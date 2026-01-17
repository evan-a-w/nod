open! Core

type t = int [@@deriving sexp, compare, hash, equal]

include functor Comparable.Make
include functor Hashable.Make

let to_string = Int.to_string
