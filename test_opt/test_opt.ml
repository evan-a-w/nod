open! Core
open! Import
open! Dsl

let opt_flags ~unused_vars ~constant_propagation ~gvn : Eir.Opt_flags.t =
  { unused_vars; constant_propagation; gvn }
;;

let lower_to_ssa program =
  let state = Nod_core.State.create () in
  let program =
    { program with
      Program.functions =
        Map.mapi program.Program.functions ~f:(fun ~key:name ~data:fn ->
          Function.map_root
            fn
            ~f:(Cfg.process ~fn_state:(Nod_core.State.fn_state state name)))
    }
  in
  let program = Eir.set_entry_block_args ~state program in
  state, Ssa.convert_program program ~state
;;

let compile_to_ssa s = Parser.parse_string s |> Result.map ~f:lower_to_ssa

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
            ~args:(Block.args block : Typed_var.t Nod_vec.read)
            (instrs : Ir.t list)]))
;;

let run_compiled ?opt_flags (state, program) =
  print_endline "before";
  dump_program program;
  print_endline "after";
  ignore (Eir.optimize ?opt_flags ~state program);
  dump_program program
;;

let run_program ?opt_flags program =
  lower_to_ssa program |> run_compiled ?opt_flags
;;

let run_dsl ?opt_flags functions =
  Dsl.program ~globals:[] ~functions:(List.map functions ~f:Dsl.Fn.pack)
  |> Result.map_error ~f:Nod_error.to_string
  |> Result.ok_or_failwith
  |> run_program ?opt_flags
;;

let run_dsl' ?opt_flags irs =
  let unnamed = Dsl.Fn.Unnamed.const Int64 irs in
  let fn = Dsl.Fn.create ~unnamed ~name:"root" in
  run_dsl ?opt_flags [ fn ]
;;

let run ?opt_flags s =
  match compile_to_ssa s with
  | Error e -> Nod_error.to_string e |> print_endline
  | Ok compiled -> run_compiled ?opt_flags compiled
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

let%expect_test "copy propagation eliminates redundant moves" =
  let fn =
    [%nod
      fun (input : int64) ->
        let tmp = mov input in
        let alias = mov tmp in
        return alias]
  in
  run_dsl
    ~opt_flags:
      (opt_flags ~unused_vars:true ~constant_propagation:true ~gvn:false)
    [ fn ];
  [%expect
    {|
    before
    (%entry (args (((name input) (type_ I64))))
     (instrs
      ((Move ((name tmp) (type_ I64)) (Var ((name input) (type_ I64))))
       (Move ((name alias) (type_ I64)) (Var ((name tmp) (type_ I64))))
       (Return (Var ((name alias) (type_ I64)))))))
    after
    (%entry (args (((name input) (type_ I64))))
     (instrs ((Return (Var ((name input) (type_ I64)))))))
    |}]
;;

let%expect_test "phi simplification removes redundant block args" =
  run
    {|
entry:
  mov %cond:i64, 0
  mov %value:i64, 5
  branch %cond, left, right

left:
  mov %res:i64, %value
  branch 1, join, join

right:
  mov %res:i64, %value
  branch 1, join, join

join:
  add %out:i64, %res, 1
  return %out
|};
  [%expect
    {|
    before
    (entry (args ())
     (instrs
      ((Move ((name cond) (type_ I64)) (Lit 0))
       (Move ((name value) (type_ I64)) (Lit 5))
       (Branch
        (Cond (cond (Var ((name cond) (type_ I64))))
         (if_true ((block ((id_hum left) (args ()))) (args ())))
         (if_false ((block ((id_hum right) (args ()))) (args ()))))))))
    (left (args ())
     (instrs
      ((Move ((name res%1) (type_ I64)) (Var ((name value) (type_ I64))))
       (Branch
        (Cond (cond (Lit 1))
         (if_true
          ((block ((id_hum join) (args (((name res) (type_ I64))))))
           (args (((name res%1) (type_ I64))))))
         (if_false
          ((block ((id_hum join) (args (((name res) (type_ I64))))))
           (args (((name res%1) (type_ I64)))))))))))
    (join (args (((name res) (type_ I64))))
     (instrs
      ((Add
        ((dest ((name out) (type_ I64))) (src1 (Var ((name res) (type_ I64))))
         (src2 (Lit 1))))
       (Return (Var ((name out) (type_ I64)))))))
    (right (args ())
     (instrs
      ((Move ((name res%0) (type_ I64)) (Var ((name value) (type_ I64))))
       (Branch
        (Cond (cond (Lit 1))
         (if_true
          ((block ((id_hum join) (args (((name res) (type_ I64))))))
           (args (((name res%0) (type_ I64))))))
         (if_false
          ((block ((id_hum join) (args (((name res) (type_ I64))))))
           (args (((name res%0) (type_ I64)))))))))))
    after
    (entry (args ())
     (instrs ((Branch (Uncond ((block ((id_hum right) (args ()))) (args ())))))))
    (right (args ())
     (instrs ((Branch (Uncond ((block ((id_hum join) (args ()))) (args ())))))))
    (join (args ()) (instrs ((Return (Lit 6)))))
    |}]
;;

let%expect_test "arithmetic simplification canonicalizes identities" =
  let fn =
    [%nod
      fun (input : int64) ->
        let mul_zero = mul input (lit 0L) in
        let same = sub mul_zero mul_zero in
        return same]
  in
  run_dsl
    ~opt_flags:
      (opt_flags ~unused_vars:true ~constant_propagation:true ~gvn:false)
    [ fn ];
  [%expect
    {|
    before
    (%entry (args (((name input) (type_ I64))))
     (instrs
      ((Mul
        ((dest ((name mul_zero) (type_ I64)))
         (src1 (Var ((name input) (type_ I64)))) (src2 (Lit 0))))
       (Sub
        ((dest ((name same) (type_ I64)))
         (src1 (Var ((name mul_zero) (type_ I64))))
         (src2 (Var ((name mul_zero) (type_ I64))))))
       (Return (Var ((name same) (type_ I64)))))))
    after
    (%entry (args ()) (instrs ((Return (Lit 0)))))
    |}]
;;

let%expect_test "constant branches simplify to jumps" =
  run_dsl'
    [%nod
      label entry;
      let x = mov (lit 1L) in
      branch_to (lit 1L) ~if_true:"left" ~if_false:"right";
      label right;
      seq [ Instr.ir Ir.unreachable ];
      label left;
      return x];
  [%expect
    {|
    before
    (entry (args ())
     (instrs
      ((Move ((name x) (type_ I64)) (Lit 1))
       (Branch
        (Cond (cond (Lit 1))
         (if_true ((block ((id_hum left) (args ()))) (args ())))
         (if_false ((block ((id_hum right) (args ()))) (args ()))))))))
    (left (args ()) (instrs ((Return (Var ((name x) (type_ I64)))))))
    (right (args ()) (instrs (Unreachable)))
    after
    (entry (args ())
     (instrs ((Branch (Uncond ((block ((id_hum left) (args ()))) (args ())))))))
    (left (args ()) (instrs ((Return (Lit 1)))))
    |}]
;;

let%expect_test "peephole identities simplify arithmetic chains" =
  let fn =
    [%nod
      fun (input : int64) ->
        let sum = add input (lit 0L) in
        let prod = mul sum (lit 1L) in
        return prod]
  in
  run_dsl
    ~opt_flags:
      (opt_flags ~unused_vars:true ~constant_propagation:true ~gvn:false)
    [ fn ];
  [%expect
    {|
    before
    (%entry (args (((name input) (type_ I64))))
     (instrs
      ((Add
        ((dest ((name sum) (type_ I64))) (src1 (Var ((name input) (type_ I64))))
         (src2 (Lit 0))))
       (Mul
        ((dest ((name prod) (type_ I64))) (src1 (Var ((name sum) (type_ I64))))
         (src2 (Lit 1))))
       (Return (Var ((name prod) (type_ I64)))))))
    after
    (%entry (args (((name input) (type_ I64))))
     (instrs ((Return (Var ((name input) (type_ I64)))))))
    |}]
;;

let%expect_test "bitwise and/or peepholes fold constants" =
  let fn =
    [%nod
      fun (input : int64) ->
        let _cleared = and_ input (lit 0L) in
        let masked = and_ input (lit (-1L)) in
        let merged = or_ masked (lit 0L) in
        let saturated = or_ merged (lit (-1L)) in
        return saturated]
  in
  run_dsl
    ~opt_flags:
      (opt_flags ~unused_vars:true ~constant_propagation:true ~gvn:false)
    [ fn ];
  [%expect
    {|
    before
    (%entry (args (((name input) (type_ I64))))
     (instrs
      ((And
        ((dest ((name _cleared) (type_ I64)))
         (src1 (Var ((name input) (type_ I64)))) (src2 (Lit 0))))
       (And
        ((dest ((name masked) (type_ I64)))
         (src1 (Var ((name input) (type_ I64)))) (src2 (Lit -1))))
       (Or
        ((dest ((name merged) (type_ I64)))
         (src1 (Var ((name masked) (type_ I64)))) (src2 (Lit 0))))
       (Or
        ((dest ((name saturated) (type_ I64)))
         (src1 (Var ((name merged) (type_ I64)))) (src2 (Lit -1))))
       (Return (Var ((name saturated) (type_ I64)))))))
    after
    (%entry (args ()) (instrs ((Return (Lit -1)))))
    |}]
;;

let%expect_test "mod and comparisons fold to constants" =
  let fn =
    [%nod
      fun (input : int64) ->
        let cmp = lt input input in
        let rem = mod_ input (lit 1L) in
        let total = add cmp rem in
        return total]
  in
  run_dsl
    ~opt_flags:
      (opt_flags ~unused_vars:true ~constant_propagation:true ~gvn:false)
    [ fn ];
  [%expect
    {|
    before
    (%entry (args (((name input) (type_ I64))))
     (instrs
      ((Lt
        ((dest ((name cmp) (type_ I64))) (src1 (Var ((name input) (type_ I64))))
         (src2 (Var ((name input) (type_ I64))))))
       (Mod
        ((dest ((name rem) (type_ I64))) (src1 (Var ((name input) (type_ I64))))
         (src2 (Lit 1))))
       (Add
        ((dest ((name total) (type_ I64))) (src1 (Var ((name cmp) (type_ I64))))
         (src2 (Var ((name rem) (type_ I64))))))
       (Return (Var ((name total) (type_ I64)))))))
    after
    (%entry (args ()) (instrs ((Return (Lit 0)))))
    |}]
;;

let%expect_test "peepholes simplify loads from globals" =
  run
    {|
global @g:i64 = 7

entry() {
entry:
  mov %ptr:ptr(i64), @g
  mov %alias:ptr(i64), %ptr
  load %value:i64, %alias
  return %value
}
|};
  [%expect
    {|
    before
    (entry (args ())
     (instrs
      ((Move ((name ptr) (type_ (Ptr_typed I64)))
        (Global ((name g) (type_ I64) (init (Int 7)))))
       (Move ((name alias) (type_ (Ptr_typed I64)))
        (Var ((name ptr) (type_ (Ptr_typed I64)))))
       (Load ((name value) (type_ I64))
        (Address
         ((base (Var ((name alias) (type_ (Ptr_typed I64))))) (offset 0))))
       (Return (Var ((name value) (type_ I64)))))))
    after
    (entry (args ())
     (instrs
      ((Load ((name value) (type_ I64))
        (Global ((name g) (type_ I64) (init (Int 7)))))
       (Return (Var ((name value) (type_ I64)))))))
    |}]
;;
