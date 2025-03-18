open! Core

module Ir = struct
  include Ir
  include Initial_transform.Make_with_block (Ir)
end

let test s =
  s
  |> Parser.parse_string
  |> Result.map ~f:Cfg.process
  |> Result.map ~f:Ir.Ssa.create
  |> function
  | Error e -> Test_parser.print_error e
  | Ok ssa ->
    Vec.iter ssa.Ir.Ssa.in_order ~f:(fun block ->
      let instrs = Vec.to_list block.instructions @ [ block.terminal ] in
      print_s [%message block.id_hum (instrs : Ir.Instr.t list)])
;;

let%expect_test "all examples" =
  List.iter Examples.Textual.all ~f:(fun s ->
    print_endline "---------------------------------";
    print_endline s;
    print_endline "=================================";
    test s;
    print_endline "---------------------------------")
;;
