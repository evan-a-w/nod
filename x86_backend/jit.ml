open! Core
open! Import

module Encoder = Jit_encode
module Runtime = Nod_backend_common.Jit_runtime

type t =
  { region : Runtime.region
  ; size : int
  ; symbols : nativeint String.Map.t
  }

module Module = struct
  type nonrec t = t

  let entry t name = Map.find t.symbols name
end

let patch_int64_le bytes ~offset value =
  let value = Int64.of_nativeint value in
  let byte shift =
    Int64.(to_int_exn (shift_right_logical value shift land 0xFFL))
  in
  Bytes.set bytes offset (Char.of_int_exn (byte 0));
  Bytes.set bytes (offset + 1) (Char.of_int_exn (byte 8));
  Bytes.set bytes (offset + 2) (Char.of_int_exn (byte 16));
  Bytes.set bytes (offset + 3) (Char.of_int_exn (byte 24));
  Bytes.set bytes (offset + 4) (Char.of_int_exn (byte 32));
  Bytes.set bytes (offset + 5) (Char.of_int_exn (byte 40));
  Bytes.set bytes (offset + 6) (Char.of_int_exn (byte 48));
  Bytes.set bytes (offset + 7) (Char.of_int_exn (byte 56))
;;

let resolve_symbol entry_offsets externals (symbol : X86_asm.symbol) =
  match Map.find entry_offsets symbol.name with
  | Some offset -> `Internal offset
  | None ->
    (match externals with
     | None ->
       failwithf "unresolved external symbol: %s" symbol.name ()
     | Some resolve ->
       (match resolve symbol.name with
        | Some addr -> `External addr
        | None ->
          failwithf "unresolved external symbol: %s" symbol.name ()))
;;

let compile_items ?externals (program : X86_asm.program) =
  let encoding = Encoder.encode program in
  let bytes = Bytes.copy encoding.bytes in
  let region = Runtime.alloc (Bytes.length bytes) in
  let base = Runtime.region_ptr region in
  let symbols =
    Map.map encoding.entry_offsets ~f:(fun offset ->
      Nativeint.(base + of_int offset))
  in
  List.iter encoding.fixups ~f:(fun fixup ->
    let address =
      match resolve_symbol encoding.entry_offsets externals fixup.symbol with
      | `Internal offset -> Nativeint.(base + of_int offset)
      | `External addr -> addr
    in
    patch_int64_le bytes ~offset:fixup.offset address);
  Runtime.copy_bytes region bytes;
  Runtime.make_exec region;
  { region; size = Bytes.length bytes; symbols }
;;

let compile ?dump_crap ?externals ?(system = `Linux) ~state functions =
  let items = X86_backend.compile_to_items ?dump_crap ~system ~state functions in
  compile_items ?externals items
;;

let entry = Module.entry

let call0_i64 fn_ptr = Runtime.call0_i64 fn_ptr
let call1_i64 fn_ptr arg0 = Runtime.call1_i64 fn_ptr arg0
let call2_i64 fn_ptr arg0 arg1 = Runtime.call2_i64 fn_ptr arg0 arg1
