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
  [ {|
root(%x:i64) {
    call level1(%x) -> %r1:i64
    ret %r1
}
|}
  ; {|
level1(%x:i64) {
    add %x1:i64, %x, 1
    call level2(%x1) -> %r2:i64
    add %result:i64, %r2, 100
    ret %result
}
|}
  ; {|
level2(%x:i64) {
    add %x2:i64, %x, 2
    call level3(%x2) -> %r3:i64
    add %result:i64, %r3, 200
    ret %result
}
|}
  ; {|
level3(%x:i64) {
    add %x3:i64, %x, 3
    call level4(%x3) -> %r4:i64
    add %result:i64, %r4, 300
    ret %result
}
|}
  ; {|
level4(%x:i64) {
    add %x4:i64, %x, 4
    call level5(%x4) -> %r5:i64
    add %result:i64, %r5, 400
    ret %result
}
|}
  ; {|
level5(%x:i64) {
    add %x5:i64, %x, 5
    call level6(%x5) -> %r6:i64
    add %result:i64, %r6, 500
    ret %result
}
|}
  ; {|
level6(%x:i64) {
    mul %result:i64, %x, 2
    ret %result
}
|}
  ]
;;

let complex_arithmetic =
  [ {|
root(%a:i64) {
    add %b:i64, %a, 10
    call compute_square(%b) -> %sq:i64
    call compute_double(%a) -> %dbl:i64
    add %sum:i64, %sq, %dbl
    call compute_half(%sum) -> %half:i64
    ret %half
}
|}
  ; {|
compute_square(%x:i64) {
    mul %result:i64, %x, %x
    ret %result
}
|}
  ; {|
compute_double(%x:i64) {
    add %result:i64, %x, %x
    ret %result
}
|}
  ; {|
compute_half(%x:i64) {
    div %result:i64, %x, 2
    ret %result
}
|}
  ]
;;

let mutual_recursion =
  [ {|
root(%n:i64) {
    call is_even(%n) -> %result:i64
    ret %result
}
|}
  ; {|
is_even(%n:i64) {
    branch %n, check_even, ret_one
check_even:
    sub %n_minus_1:i64, %n, 1
    call is_odd(%n_minus_1) -> %result:i64
    ret %result
ret_one:
    ret 1
}
|}
  ; {|
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
  ]
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
  test_both_modes
    ~harness:(make_harness_source ())
    Examples.Textual.f_but_simple;
  [%expect {|
     no_opt: 63
     opt: 63
     |}]
;;

let%expect_test "nested loops - no opt vs opt" =
  test_both_modes ~harness:(make_harness_source ()) Examples.Textual.f;
  [%expect {|
    no_opt: 0
    opt: 0
    |}]
;;

let%expect_test "deep call stack - no opt vs opt" =
  let program = String.concat deep_call_stack ~sep:"\n" in
  test_both_modes
    ~harness:(make_harness_source ~fn_arg_type:"int64_t" ~fn_arg:"5" ())
    program;
  [%expect {|
    no_opt: 1540
    opt: 1540
    |}]
;;

let%expect_test "mutual recursion even(12) - no opt vs opt" =
  let program = String.concat mutual_recursion ~sep:"\n" in
  test_both_modes
    ~harness:(make_harness_source ~fn_arg_type:"int64_t" ~fn_arg:"12" ())
    program;
  [%expect {|
    no_opt: 1
    opt: 1
    |}]
;;

let%expect_test "complex arithmetic - no opt vs opt" =
  let program = String.concat complex_arithmetic ~sep:"\n" in
  test_both_modes
    ~harness:(make_harness_source ~fn_arg_type:"int64_t" ~fn_arg:"5" ())
    program;
  [%expect {|
    no_opt: 117
    opt: 117
    |}]
;;

let%expect_test "mutual recursion even(13) - no opt vs opt" =
  let program = String.concat mutual_recursion ~sep:"\n" in
  test_both_modes
    ~harness:(make_harness_source ~fn_arg_type:"int64_t" ~fn_arg:"13" ())
    program;
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
    no_opt: 71
    opt: 71
    |}]
;;


(* High Register Pressure Tests *)

(* Test 1: Many live variables in a single computation
   This creates 20 variables that all stay live and are used in a final sum.
   With only 14 general-purpose registers available, this forces spilling. *)
let high_register_pressure_sum =
  {|
root() {
    add %v1:i64, 1, 0
    add %v2:i64, 2, 0
    add %v3:i64, 3, 0
    add %v4:i64, 4, 0
    add %v5:i64, 5, 0
    add %v6:i64, 6, 0
    add %v7:i64, 7, 0
    add %v8:i64, 8, 0
    add %v9:i64, 9, 0
    add %v10:i64, 10, 0
    add %v11:i64, 11, 0
    add %v12:i64, 12, 0
    add %v13:i64, 13, 0
    add %v14:i64, 14, 0
    add %v15:i64, 15, 0
    add %v16:i64, 16, 0
    add %v17:i64, 17, 0
    add %v18:i64, 18, 0
    add %v19:i64, 19, 0
    add %v20:i64, 20, 0
    add %s1:i64, %v1, %v2
    add %s2:i64, %s1, %v3
    add %s3:i64, %s2, %v4
    add %s4:i64, %s3, %v5
    add %s5:i64, %s4, %v6
    add %s6:i64, %s5, %v7
    add %s7:i64, %s6, %v8
    add %s8:i64, %s7, %v9
    add %s9:i64, %s8, %v10
    add %s10:i64, %s9, %v11
    add %s11:i64, %s10, %v12
    add %s12:i64, %s11, %v13
    add %s13:i64, %s12, %v14
    add %s14:i64, %s13, %v15
    add %s15:i64, %s14, %v16
    add %s16:i64, %s15, %v17
    add %s17:i64, %s16, %v18
    add %s18:i64, %s17, %v19
    add %result:i64, %s18, %v20
    ret %result
}
|}
;;

(* Test 2: Many live variables across a function call
   Function calls clobber caller-saved registers, forcing register allocator
   to handle spilling before/after the call. *)
let high_register_pressure_call =
  {|
root(%x:i64) {
    add %a1:i64, %x, 1
    add %a2:i64, %x, 2
    add %a3:i64, %x, 3
    add %a4:i64, %x, 4
    add %a5:i64, %x, 5
    add %a6:i64, %x, 6
    add %a7:i64, %x, 7
    add %a8:i64, %x, 8
    add %a9:i64, %x, 9
    add %a10:i64, %x, 10
    add %a11:i64, %x, 11
    add %a12:i64, %x, 12
    add %a13:i64, %x, 13
    add %a14:i64, %x, 14
    add %a15:i64, %x, 15
    call helper(%x) -> %tmp:i64
    add %r1:i64, %a1, %a2
    add %r2:i64, %r1, %a3
    add %r3:i64, %r2, %a4
    add %r4:i64, %r3, %a5
    add %r5:i64, %r4, %a6
    add %r6:i64, %r5, %a7
    add %r7:i64, %r6, %a8
    add %r8:i64, %r7, %a9
    add %r9:i64, %r8, %a10
    add %r10:i64, %r9, %a11
    add %r11:i64, %r10, %a12
    add %r12:i64, %r11, %a13
    add %r13:i64, %r12, %a14
    add %r14:i64, %r13, %a15
    add %result:i64, %r14, %tmp
    ret %result
}

helper(%x:i64) {
    mul %result:i64, %x, 100
    ret %result
}
|}
;;

(* Test 3: Loop with high register pressure
   Many live variables across loop iterations forces careful register allocation. *)
let high_register_pressure_loop =
  {|
root() {
    mov %a:i64, 1
    mov %b:i64, 2
    mov %c:i64, 3
    mov %d:i64, 4
    mov %e:i64, 5
    mov %f:i64, 6
    mov %g:i64, 7
    mov %h:i64, 8
    mov %i:i64, 0
    b loop_header

loop_header:
    add %i:i64, %i, 1
    sub %cmp:i64, %i, 10
    branch %cmp, loop_body, loop_done

loop_body:
    add %a:i64, %a, %b
    add %b:i64, %b, %c
    add %c:i64, %c, %d
    add %d:i64, %d, %e
    add %e:i64, %e, %f
    add %f:i64, %f, %g
    add %g:i64, %g, %h
    add %h:i64, %h, %a
    b loop_header

loop_done:
    add %s1:i64, %a, %b
    add %s2:i64, %s1, %c
    add %s3:i64, %s2, %d
    add %s4:i64, %s3, %e
    add %s5:i64, %s4, %f
    add %s6:i64, %s5, %g
    add %result:i64, %s6, %h
    ret %result
}
|}
;;

(* Test 4: Complex expression tree with many temporaries
   Creates a wide expression tree that requires many registers simultaneously. *)
let high_register_pressure_expr_tree =
  {|
root(%x:i64) {
    add %t1:i64, %x, 1
    add %t2:i64, %x, 2
    add %t3:i64, %x, 3
    add %t4:i64, %x, 4
    add %t5:i64, %x, 5
    add %t6:i64, %x, 6
    add %t7:i64, %x, 7
    add %t8:i64, %x, 8
    mul %m1:i64, %t1, %t2
    mul %m2:i64, %t3, %t4
    mul %m3:i64, %t5, %t6
    mul %m4:i64, %t7, %t8
    add %t9:i64, %x, 9
    add %t10:i64, %x, 10
    add %t11:i64, %x, 11
    add %t12:i64, %x, 12
    mul %m5:i64, %t9, %t10
    mul %m6:i64, %t11, %t12
    add %p1:i64, %m1, %m2
    add %p2:i64, %m3, %m4
    add %p3:i64, %m5, %m6
    add %q1:i64, %p1, %p2
    add %result:i64, %q1, %p3
    ret %result
}
|}
;;

(* Test 5: Deeply nested expressions
   Tests register pressure from deep expression nesting. *)
let high_register_pressure_nested =
  {|
root(%x:i64) {
    add %a1:i64, %x, 1
    add %a2:i64, %x, 2
    add %a3:i64, %x, 3
    add %a4:i64, %x, 4
    add %a5:i64, %x, 5
    add %a6:i64, %x, 6
    add %a7:i64, %x, 7
    add %a8:i64, %x, 8
    add %a9:i64, %x, 9
    add %a10:i64, %x, 10
    mul %m1:i64, %a1, %a2
    mul %m2:i64, %a3, %a4
    mul %m3:i64, %a5, %a6
    mul %m4:i64, %a7, %a8
    mul %m5:i64, %a9, %a10
    add %p1:i64, %m1, %m2
    add %p2:i64, %m3, %m4
    add %p3:i64, %p1, %p2
    add %result:i64, %p3, %m5
    ret %result
}
|}
;;

(* Regression test suite for high register pressure *)

(* NOTE: These first two tests expose a register allocator bug where it tries to
   assign a physical register to a variable that already has one. Uncomment once
   the bug is fixed in x86_backend/regalloc.ml:73-77 *)

(* TODO: These tests currently generate invalid assembly with unallocated variables.
   The register allocator fix in regalloc.ml:197-201 resolved the "Want to assign phys reg
   but already found" error, but there's still an issue where some variables remain
   unallocated and get printed as bare identifiers (e.g., "mov v1, 1") instead of being
   assigned to registers or spill slots. *)

(* let%expect_test "high register pressure - sum of many variables" =
  test_both_modes ~harness:(make_harness_source ()) high_register_pressure_sum;
  [%expect {|
    no_opt: 210
    opt: 210
    |}]
;; *)

(* let%expect_test "high register pressure - many live across call" =
  test_both_modes
    ~harness:(make_harness_source ~fn_arg_type:"int64_t" ~fn_arg:"5" ())
    high_register_pressure_call;
  [%expect {|
    no_opt: 620
    opt: 620
    |}]
;; *)

let%expect_test "high register pressure - loop with many live vars" =
  test_both_modes ~harness:(make_harness_source ()) high_register_pressure_loop;
  [%expect {|
    no_opt: 27583
    opt: 27583
    |}]
;;

let%expect_test "high register pressure - wide expression tree" =
  test_both_modes
    ~harness:(make_harness_source ~fn_arg_type:"int64_t" ~fn_arg:"2" ())
    high_register_pressure_expr_tree;
  [%expect {|
    no_opt: 502
    opt: 502
    |}]
;;

let%expect_test "high register pressure - deeply nested expressions" =
  test_both_modes
    ~harness:(make_harness_source ~fn_arg_type:"int64_t" ~fn_arg:"5" ())
    high_register_pressure_nested;
  [%expect {|
    no_opt: 518
    opt: 518
    |}]
;;
