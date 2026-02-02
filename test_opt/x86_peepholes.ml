open! Core
open! Import
module Asm = Nod_x86_backend.X86_asm
module Peepholes = Nod_x86_backend.Asm_peepholes
module X86_ir = Nod_ir.X86_ir
module Reg = X86_ir.Reg

let%test_unit "x86 peephole: swap via temp" =
  let items =
    [ Asm.Instr (Mov (X86_ir.Reg Reg.r10, X86_ir.Reg Reg.rax))
    ; Asm.Instr (Mov (X86_ir.Reg Reg.rax, X86_ir.Reg Reg.rbx))
    ; Asm.Instr (Mov (X86_ir.Reg Reg.rbx, X86_ir.Reg Reg.r10))
    ]
  in
  let expected =
    [ Asm.Instr (Xchg (X86_ir.Reg Reg.rax, X86_ir.Reg Reg.rbx))
    ; Asm.Instr (Mov (X86_ir.Reg Reg.r10, X86_ir.Reg Reg.rbx))
    ]
  in
  let optimized = Peepholes.optimize items in
  if not (List.equal Asm.equal_item optimized expected)
  then raise_s [%message (optimized : Asm.item list) (expected : Asm.item list)]
;;

let%test_unit "x86 peephole: invert branch with fallthrough" =
  let items =
    [ Asm.Instr (Je "L1"); Asm.Instr (Jmp "L2"); Asm.Label "L1"; Asm.Instr Ret ]
  in
  let expected = [ Asm.Instr (Jne "L2"); Asm.Label "L1"; Asm.Instr Ret ] in
  let optimized = Peepholes.optimize items in
  if not (List.equal Asm.equal_item optimized expected)
  then raise_s [%message (optimized : Asm.item list) (expected : Asm.item list)]
;;

let%test_unit "x86 peephole: forward stack store/load" =
  let addr = X86_ir.Mem (Reg.rsp, -8) in
  let items =
    [ Asm.Instr (Mov (addr, X86_ir.Reg Reg.rax))
    ; Asm.Instr (Mov (X86_ir.Reg Reg.rbx, addr))
    ]
  in
  let expected =
    [ Asm.Instr (Mov (addr, X86_ir.Reg Reg.rax))
    ; Asm.Instr (Mov (X86_ir.Reg Reg.rbx, X86_ir.Reg Reg.rax))
    ]
  in
  let optimized = Peepholes.optimize items in
  if not (List.equal Asm.equal_item optimized expected)
  then raise_s [%message (optimized : Asm.item list) (expected : Asm.item list)]
;;

let%test_unit "x86 peephole: push/pop to mov" =
  let items =
    [ Asm.Instr (Push (X86_ir.Reg Reg.rax)); Asm.Instr (Pop Reg.rbx) ]
  in
  let expected = [ Asm.Instr (Mov (X86_ir.Reg Reg.rbx, X86_ir.Reg Reg.rax)) ] in
  let optimized = Peepholes.optimize items in
  if not (List.equal Asm.equal_item optimized expected)
  then raise_s [%message (optimized : Asm.item list) (expected : Asm.item list)]
;;
