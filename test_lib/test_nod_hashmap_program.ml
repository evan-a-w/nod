open! Core
open! Import
open Nod_runtime

let root =
  let instrs =
    [%nod
      let state = alloca (lit 16L) in
      let table = alloca (lit 64L) in
      seq [ store_addr (lit 4L) state 0; store_addr table state 8 ];
      let init_done = Hashmap.hashmap_init state in
      let entry1 = alloca (lit 16L) in
      seq [ store_addr (lit 7L) entry1 0; store_addr (lit 21L) entry1 8 ];
      let put1 = Hashmap.hashmap_put state entry1 in
      let entry2 = alloca (lit 16L) in
      seq [ store_addr (lit 42L) entry2 0; store_addr (lit 100L) entry2 8 ];
      let put2 = Hashmap.hashmap_put state entry2 in
      let query_hit = alloca (lit 16L) in
      seq [ store_addr (lit 7L) query_hit 0; store_addr (lit 0L) query_hit 8 ];
      let hit = Hashmap.hashmap_get state query_hit in
      let query_miss = alloca (lit 16L) in
      seq
        [ store_addr (lit 99L) query_miss 0; store_addr (lit 5L) query_miss 8 ];
      let miss = Hashmap.hashmap_get state query_miss in
      let total = add hit miss in
      let total = add total init_done in
      let total = sub total init_done in
      let total = add total put1 in
      let total = sub total put1 in
      let total = add total put2 in
      let total = sub total put2 in
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
         (((id (Instr_id 30))
           (ir (Alloca ((dest ((name state) (type_ Ptr))) (size (Lit 16))))))
          ((id (Instr_id 0))
           (ir (Alloca ((dest ((name table) (type_ Ptr))) (size (Lit 64))))))
          ((id (Instr_id 1))
           (ir
            (Store (Lit 4)
             (Address ((base (Var ((name state) (type_ Ptr)))) (offset 0))))))
          ((id (Instr_id 2))
           (ir
            (Store (Var ((name table) (type_ Ptr)))
             (Address ((base (Var ((name state) (type_ Ptr)))) (offset 8))))))
          ((id (Instr_id 3))
           (ir
            (Call (fn hashmap_init) (results (((name init_done) (type_ I64))))
             (args ((Var ((name state) (type_ Ptr))))))))
          ((id (Instr_id 4))
           (ir (Alloca ((dest ((name entry1) (type_ Ptr))) (size (Lit 16))))))
          ((id (Instr_id 5))
           (ir
            (Store (Lit 7)
             (Address ((base (Var ((name entry1) (type_ Ptr)))) (offset 0))))))
          ((id (Instr_id 6))
           (ir
            (Store (Lit 21)
             (Address ((base (Var ((name entry1) (type_ Ptr)))) (offset 8))))))
          ((id (Instr_id 7))
           (ir
            (Call (fn hashmap_put) (results (((name put1) (type_ I64))))
             (args
              ((Var ((name state) (type_ Ptr)))
               (Var ((name entry1) (type_ Ptr))))))))
          ((id (Instr_id 8))
           (ir (Alloca ((dest ((name entry2) (type_ Ptr))) (size (Lit 16))))))
          ((id (Instr_id 9))
           (ir
            (Store (Lit 42)
             (Address ((base (Var ((name entry2) (type_ Ptr)))) (offset 0))))))
          ((id (Instr_id 10))
           (ir
            (Store (Lit 100)
             (Address ((base (Var ((name entry2) (type_ Ptr)))) (offset 8))))))
          ((id (Instr_id 11))
           (ir
            (Call (fn hashmap_put) (results (((name put2) (type_ I64))))
             (args
              ((Var ((name state) (type_ Ptr)))
               (Var ((name entry2) (type_ Ptr))))))))
          ((id (Instr_id 12))
           (ir (Alloca ((dest ((name query_hit) (type_ Ptr))) (size (Lit 16))))))
          ((id (Instr_id 13))
           (ir
            (Store (Lit 7)
             (Address ((base (Var ((name query_hit) (type_ Ptr)))) (offset 0))))))
          ((id (Instr_id 14))
           (ir
            (Store (Lit 0)
             (Address ((base (Var ((name query_hit) (type_ Ptr)))) (offset 8))))))
          ((id (Instr_id 15))
           (ir
            (Call (fn hashmap_get) (results (((name hit) (type_ I64))))
             (args
              ((Var ((name state) (type_ Ptr)))
               (Var ((name query_hit) (type_ Ptr))))))))
          ((id (Instr_id 16))
           (ir (Alloca ((dest ((name query_miss) (type_ Ptr))) (size (Lit 16))))))
          ((id (Instr_id 17))
           (ir
            (Store (Lit 99)
             (Address ((base (Var ((name query_miss) (type_ Ptr)))) (offset 0))))))
          ((id (Instr_id 18))
           (ir
            (Store (Lit 5)
             (Address ((base (Var ((name query_miss) (type_ Ptr)))) (offset 8))))))
          ((id (Instr_id 19))
           (ir
            (Call (fn hashmap_get) (results (((name miss) (type_ I64))))
             (args
              ((Var ((name state) (type_ Ptr)))
               (Var ((name query_miss) (type_ Ptr))))))))
          ((id (Instr_id 20))
           (ir
            (Add
             ((dest ((name total) (type_ I64)))
              (src1 (Var ((name hit) (type_ I64))))
              (src2 (Var ((name miss) (type_ I64))))))))
          ((id (Instr_id 21))
           (ir
            (Add
             ((dest ((name total%0) (type_ I64)))
              (src1 (Var ((name total) (type_ I64))))
              (src2 (Var ((name init_done) (type_ I64))))))))
          ((id (Instr_id 22))
           (ir
            (Sub
             ((dest ((name total%1) (type_ I64)))
              (src1 (Var ((name total%0) (type_ I64))))
              (src2 (Var ((name init_done) (type_ I64))))))))
          ((id (Instr_id 23))
           (ir
            (Add
             ((dest ((name total%2) (type_ I64)))
              (src1 (Var ((name total%1) (type_ I64))))
              (src2 (Var ((name put1) (type_ I64))))))))
          ((id (Instr_id 24))
           (ir
            (Sub
             ((dest ((name total%3) (type_ I64)))
              (src1 (Var ((name total%2) (type_ I64))))
              (src2 (Var ((name put1) (type_ I64))))))))
          ((id (Instr_id 25))
           (ir
            (Add
             ((dest ((name total%4) (type_ I64)))
              (src1 (Var ((name total%3) (type_ I64))))
              (src2 (Var ((name put2) (type_ I64))))))))
          ((id (Instr_id 26))
           (ir
            (Sub
             ((dest ((name total%5) (type_ I64)))
              (src1 (Var ((name total%4) (type_ I64))))
              (src2 (Var ((name put2) (type_ I64))))))))
          ((id (Instr_id 27)) (ir (Return (Var ((name total%5) (type_ I64)))))))))))
     (args ()) (name root) (prologue ()) (epilogue ())
     (bytes_for_clobber_saves 0) (bytes_for_padding 0) (bytes_for_spills 0)
     (bytes_statically_alloca'd 0))
    ((call_conv Default)
     (root
      ((%entry (args (((name state) (type_ Ptr)) ((name entry) (type_ Ptr))))
        (instrs
         (((id (Instr_id 32))
           (ir
            (Load ((name key) (type_ I64))
             (Address ((base (Var ((name entry) (type_ Ptr)))) (offset 0))))))
          ((id (Instr_id 5))
           (ir
            (Load ((name value) (type_ I64))
             (Address ((base (Var ((name entry) (type_ Ptr)))) (offset 8))))))
          ((id (Instr_id 6))
           (ir
            (Load ((name capacity) (type_ I64))
             (Address ((base (Var ((name state) (type_ Ptr)))) (offset 0))))))
          ((id (Instr_id 7))
           (ir
            (Load ((name table) (type_ Ptr))
             (Address ((base (Var ((name state) (type_ Ptr)))) (offset 8))))))
          ((id (Instr_id 8))
           (ir
            (Call (fn hash) (results (((name idx0) (type_ I64))))
             (args
              ((Var ((name key) (type_ I64)))
               (Var ((name capacity) (type_ I64))))))))
          ((id (Instr_id 9))
           (ir (Alloca ((dest ((name idx_slot) (type_ Ptr))) (size (Lit 8))))))
          ((id (Instr_id 10))
           (ir
            (Store (Var ((name idx0) (type_ I64)))
             (Address ((base (Var ((name idx_slot) (type_ Ptr)))) (offset 0))))))
          ((id (Instr_id 11))
           (ir
            (Branch
             (Uncond
              ((block
                ((id_hum probe)
                 (args
                  (((name idx) (type_ I64)) ((name slot) (type_ Ptr))
                   ((name slot_key) (type_ I64))))))
               (args
                (((name idx) (type_ I64)) ((name slot) (type_ Ptr))
                 ((name slot_key) (type_ I64))))))))))))
       (probe
        (args
         (((name idx) (type_ I64)) ((name slot) (type_ Ptr))
          ((name slot_key) (type_ I64))))
        (instrs
         (((id (Instr_id 33))
           (ir
            (Load ((name idx%0) (type_ I64))
             (Address ((base (Var ((name idx_slot) (type_ Ptr)))) (offset 0))))))
          ((id (Instr_id 13))
           (ir
            (Mul
             ((dest ((name offset) (type_ I64)))
              (src1 (Var ((name idx%0) (type_ I64)))) (src2 (Lit 16))))))
          ((id (Instr_id 0))
           (ir
            (Add
             ((dest ((name slot%0) (type_ Ptr)))
              (src1 (Var ((name table) (type_ Ptr))))
              (src2 (Var ((name offset) (type_ I64))))))))
          ((id (Instr_id 14))
           (ir
            (Load ((name slot_key%0) (type_ I64))
             (Address ((base (Var ((name slot%0) (type_ Ptr)))) (offset 0))))))
          ((id (Instr_id 15))
           (ir
            (Branch
             (Cond (cond (Var ((name slot_key%0) (type_ I64))))
              (if_true ((block ((id_hum check_key) (args ()))) (args ())))
              (if_false ((block ((id_hum insert) (args ()))) (args ()))))))))))
       (check_key (args ())
        (instrs
         (((id (Instr_id 34))
           (ir
            (Sub
             ((dest ((name diff) (type_ I64)))
              (src1 (Var ((name slot_key%0) (type_ I64))))
              (src2 (Var ((name key) (type_ I64))))))))
          ((id (Instr_id 17))
           (ir
            (Branch
             (Cond (cond (Var ((name diff) (type_ I64))))
              (if_true ((block ((id_hum probe_next) (args ()))) (args ())))
              (if_false ((block ((id_hum update) (args ()))) (args ()))))))))))
       (probe_next (args ())
        (instrs
         (((id (Instr_id 35))
           (ir
            (Add
             ((dest ((name idx_inc) (type_ I64)))
              (src1 (Var ((name idx%0) (type_ I64)))) (src2 (Lit 1))))))
          ((id (Instr_id 18))
           (ir
            (Mod
             ((dest ((name idx_wrap) (type_ I64)))
              (src1 (Var ((name idx_inc) (type_ I64))))
              (src2 (Var ((name capacity) (type_ I64))))))))
          ((id (Instr_id 2))
           (ir
            (Store (Var ((name idx_wrap) (type_ I64)))
             (Address ((base (Var ((name idx_slot) (type_ Ptr)))) (offset 0))))))
          ((id (Instr_id 19))
           (ir
            (Branch
             (Uncond
              ((block
                ((id_hum probe)
                 (args
                  (((name idx) (type_ I64)) ((name slot) (type_ Ptr))
                   ((name slot_key) (type_ I64))))))
               (args
                (((name idx%0) (type_ I64)) ((name slot%0) (type_ Ptr))
                 ((name slot_key%0) (type_ I64))))))))))))
       (update (args ())
        (instrs
         (((id (Instr_id 36))
           (ir
            (Store (Var ((name value) (type_ I64)))
             (Address ((base (Var ((name slot%0) (type_ Ptr)))) (offset 8))))))
          ((id (Instr_id 21)) (ir (Return (Var ((name value) (type_ I64)))))))))
       (insert (args ())
        (instrs
         (((id (Instr_id 37))
           (ir
            (Store (Var ((name key) (type_ I64)))
             (Address ((base (Var ((name slot%0) (type_ Ptr)))) (offset 0))))))
          ((id (Instr_id 24))
           (ir
            (Store (Var ((name value) (type_ I64)))
             (Address ((base (Var ((name slot%0) (type_ Ptr)))) (offset 8))))))
          ((id (Instr_id 3)) (ir (Return (Var ((name value) (type_ I64)))))))))))
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
