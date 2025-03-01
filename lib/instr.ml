open! Core

module type S = sig
  type t

  val defs : t -> string list
  val uses : t -> string list
  val map_uses : t -> f:(string -> string) -> t
  val map_defs : t -> f:(string -> string) -> t
end
