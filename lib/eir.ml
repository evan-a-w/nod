open! Core
include Ir
include Initial_transform.Make_with_block (Ir)

module Tags = struct
  type t = { constant : Int64.t option } [@@deriving sexp]

  let empty = { constant = None }
end

module Instr = Ir.Instr

module Loc = struct
  module T = struct
    type where =
      | Block_arg of string
      | Instr of Instr.t
    [@@deriving sexp, compare, hash]

    type t =
      { block : Block.t
      ; where : where
      }
    [@@deriving sexp, compare, hash, fields]

    let is_terminal_for_block t ~block =
      match t.where with
      | Block_arg _ -> false
      | Instr instr -> phys_equal block.Block.terminal instr
    ;;
  end

  include Comparable.Make (T)
  include Hashable.Make (T)
  include T
end

module Var = struct
  module T = struct
    type t =
      { id : string
      ; mutable tags : Tags.t [@compare.ignore]
      ; mutable loc : Loc.t [@compare.ignore]
      ; uses : Loc.Hash_set.t [@compare.ignore]
      ; mutable active : bool [@compare.ignore]
      }
    [@@deriving sexp, hash, compare]
  end

  include Comparable.Make (T)
  include Hashable.Make (T)
  include T
end

module Opt_flags = struct
  type t =
    { unused_vars : bool
    ; constant_propagation : bool
    ; gvn : bool
    }
  [@@deriving fields]

  let default = { unused_vars = true; constant_propagation = true; gvn = true }
end

module Opt = struct
  module Block_tracker0 = struct
    type t =
      { mutable needed : Var.Set.t Block.Map.t
      ; once_ready : Block.t -> unit
      }

    let ready t ~var =
      t.needed
      <- Map.change t.needed var.Var.loc.block ~f:(function
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
    ; vars : Var.t String.Table.t
    ; mutable active_vars : String.Set.t
    ; opt_flags : Opt_flags.t
    ; mutable block_tracker : Block_tracker0.t option
    ; var_remap : string String.Table.t
    ; instr_remap : string Instr.Table.t
    }

  let create ssa =
    { ssa
    ; vars = String.Table.create ()
    ; active_vars = String.Set.empty
    ; opt_flags = Opt_flags.default
    ; block_tracker = None
    ; var_remap = String.Table.create ()
    ; instr_remap = Instr.Table.create ()
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
          Instr.uses block.terminal
          |> List.filter_map ~f:(active_var opt)
          |> Var.Set.of_list
        in
        if Set.length data = 0
        then once_ready block
        else t.needed <- Map.set t.needed ~key:block ~data);
      t
    ;;
  end

  let create ssa =
    let t = create ssa in
    let define ~loc id =
      let var =
        { Var.id
        ; tags = Tags.empty
        ; loc
        ; uses = Loc.Hash_set.create ()
        ; active = true
        }
      in
      Hashtbl.set t.vars ~key:id ~data:var;
      t.active_vars <- Set.add t.active_vars id
    in
    let use ~loc id = Hash_set.add (Hashtbl.find_exn t.vars id).uses loc in
    iter t ~f:(fun block ->
      Vec.iter block.Block.args ~f:(fun id ->
        define ~loc:{ Loc.block; where = Loc.Block_arg id } id);
      Vec.iter block.instructions ~f:(fun instr ->
        let loc = { Loc.block; where = Loc.Instr instr } in
        Option.iter (Instr.def instr) ~f:(define ~loc)));
    iter t ~f:(fun block ->
      let use instr =
        let loc = { Loc.block; where = Loc.Instr instr } in
        List.iter (Instr.uses instr) ~f:(use ~loc)
      in
      Vec.iter block.instructions ~f:use;
      use block.terminal);
    t
  ;;

  (* TODO: implement, call when constant folding terminals and
     when deleting instructions *)
  (* if [block] is unnecessary, remove it *)
  let kill_block (_ : t) ~block:_ = ()

  let defining_vars_for_block_arg ~block ~arg =
    let idx =
      Vec.findi block.Block.args ~f:(fun i s ->
        if String.equal arg s then Some i else None)
      |> Option.value_exn
    in
    Vec.filter_map block.parents ~f:(fun parent ->
      match
        Ir.filter_map_call_blocks
          parent.terminal
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
    List.iter (Ir.uses instr) ~f:(fun id ->
      match active_var t id with
      | None -> ()
      | Some var ->
        Hash_set.filter_inplace var.uses ~f:(fun loc ->
          match loc.Loc.where with
          | Loc.Block_arg _ -> true
          | Instr i -> not (phys_equal i instr));
        try_kill_var t ~id);
    block.Block.instructions
    <- Vec.filter block.Block.instructions ~f:(Fn.non (phys_equal instr))

  and remove_arg_from_parent t ~parent ~idx =
    let rec go () =
      let current = parent.Block.terminal in
      let new_ =
        Ir.map_args
          parent.Block.terminal
          ~f:
            (List.filteri ~f:(fun i id ->
               match i = idx, active_var t id with
               | false, _ -> true
               | true, None -> false
               | true, Some var ->
                 (* kill the tang *)
                 Hash_set.filter_inplace var.uses ~f:(fun loc ->
                   match loc.Loc.where with
                   | Loc.Block_arg _ -> true
                   | Instr i -> not (phys_equal i parent.terminal));
                 try_kill_var t ~id;
                 false))
      in
      (* can actually change during execution :() *)
      if phys_equal current parent.Block.terminal
      then parent.Block.terminal <- new_
      else go ()
    in
    go ()

  and remove_arg t ~block ~arg =
    let idx =
      Vec.findi block.Block.args ~f:(fun i s ->
        if String.equal arg s then Some i else None)
      |> Option.value_exn
    in
    block.args <- Vec.filter block.args ~f:(Fn.non (String.equal arg));
    Vec.iter block.parents ~f:(fun parent ->
      remove_arg_from_parent t ~parent ~idx)

  and kill_definition t ~id =
    match active_var t id with
    | None -> ()
    | Some var ->
      var.Var.active <- false;
      t.active_vars <- Set.remove t.active_vars id;
      let block = var.loc.block in
      (match var.loc.where with
       | Instr instr ->
         assert (Hash_set.length var.uses = 0);
         remove_instr t ~block ~instr
       | Block_arg arg -> remove_arg t ~block ~arg);
      Option.iter t.block_tracker ~f:(Block_tracker.ready ~var)

  and try_kill_var t ~id =
    match active_var t id with
    | None -> ()
    | Some var ->
      (match Hash_set.length var.Var.uses, var.loc.where with
       | 0, _ -> kill_definition t ~id:var.id
       | 1, Block_arg arg ->
         (* weird case in our ssa algo that is borked, fix it here *)
         let loc =
           Hash_set.min_elt ~compare:Loc.compare var.uses |> Option.value_exn
         in
         if phys_equal loc.block var.loc.block
            && Loc.is_terminal_for_block loc ~block:var.loc.block
            && [%equal: string list]
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
    let rec go id =
      match active_var t id with
      | None -> ()
      | Some var ->
        if Hash_set.mem seen var.Var.id
        then ()
        else (
          Hash_set.add seen var.id;
          (match Loc.where var.loc with
           | Block_arg _ -> f ~var
           | Instr instr ->
             List.iter (Ir.uses instr) ~f:go;
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
        | Var id ->
          let var = Hashtbl.find_exn t.vars id in
          (match var.Var.tags.constant with
           | Some i -> Lit i
           | None ->
             (* var can be inactive if it is constant *)
             assert var.active;
             lit_or_var))
    in
    Ir.constant_fold instr
  ;;

  let update_uses t ~old_instr ~new_instr ~loc =
    let old_uses = Ir.uses old_instr in
    let new_uses = Ir.uses new_instr in
    List.iter old_uses ~f:(fun id ->
      match active_var t id with
      | None -> ()
      | Some var ->
        Hash_set.filter_inplace var.uses ~f:(fun loc ->
          match loc.Loc.where with
          | Loc.Block_arg _ -> true
          | Instr i -> not (phys_equal i old_instr)));
    List.iter new_uses ~f:(fun id ->
      match active_var t id with
      | None -> ()
      | Some var' -> Hash_set.add var'.uses loc);
    Set.iter
      (Set.diff (String.Set.of_list old_uses) (String.Set.of_list new_uses))
      ~f:(fun id ->
        if Opt_flags.unused_vars t.opt_flags then try_kill_var t ~id)
  ;;

  (* must be strict subset of uses and such *)
  let replace_defining_instruction t ~var ~new_instr =
    let old_instr =
      match var.Var.loc.where with
      | Block_arg _ -> failwith "Can't replace defining instr for block arg"
      | Instr instr -> instr
    in
    var.loc <- { var.loc with where = Instr new_instr };
    Vec.map_inplace var.loc.block.Block.instructions ~f:(fun instr ->
      if phys_equal old_instr instr then new_instr else instr);
    update_uses t ~old_instr ~new_instr ~loc:var.loc
  ;;

  (* must be strict subset of uses and such *)
  let replace_terminal t ~block ~new_terminal =
    let old_terminal = block.Block.terminal in
    let old_blocks = Ir.blocks old_terminal in
    let new_blocks = Ir.blocks old_terminal in
    let diff =
      List.filter old_blocks ~f:(fun block' ->
        not (List.mem new_blocks block' ~equal:phys_equal))
    in
    Vec.switch block.children (Vec.of_list new_blocks);
    List.iter diff ~f:(fun block' ->
      Vec.switch
        block'.parents
        (Vec.filter block'.parents ~f:(Fn.non (phys_equal block))));
    let loc = { Loc.block; where = Instr new_terminal } in
    update_uses t ~old_instr:old_terminal ~new_instr:new_terminal ~loc;
    block.terminal <- new_terminal
  ;;

  let rec refine_type t ~var =
    match var.Var.tags.constant with
    | Some _ -> ()
    | None ->
      (match var.Var.loc.where with
       | Block_arg arg -> refine_type_block_arg t ~var ~arg
       | Instr instr -> refine_type_instr t ~var ~instr)

  and refine_type_block_arg t ~var ~arg =
    let block = var.Var.loc.block in
    defining_vars_for_block_arg ~block ~arg
    |> function
    | [] -> ()
    | id :: xs ->
      let constant id = (Hashtbl.find_exn t.vars id).tags.constant in
      let constant =
        List.fold xs ~init:(constant id) ~f:(fun acc id ->
          match acc, constant id with
          | Some a, Some b when Int64.equal a b -> acc
          | _ -> None)
      in
      var.tags <- { constant }

  and refine_type_instr t ~var ~instr =
    let instr = constant_fold t ~instr in
    replace_defining_instruction t ~var ~new_instr:instr;
    match Ir.constant instr with
    | None -> ()
    | Some _ as constant ->
      var.tags <- { constant };
      if List.mem (Ir.uses var.loc.block.terminal) var.id ~equal:String.equal
      then refine_terminal t ~block:var.loc.block

  and refine_terminal t ~block =
    let terminal = block.Block.terminal in
    let new_terminal = constant_fold t ~instr:terminal in
    replace_terminal t ~block ~new_terminal
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
      if Opt_flags.unused_vars t.opt_flags then try_kill_var t ~id:var.Var.id;
      if var.Var.active && Opt_flags.gvn t.opt_flags then gvn t ~var)
  ;;
end

let optimize ssa =
  let opt_state = Opt.create ssa in
  Opt.run opt_state
;;
