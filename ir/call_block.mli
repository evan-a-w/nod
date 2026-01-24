open! Core

type ('var, 'block) t =
  { block : 'block
  ; args : 'var list
  }
[@@deriving sexp, compare, equal, fields]

val blocks : ('var, 'block) t -> 'block list
val map_uses : ('var, 'block) t -> f:('var -> 'var2) -> ('var2, 'block) t
val map_blocks : ('var, 'block) t -> f:('block -> 'block2) -> ('var, 'block2) t
val uses : ('var, 'block) t -> 'var list
