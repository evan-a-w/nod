open! Core

type t = Default [@@deriving sexp, compare, equal, hash, variants]
