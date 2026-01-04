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

let%test_unit "jit call with stack args" =
  run_if_x86 (fun () ->
    let program =
      {|
sum7(%a:i64, %b:i64, %c:i64, %d:i64, %e:i64, %f:i64, %g:i64) {
  add %t0:i64, %a, %b
  add %t1:i64, %t0, %c
  add %t2:i64, %t1, %d
  add %t3:i64, %t2, %e
  add %t4:i64, %t3, %f
  add %t5:i64, %t4, %g
  ret %t5
}

root() {
  call sum7(1, 2, 3, 4, 5, 6, 7) -> %res:i64
  ret %res
}
|}
    in
    let jit = Nod.compile_and_jit_x86 ~system:host_system program in
    let entry = X86_jit.entry jit "root" |> Option.value_exn in
    let result = X86_jit.call0_i64 entry in
    [%test_eq: int64] result 28L)
;;

let%test_unit "jit branch" =
  run_if_x86 (fun () ->
    let program =
      {|
mov %cond:i64, 3
sub %cond:i64, %cond, 3
branch %cond, nonzero, zero

nonzero:
  mov %value:i64, 111
  ret %value

zero:
  mov %value:i64, 42
  ret %value
|}
    in
    let jit = Nod.compile_and_jit_x86 ~system:host_system program in
    let entry = X86_jit.entry jit "root" |> Option.value_exn in
    let result = X86_jit.call0_i64 entry in
    [%test_eq: int64] result 42L)
;;

let%test_unit "jit float add + cast" =
  run_if_x86 (fun () ->
    let program =
      {|
cast %x:f64, 3
cast %y:f64, 7
fadd %sum:f64, %x, %y
cast %result:i64, %sum
ret %result
|}
    in
    let jit = Nod.compile_and_jit_x86 ~system:host_system program in
    let entry = X86_jit.entry jit "root" |> Option.value_exn in
    let result = X86_jit.call0_i64 entry in
    [%test_eq: int64] result 10L)
;;

let%test_unit "jit load/store" =
  run_if_x86 (fun () ->
    let program =
      {|
alloca %ptr:ptr, 8
mov %value:i64, 123
store %ptr, %value
load %out:i64, %ptr
ret %out
|}
    in
    let jit = Nod.compile_and_jit_x86 ~system:host_system program in
    let entry = X86_jit.entry jit "root" |> Option.value_exn in
    let result = X86_jit.call0_i64 entry in
    [%test_eq: int64] result 123L)
;;

let%test_unit "jit external call" =
  run_if_x86 (fun () ->
    let program =
      {|
root(%x:i64) {
  call add3(%x) -> %y:i64
  ret %y
}
|}
    in
    let externals name =
      if String.equal name "add3"
      then Some (Nod_backend_common.Jit_runtime.add3_ptr ())
      else None
    in
    let jit =
      Nod.compile_and_jit_x86 ~system:host_system ~externals program
    in
    let entry = X86_jit.entry jit "root" |> Option.value_exn in
    let result = X86_jit.call1_i64 entry 39L in
    [%test_eq: int64] result 42L)
;;
