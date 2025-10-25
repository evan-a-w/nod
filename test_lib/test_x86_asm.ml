open! Core
open! Import

let compile_and_lower ?(opt_flags = Eir.Opt_flags.no_opt) program =
  match Nod.compile ~opt_flags program with
  | Error e -> Nod_error.to_string e |> print_endline
  | Ok functions ->
    let asm = X86_backend.compile_to_asm functions in
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
      jmp root__a
    root__a:
      mov r15, 10
      mov r14, 20
      sub r14, r15
      mov rax, r14
      jmp root__root__epilogue
    root__root__epilogue:
      mov rsp, rbp
      sub rsp, 24
      pop r15
      pop r14
      pop rbp
      ret
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
      push r13
      push r14
      push r15
      mov rbp, rsp
      add rbp, 32
      jmp root__a
    root__a:
      mov r15, 10
      mov r14, 20
      sub r14, r15
      jmp root__intermediate_a_to_b
    root__intermediate_a_to_b:
      jmp root__b
    root__b:
      mov r13, r14
      add r13, 5
      jmp root__intermediate_b_to_end0
    root__intermediate_b_to_end0:
      mov r15, r13
      jmp root__end
    root__end:
      mov rax, r15
      jmp root__root__epilogue
    root__root__epilogue:
      mov rsp, rbp
      sub rsp, 32
      pop r15
      pop r14
      pop r13
      pop rbp
      ret
    root__intermediate_b_to_end:
      mov r15, r13
      jmp root__end
    root__intermediate_a_to_c:
      jmp root__c
    root__c:
      mov r14, 0
      jmp root__intermediate_c_to_end0
    root__intermediate_c_to_end0:
      mov r15, r14
      jmp root__end
    root__intermediate_c_to_end:
      mov r15, r14
      jmp root__end
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
      jmp fib___root
    fib___root:
      cmp r14, 0
      jne fib__intermediate__root_to_check1_
      jmp fib__intermediate__root_to_ret_1
    fib__intermediate__root_to_check1_:
      jmp fib__check1_
    fib__check1_:
      mov r15, r14
      sub r15, 1
      cmp r15, 0
      jne fib__intermediate_check1__to_rec
      jmp fib__intermediate_check1__to_ret_1
    fib__intermediate_check1__to_rec:
      jmp fib__rec
    fib__rec:
      push rax
      mov rdi, r15
      call fib
      mov r14, rax
      pop rax
      mov r13, r15
      sub r13, 1
      push rax
      mov rdi, r13
      call fib
      mov r13, rax
      pop rax
      add r14, r13
      mov rax, r14
      jmp fib__fib__epilogue
    fib__fib__epilogue:
      mov rsp, rbp
      sub rsp, 32
      pop r15
      pop r14
      pop r13
      pop rbp
      ret
    fib__intermediate_check1__to_ret_1:
      jmp fib__ret_1
    fib__ret_1:
      mov r14, 1
      mov rax, r14
      jmp fib__fib__epilogue
    fib__intermediate__root_to_ret_1:
      mov r15, r13
      jmp fib__ret_1
    |}]
;;
