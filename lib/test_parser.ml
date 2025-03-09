open! Core

let%expect_test "simple" =
  {|
a:
add %a, 1, 2
b:
add %a, %a, 4
c: 
mov %a, 3
branch 1, a, b
|}
  |> Parser.parse_string
  |> function
  | Error _ -> print_endline "error!"
  | Ok blocks -> print_s [%sexp (blocks : string Ir.t' Vec.t String.Map.t)]
;;
