open Core
open Ir

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
