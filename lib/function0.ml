open! Core

type ('block, 'extra) t' =
  { call_conv : Call_conv.t
  ; root : 'block
  ; args : string list
  ; name : string
  ; extra : 'extra
  }
[@@deriving sexp, compare, hash, fields]

let map_root { name; root; call_conv; args; extra } ~f =
  { name; call_conv; root = f root; args; extra }
;;

let iter_root { root; name = _; call_conv = _; args = _; extra = _ } ~f = f root
