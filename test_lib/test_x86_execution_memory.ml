open! Core
open! Import

let execute_functions
  ?(arch = `X86_64)
  ?(harness = Nod.make_harness_source ())
  functions
  =
  let asm =
    Nod.compile_and_lower_functions ~arch ~system:host_system functions
  in
  Nod.execute_asm ~arch ~system:host_system ~harness asm
;;

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
;;

let make_fn ~name ~args ~root =
  (* Mirror [Eir.set_entry_block_args] for hand-constructed CFGs. *)
  List.iter args ~f:(Vec.push root.Block.args);
  root.dfs_id <- Some 0;
  Function.create ~name ~args ~root
;;

let%expect_test "alloca passed to child; child loads value" =
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

let%expect_test "alloca passed to child; child stores value; parent observes" =
  let mk_functions (_arch : [ `X86_64 | `Arm64 ]) =
    let p = Var.create ~name:"p" ~type_:Type.Ptr in
    let child_ret = Var.create ~name:"child_ret" ~type_:Type.I64 in
    let child_root =
      Block.create
        ~id_hum:"%root"
        ~terminal:(Ir.return (Ir.Lit_or_var.Var child_ret))
    in
    Vec.push
      child_root.instructions
      (Ir.store (Ir.Lit_or_var.Lit 99L) (Ir.Mem.address (Ir.Lit_or_var.Var p)));
    Vec.push child_root.instructions (Ir.move child_ret (Ir.Lit_or_var.Lit 0L));
    let child = make_fn ~name:"child" ~args:[ p ] ~root:child_root in
    let slot = Var.create ~name:"slot" ~type_:Type.Ptr in
    let tmp = Var.create ~name:"tmp" ~type_:Type.I64 in
    let loaded = Var.create ~name:"loaded" ~type_:Type.I64 in
    let root_root =
      Block.create
        ~id_hum:"%root"
        ~terminal:(Ir.return (Ir.Lit_or_var.Var loaded))
    in
    Vec.push
      root_root.instructions
      (Ir.alloca { dest = slot; size = Ir.Lit_or_var.Lit 8L });
    Vec.push
      root_root.instructions
      (Ir.store
         (Ir.Lit_or_var.Lit 1L)
         (Ir.Mem.address (Ir.Lit_or_var.Var slot)));
    Vec.push
      root_root.instructions
      (Ir.call ~fn:"child" ~results:[ tmp ] ~args:[ Ir.Lit_or_var.Var slot ]);
    Vec.push
      root_root.instructions
      (Ir.load loaded (Ir.Mem.address (Ir.Lit_or_var.Var slot)));
    let root = make_fn ~name:"root" ~args:[] ~root:root_root in
    String.Map.of_alist_exn [ "root", root; "child", child ]
  in
  run_functions mk_functions "99"
;;

let%expect_test "alloca + pointer arithmetic; pass element pointer to child" =
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
    let base = Var.create ~name:"base" ~type_:Type.Ptr in
    let elem1 = Var.create ~name:"elem1" ~type_:Type.Ptr in
    let tmp = Var.create ~name:"tmp" ~type_:Type.I64 in
    let res = Var.create ~name:"res" ~type_:Type.I64 in
    let root_root =
      Block.create ~id_hum:"%root" ~terminal:(Ir.return (Ir.Lit_or_var.Var res))
    in
    Vec.push
      root_root.instructions
      (Ir.alloca { dest = base; size = Ir.Lit_or_var.Lit 16L });
    Vec.push
      root_root.instructions
      (Ir.store
         (Ir.Lit_or_var.Lit 7L)
         (Ir.Mem.address (Ir.Lit_or_var.Var base)));
    Vec.push
      root_root.instructions
      (Ir.add
         { dest = elem1
         ; src1 = Ir.Lit_or_var.Var base
         ; src2 = Ir.Lit_or_var.Lit 8L
         });
    Vec.push
      root_root.instructions
      (Ir.store
         (Ir.Lit_or_var.Lit 123L)
         (Ir.Mem.address (Ir.Lit_or_var.Var elem1)));
    Vec.push
      root_root.instructions
      (Ir.call ~fn:"child" ~results:[ tmp ] ~args:[ Ir.Lit_or_var.Var elem1 ]);
    Vec.push root_root.instructions (Ir.move res (Ir.Lit_or_var.Var tmp));
    let root = make_fn ~name:"root" ~args:[] ~root:root_root in
    String.Map.of_alist_exn [ "root", root; "child", child ]
  in
  run_functions mk_functions "123"
;;

let%expect_test "call returning two values (RAX/RDX)" =
  let mk_functions (arch : [ `X86_64 | `Arm64 ]) =
    let terminal =
      match arch with
      | `X86_64 ->
        Ir.x86_terminal
          [ X86_ir.mov (Reg X86_reg.rax) (Imm 11L)
          ; X86_ir.mov (Reg X86_reg.rdx) (Imm 22L)
          ; X86_ir.RET [ Reg X86_reg.rax; Reg X86_reg.rdx ]
          ]
      | `Arm64 ->
        Ir.arm64_terminal
          [ Arm64_ir.Move { dst = Arm64_reg.x0; src = Arm64_ir.Imm 11L }
          ; Arm64_ir.Move { dst = Arm64_reg.x1; src = Arm64_ir.Imm 22L }
          ; Arm64_ir.Ret
              [ Arm64_ir.Reg Arm64_reg.x0; Arm64_ir.Reg Arm64_reg.x1 ]
          ]
    in
    let callee_root = Block.create ~id_hum:"%root" ~terminal in
    callee_root.dfs_id <- Some 0;
    let callee = Function.create ~name:"two" ~args:[] ~root:callee_root in
    let r0 = Var.create ~name:"r0" ~type_:Type.I64 in
    let r1 = Var.create ~name:"r1" ~type_:Type.I64 in
    let sum = Var.create ~name:"sum" ~type_:Type.I64 in
    let root_root =
      Block.create ~id_hum:"%root" ~terminal:(Ir.return (Ir.Lit_or_var.Var sum))
    in
    root_root.dfs_id <- Some 0;
    Vec.push
      root_root.instructions
      (Ir.call ~fn:"two" ~results:[ r0; r1 ] ~args:[]);
    Vec.push
      root_root.instructions
      (Ir.add
         { dest = sum
         ; src1 = Ir.Lit_or_var.Var r0
         ; src2 = Ir.Lit_or_var.Var r1
         });
    let root = Function.create ~name:"root" ~args:[] ~root:root_root in
    String.Map.of_alist_exn [ "root", root; "two", callee ]
  in
  run_functions mk_functions "33"
;;

let%expect_test "phi/parallel-move cycle: swap two values across edge" =
  let mk_functions (_arch : [ `X86_64 | `Arm64 ]) =
    let a = Var.create ~name:"a" ~type_:Type.I64 in
    let b = Var.create ~name:"b" ~type_:Type.I64 in
    let tmp10 = Var.create ~name:"tmp10" ~type_:Type.I64 in
    let res = Var.create ~name:"res" ~type_:Type.I64 in
    let swap_block =
      Block.create ~id_hum:"swap" ~terminal:(Ir.return (Ir.Lit_or_var.Var res))
    in
    swap_block.dfs_id <- Some 1;
    swap_block.args <- Vec.of_list [ a; b ];
    Vec.push
      swap_block.instructions
      (Ir.mul
         { dest = tmp10
         ; src1 = Ir.Lit_or_var.Var a
         ; src2 = Ir.Lit_or_var.Lit 10L
         });
    Vec.push
      swap_block.instructions
      (Ir.add
         { dest = res
         ; src1 = Ir.Lit_or_var.Var tmp10
         ; src2 = Ir.Lit_or_var.Var b
         });
    let start =
      Block.create
        ~id_hum:"%root"
        ~terminal:
          (Ir.branch
             (Ir.Branch.Uncond
                { Call_block.block = swap_block; args = [ b; a ] }))
    in
    start.dfs_id <- Some 0;
    Vec.push start.instructions (Ir.move a (Ir.Lit_or_var.Lit 1L));
    Vec.push start.instructions (Ir.move b (Ir.Lit_or_var.Lit 2L));
    Vec.push start.children swap_block;
    Vec.push swap_block.parents start;
    let fn = Function.create ~name:"root" ~args:[] ~root:start in
    String.Map.of_alist_exn [ "root", fn ]
  in
  run_functions mk_functions "21"
;;
