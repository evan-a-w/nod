open! Core
open! Import

(* Extend the common DSL with test-specific helpers *)
module Dsl = struct
  include Nod_dsl.Dsl

  let accumulate sum consts =
    List.map consts ~f:(fun lit_const ->
      Instr.add ~dest:sum sum (lit lit_const))
  ;;

  let bump v = [ Instr.add ~dest:v v (lit 1L) ]
end

let%expect_test "block builder" =
  let block =
    [%nod
      let%named tmp = mov (lit 1L) in
      return tmp]
  in
  Block.iter_and_update_bookkeeping block ~f:(fun _ -> ());
  print_s (Block.to_sexp_verbose block);
  [%expect
    {|
    ((%entry (args ())
      (instrs
       ((Move ((name tmp) (type_ I64)) (Lit 1))
        (Return (Var ((name tmp) (type_ I64))))))))
    |}]
;;

let%expect_test "no_nod escape and implicit dsl" =
  let called = ref false in
  let mark_called () = called := true in
  let block =
    [%nod
      [%no_nod mark_called ()];
      let%named tmp = mov (lit 1L) in
      return tmp]
  in
  print_s [%sexp (!called : bool)];
  Block.iter_and_update_bookkeeping block ~f:(fun _ -> ());
  print_s (Block.to_sexp_verbose block);
  [%expect
    {|
    true
    ((%entry (args ())
      (instrs
       ((Move ((name tmp) (type_ I64)) (Lit 1))
        (Return (Var ((name tmp) (type_ I64))))))))
    |}]
;;

let%expect_test "function builder" =
  let fn =
    [%nod
      fun "add" (a : int64) (b : int64) ->
        let%named sum = add a b in
        return sum]
  in
  let fn = Dsl.Fn.function_exn fn in
  Block.iter_and_update_bookkeeping (Function.root fn) ~f:(fun _ -> ());
  Function.print_verbose fn;
  [%expect
    {|
    ((call_conv Default)
     (root
      ((%entry (args (((name a) (type_ I64)) ((name b) (type_ I64))))
        (instrs
         ((Add
           ((dest ((name sum) (type_ I64))) (src1 (Var ((name a) (type_ I64))))
            (src2 (Var ((name b) (type_ I64))))))
          (Return (Var ((name sum) (type_ I64)))))))))
     (args (((name a) (type_ I64)) ((name b) (type_ I64)))) (name add)
     (prologue ()) (epilogue ()) (bytes_for_clobber_saves 0)
     (bytes_for_padding 0) (bytes_for_spills 0) (bytes_statically_alloca'd 0))
    |}]
;;

let%expect_test "loop label" =
  let block =
    [%nod
      label loop;
      let%named tmp = mov (lit 1L) in
      b loop]
  in
  Block.iter_and_update_bookkeeping block ~f:(fun _ -> ());
  print_s (Block.to_sexp_verbose block);
  [%expect
    {|
    ((%entry (args ())
      (instrs ((Branch (Uncond ((block ((id_hum loop) (args ()))) (args ()))))))))
    |}]
;;

let%expect_test "embedded sequences" =
  let block =
    [%nod
      let%named sum = mov (lit 0L) in
      seq (Dsl.accumulate sum [ 4L; 5L; 6L ]);
      return sum]
  in
  Block.iter_and_update_bookkeeping block ~f:(fun _ -> ());
  print_s (Block.to_sexp_verbose block);
  [%expect
    {|
    ((%entry (args ())
      (instrs
       ((Move ((name sum) (type_ I64)) (Lit 0))
        (Add
         ((dest ((name sum) (type_ I64))) (src1 (Var ((name sum) (type_ I64))))
          (src2 (Lit 4))))
        (Add
         ((dest ((name sum) (type_ I64))) (src1 (Var ((name sum) (type_ I64))))
          (src2 (Lit 5))))
        (Add
         ((dest ((name sum) (type_ I64))) (src1 (Var ((name sum) (type_ I64))))
          (src2 (Lit 6))))
        (Return (Var ((name sum) (type_ I64))))))))
    |}]
;;

let%expect_test "sequence depends on prior bindings" =
  let block =
    [%nod
      let%named a = mov (lit 10L) in
      seq (Dsl.bump a);
      let%named b = add a (lit 5L) in
      return b]
  in
  Block.iter_and_update_bookkeeping block ~f:(fun _ -> ());
  print_s (Block.to_sexp_verbose block);
  [%expect
    {|
    ((%entry (args ())
      (instrs
       ((Move ((name a) (type_ I64)) (Lit 10))
        (Add
         ((dest ((name a) (type_ I64))) (src1 (Var ((name a) (type_ I64))))
          (src2 (Lit 1))))
        (Add
         ((dest ((name b) (type_ I64))) (src1 (Var ((name a) (type_ I64))))
          (src2 (Lit 5))))
        (Return (Var ((name b) (type_ I64))))))))
    |}]
;;

let%expect_test "compose nod functions" =
  let double =
    [%nod
      fun "double" (x : int64) ->
        let%named twice = add x x in
        return twice]
  in
  let mk_offset delta =
    [%nod
      fun "offset" (x : int64) ->
        let%named twice = call double x in
        let%named shifted = add twice (lit delta) in
        return shifted]
  in
  let mk_entry start offset =
    [%nod
      fun "entry" (input : int64) ->
        let%named seed = add input (lit start) in
        let%named out = call offset seed in
        return out]
  in
  let offset = mk_offset 5L in
  let entry = mk_entry 3L offset in
  let funcs =
    [ double; offset; entry ]
  in
  List.iter funcs ~f:(fun fn ->
    let func = Dsl.Fn.function_exn fn in
    Block.iter_and_update_bookkeeping (Function.root func) ~f:(fun _ -> ());
    Function.print_verbose func);
  [%expect
    {|
    ((call_conv Default)
     (root
      ((%entry (args (((name x) (type_ I64))))
        (instrs
         ((Add
           ((dest ((name twice) (type_ I64))) (src1 (Var ((name x) (type_ I64))))
            (src2 (Var ((name x) (type_ I64))))))
          (Return (Var ((name twice) (type_ I64)))))))))
     (args (((name x) (type_ I64)))) (name double) (prologue ()) (epilogue ())
     (bytes_for_clobber_saves 0) (bytes_for_padding 0) (bytes_for_spills 0)
     (bytes_statically_alloca'd 0))
    ((call_conv Default)
     (root
      ((%entry (args (((name x) (type_ I64))))
        (instrs
         ((Call (fn double) (results (((name twice) (type_ I64))))
           (args ((Var ((name x) (type_ I64))))))
          (Add
           ((dest ((name shifted) (type_ I64)))
            (src1 (Var ((name twice) (type_ I64)))) (src2 (Lit 5))))
          (Return (Var ((name shifted) (type_ I64)))))))))
     (args (((name x) (type_ I64)))) (name offset) (prologue ()) (epilogue ())
     (bytes_for_clobber_saves 0) (bytes_for_padding 0) (bytes_for_spills 0)
     (bytes_statically_alloca'd 0))
    ((call_conv Default)
     (root
      ((%entry (args (((name input) (type_ I64))))
        (instrs
         ((Add
           ((dest ((name seed) (type_ I64)))
            (src1 (Var ((name input) (type_ I64)))) (src2 (Lit 3))))
          (Call (fn offset) (results (((name out) (type_ I64))))
           (args ((Var ((name seed) (type_ I64))))))
          (Return (Var ((name out) (type_ I64)))))))))
     (args (((name input) (type_ I64)))) (name entry) (prologue ()) (epilogue ())
     (bytes_for_clobber_saves 0) (bytes_for_padding 0) (bytes_for_spills 0)
     (bytes_statically_alloca'd 0))
    |}]
;;
