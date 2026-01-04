open! Core
open! Import

let run_if_x86 f =
  match Lazy.force Nod.host_arch with
  | `X86_64 -> f ()
  | `Arm64 | `Other -> ()
;;

let%test_unit "jit simple add" =
  run_if_x86 (fun () ->
    let program =
      {|
mov %a:i64, 5
mov %b:i64, 7
add %sum:i64, %a, %b
ret %sum
|}
    in
    let jit = Nod.compile_and_jit_x86 ~system:host_system program in
    let entry = X86_jit.entry jit "root" |> Option.value_exn in
    let result = X86_jit.call0_i64 entry in
    [%test_eq: int64] result 12L)
;;

let%test_unit "jit fib recursive" =
  run_if_x86 (fun () ->
    let jit =
      Nod.compile_and_jit_x86 ~system:host_system Examples.Textual.fib_recursive
    in
    let entry = X86_jit.entry jit "fib" |> Option.value_exn in
    let result = X86_jit.call1_i64 entry 6L in
    [%test_eq: int64] result 13L)
;;
