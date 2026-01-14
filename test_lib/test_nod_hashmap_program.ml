open! Core
open! Import
open Nod_runtime

let root =
  let instrs =
    [%nod
      let%named state = alloca (lit 16L) in
      let%named table = alloca (lit 64L) in
      seq [ store_addr (lit 4L) state 0; store_addr table state 8 ];
      let%named init_done = Hashmap.hashmap_init state in
      let%named entry1 = alloca (lit 16L) in
      seq [ store_addr (lit 7L) entry1 0; store_addr (lit 21L) entry1 8 ];
      let%named put1 = Hashmap.hashmap_put state entry1 in
      let%named entry2 = alloca (lit 16L) in
      seq [ store_addr (lit 42L) entry2 0; store_addr (lit 100L) entry2 8 ];
      let%named put2 = Hashmap.hashmap_put state entry2 in
      let%named query_hit = alloca (lit 16L) in
      seq [ store_addr (lit 7L) query_hit 0; store_addr (lit 0L) query_hit 8 ];
      let%named hit = Hashmap.hashmap_get state query_hit in
      let%named query_miss = alloca (lit 16L) in
      seq
        [ store_addr (lit 99L) query_miss 0; store_addr (lit 5L) query_miss 8 ];
      let%named miss = Hashmap.hashmap_get state query_miss in
      let%named total = add hit miss in
      let%named total = add total init_done in
      let%named total = sub total init_done in
      let%named total = add total put1 in
      let%named total = sub total put1 in
      let%named total = add total put2 in
      let%named total = sub total put2 in
      return total]
  in
  let unnamed = Dsl.Fn.Unnamed.const Dsl.Type_repr.Int64 instrs in
  Dsl.Fn.create ~name:"root" ~unnamed
;;

let hashmap_program =
  Dsl.program ~functions:(Dsl.Fn.pack root :: Hashmap.functions) ~globals:[]
;;

let%expect_test "nod hashmap program compiles" =
  let program = Dsl.compile_program_exn hashmap_program in
  let names = Map.keys program.Program.functions in
  print_s [%sexp (names : string list)];
  let root_fn = Map.find_exn program.Program.functions "root" in
  print_s (Function.to_sexp_verbose root_fn);
  let put_fn = Map.find_exn program.Program.functions "hashmap_put" in
  print_s (Function.to_sexp_verbose put_fn);
  [%expect
    {|
    (hash hashmap_get hashmap_init hashmap_put root)
    ((call_conv Default)
     (root
      ((%entry (args ())
        (instrs
         ((Alloca ((dest ((name state) (type_ Ptr))) (size (Lit 16))))
          (Alloca ((dest ((name table) (type_ Ptr))) (size (Lit 64))))
          (Store (Lit 4)
           (Address ((base (Var ((name state) (type_ Ptr)))) (offset 0))))
          (Store (Var ((name table) (type_ Ptr)))
           (Address ((base (Var ((name state) (type_ Ptr)))) (offset 8))))
          (Call (fn hashmap_init) (results (((name init_done) (type_ I64))))
           (args ((Var ((name state) (type_ Ptr))))))
          (Alloca ((dest ((name entry1) (type_ Ptr))) (size (Lit 16))))
          (Store (Lit 7)
           (Address ((base (Var ((name entry1) (type_ Ptr)))) (offset 0))))
          (Store (Lit 21)
           (Address ((base (Var ((name entry1) (type_ Ptr)))) (offset 8))))
          (Call (fn hashmap_put) (results (((name put1) (type_ I64))))
           (args
            ((Var ((name state) (type_ Ptr))) (Var ((name entry1) (type_ Ptr))))))
          (Alloca ((dest ((name entry2) (type_ Ptr))) (size (Lit 16))))
          (Store (Lit 42)
           (Address ((base (Var ((name entry2) (type_ Ptr)))) (offset 0))))
          (Store (Lit 100)
           (Address ((base (Var ((name entry2) (type_ Ptr)))) (offset 8))))
          (Call (fn hashmap_put) (results (((name put2) (type_ I64))))
           (args
            ((Var ((name state) (type_ Ptr))) (Var ((name entry2) (type_ Ptr))))))
          (Alloca ((dest ((name query_hit) (type_ Ptr))) (size (Lit 16))))
          (Store (Lit 7)
           (Address ((base (Var ((name query_hit) (type_ Ptr)))) (offset 0))))
          (Store (Lit 0)
           (Address ((base (Var ((name query_hit) (type_ Ptr)))) (offset 8))))
          (Call (fn hashmap_get) (results (((name hit) (type_ I64))))
           (args
            ((Var ((name state) (type_ Ptr)))
             (Var ((name query_hit) (type_ Ptr))))))
          (Alloca ((dest ((name query_miss) (type_ Ptr))) (size (Lit 16))))
          (Store (Lit 99)
           (Address ((base (Var ((name query_miss) (type_ Ptr)))) (offset 0))))
          (Store (Lit 5)
           (Address ((base (Var ((name query_miss) (type_ Ptr)))) (offset 8))))
          (Call (fn hashmap_get) (results (((name miss) (type_ I64))))
           (args
            ((Var ((name state) (type_ Ptr)))
             (Var ((name query_miss) (type_ Ptr))))))
          (Add
           ((dest ((name total) (type_ I64)))
            (src1 (Var ((name hit) (type_ I64))))
            (src2 (Var ((name miss) (type_ I64))))))
          (Add
           ((dest ((name total%0) (type_ I64)))
            (src1 (Var ((name total) (type_ I64))))
            (src2 (Var ((name init_done) (type_ I64))))))
          (Sub
           ((dest ((name total%1) (type_ I64)))
            (src1 (Var ((name total%0) (type_ I64))))
            (src2 (Var ((name init_done) (type_ I64))))))
          (Add
           ((dest ((name total%2) (type_ I64)))
            (src1 (Var ((name total%1) (type_ I64))))
            (src2 (Var ((name put1) (type_ I64))))))
          (Sub
           ((dest ((name total%3) (type_ I64)))
            (src1 (Var ((name total%2) (type_ I64))))
            (src2 (Var ((name put1) (type_ I64))))))
          (Add
           ((dest ((name total%4) (type_ I64)))
            (src1 (Var ((name total%3) (type_ I64))))
            (src2 (Var ((name put2) (type_ I64))))))
          (Sub
           ((dest ((name total%5) (type_ I64)))
            (src1 (Var ((name total%4) (type_ I64))))
            (src2 (Var ((name put2) (type_ I64))))))
          (Return (Var ((name total%5) (type_ I64)))))))))
     (args ()) (name root) (prologue ()) (epilogue ())
     (bytes_for_clobber_saves 0) (bytes_for_padding 0) (bytes_for_spills 0)
     (bytes_statically_alloca'd 0))
    ((call_conv Default)
     (root
      ((%entry (args (((name state) (type_ Ptr)) ((name entry) (type_ Ptr))))
        (instrs
         ((Load ((name key) (type_ I64))
           (Address ((base (Var ((name entry) (type_ Ptr)))) (offset 0))))
          (Load ((name value) (type_ I64))
           (Address ((base (Var ((name entry) (type_ Ptr)))) (offset 8))))
          (Load ((name capacity) (type_ I64))
           (Address ((base (Var ((name state) (type_ Ptr)))) (offset 0))))
          (Load ((name table) (type_ Ptr))
           (Address ((base (Var ((name state) (type_ Ptr)))) (offset 8))))
          (Call (fn hash) (results (((name idx0) (type_ I64))))
           (args
            ((Var ((name key) (type_ I64))) (Var ((name capacity) (type_ I64))))))
          (Alloca ((dest ((name idx_slot) (type_ Ptr))) (size (Lit 8))))
          (Store (Var ((name idx0) (type_ I64)))
           (Address ((base (Var ((name idx_slot) (type_ Ptr)))) (offset 0))))
          (Branch
           (Uncond
            ((block
              ((id_hum probe)
               (args
                (((name idx) (type_ I64)) ((name slot) (type_ Ptr))
                 ((name slot_key) (type_ I64))))))
             (args
              (((name idx) (type_ I64)) ((name slot) (type_ Ptr))
               ((name slot_key) (type_ I64))))))))))
       (probe
        (args
         (((name idx) (type_ I64)) ((name slot) (type_ Ptr))
          ((name slot_key) (type_ I64))))
        (instrs
         ((Load ((name idx%0) (type_ I64))
           (Address ((base (Var ((name idx_slot) (type_ Ptr)))) (offset 0))))
          (Mul
           ((dest ((name offset) (type_ I64)))
            (src1 (Var ((name idx%0) (type_ I64)))) (src2 (Lit 16))))
          (Add
           ((dest ((name slot%0) (type_ Ptr)))
            (src1 (Var ((name table) (type_ Ptr))))
            (src2 (Var ((name offset) (type_ I64))))))
          (Load ((name slot_key%0) (type_ I64))
           (Address ((base (Var ((name slot%0) (type_ Ptr)))) (offset 0))))
          (Branch
           (Cond (cond (Var ((name slot_key%0) (type_ I64))))
            (if_true ((block ((id_hum check_key) (args ()))) (args ())))
            (if_false ((block ((id_hum insert) (args ()))) (args ()))))))))
       (check_key (args ())
        (instrs
         ((Sub
           ((dest ((name diff) (type_ I64)))
            (src1 (Var ((name slot_key%0) (type_ I64))))
            (src2 (Var ((name key) (type_ I64))))))
          (Branch
           (Cond (cond (Var ((name diff) (type_ I64))))
            (if_true ((block ((id_hum probe_next) (args ()))) (args ())))
            (if_false ((block ((id_hum update) (args ()))) (args ()))))))))
       (probe_next (args ())
        (instrs
         ((Add
           ((dest ((name idx_inc) (type_ I64)))
            (src1 (Var ((name idx%0) (type_ I64)))) (src2 (Lit 1))))
          (Mod
           ((dest ((name idx_wrap) (type_ I64)))
            (src1 (Var ((name idx_inc) (type_ I64))))
            (src2 (Var ((name capacity) (type_ I64))))))
          (Store (Var ((name idx_wrap) (type_ I64)))
           (Address ((base (Var ((name idx_slot) (type_ Ptr)))) (offset 0))))
          (Branch
           (Uncond
            ((block
              ((id_hum probe)
               (args
                (((name idx) (type_ I64)) ((name slot) (type_ Ptr))
                 ((name slot_key) (type_ I64))))))
             (args
              (((name idx%0) (type_ I64)) ((name slot%0) (type_ Ptr))
               ((name slot_key%0) (type_ I64))))))))))
       (update (args ())
        (instrs
         ((Store (Var ((name value) (type_ I64)))
           (Address ((base (Var ((name slot%0) (type_ Ptr)))) (offset 8))))
          (Return (Var ((name value) (type_ I64)))))))
       (insert (args ())
        (instrs
         ((Store (Var ((name key) (type_ I64)))
           (Address ((base (Var ((name slot%0) (type_ Ptr)))) (offset 0))))
          (Store (Var ((name value) (type_ I64)))
           (Address ((base (Var ((name slot%0) (type_ Ptr)))) (offset 8))))
          (Return (Var ((name value) (type_ I64)))))))))
     (args (((name state) (type_ Ptr)) ((name entry) (type_ Ptr))))
     (name hashmap_put) (prologue ()) (epilogue ()) (bytes_for_clobber_saves 0)
     (bytes_for_padding 0) (bytes_for_spills 0) (bytes_statically_alloca'd 0))
    |}]
;;

let compile_and_execute_program_exn program expected =
  List.iter test_architectures ~f:(fun arch ->
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

let%expect_test "nod hashmap program executes" =
  compile_and_execute_program_exn hashmap_program "26";
  [%expect {| |}]
;;
