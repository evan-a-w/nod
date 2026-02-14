open! Core
open! Import

let compile_to_ssa ?(mem2reg = true) s =
  let state = Nod_core.State.create () in
  Parser.parse_string s
  |> Result.map ~f:(fun program ->
    { program with
      Program.functions =
        Map.mapi program.Program.functions ~f:(fun ~key:name ~data:fn ->
          Function.map_root
            fn
            ~f:(Cfg.process ~fn_state:(Nod_core.State.fn_state state name)))
    })
  |> Result.map ~f:(Eir.set_entry_block_args ~state)
  |> Result.map ~f:(fun program -> Ssa.convert_program program ~state ~mem2reg)
;;

let print_program program =
  Map.iter program.Program.functions ~f:(fun fn ->
    Block.iter (Function.root fn) ~f:(fun block ->
      let instrs =
        Instr_state.to_ir_list (Block.instructions block)
        |> List.map ~f:Fn_state.var_ir
        |> fun instrs -> instrs @ [ Fn_state.var_ir (Block.terminal block).Instr_state.ir ]
      in
      print_s
        [%message
          (Block.id_hum block)
            ~args:(Block.args block : Typed_var.t Nod_vec.read)
            (instrs : Ir.t list)]))
;;

let%expect_test "mem2reg simple promote" =
  let input =
    {|
    f() {
      alloca %p:ptr, i64
      store %p, 42
      load %a:i64, %p
      return %a
    }
    |}
  in
  (match compile_to_ssa ~mem2reg:false input with
   | Error e -> Nod_error.to_string e |> print_endline
   | Ok program -> print_program program);
  print_endline "---- mem2reg on ----";
  (match compile_to_ssa ~mem2reg:true input with
   | Error e -> Nod_error.to_string e |> print_endline
   | Ok program -> print_program program);
  [%expect
    {|
    (%root (args ())
     (instrs
      ((Alloca ((dest ((name p) (type_ Ptr))) (size (Lit 8))))
       (Store (Lit 42)
        (Address ((base (Var ((name p) (type_ Ptr)))) (offset 0))))
       (Load ((name a) (type_ I64))
        (Address ((base (Var ((name p) (type_ Ptr)))) (offset 0))))
       (Return (Var ((name a) (type_ I64)))))))
    ---- mem2reg on ----
    (%root (args ())
     (instrs
      ((Move ((name p$v) (type_ I64)) (Lit 42))
       (Move ((name a) (type_ I64)) (Var ((name p$v) (type_ I64))))
       (Return (Var ((name a) (type_ I64)))))))
    |}]
;;

let%expect_test "mem2reg inserts phi at join" =
  let input =
    {|
    f() {
      alloca %p:ptr, i64
      move %cond:i64, 1
      branch %cond, then_blk, else_blk
    then_blk:
      store %p, 10
      branch join
    else_blk:
      store %p, 20
      branch join
    join:
      load %a:i64, %p
      return %a
    }
    |}
  in
  (match compile_to_ssa ~mem2reg:false input with
   | Error e -> Nod_error.to_string e |> print_endline
   | Ok program -> print_program program);
  print_endline "---- mem2reg on ----";
  (match compile_to_ssa ~mem2reg:true input with
   | Error e -> Nod_error.to_string e |> print_endline
   | Ok program -> print_program program);
  [%expect
    {|
    (%root (args ())
     (instrs
      ((Alloca ((dest ((name p) (type_ Ptr))) (size (Lit 8))))
       (Move ((name cond) (type_ I64)) (Lit 1))
       (Branch
        (Cond (cond (Var ((name cond) (type_ I64))))
         (if_true ((block ((id_hum then_blk) (args ()))) (args ())))
         (if_false ((block ((id_hum else_blk) (args ()))) (args ()))))))))
    (then_blk (args ())
     (instrs
      ((Store (Lit 10)
        (Address ((base (Var ((name p) (type_ Ptr)))) (offset 0))))
       (Branch (Uncond ((block ((id_hum join) (args ()))) (args ())))))))
    (join (args ())
     (instrs
      ((Load ((name a) (type_ I64))
        (Address ((base (Var ((name p) (type_ Ptr)))) (offset 0))))
       (Return (Var ((name a) (type_ I64)))))))
    (else_blk (args ())
     (instrs
      ((Store (Lit 20)
        (Address ((base (Var ((name p) (type_ Ptr)))) (offset 0))))
       (Branch (Uncond ((block ((id_hum join) (args ()))) (args ())))))))
    ---- mem2reg on ----
    (%root (args ())
     (instrs
      ((Move ((name cond) (type_ I64)) (Lit 1))
       (Branch
        (Cond (cond (Var ((name cond) (type_ I64))))
         (if_true ((block ((id_hum then_blk) (args ()))) (args ())))
         (if_false ((block ((id_hum else_blk) (args ()))) (args ()))))))))
    (then_blk (args ())
     (instrs
      ((Move ((name p$v%1) (type_ I64)) (Lit 10))
       (Branch
        (Uncond
         ((block ((id_hum join) (args (((name p$v) (type_ I64))))))
          (args (((name p$v%1) (type_ I64))))))))))
    (join (args (((name p$v) (type_ I64))))
     (instrs
      ((Move ((name a) (type_ I64)) (Var ((name p$v) (type_ I64))))
       (Return (Var ((name a) (type_ I64)))))))
    (else_blk (args ())
     (instrs
      ((Move ((name p$v%0) (type_ I64)) (Lit 20))
       (Branch
        (Uncond
         ((block ((id_hum join) (args (((name p$v) (type_ I64))))))
          (args (((name p$v%0) (type_ I64))))))))))
    |}]
;;

let%expect_test "mem2reg does not promote on pointer escape" =
  let input =
    {|
    f() {
      alloca %p:ptr, i64
      add %q:ptr, %p, 8
      store %p, 1
      load %a:i64, %p
      return %a
    }
    |}
  in
  (match compile_to_ssa ~mem2reg:true input with
   | Error e -> Nod_error.to_string e |> print_endline
   | Ok program -> print_program program);
  [%expect
    {|
    (%root (args ())
     (instrs
      ((Alloca ((dest ((name p) (type_ Ptr))) (size (Lit 8))))
       (Add
        ((dest ((name q) (type_ Ptr))) (src1 (Var ((name p) (type_ Ptr))))
         (src2 (Lit 8))))
       (Store (Lit 1) (Address ((base (Var ((name p) (type_ Ptr)))) (offset 0))))
       (Load ((name a) (type_ I64))
        (Address ((base (Var ((name p) (type_ Ptr)))) (offset 0))))
       (Return (Var ((name a) (type_ I64)))))))
    |}]
;;
