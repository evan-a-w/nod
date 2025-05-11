open! Core
open Parser_core
module Parser_comb = Parser_comb.Make (Token)
open Parser_comb
open! Asm

let rec file () = many (line_item ()) << eof ()

and line_item () =
  choice [ directive_line (); label_defn (); instruction_line () ]
  << skip_many_tok Token.Newline

(* Parse any instruction line *)
and instruction_line () =
  let%bind mnem = Mnemonic.parser in
  let%bind operands =
    option
      []
      (spaces *> sep_by1 (spaces *> expect Token.Comma <* spaces) operand)
  in
  return (Asm.Insn (mnem, operands))

(* Parse any operand: register, immediate, or memory *)
and operand () =
  choice
    [ reg () >>| Operand.reg; imm () >>| Operand.imm; mem () >>| Operand.mem ]

(* Parse an immediate: e.g. "$123" or "$-0x10" *)
and imm () =
  let%bind _ = expect Token.Dollar in
  let%bind tok = next () in
  match tok with
  | Token.Int i, _ -> return i
  | Token.HexInt i, _ -> return i
  | _ -> fail (`Unexpected_token tok)

and mem () =
  let%bind seg =
    option
      None
      (try_consume_directive "fs" (* or other segment registers *)
       >>| fun () -> Some Reg.FS)
  in
  let%bind _ = expect Token.LBrack in
  let%bind base = option None (reg >>| Option.some) in
  let%bind parts =
    many
      (skip_spaces
       *> choice
            [ (* + index * scale *)
              (let%bind _ = expect Token.Plus in
               let%bind r, _ = parse_index in
               return (`Index r);
               (* + disp or - disp *)
               let%bind sign =
                 choice
                   [ (expect Token.Plus
                      >>| fun _ ->
                      1;
                      expect Token.Minus >>| fun _ -> -1)
                   ]
               in
               let%bind i = imm in
               return (`Disp Int64.(mul (of_int sign) i)))
            ])
  in
  let%map _ = expect Token.RBrack in
  let index, disp =
    List.fold parts ~init:(None, 0L) ~f:(fun (idx, d) -> function
      | `Index r -> Some (r, 1), d
      | `Disp x -> idx, Int64.(d + x))
  in
  { Mem.base; index; disp; seg }

and parse_index =
  let%bind r = reg in
  let%map scale = option 1 (expect Token.Star *> expect_int_constant) in
  r, scale

and expect_int_constant =
  next
  >>= function
  | Token.Int i, _ -> return (Int64.to_int_exn i)
  | Token.HexInt i, _ -> return (Int64.to_int_exn i)
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

and segment () =
  let%bind pos = get_pos () in
  let%bind r = reg () in
  match Reg.segment r with
  | Some segment -> return segment
  | None -> fail (`Unexpected_token (Token.Ident (Reg.Variants.to_name r), pos))

and label () = ident () >>| Label.of_string
and directive () = ident () >>| Directive.of_string

and label_defn () =
  let%bind _ = expect Token.Dot in
  let%bind l = label () in
  let%map _ = expect Token.Colon in
  Label l

and directive_line () =
  let%bind _ = expect Token.Dot in
  let%bind d = directive () in
  let%map l = take_until_token_inc Token.Newline in
  Directive (d, l)
;;
