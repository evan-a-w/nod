open! Core

(* go from

   [string Ir.t' Vec.t String.Map.t * string Vec.t]
   describing sequences of instructions


   to an actual cfg, [Ir.t]
*)
let process ((instrs, labels) : string Ir.t' Vec.t String.Map.t * string Vec.t)
  : Ir.Block.t * Ir.Block.t Vec.t
  =
  let new_block id_hum : Ir.Block.t =
    { id_hum
    ; Ir.Block.args = Vec.create ()
    ; parents = Vec.create ()
    ; children = Vec.create ()
    ; instructions = Vec.create ()
    ; terminal = Ir.Unreachable
    ; dfs_id = None
    }
  in
  let blocks =
    Vec.map labels ~f:(fun label -> label, new_block label)
    |> Vec.to_list
    |> String.Map.of_alist_exn
  in
  let ordered = Vec.map labels ~f:(Map.find_exn blocks) in
  Vec.iteri labels ~f:(fun i label ->
    let block = Map.find_exn blocks label in
    let found_terminal = ref false in
    let add_terminal instr =
      found_terminal := true;
      Ir.blocks instr
      |> List.iter ~f:(fun block' ->
        let block' = Map.find_exn blocks block' in
        Vec.push block.children block';
        Vec.push block'.parents block);
      block.terminal <- Ir.map_blocks ~f:(Map.find_exn blocks) instr
    in
    Vec.iter
      (Map.find instrs label |> Option.value_or_thunk ~default:Vec.create)
      ~f:(fun instr ->
        if !found_terminal
        then ()
        else if Ir.is_terminal instr
        then add_terminal instr
        else
          Vec.push
            block.instructions
            (Ir.map_blocks ~f:(Map.find_exn blocks) instr));
    if not !found_terminal
    then (
      match Vec.get_opt labels (i + 1) with
      | None -> add_terminal Ir.Unreachable
      | Some block' ->
        add_terminal
          Ir.(Branch (Branch.Uncond { Call_block.block = block'; args = [] }))));
  Map.find_exn blocks (Vec.get labels 0), ordered
;;
