open! Core

let ir_to_x86_ir (ir : Ir.t) =
  let open X86_ir in
  let operand_of_lit_or_var (lit_or_var : Ir.Lit_or_var.t) =
    match lit_or_var with
    | Lit l -> Imm l
    | Var v -> Reg (Reg.unallocated v)
  in
  let make_arith f ({ dest; src1; src2 } : Ir.arith) =
    let dest = Reg (Reg.unallocated dest) in
    [ mov dest (operand_of_lit_or_var src1)
    ; f dest (operand_of_lit_or_var src2)
    ]
  in
  let reg v = Reg (Reg.unallocated v) in
  let mul_div_mod ({ dest; src1; src2 } : Ir.arith) ~make_instr ~take_reg =
    [ mov (Reg Reg.rax) (Ir.Lit_or_var.to_x86_ir_operand src1)
    ; make_instr (Ir.Lit_or_var.to_x86_ir_operand src2)
    ; mov (reg dest) (Reg take_reg)
    ]
  in
  match ir with
  | X86 x -> [ x ]
  | Noop | Unreachable -> []
  | And arith -> make_arith and_ arith
  | Or arith -> make_arith or_ arith
  | Add arith -> make_arith add arith
  | Sub arith -> make_arith sub arith
  | Return lit_or_var -> [ RET (operand_of_lit_or_var lit_or_var) ]
  | Move (v, lit_or_var) -> [ mov (reg v) (operand_of_lit_or_var lit_or_var) ]
  | Load (v, mem) -> [ mov (reg v) (Ir.Mem.to_x86_ir_operand mem) ]
  | Store (lit_or_var, mem) ->
    [ mov
        (Ir.Mem.to_x86_ir_operand mem)
        (Ir0.Lit_or_var.to_x86_ir_operand lit_or_var)
    ]
  | Mul arith -> mul_div_mod arith ~take_reg:Reg.rax ~make_instr:imul
  | Div arith -> mul_div_mod arith ~take_reg:Reg.rax ~make_instr:idiv
  | Mod arith -> mul_div_mod arith ~take_reg:Reg.rdx ~make_instr:mod_
  | Branch (Uncond cb) -> [ jmp cb ]
  | Branch (Cond { cond; if_true; if_false }) ->
    [ cmp (operand_of_lit_or_var cond) (Imm Int64.zero)
    ; jne if_true (Some if_false)
    ]
;;
