open! Ssa
open! Core
open! Import

type t = { constant : Int64.t option } [@@deriving sexp]

let empty = { constant = None }
