open! Core
open! Import
open! Dsl

let malloc : (int64 -> ptr, int64) Fn.t =
  Fn.external_ ~name:"malloc" ~args:[ Type.I64 ] ~ret:Type.Ptr
;;
