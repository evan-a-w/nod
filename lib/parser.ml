open! Core
open Parser_comb

module State = struct
  type t =
    { blocks : string Ir.t' Vec.t String.Map.t
    ; current_block : string
    ; current_instrs : string Ir.t' Vec.t
    }

  let create () =
    { blocks = String.Map.empty
    ; current_block = "%root"
    ; current_instrs = Vec.create ()
    }
  ;;
end

let ident () =
  let%bind (_ : Pos.t) = expect Token.Percent in
  match%bind next () with
  | Token.Ident i, (_ : Pos.t) -> return i
  | tok, pos -> fail (`Unexpected_token (tok, pos))
;;

let lit () =
  match%bind next () with
  | Token.Int i, _ -> return i
  | tok, pos -> fail (`Unexpected_token (tok, pos))
;;

let lit_or_var () =
  match%bind next () with
  | Token.Int i, _ -> return (Ir.Lit_or_var.Lit i)
  | Token.Ident s, _ -> return (Ir.Lit_or_var.Var s)
  | tok, pos -> fail (`Unexpected_token (tok, pos))
;;

let seen_label ~label =
  let%bind state = get_state () in
  let vec = Vec.create () in
  let%bind state =
    match Map.add state.State.blocks ~key:state.current_block ~data:vec with
    | `Duplicate -> fail (`Duplicate_label state.current_block)
    | `Ok blocks ->
      Vec.switch vec state.current_instrs;
      return { state with blocks; current_block = label }
  in
  set_state state
;;

let comma () = expect Token.Comma

let arith () =
  let%bind dest = ident () in
  let%bind (_ : Pos.t) = comma () in
  let%bind src1 = lit_or_var () in
  let%bind (_ : Pos.t) = comma () in
  let%map src2 = lit_or_var () in
  { Ir.dest; src1; src2 }
;;

let instr' = function
  | "add" ->
    let%map a = arith () in
    Ir.Add a
  | "sub" ->
    let%map a = arith () in
    Ir.Sub a
  | "mul" ->
    let%map a = arith () in
    Ir.Mul a
  | "div" ->
    let%map a = arith () in
    Ir.Div a
  | "mod" ->
    let%map a = arith () in
    Ir.Mod a
  | "mov" | "move" ->
    let%bind dest = ident () in
    let%bind (_ : Pos.t) = comma () in
    let%map src = lit_or_var () in
    Ir.Move (dest, src)
  | "b" | "branch" ->
    let%bind cond = lit_or_var () in
    let%bind (_ : Pos.t) = comma () in
    let%bind label1 = ident () in
    let%bind (_ : Pos.t) = comma () in
    let%map label2 = ident () in
    Ir.Branch
      { cond
      ; if_true = { Ir.Call_block.block = label1; args = [] }
      ; if_false = { Ir.Call_block.block = label2; args = [] }
      }
  | "unreachable" -> return Ir.Unreachable
  | s -> fail (`Unknown_instruction s)
;;

let rec instr () =
  let%bind instr_or_label = ident () in
  match%bind peek () with
  | None -> fail `Unexpected_end_of_input
  | Some (Token.Colon, _) ->
    let%bind _ = next () in
    seen_label ~label:instr_or_label >> instr ()
  | Some _ -> instr' instr_or_label
;;

let parser () =
  let rec go () =
    match%bind peek () with
    | None -> return ()
    | Some _ ->
      let%bind i = instr () in
      let%bind state = get_state () in
      Vec.push state.State.current_instrs i;
      go ()
  in
  let%bind () = go () in
  let%bind () = seen_label ~label:"" in
  let%map state = get_state () in
  state.State.blocks
;;

let parse_string s =
  match Lexer.tokens ~file:"" s with
  | Error _ as e -> e
  | Ok tokens ->
    (match parser () (tokens, State.create ()) with
     | Error _ as e -> e
     | Ok (res, _) -> Ok res)
;;
