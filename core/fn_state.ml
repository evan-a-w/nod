open! Core
open! Import

(** per function ssa state to map between values and instrs etc. *)
type t =
  { values : Value_state.t option Nod_vec.t
  ; free_values : int Nod_vec.t
  ; instrs : Block.t Instr_state.t option Nod_vec.t
  ; free_instrs : int Nod_vec.t
  ; instr_block_by_id : Block.t option Nod_vec.t
  ; value_id_by_var : Value_id.t Typed_var.Table.t
  }

let create () =
  { values = Nod_vec.create ()
  ; free_values = Nod_vec.create ()
  ; instrs = Nod_vec.create ()
  ; free_instrs = Nod_vec.create ()
  ; instr_block_by_id = Nod_vec.create ()
  ; value_id_by_var = Typed_var.Table.create ()
  }
;;

let value t (Value_id idx : Value_id.t) =
  Nod_vec.get_opt t.values idx |> Option.join
;;

let instr t (Instr_id idx : Instr_id.t) =
  Nod_vec.get_opt t.instrs idx |> Option.join
;;

let instr_block t (Instr_id idx : Instr_id.t) =
  Nod_vec.get_opt t.instr_block_by_id idx |> Option.join
;;

let value_by_var t var =
  Hashtbl.find t.value_id_by_var var |> Option.bind ~f:(fun id -> value t id)
;;

let alloc_value t ~type_ ~var =
  let res id : Value_state.t =
    Hashtbl.set t.value_id_by_var ~key:var ~data:(Value_id id);
    Value_state.create
      ~id:(Value_id id)
      ~var
      ~type_
      ~def:Undefined
      ~opt_tags:Opt_tags.empty
      ~uses:Instr_id.Set.empty
      ~active:true
  in
  match Nod_vec.pop t.free_values with
  | Some id ->
    let res = res id in
    Nod_vec.set t.values id (Some res);
    res
  | None ->
    let res = res (Nod_vec.length t.values) in
    Nod_vec.push t.values (Some res);
    res
;;

let free_value t ({ id = Value_id id; _ } : Value_state.t) =
  Hashtbl.remove
    t.value_id_by_var
    (Option.value_exn (Nod_vec.get t.values id) |> Value_state.var);
  Nod_vec.set t.values id None;
  Nod_vec.push t.free_values id
;;

let alloc_instr ?prev ?next t ~ir =
  let res id : Block.t Instr_state.t = { id = Instr_id id; ir; prev; next } in
  match Nod_vec.pop t.free_instrs with
  | Some id ->
    let res = res id in
    Nod_vec.set t.instrs id (Some res);
    Nod_vec.fill_to_length t.instr_block_by_id ~length:(id + 1) ~f:(fun _ ->
      None);
    res
  | None ->
    let res = res (Nod_vec.length t.instrs) in
    Nod_vec.push t.instrs (Some res);
    Nod_vec.fill_to_length
      t.instr_block_by_id
      ~length:(Nod_vec.length t.instrs)
      ~f:(fun _ -> None);
    res
;;

let free_instr t ({ id = Instr_id id; _ } : Block.t Instr_state.t) =
  Nod_vec.set t.instrs id None;
  Nod_vec.fill_to_length t.instr_block_by_id ~length:(id + 1) ~f:(fun _ -> None);
  Nod_vec.set t.instr_block_by_id id None;
  Nod_vec.push t.free_instrs id
;;

let ensure_value t ~var =
  match value_by_var t var with
  | Some value -> value
  | None -> alloc_value t ~type_:(Typed_var.type_ var) ~var
;;

let value_ir t ir = Nod_ir.Ir.map_vars ir ~f:(fun var -> ensure_value t ~var)
let var_ir ir = Nod_ir.Ir.map_vars ir ~f:Value_state.var

let add_use (value : Value_state.t) instr_id =
  Value_state.Expert.set_uses value (Set.add value.Value_state.uses instr_id)
;;

let remove_use (value : Value_state.t) instr_id =
  Value_state.Expert.set_uses value (Set.remove value.Value_state.uses instr_id)
;;

let clear_instr_value_relationships _t ~(instr : _ Instr_state.t) =
  Nod_ir.Ir.defs instr.ir
  |> List.iter ~f:(fun value ->
    match value.Value_state.def with
    | Undefined | Block_arg _ -> ()
    | Instr id ->
      if [%compare.equal: Instr_id.t] id instr.id
      then Value_state.Expert.set_def value Undefined);
  Nod_ir.Ir.uses instr.ir
  |> List.iter ~f:(fun value -> remove_use value instr.id)
;;

let add_instr_value_relationships _t ~(instr : _ Instr_state.t) =
  Nod_ir.Ir.defs instr.ir
  |> List.iter ~f:(fun value ->
    Value_state.Expert.set_def value (Instr instr.id));
  Nod_ir.Ir.uses instr.ir |> List.iter ~f:(fun value -> add_use value instr.id)
;;

let of_cfg ~root =
  let t = create () in
  let register_instr ~block instr =
    let (Instr_id id) = instr.Instr_state.id in
    Nod_vec.fill_to_length t.instrs ~length:(id + 1) ~f:(fun _ -> None);
    Nod_vec.set t.instrs id (Some instr);
    Nod_vec.fill_to_length t.instr_block_by_id ~length:(id + 1) ~f:(fun _ ->
      None);
    Nod_vec.set t.instr_block_by_id id (Some block)
  in
  Block.iter root ~f:(fun block ->
    Instr_state.iter (Block.instructions block) ~f:(register_instr ~block);
    register_instr ~block (Block.terminal block));
  Block.iter root ~f:(fun block ->
    Nod_vec.iteri (Block.args block) ~f:(fun arg var ->
      let value = ensure_value t ~var in
      Value_state.Expert.set_def
        value
        (Block_arg { block_id = Block.id_hum block; arg })));
  Block.iter_instructions root ~f:(fun instr ->
    add_instr_value_relationships t ~instr);
  t
;;

let set_instr_block t ~(block : Block.t) ~(instr : _ Instr_state.t) =
  let (Instr_id id) = instr.Instr_state.id in
  Nod_vec.fill_to_length t.instr_block_by_id ~length:(id + 1) ~f:(fun _ -> None);
  Nod_vec.set t.instr_block_by_id id (Some block)
;;

let set_block_args t ~(block : Block.t) ~(args : Typed_var.t Nod_vec.t) =
  Nod_vec.iter (Block.args block) ~f:(fun var ->
    match value_by_var t var with
    | None -> ()
    | Some value ->
      (match value.Value_state.def with
       | Block_arg { block_id; _ }
         when String.equal block_id (Block.id_hum block) ->
         Value_state.Expert.set_def value Undefined
       | _ -> ()));
  Block.Expert.set_args block args;
  Nod_vec.iteri args ~f:(fun arg var ->
    let value = ensure_value t ~var in
    Value_state.Expert.set_def
      value
      (Block_arg { block_id = Block.id_hum block; arg }))
;;

let replace_instr t ~(block : Block.t) ~instr ~with_instrs =
  clear_instr_value_relationships t ~instr;
  free_instr t instr;
  List.iter with_instrs ~f:(fun instr ->
    add_instr_value_relationships t ~instr;
    set_instr_block t ~block ~instr);
  let rec link prev l =
    match l with
    | [] -> prev
    | x :: xs ->
      x.Instr_state.prev <- prev;
      (match prev with
       | None -> Block.Expert.set_instructions block (Some x)
       | Some prev -> prev.Instr_state.next <- Some x);
      link (Some x) xs
  in
  let last = link instr.Instr_state.prev with_instrs in
  (match last with
   | None -> Block.Expert.set_instructions block instr.Instr_state.next
   | Some last -> last.Instr_state.next <- instr.Instr_state.next);
  Option.iter instr.Instr_state.next ~f:(fun next ->
    next.Instr_state.prev <- last)
;;

let replace_instr_with_irs t ~block ~instr ~with_irs =
  let instrs = List.map with_irs ~f:(fun ir -> alloc_instr t ~ir) in
  replace_instr t ~block ~instr ~with_instrs:instrs
;;

let replace_terminal t ~(block : Block.t) ~with_ =
  clear_instr_value_relationships t ~instr:(Block.terminal block);
  free_instr t (Block.terminal block);
  add_instr_value_relationships t ~instr:with_;
  set_instr_block t ~block ~instr:with_;
  Block.Expert.set_terminal block with_
;;

let replace_terminal_ir t ~(block : Block.t) ~with_ =
  let with_ = alloc_instr t ~ir:with_ in
  clear_instr_value_relationships t ~instr:(Block.terminal block);
  add_instr_value_relationships t ~instr:with_;
  set_instr_block t ~block ~instr:with_;
  Block.Expert.set_terminal block with_
;;

let remove_instr t ~(block : Block.t) ~(instr : _ Instr_state.t) =
  clear_instr_value_relationships t ~instr;
  free_instr t instr;
  (match instr.Instr_state.prev with
   | None -> Block.Expert.set_instructions block instr.Instr_state.next
   | Some prev -> prev.Instr_state.next <- instr.Instr_state.next);
  Option.iter instr.Instr_state.next ~f:(fun next ->
    next.Instr_state.prev <- instr.Instr_state.prev)
;;

let append_instr t ~(block : Block.t) ~instr =
  set_instr_block t ~block ~instr;
  let rec go (curr : _ Instr_state.t) =
    match curr.Instr_state.next with
    | None ->
      curr.Instr_state.next <- Some instr;
      instr.Instr_state.prev <- Some curr
    | Some next -> go next
  in
  match Block.instructions block with
  | None -> Block.Expert.set_instructions block (Some instr)
  | Some head -> go head
;;

let append_ir t ~block ~ir = append_instr t ~block ~instr:(alloc_instr t ~ir)

let append_irs t ~(block : Block.t) ~irs =
  List.iter irs ~f:(fun ir -> append_ir t ~block ~ir)
;;

let replace_irs t ~block ~irs =
  let rec clear = function
    | None -> ()
    | Some instr ->
      let next = instr.Instr_state.next in
      remove_instr t ~block ~instr;
      clear next
  in
  clear (Block.instructions block);
  List.iter irs ~f:(fun ir -> append_ir t ~block ~ir)
;;
