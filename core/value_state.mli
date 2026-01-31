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
[@@deriving sexp]

val compare : t -> t -> int
val equal : t -> t -> bool
val var : t -> Typed_var.t

include Comparable.S with type t := t
