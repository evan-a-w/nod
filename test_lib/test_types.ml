open! Core
open! Import

let test s =
  s
  |> Parser.parse_string
  |> Result.map ~f:(fun program ->
    let state = Nod_core.State.create () in
    { program with
      Program.functions =
        Map.mapi program.Program.functions ~f:(fun ~key:name ~data:fn ->
          Function0.map_root
            fn
            ~f:(Cfg.process ~fn_state:(Nod_core.State.fn_state state name)))
    })
  |> Result.bind ~f:(fun program ->
    Map.fold program.Program.functions ~init:(Ok ()) ~f:(fun ~key:_ ~data acc ->
      let%bind.Result () = acc in
      let { Nod_ir.Function.root = ~root:_, ~blocks:_, ~in_order:blocks; _ } = data in
      Vec.fold blocks ~init:(Ok ()) ~f:(fun acc block ->
        let%bind.Result () = acc in
        List.fold
          (Instr_state.to_ir_list (Block.instructions block)
           |> List.map ~f:Fn_state.var_ir
           |> fun instrs ->
           instrs @ [ Fn_state.var_ir (Block.terminal block).Instr_state.ir ])
          ~init:(Ok ())
          ~f:(fun acc instr ->
            let%bind.Result () = acc in
            Ir.check_types instr))))
  |> function
  | Error e -> print_endline (Nod_error.to_string e)
  | Ok () -> print_endline "OK"
;;

(* Pointer arithmetic tests *)

let%expect_test "pointer + i64" =
  test
    {|
    mov %ptr:ptr, 1000
    add %result:ptr, %ptr, 8
    return %result
  |};
  [%expect {| OK |}]
;;

let%expect_test "i64 + pointer" =
  test
    {|
    mov %ptr:ptr, 1000
    add %result:ptr, 8, %ptr
    return %result
  |};
  [%expect {| OK |}]
;;

let%expect_test "pointer - i64" =
  test
    {|
    mov %ptr:ptr, 1000
    sub %result:ptr, %ptr, 8
    return %result
  |};
  [%expect {| OK |}]
;;

let%expect_test "pointer + literal" =
  test
    {|
    mov %ptr:ptr, 1000
    add %result:ptr, %ptr, 16
    return %result
  |};
  [%expect {| OK |}]
;;

let%expect_test "pointer arithmetic with i64 variable" =
  test
    {|
    mov %ptr:ptr, 1000
    mov %offset:i64, 24
    add %result:ptr, %ptr, %offset
    return %result
  |};
  [%expect {| OK |}]
;;

let%expect_test "pointer subtraction gives i64" =
  test
    {|
    mov %ptr1:ptr, 1000
    mov %ptr2:ptr, 1050
    sub %diff:i64, %ptr2, %ptr1
    return %diff
  |};
  [%expect {| OK |}]
;;

(* Pointer arithmetic error cases *)

let%expect_test "pointer + pointer (should fail)" =
  test
    {|
    mov %ptr1:ptr, 1000
    mov %ptr2:ptr, 2000
    add %result:ptr, %ptr1, %ptr2
    return %result
  |};
  [%expect
    {| Error: type mismatch: add with pointer destination requires one pointer and one i64 operand |}]
;;

let%expect_test "pointer + i32 (should fail)" =
  test
    {|
    mov %ptr:ptr, 1000
    mov %offset:i32, 8
    add %result:ptr, %ptr, %offset
    return %result
  |};
  [%expect
    {| Error: type mismatch: add with pointer destination requires one pointer and one i64 operand |}]
;;

(* Integer arithmetic tests *)

let%expect_test "i64 + i64" =
  test
    {|
    mov %a:i64, 10
    mov %b:i64, 20
    add %c:i64, %a, %b
    return %c
  |};
  [%expect {| OK |}]
;;

let%expect_test "i32 + i32" =
  test
    {|
    mov %a:i32, 10
    mov %b:i32, 20
    add %c:i32, %a, %b
    return %a
  |};
  [%expect {| OK |}]
;;

let%expect_test "mixed integer types (should fail)" =
  test
    {|
    mov %a:i64, 10
    mov %b:i32, 20
    add %c:i64, %a, %b
    return %c
  |};
  [%expect
    {| Error: type mismatch: add expects rhs of type i64 but got b:i32 |}]
;;

(* Alloca tests *)

let%expect_test "alloca with i64 size" =
  test {|
    mov %size:i64, 16
    alloca %ptr:ptr, %size
    return %ptr
  |};
  [%expect {| OK |}]
;;

let%expect_test "alloca with literal size" =
  test {|
    alloca %ptr:ptr, 32
    return %ptr
  |};
  [%expect {| OK |}]
;;

let%expect_test "alloca with non-ptr destination (should fail)" =
  test {|
    alloca %not_ptr:i64, 16
    return %not_ptr
  |};
  [%expect
    {| Error: type mismatch: alloca destination not_ptr:i64 must have ptr type |}]
;;

(* Move tests *)

let%expect_test "move matching types" =
  test {|
    mov %a:i64, 100
    mov %b:i64, %a
    return %b
  |};
  [%expect {| OK |}]
;;

let%expect_test "move literal to ptr" =
  test {|
    mov %ptr:ptr, 1000
    return %ptr
  |};
  [%expect {| OK |}]
;;

let%expect_test "move mismatched types (should fail)" =
  test {|
    mov %a:i64, 100
    mov %b:i32, %a
    return %b
  |};
  [%expect
    {| Error: type mismatch: move destination b:i32 does not match source a:i64 |}]
;;

let%expect_test "load_field extracts scalar" =
  test
    {|
    alloca %buf:ptr, (i64, f64)
    load_field %hi:i64, %buf, (i64, f64), 0
    return %hi
  |};
  [%expect {| OK |}]
;;

let%expect_test "store_field mismatched type fails" =
  test
    {|
    alloca %buf:ptr, (i64, f64)
    mov %wrong:f64, 0
    store_field %buf, %wrong, (i64, f64), 0
    return %wrong
  |};
  [%expect
    {| Error: type mismatch: store_field expected source of type i64 but got f64 |}]
;;

let%expect_test "memcpy expands to loads and stores" =
  test
    {|
    alloca %src:ptr, (i64, f64)
    alloca %dst:ptr, (i64, f64)
    memcpy %dst, %src, (i64, f64)
    return %src
  |};
  [%expect {| OK |}]
;;

let%expect_test "alloca sizeof tuple" =
  test
    {|
    alloca %buf:ptr, sizeof[(i64, f64)]
    return %buf
  |};
  [%expect {| OK |}]
;;

let%expect_test "sizeof works in arithmetic" =
  test
    {|
    alloca %buf:ptr, sizeof[(i64, f64)]
    add %ptr:ptr, %buf, sizeof[i64]
    sub %diff:i64, %ptr, %buf
    return %diff
  |};
  [%expect {| OK |}]
;;

(* All arithmetic operations with integers *)

let%expect_test "sub i64" =
  test
    {|
    mov %a:i64, 100
    mov %b:i64, 30
    sub %c:i64, %a, %b
    return %c
  |};
  [%expect {| OK |}]
;;

let%expect_test "mul i64" =
  test
    {|
    mov %a:i64, 10
    mov %b:i64, 20
    mul %c:i64, %a, %b
    return %c
  |};
  [%expect {| OK |}]
;;

let%expect_test "div i64" =
  test
    {|
    mov %a:i64, 100
    mov %b:i64, 10
    div %c:i64, %a, %b
    return %c
  |};
  [%expect {| OK |}]
;;

let%expect_test "mod i64" =
  test
    {|
    mov %a:i64, 100
    mov %b:i64, 7
    mod %c:i64, %a, %b
    return %c
  |};
  [%expect {| OK |}]
;;

let%expect_test "and i64" =
  test
    {|
    mov %a:i64, 255
    mov %b:i64, 15
    and %c:i64, %a, %b
    return %c
  |};
  [%expect {| OK |}]
;;

let%expect_test "or i64" =
  test
    {|
    mov %a:i64, 8
    mov %b:i64, 4
    or %c:i64, %a, %b
    return %c
  |};
  [%expect {| OK |}]
;;

(* Multiple size tests *)

let%expect_test "i8 arithmetic" =
  test
    {|
    mov %a:i8, 10
    mov %b:i8, 20
    add %c:i8, %a, %b
    return %a
  |};
  [%expect {| OK |}]
;;

let%expect_test "i16 arithmetic" =
  test
    {|
    mov %a:i16, 1000
    mov %b:i16, 2000
    add %c:i16, %a, %b
    return %a
  |};
  [%expect {| OK |}]
;;

(* Complex pointer arithmetic *)

let%expect_test "multiple pointer arithmetic operations" =
  test
    {|
    alloca %base:ptr, 100
    add %ptr1:ptr, %base, 8
    add %ptr2:ptr, %ptr1, 16
    sub %ptr3:ptr, %ptr2, 4
    return %ptr3
  |};
  [%expect {| OK |}]
;;

let%expect_test "complex pointer computation" =
  test
    {|
    alloca %arr:ptr, 80
    mov %idx:i64, 5
    mul %offset:i64, %idx, 8
    add %ptr:ptr, %arr, %offset
    return %ptr
  |};
  [%expect {| OK |}]
;;

(* Float arithmetic tests *)

let%expect_test "f32 fadd" =
  test
    {|
    mov %a:f32, 1
    mov %b:f32, 2
    fadd %c:f32, %a, %b
    return %a
  |};
  [%expect {| OK |}]
;;

let%expect_test "f64 fadd" =
  test
    {|
    mov %a:f64, 1
    mov %b:f64, 2
    fadd %c:f64, %a, %b
    return %a
  |};
  [%expect {| OK |}]
;;

let%expect_test "f64 fsub" =
  test
    {|
    mov %a:f64, 10
    mov %b:f64, 3
    fsub %c:f64, %a, %b
    return %a
  |};
  [%expect {| OK |}]
;;

let%expect_test "f64 fmul" =
  test
    {|
    mov %a:f64, 3
    mov %b:f64, 7
    fmul %c:f64, %a, %b
    return %a
  |};
  [%expect {| OK |}]
;;

let%expect_test "f64 fdiv" =
  test
    {|
    mov %a:f64, 100
    mov %b:f64, 4
    fdiv %c:f64, %a, %b
    return %a
  |};
  [%expect {| OK |}]
;;

let%expect_test "mixed f32 and f64 (should fail)" =
  test
    {|
    mov %a:f32, 1
    mov %b:f64, 2
    fadd %c:f64, %a, %b
    return %a
  |};
  [%expect
    {| Error: type mismatch: fadd expects lhs of type f64 but got a:f32 |}]
;;

let%expect_test "float destination but integer operands (should fail)" =
  test
    {|
    mov %a:i64, 1
    mov %b:i64, 2
    fadd %c:f64, %a, %b
    return %a
  |};
  [%expect
    {| Error: type mismatch: fadd expects lhs of type f64 but got a:i64 |}]
;;

let%expect_test "integer instruction with float (should fail)" =
  test
    {|
    mov %a:f64, 1
    mov %b:f64, 2
    add %c:f64, %a, %b
    return %a
  |};
  [%expect
    {| Error: type mismatch: add destination c:f64 must be integer or pointer |}]
;;

let%expect_test "all float operations" =
  test
    {|
    mov %x:f64, 100
    mov %y:f64, 20
    fadd %sum:f64, %x, %y
    fsub %diff:f64, %x, %y
    fmul %prod:f64, %x, %y
    fdiv %quot:f64, %x, %y
    return %sum
  |};
  [%expect {| OK |}]
;;

(* Cast instruction tests for type conversions *)

let%expect_test "cast i64 to f64" =
  test
    {|
    mov %i:i64, 42
    cast %f:f64, %i
    cast %result:i64, %f
    return %result
  |};
  [%expect {| OK |}]
;;

let%expect_test "cast f64 to i64" =
  test {|
    mov %f:f64, 3
    cast %i:i64, %f
    return %i
  |};
  [%expect {| OK |}]
;;

let%expect_test "cast with literal" =
  test {|
    cast %f:f64, 42
    return %f
  |};
  [%expect {| OK |}]
;;

let%expect_test "cast i64 to i64 (should fail)" =
  test {|
    mov %a:i64, 1
    cast %b:i64, %a
    return %b
  |};
  [%expect
    {| Error: type mismatch: cast requires different types, use move for i64 to i64 |}]
;;

let%expect_test "cast f64 to f64 (should fail)" =
  test {|
    mov %a:f64, 1
    cast %b:f64, %a
    return %a
  |};
  [%expect
    {| Error: type mismatch: cast requires different types, use move for f64 to f64 |}]
;;

let%expect_test "cast i32 to f64" =
  test {|
    mov %i:i32, 42
    cast %f:f64, %i
    return %i
  |};
  [%expect {| OK |}]
;;
