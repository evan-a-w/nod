open! Core

type t [@@deriving compare, hash, sexp, equal]

include Comparable.S with type t := t
include Hashable.S with type t := t

val id_exn : t -> int
val id_hum : t -> string
val dfs_id : t -> int option
val set_dfs_id : t -> int option -> unit
val create : id_hum:string -> terminal:t Instr_state.t -> t
val iter : t -> f:(t -> unit) -> unit
val to_list : t -> t list
val iter_and_update_bookkeeping : t -> f:(t -> unit) -> unit
val iter_instructions : t -> f:(t Instr_state.t -> unit) -> unit
val instructions : t -> t Instr_state.t option
val terminal : t -> t Instr_state.t
val args : t -> Var.t Vec.t
val insert_phi_moves : t -> bool
val to_sexp_verbose : t -> Sexp.t
val children : t -> t Vec.t
val parents : t -> t Vec.t

(** doesn't keep in track var state etc. *)
module Expert : sig
  val set_terminal : t -> t Instr_state.t -> unit
  val set_instructions : t -> t Instr_state.t option -> unit
  val set_args : t -> Var.t Vec.t -> unit
  val set_insert_phi_moves : t -> bool -> unit
end

module Pair : sig
  type nonrec t = t * t

  include Comparable.S with type t := t
  include Hashable.S with type t := t
end
