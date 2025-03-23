open! Core
include Ir
include Initial_transform.Make_with_block (Ir)

module Tags = struct
  type t = { constant : int option } [@@deriving sexp]

  let empty = { constant = None }
end

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
  type t =
    { id : string
    ; mutable tags : Tags.t
    ; mutable loc : Loc.t
    ; uses : Loc.Hash_set.t
    }
  [@@deriving sexp]
end

module Opt = struct
  type t =
    { ssa : Ssa.t
    ; vars : Var.t String.Table.t
    ; mutable vars_set : String.Set.t
    }

  let create ssa =
    { ssa; vars = String.Table.create (); vars_set = String.Set.empty }
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

  let iter t ~f = iter_from t ~block:t.ssa.def_uses.root ~f

  let create ssa =
    let t = create ssa in
    let define ~loc id =
      let var =
        { Var.id; tags = Tags.empty; loc; uses = Loc.Hash_set.create () }
      in
      Hashtbl.set t.vars ~key:id ~data:var;
      t.vars_set <- Set.add t.vars_set id
    in
    let use ~loc id = Hash_set.add (Hashtbl.find_exn t.vars id).uses loc in
    iter t ~f:(fun block ->
      Vec.iter block.Block.args ~f:(fun id ->
        define ~loc:{ Loc.block; where = Loc.Block_arg id } id);
      Vec.iter block.instructions ~f:(fun instr ->
        let loc = { Loc.block; where = Loc.Instr instr } in
        List.iter (Instr.defs instr) ~f:(define ~loc)));
    iter t ~f:(fun block ->
      let use instr =
        let loc = { Loc.block; where = Loc.Instr instr } in
        List.iter (Instr.uses instr) ~f:(use ~loc)
      in
      Vec.iter block.instructions ~f:use;
      use block.terminal);
    t
  ;;

  let kill_block (_ : t) ~block:_ = ()

  let rec remove_instr t ~block ~instr =
    List.iter (Ir.uses instr) ~f:(fun id ->
      match Hashtbl.find t.vars id with
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
    parent.Block.terminal
    <- Ir.map_args
         parent.Block.terminal
         ~f:
           (List.filteri ~f:(fun i id ->
              match i = idx, Hashtbl.find t.vars id with
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
    match Hashtbl.find t.vars id with
    | None -> ()
    | Some var ->
      Hashtbl.remove t.vars id;
      t.vars_set <- Set.remove t.vars_set id;
      let block = var.loc.block in
      (match var.loc.where with
       | Instr instr ->
         assert (Hash_set.length var.uses = 0);
         (match List.filter (Instr.defs instr) ~f:(Hashtbl.mem t.vars) with
          | [] -> remove_instr t ~block ~instr
          | _ -> ())
       | Block_arg arg -> remove_arg t ~block ~arg)

  and try_kill_var t ~id =
    match Hashtbl.find t.vars id with
    | None -> ()
    | Some var -> if Hash_set.length var.uses = 0 then kill_definition t ~id
  ;;

  let kill_unused_vars t = Set.iter t.vars_set ~f:(fun id -> try_kill_var t ~id)

  let maybe_prune_phi t ~var =
    match Hash_set.length var.Var.uses with
    | 0 -> kill_definition t ~id:var.id
    | 1 ->
      let loc =
        Hash_set.min_elt ~compare:Loc.compare var.uses |> Option.value_exn
      in
      if
        phys_equal loc.block var.loc.block
        && Loc.is_terminal_for_block loc ~block:var.loc.block
      then kill_definition t ~id:var.id
      else ()
    | _ ->
      (* can't trim *)
      ()
  ;;

  let prune_phis t =
    Set.iter t.vars_set ~f:(fun id ->
      match Hashtbl.find t.vars id with
      | None -> ()
      | Some var ->
        (match var.loc.where with
         | Instr _ ->
           (* not phi *)
           ()
         | Block_arg _ -> maybe_prune_phi t ~var))
  ;;

  let replace_defining_instruction t ~var ~new_instr =
    let old_instr =
      match var.Var.loc.where with
      | Block_arg _ -> failwith "Can't replace defining instr for block arg"
      | Instr instr -> instr
    in
    var.loc <- { var.loc with where = Instr new_instr };
    List.iter (Ir.uses old_instr) ~f:(fun id ->
      match Hashtbl.find t.vars id with
      | None -> ()
      | Some var ->
        Hash_set.filter_inplace var.uses ~f:(fun loc ->
          match loc.Loc.where with
          | Loc.Block_arg _ -> true
          | Instr i -> not (phys_equal i old_instr)));
    Vec.map_inplace var.loc.block.Block.instructions ~f:(fun instr ->
      if phys_equal old_instr instr then new_instr else instr);
    List.iter (Ir.uses old_instr) ~f:(fun id ->
      match Hashtbl.find t.vars id with
      | None -> ()
      | Some var' -> Hash_set.add var'.uses var.loc)
  ;;

  let refine_type t ~var = failwith "TODO"

  let tagify t =
    let seen = String.Hash_set.create () in
    let rec go var =
      if Hash_set.mem seen var.Var.id
      then ()
      else (
        Hash_set.add seen var.id;
        match Loc.where var.loc with
        | Block_arg _ -> ()
        | Instr instr ->
          List.iter (Ir.uses instr) ~f:(Fn.compose go (Hashtbl.find_exn t.vars));
          refine_type t ~var)
    in
    Hashtbl.iter t.vars ~f:go
  ;;
end

let optimize ssa =
  let opt_state = Opt.create ssa in
  Opt.prune_phis opt_state;
  Opt.kill_unused_vars opt_state
;;
