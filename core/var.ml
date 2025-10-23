open! Core

type t = string [@@deriving sexp, compare, equal, hash]

include functor Comparable.Make
include functor Hashable.Make

let of_string = Fn.id
let to_string = Fn.id
