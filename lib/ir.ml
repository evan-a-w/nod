open! Core

module Var = struct
  type t = string [@@deriving sexp, compare, equal]
end

module Lit = struct
  type t = int [@@deriving sexp, compare, equal]
end

module Lit_or_var = struct
  type t =
    | Lit of Lit.t
    | Var of Var.t
  [@@deriving sexp, compare, equal]
end

module Block_id =
  String_id.Make
    (struct
      let module_name = "Block_id"
    end)
    ()

type arith =
  { dest : Var.t
  ; src1 : Lit_or_var.t
  ; src2 : Lit_or_var.t
  }

module Call_block = struct
  type 'block t =
    { mutable block : 'block
    ; mutable args : Var.t list
    }
end

type 'block t =
  | Add of arith
  | Sub of arith
  | Mul of arith
  | Div of arith
  | Mod of arith
  | Move of Var.t * Lit_or_var.t
  | Branch of
      { cond : Lit_or_var.t
      ; if_true : 'block Call_block.t
      ; if_false : 'block Call_block.t
      }
  | Unreachable
