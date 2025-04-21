open Core
open Ir

module Reg = struct
  type t =
    | Unallocated of Var.t
    | RBP
    | RSP
    | RAX
    | RBX
    | RCX
    | RDX
    | RSI
    | RDI
    | R8
    | R9
    | R10
    | R11
    | R12
    | R13
    | R14
    | R15
  [@@deriving sexp, equal, compare, hash]
end

type operand =
  | Reg of Reg.t
  | Imm of Int64.t
  | Mem of Reg.t * int (* [reg + disp] *)
[@@deriving sexp, equal, compare, hash]

type t =
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
[@@deriving sexp, equal, compare, hash]
