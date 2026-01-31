open! Core
open! Import
module Reg = Arm64_reg

module Jump_target : sig
  type 'var t =
    | Reg of 'var Reg.t
    | Imm of Int64.t
    | Symbol of Symbol.t
    | Label of string
  [@@deriving sexp, equal, compare, hash]
end

module Condition : sig
  type t =
    | Eq
    | Ne
    | Lt
    | Le
    | Gt
    | Ge
    | Pl
    | Mi
  [@@deriving sexp, equal, compare, hash, enumerate]
end

module Int_op : sig
  type t =
    | Add
    | Sub
    | Mul
    | Sdiv
    | Smod
    | And
    | Orr
    | Eor
    | Lsl
    | Lsr
    | Asr
  [@@deriving sexp, equal, compare, hash, enumerate]
end

module Float_op : sig
  type t =
    | Fadd
    | Fsub
    | Fmul
    | Fdiv
  [@@deriving sexp, equal, compare, hash, enumerate]
end

module Convert_op : sig
  type t =
    | Int_to_float
    | Float_to_int
  [@@deriving sexp, equal, compare, hash, enumerate]
end

module Comp_kind : sig
  type t =
    | Int
    | Float
  [@@deriving sexp, equal, compare, hash, enumerate]
end

type 'var operand =
  | Reg of 'var Reg.t
  | Imm of Int64.t
  | Mem of 'var Reg.t * int
  | Spill_slot of int
[@@deriving sexp, equal, compare, hash]

val reg_of_operand_exn : 'var operand -> 'var Reg.t
val var_of_reg : 'var Reg.t -> 'var option

type ('var, 'block) t =
  | Nop
  | Tag_use of ('var, 'block) t * 'var operand
  | Tag_def of ('var, 'block) t * 'var operand
  | Move of
      { dst : 'var Reg.t
      ; src : 'var operand
      }
  | Load of
      { dst : 'var Reg.t
      ; addr : 'var operand
      }
  | Store of
      { src : 'var operand
      ; addr : 'var operand
      }
  | Int_binary of
      { op : Int_op.t
      ; dst : 'var Reg.t
      ; lhs : 'var operand
      ; rhs : 'var operand
      }
  | Float_binary of
      { op : Float_op.t
      ; dst : 'var Reg.t
      ; lhs : 'var operand
      ; rhs : 'var operand
      }
  | Convert of
      { op : Convert_op.t
      ; dst : 'var Reg.t
      ; src : 'var operand
      }
  | Bitcast of
      { dst : 'var Reg.t
      ; src : 'var operand
      }
  | Adr of
      { dst : 'var Reg.t
      ; target : 'var Jump_target.t
      }
  | Comp of
      { kind : Comp_kind.t
      ; lhs : 'var operand
      ; rhs : 'var operand
      }
  | Cset of
      { condition : Condition.t
      ; dst : 'var Reg.t
      }
  | Conditional_branch of
      { condition : Condition.t
      ; then_ : ('var, 'block) Call_block.t
      ; else_ : ('var, 'block) Call_block.t option
      }
  | Jump of ('var, 'block) Call_block.t
  | Call of
      { fn : string
      ; results : 'var Reg.t list
      ; args : 'var operand list
      }
  | Ret of 'var operand list
  | Label of string
  | Save_clobbers
  | Restore_clobbers
  | Alloca of 'var operand * Int64.t
  | Dmb
  | Ldar of
      { dst : 'var Reg.t
      ; addr : 'var operand
      }
  | Stlr of
      { src : 'var operand
      ; addr : 'var operand
      }
  | Ldaxr of
      { dst : 'var Reg.t
      ; addr : 'var operand
      }
  | Stlxr of
      { status : 'var Reg.t
      ; src : 'var operand
      ; addr : 'var operand
      }
  | Casal of
      { dst : 'var Reg.t
      ; expected : 'var operand
      ; desired : 'var operand
      ; addr : 'var operand
      }
[@@deriving sexp, equal, compare, hash, variants]

val fn : ('var, 'block) t -> string option

val map_var_operands
  :  ('var, 'block) t
  -> f:('var -> 'var2)
  -> ('var2, 'block) t

val map_operands
  :  ('var, 'block) t
  -> f:('var operand -> 'var operand)
  -> ('var, 'block) t

val map_call_blocks
  :  ('var, 'block) t
  -> f:(('var, 'block) Call_block.t -> ('var, 'block2) Call_block.t)
  -> ('var, 'block2) t

val iter_call_blocks
  :  ('var, 'block) t
  -> f:(('var, 'block) Call_block.t -> unit)
  -> unit

val filter_map_call_blocks
  :  ('var, 'block) t
  -> f:(('var, 'block) Call_block.t -> 'a option)
  -> 'a list

val map_blocks : ('var, 'block) t -> f:('block -> 'block2) -> ('var, 'block2) t
val map_defs : ('var, 'block) t -> f:('var -> 'var) -> ('var, 'block) t
val map_uses : ('var, 'block) t -> f:('var -> 'var) -> ('var, 'block) t
val blocks : ('var, 'block) t -> 'block list
val call_blocks : ('var, 'block) t -> ('var, 'block) Call_block.t list
val is_terminal : ('var, 'block) t -> bool
val reg_defs : ('var, 'block) t -> 'var Reg.t list
val reg_uses : ('var, 'block) t -> 'var Reg.t list
val regs : ('var, 'block) t -> 'var Reg.t list
val defs : ('var, 'block) t -> 'var list
val uses : ('var, 'block) t -> 'var list
val vars : ('var, 'block) t -> 'var list
val unreachable : ('var, 'block) t

module For_backend : sig
  val map_use_regs
    :  ('var, 'block) t
    -> f:(must_be_reg:bool -> 'var Reg.t -> 'var operand)
    -> ('var, 'block) t

  val map_def_regs
    :  ('var, 'block) t
    -> f:(must_be_reg:bool -> 'var Reg.t -> 'var operand)
    -> ('var, 'block) t
end
