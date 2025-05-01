open! Core
module Cfg = Cfg.Process (Ir)

let test ?don't_opt s =
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
    (match don't_opt with
     | Some () -> ()
     | None ->
       print_endline "******************************";
       Eir.optimize ssa;
       go ssa)
;;

let%expect_test "phi pruning" =
  test Examples.Textual.e;
  print_endline "";
  print_endline "";
  print_endline "";
  test Examples.Textual.e2;
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
     (instrs ((Branch (Uncond ((block ((id_hum end) (args ()))) (args ())))))))
    (ifFalse (args ())
     (instrs ((Branch (Uncond ((block ((id_hum end) (args ()))) (args ())))))))
    (end (args ()) (instrs (Unreachable)))



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
    (end (instrs ((Return (Var x)))))
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
    (end (args (x%2)) (instrs ((Return (Var x%2)))))
    ******************************
    (start (args ())
     (instrs
      ((Branch (Uncond ((block ((id_hum ifFalse) (args ()))) (args ())))))))
    (ifTrue (args ())
     (instrs
      ((Move x%4 (Lit 999))
       (Branch (Uncond ((block ((id_hum end) (args (x%2)))) (args (x%4))))))))
    (ifFalse (args ())
     (instrs
      ((Move x%3 (Lit 20))
       (Branch (Uncond ((block ((id_hum end) (args (x%2)))) (args (x%3))))))))
    (end (args (x%2)) (instrs ((Return (Var x%2))))) |}]
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
     (instrs ((Branch (Uncond ((block ((id_hum end) (args ()))) (args ())))))))
    (c (args ())
     (instrs ((Branch (Uncond ((block ((id_hum end) (args ()))) (args ())))))))
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
     (instrs ((Branch (Uncond ((block ((id_hum end) (args ()))) (args ())))))))
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
          ((block ((id_hum loop) (args (cond%0 sum%0 i%0)))) (args (cond sum i))))
         (if_false
          ((block ((id_hum loop) (args (cond%0 sum%0 i%0)))) (args (cond sum i)))))))))
    (loop (args (cond%0 sum%0 i%0))
     (instrs
      ((Add ((dest sum%1) (src1 (Var sum%0)) (src2 (Var i%0))))
       (Add ((dest i%1) (src1 (Var i%0)) (src2 (Lit 1))))
       (Sub ((dest cond%0) (src1 (Lit 10)) (src2 (Var i%1))))
       (Branch
        (Cond (cond (Var cond%0))
         (if_true
          ((block ((id_hum loop) (args (cond%0 sum%0 i%0))))
           (args (cond%0 sum%1 i%1))))
         (if_false ((block ((id_hum end) (args ()))) (args ()))))))))
    (end (args ()) (instrs (Unreachable)))
    ******************************
    (%root (args ())
     (instrs
      ((Move i (Lit 0))
       (Branch
        (Uncond ((block ((id_hum loop) (args (cond%0 i%0)))) (args (cond))))))))
    (loop (args (cond%0 i%0))
     (instrs
      ((Add ((dest i%1) (src1 (Lit 1)) (src2 (Var i%0))))
       (Sub ((dest cond%0) (src1 (Lit 10)) (src2 (Var i%1))))
       (Branch
        (Cond (cond (Var cond%0))
         (if_true
          ((block ((id_hum loop) (args (cond%0 i%0)))) (args (cond%0 i%1))))
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
     (instrs ((Branch (Uncond ((block ((id_hum end) (args ()))) (args ())))))))
    (ifFalse (args ())
     (instrs ((Branch (Uncond ((block ((id_hum end) (args ()))) (args ())))))))
    (end (args ()) (instrs (Unreachable)))
    ++++++++++++++++++++++++++
    ++++++++++++++++++++++++++
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
    (entry (args ()) (instrs ((Return (Lit 5)))))
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
    (end (instrs ((Return (Var x)))))
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
    (end (args (x%2)) (instrs ((Return (Var x%2)))))
    ******************************
    (start (args ())
     (instrs
      ((Branch (Uncond ((block ((id_hum ifFalse) (args ()))) (args ())))))))
    (ifTrue (args ())
     (instrs
      ((Move x%4 (Lit 999))
       (Branch (Uncond ((block ((id_hum end) (args (x%2)))) (args (x%4))))))))
    (ifFalse (args ())
     (instrs
      ((Move x%3 (Lit 20))
       (Branch (Uncond ((block ((id_hum end) (args (x%2)))) (args (x%3))))))))
    (end (args (x%2)) (instrs ((Return (Var x%2)))))
    ++++++++++++++++++++++++++
    ++++++++++++++++++++++++++ |}]
;;

let%expect_test "longer example" = test Examples.Textual.f;
  [%expect {|
    (start
     (instrs
      ((Move n (Lit 7)) (Move i (Lit 0)) (Move total (Lit 0))
       (Branch
        (Cond (cond (Lit 1))
         (if_true ((block ((id_hum outerCheck) (args ()))) (args ())))
         (if_false ((block ((id_hum exit) (args ()))) (args ()))))))))
    (outerCheck
     (instrs
      ((Sub ((dest condOuter) (src1 (Var i)) (src2 (Var n))))
       (Branch
        (Cond (cond (Var condOuter))
         (if_true ((block ((id_hum outerBody) (args ()))) (args ())))
         (if_false ((block ((id_hum exit) (args ()))) (args ()))))))))
    (outerBody
     (instrs
      ((Move j (Lit 0)) (Move partial (Lit 0))
       (Branch
        (Cond (cond (Lit 1))
         (if_true ((block ((id_hum innerCheck) (args ()))) (args ())))
         (if_false ((block ((id_hum outerInc) (args ()))) (args ()))))))))
    (innerCheck
     (instrs
      ((Sub ((dest condInner) (src1 (Var j)) (src2 (Lit 3))))
       (Branch
        (Cond (cond (Var condInner))
         (if_true ((block ((id_hum innerBody) (args ()))) (args ())))
         (if_false ((block ((id_hum innerExit) (args ()))) (args ()))))))))
    (innerBody
     (instrs
      ((And ((dest isEven) (src1 (Var j)) (src2 (Lit 1))))
       (Sub ((dest condSkip) (src1 (Var isEven)) (src2 (Lit 0))))
       (Branch
        (Cond (cond (Var condSkip))
         (if_true ((block ((id_hum doWork) (args ()))) (args ())))
         (if_false ((block ((id_hum skipEven) (args ()))) (args ()))))))))
    (skipEven
     (instrs
      ((Add ((dest j) (src1 (Var j)) (src2 (Lit 1))))
       (Branch
        (Cond (cond (Lit 1))
         (if_true ((block ((id_hum innerCheck) (args ()))) (args ())))
         (if_false ((block ((id_hum innerExit) (args ()))) (args ()))))))))
    (doWork
     (instrs
      ((Mul ((dest tmp) (src1 (Var i)) (src2 (Var j))))
       (Add ((dest partial) (src1 (Var partial)) (src2 (Var tmp))))
       (Add ((dest j) (src1 (Var j)) (src2 (Lit 1))))
       (Branch
        (Cond (cond (Lit 1))
         (if_true ((block ((id_hum innerCheck) (args ()))) (args ())))
         (if_false ((block ((id_hum innerExit) (args ()))) (args ()))))))))
    (innerExit
     (instrs
      ((Add ((dest total) (src1 (Var total)) (src2 (Var partial))))
       (Branch
        (Cond (cond (Lit 1))
         (if_true ((block ((id_hum outerInc) (args ()))) (args ())))
         (if_false ((block ((id_hum exit) (args ()))) (args ()))))))))
    (outerInc
     (instrs
      ((Add ((dest i) (src1 (Var i)) (src2 (Lit 1))))
       (Branch (Uncond ((block ((id_hum outerCheck) (args ()))) (args ())))))))
    (exit (instrs ((Return (Var total)))))
    =================================
    (start (args ())
     (instrs
      ((Move n (Lit 7)) (Move i (Lit 0)) (Move total (Lit 0))
       (Branch
        (Cond (cond (Lit 1))
         (if_true
          ((block ((id_hum outerCheck) (args (partial%0 j%0 condOuter%0 i%0))))
           (args (partial j condOuter i))))
         (if_false
          ((block
            ((id_hum exit)
             (args (total%2 condInner%2 partial%4 j%5 condOuter%1))))
           (args (total condInner partial j condOuter)))))))))
    (outerCheck (args (partial%0 j%0 condOuter%0 i%0))
     (instrs
      ((Sub ((dest condOuter%0) (src1 (Var i%0)) (src2 (Var n))))
       (Branch
        (Cond (cond (Var condOuter%0))
         (if_true ((block ((id_hum outerBody) (args ()))) (args ())))
         (if_false
          ((block
            ((id_hum exit)
             (args (total%2 condInner%2 partial%4 j%5 condOuter%1))))
           (args (total condInner partial j condOuter%0)))))))))
    (outerBody (args ())
     (instrs
      ((Move j%0 (Lit 0)) (Move partial%0 (Lit 0))
       (Branch
        (Cond (cond (Lit 1))
         (if_true
          ((block
            ((id_hum innerCheck)
             (args (condSkip%1 condInner%0 partial%1 j%1 tmp%1 isEven%1))))
           (args (condSkip condInner partial%0 j%0 tmp isEven))))
         (if_false
          ((block ((id_hum outerInc) (args (total%1 condInner%1))))
           (args (total condInner)))))))))
    (innerCheck (args (condSkip%1 condInner%0 partial%1 j%1 tmp%1 isEven%1))
     (instrs
      ((Sub ((dest condInner%0) (src1 (Var j%0)) (src2 (Lit 3))))
       (Branch
        (Cond (cond (Var condInner%0))
         (if_true ((block ((id_hum innerBody) (args ()))) (args ())))
         (if_false
          ((block
            ((id_hum innerExit) (args (condSkip%0 partial%2 j%2 tmp%0 isEven%0))))
           (args (condSkip partial%0 j%0 tmp isEven)))))))))
    (innerBody (args ())
     (instrs
      ((And ((dest isEven%1) (src1 (Var j%0)) (src2 (Lit 1))))
       (Sub ((dest condSkip%1) (src1 (Var isEven%1)) (src2 (Lit 0))))
       (Branch
        (Cond (cond (Var condSkip%1))
         (if_true ((block ((id_hum doWork) (args ()))) (args ())))
         (if_false ((block ((id_hum skipEven) (args ()))) (args ()))))))))
    (skipEven (args ())
     (instrs
      ((Add ((dest j%4) (src1 (Var j%0)) (src2 (Lit 1))))
       (Branch
        (Cond (cond (Lit 1))
         (if_true
          ((block
            ((id_hum innerCheck)
             (args (condSkip%1 condInner%0 partial%1 j%1 tmp%1 isEven%1))))
           (args (condSkip%1 condInner%0 partial%0 j%4 tmp isEven%1))))
         (if_false
          ((block
            ((id_hum innerExit) (args (condSkip%0 partial%2 j%2 tmp%0 isEven%0))))
           (args (condSkip%1 partial%0 j%4 tmp isEven%1)))))))))
    (doWork (args ())
     (instrs
      ((Mul ((dest tmp%1) (src1 (Var i%0)) (src2 (Var j%0))))
       (Add ((dest partial%3) (src1 (Var partial%0)) (src2 (Var tmp%1))))
       (Add ((dest j%3) (src1 (Var j%0)) (src2 (Lit 1))))
       (Branch
        (Cond (cond (Lit 1))
         (if_true
          ((block
            ((id_hum innerCheck)
             (args (condSkip%1 condInner%0 partial%1 j%1 tmp%1 isEven%1))))
           (args (condSkip%1 condInner%0 partial%3 j%3 tmp%1 isEven%1))))
         (if_false
          ((block
            ((id_hum innerExit) (args (condSkip%0 partial%2 j%2 tmp%0 isEven%0))))
           (args (condSkip%1 partial%3 j%3 tmp%1 isEven%1)))))))))
    (innerExit (args (condSkip%0 partial%2 j%2 tmp%0 isEven%0))
     (instrs
      ((Add ((dest total%0) (src1 (Var total)) (src2 (Var partial%0))))
       (Branch
        (Cond (cond (Lit 1))
         (if_true
          ((block ((id_hum outerInc) (args (total%1 condInner%1))))
           (args (total%0 condInner%0))))
         (if_false
          ((block
            ((id_hum exit)
             (args (total%2 condInner%2 partial%4 j%5 condOuter%1))))
           (args (total%0 condInner%0 partial%0 j%0 condOuter%0)))))))))
    (outerInc (args (total%1 condInner%1))
     (instrs
      ((Add ((dest i%1) (src1 (Var i%0)) (src2 (Lit 1))))
       (Branch
        (Uncond
         ((block ((id_hum outerCheck) (args (partial%0 j%0 condOuter%0 i%0))))
          (args (partial%0 j%0 condOuter%0 i%1))))))))
    (exit (args (total%2 condInner%2 partial%4 j%5 condOuter%1))
     (instrs ((Return (Var total)))))
    ******************************
    (start (args ())
     (instrs
      ((Move i (Lit 0)) (Move total (Lit 0))
       (Branch
        (Uncond
         ((block ((id_hum outerCheck) (args (partial%0 j%0 condOuter%0 i%0))))
          (args (partial j condOuter i))))))))
    (outerCheck (args (partial%0 j%0 condOuter%0 i%0))
     (instrs
      ((Sub ((dest condOuter%0) (src1 (Var i%0)) (src2 (Lit 7))))
       (Branch
        (Cond (cond (Var condOuter%0))
         (if_true ((block ((id_hum outerBody) (args ()))) (args ())))
         (if_false ((block ((id_hum exit) (args ()))) (args ()))))))))
    (outerBody (args ())
     (instrs
      ((Move j%0 (Lit 0)) (Move partial%0 (Lit 0))
       (Branch
        (Uncond
         ((block
           ((id_hum innerCheck) (args (condSkip%1 condInner%0 tmp%1 isEven%1))))
          (args (condSkip condInner tmp isEven))))))))
    (innerCheck (args (condSkip%1 condInner%0 tmp%1 isEven%1))
     (instrs
      ((Move condInner%0 (Lit -3))
       (Branch (Uncond ((block ((id_hum innerBody) (args ()))) (args ())))))))
    (innerBody (args ())
     (instrs
      ((And ((dest isEven%1) (src1 (Lit 0)) (src2 (Lit 1))))
       (Move condSkip%1 (Var isEven%1))
       (Branch
        (Cond (cond (Var condSkip%1))
         (if_true ((block ((id_hum doWork) (args ()))) (args ())))
         (if_false ((block ((id_hum skipEven) (args ()))) (args ()))))))))
    (skipEven (args ())
     (instrs
      ((Move j%4 (Lit 1))
       (Branch
        (Cond (cond (Lit 1))
         (if_true
          ((block
            ((id_hum innerCheck) (args (condSkip%1 condInner%0 tmp%1 isEven%1))))
           (args (condSkip%1 condInner%0 tmp isEven%1))))
         (if_false ((block ((id_hum innerExit) (args ()))) (args ()))))))))
    (doWork (args ())
     (instrs
      ((Mul ((dest tmp%1) (src1 (Lit 0)) (src2 (Var i%0))))
       (Move partial%3 (Var tmp%1)) (Move j%3 (Lit 1))
       (Branch
        (Cond (cond (Lit 1))
         (if_true
          ((block
            ((id_hum innerCheck) (args (condSkip%1 condInner%0 tmp%1 isEven%1))))
           (args (condSkip%1 condInner%0 tmp%1 isEven%1))))
         (if_false ((block ((id_hum innerExit) (args ()))) (args ()))))))))
    (innerExit (args ())
     (instrs
      ((Move total%0 (Lit 0))
       (Branch (Uncond ((block ((id_hum outerInc) (args ()))) (args ())))))))
    (outerInc (args ())
     (instrs
      ((Add ((dest i%1) (src1 (Lit 1)) (src2 (Var i%0))))
       (Branch
        (Uncond
         ((block ((id_hum outerCheck) (args (partial%0 j%0 condOuter%0 i%0))))
          (args (partial%0 j%0 condOuter%0 i%1))))))))
    (exit (args ()) (instrs ((Return (Var total))))) |}]
