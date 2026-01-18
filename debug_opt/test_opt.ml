open! Core
open! Nod_core
open! Nod

let c2 =
  {|
  entry:
    move %a:i64, 100
    move %b:i64, 6
    mod %res:i64, %a, %b
    add %res:i64, %res, 1
    return %res
  |}

(* Test to understand what's happening with replace_defs_uses *)
let () =
  let state = State.create () in

  (* First, create the CFG *)
  let program =
    match
      Parser.parse_string c2
      |> Result.map ~f:(fun program ->
        Program.map_function_roots_with_name program ~f:(fun ~name root ->
          let fn_state = State.ensure_function state name in
          Cfg.process ~state:fn_state root))
      |> Result.map ~f:(Eir.set_entry_block_args ~state)
    with
    | Error e -> failwith (Nod_error.to_string e)
    | Ok p -> p
  in

  print_endline "=== After CFG creation, before SSA ===";
  Map.iteri program.Program.functions ~f:(fun ~key:fn_name ~data:{ Function.root = (~root, ~blocks:_, ~in_order:_); _ } ->
    let fn_state = State.state_for_function state fn_name in

    print_endline "";
    printf "Function: %s, Block: %s\n" fn_name root.id_hum;
    Block.iter_instrs root ~f:(fun instr ->
      let (Instr_id id) = instr.Ssa_instr.id in
      let defs = Ir.defs instr.ir in
      printf "  Instr %d: defs=[%s]\n"
        id
        (List.map defs ~f:Var.name |> String.concat ~sep:", ");

      (* Check what the state says about each def *)
      List.iter defs ~f:(fun var ->
        let value = Ssa_state.value_by_var fn_state var in
        let def_str = match value with
          | None -> "NOT FOUND"
          | Some v -> match v.Ssa_value.def with
            | Def_site.Instr (Instr_id vid) -> sprintf "Instr(%d)" vid
            | Def_site.Block_arg { arg; _ } -> sprintf "Block_arg(%d)" arg
            | Def_site.Undefined -> "Undefined"
        in
        printf "    var %s: %s\n" (Var.name var) def_str)));

  print_endline "";
  print_endline "=== Now running SSA transformation ===";

  (* Now run SSA *)
  Map.iteri program.Program.functions ~f:(fun ~key:fn_name ~data:{ Function.root; _ } ->
    let fn_state = State.state_for_function state fn_name in

    (* Hook into the state to debug *)
    print_endline "";
    print_endline "--- Before Ssa.create ---";
    let (~root:root_block, ~blocks:_, ~in_order:_) = root in
    Block.iter_instrs root_block ~f:(fun instr ->
      let (Instr_id id) = instr.Ssa_instr.id in
      let defs = Ir.defs instr.ir in
      List.iter defs ~f:(fun var ->
        let value = Ssa_state.value_by_var fn_state var in
        let def_str = match value with
          | None -> "NOT FOUND"
          | Some v -> match v.Ssa_value.def with
            | Def_site.Instr (Instr_id vid) -> sprintf "Instr(%d)" vid
            | Def_site.Block_arg { arg; _ } -> sprintf "Block_arg(%d)" arg
            | Def_site.Undefined -> "Undefined"
        in
        printf "  Instr %d def %s: state says %s\n" id (Var.name var) def_str));

    let ssa = Ssa.create ~state:fn_state root in

    print_endline "";
    print_endline "--- After Ssa.create ---";
    Vec.iter ssa.in_order ~f:(fun block ->
      Block.iter_instrs block ~f:(fun instr ->
        let (Instr_id id) = instr.Ssa_instr.id in
        let defs = Ir.defs instr.ir in
        List.iter defs ~f:(fun var ->
          let value = Ssa_state.value_by_var fn_state var in
          let def_str = match value with
            | None -> "NOT FOUND"
            | Some v -> match v.Ssa_value.def with
              | Def_site.Instr (Instr_id vid) -> sprintf "Instr(%d)" vid
              | Def_site.Block_arg { arg; _ } -> sprintf "Block_arg(%d)" arg
              | Def_site.Undefined -> "Undefined"
          in
          printf "  Instr %d def %s: state says %s\n" id (Var.name var) def_str))));

  print_endline "\n=== Done ==="
;;
