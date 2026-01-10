open! Core
open! Import

module Label = struct
  type t =
    { name : string
    ; block : Block.t
    ; mutable terminated : bool
    }

  let block t = t.block
  let name t = t.name
end

module Type_ast = struct
  type t =
    | Atom of string
    | Ptr of t
    | Tuple of t list
end

let rec type_of_ast = function
  | Type_ast.Atom "i8" -> Type.I8
  | Type_ast.Atom "i16" -> Type.I16
  | Type_ast.Atom "i32" -> Type.I32
  | Type_ast.Atom "i64" -> Type.I64
  | Type_ast.Atom "f32" -> Type.F32
  | Type_ast.Atom "f64" -> Type.F64
  | Type_ast.Atom "ptr" -> Type.Ptr
  | Type_ast.Atom other -> raise_s [%message "unknown type" other]
  | Type_ast.Ptr inner -> Type.Ptr_typed (type_of_ast inner)
  | Type_ast.Tuple elements -> Type.Tuple (List.map elements ~f:type_of_ast)
;;

type mode =
  | Block
  | Function of { mutable args_rev : Var.t list }

type t =
  { root : Block.t
  ; mutable current : Label.t
  ; labels : Label.t String.Table.t
  ; mutable order_rev : Label.t list
  ; mode : mode
  }

let create_block ?(entry = "%entry") () =
  let block = Block.create ~id_hum:entry ~terminal:Ir.unreachable in
  let label = { Label.name = entry; block; terminated = false } in
  { root = block
  ; current = label
  ; labels = String.Table.create ()
  ; order_rev = [ label ]
  ; mode = Block
  }
;;

let create_function () =
  let builder = create_block () in
  { builder with mode = Function { args_rev = [] } }
;;

let ensure_label t name ~f =
  Hashtbl.find_or_add t.labels name ~default:(fun () ->
    let label = f () in
    t.order_rev <- label :: t.order_rev;
    label)
;;

let new_label_state name =
  let block = Block.create ~id_hum:name ~terminal:Ir.unreachable in
  { Label.name; block; terminated = false }
;;

let entry_placeholder_active t =
  phys_equal t.current.block t.root
  && Vec.length t.current.block.Block.instructions = 0
  && not t.current.terminated
;;

let enter_label t ~name =
  let label = ensure_label t name ~f:(fun () -> new_label_state name) in
  if not (phys_equal t.current.block label.block)
  then
    if entry_placeholder_active t
    then (
      let call_block = { Call_block.block = label.block; args = [] } in
      t.current.block.Block.terminal <- Ir.branch (Ir.Branch.Uncond call_block);
      t.current.terminated <- true)
    else if not t.current.terminated
    then
      raise_s
        [%message
          "previous block missing terminator before defining new label"
            (t.current.name : string)];
  t.current <- label;
  label
;;

let ensure_current_open label =
  if label.Label.terminated
  then raise_s [%message "block already terminated" (label.name : string)]
;;

let emit t instr =
  ensure_current_open t.current;
  Vec.push t.current.block.Block.instructions instr
;;

let emit_many t instrs = List.iter instrs ~f:(emit t)

let set_terminal t instr =
  ensure_current_open t.current;
  t.current.block.Block.terminal <- instr;
  t.current.terminated <- true
;;

let goto t label ~args =
  let call_block = { Call_block.block = label.Label.block; args } in
  set_terminal t (Ir.branch (Ir.Branch.Uncond call_block))
;;

let branch t ~cond ~if_true ~if_false ~args_true ~args_false =
  let to_call label args = { Call_block.block = label.Label.block; args } in
  set_terminal
    t
    (Ir.branch
       (Ir.Branch.Cond
          { cond
          ; if_true = to_call if_true args_true
          ; if_false = to_call if_false args_false
          }))
;;

let return t value = set_terminal t (Ir.return value)
let unreachable t = set_terminal t Ir.unreachable
let new_var _t ~name ~type_ = Var.create ~name ~type_

let add_arg t ~name ~type_ =
  match t.mode with
  | Block -> raise_s [%message "arguments only allowed in functions" name]
  | Function data ->
    let var = Var.create ~name ~type_ in
    data.args_rev <- var :: data.args_rev;
    Vec.push t.root.Block.args var;
    var
;;

let ensure_all_terminated t =
  List.iter t.order_rev ~f:(fun label ->
    if not label.Label.terminated
    then raise_s [%message "block missing terminator" (label.name : string)])
;;

let finish_block t =
  ensure_all_terminated t;
  t.root
;;

let finish_function t ~name =
  ensure_all_terminated t;
  match t.mode with
  | Block -> raise_s [%message "cannot finish block builder as function" name]
  | Function { args_rev } ->
    let args = List.rev args_rev in
    Function.create ~name ~args ~root:t.root
;;

let current_block t = t.current.block
