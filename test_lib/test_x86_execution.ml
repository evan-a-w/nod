open! Core
open! Nod

module Std = Stdlib

let harness_source =
  {|
#include <stdint.h>
#include <stdio.h>

extern int64_t root(void);

int main(void) {
  printf("%lld\n", (long long) root());
  return 0;
}
|}
;;

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

let compile_and_execute ?(opt_flags = Eir.Opt_flags.no_opt) program =
  match Eir.compile ~opt_flags program with
  | Error err ->
    Or_error.error_string (Parser.error_to_string err) |> Or_error.ok_exn
  | Ok functions ->
    let asm = X86_backend.compile_to_asm functions in
    let temp_dir = Core_unix.mkdtemp "nod-exec" in
    Exn.protect
      ~f:(fun () ->
        let asm_path = Filename.concat temp_dir "program.s" in
        Out_channel.write_all asm_path ~data:asm;
        let harness_path = Filename.concat temp_dir "main.c" in
        Out_channel.write_all harness_path ~data:harness_source;
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

let%expect_test "simple execution" =
  let output =
    compile_and_execute
      {|
mov %a, 5
mov %b, 7
add %res, %a, %b
ret %res
|}
  in
  print_endline output;
  [%expect {|12|}]
;;

let%expect_test "branch execution" =
  let output =
    compile_and_execute
      {|
mov %cond, 3
sub %cond, %cond, 3
branch %cond, nonzero, zero

nonzero:
  mov %value, 111
  ret %value

zero:
  mov %value, 42
  ret %value
|}
  in
  print_endline output;
  [%expect {|42|}]
;;
