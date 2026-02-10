open! Ssa
open! Core
open! Import

type raw_block =
  instrs_by_label:(Typed_var.t, string) Nod_ir.Ir.t Nod_vec.t String.Map.t
  * labels:string Nod_vec.t

(* TODO: why is this a result lol *)
type input = (raw_block Program.t', Nod_error.t) Result.t

module Opt_flags = Eir_opt.Opt_flags

let map_program_roots_with_state program ~state ~f =
  { program with
    Program.functions =
      Map.mapi program.Program.functions ~f:(fun ~key:name ~data:fn ->
        Function.map_root fn ~f:(f ~fn_state:(State.fn_state state name)))
  }
;;

let set_entry_block_args program ~state =
  Map.iteri program.Program.functions ~f:(fun ~key:name ~data:fn ->
    let root_data = Function.root fn in
    let args = Function.args fn in
    let ~root:block, ~blocks:_, ~in_order:_ = root_data in
    Fn_state.set_block_args
      (State.fn_state state name)
      ~block
      ~args:(Nod_vec.of_list args));
  program
;;

let type_check_block block =
  let open Result.Let_syntax in
  let%bind () =
    Instr_state.fold
      (Block.instructions block)
      ~init:(Ok ())
      ~f:(fun acc instr ->
        let%bind () = acc in
        Ir.check_types (Fn_state.var_ir instr.Instr_state.ir))
  in
  Ir.check_types (Fn_state.var_ir (Block.terminal block).Instr_state.ir)
;;

let type_check_cfg (~root, ~blocks:_, ~in_order:_) =
  let open Result.Let_syntax in
  let seen = String.Hash_set.create () in
  let rec go block =
    if Hash_set.mem seen (Block.id_hum block)
    then Ok ()
    else (
      Hash_set.add seen (Block.id_hum block);
      let%bind () = type_check_block block in
      Nod_vec.fold (Block.children block) ~init:(Ok ()) ~f:(fun acc child ->
        let%bind () = acc in
        go child))
  in
  go root
;;

let type_check_program program =
  Map.fold
    program.Program.functions
    ~init:(Ok ())
    ~f:(fun ~key:_ ~data:fn acc ->
      let open Result.Let_syntax in
      let%bind () = acc in
      type_check_cfg (Function.root fn))
;;

let lower_aggregate_program program ~state =
  Map.fold
    program.Program.functions
    ~init:(Ok ())
    ~f:(fun ~key:name ~data:fn acc ->
      let open Result.Let_syntax in
      let%bind () = acc in
      let ~root:block, ~blocks:_, ~in_order:_ = Function.root fn in
      Ir.lower_aggregates ~fn_state:(State.fn_state state name) ~root:block)
  |> Result.map ~f:(fun () -> program)
;;

let optimize_root ?opt_flags ~fn_state root =
  Eir_opt.optimize_root ?opt_flags ~fn_state root
;;

let optimize ?opt_flags ~state program =
  Eir_opt.optimize ?opt_flags ~state program
;;

let compile ?opt_flags (input : input) =
  let state = State.create () in
  match
    Result.map input ~f:(map_program_roots_with_state ~state ~f:Cfg.process)
    |> Result.map ~f:(set_entry_block_args ~state)
    |> Result.bind ~f:(fun program ->
      type_check_program program |> Result.map ~f:(fun () -> program))
    |> Result.bind ~f:(lower_aggregate_program ~state)
    |> Result.map ~f:(fun program -> convert_program program ~state)
  with
  | Error _ as e -> e
  | Ok program ->
    let program = optimize ?opt_flags ~state program in
    Ok program
;;
