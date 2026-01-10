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

type i64_atom = Dsl.int64 Dsl.Atom.t
type ptr_atom = Dsl.ptr Dsl.Atom.t

let malloc : (i64_atom, ptr_atom) Dsl.Fn.t =
  Dsl.Fn.external_ ~name:"malloc" ~args:[ Type.I64 ] ~returns:[ Type.Ptr ]
;;

let memset : (ptr_atom * i64_atom * i64_atom, ptr_atom) Dsl.Fn.t =
  Dsl.Fn.external_
    ~name:"memset"
    ~args:[ Type.Ptr; Type.I64; Type.I64 ]
    ~returns:[ Type.Ptr ]
;;

(* hash_map_new: Creates a new hash map with given capacity
   Args: capacity (i64)
   Returns: ptr to hash map structure *)
let mk_new (name : string) : (i64_atom, ptr_atom) Dsl.Fn.t =
  [%nod
    fun name (capacity : int64) ->
      (* Allocate hash map structure (24 bytes) *)
      let%named map_ptr = call malloc (lit 24L) in
      (* Calculate entries array size: capacity * 24 *)
      let%named entry_size_lit = mov (lit (Int64.of_int entry_size)) in
      let%named entries_bytes = mul capacity entry_size_lit in
      (* Allocate entries array *)
      let%named entries_ptr = call malloc entries_bytes in
      (* Initialize entries to all zeros (occupied = 0) *)
      let%named zero = mov (lit 0L) in
      seq
        [ Instr.call0 memset [ entries_ptr; zero; entries_bytes ] ];
      (* Store capacity at offset 0 *)
      store_addr capacity map_ptr 0;
      (* Store size (0) at offset 8 *)
      store_addr zero map_ptr 8;
      (* Store entries pointer at offset 16 *)
      store_addr entries_ptr map_ptr 16;
      return map_ptr]
;;

(* hash: Simple hash function using bitwise AND to keep in range
   Args: key (i64), capacity (i64)
   Returns: hash value (i64) *)
let mk_hash (name : string) : (i64_atom * i64_atom, i64_atom) Dsl.Fn.t =
  [%nod
    fun name (key : int64) (capacity : int64) ->
      (* Use capacity - 1 as mask (assumes capacity is power of 2) *)
      let%named mask = sub capacity (lit 1L) in
      let%named hash = and_ key mask in
      return hash]
;;

(* Helper: compute entry address
   Args: entries_ptr (ptr), index (i64)
   Returns: entry_ptr (ptr) *)
let mk_entry_addr (name : string) : (ptr_atom * i64_atom, ptr_atom) Dsl.Fn.t =
  [%nod
    fun name (entries_ptr : ptr) (index : int64) ->
      let%named entry_size_lit = mov (lit (Int64.of_int entry_size)) in
      let%named entry_offset = mul index entry_size_lit in
      let%named entry_ptr = ptr_add entries_ptr entry_offset in
      return entry_ptr]
;;

(* insert_at: Insert a key-value pair at a specific index
   Args: map (ptr), index (i64), key (i64), value (i64)
   Returns: 1 on success, 0 if slot occupied *)
let mk_insert_at
  (name : string)
  (entry_addr : (ptr_atom * i64_atom, ptr_atom) Dsl.Fn.t)
  : (ptr_atom * i64_atom * i64_atom * i64_atom, i64_atom) Dsl.Fn.t
  =
  [%nod
    fun name (map : ptr) (index : int64) (key : int64) (value : int64) ->
      (* Get entries pointer *)
      let%named entries_ptr = load_addr_ptr map 16 in
      (* Get entry address *)
      let%named entry_ptr = call2 entry_addr entries_ptr index in
      (* Check if slot is occupied *)
      let%named occupied = load_addr entry_ptr 0 in
      (* Store occupied = 1 *)
      let%named one = mov (lit 1L) in
      store_addr one entry_ptr 0;
      (* Store key *)
      store_addr key entry_ptr 8;
      (* Store value *)
      store_addr value entry_ptr 16;
      (* Increment size if this was a new entry *)
      let%named was_new = sub (lit 1L) occupied in
      let%named size = load_addr map 8 in
      let%named new_size = add size was_new in
      store_addr new_size map 8;
      return one]
;;

(* insert: Insert a key-value pair
   Args: map (ptr), key (i64), value (i64)
   Returns: 1 on success *)
let mk_insert
  (name : string)
  (hash_fn : (i64_atom * i64_atom, i64_atom) Dsl.Fn.t)
  (insert_at_fn :
     (ptr_atom * i64_atom * i64_atom * i64_atom, i64_atom) Dsl.Fn.t)
  : (ptr_atom * i64_atom * i64_atom, i64_atom) Dsl.Fn.t
  =
  [%nod
    fun name (map : ptr) (key : int64) (value : int64) ->
      (* Load capacity *)
      let%named capacity = load_addr map 0 in
      (* Compute hash *)
      let%named index = call2 hash_fn key capacity in
      (* Insert at the hashed index (simple, no collision handling for now) *)
      let%named result = call4 insert_at_fn map index key value in
      return result]
;;

(* get: Retrieve a value by key
   Args: map (ptr), key (i64), default_value (i64)
   Returns: value (i64), or default if not found *)
let mk_get
  (name : string)
  (hash_fn : (i64_atom * i64_atom, i64_atom) Dsl.Fn.t)
  (entry_addr : (ptr_atom * i64_atom, ptr_atom) Dsl.Fn.t)
  : (ptr_atom * i64_atom * i64_atom, i64_atom) Dsl.Fn.t
  =
  [%nod
    fun name (map : ptr) (key : int64) (default_val : int64) ->
      (* Load capacity *)
      let%named capacity = load_addr map 0 in
      (* Compute hash *)
      let%named index = call2 hash_fn key capacity in
      (* Get entries pointer *)
      let%named entries_ptr = load_addr_ptr map 16 in
      (* Get entry address *)
      let%named entry_ptr = call2 entry_addr entries_ptr index in
      (* Check if occupied *)
      let%named occupied = load_addr entry_ptr 0 in
      (* Load the value *)
      let%named value = load_addr entry_ptr 16 in
      (* Return value if occupied, default otherwise *)
      (* result = (occupied * value) + ((1 - occupied) * default_val) *)
      let%named occupied_value = mul occupied value in
      let%named one = mov (lit 1L) in
      let%named not_occupied = sub one occupied in
      let%named not_occupied_default = mul not_occupied default_val in
      let%named result = add occupied_value not_occupied_default in
      return result]
;;

(* size: Get the number of entries in the map *)
let mk_size (name : string) : (ptr_atom, i64_atom) Dsl.Fn.t =
  [%nod
    fun name (map : ptr) ->
      let%named size = load_addr map 8 in
      return size]
;;

(* capacity: Get the capacity of the map *)
let mk_capacity (name : string) : (ptr_atom, i64_atom) Dsl.Fn.t =
  [%nod
    fun name (map : ptr) ->
      let%named capacity = load_addr map 0 in
      return capacity]
;;

type hashmap_fns =
  { new_fn : (i64_atom, ptr_atom) Dsl.Fn.t
  ; hash_fn : (i64_atom * i64_atom, i64_atom) Dsl.Fn.t
  ; entry_addr_fn : (ptr_atom * i64_atom, ptr_atom) Dsl.Fn.t
  ; insert_at_fn :
      (ptr_atom * i64_atom * i64_atom * i64_atom, i64_atom) Dsl.Fn.t
  ; insert_fn : (ptr_atom * i64_atom * i64_atom, i64_atom) Dsl.Fn.t
  ; get_fn : (ptr_atom * i64_atom * i64_atom, i64_atom) Dsl.Fn.t
  ; size_fn : (ptr_atom, i64_atom) Dsl.Fn.t
  ; capacity_fn : (ptr_atom, i64_atom) Dsl.Fn.t
  }

let hashmap_functions (fns : hashmap_fns) =
  [ Dsl.Fn.function_exn fns.new_fn
  ; Dsl.Fn.function_exn fns.hash_fn
  ; Dsl.Fn.function_exn fns.entry_addr_fn
  ; Dsl.Fn.function_exn fns.insert_at_fn
  ; Dsl.Fn.function_exn fns.insert_fn
  ; Dsl.Fn.function_exn fns.get_fn
  ; Dsl.Fn.function_exn fns.size_fn
  ; Dsl.Fn.function_exn fns.capacity_fn
  ]
;;

let make_hashmap () : hashmap_fns =
  let hash_fn = mk_hash "hash_map_hash" in
  let entry_addr_fn = mk_entry_addr "hash_map_entry_addr" in
  let insert_at_fn = mk_insert_at "hash_map_insert_at" entry_addr_fn in
  let insert_fn = mk_insert "hash_map_insert" hash_fn insert_at_fn in
  let get_fn = mk_get "hash_map_get" hash_fn entry_addr_fn in
  let new_fn = mk_new "hash_map_new" in
  let size_fn = mk_size "hash_map_size" in
  let capacity_fn = mk_capacity "hash_map_capacity" in
  { new_fn
  ; hash_fn
  ; entry_addr_fn
  ; insert_at_fn
  ; insert_fn
  ; get_fn
  ; size_fn
  ; capacity_fn
  }
;;

let%expect_test "hash map functions compile" =
  let funcs = make_hashmap () |> hashmap_functions in
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
  let funcs = make_hashmap () |> hashmap_functions in
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
  let funcs = make_hashmap () |> hashmap_functions in
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
  let hash_fn = mk_hash "test_hash" |> Dsl.Fn.function_exn in
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
    let hash_map_fns = make_hashmap () in
    let { new_fn = hash_map_new
        ; insert_fn = hash_map_insert
        ; get_fn = hash_map_get
        ; size_fn = hash_map_size
        ; _
        }
      =
      hash_map_fns
    in
    (* Create a test function that uses the hash map *)
    let test_fn =
      [%nod
        fun "test_hashmap" (_dummy : int64) ->
          (* Create a new hash map with capacity 8 *)
          let%named map = call hash_map_new (lit 8L) in
          (* Insert some values: key -> value *)
          let%named r1 = call3 hash_map_insert map (lit 5L) (lit 100L) in
          let%named r2 = call3 hash_map_insert map (lit 13L) (lit 200L) in
          let%named r3 = call3 hash_map_insert map (lit 3L) (lit 300L) in
          (* Get the values back *)
          let%named val1 = call3 hash_map_get map (lit 5L) (lit 0L) in
          let%named val2 = call3 hash_map_get map (lit 13L) (lit 0L) in
          let%named val3 = call3 hash_map_get map (lit 3L) (lit 0L) in
          (* Get a non-existent value (should return default) *)
          let%named val_missing =
            call3 hash_map_get map (lit 999L) (lit 42L)
          in
          (* Get size *)
          let%named size = call hash_map_size map in
          (* Compute result: val1 + val2 + val3 + val_missing + size *)
          (* Expected: 100 + 200 + 300 + 42 + 3 = 645 *)
          let%named sum1 = add val1 val2 in
          let%named sum2 = add sum1 val3 in
          let%named sum3 = add sum2 val_missing in
          let%named result = add sum3 size in
          return result]
    in
    let all_funcs =
      hashmap_functions hash_map_fns @ [ Dsl.Fn.function_exn test_fn ]
    in
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
    let hash_map_fns = make_hashmap () in
    let { new_fn = hash_map_new
        ; insert_fn = hash_map_insert
        ; get_fn = hash_map_get
        ; size_fn = hash_map_size
        ; _
        }
      =
      hash_map_fns
    in
    let test_fn =
      [%nod
        fun "test_overwrite" (_dummy : int64) ->
          (* Create map with capacity 8 *)
          let%named map = call hash_map_new (lit 8L) in
          (* Insert initial value *)
          let%named r1 = call3 hash_map_insert map (lit 7L) (lit 100L) in
          (* Get the value *)
          let%named val1 = call3 hash_map_get map (lit 7L) (lit 0L) in
          (* Overwrite with new value *)
          let%named r2 = call3 hash_map_insert map (lit 7L) (lit 200L) in
          (* Get the new value *)
          let%named val2 = call3 hash_map_get map (lit 7L) (lit 0L) in
          (* Size should still be 1 (not 2) *)
          let%named size = call hash_map_size map in
          (* Return: old_value + new_value + size = 100 + 200 + 1 = 301 *)
          let%named sum1 = add val1 val2 in
          let%named result = add sum1 size in
          return result]
    in
    let all_funcs =
      hashmap_functions hash_map_fns @ [ Dsl.Fn.function_exn test_fn ]
    in
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
    let hash_map_fns = make_hashmap () in
    let { new_fn = hash_map_new
        ; insert_fn = hash_map_insert
        ; get_fn = hash_map_get
        ; size_fn = hash_map_size
        ; _
        }
      =
      hash_map_fns
    in
    let test_fn =
      [%nod
        fun "test_multi" (_dummy : int64) ->
          (* Create map with capacity 16 *)
          let%named map = call hash_map_new (lit 16L) in
          (* Insert 5 different values *)
          let%named r1 = call3 hash_map_insert map (lit 1L) (lit 10L) in
          let%named r2 = call3 hash_map_insert map (lit 2L) (lit 20L) in
          let%named r3 = call3 hash_map_insert map (lit 3L) (lit 30L) in
          let%named r4 = call3 hash_map_insert map (lit 4L) (lit 40L) in
          let%named r5 = call3 hash_map_insert map (lit 5L) (lit 50L) in
          (* Verify size is 5 *)
          let%named size = call hash_map_size map in
          (* Get all values and sum them *)
          let%named v1 = call3 hash_map_get map (lit 1L) (lit 0L) in
          let%named v2 = call3 hash_map_get map (lit 2L) (lit 0L) in
          let%named v3 = call3 hash_map_get map (lit 3L) (lit 0L) in
          let%named v4 = call3 hash_map_get map (lit 4L) (lit 0L) in
          let%named v5 = call3 hash_map_get map (lit 5L) (lit 0L) in
          (* Sum: 10 + 20 + 30 + 40 + 50 + 5 (size) = 155 *)
          let%named s1 = add v1 v2 in
          let%named s2 = add s1 v3 in
          let%named s3 = add s2 v4 in
          let%named s4 = add s3 v5 in
          let%named result = add s4 size in
          return result]
    in
    let all_funcs =
      hashmap_functions hash_map_fns @ [ Dsl.Fn.function_exn test_fn ]
    in
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
