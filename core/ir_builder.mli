open! Core

module Label : sig
  type t

  val block : t -> Block.t
  val name : t -> string
end

module Type_ast : sig
  type t =
    | Atom of string
    | Ptr of t
    | Tuple of t list
end

val type_of_ast : Type_ast.t -> Type.t

type t

val create_block : ?entry:string -> unit -> t
val create_function : unit -> t
val enter_label : t -> name:string -> Label.t
val emit : t -> Block.t Ir0.t -> unit
val emit_many : t -> Block.t Ir0.t list -> unit
val goto : t -> Label.t -> args:Var.t list -> unit

val branch
  :  t
  -> cond:Ir.Lit_or_var.t
  -> if_true:Label.t
  -> if_false:Label.t
  -> args_true:Var.t list
  -> args_false:Var.t list
  -> unit

val return : t -> Ir.Lit_or_var.t -> unit
val unreachable : t -> unit
val new_var : t -> name:string -> type_:Type.t -> Var.t
val add_arg : t -> name:string -> type_:Type.t -> Var.t
val finish_block : t -> Block.t
val finish_function : t -> name:string -> Function.t
val current_block : t -> Block.t
