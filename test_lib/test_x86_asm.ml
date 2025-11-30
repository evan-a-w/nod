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
      mov r14, 10
      mov r15, 20
      sub r15, r14
      mov rax, r15
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
      mov r14, 10
      mov r15, 20
      sub r15, r14
      jmp root__intermediate_a_to_b
    root__intermediate_a_to_b:
      jmp root__b
    root__b:
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
      mov r13, rax
      pop rax
      sub r15, 1
      push rax
      mov rdi, r15
      call fib
      mov r14, rax
      pop rax
      mov r15, r13
      add r15, r14
      mov rax, r15
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
      mov r15, 1
      mov rax, r15
      jmp fib__fib__epilogue
    fib__intermediate__root_to_ret_1:
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
      mov xmm15, 3
      mov xmm14, 7
      addsd xmm15, xmm14
      cvttsd2si r15, xmm15
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
      mov r11, [rbp]
      mov r14, 0
      mov r15, 0
      mov r12, r14
      mov r13, r15
      jmp root__loop
    root__loop:
      mov r15, 8
      mov rax, r12
      imul r15
      mov r14, rax
      mov r15, r11
      add r15, r14
      add r13, r12
      mov r14, r12
      add r14, 1
      mov r15, r14
      sub r15, 10
      cmp r15, 0
      jne root__intermediate_loop_to_loop
      jmp root__intermediate_loop_to_done
    root__intermediate_loop_to_loop:
      mov r12, r14
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

let%expect_test "debug borked loop - show SSA" =
  let program =
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
  match Nod.compile ~opt_flags:Eir.Opt_flags.no_opt program with
  | Error e -> print_endline (Nod_error.to_string e)
  | Ok functions ->
    Map.iteri functions ~f:(fun ~key:name ~data:fn ->
      print_endline (sprintf "=== Function: %s ===" name);
      Block.iter fn.Function.root ~f:(fun block ->
        print_endline (sprintf "\nBlock: %s" block.Block.id_hum);
        print_endline
          (sprintf
             "  Args: %s"
             (Vec.to_list block.args
              |> List.map ~f:(fun v ->
                sprintf "%s:%s" (Var.name v) (Type.to_string (Var.type_ v)))
              |> String.concat ~sep:", "));
        Vec.iter block.instructions ~f:(fun instr ->
          print_endline (sprintf "  %s" (Sexp.to_string_hum (Ir.sexp_of_t instr))));
        print_endline
          (sprintf "  Terminal: %s" (Sexp.to_string_hum (Ir.sexp_of_t block.terminal)))));
  [%expect {|
    === Function: root ===

    Block: %root
      Args:
      (Alloca ((dest ((name array) (type_ Ptr))) (size (Lit 80))))
      (Move ((name i) (type_ I64)) (Lit 0))
      (Move ((name sum) (type_ I64)) (Lit 0))
      Terminal: (Branch
     (Uncond
      ((block
        ((id_hum loop)
         (args (((name i%0) (type_ I64)) ((name sum%0) (type_ I64))))))
       (args (((name i) (type_ I64)) ((name sum) (type_ I64)))))))

    Block: loop
      Args: i%0:i64, sum%0:i64
      (Mul
     ((dest ((name offset) (type_ I64))) (src1 (Var ((name i%0) (type_ I64))))
      (src2 (Lit 8))))
      (Add
     ((dest ((name ptr) (type_ Ptr))) (src1 (Var ((name array) (type_ Ptr))))
      (src2 (Var ((name offset) (type_ I64))))))
      (Add
     ((dest ((name sum%1) (type_ I64))) (src1 (Var ((name sum%0) (type_ I64))))
      (src2 (Var ((name i%0) (type_ I64))))))
      (Add
     ((dest ((name i%1) (type_ I64))) (src1 (Var ((name i%0) (type_ I64))))
      (src2 (Lit 1))))
      (Sub
     ((dest ((name cond) (type_ I64))) (src1 (Var ((name i%1) (type_ I64))))
      (src2 (Lit 10))))
      Terminal: (Branch
     (Cond (cond (Var ((name cond) (type_ I64))))
      (if_true
       ((block
         ((id_hum loop)
          (args (((name i%0) (type_ I64)) ((name sum%0) (type_ I64))))))
        (args (((name i%1) (type_ I64)) ((name sum%1) (type_ I64))))))
      (if_false ((block ((id_hum done) (args ()))) (args ())))))

    Block: done
      Args:
      Terminal: (Return (Var ((name sum%1) (type_ I64))))
    |}]
;;
