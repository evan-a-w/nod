open! Core
module B = Bitset

let int_list t = B.to_array t |> Array.to_list

let%test_unit "of_array normalizes duplicates" =
  let bits = B.of_array [| 3; 1; 3; 0 |] in
  [%test_result: int list] (int_list bits) ~expect:[ 0; 1; 3 ]
;;

let%test_unit "sexp roundtrip" =
  let bits = B.of_list [ 5; 2; 9 ] in
  let round_tripped = B.sexp_of_t bits |> B.t_of_sexp in
  [%test_result: int list] (int_list round_tripped) ~expect:(int_list bits)
;;

let%test_unit "compare establishes ordering" =
  let empty = B.create () in
  let a = B.of_list [ 1; 2 ] in
  let b = B.of_list [ 1; 3 ] in
  [%test_result: bool] (B.compare empty a < 0) ~expect:true;
  [%test_result: bool] (B.compare b a > 0) ~expect:true;
  [%test_result: int] (B.compare a (B.of_list [ 2; 1 ])) ~expect:0
;;

let%test_unit "of_list populates bits" =
  let bits = B.of_list [ 3; 0; 2 ] in
  [%test_result: int list] (int_list bits) ~expect:[ 0; 2; 3 ]
;;

let%test_unit "set and mem mutate the bitset" =
  let bits = B.create () in
  [%test_result: bool] (B.is_empty bits) ~expect:true;
  B.set bits ~bit:4;
  B.set bits ~bit:1;
  [%test_result: int list] (int_list bits) ~expect:[ 1; 4 ];
  [%test_result: bool] (B.mem bits 4) ~expect:true;
  [%test_result: bool] (B.mem bits 3) ~expect:false;
  [%test_result: bool] (B.is_empty bits) ~expect:false
;;

let%test_unit "set_between fills inclusive range" =
  let bits = B.create () in
  B.set_between bits ~start:2 ~stop:5;
  [%test_result: int list] (int_list bits) ~expect:[ 2; 3; 4 ]
;;

let%test_unit "union_into merges both sets" =
  let dst = B.of_list [ 1; 4 ] in
  let src = B.of_list [ 0; 4; 5 ] in
  B.union_into ~dst ~src;
  [%test_result: int list] (int_list dst) ~expect:[ 0; 1; 4; 5 ]
;;

let%test_unit "intersect_into writes intersection" =
  let dst = B.create () in
  let lhs = B.of_list [ 1; 4; 7 ] in
  let rhs = B.of_list [ 4; 5; 7 ] in
  B.intersect_into ~dst ~lhs ~rhs;
  [%test_result: int list] (int_list dst) ~expect:[ 4; 7 ]
;;

let%test_unit "difference_into removes src bits" =
  let dst = B.of_list [ 1; 2; 3 ] in
  let src = B.of_list [ 2; 4 ] in
  B.difference_into ~dst ~src;
  [%test_result: int list] (int_list dst) ~expect:[ 1; 3 ]
;;

let%test_unit "sequence views mirror set operations" =
  let lhs = B.of_list [ 1; 3; 5 ] in
  let rhs = B.of_list [ 3; 4; 6 ] in
  [%test_result: int list]
    (B.union_sequence ~lhs ~rhs |> Sequence.to_list)
    ~expect:[ 1; 3; 4; 5; 6 ];
  [%test_result: int list]
    (B.intersection_sequence ~lhs ~rhs |> Sequence.to_list)
    ~expect:[ 3 ];
  [%test_result: int list]
    (B.difference_sequence ~lhs ~rhs |> Sequence.to_list)
    ~expect:[ 1; 5 ]
;;

let%test_unit "pop_first_set removes smallest bit" =
  let bits = B.of_list [ 5; 2; 7 ] in
  [%test_result: int option] (B.pop_first_set bits) ~expect:(Some 2);
  [%test_result: int list] (int_list bits) ~expect:[ 5; 7 ]
;;

let%test_unit "first queries scan correctly" =
  let bits = B.of_list [ 0; 3; 6 ] in
  [%test_result: int option] (B.first_set bits) ~expect:(Some 0);
  [%test_result: int option] (B.first_unset bits) ~expect:(Some 1);
  [%test_result: int option] (B.first_set_ge bits ~ge:2) ~expect:(Some 3);
  [%test_result: int option] (B.first_unset_ge bits ~ge:4) ~expect:(Some 4)
;;

let%test_unit "clear_all resets the structure" =
  let bits = B.of_list [ 1; 9 ] in
  B.clear_all bits;
  [%test_result: bool] (B.is_empty bits) ~expect:true;
  [%test_result: int list] (int_list bits) ~expect:[]
;;
