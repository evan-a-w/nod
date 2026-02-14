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
[@@deriving fields]

let create ~id ~var ~type_ ~def ~opt_tags ~uses ~active =
  { id; var; type_; def; opt_tags; uses; active }
;;

let compare a b = Value_id.compare a.id b.id
let sexp_of_t t = Value_id.sexp_of_t t.id
let t_of_sexp _ = failwith "Value_state.t_of_sexp: unsupported"
let var t = t.var

module Expert = struct
  let set_def = set_def
  let set_opt_tags = set_opt_tags
  let set_uses = set_uses
  let set_active = set_active
end

include functor Comparable.Make
