open! Core
open! Import
open! Dsl

(* Compare function for i64 elements: returns negative if *a < *b *)
let compare_i64 : (ptr -> ptr -> int64, int64) Dsl.Fn.t =
  [%nod
    fun (a : ptr) (b : ptr) ->
      let a_val = load a in
      let b_val = load b in
      let diff = sub a_val b_val in
      return diff]
;;

module I64_heap = Binary_heap.Compile (struct
    let elt_type = Type.I64
    let compare = compare_i64
  end)

(* Test: create a heap and check its length is 0 *)
let test_create_len_root =
  let instrs =
    [%nod
      let heap = I64_heap.create (lit 16L) in
      let len = I64_heap.len heap in
      return len]
  in
  let unnamed = Dsl.Fn.Unnamed.const Dsl.Type_repr.Int64 instrs in
  Dsl.Fn.create ~name:"root" ~unnamed
;;

let test_create_len_program =
  Dsl.program
    ~functions:
      (Dsl.Fn.pack test_create_len_root
       :: Dsl.Fn.pack compare_i64
       :: I64_heap.functions)
    ~globals:[]
;;

(* Test: push one element and check length *)
let test_push_one_root =
  let instrs =
    [%nod
      let heap = I64_heap.create (lit 16L) in
      let elt = alloca (lit 8L) in
      store (lit 42L) elt;
      let _ = I64_heap.push heap elt in
      let len = I64_heap.len heap in
      return len]
  in
  let unnamed = Dsl.Fn.Unnamed.const Dsl.Type_repr.Int64 instrs in
  Dsl.Fn.create ~name:"root" ~unnamed
;;

let test_push_one_program =
  Dsl.program
    ~functions:
      (Dsl.Fn.pack test_push_one_root
       :: Dsl.Fn.pack compare_i64
       :: I64_heap.functions)
    ~globals:[]
;;

(* Test: push one element and peek *)
let test_push_peek_root =
  let instrs =
    [%nod
      let heap = I64_heap.create (lit 16L) in
      let elt = alloca (lit 8L) in
      store (lit 42L) elt;
      let _ = I64_heap.push heap elt in
      let top = I64_heap.peek heap in
      let value = load top in
      return value]
  in
  let unnamed = Dsl.Fn.Unnamed.const Dsl.Type_repr.Int64 instrs in
  Dsl.Fn.create ~name:"root" ~unnamed
;;

let test_push_peek_program =
  Dsl.program
    ~functions:
      (Dsl.Fn.pack test_push_peek_root
       :: Dsl.Fn.pack compare_i64
       :: I64_heap.functions)
    ~globals:[]
;;

(* Test: push two elements, check min is at top *)
let test_push_two_min_root =
  let instrs =
    [%nod
      let heap = I64_heap.create (lit 16L) in
      let elt1 = alloca (lit 8L) in
      store (lit 100L) elt1;
      let _ = I64_heap.push heap elt1 in
      let elt2 = alloca (lit 8L) in
      store (lit 50L) elt2;
      let _ = I64_heap.push heap elt2 in
      let top = I64_heap.peek heap in
      let value = load top in
      return value]
  in
  let unnamed = Dsl.Fn.Unnamed.const Dsl.Type_repr.Int64 instrs in
  Dsl.Fn.create ~name:"root" ~unnamed
;;

let test_push_two_min_program =
  Dsl.program
    ~functions:
      (Dsl.Fn.pack test_push_two_min_root
       :: Dsl.Fn.pack compare_i64
       :: I64_heap.functions)
    ~globals:[]
;;

(* Test: push three elements, pop one, check new min *)
let test_pop_root =
  let instrs =
    [%nod
      let heap = I64_heap.create (lit 16L) in
      let elt1 = alloca (lit 8L) in
      store (lit 30L) elt1;
      let _ = I64_heap.push heap elt1 in
      let elt2 = alloca (lit 8L) in
      store (lit 10L) elt2;
      let _ = I64_heap.push heap elt2 in
      let elt3 = alloca (lit 8L) in
      store (lit 20L) elt3;
      let _ = I64_heap.push heap elt3 in
      (* Pop the min (10), new min should be 20 *)
      let out = alloca (lit 8L) in
      let _ = I64_heap.pop heap out in
      let popped = load out in
      let top = I64_heap.peek heap in
      let new_min = load top in
      (* Return popped * 1000 + new_min so we can check both values *)
      let scaled = mul popped (lit 1000L) in
      let result = add scaled new_min in
      return result]
  in
  let unnamed = Dsl.Fn.Unnamed.const Dsl.Type_repr.Int64 instrs in
  Dsl.Fn.create ~name:"root" ~unnamed
;;

let test_pop_program =
  Dsl.program
    ~functions:
      (Dsl.Fn.pack test_pop_root
       :: Dsl.Fn.pack compare_i64
       :: I64_heap.functions)
    ~globals:[]
;;

(* Test: push and pop multiple times *)
let test_push_pop_multiple_root =
  let instrs =
    [%nod
      let heap = I64_heap.create (lit 16L) in
      (* Push 50, 30, 70, 10, 40 *)
      let elt = alloca (lit 8L) in
      store (lit 50L) elt;
      let _ = I64_heap.push heap elt in
      store (lit 30L) elt;
      let _ = I64_heap.push heap elt in
      store (lit 70L) elt;
      let _ = I64_heap.push heap elt in
      store (lit 10L) elt;
      let _ = I64_heap.push heap elt in
      store (lit 40L) elt;
      let _ = I64_heap.push heap elt in
      (* Pop three times, should get 10, 30, 40 *)
      let out = alloca (lit 8L) in
      let _ = I64_heap.pop heap out in
      let first = load out in
      let _ = I64_heap.pop heap out in
      let second = load out in
      let _ = I64_heap.pop heap out in
      let third = load out in
      (* Return first * 10000 + second * 100 + third *)
      let r1 = mul first (lit 10000L) in
      let r2 = mul second (lit 100L) in
      let result = add r1 r2 in
      let result = add result third in
      return result]
  in
  let unnamed = Dsl.Fn.Unnamed.const Dsl.Type_repr.Int64 instrs in
  Dsl.Fn.create ~name:"root" ~unnamed
;;

let test_push_pop_multiple_program =
  Dsl.program
    ~functions:
      (Dsl.Fn.pack test_push_pop_multiple_root
       :: Dsl.Fn.pack compare_i64
       :: I64_heap.functions)
    ~globals:[]
;;

let compile_and_execute_program_exn program expected =
  List.iter test_architectures_narrow ~f:(fun arch ->
    let compiled = Dsl.compile_program_exn program in
    let asm =
      compile_and_lower_functions
        ~arch
        ~system:host_system
        ~globals:compiled.Program.globals
        compiled.Program.functions
    in
    let output =
      execute_asm ~arch ~system:host_system ~harness:harness_source asm
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

let%expect_test "heap create and len" =
  compile_and_execute_program_exn test_create_len_program "0";
  [%expect {| |}]
;;

let%expect_test "heap push one" =
  compile_and_execute_program_exn test_push_one_program "1";
  [%expect {| |}]
;;

let%expect_test "heap push and peek" =
  compile_and_execute_program_exn test_push_peek_program "42";
  [%expect {| |}]
;;

let%expect_test "heap push two - min at top" =
  compile_and_execute_program_exn test_push_two_min_program "50";
  [%expect {| |}]
;;

let%expect_test "heap pop" =
  (* 10 * 1000 + 20 = 10020 *)
  compile_and_execute_program_exn test_pop_program "10020";
  [%expect {| |}]
;;

let%expect_test "heap push pop multiple" =
  (* 10 * 10000 + 30 * 100 + 40 = 103040 *)
  compile_and_execute_program_exn test_push_pop_multiple_program "103040";
  [%expect.unreachable]
[@@expect.uncaught_exn {|
  (* CR expect_test_collector: This test expectation appears to contain a backtrace.
     This is strongly discouraged as backtraces are fragile.
     Please change this test to not include a backtrace. *)
  (Failure
    "command failed (139): cd 'nod-exec.tmp.wZ3LMY' && './program' > 'stdout.txt'")
  Raised at Stdlib.failwith in file "stdlib.ml" (inlined), line 39, characters 17-33
  Called from Nod.run_shell_exn in file "lib/nod.ml", line 115, characters 12-69
  Called from Nod.execute_asm.(fun) in file "lib/nod.ml", lines 308-313, characters 6-166
  Called from Base__Exn.protectx in file "src/exn.ml" (inlined), line 59, characters 8-11
  Called from Base__Exn.protect in file "src/exn.ml" (inlined), line 72, characters 26-49
  Called from Nod.execute_asm in file "lib/nod.ml", lines 287-317, characters 2-1185
  Re-raised at Base__Exn.raise_with_original_backtrace in file "src/exn.ml" (inlined), line 35, characters 2-50
  Called from Base__Exn.protectx in file "src/exn.ml" (inlined), line 66, characters 13-49
  Called from Base__Exn.protect in file "src/exn.ml" (inlined), line 72, characters 26-49
  Called from Nod.execute_asm in file "lib/nod.ml", lines 287-317, characters 2-1185
  Called from Nod.execute_asm in file "lib/nod.ml" (inlined), lines 241-317, characters 2-2665
  Called from Nod_runtime_tests__Test_binary_heap.compile_and_execute_program_exn.(fun) in file "runtime_tests/test_binary_heap.ml", line 212, characters 6-71
  Called from Base__List0.iter in file "src/list0.ml" (inlined), line 83, characters 4-7
  Called from Nod_runtime_tests__Test_binary_heap.compile_and_execute_program_exn in file "runtime_tests/test_binary_heap.ml", lines 202-221, characters 2-561
  Called from Nod_runtime_tests__Test_binary_heap.(fun) in file "runtime_tests/test_binary_heap.ml", line 252, characters 2-73
  Called from Ppx_expect_runtime__Test_block.Configured.dump_backtrace in file "runtime/test_block.ml", line 358, characters 10-25

  Trailing output
  ---------------
  Segmentation fault (core dumped)
  |}]
;;
