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

  (* note: can use [%nod
     let v = Libc.malloc size in]
     defined as an external function in libc.ml
  *)

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

  let copy_elt =
    [%nod
      fun (src : ptr) (dst : ptr) ->
        let bytes_to_copy = mov (lit elt_bytes) in
        let i_slot = alloca (lit 8L) in
        store (lit 0L) i_slot;
        label copy_loop;
        let i = load i_slot in
        let remaining = sub bytes_to_copy i in
        branch_to remaining ~if_true:"copy_body" ~if_false:"copy_done";
        label copy_body;
        let src_ptr = ptr_add src i in
        let dst_ptr = ptr_add dst i in
        let byte = load src_ptr in
        store byte dst_ptr;
        let next_i = add i (lit 8L) in
        store next_i i_slot;
        jump_to "copy_loop";
        label copy_done;
        return (lit 0L)]
  ;;

  let swap =
    [%nod
      fun (t : ptr) (index1 : int64) (index2 : int64) ->
        let ptr1 = array_offset t index1 in
        let ptr2 = array_offset t index2 in
        let tmp = alloca (lit elt_bytes) in
        let _ = copy_elt ptr1 tmp in
        let _ = copy_elt ptr2 ptr1 in
        let _ = copy_elt tmp ptr2 in
        return (lit 0L)]
  ;;

  let parent_index =
    [%nod
      fun (i : int64) ->
        let one = mov (lit 1L) in
        let i_minus_1 = sub i one in
        let parent = div i_minus_1 (lit 2L) in
        return parent]
  ;;

  let left_child_index =
    [%nod
      fun (i : int64) ->
        let two_i = mul i (lit 2L) in
        let left = add two_i (lit 1L) in
        return left]
  ;;

  let right_child_index =
    [%nod
      fun (i : int64) ->
        let two_i = mul i (lit 2L) in
        let right = add two_i (lit 2L) in
        return right]
  ;;

  let sift_up =
    [%nod
      fun (t : ptr) (index : int64) ->
        let i_slot = alloca (lit 8L) in
        store index i_slot;
        label sift_up_loop;
        let i = load i_slot in
        (* if i == 0, we're at root, done *)
        branch_to i ~if_true:"sift_up_check_parent" ~if_false:"sift_up_done";
        label sift_up_check_parent;
        let parent = parent_index i in
        let cmp = compare_indices t i parent in
        (* if cmp < 0, element is smaller than parent, swap *)
        let is_less = lt cmp (lit 0L) in
        branch_to is_less ~if_true:"sift_up_swap" ~if_false:"sift_up_done";
        label sift_up_swap;
        let _ = swap t i parent in
        store parent i_slot;
        jump_to "sift_up_loop";
        label sift_up_done;
        return (lit 0L)]
  ;;

  let sift_down =
    [%nod
      fun (t : ptr) (index : int64) ->
        let len = load_record_field binary_heap.len t in
        let i_slot = alloca (lit 8L) in
        store index i_slot;
        label sift_down_loop;
        let i = load i_slot in
        let left = left_child_index i in
        (* if left >= len, no children, done *)
        let left_in_bounds = sub len left in
        (* left_in_bounds > 0 iff left < len *)
        branch_to
          left_in_bounds
          ~if_true:"sift_down_has_left"
          ~if_false:"sift_down_done";
        label sift_down_has_left;
        let right = right_child_index i in
        let right_in_bounds = sub len right in
        (* right_in_bounds > 0 iff right < len *)
        let smallest_slot = alloca (lit 8L) in
        store left smallest_slot;
        branch_to
          right_in_bounds
          ~if_true:"sift_down_check_right"
          ~if_false:"sift_down_compare_with_parent";
        label sift_down_check_right;
        (* compare right with current smallest (left) *)
        let smallest = load smallest_slot in
        let cmp_right_left = compare_indices t right smallest in
        let right_is_smaller = lt cmp_right_left (lit 0L) in
        branch_to
          right_is_smaller
          ~if_true:"sift_down_right_smaller"
          ~if_false:"sift_down_compare_with_parent";
        label sift_down_right_smaller;
        store right smallest_slot;
        jump_to "sift_down_compare_with_parent";
        label sift_down_compare_with_parent;
        let smallest_final = load smallest_slot in
        let cmp_smallest_i = compare_indices t smallest_final i in
        let smallest_is_less = lt cmp_smallest_i (lit 0L) in
        branch_to
          smallest_is_less
          ~if_true:"sift_down_swap"
          ~if_false:"sift_down_done";
        label sift_down_swap;
        let _ = swap t i smallest_final in
        store smallest_final i_slot;
        jump_to "sift_down_loop";
        label sift_down_done;
        return (lit 0L)]
  ;;

  let create =
    [%nod
      fun (initial_capacity : int64) ->
        let heap_size = mov (lit 24L) in
        (* 3 fields * 8 bytes each *)
        let heap_ptr = Libc.malloc heap_size in
        let array_size = mul initial_capacity (lit elt_bytes) in
        let array_ptr = Libc.malloc array_size in
        store_record_field binary_heap.array heap_ptr array_ptr;
        store_record_field binary_heap.capacity heap_ptr initial_capacity;
        store_record_field binary_heap.len heap_ptr (lit 0L);
        return heap_ptr]
  ;;

  let len =
    [%nod
      fun (t : ptr) ->
        let len = load_record_field binary_heap.len t in
        return len]
  ;;

  let peek =
    [%nod
      fun (t : ptr) ->
        let ptr = array_offset t (lit 0L) in
        return ptr]
  ;;

  let push =
    [%nod
      fun (t : ptr) (elt : ptr) ->
        let current_len = load_record_field binary_heap.len t in
        (* TODO: check capacity and grow if needed *)
        let insert_ptr = array_offset t current_len in
        let _ = copy_elt elt insert_ptr in
        let new_len = add current_len (lit 1L) in
        store_record_field binary_heap.len t new_len;
        let _ = sift_up t current_len in
        return (lit 0L)]
  ;;

  let pop =
    [%nod
      fun (t : ptr) (out : ptr) ->
        let current_len = load_record_field binary_heap.len t in
        (* if len == 0, return error or undefined *)
        branch_to current_len ~if_true:"pop_has_elements" ~if_false:"pop_empty";
        label pop_has_elements;
        let root_ptr = array_offset t (lit 0L) in
        let _ = copy_elt root_ptr out in
        let new_len = sub current_len (lit 1L) in
        store_record_field binary_heap.len t new_len;
        (* if new_len == 0, nothing to sift *)
        branch_to new_len ~if_true:"pop_sift" ~if_false:"pop_done";
        label pop_sift;
        let last_ptr = array_offset t new_len in
        let _ = copy_elt last_ptr root_ptr in
        let _ = sift_down t (lit 0L) in
        jump_to "pop_done";
        label pop_empty;
        jump_to "pop_done";
        label pop_done;
        return (lit 0L)]
  ;;

  let functions =
    [ Dsl.Fn.pack (Dsl.Fn.renamed ~name:"heap_array_offset" array_offset)
    ; Dsl.Fn.pack (Dsl.Fn.renamed ~name:"heap_compare_indices" compare_indices)
    ; Dsl.Fn.pack (Dsl.Fn.renamed ~name:"heap_copy_elt" copy_elt)
    ; Dsl.Fn.pack (Dsl.Fn.renamed ~name:"heap_swap" swap)
    ; Dsl.Fn.pack (Dsl.Fn.renamed ~name:"heap_parent_index" parent_index)
    ; Dsl.Fn.pack
        (Dsl.Fn.renamed ~name:"heap_left_child_index" left_child_index)
    ; Dsl.Fn.pack
        (Dsl.Fn.renamed ~name:"heap_right_child_index" right_child_index)
    ; Dsl.Fn.pack (Dsl.Fn.renamed ~name:"heap_sift_up" sift_up)
    ; Dsl.Fn.pack (Dsl.Fn.renamed ~name:"heap_sift_down" sift_down)
    ; Dsl.Fn.pack (Dsl.Fn.renamed ~name:"heap_create" create)
    ; Dsl.Fn.pack (Dsl.Fn.renamed ~name:"heap_len" len)
    ; Dsl.Fn.pack (Dsl.Fn.renamed ~name:"heap_peek" peek)
    ; Dsl.Fn.pack (Dsl.Fn.renamed ~name:"heap_push" push)
    ; Dsl.Fn.pack (Dsl.Fn.renamed ~name:"heap_pop" pop)
    ]
  ;;
end
