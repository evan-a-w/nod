open! Core
open! Import

let compile_and_lower ?(opt_flags = Eir.Opt_flags.no_opt) program =
  match Nod.compile ~opt_flags program with
  | Error e -> Nod_error.to_string e |> print_endline
  | Ok program ->
    let asm =
      X86_backend.compile_to_asm
        ~system:`Linux
        ~globals:program.Program.globals
        program.Program.functions
    in
    print_endline asm
;;

let compile_and_lower_functions functions =
  X86_backend.compile_to_asm ~system:`Linux functions
;;

let make_fn ~fn_state ~name ~args ~root =
  Fn_state.set_block_args fn_state ~block:root ~args:(Vec.of_list args);
  Block.set_dfs_id root (Some 0);
  Function.create ~name ~args ~root
;;

let mk_block fn_state ~id_hum ~terminal =
  Block.create ~id_hum ~terminal:(Fn_state.alloc_instr fn_state ~ir:terminal)
;;

let mk_block_with_instrs fn_state ~id_hum ~terminal ~instrs =
  let block = mk_block fn_state ~id_hum ~terminal in
  List.iter instrs ~f:(fun ir -> Fn_state.append_ir fn_state ~block ~ir);
  block
;;

let print_mnemonics_with_prefixes prefixes asm =
  asm
  |> String.split_lines
  |> List.filter_map ~f:(fun line ->
    let line = String.strip line in
    if List.exists prefixes ~f:(fun prefix -> String.is_prefix line ~prefix)
    then String.split line ~on:' ' |> List.hd
    else None)
  |> List.iter ~f:print_endline
;;

let print_selected_mem_fences fn =
  Function.iter_root fn ~f:(fun root ->
    Block.to_list root
    |> List.concat_map ~f:(fun block ->
      Instr_state.to_ir_list (Block.instructions block)
      @ [ (Block.terminal block).Instr_state.ir ])
    |> List.concat_map ~f:(fun instr ->
      match instr with
      | Ir0.X86 x -> [ x ]
      | Ir0.X86_terminal xs -> xs
      | _ -> [])
    |> List.filter_map ~f:(function
      | X86_ir.MFENCE -> Some "mfence"
      | X86_ir.MOV (X86_ir.Mem _, _) -> Some "store"
      | X86_ir.MOV (_, X86_ir.Mem _) -> Some "load"
      | _ -> None)
    |> List.iter ~f:print_endline)
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
      mov rbp, rsp
      push r14
      push r15
    root__a:
      mov r14, 10
      mov r15, 20
      sub r15, r14
      mov rax, r15
    root__root__epilogue:
      sub rbp, 16
      mov rsp, rbp
      pop r15
      pop r14
      pop rbp
      ret
    .section .note.GNU-stack,"",@progbits
    |}]
;;

let%expect_test "atomic load/store seq_cst lower to mfence" =
  let slot = Var.create ~name:"slot" ~type_:Type.Ptr in
  let loaded = Var.create ~name:"loaded" ~type_:Type.I64 in
  let fn_state = Fn_state.create () in
  let root =
    mk_block_with_instrs
      fn_state
      ~id_hum:"%root"
      ~terminal:(Ir.return (Ir.Lit_or_var.Var loaded))
      ~instrs:
        [ Ir.alloca { dest = slot; size = Ir.Lit_or_var.Lit 8L }
        ; Ir.atomic_store
            { addr = Ir.Mem.address (Ir.Lit_or_var.Var slot)
            ; src = Ir.Lit_or_var.Lit 7L
            ; order = Ir.Memory_order.Seq_cst
            }
        ; Ir.atomic_load
            { dest = loaded
            ; addr = Ir.Mem.address (Ir.Lit_or_var.Var slot)
            ; order = Ir.Memory_order.Seq_cst
            }
        ]
  in
  let fn = make_fn ~fn_state ~name:"root" ~args:[] ~root in
  let selected_map =
    X86_backend.For_testing.select_instructions
      (String.Map.of_alist_exn [ "root", fn ])
  in
  let selected = Map.find_exn selected_map "root" in
  print_selected_mem_fences selected;
  [%expect
    {|
    store
    mfence
    mfence
    load
    |}]
;;

let%expect_test "atomic cmpxchg lowers to lock cmpxchg and sete" =
  let slot = Var.create ~name:"slot" ~type_:Type.Ptr in
  let old = Var.create ~name:"old" ~type_:Type.I64 in
  let ok = Var.create ~name:"ok" ~type_:Type.I64 in
  let fn_state = Fn_state.create () in
  let root =
    mk_block_with_instrs
      fn_state
      ~id_hum:"%root"
      ~terminal:(Ir.return (Ir.Lit_or_var.Var ok))
      ~instrs:
        [ Ir.alloca { dest = slot; size = Ir.Lit_or_var.Lit 8L }
        ; Ir.atomic_cmpxchg
            { dest = old
            ; success = ok
            ; addr = Ir.Mem.address (Ir.Lit_or_var.Var slot)
            ; expected = Ir.Lit_or_var.Lit 1L
            ; desired = Ir.Lit_or_var.Lit 2L
            ; success_order = Ir.Memory_order.Acq_rel
            ; failure_order = Ir.Memory_order.Acquire
            }
        ]
  in
  let fn = make_fn ~fn_state ~name:"root" ~args:[] ~root in
  let asm =
    compile_and_lower_functions (String.Map.of_alist_exn [ "root", fn ])
  in
  print_mnemonics_with_prefixes [ "lock cmpxchg"; "sete"; "and" ] asm;
  [%expect
    {|
    lock
    sete
    and
    |}]
;;

let%expect_test "atomic rmw lowers to cmpxchg loop" =
  let slot = Var.create ~name:"slot" ~type_:Type.Ptr in
  let old = Var.create ~name:"old" ~type_:Type.I64 in
  let fn_state = Fn_state.create () in
  let root =
    mk_block_with_instrs
      fn_state
      ~id_hum:"%root"
      ~terminal:(Ir.return (Ir.Lit_or_var.Var old))
      ~instrs:
        [ Ir.alloca { dest = slot; size = Ir.Lit_or_var.Lit 8L }
        ; Ir.atomic_rmw
            { dest = old
            ; addr = Ir.Mem.address (Ir.Lit_or_var.Var slot)
            ; src = Ir.Lit_or_var.Lit 1L
            ; op = Ir.Rmw_op.Add
            ; order = Ir.Memory_order.Relaxed
            }
        ]
  in
  let fn = make_fn ~fn_state ~name:"root" ~args:[] ~root in
  let asm =
    compile_and_lower_functions (String.Map.of_alist_exn [ "root", fn ])
  in
  print_mnemonics_with_prefixes [ "lock cmpxchg" ] asm;
  [%expect
    {| lock |}]
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
      mov rbp, rsp
      push r14
      push r15
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
      sub rbp, 16
      mov rsp, rbp
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
      mov rbp, rsp
      push r13
      push r14
      push r15
      sub rsp, 8
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
      sub rbp, 24
      mov rsp, rbp
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
      mov rbp, rsp
      push r15
      sub rsp, 8
    root___root:
      mov xmm15, 3
      mov xmm14, 7
      addsd xmm15, xmm14
      cvttsd2si r15, xmm15
      mov rax, r15
    root__root__epilogue:
      sub rbp, 8
      mov rsp, rbp
      pop r15
      pop rbp
      ret
    .section .note.GNU-stack,"",@progbits
    |}]
;;

let%expect_test "globals lower into data section" =
  compile_and_lower
    {|
global @g:i64 = 42
global @pair:(i64, i64) = (10, 32)
global @zeros:(i64, i64) = zero
root() {
  load %x:i64, @g
  load_field %y:i64, @pair, (i64, i64), 1
  add %z:i64, %x, %y
  ret %z
}
|};
  [%expect {|
    .intel_syntax noprefix
    .data
    .balign 8
    g:
    .byte 42
    .zero 7
    .balign 8
    pair:
    .byte 10
    .zero 7
    .byte 32
    .zero 7
    .balign 8
    zeros:
    .zero 16
    .text
    .globl root
    root:
      push rbp
      mov rbp, rsp
      push r13
      push r14
      push r15
      sub rsp, 8
    root___root:
      lea r15, [rip + g]
      mov r13, [r15]
      lea r15, [rip + pair]
      mov r14, [r15 + 8]
      mov r15, r13
      add r15, r14
      mov rax, r15
    root__root__epilogue:
      sub rbp, 24
      mov rsp, rbp
      pop r15
      pop r14
      pop r13
      pop rbp
      ret
    .section .note.GNU-stack,"",@progbits
    |}]
;;

let%expect_test "globals store, load, and reuse values" =
  compile_and_lower
    {|
global @g:i64 = 0
root() {
  mov %v:i64, 123
  store @g, %v
  load %x:i64, @g
  add %y:i64, %x, %v
  ret %y
}
|};
  [%expect {|
    .intel_syntax noprefix
    .data
    .balign 8
    g:
    .zero 8
    .text
    .globl root
    root:
      push rbp
      mov rbp, rsp
      push r14
      push r15
    root___root:
      mov r14, 123
      lea r15, [rip + g]
      mov [r15], r14
      lea r15, [rip + g]
      mov r15, [r15]
      add r15, r14
      mov rax, r15
    root__root__epilogue:
      sub rbp, 16
      mov rsp, rbp
      pop r15
      pop r14
      pop rbp
      ret
    .section .note.GNU-stack,"",@progbits
    |}]
;;

let%expect_test "globals used in pointer arithmetic" =
  compile_and_lower
    {|
global @buf:(i64, i64) = (10, 32)
root() {
  add %p:ptr, @buf, 8
  load %x:i64, %p
  ret %x
}
|};
  [%expect {|
    .intel_syntax noprefix
    .data
    .balign 8
    buf:
    .byte 10
    .zero 7
    .byte 32
    .zero 7
    .text
    .globl root
    root:
      push rbp
      mov rbp, rsp
      push r15
      sub rsp, 8
    root___root:
      lea r15, [rip + buf]
      add r15, 8
      mov r15, [r15]
      mov rax, r15
    root__root__epilogue:
      sub rbp, 8
      mov rsp, rbp
      pop r15
      pop rbp
      ret
    .section .note.GNU-stack,"",@progbits
    |}]
;;

let%expect_test "globals passed as call args" =
  compile_and_lower
    {|
global @g:i64 = 0
id(%p:ptr(i64)) {
  mov %tmp:ptr(i64), %p
  ret 0
}
root() {
  call id(@g)
  ret 0
}
|};
  [%expect {|
    .intel_syntax noprefix
    .data
    .balign 8
    g:
    .zero 8
    .text
    .globl id
    id:
      push rbp
      mov rbp, rsp
      push r15
      sub rsp, 8
      mov r15, rdi
    id___root:
      mov r15, 0
      mov rax, r15
    id__id__epilogue:
      sub rbp, 8
      mov rsp, rbp
      pop r15
      pop rbp
      ret

    .globl root
    root:
      push rbp
      mov rbp, rsp
      push r15
      sub rsp, 8
    root___root:
      lea r15, [rip + g]
      mov rdi, r15
      call id
      mov r15, 0
      mov rax, r15
    root__root__epilogue:
      sub rbp, 8
      mov rsp, rbp
      pop r15
      pop rbp
      ret
    .section .note.GNU-stack,"",@progbits
    |}]
;;

let%expect_test "globals data layout for floats and aggregates" =
  compile_and_lower
    {|
global @f:f64 = 1.5
global @p:ptr(i64) = 0
global @nested:(i8, (i16, i32), i8) = (1, (2, 3), 4)
global @mixed:(i8, i64, i16) = (1, 72623859790382856, 7)
root() {
  ret 0
}
|};
  [%expect {|
    .intel_syntax noprefix
    .data
    .balign 8
    f:
    .zero 6
    .byte 248, 63
    .balign 8
    p:
    .zero 8
    .balign 4
    nested:
    .byte 1
    .zero 3
    .byte 2
    .zero 3
    .byte 3
    .zero 3
    .byte 4
    .zero 3
    .balign 8
    mixed:
    .byte 1
    .zero 7
    .byte 8, 7, 6, 5, 4, 3, 2, 1, 7
    .zero 7
    .text
    .globl root
    root:
      push rbp
      mov rbp, rsp
      push r15
      sub rsp, 8
    root___root:
      mov r15, 0
      mov rax, r15
    root__root__epilogue:
      sub rbp, 8
      mov rsp, rbp
      pop r15
      pop rbp
      ret
    .section .note.GNU-stack,"",@progbits
    |}]
;;
