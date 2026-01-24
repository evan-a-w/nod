open! Core

(** per function ssa state to map between values and instrs etc. *)
type t =
  { values : Value_state.t option Vec.t
  ; free_values : int Vec.t
  ; instrs : Block.t Instr_state.t option Vec.t
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
  let res id : Value_state.t =
    Hashtbl.set t.value_id_by_var ~key:var ~data:(Value_id id);
    { id = Value_id id
    ; var
    ; type_
    ; def = Undefined
    ; opt_tags = Opt_tags.empty
    ; uses = Instr_id.Set.empty
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

let free_value t ({ id = Value_id id; _ } : Value_state.t) =
  Hashtbl.remove t.value_id_by_var (Option.value_exn (Vec.get t.values id)).var;
  Vec.set t.values id None;
  Vec.push t.free_values id
;;

let alloc_instr ?prev ?next t ~ir =
  let res id : Block.t Instr_state.t = { id = Instr_id id; ir; prev; next } in
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

let free_instr t ({ id = Instr_id id; _ } : Block.t Instr_state.t) =
  Vec.set t.instrs id None;
  Vec.push t.free_instrs id
;;

let ensure_value t ~var =
  match value_by_var t var with
  | Some value -> value
  | None -> alloc_value t ~type_:(Var.type_ var) ~var
;;

let add_use (value : Value_state.t) instr_id =
  value.uses <- Set.add value.uses instr_id
;;

let remove_use (value : Value_state.t) instr_id =
  value.uses <- Set.remove value.uses instr_id
;;

let clear_instr_value_relationships t ~(instr : _ Instr_state.t) =
  Ir0.defs instr.ir
  |> List.iter ~f:(fun var ->
    match value_by_var t var with
    | None -> ()
    | Some var ->
      (match var.def with
       | Undefined | Block_arg _ ->
         (* do nothing, def is already not this ir *)
         ()
       | Instr id ->
         (* only clear if this def is actually us. This is basically just so it's not funky if the thing isn't actually in ssa form *)
         if [%compare.equal: Instr_id.t] id instr.id then var.def <- Undefined));
  Ir0.uses instr.ir
  |> List.iter ~f:(fun var ->
    match value_by_var t var with
    | None -> ()
    | Some var -> remove_use var instr.id)
;;

let add_instr_value_relationships t ~(instr : _ Instr_state.t) =
  Ir0.defs instr.ir
  |> List.iter ~f:(fun var -> (ensure_value t ~var).def <- Instr instr.id);
  Ir0.uses instr.ir
  |> List.iter ~f:(fun var -> add_use (ensure_value t ~var) instr.id)
;;

let replace_instr t ~(block : Block.t) ~instr ~with_instrs =
  clear_instr_value_relationships t ~instr;
  free_instr t instr;
  List.iter with_instrs ~f:(fun instr -> add_instr_value_relationships t ~instr);
  let rec go (prev : _ Instr_state.t option) l =
    match l with
    | [] -> ()
    | x :: xs ->
      (match prev with
       | None -> ()
       | Some prev -> prev.next <- Some x);
      x.next <- instr.next;
      go (Some x) xs
  in
  go instr.prev with_instrs;
  match instr.prev, List.hd with_instrs with
  | None, head -> block.instructions <- head
  | Some prev, head -> prev.next <- head
;;

let replace_instr_with_irs t ~block ~instr ~with_irs =
  let instrs = List.map with_irs ~f:(fun ir -> alloc_instr t ~ir) in
  replace_instr t ~block ~instr ~with_instrs:instrs
;;

let replace_terminal t ~(block : Block.t) ~with_ =
  clear_instr_value_relationships t ~instr:block.terminal;
  free_instr t block.terminal;
  add_instr_value_relationships t ~instr:with_;
  block.terminal <- with_
;;

let replace_terminal_ir t ~(block : Block.t) ~with_ =
  let with_ = alloc_instr t ~ir:with_ in
  clear_instr_value_relationships t ~instr:block.terminal;
  add_instr_value_relationships t ~instr:with_;
  block.terminal <- with_
;;

let append_instr t ~(block : Block.t) ~instr =
  let rec go (curr : _ Instr_state.t) =
    match curr.next with
    | None -> curr.next <- Some instr
    | Some next -> go next
  in
  match block.instructions with
  | None -> block.instructions <- Some instr
  | Some head -> go head
;;

let append_ir t ~block ~ir = append_instr t ~block ~instr:(alloc_instr t ~ir)
