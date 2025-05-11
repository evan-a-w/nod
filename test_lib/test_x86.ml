open! Core
open! Nod

let test s =
  match Eir.compile s with
  | Error e -> Test_parser.print_error e
  | Ok root ->
    let x86 = X86_codegen.compile_and_regalloc root in
    print_s [%sexp (x86 : (string, string) X86_ir.instr Vec.t)]
;;

let%expect_test "e2" =
  test Examples.Textual.e2;
  [%expect
    {|
    ((LABEL start) (JMP ifFalse) (LABEL ifFalse) (MOV (Reg RAX) (Imm 20))
     (PAR_MOV (((Reg RAX) (Reg RAX)))) (JMP end) (LABEL end)
     (MOV (Reg RAX) (Reg RAX)) (RET (Reg RAX))) |}]
;;

let%expect_test "c2" =
  test Examples.Textual.c2;
  [%expect
    {|
    ((LABEL entry) (MOV (Reg RAX) (Imm 5)) (RET (Reg RAX))) |}]
;;

let%expect_test "f" =
  test Examples.Textual.f;
  [%expect
    {|
    ((LABEL start) (MOV (Reg RAX) (Imm 0)) (MOV (Reg RBX) (Imm 0))
     (PAR_MOV
      (((Reg Junk) (Reg Junk)) ((Reg Junk) (Reg Junk)) ((Reg RAX) (Reg RAX))))
     (JMP outerCheck) (LABEL outerCheck) (MOV (Reg RSI) (Reg RAX))
     (SUB (Reg RSI) (Imm 7)) (CMP (Reg RSI) (Imm 0)) (JNE outerBody ())
     (JMP exit) (LABEL outerBody) (MOV (Reg RSI) (Imm 0)) (MOV (Reg RDI) (Imm 0))
     (JMP innerCheck) (LABEL innerCheck) (JMP innerBody) (LABEL innerBody)
     (MOV (Reg R8) (Imm 0)) (AND (Reg R8) (Imm 1)) (MOV (Reg R8) (Reg R8))
     (CMP (Reg R8) (Imm 0)) (JNE doWork ()) (JMP skipEven) (LABEL doWork)
     (MOV (Reg R8) (Imm 0)) (MUL (Reg R8) (Reg RAX)) (MOV (Reg Junk) (Reg R8))
     (JMP innerCheck) (LABEL skipEven) (CMP (Imm 1) (Imm 0)) (JNE innerCheck ())
     (JMP innerExit) (LABEL innerExit) (MOV (Reg Junk) (Imm 0)) (JMP outerInc)
     (LABEL outerInc) (MOV (Reg R8) (Imm 1)) (ADD (Reg R8) (Reg RAX))
     (PAR_MOV (((Reg RDI) (Reg RDI)) ((Reg RSI) (Reg RSI)) ((Reg R8) (Reg R8))))
     (JMP outerCheck) (LABEL exit) (MOV (Reg RAX) (Reg RBX)) (RET (Reg RAX))) |}]
;;

let%expect_test "fib" =
  test Examples.Textual.fib;
  [%expect
    {|
    ((LABEL %root) (JMP fib_start) (LABEL fib_start) (MOV (Reg RAX) (Imm 10))
     (MOV (Reg RBX) (Imm 0)) (MOV (Reg RCX) (Imm 1))
     (PAR_MOV
      (((Reg RAX) (Reg RBX)) ((Reg RBX) (Reg RAX)) ((Reg RCX) (Reg RCX))))
     (JMP fib_check) (LABEL fib_check) (CMP (Reg RBX) (Imm 0)) (JNE fib_body ())
     (JMP fib_exit) (LABEL fib_body) (MOV (Reg RAX) (Reg RAX))
     (ADD (Reg RAX) (Reg RCX)) (MOV (Reg RCX) (Reg RCX))
     (MOV (Reg RAX) (Reg RAX)) (MOV (Reg RBX) (Reg RBX)) (SUB (Reg RBX) (Imm 1))
     (PAR_MOV
      (((Reg RBX) (Reg RCX)) ((Reg RCX) (Reg RBX)) ((Reg RAX) (Reg RAX))))
     (JMP fib_check) (LABEL fib_exit) (MOV (Reg RAX) (Reg RBX)) (RET (Reg RAX))) |}]
;;

let%expect_test "sum 100" =
  test Examples.Textual.sum_100;
  [%expect
    {|
    ((LABEL start) (MOV (Reg RAX) (Imm 1)) (MOV (Reg RBX) (Imm 0))
     (PAR_MOV (((Reg RAX) (Reg RBX)) ((Reg RBX) (Reg RAX)))) (JMP check)
     (LABEL check) (MOV (Reg RCX) (Reg RBX)) (SUB (Reg RCX) (Imm 100))
     (CMP (Reg RCX) (Imm 0)) (JNE body ()) (PAR_MOV (((Reg RCX) (Reg RAX))))
     (JMP exit) (LABEL body) (MOV (Reg RAX) (Reg RAX)) (ADD (Reg RAX) (Reg RBX))
     (PAR_MOV (((Reg RBX) (Reg RAX)) ((Reg RAX) (Reg Junk)))) (JMP check)
     (LABEL exit) (MOV (Reg RAX) (Reg RCX)) (RET (Reg RAX))) |}]
;;

(*
   RAX = 1
   RBX = 0

   RAX = 0
   RBX = 1

   RCX=  1
   RCX = -99

   RAX = 0
   RAX = 1
   RBX = 1
   RAX = Junk
   this point is the crux i think
*)
