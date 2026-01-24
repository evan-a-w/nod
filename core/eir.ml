open! Ssa
open! Core
open! Import
(* Planned opts/changes:
 
  8 opts: inline, unroll (& vectorise), cse, dce, code motion, constant fold, peephole

  Memory:

  First write in tags on ir to keep track of memory regions and stuff like reading and mutating which regions.
  Make sure these tags can be inserted in the frontend stage (at least make it possible, and later extend the parser to parse annotations)

   IR ops: alloca, gep/addr_of, load, store, and calls that may read/write memory.

   Only values are in SSA; memory is implicit shared state.

   Add metadata/flags to ops about effects: readonly, writeonly, argmemonly, noalias, nocapture, invariant.load, alignment, TBAA, etc.

   You need a notion of disjointness to optimize safely.

   Stack slots (alloca v): treat each alloca as its own location; quickly disjoint.

   Fields of aggregates: use field sensitivity. Treat p->x and p->y as different alias classes (use GEP indices/offsets).

   Globals: distinct by symbol + section (and possibly constant vs mutable).

   Heap objects: introduce object identity via allocation sites (context-sensitive if you like). A pointer’s “points-to set” is a set of alloc-sites.

   Address spaces/regions: sometimes you’ll model distinct regions (e.g., stack vs heap vs GPU local) as never-aliasing.

   This granularity is the backbone for AA and DSE.

  reg2mem

  SROA / mem2reg (promote allocas, split aggregates)

  GVN/CSE (values + loads)

  DSE (kills earlier stores)

  LICM (hoist invariant loads; sink dead stores)

  Loop vectorization / store & load widening (if you have it)

  DCE (clean up)

  Repeat (2–6) once; interleave with inlining and AA rebuild as needed.

  Run MemorySSA rebuild when necessary (cheap if incremental).
*)

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
  module Block_tracker0 = struct
    type t =
      { mutable needed : Var.Set.t Block.Map.t
      ; once_ready : Block.t -> unit
      }

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
  end

  type t =
    { ssa : Ssa.t
    ; fn_state : Fn_state.t
    ; opt_flags : Opt_flags.t
    ; mutable block_tracker : Block_tracker0.t option
    }

  let create ~opt_flags ssa =
    { ssa; fn_state = Ssa.fn_state ssa; opt_flags; block_tracker = None }
  ;;

  let rec iter_from t ~block ~f =
    f block;
    Hashtbl.find t.ssa.immediate_dominees block
    |> Option.iter
         ~f:
           (Hash_set.iter ~f:(fun block' ->
              if phys_equal block' block
              then ()
              else iter_from t ~block:block' ~f))
  ;;

  let value_by_var t var = Fn_state.value_by_var t.fn_state var

  let active_value t var =
    match value_by_var t var with
    | Some value when value.active -> Some value
    | _ -> None
  ;;

  let iter t ~f = iter_from t ~block:(Ssa.root t.ssa) ~f

  module Block_tracker = struct
    include Block_tracker0

    let create ~once_ready opt =
      let t = { needed = Block.Map.empty; once_ready } in
      iter opt ~f:(fun block ->
        let data =
          Ir.uses (Block.terminal block).Instr_state.ir
          |> List.filter_map ~f:(fun var ->
            active_value opt var |> Option.map ~f:(fun _ -> var))
          |> Var.Set.of_list
        in
        if Set.length data = 0
        then once_ready block
        else t.needed <- Map.set t.needed ~key:block ~data);
      t
    ;;
  end

  let block_for_instr_id_exn t instr_id =
    Fn_state.instr_block t.fn_state instr_id |> Option.value_exn
  ;;

  let def_block t (value : Value_state.t) =
    match value.def with
    | Def_site.Block_arg { block; _ } -> Some block
    | Def_site.Instr instr_id -> Some (block_for_instr_id_exn t instr_id)
    | Def_site.Undefined -> None
  ;;

  (* TODO: implement, call when constant folding terminals and
     when deleting instructions *)
  (* if [block] is unnecessary, remove it *)
  let kill_block (_ : t) ~block:_ = ()

  let defining_vars_for_block_arg ~block ~arg =
    let idx =
      Vec.findi (Block.args block) ~f:(fun i s ->
        if Var.equal arg s then Some i else None)
      |> Option.value_exn
    in
    Vec.filter_map (Block.parents block) ~f:(fun parent ->
      let parent_terminal = Block.terminal parent in
      match
        Ir.filter_map_call_blocks
          parent_terminal.Instr_state.ir
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

  let rec remove_instr t ~block ~instr =
    let used_vars = Ir.uses instr.Instr_state.ir in
    Fn_state.remove_instr t.fn_state ~block ~instr;
    List.iter used_vars ~f:(fun var ->
      match active_value t var with
      | None -> ()
      | Some value -> if Set.is_empty value.uses then try_kill_value t ~value)

  and remove_arg_from_parent t ~parent ~idx ~from_block =
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
    Fn_state.replace_terminal_ir t.fn_state ~block:parent ~with_:new_ir;
    List.iter !removed ~f:(fun var ->
      match active_value t var with
      | None -> ()
      | Some value -> if Set.is_empty value.uses then try_kill_value t ~value)

  and remove_arg t ~block ~arg =
    let idx =
      Vec.findi (Block.args block) ~f:(fun i s ->
        if Var.equal arg s then Some i else None)
      |> Option.value_exn
    in
    Fn_state.set_block_args
      t.fn_state
      ~block
      ~args:(Vec.filter (Block.args block) ~f:(Fn.non (Var.equal arg)));
    Vec.iter (Block.parents block) ~f:(fun parent ->
      remove_arg_from_parent t ~parent ~idx ~from_block:block)

  and kill_definition t (value : Value_state.t) =
    if not value.active
    then ()
    else (
      value.active <- false;
      let def_block = def_block t value in
      (match value.def with
       | Def_site.Instr instr_id ->
         let instr = Fn_state.instr t.fn_state instr_id |> Option.value_exn in
         Option.iter def_block ~f:(fun block -> remove_instr t ~block ~instr)
       | Def_site.Block_arg { block; arg } ->
         let arg_var = Vec.get (Block.args block) arg in
         remove_arg t ~block ~arg:arg_var
       | Def_site.Undefined -> ());
      Option.iter t.block_tracker ~f:(fun tracker ->
        Option.iter def_block ~f:(fun block ->
          Block_tracker.ready tracker ~var:value.var ~block)))

  and try_kill_value t ~(value : Value_state.t) =
    if not value.active
    then ()
    else (
      match Set.length value.uses, value.def with
      | 0, _ -> kill_definition t value
      | 1, Def_site.Block_arg { block; arg } ->
        (* weird case in our ssa algo that is borked, fix it here *)
        let use_id = Set.min_elt_exn value.uses in
        let arg_var = Vec.get (Block.args block) arg in
        if Instr_id.equal use_id (Block.terminal block).Instr_state.id
           && List.equal
                Var.equal
                [ arg_var ]
                (defining_vars_for_block_arg ~block ~arg:arg_var)
        then kill_definition t value
        else ()
      | _, _ ->
        (* can't trim *)
        ())
  ;;

  let dfs_vars ?on_terminal t ~f =
    let seen = Int.Hash_set.create () in
    Option.iter on_terminal ~f:(fun once_ready ->
      let block_tracker = Block_tracker.create ~once_ready t in
      assert (Option.is_none t.block_tracker);
      t.block_tracker <- Some block_tracker);
    let instr_exn instr_id =
      Fn_state.instr t.fn_state instr_id |> Option.value_exn
    in
    let rec go (value : Value_state.t) =
      let (Value_id id) = value.id in
      if Hash_set.mem seen id
      then ()
      else (
        Hash_set.add seen id;
        let def_block = def_block t value in
        (match value.def with
         | Def_site.Block_arg _ -> f ~value
         | Def_site.Instr instr_id ->
           let instr = instr_exn instr_id in
           List.iter (Ir.uses instr.Instr_state.ir) ~f:(fun use ->
             Option.iter (active_value t use) ~f:go);
           f ~value
         | Def_site.Undefined -> ());
        Option.iter t.block_tracker ~f:(fun tracker ->
          Option.iter def_block ~f:(fun block ->
            Block_tracker.ready tracker ~var:value.var ~block)))
    in
    Vec.iter t.fn_state.values ~f:(function
      | None -> ()
      | Some value -> if value.active then go value);
    Option.iter on_terminal ~f:(fun _ -> t.block_tracker <- None)
  ;;

  let constant_fold t ~instr =
    let instr =
      Ir.map_lit_or_vars instr ~f:(fun lit_or_var ->
        match lit_or_var with
        | Lit _ -> lit_or_var
        | Var var ->
          (match value_by_var t var with
           | Some value ->
             (match value.opt_tags.constant with
              | Some i -> Lit i
              | None -> lit_or_var)
           | None -> lit_or_var)
        | Global _ -> lit_or_var)
    in
    Ir.constant_fold instr
  ;;

  let update_uses t ~old_ir ~new_ir =
    let old_vars = Var.Set.of_list (Ir.uses old_ir) in
    let new_vars = Var.Set.of_list (Ir.uses new_ir) in
    Set.iter (Set.diff old_vars new_vars) ~f:(fun var ->
      match active_value t var with
      | None -> ()
      | Some value ->
        if Opt_flags.unused_vars t.opt_flags && Set.is_empty value.uses
        then try_kill_value t ~value)
  ;;

  (* must be strict subset of uses and such *)
  let replace_defining_instruction t ~(value : Value_state.t) ~new_ir =
    let old_instr_id =
      match value.def with
      | Def_site.Block_arg _ ->
        failwith "Can't replace defining instr for block arg"
      | Def_site.Instr instr_id -> instr_id
      | Def_site.Undefined -> failwith "value has no definition"
    in
    let def_block = def_block t value |> Option.value_exn in
    let old_instr =
      Fn_state.instr t.fn_state old_instr_id |> Option.value_exn
    in
    let new_instr = Fn_state.alloc_instr t.fn_state ~ir:new_ir in
    Fn_state.replace_instr
      t.fn_state
      ~block:def_block
      ~instr:old_instr
      ~with_instrs:[ new_instr ];
    update_uses t ~old_ir:old_instr.Instr_state.ir ~new_ir
  ;;

  (* must be strict subset of uses and such *)
  let replace_terminal t ~block ~new_terminal_ir =
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
    Fn_state.replace_terminal_ir t.fn_state ~block ~with_:new_terminal_ir;
    update_uses t ~old_ir:old_terminal.Instr_state.ir ~new_ir:new_terminal_ir
  ;;

  let rec refine_type t ~(value : Value_state.t) =
    match value.opt_tags.constant with
    | Some _ -> ()
    | None ->
      (match value.def with
       | Def_site.Block_arg { block; arg } ->
         let arg_var = Vec.get (Block.args block) arg in
         refine_type_block_arg t ~value ~block ~arg:arg_var
       | Def_site.Instr instr_id -> refine_type_instr t ~value ~instr_id
       | Def_site.Undefined -> ())

  and refine_type_block_arg t ~value ~block ~arg =
    let constant var =
      Option.map (value_by_var t var) ~f:(fun x -> x.opt_tags.constant)
    in
    defining_vars_for_block_arg ~block ~arg
    |> List.filter_map ~f:constant
    |> function
    | [] -> ()
    | constant :: xs ->
      let constant =
        List.fold xs ~init:constant ~f:(fun acc constant' ->
          match acc, constant' with
          | Some a, Some b when Int64.equal a b -> acc
          | _ -> None)
      in
      value.opt_tags <- { constant }

  and refine_type_instr t ~value ~instr_id =
    let instr = Fn_state.instr t.fn_state instr_id |> Option.value_exn in
    let new_ir = constant_fold t ~instr:instr.Instr_state.ir in
    replace_defining_instruction t ~value ~new_ir;
    match Ir.constant new_ir with
    | None -> ()
    | Some _ as constant ->
      value.opt_tags <- { constant };
      let terminal_uses =
        Ir.uses
          (Block.terminal (def_block t value |> Option.value_exn))
            .Instr_state.ir
      in
      if List.exists terminal_uses ~f:(fun use ->
           String.equal (Var.name use) (Var.name value.var))
      then refine_terminal t ~block:(def_block t value |> Option.value_exn)

  and refine_terminal t ~block =
    let terminal = Block.terminal block in
    let new_terminal_ir = constant_fold t ~instr:terminal.Instr_state.ir in
    replace_terminal t ~block ~new_terminal_ir
  ;;

  let gvn t ~value =
    let _ = t, value in
    ()
  ;;

  let run t =
    let on_terminal block =
      if Opt_flags.constant_propagation t.opt_flags
      then refine_terminal t ~block
    in
    dfs_vars ~on_terminal t ~f:(fun ~value ->
      if Opt_flags.constant_propagation t.opt_flags then refine_type t ~value;
      if Opt_flags.unused_vars t.opt_flags then try_kill_value t ~value;
      if value.active && Opt_flags.gvn t.opt_flags then gvn t ~value)
  ;;
end

let map_program_roots ~f program = Program.map_function_roots program ~f

let map_program_roots_with_state program ~state ~f =
  { program with
    Program.functions =
      Map.mapi program.Program.functions ~f:(fun ~key:name ~data:fn ->
        Function0.map_root fn ~f:(f ~fn_state:(State.fn_state state name)))
  }
;;

let set_entry_block_args program ~state =
  Map.iteri
    program.Program.functions
    ~f:(fun ~key:name ~data:{ Function.root = root_data; args; _ } ->
      let ~root:block, ~blocks:_, ~in_order:_ = root_data in
      Fn_state.set_block_args
        (State.fn_state state name)
        ~block
        ~args:(Vec.of_list args));
  program
;;

let type_check_block block =
  let open Result.Let_syntax in
  let%bind () =
    Instr_state.fold
      (Block.instructions block)
      ~init:(Ok ())
      ~f:(fun acc instr ->
        let%bind () = acc in
        Ir.check_types instr.Instr_state.ir)
  in
  Ir.check_types (Block.terminal block).Instr_state.ir
;;

let type_check_cfg (~root, ~blocks:_, ~in_order:_) =
  let open Result.Let_syntax in
  let seen = String.Hash_set.create () in
  let rec go block =
    if Hash_set.mem seen (Block.id_hum block)
    then Ok ()
    else (
      Hash_set.add seen (Block.id_hum block);
      let%bind () = type_check_block block in
      Vec.fold (Block.children block) ~init:(Ok ()) ~f:(fun acc child ->
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

let lower_aggregate_program program ~state =
  Map.fold
    program.Program.functions
    ~init:(Ok ())
    ~f:(fun ~key:name ~data:fn acc ->
      let open Result.Let_syntax in
      let%bind () = acc in
      let { Function.root = ~root:block, ~blocks:_, ~in_order:_; _ } = fn in
      Ir.lower_aggregates ~fn_state:(State.fn_state state name) ~root:block)
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

let compile ?opt_flags (input : input) =
  let state = State.create () in
  match
    Result.map input ~f:(map_program_roots_with_state ~state ~f:Cfg.process)
    |> Result.map ~f:(set_entry_block_args ~state)
    |> Result.bind ~f:(fun program ->
      type_check_program program |> Result.map ~f:(fun () -> program))
    |> Result.bind ~f:(lower_aggregate_program ~state)
    |> Result.map ~f:(map_program_roots_with_state ~state ~f:Ssa.create)
  with
  | Error _ as e -> e
  | Ok program ->
    optimize ?opt_flags program;
    Ok (map_program_roots ~f:Ssa.root program)
;;
