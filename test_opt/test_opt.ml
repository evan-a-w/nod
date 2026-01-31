open! Core
open! Import

let opt_flags ~unused_vars ~constant_propagation ~gvn : Eir.Opt_flags.t =
  { unused_vars; constant_propagation; gvn }
;;

let compile_to_ssa s =
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
  |> Result.map ~f:(fun program -> state, Ssa.convert_program program ~state)
;;

let dump_program program =
  Map.iter program.Program.functions ~f:(fun fn ->
    let root = Function.root fn in
    Block.iter root ~f:(fun block ->
      let instrs =
        Instr_state.to_ir_list (Block.instructions block)
        |> List.map ~f:Fn_state.var_ir
        |> fun instrs ->
        instrs @ [ Fn_state.var_ir (Block.terminal block).Instr_state.ir ]
      in
      print_s
        [%message
          (Block.id_hum block)
            ~args:(Block.args block : Typed_var.t Vec.read)
            (instrs : Ir.t list)]))
;;

let run ?opt_flags s =
  match compile_to_ssa s with
  | Error e -> Nod_error.to_string e |> print_endline
  | Ok (state, program) ->
    print_endline "before";
    dump_program program;
    print_endline "after";
    ignore (Eir.optimize ?opt_flags ~state program);
    dump_program program
;;

let%expect_test "constant propagation folds arithmetic" =
  run
    ~opt_flags:
      (opt_flags ~unused_vars:false ~constant_propagation:true ~gvn:false)
    {|
entry:
  mov %x:i64, 10
  add %y:i64, %x, 32
  return %y
|};
  [%expect
    {|
    before
    (entry (args ())
     (instrs
      ((Move ((name x) (type_ I64)) (Lit 10))
       (Add
        ((dest ((name y) (type_ I64))) (src1 (Var ((name x) (type_ I64))))
         (src2 (Lit 32))))
       (Return (Var ((name y) (type_ I64)))))))
    after
    (entry (args ())
     (instrs
      ((Move ((name x) (type_ I64)) (Lit 10))
       (Move ((name y) (type_ I64)) (Lit 42)) (Return (Lit 42)))))
    |}]
;;

let%expect_test "dce removes unused values" =
  run
    ~opt_flags:
      (opt_flags ~unused_vars:true ~constant_propagation:false ~gvn:false)
    {|
entry:
  mov %x:i64, 10
  mov %y:i64, 20
  add %z:i64, %x, %y
  return %x
|};
  [%expect
    {|
    before
    (entry (args ())
     (instrs
      ((Move ((name x) (type_ I64)) (Lit 10))
       (Move ((name y) (type_ I64)) (Lit 20))
       (Add
        ((dest ((name z) (type_ I64))) (src1 (Var ((name x) (type_ I64))))
         (src2 (Var ((name y) (type_ I64))))))
       (Return (Var ((name x) (type_ I64)))))))
    after
    (entry (args ())
     (instrs
      ((Move ((name x) (type_ I64)) (Lit 10))
       (Return (Var ((name x) (type_ I64)))))))
    |}]
;;

let%expect_test "constant propagation enables dce" =
  run {|
entry:
  mov %x:i64, 10
  add %y:i64, %x, 32
  return %y
|};
  [%expect
    {|
    before
    (entry (args ())
     (instrs
      ((Move ((name x) (type_ I64)) (Lit 10))
       (Add
        ((dest ((name y) (type_ I64))) (src1 (Var ((name x) (type_ I64))))
         (src2 (Lit 32))))
       (Return (Var ((name y) (type_ I64)))))))
    after
    (entry (args ()) (instrs ((Return (Lit 42)))))
    |}]
;;

let%expect_test "gvn pass is a no-op for now" =
  run
    ~opt_flags:
      (opt_flags ~unused_vars:false ~constant_propagation:false ~gvn:true)
    {|
entry:
  mov %x:i64, 10
  add %y:i64, %x, 32
  add %z:i64, %x, 32
  return %z
|};
  [%expect
    {|
    before
    (entry (args ())
     (instrs
      ((Move ((name x) (type_ I64)) (Lit 10))
       (Add
        ((dest ((name y) (type_ I64))) (src1 (Var ((name x) (type_ I64))))
         (src2 (Lit 32))))
       (Add
        ((dest ((name z) (type_ I64))) (src1 (Var ((name x) (type_ I64))))
         (src2 (Lit 32))))
       (Return (Var ((name z) (type_ I64)))))))
    after
    (entry (args ())
     (instrs
      ((Move ((name x) (type_ I64)) (Lit 10))
       (Add
        ((dest ((name y) (type_ I64))) (src1 (Var ((name x) (type_ I64))))
         (src2 (Lit 32))))
       (Add
        ((dest ((name z) (type_ I64))) (src1 (Var ((name x) (type_ I64))))
         (src2 (Lit 32))))
       (Return (Var ((name z) (type_ I64)))))))
    |}]
;;
