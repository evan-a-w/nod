open! Core
open! Import

let gc_alloc_name = "nod_gc_alloc"
let gc_collect_name = "nod_gc_collect"
let gc_push_frame_name = "nod_gc_push_frame"
let gc_pop_frame_name = "nod_gc_pop_frame"
let frame_header_words = 2
let word_bytes = 8

module Var_set = Var.Set

type liveness =
  { live_in : Var_set.t
  ; live_out : Var_set.t
  }

type block_state =
  { defs : Var_set.t
  ; uses : Var_set.t
  ; mutable live_in : Var_set.t
  ; mutable live_out : Var_set.t
  ; mutable instrs : liveness Vec.t
  ; mutable terminal : liveness
  }

let uses_of_ir ir = Ir.uses ir |> Var_set.of_list
let defs_of_ir ir = Ir.defs ir |> Var_set.of_list

let defs_and_uses (block : Block.t) =
  let defs = ref (Var_set.of_list (Vec.to_list block.args)) in
  let uses = ref Var_set.empty in
  let add_ir ir =
    let new_uses = Set.diff (uses_of_ir ir) !defs in
    uses := Set.union !uses new_uses;
    defs := Set.union !defs (defs_of_ir ir)
  in
  Vec.iter block.instructions ~f:add_ir;
  add_ir block.terminal;
  !defs, !uses
;;

let compute_liveness root =
  let states = Block.Table.create () in
  Block.iter root ~f:(fun block ->
    let defs, uses = defs_and_uses block in
    Hashtbl.set
      states
      ~key:block
      ~data:
        { defs
        ; uses
        ; live_in = Var_set.empty
        ; live_out = Var_set.empty
        ; instrs = Vec.create ()
        ; terminal = { live_in = Var_set.empty; live_out = Var_set.empty }
        });
  let changed = ref true in
  while !changed do
    changed := false;
    Block.iter root ~f:(fun block ->
      let state = Hashtbl.find_exn states block in
      let live_out =
        block.children
        |> Vec.to_list
        |> List.map ~f:(fun child ->
          (Hashtbl.find_exn states child).live_in)
        |> Var_set.union_list
      in
      let live_in = Set.union state.uses (Set.diff live_out state.defs) in
      if (not (Set.equal live_in state.live_in))
         || not (Set.equal live_out state.live_out)
      then (
        state.live_in <- live_in;
        state.live_out <- live_out;
        changed := true))
  done;
  Block.iter root ~f:(fun block ->
    let state = Hashtbl.find_exn states block in
    let live = ref state.live_out in
    let terminal_live_out = !live in
    let terminal_live_in =
      Set.union (uses_of_ir block.terminal) (Set.diff terminal_live_out (defs_of_ir block.terminal))
    in
    state.terminal <- { live_in = terminal_live_in; live_out = terminal_live_out };
    live := terminal_live_in;
    let instrs_rev = Vec.create () in
    let (_ : Var_set.t) =
      Vec.foldr block.instructions ~init:!live ~f:(fun live_out ir ->
        let live_in =
          Set.union (uses_of_ir ir) (Set.diff live_out (defs_of_ir ir))
        in
        Vec.push instrs_rev { live_in; live_out };
        live_in)
    in
    Vec.reverse_inplace instrs_rev;
    state.instrs <- instrs_rev);
  states
;;

let collect_pointer_vars root =
  let vars = ref Var_set.empty in
  let add_var var =
    if Type.equal (Var.type_ var) Type.Ptr
    then vars := Set.add !vars var
  in
  Block.iter root ~f:(fun block ->
    Vec.iter block.args ~f:add_var;
    Vec.iter block.instructions ~f:(fun ir ->
      List.iter (Ir.vars ir) ~f:add_var);
    List.iter (Ir.vars block.terminal) ~f:add_var);
  Set.to_list !vars
;;

let collect_used_names root =
  let names = String.Hash_set.create () in
  let add_var var = Hash_set.add names (Var.name var) in
  Block.iter root ~f:(fun block ->
    Vec.iter block.args ~f:add_var;
    Vec.iter block.instructions ~f:(fun ir ->
      List.iter (Ir.vars ir) ~f:add_var);
    List.iter (Ir.vars block.terminal) ~f:add_var);
  names
;;

let fresh_name used_names base =
  let rec loop i =
    let name = if i = 0 then base else base ^ "_" ^ Int.to_string i in
    if Hash_set.mem used_names name
    then loop (i + 1)
    else (
      Hash_set.add used_names name;
      name)
  in
  loop 0
;;

let call_targets root =
  let targets = String.Hash_set.create () in
  Block.iter_instructions root ~f:(function
    | Ir.Call { fn; _ } -> Hash_set.add targets fn
    | _ -> ());
  String.Set.of_hash_set targets
;;

let gc_reachable_functions functions =
  let call_graph =
    Map.map functions ~f:(fun fn -> call_targets fn.Function.root)
  in
  let direct =
    Map.fold functions ~init:String.Set.empty ~f:(fun ~key:name ~data:fn acc ->
      let calls = Map.find_exn call_graph name in
      if Set.mem calls gc_alloc_name || Set.mem calls gc_collect_name
      then Set.add acc name
      else acc)
  in
  let reachable = ref direct in
  let changed = ref true in
  while !changed do
    changed := false;
    Map.iteri functions ~f:(fun ~key:name ~data:_fn ->
      if not (Set.mem !reachable name)
      then (
        let calls = Map.find_exn call_graph name in
        if Set.exists calls ~f:(fun callee -> Set.mem !reachable callee)
        then (
          reachable := Set.add !reachable name;
          changed := true))))
  done;
  !reachable
;;

let insert_gc_frame fn =
  let root = fn.Function.root in
  let pointer_vars =
    collect_pointer_vars root |> List.sort ~compare:Var.compare
  in
  if List.is_empty pointer_vars
  then ()
  else (
    let used_names = collect_used_names root in
    let frame_name = fresh_name used_names "__gc_frame" in
    let frame_var = Var.create ~name:frame_name ~type_:Type.Ptr in
    let slot_map =
      List.mapi pointer_vars ~f:(fun idx var -> var, idx)
      |> Var.Map.of_alist_exn
    in
    let frame_size =
      (frame_header_words + List.length pointer_vars) * word_bytes
    in
    let frame_base = Ir.Lit_or_var.Var frame_var in
    let slot_offset idx = (frame_header_words + idx) * word_bytes in
    let store_root var =
      match Map.find slot_map var with
      | None -> None
      | Some idx ->
        Some
          (Ir.store
             (Ir.Lit_or_var.Var var)
             (Ir.Mem.address frame_base ~offset:(slot_offset idx)))
    in
    let clear_root var =
      match Map.find slot_map var with
      | None -> None
      | Some idx ->
        Some
          (Ir.store
             (Ir.Lit_or_var.Lit 0L)
             (Ir.Mem.address frame_base ~offset:(slot_offset idx)))
    in
    let liveness = compute_liveness root in
    Block.iter root ~f:(fun block ->
      let state = Hashtbl.find_exn liveness block in
      let orig_instrs = Vec.to_list block.instructions in
      let liveness_instrs = Vec.to_list state.instrs in
      let new_instrs = Vec.create () in
      let arg_stores =
        Vec.to_list block.args
        |> List.filter ~f:(fun var -> Type.equal (Var.type_ var) Type.Ptr)
        |> List.filter_map ~f:store_root
      in
      let entry_live_in =
        match liveness_instrs with
        | first :: _ -> first.live_in
        | [] -> state.terminal.live_in
      in
      let dead_args =
        Set.diff (Var_set.of_list (Vec.to_list block.args)) entry_live_in
      in
      let dead_arg_clears =
        Set.to_list dead_args
        |> List.filter ~f:(fun var -> Type.equal (Var.type_ var) Type.Ptr)
        |> List.filter_map ~f:clear_root
      in
      if phys_equal block root
      then (
        Vec.push
          new_instrs
          (Ir.alloca
             { dest = frame_var
             ; size = Ir.Lit_or_var.Lit (Int64.of_int frame_size)
             });
        Vec.push
          new_instrs
          (Ir.call
             ~fn:gc_push_frame_name
             ~results:[]
             ~args:
               [ frame_base; Ir.Lit_or_var.Lit (Int64.of_int (List.length pointer_vars)) ]);
        List.iter arg_stores ~f:(Vec.push new_instrs);
        List.iter dead_arg_clears ~f:(Vec.push new_instrs))
      else (
        List.iter arg_stores ~f:(Vec.push new_instrs);
        List.iter dead_arg_clears ~f:(Vec.push new_instrs));
      List.iter2_exn orig_instrs liveness_instrs ~f:(fun instr live ->
        Vec.push new_instrs instr;
        let defs = Ir.defs instr in
        List.iter defs ~f:(fun var ->
          if Type.equal (Var.type_ var) Type.Ptr && Set.mem live.live_out var
          then Option.iter (store_root var) ~f:(Vec.push new_instrs));
        let dead = Set.diff live.live_in live.live_out in
        Set.iter dead ~f:(fun var ->
          if Type.equal (Var.type_ var) Type.Ptr
          then Option.iter (clear_root var) ~f:(Vec.push new_instrs)));
      let terminal_live = state.terminal in
      let dead_terminal = Set.diff terminal_live.live_in terminal_live.live_out in
      Set.iter dead_terminal ~f:(fun var ->
        if Type.equal (Var.type_ var) Type.Ptr
        then Option.iter (clear_root var) ~f:(Vec.push new_instrs));
      (match block.terminal with
       | Return _ ->
         Vec.push
           new_instrs
           (Ir.call ~fn:gc_pop_frame_name ~results:[] ~args:[]);
         block.terminal <- block.terminal
       | _ -> ());
      block.instructions <- new_instrs))
;;

let apply functions =
  let reachable = gc_reachable_functions functions in
  Map.iteri functions ~f:(fun ~key:name ~data:fn ->
    if Set.mem reachable name then insert_gc_frame fn);
  functions
;;
