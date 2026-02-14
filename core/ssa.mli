open! Core
open! Import

val convert_program
  :  ?mem2reg:bool
  -> ( Typed_var.t
       , root:Block.t * blocks:Block.t String.Map.t * in_order:Block.t Nod_vec.t
       )
       Program.t
  -> state:State.t
  -> (Typed_var.t, Block.t) Program.t
