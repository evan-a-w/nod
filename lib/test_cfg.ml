open! Core

let test s =
  s
  |> Parser.parse_string
  |> function
  | Error e -> Test_parser.print_error e
  | Ok blocks ->
    let _, blocks = Cfg.process blocks in
    Vec.iter blocks ~f:(fun block ->
      let instrs = Vec.to_list block.instructions @ [ block.terminal ] in
      print_s [%message block.id_hum (instrs : Ir.Instr.t list)])
;;

let%expect_test "all examples" =
  List.iter Examples.Textual.all ~f:(fun s ->
    print_endline "---------------------------------";
    print_endline s;
    print_endline "=================================";
    test s;
    print_endline "---------------------------------");
  [%expect {|
    ---------------------------------

    a:
      mov %x, 10

      mov %y, 20

      sub %z, %y, %x

      branch 1, b, c

    b:
      add %z, %z, 5
      branch 1, end, end

    c:
      mov %z, 0
      branch 1, end, end

    end:
      unreachable

    =================================
    (a
     (instrs
      ((Move x (Lit 10)) (Move y (Lit 20))
       (Sub ((dest z) (src1 (Var y)) (src2 (Var x)))) Unreachable)))
    (b (instrs ((Add ((dest z) (src1 (Var z)) (src2 (Lit 5)))) Unreachable)))
    (c (instrs ((Move z (Lit 0)) Unreachable)))
    (end (instrs (Unreachable)))
    ---------------------------------
    ---------------------------------

      (* Initialize two variables *)
      mov %a, 4
      mov %b, 5

      (* Multiply a * b -> %c *)
      mul %c, %a, %b

      (* If we treat '1' as always-true, jump to label "divide" *)
      branch 1, divide, end

    divide:
      (* Divide %c by 2 *)
      div %c, %c, 2
      branch 1, end, end

    end:
      unreachable

    =================================
    (%root
     (instrs
      ((Move a (Lit 4)) (Move b (Lit 5))
       (Mul ((dest c) (src1 (Var a)) (src2 (Var b)))) Unreachable)))
    (divide
     (instrs ((Div ((dest c) (src1 (Var c)) (src2 (Lit 2)))) Unreachable)))
    (end (instrs (Unreachable)))
    ---------------------------------
    ---------------------------------

    entry:
      (* Put 100 into %a *)
      mov %a, 100

      (* Put 6 into %b *)
      mov %b, 6

      (* Compute a mod b -> %res *)
      mod %res, %a, %b

      (* Add 1 to %res *)
      add %res, %res, 1

      (* End of the program *)
      unreachable

    =================================
    (entry
     (instrs
      ((Move a (Lit 100)) (Move b (Lit 6))
       (Mod ((dest res) (src1 (Var a)) (src2 (Var b))))
       (Add ((dest res) (src1 (Var res)) (src2 (Lit 1)))) Unreachable)))
    ---------------------------------
    ---------------------------------

      (* Initialize iteration counter *)
      mov %i, 0

      (* Initialize sum *)
      mov %sum, 0

      (* Jump to the loop *)
      branch 1, loop, loop

    loop:
      (* sum = sum + i *)
      add %sum, %sum, %i

      add %i, %i, 1

      (* We want to continue looping if i < 10
         We'll synthesize i < 10 by: cond = 10 - i
         If cond != 0, keep looping. If cond == 0, end. *)
      sub %cond, 10, %i

      branch %cond, loop, end

    end:
      unreachable

    =================================
    (%root (instrs ((Move i (Lit 0)) (Move sum (Lit 0)) Unreachable)))
    (loop
     (instrs
      ((Add ((dest sum) (src1 (Var sum)) (src2 (Var i))))
       (Add ((dest i) (src1 (Var i)) (src2 (Lit 1))))
       (Sub ((dest cond) (src1 (Lit 10)) (src2 (Var i)))) Unreachable)))
    (end (instrs (Unreachable)))
    ---------------------------------
    ---------------------------------

    start:
      mov %x, 7
      mov %y, 2

      mul %x, %x, 3

      div %x, %x, %y

      (* Then check if y == 2 to decide next path
         We emulate a check by subtracting 2 from y
         sub %cond, %y, 2 *)
      branch %cond, ifTrue, ifFalse

    ifTrue:
      (* If y != 2, we would land here
         For illustration, set x = 999 *)
      mov %x, 999
      branch 1, end, end

    ifFalse:
      (* If y == 2, we come here
         Let’s set x = x + 10 *)
      add %x, %x, 10
      branch 1, end, end

    end:
      unreachable

    =================================
    (start
     (instrs
      ((Move x (Lit 7)) (Move y (Lit 2))
       (Mul ((dest x) (src1 (Var x)) (src2 (Lit 3))))
       (Div ((dest x) (src1 (Var x)) (src2 (Var y)))) Unreachable)))
    (ifTrue (instrs ((Move x (Lit 999)) Unreachable)))
    (ifFalse
     (instrs ((Add ((dest x) (src1 (Var x)) (src2 (Lit 10)))) Unreachable)))
    (end (instrs (Unreachable)))
    --------------------------------- |}]
;;
