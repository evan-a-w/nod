open Core
open Nod_core

let quote_command prog args =
  String.concat ~sep:" " (Filename.quote prog :: List.map args ~f:Filename.quote)
;;

let run_shell_exn ~cwd command =
  match Stdlib.Sys.command (sprintf "cd %s && %s" (Filename.quote cwd) command) with
  | 0 -> ()
  | code -> failwith (sprintf "command failed (%d): %s" code command)
;;

let run_program asm =
  let temp_dir = Core_unix.mkdtemp "arm-test" in
  Exn.protect
    ~f:(fun () ->
      let asm_path = Filename.concat temp_dir "program.s" in
      Out_channel.write_all asm_path ~data:asm;
      let harness_path = Filename.concat temp_dir "main.c" in
      Out_channel.write_all
        harness_path
        ~data:
          "#include <stdint.h>\n#include <stdio.h>\nextern int64_t root(void);\nint main(void){ printf(\"%lld\\n\", (long long)root()); return 0;}\n";
      run_shell_exn
        ~cwd:temp_dir
        (quote_command
           "clang"
           [ "-arch"
           ; "arm64"
           ; "-target"
           ; "arm64-apple-macos11"
           ; "program.s"
           ; "main.c"
           ; "-o"
           ; "program"
           ]);
      run_shell_exn ~cwd:temp_dir (sprintf "%s > out" (quote_command "./program" []));
      In_channel.read_all (Filename.concat temp_dir "out") |> String.strip)
    ~finally:(fun () -> ignore (Stdlib.Sys.command (quote_command "rm" [ "-rf"; temp_dir ])))
;;

let make_fn ~name ~args ~root =
  List.iter args ~f:(Vec.push root.Block.args);
  root.Block.dfs_id <- Some 0;
  Function.create ~name ~args ~root
;;

let () =
  let p = Var.create ~name:"p" ~type_:Type.Ptr in
  let loaded = Var.create ~name:"loaded" ~type_:Type.I64 in
  let child_root =
    Block.create ~id_hum:"child_root" ~terminal:(Ir.return (Ir.Lit_or_var.Var loaded))
  in
  Vec.push
    child_root.Block.instructions
    (Ir.load loaded (Ir.Mem.Lit_or_var (Ir.Lit_or_var.Var p)));
  let child = make_fn ~name:"child" ~args:[ p ] ~root:child_root in
  let slot = Var.create ~name:"slot" ~type_:Type.Ptr in
  let res = Var.create ~name:"res" ~type_:Type.I64 in
  let root_root =
    Block.create ~id_hum:"root" ~terminal:(Ir.return (Ir.Lit_or_var.Var res))
  in
  Vec.push
    root_root.Block.instructions
    (Ir.alloca { dest = slot; size = Ir.Lit_or_var.Lit 8L });
  Vec.push
    root_root.Block.instructions
    (Ir.store
       (Ir.Lit_or_var.Lit 41L)
       (Ir.Mem.Lit_or_var (Ir.Lit_or_var.Var slot)));
  Vec.push
    root_root.Block.instructions
    (Ir.call ~fn:"child" ~results:[ res ] ~args:[ Ir.Lit_or_var.Var slot ]);
  let root = make_fn ~name:"root" ~args:[] ~root:root_root in
  let functions = String.Map.of_alist_exn [ "root", root; "child", child ] in
  let asm = Nod_arm64_backend.Arm64_backend.compile_to_asm ~system:`Linux functions in
  printf "%s\n" (run_program asm)
;;
