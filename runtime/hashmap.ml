open! Core
open! Import

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
    fun (state : int64 ptr) ->
      let capacity = load state in
      let table_field = ptr_add state (lit 8L) in
      let table = load table_field in
      let table = cast "table" Type.Ptr table in
      let idx_slot = alloca (lit 8L) in
      seq [ store (lit 0L) idx_slot ];
      label init_loop;
      let idx = load idx_slot in
      let cond = sub idx capacity in
      seq [ branch_to cond ~if_true:"init_body" ~if_false:"init_done" ];
      label init_body;
      let offset = mul idx (lit 16L) in
      let slot = ptr_add table offset in
      let slot_value = ptr_add slot (lit 8L) in
      seq [ store (lit 0L) slot; store (lit 0L) slot_value ];
      let idx_next = add idx (lit 1L) in
      seq [ store idx_next idx_slot; jump_to "init_loop" ];
      label init_done;
      return (lit 0L)]
  |> Dsl.Fn.renamed ~name:"hashmap_init"
;;

let hashmap_put =
  [%nod
    fun (state : int64 ptr) (entry : int64 ptr) ->
      let key = load entry in
      let entry_value = ptr_add entry (lit 8L) in
      let value = load entry_value in
      let capacity = load state in
      let table_field = ptr_add state (lit 8L) in
      let table = load table_field in
      let table = cast "table" Type.Ptr table in
      let idx0 = hash_fn key capacity in
      let idx_slot = alloca (lit 8L) in
      store idx0 idx_slot;
      label probe;
      let idx = load idx_slot in
      let offset = mul idx (lit 16L) in
      let slot = ptr_add table offset in
      let slot_key = load slot in
      branch_to slot_key ~if_true:"check_key" ~if_false:"insert";
      label check_key;
      let diff = sub slot_key key in
      seq [ branch_to diff ~if_true:"probe_next" ~if_false:"update" ];
      label probe_next;
      let idx_inc = add idx (lit 1L) in
      let idx_wrap = mod_ idx_inc capacity in
      store idx_wrap idx_slot;
      jump_to "probe";
      label insert;
      let slot_value = ptr_add slot (lit 8L) in
      store key slot;
      store value slot_value;
      return value;
      label update;
      let slot_value = ptr_add slot (lit 8L) in
      store value slot_value;
      return value]
  |> Dsl.Fn.renamed ~name:"hashmap_put"
;;

let hashmap_get =
  [%nod
    fun (state : int64 ptr) (query : int64 ptr) ->
      let key = load query in
      let query_default = ptr_add query (lit 8L) in
      let default = load query_default in
      let capacity = load state in
      let table_field = ptr_add state (lit 8L) in
      let table = load table_field in
      let table = cast "table" Type.Ptr table in
      let idx0 = hash_fn key capacity in
      let idx_slot = alloca (lit 8L) in
      seq [ store idx0 idx_slot ];
      label probe;
      let idx = load idx_slot in
      let offset = mul idx (lit 16L) in
      let slot = ptr_add table offset in
      let slot_key = load slot in
      seq [ branch_to slot_key ~if_true:"check_key" ~if_false:"miss" ];
      label check_key;
      let diff = sub slot_key key in
      seq [ branch_to diff ~if_true:"probe_next" ~if_false:"hit" ];
      label probe_next;
      let idx_inc = add idx (lit 1L) in
      let idx_wrap = mod_ idx_inc capacity in
      seq [ store idx_wrap idx_slot; jump_to "probe" ];
      label hit;
      let slot_value = ptr_add slot (lit 8L) in
      let value = load slot_value in
      seq [ return value ];
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
