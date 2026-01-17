open! Core

type t =
  { id : Instr_id.t
  ; mutable ir : Ir.t
  ; mutable block : Block.t option
  ; mutable next : t option
  ; mutable prev : t option
  }
