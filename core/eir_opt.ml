open! Core
open! Import

module Opt_flags = struct
  type t =
    { unused_vars : bool
    ; constant_propagation : bool
    ; gvn : bool
    ; inline : bool
    }
  [@@deriving fields]

  let default =
    { unused_vars = true
    ; constant_propagation = true
    ; gvn = true
    ; inline = true
    }
  ;;

  let no_opt =
    { unused_vars = false
    ; constant_propagation = false
    ; gvn = false
    ; inline = false
    }
  ;;
end

module Inline = struct
  let max_inline_instrs = 32
  let max_inline_blocks = 6

  type metrics =
    { instrs : int
    ; blocks : int
    }

  let instrs_in_block block =
    Instr_state.fold (Block.instructions block) ~init:0 ~f:(fun acc _ ->
      acc + 1)
  ;;

  let metrics_of_root root =
    let blocks = ref 0 in
    let instrs = ref 0 in
    Block.iter root ~f:(fun block ->
      incr blocks;
      instrs := !instrs + instrs_in_block block + 1);
    { instrs = !instrs; blocks = !blocks }
  ;;

  let should_inline metrics =
    metrics.instrs <= max_inline_instrs && metrics.blocks <= max_inline_blocks
  ;;

  module Name_supply = struct
    type t =
      { var_names : String.Hash_set.t
      ; block_names : String.Hash_set.t
      ; mutable var_counter : int
      ; mutable block_counter : int
      }

    let sanitize_name base =
      String.map base ~f:(function
        | '%' -> '_'
        | c -> c)
    ;;

    let create ~fn_state ~root =
      let var_names = String.Hash_set.create () in
      Vec.iter fn_state.Fn_state.values ~f:(function
        | None -> ()
        | Some value ->
          Hash_set.add var_names (Typed_var.name (Value_state.var value)));
      let block_names = String.Hash_set.create () in
      Block.iter root ~f:(fun block ->
        Hash_set.add block_names (Block.id_hum block));
      { var_names; block_names; var_counter = 0; block_counter = 0 }
    ;;

    let fresh_name names counter base =
      let base = sanitize_name base in
      let rec loop attempt =
        let candidate =
          if attempt = 0
          then sprintf "%s__inline_%d" base counter
          else sprintf "%s__inline_%d_%d" base counter attempt
        in
        if Hash_set.mem names candidate then loop (attempt + 1) else candidate
      in
      loop 0
    ;;

    let fresh_block_name t base =
      let name = fresh_name t.block_names t.block_counter base in
      Hash_set.add t.block_names name;
      t.block_counter <- t.block_counter + 1;
      name
    ;;

    let fresh_var_name t ?hint () =
      let base = Option.value hint ~default:"tmp" in
      let name = fresh_name t.var_names t.var_counter base in
      Hash_set.add t.var_names name;
      t.var_counter <- t.var_counter + 1;
      name
    ;;

    let fresh_var t ?hint type_ =
      let name = fresh_var_name t ?hint () in
      Typed_var.create ~name ~type_
    ;;
  end

  let collect_instrs ~fn_state block =
    let rec loop instr acc =
      match instr with
      | None -> List.rev acc
      | Some instr ->
        loop
          instr.Instr_state.next
          ((instr, Fn_state.var_ir instr.Instr_state.ir) :: acc)
    in
    loop (Block.instructions block) []
  ;;

  let split_around_call entries ~call_instr =
    let rec loop prefix = function
      | [] -> None
      | (instr, ir) :: rest ->
        if phys_equal instr call_instr
        then Some (List.rev prefix, ir, rest)
        else loop ((instr, ir) :: prefix) rest
    in
    loop [] entries
  ;;

  let has_return root =
    let found = ref false in
    Block.iter root ~f:(fun block ->
      if !found
      then ()
      else (
        match (Block.terminal block).Instr_state.ir with
        | Return _ -> found := true
        | _ -> ()));
    !found
  ;;

  let install_instrs ~fn_state ~block irs =
    let irs = List.map irs ~f:(Fn_state.value_ir fn_state) in
    Fn_state.replace_irs fn_state ~block ~irs
  ;;

  let create_block supply ~fn_state ~base ~terminal_ir =
    let id_hum = Name_supply.fresh_block_name supply base in
    let terminal =
      Fn_state.alloc_instr fn_state ~ir:(Fn_state.value_ir fn_state terminal_ir)
    in
    let block = Block.create ~id_hum ~terminal in
    Block.set_dfs_id block (Some 0);
    Fn_state.set_instr_block fn_state ~block ~instr:terminal;
    block
  ;;

  let rec inline_call
    ~program
    ~state
    ~caller_name
    ~caller_fn_state
    ~caller_root
    ~block
    ~call_instr
    =
    match call_instr.Instr_state.ir with
    | Call call_value ->
      let callee_name = call_value.fn in
      if String.equal callee_name caller_name
      then false
      else (
        match Map.find program.Program.functions callee_name with
        | None -> false
        | Some callee_fn ->
          let callee_root = Function.root callee_fn in
          let callee_metrics = metrics_of_root callee_root in
          if (not (should_inline callee_metrics))
             || not (has_return callee_root)
          then false
          else (
            let entries = collect_instrs ~fn_state:caller_fn_state block in
            match split_around_call entries ~call_instr with
            | None -> false
            | Some (before, call_ir_typed, after) ->
              (match call_ir_typed with
               | Call call_typed_ir ->
                 let entry_args = Vec.to_list (Block.args callee_root) in
                 if List.length call_typed_ir.args <> List.length entry_args
                 then false
                 else (
                   let call_result_vars =
                     List.map call_value.results ~f:(fun value ->
                       Value_state.var value)
                   in
                   if List.length call_result_vars > 1
                   then false
                   else (
                     let supply =
                       Name_supply.create
                         ~fn_state:caller_fn_state
                         ~root:caller_root
                     in
                     let actual_args, prep_instrs =
                       List.fold2_exn
                         entry_args
                         call_typed_ir.args
                         ~init:([], [])
                         ~f:(fun (args, instrs) param arg ->
                           match arg with
                           | Var var -> var :: args, instrs
                           | Lit lit ->
                             let temp =
                               Name_supply.fresh_var
                                 supply
                                 ~hint:(Typed_var.name param)
                                 (Typed_var.type_ param)
                             in
                             ( temp :: args
                             , Nod_ir.Ir.Move (temp, Lit lit) :: instrs )
                           | Global g ->
                             let temp =
                               Name_supply.fresh_var
                                 supply
                                 ~hint:(Typed_var.name param)
                                 (Typed_var.type_ param)
                             in
                             ( temp :: args
                             , Nod_ir.Ir.Move (temp, Global g) :: instrs ))
                     in
                     let actual_args = List.rev actual_args in
                     let prep_instrs = List.rev prep_instrs in
                     let before_instrs = List.map before ~f:snd @ prep_instrs in
                     install_instrs
                       ~fn_state:caller_fn_state
                       ~block
                       before_instrs;
                     let after_instrs = List.map after ~f:snd in
                     let original_terminal =
                       Fn_state.var_ir (Block.terminal block).Instr_state.ir
                     in
                     let cont_block =
                       create_block
                         supply
                         ~fn_state:caller_fn_state
                         ~base:(Block.id_hum block ^ "__cont")
                         ~terminal_ir:original_terminal
                     in
                     install_instrs
                       ~fn_state:caller_fn_state
                       ~block:cont_block
                       after_instrs;
                     Fn_state.set_block_args
                       caller_fn_state
                       ~block:cont_block
                       ~args:(Vec.of_list call_result_vars);
                     let callee_blocks = Block.to_list callee_root in
                     let block_map = Block.Table.create () in
                     List.iter callee_blocks ~f:(fun callee_block ->
                       let clone =
                         create_block
                           supply
                           ~fn_state:caller_fn_state
                           ~base:(Block.id_hum callee_block)
                           ~terminal_ir:Ir.unreachable
                       in
                       Hashtbl.set block_map ~key:callee_block ~data:clone);
                     let var_map = Typed_var.Table.create () in
                     List.iter callee_blocks ~f:(fun callee_block ->
                       let clone = Hashtbl.find_exn block_map callee_block in
                       let args = Vec.to_list (Block.args callee_block) in
                       let new_args =
                         List.map args ~f:(fun arg ->
                           let mapped =
                             Name_supply.fresh_var
                               supply
                               ~hint:(Typed_var.name arg)
                               (Typed_var.type_ arg)
                           in
                           Hashtbl.set var_map ~key:arg ~data:mapped;
                           mapped)
                       in
                       Fn_state.set_block_args
                         caller_fn_state
                         ~block:clone
                         ~args:(Vec.of_list new_args));
                     let map_var var =
                       match Hashtbl.find var_map var with
                       | Some mapped -> mapped
                       | None -> failwith "inline: missing var mapping"
                     in
                     let map_lit_or_var lit_or_var =
                       Nod_ir.Lit_or_var.map_vars lit_or_var ~f:map_var
                     in
                     List.iter callee_blocks ~f:(fun callee_block ->
                       let clone = Hashtbl.find_exn block_map callee_block in
                       let typed_instrs =
                         Block.instructions callee_block
                         |> Instr_state.to_ir_list
                         |> List.map ~f:Fn_state.var_ir
                       in
                       let mapped_instrs =
                         List.fold typed_instrs ~init:[] ~f:(fun acc instr ->
                           List.iter (Ir.defs instr) ~f:(fun var ->
                             if not (Hashtbl.mem var_map var)
                             then (
                               let mapped =
                                 Name_supply.fresh_var
                                   supply
                                   ~hint:(Typed_var.name var)
                                   (Typed_var.type_ var)
                               in
                               Hashtbl.set var_map ~key:var ~data:mapped));
                           Ir.map_vars instr ~f:map_var :: acc)
                         |> List.rev
                       in
                       let terminal_ir =
                         Fn_state.var_ir
                           (Block.terminal callee_block).Instr_state.ir
                       in
                       let mapped_terminal, extra_instrs =
                         match terminal_ir with
                         | Return ret ->
                           let args, extra =
                             match call_result_vars with
                             | [] -> [], []
                             | [ result_var ] ->
                               (match map_lit_or_var ret with
                                | Var var -> [ var ], []
                                | lit ->
                                  let temp =
                                    Name_supply.fresh_var
                                      supply
                                      ~hint:(Typed_var.name result_var)
                                      (Typed_var.type_ result_var)
                                  in
                                  [ temp ], [ Nod_ir.Ir.Move (temp, lit) ])
                             | _ -> [], []
                           in
                           ( Nod_ir.Ir.Branch
                               (Nod_ir.Branch.Uncond
                                  { Call_block.block = cont_block; args })
                           , extra )
                         | _ ->
                           ( terminal_ir
                             |> Ir.map_vars ~f:map_var
                             |> Ir.map_blocks ~f:(fun block ->
                               Hashtbl.find_exn block_map block)
                           , [] )
                       in
                       install_instrs
                         ~fn_state:caller_fn_state
                         ~block:clone
                         (mapped_instrs @ extra_instrs);
                       Fn_state.replace_terminal_ir
                         caller_fn_state
                         ~block:clone
                         ~with_:
                           (Fn_state.value_ir caller_fn_state mapped_terminal));
                     let entry_clone = Hashtbl.find_exn block_map callee_root in
                     let branch_to_inline =
                       Nod_ir.Ir.Branch
                         (Nod_ir.Branch.Uncond
                            { Call_block.block = entry_clone
                            ; args = actual_args
                            })
                     in
                     Fn_state.replace_terminal_ir
                       caller_fn_state
                       ~block
                       ~with_:
                         (Fn_state.value_ir caller_fn_state branch_to_inline);
                     Block.iter_and_update_bookkeeping caller_root ~f:(fun _ ->
                       ());
                     true))
               | _ -> false)))
    | _ -> false
  ;;

  let inline_function ~program ~state ~caller_name ~fn =
    let caller_fn_state = State.fn_state state caller_name in
    let root = Function.root fn in
    let rec loop () =
      let changed = ref false in
      Block.iter root ~f:(fun block ->
        if !changed
        then ()
        else (
          let rec scan instr =
            match instr with
            | None -> ()
            | Some instr ->
              if inline_call
                   ~program
                   ~state
                   ~caller_name
                   ~caller_fn_state
                   ~caller_root:root
                   ~block
                   ~call_instr:instr
              then changed := true
              else scan instr.Instr_state.next
          in
          scan (Block.instructions block)));
      if !changed then loop ()
    in
    loop ()
  ;;

  let run ~state ~opt_flags program =
    if not (Opt_flags.inline opt_flags)
    then program
    else (
      Map.iteri program.Program.functions ~f:(fun ~key:name ~data:fn ->
        inline_function ~program ~state ~caller_name:name ~fn);
      program)
  ;;
end

module Dominance = struct
  let immediate_dominees root =
    Block.iter_and_update_bookkeeping root ~f:(fun _ -> ());
    let blocks = Block.to_list root in
    let order block = Block.id_exn block in
    let idom = Block.Table.create () in
    Hashtbl.set idom ~key:root ~data:root;
    let intersect a b =
      let block_a = ref a in
      let block_b = ref b in
      while not (phys_equal !block_a !block_b) do
        while order !block_a > order !block_b do
          block_a := Hashtbl.find_exn idom !block_a
        done;
        while order !block_b > order !block_a do
          block_b := Hashtbl.find_exn idom !block_b
        done;
        if not (phys_equal !block_a !block_b)
        then (
          block_a := Hashtbl.find_exn idom !block_a;
          block_b := Hashtbl.find_exn idom !block_b)
      done;
      !block_a
    in
    let changed = ref true in
    while !changed do
      changed := false;
      List.iter blocks ~f:(fun block ->
        if phys_equal block root
        then ()
        else (
          let preds = Block.parents block |> Vec.to_list in
          if List.is_empty preds
          then ()
          else (
            match List.find preds ~f:(fun pred -> Hashtbl.mem idom pred) with
            | None -> ()
            | Some first_processed ->
              let new_idom =
                List.fold preds ~init:first_processed ~f:(fun acc pred ->
                  if phys_equal pred acc
                  then acc
                  else (
                    match Hashtbl.find idom pred with
                    | None -> acc
                    | Some _ -> intersect acc pred))
              in
              let should_update =
                match Hashtbl.find idom block with
                | None -> true
                | Some prev -> not (phys_equal prev new_idom)
              in
              if should_update
              then (
                Hashtbl.set idom ~key:block ~data:new_idom;
                changed := true))))
    done;
    let immediate_dominees = Block.Table.create () in
    Hashtbl.iteri idom ~f:(fun ~key:block ~data:idom_block ->
      if phys_equal block root
      then ()
      else (
        let bucket =
          Hashtbl.find immediate_dominees idom_block
          |> Option.value_or_thunk ~default:(fun () ->
            let set = Block.Hash_set.create () in
            Hashtbl.set immediate_dominees ~key:idom_block ~data:set;
            set)
        in
        Hash_set.add bucket block));
    immediate_dominees
  ;;
end

type context =
  { root : Block.t
  ; fn_state : Fn_state.t
  ; opt_flags : Opt_flags.t
  ; block_by_id : Block.t String.Table.t
  ; immediate_dominees : Block.Hash_set.t Block.Table.t
  ; mutable changed : bool
  }

let create_context ~opt_flags ~fn_state root =
  let block_by_id = String.Table.create () in
  Block.iter root ~f:(fun block ->
    Hashtbl.set block_by_id ~key:(Block.id_hum block) ~data:block);
  { root
  ; fn_state
  ; opt_flags
  ; block_by_id
  ; immediate_dominees = Dominance.immediate_dominees root
  ; changed = false
  }
;;

let mark_changed ctx = ctx.changed <- true

let rec iter_blocks ctx ~block ~f =
  f block;
  Hashtbl.find ctx.immediate_dominees block
  |> Option.iter
       ~f:
         (Hash_set.iter ~f:(fun block' ->
            if phys_equal block' block
            then ()
            else iter_blocks ctx ~block:block' ~f))
;;

let iter_blocks ctx ~f = iter_blocks ctx ~block:ctx.root ~f
let value_of_var ctx var = Fn_state.value_by_var ctx.fn_state var
let value_of_var_exn ctx var = Fn_state.ensure_value ctx.fn_state ~var

let active_value (value : Value_state.t) =
  if value.Value_state.active then Some value else None
;;

let active_value_of_var ctx var =
  value_of_var ctx var |> Option.bind ~f:active_value
;;

let block_for_instr_id_exn ctx instr_id =
  Fn_state.instr_block ctx.fn_state instr_id |> Option.value_exn
;;

let def_block_exn ctx (value : Value_state.t) =
  match value.Value_state.def with
  | Def_site.Block_arg { block_id; _ } ->
    Hashtbl.find_exn ctx.block_by_id block_id
  | Def_site.Instr instr_id -> block_for_instr_id_exn ctx instr_id
  | Def_site.Undefined -> failwith "value has no definition"
;;

(* TODO: implement, call when constant folding terminals and
   when deleting instructions *)
(* if [block] is unnecessary, remove it *)
let kill_block (_ : context) ~block:_ = ()

let defining_values_for_block_arg ctx ~block ~arg_index =
  Vec.filter_map (Block.parents block) ~f:(fun parent ->
    let parent_terminal = Block.terminal parent in
    match
      Ir.filter_map_call_blocks
        parent_terminal.Instr_state.ir
        ~f:(fun { Ir.Call_block.block = block'; args } ->
          if phys_equal block' block
          then Some (List.nth_exn args arg_index)
          else None)
    with
    | [] -> None
    | xs -> Some xs)
  |> Vec.to_list
  |> List.concat
;;

module Transform = struct
  let rec update_uses ctx ~old_ir ~new_ir =
    let old_values = Value_state.Set.of_list (Ir.uses old_ir) in
    let new_values = Value_state.Set.of_list (Ir.uses new_ir) in
    Set.iter (Set.diff old_values new_values) ~f:(fun value ->
      match active_value value with
      | None -> ()
      | Some value ->
        if Opt_flags.unused_vars ctx.opt_flags
           && Set.is_empty value.Value_state.uses
        then try_kill_value ctx ~value)

  and remove_instr ctx ~block ~instr =
    mark_changed ctx;
    let used_values = Ir.uses instr.Instr_state.ir in
    Fn_state.remove_instr ctx.fn_state ~block ~instr;
    List.iter used_values ~f:(fun value ->
      match active_value value with
      | None -> ()
      | Some value ->
        if Set.is_empty value.Value_state.uses then try_kill_value ctx ~value)

  and remove_arg_from_parent ctx ~parent ~idx ~from_block =
    mark_changed ctx;
    let removed = ref [] in
    let parent_terminal = Block.terminal parent in
    let new_ir =
      Ir.map_call_blocks parent_terminal.Instr_state.ir ~f:(fun cb ->
        if not (phys_equal cb.block from_block)
        then cb
        else
          { cb with
            args =
              List.filteri cb.args ~f:(fun i var ->
                if i = idx
                then (
                  removed := var :: !removed;
                  false)
                else true)
          })
    in
    Fn_state.replace_terminal_ir ctx.fn_state ~block:parent ~with_:new_ir;
    List.iter !removed ~f:(fun value ->
      match active_value value with
      | None -> ()
      | Some value ->
        if Set.is_empty value.Value_state.uses then try_kill_value ctx ~value)

  and remove_arg ctx ~block ~arg_index =
    mark_changed ctx;
    let args = Block.args block in
    let new_args = Vec.create () in
    Vec.iteri args ~f:(fun i arg ->
      if not (Int.equal i arg_index) then Vec.push new_args arg);
    Fn_state.set_block_args ctx.fn_state ~block ~args:new_args;
    Vec.iter (Block.parents block) ~f:(fun parent ->
      remove_arg_from_parent ctx ~parent ~idx:arg_index ~from_block:block)

  and kill_definition ctx (value : Value_state.t) =
    if not value.Value_state.active
    then ()
    else (
      mark_changed ctx;
      Value_state.Expert.set_active value false;
      let def_block =
        match value.Value_state.def with
        | Def_site.Undefined -> None
        | _ -> Some (def_block_exn ctx value)
      in
      match value.Value_state.def with
      | Def_site.Instr instr_id ->
        let instr = Fn_state.instr ctx.fn_state instr_id |> Option.value_exn in
        Option.iter def_block ~f:(fun block -> remove_instr ctx ~block ~instr)
      | Def_site.Block_arg { block_id; arg } ->
        let block = Hashtbl.find_exn ctx.block_by_id block_id in
        remove_arg ctx ~block ~arg_index:arg
      | Def_site.Undefined -> ())

  and try_kill_value ctx ~(value : Value_state.t) =
    if not value.Value_state.active
    then ()
    else (
      match Set.length value.Value_state.uses, value.Value_state.def with
      | 0, _ -> kill_definition ctx value
      | 1, Def_site.Block_arg { block_id; arg } ->
        let block = Hashtbl.find_exn ctx.block_by_id block_id in
        let use_id = Set.min_elt_exn value.Value_state.uses in
        let arg_value = value_of_var_exn ctx (Vec.get (Block.args block) arg) in
        if Instr_id.equal use_id (Block.terminal block).Instr_state.id
           && List.equal
                Value_state.equal
                [ arg_value ]
                (defining_values_for_block_arg ctx ~block ~arg_index:arg)
        then kill_definition ctx value
        else ()
      | _, _ -> ())
  ;;

  let replace_defining_instruction ctx ~(value : Value_state.t) ~new_ir =
    let old_instr_id =
      match value.Value_state.def with
      | Def_site.Block_arg _ ->
        failwith "Can't replace defining instr for block arg"
      | Def_site.Instr instr_id -> instr_id
      | Def_site.Undefined -> failwith "value has no definition"
    in
    let def_block = def_block_exn ctx value in
    let old_instr =
      Fn_state.instr ctx.fn_state old_instr_id |> Option.value_exn
    in
    let new_instr = Fn_state.alloc_instr ctx.fn_state ~ir:new_ir in
    mark_changed ctx;
    Fn_state.replace_instr
      ctx.fn_state
      ~block:def_block
      ~instr:old_instr
      ~with_instrs:[ new_instr ];
    update_uses ctx ~old_ir:old_instr.Instr_state.ir ~new_ir
  ;;

  let replace_terminal ctx ~block ~new_terminal_ir =
    let old_terminal = Block.terminal block in
    let old_blocks = Ir.blocks old_terminal.Instr_state.ir in
    let new_blocks = Ir.blocks new_terminal_ir in
    let diff =
      List.filter old_blocks ~f:(fun block' ->
        not (List.mem new_blocks block' ~equal:phys_equal))
    in
    mark_changed ctx;
    Vec.switch (Block.Expert.children block) (Vec.of_list new_blocks);
    List.iter diff ~f:(fun block' ->
      Vec.switch
        (Block.Expert.parents block')
        (Vec.filter (Block.parents block') ~f:(Fn.non (phys_equal block))));
    Fn_state.replace_terminal_ir ctx.fn_state ~block ~with_:new_terminal_ir;
    update_uses ctx ~old_ir:old_terminal.Instr_state.ir ~new_ir:new_terminal_ir
  ;;

  let replace_instruction_ir
    ctx
    ~(block : Block.t)
    ~(instr : _ Instr_state.t)
    ~new_ir
    =
    let old_ir = instr.Instr_state.ir in
    mark_changed ctx;
    if phys_equal instr (Block.terminal block)
    then Fn_state.replace_terminal_ir ctx.fn_state ~block ~with_:new_ir
    else
      Fn_state.replace_instr_with_irs
        ctx.fn_state
        ~block
        ~instr
        ~with_irs:[ new_ir ];
    update_uses ctx ~old_ir ~new_ir
  ;;
end

let try_kill_value = Transform.try_kill_value

let replace_value_uses
  ctx
  ~(from_value : Value_state.t)
  ~(to_value : Value_state.t)
  =
  if Value_state.equal from_value to_value
  then ()
  else (
    let uses = Set.to_list from_value.Value_state.uses in
    List.iter uses ~f:(fun instr_id ->
      let block = block_for_instr_id_exn ctx instr_id in
      let instr = Fn_state.instr ctx.fn_state instr_id |> Option.value_exn in
      let new_ir =
        Ir.map_uses instr.Instr_state.ir ~f:(fun use ->
          if Value_state.equal use from_value then to_value else use)
      in
      Transform.replace_instruction_ir ctx ~block ~instr ~new_ir);
    try_kill_value ctx ~value:from_value)
;;

(* --- Constant propagation helpers --- *)
let constant_fold ctx ~instr =
  let substituted = ref false in
  let mapped =
    Ir.map_lit_or_vars instr ~f:(fun lit_or_var ->
      match lit_or_var with
      | Lit _ -> lit_or_var
      | Var value ->
        (match value.Value_state.opt_tags.constant with
         | Some i ->
           substituted := true;
           Lit i
         | None -> lit_or_var)
      | Global _ -> lit_or_var)
  in
  let base = if !substituted then mapped else instr in
  let folded = Ir.constant_fold base in
  !substituted || not (phys_equal folded instr), folded
;;

let set_constant_tag ctx value constant =
  let prev = value.Value_state.opt_tags.constant in
  if not (Option.equal Int64.equal prev constant)
  then (
    Value_state.Expert.set_opt_tags value { constant };
    mark_changed ctx)
;;

let rec refine_type ctx ~(value : Value_state.t) =
  match value.Value_state.opt_tags.constant with
  | Some _ -> ()
  | None ->
    (match value.Value_state.def with
     | Def_site.Block_arg { block_id; arg } ->
       let block = Hashtbl.find_exn ctx.block_by_id block_id in
       refine_type_block_arg ctx ~value ~block ~arg_index:arg
     | Def_site.Instr instr_id -> refine_type_instr ctx ~value ~instr_id
     | Def_site.Undefined -> ())

and refine_type_block_arg ctx ~value ~block ~arg_index =
  defining_values_for_block_arg ctx ~block ~arg_index
  |> List.map ~f:(fun x -> x.opt_tags.constant)
  |> function
  | [] -> ()
  | constant :: xs ->
    let constant =
      List.fold xs ~init:constant ~f:(fun acc constant' ->
        match acc, constant' with
        | Some a, Some b when Int64.equal a b -> acc
        | _ -> None)
    in
    set_constant_tag ctx value constant

and refine_type_instr ctx ~value ~instr_id =
  let instr = Fn_state.instr ctx.fn_state instr_id |> Option.value_exn in
  let changed, new_ir = constant_fold ctx ~instr:instr.Instr_state.ir in
  let ir =
    if changed
    then (
      Transform.replace_defining_instruction ctx ~value ~new_ir;
      new_ir)
    else instr.Instr_state.ir
  in
  match Ir.constant ir with
  | None -> ()
  | Some _ as constant ->
    set_constant_tag ctx value constant;
    let terminal_uses =
      Ir.uses (Block.terminal (def_block_exn ctx value)).Instr_state.ir
    in
    if List.exists terminal_uses ~f:(fun use -> Value_state.equal use value)
    then refine_terminal ctx ~block:(def_block_exn ctx value)

and refine_terminal ctx ~block =
  let terminal = Block.terminal block in
  let changed, new_terminal_ir =
    constant_fold ctx ~instr:terminal.Instr_state.ir
  in
  if changed then Transform.replace_terminal ctx ~block ~new_terminal_ir
;;

let gvn (_ctx : context) ~(value : Value_state.t) =
  let _ = value in
  ()
;;

module Value_pass = struct
  type t =
    { name : string
    ; enabled : Opt_flags.t -> bool
    ; visit : context -> Value_state.t -> unit
    ; fixpoint : bool
    }
end

module Block_pass = struct
  type t =
    { name : string
    ; enabled : Opt_flags.t -> bool
    ; visit : context -> Block.t -> unit
    ; fixpoint : bool
    }
end

module Function_pass = struct
  type t =
    { name : string
    ; enabled : Opt_flags.t -> bool
    ; run : context -> unit
    ; fixpoint : bool
    }
end

type pass =
  | Value of Value_pass.t
  | Block of Block_pass.t
  | Function of Function_pass.t

module Pass_runner = struct
  let max_fixpoint_iterations = 8

  let run_value_pass ctx (pass : Value_pass.t) =
    if pass.enabled ctx.opt_flags
    then (
      let rec loop iteration =
        ctx.changed <- false;
        let seen = Int.Hash_set.create () in
        let instr_exn instr_id =
          Fn_state.instr ctx.fn_state instr_id |> Option.value_exn
        in
        let rec go (value : Value_state.t) =
          if not value.Value_state.active
          then ()
          else (
            let (Value_id id) = value.id in
            if Hash_set.mem seen id
            then ()
            else (
              Hash_set.add seen id;
              match value.Value_state.def with
              | Def_site.Block_arg _ -> pass.visit ctx value
              | Def_site.Instr instr_id ->
                let instr = instr_exn instr_id in
                List.iter (Ir.uses instr.Instr_state.ir) ~f:(fun use ->
                  Option.iter (active_value use) ~f:go);
                pass.visit ctx value
              | Def_site.Undefined -> ()))
        in
        Vec.iter ctx.fn_state.values ~f:(function
          | None -> ()
          | Some value -> go value);
        if pass.fixpoint && ctx.changed && iteration < max_fixpoint_iterations
        then loop (iteration + 1)
      in
      loop 1)
  ;;

  let run_block_pass ctx (pass : Block_pass.t) =
    if pass.enabled ctx.opt_flags
    then (
      let rec loop iteration =
        ctx.changed <- false;
        iter_blocks ctx ~f:(fun block -> pass.visit ctx block);
        if pass.fixpoint && ctx.changed && iteration < max_fixpoint_iterations
        then loop (iteration + 1)
      in
      loop 1)
  ;;

  let run_function_pass ctx (pass : Function_pass.t) =
    if pass.enabled ctx.opt_flags
    then (
      let rec loop iteration =
        ctx.changed <- false;
        pass.run ctx;
        if pass.fixpoint && ctx.changed && iteration < max_fixpoint_iterations
        then loop (iteration + 1)
      in
      loop 1)
  ;;

  let run ctx passes =
    List.iter passes ~f:(function
      | Value pass -> run_value_pass ctx pass
      | Block pass -> run_block_pass ctx pass
      | Function pass -> run_function_pass ctx pass)
  ;;
end

let pass_constant_propagation_values =
  Value
    { Value_pass.name = "constant_propagation_values"
    ; enabled = Opt_flags.constant_propagation
    ; visit = (fun ctx value -> refine_type ctx ~value)
    ; fixpoint = true
    }
;;

let pass_copy_propagation =
  Value
    { Value_pass.name = "copy_propagation"
    ; enabled = Opt_flags.constant_propagation
    ; visit =
        (fun ctx value ->
          match value.Value_state.def with
          | Def_site.Instr instr_id ->
            let instr =
              Fn_state.instr ctx.fn_state instr_id |> Option.value_exn
            in
            (match instr.Instr_state.ir with
             | Nod_ir.Ir.Move (_, Nod_ir.Lit_or_var.Var src)
               when src.Value_state.active && not (Value_state.equal value src)
               -> replace_value_uses ctx ~from_value:value ~to_value:src
             | _ -> ())
          | _ -> ())
    ; fixpoint = true
    }
;;

let pass_phi_simplify =
  Block
    { Block_pass.name = "phi_simplify"
    ; enabled = Opt_flags.constant_propagation
    ; visit =
        (fun ctx block ->
          Vec.iteri (Block.args block) ~f:(fun arg_index arg ->
            let value = value_of_var_exn ctx arg in
            match defining_values_for_block_arg ctx ~block ~arg_index with
            | [] -> ()
            | first :: rest ->
              if first.Value_state.active
                 && List.for_all rest ~f:(fun v -> Value_state.equal v first)
              then replace_value_uses ctx ~from_value:value ~to_value:first))
    ; fixpoint = true
    }
;;

let pass_terminal_simplify =
  Block
    { Block_pass.name = "simplify_terminals"
    ; enabled = Opt_flags.constant_propagation
    ; visit = (fun ctx block -> refine_terminal ctx ~block)
    ; fixpoint = true
    }
;;

let pass_arithmetic_simplify =
  Value
    { Value_pass.name = "simplify_arith"
    ; enabled = Opt_flags.constant_propagation
    ; visit =
        (fun ctx value ->
          match value.Value_state.def with
          | Def_site.Instr instr_id ->
            let instr =
              Fn_state.instr ctx.fn_state instr_id |> Option.value_exn
            in
            (match
               Peepholes.simplify
                 ~fn_state:ctx.fn_state
                 ~value
                 ~ir:instr.Instr_state.ir
             with
             | None -> ()
             | Some new_ir ->
               Transform.replace_defining_instruction ctx ~value ~new_ir)
          | _ -> ())
    ; fixpoint = true
    }
;;

let pass_dce =
  Value
    { Value_pass.name = "dce"
    ; enabled = Opt_flags.unused_vars
    ; visit = (fun ctx value -> try_kill_value ctx ~value)
    ; fixpoint = true
    }
;;

let pass_gvn =
  Value
    { Value_pass.name = "gvn"
    ; enabled = Opt_flags.gvn
    ; visit = (fun ctx value -> if value.Value_state.active then gvn ctx ~value)
    ; fixpoint = false
    }
;;

let passes =
  [ pass_constant_propagation_values
  ; pass_copy_propagation
  ; pass_phi_simplify
  ; pass_arithmetic_simplify
  ; pass_terminal_simplify
  ; pass_dce
  ; pass_gvn
  ; pass_constant_propagation_values
  ; pass_copy_propagation
  ]
;;

let run ctx = Pass_runner.run ctx passes

let optimize_root ?(opt_flags = Opt_flags.default) ~fn_state root =
  let ctx = create_context ~opt_flags ~fn_state root in
  run ctx
;;

let optimize ?(opt_flags = Opt_flags.default) ~state program =
  let program = Inline.run ~state ~opt_flags program in
  Map.iteri program.Program.functions ~f:(fun ~key:name ~data:fn ->
    let fn_state = State.fn_state state name in
    optimize_root ~opt_flags ~fn_state (Function.root fn));
  program
;;
