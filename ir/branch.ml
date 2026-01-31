open! Core
open! Import

type ('var, 'block) t =
  | Cond of
      { cond : 'var Lit_or_var.t
      ; if_true : ('var, 'block) Call_block.t
      ; if_false : ('var, 'block) Call_block.t
      }
  | Uncond of ('var, 'block) Call_block.t
[@@deriving sexp, compare, equal, hash]

let filter_map_call_blocks t ~f =
  match t with
  | Uncond call_block -> f call_block |> Option.to_list
  | Cond { cond = _; if_true; if_false } ->
    (f if_true |> Option.to_list) @ (f if_false |> Option.to_list)
;;

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

let map_uses t ~f =
  match t with
  | Cond { cond; if_true; if_false } ->
    Cond
      { cond = Lit_or_var.map_vars ~f cond
      ; if_true = Call_block.map_uses if_true ~f
      ; if_false = Call_block.map_uses if_false ~f
      }
  | Uncond call -> Uncond (Call_block.map_uses call ~f)
;;

let map_blocks t ~f =
  match t with
  | Cond { cond; if_true; if_false } ->
    Cond
      { cond
      ; if_true = Call_block.map_blocks if_true ~f
      ; if_false = Call_block.map_blocks if_false ~f
      }
  | Uncond call -> Uncond (Call_block.map_blocks call ~f)
;;

let iter_call_blocks t ~f =
  match t with
  | Cond { cond = _; if_true; if_false } ->
    f if_true;
    f if_false
  | Uncond call -> f call
;;

let map_call_blocks t ~f =
  match t with
  | Cond { cond; if_true; if_false } ->
    Cond { cond; if_true = f if_true; if_false = f if_false }
  | Uncond call -> Uncond (f call)
;;

let map_lit_or_vars t ~f =
  match t with
  | Uncond _ -> t
  | Cond { cond; if_true; if_false } ->
    Cond { cond = f cond; if_true; if_false }
;;
