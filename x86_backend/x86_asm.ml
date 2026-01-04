open! Core
open! Import
module Reg = X86_reg

type symbol =
  { name : string
  ; asm_label : string
  }
[@@deriving sexp, equal]

type instr =
  | Mov of operand * operand
  | Movsd of operand * operand
  | Movq of operand * operand
  | Cvtsi2sd of operand * operand
  | Cvttsd2si of operand * operand
  | Add of operand * operand
  | Sub of operand * operand
  | Addsd of operand * operand
  | Subsd of operand * operand
  | Mulsd of operand * operand
  | Divsd of operand * operand
  | And of operand * operand
  | Or of operand * operand
  | Imul of operand
  | Idiv of operand
  | Mod of operand
  | Cmp of operand * operand
  | Call of symbol
  | Push of operand
  | Pop of Reg.t
  | Jmp of string
  | Je of string
  | Jne of string
  | Ret
[@@deriving sexp, equal]

type item =
  | Label of string
  | Instr of instr
[@@deriving sexp, equal]

type fn =
  { name : string
  ; asm_label : string
  ; items : item list
  }
[@@deriving sexp, equal]

type program = fn list [@@deriving sexp, equal]
