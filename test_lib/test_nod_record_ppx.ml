open! Core
open! Import

type point =
  { x : Dsl.int64
  ; y : Dsl.float64
  ; z : Dsl.int64 * Dsl.float64
  }
[@@deriving nod_record]

let%expect_test "nod_record generates type and value" =
  print_s [%sexp (Dsl.Type_repr.type_ point.repr : Type.t)];
  [%expect {| (Tuple (I64 F64 (Tuple (I64 F64)))) |}];
  print_s [%sexp (Dsl.Type_repr.type_ point.x.repr : Type.t)];
  [%expect {| I64 |}];
  print_s [%sexp (Dsl.Type_repr.type_ point.y.repr : Type.t)];
  [%expect {| F64 |}];
  print_s [%sexp (Dsl.Type_repr.type_ point.z.repr : Type.t)];
  [%expect {| (Tuple (I64 F64)) |}]
;;

type point' =
  { point : point
  ; x : int64
  }
[@@deriving_inline nod_record]

let _ = fun (_ : point') -> ()

type nonrec point'_tuple_alias = point_tuple_alias * Dsl.int64

type nonrec point'_t =
  { repr : (point_tuple_alias * Dsl.int64) Dsl.Type_repr.t
  ; point :
      ( point_tuple_alias * Dsl.int64
        , point_tuple_alias
        , point_t
        , Dsl.record )
        Dsl.Field.t
  ; x : (point_tuple_alias * Dsl.int64, Dsl.int64, unit, Dsl.base) Dsl.Field.t
  }

let point' =
  { repr = Dsl.Type_repr.Tuple2 (point.repr, Dsl.Type_repr.Int64)
  ; point =
      { record_repr = Dsl.Type_repr.Tuple2 (point.repr, Dsl.Type_repr.Int64)
      ; repr = point.repr
      ; name = "point"
      ; index = 0
      ; type_info = point
      }
  ; x =
      { record_repr = Dsl.Type_repr.Tuple2 (point.repr, Dsl.Type_repr.Int64)
      ; repr = Dsl.Type_repr.Int64
      ; name = "x"
      ; index = 1
      ; type_info = ()
      }
  }
;;

let _ = point'

[@@@end]

let%expect_test "incl other" =
  assert (phys_equal () point'.x.type_info);
  assert (phys_equal point'.point.type_info point);
  print_s [%sexp (Dsl.Type_repr.type_ point'.point.repr : Type.t)];
  [%expect {| (Tuple (I64 F64 (Tuple (I64 F64)))) |}]
;;

let%expect_test "nod load and store field" =
  let fn =
    [%nod
      fun (a : ptr) ->
        let%named x = load_record_field point.x a in
        let%named y = load_record_field point'.point.x in
        return x]
  in
  let unnamed = Dsl.Fn.unnamed fn in
  print_s [%sexp (Dsl.Fn.Unnamed.args unnamed : Var.t list)];
  print_s [%sexp (Dsl.Fn.Unnamed.ret unnamed : Type.t)];
  let root = block_of_instrs (Dsl.Fn.Unnamed.instrs unnamed) in
  print_s (Block.to_sexp_verbose root);
  [%expect
    {|
    (((name a) (type_ I64)) ((name b) (type_ I64)))
    I64
    ((%entry (args ())
      (instrs
       ((Add
         ((dest ((name sum) (type_ I64))) (src1 (Var ((name a) (type_ I64))))
          (src2 (Var ((name b) (type_ I64))))))
        (Return (Var ((name sum) (type_ I64))))))))
    |}]
;;
