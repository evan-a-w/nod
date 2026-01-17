open! Core
include Ir0
module Block = Block
module Call_block = Call_block

type nonrec t = Block.t t [@@deriving sexp, compare, equal, hash]

let add_block_args =
  let on_call_block { Call_block.block; args = _ } =
    { Call_block.block; args = Vec.to_list block.Block.args }
  in
  function
  | ( Add _
    | And _
    | Or _
    | Mul _
    | Div _
    | Lt _
    | Fadd _
    | Fsub _
    | Fmul _
    | Fdiv _
    | Alloca _
    | Load _
    | Store _
    | Load_field _
    | Store_field _
    | Memcpy _
    | Atomic_load _
    | Atomic_store _
    | Atomic_rmw _
    | Atomic_cmpxchg _
    | Mod _
    | Sub _
    | Move _
    | Cast _
    | Call _
    | Unreachable
    | Noop
    | Return _ ) as t -> t
  | Arm64 arm64_ir -> Arm64 (Arm64_ir.map_call_blocks arm64_ir ~f:on_call_block)
  | Arm64_terminal arm64_irs ->
    Arm64_terminal
      (List.map ~f:(Arm64_ir.map_call_blocks ~f:on_call_block) arm64_irs)
  | X86 x86_ir -> X86 (X86_ir.map_call_blocks x86_ir ~f:on_call_block)
  | X86_terminal x86_irs ->
    X86_terminal (List.map ~f:(X86_ir.map_call_blocks ~f:on_call_block) x86_irs)
  | Branch (Branch.Cond { cond; if_true; if_false }) ->
    Branch
      (Branch.Cond
         { cond
         ; if_true = on_call_block if_true
         ; if_false = on_call_block if_false
         })
  | Branch (Branch.Uncond call) -> Branch (Branch.Uncond (on_call_block call))
;;

let remove_block_args =
  let on_call_block (call_block : Block.t Call_block.t) =
    { call_block with args = [] }
  in
  function
  | ( Add _
    | And _
    | Or _
    | Mul _
    | Div _
    | Lt _
    | Fadd _
    | Fsub _
    | Fmul _
    | Fdiv _
    | Alloca _
    | Load _
    | Store _
    | Load_field _
    | Store_field _
    | Memcpy _
    | Atomic_load _
    | Atomic_store _
    | Atomic_rmw _
    | Atomic_cmpxchg _
    | Mod _
    | Sub _
    | Move _
    | Cast _
    | Call _
    | Unreachable
    | Noop
    | Return _ ) as t -> t
  | Arm64 arm64_ir -> Arm64 (Arm64_ir.map_call_blocks arm64_ir ~f:on_call_block)
  | Arm64_terminal arm64_irs ->
    Arm64_terminal
      (List.map ~f:(Arm64_ir.map_call_blocks ~f:on_call_block) arm64_irs)
  | X86 x86_ir -> X86 (X86_ir.map_call_blocks x86_ir ~f:on_call_block)
  | X86_terminal x86_irs ->
    X86_terminal (List.map ~f:(X86_ir.map_call_blocks ~f:on_call_block) x86_irs)
  | Branch (Branch.Cond { cond; if_true; if_false }) ->
    Branch
      (Branch.Cond
         { cond
         ; if_true = on_call_block if_true
         ; if_false = on_call_block if_false
         })
  | Branch (Branch.Uncond call) -> Branch (Branch.Uncond (on_call_block call))
;;

let iter_blocks_and_args t ~f =
  iter_call_blocks t ~f:(fun { block; args } ->
    f ~block:block.Block.id_hum ~args)
;;

include functor Hashable.Make
include functor Comparable.Make

module Aggregate = struct
  open Or_error.Let_syntax

  let type_error fmt = Printf.ksprintf Or_error.error_string fmt

  let ensure_value_type type_ =
    if Type.is_aggregate type_
    then type_error "aggregate values are not supported: %s" (Type.to_string type_)
    else Ok type_
  ;;

  let field_offset type_ indices =
    if List.is_empty indices
    then type_error "field access requires at least one index"
    else Type.field_offset type_ indices
  ;;

  let ensure_pointer_operand operand ~op ~position =
    match operand with
    | Lit_or_var.Lit _ -> Ok ()
    | Var v ->
      if Type.is_ptr (Var.type_ v)
      then Ok ()
      else
        type_error
          "%s expects %s pointer but got %s:%s"
          op
          position
          (Var.name v)
          (Type.to_string (Var.type_ v))
    | Global _ -> Ok ()
  ;;

  let ensure_pointer_target type_ ~expected ~op ~position =
    match Type.ptr_target type_ with
    | None -> Ok ()
    | Some inner ->
      if Type.equal inner expected
      then Ok ()
      else
        type_error
          "%s expects %s pointer to %s but got %s"
          op
          position
          (Type.to_string expected)
          (Type.to_string type_)
  ;;

  let ensure_pointer_operand_target operand ~expected ~op ~position =
    match operand with
    | Lit_or_var.Lit _ -> Ok ()
    | Var v -> ensure_pointer_target (Var.type_ v) ~expected ~op ~position
    | Global g ->
      ensure_pointer_target (Type.Ptr_typed g.Global.type_) ~expected ~op ~position
  ;;

  let types_compatible ~expected ~actual =
    Type.equal expected actual
    || (Type.equal expected Type.Ptr && Type.is_ptr actual)
  ;;

  let lower_load_field ({ dest; base; type_; indices } : load_field) =
    let%bind () = ensure_pointer_operand base ~op:"load_field" ~position:"base" in
    let%bind offset, raw_field_type = field_offset type_ indices in
    match raw_field_type with
    | Tuple _ ->
      if Type.is_ptr (Var.type_ dest)
      then
        let%bind () =
          ensure_pointer_target
            (Var.type_ dest)
            ~expected:raw_field_type
            ~op:"load_field"
            ~position:"destination"
        in
        Ok
          [ add
              { dest
              ; src1 = base
              ; src2 = Lit_or_var.Lit (Int64.of_int offset)
              }
          ]
      else
        type_error
          "load_field expected pointer destination for aggregate field but got %s"
          (Type.to_string (Var.type_ dest))
    | _ ->
      let%bind field_type = ensure_value_type raw_field_type in
      let%bind () =
        if Type.equal field_type (Var.type_ dest)
        then Ok ()
        else
          type_error
            "load_field expected destination of type %s but got %s"
            (Type.to_string field_type)
            (Type.to_string (Var.type_ dest))
      in
      Ok [ load dest (Mem.address base ~offset) ]
  ;;

  let lower_store_field ({ base; src; type_; indices } : store_field) ~fresh_temp
    =
    let%bind () =
      ensure_pointer_operand base ~op:"store_field" ~position:"base"
    in
    let%bind offset, raw_field_type = field_offset type_ indices in
    match raw_field_type with
    | Tuple _ ->
      let%bind () =
        ensure_pointer_operand src ~op:"store_field" ~position:"source"
      in
      let dest = fresh_temp ~type_:(Type.Ptr_typed raw_field_type) in
      let%bind () =
        ensure_pointer_operand_target
          src
          ~expected:raw_field_type
          ~op:"store_field"
          ~position:"source"
      in
      Ok
        [ add
            { dest
            ; src1 = base
            ; src2 = Lit_or_var.Lit (Int64.of_int offset)
            }
        ; memcpy { dest = Lit_or_var.Var dest; src; type_ = raw_field_type }
        ]
    | _ ->
      let%bind field_type = ensure_value_type raw_field_type in
      let%bind () =
        match src with
        | Lit_or_var.Lit _ -> Ok ()
        | Var v ->
          if types_compatible ~expected:field_type ~actual:(Var.type_ v)
          then Ok ()
          else
            type_error
              "store_field expected source of type %s but got %s"
              (Type.to_string field_type)
              (Type.to_string (Var.type_ v))
        | Global g ->
          let actual = Type.Ptr_typed g.Global.type_ in
          if types_compatible ~expected:field_type ~actual
          then Ok ()
          else
            type_error
              "store_field expected source of type %s but got %s"
              (Type.to_string field_type)
              (Type.to_string actual)
      in
      Ok [ store src (Mem.address base ~offset) ]
  ;;

  let lower_memcpy ({ dest; src; type_ } : memcpy) ~fresh_temp =
    let%bind () =
      ensure_pointer_operand dest ~op:"memcpy" ~position:"destination"
    in
    let%bind () = ensure_pointer_operand src ~op:"memcpy" ~position:"source" in
    let%bind () =
      ensure_pointer_operand_target
        dest
        ~expected:type_
        ~op:"memcpy"
        ~position:"destination"
    in
    let%bind () =
      ensure_pointer_operand_target
        src
        ~expected:type_
        ~op:"memcpy"
        ~position:"source"
    in
    let leaves = Type.leaf_offsets type_ in
    let rec emit acc = function
      | [] -> Ok (List.rev acc)
      | (offset, raw_field_type) :: rest ->
        let%bind field_type = ensure_value_type raw_field_type in
        let temp = fresh_temp ~type_:field_type in
        let load_instr = load temp (Mem.address src ~offset) in
        let store_instr = store (Lit_or_var.Var temp) (Mem.address dest ~offset) in
        emit (store_instr :: load_instr :: acc) rest
    in
    emit [] leaves
  ;;

  let lower_instruction ~fresh_temp = function
    | Load_field t -> lower_load_field t
    | Store_field t -> lower_store_field t ~fresh_temp
    | Memcpy t -> lower_memcpy t ~fresh_temp
    | instr -> Ok [ instr ]
  ;;
end

module Type_check = struct
  open Result.Let_syntax

  let type_error fmt =
    Printf.ksprintf (fun msg -> Error (`Type_mismatch msg)) fmt
  ;;

  let literal_allowed type_ = Type.is_numeric type_ || Type.is_ptr type_

  let types_compatible ~expected ~actual =
    Type.equal expected actual
    || (Type.equal expected Type.Ptr && Type.is_ptr actual)
  ;;

  let ensure_operand_matches operand ~expected_type ~op ~position =
    match operand with
    | Lit_or_var.Lit _ ->
      if literal_allowed expected_type
      then Ok ()
      else
        type_error
          "%s expects %s of type %s"
          op
          position
          (Type.to_string expected_type)
    | Var var ->
      if types_compatible ~expected:expected_type ~actual:(Var.type_ var)
      then Ok ()
      else
        type_error
          "%s expects %s of type %s but got %s:%s"
          op
          position
          (Type.to_string expected_type)
          (Var.name var)
          (Type.to_string (Var.type_ var))
    | Global g ->
      let actual = Type.Ptr_typed g.Global.type_ in
      if types_compatible ~expected:expected_type ~actual
      then Ok ()
      else
        type_error
          "%s expects %s of type %s but got %s"
          op
          position
          (Type.to_string expected_type)
          (Type.to_string actual)
  ;;

  let ensure_integer_var var ~op ~position =
    if Type.is_integer (Var.type_ var)
    then Ok ()
    else
      type_error
        "%s expects %s to be integer but %s:%s"
        op
        position
        (Var.name var)
        (Type.to_string (Var.type_ var))
  ;;

  let ensure_integer_operand operand ~op ~position =
    match operand with
    | Lit_or_var.Lit _ -> Ok ()
    | Var var -> ensure_integer_var var ~op ~position
    | Global g ->
      type_error
        "%s expects %s to be integer but got %s"
        op
        position
        (Type.to_string (Type.Ptr_typed g.Global.type_))
  ;;

  let ensure_pointer_operand operand ~op ~position =
    match operand with
    | Lit_or_var.Lit _ -> Ok ()
    | Var var ->
      if Type.is_ptr (Var.type_ var)
      then Ok ()
      else
        type_error
          "%s expects %s pointer but got %s:%s"
          op
          position
          (Var.name var)
          (Type.to_string (Var.type_ var))
    | Global _ -> Ok ()
  ;;

  let ensure_pointer_target type_ ~expected ~op ~position =
    match Type.ptr_target type_ with
    | None -> Ok ()
    | Some inner ->
      if Type.equal inner expected
      then Ok ()
      else
        type_error
          "%s expects %s pointer to %s but got %s"
          op
          position
          (Type.to_string expected)
          (Type.to_string type_)
  ;;

  let ensure_pointer_mem mem ~op =
    match mem with
    | Mem.Stack_slot _ -> Ok ()
    | Mem.Address { base; _ } ->
      ensure_pointer_operand base ~op ~position:"memory operand"
    | Mem.Global _ -> Ok ()
  ;;

  let ensure_value_type type_ =
    if Type.is_aggregate type_
    then type_error "aggregate values are not supported: %s" (Type.to_string type_)
    else Ok type_
  ;;

  let or_error_to_result = function
    | Ok v -> Ok v
    | Error err -> type_error "%s" (Error.to_string_hum err)
  ;;

  let field_offset type_ indices =
    if List.is_empty indices
    then type_error "field access requires at least one index"
    else or_error_to_result (Type.field_offset type_ indices)
  ;;

  let check_arith ~op { dest; src1; src2 } =
    let dest_type = Var.type_ dest in
    let is_ptr = function
      | Lit_or_var.Lit _ -> false
      | Lit_or_var.Var v -> Type.is_ptr (Var.type_ v)
      | Lit_or_var.Global _ -> true
    in
    let is_i64 = function
      | Lit_or_var.Lit _ -> true
      | Lit_or_var.Var v -> Type.equal (Var.type_ v) Type.I64
      | Lit_or_var.Global _ -> false
    in
    match dest_type with
    | _ when Type.is_ptr dest_type ->
      (* Pointer arithmetic: ptr ± i64 = ptr *)
      if (is_ptr src1 && is_i64 src2) || (is_i64 src1 && is_ptr src2)
      then Ok ()
      else
        type_error
          "%s with pointer destination requires one pointer and one i64 operand"
          op
    | _ when Type.is_integer dest_type ->
      (* Check for pointer subtraction: ptr - ptr = i64 *)
      if is_ptr src1 && is_ptr src2 && String.equal op "sub"
      then Ok ()
      else (
        (* Regular integer arithmetic: all operands must match *)
        let%bind () =
          ensure_operand_matches
            src1
            ~expected_type:dest_type
            ~op
            ~position:"lhs"
        in
        ensure_operand_matches src2 ~expected_type:dest_type ~op ~position:"rhs")
    | _ ->
      type_error
        "%s destination %s:%s must be integer or pointer"
        op
        (Var.name dest)
        (Type.to_string dest_type)
  ;;

  let check_float_arith ~op { dest; src1; src2 } =
    let dest_type = Var.type_ dest in
    if not (Type.is_float dest_type)
    then
      type_error
        "%s destination %s:%s must be float (f32 or f64)"
        op
        (Var.name dest)
        (Type.to_string dest_type)
    else (
      let%bind () =
        ensure_operand_matches src1 ~expected_type:dest_type ~op ~position:"lhs"
      in
      ensure_operand_matches src2 ~expected_type:dest_type ~op ~position:"rhs")
  ;;

  let check_alloca { dest; size } =
    let%bind () =
      if Type.is_ptr (Var.type_ dest)
      then Ok ()
      else
        type_error
          "alloca destination %s:%s must have ptr type"
          (Var.name dest)
          (Type.to_string (Var.type_ dest))
    in
    ensure_integer_operand size ~op:"alloca" ~position:"size"
  ;;

  let check_move (dest, src) =
    match src with
    | Lit_or_var.Lit _ ->
      if literal_allowed (Var.type_ dest)
      then Ok ()
      else
        type_error
          "cannot assign literal to %s:%s"
          (Var.name dest)
          (Type.to_string (Var.type_ dest))
    | Var src_var ->
      if types_compatible
           ~expected:(Var.type_ dest)
           ~actual:(Var.type_ src_var)
      then Ok ()
      else
        type_error
          "move destination %s:%s does not match source %s:%s"
          (Var.name dest)
          (Type.to_string (Var.type_ dest))
          (Var.name src_var)
          (Type.to_string (Var.type_ src_var))
    | Global g ->
      let actual = Type.Ptr_typed g.Global.type_ in
      if types_compatible ~expected:(Var.type_ dest) ~actual
      then Ok ()
      else
        type_error
          "move destination %s:%s does not match source %s"
          (Var.name dest)
          (Type.to_string (Var.type_ dest))
          (Type.to_string actual)
  ;;

  let check_cast (dest, src) =
    let dest_type = Var.type_ dest in
    match src with
    | Lit_or_var.Lit _ ->
      (* Literals can be cast to compatible types *)
      if Type.is_numeric dest_type || Type.is_ptr dest_type
      then Ok ()
      else
        type_error
          "cast cannot convert literal to %s:%s"
          (Var.name dest)
          (Type.to_string dest_type)
    | Var src_var ->
      let src_type = Var.type_ src_var in
      (* Cast requires different types *)
      if Type.equal src_type dest_type
      then
        type_error
          "cast requires different types, use move for %s to %s"
          (Type.to_string src_type)
          (Type.to_string dest_type)
      else if Type.is_numeric src_type && Type.is_numeric dest_type
      then Ok () (* Numeric conversions are valid *)
      else if Type.is_ptr src_type && Type.is_ptr dest_type
      then Ok () (* Pointer bitcasts are valid *)
      else
        type_error
          "cast cannot convert %s:%s to %s:%s"
          (Var.name src_var)
          (Type.to_string src_type)
          (Var.name dest)
          (Type.to_string dest_type)
    | Global g ->
      let src_type = Type.Ptr_typed g.Global.type_ in
      if Type.equal src_type dest_type
      then
        type_error
          "cast requires different types, use move for %s to %s"
          (Type.to_string src_type)
          (Type.to_string dest_type)
      else if Type.is_ptr dest_type
      then Ok ()
      else
        type_error
          "cast cannot convert %s to %s:%s"
          (Type.to_string src_type)
          (Var.name dest)
          (Type.to_string dest_type)
  ;;

  let check_branch_cond cond =
    ensure_integer_operand cond ~op:"branch" ~position:"condition"
  ;;

  let check_load (dest, mem) =
    let%bind () = ensure_pointer_mem mem ~op:"load" in
    match mem with
    | Mem.Global global ->
      if Type.equal (Var.type_ dest) global.Global.type_
      then Ok ()
      else
        type_error
          "load expected destination of type %s but got %s"
          (Type.to_string global.Global.type_)
          (Type.to_string (Var.type_ dest))
    | _ -> Ok ()
  ;;

  let check_store (value, mem) =
    let%bind () = ensure_pointer_mem mem ~op:"store" in
    match mem with
    | Mem.Global global ->
      (match value with
       | Lit_or_var.Lit _ ->
         if literal_allowed global.Global.type_
         then Ok ()
         else
           type_error
             "cannot assign literal to global of type %s"
             (Type.to_string global.Global.type_)
       | Var v ->
         if types_compatible
              ~expected:global.Global.type_
              ~actual:(Var.type_ v)
         then Ok ()
         else
           type_error
             "store expected source of type %s but got %s"
             (Type.to_string global.Global.type_)
             (Type.to_string (Var.type_ v))
       | Global g ->
         let actual = Type.Ptr_typed g.Global.type_ in
         if types_compatible ~expected:global.Global.type_ ~actual
         then Ok ()
         else
           type_error
             "store expected source of type %s but got %s"
             (Type.to_string global.Global.type_)
             (Type.to_string actual))
    | _ ->
      (match value with
       | Lit_or_var.Lit _ -> Ok ()
       | Var _ -> Ok ()
       | Global _ -> Ok ())
  ;;

  let check_load_field ({ dest; base; type_; indices } : load_field) =
    let%bind () =
      ensure_pointer_operand base ~op:"load_field" ~position:"base"
    in
    let%bind _offset, raw_field_type = field_offset type_ indices in
    (match raw_field_type with
     | Tuple _ ->
       if Type.is_ptr (Var.type_ dest)
       then
         ensure_pointer_target
           (Var.type_ dest)
           ~expected:raw_field_type
           ~op:"load_field"
           ~position:"destination"
       else
         type_error
           "load_field expected pointer destination for aggregate field but got %s"
           (Type.to_string (Var.type_ dest))
     | _ ->
       let%bind field_type = ensure_value_type raw_field_type in
       if Type.equal (Var.type_ dest) field_type
       then Ok ()
       else
         type_error
           "load_field expected destination of type %s but got %s"
           (Type.to_string field_type)
           (Type.to_string (Var.type_ dest)))
  ;;

  let check_store_field ({ base; src; type_; indices } : store_field) =
    let%bind () =
      ensure_pointer_operand base ~op:"store_field" ~position:"base"
    in
    let%bind _offset, raw_field_type = field_offset type_ indices in
    (match raw_field_type with
     | Tuple _ ->
       let%bind () =
         ensure_pointer_operand src ~op:"store_field" ~position:"source"
       in
       (match src with
        | Lit_or_var.Lit _ -> Ok ()
        | Var v ->
          ensure_pointer_target
            (Var.type_ v)
            ~expected:raw_field_type
            ~op:"store_field"
            ~position:"source"
        | Global g ->
          ensure_pointer_target
            (Type.Ptr_typed g.Global.type_)
            ~expected:raw_field_type
            ~op:"store_field"
            ~position:"source")
     | _ ->
       let%bind field_type = ensure_value_type raw_field_type in
       match src with
       | Lit_or_var.Lit _ -> Ok ()
       | Var v when types_compatible ~expected:field_type ~actual:(Var.type_ v) ->
         Ok ()
       | Var v ->
         type_error
           "store_field expected source of type %s but got %s"
           (Type.to_string field_type)
           (Type.to_string (Var.type_ v))
       | Global g ->
         let actual = Type.Ptr_typed g.Global.type_ in
         if types_compatible ~expected:field_type ~actual
         then Ok ()
         else
           type_error
             "store_field expected source of type %s but got %s"
             (Type.to_string field_type)
             (Type.to_string actual))
  ;;

  let check_memcpy ({ dest; src; type_ } : memcpy) =
    let%bind () =
      ensure_pointer_operand dest ~op:"memcpy" ~position:"destination"
    in
    let%bind () = ensure_pointer_operand src ~op:"memcpy" ~position:"source" in
    let%bind () =
      match dest with
      | Lit_or_var.Lit _ -> Ok ()
      | Var v ->
        ensure_pointer_target
          (Var.type_ v)
          ~expected:type_
          ~op:"memcpy"
          ~position:"destination"
      | Global g ->
        ensure_pointer_target
          (Type.Ptr_typed g.Global.type_)
          ~expected:type_
          ~op:"memcpy"
          ~position:"destination"
    in
    let%bind () =
      match src with
      | Lit_or_var.Lit _ -> Ok ()
      | Var v ->
        ensure_pointer_target
          (Var.type_ v)
          ~expected:type_
          ~op:"memcpy"
          ~position:"source"
      | Global g ->
        ensure_pointer_target
          (Type.Ptr_typed g.Global.type_)
          ~expected:type_
          ~op:"memcpy"
          ~position:"source"
    in
    List.fold (Type.leaf_offsets type_) ~init:(Ok ()) ~f:(fun acc (_, leaf) ->
      let%bind () = acc in
      let%map (_ : Type.t) = ensure_value_type leaf in
      ())
  ;;

  let check_atomic_load ({ dest; addr; order = _ } : atomic_load) =
    let%bind () = ensure_pointer_mem addr ~op:"atomic_load" in
    let dest_type = Var.type_ dest in
    if Type.is_integer dest_type || Type.is_ptr dest_type
    then Ok ()
    else
      type_error
        "atomic_load destination %s:%s must be integer or pointer"
        (Var.name dest)
        (Type.to_string dest_type)
  ;;

  let check_atomic_store ({ addr; src; order = _ } : atomic_store) =
    let%bind () = ensure_pointer_mem addr ~op:"atomic_store" in
    match src with
    | Lit_or_var.Lit _ -> Ok ()
    | Var v ->
      let src_type = Var.type_ v in
      if Type.is_integer src_type || Type.is_ptr src_type
      then Ok ()
      else
        type_error
          "atomic_store source %s:%s must be integer or pointer"
          (Var.name v)
          (Type.to_string src_type)
    | Global _ -> Ok ()
  ;;

  let check_atomic_rmw ({ dest; addr; src; op = _; order = _ } : atomic_rmw) =
    let%bind () = ensure_pointer_mem addr ~op:"atomic_rmw" in
    let dest_type = Var.type_ dest in
    let%bind () =
      if Type.is_integer dest_type || Type.is_ptr dest_type
      then Ok ()
      else
        type_error
          "atomic_rmw destination %s:%s must be integer or pointer"
          (Var.name dest)
          (Type.to_string dest_type)
    in
    ensure_operand_matches
      src
      ~expected_type:dest_type
      ~op:"atomic_rmw"
      ~position:"source"
  ;;

  let check_atomic_cmpxchg
    ({ dest
     ; success
     ; addr
     ; expected
     ; desired
     ; success_order = _
     ; failure_order = _
     }
    : atomic_cmpxchg)
    =
    let%bind () = ensure_pointer_mem addr ~op:"atomic_cmpxchg" in
    let dest_type = Var.type_ dest in
    let%bind () =
      if Type.is_integer dest_type || Type.is_ptr dest_type
      then Ok ()
      else
        type_error
          "atomic_cmpxchg destination %s:%s must be integer or pointer"
          (Var.name dest)
          (Type.to_string dest_type)
    in
    let%bind () =
      if Type.equal (Var.type_ success) Type.I64
      then Ok ()
      else
        type_error
          "atomic_cmpxchg success flag %s:%s must be i64"
          (Var.name success)
          (Type.to_string (Var.type_ success))
    in
    let%bind () =
      ensure_operand_matches
        expected
        ~expected_type:dest_type
        ~op:"atomic_cmpxchg"
        ~position:"expected"
    in
    ensure_operand_matches
      desired
      ~expected_type:dest_type
      ~op:"atomic_cmpxchg"
      ~position:"desired"
  ;;

  let check_call_block_args (call_block : Block.t Call_block.t) =
    let formal_args = Vec.to_list call_block.block.Block.args in
    let actual_args = call_block.args in
    if Int.O.(List.length formal_args <> List.length actual_args)
    then
      type_error
        "block %s expects %d arguments but received %d"
        call_block.block.Block.id_hum
        (List.length formal_args)
        (List.length actual_args)
    else
      List.fold2_exn
        formal_args
        actual_args
        ~init:(Ok ())
        ~f:(fun acc formal actual ->
          let%bind () = acc in
          if Type.equal (Var.type_ formal) (Var.type_ actual)
          then Ok ()
          else
            type_error
              "block %s expects arg %s:%s but received %s:%s"
              call_block.block.Block.id_hum
              (Var.name formal)
              (Type.to_string (Var.type_ formal))
              (Var.name actual)
              (Type.to_string (Var.type_ actual)))
  ;;

  let check = function
    | Noop | Arm64 _ | Arm64_terminal _ | X86 _ | X86_terminal _ | Unreachable
      -> Ok ()
    | Add arith -> check_arith ~op:"add" arith
    | Sub arith -> check_arith ~op:"sub" arith
    | Mul arith -> check_arith ~op:"mul" arith
    | Div arith -> check_arith ~op:"div" arith
    | Mod arith -> check_arith ~op:"mod" arith
    | Lt arith -> check_arith ~op:"lt" arith
    | And arith -> check_arith ~op:"and" arith
    | Or arith -> check_arith ~op:"or" arith
    | Fadd arith -> check_float_arith ~op:"fadd" arith
    | Fsub arith -> check_float_arith ~op:"fsub" arith
    | Fmul arith -> check_float_arith ~op:"fmul" arith
    | Fdiv arith -> check_float_arith ~op:"fdiv" arith
    | Alloca alloca -> check_alloca alloca
    | Move (dst, src) -> check_move (dst, src)
    | Cast (dst, src) -> check_cast (dst, src)
    | Load (dst, src) -> check_load (dst, src)
    | Store (dst, src) -> check_store (dst, src)
    | Load_field instr -> check_load_field instr
    | Store_field instr -> check_store_field instr
    | Memcpy instr -> check_memcpy instr
    | Atomic_load instr -> check_atomic_load instr
    | Atomic_store instr -> check_atomic_store instr
    | Atomic_rmw instr -> check_atomic_rmw instr
    | Atomic_cmpxchg instr -> check_atomic_cmpxchg instr
    | Return _ -> Ok ()
    | Call _ -> Ok ()
    | Branch (Branch.Cond { cond; if_true; if_false }) ->
      let%bind () = check_branch_cond cond in
      let%bind () = check_call_block_args if_true in
      check_call_block_args if_false
    | Branch (Branch.Uncond cb) -> check_call_block_args cb
  ;;
end

let check_types = Type_check.check

let lower_aggregates ~root =
  let add_var used var = Core.Hash_set.add used (Var.name var) in
  let blocks =
    let seen = Core.Hash_set.Poly.create () in
    let rec collect acc block =
      if Core.Hash_set.Poly.mem seen block
      then acc
      else (
        Core.Hash_set.Poly.add seen block;
        let acc = block :: acc in
        Vec.fold block.Block.children ~init:acc ~f:collect)
    in
    collect [] root |> List.rev
  in
  let used_names = String.Hash_set.create () in
  List.iter blocks ~f:(fun block ->
    Vec.iter block.Block.args ~f:(add_var used_names);
    let add_instr_vars instr =
      List.iter (vars instr) ~f:(add_var used_names)
    in
    Vec.iter block.Block.instructions ~f:add_instr_vars;
    add_instr_vars block.Block.terminal);
  let counter = ref 0 in
  let fresh_temp ~type_ =
    let rec next_name () =
      let name = sprintf "__tmp%d" !counter in
      incr counter;
      if Core.Hash_set.mem used_names name then next_name () else name
    in
    let name = next_name () in
    Core.Hash_set.add used_names name;
    Var.create ~name ~type_
  in
  List.fold blocks ~init:(Ok ()) ~f:(fun acc block ->
    let open Result.Let_syntax in
    let%bind () = acc in
    let new_instrs = Vec.create () in
    let%bind () =
      Vec.fold block.Block.instructions ~init:(Ok ()) ~f:(fun acc instr ->
        let%bind () = acc in
        match Aggregate.lower_instruction ~fresh_temp instr with
        | Ok instrs ->
          List.iter instrs ~f:(Vec.push new_instrs);
          Ok ()
        | Error err ->
          Error (`Type_mismatch (Error.to_string_hum err)))
    in
    block.Block.instructions <- new_instrs;
    let%bind () =
      match Aggregate.lower_instruction ~fresh_temp block.Block.terminal with
      | Ok [ instr ] ->
        if is_terminal instr
        then (
          block.terminal <- instr;
          Ok ())
        else Error (`Type_mismatch "aggregate instruction cannot be terminal")
      | Ok _ -> Error (`Type_mismatch "aggregate instruction cannot be terminal")
      | Error err -> Error (`Type_mismatch (Error.to_string_hum err))
    in
    Ok ())
