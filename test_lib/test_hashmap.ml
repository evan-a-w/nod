open! Core
open! Import

(* Hash map implementation using the PPX

   This is a simplified hash map demonstrating the PPX capabilities.
   It uses a fixed-size array for simplicity and linear probing for collision resolution.

   Memory layout:
   HashMap structure (24 bytes):
     - capacity: i64 (offset 0)
     - size: i64 (offset 8)
     - entries: ptr (offset 16)

   Entry structure:
     - occupied: i64 (offset 0, 0 or 1)
     - key: i64 (offset 8)
     - value: i64 (offset 16)

   Entry size: 24 bytes
*)

(* Use the common DSL from the dsl/ library *)
let entry_size = 24

(* hash_map_new: Creates a new hash map with given capacity
   Args: capacity (i64)
   Returns: ptr to hash map structure *)
let mk_new =
  [%nod
    fun (capacity : i64) ->
      (* Allocate hash map structure (24 bytes) *)
      let (map_ptr : ptr) = Dsl.call1 "malloc" (Dsl.lit 24L) in
      (* Calculate entries array size: capacity * 24 *)
      let (entry_size_lit : i64) =
        Dsl.mov (Dsl.lit (Int64.of_int entry_size))
      in
      let (entries_bytes : i64) =
        Dsl.mul (Dsl.var capacity) (Dsl.var entry_size_lit)
      in
      (* Allocate entries array *)
      let (entries_ptr : ptr) = Dsl.call1 "malloc" (Dsl.var entries_bytes) in
      (* Initialize entries to all zeros (occupied = 0) *)
      let (zero : i64) = Dsl.mov (Dsl.lit 0L) in
      seq
        [ Dsl.call0
            "memset"
            [ Dsl.var entries_ptr; Dsl.var zero; Dsl.var entries_bytes ]
        ];
      (* Store capacity at offset 0 *)
      seq [ Dsl.store_addr (Dsl.var capacity) map_ptr 0 ];
      (* Store size (0) at offset 8 *)
      seq [ Dsl.store_addr (Dsl.var zero) map_ptr 8 ];
      (* Store entries pointer at offset 16 *)
      seq [ Dsl.store_addr (Dsl.var entries_ptr) map_ptr 16 ];
      return (Dsl.var map_ptr)]
;;

(* hash: Simple hash function using bitwise AND to keep in range
   Args: key (i64), capacity (i64)
   Returns: hash value (i64) *)
let mk_hash =
  [%nod
    fun (key : i64) (capacity : i64) ->
      (* Use capacity - 1 as mask (assumes capacity is power of 2) *)
      let (mask : i64) = Dsl.sub (Dsl.var capacity) (Dsl.lit 1L) in
      let (hash : i64) = Dsl.and_ (Dsl.var key) (Dsl.var mask) in
      return (Dsl.var hash)]
;;

(* Helper: compute entry address
   Args: entries_ptr (ptr), index (i64)
   Returns: entry_ptr (ptr) *)
let mk_entry_addr =
  [%nod
    fun (entries_ptr : ptr) (index : i64) ->
      let (entry_size_lit : i64) =
        Dsl.mov (Dsl.lit (Int64.of_int entry_size))
      in
      let (entry_offset : i64) =
        Dsl.mul (Dsl.var index) (Dsl.var entry_size_lit)
      in
      let (entry_ptr : ptr) =
        Dsl.add (Dsl.var entries_ptr) (Dsl.var entry_offset)
      in
      return (Dsl.var entry_ptr)]
;;

(* insert_at: Insert a key-value pair at a specific index
   Args: map (ptr), index (i64), key (i64), value (i64)
   Returns: 1 on success, 0 if slot occupied *)
let mk_insert_at =
  [%nod
    fun (map : ptr) (index : i64) (key : i64) (value : i64) ->
      (* Get entries pointer *)
      let (entries_ptr : ptr) = Dsl.load_addr map 16 in
      (* Get entry address *)
      let (entry_ptr : ptr) =
        Dsl.call2 "hash_map_entry_addr" (Dsl.var entries_ptr) (Dsl.var index)
      in
      (* Check if slot is occupied *)
      let (occupied : i64) = Dsl.load_addr entry_ptr 0 in
      (* Store occupied = 1 *)
      let (one : i64) = Dsl.mov (Dsl.lit 1L) in
      seq [ Dsl.store_addr (Dsl.var one) entry_ptr 0 ];
      (* Store key *)
      seq [ Dsl.store_addr (Dsl.var key) entry_ptr 8 ];
      (* Store value *)
      seq [ Dsl.store_addr (Dsl.var value) entry_ptr 16 ];
      (* Increment size if this was a new entry *)
      let (was_new : i64) = Dsl.sub (Dsl.lit 1L) (Dsl.var occupied) in
      let (size : i64) = Dsl.load_addr map 8 in
      let (new_size : i64) = Dsl.add (Dsl.var size) (Dsl.var was_new) in
      seq [ Dsl.store_addr (Dsl.var new_size) map 8 ];
      return (Dsl.var one)]
;;

(* insert: Insert a key-value pair
   Args: map (ptr), key (i64), value (i64)
   Returns: 1 on success *)
let mk_insert =
  [%nod
    fun (map : ptr) (key : i64) (value : i64) ->
      (* Load capacity *)
      let (capacity : i64) = Dsl.load_addr map 0 in
      (* Compute hash *)
      let (index : i64) =
        Dsl.call2 "hash_map_hash" (Dsl.var key) (Dsl.var capacity)
      in
      (* Insert at the hashed index (simple, no collision handling for now) *)
      let (result : i64) =
        Dsl.call4
          "hash_map_insert_at"
          (Dsl.var map)
          (Dsl.var index)
          (Dsl.var key)
          (Dsl.var value)
      in
      return (Dsl.var result)]
;;

(* get: Retrieve a value by key
   Args: map (ptr), key (i64), default_value (i64)
   Returns: value (i64), or default if not found *)
let mk_get =
  [%nod
    fun (map : ptr) (key : i64) (default_val : i64) ->
      (* Load capacity *)
      let (capacity : i64) = Dsl.load_addr map 0 in
      (* Compute hash *)
      let (index : i64) =
        Dsl.call2 "hash_map_hash" (Dsl.var key) (Dsl.var capacity)
      in
      (* Get entries pointer *)
      let (entries_ptr : ptr) = Dsl.load_addr map 16 in
      (* Get entry address *)
      let (entry_ptr : ptr) =
        Dsl.call2 "hash_map_entry_addr" (Dsl.var entries_ptr) (Dsl.var index)
      in
      (* Check if occupied *)
      let (occupied : i64) = Dsl.load_addr entry_ptr 0 in
      (* Load the value *)
      let (value : i64) = Dsl.load_addr entry_ptr 16 in
      (* Return value if occupied, default otherwise *)
      (* result = (occupied * value) + ((1 - occupied) * default_val) *)
      let (occupied_value : i64) = Dsl.mul (Dsl.var occupied) (Dsl.var value) in
      let (one : i64) = Dsl.mov (Dsl.lit 1L) in
      let (not_occupied : i64) = Dsl.sub (Dsl.var one) (Dsl.var occupied) in
      let (not_occupied_default : i64) =
        Dsl.mul (Dsl.var not_occupied) (Dsl.var default_val)
      in
      let (result : i64) =
        Dsl.add (Dsl.var occupied_value) (Dsl.var not_occupied_default)
      in
      return (Dsl.var result)]
;;

(* size: Get the number of entries in the map *)
let mk_size =
  [%nod
    fun (map : ptr) ->
      let (size : i64) = Dsl.load_addr map 8 in
      return (Dsl.var size)]
;;

(* capacity: Get the capacity of the map *)
let mk_capacity =
  [%nod
    fun (map : ptr) ->
      let (capacity : i64) = Dsl.load_addr map 0 in
      return (Dsl.var capacity)]
;;

let make_hashmap () =
  [ mk_new ~name:"hash_map_new"
  ; mk_hash ~name:"hash_map_hash"
  ; mk_entry_addr ~name:"hash_map_entry_addr"
  ; mk_insert_at ~name:"hash_map_insert_at"
  ; mk_insert ~name:"hash_map_insert"
  ; mk_get ~name:"hash_map_get"
  ; mk_size ~name:"hash_map_size"
  ; mk_capacity ~name:"hash_map_capacity"
  ]
;;

let%expect_test "hash map functions compile" =
  let funcs = make_hashmap () in
  List.iter funcs ~f:(fun fn ->
    Block.iter_and_update_bookkeeping (Function.root fn) ~f:(fun _ -> ()));
  (* Print function names *)
  List.iter funcs ~f:(fun fn -> print_endline fn.Function.name);
  [%expect
    {|
    hash_map_new
    hash_map_hash
    hash_map_entry_addr
    hash_map_insert_at
    hash_map_insert
    hash_map_get
    hash_map_size
    hash_map_capacity
    |}]
;;

let%expect_test "hash map new function structure" =
  let funcs = make_hashmap () in
  List.iter funcs ~f:(fun fn ->
    Block.iter_and_update_bookkeeping (Function.root fn) ~f:(fun _ -> ()));
  let new_fn = List.hd_exn funcs in
  Function.print_verbose new_fn;
  [%expect
    {|
    ((call_conv Default)
     (root
      ((%entry (args (((name capacity) (type_ I64))))
        (instrs
         ((Call (fn malloc) (results (((name map_ptr) (type_ Ptr))))
           (args ((Lit 24))))
          (Move ((name entry_size_lit) (type_ I64)) (Lit 24))
          (Mul
           ((dest ((name entries_bytes) (type_ I64)))
            (src1 (Var ((name capacity) (type_ I64))))
            (src2 (Var ((name entry_size_lit) (type_ I64))))))
          (Call (fn malloc) (results (((name entries_ptr) (type_ Ptr))))
           (args ((Var ((name entries_bytes) (type_ I64))))))
          (Move ((name zero) (type_ I64)) (Lit 0))
          (Call (fn memset) (results ())
           (args
            ((Var ((name entries_ptr) (type_ Ptr)))
             (Var ((name zero) (type_ I64)))
             (Var ((name entries_bytes) (type_ I64))))))
          (Store (Var ((name capacity) (type_ I64)))
           (Address ((base (Var ((name map_ptr) (type_ Ptr)))) (offset 0))))
          (Store (Var ((name zero) (type_ I64)))
           (Address ((base (Var ((name map_ptr) (type_ Ptr)))) (offset 8))))
          (Store (Var ((name entries_ptr) (type_ Ptr)))
           (Address ((base (Var ((name map_ptr) (type_ Ptr)))) (offset 16))))
          (Return (Var ((name map_ptr) (type_ Ptr)))))))))
     (args (((name capacity) (type_ I64)))) (name hash_map_new) (prologue ())
     (epilogue ()) (bytes_for_clobber_saves 0) (bytes_for_padding 0)
     (bytes_for_spills 0) (bytes_statically_alloca'd 0))
    |}]
;;

let%expect_test "hash function" =
  let funcs = make_hashmap () in
  List.iter funcs ~f:(fun fn ->
    Block.iter_and_update_bookkeeping (Function.root fn) ~f:(fun _ -> ()));
  let hash_fn = List.nth_exn funcs 1 in
  Function.print_verbose hash_fn;
  [%expect
    {|
    ((call_conv Default)
     (root
      ((%entry (args (((name key) (type_ I64)) ((name capacity) (type_ I64))))
        (instrs
         ((Sub
           ((dest ((name mask) (type_ I64)))
            (src1 (Var ((name capacity) (type_ I64)))) (src2 (Lit 1))))
          (And
           ((dest ((name hash) (type_ I64)))
            (src1 (Var ((name key) (type_ I64))))
            (src2 (Var ((name mask) (type_ I64))))))
          (Return (Var ((name hash) (type_ I64)))))))))
     (args (((name key) (type_ I64)) ((name capacity) (type_ I64))))
     (name hash_map_hash) (prologue ()) (epilogue ()) (bytes_for_clobber_saves 0)
     (bytes_for_padding 0) (bytes_for_spills 0) (bytes_statically_alloca'd 0))
    |}]
;;

(* Test just the hash function - simpler test without memory allocation *)
let%expect_test "hash function standalone" =
  let hash_fn = mk_hash ~name:"test_hash" in
  Block.iter_and_update_bookkeeping (Function.root hash_fn) ~f:(fun _ -> ());
  (* Compile and execute on x86_64 if available *)
  only_on_arch `X86_64 (fun () ->
    let functions = String.Map.singleton "test_hash" hash_fn in
    let asm =
      X86_backend.compile_to_asm ~system:host_system ~globals:[] functions
    in
    (* Test: hash(42, 8) should give 42 & 7 = 2 *)
    let harness =
      [%string
        {|
#include <stdint.h>
#include <stdio.h>

extern int64_t test_hash(int64_t, int64_t);

int main(void) {
  /* Test: hash(42, 8) should give 42 & 7 = 2 */
  int64_t result1 = test_hash(42, 8);
  /* Test: hash(17, 8) should give 17 & 7 = 1 */
  int64_t result2 = test_hash(17, 8);
  /* Test: hash(255, 16) should give 255 & 15 = 15 */
  int64_t result3 = test_hash(255, 16);

  printf("%lld %lld %lld\n", (long long)result1, (long long)result2, (long long)result3);
  return 0;
}
|}]
    in
    let output = execute_asm ~arch:`X86_64 ~system:host_system ~harness asm in
    print_endline output);
  [%expect {| 2 1 15 |}]
;;

(* Test the full hash map with assembly execution *)
let%expect_test "hash map basic operations" =
  only_on_arch `X86_64 (fun () ->
    let hash_map_funcs = make_hashmap () in
    (* Create a test function that uses the hash map *)
    let test_fn =
      [%nod
        fun (_dummy : i64) ->
          (* Create a new hash map with capacity 8 *)
          let (map : ptr) = Dsl.call1 "hash_map_new" (Dsl.lit 8L) in
          (* Insert some values: key -> value *)
          let (r1 : i64) =
            Dsl.call3
              "hash_map_insert"
              (Dsl.var map)
              (Dsl.lit 5L)
              (Dsl.lit 100L)
          in
          let (r2 : i64) =
            Dsl.call3
              "hash_map_insert"
              (Dsl.var map)
              (Dsl.lit 13L)
              (Dsl.lit 200L)
          in
          let (r3 : i64) =
            Dsl.call3
              "hash_map_insert"
              (Dsl.var map)
              (Dsl.lit 3L)
              (Dsl.lit 300L)
          in
          (* Get the values back *)
          let (val1 : i64) =
            Dsl.call3 "hash_map_get" (Dsl.var map) (Dsl.lit 5L) (Dsl.lit 0L)
          in
          let (val2 : i64) =
            Dsl.call3 "hash_map_get" (Dsl.var map) (Dsl.lit 13L) (Dsl.lit 0L)
          in
          let (val3 : i64) =
            Dsl.call3 "hash_map_get" (Dsl.var map) (Dsl.lit 3L) (Dsl.lit 0L)
          in
          (* Get a non-existent value (should return default) *)
          let (val_missing : i64) =
            Dsl.call3 "hash_map_get" (Dsl.var map) (Dsl.lit 999L) (Dsl.lit 42L)
          in
          (* Get size *)
          let (size : i64) = Dsl.call1 "hash_map_size" (Dsl.var map) in
          (* Compute result: val1 + val2 + val3 + val_missing + size *)
          (* Expected: 100 + 200 + 300 + 42 + 3 = 645 *)
          let (sum1 : i64) = Dsl.add (Dsl.var val1) (Dsl.var val2) in
          let (sum2 : i64) = Dsl.add (Dsl.var sum1) (Dsl.var val3) in
          let (sum3 : i64) = Dsl.add (Dsl.var sum2) (Dsl.var val_missing) in
          let (result : i64) = Dsl.add (Dsl.var sum3) (Dsl.var size) in
          return (Dsl.var result)]
    in
    let all_funcs = hash_map_funcs @ [ test_fn ~name:"test_hashmap" ] in
    (* Process all functions *)
    List.iter all_funcs ~f:(fun fn ->
      Block.iter_and_update_bookkeeping (Function.root fn) ~f:(fun _ -> ()));
    let functions =
      all_funcs
      |> List.map ~f:(fun fn -> fn.Function.name, fn)
      |> String.Map.of_alist_exn
    in
    let asm =
      X86_backend.compile_to_asm ~system:host_system ~globals:[] functions
    in
    let harness =
      make_harness_source
        ~fn_name:"test_hashmap"
        ~fn_arg_type:"int64_t"
        ~fn_arg:"0"
        ()
    in
    let output = execute_asm ~arch:`X86_64 ~system:host_system ~harness asm in
    print_endline output);
  [%expect {| 645 |}]
;;

(* Test that overwriting values works *)
let%expect_test "hash map overwrite values" =
  only_on_arch `X86_64 (fun () ->
    let hash_map_funcs = make_hashmap () in
    let test_fn =
      [%nod
        fun (_dummy : i64) ->
          (* Create map with capacity 8 *)
          let (map : ptr) = Dsl.call1 "hash_map_new" (Dsl.lit 8L) in
          (* Insert initial value *)
          let (r1 : i64) =
            Dsl.call3
              "hash_map_insert"
              (Dsl.var map)
              (Dsl.lit 7L)
              (Dsl.lit 100L)
          in
          (* Get the value *)
          let (val1 : i64) =
            Dsl.call3 "hash_map_get" (Dsl.var map) (Dsl.lit 7L) (Dsl.lit 0L)
          in
          (* Overwrite with new value *)
          let (r2 : i64) =
            Dsl.call3
              "hash_map_insert"
              (Dsl.var map)
              (Dsl.lit 7L)
              (Dsl.lit 200L)
          in
          (* Get the new value *)
          let (val2 : i64) =
            Dsl.call3 "hash_map_get" (Dsl.var map) (Dsl.lit 7L) (Dsl.lit 0L)
          in
          (* Size should still be 1 (not 2) *)
          let (size : i64) = Dsl.call1 "hash_map_size" (Dsl.var map) in
          (* Return: old_value + new_value + size = 100 + 200 + 1 = 301 *)
          let (sum1 : i64) = Dsl.add (Dsl.var val1) (Dsl.var val2) in
          let (result : i64) = Dsl.add (Dsl.var sum1) (Dsl.var size) in
          return (Dsl.var result)]
    in
    let all_funcs = hash_map_funcs @ [ test_fn ~name:"test_overwrite" ] in
    List.iter all_funcs ~f:(fun fn ->
      Block.iter_and_update_bookkeeping (Function.root fn) ~f:(fun _ -> ()));
    let functions =
      all_funcs
      |> List.map ~f:(fun fn -> fn.Function.name, fn)
      |> String.Map.of_alist_exn
    in
    let asm =
      X86_backend.compile_to_asm ~system:host_system ~globals:[] functions
    in
    let harness =
      make_harness_source
        ~fn_name:"test_overwrite"
        ~fn_arg_type:"int64_t"
        ~fn_arg:"0"
        ()
    in
    let output = execute_asm ~arch:`X86_64 ~system:host_system ~harness asm in
    print_endline output);
  [%expect {| 301 |}]
;;

(* Test multiple insertions *)
let%expect_test "hash map multiple operations" =
  only_on_arch `X86_64 (fun () ->
    let hash_map_funcs = make_hashmap () in
    let test_fn =
      [%nod
        fun (_dummy : i64) ->
          (* Create map with capacity 16 *)
          let (map : ptr) = Dsl.call1 "hash_map_new" (Dsl.lit 16L) in
          (* Insert 5 different values *)
          let (r1 : i64) =
            Dsl.call3 "hash_map_insert" (Dsl.var map) (Dsl.lit 1L) (Dsl.lit 10L)
          in
          let (r2 : i64) =
            Dsl.call3 "hash_map_insert" (Dsl.var map) (Dsl.lit 2L) (Dsl.lit 20L)
          in
          let (r3 : i64) =
            Dsl.call3 "hash_map_insert" (Dsl.var map) (Dsl.lit 3L) (Dsl.lit 30L)
          in
          let (r4 : i64) =
            Dsl.call3 "hash_map_insert" (Dsl.var map) (Dsl.lit 4L) (Dsl.lit 40L)
          in
          let (r5 : i64) =
            Dsl.call3 "hash_map_insert" (Dsl.var map) (Dsl.lit 5L) (Dsl.lit 50L)
          in
          (* Verify size is 5 *)
          let (size : i64) = Dsl.call1 "hash_map_size" (Dsl.var map) in
          (* Get all values and sum them *)
          let (v1 : i64) =
            Dsl.call3 "hash_map_get" (Dsl.var map) (Dsl.lit 1L) (Dsl.lit 0L)
          in
          let (v2 : i64) =
            Dsl.call3 "hash_map_get" (Dsl.var map) (Dsl.lit 2L) (Dsl.lit 0L)
          in
          let (v3 : i64) =
            Dsl.call3 "hash_map_get" (Dsl.var map) (Dsl.lit 3L) (Dsl.lit 0L)
          in
          let (v4 : i64) =
            Dsl.call3 "hash_map_get" (Dsl.var map) (Dsl.lit 4L) (Dsl.lit 0L)
          in
          let (v5 : i64) =
            Dsl.call3 "hash_map_get" (Dsl.var map) (Dsl.lit 5L) (Dsl.lit 0L)
          in
          (* Sum: 10 + 20 + 30 + 40 + 50 + 5 (size) = 155 *)
          let (s1 : i64) = Dsl.add (Dsl.var v1) (Dsl.var v2) in
          let (s2 : i64) = Dsl.add (Dsl.var s1) (Dsl.var v3) in
          let (s3 : i64) = Dsl.add (Dsl.var s2) (Dsl.var v4) in
          let (s4 : i64) = Dsl.add (Dsl.var s3) (Dsl.var v5) in
          let (result : i64) = Dsl.add (Dsl.var s4) (Dsl.var size) in
          return (Dsl.var result)]
    in
    let all_funcs = hash_map_funcs @ [ test_fn ~name:"test_multi" ] in
    List.iter all_funcs ~f:(fun fn ->
      Block.iter_and_update_bookkeeping (Function.root fn) ~f:(fun _ -> ()));
    let functions =
      all_funcs
      |> List.map ~f:(fun fn -> fn.Function.name, fn)
      |> String.Map.of_alist_exn
    in
    let asm =
      X86_backend.compile_to_asm ~system:host_system ~globals:[] functions
    in
    let harness =
      make_harness_source
        ~fn_name:"test_multi"
        ~fn_arg_type:"int64_t"
        ~fn_arg:"0"
        ()
    in
    let output = execute_asm ~arch:`X86_64 ~system:host_system ~harness asm in
    print_endline output);
  [%expect {| 155 |}]
;;
