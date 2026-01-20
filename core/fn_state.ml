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
  if not (List.mem value.uses instr_id ~equal:Instr_id.equal)
  then value.uses <- instr_id :: value.uses
;;

let remove_use (value : Value_state.t) instr_id =
  value.uses <- List.filter value.uses ~f:(Fn.non (Instr_id.equal instr_id))
;;
