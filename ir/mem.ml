open! Core
open! Import

type 'var address =
  { base : 'var Lit_or_var.t
  ; offset : int
  }
[@@deriving sexp, compare, equal, hash]

type 'var t =
  | Stack_slot of int (* bytes *)
  | Address of 'var address
  | Global of Global.t
[@@deriving sexp, compare, equal, hash]

let vars = function
  | Address { base; _ } -> Lit_or_var.vars base
  | Stack_slot _ -> []
  | Global _ -> []
;;

let map_vars t ~f =
  match t with
  | Address { base; offset } ->
    Address { base = Lit_or_var.map_vars base ~f; offset }
  | Stack_slot s -> Stack_slot s
  | Global g -> Global g
;;

let map_lit_or_vars t ~f =
  match t with
  | Address { base; offset } -> Address { base = f base; offset }
  | Stack_slot s -> Stack_slot s
  | Global g -> Global g
;;

let address ?(offset = 0) base = Address { base; offset }

let to_x86_ir_operand t : 'var X86_ir.operand =
  match t with
  | Address { base = Lit_or_var.Var v; offset } ->
    Mem (X86_reg.unallocated v, offset)
  | Stack_slot i ->
    Breadcrumbs.frame_pointer_omission;
    Mem (X86_reg.rbp, i)
  | Global _ -> failwith "cannot convert global address without lowering"
  | Address { base = Lit_or_var.Global _; _ } ->
    failwith "cannot convert global address without lowering"
  | Address { base = Lit_or_var.Lit _; _ } ->
    failwith "cannot convert literal address without lowering"
;;

let to_arm64_ir_operand t : 'var Arm64_ir.operand =
  match t with
  | Stack_slot i -> Arm64_ir.Mem (Arm64_reg.fp, i)
  | Address { base = Lit_or_var.Var v; offset } ->
    Arm64_ir.Mem (Arm64_reg.unallocated v, offset)
  | Global _ -> failwith "cannot convert global address without lowering"
  | Address { base = Lit_or_var.Global _; _ } ->
    failwith "cannot convert global address without lowering"
  | Address { base = Lit_or_var.Lit _; _ } ->
    failwith "cannot convert literal address without lowering"
;;
