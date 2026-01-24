open! Core
open! Import

type 'var t =
  | Lit of Lit.t
  | Var of 'var
  | Global of Global.t
[@@deriving sexp, compare, equal, hash]

let vars = function
  | Lit _ -> []
  | Var v -> [ v ]
  | Global _ -> []
;;

let map_vars t ~f =
  match t with
  | Lit _ -> t
  | Var v -> Var (f v)
  | Global _ -> t
;;

let to_x86_ir_operand t : X86_ir.operand =
  match t with
  | Lit l -> Imm l
  | Var v -> Reg (X86_reg.unallocated v)
  | Global _ -> failwith "cannot convert global operand without lowering"
;;

let to_arm64_ir_operand t : Arm64_ir.operand =
  match t with
  | Lit l -> Arm64_ir.Imm l
  | Var v -> Arm64_ir.Reg (Arm64_reg.unallocated v)
  | Global _ -> failwith "cannot convert global operand without lowering"
;;
