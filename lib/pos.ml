open! Core

type t =
  { line : int
  ; col : int
  ; file : string
  }
[@@deriving sexp]

let create ~file = { line = 0; col = 0; file }
let advance_line pos = { pos with line = pos.line + 1; col = 0 }
let advance_column pos = { pos with col = pos.col + 1 }
