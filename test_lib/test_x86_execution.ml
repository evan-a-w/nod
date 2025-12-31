open! Core
open! Import

let check_program ?harness ?opt_flags program expected =
  List.iter test_architectures ~f:(fun arch ->
    let output =
      compile_and_execute_on_arch arch ?harness ?opt_flags program
    in
    if not (String.equal output expected)
    then
      failwithf
        "arch %s produced %s, expected %s"
        (arch_to_string arch)
        output
        expected
        ())
;;

let%expect_test "simple execution" =
  check_program
    {|
mov %a:i64, 5
mov %b:i64, 7
add %res:i64, %a, %b
ret %res
|}
    "12"
;;

let%expect_test "branch execution" =
  check_program
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
    "42"
;;

let%expect_test "recursive fib" =
  check_program
    ~harness:
      (make_harness_source
         ~fn_name:"fib"
         ~fn_arg_type:"int64_t"
         ~fn_arg:"6"
         ())
    Examples.Textual.fib_recursive
    "13"
;;

(* Pointer arithmetic tests *)

let%expect_test "basic pointer arithmetic - adding offset" =
  check_program
    {|
alloca %base:ptr, 64
mov %offset:i64, 8
add %ptr:ptr, %base, %offset
sub %result:i64, %ptr, %base
ret %result
|}
    "8"
;;

let%expect_test "pointer arithmetic - array indexing" =
  check_program
    {|
alloca %array:ptr, 80
mov %idx:i64, 3
mul %byte_offset:i64, %idx, 8
add %element_ptr:ptr, %array, %byte_offset
sub %result:i64, %element_ptr, %array
ret %result
|}
    "24"
;;

let%expect_test "pointer arithmetic - multiple operations" =
  check_program
    {|
alloca %buf:ptr, 100
add %p1:ptr, %buf, 10
add %p2:ptr, %p1, 15
add %p3:ptr, %p2, 5
sub %total_offset:i64, %p3, %buf
ret %total_offset
|}
    "30"
;;

let%expect_test "pointer arithmetic in loop" =
  check_program
    {|
alloca %array:ptr, 80
mov %i:i64, 0
mov %sum:i64, 0

loop:
  mul %offset:i64, %i, 8
  add %ptr:ptr, %array, %offset
  add %sum:i64, %sum, %i
  add %i:i64, %i, 1
  sub %cond:i64, %i, 10
  branch %cond, loop, done

done:
  ret %sum
|}
    "45"
;;

let%expect_test "pointer arithmetic - subtracting from pointer" =
  check_program
    {|
alloca %buf:ptr, 100
add %end:ptr, %buf, 50
sub %middle:ptr, %end, 25
sub %result:i64, %middle, %buf
ret %result
|}
    "25"
;;

let%expect_test "pointer arithmetic - complex calculation" =
  check_program
    {|
alloca %data:ptr, 200
mov %base_idx:i64, 5
mul %base_offset:i64, %base_idx, 8
add %base_ptr:ptr, %data, %base_offset
mov %extra:i64, 3
mul %extra_offset:i64, %extra, 8
add %final_ptr:ptr, %base_ptr, %extra_offset
sub %total:i64, %final_ptr, %data
ret %total
|}
    "64"
;;

let%expect_test "alloca with dynamic size" =
  check_program
    {|
mov %size:i64, 32
alloca %buf:ptr, %size
add %end:ptr, %buf, %size
sub %actual_size:i64, %end, %buf
ret %actual_size
|}
    "32"
;;

let%expect_test "nested pointer arithmetic" =
  check_program
    {|
alloca %outer:ptr, 128
mov %outer_idx:i64, 2
mul %outer_off:i64, %outer_idx, 16
add %inner_base:ptr, %outer, %outer_off
mov %inner_idx:i64, 3
mul %inner_off:i64, %inner_idx, 8
add %element:ptr, %inner_base, %inner_off
sub %total_off:i64, %element, %outer
ret %total_off
|}
    "56"
;;

let%expect_test "pointer arithmetic with mixed operations" =
  check_program
    {|
alloca %arr:ptr, 100
mov %a:i64, 10
mov %b:i64, 20
add %sum:i64, %a, %b
add %ptr1:ptr, %arr, %sum
sub %diff:i64, %b, %a
sub %ptr2:ptr, %ptr1, %diff
sub %result:i64, %ptr2, %arr
ret %result
|}
    "20"
;;

let%expect_test "pointer arithmetic - boundary calculation" =
  check_program
    {|
mov %size:i64, 64
alloca %buffer:ptr, %size
add %ptr:ptr, %buffer, 0
sub %at_start:i64, %ptr, %buffer
add %end:ptr, %buffer, %size
sub %range:i64, %end, %buffer
mul %result:i64, %at_start, 100
add %result:i64, %result, %range
ret %result
|}
    "64"
;;

let%expect_test "load_field/store_field execute" =
  check_program
    {|
alloca %buf:ptr, (i64, f64)
store_field %buf, 123, (i64, f64), 0
load_field %result:i64, %buf, (i64, f64), 0
ret %result
|}
    "123"
;;

let%expect_test "memcpy executes for nested aggregate" =
  check_program
    {|
alloca %src:ptr, (i64, (i64, i64))
alloca %dst:ptr, (i64, (i64, i64))
store_field %src, 5, (i64, (i64, i64)), 0
store_field %src, 6, (i64, (i64, i64)), 1, 0
store_field %src, 7, (i64, (i64, i64)), 1, 1
memcpy %dst, %src, (i64, (i64, i64))
load_field %a:i64, %dst, (i64, (i64, i64)), 0
load_field %b:i64, %dst, (i64, (i64, i64)), 1, 0
load_field %c:i64, %dst, (i64, (i64, i64)), 1, 1
add %tmp:i64, %a, %b
add %sum:i64, %tmp, %c
ret %sum
|}
    "18"
;;

(* Float arithmetic tests *)

let%expect_test "basic float addition" =
  check_program
    {|
cast %x:f64, 3
cast %y:f64, 7
fadd %sum:f64, %x, %y
cast %result:i64, %sum
ret %result
|}
    "10"
;;

let%expect_test "float subtraction" =
  check_program
    {|
cast %x:f64, 10
cast %y:f64, 3
fsub %diff:f64, %x, %y
cast %result:i64, %diff
ret %result
|}
    "7"
;;

let%expect_test "float multiplication" =
  check_program
    {|
cast %x:f64, 3
cast %y:f64, 4
fmul %prod:f64, %x, %y
cast %result:i64, %prod
ret %result
|}
    "12"
;;

let%expect_test "float division" =
  check_program
    {|
cast %x:f64, 20
cast %y:f64, 4
fdiv %quot:f64, %x, %y
cast %result:i64, %quot
ret %result
|}
    "5"
;;

let%expect_test "cast i64 to f64 and back" =
  check_program
    {|
mov %i:i64, 42
cast %f:f64, %i
cast %result:i64, %f
ret %result
|}
    "42"
;;

let%expect_test "cast with float literal to i64" =
  check_program
    {|
cast %f:f64, 7
cast %i:i64, %f
ret %i
|}
    "7"
;;

let%expect_test "complex float calculation" =
  check_program
    {|
cast %a:f64, 10
cast %b:f64, 5
fadd %sum:f64, %a, %b
fsub %diff:f64, %a, %b
fmul %product:f64, %sum, %diff
cast %result:i64, %product
ret %result
|}
    "75"
;;

let%expect_test "float division truncates toward zero" =
  check_program
    {|
cast %x:f64, 7
cast %y:f64, 2
fdiv %quot:f64, %x, %y
cast %result:i64, %quot
ret %result
|}
    "3"
;;

let%expect_test "float division truncates toward zero (negative)" =
  check_program
    {|
cast %zero:f64, 0
cast %seven:f64, 7
fsub %neg_seven:f64, %zero, %seven
cast %two:f64, 2
fdiv %quot:f64, %neg_seven, %two
cast %result:i64, %quot
ret %result
|}
    "-3"
;;

let%expect_test "call with stack arguments" =
  check_program
    {|
sum8(%a:i64, %b:i64, %c:i64, %d:i64, %e:i64, %f:i64, %g:i64, %h:i64) {
  add %t0:i64, %a, %b
  add %t1:i64, %t0, %c
  add %t2:i64, %t1, %d
  add %t3:i64, %t2, %e
  add %t4:i64, %t3, %f
  add %t5:i64, %t4, %g
  add %t6:i64, %t5, %h
  ret %t6
}

root() {
  call sum8(1, 2, 3, 4, 5, 6, 7, 8) -> %res:i64
  ret %res
}
|}
    "36"
;;
