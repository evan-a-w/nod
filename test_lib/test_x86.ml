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
          ((Move ((name x) (type_ I64)) (Lit 10))
           (Move ((name y) (type_ I64)) (Lit 20))
           (Sub
            ((dest ((name z) (type_ I64))) (src1 (Var ((name y) (type_ I64))))
             (src2 (Var ((name x) (type_ I64))))))
           (Return (Var ((name z) (type_ I64)))))))))
      (args ()) (name root) (prologue ()) (epilogue ())
      (bytes_for_clobber_saves 0) (bytes_for_padding 0) (bytes_for_spills 0)
      (bytes_statically_alloca'd 0)))
    (((call_conv Default)
      (root
       ((root__prologue (args ())
         (instrs
          ((X86 (PUSH (Reg ((reg RBP) (class_ I64)))))
           (X86
            (MOV (Reg ((reg RBP) (class_ I64))) (Reg ((reg RSP) (class_ I64)))))
           (X86 (PUSH (Reg ((reg R14) (class_ I64)))))
           (X86 (PUSH (Reg ((reg R15) (class_ I64)))))
           (X86 (Tag_def NOOP (Reg ((reg RBP) (class_ I64)))))
           (X86 (JMP ((block ((id_hum a) (args ()))) (args ())))))))
        (a (args ())
         (instrs
          ((X86 (MOV (Reg ((reg R14) (class_ I64))) (Imm 10)))
           (X86 (MOV (Reg ((reg R15) (class_ I64))) (Imm 20)))
           (X86
            (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg R15) (class_ I64)))))
           (X86
            (SUB (Reg ((reg R15) (class_ I64))) (Reg ((reg R14) (class_ I64)))))
           (X86
            (MOV (Reg ((reg RAX) (class_ I64))) (Reg ((reg R15) (class_ I64)))))
           (X86_terminal
            ((JMP
              ((block
                ((id_hum root__epilogue) (args (((name res__0) (type_ I64))))))
               (args ()))))))))
        (root__epilogue (args (((name res__0) (type_ I64))))
         (instrs
          ((X86
            (MOV (Reg ((reg RAX) (class_ I64))) (Reg ((reg RAX) (class_ I64)))))
           (X86 (SUB (Reg ((reg RBP) (class_ I64))) (Imm 16)))
           (X86
            (MOV (Reg ((reg RSP) (class_ I64))) (Reg ((reg RBP) (class_ I64)))))
           (X86 (POP ((reg R15) (class_ I64))))
           (X86 (POP ((reg R14) (class_ I64))))
           (X86 (POP ((reg RBP) (class_ I64))))
           (X86 (RET ((Reg ((reg RAX) (class_ I64)))))))))))
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
          ((Move ((name x) (type_ I64)) (Lit 10))
           (Move ((name y) (type_ I64)) (Lit 20))
           (Sub
            ((dest ((name z) (type_ I64))) (src1 (Var ((name y) (type_ I64))))
             (src2 (Var ((name x) (type_ I64))))))
           (Branch
            (Cond (cond (Lit 1))
             (if_true ((block ((id_hum b) (args ()))) (args ())))
             (if_false ((block ((id_hum c) (args ()))) (args ()))))))))
        (b (args ())
         (instrs
          ((Add
            ((dest ((name z%2) (type_ I64))) (src1 (Var ((name z) (type_ I64))))
             (src2 (Lit 5))))
           (Branch
            (Cond (cond (Lit 1))
             (if_true
              ((block ((id_hum end) (args (((name z%0) (type_ I64))))))
               (args (((name z%2) (type_ I64))))))
             (if_false
              ((block ((id_hum end) (args (((name z%0) (type_ I64))))))
               (args (((name z%2) (type_ I64)))))))))))
        (end (args (((name z%0) (type_ I64))))
         (instrs ((Return (Var ((name z%0) (type_ I64)))))))
        (c (args ())
         (instrs
          ((Move ((name z%1) (type_ I64)) (Lit 0))
           (Branch
            (Cond (cond (Lit 1))
             (if_true
              ((block ((id_hum end) (args (((name z%0) (type_ I64))))))
               (args (((name z%1) (type_ I64))))))
             (if_false
              ((block ((id_hum end) (args (((name z%0) (type_ I64))))))
               (args (((name z%1) (type_ I64)))))))))))))
      (args ()) (name root) (prologue ()) (epilogue ())
      (bytes_for_clobber_saves 0) (bytes_for_padding 0) (bytes_for_spills 0)
      (bytes_statically_alloca'd 0)))
    (((call_conv Default)
      (root
       ((root__prologue (args ())
         (instrs
          ((X86 (PUSH (Reg ((reg RBP) (class_ I64)))))
           (X86
            (MOV (Reg ((reg RBP) (class_ I64))) (Reg ((reg RSP) (class_ I64)))))
           (X86 (PUSH (Reg ((reg R14) (class_ I64)))))
           (X86 (PUSH (Reg ((reg R15) (class_ I64)))))
           (X86 (Tag_def NOOP (Reg ((reg RBP) (class_ I64)))))
           (X86 (JMP ((block ((id_hum a) (args ()))) (args ())))))))
        (a (args ())
         (instrs
          ((X86 (MOV (Reg ((reg R14) (class_ I64))) (Imm 10)))
           (X86 (MOV (Reg ((reg R15) (class_ I64))) (Imm 20)))
           (X86
            (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg R15) (class_ I64)))))
           (X86
            (SUB (Reg ((reg R15) (class_ I64))) (Reg ((reg R14) (class_ I64)))))
           (X86_terminal
            ((CMP (Imm 1) (Imm 0))
             (JNE ((block ((id_hum intermediate_a_to_b) (args ()))) (args ()))
              (((block ((id_hum intermediate_a_to_c) (args ()))) (args ())))))))))
        (intermediate_a_to_b (args ())
         (instrs ((X86 (JMP ((block ((id_hum b) (args ()))) (args ())))))))
        (b (args ())
         (instrs
          ((X86
            (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg R15) (class_ I64)))))
           (X86 (ADD (Reg ((reg R15) (class_ I64))) (Imm 5)))
           (X86_terminal
            ((CMP (Imm 1) (Imm 0))
             (JNE ((block ((id_hum intermediate_b_to_end0) (args ()))) (args ()))
              (((block ((id_hum intermediate_b_to_end) (args ()))) (args ())))))))))
        (intermediate_b_to_end0 (args ())
         (instrs
          ((X86
            (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg R15) (class_ I64)))))
           (X86
            (JMP
             ((block ((id_hum end) (args (((name z%0) (type_ I64)))))) (args ())))))))
        (end (args (((name z%0) (type_ I64))))
         (instrs
          ((X86
            (MOV (Reg ((reg RAX) (class_ I64))) (Reg ((reg R15) (class_ I64)))))
           (X86_terminal
            ((JMP
              ((block
                ((id_hum root__epilogue) (args (((name res__0) (type_ I64))))))
               (args ()))))))))
        (root__epilogue (args (((name res__0) (type_ I64))))
         (instrs
          ((X86
            (MOV (Reg ((reg RAX) (class_ I64))) (Reg ((reg RAX) (class_ I64)))))
           (X86 (SUB (Reg ((reg RBP) (class_ I64))) (Imm 16)))
           (X86
            (MOV (Reg ((reg RSP) (class_ I64))) (Reg ((reg RBP) (class_ I64)))))
           (X86 (POP ((reg R15) (class_ I64))))
           (X86 (POP ((reg R14) (class_ I64))))
           (X86 (POP ((reg RBP) (class_ I64))))
           (X86 (RET ((Reg ((reg RAX) (class_ I64)))))))))
        (intermediate_b_to_end (args ())
         (instrs
          ((X86
            (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg R15) (class_ I64)))))
           (X86
            (JMP
             ((block ((id_hum end) (args (((name z%0) (type_ I64)))))) (args ())))))))
        (intermediate_a_to_c (args ())
         (instrs ((X86 (JMP ((block ((id_hum c) (args ()))) (args ())))))))
        (c (args ())
         (instrs
          ((X86 (MOV (Reg ((reg R15) (class_ I64))) (Imm 0)))
           (X86_terminal
            ((CMP (Imm 1) (Imm 0))
             (JNE ((block ((id_hum intermediate_c_to_end0) (args ()))) (args ()))
              (((block ((id_hum intermediate_c_to_end) (args ()))) (args ())))))))))
        (intermediate_c_to_end0 (args ())
         (instrs
          ((X86
            (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg R15) (class_ I64)))))
           (X86
            (JMP
             ((block ((id_hum end) (args (((name z%0) (type_ I64)))))) (args ())))))))
        (intermediate_c_to_end (args ())
         (instrs
          ((X86
            (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg R15) (class_ I64)))))
           (X86
            (JMP
             ((block ((id_hum end) (args (((name z%0) (type_ I64)))))) (args ())))))))))
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
          ((Move ((name x) (type_ I64)) (Lit 7))
           (Move ((name y) (type_ I64)) (Lit 2))
           (Mul
            ((dest ((name x%0) (type_ I64))) (src1 (Var ((name x) (type_ I64))))
             (src2 (Lit 3))))
           (Div
            ((dest ((name x%1) (type_ I64)))
             (src1 (Var ((name x%0) (type_ I64))))
             (src2 (Var ((name y) (type_ I64))))))
           (Sub
            ((dest ((name cond) (type_ I64))) (src1 (Var ((name y) (type_ I64))))
             (src2 (Lit 2))))
           (Branch
            (Cond (cond (Var ((name cond) (type_ I64))))
             (if_true ((block ((id_hum ifTrue) (args ()))) (args ())))
             (if_false ((block ((id_hum ifFalse) (args ()))) (args ()))))))))
        (ifTrue (args ())
         (instrs
          ((Move ((name x%4) (type_ I64)) (Lit 999))
           (Branch
            (Cond (cond (Lit 1))
             (if_true
              ((block ((id_hum end) (args (((name x%2) (type_ I64))))))
               (args (((name x%4) (type_ I64))))))
             (if_false
              ((block ((id_hum end) (args (((name x%2) (type_ I64))))))
               (args (((name x%4) (type_ I64)))))))))))
        (end (args (((name x%2) (type_ I64))))
         (instrs ((Return (Var ((name x%2) (type_ I64)))))))
        (ifFalse (args ())
         (instrs
          ((Add
            ((dest ((name x%3) (type_ I64)))
             (src1 (Var ((name x%1) (type_ I64)))) (src2 (Lit 10))))
           (Branch
            (Cond (cond (Lit 1))
             (if_true
              ((block ((id_hum end) (args (((name x%2) (type_ I64))))))
               (args (((name x%3) (type_ I64))))))
             (if_false
              ((block ((id_hum end) (args (((name x%2) (type_ I64))))))
               (args (((name x%3) (type_ I64)))))))))))))
      (args ()) (name root) (prologue ()) (epilogue ())
      (bytes_for_clobber_saves 0) (bytes_for_padding 0) (bytes_for_spills 0)
      (bytes_statically_alloca'd 0)))
    (((call_conv Default)
      (root
       ((root__prologue (args ())
         (instrs
          ((X86 (PUSH (Reg ((reg RBP) (class_ I64)))))
           (X86
            (MOV (Reg ((reg RBP) (class_ I64))) (Reg ((reg RSP) (class_ I64)))))
           (X86 (PUSH (Reg ((reg R13) (class_ I64)))))
           (X86 (PUSH (Reg ((reg R14) (class_ I64)))))
           (X86 (PUSH (Reg ((reg R15) (class_ I64)))))
           (X86 (SUB (Reg ((reg RSP) (class_ I64))) (Imm 8)))
           (X86 (Tag_def NOOP (Reg ((reg RBP) (class_ I64)))))
           (X86 (JMP ((block ((id_hum start) (args ()))) (args ())))))))
        (start (args ())
         (instrs
          ((X86 (MOV (Reg ((reg R14) (class_ I64))) (Imm 7)))
           (X86 (MOV (Reg ((reg R13) (class_ I64))) (Imm 2)))
           (X86 (MOV (Reg ((reg R15) (class_ I64))) (Imm 3)))
           (X86
            (MOV (Reg ((reg RAX) (class_ I64))) (Reg ((reg R14) (class_ I64)))))
           (X86
            (Tag_def
             (Tag_def
              (Tag_use (IMUL (Reg ((reg R15) (class_ I64))))
               (Reg ((reg RAX) (class_ I64))))
              (Reg ((reg RAX) (class_ I64))))
             (Reg ((reg RDX) (class_ I64)))))
           (X86
            (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg RAX) (class_ I64)))))
           (X86
            (MOV (Reg ((reg RAX) (class_ I64))) (Reg ((reg R15) (class_ I64)))))
           (X86
            (Tag_def
             (Tag_def
              (Tag_use (IDIV (Reg ((reg R13) (class_ I64))))
               (Reg ((reg RAX) (class_ I64))))
              (Reg ((reg RAX) (class_ I64))))
             (Reg ((reg RDX) (class_ I64)))))
           (X86
            (MOV (Reg ((reg R14) (class_ I64))) (Reg ((reg RAX) (class_ I64)))))
           (X86
            (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg R13) (class_ I64)))))
           (X86 (SUB (Reg ((reg R15) (class_ I64))) (Imm 2)))
           (X86_terminal
            ((CMP (Reg ((reg R15) (class_ I64))) (Imm 0))
             (JNE
              ((block ((id_hum intermediate_start_to_ifTrue) (args ())))
               (args ()))
              (((block ((id_hum intermediate_start_to_ifFalse) (args ())))
                (args ())))))))))
        (intermediate_start_to_ifTrue (args ())
         (instrs ((X86 (JMP ((block ((id_hum ifTrue) (args ()))) (args ())))))))
        (ifTrue (args ())
         (instrs
          ((X86 (MOV (Reg ((reg R15) (class_ I64))) (Imm 999)))
           (X86_terminal
            ((CMP (Imm 1) (Imm 0))
             (JNE
              ((block ((id_hum intermediate_ifTrue_to_end0) (args ())))
               (args ()))
              (((block ((id_hum intermediate_ifTrue_to_end) (args ())))
                (args ())))))))))
        (intermediate_ifTrue_to_end0 (args ())
         (instrs
          ((X86
            (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg R15) (class_ I64)))))
           (X86
            (JMP
             ((block ((id_hum end) (args (((name x%2) (type_ I64)))))) (args ())))))))
        (end (args (((name x%2) (type_ I64))))
         (instrs
          ((X86
            (MOV (Reg ((reg RAX) (class_ I64))) (Reg ((reg R15) (class_ I64)))))
           (X86_terminal
            ((JMP
              ((block
                ((id_hum root__epilogue) (args (((name res__0) (type_ I64))))))
               (args ()))))))))
        (root__epilogue (args (((name res__0) (type_ I64))))
         (instrs
          ((X86
            (MOV (Reg ((reg RAX) (class_ I64))) (Reg ((reg RAX) (class_ I64)))))
           (X86 (SUB (Reg ((reg RBP) (class_ I64))) (Imm 24)))
           (X86
            (MOV (Reg ((reg RSP) (class_ I64))) (Reg ((reg RBP) (class_ I64)))))
           (X86 (POP ((reg R15) (class_ I64))))
           (X86 (POP ((reg R14) (class_ I64))))
           (X86 (POP ((reg R13) (class_ I64))))
           (X86 (POP ((reg RBP) (class_ I64))))
           (X86 (RET ((Reg ((reg RAX) (class_ I64)))))))))
        (intermediate_ifTrue_to_end (args ())
         (instrs
          ((X86
            (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg R15) (class_ I64)))))
           (X86
            (JMP
             ((block ((id_hum end) (args (((name x%2) (type_ I64)))))) (args ())))))))
        (intermediate_start_to_ifFalse (args ())
         (instrs ((X86 (JMP ((block ((id_hum ifFalse) (args ()))) (args ())))))))
        (ifFalse (args ())
         (instrs
          ((X86
            (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg R14) (class_ I64)))))
           (X86 (ADD (Reg ((reg R15) (class_ I64))) (Imm 10)))
           (X86_terminal
            ((CMP (Imm 1) (Imm 0))
             (JNE
              ((block ((id_hum intermediate_ifFalse_to_end0) (args ())))
               (args ()))
              (((block ((id_hum intermediate_ifFalse_to_end) (args ())))
                (args ())))))))))
        (intermediate_ifFalse_to_end0 (args ())
         (instrs
          ((X86
            (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg R15) (class_ I64)))))
           (X86
            (JMP
             ((block ((id_hum end) (args (((name x%2) (type_ I64)))))) (args ())))))))
        (intermediate_ifFalse_to_end (args ())
         (instrs
          ((X86
            (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg R15) (class_ I64)))))
           (X86
            (JMP
             ((block ((id_hum end) (args (((name x%2) (type_ I64)))))) (args ())))))))))
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
          ((Move ((name a) (type_ I64)) (Lit 100))
           (Move ((name b) (type_ I64)) (Lit 6))
           (Mod
            ((dest ((name res) (type_ I64))) (src1 (Var ((name a) (type_ I64))))
             (src2 (Var ((name b) (type_ I64))))))
           (Add
            ((dest ((name res%0) (type_ I64)))
             (src1 (Var ((name res) (type_ I64)))) (src2 (Lit 1))))
           (Return (Var ((name res%0) (type_ I64)))))))))
      (args ()) (name root) (prologue ()) (epilogue ())
      (bytes_for_clobber_saves 0) (bytes_for_padding 0) (bytes_for_spills 0)
      (bytes_statically_alloca'd 0)))
    (((call_conv Default)
      (root
       ((root__prologue (args ())
         (instrs
          ((X86 (PUSH (Reg ((reg RBP) (class_ I64)))))
           (X86
            (MOV (Reg ((reg RBP) (class_ I64))) (Reg ((reg RSP) (class_ I64)))))
           (X86 (PUSH (Reg ((reg R14) (class_ I64)))))
           (X86 (PUSH (Reg ((reg R15) (class_ I64)))))
           (X86 (Tag_def NOOP (Reg ((reg RBP) (class_ I64)))))
           (X86 (JMP ((block ((id_hum entry) (args ()))) (args ())))))))
        (entry (args ())
         (instrs
          ((X86 (MOV (Reg ((reg R14) (class_ I64))) (Imm 100)))
           (X86 (MOV (Reg ((reg R15) (class_ I64))) (Imm 6)))
           (X86
            (MOV (Reg ((reg RAX) (class_ I64))) (Reg ((reg R14) (class_ I64)))))
           (X86
            (Tag_def
             (Tag_def
              (Tag_use (MOD (Reg ((reg R15) (class_ I64))))
               (Reg ((reg RAX) (class_ I64))))
              (Reg ((reg RDX) (class_ I64))))
             (Reg ((reg RAX) (class_ I64)))))
           (X86
            (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg RDX) (class_ I64)))))
           (X86
            (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg R15) (class_ I64)))))
           (X86 (ADD (Reg ((reg R15) (class_ I64))) (Imm 1)))
           (X86
            (MOV (Reg ((reg RAX) (class_ I64))) (Reg ((reg R15) (class_ I64)))))
           (X86_terminal
            ((JMP
              ((block
                ((id_hum root__epilogue) (args (((name res__0) (type_ I64))))))
               (args ()))))))))
        (root__epilogue (args (((name res__0) (type_ I64))))
         (instrs
          ((X86
            (MOV (Reg ((reg RAX) (class_ I64))) (Reg ((reg RAX) (class_ I64)))))
           (X86 (SUB (Reg ((reg RBP) (class_ I64))) (Imm 16)))
           (X86
            (MOV (Reg ((reg RSP) (class_ I64))) (Reg ((reg RBP) (class_ I64)))))
           (X86 (POP ((reg R15) (class_ I64))))
           (X86 (POP ((reg R14) (class_ I64))))
           (X86 (POP ((reg RBP) (class_ I64))))
           (X86 (RET ((Reg ((reg RAX) (class_ I64)))))))))))
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
          ((Move ((name n) (type_ I64)) (Lit 24))
           (Alloca ((dest ((name ptr) (type_ Ptr))) (size (Lit 16))))
           (Alloca
            ((dest ((name dyn) (type_ Ptr))) (size (Var ((name n) (type_ I64))))))
           (Return (Var ((name dyn) (type_ Ptr)))))))))
      (args ()) (name root) (prologue ()) (epilogue ())
      (bytes_for_clobber_saves 0) (bytes_for_padding 0) (bytes_for_spills 0)
      (bytes_statically_alloca'd 0)))
    (((call_conv Default)
      (root
       ((root__prologue (args ())
         (instrs
          ((X86 (PUSH (Reg ((reg RBP) (class_ I64)))))
           (X86
            (MOV (Reg ((reg RBP) (class_ I64))) (Reg ((reg RSP) (class_ I64)))))
           (X86 (PUSH (Reg ((reg R14) (class_ I64)))))
           (X86 (PUSH (Reg ((reg R15) (class_ I64)))))
           (X86 (SUB (Reg ((reg RSP) (class_ I64))) (Imm 16)))
           (X86 (Tag_def NOOP (Reg ((reg RBP) (class_ I64)))))
           (X86 (JMP ((block ((id_hum %root) (args ()))) (args ())))))))
        (%root (args ())
         (instrs
          ((X86 (MOV (Reg ((reg R14) (class_ I64))) (Imm 24)))
           (X86_terminal
            ((MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg RBP) (class_ I64))))
             (SUB (Reg ((reg R15) (class_ I64))) (Imm 32))))
           (X86
            (SUB (Reg ((reg RSP) (class_ I64))) (Reg ((reg R14) (class_ I64)))))
           (X86
            (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg RSP) (class_ I64)))))
           (X86
            (MOV (Reg ((reg RAX) (class_ I64))) (Reg ((reg R15) (class_ I64)))))
           (X86_terminal
            ((JMP
              ((block
                ((id_hum root__epilogue) (args (((name res__0) (type_ I64))))))
               (args ()))))))))
        (root__epilogue (args (((name res__0) (type_ I64))))
         (instrs
          ((X86
            (MOV (Reg ((reg RAX) (class_ I64))) (Reg ((reg RAX) (class_ I64)))))
           (X86 (SUB (Reg ((reg RBP) (class_ I64))) (Imm 16)))
           (X86
            (MOV (Reg ((reg RSP) (class_ I64))) (Reg ((reg RBP) (class_ I64)))))
           (X86 (POP ((reg R15) (class_ I64))))
           (X86 (POP ((reg R14) (class_ I64))))
           (X86 (POP ((reg RBP) (class_ I64))))
           (X86 (RET ((Reg ((reg RAX) (class_ I64)))))))))))
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
          ((Move ((name n) (type_ I64)) (Lit 7))
           (Move ((name i) (type_ I64)) (Lit 0))
           (Move ((name total) (type_ I64)) (Lit 0))
           (Branch
            (Cond (cond (Lit 1))
             (if_true
              ((block
                ((id_hum outerCheck)
                 (args
                  (((name i%0) (type_ I64)) ((name j) (type_ I64))
                   ((name partial) (type_ I64))))))
               (args
                (((name i) (type_ I64)) ((name j) (type_ I64))
                 ((name partial) (type_ I64))))))
             (if_false
              ((block
                ((id_hum exit)
                 (args
                  (((name total%2) (type_ I64)) ((name j%5) (type_ I64))
                   ((name partial%4) (type_ I64))))))
               (args
                (((name total) (type_ I64)) ((name j) (type_ I64))
                 ((name partial) (type_ I64)))))))))))
        (outerCheck
         (args
          (((name i%0) (type_ I64)) ((name j) (type_ I64))
           ((name partial) (type_ I64))))
         (instrs
          ((Sub
            ((dest ((name condOuter) (type_ I64)))
             (src1 (Var ((name i%0) (type_ I64))))
             (src2 (Var ((name n) (type_ I64))))))
           (Branch
            (Cond (cond (Var ((name condOuter) (type_ I64))))
             (if_true ((block ((id_hum outerBody) (args ()))) (args ())))
             (if_false
              ((block
                ((id_hum exit)
                 (args
                  (((name total%2) (type_ I64)) ((name j%5) (type_ I64))
                   ((name partial%4) (type_ I64))))))
               (args
                (((name total) (type_ I64)) ((name j) (type_ I64))
                 ((name partial) (type_ I64)))))))))))
        (outerBody (args ())
         (instrs
          ((Move ((name j%0) (type_ I64)) (Lit 0))
           (Move ((name partial%0) (type_ I64)) (Lit 0))
           (Branch
            (Cond (cond (Lit 1))
             (if_true
              ((block
                ((id_hum innerCheck)
                 (args (((name j%1) (type_ I64)) ((name partial%1) (type_ I64))))))
               (args (((name j%0) (type_ I64)) ((name partial%0) (type_ I64))))))
             (if_false
              ((block ((id_hum outerInc) (args (((name total%1) (type_ I64))))))
               (args (((name total) (type_ I64)))))))))))
        (innerCheck
         (args (((name j%1) (type_ I64)) ((name partial%1) (type_ I64))))
         (instrs
          ((Sub
            ((dest ((name condInner) (type_ I64)))
             (src1 (Var ((name j%1) (type_ I64)))) (src2 (Lit 3))))
           (Branch
            (Cond (cond (Var ((name condInner) (type_ I64))))
             (if_true ((block ((id_hum innerBody) (args ()))) (args ())))
             (if_false
              ((block
                ((id_hum innerExit)
                 (args (((name j%2) (type_ I64)) ((name partial%2) (type_ I64))))))
               (args (((name j%1) (type_ I64)) ((name partial%1) (type_ I64)))))))))))
        (innerBody (args ())
         (instrs
          ((And
            ((dest ((name isEven) (type_ I64)))
             (src1 (Var ((name j%1) (type_ I64)))) (src2 (Lit 1))))
           (Sub
            ((dest ((name condSkip) (type_ I64)))
             (src1 (Var ((name isEven) (type_ I64)))) (src2 (Lit 0))))
           (Branch
            (Cond (cond (Var ((name condSkip) (type_ I64))))
             (if_true ((block ((id_hum doWork) (args ()))) (args ())))
             (if_false ((block ((id_hum skipEven) (args ()))) (args ()))))))))
        (doWork (args ())
         (instrs
          ((Mul
            ((dest ((name tmp) (type_ I64)))
             (src1 (Var ((name i%0) (type_ I64))))
             (src2 (Var ((name j%1) (type_ I64))))))
           (Add
            ((dest ((name partial%3) (type_ I64)))
             (src1 (Var ((name partial%1) (type_ I64))))
             (src2 (Var ((name tmp) (type_ I64))))))
           (Add
            ((dest ((name j%3) (type_ I64)))
             (src1 (Var ((name j%1) (type_ I64)))) (src2 (Lit 1))))
           (Branch
            (Cond (cond (Lit 1))
             (if_true
              ((block
                ((id_hum innerCheck)
                 (args (((name j%1) (type_ I64)) ((name partial%1) (type_ I64))))))
               (args (((name j%3) (type_ I64)) ((name partial%3) (type_ I64))))))
             (if_false
              ((block
                ((id_hum innerExit)
                 (args (((name j%2) (type_ I64)) ((name partial%2) (type_ I64))))))
               (args (((name j%3) (type_ I64)) ((name partial%3) (type_ I64)))))))))))
        (innerExit
         (args (((name j%2) (type_ I64)) ((name partial%2) (type_ I64))))
         (instrs
          ((Add
            ((dest ((name total%0) (type_ I64)))
             (src1 (Var ((name total) (type_ I64))))
             (src2 (Var ((name partial%2) (type_ I64))))))
           (Branch
            (Cond (cond (Lit 1))
             (if_true
              ((block ((id_hum outerInc) (args (((name total%1) (type_ I64))))))
               (args (((name total%0) (type_ I64))))))
             (if_false
              ((block
                ((id_hum exit)
                 (args
                  (((name total%2) (type_ I64)) ((name j%5) (type_ I64))
                   ((name partial%4) (type_ I64))))))
               (args
                (((name total%0) (type_ I64)) ((name j%2) (type_ I64))
                 ((name partial%2) (type_ I64)))))))))))
        (outerInc (args (((name total%1) (type_ I64))))
         (instrs
          ((Add
            ((dest ((name i%1) (type_ I64)))
             (src1 (Var ((name i%0) (type_ I64)))) (src2 (Lit 1))))
           (Branch
            (Uncond
             ((block
               ((id_hum outerCheck)
                (args
                 (((name i%0) (type_ I64)) ((name j) (type_ I64))
                  ((name partial) (type_ I64))))))
              (args
               (((name i%1) (type_ I64)) ((name j%0) (type_ I64))
                ((name partial%0) (type_ I64))))))))))
        (exit
         (args
          (((name total%2) (type_ I64)) ((name j%5) (type_ I64))
           ((name partial%4) (type_ I64))))
         (instrs ((Return (Var ((name total%2) (type_ I64)))))))
        (skipEven (args ())
         (instrs
          ((Add
            ((dest ((name j%4) (type_ I64)))
             (src1 (Var ((name j%1) (type_ I64)))) (src2 (Lit 1))))
           (Branch
            (Cond (cond (Lit 1))
             (if_true
              ((block
                ((id_hum innerCheck)
                 (args (((name j%1) (type_ I64)) ((name partial%1) (type_ I64))))))
               (args (((name j%4) (type_ I64)) ((name partial%1) (type_ I64))))))
             (if_false
              ((block
                ((id_hum innerExit)
                 (args (((name j%2) (type_ I64)) ((name partial%2) (type_ I64))))))
               (args (((name j%4) (type_ I64)) ((name partial%1) (type_ I64)))))))))))))
      (args ()) (name root) (prologue ()) (epilogue ())
      (bytes_for_clobber_saves 0) (bytes_for_padding 0) (bytes_for_spills 0)
      (bytes_statically_alloca'd 0)))
    (((call_conv Default)
      (root
       ((root__prologue (args ())
         (instrs
          ((X86 (PUSH (Reg ((reg RBP) (class_ I64)))))
           (X86
            (MOV (Reg ((reg RBP) (class_ I64))) (Reg ((reg RSP) (class_ I64)))))
           (X86 (PUSH (Reg ((reg R12) (class_ I64)))))
           (X86 (PUSH (Reg ((reg R13) (class_ I64)))))
           (X86 (PUSH (Reg ((reg R14) (class_ I64)))))
           (X86 (PUSH (Reg ((reg R15) (class_ I64)))))
           (X86 (Tag_def NOOP (Reg ((reg RBP) (class_ I64)))))
           (X86 (JMP ((block ((id_hum start) (args ()))) (args ())))))))
        (start (args ())
         (instrs
          ((X86 (MOV (Reg ((reg R8) (class_ I64))) (Imm 7)))
           (X86 (MOV (Reg ((reg R15) (class_ I64))) (Imm 0)))
           (X86 (MOV (Reg ((reg R9) (class_ I64))) (Imm 0)))
           (X86_terminal
            ((CMP (Imm 1) (Imm 0))
             (JNE
              ((block ((id_hum intermediate_start_to_outerCheck) (args ())))
               (args ()))
              (((block ((id_hum intermediate_start_to_exit) (args ())))
                (args ())))))))))
        (intermediate_start_to_outerCheck (args ())
         (instrs
          ((X86
            (MOV (Reg ((reg R10) (class_ I64))) (Reg ((reg R15) (class_ I64)))))
           (X86
            (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg R14) (class_ I64)))))
           (X86
            (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg R13) (class_ I64)))))
           (X86
            (JMP
             ((block
               ((id_hum outerCheck)
                (args
                 (((name i%0) (type_ I64)) ((name j) (type_ I64))
                  ((name partial) (type_ I64))))))
              (args ())))))))
        (outerCheck
         (args
          (((name i%0) (type_ I64)) ((name j) (type_ I64))
           ((name partial) (type_ I64))))
         (instrs
          ((X86
            (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg R10) (class_ I64)))))
           (X86
            (SUB (Reg ((reg R15) (class_ I64))) (Reg ((reg R8) (class_ I64)))))
           (X86_terminal
            ((CMP (Reg ((reg R15) (class_ I64))) (Imm 0))
             (JNE
              ((block ((id_hum intermediate_outerCheck_to_outerBody) (args ())))
               (args ()))
              (((block ((id_hum intermediate_outerCheck_to_exit) (args ())))
                (args ())))))))))
        (intermediate_outerCheck_to_outerBody (args ())
         (instrs
          ((X86 (JMP ((block ((id_hum outerBody) (args ()))) (args ())))))))
        (outerBody (args ())
         (instrs
          ((X86 (MOV (Reg ((reg R11) (class_ I64))) (Imm 0)))
           (X86 (MOV (Reg ((reg R12) (class_ I64))) (Imm 0)))
           (X86_terminal
            ((CMP (Imm 1) (Imm 0))
             (JNE
              ((block ((id_hum intermediate_outerBody_to_innerCheck) (args ())))
               (args ()))
              (((block ((id_hum intermediate_outerBody_to_outerInc) (args ())))
                (args ())))))))))
        (intermediate_outerBody_to_innerCheck (args ())
         (instrs
          ((X86
            (MOV (Reg ((reg R14) (class_ I64))) (Reg ((reg R11) (class_ I64)))))
           (X86
            (MOV (Reg ((reg R13) (class_ I64))) (Reg ((reg R12) (class_ I64)))))
           (X86
            (JMP
             ((block
               ((id_hum innerCheck)
                (args (((name j%1) (type_ I64)) ((name partial%1) (type_ I64))))))
              (args ())))))))
        (innerCheck
         (args (((name j%1) (type_ I64)) ((name partial%1) (type_ I64))))
         (instrs
          ((X86
            (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg R14) (class_ I64)))))
           (X86 (SUB (Reg ((reg R15) (class_ I64))) (Imm 3)))
           (X86_terminal
            ((CMP (Reg ((reg R15) (class_ I64))) (Imm 0))
             (JNE
              ((block ((id_hum intermediate_innerCheck_to_innerBody) (args ())))
               (args ()))
              (((block ((id_hum intermediate_innerCheck_to_innerExit) (args ())))
                (args ())))))))))
        (intermediate_innerCheck_to_innerBody (args ())
         (instrs
          ((X86 (JMP ((block ((id_hum innerBody) (args ()))) (args ())))))))
        (innerBody (args ())
         (instrs
          ((X86
            (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg R14) (class_ I64)))))
           (X86 (AND (Reg ((reg R15) (class_ I64))) (Imm 1)))
           (X86
            (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg R15) (class_ I64)))))
           (X86 (SUB (Reg ((reg R15) (class_ I64))) (Imm 0)))
           (X86_terminal
            ((CMP (Reg ((reg R15) (class_ I64))) (Imm 0))
             (JNE
              ((block ((id_hum intermediate_innerBody_to_doWork) (args ())))
               (args ()))
              (((block ((id_hum intermediate_innerBody_to_skipEven) (args ())))
                (args ())))))))))
        (intermediate_innerBody_to_doWork (args ())
         (instrs ((X86 (JMP ((block ((id_hum doWork) (args ()))) (args ())))))))
        (doWork (args ())
         (instrs
          ((X86
            (MOV (Reg ((reg RAX) (class_ I64))) (Reg ((reg R10) (class_ I64)))))
           (X86
            (Tag_def
             (Tag_def
              (Tag_use (IMUL (Reg ((reg R14) (class_ I64))))
               (Reg ((reg RAX) (class_ I64))))
              (Reg ((reg RAX) (class_ I64))))
             (Reg ((reg RDX) (class_ I64)))))
           (X86
            (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg RAX) (class_ I64)))))
           (X86
            (MOV (Reg ((reg R13) (class_ I64))) (Reg ((reg R13) (class_ I64)))))
           (X86
            (ADD (Reg ((reg R13) (class_ I64))) (Reg ((reg R15) (class_ I64)))))
           (X86
            (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg R14) (class_ I64)))))
           (X86 (ADD (Reg ((reg R15) (class_ I64))) (Imm 1)))
           (X86_terminal
            ((CMP (Imm 1) (Imm 0))
             (JNE
              ((block ((id_hum intermediate_doWork_to_innerCheck) (args ())))
               (args ()))
              (((block ((id_hum intermediate_doWork_to_innerExit) (args ())))
                (args ())))))))))
        (intermediate_doWork_to_innerCheck (args ())
         (instrs
          ((X86
            (MOV (Reg ((reg R14) (class_ I64))) (Reg ((reg R15) (class_ I64)))))
           (X86
            (MOV (Reg ((reg R13) (class_ I64))) (Reg ((reg R13) (class_ I64)))))
           (X86
            (JMP
             ((block
               ((id_hum innerCheck)
                (args (((name j%1) (type_ I64)) ((name partial%1) (type_ I64))))))
              (args ())))))))
        (intermediate_doWork_to_innerExit (args ())
         (instrs
          ((X86
            (MOV (Reg ((reg R14) (class_ I64))) (Reg ((reg R15) (class_ I64)))))
           (X86
            (MOV (Reg ((reg R13) (class_ I64))) (Reg ((reg R13) (class_ I64)))))
           (X86
            (JMP
             ((block
               ((id_hum innerExit)
                (args (((name j%2) (type_ I64)) ((name partial%2) (type_ I64))))))
              (args ())))))))
        (innerExit
         (args (((name j%2) (type_ I64)) ((name partial%2) (type_ I64))))
         (instrs
          ((X86
            (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg R9) (class_ I64)))))
           (X86
            (ADD (Reg ((reg R15) (class_ I64))) (Reg ((reg R13) (class_ I64)))))
           (X86_terminal
            ((CMP (Imm 1) (Imm 0))
             (JNE
              ((block ((id_hum intermediate_innerExit_to_outerInc) (args ())))
               (args ()))
              (((block ((id_hum intermediate_innerExit_to_exit) (args ())))
                (args ())))))))))
        (intermediate_innerExit_to_outerInc (args ())
         (instrs
          ((X86
            (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg R15) (class_ I64)))))
           (X86
            (JMP
             ((block ((id_hum outerInc) (args (((name total%1) (type_ I64))))))
              (args ())))))))
        (outerInc (args (((name total%1) (type_ I64))))
         (instrs
          ((X86
            (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg R10) (class_ I64)))))
           (X86 (ADD (Reg ((reg R15) (class_ I64))) (Imm 1)))
           (X86
            (MOV (Reg ((reg R10) (class_ I64))) (Reg ((reg R15) (class_ I64)))))
           (X86
            (MOV (Reg ((reg R14) (class_ I64))) (Reg ((reg R11) (class_ I64)))))
           (X86
            (MOV (Reg ((reg R13) (class_ I64))) (Reg ((reg R12) (class_ I64)))))
           (X86_terminal
            ((JMP
              ((block
                ((id_hum outerCheck)
                 (args
                  (((name i%0) (type_ I64)) ((name j) (type_ I64))
                   ((name partial) (type_ I64))))))
               (args ()))))))))
        (intermediate_innerExit_to_exit (args ())
         (instrs
          ((X86
            (MOV (Reg ((reg R14) (class_ I64))) (Reg ((reg R14) (class_ I64)))))
           (X86
            (MOV (Reg ((reg R14) (class_ I64))) (Reg ((reg R13) (class_ I64)))))
           (X86
            (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg R15) (class_ I64)))))
           (X86
            (JMP
             ((block
               ((id_hum exit)
                (args
                 (((name total%2) (type_ I64)) ((name j%5) (type_ I64))
                  ((name partial%4) (type_ I64))))))
              (args ())))))))
        (exit
         (args
          (((name total%2) (type_ I64)) ((name j%5) (type_ I64))
           ((name partial%4) (type_ I64))))
         (instrs
          ((X86
            (MOV (Reg ((reg RAX) (class_ I64))) (Reg ((reg R15) (class_ I64)))))
           (X86_terminal
            ((JMP
              ((block
                ((id_hum root__epilogue) (args (((name res__0) (type_ I64))))))
               (args ()))))))))
        (root__epilogue (args (((name res__0) (type_ I64))))
         (instrs
          ((X86
            (MOV (Reg ((reg RAX) (class_ I64))) (Reg ((reg RAX) (class_ I64)))))
           (X86 (SUB (Reg ((reg RBP) (class_ I64))) (Imm 32)))
           (X86
            (MOV (Reg ((reg RSP) (class_ I64))) (Reg ((reg RBP) (class_ I64)))))
           (X86 (POP ((reg R15) (class_ I64))))
           (X86 (POP ((reg R14) (class_ I64))))
           (X86 (POP ((reg R13) (class_ I64))))
           (X86 (POP ((reg R12) (class_ I64))))
           (X86 (POP ((reg RBP) (class_ I64))))
           (X86 (RET ((Reg ((reg RAX) (class_ I64)))))))))
        (intermediate_innerBody_to_skipEven (args ())
         (instrs ((X86 (JMP ((block ((id_hum skipEven) (args ()))) (args ())))))))
        (skipEven (args ())
         (instrs
          ((X86
            (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg R14) (class_ I64)))))
           (X86 (ADD (Reg ((reg R15) (class_ I64))) (Imm 1)))
           (X86_terminal
            ((CMP (Imm 1) (Imm 0))
             (JNE
              ((block ((id_hum intermediate_skipEven_to_innerCheck) (args ())))
               (args ()))
              (((block ((id_hum intermediate_skipEven_to_innerExit) (args ())))
                (args ())))))))))
        (intermediate_skipEven_to_innerCheck (args ())
         (instrs
          ((X86
            (MOV (Reg ((reg R14) (class_ I64))) (Reg ((reg R15) (class_ I64)))))
           (X86
            (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg R13) (class_ I64)))))
           (X86
            (JMP
             ((block
               ((id_hum innerCheck)
                (args (((name j%1) (type_ I64)) ((name partial%1) (type_ I64))))))
              (args ())))))))
        (intermediate_skipEven_to_innerExit (args ())
         (instrs
          ((X86
            (MOV (Reg ((reg R14) (class_ I64))) (Reg ((reg R15) (class_ I64)))))
           (X86
            (MOV (Reg ((reg R13) (class_ I64))) (Reg ((reg R13) (class_ I64)))))
           (X86
            (JMP
             ((block
               ((id_hum innerExit)
                (args (((name j%2) (type_ I64)) ((name partial%2) (type_ I64))))))
              (args ())))))))
        (intermediate_innerCheck_to_innerExit (args ())
         (instrs
          ((X86
            (MOV (Reg ((reg R14) (class_ I64))) (Reg ((reg R14) (class_ I64)))))
           (X86
            (MOV (Reg ((reg R13) (class_ I64))) (Reg ((reg R13) (class_ I64)))))
           (X86
            (JMP
             ((block
               ((id_hum innerExit)
                (args (((name j%2) (type_ I64)) ((name partial%2) (type_ I64))))))
              (args ())))))))
        (intermediate_outerBody_to_outerInc (args ())
         (instrs
          ((X86
            (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg R9) (class_ I64)))))
           (X86
            (JMP
             ((block ((id_hum outerInc) (args (((name total%1) (type_ I64))))))
              (args ())))))))
        (intermediate_outerCheck_to_exit (args ())
         (instrs
          ((X86
            (MOV (Reg ((reg R14) (class_ I64))) (Reg ((reg R14) (class_ I64)))))
           (X86
            (MOV (Reg ((reg R14) (class_ I64))) (Reg ((reg R13) (class_ I64)))))
           (X86
            (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg R9) (class_ I64)))))
           (X86
            (JMP
             ((block
               ((id_hum exit)
                (args
                 (((name total%2) (type_ I64)) ((name j%5) (type_ I64))
                  ((name partial%4) (type_ I64))))))
              (args ())))))))
        (intermediate_start_to_exit (args ())
         (instrs
          ((X86
            (MOV (Reg ((reg R14) (class_ I64))) (Reg ((reg R14) (class_ I64)))))
           (X86
            (MOV (Reg ((reg R14) (class_ I64))) (Reg ((reg R13) (class_ I64)))))
           (X86
            (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg R9) (class_ I64)))))
           (X86
            (JMP
             ((block
               ((id_hum exit)
                (args
                 (((name total%2) (type_ I64)) ((name j%5) (type_ I64))
                  ((name partial%4) (type_ I64))))))
              (args ())))))))))
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
          ((Branch
            (Cond (cond (Var ((name arg) (type_ I64))))
             (if_true ((block ((id_hum check1_) (args ()))) (args ())))
             (if_false
              ((block ((id_hum ret_1) (args (((name m1) (type_ I64))))))
               (args (((name m1) (type_ I64)))))))))))
        (check1_ (args ())
         (instrs
          ((Sub
            ((dest ((name m1%0) (type_ I64)))
             (src1 (Var ((name arg) (type_ I64)))) (src2 (Lit 1))))
           (Branch
            (Cond (cond (Var ((name m1%0) (type_ I64))))
             (if_true ((block ((id_hum rec) (args ()))) (args ())))
             (if_false
              ((block ((id_hum ret_1) (args (((name m1) (type_ I64))))))
               (args (((name m1%0) (type_ I64)))))))))))
        (rec (args ())
         (instrs
          ((Call (fn fib) (results (((name sub1_res) (type_ I64))))
            (args ((Var ((name m1%0) (type_ I64))))))
           (Sub
            ((dest ((name m2) (type_ I64)))
             (src1 (Var ((name m1%0) (type_ I64)))) (src2 (Lit 1))))
           (Call (fn fib) (results (((name sub2_res) (type_ I64))))
            (args ((Var ((name m2) (type_ I64))))))
           (Add
            ((dest ((name res) (type_ I64)))
             (src1 (Var ((name sub1_res) (type_ I64))))
             (src2 (Var ((name sub2_res) (type_ I64))))))
           (Return (Var ((name res) (type_ I64)))))))
        (ret_1 (args (((name m1) (type_ I64)))) (instrs ((Return (Lit 1)))))))
      (args (((name arg) (type_ I64)))) (name fib) (prologue ()) (epilogue ())
      (bytes_for_clobber_saves 0) (bytes_for_padding 0) (bytes_for_spills 0)
      (bytes_statically_alloca'd 0)))
    (((call_conv Default)
      (root
       ((fib__prologue (args (((name arg1) (type_ I64))))
         (instrs
          ((X86 (PUSH (Reg ((reg RBP) (class_ I64)))))
           (X86
            (MOV (Reg ((reg RBP) (class_ I64))) (Reg ((reg RSP) (class_ I64)))))
           (X86 (PUSH (Reg ((reg R13) (class_ I64)))))
           (X86 (PUSH (Reg ((reg R14) (class_ I64)))))
           (X86 (PUSH (Reg ((reg R15) (class_ I64)))))
           (X86 (SUB (Reg ((reg RSP) (class_ I64))) (Imm 8)))
           (X86
            (MOV (Reg ((reg RDI) (class_ I64))) (Reg ((reg RDI) (class_ I64)))))
           (X86 (Tag_def NOOP (Reg ((reg RBP) (class_ I64)))))
           (X86
            (MOV (Reg ((reg R14) (class_ I64))) (Reg ((reg RDI) (class_ I64)))))
           (X86
            (JMP
             ((block ((id_hum %root) (args (((name arg) (type_ I64))))))
              (args ())))))))
        (%root (args (((name arg) (type_ I64))))
         (instrs
          ((X86_terminal
            ((CMP (Reg ((reg R14) (class_ I64))) (Imm 0))
             (JNE
              ((block ((id_hum intermediate_%root_to_check1_) (args ())))
               (args ()))
              (((block ((id_hum intermediate_%root_to_ret_1) (args ())))
                (args ())))))))))
        (intermediate_%root_to_check1_ (args ())
         (instrs ((X86 (JMP ((block ((id_hum check1_) (args ()))) (args ())))))))
        (check1_ (args ())
         (instrs
          ((X86
            (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg R14) (class_ I64)))))
           (X86 (SUB (Reg ((reg R15) (class_ I64))) (Imm 1)))
           (X86_terminal
            ((CMP (Reg ((reg R15) (class_ I64))) (Imm 0))
             (JNE
              ((block ((id_hum intermediate_check1__to_rec) (args ())))
               (args ()))
              (((block ((id_hum intermediate_check1__to_ret_1) (args ())))
                (args ())))))))))
        (intermediate_check1__to_rec (args ())
         (instrs ((X86 (JMP ((block ((id_hum rec) (args ()))) (args ())))))))
        (rec (args ())
         (instrs
          ((X86
            (MOV (Reg ((reg RDI) (class_ I64))) (Reg ((reg R15) (class_ I64)))))
           (X86
            (CALL (fn fib) (results (((reg RAX) (class_ I64))))
             (args ((Reg ((reg R15) (class_ I64)))))))
           (X86
            (MOV (Reg ((reg R13) (class_ I64))) (Reg ((reg RAX) (class_ I64)))))
           (X86
            (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg R15) (class_ I64)))))
           (X86 (SUB (Reg ((reg R15) (class_ I64))) (Imm 1)))
           (X86
            (MOV (Reg ((reg RDI) (class_ I64))) (Reg ((reg R15) (class_ I64)))))
           (X86
            (CALL (fn fib) (results (((reg RAX) (class_ I64))))
             (args ((Reg ((reg R15) (class_ I64)))))))
           (X86
            (MOV (Reg ((reg R14) (class_ I64))) (Reg ((reg RAX) (class_ I64)))))
           (X86
            (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg R13) (class_ I64)))))
           (X86
            (ADD (Reg ((reg R15) (class_ I64))) (Reg ((reg R14) (class_ I64)))))
           (X86
            (MOV (Reg ((reg RAX) (class_ I64))) (Reg ((reg R15) (class_ I64)))))
           (X86_terminal
            ((JMP
              ((block
                ((id_hum fib__epilogue) (args (((name res__0) (type_ I64))))))
               (args ()))))))))
        (fib__epilogue (args (((name res__0) (type_ I64))))
         (instrs
          ((X86
            (MOV (Reg ((reg RAX) (class_ I64))) (Reg ((reg RAX) (class_ I64)))))
           (X86 (SUB (Reg ((reg RBP) (class_ I64))) (Imm 24)))
           (X86
            (MOV (Reg ((reg RSP) (class_ I64))) (Reg ((reg RBP) (class_ I64)))))
           (X86 (POP ((reg R15) (class_ I64))))
           (X86 (POP ((reg R14) (class_ I64))))
           (X86 (POP ((reg R13) (class_ I64))))
           (X86 (POP ((reg RBP) (class_ I64))))
           (X86 (RET ((Reg ((reg RAX) (class_ I64)))))))))
        (intermediate_check1__to_ret_1 (args ())
         (instrs
          ((X86
            (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg R15) (class_ I64)))))
           (X86
            (JMP
             ((block ((id_hum ret_1) (args (((name m1) (type_ I64))))))
              (args ())))))))
        (ret_1 (args (((name m1) (type_ I64))))
         (instrs
          ((X86 (MOV (Reg ((reg R15) (class_ I64))) (Imm 1)))
           (X86
            (MOV (Reg ((reg RAX) (class_ I64))) (Reg ((reg R15) (class_ I64)))))
           (X86_terminal
            ((JMP
              ((block
                ((id_hum fib__epilogue) (args (((name res__0) (type_ I64))))))
               (args ()))))))))
        (intermediate_%root_to_ret_1 (args ())
         (instrs
          ((X86
            (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg R15) (class_ I64)))))
           (X86
            (JMP
             ((block ((id_hum ret_1) (args (((name m1) (type_ I64))))))
              (args ())))))))))
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
          ((Add
            ((dest ((name one) (type_ I64))) (src1 (Var ((name x) (type_ I64))))
             (src2 (Lit 1))))
           (Call (fn fourth) (results (((name fourth) (type_ I64))))
            (args ((Var ((name one) (type_ I64))) (Var ((name x) (type_ I64))))))
           (Return (Var ((name fourth) (type_ I64)))))))))
      (args (((name x) (type_ I64)))) (name first) (prologue ()) (epilogue ())
      (bytes_for_clobber_saves 0) (bytes_for_padding 0) (bytes_for_spills 0)
      (bytes_statically_alloca'd 0))
     ((call_conv Default)
      (root
       ((%root (args (((name p) (type_ I64)) ((name q) (type_ I64))))
         (instrs
          ((Add
            ((dest ((name mix) (type_ I64))) (src1 (Var ((name p) (type_ I64))))
             (src2 (Var ((name q) (type_ I64))))))
           (Return (Var ((name mix) (type_ I64)))))))))
      (args (((name p) (type_ I64)) ((name q) (type_ I64)))) (name fourth)
      (prologue ()) (epilogue ()) (bytes_for_clobber_saves 0)
      (bytes_for_padding 0) (bytes_for_spills 0) (bytes_statically_alloca'd 0))
     ((call_conv Default)
      (root
       ((%root (args (((name h) (type_ I64))))
         (instrs
          ((Add
            ((dest ((name res) (type_ I64))) (src1 (Var ((name h) (type_ I64))))
             (src2 (Lit 3))))
           (Return (Var ((name res) (type_ I64)))))))))
      (args (((name h) (type_ I64)))) (name helper) (prologue ()) (epilogue ())
      (bytes_for_clobber_saves 0) (bytes_for_padding 0) (bytes_for_spills 0)
      (bytes_statically_alloca'd 0))
     ((call_conv Default)
      (root
       ((%root (args (((name init) (type_ I64))))
         (instrs
          ((Call (fn first) (results (((name first) (type_ I64))))
            (args ((Var ((name init) (type_ I64))))))
           (Call (fn second) (results (((name second) (type_ I64))))
            (args ((Var ((name first) (type_ I64))))))
           (Call (fn third) (results (((name third) (type_ I64))))
            (args
             ((Var ((name second) (type_ I64))) (Var ((name first) (type_ I64))))))
           (Return (Var ((name third) (type_ I64)))))))))
      (args (((name init) (type_ I64)))) (name root) (prologue ()) (epilogue ())
      (bytes_for_clobber_saves 0) (bytes_for_padding 0) (bytes_for_spills 0)
      (bytes_statically_alloca'd 0))
     ((call_conv Default)
      (root
       ((%root (args (((name y) (type_ I64))))
         (instrs
          ((Call (fn third) (results (((name tmp) (type_ I64))))
            (args ((Var ((name y) (type_ I64))) (Var ((name y) (type_ I64))))))
           (Add
            ((dest ((name res) (type_ I64)))
             (src1 (Var ((name tmp) (type_ I64)))) (src2 (Lit 2))))
           (Return (Var ((name res) (type_ I64)))))))))
      (args (((name y) (type_ I64)))) (name second) (prologue ()) (epilogue ())
      (bytes_for_clobber_saves 0) (bytes_for_padding 0) (bytes_for_spills 0)
      (bytes_statically_alloca'd 0))
     ((call_conv Default)
      (root
       ((%root (args (((name u) (type_ I64)) ((name v) (type_ I64))))
         (instrs
          ((Add
            ((dest ((name sum) (type_ I64))) (src1 (Var ((name u) (type_ I64))))
             (src2 (Var ((name v) (type_ I64))))))
           (Call (fn helper) (results (((name helped) (type_ I64))))
            (args ((Var ((name sum) (type_ I64))))))
           (Return (Var ((name helped) (type_ I64)))))))))
      (args (((name u) (type_ I64)) ((name v) (type_ I64)))) (name third)
      (prologue ()) (epilogue ()) (bytes_for_clobber_saves 0)
      (bytes_for_padding 0) (bytes_for_spills 0) (bytes_statically_alloca'd 0)))
    (((call_conv Default)
      (root
       ((first__prologue (args (((name x2) (type_ I64))))
         (instrs
          ((X86 (PUSH (Reg ((reg RBP) (class_ I64)))))
           (X86
            (MOV (Reg ((reg RBP) (class_ I64))) (Reg ((reg RSP) (class_ I64)))))
           (X86 (PUSH (Reg ((reg R14) (class_ I64)))))
           (X86 (PUSH (Reg ((reg R15) (class_ I64)))))
           (X86
            (MOV (Reg ((reg RDI) (class_ I64))) (Reg ((reg RDI) (class_ I64)))))
           (X86 (Tag_def NOOP (Reg ((reg RBP) (class_ I64)))))
           (X86
            (MOV (Reg ((reg R14) (class_ I64))) (Reg ((reg RDI) (class_ I64)))))
           (X86
            (JMP
             ((block ((id_hum %root) (args (((name x) (type_ I64)))))) (args ())))))))
        (%root (args (((name x) (type_ I64))))
         (instrs
          ((X86
            (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg R14) (class_ I64)))))
           (X86 (ADD (Reg ((reg R15) (class_ I64))) (Imm 1)))
           (X86
            (MOV (Reg ((reg RDI) (class_ I64))) (Reg ((reg R15) (class_ I64)))))
           (X86
            (MOV (Reg ((reg RSI) (class_ I64))) (Reg ((reg R14) (class_ I64)))))
           (X86
            (CALL (fn fourth) (results (((reg RAX) (class_ I64))))
             (args
              ((Reg ((reg R15) (class_ I64))) (Reg ((reg R14) (class_ I64)))))))
           (X86
            (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg RAX) (class_ I64)))))
           (X86
            (MOV (Reg ((reg RAX) (class_ I64))) (Reg ((reg R15) (class_ I64)))))
           (X86_terminal
            ((JMP
              ((block
                ((id_hum first__epilogue) (args (((name res__0) (type_ I64))))))
               (args ()))))))))
        (first__epilogue (args (((name res__0) (type_ I64))))
         (instrs
          ((X86
            (MOV (Reg ((reg RAX) (class_ I64))) (Reg ((reg RAX) (class_ I64)))))
           (X86 (SUB (Reg ((reg RBP) (class_ I64))) (Imm 16)))
           (X86
            (MOV (Reg ((reg RSP) (class_ I64))) (Reg ((reg RBP) (class_ I64)))))
           (X86 (POP ((reg R15) (class_ I64))))
           (X86 (POP ((reg R14) (class_ I64))))
           (X86 (POP ((reg RBP) (class_ I64))))
           (X86 (RET ((Reg ((reg RAX) (class_ I64)))))))))))
      (args (((name x) (type_ I64)))) (name first) (prologue ()) (epilogue ())
      (bytes_for_clobber_saves 16) (bytes_for_padding 0) (bytes_for_spills 0)
      (bytes_statically_alloca'd 0))
     ((call_conv Default)
      (root
       ((fourth__prologue
         (args (((name p0) (type_ I64)) ((name q0) (type_ I64))))
         (instrs
          ((X86 (PUSH (Reg ((reg RBP) (class_ I64)))))
           (X86
            (MOV (Reg ((reg RBP) (class_ I64))) (Reg ((reg RSP) (class_ I64)))))
           (X86 (PUSH (Reg ((reg R14) (class_ I64)))))
           (X86 (PUSH (Reg ((reg R15) (class_ I64)))))
           (X86
            (MOV (Reg ((reg RDI) (class_ I64))) (Reg ((reg RDI) (class_ I64)))))
           (X86
            (MOV (Reg ((reg RSI) (class_ I64))) (Reg ((reg RSI) (class_ I64)))))
           (X86 (Tag_def NOOP (Reg ((reg RBP) (class_ I64)))))
           (X86
            (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg RDI) (class_ I64)))))
           (X86
            (MOV (Reg ((reg R14) (class_ I64))) (Reg ((reg RSI) (class_ I64)))))
           (X86
            (JMP
             ((block
               ((id_hum %root)
                (args (((name p) (type_ I64)) ((name q) (type_ I64))))))
              (args ())))))))
        (%root (args (((name p) (type_ I64)) ((name q) (type_ I64))))
         (instrs
          ((X86
            (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg R15) (class_ I64)))))
           (X86
            (ADD (Reg ((reg R15) (class_ I64))) (Reg ((reg R14) (class_ I64)))))
           (X86
            (MOV (Reg ((reg RAX) (class_ I64))) (Reg ((reg R15) (class_ I64)))))
           (X86_terminal
            ((JMP
              ((block
                ((id_hum fourth__epilogue) (args (((name res__0) (type_ I64))))))
               (args ()))))))))
        (fourth__epilogue (args (((name res__0) (type_ I64))))
         (instrs
          ((X86
            (MOV (Reg ((reg RAX) (class_ I64))) (Reg ((reg RAX) (class_ I64)))))
           (X86 (SUB (Reg ((reg RBP) (class_ I64))) (Imm 16)))
           (X86
            (MOV (Reg ((reg RSP) (class_ I64))) (Reg ((reg RBP) (class_ I64)))))
           (X86 (POP ((reg R15) (class_ I64))))
           (X86 (POP ((reg R14) (class_ I64))))
           (X86 (POP ((reg RBP) (class_ I64))))
           (X86 (RET ((Reg ((reg RAX) (class_ I64)))))))))))
      (args (((name p) (type_ I64)) ((name q) (type_ I64)))) (name fourth)
      (prologue ()) (epilogue ()) (bytes_for_clobber_saves 16)
      (bytes_for_padding 0) (bytes_for_spills 0) (bytes_statically_alloca'd 0))
     ((call_conv Default)
      (root
       ((helper__prologue (args (((name h0) (type_ I64))))
         (instrs
          ((X86 (PUSH (Reg ((reg RBP) (class_ I64)))))
           (X86
            (MOV (Reg ((reg RBP) (class_ I64))) (Reg ((reg RSP) (class_ I64)))))
           (X86 (PUSH (Reg ((reg R15) (class_ I64)))))
           (X86 (SUB (Reg ((reg RSP) (class_ I64))) (Imm 8)))
           (X86
            (MOV (Reg ((reg RDI) (class_ I64))) (Reg ((reg RDI) (class_ I64)))))
           (X86 (Tag_def NOOP (Reg ((reg RBP) (class_ I64)))))
           (X86
            (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg RDI) (class_ I64)))))
           (X86
            (JMP
             ((block ((id_hum %root) (args (((name h) (type_ I64)))))) (args ())))))))
        (%root (args (((name h) (type_ I64))))
         (instrs
          ((X86
            (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg R15) (class_ I64)))))
           (X86 (ADD (Reg ((reg R15) (class_ I64))) (Imm 3)))
           (X86
            (MOV (Reg ((reg RAX) (class_ I64))) (Reg ((reg R15) (class_ I64)))))
           (X86_terminal
            ((JMP
              ((block
                ((id_hum helper__epilogue) (args (((name res__0) (type_ I64))))))
               (args ()))))))))
        (helper__epilogue (args (((name res__0) (type_ I64))))
         (instrs
          ((X86
            (MOV (Reg ((reg RAX) (class_ I64))) (Reg ((reg RAX) (class_ I64)))))
           (X86 (SUB (Reg ((reg RBP) (class_ I64))) (Imm 8)))
           (X86
            (MOV (Reg ((reg RSP) (class_ I64))) (Reg ((reg RBP) (class_ I64)))))
           (X86 (POP ((reg R15) (class_ I64))))
           (X86 (POP ((reg RBP) (class_ I64))))
           (X86 (RET ((Reg ((reg RAX) (class_ I64)))))))))))
      (args (((name h) (type_ I64)))) (name helper) (prologue ()) (epilogue ())
      (bytes_for_clobber_saves 8) (bytes_for_padding 8) (bytes_for_spills 0)
      (bytes_statically_alloca'd 0))
     ((call_conv Default)
      (root
       ((root__prologue (args (((name init1) (type_ I64))))
         (instrs
          ((X86 (PUSH (Reg ((reg RBP) (class_ I64)))))
           (X86
            (MOV (Reg ((reg RBP) (class_ I64))) (Reg ((reg RSP) (class_ I64)))))
           (X86 (PUSH (Reg ((reg R14) (class_ I64)))))
           (X86 (PUSH (Reg ((reg R15) (class_ I64)))))
           (X86
            (MOV (Reg ((reg RDI) (class_ I64))) (Reg ((reg RDI) (class_ I64)))))
           (X86 (Tag_def NOOP (Reg ((reg RBP) (class_ I64)))))
           (X86
            (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg RDI) (class_ I64)))))
           (X86
            (JMP
             ((block ((id_hum %root) (args (((name init) (type_ I64))))))
              (args ())))))))
        (%root (args (((name init) (type_ I64))))
         (instrs
          ((X86
            (MOV (Reg ((reg RDI) (class_ I64))) (Reg ((reg R15) (class_ I64)))))
           (X86
            (CALL (fn first) (results (((reg RAX) (class_ I64))))
             (args ((Reg ((reg R15) (class_ I64)))))))
           (X86
            (MOV (Reg ((reg R14) (class_ I64))) (Reg ((reg RAX) (class_ I64)))))
           (X86
            (MOV (Reg ((reg RDI) (class_ I64))) (Reg ((reg R14) (class_ I64)))))
           (X86
            (CALL (fn second) (results (((reg RAX) (class_ I64))))
             (args ((Reg ((reg R14) (class_ I64)))))))
           (X86
            (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg RAX) (class_ I64)))))
           (X86
            (MOV (Reg ((reg RDI) (class_ I64))) (Reg ((reg R15) (class_ I64)))))
           (X86
            (MOV (Reg ((reg RSI) (class_ I64))) (Reg ((reg R14) (class_ I64)))))
           (X86
            (CALL (fn third) (results (((reg RAX) (class_ I64))))
             (args
              ((Reg ((reg R15) (class_ I64))) (Reg ((reg R14) (class_ I64)))))))
           (X86
            (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg RAX) (class_ I64)))))
           (X86
            (MOV (Reg ((reg RAX) (class_ I64))) (Reg ((reg R15) (class_ I64)))))
           (X86_terminal
            ((JMP
              ((block
                ((id_hum root__epilogue) (args (((name res__0) (type_ I64))))))
               (args ()))))))))
        (root__epilogue (args (((name res__0) (type_ I64))))
         (instrs
          ((X86
            (MOV (Reg ((reg RAX) (class_ I64))) (Reg ((reg RAX) (class_ I64)))))
           (X86 (SUB (Reg ((reg RBP) (class_ I64))) (Imm 16)))
           (X86
            (MOV (Reg ((reg RSP) (class_ I64))) (Reg ((reg RBP) (class_ I64)))))
           (X86 (POP ((reg R15) (class_ I64))))
           (X86 (POP ((reg R14) (class_ I64))))
           (X86 (POP ((reg RBP) (class_ I64))))
           (X86 (RET ((Reg ((reg RAX) (class_ I64)))))))))))
      (args (((name init) (type_ I64)))) (name root) (prologue ()) (epilogue ())
      (bytes_for_clobber_saves 16) (bytes_for_padding 0) (bytes_for_spills 0)
      (bytes_statically_alloca'd 0))
     ((call_conv Default)
      (root
       ((second__prologue (args (((name y2) (type_ I64))))
         (instrs
          ((X86 (PUSH (Reg ((reg RBP) (class_ I64)))))
           (X86
            (MOV (Reg ((reg RBP) (class_ I64))) (Reg ((reg RSP) (class_ I64)))))
           (X86 (PUSH (Reg ((reg R15) (class_ I64)))))
           (X86 (SUB (Reg ((reg RSP) (class_ I64))) (Imm 8)))
           (X86
            (MOV (Reg ((reg RDI) (class_ I64))) (Reg ((reg RDI) (class_ I64)))))
           (X86 (Tag_def NOOP (Reg ((reg RBP) (class_ I64)))))
           (X86
            (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg RDI) (class_ I64)))))
           (X86
            (JMP
             ((block ((id_hum %root) (args (((name y) (type_ I64)))))) (args ())))))))
        (%root (args (((name y) (type_ I64))))
         (instrs
          ((X86
            (MOV (Reg ((reg RDI) (class_ I64))) (Reg ((reg R15) (class_ I64)))))
           (X86
            (MOV (Reg ((reg RSI) (class_ I64))) (Reg ((reg R15) (class_ I64)))))
           (X86
            (CALL (fn third) (results (((reg RAX) (class_ I64))))
             (args
              ((Reg ((reg R15) (class_ I64))) (Reg ((reg R15) (class_ I64)))))))
           (X86
            (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg RAX) (class_ I64)))))
           (X86
            (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg R15) (class_ I64)))))
           (X86 (ADD (Reg ((reg R15) (class_ I64))) (Imm 2)))
           (X86
            (MOV (Reg ((reg RAX) (class_ I64))) (Reg ((reg R15) (class_ I64)))))
           (X86_terminal
            ((JMP
              ((block
                ((id_hum second__epilogue) (args (((name res__0) (type_ I64))))))
               (args ()))))))))
        (second__epilogue (args (((name res__0) (type_ I64))))
         (instrs
          ((X86
            (MOV (Reg ((reg RAX) (class_ I64))) (Reg ((reg RAX) (class_ I64)))))
           (X86 (SUB (Reg ((reg RBP) (class_ I64))) (Imm 8)))
           (X86
            (MOV (Reg ((reg RSP) (class_ I64))) (Reg ((reg RBP) (class_ I64)))))
           (X86 (POP ((reg R15) (class_ I64))))
           (X86 (POP ((reg RBP) (class_ I64))))
           (X86 (RET ((Reg ((reg RAX) (class_ I64)))))))))))
      (args (((name y) (type_ I64)))) (name second) (prologue ()) (epilogue ())
      (bytes_for_clobber_saves 8) (bytes_for_padding 8) (bytes_for_spills 0)
      (bytes_statically_alloca'd 0))
     ((call_conv Default)
      (root
       ((third__prologue (args (((name u0) (type_ I64)) ((name v0) (type_ I64))))
         (instrs
          ((X86 (PUSH (Reg ((reg RBP) (class_ I64)))))
           (X86
            (MOV (Reg ((reg RBP) (class_ I64))) (Reg ((reg RSP) (class_ I64)))))
           (X86 (PUSH (Reg ((reg R14) (class_ I64)))))
           (X86 (PUSH (Reg ((reg R15) (class_ I64)))))
           (X86
            (MOV (Reg ((reg RDI) (class_ I64))) (Reg ((reg RDI) (class_ I64)))))
           (X86
            (MOV (Reg ((reg RSI) (class_ I64))) (Reg ((reg RSI) (class_ I64)))))
           (X86 (Tag_def NOOP (Reg ((reg RBP) (class_ I64)))))
           (X86
            (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg RDI) (class_ I64)))))
           (X86
            (MOV (Reg ((reg R14) (class_ I64))) (Reg ((reg RSI) (class_ I64)))))
           (X86
            (JMP
             ((block
               ((id_hum %root)
                (args (((name u) (type_ I64)) ((name v) (type_ I64))))))
              (args ())))))))
        (%root (args (((name u) (type_ I64)) ((name v) (type_ I64))))
         (instrs
          ((X86
            (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg R15) (class_ I64)))))
           (X86
            (ADD (Reg ((reg R15) (class_ I64))) (Reg ((reg R14) (class_ I64)))))
           (X86
            (MOV (Reg ((reg RDI) (class_ I64))) (Reg ((reg R15) (class_ I64)))))
           (X86
            (CALL (fn helper) (results (((reg RAX) (class_ I64))))
             (args ((Reg ((reg R15) (class_ I64)))))))
           (X86
            (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg RAX) (class_ I64)))))
           (X86
            (MOV (Reg ((reg RAX) (class_ I64))) (Reg ((reg R15) (class_ I64)))))
           (X86_terminal
            ((JMP
              ((block
                ((id_hum third__epilogue) (args (((name res__0) (type_ I64))))))
               (args ()))))))))
        (third__epilogue (args (((name res__0) (type_ I64))))
         (instrs
          ((X86
            (MOV (Reg ((reg RAX) (class_ I64))) (Reg ((reg RAX) (class_ I64)))))
           (X86 (SUB (Reg ((reg RBP) (class_ I64))) (Imm 16)))
           (X86
            (MOV (Reg ((reg RSP) (class_ I64))) (Reg ((reg RBP) (class_ I64)))))
           (X86 (POP ((reg R15) (class_ I64))))
           (X86 (POP ((reg R14) (class_ I64))))
           (X86 (POP ((reg RBP) (class_ I64))))
           (X86 (RET ((Reg ((reg RAX) (class_ I64)))))))))))
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
          ((Move ((name arg) (type_ I64)) (Lit 10))
           (Branch (Uncond ((block ((id_hum fib_start) (args ()))) (args ())))))))
        (fib_start (args ())
         (instrs
          ((Move ((name count) (type_ I64)) (Var ((name arg) (type_ I64))))
           (Move ((name a) (type_ I64)) (Lit 0))
           (Move ((name b) (type_ I64)) (Lit 1))
           (Branch
            (Uncond
             ((block
               ((id_hum fib_check)
                (args
                 (((name b%0) (type_ I64)) ((name count%0) (type_ I64))
                  ((name a%0) (type_ I64))))))
              (args
               (((name b) (type_ I64)) ((name count) (type_ I64))
                ((name a) (type_ I64))))))))))
        (fib_check
         (args
          (((name b%0) (type_ I64)) ((name count%0) (type_ I64))
           ((name a%0) (type_ I64))))
         (instrs
          ((Branch
            (Cond (cond (Var ((name count%0) (type_ I64))))
             (if_true ((block ((id_hum fib_body) (args ()))) (args ())))
             (if_false ((block ((id_hum fib_exit) (args ()))) (args ()))))))))
        (fib_body (args ())
         (instrs
          ((Add
            ((dest ((name next) (type_ I64)))
             (src1 (Var ((name a%0) (type_ I64))))
             (src2 (Var ((name b%0) (type_ I64))))))
           (Move ((name a%1) (type_ I64)) (Var ((name b%0) (type_ I64))))
           (Move ((name b%1) (type_ I64)) (Var ((name next) (type_ I64))))
           (Sub
            ((dest ((name count%1) (type_ I64)))
             (src1 (Var ((name count%0) (type_ I64)))) (src2 (Lit 1))))
           (Branch
            (Uncond
             ((block
               ((id_hum fib_check)
                (args
                 (((name b%0) (type_ I64)) ((name count%0) (type_ I64))
                  ((name a%0) (type_ I64))))))
              (args
               (((name b%1) (type_ I64)) ((name count%1) (type_ I64))
                ((name a%1) (type_ I64))))))))))
        (fib_exit (args ()) (instrs ((Return (Var ((name a%0) (type_ I64)))))))))
      (args ()) (name root) (prologue ()) (epilogue ())
      (bytes_for_clobber_saves 0) (bytes_for_padding 0) (bytes_for_spills 0)
      (bytes_statically_alloca'd 0)))
    (((call_conv Default)
      (root
       ((root__prologue (args ())
         (instrs
          ((X86 (PUSH (Reg ((reg RBP) (class_ I64)))))
           (X86
            (MOV (Reg ((reg RBP) (class_ I64))) (Reg ((reg RSP) (class_ I64)))))
           (X86 (PUSH (Reg ((reg R12) (class_ I64)))))
           (X86 (PUSH (Reg ((reg R13) (class_ I64)))))
           (X86 (PUSH (Reg ((reg R14) (class_ I64)))))
           (X86 (PUSH (Reg ((reg R15) (class_ I64)))))
           (X86 (Tag_def NOOP (Reg ((reg RBP) (class_ I64)))))
           (X86 (JMP ((block ((id_hum %root) (args ()))) (args ())))))))
        (%root (args ())
         (instrs
          ((X86 (MOV (Reg ((reg R15) (class_ I64))) (Imm 10)))
           (X86_terminal
            ((JMP ((block ((id_hum fib_start) (args ()))) (args ()))))))))
        (fib_start (args ())
         (instrs
          ((X86
            (MOV (Reg ((reg R12) (class_ I64))) (Reg ((reg R15) (class_ I64)))))
           (X86 (MOV (Reg ((reg R14) (class_ I64))) (Imm 0)))
           (X86 (MOV (Reg ((reg R15) (class_ I64))) (Imm 1)))
           (X86
            (MOV (Reg ((reg R13) (class_ I64))) (Reg ((reg R14) (class_ I64)))))
           (X86
            (MOV (Reg ((reg R14) (class_ I64))) (Reg ((reg R15) (class_ I64)))))
           (X86
            (MOV (Reg ((reg R12) (class_ I64))) (Reg ((reg R12) (class_ I64)))))
           (X86_terminal
            ((JMP
              ((block
                ((id_hum fib_check)
                 (args
                  (((name b%0) (type_ I64)) ((name count%0) (type_ I64))
                   ((name a%0) (type_ I64))))))
               (args ()))))))))
        (fib_check
         (args
          (((name b%0) (type_ I64)) ((name count%0) (type_ I64))
           ((name a%0) (type_ I64))))
         (instrs
          ((X86_terminal
            ((CMP (Reg ((reg R12) (class_ I64))) (Imm 0))
             (JNE
              ((block ((id_hum intermediate_fib_check_to_fib_body) (args ())))
               (args ()))
              (((block ((id_hum intermediate_fib_check_to_fib_exit) (args ())))
                (args ())))))))))
        (intermediate_fib_check_to_fib_body (args ())
         (instrs ((X86 (JMP ((block ((id_hum fib_body) (args ()))) (args ())))))))
        (fib_body (args ())
         (instrs
          ((X86
            (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg R13) (class_ I64)))))
           (X86
            (ADD (Reg ((reg R15) (class_ I64))) (Reg ((reg R14) (class_ I64)))))
           (X86
            (MOV (Reg ((reg R13) (class_ I64))) (Reg ((reg R14) (class_ I64)))))
           (X86
            (MOV (Reg ((reg R14) (class_ I64))) (Reg ((reg R15) (class_ I64)))))
           (X86
            (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg R12) (class_ I64)))))
           (X86 (SUB (Reg ((reg R15) (class_ I64))) (Imm 1)))
           (X86
            (MOV (Reg ((reg R13) (class_ I64))) (Reg ((reg R13) (class_ I64)))))
           (X86
            (MOV (Reg ((reg R14) (class_ I64))) (Reg ((reg R14) (class_ I64)))))
           (X86
            (MOV (Reg ((reg R12) (class_ I64))) (Reg ((reg R15) (class_ I64)))))
           (X86_terminal
            ((JMP
              ((block
                ((id_hum fib_check)
                 (args
                  (((name b%0) (type_ I64)) ((name count%0) (type_ I64))
                   ((name a%0) (type_ I64))))))
               (args ()))))))))
        (intermediate_fib_check_to_fib_exit (args ())
         (instrs ((X86 (JMP ((block ((id_hum fib_exit) (args ()))) (args ())))))))
        (fib_exit (args ())
         (instrs
          ((X86
            (MOV (Reg ((reg RAX) (class_ I64))) (Reg ((reg R13) (class_ I64)))))
           (X86_terminal
            ((JMP
              ((block
                ((id_hum root__epilogue) (args (((name res__0) (type_ I64))))))
               (args ()))))))))
        (root__epilogue (args (((name res__0) (type_ I64))))
         (instrs
          ((X86
            (MOV (Reg ((reg RAX) (class_ I64))) (Reg ((reg RAX) (class_ I64)))))
           (X86 (SUB (Reg ((reg RBP) (class_ I64))) (Imm 32)))
           (X86
            (MOV (Reg ((reg RSP) (class_ I64))) (Reg ((reg RBP) (class_ I64)))))
           (X86 (POP ((reg R15) (class_ I64))))
           (X86 (POP ((reg R14) (class_ I64))))
           (X86 (POP ((reg R13) (class_ I64))))
           (X86 (POP ((reg R12) (class_ I64))))
           (X86 (POP ((reg RBP) (class_ I64))))
           (X86 (RET ((Reg ((reg RAX) (class_ I64)))))))))))
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
          ((Move ((name i) (type_ I64)) (Lit 1))
           (Move ((name sum) (type_ I64)) (Lit 0))
           (Branch
            (Cond (cond (Lit 1))
             (if_true
              ((block
                ((id_hum check)
                 (args (((name i%1) (type_ I64)) ((name sum%1) (type_ I64))))))
               (args (((name i) (type_ I64)) ((name sum) (type_ I64))))))
             (if_false
              ((block
                ((id_hum exit)
                 (args (((name i%0) (type_ I64)) ((name sum%0) (type_ I64))))))
               (args (((name i) (type_ I64)) ((name sum) (type_ I64)))))))))))
        (check (args (((name i%1) (type_ I64)) ((name sum%1) (type_ I64))))
         (instrs
          ((Sub
            ((dest ((name cond) (type_ I64)))
             (src1 (Var ((name i%1) (type_ I64)))) (src2 (Lit 100))))
           (Branch
            (Cond (cond (Var ((name cond) (type_ I64))))
             (if_true ((block ((id_hum body) (args ()))) (args ())))
             (if_false
              ((block
                ((id_hum exit)
                 (args (((name i%0) (type_ I64)) ((name sum%0) (type_ I64))))))
               (args (((name i%1) (type_ I64)) ((name sum%1) (type_ I64)))))))))))
        (body (args ())
         (instrs
          ((Add
            ((dest ((name sum%2) (type_ I64)))
             (src1 (Var ((name sum%1) (type_ I64))))
             (src2 (Var ((name i%1) (type_ I64))))))
           (Add
            ((dest ((name i%2) (type_ I64)))
             (src1 (Var ((name i%1) (type_ I64)))) (src2 (Lit 1))))
           (Branch
            (Cond (cond (Lit 1))
             (if_true
              ((block
                ((id_hum check)
                 (args (((name i%1) (type_ I64)) ((name sum%1) (type_ I64))))))
               (args (((name i%2) (type_ I64)) ((name sum%2) (type_ I64))))))
             (if_false
              ((block
                ((id_hum exit)
                 (args (((name i%0) (type_ I64)) ((name sum%0) (type_ I64))))))
               (args (((name i%2) (type_ I64)) ((name sum%2) (type_ I64)))))))))))
        (exit (args (((name i%0) (type_ I64)) ((name sum%0) (type_ I64))))
         (instrs ((Return (Var ((name sum%0) (type_ I64)))))))))
      (args ()) (name root) (prologue ()) (epilogue ())
      (bytes_for_clobber_saves 0) (bytes_for_padding 0) (bytes_for_spills 0)
      (bytes_statically_alloca'd 0)))
    (((call_conv Default)
      (root
       ((root__prologue (args ())
         (instrs
          ((X86 (PUSH (Reg ((reg RBP) (class_ I64)))))
           (X86
            (MOV (Reg ((reg RBP) (class_ I64))) (Reg ((reg RSP) (class_ I64)))))
           (X86 (PUSH (Reg ((reg R13) (class_ I64)))))
           (X86 (PUSH (Reg ((reg R14) (class_ I64)))))
           (X86 (PUSH (Reg ((reg R15) (class_ I64)))))
           (X86 (SUB (Reg ((reg RSP) (class_ I64))) (Imm 8)))
           (X86 (Tag_def NOOP (Reg ((reg RBP) (class_ I64)))))
           (X86 (JMP ((block ((id_hum start) (args ()))) (args ())))))))
        (start (args ())
         (instrs
          ((X86 (MOV (Reg ((reg R14) (class_ I64))) (Imm 1)))
           (X86 (MOV (Reg ((reg R15) (class_ I64))) (Imm 0)))
           (X86_terminal
            ((CMP (Imm 1) (Imm 0))
             (JNE
              ((block ((id_hum intermediate_start_to_check) (args ())))
               (args ()))
              (((block ((id_hum intermediate_start_to_exit) (args ())))
                (args ())))))))))
        (intermediate_start_to_check (args ())
         (instrs
          ((X86
            (MOV (Reg ((reg R14) (class_ I64))) (Reg ((reg R14) (class_ I64)))))
           (X86
            (MOV (Reg ((reg R13) (class_ I64))) (Reg ((reg R15) (class_ I64)))))
           (X86
            (JMP
             ((block
               ((id_hum check)
                (args (((name i%1) (type_ I64)) ((name sum%1) (type_ I64))))))
              (args ())))))))
        (check (args (((name i%1) (type_ I64)) ((name sum%1) (type_ I64))))
         (instrs
          ((X86
            (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg R14) (class_ I64)))))
           (X86 (SUB (Reg ((reg R15) (class_ I64))) (Imm 100)))
           (X86_terminal
            ((CMP (Reg ((reg R15) (class_ I64))) (Imm 0))
             (JNE
              ((block ((id_hum intermediate_check_to_body) (args ()))) (args ()))
              (((block ((id_hum intermediate_check_to_exit) (args ())))
                (args ())))))))))
        (intermediate_check_to_body (args ())
         (instrs ((X86 (JMP ((block ((id_hum body) (args ()))) (args ())))))))
        (body (args ())
         (instrs
          ((X86
            (MOV (Reg ((reg R13) (class_ I64))) (Reg ((reg R13) (class_ I64)))))
           (X86
            (ADD (Reg ((reg R13) (class_ I64))) (Reg ((reg R14) (class_ I64)))))
           (X86
            (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg R14) (class_ I64)))))
           (X86 (ADD (Reg ((reg R15) (class_ I64))) (Imm 1)))
           (X86_terminal
            ((CMP (Imm 1) (Imm 0))
             (JNE
              ((block ((id_hum intermediate_body_to_check) (args ()))) (args ()))
              (((block ((id_hum intermediate_body_to_exit) (args ()))) (args ())))))))))
        (intermediate_body_to_check (args ())
         (instrs
          ((X86
            (MOV (Reg ((reg R14) (class_ I64))) (Reg ((reg R15) (class_ I64)))))
           (X86
            (MOV (Reg ((reg R13) (class_ I64))) (Reg ((reg R13) (class_ I64)))))
           (X86
            (JMP
             ((block
               ((id_hum check)
                (args (((name i%1) (type_ I64)) ((name sum%1) (type_ I64))))))
              (args ())))))))
        (intermediate_body_to_exit (args ())
         (instrs
          ((X86
            (MOV (Reg ((reg R14) (class_ I64))) (Reg ((reg R15) (class_ I64)))))
           (X86
            (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg R13) (class_ I64)))))
           (X86
            (JMP
             ((block
               ((id_hum exit)
                (args (((name i%0) (type_ I64)) ((name sum%0) (type_ I64))))))
              (args ())))))))
        (exit (args (((name i%0) (type_ I64)) ((name sum%0) (type_ I64))))
         (instrs
          ((X86
            (MOV (Reg ((reg RAX) (class_ I64))) (Reg ((reg R15) (class_ I64)))))
           (X86_terminal
            ((JMP
              ((block
                ((id_hum root__epilogue) (args (((name res__0) (type_ I64))))))
               (args ()))))))))
        (root__epilogue (args (((name res__0) (type_ I64))))
         (instrs
          ((X86
            (MOV (Reg ((reg RAX) (class_ I64))) (Reg ((reg RAX) (class_ I64)))))
           (X86 (SUB (Reg ((reg RBP) (class_ I64))) (Imm 24)))
           (X86
            (MOV (Reg ((reg RSP) (class_ I64))) (Reg ((reg RBP) (class_ I64)))))
           (X86 (POP ((reg R15) (class_ I64))))
           (X86 (POP ((reg R14) (class_ I64))))
           (X86 (POP ((reg R13) (class_ I64))))
           (X86 (POP ((reg RBP) (class_ I64))))
           (X86 (RET ((Reg ((reg RAX) (class_ I64)))))))))
        (intermediate_check_to_exit (args ())
         (instrs
          ((X86
            (MOV (Reg ((reg R14) (class_ I64))) (Reg ((reg R14) (class_ I64)))))
           (X86
            (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg R13) (class_ I64)))))
           (X86
            (JMP
             ((block
               ((id_hum exit)
                (args (((name i%0) (type_ I64)) ((name sum%0) (type_ I64))))))
              (args ())))))))
        (intermediate_start_to_exit (args ())
         (instrs
          ((X86
            (MOV (Reg ((reg R14) (class_ I64))) (Reg ((reg R14) (class_ I64)))))
           (X86
            (MOV (Reg ((reg R15) (class_ I64))) (Reg ((reg R15) (class_ I64)))))
           (X86
            (JMP
             ((block
               ((id_hum exit)
                (args (((name i%0) (type_ I64)) ((name sum%0) (type_ I64))))))
              (args ())))))))))
      (args ()) (name root) (prologue ()) (epilogue ())
      (bytes_for_clobber_saves 24) (bytes_for_padding 8) (bytes_for_spills 0)
      (bytes_statically_alloca'd 0)))
    |}]
;;
