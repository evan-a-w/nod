open! Core

type t =
  | Instruction of Instruction.t
  | Label of Label.t
  | Directive of
      (* won't use for a while probably *)
      (Directive.t * Token.t list)
[@@deriving sexp, compare, hash]
