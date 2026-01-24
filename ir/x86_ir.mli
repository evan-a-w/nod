open! Core
open! Import
module Reg = X86_reg

module Jump_target : sig
  type 'var t =
    | Reg of 'var Reg.t
    | Imm of Int64.t
    | Symbol of Symbol.t
end

type 'var operand =
  | Reg of 'var Reg.t
  | Imm of Int64.t
  | Mem of 'var Reg.t * int
  | Spill_slot of int
  | Symbol of string
[@@deriving sexp, equal, compare, hash]

val reg_of_operand_exn : 'var operand -> 'var Reg.t

type ('var, 'block) t =
  | NOOP
  | Tag_use of ('var, 'block) t * 'var operand
  | Tag_def of ('var, 'block) t * 'var operand
  | AND of 'var operand * 'var operand
  | OR of 'var operand * 'var operand
  | MOV of 'var operand * 'var operand
  | ADD of 'var operand * 'var operand
  | SUB of 'var operand * 'var operand
  | IMUL of 'var operand
  | IDIV of 'var operand
  | MOD of 'var operand
  | ADDSD of 'var operand * 'var operand
  | SUBSD of 'var operand * 'var operand
  | MULSD of 'var operand * 'var operand
  | DIVSD of 'var operand * 'var operand
  | MOVSD of 'var operand * 'var operand
  | MOVQ of 'var operand * 'var operand
  | CVTSI2SD of 'var operand * 'var operand
  | CVTTSD2SI of 'var operand * 'var operand
  | MFENCE
  | XCHG of 'var operand * 'var operand
  | LOCK_ADD of 'var operand * 'var operand
  | LOCK_SUB of 'var operand * 'var operand
  | LOCK_AND of 'var operand * 'var operand
  | LOCK_OR of 'var operand * 'var operand
  | LOCK_XOR of 'var operand * 'var operand
  | LOCK_CMPXCHG of
      { dest : 'var operand
      ; expected : 'var operand
      ; desired : 'var operand
      }
  | Save_clobbers
  | Restore_clobbers
  | CALL of
      { fn : string
      ; results : 'var Reg.t list
      ; args : 'var operand list
      }
  | PUSH of 'var operand
  | POP of 'var Reg.t
  | LABEL of string
  | CMP of 'var operand * 'var operand
  | SETE of 'var operand
  | SETL of 'var operand
  | JE of ('var, 'block) Call_block.t * ('var, 'block) Call_block.t option
  | JNE of ('var, 'block) Call_block.t * ('var, 'block) Call_block.t option
  | JMP of ('var, 'block) Call_block.t
  | RET of 'var operand list
  | ALLOCA of 'var operand * Int64.t
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

val map_blocks : ('var, 'block) t -> f:('block -> 'block2) -> ('var, 'block2) t

val filter_map_call_blocks
  :  ('var, 'block) t
  -> f:(('var, 'block) Call_block.t -> 'a option)
  -> 'a list

val iter_call_blocks
  :  ('var, 'block) t
  -> f:(('var, 'block) Call_block.t -> unit)
  -> unit

val call_blocks : ('var, 'block) t -> ('var, 'block) Call_block.t list
val blocks : ('var, 'block) t -> 'block list
val is_terminal : ('var, 'block) t -> bool
val reg_defs : ('var, 'block) t -> 'var Reg.t list
val reg_uses : ('var, 'block) t -> 'var Reg.t list
val regs : ('var, 'block) t -> 'var Reg.t list
val defs : ('var, 'block) t -> 'var list
val uses : ('var, 'block) t -> 'var list
val vars : ('var, 'block) t -> 'var list
val map_defs : ('var, 'block) t -> f:('var -> 'var) -> ('var, 'block) t
val map_uses : ('var, 'block) t -> f:('var -> 'var) -> ('var, 'block) t
