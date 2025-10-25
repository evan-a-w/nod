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
    | Alloca _
    | Load _
    | Store _
    | Mod _
    | Sub _
    | Move _
    | Call _
    | Unreachable
    | Noop
    | Return _ ) as t -> t
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
    | Alloca _
    | Load _
    | Store _
    | Mod _
    | Sub _
    | Move _
    | Call _
    | Unreachable
    | Noop
    | Return _ ) as t -> t
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

module Type_check = struct
  open Result.Let_syntax

  let type_error fmt =
    Printf.ksprintf (fun msg -> Error (`Type_mismatch msg)) fmt
  ;;

  let literal_allowed type_ = Type.is_integer type_ || Type.equal type_ Type.Ptr

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
      if Type.equal (Var.type_ var) expected_type
      then Ok ()
      else
        type_error
          "%s expects %s of type %s but got %s:%s"
          op
          position
          (Type.to_string expected_type)
          (Var.name var)
          (Type.to_string (Var.type_ var))
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
  ;;

  let ensure_pointer_operand operand ~op ~position =
    match operand with
    | Lit_or_var.Lit _ -> Ok ()
    | Var var ->
      if Type.equal (Var.type_ var) Type.Ptr
      then Ok ()
      else
        type_error
          "%s expects %s pointer but got %s:%s"
          op
          position
          (Var.name var)
          (Type.to_string (Var.type_ var))
  ;;

  let ensure_pointer_mem mem ~op =
    match mem with
    | Mem.Stack_slot _ -> Ok ()
    | Mem.Lit_or_var operand ->
      ensure_pointer_operand operand ~op ~position:"memory operand"
  ;;

  let check_arith ~op { dest; src1; src2 } =
    let%bind () = ensure_integer_var dest ~op ~position:"destination" in
    let dest_type = Var.type_ dest in
    let%bind () =
      ensure_operand_matches src1 ~expected_type:dest_type ~op ~position:"lhs"
    in
    ensure_operand_matches src2 ~expected_type:dest_type ~op ~position:"rhs"
  ;;

  let check_alloca { dest; size } =
    let%bind () =
      if Type.equal (Var.type_ dest) Type.Ptr
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
      if Type.equal (Var.type_ src_var) (Var.type_ dest)
      then Ok ()
      else
        type_error
          "move destination %s:%s does not match source %s:%s"
          (Var.name dest)
          (Type.to_string (Var.type_ dest))
          (Var.name src_var)
          (Type.to_string (Var.type_ src_var))
  ;;

  let check_branch_cond cond =
    ensure_integer_operand cond ~op:"branch" ~position:"condition"
  ;;

  let check_load (dest, mem) =
    let _ = dest in
    ensure_pointer_mem mem ~op:"load"
  ;;

  let check_store (value, mem) =
    let%bind () = ensure_pointer_mem mem ~op:"store" in
    match value with
    | Lit_or_var.Lit _ -> Ok ()
    | Var _ -> Ok ()
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
    | Noop | X86 _ | X86_terminal _ | Unreachable -> Ok ()
    | Add arith -> check_arith ~op:"add" arith
    | Sub arith -> check_arith ~op:"sub" arith
    | Mul arith -> check_arith ~op:"mul" arith
    | Div arith -> check_arith ~op:"div" arith
    | Mod arith -> check_arith ~op:"mod" arith
    | And arith -> check_arith ~op:"and" arith
    | Or arith -> check_arith ~op:"or" arith
    | Alloca alloca -> check_alloca alloca
    | Move (dst, src) -> check_move (dst, src)
    | Load (dst, src) -> check_load (dst, src)
    | Store (dst, src) -> check_store (dst, src)
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
