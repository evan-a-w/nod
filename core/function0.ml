open! Core
open! Import
include Nod_ir.Function

type 'a t' = (Typed_var.t, 'a) t [@@deriving sexp]
