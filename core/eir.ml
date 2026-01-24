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

module Tags = struct
  type t = { constant : Int64.t option } [@@deriving sexp]

  let empty = { constant = None }
end

type raw_block =
  instrs_by_label:string Ir0.t Vec.t String.Map.t * labels:string Vec.t

type input = (raw_block Program.t, Nod_error.t) Result.t

module Loc = struct
  type where =
    | Block_arg of Var.t
    | Instr of Instr_id.t
  [@@deriving sexp, compare, hash]

  type t =
    { block : Block.t
    ; where : where
    }
  [@@deriving sexp, compare, hash, fields]

  let is_terminal_for_block t ~block =
    match t.where with
    | Block_arg _ -> false
    | Instr instr_id ->
      Instr_id.equal instr_id (Block.terminal block).Instr_state.id
  ;;

  include functor Comparable.Make
  include functor Hashable.Make
end

module Opt_var = struct
  type t =
    { id : string
    ; mutable tags : Tags.t [@compare.ignore]
    ; mutable loc : Loc.t [@compare.ignore]
    ; uses : Loc.Hash_set.t [@compare.ignore]
    ; mutable active : bool [@compare.ignore]
    }
  [@@deriving sexp, hash, compare]

  include functor Comparable.Make
  include functor Hashable.Make
end

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
      { mutable needed : Opt_var.Set.t Block.Map.t
      ; once_ready : Block.t -> unit
      }

    let ready t ~var =
      t.needed
      <- Map.change t.needed var.Opt_var.loc.block ~f:(function
           | None -> None
           | Some vars ->
             let vars = Set.remove vars var in
             if Set.length vars = 0
             then (
               t.once_ready var.loc.block;
               None)
             else Some vars)
    ;;
  end

  type t =
    { ssa : Ssa.t
    ; vars : Opt_var.t String.Table.t
    ; mutable active_vars : String.Set.t
    ; opt_flags : Opt_flags.t
    ; mutable block_tracker : Block_tracker0.t option
    ; var_remap : string String.Table.t
    ; instr_remap : string Ir.Table.t
    }

  let create ~opt_flags ssa =
    { ssa
    ; vars = String.Table.create ()
    ; active_vars = String.Set.empty
    ; opt_flags
    ; block_tracker = None
    ; var_remap = String.Table.create ()
    ; instr_remap = Ir.Table.create ()
    }
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

  let active_var t id =
    match Hashtbl.find t.vars id with
    | None -> None
    | Some var when not var.active -> None
    | Some _ as x -> x
  ;;

  let iter t ~f = iter_from t ~block:t.ssa.def_uses.root ~f

  module Block_tracker = struct
    include Block_tracker0

    let create ~once_ready opt =
      let t = { needed = Block.Map.empty; once_ready } in
      iter opt ~f:(fun block ->
        let data =
          Ir.uses (Block.terminal block).Instr_state.ir
          |> List.filter_map ~f:(fun var -> active_var opt (Var.name var))
          |> Opt_var.Set.of_list
        in
        if Set.length data = 0
        then once_ready block
        else t.needed <- Map.set t.needed ~key:block ~data);
      t
    ;;
  end

  let create ~opt_flags ssa =
    let t = create ~opt_flags ssa in
    let early_sets = Var.Table.create () in
    let early_set var =
      Hashtbl.find_or_add early_sets var ~default:Loc.Hash_set.create
    in
    let define ~loc var =
      let id = Var.name var in
      if Hashtbl.mem t.vars id
      then ()
      else (
        let opt_var =
          { Opt_var.id
          ; tags = Tags.empty
          ; loc
          ; uses = early_set var
          ; active = true
          }
        in
        Hashtbl.set t.vars ~key:id ~data:opt_var;
        t.active_vars <- Set.add t.active_vars id)
    in
    let use ~loc var =
      match Hashtbl.find t.vars (Var.name var) with
      | None -> Hash_set.add (early_set var) loc
      | Some opt_var -> Hash_set.add opt_var.uses loc
    in
    iter t ~f:(fun block ->
      Vec.iter (Block.args block) ~f:(fun arg ->
        define ~loc:{ Loc.block; where = Loc.Block_arg arg } arg);
      Instr_state.iter (Block.instructions block) ~f:(fun instr ->
        let loc = { Loc.block; where = Loc.Instr instr.Instr_state.id } in
        List.iter (Ir.defs instr.Instr_state.ir) ~f:(define ~loc)));
    iter t ~f:(fun block ->
      let use instr =
        let loc = { Loc.block; where = Loc.Instr instr.Instr_state.id } in
        List.iter (Ir.uses instr.Instr_state.ir) ~f:(use ~loc)
      in
      Instr_state.iter (Block.instructions block) ~f:use;
      use (Block.terminal block));
    t
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
    let instr_id = instr.Instr_state.id in
    List.iter (Ir.uses instr.Instr_state.ir) ~f:(fun var ->
      let id = Var.name var in
      match active_var t id with
      | None -> ()
      | Some var ->
        Hash_set.filter_inplace var.uses ~f:(fun loc ->
          match loc.Loc.where with
          | Loc.Block_arg _ -> true
          | Instr i -> not (Instr_id.equal i instr_id));
        try_kill_var t ~id);
    Fn_state.remove_instr (fn_state t.ssa) ~block ~instr

  and remove_arg_from_parent t ~parent ~idx ~from_block =
    let found = Queue.create () in
    let parent_terminal = Block.terminal parent in
    let new_ir =
      Ir.map_call_blocks parent_terminal.Instr_state.ir ~f:(fun cb ->
        if not (phys_equal cb.block from_block)
        then cb
        else
          { cb with
            args =
              List.filteri cb.args ~f:(fun i var ->
                let id = Var.name var in
                match i = idx, active_var t id with
                | false, _ -> true
                | true, None -> false
                | true, Some opt_var ->
                  (* kill the tang *)
                  Hash_set.filter_inplace opt_var.uses ~f:(fun loc ->
                    match loc.Loc.where with
                    | Loc.Block_arg _ -> true
                    | Instr instr_id ->
                      not
                        (Instr_id.equal instr_id parent_terminal.Instr_state.id));
                  Queue.enqueue found opt_var;
                  false)
          })
    in
    Fn_state.replace_terminal_ir (fn_state t.ssa) ~block:parent ~with_:new_ir;
    let new_terminal = Block.terminal parent in
    let loc =
      { Loc.where = Instr new_terminal.Instr_state.id; block = parent }
    in
    Queue.iter found ~f:(fun (opt_var : Opt_var.t) ->
      Hash_set.add opt_var.uses loc);
    Queue.iter found ~f:(fun (opt_var : Opt_var.t) ->
      try_kill_var t ~id:opt_var.id)

  and remove_arg t ~block ~arg =
    let idx =
      Vec.findi (Block.args block) ~f:(fun i s ->
        if Var.equal arg s then Some i else None)
      |> Option.value_exn
    in
    Fn_state.set_block_args
      (fn_state t.ssa)
      ~block
      ~args:(Vec.filter (Block.args block) ~f:(Fn.non (Var.equal arg)));
    Vec.iter (Block.parents block) ~f:(fun parent ->
      remove_arg_from_parent t ~parent ~idx ~from_block:block)

  and kill_definition t ~id =
    match active_var t id with
    | None -> ()
    | Some var ->
      var.Opt_var.active <- false;
      t.active_vars <- Set.remove t.active_vars id;
      let block = var.loc.block in
      (match var.loc.where with
       | Instr instr_id ->
         assert (Hash_set.length var.uses = 0);
         let instr =
           Fn_state.instr (fn_state t.ssa) instr_id |> Option.value_exn
         in
         remove_instr t ~block ~instr
       | Block_arg arg -> remove_arg t ~block ~arg);
      Option.iter t.block_tracker ~f:(Block_tracker.ready ~var)

  and try_kill_var t ~id =
    match active_var t id with
    | None -> ()
    | Some var ->
      (match Hash_set.length var.Opt_var.uses, var.loc.where with
       | 0, _ -> kill_definition t ~id:var.id
       | 1, Block_arg arg ->
         (* weird case in our ssa algo that is borked, fix it here *)
         let loc =
           Hash_set.min_elt ~compare:Loc.compare var.uses |> Option.value_exn
         in
         if phys_equal loc.block var.loc.block
            && Loc.is_terminal_for_block loc ~block:var.loc.block
            && List.equal
                 Var.equal
                 [ arg ]
                 (defining_vars_for_block_arg ~block:var.loc.block ~arg)
         then kill_definition t ~id:var.id
         else ()
       | _, _ ->
         (* can't trim *)
         ())
  ;;

  let dfs_vars ?on_terminal t ~f =
    let seen = String.Hash_set.create () in
    Option.iter on_terminal ~f:(fun once_ready ->
      let block_tracker = Block_tracker.create ~once_ready t in
      assert (Option.is_none t.block_tracker);
      t.block_tracker <- Some block_tracker);
    let instr_exn instr_id =
      Fn_state.instr (fn_state t.ssa) instr_id |> Option.value_exn
    in
    let rec go id =
      match active_var t id with
      | None -> ()
      | Some var ->
        if Hash_set.mem seen var.Opt_var.id
        then ()
        else (
          Hash_set.add seen var.id;
          (match Loc.where var.loc with
           | Block_arg _ -> f ~var
           | Instr instr_id ->
             let instr = instr_exn instr_id in
             List.iter (Ir.uses instr.Instr_state.ir) ~f:(fun use ->
               go (Var.name use));
             f ~var);
          Option.iter t.block_tracker ~f:(Block_tracker.ready ~var))
    in
    Set.iter t.active_vars ~f:go;
    Option.iter on_terminal ~f:(fun _ -> t.block_tracker <- None)
  ;;

  let constant_fold t ~instr =
    let instr =
      Ir.map_lit_or_vars instr ~f:(fun lit_or_var ->
        match lit_or_var with
        | Lit _ -> lit_or_var
        | Var var ->
          let opt_var = Hashtbl.find_exn t.vars (Var.name var) in
          (match opt_var.Opt_var.tags.constant with
           | Some i -> Lit i
           | None ->
             (* var can be inactive if it is constant *)
             assert opt_var.active;
             lit_or_var)
        | Global _ -> lit_or_var)
    in
    Ir.constant_fold instr
  ;;

  let update_uses t ~old_instr_id ~old_ir ~new_ir ~loc =
    let old_uses = Ir.uses old_ir in
    let new_uses = Ir.uses new_ir in
    let old_ids = List.map old_uses ~f:Var.name in
    let new_ids = List.map new_uses ~f:Var.name in
    List.iter old_ids ~f:(fun id ->
      match active_var t id with
      | None -> ()
      | Some var ->
        Hash_set.filter_inplace var.uses ~f:(fun loc ->
          match loc.Loc.where with
          | Loc.Block_arg _ -> true
          | Instr i -> not (Instr_id.equal i old_instr_id)));
    List.iter new_ids ~f:(fun id ->
      match active_var t id with
      | None -> ()
      | Some var' -> Hash_set.add var'.uses loc);
    Set.iter
      (Set.diff (String.Set.of_list old_ids) (String.Set.of_list new_ids))
      ~f:(fun id ->
        if Opt_flags.unused_vars t.opt_flags then try_kill_var t ~id)
  ;;

  (* must be strict subset of uses and such *)
  let replace_defining_instruction t ~var ~new_ir =
    let old_instr_id =
      match var.Opt_var.loc.where with
      | Block_arg _ -> failwith "Can't replace defining instr for block arg"
      | Instr instr_id -> instr_id
    in
    let old_instr =
      Fn_state.instr (fn_state t.ssa) old_instr_id |> Option.value_exn
    in
    let new_instr = Fn_state.alloc_instr (fn_state t.ssa) ~ir:new_ir in
    Fn_state.replace_instr
      (fn_state t.ssa)
      ~block:var.loc.block
      ~instr:old_instr
      ~with_instrs:[ new_instr ];
    var.loc <- { var.loc with where = Instr new_instr.Instr_state.id };
    update_uses
      t
      ~old_instr_id:old_instr.Instr_state.id
      ~old_ir:old_instr.Instr_state.ir
      ~new_ir
      ~loc:var.loc
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
    Fn_state.replace_terminal_ir (fn_state t.ssa) ~block ~with_:new_terminal_ir;
    let new_terminal = Block.terminal block in
    let loc = { Loc.block; where = Instr new_terminal.Instr_state.id } in
    update_uses
      t
      ~old_instr_id:old_terminal.Instr_state.id
      ~old_ir:old_terminal.Instr_state.ir
      ~new_ir:new_terminal_ir
      ~loc
  ;;

  let rec refine_type t ~var =
    match var.Opt_var.tags.constant with
    | Some _ -> ()
    | None ->
      (match var.Opt_var.loc.where with
       | Block_arg arg -> refine_type_block_arg t ~var ~arg
       | Instr instr_id -> refine_type_instr t ~var ~instr_id)

  and refine_type_block_arg t ~var ~arg =
    let block = var.Opt_var.loc.block in
    let constant var =
      Option.map
        (Hashtbl.find t.vars (Var.name var))
        ~f:(fun x -> x.tags.constant)
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
      var.tags <- { constant }

  and refine_type_instr t ~var ~instr_id =
    let instr = Fn_state.instr (fn_state t.ssa) instr_id |> Option.value_exn in
    let new_ir = constant_fold t ~instr:instr.Instr_state.ir in
    replace_defining_instruction t ~var ~new_ir;
    match Ir.constant new_ir with
    | None -> ()
    | Some _ as constant ->
      var.tags <- { constant };
      let terminal_uses =
        Ir.uses (Block.terminal var.loc.block).Instr_state.ir
      in
      if List.exists terminal_uses ~f:(fun use ->
           String.equal (Var.name use) var.id)
      then refine_terminal t ~block:var.loc.block

  and refine_terminal t ~block =
    let terminal = Block.terminal block in
    let new_terminal_ir = constant_fold t ~instr:terminal.Instr_state.ir in
    replace_terminal t ~block ~new_terminal_ir
  ;;

  let gvn t ~var =
    let _ = t, var in
    ()
  ;;

  let run t =
    let on_terminal block =
      if Opt_flags.constant_propagation t.opt_flags
      then refine_terminal t ~block
    in
    dfs_vars ~on_terminal t ~f:(fun ~var ->
      if Opt_flags.constant_propagation t.opt_flags then refine_type t ~var;
      if Opt_flags.unused_vars t.opt_flags
      then try_kill_var t ~id:var.Opt_var.id;
      if var.Opt_var.active && Opt_flags.gvn t.opt_flags then gvn t ~var)
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
