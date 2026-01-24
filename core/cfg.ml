open! Core

(* go from

     [string Ir0.t Vec.t String.Map.t * string Vec.t]
     describing sequences of instructions

     to an actual cfg, [Ir.t]
*)
let process ~fn_state (~instrs_by_label, ~labels) =
  let blocks =
    Vec.map labels ~f:(fun label ->
      ( label
      , Block.create
          ~id_hum:label
          ~terminal:(Fn_state.alloc_instr fn_state ~ir:Ir.unreachable) ))
    |> Vec.to_list
    |> String.Map.of_alist_exn
  in
  let in_order = Vec.map labels ~f:(Map.find_exn blocks) in
  Vec.iteri labels ~f:(fun i label ->
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
          ~ir:(Ir.map_blocks ~f:(Map.find_exn blocks) ir)
      in
      Fn_state.replace_terminal fn_state ~block ~with_:new_terminal
    in
    Vec.iter
      (Map.find instrs_by_label label
       |> Option.value_or_thunk ~default:Vec.create)
      ~f:(fun instr ->
        if !found_terminal
        then ()
        else if Ir.is_terminal instr
        then add_terminal instr
        else
          Fn_state.append_ir
            fn_state
            ~block
            ~ir:(Ir.map_blocks ~f:(Map.find_exn blocks) instr));
    if not !found_terminal
    then (
      match Vec.get_opt labels (i + 1) with
      | None -> add_terminal Ir.unreachable
      | Some block' -> add_terminal (Ir.jump_to block')));
  ~root:(Map.find_exn blocks (Vec.get labels 0)), ~blocks, ~in_order
;;

let process'
  ~is_label
  ~add_fall_through_to_terminal
  (instrs : string Ir0.t Vec.t)
  =
  let labels = Vec.create () in
  let label_n = ref 0 in
  let curr_label = ref "%root" in
  let curr_instrs = Vec.create () in
  let instrs_by_label = ref String.Map.empty in
  let new_block new_label =
    let new_instrs = Vec.create () in
    instrs_by_label
    := Map.add_exn !instrs_by_label ~key:!curr_label ~data:new_instrs;
    Vec.switch curr_instrs new_instrs;
    Vec.push labels !curr_label;
    curr_label := new_label
  in
  Vec.iter instrs ~f:(fun instr ->
    if is_label instr
    then (
      let label = List.hd_exn (Ir.blocks instr) in
      if Vec.length curr_instrs > 0
      then new_block label
      else (
        (* might be necessary because of keeping track of which blocks things follow through to *)
        Vec.push curr_instrs (Ir.jump_to label);
        new_block label))
    else if Ir.is_terminal instr
    then (
      let new_label = "%gen_lbl_" ^ Int.to_string !label_n in
      Vec.push
        curr_instrs
        (add_fall_through_to_terminal instr ~fall_through_to_block:new_label);
      incr label_n;
      new_block new_label)
    else Vec.push curr_instrs instr);
  let instrs_by_label = !instrs_by_label in
  process (~instrs_by_label, ~labels)
;;
