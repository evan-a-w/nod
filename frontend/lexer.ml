open! Core
open! Import
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

let digit c =
  if Char.is_digit c
  then return (Char.to_int c - Char.to_int '0')
  else fail (`Expected_digit c)
;;

let lex_int c =
  let%bind n = digit c in
  let rec loop n =
    match%bind peek with
    | Some c when Char.is_digit c ->
      let%bind d = digit c in
      next >> loop ((n * 10) + d)
    | _ -> return n
  in
  loop n
;;

let lex_number c =
  let%bind n = lex_int c in
  match%bind peek with
  | Some '.' ->
    let%bind _ = next in
    let%bind f = lex_int '0' in
    return (Token.Float (Float.of_int n +. (Float.of_int f /. 10.0)))
  | _ -> return (Token.Int n)
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

let rec lex' () : (_, _, _) State.Result.t =
  let%bind pos = get >>| fun t -> t.pos in
  let rep token = add pos token >> lex' () in
  match%bind next with
  | Some c when Char.is_whitespace c -> lex' ()
  | Some '.' -> rep Token.Dot
  | Some '}' -> rep Token.R_brace
  | Some '[' -> rep Token.L_bracket
  | Some ']' -> rep Token.R_bracket
  | Some ':' -> rep Token.Colon
  | Some ';' -> rep Token.Semi_colon
  | Some ',' -> rep Token.Comma
  | Some '"' -> lex_string () >>= add pos >> lex' ()
  | Some '/' -> rep Token.Forward_slash
  | Some '*' -> rep Token.Star
  | Some '+' -> rep Token.Plus
  | Some '=' -> rep Token.Equal
  | Some '>' ->
    (match%bind peek with
     | Some '=' -> next >> rep Token.Greater_equal
     | _ -> rep Token.Greater)
  | Some '<' ->
    (match%bind peek with
     | Some '=' -> next >> rep Token.Less_equal
     | Some '>' -> next >> rep Token.Not_equal
     | _ -> rep Token.Less)
  | Some '-' ->
    (match%bind peek with
     | Some '>' -> next >> rep Token.Arrow
     | _ -> rep Token.Minus)
  | Some '(' ->
    (match%bind peek with
     | Some '*' -> next >> lex_comment () >>= rep
     | _ -> rep Token.L_paren)
  | Some ')' -> rep Token.R_paren
  | Some '{' ->
    (match%bind peek with
     | Some '%' -> next >> rep Token.L_brace_percent
     | _ -> rep Token.L_brace)
  | Some '%' ->
    (match%bind peek with
     | Some '}' -> next >> rep Token.Percent_r_brace
     | _ -> rep Token.Percent)
  | Some c when Char.is_digit c -> lex_number c >>= add pos >> lex' ()
  | Some c when Char.is_alpha c -> lex_ident c >>= add pos >> lex' ()
  | Some c -> fail (`Unexpected_character c)
  | None -> return ()

and lex_comment' () =
  let rep c =
    let%map l = lex_comment' () in
    c :: l
  in
  match%bind next with
  | Some '*' ->
    (match%bind peek with
     | Some ')' -> next >> return []
     | _ -> rep '*')
  | Some c -> rep c
  | None -> fail `Unexpected_eof_in_comment

and lex_comment () =
  let%map l = lex_comment' () in
  Token.Comment (String.of_char_list l)

and lex_string' () =
  let rep c =
    let%map l = lex_string' () in
    c :: l
  in
  match%bind next with
  | Some '"' -> return []
  | Some '\\' ->
    (match%bind next with
     | Some c -> rep c
     | None -> fail `Unexpected_eof_in_comment)
  | Some c -> rep c
  | None -> fail `Unexpected_eof_in_comment

and lex_string () =
  let%map l = lex_string' () in
  Token.String (String.of_char_list l)
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

let%expect_test "tokens" =
  let s = {|let x = 123 25.05
in x {} :  (* a
b c *) "hi there \""  |} in
  (match tokens ~file:"test" s with
   | Ok tokens -> print_s [%message (tokens : (Token.t * Pos.t) list)]
   | Error _ -> ());
  [%expect
    {|
    (tokens
     (((Ident let) ((line 0) (col 0) (file test)))
      ((Ident x) ((line 0) (col 4) (file test)))
      (Equal ((line 0) (col 6) (file test)))
      ((Int 123) ((line 0) (col 8) (file test)))
      ((Float 25.5) ((line 0) (col 12) (file test)))
      ((Ident in) ((line 1) (col 0) (file test)))
      ((Ident x) ((line 1) (col 3) (file test)))
      (L_brace ((line 1) (col 5) (file test)))
      (R_brace ((line 1) (col 6) (file test)))
      (Colon ((line 1) (col 8) (file test)))
      ((Comment  " a\
                \nb c ") ((line 1) (col 11) (file test)))
      ((String "hi there \"") ((line 2) (col 7) (file test)))))
    |}]
;;
