open! Core
open! Import

type init =
  | Zero
  | Int of Int64.t
  | Float of float
  | Aggregate of init list
[@@deriving sexp, compare, equal, hash]

type t =
  { name : string
  ; type_ : Type.t
  ; init : init
  }
[@@deriving sexp, compare, equal, hash]
