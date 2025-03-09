open! Core

type t =
  | L_paren
  | R_paren
  | L_brace
  | R_brace
  | L_bracket
  | R_bracket
  | L_brace_percent
  | Percent_r_brace
  | Minus
  | Plus
  | Star
  | Forward_slash
  | Equal
  | Not_equal
  | Less
  | Less_equal
  | Greater
  | Greater_equal
  | Percent
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
  | Bool of bool
  | (* Will use the same lexer for formatting etc. so we can't lose info like this *)
    Comment of string
[@@deriving sexp, compare, equal]

let keywords = [ "return" ]
