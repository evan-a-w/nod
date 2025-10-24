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

let elements t = bitset_iter t

let union_elements ~lhs ~rhs = bitset_iter_union lhs rhs

let intersection_elements ~lhs ~rhs = bitset_iter_intersection lhs rhs

let difference_elements ~lhs ~rhs = bitset_iter_difference lhs rhs

let intersect_first_set ~lhs ~rhs = bitset_intersect_first_set lhs rhs

let intersect_first_set_ge ~lhs ~rhs ~ge = bitset_intersect_first_set_ge lhs rhs ge

let is_empty t = bitset_is_empty t

let to_seq t = Array.to_seq (elements t)

let union_seq ~lhs ~rhs = Array.to_seq (union_elements ~lhs ~rhs)

let intersection_seq ~lhs ~rhs =
  Array.to_seq (intersection_elements ~lhs ~rhs)

let difference_seq ~lhs ~rhs = Array.to_seq (difference_elements ~lhs ~rhs)
