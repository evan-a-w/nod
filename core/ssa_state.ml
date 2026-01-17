open! Core

(** per function ssa state to map between values and instrs etc. *)
type t =
  { values : Ssa_value.t option Vec.t
  ; free_values : int Vec.t
  ; instrs : Block.t Ssa_instr.t option Vec.t
  ; free_instrs : int Vec.t
  ; value_id_by_var : Value_id.t Var.Table.t
  }

let create () =
  { values = Vec.create ()
  ; free_values = Vec.create ()
  ; instrs = Vec.create ()
  ; free_instrs = Vec.create ()
  ; value_id_by_var = Var.Table.create ()
  }
;;

let value t (Value_id idx : Value_id.t) =
  Vec.get_opt t.values idx |> Option.join
;;

let instr t (Instr_id idx : Instr_id.t) =
  Vec.get_opt t.instrs idx |> Option.join
;;

let value_by_var t var =
  Hashtbl.find t.value_id_by_var var |> Option.bind ~f:(fun id -> value t id)
;;

let alloc_value t ~type_ ~var =
  let res id : Ssa_value.t =
    Hashtbl.set t.value_id_by_var ~key:var ~data:(Value_id id);
    { id = Value_id id
    ; var
    ; type_
    ; def = Undefined
    ; opt_tags = Opt_tags.empty
    ; uses = []
    }
  in
  match Vec.pop t.free_values with
  | Some id ->
    let res = res id in
    Vec.set t.values id (Some res);
    res
  | None ->
    let res = res (Vec.length t.values) in
    Vec.push t.values (Some res);
    res
;;

let free_value t ({ id = Value_id id; _ } : Ssa_value.t) =
  Hashtbl.remove t.value_id_by_var (Option.value_exn (Vec.get t.values id)).var;
  Vec.set t.values id None;
  Vec.push t.free_values id
;;

let alloc_instr ?prev ?next t ~ir =
  let res id : Block.t Ssa_instr.t = { id = Instr_id id; ir; prev; next } in
  match Vec.pop t.free_instrs with
  | Some id ->
    let res = res id in
    Vec.set t.instrs id (Some res);
    res
  | None ->
    let res = res (Vec.length t.instrs) in
    Vec.push t.instrs (Some res);
    res
;;

let free_instr t ({ id = Instr_id id; _ } : Block.t Ssa_instr.t) =
  Vec.set t.instrs id None;
  Vec.push t.free_instrs id
;;

let ensure_value t ~var =
  match value_by_var t var with
  | Some value -> value
  | None -> alloc_value t ~type_:(Var.type_ var) ~var
;;

let add_use (value : Ssa_value.t) instr_id =
  if not (List.mem value.uses instr_id ~equal:Instr_id.equal)
  then value.uses <- instr_id :: value.uses
;;

let remove_use (value : Ssa_value.t) instr_id =
  value.uses <- List.filter value.uses ~f:(Fn.non (Instr_id.equal instr_id))
;;

let register_defs_uses t ~instr_id ~defs ~uses =
  List.iter defs ~f:(fun var ->
    let value = ensure_value t ~var in
    value.def <- Def_site.Instr instr_id);
  List.iter uses ~f:(fun var ->
    let value = ensure_value t ~var in
    add_use value instr_id)
;;

let unregister_defs_uses t ~instr_id ~defs ~uses =
  List.iter uses ~f:(fun var ->
    Option.iter (value_by_var t var) ~f:(fun value -> remove_use value instr_id));
  List.iter defs ~f:(fun var ->
    Option.iter (value_by_var t var) ~f:(fun value ->
      match value.def with
      | Def_site.Instr id when Instr_id.equal id instr_id ->
        value.def <- Def_site.Undefined
      | _ -> ()))
;;

let replace_defs_uses t ~instr_id ~old_defs ~old_uses ~new_defs ~new_uses =
  let old_defs_set = Var.Set.of_list old_defs in
  let new_defs_set = Var.Set.of_list new_defs in
  let old_uses_set = Var.Set.of_list old_uses in
  let new_uses_set = Var.Set.of_list new_uses in
  let removed_uses = Set.diff old_uses_set new_uses_set |> Set.to_list in
  let added_uses = Set.diff new_uses_set old_uses_set |> Set.to_list in
  let removed_defs = Set.diff old_defs_set new_defs_set |> Set.to_list in
  let added_defs = Set.diff new_defs_set old_defs_set |> Set.to_list in
  List.iter removed_uses ~f:(fun var ->
    Option.iter (value_by_var t var) ~f:(fun value -> remove_use value instr_id));
  List.iter added_uses ~f:(fun var ->
    let value = ensure_value t ~var in
    add_use value instr_id);
  List.iter removed_defs ~f:(fun var ->
    Option.iter (value_by_var t var) ~f:(fun value ->
      match value.def with
      | Def_site.Instr id when Instr_id.equal id instr_id ->
        value.def <- Def_site.Undefined
      | _ -> ()));
  List.iter added_defs ~f:(fun var ->
    let value = ensure_value t ~var in
    value.def <- Def_site.Instr instr_id)
;;

let register_instr t (instr : Block.t Ssa_instr.t) =
  register_defs_uses
    t
    ~instr_id:instr.id
    ~defs:(Ir0.defs instr.ir)
    ~uses:(Ir0.uses instr.ir)
;;

let unregister_instr t (instr : Block.t Ssa_instr.t) =
  unregister_defs_uses
    t
    ~instr_id:instr.id
    ~defs:(Ir0.defs instr.ir)
    ~uses:(Ir0.uses instr.ir)
;;

let replace_instr_ir t (instr : Block.t Ssa_instr.t) ~ir =
  replace_defs_uses
    t
    ~instr_id:instr.id
    ~old_defs:(Ir0.defs instr.ir)
    ~old_uses:(Ir0.uses instr.ir)
    ~new_defs:(Ir0.defs ir)
    ~new_uses:(Ir0.uses ir);
  instr.ir <- ir
;;

let append_ir t ~block ~ir =
  let instr = alloc_instr t ~ir in
  register_instr t instr;
  Block.append_instr block instr;
  instr
;;

let replace_block_instructions t ~block ~irs =
  Block.iter_instrs block ~f:(fun instr ->
    unregister_instr t instr;
    free_instr t instr);
  block.Block.instructions <- None;
  let last = ref None in
  List.iter irs ~f:(fun ir ->
    let instr = alloc_instr t ~ir in
    register_instr t instr;
    instr.Ssa_instr.prev <- !last;
    instr.Ssa_instr.next <- None;
    (match !last with
     | None -> block.Block.instructions <- Some instr
     | Some prev -> prev.Ssa_instr.next <- Some instr);
    last := Some instr)
;;

let remove_instr t ~block ~instr =
  unregister_instr t instr;
  Block.unlink_instr block instr;
  free_instr t instr
;;

let set_terminal_ir t ~block ~ir = replace_instr_ir t block.Block.terminal ~ir

let register_block_args t ~block =
  Vec.iteri block.Block.args ~f:(fun i var ->
    let value = ensure_value t ~var in
    value.def <- Def_site.Block_arg { block; arg = i })
;;

let update_block_args t ~block ~old_args ~new_args =
  List.iteri old_args ~f:(fun i var ->
    Option.iter (value_by_var t var) ~f:(fun value ->
      match value.def with
      | Def_site.Block_arg { block = def_block; arg } ->
        if phys_equal def_block block && arg = i
        then value.def <- Def_site.Undefined
        else ()
      | _ -> ()));
  List.iteri new_args ~f:(fun i var ->
    let value = ensure_value t ~var in
    value.def <- Def_site.Block_arg { block; arg = i })
;;
