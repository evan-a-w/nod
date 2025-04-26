module type S = sig
  type elt
  type t

  val union : t -> t -> t
  val add : t -> elt -> t
  val remove : t -> elt -> t
  val mem : t -> elt -> bool
  val diff : t -> t -> t
  val intersect : t -> t -> t
end
