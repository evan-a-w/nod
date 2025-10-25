open! Core

type t =
  | All
  | Known_x86 of X86_ir.Reg.Set.t
[@@deriving sexp, equal, compare, variants]
