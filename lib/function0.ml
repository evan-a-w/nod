open! Core

type 'block t' =
  { call_conv : Call_conv.t
  ; root : 'block
  ; args : string list
  ; name : string
  }
[@@deriving sexp, compare, equal, hash, fields]

let map_root { name; root; call_conv; args } ~f =
  { name; call_conv; root = f root; args }
;;
