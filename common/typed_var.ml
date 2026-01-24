open! Core

type 't t =
  { name : string
  ; type_ : 't
  }
[@@deriving sexp, compare, equal, hash]

let create ~name ~type_ = { name; type_ }
