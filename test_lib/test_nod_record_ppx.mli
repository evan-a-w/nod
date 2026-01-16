open! Core
open! Import

type point =
  { x : Dsl.int64
  ; y : Dsl.float64
  ; z : Dsl.int64 * Dsl.float64
  }
[@@deriving nod_record]

type point' =
  { point : point
  ; x : int64
  }
[@@deriving_inline nod_record]

include sig
  [@@@ocaml.warning "-32"]

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

  val point' : point'_t
end
[@@ocaml.doc "@inline"]

[@@@end]
