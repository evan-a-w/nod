open! Core

type ('var, 'block) t =
  { block : 'block
  ; args : 'var list
  }
[@@deriving sexp, compare, equal, fields, hash]

let blocks { block; _ } = [ block ]
let map_uses t ~f = { t with args = List.map t.args ~f }
let map_blocks t ~f = { t with block = f t.block }
let uses { args; _ } = args
