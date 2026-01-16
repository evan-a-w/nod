open! Core
open! Import
open! Dsl

type binary_heap =
  { array : ptr
  ; capacity : int64
  ; len : int64
  }
[@@deriving nod_record]

module Compile (Arg : sig
    val elt_type : Type.t

    (** < 0 if less, 0 if equal, > 0 is greater *)
    val compare : (ptr -> ptr -> int64, int64) Fn.t
  end) =
struct
  include Arg

  let elt_bytes = Type.size_in_bytes elt_type |> Int64.of_int

  let array_offset =
    [%nod
      fun (t : ptr) (index : int64) ->
        let each_elt = mov (lit elt_bytes) in
        let offset = mul each_elt index in
        let array = load_record_field binary_heap.array t in
        let res = ptr_add array offset in
        return res]
  ;;

  let compare_indices =
    [%nod
      fun (t : ptr) (index1 : int64) (index2 : int64) ->
        let ptr1 = array_offset t index1 in
        let ptr2 = array_offset t index2 in
        let res = compare ptr1 ptr2 in
        return res]
  ;;
end
