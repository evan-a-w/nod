open! Core
open! Import
module Reg = Arm64_reg

type symbol =
  { name : string
  ; asm_label : string
  }
[@@deriving sexp, equal]

type instr =
  | Mov of
      { dst : Reg.t
      ; src : Arm64_ir.operand
      }
  | Ldr of
      { dst : Reg.t
      ; addr : Arm64_ir.operand
      }
  | Str of
      { src : Arm64_ir.operand
      ; addr : Arm64_ir.operand
      }
  | Dmb
  | Ldar of
      { dst : Reg.t
      ; addr : Arm64_ir.operand
      }
  | Stlr of
      { src : Arm64_ir.operand
      ; addr : Arm64_ir.operand
      }
  | Ldaxr of
      { dst : Reg.t
      ; addr : Arm64_ir.operand
      }
  | Stlxr of
      { status : Reg.t
      ; src : Arm64_ir.operand
      ; addr : Arm64_ir.operand
      }
  | Casal of
      { expected : Reg.t
      ; desired : Reg.t
      ; addr : Arm64_ir.operand
      }
  | Add of
      { dst : Reg.t
      ; lhs : Reg.t
      ; rhs : Reg.t
      }
  | Sub of
      { dst : Reg.t
      ; lhs : Reg.t
      ; rhs : Reg.t
      }
  | Mul of
      { dst : Reg.t
      ; lhs : Reg.t
      ; rhs : Reg.t
      }
  | Sdiv of
      { dst : Reg.t
      ; lhs : Reg.t
      ; rhs : Reg.t
      }
  | Msub of
      { dst : Reg.t
      ; lhs : Reg.t
      ; rhs : Reg.t
      ; acc : Reg.t
      }
  | And of
      { dst : Reg.t
      ; lhs : Reg.t
      ; rhs : Reg.t
      }
  | Orr of
      { dst : Reg.t
      ; lhs : Reg.t
      ; rhs : Reg.t
      }
  | Eor of
      { dst : Reg.t
      ; lhs : Reg.t
      ; rhs : Reg.t
      }
  | Lsl of
      { dst : Reg.t
      ; lhs : Reg.t
      ; rhs : Reg.t
      }
  | Lsr of
      { dst : Reg.t
      ; lhs : Reg.t
      ; rhs : Reg.t
      }
  | Asr of
      { dst : Reg.t
      ; lhs : Reg.t
      ; rhs : Reg.t
      }
  | Fadd of
      { dst : Reg.t
      ; lhs : Reg.t
      ; rhs : Reg.t
      }
  | Fsub of
      { dst : Reg.t
      ; lhs : Reg.t
      ; rhs : Reg.t
      }
  | Fmul of
      { dst : Reg.t
      ; lhs : Reg.t
      ; rhs : Reg.t
      }
  | Fdiv of
      { dst : Reg.t
      ; lhs : Reg.t
      ; rhs : Reg.t
      }
  | Scvtf of
      { dst : Reg.t
      ; src : Reg.t
      }
  | Fcvtzs of
      { dst : Reg.t
      ; src : Reg.t
      }
  | Fmov of
      { dst : Reg.t
      ; src : Arm64_ir.operand
      }
  | Cmp of
      { lhs : Arm64_ir.operand
      ; rhs : Arm64_ir.operand
      }
  | Fcmp of
      { lhs : Arm64_ir.operand
      ; rhs : Arm64_ir.operand
      }
  | Adr of
      { dst : Reg.t
      ; target : Arm64_ir.Jump_target.t
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
