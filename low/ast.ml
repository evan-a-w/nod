open! Core

type type_expr =
  | I64
  | F64
  | Ptr of type_expr
  | Struct of string
[@@deriving sexp, compare, equal]

type unop =
  | Neg
  | Deref
[@@deriving sexp, compare, equal]

type binop =
  | Add
  | Sub
  | Mul
  | Div
  | Mod
[@@deriving sexp, compare, equal]

type expr =
  | Int of int64
  | Float of float
  | Var of string
  | Unary of unop * expr
  | Binary of binop * expr * expr
  | Call of string * expr list
  | Field of expr * string
  | Alloca of type_expr
  | Alloc of type_expr
  | Cast of type_expr * expr
[@@deriving sexp, compare, equal]

type stmt =
  | Let of type_expr * string * expr option
  | Assign of expr * expr
  | Return of expr
  | If of expr * stmt list * stmt list option
  | While of expr * stmt list
  | Expr of expr
[@@deriving sexp, compare, equal]

type param =
  { name : string
  ; type_ : type_expr
  }
[@@deriving sexp, compare, equal]

type func =
  { name : string
  ; params : param list
  ; return_type : type_expr
  ; body : stmt list
  }
[@@deriving sexp, compare, equal]

type struct_def =
  { name : string
  ; fields : (string * type_expr) list
  }
[@@deriving sexp, compare, equal]

type program =
  { structs : struct_def list
  ; functions : func list
  }
[@@deriving sexp, compare, equal]
