open! Core

type t = Value_id of int [@@deriving sexp, compare, hash, equal] [@@unboxed]

include functor Comparable.Make
include functor Hashable.Make
