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
