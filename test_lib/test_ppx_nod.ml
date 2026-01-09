open! Core
open! Import

module Dsl = struct
  module L = Ir.Lit_or_var

  let lit i = L.Lit i
  let var v = L.Var v
  let mov src ~dest = Ir.move dest src
  let add src1 src2 ~dest = Ir.add { dest; src1; src2 }
  let call1 fn arg ~dest = Ir.call ~fn ~results:[ dest ] ~args:[ arg ]

  let accumulate sum consts =
    List.map consts ~f:(fun lit_const ->
      Ir.add
        { dest = sum
        ; src1 = var sum
        ; src2 = lit lit_const
        })

  let bump v =
    [ Ir.add { dest = v; src1 = var v; src2 = lit 1L } ]
end

let%expect_test "block builder" =
  let block =
    [%nod
      let (tmp : i64) = Dsl.mov (Dsl.lit 1L) in
      return (Dsl.var tmp)
    ]
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

let%expect_test "function builder" =
  let mk =
    [%nod fun (a : i64) (b : i64) ->
      let (sum : i64) = Dsl.add (Dsl.var a) (Dsl.var b) in
      return (Dsl.var sum)
    ]
  in
  let fn = mk ~name:"add" in
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
      let (tmp : i64) = Dsl.mov (Dsl.lit 1L) in
      b loop
    ]
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
      let (sum : i64) = Dsl.mov (Dsl.lit 0L) in
      seq (Dsl.accumulate sum [ 4L; 5L; 6L ]);
      return (Dsl.var sum)
    ]
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
      let (a : i64) = Dsl.mov (Dsl.lit 10L) in
      seq (Dsl.bump a);
      let (b : i64) = Dsl.add (Dsl.var a) (Dsl.lit 5L) in
      return (Dsl.var b)
    ]
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
  let mk_double =
    [%nod fun (x : i64) ->
      let (twice : i64) = Dsl.add (Dsl.var x) (Dsl.var x) in
      return (Dsl.var twice)
    ]
  in
  let mk_offset delta =
    [%nod fun (x : i64) ->
      let (twice : i64) = Dsl.call1 "double" (Dsl.var x) in
      let (shifted : i64) = Dsl.add (Dsl.var twice) (Dsl.lit delta) in
      return (Dsl.var shifted)
    ]
  in
  let mk_entry start =
    [%nod fun (input : i64) ->
      let (seed : i64) = Dsl.add (Dsl.var input) (Dsl.lit start) in
      let (out : i64) = Dsl.call1 "offset" (Dsl.var seed) in
      return (Dsl.var out)
    ]
  in
  let funcs =
    [ mk_double ~name:"double"
    ; mk_offset 5L ~name:"offset"
    ; mk_entry 3L ~name:"entry"
    ]
  in
  List.iter funcs ~f:(fun fn ->
    Block.iter_and_update_bookkeeping (Function.root fn) ~f:(fun _ -> ());
    Function.print_verbose fn);
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
