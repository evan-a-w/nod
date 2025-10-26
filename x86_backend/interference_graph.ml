open! Core
open! Import
open! Common

module Var_pair = struct
  type t = int * int [@@deriving sexp, compare, equal]

  let create a b : t = if a <= b then a, b else b, a

  include functor Comparable.Make
end

type t =
  { calc_liveness : (module Calc_liveness.S with type Arg.t = Var.t)
       [@compare.ignore]
  ; edges : Var_pair.Set.t
  }
[@@deriving compare, fields ~getters]

let interfere t a b = if a = b then t else Set.add t (Var_pair.create a b)
let empty = Var_pair.Set.empty

let create
  (type a)
  (module Calc_liveness : Calc_liveness.S
    with type Arg.t = Var.t
     and type Liveness_state.t = a)
  ~(liveness_state : a)
  ~root
  =
  let open Calc_liveness in
  let edges = ref empty in
  let add_edge u v = edges := interfere !edges u v in
  Block.iter root ~f:(fun block ->
    let block_liveness = Liveness_state.block_liveness liveness_state block in
    let zipped =
      List.zip_exn
        (Vec.to_list block.instructions @ [ block.terminal ])
        (Vec.to_list block_liveness.instructions @ [ block_liveness.terminal ])
    in
    List.iter zipped ~f:(fun (ir, liveness (* , _) *)) ->
      List.iter (Ir.defs ir) ~f:(fun var ->
        let u = Arg.id_of_t var in
        Set.iter liveness.live_out ~f:(add_edge u))));
  { calc_liveness = (module Calc_liveness); edges = !edges }
;;

let print
  { calc_liveness =
      (module Calc_liveness : Calc_liveness.S with type Arg.t = Var.t)
  ; edges
  }
  =
  let edges =
    Set.to_list edges
    |> List.map ~f:(fun (a, b) ->
      Calc_liveness.Arg.t_of_id a, Calc_liveness.Arg.t_of_id b)
  in
  print_s [%sexp (edges : (Var.t * Var.t) list)]
;;
