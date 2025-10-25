open! Core

type t =
  | I8
  | I16
  | I32
  | I64
  | F32
  | F64
  | Ptr
[@@deriving sexp, compare, equal, variants]
