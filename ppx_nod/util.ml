open Ppxlib
module Builder = Ast_builder.Default

let errorf ~loc fmt = Location.raise_errorf ~loc fmt

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

type arg_type =
  | I64
  | F64
  | Ptr
  | Tuple of arg_type list

let is_atom_type lid =
  match List.rev (longident_to_list lid) with
  | "t" :: "Atom" :: _ -> true
  | _ -> false
;;

let rec arg_type_of_core_type ct =
  match ct.ptyp_desc with
  | Ptyp_tuple l ->
    Tuple (List.map (fun (_, typ) -> arg_type_of_core_type typ) l)
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

let rec type_expr ~loc =
  let open Builder in
  function
  | I64 -> [%expr Nod_core.Type.I64]
  | F64 -> [%expr Nod_core.Type.F64]
  | Ptr -> [%expr Nod_core.Type.Ptr]
  | Tuple l ->
    let l = List.map (type_expr ~loc) l in
    [%expr Nod_core.Type.Tuple [%e elist ~loc l]]
;;

let tuple_n_expr ~loc n args =
  if n < 2 || n > 25
  then Location.raise_errorf ~loc "tuple arity %d not supported by ppx nod" n;
  let ctor = Longident.parse ("Nod_core.Type.Tuple" ^ Int.to_string n) in
  let ctor_expr = Ast_builder.Default.pexp_ident ~loc { loc; txt = ctor } in
  let tuple_expr = Ast_builder.Default.pexp_tuple ~loc args in
  Ast_builder.Default.pexp_apply ~loc ctor_expr [ Nolabel, tuple_expr ]
;;

let rec type_repr_expr ~loc = function
  | I64 -> [%expr Type_repr.Int64]
  | F64 -> [%expr Type_repr.Float64]
  | Ptr -> [%expr Type_repr.Ptr]
  | Tuple tys ->
    let n = List.length tys in
    let args = List.map (type_repr_expr ~loc) tys in
    tuple_n_expr ~loc n args
;;
