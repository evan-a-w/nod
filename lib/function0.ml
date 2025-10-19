open! Core

type 'block t' =
  { call_conv : Call_conv.t
  ; mutable root : 'block [@hash.ignore]
  ; args : string list
  ; name : string
  ; mutable prologue : 'block option [@hash.ignore]
  ; mutable epilogue : 'block option [@hash.ignore]
  }
[@@deriving sexp, compare, equal, hash, fields]

let map_root { name; root; call_conv; args; prologue = _; epilogue = _ } ~f =
  { name; call_conv; root = f root; args; prologue = None; epilogue = None }
;;

let iter_root
  { root; name = _; call_conv = _; args = _; prologue = _; epilogue = _ }
  ~f
  =
  f root
;;
