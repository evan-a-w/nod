open! Core

type error =
  [ `Duplicate_label of string
  | `Expected_digit of char
  | `Unexpected_character of char
  | `Unexpected_end_of_input
  | `Unexpected_eof_in_comment
  | `Unexpected_token of Token.t * Pos.t
  | `Unknown_instruction of string
  ]

let print_error = function
  | `Duplicate_label s -> Printf.printf "Error: duplicate label '%s'\n" s
  | `Expected_digit c ->
    Printf.printf "Error: expected a digit but got '%c'\n" c
  | `Unexpected_character c ->
    Printf.printf "Error: unexpected character '%c'\n" c
  | `Unexpected_end_of_input -> Printf.printf "Error: unexpected end of input\n"
  | `Unexpected_eof_in_comment ->
    Printf.printf "Error: unexpected EOF in comment\n"
  | `Unexpected_token (tok, pos) ->
    Printf.printf
      "Error: unexpected token %s at %s\n"
      (Token.to_string tok)
      (Pos.to_string pos)
  | `Unknown_instruction s ->
    Printf.printf "Error: unknown instruction '%s'\n" s
;;

let test s =
  s
  |> Parser.parse_string
  |> function
  | Error e -> print_error e
  | Ok blocks ->
    print_s [%sexp (blocks : string Ir.t' Vec.t String.Map.t * string Vec.t)]
;;

let%expect_test "simple" =
  {|
mov %a, 3
branch 1, a, b
a:
add %a, 1, 2
b:
add %a, %a, 4
|} |> test;
  [%expect
    {|
    (((%root
       ((Move a (Lit 3))
        (Branch
         (Cond (cond (Lit 1)) (if_true ((block a) (args ())))
          (if_false ((block b) (args ())))))))
      (a ((Add ((dest a) (src1 (Lit 1)) (src2 (Lit 2))))))
      (b ((Add ((dest a) (src1 (Var a)) (src2 (Lit 4)))))))
     (%root a b))
    |}]
;;

let%expect_test "simple with comment" =
  {|
mov %a, 3
    (* CommenT!!*)
branch 1, a, b
a:
add %a, 1, 2
b end
b:
add %a, %a, 4
end:
    unreachable

|}
  |> test;
  [%expect
    {|
    (((%root
       ((Move a (Lit 3))
        (Branch
         (Cond (cond (Lit 1)) (if_true ((block a) (args ())))
          (if_false ((block b) (args ())))))))
      (a
       ((Add ((dest a) (src1 (Lit 1)) (src2 (Lit 2))))
        (Branch (Uncond ((block end) (args ()))))))
      (b ((Add ((dest a) (src1 (Var a)) (src2 (Lit 4)))))) (end (Unreachable)))
     (%root a b end))
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
    (((a
       ((Move x (Lit 10)) (Move y (Lit 20))
        (Sub ((dest z) (src1 (Var y)) (src2 (Var x))))
        (Branch
         (Cond (cond (Lit 1)) (if_true ((block b) (args ())))
          (if_false ((block c) (args ())))))))
      (b
       ((Add ((dest z) (src1 (Var z)) (src2 (Lit 5))))
        (Branch
         (Cond (cond (Lit 1)) (if_true ((block end) (args ())))
          (if_false ((block end) (args ())))))))
      (c
       ((Move z (Lit 0))
        (Branch
         (Cond (cond (Lit 1)) (if_true ((block end) (args ())))
          (if_false ((block end) (args ())))))))
      (end (Unreachable)))
     (a b c end))
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
    (((%root
       ((Move a (Lit 4)) (Move b (Lit 5))
        (Mul ((dest c) (src1 (Var a)) (src2 (Var b))))
        (Branch
         (Cond (cond (Lit 1)) (if_true ((block divide) (args ())))
          (if_false ((block end) (args ())))))))
      (divide
       ((Div ((dest c) (src1 (Var c)) (src2 (Lit 2))))
        (Branch
         (Cond (cond (Lit 1)) (if_true ((block end) (args ())))
          (if_false ((block end) (args ())))))))
      (end (Unreachable)))
     (%root divide end))
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
    (((entry
       ((Move a (Lit 100)) (Move b (Lit 6))
        (Mod ((dest res) (src1 (Var a)) (src2 (Var b))))
        (Add ((dest res) (src1 (Var res)) (src2 (Lit 1)))) Unreachable)))
     (entry))
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
    (((%root
       ((Move i (Lit 0)) (Move sum (Lit 0))
        (Branch
         (Cond (cond (Lit 1)) (if_true ((block loop) (args ())))
          (if_false ((block loop) (args ())))))))
      (end (Unreachable))
      (loop
       ((Add ((dest sum) (src1 (Var sum)) (src2 (Var i))))
        (Add ((dest i) (src1 (Var i)) (src2 (Lit 1))))
        (Sub ((dest cond) (src1 (Lit 10)) (src2 (Var i))))
        (Branch
         (Cond (cond (Var cond)) (if_true ((block loop) (args ())))
          (if_false ((block end) (args ()))))))))
     (%root loop end))
    ---------------------------------
    ---------------------------------

    start:
      mov %x, 7
      mov %y, 2

      mul %x, %x, 3

      div %x, %x, %y

      (* Then check if y == 2 to decide next path
         We emulate a check by subtracting 2 from y *)
      sub %cond, %y, 2
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
    (((end (Unreachable))
      (ifFalse
       ((Add ((dest x) (src1 (Var x)) (src2 (Lit 10))))
        (Branch
         (Cond (cond (Lit 1)) (if_true ((block end) (args ())))
          (if_false ((block end) (args ())))))))
      (ifTrue
       ((Move x (Lit 999))
        (Branch
         (Cond (cond (Lit 1)) (if_true ((block end) (args ())))
          (if_false ((block end) (args ())))))))
      (start
       ((Move x (Lit 7)) (Move y (Lit 2))
        (Mul ((dest x) (src1 (Var x)) (src2 (Lit 3))))
        (Div ((dest x) (src1 (Var x)) (src2 (Var y))))
        (Sub ((dest cond) (src1 (Var y)) (src2 (Lit 2))))
        (Branch
         (Cond (cond (Var cond)) (if_true ((block ifTrue) (args ())))
          (if_false ((block ifFalse) (args ()))))))))
     (start ifTrue ifFalse end))
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
      return %res

    =================================
    (((entry
       ((Move a (Lit 100)) (Move b (Lit 6))
        (Mod ((dest res) (src1 (Var a)) (src2 (Var b))))
        (Add ((dest res) (src1 (Var res)) (src2 (Lit 1)))) (Return (Var res)))))
     (entry))
    ---------------------------------
    ---------------------------------

    start:
      mov %x, 7
      mov %y, 2

      mul %x, %x, 3

      div %x, %x, %y

      (* Then check if y == 2 to decide next path
         We emulate a check by subtracting 2 from y *)
      sub %cond, %y, 2
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
      return %x

    =================================
    (((end ((Return (Var x))))
      (ifFalse
       ((Add ((dest x) (src1 (Var x)) (src2 (Lit 10))))
        (Branch
         (Cond (cond (Lit 1)) (if_true ((block end) (args ())))
          (if_false ((block end) (args ())))))))
      (ifTrue
       ((Move x (Lit 999))
        (Branch
         (Cond (cond (Lit 1)) (if_true ((block end) (args ())))
          (if_false ((block end) (args ())))))))
      (start
       ((Move x (Lit 7)) (Move y (Lit 2))
        (Mul ((dest x) (src1 (Var x)) (src2 (Lit 3))))
        (Div ((dest x) (src1 (Var x)) (src2 (Var y))))
        (Sub ((dest cond) (src1 (Var y)) (src2 (Lit 2))))
        (Branch
         (Cond (cond (Var cond)) (if_true ((block ifTrue) (args ())))
          (if_false ((block ifFalse) (args ()))))))))
     (start ifTrue ifFalse end))
    ---------------------------------
    |}]
;;
