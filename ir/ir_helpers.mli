open! Core
open! Import

module Rmw_op : sig
  type t =
    | Xchg
    | Add
    | Sub
    | And
    | Or
    | Xor
  [@@deriving sexp, compare, equal, hash]
end

type 'var arith =
  { dest : 'var
  ; src1 : 'var Lit_or_var.t
  ; src2 : 'var Lit_or_var.t
  }
[@@deriving sexp, compare, equal, hash]

val map_arith_defs : 'var arith -> f:('var -> 'var2) -> 'var2 arith
val map_arith_uses : 'var arith -> f:('var -> 'var2) -> 'var2 arith

val map_arith_lit_or_vars
  :  'var arith
  -> f:('var Lit_or_var.t -> 'var2 Lit_or_var.t)
  -> 'var2 arith

type 'var alloca =
  { dest : 'var
  ; size : 'var Lit_or_var.t
  }
[@@deriving sexp, compare, equal, hash]

val map_alloca_defs : 'var alloca -> f:('var -> 'var2) -> 'var2 alloca
val map_alloca_uses : 'var alloca -> f:('var -> 'var2) -> 'var2 alloca

val map_alloca_lit_or_vars
  :  'var alloca
  -> f:('var Lit_or_var.t -> 'var Lit_or_var.t)
  -> 'var alloca

type 'var load_field =
  { dest : 'var
  ; base : 'var Lit_or_var.t
  ; type_ : Type.t
  ; indices : int list
  }
[@@deriving sexp, compare, equal, hash]

type 'var store_field =
  { base : 'var Lit_or_var.t
  ; src : 'var Lit_or_var.t
  ; type_ : Type.t
  ; indices : int list
  }
[@@deriving sexp, compare, equal, hash]

type 'var memcpy =
  { dest : 'var Lit_or_var.t
  ; src : 'var Lit_or_var.t
  ; type_ : Type.t
  }
[@@deriving sexp, compare, equal, hash]

type 'var atomic_load =
  { dest : 'var
  ; addr : 'var Mem.t
  ; order : Memory_order.t
  }
[@@deriving sexp, compare, equal, hash]

type 'var atomic_store =
  { addr : 'var Mem.t
  ; src : 'var Lit_or_var.t
  ; order : Memory_order.t
  }
[@@deriving sexp, compare, equal, hash]

type 'var atomic_rmw =
  { dest : 'var
  ; addr : 'var Mem.t
  ; src : 'var Lit_or_var.t
  ; op : Rmw_op.t
  ; order : Memory_order.t
  }
[@@deriving sexp, compare, equal, hash]

type 'var atomic_cmpxchg =
  { dest : 'var
  ; success : 'var
  ; addr : 'var Mem.t
  ; expected : 'var Lit_or_var.t
  ; desired : 'var Lit_or_var.t
  ; success_order : Memory_order.t
  ; failure_order : Memory_order.t
  }
[@@deriving sexp, compare, equal, hash]

val map_load_field_defs : 'var load_field -> f:('var -> 'var) -> 'var load_field
val map_load_field_uses : 'var load_field -> f:('var -> 'var) -> 'var load_field

val map_load_field_lit_or_vars
  :  'var load_field
  -> f:('var Lit_or_var.t -> 'var Lit_or_var.t)
  -> 'var load_field

val map_store_field_uses
  :  'var store_field
  -> f:('var -> 'var)
  -> 'var store_field

val map_store_field_lit_or_vars
  :  'var store_field
  -> f:('var Lit_or_var.t -> 'var Lit_or_var.t)
  -> 'var store_field

val map_memcpy_uses : 'var memcpy -> f:('var -> 'var) -> 'var memcpy

val map_memcpy_lit_or_vars
  :  'var memcpy
  -> f:('var Lit_or_var.t -> 'var Lit_or_var.t)
  -> 'var memcpy

val map_atomic_load_defs
  :  'var atomic_load
  -> f:('var -> 'var)
  -> 'var atomic_load

val map_atomic_load_uses
  :  'var atomic_load
  -> f:('var -> 'var)
  -> 'var atomic_load

val map_atomic_store_uses
  :  'var atomic_store
  -> f:('var -> 'var)
  -> 'var atomic_store

val map_atomic_store_lit_or_vars
  :  'var atomic_store
  -> f:('var Lit_or_var.t -> 'var Lit_or_var.t)
  -> 'var atomic_store

val map_atomic_rmw_defs : 'var atomic_rmw -> f:('var -> 'var) -> 'var atomic_rmw
val map_atomic_rmw_uses : 'var atomic_rmw -> f:('var -> 'var) -> 'var atomic_rmw

val map_atomic_rmw_lit_or_vars
  :  'var atomic_rmw
  -> f:('var Lit_or_var.t -> 'var Lit_or_var.t)
  -> 'var atomic_rmw

val map_atomic_cmpxchg_defs
  :  'var atomic_cmpxchg
  -> f:('var -> 'var)
  -> 'var atomic_cmpxchg

val map_atomic_cmpxchg_uses
  :  'var atomic_cmpxchg
  -> f:('var -> 'var)
  -> 'var atomic_cmpxchg

val map_atomic_cmpxchg_lit_or_vars
  :  'var atomic_cmpxchg
  -> f:('var Lit_or_var.t -> 'var Lit_or_var.t)
  -> 'var atomic_cmpxchg
