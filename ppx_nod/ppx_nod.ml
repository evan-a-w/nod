open Ppxlib
module Builder = Ast_builder.Default

let errorf ~loc fmt = Location.raise_errorf ~loc fmt
let with_loc _ f = f ()

let rec longident_to_list lid =
  match lid with
  | Lident name -> [ name ]
  | Ldot (prefix, name) -> longident_to_list prefix @ [ name ]
  | Lapply (_, arg) -> longident_to_list arg
;;

let longident_last lid =
  match List.rev (longident_to_list lid) with
  | last :: _ -> last
  | [] -> ""
;;

let is_ident_name expr name =
  match expr.pexp_desc with
  | Pexp_ident { txt = Lident id; _ } -> String.equal id name
  | _ -> false
;;

let return_arg expr =
  match expr.pexp_desc with
  | Pexp_apply (fn, [ (Nolabel, arg) ]) when is_ident_name fn "return" ->
    Some arg
  | _ -> None
;;

let label_application expr =
  match expr.pexp_desc with
  | Pexp_apply (fn, [ (Nolabel, arg) ]) when is_ident_name fn "label" ->
    let arg_expr =
      match arg.pexp_desc with
      | Pexp_ident { txt = Lident name; _ } ->
        Builder.estring ~loc:arg.pexp_loc name
      | Pexp_constant (Pconst_string _) -> arg
      | _ ->
        errorf
          ~loc:arg.pexp_loc
          "nod: label expects an identifier or string literal"
    in
    Some { expr with pexp_desc = Pexp_apply (fn, [ (Nolabel, arg_expr) ]) }
  | _ -> None
;;

let seq_arg expr =
  match expr.pexp_desc with
  | Pexp_apply (fn, [ (Nolabel, arg) ]) when is_ident_name fn "seq" -> Some arg
  | _ -> None
;;

let extract_named_let expr =
  match expr.pexp_desc with
  | Pexp_extension ({ txt = "named"; _ }, PStr [ item ]) ->
    (match item.pstr_desc with
     | Pstr_eval (inner, _) ->
       (match inner.pexp_desc with
        | Pexp_let (Immutable, Nonrecursive, [ binding ], body) ->
          Some (binding, body)
        | Pexp_let (Mutable, _, _, _) ->
          errorf ~loc:expr.pexp_loc "nod: let%%named does not support mutable"
        | Pexp_let (_, Recursive, _, _) ->
          errorf ~loc:expr.pexp_loc "nod: let%%named does not support rec"
        | _ ->
          errorf
            ~loc:expr.pexp_loc
            "nod: let%%named must be followed by a single let binding")
     | _ ->
       errorf
         ~loc:expr.pexp_loc
         "nod: let%%named must be followed by a let binding")
  | Pexp_extension ({ txt = "named"; _ }, _) ->
    errorf
      ~loc:expr.pexp_loc
      "nod: let%%named must be followed by a let binding"
  | _ -> None
;;

let rec pat_var_name pat =
  match pat.ppat_desc with
  | Ppat_var { txt = name; _ } -> Some name
  | Ppat_constraint (pat', _, _) -> pat_var_name pat'
  | _ -> None
;;

type arg_type =
  | I64
  | F64
  | Ptr

let is_atom_type lid =
  match List.rev (longident_to_list lid) with
  | "t" :: "Atom" :: _ -> true
  | _ -> false
;;

let rec arg_type_of_core_type ct =
  match ct.ptyp_desc with
  | Ptyp_constr ({ txt = lid; _ }, args) when is_atom_type lid ->
    (match args with
     | [ arg ] -> arg_type_of_core_type arg
     | _ ->
       errorf
         ~loc:ct.ptyp_loc
         "nod: Atom.t annotations must have exactly one type argument")
  | Ptyp_constr ({ txt = lid; _ }, []) ->
    (match longident_last lid with
     | "int64" -> I64
     | "float64" -> F64
     | "ptr" -> Ptr
     | other ->
       errorf ~loc:ct.ptyp_loc "nod: unsupported argument type %s" other)
  | _ -> errorf ~loc:ct.ptyp_loc "nod: unsupported argument type"
;;

let type_expr ~loc =
  function
  | I64 -> [%expr Nod_core.Type.I64]
  | F64 -> [%expr Nod_core.Type.F64]
  | Ptr -> [%expr Nod_core.Type.Ptr]
;;

type arg =
  { name : string
  ; type_ : arg_type
  ; var_name : string
  }

let arg_of_pat pat =
  let type_ =
    match pat.ppat_desc with
    | Ppat_constraint (_, ct_opt, _) ->
      (match ct_opt with
       | Some ct -> arg_type_of_core_type ct
       | None -> I64)
    | _ -> I64
  in
  match pat_var_name pat with
  | Some name ->
    { name
    ; type_
    ; var_name = gen_symbol ~prefix:("__nod_arg_" ^ name) ()
    }
  | None -> errorf ~loc:pat.ppat_loc "nod: function arguments must be variables"
;;

let add_name_argument ~loc name expr =
  match expr.pexp_desc with
  | Pexp_apply (fn, args) ->
    let name_expr = Builder.estring ~loc name in
    { expr with pexp_desc = Pexp_apply (fn, (Nolabel, name_expr) :: args) }
  | _ ->
    errorf ~loc:expr.pexp_loc "nod: let%%named expects a function application"
;;

let let_in ~loc pat expr body =
  let open Builder in
  pexp_let ~loc Nonrecursive [ value_binding ~loc ~pat ~expr ] body
;;

let rec translate ~add_instr expr =
  let loc = expr.pexp_loc in
  let open Builder in
  match extract_named_let expr with
  | Some (binding, body) ->
    let pat = binding.pvb_pat in
    let name =
      match pat_var_name pat with
      | Some name -> name
      | None ->
        errorf ~loc:pat.ppat_loc "nod: let%%named expects a variable pattern"
    in
    let instr_name = gen_symbol ~prefix:"__nod_instr" () in
    let rhs = add_name_argument ~loc name binding.pvb_expr in
    let bound_pat = ppat_tuple ~loc [ pat; pvar ~loc instr_name ] in
    let add_expr = [%expr [%e evar ~loc add_instr] [%e evar ~loc instr_name]] in
    let body_expr = translate ~add_instr body in
    with_loc loc (fun () ->
      [%expr
        let [%p bound_pat] = [%e rhs] in
        [%e add_expr];
        [%e body_expr]])
  | None ->
    (match expr.pexp_desc with
     | Pexp_let (Immutable, Nonrecursive, [ binding ], body) ->
       let pat = binding.pvb_pat in
       (match pat_var_name pat with
        | Some _ -> ()
        | None ->
          errorf
            ~loc:pat.ppat_loc
            "nod: let bindings must use a variable pattern");
       let instr_name = gen_symbol ~prefix:"__nod_instr" () in
       let rhs = binding.pvb_expr in
       let bound_pat = ppat_tuple ~loc [ pat; pvar ~loc instr_name ] in
       let add_expr =
         [%expr [%e evar ~loc add_instr] [%e evar ~loc instr_name]]
       in
       let body_expr = translate ~add_instr body in
       with_loc loc (fun () ->
         [%expr
           let [%p bound_pat] = [%e rhs] in
           [%e add_expr];
           [%e body_expr]])
     | Pexp_let (Mutable, _, _, _) ->
       errorf ~loc "nod: mutable let bindings are not supported"
     | Pexp_let (Immutable, Nonrecursive, _, _) ->
       errorf ~loc "nod: let bindings must be single bindings"
     | Pexp_let (_, Recursive, _, _) ->
       errorf ~loc "nod: recursive let bindings are not supported"
     | Pexp_sequence (e1, e2) ->
       let emit_expr = emit ~add_instr e1 in
       let body_expr = translate ~add_instr e2 in
       with_loc loc (fun () ->
         [%expr
           [%e emit_expr];
           [%e body_expr]])
     | _ ->
       (match return_arg expr with
        | Some arg ->
          let ret_name = gen_symbol ~prefix:"__nod_ret" () in
          let ret_pat = pvar ~loc ret_name in
          let ret_expr = evar ~loc ret_name in
          let add_expr =
            [%expr [%e evar ~loc add_instr] (return [%e ret_expr])]
          in
          with_loc loc (fun () ->
            [%expr
              let [%p ret_pat] = [%e arg] in
              [%e add_expr];
              [%e ret_expr]])
        | None -> errorf ~loc "nod: block must end with return"))

and emit ~add_instr expr =
  let loc = expr.pexp_loc in
  let open Builder in
  match extract_named_let expr with
  | Some _ -> errorf ~loc "nod: let%%named must be in tail position"
  | None ->
    (match return_arg expr with
     | Some _ -> errorf ~loc "nod: return must be in tail position"
     | None ->
       (match expr.pexp_desc with
        | Pexp_let _ | Pexp_sequence _ ->
          errorf ~loc "nod: expected instruction expression"
        | _ ->
          (match seq_arg expr with
           | Some instrs ->
             with_loc loc (fun () ->
               [%expr Core.List.iter [%e instrs] ~f:[%e evar ~loc add_instr]])
           | None ->
             let expr =
               match label_application expr with
               | Some label_expr -> label_expr
               | None -> expr
             in
             with_loc loc (fun () ->
               [%expr [%e evar ~loc add_instr] [%e expr]]))))
;;

let collect_fun expr =
  let param_pat param =
    match param.pparam_desc with
    | Pparam_val (Nolabel, None, pat) -> pat
    | Pparam_val (Nolabel, Some _, _) ->
      errorf
        ~loc:param.pparam_loc
        "nod: optional default arguments are not supported"
    | Pparam_val (Labelled _, _, _) ->
      errorf ~loc:param.pparam_loc "nod: labelled arguments are not supported"
    | Pparam_val (Optional _, _, _) ->
      errorf ~loc:param.pparam_loc "nod: optional arguments are not supported"
    | Pparam_newtype _ ->
      errorf ~loc:param.pparam_loc "nod: newtype arguments are not supported"
  in
  let body_expr_of_function ~loc = function
    | Pfunction_body expr -> expr
    | Pfunction_cases _ ->
      errorf ~loc "nod: function cases are not supported"
  in
  let rec go acc expr =
    match expr.pexp_desc with
    | Pexp_function (params, fn_constraint, body) ->
      (match fn_constraint.ret_type_constraint with
       | None -> ()
       | Some _ ->
         errorf
           ~loc:expr.pexp_loc
           "nod: function return type constraints are not supported");
      let params = List.map param_pat params in
      let acc = List.rev_append params acc in
      let body_expr = body_expr_of_function ~loc:expr.pexp_loc body in
      go acc body_expr
    | _ -> List.rev acc, expr
  in
  go [] expr
;;

let fn_name_of_loc loc =
  let pos = loc.loc_start in
  let line = pos.pos_lnum in
  let col = pos.pos_cnum - pos.pos_bol in
  Printf.sprintf "nod_fn_%d_%d" line col
;;

let expand_block expr =
  let loc = expr.pexp_loc in
  let open Builder in
  let instrs_ref = gen_symbol ~prefix:"__nod_instrs" () in
  let add_instr = gen_symbol ~prefix:"__nod_add" () in
  let instrs = gen_symbol ~prefix:"__nod_instrs_list" () in
  let body_expr = translate ~add_instr expr in
  let add_binding =
    [%expr
      fun instr ->
        [%e evar ~loc instrs_ref] := instr :: ![%e evar ~loc instrs_ref]]
  in
  let body =
    let_in
      ~loc
      (pvar ~loc instrs_ref)
      [%expr ref []]
      (let_in
         ~loc
         (pvar ~loc add_instr)
         add_binding
         (let_in
            ~loc
            (ppat_any ~loc)
            body_expr
            (let_in
               ~loc
               (pvar ~loc instrs)
               [%expr Core.List.rev ![%e evar ~loc instrs_ref]]
               (evar ~loc instrs))))
  in
  [%expr
    let open Dsl in
    [%e body]]
;;

let expand_fn expr =
  let loc = expr.pexp_loc in
  let open Builder in
  let args, body_expr = collect_fun expr in
  let args = List.map arg_of_pat args in
  let instrs_ref = gen_symbol ~prefix:"__nod_instrs" () in
  let add_instr = gen_symbol ~prefix:"__nod_add" () in
  let instrs = gen_symbol ~prefix:"__nod_instrs_list" () in
  let ret = gen_symbol ~prefix:"__nod_ret" () in
  let unnamed = gen_symbol ~prefix:"__nod_unnamed" () in
  let body_expr = translate ~add_instr body_expr in
  let add_binding =
    [%expr
      fun instr ->
        [%e evar ~loc instrs_ref] := instr :: ![%e evar ~loc instrs_ref]]
  in
  let const_expr =
    [%expr
      Fn.Unnamed.const_with_return [%e evar ~loc ret] [%e evar ~loc instrs]]
  in
  let unnamed_expr =
    List.fold_left
      (fun acc arg ->
        [%expr Fn.Unnamed.with_arg [%e acc] [%e evar ~loc arg.var_name]])
      const_expr
      args
  in
  let fn_expr =
    let fn_name = fn_name_of_loc loc in
    [%expr
      Fn.create ~name:[%e estring ~loc fn_name] ~unnamed:[%e evar ~loc unnamed]]
  in
  let builder_body =
    let_in
      ~loc
      (pvar ~loc instrs_ref)
      [%expr ref []]
      (let_in
         ~loc
         (pvar ~loc add_instr)
         add_binding
         (let_in
            ~loc
            (pvar ~loc ret)
            body_expr
            (let_in
               ~loc
               (pvar ~loc instrs)
               [%expr Core.List.rev ![%e evar ~loc instrs_ref]]
               (let_in ~loc (pvar ~loc unnamed) unnamed_expr fn_expr))))
  in
  let with_args =
    List.fold_right
      (fun arg acc ->
        let var_expr =
          [%expr
            Nod_core.Var.create
              ~name:[%e estring ~loc arg.name]
              ~type_:[%e type_expr ~loc arg.type_]]
        in
        let atom_expr = [%expr var [%e evar ~loc arg.var_name]] in
        let acc = let_in ~loc (pvar ~loc arg.name) atom_expr acc in
        let_in ~loc (pvar ~loc arg.var_name) var_expr acc)
      args
      builder_body
  in
  [%expr
    let open Dsl in
    [%e with_args]]
;;

let expand_nod ~loc:_ ~path:_ expr =
  let args, _body = collect_fun expr in
  match args with
  | [] -> expand_block expr
  | _ -> expand_fn expr
;;

let nod_extension =
  Extension.declare
    "nod"
    Extension.Context.Expression
    Ast_pattern.(single_expr_payload __)
    expand_nod
;;

let () =
  Driver.register_transformation
    "ppx_nod"
    ~rules:[ Context_free.Rule.extension nod_extension ]
;;
