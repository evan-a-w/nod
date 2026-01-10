open! Core
open! Nod_core

type int64
type int32
type int16
type int8
type float64
type float32
type ptr
type i64 = int64
type i32 = int32
type i16 = int16
type i8 = int8
type f64 = float64
type f32 = float32

module Atom : sig
  type _ t

  val lit_or_var : _ t -> Ir.Lit_or_var.t
  val var : _ t -> Var.t option
end

module Instr : sig
  type t =
    | Ir : Ir.t -> t
    | Label : string -> t
    | Atom : _ Atom.t -> t
end

module Fn : sig
  type ('args, 'ret) t

  val name : ('args, 'ret) t -> string
  val function_exn : ('args, 'ret) t -> Function.t
  val functions : ('args, 'ret) t list -> Function.t list

  val external_
    :  name:string
    -> args:Type.t list
    -> returns:Type.t list
    -> ('args, 'ret) t

  val of_function : Function.t -> ('args, 'ret) t
end

val with_builder : Ir_builder.t -> (unit -> 'a) -> 'a
val lit : Int64.t -> int64 Atom.t
val var : Var.t -> 'a Atom.t
val global : Global.t -> ptr Atom.t
val mov : string -> 'a Atom.t -> 'a Atom.t
val add : string -> int64 Atom.t -> int64 Atom.t -> int64 Atom.t
val sub : string -> int64 Atom.t -> int64 Atom.t -> int64 Atom.t
val mul : string -> int64 Atom.t -> int64 Atom.t -> int64 Atom.t
val div : string -> int64 Atom.t -> int64 Atom.t -> int64 Atom.t
val mod_ : string -> int64 Atom.t -> int64 Atom.t -> int64 Atom.t
val and_ : string -> int64 Atom.t -> int64 Atom.t -> int64 Atom.t
val or_ : string -> int64 Atom.t -> int64 Atom.t -> int64 Atom.t
val ptr_add : string -> ptr Atom.t -> int64 Atom.t -> ptr Atom.t
val ptr_sub : string -> ptr Atom.t -> int64 Atom.t -> ptr Atom.t
val ptr_diff : string -> ptr Atom.t -> ptr Atom.t -> int64 Atom.t
val fadd : string -> float64 Atom.t -> float64 Atom.t -> float64 Atom.t
val fsub : string -> float64 Atom.t -> float64 Atom.t -> float64 Atom.t
val fmul : string -> float64 Atom.t -> float64 Atom.t -> float64 Atom.t
val fdiv : string -> float64 Atom.t -> float64 Atom.t -> float64 Atom.t
val load : string -> ptr Atom.t -> int64 Atom.t
val load_ptr : string -> ptr Atom.t -> ptr Atom.t
val load_f64 : string -> ptr Atom.t -> float64 Atom.t
val store : 'a Atom.t -> ptr Atom.t -> unit
val load_addr : string -> ptr Atom.t -> int -> int64 Atom.t
val load_addr_ptr : string -> ptr Atom.t -> int -> ptr Atom.t
val load_addr_f64 : string -> ptr Atom.t -> int -> float64 Atom.t
val store_addr : 'a Atom.t -> ptr Atom.t -> int -> unit
val alloca : string -> int64 Atom.t -> ptr Atom.t
val cast : string -> Type.t -> 'a Atom.t -> 'b Atom.t
val call : string -> ('a Atom.t, 'b Atom.t) Fn.t -> 'a Atom.t -> 'b Atom.t
val call0 : string -> (unit, 'a Atom.t) Fn.t -> 'a Atom.t

val call2
  :  string
  -> ('a Atom.t * 'b Atom.t, 'c Atom.t) Fn.t
  -> 'a Atom.t
  -> 'b Atom.t
  -> 'c Atom.t

val call3
  :  string
  -> ('a Atom.t * 'b Atom.t * 'c Atom.t, 'd Atom.t) Fn.t
  -> 'a Atom.t
  -> 'b Atom.t
  -> 'c Atom.t
  -> 'd Atom.t

val call4
  :  string
  -> ('a Atom.t * 'b Atom.t * 'c Atom.t * 'd Atom.t, 'e Atom.t) Fn.t
  -> 'a Atom.t
  -> 'b Atom.t
  -> 'c Atom.t
  -> 'd Atom.t
  -> 'e Atom.t

val call5
  :  string
  -> ('a Atom.t * 'b Atom.t * 'c Atom.t * 'd Atom.t * 'e Atom.t, 'f Atom.t) Fn.t
  -> 'a Atom.t
  -> 'b Atom.t
  -> 'c Atom.t
  -> 'd Atom.t
  -> 'e Atom.t
  -> 'f Atom.t

val load_field : string -> ptr Atom.t -> Type.t -> int list -> 'a Atom.t
val store_field : ptr Atom.t -> 'a Atom.t -> Type.t -> int list -> unit
val memcpy : ptr Atom.t -> ptr Atom.t -> Type.t -> unit

(* module Instr : sig *)
(*   val mov : dest:'a Atom.t -> 'a Atom.t -> Block.t Ir0.t *)
(*   val add : dest:int64 Atom.t -> int64 Atom.t -> int64 Atom.t -> Block.t Ir0.t *)
(*   val sub : dest:int64 Atom.t -> int64 Atom.t -> int64 Atom.t -> Block.t Ir0.t *)
(*   val mul : dest:int64 Atom.t -> int64 Atom.t -> int64 Atom.t -> Block.t Ir0.t *)
(*   val div : dest:int64 Atom.t -> int64 Atom.t -> int64 Atom.t -> Block.t Ir0.t *)
(*   val mod_ : dest:int64 Atom.t -> int64 Atom.t -> int64 Atom.t -> Block.t Ir0.t *)
(*   val and_ : dest:int64 Atom.t -> int64 Atom.t -> int64 Atom.t -> Block.t Ir0.t *)
(*   val or_ : dest:int64 Atom.t -> int64 Atom.t -> int64 Atom.t -> Block.t Ir0.t *)

(*   val fadd *)
(*     :  dest:float64 Atom.t *)
(*     -> float64 Atom.t *)
(*     -> float64 Atom.t *)
(*     -> Block.t Ir0.t *)

(*   val fsub *)
(*     :  dest:float64 Atom.t *)
(*     -> float64 Atom.t *)
(*     -> float64 Atom.t *)
(*     -> Block.t Ir0.t *)

(*   val fmul *)
(*     :  dest:float64 Atom.t *)
(*     -> float64 Atom.t *)
(*     -> float64 Atom.t *)
(*     -> Block.t Ir0.t *)

(*   val fdiv *)
(*     :  dest:float64 Atom.t *)
(*     -> float64 Atom.t *)
(*     -> float64 Atom.t *)
(*     -> Block.t Ir0.t *)

(*   val load : Ir.Mem.t -> dest:'a Atom.t -> Block.t Ir0.t *)
(*   val store : 'a Atom.t -> Ir.Mem.t -> Block.t Ir0.t *)
(*   val load_addr : ptr Atom.t -> int -> dest:'a Atom.t -> Block.t Ir0.t *)
(*   val store_addr : 'a Atom.t -> ptr Atom.t -> int -> Block.t Ir0.t *)
(*   val alloca : int64 Atom.t -> dest:ptr Atom.t -> Block.t Ir0.t *)
(*   val cast : 'a Atom.t -> dest:'b Atom.t -> Block.t Ir0.t *)

(*   val load_field *)
(*     :  ptr Atom.t *)
(*     -> Type.t *)
(*     -> int list *)
(*     -> dest:'a Atom.t *)
(*     -> Block.t Ir0.t *)

(*   val store_field *)
(*     :  ptr Atom.t *)
(*     -> 'a Atom.t *)
(*     -> Type.t *)
(*     -> int list *)
(*     -> Block.t Ir0.t *)

(*   val memcpy : ptr Atom.t -> ptr Atom.t -> Type.t -> Block.t Ir0.t *)

(*   val atomic_load *)
(*     :  ptr Atom.t *)
(*     -> Ir.Memory_order.t *)
(*     -> dest:int64 Atom.t *)
(*     -> Block.t Ir0.t *)

(*   val atomic_store *)
(*     :  ptr Atom.t *)
(*     -> int64 Atom.t *)
(*     -> Ir.Memory_order.t *)
(*     -> Block.t Ir0.t *)

(*   val atomic_rmw *)
(*     :  ptr Atom.t *)
(*     -> int64 Atom.t *)
(*     -> Ir.Rmw_op.t *)
(*     -> Ir.Memory_order.t *)
(*     -> dest:int64 Atom.t *)
(*     -> Block.t Ir0.t *)

(*   val atomic_cmpxchg *)
(*     :  ptr Atom.t *)
(*     -> int64 Atom.t *)
(*     -> int64 Atom.t *)
(*     -> Ir.Memory_order.t *)
(*     -> Ir.Memory_order.t *)
(*     -> dest:int64 Atom.t *)
(*     -> success:int64 Atom.t *)
(*     -> Block.t Ir0.t *)
(* end *)
