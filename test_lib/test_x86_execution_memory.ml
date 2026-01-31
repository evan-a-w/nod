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

let make_fn ~fn_state ~name ~args ~root =
  (* Mirror [Eir.set_entry_block_args] for hand-constructed CFGs. *)
  Fn_state.set_block_args fn_state ~block:root ~args:(Vec.of_list args);
  Block.set_dfs_id root (Some 0);
  Function.create ~name ~args ~root
;;

let mk_block fn_state ~id_hum ~terminal =
  Block.create
    ~id_hum
    ~terminal:
      (Fn_state.alloc_instr fn_state ~ir:(Fn_state.value_ir fn_state terminal))
;;

let mk_block_with_instrs fn_state ~id_hum ~terminal ~instrs =
  let block = mk_block fn_state ~id_hum ~terminal in
  List.iter instrs ~f:(fun ir ->
    Fn_state.append_ir fn_state ~block ~ir:(Fn_state.value_ir fn_state ir));
  block
;;

let%expect_test "alloca passed to child; child loads value" =
  let mk_functions (_arch : [ `X86_64 | `Arm64 ]) =
    let p = Typed_var.create ~name:"p" ~type_:Type.Ptr in
    let loaded = Typed_var.create ~name:"loaded" ~type_:Type.I64 in
    let child_state = Fn_state.create () in
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
    let slot = Typed_var.create ~name:"slot" ~type_:Type.Ptr in
    let res = Typed_var.create ~name:"res" ~type_:Type.I64 in
    let root_state = Fn_state.create () in
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
  run_functions mk_functions "41";
  [%expect {| |}]
;;

let%expect_test "alloca passed to child; child stores value; parent observes" =
  let mk_functions (_arch : [ `X86_64 | `Arm64 ]) =
    let p = Typed_var.create ~name:"p" ~type_:Type.Ptr in
    let child_ret = Typed_var.create ~name:"child_ret" ~type_:Type.I64 in
    let child_state = Fn_state.create () in
    let child_root =
      mk_block_with_instrs
        child_state
        ~id_hum:"%root"
        ~terminal:(Ir.return (Ir.Lit_or_var.Var child_ret))
        ~instrs:
          [ Ir.store
              (Ir.Lit_or_var.Lit 99L)
              (Ir.Mem.address (Ir.Lit_or_var.Var p))
          ; Ir.move child_ret (Ir.Lit_or_var.Lit 0L)
          ]
    in
    let child =
      make_fn ~fn_state:child_state ~name:"child" ~args:[ p ] ~root:child_root
    in
    let slot = Typed_var.create ~name:"slot" ~type_:Type.Ptr in
    let tmp = Typed_var.create ~name:"tmp" ~type_:Type.I64 in
    let loaded = Typed_var.create ~name:"loaded" ~type_:Type.I64 in
    let root_state = Fn_state.create () in
    let root_root =
      mk_block_with_instrs
        root_state
        ~id_hum:"%root"
        ~terminal:(Ir.return (Ir.Lit_or_var.Var loaded))
        ~instrs:
          [ Ir.alloca { dest = slot; size = Ir.Lit_or_var.Lit 8L }
          ; Ir.store
              (Ir.Lit_or_var.Lit 1L)
              (Ir.Mem.address (Ir.Lit_or_var.Var slot))
          ; Ir.call
              ~fn:"child"
              ~results:[ tmp ]
              ~args:[ Ir.Lit_or_var.Var slot ]
          ; Ir.load loaded (Ir.Mem.address (Ir.Lit_or_var.Var slot))
          ]
    in
    let root =
      make_fn ~fn_state:root_state ~name:"root" ~args:[] ~root:root_root
    in
    String.Map.of_alist_exn [ "root", root; "child", child ]
  in
  run_functions mk_functions "99"
;;

let%expect_test "alloca + pointer arithmetic; pass element pointer to child" =
  let mk_functions (_arch : [ `X86_64 | `Arm64 ]) =
    let p = Typed_var.create ~name:"p" ~type_:Type.Ptr in
    let loaded = Typed_var.create ~name:"loaded" ~type_:Type.I64 in
    let child_state = Fn_state.create () in
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
    let base = Typed_var.create ~name:"base" ~type_:Type.Ptr in
    let elem1 = Typed_var.create ~name:"elem1" ~type_:Type.Ptr in
    let tmp = Typed_var.create ~name:"tmp" ~type_:Type.I64 in
    let res = Typed_var.create ~name:"res" ~type_:Type.I64 in
    let root_state = Fn_state.create () in
    let root_root =
      mk_block_with_instrs
        root_state
        ~id_hum:"%root"
        ~terminal:(Ir.return (Ir.Lit_or_var.Var res))
        ~instrs:
          [ Ir.alloca { dest = base; size = Ir.Lit_or_var.Lit 16L }
          ; Ir.store
              (Ir.Lit_or_var.Lit 7L)
              (Ir.Mem.address (Ir.Lit_or_var.Var base))
          ; Ir.add
              { dest = elem1
              ; src1 = Ir.Lit_or_var.Var base
              ; src2 = Ir.Lit_or_var.Lit 8L
              }
          ; Ir.store
              (Ir.Lit_or_var.Lit 123L)
              (Ir.Mem.address (Ir.Lit_or_var.Var elem1))
          ; Ir.call
              ~fn:"child"
              ~results:[ tmp ]
              ~args:[ Ir.Lit_or_var.Var elem1 ]
          ; Ir.move res (Ir.Lit_or_var.Var tmp)
          ]
    in
    let root =
      make_fn ~fn_state:root_state ~name:"root" ~args:[] ~root:root_root
    in
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
          [ X86_ir.mov (Reg Nod_ir.X86_reg.rax) (Imm 11L)
          ; X86_ir.mov (Reg Nod_ir.X86_reg.rdx) (Imm 22L)
          ; X86_ir.RET [ Reg Nod_ir.X86_reg.rax; Reg Nod_ir.X86_reg.rdx ]
          ]
      | `Arm64 ->
        Ir.arm64_terminal
          [ Arm64_ir.Move { dst = Nod_ir.Arm64_reg.x0; src = Arm64_ir.Imm 11L }
          ; Arm64_ir.Move { dst = Nod_ir.Arm64_reg.x1; src = Arm64_ir.Imm 22L }
          ; Arm64_ir.Ret
              [ Arm64_ir.Reg Nod_ir.Arm64_reg.x0
              ; Arm64_ir.Reg Nod_ir.Arm64_reg.x1
              ]
          ]
    in
    let callee_state = Fn_state.create () in
    let callee_root = mk_block callee_state ~id_hum:"%root" ~terminal in
    Block.set_dfs_id callee_root (Some 0);
    let callee = Function.create ~name:"two" ~args:[] ~root:callee_root in
    let r0 = Typed_var.create ~name:"r0" ~type_:Type.I64 in
    let r1 = Typed_var.create ~name:"r1" ~type_:Type.I64 in
    let sum = Typed_var.create ~name:"sum" ~type_:Type.I64 in
    let root_state = Fn_state.create () in
    let root_root =
      mk_block_with_instrs
        root_state
        ~id_hum:"%root"
        ~terminal:(Ir.return (Ir.Lit_or_var.Var sum))
        ~instrs:
          [ Ir.call ~fn:"two" ~results:[ r0; r1 ] ~args:[]
          ; Ir.add
              { dest = sum
              ; src1 = Ir.Lit_or_var.Var r0
              ; src2 = Ir.Lit_or_var.Var r1
              }
          ]
    in
    Block.set_dfs_id root_root (Some 0);
    let root = Function.create ~name:"root" ~args:[] ~root:root_root in
    String.Map.of_alist_exn [ "root", root; "two", callee ]
  in
  run_functions mk_functions "33"
;;

let%expect_test "phi/parallel-move cycle: swap two values across edge" =
  let mk_functions (_arch : [ `X86_64 | `Arm64 ]) =
    let fn_state = Fn_state.create () in
    let a = Typed_var.create ~name:"a" ~type_:Type.I64 in
    let b = Typed_var.create ~name:"b" ~type_:Type.I64 in
    let tmp10 = Typed_var.create ~name:"tmp10" ~type_:Type.I64 in
    let res = Typed_var.create ~name:"res" ~type_:Type.I64 in
    let swap_block =
      Block.create
        ~id_hum:"swap"
        ~terminal:
          (Fn_state.alloc_instr
             fn_state
             ~ir:
               (Fn_state.value_ir fn_state (Ir.return (Ir.Lit_or_var.Var res))))
    in
    Block.set_dfs_id swap_block (Some 1);
    Fn_state.set_block_args
      fn_state
      ~block:swap_block
      ~args:(Vec.of_list [ a; b ]);
    Fn_state.append_ir
      fn_state
      ~block:swap_block
      ~ir:
        (Fn_state.value_ir
           fn_state
           (Ir.mul
              { dest = tmp10
              ; src1 = Ir.Lit_or_var.Var a
              ; src2 = Ir.Lit_or_var.Lit 10L
              }));
    Fn_state.append_ir
      fn_state
      ~block:swap_block
      ~ir:
        (Fn_state.value_ir
           fn_state
           (Ir.add
              { dest = res
              ; src1 = Ir.Lit_or_var.Var tmp10
              ; src2 = Ir.Lit_or_var.Var b
              }));
    let start =
      Block.create
        ~id_hum:"%root"
        ~terminal:
          (Fn_state.alloc_instr
             fn_state
             ~ir:
               (Fn_state.value_ir
                  fn_state
                  (Ir.branch
                     (Ir.Branch.Uncond
                        { Call_block.block = swap_block; args = [ b; a ] }))))
    in
    Block.set_dfs_id start (Some 0);
    Fn_state.append_ir
      fn_state
      ~block:start
      ~ir:(Fn_state.value_ir fn_state (Ir.move a (Ir.Lit_or_var.Lit 1L)));
    Fn_state.append_ir
      fn_state
      ~block:start
      ~ir:(Fn_state.value_ir fn_state (Ir.move b (Ir.Lit_or_var.Lit 2L)));
    Block.Expert.add_child start ~child:swap_block;
    let fn = Function.create ~name:"root" ~args:[] ~root:start in
    String.Map.of_alist_exn [ "root", fn ]
  in
  run_functions mk_functions "21"
;;
