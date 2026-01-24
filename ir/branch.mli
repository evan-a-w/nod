open! Core
open! Import

type ('var, 'block) t =
  | Cond of
      { cond : 'var Lit_or_var.t
      ; if_true : ('var, 'block) Call_block.t
      ; if_false : ('var, 'block) Call_block.t
      }
  | Uncond of ('var, 'block) Call_block.t
[@@deriving sexp, compare, equal, hash]

val filter_map_call_blocks
  :  ('var, 'block) t
  -> f:(('var, 'block) Call_block.t -> 'a option)
  -> 'a list

val constant_fold : ('var, 'block) t -> ('var, 'block) t
val blocks : ('var, 'block) t -> 'block list
val uses : ('var, 'block) t -> 'var list
val map_uses : ('var, 'block) t -> f:('var -> 'var2) -> ('var2, 'block) t
val map_blocks : ('var, 'block) t -> f:('block -> 'block2) -> ('var, 'block2) t
val iter_call_blocks : ('var, 'block) t -> f:(('var, 'block) Call_block.t -> unit) -> unit

val map_call_blocks
  :  ('var, 'block) t
  -> f:(('var, 'block) Call_block.t -> ('var, 'block2) Call_block.t)
  -> ('var, 'block2) t

val map_lit_or_vars
  :  ('var, 'block) t
  -> f:('var Lit_or_var.t -> 'var Lit_or_var.t)
  -> ('var, 'block) t
