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
    if not (Set.mem !don't_spill interval.reg)
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

let process ~stack_offset instrs =
  let state = State.create ~alloc_from:stack_offset in
  Vec.concat_map instrs ~f:(fun instr ->
    let uses' = uses instr in
    let defs' = defs instr in
    let both = Set.union uses' defs' in
    let find_reg_mapping var =
      match Hashtbl.find state.mappings var with
      | Some (Reg r) -> Some r
      | Some (Stack_slot _) | None -> None
    in
    let uses_need_reg =
      Set.filter uses' ~f:(Fn.compose Option.is_some find_reg_mapping)
    in
    let defs_need_reg =
      Set.diff defs' uses'
      |> Set.filter ~f:(Fn.compose Option.is_some find_reg_mapping)
    in
    let don't_spill =
      ref (Set.filter_map (module Reg) both ~f:find_reg_mapping)
    in
    (* TODO: actually set intervals for the allocs we do *)
    let spills_and_loads_for_uses =
      (Set.to_list uses_need_reg |> List.map ~f:(fun x -> x, `Use))
      @ (Set.to_list defs_need_reg |> List.map ~f:(fun x -> x, `Def))
      |> List.map ~f:(fun (this, use_or_def) ->
        let instrs_for_this_var = Vec.create () in
        let reg =
          match State.get_reg_or_spill ~don't_spill state with
          | `Spill (instr, reg) ->
            Vec.push instrs_for_this_var instr;
            reg
          | `Reg reg -> reg
        in
        don't_spill := Set.add !don't_spill reg;
        (match use_or_def, Hashtbl.find state.mappings this with
         | _, Some (Reg _) -> failwith "impossible"
         | `Def, _ -> ()
         | `Use, Some (Stack_slot stack_slot) ->
           MOV (Reg reg, Mem (RSP, -stack_slot)) |> Vec.push instrs_for_this_var
         | `Use, None ->
           MOV (Reg reg, Imm Int64.zero) |> Vec.push instrs_for_this_var);
        (* TODO: set interval also *)
        Hashtbl.set state.mappings ~key:this ~data:(Reg reg);
        instrs_for_this_var)
      |> Vec.concat_list
    in
    let instr =
      map_operands instr ~f:(fun use ->
        match Hashtbl.find_exn state.mappings use with
        | Reg r -> r
        | Stack_slot _ -> failwith "impossible")
    in
    Vec.push spills_and_loads_for_uses instr;
    spills_and_loads_for_uses)
;;
