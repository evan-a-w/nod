open! Core

type t =
  { name : string
  ; type_ : Type.t
  }
[@@deriving sexp, compare, equal, hash, fields]

let create ~name ~type_ = { name; type_ }

include functor Comparable.Make
include functor Hashable.Make
