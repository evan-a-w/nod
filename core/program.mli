open! Import
include module type of Nod_ir.Program

type 'a t' = (Typed_var.t, 'a) t [@@deriving sexp]
