open! Core
open Pror_rs

type t = bitset

let create () = bitset_create ()
let grow t ~bits = bitset_grow t bits
let capacity t = bitset_capacity t
let clear_all t = bitset_clear_all t
let set t ~bit = bitset_set t bit
let set_between t ~start ~stop = bitset_set_between t start stop
let clear t ~bit = bitset_clear t bit
let mem t bit = bitset_contains t bit
let add = mem
let first_set t = bitset_first_set t
let first_unset t = bitset_first_unset t
let first_set_ge t ~ge = bitset_first_set_ge t ge
let first_unset_ge t ~ge = bitset_first_unset_ge t ge
let union_into ~dst ~src = bitset_union_with dst src
let intersect_into ~dst ~lhs ~rhs = bitset_intersect dst lhs rhs
let intersect_with ~dst ~src = bitset_intersect_with dst src
let difference_into ~dst ~src = bitset_difference_with dst src
let pop_first_set t = bitset_pop_first_set t
let nth t n = bitset_nth t n
let count t = bitset_count t
let to_array t = bitset_iter t
let to_list t = bitset_iter t |> Array.to_list

let of_array arr =
  let t = create () in
  Array.iter arr ~f:(fun bit -> set t ~bit);
  t
;;

let of_list lst =
  let t = create () in
  List.iter lst ~f:(fun bit -> set t ~bit);
  t
;;

let elements t = to_array t
let union_elements ~lhs ~rhs = bitset_iter_union lhs rhs
let intersection_elements ~lhs ~rhs = bitset_iter_intersection lhs rhs
let difference_elements ~lhs ~rhs = bitset_iter_difference lhs rhs
let intersect_first_set ~lhs ~rhs = bitset_intersect_first_set lhs rhs

let intersect_first_set_ge ~lhs ~rhs ~ge =
  bitset_intersect_first_set_ge lhs rhs ge
;;

let is_empty t = bitset_is_empty t
let to_sequence t = elements t |> Array.to_list |> Sequence.of_list

let union_sequence ~lhs ~rhs =
  union_elements ~lhs ~rhs |> Array.to_list |> Sequence.of_list
;;

let intersection_sequence ~lhs ~rhs =
  intersection_elements ~lhs ~rhs |> Array.to_list |> Sequence.of_list
;;

let difference_sequence ~lhs ~rhs =
  difference_elements ~lhs ~rhs |> Array.to_list |> Sequence.of_list
;;

let compare lhs rhs = Array.compare Int.compare (to_array lhs) (to_array rhs)
let sexp_of_t t = [%sexp_of: int array] (to_array t)
let t_of_sexp sexp = sexp |> [%of_sexp: int array] |> of_array
let equal a b = compare a b = 0
