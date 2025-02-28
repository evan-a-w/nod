open! Core

module Triv_instr = struct
  type t = int
end

module Ir = Ir.Make (struct
    module Instr = Triv_instr
  end)

let make instrs =
  { Ir.Block.parents = Vec.create ()
  ; children = Vec.create ()
  ; instructions = Vec.of_list instrs
  ; dfs_id = None
  ; terminal = 0
  }
;;

let simple_graph () =
  let things = Array.init 6 ~f:(fun i -> make [ i + 1 ]) in
  let edges = [ 1, 2; 2, 3; 2, 4; 3, 5; 4, 5; 5, 2; 2, 6 ] in
  List.iter edges ~f:(fun (a, b) ->
    Vec.push things.(a - 1).children things.(b - 1);
    Vec.push things.(b - 1).parents things.(a - 1));
  things
;;

let%expect_test "dfs" =
  let things = simple_graph () in
  let _st = Ir.Dominator.dfs things.(0) in
  Array.iteri things ~f:(fun i block ->
    let num = Option.value_exn block.Ir.Block.dfs_id in
    print_endline [%string {|Block %{i + 1#Int}: %{num#Int}|}]);
  [%expect
    {|
    Block 1: 0
    Block 2: 1
    Block 3: 2
    Block 4: 4
    Block 5: 3
    Block 6: 5
    |}]
;;

let%expect_test "dominator" =
  let things = simple_graph () in
  let st = Ir.Dominator.run things.(0) in
  let block_number block = Vec.get block.Ir.Block.instructions 0 in
  Array.iter things ~f:(fun block ->
    let dom =
      Vec.get st.Ir.Dominator.dom (Option.value_exn block.Ir.Block.dfs_id)
    in
    let dom_block = Vec.get st.blocks dom in
    print_endline
      [%string
        {|Block %{block_number block#Int}: dominator is Block %{block_number dom_block#Int}|}]);
  [%expect {|
    Block 1: dominator is Block 1
    Block 2: dominator is Block 1
    Block 3: dominator is Block 2
    Block 4: dominator is Block 2
    Block 5: dominator is Block 2
    Block 6: dominator is Block 2
    |}]
;;
