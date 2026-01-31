open! Core
open! Import

module M (A : Arch.S) = struct
  open A

  type var_state =
    { mutable num_uses : int
    ; id : int
    ; var : Var.t
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
  let reg_id t (reg : Reg.Raw.t) = Reg.Raw.to_id ~var_id:(var_id t) reg
  let id_reg t id : Reg.Raw.t = Reg.Raw.of_id ~id_var:(id_var t) id

  let create (root : Block.t) =
    let t = { vars = Var.Table.create (); id_to_var = Int.Table.create () } in
    let add_use v =
      let s = var_state t v in
      s.num_uses <- s.num_uses + 1
    in
    Block.iter_instructions root ~f:(fun instr ->
      let ir = Nod_ir.Ir.map_vars instr.Instr_state.ir ~f:Value_state.var in
      Ir.uses ir |> List.iter ~f:add_use;
      Ir.defs ir
      |> List.iter ~f:(fun def ->
        let (_ : var_state) = var_state t def in
        ()));
    t
  ;;
end
