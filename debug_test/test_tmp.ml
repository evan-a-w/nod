open! Core
open! Import

let map_function_roots ~f program = Program.map_function_roots program ~f

let map_function_roots_with_state program ~state ~f =
  { program with
    Program.functions =
      Map.mapi program.Program.functions ~f:(fun ~key:name ~data:fn ->
        Function0.map_root
          fn
          ~f:(f ~fn_state:(Nod_core.State.fn_state state name)))
  }
;;

let test_cfg s =
  s
  |> Parser.parse_string
  |> Result.map ~f:(fun program ->
    let state = Nod_core.State.create () in
    map_function_roots_with_state program ~state ~f:Cfg.process)
  |> function
  | Error e -> Nod_error.to_string e |> print_endline
  | Ok program ->
    Map.iter
      program.Program.functions
      ~f:(fun { Nod_ir.Function.root = ~root:_, ~blocks:_, ~in_order:blocks; _ } ->
        Vec.iter blocks ~f:(fun block ->
          let instrs =
            Instr_state.to_ir_list (Block.instructions block)
            |> List.map ~f:Fn_state.var_ir
            |> fun instrs ->
            instrs @ [ Fn_state.var_ir (Block.terminal block).Instr_state.ir ]
          in
          print_s [%message (Block.id_hum block) (instrs : Ir.t list)]))
;;

let test_ssa ?don't_opt s =
  test_cfg s;
  print_endline "=================================";
  let state = Nod_core.State.create () in
  Parser.parse_string s
  |> Result.map ~f:(fun program ->
    map_function_roots_with_state program ~state ~f:Cfg.process)
  |> Result.map ~f:(Eir.set_entry_block_args ~state)
  |> Result.map ~f:(fun program ->
    map_function_roots_with_state program ~state ~f:Ssa.create)
  |> function
  | Error e -> Nod_error.to_string e |> print_endline
  | Ok program ->
    let go program =
      Map.iter
        program.Program.functions
        ~f:(fun { Nod_ir.Function.root = (ssa : Ssa.t); _ } ->
          Vec.iter ssa.in_order ~f:(fun block ->
            let instrs =
              Instr_state.to_ir_list (Block.instructions block)
              |> List.map ~f:Fn_state.var_ir
              |> fun instrs ->
              instrs @ [ Fn_state.var_ir (Block.terminal block).Instr_state.ir ]
            in
            print_s
              [%message
                (Block.id_hum block)
                  ~args:(Block.args block : Var.t Vec.read)
                  (instrs : Ir.t list)]))
    in
    go program;
    (match don't_opt with
     | Some () -> ()
     | None ->
       print_endline "******************************";
       Eir.optimize program;
       go program)
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

let%expect_test "temp alloca passed to child; child loads value" =
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
  let make_fn ~fn_state ~name ~args ~root =
    (* Mirror [Eir.set_entry_block_args] for hand-constructed CFGs. *)
    Fn_state.set_block_args fn_state ~block:root ~args:(Vec.of_list args);
    Block.set_dfs_id root (Some 0);
    Function.create ~name ~args ~root
  in
  let mk_block fn_state ~id_hum ~terminal =
    Block.create
      ~id_hum
      ~terminal:
        (Fn_state.alloc_instr fn_state ~ir:(Fn_state.value_ir fn_state terminal))
  in
  let mk_block_with_instrs fn_state ~id_hum ~terminal ~instrs =
    let block = mk_block fn_state ~id_hum ~terminal in
    List.iter instrs ~f:(fun ir ->
      Fn_state.append_ir fn_state ~block ~ir:(Fn_state.value_ir fn_state ir));
    block
  in
  let mk_functions (_arch : [ `X86_64 | `Arm64 ]) =
    let child_state = Fn_state.create () in
    let root_state = Fn_state.create () in
    let p = Var.create ~name:"p" ~type_:Type.Ptr in
    let loaded = Var.create ~name:"loaded" ~type_:Type.I64 in
    let child_root =
      mk_block_with_instrs
        child_state
        ~id_hum:"%root"
        ~terminal:(Ir.return (Ir.Lit_or_var.Var loaded))
        ~instrs:[ Ir.load loaded (Ir.Mem.address (Ir.Lit_or_var.Var p)) ]
    in
    let child =
      make_fn ~fn_state:child_state ~name:"child" ~args:[ p ] ~root:child_root
    in
    let slot = Var.create ~name:"slot" ~type_:Type.Ptr in
    let res = Var.create ~name:"res" ~type_:Type.I64 in
    let root_root =
      mk_block_with_instrs
        root_state
        ~id_hum:"%root"
        ~terminal:(Ir.return (Ir.Lit_or_var.Var res))
        ~instrs:
          [ Ir.alloca { dest = slot; size = Ir.Lit_or_var.Lit 8L }
          ; Ir.store
              (Ir.Lit_or_var.Lit 41L)
              (Ir.Mem.address (Ir.Lit_or_var.Var slot))
          ; Ir.call
              ~fn:"child"
              ~results:[ res ]
              ~args:[ Ir.Lit_or_var.Var slot ]
          ]
    in
    let root =
      make_fn ~fn_state:root_state ~name:"root" ~args:[] ~root:root_root
    in
    String.Map.of_alist_exn [ "root", root; "child", child ]
  in
  run_functions mk_functions "41"
;;

(* let%expect_test "temp memory asm" = *)
(*   let make_fn ~name ~args ~root = *)
(*     (\* Mirror [Eir.set_entry_block_args] for hand-constructed CFGs. *\) *)
(*     List.iter args ~f:(Vec.push root.Block.args); *)
(*     root.dfs_id <- Some 0; *)
(*     Function.create ~name ~args ~root *)
(*   in *)
(*   let comp_functions ?(arch = `X86_64) functions = *)
(*     let asm = *)
(*       Nod.compile_and_lower_functions ~arch ~system:host_system functions *)
(*     in *)
(*     print_endline asm *)
(*   in *)
(*   let run_functions mk_functions = *)
(*     let arch = `Arm64 in *)
(*     let functions = mk_functions arch in *)
(*     comp_functions ~arch functions *)
(*   in *)
(*   let mk_functions (_arch : [ `X86_64 | `Arm64 ]) = *)
(*     let p = Var.create ~name:"p" ~type_:Type.Ptr in *)
(*     let loaded = Var.create ~name:"loaded" ~type_:Type.I64 in *)
(*     let child_root = *)
(*       Block.create *)
(*         ~id_hum:"%root" *)
(*         ~terminal:(Ir.return (Ir.Lit_or_var.Var loaded)) *)
(*     in *)
(*     Vec.push *)
(*       child_root.instructions *)
(*       (Ir.load loaded (Ir.Mem.address (Ir.Lit_or_var.Var p))); *)
(*     let child = make_fn ~name:"child" ~args:[ p ] ~root:child_root in *)
(*     let slot = Var.create ~name:"slot" ~type_:Type.Ptr in *)
(*     let res = Var.create ~name:"res" ~type_:Type.I64 in *)
(*     let root_root = *)
(*       Block.create ~id_hum:"%root" ~terminal:(Ir.return (Ir.Lit_or_var.Var res)) *)
(*     in *)
(*     Vec.push *)
(*       root_root.instructions *)
(*       (Ir.alloca { dest = slot; size = Ir.Lit_or_var.Lit 8L }); *)
(*     Vec.push *)
(*       root_root.instructions *)
(*       (Ir.store *)
(*          (Ir.Lit_or_var.Lit 41L) *)
(*          (Ir.Mem.address (Ir.Lit_or_var.Var slot))); *)
(*     Vec.push *)
(*       root_root.instructions *)
(*       (Ir.call ~fn:"child" ~results:[ res ] ~args:[ Ir.Lit_or_var.Var slot ]); *)
(*     let root = make_fn ~name:"root" ~args:[] ~root:root_root in *)
(*     String.Map.of_alist_exn [ "root", root; "child", child ] *)
(*   in *)
(*   run_functions mk_functions; *)
(*   [%expect *)
(*     {| *)
(*     .text *)
(*     .globl child *)
(*     child: *)
(*       mov x14, #16 *)
(*       sub sp, sp, x14 *)
(*       str x28, [sp] *)
(*       str x29, [sp, #8] *)
(*       mov x29, sp *)
(*       mov x0, x0 *)
(*       mov x28, x0 *)
(*     child___root: *)
(*       ldr x28, [x28] *)
(*       mov x0, x28 *)
(*     child__child__epilogue: *)
(*       mov x0, x0 *)
(*       mov sp, x29 *)
(*       ldr x28, [sp] *)
(*       ldr x29, [sp, #8] *)
(*       mov x14, #16 *)
(*       add sp, sp, x14 *)
(*       ret *)

(*     .globl root *)
(*     root: *)
(*       mov x14, #32 *)
(*       sub sp, sp, x14 *)
(*       str x28, [sp, #8] *)
(*       str x29, [sp, #16] *)
(*       str x30, [sp, #24] *)
(*       mov x29, sp *)
(*     root___root: *)
(*       mov x14, #0 *)
(*       add x28, x29, x14 *)
(*       mov x14, #41 *)
(*       str x14, [x28] *)
(*       mov x0, x28 *)
(*       bl child *)
(*       mov x28, x0 *)
(*       mov x0, x28 *)
(*     root__root__epilogue: *)
(*       mov x0, x0 *)
(*       mov sp, x29 *)
(*       ldr x28, [sp, #8] *)
(*       ldr x29, [sp, #16] *)
(*       ldr x30, [sp, #24] *)
(*       mov x14, #32 *)
(*       add sp, sp, x14 *)
(*       ret *)
(*     .section .note.GNU-stack,"",@progbits *)
(*     |}] *)
(* ;; *)

let%expect_test "print helper" =
  let make_fn ~fn_state ~name ~args ~root =
    (* Mirror [Eir.set_entry_block_args] for hand-constructed CFGs. *)
    Fn_state.set_block_args fn_state ~block:root ~args:(Vec.of_list args);
    Block.set_dfs_id root (Some 0);
    Function.create ~name ~args ~root
  in
  let mk_block fn_state ~id_hum ~terminal =
    Block.create
      ~id_hum
      ~terminal:
        (Fn_state.alloc_instr fn_state ~ir:(Fn_state.value_ir fn_state terminal))
  in
  let mk_block_with_instrs fn_state ~id_hum ~terminal ~instrs =
    let block = mk_block fn_state ~id_hum ~terminal in
    List.iter instrs ~f:(fun ir ->
      Fn_state.append_ir fn_state ~block ~ir:(Fn_state.value_ir fn_state ir));
    block
  in
  let child_state = Fn_state.create () in
  let root_state = Fn_state.create () in
  let p = Var.create ~name:"p" ~type_:Type.Ptr in
  let loaded = Var.create ~name:"loaded" ~type_:Type.I64 in
  let child_root =
    mk_block_with_instrs
      child_state
      ~id_hum:"%root"
      ~terminal:(Ir.return (Ir.Lit_or_var.Var loaded))
      ~instrs:[ Ir.load loaded (Ir.Mem.address (Ir.Lit_or_var.Var p)) ]
  in
  let child =
    make_fn ~fn_state:child_state ~name:"child" ~args:[ p ] ~root:child_root
  in
  let slot = Var.create ~name:"slot" ~type_:Type.Ptr in
  let res = Var.create ~name:"res" ~type_:Type.I64 in
  let root_root =
    mk_block_with_instrs
      root_state
      ~id_hum:"%root"
      ~terminal:(Ir.return (Ir.Lit_or_var.Var res))
      ~instrs:
        [ Ir.alloca { dest = slot; size = Ir.Lit_or_var.Lit 8L }
        ; Ir.store
            (Ir.Lit_or_var.Lit 41L)
            (Ir.Mem.address (Ir.Lit_or_var.Var slot))
        ; Ir.call ~fn:"child" ~results:[ res ] ~args:[ Ir.Lit_or_var.Var slot ]
        ]
  in
  let root =
    make_fn ~fn_state:root_state ~name:"root" ~args:[] ~root:root_root
  in
  let functions = String.Map.of_alist_exn [ "root", root; "child", child ] in
  print_s [%sexp (functions : Function.t String.Map.t)];
  [%expect
    {|
    ((child
      ((call_conv Default)
       (root
        ((%root (args (((name p) (type_ Ptr))))
          (instrs
           (((id (Instr_id 1))
             (ir
              (Load (Value_id 0)
               (Address ((base (Var (Value_id 1))) (offset 0))))))
            ((id (Instr_id 0)) (ir (Return (Var (Value_id 0))))))))))
       (args (((name p) (type_ Ptr)))) (name child) (prologue ()) (epilogue ())
       (bytes_for_clobber_saves 0) (bytes_for_padding 0) (bytes_for_spills 0)
       (bytes_statically_alloca'd 0)))
     (root
      ((call_conv Default)
       (root
        ((%root (args ())
          (instrs
           (((id (Instr_id 1))
             (ir (Alloca ((dest (Value_id 1)) (size (Lit 8))))))
            ((id (Instr_id 2))
             (ir
              (Store (Lit 41) (Address ((base (Var (Value_id 1))) (offset 0))))))
            ((id (Instr_id 3))
             (ir
              (Call (fn child) (results ((Value_id 0)))
               (args ((Var (Value_id 1)))))))
            ((id (Instr_id 0)) (ir (Return (Var (Value_id 0))))))))))
       (args ()) (name root) (prologue ()) (epilogue ())
       (bytes_for_clobber_saves 0) (bytes_for_padding 0) (bytes_for_spills 0)
       (bytes_statically_alloca'd 0))))
    |}]
;;

let borked =
  (*   {| *)
(* child(%x:ptr) { *)
(*    load %res:i64, %x *)
(*    ret %res *)
(* } *)

(* root() { *)
(*    alloca %slot:ptr, 8 *)
(*    store %slot, 41 *)
(*    call child(%slot) -> %res:i64 *)
(*    ret %res *)
(* } *)
(*    |} *)
  {|
     sum8(%a:i64, %b:i64, %c:i64, %d:i64, %e:i64, %f:i64, %g:i64, %h:i64) {
     add %t0:i64, %a, %b
     add %t1:i64, %t0, %c
     add %t2:i64, %t1, %d
     add %t3:i64, %t2, %e
     add %t4:i64, %t3, %f
     add %t5:i64, %t4, %g
     add %t6:i64, %t5, %h
     ret %t6
     }

     root() {
     call sum8(1, 2, 3, 4, 5, 6, 7, 8) -> %res:i64
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
  | Ok program ->
    (match arch with
     | `X86_64 ->
       let x86 = X86_backend.compile ?dump_crap program.Program.functions in
       print_s
         [%sexp
           (Map.data x86 |> List.map ~f:Function.to_sexp_verbose : Sexp.t list)]
     | `Arm64 ->
       let arm64 = Arm64_backend.compile ?dump_crap program.Program.functions in
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
    "36";
  [%expect {| |}]
;;

let%expect_test "borked regaloc" =
  match Nod.compile ~opt_flags:Eir.Opt_flags.no_opt borked with
  | Error e -> Nod_error.to_string e |> print_endline
  | Ok program ->
    (match arch with
     | `X86_64 ->
       X86_backend.For_testing.print_assignments program.Program.functions
     | `Arm64 ->
       Arm64_backend.For_testing.print_assignments program.Program.functions
     | `Other -> failwith "unecpected arch");
    [%expect
      {|
      ((function_name root)
       (assignments
        ((((name arg_reg) (type_ I64)) (Reg ((reg X0) (class_ I64))))
         (((name arg_reg0) (type_ I64)) (Reg ((reg X1) (class_ I64))))
         (((name arg_reg1) (type_ I64)) (Reg ((reg X2) (class_ I64))))
         (((name arg_reg2) (type_ I64)) (Reg ((reg X3) (class_ I64))))
         (((name arg_reg3) (type_ I64)) (Reg ((reg X4) (class_ I64))))
         (((name arg_reg4) (type_ I64)) (Reg ((reg X5) (class_ I64))))
         (((name arg_reg5) (type_ I64)) (Reg ((reg X6) (class_ I64))))
         (((name arg_reg6) (type_ I64)) (Reg ((reg X7) (class_ I64))))
         (((name res) (type_ I64)) (Reg ((reg X28) (class_ I64))))
         (((name res__0) (type_ I64)) (Reg ((reg X0) (class_ I64))))
         (((name tmp_force_physical) (type_ I64)) (Reg ((reg X0) (class_ I64)))))))
      ()
      ((function_name sum8)
       (assignments
        ((((name a) (type_ I64)) (Reg ((reg X21) (class_ I64))))
         (((name a0) (type_ I64)) (Reg ((reg X0) (class_ I64))))
         (((name b) (type_ I64)) (Reg ((reg X28) (class_ I64))))
         (((name b0) (type_ I64)) (Reg ((reg X1) (class_ I64))))
         (((name c) (type_ I64)) (Reg ((reg X22) (class_ I64))))
         (((name c0) (type_ I64)) (Reg ((reg X2) (class_ I64))))
         (((name d) (type_ I64)) (Reg ((reg X23) (class_ I64))))
         (((name d0) (type_ I64)) (Reg ((reg X3) (class_ I64))))
         (((name e) (type_ I64)) (Reg ((reg X24) (class_ I64))))
         (((name e0) (type_ I64)) (Reg ((reg X4) (class_ I64))))
         (((name f) (type_ I64)) (Reg ((reg X25) (class_ I64))))
         (((name f0) (type_ I64)) (Reg ((reg X5) (class_ I64))))
         (((name g) (type_ I64)) (Reg ((reg X26) (class_ I64))))
         (((name g0) (type_ I64)) (Reg ((reg X6) (class_ I64))))
         (((name h) (type_ I64)) (Reg ((reg X27) (class_ I64))))
         (((name h0) (type_ I64)) (Reg ((reg X7) (class_ I64))))
         (((name res__0) (type_ I64)) (Reg ((reg X0) (class_ I64))))
         (((name t0) (type_ I64)) (Reg ((reg X28) (class_ I64))))
         (((name t1) (type_ I64)) (Reg ((reg X28) (class_ I64))))
         (((name t2) (type_ I64)) (Reg ((reg X28) (class_ I64))))
         (((name t3) (type_ I64)) (Reg ((reg X28) (class_ I64))))
         (((name t4) (type_ I64)) (Reg ((reg X28) (class_ I64))))
         (((name t5) (type_ I64)) (Reg ((reg X28) (class_ I64))))
         (((name t6) (type_ I64)) (Reg ((reg X28) (class_ I64)))))))
      ((((name a0) (type_ I64)) ((name b0) (type_ I64)))
       (((name a0) (type_ I64)) ((name c0) (type_ I64)))
       (((name a0) (type_ I64)) ((name d0) (type_ I64)))
       (((name a0) (type_ I64)) ((name e0) (type_ I64)))
       (((name a0) (type_ I64)) ((name f0) (type_ I64)))
       (((name a0) (type_ I64)) ((name g0) (type_ I64)))
       (((name a0) (type_ I64)) ((name h0) (type_ I64)))
       (((name b0) (type_ I64)) ((name c0) (type_ I64)))
       (((name b0) (type_ I64)) ((name d0) (type_ I64)))
       (((name b0) (type_ I64)) ((name e0) (type_ I64)))
       (((name b0) (type_ I64)) ((name f0) (type_ I64)))
       (((name b0) (type_ I64)) ((name g0) (type_ I64)))
       (((name b0) (type_ I64)) ((name h0) (type_ I64)))
       (((name b0) (type_ I64)) ((name a) (type_ I64)))
       (((name c0) (type_ I64)) ((name d0) (type_ I64)))
       (((name c0) (type_ I64)) ((name e0) (type_ I64)))
       (((name c0) (type_ I64)) ((name f0) (type_ I64)))
       (((name c0) (type_ I64)) ((name g0) (type_ I64)))
       (((name c0) (type_ I64)) ((name h0) (type_ I64)))
       (((name c0) (type_ I64)) ((name a) (type_ I64)))
       (((name c0) (type_ I64)) ((name b) (type_ I64)))
       (((name d0) (type_ I64)) ((name e0) (type_ I64)))
       (((name d0) (type_ I64)) ((name f0) (type_ I64)))
       (((name d0) (type_ I64)) ((name g0) (type_ I64)))
       (((name d0) (type_ I64)) ((name h0) (type_ I64)))
       (((name d0) (type_ I64)) ((name a) (type_ I64)))
       (((name d0) (type_ I64)) ((name b) (type_ I64)))
       (((name d0) (type_ I64)) ((name c) (type_ I64)))
       (((name e0) (type_ I64)) ((name f0) (type_ I64)))
       (((name e0) (type_ I64)) ((name g0) (type_ I64)))
       (((name e0) (type_ I64)) ((name h0) (type_ I64)))
       (((name e0) (type_ I64)) ((name a) (type_ I64)))
       (((name e0) (type_ I64)) ((name b) (type_ I64)))
       (((name e0) (type_ I64)) ((name c) (type_ I64)))
       (((name e0) (type_ I64)) ((name d) (type_ I64)))
       (((name f0) (type_ I64)) ((name g0) (type_ I64)))
       (((name f0) (type_ I64)) ((name h0) (type_ I64)))
       (((name f0) (type_ I64)) ((name a) (type_ I64)))
       (((name f0) (type_ I64)) ((name b) (type_ I64)))
       (((name f0) (type_ I64)) ((name c) (type_ I64)))
       (((name f0) (type_ I64)) ((name d) (type_ I64)))
       (((name f0) (type_ I64)) ((name e) (type_ I64)))
       (((name g0) (type_ I64)) ((name h0) (type_ I64)))
       (((name g0) (type_ I64)) ((name a) (type_ I64)))
       (((name g0) (type_ I64)) ((name b) (type_ I64)))
       (((name g0) (type_ I64)) ((name c) (type_ I64)))
       (((name g0) (type_ I64)) ((name d) (type_ I64)))
       (((name g0) (type_ I64)) ((name e) (type_ I64)))
       (((name g0) (type_ I64)) ((name f) (type_ I64)))
       (((name h0) (type_ I64)) ((name a) (type_ I64)))
       (((name h0) (type_ I64)) ((name b) (type_ I64)))
       (((name h0) (type_ I64)) ((name c) (type_ I64)))
       (((name h0) (type_ I64)) ((name d) (type_ I64)))
       (((name h0) (type_ I64)) ((name e) (type_ I64)))
       (((name h0) (type_ I64)) ((name f) (type_ I64)))
       (((name h0) (type_ I64)) ((name g) (type_ I64)))
       (((name a) (type_ I64)) ((name b) (type_ I64)))
       (((name a) (type_ I64)) ((name c) (type_ I64)))
       (((name a) (type_ I64)) ((name d) (type_ I64)))
       (((name a) (type_ I64)) ((name e) (type_ I64)))
       (((name a) (type_ I64)) ((name f) (type_ I64)))
       (((name a) (type_ I64)) ((name g) (type_ I64)))
       (((name a) (type_ I64)) ((name h) (type_ I64)))
       (((name b) (type_ I64)) ((name c) (type_ I64)))
       (((name b) (type_ I64)) ((name d) (type_ I64)))
       (((name b) (type_ I64)) ((name e) (type_ I64)))
       (((name b) (type_ I64)) ((name f) (type_ I64)))
       (((name b) (type_ I64)) ((name g) (type_ I64)))
       (((name b) (type_ I64)) ((name h) (type_ I64)))
       (((name c) (type_ I64)) ((name d) (type_ I64)))
       (((name c) (type_ I64)) ((name e) (type_ I64)))
       (((name c) (type_ I64)) ((name f) (type_ I64)))
       (((name c) (type_ I64)) ((name g) (type_ I64)))
       (((name c) (type_ I64)) ((name h) (type_ I64)))
       (((name c) (type_ I64)) ((name t0) (type_ I64)))
       (((name d) (type_ I64)) ((name e) (type_ I64)))
       (((name d) (type_ I64)) ((name f) (type_ I64)))
       (((name d) (type_ I64)) ((name g) (type_ I64)))
       (((name d) (type_ I64)) ((name h) (type_ I64)))
       (((name d) (type_ I64)) ((name t0) (type_ I64)))
       (((name d) (type_ I64)) ((name t1) (type_ I64)))
       (((name e) (type_ I64)) ((name f) (type_ I64)))
       (((name e) (type_ I64)) ((name g) (type_ I64)))
       (((name e) (type_ I64)) ((name h) (type_ I64)))
       (((name e) (type_ I64)) ((name t0) (type_ I64)))
       (((name e) (type_ I64)) ((name t1) (type_ I64)))
       (((name e) (type_ I64)) ((name t2) (type_ I64)))
       (((name f) (type_ I64)) ((name g) (type_ I64)))
       (((name f) (type_ I64)) ((name h) (type_ I64)))
       (((name f) (type_ I64)) ((name t0) (type_ I64)))
       (((name f) (type_ I64)) ((name t1) (type_ I64)))
       (((name f) (type_ I64)) ((name t2) (type_ I64)))
       (((name f) (type_ I64)) ((name t3) (type_ I64)))
       (((name g) (type_ I64)) ((name h) (type_ I64)))
       (((name g) (type_ I64)) ((name t0) (type_ I64)))
       (((name g) (type_ I64)) ((name t1) (type_ I64)))
       (((name g) (type_ I64)) ((name t2) (type_ I64)))
       (((name g) (type_ I64)) ((name t3) (type_ I64)))
       (((name g) (type_ I64)) ((name t4) (type_ I64)))
       (((name h) (type_ I64)) ((name t0) (type_ I64)))
       (((name h) (type_ I64)) ((name t1) (type_ I64)))
       (((name h) (type_ I64)) ((name t2) (type_ I64)))
       (((name h) (type_ I64)) ((name t3) (type_ I64)))
       (((name h) (type_ I64)) ((name t4) (type_ I64)))
       (((name h) (type_ I64)) ((name t5) (type_ I64))))
      |}]
;;

let%expect_test "borked" =
  compile_and_lower ~arch:`X86_64 ~system ~opt_flags:Eir.Opt_flags.no_opt borked
  |> print_endline;
  [%expect
    {|
    .intel_syntax noprefix
    .text
    .globl _root
    _root:
      push rbp
      mov rbp, rsp
      push r15
      sub rsp, 8
    root___root:
      push 8
      push 7
      mov rdi, 1
      mov rsi, 2
      mov rdx, 3
      mov rcx, 4
      mov r8, 5
      mov r9, 6
      call _sum8
      mov r15, rax
      add rsp, 16
      mov rax, r15
    root__root__epilogue:
      sub rbp, 8
      mov rsp, rbp
      pop r15
      pop rbp
      ret

    .globl _sum8
    _sum8:
      push rbp
      mov rbp, rsp
      push rbx
      push r12
      push r13
      push r14
      push r15
      sub rsp, 8
      mov r13, [rbp + 16]
      mov r14, [rbp + 24]
      mov r15, rdi
      mov rbx, rsi
      mov r10, rcx
      mov r11, r8
      mov r12, r9
    sum8___root:
      add r15, rbx
      add r15, rdx
      add r15, r10
      add r15, r11
      add r15, r12
      add r15, r13
      add r15, r14
      mov rax, r15
    sum8__sum8__epilogue:
      sub rbp, 40
      mov rsp, rbp
      pop r15
      pop r14
      pop r13
      pop r12
      pop rbx
      pop rbp
      ret
    |}]
;;

let%expect_test "debug borked opt ssa" =
  test_ssa ~don't_opt:() borked;
  [%expect
    {|
    (%root
     (instrs
      ((Call (fn sum8) (results (((name res) (type_ I64))))
        (args ((Lit 1) (Lit 2) (Lit 3) (Lit 4) (Lit 5) (Lit 6) (Lit 7) (Lit 8))))
       (Return (Var ((name res) (type_ I64)))))))
    (%root
     (instrs
      ((Add
        ((dest ((name t0) (type_ I64))) (src1 (Var ((name a) (type_ I64))))
         (src2 (Var ((name b) (type_ I64))))))
       (Add
        ((dest ((name t1) (type_ I64))) (src1 (Var ((name t0) (type_ I64))))
         (src2 (Var ((name c) (type_ I64))))))
       (Add
        ((dest ((name t2) (type_ I64))) (src1 (Var ((name t1) (type_ I64))))
         (src2 (Var ((name d) (type_ I64))))))
       (Add
        ((dest ((name t3) (type_ I64))) (src1 (Var ((name t2) (type_ I64))))
         (src2 (Var ((name e) (type_ I64))))))
       (Add
        ((dest ((name t4) (type_ I64))) (src1 (Var ((name t3) (type_ I64))))
         (src2 (Var ((name f) (type_ I64))))))
       (Add
        ((dest ((name t5) (type_ I64))) (src1 (Var ((name t4) (type_ I64))))
         (src2 (Var ((name g) (type_ I64))))))
       (Add
        ((dest ((name t6) (type_ I64))) (src1 (Var ((name t5) (type_ I64))))
         (src2 (Var ((name h) (type_ I64))))))
       (Return (Var ((name t6) (type_ I64)))))))
    =================================
    (%root (args ())
     (instrs
      ((Call (fn sum8) (results (((name res) (type_ I64))))
        (args ((Lit 1) (Lit 2) (Lit 3) (Lit 4) (Lit 5) (Lit 6) (Lit 7) (Lit 8))))
       (Return (Var ((name res) (type_ I64)))))))
    (%root
     (args
      (((name a) (type_ I64)) ((name b) (type_ I64)) ((name c) (type_ I64))
       ((name d) (type_ I64)) ((name e) (type_ I64)) ((name f) (type_ I64))
       ((name g) (type_ I64)) ((name h) (type_ I64))))
     (instrs
      ((Add
        ((dest ((name t0) (type_ I64))) (src1 (Var ((name a) (type_ I64))))
         (src2 (Var ((name b) (type_ I64))))))
       (Add
        ((dest ((name t1) (type_ I64))) (src1 (Var ((name t0) (type_ I64))))
         (src2 (Var ((name c) (type_ I64))))))
       (Add
        ((dest ((name t2) (type_ I64))) (src1 (Var ((name t1) (type_ I64))))
         (src2 (Var ((name d) (type_ I64))))))
       (Add
        ((dest ((name t3) (type_ I64))) (src1 (Var ((name t2) (type_ I64))))
         (src2 (Var ((name e) (type_ I64))))))
       (Add
        ((dest ((name t4) (type_ I64))) (src1 (Var ((name t3) (type_ I64))))
         (src2 (Var ((name f) (type_ I64))))))
       (Add
        ((dest ((name t5) (type_ I64))) (src1 (Var ((name t4) (type_ I64))))
         (src2 (Var ((name g) (type_ I64))))))
       (Add
        ((dest ((name t6) (type_ I64))) (src1 (Var ((name t5) (type_ I64))))
         (src2 (Var ((name h) (type_ I64))))))
       (Return (Var ((name t6) (type_ I64)))))))
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
          (((id (Instr_id 25))
            (ir
             (Arm64
              (Int_binary (op Sub) (dst ((reg SP) (class_ I64)))
               (lhs (Reg ((reg SP) (class_ I64)))) (rhs (Imm 32))))))
           ((id (Instr_id 28))
            (ir
             (Arm64
              (Store (src (Reg ((reg X28) (class_ I64))))
               (addr (Mem ((reg SP) (class_ I64)) 0))))))
           ((id (Instr_id 29))
            (ir
             (Arm64
              (Store (src (Reg ((reg X29) (class_ I64))))
               (addr (Mem ((reg SP) (class_ I64)) 8))))))
           ((id (Instr_id 30))
            (ir
             (Arm64
              (Store (src (Reg ((reg X30) (class_ I64))))
               (addr (Mem ((reg SP) (class_ I64)) 16))))))
           ((id (Instr_id 31))
            (ir
             (Arm64
              (Move (dst ((reg X29) (class_ I64)))
               (src (Reg ((reg SP) (class_ I64))))))))
           ((id (Instr_id 32))
            (ir (Arm64 (Tag_def Nop (Reg ((reg X29) (class_ I64)))))))
           ((id (Instr_id 14))
            (ir (Arm64 (Jump ((block ((id_hum %root) (args ()))) (args ())))))))))
        (%root (args ())
         (instrs
          (((id (Instr_id 13))
            (ir (Arm64 (Move (dst ((reg X0) (class_ I64))) (src (Imm 1))))))
           ((id (Instr_id 12))
            (ir (Arm64 (Move (dst ((reg X1) (class_ I64))) (src (Imm 2))))))
           ((id (Instr_id 11))
            (ir (Arm64 (Move (dst ((reg X2) (class_ I64))) (src (Imm 3))))))
           ((id (Instr_id 10))
            (ir (Arm64 (Move (dst ((reg X3) (class_ I64))) (src (Imm 4))))))
           ((id (Instr_id 9))
            (ir (Arm64 (Move (dst ((reg X4) (class_ I64))) (src (Imm 5))))))
           ((id (Instr_id 8))
            (ir (Arm64 (Move (dst ((reg X5) (class_ I64))) (src (Imm 6))))))
           ((id (Instr_id 7))
            (ir (Arm64 (Move (dst ((reg X6) (class_ I64))) (src (Imm 7))))))
           ((id (Instr_id 6))
            (ir (Arm64 (Move (dst ((reg X7) (class_ I64))) (src (Imm 8))))))
           ((id (Instr_id 5))
            (ir
             (Arm64
              (Call (fn sum8) (results (((reg X0) (class_ I64))))
               (args
                ((Imm 1) (Imm 2) (Imm 3) (Imm 4) (Imm 5) (Imm 6) (Imm 7) (Imm 8)))))))
           ((id (Instr_id 0))
            (ir
             (Arm64
              (Move (dst ((reg X28) (class_ I64)))
               (src (Reg ((reg X0) (class_ I64))))))))
           ((id (Instr_id 4))
            (ir
             (Arm64
              (Move (dst ((reg X0) (class_ I64)))
               (src (Reg ((reg X28) (class_ I64))))))))
           ((id (Instr_id 26))
            (ir
             (Arm64_terminal
              ((Jump
                ((block
                  ((id_hum root__epilogue) (args (((name res__0) (type_ I64))))))
                 (args ()))))))))))
        (root__epilogue (args (((name res__0) (type_ I64))))
         (instrs
          (((id (Instr_id 27))
            (ir
             (Arm64
              (Move (dst ((reg X0) (class_ I64)))
               (src (Reg ((reg X0) (class_ I64))))))))
           ((id (Instr_id 33))
            (ir
             (Arm64
              (Move (dst ((reg SP) (class_ I64)))
               (src (Reg ((reg X29) (class_ I64))))))))
           ((id (Instr_id 34))
            (ir
             (Arm64
              (Load (dst ((reg X28) (class_ I64)))
               (addr (Mem ((reg SP) (class_ I64)) 0))))))
           ((id (Instr_id 35))
            (ir
             (Arm64
              (Load (dst ((reg X29) (class_ I64)))
               (addr (Mem ((reg SP) (class_ I64)) 8))))))
           ((id (Instr_id 36))
            (ir
             (Arm64
              (Load (dst ((reg X30) (class_ I64)))
               (addr (Mem ((reg SP) (class_ I64)) 16))))))
           ((id (Instr_id 37))
            (ir
             (Arm64
              (Int_binary (op Add) (dst ((reg SP) (class_ I64)))
               (lhs (Reg ((reg SP) (class_ I64)))) (rhs (Imm 32))))))
           ((id (Instr_id 38))
            (ir (Arm64 (Ret ((Reg ((reg X0) (class_ I64)))))))))))))
      (args ()) (name root) (prologue ()) (epilogue ())
      (bytes_for_clobber_saves 24) (bytes_for_padding 0) (bytes_for_spills 0)
      (bytes_statically_alloca'd 0))
     ((call_conv Default)
      (root
       ((sum8__prologue
         (args
          (((name a0) (type_ I64)) ((name b0) (type_ I64))
           ((name c0) (type_ I64)) ((name d0) (type_ I64))
           ((name e0) (type_ I64)) ((name f0) (type_ I64))
           ((name g0) (type_ I64)) ((name h0) (type_ I64))))
         (instrs
          (((id (Instr_id 30))
            (ir
             (Arm64
              (Int_binary (op Sub) (dst ((reg SP) (class_ I64)))
               (lhs (Reg ((reg SP) (class_ I64)))) (rhs (Imm 80))))))
           ((id (Instr_id 29))
            (ir
             (Arm64
              (Store (src (Reg ((reg X21) (class_ I64))))
               (addr (Mem ((reg SP) (class_ I64)) 0))))))
           ((id (Instr_id 28))
            (ir
             (Arm64
              (Store (src (Reg ((reg X22) (class_ I64))))
               (addr (Mem ((reg SP) (class_ I64)) 8))))))
           ((id (Instr_id 27))
            (ir
             (Arm64
              (Store (src (Reg ((reg X23) (class_ I64))))
               (addr (Mem ((reg SP) (class_ I64)) 16))))))
           ((id (Instr_id 26))
            (ir
             (Arm64
              (Store (src (Reg ((reg X24) (class_ I64))))
               (addr (Mem ((reg SP) (class_ I64)) 24))))))
           ((id (Instr_id 25))
            (ir
             (Arm64
              (Store (src (Reg ((reg X25) (class_ I64))))
               (addr (Mem ((reg SP) (class_ I64)) 32))))))
           ((id (Instr_id 24))
            (ir
             (Arm64
              (Store (src (Reg ((reg X26) (class_ I64))))
               (addr (Mem ((reg SP) (class_ I64)) 40))))))
           ((id (Instr_id 12))
            (ir
             (Arm64
              (Store (src (Reg ((reg X27) (class_ I64))))
               (addr (Mem ((reg SP) (class_ I64)) 48))))))
           ((id (Instr_id 13))
            (ir
             (Arm64
              (Store (src (Reg ((reg X28) (class_ I64))))
               (addr (Mem ((reg SP) (class_ I64)) 56))))))
           ((id (Instr_id 14))
            (ir
             (Arm64
              (Store (src (Reg ((reg X29) (class_ I64))))
               (addr (Mem ((reg SP) (class_ I64)) 64))))))
           ((id (Instr_id 15))
            (ir
             (Arm64
              (Move (dst ((reg X29) (class_ I64)))
               (src (Reg ((reg SP) (class_ I64))))))))
           ((id (Instr_id 16))
            (ir
             (Arm64
              (Move (dst ((reg X0) (class_ I64)))
               (src (Reg ((reg X0) (class_ I64))))))))
           ((id (Instr_id 17))
            (ir
             (Arm64
              (Move (dst ((reg X1) (class_ I64)))
               (src (Reg ((reg X1) (class_ I64))))))))
           ((id (Instr_id 18))
            (ir
             (Arm64
              (Move (dst ((reg X2) (class_ I64)))
               (src (Reg ((reg X2) (class_ I64))))))))
           ((id (Instr_id 19))
            (ir
             (Arm64
              (Move (dst ((reg X3) (class_ I64)))
               (src (Reg ((reg X3) (class_ I64))))))))
           ((id (Instr_id 20))
            (ir
             (Arm64
              (Move (dst ((reg X4) (class_ I64)))
               (src (Reg ((reg X4) (class_ I64))))))))
           ((id (Instr_id 36))
            (ir
             (Arm64
              (Move (dst ((reg X5) (class_ I64)))
               (src (Reg ((reg X5) (class_ I64))))))))
           ((id (Instr_id 39))
            (ir
             (Arm64
              (Move (dst ((reg X6) (class_ I64)))
               (src (Reg ((reg X6) (class_ I64))))))))
           ((id (Instr_id 40))
            (ir
             (Arm64
              (Move (dst ((reg X7) (class_ I64)))
               (src (Reg ((reg X7) (class_ I64))))))))
           ((id (Instr_id 41))
            (ir (Arm64 (Tag_def Nop (Reg ((reg X29) (class_ I64)))))))
           ((id (Instr_id 42))
            (ir
             (Arm64
              (Move (dst ((reg X21) (class_ I64)))
               (src (Reg ((reg X0) (class_ I64))))))))
           ((id (Instr_id 43))
            (ir
             (Arm64
              (Move (dst ((reg X28) (class_ I64)))
               (src (Reg ((reg X1) (class_ I64))))))))
           ((id (Instr_id 44))
            (ir
             (Arm64
              (Move (dst ((reg X22) (class_ I64)))
               (src (Reg ((reg X2) (class_ I64))))))))
           ((id (Instr_id 45))
            (ir
             (Arm64
              (Move (dst ((reg X23) (class_ I64)))
               (src (Reg ((reg X3) (class_ I64))))))))
           ((id (Instr_id 46))
            (ir
             (Arm64
              (Move (dst ((reg X24) (class_ I64)))
               (src (Reg ((reg X4) (class_ I64))))))))
           ((id (Instr_id 47))
            (ir
             (Arm64
              (Move (dst ((reg X25) (class_ I64)))
               (src (Reg ((reg X5) (class_ I64))))))))
           ((id (Instr_id 48))
            (ir
             (Arm64
              (Move (dst ((reg X26) (class_ I64)))
               (src (Reg ((reg X6) (class_ I64))))))))
           ((id (Instr_id 49))
            (ir
             (Arm64
              (Move (dst ((reg X27) (class_ I64)))
               (src (Reg ((reg X7) (class_ I64))))))))
           ((id (Instr_id 61))
            (ir
             (Arm64
              (Jump
               ((block
                 ((id_hum %root)
                  (args
                   (((name a) (type_ I64)) ((name b) (type_ I64))
                    ((name c) (type_ I64)) ((name d) (type_ I64))
                    ((name e) (type_ I64)) ((name f) (type_ I64))
                    ((name g) (type_ I64)) ((name h) (type_ I64))))))
                (args ())))))))))
        (%root
         (args
          (((name a) (type_ I64)) ((name b) (type_ I64)) ((name c) (type_ I64))
           ((name d) (type_ I64)) ((name e) (type_ I64)) ((name f) (type_ I64))
           ((name g) (type_ I64)) ((name h) (type_ I64))))
         (instrs
          (((id (Instr_id 37))
            (ir
             (Arm64
              (Int_binary (op Add) (dst ((reg X28) (class_ I64)))
               (lhs (Reg ((reg X21) (class_ I64))))
               (rhs (Reg ((reg X28) (class_ I64))))))))
           ((id (Instr_id 10))
            (ir
             (Arm64
              (Int_binary (op Add) (dst ((reg X28) (class_ I64)))
               (lhs (Reg ((reg X28) (class_ I64))))
               (rhs (Reg ((reg X22) (class_ I64))))))))
           ((id (Instr_id 9))
            (ir
             (Arm64
              (Int_binary (op Add) (dst ((reg X28) (class_ I64)))
               (lhs (Reg ((reg X28) (class_ I64))))
               (rhs (Reg ((reg X23) (class_ I64))))))))
           ((id (Instr_id 0))
            (ir
             (Arm64
              (Int_binary (op Add) (dst ((reg X28) (class_ I64)))
               (lhs (Reg ((reg X28) (class_ I64))))
               (rhs (Reg ((reg X24) (class_ I64))))))))
           ((id (Instr_id 1))
            (ir
             (Arm64
              (Int_binary (op Add) (dst ((reg X28) (class_ I64)))
               (lhs (Reg ((reg X28) (class_ I64))))
               (rhs (Reg ((reg X25) (class_ I64))))))))
           ((id (Instr_id 2))
            (ir
             (Arm64
              (Int_binary (op Add) (dst ((reg X28) (class_ I64)))
               (lhs (Reg ((reg X28) (class_ I64))))
               (rhs (Reg ((reg X26) (class_ I64))))))))
           ((id (Instr_id 3))
            (ir
             (Arm64
              (Int_binary (op Add) (dst ((reg X28) (class_ I64)))
               (lhs (Reg ((reg X28) (class_ I64))))
               (rhs (Reg ((reg X27) (class_ I64))))))))
           ((id (Instr_id 4))
            (ir
             (Arm64
              (Move (dst ((reg X0) (class_ I64)))
               (src (Reg ((reg X28) (class_ I64))))))))
           ((id (Instr_id 62))
            (ir
             (Arm64_terminal
              ((Jump
                ((block
                  ((id_hum sum8__epilogue) (args (((name res__0) (type_ I64))))))
                 (args ()))))))))))
        (sum8__epilogue (args (((name res__0) (type_ I64))))
         (instrs
          (((id (Instr_id 38))
            (ir
             (Arm64
              (Move (dst ((reg X0) (class_ I64)))
               (src (Reg ((reg X0) (class_ I64))))))))
           ((id (Instr_id 50))
            (ir
             (Arm64
              (Move (dst ((reg SP) (class_ I64)))
               (src (Reg ((reg X29) (class_ I64))))))))
           ((id (Instr_id 51))
            (ir
             (Arm64
              (Load (dst ((reg X21) (class_ I64)))
               (addr (Mem ((reg SP) (class_ I64)) 0))))))
           ((id (Instr_id 52))
            (ir
             (Arm64
              (Load (dst ((reg X22) (class_ I64)))
               (addr (Mem ((reg SP) (class_ I64)) 8))))))
           ((id (Instr_id 53))
            (ir
             (Arm64
              (Load (dst ((reg X23) (class_ I64)))
               (addr (Mem ((reg SP) (class_ I64)) 16))))))
           ((id (Instr_id 54))
            (ir
             (Arm64
              (Load (dst ((reg X24) (class_ I64)))
               (addr (Mem ((reg SP) (class_ I64)) 24))))))
           ((id (Instr_id 55))
            (ir
             (Arm64
              (Load (dst ((reg X25) (class_ I64)))
               (addr (Mem ((reg SP) (class_ I64)) 32))))))
           ((id (Instr_id 56))
            (ir
             (Arm64
              (Load (dst ((reg X26) (class_ I64)))
               (addr (Mem ((reg SP) (class_ I64)) 40))))))
           ((id (Instr_id 57))
            (ir
             (Arm64
              (Load (dst ((reg X27) (class_ I64)))
               (addr (Mem ((reg SP) (class_ I64)) 48))))))
           ((id (Instr_id 58))
            (ir
             (Arm64
              (Load (dst ((reg X28) (class_ I64)))
               (addr (Mem ((reg SP) (class_ I64)) 56))))))
           ((id (Instr_id 59))
            (ir
             (Arm64
              (Load (dst ((reg X29) (class_ I64)))
               (addr (Mem ((reg SP) (class_ I64)) 64))))))
           ((id (Instr_id 60))
            (ir
             (Arm64
              (Int_binary (op Add) (dst ((reg SP) (class_ I64)))
               (lhs (Reg ((reg SP) (class_ I64)))) (rhs (Imm 80))))))
           ((id (Instr_id 63))
            (ir (Arm64 (Ret ((Reg ((reg X0) (class_ I64)))))))))))))
      (args
       (((name a) (type_ I64)) ((name b) (type_ I64)) ((name c) (type_ I64))
        ((name d) (type_ I64)) ((name e) (type_ I64)) ((name f) (type_ I64))
        ((name g) (type_ I64)) ((name h) (type_ I64))))
      (name sum8) (prologue ()) (epilogue ()) (bytes_for_clobber_saves 72)
      (bytes_for_padding 0) (bytes_for_spills 0) (bytes_statically_alloca'd 0)))
    |}]
;;

let%expect_test "debug borked" =
  match Nod.compile ~opt_flags:Eir.Opt_flags.no_opt borked with
  | Error e -> Nod_error.to_string e |> print_endline
  | Ok program ->
    (match arch with
     | `X86_64 ->
       X86_backend.For_testing.print_selected_instructions
         program.Program.functions
     | `Arm64 ->
       Arm64_backend.For_testing.print_selected_instructions
         program.Program.functions
     | `Other -> failwith "unexpected arch");
    [%expect
      {|
      (block ("Block.id_hum block" root__prologue))
      +--------------------------------------------------------+------------+
      | ir                                                     | Ir.defs ir |
      +--------------------------------------------------------+------------+
      | (Arm64(Tag_def Nop(Reg((reg X29)(class_ I64)))))       | {}         |
      +--------------------------------------------------------+------------+
      | (Arm64(Jump((block((id_hum %root)(args())))(args())))) | {}         |
      +--------------------------------------------------------+------------+
      (block ("Block.id_hum block" %root))
      +---------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | ir                                                                                                                                                                        | Ir.defs ir                               |
      +---------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | {Arm64,Save_clobbers}                                                                                                                                                     | {}                                       |
      +---------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (Arm64(Move(dst((reg(Allocated((name arg_reg)(type_ I64))(X0)))(class_ I64)))(src(Imm 1))))                                                                               | (((name arg_reg)(type_ I64)))            |
      +---------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (Arm64(Move(dst((reg(Allocated((name arg_reg0)(type_ I64))(X1)))(class_ I64)))(src(Imm 2))))                                                                              | (((name arg_reg0)(type_ I64)))           |
      +---------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (Arm64(Move(dst((reg(Allocated((name arg_reg1)(type_ I64))(X2)))(class_ I64)))(src(Imm 3))))                                                                              | (((name arg_reg1)(type_ I64)))           |
      +---------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (Arm64(Move(dst((reg(Allocated((name arg_reg2)(type_ I64))(X3)))(class_ I64)))(src(Imm 4))))                                                                              | (((name arg_reg2)(type_ I64)))           |
      +---------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (Arm64(Move(dst((reg(Allocated((name arg_reg3)(type_ I64))(X4)))(class_ I64)))(src(Imm 5))))                                                                              | (((name arg_reg3)(type_ I64)))           |
      +---------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (Arm64(Move(dst((reg(Allocated((name arg_reg4)(type_ I64))(X5)))(class_ I64)))(src(Imm 6))))                                                                              | (((name arg_reg4)(type_ I64)))           |
      +---------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (Arm64(Move(dst((reg(Allocated((name arg_reg5)(type_ I64))(X6)))(class_ I64)))(src(Imm 7))))                                                                              | (((name arg_reg5)(type_ I64)))           |
      +---------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (Arm64(Move(dst((reg(Allocated((name arg_reg6)(type_ I64))(X7)))(class_ I64)))(src(Imm 8))))                                                                              | (((name arg_reg6)(type_ I64)))           |
      +---------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (Arm64(Call(fn sum8)(results(((reg(Allocated((name tmp_force_physical)(type_ I64))(X0)))(class_ I64))))(args((Imm 1)(Imm 2)(Imm 3)(Imm 4)(Imm 5)(Imm 6)(Imm 7)(Imm 8))))) | (((name tmp_force_physical)(type_ I64))) |
      +---------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (Arm64(Move(dst((reg(Unallocated((name res)(type_ I64))))(class_ I64)))(src(Reg((reg(Allocated((name tmp_force_physical)(type_ I64))(X0)))(class_ I64))))))               | (((name res)(type_ I64)))                |
      +---------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | {Arm64,Restore_clobbers}                                                                                                                                                  | {}                                       |
      +---------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (Arm64(Move(dst((reg(Unallocated((name res__0)(type_ I64))))(class_ I64)))(src(Reg((reg(Unallocated((name res)(type_ I64))))(class_ I64))))))                             | (((name res__0)(type_ I64)))             |
      +---------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (Arm64_terminal((Jump((block((id_hum root__epilogue)(args(((name res__0)(type_ I64))))))(args(((name res)(type_ I64))))))))                                               | {}                                       |
      +---------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      (block ("Block.id_hum block" root__epilogue))
      +----------------------------------------------------------------------------------------------------------------+------------+
      | ir                                                                                                             | Ir.defs ir |
      +----------------------------------------------------------------------------------------------------------------+------------+
      | (Arm64(Move(dst((reg X0)(class_ I64)))(src(Reg((reg(Allocated((name res__0)(type_ I64))(X0)))(class_ I64)))))) | {}         |
      +----------------------------------------------------------------------------------------------------------------+------------+
      | (Arm64(Ret((Reg((reg(Allocated((name res__0)(type_ I64))(X0)))(class_ I64))))))                                | {}         |
      +----------------------------------------------------------------------------------------------------------------+------------+
      (block ("Block.id_hum block" sum8__prologue))
      +----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------+
      | ir                                                                                                                                                                                                                                                                                                                                                                                                             | Ir.defs ir               |
      +----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------+
      | (Arm64(Move(dst((reg(Allocated((name a0)(type_ I64))(X0)))(class_ I64)))(src(Reg((reg X0)(class_ I64))))))                                                                                                                                                                                                                                                                                                     | (((name a0)(type_ I64))) |
      +----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------+
      | (Arm64(Move(dst((reg(Allocated((name b0)(type_ I64))(X1)))(class_ I64)))(src(Reg((reg X1)(class_ I64))))))                                                                                                                                                                                                                                                                                                     | (((name b0)(type_ I64))) |
      +----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------+
      | (Arm64(Move(dst((reg(Allocated((name c0)(type_ I64))(X2)))(class_ I64)))(src(Reg((reg X2)(class_ I64))))))                                                                                                                                                                                                                                                                                                     | (((name c0)(type_ I64))) |
      +----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------+
      | (Arm64(Move(dst((reg(Allocated((name d0)(type_ I64))(X3)))(class_ I64)))(src(Reg((reg X3)(class_ I64))))))                                                                                                                                                                                                                                                                                                     | (((name d0)(type_ I64))) |
      +----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------+
      | (Arm64(Move(dst((reg(Allocated((name e0)(type_ I64))(X4)))(class_ I64)))(src(Reg((reg X4)(class_ I64))))))                                                                                                                                                                                                                                                                                                     | (((name e0)(type_ I64))) |
      +----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------+
      | (Arm64(Move(dst((reg(Allocated((name f0)(type_ I64))(X5)))(class_ I64)))(src(Reg((reg X5)(class_ I64))))))                                                                                                                                                                                                                                                                                                     | (((name f0)(type_ I64))) |
      +----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------+
      | (Arm64(Move(dst((reg(Allocated((name g0)(type_ I64))(X6)))(class_ I64)))(src(Reg((reg X6)(class_ I64))))))                                                                                                                                                                                                                                                                                                     | (((name g0)(type_ I64))) |
      +----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------+
      | (Arm64(Move(dst((reg(Allocated((name h0)(type_ I64))(X7)))(class_ I64)))(src(Reg((reg X7)(class_ I64))))))                                                                                                                                                                                                                                                                                                     | (((name h0)(type_ I64))) |
      +----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------+
      | (Arm64(Tag_def Nop(Reg((reg X29)(class_ I64)))))                                                                                                                                                                                                                                                                                                                                                               | {}                       |
      +----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------+
      | (Arm64(Move(dst((reg(Unallocated((name a)(type_ I64))))(class_ I64)))(src(Reg((reg(Unallocated((name a0)(type_ I64))))(class_ I64))))))                                                                                                                                                                                                                                                                        | (((name a)(type_ I64)))  |
      +----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------+
      | (Arm64(Move(dst((reg(Unallocated((name b)(type_ I64))))(class_ I64)))(src(Reg((reg(Unallocated((name b0)(type_ I64))))(class_ I64))))))                                                                                                                                                                                                                                                                        | (((name b)(type_ I64)))  |
      +----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------+
      | (Arm64(Move(dst((reg(Unallocated((name c)(type_ I64))))(class_ I64)))(src(Reg((reg(Unallocated((name c0)(type_ I64))))(class_ I64))))))                                                                                                                                                                                                                                                                        | (((name c)(type_ I64)))  |
      +----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------+
      | (Arm64(Move(dst((reg(Unallocated((name d)(type_ I64))))(class_ I64)))(src(Reg((reg(Unallocated((name d0)(type_ I64))))(class_ I64))))))                                                                                                                                                                                                                                                                        | (((name d)(type_ I64)))  |
      +----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------+
      | (Arm64(Move(dst((reg(Unallocated((name e)(type_ I64))))(class_ I64)))(src(Reg((reg(Unallocated((name e0)(type_ I64))))(class_ I64))))))                                                                                                                                                                                                                                                                        | (((name e)(type_ I64)))  |
      +----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------+
      | (Arm64(Move(dst((reg(Unallocated((name f)(type_ I64))))(class_ I64)))(src(Reg((reg(Unallocated((name f0)(type_ I64))))(class_ I64))))))                                                                                                                                                                                                                                                                        | (((name f)(type_ I64)))  |
      +----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------+
      | (Arm64(Move(dst((reg(Unallocated((name g)(type_ I64))))(class_ I64)))(src(Reg((reg(Unallocated((name g0)(type_ I64))))(class_ I64))))))                                                                                                                                                                                                                                                                        | (((name g)(type_ I64)))  |
      +----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------+
      | (Arm64(Move(dst((reg(Unallocated((name h)(type_ I64))))(class_ I64)))(src(Reg((reg(Unallocated((name h0)(type_ I64))))(class_ I64))))))                                                                                                                                                                                                                                                                        | (((name h)(type_ I64)))  |
      +----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------+
      | (Arm64(Jump((block((id_hum %root)(args(((name a)(type_ I64))((name b)(type_ I64))((name c)(type_ I64))((name d)(type_ I64))((name e)(type_ I64))((name f)(type_ I64))((name g)(type_ I64))((name h)(type_ I64))))))(args(((name a0)(type_ I64))((name b0)(type_ I64))((name c0)(type_ I64))((name d0)(type_ I64))((name e0)(type_ I64))((name f0)(type_ I64))((name g0)(type_ I64))((name h0)(type_ I64))))))) | {}                       |
      +----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------+
      (block ("Block.id_hum block" %root))
      +-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------+
      | ir                                                                                                                                                                                                                    | Ir.defs ir                   |
      +-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------+
      | (Arm64(Int_binary(op Add)(dst((reg(Unallocated((name t0)(type_ I64))))(class_ I64)))(lhs(Reg((reg(Unallocated((name a)(type_ I64))))(class_ I64))))(rhs(Reg((reg(Unallocated((name b)(type_ I64))))(class_ I64))))))  | (((name t0)(type_ I64)))     |
      +-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------+
      | (Arm64(Int_binary(op Add)(dst((reg(Unallocated((name t1)(type_ I64))))(class_ I64)))(lhs(Reg((reg(Unallocated((name t0)(type_ I64))))(class_ I64))))(rhs(Reg((reg(Unallocated((name c)(type_ I64))))(class_ I64)))))) | (((name t1)(type_ I64)))     |
      +-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------+
      | (Arm64(Int_binary(op Add)(dst((reg(Unallocated((name t2)(type_ I64))))(class_ I64)))(lhs(Reg((reg(Unallocated((name t1)(type_ I64))))(class_ I64))))(rhs(Reg((reg(Unallocated((name d)(type_ I64))))(class_ I64)))))) | (((name t2)(type_ I64)))     |
      +-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------+
      | (Arm64(Int_binary(op Add)(dst((reg(Unallocated((name t3)(type_ I64))))(class_ I64)))(lhs(Reg((reg(Unallocated((name t2)(type_ I64))))(class_ I64))))(rhs(Reg((reg(Unallocated((name e)(type_ I64))))(class_ I64)))))) | (((name t3)(type_ I64)))     |
      +-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------+
      | (Arm64(Int_binary(op Add)(dst((reg(Unallocated((name t4)(type_ I64))))(class_ I64)))(lhs(Reg((reg(Unallocated((name t3)(type_ I64))))(class_ I64))))(rhs(Reg((reg(Unallocated((name f)(type_ I64))))(class_ I64)))))) | (((name t4)(type_ I64)))     |
      +-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------+
      | (Arm64(Int_binary(op Add)(dst((reg(Unallocated((name t5)(type_ I64))))(class_ I64)))(lhs(Reg((reg(Unallocated((name t4)(type_ I64))))(class_ I64))))(rhs(Reg((reg(Unallocated((name g)(type_ I64))))(class_ I64)))))) | (((name t5)(type_ I64)))     |
      +-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------+
      | (Arm64(Int_binary(op Add)(dst((reg(Unallocated((name t6)(type_ I64))))(class_ I64)))(lhs(Reg((reg(Unallocated((name t5)(type_ I64))))(class_ I64))))(rhs(Reg((reg(Unallocated((name h)(type_ I64))))(class_ I64)))))) | (((name t6)(type_ I64)))     |
      +-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------+
      | (Arm64(Move(dst((reg(Unallocated((name res__0)(type_ I64))))(class_ I64)))(src(Reg((reg(Unallocated((name t6)(type_ I64))))(class_ I64))))))                                                                          | (((name res__0)(type_ I64))) |
      +-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------+
      | (Arm64_terminal((Jump((block((id_hum sum8__epilogue)(args(((name res__0)(type_ I64))))))(args(((name t6)(type_ I64))))))))                                                                                            | {}                           |
      +-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------+
      (block ("Block.id_hum block" sum8__epilogue))
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
  | Ok program ->
    (match arch with
     | `X86_64 ->
       X86_backend.For_testing.print_selected_instructions
         program.Program.functions
     | `Arm64 ->
       Arm64_backend.For_testing.print_selected_instructions
         program.Program.functions
     | `Other -> failwith "unexpected arch");
    [%expect
      {|
      (block ("Block.id_hum block" root__prologue))
      +--------------------------------------------------------+------------+
      | ir                                                     | Ir.defs ir |
      +--------------------------------------------------------+------------+
      | (Arm64(Tag_def Nop(Reg((reg X29)(class_ I64)))))       | {}         |
      +--------------------------------------------------------+------------+
      | (Arm64(Jump((block((id_hum %root)(args())))(args())))) | {}         |
      +--------------------------------------------------------+------------+
      (block ("Block.id_hum block" %root))
      +---------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | ir                                                                                                                                                                        | Ir.defs ir                               |
      +---------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | {Arm64,Save_clobbers}                                                                                                                                                     | {}                                       |
      +---------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (Arm64(Move(dst((reg(Allocated((name arg_reg)(type_ I64))(X0)))(class_ I64)))(src(Imm 1))))                                                                               | (((name arg_reg)(type_ I64)))            |
      +---------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (Arm64(Move(dst((reg(Allocated((name arg_reg0)(type_ I64))(X1)))(class_ I64)))(src(Imm 2))))                                                                              | (((name arg_reg0)(type_ I64)))           |
      +---------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (Arm64(Move(dst((reg(Allocated((name arg_reg1)(type_ I64))(X2)))(class_ I64)))(src(Imm 3))))                                                                              | (((name arg_reg1)(type_ I64)))           |
      +---------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (Arm64(Move(dst((reg(Allocated((name arg_reg2)(type_ I64))(X3)))(class_ I64)))(src(Imm 4))))                                                                              | (((name arg_reg2)(type_ I64)))           |
      +---------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (Arm64(Move(dst((reg(Allocated((name arg_reg3)(type_ I64))(X4)))(class_ I64)))(src(Imm 5))))                                                                              | (((name arg_reg3)(type_ I64)))           |
      +---------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (Arm64(Move(dst((reg(Allocated((name arg_reg4)(type_ I64))(X5)))(class_ I64)))(src(Imm 6))))                                                                              | (((name arg_reg4)(type_ I64)))           |
      +---------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (Arm64(Move(dst((reg(Allocated((name arg_reg5)(type_ I64))(X6)))(class_ I64)))(src(Imm 7))))                                                                              | (((name arg_reg5)(type_ I64)))           |
      +---------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (Arm64(Move(dst((reg(Allocated((name arg_reg6)(type_ I64))(X7)))(class_ I64)))(src(Imm 8))))                                                                              | (((name arg_reg6)(type_ I64)))           |
      +---------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (Arm64(Call(fn sum8)(results(((reg(Allocated((name tmp_force_physical)(type_ I64))(X0)))(class_ I64))))(args((Imm 1)(Imm 2)(Imm 3)(Imm 4)(Imm 5)(Imm 6)(Imm 7)(Imm 8))))) | (((name tmp_force_physical)(type_ I64))) |
      +---------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (Arm64(Move(dst((reg(Unallocated((name res)(type_ I64))))(class_ I64)))(src(Reg((reg(Allocated((name tmp_force_physical)(type_ I64))(X0)))(class_ I64))))))               | (((name res)(type_ I64)))                |
      +---------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | {Arm64,Restore_clobbers}                                                                                                                                                  | {}                                       |
      +---------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (Arm64(Move(dst((reg(Unallocated((name res__0)(type_ I64))))(class_ I64)))(src(Reg((reg(Unallocated((name res)(type_ I64))))(class_ I64))))))                             | (((name res__0)(type_ I64)))             |
      +---------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      | (Arm64_terminal((Jump((block((id_hum root__epilogue)(args(((name res__0)(type_ I64))))))(args(((name res)(type_ I64))))))))                                               | {}                                       |
      +---------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------+
      (block ("Block.id_hum block" root__epilogue))
      +----------------------------------------------------------------------------------------------------------------+------------+
      | ir                                                                                                             | Ir.defs ir |
      +----------------------------------------------------------------------------------------------------------------+------------+
      | (Arm64(Move(dst((reg X0)(class_ I64)))(src(Reg((reg(Allocated((name res__0)(type_ I64))(X0)))(class_ I64)))))) | {}         |
      +----------------------------------------------------------------------------------------------------------------+------------+
      | (Arm64(Ret((Reg((reg(Allocated((name res__0)(type_ I64))(X0)))(class_ I64))))))                                | {}         |
      +----------------------------------------------------------------------------------------------------------------+------------+
      (block ("Block.id_hum block" sum8__prologue))
      +----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------+
      | ir                                                                                                                                                                                                                                                                                                                                                                                                             | Ir.defs ir               |
      +----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------+
      | (Arm64(Move(dst((reg(Allocated((name a0)(type_ I64))(X0)))(class_ I64)))(src(Reg((reg X0)(class_ I64))))))                                                                                                                                                                                                                                                                                                     | (((name a0)(type_ I64))) |
      +----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------+
      | (Arm64(Move(dst((reg(Allocated((name b0)(type_ I64))(X1)))(class_ I64)))(src(Reg((reg X1)(class_ I64))))))                                                                                                                                                                                                                                                                                                     | (((name b0)(type_ I64))) |
      +----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------+
      | (Arm64(Move(dst((reg(Allocated((name c0)(type_ I64))(X2)))(class_ I64)))(src(Reg((reg X2)(class_ I64))))))                                                                                                                                                                                                                                                                                                     | (((name c0)(type_ I64))) |
      +----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------+
      | (Arm64(Move(dst((reg(Allocated((name d0)(type_ I64))(X3)))(class_ I64)))(src(Reg((reg X3)(class_ I64))))))                                                                                                                                                                                                                                                                                                     | (((name d0)(type_ I64))) |
      +----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------+
      | (Arm64(Move(dst((reg(Allocated((name e0)(type_ I64))(X4)))(class_ I64)))(src(Reg((reg X4)(class_ I64))))))                                                                                                                                                                                                                                                                                                     | (((name e0)(type_ I64))) |
      +----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------+
      | (Arm64(Move(dst((reg(Allocated((name f0)(type_ I64))(X5)))(class_ I64)))(src(Reg((reg X5)(class_ I64))))))                                                                                                                                                                                                                                                                                                     | (((name f0)(type_ I64))) |
      +----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------+
      | (Arm64(Move(dst((reg(Allocated((name g0)(type_ I64))(X6)))(class_ I64)))(src(Reg((reg X6)(class_ I64))))))                                                                                                                                                                                                                                                                                                     | (((name g0)(type_ I64))) |
      +----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------+
      | (Arm64(Move(dst((reg(Allocated((name h0)(type_ I64))(X7)))(class_ I64)))(src(Reg((reg X7)(class_ I64))))))                                                                                                                                                                                                                                                                                                     | (((name h0)(type_ I64))) |
      +----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------+
      | (Arm64(Tag_def Nop(Reg((reg X29)(class_ I64)))))                                                                                                                                                                                                                                                                                                                                                               | {}                       |
      +----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------+
      | (Arm64(Move(dst((reg(Unallocated((name a)(type_ I64))))(class_ I64)))(src(Reg((reg(Unallocated((name a0)(type_ I64))))(class_ I64))))))                                                                                                                                                                                                                                                                        | (((name a)(type_ I64)))  |
      +----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------+
      | (Arm64(Move(dst((reg(Unallocated((name b)(type_ I64))))(class_ I64)))(src(Reg((reg(Unallocated((name b0)(type_ I64))))(class_ I64))))))                                                                                                                                                                                                                                                                        | (((name b)(type_ I64)))  |
      +----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------+
      | (Arm64(Move(dst((reg(Unallocated((name c)(type_ I64))))(class_ I64)))(src(Reg((reg(Unallocated((name c0)(type_ I64))))(class_ I64))))))                                                                                                                                                                                                                                                                        | (((name c)(type_ I64)))  |
      +----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------+
      | (Arm64(Move(dst((reg(Unallocated((name d)(type_ I64))))(class_ I64)))(src(Reg((reg(Unallocated((name d0)(type_ I64))))(class_ I64))))))                                                                                                                                                                                                                                                                        | (((name d)(type_ I64)))  |
      +----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------+
      | (Arm64(Move(dst((reg(Unallocated((name e)(type_ I64))))(class_ I64)))(src(Reg((reg(Unallocated((name e0)(type_ I64))))(class_ I64))))))                                                                                                                                                                                                                                                                        | (((name e)(type_ I64)))  |
      +----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------+
      | (Arm64(Move(dst((reg(Unallocated((name f)(type_ I64))))(class_ I64)))(src(Reg((reg(Unallocated((name f0)(type_ I64))))(class_ I64))))))                                                                                                                                                                                                                                                                        | (((name f)(type_ I64)))  |
      +----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------+
      | (Arm64(Move(dst((reg(Unallocated((name g)(type_ I64))))(class_ I64)))(src(Reg((reg(Unallocated((name g0)(type_ I64))))(class_ I64))))))                                                                                                                                                                                                                                                                        | (((name g)(type_ I64)))  |
      +----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------+
      | (Arm64(Move(dst((reg(Unallocated((name h)(type_ I64))))(class_ I64)))(src(Reg((reg(Unallocated((name h0)(type_ I64))))(class_ I64))))))                                                                                                                                                                                                                                                                        | (((name h)(type_ I64)))  |
      +----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------+
      | (Arm64(Jump((block((id_hum %root)(args(((name a)(type_ I64))((name b)(type_ I64))((name c)(type_ I64))((name d)(type_ I64))((name e)(type_ I64))((name f)(type_ I64))((name g)(type_ I64))((name h)(type_ I64))))))(args(((name a0)(type_ I64))((name b0)(type_ I64))((name c0)(type_ I64))((name d0)(type_ I64))((name e0)(type_ I64))((name f0)(type_ I64))((name g0)(type_ I64))((name h0)(type_ I64))))))) | {}                       |
      +----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------+
      (block ("Block.id_hum block" %root))
      +-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------+
      | ir                                                                                                                                                                                                                    | Ir.defs ir                   |
      +-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------+
      | (Arm64(Int_binary(op Add)(dst((reg(Unallocated((name t0)(type_ I64))))(class_ I64)))(lhs(Reg((reg(Unallocated((name a)(type_ I64))))(class_ I64))))(rhs(Reg((reg(Unallocated((name b)(type_ I64))))(class_ I64))))))  | (((name t0)(type_ I64)))     |
      +-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------+
      | (Arm64(Int_binary(op Add)(dst((reg(Unallocated((name t1)(type_ I64))))(class_ I64)))(lhs(Reg((reg(Unallocated((name t0)(type_ I64))))(class_ I64))))(rhs(Reg((reg(Unallocated((name c)(type_ I64))))(class_ I64)))))) | (((name t1)(type_ I64)))     |
      +-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------+
      | (Arm64(Int_binary(op Add)(dst((reg(Unallocated((name t2)(type_ I64))))(class_ I64)))(lhs(Reg((reg(Unallocated((name t1)(type_ I64))))(class_ I64))))(rhs(Reg((reg(Unallocated((name d)(type_ I64))))(class_ I64)))))) | (((name t2)(type_ I64)))     |
      +-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------+
      | (Arm64(Int_binary(op Add)(dst((reg(Unallocated((name t3)(type_ I64))))(class_ I64)))(lhs(Reg((reg(Unallocated((name t2)(type_ I64))))(class_ I64))))(rhs(Reg((reg(Unallocated((name e)(type_ I64))))(class_ I64)))))) | (((name t3)(type_ I64)))     |
      +-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------+
      | (Arm64(Int_binary(op Add)(dst((reg(Unallocated((name t4)(type_ I64))))(class_ I64)))(lhs(Reg((reg(Unallocated((name t3)(type_ I64))))(class_ I64))))(rhs(Reg((reg(Unallocated((name f)(type_ I64))))(class_ I64)))))) | (((name t4)(type_ I64)))     |
      +-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------+
      | (Arm64(Int_binary(op Add)(dst((reg(Unallocated((name t5)(type_ I64))))(class_ I64)))(lhs(Reg((reg(Unallocated((name t4)(type_ I64))))(class_ I64))))(rhs(Reg((reg(Unallocated((name g)(type_ I64))))(class_ I64)))))) | (((name t5)(type_ I64)))     |
      +-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------+
      | (Arm64(Int_binary(op Add)(dst((reg(Unallocated((name t6)(type_ I64))))(class_ I64)))(lhs(Reg((reg(Unallocated((name t5)(type_ I64))))(class_ I64))))(rhs(Reg((reg(Unallocated((name h)(type_ I64))))(class_ I64)))))) | (((name t6)(type_ I64)))     |
      +-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------+
      | (Arm64(Move(dst((reg(Unallocated((name res__0)(type_ I64))))(class_ I64)))(src(Reg((reg(Unallocated((name t6)(type_ I64))))(class_ I64))))))                                                                          | (((name res__0)(type_ I64))) |
      +-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------+
      | (Arm64_terminal((Jump((block((id_hum sum8__epilogue)(args(((name res__0)(type_ I64))))))(args(((name t6)(type_ I64))))))))                                                                                            | {}                           |
      +-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------+
      (block ("Block.id_hum block" sum8__epilogue))
      +----------------------------------------------------------------------------------------------------------------+------------+
      | ir                                                                                                             | Ir.defs ir |
      +----------------------------------------------------------------------------------------------------------------+------------+
      | (Arm64(Move(dst((reg X0)(class_ I64)))(src(Reg((reg(Allocated((name res__0)(type_ I64))(X0)))(class_ I64)))))) | {}         |
      +----------------------------------------------------------------------------------------------------------------+------------+
      | (Arm64(Ret((Reg((reg(Allocated((name res__0)(type_ I64))(X0)))(class_ I64))))))                                | {}         |
      +----------------------------------------------------------------------------------------------------------------+------------+
      |}]
;;
