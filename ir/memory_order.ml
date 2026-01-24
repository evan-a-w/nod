open! Core
open! Import

type t =
  | Relaxed
  | Acquire
  | Release
  | Acq_rel
  | Seq_cst
[@@deriving sexp, compare, equal, hash]

(* For x86_64 TSO: many orderings collapse to simpler operations *)
let x86_needs_fence = function
  | Relaxed | Acquire -> false
  | Release | Acq_rel | Seq_cst -> true
;;

(* Check if a load ordering requires special handling on x86 *)
let x86_load_needs_fence = function
  | Relaxed | Acquire -> false
  | Release | Acq_rel | Seq_cst -> true
;;

(* Check if a store ordering requires special handling on x86 *)
let x86_store_needs_fence = function
  | Relaxed -> false
  | Acquire | Release | Acq_rel | Seq_cst -> true
;;
