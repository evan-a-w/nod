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
  let root =
    Block.create ~id_hum:"%root" ~terminal:(Ir.return (Ir.Lit_or_var.Var tmp))
  in
  root.dfs_id <- Some 0;
  Vec.push root.instructions (Ir.store (Ir.Lit_or_var.Lit 42L) slot);
  Vec.push root.instructions (Ir.load tmp slot);
  let fn = Function.create ~name:"root" ~args:[] ~root in
  select_instructions fn |> Function.print_verbose;
  [%expect
    {|
    ((call_conv Default)
     (root
      ((root__prologue (args ())
        (instrs
         ((X86 (Tag_def NOOP (Reg ((reg RBP) (class_ I64)))))
          (X86 (JMP ((block ((id_hum %root) (args ()))) (args ())))))))
       (%root (args ())
        (instrs
         ((X86 (MOV (Mem ((reg RBP) (class_ I64)) 0) (Imm 42)))
          (X86
           (MOV (Reg ((reg (Unallocated ((name tmp) (type_ I64)))) (class_ I64)))
            (Mem ((reg RBP) (class_ I64)) 0)))
          (X86
           (MOV
            (Reg ((reg (Unallocated ((name res__0) (type_ I64)))) (class_ I64)))
            (Reg ((reg (Unallocated ((name tmp) (type_ I64)))) (class_ I64)))))
          (X86_terminal
           ((JMP
             ((block
               ((id_hum root__epilogue) (args (((name res__0) (type_ I64))))))
              (args ()))))))))
       (root__epilogue (args (((name res__0) (type_ I64))))
        (instrs
         ((X86
           (MOV (Reg ((reg RAX) (class_ I64)))
            (Reg
             ((reg (Allocated ((name res__0) (type_ I64)) (RAX))) (class_ I64)))))
          (X86
           (RET
            ((Reg
              ((reg (Allocated ((name res__0) (type_ I64)) (RAX))) (class_ I64)))))))))))
     (args ()) (name root) (prologue ()) (epilogue ()) (bytes_alloca'd 0)
     (bytes_for_spills 0) (bytes_for_clobber_saves 0))
    |}]
;;
