open! Core
open! Import
module Reg = Arm64_reg

type symbol =
  { name : string
  ; asm_label : string
  }
[@@deriving sexp, equal]

type operand = unit Arm64_ir.operand [@@deriving sexp, equal]
type reg = unit Arm64_reg.t [@@deriving sexp, equal]
type jump_target = unit Arm64_ir.Jump_target.t [@@deriving sexp, equal]

type instr =
  | Mov of
      { dst : reg
      ; src : operand
      }
  | Ldr of
      { dst : reg
      ; addr : operand
      }
  | Str of
      { src : operand
      ; addr : operand
      }
  | Dmb
  | Ldar of
      { dst : reg
      ; addr : operand
      }
  | Stlr of
      { src : operand
      ; addr : operand
      }
  | Ldaxr of
      { dst : reg
      ; addr : operand
      }
  | Stlxr of
      { status : reg
      ; src : operand
      ; addr : operand
      }
  | Casal of
      { expected : reg
      ; desired : reg
      ; addr : operand
      }
  | Add of
      { dst : reg
      ; lhs : reg
      ; rhs : reg
      }
  | Sub of
      { dst : reg
      ; lhs : reg
      ; rhs : reg
      }
  | Mul of
      { dst : reg
      ; lhs : reg
      ; rhs : reg
      }
  | Sdiv of
      { dst : reg
      ; lhs : reg
      ; rhs : reg
      }
  | Msub of
      { dst : reg
      ; lhs : reg
      ; rhs : reg
      ; acc : reg
      }
  | And of
      { dst : reg
      ; lhs : reg
      ; rhs : reg
      }
  | Orr of
      { dst : reg
      ; lhs : reg
      ; rhs : reg
      }
  | Eor of
      { dst : reg
      ; lhs : reg
      ; rhs : reg
      }
  | Lsl of
      { dst : reg
      ; lhs : reg
      ; rhs : reg
      }
  | Lsr of
      { dst : reg
      ; lhs : reg
      ; rhs : reg
      }
  | Asr of
      { dst : reg
      ; lhs : reg
      ; rhs : reg
      }
  | Fadd of
      { dst : reg
      ; lhs : reg
      ; rhs : reg
      }
  | Fsub of
      { dst : reg
      ; lhs : reg
      ; rhs : reg
      }
  | Fmul of
      { dst : reg
      ; lhs : reg
      ; rhs : reg
      }
  | Fdiv of
      { dst : reg
      ; lhs : reg
      ; rhs : reg
      }
  | Scvtf of
      { dst : reg
      ; src : reg
      }
  | Fcvtzs of
      { dst : reg
      ; src : reg
      }
  | Fmov of
      { dst : reg
      ; src : operand
      }
  | Cmp of
      { lhs : operand
      ; rhs : operand
      }
  | Fcmp of
      { lhs : operand
      ; rhs : operand
      }
  | Cset of
      { condition : Arm64_ir.Condition.t
      ; dst : reg
      }
  | Adr of
      { dst : reg
      ; target : jump_target
      }
  | B of string
  | Bcond of
      { condition : Arm64_ir.Condition.t
      ; target : string
      }
  | Bl of symbol
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
