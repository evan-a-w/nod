open Ppxlib
module Builder = Ast_builder.Default

let errorf ~loc fmt = Location.raise_errorf ~loc fmt

let rec longident_to_list lid =
  match lid with
  | Lident name -> [ name ]
  | Ldot (prefix, name) -> longident_to_list prefix @ [ name ]
  | Lapply (_, arg) -> longident_to_list arg
;;

let longident_append_suffix lid ~suffix =
  match lid with
  | Lident name -> Lident (name ^ suffix)
  | Ldot (prefix, name) -> Ldot (prefix, name ^ suffix)
  | Lapply (_, _) -> failwith "can't append lapply"
;;

let longident_last lid =
  match List.rev (longident_to_list lid) with
  | last :: _ -> last
  | [] -> ""
;;

type arg_type =
  | I64
  | F64
  | Ptr of ptr_kind
  | Tuple of arg_type list
  | Lid of lid_info

and lid_info =
  { lid : Longident.t
  ; loc : location
  ; is_type_name : bool
  }

and ptr_kind =
  | Untyped
  | Typed of arg_type

let ident lid loc = Builder.pexp_ident ~loc { loc; txt = lid }

let is_atom_type lid =
  match List.rev (longident_to_list lid) with
  | "t" :: "Atom" :: _ -> true
  | _ -> false
;;

let rec arg_type_of_core_type ~allow_expr ct =
  match ct.ptyp_desc with
  | Ptyp_tuple l ->
    Tuple (List.map (fun (_, typ) -> arg_type_of_core_type ~allow_expr typ) l)
  | Ptyp_constr ({ txt = lid; _ }, args) when is_atom_type lid ->
    (match args with
     | [ arg ] -> arg_type_of_core_type ~allow_expr arg
     | _ ->
       errorf
         ~loc:ct.ptyp_loc
         "nod: Atom.t annotations must have exactly one type argument")
  | Ptyp_constr ({ txt = lid; loc; _ }, args) ->
    (match longident_last lid, args with
     | "int64", [] -> I64
     | "float64", [] -> F64
     | "ptr", [] ->
       if allow_expr
       then
         errorf
           ~loc:ct.ptyp_loc
           "nod: ptr types must specify the pointed-to type"
       else Ptr Untyped
     | "ptr", [ arg ] -> Ptr (Typed (arg_type_of_core_type ~allow_expr arg))
     | "ptr", _ ->
       errorf ~loc:ct.ptyp_loc "nod: ptr expects exactly one type argument"
     | _other, [] -> Lid { lid; loc; is_type_name = not allow_expr }
     | other, _ ->
       errorf
         ~loc:ct.ptyp_loc
         "nod: unsupported argument type %s with parameters"
         other)
  | _ -> errorf ~loc:ct.ptyp_loc "nod: unsupported argument type"
;;

let rec type_expr ~loc =
  let open Builder in
  function
  | I64 -> [%expr Nod_common.Type.I64]
  | F64 -> [%expr Nod_common.Type.F64]
  | Ptr Untyped -> [%expr Nod_common.Type.Ptr]
  | Ptr (Typed inner) ->
    let inner = type_expr ~loc inner in
    [%expr Nod_common.Type.Ptr_typed [%e inner]]
  | Tuple l ->
    let l = List.map (type_expr ~loc) l in
    [%expr Nod_common.Type.Tuple [%e elist ~loc l]]
  | Lid { lid; loc; is_type_name } ->
    let base = ident lid loc in
    let repr_expr =
      if is_type_name
      then Builder.pexp_field ~loc base { loc; txt = Longident.parse "repr" }
      else base
    in
    [%expr Dsl.Type_repr.type_ [%e repr_expr]]
;;

let tuple_n_expr ~loc args =
  let n = List.length args in
  if n < 2 || n > 25
  then Location.raise_errorf ~loc "tuple arity %d not supported by ppx_nod" n;
  let ctor_lid = Longident.parse ("Dsl.Type_repr.Tuple" ^ Int.to_string n) in
  let tuple_expr = Ast_builder.Default.pexp_tuple ~loc args in
  Ast_builder.Default.pexp_construct
    ~loc
    { loc; txt = ctor_lid }
    (Some tuple_expr)
;;

let record_type_suffix = "_tuple_alias"
let value_type_suffix = "_t"

let rec type_repr_expr ~in_record_context ~loc = function
  | I64 -> [%expr Dsl.Type_repr.Int64]
  | F64 -> [%expr Dsl.Type_repr.Float64]
  | Ptr Untyped ->
    Location.raise_errorf
      ~loc
      "nod: ptr type expressions must specify the pointed-to type"
  | Ptr (Typed inner) ->
    let inner = type_repr_expr ~in_record_context ~loc inner in
    [%expr Dsl.Type_repr.Ptr [%e inner]]
  | Lid { lid; loc; is_type_name } when in_record_context || is_type_name ->
    Builder.pexp_field
      ~loc
      (ident lid loc)
      { loc; txt = Longident.parse "repr" }
  | Lid { lid; loc; _ } -> ident lid loc
  | Tuple [ ty ] -> type_repr_expr ~in_record_context ~loc ty
  | Tuple tys ->
    let args = List.map (type_repr_expr ~in_record_context ~loc) tys in
    tuple_n_expr ~loc args
;;

let rec arg_type_to_core_type ~loc = function
  | I64 -> [%type: Dsl.int64] [@metaloc loc]
  | F64 -> [%type: Dsl.float64] [@metaloc loc]
  | Ptr Untyped -> [%type: Dsl.ptr] [@metaloc loc]
  | Ptr (Typed inner) ->
    let inner = arg_type_to_core_type ~loc inner in
    Builder.ptyp_constr ~loc { loc; txt = Longident.parse "Dsl.ptr" } [ inner ]
  | Tuple tys ->
    let tuple_types = List.map (arg_type_to_core_type ~loc) tys in
    Builder.ptyp_tuple ~loc tuple_types
  | Lid { lid; loc; _ } ->
    Builder.ptyp_constr
      ~loc
      { txt = longident_append_suffix lid ~suffix:record_type_suffix; loc }
      []
;;

let field_type_info_kind_type ~loc = function
  | I64 | F64 | Ptr _ | Tuple _ ->
    Builder.ptyp_constr ~loc { txt = Longident.parse "Dsl.base"; loc } []
  | Lid _ ->
    Builder.ptyp_constr ~loc { txt = Longident.parse "Dsl.record"; loc } []
;;

let field_type_info_type ~loc = function
  | I64 | F64 | Ptr _ | Tuple _ ->
    Builder.ptyp_constr ~loc { txt = Longident.parse "unit"; loc } []
  | Lid { lid; loc; _ } ->
    Builder.ptyp_constr
      ~loc
      { txt = longident_append_suffix lid ~suffix:value_type_suffix; loc }
      []
;;

let field_type_info_value ~loc = function
  | I64 | F64 | Ptr _ | Tuple _ -> [%expr ()]
  | Lid { lid; loc; _ } -> ident lid loc
;;
