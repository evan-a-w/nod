open! Core
open! Import

type 'block t =
  { id : Instr_id.t
  ; mutable ir : 'block Ir0.t
  ; mutable next : 'block t option
  ; mutable prev : 'block t option
  }
