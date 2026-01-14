open! Core
open! Import

let helper name arg = Dsl.mov name arg

let block_of_instrs instrs =
  instrs
  |> Dsl.Instr.process
  |> (function
        | Ok raw -> raw
        | Error err -> Nod_error.to_string err |> failwith)
  |> Cfg.process
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
    [%nod
      fun (a : int64) (b : int64) ->
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

let%expect_test "nod calls externals with mixed types" =
  let ext_add : (Dsl.int64 -> Dsl.int64 -> Dsl.int64, Dsl.int64) Dsl.Fn.t =
    Dsl.Fn.external_ ~name:"ext_add" ~args:[ Type.I64; Type.I64 ] ~ret:Type.I64
  in
  let ext_peek : (Dsl.ptr -> Dsl.int64, Dsl.int64) Dsl.Fn.t =
    Dsl.Fn.external_ ~name:"ext_peek" ~args:[ Type.Ptr ] ~ret:Type.I64
  in
  let instrs =
    [%nod
      let%named slot = alloca (lit 8L) in
      let%named sum = ext_add (lit 5L) (lit 7L) in
      let%named peeked = ext_peek slot in
      let%named total = add sum peeked in
      return total]
  in
  let root = block_of_instrs instrs in
  print_s (Block.to_sexp_verbose root);
  [%expect
    {|
    ((%entry (args ())
      (instrs
       ((Alloca ((dest ((name slot) (type_ Ptr))) (size (Lit 8))))
        (Call (fn ext_add) (results (((name sum) (type_ I64))))
         (args ((Lit 5) (Lit 7))))
        (Call (fn ext_peek) (results (((name peeked) (type_ I64))))
         (args ((Var ((name slot) (type_ Ptr))))))
        (Add
         ((dest ((name total) (type_ I64))) (src1 (Var ((name sum) (type_ I64))))
          (src2 (Var ((name peeked) (type_ I64))))))
        (Return (Var ((name total) (type_ I64))))))))
    |}]
;;

let%expect_test "nod no_nod preserves ocaml call" =
  let instrs =
    [%nod
      let%named tmp = [%no_nod helper (lit 9L)] in
      return tmp]
  in
  let root = block_of_instrs instrs in
  print_s (Block.to_sexp_verbose root);
  [%expect
    {|
    ((%entry (args ())
      (instrs
       ((Move ((name tmp) (type_ I64)) (Lit 9))
        (Return (Var ((name tmp) (type_ I64))))))))
    |}]
;;

let%expect_test "nod bang preserves ocaml call" =
  let instrs =
    [%nod
      let%named tmp = !(helper (lit 11L)) in
      return tmp]
  in
  let root = block_of_instrs instrs in
  print_s (Block.to_sexp_verbose root);
  [%expect
    {|
    ((%entry (args ())
      (instrs
       ((Move ((name tmp) (type_ I64)) (Lit 11))
        (Return (Var ((name tmp) (type_ I64))))))))
    |}]
;;

module Embed_generated = struct
  [%%embed
    let arities = List.init 3 ~f:(fun i -> i + 2) in
    let lines =
      List.map arities ~f:(fun n -> sprintf "let tuple_%d = %d\n" n (n * n))
    in
    String.concat lines ~sep:""]
end

let%expect_test "embed generates structure items" =
  print_s [%sexp (Embed_generated.tuple_2 : int)];
  print_s [%sexp (Embed_generated.tuple_4 : int)];
  [%expect {|
    4
    16
  |}]
;;
