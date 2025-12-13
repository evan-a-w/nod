open! Core
open! Import

type prim =
  | I64
  | F64
[@@deriving sexp, compare, equal]

type t =
  | Prim of prim
  | Unit
  | Struct of string
  | Ptr of t
[@@deriving sexp, compare, equal]

let rec to_string = function
  | Prim I64 -> "i64"
  | Prim F64 -> "f64"
  | Unit -> "unit"
  | Struct s -> s
  | Ptr t -> to_string t ^ " ptr"
;;

let rec of_cst (t : Cst.ty) =
  match t.value with
  | Cst.I64 -> Prim I64
  | Cst.F64 -> Prim F64
  | Cst.Unit -> Unit
  | Cst.Named s -> Struct s
  | Cst.Ptr t -> Ptr (of_cst t)
;;

