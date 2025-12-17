open! Core
open! Import

module type S = sig
  module Class : sig
    type t [@@deriving enumerate]
  end

  module Raw : sig
    type t
  end

  type t [@@deriving sexp, compare, hash, equal]

  val should_save : t -> bool
  val all_physical : t list
  val is_physical : t -> bool
  val to_id : var_id:(Var.t -> int) -> t -> int
  val of_id : id_var:(int -> Var.t) -> int -> t
  val class_ : t -> Class.t
  val raw : t -> Raw.t
  val callee_saved : call_conv:Call_conv.t -> Class.t -> t list

  include Comparable.S with type t := t
end
