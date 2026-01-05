open! Core
open! Import

type directive =
  | Align of int
  | Label of string
  | Bytes of int list
  | Zero of int

let int_bytes ~size value =
  List.init size ~f:(fun i ->
    let shift = i * 8 in
    Int64.shift_right_logical value shift
    |> Int64.bit_and 0xFFL
    |> Int64.to_int_exn)
;;

let float_bytes type_ value =
  match type_ with
  | Type.F32 ->
    let bits = Int32.bits_of_float value |> Int64.of_int32 in
    int_bytes ~size:4 bits
  | Type.F64 ->
    let bits = Int64.bits_of_float value in
    int_bytes ~size:8 bits
  | _ -> failwith "float_bytes called with non-float type"
;;

let bytes_of_scalar type_ init =
  let size = Type.size_in_bytes type_ in
  match init with
  | Global.Zero -> List.init size ~f:(Fn.const 0)
  | Global.Int value ->
    if Type.is_integer type_ || Type.is_ptr type_
    then int_bytes ~size value
    else failwith "integer initializer used for non-integer type"
  | Global.Float value ->
    if Type.is_float type_
    then float_bytes type_ value
    else failwith "float initializer used for non-float type"
  | Global.Aggregate _ ->
    failwith "aggregate initializer used for non-aggregate type"
;;

let bytes_of_init type_ init =
  let total_size = Type.size_in_bytes type_ in
  let bytes = Array.create ~len:total_size 0 in
  let rec fill ~offset type_ init =
    match type_, init with
    | Type.Tuple fields, Global.Aggregate values ->
      if List.length fields <> List.length values
      then failwith "aggregate initializer length mismatch"
      else
        List.fold2_exn fields values ~init:offset ~f:(fun offset field init ->
          let offset = Type.align_up offset (Type.align_of field) in
          fill ~offset field init;
          offset + Type.size_in_bytes field)
        |> ignore
    | Type.Tuple _fields, Global.Zero -> ()
    | Type.Tuple _fields, _ ->
      failwith "aggregate globals must use aggregate or zero initializer"
    | _ ->
      let data = bytes_of_scalar type_ init in
      List.iteri data ~f:(fun idx byte ->
        bytes.(offset + idx) <- byte)
  in
  fill ~offset:0 type_ init;
  Array.to_list bytes
;;

let directives_of_bytes bytes =
  let rec gather_nonzero acc rest =
    match rest with
    | [] -> List.rev acc, []
    | 0 :: _ -> List.rev acc, rest
    | b :: tl -> gather_nonzero (b :: acc) tl
  in
  let rec gather_zero count rest =
    match rest with
    | 0 :: tl -> gather_zero (count + 1) tl
    | _ -> count, rest
  in
  let rec loop acc = function
    | [] -> List.rev acc
    | 0 :: rest ->
      let count, rest = gather_zero 1 rest in
      loop (Zero count :: acc) rest
    | b :: rest ->
      let data, rest = gather_nonzero [ b ] rest in
      loop (Bytes data :: acc) rest
  in
  loop [] bytes
;;

let directives_of_global ~label_of (global : Global.t) =
  let label = label_of global.name in
  let alignment = Type.align_of global.type_ in
  let bytes = bytes_of_init global.type_ global.init in
  Align alignment :: Label label :: directives_of_bytes bytes
;;

let render_directive = function
  | Align n -> Printf.sprintf ".balign %d" n
  | Label name -> name ^ ":"
  | Bytes bytes ->
    let body =
      List.map bytes ~f:Int.to_string |> String.concat ~sep:", "
    in
    ".byte " ^ body
  | Zero count -> Printf.sprintf ".zero %d" count
;;

let data_section_lines ~label_of globals =
  match globals with
  | [] -> []
  | _ ->
    let directives =
      List.concat_map globals ~f:(directives_of_global ~label_of)
      |> List.map ~f:render_directive
    in
    ".data" :: directives
;;
