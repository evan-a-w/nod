open! Core
open! Import
open! Dsl

let malloc : (int64 -> ptr, ptr) Fn.t =
  Fn.external_ ~name:"malloc" ~args:[ Type.I64 ] ~ret:Type.Ptr
;;
