open! Core
open! Ir

(* will eventually make it a bitset, no need rn *)
module Make (Var : X86_ir.Arg) = struct
  module X86_ir = X86_ir.Make (Var)
  open X86_ir

  let free_regs () =
    [ Reg.RAX; RBX; RCX; RDX; RSI; RDI; R8; R9; R10; R11; R12; R13; R14; R15 ]
    @ List.init 500 ~f:(fun i ->
      Reg.unallocated ("FREE" ^ Int.to_string i |> Var.of_string))
  ;;

  module Interval = struct
    module T = struct
      type t =
        { start : int
        ; end_ : int
        }
      [@@deriving sexp, equal, compare, hash]
    end

    include T
    include Comparable.Make (T)
    include Hashable.Make (T)
  end

  module Stack_slot = Int

  module Mapping = struct
    type t =
      | Reg of Var.t Reg.t
      | Stack_slot of Stack_slot.t
    [@@deriving sexp, compare, equal, hash, variants]
  end

  module Allocation = struct
    module T = struct
      type t =
        { interval : Interval.t
        ; mapping : Mapping.t
        ; var : Var.t
        }
      [@@deriving sexp, equal, compare, hash]
    end

    include T

    let fake ~var ~interval = { interval; mapping = Stack_slot 0; var }

    include Comparable.Make (T)
    include Hashable.Make (T)
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
        if i >= Vec.length instrs
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

    let create ~block_args ~block_starts ~block_adj ~instrs =
      (* print_s *)
      (*   [%message *)
      (*     (block_args : Var.t Vec.t String.Table.t) *)
      (*       (block_starts : int String.Map.t) *)
      (*       (block_adj : string List.t String.Table.t)]; *)
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
      (* print_s *)
      (*   [%message *)
      (*     (block_defs : Var.Set.t String.Table.t) *)
      (*       (block_uses : Var.Set.t String.Table.t)]; *)
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
            (Hashtbl.find_exn block_args block |> Vec.to_list |> Var.Set.of_list)
            (Set.union
               (Hashtbl.find_exn block_uses block)
               (Set.diff new_live_out (Hashtbl.find_exn block_defs block)))
        in
        (* print_s *)
        (*   [%message block (new_live_in : Var.Set.t) (new_live_out : Var.Set.t)]; *)
        if not
             (Var.Set.equal new_live_in (find_set live_in block)
              && Var.Set.equal new_live_out (find_set live_out block))
        then (
          Hashtbl.set live_in ~key:block ~data:new_live_in;
          Hashtbl.set live_out ~key:block ~data:new_live_out;
          (* only needs pred blocks but cbf to compute *)
          Map.iter_keys block_starts ~f:(Queue.enqueue worklist))
      done;
      (* let keys = Hashtbl.keys live_in in *)
      (* List.iter keys ~f:(fun s -> *)
      (* print_s *)
      (*   [%message *)
      (*     s *)
      (*       ~in_:(Hashtbl.find_exn live_in s : Var.Set.t) *)
      (*       ~out:(Hashtbl.find_exn live_out s : Var.Set.t)]); *)
      { block_starts; block_ends = !block_ends; live_in; live_out; block_adj }
    ;;

    let liveness_by_instr t ~instrs =
      let live_before = Vec.map instrs ~f:(Fn.const Var.Set.empty) in
      let live_after = Vec.map instrs ~f:(Fn.const Var.Set.empty) in
      Map.iteri t.block_ends ~f:(fun ~key:block ~data:end_ ->
        let start = Map.find_exn t.block_starts block in
        let after = ref (Hashtbl.find_exn t.live_out block) in
        for i = end_ - 1 downto start do
          let instr = Vec.get instrs i in
          let before =
            Set.union (X86_ir.uses instr) (Set.diff !after (X86_ir.defs instr))
          in
          Vec.set live_before i before;
          Vec.set live_after i !after;
          after := before
        done);
      live_before, live_after
    ;;
  end

  let calculate_liveness_info ~block_args ~block_starts ~block_adj ~instrs =
    (* print_s [%sexp (instrs : (Var.t, string) instr Vec.t)]; *)
    let live_ranges = Var.Table.create () in
    let events = Vec.map instrs ~f:(fun _ -> Vec.create ()) in
    let open_idx = Var.Table.create () in
    let block_info =
      Block_info.create ~block_args ~block_starts ~instrs ~block_adj
    in
    let live_before, live_after =
      Block_info.liveness_by_instr block_info ~instrs
    in
    (* let top = *)
    (*   Sequence.zip (Vec.to_sequence live_before) (Vec.to_sequence live_after) *)
    (*   |> Sequence.mapi ~f:(fun i (a, b) -> i, a, b) *)
    (*   |> Sequence.to_list *)
    (*   |> Vec.of_list *)
    (* in *)
    (* print_s [%sexp (top : (int * Var.Set.t * Var.Set.t) Vec.t)]; *)
    let add_interval var ~end_ =
      match Hashtbl.find open_idx var with
      | None -> (* not defined *) ()
      | Some start ->
        Hashtbl.update live_ranges var ~f:(function
          | None -> Interval.Map.singleton { start; end_ } ()
          | Some m -> Map.set m ~key:{ start; end_ } ~data:())
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
          Hashtbl.set open_idx ~key ~data:i));
    Hashtbl.iter_keys open_idx ~f:(fun var ->
      add_interval var ~end_:(Vec.length instrs));
    events, live_ranges
  ;;

  let get_reg free_regs =
    match !free_regs with
    | [] -> None
    | reg :: rest ->
      free_regs := rest;
      Some reg
  ;;

  let get_stack_slot ~free_stack_slots ~stack_slot_min =
    match !free_stack_slots with
    | [] ->
      let res = !stack_slot_min in
      incr stack_slot_min;
      res
    | stack_slot :: rest ->
      free_stack_slots := rest;
      stack_slot
  ;;

  let process ~stack_offset ~block_args ~block_starts ~block_adj ~instrs =
    let free_regs = ref (free_regs ()) in
    let free_stack_slots = ref [] in
    let stack_slot_min = ref stack_offset in
    let mappings = Var.Table.create () in
    let events, live_ranges =
      calculate_liveness_info ~block_args ~block_starts ~block_adj ~instrs
    in
    Vec.iteri events ~f:(fun i events ->
      Vec.iter events ~f:(function
        | `Close var ->
          (match Hashtbl.find mappings var with
           | None ->
             (* print_s [%message "failed close" (var : Var.t)]; *)
             ()
           | Some allocations ->
             (* print_s [%message "close" (var : Var.t)]; *)
             let allocation, _ = Map.max_elt_exn allocations in
             (match allocation.Allocation.mapping with
              | Stack_slot stack_slot ->
                free_stack_slots := stack_slot :: !free_stack_slots
              | Reg reg -> free_regs := reg :: !free_regs))
        | `Open var ->
          (* print_s [%message "open" (var : Var.t)]; *)
          let intervals = Hashtbl.find_exn live_ranges var in
          let interval, () =
            Map.closest_key intervals `Greater_than { start = i; end_ = i }
            |> Option.value_exn
          in
          let mapping =
            match get_reg free_regs with
            | Some reg -> Mapping.Reg reg
            | None ->
              Mapping.Stack_slot
                (get_stack_slot ~free_stack_slots ~stack_slot_min)
          in
          let allocation = { Allocation.interval; var; mapping } in
          Hashtbl.update mappings var ~f:(function
            | None -> Allocation.Map.singleton allocation ()
            | Some s -> Map.set s ~key:allocation ~data:())));
    mappings, !stack_slot_min
  ;;
end
