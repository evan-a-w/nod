open! Core
open! Import

type point =
  { x : int64
  ; y : float64 (* ; z : int64 * float64 *)
  }
[@@deriving nod_record]

let%expect_test "nod_record generates type and value" =
  print_s [%sexp (Dsl.Type_repr.type_ point.repr : Type.t)];
  [%expect {| (Tuple (I64 I64)) |}];
  print_s [%sexp (Dsl.Type_repr.type_ point.x.repr : Type.t)];
  [%expect {| I64 |}];
  print_s [%sexp (Dsl.Type_repr.type_ point.y.repr : Type.t)];
  [%expect {| I64 |}]
;;
(* print_s [%sexp (Dsl.Type_repr.type_ point.z.repr : Type.t)]; *)
(* [%expect {| I64 |}] *)

(* type point' = { point : point } *)
(* let%expect_test "incl other" = *)
(*   print_s [%sexp (Dsl.Type_repr.type_ point'.point.repr : Type.t)]; *)
(*   [%expect {| I64 |}] *)
(* ;; *)
