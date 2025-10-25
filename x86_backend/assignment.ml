open! Core
open! Import
open! Common

type t =
  | Spill
  | Reg of Reg.t
[@@deriving sexp, compare, hash, variants]
