open! Core
open! Dsl_import

val compile_program_exn : Eir.input -> Nod_core.Block.t Nod_core.Program.t

type int64
type float64
type ptr

module Type_repr : sig
  [%%embed
    let max_tuple_arity = 25 in
    let tuple_constructor arity =
      let type_var index =
        if index >= 26 then failwith "tuple arity too large";
        Char.of_int_exn (Char.to_int 'a' + index)
      in
      let args =
        List.init arity ~f:(fun i -> sprintf "'%c t" (type_var i))
        |> String.concat ~sep:" * "
      in
      let tuple =
        List.init arity ~f:(fun i -> sprintf "'%c" (type_var i))
        |> String.concat ~sep:" * "
      in
      sprintf " | Tuple%d : %s -> (%s) t" arity args tuple
    in
    let tuples =
      List.init (max_tuple_arity - 2) ~f:(fun i -> tuple_constructor (i + 2))
      |> String.concat ~sep:""
    in
    sprintf
      "type _ t = | Int64 : int64 t | Float64 : float64 t | Ptr : ptr t %s"
      tuples]

  val type_ : 'a t -> Type.t
end

module Atom : sig
  type _ t

  val type_ : 'a t -> Type.t
  val lit_or_var : _ t -> Ir.Lit_or_var.t
  val var : _ t -> Var.t option
end

module Instr : sig
  type 'ret t

  val ir : string Ir0.t -> 'ret t

  val process
    :  ?root_name:string
    -> 'ret t list
    -> (Eir.raw_block, Nod_error.t) Result.t
end

module Field : sig
  type ('record, 'field) t =
    { repr : 'field Type_repr.t
    (* ; load_field : 'ret. string -> ptr Atom.t -> 'field Atom.t * 'ret Instr.t *)
    (* ; store_field : 'ret. string -> ptr Atom.t -> 'field Atom.t * 'ret Instr.t *)
    }
end

module Fn : sig
  type ('fn, 'ret) t

  val name : ('fn, 'ret) t -> string

  val function_
    :  ('fn, 'ret) t
    -> (Eir.raw_block Function0.t', Nod_error.t) Result.t

  module Unnamed : sig
    type ('fn, 'ret) t

    val const : 'ret Type_repr.t -> 'ret Instr.t list -> ('ret, 'ret) t
    val const_with_return : 'ret Atom.t -> 'ret Instr.t list -> ('ret, 'ret) t

    val with_arg
      :  ('fn, 'ret) t
      -> 'a Type_repr.t
      -> Var.t
      -> ('a -> 'fn, 'ret) t

    val args : ('fn, 'ret) t -> Var.t list
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

val program : functions:Fn.Packed.t list -> globals:Global.t list -> Eir.input

(** builder functions *)

val return : 'a Atom.t -> 'a Instr.t
val label : string -> 'ret Instr.t
val lit : Int64.t -> int64 Atom.t
val var : Var.t -> 'a Atom.t
val global : Global.t -> ptr Atom.t
val mov : string -> 'a Atom.t -> 'a Atom.t * 'ret Instr.t
val add : string -> int64 Atom.t -> int64 Atom.t -> int64 Atom.t * 'ret Instr.t
val sub : string -> int64 Atom.t -> int64 Atom.t -> int64 Atom.t * 'ret Instr.t
val mul : string -> int64 Atom.t -> int64 Atom.t -> int64 Atom.t * 'ret Instr.t
val div : string -> int64 Atom.t -> int64 Atom.t -> int64 Atom.t * 'ret Instr.t
val mod_ : string -> int64 Atom.t -> int64 Atom.t -> int64 Atom.t * 'ret Instr.t
val and_ : string -> int64 Atom.t -> int64 Atom.t -> int64 Atom.t * 'ret Instr.t
val or_ : string -> int64 Atom.t -> int64 Atom.t -> int64 Atom.t * 'ret Instr.t
val ptr_add : string -> ptr Atom.t -> int64 Atom.t -> ptr Atom.t * 'ret Instr.t
val ptr_sub : string -> ptr Atom.t -> int64 Atom.t -> ptr Atom.t * 'ret Instr.t
val ptr_diff : string -> ptr Atom.t -> ptr Atom.t -> int64 Atom.t * 'ret Instr.t

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

val load : string -> ptr Atom.t -> int64 Atom.t * 'ret Instr.t
val load_ptr : string -> ptr Atom.t -> ptr Atom.t * 'ret Instr.t
val load_f64 : string -> ptr Atom.t -> float64 Atom.t * 'ret Instr.t
val store : 'a Atom.t -> ptr Atom.t -> 'ret Instr.t
val load_addr : string -> ptr Atom.t -> int -> int64 Atom.t * 'ret Instr.t
val load_addr_ptr : string -> ptr Atom.t -> int -> ptr Atom.t * 'ret Instr.t
val load_addr_f64 : string -> ptr Atom.t -> int -> float64 Atom.t * 'ret Instr.t
val store_addr : 'a Atom.t -> ptr Atom.t -> int -> 'ret Instr.t
val alloca : string -> int64 Atom.t -> ptr Atom.t * 'ret Instr.t
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

val branch_to : int64 Atom.t -> if_true:string -> if_false:string -> 'a Instr.t
val jump_to : string -> 'a Instr.t
