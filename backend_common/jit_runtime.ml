open! Core
open! Import

type region

external alloc : int -> region = "nod_jit_alloc"
external copy_bytes : region -> bytes -> unit = "nod_jit_copy"
external make_exec : region -> unit = "nod_jit_make_exec"
external region_ptr : region -> nativeint = "nod_jit_ptr"
external call0_i64 : nativeint -> int64 = "nod_jit_call0_i64"
external call1_i64 : nativeint -> int64 -> int64 = "nod_jit_call1_i64"
external call2_i64 : nativeint -> int64 -> int64 -> int64 = "nod_jit_call2_i64"
external add3_ptr : unit -> nativeint = "nod_jit_add3_ptr"

type t =
  { region : region
  ; size : int
  }

let create bytes =
  let size = Bytes.length bytes in
  let region = alloc size in
  copy_bytes region bytes;
  make_exec region;
  { region; size }
;;

let ptr t = region_ptr t.region
let size t = t.size
