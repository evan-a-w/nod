open! Core
open! Import

let test ?don't_opt s =
  let state = Nod_core.State.create () in
  Test_cfg.test s;
  print_endline "=================================";
  Parser.parse_string s
  |> Result.map ~f:(fun program ->
    { program with
      Program.functions =
        Map.mapi program.Program.functions ~f:(fun ~key:name ~data:fn ->
          Function0.map_root
            fn
            ~f:(Cfg.process ~fn_state:(Nod_core.State.fn_state state name)))
    })
  |> Result.map ~f:(Eir.set_entry_block_args ~state)
  |> Result.map ~f:(fun program ->
    { program with
      Program.functions =
        Map.mapi program.Program.functions ~f:(fun ~key:name ~data:fn ->
          Function0.map_root
            fn
            ~f:(Ssa.create ~fn_state:(Nod_core.State.fn_state state name)))
    })
  |> function
  | Error e -> Nod_error.to_string e |> print_endline
  | Ok program ->
    let go program =
      Map.iter
        program.Program.functions
        ~f:(fun { Function.root = (ssa : Ssa.t); _ } ->
          Vec.iter ssa.in_order ~f:(fun block ->
            let instrs =
              Instr_state.to_ir_list (Block.instructions block)
              @ [ (Block.terminal block).Instr_state.ir ]
            in
            print_s
              [%message
                (Block.id_hum block)
                  ~args:(Block.args block : Var.t Vec.read)
                  (instrs : Ir.t list)]))
    in
    go program;
    (match don't_opt with
     | Some () -> ()
     | None ->
       print_endline "******************************";
       Eir.optimize program;
       go program)
;;

let%expect_test "funs" =
  test
    {| a(%x:i64, %y:i64, %z:i64) {add %a:i64, %x, %y add %a, %a, %z return %a} |};
  [%expect
    {|
    Error: errors in choices `Error: unknown instruction 'a'
    , Error: unexpected token (Ident a) at ((line 0)(col 1)(file""))
    `

    =================================
    Error: errors in choices `Error: unknown instruction 'a'
    , Error: unexpected token (Ident a) at ((line 0)(col 1)(file""))
    `
    |}]
;;

let%expect_test "eir compile with args" =
  match Eir.compile {| a(%x:i64, %y:i64) {add %z:i64, %x, %y return %z} |} with
  | Error e -> Nod_error.to_string e |> print_endline
  | Ok program ->
    Map.iter program.Program.functions ~f:(fun { Function.root = block; _ } ->
      let instrs =
        Instr_state.to_ir_list (Block.instructions block)
        @ [ (Block.terminal block).Instr_state.ir ]
      in
      print_s
        [%message
          (Block.id_hum block)
            ~args:(Block.args block : Var.t Vec.read)
            (instrs : Ir.t list)]);
    [%expect
      {|
      (%root (args (((name x) (type_ I64)) ((name y) (type_ I64))))
       (instrs
        ((Add
          ((dest ((name z) (type_ I64))) (src1 (Var ((name x) (type_ I64))))
           (src2 (Var ((name y) (type_ I64))))))
         (Return (Var ((name z) (type_ I64)))))))
      |}]
;;

let%expect_test "fib" =
  test Examples.Textual.fib;
  [%expect
    {|
    (%root
     (instrs
      ((Move ((name arg) (type_ I64)) (Lit 10))
       (Branch (Uncond ((block ((id_hum fib_start) (args ()))) (args ())))))))
    (fib_start
     (instrs
      ((Move ((name count) (type_ I64)) (Var ((name arg) (type_ I64))))
       (Move ((name a) (type_ I64)) (Lit 0))
       (Move ((name b) (type_ I64)) (Lit 1))
       (Branch (Uncond ((block ((id_hum fib_check) (args ()))) (args ())))))))
    (fib_check
     (instrs
      ((Branch
        (Cond (cond (Var ((name count) (type_ I64))))
         (if_true ((block ((id_hum fib_body) (args ()))) (args ())))
         (if_false ((block ((id_hum fib_exit) (args ()))) (args ()))))))))
    (fib_body
     (instrs
      ((Add
        ((dest ((name next) (type_ I64))) (src1 (Var ((name a) (type_ I64))))
         (src2 (Var ((name b) (type_ I64))))))
       (Move ((name a) (type_ I64)) (Var ((name b) (type_ I64))))
       (Move ((name b) (type_ I64)) (Var ((name next) (type_ I64))))
       (Sub
        ((dest ((name count) (type_ I64)))
         (src1 (Var ((name count) (type_ I64)))) (src2 (Lit 1))))
       (Branch (Uncond ((block ((id_hum fib_check) (args ()))) (args ())))))))
    (fib_exit (instrs ((Return (Var ((name a) (type_ I64)))))))
    =================================
    (%root (args ())
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
        ((dest ((name next) (type_ I64))) (src1 (Var ((name a%0) (type_ I64))))
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
    (fib_exit (args ()) (instrs ((Return (Var ((name a%0) (type_ I64)))))))
    ******************************
    (%root (args ())
     (instrs
      ((Branch (Uncond ((block ((id_hum fib_start) (args ()))) (args ())))))))
    (fib_start (args ())
     (instrs
      ((Move ((name count) (type_ I64)) (Lit 10))
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
        ((dest ((name next) (type_ I64))) (src1 (Var ((name a%0) (type_ I64))))
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
    (fib_exit (args ()) (instrs ((Return (Var ((name a%0) (type_ I64)))))))
    |}]
;;

let%expect_test "fib_rec" =
  test Examples.Textual.fib_recursive;
  [%expect
    {|
    (%root
     (instrs
      ((Branch
        (Cond (cond (Var ((name arg) (type_ I64))))
         (if_true ((block ((id_hum check1_) (args ()))) (args ())))
         (if_false ((block ((id_hum ret_1) (args ()))) (args ()))))))))
    (check1_
     (instrs
      ((Sub
        ((dest ((name m1) (type_ I64))) (src1 (Var ((name arg) (type_ I64))))
         (src2 (Lit 1))))
       (Branch
        (Cond (cond (Var ((name m1) (type_ I64))))
         (if_true ((block ((id_hum rec) (args ()))) (args ())))
         (if_false ((block ((id_hum ret_1) (args ()))) (args ()))))))))
    (ret_1 (instrs ((Return (Lit 1)))))
    (rec
     (instrs
      ((Call (fn fib) (results (((name sub1_res) (type_ I64))))
        (args ((Var ((name m1) (type_ I64))))))
       (Sub
        ((dest ((name m2) (type_ I64))) (src1 (Var ((name m1) (type_ I64))))
         (src2 (Lit 1))))
       (Call (fn fib) (results (((name sub2_res) (type_ I64))))
        (args ((Var ((name m2) (type_ I64))))))
       (Add
        ((dest ((name res) (type_ I64)))
         (src1 (Var ((name sub1_res) (type_ I64))))
         (src2 (Var ((name sub2_res) (type_ I64))))))
       (Return (Var ((name res) (type_ I64)))))))
    =================================
    (%root (args (((name arg) (type_ I64))))
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
        ((dest ((name m1%0) (type_ I64))) (src1 (Var ((name arg) (type_ I64))))
         (src2 (Lit 1))))
       (Branch
        (Cond (cond (Var ((name m1%0) (type_ I64))))
         (if_true ((block ((id_hum rec) (args ()))) (args ())))
         (if_false
          ((block ((id_hum ret_1) (args (((name m1) (type_ I64))))))
           (args (((name m1%0) (type_ I64)))))))))))
    (ret_1 (args (((name m1) (type_ I64)))) (instrs ((Return (Lit 1)))))
    (rec (args ())
     (instrs
      ((Call (fn fib) (results (((name sub1_res) (type_ I64))))
        (args ((Var ((name m1%0) (type_ I64))))))
       (Sub
        ((dest ((name m2) (type_ I64))) (src1 (Var ((name m1%0) (type_ I64))))
         (src2 (Lit 1))))
       (Call (fn fib) (results (((name sub2_res) (type_ I64))))
        (args ((Var ((name m2) (type_ I64))))))
       (Add
        ((dest ((name res) (type_ I64)))
         (src1 (Var ((name sub1_res) (type_ I64))))
         (src2 (Var ((name sub2_res) (type_ I64))))))
       (Return (Var ((name res) (type_ I64)))))))
    ******************************
    (%root (args (((name arg) (type_ I64))))
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
        ((dest ((name m1%0) (type_ I64))) (src1 (Var ((name arg) (type_ I64))))
         (src2 (Lit 1))))
       (Branch
        (Cond (cond (Var ((name m1%0) (type_ I64))))
         (if_true ((block ((id_hum rec) (args ()))) (args ())))
         (if_false
          ((block ((id_hum ret_1) (args (((name m1) (type_ I64))))))
           (args (((name m1%0) (type_ I64)))))))))))
    (ret_1 (args (((name m1) (type_ I64)))) (instrs ((Return (Lit 1)))))
    (rec (args ())
     (instrs
      ((Call (fn fib) (results (((name sub1_res) (type_ I64))))
        (args ((Var ((name m1%0) (type_ I64))))))
       (Sub
        ((dest ((name m2) (type_ I64))) (src1 (Var ((name m1%0) (type_ I64))))
         (src2 (Lit 1))))
       (Call (fn fib) (results (((name sub2_res) (type_ I64))))
        (args ((Var ((name m2) (type_ I64))))))
       (Add
        ((dest ((name res) (type_ I64)))
         (src1 (Var ((name sub1_res) (type_ I64))))
         (src2 (Var ((name sub2_res) (type_ I64))))))
       (Return (Var ((name res) (type_ I64)))))))
    |}]
;;

let%expect_test "phi pruning" =
  test Examples.Textual.e;
  print_endline "";
  print_endline "";
  print_endline "";
  test Examples.Textual.e2;
  [%expect
    {|
    (start
     (instrs
      ((Move ((name x) (type_ I64)) (Lit 7))
       (Move ((name y) (type_ I64)) (Lit 2))
       (Mul
        ((dest ((name x) (type_ I64))) (src1 (Var ((name x) (type_ I64))))
         (src2 (Lit 3))))
       (Div
        ((dest ((name x) (type_ I64))) (src1 (Var ((name x) (type_ I64))))
         (src2 (Var ((name y) (type_ I64))))))
       (Sub
        ((dest ((name cond) (type_ I64))) (src1 (Var ((name y) (type_ I64))))
         (src2 (Lit 2))))
       (Branch
        (Cond (cond (Var ((name cond) (type_ I64))))
         (if_true ((block ((id_hum ifTrue) (args ()))) (args ())))
         (if_false ((block ((id_hum ifFalse) (args ()))) (args ()))))))))
    (ifTrue
     (instrs
      ((Move ((name x) (type_ I64)) (Lit 999))
       (Branch
        (Cond (cond (Lit 1))
         (if_true ((block ((id_hum end) (args ()))) (args ())))
         (if_false ((block ((id_hum end) (args ()))) (args ()))))))))
    (ifFalse
     (instrs
      ((Add
        ((dest ((name x) (type_ I64))) (src1 (Var ((name x) (type_ I64))))
         (src2 (Lit 10))))
       (Branch
        (Cond (cond (Lit 1))
         (if_true ((block ((id_hum end) (args ()))) (args ())))
         (if_false ((block ((id_hum end) (args ()))) (args ()))))))))
    (end (instrs (Unreachable)))
    =================================
    (start (args ())
     (instrs
      ((Move ((name x) (type_ I64)) (Lit 7))
       (Move ((name y) (type_ I64)) (Lit 2))
       (Mul
        ((dest ((name x%0) (type_ I64))) (src1 (Var ((name x) (type_ I64))))
         (src2 (Lit 3))))
       (Div
        ((dest ((name x%1) (type_ I64))) (src1 (Var ((name x%0) (type_ I64))))
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
    (ifFalse (args ())
     (instrs
      ((Add
        ((dest ((name x%3) (type_ I64))) (src1 (Var ((name x%1) (type_ I64))))
         (src2 (Lit 10))))
       (Branch
        (Cond (cond (Lit 1))
         (if_true
          ((block ((id_hum end) (args (((name x%2) (type_ I64))))))
           (args (((name x%3) (type_ I64))))))
         (if_false
          ((block ((id_hum end) (args (((name x%2) (type_ I64))))))
           (args (((name x%3) (type_ I64)))))))))))
    (end (args (((name x%2) (type_ I64)))) (instrs (Unreachable)))
    ******************************
    (start (args ())
     (instrs
      ((Branch (Uncond ((block ((id_hum ifFalse) (args ()))) (args ())))))))
    (ifTrue (args ())
     (instrs ((Branch (Uncond ((block ((id_hum end) (args ()))) (args ())))))))
    (ifFalse (args ())
     (instrs ((Branch (Uncond ((block ((id_hum end) (args ()))) (args ())))))))
    (end (args ()) (instrs (Unreachable)))



    (start
     (instrs
      ((Move ((name x) (type_ I64)) (Lit 7))
       (Move ((name y) (type_ I64)) (Lit 2))
       (Mul
        ((dest ((name x) (type_ I64))) (src1 (Var ((name x) (type_ I64))))
         (src2 (Lit 3))))
       (Div
        ((dest ((name x) (type_ I64))) (src1 (Var ((name x) (type_ I64))))
         (src2 (Var ((name y) (type_ I64))))))
       (Sub
        ((dest ((name cond) (type_ I64))) (src1 (Var ((name y) (type_ I64))))
         (src2 (Lit 2))))
       (Branch
        (Cond (cond (Var ((name cond) (type_ I64))))
         (if_true ((block ((id_hum ifTrue) (args ()))) (args ())))
         (if_false ((block ((id_hum ifFalse) (args ()))) (args ()))))))))
    (ifTrue
     (instrs
      ((Move ((name x) (type_ I64)) (Lit 999))
       (Branch
        (Cond (cond (Lit 1))
         (if_true ((block ((id_hum end) (args ()))) (args ())))
         (if_false ((block ((id_hum end) (args ()))) (args ()))))))))
    (ifFalse
     (instrs
      ((Add
        ((dest ((name x) (type_ I64))) (src1 (Var ((name x) (type_ I64))))
         (src2 (Lit 10))))
       (Branch
        (Cond (cond (Lit 1))
         (if_true ((block ((id_hum end) (args ()))) (args ())))
         (if_false ((block ((id_hum end) (args ()))) (args ()))))))))
    (end (instrs ((Return (Var ((name x) (type_ I64)))))))
    =================================
    (start (args ())
     (instrs
      ((Move ((name x) (type_ I64)) (Lit 7))
       (Move ((name y) (type_ I64)) (Lit 2))
       (Mul
        ((dest ((name x%0) (type_ I64))) (src1 (Var ((name x) (type_ I64))))
         (src2 (Lit 3))))
       (Div
        ((dest ((name x%1) (type_ I64))) (src1 (Var ((name x%0) (type_ I64))))
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
    (ifFalse (args ())
     (instrs
      ((Add
        ((dest ((name x%3) (type_ I64))) (src1 (Var ((name x%1) (type_ I64))))
         (src2 (Lit 10))))
       (Branch
        (Cond (cond (Lit 1))
         (if_true
          ((block ((id_hum end) (args (((name x%2) (type_ I64))))))
           (args (((name x%3) (type_ I64))))))
         (if_false
          ((block ((id_hum end) (args (((name x%2) (type_ I64))))))
           (args (((name x%3) (type_ I64)))))))))))
    (end (args (((name x%2) (type_ I64))))
     (instrs ((Return (Var ((name x%2) (type_ I64)))))))
    ******************************
    (start (args ())
     (instrs
      ((Branch (Uncond ((block ((id_hum ifFalse) (args ()))) (args ())))))))
    (ifTrue (args ())
     (instrs
      ((Move ((name x%4) (type_ I64)) (Lit 999))
       (Branch
        (Uncond
         ((block ((id_hum end) (args (((name x%2) (type_ I64))))))
          (args (((name x%4) (type_ I64))))))))))
    (ifFalse (args ())
     (instrs
      ((Move ((name x%3) (type_ I64)) (Lit 20))
       (Branch
        (Uncond
         ((block ((id_hum end) (args (((name x%2) (type_ I64))))))
          (args (((name x%3) (type_ I64))))))))))
    (end (args (((name x%2) (type_ I64))))
     (instrs ((Return (Var ((name x%2) (type_ I64)))))))
    |}]
;;

let%expect_test "trivial unused vars" =
  test Examples.Textual.c;
  print_endline "";
  print_endline "";
  print_endline "";
  test Examples.Textual.c2;
  [%expect
    {|
    (entry
     (instrs
      ((Move ((name a) (type_ I64)) (Lit 100))
       (Move ((name b) (type_ I64)) (Lit 6))
       (Mod
        ((dest ((name res) (type_ I64))) (src1 (Var ((name a) (type_ I64))))
         (src2 (Var ((name b) (type_ I64))))))
       (Add
        ((dest ((name res) (type_ I64))) (src1 (Var ((name res) (type_ I64))))
         (src2 (Lit 1))))
       Unreachable)))
    =================================
    (entry (args ())
     (instrs
      ((Move ((name a) (type_ I64)) (Lit 100))
       (Move ((name b) (type_ I64)) (Lit 6))
       (Mod
        ((dest ((name res) (type_ I64))) (src1 (Var ((name a) (type_ I64))))
         (src2 (Var ((name b) (type_ I64))))))
       (Add
        ((dest ((name res%0) (type_ I64))) (src1 (Var ((name res) (type_ I64))))
         (src2 (Lit 1))))
       Unreachable)))
    ******************************
    (entry (args ()) (instrs (Unreachable)))



    (entry
     (instrs
      ((Move ((name a) (type_ I64)) (Lit 100))
       (Move ((name b) (type_ I64)) (Lit 6))
       (Mod
        ((dest ((name res) (type_ I64))) (src1 (Var ((name a) (type_ I64))))
         (src2 (Var ((name b) (type_ I64))))))
       (Add
        ((dest ((name res) (type_ I64))) (src1 (Var ((name res) (type_ I64))))
         (src2 (Lit 1))))
       (Return (Var ((name res) (type_ I64)))))))
    =================================
    (entry (args ())
     (instrs
      ((Move ((name a) (type_ I64)) (Lit 100))
       (Move ((name b) (type_ I64)) (Lit 6))
       (Mod
        ((dest ((name res) (type_ I64))) (src1 (Var ((name a) (type_ I64))))
         (src2 (Var ((name b) (type_ I64))))))
       (Add
        ((dest ((name res%0) (type_ I64))) (src1 (Var ((name res) (type_ I64))))
         (src2 (Lit 1))))
       (Return (Var ((name res%0) (type_ I64)))))))
    ******************************
    (entry (args ()) (instrs ((Return (Lit 5)))))
    |}]
;;

let%expect_test "all examples" =
  List.iter Examples.Textual.all ~f:(fun s ->
    test s;
    print_endline "++++++++++++++++++++++++++";
    print_endline "++++++++++++++++++++++++++");
  [%expect
    {|
    (a
     (instrs
      ((Move ((name x) (type_ I64)) (Lit 10))
       (Move ((name y) (type_ I64)) (Lit 20))
       (Sub
        ((dest ((name z) (type_ I64))) (src1 (Var ((name y) (type_ I64))))
         (src2 (Var ((name x) (type_ I64))))))
       (Branch
        (Cond (cond (Lit 1)) (if_true ((block ((id_hum b) (args ()))) (args ())))
         (if_false ((block ((id_hum c) (args ()))) (args ()))))))))
    (b
     (instrs
      ((Add
        ((dest ((name z) (type_ I64))) (src1 (Var ((name z) (type_ I64))))
         (src2 (Lit 5))))
       (Branch
        (Cond (cond (Lit 1))
         (if_true ((block ((id_hum end) (args ()))) (args ())))
         (if_false ((block ((id_hum end) (args ()))) (args ()))))))))
    (c
     (instrs
      ((Move ((name z) (type_ I64)) (Lit 0))
       (Branch
        (Cond (cond (Lit 1))
         (if_true ((block ((id_hum end) (args ()))) (args ())))
         (if_false ((block ((id_hum end) (args ()))) (args ()))))))))
    (end (instrs ((Return (Var ((name z) (type_ I64)))))))
    =================================
    (a (args ())
     (instrs
      ((Move ((name x) (type_ I64)) (Lit 10))
       (Move ((name y) (type_ I64)) (Lit 20))
       (Sub
        ((dest ((name z) (type_ I64))) (src1 (Var ((name y) (type_ I64))))
         (src2 (Var ((name x) (type_ I64))))))
       (Branch
        (Cond (cond (Lit 1)) (if_true ((block ((id_hum b) (args ()))) (args ())))
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
           (args (((name z%1) (type_ I64)))))))))))
    (end (args (((name z%0) (type_ I64))))
     (instrs ((Return (Var ((name z%0) (type_ I64)))))))
    ******************************
    (a (args ())
     (instrs ((Branch (Uncond ((block ((id_hum b) (args ()))) (args ())))))))
    (b (args ())
     (instrs
      ((Move ((name z%2) (type_ I64)) (Lit 15))
       (Branch
        (Uncond
         ((block ((id_hum end) (args (((name z%0) (type_ I64))))))
          (args (((name z%2) (type_ I64))))))))))
    (c (args ())
     (instrs
      ((Move ((name z%1) (type_ I64)) (Lit 0))
       (Branch
        (Uncond
         ((block ((id_hum end) (args (((name z%0) (type_ I64))))))
          (args (((name z%1) (type_ I64))))))))))
    (end (args (((name z%0) (type_ I64))))
     (instrs ((Return (Var ((name z%0) (type_ I64)))))))
    ++++++++++++++++++++++++++
    ++++++++++++++++++++++++++
    (%root
     (instrs
      ((Move ((name a) (type_ I64)) (Lit 4))
       (Move ((name b) (type_ I64)) (Lit 5))
       (Mul
        ((dest ((name c) (type_ I64))) (src1 (Var ((name a) (type_ I64))))
         (src2 (Var ((name b) (type_ I64))))))
       (Branch
        (Cond (cond (Lit 1))
         (if_true ((block ((id_hum divide) (args ()))) (args ())))
         (if_false ((block ((id_hum end) (args ()))) (args ()))))))))
    (divide
     (instrs
      ((Div
        ((dest ((name c) (type_ I64))) (src1 (Var ((name c) (type_ I64))))
         (src2 (Lit 2))))
       (Branch
        (Cond (cond (Lit 1))
         (if_true ((block ((id_hum end) (args ()))) (args ())))
         (if_false ((block ((id_hum end) (args ()))) (args ()))))))))
    (end (instrs (Unreachable)))
    =================================
    (%root (args ())
     (instrs
      ((Move ((name a) (type_ I64)) (Lit 4))
       (Move ((name b) (type_ I64)) (Lit 5))
       (Mul
        ((dest ((name c) (type_ I64))) (src1 (Var ((name a) (type_ I64))))
         (src2 (Var ((name b) (type_ I64))))))
       (Branch
        (Cond (cond (Lit 1))
         (if_true ((block ((id_hum divide) (args ()))) (args ())))
         (if_false
          ((block ((id_hum end) (args (((name c%0) (type_ I64))))))
           (args (((name c) (type_ I64)))))))))))
    (divide (args ())
     (instrs
      ((Div
        ((dest ((name c%1) (type_ I64))) (src1 (Var ((name c) (type_ I64))))
         (src2 (Lit 2))))
       (Branch
        (Cond (cond (Lit 1))
         (if_true
          ((block ((id_hum end) (args (((name c%0) (type_ I64))))))
           (args (((name c%1) (type_ I64))))))
         (if_false
          ((block ((id_hum end) (args (((name c%0) (type_ I64))))))
           (args (((name c%1) (type_ I64)))))))))))
    (end (args (((name c%0) (type_ I64)))) (instrs (Unreachable)))
    ******************************
    (%root (args ())
     (instrs ((Branch (Uncond ((block ((id_hum divide) (args ()))) (args ())))))))
    (divide (args ())
     (instrs ((Branch (Uncond ((block ((id_hum end) (args ()))) (args ())))))))
    (end (args ()) (instrs (Unreachable)))
    ++++++++++++++++++++++++++
    ++++++++++++++++++++++++++
    (entry
     (instrs
      ((Move ((name a) (type_ I64)) (Lit 100))
       (Move ((name b) (type_ I64)) (Lit 6))
       (Mod
        ((dest ((name res) (type_ I64))) (src1 (Var ((name a) (type_ I64))))
         (src2 (Var ((name b) (type_ I64))))))
       (Add
        ((dest ((name res) (type_ I64))) (src1 (Var ((name res) (type_ I64))))
         (src2 (Lit 1))))
       Unreachable)))
    =================================
    (entry (args ())
     (instrs
      ((Move ((name a) (type_ I64)) (Lit 100))
       (Move ((name b) (type_ I64)) (Lit 6))
       (Mod
        ((dest ((name res) (type_ I64))) (src1 (Var ((name a) (type_ I64))))
         (src2 (Var ((name b) (type_ I64))))))
       (Add
        ((dest ((name res%0) (type_ I64))) (src1 (Var ((name res) (type_ I64))))
         (src2 (Lit 1))))
       Unreachable)))
    ******************************
    (entry (args ()) (instrs (Unreachable)))
    ++++++++++++++++++++++++++
    ++++++++++++++++++++++++++
    (%root
     (instrs
      ((Move ((name i) (type_ I64)) (Lit 0))
       (Move ((name sum) (type_ I64)) (Lit 0))
       (Branch
        (Cond (cond (Lit 1))
         (if_true ((block ((id_hum loop) (args ()))) (args ())))
         (if_false ((block ((id_hum loop) (args ()))) (args ()))))))))
    (loop
     (instrs
      ((Add
        ((dest ((name sum) (type_ I64))) (src1 (Var ((name sum) (type_ I64))))
         (src2 (Var ((name i) (type_ I64))))))
       (Add
        ((dest ((name i) (type_ I64))) (src1 (Var ((name i) (type_ I64))))
         (src2 (Lit 1))))
       (Sub
        ((dest ((name cond) (type_ I64))) (src1 (Lit 10))
         (src2 (Var ((name i) (type_ I64))))))
       (Branch
        (Cond (cond (Var ((name cond) (type_ I64))))
         (if_true ((block ((id_hum loop) (args ()))) (args ())))
         (if_false ((block ((id_hum end) (args ()))) (args ()))))))))
    (end (instrs (Unreachable)))
    =================================
    (%root (args ())
     (instrs
      ((Move ((name i) (type_ I64)) (Lit 0))
       (Move ((name sum) (type_ I64)) (Lit 0))
       (Branch
        (Cond (cond (Lit 1))
         (if_true
          ((block
            ((id_hum loop)
             (args (((name i%0) (type_ I64)) ((name sum%0) (type_ I64))))))
           (args (((name i) (type_ I64)) ((name sum) (type_ I64))))))
         (if_false
          ((block
            ((id_hum loop)
             (args (((name i%0) (type_ I64)) ((name sum%0) (type_ I64))))))
           (args (((name i) (type_ I64)) ((name sum) (type_ I64)))))))))))
    (loop (args (((name i%0) (type_ I64)) ((name sum%0) (type_ I64))))
     (instrs
      ((Add
        ((dest ((name sum%1) (type_ I64)))
         (src1 (Var ((name sum%0) (type_ I64))))
         (src2 (Var ((name i%0) (type_ I64))))))
       (Add
        ((dest ((name i%1) (type_ I64))) (src1 (Var ((name i%0) (type_ I64))))
         (src2 (Lit 1))))
       (Sub
        ((dest ((name cond) (type_ I64))) (src1 (Lit 10))
         (src2 (Var ((name i%1) (type_ I64))))))
       (Branch
        (Cond (cond (Var ((name cond) (type_ I64))))
         (if_true
          ((block
            ((id_hum loop)
             (args (((name i%0) (type_ I64)) ((name sum%0) (type_ I64))))))
           (args (((name i%1) (type_ I64)) ((name sum%1) (type_ I64))))))
         (if_false ((block ((id_hum end) (args ()))) (args ()))))))))
    (end (args ()) (instrs (Unreachable)))
    ******************************
    (%root (args ())
     (instrs
      ((Move ((name i) (type_ I64)) (Lit 0))
       (Move ((name sum) (type_ I64)) (Lit 0))
       (Branch
        (Uncond
         ((block
           ((id_hum loop)
            (args (((name i%0) (type_ I64)) ((name sum%0) (type_ I64))))))
          (args (((name i) (type_ I64)) ((name sum) (type_ I64))))))))))
    (loop (args (((name i%0) (type_ I64)) ((name sum%0) (type_ I64))))
     (instrs
      ((Add
        ((dest ((name sum%1) (type_ I64)))
         (src1 (Var ((name sum%0) (type_ I64))))
         (src2 (Var ((name i%0) (type_ I64))))))
       (Add
        ((dest ((name i%1) (type_ I64))) (src1 (Lit 1))
         (src2 (Var ((name i%0) (type_ I64))))))
       (Sub
        ((dest ((name cond) (type_ I64))) (src1 (Lit 10))
         (src2 (Var ((name i%1) (type_ I64))))))
       (Branch
        (Cond (cond (Var ((name cond) (type_ I64))))
         (if_true
          ((block
            ((id_hum loop)
             (args (((name i%0) (type_ I64)) ((name sum%0) (type_ I64))))))
           (args (((name i%1) (type_ I64)) ((name sum%1) (type_ I64))))))
         (if_false ((block ((id_hum end) (args ()))) (args ()))))))))
    (end (args ()) (instrs (Unreachable)))
    ++++++++++++++++++++++++++
    ++++++++++++++++++++++++++
    (start
     (instrs
      ((Move ((name x) (type_ I64)) (Lit 7))
       (Move ((name y) (type_ I64)) (Lit 2))
       (Mul
        ((dest ((name x) (type_ I64))) (src1 (Var ((name x) (type_ I64))))
         (src2 (Lit 3))))
       (Div
        ((dest ((name x) (type_ I64))) (src1 (Var ((name x) (type_ I64))))
         (src2 (Var ((name y) (type_ I64))))))
       (Sub
        ((dest ((name cond) (type_ I64))) (src1 (Var ((name y) (type_ I64))))
         (src2 (Lit 2))))
       (Branch
        (Cond (cond (Var ((name cond) (type_ I64))))
         (if_true ((block ((id_hum ifTrue) (args ()))) (args ())))
         (if_false ((block ((id_hum ifFalse) (args ()))) (args ()))))))))
    (ifTrue
     (instrs
      ((Move ((name x) (type_ I64)) (Lit 999))
       (Branch
        (Cond (cond (Lit 1))
         (if_true ((block ((id_hum end) (args ()))) (args ())))
         (if_false ((block ((id_hum end) (args ()))) (args ()))))))))
    (ifFalse
     (instrs
      ((Add
        ((dest ((name x) (type_ I64))) (src1 (Var ((name x) (type_ I64))))
         (src2 (Lit 10))))
       (Branch
        (Cond (cond (Lit 1))
         (if_true ((block ((id_hum end) (args ()))) (args ())))
         (if_false ((block ((id_hum end) (args ()))) (args ()))))))))
    (end (instrs (Unreachable)))
    =================================
    (start (args ())
     (instrs
      ((Move ((name x) (type_ I64)) (Lit 7))
       (Move ((name y) (type_ I64)) (Lit 2))
       (Mul
        ((dest ((name x%0) (type_ I64))) (src1 (Var ((name x) (type_ I64))))
         (src2 (Lit 3))))
       (Div
        ((dest ((name x%1) (type_ I64))) (src1 (Var ((name x%0) (type_ I64))))
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
    (ifFalse (args ())
     (instrs
      ((Add
        ((dest ((name x%3) (type_ I64))) (src1 (Var ((name x%1) (type_ I64))))
         (src2 (Lit 10))))
       (Branch
        (Cond (cond (Lit 1))
         (if_true
          ((block ((id_hum end) (args (((name x%2) (type_ I64))))))
           (args (((name x%3) (type_ I64))))))
         (if_false
          ((block ((id_hum end) (args (((name x%2) (type_ I64))))))
           (args (((name x%3) (type_ I64)))))))))))
    (end (args (((name x%2) (type_ I64)))) (instrs (Unreachable)))
    ******************************
    (start (args ())
     (instrs
      ((Branch (Uncond ((block ((id_hum ifFalse) (args ()))) (args ())))))))
    (ifTrue (args ())
     (instrs ((Branch (Uncond ((block ((id_hum end) (args ()))) (args ())))))))
    (ifFalse (args ())
     (instrs ((Branch (Uncond ((block ((id_hum end) (args ()))) (args ())))))))
    (end (args ()) (instrs (Unreachable)))
    ++++++++++++++++++++++++++
    ++++++++++++++++++++++++++
    (entry
     (instrs
      ((Move ((name a) (type_ I64)) (Lit 100))
       (Move ((name b) (type_ I64)) (Lit 6))
       (Mod
        ((dest ((name res) (type_ I64))) (src1 (Var ((name a) (type_ I64))))
         (src2 (Var ((name b) (type_ I64))))))
       (Add
        ((dest ((name res) (type_ I64))) (src1 (Var ((name res) (type_ I64))))
         (src2 (Lit 1))))
       (Return (Var ((name res) (type_ I64)))))))
    =================================
    (entry (args ())
     (instrs
      ((Move ((name a) (type_ I64)) (Lit 100))
       (Move ((name b) (type_ I64)) (Lit 6))
       (Mod
        ((dest ((name res) (type_ I64))) (src1 (Var ((name a) (type_ I64))))
         (src2 (Var ((name b) (type_ I64))))))
       (Add
        ((dest ((name res%0) (type_ I64))) (src1 (Var ((name res) (type_ I64))))
         (src2 (Lit 1))))
       (Return (Var ((name res%0) (type_ I64)))))))
    ******************************
    (entry (args ()) (instrs ((Return (Lit 5)))))
    ++++++++++++++++++++++++++
    ++++++++++++++++++++++++++
    (start
     (instrs
      ((Move ((name x) (type_ I64)) (Lit 7))
       (Move ((name y) (type_ I64)) (Lit 2))
       (Mul
        ((dest ((name x) (type_ I64))) (src1 (Var ((name x) (type_ I64))))
         (src2 (Lit 3))))
       (Div
        ((dest ((name x) (type_ I64))) (src1 (Var ((name x) (type_ I64))))
         (src2 (Var ((name y) (type_ I64))))))
       (Sub
        ((dest ((name cond) (type_ I64))) (src1 (Var ((name y) (type_ I64))))
         (src2 (Lit 2))))
       (Branch
        (Cond (cond (Var ((name cond) (type_ I64))))
         (if_true ((block ((id_hum ifTrue) (args ()))) (args ())))
         (if_false ((block ((id_hum ifFalse) (args ()))) (args ()))))))))
    (ifTrue
     (instrs
      ((Move ((name x) (type_ I64)) (Lit 999))
       (Branch
        (Cond (cond (Lit 1))
         (if_true ((block ((id_hum end) (args ()))) (args ())))
         (if_false ((block ((id_hum end) (args ()))) (args ()))))))))
    (ifFalse
     (instrs
      ((Add
        ((dest ((name x) (type_ I64))) (src1 (Var ((name x) (type_ I64))))
         (src2 (Lit 10))))
       (Branch
        (Cond (cond (Lit 1))
         (if_true ((block ((id_hum end) (args ()))) (args ())))
         (if_false ((block ((id_hum end) (args ()))) (args ()))))))))
    (end (instrs ((Return (Var ((name x) (type_ I64)))))))
    =================================
    (start (args ())
     (instrs
      ((Move ((name x) (type_ I64)) (Lit 7))
       (Move ((name y) (type_ I64)) (Lit 2))
       (Mul
        ((dest ((name x%0) (type_ I64))) (src1 (Var ((name x) (type_ I64))))
         (src2 (Lit 3))))
       (Div
        ((dest ((name x%1) (type_ I64))) (src1 (Var ((name x%0) (type_ I64))))
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
    (ifFalse (args ())
     (instrs
      ((Add
        ((dest ((name x%3) (type_ I64))) (src1 (Var ((name x%1) (type_ I64))))
         (src2 (Lit 10))))
       (Branch
        (Cond (cond (Lit 1))
         (if_true
          ((block ((id_hum end) (args (((name x%2) (type_ I64))))))
           (args (((name x%3) (type_ I64))))))
         (if_false
          ((block ((id_hum end) (args (((name x%2) (type_ I64))))))
           (args (((name x%3) (type_ I64)))))))))))
    (end (args (((name x%2) (type_ I64))))
     (instrs ((Return (Var ((name x%2) (type_ I64)))))))
    ******************************
    (start (args ())
     (instrs
      ((Branch (Uncond ((block ((id_hum ifFalse) (args ()))) (args ())))))))
    (ifTrue (args ())
     (instrs
      ((Move ((name x%4) (type_ I64)) (Lit 999))
       (Branch
        (Uncond
         ((block ((id_hum end) (args (((name x%2) (type_ I64))))))
          (args (((name x%4) (type_ I64))))))))))
    (ifFalse (args ())
     (instrs
      ((Move ((name x%3) (type_ I64)) (Lit 20))
       (Branch
        (Uncond
         ((block ((id_hum end) (args (((name x%2) (type_ I64))))))
          (args (((name x%3) (type_ I64))))))))))
    (end (args (((name x%2) (type_ I64))))
     (instrs ((Return (Var ((name x%2) (type_ I64)))))))
    ++++++++++++++++++++++++++
    ++++++++++++++++++++++++++
    |}]
;;

let%expect_test "longer example" =
  test Examples.Textual.f;
  [%expect
    {|
    (start
     (instrs
      ((Move ((name n) (type_ I64)) (Lit 7))
       (Move ((name i) (type_ I64)) (Lit 0))
       (Move ((name total) (type_ I64)) (Lit 0))
       (Branch
        (Cond (cond (Lit 1))
         (if_true ((block ((id_hum outerCheck) (args ()))) (args ())))
         (if_false ((block ((id_hum exit) (args ()))) (args ()))))))))
    (outerCheck
     (instrs
      ((Sub
        ((dest ((name condOuter) (type_ I64)))
         (src1 (Var ((name i) (type_ I64)))) (src2 (Var ((name n) (type_ I64))))))
       (Branch
        (Cond (cond (Var ((name condOuter) (type_ I64))))
         (if_true ((block ((id_hum outerBody) (args ()))) (args ())))
         (if_false ((block ((id_hum exit) (args ()))) (args ()))))))))
    (outerBody
     (instrs
      ((Move ((name j) (type_ I64)) (Lit 0))
       (Move ((name partial) (type_ I64)) (Lit 0))
       (Branch
        (Cond (cond (Lit 1))
         (if_true ((block ((id_hum innerCheck) (args ()))) (args ())))
         (if_false ((block ((id_hum outerInc) (args ()))) (args ()))))))))
    (innerCheck
     (instrs
      ((Sub
        ((dest ((name condInner) (type_ I64)))
         (src1 (Var ((name j) (type_ I64)))) (src2 (Lit 3))))
       (Branch
        (Cond (cond (Var ((name condInner) (type_ I64))))
         (if_true ((block ((id_hum innerBody) (args ()))) (args ())))
         (if_false ((block ((id_hum innerExit) (args ()))) (args ()))))))))
    (innerBody
     (instrs
      ((And
        ((dest ((name isEven) (type_ I64))) (src1 (Var ((name j) (type_ I64))))
         (src2 (Lit 1))))
       (Sub
        ((dest ((name condSkip) (type_ I64)))
         (src1 (Var ((name isEven) (type_ I64)))) (src2 (Lit 0))))
       (Branch
        (Cond (cond (Var ((name condSkip) (type_ I64))))
         (if_true ((block ((id_hum doWork) (args ()))) (args ())))
         (if_false ((block ((id_hum skipEven) (args ()))) (args ()))))))))
    (skipEven
     (instrs
      ((Add
        ((dest ((name j) (type_ I64))) (src1 (Var ((name j) (type_ I64))))
         (src2 (Lit 1))))
       (Branch
        (Cond (cond (Lit 1))
         (if_true ((block ((id_hum innerCheck) (args ()))) (args ())))
         (if_false ((block ((id_hum innerExit) (args ()))) (args ()))))))))
    (doWork
     (instrs
      ((Mul
        ((dest ((name tmp) (type_ I64))) (src1 (Var ((name i) (type_ I64))))
         (src2 (Var ((name j) (type_ I64))))))
       (Add
        ((dest ((name partial) (type_ I64)))
         (src1 (Var ((name partial) (type_ I64))))
         (src2 (Var ((name tmp) (type_ I64))))))
       (Add
        ((dest ((name j) (type_ I64))) (src1 (Var ((name j) (type_ I64))))
         (src2 (Lit 1))))
       (Branch
        (Cond (cond (Lit 1))
         (if_true ((block ((id_hum innerCheck) (args ()))) (args ())))
         (if_false ((block ((id_hum innerExit) (args ()))) (args ()))))))))
    (innerExit
     (instrs
      ((Add
        ((dest ((name total) (type_ I64)))
         (src1 (Var ((name total) (type_ I64))))
         (src2 (Var ((name partial) (type_ I64))))))
       (Branch
        (Cond (cond (Lit 1))
         (if_true ((block ((id_hum outerInc) (args ()))) (args ())))
         (if_false ((block ((id_hum exit) (args ()))) (args ()))))))))
    (outerInc
     (instrs
      ((Add
        ((dest ((name i) (type_ I64))) (src1 (Var ((name i) (type_ I64))))
         (src2 (Lit 1))))
       (Branch (Uncond ((block ((id_hum outerCheck) (args ()))) (args ())))))))
    (exit (instrs ((Return (Var ((name total) (type_ I64)))))))
    =================================
    (start (args ())
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
    (innerCheck (args (((name j%1) (type_ I64)) ((name partial%1) (type_ I64))))
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
        ((dest ((name isEven) (type_ I64))) (src1 (Var ((name j%1) (type_ I64))))
         (src2 (Lit 1))))
       (Sub
        ((dest ((name condSkip) (type_ I64)))
         (src1 (Var ((name isEven) (type_ I64)))) (src2 (Lit 0))))
       (Branch
        (Cond (cond (Var ((name condSkip) (type_ I64))))
         (if_true ((block ((id_hum doWork) (args ()))) (args ())))
         (if_false ((block ((id_hum skipEven) (args ()))) (args ()))))))))
    (skipEven (args ())
     (instrs
      ((Add
        ((dest ((name j%4) (type_ I64))) (src1 (Var ((name j%1) (type_ I64))))
         (src2 (Lit 1))))
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
           (args (((name j%4) (type_ I64)) ((name partial%1) (type_ I64)))))))))))
    (doWork (args ())
     (instrs
      ((Mul
        ((dest ((name tmp) (type_ I64))) (src1 (Var ((name i%0) (type_ I64))))
         (src2 (Var ((name j%1) (type_ I64))))))
       (Add
        ((dest ((name partial%3) (type_ I64)))
         (src1 (Var ((name partial%1) (type_ I64))))
         (src2 (Var ((name tmp) (type_ I64))))))
       (Add
        ((dest ((name j%3) (type_ I64))) (src1 (Var ((name j%1) (type_ I64))))
         (src2 (Lit 1))))
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
    (innerExit (args (((name j%2) (type_ I64)) ((name partial%2) (type_ I64))))
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
        ((dest ((name i%1) (type_ I64))) (src1 (Var ((name i%0) (type_ I64))))
         (src2 (Lit 1))))
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
    ******************************
    (start (args ())
     (instrs
      ((Move ((name i) (type_ I64)) (Lit 0))
       (Branch
        (Uncond
         ((block
           ((id_hum outerCheck)
            (args
             (((name i%0) (type_ I64)) ((name j) (type_ I64))
              ((name partial) (type_ I64))))))
          (args
           (((name i) (type_ I64)) ((name j) (type_ I64))
            ((name partial) (type_ I64))))))))))
    (outerCheck
     (args
      (((name i%0) (type_ I64)) ((name j) (type_ I64))
       ((name partial) (type_ I64))))
     (instrs
      ((Sub
        ((dest ((name condOuter) (type_ I64)))
         (src1 (Var ((name i%0) (type_ I64)))) (src2 (Lit 7))))
       (Branch
        (Cond (cond (Var ((name condOuter) (type_ I64))))
         (if_true ((block ((id_hum outerBody) (args ()))) (args ())))
         (if_false ((block ((id_hum exit) (args ()))) (args ()))))))))
    (outerBody (args ())
     (instrs
      ((Move ((name j%0) (type_ I64)) (Lit 0))
       (Move ((name partial%0) (type_ I64)) (Lit 0))
       (Branch
        (Uncond
         ((block
           ((id_hum innerCheck)
            (args (((name j%1) (type_ I64)) ((name partial%1) (type_ I64))))))
          (args (((name j%0) (type_ I64)) ((name partial%0) (type_ I64))))))))))
    (innerCheck (args (((name j%1) (type_ I64)) ((name partial%1) (type_ I64))))
     (instrs
      ((Sub
        ((dest ((name condInner) (type_ I64)))
         (src1 (Var ((name j%1) (type_ I64)))) (src2 (Lit 3))))
       (Branch
        (Cond (cond (Var ((name condInner) (type_ I64))))
         (if_true ((block ((id_hum innerBody) (args ()))) (args ())))
         (if_false ((block ((id_hum innerExit) (args ()))) (args ()))))))))
    (innerBody (args ())
     (instrs
      ((And
        ((dest ((name isEven) (type_ I64))) (src1 (Var ((name j%1) (type_ I64))))
         (src2 (Lit 1))))
       (Move ((name condSkip) (type_ I64)) (Var ((name isEven) (type_ I64))))
       (Branch
        (Cond (cond (Var ((name condSkip) (type_ I64))))
         (if_true ((block ((id_hum doWork) (args ()))) (args ())))
         (if_false ((block ((id_hum skipEven) (args ()))) (args ()))))))))
    (skipEven (args ())
     (instrs
      ((Add
        ((dest ((name j%4) (type_ I64))) (src1 (Lit 1))
         (src2 (Var ((name j%1) (type_ I64))))))
       (Branch
        (Cond (cond (Lit 1))
         (if_true
          ((block
            ((id_hum innerCheck)
             (args (((name j%1) (type_ I64)) ((name partial%1) (type_ I64))))))
           (args (((name j%4) (type_ I64)) ((name partial%1) (type_ I64))))))
         (if_false ((block ((id_hum innerExit) (args ()))) (args ()))))))))
    (doWork (args ())
     (instrs
      ((Mul
        ((dest ((name tmp) (type_ I64))) (src1 (Var ((name i%0) (type_ I64))))
         (src2 (Var ((name j%1) (type_ I64))))))
       (Add
        ((dest ((name partial%3) (type_ I64)))
         (src1 (Var ((name partial%1) (type_ I64))))
         (src2 (Var ((name tmp) (type_ I64))))))
       (Add
        ((dest ((name j%3) (type_ I64))) (src1 (Lit 1))
         (src2 (Var ((name j%1) (type_ I64))))))
       (Branch
        (Uncond
         ((block
           ((id_hum innerCheck)
            (args (((name j%1) (type_ I64)) ((name partial%1) (type_ I64))))))
          (args (((name j%3) (type_ I64)) ((name partial%3) (type_ I64))))))))))
    (innerExit (args ())
     (instrs
      ((Branch (Uncond ((block ((id_hum outerInc) (args ()))) (args ())))))))
    (outerInc (args ())
     (instrs
      ((Add
        ((dest ((name i%1) (type_ I64))) (src1 (Lit 1))
         (src2 (Var ((name i%0) (type_ I64))))))
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
    (exit (args ()) (instrs ((Return (Lit 0)))))
    |}]
;;
