open Ppxlib
open Ast_builder.Default

let ir_builder_mod = "Nod_core.Ir_builder"

let lid ?(loc = Location.none) s = Located.mk ~loc (Longident.parse s)

let evar_lid ~loc name = pexp_ident ~loc (lid ~loc name)

let type_ast_mod = ir_builder_mod ^ ".Type_ast"

let type_ast_ctor ~loc name arg = pexp_construct ~loc (lid ~loc name) arg

let rec translate_type (ct : core_type) =
  let loc = ct.ptyp_loc in
  match ct.ptyp_desc with
  | Ptyp_constr ({ txt = Lident "i8"; _ }, []) ->
    type_ast_ctor ~loc (type_ast_mod ^ ".Atom") (Some (estring ~loc "i8"))
  | Ptyp_constr ({ txt = Lident "i16"; _ }, []) ->
    type_ast_ctor ~loc (type_ast_mod ^ ".Atom") (Some (estring ~loc "i16"))
  | Ptyp_constr ({ txt = Lident "i32"; _ }, []) ->
    type_ast_ctor ~loc (type_ast_mod ^ ".Atom") (Some (estring ~loc "i32"))
  | Ptyp_constr ({ txt = Lident "i64"; _ }, []) ->
    type_ast_ctor ~loc (type_ast_mod ^ ".Atom") (Some (estring ~loc "i64"))
  | Ptyp_constr ({ txt = Lident "f32"; _ }, []) ->
    type_ast_ctor ~loc (type_ast_mod ^ ".Atom") (Some (estring ~loc "f32"))
  | Ptyp_constr ({ txt = Lident "f64"; _ }, []) ->
    type_ast_ctor ~loc (type_ast_mod ^ ".Atom") (Some (estring ~loc "f64"))
  | Ptyp_constr ({ txt = Lident "ptr"; _ }, []) ->
    type_ast_ctor ~loc (type_ast_mod ^ ".Atom") (Some (estring ~loc "ptr"))
  | Ptyp_constr ({ txt = Lident "ptr"; _ }, [ inner ]) ->
    type_ast_ctor
      ~loc
      (type_ast_mod ^ ".Ptr")
      (Some (translate_type inner))
  | Ptyp_tuple elements ->
    let items =
      ListLabels.map elements ~f:(fun (_label, ty) -> translate_type ty)
    in
    type_ast_ctor
      ~loc
      (type_ast_mod ^ ".Tuple")
      (Some (elist ~loc items))
  | _ -> Location.raise_errorf ~loc "unsupported type annotation for nod"

let parse_typed_pattern pat =
  match pat.ppat_desc with
  | Ppat_constraint (inner, Some typ, _) ->
    (match inner.ppat_desc with
     | Ppat_var { txt; loc } -> txt, loc, translate_type typ
     | _ -> Location.raise_errorf ~loc:pat.ppat_loc "expected variable binding")
  | Ppat_constraint (_, None, _) ->
    Location.raise_errorf ~loc:pat.ppat_loc "type annotation missing"
  | _ -> Location.raise_errorf ~loc:pat.ppat_loc "expected (name : type) pattern"

let is_ident expr name =
  match expr.pexp_desc with
  | Pexp_ident { txt = Lident ident; _ } -> String.equal ident name
  | _ -> false

let classify_label expr =
  match expr.pexp_desc with
  | Pexp_apply (fn, [ (_, arg) ]) when is_ident fn "label" ->
    (match arg.pexp_desc with
     | Pexp_ident { txt = Lident name; loc } -> Some (name, loc)
     | _ -> Location.raise_errorf ~loc:arg.pexp_loc "label expects identifier")
  | _ -> None

let builder_fun ~loc fn = evar_lid ~loc (Printf.sprintf "%s.%s" ir_builder_mod fn)

let rec translate builder expr =
  match expr.pexp_desc with
  | Pexp_sequence (lhs, rhs) -> translate_sequence builder lhs rhs
  | Pexp_let (Immutable, Nonrecursive, [ vb ], body) ->
    (match parse_typed_pattern vb.pvb_pat with
     | exception Location.Error _ ->
       let body' = translate builder body in
       { expr with pexp_desc = Pexp_let (Immutable, Nonrecursive, [ vb ], body') }
     | name, loc, type_ast -> translate_let builder ~name ~loc ~type_ast vb body)
  | Pexp_let (mut_flag, rec_flag, bindings, body) ->
    let body' = translate builder body in
    { expr with pexp_desc = Pexp_let (mut_flag, rec_flag, bindings, body') }
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

and translate_let builder ~name ~loc ~type_ast vb body =
  let pat = ppat_var ~loc { txt = name; loc } in
  let name_expr = estring ~loc name in
  let type_expr =
    [%expr
      [%e evar_lid ~loc (Printf.sprintf "%s.type_of_ast" ir_builder_mod)]
        [%e type_ast]]
  in
  let new_var =
    [%expr
      [%e builder_fun ~loc "new_var"]
        [%e builder]
        ~name:[%e name_expr]
        ~type_:[%e type_expr]]
  in
  let dest = evar ~loc name in
  let instr_expr =
    [%expr
      let instr = [%e vb.pvb_expr] ~dest:[%e dest] in
      [%e builder_fun ~loc "emit"] [%e builder] instr]
  in
  [%expr
    let [%p pat] = [%e new_var] in
    [%e instr_expr];
    [%e translate builder body]]

and translate_statement builder expr =
  let loc = expr.pexp_loc in
  match expr.pexp_desc with
  | Pexp_apply (fn, args) when is_ident fn "return" ->
    (match args with
     | [ (_, value) ] ->
       [%expr [%e builder_fun ~loc "return"] [%e builder] [%e value]]
     | _ -> Location.raise_errorf ~loc:expr.pexp_loc "return expects one argument")
  | Pexp_apply (fn, args) when is_ident fn "b" -> translate_goto builder expr args
  | Pexp_apply (fn, args) when is_ident fn "br" -> translate_branch builder expr args
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
  | [ (_, label ); (_, params) ] ->
    [%expr [%e builder_fun ~loc "goto"] [%e builder] [%e label] ~args:[%e params]]
  | _ -> Location.raise_errorf ~loc "b expects label and optional args"

and translate_branch builder expr args =
  let loc = expr.pexp_loc in
  match args with
  | [ (_, cond ); (_, t_label ); (_, f_label ) ] ->
    [%expr
      [%e builder_fun ~loc "branch"]
        [%e builder]
        ~cond:[%e cond]
        ~if_true:[%e t_label]
        ~if_false:[%e f_label]
        ~args_true:[]
        ~args_false:[]]
  | _ -> Location.raise_errorf ~loc "br expects cond, true label, false label"

let rec collect_fun_args expr acc_rev =
  match expr.pexp_desc with
  | Pexp_function (params, _, Pfunction_body body) ->
    let new_args =
      List.map
        (fun param ->
          match param.pparam_desc with
          | Pparam_val (Nolabel, None, pat) -> parse_typed_pattern pat
          | _ ->
            Location.raise_errorf ~loc:param.pparam_loc "unsupported parameter kind")
        params
    in
    let acc_rev = List.rev_append new_args acc_rev in
    collect_fun_args body acc_rev
  | Pexp_function (_, _, Pfunction_cases _) ->
    Location.raise_errorf ~loc:expr.pexp_loc "function cases are not supported"
  | _ -> List.rev acc_rev, expr

let expand_fun expr =
  let args, body = collect_fun_args expr [] in
  let loc = expr.pexp_loc in
  let builder_name = gen_symbol ~prefix:"__nod_builder" () in
  let builder_pat = ppat_var ~loc { txt = builder_name; loc } in
  let builder_expr = evar ~loc builder_name in
  let body_expr = translate builder_expr body in
  let body_with_args =
    ListLabels.fold_right args ~init:body_expr ~f:(fun (name, loc, ty) acc ->
      let pat = ppat_var ~loc { txt = name; loc } in
      let type_expr =
        [%expr
          [%e evar_lid ~loc (Printf.sprintf "%s.type_of_ast" ir_builder_mod)]
            [%e ty]]
      in
      let arg_expr =
        [%expr
          [%e builder_fun ~loc "add_arg"]
          [%e builder_expr]
          ~name:[%e estring ~loc name]
          ~type_:[%e type_expr]]
      in
      [%expr let [%p pat] = [%e arg_expr] in [%e acc]])
  in
  [%expr
    fun ~name ->
      let [%p builder_pat] = [%e builder_fun ~loc "create_function"] () in
      [%e body_with_args];
      [%e builder_fun ~loc "finish_function"] [%e builder_expr] ~name]

let expand_block expr =
  let loc = expr.pexp_loc in
  let builder_name = gen_symbol ~prefix:"__nod_builder" () in
  let builder_pat = ppat_var ~loc { txt = builder_name; loc } in
  let builder_expr = evar ~loc builder_name in
  let body_expr = translate builder_expr expr in
  [%expr
    let [%p builder_pat] = [%e builder_fun ~loc "create_block"] () in
    [%e body_expr];
    [%e builder_fun ~loc "finish_block"] [%e builder_expr]]

let expand expr =
  match expr.pexp_desc with
  | Pexp_function _ -> expand_fun expr
  | _ -> expand_block expr

let extension =
  Extension.declare
    "nod"
    Expression
    Ast_pattern.(single_expr_payload __)
    (fun ~loc:_ ~path:_ expr -> expand expr)

let () = Driver.register_transformation ~extensions:[ extension ] "ppx_nod_ir"
