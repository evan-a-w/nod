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
    (Ir.load loaded (Ir.Mem.Lit_or_var (Ir.Lit_or_var.Var p)));
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
       (Ir.Mem.Lit_or_var (Ir.Lit_or_var.Var slot)));
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
             (Lit_or_var (Var ((name p) (type_ Ptr)))))
            (Return (Var ((name loaded) (type_ I64)))))))))
       (args (((name p) (type_ Ptr)))) (name child) (prologue ()) (epilogue ())
       (bytes_alloca'd 0) (bytes_for_spills 0) (bytes_for_clobber_saves 0)))
     (root
      ((call_conv Default)
       (root
        ((%root (args ())
          (instrs
           ((Alloca ((dest ((name slot) (type_ Ptr))) (size (Lit 8))))
            (Store (Lit 41) (Lit_or_var (Var ((name slot) (type_ Ptr)))))
            (Call (fn child) (results (((name res) (type_ I64))))
             (args ((Var ((name slot) (type_ Ptr))))))
            (Return (Var ((name res) (type_ I64)))))))))
       (args ()) (name root) (prologue ()) (epilogue ()) (bytes_alloca'd 0)
       (bytes_for_spills 0) (bytes_for_clobber_saves 0))))
    |}]
;;

let borked =
  (* Examples.Textual.super_triv *)
  {|
child(%p:ptr) {
   load %loaded:i64, %p
   ret %loaded
} 

root() {
   alloca %slot:ptr, 8
   store %slot, 41
   call child(%slot) -> %res:i64
   ret %res
}
|}
;;

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
      (make_harness_source ~fn_name:"root" ~fn_arg_type:"int" ~fn_arg:"5" ())
    ~opt_flags:Eir.Opt_flags.no_opt
    borked
    "695"
[@@expect.uncaught_exn
  {|
  (* CR expect_test_collector: This test expectation appears to contain a backtrace.
     This is strongly discouraged as backtraces are fragile.
     Please change this test to not include a backtrace. *)
  (Failure "arch x86_64 produced 12, expected 695")
  Raised at Stdlib.failwith in file "stdlib.ml" (inlined), line 39, characters 17-33
  Called from Base__Printf.failwithf.(fun) in file "src/printf.ml", line 7, characters 24-34
  Called from Base__List0.iter.loop in file "src/list0.ml" (inlined), line 99, characters 6-9
  Called from Base__List0.iter in file "src/list0.ml" (inlined), line 102, characters 2-11
  Called from Nod_debug_test__Test_tmp.assert_execution in file "debug_test/test_tmp.ml", lines 58-67, characters 2-311
  Called from Ppx_expect_runtime__Test_block.Configured.dump_backtrace in file "runtime/test_block.ml", line 358, characters 10-25
  |}]
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
      ((function_name root)
       (assignments
        ((((name a) (type_ I64)) (Reg ((reg X28) (class_ I64))))
         (((name b) (type_ I64)) (Reg ((reg X27) (class_ I64))))
         (((name res) (type_ I64)) (Reg ((reg X28) (class_ I64))))
         (((name res__0) (type_ I64)) (Reg ((reg X0) (class_ I64))))
         (((name tmp10) (type_ I64)) (Reg ((reg X28) (class_ I64)))))))
      ((((name a) (type_ I64)) ((name b) (type_ I64)))
       (((name b) (type_ I64)) ((name tmp10) (type_ I64))))
      |}]
;;

let%expect_test "borked" =
  compile_and_lower ~arch ~system ~opt_flags:Eir.Opt_flags.no_opt borked
  |> print_endline;
  [%expect
    {|
    .text
    .globl _root
    _root:
      mov x16, #32
      sub sp, sp, x16
      str x27, [sp]
      str x28, [sp, #8]
      str x29, [sp, #16]
      str x30, [sp, #24]
      mov x29, sp
      mov x16, #32
      add x29, x29, x16
    root___root:
      mov x28, #1
      mov x27, #2
      mov x16, #10
      mul x28, x28, x16
      add x28, x28, x27
      mov x0, x28
    root__root__epilogue:
      mov x0, x0
      mov sp, x29
      mov x16, #32
      sub sp, sp, x16
      ldr x30, [sp, #24]
      ldr x29, [sp, #16]
      ldr x28, [sp, #8]
      ldr x27, [sp]
      mov x16, #32
      add sp, sp, x16
      ret
    |}]
;;

let%expect_test "debug borked opt ssa" =
  test_ssa ~don't_opt:() borked;
  [%expect
    {|
    (%root
     (instrs
      ((Move ((name a) (type_ I64)) (Lit 1))
       (Move ((name b) (type_ I64)) (Lit 2))
       (Mul
        ((dest ((name tmp10) (type_ I64))) (src1 (Var ((name a) (type_ I64))))
         (src2 (Lit 10))))
       (Add
        ((dest ((name res) (type_ I64))) (src1 (Var ((name tmp10) (type_ I64))))
         (src2 (Var ((name b) (type_ I64))))))
       (Return (Var ((name res) (type_ I64)))))))
    =================================
    (%root (args ())
     (instrs
      ((Move ((name a) (type_ I64)) (Lit 1))
       (Move ((name b) (type_ I64)) (Lit 2))
       (Mul
        ((dest ((name tmp10) (type_ I64))) (src1 (Var ((name a) (type_ I64))))
         (src2 (Lit 10))))
       (Add
        ((dest ((name res) (type_ I64))) (src1 (Var ((name tmp10) (type_ I64))))
         (src2 (Var ((name b) (type_ I64))))))
       (Return (Var ((name res) (type_ I64)))))))
    |}]
;;

let%expect_test "debug borked opt x86" =
  test ~opt_flags:Eir.Opt_flags.no_opt borked;
  [%expect
    {|
    (((call_conv Default)
      (root
       ((root__prologue (args ())
         (instrs
          ((Arm64
            (Int_binary (op Sub) (dst ((reg SP) (class_ I64)))
             (lhs (Reg ((reg SP) (class_ I64)))) (rhs (Imm 32))))
           (Arm64
            (Store (src (Reg ((reg X27) (class_ I64))))
             (addr (Mem ((reg SP) (class_ I64)) 0))))
           (Arm64
            (Store (src (Reg ((reg X28) (class_ I64))))
             (addr (Mem ((reg SP) (class_ I64)) 8))))
           (Arm64
            (Store (src (Reg ((reg X29) (class_ I64))))
             (addr (Mem ((reg SP) (class_ I64)) 16))))
           (Arm64
            (Store (src (Reg ((reg X30) (class_ I64))))
             (addr (Mem ((reg SP) (class_ I64)) 24))))
           (Arm64
            (Move (dst ((reg X29) (class_ I64)))
             (src (Reg ((reg SP) (class_ I64))))))
           (Arm64
            (Int_binary (op Add) (dst ((reg X29) (class_ I64)))
             (lhs (Reg ((reg X29) (class_ I64)))) (rhs (Imm 32))))
           (Arm64 (Tag_def Nop (Reg ((reg X29) (class_ I64)))))
           (Arm64 (Jump ((block ((id_hum %root) (args ()))) (args ())))))))
        (%root (args ())
         (instrs
          ((Arm64 (Move (dst ((reg X28) (class_ I64))) (src (Imm 1))))
           (Arm64 (Move (dst ((reg X27) (class_ I64))) (src (Imm 2))))
           (Arm64
            (Int_binary (op Mul) (dst ((reg X28) (class_ I64)))
             (lhs (Reg ((reg X28) (class_ I64)))) (rhs (Imm 10))))
           (Arm64
            (Int_binary (op Add) (dst ((reg X28) (class_ I64)))
             (lhs (Reg ((reg X28) (class_ I64))))
             (rhs (Reg ((reg X27) (class_ I64))))))
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
             (lhs (Reg ((reg SP) (class_ I64)))) (rhs (Imm 32))))
           (Arm64
            (Load (dst ((reg X30) (class_ I64)))
             (addr (Mem ((reg SP) (class_ I64)) 24))))
           (Arm64
            (Load (dst ((reg X29) (class_ I64)))
             (addr (Mem ((reg SP) (class_ I64)) 16))))
           (Arm64
            (Load (dst ((reg X28) (class_ I64)))
             (addr (Mem ((reg SP) (class_ I64)) 8))))
           (Arm64
            (Load (dst ((reg X27) (class_ I64)))
             (addr (Mem ((reg SP) (class_ I64)) 0))))
           (Arm64
            (Int_binary (op Add) (dst ((reg SP) (class_ I64)))
             (lhs (Reg ((reg SP) (class_ I64)))) (rhs (Imm 32))))
           (Arm64 (Ret ((Reg ((reg X0) (class_ I64)))))))))))
      (args ()) (name root) (prologue ()) (epilogue ()) (bytes_alloca'd 0)
      (bytes_for_spills 0) (bytes_for_clobber_saves 32)))
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
      (block (block.id_hum root__prologue))
      +--------------------------------------------------------+------------+
      | ir                                                     | Ir.defs ir |
      +--------------------------------------------------------+------------+
      | (Arm64(Tag_def Nop(Reg((reg X29)(class_ I64)))))       | {}         |
      +--------------------------------------------------------+------------+
      | (Arm64(Jump((block((id_hum %root)(args())))(args())))) | {}         |
      +--------------------------------------------------------+------------+
      (block (block.id_hum %root))
      +---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------+
      | ir                                                                                                                                                                                                                        | Ir.defs ir                   |
      +---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------+
      | (Arm64(Move(dst((reg(Unallocated((name a)(type_ I64))))(class_ I64)))(src(Imm 1))))                                                                                                                                       | (((name a)(type_ I64)))      |
      +---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------+
      | (Arm64(Move(dst((reg(Unallocated((name b)(type_ I64))))(class_ I64)))(src(Imm 2))))                                                                                                                                       | (((name b)(type_ I64)))      |
      +---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------+
      | (Arm64(Int_binary(op Mul)(dst((reg(Unallocated((name tmp10)(type_ I64))))(class_ I64)))(lhs(Reg((reg(Unallocated((name a)(type_ I64))))(class_ I64))))(rhs(Imm 10))))                                                     | (((name tmp10)(type_ I64)))  |
      +---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------+
      | (Arm64(Int_binary(op Add)(dst((reg(Unallocated((name res)(type_ I64))))(class_ I64)))(lhs(Reg((reg(Unallocated((name tmp10)(type_ I64))))(class_ I64))))(rhs(Reg((reg(Unallocated((name b)(type_ I64))))(class_ I64)))))) | (((name res)(type_ I64)))    |
      +---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------+
      | (Arm64(Move(dst((reg(Unallocated((name res__0)(type_ I64))))(class_ I64)))(src(Reg((reg(Unallocated((name res)(type_ I64))))(class_ I64))))))                                                                             | (((name res__0)(type_ I64))) |
      +---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------+
      | (Arm64_terminal((Jump((block((id_hum root__epilogue)(args(((name res__0)(type_ I64))))))(args(((name res)(type_ I64))))))))                                                                                               | {}                           |
      +---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------+
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
      (block (block.id_hum root__prologue))
      +--------------------------------------------------------+------------+
      | ir                                                     | Ir.defs ir |
      +--------------------------------------------------------+------------+
      | (Arm64(Tag_def Nop(Reg((reg X29)(class_ I64)))))       | {}         |
      +--------------------------------------------------------+------------+
      | (Arm64(Jump((block((id_hum %root)(args())))(args())))) | {}         |
      +--------------------------------------------------------+------------+
      (block (block.id_hum %root))
      +---------------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------+
      | ir                                                                                                                                                | Ir.defs ir                    |
      +---------------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------+
      | (Arm64(Move(dst((reg(Unallocated((name res__00)(type_ I64))))(class_ I64)))(src(Imm 12))))                                                        | (((name res__00)(type_ I64))) |
      +---------------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------+
      | (Arm64(Move(dst((reg(Unallocated((name res__0)(type_ I64))))(class_ I64)))(src(Reg((reg(Unallocated((name res__00)(type_ I64))))(class_ I64)))))) | (((name res__0)(type_ I64)))  |
      +---------------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------+
      | (Arm64_terminal((Jump((block((id_hum root__epilogue)(args(((name res__0)(type_ I64))))))(args(((name res__00)(type_ I64))))))))                   | {}                            |
      +---------------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------+
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
