open! Core

let next_uid = ref 0

let fresh_uid () =
  let uid = !next_uid in
  incr next_uid;
  uid
;;

type t =
  { uid : int
  ; id_hum : string
  ; mutable args : Var.t Vec.t
  ; parents : t Vec.t
  ; children : t Vec.t
  ; mutable instructions : t Ssa_instr.t option
  ; mutable terminal : t Ssa_instr.t
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
  [%sexp { id_hum : string; args : Var.t Vec.t }]
;;

let create ~id_hum ~terminal =
  { uid = fresh_uid ()
  ; id_hum
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
    let rec go = function
      | None -> ()
      | Some instr ->
        f instr.Ssa_instr.ir;
        go instr.Ssa_instr.next
    in
    go block.instructions;
    f block.terminal.ir)
;;

let to_sexp_verbose root =
  let ts = Vec.create () in
  iter root ~f:(fun t ->
    let instrs =
      let rec go acc = function
        | None -> List.rev acc
        | Some instr -> go (instr.Ssa_instr.ir :: acc) instr.Ssa_instr.next
      in
      go [] t.instructions @ [ t.terminal.ir ]
    in
    Vec.push
      ts
      [%message t.id_hum ~args:(t.args : Var.t Vec.t) (instrs : t Ir0.t list)]);
  [%sexp (ts : Sexp.t Vec.t)]
;;

let instrs_to_list t =
  let rec go acc = function
    | None -> List.rev acc
    | Some instr -> go (instr :: acc) instr.Ssa_instr.next
  in
  go [] t.instructions
;;

let instrs_to_ir_list t =
  let rec go acc = function
    | None -> List.rev acc
    | Some instr -> go (instr.Ssa_instr.ir :: acc) instr.Ssa_instr.next
  in
  go [] t.instructions
;;

let iter_instrs t ~f =
  let rec go = function
    | None -> ()
    | Some instr ->
      f instr;
      go instr.Ssa_instr.next
  in
  go t.instructions
;;

let append_instr t instr =
  instr.Ssa_instr.prev <- None;
  instr.Ssa_instr.next <- None;
  match t.instructions with
  | None -> t.instructions <- Some instr
  | Some head ->
    let rec last curr =
      match curr.Ssa_instr.next with
      | None -> curr
      | Some next -> last next
    in
    let tail = last head in
    tail.Ssa_instr.next <- Some instr;
    instr.Ssa_instr.prev <- Some tail
;;

let unlink_instr t instr =
  (match instr.Ssa_instr.prev with
   | None -> t.instructions <- instr.Ssa_instr.next
   | Some prev -> prev.Ssa_instr.next <- instr.Ssa_instr.next);
  (match instr.Ssa_instr.next with
   | None -> ()
   | Some next -> next.Ssa_instr.prev <- instr.Ssa_instr.prev);
  instr.Ssa_instr.prev <- None;
  instr.Ssa_instr.next <- None
;;

module Pair = struct
  type nonrec t = t * t [@@deriving compare, hash, sexp]

  include functor Comparable.Make
  include functor Hashable.Make
end
