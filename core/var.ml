open! Core

type t =
  { name : string
  ; type_ : Type.t
  }
[@@deriving compare, equal, hash]

let sexp_of_t { name; type_ } =
  Sexp.List
    [ Sexp.List [ Sexp.Atom "name"; [%sexp (name : string)] ]
    ; Sexp.List [ Sexp.Atom "type_"; Type.sexp_of_t type_ ]
    ]
;;

let t_of_sexp sexp =
  match sexp with
  | Sexp.List
      [ Sexp.List [ Sexp.Atom "name"; name_sexp ]
      ; Sexp.List [ Sexp.Atom "type_"; type_sexp ]
      ] ->
    let name = [%of_sexp: string] name_sexp in
    let type_ = Type.t_of_sexp type_sexp in
    { name; type_ }
  | _ -> failwith "Var.t_of_sexp: unexpected shape"
;;

include functor Comparable.Make
include functor Hashable.Make

let create ~name ~type_ = { name; type_ }
let name t = t.name
let type_ t = t.type_
let map_name t ~f = { t with name = f t.name }
let with_type t type_ = { t with type_ }
let to_string = name
