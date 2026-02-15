open! Core
open! Dsl_import

type base = Dsl_types.base
type record = Dsl_types.record
type int64 = Dsl_types.int64
type float64 = Dsl_types.float64
type 'a ptr = 'a Dsl_types.ptr

val base : base

module Type_repr : module type of Type_repr_gen

module Atom : sig
  type _ t

  val type_ : 'a t -> Type.t
  val lit_or_var : _ t -> Typed_var.t Ir.Lit_or_var.t
  val var : _ t -> Typed_var.t option
end

module Instr : sig
  type 'ret t

  val ir : (Typed_var.t, string) Nod_ir.Ir.t -> 'ret t

  val process
    :  ?root_name:string
    -> 'ret t list
    -> (Eir.raw_block, Nod_error.t) Result.t
end

module Field : sig
  type ('record, 'field, 'type_info, 'kind) t =
    { repr : 'field Type_repr.t
    ; name : string
    ; index : int
    ; type_info : 'type_info
    ; record_repr : 'record Type_repr.t
    }

  module Loader : sig
    type 'field t

    val dest : string -> 'field t
  end

  val load_immediate
    :  'record Loader.t
    -> ('record, 'field, _, base) t
    -> 'record ptr Atom.t
    -> 'field Atom.t * 'ret Instr.t

  val load_record
    :  'record Loader.t
    -> ('record, 'field, _, record) t
    -> 'field Loader.t

  module Storer : sig
    type ('field, 'record) t

    val src : 'field Atom.t -> ('field, 'record) t
  end

  val store_immediate
    :  ('field, 'record) Storer.t
    -> ('record, 'field, _, base) t
    -> 'record ptr Atom.t
    -> 'ret Instr.t

  val store_record
    :  ('stored_field, 'record) Storer.t
    -> ('record, 'field, _, record) t
    -> ('stored_field, 'field) Storer.t
end

module Fn : sig
  type ('fn, 'ret) t

  val name : ('fn, 'ret) t -> string

  val function_
    :  ('fn, 'ret) t
    -> (Eir.raw_block Function.t', Nod_error.t) Result.t

  module Unnamed : sig
    type ('fn, 'ret) t

    val const : 'ret Type_repr.t -> 'ret Instr.t list -> ('ret, 'ret) t
    val const_with_return : 'ret Atom.t -> 'ret Instr.t list -> ('ret, 'ret) t

    val with_arg
      :  ('fn, 'ret) t
      -> 'a Type_repr.t
      -> Typed_var.t
      -> ('a -> 'fn, 'ret) t

    val args : ('fn, 'ret) t -> Typed_var.t list
    val ret : ('fn, 'ret) t -> Type.t
    val instrs : ('fn, 'ret) t -> 'ret Instr.t list
  end

  val unnamed : ('fn, 'ret) t -> ('fn, 'ret) Unnamed.t
  val create : unnamed:('fn, 'ret) Unnamed.t -> name:string -> ('fn, 'ret) t
  val renamed : name:string -> ('fn, 'ret) t -> ('fn, 'ret) t
  val external_ : name:string -> args:Type.t list -> ret:Type.t -> ('fn, 'ret) t

  module Packed : sig
    type t
  end

  val pack : (_, _) t -> Packed.t
end

(** meta functions *)

val program
  :  functions:Fn.Packed.t list
  -> globals:Nod_ir.Global.t list
  -> (Eir.program, Nod_error.t) Result.t

val compile_program_exn'
  :  (Eir.program, Nod_error.t) Result.t
  -> Nod_core.Block.t Nod_core.Program.t'

val compile_program_exn : Eir.program -> Nod_core.Block.t Nod_core.Program.t'

(** builder functions *)

val return : 'a Atom.t -> 'a Instr.t
val label : string -> 'ret Instr.t
val lit : Int64.t -> int64 Atom.t
val var : Typed_var.t -> 'a Atom.t
val global : Nod_ir.Global.t -> _ ptr Atom.t
val mov : string -> 'a Atom.t -> 'a Atom.t * 'ret Instr.t
val add : string -> int64 Atom.t -> int64 Atom.t -> int64 Atom.t * 'ret Instr.t
val sub : string -> int64 Atom.t -> int64 Atom.t -> int64 Atom.t * 'ret Instr.t
val mul : string -> int64 Atom.t -> int64 Atom.t -> int64 Atom.t * 'ret Instr.t
val div : string -> int64 Atom.t -> int64 Atom.t -> int64 Atom.t * 'ret Instr.t
val mod_ : string -> int64 Atom.t -> int64 Atom.t -> int64 Atom.t * 'ret Instr.t
val and_ : string -> int64 Atom.t -> int64 Atom.t -> int64 Atom.t * 'ret Instr.t
val or_ : string -> int64 Atom.t -> int64 Atom.t -> int64 Atom.t * 'ret Instr.t
val lt : string -> int64 Atom.t -> int64 Atom.t -> int64 Atom.t * 'ret Instr.t

val ptr_add
  :  string
  -> 'a ptr Atom.t
  -> int64 Atom.t
  -> 'a ptr Atom.t * 'ret Instr.t

val ptr_sub
  :  string
  -> 'a ptr Atom.t
  -> int64 Atom.t
  -> 'a ptr Atom.t * 'ret Instr.t

val ptr_diff
  :  string
  -> 'a ptr Atom.t
  -> 'a ptr Atom.t
  -> int64 Atom.t * 'ret Instr.t

val fadd
  :  string
  -> float64 Atom.t
  -> float64 Atom.t
  -> float64 Atom.t * 'ret Instr.t

val fsub
  :  string
  -> float64 Atom.t
  -> float64 Atom.t
  -> float64 Atom.t * 'ret Instr.t

val fmul
  :  string
  -> float64 Atom.t
  -> float64 Atom.t
  -> float64 Atom.t * 'ret Instr.t

val fdiv
  :  string
  -> float64 Atom.t
  -> float64 Atom.t
  -> float64 Atom.t * 'ret Instr.t

val load : string -> 'a ptr Atom.t -> 'a Atom.t * 'ret Instr.t
val store : 'a Atom.t -> 'a ptr Atom.t -> 'ret Instr.t
val alloca : string -> int64 Atom.t -> 'a ptr Atom.t * 'ret Instr.t
val cast : string -> Type.t -> 'a Atom.t -> 'b Atom.t * 'ret Instr.t
val call0 : string -> ('ret, 'ret) Fn.t -> 'ret Atom.t * 'block Instr.t

val call1
  :  string
  -> ('a -> 'ret, 'ret) Fn.t
  -> 'a Atom.t
  -> 'ret Atom.t * 'block Instr.t

val call2
  :  string
  -> ('a -> 'b -> 'ret, 'ret) Fn.t
  -> 'a Atom.t
  -> 'b Atom.t
  -> 'ret Atom.t * 'block Instr.t

val call3
  :  string
  -> ('a -> 'b -> 'c -> 'ret, 'ret) Fn.t
  -> 'a Atom.t
  -> 'b Atom.t
  -> 'c Atom.t
  -> 'ret Atom.t * 'block Instr.t

val branch_to : int64 Atom.t -> if_true:string -> if_false:string -> 'a Instr.t
val jump_to : string -> 'a Instr.t
