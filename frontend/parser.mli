open! Core
open! Import

type unprocessed_cfg =
  { instrs_by_label : (Type.t Typed_var.t, string) Ir.t Vec.t String.Map.t
  ; labels : string Vec.t
  }

type output = (Type.t Typed_var.t, unprocessed_cfg) Program.t [@@deriving sexp]

val parse_string : string -> (output, Nod_error.t) result
