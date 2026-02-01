open! Core
open! Import

val simplify
  :  value:Value_state.t
  -> ir:(Value_state.t, Block.t) Nod_ir.Ir.t
  -> replace:((Value_state.t, Block.t) Nod_ir.Ir.t -> unit)
  -> bool
