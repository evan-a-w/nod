open! Core

module type S = sig
  type t [@@deriving equal]

  val is_comment : t -> bool
end
