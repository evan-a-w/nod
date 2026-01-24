open! Core
open! Import

type 'block t =
  { id : Instr_id.t
  ; mutable ir : 'block Ir0.t
  ; mutable next : 'block t option
  ; mutable prev : 'block t option
  }
[@@deriving fields]

let sexp_of_t sexp_of_block { id; ir; next = _; prev = _ } =
  [%message (id : Instr_id.t) (ir : block Ir0.t)]
;;

let rec iter t ~(local_ f) =
  match t with
  | None -> ()
  | Some t ->
    f t;
    iter t.next ~f
;;

let rec to_list t =
  match t with
  | None -> []
  | Some x -> x :: to_list x.next
;;

let to_ir_list t = to_list t |> List.map ~f:ir

let rec fold t ~init ~f =
  match t with
  | None -> init
  | Some t -> fold t.next ~init:(f init t) ~f
;;
