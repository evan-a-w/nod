open! Core
open! Import

let compile_and_lower ?(opt_flags = Eir.Opt_flags.no_opt) program =
  match Nod.compile ~opt_flags program with
  | Error e -> Nod_error.to_string e |> print_endline
  | Ok functions ->
    let asm = Arm64_backend.compile_to_asm ~system:`Linux functions in
    print_endline asm
;;

let%expect_test "super triv lowers to assembly" =
  compile_and_lower Examples.Textual.super_triv;
  [%expect
    {|
    .text
    .globl root
    root:
      mov x14, #32
      sub sp, sp, x14
      str x27, [sp]
      str x28, [sp, #8]
      str x29, [sp, #16]
      str x30, [sp, #24]
      mov x29, sp
      mov x14, #32
      add x29, x29, x14
    root__a:
      mov x27, #10
      mov x28, #20
      sub x28, x28, x27
      mov x0, x28
    root__root__epilogue:
      mov x0, x0
      mov sp, x29
      mov x14, #32
      sub sp, sp, x14
      ldr x30, [sp, #24]
      ldr x29, [sp, #16]
      ldr x28, [sp, #8]
      ldr x27, [sp]
      mov x14, #32
      add sp, sp, x14
      ret
    .section .note.GNU-stack,"",@progbits
    |}]
;;

let%expect_test "branches lower with labels" =
  compile_and_lower Examples.Textual.a;
  [%expect
    {|
    .text
    .globl root
    root:
      mov x14, #32
      sub sp, sp, x14
      str x27, [sp]
      str x28, [sp, #8]
      str x29, [sp, #16]
      str x30, [sp, #24]
      mov x29, sp
      mov x14, #32
      add x29, x29, x14
    root__a:
      mov x27, #10
      mov x28, #20
      sub x28, x28, x27
      mov x14, #1
      cmp x14, #0
      b.eq root__intermediate_a_to_c
    root__intermediate_a_to_b:
      b root__b
    root__intermediate_a_to_c:
      b root__c
    root__b:
      mov x14, #5
      add x28, x28, x14
      mov x14, #1
      cmp x14, #0
      b.ne root__intermediate_b_to_end
      b root__intermediate_b_to_end0
    root__c:
      mov x28, #0
      mov x14, #1
      cmp x14, #0
      b.ne root__intermediate_c_to_end
      b root__intermediate_c_to_end0
    root__intermediate_b_to_end:
      mov x28, x28
      b root__end
    root__intermediate_b_to_end0:
      mov x28, x28
      b root__end
    root__intermediate_c_to_end:
      mov x28, x28
      b root__end
    root__intermediate_c_to_end0:
      mov x28, x28
    root__end:
      mov x0, x28
    root__root__epilogue:
      mov x0, x0
      mov sp, x29
      mov x14, #32
      sub sp, sp, x14
      ldr x30, [sp, #24]
      ldr x29, [sp, #16]
      ldr x28, [sp, #8]
      ldr x27, [sp]
      mov x14, #32
      add sp, sp, x14
      ret
    .section .note.GNU-stack,"",@progbits
    |}]
;;

let%expect_test "recursive fib" =
  compile_and_lower Examples.Textual.fib_recursive;
  [%expect
    {|
    .text
    .globl fib
    fib:
      mov x14, #32
      sub sp, sp, x14
      str x27, [sp]
      str x28, [sp, #8]
      str x29, [sp, #16]
      str x30, [sp, #24]
      mov x29, sp
      mov x14, #32
      add x29, x29, x14
      mov x0, x0
      mov x27, x0
    fib___root:
      cmp x27, #0
      b.eq fib__intermediate__root_to_ret_1
    fib__intermediate__root_to_check1_:
      b fib__check1_
    fib__intermediate__root_to_ret_1:
      mov x28, x28
      b fib__ret_1
    fib__check1_:
      mov x14, #1
      sub x28, x27, x14
      cmp x28, #0
      b.eq fib__intermediate_check1__to_ret_1
    fib__intermediate_check1__to_rec:
      b fib__rec
    fib__intermediate_check1__to_ret_1:
      mov x28, x28
    fib__ret_1:
      mov x28, #1
      mov x0, x28
      b fib__fib__epilogue
    fib__rec:
      mov x0, x28
      bl fib
      mov x27, x0
      mov x14, #1
      sub x28, x28, x14
      mov x0, x28
      bl fib
      mov x28, x0
      add x28, x27, x28
      mov x0, x28
    fib__fib__epilogue:
      mov x0, x0
      mov sp, x29
      mov x14, #32
      sub sp, sp, x14
      ldr x30, [sp, #24]
      ldr x29, [sp, #16]
      ldr x28, [sp, #8]
      ldr x27, [sp]
      mov x14, #32
      add sp, sp, x14
      ret
    .section .note.GNU-stack,"",@progbits
    |}]
;;

let%expect_test "basic float add with cast" =
  compile_and_lower
    {|
mov %x:f64, 3
mov %y:f64, 7
fadd %sum:f64, %x, %y
cast %result:i64, %sum
ret %result
         |};
  [%expect
    {|
    .text
    .globl root
    root:
      mov x14, #8
      sub sp, sp, x14
      mov x14, #24
      sub sp, sp, x14
      str x28, [sp]
      str x29, [sp, #8]
      str x30, [sp, #16]
      mov x29, sp
      mov x14, #24
      add x29, x29, x14
    root___root:
      mov d27, #3
      mov d28, #7
      fadd d28, d27, d28
      fcvtzs x28, d28
      mov x0, x28
    root__root__epilogue:
      mov x0, x0
      mov sp, x29
      mov x14, #24
      sub sp, sp, x14
      ldr x30, [sp, #16]
      ldr x29, [sp, #8]
      ldr x28, [sp]
      mov x14, #24
      add sp, sp, x14
      mov x14, #8
      add sp, sp, x14
      ret
    .section .note.GNU-stack,"",@progbits
    |}]
;;
