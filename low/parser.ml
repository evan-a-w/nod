open! Core
module Pos = Nod_common.Pos
module Parser_comb = Nod_frontend.Parser_comb.Make (Token)
open Parser_comb

type output = Ast.program [@@deriving sexp]

let unexpected_token tok pos = fail (`Unexpected_token (tok, pos))

let ident () =
  match%bind next () with
  | Token.Ident name, _ -> return name
  | tok, pos -> unexpected_token tok pos
;;

let keyword kw =
  match%bind next () with
  | Token.Keyword s, _ when String.equal s kw -> return ()
  | tok, pos -> unexpected_token tok pos
;;

let expect_token tok =
  match%bind next () with
  | tok', _ when Token.equal tok tok' -> return ()
  | tok', pos -> unexpected_token tok' pos
;;

let expect_l_paren () = expect_token Token.L_paren
let expect_r_paren () = expect_token Token.R_paren
let expect_l_brace () = expect_token Token.L_brace
let expect_r_brace () = expect_token Token.R_brace
let expect_semi () = expect_token Token.Semi_colon
let expect_comma () = expect_token Token.Comma

let rec parse_type () =
  let%bind base =
    match%bind next () with
    | Token.Ident "i64", _ -> return Ast.I64
    | Token.Ident "f64", _ -> return Ast.F64
    | Token.Keyword "struct", _ ->
      let%map name = ident () in
      Ast.Struct name
    | Token.Ident name, _ -> fail (`Unknown_type name)
    | tok, pos -> unexpected_token tok pos
  in
  parse_ptr_suffix base

and parse_ptr_suffix base =
  match%bind peek () with
  | Some (Token.Star, _) ->
    let%bind () = expect_token Token.Star in
    parse_ptr_suffix (Ast.Ptr base)
  | _ -> return base
;;

let parse_param () =
  let%bind type_ = parse_type () in
  let%map name = ident () in
  { Ast.name; type_ }
;;

let parse_params () =
  let%bind () = expect_l_paren () in
  let%bind params = delimited0 ~delimiter:(expect_comma ()) (parse_param ()) in
  let%map () = expect_r_paren () in
  params
;;

let parse_struct_field () =
  let%bind field_name = ident () in
  let%bind () = expect_token Token.Colon in
  let%bind type_ = parse_type () in
  let%map () = expect_semi () in
  field_name, type_
;;

let parse_struct_def () =
  let%bind () = keyword "struct" in
  let%bind name = ident () in
  let%bind () = expect_l_brace () in
  let%bind fields = many (parse_struct_field ()) in
  let%bind () = expect_r_brace () in
  let%map () =
    match%bind peek () with
    | Some (Token.Semi_colon, _) -> expect_semi ()
    | _ -> return ()
  in
  { Ast.name; fields }
;;

let is_type_start = function
  | Token.Ident "i64"
  | Token.Ident "f64"
  | Token.Keyword "struct" -> true
  | _ -> false
;;

let rec parse_expr () = parse_additive ()

and parse_additive () =
  let%bind left = parse_multiplicative () in
  let rec loop acc =
    match%bind peek () with
    | Some (Token.Plus, _) ->
      let%bind () = expect_token Token.Plus in
      let%bind rhs = parse_multiplicative () in
      loop (Ast.Binary (Add, acc, rhs))
    | Some (Token.Minus, _) ->
      let%bind () = expect_token Token.Minus in
      let%bind rhs = parse_multiplicative () in
      loop (Ast.Binary (Sub, acc, rhs))
    | _ -> return acc
  in
  loop left

and parse_multiplicative () =
  let%bind left = parse_unary () in
  let rec loop acc =
    match%bind peek () with
    | Some (Token.Star, _) ->
      let%bind () = expect_token Token.Star in
      let%bind rhs = parse_unary () in
      loop (Ast.Binary (Mul, acc, rhs))
    | Some (Token.Forward_slash, _) ->
      let%bind () = expect_token Token.Forward_slash in
      let%bind rhs = parse_unary () in
      loop (Ast.Binary (Div, acc, rhs))
    | Some (Token.Percent, _) ->
      let%bind () = expect_token Token.Percent in
      let%bind rhs = parse_unary () in
      loop (Ast.Binary (Mod, acc, rhs))
    | _ -> return acc
  in
  loop left

and parse_unary () =
  match%bind peek () with
  | Some (Token.Minus, _) ->
    let%bind () = expect_token Token.Minus in
    let%map expr = parse_unary () in
    Ast.Unary (Neg, expr)
  | Some (Token.Star, _) ->
    let%bind () = expect_token Token.Star in
    let%map expr = parse_unary () in
    Ast.Unary (Deref, expr)
  | _ -> parse_postfix ()

and parse_postfix () =
  let%bind base = parse_primary () in
  let rec loop expr =
    match%bind peek () with
    | Some (Token.Dot, _) ->
      let%bind () = expect_token Token.Dot in
      let%bind field = ident () in
      loop (Ast.Field (expr, field))
    | Some (Token.Arrow, _) ->
      let%bind () = expect_token Token.Arrow in
      let%bind field = ident () in
      loop (Ast.Field (expr, field))
    | _ -> return expr
  in
  loop base

and parse_primary () =
  match%bind next () with
  | Token.Int i, _ -> return (Ast.Int (Int64.of_int i))
  | Token.Float f, _ -> return (Ast.Float f)
  | Token.Keyword "alloca", _ ->
    let%bind () = expect_l_paren () in
    let%bind type_ = parse_type () in
    let%map () = expect_r_paren () in
    Ast.Alloca type_
  | Token.Keyword "cast", _ ->
    let%bind () = expect_l_paren () in
    let%bind type_ = parse_type () in
    let%bind () = expect_comma () in
    let%bind expr = parse_expr () in
    let%map () = expect_r_paren () in
    Ast.Cast (type_, expr)
  | Token.Ident name, _ ->
    (match%bind peek () with
     | Some (Token.L_paren, _) ->
       let%bind args =
         let%bind () = expect_l_paren () in
         let%bind args = delimited0 ~delimiter:(expect_comma ()) (parse_expr ()) in
         let%map () = expect_r_paren () in
         args
       in
       return (Ast.Call (name, args))
     | _ -> return (Ast.Var name))
  | Token.L_paren, _ ->
    let%bind expr = parse_expr () in
    let%map () = expect_r_paren () in
    expr
  | tok, pos -> unexpected_token tok pos
;;

let rec parse_block () =
  let%bind () = expect_l_brace () in
  let%bind stmts = parse_statements [] in
  let%map () = expect_r_brace () in
  List.rev stmts

and parse_statements acc =
  match%bind peek () with
  | None | Some (Token.R_brace, _) -> return acc
  | Some (Token.Keyword "return", _) ->
    let%bind () = keyword "return" in
    let%bind expr = parse_expr () in
    let%bind () = expect_semi () in
    parse_statements (Ast.Return expr :: acc)
  | Some (Token.Keyword "if", _) ->
    let%bind () = keyword "if" in
    let%bind () = expect_l_paren () in
    let%bind cond = parse_expr () in
    let%bind () = expect_r_paren () in
    let%bind then_block = parse_block () in
    let%bind else_block =
      match%bind peek () with
      | Some (Token.Keyword "else", _) ->
        let%bind () = keyword "else" in
        let%map block = parse_block () in
        Some block
      | _ -> return None
    in
    parse_statements (Ast.If (cond, then_block, else_block) :: acc)
  | Some (Token.Keyword "while", _) ->
    let%bind () = keyword "while" in
    let%bind () = expect_l_paren () in
    let%bind cond = parse_expr () in
    let%bind () = expect_r_paren () in
    let%bind body = parse_block () in
    parse_statements (Ast.While (cond, body) :: acc)
  | Some (tok, _) when is_type_start tok ->
    let%bind type_ = parse_type () in
    let%bind name = ident () in
    let%bind init =
      match%bind peek () with
      | Some (Token.Equal, _) ->
        let%bind () = expect_token Token.Equal in
        let%map expr = parse_expr () in
        Some expr
      | _ -> return None
    in
    let%bind () = expect_semi () in
    parse_statements (Ast.Let (type_, name, init) :: acc)
  | Some _ ->
    let%bind expr = parse_expr () in
    (match%bind peek () with
     | Some (Token.Equal, _) ->
       let%bind () = expect_token Token.Equal in
       let%bind rhs = parse_expr () in
       let%bind () = expect_semi () in
       parse_statements (Ast.Assign (expr, rhs) :: acc)
     | _ ->
       let%bind () = expect_semi () in
       parse_statements (Ast.Expr expr :: acc))
;;

let parse_function_def () =
  let%bind return_type = parse_type () in
  let%bind name = ident () in
  let%bind params = parse_params () in
  let%map body = parse_block () in
  { Ast.name; params; return_type; body }
;;

let parse_program () =
  let rec loop structs functions =
    match%bind peek () with
    | None ->
      return { Ast.structs = List.rev structs; functions = List.rev functions }
    | Some (Token.Keyword "struct", _) ->
      let%bind struct_def = parse_struct_def () in
      loop (struct_def :: structs) functions
    | Some _ ->
      let%bind fn = parse_function_def () in
      loop structs (fn :: functions)
  in
  loop [] []
;;

let parser () : (output, Pos.t, unit, _) Parser_comb.parser = parse_program ()

let parse_string s =
  match Lexer.tokens ~file:"" s with
  | Error _ as e -> e
  | Ok tokens ->
    (match parser () (tokens, ()) with
     | Error _ as e -> e
     | Ok (res, _) -> Ok res)
;;
