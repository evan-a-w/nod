open! Core
open! Import
open Ir_helpers

type ('var, 'block) t =
  | Noop
  | And of 'var arith
  | Or of 'var arith
  | Add of 'var arith
  | Sub of 'var arith
  | Mul of 'var arith
  | Div of 'var arith
  | Mod of 'var arith
  | Lt of 'var arith
  | Fadd of 'var arith
  | Fsub of 'var arith
  | Fmul of 'var arith
  | Fdiv of 'var arith
  | Alloca of 'var alloca
  | Call of
      { fn : string
      ; results : 'var list
      ; args : 'var Lit_or_var.t list
      }
  | Load of 'var * 'var Mem.t
  | Store of 'var Lit_or_var.t * 'var Mem.t
  | Load_field of 'var load_field
  | Store_field of 'var store_field
  | Memcpy of 'var memcpy
  | Atomic_load of 'var atomic_load
  | Atomic_store of 'var atomic_store
  | Atomic_rmw of 'var atomic_rmw
  | Atomic_cmpxchg of 'var atomic_cmpxchg
  | Move of 'var * 'var Lit_or_var.t
  | Cast of 'var * 'var Lit_or_var.t
  | Branch of ('var, 'block) Branch.t
  | Return of 'var Lit_or_var.t
  | Arm64 of ('var, 'block) Arm64_ir.t
  | Arm64_terminal of ('var, 'block) Arm64_ir.t list
  | X86 of ('var, 'block) X86_ir.t
  | X86_terminal of ('var, 'block) X86_ir.t list
  | Unreachable
[@@deriving sexp, compare, equal, variants, hash]

val filter_map_call_blocks
  :  ('var, 'block) t
  -> f:(('var, 'block) Call_block.t -> 'a option)
  -> 'a list

val constant_fold : ('var, 'block) t -> ('var, 'block) t
val maybe_constant_fold : ('var, 'block) t -> ('var, 'block) t option
val constant : ('var, 'block) t -> Int64.t option
val defs : ('var, 'block) t -> 'var list
val uses : ('var, 'block) t -> 'var list
val vars : ('var, 'block) t -> 'var list
val blocks : ('var, 'block) t -> 'block list
val x86_regs : ('var, 'block) t -> 'var X86_reg.t list
val x86_reg_defs : ('var, 'block) t -> 'var X86_reg.t list
val arm64_regs : ('var, 'block) t -> 'var Arm64_reg.t list
val arm64_reg_defs : ('var, 'block) t -> 'var Arm64_reg.t list
val map_defs : ('var, 'block) t -> f:('var -> 'var) -> ('var, 'block) t
val map_uses : ('var, 'block) t -> f:('var -> 'var) -> ('var, 'block) t
val map_vars : ('var, 'block) t -> f:('var -> 'var2) -> ('var2, 'block) t
val is_terminal : ('var, 'block) t -> bool

val map_call_blocks
  :  ('var, 'block) t
  -> f:(('var, 'block) Call_block.t -> ('var, 'block2) Call_block.t)
  -> ('var, 'block2) t

val iter_call_blocks
  :  ('var, 'block) t
  -> f:(('var, 'block) Call_block.t -> unit)
  -> unit

val map_blocks : ('var, 'block) t -> f:('block -> 'block2) -> ('var, 'block2) t

val map_lit_or_vars
  :  ('var, 'block) t
  -> f:('var Lit_or_var.t -> 'var Lit_or_var.t)
  -> ('var, 'block) t

val jump_to : 'block -> ('var, 'block) t
val call_blocks : ('var, 'block) t -> ('var, 'block) Call_block.t list

val map_x86_operands
  :  ('var, 'block) t
  -> f:('var X86_ir.operand -> 'var X86_ir.operand)
  -> ('var, 'block) t

val map_arm64_operands
  :  ('var, 'block) t
  -> f:('var Arm64_ir.operand -> 'var Arm64_ir.operand)
  -> ('var, 'block) t

val uses_ex_args
  :  ('var, 'block) t
  -> compare_var:('var -> 'var -> int)
  -> 'var list
