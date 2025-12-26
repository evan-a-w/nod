open Core
open Nod

let () =
  let program = Examples.Textual.super_triv in
  match Nod.compile program with
  | Error err -> eprintf "compile error: %s\n" (Nod_common.Nod_error.to_string err)
  | Ok functions ->
    let fn = Map.find_exn functions "root" in
    let fn = Nod_arm64_backend.Instruction_selection.For_testing.run_deebg fn in
    Core.print_s [%sexp (fn : Nod_core.Function.t)]
