open! Core
open! Import

let map_function_roots ~f functions =
  Map.map ~f:(Function.map_root ~f) functions
;;

let test_cfg s =
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

let test_ssa ?don't_opt s =
  test_cfg s;
  print_endline "=================================";
  Parser.parse_string s
  |> Result.map ~f:(map_function_roots ~f:Cfg.process)
  |> Result.map ~f:Eir.set_entry_block_args
  |> Result.map ~f:(map_function_roots ~f:Ssa.create)
  |> function
  | Error e -> Nod_error.to_string e |> print_endline
  | Ok fns ->
    let go fns =
      Map.iter fns ~f:(fun { Function.root = (ssa : Ssa.t); _ } ->
        Vec.iter ssa.in_order ~f:(fun block ->
          let instrs = Vec.to_list block.instructions @ [ block.terminal ] in
          print_s
            [%message
              block.id_hum ~args:(block.args : Var.t Vec.t) (instrs : Ir.t list)]))
    in
    go fns;
    (match don't_opt with
     | Some () -> ()
     | None ->
       print_endline "******************************";
       Eir.optimize fns;
       go fns)
;;

let compile_and_lower ?(opt_flags = Eir.Opt_flags.no_opt) program =
  match Nod.compile ~opt_flags program with
  | Error e -> Nod_error.to_string e |> print_endline
  | Ok functions ->
    let asm = X86_backend.compile_to_asm functions in
    print_endline asm
;;

let borked = Examples.Textual.regalloc_hard

let%expect_test "run" =
  let output = compile_and_execute ~opt_flags:Eir.Opt_flags.no_opt borked in
  print_endline output;
  [%expect
    {| 91 |}]
;;

let%expect_test "borked regaloc" =
  match Nod.compile ~opt_flags:Eir.Opt_flags.no_opt borked with
  | Error e -> Nod_error.to_string e |> print_endline
  | Ok functions ->
    X86_backend.For_testing.print_assignments functions;
    [%expect
      {|
      ((function_name root)
       (assignments
        ((((name a) (type_ I64)) (Reg ((reg R10) (class_ I64))))
         (((name b) (type_ I64)) (Reg ((reg R15) (class_ I64))))
         (((name c) (type_ I64)) (Reg ((reg R12) (class_ I64))))
         (((name d) (type_ I64)) (Reg ((reg R13) (class_ I64))))
         (((name e) (type_ I64)) (Reg ((reg R11) (class_ I64))))
         (((name f) (type_ I64)) (Reg ((reg R14) (class_ I64))))
         (((name g) (type_ I64)) (Reg ((reg RBX) (class_ I64))))
         (((name h) (type_ I64)) Spill)
         (((name i) (type_ I64)) (Reg ((reg RAX) (class_ I64))))
         (((name j) (type_ I64)) (Reg ((reg RCX) (class_ I64))))
         (((name k) (type_ I64)) (Reg ((reg RDX) (class_ I64))))
         (((name l) (type_ I64)) (Reg ((reg R8) (class_ I64))))
         (((name m) (type_ I64)) (Reg ((reg R9) (class_ I64))))
         (((name res__0) (type_ I64)) (Reg ((reg RAX) (class_ I64))))
         (((name s1) (type_ I64)) (Reg ((reg R10) (class_ I64))))
         (((name s10) (type_ I64)) (Reg ((reg R15) (class_ I64))))
         (((name s11) (type_ I64)) (Reg ((reg R15) (class_ I64))))
         (((name s12) (type_ I64)) (Reg ((reg R15) (class_ I64))))
         (((name s2) (type_ I64)) (Reg ((reg R15) (class_ I64))))
         (((name s3) (type_ I64)) (Reg ((reg R15) (class_ I64))))
         (((name s4) (type_ I64)) (Reg ((reg R15) (class_ I64))))
         (((name s5) (type_ I64)) (Reg ((reg R15) (class_ I64))))
         (((name s6) (type_ I64)) (Reg ((reg R15) (class_ I64))))
         (((name s7) (type_ I64)) (Reg ((reg R15) (class_ I64))))
         (((name s8) (type_ I64)) (Reg ((reg R15) (class_ I64))))
         (((name s9) (type_ I64)) (Reg ((reg R15) (class_ I64)))))))
      ((((name a) (type_ I64)) ((name b) (type_ I64)))
       (((name a) (type_ I64)) ((name c) (type_ I64)))
       (((name a) (type_ I64)) ((name d) (type_ I64)))
       (((name a) (type_ I64)) ((name e) (type_ I64)))
       (((name a) (type_ I64)) ((name f) (type_ I64)))
       (((name a) (type_ I64)) ((name g) (type_ I64)))
       (((name a) (type_ I64)) ((name h) (type_ I64)))
       (((name a) (type_ I64)) ((name i) (type_ I64)))
       (((name a) (type_ I64)) ((name j) (type_ I64)))
       (((name a) (type_ I64)) ((name k) (type_ I64)))
       (((name a) (type_ I64)) ((name l) (type_ I64)))
       (((name a) (type_ I64)) ((name m) (type_ I64)))
       (((name b) (type_ I64)) ((name c) (type_ I64)))
       (((name b) (type_ I64)) ((name d) (type_ I64)))
       (((name b) (type_ I64)) ((name e) (type_ I64)))
       (((name b) (type_ I64)) ((name f) (type_ I64)))
       (((name b) (type_ I64)) ((name g) (type_ I64)))
       (((name b) (type_ I64)) ((name h) (type_ I64)))
       (((name b) (type_ I64)) ((name i) (type_ I64)))
       (((name b) (type_ I64)) ((name j) (type_ I64)))
       (((name b) (type_ I64)) ((name k) (type_ I64)))
       (((name b) (type_ I64)) ((name l) (type_ I64)))
       (((name b) (type_ I64)) ((name m) (type_ I64)))
       (((name b) (type_ I64)) ((name s1) (type_ I64)))
       (((name c) (type_ I64)) ((name d) (type_ I64)))
       (((name c) (type_ I64)) ((name e) (type_ I64)))
       (((name c) (type_ I64)) ((name f) (type_ I64)))
       (((name c) (type_ I64)) ((name g) (type_ I64)))
       (((name c) (type_ I64)) ((name h) (type_ I64)))
       (((name c) (type_ I64)) ((name i) (type_ I64)))
       (((name c) (type_ I64)) ((name j) (type_ I64)))
       (((name c) (type_ I64)) ((name k) (type_ I64)))
       (((name c) (type_ I64)) ((name l) (type_ I64)))
       (((name c) (type_ I64)) ((name m) (type_ I64)))
       (((name c) (type_ I64)) ((name s1) (type_ I64)))
       (((name c) (type_ I64)) ((name s2) (type_ I64)))
       (((name d) (type_ I64)) ((name e) (type_ I64)))
       (((name d) (type_ I64)) ((name f) (type_ I64)))
       (((name d) (type_ I64)) ((name g) (type_ I64)))
       (((name d) (type_ I64)) ((name h) (type_ I64)))
       (((name d) (type_ I64)) ((name i) (type_ I64)))
       (((name d) (type_ I64)) ((name j) (type_ I64)))
       (((name d) (type_ I64)) ((name k) (type_ I64)))
       (((name d) (type_ I64)) ((name l) (type_ I64)))
       (((name d) (type_ I64)) ((name m) (type_ I64)))
       (((name d) (type_ I64)) ((name s1) (type_ I64)))
       (((name d) (type_ I64)) ((name s2) (type_ I64)))
       (((name d) (type_ I64)) ((name s3) (type_ I64)))
       (((name e) (type_ I64)) ((name f) (type_ I64)))
       (((name e) (type_ I64)) ((name g) (type_ I64)))
       (((name e) (type_ I64)) ((name h) (type_ I64)))
       (((name e) (type_ I64)) ((name i) (type_ I64)))
       (((name e) (type_ I64)) ((name j) (type_ I64)))
       (((name e) (type_ I64)) ((name k) (type_ I64)))
       (((name e) (type_ I64)) ((name l) (type_ I64)))
       (((name e) (type_ I64)) ((name m) (type_ I64)))
       (((name e) (type_ I64)) ((name s1) (type_ I64)))
       (((name e) (type_ I64)) ((name s2) (type_ I64)))
       (((name e) (type_ I64)) ((name s3) (type_ I64)))
       (((name e) (type_ I64)) ((name s4) (type_ I64)))
       (((name f) (type_ I64)) ((name g) (type_ I64)))
       (((name f) (type_ I64)) ((name h) (type_ I64)))
       (((name f) (type_ I64)) ((name i) (type_ I64)))
       (((name f) (type_ I64)) ((name j) (type_ I64)))
       (((name f) (type_ I64)) ((name k) (type_ I64)))
       (((name f) (type_ I64)) ((name l) (type_ I64)))
       (((name f) (type_ I64)) ((name m) (type_ I64)))
       (((name f) (type_ I64)) ((name s1) (type_ I64)))
       (((name f) (type_ I64)) ((name s2) (type_ I64)))
       (((name f) (type_ I64)) ((name s3) (type_ I64)))
       (((name f) (type_ I64)) ((name s4) (type_ I64)))
       (((name f) (type_ I64)) ((name s5) (type_ I64)))
       (((name g) (type_ I64)) ((name h) (type_ I64)))
       (((name g) (type_ I64)) ((name i) (type_ I64)))
       (((name g) (type_ I64)) ((name j) (type_ I64)))
       (((name g) (type_ I64)) ((name k) (type_ I64)))
       (((name g) (type_ I64)) ((name l) (type_ I64)))
       (((name g) (type_ I64)) ((name m) (type_ I64)))
       (((name g) (type_ I64)) ((name s1) (type_ I64)))
       (((name g) (type_ I64)) ((name s2) (type_ I64)))
       (((name g) (type_ I64)) ((name s3) (type_ I64)))
       (((name g) (type_ I64)) ((name s4) (type_ I64)))
       (((name g) (type_ I64)) ((name s5) (type_ I64)))
       (((name g) (type_ I64)) ((name s6) (type_ I64)))
       (((name h) (type_ I64)) ((name i) (type_ I64)))
       (((name h) (type_ I64)) ((name j) (type_ I64)))
       (((name h) (type_ I64)) ((name k) (type_ I64)))
       (((name h) (type_ I64)) ((name l) (type_ I64)))
       (((name h) (type_ I64)) ((name m) (type_ I64)))
       (((name h) (type_ I64)) ((name s1) (type_ I64)))
       (((name h) (type_ I64)) ((name s2) (type_ I64)))
       (((name h) (type_ I64)) ((name s3) (type_ I64)))
       (((name h) (type_ I64)) ((name s4) (type_ I64)))
       (((name h) (type_ I64)) ((name s5) (type_ I64)))
       (((name h) (type_ I64)) ((name s6) (type_ I64)))
       (((name h) (type_ I64)) ((name s7) (type_ I64)))
       (((name i) (type_ I64)) ((name j) (type_ I64)))
       (((name i) (type_ I64)) ((name k) (type_ I64)))
       (((name i) (type_ I64)) ((name l) (type_ I64)))
       (((name i) (type_ I64)) ((name m) (type_ I64)))
       (((name i) (type_ I64)) ((name s1) (type_ I64)))
       (((name i) (type_ I64)) ((name s2) (type_ I64)))
       (((name i) (type_ I64)) ((name s3) (type_ I64)))
       (((name i) (type_ I64)) ((name s4) (type_ I64)))
       (((name i) (type_ I64)) ((name s5) (type_ I64)))
       (((name i) (type_ I64)) ((name s6) (type_ I64)))
       (((name i) (type_ I64)) ((name s7) (type_ I64)))
       (((name i) (type_ I64)) ((name s8) (type_ I64)))
       (((name j) (type_ I64)) ((name k) (type_ I64)))
       (((name j) (type_ I64)) ((name l) (type_ I64)))
       (((name j) (type_ I64)) ((name m) (type_ I64)))
       (((name j) (type_ I64)) ((name s1) (type_ I64)))
       (((name j) (type_ I64)) ((name s2) (type_ I64)))
       (((name j) (type_ I64)) ((name s3) (type_ I64)))
       (((name j) (type_ I64)) ((name s4) (type_ I64)))
       (((name j) (type_ I64)) ((name s5) (type_ I64)))
       (((name j) (type_ I64)) ((name s6) (type_ I64)))
       (((name j) (type_ I64)) ((name s7) (type_ I64)))
       (((name j) (type_ I64)) ((name s8) (type_ I64)))
       (((name j) (type_ I64)) ((name s9) (type_ I64)))
       (((name k) (type_ I64)) ((name l) (type_ I64)))
       (((name k) (type_ I64)) ((name m) (type_ I64)))
       (((name k) (type_ I64)) ((name s1) (type_ I64)))
       (((name k) (type_ I64)) ((name s2) (type_ I64)))
       (((name k) (type_ I64)) ((name s3) (type_ I64)))
       (((name k) (type_ I64)) ((name s4) (type_ I64)))
       (((name k) (type_ I64)) ((name s5) (type_ I64)))
       (((name k) (type_ I64)) ((name s6) (type_ I64)))
       (((name k) (type_ I64)) ((name s7) (type_ I64)))
       (((name k) (type_ I64)) ((name s8) (type_ I64)))
       (((name k) (type_ I64)) ((name s9) (type_ I64)))
       (((name k) (type_ I64)) ((name s10) (type_ I64)))
       (((name l) (type_ I64)) ((name m) (type_ I64)))
       (((name l) (type_ I64)) ((name s1) (type_ I64)))
       (((name l) (type_ I64)) ((name s2) (type_ I64)))
       (((name l) (type_ I64)) ((name s3) (type_ I64)))
       (((name l) (type_ I64)) ((name s4) (type_ I64)))
       (((name l) (type_ I64)) ((name s5) (type_ I64)))
       (((name l) (type_ I64)) ((name s6) (type_ I64)))
       (((name l) (type_ I64)) ((name s7) (type_ I64)))
       (((name l) (type_ I64)) ((name s8) (type_ I64)))
       (((name l) (type_ I64)) ((name s9) (type_ I64)))
       (((name l) (type_ I64)) ((name s10) (type_ I64)))
       (((name l) (type_ I64)) ((name s11) (type_ I64)))
       (((name m) (type_ I64)) ((name s1) (type_ I64)))
       (((name m) (type_ I64)) ((name s2) (type_ I64)))
       (((name m) (type_ I64)) ((name s3) (type_ I64)))
       (((name m) (type_ I64)) ((name s4) (type_ I64)))
       (((name m) (type_ I64)) ((name s5) (type_ I64)))
       (((name m) (type_ I64)) ((name s6) (type_ I64)))
       (((name m) (type_ I64)) ((name s7) (type_ I64)))
       (((name m) (type_ I64)) ((name s8) (type_ I64)))
       (((name m) (type_ I64)) ((name s9) (type_ I64)))
       (((name m) (type_ I64)) ((name s10) (type_ I64)))
       (((name m) (type_ I64)) ((name s11) (type_ I64)))
       (((name m) (type_ I64)) ((name s12) (type_ I64))))
      |}]
;;

let%expect_test "borked" =
  compile_and_lower ~opt_flags:Eir.Opt_flags.no_opt borked;
  [%expect
    {|
    .intel_syntax noprefix
    .text
    .globl root
    root:
      sub rsp, 8
      push rbp
      push rbx
      push r12
      push r13
      push r14
      push r15
      mov rbp, rsp
      add rbp, 56
    root___root:
      mov r10, 1
      mov r15, 2
      mov r12, 3
      mov r13, 4
      mov r11, 5
      mov r14, 6
      mov rbx, 7
      mov qword ptr [rbp + 8], 8
      mov rax, 9
      mov rcx, 10
      mov rdx, 11
      mov r8, 12
      mov r9, 13
      add r10, r15
      mov r15, r10
      add r15, r12
      add r15, r13
      add r15, r11
      add r15, r14
      add r15, rbx
      add r15, [rbp + 8]
      add r15, rax
      add r15, rcx
      add r15, rdx
      add r15, r8
      add r15, r9
      mov rax, r15
    root__root__epilogue:
      mov rsp, rbp
      sub rsp, 56
      pop r15
      pop r14
      pop r13
      pop r12
      pop rbx
      pop rbp
      add rsp, 8
      ret
    .section .note.GNU-stack,"",@progbits
    |}]
;;

let%expect_test "debug borked opt ssa" =
  test_ssa ~don't_opt:() borked;
  [%expect
    {|
    (%root
     (instrs
      ((Move ((name a) (type_ I64)) (Lit 1))
       (Move ((name b) (type_ I64)) (Lit 2))
       (Move ((name c) (type_ I64)) (Lit 3))
       (Move ((name d) (type_ I64)) (Lit 4))
       (Move ((name e) (type_ I64)) (Lit 5))
       (Move ((name f) (type_ I64)) (Lit 6))
       (Move ((name g) (type_ I64)) (Lit 7))
       (Move ((name h) (type_ I64)) (Lit 8))
       (Move ((name i) (type_ I64)) (Lit 9))
       (Move ((name j) (type_ I64)) (Lit 10))
       (Move ((name k) (type_ I64)) (Lit 11))
       (Move ((name l) (type_ I64)) (Lit 12))
       (Move ((name m) (type_ I64)) (Lit 13))
       (Add
        ((dest ((name s1) (type_ I64))) (src1 (Var ((name a) (type_ I64))))
         (src2 (Var ((name b) (type_ I64))))))
       (Add
        ((dest ((name s2) (type_ I64))) (src1 (Var ((name s1) (type_ I64))))
         (src2 (Var ((name c) (type_ I64))))))
       (Add
        ((dest ((name s3) (type_ I64))) (src1 (Var ((name s2) (type_ I64))))
         (src2 (Var ((name d) (type_ I64))))))
       (Add
        ((dest ((name s4) (type_ I64))) (src1 (Var ((name s3) (type_ I64))))
         (src2 (Var ((name e) (type_ I64))))))
       (Add
        ((dest ((name s5) (type_ I64))) (src1 (Var ((name s4) (type_ I64))))
         (src2 (Var ((name f) (type_ I64))))))
       (Add
        ((dest ((name s6) (type_ I64))) (src1 (Var ((name s5) (type_ I64))))
         (src2 (Var ((name g) (type_ I64))))))
       (Add
        ((dest ((name s7) (type_ I64))) (src1 (Var ((name s6) (type_ I64))))
         (src2 (Var ((name h) (type_ I64))))))
       (Add
        ((dest ((name s8) (type_ I64))) (src1 (Var ((name s7) (type_ I64))))
         (src2 (Var ((name i) (type_ I64))))))
       (Add
        ((dest ((name s9) (type_ I64))) (src1 (Var ((name s8) (type_ I64))))
         (src2 (Var ((name j) (type_ I64))))))
       (Add
        ((dest ((name s10) (type_ I64))) (src1 (Var ((name s9) (type_ I64))))
         (src2 (Var ((name k) (type_ I64))))))
       (Add
        ((dest ((name s11) (type_ I64))) (src1 (Var ((name s10) (type_ I64))))
         (src2 (Var ((name l) (type_ I64))))))
       (Add
        ((dest ((name s12) (type_ I64))) (src1 (Var ((name s11) (type_ I64))))
         (src2 (Var ((name m) (type_ I64))))))
       (Return (Var ((name s12) (type_ I64)))))))
    =================================
    (%root (args ())
     (instrs
      ((Move ((name a) (type_ I64)) (Lit 1))
       (Move ((name b) (type_ I64)) (Lit 2))
       (Move ((name c) (type_ I64)) (Lit 3))
       (Move ((name d) (type_ I64)) (Lit 4))
       (Move ((name e) (type_ I64)) (Lit 5))
       (Move ((name f) (type_ I64)) (Lit 6))
       (Move ((name g) (type_ I64)) (Lit 7))
       (Move ((name h) (type_ I64)) (Lit 8))
       (Move ((name i) (type_ I64)) (Lit 9))
       (Move ((name j) (type_ I64)) (Lit 10))
       (Move ((name k) (type_ I64)) (Lit 11))
       (Move ((name l) (type_ I64)) (Lit 12))
       (Move ((name m) (type_ I64)) (Lit 13))
       (Add
        ((dest ((name s1) (type_ I64))) (src1 (Var ((name a) (type_ I64))))
         (src2 (Var ((name b) (type_ I64))))))
       (Add
        ((dest ((name s2) (type_ I64))) (src1 (Var ((name s1) (type_ I64))))
         (src2 (Var ((name c) (type_ I64))))))
       (Add
        ((dest ((name s3) (type_ I64))) (src1 (Var ((name s2) (type_ I64))))
         (src2 (Var ((name d) (type_ I64))))))
       (Add
        ((dest ((name s4) (type_ I64))) (src1 (Var ((name s3) (type_ I64))))
         (src2 (Var ((name e) (type_ I64))))))
       (Add
        ((dest ((name s5) (type_ I64))) (src1 (Var ((name s4) (type_ I64))))
         (src2 (Var ((name f) (type_ I64))))))
       (Add
        ((dest ((name s6) (type_ I64))) (src1 (Var ((name s5) (type_ I64))))
         (src2 (Var ((name g) (type_ I64))))))
       (Add
        ((dest ((name s7) (type_ I64))) (src1 (Var ((name s6) (type_ I64))))
         (src2 (Var ((name h) (type_ I64))))))
       (Add
        ((dest ((name s8) (type_ I64))) (src1 (Var ((name s7) (type_ I64))))
         (src2 (Var ((name i) (type_ I64))))))
       (Add
        ((dest ((name s9) (type_ I64))) (src1 (Var ((name s8) (type_ I64))))
         (src2 (Var ((name j) (type_ I64))))))
       (Add
        ((dest ((name s10) (type_ I64))) (src1 (Var ((name s9) (type_ I64))))
         (src2 (Var ((name k) (type_ I64))))))
       (Add
        ((dest ((name s11) (type_ I64))) (src1 (Var ((name s10) (type_ I64))))
         (src2 (Var ((name l) (type_ I64))))))
       (Add
        ((dest ((name s12) (type_ I64))) (src1 (Var ((name s11) (type_ I64))))
         (src2 (Var ((name m) (type_ I64))))))
       (Return (Var ((name s12) (type_ I64)))))))
    |}]
;;

let%expect_test "debug borked" =
  match Nod.compile ~opt_flags:Eir.Opt_flags.no_opt borked with
  | Error e -> Nod_error.to_string e |> print_endline
  | Ok functions ->
    X86_backend.For_testing.print_selected_instructions functions;
    [%expect
      {|
      +----------------+---------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | block          | instruction                                                                                                                           | live_in                                                                                                                                                                                                                                                                              | live_out                                                                                                                                                                                                                                                                             |
      +----------------+---------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | root__prologue | (block start(args()))                                                                                                                 | {}                                                                                                                                                                                                                                                                                   | {}                                                                                                                                                                                                                                                                                   |
      +----------------+---------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | root__prologue | (X86(Tag_def NOOP(Reg((reg RBP)(class_ I64)))))                                                                                       | {}                                                                                                                                                                                                                                                                                   | {}                                                                                                                                                                                                                                                                                   |
      +----------------+---------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | root__prologue | (X86(JMP((block((id_hum %root)(args())))(args()))))                                                                                   | {}                                                                                                                                                                                                                                                                                   | {}                                                                                                                                                                                                                                                                                   |
      +----------------+---------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | root__prologue | block end                                                                                                                             | {}                                                                                                                                                                                                                                                                                   | {}                                                                                                                                                                                                                                                                                   |
      +----------------+---------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (block start(args()))                                                                                                                 | {}                                                                                                                                                                                                                                                                                   | {}                                                                                                                                                                                                                                                                                   |
      +----------------+---------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(MOV(Reg((reg(Unallocated((name a)(type_ I64))))(class_ I64)))(Imm 1)))                                                           | {}                                                                                                                                                                                                                                                                                   | (((name a)(type_ I64)))                                                                                                                                                                                                                                                              |
      +----------------+---------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(MOV(Reg((reg(Unallocated((name b)(type_ I64))))(class_ I64)))(Imm 2)))                                                           | (((name a)(type_ I64)))                                                                                                                                                                                                                                                              | (((name a)(type_ I64))((name b)(type_ I64)))                                                                                                                                                                                                                                         |
      +----------------+---------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(MOV(Reg((reg(Unallocated((name c)(type_ I64))))(class_ I64)))(Imm 3)))                                                           | (((name a)(type_ I64))((name b)(type_ I64)))                                                                                                                                                                                                                                         | (((name a)(type_ I64))((name b)(type_ I64))((name c)(type_ I64)))                                                                                                                                                                                                                    |
      +----------------+---------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(MOV(Reg((reg(Unallocated((name d)(type_ I64))))(class_ I64)))(Imm 4)))                                                           | (((name a)(type_ I64))((name b)(type_ I64))((name c)(type_ I64)))                                                                                                                                                                                                                    | (((name a)(type_ I64))((name b)(type_ I64))((name c)(type_ I64))((name d)(type_ I64)))                                                                                                                                                                                               |
      +----------------+---------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(MOV(Reg((reg(Unallocated((name e)(type_ I64))))(class_ I64)))(Imm 5)))                                                           | (((name a)(type_ I64))((name b)(type_ I64))((name c)(type_ I64))((name d)(type_ I64)))                                                                                                                                                                                               | (((name a)(type_ I64))((name b)(type_ I64))((name c)(type_ I64))((name d)(type_ I64))((name e)(type_ I64)))                                                                                                                                                                          |
      +----------------+---------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(MOV(Reg((reg(Unallocated((name f)(type_ I64))))(class_ I64)))(Imm 6)))                                                           | (((name a)(type_ I64))((name b)(type_ I64))((name c)(type_ I64))((name d)(type_ I64))((name e)(type_ I64)))                                                                                                                                                                          | (((name a)(type_ I64))((name b)(type_ I64))((name c)(type_ I64))((name d)(type_ I64))((name e)(type_ I64))((name f)(type_ I64)))                                                                                                                                                     |
      +----------------+---------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(MOV(Reg((reg(Unallocated((name g)(type_ I64))))(class_ I64)))(Imm 7)))                                                           | (((name a)(type_ I64))((name b)(type_ I64))((name c)(type_ I64))((name d)(type_ I64))((name e)(type_ I64))((name f)(type_ I64)))                                                                                                                                                     | (((name a)(type_ I64))((name b)(type_ I64))((name c)(type_ I64))((name d)(type_ I64))((name e)(type_ I64))((name f)(type_ I64))((name g)(type_ I64)))                                                                                                                                |
      +----------------+---------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(MOV(Reg((reg(Unallocated((name h)(type_ I64))))(class_ I64)))(Imm 8)))                                                           | (((name a)(type_ I64))((name b)(type_ I64))((name c)(type_ I64))((name d)(type_ I64))((name e)(type_ I64))((name f)(type_ I64))((name g)(type_ I64)))                                                                                                                                | (((name a)(type_ I64))((name b)(type_ I64))((name c)(type_ I64))((name d)(type_ I64))((name e)(type_ I64))((name f)(type_ I64))((name g)(type_ I64))((name h)(type_ I64)))                                                                                                           |
      +----------------+---------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(MOV(Reg((reg(Unallocated((name i)(type_ I64))))(class_ I64)))(Imm 9)))                                                           | (((name a)(type_ I64))((name b)(type_ I64))((name c)(type_ I64))((name d)(type_ I64))((name e)(type_ I64))((name f)(type_ I64))((name g)(type_ I64))((name h)(type_ I64)))                                                                                                           | (((name a)(type_ I64))((name b)(type_ I64))((name c)(type_ I64))((name d)(type_ I64))((name e)(type_ I64))((name f)(type_ I64))((name g)(type_ I64))((name h)(type_ I64))((name i)(type_ I64)))                                                                                      |
      +----------------+---------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(MOV(Reg((reg(Unallocated((name j)(type_ I64))))(class_ I64)))(Imm 10)))                                                          | (((name a)(type_ I64))((name b)(type_ I64))((name c)(type_ I64))((name d)(type_ I64))((name e)(type_ I64))((name f)(type_ I64))((name g)(type_ I64))((name h)(type_ I64))((name i)(type_ I64)))                                                                                      | (((name a)(type_ I64))((name b)(type_ I64))((name c)(type_ I64))((name d)(type_ I64))((name e)(type_ I64))((name f)(type_ I64))((name g)(type_ I64))((name h)(type_ I64))((name i)(type_ I64))((name j)(type_ I64)))                                                                 |
      +----------------+---------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(MOV(Reg((reg(Unallocated((name k)(type_ I64))))(class_ I64)))(Imm 11)))                                                          | (((name a)(type_ I64))((name b)(type_ I64))((name c)(type_ I64))((name d)(type_ I64))((name e)(type_ I64))((name f)(type_ I64))((name g)(type_ I64))((name h)(type_ I64))((name i)(type_ I64))((name j)(type_ I64)))                                                                 | (((name a)(type_ I64))((name b)(type_ I64))((name c)(type_ I64))((name d)(type_ I64))((name e)(type_ I64))((name f)(type_ I64))((name g)(type_ I64))((name h)(type_ I64))((name i)(type_ I64))((name j)(type_ I64))((name k)(type_ I64)))                                            |
      +----------------+---------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(MOV(Reg((reg(Unallocated((name l)(type_ I64))))(class_ I64)))(Imm 12)))                                                          | (((name a)(type_ I64))((name b)(type_ I64))((name c)(type_ I64))((name d)(type_ I64))((name e)(type_ I64))((name f)(type_ I64))((name g)(type_ I64))((name h)(type_ I64))((name i)(type_ I64))((name j)(type_ I64))((name k)(type_ I64)))                                            | (((name a)(type_ I64))((name b)(type_ I64))((name c)(type_ I64))((name d)(type_ I64))((name e)(type_ I64))((name f)(type_ I64))((name g)(type_ I64))((name h)(type_ I64))((name i)(type_ I64))((name j)(type_ I64))((name k)(type_ I64))((name l)(type_ I64)))                       |
      +----------------+---------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(MOV(Reg((reg(Unallocated((name m)(type_ I64))))(class_ I64)))(Imm 13)))                                                          | (((name a)(type_ I64))((name b)(type_ I64))((name c)(type_ I64))((name d)(type_ I64))((name e)(type_ I64))((name f)(type_ I64))((name g)(type_ I64))((name h)(type_ I64))((name i)(type_ I64))((name j)(type_ I64))((name k)(type_ I64))((name l)(type_ I64)))                       | (((name a)(type_ I64))((name b)(type_ I64))((name c)(type_ I64))((name d)(type_ I64))((name e)(type_ I64))((name f)(type_ I64))((name g)(type_ I64))((name h)(type_ I64))((name i)(type_ I64))((name j)(type_ I64))((name k)(type_ I64))((name l)(type_ I64))((name m)(type_ I64)))  |
      +----------------+---------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(MOV(Reg((reg(Unallocated((name s1)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name a)(type_ I64))))(class_ I64)))))       | (((name a)(type_ I64))((name b)(type_ I64))((name c)(type_ I64))((name d)(type_ I64))((name e)(type_ I64))((name f)(type_ I64))((name g)(type_ I64))((name h)(type_ I64))((name i)(type_ I64))((name j)(type_ I64))((name k)(type_ I64))((name l)(type_ I64))((name m)(type_ I64)))  | (((name b)(type_ I64))((name c)(type_ I64))((name d)(type_ I64))((name e)(type_ I64))((name f)(type_ I64))((name g)(type_ I64))((name h)(type_ I64))((name i)(type_ I64))((name j)(type_ I64))((name k)(type_ I64))((name l)(type_ I64))((name m)(type_ I64))((name s1)(type_ I64))) |
      +----------------+---------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(ADD(Reg((reg(Unallocated((name s1)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name b)(type_ I64))))(class_ I64)))))       | (((name b)(type_ I64))((name c)(type_ I64))((name d)(type_ I64))((name e)(type_ I64))((name f)(type_ I64))((name g)(type_ I64))((name h)(type_ I64))((name i)(type_ I64))((name j)(type_ I64))((name k)(type_ I64))((name l)(type_ I64))((name m)(type_ I64))((name s1)(type_ I64))) | (((name c)(type_ I64))((name d)(type_ I64))((name e)(type_ I64))((name f)(type_ I64))((name g)(type_ I64))((name h)(type_ I64))((name i)(type_ I64))((name j)(type_ I64))((name k)(type_ I64))((name l)(type_ I64))((name m)(type_ I64))((name s1)(type_ I64)))                      |
      +----------------+---------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(MOV(Reg((reg(Unallocated((name s2)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name s1)(type_ I64))))(class_ I64)))))      | (((name c)(type_ I64))((name d)(type_ I64))((name e)(type_ I64))((name f)(type_ I64))((name g)(type_ I64))((name h)(type_ I64))((name i)(type_ I64))((name j)(type_ I64))((name k)(type_ I64))((name l)(type_ I64))((name m)(type_ I64))((name s1)(type_ I64)))                      | (((name c)(type_ I64))((name d)(type_ I64))((name e)(type_ I64))((name f)(type_ I64))((name g)(type_ I64))((name h)(type_ I64))((name i)(type_ I64))((name j)(type_ I64))((name k)(type_ I64))((name l)(type_ I64))((name m)(type_ I64))((name s2)(type_ I64)))                      |
      +----------------+---------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(ADD(Reg((reg(Unallocated((name s2)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name c)(type_ I64))))(class_ I64)))))       | (((name c)(type_ I64))((name d)(type_ I64))((name e)(type_ I64))((name f)(type_ I64))((name g)(type_ I64))((name h)(type_ I64))((name i)(type_ I64))((name j)(type_ I64))((name k)(type_ I64))((name l)(type_ I64))((name m)(type_ I64))((name s2)(type_ I64)))                      | (((name d)(type_ I64))((name e)(type_ I64))((name f)(type_ I64))((name g)(type_ I64))((name h)(type_ I64))((name i)(type_ I64))((name j)(type_ I64))((name k)(type_ I64))((name l)(type_ I64))((name m)(type_ I64))((name s2)(type_ I64)))                                           |
      +----------------+---------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(MOV(Reg((reg(Unallocated((name s3)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name s2)(type_ I64))))(class_ I64)))))      | (((name d)(type_ I64))((name e)(type_ I64))((name f)(type_ I64))((name g)(type_ I64))((name h)(type_ I64))((name i)(type_ I64))((name j)(type_ I64))((name k)(type_ I64))((name l)(type_ I64))((name m)(type_ I64))((name s2)(type_ I64)))                                           | (((name d)(type_ I64))((name e)(type_ I64))((name f)(type_ I64))((name g)(type_ I64))((name h)(type_ I64))((name i)(type_ I64))((name j)(type_ I64))((name k)(type_ I64))((name l)(type_ I64))((name m)(type_ I64))((name s3)(type_ I64)))                                           |
      +----------------+---------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(ADD(Reg((reg(Unallocated((name s3)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name d)(type_ I64))))(class_ I64)))))       | (((name d)(type_ I64))((name e)(type_ I64))((name f)(type_ I64))((name g)(type_ I64))((name h)(type_ I64))((name i)(type_ I64))((name j)(type_ I64))((name k)(type_ I64))((name l)(type_ I64))((name m)(type_ I64))((name s3)(type_ I64)))                                           | (((name e)(type_ I64))((name f)(type_ I64))((name g)(type_ I64))((name h)(type_ I64))((name i)(type_ I64))((name j)(type_ I64))((name k)(type_ I64))((name l)(type_ I64))((name m)(type_ I64))((name s3)(type_ I64)))                                                                |
      +----------------+---------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(MOV(Reg((reg(Unallocated((name s4)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name s3)(type_ I64))))(class_ I64)))))      | (((name e)(type_ I64))((name f)(type_ I64))((name g)(type_ I64))((name h)(type_ I64))((name i)(type_ I64))((name j)(type_ I64))((name k)(type_ I64))((name l)(type_ I64))((name m)(type_ I64))((name s3)(type_ I64)))                                                                | (((name e)(type_ I64))((name f)(type_ I64))((name g)(type_ I64))((name h)(type_ I64))((name i)(type_ I64))((name j)(type_ I64))((name k)(type_ I64))((name l)(type_ I64))((name m)(type_ I64))((name s4)(type_ I64)))                                                                |
      +----------------+---------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(ADD(Reg((reg(Unallocated((name s4)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name e)(type_ I64))))(class_ I64)))))       | (((name e)(type_ I64))((name f)(type_ I64))((name g)(type_ I64))((name h)(type_ I64))((name i)(type_ I64))((name j)(type_ I64))((name k)(type_ I64))((name l)(type_ I64))((name m)(type_ I64))((name s4)(type_ I64)))                                                                | (((name f)(type_ I64))((name g)(type_ I64))((name h)(type_ I64))((name i)(type_ I64))((name j)(type_ I64))((name k)(type_ I64))((name l)(type_ I64))((name m)(type_ I64))((name s4)(type_ I64)))                                                                                     |
      +----------------+---------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(MOV(Reg((reg(Unallocated((name s5)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name s4)(type_ I64))))(class_ I64)))))      | (((name f)(type_ I64))((name g)(type_ I64))((name h)(type_ I64))((name i)(type_ I64))((name j)(type_ I64))((name k)(type_ I64))((name l)(type_ I64))((name m)(type_ I64))((name s4)(type_ I64)))                                                                                     | (((name f)(type_ I64))((name g)(type_ I64))((name h)(type_ I64))((name i)(type_ I64))((name j)(type_ I64))((name k)(type_ I64))((name l)(type_ I64))((name m)(type_ I64))((name s5)(type_ I64)))                                                                                     |
      +----------------+---------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(ADD(Reg((reg(Unallocated((name s5)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name f)(type_ I64))))(class_ I64)))))       | (((name f)(type_ I64))((name g)(type_ I64))((name h)(type_ I64))((name i)(type_ I64))((name j)(type_ I64))((name k)(type_ I64))((name l)(type_ I64))((name m)(type_ I64))((name s5)(type_ I64)))                                                                                     | (((name g)(type_ I64))((name h)(type_ I64))((name i)(type_ I64))((name j)(type_ I64))((name k)(type_ I64))((name l)(type_ I64))((name m)(type_ I64))((name s5)(type_ I64)))                                                                                                          |
      +----------------+---------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(MOV(Reg((reg(Unallocated((name s6)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name s5)(type_ I64))))(class_ I64)))))      | (((name g)(type_ I64))((name h)(type_ I64))((name i)(type_ I64))((name j)(type_ I64))((name k)(type_ I64))((name l)(type_ I64))((name m)(type_ I64))((name s5)(type_ I64)))                                                                                                          | (((name g)(type_ I64))((name h)(type_ I64))((name i)(type_ I64))((name j)(type_ I64))((name k)(type_ I64))((name l)(type_ I64))((name m)(type_ I64))((name s6)(type_ I64)))                                                                                                          |
      +----------------+---------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(ADD(Reg((reg(Unallocated((name s6)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name g)(type_ I64))))(class_ I64)))))       | (((name g)(type_ I64))((name h)(type_ I64))((name i)(type_ I64))((name j)(type_ I64))((name k)(type_ I64))((name l)(type_ I64))((name m)(type_ I64))((name s6)(type_ I64)))                                                                                                          | (((name h)(type_ I64))((name i)(type_ I64))((name j)(type_ I64))((name k)(type_ I64))((name l)(type_ I64))((name m)(type_ I64))((name s6)(type_ I64)))                                                                                                                               |
      +----------------+---------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(MOV(Reg((reg(Unallocated((name s7)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name s6)(type_ I64))))(class_ I64)))))      | (((name h)(type_ I64))((name i)(type_ I64))((name j)(type_ I64))((name k)(type_ I64))((name l)(type_ I64))((name m)(type_ I64))((name s6)(type_ I64)))                                                                                                                               | (((name h)(type_ I64))((name i)(type_ I64))((name j)(type_ I64))((name k)(type_ I64))((name l)(type_ I64))((name m)(type_ I64))((name s7)(type_ I64)))                                                                                                                               |
      +----------------+---------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(ADD(Reg((reg(Unallocated((name s7)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name h)(type_ I64))))(class_ I64)))))       | (((name h)(type_ I64))((name i)(type_ I64))((name j)(type_ I64))((name k)(type_ I64))((name l)(type_ I64))((name m)(type_ I64))((name s7)(type_ I64)))                                                                                                                               | (((name i)(type_ I64))((name j)(type_ I64))((name k)(type_ I64))((name l)(type_ I64))((name m)(type_ I64))((name s7)(type_ I64)))                                                                                                                                                    |
      +----------------+---------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(MOV(Reg((reg(Unallocated((name s8)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name s7)(type_ I64))))(class_ I64)))))      | (((name i)(type_ I64))((name j)(type_ I64))((name k)(type_ I64))((name l)(type_ I64))((name m)(type_ I64))((name s7)(type_ I64)))                                                                                                                                                    | (((name i)(type_ I64))((name j)(type_ I64))((name k)(type_ I64))((name l)(type_ I64))((name m)(type_ I64))((name s8)(type_ I64)))                                                                                                                                                    |
      +----------------+---------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(ADD(Reg((reg(Unallocated((name s8)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name i)(type_ I64))))(class_ I64)))))       | (((name i)(type_ I64))((name j)(type_ I64))((name k)(type_ I64))((name l)(type_ I64))((name m)(type_ I64))((name s8)(type_ I64)))                                                                                                                                                    | (((name j)(type_ I64))((name k)(type_ I64))((name l)(type_ I64))((name m)(type_ I64))((name s8)(type_ I64)))                                                                                                                                                                         |
      +----------------+---------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(MOV(Reg((reg(Unallocated((name s9)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name s8)(type_ I64))))(class_ I64)))))      | (((name j)(type_ I64))((name k)(type_ I64))((name l)(type_ I64))((name m)(type_ I64))((name s8)(type_ I64)))                                                                                                                                                                         | (((name j)(type_ I64))((name k)(type_ I64))((name l)(type_ I64))((name m)(type_ I64))((name s9)(type_ I64)))                                                                                                                                                                         |
      +----------------+---------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(ADD(Reg((reg(Unallocated((name s9)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name j)(type_ I64))))(class_ I64)))))       | (((name j)(type_ I64))((name k)(type_ I64))((name l)(type_ I64))((name m)(type_ I64))((name s9)(type_ I64)))                                                                                                                                                                         | (((name k)(type_ I64))((name l)(type_ I64))((name m)(type_ I64))((name s9)(type_ I64)))                                                                                                                                                                                              |
      +----------------+---------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(MOV(Reg((reg(Unallocated((name s10)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name s9)(type_ I64))))(class_ I64)))))     | (((name k)(type_ I64))((name l)(type_ I64))((name m)(type_ I64))((name s9)(type_ I64)))                                                                                                                                                                                              | (((name k)(type_ I64))((name l)(type_ I64))((name m)(type_ I64))((name s10)(type_ I64)))                                                                                                                                                                                             |
      +----------------+---------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(ADD(Reg((reg(Unallocated((name s10)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name k)(type_ I64))))(class_ I64)))))      | (((name k)(type_ I64))((name l)(type_ I64))((name m)(type_ I64))((name s10)(type_ I64)))                                                                                                                                                                                             | (((name l)(type_ I64))((name m)(type_ I64))((name s10)(type_ I64)))                                                                                                                                                                                                                  |
      +----------------+---------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(MOV(Reg((reg(Unallocated((name s11)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name s10)(type_ I64))))(class_ I64)))))    | (((name l)(type_ I64))((name m)(type_ I64))((name s10)(type_ I64)))                                                                                                                                                                                                                  | (((name l)(type_ I64))((name m)(type_ I64))((name s11)(type_ I64)))                                                                                                                                                                                                                  |
      +----------------+---------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(ADD(Reg((reg(Unallocated((name s11)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name l)(type_ I64))))(class_ I64)))))      | (((name l)(type_ I64))((name m)(type_ I64))((name s11)(type_ I64)))                                                                                                                                                                                                                  | (((name m)(type_ I64))((name s11)(type_ I64)))                                                                                                                                                                                                                                       |
      +----------------+---------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(MOV(Reg((reg(Unallocated((name s12)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name s11)(type_ I64))))(class_ I64)))))    | (((name m)(type_ I64))((name s11)(type_ I64)))                                                                                                                                                                                                                                       | (((name m)(type_ I64))((name s12)(type_ I64)))                                                                                                                                                                                                                                       |
      +----------------+---------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(ADD(Reg((reg(Unallocated((name s12)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name m)(type_ I64))))(class_ I64)))))      | (((name m)(type_ I64))((name s12)(type_ I64)))                                                                                                                                                                                                                                       | (((name s12)(type_ I64)))                                                                                                                                                                                                                                                            |
      +----------------+---------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86(MOV(Reg((reg(Unallocated((name res__0)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name s12)(type_ I64))))(class_ I64))))) | (((name s12)(type_ I64)))                                                                                                                                                                                                                                                            | (((name s12)(type_ I64)))                                                                                                                                                                                                                                                            |
      +----------------+---------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | (X86_terminal((JMP((block((id_hum root__epilogue)(args(((name res__0)(type_ I64))))))(args(((name s12)(type_ I64))))))))              | (((name s12)(type_ I64)))                                                                                                                                                                                                                                                            | {}                                                                                                                                                                                                                                                                                   |
      +----------------+---------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | %root          | block end                                                                                                                             | {}                                                                                                                                                                                                                                                                                   | {}                                                                                                                                                                                                                                                                                   |
      +----------------+---------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | root__epilogue | (block start(args(((name res__0)(type_ I64)))))                                                                                       | {}                                                                                                                                                                                                                                                                                   | (((name res__0)(type_ I64)))                                                                                                                                                                                                                                                         |
      +----------------+---------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | root__epilogue | (X86(MOV(Reg((reg RAX)(class_ I64)))(Reg((reg(Allocated((name res__0)(type_ I64))(RAX)))(class_ I64)))))                              | (((name res__0)(type_ I64)))                                                                                                                                                                                                                                                         | (((name res__0)(type_ I64)))                                                                                                                                                                                                                                                         |
      +----------------+---------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | root__epilogue | (X86(RET((Reg((reg(Allocated((name res__0)(type_ I64))(RAX)))(class_ I64))))))                                                        | (((name res__0)(type_ I64)))                                                                                                                                                                                                                                                         | {}                                                                                                                                                                                                                                                                                   |
      +----------------+---------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      | root__epilogue | block end                                                                                                                             | {}                                                                                                                                                                                                                                                                                   | {}                                                                                                                                                                                                                                                                                   |
      +----------------+---------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      |}]
;;

let%expect_test "debug borked opt" =
  match Nod.compile ~opt_flags:Eir.Opt_flags.default borked with
  | Error e -> Nod_error.to_string e |> print_endline
  | Ok functions ->
    X86_backend.For_testing.print_selected_instructions functions;
    [%expect
      {|
      +----------------+-------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------+-------------------------------+
      | block          | instruction                                                                                                                               | live_in                       | live_out                      |
      +----------------+-------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------+-------------------------------+
      | root__prologue | (block start(args()))                                                                                                                     | {}                            | {}                            |
      +----------------+-------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------+-------------------------------+
      | root__prologue | (X86(Tag_def NOOP(Reg((reg RBP)(class_ I64)))))                                                                                           | {}                            | {}                            |
      +----------------+-------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------+-------------------------------+
      | root__prologue | (X86(JMP((block((id_hum %root)(args())))(args()))))                                                                                       | {}                            | {}                            |
      +----------------+-------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------+-------------------------------+
      | root__prologue | block end                                                                                                                                 | {}                            | {}                            |
      +----------------+-------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------+-------------------------------+
      | %root          | (block start(args()))                                                                                                                     | {}                            | {}                            |
      +----------------+-------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------+-------------------------------+
      | %root          | (X86(MOV(Reg((reg(Unallocated((name res__00)(type_ I64))))(class_ I64)))(Imm 91)))                                                        | {}                            | (((name res__00)(type_ I64))) |
      +----------------+-------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------+-------------------------------+
      | %root          | (X86(MOV(Reg((reg(Unallocated((name res__0)(type_ I64))))(class_ I64)))(Reg((reg(Unallocated((name res__00)(type_ I64))))(class_ I64))))) | (((name res__00)(type_ I64))) | (((name res__00)(type_ I64))) |
      +----------------+-------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------+-------------------------------+
      | %root          | (X86_terminal((JMP((block((id_hum root__epilogue)(args(((name res__0)(type_ I64))))))(args(((name res__00)(type_ I64))))))))              | (((name res__00)(type_ I64))) | {}                            |
      +----------------+-------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------+-------------------------------+
      | %root          | block end                                                                                                                                 | {}                            | {}                            |
      +----------------+-------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------+-------------------------------+
      | root__epilogue | (block start(args(((name res__0)(type_ I64)))))                                                                                           | {}                            | (((name res__0)(type_ I64)))  |
      +----------------+-------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------+-------------------------------+
      | root__epilogue | (X86(MOV(Reg((reg RAX)(class_ I64)))(Reg((reg(Allocated((name res__0)(type_ I64))(RAX)))(class_ I64)))))                                  | (((name res__0)(type_ I64)))  | (((name res__0)(type_ I64)))  |
      +----------------+-------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------+-------------------------------+
      | root__epilogue | (X86(RET((Reg((reg(Allocated((name res__0)(type_ I64))(RAX)))(class_ I64))))))                                                            | (((name res__0)(type_ I64)))  | {}                            |
      +----------------+-------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------+-------------------------------+
      | root__epilogue | block end                                                                                                                                 | {}                            | {}                            |
      +----------------+-------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------+-------------------------------+
      |}]
;;
