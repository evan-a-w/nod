open Ppxlib
module Builder = Ast_builder.Default
open Util

let with_loc _ f = f ()

module Embed = struct
  let delete_file path =
    if Sys.file_exists path
    then (
      try Sys.remove path with
      | Sys_error _ -> ())
  ;;

  let cleanup_files ml_file exe_file =
    delete_file ml_file;
    delete_file exe_file;
    if Filename.check_suffix ml_file ".ml"
    then (
      let base = Filename.chop_suffix ml_file ".ml" in
      delete_file (base ^ ".cmi");
      delete_file (base ^ ".cmo"))
  ;;

  let process_status_to_string = function
    | Unix.WEXITED code -> Printf.sprintf "exit status %d" code
    | Unix.WSIGNALED signal -> Printf.sprintf "signal %d" signal
    | Unix.WSTOPPED signal -> Printf.sprintf "stopped %d" signal
  ;;

  let run_command ~loc prog args =
    let argv = Array.of_list (prog :: args) in
    try
      let pid =
        Unix.create_process prog argv Unix.stdin Unix.stdout Unix.stderr
      in
      match Unix.waitpid [] pid with
      | _, Unix.WEXITED 0 -> ()
      | _, status ->
        errorf
          ~loc
          "nod: command %s failed (%s)"
          prog
          (process_status_to_string status)
    with
    | Unix.Unix_error (Unix.ENOENT, _, _) ->
      errorf ~loc "nod: command %s not found" prog
  ;;

  let read_all_channel ic =
    let buffer = Buffer.create 128 in
    (try
       while true do
         Buffer.add_channel buffer ic 1024
       done
     with
     | End_of_file -> ());
    Buffer.contents buffer
  ;;

  let capture_output ~loc prog args =
    let argv = Array.of_list (prog :: args) in
    let env = Unix.environment () in
    try
      let stdout_ic, stdin_oc, stderr_ic =
        Unix.open_process_args_full prog argv env
      in
      close_out stdin_oc;
      let stdout = read_all_channel stdout_ic in
      let stderr = read_all_channel stderr_ic in
      match Unix.close_process_full (stdout_ic, stdin_oc, stderr_ic) with
      | Unix.WEXITED 0 -> stdout
      | status ->
        errorf
          ~loc
          "nod: command %s failed (%s)%s"
          prog
          (process_status_to_string status)
          (if String.length stderr = 0 then "" else Printf.sprintf "\n%s" stderr)
    with
    | Unix.Unix_error (Unix.ENOENT, _, _) ->
      errorf ~loc "nod: command %s not found" prog
  ;;

  let eval_expression ~loc expr =
    let expr_source = Format.asprintf "%a" Pprintast.expression expr in
    let ml_file, oc = Filename.open_temp_file "ppx_embed" ".ml" in
    let exe_file = Filename.temp_file "ppx_embed" "" in
    Fun.protect
      ~finally:(fun () -> cleanup_files ml_file exe_file)
      (fun () ->
        (try
           output_string
             oc
             (Printf.sprintf
                "open Core\n\n\
                 let () =\n\
                \  let result = (let open Core in (%s)) in\n\
                \  Stdlib.print_string result;\n\
                \  Stdlib.flush Stdlib.stdout\n"
                expr_source);
           close_out oc
         with
         | exn ->
           close_out_noerr oc;
           raise exn);
        run_command
          ~loc
          "ocamlfind"
          [ "ocamlc"; "-linkpkg"; "-package"; "core"; ml_file; "-o"; exe_file ];
        capture_output ~loc exe_file [])
  ;;

  let parse_structure ~loc contents =
    let lexbuf = Lexing.from_string contents in
    lexbuf.lex_curr_p
    <- { loc.loc_start with pos_fname = loc.loc_start.pos_fname };
    try Parse.implementation lexbuf with
    | exn ->
      let msg = Printexc.to_string exn in
      errorf ~loc "nod: %%embed produced invalid structure (%s)" msg
  ;;

  let parse_signature ~loc contents =
    let lexbuf = Lexing.from_string contents in
    lexbuf.lex_curr_p
    <- { loc.loc_start with pos_fname = loc.loc_start.pos_fname };
    try Parse.interface lexbuf with
    | exn ->
      let msg = Printexc.to_string exn in
      errorf ~loc "nod: %%embed produced invalid signature (%s)" msg
  ;;

  let expand_structure ~ctxt expr =
    let loc = Expansion_context.Extension.extension_point_loc ctxt in
    let contents = eval_expression ~loc expr in
    let structure = parse_structure ~loc contents in
    let include_infos =
      Builder.include_infos ~loc (Builder.pmod_structure ~loc structure)
    in
    Builder.pstr_include ~loc include_infos
  ;;

  let expand_signature ~ctxt expr =
    let loc = Expansion_context.Extension.extension_point_loc ctxt in
    let contents = eval_expression ~loc expr in
    let signature = parse_signature ~loc contents in
    let include_infos =
      Builder.include_infos ~loc (Builder.Latest.pmty_signature ~loc signature)
    in
    Builder.psig_include ~loc include_infos
  ;;
end

let is_ident_name expr name =
  match expr.pexp_desc with
  | Pexp_ident { txt = Lident id; _ } -> String.equal id name
  | _ -> false
;;

let rec unwrap_no_nod expr =
  match expr.pexp_desc with
  | Pexp_apply (fn, [ (Nolabel, inner) ]) when is_ident_name fn "!" ->
    let inner, _ = unwrap_no_nod inner in
    inner, true
  | Pexp_extension ({ txt = "no_nod"; _ }, PStr [ item ]) ->
    (match item.pstr_desc with
     | Pstr_eval (inner, _) ->
       let inner, _ = unwrap_no_nod inner in
       inner, true
     | _ ->
       errorf
         ~loc:expr.pexp_loc
         "nod: %%no_nod must contain an expression payload")
  | Pexp_extension ({ txt = "no_nod"; _ }, _) ->
    errorf ~loc:expr.pexp_loc "nod: %%no_nod must contain an expression payload"
  | _ -> expr, false
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
    Some { expr with pexp_desc = Pexp_apply (fn, [ Nolabel, arg_expr ]) }
  | _ -> None
;;

let seq_arg expr =
  match expr.pexp_desc with
  | Pexp_apply (fn, [ (Nolabel, arg) ]) when is_ident_name fn "seq" -> Some arg
  | _ -> None
;;

let is_nod_builtin_name =
  let builtins =
    [ "mov"
    ; "add"
    ; "sub"
    ; "mul"
    ; "div"
    ; "mod_"
    ; "and_"
    ; "or_"
    ; "ptr_add"
    ; "ptr_sub"
    ; "ptr_diff"
    ; "fadd"
    ; "fsub"
    ; "fmul"
    ; "fdiv"
    ; "load"
    ; "load_ptr"
    ; "load_f64"
    ; "store"
    ; "load_addr"
    ; "load_addr_ptr"
    ; "load_addr_f64"
    ; "store_addr"
    ; "alloca"
    ; "cast"
    ; "call0"
    ; "call1"
    ; "call2"
    ; "label"
    ; "return"
    ; "seq"
    ; "load_record_field"
    ; "store_record_field"
    ]
  in
  fun name -> List.exists (fun builtin -> String.equal name builtin) builtins
;;

let rec collect_field_access expr =
  match expr.pexp_desc with
  | Pexp_field (inner, { txt = Lident field_name; _ }) ->
    let base, fields = collect_field_access inner in
    base, fields @ [ field_name ]
  | Pexp_ident { txt = lid; _ } -> lid, []
  | _ -> errorf ~loc:expr.pexp_loc "nod: invalid field access expression"
;;

let rec take n lst =
  if n <= 0 then [] else
  match lst with
  | [] -> []
  | x :: xs -> x :: take (n - 1) xs
;;

let expand_load_record_field ~loc ~var_name field_expr ptr_expr =
  let base_lid, field_names = collect_field_access field_expr in
  match field_names with
  | [] ->
    errorf
      ~loc
      "nod: load_record_field requires at least one field access (e.g., \
       record.field)"
  | [ field_name ] ->
    let open Builder in
    let record_ref = ident base_lid loc in
    let field_ref = pexp_field ~loc record_ref { txt = Lident field_name; loc } in
    [%expr
      Field.load_immediate
        (Field.Loader.dest [%e estring ~loc var_name])
        [%e field_ref]
        [%e ptr_expr]]
  | _ :: _ as fields ->
    let open Builder in
    let record_ref = ident base_lid loc in
    let loader_name = gen_symbol ~prefix:"__loader" () in
    let rec build_field_ref base fields =
      match fields with
      | [] -> base
      | field :: rest ->
        let field_expr =
          pexp_field ~loc base { txt = Lident field; loc }
        in
        build_field_ref field_expr rest
    in
    let rec split_last = function
      | [] -> failwith "empty list"
      | [x] -> [], x
      | x :: xs ->
        let rest, last = split_last xs in
        x :: rest, last
    in
    let intermediate_fields, _final_field = split_last fields in
    let rec build_loader idx remaining_fields =
      match remaining_fields with
      | [] ->
        [%expr Field.Loader.dest [%e estring ~loc var_name]]
      | field :: rest ->
        let prefix_fields = take idx intermediate_fields in
        let field_ref = build_field_ref record_ref prefix_fields in
        let field_access = pexp_field ~loc field_ref { txt = Lident field; loc } in
        let inner_loader = build_loader (idx + 1) rest in
        [%expr
          Field.load_record
            [%e inner_loader]
            [%e field_access]]
    in
    let loader_expr = build_loader 0 intermediate_fields in
    let intermediate_field_ref = build_field_ref record_ref intermediate_fields in
    let final_field_name = List.hd (List.rev fields) in
    let final_field_ref =
      pexp_field ~loc
        (pexp_field ~loc intermediate_field_ref { txt = Lident "type_info"; loc })
        { txt = Lident final_field_name; loc }
    in
    [%expr
      let [%p pvar ~loc loader_name] = [%e loader_expr] in
      Field.load_immediate
        [%e evar ~loc loader_name]
        [%e final_field_ref]
        [%e ptr_expr]]
;;

let expand_store_record_field ~loc field_expr value_expr ptr_expr =
  let base_lid, field_names = collect_field_access field_expr in
  match field_names with
  | [] ->
    errorf
      ~loc
      "nod: store_record_field requires at least one field access (e.g., \
       record.field)"
  | [ field_name ] ->
    let open Builder in
    let record_ref = ident base_lid loc in
    let field_ref = pexp_field ~loc record_ref { txt = Lident field_name; loc } in
    [%expr
      [ Field.store_immediate
          (Field.Storer.src [%e value_expr])
          [%e field_ref]
          [%e ptr_expr]
      ]]
  | _ :: _ as fields ->
    let open Builder in
    let record_ref = ident base_lid loc in
    let storer_name = gen_symbol ~prefix:"__storer" () in
    let rec build_field_ref base fields =
      match fields with
      | [] -> base
      | field :: rest ->
        let field_expr =
          pexp_field ~loc base { txt = Lident field; loc }
        in
        build_field_ref field_expr rest
    in
    let rec split_last = function
      | [] -> failwith "empty list"
      | [x] -> [], x
      | x :: xs ->
        let rest, last = split_last xs in
        x :: rest, last
    in
    let intermediate_fields, _final_field = split_last fields in
    let rec build_storer idx remaining_fields =
      match remaining_fields with
      | [] -> [%expr Field.Storer.src [%e value_expr]]
      | field :: rest ->
        let prefix_fields = take idx intermediate_fields in
        let field_ref = build_field_ref record_ref prefix_fields in
        let field_access = pexp_field ~loc field_ref { txt = Lident field; loc } in
        let inner_storer = build_storer (idx + 1) rest in
        [%expr
          Field.store_record
            [%e inner_storer]
            [%e field_access]]
    in
    let storer_expr = build_storer 0 intermediate_fields in
    let intermediate_field_ref = build_field_ref record_ref intermediate_fields in
    let final_field_name = List.hd (List.rev fields) in
    let final_field_ref =
      pexp_field ~loc
        (pexp_field ~loc intermediate_field_ref { txt = Lident "type_info"; loc })
        { txt = Lident final_field_name; loc }
    in
    [%expr
      [ (let [%p pvar ~loc storer_name] = [%e storer_expr] in
         Field.store_immediate
           [%e evar ~loc storer_name]
           [%e final_field_ref]
           [%e ptr_expr])
      ]]
;;

let rewritable_callee expr =
  match expr.pexp_desc with
  | Pexp_ident { txt = lid; _ } ->
    let name = longident_last lid in
    not (is_nod_builtin_name name)
  | _ -> false
;;

let rewrite_call_expr expr =
  let loc = expr.pexp_loc in
  match expr.pexp_desc with
  | Pexp_apply (fn, args) ->
    (match fn.pexp_desc with
     | Pexp_ident { txt = Lident "load_record_field"; _ } ->
       (* Don't rewrite load_record_field here; it's handled by add_name_argument *)
       expr
     | Pexp_ident { txt = Lident "store_record_field"; _ } ->
       (match args with
        | [ (Nolabel, field_expr); (Nolabel, ptr_expr); (Nolabel, value_expr) ]
          ->
          expand_store_record_field ~loc field_expr value_expr ptr_expr
        | _ ->
          errorf
            ~loc
            "nod: store_record_field expects exactly three arguments: field \
             access, pointer, and value")
     | _ when rewritable_callee fn ->
       (match args with
        | _ when not (List.for_all (fun (label, _) -> label = Nolabel) args) ->
          expr
        | [ (Nolabel, arg) ] -> [%expr call1 [%e fn] [%e arg]]
        | [ (Nolabel, arg1); (Nolabel, arg2) ] ->
          [%expr call2 [%e fn] [%e arg1] [%e arg2]]
        | _ -> expr)
     | _ -> expr)
  | _ -> expr
;;

let normalize_call_expr expr =
  let expr, no_nod = unwrap_no_nod expr in
  if no_nod then expr else rewrite_call_expr expr
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
       | Some ct -> arg_type_of_core_type ~allow_expr:false ct
       | None -> I64)
    | _ -> I64
  in
  match pat_var_name pat with
  | Some name ->
    { name; type_; var_name = gen_symbol ~prefix:("__nod_arg_" ^ name) () }
  | None -> errorf ~loc:pat.ppat_loc "nod: function arguments must be variables"
;;

let add_name_argument ~loc name expr =
  match expr.pexp_desc with
  | Pexp_apply (fn, args) ->
    (match fn.pexp_desc with
     | Pexp_ident { txt = Lident "load_record_field"; _ } ->
       (* Special handling for load_record_field *)
       (match args with
        | [ (Nolabel, field_expr); (Nolabel, ptr_expr) ] ->
          expand_load_record_field ~loc ~var_name:name field_expr ptr_expr
        | _ ->
          errorf
            ~loc
            "nod: load_record_field expects exactly two arguments: field access \
             and pointer")
     | _ ->
       let name_expr = Builder.estring ~loc name in
       { expr with pexp_desc = Pexp_apply (fn, (Nolabel, name_expr) :: args) })
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
    let rhs =
      binding.pvb_expr |> normalize_call_expr |> add_name_argument ~loc name
    in
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
       let rhs = normalize_call_expr binding.pvb_expr in
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
    let expr, no_nod = unwrap_no_nod expr in
    if no_nod
    then with_loc loc (fun () -> [%expr [%e evar ~loc add_instr] [%e expr]])
    else (
      match return_arg expr with
      | Some _ -> errorf ~loc "nod: return must be in tail position"
      | None ->
        (match expr.pexp_desc with
         | Pexp_let _ | Pexp_sequence _ ->
           errorf ~loc "nod: expected instruction expression"
         | _ ->
           (match seq_arg expr with
            | Some instrs ->
              let instrs = normalize_call_expr instrs in
              with_loc loc (fun () ->
                [%expr Core.List.iter [%e instrs] ~f:[%e evar ~loc add_instr]])
            | None ->
              let expr =
                match label_application expr with
                | Some label_expr -> label_expr
                | None -> normalize_call_expr expr
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
    | Pfunction_cases _ -> errorf ~loc "nod: function cases are not supported"
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
    List.fold_right
      (fun arg acc ->
        [%expr
          Fn.Unnamed.with_arg
            [%e acc]
            [%e type_repr_expr ~in_record_context:false ~loc arg.type_]
            [%e evar ~loc arg.var_name]])
      args
      const_expr
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

let expand_nod_type_expr ~loc ~path:_ (ty : core_type) : expression =
  Util.type_repr_expr
    ~in_record_context:false
    ~loc
    (arg_type_of_core_type ~allow_expr:true ty)
;;

let nod_extension =
  Extension.declare
    "nod"
    Extension.Context.Expression
    Ast_pattern.(single_expr_payload __)
    expand_nod
;;

let nod_type_expr_extension =
  Extension.declare
    "nod_type_expr"
    Extension.Context.Expression
    Ast_pattern.(ptyp __)
    expand_nod_type_expr
;;

let embed_structure_extension =
  Extension.V3.declare
    "embed"
    Extension.Context.Structure_item
    Ast_pattern.(single_expr_payload __)
    Embed.expand_structure
;;

let embed_signature_extension =
  Extension.V3.declare
    "embed"
    Extension.Context.Signature_item
    Ast_pattern.(single_expr_payload __)
    Embed.expand_signature
;;

let () =
  Driver.register_transformation
    "ppx_nod"
    ~rules:
      [ Context_free.Rule.extension nod_extension
      ; Context_free.Rule.extension embed_structure_extension
      ; Context_free.Rule.extension embed_signature_extension
      ; Context_free.Rule.extension nod_type_expr_extension
      ]
;;
