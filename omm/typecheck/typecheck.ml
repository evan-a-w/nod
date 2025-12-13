open! Core
open! Import

module Cst = Cst
module Ast = Ast
module Tc_error = Omm_error

type struct_info =
  { pos : Pos.t
  ; fields_in_order : (string * Ty.t) list
  ; fields_by_name : Ty.t String.Map.t
  }

type fun_sig =
  { pos : Pos.t
  ; params : Ty.t list
  ; ret : Ty.t
  }

type global_sig =
  { pos : Pos.t
  ; ty : Ty.t
  }

type env =
  { structs : struct_info String.Map.t
  ; funs : fun_sig String.Map.t
  ; globals : global_sig String.Map.t
  ; layout : Layout.t
  ; scopes : Ty.t String.Map.t list
  ; return_ty : Ty.t option
  }

let push_scope env = { env with scopes = String.Map.empty :: env.scopes }

let add_local env ~name ~ty =
  match env.scopes with
  | [] -> { env with scopes = [ String.Map.singleton name ty ] }
  | scope :: rest -> { env with scopes = Map.set scope ~key:name ~data:ty :: rest }
;;

let rec lookup_local scopes name =
  match scopes with
  | [] -> None
  | scope :: rest ->
    (match Map.find scope name with
     | Some _ as x -> x
     | None -> lookup_local rest name)
;;

let lookup_value env ~pos name =
  match lookup_local env.scopes name with
  | Some ty -> Ok ty
  | None ->
    (match Map.find env.globals name with
     | Some g -> Ok g.ty
     | None -> Error (Tc_error.Unknown_variable { name; pos }))
;;

let lookup_struct env ~pos name =
  match Map.find env.structs name with
  | Some s -> Ok s
  | None -> Error (Tc_error.Unknown_struct { name; pos })
;;

let lookup_fun env ~pos name =
  match Map.find env.funs name with
  | Some f -> Ok f
  | None -> Error (Tc_error.Unknown_function { name; pos })
;;

let ensure_type_exists env ~pos ty =
  let rec go = function
    | Ty.Unit | Ty.Prim _ -> Ok ()
    | Ty.Ptr t -> go t
    | Ty.Struct name ->
      (match Map.find env.structs name with
       | Some _ -> Ok ()
       | None -> Error (Tc_error.Unknown_struct { name; pos }))
  in
  go ty
;;

let expect_type ~context ~pos ~expected ~got =
  if Ty.equal expected got
  then Ok ()
  else Error (Tc_error.Expected_type { expected; got; pos; context })
;;

let expect_i64_cond ~pos ~got =
  match got with
  | Ty.Prim Ty.I64 -> Ok ()
  | _ -> Error (Tc_error.Expected_i64_condition { got; pos })
;;

let expect_ptr ~pos ~got =
  match got with
  | Ty.Ptr t -> Ok t
  | _ -> Error (Tc_error.Expected_pointer { got; pos })
;;

let expect_struct ~pos ~got =
  match got with
  | Ty.Struct name -> Ok name
  | _ -> Error (Tc_error.Expected_struct { got; pos })
;;

let expect_struct_ptr ~pos ~got =
  match got with
  | Ty.Ptr (Ty.Struct name) -> Ok name
  | _ -> Error (Tc_error.Expected_struct_ptr { got; pos })
;;

let is_numeric = function
  | Ty.Prim Ty.I64 | Ty.Prim Ty.F64 -> true
  | _ -> false
;;

let is_i64 = function
  | Ty.Prim Ty.I64 -> true
  | _ -> false
;;

let check_binop ~pos (op : Cst.binop) lhs_ty rhs_ty =
  let same = Ty.equal lhs_ty rhs_ty in
  match op with
  | Add | Sub | Mul | Div ->
    if same && is_numeric lhs_ty
    then Ok lhs_ty
    else Error (Tc_error.Expected_type { expected = lhs_ty; got = rhs_ty; pos; context = "binop" })
  | Mod ->
    if same && is_i64 lhs_ty
    then Ok lhs_ty
    else
      Error (Tc_error.Expected_type { expected = Ty.Prim Ty.I64; got = lhs_ty; pos; context = "mod" })
  | Eq | Ne | Lt | Le | Gt | Ge ->
    if same && is_numeric lhs_ty
    then Ok (Ty.Prim Ty.I64)
    else Error (Tc_error.Expected_type { expected = lhs_ty; got = rhs_ty; pos; context = "cmp" })
  | Land | Lor | Lxor | Lsl | Lsr | Asr ->
    if same && is_i64 lhs_ty
    then Ok (Ty.Prim Ty.I64)
    else
      Error
        (Tc_error.Expected_type { expected = Ty.Prim Ty.I64; got = lhs_ty; pos; context = "bitop" })
;;

let check_unop ~pos (op : Cst.unop) arg_ty =
  match op with
  | Neg ->
    if is_numeric arg_ty
    then Ok arg_ty
    else Error (Tc_error.Expected_type { expected = Ty.Prim Ty.I64; got = arg_ty; pos; context = "neg" })
;;

let rec check_top_expr env (e : Cst.top_expr) : (Ast.top_expr, Tc_error.t) Result.t =
  let open Result.Let_syntax in
  let pos = e.pos in
  match e.value with
  | Cst.Top_int i ->
    Ok ({ Ast.pos; ty = Ty.Prim Ty.I64; desc = Ast.Top_int i } : Ast.top_expr)
  | Cst.Top_float f ->
    Ok ({ Ast.pos; ty = Ty.Prim Ty.F64; desc = Ast.Top_float f } : Ast.top_expr)
  | Cst.Top_unit -> Ok ({ Ast.pos; ty = Ty.Unit; desc = Ast.Top_unit } : Ast.top_expr)
  | Cst.Top_var name ->
    let%map ty = lookup_value env ~pos name in
    ({ Ast.pos; ty; desc = Ast.Top_var name } : Ast.top_expr)
  | Cst.Top_struct { ty_name; fields } ->
    let%bind struct_info = lookup_struct env ~pos ty_name in
    let seen = String.Hash_set.create () in
    let%bind typed_fields =
      fields
      |> List.map ~f:(fun (field, value) ->
        if Hash_set.mem seen field
        then Error (Tc_error.Duplicate_field_init { struct_name = ty_name; field; pos })
        else (
          Hash_set.add seen field;
          match Map.find struct_info.fields_by_name field with
          | None -> Error (Tc_error.Extra_field_init { struct_name = ty_name; field; pos })
          | Some expected_ty ->
            let%bind value = check_top_expr env value in
            let%bind () =
              expect_type
                ~context:[%string "top struct field %{ty_name}.%{field}"]
                ~pos:value.pos
                ~expected:expected_ty
                ~got:value.ty
            in
            Ok (field, value)))
      |> List.fold_result ~init:[] ~f:(fun acc x ->
        let open Result.Let_syntax in
        let%map x = x in
        x :: acc)
      |> Result.map ~f:List.rev
    in
    let%bind () =
      struct_info.fields_in_order
      |> List.fold_result ~init:() ~f:(fun () (field, _) ->
        if Hash_set.mem seen field
        then Ok ()
        else Error (Tc_error.Missing_field_init { struct_name = ty_name; field; pos }))
    in
    Ok
      ({ Ast.pos
       ; ty = Ty.Struct ty_name
       ; desc = Ast.Top_struct { ty_name; fields = typed_fields }
       }
       : Ast.top_expr)
;;

let check_intrinsic env ~pos (name : Ast.intrinsic_name) ~type_args ~args =
  let open Result.Let_syntax in
  let type_arg i =
    match List.nth type_args i with
    | Some t -> Ok t
    | None ->
      Error (Tc_error.Invalid_intrinsic { msg = "missing type argument"; pos })
  in
  let expr_arg i =
    match List.nth args i with
    | Some (Ast.Arg_expr e) -> Ok e
    | Some (Ast.Arg_field _) ->
      Error (Tc_error.Invalid_intrinsic { msg = "expected expression argument"; pos })
    | None -> Error (Tc_error.Invalid_intrinsic { msg = "missing argument"; pos })
  in
  let field_arg i =
    match List.nth args i with
    | Some (Ast.Arg_field { field }) -> Ok field
    | Some (Ast.Arg_expr _) ->
      Error (Tc_error.Invalid_intrinsic { msg = "expected field identifier"; pos })
    | None -> Error (Tc_error.Invalid_intrinsic { msg = "missing argument"; pos })
  in
  let ensure_no_extra_args ~expected =
    let got = List.length args in
    if Int.equal got expected
    then Ok ()
    else Error (Tc_error.Wrong_arity { name = Intrinsic.to_string name; expected; got; pos })
  in
  let ensure_no_extra_type_args ~expected =
    let got = List.length type_args in
    if Int.equal got expected
    then Ok ()
    else Error (Tc_error.Invalid_intrinsic { msg = "wrong number of type arguments"; pos })
  in
  match name with
  | Alloca ->
    let%bind () = ensure_no_extra_type_args ~expected:1 in
    let%bind () = ensure_no_extra_args ~expected:0 in
    let%bind t = type_arg 0 in
    let%bind () = ensure_type_exists env ~pos t in
    Ok (Ty.Ptr t)
  | Alloca_array ->
    let%bind () = ensure_no_extra_type_args ~expected:1 in
    let%bind () = ensure_no_extra_args ~expected:1 in
    let%bind t = type_arg 0 in
    let%bind () = ensure_type_exists env ~pos t in
    let%bind n = expr_arg 0 in
    let%bind () = expect_type ~context:"alloca_array length" ~pos:n.pos ~expected:(Ty.Prim Ty.I64) ~got:n.ty in
    Ok (Ty.Ptr t)
  | Load ->
    let%bind () = ensure_no_extra_type_args ~expected:1 in
    let%bind () = ensure_no_extra_args ~expected:1 in
    let%bind t = type_arg 0 in
    let%bind () = ensure_type_exists env ~pos t in
    let%bind p = expr_arg 0 in
    let%bind () =
      expect_type ~context:"load pointer" ~pos:p.pos ~expected:(Ty.Ptr t) ~got:p.ty
    in
    Ok t
  | Store ->
    let%bind () = ensure_no_extra_type_args ~expected:1 in
    let%bind () = ensure_no_extra_args ~expected:2 in
    let%bind t = type_arg 0 in
    let%bind () = ensure_type_exists env ~pos t in
    let%bind p = expr_arg 0 in
    let%bind v = expr_arg 1 in
    let%bind () =
      expect_type ~context:"store pointer" ~pos:p.pos ~expected:(Ty.Ptr t) ~got:p.ty
    in
    let%bind () = expect_type ~context:"store value" ~pos:v.pos ~expected:t ~got:v.ty in
    Ok Ty.Unit
  | Ptr_add ->
    let%bind () = ensure_no_extra_type_args ~expected:1 in
    let%bind () = ensure_no_extra_args ~expected:2 in
    let%bind t = type_arg 0 in
    let%bind () = ensure_type_exists env ~pos t in
    let%bind p = expr_arg 0 in
    let%bind i = expr_arg 1 in
    let%bind () =
      expect_type ~context:"ptr_add pointer" ~pos:p.pos ~expected:(Ty.Ptr t) ~got:p.ty
    in
    let%bind () = expect_type ~context:"ptr_add index" ~pos:i.pos ~expected:(Ty.Prim Ty.I64) ~got:i.ty in
    Ok (Ty.Ptr t)
  | Field_addr ->
    let%bind () = ensure_no_extra_type_args ~expected:2 in
    let%bind () = ensure_no_extra_args ~expected:2 in
    let%bind s = type_arg 0 in
    let%bind t = type_arg 1 in
    let%bind struct_name =
      match s with
      | Ty.Struct n -> Ok n
      | _ ->
        Error
          (Tc_error.Invalid_intrinsic { msg = "field_addr first type argument must be a struct"; pos })
    in
    let%bind struct_info = lookup_struct env ~pos struct_name in
    let%bind p = expr_arg 0 in
    let%bind () =
      expect_type
        ~context:"field_addr pointer"
        ~pos:p.pos
        ~expected:(Ty.Ptr (Ty.Struct struct_name))
        ~got:p.ty
    in
    let%bind field = field_arg 1 in
    let%bind field_ty =
      match Map.find struct_info.fields_by_name field with
      | Some ty -> Ok ty
      | None -> Error (Tc_error.Unknown_field { struct_name; field; pos })
    in
    let%bind () =
      expect_type ~context:"field_addr result type" ~pos ~expected:field_ty ~got:t
    in
    Ok (Ty.Ptr t)
  | Sizeof ->
    let%bind () = ensure_no_extra_type_args ~expected:1 in
    let%bind () = ensure_no_extra_args ~expected:0 in
    let%bind t = type_arg 0 in
    let%bind () = ensure_type_exists env ~pos t in
    Ok (Ty.Prim Ty.I64)
  | Alignof ->
    let%bind () = ensure_no_extra_type_args ~expected:1 in
    let%bind () = ensure_no_extra_args ~expected:0 in
    let%bind t = type_arg 0 in
    let%bind () = ensure_type_exists env ~pos t in
    Ok (Ty.Prim Ty.I64)
  | Offsetof ->
    let%bind () = ensure_no_extra_type_args ~expected:1 in
    let%bind () = ensure_no_extra_args ~expected:1 in
    let%bind s = type_arg 0 in
    let%bind struct_name =
      match s with
      | Ty.Struct n -> Ok n
      | _ ->
        Error (Tc_error.Invalid_intrinsic { msg = "offsetof type argument must be a struct"; pos })
    in
    let%bind field =
      match List.nth args 0 with
      | Some (Ast.Arg_field { field }) -> Ok field
      | Some (Ast.Arg_expr { desc = Ast.Var field; _ }) -> Ok field
      | Some _ -> Error (Tc_error.Invalid_intrinsic { msg = "offsetof expects a field identifier"; pos })
      | None -> Error (Tc_error.Invalid_intrinsic { msg = "missing argument"; pos })
    in
    let%bind (_ : int) =
      match Layout.offset_of_field struct_name ~field env.layout with
      | Ok off -> Ok off
      | Error msg -> Error (Tc_error.Layout_error { msg; pos })
    in
    Ok (Ty.Prim Ty.I64)
  | F64_of_i64 ->
    let%bind () = ensure_no_extra_type_args ~expected:0 in
    let%bind () = ensure_no_extra_args ~expected:1 in
    let%bind x = expr_arg 0 in
    let%bind () =
      expect_type ~context:"f64_of_i64" ~pos:x.pos ~expected:(Ty.Prim Ty.I64) ~got:x.ty
    in
    Ok (Ty.Prim Ty.F64)
  | I64_of_f64 ->
    let%bind () = ensure_no_extra_type_args ~expected:0 in
    let%bind () = ensure_no_extra_args ~expected:1 in
    let%bind x = expr_arg 0 in
    let%bind () =
      expect_type ~context:"i64_of_f64" ~pos:x.pos ~expected:(Ty.Prim Ty.F64) ~got:x.ty
    in
    Ok (Ty.Prim Ty.I64)
  | Ptr_cast ->
    let%bind () = ensure_no_extra_type_args ~expected:2 in
    let%bind () = ensure_no_extra_args ~expected:1 in
    let%bind u = type_arg 0 in
    let%bind v = type_arg 1 in
    let%bind () = ensure_type_exists env ~pos u in
    let%bind () = ensure_type_exists env ~pos v in
    let%bind p = expr_arg 0 in
    let%bind () =
      expect_type ~context:"ptr_cast" ~pos:p.pos ~expected:(Ty.Ptr u) ~got:p.ty
    in
    Ok (Ty.Ptr v)
  | Bitcast ->
    let%bind () = ensure_no_extra_type_args ~expected:2 in
    let%bind () = ensure_no_extra_args ~expected:1 in
    let%bind u = type_arg 0 in
    let%bind v = type_arg 1 in
    let%bind () = ensure_type_exists env ~pos u in
    let%bind () = ensure_type_exists env ~pos v in
    let%bind x = expr_arg 0 in
    let%bind () = expect_type ~context:"bitcast" ~pos:x.pos ~expected:u ~got:x.ty in
    let%bind su =
      match Layout.size_of u env.layout with
      | Ok n -> Ok n
      | Error msg -> Error (Tc_error.Layout_error { msg; pos })
    in
    let%bind sv =
      match Layout.size_of v env.layout with
      | Ok n -> Ok n
      | Error msg -> Error (Tc_error.Layout_error { msg; pos })
    in
    if Int.equal su sv
    then Ok v
    else Error (Tc_error.Invalid_intrinsic { msg = "bitcast requires same-sized types"; pos })
;;

let rec check_expr env (e : Cst.expr) : (Ast.expr, Tc_error.t) Result.t =
  let open Result.Let_syntax in
  let pos = e.pos in
  match e.value with
  | Cst.Int i -> Ok { Ast.pos; ty = Ty.Prim Ty.I64; desc = Int i }
  | Cst.Float f -> Ok { Ast.pos; ty = Ty.Prim Ty.F64; desc = Float f }
  | Cst.Unit_lit -> Ok { Ast.pos; ty = Ty.Unit; desc = Unit_lit }
  | Cst.Var name ->
    let%map ty = lookup_value env ~pos name in
    { Ast.pos; ty; desc = Var name }
  | Cst.Paren e ->
    let%map e = check_expr env e in
    { Ast.pos; ty = e.ty; desc = Paren e }
  | Cst.Unop { op; arg } ->
    let%bind arg = check_expr env arg in
    let%bind ty = check_unop ~pos op arg.ty in
    Ok { Ast.pos; ty; desc = Unop { op; arg } }
  | Cst.Binop { op; lhs; rhs } ->
    let%bind lhs = check_expr env lhs in
    let%bind rhs = check_expr env rhs in
    let%bind ty = check_binop ~pos op lhs.ty rhs.ty in
    Ok { Ast.pos; ty; desc = Binop { op; lhs; rhs } }
  | Cst.If { cond; then_; else_ } ->
    let%bind cond = check_expr env cond in
    let%bind () = expect_i64_cond ~pos:cond.pos ~got:cond.ty in
    let%bind then_ = check_expr env then_ in
    let%bind else_ = check_expr env else_ in
    let%bind () =
      expect_type ~context:"if expression branches" ~pos ~expected:then_.ty ~got:else_.ty
    in
    Ok { Ast.pos; ty = then_.ty; desc = If { cond; then_; else_ } }
  | Cst.Struct_lit { ty_name; fields } ->
    let%bind struct_info = lookup_struct env ~pos ty_name in
    let seen = String.Hash_set.create () in
    let%bind typed_fields =
      fields
      |> List.map ~f:(fun (field, value) ->
        if Hash_set.mem seen field
        then Error (Tc_error.Duplicate_field_init { struct_name = ty_name; field; pos })
        else (
          Hash_set.add seen field;
          match Map.find struct_info.fields_by_name field with
          | None -> Error (Tc_error.Extra_field_init { struct_name = ty_name; field; pos })
          | Some expected_ty ->
            let%bind value = check_expr env value in
            let%bind () =
              expect_type
                ~context:[%string "struct field %{ty_name}.%{field}"]
                ~pos:value.pos
                ~expected:expected_ty
                ~got:value.ty
            in
            Ok (field, value)))
      |> List.fold_result ~init:[] ~f:(fun acc x ->
        let open Result.Let_syntax in
        let%map x = x in
        x :: acc)
      |> Result.map ~f:List.rev
    in
    let%bind () =
      struct_info.fields_in_order
      |> List.fold_result ~init:() ~f:(fun () (field, _) ->
        if Hash_set.mem seen field
        then Ok ()
        else Error (Tc_error.Missing_field_init { struct_name = ty_name; field; pos }))
    in
    Ok
      { Ast.pos
      ; ty = Ty.Struct ty_name
      ; desc = Struct_lit { ty_name; fields = typed_fields }
      }
  | Cst.Field { base; field } ->
    let%bind base = check_expr env base in
    let%bind struct_name = expect_struct ~pos:base.pos ~got:base.ty in
    let%bind struct_info = lookup_struct env ~pos:base.pos struct_name in
    let%bind field_ty =
      match Map.find struct_info.fields_by_name field with
      | Some ty -> Ok ty
      | None -> Error (Tc_error.Unknown_field { struct_name; field; pos })
    in
    Ok { Ast.pos; ty = field_ty; desc = Field { base; field } }
  | Cst.Arrow_field { base; field } ->
    let%bind base = check_expr env base in
    let%bind struct_name = expect_struct_ptr ~pos:base.pos ~got:base.ty in
    let%bind struct_info = lookup_struct env ~pos:base.pos struct_name in
    let%bind field_ty =
      match Map.find struct_info.fields_by_name field with
      | Some ty -> Ok ty
      | None -> Error (Tc_error.Unknown_field { struct_name; field; pos })
    in
    Ok { Ast.pos; ty = Ty.Ptr field_ty; desc = Arrow_field { base; field } }
  | Cst.Index { base; index } ->
    let%bind base = check_expr env base in
    let%bind elem_ty = expect_ptr ~pos:base.pos ~got:base.ty in
    let%bind index = check_expr env index in
    let%bind () =
      expect_type ~context:"index" ~pos:index.pos ~expected:(Ty.Prim Ty.I64) ~got:index.ty
    in
    Ok { Ast.pos; ty = Ty.Ptr elem_ty; desc = Index { base; index } }
  | Cst.Call { callee; type_args; args } ->
    (match callee.value with
     | Cst.Var name ->
       (match Intrinsic.of_string name with
        | Some intrinsic ->
          let%bind type_args =
            type_args
            |> List.map ~f:(fun t -> Ok (Ty.of_cst t))
            |> List.fold_result ~init:[] ~f:(fun acc x ->
              let open Result.Let_syntax in
              let%map x = x in
              x :: acc)
            |> Result.map ~f:List.rev
          in
          let%bind () =
            type_args
            |> List.fold_result ~init:() ~f:(fun () t -> ensure_type_exists env ~pos t)
          in
          let%bind args =
            args
            |> List.map ~f:(function
              | Cst.Named_field { field } -> Ok (Ast.Arg_field { field })
              | Cst.Expr e ->
                let%map e = check_expr env e in
                Ast.Arg_expr e)
            |> List.fold_result ~init:[] ~f:(fun acc x ->
              let open Result.Let_syntax in
              let%map x = x in
              x :: acc)
            |> Result.map ~f:List.rev
          in
          let%bind ty = check_intrinsic env ~pos intrinsic ~type_args ~args in
          Ok { Ast.pos; ty; desc = Intrinsic_call { name = intrinsic; type_args; args } }
        | None ->
          let%bind () =
            if List.is_empty type_args
            then Ok ()
            else
              Error
                (Tc_error.Invalid_intrinsic
                   { msg = "type arguments are only allowed for intrinsics"; pos })
          in
          let%bind () =
            match List.find args ~f:(function
              | Cst.Named_field _ -> true
              | Cst.Expr _ -> false)
            with
            | Some _ ->
              Error
                (Tc_error.Invalid_intrinsic
                   { msg = "named arguments are only allowed for intrinsics"; pos })
            | None -> Ok ()
          in
          let%bind fn = lookup_fun env ~pos name in
          let%bind args =
            args
            |> List.map ~f:(function
              | Cst.Expr e -> check_expr env e
              | Cst.Named_field _ ->
                Error (Tc_error.Invalid_intrinsic { msg = "unexpected named argument"; pos }))
            |> List.fold_result ~init:[] ~f:(fun acc x ->
              let open Result.Let_syntax in
              let%map x = x in
              x :: acc)
            |> Result.map ~f:List.rev
          in
          let expected = List.length fn.params in
          let got = List.length args in
          let%bind () =
            if Int.equal expected got
            then Ok ()
            else Error (Tc_error.Wrong_arity { name; expected; got; pos })
          in
          let%bind () =
            List.zip_exn fn.params args
            |> List.fold_result ~init:() ~f:(fun () (param_ty, arg) ->
              expect_type
                ~context:[%string "call arg %{name}"]
                ~pos:arg.pos
                ~expected:param_ty
                ~got:arg.ty)
          in
          Ok { Ast.pos; ty = fn.ret; desc = Call { name; args } })
     | _ -> Error (Tc_error.Invalid_intrinsic { msg = "callee must be a name"; pos }))
;;

let rec check_stmt env (s : Cst.stmt) : (env * Ast.stmt * bool, Tc_error.t) Result.t =
  let open Result.Let_syntax in
  let pos = s.pos in
  match s.value with
  | Cst.Let { name; ty; expr } ->
    let declared_ty = Ty.of_cst ty in
    let%bind () = ensure_type_exists env ~pos declared_ty in
    let%bind expr = check_expr env expr in
    let%bind () =
      expect_type ~context:[%string "let %{name}"] ~pos:expr.pos ~expected:declared_ty ~got:expr.ty
    in
    let env = add_local env ~name ~ty:declared_ty in
    Ok (env, { Ast.pos; desc = Let { name; ty = declared_ty; expr } }, false)
  | Cst.Expr_stmt e ->
    let%map e = check_expr env e in
    env, { Ast.pos; desc = Expr_stmt e }, false
  | Cst.Return e ->
    let%bind e = check_expr env e in
    let%bind () =
      match env.return_ty with
      | None -> Ok ()
      | Some expected ->
        expect_type ~context:"return" ~pos:e.pos ~expected ~got:e.ty
    in
    Ok (env, { Ast.pos; desc = Return e }, true)
  | Cst.If_stmt { cond; then_; else_ } ->
    let%bind cond = check_expr env cond in
    let%bind () = expect_i64_cond ~pos:cond.pos ~got:cond.ty in
    let%bind then_block, then_returns = check_block env then_ in
    let%bind else_block, else_returns = check_block env else_ in
    Ok
      ( env
      , { Ast.pos; desc = If_stmt { cond; then_ = then_block; else_ = else_block } }
      , then_returns && else_returns )
  | Cst.While { cond; body } ->
    let%bind cond = check_expr env cond in
    let%bind () = expect_i64_cond ~pos:cond.pos ~got:cond.ty in
    let%bind body, (_ : bool) = check_block env body in
    Ok (env, { Ast.pos; desc = While { cond; body } }, false)

and check_block env (b : Cst.block) : (Ast.block * bool, Tc_error.t) Result.t =
  let open Result.Let_syntax in
  let env = push_scope env in
  let pos = b.pos in
  let rec loop env acc = function
    | [] -> Ok ({ Ast.pos; stmts = List.rev acc }, false)
    | stmt :: rest ->
      let%bind env, typed_stmt, returns = check_stmt env stmt in
      if returns
      then Ok ({ Ast.pos; stmts = List.rev (typed_stmt :: acc) }, true)
      else loop env (typed_stmt :: acc) rest
  in
  loop env [] b.value.stmts
;;

let struct_info_of_cst_field (f : Cst.field) = f.name, Ty.of_cst f.ty
let ast_field_of_cst_field (f : Cst.field) =
  ({ Ast.name = f.name; ty = Ty.of_cst f.ty } : Ast.field)
;;

let create_structs (program : Cst.program) : (struct_info String.Map.t, Tc_error.t) Result.t =
  let open Result.Let_syntax in
  let%bind user_structs =
    program
    |> List.filter_map ~f:(fun (item : Cst.item) ->
      match item.value with
      | Cst.Type_def { name; fields } -> Some (item.pos, name, fields)
      | _ -> None)
    |> List.fold_result ~init:String.Map.empty ~f:(fun acc (pos, name, fields) ->
      if Map.mem acc name
      then Error (Tc_error.Duplicate_name { kind = "type"; name; pos })
      else (
        let field_map =
          fields
          |> List.map ~f:struct_info_of_cst_field
          |> String.Map.of_alist
        in
         (match field_map with
          | `Duplicate_key field ->
           Error (Tc_error.Duplicate_name { kind = "field"; name = field; pos })
          | `Ok fields_by_name ->
           Ok
             (Map.set
                acc
                ~key:name
                ~data:{ pos; fields_in_order = List.map fields ~f:struct_info_of_cst_field; fields_by_name }))))
  in
  let unit_def =
    match Map.find user_structs "unit" with
    | None ->
      Ok { pos = Pos.create ~file:""; fields_in_order = []; fields_by_name = String.Map.empty }
    | Some def ->
      if List.is_empty def.fields_in_order
      then Ok def
      else
        Error (Tc_error.Invalid_intrinsic { msg = "unit must be an empty struct"; pos = def.pos })
  in
  match unit_def with
  | Error _ as e -> e
  | Ok unit_def -> Ok (Map.set user_structs ~key:"unit" ~data:unit_def)
;;

let create_funs_and_globals (structs : struct_info String.Map.t) (program : Cst.program) =
  let open Result.Let_syntax in
  let dummy_layout = Layout.create String.Map.empty in
  let env0 =
    { structs
    ; funs = String.Map.empty
    ; globals = String.Map.empty
    ; layout = dummy_layout
    ; scopes = []
    ; return_ty = None
    }
  in
  let%bind env =
    program
    |> List.fold_result ~init:env0 ~f:(fun env (item : Cst.item) ->
      let pos = item.pos in
      match item.value with
      | Cst.Extern_decl { name; params; ret; symbol = _ } ->
        if List.mem Intrinsic.reserved_names name ~equal:String.equal
        then Error (Tc_error.Duplicate_name { kind = "intrinsic name"; name; pos })
        else if Map.mem env.funs name || Map.mem env.globals name
        then Error (Tc_error.Duplicate_name { kind = "value"; name; pos })
        else (
          let params = List.map params ~f:Ty.of_cst in
          let ret = Ty.of_cst ret in
          let%bind () =
            params |> List.fold_result ~init:() ~f:(fun () ty -> ensure_type_exists env ~pos ty)
          in
          let%bind () = ensure_type_exists env ~pos ret in
          Ok { env with funs = Map.set env.funs ~key:name ~data:{ pos; params; ret } })
      | Cst.Fun_def { name; params; ret; body = _ } ->
        if List.mem Intrinsic.reserved_names name ~equal:String.equal
        then Error (Tc_error.Duplicate_name { kind = "intrinsic name"; name; pos })
        else if Map.mem env.funs name || Map.mem env.globals name
        then Error (Tc_error.Duplicate_name { kind = "value"; name; pos })
        else (
          let params = List.map params ~f:(fun (p : Cst.param) -> Ty.of_cst p.ty) in
          let ret = Ty.of_cst ret in
          let%bind () =
            params |> List.fold_result ~init:() ~f:(fun () ty -> ensure_type_exists env ~pos ty)
          in
          let%bind () = ensure_type_exists env ~pos ret in
          Ok { env with funs = Map.set env.funs ~key:name ~data:{ pos; params; ret } })
      | Cst.Global_def { name; ty; init = _ } ->
        if List.mem Intrinsic.reserved_names name ~equal:String.equal
        then Error (Tc_error.Duplicate_name { kind = "intrinsic name"; name; pos })
        else if Map.mem env.funs name || Map.mem env.globals name
        then Error (Tc_error.Duplicate_name { kind = "value"; name; pos })
        else (
          let ty = Ty.of_cst ty in
          let%bind () = ensure_type_exists env ~pos ty in
          Ok { env with globals = Map.set env.globals ~key:name ~data:{ pos; ty } })
      | Cst.Type_def _ -> Ok env)
  in
  let struct_defs =
    env.structs
    |> Map.map ~f:(fun s ->
      { Layout.pos = s.pos; fields = s.fields_in_order })
  in
  let layout = Layout.create struct_defs in
  Ok { env with layout }
;;

let check_program (program : Cst.program) : (Ast.program, Tc_error.t) Result.t =
  let open Result.Let_syntax in
  let%bind structs = create_structs program in
  let%bind env = create_funs_and_globals structs program in
  let%bind () =
    env.structs
    |> Map.to_alist
    |> List.fold_result ~init:() ~f:(fun () (name, info) ->
      match Layout.size_of (Ty.Struct name) env.layout with
      | Ok (_ : int) -> Ok ()
      | Error msg -> Error (Tc_error.Layout_error { msg; pos = info.pos }))
  in
  let%bind items =
    program
    |> List.map ~f:(fun (item : Cst.item) ->
      let pos = item.pos in
      match item.value with
      | Cst.Type_def { name; fields } ->
        let fields = List.map fields ~f:ast_field_of_cst_field in
        Ok (Ast.Type_def { pos; name; fields })
      | Cst.Extern_decl { name; params; ret; symbol } ->
        let params = List.map params ~f:Ty.of_cst in
        let ret = Ty.of_cst ret in
        Ok (Ast.Extern_decl { pos; name; params; ret; symbol })
      | Cst.Fun_def { name; params; ret; body } ->
        let params =
          params
          |> List.map ~f:(fun (p : Cst.param) ->
            ({ Ast.name = p.name; ty = Ty.of_cst p.ty } : Ast.param))
        in
        let ret = Ty.of_cst ret in
        let%bind scope =
          params
          |> List.map ~f:(fun p -> p.Ast.name, p.ty)
          |> String.Map.of_alist
          |> (function
           | `Ok m -> Ok m
           | `Duplicate_key name -> Error (Tc_error.Duplicate_name { kind = "param"; name; pos }))
        in
        let env = { env with scopes = [ scope ]; return_ty = Some ret } in
        let%bind body, returns = check_block env body in
        let%bind () =
          if returns
          then Ok ()
          else Error (Tc_error.Missing_return { fn_name = name; pos })
        in
        Ok (Ast.Fun_def { pos; name; params; ret; body })
      | Cst.Global_def { name; ty; init } ->
        let ty = Ty.of_cst ty in
        let%bind init = check_top_expr env init in
        let%bind () = expect_type ~context:"global initializer" ~pos:init.pos ~expected:ty ~got:init.ty in
        Ok (Ast.Global_def { pos; name; ty; init }))
    |> List.fold_result ~init:[] ~f:(fun acc x ->
      let open Result.Let_syntax in
      let%map x = x in
      x :: acc)
    |> Result.map ~f:List.rev
  in
  Ok { Ast.items }
;;
