open! Core
open! Import
open! Common

type var_state =
  { mutable num_uses : int
  ; id : int
  ; var : string
  }
[@@deriving fields, sexp]

let var_state_score { num_uses; id = _; var = _ } = num_uses

type t =
  { vars : var_state Var.Table.t
  ; id_to_var : Var.t Int.Table.t
  }
[@@deriving fields, sexp]

let var_state t var =
  match Hashtbl.find t.vars var with
  | Some state -> state
  | None ->
    let id = Hashtbl.length t.vars in
    let res = { num_uses = 0; id; var } in
    Hashtbl.set t.vars ~key:var ~data:res;
    Hashtbl.set t.id_to_var ~key:id ~data:var;
    res
;;

let var_id t var = (var_state t var).id
let id_var t id = Hashtbl.find_exn t.id_to_var id

let reg_id t (reg : Reg.t) =
  match reg with
  | RBP -> 0
  | RSP -> 1
  | RAX -> 2
  | RBX -> 3
  | RCX -> 4
  | RDX -> 5
  | RSI -> 6
  | RDI -> 7
  | R8 -> 8
  | R9 -> 9
  | R10 -> 10
  | R11 -> 11
  | R12 -> 12
  | R13 -> 13
  | R14 -> 14
  | R15 -> 15
  | Unallocated var | Allocated (var, _) -> 16 + var_id t var
;;

let id_reg t id : Reg.t =
  match id with
  | 0 -> RBP
  | 1 -> RSP
  | 2 -> RAX
  | 3 -> RBX
  | 4 -> RCX
  | 5 -> RDX
  | 6 -> RSI
  | 7 -> RDI
  | 8 -> R8
  | 9 -> R9
  | 10 -> R10
  | 11 -> R11
  | 12 -> R12
  | 13 -> R13
  | 14 -> R14
  | 15 -> R15
  | other ->
    let id = other - 16 in
    Unallocated (id_var t id)
;;

let create (root : Block.t) =
  let t = { vars = Var.Table.create (); id_to_var = Int.Table.create () } in
  let add_use v =
    let s = var_state t v in
    s.num_uses <- s.num_uses + 1
  in
  Block.iter_instructions root ~f:(fun ir ->
    Ir.uses ir |> List.iter ~f:add_use;
    Ir.defs ir
    |> List.iter ~f:(fun def ->
      let (_ : var_state) = var_state t def in
      ()));
  t
;;
