open! Core

type 'a t =
  { mutable arr : 'a array
  ; mutable length : int
  }
[@@deriving fields]

let create ?(capacity = 0) () =
  { arr = Array.create ~len:capacity (Obj.magic ()); length = 0 }
;;

let length t = t.length

let rec push t v =
  if t.length = Array.length t.arr
  then (
    let new_len = 2 * (t.length + 1) in
    let new_ = Array.create ~len:new_len (Obj.magic ()) in
    Array.blit ~src:t.arr ~src_pos:0 ~dst:new_ ~dst_pos:0 ~len:t.length;
    t.arr <- new_;
    push t v)
  else (
    t.arr.(t.length) <- v;
    t.length <- t.length + 1)
;;

let pop_exn t =
  if t.length = 0
  then raise (Invalid_argument "Empty array")
  else (
    t.length <- t.length - 1;
    t.arr.(t.length))
;;

let get t i =
  if i < 0 || i >= t.length
  then raise (Invalid_argument [%string "Index %{i#Int} out of bounds"])
  else t.arr.(i)
;;

let set t i v =
  if i < 0 || i >= t.length
  then raise (Invalid_argument "Index out of bounds")
  else t.arr.(i) <- v
;;

let iter t ~f =
  for i = 0 to t.length - 1 do
    f t.arr.(i)
  done
;;

let iteri t ~f =
  for i = 0 to t.length - 1 do
    f i t.arr.(i)
  done
;;

let fold t ~init ~f =
  let r = ref init in
  for i = 0 to t.length - 1 do
    r := f !r t.arr.(i)
  done;
  !r
;;

let fill_to_length t ~length ~f =
  let i = ref (t.length - 1) in
  while !i < length - 1 do
    push t (f !i);
    incr i
  done
;;

let map t ~f =
  let new_ = create ~capacity:t.length () in
  for i = 0 to t.length - 1 do
    push new_ (f t.arr.(i))
  done;
  new_
;;

let of_list l =
  let t = create ~capacity:(List.length l) () in
  List.iter l ~f:(push t);
  t
;;

let to_list t = fold t ~init:[] ~f:(fun acc x -> x :: acc) |> List.rev
let to_array t = Array.sub t.arr ~pos:0 ~len:t.length

let%expect_test "push" =
  let t = create () in
  push t 1;
  push t 2;
  push t 3;
  push t 4;
  push t 5;
  iter t ~f:(fun x -> Int.to_string x |> print_endline);
  [%expect {|
    1
    2
    3
    4
    5
    |}]
;;

let sexp_of_t (type a) sexp_of_a t = [%sexp_of: a list] (to_list t)
let t_of_sexp (type a) a_of_sexp sexp = [%of_sexp: a list] sexp |> of_list

let mem t v ~compare =
  let rec loop i =
    if i = t.length
    then false
    else if compare t.arr.(i) v = 0
    then true
    else loop (i + 1)
  in
  loop 0
;;

let take t ~other =
  t.arr <- other.arr;
  t.length <- other.length;
  other.arr <- [||];
  other.length <- 0
;;

let switch t1 t2 =
  let arr = t1.arr in
  let length = t1.length in
  t1.arr <- t2.arr;
  t1.length <- t2.length;
  t2.arr <- arr;
  t2.length <- length
;;
