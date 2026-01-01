open! Core
module Eir = Nod_core.Eir

module Ast = Ast
module Error = Error
module Lexer = Lexer
module Parser = Parser
module Token = Token

let parse_string = Parser.parse_string

let lower_string source =
  let open Result.Let_syntax in
  let%bind program = Parser.parse_string source in
  Lower.lower_program program
;;

let compile ?opt_flags source =
  let open Result.Let_syntax in
  let%bind eir = lower_string source in
  match Eir.compile ?opt_flags (Ok eir) with
  | Ok _ as ok -> ok
  | Error err -> Error (`Backend_error err)
;;
