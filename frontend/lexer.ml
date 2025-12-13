open! Core
open! Import
open State.Result
open Let_syntax

type t =
  { pos : Pos.t
  ; characters : char Sequence.t
  ; keywords : String.Set.t
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

let digit c = if Char.is_digit c then return () else fail (`Expected_digit c)

let is_hex_digit c =
  Char.is_digit c
  || Char.(c >= 'a' && c <= 'f')
  || Char.(c >= 'A' && c <= 'F')
;;

let lex_while buf ~f =
  let rec loop () =
    match%bind peek with
    | Some c when f c ->
      let%bind _ = next in
      Buffer.add_char buf c;
      loop ()
    | None | Some _ -> return ()
  in
  loop ()
;;

let lex_number first =
  let buf = Buffer.create 16 in
  Buffer.add_char buf first;
  match first with
  | '0' ->
    (match%bind peek with
     | Some ('x' | 'X' as c) ->
       let%bind _ = next in
       Buffer.add_char buf c;
       (match%bind peek with
        | Some c when is_hex_digit c ->
          let%bind () = lex_while buf ~f:is_hex_digit in
          let s = Buffer.contents buf in
          (match Int64.of_string_opt s with
           | Some i -> return (Token.Int i)
           | None -> fail (`Invalid_number_literal s))
        | Some c -> fail (`Unexpected_character c)
        | None -> fail `Unexpected_end_of_input)
     | _ ->
       let%bind () = lex_while buf ~f:Char.is_digit in
       let%bind is_float =
         match%bind peek with
         | Some '.' ->
           let%bind _ = next in
           Buffer.add_char buf '.';
           let%bind () = lex_while buf ~f:Char.is_digit in
           return true
         | None | Some _ -> return false
       in
       let%bind is_float =
         match%bind peek with
         | Some ('e' | 'E' as e) ->
           let%bind _ = next in
           Buffer.add_char buf e;
           let%bind () =
             match%bind peek with
             | Some (('+' | '-') as sign) ->
               let%bind _ = next in
               Buffer.add_char buf sign;
               return ()
             | None | Some _ -> return ()
           in
           (match%bind peek with
            | Some c ->
              let%bind () = digit c in
              let%bind () = lex_while buf ~f:Char.is_digit in
              return true
            | None -> fail `Unexpected_end_of_input)
         | None | Some _ -> return is_float
       in
       let s = Buffer.contents buf in
       if is_float
       then (
         match Float.of_string_opt s with
         | Some f -> return (Token.Float f)
         | None -> fail (`Invalid_number_literal s))
       else (
         match Int64.of_string_opt s with
         | Some i -> return (Token.Int i)
         | None -> fail (`Invalid_number_literal s)))
  | _ ->
    let%bind () = lex_while buf ~f:Char.is_digit in
    let%bind is_float =
      match%bind peek with
      | Some '.' ->
        let%bind _ = next in
        Buffer.add_char buf '.';
        let%bind () = lex_while buf ~f:Char.is_digit in
        return true
      | None | Some _ -> return false
    in
    let%bind is_float =
      match%bind peek with
      | Some ('e' | 'E' as e) ->
        let%bind _ = next in
        Buffer.add_char buf e;
        let%bind () =
          match%bind peek with
          | Some (('+' | '-') as sign) ->
            let%bind _ = next in
            Buffer.add_char buf sign;
            return ()
          | None | Some _ -> return ()
        in
        (match%bind peek with
         | Some c ->
           let%bind () = digit c in
           let%bind () = lex_while buf ~f:Char.is_digit in
           return true
         | None -> fail `Unexpected_end_of_input)
      | None | Some _ -> return is_float
    in
    let s = Buffer.contents buf in
    if is_float
    then (
      match Float.of_string_opt s with
      | Some f -> return (Token.Float f)
      | None -> fail (`Invalid_number_literal s))
    else (
      match Int64.of_string_opt s with
      | Some i -> return (Token.Int i)
      | None -> fail (`Invalid_number_literal s))
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
  let%bind l = lex_word c in
  let s = String.of_char_list l in
  let%map t = get in
  if Set.mem t.keywords s then Token.Keyword s else Token.Ident s
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
  | Some '/' ->
    (match%bind peek with
     | Some '/' -> next >> lex_line_comment () >>= rep
     | _ -> rep Token.Forward_slash)
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
     | Some '*' -> next >> lex_block_comment ~depth:1 () >>= rep
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
  | Some c when Char.is_alpha c || Char.equal c '_' ->
    lex_ident c >>= add pos >> lex' ()
  | Some c -> fail (`Unexpected_character c)
  | None -> return ()

and lex_line_comment' acc =
  match%bind peek with
  | None -> return (List.rev acc)
  | Some '\n' -> return (List.rev acc)
  | Some c ->
    let%bind _ = next in
    lex_line_comment' (c :: acc)

and lex_line_comment () =
  let%map l = lex_line_comment' [] in
  Token.Comment (String.of_char_list l)

and lex_block_comment' ~depth acc =
  match%bind next with
  | None -> fail `Unexpected_eof_in_comment
  | Some '(' ->
    (match%bind peek with
     | Some '*' ->
       let%bind _ = next in
       lex_block_comment' ~depth:(depth + 1) ('*' :: '(' :: acc)
     | None | Some _ -> lex_block_comment' ~depth ('(' :: acc))
  | Some '*' ->
    (match%bind peek with
     | Some ')' ->
       let%bind _ = next in
       if depth = 1
       then return acc
       else lex_block_comment' ~depth:(depth - 1) (')' :: '*' :: acc)
     | None | Some _ -> lex_block_comment' ~depth ('*' :: acc))
  | Some c -> lex_block_comment' ~depth (c :: acc)

and lex_block_comment ~depth () =
  let%map l = lex_block_comment' ~depth [] in
  Token.Comment (String.of_char_list (List.rev l))

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

let of_string ~file ~keywords s =
  { pos = Pos.create ~file
  ; characters =
      Sequence.unfold ~init:0 ~f:(fun i ->
        if i < String.length s then Some (s.[i], i + 1) else None)
  ; keywords = String.Set.of_list keywords
  ; res = []
  }
;;

let lex ?(keywords = Token.keywords) ~file s =
  let%bind () = set (of_string ~file ~keywords s) in
  let%bind () = lex' () in
  let%bind t = get in
  return (List.rev t.res)
;;

let tokens ?(keywords = Token.keywords) ~file s =
  let open Result.Let_syntax in
  let t = of_string ~file ~keywords s in
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
      ((Float 25.05) ((line 0) (col 12) (file test)))
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
