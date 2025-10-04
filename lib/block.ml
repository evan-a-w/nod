open! Core

type t =
  { id_hum : string
  ; mutable args : string Vec.t
  ; parents : t Vec.t
  ; children : t Vec.t
  ; mutable instructions : t Ir0.t Vec.t
  ; mutable terminal : t Ir0.t
  ; mutable dfs_id : int option
  ; mutable insert_phi_moves : bool
  }
[@@deriving fields]

let id_exn t = Option.value_exn t.dfs_id
let compare t1 t2 = id_exn t1 - id_exn t2
let hash_fold_t s t = Int.hash_fold_t s (Option.value_exn t.dfs_id)
let hash t = Int.hash (Option.value_exn t.dfs_id)
let t_of_sexp _ = failwith ":()"

let sexp_of_t t =
  let id_hum = t.id_hum in
  let args = t.args in
  [%sexp { id_hum : string; args : string Vec.t }]
;;

let iter_and_set_dfs_ids root ~f =
  let i = ref 0 in
  let rec go block =
    match dfs_id block with
    | None ->
      set_dfs_id block (Some !i);
      incr i;
      f block;
      Vec.iter (children block) ~f:go
    | Some _ -> ()
  in
  go root
;;

let create ~id_hum ~terminal =
  { id_hum
  ; args = Vec.create ()
  ; parents = Vec.create ()
  ; children = Vec.create ()
  ; instructions = Vec.create ()
  ; terminal
  ; dfs_id = None
  ; insert_phi_moves = true
  }
;;

include functor Comparable.Make
include functor Hashable.Make

let iter root ~f =
  let seen = Hash_set.create () in
  let rec go block =
    match Core.Hash_set.mem seen block with
    | true -> ()
    | false ->
      Core.Hash_set.add seen block;
      f block;
      Vec.iter block.children ~f:go
  in
  go root
;;

module Pair = struct
  type nonrec t = t * t [@@deriving compare, hash, sexp]

  include functor Comparable.Make
  include functor Hashable.Make
end
