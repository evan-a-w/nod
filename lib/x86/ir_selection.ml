open Core
open Ir

(* Simple x86-64 instruction selection *)
module X86 = struct
  type reg =
    | Unallocated of Var.t
    | RAX
    | RBX
    | RCX
    | RDX
    | RSI
    | RDI
    | RBP
    | RSP
  [@@deriving sexp, compare, equal]

  type operand =
    | Reg of reg
    | Imm of Int64.t
    | Mem of reg * int (* [reg + disp] *)
  [@@deriving sexp]

  type insn =
    | MOV of operand * operand
    | ADD of operand * operand
    | SUB of operand * operand
    | MUL of operand * operand
    | IDIV of operand (* divide RAX by operand, result in RAX, RDX *)
    | LABEL of string
    | JMP of string
    | CMP of operand * operand
    | JE of string
    | JNE of string
    | RET of operand
  [@@deriving sexp]
end

module Codegen = struct
  open X86
  open Lit_or_var
  open Mem

  let reg_of_var (v : Var.t) : reg = Unallocated v

  let operand_of_lit_or_var = function
    | Lit n -> Imm n
    | Var v -> Reg (reg_of_var v)
  ;;

  let operand_of_mem = function
    | Stack_slot i -> Mem (RBP, -8 * i)
    | Lit_or_var lom -> operand_of_lit_or_var lom
  ;;

  (* Generate x86 instructions for a single IR instruction *)
  let sel_instr = function
    | Add { dest; src1; src2 } ->
      let rd = Reg (reg_of_var dest) in
      [ MOV (operand_of_lit_or_var src1, rd)
      ; ADD (operand_of_lit_or_var src2, rd)
      ]
    | Sub { dest; src1; src2 } ->
      let rd = Reg (reg_of_var dest) in
      [ MOV (operand_of_lit_or_var src1, rd)
      ; SUB (operand_of_lit_or_var src2, rd)
      ]
    | Mul { dest; src1; src2 } ->
      let rd = Reg (reg_of_var dest) in
      [ MOV (operand_of_lit_or_var src1, rd)
      ; MUL (operand_of_lit_or_var src2, rd)
      ]
    | Div { dest; src1; src2 } ->
      (* idiv uses RAX and RDX *)
      [ MOV (operand_of_lit_or_var src1, Reg RAX)
      ; CMP (Reg RAX, Reg RAX) (* clear RDX for signed division *)
      ; IDIV (operand_of_lit_or_var src2)
      ; MOV (Reg RAX, Reg (reg_of_var dest))
      ]
    | Mod { dest; src1; src2 } ->
      (* remainder after idiv is in RDX *)
      [ MOV (operand_of_lit_or_var src1, Reg RAX)
      ; CMP (Reg RAX, Reg RAX)
      ; IDIV (operand_of_lit_or_var src2)
      ; MOV (Reg RDX, Reg (reg_of_var dest))
      ]
    | Load (v, mem) ->
      let rd = Reg (reg_of_var v) in
      [ MOV (operand_of_mem mem, rd) ]
    | Store (val_, mem) ->
      [ MOV (operand_of_lit_or_var val_, operand_of_mem mem) ]
    | Move (v, src) -> MOV (operand_of_lit_or_var src, Reg (reg_of_var v)) :: []
    | Return rv -> [ MOV (operand_of_lit_or_var rv, Reg RAX); RET (Reg RAX) ]
    | Branch (Uncond b) -> [ JMP b.block.Block.id_hum ]
    | Branch (Cond { cond; if_true; if_false }) ->
      let c = operand_of_lit_or_var cond in
      [ CMP (c, Imm 0L)
      ; JNE if_true.block.Block.id_hum
      ; JMP if_false.block.Block.id_hum
      ]
    | Noop -> []
    | Unreachable -> []
  ;;

  (* Compile a block to x86 instructions *)
  let compile_block (blk : Block.t) : insn list =
    let label = LABEL blk.id_hum in
    let body = Vec.to_list blk.instructions |> List.concat_map ~f:sel_instr in
    let term = sel_instr blk.terminal in
    (label :: body) @ term
  ;;

  (* Compile whole CFG *)
  let compile_cfg (blocks : Block.t Vec.t) : insn list =
    Vec.to_list blocks |> List.concat_map ~f:compile_block
  ;;
end
