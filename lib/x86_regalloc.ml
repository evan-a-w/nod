open! Core
open! Ir
open! X86_ir

let free_regs =
  [ Reg.RAX; RBX; RCX; RDX; RSI; RDI; R8; R9; R10; R11; R12; R13; R14; R15 ]
;;

module Interval = struct
  module T = struct
    type t =
      { prio : int
      ; end_ : int
      ; start : int
      ; reg : Reg.t
      }
    [@@deriving sexp, equal, compare, hash]
  end

  include T
  include Comparable.Make (T)
  include Hashable.Make (T)
end

module Stack_slot = Int

module Stack_slots = struct
  type t =
    { mutable free_slots : Stack_slot.Set.t
    ; mutable alloc_from : Stack_slot.t
    }
  [@@deriving sexp]

  let alloc t =
    match Set.min_elt t.free_slots with
    | Some x ->
      t.free_slots <- Set.remove t.free_slots x;
      x
    | None ->
      t.alloc_from <- t.alloc_from + 1;
      t.alloc_from - 1
  ;;

  let free t ~slot = t.free_slots <- Set.add t.free_slots slot
  let create ~alloc_from = { free_slots = Stack_slot.Set.empty; alloc_from }
end

module Mapping = struct
  type t =
    | Reg of Reg.t
    | Stack_slot of Stack_slot.t
  [@@deriving sexp, compare, equal, hash]
end

module State = struct
  type t =
    { mutable free_regs : Reg.t list
    ; mappings : Mapping.t Var.Table.t
    ; mutable live_intervals : Var.t Interval.Map.t
    ; stack_slots : Stack_slots.t
    }
  [@@deriving sexp]

  let get_reg t =
    match t.free_regs with
    | [] -> None
    | reg :: rest ->
      t.free_regs <- rest;
      Some reg
  ;;

  let rec to_spill ~don't_spill ?current t =
    let ((interval, _) as res) =
      match current with
      | None -> Map.min_elt_exn t.live_intervals
      | Some x ->
        Map.closest_key t.live_intervals `Greater_than x |> Option.value_exn
    in
    if not (Set.mem don't_spill interval.reg)
    then (
      t.live_intervals <- Map.remove t.live_intervals interval;
      res)
    else to_spill ~don't_spill ~current:interval t
  ;;

  let get_reg_or_spill ~don't_spill t =
    match get_reg t with
    | Some x -> `Reg x
    | None ->
      let interval, var_to_spill = to_spill ~don't_spill t in
      let stack_slot = Stack_slots.alloc t.stack_slots in
      Hashtbl.set t.mappings ~key:var_to_spill ~data:(Stack_slot stack_slot);
      `Spill (MOV (Mem (RSP, -stack_slot), Reg interval.reg), interval.reg)
  ;;

  let create ~alloc_from =
    { free_regs
    ; mappings = Var.Table.create ()
    ; live_intervals = Interval.Map.empty
    ; stack_slots = Stack_slots.create ~alloc_from
    }
  ;;
end

(* let process ~stack_offset instrs = *)
(*   let state = State.create ~alloc_from:stack_offset in *)
(*   Vec.concat_map instrs ~f:(fun instr -> *)

(*       let uses' = uses instr in *)
(*       let defs' = defs instr in *)
(*       let both = (Set.union uses' defs') in *)
(*       let don't_spill = Set.filter_map (module Reg) both ~f:(fun this -> *)
(*           match Hashtbl.find state.mappings this with *)
(*           | Some (Reg r) -> Some r *)
(*           | Some (Stack_slot _) | None -> None *)
(*         ) in *)
(*       let allocs_this_time = Set.fold ~init:Var.Set.empty both ~f:(fun acc this -> *)
(*           match Hashtbl.find state.mappings this with *)
(*           | Some (Reg r) ->  *)

(*         ) *)

(*       in *)
(*        let new_mappings = uses instr |> Set.to_list |> List.map ~f:(fun use -> *)

(*         ) *)

(*     ) *)
(* ;; *)
