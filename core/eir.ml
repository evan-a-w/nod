open! Ssa
open! Core
open! Import

module Tags = Opt_tags

type raw_block =
  instrs_by_label:string Ir0.t Vec.t String.Map.t * labels:string Vec.t

type input = (raw_block Program.t, Nod_error.t) Result.t

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

module Opt = struct
  let defining_vars_for_block_arg ~block ~arg =
    let idx =
      Vec.findi block.Block.args ~f:(fun i s ->
        if Var.equal arg s then Some i else None)
      |> Option.value_exn
    in
    Vec.filter_map block.parents ~f:(fun parent ->
      match
        Ir.filter_map_call_blocks
          parent.terminal.ir
          ~f:(fun { Ir.Call_block.block = block'; args } ->
            if phys_equal block' block
            then Some (List.nth_exn args idx)
            else None)
      with
      | [] -> None
      | xs -> Some xs)
    |> Vec.to_list
    |> List.concat
  ;;

  type t =
    { ssa : Ssa.t
    ; ssa_state : Ssa_state.t
    ; opt_flags : Opt_flags.t
    ; instr_blocks : Block.t Instr_id.Table.t
    ; vars : Var.Hash_set.t
    }

  let create ~opt_flags ssa =
    let state = ssa.state in
    let instr_blocks = Instr_id.Table.create () in
    let vars = Var.Hash_set.create () in
    let visited = Block.Hash_set.create () in
    let rec visit block =
      if Hash_set.mem visited block
      then ()
      else (
        Hash_set.add visited block;
        Vec.iter block.Block.args ~f:(Hash_set.add vars);
        Block.iter_instrs block ~f:(fun instr ->
          Hashtbl.set instr_blocks ~key:instr.Ssa_instr.id ~data:block;
          List.iter (Ir.defs instr.Ssa_instr.ir) ~f:(Hash_set.add vars));
        Vec.iter block.children ~f:visit)
    in
    visit ssa.def_uses.root;
    { ssa; ssa_state = state; opt_flags; instr_blocks; vars }

  let value_opt t var = Ssa_state.value_by_var t.ssa_state var
  let value_exn t var = Option.value_exn (value_opt t var)

  let instr_exn t instr_id =
    Ssa_state.instr t.ssa_state instr_id |> Option.value_exn

  let block_of_instr t instr_id = Hashtbl.find_exn t.instr_blocks instr_id

  let constant_fold t ~instr =
    let instr =
      Ir.map_lit_or_vars instr ~f:(function
        | Ir.Lit_or_var.Lit _ as lit -> lit
        | Global _ as global -> global
        | Var var ->
          (match value_opt t var with
           | Some value ->
             (match value.Ssa_value.opt_tags.constant with
              | Some c -> Lit c
              | None -> Var var)
           | None -> Var var))
    in
    Ir.constant_fold instr

  let replace_defining_instruction t ~value ~new_ir =
    match value.Ssa_value.def with
    | Def_site.Instr instr_id ->
      let instr = instr_exn t instr_id in
    Ssa_state.replace_instr_ir t.ssa_state instr ~ir:new_ir
    | Def_site.Block_arg _ | Def_site.Undefined -> ()

  let replace_terminal t ~block ~new_ir =
    let old_terminal = block.Block.terminal in
    let old_ir = old_terminal.ir in
    let old_blocks = Ir.blocks old_ir in
    let new_blocks = Ir.blocks new_ir in
    let diff =
      List.filter old_blocks ~f:(fun block' ->
        not (List.mem new_blocks block' ~equal:phys_equal))
    in
    Vec.switch block.children (Vec.of_list new_blocks);
    List.iter diff ~f:(fun block' ->
      Vec.switch
        block'.parents
        (Vec.filter block'.parents ~f:(Fn.non (phys_equal block))));
    Ssa_state.set_terminal_ir t.ssa_state ~block ~ir:new_ir

  let remove_arg_from_parent t ~parent ~idx ~from_block =
    let new_ =
      Ir.map_call_blocks parent.Block.terminal.ir ~f:(fun cb ->
        if phys_equal cb.block from_block
        then { cb with args = List.filteri cb.args ~f:(fun i _ -> i <> idx) }
        else cb)
    in
    Ssa_state.set_terminal_ir t.ssa_state ~block:parent ~ir:new_

  let remove_arg t ~block ~arg =
    let idx =
      Vec.findi block.Block.args ~f:(fun i s ->
        if Var.equal arg s then Some i else None)
      |> Option.value_exn
    in
    let old_args = Vec.to_list block.Block.args in
    block.args <- Vec.filter block.args ~f:(Fn.non (Var.equal arg));
    let new_args = Vec.to_list block.Block.args in
    Ssa_state.update_block_args t.ssa_state ~block ~old_args ~new_args;
    Vec.iter block.parents ~f:(fun parent ->
      remove_arg_from_parent t ~parent ~idx ~from_block:block)

  let kill_definition t var =
    match value_opt t var with
    | None -> false
    | Some value ->
      (match value.Ssa_value.def with
       | Def_site.Instr instr_id ->
         let block = block_of_instr t instr_id in
         let instr = instr_exn t instr_id in
         Ssa_state.remove_instr t.ssa_state ~block ~instr;
         value.Ssa_value.def <- Def_site.Undefined;
         value.Ssa_value.opt_tags <- Tags.empty;
         true
        | Def_site.Block_arg { block; _ } ->
          remove_arg t ~block ~arg:var;
         value.Ssa_value.def <- Def_site.Undefined;
         value.Ssa_value.opt_tags <- Tags.empty;
         true
       | Def_site.Undefined -> false)

  let rec refine_terminal t ~block =
    let terminal = block.Block.terminal in
    let new_ir = constant_fold t ~instr:terminal.ir in
    replace_terminal t ~block ~new_ir

  and refine_type_instr t var value =
    match value.Ssa_value.def with
    | Def_site.Instr instr_id ->
      let instr = instr_exn t instr_id in
      let new_ir = constant_fold t ~instr:instr.Ssa_instr.ir in
      replace_defining_instruction t ~value ~new_ir;
      (match Ir.constant new_ir with
       | None -> ()
       | Some _ as constant ->
         value.Ssa_value.opt_tags <- { constant };
         let block = block_of_instr t instr_id in
         let terminal_uses = Ir.uses block.Block.terminal.ir in
         if List.exists terminal_uses ~f:(Var.equal var)
         then refine_terminal t ~block)
    | _ -> ()

  and refine_type_block_arg t var value =
    match value.Ssa_value.def with
    | Def_site.Block_arg { block; _ } ->
      defining_vars_for_block_arg ~block ~arg:var
      |> List.filter_map ~f:(fun incoming ->
           Option.bind (value_opt t incoming) ~f:(fun v -> v.Ssa_value.opt_tags.constant))
      |> function
      | [] -> ()
      | constant :: xs ->
        let constant =
          List.fold xs ~init:(Some constant) ~f:(fun acc constant' ->
            match acc with
            | None -> None
            | Some a when Int64.equal a constant' -> acc
            | Some _ -> None)
        in
        value.Ssa_value.opt_tags <- { constant }
    | _ -> ()

  and refine_type t var value =
    match value.Ssa_value.opt_tags.constant with
    | Some _ -> ()
    | None ->
      (match value.Ssa_value.def with
       | Def_site.Block_arg _ -> refine_type_block_arg t var value
       | Def_site.Instr _ -> refine_type_instr t var value
       | Def_site.Undefined -> ())

  let rec dfs_vars t ~f =
    let seen = Var.Hash_set.create () in
    let rec go var =
      if Hash_set.mem seen var
      then ()
      else (
        Hash_set.add seen var;
        (match value_opt t var with
         | None -> ()
         | Some value ->
           (match value.Ssa_value.def with
            | Def_site.Instr instr_id ->
              let instr = instr_exn t instr_id in
              List.iter (Ir.uses instr.Ssa_instr.ir) ~f:go
            | Def_site.Block_arg { block; _ } ->
              defining_vars_for_block_arg ~block ~arg:var |> List.iter ~f:go
            | Def_site.Undefined -> ());
           f var value))
    in
    Hash_set.iter t.vars ~f:go

  let rec remove_unused t =
    let removed =
      Hash_set.fold t.vars ~init:false ~f:(fun removed var ->
        kill_unused_var t var || removed)
    in
    if removed then remove_unused t

  and kill_unused_var t var =
    match value_opt t var with
    | None -> false
    | Some value ->
      (match value.Ssa_value.def with
       | Def_site.Undefined -> false
       | _ ->
         (match value.Ssa_value.uses with
          | [] -> kill_definition t var
          | [ use ] ->
            (match value.Ssa_value.def with
             | Def_site.Block_arg { block; arg } ->
               let terminal_id = block.Block.terminal.id in
               if Instr_id.equal use terminal_id
                  && let arg_var = Vec.get block.Block.args arg in
                     List.equal Var.equal [ arg_var ]
                       (defining_vars_for_block_arg ~block ~arg:arg_var)
               then kill_definition t var
               else false
             | _ -> false)
          | _ -> false))

  let run t =
    if Opt_flags.constant_propagation t.opt_flags
    then dfs_vars t ~f:(fun var value -> refine_type t var value);
    if Opt_flags.constant_propagation t.opt_flags
    then Block.iter t.ssa.def_uses.root ~f:(fun block -> refine_terminal t ~block);
    if Opt_flags.unused_vars t.opt_flags then remove_unused t
end

let map_program_roots ~f program = Program.map_function_roots program ~f

let set_entry_block_args ~state program =
  Map.iteri
    program.Program.functions
    ~f:(fun ~key:name ~data:{ Function.root = root_data; args; _ } ->
      let ~root:block, ~blocks:_, ~in_order:_ = root_data in
      let function_state = State.state_for_function state name in
      let old_args = Vec.to_list block.Block.args in
      List.iter args ~f:(Vec.push block.Block.args);
      let new_args = Vec.to_list block.Block.args in
      Ssa_state.update_block_args function_state ~block ~old_args ~new_args);
  program
;;

let type_check_block block =
  let open Result.Let_syntax in
  let%bind () =
    List.fold (Block.instrs_to_ir_list block) ~init:(Ok ()) ~f:(fun acc instr ->
      let%bind () = acc in
      Ir.check_types instr)
  in
  Ir.check_types block.Block.terminal.ir
;;

let type_check_cfg (~root, ~blocks:_, ~in_order:_) =
  let open Result.Let_syntax in
  let seen = String.Hash_set.create () in
  let rec go block =
    if Hash_set.mem seen block.Block.id_hum
    then Ok ()
    else (
      Hash_set.add seen block.Block.id_hum;
      let%bind () = type_check_block block in
      Vec.fold block.Block.children ~init:(Ok ()) ~f:(fun acc child ->
        let%bind () = acc in
        go child))
  in
  go root
;;

let type_check_program program =
  Map.fold
    program.Program.functions
    ~init:(Ok ())
    ~f:(fun ~key:_ ~data:fn acc ->
      let open Result.Let_syntax in
      let%bind () = acc in
      type_check_cfg fn.Function.root)
;;

let lower_aggregate_program ~state program =
  Map.fold
    program.Program.functions
    ~init:(Ok ())
    ~f:(fun ~key:name ~data:fn acc ->
      let open Result.Let_syntax in
      let%bind () = acc in
      let { Function.root = ~root:block, ~blocks:_, ~in_order:_; _ } = fn in
      let function_state = State.state_for_function state name in
      Ir.lower_aggregates ~state:function_state ~root:block)
  |> Result.map ~f:(fun () -> program)
;;

let optimize_root ?(opt_flags = Opt_flags.default) ssa =
  let opt_state = Opt.create ~opt_flags ssa in
  Opt.run opt_state
;;

let optimize ?opt_flags program =
  Map.iter
    ~f:(fun ({ root; _ } : _ Function.t') -> optimize_root ?opt_flags root)
    program.Program.functions
;;

let compile ?opt_flags ~state (input : input) =
  State.reset state;
  match
    Result.map input ~f:(fun program ->
      Program.map_function_roots_with_name program ~f:(fun ~name root ->
        let function_state = State.ensure_function state name in
        Cfg.process ~state:function_state root))
    |> Result.map ~f:(set_entry_block_args ~state)
    |> Result.bind ~f:(fun program ->
      type_check_program program |> Result.map ~f:(fun () -> program))
    |> Result.bind ~f:(lower_aggregate_program ~state)
    |> Result.map ~f:(fun program ->
      Program.map_function_roots_with_name program ~f:(fun ~name root ->
        let function_state = State.state_for_function state name in
        Ssa.create ~state:function_state root))
  with
  | Error _ as e -> e
  | Ok program ->
    optimize ?opt_flags program;
    Ok (map_program_roots ~f:Ssa.root program)
;;
