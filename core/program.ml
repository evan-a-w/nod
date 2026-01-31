open! Import
include Nod_ir.Program

type 'a t' = (Typed_var.t, 'a) t [@@deriving sexp]
