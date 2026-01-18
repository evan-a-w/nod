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

let compile_and_print_x86_program program =
  let compiled = Dsl.compile_program_exn program in
  let asm =
    compile_and_lower_functions
      ~arch:`X86_64
      ~system:`Linux
      ~state:compiled.state
      ~globals:compiled.program.Program.globals
      compiled.program.Program.functions
  in
  print_endline asm
;;

let compile_and_execute_program_exn program expected =
  (* TODO: narrow because macos _ prefix in labels is a bit borked *)
  let archs =
    match Lazy.force Nod.host_arch with
    | `Arm64 -> []
    | `X86_64 -> [ `X86_64 ]
    | `Other -> []
  in
  List.iter archs ~f:(fun arch ->
    let compiled = Dsl.compile_program_exn program in
    let asm =
      compile_and_lower_functions
        ~arch
        ~system:host_system
        ~state:compiled.state
        ~globals:compiled.program.Program.globals
        compiled.program.Program.functions
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
  [%expect {| |}]
;;

let%expect_test "x86 test push pop program" =
  compile_and_print_x86_program test_push_pop_multiple_program;
  [%expect
    {|
    .intel_syntax noprefix
    .text
    .globl nod_fn_103_6
    nod_fn_103_6:
      push rbp
      mov rbp, rsp
      push r12
      push r13
      push r14
      push r15
      sub rsp, 16
      mov r13, rsi
      mov r10, rdi
    nod_fn_103_6___entry:
      mov r11, rbp
      sub r11, 48
      mov [r11], r13
      mov r15, r14
    nod_fn_103_6__sift_up_loop:
      mov r12, [r11]
      cmp r12, 0
      je nod_fn_103_6__intermediate_sift_up_loop_to_sift_up_done
    nod_fn_103_6__intermediate_sift_up_loop_to_sift_up_check_parent:
      jmp nod_fn_103_6__sift_up_check_parent
    nod_fn_103_6__intermediate_sift_up_loop_to_sift_up_done:
      mov r15, r14
      jmp nod_fn_103_6__sift_up_done
    nod_fn_103_6__sift_up_check_parent:
      mov rdi, r12
      call nod_fn_78_6
      mov r13, rax
      mov rdi, r10
      mov rsi, r12
      mov rdx, r13
      call nod_fn_35_6
      mov r14, rax
      mov r15, 0
      cmp r14, 0
      setl r15b
      cmp r15, 0
      je nod_fn_103_6__intermediate_sift_up_check_parent_to_sift_up_done
    nod_fn_103_6__intermediate_sift_up_check_parent_to_sift_up_swap:
      jmp nod_fn_103_6__sift_up_swap
    nod_fn_103_6__intermediate_sift_up_check_parent_to_sift_up_done:
      mov r15, r13
    nod_fn_103_6__sift_up_done:
      mov r15, 0
      mov rax, r15
    nod_fn_103_6__nod_fn_103_6__epilogue:
      sub rbp, 32
      mov rsp, rbp
      pop r15
      pop r14
      pop r13
      pop r12
      pop rbp
      ret
    nod_fn_103_6__sift_up_swap:
      push r10
      push r11
      mov rdi, r10
      mov rsi, r12
      mov rdx, r13
      call nod_fn_66_6
      mov r15, rax
      pop r11
      pop r10
      mov [r11], r13
      mov r15, r12
      mov r14, r13
      jmp nod_fn_103_6__sift_up_loop

    .globl nod_fn_126_6
    nod_fn_126_6:
      push rbp
      mov rbp, rsp
      push rbx
      push r12
      push r13
      push r14
      push r15
      sub rsp, 24
      mov r12, rsi
      mov rbx, rdi
    nod_fn_126_6___entry:
      mov rcx, [rbx + 16]
      mov r8, rbp
      sub r8, 56
      mov [r8], r12
      mov r12, r15
      mov r15, r11
      mov r15, r13
      mov r15, r14
    nod_fn_126_6__sift_down_loop:
      mov r9, [r8]
      mov rdi, r9
      call nod_fn_87_6
      mov r10, rax
      mov r15, 0
      cmp r10, rcx
      setl r15b
      cmp r15, 0
      je nod_fn_126_6__intermediate_sift_down_loop_to_sift_down_done
    nod_fn_126_6__intermediate_sift_down_loop_to_sift_down_has_left:
      jmp nod_fn_126_6__sift_down_has_left
    nod_fn_126_6__intermediate_sift_down_loop_to_sift_down_done:
      mov r15, r11
      mov r15, r13
      mov r15, r14
      jmp nod_fn_126_6__sift_down_done
    nod_fn_126_6__sift_down_has_left:
      mov rdi, r9
      call nod_fn_95_6
      mov r11, rax
      mov r15, 0
      cmp r11, rcx
      setl r15b
      mov r12, rbp
      sub r12, 64
      mov [r12], r10
      cmp r15, 0
      je nod_fn_126_6__intermediate_sift_down_has_left_to_sift_down_compare_with_parent
    nod_fn_126_6__intermediate_sift_down_has_left_to_sift_down_check_right:
      jmp nod_fn_126_6__sift_down_check_right
    nod_fn_126_6__intermediate_sift_down_has_left_to_sift_down_compare_with_parent:
      jmp nod_fn_126_6__sift_down_compare_with_parent
    nod_fn_126_6__sift_down_done:
      mov r15, 0
      mov rax, r15
    nod_fn_126_6__nod_fn_126_6__epilogue:
      sub rbp, 40
      mov rsp, rbp
      pop r15
      pop r14
      pop r13
      pop r12
      pop rbx
      pop rbp
      ret
    nod_fn_126_6__sift_down_check_right:
      mov r15, [r12]
      mov rdi, rbx
      mov rsi, r11
      mov rdx, r15
      call nod_fn_35_6
      mov r14, rax
      mov r15, 0
      cmp r14, 0
      setl r15b
      cmp r15, 0
      je nod_fn_126_6__intermediate_sift_down_check_right_to_sift_down_compare_with_parent
    nod_fn_126_6__intermediate_sift_down_check_right_to_sift_down_right_smaller:
      jmp nod_fn_126_6__sift_down_right_smaller
    nod_fn_126_6__intermediate_sift_down_check_right_to_sift_down_compare_with_parent:
    nod_fn_126_6__sift_down_compare_with_parent:
      mov r13, [r12]
      mov rdi, rbx
      mov rsi, r13
      mov rdx, r9
      call nod_fn_35_6
      mov r14, rax
      mov r15, 0
      cmp r14, 0
      setl r15b
      cmp r15, 0
      je nod_fn_126_6__intermediate_sift_down_compare_with_parent_to_sift_down_done
    nod_fn_126_6__intermediate_sift_down_compare_with_parent_to_sift_down_swap:
      jmp nod_fn_126_6__sift_down_swap
    nod_fn_126_6__intermediate_sift_down_compare_with_parent_to_sift_down_done:
      mov r15, r11
      mov r15, r13
      mov r15, r12
      jmp nod_fn_126_6__sift_down_done
    nod_fn_126_6__sift_down_right_smaller:
      mov [r12], r11
      jmp nod_fn_126_6__sift_down_compare_with_parent
    nod_fn_126_6__sift_down_swap:
      push r9
      push r10
      push r11
      mov rdi, rbx
      mov rsi, r9
      mov rdx, r13
      call nod_fn_66_6
      mov r15, rax
      pop r11
      pop r10
      pop r9
      mov [r8], r13
      mov r15, r9
      mov r15, r10
      mov r14, r12
      jmp nod_fn_126_6__sift_down_loop

    .globl nod_fn_179_6
    nod_fn_179_6:
      push rbp
      mov rbp, rsp
      push r13
      push r14
      push r15
      sub rsp, 8
      mov r13, rdi
    nod_fn_179_6___entry:
      mov r15, 24
      mov rdi, r15
      call malloc
      mov r14, rax
      mov r15, 8
      mov rax, r13
      imul r15
      mov r15, rax
      mov rdi, r15
      call malloc
      mov r15, rax
      mov [r14], r15
      mov [r14 + 8], r13
      mov qword ptr [r14 + 16], 0
      mov rax, r14
    nod_fn_179_6__nod_fn_179_6__epilogue:
      sub rbp, 24
      mov rsp, rbp
      pop r15
      pop r14
      pop r13
      pop rbp
      ret

    .globl nod_fn_193_6
    nod_fn_193_6:
      push rbp
      mov rbp, rsp
      push r15
      sub rsp, 8
      mov r15, rdi
    nod_fn_193_6___entry:
      mov r15, [r15 + 16]
      mov rax, r15
    nod_fn_193_6__nod_fn_193_6__epilogue:
      sub rbp, 8
      mov rsp, rbp
      pop r15
      pop rbp
      ret

    .globl nod_fn_200_6
    nod_fn_200_6:
      push rbp
      mov rbp, rsp
      push r15
      sub rsp, 8
      mov r15, rdi
    nod_fn_200_6___entry:
      mov rdi, r15
      mov rsi, 0
      call nod_fn_25_6
      mov r15, rax
      mov rax, r15
    nod_fn_200_6__nod_fn_200_6__epilogue:
      sub rbp, 8
      mov rsp, rbp
      pop r15
      pop rbp
      ret

    .globl nod_fn_207_6
    nod_fn_207_6:
      push rbp
      mov rbp, rsp
      push r12
      push r13
      push r14
      push r15
      mov r12, rsi
      mov r13, rdi
    nod_fn_207_6___entry:
      mov r14, [r13 + 16]
      mov rdi, r13
      mov rsi, r14
      call nod_fn_25_6
      mov r15, rax
      mov rdi, r12
      mov rsi, r15
      call nod_fn_44_6
      mov r15, rax
      mov r15, r14
      add r15, 1
      mov [r13 + 16], r15
      mov rdi, r13
      mov rsi, r14
      call nod_fn_103_6
      mov r15, rax
      mov r15, 0
      mov rax, r15
    nod_fn_207_6__nod_fn_207_6__epilogue:
      sub rbp, 32
      mov rsp, rbp
      pop r15
      pop r14
      pop r13
      pop r12
      pop rbp
      ret

    .globl nod_fn_220_6
    nod_fn_220_6:
      push rbp
      mov rbp, rsp
      push r12
      push r13
      push r14
      push r15
      mov r10, rsi
      mov r11, rdi
    nod_fn_220_6___entry:
      mov r12, [r11 + 16]
      cmp r12, 0
      je nod_fn_220_6__intermediate__entry_to_pop_empty
    nod_fn_220_6__intermediate__entry_to_pop_has_elements:
      jmp nod_fn_220_6__pop_has_elements
    nod_fn_220_6__intermediate__entry_to_pop_empty:
      jmp nod_fn_220_6__pop_empty
    nod_fn_220_6__pop_has_elements:
      mov rdi, r11
      mov rsi, 0
      call nod_fn_25_6
      mov r13, rax
      push r10
      push r11
      mov rdi, r13
      mov rsi, r10
      call nod_fn_44_6
      mov r15, rax
      pop r11
      pop r10
      mov r14, r12
      sub r14, 1
      mov [r11 + 16], r14
      cmp r14, 0
      jne nod_fn_220_6__intermediate_pop_has_elements_to_pop_sift
      jmp nod_fn_220_6__intermediate_pop_has_elements_to_pop_done
    nod_fn_220_6__pop_empty:
      mov r15, r14
      jmp nod_fn_220_6__pop_done
    nod_fn_220_6__intermediate_pop_has_elements_to_pop_sift:
      jmp nod_fn_220_6__pop_sift
    nod_fn_220_6__intermediate_pop_has_elements_to_pop_done:
      mov r15, r14
      mov r14, r13
      jmp nod_fn_220_6__pop_done
    nod_fn_220_6__pop_sift:
      mov rdi, r11
      mov rsi, r14
      call nod_fn_25_6
      mov r15, rax
      push r11
      mov rdi, r15
      mov rsi, r13
      call nod_fn_44_6
      mov r15, rax
      pop r11
      push r11
      mov rdi, r11
      mov rsi, 0
      call nod_fn_126_6
      mov r15, rax
      pop r11
      mov r15, r14
      mov r14, r13
    nod_fn_220_6__pop_done:
      mov r15, 0
      mov rax, r15
    nod_fn_220_6__nod_fn_220_6__epilogue:
      sub rbp, 32
      mov rsp, rbp
      pop r15
      pop r14
      pop r13
      pop r12
      pop rbp
      ret

    .globl nod_fn_25_6
    nod_fn_25_6:
      push rbp
      mov rbp, rsp
      push r13
      push r14
      push r15
      sub rsp, 8
      mov r14, rsi
      mov r13, rdi
    nod_fn_25_6___entry:
      mov r15, 8
      mov rax, r15
      imul r14
      mov r14, rax
      mov r15, [r13]
      add r15, r14
      mov rax, r15
    nod_fn_25_6__nod_fn_25_6__epilogue:
      sub rbp, 24
      mov rsp, rbp
      pop r15
      pop r14
      pop r13
      pop rbp
      ret

    .globl nod_fn_35_6
    nod_fn_35_6:
      push rbp
      mov rbp, rsp
      push r13
      push r14
      push r15
      sub rsp, 8
      mov r14, rsi
      mov r13, rdx
      mov r15, rdi
    nod_fn_35_6___entry:
      mov rdi, r15
      mov rsi, r14
      call nod_fn_25_6
      mov r14, rax
      mov rdi, r15
      mov rsi, r13
      call nod_fn_25_6
      mov r15, rax
      mov rdi, r14
      mov rsi, r15
      call nod_fn_8_4
      mov r15, rax
      mov rax, r15
    nod_fn_35_6__nod_fn_35_6__epilogue:
      sub rbp, 24
      mov rsp, rbp
      pop r15
      pop r14
      pop r13
      pop rbp
      ret

    .globl nod_fn_44_6
    nod_fn_44_6:
      push rbp
      mov rbp, rsp
      push r12
      push r13
      push r14
      push r15
      sub rsp, 16
      mov r9, rsi
      mov r10, rdi
    nod_fn_44_6___entry:
      mov r11, 8
      mov r12, rbp
      sub r12, 48
      mov qword ptr [r12], 0
    nod_fn_44_6__copy_loop:
      mov r13, [r12]
      mov r15, r11
      sub r15, r13
      cmp r15, 0
      je nod_fn_44_6__intermediate_copy_loop_to_copy_done
    nod_fn_44_6__intermediate_copy_loop_to_copy_body:
      jmp nod_fn_44_6__copy_body
    nod_fn_44_6__intermediate_copy_loop_to_copy_done:
      jmp nod_fn_44_6__copy_done
    nod_fn_44_6__copy_body:
      mov r15, r10
      add r15, r13
      mov r14, r9
      add r14, r13
      mov r15, [r15]
      mov [r14], r15
      mov r15, r13
      add r15, 8
      mov [r12], r15
      mov r15, r13
      jmp nod_fn_44_6__copy_loop
    nod_fn_44_6__copy_done:
      mov r15, 0
      mov rax, r15
    nod_fn_44_6__nod_fn_44_6__epilogue:
      sub rbp, 32
      mov rsp, rbp
      pop r15
      pop r14
      pop r13
      pop r12
      pop rbp
      ret

    .globl nod_fn_66_6
    nod_fn_66_6:
      push rbp
      mov rbp, rsp
      push r12
      push r13
      push r14
      push r15
      sub rsp, 16
      mov r13, rsi
      mov r14, rdx
      mov r15, rdi
    nod_fn_66_6___entry:
      mov rdi, r15
      mov rsi, r13
      call nod_fn_25_6
      mov r12, rax
      mov rdi, r15
      mov rsi, r14
      call nod_fn_25_6
      mov r13, rax
      mov r14, rbp
      sub r14, 48
      mov rdi, r12
      mov rsi, r14
      call nod_fn_44_6
      mov r15, rax
      mov rdi, r13
      mov rsi, r12
      call nod_fn_44_6
      mov r15, rax
      mov rdi, r14
      mov rsi, r13
      call nod_fn_44_6
      mov r15, rax
      mov r15, 0
      mov rax, r15
    nod_fn_66_6__nod_fn_66_6__epilogue:
      sub rbp, 32
      mov rsp, rbp
      pop r15
      pop r14
      pop r13
      pop r12
      pop rbp
      ret

    .globl nod_fn_78_6
    nod_fn_78_6:
      push rbp
      mov rbp, rsp
      push r14
      push r15
      mov r14, rdi
    nod_fn_78_6___entry:
      mov r15, 1
      sub r14, r15
      mov r15, 2
      mov rax, r14
      cqo
      idiv r15
      mov r15, rax
      mov rax, r15
    nod_fn_78_6__nod_fn_78_6__epilogue:
      sub rbp, 16
      mov rsp, rbp
      pop r15
      pop r14
      pop rbp
      ret

    .globl nod_fn_87_6
    nod_fn_87_6:
      push rbp
      mov rbp, rsp
      push r14
      push r15
      mov r14, rdi
    nod_fn_87_6___entry:
      mov r15, 2
      mov rax, r14
      imul r15
      mov r15, rax
      add r15, 1
      mov rax, r15
    nod_fn_87_6__nod_fn_87_6__epilogue:
      sub rbp, 16
      mov rsp, rbp
      pop r15
      pop r14
      pop rbp
      ret

    .globl nod_fn_8_4
    nod_fn_8_4:
      push rbp
      mov rbp, rsp
      push r14
      push r15
      mov r15, rdi
      mov r14, rsi
    nod_fn_8_4___entry:
      mov r15, [r15]
      mov r14, [r14]
      sub r15, r14
      mov rax, r15
    nod_fn_8_4__nod_fn_8_4__epilogue:
      sub rbp, 16
      mov rsp, rbp
      pop r15
      pop r14
      pop rbp
      ret

    .globl nod_fn_95_6
    nod_fn_95_6:
      push rbp
      mov rbp, rsp
      push r14
      push r15
      mov r14, rdi
    nod_fn_95_6___entry:
      mov r15, 2
      mov rax, r14
      imul r15
      mov r15, rax
      add r15, 2
      mov rax, r15
    nod_fn_95_6__nod_fn_95_6__epilogue:
      sub rbp, 16
      mov rsp, rbp
      pop r15
      pop r14
      pop rbp
      ret

    .globl root
    root:
      push rbp
      mov rbp, rsp
      push r12
      push r13
      push r14
      push r15
      sub rsp, 16
    root___entry:
      mov rdi, 16
      call nod_fn_179_6
      mov r11, rax
      mov r14, rbp
      sub r14, 40
      mov qword ptr [r14], 50
      push r11
      mov rdi, r11
      mov rsi, r14
      call nod_fn_207_6
      mov r15, rax
      pop r11
      mov qword ptr [r14], 30
      push r11
      mov rdi, r11
      mov rsi, r14
      call nod_fn_207_6
      mov r15, rax
      pop r11
      mov qword ptr [r14], 70
      push r11
      mov rdi, r11
      mov rsi, r14
      call nod_fn_207_6
      mov r15, rax
      pop r11
      mov qword ptr [r14], 10
      push r11
      mov rdi, r11
      mov rsi, r14
      call nod_fn_207_6
      mov r15, rax
      pop r11
      mov qword ptr [r14], 40
      push r11
      mov rdi, r11
      mov rsi, r14
      call nod_fn_207_6
      mov r15, rax
      pop r11
      mov r12, rbp
      sub r12, 48
      push r11
      mov rdi, r11
      mov rsi, r12
      call nod_fn_220_6
      mov r15, rax
      pop r11
      mov r13, [r12]
      push r11
      mov rdi, r11
      mov rsi, r12
      call nod_fn_220_6
      mov r15, rax
      pop r11
      mov r14, [r12]
      push r11
      mov rdi, r11
      mov rsi, r12
      call nod_fn_220_6
      mov r15, rax
      pop r11
      mov r12, [r12]
      mov r15, 10000
      mov rax, r13
      imul r15
      mov r13, rax
      mov r15, 100
      mov rax, r14
      imul r15
      mov r14, rax
      mov r15, r13
      add r15, r14
      add r15, r12
      mov rax, r15
    root__root__epilogue:
      sub rbp, 32
      mov rsp, rbp
      pop r15
      pop r14
      pop r13
      pop r12
      pop rbp
      ret
    .section .note.GNU-stack,"",@progbits
    |}]
;;
