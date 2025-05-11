open! Core
include State.Result

module Make (Token : Token_intf.S) = struct
  include Let_syntax

  let peek () =
    match%map get with
    | [], _ -> None
    | x :: _, _ -> Some x
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

  let optional token =
    match%bind peek () with
    | Some (tok, pos) when Token.equal tok token ->
      next () >> return (Some (tok, pos))
    | Some (_, _) | None -> return None
  ;;

  let get_state () =
    let%map _, st = get in
    st
  ;;

  let set_state st =
    let%bind curr, _ = get in
    set (curr, st)
  ;;

  let delimited1 ~delimiter p =
    let%bind first = p in
    let rec loop acc =
      match%bind delimiter with
      | None -> return (List.rev acc)
      | Some _ ->
        let%bind x = p in
        loop (x :: acc)
    in
    loop [ first ]
  ;;
end
