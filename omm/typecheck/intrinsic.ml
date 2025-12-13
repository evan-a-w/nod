open! Core
open! Import

type t = Ast.intrinsic_name [@@deriving sexp, compare, equal]

let of_string = function
  | "alloca" -> Some Ast.Alloca
  | "alloca_array" -> Some Ast.Alloca_array
  | "load" -> Some Ast.Load
  | "store" -> Some Ast.Store
  | "ptr_add" -> Some Ast.Ptr_add
  | "field_addr" -> Some Ast.Field_addr
  | "sizeof" -> Some Ast.Sizeof
  | "alignof" -> Some Ast.Alignof
  | "offsetof" -> Some Ast.Offsetof
  | "f64_of_i64" -> Some Ast.F64_of_i64
  | "i64_of_f64" -> Some Ast.I64_of_f64
  | "bitcast" -> Some Ast.Bitcast
  | "ptr_cast" -> Some Ast.Ptr_cast
  | _ -> None
;;

let to_string (t : t) = Sexp.to_string (sexp_of_t t)

let reserved_names =
  [ "alloca"
  ; "alloca_array"
  ; "load"
  ; "store"
  ; "ptr_add"
  ; "field_addr"
  ; "sizeof"
  ; "alignof"
  ; "offsetof"
  ; "f64_of_i64"
  ; "i64_of_f64"
  ; "bitcast"
  ; "ptr_cast"
  ]
;;

