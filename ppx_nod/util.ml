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
  | Expr of expression

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
  | Ptyp_constr ({ txt = lid; loc; _ }, []) ->
    (match longident_last lid with
     | "int64" -> I64
     | "float64" -> F64
     | "ptr" -> Ptr
     | other ->
       (match allow_expr with
        | true -> Expr (Builder.pexp_ident ~loc { loc; txt = lid })
        | false ->
          errorf ~loc:ct.ptyp_loc "nod: unsupported argument type %s" other))
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
  | Expr e -> [%expr Dsl.Type_repr.type_ [%e e]]
;;

let tuple_n_expr ~loc args =
  match args with
  | [ a; b ] -> [%expr Dsl.Type_repr.Tuple2 ([%e a], [%e b])]
  | [ a; b; c ] -> [%expr Dsl.Type_repr.Tuple3 ([%e a], [%e b], [%e c])]
  | _ -> failwith "tuple of this size not support by ppx_nod"
;;

(*
   let n = List.length args in
   if n < 2 || n > 25
  then Location.raise_errorf ~loc "tuple arity %d not supported by ppx nod" n;
  let ctor = Longident.parse ("Dsl.Type_repr.Tuple" ^ Int.to_string n) in
  let ctor_expr = Ast_builder.Default.pexp_ident ~loc { loc; txt = ctor } in
  let tuple_expr = Ast_builder.Default.pexp_tuple ~loc args in
  Ast_builder.Default.pexp_apply ~loc ctor_expr [ Nolabel, tuple_expr ]
*)

let rec type_repr_expr ~loc = function
  | I64 -> [%expr Dsl.Type_repr.Int64]
  | F64 -> [%expr Dsl.Type_repr.Float64]
  | Ptr -> [%expr Dsl.Type_repr.Ptr]
  | Expr e -> e
  | Tuple tys ->
    let args = List.map (type_repr_expr ~loc) tys in
    tuple_n_expr ~loc args
;;
