open! Core
include Function0

type t = Block.t t'

let to_sexp_verbose t =
  let t' = map_root t ~f:Block.to_sexp_verbose in
  [%sexp (t' : Sexp.t t')]
;;

let print_verbose t = print_s (to_sexp_verbose t)
