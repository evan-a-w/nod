open! Core

type t =
  [ `Duplicate_label of string
  | `Expected_digit of char
  | `Unexpected_character of char
  | `Unexpected_end_of_input
  | `Unexpected_end_of_input
  | `Unexpected_eof_in_comment
  | `Unexpected_token of Token.t * Pos.t
  | `Unknown_instruction of string
  | `Unknown_type of string
  | `Unknown_variable of string
  | `Type_mismatch of string
  | `Choices of t list
  ]

let rec to_string : t -> string = function
  | `Duplicate_label s -> Printf.sprintf "Error: duplicate label '%s'\n" s
  | `Expected_digit c ->
    Printf.sprintf "Error: expected a digit but got '%c'\n" c
  | `Unexpected_character c ->
    Printf.sprintf "Error: unexpected character '%c'\n" c
  | `Unexpected_end_of_input ->
    Printf.sprintf "Error: unexpected end of input\n"
  | `Unexpected_eof_in_comment ->
    Printf.sprintf "Error: unexpected EOF in comment\n"
  | `Unexpected_token (tok, pos) ->
    Printf.sprintf
      "Error: unexpected token %s at %s\n"
      (Token.to_string tok)
      (Pos.to_string pos)
  | `Unknown_instruction s ->
    Printf.sprintf "Error: unknown instruction '%s'\n" s
  | `Unknown_type s ->
    Printf.sprintf "Error: unknown type '%s'\n" s
  | `Unknown_variable s ->
    Printf.sprintf "Error: unknown variable '%s'\n" s
  | `Type_mismatch s ->
    Printf.sprintf "Error: type mismatch: %s\n" s
  | `Choices [ error ] -> to_string error
  | `Choices l ->
    Printf.sprintf
      "Error: errors in choices `%s`\n"
      (String.concat (List.map l ~f:to_string) ~sep:", ")
;;
