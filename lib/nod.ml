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
module Omm_cst = Nod_frontend.Omm_cst
module Omm_parser = Nod_frontend.Omm_parser
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
    Exn.protect
      ~f:(fun () ->
        let asm_path = Filename.concat temp_dir "program.s" in
        Out_channel.write_all asm_path ~data:asm;
        let harness_path = Filename.concat temp_dir "main.c" in
        Out_channel.write_all harness_path ~data:harness;
        run_command_exn
          ~cwd:temp_dir
          "gcc"
          [ "-Wall"; "-Werror"; "-O0"; "main.c"; "program.s"; "-o"; "program" ];
        let output_file = "stdout.txt" in
        let output_path = Filename.concat temp_dir output_file in
        run_shell_exn
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
