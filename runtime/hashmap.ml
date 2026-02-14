open! Core
open! Import
open! Dsl

type hashmap_entry =
  { key : int64
  ; value : int64
  }
[@@deriving nod_record]

type hashmap_query =
  { key : int64
  ; default : int64
  }
[@@deriving nod_record]

type hashmap =
  { capacity : int64
  ; table : hashmap_entry ptr
  }
[@@deriving nod_record]

let entry_bytes =
  Type.size_in_bytes (Type_repr.type_ hashmap_entry.repr) |> Int64.of_int
;;

let hash_fn =
  [%nod
    fun (key : int64) (capacity : int64) ->
      let mul_key = mul key (lit 33L) in
      let hashed = add mul_key (lit 7L) in
      let idx = mod_ hashed capacity in
      return idx]
  |> Dsl.Fn.renamed ~name:"hash"
;;

let hashmap_init =
  [%nod
    fun (state : hashmap ptr) ->
      let entry_size = mov (lit entry_bytes) in
      let capacity = load_record_field hashmap.capacity state in
      let table = load_record_field hashmap.table state in
      let idx_slot = alloca (lit 8L) in
      store (lit 0L) idx_slot;
      label init_loop;
      let idx = load idx_slot in
      let cond = sub idx capacity in
      branch_to cond ~if_true:"init_body" ~if_false:"init_done";
      label init_body;
      let offset = mul idx entry_size in
      let slot = ptr_add table offset in
      store_record_field hashmap_entry.key slot (lit 0L);
      store_record_field hashmap_entry.value slot (lit 0L);
      let idx_next = add idx (lit 1L) in
      store idx_next idx_slot;
      jump_to "init_loop";
      label init_done;
      return (lit 0L)]
  |> Dsl.Fn.renamed ~name:"hashmap_init"
;;

let hashmap_put =
  [%nod
    fun (state : hashmap ptr) (entry_ptr : hashmap_entry ptr) ->
      let entry_size = mov (lit entry_bytes) in
      let key = load_record_field hashmap_entry.key entry_ptr in
      let value = load_record_field hashmap_entry.value entry_ptr in
      let capacity = load_record_field hashmap.capacity state in
      let table = load_record_field hashmap.table state in
      let idx0 = hash_fn key capacity in
      let idx_slot = alloca (lit 8L) in
      store idx0 idx_slot;
      label probe;
      let idx = load idx_slot in
      let offset = mul idx entry_size in
      let slot = ptr_add table offset in
      let slot_key = load_record_field hashmap_entry.key slot in
      branch_to slot_key ~if_true:"check_key" ~if_false:"insert";
      label check_key;
      let diff = sub slot_key key in
      branch_to diff ~if_true:"probe_next" ~if_false:"update";
      label probe_next;
      let idx_inc = add idx (lit 1L) in
      let idx_wrap = mod_ idx_inc capacity in
      store idx_wrap idx_slot;
      jump_to "probe";
      label insert;
      store_record_field hashmap_entry.key slot key;
      store_record_field hashmap_entry.value slot value;
      return value;
      label update;
      store_record_field hashmap_entry.value slot value;
      return value]
  |> Dsl.Fn.renamed ~name:"hashmap_put"
;;

let hashmap_get =
  [%nod
    fun (state : hashmap ptr) (query_ptr : hashmap_query ptr) ->
      let entry_size = mov (lit entry_bytes) in
      let key = load_record_field hashmap_query.key query_ptr in
      let default = load_record_field hashmap_query.default query_ptr in
      let capacity = load_record_field hashmap.capacity state in
      let table = load_record_field hashmap.table state in
      let idx0 = hash_fn key capacity in
      let idx_slot = alloca (lit 8L) in
      store idx0 idx_slot;
      label probe;
      let idx = load idx_slot in
      let offset = mul idx entry_size in
      let slot = ptr_add table offset in
      let slot_key = load_record_field hashmap_entry.key slot in
      branch_to slot_key ~if_true:"check_key" ~if_false:"miss";
      label check_key;
      let diff = sub slot_key key in
      branch_to diff ~if_true:"probe_next" ~if_false:"hit";
      label probe_next;
      let idx_inc = add idx (lit 1L) in
      let idx_wrap = mod_ idx_inc capacity in
      store idx_wrap idx_slot;
      jump_to "probe";
      label hit;
      let value = load_record_field hashmap_entry.value slot in
      return value;
      label miss;
      return default]
  |> Dsl.Fn.renamed ~name:"hashmap_get"
;;

let functions =
  [ Dsl.Fn.pack hash_fn
  ; Dsl.Fn.pack hashmap_init
  ; Dsl.Fn.pack hashmap_put
  ; Dsl.Fn.pack hashmap_get
  ]
;;
