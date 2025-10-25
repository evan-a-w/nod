open! Core
open! Import
module Std = Stdlib

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

let%expect_test "simple execution" =
  let output =
    compile_and_execute {|
mov %a:i64, 5
mov %b:i64, 7
add %res:i64, %a, %b
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
mov %cond:i64, 3
sub %cond:i64, %cond, 3
branch %cond, nonzero, zero

nonzero:
  mov %value:i64, 111
  ret %value

zero:
  mov %value:i64, 42
  ret %value
|}
  in
  print_endline output;
  [%expect {|42|}]
;;

let%expect_test "recursive fib" =
  let output =
    compile_and_execute
      ~harness:
        (make_harness_source
           ~fn_name:"fib"
           ~fn_arg_type:"int64_t"
           ~fn_arg:"6"
           ())
      Examples.Textual.fib_recursive
  in
  print_endline output;
  [%expect {| 13 |}]
;;

(* Pointer arithmetic tests *)

let%expect_test "basic pointer arithmetic - adding offset" =
  let output =
    compile_and_execute
      {|
alloca %base:ptr, 64
mov %offset:i64, 8
add %ptr:ptr, %base, %offset
sub %result:i64, %ptr, %base
ret %result
|}
  in
  print_endline output;
  [%expect {| 8 |}]
;;

let%expect_test "pointer arithmetic - array indexing" =
  let output =
    compile_and_execute
      {|
alloca %array:ptr, 80
mov %idx:i64, 3
mul %byte_offset:i64, %idx, 8
add %element_ptr:ptr, %array, %byte_offset
sub %result:i64, %element_ptr, %array
ret %result
|}
  in
  print_endline output;
  [%expect {| 24 |}]
;;

let%expect_test "pointer arithmetic - multiple operations" =
  let output =
    compile_and_execute
      {|
alloca %buf:ptr, 100
add %p1:ptr, %buf, 10
add %p2:ptr, %p1, 15
add %p3:ptr, %p2, 5
sub %total_offset:i64, %p3, %buf
ret %total_offset
|}
  in
  print_endline output;
  [%expect {| 30 |}]
;;

let%expect_test "pointer arithmetic in loop" =
  let output =
    compile_and_execute
      {|
alloca %array:ptr, 80
mov %i:i64, 0
mov %sum:i64, 0

loop:
  mul %offset:i64, %i, 8
  add %ptr:ptr, %array, %offset
  add %sum:i64, %sum, %i
  add %i:i64, %i, 1
  sub %cond:i64, %i, 10
  branch %cond, loop, done

done:
  ret %sum
|}
  in
  print_endline output;
  [%expect {| 45 |}]
;;

let%expect_test "pointer arithmetic - subtracting from pointer" =
  let output =
    compile_and_execute
      {|
alloca %buf:ptr, 100
add %end:ptr, %buf, 50
sub %middle:ptr, %end, 25
sub %result:i64, %middle, %buf
ret %result
|}
  in
  print_endline output;
  [%expect {| 25 |}]
;;

let%expect_test "pointer arithmetic - complex calculation" =
  let output =
    compile_and_execute
      {|
alloca %data:ptr, 200
mov %base_idx:i64, 5
mul %base_offset:i64, %base_idx, 8
add %base_ptr:ptr, %data, %base_offset
mov %extra:i64, 3
mul %extra_offset:i64, %extra, 8
add %final_ptr:ptr, %base_ptr, %extra_offset
sub %total:i64, %final_ptr, %data
ret %total
|}
  in
  print_endline output;
  [%expect {| 64 |}]
;;

let%expect_test "alloca with dynamic size" =
  let output =
    compile_and_execute
      {|
mov %size:i64, 32
alloca %buf:ptr, %size
add %end:ptr, %buf, %size
sub %actual_size:i64, %end, %buf
ret %actual_size
|}
  in
  print_endline output;
  [%expect {| 32 |}]
;;

let%expect_test "nested pointer arithmetic" =
  let output =
    compile_and_execute
      {|
alloca %outer:ptr, 128
mov %outer_idx:i64, 2
mul %outer_off:i64, %outer_idx, 16
add %inner_base:ptr, %outer, %outer_off
mov %inner_idx:i64, 3
mul %inner_off:i64, %inner_idx, 8
add %element:ptr, %inner_base, %inner_off
sub %total_off:i64, %element, %outer
ret %total_off
|}
  in
  print_endline output;
  [%expect {| 56 |}]
;;

let%expect_test "pointer arithmetic with mixed operations" =
  let output =
    compile_and_execute
      {|
alloca %arr:ptr, 100
mov %a:i64, 10
mov %b:i64, 20
add %sum:i64, %a, %b
add %ptr1:ptr, %arr, %sum
sub %diff:i64, %b, %a
sub %ptr2:ptr, %ptr1, %diff
sub %result:i64, %ptr2, %arr
ret %result
|}
  in
  print_endline output;
  [%expect {| 20 |}]
;;

let%expect_test "pointer arithmetic - boundary calculation" =
  let output =
    compile_and_execute
      {|
mov %size:i64, 64
alloca %buffer:ptr, %size
add %ptr:ptr, %buffer, 0
sub %at_start:i64, %ptr, %buffer
add %end:ptr, %buffer, %size
sub %range:i64, %end, %buffer
mul %result:i64, %at_start, 100
add %result:i64, %result, %range
ret %result
|}
  in
  print_endline output;
  [%expect {| 64 |}]
;;
