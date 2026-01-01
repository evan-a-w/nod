open! Core
module Pos = Nod_common.Pos
module State = Nod_frontend.State
open State.Result
open Let_syntax

type t =
  { pos : Pos.t
  ; characters : char Sequence.t
  ; res : (Token.t * Pos.t) list
  }
[@@deriving fields]

let peek : (Char.t option, _, _) State.Result.t =
  let%map t = get in
  match Sequence.next t.characters with
  | Some (c, _) -> Some c
  | None -> None
;;

let next : (Char.t option, _, _) State.Result.t =
  let%bind t = get in
  match Sequence.next t.characters with
  | Some (c, characters) ->
    let%bind () =
      match c with
      | '\n' -> set { t with pos = Pos.advance_line t.pos }
      | _ -> set { t with pos = Pos.advance_column t.pos }
    in
    let%bind t = get in
    let%map () = set { t with characters } in
    Some c
  | None -> return None
;;

let add pos token =
  let%bind t = get in
  set { t with res = (token, pos) :: t.res }
;;

let rec lex_digits buf =
  match%bind peek with
  | Some c when Char.is_digit c ->
    let%bind _ = next in
    Buffer.add_char buf c;
    lex_digits buf
  | _ -> return ()
;;

let lex_number c =
  let buf = Buffer.create 16 in
  Buffer.add_char buf c;
  let%bind () = lex_digits buf in
  match%bind peek with
  | Some '.' ->
    let%bind _ = next in
    Buffer.add_char buf '.';
    let%bind () = lex_digits buf in
    let s = Buffer.contents buf in
    return (Token.Float (Float.of_string s))
  | _ ->
    let s = Buffer.contents buf in
    return (Token.Int (Int.of_string s))
;;

let extra_ident_chars = Char.Set.of_list [ '_' ]

let lex_word c =
  let rec loop acc =
    match%bind peek with
    | Some c
      when Char.is_alpha c || Char.is_digit c || Set.mem extra_ident_chars c ->
      let%bind _ = next in
      loop (c :: acc)
    | _ -> return (List.rev acc)
  in
  loop [ c ]
;;

let lex_ident c =
  let%map l = lex_word c in
  let s = String.of_char_list l in
  if List.mem Token.keywords s ~equal:String.equal
  then Token.Keyword s
  else Token.Ident s
;;

let rec lex_line_comment acc =
  match%bind next with
  | Some '\n' -> return (Token.Comment (String.of_char_list (List.rev acc)))
  | Some c -> lex_line_comment (c :: acc)
  | None -> return (Token.Comment (String.of_char_list (List.rev acc)))
;;

let rec lex_block_comment acc =
  match%bind next with
  | Some '*' ->
    (match%bind peek with
     | Some '/' ->
       let%map _ = next in
       Token.Comment (String.of_char_list (List.rev acc))
     | _ -> lex_block_comment ('*' :: acc))
  | Some c -> lex_block_comment (c :: acc)
  | None -> fail `Unexpected_eof_in_comment
;;

let rec lex' () : (_, _, _) State.Result.t =
  let%bind pos = get >>| fun t -> t.pos in
  let rep token = add pos token >> lex' () in
  match%bind next with
  | Some c when Char.is_whitespace c -> lex' ()
  | Some '(' -> rep Token.L_paren
  | Some ')' -> rep Token.R_paren
  | Some '{' -> rep Token.L_brace
  | Some '}' -> rep Token.R_brace
  | Some '[' -> rep Token.L_bracket
  | Some ']' -> rep Token.R_bracket
  | Some ':' -> rep Token.Colon
  | Some ';' -> rep Token.Semi_colon
  | Some ',' -> rep Token.Comma
  | Some '.' -> rep Token.Dot
  | Some '&' -> rep Token.Ampersand
  | Some '*' -> rep Token.Star
  | Some '+' -> rep Token.Plus
  | Some '=' -> rep Token.Equal
  | Some '%' -> rep Token.Percent
  | Some '-' ->
    (match%bind peek with
     | Some '>' -> next >> rep Token.Arrow
     | _ -> rep Token.Minus)
  | Some '/' ->
    (match%bind peek with
     | Some '/' -> next >> lex_line_comment [] >>= rep
     | Some '*' -> next >> lex_block_comment [] >>= rep
     | _ -> rep Token.Forward_slash)
  | Some c when Char.is_digit c -> lex_number c >>= add pos >> lex' ()
  | Some c when Char.is_alpha c -> lex_ident c >>= add pos >> lex' ()
  | Some c -> fail (`Unexpected_character c)
  | None -> return ()
;;

let of_string ~file s =
  { pos = Pos.create ~file
  ; characters =
      Sequence.unfold ~init:0 ~f:(fun i ->
        if i < String.length s then Some (s.[i], i + 1) else None)
  ; res = []
  }
;;

let lex ~file s =
  let%bind () = set (of_string ~file s) in
  let%bind () = lex' () in
  let%bind t = get in
  return (List.rev t.res)
;;

let tokens ~file s =
  let open Result.Let_syntax in
  let t = of_string ~file s in
  let%map (), t = lex' () t in
  res t |> List.rev
;;
