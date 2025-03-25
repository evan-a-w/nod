open! Core

module Var = struct
  type t = string [@@deriving sexp, compare, equal, hash]
end

module Lit = struct
  type t = Int64.t [@@deriving sexp, compare, equal, hash]
end

module Lit_or_var = struct
  type t =
    | Lit of Lit.t
    | Var of Var.t
  [@@deriving sexp, compare, equal, hash]

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
[@@deriving sexp, compare, equal, hash]

let map_arith_defs t ~f = { t with dest = f t.dest }

let map_arith_uses t ~f =
  { t with
    src1 = Lit_or_var.map_vars ~f t.src1
  ; src2 = Lit_or_var.map_vars ~f t.src2
  }
;;

let map_arith_lit_or_vars t ~f = { t with src1 = f t.src1; src2 = f t.src2 }

module Call_block = struct
  type 'block t =
    { mutable block : 'block
    ; args : Var.t list
    }
  [@@deriving sexp, compare, equal, fields]

  let hash_fold_t (type block) hash_fold_block st t =
    [%hash_fold: block * Var.t list] st (t.block, t.args)
  ;;

  let hash (type block) hash_fold_block t =
    [%hash: block * Var.t list] (t.block, t.args)
  ;;

  let blocks { block; _ } = [ block ]
  let map_uses t ~f = { t with args = List.map t.args ~f }
  let map_blocks t ~f = { t with block = f t.block }
  let map_args t ~f = { t with args = f t.args }
  let uses = args
end

module Branch = struct
  type 'block t =
    | Cond of
        { cond : Lit_or_var.t
        ; if_true : 'block Call_block.t
        ; if_false : 'block Call_block.t
        }
    | Uncond of 'block Call_block.t
  [@@deriving sexp, compare, equal, hash]

  (*
     [let t' = constant_fold t in
      not (phys_equal t t') iff t' is simpler than t
     ]
  *)
  let constant_fold = function
    | Cond { cond = Lit x; if_true = _; if_false } when Int64.(x = zero) ->
      Uncond if_false
    | Cond { cond = Lit x; if_true; if_false = _ } when Int64.(x <> zero) ->
      Uncond if_true
    | t -> t
  ;;

  let blocks = function
    | Uncond c -> Call_block.blocks c
    | Cond { cond = _; if_true; if_false } ->
      Call_block.blocks if_true @ Call_block.blocks if_false
  ;;

  let uses = function
    | Cond { cond; if_true; if_false } ->
      List.concat
        [ Lit_or_var.vars cond
        ; Call_block.uses if_true
        ; Call_block.uses if_false
        ]
    | Uncond call -> Call_block.uses call
  ;;

  let map_uses ~f = function
    | Cond { cond; if_true; if_false } ->
      Cond
        { cond = Lit_or_var.map_vars ~f cond
        ; if_true = Call_block.map_uses if_true ~f
        ; if_false = Call_block.map_uses if_false ~f
        }
    | Uncond call -> Uncond (Call_block.map_uses call ~f)
  ;;

  let map_blocks ~f = function
    | Cond { cond; if_true; if_false } ->
      Cond
        { cond
        ; if_true = Call_block.map_blocks if_true ~f
        ; if_false = Call_block.map_blocks if_false ~f
        }
    | Uncond call -> Uncond (Call_block.map_blocks call ~f)
  ;;

  let map_args ~f = function
    | Cond { cond; if_true; if_false } ->
      Cond
        { cond
        ; if_true = Call_block.map_args if_true ~f
        ; if_false = Call_block.map_args if_false ~f
        }
    | Uncond call -> Uncond (Call_block.map_args call ~f)
  ;;

  let map_lit_or_vars t ~f =
    match t with
    | Uncond _ -> t
    | Cond { cond; if_true; if_false } ->
      Cond { cond = f cond; if_true; if_false }
  ;;
end

module T = struct
  type 'block t' =
    | Noop
    | Add of arith
    | Sub of arith
    | Mul of arith
    | Div of arith
    | Mod of arith
    | Move of Var.t * Lit_or_var.t
    | Branch of 'block Branch.t
    | Return of Lit_or_var.t
    | Unreachable
  [@@deriving sexp, compare, equal, variants, hash]

  (*
     [let t' = constant_fold t in
      not (phys_equal t t') iff t' is simpler than t
     ]
  *)
  let constant_fold = function
    | Add { src1 = Lit a; src2 = Lit b; dest } -> Move (dest, Lit Int64.(a + b))
    | Sub { src1 = Lit a; src2 = Lit b; dest } -> Move (dest, Lit Int64.(a - b))
    | Mul { src1 = Lit a; src2 = Lit b; dest } -> Move (dest, Lit Int64.(a * b))
    | Div { src1 = Lit a; src2 = Lit b; dest } -> Move (dest, Lit Int64.(a / b))
    | Mod { src1 = Lit a; src2 = Lit b; dest } ->
      Move (dest, Lit (Int64.rem a b))
    (* move to left *)
    | Add { src1; src2 = Lit _ as src2; dest } ->
      Add { src1 = src2; src2 = src1; dest }
    | Mul { src1; src2 = Lit _ as src2; dest } ->
      Mul { src1 = src2; src2 = src1; dest }
    | Branch b as t ->
      let b' = Branch.constant_fold b in
      if phys_equal b b' then t else Branch b'
    | t -> t
  ;;

  let maybe_constant_fold t =
    let t' = constant_fold t in
    if phys_equal t t' then None else Some t'
  ;;

  let constant = function
    | Move (_, Lit i) -> Some i
    | _ -> None
  ;;

  let def = function
    | Add a | Sub a | Mul a | Div a | Mod a -> Some a.dest
    | Move (var, _) -> Some var
    | Branch _ | Unreachable | Noop | Return _ -> None
  ;;

  let blocks = function
    | Branch b -> Branch.blocks b
    | Add _ | Sub _ | Mul _ | Div _ | Mod _
    | Move (_, _)
    | Unreachable | Noop | Return _ -> []
  ;;

  let uses = function
    | Add a | Sub a | Mul a | Div a | Mod a ->
      Lit_or_var.vars a.src1 @ Lit_or_var.vars a.src2
    | Move (_, src) -> Lit_or_var.vars src
    | Branch b -> Branch.uses b
    | Return var -> Lit_or_var.vars var
    | Unreachable | Noop -> []
  ;;

  let map_defs t ~f =
    match t with
    | Add a -> Add (map_arith_defs a ~f)
    | Mul a -> Mul (map_arith_defs a ~f)
    | Div a -> Div (map_arith_defs a ~f)
    | Mod a -> Mod (map_arith_defs a ~f)
    | Sub a -> Sub (map_arith_defs a ~f)
    | Move (var, b) -> Move (f var, b)
    | Branch _ | Unreachable | Noop | Return _ -> t
  ;;

  let map_uses t ~f =
    match t with
    | Add a -> Add (map_arith_uses a ~f)
    | Mul a -> Mul (map_arith_uses a ~f)
    | Div a -> Div (map_arith_uses a ~f)
    | Mod a -> Mod (map_arith_uses a ~f)
    | Sub a -> Sub (map_arith_uses a ~f)
    | Return use -> Return (Lit_or_var.map_vars use ~f)
    | Move (var, b) -> Move (var, Lit_or_var.map_vars b ~f)
    | Branch b -> Branch (Branch.map_uses b ~f)
    | Unreachable | Noop -> t
  ;;

  let is_terminal = function
    | Branch _ | Unreachable | Return _ -> true
    | Add _ | Mul _ | Div _ | Mod _ | Sub _ | Move _ | Noop -> false
  ;;

  let map_args t ~f =
    match t with
    | Branch b -> Branch (Branch.map_args b ~f)
    | Unreachable
    | Add _
    | Mul _
    | Div _
    | Mod _
    | Sub _
    | Move _
    | Noop
    | Return _ -> t
  ;;

  let map_blocks (t : 'a t') ~f : 'b t' =
    match t with
    | Add a -> Add a
    | Mul a -> Mul a
    | Div a -> Div a
    | Mod a -> Mod a
    | Sub a -> Sub a
    | Move (var, b) -> Move (var, b)
    | Branch b -> Branch (Branch.map_blocks b ~f)
    | Noop -> Noop
    | Return var -> Return var
    | Unreachable -> Unreachable
  ;;

  let map_lit_or_vars t ~f =
    match t with
    | Add a -> Add (map_arith_lit_or_vars a ~f)
    | Mul a -> Mul (map_arith_lit_or_vars a ~f)
    | Div a -> Div (map_arith_lit_or_vars a ~f)
    | Mod a -> Mod (map_arith_lit_or_vars a ~f)
    | Sub a -> Sub (map_arith_lit_or_vars a ~f)
    | Move (var, b) -> Move (var, f b)
    | Branch b -> Branch (Branch.map_lit_or_vars b ~f)
    | Return var -> Return (f var)
    | Noop -> Noop
    | Unreachable -> Unreachable
  ;;
end

include T
module Instr_ = Instr
module Block_ = Block

module rec Instr : (Instr_.S with type t = Block.t t') = struct
  include T

  type t = Block.t t' [@@deriving sexp, compare, hash]

  let add_block_args =
    let on_call_block { Call_block.block; args = _ } =
      { Call_block.block; args = Vec.to_list block.Block.args }
    in
    function
    | ( Add _
      | Mul _
      | Div _
      | Mod _
      | Sub _
      | Move _
      | Unreachable
      | Noop
      | Return _ ) as t -> t
    | Branch (Branch.Cond { cond; if_true; if_false }) ->
      Branch
        (Branch.Cond
           { cond
           ; if_true = on_call_block if_true
           ; if_false = on_call_block if_false
           })
    | Branch (Branch.Uncond call) -> Branch (Branch.Uncond (on_call_block call))
  ;;
end

and Block : (Block_.S with type instr := Instr.t) = Block_.Make (Instr)
