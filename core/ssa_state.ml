open! Core

(** per function ssa state to map between values and instrs etc. *)
type t =
  { values : Ssa_value.t option Vec.t
  ; free_values : int Vec.t
  ; instrs : Ssa_instr.t option Vec.t
  ; free_instrs : int Vec.t
  ; value_id_by_var : Value_id.t Var.Table.t
  }

let value t (Value_id idx : Value_id.t) = Vec.get_opt t.values idx

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

let alloc_instr ?block ?prev ?next t ~ir =
  let res id : Ssa_instr.t = { id = Instr_id id; ir; block; prev; next } in
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

let free_instr t ({ id = Instr_id id; _ } : Ssa_instr.t) =
  Vec.set t.instrs id None;
  Vec.push t.free_instrs id
;;
