open! Core
open! Import
open! Test_nod_ppx

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
        let x = load_record_field point.x a in
        let y = load_record_field point'.point.x a in
        store_record_field point.x a x;
        store_record_field point'.point.x a y;
        return x]
  in
  let unnamed = Dsl.Fn.unnamed fn in
  let root = block_of_instrs (Dsl.Fn.Unnamed.instrs unnamed) in
  print_s (Block.to_sexp_verbose root);
  [%expect
    {|
    ((%entry (args ())
      (instrs
       (((id (Instr_id 1))
         (ir
          (Load_field
           ((dest ((name x) (type_ I64))) (base (Var ((name a) (type_ Ptr))))
            (type_ (Tuple (I64 F64 (Tuple (I64 F64))))) (indices (0))))))
        ((id (Instr_id 2))
         (ir
          (Load_field
           ((dest ((name y) (type_ I64))) (base (Var ((name a) (type_ Ptr))))
            (type_ (Tuple ((Tuple (I64 F64 (Tuple (I64 F64)))) I64)))
            (indices (0 0))))))
        ((id (Instr_id 3))
         (ir
          (Store_field
           ((base (Var ((name a) (type_ Ptr))))
            (src (Var ((name x) (type_ I64))))
            (type_ (Tuple (I64 F64 (Tuple (I64 F64))))) (indices (0))))))
        ((id (Instr_id 4))
         (ir
          (Store_field
           ((base (Var ((name a) (type_ Ptr))))
            (src (Var ((name y) (type_ I64))))
            (type_ (Tuple ((Tuple (I64 F64 (Tuple (I64 F64)))) I64)))
            (indices (0 0))))))
        ((id (Instr_id 5)) (ir (Return (Var ((name x) (type_ I64))))))))))
    |}]
;;
