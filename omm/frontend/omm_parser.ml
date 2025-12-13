open! Core
open! Import
module Parser_comb = Nod_frontend.Parser_comb.Make (Token)
open Parser_comb

module Cst = Omm_cst

type output = Cst.program [@@deriving sexp]

module State = struct
  type t = unit

  let create () = ()
end

let keywords =
  [ "type"
  ; "struct"
  ; "external"
  ; "let"
  ; "if"
  ; "then"
  ; "else"
  ; "while"
  ; "do"
  ; "done"
  ; "begin"
  ; "end"
  ; "return"
  ]
;;

let located pos value = { Cst.Located.pos = pos; value }

let peek_non_comment () =
  let%map tokens, (_ : State.t) = get in
  let rec go = function
    | [] -> None
    | (tok, pos) :: rest -> if Token.is_comment tok then go rest else Some (tok, pos)
  in
  go tokens
;;

let peek2_non_comment () =
  let%map tokens, (_ : State.t) = get in
  let rec go tokens acc =
    match tokens with
    | [] -> List.rev acc
    | (tok, pos) :: rest ->
      if Token.is_comment tok
      then go rest acc
      else (
        match acc with
        | [ _; _ ] -> List.rev acc
        | _ -> go rest ((tok, pos) :: acc))
  in
  go tokens []
;;

let ident () =
  match%bind next () with
  | Token.Ident s, pos -> return (s, pos)
  | tok, pos -> fail (`Unexpected_token (tok, pos))
;;

let lower_ident () =
  let%bind s, pos = ident () in
  match String.to_list s with
  | [] -> fail (`Unexpected_token (Token.Ident s, pos))
  | '_' :: [] -> return (s, pos)
  | c :: _ when Char.is_lowercase c -> return (s, pos)
  | _ -> fail (`Unexpected_token (Token.Ident s, pos))
;;

let string_lit () =
  match%bind next () with
  | Token.String s, pos -> return (s, pos)
  | tok, pos -> fail (`Unexpected_token (tok, pos))
;;

let int_lit () =
  match%bind next () with
  | Token.Int i, pos -> return (i, pos)
  | tok, pos -> fail (`Unexpected_token (tok, pos))
;;

let float_lit () =
  match%bind next () with
  | Token.Float f, pos -> return (f, pos)
  | tok, pos -> fail (`Unexpected_token (tok, pos))
;;

let rec ty () =
  let%bind base = ty_atom () in
  let rec loop t =
    match%bind peek_non_comment () with
    | Some (Token.Ident "ptr", _) ->
      let%bind _ = next () in
      loop (located t.Cst.Located.pos (Cst.Ptr t))
    | None | Some _ -> return t
  in
  loop base

and ty_atom () =
  let%bind pos = get_pos () in
  match%bind next () with
  | Token.Ident "i64", _ -> return (located pos Cst.I64)
  | Token.Ident "f64", _ -> return (located pos Cst.F64)
  | Token.Ident "unit", _ -> return (located pos Cst.Unit)
  | Token.Ident name, _ ->
    (* Type names are lowercase identifiers; reject uppercase identifiers. *)
    (match String.to_list name with
     | c :: _ when Char.is_uppercase c -> fail (`Unexpected_token (Token.Ident name, pos))
     | _ -> return (located pos (Cst.Named name)))
  | tok, pos -> fail (`Unexpected_token (tok, pos))
;;

let param () =
  let%bind name, (_ : Pos.t) = lower_ident () in
  let%bind (_ : Pos.t) = expect Token.Colon in
  let%map ty = ty () in
  ({ Cst.name; ty } : Cst.param)
;;

let field () =
  let%bind name, (_ : Pos.t) = lower_ident () in
  let%bind (_ : Pos.t) = expect Token.Colon in
  let%bind ty = ty () in
  let%map (_ : Pos.t) = expect Token.Semi_colon in
  ({ Cst.name; ty } : Cst.field)
;;

let looks_like_type_args_and_call () =
  let%map tokens, (_ : State.t) = get in
  let rec skip_comments = function
    | [] -> []
    | (tok, _) :: rest when Token.is_comment tok -> skip_comments rest
    | rest -> rest
  in
  let tokens = skip_comments tokens in
  match tokens with
  | (Token.Less, _) :: rest ->
    let rec find_greater = function
      | [] -> None
      | (tok, _) :: rest when Token.is_comment tok -> find_greater rest
      | (Token.Greater, _) :: rest -> Some rest
      | _ :: rest -> find_greater rest
    in
    (match find_greater rest with
     | None -> false
     | Some rest ->
       (match skip_comments rest with
        | (Token.L_paren, _) :: _ -> true
        | _ -> false))
  | _ -> false
;;

let type_args () =
  let%bind (_ : Pos.t) = expect Token.Less in
  let%bind tys = delimited0 ~delimiter:(expect Token.Comma) (ty ()) in
  let%bind (_ : Pos.t) = expect Token.Greater in
  return tys
;;

let rec expr () =
  match%bind peek_non_comment () with
  | Some (Token.Keyword "if", _) -> if_expr ()
  | None | Some _ -> expr_cmp ()

and if_expr () =
  let%bind pos = get_pos () in
  let%bind (_ : Pos.t) = expect (Token.Keyword "if") in
  let%bind cond = expr () in
  let%bind (_ : Pos.t) = expect (Token.Keyword "then") in
  let%bind then_ = expr () in
  let%bind (_ : Pos.t) = expect (Token.Keyword "else") in
  let%map else_ = expr () in
  located pos (Cst.If { cond; then_; else_ })

and expr_cmp () =
  let%bind lhs = expr_bit_or () in
  let rec loop lhs =
    match%bind peek_non_comment () with
    | Some (Token.Equal, _) ->
      let%bind _ = next () in
      let%bind rhs = expr_bit_or () in
      loop (located lhs.Cst.Located.pos (Cst.Binop { op = Eq; lhs; rhs }))
    | Some (Token.Not_equal, _) ->
      let%bind _ = next () in
      let%bind rhs = expr_bit_or () in
      loop (located lhs.Cst.Located.pos (Cst.Binop { op = Ne; lhs; rhs }))
    | Some (Token.Less, _) ->
      let%bind _ = next () in
      let%bind rhs = expr_bit_or () in
      loop (located lhs.Cst.Located.pos (Cst.Binop { op = Lt; lhs; rhs }))
    | Some (Token.Less_equal, _) ->
      let%bind _ = next () in
      let%bind rhs = expr_bit_or () in
      loop (located lhs.Cst.Located.pos (Cst.Binop { op = Le; lhs; rhs }))
    | Some (Token.Greater, _) ->
      let%bind _ = next () in
      let%bind rhs = expr_bit_or () in
      loop (located lhs.Cst.Located.pos (Cst.Binop { op = Gt; lhs; rhs }))
    | Some (Token.Greater_equal, _) ->
      let%bind _ = next () in
      let%bind rhs = expr_bit_or () in
      loop (located lhs.Cst.Located.pos (Cst.Binop { op = Ge; lhs; rhs }))
    | None | Some _ -> return lhs
  in
  loop lhs

and expr_bit_or () =
  let%bind lhs = expr_bit_xor () in
  let rec loop lhs =
    match%bind peek_non_comment () with
    | Some (Token.Ident "lor", _) ->
      let%bind _ = next () in
      let%bind rhs = expr_bit_xor () in
      loop (located lhs.Cst.Located.pos (Cst.Binop { op = Lor; lhs; rhs }))
    | None | Some _ -> return lhs
  in
  loop lhs

and expr_bit_xor () =
  let%bind lhs = expr_bit_and () in
  let rec loop lhs =
    match%bind peek_non_comment () with
    | Some (Token.Ident "lxor", _) ->
      let%bind _ = next () in
      let%bind rhs = expr_bit_and () in
      loop (located lhs.Cst.Located.pos (Cst.Binop { op = Lxor; lhs; rhs }))
    | None | Some _ -> return lhs
  in
  loop lhs

and expr_bit_and () =
  let%bind lhs = expr_shift () in
  let rec loop lhs =
    match%bind peek_non_comment () with
    | Some (Token.Ident "land", _) ->
      let%bind _ = next () in
      let%bind rhs = expr_shift () in
      loop (located lhs.Cst.Located.pos (Cst.Binop { op = Land; lhs; rhs }))
    | None | Some _ -> return lhs
  in
  loop lhs

and expr_shift () =
  let%bind lhs = expr_add () in
  let rec loop lhs =
    match%bind peek_non_comment () with
    | Some (Token.Ident "lsl", _) ->
      let%bind _ = next () in
      let%bind rhs = expr_add () in
      loop (located lhs.Cst.Located.pos (Cst.Binop { op = Lsl; lhs; rhs }))
    | Some (Token.Ident "lsr", _) ->
      let%bind _ = next () in
      let%bind rhs = expr_add () in
      loop (located lhs.Cst.Located.pos (Cst.Binop { op = Lsr; lhs; rhs }))
    | Some (Token.Ident "asr", _) ->
      let%bind _ = next () in
      let%bind rhs = expr_add () in
      loop (located lhs.Cst.Located.pos (Cst.Binop { op = Asr; lhs; rhs }))
    | None | Some _ -> return lhs
  in
  loop lhs

and expr_add () =
  let%bind lhs = expr_mul () in
  let rec loop lhs =
    match%bind peek_non_comment () with
    | Some (Token.Plus, _) ->
      let%bind _ = next () in
      let%bind rhs = expr_mul () in
      loop (located lhs.Cst.Located.pos (Cst.Binop { op = Add; lhs; rhs }))
    | Some (Token.Minus, _) ->
      let%bind _ = next () in
      let%bind rhs = expr_mul () in
      loop (located lhs.Cst.Located.pos (Cst.Binop { op = Sub; lhs; rhs }))
    | None | Some _ -> return lhs
  in
  loop lhs

and expr_mul () =
  let%bind lhs = expr_unary () in
  let rec loop lhs =
    match%bind peek_non_comment () with
    | Some (Token.Star, _) ->
      let%bind _ = next () in
      let%bind rhs = expr_unary () in
      loop (located lhs.Cst.Located.pos (Cst.Binop { op = Mul; lhs; rhs }))
    | Some (Token.Forward_slash, _) ->
      let%bind _ = next () in
      let%bind rhs = expr_unary () in
      loop (located lhs.Cst.Located.pos (Cst.Binop { op = Div; lhs; rhs }))
    | Some (Token.Percent, _) ->
      let%bind _ = next () in
      let%bind rhs = expr_unary () in
      loop (located lhs.Cst.Located.pos (Cst.Binop { op = Mod; lhs; rhs }))
    | None | Some _ -> return lhs
  in
  loop lhs

and expr_unary () =
  match%bind peek_non_comment () with
  | Some (Token.Minus, _) ->
    let%bind pos = get_pos () in
    let%bind _ = next () in
    let%map arg = expr_unary () in
    located pos (Cst.Unop { op = Neg; arg })
  | None | Some _ -> expr_postfix ()

and expr_postfix () =
  let%bind base = expr_atom () in
  let rec loop base ~pending_type_args =
    match%bind peek_non_comment () with
    | Some (Token.Dot, _) ->
      let%bind _ = next () in
      let%bind field, (_ : Pos.t) = lower_ident () in
      loop
        (located base.Cst.Located.pos (Cst.Field { base; field }))
        ~pending_type_args:[]
    | Some (Token.Arrow, _) ->
      let%bind _ = next () in
      let%bind field, (_ : Pos.t) = lower_ident () in
      loop
        (located base.Cst.Located.pos (Cst.Arrow_field { base; field }))
        ~pending_type_args:[]
    | Some (Token.L_bracket, _) ->
      let%bind _ = next () in
      let%bind index = expr () in
      let%bind (_ : Pos.t) = expect Token.R_bracket in
      loop
        (located base.Cst.Located.pos (Cst.Index { base; index }))
        ~pending_type_args:[]
    | Some (Token.Less, _) ->
      (match base.Cst.Located.value with
       | Cst.Var _ ->
         let%bind ok = looks_like_type_args_and_call () in
         if ok
         then (
           let%bind tys = type_args () in
           loop base ~pending_type_args:tys)
         else return base
       | _ -> return base)
    | Some (Token.L_paren, _) ->
      let%bind args = call_args () in
      loop
        (located
           base.Cst.Located.pos
           (Cst.Call { callee = base; type_args = pending_type_args; args }))
        ~pending_type_args:[]
    | None | Some _ -> return base
  in
  loop base ~pending_type_args:[]

and call_args () =
  let%bind (_ : Pos.t) = expect Token.L_paren in
  let%bind args = delimited0 ~delimiter:(expect Token.Comma) (call_arg ()) in
  let%bind (_ : Pos.t) = expect Token.R_paren in
  return args

and call_arg () =
  match%bind peek2_non_comment () with
  | (Token.Ident "field", _) :: (Token.Equal, _) :: _ ->
    let%bind _field, (_ : Pos.t) = ident () in
    let%bind (_ : Pos.t) = expect Token.Equal in
    let%map field, (_ : Pos.t) = lower_ident () in
    Cst.Named_field { field }
  | _ ->
    let%map e = expr () in
    Cst.Expr e

and expr_atom () =
  let%bind pos = get_pos () in
  match%bind peek_non_comment () with
  | Some (Token.Int _, _) ->
    let%map i, (_ : Pos.t) = int_lit () in
    located pos (Cst.Int i)
  | Some (Token.Float _, _) ->
    let%map f, (_ : Pos.t) = float_lit () in
    located pos (Cst.Float f)
  | Some (Token.L_paren, _) ->
    let%bind (_ : Pos.t) = expect Token.L_paren in
    (match%bind peek_non_comment () with
     | Some (Token.R_paren, _) ->
       let%map (_ : Pos.t) = expect Token.R_paren in
       located pos Cst.Unit_lit
     | _ ->
       let%bind e = expr () in
       let%bind (_ : Pos.t) = expect Token.R_paren in
       return (located pos (Cst.Paren e)))
  | Some (Token.Ident _, _) ->
    let%bind name, (_ : Pos.t) = ident () in
    (* Reject uppercase identifiers in expression positions. *)
    let%bind () =
      match String.to_list name with
      | c :: _ when Char.is_uppercase c -> fail (`Unexpected_token (Token.Ident name, pos))
      | _ -> return ()
    in
    (match%bind peek_non_comment () with
     | Some (Token.L_brace, _) ->
       let%bind fields = struct_fields expr in
       return (located pos (Cst.Struct_lit { ty_name = name; fields }))
     | None | Some _ -> return (located pos (Cst.Var name)))
  | Some (tok, pos) -> fail (`Unexpected_token (tok, pos))
  | None -> fail `Unexpected_end_of_input

and struct_fields expr_parser =
  let%bind (_ : Pos.t) = expect Token.L_brace in
  let rec loop acc =
    match%bind peek_non_comment () with
    | Some (Token.R_brace, _) ->
      let%bind (_ : Pos.t) = expect Token.R_brace in
      return (List.rev acc)
    | _ ->
      let%bind field, (_ : Pos.t) = lower_ident () in
      let%bind (_ : Pos.t) = expect Token.Equal in
      let%bind value = expr_parser () in
      let%bind () =
        match%bind peek_non_comment () with
        | Some (Token.Semi_colon, _) ->
          let%map (_ : Token.t * Pos.t) = next () in
          ()
        | Some (Token.R_brace, _) -> return ()
        | Some (tok, pos) -> fail (`Unexpected_token (tok, pos))
        | None -> fail `Unexpected_end_of_input
      in
      loop ((field, value) :: acc)
  in
  loop []
;;

let rec top_expr () =
  let%bind pos = get_pos () in
  match%bind peek_non_comment () with
  | Some (Token.Int _, _) ->
    let%map i, (_ : Pos.t) = int_lit () in
    located pos (Cst.Top_int i)
  | Some (Token.Float _, _) ->
    let%map f, (_ : Pos.t) = float_lit () in
    located pos (Cst.Top_float f)
  | Some (Token.L_paren, _) ->
    let%bind (_ : Pos.t) = expect Token.L_paren in
    let%bind (_ : Pos.t) = expect Token.R_paren in
    return (located pos Cst.Top_unit)
  | Some (Token.Ident _, _) ->
    let%bind name, (_ : Pos.t) = ident () in
    let%bind () =
      match String.to_list name with
      | c :: _ when Char.is_uppercase c -> fail (`Unexpected_token (Token.Ident name, pos))
      | _ -> return ()
    in
    (match%bind peek_non_comment () with
     | Some (Token.L_brace, _) ->
       let%bind fields = top_struct_fields () in
       return (located pos (Cst.Top_struct { ty_name = name; fields }))
     | None | Some _ -> return (located pos (Cst.Top_var name)))
  | Some (tok, pos) -> fail (`Unexpected_token (tok, pos))
  | None -> fail `Unexpected_end_of_input

and top_struct_fields () =
  let%bind (_ : Pos.t) = expect Token.L_brace in
  let rec loop acc =
    match%bind peek_non_comment () with
    | Some (Token.R_brace, _) ->
      let%bind (_ : Pos.t) = expect Token.R_brace in
      return (List.rev acc)
    | _ ->
      let%bind field, (_ : Pos.t) = lower_ident () in
      let%bind (_ : Pos.t) = expect Token.Equal in
      let%bind value = top_expr () in
      let%bind () =
        match%bind peek_non_comment () with
        | Some (Token.Semi_colon, _) ->
          let%map (_ : Token.t * Pos.t) = next () in
          ()
        | Some (Token.R_brace, _) -> return ()
        | Some (tok, pos) -> fail (`Unexpected_token (tok, pos))
        | None -> fail `Unexpected_end_of_input
      in
      loop ((field, value) :: acc)
  in
  loop []
;;

let rec stmt () =
  let%bind pos = get_pos () in
  match%bind peek_non_comment () with
  | Some (Token.Keyword "let", _) -> let_stmt ~pos ()
  | Some (Token.Keyword "if", _) -> if_stmt ~pos ()
  | Some (Token.Keyword "while", _) -> while_stmt ~pos ()
  | Some (Token.Keyword "return", _) -> return_stmt ~pos ()
  | None | Some _ ->
    let%bind e = expr () in
    let%bind (_ : Pos.t) = expect Token.Semi_colon in
    return (located pos (Cst.Expr_stmt e))

and let_stmt ~pos () =
  let%bind (_ : Pos.t) = expect (Token.Keyword "let") in
  let%bind name, (_ : Pos.t) = lower_ident () in
  let%bind (_ : Pos.t) = expect Token.Colon in
  let%bind ty = ty () in
  let%bind (_ : Pos.t) = expect Token.Equal in
  let%bind expr = expr () in
  let%bind (_ : Pos.t) = expect Token.Semi_colon in
  return (located pos (Cst.Let { name; ty; expr }))

and if_stmt ~pos () =
  let%bind (_ : Pos.t) = expect (Token.Keyword "if") in
  let%bind cond = expr () in
  let%bind (_ : Pos.t) = expect (Token.Keyword "then") in
  let%bind then_ = block () in
  let%bind (_ : Pos.t) = expect (Token.Keyword "else") in
  let%bind else_ = block () in
  let%bind (_ : Pos.t) = expect Token.Semi_colon in
  return (located pos (Cst.If_stmt { cond; then_; else_ }))

and while_stmt ~pos () =
  let%bind (_ : Pos.t) = expect (Token.Keyword "while") in
  let%bind cond = expr () in
  let%bind (_ : Pos.t) = expect (Token.Keyword "do") in
  let%bind body = block () in
  let%bind (_ : Pos.t) = expect (Token.Keyword "done") in
  let%bind (_ : Pos.t) = expect Token.Semi_colon in
  return (located pos (Cst.While { cond; body }))

and return_stmt ~pos () =
  let%bind (_ : Pos.t) = expect (Token.Keyword "return") in
  let%bind e = expr () in
  let%bind (_ : Pos.t) = expect Token.Semi_colon in
  return (located pos (Cst.Return e))

and block () =
  let%bind pos = get_pos () in
  let%bind (_ : Pos.t) = expect (Token.Keyword "begin") in
  let rec loop acc =
    match%bind peek_non_comment () with
    | Some (Token.Keyword "end", _) ->
      let%bind (_ : Pos.t) = expect (Token.Keyword "end") in
      return (located pos { Cst.stmts = List.rev acc })
    | None -> fail `Unexpected_end_of_input
    | Some _ ->
      let%bind s = stmt () in
      loop (s :: acc)
  in
  loop []
;;

let type_def () =
  let%bind pos = get_pos () in
  let%bind (_ : Pos.t) = expect (Token.Keyword "type") in
  let%bind name, (_ : Pos.t) = lower_ident () in
  let%bind (_ : Pos.t) = expect Token.Equal in
  let%bind (_ : Pos.t) = expect (Token.Keyword "struct") in
  let%bind (_ : Pos.t) = expect Token.L_brace in
  let%bind fields = many (field ()) in
  let%bind (_ : Pos.t) = expect Token.R_brace in
  return (located pos (Cst.Type_def { name; fields }))
;;

let extern_decl () =
  let%bind pos = get_pos () in
  let%bind (_ : Pos.t) = expect (Token.Keyword "external") in
  let%bind name, (_ : Pos.t) = lower_ident () in
  let%bind (_ : Pos.t) = expect Token.Colon in
  let%bind (_ : Pos.t) = expect Token.L_paren in
  let%bind params = delimited0 ~delimiter:(expect Token.Comma) (ty ()) in
  let%bind (_ : Pos.t) = expect Token.R_paren in
  let%bind (_ : Pos.t) = expect Token.Arrow in
  let%bind ret = ty () in
  let%bind (_ : Pos.t) = expect Token.Equal in
  let%map symbol, (_ : Pos.t) = string_lit () in
  located pos (Cst.Extern_decl { name; params; ret; symbol })
;;

let fun_def () =
  let%bind pos = get_pos () in
  let%bind (_ : Pos.t) = expect (Token.Keyword "let") in
  let%bind name, (_ : Pos.t) = lower_ident () in
  let%bind (_ : Pos.t) = expect Token.L_paren in
  let%bind params = delimited0 ~delimiter:(expect Token.Comma) (param ()) in
  let%bind (_ : Pos.t) = expect Token.R_paren in
  let%bind (_ : Pos.t) = expect Token.Colon in
  let%bind ret = ty () in
  let%bind (_ : Pos.t) = expect Token.Equal in
  let%map body = block () in
  located pos (Cst.Fun_def { name; params; ret; body })
;;

let global_def () =
  let%bind pos = get_pos () in
  let%bind (_ : Pos.t) = expect (Token.Keyword "let") in
  let%bind name, (_ : Pos.t) = lower_ident () in
  let%bind (_ : Pos.t) = expect Token.Colon in
  let%bind ty = ty () in
  let%bind (_ : Pos.t) = expect Token.Equal in
  let%bind init = top_expr () in
  let%bind (_ : Pos.t) = expect Token.Semi_colon in
  return (located pos (Cst.Global_def { name; ty; init }))
;;

let item () =
  match%bind peek_non_comment () with
  | Some (Token.Keyword "type", _) -> type_def ()
  | Some (Token.Keyword "external", _) -> extern_decl ()
  | Some (Token.Keyword "let", _) ->
    (* Disambiguate global vs function def. *)
    let%bind tokens, (_ : State.t) = get in
    let rec skip_comments = function
      | [] -> []
      | (tok, _) :: rest when Token.is_comment tok -> skip_comments rest
      | rest -> rest
    in
    (match skip_comments tokens with
     | (Token.Keyword "let", _) :: (Token.Ident _, _) :: (Token.L_paren, _) :: _ ->
       fun_def ()
     | (Token.Keyword "let", _) :: (Token.Ident _, _) :: (Token.Colon, _) :: _ ->
       global_def ()
     | (tok, pos) :: _ -> fail (`Unexpected_token (tok, pos))
     | [] -> fail `Unexpected_end_of_input)
  | Some (tok, pos) -> fail (`Unexpected_token (tok, pos))
  | None -> fail `Unexpected_end_of_input
;;

let program () = exhaust (item ())

let parse_string ?(file = "") s =
  match Nod_frontend.Lexer.tokens ~keywords ~file s with
  | Error _ as e -> e
  | Ok tokens ->
    (match program () (tokens, State.create ()) with
     | Error _ as e -> e
     | Ok (res, _) -> Ok res)
;;
