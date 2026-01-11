open! Core
open! Import

type int64 = Int64 [@@warning "-37"]
type float64 = Float64 [@@warning "-37"]
type ptr = Ptr [@@warning "-37"]

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
  type 'a t =
    | Ir : string Ir0.t -> 'a t
    | Label : string -> 'a t
  [@@deriving variants]

  let ir ir0 = Ir ir0

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
    type ('fn, 'ret) t =
      { args : Var.t list
      ; ret : Type.t
      ; instrs : 'ret Instr.t list
      }

    let args t = t.args
    let ret t = t.ret
    let instrs t = t.instrs

    let const type_repr instrs =
      { args = []; ret = Type_repr.type_ type_repr; instrs }
    ;;

    let const_with_return ret instrs =
      { args = []; ret = Atom.type_ ret; instrs }
    ;;

    let with_arg (type fn ret arg) ({ args; ret; instrs } : (fn, ret) t) var
      : (arg -> fn, ret) t
      =
      { args = args @ [ var ]; ret; instrs }
    ;;
  end

  type ('fn, 'ret) t =
    { name : string
    ; unnamed : ('fn, 'ret) Unnamed.t
    }

  let name t = t.name
  let unnamed t = t.unnamed
  let create ~unnamed ~name = { name; unnamed }

  let function_ t =
    let open Result.Let_syntax in
    let%map root = Instr.process t.unnamed.instrs in
    Function0.create ~name:t.name ~args:t.unnamed.args ~root
  ;;

  module Packed = struct
    type nonrec ('fn, 'ret) outer = ('fn, 'ret) t
    type t = T : (_, _) outer -> t
  end

  let pack t : Packed.t = T t
end

let program ~functions ~globals =
  let open Result.Let_syntax in
  let fn_results =
    List.map functions ~f:(fun (function_ : Fn.Packed.t) ->
      match function_ with
      | Fn.Packed.T fn ->
        let%map fn_value = Fn.function_ fn in
        Fn.name fn, fn_value)
  in
  let%bind functions = Result.all fn_results in
  match String.Map.of_alist functions with
  | `Ok functions -> Ok { Program.globals; functions }
  | `Duplicate_key dup ->
    Error (`Type_mismatch (sprintf "duplicate function %s" dup))
;;

let return (type a) (value : a Atom.t) : a Instr.t =
  Instr.ir (Ir0.Return (Atom.lit_or_var value))
;;
let label name = Instr.Label name
let lit value : int64 Atom.t = Ir.Lit_or_var.Lit value
let var v : 'a Atom.t = Ir.Lit_or_var.Var v
let global g : ptr Atom.t = Ir.Lit_or_var.Global g
let make_dest name type_ = Var.create ~name ~type_
let atom_of_var var : _ Atom.t = Ir.Lit_or_var.Var var
let mem_address ?offset ptr = Ir0.Mem.address ?offset (Atom.lit_or_var ptr)

let binary name type_ lhs rhs ctor =
  let dest = make_dest name type_ in
  let instr =
    ctor
      { Ir0.dest
      ; Ir0.src1 = Atom.lit_or_var lhs
      ; Ir0.src2 = Atom.lit_or_var rhs
      }
    |> Instr.ir
  in
  atom_of_var dest, instr
;;

let mov name src =
  let dest = make_dest name (Atom.type_ src) in
  let instr = Instr.ir (Ir0.Move (dest, Atom.lit_or_var src)) in
  atom_of_var dest, instr
;;

let add name lhs rhs = binary name Type.I64 lhs rhs Ir0.add
let sub name lhs rhs = binary name Type.I64 lhs rhs Ir0.sub
let mul name lhs rhs = binary name Type.I64 lhs rhs Ir0.mul
let div name lhs rhs = binary name Type.I64 lhs rhs Ir0.div
let mod_ name lhs rhs = binary name Type.I64 lhs rhs Ir0.mod_
let and_ name lhs rhs = binary name Type.I64 lhs rhs Ir0.and_
let or_ name lhs rhs = binary name Type.I64 lhs rhs Ir0.or_
let ptr_add name base offset = binary name (Atom.type_ base) base offset Ir0.add
let ptr_sub name base offset = binary name (Atom.type_ base) base offset Ir0.sub
let ptr_diff name lhs rhs = binary name Type.I64 lhs rhs Ir0.sub
let fadd name lhs rhs = binary name Type.F64 lhs rhs Ir0.fadd
let fsub name lhs rhs = binary name Type.F64 lhs rhs Ir0.fsub
let fmul name lhs rhs = binary name Type.F64 lhs rhs Ir0.fmul
let fdiv name lhs rhs = binary name Type.F64 lhs rhs Ir0.fdiv

let load_mem ?(offset = 0) name ptr type_ =
  let dest = make_dest name type_ in
  let instr = Instr.ir (Ir0.Load (dest, mem_address ~offset ptr)) in
  atom_of_var dest, instr
;;

let load name ptr = load_mem name ptr Type.I64
let load_ptr name ptr = load_mem name ptr Type.Ptr
let load_f64 name ptr = load_mem name ptr Type.F64
let load_addr name ptr offset = load_mem ~offset name ptr Type.I64
let load_addr_ptr name ptr offset = load_mem ~offset name ptr Type.Ptr
let load_addr_f64 name ptr offset = load_mem ~offset name ptr Type.F64

let store value ptr =
  Instr.ir (Ir0.Store (Atom.lit_or_var value, mem_address ptr))
;;

let store_addr value ptr offset =
  Instr.ir (Ir0.Store (Atom.lit_or_var value, mem_address ~offset ptr))
;;

let alloca name size =
  let dest = make_dest name Type.Ptr in
  let instr = Instr.ir (Ir0.Alloca { Ir0.dest; size = Atom.lit_or_var size }) in
  atom_of_var dest, instr
;;

let cast name type_ src =
  let dest = make_dest name type_ in
  let instr = Instr.ir (Ir0.Cast (dest, Atom.lit_or_var src)) in
  atom_of_var dest, instr
;;

let call_common name fn args =
  let dest = make_dest name (Fn.Unnamed.ret (Fn.unnamed fn)) in
  let instr =
    Instr.ir
      (Ir0.Call
         { fn = Fn.name fn
         ; results = [ dest ]
         ; args = List.map args ~f:Atom.lit_or_var
         })
  in
  atom_of_var dest, instr
;;

let call0 name (fn : ('ret, 'ret) Fn.t) = call_common name fn []

let call1 name (fn : ('a -> 'ret, 'ret) Fn.t) (arg : 'a Atom.t) =
  call_common name fn [ arg ]
;;

let call2
  name
  (fn : ('a -> 'b -> 'ret, 'ret) Fn.t)
  (arg1 : 'a Atom.t)
  (arg2 : 'b Atom.t)
  =
  call_common name fn [ arg1; arg2 ]
;;
