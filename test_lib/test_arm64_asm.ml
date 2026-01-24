open! Core
open! Import

let compile_and_lower ?(opt_flags = Eir.Opt_flags.no_opt) program =
  match Nod.compile ~opt_flags program with
  | Error e -> Nod_error.to_string e |> print_endline
  | Ok program ->
    let asm =
      Arm64_backend.compile_to_asm
        ~system:`Linux
        ~globals:program.Program.globals
        program.Program.functions
    in
    print_endline asm
;;

let compile_and_lower_functions functions =
  Arm64_backend.compile_to_asm ~system:`Linux functions
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
      mov x29, sp
    root__a:
      mov x27, #10
      mov x28, #20
      sub x28, x28, x27
      mov x0, x28
    root__root__epilogue:
      mov x0, x0
      mov sp, x29
      ldr x27, [sp]
      ldr x28, [sp, #8]
      ldr x29, [sp, #16]
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
      mov x29, sp
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
      ldr x27, [sp]
      ldr x28, [sp, #8]
      ldr x29, [sp, #16]
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
      ldr x27, [sp]
      ldr x28, [sp, #8]
      ldr x29, [sp, #16]
      ldr x30, [sp, #24]
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
      mov x14, #16
      sub sp, sp, x14
      str x28, [sp]
      str x29, [sp, #8]
      mov x29, sp
    root___root:
      mov d27, #3
      mov d28, #7
      fadd d28, d27, d28
      fcvtzs x28, d28
      mov x0, x28
    root__root__epilogue:
      mov x0, x0
      mov sp, x29
      ldr x28, [sp]
      ldr x29, [sp, #8]
      mov x14, #16
      add sp, sp, x14
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
      mov x14, #32
      sub sp, sp, x14
      str x27, [sp]
      str x28, [sp, #8]
      str x29, [sp, #16]
      mov x29, sp
    root___root:
      adr x28, g
      ldr x27, [x28]
      adr x28, pair
      ldr x28, [x28, #8]
      add x28, x27, x28
      mov x0, x28
    root__root__epilogue:
      mov x0, x0
      mov sp, x29
      ldr x27, [sp]
      ldr x28, [sp, #8]
      ldr x29, [sp, #16]
      mov x14, #32
      add sp, sp, x14
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
    .data
    .balign 8
    g:
    .zero 8
    .text
    .globl root
    root:
      mov x14, #32
      sub sp, sp, x14
      str x27, [sp]
      str x28, [sp, #8]
      str x29, [sp, #16]
      mov x29, sp
    root___root:
      mov x27, #123
      adr x28, g
      str x27, [x28]
      adr x28, g
      ldr x28, [x28]
      add x28, x28, x27
      mov x0, x28
    root__root__epilogue:
      mov x0, x0
      mov sp, x29
      ldr x27, [sp]
      ldr x28, [sp, #8]
      ldr x29, [sp, #16]
      mov x14, #32
      add sp, sp, x14
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
      mov x14, #16
      sub sp, sp, x14
      str x28, [sp]
      str x29, [sp, #8]
      mov x29, sp
    root___root:
      adr x28, buf
      mov x14, #8
      add x28, x28, x14
      ldr x28, [x28]
      mov x0, x28
    root__root__epilogue:
      mov x0, x0
      mov sp, x29
      ldr x28, [sp]
      ldr x29, [sp, #8]
      mov x14, #16
      add sp, sp, x14
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
    .data
    .balign 8
    g:
    .zero 8
    .text
    .globl id
    id:
      mov x14, #16
      sub sp, sp, x14
      str x28, [sp]
      str x29, [sp, #8]
      mov x29, sp
      mov x0, x0
      mov x28, x0
    id___root:
      mov x28, x28
      mov x28, #0
      mov x0, x28
    id__id__epilogue:
      mov x0, x0
      mov sp, x29
      ldr x28, [sp]
      ldr x29, [sp, #8]
      mov x14, #16
      add sp, sp, x14
      ret

    .globl root
    root:
      mov x14, #32
      sub sp, sp, x14
      str x28, [sp]
      str x29, [sp, #8]
      str x30, [sp, #16]
      mov x29, sp
    root___root:
      adr x28, g
      mov x0, x28
      bl id
      mov x28, #0
      mov x0, x28
    root__root__epilogue:
      mov x0, x0
      mov sp, x29
      ldr x28, [sp]
      ldr x29, [sp, #8]
      ldr x30, [sp, #16]
      mov x14, #32
      add sp, sp, x14
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
      mov x14, #16
      sub sp, sp, x14
      str x28, [sp]
      str x29, [sp, #8]
      mov x29, sp
    root___root:
      mov x28, #0
      mov x0, x28
    root__root__epilogue:
      mov x0, x0
      mov sp, x29
      ldr x28, [sp]
      ldr x29, [sp, #8]
      mov x14, #16
      add sp, sp, x14
      ret
    .section .note.GNU-stack,"",@progbits
    |}]
;;

let%expect_test "atomic load/store seq_cst lower to ldar/stlr with dmb" =
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
  let asm = compile_and_lower_functions (String.Map.of_alist_exn [ "root", fn ]) in
  print_mnemonics_with_prefixes [ "dmb"; "stlr"; "ldar" ] asm;
  [%expect
    {|
    dmb
    stlr
    dmb
    dmb
    ldar
    dmb
    |}]
;;

let%expect_test "atomic cmpxchg lowers to casal and success masking" =
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
  let asm = compile_and_lower_functions (String.Map.of_alist_exn [ "root", fn ]) in
  print_mnemonics_with_prefixes
    [ "casal"; "eor x"; "sub x"; "orr x"; "asr x"; "and x" ]
    asm;
  [%expect
    {|
    casal
    eor
    sub
    orr
    asr
    and
    sub
    |}]
;;

let%expect_test "atomic rmw lowers to ldaxr/stlxr loop" =
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
  let asm = compile_and_lower_functions (String.Map.of_alist_exn [ "root", fn ]) in
  print_mnemonics_with_prefixes [ "ldaxr"; "stlxr" ] asm;
  [%expect
    {|
    ldaxr
    stlxr
    |}]
;;
