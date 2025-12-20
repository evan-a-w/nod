open! Core
open! Import

let quote_command prog args =
  String.concat ~sep:" " (Filename.quote prog :: List.map args ~f:Filename.quote)
;;

let run_command_exn ~cwd prog args =
  let command = quote_command prog args in
  match
    Stdlib.Sys.command (sprintf "cd %s && %s" (Filename.quote cwd) command)
  with
  | 0 -> ()
  | code -> failwith (sprintf "command failed (%d): %s" code command)
;;

let run_shell_exn ~cwd command =
  match
    Stdlib.Sys.command (sprintf "cd %s && %s" (Filename.quote cwd) command)
  with
  | 0 -> ()
  | code -> failwith (sprintf "command failed (%d): %s" code command)
;;

let execute_functions
  ?(arch = `X86_64)
  ?(harness = Nod.make_harness_source ())
  functions
  =
  let asm =
    X86_backend.compile_to_asm ~system:(Lazy.force Nod.host_system) functions
  in
  let temp_dir = Core_unix.mkdtemp "nod-exec-ir" in
  let host_arch = architecture () in
  let host_sysname =
    String.lowercase (Core_unix.uname () |> Core_unix.Utsname.sysname)
  in
  let needs_x86 = Poly.(arch = `X86_64) in
  let use_rosetta =
    needs_x86 && Poly.(host_arch = `Arm64) && String.equal host_sysname "darwin"
  in
  let compiler =
    match host_sysname with
    | "darwin" -> "clang"
    | _ -> "gcc"
  in
  let arch_args =
    match arch, host_sysname with
    | `X86_64, "darwin" ->
      [ "-arch"; "x86_64"; "-target"; "x86_64-apple-macos11" ]
    | _ -> []
  in
  let run_shell_runtime ~cwd command =
    if use_rosetta
    then (
      let command =
        quote_command "arch" [ "-x86_64"; "/bin/zsh"; "-c"; command ]
      in
      run_shell_exn ~cwd command)
    else run_shell_exn ~cwd command
  in
  Exn.protect
    ~f:(fun () ->
      let asm_path = Filename.concat temp_dir "program.s" in
      Out_channel.write_all asm_path ~data:asm;
      let harness_path = Filename.concat temp_dir "main.c" in
      Out_channel.write_all harness_path ~data:harness;
      (match needs_x86, host_arch with
       | true, _ when Poly.(host_arch <> `X86_64) && not use_rosetta ->
         failwith "x86_64 execution is not supported on this host"
       | _ -> ());
      run_shell_exn
        ~cwd:temp_dir
        (quote_command
           compiler
           ([ "-Wall"; "-Werror"; "-O0" ]
            @ arch_args
            @ [ "main.c"; "program.s"; "-o"; "program" ]));
      let output_file = "stdout.txt" in
      let output_path = Filename.concat temp_dir output_file in
      run_shell_runtime
        ~cwd:temp_dir
        (sprintf
           "%s > %s"
           (quote_command "./program" [])
           (Filename.quote output_file));
      In_channel.read_all output_path |> String.strip)
    ~finally:(fun () ->
      let _ = Stdlib.Sys.command (quote_command "rm" [ "-rf"; temp_dir ]) in
      ())
;;

let make_fn ~name ~args ~root =
  (* Mirror [Eir.set_entry_block_args] for hand-constructed CFGs. *)
  List.iter args ~f:(Vec.push root.Block.args);
  root.dfs_id <- Some 0;
  Function.create ~name ~args ~root
;;

let%expect_test "alloca passed to child; child loads value" =
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
  let output =
    execute_functions (String.Map.of_alist_exn [ "root", root; "child", child ])
  in
  assert (String.equal output "41")
;;

let%expect_test "alloca passed to child; child stores value; parent observes" =
  let p = Var.create ~name:"p" ~type_:Type.Ptr in
  let child_ret = Var.create ~name:"child_ret" ~type_:Type.I64 in
  let child_root =
    Block.create
      ~id_hum:"%root"
      ~terminal:(Ir.return (Ir.Lit_or_var.Var child_ret))
  in
  Vec.push
    child_root.instructions
    (Ir.store (Ir.Lit_or_var.Lit 99L) (Ir.Mem.Lit_or_var (Ir.Lit_or_var.Var p)));
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
       (Ir.Mem.Lit_or_var (Ir.Lit_or_var.Var slot)));
  Vec.push
    root_root.instructions
    (Ir.call ~fn:"child" ~results:[ tmp ] ~args:[ Ir.Lit_or_var.Var slot ]);
  Vec.push
    root_root.instructions
    (Ir.load loaded (Ir.Mem.Lit_or_var (Ir.Lit_or_var.Var slot)));
  let root = make_fn ~name:"root" ~args:[] ~root:root_root in
  let output =
    execute_functions (String.Map.of_alist_exn [ "root", root; "child", child ])
  in
  assert (String.equal output "99")
;;

let%expect_test "alloca + pointer arithmetic; pass element pointer to child" =
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
       (Ir.Mem.Lit_or_var (Ir.Lit_or_var.Var base)));
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
       (Ir.Mem.Lit_or_var (Ir.Lit_or_var.Var elem1)));
  Vec.push
    root_root.instructions
    (Ir.call ~fn:"child" ~results:[ tmp ] ~args:[ Ir.Lit_or_var.Var elem1 ]);
  Vec.push root_root.instructions (Ir.move res (Ir.Lit_or_var.Var tmp));
  let root = make_fn ~name:"root" ~args:[] ~root:root_root in
  let output =
    execute_functions (String.Map.of_alist_exn [ "root", root; "child", child ])
  in
  assert (String.equal output "123")
;;

let%expect_test "call returning two values (RAX/RDX)" =
  let callee_root =
    Block.create
      ~id_hum:"%root"
      ~terminal:
        (Ir.x86_terminal
           [ X86_ir.mov (Reg X86_reg.rax) (Imm 11L)
           ; X86_ir.mov (Reg X86_reg.rdx) (Imm 22L)
           ; X86_ir.RET [ Reg X86_reg.rax; Reg X86_reg.rdx ]
           ])
  in
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
       { dest = sum; src1 = Ir.Lit_or_var.Var r0; src2 = Ir.Lit_or_var.Var r1 });
  let root = Function.create ~name:"root" ~args:[] ~root:root_root in
  let output =
    execute_functions (String.Map.of_alist_exn [ "root", root; "two", callee ])
  in
  assert (String.equal output "33")
;;

let%expect_test "phi/parallel-move cycle: swap two values across edge" =
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
           (Ir.Branch.Uncond { Call_block.block = swap_block; args = [ b; a ] }))
  in
  start.dfs_id <- Some 0;
  Vec.push start.instructions (Ir.move a (Ir.Lit_or_var.Lit 1L));
  Vec.push start.instructions (Ir.move b (Ir.Lit_or_var.Lit 2L));
  Vec.push start.children swap_block;
  Vec.push swap_block.parents start;
  let fn = Function.create ~name:"root" ~args:[] ~root:start in
  let output = execute_functions (String.Map.of_alist_exn [ "root", fn ]) in
  assert (String.equal output "21")
;;
