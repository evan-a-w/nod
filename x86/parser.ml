open! Core
open Parser_core
module Parser_comb = Parser_comb.Make (Token)
open Parser_comb

let ident () =
  match%bind next () with
  | Token.Ident i, (_ : Pos.t) -> return i
  | tok, pos -> fail (`Unexpected_token (tok, pos))
;;

let var () =
  let%bind (_ : Pos.t) = expect Token.Percent in
  ident ()
;;

let lit () =
  match%bind next () with
  | Token.Int i, _ -> return i
  | tok, pos -> fail (`Unexpected_token (tok, pos))
;;
