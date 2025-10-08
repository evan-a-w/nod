open! Core
open! Nod

let test ?dump_crap ?(opt_flags = Eir.Opt_flags.no_opt) s =
  match Eir.compile ~opt_flags s with
  | Error e -> Test_parser.print_error e
  | Ok root ->
    Block.print_verbose root;
    let x86 = X86_backend.compile ?dump_crap root in
    Block.print_verbose x86
;;

let%expect_test "trivi" =
  test Examples.Textual.super_triv;
  [%expect
    {|
    ((a (args ())
      (instrs
       ((Move x (Lit 10)) (Move y (Lit 20))
        (Sub ((dest z) (src1 (Var y)) (src2 (Var x)))) (Return (Var z))))))
    ((a (args ())
      (instrs
       ((X86 (MOV (Reg R15) (Imm 10))) (X86 (MOV (Reg R14) (Imm 20)))
        (X86 (MOV (Reg R14) (Reg R14))) (X86 (SUB (Reg R14) (Reg R15)))
        (X86_terminal ((RET (Reg R14))))))))
    |}]
;;

let%expect_test "a" =
  test Examples.Textual.a;
  [%expect
    {|
    ((a (args ())
      (instrs
       ((Move x (Lit 10)) (Move y (Lit 20))
        (Sub ((dest z) (src1 (Var y)) (src2 (Var x))))
        (Branch
         (Cond (cond (Lit 1))
          (if_true ((block ((id_hum b) (args ()))) (args ())))
          (if_false ((block ((id_hum c) (args ()))) (args ()))))))))
     (b (args ())
      (instrs
       ((Add ((dest z%2) (src1 (Var z)) (src2 (Lit 5))))
        (Branch
         (Cond (cond (Lit 1))
          (if_true ((block ((id_hum end) (args (z%0)))) (args (z%2))))
          (if_false ((block ((id_hum end) (args (z%0)))) (args (z%2)))))))))
     (end (args (z%0)) (instrs ((Return (Var z%0)))))
     (c (args ())
      (instrs
       ((Move z%1 (Lit 0))
        (Branch
         (Cond (cond (Lit 1))
          (if_true ((block ((id_hum end) (args (z%0)))) (args (z%1))))
          (if_false ((block ((id_hum end) (args (z%0)))) (args (z%1))))))))))
    ((a (args ())
      (instrs
       ((X86 (MOV (Reg R15) (Imm 10))) (X86 (MOV (Reg R14) (Imm 20)))
        (X86 (MOV (Reg R14) (Reg R14))) (X86 (SUB (Reg R14) (Reg R15)))
        (X86_terminal
         ((CMP (Imm 1) (Imm 0))
          (JNE ((block ((id_hum intermediate_a_to_b) (args ()))) (args ()))
           (((block ((id_hum intermediate_a_to_c) (args ()))) (args ())))))))))
     (intermediate_a_to_b (args ())
      (instrs ((X86 (JMP ((block ((id_hum b) (args ()))) (args ())))))))
     (b (args ())
      (instrs
       ((X86 (MOV (Reg R15) (Reg R14))) (X86 (ADD (Reg R15) (Imm 5)))
        (X86_terminal
         ((CMP (Imm 1) (Imm 0))
          (JNE ((block ((id_hum intermediate_b_to_end0) (args (z%2)))) (args ()))
           (((block ((id_hum intermediate_b_to_end) (args (z%2)))) (args ())))))))))
     (intermediate_b_to_end0 (args (z%2))
      (instrs
       ((X86 (MOV (Reg R14) (Reg R15)))
        (X86 (JMP ((block ((id_hum end) (args (z%0)))) (args ())))))))
     (end (args (z%0)) (instrs ((X86_terminal ((RET (Reg R14)))))))
     (intermediate_b_to_end (args (z%2))
      (instrs
       ((X86 (MOV (Reg R14) (Reg R15)))
        (X86 (JMP ((block ((id_hum end) (args (z%0)))) (args ())))))))
     (intermediate_a_to_c (args ())
      (instrs ((X86 (JMP ((block ((id_hum c) (args ()))) (args ())))))))
     (c (args ())
      (instrs
       ((X86 (MOV (Reg R15) (Imm 0)))
        (X86_terminal
         ((CMP (Imm 1) (Imm 0))
          (JNE ((block ((id_hum intermediate_c_to_end0) (args (z%1)))) (args ()))
           (((block ((id_hum intermediate_c_to_end) (args (z%1)))) (args ())))))))))
     (intermediate_c_to_end0 (args (z%1))
      (instrs
       ((X86 (MOV (Reg R14) (Reg R15)))
        (X86 (JMP ((block ((id_hum end) (args (z%0)))) (args ())))))))
     (intermediate_c_to_end (args (z%1))
      (instrs
       ((X86 (MOV (Reg R14) (Reg R15)))
        (X86 (JMP ((block ((id_hum end) (args (z%0)))) (args ()))))))))
    |}]
;;

let%expect_test "e2" =
  test Examples.Textual.e2;
  [%expect
    {|
    ((start (args ())
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
     (end (args (x%2)) (instrs ((Return (Var x%2)))))
     (ifFalse (args ())
      (instrs
       ((Add ((dest x%3) (src1 (Var x%1)) (src2 (Lit 10))))
        (Branch
         (Cond (cond (Lit 1))
          (if_true ((block ((id_hum end) (args (x%2)))) (args (x%3))))
          (if_false ((block ((id_hum end) (args (x%2)))) (args (x%3))))))))))
    ((start (args ())
      (instrs
       ((X86 (MOV (Reg R14) (Imm 7))) (X86 (MOV (Reg R15) (Imm 2)))
        (X86 (MOV (Reg RAX) (Reg R14)))
        (X86 (Tag_def (Tag_use (IMUL (Imm 3)) (Reg RAX)) (Reg RAX)))
        (X86 (MOV (Reg R14) (Reg RAX))) (X86 (MOV (Reg RAX) (Reg R14)))
        (X86 (Tag_def (Tag_use (IDIV (Reg R15)) (Reg RAX)) (Reg RAX)))
        (X86 (MOV (Reg R14) (Reg RAX))) (X86 (MOV (Reg R15) (Reg R15)))
        (X86 (SUB (Reg R15) (Imm 2)))
        (X86_terminal
         ((CMP (Reg R15) (Imm 0))
          (JNE
           ((block ((id_hum intermediate_start_to_ifTrue) (args ()))) (args ()))
           (((block ((id_hum intermediate_start_to_ifFalse) (args ())))
             (args ())))))))))
     (intermediate_start_to_ifTrue (args ())
      (instrs ((X86 (JMP ((block ((id_hum ifTrue) (args ()))) (args ())))))))
     (ifTrue (args ())
      (instrs
       ((X86 (MOV (Reg R14) (Imm 999)))
        (X86_terminal
         ((CMP (Imm 1) (Imm 0))
          (JNE
           ((block ((id_hum intermediate_ifTrue_to_end0) (args (x%4))))
            (args ()))
           (((block ((id_hum intermediate_ifTrue_to_end) (args (x%4))))
             (args ())))))))))
     (intermediate_ifTrue_to_end0 (args (x%4))
      (instrs
       ((X86 (MOV (Reg R15) (Reg R14)))
        (X86 (JMP ((block ((id_hum end) (args (x%2)))) (args ())))))))
     (end (args (x%2)) (instrs ((X86_terminal ((RET (Reg R15)))))))
     (intermediate_ifTrue_to_end (args (x%4))
      (instrs
       ((X86 (MOV (Reg R15) (Reg R14)))
        (X86 (JMP ((block ((id_hum end) (args (x%2)))) (args ())))))))
     (intermediate_start_to_ifFalse (args ())
      (instrs ((X86 (JMP ((block ((id_hum ifFalse) (args ()))) (args ())))))))
     (ifFalse (args ())
      (instrs
       ((X86 (MOV (Reg R13) (Reg R14))) (X86 (ADD (Reg R13) (Imm 10)))
        (X86_terminal
         ((CMP (Imm 1) (Imm 0))
          (JNE
           ((block ((id_hum intermediate_ifFalse_to_end0) (args (x%3))))
            (args ()))
           (((block ((id_hum intermediate_ifFalse_to_end) (args (x%3))))
             (args ())))))))))
     (intermediate_ifFalse_to_end0 (args (x%3))
      (instrs
       ((X86 (MOV (Reg R15) (Reg R13)))
        (X86 (JMP ((block ((id_hum end) (args (x%2)))) (args ())))))))
     (intermediate_ifFalse_to_end (args (x%3))
      (instrs
       ((X86 (MOV (Reg R15) (Reg R13)))
        (X86 (JMP ((block ((id_hum end) (args (x%2)))) (args ()))))))))
    |}]
;;

let%expect_test "c2" =
  test Examples.Textual.c2;
  [%expect
    {|
    ((entry (args ())
      (instrs
       ((Move a (Lit 100)) (Move b (Lit 6))
        (Mod ((dest res) (src1 (Var a)) (src2 (Var b))))
        (Add ((dest res%0) (src1 (Var res)) (src2 (Lit 1))))
        (Return (Var res%0))))))
    ((entry (args ())
      (instrs
       ((X86 (MOV (Reg R14) (Imm 100))) (X86 (MOV (Reg R15) (Imm 6)))
        (X86 (MOV (Reg RAX) (Reg R14)))
        (X86 (Tag_def (Tag_use (MOD (Reg R15)) (Reg RAX)) (Reg RDX)))
        (X86 (MOV (Reg R15) (Reg RDX))) (X86 (MOV (Reg R15) (Reg R15)))
        (X86 (ADD (Reg R15) (Imm 1))) (X86_terminal ((RET (Reg R15))))))))
    |}]
;;

let%expect_test "f" =
  test Examples.Textual.f;
  [%expect
    {|
    ((start (args ())
      (instrs
       ((Move n (Lit 7)) (Move i (Lit 0)) (Move total (Lit 0))
        (Branch
         (Cond (cond (Lit 1))
          (if_true
           ((block ((id_hum outerCheck) (args (partial%0 j%0 i%0))))
            (args (partial j i))))
          (if_false
           ((block ((id_hum exit) (args (total%2 partial%4 j%5))))
            (args (total partial j)))))))))
     (outerCheck (args (partial%0 j%0 i%0))
      (instrs
       ((Sub ((dest condOuter) (src1 (Var i%0)) (src2 (Var n))))
        (Branch
         (Cond (cond (Var condOuter))
          (if_true ((block ((id_hum outerBody) (args ()))) (args ())))
          (if_false
           ((block ((id_hum exit) (args (total%2 partial%4 j%5))))
            (args (total partial j)))))))))
     (outerBody (args ())
      (instrs
       ((Move j%0 (Lit 0)) (Move partial%0 (Lit 0))
        (Branch
         (Cond (cond (Lit 1))
          (if_true
           ((block ((id_hum innerCheck) (args (partial%1 j%1))))
            (args (partial%0 j%0))))
          (if_false
           ((block ((id_hum outerInc) (args (total%1)))) (args (total)))))))))
     (innerCheck (args (partial%1 j%1))
      (instrs
       ((Sub ((dest condInner) (src1 (Var j%0)) (src2 (Lit 3))))
        (Branch
         (Cond (cond (Var condInner))
          (if_true ((block ((id_hum innerBody) (args ()))) (args ())))
          (if_false
           ((block ((id_hum innerExit) (args (partial%2 j%2))))
            (args (partial%0 j%0)))))))))
     (innerBody (args ())
      (instrs
       ((And ((dest isEven) (src1 (Var j%0)) (src2 (Lit 1))))
        (Sub ((dest condSkip) (src1 (Var isEven)) (src2 (Lit 0))))
        (Branch
         (Cond (cond (Var condSkip))
          (if_true ((block ((id_hum doWork) (args ()))) (args ())))
          (if_false ((block ((id_hum skipEven) (args ()))) (args ()))))))))
     (doWork (args ())
      (instrs
       ((Mul ((dest tmp) (src1 (Var i%0)) (src2 (Var j%0))))
        (Add ((dest partial%3) (src1 (Var partial%0)) (src2 (Var tmp))))
        (Add ((dest j%3) (src1 (Var j%0)) (src2 (Lit 1))))
        (Branch
         (Cond (cond (Lit 1))
          (if_true
           ((block ((id_hum innerCheck) (args (partial%1 j%1))))
            (args (partial%3 j%3))))
          (if_false
           ((block ((id_hum innerExit) (args (partial%2 j%2))))
            (args (partial%3 j%3)))))))))
     (innerExit (args (partial%2 j%2))
      (instrs
       ((Add ((dest total%0) (src1 (Var total)) (src2 (Var partial%0))))
        (Branch
         (Cond (cond (Lit 1))
          (if_true
           ((block ((id_hum outerInc) (args (total%1)))) (args (total%0))))
          (if_false
           ((block ((id_hum exit) (args (total%2 partial%4 j%5))))
            (args (total%0 partial%0 j%0)))))))))
     (outerInc (args (total%1))
      (instrs
       ((Add ((dest i%1) (src1 (Var i%0)) (src2 (Lit 1))))
        (Branch
         (Uncond
          ((block ((id_hum outerCheck) (args (partial%0 j%0 i%0))))
           (args (partial%0 j%0 i%1))))))))
     (exit (args (total%2 partial%4 j%5)) (instrs ((Return (Var total)))))
     (skipEven (args ())
      (instrs
       ((Add ((dest j%4) (src1 (Var j%0)) (src2 (Lit 1))))
        (Branch
         (Cond (cond (Lit 1))
          (if_true
           ((block ((id_hum innerCheck) (args (partial%1 j%1))))
            (args (partial%0 j%4))))
          (if_false
           ((block ((id_hum innerExit) (args (partial%2 j%2))))
            (args (partial%0 j%4))))))))))
    ((start (args ())
      (instrs
       ((X86 (MOV (Reg R12) (Imm 7))) (X86 (MOV (Reg R12) (Imm 0)))
        (X86 (MOV (Reg R12) (Imm 0)))
        (X86_terminal
         ((CMP (Imm 1) (Imm 0))
          (JNE
           ((block
             ((id_hum intermediate_start_to_outerCheck) (args (partial j i))))
            (args ()))
           (((block
              ((id_hum intermediate_start_to_exit) (args (total partial j))))
             (args ())))))))))
     (intermediate_start_to_outerCheck (args (partial j i))
      (instrs
       ((X86 (MOV (Reg R11) (Reg R12))) (X86 (MOV (Reg R14) (Reg R15)))
        (X86 (MOV (Reg R13) (Reg R15)))
        (X86
         (JMP
          ((block ((id_hum outerCheck) (args (partial%0 j%0 i%0)))) (args ())))))))
     (outerCheck (args (partial%0 j%0 i%0))
      (instrs
       ((X86 (MOV (Reg R10) (Reg R11))) (X86 (SUB (Reg R10) (Reg R12)))
        (X86_terminal
         ((CMP (Reg R10) (Imm 0))
          (JNE
           ((block ((id_hum intermediate_outerCheck_to_outerBody) (args ())))
            (args ()))
           (((block
              ((id_hum intermediate_outerCheck_to_exit) (args (total partial j))))
             (args ())))))))))
     (intermediate_outerCheck_to_outerBody (args ())
      (instrs ((X86 (JMP ((block ((id_hum outerBody) (args ()))) (args ())))))))
     (outerBody (args ())
      (instrs
       ((X86 (MOV (Reg R14) (Imm 0))) (X86 (MOV (Reg R13) (Imm 0)))
        (X86_terminal
         ((CMP (Imm 1) (Imm 0))
          (JNE
           ((block
             ((id_hum intermediate_outerBody_to_innerCheck)
              (args (partial%0 j%0))))
            (args ()))
           (((block ((id_hum intermediate_outerBody_to_outerInc) (args (total))))
             (args ())))))))))
     (intermediate_outerBody_to_innerCheck (args (partial%0 j%0))
      (instrs
       ((X86 (MOV (Reg R9) (Reg R14))) (X86 (MOV (Reg R9) (Reg R13)))
        (X86
         (JMP ((block ((id_hum innerCheck) (args (partial%1 j%1)))) (args ())))))))
     (innerCheck (args (partial%1 j%1))
      (instrs
       ((X86 (MOV (Reg R10) (Reg R14))) (X86 (SUB (Reg R10) (Imm 3)))
        (X86_terminal
         ((CMP (Reg R10) (Imm 0))
          (JNE
           ((block ((id_hum intermediate_innerCheck_to_innerBody) (args ())))
            (args ()))
           (((block
              ((id_hum intermediate_innerCheck_to_innerExit)
               (args (partial%0 j%0))))
             (args ())))))))))
     (intermediate_innerCheck_to_innerBody (args ())
      (instrs ((X86 (JMP ((block ((id_hum innerBody) (args ()))) (args ())))))))
     (innerBody (args ())
      (instrs
       ((X86 (MOV (Reg R10) (Reg R14))) (X86 (AND (Reg R10) (Imm 1)))
        (X86 (MOV (Reg R10) (Reg R10))) (X86 (SUB (Reg R10) (Imm 0)))
        (X86_terminal
         ((CMP (Reg R10) (Imm 0))
          (JNE
           ((block ((id_hum intermediate_innerBody_to_doWork) (args ())))
            (args ()))
           (((block ((id_hum intermediate_innerBody_to_skipEven) (args ())))
             (args ())))))))))
     (intermediate_innerBody_to_doWork (args ())
      (instrs ((X86 (JMP ((block ((id_hum doWork) (args ()))) (args ())))))))
     (doWork (args ())
      (instrs
       ((X86 (MOV (Reg RAX) (Reg R11)))
        (X86 (Tag_def (Tag_use (IMUL (Reg R14)) (Reg RAX)) (Reg RAX)))
        (X86 (MOV (Reg R9) (Reg RAX))) (X86 (MOV (Reg R10) (Reg R13)))
        (X86 (ADD (Reg R10) (Reg R9))) (X86 (MOV (Reg R10) (Reg R14)))
        (X86 (ADD (Reg R10) (Imm 1)))
        (X86_terminal
         ((CMP (Imm 1) (Imm 0))
          (JNE
           ((block
             ((id_hum intermediate_doWork_to_innerCheck) (args (partial%3 j%3))))
            (args ()))
           (((block
              ((id_hum intermediate_doWork_to_innerExit) (args (partial%3 j%3))))
             (args ())))))))))
     (intermediate_doWork_to_innerCheck (args (partial%3 j%3))
      (instrs
       ((X86 (MOV (Reg R9) (Reg R10))) (X86 (MOV (Reg R9) (Reg R10)))
        (X86
         (JMP ((block ((id_hum innerCheck) (args (partial%1 j%1)))) (args ())))))))
     (intermediate_doWork_to_innerExit (args (partial%3 j%3))
      (instrs
       ((X86 (MOV (Reg R9) (Reg R10))) (X86 (MOV (Reg R9) (Reg R10)))
        (X86
         (JMP ((block ((id_hum innerExit) (args (partial%2 j%2)))) (args ())))))))
     (innerExit (args (partial%2 j%2))
      (instrs
       ((X86 (MOV (Reg R10) (Reg R12))) (X86 (ADD (Reg R10) (Reg R13)))
        (X86_terminal
         ((CMP (Imm 1) (Imm 0))
          (JNE
           ((block
             ((id_hum intermediate_innerExit_to_outerInc) (args (total%0))))
            (args ()))
           (((block
              ((id_hum intermediate_innerExit_to_exit)
               (args (total%0 partial%0 j%0))))
             (args ())))))))))
     (intermediate_innerExit_to_outerInc (args (total%0))
      (instrs
       ((X86 (MOV (Reg R9) (Reg R10)))
        (X86 (JMP ((block ((id_hum outerInc) (args (total%1)))) (args ())))))))
     (outerInc (args (total%1))
      (instrs
       ((X86 (MOV (Reg R11) (Reg R11))) (X86 (ADD (Reg R11) (Imm 1)))
        (X86 (MOV (Reg R11) (Reg R11))) (X86 (MOV (Reg R14) (Reg R14)))
        (X86 (MOV (Reg R14) (Reg R14))) (X86 (MOV (Reg R13) (Reg R13)))
        (X86 (MOV (Reg R13) (Reg R13)))
        (X86_terminal
         ((JMP
           ((block ((id_hum outerCheck) (args (partial%0 j%0 i%0)))) (args ()))))))))
     (intermediate_innerExit_to_exit (args (total%0 partial%0 j%0))
      (instrs
       ((X86 (MOV (Reg R11) (Reg R14))) (X86 (MOV (Reg R11) (Reg R13)))
        (X86 (MOV (Reg R11) (Reg R10)))
        (X86
         (JMP ((block ((id_hum exit) (args (total%2 partial%4 j%5)))) (args ())))))))
     (exit (args (total%2 partial%4 j%5))
      (instrs ((X86_terminal ((RET (Reg R12)))))))
     (intermediate_innerBody_to_skipEven (args ())
      (instrs ((X86 (JMP ((block ((id_hum skipEven) (args ()))) (args ())))))))
     (skipEven (args ())
      (instrs
       ((X86 (MOV (Reg R10) (Reg R14))) (X86 (ADD (Reg R10) (Imm 1)))
        (X86_terminal
         ((CMP (Imm 1) (Imm 0))
          (JNE
           ((block
             ((id_hum intermediate_skipEven_to_innerCheck)
              (args (partial%0 j%4))))
            (args ()))
           (((block
              ((id_hum intermediate_skipEven_to_innerExit)
               (args (partial%0 j%4))))
             (args ())))))))))
     (intermediate_skipEven_to_innerCheck (args (partial%0 j%4))
      (instrs
       ((X86 (MOV (Reg R9) (Reg R10))) (X86 (MOV (Reg R9) (Reg R13)))
        (X86
         (JMP ((block ((id_hum innerCheck) (args (partial%1 j%1)))) (args ())))))))
     (intermediate_skipEven_to_innerExit (args (partial%0 j%4))
      (instrs
       ((X86 (MOV (Reg R9) (Reg R10))) (X86 (MOV (Reg R9) (Reg R13)))
        (X86
         (JMP ((block ((id_hum innerExit) (args (partial%2 j%2)))) (args ())))))))
     (intermediate_innerCheck_to_innerExit (args (partial%0 j%0))
      (instrs
       ((X86 (MOV (Reg R9) (Reg R14))) (X86 (MOV (Reg R9) (Reg R13)))
        (X86
         (JMP ((block ((id_hum innerExit) (args (partial%2 j%2)))) (args ())))))))
     (intermediate_outerBody_to_outerInc (args (total))
      (instrs
       ((X86 (MOV (Reg R9) (Reg R12)))
        (X86 (JMP ((block ((id_hum outerInc) (args (total%1)))) (args ())))))))
     (intermediate_outerCheck_to_exit (args (total partial j))
      (instrs
       ((X86 (MOV (Reg R11) (Reg R15))) (X86 (MOV (Reg R11) (Reg R15)))
        (X86 (MOV (Reg R11) (Reg R12)))
        (X86
         (JMP ((block ((id_hum exit) (args (total%2 partial%4 j%5)))) (args ())))))))
     (intermediate_start_to_exit (args (total partial j))
      (instrs
       ((X86 (MOV (Reg R11) (Reg R15))) (X86 (MOV (Reg R11) (Reg R15)))
        (X86 (MOV (Reg R11) (Reg R12)))
        (X86
         (JMP ((block ((id_hum exit) (args (total%2 partial%4 j%5)))) (args ()))))))))
    |}]
;;

let%expect_test "fib" =
  test Examples.Textual.fib;
  [%expect
    {|
    ((%root (args ())
      (instrs
       ((Move arg (Lit 10))
        (Branch (Uncond ((block ((id_hum fib_start) (args ()))) (args ())))))))
     (fib_start (args ())
      (instrs
       ((Move count (Var arg)) (Move a (Lit 0)) (Move b (Lit 1))
        (Branch
         (Uncond
          ((block ((id_hum fib_check) (args (a%0 count%0 b%0))))
           (args (a count b))))))))
     (fib_check (args (a%0 count%0 b%0))
      (instrs
       ((Branch
         (Cond (cond (Var count%0))
          (if_true ((block ((id_hum fib_body) (args ()))) (args ())))
          (if_false ((block ((id_hum fib_exit) (args ()))) (args ()))))))))
     (fib_body (args ())
      (instrs
       ((Add ((dest next) (src1 (Var a%0)) (src2 (Var b%0))))
        (Move a%1 (Var b%0)) (Move b%1 (Var next))
        (Sub ((dest count%1) (src1 (Var count%0)) (src2 (Lit 1))))
        (Branch
         (Uncond
          ((block ((id_hum fib_check) (args (a%0 count%0 b%0))))
           (args (a%1 count%1 b%1))))))))
     (fib_exit (args ()) (instrs ((Return (Var a%0))))))
    ((%root (args ())
      (instrs
       ((X86 (MOV (Reg R14) (Imm 10)))
        (X86_terminal ((JMP ((block ((id_hum fib_start) (args ()))) (args ()))))))))
     (fib_start (args ())
      (instrs
       ((X86 (MOV (Reg R12) (Reg R14))) (X86 (MOV (Reg R15) (Imm 0)))
        (X86 (MOV (Reg R13) (Imm 1))) (X86 (MOV (Reg R15) (Reg R15)))
        (X86 (MOV (Reg R13) (Reg R13))) (X86 (MOV (Reg R12) (Reg R12)))
        (X86_terminal
         ((JMP ((block ((id_hum fib_check) (args (a%0 count%0 b%0)))) (args ()))))))))
     (fib_check (args (a%0 count%0 b%0))
      (instrs
       ((X86_terminal
         ((CMP (Reg R12) (Imm 0))
          (JNE
           ((block ((id_hum intermediate_fib_check_to_fib_body) (args ())))
            (args ()))
           (((block ((id_hum intermediate_fib_check_to_fib_exit) (args ())))
             (args ())))))))))
     (intermediate_fib_check_to_fib_body (args ())
      (instrs ((X86 (JMP ((block ((id_hum fib_body) (args ()))) (args ())))))))
     (fib_body (args ())
      (instrs
       ((X86 (MOV (Reg R14) (Reg R15))) (X86 (ADD (Reg R14) (Reg R13)))
        (X86 (MOV (Reg R15) (Reg R13))) (X86 (MOV (Reg R14) (Reg R14)))
        (X86 (MOV (Reg R12) (Reg R12))) (X86 (SUB (Reg R12) (Imm 1)))
        (X86 (MOV (Reg R15) (Reg R15))) (X86 (MOV (Reg R13) (Reg R14)))
        (X86 (MOV (Reg R12) (Reg R12)))
        (X86_terminal
         ((JMP ((block ((id_hum fib_check) (args (a%0 count%0 b%0)))) (args ()))))))))
     (intermediate_fib_check_to_fib_exit (args ())
      (instrs ((X86 (JMP ((block ((id_hum fib_exit) (args ()))) (args ())))))))
     (fib_exit (args ()) (instrs ((X86_terminal ((RET (Reg R15))))))))
    |}]
;;

let%expect_test "sum 100" =
  test Examples.Textual.sum_100;
  [%expect
    {|
    ((start (args ())
      (instrs
       ((Move i (Lit 1)) (Move sum (Lit 0))
        (Branch
         (Cond (cond (Lit 1))
          (if_true ((block ((id_hum check) (args (sum%1 i%1)))) (args (sum i))))
          (if_false ((block ((id_hum exit) (args (sum%0 i%0)))) (args (sum i)))))))))
     (check (args (sum%1 i%1))
      (instrs
       ((Sub ((dest cond) (src1 (Var i%1)) (src2 (Lit 100))))
        (Branch
         (Cond (cond (Var cond))
          (if_true ((block ((id_hum body) (args ()))) (args ())))
          (if_false
           ((block ((id_hum exit) (args (sum%0 i%0)))) (args (sum%1 i%1)))))))))
     (body (args ())
      (instrs
       ((Add ((dest sum%2) (src1 (Var sum%1)) (src2 (Var i%1))))
        (Add ((dest i%2) (src1 (Var i%1)) (src2 (Lit 1))))
        (Branch
         (Cond (cond (Lit 1))
          (if_true
           ((block ((id_hum check) (args (sum%1 i%1)))) (args (sum%2 i%2))))
          (if_false
           ((block ((id_hum exit) (args (sum%0 i%0)))) (args (sum%2 i%2)))))))))
     (exit (args (sum%0 i%0)) (instrs ((Return (Var sum%0))))))
    ((start (args ())
      (instrs
       ((X86 (MOV (Reg R13) (Imm 1))) (X86 (MOV (Reg R13) (Imm 0)))
        (X86_terminal
         ((CMP (Imm 1) (Imm 0))
          (JNE
           ((block ((id_hum intermediate_start_to_check) (args (sum i))))
            (args ()))
           (((block ((id_hum intermediate_start_to_exit) (args (sum i))))
             (args ())))))))))
     (intermediate_start_to_check (args (sum i))
      (instrs
       ((X86 (MOV (Reg R15) (Reg R13))) (X86 (MOV (Reg R15) (Reg R13)))
        (X86 (JMP ((block ((id_hum check) (args (sum%1 i%1)))) (args ())))))))
     (check (args (sum%1 i%1))
      (instrs
       ((X86 (MOV (Reg R14) (Reg R15))) (X86 (SUB (Reg R14) (Imm 100)))
        (X86_terminal
         ((CMP (Reg R14) (Imm 0))
          (JNE
           ((block ((id_hum intermediate_check_to_body) (args ()))) (args ()))
           (((block ((id_hum intermediate_check_to_exit) (args (sum%1 i%1))))
             (args ())))))))))
     (intermediate_check_to_body (args ())
      (instrs ((X86 (JMP ((block ((id_hum body) (args ()))) (args ())))))))
     (body (args ())
      (instrs
       ((X86 (MOV (Reg R13) (Reg R15))) (X86 (ADD (Reg R13) (Reg R15)))
        (X86 (MOV (Reg R13) (Reg R15))) (X86 (ADD (Reg R13) (Imm 1)))
        (X86_terminal
         ((CMP (Imm 1) (Imm 0))
          (JNE
           ((block ((id_hum intermediate_body_to_check) (args (sum%2 i%2))))
            (args ()))
           (((block ((id_hum intermediate_body_to_exit) (args (sum%2 i%2))))
             (args ())))))))))
     (intermediate_body_to_check (args (sum%2 i%2))
      (instrs
       ((X86 (MOV (Reg R15) (Reg R13))) (X86 (MOV (Reg R15) (Reg R13)))
        (X86 (JMP ((block ((id_hum check) (args (sum%1 i%1)))) (args ())))))))
     (intermediate_body_to_exit (args (sum%2 i%2))
      (instrs
       ((X86 (MOV (Reg R14) (Reg R13))) (X86 (MOV (Reg R14) (Reg R13)))
        (X86 (JMP ((block ((id_hum exit) (args (sum%0 i%0)))) (args ())))))))
     (exit (args (sum%0 i%0)) (instrs ((X86_terminal ((RET (Reg R14)))))))
     (intermediate_check_to_exit (args (sum%1 i%1))
      (instrs
       ((X86 (MOV (Reg R14) (Reg R15))) (X86 (MOV (Reg R14) (Reg R15)))
        (X86 (JMP ((block ((id_hum exit) (args (sum%0 i%0)))) (args ())))))))
     (intermediate_start_to_exit (args (sum i))
      (instrs
       ((X86 (MOV (Reg R14) (Reg R13))) (X86 (MOV (Reg R14) (Reg R13)))
        (X86 (JMP ((block ((id_hum exit) (args (sum%0 i%0)))) (args ()))))))))
    |}]
;;
