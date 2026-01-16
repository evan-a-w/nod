open Ppxlib
module Builder = Ast_builder.Default

type record_field =
  { field_name : string
  ; field_type : Util.arg_type
  ; field_index : int
  }

let parse_record_type_decl ~loc (type_decl : type_declaration) =
  let type_name = type_decl.ptype_name.txt in
  match type_decl.ptype_kind with
  | Ptype_record label_decls ->
    let fields =
      List.mapi
        (fun i { pld_name; pld_type; _ } ->
          let field_name = pld_name.txt in
          let field_type =
            Util.arg_type_of_core_type ~allow_expr:true pld_type
          in
          { field_name; field_type; field_index = i })
        label_decls
    in
    type_name, fields
  | _ ->
    Location.raise_errorf ~loc "nod_record expects a record type declaration"
;;

let generate_record_type ~loc type_name (fields : record_field list) =
  let open Builder in
  let type_repr_inner =
    ptyp_tuple
      ~loc
      (List.map
         (fun field -> Util.arg_type_to_core_type ~loc field.field_type)
         fields) [@metaloc loc]
  in
  let type_repr_type =
    ptyp_constr
      ~loc
      { loc; txt = Longident.parse "Dsl.Type_repr.t" }
      [ type_repr_inner ]
  in
  let repr_field =
    { pld_name = { loc; txt = "repr" }
    ; pld_mutable = Immutable
    ; pld_type = type_repr_type
    ; pld_loc = loc
    ; pld_attributes = []
    ; pld_modalities = []
    }
  in
  let accessor_fields =
    List.map
      (fun field ->
        let field_type_param =
          Util.arg_type_to_core_type ~loc field.field_type
        in
        { pld_name = { loc; txt = field.field_name }
        ; pld_mutable = Immutable
        ; pld_type =
            ptyp_constr
              ~loc
              { loc; txt = Longident.parse "Dsl.Field.t" }
              [ type_repr_inner
              ; field_type_param
              ; Util.field_type_info_type ~loc field.field_type
              ; Util.field_type_info_kind_type ~loc field.field_type
              ]
        ; pld_loc = loc
        ; pld_attributes = []
        ; pld_modalities = []
        })
      fields
  in
  let all_fields = repr_field :: accessor_fields in
  let tuple_type_alias =
    pstr_type
      ~loc
      Nonrecursive
      [ type_declaration
          ~loc
          ~name:{ loc; txt = type_name ^ Util.record_type_suffix }
          ~params:[]
          ~cstrs:[]
          ~kind:Ptype_abstract
          ~private_:Public
          ~manifest:(Some type_repr_inner)
      ]
  in
  let record_type_decl =
    pstr_type
      ~loc
      Nonrecursive
      [ type_declaration
          ~loc
          ~name:{ loc; txt = type_name ^ Util.value_type_suffix }
          ~params:[]
          ~cstrs:[]
          ~kind:(Ptype_record all_fields)
          ~private_:Public
          ~manifest:None
      ]
  in
  [ tuple_type_alias; record_type_decl ]
;;

let generate_record_value ~loc type_name (fields : record_field list) =
  let open Builder in
  let field_types = List.map (fun f -> f.field_type) fields in
  let overall_type_repr =
    Util.type_repr_expr ~in_record_context:true ~loc (Tuple field_types)
  in
  let field_exprs =
    List.mapi
      (fun index field ->
        let field_type_repr =
          Util.type_repr_expr ~in_record_context:true ~loc field.field_type
        in
        let accessor_record =
          pexp_record
            ~loc
            [ { loc; txt = Lident "record_repr" }, overall_type_repr
            ; { loc; txt = Lident "repr" }, field_type_repr
            ; ( { loc; txt = Lident "name" }
              , Builder.estring ~loc field.field_name )
            ; { loc; txt = Lident "index" }, Builder.eint ~loc index
            ; ( { loc; txt = Lident "type_info" }
              , Util.field_type_info_value ~loc field.field_type )
            ]
            None
        in
        { loc; txt = Lident field.field_name }, accessor_record)
      fields
  in
  let repr_field = { loc; txt = Lident "repr" }, overall_type_repr in
  let all_field_exprs = repr_field :: field_exprs in
  let record_expr = pexp_record ~loc all_field_exprs None in
  pstr_value
    ~loc
    Nonrecursive
    [ value_binding ~loc ~pat:(pvar ~loc type_name) ~expr:record_expr ]
;;

let str_type_decl ~ctxt (_rec_flag, type_decls) =
  let loc = Expansion_context.Deriver.derived_item_loc ctxt in
  match type_decls with
  | [ type_decl ] ->
    let type_name, fields = parse_record_type_decl ~loc type_decl in
    let record_types = generate_record_type ~loc type_name fields in
    let record_value = generate_record_value ~loc type_name fields in
    record_types @ [ record_value ]
  | _ ->
    Location.raise_errorf
      ~loc
      "nod_record can only be derived for a single type at a time"
;;

let sig_type_decl ~ctxt:_ (_rec_flag, _type_decls) = []

let _nod_record_deriver =
  Deriving.add
    "nod_record"
    ~str_type_decl:(Deriving.Generator.V2.make_noarg str_type_decl)
    ~sig_type_decl:(Deriving.Generator.V2.make_noarg sig_type_decl)
;;
