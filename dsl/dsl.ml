open! Core
open! Nod_core

(* Common DSL helpers for writing Nod IR using the PPX

   This module provides helper functions that make writing Nod IR
   with the [%nod ...] PPX more ergonomic and readable.
*)

module L = Ir.Lit_or_var

(* Literals and variables *)
let lit i = L.Lit i
let var v = L.Var v
let global g = L.Global g

(* Arithmetic operations *)
let mov src ~dest = Ir.move dest src
let add src1 src2 ~dest = Ir.add { dest; src1; src2 }
let sub src1 src2 ~dest = Ir.sub { dest; src1; src2 }
let mul src1 src2 ~dest = Ir.mul { dest; src1; src2 }
let div src1 src2 ~dest = Ir.div { dest; src1; src2 }
let mod_ src1 src2 ~dest = Ir.mod_ { dest; src1; src2 }

(* Bitwise operations *)
let and_ src1 src2 ~dest = Ir.and_ { dest; src1; src2 }
let or_ src1 src2 ~dest = Ir.or_ { dest; src1; src2 }

(* Floating point operations *)
let fadd src1 src2 ~dest = Ir.fadd { dest; src1; src2 }
let fsub src1 src2 ~dest = Ir.fsub { dest; src1; src2 }
let fmul src1 src2 ~dest = Ir.fmul { dest; src1; src2 }
let fdiv src1 src2 ~dest = Ir.fdiv { dest; src1; src2 }

(* Memory operations *)
let load mem ~dest = Ir.load dest mem
let store src mem = Ir.store src mem

(* Memory operations with address offset *)
let load_addr base offset ~dest =
  Ir.load dest (Ir.Mem.address (var base) ~offset)
;;

let store_addr src base offset =
  Ir.store src (Ir.Mem.address (var base) ~offset)
;;

(* Alloca *)
let alloca size ~dest = Ir.alloca { dest; size }

(* Cast *)
let cast src ~dest = Ir.cast dest src

(* Call helpers for different arities that work with PPX *)
let call fn args ~results = Ir.call ~fn ~results ~args
let call0 fn args = Ir.call ~fn ~results:[] ~args
let call1 fn arg ~dest = Ir.call ~fn ~results:[ dest ] ~args:[ arg ]

let call2 fn arg1 arg2 ~dest =
  Ir.call ~fn ~results:[ dest ] ~args:[ arg1; arg2 ]
;;

let call3 fn arg1 arg2 arg3 ~dest =
  Ir.call ~fn ~results:[ dest ] ~args:[ arg1; arg2; arg3 ]
;;

let call4 fn arg1 arg2 arg3 arg4 ~dest =
  Ir.call ~fn ~results:[ dest ] ~args:[ arg1; arg2; arg3; arg4 ]
;;

let call5 fn arg1 arg2 arg3 arg4 arg5 ~dest =
  Ir.call ~fn ~results:[ dest ] ~args:[ arg1; arg2; arg3; arg4; arg5 ]
;;

(* Aggregate operations *)
let load_field base type_ indices ~dest =
  Ir.load_field { dest; base; type_; indices }
;;

let store_field base src type_ indices =
  Ir.store_field { base; src; type_; indices }
;;

let memcpy dest src type_ = Ir.memcpy { dest; src; type_ }

(* Atomic operations *)
let atomic_load addr order ~dest = Ir.atomic_load { dest; addr; order }
let atomic_store addr src order = Ir.atomic_store { addr; src; order }

let atomic_rmw addr src op order ~dest =
  Ir.atomic_rmw { dest; addr; src; op; order }
;;

let atomic_cmpxchg
  addr
  expected
  desired
  success_order
  failure_order
  ~dest
  ~success
  =
  Ir.atomic_cmpxchg
    { dest; success; addr; expected; desired; success_order; failure_order }
;;
