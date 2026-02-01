open! Core
open! Import

val simplify
  :  fn_state:Fn_state.t
  -> value:Value_state.t
  -> ir:(Value_state.t, Block.t) Nod_ir.Ir.t
  -> (Value_state.t, Block.t) Nod_ir.Ir.t option
