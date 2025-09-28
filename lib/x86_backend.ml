open! Core

let ir_to_x86_ir (ir : Ir.t) =
  let open X86_ir in
  let operand_of_lit_or_var (lit_or_var : Ir.Lit_or_var.t) =
    match lit_or_var with
    | Lit l -> Imm l
    | Var v -> Reg (Reg.unallocated v)
  in
  let make_arith f ({ dest; src1; src2 } : Ir0.arith) =
    let dest = Reg (Reg.unallocated dest) in
    [ mov dest (operand_of_lit_or_var src1)
    ; f dest (operand_of_lit_or_var src2)
    ]
  in
  match ir with
  | X86 x -> [ x ]
  | Noop | Unreachable -> []
  | And arith -> make_arith X86_ir.and_ arith
  | Or arith -> make_arith X86_ir.or_ arith
  | Add arith -> make_arith X86_ir.add arith
  | Sub arith -> make_arith X86_ir.sub arith
  | Return lit_or_var -> [ RET (operand_of_lit_or_var lit_or_var) ]
  | Move (v, lit_or_var) ->
    [ X86_ir.mov (Reg (Reg.unallocated v)) (operand_of_lit_or_var lit_or_var) ]
;;
(* | Mul arith -> make_arith X86_ir.mul arith *)

(* | Load of Var.t * Mem.t *)
(* | Store of Lit_or_var.t * Mem.t *)
(* | Move of Var.t * Lit_or_var.t *)
(* | Branch of 'block Branch.t *)
