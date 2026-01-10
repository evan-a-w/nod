open! Core
open! Import

type int64
type float64
type ptr

module Type_repr : sig
  type _ t =
    | Int64 : int64 t
    | Float64 : float64 t
    | Ptr : ptr t

  val type_ : 'a t -> Type.t
end

module Atom : sig
  type _ t

  val type_ : 'a t -> Type.t
  val lit_or_var : _ t -> Ir.Lit_or_var.t
  val var : _ t -> Var.t option
end

module Instr : sig
  type t

  val ir : string Ir0.t -> t

  val process
    :  ?root_name:string
    -> t list
    -> (Eir.raw_block, Nod_error.t) Result.t
end

module Fn : sig
  type 'a t

  val name : 'a t -> string
  val function_ : 'a t -> (Eir.raw_block Function0.t', Nod_error.t) Result.t

  module Unnamed : sig
    type 'a t

    val const : 'a Type_repr.t -> Instr.t list -> 'a t
    val with_arg : 'ret t -> Var.t -> ('a -> 'ret) t
    val args : 'a t -> Var.t list
    val ret : 'a t -> Type.t
    val instrs : 'a t -> Instr.t list
  end

  val unnamed : 'a t -> 'a Unnamed.t
  val create : unnamed:'a Unnamed.t -> name:string -> 'a t

  module Packed : sig
    type t
  end

  val pack : _ t -> Packed.t
end

(** meta functions *)

val program : functions:Fn.Packed.t list -> globals:Global.t list -> Eir.input

(** builder functions *)

val lit : Int64.t -> int64 Atom.t
val var : Var.t -> 'a Atom.t
val global : Global.t -> ptr Atom.t
val mov : string -> 'a Atom.t -> 'a Atom.t * Instr.t
val add : string -> int64 Atom.t -> int64 Atom.t -> int64 Atom.t * Instr.t
val sub : string -> int64 Atom.t -> int64 Atom.t -> int64 Atom.t * Instr.t
val mul : string -> int64 Atom.t -> int64 Atom.t -> int64 Atom.t * Instr.t
val div : string -> int64 Atom.t -> int64 Atom.t -> int64 Atom.t * Instr.t
val mod_ : string -> int64 Atom.t -> int64 Atom.t -> int64 Atom.t * Instr.t
val and_ : string -> int64 Atom.t -> int64 Atom.t -> int64 Atom.t * Instr.t
val or_ : string -> int64 Atom.t -> int64 Atom.t -> int64 Atom.t * Instr.t
val ptr_add : string -> ptr Atom.t -> int64 Atom.t -> ptr Atom.t * Instr.t
val ptr_sub : string -> ptr Atom.t -> int64 Atom.t -> ptr Atom.t * Instr.t
val ptr_diff : string -> ptr Atom.t -> ptr Atom.t -> int64 Atom.t * Instr.t

val fadd
  :  string
  -> float64 Atom.t
  -> float64 Atom.t
  -> float64 Atom.t * Instr.t

val fsub
  :  string
  -> float64 Atom.t
  -> float64 Atom.t
  -> float64 Atom.t * Instr.t

val fmul
  :  string
  -> float64 Atom.t
  -> float64 Atom.t
  -> float64 Atom.t * Instr.t

val fdiv
  :  string
  -> float64 Atom.t
  -> float64 Atom.t
  -> float64 Atom.t * Instr.t

val load : string -> ptr Atom.t -> int64 Atom.t * Instr.t
val load_ptr : string -> ptr Atom.t -> ptr Atom.t * Instr.t
val load_f64 : string -> ptr Atom.t -> float64 Atom.t * Instr.t
val store : 'a Atom.t -> ptr Atom.t -> Instr.t
val load_addr : string -> ptr Atom.t -> int -> int64 Atom.t * Instr.t
val load_addr_ptr : string -> ptr Atom.t -> int -> ptr Atom.t * Instr.t
val load_addr_f64 : string -> ptr Atom.t -> int -> float64 Atom.t * Instr.t
val store_addr : 'a Atom.t -> ptr Atom.t -> int -> Instr.t
val alloca : string -> int64 Atom.t -> ptr Atom.t * Instr.t
val cast : string -> Type.t -> 'a Atom.t -> 'b Atom.t * Instr.t
val call0 : string -> 'ret Fn.t -> 'ret Atom.t * Instr.t
val call1 : string -> ('a -> 'ret) Fn.t -> 'a Atom.t -> 'ret Atom.t * Instr.t

val call2
  :  string
  -> ('a -> 'b -> 'ret) Fn.t
  -> 'a Atom.t
  -> 'b Atom.t
  -> 'ret Atom.t * Instr.t
