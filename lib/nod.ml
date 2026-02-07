open! Core
module Std = Stdlib
module Nod_error = Nod_common.Nod_error
module Pos = Nod_common.Pos
module Token = Nod_common.Token
module Frontend = Nod_frontend
module Parser = Nod_frontend.Parser
module Lexer = Nod_frontend.Lexer
module Parser_comb = Nod_frontend.Parser_comb
module State = Nod_frontend.State
module Block = Nod_core.Block
module Call_block = Nod_core.Call_block
module Call_conv = Nod_common.Call_conv
module Cfg = Nod_core.Cfg
module Function = Nod_core.Function
module Import = Nod_core.Import
module Ir = Nod_core.Ir
module Program = Nod_core.Program
module Ssa = Nod_core.Ssa
module Typed_var = Nod_common.Typed_var
module X86_ir = Nod_ir.X86_ir
module X86_asm = Nod_x86_backend.X86_asm
module X86_backend = Nod_x86_backend.X86_backend
module X86_jit = Nod_x86_backend.Jit
module Arm64_asm = Nod_arm64_backend.Arm64_asm
module Arm64_backend = Nod_arm64_backend.Arm64_backend

type arch =
  [ `Arm64
  | `X86_64
  | `Other
  ]

let parse_arch s : arch =
  match s with
  | "x86_64" | "amd64" -> `X86_64
  | "arm64" | "aarch64" -> `Arm64
  | _ -> `Other
;;

let architecture () : arch =
  Core_unix.uname ()
  |> Core_unix.Utsname.machine
  |> String.lowercase
  |> parse_arch
;;

let only_on_arch arch f = if Poly.(architecture () = arch) then f () else ()

module Eir = struct
  include Nod_core.Eir

  let compile_parsed = Nod_core.Eir.compile

  let compile ?opt_flags program =
    Parser.parse_string program
    |> Result.bind ~f:(fun parsed -> compile_parsed ?opt_flags (Ok parsed))
  ;;
end

let compile ?opt_flags source = Eir.compile ?opt_flags source

let make_harness_source
  ?(fn_name = "root")
  ?(fn_arg_type = "void")
  ?(fn_arg = "")
  ()
  =
  [%string
    {|
#include <stdint.h>
#include <stdio.h>

extern int64_t %{fn_name}(%{fn_arg_type});

int main(void) {
  printf("%lld\n", (long long) %{fn_name}(%{fn_arg}));
  return 0;
}
|}]
;;

let harness_source = make_harness_source ()

let quote_command prog args =
  String.concat ~sep:" " (Filename.quote prog :: List.map args ~f:Filename.quote)
;;

let run_command_exn ?cwd prog args =
  let command = quote_command prog args in
  let command =
    match cwd with
    | None -> command
    | Some dir -> sprintf "cd %s && %s" (Filename.quote dir) command
  in
  match Std.Sys.command command with
  | 0 -> ()
  | code -> failwith (sprintf "command failed (%d): %s" code command)
;;

let run_shell_exn ?cwd command =
  let command =
    match cwd with
    | None -> command
    | Some dir -> sprintf "cd %s && %s" (Filename.quote dir) command
  in
  match Std.Sys.command command with
  | 0 -> ()
  | code -> failwith (sprintf "command failed (%d): %s" code command)
;;

let host_system =
  lazy
    (match
       String.lowercase (Core_unix.uname () |> Core_unix.Utsname.sysname)
     with
     | "darwin" -> `Darwin
     | "linux" -> `Linux
     | _ -> `Other)
;;

let host_arch = lazy (architecture ())

let use_qemu_arm64 =
  lazy
    (Std.Sys.command "which qemu-aarch64 > /dev/null" = 0
     || Array.find
          (Core_unix.environment ())
          ~f:(String.is_prefix ~prefix:"USE_QEMU_ARM64")
        |> Option.is_some)
;;

let compile_and_lower_functions
  ~(arch : [ `X86_64 | `Arm64 | `Other ])
  ~(system : [ `Darwin | `Linux | `Other ])
  ?(globals = [])
  functions
  =
  match arch with
  | `X86_64 -> X86_backend.compile_to_asm ~system ~globals functions
  | `Arm64 -> Arm64_backend.compile_to_asm ~system ~globals functions
  | `Other -> failwith "unsupported target architecture"
;;

type lowered_items =
  | X86 of X86_asm.program
  | Arm64 of Arm64_asm.program

let compile_and_lower_functions_to_items
  ~(arch : [ `X86_64 | `Arm64 | `Other ])
  ~(system : [ `Darwin | `Linux | `Other ])
  ?(globals = [])
  functions
  =
  if not (List.is_empty globals)
  then failwith "globals are not supported in item lowering";
  match arch with
  | `X86_64 ->
    X86_backend.compile_to_items ~system functions |> fun items -> X86 items
  | `Arm64 ->
    Arm64_backend.compile_to_items ~system functions |> fun items -> Arm64 items
  | `Other -> failwith "unsupported target architecture"
;;

let compile_and_lower
  ~(arch : [ `X86_64 | `Arm64 | `Other ])
  ~(system : [ `Darwin | `Linux | `Other ])
  ?(opt_flags = Eir.Opt_flags.no_opt)
  program
  =
  match Eir.compile ~opt_flags program with
  | Error err ->
    Or_error.error_string (Nod_error.to_string err) |> Or_error.ok_exn
  | Ok program ->
    compile_and_lower_functions
      ~arch
      ~system
      ~globals:program.Program.globals
      program.Program.functions
;;

let compile_and_lower_items
  ~(arch : [ `X86_64 | `Arm64 | `Other ])
  ~(system : [ `Darwin | `Linux | `Other ])
  ?(opt_flags = Eir.Opt_flags.no_opt)
  program
  =
  match Eir.compile ~opt_flags program with
  | Error err ->
    Or_error.error_string (Nod_error.to_string err) |> Or_error.ok_exn
  | Ok program ->
    compile_and_lower_functions_to_items
      ~arch
      ~system
      ~globals:program.Program.globals
      program.Program.functions
;;

type jit_module = X86_jit.Module.t

let compile_and_jit_x86
  ~(system : [ `Darwin | `Linux | `Other ])
  ?(opt_flags = Eir.Opt_flags.no_opt)
  ?dump_crap
  ?externals
  program
  =
  match Eir.compile ~opt_flags program with
  | Error err ->
    Or_error.error_string (Nod_error.to_string err) |> Or_error.ok_exn
  | Ok program ->
    if not (List.is_empty program.Program.globals)
    then failwith "globals are not supported in the x86 jit";
    X86_jit.compile ?dump_crap ?externals ~system program.Program.functions
;;

let qemu_aarch64_ld_prefix =
  lazy
    (let candidates =
       [ Std.Sys.getenv_opt "QEMU_AARCH64_LD_PREFIX"
       ; Some "/usr/aarch64-linux-gnu"
       ]
     in
     List.filter_opt candidates
     |> List.find ~f:(fun dir ->
       try
         match (Core_unix.stat dir).st_kind with
         | Core_unix.S_DIR -> true
         | _ -> false
       with
       | _ -> false))
;;

let execute_asm
  ~(arch : [ `X86_64 | `Arm64 | `Other ])
  ~(system : [ `Darwin | `Linux | `Other ])
  ?(harness = harness_source)
  asm
  =
  let temp_dir = Core_unix.mkdtemp "nod-exec" in
  let host_architecture = Lazy.force host_arch in
  let use_rosetta =
    Poly.(arch = `X86_64)
    && Poly.(host_architecture = `Arm64)
    && Poly.(system = `Darwin)
  in
  let compiler =
    match system with
    | `Darwin -> "clang"
    | `Linux | `Other -> "clang"
  in
  let arch_args =
    match host_architecture, arch, system with
    | `Arm64, `X86_64, `Darwin ->
      [ "-arch"; "x86_64"; "-target"; "x86_64-apple-macos11" ]
    | `Arm64, `Arm64, `Darwin ->
      [ "-arch"; "arm64"; "-target"; "arm64-apple-macos11" ]
    | `X86_64, `Arm64, `Linux when Lazy.force use_qemu_arm64 ->
      [ "--target=aarch64-linux-gnu" ]
    | _ -> []
  in
  let run_shell_runtime ?cwd command =
    match host_architecture, arch, system with
    | `Arm64, `X86_64, `Darwin when use_rosetta ->
      let command =
        quote_command "arch" [ "-x86_64"; "/bin/zsh"; "-c"; command ]
      in
      run_shell_exn ?cwd command
    | `X86_64, `Arm64, `Linux when Lazy.force use_qemu_arm64 ->
      let qemu_args =
        match Lazy.force qemu_aarch64_ld_prefix with
        | None -> []
        | Some dir -> [ "-L"; dir ]
      in
      let command =
        sprintf "%s %s" (quote_command "qemu-aarch64" qemu_args) command
      in
      run_shell_exn ?cwd command
    | _ -> run_shell_exn ?cwd command
  in
  Exn.protect
    ~f:(fun () ->
      let asm_path = Filename.concat temp_dir "program.s" in
      Out_channel.write_all asm_path ~data:asm;
      let harness_path = Filename.concat temp_dir "main.c" in
      Out_channel.write_all harness_path ~data:harness;
      (match arch, host_architecture with
       | `X86_64, `X86_64 -> ()
       | `X86_64, `Arm64 when use_rosetta -> ()
       | `Arm64, `Arm64 -> ()
       | `Arm64, `X86_64 when Lazy.force use_qemu_arm64 -> ()
       | _ -> failwith "execution is not supported on this host");
      run_shell_exn
        ~cwd:temp_dir
        (quote_command
           compiler
           ([ "-Wall"; "-Werror"; "-O0" ]
            @ arch_args
            @ [ "main.c"; "program.s"; "-o"; "program" ]));
      let output_file = "stdout.txt" in
      let output_path = Filename.concat temp_dir output_file in
      run_shell_runtime
        ~cwd:temp_dir
        (sprintf
           "%s > %s"
           (quote_command "./program" [])
           (Filename.quote output_file));
      In_channel.read_all output_path |> String.strip)
    ~finally:(fun () ->
      let _ = Std.Sys.command (quote_command "rm" [ "-rf"; temp_dir ]) in
      ())
;;

let compile_and_execute
  ~(arch : [ `X86_64 | `Arm64 | `Other ])
  ~(system : [ `Darwin | `Linux | `Other ])
  ?(harness = harness_source)
  ?(opt_flags = Eir.Opt_flags.no_opt)
  program
  =
  let asm = compile_and_lower ~arch ~system ~opt_flags program in
  execute_asm ~arch ~system ~harness asm
;;
