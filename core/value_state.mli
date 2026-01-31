open! Core
open! Import

type t = private
  { id : Value_id.t
  ; var : Typed_var.t
  ; type_ : Type.t
  ; mutable def : Def_site.t
  ; mutable opt_tags : Opt_tags.t
  ; mutable uses : Instr_id.Set.t
  ; mutable active : bool
  }
[@@deriving sexp]

val create
  :  id:Value_id.t
  -> var:Typed_var.t
  -> type_:Type.t
  -> def:Def_site.t
  -> opt_tags:Opt_tags.t
  -> uses:Instr_id.Set.t
  -> active:bool
  -> t

val compare : t -> t -> int
val equal : t -> t -> bool
val var : t -> Typed_var.t

(** should only be used by [Fn_state] *)
module Expert : sig
  val set_def : t -> Def_site.t -> unit
  val set_opt_tags : t -> Opt_tags.t -> unit
  val set_uses : t -> Instr_id.Set.t -> unit
  val set_active : t -> bool -> unit
end

include Comparable.S with type t := t
