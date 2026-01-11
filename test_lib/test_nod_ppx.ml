open! Core
open! Import

let block_of_instrs instrs =
  instrs
  |> Dsl.Instr.process
  |> (function
   | Ok raw -> raw
   | Error err -> Nod_error.to_string err |> failwith)
  |> Cfg.process
  |> fun (~root, ~blocks:_, ~in_order) ->
  Vec.iteri in_order ~f:(fun i block ->
    Block.set_dfs_id block (Some i));
  root
;;

let%expect_test "nod block from let%named" =
  let instrs =
    [%nod
      let%named tmp = mov (lit 1L) in
      return tmp]
  in
  let root = block_of_instrs instrs in
  print_s (Block.to_sexp_verbose root);
  [%expect
    {|
    ((%entry (args ())
      (instrs
       ((Move ((name tmp) (type_ I64)) (Lit 1))
        (Return (Var ((name tmp) (type_ I64))))))))
    |}]
;;

let%expect_test "nod seq embeds instruction list" =
  let instrs =
    [%nod
      seq [ Instr.ir Ir0.Noop; Instr.ir Ir0.Noop ];
      return (lit 0L)]
  in
  let root = block_of_instrs instrs in
  let instrs = Vec.to_list root.instructions in
  let noop_count =
    List.count instrs ~f:(function
      | Ir0.Noop -> true
      | _ -> false)
  in
  print_s [%sexp (Vec.length root.instructions : int)];
  print_s [%sexp (noop_count : int)];
  [%expect {|
    2
    2
  |}]
;;

let%expect_test "nod fun builds args and return type" =
  let fn =
    [%nod fun (a : int64) (b : int64) ->
      let%named sum = add a b in
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
       ((Add
         ((dest ((name sum) (type_ I64))) (src1 (Var ((name a) (type_ I64))))
          (src2 (Var ((name b) (type_ I64))))))
        (Return (Var ((name sum) (type_ I64))))))))
    |}]
;;

let%expect_test "nod calculator with labels" =
  let instrs =
    [%nod
      label entry;
      let%named x = mov (lit 10L) in
      let%named y = mov (lit 4L) in
      let%named sum = add x y in
      let%named diff = sub x y in
      let%named prod = mul sum diff in
      seq [ Instr.ir (Ir0.jump_to "final") ];
      label skipped;
      seq [ return (lit 0L) ];
      label final;
      let%named result = add prod (lit 3L) in
      return result]
  in
  let root = block_of_instrs instrs in
  print_s (Block.to_sexp_verbose root);
  [%expect
    {|
    ((entry (args ())
      (instrs
       ((Move ((name x) (type_ I64)) (Lit 10))
        (Move ((name y) (type_ I64)) (Lit 4))
        (Add
         ((dest ((name sum) (type_ I64))) (src1 (Var ((name x) (type_ I64))))
          (src2 (Var ((name y) (type_ I64))))))
        (Sub
         ((dest ((name diff) (type_ I64))) (src1 (Var ((name x) (type_ I64))))
          (src2 (Var ((name y) (type_ I64))))))
        (Mul
         ((dest ((name prod) (type_ I64))) (src1 (Var ((name sum) (type_ I64))))
          (src2 (Var ((name diff) (type_ I64))))))
        (Branch (Uncond ((block ((id_hum final) (args ()))) (args ())))))))
     (final (args ())
      (instrs
       ((Add
         ((dest ((name result) (type_ I64)))
          (src1 (Var ((name prod) (type_ I64)))) (src2 (Lit 3))))
        (Return (Var ((name result) (type_ I64))))))))
    |}]
;;
