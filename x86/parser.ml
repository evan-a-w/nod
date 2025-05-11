open! Core
open Parser_core
module Parser_comb = Parser_comb.Make (Token)
open! Parser_comb
open! Instruction
open! Asm

type config = { classification_config : Instruction.Classification.Config.t }

let rec file () = many (line_item ()) << eof ()

and line_item () =
  let%bind line =
    choice [ directive_line (); label_defn (); instruction_line () ]
  in
  let%map _ = skip_many_tok Token.Newline in
  line

and mnemonic () =
  let%bind tok, pos = peek' () in
  match%bind ident () >>| Mnemonic.of_string_opt with
  | Some mnemonic -> return mnemonic
  | None -> fail (`Unexpected_token (tok, pos))

and instruction () : (Instruction.t, _, _, _) parser =
  let%bind mne = mnemonic () in
  let delimiter = optional (expect Token.Comma) in
  let%bind operands = delimited0 ~delimiter (operand ()) in
  let instruction =
    match operands with
    | [] -> Nullary mne
    | [ a ] -> Unary (mne, a)
    | [ a; b ] -> Binary (mne, a, b)
    | l -> N_ary (mne, l)
  in
  let%bind config = get_state () in
  match
    Instruction.Classification.Config.is_allowed
      config.classification_config
      instruction
  with
  | true -> return instruction
  | false -> fail (`Instruction_not_allowed instruction)

and instruction_line () : (Asm.t, _, _, _) parser =
  instruction () >>| Asm.instruction

and operand () =
  choice
    [ reg () >>| Operand.reg; imm () >>| Operand.imm; mem () >>| Operand.mem ]

and imm () =
  let%bind _ = expect Token.Dollar in
  let%bind tok, pos = next () in
  match tok with
  | Token.Int i -> return i (* TODO: hex *)
  | _ -> fail (`Unexpected_token (tok, pos))

and mem () =
  let%bind seg = optional (segment_reg () << expect Token.Colon) in
  let%bind offset =
    choice
      [ (let%map l = label () in
         `Label l)
      ; (let%map i = int_constant () in
         `Imm i)
      ]
    |> optional
    >>| Option.value ~default:(`Imm (Int64.of_int 1))
  in
  let%bind base = optional (reg ()) in
  let%map index =
    let%bind reg = optional (reg ()) in
    match reg with
    | None -> return None
    | Some reg ->
      let%bind scale = optional (int_constant ()) in
      (match scale with
       | None -> return (Some (reg, Int64.of_int 1))
       | Some i -> return (Some (reg, i)))
  in
  { Mem.base; index; offset; seg }

and int_constant () =
  next ()
  >>= function
  | Token.Int i, _ -> return i
  (* TODO: hex *)
  | tok, pos -> fail (`Unexpected_token (tok, pos))

and ident () =
  match%bind next () with
  | Token.Ident i, (_ : Pos.t) -> return i
  | tok, pos -> fail (`Unexpected_token (tok, pos))

and reg () =
  let%bind _ = expect Token.Percent in
  let%bind name = ident () in
  match Map.find Reg.name_to_reg name with
  | None -> fail (`Unexpected_register name)
  | Some reg -> return reg

and segment_reg () =
  let%bind pos = get_pos () in
  let%bind r = reg () in
  match Reg.segment r with
  | Some segment -> return segment
  | None -> fail (`Unexpected_token (Token.Ident (Reg.Variants.to_name r), pos))

and label () = ident () >>| Label.of_string
and directive () = ident () >>| Directive.of_string

and label_defn () : (Asm.t, _, _, _) parser =
  let%bind _ = expect Token.Dot in
  let%bind l = label () in
  let%map _ = expect Token.Colon in
  Label l

and directive_line () : (Asm.t, _, _, _) parser =
  let%bind _ = expect Token.Dot in
  let%bind d = directive () in
  let%map l = take_until_token_inc Token.Newline in
  Directive (d, l)
;;

let parse_string ~config s =
  match Lexer.tokens ~file:"" s with
  | Error _ as e -> e
  | Ok tokens ->
    (match file () (tokens, config) with
     | Error _ as e -> e
     | Ok (res, _) -> Ok res)
;;
