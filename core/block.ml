open! Core

type t =
  { id_hum : string
  ; mutable args : Var.t Vec.t
  ; parents : t Vec.t
  ; children : t Vec.t
  ; mutable instructions : t Instr_state.t option
  ; mutable terminal : t Instr_state.t
  ; mutable dfs_id : int option
  ; mutable insert_phi_moves : bool
  }
[@@deriving fields]

let args t = args t |> Vec.read
let id_exn t = Option.value_exn t.dfs_id
let compare t1 t2 = id_exn t1 - id_exn t2
let hash_fold_t s t = Int.hash_fold_t s (Option.value_exn t.dfs_id)
let hash t = Int.hash (Option.value_exn t.dfs_id)
let t_of_sexp _ = failwith ":()"

let sexp_of_t t =
  let id_hum = t.id_hum in
  let args = t.args in
  [%sexp { id_hum : string; args : Var.t Vec.t }]
;;

let create ~id_hum ~terminal =
  { id_hum
  ; args = Vec.create ()
  ; parents = Vec.create ()
  ; children = Vec.create ()
  ; instructions = None
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

let to_list root =
  let res = ref [] in
  iter root ~f:(fun block -> res := block :: !res);
  List.rev !res
;;

let iter_and_update_bookkeeping root ~f =
  let rec go block =
    match dfs_id block with
    | None -> ()
    | Some _ ->
      set_dfs_id block None;
      f block;
      let children =
        Ir0.call_blocks block.terminal.ir
        |> List.map ~f:Call_block.block
        |> Vec.of_list
      in
      Vec.clear block.parents;
      Vec.switch block.children children;
      Vec.iter block.children ~f:go
  in
  go root;
  let i = ref 0 in
  let rec go block =
    match dfs_id block with
    | Some _ -> ()
    | None ->
      set_dfs_id block (Some !i);
      incr i;
      Vec.iter block.children ~f:(fun child ->
        Vec.push child.parents block;
        go child)
  in
  go root
;;

let iter_instructions t ~f =
  iter t ~f:(fun block ->
    Instr_state.iter block.instructions ~f;
    f block.terminal)
;;

let to_sexp_verbose root =
  let ts = Vec.create () in
  iter root ~f:(fun t ->
    let instrs = Instr_state.to_list t.instructions @ [ t.terminal ] in
    Vec.push
      ts
      [%message
        t.id_hum ~args:(t.args : Var.t Vec.t) (instrs : t Instr_state.t list)]);
  [%sexp (ts : Sexp.t Vec.t)]
;;

module Pair = struct
  type nonrec t = t * t [@@deriving compare, hash, sexp]

  include functor Comparable.Make
  include functor Hashable.Make
end

module Expert = struct
  let set_terminal = set_terminal
  let set_instructions = set_instructions
  let set_args = set_args
  let set_insert_phi_moves = set_insert_phi_moves

  let add_child t ~child =
    Vec.push t.children child;
    Vec.push child.parents t
  ;;

  let add_parent t ~parent = add_child parent ~child:t
  let children = children
  let parents = parents
end

let children t = children t |> Vec.read
let parents t = parents t |> Vec.read
