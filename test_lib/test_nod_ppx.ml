open! Core
open! Import

let helper name arg = Dsl.mov name arg

let block_of_instrs instrs =
  instrs
  |> Dsl.Instr.process
  |> (function
        | Ok raw -> raw
        | Error err -> Nod_error.to_string err |> failwith)
  |> Cfg.process ~fn_state:(Fn_state.create ())
  |> fun (~root, ~blocks:_, ~in_order) ->
  Vec.iteri in_order ~f:(fun i block -> Block.set_dfs_id block (Some i));
  root
;;

let%expect_test "nod type expr" =
  let a = [%nod_type_expr: int64] in
  print_s [%sexp (Dsl.Type_repr.type_ a : Type.t)];
  [%expect {| I64 |}];
  let a = [%nod_type_expr: a * float64 * ptr] in
  print_s [%sexp (Dsl.Type_repr.type_ a : Type.t)];
  [%expect {| (Tuple (I64 F64 Ptr)) |}]
;;

let%expect_test "nod block from let" =
  let instrs =
    [%nod
      let tmp = mov (lit 1L) in
      return tmp]
  in
  let root = block_of_instrs instrs in
  print_s (Block.to_sexp_verbose root);
  [%expect
    {|
    ((%entry (args ())
      (instrs
       (((id (Instr_id 1)) (ir (Move (Value_id 0) (Lit 1))))
        ((id (Instr_id 2)) (ir (Return (Var (Value_id 0)))))))))
    |}]
;;

let%expect_test "nod seq embeds instruction list" =
  let instrs =
    [%nod
      seq [ Instr.ir Ir.noop; Instr.ir Ir.noop ];
      return (lit 0L)]
  in
  let root = block_of_instrs instrs in
  let instrs = Instr_state.to_ir_list (Block.instructions root) in
  let noop_count =
    List.count instrs ~f:(function
      | Noop -> true
      | _ -> false)
  in
  print_s
    [%sexp (List.length (Instr_state.to_list (Block.instructions root)) : int)];
  print_s [%sexp (noop_count : int)];
  [%expect {|
    2
    2
  |}]
;;

let%expect_test "nod fun builds args and return type" =
  let fn =
    [%nod
      fun (a : int64) (b : int64) ->
        let sum = add a b in
        return sum]
  in
  let unnamed = Dsl.Fn.unnamed fn in
  print_s [%sexp (Dsl.Fn.Unnamed.args unnamed : Var.t list)];
  print_s [%sexp (Dsl.Fn.Unnamed.ret unnamed : Type.t)];
  let root = block_of_instrs (Dsl.Fn.Unnamed.instrs unnamed) in
  print_s (Block.to_sexp_verbose root);
  [%expect
    {|
    (((name a) (type_ I64)) ((name b) (type_ I64)))
    I64
    ((%entry (args ())
      (instrs
       (((id (Instr_id 1))
         (ir
          (Add
           ((dest (Value_id 2)) (src1 (Var (Value_id 1)))
            (src2 (Var (Value_id 0)))))))
        ((id (Instr_id 2)) (ir (Return (Var (Value_id 2)))))))))
    |}]
;;

let%expect_test "nod calculator with labels" =
  let instrs =
    [%nod
      label entry;
      let x = mov (lit 10L) in
      let y = mov (lit 4L) in
      let sum = add x y in
      let diff = sub x y in
      let prod = mul sum diff in
      seq [ Instr.ir (Ir.jump_to "final") ];
      label skipped;
      seq [ return (lit 0L) ];
      label final;
      let result = add prod (lit 3L) in
      return result]
  in
  let root = block_of_instrs instrs in
  print_s (Block.to_sexp_verbose root);
  [%expect
    {|
    ((entry (args ())
      (instrs
       (((id (Instr_id 3)) (ir (Move (Value_id 0) (Lit 10))))
        ((id (Instr_id 4)) (ir (Move (Value_id 1) (Lit 4))))
        ((id (Instr_id 5))
         (ir
          (Add
           ((dest (Value_id 2)) (src1 (Var (Value_id 0)))
            (src2 (Var (Value_id 1)))))))
        ((id (Instr_id 6))
         (ir
          (Sub
           ((dest (Value_id 3)) (src1 (Var (Value_id 0)))
            (src2 (Var (Value_id 1)))))))
        ((id (Instr_id 7))
         (ir
          (Mul
           ((dest (Value_id 4)) (src1 (Var (Value_id 2)))
            (src2 (Var (Value_id 3)))))))
        ((id (Instr_id 8))
         (ir (Branch (Uncond ((block ((id_hum final) (args ()))) (args ())))))))))
     (final (args ())
      (instrs
       (((id (Instr_id 1))
         (ir
          (Add ((dest (Value_id 5)) (src1 (Var (Value_id 4))) (src2 (Lit 3))))))
        ((id (Instr_id 9)) (ir (Return (Var (Value_id 5)))))))))
    |}]
;;

let%expect_test "nod calls externals with mixed types" =
  let ext_add : (Dsl.int64 -> Dsl.int64 -> Dsl.int64, Dsl.int64) Dsl.Fn.t =
    Dsl.Fn.external_ ~name:"ext_add" ~args:[ Type.I64; Type.I64 ] ~ret:Type.I64
  in
  let ext_peek : (Dsl.ptr -> Dsl.int64, Dsl.int64) Dsl.Fn.t =
    Dsl.Fn.external_ ~name:"ext_peek" ~args:[ Type.Ptr ] ~ret:Type.I64
  in
  let instrs =
    [%nod
      let slot = alloca (lit 8L) in
      let sum = ext_add (lit 5L) (lit 7L) in
      let peeked = ext_peek slot in
      let total = add sum peeked in
      return total]
  in
  let root = block_of_instrs instrs in
  print_s (Block.to_sexp_verbose root);
  [%expect
    {|
    ((%entry (args ())
      (instrs
       (((id (Instr_id 1)) (ir (Alloca ((dest (Value_id 0)) (size (Lit 8))))))
        ((id (Instr_id 2))
         (ir
          (Call (fn ext_add) (results ((Value_id 1))) (args ((Lit 5) (Lit 7))))))
        ((id (Instr_id 3))
         (ir
          (Call (fn ext_peek) (results ((Value_id 2)))
           (args ((Var (Value_id 0)))))))
        ((id (Instr_id 4))
         (ir
          (Add
           ((dest (Value_id 3)) (src1 (Var (Value_id 1)))
            (src2 (Var (Value_id 2)))))))
        ((id (Instr_id 5)) (ir (Return (Var (Value_id 3)))))))))
    |}]
;;

let%expect_test "nod no_nod preserves ocaml call" =
  let instrs =
    [%nod
      let tmp = [%no_nod helper (lit 9L)] in
      return tmp]
  in
  let root = block_of_instrs instrs in
  print_s (Block.to_sexp_verbose root);
  [%expect
    {|
    ((%entry (args ())
      (instrs
       (((id (Instr_id 1)) (ir (Move (Value_id 0) (Lit 9))))
        ((id (Instr_id 2)) (ir (Return (Var (Value_id 0)))))))))
    |}]
;;

let%expect_test "nod bang preserves ocaml call" =
  let instrs =
    [%nod
      let tmp = !(helper (lit 11L)) in
      return tmp]
  in
  let root = block_of_instrs instrs in
  print_s (Block.to_sexp_verbose root);
  [%expect
    {|
    ((%entry (args ())
      (instrs
       (((id (Instr_id 1)) (ir (Move (Value_id 0) (Lit 11))))
        ((id (Instr_id 2)) (ir (Return (Var (Value_id 0)))))))))
    |}]
;;
