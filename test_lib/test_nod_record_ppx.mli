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

[@@@end]
