open! Core
open! Nod_core

let compile ?opt_flags s =
  Frontend.Parser.parse_string s |> Eir.compile ?opt_flags
;;
