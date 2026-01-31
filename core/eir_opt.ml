open! Ssa
open! Core
open! Import

module Opt_flags = struct
  type t =
    { unused_vars : bool
    ; constant_propagation : bool
    ; gvn : bool
    }
  [@@deriving fields]

  let default = { unused_vars = true; constant_propagation = true; gvn = true }

  let no_opt =
    { unused_vars = false; constant_propagation = false; gvn = false }
  ;;
end

type block_tracker =
  { mutable needed : Value_state.Set.t Block.Map.t
  ; once_ready : Block.t -> unit
  }

type context =
  { ssa : Ssa.t
  ; fn_state : Fn_state.t
  ; opt_flags : Opt_flags.t
  ; block_by_id : Block.t String.Table.t
  ; mutable block_tracker : block_tracker option
  }

let create_context ~opt_flags ssa =
  let block_by_id = String.Table.create () in
  Block.iter (Ssa.root ssa) ~f:(fun block ->
    Hashtbl.set block_by_id ~key:(Block.id_hum block) ~data:block);
  { ssa
  ; fn_state = Ssa.fn_state ssa
  ; opt_flags
  ; block_by_id
  ; block_tracker = None
  }
;;

let rec iter_blocks ctx ~block ~f =
  f block;
  Hashtbl.find ctx.ssa.immediate_dominees block
  |> Option.iter
       ~f:
         (Hash_set.iter ~f:(fun block' ->
            if phys_equal block' block
            then ()
            else iter_blocks ctx ~block:block' ~f))
;;

let iter_blocks ctx ~f = iter_blocks ctx ~block:(Ssa.root ctx.ssa) ~f

let value_of_var ctx var = Fn_state.value_by_var ctx.fn_state var
let value_of_var_exn ctx var = Fn_state.ensure_value ctx.fn_state ~var

let active_value (value : Value_state.t) =
  if value.Value_state.active then Some value else None

let active_value_of_var ctx var =
  value_of_var ctx var |> Option.bind ~f:active_value
;;
;;

module Block_tracker = struct
  type t = block_tracker

  let ready t ~var ~block =
    t.needed
    <- Map.change t.needed block ~f:(function
         | None -> None
         | Some vars ->
           let vars = Set.remove vars var in
           if Set.length vars = 0
           then (
             t.once_ready block;
             None)
           else Some vars)
  ;;

  let create ctx ~once_ready =
    let t = { needed = Block.Map.empty; once_ready } in
    iter_blocks ctx ~f:(fun block ->
      let data =
        Ssa.uses_values ctx.ssa (Block.terminal block).Instr_state.ir
        |> List.filter_map ~f:active_value
        |> Value_state.Set.of_list
      in
      if Set.length data = 0
      then once_ready block
      else t.needed <- Map.set t.needed ~key:block ~data);
    t
  ;;
end

let block_for_instr_id_exn ctx instr_id =
  Fn_state.instr_block ctx.fn_state instr_id |> Option.value_exn
;;

let def_block_exn ctx (value : Value_state.t) =
  match value.Value_state.def with
  | Def_site.Block_arg { block_id; _ } ->
    Hashtbl.find_exn ctx.block_by_id block_id
  | Def_site.Instr instr_id -> block_for_instr_id_exn ctx instr_id
  | Def_site.Undefined -> failwith "value has no definition"
;;

(* TODO: implement, call when constant folding terminals and
   when deleting instructions *)
(* if [block] is unnecessary, remove it *)
let kill_block (_ : context) ~block:_ = ()

let defining_values_for_block_arg ctx ~block ~arg_index =
  Vec.filter_map (Block.parents block) ~f:(fun parent ->
    let parent_terminal = Block.terminal parent in
    match
      Ir.filter_map_call_blocks
        parent_terminal.Instr_state.ir
        ~f:(fun { Ir.Call_block.block = block'; args } ->
          if phys_equal block' block
          then Some (List.nth_exn args arg_index)
          else None)
    with
    | [] -> None
    | xs -> Some xs)
  |> Vec.to_list
  |> List.concat
;;

(* --- Dead code elimination helpers --- *)
let rec remove_instr ctx ~block ~instr =
  let used_values = Ssa.uses_values ctx.ssa instr.Instr_state.ir in
  Fn_state.remove_instr ctx.fn_state ~block ~instr;
  List.iter used_values ~f:(fun value ->
    match active_value value with
    | None -> ()
    | Some value ->
      if Set.is_empty value.Value_state.uses then try_kill_value ctx ~value)

and remove_arg_from_parent ctx ~parent ~idx ~from_block =
  let removed = ref [] in
  let parent_terminal = Block.terminal parent in
  let new_ir =
    Ir.map_call_blocks parent_terminal.Instr_state.ir ~f:(fun cb ->
      if not (phys_equal cb.block from_block)
      then cb
      else
        { cb with
          args =
            List.filteri cb.args ~f:(fun i var ->
              if i = idx
              then (
                removed := var :: !removed;
                false)
              else true)
        })
  in
  Fn_state.replace_terminal_ir ctx.fn_state ~block:parent ~with_:new_ir;
  List.iter !removed ~f:(fun value ->
    match active_value value with
    | None -> ()
    | Some value -> if Set.is_empty value.Value_state.uses then try_kill_value ctx ~value)

and remove_arg ctx ~block ~arg_index =
  let args = Block.args block in
  let new_args = Vec.create () in
  Vec.iteri args ~f:(fun i arg ->
    if not (Int.equal i arg_index) then Vec.push new_args arg);
  Fn_state.set_block_args
    ctx.fn_state
    ~block
    ~args:new_args;
  Vec.iter (Block.parents block) ~f:(fun parent ->
    remove_arg_from_parent ctx ~parent ~idx:arg_index ~from_block:block)

and kill_definition ctx (value : Value_state.t) =
  if not value.Value_state.active
  then ()
  else (
    value.Value_state.active <- false;
    let def_block =
      match value.Value_state.def with
      | Def_site.Undefined -> None
      | _ -> Some (def_block_exn ctx value)
    in
    (match value.Value_state.def with
     | Def_site.Instr instr_id ->
       let instr = Fn_state.instr ctx.fn_state instr_id |> Option.value_exn in
       Option.iter def_block ~f:(fun block -> remove_instr ctx ~block ~instr)
     | Def_site.Block_arg { block_id; arg } ->
       let block = Hashtbl.find_exn ctx.block_by_id block_id in
       remove_arg ctx ~block ~arg_index:arg
     | Def_site.Undefined -> ());
    Option.iter ctx.block_tracker ~f:(fun tracker ->
      Option.iter def_block ~f:(fun block ->
        Block_tracker.ready tracker ~var:value ~block)))

and try_kill_value ctx ~(value : Value_state.t) =
  if not value.Value_state.active
  then ()
  else (
    match Set.length value.Value_state.uses, value.Value_state.def with
    | 0, _ -> kill_definition ctx value
    | 1, Def_site.Block_arg { block_id; arg } ->
      (* weird case in our ssa algo that is borked, fix it here *)
      let block = Hashtbl.find_exn ctx.block_by_id block_id in
      let use_id = Set.min_elt_exn value.Value_state.uses in
      let arg_value = value_of_var_exn ctx (Vec.get (Block.args block) arg) in
      if Instr_id.equal use_id (Block.terminal block).Instr_state.id
         && List.equal
              Value_state.equal
              [ arg_value ]
              (defining_values_for_block_arg ctx ~block ~arg_index:arg)
      then kill_definition ctx value
      else ()
    | _, _ ->
      (* can't trim *)
      ())
;;

let update_uses ctx ~old_ir ~new_ir =
  let old_values = Value_state.Set.of_list (Ssa.uses_values ctx.ssa old_ir) in
  let new_values = Value_state.Set.of_list (Ssa.uses_values ctx.ssa new_ir) in
  Set.iter (Set.diff old_values new_values)
    ~f:(fun value ->
      match active_value value with
      | None -> ()
      | Some value ->
        if Opt_flags.unused_vars ctx.opt_flags && Set.is_empty value.Value_state.uses
        then try_kill_value ctx ~value)
;;

(* --- Constant propagation helpers --- *)
let constant_fold ctx ~instr =
  let instr =
    Ir.map_lit_or_vars instr ~f:(fun lit_or_var ->
      match lit_or_var with
      | Lit _ -> lit_or_var
      | Var value ->
        (match value.Value_state.opt_tags.constant with
         | Some i -> Lit i
         | None -> lit_or_var)
      | Global _ -> lit_or_var)
  in
  Ir.constant_fold instr
;;

(* must be strict subset of uses and such *)
let replace_defining_instruction ctx ~(value : Value_state.t) ~new_ir =
  let old_instr_id =
    match value.Value_state.def with
    | Def_site.Block_arg _ ->
      failwith "Can't replace defining instr for block arg"
    | Def_site.Instr instr_id -> instr_id
    | Def_site.Undefined -> failwith "value has no definition"
  in
  let def_block = def_block_exn ctx value in
  let old_instr =
    Fn_state.instr ctx.fn_state old_instr_id |> Option.value_exn
  in
  let new_instr = Fn_state.alloc_instr ctx.fn_state ~ir:new_ir in
  Fn_state.replace_instr
    ctx.fn_state
    ~block:def_block
    ~instr:old_instr
    ~with_instrs:[ new_instr ];
  update_uses ctx ~old_ir:old_instr.Instr_state.ir ~new_ir
;;

(* must be strict subset of uses and such *)
let replace_terminal ctx ~block ~new_terminal_ir =
  let old_terminal = Block.terminal block in
  let old_blocks = Ir.blocks old_terminal.Instr_state.ir in
  let new_blocks = Ir.blocks new_terminal_ir in
  let diff =
    List.filter old_blocks ~f:(fun block' ->
      not (List.mem new_blocks block' ~equal:phys_equal))
  in
  Vec.switch (Block.Expert.children block) (Vec.of_list new_blocks);
  List.iter diff ~f:(fun block' ->
    Vec.switch
      (Block.Expert.parents block')
      (Vec.filter (Block.parents block') ~f:(Fn.non (phys_equal block))));
  Fn_state.replace_terminal_ir ctx.fn_state ~block ~with_:new_terminal_ir;
  update_uses ctx ~old_ir:old_terminal.Instr_state.ir ~new_ir:new_terminal_ir
;;

let rec refine_type ctx ~(value : Value_state.t) =
  match value.Value_state.opt_tags.constant with
  | Some _ -> ()
  | None ->
    (match value.Value_state.def with
     | Def_site.Block_arg { block_id; arg } ->
       let block = Hashtbl.find_exn ctx.block_by_id block_id in
       refine_type_block_arg ctx ~value ~block ~arg_index:arg
     | Def_site.Instr instr_id -> refine_type_instr ctx ~value ~instr_id
     | Def_site.Undefined -> ())

and refine_type_block_arg ctx ~value ~block ~arg_index =
  defining_values_for_block_arg ctx ~block ~arg_index
  |> List.map ~f:(fun x -> x.opt_tags.constant)
  |> function
  | [] -> ()
  | constant :: xs ->
    let constant =
      List.fold xs ~init:constant ~f:(fun acc constant' ->
        match acc, constant' with
        | Some a, Some b when Int64.equal a b -> acc
        | _ -> None)
    in
    value.Value_state.opt_tags <- { constant }

and refine_type_instr ctx ~value ~instr_id =
  let instr = Fn_state.instr ctx.fn_state instr_id |> Option.value_exn in
  let new_ir = constant_fold ctx ~instr:instr.Instr_state.ir in
  replace_defining_instruction ctx ~value ~new_ir;
  match Ir.constant new_ir with
  | None -> ()
  | Some _ as constant ->
    value.Value_state.opt_tags <- { constant };
    let terminal_uses =
      Ssa.uses_values
        ctx.ssa
        (Block.terminal (def_block_exn ctx value)).Instr_state.ir
    in
    if List.exists terminal_uses ~f:(fun use ->
         Value_state.equal use value)
    then refine_terminal ctx ~block:(def_block_exn ctx value)

and refine_terminal ctx ~block =
  let terminal = Block.terminal block in
  let new_terminal_ir = constant_fold ctx ~instr:terminal.Instr_state.ir in
  replace_terminal ctx ~block ~new_terminal_ir
;;

let gvn (_ctx : context) ~(value : Value_state.t) =
  let _ = value in
  ()
;;

type pass =
  { name : string
  ; enabled : Opt_flags.t -> bool
  ; on_value : (context -> Value_state.t -> unit) option
  ; on_terminal : (context -> Block.t -> unit) option
  }

let sweep_values ?on_terminal ctx ~on_value =
  let seen = Int.Hash_set.create () in
  Option.iter on_terminal ~f:(fun once_ready ->
    let tracker = Block_tracker.create ctx ~once_ready in
    assert (Option.is_none ctx.block_tracker);
    ctx.block_tracker <- Some tracker);
  let instr_exn instr_id =
    Fn_state.instr ctx.fn_state instr_id |> Option.value_exn
  in
  let rec go (value : Value_state.t) =
    let (Value_id id) = value.id in
    if Hash_set.mem seen id
    then ()
    else (
      Hash_set.add seen id;
      let def_block =
        match value.Value_state.def with
        | Def_site.Block_arg { block_id; _ } ->
          Some (Hashtbl.find_exn ctx.block_by_id block_id)
        | Def_site.Instr _ -> Some (def_block_exn ctx value)
        | Def_site.Undefined -> None
      in
      (match value.Value_state.def with
       | Def_site.Block_arg _ -> on_value value
       | Def_site.Instr instr_id ->
         let instr = instr_exn instr_id in
         List.iter
           (Ssa.uses_values ctx.ssa instr.Instr_state.ir)
           ~f:(fun use -> Option.iter (active_value use) ~f:go);
         on_value value
       | Def_site.Undefined -> ());
      Option.iter ctx.block_tracker ~f:(fun tracker ->
        Option.iter def_block ~f:(fun block ->
          Block_tracker.ready tracker ~var:value ~block)))
  in
  Vec.iter ctx.fn_state.values ~f:(function
    | None -> ()
    | Some value -> if value.Value_state.active then go value);
  Option.iter on_terminal ~f:(fun _ -> ctx.block_tracker <- None)
;;

let pass_constant_propagation =
  { name = "constant_propagation"
  ; enabled = Opt_flags.constant_propagation
  ; on_value = Some (fun ctx value -> refine_type ctx ~value)
  ; on_terminal = Some (fun ctx block -> refine_terminal ctx ~block)
  }
;;

let pass_dce =
  { name = "dce"
  ; enabled = Opt_flags.unused_vars
  ; on_value = Some (fun ctx value -> try_kill_value ctx ~value)
  ; on_terminal = None
  }
;;

let pass_gvn =
  { name = "gvn"
  ; enabled = Opt_flags.gvn
  ; on_value = Some (fun ctx value -> if value.Value_state.active then gvn ctx ~value)
  ; on_terminal = None
  }
;;

let passes = [ pass_constant_propagation; pass_dce; pass_gvn ]

let run ctx =
  let enabled_passes =
    List.filter passes ~f:(fun pass -> pass.enabled ctx.opt_flags)
  in
  let on_value value =
    List.iter enabled_passes ~f:(fun pass ->
      Option.iter pass.on_value ~f:(fun f -> f ctx value))
  in
  let on_terminal =
    if List.exists enabled_passes ~f:(fun pass ->
         Option.is_some pass.on_terminal)
    then
      Some
        (fun block ->
          List.iter enabled_passes ~f:(fun pass ->
            Option.iter pass.on_terminal ~f:(fun f -> f ctx block)))
    else None
  in
  sweep_values ctx ~on_value ?on_terminal
;;

let optimize_root ?(opt_flags = Opt_flags.default) ssa =
  let ctx = create_context ~opt_flags ssa in
  run ctx
;;

let optimize ?opt_flags program =
  Map.iter
    ~f:(fun ({ root; _ } : _ Function.t') -> optimize_root ?opt_flags root)
    program.Program.functions
;;
