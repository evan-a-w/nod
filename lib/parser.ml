open! Core
open Parser_comb

module State = struct
  type t =
    { blocks : string Ir.t' Vec.t String.Map.t
    ; labels : string Vec.t
    ; current_block : string
    ; current_instrs : string Ir.t' Vec.t
    }

  let create () =
    { blocks = String.Map.empty
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
    if Map.mem state.State.blocks label
    then fail (`Duplicate_label label)
    else return ()
  in
  if Vec.length state.State.current_instrs = 0
  then set_state { state with State.current_block = label }
  else (
    Vec.push state.State.labels state.current_block;
    let vec = Vec.create () in
    let%bind state =
      match Map.add state.State.blocks ~key:state.current_block ~data:vec with
      | `Duplicate -> fail (`Duplicate_label state.current_block)
      | `Ok blocks ->
        Vec.switch vec state.current_instrs;
        return { state with blocks; current_block = label }
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
    return
      (Ir.Branch (Ir.Branch.Uncond { Ir.Call_block.block = label; args = [] }))
  | `Lit_or_var cond ->
    let%bind (_ : Pos.t) = comma () in
    let%bind label1 = ident () in
    let%bind (_ : Pos.t) = comma () in
    let%map label2 = ident () in
    Ir.Branch
      (Ir.Branch.Cond
         { cond
         ; if_true = { Ir.Call_block.block = label1; args = [] }
         ; if_false = { Ir.Call_block.block = label2; args = [] }
         })
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
    let%bind dest = var () in
    let%bind (_ : Pos.t) = comma () in
    let%map src = lit_or_var () in
    Ir.Move (dest, src)
  | "b" | "branch" -> branch ()
  | "return" | "ret" ->
    let%map res = lit_or_var () in
    Ir.Return res
  | "unreachable" -> return Ir.Unreachable
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
  state.State.blocks, state.labels
;;

let parse_string s =
  match Lexer.tokens ~file:"" s with
  | Error _ as e -> e
  | Ok tokens ->
    (match parser () (tokens, State.create ()) with
     | Error _ as e -> e
     | Ok (res, _) -> Ok res)
;;
