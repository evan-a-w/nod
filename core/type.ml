open! Core
open Or_error.Let_syntax

type t =
  | I8
  | I16
  | I32
  | I64
  | F32
  | F64
  | Ptr
  | Tuple of t list
[@@deriving sexp, compare, equal, variants, hash]

let rec to_string = function
  | I8 -> "i8"
  | I16 -> "i16"
  | I32 -> "i32"
  | I64 -> "i64"
  | F32 -> "f32"
  | F64 -> "f64"
  | Ptr -> "ptr"
  | Tuple elements ->
    let inner = elements |> List.map ~f:to_string |> String.concat ~sep:", " in
    sprintf "(%s)" inner
;;

let of_string s =
  match String.uppercase s with
  | "I8" -> Some I8
  | "I16" -> Some I16
  | "I32" -> Some I32
  | "I64" -> Some I64
  | "F32" -> Some F32
  | "F64" -> Some F64
  | "PTR" -> Some Ptr
  | _ -> None
;;

let is_integer = function
  | I8 | I16 | I32 | I64 -> true
  | F32 | F64 | Ptr | Tuple _ -> false
;;

let is_float = function
  | F32 | F64 -> true
  | I8 | I16 | I32 | I64 | Ptr | Tuple _ -> false
;;

let is_numeric t = is_integer t || is_float t

let is_aggregate = function
  | Tuple _ -> true
  | I8 | I16 | I32 | I64 | F32 | F64 | Ptr -> false
;;

let rec align_of = function
  | I8 -> 1
  | I16 -> 2
  | I32 | F32 -> 4
  | I64 | F64 | Ptr -> 8
  | Tuple [] -> 1
  | Tuple fields ->
    List.fold fields ~init:1 ~f:(fun acc field -> Int.max acc (align_of field))
;;

let align_up value alignment =
  if alignment = 0 then value else ((value + alignment - 1) / alignment) * alignment
;;

let rec size_in_bytes = function
  | I8 -> 1
  | I16 -> 2
  | I32 | F32 -> 4
  | I64 | F64 | Ptr -> 8
  | Tuple fields ->
    let alignment = align_of (Tuple fields) in
    let size =
      List.fold fields ~init:0 ~f:(fun offset field ->
        let offset = align_up offset (align_of field) in
        offset + size_in_bytes field)
    in
    align_up size alignment
;;

let rec field_offset_in_tuple fields target_index ~offset =
  if target_index < 0
  then Or_error.errorf "field index %d out of bounds" target_index
  else (
    match fields, target_index with
    | [], _ -> Or_error.errorf "field index %d out of bounds" target_index
    | field :: _, 0 ->
      let offset = align_up offset (align_of field) in
      Ok (offset, field)
    | field :: rest, idx ->
      let offset = align_up offset (align_of field) + size_in_bytes field in
      field_offset_in_tuple rest (idx - 1) ~offset)
;;

let rec field_offset type_ indices =
  match indices, type_ with
  | [], _ -> Or_error.error_string "field path cannot be empty"
  | idx :: rest, Tuple fields ->
    let%bind offset, field = field_offset_in_tuple fields idx ~offset:0 in
    (match rest with
     | [] -> Ok (offset, field)
     | _ ->
       let%map inner_offset, inner_type = field_offset field rest in
       offset + inner_offset, inner_type)
  | _ :: _, _ ->
    Or_error.errorf
      "attempted to access field of non-aggregate type %s"
      (to_string type_)
;;

let rec fold_leaves type_ ~offset acc ~f =
  match type_ with
  | Tuple fields ->
    let _, acc =
      List.fold fields ~init:(offset, acc) ~f:(fun (curr_offset, acc) field ->
        let curr_offset = align_up curr_offset (align_of field) in
        let acc = fold_leaves field ~offset:curr_offset acc ~f in
        curr_offset + size_in_bytes field, acc)
    in
    acc
  | _ -> f ~offset acc type_
;;

let leaf_offsets type_ =
  fold_leaves type_ ~offset:0 [] ~f:(fun ~offset acc leaf -> (offset, leaf) :: acc)
  |> List.rev
;;

let pointer_mask_words type_ =
  let size_bytes = size_in_bytes type_ in
  let words = align_up size_bytes 8 / 8 in
  let mask_len = (words + 63) / 64 in
  let masks = Array.create ~len:mask_len 0L in
  List.iter (leaf_offsets type_) ~f:(fun (offset, leaf) ->
    if equal leaf Ptr
    then (
      let word = offset / 8 in
      let idx = word / 64 in
      let bit = word mod 64 in
      let value = Int64.shift_left 1L bit in
      masks.(idx) <- Stdlib.Int64.logor masks.(idx) value));
  if Array.for_all masks ~f:(fun value -> Int64.equal value 0L)
  then []
  else Array.to_list masks
;;
