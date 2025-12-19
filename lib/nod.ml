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
module Call_conv = Nod_core.Call_conv
module Cfg = Nod_core.Cfg
module Clobbers = Nod_core.Clobbers
module Function = Nod_core.Function
module Function0 = Nod_core.Function0
module Import = Nod_core.Import
module Ir = Nod_core.Ir
module Ir0 = Nod_core.Ir0
module Ssa = Nod_core.Ssa
module Var = Nod_core.Var
module X86_ir = Nod_core.X86_ir
module X86_backend = Nod_x86_backend.X86_backend
module Examples = Nod_examples.Examples

let architecture () : [ `Arm64 | `X86_64 | `Other ] =
  match Core_unix.uname () |> Core_unix.Utsname.machine |> String.lowercase with
  | "x86_64" | "amd64" -> `X86_64
  | "arm64" | "aarch64" -> `Arm64
  | _ -> `Other
;;

let only_on_arch arch f =
  if Poly.(architecture () = arch) then f () else ()
;;

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

let compile_and_execute
  ?(arch = `X86_64)
  ?(harness = harness_source)
  ?(opt_flags = Eir.Opt_flags.no_opt)
  program
  =
  match Eir.compile ~opt_flags program with
  | Error err ->
    Or_error.error_string (Nod_error.to_string err) |> Or_error.ok_exn
  | Ok functions ->
    let asm = X86_backend.compile_to_asm functions in
    let temp_dir = Core_unix.mkdtemp "nod-exec" in
    let host_arch = architecture () in
    let host_sysname =
      String.lowercase (Core_unix.uname () |> Core_unix.Utsname.sysname)
    in
    let needs_x86 = Poly.(arch = `X86_64) in
    let use_rosetta =
      needs_x86 && Poly.(host_arch = `Arm64) && String.equal host_sysname "darwin"
    in
    let compiler =
      match host_sysname with
      | "darwin" -> "clang"
      | _ -> "gcc"
    in
    let arch_args =
      match arch, host_sysname with
      | `X86_64, "darwin" -> [ "-arch"; "x86_64"; "-target"; "x86_64-apple-macos11" ]
      | _ -> []
    in
    let run_shell_runtime ?cwd command =
      if use_rosetta then
        let command =
          quote_command "arch" [ "-x86_64"; "/bin/zsh"; "-c"; command ]
        in
        run_shell_exn ?cwd command
      else
        run_shell_exn ?cwd command
    in
    Exn.protect
      ~f:(fun () ->
        let asm_path = Filename.concat temp_dir "program.s" in
        Out_channel.write_all asm_path ~data:asm;
        let harness_path = Filename.concat temp_dir "main.c" in
        Out_channel.write_all harness_path ~data:harness;
        (match needs_x86, host_arch with
         | true, _ when Poly.(host_arch <> `X86_64) && not use_rosetta ->
           failwith "x86_64 execution is not supported on this host"
         | _ -> ());
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
