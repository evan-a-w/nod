open! Core
open Ppxlib
open Ast_builder.Default

let ir_builder_mod = "Nod_core.Ir_builder"
let no_nod_name = "no_nod"
let lid ?(loc = Location.none) s = Located.mk ~loc (Longident.parse s)
let evar_lid ~loc name = pexp_ident ~loc (lid ~loc name)
let type_ast_mod = ir_builder_mod ^ ".Type_ast"
let type_ast_ctor ~loc name arg = pexp_construct ~loc (lid ~loc name) arg

let rec translate_type (ct : core_type) =
  let loc = ct.ptyp_loc in
  match ct.ptyp_desc with
  | Ptyp_constr ({ txt = Lident "i8"; _ }, [])
  | Ptyp_constr ({ txt = Lident "int8"; _ }, []) ->
    type_ast_ctor ~loc (type_ast_mod ^ ".Atom") (Some (estring ~loc "i8"))
  | Ptyp_constr ({ txt = Lident "i16"; _ }, [])
  | Ptyp_constr ({ txt = Lident "int16"; _ }, []) ->
    type_ast_ctor ~loc (type_ast_mod ^ ".Atom") (Some (estring ~loc "i16"))
  | Ptyp_constr ({ txt = Lident "i32"; _ }, [])
  | Ptyp_constr ({ txt = Lident "int32"; _ }, []) ->
    type_ast_ctor ~loc (type_ast_mod ^ ".Atom") (Some (estring ~loc "i32"))
  | Ptyp_constr ({ txt = Lident "i64"; _ }, [])
  | Ptyp_constr ({ txt = Lident "int64"; _ }, []) ->
    type_ast_ctor ~loc (type_ast_mod ^ ".Atom") (Some (estring ~loc "i64"))
  | Ptyp_constr ({ txt = Lident "f32"; _ }, [])
  | Ptyp_constr ({ txt = Lident "float32"; _ }, []) ->
    type_ast_ctor ~loc (type_ast_mod ^ ".Atom") (Some (estring ~loc "f32"))
  | Ptyp_constr ({ txt = Lident "f64"; _ }, [])
  | Ptyp_constr ({ txt = Lident "float64"; _ }, []) ->
    type_ast_ctor ~loc (type_ast_mod ^ ".Atom") (Some (estring ~loc "f64"))
  | Ptyp_constr ({ txt = Lident "ptr"; _ }, []) ->
    type_ast_ctor ~loc (type_ast_mod ^ ".Atom") (Some (estring ~loc "ptr"))
  | Ptyp_constr ({ txt = Lident "ptr"; _ }, [ inner ]) ->
    type_ast_ctor ~loc (type_ast_mod ^ ".Ptr") (Some (translate_type inner))
  | Ptyp_tuple elements ->
    let items =
      ListLabels.map elements ~f:(fun (_label, ty) -> translate_type ty)
    in
    type_ast_ctor ~loc (type_ast_mod ^ ".Tuple") (Some (elist ~loc items))
  | _ -> Location.raise_errorf ~loc "unsupported type annotation for nod"
;;

let parse_typed_pattern pat =
  match pat.ppat_desc with
  | Ppat_constraint (inner, Some typ, _) ->
    (match inner.ppat_desc with
     | Ppat_var { txt; loc } -> txt, loc, translate_type typ, typ
     | _ -> Location.raise_errorf ~loc:pat.ppat_loc "expected variable binding")
  | Ppat_constraint (_, None, _) ->
    Location.raise_errorf ~loc:pat.ppat_loc "type annotation missing"
  | _ ->
    Location.raise_errorf ~loc:pat.ppat_loc "expected (name : type) pattern"
;;

let is_ident expr name =
  match expr.pexp_desc with
  | Pexp_ident { txt = Lident ident; _ } -> String.equal ident name
  | _ -> false
;;

let classify_label expr =
  match expr.pexp_desc with
  | Pexp_apply (fn, [ (_, arg) ]) when is_ident fn "label" ->
    (match arg.pexp_desc with
     | Pexp_ident { txt = Lident name; loc } -> Some (name, loc)
     | _ -> Location.raise_errorf ~loc:arg.pexp_loc "label expects identifier")
  | _ -> None
;;

let builder_fun ~loc fn =
  evar_lid ~loc (Printf.sprintf "%s.%s" ir_builder_mod fn)
;;

let expr_payload ~loc ~name payload =
  match payload with
  | PStr [ { pstr_desc = Pstr_eval (expr, _); _ } ] -> expr
  | _ -> Location.raise_errorf ~loc "%s expects an expression payload" name
;;

let add_name_arg expr name_expr =
  match expr.pexp_desc with
  | Pexp_apply (fn, args) ->
    { expr with pexp_desc = Pexp_apply (fn, (Nolabel, name_expr) :: args) }
  | _ -> { expr with pexp_desc = Pexp_apply (expr, [ Nolabel, name_expr ]) }
;;

let expand_named expr =
  match expr.pexp_desc with
  | Pexp_let (Immutable, Nonrecursive, [ vb ], body) ->
    (match vb.pvb_pat.ppat_desc with
     | Ppat_var { txt = name; loc } ->
       let name_expr = estring ~loc name in
       let rhs = add_name_arg vb.pvb_expr name_expr in
       let vb = { vb with pvb_expr = rhs } in
       { expr with
         pexp_desc = Pexp_let (Immutable, Nonrecursive, [ vb ], body)
       }
     | _ ->
       Location.raise_errorf
         ~loc:vb.pvb_pat.ppat_loc
         "let%%named expects a name")
  | _ -> Location.raise_errorf ~loc:expr.pexp_loc "let%%named expects a let"
;;

let rec translate builder expr =
  match expr.pexp_desc with
  | Pexp_extension ({ txt; loc }, payload) when String.equal txt no_nod_name ->
    expr_payload ~loc ~name:no_nod_name payload
  | Pexp_extension ({ txt; loc }, payload) when String.equal txt "named" ->
    expr_payload ~loc ~name:"named" payload |> expand_named |> translate builder
  | Pexp_sequence (lhs, rhs) -> translate_sequence builder lhs rhs
  | Pexp_let (mut_flag, rec_flag, bindings, body) ->
    let bindings' =
      List.map bindings ~f:(fun vb ->
        { vb with pvb_expr = translate builder vb.pvb_expr })
    in
    let body' = translate builder body in
    { expr with pexp_desc = Pexp_let (mut_flag, rec_flag, bindings', body') }
  | _ -> translate_statement builder expr

and translate_sequence builder lhs rhs =
  let loc = lhs.pexp_loc in
  match classify_label lhs with
  | Some (name, label_loc) ->
    let pat = ppat_var ~loc:label_loc { txt = name; loc = label_loc } in
    let label_call =
      [%expr
        [%e builder_fun ~loc:label_loc "enter_label"]
          [%e builder]
          ~name:[%e estring ~loc:label_loc name]]
    in
    [%expr
      let [%p pat] = [%e label_call] in
      [%e translate builder rhs]]
  | None ->
    [%expr
      [%e translate builder lhs];
      [%e translate builder rhs]]

and translate_statement builder expr =
  let loc = expr.pexp_loc in
  match expr.pexp_desc with
  | Pexp_apply (fn, args) when is_ident fn "return" ->
    (match args with
     | [ (_, value) ] ->
       [%expr [%e builder_fun ~loc "return"] [%e builder] [%e value]]
     | _ ->
       Location.raise_errorf ~loc:expr.pexp_loc "return expects one argument")
  | Pexp_apply (fn, args) when is_ident fn "b" ->
    translate_goto builder expr args
  | Pexp_apply (fn, args) when is_ident fn "br" ->
    translate_branch builder expr args
  | Pexp_apply (fn, [ (_, seq_expr) ]) when is_ident fn "seq" ->
    [%expr [%e builder_fun ~loc "emit_many"] [%e builder] [%e seq_expr]]
  | Pexp_ident { txt = Lident "unreachable"; _ } ->
    [%expr [%e builder_fun ~loc "unreachable"] [%e builder]]
  | Pexp_apply (fn, []) when is_ident fn "unreachable" ->
    [%expr [%e builder_fun ~loc "unreachable"] [%e builder]]
  | _ -> expr

and translate_goto builder expr args =
  let loc = expr.pexp_loc in
  match args with
  | [ (_, label) ] ->
    [%expr [%e builder_fun ~loc "goto"] [%e builder] [%e label] ~args:[]]
  | [ (_, label); (_, params) ] ->
    [%expr
      [%e builder_fun ~loc "goto"] [%e builder] [%e label] ~args:[%e params]]
  | _ -> Location.raise_errorf ~loc "b expects label and optional args"

and translate_branch builder expr args =
  let loc = expr.pexp_loc in
  match args with
  | [ (_, cond); (_, t_label); (_, f_label) ] ->
    [%expr
      [%e builder_fun ~loc "branch"]
        [%e builder]
        ~cond:[%e cond]
        ~if_true:[%e t_label]
        ~if_false:[%e f_label]
        ~args_true:[]
        ~args_false:[]]
  | _ -> Location.raise_errorf ~loc "br expects cond, true label, false label"
;;

let rec parse_name_pat pat =
  match pat.ppat_desc with
  | Ppat_constant (Pconst_string (name, _, _)) -> estring ~loc:pat.ppat_loc name
  | Ppat_var { txt; loc } -> evar ~loc txt
  | Ppat_constraint (inner, _, _) -> parse_name_pat inner
  | _ ->
    Location.raise_errorf ~loc:pat.ppat_loc "function name must be a string"
;;

let parse_name_param param =
  match param.pparam_desc with
  | Pparam_val (Nolabel, None, pat) -> parse_name_pat pat
  | _ ->
    Location.raise_errorf
      ~loc:param.pparam_loc
      "function name must be an unlabeled string parameter"
;;

let rec collect_fun_args expr ~name_opt acc_rev =
  match expr.pexp_desc with
  | Pexp_function (params, _, Pfunction_body body) ->
    let name_opt, params =
      match name_opt with
      | Some name_expr -> Some name_expr, params
      | None ->
        (match params with
         | name_param :: rest -> Some (parse_name_param name_param), rest
         | [] ->
           Location.raise_errorf
             ~loc:expr.pexp_loc
             "function requires a leading name string")
    in
    let new_args =
      List.map
        ~f:(fun param ->
          match param.pparam_desc with
          | Pparam_val (Nolabel, None, pat) -> parse_typed_pattern pat
          | _ ->
            Location.raise_errorf
              ~loc:param.pparam_loc
              "unsupported parameter kind")
        params
    in
    let acc_rev = List.rev_append new_args acc_rev in
    collect_fun_args body ~name_opt acc_rev
  | Pexp_function (_, _, Pfunction_cases _) ->
    Location.raise_errorf ~loc:expr.pexp_loc "function cases are not supported"
  | _ ->
    let name_expr =
      match name_opt with
      | Some name_expr -> name_expr
      | None ->
        Location.raise_errorf
          ~loc:expr.pexp_loc
          "function requires a leading name string"
    in
    name_expr, List.rev acc_rev, expr
;;

let expand_fun expr =
  let name_expr, args, body = collect_fun_args expr ~name_opt:None [] in
  let loc = expr.pexp_loc in
  let builder_name = gen_symbol ~prefix:"__nod_builder" () in
  let builder_pat = ppat_var ~loc { txt = builder_name; loc } in
  let builder_expr = evar ~loc builder_name in
  let body_expr = translate builder_expr body in
  let body_with_args =
    ListLabels.fold_right
      args
      ~init:body_expr
      ~f:(fun (name, loc, ty, _ty) acc ->
        let pat = ppat_var ~loc { txt = name; loc } in
        let type_expr =
          [%expr
            [%e evar_lid ~loc (Printf.sprintf "%s.type_of_ast" ir_builder_mod)]
              [%e ty]]
        in
        let arg_var =
          [%expr
            [%e builder_fun ~loc "add_arg"]
              [%e builder_expr]
              ~name:[%e estring ~loc name]
              ~type_:[%e type_expr]]
        in
        let arg_atom = [%expr Dsl.var [%e arg_var]] in
        [%expr
          let [%p pat] = [%e arg_atom] in
          [%e acc]])
  in
  let atom_type ty = ptyp_constr ~loc (lid ~loc "Atom.t") [ ty ] in
  let args_type =
    match
      ListLabels.map args ~f:(fun (_name, _loc, _ty, ty_core) ->
        atom_type ty_core)
    with
    | [] -> ptyp_constr ~loc (lid ~loc "unit") []
    | [ only ] -> only
    | items -> ptyp_tuple ~loc items
  in
  let ret_var = gen_symbol ~prefix:"ret" () in
  let ret_type = ptyp_var ~loc ret_var in
  let fn_type = ptyp_constr ~loc (lid ~loc "Fn.t") [ args_type; ret_type ] in
  let fn_expr =
    [%expr
      let fn_name = [%e name_expr] in
      let [%p builder_pat] = [%e builder_fun ~loc "create_function"] () in
      [%e evar_lid ~loc "Dsl.with_builder"] [%e builder_expr] (fun () ->
        [%e body_with_args]);
      let fn =
        [%e builder_fun ~loc "finish_function"] [%e builder_expr] ~name:fn_name
      in
      Dsl.Fn.of_function fn]
  in
  pexp_constraint ~loc fn_expr fn_type
;;

let expand_block expr =
  let loc = expr.pexp_loc in
  let builder_name = gen_symbol ~prefix:"__nod_builder" () in
  let builder_pat = ppat_var ~loc { txt = builder_name; loc } in
  let builder_expr = evar ~loc builder_name in
  let body_expr = translate builder_expr expr in
  [%expr
    let [%p builder_pat] = [%e builder_fun ~loc "create_block"] () in
    [%e evar_lid ~loc "Dsl.with_builder"] [%e builder_expr] (fun () ->
      [%e body_expr]);
    [%e builder_fun ~loc "finish_block"] [%e builder_expr]]
;;

let expand expr =
  let expanded =
    match expr.pexp_desc with
    | Pexp_function _ -> expand_fun expr
    | _ -> expand_block expr
  in
  let loc = expanded.pexp_loc in
  let open_decl =
    { popen_expr = pmod_ident ~loc (lid ~loc "Dsl")
    ; popen_override = Override
    ; popen_loc = loc
    ; popen_attributes = []
    }
  in
  pexp_open ~loc open_decl expanded
;;

let extension =
  Extension.declare
    "nod"
    Expression
    Ast_pattern.(single_expr_payload __)
    (fun ~loc:_ ~path:_ expr -> expand expr)
;;

let no_nod_extension =
  Extension.declare
    no_nod_name
    Expression
    Ast_pattern.(single_expr_payload __)
    (fun ~loc:_ ~path:_ expr -> expr)
;;

let () =
  Driver.register_transformation
    ~extensions:[ extension; no_nod_extension ]
    "ppx_nod_ir"
;;
