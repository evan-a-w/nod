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
type nonrec point'_tuple_alias = (point_tuple_alias * Dsl.int64)
type nonrec point'_t =
  {
  repr: (point_tuple_alias * Dsl.int64) Dsl.Type_repr.t ;
  point: ((point_tuple_alias * Dsl.int64), point_tuple_alias) Dsl.Field.t ;
  x: ((point_tuple_alias * Dsl.int64), Dsl.int64) Dsl.Field.t }
let point' =
  {
    repr = (Dsl.Type_repr.Tuple2 (point.repr, Dsl.Type_repr.Int64));
    point = { repr = (point.repr) };
    x = { repr = Dsl.Type_repr.Int64 }
  }
let _ = point'
[@@@end]

let%expect_test "incl other" =
  print_s [%sexp (Dsl.Type_repr.type_ point'.point.repr : Type.t)];
  [%expect {| (Tuple (I64 F64 (Tuple (I64 F64)))) |}]
;;
