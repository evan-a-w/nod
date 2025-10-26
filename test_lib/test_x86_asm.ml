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
    .section .note.GNU-stack,"",@progbits
    |}]
;;

let%expect_test "basic float add" =
  compile_and_lower
    {|
mov %x:f64, 3
mov %y:f64, 7
fadd %sum:f64, %x, %y
movsd %result:i64, %sum
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
      jmp root___root
    root___root:
      mov xmm14, 3
      mov xmm15, 7
      addsd xmm14, xmm15
      movq r15, xmm14
      mov rax, r15
      jmp root__root__epilogue
    root__root__epilogue:
      mov rsp, rbp
      sub rsp, 16
      pop r15
      pop rbp
      ret
    .section .note.GNU-stack,"",@progbits
    |}]
;;

let%expect_test "borked_pointer_arith_loop" =
  compile_and_lower
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
|};
  [%expect
    {|
    .intel_syntax noprefix
    .text
    .globl root
    root:
      sub rsp, 80
      push rbp
      push r12
      push r13
      push r14
      push r15
      mov rbp, rsp
      add rbp, 120
      jmp root___root
    root___root:
      mov r15, [rbp]
      mov r14, 0
      mov r15, 0
      mov r14, r15
      jmp root__loop
    root__loop:
      mov r13, 8
      mov rax, r14
      imul r13
      mov r13, rax
      mov r12, r15
      add r12, r13
      mov r13, r14
      add r13, r14
      mov r13, r14
      add r13, 1
      sub r13, 10
      cmp r13, 0
      jne root__intermediate_loop_to_loop
      jmp root__intermediate_loop_to_done
    root__intermediate_loop_to_loop:
      mov r14, r13
      mov r14, r13
      jmp root__loop
    root__intermediate_loop_to_done:
      jmp root__done
    root__done:
      mov rax, r13
      jmp root__root__epilogue
    root__root__epilogue:
      mov rsp, rbp
      sub rsp, 120
      pop r15
      pop r14
      pop r13
      pop r12
      pop rbp
      add rsp, 80
      ret
    .section .note.GNU-stack,"",@progbits
    |}]
;;
