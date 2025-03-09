open! Core

module Var = struct
  type t = string [@@deriving sexp, compare, equal]
end

module Lit = struct
  type t = int [@@deriving sexp, compare, equal]
end

module Lit_or_var = struct
  type t =
    | Lit of Lit.t
    | Var of Var.t
  [@@deriving sexp, compare, equal]

  let vars = function
    | Lit _ -> []
    | Var v -> [ v ]
  ;;

  let map_vars t ~f =
    match t with
    | Lit _ -> t
    | Var v -> Var (f v)
  ;;
end

module Block_id =
  String_id.Make
    (struct
      let module_name = "Block_id"
    end)
    ()

type arith =
  { dest : Var.t
  ; src1 : Lit_or_var.t
  ; src2 : Lit_or_var.t
  }
[@@deriving sexp, compare, equal]

let map_arith_defs t ~f = { t with dest = f t.dest }

let map_arith_uses t ~f =
  { t with
    src1 = Lit_or_var.map_vars ~f t.src1
  ; src2 = Lit_or_var.map_vars ~f t.src2
  }
;;

module Call_block = struct
  type 'block t =
    { mutable block : 'block
    ; args : Var.t list
    }
  [@@deriving sexp, compare, equal, fields]

  let map_uses t ~f = { t with args = List.map t.args ~f }
  let uses = args
end

module Branch = struct
  type 'block t =
    { cond : Lit_or_var.t
    ; if_true : 'block Call_block.t
    ; if_false : 'block Call_block.t
    }
  [@@deriving sexp, compare, equal]

  let uses { cond; if_true; if_false } =
    List.concat
      [ Lit_or_var.vars cond
      ; Call_block.uses if_true
      ; Call_block.uses if_false
      ]
  ;;

  let map_uses { cond; if_true; if_false } ~f =
    { cond = Lit_or_var.map_vars ~f cond
    ; if_true = Call_block.map_uses if_true ~f
    ; if_false = Call_block.map_uses if_false ~f
    }
  ;;
end

module T = struct
  type 'block t' =
    | Add of arith
    | Sub of arith
    | Mul of arith
    | Div of arith
    | Mod of arith
    | Move of Var.t * Lit_or_var.t
    | Branch of 'block Branch.t
    | Unreachable
  [@@deriving sexp, compare, equal]

  let defs = function
    | Add a | Sub a | Mul a | Div a | Mod a -> [ a.dest ]
    | Move (var, _) -> [ var ]
    | Branch _ | Unreachable -> []
  ;;

  let uses = function
    | Add a | Sub a | Mul a | Div a | Mod a ->
      Lit_or_var.vars a.src1 @ Lit_or_var.vars a.src2
    | Move (_, src) -> Lit_or_var.vars src
    | Branch b -> Branch.uses b
    | Unreachable -> []
  ;;

  let map_defs t ~f =
    match t with
    | Add a -> Add (map_arith_defs a ~f)
    | Mul a -> Mul (map_arith_defs a ~f)
    | Div a -> Div (map_arith_defs a ~f)
    | Mod a -> Mod (map_arith_defs a ~f)
    | Sub a -> Sub (map_arith_defs a ~f)
    | Move (var, b) -> Move (f var, b)
    | Branch _ | Unreachable -> t
  ;;

  let map_uses t ~f =
    match t with
    | Add a -> Add (map_arith_uses a ~f)
    | Mul a -> Mul (map_arith_uses a ~f)
    | Div a -> Div (map_arith_uses a ~f)
    | Mod a -> Mod (map_arith_uses a ~f)
    | Sub a -> Sub (map_arith_uses a ~f)
    | Move (var, b) -> Move (var, Lit_or_var.map_vars b ~f)
    | Branch b -> Branch (Branch.map_uses b ~f)
    | Unreachable -> t
  ;;
end

module Instr_ = Instr
module Block_ = Block

module rec Instr : Instr_.S = struct
  include T

  type t = Block.t t'

  let add_block_args = function
    | (Add _ | Mul _ | Div _ | Mod _ | Sub _ | Move _ | Unreachable) as t -> t
    | Branch { Branch.cond; if_true; if_false } ->
      let on_call_block { Call_block.block; args = _ } =
        { Call_block.block; args = Vec.to_list block.Block.args }
      in
      Branch
        { Branch.cond
        ; if_true = on_call_block if_true
        ; if_false = on_call_block if_false
        }
  ;;
end

and Block : Block_.S = Block_.Make (Instr)
