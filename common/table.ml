open! Core

(** A simple ASCII table printer *)

type cell = string

type row = cell list

type t =
  { headers : row
  ; rows : row list
  }

let create ~headers rows = { headers; rows }

let max_widths { headers; rows } =
  let all_rows = headers :: rows in
  let num_cols = List.length headers in
  List.init num_cols ~f:(fun col_idx ->
    List.fold all_rows ~init:0 ~f:(fun max_width row ->
      match List.nth row col_idx with
      | None -> max_width
      | Some cell -> Int.max max_width (String.length cell)))
;;

let print_separator widths =
  let sep =
    List.map widths ~f:(fun width -> String.make (width + 2) '-')
    |> String.concat ~sep:"+"
  in
  print_endline ("+" ^ sep ^ "+")
;;

let print_row widths row =
  let cells =
    List.map2_exn widths row ~f:(fun width cell ->
      let padding = width - String.length cell in
      " " ^ cell ^ String.make (padding + 1) ' ')
  in
  print_endline ("|" ^ String.concat ~sep:"|" cells ^ "|")
;;

let print t =
  let widths = max_widths t in
  print_separator widths;
  print_row widths t.headers;
  print_separator widths;
  List.iter t.rows ~f:(print_row widths);
  print_separator widths
;;

let of_sexp_rows ~headers sexp_rows =
  let rows =
    List.map sexp_rows ~f:(fun row ->
      List.map row ~f:(fun sexp ->
        (* Convert sexp to string, but make it more compact *)
        Sexp.to_string_mach sexp))
  in
  create ~headers rows
;;

let print_sexp_rows ~headers sexp_rows =
  of_sexp_rows ~headers sexp_rows |> print
;;

(** Convert a sexp value to a readable string, with special handling for common patterns *)
let sexp_value_to_string sexp =
  match sexp with
  | Sexp.Atom s -> s
  | Sexp.List atoms when List.for_all atoms ~f:(function Sexp.Atom _ -> true | _ -> false) ->
    (* List of atoms - format as comma-separated list in braces *)
    let values = List.map atoms ~f:(function Sexp.Atom s -> s | _ -> "") in
    "{" ^ String.concat ~sep:"," values ^ "}"
  | _ ->
    (* Complex sexp - use machine format and strip quotes *)
    Sexp.to_string_mach sexp
    |> String.substr_replace_all ~pattern:"\"" ~with_:""
;;

(** Extract headers and rows from a list of record sexps.
    Each record should be a list of (field value) pairs.
    The headers are extracted from the first record's field names. *)
let of_sexp_records records =
  match records with
  | [] -> create ~headers:[] []
  | Sexp.List first_record :: rest_records ->
    (* Extract headers from first record *)
    let headers =
      List.filter_map first_record ~f:(function
        | Sexp.List [ Sexp.Atom field_name; _ ] -> Some field_name
        | _ -> None)
    in
    (* Extract all records (including first) *)
    let all_records = Sexp.List first_record :: rest_records in
    let rows =
      List.map all_records ~f:(function
        | Sexp.List fields ->
          List.filter_map fields ~f:(function
            | Sexp.List [ Sexp.Atom _field_name; value ] ->
              Some (sexp_value_to_string value)
            | _ -> None)
        | _ -> [])
    in
    create ~headers rows
  | _ -> create ~headers:[] []
;;

let print_sexp_records records = of_sexp_records records |> print
;;
