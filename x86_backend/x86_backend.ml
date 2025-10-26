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
        (* Print block header *)
        print_endline "";
        print_endline ("Block: " ^ block.id_hum);
        print_endline (String.make (String.length block.id_hum + 7) '=');
        (* Build sexp records for each row *)
        let instruction_records =
          List.mapi instructions ~f:(fun idx (instr, liveness) ->
            let live_in_sexp =
              Set.to_list liveness.live_in
              |> List.map ~f:(fun i -> Sexp.Atom (Int.to_string i))
              |> fun l -> Sexp.List l
            in
            let live_out_sexp =
              Set.to_list liveness.live_out
              |> List.map ~f:(fun i -> Sexp.Atom (Int.to_string i))
              |> fun l -> Sexp.List l
            in
            Sexp.List
              [ Sexp.List [ Sexp.Atom "Idx"; Sexp.Atom (Int.to_string idx) ]
              ; Sexp.List [ Sexp.Atom "Instruction"; Ir.sexp_of_t instr ]
              ; Sexp.List [ Sexp.Atom "Live In"; live_in_sexp ]
              ; Sexp.List [ Sexp.Atom "Live Out"; live_out_sexp ]
              ])
        in
        let terminal_record =
          let instr, liveness = terminal in
          let live_in_sexp =
            Set.to_list liveness.live_in
            |> List.map ~f:(fun i -> Sexp.Atom (Int.to_string i))
            |> fun l -> Sexp.List l
          in
          let live_out_sexp =
            Set.to_list liveness.live_out
            |> List.map ~f:(fun i -> Sexp.Atom (Int.to_string i))
            |> fun l -> Sexp.List l
          in
          Sexp.List
            [ Sexp.List [ Sexp.Atom "Idx"; Sexp.Atom "TERM" ]
            ; Sexp.List [ Sexp.Atom "Instruction"; Ir.sexp_of_t instr ]
            ; Sexp.List [ Sexp.Atom "Live In"; live_in_sexp ]
            ; Sexp.List [ Sexp.Atom "Live Out"; live_out_sexp ]
            ]
        in
        let all_records = instruction_records @ [ terminal_record ] in
        Table.print_sexp_records all_records))
  ;;
end
