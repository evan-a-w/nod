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
  let program = Dsl.compile_program_exn' hashmap_program in
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
           (ir (Alloca ((dest (Value_id 0)) (size (Lit 16))))))
          ((id (Instr_id 0)) (ir (Alloca ((dest (Value_id 1)) (size (Lit 64))))))
          ((id (Instr_id 1))
           (ir (Store (Lit 4) (Address ((base (Var (Value_id 0))) (offset 0))))))
          ((id (Instr_id 2))
           (ir
            (Store (Var (Value_id 1))
             (Address ((base (Var (Value_id 0))) (offset 8))))))
          ((id (Instr_id 3))
           (ir
            (Call (callee (Direct hashmap_init)) (results ((Value_id 2)))
             (args ((Var (Value_id 0)))))))
          ((id (Instr_id 4)) (ir (Alloca ((dest (Value_id 3)) (size (Lit 16))))))
          ((id (Instr_id 5))
           (ir (Store (Lit 7) (Address ((base (Var (Value_id 3))) (offset 0))))))
          ((id (Instr_id 6))
           (ir (Store (Lit 21) (Address ((base (Var (Value_id 3))) (offset 8))))))
          ((id (Instr_id 7))
           (ir
            (Call (callee (Direct hashmap_put)) (results ((Value_id 4)))
             (args ((Var (Value_id 0)) (Var (Value_id 3)))))))
          ((id (Instr_id 8)) (ir (Alloca ((dest (Value_id 5)) (size (Lit 16))))))
          ((id (Instr_id 9))
           (ir (Store (Lit 42) (Address ((base (Var (Value_id 5))) (offset 0))))))
          ((id (Instr_id 10))
           (ir
            (Store (Lit 100) (Address ((base (Var (Value_id 5))) (offset 8))))))
          ((id (Instr_id 11))
           (ir
            (Call (callee (Direct hashmap_put)) (results ((Value_id 6)))
             (args ((Var (Value_id 0)) (Var (Value_id 5)))))))
          ((id (Instr_id 12))
           (ir (Alloca ((dest (Value_id 7)) (size (Lit 16))))))
          ((id (Instr_id 13))
           (ir (Store (Lit 7) (Address ((base (Var (Value_id 7))) (offset 0))))))
          ((id (Instr_id 14))
           (ir (Store (Lit 0) (Address ((base (Var (Value_id 7))) (offset 8))))))
          ((id (Instr_id 15))
           (ir
            (Call (callee (Direct hashmap_get)) (results ((Value_id 8)))
             (args ((Var (Value_id 0)) (Var (Value_id 7)))))))
          ((id (Instr_id 16))
           (ir (Alloca ((dest (Value_id 9)) (size (Lit 16))))))
          ((id (Instr_id 17))
           (ir (Store (Lit 99) (Address ((base (Var (Value_id 9))) (offset 0))))))
          ((id (Instr_id 18))
           (ir (Store (Lit 5) (Address ((base (Var (Value_id 9))) (offset 8))))))
          ((id (Instr_id 19))
           (ir
            (Call (callee (Direct hashmap_get)) (results ((Value_id 10)))
             (args ((Var (Value_id 0)) (Var (Value_id 9)))))))
          ((id (Instr_id 20))
           (ir
            (Add
             ((dest (Value_id 11)) (src1 (Var (Value_id 8)))
              (src2 (Var (Value_id 10)))))))
          ((id (Instr_id 21))
           (ir
            (Add
             ((dest (Value_id 12)) (src1 (Var (Value_id 11)))
              (src2 (Var (Value_id 2)))))))
          ((id (Instr_id 22))
           (ir
            (Sub
             ((dest (Value_id 13)) (src1 (Var (Value_id 12)))
              (src2 (Var (Value_id 2)))))))
          ((id (Instr_id 23))
           (ir
            (Add
             ((dest (Value_id 14)) (src1 (Var (Value_id 13)))
              (src2 (Var (Value_id 4)))))))
          ((id (Instr_id 24))
           (ir
            (Sub
             ((dest (Value_id 15)) (src1 (Var (Value_id 14)))
              (src2 (Var (Value_id 4)))))))
          ((id (Instr_id 25))
           (ir
            (Add
             ((dest (Value_id 16)) (src1 (Var (Value_id 15)))
              (src2 (Var (Value_id 6)))))))
          ((id (Instr_id 26))
           (ir
            (Sub
             ((dest (Value_id 17)) (src1 (Var (Value_id 16)))
              (src2 (Var (Value_id 6)))))))
          ((id (Instr_id 27)) (ir (Return (Var (Value_id 17))))))))))
     (args ()) (name root) (prologue ()) (epilogue ())
     (bytes_for_clobber_saves 0) (bytes_for_padding 0) (bytes_for_spills 0)
     (bytes_statically_alloca'd 0))
    ((call_conv Default)
     (root
      ((%entry (args (((name state) (type_ Ptr)) ((name entry) (type_ Ptr))))
        (instrs
         (((id (Instr_id 32))
           (ir
            (Load (Value_id 1) (Address ((base (Var (Value_id 0))) (offset 0))))))
          ((id (Instr_id 5))
           (ir
            (Load (Value_id 2) (Address ((base (Var (Value_id 0))) (offset 8))))))
          ((id (Instr_id 6))
           (ir
            (Load (Value_id 4) (Address ((base (Var (Value_id 3))) (offset 0))))))
          ((id (Instr_id 7))
           (ir
            (Load (Value_id 5) (Address ((base (Var (Value_id 3))) (offset 8))))))
          ((id (Instr_id 8))
           (ir
            (Call (callee (Direct hash)) (results ((Value_id 6)))
             (args ((Var (Value_id 1)) (Var (Value_id 4)))))))
          ((id (Instr_id 9)) (ir (Alloca ((dest (Value_id 7)) (size (Lit 8))))))
          ((id (Instr_id 10))
           (ir
            (Store (Var (Value_id 6))
             (Address ((base (Var (Value_id 7))) (offset 0))))))
          ((id (Instr_id 11))
           (ir
            (Branch
             (Uncond
              ((block
                ((id_hum probe)
                 (args
                  (((name idx) (type_ I64)) ((name slot) (type_ Ptr))
                   ((name slot_key) (type_ I64))))))
               (args ((Value_id 8) (Value_id 10) (Value_id 11)))))))))))
       (probe
        (args
         (((name idx) (type_ I64)) ((name slot) (type_ Ptr))
          ((name slot_key) (type_ I64))))
        (instrs
         (((id (Instr_id 33))
           (ir
            (Load (Value_id 15) (Address ((base (Var (Value_id 7))) (offset 0))))))
          ((id (Instr_id 13))
           (ir
            (Mul
             ((dest (Value_id 9)) (src1 (Var (Value_id 15))) (src2 (Lit 16))))))
          ((id (Instr_id 0))
           (ir
            (Add
             ((dest (Value_id 16)) (src1 (Var (Value_id 5)))
              (src2 (Var (Value_id 9)))))))
          ((id (Instr_id 14))
           (ir
            (Load (Value_id 17)
             (Address ((base (Var (Value_id 16))) (offset 0))))))
          ((id (Instr_id 15))
           (ir
            (Branch
             (Cond (cond (Var (Value_id 17)))
              (if_true ((block ((id_hum check_key) (args ()))) (args ())))
              (if_false ((block ((id_hum insert) (args ()))) (args ()))))))))))
       (check_key (args ())
        (instrs
         (((id (Instr_id 34))
           (ir
            (Sub
             ((dest (Value_id 12)) (src1 (Var (Value_id 17)))
              (src2 (Var (Value_id 1)))))))
          ((id (Instr_id 17))
           (ir
            (Branch
             (Cond (cond (Var (Value_id 12)))
              (if_true ((block ((id_hum probe_next) (args ()))) (args ())))
              (if_false ((block ((id_hum update) (args ()))) (args ()))))))))))
       (probe_next (args ())
        (instrs
         (((id (Instr_id 35))
           (ir
            (Add
             ((dest (Value_id 13)) (src1 (Var (Value_id 15))) (src2 (Lit 1))))))
          ((id (Instr_id 18))
           (ir
            (Mod
             ((dest (Value_id 14)) (src1 (Var (Value_id 13)))
              (src2 (Var (Value_id 4)))))))
          ((id (Instr_id 2))
           (ir
            (Store (Var (Value_id 14))
             (Address ((base (Var (Value_id 7))) (offset 0))))))
          ((id (Instr_id 19))
           (ir
            (Branch
             (Uncond
              ((block
                ((id_hum probe)
                 (args
                  (((name idx) (type_ I64)) ((name slot) (type_ Ptr))
                   ((name slot_key) (type_ I64))))))
               (args ((Value_id 15) (Value_id 16) (Value_id 17)))))))))))
       (update (args ())
        (instrs
         (((id (Instr_id 36))
           (ir
            (Store (Var (Value_id 2))
             (Address ((base (Var (Value_id 16))) (offset 8))))))
          ((id (Instr_id 21)) (ir (Return (Var (Value_id 2))))))))
       (insert (args ())
        (instrs
         (((id (Instr_id 37))
           (ir
            (Store (Var (Value_id 1))
             (Address ((base (Var (Value_id 16))) (offset 0))))))
          ((id (Instr_id 24))
           (ir
            (Store (Var (Value_id 2))
             (Address ((base (Var (Value_id 16))) (offset 8))))))
          ((id (Instr_id 3)) (ir (Return (Var (Value_id 2))))))))))
     (args (((name state) (type_ Ptr)) ((name entry) (type_ Ptr))))
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
