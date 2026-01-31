open! Core
open! Import

type 'var address =
  { base : 'var Lit_or_var.t
  ; offset : int
  }
[@@deriving sexp, compare, equal, hash]

type 'var t =
  | Stack_slot of int (* bytes *)
  | Address of 'var address
  | Global of Global.t
[@@deriving sexp, compare, equal, hash]

val vars : 'var t -> 'var list
val map_vars : 'var t -> f:('var -> 'var2) -> 'var2 t

val map_lit_or_vars
  :  'var t
  -> f:('var Lit_or_var.t -> 'var2 Lit_or_var.t)
  -> 'var2 t

val address : ?offset:int -> 'var Lit_or_var.t -> 'var t
val to_x86_ir_operand : 'var t -> 'var X86_ir.operand
val to_arm64_ir_operand : 'var t -> 'var Arm64_ir.operand
