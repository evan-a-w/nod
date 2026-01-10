open! Core
open! Import

type int64 = Int64
type float64 = Float64
type ptr = Ptr

module Type_repr = struct
  type _ t =
    | Int64 : int64 t
    | Float64 : float64 t
    | Ptr : ptr t

  let type_ (type a) (t : a t) : Type.t =
    match t with
    | Int64 -> I64
    | Float64 -> F64
    | Ptr -> Ptr
  ;;
end

module Atom = struct
  type _ t = Ir.Lit_or_var.t

  let lit_or_var t = t

  let var t =
    match (t : Ir.Lit_or_var.t) with
    | Var v -> Some v
    | Global _ | Lit _ -> None
  ;;

  let type_ t =
    match (t : Ir.Lit_or_var.t) with
    | Var v -> v.type_
    | Lit _ -> Type.I64
    | Global g -> g.type_
  ;;
end

module Instr = struct
  type t =
    | Ir : string Ir0.t -> t
    | Label : string -> t
  [@@deriving variants]

  let process ?(root_name = "%entry") ts =
    let labels = Vec.create () in
    let instrs = Vec.create () in
    let end_this_label current_label instrs_by_label =
      if Vec.length instrs = 0
      then Map.remove instrs_by_label current_label
      else (
        Vec.push labels current_label;
        let instrs_in_map = Map.find_exn instrs_by_label current_label in
        Vec.switch instrs_in_map instrs;
        instrs_by_label)
    in
    let instrs_by_label =
      Map.set String.Map.empty ~key:root_name ~data:(Vec.create ())
    in
    let rec go current_label instrs_by_label ts =
      match ts with
      | [] -> Ok (~current_label, ~instrs_by_label)
      | Ir ir :: rest ->
        Vec.push instrs ir;
        go current_label instrs_by_label rest
      | Label new_label :: rest ->
        if Map.mem instrs_by_label new_label
        then Error (`Duplicate_label new_label)
        else (
          let instrs_by_label = end_this_label current_label instrs_by_label in
          let instrs_by_label =
            Map.set instrs_by_label ~key:new_label ~data:(Vec.create ())
          in
          go new_label instrs_by_label rest)
    in
    match go root_name instrs_by_label ts with
    | Error _ as res -> res
    | Ok (~current_label, ~instrs_by_label) ->
      let instrs_by_label = end_this_label current_label instrs_by_label in
      Ok (~instrs_by_label, ~labels)
  ;;
end

module Fn = struct
  module Unnamed = struct
    type 'a t =
      { args : Var.t list
      ; ret : Type.t
      ; instrs : Instr.t list
      }

    let const type_repr instrs =
      { args = []; ret = Type_repr.type_ type_repr; instrs : Instr.t list }
    ;;

    let with_arg { args; ret; instrs } var = { args = var :: args; ret; instrs }
  end

  type 'a t =
    { name : string
    ; unnamed : 'a Unnamed.t
    }
  [@@deriving fields]

  let function_ t =
    Function0.create
      ~name:t.name
      ~args:t.unnamed.args
      ~root:(Instr.process t.unnamed.instrs)
  ;;

  module Packed = struct
    type 'a outer = 'a t
    type t = T : _ outer -> t
  end

  let pack t : Packed.t = T t
end

let process ~functions ~globals =
  let functions =
    List.map functions ~f:(fun (function_ : Fn.Packed.t) ->
      match function_ with
      | T t -> t.name, Fn.function_ t)
  in
  String.Map.of_alist functions
;;
