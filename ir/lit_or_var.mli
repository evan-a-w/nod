open! Core
open! Import

type 'var t =
  | Lit of Lit.t
  | Var of 'var
  | Global of Global.t
[@@deriving sexp, compare, equal, hash]

val vars : 'var t -> 'var list
val map_vars : 'var t -> f:('var -> 'var2) -> 'var2 t
val to_x86_ir_operand : 'var t -> 'var X86_ir.operand
val to_arm64_ir_operand : 'var t -> 'var Arm64_ir.operand
