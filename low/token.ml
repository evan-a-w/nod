open! Core

type t =
  | L_paren
  | R_paren
  | L_brace
  | R_brace
  | L_bracket
  | R_bracket
  | Minus
  | Plus
  | Star
  | Ampersand
  | Forward_slash
  | Percent
  | Equal
  | Arrow
  | Colon
  | Semi_colon
  | Comma
  | Dot
  | Keyword of string
  | Ident of string
  | String of string
  | Int of int
  | Float of float
  | Comment of string
[@@deriving sexp, compare, equal]

let is_comment = function
  | Comment _ -> true
  | _ -> false
;;

let keywords =
  [ "struct"
  ; "return"
  ; "if"
  ; "else"
  ; "while"
  ; "alloca"
  ; "alloc"
  ; "cast"
  ]
;;
