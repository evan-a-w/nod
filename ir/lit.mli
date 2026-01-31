open! Core
open! Import

type t = Int64.t [@@deriving sexp, compare, equal, hash]
