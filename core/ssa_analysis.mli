open! Core
open! Import

module Dominance : sig
  type t

  val create : fn_state:Fn_state.t -> Block.t -> t
  val fn_state : t -> Fn_state.t

  (* Returns the dominance frontier of [block] as concrete blocks. *)
  val frontier_blocks : t -> block:Block.t -> Block.t list

  (* Map from each block to the set of blocks it immediately dominates. *)
  val idom_tree : t -> Block.Hash_set.t Block.Table.t
end

module Def_use : sig
  type t

  val create : fn_state:Fn_state.t -> Block.t -> t
  val fn_state : t -> Fn_state.t
  val root : t -> Block.t
  val vars : t -> Typed_var.Hash_set.t
  val defs : t -> Block.Hash_set.t Typed_var.Table.t
  val uses : t -> Block.Hash_set.t Typed_var.Table.t

  (* Dominance information backing this analysis. *)
  val dominance : t -> Dominance.t

  (* Convenience wrapper over [Dominance.frontier_blocks]. *)
  val df : t -> block:Block.t -> Block.t list
end
