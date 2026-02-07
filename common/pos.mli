open! Core

type t =
  { line : int
  ; col : int
  ; file : string
  }
[@@deriving sexp]

val create : file:string -> t
val advance_line : t -> t
val advance_column : t -> t
val to_string : t -> string
