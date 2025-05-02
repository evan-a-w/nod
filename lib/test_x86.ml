open! Core

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
      (((Reg Junk) (Reg Junk)) ((Reg Junk) (Reg Junk)) ((Reg Junk) (Reg Junk))
       ((Reg RCX) (Reg RAX))))
     (JMP outerCheck) (LABEL outerCheck) (MOV (Reg RDI) (Reg RCX))
     (SUB (Reg RDI) (Imm 7)) (CMP (Reg RDI) (Imm 0)) (JNE outerBody ())
     (JMP exit) (LABEL outerBody) (MOV (Reg R8) (Imm 0)) (MOV (Reg R9) (Imm 0))
     (PAR_MOV
      (((Reg Junk) (Reg Junk)) ((Reg Junk) (Reg Junk)) ((Reg Junk) (Reg Junk))
       ((Reg Junk) (Reg Junk))))
     (JMP innerCheck) (LABEL innerCheck) (MOV (Reg R14) (Imm -3)) (JMP innerBody)
     (LABEL innerBody) (MOV (Reg R15) (Imm 0)) (AND (Reg R15) (Imm 1))
     (MOV (Mem RSP 0) (Reg R15)) (CMP (Mem RSP 0) (Imm 0)) (JNE doWork ())
     (JMP skipEven) (LABEL doWork) (MOV (Reg Junk) (Imm 0))
     (MUL (Reg Junk) (Reg RCX)) (MOV (Reg Junk) (Reg Junk))
     (MOV (Reg Junk) (Imm 1)) (CMP (Imm 1) (Imm 0)) (JE innerExit ())
     (PAR_MOV
      (((Mem RSP 0) (Mem RSP 0)) ((Reg R14) (Reg R14)) ((Reg Junk) (Reg Junk))
       ((Reg R15) (Reg R15))))
     (JMP innerCheck) (LABEL innerExit) (MOV (Reg Junk) (Imm 0)) (JMP outerInc)
     (LABEL outerInc) (MOV (Mem RSP -2) (Imm 1)) (ADD (Mem RSP -2) (Reg RCX))
     (PAR_MOV
      (((Reg R9) (Reg R9)) ((Reg R8) (Reg R8)) ((Reg RDI) (Reg RDI))
       ((Reg RCX) (Mem RSP -2))))
     (JMP outerCheck) (LABEL skipEven) (MOV (Reg Junk) (Imm 1))
     (CMP (Imm 1) (Imm 0)) (JE innerExit ())
     (PAR_MOV
      (((Mem RSP 0) (Mem RSP 0)) ((Reg R14) (Reg R14)) ((Mem RSP -2) (Reg Junk))
       ((Reg R15) (Reg R15))))
     (JMP innerCheck) (LABEL exit) (MOV (Reg RAX) (Reg RBX))
     (SUB (Reg RSP) (Imm 4)) (RET (Reg RAX))) |}]
;;

let%expect_test "f" = test Examples.Textual.fib;
  [%expect {|
    ((LABEL %root) (JMP fib_start) (LABEL fib_start) (MOV (Reg RAX) (Imm 0))
     (MOV (Reg RBX) (Imm 1))
     (PAR_MOV
      (((Reg Junk) (Reg RAX)) ((Reg Junk) (Reg Junk)) ((Reg RAX) (Reg RBX))))
     (JMP fib_check) (LABEL fib_check) (JMP fib_body) (LABEL fib_body)
     (MOV (Reg RDX) (Reg RAX)) (MOV (Reg RAX) (Reg RAX))
     (MOV (Reg RSI) (Reg RDX))
     (PAR_MOV
      (((Reg RSI) (Reg RAX)) ((Reg RDX) (Reg RDX)) ((Reg RAX) (Reg RSI))))
     (JMP fib_check)) |}]
