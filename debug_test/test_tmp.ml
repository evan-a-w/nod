open! Core
open! Import

let map_function_roots ~f program = Program.map_function_roots program ~f

let create_block state ~id_hum ~terminal =
  let terminal = Ssa_state.alloc_instr state ~ir:terminal in
  let block = Block.create ~id_hum ~terminal in
  Ssa_state.register_instr state block.Block.terminal;
  block
;;

let append_ir state block ir = ignore (Ssa_state.append_ir state ~block ~ir)

let test_cfg s =
  let state = State.create () in
  s
  |> Parser.parse_string
  |> Result.map ~f:(fun program ->
    Program.map_function_roots_with_name program ~f:(fun ~name root ->
      let fn_state = State.ensure_function state name in
      Cfg.process ~state:fn_state root))
  |> function
  | Error e -> Nod_error.to_string e |> print_endline
  | Ok program ->
    Map.iter
      program.Program.functions
      ~f:(fun { Function.root = ~root:_, ~blocks:_, ~in_order:blocks; _ } ->
        Vec.iter blocks ~f:(fun block ->
          let instrs =
            Block.instrs_to_ir_list block @ [ block.terminal.ir ]
          in
          print_s [%message block.id_hum (instrs : Ir.t list)]))
;;

let test_ssa ?don't_opt s =
  test_cfg s;
  print_endline "=================================";
  let state = State.create () in
  Parser.parse_string s
  |> Result.map ~f:(fun program ->
    Program.map_function_roots_with_name program ~f:(fun ~name root ->
      let fn_state = State.ensure_function state name in
      Cfg.process ~state:fn_state root))
  |> Result.map ~f:(Eir.set_entry_block_args ~state)
  |> Result.map ~f:(Program.map_function_roots_with_name ~f:(fun ~name root ->
         let fn_state = State.state_for_function state name in
         Ssa.create ~state:fn_state root))
  |> function
  | Error e -> Nod_error.to_string e |> print_endline
  | Ok program ->
    let go program =
      Map.iter
        program.Program.functions
        ~f:(fun { Function.root = (ssa : Ssa.t); _ } ->
          Vec.iter ssa.in_order ~f:(fun block ->
            let instrs = Block.instrs_to_ir_list block @ [ block.terminal.ir ] in
            print_s
              [%message
                block.id_hum
                  ~args:(block.args : Var.t Vec.t)
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
    ~state
    functions
    =
    let asm =
      Nod.compile_and_lower_functions ~arch ~system:host_system ~state functions
    in
    Nod.execute_asm ~arch ~system:host_system ~harness asm
  in
  let run_functions ?harness mk_functions expected =
    List.iter test_architectures ~f:(function
      | (`X86_64 | `Arm64) as arch ->
        let state, functions = mk_functions arch in
        let output = execute_functions ~arch ?harness ~state functions in
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
  let make_fn ~state ~name ~args ~root =
    (* Mirror [Eir.set_entry_block_args] for hand-constructed CFGs. *)
    let old_args = Vec.to_list root.Block.args in
    List.iter args ~f:(Vec.push root.Block.args);
    Ssa_state.update_block_args state ~block:root ~old_args ~new_args:args;
    root.dfs_id <- Some 0;
    Function.create ~name ~args ~root
  in
  let mk_functions (_arch : [ `X86_64 | `Arm64 ]) =
    let state = State.create () in
    let child_state = State.ensure_function state "child" in
    let root_state = State.ensure_function state "root" in
    let p = Var.create ~name:"p" ~type_:Type.Ptr in
    let loaded = Var.create ~name:"loaded" ~type_:Type.I64 in
    let child_root =
      create_block
        child_state
        ~id_hum:"%root"
        ~terminal:(Ir.return (Ir.Lit_or_var.Var loaded))
    in
    append_ir
      child_state
      child_root
      (Ir.load loaded (Ir.Mem.address (Ir.Lit_or_var.Var p)));
    let child = make_fn ~state:child_state ~name:"child" ~args:[ p ] ~root:child_root in
    let slot = Var.create ~name:"slot" ~type_:Type.Ptr in
    let res = Var.create ~name:"res" ~type_:Type.I64 in
    let root_root =
      create_block
        root_state
        ~id_hum:"%root"
        ~terminal:(Ir.return (Ir.Lit_or_var.Var res))
    in
    append_ir
      root_state
      root_root
      (Ir.alloca { dest = slot; size = Ir.Lit_or_var.Lit 8L });
    append_ir
      root_state
      root_root
      (Ir.store
         (Ir.Lit_or_var.Lit 41L)
         (Ir.Mem.address (Ir.Lit_or_var.Var slot)));
    append_ir
      root_state
      root_root
      (Ir.call ~fn:"child" ~results:[ res ] ~args:[ Ir.Lit_or_var.Var slot ]);
    let root = make_fn ~state:root_state ~name:"root" ~args:[] ~root:root_root in
    state, String.Map.of_alist_exn [ "root", root; "child", child ]
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
  let make_fn ~state ~name ~args ~root =
    (* Mirror [Eir.set_entry_block_args] for hand-constructed CFGs. *)
    let old_args = Vec.to_list root.Block.args in
    List.iter args ~f:(Vec.push root.Block.args);
    Ssa_state.update_block_args state ~block:root ~old_args ~new_args:args;
    root.dfs_id <- Some 0;
    Function.create ~name ~args ~root
  in
  let state = State.create () in
  let child_state = State.ensure_function state "child" in
  let root_state = State.ensure_function state "root" in
  let p = Var.create ~name:"p" ~type_:Type.Ptr in
  let loaded = Var.create ~name:"loaded" ~type_:Type.I64 in
  let child_root =
    create_block
      child_state
      ~id_hum:"%root"
      ~terminal:(Ir.return (Ir.Lit_or_var.Var loaded))
  in
  append_ir
    child_state
    child_root
    (Ir.load loaded (Ir.Mem.address (Ir.Lit_or_var.Var p)));
    let child = make_fn ~state:child_state ~name:"child" ~args:[ p ] ~root:child_root in
  let slot = Var.create ~name:"slot" ~type_:Type.Ptr in
  let res = Var.create ~name:"res" ~type_:Type.I64 in
  let root_root =
    create_block
      root_state
      ~id_hum:"%root"
      ~terminal:(Ir.return (Ir.Lit_or_var.Var res))
  in
  append_ir
    root_state
    root_root
    (Ir.alloca { dest = slot; size = Ir.Lit_or_var.Lit 8L });
  append_ir
    root_state
    root_root
    (Ir.store (Ir.Lit_or_var.Lit 41L) (Ir.Mem.address (Ir.Lit_or_var.Var slot)));
  append_ir
    root_state
    root_root
    (Ir.call ~fn:"child" ~results:[ res ] ~args:[ Ir.Lit_or_var.Var slot ]);
  let root = make_fn ~state:root_state ~name:"root" ~args:[] ~root:root_root in
  let functions = String.Map.of_alist_exn [ "root", root; "child", child ] in
  print_s [%sexp (functions : Function.t String.Map.t)];
  [%expect {|
    ((child
      ((call_conv Default)
       (root
        ((%root (args (((name p) (type_ Ptr))))
          (instrs
           ((Load ((name loaded) (type_ I64))
             (Address ((base (Var ((name p) (type_ Ptr)))) (offset 0))))
            (Return (Var ((name loaded) (type_ I64)))))))))
       (args (((name p) (type_ Ptr)))) (name child) (prologue ()) (epilogue ())
       (bytes_for_clobber_saves 0) (bytes_for_padding 0) (bytes_for_spills 0)
       (bytes_statically_alloca'd 0)))
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
  | Ok { program; state } ->
    (match arch with
     | `X86_64 ->
       let x86 =
         X86_backend.compile ?dump_crap ~state program.Program.functions
       in
       print_s
         [%sexp
           (Map.data x86 |> List.map ~f:Function.to_sexp_verbose : Sexp.t list)]
     | `Arm64 ->
       let arm64 =
         Arm64_backend.compile ?dump_crap ~state program.Program.functions
       in
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
  | Ok { program; state } ->
    (match arch with
     | `X86_64 ->
       X86_backend.For_testing.print_assignments
         ~state
         program.Program.functions
     | `Arm64 ->
       Arm64_backend.For_testing.print_assignments
         ~state
         program.Program.functions
     | `Other -> failwith "unecpected arch");
    [%expect {|
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
  [%expect {|
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
  [%expect {|
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
  [%expect {|
    (((call_conv Default)
      (root
       ((root__prologue (args ())
         (instrs
          ((Arm64
            (Int_binary (op Sub) (dst ((reg SP) (class_ I64)))
             (lhs (Reg ((reg SP) (class_ I64)))) (rhs (Imm 32))))
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
           (Arm64 (Tag_def Nop (Reg ((reg X29) (class_ I64)))))
           (Arm64 (Jump ((block ((id_hum %root) (args ()))) (args ())))))))
        (%root (args ())
         (instrs
          ((Arm64 (Move (dst ((reg X0) (class_ I64))) (src (Imm 1))))
           (Arm64 (Move (dst ((reg X1) (class_ I64))) (src (Imm 2))))
           (Arm64 (Move (dst ((reg X2) (class_ I64))) (src (Imm 3))))
           (Arm64 (Move (dst ((reg X3) (class_ I64))) (src (Imm 4))))
           (Arm64 (Move (dst ((reg X4) (class_ I64))) (src (Imm 5))))
           (Arm64 (Move (dst ((reg X5) (class_ I64))) (src (Imm 6))))
           (Arm64 (Move (dst ((reg X6) (class_ I64))) (src (Imm 7))))
           (Arm64 (Move (dst ((reg X7) (class_ I64))) (src (Imm 8))))
           (Arm64
            (Call (fn sum8) (results (((reg X0) (class_ I64))))
             (args
              ((Imm 1) (Imm 2) (Imm 3) (Imm 4) (Imm 5) (Imm 6) (Imm 7) (Imm 8)))))
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
            (Load (dst ((reg X28) (class_ I64)))
             (addr (Mem ((reg SP) (class_ I64)) 0))))
           (Arm64
            (Load (dst ((reg X29) (class_ I64)))
             (addr (Mem ((reg SP) (class_ I64)) 8))))
           (Arm64
            (Load (dst ((reg X30) (class_ I64)))
             (addr (Mem ((reg SP) (class_ I64)) 16))))
           (Arm64
            (Int_binary (op Add) (dst ((reg SP) (class_ I64)))
             (lhs (Reg ((reg SP) (class_ I64)))) (rhs (Imm 32))))
           (Arm64 (Ret ((Reg ((reg X0) (class_ I64)))))))))))
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
          ((Arm64
            (Int_binary (op Sub) (dst ((reg SP) (class_ I64)))
             (lhs (Reg ((reg SP) (class_ I64)))) (rhs (Imm 80))))
           (Arm64
            (Store (src (Reg ((reg X21) (class_ I64))))
             (addr (Mem ((reg SP) (class_ I64)) 0))))
           (Arm64
            (Store (src (Reg ((reg X22) (class_ I64))))
             (addr (Mem ((reg SP) (class_ I64)) 8))))
           (Arm64
            (Store (src (Reg ((reg X23) (class_ I64))))
             (addr (Mem ((reg SP) (class_ I64)) 16))))
           (Arm64
            (Store (src (Reg ((reg X24) (class_ I64))))
             (addr (Mem ((reg SP) (class_ I64)) 24))))
           (Arm64
            (Store (src (Reg ((reg X25) (class_ I64))))
             (addr (Mem ((reg SP) (class_ I64)) 32))))
           (Arm64
            (Store (src (Reg ((reg X26) (class_ I64))))
             (addr (Mem ((reg SP) (class_ I64)) 40))))
           (Arm64
            (Store (src (Reg ((reg X27) (class_ I64))))
             (addr (Mem ((reg SP) (class_ I64)) 48))))
           (Arm64
            (Store (src (Reg ((reg X28) (class_ I64))))
             (addr (Mem ((reg SP) (class_ I64)) 56))))
           (Arm64
            (Store (src (Reg ((reg X29) (class_ I64))))
             (addr (Mem ((reg SP) (class_ I64)) 64))))
           (Arm64
            (Move (dst ((reg X29) (class_ I64)))
             (src (Reg ((reg SP) (class_ I64))))))
           (Arm64
            (Move (dst ((reg X0) (class_ I64)))
             (src (Reg ((reg X0) (class_ I64))))))
           (Arm64
            (Move (dst ((reg X1) (class_ I64)))
             (src (Reg ((reg X1) (class_ I64))))))
           (Arm64
            (Move (dst ((reg X2) (class_ I64)))
             (src (Reg ((reg X2) (class_ I64))))))
           (Arm64
            (Move (dst ((reg X3) (class_ I64)))
             (src (Reg ((reg X3) (class_ I64))))))
           (Arm64
            (Move (dst ((reg X4) (class_ I64)))
             (src (Reg ((reg X4) (class_ I64))))))
           (Arm64
            (Move (dst ((reg X5) (class_ I64)))
             (src (Reg ((reg X5) (class_ I64))))))
           (Arm64
            (Move (dst ((reg X6) (class_ I64)))
             (src (Reg ((reg X6) (class_ I64))))))
           (Arm64
            (Move (dst ((reg X7) (class_ I64)))
             (src (Reg ((reg X7) (class_ I64))))))
           (Arm64 (Tag_def Nop (Reg ((reg X29) (class_ I64)))))
           (Arm64
            (Move (dst ((reg X21) (class_ I64)))
             (src (Reg ((reg X0) (class_ I64))))))
           (Arm64
            (Move (dst ((reg X28) (class_ I64)))
             (src (Reg ((reg X1) (class_ I64))))))
           (Arm64
            (Move (dst ((reg X22) (class_ I64)))
             (src (Reg ((reg X2) (class_ I64))))))
           (Arm64
            (Move (dst ((reg X23) (class_ I64)))
             (src (Reg ((reg X3) (class_ I64))))))
           (Arm64
            (Move (dst ((reg X24) (class_ I64)))
             (src (Reg ((reg X4) (class_ I64))))))
           (Arm64
            (Move (dst ((reg X25) (class_ I64)))
             (src (Reg ((reg X5) (class_ I64))))))
           (Arm64
            (Move (dst ((reg X26) (class_ I64)))
             (src (Reg ((reg X6) (class_ I64))))))
           (Arm64
            (Move (dst ((reg X27) (class_ I64)))
             (src (Reg ((reg X7) (class_ I64))))))
           (Arm64
            (Jump
             ((block
               ((id_hum %root)
                (args
                 (((name a) (type_ I64)) ((name b) (type_ I64))
                  ((name c) (type_ I64)) ((name d) (type_ I64))
                  ((name e) (type_ I64)) ((name f) (type_ I64))
                  ((name g) (type_ I64)) ((name h) (type_ I64))))))
              (args ())))))))
        (%root
         (args
          (((name a) (type_ I64)) ((name b) (type_ I64)) ((name c) (type_ I64))
           ((name d) (type_ I64)) ((name e) (type_ I64)) ((name f) (type_ I64))
           ((name g) (type_ I64)) ((name h) (type_ I64))))
         (instrs
          ((Arm64
            (Int_binary (op Add) (dst ((reg X28) (class_ I64)))
             (lhs (Reg ((reg X21) (class_ I64))))
             (rhs (Reg ((reg X28) (class_ I64))))))
           (Arm64
            (Int_binary (op Add) (dst ((reg X28) (class_ I64)))
             (lhs (Reg ((reg X28) (class_ I64))))
             (rhs (Reg ((reg X22) (class_ I64))))))
           (Arm64
            (Int_binary (op Add) (dst ((reg X28) (class_ I64)))
             (lhs (Reg ((reg X28) (class_ I64))))
             (rhs (Reg ((reg X23) (class_ I64))))))
           (Arm64
            (Int_binary (op Add) (dst ((reg X28) (class_ I64)))
             (lhs (Reg ((reg X28) (class_ I64))))
             (rhs (Reg ((reg X24) (class_ I64))))))
           (Arm64
            (Int_binary (op Add) (dst ((reg X28) (class_ I64)))
             (lhs (Reg ((reg X28) (class_ I64))))
             (rhs (Reg ((reg X25) (class_ I64))))))
           (Arm64
            (Int_binary (op Add) (dst ((reg X28) (class_ I64)))
             (lhs (Reg ((reg X28) (class_ I64))))
             (rhs (Reg ((reg X26) (class_ I64))))))
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
                ((id_hum sum8__epilogue) (args (((name res__0) (type_ I64))))))
               (args ()))))))))
        (sum8__epilogue (args (((name res__0) (type_ I64))))
         (instrs
          ((Arm64
            (Move (dst ((reg X0) (class_ I64)))
             (src (Reg ((reg X0) (class_ I64))))))
           (Arm64
            (Move (dst ((reg SP) (class_ I64)))
             (src (Reg ((reg X29) (class_ I64))))))
           (Arm64
            (Load (dst ((reg X21) (class_ I64)))
             (addr (Mem ((reg SP) (class_ I64)) 0))))
           (Arm64
            (Load (dst ((reg X22) (class_ I64)))
             (addr (Mem ((reg SP) (class_ I64)) 8))))
           (Arm64
            (Load (dst ((reg X23) (class_ I64)))
             (addr (Mem ((reg SP) (class_ I64)) 16))))
           (Arm64
            (Load (dst ((reg X24) (class_ I64)))
             (addr (Mem ((reg SP) (class_ I64)) 24))))
           (Arm64
            (Load (dst ((reg X25) (class_ I64)))
             (addr (Mem ((reg SP) (class_ I64)) 32))))
           (Arm64
            (Load (dst ((reg X26) (class_ I64)))
             (addr (Mem ((reg SP) (class_ I64)) 40))))
           (Arm64
            (Load (dst ((reg X27) (class_ I64)))
             (addr (Mem ((reg SP) (class_ I64)) 48))))
           (Arm64
            (Load (dst ((reg X28) (class_ I64)))
             (addr (Mem ((reg SP) (class_ I64)) 56))))
           (Arm64
            (Load (dst ((reg X29) (class_ I64)))
             (addr (Mem ((reg SP) (class_ I64)) 64))))
           (Arm64
            (Int_binary (op Add) (dst ((reg SP) (class_ I64)))
             (lhs (Reg ((reg SP) (class_ I64)))) (rhs (Imm 80))))
           (Arm64 (Ret ((Reg ((reg X0) (class_ I64)))))))))))
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
  | Ok { program; state } ->
    (match arch with
     | `X86_64 ->
       X86_backend.For_testing.print_selected_instructions
         ~state
         program.Program.functions
     | `Arm64 ->
       Arm64_backend.For_testing.print_selected_instructions
         ~state
         program.Program.functions
     | `Other -> failwith "unexpected arch");
    [%expect {|
      (block (block.id_hum root__prologue))
      +--------------------------------------------------------+------------+
      | ir                                                     | Ir.defs ir |
      +--------------------------------------------------------+------------+
      | (Arm64(Tag_def Nop(Reg((reg X29)(class_ I64)))))       | {}         |
      +--------------------------------------------------------+------------+
      | (Arm64(Jump((block((id_hum %root)(args())))(args())))) | {}         |
      +--------------------------------------------------------+------------+
      (block (block.id_hum %root))
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
      (block (block.id_hum root__epilogue))
      +----------------------------------------------------------------------------------------------------------------+------------+
      | ir                                                                                                             | Ir.defs ir |
      +----------------------------------------------------------------------------------------------------------------+------------+
      | (Arm64(Move(dst((reg X0)(class_ I64)))(src(Reg((reg(Allocated((name res__0)(type_ I64))(X0)))(class_ I64)))))) | {}         |
      +----------------------------------------------------------------------------------------------------------------+------------+
      | (Arm64(Ret((Reg((reg(Allocated((name res__0)(type_ I64))(X0)))(class_ I64))))))                                | {}         |
      +----------------------------------------------------------------------------------------------------------------+------------+
      (block (block.id_hum sum8__prologue))
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
      (block (block.id_hum %root))
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
      (block (block.id_hum sum8__epilogue))
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
  | Ok { program; state } ->
    (match arch with
     | `X86_64 ->
       X86_backend.For_testing.print_selected_instructions
         ~state
         program.Program.functions
     | `Arm64 ->
       Arm64_backend.For_testing.print_selected_instructions
         ~state
         program.Program.functions
     | `Other -> failwith "unexpected arch");
    [%expect {|
      (block (block.id_hum root__prologue))
      +--------------------------------------------------------+------------+
      | ir                                                     | Ir.defs ir |
      +--------------------------------------------------------+------------+
      | (Arm64(Tag_def Nop(Reg((reg X29)(class_ I64)))))       | {}         |
      +--------------------------------------------------------+------------+
      | (Arm64(Jump((block((id_hum %root)(args())))(args())))) | {}         |
      +--------------------------------------------------------+------------+
      (block (block.id_hum %root))
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
      (block (block.id_hum root__epilogue))
      +----------------------------------------------------------------------------------------------------------------+------------+
      | ir                                                                                                             | Ir.defs ir |
      +----------------------------------------------------------------------------------------------------------------+------------+
      | (Arm64(Move(dst((reg X0)(class_ I64)))(src(Reg((reg(Allocated((name res__0)(type_ I64))(X0)))(class_ I64)))))) | {}         |
      +----------------------------------------------------------------------------------------------------------------+------------+
      | (Arm64(Ret((Reg((reg(Allocated((name res__0)(type_ I64))(X0)))(class_ I64))))))                                | {}         |
      +----------------------------------------------------------------------------------------------------------------+------------+
      (block (block.id_hum sum8__prologue))
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
      (block (block.id_hum %root))
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
      (block (block.id_hum sum8__epilogue))
      +----------------------------------------------------------------------------------------------------------------+------------+
      | ir                                                                                                             | Ir.defs ir |
      +----------------------------------------------------------------------------------------------------------------+------------+
      | (Arm64(Move(dst((reg X0)(class_ I64)))(src(Reg((reg(Allocated((name res__0)(type_ I64))(X0)))(class_ I64)))))) | {}         |
      +----------------------------------------------------------------------------------------------------------------+------------+
      | (Arm64(Ret((Reg((reg(Allocated((name res__0)(type_ I64))(X0)))(class_ I64))))))                                | {}         |
      +----------------------------------------------------------------------------------------------------------------+------------+
      |}]
;;
