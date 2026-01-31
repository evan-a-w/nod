open! Core
open! Import

let select_instructions fn =
  let functions = String.Map.of_alist_exn [ Function.name fn, fn ] in
  let selected = X86_backend.For_testing.select_instructions functions in
  Map.find_exn selected (Function.name fn)
;;

let%expect_test "load/store select into x86 mem operands" =
  let slot = Ir.Mem.Stack_slot 0 in
  let tmp = Var.create ~name:"tmp" ~type_:Type.I64 in
  let fn_state = Fn_state.create () in
  let root =
    Block.create
      ~id_hum:"%root"
      ~terminal:
        (Fn_state.alloc_instr
           fn_state
           ~ir:(Fn_state.value_ir fn_state (Ir.return (Ir.Lit_or_var.Var tmp))))
  in
  Block.set_dfs_id root (Some 0);
  Fn_state.append_ir
    fn_state
    ~block:root
    ~ir:(Fn_state.value_ir fn_state (Ir.store (Ir.Lit_or_var.Lit 42L) slot));
  Fn_state.append_ir
    fn_state
    ~block:root
    ~ir:(Fn_state.value_ir fn_state (Ir.load tmp slot));
  let fn = Function.create ~name:"root" ~args:[] ~root in
  select_instructions fn |> Function.print_verbose;
  [%expect
    {|
    ((call_conv Default)
     (root
      ((root__prologue (args ())
        (instrs
         (((id (Instr_id 5))
           (ir (X86 (Tag_def NOOP (Reg ((reg RBP) (class_ I64)))))))
          ((id (Instr_id 10))
           (ir (X86 (JMP ((block ((id_hum %root) (args ()))) (args ())))))))))
       (%root (args ())
        (instrs
         (((id (Instr_id 1))
           (ir (X86 (MOV (Mem ((reg RBP) (class_ I64)) 0) (Imm 42)))))
          ((id (Instr_id 3))
           (ir
            (X86
             (MOV (Reg ((reg (Unallocated (Value_id 0))) (class_ I64)))
              (Mem ((reg RBP) (class_ I64)) 0)))))
          ((id (Instr_id 9))
           (ir
            (X86
             (MOV (Reg ((reg (Unallocated (Value_id 1))) (class_ I64)))
              (Reg ((reg (Unallocated (Value_id 0))) (class_ I64)))))))
          ((id (Instr_id 11))
           (ir
            (X86_terminal
             ((JMP
               ((block
                 ((id_hum root__epilogue) (args (((name res__0) (type_ I64))))))
                (args ()))))))))))
       (root__epilogue (args (((name res__0) (type_ I64))))
        (instrs
         (((id (Instr_id 7))
           (ir
            (X86
             (MOV (Reg ((reg RAX) (class_ I64)))
              (Reg ((reg (Allocated (Value_id 1) (RAX))) (class_ I64)))))))
          ((id (Instr_id 12))
           (ir
            (X86
             (RET ((Reg ((reg (Allocated (Value_id 1) (RAX))) (class_ I64)))))))))))))
     (args ()) (name root) (prologue ()) (epilogue ())
     (bytes_for_clobber_saves 0) (bytes_for_padding 0) (bytes_for_spills 0)
     (bytes_statically_alloca'd 0))
    |}]
;;
