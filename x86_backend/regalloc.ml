open! Core
open! Import
open! Common

let update_assignment ~assignments ~var ~to_ =
  Hashtbl.update assignments var ~f:(function
    | None -> Assignment.reg to_
    | Some (Assignment.Reg to' as x) when Reg.equal to' to_ -> x
    | Some a ->
      Error.raise_s
        [%message
          "Want to assign phys reg but already found"
            (a : Assignment.t)
            (to_ : Reg.t)])
;;

let initialize_assignments root =
  let assignments = Var.Table.create () in
  let don't_spill = Var.Hash_set.create () in
  Block.iter_instructions root ~f:(fun ir ->
    Ir.x86_regs ir
    |> List.iter ~f:(function
      (* pretty ugly, cbf to clean *)
      | Allocated (_, Some (Allocated _)) | Allocated (_, Some (Unallocated _))
        -> failwith "bug"
      | Reg.Allocated (var, Some to_) ->
        update_assignment ~assignments ~var ~to_
      | Reg.Allocated (var, None) -> Hash_set.add don't_spill var
      | _ -> ()));
  ~assignments, ~don't_spill
;;

module type Sat = sig
  val run : unit -> unit
end

let run_sat
  ~dump_crap
  ~reg_numbering
  ~interference_graph
  ~assignments
  ~don't_spill
  =
  let (module Sat) =
    (module struct
      let reg_pool : Reg.t array =
        [| RAX; RBX; RCX; RDX; R8; R9; R10; R11; R12; R13; R14; R15 |]
      ;;

      let sat_vars_per_var_id =
        (* there is also a var for if spilled, but that is just 0 index (phys reg ids are > 0)*)
        Array.length reg_pool + 1
      ;;

      (* Can eventually fuse non interfering registers

     but if one is allocated to a specific physical register, we can only fuse variables that don't interfere with the same physical register

     After all this can kill moves to same reg
      *)

      let var_ids =
        Reg_numbering.vars reg_numbering
        |> Hashtbl.data
        |> List.map ~f:Reg_numbering.id
        |> Array.of_list
      ;;

      let spill var_id = (var_id * sat_vars_per_var_id) + 1
      let reg_sat var_id idx = spill var_id + idx + 1

      let backout_sat_var var =
        let var_id = (var - 1) / sat_vars_per_var_id in
        let reg = (var - 1) mod sat_vars_per_var_id in
        if reg = 0
        then var_id, `Spill
        else var_id, `Assignment reg_pool.(reg - 1)
      ;;

      let all_reg_assignments var_id =
        [| reg_sat var_id i for i = 0 to Array.length reg_pool - 1 |]
      ;;

      let sat_constraints =
        (*
           Setup:
             1. a variable for whether [id] is spilled
                - use this as a flag before each relevant condition, so we can disable them easily via assumptions
                - start by pushing assumptions that all of these are false, and if we spill a variable, push it as true
             2. a variable for each physical reg saying [id] is assigned that physical reg
                - exactly one of these must be true
                - when variables are conflicting, we push a constraint to have [^a or ^b]
        *)
        let open Pror.Logic in
        let exactly_one_reg_per_var =
          Array.concat_map var_ids ~f:(fun var_id ->
            Array.map
              (exactly_one (all_reg_assignments var_id))
              ~f:(fun arr -> Array.append [| spill var_id |] arr))
        in
        let interferences =
          Interference_graph.edges interference_graph
          |> Set.to_array
          |> Array.concat_map ~f:(fun (var_id, var_id') ->
            Array.zip_exn
              (all_reg_assignments var_id)
              (all_reg_assignments var_id')
            |> Array.map ~f:(fun (ass, ass') -> [| -ass; -ass' |]))
        in
        Array.append exactly_one_reg_per_var interferences
      ;;

      let () =
        if dump_crap
        then
          print_s
            [%message "SAT constraints" (sat_constraints : int array array)]
      ;;

      let pror = Pror.create_with_problem sat_constraints

      let to_spill =
        Reg_numbering.vars reg_numbering
        |> Hashtbl.data
        |> List.filter ~f:(fun { var; _ } ->
          (not (Hashtbl.mem assignments var))
          && not (Hash_set.mem don't_spill var))
        |> List.sort
             ~compare:
               (Comparable.lift Int.compare ~f:Reg_numbering.var_state_score)
        |> Ref.create
      ;;

      let assumptions () =
        Reg_numbering.vars reg_numbering
        |> Hashtbl.to_alist
        |> Array.of_list
        |> Array.map ~f:(fun (var, { id; _ }) ->
          match (Hashtbl.find assignments var : Assignment.t option) with
          | Some Spill -> spill id
          | Some (Reg reg) ->
            (match
               Array.findi reg_pool ~f:(fun _i reg' -> Reg.equal reg reg')
             with
             | None -> spill id
             (* we can just pretend it doesn't exist in this case, because it doesn't affect other assignments *)
             | Some (i, _) -> reg_sat id i)
          | None -> -spill id)
      ;;

      let rec run () =
        let assumptions = assumptions () in
        if dump_crap then print_s [%message "LOOP" (assumptions : int array)];
        match Pror.run_with_assumptions pror assumptions, !to_spill with
        | UnsatCore core, [] ->
          Error.raise_s
            [%message
              "Can't assign, but nothing to spill"
                (assignments : Assignment.t String.Table.t)
                (core : int array)]
        | ( UnsatCore _
          , ({ var = key; _ } : Reg_numbering.var_state) :: rest_to_spill ) ->
          to_spill := rest_to_spill;
          Hashtbl.add_exn assignments ~key ~data:Spill;
          run ()
        | Sat res, _ ->
          if dump_crap then print_s [%message (res : (int * bool) list)];
          List.iter res ~f:(fun (sat_var, b) ->
            let var_id, x = backout_sat_var sat_var in
            let var = Reg_numbering.id_var reg_numbering var_id in
            match x with
            | `Assignment reg when b ->
              update_assignment ~assignments ~var ~to_:reg
            | `Assignment _ | `Spill -> ())
      ;;
    end : Sat)
  in
  Sat.run ()
;;

let replace_regs
  (type a)
  (module Calc_liveness : Calc_liveness.S with type Liveness_state.t = a)
  ~(liveness_state : a)
  ~fn
  ~assignments
  ~reg_numbering
  =
  let open Calc_liveness in
  let root = fn.Function.root in
  let spill_slot_by_var = String.Table.create () in
  let free_spill_slots = ref Int.Set.empty in
  let used_spill_slots = ref Int.Set.empty in
  let get_spill_slot () =
    match Set.min_elt !free_spill_slots with
    | None -> Set.length !used_spill_slots
    | Some x ->
      free_spill_slots := Set.remove !free_spill_slots x;
      x
  in
  let free_spill_slot spill_slot =
    free_spill_slots := Set.add !free_spill_slots spill_slot
  in
  let prev_liveness = ref None in
  let update_slots ({ live_in; live_out } : Liveness.t) =
    let opened = Set.diff live_out live_in in
    let closed = Set.diff live_in live_out in
    Set.iter opened ~f:(fun var_id ->
      let var = Reg_numbering.id_var reg_numbering var_id in
      if Hashtbl.mem spill_slot_by_var var
      then ()
      else Hashtbl.add_exn spill_slot_by_var ~key:var ~data:(get_spill_slot ()));
    Set.iter closed ~f:(fun var_id ->
      let var = Reg_numbering.id_var reg_numbering var_id in
      Hashtbl.find_and_remove spill_slot_by_var var
      |> Option.iter ~f:free_spill_slot)
  in
  let map_ir ir =
    let map_reg = function
      | Reg.Unallocated v ->
        (match Hashtbl.find_exn assignments v with
         | Assignment.Spill ->
           (* RBP is whatever stack is at start of fn

                Stack looks like args then ret pointer then spills then actual state
           *)
           Mem
             ( RBP
             , fn.bytes_alloca'd + (Hashtbl.find_exn spill_slot_by_var v * 8) )
         | Reg r -> Reg r)
      | Allocated (v, _) ->
        Reg
          (Hashtbl.find_exn assignments v
           |> Assignment.reg_val
           |> Option.value_exn)
      | reg -> Reg reg
    in
    Ir.map_x86_operands ir ~f:(function
      | Reg r -> map_reg r
      | Mem (r, offset) ->
        Mem
          ( map_reg r
            |> (* safe because we enforce no spills on the mem regs *)
            reg_of_operand_exn
          , offset )
      | Imm _ as t -> t)
  in
  Block.iter root ~f:(fun block ->
    let block_liveness = Liveness_state.block_liveness liveness_state block in
    (match !prev_liveness with
     | None -> ()
     | Some ({ live_out; _ } : Liveness.t) ->
       update_slots
         { live_in = live_out; live_out = block_liveness.overall.live_in });
    let new_instructions =
      Vec.zip_exn block.instructions block_liveness.instructions
      |> Vec.map ~f:(fun (instruction, liveness) ->
        update_slots liveness;
        map_ir instruction)
    in
    block.instructions <- new_instructions;
    update_slots block_liveness.terminal;
    block.terminal <- map_ir block.terminal;
    prev_liveness := Some block_liveness.terminal);
  let spill_slots_used =
    match Set.max_elt !free_spill_slots, Set.max_elt !used_spill_slots with
    | None, None -> 0
    | Some a, Some b -> Int.max a b
    | Some a, None | None, Some a -> a
  in
  spill_slots_used
;;

let run ?(dump_crap = false) (fn : Function.t) =
  let reg_numbering = Reg_numbering.create fn.root in
  let (module Calc_liveness) = Calc_liveness.var ~reg_numbering in
  let liveness_state = Calc_liveness.Liveness_state.create ~root:fn.root in
  let interference_graph =
    Interference_graph.create
      (module Calc_liveness)
      ~liveness_state
      ~root:fn.root
  in
  if dump_crap then Interference_graph.print interference_graph;
  let ~assignments, ~don't_spill = initialize_assignments fn.root in
  let () =
    run_sat
      ~dump_crap
      ~reg_numbering
      ~interference_graph
      ~assignments
      ~don't_spill
  in
  if dump_crap then print_s [%sexp (assignments : Assignment.t String.Table.t)];
  let spill_slots_used =
    replace_regs
      (module Calc_liveness)
      ~fn
      ~assignments
      ~liveness_state
      ~reg_numbering
  in
  fn.bytes_for_spills <- spill_slots_used * 8;
  fn
;;
