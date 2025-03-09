open! Core

module Triv_instr = struct
  type t = int

  let defs _ = []
  let uses _ = []
  let map_uses t ~f:_ = t
  let map_defs t ~f:_ = t
  let add_block_args t = t
end

module Ir = Initial_transform.Make (struct
    module Instr = Triv_instr
  end)

let make instrs =
  { args = Vec.create ()
  ; Block.parents = Vec.create ()
  ; children = Vec.create ()
  ; instructions = Vec.of_list instrs
  ; dfs_id = None
  ; terminal = 0
  }
;;

let of_edges ~num_nodes edges =
  let things = Array.init num_nodes ~f:(fun i -> make [ i + 1 ]) in
  List.iter edges ~f:(fun (a, b) ->
    Vec.push things.(a - 1).children things.(b - 1);
    Vec.push things.(b - 1).parents things.(a - 1));
  things
;;

let simple_graph () =
  of_edges ~num_nodes:6 [ 1, 2; 2, 3; 2, 4; 3, 5; 4, 5; 5, 2; 2, 6 ]
;;

let simple_graph2 () = of_edges ~num_nodes:4 [ 1, 2; 1, 3; 2, 4; 3, 4 ]

let simple_graph3 () =
  of_edges ~num_nodes:6 [ 1, 2; 1, 6; 2, 3; 2, 4; 3, 5; 4, 5; 5, 6 ]
;;

let%expect_test "dfs" =
  let things = simple_graph () in
  let _st = Ir.Dominator.dfs things.(0) in
  Array.iteri things ~f:(fun i block ->
    let num = Ir.Block.id_exn block in
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

let dominator_test things =
  let st = Ir.Dominator.create things.(0) in
  let block_number block = Vec.get block.Block.instructions 0 in
  Array.iter things ~f:(fun block ->
    let dom = Vec.get st.Ir.Dominator.dom (Ir.Block.id_exn block) in
    let dom_block = Vec.get st.blocks dom in
    print_endline
      [%string
        {|Block %{block_number block#Int}: dominator is Block %{block_number dom_block#Int}|}])
;;

let%expect_test "dominator" =
  simple_graph () |> dominator_test;
  [%expect
    {|
    Block 1: dominator is Block 1
    Block 2: dominator is Block 1
    Block 3: dominator is Block 2
    Block 4: dominator is Block 2
    Block 5: dominator is Block 2
    Block 6: dominator is Block 2
    |}]
;;

let%expect_test "dominator3" =
  simple_graph3 () |> dominator_test;
  [%expect
    {|
    Block 1: dominator is Block 1
    Block 2: dominator is Block 1
    Block 3: dominator is Block 2
    Block 4: dominator is Block 2
    Block 5: dominator is Block 2
    Block 6: dominator is Block 1
    |}]
;;

let dominance_test things =
  let st = Ir.Dominator.create things.(0) in
  let block_number block = Vec.get block.Ir.Block.instructions 0 in
  Array.iter things ~f:(fun block ->
    print_s
      [%message
        (block_number block : int)
          ~frontier:
            (Vec.get
               st.Ir.Dominator.dominance_frontier
               (Option.value_exn block.dfs_id)
             |> Hash_set.to_list
             |> List.map ~f:(fun dfs_id ->
               Vec.get st.blocks dfs_id |> block_number)
             : int list)])
;;

let%expect_test "dominance frontier" =
  simple_graph () |> dominance_test;
  [%expect
    {|
    (("block_number block" 1) (frontier ()))
    (("block_number block" 2) (frontier (2)))
    (("block_number block" 3) (frontier (5)))
    (("block_number block" 4) (frontier (5)))
    (("block_number block" 5) (frontier (2)))
    (("block_number block" 6) (frontier ()))
    |}]
;;

let%expect_test "dominance frontier2" =
  simple_graph2 () |> dominance_test;
  [%expect
    {|
    (("block_number block" 1) (frontier ()))
    (("block_number block" 2) (frontier (4)))
    (("block_number block" 3) (frontier (4)))
    (("block_number block" 4) (frontier ()))
    |}]
;;

let%expect_test "dominance frontier 3" =
  simple_graph3 () |> dominance_test;
  [%expect
    {|
    (("block_number block" 1) (frontier ()))
    (("block_number block" 2) (frontier (6)))
    (("block_number block" 3) (frontier (5)))
    (("block_number block" 4) (frontier (5)))
    (("block_number block" 5) (frontier (6)))
    (("block_number block" 6) (frontier ()))
    |}]
;;
