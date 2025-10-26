open! Core
open! Import

let map_function_roots ~f functions =
  Map.map ~f:(Function.map_root ~f) functions
;;

let test s =
  s
  |> Parser.parse_string
  |> Result.map ~f:(map_function_roots ~f:Cfg.process)
  |> function
  | Error e -> Nod_error.to_string e |> print_endline
  | Ok fns ->
    Map.iter
      fns
      ~f:(fun { Function.root = ~root:_, ~blocks:_, ~in_order:blocks; _ } ->
        Vec.iter blocks ~f:(fun block ->
          let instrs =
            Vec.to_list block.Block.instructions @ [ block.terminal ]
          in
          print_s [%message block.id_hum (instrs : Ir.t list)]))
;;

let%expect_test "f" =
  test Examples.Textual.f;
  [%expect
    {|
    (start
     (instrs
      ((Move ((name n) (type_ I64)) (Lit 7))
       (Move ((name i) (type_ I64)) (Lit 0))
       (Move ((name total) (type_ I64)) (Lit 0))
       (Branch
        (Cond (cond (Lit 1))
         (if_true ((block ((id_hum outerCheck) (args ()))) (args ())))
         (if_false ((block ((id_hum exit) (args ()))) (args ()))))))))
    (outerCheck
     (instrs
      ((Sub
        ((dest ((name condOuter) (type_ I64)))
         (src1 (Var ((name i) (type_ I64)))) (src2 (Var ((name n) (type_ I64))))))
       (Branch
        (Cond (cond (Var ((name condOuter) (type_ I64))))
         (if_true ((block ((id_hum outerBody) (args ()))) (args ())))
         (if_false ((block ((id_hum exit) (args ()))) (args ()))))))))
    (outerBody
     (instrs
      ((Move ((name j) (type_ I64)) (Lit 0))
       (Move ((name partial) (type_ I64)) (Lit 0))
       (Branch
        (Cond (cond (Lit 1))
         (if_true ((block ((id_hum innerCheck) (args ()))) (args ())))
         (if_false ((block ((id_hum outerInc) (args ()))) (args ()))))))))
    (innerCheck
     (instrs
      ((Sub
        ((dest ((name condInner) (type_ I64)))
         (src1 (Var ((name j) (type_ I64)))) (src2 (Lit 3))))
       (Branch
        (Cond (cond (Var ((name condInner) (type_ I64))))
         (if_true ((block ((id_hum innerBody) (args ()))) (args ())))
         (if_false ((block ((id_hum innerExit) (args ()))) (args ()))))))))
    (innerBody
     (instrs
      ((And
        ((dest ((name isEven) (type_ I64))) (src1 (Var ((name j) (type_ I64))))
         (src2 (Lit 1))))
       (Sub
        ((dest ((name condSkip) (type_ I64)))
         (src1 (Var ((name isEven) (type_ I64)))) (src2 (Lit 0))))
       (Branch
        (Cond (cond (Var ((name condSkip) (type_ I64))))
         (if_true ((block ((id_hum doWork) (args ()))) (args ())))
         (if_false ((block ((id_hum skipEven) (args ()))) (args ()))))))))
    (skipEven
     (instrs
      ((Add
        ((dest ((name j) (type_ I64))) (src1 (Var ((name j) (type_ I64))))
         (src2 (Lit 1))))
       (Branch
        (Cond (cond (Lit 1))
         (if_true ((block ((id_hum innerCheck) (args ()))) (args ())))
         (if_false ((block ((id_hum innerExit) (args ()))) (args ()))))))))
    (doWork
     (instrs
      ((Mul
        ((dest ((name tmp) (type_ I64))) (src1 (Var ((name i) (type_ I64))))
         (src2 (Var ((name j) (type_ I64))))))
       (Add
        ((dest ((name partial) (type_ I64)))
         (src1 (Var ((name partial) (type_ I64))))
         (src2 (Var ((name tmp) (type_ I64))))))
       (Add
        ((dest ((name j) (type_ I64))) (src1 (Var ((name j) (type_ I64))))
         (src2 (Lit 1))))
       (Branch
        (Cond (cond (Lit 1))
         (if_true ((block ((id_hum innerCheck) (args ()))) (args ())))
         (if_false ((block ((id_hum innerExit) (args ()))) (args ()))))))))
    (innerExit
     (instrs
      ((Add
        ((dest ((name total) (type_ I64)))
         (src1 (Var ((name total) (type_ I64))))
         (src2 (Var ((name partial) (type_ I64))))))
       (Branch
        (Cond (cond (Lit 1))
         (if_true ((block ((id_hum outerInc) (args ()))) (args ())))
         (if_false ((block ((id_hum exit) (args ()))) (args ()))))))))
    (outerInc
     (instrs
      ((Add
        ((dest ((name i) (type_ I64))) (src1 (Var ((name i) (type_ I64))))
         (src2 (Lit 1))))
       (Branch (Uncond ((block ((id_hum outerCheck) (args ()))) (args ())))))))
    (exit (instrs ((Return (Var ((name total) (type_ I64)))))))
    |}]
;;

let%expect_test "all examples" =
  List.iter Examples.Textual.all ~f:(fun s ->
    print_endline "---------------------------------";
    print_endline s;
    print_endline "=================================";
    test s;
    print_endline "---------------------------------");
  [%expect
    {|
    ---------------------------------

    a:
      mov %x:i64, 10

      mov %y:i64, 20

      sub %z:i64, %y, %x

      branch 1, b, c

    b:
      add %z:i64, %z, 5
      branch 1, end, end

    c:
      mov %z:i64, 0
      branch 1, end, end

    end:
      ret %z

    =================================
    (a
     (instrs
      ((Move ((name x) (type_ I64)) (Lit 10))
       (Move ((name y) (type_ I64)) (Lit 20))
       (Sub
        ((dest ((name z) (type_ I64))) (src1 (Var ((name y) (type_ I64))))
         (src2 (Var ((name x) (type_ I64))))))
       (Branch
        (Cond (cond (Lit 1)) (if_true ((block ((id_hum b) (args ()))) (args ())))
         (if_false ((block ((id_hum c) (args ()))) (args ()))))))))
    (b
     (instrs
      ((Add
        ((dest ((name z) (type_ I64))) (src1 (Var ((name z) (type_ I64))))
         (src2 (Lit 5))))
       (Branch
        (Cond (cond (Lit 1))
         (if_true ((block ((id_hum end) (args ()))) (args ())))
         (if_false ((block ((id_hum end) (args ()))) (args ()))))))))
    (c
     (instrs
      ((Move ((name z) (type_ I64)) (Lit 0))
       (Branch
        (Cond (cond (Lit 1))
         (if_true ((block ((id_hum end) (args ()))) (args ())))
         (if_false ((block ((id_hum end) (args ()))) (args ()))))))))
    (end (instrs ((Return (Var ((name z) (type_ I64)))))))
    ---------------------------------
    ---------------------------------

      (* Initialize two variables *)
      mov %a:i64, 4
      mov %b:i64, 5

      (* Multiply a * b -> %c *)
      mul %c:i64, %a, %b

      (* If we treat '1' as always-true, jump to label "divide" *)
      branch 1, divide, end

    divide:
      (* Divide %c by 2 *)
      div %c:i64, %c, 2
      branch 1, end, end

    end:
      unreachable

    =================================
    (%root
     (instrs
      ((Move ((name a) (type_ I64)) (Lit 4))
       (Move ((name b) (type_ I64)) (Lit 5))
       (Mul
        ((dest ((name c) (type_ I64))) (src1 (Var ((name a) (type_ I64))))
         (src2 (Var ((name b) (type_ I64))))))
       (Branch
        (Cond (cond (Lit 1))
         (if_true ((block ((id_hum divide) (args ()))) (args ())))
         (if_false ((block ((id_hum end) (args ()))) (args ()))))))))
    (divide
     (instrs
      ((Div
        ((dest ((name c) (type_ I64))) (src1 (Var ((name c) (type_ I64))))
         (src2 (Lit 2))))
       (Branch
        (Cond (cond (Lit 1))
         (if_true ((block ((id_hum end) (args ()))) (args ())))
         (if_false ((block ((id_hum end) (args ()))) (args ()))))))))
    (end (instrs (Unreachable)))
    ---------------------------------
    ---------------------------------

    entry:
      (* Put 100 into %a *)
      mov %a:i64, 100

      (* Put 6 into %b *)
      mov %b:i64, 6

      (* Compute a mod b -> %res *)
      mod %res:i64, %a, %b

      (* Add 1 to %res *)
      add %res:i64, %res, 1

      (* End of the program *)
      unreachable

    =================================
    (entry
     (instrs
      ((Move ((name a) (type_ I64)) (Lit 100))
       (Move ((name b) (type_ I64)) (Lit 6))
       (Mod
        ((dest ((name res) (type_ I64))) (src1 (Var ((name a) (type_ I64))))
         (src2 (Var ((name b) (type_ I64))))))
       (Add
        ((dest ((name res) (type_ I64))) (src1 (Var ((name res) (type_ I64))))
         (src2 (Lit 1))))
       Unreachable)))
    ---------------------------------
    ---------------------------------

      (* Initialize iteration counter *)
      mov %i:i64, 0

      (* Initialize sum *)
      mov %sum:i64, 0

      (* Jump to the loop *)
      branch 1, loop, loop

    loop:
      (* sum = sum + i *)
      add %sum:i64, %sum, %i

      add %i:i64, %i, 1

      (* We want to continue looping if i < 10
         We'll synthesize i < 10 by: cond = 10 - i
         If cond != 0, keep looping. If cond == 0, end. *)
      sub %cond:i64, 10, %i

      branch %cond, loop, end

    end:
      unreachable

    =================================
    (%root
     (instrs
      ((Move ((name i) (type_ I64)) (Lit 0))
       (Move ((name sum) (type_ I64)) (Lit 0))
       (Branch
        (Cond (cond (Lit 1))
         (if_true ((block ((id_hum loop) (args ()))) (args ())))
         (if_false ((block ((id_hum loop) (args ()))) (args ()))))))))
    (loop
     (instrs
      ((Add
        ((dest ((name sum) (type_ I64))) (src1 (Var ((name sum) (type_ I64))))
         (src2 (Var ((name i) (type_ I64))))))
       (Add
        ((dest ((name i) (type_ I64))) (src1 (Var ((name i) (type_ I64))))
         (src2 (Lit 1))))
       (Sub
        ((dest ((name cond) (type_ I64))) (src1 (Lit 10))
         (src2 (Var ((name i) (type_ I64))))))
       (Branch
        (Cond (cond (Var ((name cond) (type_ I64))))
         (if_true ((block ((id_hum loop) (args ()))) (args ())))
         (if_false ((block ((id_hum end) (args ()))) (args ()))))))))
    (end (instrs (Unreachable)))
    ---------------------------------
    ---------------------------------

    start:
      mov %x:i64, 7
      mov %y:i64, 2

      mul %x:i64, %x, 3

      div %x:i64, %x, %y

      (* Then check if y == 2 to decide next path
         We emulate a check by subtracting 2 from y *)
      sub %cond:i64, %y, 2
      branch %cond, ifTrue, ifFalse

    ifTrue:
      (* If y != 2, we would land here
         For illustration, set x = 999 *)
      mov %x:i64, 999
      branch 1, end, end

    ifFalse:
      (* If y == 2, we come here
         Let’s set x = x + 10 *)
      add %x:i64, %x, 10
      branch 1, end, end

    end:
      unreachable

    =================================
    (start
     (instrs
      ((Move ((name x) (type_ I64)) (Lit 7))
       (Move ((name y) (type_ I64)) (Lit 2))
       (Mul
        ((dest ((name x) (type_ I64))) (src1 (Var ((name x) (type_ I64))))
         (src2 (Lit 3))))
       (Div
        ((dest ((name x) (type_ I64))) (src1 (Var ((name x) (type_ I64))))
         (src2 (Var ((name y) (type_ I64))))))
       (Sub
        ((dest ((name cond) (type_ I64))) (src1 (Var ((name y) (type_ I64))))
         (src2 (Lit 2))))
       (Branch
        (Cond (cond (Var ((name cond) (type_ I64))))
         (if_true ((block ((id_hum ifTrue) (args ()))) (args ())))
         (if_false ((block ((id_hum ifFalse) (args ()))) (args ()))))))))
    (ifTrue
     (instrs
      ((Move ((name x) (type_ I64)) (Lit 999))
       (Branch
        (Cond (cond (Lit 1))
         (if_true ((block ((id_hum end) (args ()))) (args ())))
         (if_false ((block ((id_hum end) (args ()))) (args ()))))))))
    (ifFalse
     (instrs
      ((Add
        ((dest ((name x) (type_ I64))) (src1 (Var ((name x) (type_ I64))))
         (src2 (Lit 10))))
       (Branch
        (Cond (cond (Lit 1))
         (if_true ((block ((id_hum end) (args ()))) (args ())))
         (if_false ((block ((id_hum end) (args ()))) (args ()))))))))
    (end (instrs (Unreachable)))
    ---------------------------------
    ---------------------------------

    entry:
      (* Put 100 into %a *)
      mov %a:i64, 100

      (* Put 6 into %b *)
      mov %b:i64, 6

      (* Compute a mod b -> %res *)
      mod %res:i64, %a, %b

      (* Add 1 to %res *)
      add %res:i64, %res, 1

      (* End of the program *)
      return %res

    =================================
    (entry
     (instrs
      ((Move ((name a) (type_ I64)) (Lit 100))
       (Move ((name b) (type_ I64)) (Lit 6))
       (Mod
        ((dest ((name res) (type_ I64))) (src1 (Var ((name a) (type_ I64))))
         (src2 (Var ((name b) (type_ I64))))))
       (Add
        ((dest ((name res) (type_ I64))) (src1 (Var ((name res) (type_ I64))))
         (src2 (Lit 1))))
       (Return (Var ((name res) (type_ I64)))))))
    ---------------------------------
    ---------------------------------

    start:
      mov %x:i64, 7
      mov %y:i64, 2

      mul %x:i64, %x, 3

      div %x:i64, %x, %y

      (* Then check if y == 2 to decide next path
         We emulate a check by subtracting 2 from y *)
      sub %cond:i64, %y, 2
      branch %cond, ifTrue, ifFalse

    ifTrue:
      (* If y != 2, we would land here
         For illustration, set x = 999 *)
      mov %x:i64, 999
      branch 1, end, end

    ifFalse:
      (* If y == 2, we come here
         Let’s set x = x + 10 *)
      add %x:i64, %x, 10
      branch 1, end, end

    end:
      return %x

    =================================
    (start
     (instrs
      ((Move ((name x) (type_ I64)) (Lit 7))
       (Move ((name y) (type_ I64)) (Lit 2))
       (Mul
        ((dest ((name x) (type_ I64))) (src1 (Var ((name x) (type_ I64))))
         (src2 (Lit 3))))
       (Div
        ((dest ((name x) (type_ I64))) (src1 (Var ((name x) (type_ I64))))
         (src2 (Var ((name y) (type_ I64))))))
       (Sub
        ((dest ((name cond) (type_ I64))) (src1 (Var ((name y) (type_ I64))))
         (src2 (Lit 2))))
       (Branch
        (Cond (cond (Var ((name cond) (type_ I64))))
         (if_true ((block ((id_hum ifTrue) (args ()))) (args ())))
         (if_false ((block ((id_hum ifFalse) (args ()))) (args ()))))))))
    (ifTrue
     (instrs
      ((Move ((name x) (type_ I64)) (Lit 999))
       (Branch
        (Cond (cond (Lit 1))
         (if_true ((block ((id_hum end) (args ()))) (args ())))
         (if_false ((block ((id_hum end) (args ()))) (args ()))))))))
    (ifFalse
     (instrs
      ((Add
        ((dest ((name x) (type_ I64))) (src1 (Var ((name x) (type_ I64))))
         (src2 (Lit 10))))
       (Branch
        (Cond (cond (Lit 1))
         (if_true ((block ((id_hum end) (args ()))) (args ())))
         (if_false ((block ((id_hum end) (args ()))) (args ()))))))))
    (end (instrs ((Return (Var ((name x) (type_ I64)))))))
    ---------------------------------
    |}]
;;
