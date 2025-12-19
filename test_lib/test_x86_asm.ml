open! Core
open! Import

let compile_and_lower ?(opt_flags = Eir.Opt_flags.no_opt) program =
  match Nod.compile ~opt_flags program with
  | Error e -> Nod_error.to_string e |> print_endline
  | Ok functions ->
    let asm = X86_backend.compile_to_asm ~system:`Linux functions in
    print_endline asm
;;

let%expect_test "super triv lowers to assembly" =
  compile_and_lower Examples.Textual.super_triv;
  [%expect
    {|
    .intel_syntax noprefix
    .text
    .globl root
    root:
      push rbp
      push r14
      push r15
      mov rbp, rsp
      add rbp, 24
    root__a:
      mov r14, 10
      mov r15, 20
      sub r15, r14
      mov rax, r15
    root__root__epilogue:
      mov rsp, rbp
      sub rsp, 24
      pop r15
      pop r14
      pop rbp
      ret
    .section .note.GNU-stack,"",@progbits
    |}]
;;

let%expect_test "branches lower with labels" =
  compile_and_lower Examples.Textual.a;
  [%expect
    {|
    .intel_syntax noprefix
    .text
    .globl root
    root:
      push rbp
      push r14
      push r15
      mov rbp, rsp
      add rbp, 24
    root__a:
      mov r14, 10
      mov r15, 20
      sub r15, r14
    root__intermediate_a_to_b:
      jmp root__b
    root__intermediate_a_to_c:
      jmp root__c
    root__b:
      add r15, 5
      jmp root__intermediate_b_to_end0
    root__c:
      mov r15, 0
      jmp root__intermediate_c_to_end0
    root__intermediate_b_to_end0:
      jmp root__end
    root__intermediate_b_to_end:
      jmp root__end
    root__intermediate_c_to_end0:
      jmp root__end
    root__intermediate_c_to_end:
    root__end:
      mov rax, r15
    root__root__epilogue:
      mov rsp, rbp
      sub rsp, 24
      pop r15
      pop r14
      pop rbp
      ret
    .section .note.GNU-stack,"",@progbits
    |}]
;;

let%expect_test "recursive fib" =
  compile_and_lower Examples.Textual.fib_recursive;
  [%expect
    {|
    .intel_syntax noprefix
    .text
    .globl fib
    fib:
      push rbp
      push r13
      push r14
      push r15
      mov rbp, rsp
      add rbp, 32
      mov r14, rdi
    fib___root:
      cmp r14, 0
      je fib__intermediate__root_to_ret_1
    fib__intermediate__root_to_check1_:
      jmp fib__check1_
    fib__intermediate__root_to_ret_1:
      jmp fib__ret_1
    fib__check1_:
      mov r15, r14
      sub r15, 1
      cmp r15, 0
      je fib__intermediate_check1__to_ret_1
    fib__intermediate_check1__to_rec:
      jmp fib__rec
    fib__intermediate_check1__to_ret_1:
    fib__ret_1:
      mov r15, 1
      mov rax, r15
      jmp fib__fib__epilogue
    fib__rec:
      mov rdi, r15
      call fib
      mov r13, rax
      sub r15, 1
      mov rdi, r15
      call fib
      mov r14, rax
      mov r15, r13
      add r15, r14
      mov rax, r15
    fib__fib__epilogue:
      mov rsp, rbp
      sub rsp, 32
      pop r15
      pop r14
      pop r13
      pop rbp
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
    .intel_syntax noprefix
    .text
    .globl root
    root:
      push rbp
      push r15
      mov rbp, rsp
      add rbp, 16
    root___root:
      mov xmm15, 3
      mov xmm14, 7
      addsd xmm15, xmm14
      cvttsd2si r15, xmm15
      mov rax, r15
    root__root__epilogue:
      mov rsp, rbp
      sub rsp, 16
      pop r15
      pop rbp
      ret
    .section .note.GNU-stack,"",@progbits
    |}]
;;
