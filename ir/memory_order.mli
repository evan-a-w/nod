open! Core
open! Import

type t =
  | Relaxed
  | Acquire
  | Release
  | Acq_rel
  | Seq_cst
[@@deriving sexp, compare, equal, hash]

val x86_needs_fence : t -> bool
val x86_load_needs_fence : t -> bool
val x86_store_needs_fence : t -> bool
