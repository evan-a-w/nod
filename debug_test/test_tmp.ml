open! Core
open! Import

let map_function_roots ~f functions =
  Map.map ~f:(Function.map_root ~f) functions
;;

let test_cfg s =
  s
  |> Parser.parse_string
  |> Result.map ~f:(map_function_roots ~f:Cfg.process)
  |> function
  | Error e -> Nod_error.to_string e |> print_endline
  | Ok fns ->
    Map.iter
      fns
      ~f:(fun { Function.root = ~root:_, ~blocks:_, ~in_order:blocks; _ } ->
        Vec.iter blocks ~f:(fun block ->
          let instrs =
            Vec.to_list block.Block.instructions @ [ block.terminal ]
          in
          print_s [%message block.id_hum (instrs : Ir.t list)]))
;;

let test_ssa ?don't_opt s =
  test_cfg s;
  print_endline "=================================";
  Parser.parse_string s
  |> Result.map ~f:(map_function_roots ~f:Cfg.process)
  |> Result.map ~f:Eir.set_entry_block_args
  |> Result.map ~f:(map_function_roots ~f:Ssa.create)
  |> function
  | Error e -> Nod_error.to_string e |> print_endline
  | Ok fns ->
    let go fns =
      Map.iter fns ~f:(fun { Function.root = (ssa : Ssa.t); _ } ->
        Vec.iter ssa.in_order ~f:(fun block ->
          let instrs = Vec.to_list block.instructions @ [ block.terminal ] in
          print_s
            [%message
              block.id_hum ~args:(block.args : Var.t Vec.t) (instrs : Ir.t list)]))
    in
    go fns;
    (match don't_opt with
     | Some () -> ()
     | None ->
       print_endline "******************************";
       Eir.optimize fns;
       go fns)
;;

let assert_execution
  ?harness
  ?(opt_flags = Eir.Opt_flags.no_opt)
  program
  expected
  =
  List.iter test_architectures ~f:(fun arch ->
    let output = compile_and_execute_on_arch arch ?harness ~opt_flags program in
    if not (String.equal output expected)
    then
      failwithf
        "arch %s produced %s, expected %s"
        (arch_to_string arch)
        output
        expected
        ())
;;

let%expect_test "alloca passed to child; child loads value" =
  let make_fn ~name ~args ~root =
    (* Mirror [Eir.set_entry_block_args] for hand-constructed CFGs. *)
    List.iter args ~f:(Vec.push root.Block.args);
    root.dfs_id <- Some 0;
    Function.create ~name ~args ~root
  in
  let execute_functions
    ?(arch = `X86_64)
    ?(harness = Nod.make_harness_source ())
    functions
    =
    let asm =
      Nod.compile_and_lower_functions ~arch ~system:host_system functions
    in
    Nod.execute_asm ~arch ~system:host_system ~harness asm
  in
  let run_functions ?harness mk_functions expected =
    List.iter test_architectures ~f:(function
      | (`X86_64 | `Arm64) as arch ->
        let functions = mk_functions arch in
        let output = execute_functions ~arch ?harness functions in
        if not (String.equal output expected)
        then
          failwithf
            "arch %s produced %s, expected %s"
            (arch_to_string arch)
            output
            expected
            ()
      | `Other -> ())
  in
  let mk_functions (_arch : [ `X86_64 | `Arm64 ]) =
    let p = Var.create ~name:"p" ~type_:Type.Ptr in
    let loaded = Var.create ~name:"loaded" ~type_:Type.I64 in
    let child_root =
      Block.create
        ~id_hum:"%root"
        ~terminal:(Ir.return (Ir.Lit_or_var.Var loaded))
    in
    Vec.push
      child_root.instructions
      (Ir.load loaded (Ir.Mem.address (Ir.Lit_or_var.Var p)));
    let child = make_fn ~name:"child" ~args:[ p ] ~root:child_root in
    let slot = Var.create ~name:"slot" ~type_:Type.Ptr in
    let res = Var.create ~name:"res" ~type_:Type.I64 in
    let root_root =
      Block.create ~id_hum:"%root" ~terminal:(Ir.return (Ir.Lit_or_var.Var res))
    in
    Vec.push
      root_root.instructions
      (Ir.alloca { dest = slot; size = Ir.Lit_or_var.Lit 8L });
    Vec.push
      root_root.instructions
      (Ir.store
         (Ir.Lit_or_var.Lit 41L)
         (Ir.Mem.address (Ir.Lit_or_var.Var slot)));
    Vec.push
      root_root.instructions
      (Ir.call ~fn:"child" ~results:[ res ] ~args:[ Ir.Lit_or_var.Var slot ]);
    let root = make_fn ~name:"root" ~args:[] ~root:root_root in
    String.Map.of_alist_exn [ "root", root; "child", child ]
  in
  run_functions mk_functions "41"
;;

let%expect_test "print helper" =
  let make_fn ~name ~args ~root =
    (* Mirror [Eir.set_entry_block_args] for hand-constructed CFGs. *)
    List.iter args ~f:(Vec.push root.Block.args);
    root.dfs_id <- Some 0;
    Function.create ~name ~args ~root
  in
  let p = Var.create ~name:"p" ~type_:Type.Ptr in
  let loaded = Var.create ~name:"loaded" ~type_:Type.I64 in
  let child_root =
    Block.create
      ~id_hum:"%root"
      ~terminal:(Ir.return (Ir.Lit_or_var.Var loaded))
  in
  Vec.push
    child_root.instructions
    (Ir.load loaded (Ir.Mem.address (Ir.Lit_or_var.Var p)));
  let child = make_fn ~name:"child" ~args:[ p ] ~root:child_root in
  let slot = Var.create ~name:"slot" ~type_:Type.Ptr in
  let res = Var.create ~name:"res" ~type_:Type.I64 in
  let root_root =
    Block.create ~id_hum:"%root" ~terminal:(Ir.return (Ir.Lit_or_var.Var res))
  in
  Vec.push
    root_root.instructions
    (Ir.alloca { dest = slot; size = Ir.Lit_or_var.Lit 8L });
  Vec.push
    root_root.instructions
    (Ir.store
       (Ir.Lit_or_var.Lit 41L)
       (Ir.Mem.address (Ir.Lit_or_var.Var slot)));
  Vec.push
    root_root.instructions
    (Ir.call ~fn:"child" ~results:[ res ] ~args:[ Ir.Lit_or_var.Var slot ]);
  let root = make_fn ~name:"root" ~args:[] ~root:root_root in
  let functions = String.Map.of_alist_exn [ "root", root; "child", child ] in
  print_s [%sexp (functions : Function.t String.Map.t)];
  [%expect
    {|
    ((child
      ((call_conv Default)
       (root
        ((%root (args (((name p) (type_ Ptr))))
          (instrs
           ((Load ((name loaded) (type_ I64))
             (Address ((base (Var ((name p) (type_ Ptr)))) (offset 0))))
            (Return (Var ((name loaded) (type_ I64)))))))))
       (args (((name p) (type_ Ptr)))) (name child) (prologue ()) (epilogue ())
       (bytes_alloca'd 0) (bytes_for_spills 0) (bytes_for_clobber_saves 0)))
     (root
      ((call_conv Default)
       (root
        ((%root (args ())
          (instrs
           ((Alloca ((dest ((name slot) (type_ Ptr))) (size (Lit 8))))
            (Store (Lit 41)
             (Address ((base (Var ((name slot) (type_ Ptr)))) (offset 0))))
            (Call (fn child) (results (((name res) (type_ I64))))
             (args ((Var ((name slot) (type_ Ptr))))))
            (Return (Var ((name res) (type_ I64)))))))))
       (args ()) (name root) (prologue ()) (epilogue ()) (bytes_alloca'd 0)
       (bytes_for_spills 0) (bytes_for_clobber_saves 0))))
    |}]
;;

let borked =
  {|
child(%x:ptr) {
   load %res:i64, %x
   ret %res
}

root() {
   alloca %slot:ptr, 8
   store %slot, 41
   call child(%slot) -> %res:i64
   ret %res
}
   |}
;;

(* Examples.Textual.super_triv *)
(*   {| *)
(* root() { *)
(*     add %v1:i64, 1, 0 *)
(*     add %v2:i64, 2, 0 *)
(*     add %v3:i64, 3, 0 *)
(*     add %v4:i64, 4, 0 *)
(*     add %v5:i64, 5, 0 *)
(*     add %v6:i64, 6, 0 *)
(*     add %v7:i64, 7, 0 *)
(*     add %v8:i64, 8, 0 *)
(*     add %v9:i64, 9, 0 *)
(*     add %v10:i64, 10, 0 *)
(*     add %v11:i64, 11, 0 *)
(*     add %v12:i64, 12, 0 *)
(*     add %v13:i64, 13, 0 *)
(*     add %v14:i64, 14, 0 *)
(*     add %v15:i64, 15, 0 *)
(*     add %v16:i64, 16, 0 *)
(*     add %v17:i64, 17, 0 *)
(*     add %v18:i64, 18, 0 *)
(*     add %v19:i64, 19, 0 *)
(*     add %v20:i64, 20, 0 *)
(*     add %s1:i64, %v1, %v2 *)
(*     add %s2:i64, %s1, %v3 *)
(*     add %s3:i64, %s2, %v4 *)
(*     add %s4:i64, %s3, %v5 *)
(*     add %s5:i64, %s4, %v6 *)
(*     add %s6:i64, %s5, %v7 *)
(*     add %s7:i64, %s6, %v8 *)
(*     add %s8:i64, %s7, %v9 *)
(*     add %s9:i64, %s8, %v10 *)
(*     add %s10:i64, %s9, %v11 *)
(*     add %s11:i64, %s10, %v12 *)
(*     add %s12:i64, %s11, %v13 *)
(*     add %s13:i64, %s12, %v14 *)
(*     add %s14:i64, %s13, %v15 *)
(*     add %s15:i64, %s14, %v16 *)
(*     add %s16:i64, %s15, %v17 *)
(*     add %s17:i64, %s16, %v18 *)
(*     add %s18:i64, %s17, %v19 *)
(*     add %result:i64, %s18, %v20 *)
(*     ret %result *)
(* } *)
(* |} *)

let arch = `Arm64
let system = `Darwin

let test ?dump_crap ?(opt_flags = Eir.Opt_flags.no_opt) s =
  match Eir.compile ~opt_flags s with
  | Error e -> Nod_error.to_string e |> print_endline
  | Ok functions ->
    (match arch with
     | `X86_64 ->
       let x86 = X86_backend.compile ?dump_crap functions in
       print_s
         [%sexp
           (Map.data x86 |> List.map ~f:Function.to_sexp_verbose : Sexp.t list)]
     | `Arm64 ->
       let arm64 = Arm64_backend.compile ?dump_crap functions in
       print_s
         [%sexp
           (Map.data arm64 |> List.map ~f:Function.to_sexp_verbose
            : Sexp.t list)]
     | `Other -> failwith "unecpected arch")
;;

let%expect_test "run" =
  assert_execution
    ~harness:
      (* (make_harness_source ~fn_name:"root" ~fn_arg_type:"int" ~fn_arg:"5" ()) *)
      (make_harness_source ())
    ~opt_flags:Eir.Opt_flags.no_opt
    borked (* "210" *)
    "41";
  [%expect {||}]
;;

let%expect_test "borked regaloc" =
  match Nod.compile ~opt_flags:Eir.Opt_flags.no_opt borked with
  | Error e -> Nod_error.to_string e |> print_endline
  | Ok functions ->
    (match arch with
     | `X86_64 -> X86_backend.For_testing.print_assignments functions
     | `Arm64 -> Arm64_backend.For_testing.print_assignments functions
     | `Other -> failwith "unecpected arch");
    [%expect
      {|
      ((function_name child)
       (assignments
        ((((name res) (type_ I64)) (Reg ((reg X28) (class_ I64))))
         (((name res__0) (type_ I64)) (Reg ((reg X0) (class_ I64))))
         (((name x) (type_ Ptr)) (Reg ((reg X28) (class_ I64))))
         (((name x0) (type_ Ptr)) (Reg ((reg X0) (class_ I64)))))))
      ()
      ((function_name root)
       (assignments
        ((((name arg_reg) (type_ I64)) (Reg ((reg X0) (class_ I64))))
         (((name res) (type_ I64)) (Reg ((reg X28) (class_ I64))))
         (((name res__0) (type_ I64)) (Reg ((reg X0) (class_ I64))))
         (((name slot) (type_ Ptr)) (Reg ((reg X28) (class_ I64))))
         (((name tmp_force_physical) (type_ I64)) (Reg ((reg X0) (class_ I64)))))))
      ((((name slot) (type_ Ptr)) ((name arg_reg) (type_ I64))))
      |}]
;;

let%expect_test "borked" =
  compile_and_lower ~arch ~system ~opt_flags:Eir.Opt_flags.no_opt borked
  |> print_endline;
  [%expect
    {|
    .text
    .globl _child
    _child:
      mov x14, #8
      sub sp, sp, x14
      mov x14, #24
      sub sp, sp, x14
      str x28, [sp]
      str x29, [sp, #8]
      str x30, [sp, #16]
      mov x29, sp
      mov x14, #24
      add x29, x29, x14
      mov x0, x0
      mov x28, x0
    child___root:
      ldr x28, [x28]
      mov x0, x28
    child__child__epilogue:
      mov x0, x0
      mov sp, x29
      mov x14, #24
      sub sp, sp, x14
      ldr x30, [sp, #16]
      ldr x29, [sp, #8]
      ldr x28, [sp]
      mov x14, #24
      add sp, sp, x14
      mov x14, #8
      add sp, sp, x14
      ret

    .globl _root
    _root:
      mov x14, #8
      sub sp, sp, x14
      mov x14, #24
      sub sp, sp, x14
      str x28, [sp]
      str x29, [sp, #8]
      str x30, [sp, #16]
      mov x29, sp
      mov x14, #24
      add x29, x29, x14
    root___root:
      mov x28, x29
      mov x14, #41
      str x14, [x28]
      mov x0, x28
      bl _child
      mov x28, x0
      mov x0, x28
    root__root__epilogue:
      mov x0, x0
      mov sp, x29
      mov x14, #24
      sub sp, sp, x14
      ldr x30, [sp, #16]
      ldr x29, [sp, #8]
      ldr x28, [sp]
      mov x14, #24
      add sp, sp, x14
      mov x14, #8
      add sp, sp, x14
      ret
    |}]
;;

let%expect_test "debug borked opt ssa" =
  test_ssa ~don't_opt:() borked;
  [%expect
    {|
    (%root
     (instrs
      ((Load ((name res) (type_ I64))
        (Address ((base (Var ((name x) (type_ Ptr)))) (offset 0))))
       (Return (Var ((name res) (type_ I64)))))))
    (%root
     (instrs
      ((Alloca ((dest ((name slot) (type_ Ptr))) (size (Lit 8))))
       (Store (Lit 41)
        (Address ((base (Var ((name slot) (type_ Ptr)))) (offset 0))))
       (Call (fn child) (results (((name res) (type_ I64))))
        (args ((Var ((name slot) (type_ Ptr))))))
       (Return (Var ((name res) (type_ I64)))))))
    =================================
    (%root (args (((name x) (type_ Ptr))))
     (instrs
      ((Load ((name res) (type_ I64))
        (Address ((base (Var ((name x) (type_ Ptr)))) (offset 0))))
       (Return (Var ((name res) (type_ I64)))))))
    (%root (args ())
     (instrs
      ((Alloca ((dest ((name slot) (type_ Ptr))) (size (Lit 8))))
       (Store (Lit 41)
        (Address ((base (Var ((name slot) (type_ Ptr)))) (offset 0))))
       (Call (fn child) (results (((name res) (type_ I64))))
        (args ((Var ((name slot) (type_ Ptr))))))
       (Return (Var ((name res) (type_ I64)))))))
    |}]
;;

let%expect_test "debug borked opt x86" =
  test ~opt_flags:Eir.Opt_flags.no_opt borked;
  [%expect
    {|
    (((call_conv Default)
      (root
       ((child__prologue (args (((name x0) (type_ Ptr))))
         (instrs
          ((Arm64
            (Int_binary (op Sub) (dst ((reg SP) (class_ I64)))
             (lhs (Reg ((reg SP) (class_ I64)))) (rhs (Imm 8))))
           (Arm64
            (Int_binary (op Sub) (dst ((reg SP) (class_ I64)))
             (lhs (Reg ((reg SP) (class_ I64)))) (rhs (Imm 24))))
           (Arm64
            (Store (src (Reg ((reg X28) (class_ I64))))
             (addr (Mem ((reg SP) (class_ I64)) 0))))
           (Arm64
            (Store (src (Reg ((reg X29) (class_ I64))))
             (addr (Mem ((reg SP) (class_ I64)) 8))))
           (Arm64
            (Store (src (Reg ((reg X30) (class_ I64))))
             (addr (Mem ((reg SP) (class_ I64)) 16))))
           (Arm64
            (Move (dst ((reg X29) (class_ I64)))
             (src (Reg ((reg SP) (class_ I64))))))
           (Arm64
            (Int_binary (op Add) (dst ((reg X29) (class_ I64)))
             (lhs (Reg ((reg X29) (class_ I64)))) (rhs (Imm 24))))
           (Arm64
            (Move (dst ((reg X0) (class_ I64)))
             (src (Reg ((reg X0) (class_ I64))))))
           (Arm64 (Tag_def Nop (Reg ((reg X29) (class_ I64)))))
           (Arm64
            (Move (dst ((reg X28) (class_ I64)))
             (src (Reg ((reg X0) (class_ I64))))))
           (Arm64
            (Jump
             ((block ((id_hum %root) (args (((name x) (type_ Ptr)))))) (args ())))))))
        (%root (args (((name x) (type_ Ptr))))
         (instrs
          ((Arm64
            (Load (dst ((reg X28) (class_ I64)))
             (addr (Mem ((reg X28) (class_ I64)) 0))))
           (Arm64
            (Move (dst ((reg X0) (class_ I64)))
             (src (Reg ((reg X28) (class_ I64))))))
           (Arm64_terminal
            ((Jump
              ((block
                ((id_hum child__epilogue) (args (((name res__0) (type_ I64))))))
               (args ()))))))))
        (child__epilogue (args (((name res__0) (type_ I64))))
         (instrs
          ((Arm64
            (Move (dst ((reg X0) (class_ I64)))
             (src (Reg ((reg X0) (class_ I64))))))
           (Arm64
            (Move (dst ((reg SP) (class_ I64)))
             (src (Reg ((reg X29) (class_ I64))))))
           (Arm64
            (Int_binary (op Sub) (dst ((reg SP) (class_ I64)))
             (lhs (Reg ((reg SP) (class_ I64)))) (rhs (Imm 24))))
           (Arm64
            (Load (dst ((reg X30) (class_ I64)))
             (addr (Mem ((reg SP) (class_ I64)) 16))))
           (Arm64
            (Load (dst ((reg X29) (class_ I64)))
             (addr (Mem ((reg SP) (class_ I64)) 8))))
           (Arm64
            (Load (dst ((reg X28) (class_ I64)))
             (addr (Mem ((reg SP) (class_ I64)) 0))))
           (Arm64
            (Int_binary (op Add) (dst ((reg SP) (class_ I64)))
             (lhs (Reg ((reg SP) (class_ I64)))) (rhs (Imm 24))))
           (Arm64
            (Int_binary (op Add) (dst ((reg SP) (class_ I64)))
             (lhs (Reg ((reg SP) (class_ I64)))) (rhs (Imm 8))))
           (Arm64 (Ret ((Reg ((reg X0) (class_ I64)))))))))))
      (args (((name x) (type_ Ptr)))) (name child) (prologue ()) (epilogue ())
      (bytes_alloca'd 0) (bytes_for_spills 0) (bytes_for_clobber_saves 24))
     ((call_conv Default)
      (root
       ((root__prologue (args ())
         (instrs
          ((Arm64
            (Int_binary (op Sub) (dst ((reg SP) (class_ I64)))
             (lhs (Reg ((reg SP) (class_ I64)))) (rhs (Imm 8))))
           (Arm64
            (Int_binary (op Sub) (dst ((reg SP) (class_ I64)))
             (lhs (Reg ((reg SP) (class_ I64)))) (rhs (Imm 24))))
           (Arm64
            (Store (src (Reg ((reg X28) (class_ I64))))
             (addr (Mem ((reg SP) (class_ I64)) 0))))
           (Arm64
            (Store (src (Reg ((reg X29) (class_ I64))))
             (addr (Mem ((reg SP) (class_ I64)) 8))))
           (Arm64
            (Store (src (Reg ((reg X30) (class_ I64))))
             (addr (Mem ((reg SP) (class_ I64)) 16))))
           (Arm64
            (Move (dst ((reg X29) (class_ I64)))
             (src (Reg ((reg SP) (class_ I64))))))
           (Arm64
            (Int_binary (op Add) (dst ((reg X29) (class_ I64)))
             (lhs (Reg ((reg X29) (class_ I64)))) (rhs (Imm 24))))
           (Arm64 (Tag_def Nop (Reg ((reg X29) (class_ I64)))))
           (Arm64 (Jump ((block ((id_hum %root) (args ()))) (args ())))))))
        (%root (args ())
         (instrs
          ((Arm64_terminal
            ((Move (dst ((reg X28) (class_ I64)))
              (src (Reg ((reg X29) (class_ I64)))))))
           (Arm64 (Store (src (Imm 41)) (addr (Mem ((reg X28) (class_ I64)) 0))))
           (Arm64
            (Move (dst ((reg X0) (class_ I64)))
             (src (Reg ((reg X28) (class_ I64))))))
           (Arm64
            (Call (fn child) (results (((reg X0) (class_ I64))))
             (args ((Reg ((reg X28) (class_ I64)))))))
           (Arm64
            (Move (dst ((reg X28) (class_ I64)))
             (src (Reg ((reg X0) (class_ I64))))))
           (Arm64
            (Move (dst ((reg X0) (class_ I64)))
             (src (Reg ((reg X28) (class_ I64))))))
           (Arm64_terminal
            ((Jump
              ((block
                ((id_hum root__epilogue) (args (((name res__0) (type_ I64))))))
               (args ()))))))))
        (root__epilogue (args (((name res__0) (type_ I64))))
         (instrs
          ((Arm64
            (Move (dst ((reg X0) (class_ I64)))
             (src (Reg ((reg X0) (class_ I64))))))
           (Arm64
            (Move (dst ((reg SP) (class_ I64)))
             (src (Reg ((reg X29) (class_ I64))))))
           (Arm64
            (Int_binary (op Sub) (dst ((reg SP) (class_ I64)))
             (lhs (Reg ((reg SP) (class_ I64)))) (rhs (Imm 24))))
           (Arm64
            (Load (dst ((reg X30) (class_ I64)))
             (addr (Mem ((reg SP) (class_ I64)) 16))))
           (Arm64
            (Load (dst ((reg X29) (class_ I64)))
             (addr (Mem ((reg SP) (class_ I64)) 8))))
           (Arm64
            (Load (dst ((reg X28) (class_ I64)))
             (addr (Mem ((reg SP) (class_ I64)) 0))))
           (Arm64
            (Int_binary (op Add) (dst ((reg SP) (class_ I64)))
             (lhs (Reg ((reg SP) (class_ I64)))) (rhs (Imm 24))))
           (Arm64
            (Int_binary (op Add) (dst ((reg SP) (class_ I64)))
             (lhs (Reg ((reg SP) (class_ I64)))) (rhs (Imm 8))))
           (Arm64 (Ret ((Reg ((reg X0) (class_ I64)))))))))))
      (args ()) (name root) (prologue ()) (epilogue ()) (bytes_alloca'd 8)
      (bytes_for_spills 0) (bytes_for_clobber_saves 24)))
    |}]
;;

let%expect_test "debug borked" =
  match Nod.compile ~opt_flags:Eir.Opt_flags.no_opt borked with
  | Error e -> Nod_error.to_string e |> print_endline
  | Ok functions ->
    (match arch with
     | `X86_64 -> X86_backend.For_testing.print_selected_instructions functions
     | `Arm64 -> Arm64_backend.For_testing.print_selected_instructions functions
     | `Other -> failwith "unexpected arch");
    [%expect
      {|
      (block (block.id_hum child__prologue))
      +-----------------------------------------------------------------------------------------------------------------------------------------+--------------------------+
      | ir                                                                                                                                      | Ir.defs ir               |
      +-----------------------------------------------------------------------------------------------------------------------------------------+--------------------------+
      | (Arm64(Move(dst((reg(Allocated((name x0)(type_ Ptr))(X0)))(class_ I64)))(src(Reg((reg X0)(class_ I64))))))                              | (((name x0)(type_ Ptr))) |
      +-----------------------------------------------------------------------------------------------------------------------------------------+--------------------------+
      | (Arm64(Tag_def Nop(Reg((reg X29)(class_ I64)))))                                                                                        | {}                       |
      +-----------------------------------------------------------------------------------------------------------------------------------------+--------------------------+
      | (Arm64(Move(dst((reg(Unallocated((name x)(type_ Ptr))))(class_ I64)))(src(Reg((reg(Unallocated((name x0)(type_ Ptr))))(class_ I64)))))) | (((name x)(type_ Ptr)))  |
      +-----------------------------------------------------------------------------------------------------------------------------------------+--------------------------+
      | (Arm64(Jump((block((id_hum %root)(args(((name x)(type_ Ptr))))))(args(((name x0)(type_ Ptr)))))))                                       | {}                       |
      +-----------------------------------------------------------------------------------------------------------------------------------------+--------------------------+
      (block (block.id_hum %root))
      +-----------------------------------------------------------------------------------------------------------------------------------------------+------------------------------+
      | ir                                                                                                                                            | Ir.defs ir                   |
      +-----------------------------------------------------------------------------------------------------------------------------------------------+------------------------------+
      | (Arm64(Load(dst((reg(Unallocated((name res)(type_ I64))))(class_ I64)))(addr(Mem((reg(Allocated((name x)(type_ Ptr))()))(class_ I64))0))))    | (((name res)(type_ I64)))    |
      +-----------------------------------------------------------------------------------------------------------------------------------------------+------------------------------+
      | (Arm64(Move(dst((reg(Unallocated((name res__0)(type_ I64))))(class_ I64)))(src(Reg((reg(Unallocated((name res)(type_ I64))))(class_ I64)))))) | (((name res__0)(type_ I64))) |
      +-----------------------------------------------------------------------------------------------------------------------------------------------+------------------------------+
      | (Arm64_terminal((Jump((block((id_hum child__epilogue)(args(((name res__0)(type_ I64))))))(args(((name res)(type_ I64))))))))                  | {}                           |
      +-----------------------------------------------------------------------------------------------------------------------------------------------+------------------------------+
      (block (block.id_hum child__epilogue))
      +----------------------------------------------------------------------------------------------------------------+------------+
      | ir                                                                                                             | Ir.defs ir |
      +----------------------------------------------------------------------------------------------------------------+------------+
      | (Arm64(Move(dst((reg X0)(class_ I64)))(src(Reg((reg(Allocated((name res__0)(type_ I64))(X0)))(class_ I64)))))) | {}         |
      +----------------------------------------------------------------------------------------------------------------+------------+
      | (Arm64(Ret((Reg((reg(Allocated((name res__0)(type_ I64))(X0)))(class_ I64))))))                                | {}         |
      +----------------------------------------------------------------------------------------------------------------+------------+
      (block (block.id_hum root__prologue))
      +--------------------------------------------------------+------------+
      | ir                                                     | Ir.defs ir |
      +--------------------------------------------------------+------------+
      | (Arm64(Tag_def Nop(Reg((reg X29)(class_ I64)))))       | {}         |
      +--------------------------------------------------------+------------+
      | (Arm64(Jump((block((id_hum %root)(args())))(args())))) | {}         |
      +--------------------------------------------------------+------------+
      (block (block.id_hum %root))
      +---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | ir                                                                                                                                                                              | Ir.defs ir                               |
      +---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (Arm64_terminal((Move(dst((reg(Unallocated((name slot)(type_ Ptr))))(class_ I64)))(src(Reg((reg X29)(class_ I64)))))))                                                          | (((name slot)(type_ Ptr)))               |
      +---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (Arm64(Store(src(Imm 41))(addr(Mem((reg(Allocated((name slot)(type_ Ptr))()))(class_ I64))0))))                                                                                 | {}                                       |
      +---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | {Arm64,Save_clobbers}                                                                                                                                                           | {}                                       |
      +---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (Arm64(Move(dst((reg(Allocated((name arg_reg)(type_ I64))(X0)))(class_ I64)))(src(Reg((reg(Unallocated((name slot)(type_ Ptr))))(class_ I64))))))                               | (((name arg_reg)(type_ I64)))            |
      +---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (Arm64(Call(fn child)(results(((reg(Allocated((name tmp_force_physical)(type_ I64))(X0)))(class_ I64))))(args((Reg((reg(Unallocated((name slot)(type_ Ptr))))(class_ I64))))))) | (((name tmp_force_physical)(type_ I64))) |
      +---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (Arm64(Move(dst((reg(Unallocated((name res)(type_ I64))))(class_ I64)))(src(Reg((reg(Allocated((name tmp_force_physical)(type_ I64))(X0)))(class_ I64))))))                     | (((name res)(type_ I64)))                |
      +---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | {Arm64,Restore_clobbers}                                                                                                                                                        | {}                                       |
      +---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (Arm64(Move(dst((reg(Unallocated((name res__0)(type_ I64))))(class_ I64)))(src(Reg((reg(Unallocated((name res)(type_ I64))))(class_ I64))))))                                   | (((name res__0)(type_ I64)))             |
      +---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (Arm64_terminal((Jump((block((id_hum root__epilogue)(args(((name res__0)(type_ I64))))))(args(((name res)(type_ I64))))))))                                                     | {}                                       |
      +---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      (block (block.id_hum root__epilogue))
      +----------------------------------------------------------------------------------------------------------------+------------+
      | ir                                                                                                             | Ir.defs ir |
      +----------------------------------------------------------------------------------------------------------------+------------+
      | (Arm64(Move(dst((reg X0)(class_ I64)))(src(Reg((reg(Allocated((name res__0)(type_ I64))(X0)))(class_ I64)))))) | {}         |
      +----------------------------------------------------------------------------------------------------------------+------------+
      | (Arm64(Ret((Reg((reg(Allocated((name res__0)(type_ I64))(X0)))(class_ I64))))))                                | {}         |
      +----------------------------------------------------------------------------------------------------------------+------------+
      |}]
;;

let%expect_test "debug borked opt" =
  match Nod.compile ~opt_flags:Eir.Opt_flags.default borked with
  | Error e -> Nod_error.to_string e |> print_endline
  | Ok functions ->
    (match arch with
     | `X86_64 -> X86_backend.For_testing.print_selected_instructions functions
     | `Arm64 -> Arm64_backend.For_testing.print_selected_instructions functions
     | `Other -> failwith "unexpected arch");
    [%expect
      {|
      (block (block.id_hum child__prologue))
      +-----------------------------------------------------------------------------------------------------------------------------------------+--------------------------+
      | ir                                                                                                                                      | Ir.defs ir               |
      +-----------------------------------------------------------------------------------------------------------------------------------------+--------------------------+
      | (Arm64(Move(dst((reg(Allocated((name x0)(type_ Ptr))(X0)))(class_ I64)))(src(Reg((reg X0)(class_ I64))))))                              | (((name x0)(type_ Ptr))) |
      +-----------------------------------------------------------------------------------------------------------------------------------------+--------------------------+
      | (Arm64(Tag_def Nop(Reg((reg X29)(class_ I64)))))                                                                                        | {}                       |
      +-----------------------------------------------------------------------------------------------------------------------------------------+--------------------------+
      | (Arm64(Move(dst((reg(Unallocated((name x)(type_ Ptr))))(class_ I64)))(src(Reg((reg(Unallocated((name x0)(type_ Ptr))))(class_ I64)))))) | (((name x)(type_ Ptr)))  |
      +-----------------------------------------------------------------------------------------------------------------------------------------+--------------------------+
      | (Arm64(Jump((block((id_hum %root)(args(((name x)(type_ Ptr))))))(args(((name x0)(type_ Ptr)))))))                                       | {}                       |
      +-----------------------------------------------------------------------------------------------------------------------------------------+--------------------------+
      (block (block.id_hum %root))
      +-----------------------------------------------------------------------------------------------------------------------------------------------+------------------------------+
      | ir                                                                                                                                            | Ir.defs ir                   |
      +-----------------------------------------------------------------------------------------------------------------------------------------------+------------------------------+
      | (Arm64(Load(dst((reg(Unallocated((name res)(type_ I64))))(class_ I64)))(addr(Mem((reg(Allocated((name x)(type_ Ptr))()))(class_ I64))0))))    | (((name res)(type_ I64)))    |
      +-----------------------------------------------------------------------------------------------------------------------------------------------+------------------------------+
      | (Arm64(Move(dst((reg(Unallocated((name res__0)(type_ I64))))(class_ I64)))(src(Reg((reg(Unallocated((name res)(type_ I64))))(class_ I64)))))) | (((name res__0)(type_ I64))) |
      +-----------------------------------------------------------------------------------------------------------------------------------------------+------------------------------+
      | (Arm64_terminal((Jump((block((id_hum child__epilogue)(args(((name res__0)(type_ I64))))))(args(((name res)(type_ I64))))))))                  | {}                           |
      +-----------------------------------------------------------------------------------------------------------------------------------------------+------------------------------+
      (block (block.id_hum child__epilogue))
      +----------------------------------------------------------------------------------------------------------------+------------+
      | ir                                                                                                             | Ir.defs ir |
      +----------------------------------------------------------------------------------------------------------------+------------+
      | (Arm64(Move(dst((reg X0)(class_ I64)))(src(Reg((reg(Allocated((name res__0)(type_ I64))(X0)))(class_ I64)))))) | {}         |
      +----------------------------------------------------------------------------------------------------------------+------------+
      | (Arm64(Ret((Reg((reg(Allocated((name res__0)(type_ I64))(X0)))(class_ I64))))))                                | {}         |
      +----------------------------------------------------------------------------------------------------------------+------------+
      (block (block.id_hum root__prologue))
      +--------------------------------------------------------+------------+
      | ir                                                     | Ir.defs ir |
      +--------------------------------------------------------+------------+
      | (Arm64(Tag_def Nop(Reg((reg X29)(class_ I64)))))       | {}         |
      +--------------------------------------------------------+------------+
      | (Arm64(Jump((block((id_hum %root)(args())))(args())))) | {}         |
      +--------------------------------------------------------+------------+
      (block (block.id_hum %root))
      +---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | ir                                                                                                                                                                              | Ir.defs ir                               |
      +---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (Arm64_terminal((Move(dst((reg(Unallocated((name slot)(type_ Ptr))))(class_ I64)))(src(Reg((reg X29)(class_ I64)))))))                                                          | (((name slot)(type_ Ptr)))               |
      +---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (Arm64(Store(src(Imm 41))(addr(Mem((reg(Allocated((name slot)(type_ Ptr))()))(class_ I64))0))))                                                                                 | {}                                       |
      +---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | {Arm64,Save_clobbers}                                                                                                                                                           | {}                                       |
      +---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (Arm64(Move(dst((reg(Allocated((name arg_reg)(type_ I64))(X0)))(class_ I64)))(src(Reg((reg(Unallocated((name slot)(type_ Ptr))))(class_ I64))))))                               | (((name arg_reg)(type_ I64)))            |
      +---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (Arm64(Call(fn child)(results(((reg(Allocated((name tmp_force_physical)(type_ I64))(X0)))(class_ I64))))(args((Reg((reg(Unallocated((name slot)(type_ Ptr))))(class_ I64))))))) | (((name tmp_force_physical)(type_ I64))) |
      +---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (Arm64(Move(dst((reg(Unallocated((name res)(type_ I64))))(class_ I64)))(src(Reg((reg(Allocated((name tmp_force_physical)(type_ I64))(X0)))(class_ I64))))))                     | (((name res)(type_ I64)))                |
      +---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | {Arm64,Restore_clobbers}                                                                                                                                                        | {}                                       |
      +---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (Arm64(Move(dst((reg(Unallocated((name res__0)(type_ I64))))(class_ I64)))(src(Reg((reg(Unallocated((name res)(type_ I64))))(class_ I64))))))                                   | (((name res__0)(type_ I64)))             |
      +---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (Arm64_terminal((Jump((block((id_hum root__epilogue)(args(((name res__0)(type_ I64))))))(args(((name res)(type_ I64))))))))                                                     | {}                                       |
      +---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      (block (block.id_hum root__epilogue))
      +----------------------------------------------------------------------------------------------------------------+------------+
      | ir                                                                                                             | Ir.defs ir |
      +----------------------------------------------------------------------------------------------------------------+------------+
      | (Arm64(Move(dst((reg X0)(class_ I64)))(src(Reg((reg(Allocated((name res__0)(type_ I64))(X0)))(class_ I64)))))) | {}         |
      +----------------------------------------------------------------------------------------------------------------+------------+
      | (Arm64(Ret((Reg((reg(Allocated((name res__0)(type_ I64))(X0)))(class_ I64))))))                                | {}         |
      +----------------------------------------------------------------------------------------------------------------+------------+
      |}]
;;
