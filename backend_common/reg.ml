open! Core
open! Import

module type S = sig
  module Class : sig
    type t [@@deriving sexp, compare, hash, equal, enumerate]
  end

  module Raw : sig
    type t [@@deriving sexp, compare, hash, equal]

    val to_physical : t -> t option
    val should_save : t -> t option
    val class_ : t -> [ `Physical of Class.t | `Variable ]
    val to_id : var_id:(Var.t -> int) -> t -> int
    val of_id : id_var:(int -> Var.t) -> int -> t
  end

  type t [@@deriving sexp, compare, hash, equal]

  val create : class_:Class.t -> raw:Raw.t -> t
  val class_ : t -> Class.t
  val raw : t -> Raw.t
  val callee_saved : call_conv:Call_conv.t -> Class.t -> t list
  val allocable : class_:Class.t -> t list

  include Comparable.S with type t := t
end
