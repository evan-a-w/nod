open! Core
open! Import

module Dsl = struct
  module L = Ir.Lit_or_var

  let lit i = L.Lit i
  let var v = L.Var v
  let mov src ~dest = Ir.move dest src
  let add src1 src2 ~dest = Ir.add { dest; src1; src2 }
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
