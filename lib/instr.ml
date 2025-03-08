open! Core

module type S = sig
  type t

  val defs : t -> string list
  val uses : t -> string list
  val add_block_args : t -> t
  val map_uses : t -> f:(string -> string) -> t
  val map_defs : t -> f:(string -> string) -> t
end
