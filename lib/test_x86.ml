open! Core

let test s =
  match Eir.compile s with
  | Error e -> Test_parser.print_error e
  | Ok root ->
    let x86 = X86_codegen.compile_and_regalloc root in
    print_s [%sexp (x86 : (string, string) X86_ir.instr Vec.t)]
;;

let%expect_test "e2" = test Examples.Textual.e2
