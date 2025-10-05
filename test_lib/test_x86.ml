open! Core
open! Nod

let test s =
  match Eir.compile ~opt_flags:Eir.Opt_flags.no_opt s with
  | Error e -> Test_parser.print_error e
  | Ok root ->
    let x86 = X86_backend.compile root in
    Block.iter x86 ~f:(fun block ->
      let instrs = Vec.to_list block.instructions @ [ block.terminal ] in
      print_s
        [%message
          block.id_hum ~args:(block.args : string Vec.t) (instrs : Ir.t list)])
;;

let%expect_test "a" = print_s [%sexp ([| i for i = 1 to 10 |] : int array)]

let%expect_test "a" =
  test Examples.Textual.a;
  [%expect
    {|
    (a (args ())
     (instrs
      ((X86 (MOV (Reg (Unallocated x)) (Imm 10)))
       (X86 (MOV (Reg (Unallocated y)) (Imm 20)))
       (X86 (MOV (Reg (Unallocated z)) (Reg (Unallocated y))))
       (X86 (SUB (Reg (Unallocated z)) (Reg (Unallocated x))))
       (X86_terminal
        ((CMP (Imm 1) (Imm 0))
         (JNE ((block ((id_hum intermediate_a_to_b) (args ()))) (args ()))
          (((block ((id_hum intermediate_a_to_c) (args ()))) (args ())))))))))
    (intermediate_a_to_b (args ())
     (instrs ((X86 (JMP ((block ((id_hum b) (args ()))) (args ())))))))
    (b (args ())
     (instrs
      ((X86 (MOV (Reg (Unallocated z%2)) (Reg (Unallocated z))))
       (X86 (ADD (Reg (Unallocated z%2)) (Imm 5)))
       (X86_terminal
        ((CMP (Imm 1) (Imm 0))
         (JNE
          ((block ((id_hum intermediate_b_to_end0) (args (z%2)))) (args (z%2)))
          (((block ((id_hum intermediate_b_to_end) (args (z%2)))) (args (z%2))))))))))
    (intermediate_b_to_end0 (args (z%2))
     (instrs
      ((X86 (MOV (Reg (Unallocated z%0)) (Reg (Unallocated z%2))))
       (X86 (JMP ((block ((id_hum end) (args (z%0)))) (args (z%2))))))))
    (end (args (z%0)) (instrs ((X86_terminal ()))))
    (intermediate_b_to_end (args (z%2))
     (instrs
      ((X86 (MOV (Reg (Unallocated z%0)) (Reg (Unallocated z%2))))
       (X86 (JMP ((block ((id_hum end) (args (z%0)))) (args (z%2))))))))
    (intermediate_a_to_c (args ())
     (instrs ((X86 (JMP ((block ((id_hum c) (args ()))) (args ())))))))
    (c (args ())
     (instrs
      ((X86 (MOV (Reg (Unallocated z%1)) (Imm 0)))
       (X86_terminal
        ((CMP (Imm 1) (Imm 0))
         (JNE
          ((block ((id_hum intermediate_c_to_end0) (args (z%1)))) (args (z%1)))
          (((block ((id_hum intermediate_c_to_end) (args (z%1)))) (args (z%1))))))))))
    (intermediate_c_to_end0 (args (z%1))
     (instrs
      ((X86 (MOV (Reg (Unallocated z%0)) (Reg (Unallocated z%1))))
       (X86 (JMP ((block ((id_hum end) (args (z%0)))) (args (z%1))))))))
    (intermediate_c_to_end (args (z%1))
     (instrs
      ((X86 (MOV (Reg (Unallocated z%0)) (Reg (Unallocated z%1))))
       (X86 (JMP ((block ((id_hum end) (args (z%0)))) (args (z%1))))))))
    |}]
;;

(* let%expect_test "e2" = *)
(*   test Examples.Textual.e2; *)
(*   [%expect *)
(*     {| *)
       (*     ((LABEL start) (JMP ifFalse) (LABEL ifFalse) (MOV (Reg RAX) (Imm 20)) *)
       (*      (PAR_MOV (((Reg RAX) (Reg RAX)))) (JMP end) (LABEL end) *)
       (*      (MOV (Reg RAX) (Reg RAX)) (RET (Reg RAX))) |}] *)
(* ;; *)

(* let%expect_test "c2" = *)
(*   test Examples.Textual.c2; *)
(*   [%expect {| *)
(*     ((LABEL entry) (MOV (Reg RAX) (Imm 5)) (RET (Reg RAX))) |}] *)
(* ;; *)

(* let%expect_test "f" = *)
(*   test Examples.Textual.f; *)
(*   [%expect *)
(*     {| *)
(*     ((LABEL start) (MOV (Reg RAX) (Imm 0)) (MOV (Reg RBX) (Imm 0)) *)
(*      (PAR_MOV *)
(*       (((Reg Junk) (Reg Junk)) ((Reg Junk) (Reg Junk)) ((Reg RAX) (Reg RAX)))) *)
(*      (JMP outerCheck) (LABEL outerCheck) (MOV (Reg RSI) (Reg RAX)) *)
(*      (SUB (Reg RSI) (Imm 7)) (CMP (Reg RSI) (Imm 0)) (JNE outerBody ()) *)
(*      (JMP exit) (LABEL outerBody) (MOV (Reg RSI) (Imm 0)) (MOV (Reg RDI) (Imm 0)) *)
(*      (JMP innerCheck) (LABEL innerCheck) (JMP innerBody) (LABEL innerBody) *)
(*      (MOV (Reg R8) (Imm 0)) (AND (Reg R8) (Imm 1)) (MOV (Reg R8) (Reg R8)) *)
(*      (CMP (Reg R8) (Imm 0)) (JNE doWork ()) (JMP skipEven) (LABEL doWork) *)
(*      (MOV (Reg R8) (Imm 0)) (MUL (Reg R8) (Reg RAX)) (MOV (Reg Junk) (Reg R8)) *)
(*      (JMP innerCheck) (LABEL skipEven) (CMP (Imm 1) (Imm 0)) (JNE innerCheck ()) *)
(*      (JMP innerExit) (LABEL innerExit) (MOV (Reg Junk) (Imm 0)) (JMP outerInc) *)
(*      (LABEL outerInc) (MOV (Reg R8) (Imm 1)) (ADD (Reg R8) (Reg RAX)) *)
(*      (PAR_MOV (((Reg RDI) (Reg RDI)) ((Reg RSI) (Reg RSI)) ((Reg R8) (Reg R8)))) *)
(*      (JMP outerCheck) (LABEL exit) (MOV (Reg RAX) (Reg RBX)) (RET (Reg RAX))) |}] *)
(* ;; *)

let%expect_test "fib" =
  test Examples.Textual.fib;
  [%expect
    {|
    (%root (args ())
     (instrs
      ((X86 (MOV (Reg (Unallocated arg)) (Imm 10)))
       (X86_terminal ((JMP ((block ((id_hum fib_start) (args ()))) (args ()))))))))
    (fib_start (args ())
     (instrs
      ((X86 (MOV (Reg (Unallocated count)) (Reg (Unallocated arg))))
       (X86 (MOV (Reg (Unallocated a)) (Imm 0)))
       (X86 (MOV (Reg (Unallocated b)) (Imm 1)))
       (X86 (MOV (Reg (Unallocated a%0)) (Reg (Unallocated a))))
       (X86 (MOV (Reg (Unallocated b%0)) (Reg (Unallocated b))))
       (X86 (MOV (Reg (Unallocated count%0)) (Reg (Unallocated count))))
       (X86_terminal
        ((JMP
          ((block ((id_hum fib_check) (args (a%0 count%0 b%0))))
           (args (a count b)))))))))
    (fib_check (args (a%0 count%0 b%0))
     (instrs
      ((X86_terminal
        ((CMP (Reg (Unallocated count%0)) (Imm 0))
         (JNE
          ((block ((id_hum intermediate_fib_check_to_fib_body) (args ())))
           (args ()))
          (((block ((id_hum intermediate_fib_check_to_fib_exit) (args ())))
            (args ())))))))))
    (intermediate_fib_check_to_fib_body (args ())
     (instrs ((X86 (JMP ((block ((id_hum fib_body) (args ()))) (args ())))))))
    (fib_body (args ())
     (instrs
      ((X86 (MOV (Reg (Unallocated next)) (Reg (Unallocated a%0))))
       (X86 (ADD (Reg (Unallocated next)) (Reg (Unallocated b%0))))
       (X86 (MOV (Reg (Unallocated a%1)) (Reg (Unallocated b%0))))
       (X86 (MOV (Reg (Unallocated b%1)) (Reg (Unallocated next))))
       (X86 (MOV (Reg (Unallocated count%1)) (Reg (Unallocated count%0))))
       (X86 (SUB (Reg (Unallocated count%1)) (Imm 1)))
       (X86 (MOV (Reg (Unallocated a%0)) (Reg (Unallocated a%1))))
       (X86 (MOV (Reg (Unallocated b%0)) (Reg (Unallocated b%1))))
       (X86 (MOV (Reg (Unallocated count%0)) (Reg (Unallocated count%1))))
       (X86_terminal
        ((JMP
          ((block ((id_hum fib_check) (args (a%0 count%0 b%0))))
           (args (a%1 count%1 b%1)))))))))
    (intermediate_fib_check_to_fib_exit (args ())
     (instrs ((X86 (JMP ((block ((id_hum fib_exit) (args ()))) (args ())))))))
    (fib_exit (args ())
     (instrs ((X86_terminal ((RET (Reg (Unallocated a%0))))))))
    |}]
;;

(* let%expect_test "sum 100" = *)
(*   test Examples.Textual.sum_100; *)
(*   [%expect *)
(*     {| *)
(*     ((LABEL start) (MOV (Reg RAX) (Imm 1)) (MOV (Reg RBX) (Imm 0)) *)
(*      (PAR_MOV (((Reg RAX) (Reg RBX)) ((Reg RBX) (Reg RAX)))) (JMP check) *)
(*      (LABEL check) (MOV (Reg RCX) (Reg RBX)) (SUB (Reg RCX) (Imm 100)) *)
(*      (CMP (Reg RCX) (Imm 0)) (JNE body ()) (PAR_MOV (((Reg RCX) (Reg RAX)))) *)
(*      (JMP exit) (LABEL body) (MOV (Reg RAX) (Reg RAX)) (ADD (Reg RAX) (Reg RBX)) *)
(*      (PAR_MOV (((Reg RBX) (Reg RAX)) ((Reg RAX) (Reg Junk)))) (JMP check) *)
(*      (LABEL exit) (MOV (Reg RAX) (Reg RCX)) (RET (Reg RAX))) |}] *)
(* ;; *)
