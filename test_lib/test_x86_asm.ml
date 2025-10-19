open! Core
open! Nod

let compile_and_lower ?(opt_flags = Eir.Opt_flags.no_opt) program =
  match Eir.compile ~opt_flags program with
  | Error e -> Parser.error_to_string e |> print_endline
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
      mov rbp, rsp
      push rbp
      push r14
      push r15
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
      mov rbp, rsp
      push rbp
      push r13
      push r14
      push r15
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
