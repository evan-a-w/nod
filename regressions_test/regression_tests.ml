open! Core
open! Import

let test_both_modes ~harness program =
  let ensure_same_output result_ref arch mode_label ~opt_flags =
    let output = compile_and_execute_on_arch arch ~harness ~opt_flags program in
    match !result_ref with
    | None -> result_ref := Some output
    | Some expected when String.equal expected output -> ()
    | Some expected ->
      failwithf
        "arch %s (%s) produced %s, expected %s"
        (arch_to_string arch)
        mode_label
        output
        expected
        ()
  in
  let no_opt_result = ref None in
  let opt_result = ref None in
  List.iter test_architectures ~f:(fun arch ->
    ensure_same_output
      no_opt_result
      arch
      "no_opt"
      ~opt_flags:Eir.Opt_flags.no_opt;
    ensure_same_output opt_result arch "opt" ~opt_flags:Eir.Opt_flags.default);
  match !no_opt_result, !opt_result with
  | Some no_opt, Some opt -> no_opt, opt
  | _ -> failwith "no supported architectures available for regressions"
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
  let no_opt_result, opt_result =
    test_both_modes
      ~harness:
        (make_harness_source
           ~fn_name:"factorial"
           ~fn_arg_type:"int64_t"
           ~fn_arg:"5"
           ())
      factorial_recursive
  in
  assert (String.equal no_opt_result "120");
  assert (String.equal opt_result "120")
;;

let%expect_test "factorial 7 - no opt vs opt" =
  let no_opt_result, opt_result =
    test_both_modes
      ~harness:
        (make_harness_source
           ~fn_name:"factorial"
           ~fn_arg_type:"int64_t"
           ~fn_arg:"7"
           ())
      factorial_recursive
  in
  assert (String.equal no_opt_result "5040");
  assert (String.equal opt_result "5040")
;;

let%expect_test "fibonacci 10 - no opt vs opt" =
  let no_opt_result, opt_result =
    test_both_modes
      ~harness:
        (make_harness_source
           ~fn_name:"fib"
           ~fn_arg_type:"int64_t"
           ~fn_arg:"10"
           ())
      Examples.Textual.fib_recursive
  in
  assert (String.equal no_opt_result "89");
  assert (String.equal opt_result "89")
;;

let%expect_test "sum 1 to 100 - no opt vs opt" =
  let no_opt_result, opt_result =
    test_both_modes ~harness:(make_harness_source ()) Examples.Textual.sum_100
  in
  assert (String.equal no_opt_result "4950");
  assert (String.equal opt_result "4950")
;;

let%expect_test "nested loops simpler - no opt vs opt" =
  let no_opt_result, opt_result =
    test_both_modes
      ~harness:(make_harness_source ())
      Examples.Textual.f_but_simple
  in
  assert (String.equal no_opt_result "63");
  assert (String.equal opt_result "63")
;;

let%expect_test "nested loops - no opt vs opt" =
  let no_opt_result, opt_result =
    test_both_modes ~harness:(make_harness_source ()) Examples.Textual.f
  in
  assert (String.equal no_opt_result "0");
  assert (String.equal opt_result "0")
;;

let%expect_test "deep call stack - no opt vs opt" =
  let program = String.concat deep_call_stack ~sep:"\n" in
  let no_opt_result, opt_result =
    test_both_modes
      ~harness:(make_harness_source ~fn_arg_type:"int64_t" ~fn_arg:"5" ())
      program
  in
  assert (String.equal no_opt_result "1540");
  assert (String.equal opt_result "1540")
;;

let%expect_test "mutual recursion even(12) - no opt vs opt" =
  let program = String.concat mutual_recursion ~sep:"\n" in
  let no_opt_result, opt_result =
    test_both_modes
      ~harness:(make_harness_source ~fn_arg_type:"int64_t" ~fn_arg:"12" ())
      program
  in
  assert (String.equal no_opt_result "1");
  assert (String.equal opt_result "1")
;;

let%expect_test "complex arithmetic - no opt vs opt" =
  let program = String.concat complex_arithmetic ~sep:"\n" in
  let no_opt_result, opt_result =
    test_both_modes
      ~harness:(make_harness_source ~fn_arg_type:"int64_t" ~fn_arg:"5" ())
      program
  in
  assert (String.equal no_opt_result "117");
  assert (String.equal opt_result "117")
;;

let%expect_test "mutual recursion even(13) - no opt vs opt" =
  let program = String.concat mutual_recursion ~sep:"\n" in
  let no_opt_result, opt_result =
    test_both_modes
      ~harness:(make_harness_source ~fn_arg_type:"int64_t" ~fn_arg:"13" ())
      program
  in
  assert (String.equal no_opt_result "0");
  assert (String.equal opt_result "0")
;;

let%expect_test "call chains - no opt vs opt" =
  let program = String.concat Examples.Textual.call_chains ~sep:"\n" in
  let no_opt_result, opt_result =
    test_both_modes
      ~harness:(make_harness_source ~fn_arg_type:"int64_t" ~fn_arg:"10" ())
      program
  in
  assert (String.equal no_opt_result "71");
  assert (String.equal opt_result "71")
;;

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

let high_register_pressure_over_32_live =
  {|
root() {
    (* 40 base values (all kept live until the very end) *)
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
    add %v21:i64, 21, 0
    add %v22:i64, 22, 0
    add %v23:i64, 23, 0
    add %v24:i64, 24, 0
    add %v25:i64, 25, 0
    add %v26:i64, 26, 0
    add %v27:i64, 27, 0
    add %v28:i64, 28, 0
    add %v29:i64, 29, 0
    add %v30:i64, 30, 0
    add %v31:i64, 31, 0
    add %v32:i64, 32, 0
    add %v33:i64, 33, 0
    add %v34:i64, 34, 0
    add %v35:i64, 35, 0
    add %v36:i64, 36, 0
    add %v37:i64, 37, 0
    add %v38:i64, 38, 0
    add %v39:i64, 39, 0
    add %v40:i64, 40, 0

    (* 20 a-intermediates (also kept live until the end) *)
    add %a1:i64, %v1, %v2
    add %a2:i64, %v3, %v4
    add %a3:i64, %v5, %v6
    add %a4:i64, %v7, %v8
    add %a5:i64, %v9, %v10
    add %a6:i64, %v11, %v12
    add %a7:i64, %v13, %v14
    add %a8:i64, %v15, %v16
    add %a9:i64, %v17, %v18
    add %a10:i64, %v19, %v20
    add %a11:i64, %v21, %v22
    add %a12:i64, %v23, %v24
    add %a13:i64, %v25, %v26
    add %a14:i64, %v27, %v28
    add %a15:i64, %v29, %v30
    add %a16:i64, %v31, %v32
    add %a17:i64, %v33, %v34
    add %a18:i64, %v35, %v36
    add %a19:i64, %v37, %v38
    add %a20:i64, %v39, %v40

    (* 10 b-intermediates (still not consuming anything “for real” yet)
       a's are used here BUT also used later, so they remain live *)
    add %b1:i64, %a1, %a2
    add %b2:i64, %a3, %a4
    add %b3:i64, %a5, %a6
    add %b4:i64, %a7, %a8
    add %b5:i64, %a9, %a10
    add %b6:i64, %a11, %a12
    add %b7:i64, %a13, %a14
    add %b8:i64, %a15, %a16
    add %b9:i64, %a17, %a18
    add %b10:i64, %a19, %a20

    (* Final reduction: use EVERYTHING again so v*, a*, b* were all live up to here. *)
    add %s0:i64, 0, 0

    add %s1:i64, %s0, %v1
    add %s2:i64, %s1, %v2
    add %s3:i64, %s2, %v3
    add %s4:i64, %s3, %v4
    add %s5:i64, %s4, %v5
    add %s6:i64, %s5, %v6
    add %s7:i64, %s6, %v7
    add %s8:i64, %s7, %v8
    add %s9:i64, %s8, %v9
    add %s10:i64, %s9, %v10
    add %s11:i64, %s10, %v11
    add %s12:i64, %s11, %v12
    add %s13:i64, %s12, %v13
    add %s14:i64, %s13, %v14
    add %s15:i64, %s14, %v15
    add %s16:i64, %s15, %v16
    add %s17:i64, %s16, %v17
    add %s18:i64, %s17, %v18
    add %s19:i64, %s18, %v19
    add %s20:i64, %s19, %v20
    add %s21:i64, %s20, %v21
    add %s22:i64, %s21, %v22
    add %s23:i64, %s22, %v23
    add %s24:i64, %s23, %v24
    add %s25:i64, %s24, %v25
    add %s26:i64, %s25, %v26
    add %s27:i64, %s26, %v27
    add %s28:i64, %s27, %v28
    add %s29:i64, %s28, %v29
    add %s30:i64, %s29, %v30
    add %s31:i64, %s30, %v31
    add %s32:i64, %s31, %v32
    add %s33:i64, %s32, %v33
    add %s34:i64, %s33, %v34
    add %s35:i64, %s34, %v35
    add %s36:i64, %s35, %v36
    add %s37:i64, %s36, %v37
    add %s38:i64, %s37, %v38
    add %s39:i64, %s38, %v39
    add %s40:i64, %s39, %v40

    add %s41:i64, %s40, %a1
    add %s42:i64, %s41, %a2
    add %s43:i64, %s42, %a3
    add %s44:i64, %s43, %a4
    add %s45:i64, %s44, %a5
    add %s46:i64, %s45, %a6
    add %s47:i64, %s46, %a7
    add %s48:i64, %s47, %a8
    add %s49:i64, %s48, %a9
    add %s50:i64, %s49, %a10
    add %s51:i64, %s50, %a11
    add %s52:i64, %s51, %a12
    add %s53:i64, %s52, %a13
    add %s54:i64, %s53, %a14
    add %s55:i64, %s54, %a15
    add %s56:i64, %s55, %a16
    add %s57:i64, %s56, %a17
    add %s58:i64, %s57, %a18
    add %s59:i64, %s58, %a19
    add %s60:i64, %s59, %a20

    add %s61:i64, %s60, %b1
    add %s62:i64, %s61, %b2
    add %s63:i64, %s62, %b3
    add %s64:i64, %s63, %b4
    add %s65:i64, %s64, %b5
    add %s66:i64, %s65, %b6
    add %s67:i64, %s66, %b7
    add %s68:i64, %s67, %b8
    add %s69:i64, %s68, %b9
    add %result:i64, %s69, %b10
    ret %result
}
|}
;;

let%expect_test "high register pressure - sum of many variables" =
  let no_opt_result, opt_result =
    test_both_modes ~harness:(make_harness_source ()) high_register_pressure_sum
  in
  assert (String.equal no_opt_result "210");
  assert (String.equal opt_result "210")
;;

let%expect_test "high register pressure - sum of many variables, but even more" =
  let no_opt_result, opt_result =
    test_both_modes
      ~harness:(make_harness_source ())
      high_register_pressure_over_32_live
  in
  assert (String.equal no_opt_result "2460");
  assert (String.equal opt_result "2460")
;;

let%expect_test "high register pressure - many live across call" =
  let no_opt_result, opt_result =
    test_both_modes
      ~harness:(make_harness_source ~fn_arg_type:"int64_t" ~fn_arg:"5" ())
      high_register_pressure_call
  in
  assert (String.equal no_opt_result "695");
  assert (String.equal opt_result "695")
;;

let%expect_test "high register pressure - loop with many live vars" =
  let no_opt_result, opt_result =
    test_both_modes
      ~harness:(make_harness_source ())
      high_register_pressure_loop
  in
  assert (String.equal no_opt_result "27583");
  assert (String.equal opt_result "27583")
;;

let%expect_test "high register pressure - wide expression tree" =
  let no_opt_result, opt_result =
    test_both_modes
      ~harness:(make_harness_source ~fn_arg_type:"int64_t" ~fn_arg:"2" ())
      high_register_pressure_expr_tree
  in
  assert (String.equal no_opt_result "502");
  assert (String.equal opt_result "502")
;;

let%expect_test "high register pressure - deeply nested expressions" =
  let no_opt_result, opt_result =
    test_both_modes
      ~harness:(make_harness_source ~fn_arg_type:"int64_t" ~fn_arg:"5" ())
      high_register_pressure_nested
  in
  assert (String.equal no_opt_result "590");
  assert (String.equal opt_result "590")
;;
