open! Core

type t =
  { name : string
  ; type_ : Type.t
  }
[@@deriving compare, equal, hash, sexp]

include functor Comparable.Make
include functor Hashable.Make

let create ~name ~type_ = { name; type_ }
let name t = t.name
let type_ t = t.type_
let map_name t ~f = { t with name = f t.name }
let with_type t type_ = { t with type_ }
let to_string = name
