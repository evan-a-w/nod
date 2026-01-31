open! Core
open! Import

type t =
  { id : Value_id.t
  ; var : Typed_var.t
  ; type_ : Type.t
  ; mutable def : Def_site.t
  ; mutable opt_tags : Opt_tags.t
  ; mutable uses : Instr_id.Set.t
  ; mutable active : bool
  }

let compare a b = Value_id.compare a.id b.id
let equal a b = Value_id.equal a.id b.id
let hash t = Value_id.hash t.id
let sexp_of_t t = Value_id.sexp_of_t t.id
let t_of_sexp _ = failwith "Value_state.t_of_sexp: unsupported"
let var t = t.var

module Set = Set.Make (struct
    type nonrec t = t

    let compare = compare
    let sexp_of_t = sexp_of_t
    let t_of_sexp = t_of_sexp
  end)

module Map = Map.Make (struct
    type nonrec t = t

    let compare = compare
    let sexp_of_t = sexp_of_t
    let t_of_sexp = t_of_sexp
  end)

module Hash_set = Hash_set.Make (struct
    type nonrec t = t

    let compare = compare
    let hash = hash
    let sexp_of_t = sexp_of_t
    let t_of_sexp = t_of_sexp
  end)
