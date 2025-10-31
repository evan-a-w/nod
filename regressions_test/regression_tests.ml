open! Core
open! Import
module Std = Stdlib

(* Harness utilities copied from test_x86_execution *)

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

(* Helper to test both with and without optimizations *)
let test_both_modes ~harness program =
  let no_opt_result =
    compile_and_execute ~harness ~opt_flags:Eir.Opt_flags.no_opt program
  in
  print_endline ("no_opt: " ^ no_opt_result);
  let opt_result =
    compile_and_execute ~harness ~opt_flags:Eir.Opt_flags.default program
  in
  print_endline ("opt: " ^ opt_result)
;;

(* Test Programs *)

let factorial_recursive =
  {|
factorial(%n:i64) {
    branch %n, check_one, ret_one
check_one:
    sub %n_minus_1:i64, %n, 1
    branch %n_minus_1, recurse, ret_one
ret_one:
    ret 1
recurse:
    call factorial(%n_minus_1) -> %sub_result:i64
    mul %result:i64, %n, %sub_result
    ret %result
}
|}
;;

let deep_call_stack =
  {|
root(%x:i64) {
    call level1(%x) -> %r1:i64
    ret %r1
}

level1(%x:i64) {
    add %x1:i64, %x, 1
    call level2(%x1) -> %r2:i64
    add %result:i64, %r2, 100
    ret %result
}

level2(%x:i64) {
    add %x2:i64, %x, 2
    call level3(%x2) -> %r3:i64
    add %result:i64, %r3, 200
    ret %result
}

level3(%x:i64) {
    add %x3:i64, %x, 3
    call level4(%x3) -> %r4:i64
    add %result:i64, %r4, 300
    ret %result
}

level4(%x:i64) {
    add %x4:i64, %x, 4
    call level5(%x4) -> %r5:i64
    add %result:i64, %r5, 400
    ret %result
}

level5(%x:i64) {
    add %x5:i64, %x, 5
    call level6(%x5) -> %r6:i64
    add %result:i64, %r6, 500
    ret %result
}

level6(%x:i64) {
    mul %result:i64, %x, 2
    ret %result
}
|}
;;

let complex_arithmetic =
  {|
root(%a:i64) {
    add %b:i64, %a, 10
    call compute_square(%b) -> %sq:i64
    call compute_double(%a) -> %dbl:i64
    add %sum:i64, %sq, %dbl
    call compute_half(%sum) -> %half:i64
    ret %half
}

compute_square(%x:i64) {
    mul %result:i64, %x, %x
    ret %result
}

compute_double(%x:i64) {
    add %result:i64, %x, %x
    ret %result
}

compute_half(%x:i64) {
    div %result:i64, %x, 2
    ret %result
}
|}
;;

let mutual_recursion =
  {|
root(%n:i64) {
    call is_even(%n) -> %result:i64
    ret %result
}

is_even(%n:i64) {
    branch %n, check_even, ret_one
check_even:
    sub %n_minus_1:i64, %n, 1
    call is_odd(%n_minus_1) -> %result:i64
    ret %result
ret_one:
    ret 1
}

is_odd(%n:i64) {
    branch %n, check_odd, ret_zero
check_odd:
    sub %n_minus_1:i64, %n, 1
    call is_even(%n_minus_1) -> %result:i64
    ret %result
ret_zero:
    ret 0
}
|}
;;

(* Regression Tests *)

let%expect_test "factorial 5 - no opt vs opt" =
  test_both_modes
    ~harness:
      (make_harness_source
         ~fn_name:"factorial"
         ~fn_arg_type:"int64_t"
         ~fn_arg:"5"
         ())
    factorial_recursive;
  [%expect {|
    no_opt: 120
    opt: 120
    |}]
;;

let%expect_test "factorial 7 - no opt vs opt" =
  test_both_modes
    ~harness:
      (make_harness_source
         ~fn_name:"factorial"
         ~fn_arg_type:"int64_t"
         ~fn_arg:"7"
         ())
    factorial_recursive;
  [%expect {|
    no_opt: 5040
    opt: 5040
    |}]
;;

let%expect_test "fibonacci 10 - no opt vs opt" =
  test_both_modes
    ~harness:
      (make_harness_source
         ~fn_name:"fib"
         ~fn_arg_type:"int64_t"
         ~fn_arg:"10"
         ())
    Examples.Textual.fib_recursive;
  [%expect {|
    no_opt: 89
    opt: 89
    |}]
;;

 let%expect_test "sum 1 to 100 - no opt vs opt" = 
   test_both_modes ~harness:(make_harness_source ()) Examples.Textual.sum_100; 
   [%expect {| 
          no_opt: 4950 
          opt: 4950 
          |}] 
 ;; 

 let%expect_test "nested loops simpler - no opt vs opt" = 
   test_both_modes ~harness:(make_harness_source ()) Examples.Textual.f_but_simple; 
   [%expect {|
     no_opt: 63
     opt: 63
     |}] 
 ;; 


 (*
 let%expect_test "nested loops - no opt vs opt" = 
   test_both_modes ~harness:(make_harness_source ()) Examples.Textual.f; 
   [%expect {|
     no_opt: 0
     opt: 0
     |}] 
 ;; 

 let%expect_test "deep call stack - no opt vs opt" = 
   test_both_modes 
     ~harness:(make_harness_source ~fn_arg_type:"int64_t" ~fn_arg:"5" ()) 
     deep_call_stack; 
   [%expect {| 
     no_opt: 1530 
     opt: 1530 
     |}] 
 ;; 

 let%expect_test "mutual recursion even(12) - no opt vs opt" = 
   test_both_modes 
     ~harness:(make_harness_source ~fn_arg_type:"int64_t" ~fn_arg:"12" ()) 
     mutual_recursion; 
   [%expect {| 
     no_opt: 1 
     opt: 1 
     |}] 
 ;; 


 let%expect_test "complex arithmetic - no opt vs opt" = 
   test_both_modes 
     ~harness:(make_harness_source ~fn_arg_type:"int64_t" ~fn_arg:"5" ()) 
     complex_arithmetic; 
   [%expect {| 
     no_opt: 115 
     opt: 115 
     |}] 
 ;; 

 let%expect_test "mutual recursion even(13) - no opt vs opt" = 
   test_both_modes 
     ~harness:(make_harness_source ~fn_arg_type:"int64_t" ~fn_arg:"13" ()) 
     mutual_recursion; 
   [%expect {| 
     no_opt: 0 
     opt: 0 
     |}] 
 ;; 

 let%expect_test "call chains - no opt vs opt" = 
   let program = String.concat Examples.Textual.call_chains ~sep:"\n" in 
   test_both_modes 
     ~harness:(make_harness_source ~fn_arg_type:"int64_t" ~fn_arg:"10" ()) 
     program; 
   [%expect {| 
     no_opt: 46 
     opt: 46 
     |}] 
 ;; 
 *)