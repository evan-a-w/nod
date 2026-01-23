open! Core

type t =
  { id : Value_id.t
  ; var : Var.t
  ; type_ : Type.t
  ; mutable def : Def_site.t
  ; mutable opt_tags : Opt_tags.t
  ; mutable uses : Instr_id.Set.t
  }
