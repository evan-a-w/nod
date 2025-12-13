open! Core
open! Import

let quote_command prog args =
  String.concat ~sep:" " (Filename.quote prog :: List.map args ~f:Filename.quote)
;;

let run_command_exn ~cwd prog args =
  let command = quote_command prog args in
  match Stdlib.Sys.command (sprintf "cd %s && %s" (Filename.quote cwd) command) with
  | 0 -> ()
  | code -> failwith (sprintf "command failed (%d): %s" code command)
;;

let run_shell_exn ~cwd command =
  match Stdlib.Sys.command (sprintf "cd %s && %s" (Filename.quote cwd) command) with
  | 0 -> ()
  | code -> failwith (sprintf "command failed (%d): %s" code command)
;;

let execute_functions ?(harness = Nod.make_harness_source ()) functions =
  let asm = X86_backend.compile_to_asm functions in
  let temp_dir = Core_unix.mkdtemp "nod-exec-ir" in
  Exn.protect
    ~f:(fun () ->
      let asm_path = Filename.concat temp_dir "program.s" in
      Out_channel.write_all asm_path ~data:asm;
      let harness_path = Filename.concat temp_dir "main.c" in
      Out_channel.write_all harness_path ~data:harness;
      run_command_exn
        ~cwd:temp_dir
        "gcc"
        [ "-Wall"; "-Werror"; "-O0"; "main.c"; "program.s"; "-o"; "program" ];
      let output_file = "stdout.txt" in
      let output_path = Filename.concat temp_dir output_file in
      run_shell_exn
        ~cwd:temp_dir
        (sprintf "%s > %s" (quote_command "./program" []) (Filename.quote output_file));
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
    Block.create ~id_hum:"%root" ~terminal:(Ir.return (Ir.Lit_or_var.Var loaded))
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
    (Ir.store (Ir.Lit_or_var.Lit 41L) (Ir.Mem.Lit_or_var (Ir.Lit_or_var.Var slot)));
  Vec.push
    root_root.instructions
    (Ir.call
       ~fn:"child"
       ~results:[ res ]
       ~args:[ Ir.Lit_or_var.Var slot ]);
  let root = make_fn ~name:"root" ~args:[] ~root:root_root in
  let output =
    execute_functions (String.Map.of_alist_exn [ "root", root; "child", child ])
  in
  print_endline output;
  [%expect {| 41 |}]
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
    (Ir.store
       (Ir.Lit_or_var.Lit 99L)
       (Ir.Mem.Lit_or_var (Ir.Lit_or_var.Var p)));
  Vec.push child_root.instructions (Ir.move child_ret (Ir.Lit_or_var.Lit 0L));
  let child = make_fn ~name:"child" ~args:[ p ] ~root:child_root in
  let slot = Var.create ~name:"slot" ~type_:Type.Ptr in
  let tmp = Var.create ~name:"tmp" ~type_:Type.I64 in
  let loaded = Var.create ~name:"loaded" ~type_:Type.I64 in
  let root_root =
    Block.create ~id_hum:"%root" ~terminal:(Ir.return (Ir.Lit_or_var.Var loaded))
  in
  Vec.push
    root_root.instructions
    (Ir.alloca { dest = slot; size = Ir.Lit_or_var.Lit 8L });
  Vec.push
    root_root.instructions
    (Ir.store (Ir.Lit_or_var.Lit 1L) (Ir.Mem.Lit_or_var (Ir.Lit_or_var.Var slot)));
  Vec.push
    root_root.instructions
    (Ir.call
       ~fn:"child"
       ~results:[ tmp ]
       ~args:[ Ir.Lit_or_var.Var slot ]);
  Vec.push
    root_root.instructions
    (Ir.load loaded (Ir.Mem.Lit_or_var (Ir.Lit_or_var.Var slot)));
  let root = make_fn ~name:"root" ~args:[] ~root:root_root in
  let output =
    execute_functions (String.Map.of_alist_exn [ "root", root; "child", child ])
  in
  print_endline output;
  [%expect {| 99 |}]
;;

let%expect_test "alloca + pointer arithmetic; pass element pointer to child" =
  let p = Var.create ~name:"p" ~type_:Type.Ptr in
  let loaded = Var.create ~name:"loaded" ~type_:Type.I64 in
  let child_root =
    Block.create ~id_hum:"%root" ~terminal:(Ir.return (Ir.Lit_or_var.Var loaded))
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
    (Ir.store (Ir.Lit_or_var.Lit 7L) (Ir.Mem.Lit_or_var (Ir.Lit_or_var.Var base)));
  Vec.push
    root_root.instructions
    (Ir.add
       { dest = elem1
       ; src1 = Ir.Lit_or_var.Var base
       ; src2 = Ir.Lit_or_var.Lit 8L
       });
  Vec.push
    root_root.instructions
    (Ir.store (Ir.Lit_or_var.Lit 123L) (Ir.Mem.Lit_or_var (Ir.Lit_or_var.Var elem1)));
  Vec.push
    root_root.instructions
    (Ir.call ~fn:"child" ~results:[ tmp ] ~args:[ Ir.Lit_or_var.Var elem1 ]);
  Vec.push root_root.instructions (Ir.move res (Ir.Lit_or_var.Var tmp));
  let root = make_fn ~name:"root" ~args:[] ~root:root_root in
  let output =
    execute_functions (String.Map.of_alist_exn [ "root", root; "child", child ])
  in
  print_endline output;
  [%expect {| 123 |}]
;;
