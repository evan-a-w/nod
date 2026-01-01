open! Core
open! Import

module Ast = Ast

type struct_info =
  { fields : (string * Ast.type_expr) list
  ; core_type : Type.t
  }

type fn_sig =
  { args : Ast.type_expr list
  ; return_type : Ast.type_expr
  }

type value =
  { operand : Ir.Lit_or_var.t
  ; type_ : Ast.type_expr
  }

type place =
  | Scalar_var of Ast.type_expr * Var.t
  | Mem of Ast.type_expr * Ir.Lit_or_var.t
  | Field of
      { base : Ir.Lit_or_var.t
      ; struct_name : string
      ; indices : int list
      ; field_type : Ast.type_expr
      }

type binding =
  | Scalar of Ast.type_expr
  | Struct of
      { type_ : Ast.type_expr
      ; ptr : Ir.Lit_or_var.t
      }

type builder =
  { mutable instrs_by_label : string Ir0.t Vec.t String.Map.t
  ; labels : string Vec.t
  ; mutable current_label : string
  ; mutable current_instrs : string Ir0.t Vec.t
  ; mutable terminated : bool
  ; mutable label_counter : int
  }

type ctx =
  { struct_env : struct_info String.Map.t
  ; fn_env : fn_sig String.Map.t
  ; return_type : Ast.type_expr
  ; scopes : binding String.Table.t list ref
  ; used_names : String.Hash_set.t
  ; mutable temp_counter : int
  ; builder : builder
  }

let result_all xs =
  let open Result.Let_syntax in
  List.fold xs ~init:(Ok []) ~f:(fun acc x ->
    let%bind acc in
    let%map x in
    x :: acc)
  |> Result.map ~f:List.rev
;;

let create_builder () =
  let root = "%root" in
  { instrs_by_label = String.Map.empty
  ; labels = Vec.of_list [ root ]
  ; current_label = root
  ; current_instrs = Vec.create ()
  ; terminated = false
  ; label_counter = 0
  }
;;

let finalize_block builder =
  if Map.mem builder.instrs_by_label builder.current_label
  then failwithf "duplicate label %s" builder.current_label ()
  else
    builder.instrs_by_label
    <- Map.set
         builder.instrs_by_label
         ~key:builder.current_label
         ~data:builder.current_instrs
;;

let emit builder instr =
  if builder.terminated
  then Error (`Unsupported "instruction after terminator")
  else (
    Vec.push builder.current_instrs instr;
    if Ir.is_terminal instr then builder.terminated <- true;
    Ok ())
;;

let start_block ?(link = true) builder label =
  let open Result.Let_syntax in
  let%bind () =
    if link && not builder.terminated
    then (
      let branch =
        Ir.branch
          (Ir.Branch.Uncond { Ir.Call_block.block = label; args = [] })
      in
      emit builder branch)
    else if link
    then Ok ()
    else if builder.terminated
    then Ok ()
    else Error (`Type_mismatch "missing terminator before new block")
  in
  finalize_block builder;
  builder.current_label <- label;
  builder.current_instrs <- Vec.create ();
  builder.terminated <- false;
  Vec.push builder.labels label;
  Ok ()
;;

let finish_builder builder =
  if not builder.terminated
  then Error (`Type_mismatch "missing return at end of function")
  else (
    finalize_block builder;
    Ok ())
;;

let rec type_equal a b =
  match a, b with
  | Ast.I64, Ast.I64 | Ast.F64, Ast.F64 -> true
  | Ast.Struct a, Ast.Struct b -> String.equal a b
  | Ast.Ptr a, Ast.Ptr b -> type_equal a b
  | _ -> false
;;

let core_type_of struct_env =
  let go = function
    | Ast.I64 -> Ok Type.I64
    | Ast.F64 -> Ok Type.F64
    | Ast.Ptr _ -> Ok Type.Ptr
    | Ast.Struct name ->
      (match Map.find struct_env name with
       | None -> Error (`Unknown_struct name)
       | Some info -> Ok info.core_type)
  in
  go
;;

let fresh_name ctx prefix =
  let rec loop () =
    let name = sprintf "%s%d" prefix ctx.temp_counter in
    ctx.temp_counter <- ctx.temp_counter + 1;
    if Hash_set.mem ctx.used_names name then loop () else name
  in
  let name = loop () in
  Hash_set.add ctx.used_names name;
  name
;;

let fresh_temp ctx ~type_ =
  let name = fresh_name ctx "__tmp" in
  Var.create ~name ~type_
;;

let push_scope ctx =
  ctx.scopes := String.Table.create () :: !(ctx.scopes)
;;

let pop_scope ctx =
  match !(ctx.scopes) with
  | _ :: rest -> ctx.scopes := rest
  | [] -> failwith "scope underflow"
;;

let add_binding ctx name binding =
  match !(ctx.scopes) with
  | [] -> failwith "no scope"
  | scope :: _ ->
    if Hashtbl.mem scope name
    then Error (`Type_mismatch (sprintf "duplicate binding %s" name))
    else (
      Hashtbl.set scope ~key:name ~data:binding;
      Hash_set.add ctx.used_names name;
      Ok ())
;;

let lookup_binding ctx name =
  let rec go = function
    | [] -> Error (`Unknown_variable name)
    | scope :: rest ->
      (match Hashtbl.find scope name with
       | Some binding -> Ok binding
       | None -> go rest)
  in
  go !(ctx.scopes)
;;

let binding_type = function
  | Scalar type_ -> type_
  | Struct { type_; _ } -> type_
;;

let declare_scalar ctx name type_ = add_binding ctx name (Scalar type_)

let declare_struct_local ctx name type_ =
  let open Result.Let_syntax in
  let%bind core = core_type_of ctx.struct_env type_ in
  let size = Type.size_in_bytes core |> Int64.of_int |> Ir.Lit_or_var.Lit in
  let ptr_var = Var.create ~name ~type_:Type.Ptr in
  let%bind () = emit ctx.builder (Ir.alloca { dest = ptr_var; size }) in
  add_binding ctx name (Struct { type_; ptr = Ir.Lit_or_var.Var ptr_var })
;;

let resolve_field struct_env struct_name field_name =
  match Map.find struct_env struct_name with
  | None -> Error (`Unknown_struct struct_name)
  | Some info ->
    (match List.findi info.fields ~f:(fun _ (name, _) ->
         String.equal name field_name)
     with
     | None -> Error (`Unknown_field (struct_name, field_name))
     | Some (idx, (_, field_type)) -> Ok (idx, field_type))
;;

let resolve_field_path struct_env struct_name fields =
  let rec go struct_name fields =
    match fields with
    | [] -> Error (`Invalid_lvalue "empty field path")
    | field :: rest ->
      let open Result.Let_syntax in
      let%bind idx, field_type = resolve_field struct_env struct_name field in
      (match rest with
       | [] -> Ok ([ idx ], field_type)
       | _ ->
         (match field_type with
          | Ast.Struct inner ->
            let%map indices, final_type = go inner rest in
            idx :: indices, final_type
          | _ ->
            Error
              (`Invalid_lvalue
                (sprintf
                   "field path continues through non-struct %s"
                   field))))
  in
  go struct_name fields
;;

let rec collect_field_path expr =
  match expr with
  | Ast.Field (base, name) ->
    let base_expr, fields = collect_field_path base in
    base_expr, fields @ [ name ]
  | _ -> expr, []
;;

let ensure_scalar = function
  | Ast.Struct name ->
    Error
      (`Unsupported
        (sprintf "struct values are not supported (%s)" name))
  | t -> Ok t
;;

let ensure_numeric = function
  | Ast.I64 | Ast.F64 -> Ok ()
  | Ast.Ptr _ -> Error (`Type_mismatch "cast only supports numeric types")
  | Ast.Struct name ->
    Error (`Type_mismatch (sprintf "cast cannot use struct %s" name))
;;

let pointer_for_field ctx ~base ~struct_name ~indices =
  let open Result.Let_syntax in
  let struct_core = (Map.find_exn ctx.struct_env struct_name).core_type in
  let%bind offset, _field_type =
    Type.field_offset struct_core indices
    |> Result.map_error ~f:(fun err ->
      `Type_mismatch (Error.to_string_hum err))
  in
  let dest = fresh_temp ctx ~type_:Type.Ptr in
  let%bind () =
    emit
      ctx.builder
      (Ir.add
         { dest
         ; src1 = base
         ; src2 = Ir.Lit_or_var.Lit (Int64.of_int offset)
         })
  in
  Ok (Ir.Lit_or_var.Var dest)
;;

let pointer_for_place ctx = function
  | Mem (Ast.Struct _, base) -> Ok base
  | Field { base; struct_name; indices; field_type = Ast.Struct _ } ->
    pointer_for_field ctx ~base ~struct_name ~indices
  | _ -> Error (`Invalid_lvalue "expected struct memory location")
;;

let float_literal_to_value ctx f =
  let open Result.Let_syntax in
  if Float.(f <> round f)
  then Error (`Unsupported "non-integer float literals are not supported")
  else (
    let i = Int64.of_int (Float.to_int f) in
    let tmp = fresh_temp ctx ~type_:Type.F64 in
    let%bind () = emit ctx.builder (Ir.cast tmp (Ir.Lit_or_var.Lit i)) in
    Ok { operand = Ir.Lit_or_var.Var tmp; type_ = Ast.F64 })
;;

let rec lower_expr ctx expr =
  let open Result.Let_syntax in
  match expr with
  | Ast.Int i -> Ok { operand = Ir.Lit_or_var.Lit i; type_ = Ast.I64 }
  | Ast.Float f -> float_literal_to_value ctx f
  | Ast.Var name ->
    let%bind binding = lookup_binding ctx name in
    (match binding with
     | Scalar type_ ->
       let%bind core_type = core_type_of ctx.struct_env type_ in
       let var = Var.create ~name ~type_:core_type in
       Ok { operand = Ir.Lit_or_var.Var var; type_ }
     | Struct { type_; ptr } -> Ok { operand = ptr; type_ })
  | Ast.Unary (Ast.Neg, expr) ->
    let%bind value = lower_expr ctx expr in
    (match value.type_ with
     | Ast.I64 ->
       let dest = fresh_temp ctx ~type_:Type.I64 in
       let%bind () =
         emit
           ctx.builder
           (Ir.sub
              { dest
              ; src1 = Ir.Lit_or_var.Lit Int64.zero
              ; src2 = value.operand
              })
       in
       Ok { operand = Ir.Lit_or_var.Var dest; type_ = Ast.I64 }
     | Ast.F64 ->
       let zero = fresh_temp ctx ~type_:Type.F64 in
       let%bind () =
         emit ctx.builder (Ir.cast zero (Ir.Lit_or_var.Lit Int64.zero))
       in
       let dest = fresh_temp ctx ~type_:Type.F64 in
       let%bind () =
         emit
           ctx.builder
           (Ir.fsub
              { dest
              ; src1 = Ir.Lit_or_var.Var zero
              ; src2 = value.operand
              })
       in
       Ok { operand = Ir.Lit_or_var.Var dest; type_ = Ast.F64 }
     | Ast.Ptr _ ->
       Error (`Type_mismatch "cannot negate pointer")
     | Ast.Struct _ ->
       Error (`Type_mismatch "cannot negate struct value"))
  | Ast.Unary (Ast.Deref, expr) ->
    let%bind value = lower_expr ctx expr in
    (match value.type_ with
     | Ast.Ptr inner ->
       (match inner with
        | Ast.Struct _ ->
          Ok { operand = value.operand; type_ = inner }
        | _ ->
          let%bind dest_type = core_type_of ctx.struct_env inner in
          let dest = fresh_temp ctx ~type_:dest_type in
          let%bind () =
            emit
              ctx.builder
              (Ir.load dest (Ir.Mem.address value.operand))
          in
          Ok { operand = Ir.Lit_or_var.Var dest; type_ = inner })
     | _ -> Error (`Type_mismatch "deref expects pointer"))
  | Ast.Binary (op, lhs, rhs) ->
    let%bind left = lower_expr ctx lhs in
    let%bind right = lower_expr ctx rhs in
    (match op, left.type_, right.type_ with
     | (Ast.Add | Ast.Sub | Ast.Mul | Ast.Div | Ast.Mod), Ast.I64, Ast.I64 ->
       let dest = fresh_temp ctx ~type_:Type.I64 in
       let instr =
         match op with
         | Ast.Add -> Ir.add
         | Ast.Sub -> Ir.sub
         | Ast.Mul -> Ir.mul
         | Ast.Div -> Ir.div
         | Ast.Mod -> Ir.mod_
       in
       let%bind () =
         emit ctx.builder (instr { dest; src1 = left.operand; src2 = right.operand })
       in
       Ok { operand = Ir.Lit_or_var.Var dest; type_ = Ast.I64 }
     | (Ast.Add | Ast.Sub | Ast.Mul | Ast.Div), Ast.F64, Ast.F64 ->
       let dest = fresh_temp ctx ~type_:Type.F64 in
       let instr =
         match op with
         | Ast.Add -> Ir.fadd
         | Ast.Sub -> Ir.fsub
         | Ast.Mul -> Ir.fmul
         | Ast.Div -> Ir.fdiv
         | Ast.Mod -> failwith "mod not supported for f64"
       in
       let%bind () =
         emit ctx.builder (instr { dest; src1 = left.operand; src2 = right.operand })
       in
       Ok { operand = Ir.Lit_or_var.Var dest; type_ = Ast.F64 }
     | (Ast.Add | Ast.Sub), Ast.Ptr inner, Ast.I64 ->
       let dest = fresh_temp ctx ~type_:Type.Ptr in
       let instr = match op with Ast.Add -> Ir.add | Ast.Sub -> Ir.sub | _ -> Ir.add in
       let%bind () =
         emit ctx.builder (instr { dest; src1 = left.operand; src2 = right.operand })
       in
       Ok { operand = Ir.Lit_or_var.Var dest; type_ = Ast.Ptr inner }
     | (Ast.Add | Ast.Sub), Ast.I64, Ast.Ptr inner ->
       let dest = fresh_temp ctx ~type_:Type.Ptr in
       let instr = match op with Ast.Add -> Ir.add | Ast.Sub -> Ir.sub | _ -> Ir.add in
       let%bind () =
         emit ctx.builder (instr { dest; src1 = left.operand; src2 = right.operand })
       in
       Ok { operand = Ir.Lit_or_var.Var dest; type_ = Ast.Ptr inner }
     | Ast.Sub, Ast.Ptr _, Ast.Ptr _ ->
       let dest = fresh_temp ctx ~type_:Type.I64 in
       let%bind () =
         emit ctx.builder (Ir.sub { dest; src1 = left.operand; src2 = right.operand })
       in
       Ok { operand = Ir.Lit_or_var.Var dest; type_ = Ast.I64 }
     | _ ->
       Error
         (`Type_mismatch
           (sprintf
              "invalid operands for binary op: %s and %s"
              (Ast.sexp_of_type_expr left.type_ |> Sexp.to_string)
              (Ast.sexp_of_type_expr right.type_ |> Sexp.to_string))))
  | Ast.Call (name, args) ->
    (match Map.find ctx.fn_env name with
     | None -> Error (`Unknown_function name)
     | Some sig_ ->
       let%bind arg_operands = lower_call_args ctx sig_.args args in
       let%bind _ = ensure_scalar sig_.return_type in
       let%bind result_type = core_type_of ctx.struct_env sig_.return_type in
       let dest = fresh_temp ctx ~type_:result_type in
       let%bind () =
         emit
           ctx.builder
           (Ir.call ~fn:name ~results:[ dest ] ~args:arg_operands)
       in
       Ok { operand = Ir.Lit_or_var.Var dest; type_ = sig_.return_type })
  | Ast.Field _ ->
    let%bind place = lower_lvalue ctx expr in
    (match place with
     | Field { base; struct_name; indices; field_type } ->
       (match field_type with
        | Ast.Struct _ ->
          let%bind ptr = pointer_for_field ctx ~base ~struct_name ~indices in
          Ok { operand = ptr; type_ = field_type }
        | _ ->
          let%bind dest_type = core_type_of ctx.struct_env field_type in
          let dest = fresh_temp ctx ~type_:dest_type in
          let%bind () =
            emit
              ctx.builder
              (Ir.load_field
                 { dest
                 ; base
                 ; type_ = (Map.find_exn ctx.struct_env struct_name).core_type
                 ; indices
                 })
          in
          Ok { operand = Ir.Lit_or_var.Var dest; type_ = field_type })
     | _ -> Error (`Invalid_lvalue "field access did not resolve to field"))
  | Ast.Alloca type_ ->
    let%bind core = core_type_of ctx.struct_env type_ in
    let size = Type.size_in_bytes core |> Int64.of_int |> Ir.Lit_or_var.Lit in
    let dest = fresh_temp ctx ~type_:Type.Ptr in
    let%bind () = emit ctx.builder (Ir.alloca { dest; size }) in
    Ok { operand = Ir.Lit_or_var.Var dest; type_ = Ast.Ptr type_ }
  | Ast.Cast (dest_type, expr) ->
    let%bind value = lower_expr ctx expr in
    if type_equal dest_type value.type_
    then Ok value
    else (
      let%bind () = ensure_numeric dest_type in
      let%bind () = ensure_numeric value.type_ in
      let%bind dest_core = core_type_of ctx.struct_env dest_type in
      let dest = fresh_temp ctx ~type_:dest_core in
      let%bind () = emit ctx.builder (Ir.cast dest value.operand) in
      Ok { operand = Ir.Lit_or_var.Var dest; type_ = dest_type })

and lower_call_args ctx param_types arg_exprs =
  if List.length param_types <> List.length arg_exprs
  then
    Error
      (`Type_mismatch
        (sprintf
           "function expects %d args but got %d"
           (List.length param_types)
           (List.length arg_exprs)))
  else
    List.fold2_exn param_types arg_exprs ~init:(Ok []) ~f:(fun acc param arg ->
      let open Result.Let_syntax in
      let%bind acc in
      match param with
      | Ast.Struct _ ->
        let%bind value = lower_expr ctx arg in
        if not (type_equal param value.type_)
        then
          Error
            (`Type_mismatch
              (sprintf
                 "function expects %s but got %s"
                 (Sexp.to_string (Ast.sexp_of_type_expr param))
                 (Sexp.to_string (Ast.sexp_of_type_expr value.type_))))
        else
          let%bind core = core_type_of ctx.struct_env param in
          let size =
            Type.size_in_bytes core |> Int64.of_int |> Ir.Lit_or_var.Lit
          in
          let dest = fresh_temp ctx ~type_:Type.Ptr in
          let%bind () = emit ctx.builder (Ir.alloca { dest; size }) in
          let%bind () =
            emit
              ctx.builder
              (Ir.memcpy
                 { dest = Ir.Lit_or_var.Var dest
                 ; src = value.operand
                 ; type_ = core
                 })
          in
          Ok (Ir.Lit_or_var.Var dest :: acc)
      | _ ->
        let%bind value = lower_expr ctx arg in
        if not (type_equal param value.type_)
        then
          Error
            (`Type_mismatch
              (sprintf
                 "function expects %s but got %s"
                 (Sexp.to_string (Ast.sexp_of_type_expr param))
                 (Sexp.to_string (Ast.sexp_of_type_expr value.type_))))
        else Ok (value.operand :: acc))
    |> Result.map ~f:List.rev

and lower_lvalue ctx expr =
  let open Result.Let_syntax in
  match expr with
  | Ast.Var name ->
    let%bind binding = lookup_binding ctx name in
    (match binding with
     | Scalar type_ ->
       let%bind core_type = core_type_of ctx.struct_env type_ in
       let var = Var.create ~name ~type_:core_type in
       Ok (Scalar_var (type_, var))
     | Struct { type_; ptr } -> Ok (Mem (type_, ptr)))
  | Ast.Unary (Ast.Deref, inner) ->
    let%bind value = lower_expr ctx inner in
    (match value.type_ with
     | Ast.Ptr inner_type -> Ok (Mem (inner_type, value.operand))
     | _ -> Error (`Invalid_lvalue "deref expects pointer"))
  | Ast.Field _ ->
    let base_expr, fields = collect_field_path expr in
    let%bind base_value = lower_expr ctx base_expr in
    (match base_value.type_ with
     | Ast.Ptr (Ast.Struct struct_name) | Ast.Struct struct_name ->
       let%bind indices, field_type =
         resolve_field_path ctx.struct_env struct_name fields
       in
       Ok
         (Field
            { base = base_value.operand
            ; struct_name
            ; indices
            ; field_type
            })
     | _ ->
       Error (`Invalid_lvalue "field access expects struct value or pointer"))
  | _ -> Error (`Invalid_lvalue "unsupported lvalue")
;;

let lower_assign ctx lhs rhs =
  let open Result.Let_syntax in
  let%bind place = lower_lvalue ctx lhs in
  match place with
  | Scalar_var (type_, var) ->
    let%bind value = lower_expr ctx rhs in
    if type_equal type_ value.type_
    then emit ctx.builder (Ir.move var value.operand)
    else
      Error
        (`Type_mismatch
          (sprintf
             "assignment expected %s but got %s"
             (Sexp.to_string (Ast.sexp_of_type_expr type_))
             (Sexp.to_string (Ast.sexp_of_type_expr value.type_))))
  | Mem (type_, base) ->
    (match type_ with
     | Ast.Struct _ ->
       let%bind rhs_place = lower_lvalue ctx rhs in
       let%bind dest_ptr = pointer_for_place ctx place in
       let%bind src_ptr = pointer_for_place ctx rhs_place in
       let%bind core_type = core_type_of ctx.struct_env type_ in
       emit ctx.builder (Ir.memcpy { dest = dest_ptr; src = src_ptr; type_ = core_type })
     | _ ->
       let%bind value = lower_expr ctx rhs in
       if type_equal type_ value.type_
       then
         emit
           ctx.builder
           (Ir.store value.operand (Ir.Mem.address base))
       else
         Error
           (`Type_mismatch
             (sprintf
                "assignment expected %s but got %s"
                (Sexp.to_string (Ast.sexp_of_type_expr type_))
                (Sexp.to_string (Ast.sexp_of_type_expr value.type_)))))
  | Field { base; struct_name; indices; field_type } ->
    (match field_type with
     | Ast.Struct _ ->
       let%bind rhs_place = lower_lvalue ctx rhs in
       let%bind dest_ptr = pointer_for_field ctx ~base ~struct_name ~indices in
       let%bind src_ptr = pointer_for_place ctx rhs_place in
       let%bind core_type = core_type_of ctx.struct_env field_type in
       emit ctx.builder (Ir.memcpy { dest = dest_ptr; src = src_ptr; type_ = core_type })
     | _ ->
       let%bind value = lower_expr ctx rhs in
       if type_equal field_type value.type_
       then
         emit
           ctx.builder
           (Ir.store_field
              { base
              ; src = value.operand
              ; type_ = (Map.find_exn ctx.struct_env struct_name).core_type
              ; indices
              })
       else
         Error
           (`Type_mismatch
             (sprintf
                "assignment expected %s but got %s"
                (Sexp.to_string (Ast.sexp_of_type_expr field_type))
                (Sexp.to_string (Ast.sexp_of_type_expr value.type_)))))
;;

let rec lower_stmt ctx stmt =
  let open Result.Let_syntax in
  match stmt with
  | Ast.Let (type_, name, init) ->
    (match type_ with
     | Ast.Struct _ ->
       let%bind () = declare_struct_local ctx name type_ in
       (match init with
        | None -> Ok ()
        | Some expr ->
          let%bind value = lower_expr ctx expr in
          if type_equal type_ value.type_
          then (
            let%bind binding = lookup_binding ctx name in
            match binding with
            | Struct { ptr; _ } ->
              let%bind core_type = core_type_of ctx.struct_env type_ in
              emit
                ctx.builder
                (Ir.memcpy { dest = ptr; src = value.operand; type_ = core_type })
            | Scalar _ -> Error (`Type_mismatch "expected struct binding"))
          else
            let msg =
              sprintf
                "initializer for %s expected %s but got %s"
                name
                (Sexp.to_string (Ast.sexp_of_type_expr type_))
                (Sexp.to_string (Ast.sexp_of_type_expr value.type_))
            in
            Error (`Type_mismatch msg))
     | _ ->
       let%bind () = declare_scalar ctx name type_ in
       (match init with
        | None -> Ok ()
        | Some expr ->
          let%bind value = lower_expr ctx expr in
          if type_equal type_ value.type_
          then
            let%bind core_type = core_type_of ctx.struct_env type_ in
            let var = Var.create ~name ~type_:core_type in
            emit ctx.builder (Ir.move var value.operand)
          else
            let msg =
              sprintf
                "initializer for %s expected %s but got %s"
                name
                (Sexp.to_string (Ast.sexp_of_type_expr type_))
                (Sexp.to_string (Ast.sexp_of_type_expr value.type_))
            in
            Error (`Type_mismatch msg)))
  | Ast.Assign (lhs, rhs) -> lower_assign ctx lhs rhs
  | Ast.Return expr ->
    let%bind value = lower_expr ctx expr in
    if type_equal ctx.return_type value.type_
    then emit ctx.builder (Ir.return value.operand)
    else
      Error
        (`Type_mismatch
          (sprintf
             "return expected %s but got %s"
             (Sexp.to_string (Ast.sexp_of_type_expr ctx.return_type))
             (Sexp.to_string (Ast.sexp_of_type_expr value.type_))))
  | Ast.Expr expr ->
    (match expr with
     | Ast.Call (name, args) ->
       (match Map.find ctx.fn_env name with
        | None -> Error (`Unknown_function name)
        | Some sig_ ->
          let%bind _ = ensure_scalar sig_.return_type in
          let%bind arg_operands = lower_call_args ctx sig_.args args in
          emit ctx.builder (Ir.call ~fn:name ~results:[] ~args:arg_operands))
     | _ ->
       let%map (_ : value) = lower_expr ctx expr in
       ())
  | Ast.If (cond, then_body, else_body) ->
    let%bind cond_value = lower_expr ctx cond in
    if not (type_equal cond_value.type_ Ast.I64)
    then Error (`Type_mismatch "if condition must be i64")
    else (
      let then_label = sprintf "then%d" ctx.builder.label_counter in
      let else_label = sprintf "else%d" ctx.builder.label_counter in
      let end_label = sprintf "endif%d" ctx.builder.label_counter in
      ctx.builder.label_counter <- ctx.builder.label_counter + 1;
      let%bind () =
        emit
          ctx.builder
          (Ir.branch
             (Ir.Branch.Cond
                { cond = cond_value.operand
                ; if_true = { Ir.Call_block.block = then_label; args = [] }
                ; if_false = { Ir.Call_block.block = else_label; args = [] }
                }))
      in
      let%bind () = start_block ~link:false ctx.builder then_label in
      push_scope ctx;
      let%bind () = lower_block ctx then_body in
      pop_scope ctx;
      let%bind () =
        if ctx.builder.terminated
        then Ok ()
        else
          emit
            ctx.builder
            (Ir.branch
               (Ir.Branch.Uncond
                  { Ir.Call_block.block = end_label; args = [] }))
      in
      let%bind () = start_block ~link:false ctx.builder else_label in
      let%bind () =
        match else_body with
        | None -> Ok ()
        | Some else_body ->
          push_scope ctx;
          let%bind () = lower_block ctx else_body in
          pop_scope ctx;
          Ok ()
      in
      let%bind () =
        if ctx.builder.terminated
        then Ok ()
        else
          emit
            ctx.builder
            (Ir.branch
               (Ir.Branch.Uncond
                  { Ir.Call_block.block = end_label; args = [] }))
      in
      start_block ~link:false ctx.builder end_label)
  | Ast.While (cond, body) ->
    let loop_label = sprintf "loop%d" ctx.builder.label_counter in
    let body_label = sprintf "body%d" ctx.builder.label_counter in
    let end_label = sprintf "endloop%d" ctx.builder.label_counter in
    ctx.builder.label_counter <- ctx.builder.label_counter + 1;
    let open Result.Let_syntax in
    let%bind () = start_block ctx.builder loop_label in
    let%bind cond_value = lower_expr ctx cond in
    if not (type_equal cond_value.type_ Ast.I64)
    then Error (`Type_mismatch "while condition must be i64")
    else (
      let%bind () =
        emit
          ctx.builder
          (Ir.branch
             (Ir.Branch.Cond
                { cond = cond_value.operand
                ; if_true = { Ir.Call_block.block = body_label; args = [] }
                ; if_false = { Ir.Call_block.block = end_label; args = [] }
                }))
      in
      let%bind () = start_block ~link:false ctx.builder body_label in
      push_scope ctx;
      let%bind () = lower_block ctx body in
      pop_scope ctx;
      let%bind () =
        if ctx.builder.terminated
        then Ok ()
        else
          emit
            ctx.builder
            (Ir.branch
               (Ir.Branch.Uncond
                  { Ir.Call_block.block = loop_label; args = [] }))
      in
      start_block ~link:false ctx.builder end_label)

and lower_block ctx stmts =
  let open Result.Let_syntax in
  List.fold stmts ~init:(Ok ()) ~f:(fun acc stmt ->
    let%bind () = acc in
    lower_stmt ctx stmt)
;;

let build_struct_env defs =
  let open Result.Let_syntax in
  let%bind base =
    List.fold defs ~init:(Ok String.Map.empty) ~f:(fun acc def ->
      let%bind acc in
      if Map.mem acc def.Ast.name
      then Error (`Type_mismatch (sprintf "duplicate struct %s" def.name))
      else Ok (Map.set acc ~key:def.name ~data:def.fields))
  in
  let rec core_type_of_struct visiting name =
    if Set.mem visiting name
    then Error (`Type_mismatch (sprintf "recursive struct %s" name))
    else (
      match Map.find base name with
      | None -> Error (`Unknown_struct name)
      | Some fields ->
        let%bind field_types =
          result_all
            (List.map fields ~f:(fun (_, ty) ->
               core_type_of_type (Set.add visiting name) ty))
        in
        Ok (Type.Tuple field_types))
  and core_type_of_type visiting = function
    | Ast.I64 -> Ok Type.I64
    | Ast.F64 -> Ok Type.F64
    | Ast.Ptr _ -> Ok Type.Ptr
    | Ast.Struct name -> core_type_of_struct visiting name
  in
  List.fold (Map.to_alist base) ~init:(Ok String.Map.empty) ~f:(fun acc (name, fields) ->
    let%bind acc in
    let%map core_type = core_type_of_struct String.Set.empty name in
    Map.set acc ~key:name ~data:{ fields; core_type })
;;

let build_fn_env (fns : Ast.func list) =
  let open Result.Let_syntax in
  List.fold fns ~init:(Ok String.Map.empty) ~f:(fun acc fn ->
    let%bind acc in
    if Map.mem acc fn.Ast.name
    then Error (`Type_mismatch (sprintf "duplicate function %s" fn.name))
    else
      let args = List.map fn.params ~f:(fun p -> p.Ast.type_) in
      Ok
        (Map.set acc ~key:fn.name ~data:{ args; return_type = fn.return_type }))
;;

let lower_function struct_env fn_env fn =
  let open Result.Let_syntax in
  let%bind _ = ensure_scalar fn.Ast.return_type in
  let builder = create_builder () in
  let ctx =
    { struct_env
    ; fn_env
    ; return_type = fn.return_type
    ; scopes = ref []
    ; used_names = String.Hash_set.create ()
    ; temp_counter = 0
    ; builder
    }
  in
  push_scope ctx;
  let%bind () =
    List.fold fn.params ~init:(Ok ()) ~f:(fun acc param ->
      let%bind () = acc in
      match param.Ast.type_ with
      | Ast.Struct _ ->
        let ptr_var = Var.create ~name:param.name ~type_:Type.Ptr in
        add_binding
          ctx
          param.name
          (Struct { type_ = param.type_; ptr = Ir.Lit_or_var.Var ptr_var })
      | _ -> declare_scalar ctx param.name param.type_)
  in
  let%bind () = lower_block ctx fn.body in
  let%bind () = finish_builder builder in
  let%bind args =
    result_all
      (List.map fn.params ~f:(fun param ->
         match param.Ast.type_ with
         | Ast.Struct _ ->
           let ptr_type = Type.Ptr in
           Ok (Var.create ~name:param.name ~type_:ptr_type)
         | _ ->
           let%map core_type = core_type_of struct_env param.type_ in
           Var.create ~name:param.name ~type_:core_type))
  in
  let root = (~instrs_by_label:builder.instrs_by_label, ~labels:builder.labels) in
  Ok (Function0.create ~name:fn.name ~args ~root)
;;

let lower_program (program : Ast.program) =
  let open Result.Let_syntax in
  let%bind struct_env = build_struct_env program.structs in
  let%bind fn_env = build_fn_env program.functions in
  let%bind functions =
    result_all
      (List.map program.functions ~f:(fun fn -> lower_function struct_env fn_env fn))
  in
  let map =
    String.Map.of_alist_exn
      (List.map functions ~f:(fun fn -> Function0.name fn, fn))
  in
  Ok map
;;
