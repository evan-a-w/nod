open! Core

type t = Instr_id of int [@@deriving sexp, compare, hash, equal] [@@unboxed]

include functor Comparable.Make
include functor Hashable.Make
