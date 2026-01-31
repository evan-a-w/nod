open! Core
open! Import

let test ?dump_crap ?(opt_flags = Eir.Opt_flags.no_opt) s =
  match Eir.compile ~opt_flags s with
  | Error e -> Nod_error.to_string e |> print_endline
  | Ok program ->
    let functions = program.Program.functions in
    print_s
      [%sexp
        (Map.data functions |> List.map ~f:Function.to_sexp_verbose
         : Sexp.t list)];
    let x86 = X86_backend.compile ?dump_crap functions in
    print_s
      [%sexp
        (Map.data x86 |> List.map ~f:Function.to_sexp_verbose : Sexp.t list)]
;;

let test_program ?dump_crap ?(opt_flags = Eir.Opt_flags.no_opt) fragments =
  let result =
    List.fold fragments ~init:(Ok String.Map.empty) ~f:(fun acc fragment ->
      match acc with
      | Error _ as e -> e
      | Ok functions ->
        (match Eir.compile ~opt_flags fragment with
         | Error _ as e -> e
         | Ok new_program ->
           let new_functions = new_program.Program.functions in
           let merged =
             Map.fold new_functions ~init:functions ~f:(fun ~key ~data acc ->
               Map.set acc ~key ~data)
           in
           Ok merged))
  in
  match result with
  | Error e -> Nod_error.to_string e |> print_endline
  | Ok functions ->
    print_s
      [%sexp
        (Map.data functions |> List.map ~f:Function.to_sexp_verbose
         : Sexp.t list)];
    let x86 = X86_backend.compile ?dump_crap functions in
    print_s
      [%sexp
        (Map.data x86 |> List.map ~f:Function.to_sexp_verbose : Sexp.t list)]
;;

let%expect_test "trivi" =
  test Examples.Textual.super_triv;
  [%expect
    {|
    (((call_conv Default)
      (root
       ((a (args ())
         (instrs
          (((id (Instr_id 5)) (ir (Move (Value_id 0) (Lit 10))))
           ((id (Instr_id 0)) (ir (Move (Value_id 1) (Lit 20))))
           ((id (Instr_id 1))
            (ir
             (Sub
              ((dest (Value_id 2)) (src1 (Var (Value_id 1)))
               (src2 (Var (Value_id 0)))))))
           ((id (Instr_id 2)) (ir (Return (Var (Value_id 2))))))))))
      (args ()) (name root) (prologue ()) (epilogue ())
      (bytes_for_clobber_saves 0) (bytes_for_padding 0) (bytes_for_spills 0)
      (bytes_statically_alloca'd 0)))
    (((call_conv Default)
      (root
       ((root__prologue (args ())
         (instrs
          (((id (Instr_id 17)) (ir (X86 (PUSH (Reg ((reg RBP) (class_ I64)))))))
           ((id (Instr_id 20))
            (ir
             (X86
              (MOV (Reg ((reg RBP) (class_ I64))) (Reg ((reg RSP) (class_ I64)))))))
           ((id (Instr_id 21)) (ir (X86 (PUSH (Reg ((reg R14) (class_ I64)))))))
           ((id (Instr_id 22)) (ir (X86 (PUSH (Reg ((reg R15) (class_ I64)))))))
           ((id (Instr_id 23))
            (ir (X86 (Tag_def NOOP (Reg ((reg RBP) (class_ I64)))))))
           ((id (Instr_id 29))
            (ir (X86 (JMP ((block ((id_hum a) (args ()))) (args ())))))))))
        (a (args ())
         (instrs
          (((id (Instr_id 18))
            (ir (X86 (MOV (Reg ((reg R14) (class_ I64))) (Imm 10)))))
           ((id (Instr_id 0))
            (ir (X86 (MOV (Reg ((reg R15) (class_ I64))) (Imm 20)))))
           ((id (Instr_id 5))
            (ir
             (X86
              (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg R15) (class_ I64)))))))
           ((id (Instr_id 6))
            (ir
             (X86
              (SUB (Reg ((reg R15) (class_ I64))) (Reg ((reg R14) (class_ I64)))))))
           ((id (Instr_id 2))
            (ir
             (X86
              (MOV (Reg ((reg RAX) (class_ I64))) (Reg ((reg R15) (class_ I64)))))))
           ((id (Instr_id 30))
            (ir
             (X86_terminal
              ((JMP
                ((block
                  ((id_hum root__epilogue) (args (((name res__0) (type_ I64))))))
                 (args ()))))))))))
        (root__epilogue (args (((name res__0) (type_ I64))))
         (instrs
          (((id (Instr_id 19))
            (ir
             (X86
              (MOV (Reg ((reg RAX) (class_ I64))) (Reg ((reg RAX) (class_ I64)))))))
           ((id (Instr_id 24))
            (ir (X86 (SUB (Reg ((reg RBP) (class_ I64))) (Imm 16)))))
           ((id (Instr_id 25))
            (ir
             (X86
              (MOV (Reg ((reg RSP) (class_ I64))) (Reg ((reg RBP) (class_ I64)))))))
           ((id (Instr_id 26)) (ir (X86 (POP ((reg R15) (class_ I64))))))
           ((id (Instr_id 27)) (ir (X86 (POP ((reg R14) (class_ I64))))))
           ((id (Instr_id 28)) (ir (X86 (POP ((reg RBP) (class_ I64))))))
           ((id (Instr_id 31)) (ir (X86 (RET ((Reg ((reg RAX) (class_ I64)))))))))))))
      (args ()) (name root) (prologue ()) (epilogue ())
      (bytes_for_clobber_saves 16) (bytes_for_padding 0) (bytes_for_spills 0)
      (bytes_statically_alloca'd 0)))
    |}]
;;

let%expect_test "a" =
  test Examples.Textual.a;
  [%expect
    {|
    (((call_conv Default)
      (root
       ((a (args ())
         (instrs
          (((id (Instr_id 13)) (ir (Move (Value_id 0) (Lit 10))))
           ((id (Instr_id 3)) (ir (Move (Value_id 1) (Lit 20))))
           ((id (Instr_id 4))
            (ir
             (Sub
              ((dest (Value_id 2)) (src1 (Var (Value_id 1)))
               (src2 (Var (Value_id 0)))))))
           ((id (Instr_id 5))
            (ir
             (Branch
              (Cond (cond (Lit 1))
               (if_true ((block ((id_hum b) (args ()))) (args ())))
               (if_false ((block ((id_hum c) (args ()))) (args ()))))))))))
        (b (args ())
         (instrs
          (((id (Instr_id 16))
            (ir
             (Add ((dest (Value_id 5)) (src1 (Var (Value_id 2))) (src2 (Lit 5))))))
           ((id (Instr_id 7))
            (ir
             (Branch
              (Cond (cond (Lit 1))
               (if_true
                ((block ((id_hum end) (args (((name z%0) (type_ I64))))))
                 (args ((Value_id 5)))))
               (if_false
                ((block ((id_hum end) (args (((name z%0) (type_ I64))))))
                 (args ((Value_id 5))))))))))))
        (end (args (((name z%0) (type_ I64))))
         (instrs (((id (Instr_id 14)) (ir (Return (Var (Value_id 3))))))))
        (c (args ())
         (instrs
          (((id (Instr_id 15)) (ir (Move (Value_id 4) (Lit 0))))
           ((id (Instr_id 2))
            (ir
             (Branch
              (Cond (cond (Lit 1))
               (if_true
                ((block ((id_hum end) (args (((name z%0) (type_ I64))))))
                 (args ((Value_id 4)))))
               (if_false
                ((block ((id_hum end) (args (((name z%0) (type_ I64))))))
                 (args ((Value_id 4))))))))))))))
      (args ()) (name root) (prologue ()) (epilogue ())
      (bytes_for_clobber_saves 0) (bytes_for_padding 0) (bytes_for_spills 0)
      (bytes_statically_alloca'd 0)))
    (((call_conv Default)
      (root
       ((root__prologue (args ())
         (instrs
          (((id (Instr_id 54)) (ir (X86 (PUSH (Reg ((reg RBP) (class_ I64)))))))
           ((id (Instr_id 66))
            (ir
             (X86
              (MOV (Reg ((reg RBP) (class_ I64))) (Reg ((reg RSP) (class_ I64)))))))
           ((id (Instr_id 67)) (ir (X86 (PUSH (Reg ((reg R14) (class_ I64)))))))
           ((id (Instr_id 68)) (ir (X86 (PUSH (Reg ((reg R15) (class_ I64)))))))
           ((id (Instr_id 69))
            (ir (X86 (Tag_def NOOP (Reg ((reg RBP) (class_ I64)))))))
           ((id (Instr_id 75))
            (ir (X86 (JMP ((block ((id_hum a) (args ()))) (args ())))))))))
        (a (args ())
         (instrs
          (((id (Instr_id 55))
            (ir (X86 (MOV (Reg ((reg R14) (class_ I64))) (Imm 10)))))
           ((id (Instr_id 3))
            (ir (X86 (MOV (Reg ((reg R15) (class_ I64))) (Imm 20)))))
           ((id (Instr_id 13))
            (ir
             (X86
              (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg R15) (class_ I64)))))))
           ((id (Instr_id 17))
            (ir
             (X86
              (SUB (Reg ((reg R15) (class_ I64))) (Reg ((reg R14) (class_ I64)))))))
           ((id (Instr_id 76))
            (ir
             (X86_terminal
              ((CMP (Imm 1) (Imm 0))
               (JNE ((block ((id_hum intermediate_a_to_b) (args ()))) (args ()))
                (((block ((id_hum intermediate_a_to_c) (args ()))) (args ())))))))))))
        (intermediate_a_to_b (args ())
         (instrs
          (((id (Instr_id 77))
            (ir (X86 (JMP ((block ((id_hum b) (args ()))) (args ())))))))))
        (b (args ())
         (instrs
          (((id (Instr_id 57))
            (ir
             (X86
              (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg R15) (class_ I64)))))))
           ((id (Instr_id 5))
            (ir (X86 (ADD (Reg ((reg R15) (class_ I64))) (Imm 5)))))
           ((id (Instr_id 78))
            (ir
             (X86_terminal
              ((CMP (Imm 1) (Imm 0))
               (JNE
                ((block ((id_hum intermediate_b_to_end0) (args ()))) (args ()))
                (((block ((id_hum intermediate_b_to_end) (args ()))) (args ())))))))))))
        (intermediate_b_to_end0 (args ())
         (instrs
          (((id (Instr_id 58))
            (ir
             (X86
              (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg R15) (class_ I64)))))))
           ((id (Instr_id 79))
            (ir
             (X86
              (JMP
               ((block ((id_hum end) (args (((name z%0) (type_ I64))))))
                (args ())))))))))
        (end (args (((name z%0) (type_ I64))))
         (instrs
          (((id (Instr_id 59))
            (ir
             (X86
              (MOV (Reg ((reg RAX) (class_ I64))) (Reg ((reg R15) (class_ I64)))))))
           ((id (Instr_id 80))
            (ir
             (X86_terminal
              ((JMP
                ((block
                  ((id_hum root__epilogue) (args (((name res__0) (type_ I64))))))
                 (args ()))))))))))
        (root__epilogue (args (((name res__0) (type_ I64))))
         (instrs
          (((id (Instr_id 60))
            (ir
             (X86
              (MOV (Reg ((reg RAX) (class_ I64))) (Reg ((reg RAX) (class_ I64)))))))
           ((id (Instr_id 70))
            (ir (X86 (SUB (Reg ((reg RBP) (class_ I64))) (Imm 16)))))
           ((id (Instr_id 71))
            (ir
             (X86
              (MOV (Reg ((reg RSP) (class_ I64))) (Reg ((reg RBP) (class_ I64)))))))
           ((id (Instr_id 72)) (ir (X86 (POP ((reg R15) (class_ I64))))))
           ((id (Instr_id 73)) (ir (X86 (POP ((reg R14) (class_ I64))))))
           ((id (Instr_id 74)) (ir (X86 (POP ((reg RBP) (class_ I64))))))
           ((id (Instr_id 81)) (ir (X86 (RET ((Reg ((reg RAX) (class_ I64)))))))))))
        (intermediate_b_to_end (args ())
         (instrs
          (((id (Instr_id 61))
            (ir
             (X86
              (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg R15) (class_ I64)))))))
           ((id (Instr_id 82))
            (ir
             (X86
              (JMP
               ((block ((id_hum end) (args (((name z%0) (type_ I64))))))
                (args ())))))))))
        (intermediate_a_to_c (args ())
         (instrs
          (((id (Instr_id 83))
            (ir (X86 (JMP ((block ((id_hum c) (args ()))) (args ())))))))))
        (c (args ())
         (instrs
          (((id (Instr_id 63))
            (ir (X86 (MOV (Reg ((reg R15) (class_ I64))) (Imm 0)))))
           ((id (Instr_id 84))
            (ir
             (X86_terminal
              ((CMP (Imm 1) (Imm 0))
               (JNE
                ((block ((id_hum intermediate_c_to_end0) (args ()))) (args ()))
                (((block ((id_hum intermediate_c_to_end) (args ()))) (args ())))))))))))
        (intermediate_c_to_end0 (args ())
         (instrs
          (((id (Instr_id 64))
            (ir
             (X86
              (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg R15) (class_ I64)))))))
           ((id (Instr_id 85))
            (ir
             (X86
              (JMP
               ((block ((id_hum end) (args (((name z%0) (type_ I64))))))
                (args ())))))))))
        (intermediate_c_to_end (args ())
         (instrs
          (((id (Instr_id 65))
            (ir
             (X86
              (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg R15) (class_ I64)))))))
           ((id (Instr_id 86))
            (ir
             (X86
              (JMP
               ((block ((id_hum end) (args (((name z%0) (type_ I64))))))
                (args ())))))))))))
      (args ()) (name root) (prologue ()) (epilogue ())
      (bytes_for_clobber_saves 16) (bytes_for_padding 0) (bytes_for_spills 0)
      (bytes_statically_alloca'd 0)))
    |}]
;;

let%expect_test "e2" =
  test Examples.Textual.e2;
  [%expect
    {|
    (((call_conv Default)
      (root
       ((start (args ())
         (instrs
          (((id (Instr_id 15)) (ir (Move (Value_id 0) (Lit 7))))
           ((id (Instr_id 3)) (ir (Move (Value_id 1) (Lit 2))))
           ((id (Instr_id 4))
            (ir
             (Mul ((dest (Value_id 3)) (src1 (Var (Value_id 0))) (src2 (Lit 3))))))
           ((id (Instr_id 5))
            (ir
             (Div
              ((dest (Value_id 4)) (src1 (Var (Value_id 3)))
               (src2 (Var (Value_id 1)))))))
           ((id (Instr_id 6))
            (ir
             (Sub ((dest (Value_id 2)) (src1 (Var (Value_id 1))) (src2 (Lit 2))))))
           ((id (Instr_id 7))
            (ir
             (Branch
              (Cond (cond (Var (Value_id 2)))
               (if_true ((block ((id_hum ifTrue) (args ()))) (args ())))
               (if_false ((block ((id_hum ifFalse) (args ()))) (args ()))))))))))
        (ifTrue (args ())
         (instrs
          (((id (Instr_id 18)) (ir (Move (Value_id 7) (Lit 999))))
           ((id (Instr_id 9))
            (ir
             (Branch
              (Cond (cond (Lit 1))
               (if_true
                ((block ((id_hum end) (args (((name x%2) (type_ I64))))))
                 (args ((Value_id 7)))))
               (if_false
                ((block ((id_hum end) (args (((name x%2) (type_ I64))))))
                 (args ((Value_id 7))))))))))))
        (end (args (((name x%2) (type_ I64))))
         (instrs (((id (Instr_id 16)) (ir (Return (Var (Value_id 5))))))))
        (ifFalse (args ())
         (instrs
          (((id (Instr_id 17))
            (ir
             (Add
              ((dest (Value_id 6)) (src1 (Var (Value_id 4))) (src2 (Lit 10))))))
           ((id (Instr_id 2))
            (ir
             (Branch
              (Cond (cond (Lit 1))
               (if_true
                ((block ((id_hum end) (args (((name x%2) (type_ I64))))))
                 (args ((Value_id 6)))))
               (if_false
                ((block ((id_hum end) (args (((name x%2) (type_ I64))))))
                 (args ((Value_id 6))))))))))))))
      (args ()) (name root) (prologue ()) (epilogue ())
      (bytes_for_clobber_saves 0) (bytes_for_padding 0) (bytes_for_spills 0)
      (bytes_statically_alloca'd 0)))
    (((call_conv Default)
      (root
       ((root__prologue (args ())
         (instrs
          (((id (Instr_id 61)) (ir (X86 (PUSH (Reg ((reg RBP) (class_ I64)))))))
           ((id (Instr_id 73))
            (ir
             (X86
              (MOV (Reg ((reg RBP) (class_ I64))) (Reg ((reg RSP) (class_ I64)))))))
           ((id (Instr_id 74)) (ir (X86 (PUSH (Reg ((reg R13) (class_ I64)))))))
           ((id (Instr_id 75)) (ir (X86 (PUSH (Reg ((reg R14) (class_ I64)))))))
           ((id (Instr_id 76)) (ir (X86 (PUSH (Reg ((reg R15) (class_ I64)))))))
           ((id (Instr_id 77))
            (ir (X86 (SUB (Reg ((reg RSP) (class_ I64))) (Imm 8)))))
           ((id (Instr_id 78))
            (ir (X86 (Tag_def NOOP (Reg ((reg RBP) (class_ I64)))))))
           ((id (Instr_id 85))
            (ir (X86 (JMP ((block ((id_hum start) (args ()))) (args ())))))))))
        (start (args ())
         (instrs
          (((id (Instr_id 62))
            (ir (X86 (MOV (Reg ((reg R14) (class_ I64))) (Imm 7)))))
           ((id (Instr_id 5))
            (ir (X86 (MOV (Reg ((reg R13) (class_ I64))) (Imm 2)))))
           ((id (Instr_id 4))
            (ir (X86 (MOV (Reg ((reg R15) (class_ I64))) (Imm 3)))))
           ((id (Instr_id 3))
            (ir
             (X86
              (MOV (Reg ((reg RAX) (class_ I64))) (Reg ((reg R14) (class_ I64)))))))
           ((id (Instr_id 15))
            (ir
             (X86
              (Tag_def
               (Tag_def
                (Tag_use (IMUL (Reg ((reg R15) (class_ I64))))
                 (Reg ((reg RAX) (class_ I64))))
                (Reg ((reg RAX) (class_ I64))))
               (Reg ((reg RDX) (class_ I64)))))))
           ((id (Instr_id 19))
            (ir
             (X86
              (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg RAX) (class_ I64)))))))
           ((id (Instr_id 2))
            (ir
             (X86
              (MOV (Reg ((reg RAX) (class_ I64))) (Reg ((reg R15) (class_ I64)))))))
           ((id (Instr_id 20))
            (ir
             (X86
              (Tag_def
               (Tag_def
                (Tag_use (IDIV (Reg ((reg R13) (class_ I64))))
                 (Reg ((reg RAX) (class_ I64))))
                (Reg ((reg RAX) (class_ I64))))
               (Reg ((reg RDX) (class_ I64)))))))
           ((id (Instr_id 21))
            (ir
             (X86
              (MOV (Reg ((reg R14) (class_ I64))) (Reg ((reg RAX) (class_ I64)))))))
           ((id (Instr_id 22))
            (ir
             (X86
              (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg R13) (class_ I64)))))))
           ((id (Instr_id 23))
            (ir (X86 (SUB (Reg ((reg R15) (class_ I64))) (Imm 2)))))
           ((id (Instr_id 86))
            (ir
             (X86_terminal
              ((CMP (Reg ((reg R15) (class_ I64))) (Imm 0))
               (JNE
                ((block ((id_hum intermediate_start_to_ifTrue) (args ())))
                 (args ()))
                (((block ((id_hum intermediate_start_to_ifFalse) (args ())))
                  (args ())))))))))))
        (intermediate_start_to_ifTrue (args ())
         (instrs
          (((id (Instr_id 87))
            (ir (X86 (JMP ((block ((id_hum ifTrue) (args ()))) (args ())))))))))
        (ifTrue (args ())
         (instrs
          (((id (Instr_id 64))
            (ir (X86 (MOV (Reg ((reg R15) (class_ I64))) (Imm 999)))))
           ((id (Instr_id 88))
            (ir
             (X86_terminal
              ((CMP (Imm 1) (Imm 0))
               (JNE
                ((block ((id_hum intermediate_ifTrue_to_end0) (args ())))
                 (args ()))
                (((block ((id_hum intermediate_ifTrue_to_end) (args ())))
                  (args ())))))))))))
        (intermediate_ifTrue_to_end0 (args ())
         (instrs
          (((id (Instr_id 65))
            (ir
             (X86
              (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg R15) (class_ I64)))))))
           ((id (Instr_id 89))
            (ir
             (X86
              (JMP
               ((block ((id_hum end) (args (((name x%2) (type_ I64))))))
                (args ())))))))))
        (end (args (((name x%2) (type_ I64))))
         (instrs
          (((id (Instr_id 66))
            (ir
             (X86
              (MOV (Reg ((reg RAX) (class_ I64))) (Reg ((reg R15) (class_ I64)))))))
           ((id (Instr_id 90))
            (ir
             (X86_terminal
              ((JMP
                ((block
                  ((id_hum root__epilogue) (args (((name res__0) (type_ I64))))))
                 (args ()))))))))))
        (root__epilogue (args (((name res__0) (type_ I64))))
         (instrs
          (((id (Instr_id 67))
            (ir
             (X86
              (MOV (Reg ((reg RAX) (class_ I64))) (Reg ((reg RAX) (class_ I64)))))))
           ((id (Instr_id 79))
            (ir (X86 (SUB (Reg ((reg RBP) (class_ I64))) (Imm 24)))))
           ((id (Instr_id 80))
            (ir
             (X86
              (MOV (Reg ((reg RSP) (class_ I64))) (Reg ((reg RBP) (class_ I64)))))))
           ((id (Instr_id 81)) (ir (X86 (POP ((reg R15) (class_ I64))))))
           ((id (Instr_id 82)) (ir (X86 (POP ((reg R14) (class_ I64))))))
           ((id (Instr_id 83)) (ir (X86 (POP ((reg R13) (class_ I64))))))
           ((id (Instr_id 84)) (ir (X86 (POP ((reg RBP) (class_ I64))))))
           ((id (Instr_id 91)) (ir (X86 (RET ((Reg ((reg RAX) (class_ I64)))))))))))
        (intermediate_ifTrue_to_end (args ())
         (instrs
          (((id (Instr_id 68))
            (ir
             (X86
              (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg R15) (class_ I64)))))))
           ((id (Instr_id 92))
            (ir
             (X86
              (JMP
               ((block ((id_hum end) (args (((name x%2) (type_ I64))))))
                (args ())))))))))
        (intermediate_start_to_ifFalse (args ())
         (instrs
          (((id (Instr_id 93))
            (ir (X86 (JMP ((block ((id_hum ifFalse) (args ()))) (args ())))))))))
        (ifFalse (args ())
         (instrs
          (((id (Instr_id 70))
            (ir
             (X86
              (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg R14) (class_ I64)))))))
           ((id (Instr_id 16))
            (ir (X86 (ADD (Reg ((reg R15) (class_ I64))) (Imm 10)))))
           ((id (Instr_id 94))
            (ir
             (X86_terminal
              ((CMP (Imm 1) (Imm 0))
               (JNE
                ((block ((id_hum intermediate_ifFalse_to_end0) (args ())))
                 (args ()))
                (((block ((id_hum intermediate_ifFalse_to_end) (args ())))
                  (args ())))))))))))
        (intermediate_ifFalse_to_end0 (args ())
         (instrs
          (((id (Instr_id 71))
            (ir
             (X86
              (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg R15) (class_ I64)))))))
           ((id (Instr_id 95))
            (ir
             (X86
              (JMP
               ((block ((id_hum end) (args (((name x%2) (type_ I64))))))
                (args ())))))))))
        (intermediate_ifFalse_to_end (args ())
         (instrs
          (((id (Instr_id 72))
            (ir
             (X86
              (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg R15) (class_ I64)))))))
           ((id (Instr_id 96))
            (ir
             (X86
              (JMP
               ((block ((id_hum end) (args (((name x%2) (type_ I64))))))
                (args ())))))))))))
      (args ()) (name root) (prologue ()) (epilogue ())
      (bytes_for_clobber_saves 24) (bytes_for_padding 8) (bytes_for_spills 0)
      (bytes_statically_alloca'd 0)))
    |}]
;;

let%expect_test "c2" =
  test Examples.Textual.c2;
  [%expect
    {|
    (((call_conv Default)
      (root
       ((entry (args ())
         (instrs
          (((id (Instr_id 6)) (ir (Move (Value_id 0) (Lit 100))))
           ((id (Instr_id 0)) (ir (Move (Value_id 1) (Lit 6))))
           ((id (Instr_id 1))
            (ir
             (Mod
              ((dest (Value_id 2)) (src1 (Var (Value_id 0)))
               (src2 (Var (Value_id 1)))))))
           ((id (Instr_id 2))
            (ir
             (Add ((dest (Value_id 3)) (src1 (Var (Value_id 2))) (src2 (Lit 1))))))
           ((id (Instr_id 3)) (ir (Return (Var (Value_id 3))))))))))
      (args ()) (name root) (prologue ()) (epilogue ())
      (bytes_for_clobber_saves 0) (bytes_for_padding 0) (bytes_for_spills 0)
      (bytes_statically_alloca'd 0)))
    (((call_conv Default)
      (root
       ((root__prologue (args ())
         (instrs
          (((id (Instr_id 20)) (ir (X86 (PUSH (Reg ((reg RBP) (class_ I64)))))))
           ((id (Instr_id 23))
            (ir
             (X86
              (MOV (Reg ((reg RBP) (class_ I64))) (Reg ((reg RSP) (class_ I64)))))))
           ((id (Instr_id 24)) (ir (X86 (PUSH (Reg ((reg R14) (class_ I64)))))))
           ((id (Instr_id 25)) (ir (X86 (PUSH (Reg ((reg R15) (class_ I64)))))))
           ((id (Instr_id 26))
            (ir (X86 (Tag_def NOOP (Reg ((reg RBP) (class_ I64)))))))
           ((id (Instr_id 32))
            (ir (X86 (JMP ((block ((id_hum entry) (args ()))) (args ())))))))))
        (entry (args ())
         (instrs
          (((id (Instr_id 21))
            (ir (X86 (MOV (Reg ((reg R14) (class_ I64))) (Imm 100)))))
           ((id (Instr_id 1))
            (ir (X86 (MOV (Reg ((reg R15) (class_ I64))) (Imm 6)))))
           ((id (Instr_id 0))
            (ir
             (X86
              (MOV (Reg ((reg RAX) (class_ I64))) (Reg ((reg R14) (class_ I64)))))))
           ((id (Instr_id 6))
            (ir
             (X86
              (Tag_def
               (Tag_def
                (Tag_use (MOD (Reg ((reg R15) (class_ I64))))
                 (Reg ((reg RAX) (class_ I64))))
                (Reg ((reg RDX) (class_ I64))))
               (Reg ((reg RAX) (class_ I64)))))))
           ((id (Instr_id 7))
            (ir
             (X86
              (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg RDX) (class_ I64)))))))
           ((id (Instr_id 3))
            (ir
             (X86
              (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg R15) (class_ I64)))))))
           ((id (Instr_id 8))
            (ir (X86 (ADD (Reg ((reg R15) (class_ I64))) (Imm 1)))))
           ((id (Instr_id 9))
            (ir
             (X86
              (MOV (Reg ((reg RAX) (class_ I64))) (Reg ((reg R15) (class_ I64)))))))
           ((id (Instr_id 33))
            (ir
             (X86_terminal
              ((JMP
                ((block
                  ((id_hum root__epilogue) (args (((name res__0) (type_ I64))))))
                 (args ()))))))))))
        (root__epilogue (args (((name res__0) (type_ I64))))
         (instrs
          (((id (Instr_id 22))
            (ir
             (X86
              (MOV (Reg ((reg RAX) (class_ I64))) (Reg ((reg RAX) (class_ I64)))))))
           ((id (Instr_id 27))
            (ir (X86 (SUB (Reg ((reg RBP) (class_ I64))) (Imm 16)))))
           ((id (Instr_id 28))
            (ir
             (X86
              (MOV (Reg ((reg RSP) (class_ I64))) (Reg ((reg RBP) (class_ I64)))))))
           ((id (Instr_id 29)) (ir (X86 (POP ((reg R15) (class_ I64))))))
           ((id (Instr_id 30)) (ir (X86 (POP ((reg R14) (class_ I64))))))
           ((id (Instr_id 31)) (ir (X86 (POP ((reg RBP) (class_ I64))))))
           ((id (Instr_id 34)) (ir (X86 (RET ((Reg ((reg RAX) (class_ I64)))))))))))))
      (args ()) (name root) (prologue ()) (epilogue ())
      (bytes_for_clobber_saves 16) (bytes_for_padding 0) (bytes_for_spills 0)
      (bytes_statically_alloca'd 0)))
    |}]
;;

let%expect_test "alloca lowers" =
  test {|
mov %n:i64, 24
alloca %ptr:ptr, 16
alloca %dyn:ptr, %n
ret %dyn
|};
  [%expect
    {|
    (((call_conv Default)
      (root
       ((%root (args ())
         (instrs
          (((id (Instr_id 5)) (ir (Move (Value_id 0) (Lit 24))))
           ((id (Instr_id 0))
            (ir (Alloca ((dest (Value_id 1)) (size (Lit 16))))))
           ((id (Instr_id 1))
            (ir (Alloca ((dest (Value_id 2)) (size (Var (Value_id 0)))))))
           ((id (Instr_id 2)) (ir (Return (Var (Value_id 2))))))))))
      (args ()) (name root) (prologue ()) (epilogue ())
      (bytes_for_clobber_saves 0) (bytes_for_padding 0) (bytes_for_spills 0)
      (bytes_statically_alloca'd 0)))
    (((call_conv Default)
      (root
       ((root__prologue (args ())
         (instrs
          (((id (Instr_id 17)) (ir (X86 (PUSH (Reg ((reg RBP) (class_ I64)))))))
           ((id (Instr_id 20))
            (ir
             (X86
              (MOV (Reg ((reg RBP) (class_ I64))) (Reg ((reg RSP) (class_ I64)))))))
           ((id (Instr_id 21)) (ir (X86 (PUSH (Reg ((reg R14) (class_ I64)))))))
           ((id (Instr_id 22)) (ir (X86 (PUSH (Reg ((reg R15) (class_ I64)))))))
           ((id (Instr_id 23))
            (ir (X86 (SUB (Reg ((reg RSP) (class_ I64))) (Imm 16)))))
           ((id (Instr_id 24))
            (ir (X86 (Tag_def NOOP (Reg ((reg RBP) (class_ I64)))))))
           ((id (Instr_id 30))
            (ir (X86 (JMP ((block ((id_hum %root) (args ()))) (args ())))))))))
        (%root (args ())
         (instrs
          (((id (Instr_id 18))
            (ir (X86 (MOV (Reg ((reg R14) (class_ I64))) (Imm 24)))))
           ((id (Instr_id 0))
            (ir
             (X86_terminal
              ((MOV (Reg ((reg R15) (class_ I64)))
                (Reg ((reg RBP) (class_ I64))))
               (SUB (Reg ((reg R15) (class_ I64))) (Imm 32))))))
           ((id (Instr_id 5))
            (ir
             (X86
              (SUB (Reg ((reg RSP) (class_ I64))) (Reg ((reg R14) (class_ I64)))))))
           ((id (Instr_id 6))
            (ir
             (X86
              (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg RSP) (class_ I64)))))))
           ((id (Instr_id 2))
            (ir
             (X86
              (MOV (Reg ((reg RAX) (class_ I64))) (Reg ((reg R15) (class_ I64)))))))
           ((id (Instr_id 31))
            (ir
             (X86_terminal
              ((JMP
                ((block
                  ((id_hum root__epilogue) (args (((name res__0) (type_ I64))))))
                 (args ()))))))))))
        (root__epilogue (args (((name res__0) (type_ I64))))
         (instrs
          (((id (Instr_id 19))
            (ir
             (X86
              (MOV (Reg ((reg RAX) (class_ I64))) (Reg ((reg RAX) (class_ I64)))))))
           ((id (Instr_id 25))
            (ir (X86 (SUB (Reg ((reg RBP) (class_ I64))) (Imm 16)))))
           ((id (Instr_id 26))
            (ir
             (X86
              (MOV (Reg ((reg RSP) (class_ I64))) (Reg ((reg RBP) (class_ I64)))))))
           ((id (Instr_id 27)) (ir (X86 (POP ((reg R15) (class_ I64))))))
           ((id (Instr_id 28)) (ir (X86 (POP ((reg R14) (class_ I64))))))
           ((id (Instr_id 29)) (ir (X86 (POP ((reg RBP) (class_ I64))))))
           ((id (Instr_id 32)) (ir (X86 (RET ((Reg ((reg RAX) (class_ I64)))))))))))))
      (args ()) (name root) (prologue ()) (epilogue ())
      (bytes_for_clobber_saves 16) (bytes_for_padding 0) (bytes_for_spills 0)
      (bytes_statically_alloca'd 16)))
    |}]
;;

let%expect_test "f" =
  test Examples.Textual.f;
  [%expect
    {|
    (((call_conv Default)
      (root
       ((start (args ())
         (instrs
          (((id (Instr_id 48)) (ir (Move (Value_id 0) (Lit 7))))
           ((id (Instr_id 9)) (ir (Move (Value_id 1) (Lit 0))))
           ((id (Instr_id 10)) (ir (Move (Value_id 2) (Lit 0))))
           ((id (Instr_id 11))
            (ir
             (Branch
              (Cond (cond (Lit 1))
               (if_true
                ((block
                  ((id_hum outerCheck)
                   (args
                    (((name i%0) (type_ I64)) ((name j) (type_ I64))
                     ((name partial) (type_ I64))))))
                 (args ((Value_id 1) (Value_id 4) (Value_id 5)))))
               (if_false
                ((block
                  ((id_hum exit)
                   (args
                    (((name total%2) (type_ I64)) ((name j%5) (type_ I64))
                     ((name partial%4) (type_ I64))))))
                 (args ((Value_id 2) (Value_id 4) (Value_id 5))))))))))))
        (outerCheck
         (args
          (((name i%0) (type_ I64)) ((name j) (type_ I64))
           ((name partial) (type_ I64))))
         (instrs
          (((id (Instr_id 49))
            (ir
             (Sub
              ((dest (Value_id 3)) (src1 (Var (Value_id 10)))
               (src2 (Var (Value_id 0)))))))
           ((id (Instr_id 13))
            (ir
             (Branch
              (Cond (cond (Var (Value_id 3)))
               (if_true ((block ((id_hum outerBody) (args ()))) (args ())))
               (if_false
                ((block
                  ((id_hum exit)
                   (args
                    (((name total%2) (type_ I64)) ((name j%5) (type_ I64))
                     ((name partial%4) (type_ I64))))))
                 (args ((Value_id 2) (Value_id 4) (Value_id 5))))))))))))
        (outerBody (args ())
         (instrs
          (((id (Instr_id 50)) (ir (Move (Value_id 11) (Lit 0))))
           ((id (Instr_id 14)) (ir (Move (Value_id 12) (Lit 0))))
           ((id (Instr_id 1))
            (ir
             (Branch
              (Cond (cond (Lit 1))
               (if_true
                ((block
                  ((id_hum innerCheck)
                   (args
                    (((name j%1) (type_ I64)) ((name partial%1) (type_ I64))))))
                 (args ((Value_id 11) (Value_id 12)))))
               (if_false
                ((block
                  ((id_hum outerInc) (args (((name total%1) (type_ I64))))))
                 (args ((Value_id 2))))))))))))
        (innerCheck
         (args (((name j%1) (type_ I64)) ((name partial%1) (type_ I64))))
         (instrs
          (((id (Instr_id 51))
            (ir
             (Sub
              ((dest (Value_id 6)) (src1 (Var (Value_id 13))) (src2 (Lit 3))))))
           ((id (Instr_id 16))
            (ir
             (Branch
              (Cond (cond (Var (Value_id 6)))
               (if_true ((block ((id_hum innerBody) (args ()))) (args ())))
               (if_false
                ((block
                  ((id_hum innerExit)
                   (args
                    (((name j%2) (type_ I64)) ((name partial%2) (type_ I64))))))
                 (args ((Value_id 13) (Value_id 14))))))))))))
        (innerBody (args ())
         (instrs
          (((id (Instr_id 53))
            (ir
             (And
              ((dest (Value_id 7)) (src1 (Var (Value_id 13))) (src2 (Lit 1))))))
           ((id (Instr_id 17))
            (ir
             (Sub ((dest (Value_id 8)) (src1 (Var (Value_id 7))) (src2 (Lit 0))))))
           ((id (Instr_id 3))
            (ir
             (Branch
              (Cond (cond (Var (Value_id 8)))
               (if_true ((block ((id_hum doWork) (args ()))) (args ())))
               (if_false ((block ((id_hum skipEven) (args ()))) (args ()))))))))))
        (doWork (args ())
         (instrs
          (((id (Instr_id 54))
            (ir
             (Mul
              ((dest (Value_id 9)) (src1 (Var (Value_id 10)))
               (src2 (Var (Value_id 13)))))))
           ((id (Instr_id 19))
            (ir
             (Add
              ((dest (Value_id 18)) (src1 (Var (Value_id 14)))
               (src2 (Var (Value_id 9)))))))
           ((id (Instr_id 5))
            (ir
             (Add
              ((dest (Value_id 19)) (src1 (Var (Value_id 13))) (src2 (Lit 1))))))
           ((id (Instr_id 21))
            (ir
             (Branch
              (Cond (cond (Lit 1))
               (if_true
                ((block
                  ((id_hum innerCheck)
                   (args
                    (((name j%1) (type_ I64)) ((name partial%1) (type_ I64))))))
                 (args ((Value_id 19) (Value_id 18)))))
               (if_false
                ((block
                  ((id_hum innerExit)
                   (args
                    (((name j%2) (type_ I64)) ((name partial%2) (type_ I64))))))
                 (args ((Value_id 19) (Value_id 18))))))))))))
        (innerExit
         (args (((name j%2) (type_ I64)) ((name partial%2) (type_ I64))))
         (instrs
          (((id (Instr_id 52))
            (ir
             (Add
              ((dest (Value_id 17)) (src1 (Var (Value_id 2)))
               (src2 (Var (Value_id 16)))))))
           ((id (Instr_id 23))
            (ir
             (Branch
              (Cond (cond (Lit 1))
               (if_true
                ((block
                  ((id_hum outerInc) (args (((name total%1) (type_ I64))))))
                 (args ((Value_id 17)))))
               (if_false
                ((block
                  ((id_hum exit)
                   (args
                    (((name total%2) (type_ I64)) ((name j%5) (type_ I64))
                     ((name partial%4) (type_ I64))))))
                 (args ((Value_id 17) (Value_id 15) (Value_id 16))))))))))))
        (outerInc (args (((name total%1) (type_ I64))))
         (instrs
          (((id (Instr_id 56))
            (ir
             (Add
              ((dest (Value_id 22)) (src1 (Var (Value_id 10))) (src2 (Lit 1))))))
           ((id (Instr_id 24))
            (ir
             (Branch
              (Uncond
               ((block
                 ((id_hum outerCheck)
                  (args
                   (((name i%0) (type_ I64)) ((name j) (type_ I64))
                    ((name partial) (type_ I64))))))
                (args ((Value_id 22) (Value_id 11) (Value_id 12)))))))))))
        (exit
         (args
          (((name total%2) (type_ I64)) ((name j%5) (type_ I64))
           ((name partial%4) (type_ I64))))
         (instrs (((id (Instr_id 57)) (ir (Return (Var (Value_id 23))))))))
        (skipEven (args ())
         (instrs
          (((id (Instr_id 55))
            (ir
             (Add
              ((dest (Value_id 20)) (src1 (Var (Value_id 13))) (src2 (Lit 1))))))
           ((id (Instr_id 8))
            (ir
             (Branch
              (Cond (cond (Lit 1))
               (if_true
                ((block
                  ((id_hum innerCheck)
                   (args
                    (((name j%1) (type_ I64)) ((name partial%1) (type_ I64))))))
                 (args ((Value_id 20) (Value_id 14)))))
               (if_false
                ((block
                  ((id_hum innerExit)
                   (args
                    (((name j%2) (type_ I64)) ((name partial%2) (type_ I64))))))
                 (args ((Value_id 20) (Value_id 14))))))))))))))
      (args ()) (name root) (prologue ()) (epilogue ())
      (bytes_for_clobber_saves 0) (bytes_for_padding 0) (bytes_for_spills 0)
      (bytes_statically_alloca'd 0)))
    (((call_conv Default)
      (root
       ((root__prologue (args ())
         (instrs
          (((id (Instr_id 166)) (ir (X86 (PUSH (Reg ((reg RBP) (class_ I64)))))))
           ((id (Instr_id 194))
            (ir
             (X86
              (MOV (Reg ((reg RBP) (class_ I64))) (Reg ((reg RSP) (class_ I64)))))))
           ((id (Instr_id 195)) (ir (X86 (PUSH (Reg ((reg R12) (class_ I64)))))))
           ((id (Instr_id 196)) (ir (X86 (PUSH (Reg ((reg R13) (class_ I64)))))))
           ((id (Instr_id 197)) (ir (X86 (PUSH (Reg ((reg R14) (class_ I64)))))))
           ((id (Instr_id 198)) (ir (X86 (PUSH (Reg ((reg R15) (class_ I64)))))))
           ((id (Instr_id 199))
            (ir (X86 (Tag_def NOOP (Reg ((reg RBP) (class_ I64)))))))
           ((id (Instr_id 207))
            (ir (X86 (JMP ((block ((id_hum start) (args ()))) (args ())))))))))
        (start (args ())
         (instrs
          (((id (Instr_id 167))
            (ir (X86 (MOV (Reg ((reg R8) (class_ I64))) (Imm 7)))))
           ((id (Instr_id 9))
            (ir (X86 (MOV (Reg ((reg R15) (class_ I64))) (Imm 0)))))
           ((id (Instr_id 48))
            (ir (X86 (MOV (Reg ((reg R9) (class_ I64))) (Imm 0)))))
           ((id (Instr_id 208))
            (ir
             (X86_terminal
              ((CMP (Imm 1) (Imm 0))
               (JNE
                ((block ((id_hum intermediate_start_to_outerCheck) (args ())))
                 (args ()))
                (((block ((id_hum intermediate_start_to_exit) (args ())))
                  (args ())))))))))))
        (intermediate_start_to_outerCheck (args ())
         (instrs
          (((id (Instr_id 168))
            (ir
             (X86
              (MOV (Reg ((reg R10) (class_ I64))) (Reg ((reg R15) (class_ I64)))))))
           ((id (Instr_id 108))
            (ir
             (X86
              (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg R14) (class_ I64)))))))
           ((id (Instr_id 109))
            (ir
             (X86
              (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg R13) (class_ I64)))))))
           ((id (Instr_id 209))
            (ir
             (X86
              (JMP
               ((block
                 ((id_hum outerCheck)
                  (args
                   (((name i%0) (type_ I64)) ((name j) (type_ I64))
                    ((name partial) (type_ I64))))))
                (args ())))))))))
        (outerCheck
         (args
          (((name i%0) (type_ I64)) ((name j) (type_ I64))
           ((name partial) (type_ I64))))
         (instrs
          (((id (Instr_id 169))
            (ir
             (X86
              (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg R10) (class_ I64)))))))
           ((id (Instr_id 11))
            (ir
             (X86
              (SUB (Reg ((reg R15) (class_ I64))) (Reg ((reg R8) (class_ I64)))))))
           ((id (Instr_id 210))
            (ir
             (X86_terminal
              ((CMP (Reg ((reg R15) (class_ I64))) (Imm 0))
               (JNE
                ((block
                  ((id_hum intermediate_outerCheck_to_outerBody) (args ())))
                 (args ()))
                (((block ((id_hum intermediate_outerCheck_to_exit) (args ())))
                  (args ())))))))))))
        (intermediate_outerCheck_to_outerBody (args ())
         (instrs
          (((id (Instr_id 211))
            (ir (X86 (JMP ((block ((id_hum outerBody) (args ()))) (args ())))))))))
        (outerBody (args ())
         (instrs
          (((id (Instr_id 171))
            (ir (X86 (MOV (Reg ((reg R11) (class_ I64))) (Imm 0)))))
           ((id (Instr_id 50))
            (ir (X86 (MOV (Reg ((reg R12) (class_ I64))) (Imm 0)))))
           ((id (Instr_id 212))
            (ir
             (X86_terminal
              ((CMP (Imm 1) (Imm 0))
               (JNE
                ((block
                  ((id_hum intermediate_outerBody_to_innerCheck) (args ())))
                 (args ()))
                (((block ((id_hum intermediate_outerBody_to_outerInc) (args ())))
                  (args ())))))))))))
        (intermediate_outerBody_to_innerCheck (args ())
         (instrs
          (((id (Instr_id 172))
            (ir
             (X86
              (MOV (Reg ((reg R14) (class_ I64))) (Reg ((reg R11) (class_ I64)))))))
           ((id (Instr_id 111))
            (ir
             (X86
              (MOV (Reg ((reg R13) (class_ I64))) (Reg ((reg R12) (class_ I64)))))))
           ((id (Instr_id 213))
            (ir
             (X86
              (JMP
               ((block
                 ((id_hum innerCheck)
                  (args
                   (((name j%1) (type_ I64)) ((name partial%1) (type_ I64))))))
                (args ())))))))))
        (innerCheck
         (args (((name j%1) (type_ I64)) ((name partial%1) (type_ I64))))
         (instrs
          (((id (Instr_id 173))
            (ir
             (X86
              (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg R14) (class_ I64)))))))
           ((id (Instr_id 1))
            (ir (X86 (SUB (Reg ((reg R15) (class_ I64))) (Imm 3)))))
           ((id (Instr_id 214))
            (ir
             (X86_terminal
              ((CMP (Reg ((reg R15) (class_ I64))) (Imm 0))
               (JNE
                ((block
                  ((id_hum intermediate_innerCheck_to_innerBody) (args ())))
                 (args ()))
                (((block
                   ((id_hum intermediate_innerCheck_to_innerExit) (args ())))
                  (args ())))))))))))
        (intermediate_innerCheck_to_innerBody (args ())
         (instrs
          (((id (Instr_id 215))
            (ir (X86 (JMP ((block ((id_hum innerBody) (args ()))) (args ())))))))))
        (innerBody (args ())
         (instrs
          (((id (Instr_id 175))
            (ir
             (X86
              (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg R14) (class_ I64)))))))
           ((id (Instr_id 53))
            (ir (X86 (AND (Reg ((reg R15) (class_ I64))) (Imm 1)))))
           ((id (Instr_id 16))
            (ir
             (X86
              (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg R15) (class_ I64)))))))
           ((id (Instr_id 64))
            (ir (X86 (SUB (Reg ((reg R15) (class_ I64))) (Imm 0)))))
           ((id (Instr_id 216))
            (ir
             (X86_terminal
              ((CMP (Reg ((reg R15) (class_ I64))) (Imm 0))
               (JNE
                ((block ((id_hum intermediate_innerBody_to_doWork) (args ())))
                 (args ()))
                (((block ((id_hum intermediate_innerBody_to_skipEven) (args ())))
                  (args ())))))))))))
        (intermediate_innerBody_to_doWork (args ())
         (instrs
          (((id (Instr_id 217))
            (ir (X86 (JMP ((block ((id_hum doWork) (args ()))) (args ())))))))))
        (doWork (args ())
         (instrs
          (((id (Instr_id 177))
            (ir
             (X86
              (MOV (Reg ((reg RAX) (class_ I64))) (Reg ((reg R10) (class_ I64)))))))
           ((id (Instr_id 19))
            (ir
             (X86
              (Tag_def
               (Tag_def
                (Tag_use (IMUL (Reg ((reg R14) (class_ I64))))
                 (Reg ((reg RAX) (class_ I64))))
                (Reg ((reg RAX) (class_ I64))))
               (Reg ((reg RDX) (class_ I64)))))))
           ((id (Instr_id 54))
            (ir
             (X86
              (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg RAX) (class_ I64)))))))
           ((id (Instr_id 3))
            (ir
             (X86
              (MOV (Reg ((reg R13) (class_ I64))) (Reg ((reg R13) (class_ I64)))))))
           ((id (Instr_id 67))
            (ir
             (X86
              (ADD (Reg ((reg R13) (class_ I64))) (Reg ((reg R15) (class_ I64)))))))
           ((id (Instr_id 68))
            (ir
             (X86
              (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg R14) (class_ I64)))))))
           ((id (Instr_id 69))
            (ir (X86 (ADD (Reg ((reg R15) (class_ I64))) (Imm 1)))))
           ((id (Instr_id 218))
            (ir
             (X86_terminal
              ((CMP (Imm 1) (Imm 0))
               (JNE
                ((block ((id_hum intermediate_doWork_to_innerCheck) (args ())))
                 (args ()))
                (((block ((id_hum intermediate_doWork_to_innerExit) (args ())))
                  (args ())))))))))))
        (intermediate_doWork_to_innerCheck (args ())
         (instrs
          (((id (Instr_id 178))
            (ir
             (X86
              (MOV (Reg ((reg R14) (class_ I64))) (Reg ((reg R15) (class_ I64)))))))
           ((id (Instr_id 113))
            (ir
             (X86
              (MOV (Reg ((reg R13) (class_ I64))) (Reg ((reg R13) (class_ I64)))))))
           ((id (Instr_id 219))
            (ir
             (X86
              (JMP
               ((block
                 ((id_hum innerCheck)
                  (args
                   (((name j%1) (type_ I64)) ((name partial%1) (type_ I64))))))
                (args ())))))))))
        (intermediate_doWork_to_innerExit (args ())
         (instrs
          (((id (Instr_id 179))
            (ir
             (X86
              (MOV (Reg ((reg R14) (class_ I64))) (Reg ((reg R15) (class_ I64)))))))
           ((id (Instr_id 115))
            (ir
             (X86
              (MOV (Reg ((reg R13) (class_ I64))) (Reg ((reg R13) (class_ I64)))))))
           ((id (Instr_id 220))
            (ir
             (X86
              (JMP
               ((block
                 ((id_hum innerExit)
                  (args
                   (((name j%2) (type_ I64)) ((name partial%2) (type_ I64))))))
                (args ())))))))))
        (innerExit
         (args (((name j%2) (type_ I64)) ((name partial%2) (type_ I64))))
         (instrs
          (((id (Instr_id 180))
            (ir
             (X86
              (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg R9) (class_ I64)))))))
           ((id (Instr_id 21))
            (ir
             (X86
              (ADD (Reg ((reg R15) (class_ I64))) (Reg ((reg R13) (class_ I64)))))))
           ((id (Instr_id 221))
            (ir
             (X86_terminal
              ((CMP (Imm 1) (Imm 0))
               (JNE
                ((block ((id_hum intermediate_innerExit_to_outerInc) (args ())))
                 (args ()))
                (((block ((id_hum intermediate_innerExit_to_exit) (args ())))
                  (args ())))))))))))
        (intermediate_innerExit_to_outerInc (args ())
         (instrs
          (((id (Instr_id 181))
            (ir
             (X86
              (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg R15) (class_ I64)))))))
           ((id (Instr_id 222))
            (ir
             (X86
              (JMP
               ((block ((id_hum outerInc) (args (((name total%1) (type_ I64))))))
                (args ())))))))))
        (outerInc (args (((name total%1) (type_ I64))))
         (instrs
          (((id (Instr_id 182))
            (ir
             (X86
              (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg R10) (class_ I64)))))))
           ((id (Instr_id 23))
            (ir (X86 (ADD (Reg ((reg R15) (class_ I64))) (Imm 1)))))
           ((id (Instr_id 74))
            (ir
             (X86
              (MOV (Reg ((reg R10) (class_ I64))) (Reg ((reg R15) (class_ I64)))))))
           ((id (Instr_id 118))
            (ir
             (X86
              (MOV (Reg ((reg R14) (class_ I64))) (Reg ((reg R11) (class_ I64)))))))
           ((id (Instr_id 119))
            (ir
             (X86
              (MOV (Reg ((reg R13) (class_ I64))) (Reg ((reg R12) (class_ I64)))))))
           ((id (Instr_id 223))
            (ir
             (X86_terminal
              ((JMP
                ((block
                  ((id_hum outerCheck)
                   (args
                    (((name i%0) (type_ I64)) ((name j) (type_ I64))
                     ((name partial) (type_ I64))))))
                 (args ()))))))))))
        (intermediate_innerExit_to_exit (args ())
         (instrs
          (((id (Instr_id 183))
            (ir
             (X86
              (MOV (Reg ((reg R14) (class_ I64))) (Reg ((reg R14) (class_ I64)))))))
           ((id (Instr_id 121))
            (ir
             (X86
              (MOV (Reg ((reg R14) (class_ I64))) (Reg ((reg R13) (class_ I64)))))))
           ((id (Instr_id 122))
            (ir
             (X86
              (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg R15) (class_ I64)))))))
           ((id (Instr_id 224))
            (ir
             (X86
              (JMP
               ((block
                 ((id_hum exit)
                  (args
                   (((name total%2) (type_ I64)) ((name j%5) (type_ I64))
                    ((name partial%4) (type_ I64))))))
                (args ())))))))))
        (exit
         (args
          (((name total%2) (type_ I64)) ((name j%5) (type_ I64))
           ((name partial%4) (type_ I64))))
         (instrs
          (((id (Instr_id 184))
            (ir
             (X86
              (MOV (Reg ((reg RAX) (class_ I64))) (Reg ((reg R15) (class_ I64)))))))
           ((id (Instr_id 225))
            (ir
             (X86_terminal
              ((JMP
                ((block
                  ((id_hum root__epilogue) (args (((name res__0) (type_ I64))))))
                 (args ()))))))))))
        (root__epilogue (args (((name res__0) (type_ I64))))
         (instrs
          (((id (Instr_id 185))
            (ir
             (X86
              (MOV (Reg ((reg RAX) (class_ I64))) (Reg ((reg RAX) (class_ I64)))))))
           ((id (Instr_id 200))
            (ir (X86 (SUB (Reg ((reg RBP) (class_ I64))) (Imm 32)))))
           ((id (Instr_id 201))
            (ir
             (X86
              (MOV (Reg ((reg RSP) (class_ I64))) (Reg ((reg RBP) (class_ I64)))))))
           ((id (Instr_id 202)) (ir (X86 (POP ((reg R15) (class_ I64))))))
           ((id (Instr_id 203)) (ir (X86 (POP ((reg R14) (class_ I64))))))
           ((id (Instr_id 204)) (ir (X86 (POP ((reg R13) (class_ I64))))))
           ((id (Instr_id 205)) (ir (X86 (POP ((reg R12) (class_ I64))))))
           ((id (Instr_id 206)) (ir (X86 (POP ((reg RBP) (class_ I64))))))
           ((id (Instr_id 226))
            (ir (X86 (RET ((Reg ((reg RAX) (class_ I64)))))))))))
        (intermediate_innerBody_to_skipEven (args ())
         (instrs
          (((id (Instr_id 227))
            (ir (X86 (JMP ((block ((id_hum skipEven) (args ()))) (args ())))))))))
        (skipEven (args ())
         (instrs
          (((id (Instr_id 187))
            (ir
             (X86
              (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg R14) (class_ I64)))))))
           ((id (Instr_id 57))
            (ir (X86 (ADD (Reg ((reg R15) (class_ I64))) (Imm 1)))))
           ((id (Instr_id 228))
            (ir
             (X86_terminal
              ((CMP (Imm 1) (Imm 0))
               (JNE
                ((block ((id_hum intermediate_skipEven_to_innerCheck) (args ())))
                 (args ()))
                (((block ((id_hum intermediate_skipEven_to_innerExit) (args ())))
                  (args ())))))))))))
        (intermediate_skipEven_to_innerCheck (args ())
         (instrs
          (((id (Instr_id 188))
            (ir
             (X86
              (MOV (Reg ((reg R14) (class_ I64))) (Reg ((reg R15) (class_ I64)))))))
           ((id (Instr_id 125))
            (ir
             (X86
              (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg R13) (class_ I64)))))))
           ((id (Instr_id 229))
            (ir
             (X86
              (JMP
               ((block
                 ((id_hum innerCheck)
                  (args
                   (((name j%1) (type_ I64)) ((name partial%1) (type_ I64))))))
                (args ())))))))))
        (intermediate_skipEven_to_innerExit (args ())
         (instrs
          (((id (Instr_id 189))
            (ir
             (X86
              (MOV (Reg ((reg R14) (class_ I64))) (Reg ((reg R15) (class_ I64)))))))
           ((id (Instr_id 127))
            (ir
             (X86
              (MOV (Reg ((reg R13) (class_ I64))) (Reg ((reg R13) (class_ I64)))))))
           ((id (Instr_id 230))
            (ir
             (X86
              (JMP
               ((block
                 ((id_hum innerExit)
                  (args
                   (((name j%2) (type_ I64)) ((name partial%2) (type_ I64))))))
                (args ())))))))))
        (intermediate_innerCheck_to_innerExit (args ())
         (instrs
          (((id (Instr_id 190))
            (ir
             (X86
              (MOV (Reg ((reg R14) (class_ I64))) (Reg ((reg R14) (class_ I64)))))))
           ((id (Instr_id 129))
            (ir
             (X86
              (MOV (Reg ((reg R13) (class_ I64))) (Reg ((reg R13) (class_ I64)))))))
           ((id (Instr_id 231))
            (ir
             (X86
              (JMP
               ((block
                 ((id_hum innerExit)
                  (args
                   (((name j%2) (type_ I64)) ((name partial%2) (type_ I64))))))
                (args ())))))))))
        (intermediate_outerBody_to_outerInc (args ())
         (instrs
          (((id (Instr_id 191))
            (ir
             (X86
              (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg R9) (class_ I64)))))))
           ((id (Instr_id 232))
            (ir
             (X86
              (JMP
               ((block ((id_hum outerInc) (args (((name total%1) (type_ I64))))))
                (args ())))))))))
        (intermediate_outerCheck_to_exit (args ())
         (instrs
          (((id (Instr_id 192))
            (ir
             (X86
              (MOV (Reg ((reg R14) (class_ I64))) (Reg ((reg R14) (class_ I64)))))))
           ((id (Instr_id 132))
            (ir
             (X86
              (MOV (Reg ((reg R14) (class_ I64))) (Reg ((reg R13) (class_ I64)))))))
           ((id (Instr_id 133))
            (ir
             (X86
              (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg R9) (class_ I64)))))))
           ((id (Instr_id 233))
            (ir
             (X86
              (JMP
               ((block
                 ((id_hum exit)
                  (args
                   (((name total%2) (type_ I64)) ((name j%5) (type_ I64))
                    ((name partial%4) (type_ I64))))))
                (args ())))))))))
        (intermediate_start_to_exit (args ())
         (instrs
          (((id (Instr_id 193))
            (ir
             (X86
              (MOV (Reg ((reg R14) (class_ I64))) (Reg ((reg R14) (class_ I64)))))))
           ((id (Instr_id 135))
            (ir
             (X86
              (MOV (Reg ((reg R14) (class_ I64))) (Reg ((reg R13) (class_ I64)))))))
           ((id (Instr_id 136))
            (ir
             (X86
              (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg R9) (class_ I64)))))))
           ((id (Instr_id 234))
            (ir
             (X86
              (JMP
               ((block
                 ((id_hum exit)
                  (args
                   (((name total%2) (type_ I64)) ((name j%5) (type_ I64))
                    ((name partial%4) (type_ I64))))))
                (args ())))))))))))
      (args ()) (name root) (prologue ()) (epilogue ())
      (bytes_for_clobber_saves 32) (bytes_for_padding 0) (bytes_for_spills 0)
      (bytes_statically_alloca'd 0)))
    |}]
;;

let%expect_test "fib_rec" =
  test Examples.Textual.fib_recursive;
  [%expect
    {|
    (((call_conv Default)
      (root
       ((%root (args (((name arg) (type_ I64))))
         (instrs
          (((id (Instr_id 13))
            (ir
             (Branch
              (Cond (cond (Var (Value_id 0)))
               (if_true ((block ((id_hum check1_) (args ()))) (args ())))
               (if_false
                ((block ((id_hum ret_1) (args (((name m1) (type_ I64))))))
                 (args ((Value_id 1))))))))))))
        (check1_ (args ())
         (instrs
          (((id (Instr_id 15))
            (ir
             (Sub ((dest (Value_id 6)) (src1 (Var (Value_id 0))) (src2 (Lit 1))))))
           ((id (Instr_id 4))
            (ir
             (Branch
              (Cond (cond (Var (Value_id 6)))
               (if_true ((block ((id_hum rec) (args ()))) (args ())))
               (if_false
                ((block ((id_hum ret_1) (args (((name m1) (type_ I64))))))
                 (args ((Value_id 6))))))))))))
        (rec (args ())
         (instrs
          (((id (Instr_id 16))
            (ir
             (Call (fn fib) (results ((Value_id 2))) (args ((Var (Value_id 6)))))))
           ((id (Instr_id 5))
            (ir
             (Sub ((dest (Value_id 3)) (src1 (Var (Value_id 6))) (src2 (Lit 1))))))
           ((id (Instr_id 2))
            (ir
             (Call (fn fib) (results ((Value_id 4))) (args ((Var (Value_id 3)))))))
           ((id (Instr_id 6))
            (ir
             (Add
              ((dest (Value_id 5)) (src1 (Var (Value_id 2)))
               (src2 (Var (Value_id 4)))))))
           ((id (Instr_id 7)) (ir (Return (Var (Value_id 5))))))))
        (ret_1 (args (((name m1) (type_ I64))))
         (instrs (((id (Instr_id 14)) (ir (Return (Lit 1)))))))))
      (args (((name arg) (type_ I64)))) (name fib) (prologue ()) (epilogue ())
      (bytes_for_clobber_saves 0) (bytes_for_padding 0) (bytes_for_spills 0)
      (bytes_statically_alloca'd 0)))
    (((call_conv Default)
      (root
       ((fib__prologue (args (((name arg1) (type_ I64))))
         (instrs
          (((id (Instr_id 34)) (ir (X86 (PUSH (Reg ((reg RBP) (class_ I64)))))))
           ((id (Instr_id 33))
            (ir
             (X86
              (MOV (Reg ((reg RBP) (class_ I64))) (Reg ((reg RSP) (class_ I64)))))))
           ((id (Instr_id 61)) (ir (X86 (PUSH (Reg ((reg R13) (class_ I64)))))))
           ((id (Instr_id 71)) (ir (X86 (PUSH (Reg ((reg R14) (class_ I64)))))))
           ((id (Instr_id 72)) (ir (X86 (PUSH (Reg ((reg R15) (class_ I64)))))))
           ((id (Instr_id 73))
            (ir (X86 (SUB (Reg ((reg RSP) (class_ I64))) (Imm 8)))))
           ((id (Instr_id 74))
            (ir
             (X86
              (MOV (Reg ((reg RDI) (class_ I64))) (Reg ((reg RDI) (class_ I64)))))))
           ((id (Instr_id 75))
            (ir (X86 (Tag_def NOOP (Reg ((reg RBP) (class_ I64)))))))
           ((id (Instr_id 76))
            (ir
             (X86
              (MOV (Reg ((reg R14) (class_ I64))) (Reg ((reg RDI) (class_ I64)))))))
           ((id (Instr_id 16))
            (ir
             (X86
              (JMP
               ((block ((id_hum %root) (args (((name arg) (type_ I64))))))
                (args ())))))))))
        (%root (args (((name arg) (type_ I64))))
         (instrs
          (((id (Instr_id 5))
            (ir
             (X86_terminal
              ((CMP (Reg ((reg R14) (class_ I64))) (Imm 0))
               (JNE
                ((block ((id_hum intermediate_%root_to_check1_) (args ())))
                 (args ()))
                (((block ((id_hum intermediate_%root_to_ret_1) (args ())))
                  (args ())))))))))))
        (intermediate_%root_to_check1_ (args ())
         (instrs
          (((id (Instr_id 2))
            (ir (X86 (JMP ((block ((id_hum check1_) (args ()))) (args ())))))))))
        (check1_ (args ())
         (instrs
          (((id (Instr_id 64))
            (ir
             (X86
              (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg R14) (class_ I64)))))))
           ((id (Instr_id 13))
            (ir (X86 (SUB (Reg ((reg R15) (class_ I64))) (Imm 1)))))
           ((id (Instr_id 66))
            (ir
             (X86_terminal
              ((CMP (Reg ((reg R15) (class_ I64))) (Imm 0))
               (JNE
                ((block ((id_hum intermediate_check1__to_rec) (args ())))
                 (args ()))
                (((block ((id_hum intermediate_check1__to_ret_1) (args ())))
                  (args ())))))))))))
        (intermediate_check1__to_rec (args ())
         (instrs
          (((id (Instr_id 83))
            (ir (X86 (JMP ((block ((id_hum rec) (args ()))) (args ())))))))))
        (rec (args ())
         (instrs
          (((id (Instr_id 4))
            (ir
             (X86
              (MOV (Reg ((reg RDI) (class_ I64))) (Reg ((reg R15) (class_ I64)))))))
           ((id (Instr_id 20))
            (ir
             (X86
              (CALL (fn fib) (results (((reg RAX) (class_ I64))))
               (args ((Reg ((reg R15) (class_ I64)))))))))
           ((id (Instr_id 21))
            (ir
             (X86
              (MOV (Reg ((reg R13) (class_ I64))) (Reg ((reg RAX) (class_ I64)))))))
           ((id (Instr_id 22))
            (ir
             (X86
              (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg R15) (class_ I64)))))))
           ((id (Instr_id 23))
            (ir (X86 (SUB (Reg ((reg R15) (class_ I64))) (Imm 1)))))
           ((id (Instr_id 24))
            (ir
             (X86
              (MOV (Reg ((reg RDI) (class_ I64))) (Reg ((reg R15) (class_ I64)))))))
           ((id (Instr_id 25))
            (ir
             (X86
              (CALL (fn fib) (results (((reg RAX) (class_ I64))))
               (args ((Reg ((reg R15) (class_ I64)))))))))
           ((id (Instr_id 26))
            (ir
             (X86
              (MOV (Reg ((reg R14) (class_ I64))) (Reg ((reg RAX) (class_ I64)))))))
           ((id (Instr_id 27))
            (ir
             (X86
              (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg R13) (class_ I64)))))))
           ((id (Instr_id 28))
            (ir
             (X86
              (ADD (Reg ((reg R15) (class_ I64))) (Reg ((reg R14) (class_ I64)))))))
           ((id (Instr_id 29))
            (ir
             (X86
              (MOV (Reg ((reg RAX) (class_ I64))) (Reg ((reg R15) (class_ I64)))))))
           ((id (Instr_id 84))
            (ir
             (X86_terminal
              ((JMP
                ((block
                  ((id_hum fib__epilogue) (args (((name res__0) (type_ I64))))))
                 (args ()))))))))))
        (fib__epilogue (args (((name res__0) (type_ I64))))
         (instrs
          (((id (Instr_id 67))
            (ir
             (X86
              (MOV (Reg ((reg RAX) (class_ I64))) (Reg ((reg RAX) (class_ I64)))))))
           ((id (Instr_id 77))
            (ir (X86 (SUB (Reg ((reg RBP) (class_ I64))) (Imm 24)))))
           ((id (Instr_id 78))
            (ir
             (X86
              (MOV (Reg ((reg RSP) (class_ I64))) (Reg ((reg RBP) (class_ I64)))))))
           ((id (Instr_id 79)) (ir (X86 (POP ((reg R15) (class_ I64))))))
           ((id (Instr_id 80)) (ir (X86 (POP ((reg R14) (class_ I64))))))
           ((id (Instr_id 81)) (ir (X86 (POP ((reg R13) (class_ I64))))))
           ((id (Instr_id 82)) (ir (X86 (POP ((reg RBP) (class_ I64))))))
           ((id (Instr_id 85)) (ir (X86 (RET ((Reg ((reg RAX) (class_ I64)))))))))))
        (intermediate_check1__to_ret_1 (args ())
         (instrs
          (((id (Instr_id 68))
            (ir
             (X86
              (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg R15) (class_ I64)))))))
           ((id (Instr_id 86))
            (ir
             (X86
              (JMP
               ((block ((id_hum ret_1) (args (((name m1) (type_ I64))))))
                (args ())))))))))
        (ret_1 (args (((name m1) (type_ I64))))
         (instrs
          (((id (Instr_id 69))
            (ir (X86 (MOV (Reg ((reg R15) (class_ I64))) (Imm 1)))))
           ((id (Instr_id 44))
            (ir
             (X86
              (MOV (Reg ((reg RAX) (class_ I64))) (Reg ((reg R15) (class_ I64)))))))
           ((id (Instr_id 87))
            (ir
             (X86_terminal
              ((JMP
                ((block
                  ((id_hum fib__epilogue) (args (((name res__0) (type_ I64))))))
                 (args ()))))))))))
        (intermediate_%root_to_ret_1 (args ())
         (instrs
          (((id (Instr_id 70))
            (ir
             (X86
              (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg R15) (class_ I64)))))))
           ((id (Instr_id 88))
            (ir
             (X86
              (JMP
               ((block ((id_hum ret_1) (args (((name m1) (type_ I64))))))
                (args ())))))))))))
      (args (((name arg) (type_ I64)))) (name fib) (prologue ()) (epilogue ())
      (bytes_for_clobber_saves 24) (bytes_for_padding 8) (bytes_for_spills 0)
      (bytes_statically_alloca'd 0)))
    |}]
;;

let%expect_test "call_chains" =
  test_program Examples.Textual.call_chains;
  [%expect
    {|
    (((call_conv Default)
      (root
       ((%root (args (((name x) (type_ I64))))
         (instrs
          (((id (Instr_id 4))
            (ir
             (Add ((dest (Value_id 1)) (src1 (Var (Value_id 0))) (src2 (Lit 1))))))
           ((id (Instr_id 0))
            (ir
             (Call (fn fourth) (results ((Value_id 2)))
              (args ((Var (Value_id 1)) (Var (Value_id 0)))))))
           ((id (Instr_id 1)) (ir (Return (Var (Value_id 2))))))))))
      (args (((name x) (type_ I64)))) (name first) (prologue ()) (epilogue ())
      (bytes_for_clobber_saves 0) (bytes_for_padding 0) (bytes_for_spills 0)
      (bytes_statically_alloca'd 0))
     ((call_conv Default)
      (root
       ((%root (args (((name p) (type_ I64)) ((name q) (type_ I64))))
         (instrs
          (((id (Instr_id 3))
            (ir
             (Add
              ((dest (Value_id 2)) (src1 (Var (Value_id 1)))
               (src2 (Var (Value_id 0)))))))
           ((id (Instr_id 0)) (ir (Return (Var (Value_id 2))))))))))
      (args (((name p) (type_ I64)) ((name q) (type_ I64)))) (name fourth)
      (prologue ()) (epilogue ()) (bytes_for_clobber_saves 0)
      (bytes_for_padding 0) (bytes_for_spills 0) (bytes_statically_alloca'd 0))
     ((call_conv Default)
      (root
       ((%root (args (((name h) (type_ I64))))
         (instrs
          (((id (Instr_id 3))
            (ir
             (Add ((dest (Value_id 1)) (src1 (Var (Value_id 0))) (src2 (Lit 3))))))
           ((id (Instr_id 0)) (ir (Return (Var (Value_id 1))))))))))
      (args (((name h) (type_ I64)))) (name helper) (prologue ()) (epilogue ())
      (bytes_for_clobber_saves 0) (bytes_for_padding 0) (bytes_for_spills 0)
      (bytes_statically_alloca'd 0))
     ((call_conv Default)
      (root
       ((%root (args (((name init) (type_ I64))))
         (instrs
          (((id (Instr_id 5))
            (ir
             (Call (fn first) (results ((Value_id 1)))
              (args ((Var (Value_id 0)))))))
           ((id (Instr_id 0))
            (ir
             (Call (fn second) (results ((Value_id 2)))
              (args ((Var (Value_id 1)))))))
           ((id (Instr_id 1))
            (ir
             (Call (fn third) (results ((Value_id 3)))
              (args ((Var (Value_id 2)) (Var (Value_id 1)))))))
           ((id (Instr_id 2)) (ir (Return (Var (Value_id 3))))))))))
      (args (((name init) (type_ I64)))) (name root) (prologue ()) (epilogue ())
      (bytes_for_clobber_saves 0) (bytes_for_padding 0) (bytes_for_spills 0)
      (bytes_statically_alloca'd 0))
     ((call_conv Default)
      (root
       ((%root (args (((name y) (type_ I64))))
         (instrs
          (((id (Instr_id 4))
            (ir
             (Call (fn third) (results ((Value_id 1)))
              (args ((Var (Value_id 0)) (Var (Value_id 0)))))))
           ((id (Instr_id 0))
            (ir
             (Add ((dest (Value_id 2)) (src1 (Var (Value_id 1))) (src2 (Lit 2))))))
           ((id (Instr_id 1)) (ir (Return (Var (Value_id 2))))))))))
      (args (((name y) (type_ I64)))) (name second) (prologue ()) (epilogue ())
      (bytes_for_clobber_saves 0) (bytes_for_padding 0) (bytes_for_spills 0)
      (bytes_statically_alloca'd 0))
     ((call_conv Default)
      (root
       ((%root (args (((name u) (type_ I64)) ((name v) (type_ I64))))
         (instrs
          (((id (Instr_id 4))
            (ir
             (Add
              ((dest (Value_id 2)) (src1 (Var (Value_id 1)))
               (src2 (Var (Value_id 0)))))))
           ((id (Instr_id 0))
            (ir
             (Call (fn helper) (results ((Value_id 3)))
              (args ((Var (Value_id 2)))))))
           ((id (Instr_id 1)) (ir (Return (Var (Value_id 3))))))))))
      (args (((name u) (type_ I64)) ((name v) (type_ I64)))) (name third)
      (prologue ()) (epilogue ()) (bytes_for_clobber_saves 0)
      (bytes_for_padding 0) (bytes_for_spills 0) (bytes_statically_alloca'd 0)))
    (((call_conv Default)
      (root
       ((first__prologue (args (((name x2) (type_ I64))))
         (instrs
          (((id (Instr_id 14)) (ir (X86 (PUSH (Reg ((reg RBP) (class_ I64)))))))
           ((id (Instr_id 13))
            (ir
             (X86
              (MOV (Reg ((reg RBP) (class_ I64))) (Reg ((reg RSP) (class_ I64)))))))
           ((id (Instr_id 23)) (ir (X86 (PUSH (Reg ((reg R14) (class_ I64)))))))
           ((id (Instr_id 26)) (ir (X86 (PUSH (Reg ((reg R15) (class_ I64)))))))
           ((id (Instr_id 27))
            (ir
             (X86
              (MOV (Reg ((reg RDI) (class_ I64))) (Reg ((reg RDI) (class_ I64)))))))
           ((id (Instr_id 28))
            (ir (X86 (Tag_def NOOP (Reg ((reg RBP) (class_ I64)))))))
           ((id (Instr_id 29))
            (ir
             (X86
              (MOV (Reg ((reg R14) (class_ I64))) (Reg ((reg RDI) (class_ I64)))))))
           ((id (Instr_id 4))
            (ir
             (X86
              (JMP
               ((block ((id_hum %root) (args (((name x) (type_ I64))))))
                (args ())))))))))
        (%root (args (((name x) (type_ I64))))
         (instrs
          (((id (Instr_id 5))
            (ir
             (X86
              (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg R14) (class_ I64)))))))
           ((id (Instr_id 1))
            (ir (X86 (ADD (Reg ((reg R15) (class_ I64))) (Imm 1)))))
           ((id (Instr_id 6))
            (ir
             (X86
              (MOV (Reg ((reg RDI) (class_ I64))) (Reg ((reg R15) (class_ I64)))))))
           ((id (Instr_id 7))
            (ir
             (X86
              (MOV (Reg ((reg RSI) (class_ I64))) (Reg ((reg R14) (class_ I64)))))))
           ((id (Instr_id 8))
            (ir
             (X86
              (CALL (fn fourth) (results (((reg RAX) (class_ I64))))
               (args
                ((Reg ((reg R15) (class_ I64))) (Reg ((reg R14) (class_ I64)))))))))
           ((id (Instr_id 9))
            (ir
             (X86
              (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg RAX) (class_ I64)))))))
           ((id (Instr_id 10))
            (ir
             (X86
              (MOV (Reg ((reg RAX) (class_ I64))) (Reg ((reg R15) (class_ I64)))))))
           ((id (Instr_id 24))
            (ir
             (X86_terminal
              ((JMP
                ((block
                  ((id_hum first__epilogue) (args (((name res__0) (type_ I64))))))
                 (args ()))))))))))
        (first__epilogue (args (((name res__0) (type_ I64))))
         (instrs
          (((id (Instr_id 25))
            (ir
             (X86
              (MOV (Reg ((reg RAX) (class_ I64))) (Reg ((reg RAX) (class_ I64)))))))
           ((id (Instr_id 30))
            (ir (X86 (SUB (Reg ((reg RBP) (class_ I64))) (Imm 16)))))
           ((id (Instr_id 31))
            (ir
             (X86
              (MOV (Reg ((reg RSP) (class_ I64))) (Reg ((reg RBP) (class_ I64)))))))
           ((id (Instr_id 32)) (ir (X86 (POP ((reg R15) (class_ I64))))))
           ((id (Instr_id 33)) (ir (X86 (POP ((reg R14) (class_ I64))))))
           ((id (Instr_id 34)) (ir (X86 (POP ((reg RBP) (class_ I64))))))
           ((id (Instr_id 35)) (ir (X86 (RET ((Reg ((reg RAX) (class_ I64)))))))))))))
      (args (((name x) (type_ I64)))) (name first) (prologue ()) (epilogue ())
      (bytes_for_clobber_saves 16) (bytes_for_padding 0) (bytes_for_spills 0)
      (bytes_statically_alloca'd 0))
     ((call_conv Default)
      (root
       ((fourth__prologue
         (args (((name p0) (type_ I64)) ((name q0) (type_ I64))))
         (instrs
          (((id (Instr_id 13)) (ir (X86 (PUSH (Reg ((reg RBP) (class_ I64)))))))
           ((id (Instr_id 9))
            (ir
             (X86
              (MOV (Reg ((reg RBP) (class_ I64))) (Reg ((reg RSP) (class_ I64)))))))
           ((id (Instr_id 8)) (ir (X86 (PUSH (Reg ((reg R14) (class_ I64)))))))
           ((id (Instr_id 7)) (ir (X86 (PUSH (Reg ((reg R15) (class_ I64)))))))
           ((id (Instr_id 19))
            (ir
             (X86
              (MOV (Reg ((reg RDI) (class_ I64))) (Reg ((reg RDI) (class_ I64)))))))
           ((id (Instr_id 22))
            (ir
             (X86
              (MOV (Reg ((reg RSI) (class_ I64))) (Reg ((reg RSI) (class_ I64)))))))
           ((id (Instr_id 23))
            (ir (X86 (Tag_def NOOP (Reg ((reg RBP) (class_ I64)))))))
           ((id (Instr_id 24))
            (ir
             (X86
              (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg RDI) (class_ I64)))))))
           ((id (Instr_id 25))
            (ir
             (X86
              (MOV (Reg ((reg R14) (class_ I64))) (Reg ((reg RSI) (class_ I64)))))))
           ((id (Instr_id 31))
            (ir
             (X86
              (JMP
               ((block
                 ((id_hum %root)
                  (args (((name p) (type_ I64)) ((name q) (type_ I64))))))
                (args ())))))))))
        (%root (args (((name p) (type_ I64)) ((name q) (type_ I64))))
         (instrs
          (((id (Instr_id 20))
            (ir
             (X86
              (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg R15) (class_ I64)))))))
           ((id (Instr_id 4))
            (ir
             (X86
              (ADD (Reg ((reg R15) (class_ I64))) (Reg ((reg R14) (class_ I64)))))))
           ((id (Instr_id 0))
            (ir
             (X86
              (MOV (Reg ((reg RAX) (class_ I64))) (Reg ((reg R15) (class_ I64)))))))
           ((id (Instr_id 32))
            (ir
             (X86_terminal
              ((JMP
                ((block
                  ((id_hum fourth__epilogue)
                   (args (((name res__0) (type_ I64))))))
                 (args ()))))))))))
        (fourth__epilogue (args (((name res__0) (type_ I64))))
         (instrs
          (((id (Instr_id 21))
            (ir
             (X86
              (MOV (Reg ((reg RAX) (class_ I64))) (Reg ((reg RAX) (class_ I64)))))))
           ((id (Instr_id 26))
            (ir (X86 (SUB (Reg ((reg RBP) (class_ I64))) (Imm 16)))))
           ((id (Instr_id 27))
            (ir
             (X86
              (MOV (Reg ((reg RSP) (class_ I64))) (Reg ((reg RBP) (class_ I64)))))))
           ((id (Instr_id 28)) (ir (X86 (POP ((reg R15) (class_ I64))))))
           ((id (Instr_id 29)) (ir (X86 (POP ((reg R14) (class_ I64))))))
           ((id (Instr_id 30)) (ir (X86 (POP ((reg RBP) (class_ I64))))))
           ((id (Instr_id 33)) (ir (X86 (RET ((Reg ((reg RAX) (class_ I64)))))))))))))
      (args (((name p) (type_ I64)) ((name q) (type_ I64)))) (name fourth)
      (prologue ()) (epilogue ()) (bytes_for_clobber_saves 16)
      (bytes_for_padding 0) (bytes_for_spills 0) (bytes_statically_alloca'd 0))
     ((call_conv Default)
      (root
       ((helper__prologue (args (((name h0) (type_ I64))))
         (instrs
          (((id (Instr_id 8)) (ir (X86 (PUSH (Reg ((reg RBP) (class_ I64)))))))
           ((id (Instr_id 7))
            (ir
             (X86
              (MOV (Reg ((reg RBP) (class_ I64))) (Reg ((reg RSP) (class_ I64)))))))
           ((id (Instr_id 17)) (ir (X86 (PUSH (Reg ((reg R15) (class_ I64)))))))
           ((id (Instr_id 20))
            (ir (X86 (SUB (Reg ((reg RSP) (class_ I64))) (Imm 8)))))
           ((id (Instr_id 21))
            (ir
             (X86
              (MOV (Reg ((reg RDI) (class_ I64))) (Reg ((reg RDI) (class_ I64)))))))
           ((id (Instr_id 22))
            (ir (X86 (Tag_def NOOP (Reg ((reg RBP) (class_ I64)))))))
           ((id (Instr_id 23))
            (ir
             (X86
              (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg RDI) (class_ I64)))))))
           ((id (Instr_id 28))
            (ir
             (X86
              (JMP
               ((block ((id_hum %root) (args (((name h) (type_ I64))))))
                (args ())))))))))
        (%root (args (((name h) (type_ I64))))
         (instrs
          (((id (Instr_id 18))
            (ir
             (X86
              (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg R15) (class_ I64)))))))
           ((id (Instr_id 4))
            (ir (X86 (ADD (Reg ((reg R15) (class_ I64))) (Imm 3)))))
           ((id (Instr_id 0))
            (ir
             (X86
              (MOV (Reg ((reg RAX) (class_ I64))) (Reg ((reg R15) (class_ I64)))))))
           ((id (Instr_id 29))
            (ir
             (X86_terminal
              ((JMP
                ((block
                  ((id_hum helper__epilogue)
                   (args (((name res__0) (type_ I64))))))
                 (args ()))))))))))
        (helper__epilogue (args (((name res__0) (type_ I64))))
         (instrs
          (((id (Instr_id 19))
            (ir
             (X86
              (MOV (Reg ((reg RAX) (class_ I64))) (Reg ((reg RAX) (class_ I64)))))))
           ((id (Instr_id 24))
            (ir (X86 (SUB (Reg ((reg RBP) (class_ I64))) (Imm 8)))))
           ((id (Instr_id 25))
            (ir
             (X86
              (MOV (Reg ((reg RSP) (class_ I64))) (Reg ((reg RBP) (class_ I64)))))))
           ((id (Instr_id 26)) (ir (X86 (POP ((reg R15) (class_ I64))))))
           ((id (Instr_id 27)) (ir (X86 (POP ((reg RBP) (class_ I64))))))
           ((id (Instr_id 30)) (ir (X86 (RET ((Reg ((reg RAX) (class_ I64)))))))))))))
      (args (((name h) (type_ I64)))) (name helper) (prologue ()) (epilogue ())
      (bytes_for_clobber_saves 8) (bytes_for_padding 8) (bytes_for_spills 0)
      (bytes_statically_alloca'd 0))
     ((call_conv Default)
      (root
       ((root__prologue (args (((name init1) (type_ I64))))
         (instrs
          (((id (Instr_id 22)) (ir (X86 (PUSH (Reg ((reg RBP) (class_ I64)))))))
           ((id (Instr_id 21))
            (ir
             (X86
              (MOV (Reg ((reg RBP) (class_ I64))) (Reg ((reg RSP) (class_ I64)))))))
           ((id (Instr_id 31)) (ir (X86 (PUSH (Reg ((reg R14) (class_ I64)))))))
           ((id (Instr_id 34)) (ir (X86 (PUSH (Reg ((reg R15) (class_ I64)))))))
           ((id (Instr_id 35))
            (ir
             (X86
              (MOV (Reg ((reg RDI) (class_ I64))) (Reg ((reg RDI) (class_ I64)))))))
           ((id (Instr_id 36))
            (ir (X86 (Tag_def NOOP (Reg ((reg RBP) (class_ I64)))))))
           ((id (Instr_id 37))
            (ir
             (X86
              (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg RDI) (class_ I64)))))))
           ((id (Instr_id 7))
            (ir
             (X86
              (JMP
               ((block ((id_hum %root) (args (((name init) (type_ I64))))))
                (args ())))))))))
        (%root (args (((name init) (type_ I64))))
         (instrs
          (((id (Instr_id 8))
            (ir
             (X86
              (MOV (Reg ((reg RDI) (class_ I64))) (Reg ((reg R15) (class_ I64)))))))
           ((id (Instr_id 9))
            (ir
             (X86
              (CALL (fn first) (results (((reg RAX) (class_ I64))))
               (args ((Reg ((reg R15) (class_ I64)))))))))
           ((id (Instr_id 10))
            (ir
             (X86
              (MOV (Reg ((reg R14) (class_ I64))) (Reg ((reg RAX) (class_ I64)))))))
           ((id (Instr_id 11))
            (ir
             (X86
              (MOV (Reg ((reg RDI) (class_ I64))) (Reg ((reg R14) (class_ I64)))))))
           ((id (Instr_id 12))
            (ir
             (X86
              (CALL (fn second) (results (((reg RAX) (class_ I64))))
               (args ((Reg ((reg R14) (class_ I64)))))))))
           ((id (Instr_id 13))
            (ir
             (X86
              (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg RAX) (class_ I64)))))))
           ((id (Instr_id 14))
            (ir
             (X86
              (MOV (Reg ((reg RDI) (class_ I64))) (Reg ((reg R15) (class_ I64)))))))
           ((id (Instr_id 15))
            (ir
             (X86
              (MOV (Reg ((reg RSI) (class_ I64))) (Reg ((reg R14) (class_ I64)))))))
           ((id (Instr_id 16))
            (ir
             (X86
              (CALL (fn third) (results (((reg RAX) (class_ I64))))
               (args
                ((Reg ((reg R15) (class_ I64))) (Reg ((reg R14) (class_ I64)))))))))
           ((id (Instr_id 17))
            (ir
             (X86
              (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg RAX) (class_ I64)))))))
           ((id (Instr_id 18))
            (ir
             (X86
              (MOV (Reg ((reg RAX) (class_ I64))) (Reg ((reg R15) (class_ I64)))))))
           ((id (Instr_id 2))
            (ir
             (X86_terminal
              ((JMP
                ((block
                  ((id_hum root__epilogue) (args (((name res__0) (type_ I64))))))
                 (args ()))))))))))
        (root__epilogue (args (((name res__0) (type_ I64))))
         (instrs
          (((id (Instr_id 33))
            (ir
             (X86
              (MOV (Reg ((reg RAX) (class_ I64))) (Reg ((reg RAX) (class_ I64)))))))
           ((id (Instr_id 38))
            (ir (X86 (SUB (Reg ((reg RBP) (class_ I64))) (Imm 16)))))
           ((id (Instr_id 39))
            (ir
             (X86
              (MOV (Reg ((reg RSP) (class_ I64))) (Reg ((reg RBP) (class_ I64)))))))
           ((id (Instr_id 40)) (ir (X86 (POP ((reg R15) (class_ I64))))))
           ((id (Instr_id 41)) (ir (X86 (POP ((reg R14) (class_ I64))))))
           ((id (Instr_id 42)) (ir (X86 (POP ((reg RBP) (class_ I64))))))
           ((id (Instr_id 6)) (ir (X86 (RET ((Reg ((reg RAX) (class_ I64)))))))))))))
      (args (((name init) (type_ I64)))) (name root) (prologue ()) (epilogue ())
      (bytes_for_clobber_saves 16) (bytes_for_padding 0) (bytes_for_spills 0)
      (bytes_statically_alloca'd 0))
     ((call_conv Default)
      (root
       ((second__prologue (args (((name y3) (type_ I64))))
         (instrs
          (((id (Instr_id 14)) (ir (X86 (PUSH (Reg ((reg RBP) (class_ I64)))))))
           ((id (Instr_id 13))
            (ir
             (X86
              (MOV (Reg ((reg RBP) (class_ I64))) (Reg ((reg RSP) (class_ I64)))))))
           ((id (Instr_id 23)) (ir (X86 (PUSH (Reg ((reg R15) (class_ I64)))))))
           ((id (Instr_id 26))
            (ir (X86 (SUB (Reg ((reg RSP) (class_ I64))) (Imm 8)))))
           ((id (Instr_id 27))
            (ir
             (X86
              (MOV (Reg ((reg RDI) (class_ I64))) (Reg ((reg RDI) (class_ I64)))))))
           ((id (Instr_id 28))
            (ir (X86 (Tag_def NOOP (Reg ((reg RBP) (class_ I64)))))))
           ((id (Instr_id 29))
            (ir
             (X86
              (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg RDI) (class_ I64)))))))
           ((id (Instr_id 4))
            (ir
             (X86
              (JMP
               ((block ((id_hum %root) (args (((name y) (type_ I64))))))
                (args ())))))))))
        (%root (args (((name y) (type_ I64))))
         (instrs
          (((id (Instr_id 5))
            (ir
             (X86
              (MOV (Reg ((reg RDI) (class_ I64))) (Reg ((reg R15) (class_ I64)))))))
           ((id (Instr_id 1))
            (ir
             (X86
              (MOV (Reg ((reg RSI) (class_ I64))) (Reg ((reg R15) (class_ I64)))))))
           ((id (Instr_id 6))
            (ir
             (X86
              (CALL (fn third) (results (((reg RAX) (class_ I64))))
               (args
                ((Reg ((reg R15) (class_ I64))) (Reg ((reg R15) (class_ I64)))))))))
           ((id (Instr_id 7))
            (ir
             (X86
              (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg RAX) (class_ I64)))))))
           ((id (Instr_id 8))
            (ir
             (X86
              (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg R15) (class_ I64)))))))
           ((id (Instr_id 9))
            (ir (X86 (ADD (Reg ((reg R15) (class_ I64))) (Imm 2)))))
           ((id (Instr_id 10))
            (ir
             (X86
              (MOV (Reg ((reg RAX) (class_ I64))) (Reg ((reg R15) (class_ I64)))))))
           ((id (Instr_id 24))
            (ir
             (X86_terminal
              ((JMP
                ((block
                  ((id_hum second__epilogue)
                   (args (((name res__0) (type_ I64))))))
                 (args ()))))))))))
        (second__epilogue (args (((name res__0) (type_ I64))))
         (instrs
          (((id (Instr_id 25))
            (ir
             (X86
              (MOV (Reg ((reg RAX) (class_ I64))) (Reg ((reg RAX) (class_ I64)))))))
           ((id (Instr_id 30))
            (ir (X86 (SUB (Reg ((reg RBP) (class_ I64))) (Imm 8)))))
           ((id (Instr_id 31))
            (ir
             (X86
              (MOV (Reg ((reg RSP) (class_ I64))) (Reg ((reg RBP) (class_ I64)))))))
           ((id (Instr_id 32)) (ir (X86 (POP ((reg R15) (class_ I64))))))
           ((id (Instr_id 33)) (ir (X86 (POP ((reg RBP) (class_ I64))))))
           ((id (Instr_id 34)) (ir (X86 (RET ((Reg ((reg RAX) (class_ I64)))))))))))))
      (args (((name y) (type_ I64)))) (name second) (prologue ()) (epilogue ())
      (bytes_for_clobber_saves 8) (bytes_for_padding 8) (bytes_for_spills 0)
      (bytes_statically_alloca'd 0))
     ((call_conv Default)
      (root
       ((third__prologue (args (((name u0) (type_ I64)) ((name v0) (type_ I64))))
         (instrs
          (((id (Instr_id 18)) (ir (X86 (PUSH (Reg ((reg RBP) (class_ I64)))))))
           ((id (Instr_id 14))
            (ir
             (X86
              (MOV (Reg ((reg RBP) (class_ I64))) (Reg ((reg RSP) (class_ I64)))))))
           ((id (Instr_id 13)) (ir (X86 (PUSH (Reg ((reg R14) (class_ I64)))))))
           ((id (Instr_id 12)) (ir (X86 (PUSH (Reg ((reg R15) (class_ I64)))))))
           ((id (Instr_id 24))
            (ir
             (X86
              (MOV (Reg ((reg RDI) (class_ I64))) (Reg ((reg RDI) (class_ I64)))))))
           ((id (Instr_id 27))
            (ir
             (X86
              (MOV (Reg ((reg RSI) (class_ I64))) (Reg ((reg RSI) (class_ I64)))))))
           ((id (Instr_id 28))
            (ir (X86 (Tag_def NOOP (Reg ((reg RBP) (class_ I64)))))))
           ((id (Instr_id 29))
            (ir
             (X86
              (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg RDI) (class_ I64)))))))
           ((id (Instr_id 30))
            (ir
             (X86
              (MOV (Reg ((reg R14) (class_ I64))) (Reg ((reg RSI) (class_ I64)))))))
           ((id (Instr_id 4))
            (ir
             (X86
              (JMP
               ((block
                 ((id_hum %root)
                  (args (((name u) (type_ I64)) ((name v) (type_ I64))))))
                (args ())))))))))
        (%root (args (((name u) (type_ I64)) ((name v) (type_ I64))))
         (instrs
          (((id (Instr_id 5))
            (ir
             (X86
              (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg R15) (class_ I64)))))))
           ((id (Instr_id 1))
            (ir
             (X86
              (ADD (Reg ((reg R15) (class_ I64))) (Reg ((reg R14) (class_ I64)))))))
           ((id (Instr_id 6))
            (ir
             (X86
              (MOV (Reg ((reg RDI) (class_ I64))) (Reg ((reg R15) (class_ I64)))))))
           ((id (Instr_id 7))
            (ir
             (X86
              (CALL (fn helper) (results (((reg RAX) (class_ I64))))
               (args ((Reg ((reg R15) (class_ I64)))))))))
           ((id (Instr_id 8))
            (ir
             (X86
              (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg RAX) (class_ I64)))))))
           ((id (Instr_id 9))
            (ir
             (X86
              (MOV (Reg ((reg RAX) (class_ I64))) (Reg ((reg R15) (class_ I64)))))))
           ((id (Instr_id 25))
            (ir
             (X86_terminal
              ((JMP
                ((block
                  ((id_hum third__epilogue) (args (((name res__0) (type_ I64))))))
                 (args ()))))))))))
        (third__epilogue (args (((name res__0) (type_ I64))))
         (instrs
          (((id (Instr_id 26))
            (ir
             (X86
              (MOV (Reg ((reg RAX) (class_ I64))) (Reg ((reg RAX) (class_ I64)))))))
           ((id (Instr_id 31))
            (ir (X86 (SUB (Reg ((reg RBP) (class_ I64))) (Imm 16)))))
           ((id (Instr_id 32))
            (ir
             (X86
              (MOV (Reg ((reg RSP) (class_ I64))) (Reg ((reg RBP) (class_ I64)))))))
           ((id (Instr_id 33)) (ir (X86 (POP ((reg R15) (class_ I64))))))
           ((id (Instr_id 34)) (ir (X86 (POP ((reg R14) (class_ I64))))))
           ((id (Instr_id 35)) (ir (X86 (POP ((reg RBP) (class_ I64))))))
           ((id (Instr_id 36)) (ir (X86 (RET ((Reg ((reg RAX) (class_ I64)))))))))))))
      (args (((name u) (type_ I64)) ((name v) (type_ I64)))) (name third)
      (prologue ()) (epilogue ()) (bytes_for_clobber_saves 16)
      (bytes_for_padding 0) (bytes_for_spills 0) (bytes_statically_alloca'd 0)))
    |}]
;;

let%expect_test "fib" =
  test Examples.Textual.fib;
  [%expect
    {|
    (((call_conv Default)
      (root
       ((%root (args ())
         (instrs
          (((id (Instr_id 20)) (ir (Move (Value_id 0) (Lit 10))))
           ((id (Instr_id 4))
            (ir
             (Branch (Uncond ((block ((id_hum fib_start) (args ()))) (args ())))))))))
        (fib_start (args ())
         (instrs
          (((id (Instr_id 21)) (ir (Move (Value_id 1) (Var (Value_id 0)))))
           ((id (Instr_id 6)) (ir (Move (Value_id 2) (Lit 0))))
           ((id (Instr_id 0)) (ir (Move (Value_id 3) (Lit 1))))
           ((id (Instr_id 7))
            (ir
             (Branch
              (Uncond
               ((block
                 ((id_hum fib_check)
                  (args
                   (((name b%0) (type_ I64)) ((name count%0) (type_ I64))
                    ((name a%0) (type_ I64))))))
                (args ((Value_id 3) (Value_id 1) (Value_id 2)))))))))))
        (fib_check
         (args
          (((name b%0) (type_ I64)) ((name count%0) (type_ I64))
           ((name a%0) (type_ I64))))
         (instrs
          (((id (Instr_id 22))
            (ir
             (Branch
              (Cond (cond (Var (Value_id 6)))
               (if_true ((block ((id_hum fib_body) (args ()))) (args ())))
               (if_false ((block ((id_hum fib_exit) (args ()))) (args ()))))))))))
        (fib_body (args ())
         (instrs
          (((id (Instr_id 23))
            (ir
             (Add
              ((dest (Value_id 4)) (src1 (Var (Value_id 7)))
               (src2 (Var (Value_id 5)))))))
           ((id (Instr_id 1)) (ir (Move (Value_id 8) (Var (Value_id 5)))))
           ((id (Instr_id 2)) (ir (Move (Value_id 9) (Var (Value_id 4)))))
           ((id (Instr_id 10))
            (ir
             (Sub
              ((dest (Value_id 10)) (src1 (Var (Value_id 6))) (src2 (Lit 1))))))
           ((id (Instr_id 11))
            (ir
             (Branch
              (Uncond
               ((block
                 ((id_hum fib_check)
                  (args
                   (((name b%0) (type_ I64)) ((name count%0) (type_ I64))
                    ((name a%0) (type_ I64))))))
                (args ((Value_id 9) (Value_id 10) (Value_id 8)))))))))))
        (fib_exit (args ())
         (instrs (((id (Instr_id 24)) (ir (Return (Var (Value_id 7))))))))))
      (args ()) (name root) (prologue ()) (epilogue ())
      (bytes_for_clobber_saves 0) (bytes_for_padding 0) (bytes_for_spills 0)
      (bytes_statically_alloca'd 0)))
    (((call_conv Default)
      (root
       ((root__prologue (args ())
         (instrs
          (((id (Instr_id 56)) (ir (X86 (PUSH (Reg ((reg RBP) (class_ I64)))))))
           ((id (Instr_id 65))
            (ir
             (X86
              (MOV (Reg ((reg RBP) (class_ I64))) (Reg ((reg RSP) (class_ I64)))))))
           ((id (Instr_id 66)) (ir (X86 (PUSH (Reg ((reg R12) (class_ I64)))))))
           ((id (Instr_id 67)) (ir (X86 (PUSH (Reg ((reg R13) (class_ I64)))))))
           ((id (Instr_id 68)) (ir (X86 (PUSH (Reg ((reg R14) (class_ I64)))))))
           ((id (Instr_id 69)) (ir (X86 (PUSH (Reg ((reg R15) (class_ I64)))))))
           ((id (Instr_id 70))
            (ir (X86 (Tag_def NOOP (Reg ((reg RBP) (class_ I64)))))))
           ((id (Instr_id 78))
            (ir (X86 (JMP ((block ((id_hum %root) (args ()))) (args ())))))))))
        (%root (args ())
         (instrs
          (((id (Instr_id 57))
            (ir (X86 (MOV (Reg ((reg R15) (class_ I64))) (Imm 10)))))
           ((id (Instr_id 79))
            (ir
             (X86_terminal
              ((JMP ((block ((id_hum fib_start) (args ()))) (args ()))))))))))
        (fib_start (args ())
         (instrs
          (((id (Instr_id 58))
            (ir
             (X86
              (MOV (Reg ((reg R12) (class_ I64))) (Reg ((reg R15) (class_ I64)))))))
           ((id (Instr_id 6))
            (ir (X86 (MOV (Reg ((reg R14) (class_ I64))) (Imm 0)))))
           ((id (Instr_id 21))
            (ir (X86 (MOV (Reg ((reg R15) (class_ I64))) (Imm 1)))))
           ((id (Instr_id 4))
            (ir
             (X86
              (MOV (Reg ((reg R13) (class_ I64))) (Reg ((reg R14) (class_ I64)))))))
           ((id (Instr_id 40))
            (ir
             (X86
              (MOV (Reg ((reg R14) (class_ I64))) (Reg ((reg R15) (class_ I64)))))))
           ((id (Instr_id 41))
            (ir
             (X86
              (MOV (Reg ((reg R12) (class_ I64))) (Reg ((reg R12) (class_ I64)))))))
           ((id (Instr_id 80))
            (ir
             (X86_terminal
              ((JMP
                ((block
                  ((id_hum fib_check)
                   (args
                    (((name b%0) (type_ I64)) ((name count%0) (type_ I64))
                     ((name a%0) (type_ I64))))))
                 (args ()))))))))))
        (fib_check
         (args
          (((name b%0) (type_ I64)) ((name count%0) (type_ I64))
           ((name a%0) (type_ I64))))
         (instrs
          (((id (Instr_id 81))
            (ir
             (X86_terminal
              ((CMP (Reg ((reg R12) (class_ I64))) (Imm 0))
               (JNE
                ((block ((id_hum intermediate_fib_check_to_fib_body) (args ())))
                 (args ()))
                (((block ((id_hum intermediate_fib_check_to_fib_exit) (args ())))
                  (args ())))))))))))
        (intermediate_fib_check_to_fib_body (args ())
         (instrs
          (((id (Instr_id 82))
            (ir (X86 (JMP ((block ((id_hum fib_body) (args ()))) (args ())))))))))
        (fib_body (args ())
         (instrs
          (((id (Instr_id 61))
            (ir
             (X86
              (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg R13) (class_ I64)))))))
           ((id (Instr_id 2))
            (ir
             (X86
              (ADD (Reg ((reg R15) (class_ I64))) (Reg ((reg R14) (class_ I64)))))))
           ((id (Instr_id 1))
            (ir
             (X86
              (MOV (Reg ((reg R13) (class_ I64))) (Reg ((reg R14) (class_ I64)))))))
           ((id (Instr_id 23))
            (ir
             (X86
              (MOV (Reg ((reg R14) (class_ I64))) (Reg ((reg R15) (class_ I64)))))))
           ((id (Instr_id 22))
            (ir
             (X86
              (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg R12) (class_ I64)))))))
           ((id (Instr_id 28))
            (ir (X86 (SUB (Reg ((reg R15) (class_ I64))) (Imm 1)))))
           ((id (Instr_id 29))
            (ir
             (X86
              (MOV (Reg ((reg R13) (class_ I64))) (Reg ((reg R13) (class_ I64)))))))
           ((id (Instr_id 43))
            (ir
             (X86
              (MOV (Reg ((reg R14) (class_ I64))) (Reg ((reg R14) (class_ I64)))))))
           ((id (Instr_id 44))
            (ir
             (X86
              (MOV (Reg ((reg R12) (class_ I64))) (Reg ((reg R15) (class_ I64)))))))
           ((id (Instr_id 83))
            (ir
             (X86_terminal
              ((JMP
                ((block
                  ((id_hum fib_check)
                   (args
                    (((name b%0) (type_ I64)) ((name count%0) (type_ I64))
                     ((name a%0) (type_ I64))))))
                 (args ()))))))))))
        (intermediate_fib_check_to_fib_exit (args ())
         (instrs
          (((id (Instr_id 84))
            (ir (X86 (JMP ((block ((id_hum fib_exit) (args ()))) (args ())))))))))
        (fib_exit (args ())
         (instrs
          (((id (Instr_id 63))
            (ir
             (X86
              (MOV (Reg ((reg RAX) (class_ I64))) (Reg ((reg R13) (class_ I64)))))))
           ((id (Instr_id 85))
            (ir
             (X86_terminal
              ((JMP
                ((block
                  ((id_hum root__epilogue) (args (((name res__0) (type_ I64))))))
                 (args ()))))))))))
        (root__epilogue (args (((name res__0) (type_ I64))))
         (instrs
          (((id (Instr_id 64))
            (ir
             (X86
              (MOV (Reg ((reg RAX) (class_ I64))) (Reg ((reg RAX) (class_ I64)))))))
           ((id (Instr_id 71))
            (ir (X86 (SUB (Reg ((reg RBP) (class_ I64))) (Imm 32)))))
           ((id (Instr_id 72))
            (ir
             (X86
              (MOV (Reg ((reg RSP) (class_ I64))) (Reg ((reg RBP) (class_ I64)))))))
           ((id (Instr_id 73)) (ir (X86 (POP ((reg R15) (class_ I64))))))
           ((id (Instr_id 74)) (ir (X86 (POP ((reg R14) (class_ I64))))))
           ((id (Instr_id 75)) (ir (X86 (POP ((reg R13) (class_ I64))))))
           ((id (Instr_id 76)) (ir (X86 (POP ((reg R12) (class_ I64))))))
           ((id (Instr_id 77)) (ir (X86 (POP ((reg RBP) (class_ I64))))))
           ((id (Instr_id 86)) (ir (X86 (RET ((Reg ((reg RAX) (class_ I64)))))))))))))
      (args ()) (name root) (prologue ()) (epilogue ())
      (bytes_for_clobber_saves 32) (bytes_for_padding 0) (bytes_for_spills 0)
      (bytes_statically_alloca'd 0)))
    |}]
;;

let%expect_test "sum 100" =
  test Examples.Textual.sum_100;
  [%expect
    {|
    (((call_conv Default)
      (root
       ((start (args ())
         (instrs
          (((id (Instr_id 18)) (ir (Move (Value_id 0) (Lit 1))))
           ((id (Instr_id 3)) (ir (Move (Value_id 1) (Lit 0))))
           ((id (Instr_id 4))
            (ir
             (Branch
              (Cond (cond (Lit 1))
               (if_true
                ((block
                  ((id_hum check)
                   (args (((name i%1) (type_ I64)) ((name sum%1) (type_ I64))))))
                 (args ((Value_id 0) (Value_id 1)))))
               (if_false
                ((block
                  ((id_hum exit)
                   (args (((name i%0) (type_ I64)) ((name sum%0) (type_ I64))))))
                 (args ((Value_id 0) (Value_id 1))))))))))))
        (check (args (((name i%1) (type_ I64)) ((name sum%1) (type_ I64))))
         (instrs
          (((id (Instr_id 20))
            (ir
             (Sub
              ((dest (Value_id 2)) (src1 (Var (Value_id 5))) (src2 (Lit 100))))))
           ((id (Instr_id 6))
            (ir
             (Branch
              (Cond (cond (Var (Value_id 2)))
               (if_true ((block ((id_hum body) (args ()))) (args ())))
               (if_false
                ((block
                  ((id_hum exit)
                   (args (((name i%0) (type_ I64)) ((name sum%0) (type_ I64))))))
                 (args ((Value_id 5) (Value_id 6))))))))))))
        (body (args ())
         (instrs
          (((id (Instr_id 21))
            (ir
             (Add
              ((dest (Value_id 7)) (src1 (Var (Value_id 6)))
               (src2 (Var (Value_id 5)))))))
           ((id (Instr_id 7))
            (ir
             (Add ((dest (Value_id 8)) (src1 (Var (Value_id 5))) (src2 (Lit 1))))))
           ((id (Instr_id 1))
            (ir
             (Branch
              (Cond (cond (Lit 1))
               (if_true
                ((block
                  ((id_hum check)
                   (args (((name i%1) (type_ I64)) ((name sum%1) (type_ I64))))))
                 (args ((Value_id 8) (Value_id 7)))))
               (if_false
                ((block
                  ((id_hum exit)
                   (args (((name i%0) (type_ I64)) ((name sum%0) (type_ I64))))))
                 (args ((Value_id 8) (Value_id 7))))))))))))
        (exit (args (((name i%0) (type_ I64)) ((name sum%0) (type_ I64))))
         (instrs (((id (Instr_id 19)) (ir (Return (Var (Value_id 4))))))))))
      (args ()) (name root) (prologue ()) (epilogue ())
      (bytes_for_clobber_saves 0) (bytes_for_padding 0) (bytes_for_spills 0)
      (bytes_statically_alloca'd 0)))
    (((call_conv Default)
      (root
       ((root__prologue (args ())
         (instrs
          (((id (Instr_id 66)) (ir (X86 (PUSH (Reg ((reg RBP) (class_ I64)))))))
           ((id (Instr_id 78))
            (ir
             (X86
              (MOV (Reg ((reg RBP) (class_ I64))) (Reg ((reg RSP) (class_ I64)))))))
           ((id (Instr_id 79)) (ir (X86 (PUSH (Reg ((reg R13) (class_ I64)))))))
           ((id (Instr_id 80)) (ir (X86 (PUSH (Reg ((reg R14) (class_ I64)))))))
           ((id (Instr_id 81)) (ir (X86 (PUSH (Reg ((reg R15) (class_ I64)))))))
           ((id (Instr_id 82))
            (ir (X86 (SUB (Reg ((reg RSP) (class_ I64))) (Imm 8)))))
           ((id (Instr_id 83))
            (ir (X86 (Tag_def NOOP (Reg ((reg RBP) (class_ I64)))))))
           ((id (Instr_id 90))
            (ir (X86 (JMP ((block ((id_hum start) (args ()))) (args ())))))))))
        (start (args ())
         (instrs
          (((id (Instr_id 67))
            (ir (X86 (MOV (Reg ((reg R14) (class_ I64))) (Imm 1)))))
           ((id (Instr_id 18))
            (ir (X86 (MOV (Reg ((reg R15) (class_ I64))) (Imm 0)))))
           ((id (Instr_id 91))
            (ir
             (X86_terminal
              ((CMP (Imm 1) (Imm 0))
               (JNE
                ((block ((id_hum intermediate_start_to_check) (args ())))
                 (args ()))
                (((block ((id_hum intermediate_start_to_exit) (args ())))
                  (args ())))))))))))
        (intermediate_start_to_check (args ())
         (instrs
          (((id (Instr_id 68))
            (ir
             (X86
              (MOV (Reg ((reg R14) (class_ I64))) (Reg ((reg R14) (class_ I64)))))))
           ((id (Instr_id 43))
            (ir
             (X86
              (MOV (Reg ((reg R13) (class_ I64))) (Reg ((reg R15) (class_ I64)))))))
           ((id (Instr_id 92))
            (ir
             (X86
              (JMP
               ((block
                 ((id_hum check)
                  (args (((name i%1) (type_ I64)) ((name sum%1) (type_ I64))))))
                (args ())))))))))
        (check (args (((name i%1) (type_ I64)) ((name sum%1) (type_ I64))))
         (instrs
          (((id (Instr_id 69))
            (ir
             (X86
              (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg R14) (class_ I64)))))))
           ((id (Instr_id 4))
            (ir (X86 (SUB (Reg ((reg R15) (class_ I64))) (Imm 100)))))
           ((id (Instr_id 93))
            (ir
             (X86_terminal
              ((CMP (Reg ((reg R15) (class_ I64))) (Imm 0))
               (JNE
                ((block ((id_hum intermediate_check_to_body) (args ())))
                 (args ()))
                (((block ((id_hum intermediate_check_to_exit) (args ())))
                  (args ())))))))))))
        (intermediate_check_to_body (args ())
         (instrs
          (((id (Instr_id 94))
            (ir (X86 (JMP ((block ((id_hum body) (args ()))) (args ())))))))))
        (body (args ())
         (instrs
          (((id (Instr_id 71))
            (ir
             (X86
              (MOV (Reg ((reg R13) (class_ I64))) (Reg ((reg R13) (class_ I64)))))))
           ((id (Instr_id 21))
            (ir
             (X86
              (ADD (Reg ((reg R13) (class_ I64))) (Reg ((reg R14) (class_ I64)))))))
           ((id (Instr_id 6))
            (ir
             (X86
              (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg R14) (class_ I64)))))))
           ((id (Instr_id 25))
            (ir (X86 (ADD (Reg ((reg R15) (class_ I64))) (Imm 1)))))
           ((id (Instr_id 95))
            (ir
             (X86_terminal
              ((CMP (Imm 1) (Imm 0))
               (JNE
                ((block ((id_hum intermediate_body_to_check) (args ())))
                 (args ()))
                (((block ((id_hum intermediate_body_to_exit) (args ())))
                  (args ())))))))))))
        (intermediate_body_to_check (args ())
         (instrs
          (((id (Instr_id 72))
            (ir
             (X86
              (MOV (Reg ((reg R14) (class_ I64))) (Reg ((reg R15) (class_ I64)))))))
           ((id (Instr_id 45))
            (ir
             (X86
              (MOV (Reg ((reg R13) (class_ I64))) (Reg ((reg R13) (class_ I64)))))))
           ((id (Instr_id 96))
            (ir
             (X86
              (JMP
               ((block
                 ((id_hum check)
                  (args (((name i%1) (type_ I64)) ((name sum%1) (type_ I64))))))
                (args ())))))))))
        (intermediate_body_to_exit (args ())
         (instrs
          (((id (Instr_id 73))
            (ir
             (X86
              (MOV (Reg ((reg R14) (class_ I64))) (Reg ((reg R15) (class_ I64)))))))
           ((id (Instr_id 47))
            (ir
             (X86
              (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg R13) (class_ I64)))))))
           ((id (Instr_id 97))
            (ir
             (X86
              (JMP
               ((block
                 ((id_hum exit)
                  (args (((name i%0) (type_ I64)) ((name sum%0) (type_ I64))))))
                (args ())))))))))
        (exit (args (((name i%0) (type_ I64)) ((name sum%0) (type_ I64))))
         (instrs
          (((id (Instr_id 74))
            (ir
             (X86
              (MOV (Reg ((reg RAX) (class_ I64))) (Reg ((reg R15) (class_ I64)))))))
           ((id (Instr_id 98))
            (ir
             (X86_terminal
              ((JMP
                ((block
                  ((id_hum root__epilogue) (args (((name res__0) (type_ I64))))))
                 (args ()))))))))))
        (root__epilogue (args (((name res__0) (type_ I64))))
         (instrs
          (((id (Instr_id 75))
            (ir
             (X86
              (MOV (Reg ((reg RAX) (class_ I64))) (Reg ((reg RAX) (class_ I64)))))))
           ((id (Instr_id 84))
            (ir (X86 (SUB (Reg ((reg RBP) (class_ I64))) (Imm 24)))))
           ((id (Instr_id 85))
            (ir
             (X86
              (MOV (Reg ((reg RSP) (class_ I64))) (Reg ((reg RBP) (class_ I64)))))))
           ((id (Instr_id 86)) (ir (X86 (POP ((reg R15) (class_ I64))))))
           ((id (Instr_id 87)) (ir (X86 (POP ((reg R14) (class_ I64))))))
           ((id (Instr_id 88)) (ir (X86 (POP ((reg R13) (class_ I64))))))
           ((id (Instr_id 89)) (ir (X86 (POP ((reg RBP) (class_ I64))))))
           ((id (Instr_id 99)) (ir (X86 (RET ((Reg ((reg RAX) (class_ I64)))))))))))
        (intermediate_check_to_exit (args ())
         (instrs
          (((id (Instr_id 76))
            (ir
             (X86
              (MOV (Reg ((reg R14) (class_ I64))) (Reg ((reg R14) (class_ I64)))))))
           ((id (Instr_id 50))
            (ir
             (X86
              (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg R13) (class_ I64)))))))
           ((id (Instr_id 100))
            (ir
             (X86
              (JMP
               ((block
                 ((id_hum exit)
                  (args (((name i%0) (type_ I64)) ((name sum%0) (type_ I64))))))
                (args ())))))))))
        (intermediate_start_to_exit (args ())
         (instrs
          (((id (Instr_id 77))
            (ir
             (X86
              (MOV (Reg ((reg R14) (class_ I64))) (Reg ((reg R14) (class_ I64)))))))
           ((id (Instr_id 52))
            (ir
             (X86
              (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg R15) (class_ I64)))))))
           ((id (Instr_id 101))
            (ir
             (X86
              (JMP
               ((block
                 ((id_hum exit)
                  (args (((name i%0) (type_ I64)) ((name sum%0) (type_ I64))))))
                (args ())))))))))))
      (args ()) (name root) (prologue ()) (epilogue ())
      (bytes_for_clobber_saves 24) (bytes_for_padding 8) (bytes_for_spills 0)
      (bytes_statically_alloca'd 0)))
    |}]
;;
