open! Core
open! Nod_core

let test_ok s =
  match Nod_clike.Clike.lower_string s with
  | Ok _ -> print_endline "ok"
  | Error err -> Nod_clike.Error.to_string err |> print_endline
;;

let%expect_test "struct alloca and field access" =
  {|
struct Pair {
  a: i64;
  b: i64;
};

i64 sum(i64 x, i64 y) {
  struct Pair* p = alloca(struct Pair);
  p->a = x;
  p->b = y;
  return p->a + p->b;
}
|}
  |> test_ok;
  [%expect {| ok |}]
;;

let%expect_test "if and while" =
  {|
i64 count(i64 n) {
  i64 acc = 0;
  while (n) {
    acc = acc + 1;
    n = n - 1;
  }
  if (acc) {
    acc = acc + 10;
  } else {
    acc = acc + 20;
  }
  return acc;
}
|}
  |> test_ok;
  [%expect {| ok |}]
;;
