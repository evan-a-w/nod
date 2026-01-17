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
    fun (state : ptr) ->
      let capacity = load_addr state 0 in
      let table = load_addr_ptr state 8 in
      let idx_slot = alloca (lit 8L) in
      seq [ store (lit 0L) idx_slot ];
      label init_loop;
      let idx = load idx_slot in
      let cond = sub idx capacity in
      seq [ branch_to cond ~if_true:"init_body" ~if_false:"init_done" ];
      label init_body;
      let offset = mul idx (lit 16L) in
      let slot = ptr_add table offset in
      seq [ store_addr (lit 0L) slot 0; store_addr (lit 0L) slot 8 ];
      let idx_next = add idx (lit 1L) in
      seq [ store idx_next idx_slot; jump_to "init_loop" ];
      label init_done;
      return (lit 0L)]
  |> Dsl.Fn.renamed ~name:"hashmap_init"
;;

let hashmap_put =
  [%nod
    fun (state : ptr) (entry : ptr) ->
      let key = load_addr entry 0 in
      let value = load_addr entry 8 in
      let capacity = load_addr state 0 in
      let table = load_addr_ptr state 8 in
      let idx0 = hash_fn key capacity in
      let idx_slot = alloca (lit 8L) in
      store idx0 idx_slot;
      label probe;
      let idx = load idx_slot in
      let offset = mul idx (lit 16L) in
      let slot = ptr_add table offset in
      let slot_key = load_addr slot 0 in
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
      store_addr key slot 0;
      store_addr value slot 8;
      return value;
      label update;
      store_addr value slot 8;
      return value]
  |> Dsl.Fn.renamed ~name:"hashmap_put"
;;

let hashmap_get =
  [%nod
    fun (state : ptr) (query : ptr) ->
      let key = load_addr query 0 in
      let default = load_addr query 8 in
      let capacity = load_addr state 0 in
      let table = load_addr_ptr state 8 in
      let idx0 = hash_fn key capacity in
      let idx_slot = alloca (lit 8L) in
      seq [ store idx0 idx_slot ];
      label probe;
      let idx = load idx_slot in
      let offset = mul idx (lit 16L) in
      let slot = ptr_add table offset in
      let slot_key = load_addr slot 0 in
      seq [ branch_to slot_key ~if_true:"check_key" ~if_false:"miss" ];
      label check_key;
      let diff = sub slot_key key in
      seq [ branch_to diff ~if_true:"probe_next" ~if_false:"hit" ];
      label probe_next;
      let idx_inc = add idx (lit 1L) in
      let idx_wrap = mod_ idx_inc capacity in
      seq [ store idx_wrap idx_slot; jump_to "probe" ];
      label hit;
      let value = load_addr slot 8 in
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
