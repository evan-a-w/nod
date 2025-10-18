open! Core
open Parser_core
module Parser_comb = Parser_comb.Make (Token)
open Parser_comb

type unprocessed_cfg =
  instrs_by_label:string Ir0.t Vec.t Core.String.Map.t * labels:string Vec.t
[@@deriving sexp]

type error =
  [ `Duplicate_label of string
  | `Expected_digit of char
  | `Unexpected_character of char
  | `Unexpected_end_of_input
  | `Unexpected_end_of_input
  | `Unexpected_eof_in_comment
  | `Unexpected_token of Token.t * Pos.t
  | `Unknown_instruction of string
  | `Choices of error list
  ]

type output = unprocessed_cfg Function0.t' String.Map.t [@@deriving sexp]

let rec error_to_string : error -> string = function
  | `Duplicate_label s -> Printf.sprintf "Error: duplicate label '%s'\n" s
  | `Expected_digit c ->
    Printf.sprintf "Error: expected a digit but got '%c'\n" c
  | `Unexpected_character c ->
    Printf.sprintf "Error: unexpected character '%c'\n" c
  | `Unexpected_end_of_input ->
    Printf.sprintf "Error: unexpected end of input\n"
  | `Unexpected_eof_in_comment ->
    Printf.sprintf "Error: unexpected EOF in comment\n"
  | `Unexpected_token (tok, pos) ->
    Printf.sprintf
      "Error: unexpected token %s at %s\n"
      (Token.to_string tok)
      (Pos.to_string pos)
  | `Unknown_instruction s ->
    Printf.sprintf "Error: unknown instruction '%s'\n" s
  | `Choices [ error ] -> error_to_string error
  | `Choices l ->
    Printf.sprintf
      "Error: errors in choices `%s`\n"
      (String.concat (List.map l ~f:error_to_string) ~sep:", ")
;;

module State = struct
  type t =
    { instrs_by_label : string Ir0.t Vec.t String.Map.t
    ; labels : string Vec.t
    ; current_block : string
    ; current_instrs : string Ir0.t Vec.t
    }

  let create () =
    { instrs_by_label = String.Map.empty
    ; labels = Vec.create ()
    ; current_block = "%root"
    ; current_instrs = Vec.create ()
    }
  ;;
end

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

let lit_or_var () =
  match%bind next () with
  | Token.Int i, _ -> return (Ir.Lit_or_var.Lit (Int64.of_int i))
  | Token.Percent, _ ->
    let%map s = ident () in
    Ir.Lit_or_var.Var s
  | tok, pos -> fail (`Unexpected_token (tok, pos))
;;

let lit_or_var_or_ident () =
  match%bind next () with
  | Token.Int i, _ -> return (`Lit_or_var (Ir.Lit_or_var.Lit (Int64.of_int i)))
  | Token.Percent, _ ->
    let%map s = ident () in
    `Lit_or_var (Ir.Lit_or_var.Var s)
  | Token.Ident s, _ -> return (`Ident s)
  | tok, pos -> fail (`Unexpected_token (tok, pos))
;;

let seen_label ~label =
  let%bind state = get_state () in
  let%bind () =
    if Map.mem state.State.instrs_by_label label
    then fail (`Duplicate_label label)
    else return ()
  in
  if Vec.length state.State.current_instrs = 0
  then set_state { state with State.current_block = label }
  else (
    Vec.push state.State.labels state.current_block;
    let vec = Vec.create () in
    let%bind state =
      match
        Map.add state.State.instrs_by_label ~key:state.current_block ~data:vec
      with
      | `Duplicate -> fail (`Duplicate_label state.current_block)
      | `Ok instrs_by_label ->
        Vec.switch vec state.current_instrs;
        return { state with instrs_by_label; current_block = label }
    in
    set_state state)
;;

let comma () = expect Token.Comma

let arith () =
  let%bind dest = var () in
  let%bind (_ : Pos.t) = comma () in
  let%bind src1 = lit_or_var () in
  let%bind (_ : Pos.t) = comma () in
  let%map src2 = lit_or_var () in
  { Ir.dest; src1; src2 }
;;

let branch () =
  match%bind lit_or_var_or_ident () with
  | `Ident label ->
    return (Ir.branch (Uncond { Ir.Call_block.block = label; args = [] }))
  | `Lit_or_var cond ->
    let%bind (_ : Pos.t) = comma () in
    let%bind label1 = ident () in
    let%bind (_ : Pos.t) = comma () in
    let%map label2 = ident () in
    Ir.branch
      (Cond
         { cond
         ; if_true = { Ir.Call_block.block = label1; args = [] }
         ; if_false = { Ir.Call_block.block = label2; args = [] }
         })
;;

let instr' = function
  | "add" ->
    let%map a = arith () in
    Ir.add a
  | "and" ->
    let%map a = arith () in
    Ir.and_ a
  | "or" ->
    let%map a = arith () in
    Ir.or_ a
  | "sub" ->
    let%map a = arith () in
    Ir.sub a
  | "mul" ->
    let%map a = arith () in
    Ir.mul a
  | "div" ->
    let%map a = arith () in
    Ir.div a
  | "mod" ->
    let%map a = arith () in
    Ir.mod_ a
  | "alloca" ->
    let%bind dest = var () in
    let%bind (_ : Pos.t) = comma () in
    let%map size = lit_or_var () in
    Ir.alloca { dest; size }
  | "call" ->
    let%bind fn = ident () in
    let%bind (_ : Pos.t) = expect Token.L_paren in
    let%bind args = delimited0 ~delimiter:(expect Token.Comma) (lit_or_var ()) in
    let%bind (_ : Pos.t) = expect Token.R_paren in
    let%bind results =
      match%bind peek () with
      | Some (Token.Arrow, _) ->
        let%bind (_ : Pos.t) = expect Token.Arrow in
        let%bind (_ : Pos.t) = expect Token.L_paren in
        let%bind res = delimited0 ~delimiter:(expect Token.Comma) (var ()) in
        let%map (_ : Pos.t) = expect Token.R_paren in
        res
      | _ -> return []
    in
    return (Ir.call ~fn ~results ~args)
  | "mov" | "move" ->
    let%bind dest = var () in
    let%bind (_ : Pos.t) = comma () in
    let%map src = lit_or_var () in
    Ir.move dest src
  | "b" | "branch" -> branch ()
  | "return" | "ret" ->
    let%map res = lit_or_var () in
    Ir.return res
  | "unreachable" -> return Ir.unreachable
  | s -> fail (`Unknown_instruction s)
;;

let rec instr () =
  let%bind instr_or_label = ident () in
  match%bind peek () with
  | Some (Token.Colon, _) ->
    let%bind _ = next () in
    seen_label ~label:instr_or_label >> instr ()
  | Some _ | None -> instr' instr_or_label
;;

let instructions_parser () =
  let rec go () =
    match%bind peek () with
    | None | Some (Token.R_brace, _) -> return ()
    | Some _ ->
      let%bind i = instr () in
      let%bind state = get_state () in
      Vec.push state.State.current_instrs i;
      go ()
  in
  let%bind () = go () in
  let%bind () = seen_label ~label:"" in
  let%map state = get_state () in
  state.State.instrs_by_label, state.labels
;;

let function_parser () =
  let%bind name = ident () in
  let%bind (_ : Pos.t) = expect Token.L_paren in
  let%bind args = delimited0 ~delimiter:(expect Token.Comma) (var ()) in
  let%bind (_ : Pos.t) = expect Token.R_paren in
  let%bind (_ : Pos.t) = expect Token.L_brace in
  let%bind instrs_by_label, labels = instructions_parser () in
  let%map (_ : Pos.t) = expect Token.R_brace in
  { Function.name; args; call_conv = Default; root = ~instrs_by_label, ~labels }
;;

let assume_root () =
  (* just so I don't need to migrate tests rn *)
  let%map instrs_by_label, labels = instructions_parser () in
  String.Map.of_list_with_key_exn
    ~get_key:Function.name
    [ { Function.name = "root"
      ; call_conv = Default
      ; root = ~instrs_by_label, ~labels
      ; args = []
      }
    ]
;;

let program_parser () =
  exhaust (function_parser ())
  >>| String.Map.of_list_with_key_exn ~get_key:Function.name
;;

let parser () : (output, Pos.t, State.t, _) Parser_comb.parser =
  program_parser () <|> assume_root ()
;;

let parse_string s =
  match Lexer.tokens ~file:"" s with
  | Error _ as e -> e
  | Ok tokens ->
    (match parser () (tokens, State.create ()) with
     | Error _ as e -> e
     | Ok (res, _) -> Ok res)
;;
