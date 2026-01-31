open! Core
open! Import
include Nod_ir.Function

type 'a t' = (Typed_var.t, 'a) t [@@deriving sexp]
type t = Block.t t'

let to_sexp_verbose t =
  let t' = map_root t ~f:Block.to_sexp_verbose in
  [%sexp (t' : Sexp.t t')]
;;

let sexp_of_t = to_sexp_verbose
let print_verbose t = print_s (to_sexp_verbose t)
