open! Core
open! Import

module Located = struct
  type 'a t =
    { pos : Pos.t
    ; value : 'a
    }
  [@@deriving sexp]
end

type intrinsic_name =
  | Alloca
  | Alloca_array
  | Load
  | Store
  | Ptr_add
  | Field_addr
  | Sizeof
  | Alignof
  | Offsetof
  | F64_of_i64
  | I64_of_f64
  | Bitcast
  | Ptr_cast
[@@deriving sexp, compare, equal]

type intrinsic_arg =
  | Arg_expr of expr
  | Arg_field of { field : string }

and top_expr_desc =
  | Top_int of int64
  | Top_float of float
  | Top_unit
  | Top_var of string
  | Top_struct of
      { ty_name : string
      ; fields : (string * top_expr) list
      }

and top_expr =
  { pos : Pos.t
  ; ty : Ty.t
  ; desc : top_expr_desc
  }
[@@deriving sexp]

and expr_desc =
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
  | Intrinsic_call of
      { name : intrinsic_name
      ; type_args : Ty.t list
      ; args : intrinsic_arg list
      }
  | Call of
      { name : string
      ; args : expr list
      }
  | If of
      { cond : expr
      ; then_ : expr
      ; else_ : expr
      }
  | Binop of
      { op : Cst.binop
      ; lhs : expr
      ; rhs : expr
      }
  | Unop of
      { op : Cst.unop
      ; arg : expr
      }
  | Paren of expr

and expr =
  { pos : Pos.t
  ; ty : Ty.t
  ; desc : expr_desc
  }
[@@deriving sexp]

type stmt_desc =
  | Let of
      { name : string
      ; ty : Ty.t
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

and stmt =
  { pos : Pos.t
  ; desc : stmt_desc
  }
[@@deriving sexp]

and block =
  { pos : Pos.t
  ; stmts : stmt list
  }
[@@deriving sexp]

type field =
  { name : string
  ; ty : Ty.t
  }
[@@deriving sexp]

type param =
  { name : string
  ; ty : Ty.t
  }
[@@deriving sexp]

type item =
  | Type_def of
      { pos : Pos.t
      ; name : string
      ; fields : field list
      }
  | Extern_decl of
      { pos : Pos.t
      ; name : string
      ; params : Ty.t list
      ; ret : Ty.t
      ; symbol : string
      }
  | Fun_def of
      { pos : Pos.t
      ; name : string
      ; params : param list
      ; ret : Ty.t
      ; body : block
      }
  | Global_def of
      { pos : Pos.t
      ; name : string
      ; ty : Ty.t
      ; init : top_expr
      }
[@@deriving sexp]

type program =
  { items : item list }
[@@deriving sexp]
