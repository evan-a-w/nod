open! Core
include State.Result

module Make (Token : Token_intf.S) = struct
  include Let_syntax

  type ('res, 'pos, 'state, 'err) parser =
    ('res, (Token.t * 'pos) list * 'state, 'err) t

  let peek () =
    match%map get with
    | [], _ -> None
    | x :: _, _ -> Some x
  ;;

  let peek' () =
    match%bind get with
    | [], _ -> fail `Unexpected_end_of_input
    | x :: _, _ -> return x
  ;;

  let get_pos () =
    match%bind get with
    | [], _ -> fail `Unexpected_end_of_input
    | (_, pos) :: _, _ -> return pos
  ;;

  let eof () =
    match%bind get with
    | [], _ -> return ()
    | (tok, pos) :: _, _ -> fail (`Unexpected_token (tok, pos))
  ;;

  let rec next () =
    match%bind get with
    | [], _ -> fail `Unexpected_end_of_input
    | (comment, _) :: xs, st when Token.is_comment comment ->
      set (xs, st) >> next ()
    | x :: xs, st -> set (xs, st) >> return x
  ;;

  let expect token =
    match%bind next () with
    | tok, pos when Token.equal tok token -> return pos
    | tok, pos -> fail (`Unexpected_token (tok, pos))
  ;;

  let get_state () =
    let%map _, st = get in
    st
  ;;

  let set_state st =
    let%bind curr, _ = get in
    set (curr, st)
  ;;

  let rec skip n = if n = 0 then return () else next () >> skip (n - 1)

  let rec skip_many_tok tok : (_, _, _) t =
    match%bind peek () with
    | Some (tok', _) when Token.equal tok' tok -> next () >> skip_many_tok tok
    | None | Some _ -> return ()
  ;;

  let take_until_inc f =
    let rec take_until' f acc =
      match%bind peek () with
      | None -> return acc
      | Some (tok, _pos) when f tok -> return acc
      | Some (tok, _pos) -> next () >> take_until' f (tok :: acc)
    in
    let%map l = take_until' f [] in
    List.rev l
  ;;

  let take_until_token_inc tok = take_until_inc (Token.equal tok)

  let rec while_ f =
    match%bind peek () with
    | None -> return ()
    | Some (tok, _pos) when f tok -> next () >> while_ f
    | Some _ -> return ()
  ;;

  let rec until f =
    match%bind peek () with
    | None -> return ()
    | Some (tok, _pos) when f tok -> return ()
    | Some _ -> next () >> until f
  ;;

  let until_inc f = until f >> skip 1
  let until_inc_token tok = until_inc (Token.equal tok)

  let delimited0
    ~(delimiter : (_, 'pos, 'state, 'err) parser)
    (p : ('res, 'pos, 'state, 'err) parser)
    state
    =
    let rec loop acc state =
      match p state with
      | Error _ -> Ok (acc, state)
      | Ok (x, state) ->
        (match delimiter state with
         | Error _ -> Ok (List.rev (x :: acc), state)
         | Ok (_, state) -> loop (x :: acc) state)
    in
    loop [] state
  ;;

  let many p state =
    let rec go acc state =
      match p state with
      | Error _ -> acc, state
      | Ok (x, state') -> go (x :: acc) state'
    in
    let res, state' = go [] state in
    Ok (List.rev res, state')
  ;;

  let exhaust p state =
    match many p state with
    | Error _ as e -> e
    | Ok (_, ([], _)) as r -> r
    | Ok (_, (a :: _, _)) -> Error (`Unexpected_token a)
  ;;

  let choice
    :  ('res, 'pos, 'state, 'err) parser list
    -> ('res, 'pos, 'state, 'err) parser
    =
    fun ps state ->
    List.fold ps ~init:(Error []) ~f:(fun acc p ->
      match acc with
      | Ok _ -> acc
      | Error l ->
        (match p state with
         | Error e -> Error (e :: l)
         | Ok _ as res -> res))
    |> Result.map_error ~f:(fun l -> `Choices l)
  ;;

  let optional a state =
    match a state with
    | Ok (res, state') -> Ok (Some res, state')
    | Error _ -> Ok (None, state)
  ;;

  let ( <|> ) a b state =
    match a state with
    | Ok _ as r -> r
    | Error e ->
      (match b state with
       | Ok _ as r -> r
       | Error e' -> Error (`Choices [ e; e' ]))
  ;;

  let maybe_surrounded ~before ~after p =
    let a =
      let%bind _ = before in
      let%bind res = p in
      let%map _ = after in
      res
    in
    let b = p in
    a <|> b
  ;;
end
