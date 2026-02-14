open! Core
open! Import
open! Dsl
open Nod_runtime

let root =
  let instrs =
    [%nod
      let state = alloca (lit 16L) in
      let table = alloca (lit 64L) in
      let table_field = ptr_add state (lit 8L) in
      let table =
        cast
          (Type.Ptr_typed (Dsl.Type_repr.type_ Hashmap.hashmap_entry.repr))
          table
      in
      seq [ store (lit 4L) state; store table table_field ];
      let state =
        cast (Type.Ptr_typed (Dsl.Type_repr.type_ Hashmap.hashmap.repr)) state
      in
      let init_done = Hashmap.hashmap_init state in
      let entry1 = alloca (lit 16L) in
      let entry1_value = ptr_add entry1 (lit 8L) in
      seq [ store (lit 7L) entry1; store (lit 21L) entry1_value ];
      let entry1 =
        cast
          (Type.Ptr_typed (Dsl.Type_repr.type_ Hashmap.hashmap_entry.repr))
          entry1
      in
      let put1 = Hashmap.hashmap_put state entry1 in
      let entry2 = alloca (lit 16L) in
      let entry2_value = ptr_add entry2 (lit 8L) in
      seq [ store (lit 42L) entry2; store (lit 100L) entry2_value ];
      let entry2 =
        cast
          (Type.Ptr_typed (Dsl.Type_repr.type_ Hashmap.hashmap_entry.repr))
          entry2
      in
      let put2 = Hashmap.hashmap_put state entry2 in
      let query_hit = alloca (lit 16L) in
      let query_hit_value = ptr_add query_hit (lit 8L) in
      seq [ store (lit 7L) query_hit; store (lit 0L) query_hit_value ];
      let query_hit =
        cast
          (Type.Ptr_typed (Dsl.Type_repr.type_ Hashmap.hashmap_query.repr))
          query_hit
      in
      let hit = Hashmap.hashmap_get state query_hit in
      let query_miss = alloca (lit 16L) in
      let query_miss_value = ptr_add query_miss (lit 8L) in
      seq [ store (lit 99L) query_miss; store (lit 5L) query_miss_value ];
      let query_miss =
        cast
          (Type.Ptr_typed (Dsl.Type_repr.type_ Hashmap.hashmap_query.repr))
          query_miss
      in
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
  let program = Dsl.compile_program_exn' hashmap_program in
  let names = Map.keys program.Program.functions in
  print_s [%sexp (names : string list)];
  let root_fn = Map.find_exn program.Program.functions "root" in
  print_s (Function.to_sexp_verbose root_fn);
  let put_fn = Map.find_exn program.Program.functions "hashmap_put" in
  print_s (Function.to_sexp_verbose put_fn);
  [%expect {|
    (hash hashmap_get hashmap_init hashmap_put root)
    ((call_conv Default)
     (root
      ((%entry (args ())
        (instrs
         (((id (Instr_id 41))
           (ir (Alloca ((dest (Value_id 0)) (size (Lit 16))))))
          ((id (Instr_id 0)) (ir (Alloca ((dest (Value_id 1)) (size (Lit 64))))))
          ((id (Instr_id 1))
           (ir
            (Add ((dest (Value_id 2)) (src1 (Var (Value_id 0))) (src2 (Lit 8))))))
          ((id (Instr_id 2)) (ir (Cast (Value_id 23) (Var (Value_id 1)))))
          ((id (Instr_id 3))
           (ir (Store (Lit 4) (Address ((base (Var (Value_id 0))) (offset 0))))))
          ((id (Instr_id 4))
           (ir
            (Store (Var (Value_id 23))
             (Address ((base (Var (Value_id 2))) (offset 0))))))
          ((id (Instr_id 5)) (ir (Cast (Value_id 24) (Var (Value_id 0)))))
          ((id (Instr_id 6))
           (ir
            (Call (callee (Direct hashmap_init)) (results ((Value_id 5)))
             (args ((Var (Value_id 24)))))))
          ((id (Instr_id 7)) (ir (Alloca ((dest (Value_id 6)) (size (Lit 16))))))
          ((id (Instr_id 8))
           (ir
            (Add ((dest (Value_id 7)) (src1 (Var (Value_id 6))) (src2 (Lit 8))))))
          ((id (Instr_id 9))
           (ir (Store (Lit 7) (Address ((base (Var (Value_id 6))) (offset 0))))))
          ((id (Instr_id 10))
           (ir (Store (Lit 21) (Address ((base (Var (Value_id 7))) (offset 0))))))
          ((id (Instr_id 11)) (ir (Cast (Value_id 25) (Var (Value_id 6)))))
          ((id (Instr_id 12))
           (ir
            (Call (callee (Direct hashmap_put)) (results ((Value_id 9)))
             (args ((Var (Value_id 24)) (Var (Value_id 25)))))))
          ((id (Instr_id 13))
           (ir (Alloca ((dest (Value_id 10)) (size (Lit 16))))))
          ((id (Instr_id 14))
           (ir
            (Add
             ((dest (Value_id 11)) (src1 (Var (Value_id 10))) (src2 (Lit 8))))))
          ((id (Instr_id 15))
           (ir
            (Store (Lit 42) (Address ((base (Var (Value_id 10))) (offset 0))))))
          ((id (Instr_id 16))
           (ir
            (Store (Lit 100) (Address ((base (Var (Value_id 11))) (offset 0))))))
          ((id (Instr_id 17)) (ir (Cast (Value_id 26) (Var (Value_id 10)))))
          ((id (Instr_id 18))
           (ir
            (Call (callee (Direct hashmap_put)) (results ((Value_id 13)))
             (args ((Var (Value_id 24)) (Var (Value_id 26)))))))
          ((id (Instr_id 19))
           (ir (Alloca ((dest (Value_id 14)) (size (Lit 16))))))
          ((id (Instr_id 20))
           (ir
            (Add
             ((dest (Value_id 15)) (src1 (Var (Value_id 14))) (src2 (Lit 8))))))
          ((id (Instr_id 21))
           (ir (Store (Lit 7) (Address ((base (Var (Value_id 14))) (offset 0))))))
          ((id (Instr_id 22))
           (ir (Store (Lit 0) (Address ((base (Var (Value_id 15))) (offset 0))))))
          ((id (Instr_id 23)) (ir (Cast (Value_id 27) (Var (Value_id 14)))))
          ((id (Instr_id 24))
           (ir
            (Call (callee (Direct hashmap_get)) (results ((Value_id 17)))
             (args ((Var (Value_id 24)) (Var (Value_id 27)))))))
          ((id (Instr_id 25))
           (ir (Alloca ((dest (Value_id 18)) (size (Lit 16))))))
          ((id (Instr_id 26))
           (ir
            (Add
             ((dest (Value_id 19)) (src1 (Var (Value_id 18))) (src2 (Lit 8))))))
          ((id (Instr_id 27))
           (ir
            (Store (Lit 99) (Address ((base (Var (Value_id 18))) (offset 0))))))
          ((id (Instr_id 28))
           (ir (Store (Lit 5) (Address ((base (Var (Value_id 19))) (offset 0))))))
          ((id (Instr_id 29)) (ir (Cast (Value_id 28) (Var (Value_id 18)))))
          ((id (Instr_id 30))
           (ir
            (Call (callee (Direct hashmap_get)) (results ((Value_id 21)))
             (args ((Var (Value_id 24)) (Var (Value_id 28)))))))
          ((id (Instr_id 31))
           (ir
            (Add
             ((dest (Value_id 22)) (src1 (Var (Value_id 17)))
              (src2 (Var (Value_id 21)))))))
          ((id (Instr_id 32))
           (ir
            (Add
             ((dest (Value_id 29)) (src1 (Var (Value_id 22)))
              (src2 (Var (Value_id 5)))))))
          ((id (Instr_id 33))
           (ir
            (Sub
             ((dest (Value_id 30)) (src1 (Var (Value_id 29)))
              (src2 (Var (Value_id 5)))))))
          ((id (Instr_id 34))
           (ir
            (Add
             ((dest (Value_id 31)) (src1 (Var (Value_id 30)))
              (src2 (Var (Value_id 9)))))))
          ((id (Instr_id 35))
           (ir
            (Sub
             ((dest (Value_id 32)) (src1 (Var (Value_id 31)))
              (src2 (Var (Value_id 9)))))))
          ((id (Instr_id 36))
           (ir
            (Add
             ((dest (Value_id 33)) (src1 (Var (Value_id 32)))
              (src2 (Var (Value_id 13)))))))
          ((id (Instr_id 37))
           (ir
            (Sub
             ((dest (Value_id 34)) (src1 (Var (Value_id 33)))
              (src2 (Var (Value_id 13)))))))
          ((id (Instr_id 38)) (ir (Return (Var (Value_id 34))))))))))
     (args ()) (name root) (prologue ()) (epilogue ())
     (bytes_for_clobber_saves 0) (bytes_for_padding 0) (bytes_for_spills 0)
     (bytes_statically_alloca'd 0))
    ((call_conv Default)
     (root
      ((%entry
        (args
         (((name state)
           (type_ (Ptr_typed (Tuple (I64 (Ptr_typed (Tuple (I64 I64))))))))
          ((name entry_ptr) (type_ (Ptr_typed (Tuple (I64 I64)))))))
        (instrs
         (((id (Instr_id 33)) (ir (Move (Value_id 0) (Lit 16))))
          ((id (Instr_id 5))
           (ir
            (Load (Value_id 2) (Address ((base (Var (Value_id 1))) (offset 0))))))
          ((id (Instr_id 6))
           (ir
            (Load (Value_id 3) (Address ((base (Var (Value_id 1))) (offset 8))))))
          ((id (Instr_id 7))
           (ir
            (Load (Value_id 5) (Address ((base (Var (Value_id 4))) (offset 0))))))
          ((id (Instr_id 8))
           (ir
            (Load (Value_id 6) (Address ((base (Var (Value_id 4))) (offset 8))))))
          ((id (Instr_id 9))
           (ir
            (Call (callee (Direct hash)) (results ((Value_id 7)))
             (args ((Var (Value_id 2)) (Var (Value_id 5)))))))
          ((id (Instr_id 10)) (ir (Alloca ((dest (Value_id 8)) (size (Lit 8))))))
          ((id (Instr_id 11))
           (ir
            (Store (Var (Value_id 7))
             (Address ((base (Var (Value_id 8))) (offset 0))))))
          ((id (Instr_id 12))
           (ir
            (Branch
             (Uncond
              ((block
                ((id_hum probe)
                 (args
                  (((name idx) (type_ I64)) ((name slot_key) (type_ I64))
                   ((name slot) (type_ (Ptr_typed (Tuple (I64 I64)))))))))
               (args ((Value_id 9) (Value_id 12) (Value_id 11)))))))))))
       (probe
        (args
         (((name idx) (type_ I64)) ((name slot_key) (type_ I64))
          ((name slot) (type_ (Ptr_typed (Tuple (I64 I64)))))))
        (instrs
         (((id (Instr_id 34))
           (ir
            (Load (Value_id 16) (Address ((base (Var (Value_id 8))) (offset 0))))))
          ((id (Instr_id 14))
           (ir
            (Mul
             ((dest (Value_id 10)) (src1 (Var (Value_id 16)))
              (src2 (Var (Value_id 0)))))))
          ((id (Instr_id 0))
           (ir
            (Add
             ((dest (Value_id 17)) (src1 (Var (Value_id 6)))
              (src2 (Var (Value_id 10)))))))
          ((id (Instr_id 15))
           (ir
            (Load (Value_id 18)
             (Address ((base (Var (Value_id 17))) (offset 0))))))
          ((id (Instr_id 16))
           (ir
            (Branch
             (Cond (cond (Var (Value_id 18)))
              (if_true ((block ((id_hum check_key) (args ()))) (args ())))
              (if_false ((block ((id_hum insert) (args ()))) (args ()))))))))))
       (check_key (args ())
        (instrs
         (((id (Instr_id 35))
           (ir
            (Sub
             ((dest (Value_id 13)) (src1 (Var (Value_id 18)))
              (src2 (Var (Value_id 2)))))))
          ((id (Instr_id 18))
           (ir
            (Branch
             (Cond (cond (Var (Value_id 13)))
              (if_true ((block ((id_hum probe_next) (args ()))) (args ())))
              (if_false ((block ((id_hum update) (args ()))) (args ()))))))))))
       (probe_next (args ())
        (instrs
         (((id (Instr_id 36))
           (ir
            (Add
             ((dest (Value_id 14)) (src1 (Var (Value_id 16))) (src2 (Lit 1))))))
          ((id (Instr_id 19))
           (ir
            (Mod
             ((dest (Value_id 15)) (src1 (Var (Value_id 14)))
              (src2 (Var (Value_id 5)))))))
          ((id (Instr_id 2))
           (ir
            (Store (Var (Value_id 15))
             (Address ((base (Var (Value_id 8))) (offset 0))))))
          ((id (Instr_id 20))
           (ir
            (Branch
             (Uncond
              ((block
                ((id_hum probe)
                 (args
                  (((name idx) (type_ I64)) ((name slot_key) (type_ I64))
                   ((name slot) (type_ (Ptr_typed (Tuple (I64 I64)))))))))
               (args ((Value_id 16) (Value_id 18) (Value_id 17)))))))))))
       (update (args ())
        (instrs
         (((id (Instr_id 37))
           (ir
            (Store (Var (Value_id 3))
             (Address ((base (Var (Value_id 17))) (offset 8))))))
          ((id (Instr_id 22)) (ir (Return (Var (Value_id 3))))))))
       (insert (args ())
        (instrs
         (((id (Instr_id 38))
           (ir
            (Store (Var (Value_id 2))
             (Address ((base (Var (Value_id 17))) (offset 0))))))
          ((id (Instr_id 25))
           (ir
            (Store (Var (Value_id 3))
             (Address ((base (Var (Value_id 17))) (offset 8))))))
          ((id (Instr_id 3)) (ir (Return (Var (Value_id 3))))))))))
     (args
      (((name state)
        (type_ (Ptr_typed (Tuple (I64 (Ptr_typed (Tuple (I64 I64))))))))
       ((name entry_ptr) (type_ (Ptr_typed (Tuple (I64 I64)))))))
     (name hashmap_put) (prologue ()) (epilogue ()) (bytes_for_clobber_saves 0)
     (bytes_for_padding 0) (bytes_for_spills 0) (bytes_statically_alloca'd 0))
    |}]
;;

let compile_and_execute_program_exn program expected =
  List.iter test_architectures ~f:(fun arch ->
    let compiled = Dsl.compile_program_exn' program in
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
