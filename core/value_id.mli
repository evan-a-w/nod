open! Core

type t = Value_id of int [@@deriving sexp, compare, hash, equal] [@@unboxed]

include Comparable.S with type t := t
include Hashable.S with type t := t
