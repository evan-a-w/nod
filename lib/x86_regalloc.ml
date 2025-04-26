open! Core
open! Ir
module Slow_x86_ir = X86_ir.Make (Var)

(* will eventually make it a bitset, no need rn *)
module Bit_var = Var
module X86_ir = X86_ir.Make (Bit_var)
open X86_ir

let free_regs () =
  [ Reg.RAX; RBX; RCX; RDX; RSI; RDI; R8; R9; R10; R11; R12; R13; R14; R15 ]
;;

module Interval = struct
  module T = struct
    type t =
      { end_ : int
      ; start : int
      }
    [@@deriving sexp, equal, compare, hash]
  end

  include T
  include Comparable.Make (T)
  include Hashable.Make (T)
end

module Allocation = struct
  module T = struct
    type t =
      { prio : int
      ; interval : Interval.t
      ; reg : Bit_var.t Reg.t
      ; var : Bit_var.t
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
    | Reg of Bit_var.t Reg.t
    | Stack_slot of Stack_slot.t
  [@@deriving sexp, compare, equal, hash]
end

module State = struct
  type t =
    { mutable free_regs : Bit_var.t Reg.t list
    ; live_ranges : Interval.t Var.Table.t
    ; mappings : Mapping.t Var.Table.t
    ; mutable allocations : Var.t Allocation.Map.t
    ; mutable allocations_by_end_point : Allocation.Set.t Int.Map.t
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

  let remove_allocation ~allocation t =
    t.allocations <- Map.remove t.allocations allocation;
    t.allocations_by_end_point
    <- Map.change
         t.allocations_by_end_point
         allocation.interval.end_
         ~f:(function
         | None -> None
         | Some s ->
           let s = Set.remove s allocation in
           if Set.is_empty s then None else Some s)
  ;;

  let remove_allocation_and_mapping ~allocation t =
    remove_allocation ~allocation t;
    Hashtbl.remove t.mappings allocation.var
  ;;

  let rec to_spill ~don't_spill ?current t =
    let ((allocation, _) as res) =
      match current with
      | None -> Map.min_elt_exn t.allocations
      | Some x ->
        Map.closest_key t.allocations `Greater_than x |> Option.value_exn
    in
    if not (Set.mem !don't_spill allocation.reg)
    then (
      remove_allocation t ~allocation;
      res)
    else to_spill ~don't_spill ~current:allocation t
  ;;

  let get_reg_or_spill ~don't_spill t =
    match get_reg t with
    | Some x -> `Reg x
    | None ->
      let allocation, var_to_spill = to_spill ~don't_spill t in
      let stack_slot = Stack_slots.alloc t.stack_slots in
      Hashtbl.set t.mappings ~key:var_to_spill ~data:(Stack_slot stack_slot);
      `Spill
        (X86_ir.MOV (Mem (RSP, -stack_slot), Reg allocation.reg), allocation.reg)
  ;;

  let create ~alloc_from =
    { free_regs = free_regs ()
    ; live_ranges = Var.Table.create ()
    ; mappings = Var.Table.create ()
    ; allocations = Allocation.Map.empty
    ; allocations_by_end_point = Int.Map.empty
    ; stack_slots = Stack_slots.create ~alloc_from
    }
  ;;
end

let defs_and_uses _block = Bit_var.Set.empty, Bit_var.Set.empty

let liveness blocks =
  let worklist = Queue.create () in
  let live_in = X86_ir.Block.Table.create () in
  let live_out = X86_ir.Block.Table.create () in
  let block_defs = X86_ir.Block.Table.create () in
  let block_uses = X86_ir.Block.Table.create () in
  Vec.iter blocks ~f:(fun block ->
    let defs, uses = defs_and_uses block in
    Hashtbl.set block_defs ~key:block ~data:defs;
    Hashtbl.set block_uses ~key:block ~data:uses);
  let find_set tbl block =
    Hashtbl.find_or_add tbl block ~default:(fun () -> Bit_var.Set.empty)
  in
  Vec.iter blocks ~f:(Queue.enqueue worklist);
  while not (Queue.is_empty worklist) do
    let block = Queue.dequeue_exn worklist in
    (* live_out[b] = U LIVE_IN[succ] *)
    let new_live_out =
      X86_ir.blocks block.Block.terminal
      |> List.map ~f:(find_set live_in)
      |> Bit_var.Set.union_list
    in
    (* live_in[b]  = use U (live_out / def) *)
    let new_live_in =
      Set.union
        (Hashtbl.find_exn block_uses block)
        (Set.diff new_live_out (Hashtbl.find_exn block_defs block))
    in
    if not (Bit_var.Set.equal new_live_in (find_set live_in block))
    then (
      Hashtbl.set live_in ~key:block ~data:new_live_in;
      Hashtbl.set live_out ~key:block ~data:new_live_out;
      (* only needs pred blocks but cbf to compute *)
      Vec.iter blocks ~f:(Queue.enqueue worklist))
  done
;;

let calculate_live_ranges instrs ~state =
  let first_def = Hashtbl.Poly.create () in
  let last_use = Hashtbl.Poly.create () in
  Vec.iteri instrs ~f:(fun idx instr ->
    Set.iter (defs instr) ~f:(fun v ->
      Hashtbl.set
        first_def
        ~key:v
        ~data:(Hashtbl.find_or_add first_def v ~default:(fun () -> idx)));
    Set.iter (uses instr) ~f:(fun v -> Hashtbl.set last_use ~key:v ~data:idx));
  Hashtbl.iteri first_def ~f:(fun ~key:var ~data:start ->
    let end_ = Hashtbl.find_or_add last_use var ~default:(fun () -> start) in
    Hashtbl.set state.State.live_ranges ~key:var ~data:{ Interval.start; end_ });
  Hashtbl.iteri last_use ~f:(fun ~key:var ~data:end_ ->
    if Hashtbl.mem first_def var
    then ()
    else
      Hashtbl.set
        state.State.live_ranges
        ~key:var
        ~data:{ Interval.start = end_; end_ })
;;

let process ~stack_offset instrs =
  let state = State.create ~alloc_from:stack_offset in
  calculate_live_ranges instrs ~state;
  Vec.concat_mapi instrs ~f:(fun i instr ->
    Set.iter
      (Map.find state.allocations_by_end_point i
       |> Option.value ~default:Allocation.Set.empty)
      ~f:(fun allocation ->
        State.remove_allocation_and_mapping state ~allocation);
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
      ref
        (Set.filter_map (module X86_ir.Reg_comparable) both ~f:find_reg_mapping)
    in
    (* TODO: actually set allocations for the allocs we do *)
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
        (* TODO: set allocation also *)
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
