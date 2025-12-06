open! Core

module type S = sig
  type t

  val create_with_formula : int array array -> t

  val solve
    :  ?assumptions:int array
    -> t
    -> [ `Sat of int array | `Unsat of int array ]
end
