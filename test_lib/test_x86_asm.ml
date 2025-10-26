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
      push r14
      push r15
      mov rbp, rsp
      add rbp, 24
      jmp root__a
    root__a:
      mov r15, 10
      mov r14, 20
      sub r14, r15
      jmp root__intermediate_a_to_b
    root__intermediate_a_to_b:
      jmp root__b
    root__b:
      mov r15, r14
      add r15, 5
      jmp root__intermediate_b_to_end0
    root__intermediate_b_to_end0:
      jmp root__end
    root__end:
      mov rax, r15
      jmp root__root__epilogue
    root__root__epilogue:
      mov rsp, rbp
      sub rsp, 24
      pop r15
      pop r14
      pop rbp
      ret
    root__intermediate_b_to_end:
      jmp root__end
    root__intermediate_a_to_c:
      jmp root__c
    root__c:
      mov r15, 0
      jmp root__intermediate_c_to_end0
    root__intermediate_c_to_end0:
      jmp root__end
    root__intermediate_c_to_end:
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
      push r14
      push r15
      mov rbp, rsp
      add rbp, 24
      mov r14, rdi
      jmp fib___root
    fib___root:
      cmp r14, 0
      jne fib__intermediate__root_to_check1_
      jmp fib__intermediate__root_to_ret_1
    fib__intermediate__root_to_check1_:
      jmp fib__check1_
    fib__check1_:
      sub r14, 1
      cmp r14, 0
      jne fib__intermediate_check1__to_rec
      jmp fib__intermediate_check1__to_ret_1
    fib__intermediate_check1__to_rec:
      jmp fib__rec
    fib__rec:
      push rax
      mov rdi, r14
      call fib
      mov r15, rax
      pop rax
      sub r14, 1
      push rax
      mov rdi, r14
      call fib
      mov r14, rax
      pop rax
      add r15, r14
      mov rax, r15
      jmp fib__fib__epilogue
    fib__fib__epilogue:
      mov rsp, rbp
      sub rsp, 24
      pop r15
      pop r14
      pop rbp
      ret
    fib__intermediate_check1__to_ret_1:
      mov r15, r14
      mov r14, r15
      jmp fib__ret_1
    fib__ret_1:
      mov r15, 1
      mov rax, r15
      jmp fib__fib__epilogue
    fib__intermediate__root_to_ret_1:
      mov r14, r15
      jmp fib__ret_1
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
      jmp root___root
    root___root:
      mov xmm14, 3
      mov xmm15, 7
      addsd xmm14, xmm15
      cvttsd2si r15, xmm14
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

let borked = Examples.Textual.sum_100

let%expect_test "borked" =
  compile_and_lower ~opt_flags:Eir.Opt_flags.default borked;
  [%expect
    {|
    .intel_syntax noprefix
    .text
    .globl root
    root:
      push rbp
      push r12
      push r13
      push r14
      push r15
      mov rbp, rsp
      add rbp, 40
      jmp root__start
    root__start:
      mov r14, 1
      mov r13, 0
      jmp root__check
    root__check:
      mov r12, r14
      sub r12, 100
      cmp r12, 0
      jne root__intermediate_check_to_body
      jmp root__intermediate_check_to_exit
    root__intermediate_check_to_body:
      jmp root__body
    root__body:
      add r13, r14
      mov r14, r15
      jmp root__check
    root__intermediate_check_to_exit:
      mov r15, r13
      jmp root__exit
    root__exit:
      mov rax, r15
      jmp root__root__epilogue
    root__root__epilogue:
      mov rsp, rbp
      sub rsp, 40
      pop r15
      pop r14
      pop r13
      pop r12
      pop rbp
      ret
    .section .note.GNU-stack,"",@progbits
    |}]
;;

let%expect_test "debug borked" =
  match Nod.compile ~opt_flags:Eir.Opt_flags.default borked with
  | Error e -> Nod_error.to_string e |> print_endline
  | Ok functions ->
    X86_backend.For_testing.print_selected_instructions functions;
    [%expect
      {|
    Block: root__prologue
    =====================
    +------+-----------------------------------------------------+---------+----------+
    | Idx  | Instruction                                         | Live In | Live Out |
    +------+-----------------------------------------------------+---------+----------+
    | 0    | (X86(Tag_def NOOP(Reg((reg RBP)(class_ I64)))))     | {2}     | {2}      |
    | TERM | (X86(JMP((block((id_hum start)(args())))(args())))) | {2}     | {2}      |
    +------+-----------------------------------------------------+---------+----------+

    Block: start
    ============
    +------+--------------------------------------------------------------------------------------------------------------------------------------+---------+----------+
    | Idx  | Instruction                                                                                                                          | Live In | Live Out |
    +------+--------------------------------------------------------------------------------------------------------------------------------------+---------+----------+
    | 0    | (X86(MOV(Reg((reg(Unallocated((name i)(type_ I64))))(class_ I64)))(Imm 1)))                                                          | {2}     | {2}      |
    | 1    | (X86(MOV(Reg((reg(Unallocated((name sum)(type_ I64))))(class_ I64)))(Imm 0)))                                                        | {2}     | {2}      |
    | 2    | (X86(MOV(Reg((reg(Unallocated((name i%1)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name i)(type_ I64))))(class_ I64)))))     | {2}     | {2}      |
    | 3    | (X86(MOV(Reg((reg(Unallocated((name sum%1)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name sum)(type_ I64))))(class_ I64))))) | {2}     | {2}      |
    | TERM | (X86_terminal((JMP((block((id_hum check)(args(((name i%1)(type_ I64))((name sum%1)(type_ I64))))))(args())))))                       | {2}     | {2}      |
    +------+--------------------------------------------------------------------------------------------------------------------------------------+---------+----------+

    Block: check
    ============
    +------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------+----------+
    | Idx  | Instruction                                                                                                                                                                                                                  | Live In | Live Out |
    +------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------+----------+
    | 0    | (X86(MOV(Reg((reg(Unallocated((name cond)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name i%1)(type_ I64))))(class_ I64)))))                                                                                          | {2}     | {2}      |
    | 1    | (X86(SUB(Reg((reg(Unallocated((name cond)(type_ I64))))(class_ I64)))(Imm 100)))                                                                                                                                             | {2}     | {2}      |
    | TERM | (X86_terminal((CMP(Reg((reg(Unallocated((name cond)(type_ I64))))(class_ I64)))(Imm 0))(JNE((block((id_hum intermediate_check_to_body)(args())))(args()))(((block((id_hum intermediate_check_to_exit)(args())))(args())))))) | {2}     | {2}      |
    +------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------+----------+

    Block: intermediate_check_to_body
    =================================
    +------+----------------------------------------------------+---------+----------+
    | Idx  | Instruction                                        | Live In | Live Out |
    +------+----------------------------------------------------+---------+----------+
    | TERM | (X86(JMP((block((id_hum body)(args())))(args())))) | {2}     | {2}      |
    +------+----------------------------------------------------+---------+----------+

    Block: body
    ===========
    +------+----------------------------------------------------------------------------------------------------------------------------------------+---------+----------+
    | Idx  | Instruction                                                                                                                            | Live In | Live Out |
    +------+----------------------------------------------------------------------------------------------------------------------------------------+---------+----------+
    | 0    | (X86(MOV(Reg((reg(Unallocated((name sum%2)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name sum%1)(type_ I64))))(class_ I64))))) | {2}     | {2}      |
    | 1    | (X86(ADD(Reg((reg(Unallocated((name sum%2)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name i%1)(type_ I64))))(class_ I64)))))   | {2}     | {2}      |
    | 2    | (X86(MOV(Reg((reg(Unallocated((name i%1)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name i%2)(type_ I64))))(class_ I64)))))     | {2}     | {2}      |
    | 3    | (X86(MOV(Reg((reg(Unallocated((name sum%1)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name sum%2)(type_ I64))))(class_ I64))))) | {2}     | {2}      |
    | TERM | (X86_terminal((JMP((block((id_hum check)(args(((name i%1)(type_ I64))((name sum%1)(type_ I64))))))(args())))))                         | {2}     | {2}      |
    +------+----------------------------------------------------------------------------------------------------------------------------------------+---------+----------+

    Block: intermediate_check_to_exit
    =================================
    +------+----------------------------------------------------------------------------------------------------------------------------------------+---------+----------+
    | Idx  | Instruction                                                                                                                            | Live In | Live Out |
    +------+----------------------------------------------------------------------------------------------------------------------------------------+---------+----------+
    | 0    | (X86(MOV(Reg((reg(Unallocated((name sum%0)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name sum%1)(type_ I64))))(class_ I64))))) | {2}     | {2}      |
    | TERM | (X86(JMP((block((id_hum exit)(args(((name sum%0)(type_ I64))))))(args()))))                                                            | {2}     | {2}      |
    +------+----------------------------------------------------------------------------------------------------------------------------------------+---------+----------+

    Block: exit
    ===========
    +------+-----------------------------------------------------------------------------------------------------------------------------------------+---------+----------+
    | Idx  | Instruction                                                                                                                             | Live In | Live Out |
    +------+-----------------------------------------------------------------------------------------------------------------------------------------+---------+----------+
    | 0    | (X86(MOV(Reg((reg(Unallocated((name res__0)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name sum%0)(type_ I64))))(class_ I64))))) | {2}     | {2}      |
    | TERM | (X86_terminal((JMP((block((id_hum root__epilogue)(args(((name res__0)(type_ I64))))))(args())))))                                       | {2}     | {2}      |
    +------+-----------------------------------------------------------------------------------------------------------------------------------------+---------+----------+

    Block: root__epilogue
    =====================
    +------+----------------------------------------------------------------------------------------------------------+---------+----------+
    | Idx  | Instruction                                                                                              | Live In | Live Out |
    +------+----------------------------------------------------------------------------------------------------------+---------+----------+
    | 0    | (X86(MOV(Reg((reg(Allocated((name res__0)(type_ I64))(RAX)))(class_ I64)))(Reg((reg RAX)(class_ I64))))) | {2}     | {}       |
    | TERM | (X86(RET((Reg((reg(Allocated((name res__0)(type_ I64))(RAX)))(class_ I64))))))                           | {}      | {}       |
    +------+----------------------------------------------------------------------------------------------------------+---------+----------+
    |}]
;;
