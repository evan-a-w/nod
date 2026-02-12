open! Core
open! Import
module Analysis = Ssa_analysis

let var_of_value (value : Value_state.t) = Value_state.var value

(* Context threading through the SSA construction passes. *)
type t =
  { analysis : Analysis.Def_use.t
  ; numbers : int String.Table.t
  ; idom_tree : Block.Hash_set.t Block.Table.t
  }

let fn_state t = Analysis.Def_use.fn_state t.analysis

(* Compute immediate-dominee table from dominance info. *)
let with_idom_tree analysis =
  { analysis
  ; numbers = String.Table.create ()
  ; idom_tree =
      Analysis.Dominance.idom_tree (Analysis.Def_use.dominance analysis)
  }
;;

(* Generate a fresh SSA name for a variable, using base%N numbering. *)
let fresh_name t var =
  let base = String.split (Typed_var.name var) ~on:'%' |> List.hd_exn in
  match Hashtbl.find t.numbers base with
  | None ->
    Hashtbl.set t.numbers ~key:base ~data:0;
    Typed_var.create ~name:base ~type_:(Typed_var.type_ var)
  | Some n ->
    Hashtbl.set t.numbers ~key:base ~data:(n + 1);
    Typed_var.create
      ~name:(base ^ "%" ^ Int.to_string n)
      ~type_:(Typed_var.type_ var)
;;

(* Pass 1: Phi/parameter insertion on dominance frontiers. *)
let insert_phi_args t =
  let def_use = t.analysis in
  Hash_set.iter (Analysis.Def_use.vars def_use) ~f:(fun var ->
    match Hashtbl.find (Analysis.Def_use.defs def_use) var with
    | None -> ()
    | Some defs ->
      List.iter (Hash_set.to_list defs) ~f:(fun d ->
        Analysis.Def_use.df def_use ~block:d
        |> List.iter ~f:(fun block ->
          if not (Nod_vec.mem (Block.args block) var ~compare:Typed_var.compare)
          then
            Fn_state.set_block_args
              (fn_state t)
              ~block
              ~args:
                (Nod_vec.of_list (Nod_vec.to_list (Block.args block) @ [ var ]));
          Hash_set.add defs block)));
  t
;;

(* Helper: update all branch/call sites to pass current block-args. *)
let add_block_args_value_ir t ir =
  Ir.map_call_blocks ir ~f:(fun { Call_block.block; args = _ } ->
    let args =
      Nod_vec.to_list (Block.args block)
      |> List.map ~f:(fun var -> Fn_state.ensure_value (fn_state t) ~var)
    in
    { Call_block.block; args })
;;

(* Pass 2: Propagate block-args to all successor calls. *)
let propagate_args_to_calls t =
  let rec go block =
    Fn_state.replace_terminal_ir
      (fn_state t)
      ~block
      ~with_:(add_block_args_value_ir t (Block.terminal block).ir);
    Option.iter
      (Hashtbl.find t.idom_tree block)
      ~f:
        (Hash_set.iter ~f:(fun child ->
           if phys_equal child block then () else go child))
  in
  go (Analysis.Def_use.root t.analysis);
  t
;;

(* Compute variables used in a block excluding call-site arguments. *)
let uses_in_block_ex_calls ~(block : Block.t) =
  let f (defs, uses) instr =
    let uses =
      Set.union
        uses
        (Set.diff
           (Ir.uses_ex_args instr ~compare_var:Value_state.compare
            |> List.map ~f:var_of_value
            |> Typed_var.Set.of_list)
           defs)
    in
    let defs =
      Set.union
        defs
        (Ir.defs instr |> List.map ~f:var_of_value |> Typed_var.Set.of_list)
    in
    defs, uses
  in
  let acc =
    Instr_state.to_ir_list (Block.instructions block)
    |> List.fold ~init:(Typed_var.Set.empty, Typed_var.Set.empty) ~f
  in
  let _defs, uses = f acc (Block.terminal block).ir in
  uses
;;

(* Pass 3: Prune unused block-args. *)
let prune_unused_args t =
  let rec collect acc block =
    let acc = Set.union (uses_in_block_ex_calls ~block) acc in
    Option.fold ~init:acc (Hashtbl.find t.idom_tree block) ~f:(fun init ->
      Hash_set.fold ~init ~f:(fun acc child ->
        if phys_equal child block then acc else collect acc child))
  in
  let root = Analysis.Def_use.root t.analysis in
  let uses = collect Typed_var.Set.empty root in
  let rec prune block =
    let new_args = Nod_vec.filter (Block.args block) ~f:(Set.mem uses) in
    if Nod_vec.length new_args <> Nod_vec.length (Block.args block)
    then (
      Fn_state.set_block_args (fn_state t) ~block ~args:new_args;
      Nod_vec.iter (Block.parents block) ~f:(fun parent ->
        Fn_state.replace_terminal_ir
          (fn_state t)
          ~block:parent
          ~with_:(add_block_args_value_ir t (Block.terminal parent).ir)));
    Option.iter
      (Hashtbl.find t.idom_tree block)
      ~f:
        (Hash_set.iter ~f:(fun child ->
           if phys_equal child block then () else prune child))
  in
  prune root;
  t
;;

(* Mem2Reg promotion for allocas only used in non-atomic loads/stores. *)
module Mem2reg = struct
  type slot =
    { ptr : Typed_var.t
    ; mutable val_type : Type.t option
    ; loads : (Block.t * Block.t Instr_state.t) list ref
    ; stores : (Block.t * Block.t Instr_state.t) list ref
    ; mutable bad_use : bool
    }

  let create_slot ptr =
    { ptr; val_type = None; loads = ref []; stores = ref []; bad_use = false }

  let base_is_ptr_value_var ~ptr = function
    | Nod_ir.Mem.Address { base = Nod_ir.Lit_or_var.Var v; offset = 0 } ->
      Typed_var.compare (var_of_value v) ptr = 0
    | Nod_ir.Mem.Address _ | Nod_ir.Mem.Stack_slot _ | Nod_ir.Mem.Global _ ->
      false

  let update_type slot ty =
    match slot.val_type with
    | None -> slot.val_type <- Some ty
    | Some prev -> if not (Type.equal prev ty) then slot.bad_use <- true

  let scan_block_slots (slots : (Typed_var.t, slot) Hashtbl.t) (block : Block.t)
    =
    let record_load ptr instr (dest : Value_state.t) =
      let slot = Hashtbl.find_exn slots ptr in
      slot.loads := (block, instr) :: !(slot.loads);
      update_type slot (Typed_var.type_ (Value_state.var dest))
    in
    let record_store ptr instr (src : Value_state.t Nod_ir.Lit_or_var.t) =
      let slot = Hashtbl.find_exn slots ptr in
      slot.stores := (block, instr) :: !(slot.stores);
      (match src with
       | Nod_ir.Lit_or_var.Var v ->
         update_type slot (Typed_var.type_ (Value_state.var v))
       | Nod_ir.Lit_or_var.Global g ->
         update_type slot (Type.Ptr_typed g.Nod_ir.Global.type_)
       | Nod_ir.Lit_or_var.Lit _ -> ())
    in
    let mark_bad ptr = (Hashtbl.find_exn slots ptr).bad_use <- true in
    let rec iter_instrs instr =
      match instr with
      | None -> ()
      | Some i ->
        (match i.Instr_state.ir with
         | Nod_ir.Ir.Alloca { dest = _; _ } -> ()
         | Nod_ir.Ir.Load (dest, mem) ->
           (match mem with
            | Nod_ir.Mem.Address { base = Nod_ir.Lit_or_var.Var v; offset } ->
              if offset = 0 && Hashtbl.mem slots (var_of_value v)
              then record_load (var_of_value v) i dest
              else if Hashtbl.mem slots (var_of_value v)
              then mark_bad (var_of_value v)
            | _ -> ())
         | Nod_ir.Ir.Store (src, mem) ->
           (match mem with
            | Nod_ir.Mem.Address { base = Nod_ir.Lit_or_var.Var v; offset } ->
              if offset = 0 && Hashtbl.mem slots (var_of_value v)
              then record_store (var_of_value v) i src
              else if Hashtbl.mem slots (var_of_value v)
              then mark_bad (var_of_value v)
            | _ -> ())
         | Nod_ir.Ir.Atomic_load { addr; _ }
         | Nod_ir.Ir.Atomic_store { addr; _ }
         | Nod_ir.Ir.Atomic_rmw { addr; _ }
         | Nod_ir.Ir.Atomic_cmpxchg { addr; _ } ->
           (match addr with
            | Nod_ir.Mem.Address { base = Nod_ir.Lit_or_var.Var v; _ } ->
              let pv = var_of_value v in
              if Hashtbl.mem slots pv then mark_bad pv
            | _ -> ())
         | _ ->
           let used = Ir.uses i.Instr_state.ir in
           List.iter used ~f:(fun value ->
             let var = var_of_value value in
             if Hashtbl.mem slots var
             then (
               match i.Instr_state.ir with
               | Nod_ir.Ir.Load (_, mem) | Nod_ir.Ir.Store (_, mem) ->
                 if base_is_ptr_value_var ~ptr:var mem then () else mark_bad var
               | _ -> mark_bad var)));
        iter_instrs i.Instr_state.next
    in
    iter_instrs (Block.instructions block)

  let allocas_in_block (block : Block.t) =
    let acc = ref [] in
    let rec iter instr =
      match instr with
      | None -> ()
      | Some i ->
        (match i.Instr_state.ir with
         | Nod_ir.Ir.Alloca { dest; _ } -> acc := var_of_value dest :: !acc
         | _ -> ());
        iter i.Instr_state.next
    in
    iter (Block.instructions block);
    !acc
  ;;

  let collect_slots root : slot list =
    let slots : (Typed_var.t, slot) Hashtbl.t = Typed_var.Table.create () in
    Block.iter root ~f:(fun block ->
      List.iter (allocas_in_block block) ~f:(fun dest ->
        Hashtbl.set slots ~key:dest ~data:(create_slot dest)));
    Block.iter root ~f:(scan_block_slots slots);
    Hashtbl.data slots
  ;;

  let block_has_store_to slot block =
    List.exists !(slot.stores) ~f:(fun (b, _) -> phys_equal b block)
  ;;

  let build_idom_parent idom_tree =
    let parent = Block.Table.create () in
    Hashtbl.iteri idom_tree ~f:(fun ~key:par ~data:children ->
      Hash_set.iter children ~f:(fun ch ->
        if phys_equal ch par then () else Hashtbl.set parent ~key:ch ~data:par));
    parent
  ;;

  let load_dominated_by_store slot ~idom_parent : bool =
    let has_store_in_ancestors b =
      let rec up curr =
        if block_has_store_to slot curr
        then true
        else (
          match Hashtbl.find idom_parent curr with
          | None -> false
          | Some p -> if phys_equal p curr then false else up p)
      in
      up b
    in
    let same_block_store_before_load block load_instr =
      let rec scan seen_store instr =
        match instr with
        | None -> false
        | Some i ->
          if phys_equal i load_instr
          then seen_store
          else (
            let seen_store =
              seen_store
              || (match i.Instr_state.ir with
                 | Nod_ir.Ir.Store (_, mem)
                   when base_is_ptr_value_var ~ptr:slot.ptr mem ->
                   true
                 | _ -> false)
            in
            scan seen_store i.Instr_state.next)
      in
      scan false (Block.instructions block)
    in
    List.for_all !(slot.loads) ~f:(fun (b, load_i) ->
      same_block_store_before_load b load_i || has_store_in_ancestors b)
  ;;

  let df_of_block t ~block =
    Analysis.Dominance.frontier_blocks (Analysis.Def_use.dominance t.analysis) ~block
  ;;

  let rec insert_phi_for_var ~fn_state ~var ~work ~placed ~df_of =
    match work with
    | [] -> ()
    | b :: rest ->
      let frontier = df_of b in
      let rest =
        List.fold frontier ~init:rest ~f:(fun acc y ->
          if not (Nod_vec.mem (Block.args y) var ~compare:Typed_var.compare)
          then (
            Fn_state.set_block_args
              fn_state
              ~block:y
              ~args:
                (Nod_vec.of_list (Nod_vec.to_list (Block.args y) @ [ var ]));
            if Hash_set.mem placed y then acc else (Hash_set.add placed y; y :: acc))
          else acc)
      in
      insert_phi_for_var ~fn_state ~var ~work:rest ~placed ~df_of
  ;;

  let promote t =
    let fn_state = fn_state t in
    let idom_parent = build_idom_parent t.idom_tree in
    let slots = collect_slots (Analysis.Def_use.root t.analysis) in
    let eligible =
      List.filter slots ~f:(fun s ->
        (not s.bad_use)
        && (match s.val_type with Some _ -> true | None -> false)
        && load_dominated_by_store s ~idom_parent)
    in
    List.iter eligible ~f:(fun slot ->
      let value_type = Option.value_exn slot.val_type in
      let base_name = Typed_var.name slot.ptr ^ "$v" in
      let var_slot = Typed_var.create ~name:base_name ~type_:value_type in
      (* Phi insertion on DF of store blocks. *)
      let def_blocks =
        List.map !(slot.stores) ~f:fst |> Block.Hash_set.of_list
      in
      let placed = Block.Hash_set.create () in
      let work = Hash_set.to_list def_blocks in
      insert_phi_for_var
        ~fn_state
        ~var:var_slot
        ~work
        ~placed
        ~df_of:(fun b -> df_of_block t ~block:b);
      (* Rewrite loads/stores and remove allocas. *)
      let rewrite_block (block : Block.t) =
        let rec go instr =
          match instr with
          | None -> ()
          | Some i ->
            let next = i.Instr_state.next in
            (match i.Instr_state.ir with
             | Nod_ir.Ir.Load (dest, mem)
               when base_is_ptr_value_var ~ptr:slot.ptr mem ->
               let var_slot_value = Fn_state.ensure_value fn_state ~var:var_slot in
               Fn_state.replace_instr_with_irs
                 fn_state
                 ~block
                 ~instr:i
                 ~with_irs:[ Nod_ir.Ir.Move (dest, Nod_ir.Lit_or_var.Var var_slot_value) ]
             | Nod_ir.Ir.Store (src, mem)
               when base_is_ptr_value_var ~ptr:slot.ptr mem ->
               let var_slot_value = Fn_state.ensure_value fn_state ~var:var_slot in
               Fn_state.replace_instr_with_irs
                 fn_state
                 ~block
                 ~instr:i
                 ~with_irs:[ Nod_ir.Ir.Move (var_slot_value, src) ]
             | Nod_ir.Ir.Alloca { dest; _ }
               when Typed_var.compare (var_of_value dest) slot.ptr = 0 ->
               Fn_state.replace_instr_with_irs fn_state ~block ~instr:i ~with_irs:[]
             | _ -> ());
            go next
        in
        go (Block.instructions block)
      in
      Block.iter (Analysis.Def_use.root t.analysis) ~f:rewrite_block);
    t
  ;;
end

let mem2reg t = Mem2reg.promote t

(* Pass 4: Rename into SSA using stacks per original variable. *)
let rename_into_ssa t =
  let stacks = ref Typed_var.Map.empty in
  let push_name var renamed_value =
    let stack = Map.find !stacks var |> Option.value ~default:[] in
    stacks := Map.set !stacks ~key:var ~data:(renamed_value :: stack)
  in
  let name value =
    match Map.find !stacks (Value_state.var value) with
    | None | Some [] -> value
    | Some (x :: _) -> x
  in
  let rec go block =
    let replace_use = name in
    let replace_uses instr = Ir.map_uses instr ~f:replace_use in
    let replace_def value =
      let var = Value_state.var value in
      let renamed_var = fresh_name t var in
      let renamed_value = Fn_state.ensure_value (fn_state t) ~var:renamed_var in
      push_name var renamed_value;
      renamed_value
    in
    let replace_defs instr = Ir.map_defs instr ~f:replace_def in
    let stacks_before = !stacks in
    let replace_arg var =
      let renamed_var = fresh_name t var in
      let renamed_value = Fn_state.ensure_value (fn_state t) ~var:renamed_var in
      push_name var renamed_value;
      renamed_var
    in
    Fn_state.set_block_args
      (fn_state t)
      ~block
      ~args:(Nod_vec.map (Block.args block) ~f:replace_arg);
    let rec rename_instrs instr =
      match instr with
      | None -> ()
      | Some instr ->
        let next = instr.Instr_state.next in
        let new_ir = instr.Instr_state.ir |> replace_uses |> replace_defs in
        let new_instr = Fn_state.alloc_instr (fn_state t) ~ir:new_ir in
        Fn_state.replace_instr
          (fn_state t)
          ~block
          ~instr
          ~with_instrs:[ new_instr ];
        rename_instrs next
    in
    rename_instrs (Block.instructions block);
    Fn_state.replace_terminal_ir
      (fn_state t)
      ~block
      ~with_:(replace_uses (Block.terminal block).ir);
    Option.iter
      (Hashtbl.find t.idom_tree block)
      ~f:
        (Hash_set.iter ~f:(fun child ->
           if phys_equal child block then () else go child));
    stacks := stacks_before
  in
  go (Analysis.Def_use.root t.analysis);
  t
;;

let create ~fn_state (~root, ~blocks:_, ~in_order:_) =
  Analysis.Def_use.create ~fn_state root
  |> with_idom_tree
  |> insert_phi_args
  (* Promote eligible stack slots to registers via mem2reg. *)
  |> mem2reg
  |> propagate_args_to_calls
  |> prune_unused_args
  |> rename_into_ssa
;;

let root t = Analysis.Def_use.root t.analysis

let convert_program program ~state =
  let functions =
    Map.mapi program.Program.functions ~f:(fun ~key:name ~data:fn ->
      Function.map_root fn ~f:(fun root_data ->
        let ssa = create ~fn_state:(State.fn_state state name) root_data in
        root ssa))
  in
  { program with Program.functions }
;;
