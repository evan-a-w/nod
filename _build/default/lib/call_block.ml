open! Core

type 'block t =
  { mutable block : 'block
  ; args : Var.t list
  }
[@@deriving sexp, compare, equal, fields]

let hash_fold_t (type block) hash_fold_block st t =
  [%hash_fold: block * Var.t list] st (t.block, t.args)
;;

let hash (type block) hash_fold_block t =
  [%hash: block * Var.t list] (t.block, t.args)
;;

let blocks { block; _ } = [ block ]
let map_uses t ~f = { t with args = List.map t.args ~f }
let map_blocks t ~f = { t with block = f t.block }
let uses = args
