open! Core
open! Import
module Asm = Nod_arm64_backend.Arm64_asm
module Peepholes = Nod_arm64_backend.Asm_peepholes
module Arm64_ir = Nod_ir.Arm64_ir
module Reg = Arm64_ir.Reg

let%test_unit "arm64 peephole: invert branch with fallthrough" =
  let items =
    [ Asm.Instr (Bcond { condition = Arm64_ir.Condition.Eq; target = "L1" })
    ; Asm.Instr (B "L2")
    ; Asm.Label "L1"
    ; Asm.Instr Ret
    ]
  in
  let expected =
    [ Asm.Instr (Bcond { condition = Arm64_ir.Condition.Ne; target = "L2" })
    ; Asm.Label "L1"
    ; Asm.Instr Ret
    ]
  in
  let optimized = Peepholes.optimize items in
  if not (List.equal Asm.equal_item optimized expected)
  then raise_s [%message (optimized : Asm.item list) (expected : Asm.item list)]
;;

let%test_unit "arm64 peephole: forward stack store/load" =
  let addr = Arm64_ir.Mem (Reg.sp, 8) in
  let items =
    [ Asm.Instr (Str { src = Arm64_ir.Reg Reg.x1; addr })
    ; Asm.Instr (Ldr { dst = Reg.x2; addr })
    ]
  in
  let expected =
    [ Asm.Instr (Str { src = Arm64_ir.Reg Reg.x1; addr })
    ; Asm.Instr (Mov { dst = Reg.x2; src = Arm64_ir.Reg Reg.x1 })
    ]
  in
  let optimized = Peepholes.optimize items in
  if not (List.equal Asm.equal_item optimized expected)
  then raise_s [%message (optimized : Asm.item list) (expected : Asm.item list)]
;;

let%test_unit "arm64 peephole: fold move into add" =
  let items =
    [ Asm.Instr (Mov { dst = Reg.x0; src = Arm64_ir.Reg Reg.x1 })
    ; Asm.Instr (Add { dst = Reg.x0; lhs = Reg.x0; rhs = Reg.x2 })
    ]
  in
  let expected =
    [ Asm.Instr (Add { dst = Reg.x0; lhs = Reg.x1; rhs = Reg.x2 }) ]
  in
  let optimized = Peepholes.optimize items in
  if not (List.equal Asm.equal_item optimized expected)
  then raise_s [%message (optimized : Asm.item list) (expected : Asm.item list)]
;;

let%test_unit "arm64 peephole: combine mul/sub to msub" =
  let items =
    [ Asm.Instr (Mul { dst = Reg.x0; lhs = Reg.x1; rhs = Reg.x2 })
    ; Asm.Instr (Sub { dst = Reg.x0; lhs = Reg.x3; rhs = Reg.x0 })
    ]
  in
  let expected =
    [ Asm.Instr
        (Msub { dst = Reg.x0; lhs = Reg.x1; rhs = Reg.x2; acc = Reg.x3 })
    ]
  in
  let optimized = Peepholes.optimize items in
  if not (List.equal Asm.equal_item optimized expected)
  then raise_s [%message (optimized : Asm.item list) (expected : Asm.item list)]
;;
