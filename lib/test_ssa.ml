open! Core

let test s =
  Test_cfg.test s;
  print_endline "=================================";
  Parser.parse_string s
  |> Result.map ~f:Cfg.process
  |> Result.map ~f:Eir.Ssa.create
  |> function
  | Error e -> Test_parser.print_error e
  | Ok ssa ->
    let go ssa =
      Vec.iter ssa.Eir.Ssa.in_order ~f:(fun block ->
        let instrs = Vec.to_list block.instructions @ [ block.terminal ] in
        print_s
          [%message
            block.id_hum
              ~args:(block.args : string Vec.t)
              (instrs : Eir.Instr.t list)])
    in
    go ssa;
    print_endline "******************************";
    Eir.optimize ssa;
    go ssa
;;

let%expect_test "phi pruning" =
  test Examples.Textual.e;
  [%expect
    {|
    (start
     (instrs
      ((Move x (Lit 7)) (Move y (Lit 2))
       (Mul ((dest x) (src1 (Var x)) (src2 (Lit 3))))
       (Div ((dest x) (src1 (Var x)) (src2 (Var y))))
       (Sub ((dest cond) (src1 (Var y)) (src2 (Lit 2))))
       (Branch
        (Cond (cond (Var cond))
         (if_true ((block ((id_hum ifTrue) (args ()))) (args ())))
         (if_false ((block ((id_hum ifFalse) (args ()))) (args ()))))))))
    (ifTrue
     (instrs
      ((Move x (Lit 999))
       (Branch
        (Cond (cond (Lit 1))
         (if_true ((block ((id_hum end) (args ()))) (args ())))
         (if_false ((block ((id_hum end) (args ()))) (args ()))))))))
    (ifFalse
     (instrs
      ((Add ((dest x) (src1 (Var x)) (src2 (Lit 10))))
       (Branch
        (Cond (cond (Lit 1))
         (if_true ((block ((id_hum end) (args ()))) (args ())))
         (if_false ((block ((id_hum end) (args ()))) (args ()))))))))
    (end (instrs (Unreachable)))
    =================================
    (start (args ())
     (instrs
      ((Move x (Lit 7)) (Move y (Lit 2))
       (Mul ((dest x%0) (src1 (Var x)) (src2 (Lit 3))))
       (Div ((dest x%1) (src1 (Var x%0)) (src2 (Var y))))
       (Sub ((dest cond) (src1 (Var y)) (src2 (Lit 2))))
       (Branch
        (Cond (cond (Var cond))
         (if_true ((block ((id_hum ifTrue) (args ()))) (args ())))
         (if_false ((block ((id_hum ifFalse) (args ()))) (args ()))))))))
    (ifTrue (args ())
     (instrs
      ((Move x%4 (Lit 999))
       (Branch
        (Cond (cond (Lit 1))
         (if_true ((block ((id_hum end) (args (x%2)))) (args (x%4))))
         (if_false ((block ((id_hum end) (args (x%2)))) (args (x%4)))))))))
    (ifFalse (args ())
     (instrs
      ((Add ((dest x%3) (src1 (Var x%1)) (src2 (Lit 10))))
       (Branch
        (Cond (cond (Lit 1))
         (if_true ((block ((id_hum end) (args (x%2)))) (args (x%3))))
         (if_false ((block ((id_hum end) (args (x%2)))) (args (x%3)))))))))
    (end (args (x%2)) (instrs (Unreachable)))
    ******************************
    (start (args ())
     (instrs
      ((Branch (Uncond ((block ((id_hum ifFalse) (args ()))) (args ())))))))
    (ifTrue (args ())
     (instrs
      ((Branch
        (Cond (cond (Lit 1))
         (if_true ((block ((id_hum end) (args ()))) (args ())))
         (if_false ((block ((id_hum end) (args ()))) (args ()))))))))
    (ifFalse (args ())
     (instrs
      ((Branch
        (Cond (cond (Lit 1))
         (if_true ((block ((id_hum end) (args ()))) (args ())))
         (if_false ((block ((id_hum end) (args ()))) (args ()))))))))
    (end (args ()) (instrs (Unreachable))) |}]
;;

let%expect_test "trivial unused vars" =
  test Examples.Textual.c;
  print_endline "";
  print_endline "";
  print_endline "";
  test Examples.Textual.c2;
  [%expect
    {|
(entry
 (instrs
  ((Move a (Lit 100)) (Move b (Lit 6))
   (Mod ((dest res) (src1 (Var a)) (src2 (Var b))))
   (Add ((dest res) (src1 (Var res)) (src2 (Lit 1)))) Unreachable)))
=================================
(entry (args ())
 (instrs
  ((Move a (Lit 100)) (Move b (Lit 6))
   (Mod ((dest res) (src1 (Var a)) (src2 (Var b))))
   (Add ((dest res%0) (src1 (Var res)) (src2 (Lit 1)))) Unreachable)))
******************************
(entry (args ()) (instrs (Unreachable)))



(entry
 (instrs
  ((Move a (Lit 100)) (Move b (Lit 6))
   (Mod ((dest res) (src1 (Var a)) (src2 (Var b))))
   (Add ((dest res) (src1 (Var res)) (src2 (Lit 1)))) (Return (Var res)))))
=================================
(entry (args ())
 (instrs
  ((Move a (Lit 100)) (Move b (Lit 6))
   (Mod ((dest res) (src1 (Var a)) (src2 (Var b))))
   (Add ((dest res%0) (src1 (Var res)) (src2 (Lit 1)))) (Return (Var res%0)))))
******************************
(entry (args ()) (instrs ((Return (Lit 5))))) |}]
;;

let%expect_test "all examples" =
  List.iter Examples.Textual.all ~f:(fun s ->
    test s;
    print_endline "++++++++++++++++++++++++++";
    print_endline "++++++++++++++++++++++++++");
  [%expect
    {|
    (a
     (instrs
      ((Move x (Lit 10)) (Move y (Lit 20))
       (Sub ((dest z) (src1 (Var y)) (src2 (Var x))))
       (Branch
        (Cond (cond (Lit 1)) (if_true ((block ((id_hum b) (args ()))) (args ())))
         (if_false ((block ((id_hum c) (args ()))) (args ()))))))))
    (b
     (instrs
      ((Add ((dest z) (src1 (Var z)) (src2 (Lit 5))))
       (Branch
        (Cond (cond (Lit 1))
         (if_true ((block ((id_hum end) (args ()))) (args ())))
         (if_false ((block ((id_hum end) (args ()))) (args ()))))))))
    (c
     (instrs
      ((Move z (Lit 0))
       (Branch
        (Cond (cond (Lit 1))
         (if_true ((block ((id_hum end) (args ()))) (args ())))
         (if_false ((block ((id_hum end) (args ()))) (args ()))))))))
    (end (instrs (Unreachable)))
    =================================
    (a (args ())
     (instrs
      ((Move x (Lit 10)) (Move y (Lit 20))
       (Sub ((dest z) (src1 (Var y)) (src2 (Var x))))
       (Branch
        (Cond (cond (Lit 1)) (if_true ((block ((id_hum b) (args ()))) (args ())))
         (if_false ((block ((id_hum c) (args ()))) (args ()))))))))
    (b (args ())
     (instrs
      ((Add ((dest z%2) (src1 (Var z)) (src2 (Lit 5))))
       (Branch
        (Cond (cond (Lit 1))
         (if_true ((block ((id_hum end) (args (z%0)))) (args (z%2))))
         (if_false ((block ((id_hum end) (args (z%0)))) (args (z%2)))))))))
    (c (args ())
     (instrs
      ((Move z%1 (Lit 0))
       (Branch
        (Cond (cond (Lit 1))
         (if_true ((block ((id_hum end) (args (z%0)))) (args (z%1))))
         (if_false ((block ((id_hum end) (args (z%0)))) (args (z%1)))))))))
    (end (args (z%0)) (instrs (Unreachable)))
    ******************************
    (a (args ())
     (instrs ((Branch (Uncond ((block ((id_hum b) (args ()))) (args ())))))))
    (b (args ())
     (instrs
      ((Branch
        (Cond (cond (Lit 1))
         (if_true ((block ((id_hum end) (args ()))) (args ())))
         (if_false ((block ((id_hum end) (args ()))) (args ()))))))))
    (c (args ())
     (instrs
      ((Branch
        (Cond (cond (Lit 1))
         (if_true ((block ((id_hum end) (args ()))) (args ())))
         (if_false ((block ((id_hum end) (args ()))) (args ()))))))))
    (end (args ()) (instrs (Unreachable)))
    ++++++++++++++++++++++++++
    ++++++++++++++++++++++++++
    (%root
     (instrs
      ((Move a (Lit 4)) (Move b (Lit 5))
       (Mul ((dest c) (src1 (Var a)) (src2 (Var b))))
       (Branch
        (Cond (cond (Lit 1))
         (if_true ((block ((id_hum divide) (args ()))) (args ())))
         (if_false ((block ((id_hum end) (args ()))) (args ()))))))))
    (divide
     (instrs
      ((Div ((dest c) (src1 (Var c)) (src2 (Lit 2))))
       (Branch
        (Cond (cond (Lit 1))
         (if_true ((block ((id_hum end) (args ()))) (args ())))
         (if_false ((block ((id_hum end) (args ()))) (args ()))))))))
    (end (instrs (Unreachable)))
    =================================
    (%root (args ())
     (instrs
      ((Move a (Lit 4)) (Move b (Lit 5))
       (Mul ((dest c) (src1 (Var a)) (src2 (Var b))))
       (Branch
        (Cond (cond (Lit 1))
         (if_true ((block ((id_hum divide) (args ()))) (args ())))
         (if_false ((block ((id_hum end) (args (c%0)))) (args (c)))))))))
    (divide (args ())
     (instrs
      ((Div ((dest c%1) (src1 (Var c)) (src2 (Lit 2))))
       (Branch
        (Cond (cond (Lit 1))
         (if_true ((block ((id_hum end) (args (c%0)))) (args (c%1))))
         (if_false ((block ((id_hum end) (args (c%0)))) (args (c%1)))))))))
    (end (args (c%0)) (instrs (Unreachable)))
    ******************************
    (%root (args ())
     (instrs ((Branch (Uncond ((block ((id_hum divide) (args ()))) (args ())))))))
    (divide (args ())
     (instrs
      ((Branch
        (Cond (cond (Lit 1))
         (if_true ((block ((id_hum end) (args ()))) (args ())))
         (if_false ((block ((id_hum end) (args ()))) (args ()))))))))
    (end (args ()) (instrs (Unreachable)))
    ++++++++++++++++++++++++++
    ++++++++++++++++++++++++++
    (entry
     (instrs
      ((Move a (Lit 100)) (Move b (Lit 6))
       (Mod ((dest res) (src1 (Var a)) (src2 (Var b))))
       (Add ((dest res) (src1 (Var res)) (src2 (Lit 1)))) Unreachable)))
    =================================
    (entry (args ())
     (instrs
      ((Move a (Lit 100)) (Move b (Lit 6))
       (Mod ((dest res) (src1 (Var a)) (src2 (Var b))))
       (Add ((dest res%0) (src1 (Var res)) (src2 (Lit 1)))) Unreachable)))
    ******************************
    (entry (args ()) (instrs (Unreachable)))
    ++++++++++++++++++++++++++
    ++++++++++++++++++++++++++
    (%root
     (instrs
      ((Move i (Lit 0)) (Move sum (Lit 0))
       (Branch
        (Cond (cond (Lit 1))
         (if_true ((block ((id_hum loop) (args ()))) (args ())))
         (if_false ((block ((id_hum loop) (args ()))) (args ()))))))))
    (loop
     (instrs
      ((Add ((dest sum) (src1 (Var sum)) (src2 (Var i))))
       (Add ((dest i) (src1 (Var i)) (src2 (Lit 1))))
       (Sub ((dest cond) (src1 (Lit 10)) (src2 (Var i))))
       (Branch
        (Cond (cond (Var cond))
         (if_true ((block ((id_hum loop) (args ()))) (args ())))
         (if_false ((block ((id_hum end) (args ()))) (args ()))))))))
    (end (instrs (Unreachable)))
    =================================
    (%root (args ())
     (instrs
      ((Move i (Lit 0)) (Move sum (Lit 0))
       (Branch
        (Cond (cond (Lit 1))
         (if_true
          ((block ((id_hum loop) (args (cond sum%0 i%0)))) (args (cond sum i))))
         (if_false
          ((block ((id_hum loop) (args (cond sum%0 i%0)))) (args (cond sum i)))))))))
    (loop (args (cond sum%0 i%0))
     (instrs
      ((Add ((dest sum%1) (src1 (Var sum%0)) (src2 (Var i%0))))
       (Add ((dest i%1) (src1 (Var i%0)) (src2 (Lit 1))))
       (Sub ((dest cond%0) (src1 (Lit 10)) (src2 (Var i%1))))
       (Branch
        (Cond (cond (Var cond%0))
         (if_true
          ((block ((id_hum loop) (args (cond sum%0 i%0))))
           (args (cond%0 sum%1 i%1))))
         (if_false ((block ((id_hum end) (args ()))) (args ()))))))))
    (end (args ()) (instrs (Unreachable)))
    ******************************
    (%root (args ())
     (instrs
      ((Move i (Lit 0)) (Move sum (Lit 0))
       (Branch
        (Uncond
         ((block ((id_hum loop) (args (cond sum%0 i%0)))) (args (cond sum i))))))))
    (loop (args (cond sum%0 i%0))
     (instrs
      ((Add ((dest sum%1) (src1 (Var sum%0)) (src2 (Var i%0))))
       (Add ((dest i%1) (src1 (Lit 1)) (src2 (Var i%0))))
       (Sub ((dest cond%0) (src1 (Lit 10)) (src2 (Var i%1))))
       (Branch
        (Cond (cond (Var cond%0))
         (if_true
          ((block ((id_hum loop) (args (cond sum%0 i%0))))
           (args (cond%0 sum%1 i%1))))
         (if_false ((block ((id_hum end) (args ()))) (args ()))))))))
    (end (args ()) (instrs (Unreachable)))
    ++++++++++++++++++++++++++
    ++++++++++++++++++++++++++
    (start
     (instrs
      ((Move x (Lit 7)) (Move y (Lit 2))
       (Mul ((dest x) (src1 (Var x)) (src2 (Lit 3))))
       (Div ((dest x) (src1 (Var x)) (src2 (Var y))))
       (Sub ((dest cond) (src1 (Var y)) (src2 (Lit 2))))
       (Branch
        (Cond (cond (Var cond))
         (if_true ((block ((id_hum ifTrue) (args ()))) (args ())))
         (if_false ((block ((id_hum ifFalse) (args ()))) (args ()))))))))
    (ifTrue
     (instrs
      ((Move x (Lit 999))
       (Branch
        (Cond (cond (Lit 1))
         (if_true ((block ((id_hum end) (args ()))) (args ())))
         (if_false ((block ((id_hum end) (args ()))) (args ()))))))))
    (ifFalse
     (instrs
      ((Add ((dest x) (src1 (Var x)) (src2 (Lit 10))))
       (Branch
        (Cond (cond (Lit 1))
         (if_true ((block ((id_hum end) (args ()))) (args ())))
         (if_false ((block ((id_hum end) (args ()))) (args ()))))))))
    (end (instrs (Unreachable)))
    =================================
    (start (args ())
     (instrs
      ((Move x (Lit 7)) (Move y (Lit 2))
       (Mul ((dest x%0) (src1 (Var x)) (src2 (Lit 3))))
       (Div ((dest x%1) (src1 (Var x%0)) (src2 (Var y))))
       (Sub ((dest cond) (src1 (Var y)) (src2 (Lit 2))))
       (Branch
        (Cond (cond (Var cond))
         (if_true ((block ((id_hum ifTrue) (args ()))) (args ())))
         (if_false ((block ((id_hum ifFalse) (args ()))) (args ()))))))))
    (ifTrue (args ())
     (instrs
      ((Move x%4 (Lit 999))
       (Branch
        (Cond (cond (Lit 1))
         (if_true ((block ((id_hum end) (args (x%2)))) (args (x%4))))
         (if_false ((block ((id_hum end) (args (x%2)))) (args (x%4)))))))))
    (ifFalse (args ())
     (instrs
      ((Add ((dest x%3) (src1 (Var x%1)) (src2 (Lit 10))))
       (Branch
        (Cond (cond (Lit 1))
         (if_true ((block ((id_hum end) (args (x%2)))) (args (x%3))))
         (if_false ((block ((id_hum end) (args (x%2)))) (args (x%3)))))))))
    (end (args (x%2)) (instrs (Unreachable)))
    ******************************
    (start (args ())
     (instrs
      ((Branch (Uncond ((block ((id_hum ifFalse) (args ()))) (args ())))))))
    (ifTrue (args ())
     (instrs
      ((Branch
        (Cond (cond (Lit 1))
         (if_true ((block ((id_hum end) (args ()))) (args ())))
         (if_false ((block ((id_hum end) (args ()))) (args ()))))))))
    (ifFalse (args ())
     (instrs
      ((Branch
        (Cond (cond (Lit 1))
         (if_true ((block ((id_hum end) (args ()))) (args ())))
         (if_false ((block ((id_hum end) (args ()))) (args ()))))))))
    (end (args ()) (instrs (Unreachable)))
    ++++++++++++++++++++++++++
    ++++++++++++++++++++++++++ |}]
;;
