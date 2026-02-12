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
