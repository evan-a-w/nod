open! Core
include Function0

type 'extra t = (Block.t, 'extra) t'

let to_sexp_verbose sexp_of_a t =
  let t' = map_root t ~f:Block.to_sexp_verbose in
  [%sexp (t' : (Sexp.t, a) t')]
;;

let print_verbose sexp_of_a t = print_s (to_sexp_verbose sexp_of_a t)
