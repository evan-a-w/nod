open! Core
open! Import
include module type of Nod_ir.Function

type 'a t' = (Typed_var.t, 'a) t [@@deriving sexp]
type t = Block.t t' [@@deriving sexp_of]

val to_sexp_verbose : t -> Sexp.t
val print_verbose : t -> unit
