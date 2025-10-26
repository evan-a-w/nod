open! Core
open! Import
open! Common

let compile ?dump_crap (functions : Function.t String.Map.t) =
  Map.map functions ~f:(fun fn ->
    Instruction_selection.run fn |> Regalloc.run ?dump_crap)
  |> Save_clobbers.process
;;

let compile_to_asm ?dump_crap functions =
  compile ?dump_crap functions |> Lower.run
;;

module For_testing = struct
  let select_instructions (functions : Function.t String.Map.t) =
    Map.map functions ~f:(fun fn -> Instruction_selection.run fn)
  ;;

  let print_selected_instructions (functions : Function.t String.Map.t) =
    select_instructions functions
    |> Map.iteri ~f:(fun ~key:_name ~data:fn ->
      let reg_numbering = Reg_numbering.create fn.root in
      let (module Calc_liveness) = Calc_liveness.phys ~reg_numbering in
      let open Calc_liveness in
      let liveness_state = Liveness_state.create ~root:fn.root in
      Block.iter fn.root ~f:(fun block ->
        let ~instructions, ~terminal =
          Liveness_state.block_instructions_with_liveness liveness_state ~block
        in
        print_s
          [%message
            block.id_hum
              (instructions : (Ir.t * Liveness.t) list)
              (terminal : Ir.t * Liveness.t)]))
  ;;
end
