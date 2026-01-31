open! Core
open! Import
module Parser_comb = Parser_comb.Make (Token)
open Parser_comb

type unprocessed_cfg =
  instrs_by_label:(Typed_var.t, string) Ir.t Vec.t Core.String.Map.t
  * labels:string Vec.t
[@@deriving sexp]

type output = (Typed_var.t, unprocessed_cfg) Program.t [@@deriving sexp]

module State = struct
  type t =
    { instrs_by_label : (Typed_var.t, string) Ir.t Vec.t String.Map.t
    ; labels : string Vec.t
    ; current_block : string
    ; current_instrs : (Typed_var.t, string) Ir.t Vec.t
    ; var_types : Type.t String.Table.t
    ; globals : Global.t String.Table.t
    }

  let create () =
    { instrs_by_label = String.Map.empty
    ; labels = Vec.create ()
    ; current_block = "%root"
    ; current_instrs = Vec.create ()
    ; var_types = String.Table.create ()
    ; globals = String.Table.create ()
    }
  ;;
end

let fail_type_mismatch fmt =
  Printf.ksprintf (fun msg -> fail (`Type_mismatch msg)) fmt
;;

let ensure_value_type type_ =
  if Type.is_aggregate type_
  then
    fail_type_mismatch
      "aggregate values are not supported: %s"
      (Type.to_string type_)
  else return type_
;;

let sizeof_literal type_ =
  type_ |> Type.size_in_bytes |> Int64.of_int |> fun s -> Lit_or_var.Lit s
;;

let mem_address base ~offset = Mem.address ~offset base
let mem_of_lit_or_var base = mem_address base ~offset:0

let ident () =
  match%bind next () with
  | Token.Ident i, (_ : Pos.t) -> return i
  | tok, pos -> fail (`Unexpected_token (tok, pos))
;;

let global_name () =
  let%bind (_ : Pos.t) = expect Token.At in
  ident ()
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

let ensure_global name =
  let%bind state = get_state () in
  match Hashtbl.find state.State.globals name with
  | Some global -> return global
  | None -> fail (`Unknown_global name)
;;

let record_global global =
  let%bind state = get_state () in
  match Hashtbl.find state.State.globals global.Global.name with
  | None ->
    Hashtbl.set state.globals ~key:global.name ~data:global;
    return ()
  | Some _ -> fail (`Type_mismatch (sprintf "duplicate global %s" global.name))
;;

let rec parse_type_expr () =
  match%bind next () with
  | Token.Ident type_name, _ ->
    if String.Caseless.equal type_name "ptr"
    then (
      match%bind peek () with
      | Some (Token.L_paren, _) ->
        let%bind (_ : Pos.t) = expect Token.L_paren in
        let%bind inner = parse_type_expr () in
        let%bind (_ : Pos.t) = expect Token.R_paren in
        return (Type.Ptr_typed inner)
      | _ -> return Type.Ptr)
    else (
      match Type.of_string type_name with
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
    Lit_or_var.Lit (Int64.of_int (Type.size_in_bytes type_))
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
  return (Typed_var.create ~name ~type_)
;;

let var_use () =
  let%bind (_ : Pos.t) = expect Token.Percent in
  let%bind name = ident () in
  match%bind peek () with
  | Some (Token.Colon, _) ->
    let%bind type_ = parse_type_annotation () in
    let%bind () = record_var_type name type_ in
    return (Typed_var.create ~name ~type_)
  | _ ->
    let%map type_ = ensure_var_type name in
    Typed_var.create ~name ~type_
;;

let lit () =
  match%bind next () with
  | Token.Int i, _ -> return i
  | tok, pos -> fail (`Unexpected_token (tok, pos))
;;

let parse_signed_int () =
  match%bind peek () with
  | Some (Token.Minus, _) ->
    let%bind (_ : Pos.t) = expect Token.Minus in
    let%map value = lit () in
    Int64.(neg (of_int value))
  | _ ->
    let%map value = lit () in
    Int64.of_int value
;;

let rec parse_global_init () =
  match%bind peek () with
  | Some (Token.Ident word, _) when String.Caseless.equal word "zero" ->
    let%map (_ : string) = ident () in
    Global.Zero
  | Some (Token.L_paren, _) ->
    let%bind (_ : Pos.t) = expect Token.L_paren in
    let%bind elements =
      delimited0 ~delimiter:(expect Token.Comma) (parse_global_init ())
    in
    let%map (_ : Pos.t) = expect Token.R_paren in
    Global.Aggregate elements
  | Some (Token.Minus, _) ->
    let%bind (_ : Pos.t) = expect Token.Minus in
    (match%bind next () with
     | Token.Int i, _ -> return (Global.Int Int64.(neg (of_int i)))
     | Token.Float f, _ -> return (Global.Float (-.f))
     | tok, pos -> fail (`Unexpected_token (tok, pos)))
  | Some (Token.Float _, _) ->
    (match%bind next () with
     | Token.Float f, _ -> return (Global.Float f)
     | tok, pos -> fail (`Unexpected_token (tok, pos)))
  | _ ->
    let%map value = parse_signed_int () in
    Global.Int value
;;

let validate_global_init global =
  let type_error msg = fail_type_mismatch "%s" msg in
  let rec validate type_ init =
    match type_, init with
    | Type.Tuple fields, Global.Aggregate values ->
      if List.length fields <> List.length values
      then
        type_error
          (sprintf
             "aggregate initializer expects %d fields but got %d"
             (List.length fields)
             (List.length values))
      else
        List.fold2_exn fields values ~init:(return ()) ~f:(fun acc field init ->
          let%bind () = acc in
          validate field init)
    | Type.Tuple _, Global.Zero -> return ()
    | Type.Tuple _, _ ->
      type_error "aggregate globals must be initialized with aggregate or zero"
    | _, Global.Aggregate _ ->
      type_error "aggregate initializer requires aggregate global type"
    | _, Global.Zero -> return ()
    | _, Global.Int value ->
      if Type.is_integer type_
      then return ()
      else if Type.is_ptr type_
      then
        if Int64.(value = 0L)
        then return ()
        else type_error "pointer globals can only be initialized to zero"
      else type_error "integer initializer requires integer or pointer global"
    | _, Global.Float _ ->
      if Type.is_float type_
      then return ()
      else type_error "float initializer requires f32 or f64 global"
  in
  validate global.Global.type_ global.Global.init
;;

let lit_or_var () =
  match%bind peek () with
  | Some (Token.Int _, _) ->
    let%map i = lit () in
    Lit_or_var.Lit (Int64.of_int i)
  | Some (Token.Percent, _) ->
    let%map v = var_use () in
    Lit_or_var.Var v
  | Some (Token.At, _) ->
    let%bind name = global_name () in
    let%map global = ensure_global name in
    Lit_or_var.Global global
  | Some (tok, _) when is_sizeof_token tok -> parse_sizeof_literal ()
  | Some (tok, pos) -> fail (`Unexpected_token (tok, pos))
  | None -> fail `Unexpected_end_of_input
;;

let mem_operand () =
  match%bind peek () with
  | Some (Token.At, _) ->
    let%bind name = global_name () in
    let%map global = ensure_global name in
    Mem.Global global
  | _ ->
    let%map base = lit_or_var () in
    mem_of_lit_or_var base
;;

let lit_or_var_or_ident () =
  match%bind peek () with
  | Some (Token.Int _, _) ->
    let%map i = lit () in
    `Lit_or_var (Lit_or_var.Lit (Int64.of_int i))
  | Some (Token.Percent, _) ->
    let%map v = var_use () in
    `Lit_or_var (Lit_or_var.Var v)
  | Some (Token.At, _) ->
    let%bind name = global_name () in
    let%map global = ensure_global name in
    `Lit_or_var (Lit_or_var.Global global)
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
  ({ dest; src1; src2 } : _ Ir_helpers.arith)
;;

let branch () =
  match%bind lit_or_var_or_ident () with
  | `Ident label ->
    return [ Ir.branch (Uncond { Call_block.block = label; args = [] }) ]
  | `Lit_or_var cond ->
    let%bind (_ : Pos.t) = comma () in
    let%bind label1 = ident () in
    let%bind (_ : Pos.t) = comma () in
    let%map label2 = ident () in
    [ Ir.branch
        (Cond
           { cond
           ; if_true = { Call_block.block = label1; args = [] }
           ; if_false = { Call_block.block = label2; args = [] }
           })
    ]
;;

let instr' = function
  | "load" ->
    let%bind dest = var_decl () in
    let%bind (_ : Pos.t) = comma () in
    let%map src = mem_operand () in
    [ Ir.load dest src ]
  | "store" ->
    let%bind mem = mem_operand () in
    let%bind (_ : Pos.t) = comma () in
    let%map src = lit_or_var () in
    [ Ir.store src mem ]
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
    let%bind base = lit_or_var () in
    let%bind (_ : Pos.t) = comma () in
    let%bind type_ = parse_type_expr () in
    let%bind (_ : Pos.t) = comma () in
    let%map indices = parse_field_indices () in
    [ Ir.load_field { dest; base; type_; indices } ]
  | "store_field" ->
    let%bind base = lit_or_var () in
    let%bind (_ : Pos.t) = comma () in
    let%bind src = lit_or_var () in
    let%bind (_ : Pos.t) = comma () in
    let%bind type_ = parse_type_expr () in
    let%bind (_ : Pos.t) = comma () in
    let%map indices = parse_field_indices () in
    [ Ir.store_field { base; src; type_; indices } ]
  | "memcpy" ->
    let%bind dest = lit_or_var () in
    let%bind (_ : Pos.t) = comma () in
    let%bind src = lit_or_var () in
    let%bind (_ : Pos.t) = comma () in
    let%map type_ = parse_type_expr () in
    [ Ir.memcpy { dest; src; type_ } ]
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
      List.iter instrs ~f:(fun instr ->
        Vec.push state.State.current_instrs instr);
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
    let%bind state = get_state () in
    set_state
      { state with
        State.instrs_by_label = String.Map.empty
      ; labels = Vec.create ()
      ; current_block = "%root"
      ; current_instrs = Vec.create ()
      ; var_types = String.Table.create ()
      }
  in
  return func
;;

let parse_global_decl () =
  let%bind keyword = ident () in
  if not (String.Caseless.equal keyword "global")
  then fail (`Unexpected_token (Token.Ident keyword, Pos.create ~file:""))
  else (
    let%bind name = global_name () in
    let%bind (_ : Pos.t) = expect Token.Colon in
    let%bind type_ = parse_type_expr () in
    let%bind init =
      match%bind peek () with
      | Some (Token.Equal, _) ->
        let%bind (_ : Pos.t) = expect Token.Equal in
        parse_global_init ()
      | _ -> return Global.Zero
    in
    let global = { Global.name; type_; init } in
    let%bind () = validate_global_init global in
    let%map () = record_global global in
    global)
;;

let program_parser () =
  let%bind globals =
    let rec gather acc =
      match%bind peek () with
      | Some (Token.Ident "global", _) | Some (Token.Ident "GLOBAL", _) ->
        let%bind global = parse_global_decl () in
        gather (global :: acc)
      | _ -> return (List.rev acc)
    in
    gather []
  in
  let%map functions =
    exhaust (function_parser_with_reset ())
    >>| String.Map.of_list_with_key_exn ~get_key:Function.name
  in
  { Program.globals; functions }
;;

let parser () : (output, Pos.t, State.t, _) Parser_comb.parser =
  assume_root ()
  >>| (fun functions -> { Program.globals = []; functions })
  <|> program_parser ()
;;

let parse_string s =
  match Lexer.tokens ~file:"" s with
  | Error _ as e -> e
  | Ok tokens ->
    (match parser () (tokens, State.create ()) with
     | Error _ as e -> e
     | Ok (res, _) -> Ok res)
;;
