open! Core
open! Import
open! Common

(* stack layout:

   args spilled on stack
   padding?
   callee saved regs (incl rbp)
   spills
   statically alloca'd memory

   and rbp points at the end of statically alloca'd memory
*)

let compile ?dump_crap (functions : Function.t String.Map.t) =
  let fn_state_by_name =
    Map.mapi functions ~f:(fun ~key:_ ~data:fn -> Fn_state.of_cfg ~root:fn.root)
  in
  Map.mapi functions ~f:(fun ~key:name ~data:fn ->
    let fn_state = Map.find_exn fn_state_by_name name in
    Instruction_selection.run ~fn_state fn |> Regalloc.run ?dump_crap ~fn_state)
  |> Save_clobbers.process ~fn_state_by_name
;;

let compile_to_asm ~system ?dump_crap ?(globals = []) functions =
  compile ?dump_crap functions |> Lower.run ~system ~globals
;;

let compile_to_items ~system ?dump_crap ?(globals = []) functions =
  if not (List.is_empty globals)
  then failwith "globals are not supported in item lowering"
  else compile ?dump_crap functions |> Lower.lower_to_items ~system
;;

module For_testing = struct
  let select_instructions (functions : Function.t String.Map.t) =
    Map.map functions ~f:(fun fn ->
      let fn_state = Fn_state.of_cfg ~root:fn.root in
      Instruction_selection.run ~fn_state fn)
  ;;

  let print_selected_instructions_with_all_liveness_info
    (functions : Function.t String.Map.t)
    =
    (* select_instructions *)
    Map.map functions ~f:Instruction_selection.For_testing.run_deebg
    |> Map.iteri ~f:(fun ~key:_name ~data:fn ->
      let reg_numbering = Reg_numbering.create fn.root in
      let (module Calc_liveness) =
        Calc_liveness.var ~treat_block_args_as_defs:true ~reg_numbering
      in
      let open Calc_liveness in
      let liveness_state = Liveness_state.create ~root:fn.root in
      Block.to_list fn.root
      |> List.concat_map ~f:(fun block ->
        let ~instructions, ~terminal =
          Liveness_state.block_instructions_with_liveness liveness_state ~block
        in
        let block_liveness =
          Liveness_state.block_liveness liveness_state block
        in
        let block_live_in, block_live_out =
          ( Liveness.live_in' block_liveness.overall
          , Liveness.live_out' block_liveness.overall )
        in
        let instructions, liveness = List.unzip (instructions @ [ terminal ]) in
        let live_in, live_out =
          List.map liveness ~f:(fun liveness ->
            let live_in = Liveness.live_in' liveness in
            let live_out = Liveness.live_out' liveness in
            live_in, live_out)
          |> List.unzip
        in
        let names = List.map instructions ~f:(Fn.const (Block.id_hum block)) in
        let inner_sexps =
          List.zip_exn
            names
            (List.zip_exn instructions (List.zip_exn live_in live_out))
          |> List.map ~f:(fun (block, (instruction, (live_in, live_out))) ->
            [%message
              (block : string)
                (instruction : Ir.t)
                (live_in : Typed_var.t list)
                (live_out : Typed_var.t list)])
        in
        let args = Block.args block in
        let block = Block.id_hum block in
        [ [%message
            (block : string)
              ~instruction:
                ([%message "block start" (args : Typed_var.t Vec.read)]
                 : Sexp.t)
              ~live_in:(block_live_in : Typed_var.t list)
              ~live_out:
                (List.hd_exn liveness |> Liveness.live_in' : Typed_var.t list)]
        ]
        @ inner_sexps
        @ [ [%message
              (block : string)
                ~instruction:("block end" : string)
                ~live_in:
                  (List.last_exn liveness |> Liveness.live_out'
                   : Typed_var.t list)
                ~live_out:(block_live_out : Typed_var.t list)]
          ])
      |> Table.print_records)
  ;;

  let print_selected_instructions (functions : Function.t String.Map.t) =
    (* select_instructions *)
    Map.map functions ~f:Instruction_selection.For_testing.run_deebg
    |> Map.iteri ~f:(fun ~key:_name ~data:fn ->
      let reg_numbering = Reg_numbering.create fn.root in
      let (module Calc_liveness) =
        Calc_liveness.var ~treat_block_args_as_defs:true ~reg_numbering
      in
      let open Calc_liveness in
      let liveness_state = Liveness_state.create ~root:fn.root in
      Block.to_list fn.root
      |> List.iter ~f:(fun block ->
        let ~instructions, ~terminal =
          Liveness_state.block_instructions_with_liveness liveness_state ~block
        in
        let instructions, _liveness =
          List.unzip (instructions @ [ terminal ])
        in
        print_s [%message "block" (Block.id_hum block : string)];
        List.map instructions ~f:(fun ir ->
          [%message (ir : Ir.t) (Ir.defs ir : Arg.t list)])
        |> Table.print_records))
  ;;

  let compute_assignments (fn : Function.t) =
    let var_classes = Regalloc.collect_var_classes fn.root in
    let class_of_var var =
      Hashtbl.find var_classes var |> Option.value ~default:Reg.Class.I64
    in
    let reg_numbering = Reg_numbering.create fn.root in
    let (module Calc_liveness) =
      Calc_liveness.var ~treat_block_args_as_defs:false ~reg_numbering
    in
    let liveness_state = Calc_liveness.Liveness_state.create ~root:fn.root in
    let interference_graph =
      Interference_graph.create
        (module Calc_liveness)
        ~liveness_state
        ~root:fn.root
    in
    let ~assignments, ~don't_spill = Regalloc.initialize_assignments fn.root in
    List.iter [ Reg.Class.I64; Reg.Class.F64 ] ~f:(fun class_ ->
      Regalloc.run_sat
        ~dump_crap:false
        ~reg_numbering
        ~interference_graph
        ~assignments
        ~don't_spill
        ~class_of_var
        ~class_);
    ~assignments, ~interference_graph
  ;;

  let print_assignments (functions : Function.t String.Map.t) =
    Map.iteri functions ~f:(fun ~key:function_name ~data:fn ->
      let fn_state = Fn_state.of_cfg ~root:fn.root in
      let fn = Instruction_selection.run ~fn_state fn in
      let ~assignments:assignments_table, ~interference_graph =
        compute_assignments fn
      in
      let assignments =
        assignments_table
        |> Hashtbl.to_alist
        |> List.sort
             ~compare:
               (Comparable.lift String.compare ~f:(fun (var, _) ->
                  Typed_var.name var))
      in
      print_s
        [%message
          ""
            ~function_name:(function_name : string)
            (assignments : (Typed_var.t * Assignment.t) list)];
      Interference_graph.print interference_graph)
  ;;
end
