open! Core
open! Ir

(* will eventually make it a bitset, no need rn *)
module Make (Var : X86_ir.Arg) = struct
  module X86_ir = X86_ir.Make (Var)
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
        ; reg : Var.t Reg.t
        ; var : Var.t
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
      | Reg of Var.t Reg.t
      | Stack_slot of Stack_slot.t
    [@@deriving sexp, compare, equal, hash]
  end

  module State = struct
    type t =
      { mutable free_regs : Var.t Reg.t list
      ; live_ranges : Interval.Set.t Var.Table.t
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
          ( X86_ir.MOV (Mem (RSP, -stack_slot), Reg allocation.reg)
          , allocation.reg )
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

  module Block_info = struct
    type t =
      { block_starts : int String.Map.t
      ; block_ends : int String.Map.t
      ; block_adj : String.t list String.Table.t
      ; live_in : Var.Set.t String.Table.t
      ; live_out : Var.Set.t String.Table.t
      }

    (* uses = uses that aren't yet defined in block *)
    let defs_uses_and_end ~block_start ~instrs =
      let rec go ~acc:((defs, uses) as acc) i =
        if i < Vec.length instrs
        then acc, i
        else (
          match Vec.get instrs i with
          | LABEL _ -> acc, i
          | instr ->
            let new_uses = Set.diff (X86_ir.uses instr) defs in
            let uses = Set.union uses new_uses in
            let defs = Set.union defs (X86_ir.defs instr) in
            go ~acc:(defs, uses) (i + 1))
      in
      go ~acc:(Var.Set.empty, Var.Set.empty) (block_start + 1)
    ;;

    let create ~block_starts ~block_adj ~instrs =
      let worklist = Queue.create () in
      let live_in = String.Table.create () in
      let live_out = String.Table.create () in
      let block_ends = ref String.Map.empty in
      let block_defs = String.Table.create () in
      let block_uses = String.Table.create () in
      Map.iteri block_starts ~f:(fun ~key:block ~data:block_start ->
        let (defs, uses), end_ = defs_uses_and_end ~block_start ~instrs in
        Hashtbl.set block_defs ~key:block ~data:defs;
        Hashtbl.set block_uses ~key:block ~data:uses;
        block_ends := Map.set !block_ends ~key:block ~data:end_);
      let find_set tbl block =
        Hashtbl.find_or_add tbl block ~default:(fun () -> Var.Set.empty)
      in
      Map.iter_keys block_starts ~f:(Queue.enqueue worklist);
      while not (Queue.is_empty worklist) do
        let block = Queue.dequeue_exn worklist in
        (* live_out[b] = U LIVE_IN[succ] *)
        let new_live_out =
          Hashtbl.find_exn block_adj block
          |> List.map ~f:(find_set live_in)
          |> Var.Set.union_list
        in
        (* live_in[b]  = use U (live_out / def) *)
        let new_live_in =
          Set.union
            (Hashtbl.find_exn block_uses block)
            (Set.diff new_live_out (Hashtbl.find_exn block_defs block))
        in
        if not (Var.Set.equal new_live_in (find_set live_in block))
        then (
          Hashtbl.set live_in ~key:block ~data:new_live_in;
          Hashtbl.set live_out ~key:block ~data:new_live_out;
          (* only needs pred blocks but cbf to compute *)
          Map.iter_keys block_starts ~f:(Queue.enqueue worklist))
      done;
      { block_starts; block_ends = !block_ends; live_in; live_out; block_adj }
    ;;

    let liveness_by_instr t ~instrs =
      let live_before = Vec.map instrs ~f:(Fn.const Var.Set.empty) in
      let live_after = Vec.map instrs ~f:(Fn.const Var.Set.empty) in
      Map.iteri t.block_ends ~f:(fun ~key:block ~data:end_ ->
        let i = ref end_ in
        let start = Map.find_exn t.block_starts block in
        let after = ref (Hashtbl.find_exn t.live_out block) in
        while !i > start do
          let instr = Vec.get instrs !i in
          let before =
            Set.union (X86_ir.uses instr) (Set.diff !after (X86_ir.defs instr))
          in
          Vec.set live_before !i before;
          Vec.set live_after !i !after;
          after := before
        done);
      live_before, live_after
    ;;
  end

  let calculate_liveness_info ~block_starts ~block_adj ~instrs state =
    let events = Vec.map instrs ~f:(fun _ -> Vec.create ()) in
    let block_info = Block_info.create ~block_starts ~instrs ~block_adj in
    let open_idx = Var.Table.create () in
    let live_before, live_after =
      Block_info.liveness_by_instr block_info ~instrs
    in
    let add_interval var ~end_ =
      let start = Hashtbl.find_exn open_idx var in
      Hashtbl.update state.State.live_ranges var ~f:(function
        | None -> Interval.Set.singleton { start; end_ }
        | Some s -> Set.add s { start; end_ })
    in
    Sequence.iteri
      (Sequence.zip (Vec.to_sequence live_before) (Vec.to_sequence live_after))
      ~f:(fun i (live_before, live_after) ->
        let closed = Set.diff live_before live_after in
        Set.iter closed ~f:(fun key ->
          Vec.push (Vec.get events i) (`Close key);
          add_interval ~end_:i key);
        let opened = Set.diff live_after live_before in
        Set.iter opened ~f:(fun key ->
          Vec.push (Vec.get events i) (`Open key);
          Hashtbl.add_exn open_idx ~key ~data:i));
    Hashtbl.iter_keys open_idx ~f:(fun var ->
      add_interval var ~end_:(Vec.length instrs));
    events
  ;;

  let process ~stack_offset ~block_starts ~block_adj ~instrs =
    let state = State.create ~alloc_from:stack_offset in
    let _events =
      calculate_liveness_info ~block_starts ~block_adj ~instrs state
    in
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
          (Set.filter_map
             (module X86_ir.Reg_comparable)
             both
             ~f:find_reg_mapping)
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
             MOV (Reg reg, Mem (RSP, -stack_slot))
             |> Vec.push instrs_for_this_var
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
end
