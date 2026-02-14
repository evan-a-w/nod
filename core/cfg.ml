open! Core
open! Import

(* go from

     [string Nod_ir.Ir.t Nod_vec.t String.Map.t * string Nod_vec.t]
     describing sequences of instructions

     to an actual cfg, [Ir.t]
*)
let process ~fn_state (~instrs_by_label, ~labels) =
  let blocks =
    Nod_vec.map labels ~f:(fun label ->
      ( label
      , Block.create
          ~id_hum:label
          ~terminal:(Fn_state.alloc_instr fn_state ~ir:Ir.unreachable) ))
    |> Nod_vec.to_list
    |> String.Map.of_alist_exn
  in
  let in_order = Nod_vec.map labels ~f:(Map.find_exn blocks) in
  Nod_vec.iteri labels ~f:(fun i label ->
    let block = Map.find_exn blocks label in
    let found_terminal = ref false in
    let add_terminal ir =
      found_terminal := true;
      Ir.blocks ir
      |> List.iter ~f:(fun block' ->
        let block' = Map.find_exn blocks block' in
        Block.Expert.add_child block ~child:block');
      let new_terminal =
        Fn_state.alloc_instr
          fn_state
          ~ir:
            (Ir.map_blocks ~f:(Map.find_exn blocks) ir
             |> Fn_state.value_ir fn_state)
      in
      Fn_state.replace_terminal fn_state ~block ~with_:new_terminal
    in
    Nod_vec.iter
      (Map.find instrs_by_label label
       |> Option.value_or_thunk ~default:Nod_vec.create)
      ~f:(fun instr ->
        if !found_terminal
        then ()
        else if Ir.is_terminal instr
        then add_terminal instr
        else
          Fn_state.append_ir
            fn_state
            ~block
            ~ir:
              (Ir.map_blocks ~f:(Map.find_exn blocks) instr
               |> Fn_state.value_ir fn_state));
    if not !found_terminal
    then (
      match Nod_vec.get_opt labels (i + 1) with
      | None -> add_terminal Ir.unreachable
      | Some block' -> add_terminal (Ir.jump_to block')));
  ~root:(Map.find_exn blocks (Nod_vec.get labels 0)), ~blocks, ~in_order
;;

let process'
  ~is_label
  ~add_fall_through_to_terminal
  (instrs : (Typed_var.t, string) Nod_ir.Ir.t Nod_vec.t)
  =
  let labels = Nod_vec.create () in
  let label_n = ref 0 in
  let curr_label = ref "%root" in
  let curr_instrs = Nod_vec.create () in
  let instrs_by_label = ref String.Map.empty in
  let new_block new_label =
    let new_instrs = Nod_vec.create () in
    instrs_by_label
    := Map.add_exn !instrs_by_label ~key:!curr_label ~data:new_instrs;
    Nod_vec.switch curr_instrs new_instrs;
    Nod_vec.push labels !curr_label;
    curr_label := new_label
  in
  Nod_vec.iter instrs ~f:(fun instr ->
    if is_label instr
    then (
      let label = List.hd_exn (Ir.blocks instr) in
      if Nod_vec.length curr_instrs > 0
      then new_block label
      else (
        (* might be necessary because of keeping track of which blocks things follow through to *)
        Nod_vec.push curr_instrs (Ir.jump_to label);
        new_block label))
    else if Ir.is_terminal instr
    then (
      let new_label = "%gen_lbl_" ^ Int.to_string !label_n in
      Nod_vec.push
        curr_instrs
        (add_fall_through_to_terminal instr ~fall_through_to_block:new_label);
      incr label_n;
      new_block new_label)
    else Nod_vec.push curr_instrs instr);
  let instrs_by_label = !instrs_by_label in
  process (~instrs_by_label, ~labels)
;;
