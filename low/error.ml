open! Core
module Pos = Nod_common.Pos
module Nod_error = Nod_common.Nod_error

type t =
  [ `Unexpected_character of char
  | `Unexpected_end_of_input
  | `Unexpected_eof_in_comment
  | `Unexpected_token of Token.t * Pos.t
  | `Unknown_type of string
  | `Unknown_struct of string
  | `Unknown_field of string * string
  | `Unknown_variable of string
  | `Unknown_function of string
  | `Type_mismatch of string
  | `Invalid_lvalue of string
  | `Unsupported of string
  | `Backend_error of Nod_error.t
  | `Choices of t list
  ]

let rec to_string : t -> string = function
  | `Unexpected_character c -> sprintf "Error: unexpected character '%c'\n" c
  | `Unexpected_end_of_input -> "Error: unexpected end of input\n"
  | `Unexpected_eof_in_comment -> "Error: unexpected EOF in comment\n"
  | `Unexpected_token (tok, pos) ->
    sprintf
      "Error: unexpected token %s at %s\n"
      (Sexp.to_string (Token.sexp_of_t tok))
      (Pos.to_string pos)
  | `Unknown_type name -> sprintf "Error: unknown type '%s'\n" name
  | `Unknown_struct name -> sprintf "Error: unknown struct '%s'\n" name
  | `Unknown_field (struct_name, field) ->
    sprintf "Error: unknown field '%s' in struct '%s'\n" field struct_name
  | `Unknown_variable name -> sprintf "Error: unknown variable '%s'\n" name
  | `Unknown_function name -> sprintf "Error: unknown function '%s'\n" name
  | `Type_mismatch msg -> sprintf "Error: type mismatch: %s\n" msg
  | `Invalid_lvalue msg -> sprintf "Error: invalid lvalue: %s\n" msg
  | `Unsupported msg -> sprintf "Error: unsupported: %s\n" msg
  | `Backend_error err -> Nod_error.to_string err
  | `Choices [ err ] -> to_string err
  | `Choices errs ->
    sprintf
      "Error: errors in choices `%s`\n"
      (String.concat (List.map errs ~f:to_string) ~sep:", ")
;;
