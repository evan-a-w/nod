open! Core

module type S = sig
  module Instr : Instr.S

  type t =
    { mutable args : string Vec.t
    ; parents : t Vec.t
    ; children : t Vec.t
    ; mutable instructions : Instr.t Vec.t
    ; mutable terminal : Instr.t
    ; mutable dfs_id : int option
    }
  [@@deriving fields, compare, hash, sexp]

  val id_exn : t -> int

  include Comparable.S with type t := t
  include Hashable.S with type t := t

  module Pair : sig
    type nonrec t = t * t [@@deriving compare, hash, sexp]

    include Comparable.S with type t := t
    include Hashable.S with type t := t
  end
end

module Make (Instr : Instr.S) : S with module Instr = Instr = struct
  module Instr = Instr

  module T = struct
    type t =
      { mutable args : string Vec.t
      ; parents : t Vec.t
      ; children : t Vec.t
      ; mutable instructions : Instr.t Vec.t
      ; mutable terminal : Instr.t
      ; mutable dfs_id : int option
      }
    [@@deriving fields]

    let id_exn t = Option.value_exn t.dfs_id
    let compare t1 t2 = id_exn t1 - id_exn t2
    let hash_fold_t s t = Int.hash_fold_t s (Option.value_exn t.dfs_id)
    let hash t = Int.hash (Option.value_exn t.dfs_id)
    let t_of_sexp _ = failwith ":()"
    let sexp_of_t t = Sexp.Atom (Int.to_string (Option.value_exn t.dfs_id))
  end

  include T
  include Comparable.Make (T)
  include Hashable.Make (T)

  module Pair = struct
    module T = struct
      type nonrec t = t * t [@@deriving compare, hash, sexp]
    end

    include T
    include Comparable.Make (T)
    include Hashable.Make (T)
  end
end
