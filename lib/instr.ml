open! Core

module type S = sig
  type t [@@deriving sexp, compare, hash]

  val def : t -> string option
  val uses : t -> string list

  (** Lookup the args that the block takes, and add them to branch instrs *)
  val add_block_args : t -> t

  val map_uses : t -> f:(string -> string) -> t
  val map_defs : t -> f:(string -> string) -> t
end
