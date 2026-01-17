open! Core
open! Nod_core
open! Nod_common

(* Test basic conversion - disable optimizations to see actual IR *)
let%expect_test "basic conversion to graph ir" =
  let ir_code = {|
main() {
  mov %x:i64, 10
  mov %y:i64, 20
  add %z:i64, %x, %y
  ret %z
}
  |} in
  match Nod.compile ~opt_flags:Eir.Opt_flags.no_opt ir_code with
  | Error e ->
    print_endline "Compile error";
    print_endline (Nod_error.to_string e)
  | Ok compiled ->
    let fn = Map.find_exn compiled.functions "main" in

    (* Convert to Graph IR *)
    let graph_fn = Graph_ir_convert.To_graph.convert_function fn in
    printf "Function: %s\n" graph_fn.name;
    printf "Entry block: %s\n" graph_fn.entry_block.id_hum;
    printf "Number of blocks: %d\n" (List.length graph_fn.blocks);

    (* Count instructions *)
    let instr_count = ref 0 in
    Graph_ir.Func.iter_instrs graph_fn ~f:(fun _instr -> incr instr_count);
    printf "Number of instructions: %d\n" !instr_count;

  [%expect{|
    Function: main
    Entry block: %root
    Number of blocks: 1
    Number of instructions: 3 |}]
;;

(* Test CSE optimization *)
let%expect_test "CSE optimization" =
  let ir_code = {|
main() {
  mov %a:i64, 10
  mov %b:i64, 20
  add %x:i64, %a, %b
  add %y:i64, %a, %b
  add %z:i64, %x, %y
  ret %z
}
  |} in
  match Nod.compile ~opt_flags:Eir.Opt_flags.no_opt ir_code with
  | Error e ->
    print_endline "Compile error";
    print_endline (Nod_error.to_string e)
  | Ok compiled ->
    let fn = Map.find_exn compiled.functions "main" in
    let graph_fn = Graph_ir_convert.To_graph.convert_function fn in

    (* Count instructions before CSE *)
    let count_instrs () =
      let n = ref 0 in
      Graph_ir.Func.iter_instrs graph_fn ~f:(fun _ -> incr n);
      !n
    in

    let before = count_instrs () in
    printf "Instructions before CSE: %d\n" before;

    (* Run CSE *)
    let changed = Graph_ir_opt.CSE.run graph_fn in
    printf "CSE changed: %b\n" changed;

    let after = count_instrs () in
    printf "Instructions after CSE: %d\n" after;
    printf "Instructions eliminated: %d\n" (before - after);

  [%expect{|
    Instructions before CSE: 5
    CSE changed: true
    Instructions after CSE: 4
    Instructions eliminated: 1 |}]
;;

(* Test DCE optimization *)
let%expect_test "DCE optimization" =
  let ir_code = {|
main() {
  mov %a:i64, 10
  mov %b:i64, 20
  add %x:i64, %a, %b
  add %y:i64, %a, %b
  ret %x
}
  |} in
  match Nod.compile ~opt_flags:Eir.Opt_flags.no_opt ir_code with
  | Error e ->
    print_endline "Compile error";
    print_endline (Nod_error.to_string e)
  | Ok compiled ->
    let fn = Map.find_exn compiled.functions "main" in
    let graph_fn = Graph_ir_convert.To_graph.convert_function fn in

    let count_instrs () =
      let n = ref 0 in
      Graph_ir.Func.iter_instrs graph_fn ~f:(fun _ -> incr n);
      !n
    in

    let before = count_instrs () in
    printf "Instructions before DCE: %d\n" before;

    (* Run DCE *)
    let changed = Graph_ir_opt.DCE.run graph_fn in
    printf "DCE changed: %b\n" changed;

    let after = count_instrs () in
    printf "Instructions after DCE: %d\n" after;
    printf "Dead instructions eliminated: %d\n" (before - after);

  [%expect{|
    Instructions before DCE: 4
    DCE changed: true
    Instructions after DCE: 3
    Dead instructions eliminated: 1 |}]
;;

(* Test copy propagation *)
let%expect_test "copy propagation" =
  let ir_code = {|
main() {
  mov %a:i64, 10
  mov %b:i64, %a
  mov %c:i64, %b
  ret %c
}
  |} in
  match Nod.compile ~opt_flags:Eir.Opt_flags.no_opt ir_code with
  | Error e ->
    print_endline "Compile error";
    print_endline (Nod_error.to_string e)
  | Ok compiled ->
    let fn = Map.find_exn compiled.functions "main" in
    let graph_fn = Graph_ir_convert.To_graph.convert_function fn in

    let count_instrs () =
      let n = ref 0 in
      Graph_ir.Func.iter_instrs graph_fn ~f:(fun _ -> incr n);
      !n
    in

    let before = count_instrs () in
    printf "Instructions before copy propagation: %d\n" before;

    (* Run copy propagation *)
    let changed = Graph_ir_opt.CopyProp.run graph_fn in
    printf "Copy propagation changed: %b\n" changed;

    let after = count_instrs () in
    printf "Instructions after copy propagation: %d\n" after;
    printf "Copies eliminated: %d\n" (before - after);

  [%expect{|
    Instructions before copy propagation: 3
    Copy propagation changed: true
    Instructions after copy propagation: 2
    Copies eliminated: 1
    |}]
;;

(* Test full optimization pipeline *)
let%expect_test "full optimization pipeline" =
  let ir_code = {|
main() {
  mov %a:i64, 10
  mov %b:i64, 20
  add %x:i64, %a, %b
  add %y:i64, %a, %b
  mov %copy1:i64, %x
  add %dead:i64, %a, %b
  add %z:i64, %copy1, %y
  ret %z
}
  |} in
  match Nod.compile ~opt_flags:Eir.Opt_flags.no_opt ir_code with
  | Error e ->
    print_endline "Compile error";
    print_endline (Nod_error.to_string e)
  | Ok compiled ->
    let fn = Map.find_exn compiled.functions "main" in
    let graph_fn = Graph_ir_convert.To_graph.convert_function fn in

    let count_instrs () =
      let n = ref 0 in
      Graph_ir.Func.iter_instrs graph_fn ~f:(fun _ -> incr n);
      !n
    in

    let before = count_instrs () in
    printf "Instructions before optimization: %d\n" before;

    (* Run full optimization pipeline *)
    Graph_ir_opt.optimize ~verbose:false graph_fn;

    let after = count_instrs () in
    printf "Instructions after optimization: %d\n" after;
    printf "Total instructions eliminated: %d\n" (before - after);

  [%expect{|
    Instructions before optimization: 7
    Instructions after optimization: 2
    Total instructions eliminated: 5
    |}]
;;
