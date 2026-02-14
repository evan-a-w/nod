open! Core
open! Import
open! Dsl

let malloc : (int64 -> int64 ptr, int64 ptr) Fn.t =
  Fn.external_ ~name:"malloc" ~args:[ Type.I64 ] ~ret:(Type.Ptr_typed Type.I64)
;;
