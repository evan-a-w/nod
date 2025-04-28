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
