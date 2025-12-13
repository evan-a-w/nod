open! Core
open! Import

module Located = struct
  type 'a t =
    { pos : Pos.t
    ; value : 'a
    }
  [@@deriving sexp]
end

type ty_desc =
  | I64
  | F64
  | Unit
  | Named of string
  | Ptr of ty
[@@deriving sexp]

and ty = ty_desc Located.t [@@deriving sexp]

type binop =
  | Add
  | Sub
  | Mul
  | Div
  | Mod
  | Eq
  | Ne
  | Lt
  | Le
  | Gt
  | Ge
  | Land
  | Lor
  | Lxor
  | Lsl
  | Lsr
  | Asr
[@@deriving sexp]

type unop = Neg [@@deriving sexp]

type expr_desc =
  | Int of int64
  | Float of float
  | Unit_lit
  | Var of string
  | Struct_lit of
      { ty_name : string
      ; fields : (string * expr) list
      }
  | Field of
      { base : expr
      ; field : string
      }
  | Arrow_field of
      { base : expr
      ; field : string
      }
  | Index of
      { base : expr
      ; index : expr
      }
  | Call of
      { callee : expr
      ; type_args : ty list
      ; args : call_arg list
      }
  | If of
      { cond : expr
      ; then_ : expr
      ; else_ : expr
      }
  | Binop of
      { op : binop
      ; lhs : expr
      ; rhs : expr
      }
  | Unop of
      { op : unop
      ; arg : expr
      }
  | Paren of expr

and expr = expr_desc Located.t [@@deriving sexp]

and call_arg =
  | Expr of expr
  | Named_field of { field : string }
[@@deriving sexp]

type top_expr_desc =
  | Top_int of int64
  | Top_float of float
  | Top_unit
  | Top_var of string
  | Top_struct of
      { ty_name : string
      ; fields : (string * top_expr) list
      }

and top_expr = top_expr_desc Located.t [@@deriving sexp]

type field =
  { name : string
  ; ty : ty
  }
[@@deriving sexp]

type param =
  { name : string
  ; ty : ty
  }
[@@deriving sexp]

type stmt_desc =
  | Let of
      { name : string
      ; ty : ty
      ; expr : expr
      }
  | If_stmt of
      { cond : expr
      ; then_ : block
      ; else_ : block
      }
  | While of
      { cond : expr
      ; body : block
      }
  | Return of expr
  | Expr_stmt of expr

and stmt = stmt_desc Located.t [@@deriving sexp]

and block_desc = { stmts : stmt list } [@@deriving sexp]

and block = block_desc Located.t [@@deriving sexp]

type item_desc =
  | Type_def of
      { name : string
      ; fields : field list
      }
  | Extern_decl of
      { name : string
      ; params : ty list
      ; ret : ty
      ; symbol : string
      }
  | Fun_def of
      { name : string
      ; params : param list
      ; ret : ty
      ; body : block
      }
  | Global_def of
      { name : string
      ; ty : ty
      ; init : top_expr
      }
[@@deriving sexp]

type item = item_desc Located.t [@@deriving sexp]
type program = item list [@@deriving sexp]

