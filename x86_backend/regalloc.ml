open! Core
open! Import
open! Common
module Raw = X86_reg.Raw
module Class = X86_reg.Class
module Solver = Pror.Feel_solver

let note_var_class table var class_ =
  match Hashtbl.find table var with
  | None -> Hashtbl.set table ~key:var ~data:class_
  | Some existing when Class.equal existing class_ -> ()
  | Some existing ->
    Error.raise_s
      [%message
        "register class mismatch"
          (var : Var.t)
          (existing : Class.t)
          (class_ : Class.t)]
;;

let collect_var_classes root =
  let classes = Var.Table.create () in
  Block.iter_instructions root ~f:(fun ir ->
    Ir.x86_regs ir
    |> List.iter ~f:(fun (reg : Reg.t) ->
      match reg.reg with
      | Raw.Unallocated var | Raw.Allocated (var, _) ->
        note_var_class classes var reg.class_
      | _ -> ()));
  classes
;;

let reg_pool_for_class = function
  | Class.I64 ->
    [| Reg.rax
     ; Reg.rbx
     ; Reg.rcx
     ; Reg.rdx
     ; Reg.r8
     ; Reg.r9
     ; Reg.r10
     ; Reg.r11
     ; Reg.r12
     ; Reg.r13
     ; Reg.r14
     ; Reg.r15
    |]
    (* [| Reg.rax; Reg.rbx; Reg.rcx |] *)
  | Class.F64 ->
    [| Reg.xmm0
     ; Reg.xmm1
     ; Reg.xmm2
     ; Reg.xmm3
     ; Reg.xmm4
     ; Reg.xmm5
     ; Reg.xmm6
     ; Reg.xmm7
     ; Reg.xmm8
     ; Reg.xmm9
     ; Reg.xmm10
     ; Reg.xmm11
     ; Reg.xmm12
     ; Reg.xmm13
     ; Reg.xmm14
     ; Reg.xmm15
    |]
;;

let update_assignment ~assignments ~var ~to_ =
  Hashtbl.update assignments var ~f:(function
    | None -> to_
    | Some assignment when Assignment.equal assignment to_ -> assignment
    | Some from ->
      Error.raise_s
        [%message
          "Want to assign phys reg but already found"
            (var : Var.t)
            (from : Assignment.t)
            (to_ : Assignment.t)])
;;

let initialize_assignments root =
  let assignments = Var.Table.create () in
  let don't_spill = Var.Hash_set.create () in
  Block.iter_instructions root ~f:(fun ir ->
    Ir.x86_regs ir
    |> List.iter ~f:(fun (reg : Reg.t) ->
      match reg.reg with
      | Raw.Allocated (_, Some (Raw.Allocated _))
      | Raw.Allocated (_, Some (Raw.Unallocated _)) -> failwith "bug"
      | Raw.Allocated (var, Some forced_raw) ->
        let forced = Reg.physical ~class_:reg.class_ forced_raw in
        update_assignment ~assignments ~var ~to_:(Reg forced)
      | Raw.Allocated (var, None) -> Hash_set.add don't_spill var
      | _ -> ()));
  ~assignments, ~don't_spill
;;

let run_sat
  ~dump_crap
  ~reg_numbering
  ~interference_graph
  ~assignments
  ~don't_spill
  ~class_of_var
  ~class_
  =
  (* let dump_crap = dump_crap || true in *)
  let reg_pool = reg_pool_for_class class_ in
  let var_states =
    Reg_numbering.vars reg_numbering
    |> Hashtbl.data
    |> List.filter ~f:(fun state -> Class.equal (class_of_var state.var) class_)
  in
  let sat_vars_per_var_id = Array.length reg_pool + 1 in
  (* if dump_crap *)
  (* then ( *)
  (*   let var_to_id = *)
  (*     List.map var_states ~f:(fun var -> *)
  (*       var.var, Reg_numbering.var_id reg_numbering var.var) *)
  (*   in *)
  (*   print_s *)
  (*     [%message (sat_vars_per_var_id : int) (var_to_id : (Var.t * int) list)]); *)
  let var_ids_list = List.map var_states ~f:Reg_numbering.id in
  let var_ids = Array.of_list var_ids_list in
  if Array.is_empty var_ids
  then ()
  else (
    let var_state_arr = Array.of_list var_states in
    let var_id_set = Int.Hash_set.of_list var_ids_list in
    let spill var_id = (var_id * sat_vars_per_var_id) + 1 in
    let reg_sat var_id idx = spill var_id + idx + 1 in
    let backout_sat_var var =
      let var_id = (var - 1) / sat_vars_per_var_id in
      let reg = (var - 1) mod sat_vars_per_var_id in
      if reg = 0 then var_id, `Spill else var_id, `Assignment reg_pool.(reg - 1)
    in
    let all_reg_assignments var_id =
      Array.init (Array.length reg_pool) ~f:(reg_sat var_id)
    in
    let sat_constraints =
      let open Pror.Logic in
      let exactly_one_reg_per_var =
        Array.concat_map var_ids ~f:(fun var_id ->
          let options =
            Array.append [| spill var_id |] (all_reg_assignments var_id)
          in
          exactly_one options)
      in
      let interferences =
        Interference_graph.edges interference_graph
        |> Set.to_array
        |> Array.filter ~f:(fun (a, b) ->
          Hash_set.mem var_id_set a && Hash_set.mem var_id_set b)
        |> Array.concat_map ~f:(fun (var_id, var_id') ->
          Array.zip_exn
            (all_reg_assignments var_id)
            (all_reg_assignments var_id')
          |> Array.map ~f:(fun (ass, ass') -> [| -ass; -ass' |]))
      in
      Array.append exactly_one_reg_per_var interferences
    in
    if dump_crap
    then
      print_s [%message "SAT constraints" (sat_constraints : int array array)];
    let solver = Solver.create_with_formula sat_constraints in
    let to_spill =
      var_states
      |> List.filter ~f:(fun { var; _ } ->
        (not (Hashtbl.mem assignments var))
        && not (Hash_set.mem don't_spill var))
      |> List.sort
           ~compare:
             (Comparable.lift Int.compare ~f:Reg_numbering.var_state_score)
      |> Ref.create
    in
    let assumptions () =
      Array.map var_state_arr ~f:(fun { var; id; _ } ->
        match Hashtbl.find assignments var with
        | Some Assignment.Spill -> spill id
        | Some (Reg reg) ->
          (match
             Array.findi reg_pool ~f:(fun _i reg' -> Reg.equal reg reg')
           with
           | None -> spill id
           | Some (i, _) -> reg_sat id i)
        | None -> -spill id)
    in
    let rec run () =
      let assumptions = assumptions () in
      if dump_crap
      then (
        let raw = assumptions in
        let assumptions =
          Array.map
            ~f:(fun x ->
              let b = x > 0 in
              let var_id, ass = backout_sat_var (Int.abs x) in
              Reg_numbering.id_var reg_numbering var_id, ass, x, b)
            assumptions
        in
        print_s
          [%message
            "LOOP"
              (assumptions
               : (Var.t * [ `Spill | `Assignment of Reg.t ] * int * bool) array)
              (raw : int array)]);
      match Solver.solve solver ~assumptions, !to_spill with
      | `Unsat unsat_core, [] ->
        Error.raise_s
          [%message
            "Can't assign, but nothing to spill"
              (assignments : Assignment.t Var.Table.t)
              (unsat_core : int array)]
      | `Unsat _, ({ var = key; _ } : Reg_numbering.var_state) :: rest_to_spill
        ->
        to_spill := rest_to_spill;
        Hashtbl.add_exn assignments ~key ~data:Spill;
        run ()
      | `Sat res, _ ->
        let raw = Array.to_list res in
        let res =
          Array.to_list res
          |> List.filter_map ~f:(fun literal ->
            if literal < 0 then None else Some literal)
        in
        if dump_crap
        then (
          let res =
            List.map res ~f:(fun x ->
              let var_id, ass = backout_sat_var x in
              Reg_numbering.id_var reg_numbering var_id, ass, x)
          in
          print_s
            [%message
              (res : (Var.t * [ `Spill | `Assignment of Reg.t ] * int) list)
                (raw : int list)]);
        List.iter res ~f:(fun sat_var ->
          let var_id, x = backout_sat_var sat_var in
          let var = Reg_numbering.id_var reg_numbering var_id in
          match x with
          | `Spill -> ()
          | `Assignment reg ->
            update_assignment ~assignments ~var ~to_:(Reg reg))
    in
    run ())
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
  let spill_slot_by_var = Var.Table.create () in
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
  let update_slots ~which ({ live_in; live_out } : Liveness.t) =
    let opened = Set.diff live_out live_in in
    let closed = Set.diff live_in live_out in
    (match which with
     | `Close -> ()
     | `Open | `Both ->
       Set.iter opened ~f:(fun var_id ->
         let var = Reg_numbering.id_var reg_numbering var_id in
         let assn = Hashtbl.find_exn assignments var in
         match assn with
         | Assignment.Reg _ -> ()
         | Spill ->
           (match Hashtbl.mem spill_slot_by_var var with
            | true -> ()
            | false ->
              Hashtbl.add_exn
                spill_slot_by_var
                ~key:var
                ~data:(get_spill_slot ()))));
    match which with
    | `Open -> ()
    | `Close | `Both ->
      Set.iter closed ~f:(fun var_id ->
        let var = Reg_numbering.id_var reg_numbering var_id in
        Hashtbl.find_and_remove spill_slot_by_var var
        |> Option.iter ~f:free_spill_slot)
  in
  let map_ir ir =
    let map_reg (reg : Reg.t) =
      match reg.reg with
      | Raw.Unallocated v ->
        (match Hashtbl.find assignments v with
         | Some Assignment.Spill ->
           let offset =
             fn.bytes_alloca'd + ((Hashtbl.find_exn spill_slot_by_var v + 1) * 8)
           in
           Mem (Reg.rbp, offset)
         | Some (Assignment.Reg phys) -> Reg phys
         | None -> Reg reg)
      | Raw.Allocated (v, _) ->
        let phys =
          Hashtbl.find_exn assignments v
          |> Assignment.reg_val
          |> Option.value_exn
        in
        Reg phys
      | _ -> Reg reg
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
         ~which:`Both
         { live_in = live_out; live_out = block_liveness.overall.live_in });
    let new_instructions =
      Vec.zip_exn block.instructions block_liveness.instructions
      |> Vec.map ~f:(fun (instruction, liveness) ->
        update_slots ~which:`Open liveness;
        let ir = map_ir instruction in
        update_slots ~which:`Close liveness;
        ir)
    in
    block.instructions <- new_instructions;
    update_slots ~which:`Both block_liveness.terminal;
    block.terminal <- map_ir block.terminal;
    prev_liveness := Some block_liveness.terminal);
  let spill_slots_used =
    match Set.max_elt !free_spill_slots, Set.max_elt !used_spill_slots with
    | None, None -> 0
    | Some a, Some b -> Int.max a b + 1
    | Some a, None | None, Some a -> a + 1
  in
  spill_slots_used
;;

let run ?(dump_crap = false) (fn : Function.t) =
  let var_classes = collect_var_classes fn.root in
  let class_of_var var =
    Hashtbl.find var_classes var |> Option.value ~default:Class.I64
  in
  let reg_numbering = Reg_numbering.create fn.root in
  let (module Calc_liveness) =
    Calc_liveness.var ~treat_block_args_as_defs:false ~reg_numbering
  in
  let liveness_state = Calc_liveness.Liveness_state.create ~root:fn.root in
  let interference_graph =
    Interference_graph.create
      (module Calc_liveness)
      ~liveness_state
      ~root:fn.root
  in
  if dump_crap then Interference_graph.print interference_graph;
  let ~assignments, ~don't_spill = initialize_assignments fn.root in
  List.iter [ Class.I64; Class.F64 ] ~f:(fun class_ ->
    run_sat
      ~dump_crap
      ~reg_numbering
      ~interference_graph
      ~assignments
      ~don't_spill
      ~class_of_var
      ~class_);
  if dump_crap then print_s [%sexp (assignments : Assignment.t Var.Table.t)];
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
