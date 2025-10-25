open! Core

type t =
  | I8
  | I16
  | I32
  | I64
  | F32
  | F64
  | Ptr
[@@deriving sexp, compare, equal, variants, hash]

let to_string = function
  | I8 -> "i8"
  | I16 -> "i16"
  | I32 -> "i32"
  | I64 -> "i64"
  | F32 -> "f32"
  | F64 -> "f64"
  | Ptr -> "ptr"
;;

let of_string s =
  match String.uppercase s with
  | "I8" -> Some I8
  | "I16" -> Some I16
  | "I32" -> Some I32
  | "I64" -> Some I64
  | "F32" -> Some F32
  | "F64" -> Some F64
  | "PTR" -> Some Ptr
  | _ -> None
;;

let is_integer = function
  | I8 | I16 | I32 | I64 -> true
  | F32 | F64 | Ptr -> false
;;

let is_float = function
  | F32 | F64 -> true
  | I8 | I16 | I32 | I64 | Ptr -> false
;;

let is_numeric t = is_integer t || is_float t
;;
