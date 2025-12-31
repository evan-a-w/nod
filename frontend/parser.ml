open! Core
open! Import
module Parser_comb = Parser_comb.Make (Token)
open Parser_comb

type unprocessed_cfg =
  instrs_by_label:string Ir0.t Vec.t Core.String.Map.t * labels:string Vec.t
[@@deriving sexp]

type output = unprocessed_cfg Function0.t' String.Map.t [@@deriving sexp]

module State = struct
  type t =
    { instrs_by_label : string Ir0.t Vec.t String.Map.t
    ; labels : string Vec.t
    ; current_block : string
    ; current_instrs : string Ir0.t Vec.t
    ; var_types : Type.t String.Table.t
    ; next_temp : int
    }

  let create () =
    { instrs_by_label = String.Map.empty
    ; labels = Vec.create ()
    ; current_block = "%root"
    ; current_instrs = Vec.create ()
    ; var_types = String.Table.create ()
    ; next_temp = 0
    }
  ;;
end

let fail_type_mismatch fmt =
  Printf.ksprintf (fun msg -> fail (`Type_mismatch msg)) fmt
;;

let ensure_value_type type_ =
  if Type.is_aggregate type_
  then fail_type_mismatch "aggregate values are not supported: %s" (Type.to_string type_)
  else return type_
;;

let fresh_temp_var ~type_ =
  let%bind state = get_state () in
  let name = sprintf "__tmp%d" state.State.next_temp in
  Hashtbl.set state.State.var_types ~key:name ~data:type_;
  let var = Var.create ~name ~type_ in
  set_state { state with next_temp = state.next_temp + 1 } >> return var
;;

let or_error_to_parser = function
  | Ok v -> return v
  | Error err -> fail_type_mismatch "%s" (Error.to_string_hum err)
;;

let sizeof_literal type_ =
  type_ |> Type.size_in_bytes |> Int64.of_int |> fun s -> Ir.Lit_or_var.Lit s
;;

let mem_address base ~offset = Ir.Mem.address ~offset base
;;

let mem_of_lit_or_var base = mem_address base ~offset:0
;;

let compute_field_offset type_ indices =
  if List.is_empty indices
  then fail_type_mismatch "field access requires at least one index"
  else or_error_to_parser (Type.field_offset type_ indices)
;;

let ident () =
  match%bind next () with
  | Token.Ident i, (_ : Pos.t) -> return i
  | tok, pos -> fail (`Unexpected_token (tok, pos))
;;

let record_var_type name type_ =
  let%bind state = get_state () in
  match Hashtbl.find state.State.var_types name with
  | None ->
    Hashtbl.set state.var_types ~key:name ~data:type_;
    return ()
  | Some existing when Type.equal existing type_ -> return ()
  | Some existing ->
    fail
      (`Type_mismatch
        (sprintf
           "variable %s previously annotated as %s but got %s"
           name
           (Type.to_string existing)
           (Type.to_string type_)))
;;

let ensure_var_type name =
  let%bind state = get_state () in
  match Hashtbl.find state.State.var_types name with
  | Some type_ -> return type_
  | None -> fail (`Unknown_variable name)
;;

let rec parse_type_expr () =
  match%bind next () with
  | Token.Ident type_name, _ ->
    (match Type.of_string type_name with
     | Some type_ -> return type_
     | None -> fail (`Unknown_type type_name))
  | Token.L_paren, _ ->
    let%bind first = parse_type_expr () in
    let rec parse_elements acc =
      match%bind peek () with
      | Some (Token.Comma, _) ->
        let%bind (_ : Pos.t) = expect Token.Comma in
        let%bind next_type = parse_type_expr () in
        parse_elements (next_type :: acc)
      | Some (Token.R_paren, _) ->
        let%map (_ : Pos.t) = expect Token.R_paren in
        List.rev acc
      | Some (tok, pos) -> fail (`Unexpected_token (tok, pos))
      | None -> fail `Unexpected_end_of_input
    in
    let%map elements = parse_elements [ first ] in
    Type.Tuple elements
  | tok, pos -> fail (`Unexpected_token (tok, pos))
;;

let is_sizeof_token = function
  | Token.Ident s -> String.Caseless.equal s "sizeof"
  | _ -> false
;;

let parse_sizeof_literal () =
  let%bind tok, pos = next () in
  match tok with
  | Token.Ident s when String.Caseless.equal s "sizeof" ->
    let%bind (_ : Pos.t) = expect Token.L_bracket in
    let%bind type_ = parse_type_expr () in
    let%map (_ : Pos.t) = expect Token.R_bracket in
    Ir.Lit_or_var.Lit (Int64.of_int (Type.size_in_bytes type_))
  | _ -> fail (`Unexpected_token (tok, pos))
;;

let parse_type_annotation () =
  let%bind (_ : Pos.t) = expect Token.Colon in
  let%bind type_ = parse_type_expr () in
  ensure_value_type type_
;;

let var_decl () =
  let%bind (_ : Pos.t) = expect Token.Percent in
  let%bind name = ident () in
  let%bind type_ = parse_type_annotation () in
  let%bind () = record_var_type name type_ in
  return (Var.create ~name ~type_)
;;

let var_use () =
  let%bind (_ : Pos.t) = expect Token.Percent in
  let%bind name = ident () in
  match%bind peek () with
  | Some (Token.Colon, _) ->
    let%bind type_ = parse_type_annotation () in
    let%bind () = record_var_type name type_ in
    return (Var.create ~name ~type_)
  | _ ->
    let%map type_ = ensure_var_type name in
    Var.create ~name ~type_
;;

let lit () =
  match%bind next () with
  | Token.Int i, _ -> return i
  | tok, pos -> fail (`Unexpected_token (tok, pos))
;;

let lit_or_var () =
  match%bind peek () with
  | Some (Token.Int _, _) ->
    let%map i = lit () in
    Ir.Lit_or_var.Lit (Int64.of_int i)
  | Some (Token.Percent, _) ->
    let%map v = var_use () in
    Ir.Lit_or_var.Var v
  | Some (tok, _) when is_sizeof_token tok -> parse_sizeof_literal ()
  | Some (tok, pos) -> fail (`Unexpected_token (tok, pos))
  | None -> fail `Unexpected_end_of_input
;;

let lit_or_var_or_ident () =
  match%bind peek () with
  | Some (Token.Int _, _) ->
    let%map i = lit () in
    `Lit_or_var (Ir.Lit_or_var.Lit (Int64.of_int i))
  | Some (Token.Percent, _) ->
    let%map v = var_use () in
    `Lit_or_var (Ir.Lit_or_var.Var v)
  | Some (tok, _) when is_sizeof_token tok ->
    let%map lit = parse_sizeof_literal () in
    `Lit_or_var lit
  | Some (Token.Ident _, _) ->
    let%map s = ident () in
    `Ident s
  | Some (tok, pos) -> fail (`Unexpected_token (tok, pos))
  | None -> fail `Unexpected_end_of_input
;;

let parse_alloca_size_operand () =
  match%bind peek () with
  | Some (Token.Int _, _) | Some (Token.Percent, _) -> lit_or_var ()
  | Some (tok, _) when is_sizeof_token tok -> parse_sizeof_literal ()
  | Some (Token.L_paren, _) | Some (Token.Ident _, _) ->
    let%map type_ = parse_type_expr () in
    sizeof_literal type_
  | Some (tok, pos) -> fail (`Unexpected_token (tok, pos))
  | None -> fail `Unexpected_end_of_input
;;

let parse_field_indices () =
  let rec gather acc =
    let%bind idx = lit () in
    let acc = idx :: acc in
    match%bind peek () with
    | Some (Token.Comma, _) ->
      let%bind _ = expect Token.Comma in
      (match%bind peek () with
       | Some (Token.Int _, _) -> gather acc
       | _ -> return (List.rev acc))
    | _ -> return (List.rev acc)
  in
  gather []
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
  let%bind dest = var_decl () in
  let%bind (_ : Pos.t) = comma () in
  let%bind src1 = lit_or_var () in
  let%bind (_ : Pos.t) = comma () in
  let%map src2 = lit_or_var () in
  { Ir.dest; src1; src2 }
;;

let branch () =
  match%bind lit_or_var_or_ident () with
  | `Ident label ->
    return [ Ir.branch (Uncond { Ir.Call_block.block = label; args = [] }) ]
  | `Lit_or_var cond ->
    let%bind (_ : Pos.t) = comma () in
    let%bind label1 = ident () in
    let%bind (_ : Pos.t) = comma () in
    let%map label2 = ident () in
    [ Ir.branch
        (Cond
           { cond
           ; if_true = { Ir.Call_block.block = label1; args = [] }
           ; if_false = { Ir.Call_block.block = label2; args = [] }
           })
    ]
;;

let instr' = function
  | "load" ->
    let%bind dest = var_decl () in
    let%bind (_ : Pos.t) = comma () in
    let%map src = lit_or_var () in
    [ Ir.load dest (mem_of_lit_or_var src) ]
  | "store" ->
    let%bind mem = var_use () in
    let%bind (_ : Pos.t) = comma () in
    let%map src = lit_or_var () in
    [ Ir.store src (mem_of_lit_or_var (Ir.Lit_or_var.Var mem)) ]
  | "add" ->
    let%map a = arith () in
    [ Ir.add a ]
  | "and" ->
    let%map a = arith () in
    [ Ir.and_ a ]
  | "or" ->
    let%map a = arith () in
    [ Ir.or_ a ]
  | "sub" ->
    let%map a = arith () in
    [ Ir.sub a ]
  | "mul" ->
    let%map a = arith () in
    [ Ir.mul a ]
  | "div" ->
    let%map a = arith () in
    [ Ir.div a ]
  | "mod" ->
    let%map a = arith () in
    [ Ir.mod_ a ]
  | "fadd" ->
    let%map a = arith () in
    [ Ir.fadd a ]
  | "fsub" ->
    let%map a = arith () in
    [ Ir.fsub a ]
  | "fmul" ->
    let%map a = arith () in
    [ Ir.fmul a ]
  | "fdiv" ->
    let%map a = arith () in
    [ Ir.fdiv a ]
  | "alloca" ->
    let%bind dest = var_decl () in
    let%bind (_ : Pos.t) = comma () in
    let%map size = parse_alloca_size_operand () in
    [ Ir.alloca { dest; size } ]
  | "load_field" ->
    let%bind dest = var_decl () in
    let%bind (_ : Pos.t) = comma () in
    let%bind base = var_use () in
    let%bind (_ : Pos.t) = comma () in
    let%bind type_ = parse_type_expr () in
    let%bind (_ : Pos.t) = comma () in
    let%bind indices = parse_field_indices () in
    let%bind offset, raw_field_type = compute_field_offset type_ indices in
    let%bind field_type = ensure_value_type raw_field_type in
    let%bind () =
      if Type.equal field_type (Var.type_ dest)
      then return ()
      else
        fail_type_mismatch
          "load_field expected destination of type %s but got %s"
          (Type.to_string field_type)
          (Type.to_string (Var.type_ dest))
    in
    return
      [ Ir.load dest (mem_address (Ir.Lit_or_var.Var base) ~offset) ]
  | "store_field" ->
    let%bind base = var_use () in
    let%bind (_ : Pos.t) = comma () in
    let%bind src = lit_or_var () in
    let%bind (_ : Pos.t) = comma () in
    let%bind type_ = parse_type_expr () in
    let%bind (_ : Pos.t) = comma () in
    let%bind indices = parse_field_indices () in
    let%bind offset, raw_field_type = compute_field_offset type_ indices in
    let%bind field_type = ensure_value_type raw_field_type in
    let%bind () =
      match src with
      | Ir.Lit_or_var.Lit _ -> return ()
      | Ir.Lit_or_var.Var v when Type.equal (Var.type_ v) field_type -> return ()
      | Ir.Lit_or_var.Var v ->
        fail_type_mismatch
          "store_field expected source of type %s but got %s"
          (Type.to_string field_type)
          (Type.to_string (Var.type_ v))
    in
    return
      [ Ir.store src (mem_address (Ir.Lit_or_var.Var base) ~offset) ]
  | "memcpy" ->
    let%bind dest = var_use () in
    let%bind (_ : Pos.t) = comma () in
    let%bind src = var_use () in
    let%bind (_ : Pos.t) = comma () in
    let%bind type_ = parse_type_expr () in
    let leaves = Type.leaf_offsets type_ in
    let rec emit acc = function
      | [] -> return (List.rev acc)
      | (offset, raw_field_type) :: rest ->
        let%bind field_type = ensure_value_type raw_field_type in
        let%bind temp = fresh_temp_var ~type_:field_type in
        let load_instr =
          Ir.load temp (mem_address (Ir.Lit_or_var.Var src) ~offset)
        in
        let store_instr =
          Ir.store
            (Ir.Lit_or_var.Var temp)
            (mem_address (Ir.Lit_or_var.Var dest) ~offset)
        in
        emit (store_instr :: load_instr :: acc) rest
    in
    emit [] leaves
  | "call" ->
    let%bind fn = ident () in
    let%bind (_ : Pos.t) = expect Token.L_paren in
    let%bind args =
      delimited0 ~delimiter:(expect Token.Comma) (lit_or_var ())
    in
    let%bind (_ : Pos.t) = expect Token.R_paren in
    let%bind results =
      match%bind peek () with
      | Some (Token.Arrow, _) ->
        let%bind (_ : Pos.t) = expect Token.Arrow in
        maybe_surrounded
          ~before:(expect Token.L_paren)
          ~after:(expect Token.R_paren)
          (delimited0 ~delimiter:(expect Token.Comma) (var_decl ()))
      | _ -> return []
    in
    return [ Ir.call ~fn ~results ~args ]
  | "mov" | "move" ->
    let%bind dest = var_decl () in
    let%bind (_ : Pos.t) = comma () in
    let%map src = lit_or_var () in
    [ Ir.move dest src ]
  | "cast" ->
    let%bind dest = var_decl () in
    let%bind (_ : Pos.t) = comma () in
    let%map src = lit_or_var () in
    [ Ir.cast dest src ]
  | "b" | "branch" -> branch ()
  | "return" | "ret" ->
    let%map res = lit_or_var () in
    [ Ir.return res ]
  | "unreachable" -> return [ Ir.unreachable ]
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
      let%bind instrs = instr () in
      let%bind state = get_state () in
      List.iter instrs ~f:(fun instr -> Vec.push state.State.current_instrs instr);
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
  let%bind args = delimited0 ~delimiter:(expect Token.Comma) (var_decl ()) in
  let%bind (_ : Pos.t) = expect Token.R_paren in
  let%bind (_ : Pos.t) = expect Token.L_brace in
  let%bind instrs_by_label, labels = instructions_parser () in
  let%map (_ : Pos.t) = expect Token.R_brace in
  Function.create ~name ~args ~root:(~instrs_by_label, ~labels)
;;

let assume_root () =
  (* just so I don't need to migrate tests rn *)
  let%map instrs_by_label, labels = instructions_parser () in
  String.Map.of_list_with_key_exn
    ~get_key:Function.name
    [ Function.create ~name:"root" ~root:(~instrs_by_label, ~labels) ~args:[] ]
;;

let function_parser_with_reset () =
  let%bind func = function_parser () in
  (* Reset state after parsing each function for the next one *)
  let%bind () =
    set_state
      { State.instrs_by_label = String.Map.empty
      ; State.labels = Vec.create ()
      ; State.current_block = "%root"
      ; State.current_instrs = Vec.create ()
      ; State.var_types = String.Table.create ()
      ; State.next_temp = 0
      }
  in
  return func
;;

let program_parser () =
  exhaust (function_parser_with_reset ())
  >>| String.Map.of_list_with_key_exn ~get_key:Function.name
;;

let parser () : (output, Pos.t, State.t, _) Parser_comb.parser =
  assume_root () <|> program_parser ()
;;

let parse_string s =
  match Lexer.tokens ~file:"" s with
  | Error _ as e -> e
  | Ok tokens ->
    (match parser () (tokens, State.create ()) with
     | Error _ as e -> e
     | Ok (res, _) -> Ok res)
;;
