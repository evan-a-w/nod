open! Core
open! Import
open! Common

module Clobbers = struct
  type fn_state =
    { to_restore : Reg.Set.t
    ; clobbers : Reg.Set.t
    }

  let calc_edges (functions : Function.t String.Map.t) =
    let edges = String.Table.create () in
    let defs = String.Table.create () in
    let uses_fn fn1 fn2 =
      let edges =
        Hashtbl.find_or_add edges fn1 ~default:String.Hash_set.create
      in
      Hash_set.add edges fn2
    in
    Map.iter functions ~f:(fun function_ ->
      let this_defs = ref Reg.Set.empty in
      Hashtbl.add_exn
        edges
        ~key:function_.name
        ~data:(String.Hash_set.create ());
      Block.iter_instructions function_.root ~f:(fun ir ->
        this_defs := Set.union !this_defs (Ir.x86_reg_defs ir |> Reg.Set.of_list);
        on_x86_irs ir ~f:(fun x86_ir ->
          match x86_ir with
          | CALL { fn; results = _; args = _ } -> uses_fn function_.name fn
          | _ -> ()));
      Hashtbl.add_exn defs ~key:function_.name ~data:!this_defs);
    ~edges, ~defs
  ;;

  let callee_saved ~call_conv =
    match (call_conv : Call_conv.t) with
    | Default -> Reg.integer_callee_saved |> Reg.Set.of_list
  ;;

  let init_state (functions : Function.t String.Map.t) : fn_state String.Map.t =
    (* dumb algo to work out clobbers, I think doing scc to sort out cycles first would make it O(n) instead *)
    let ~edges, ~defs = calc_edges functions in
    let worklist = Queue.create () in
    let clobbers = String.Table.create () in
    let to_restore = String.Table.create () in
    Map.iter functions ~f:(Queue.enqueue worklist);
    while not (Queue.is_empty worklist) do
      let fn = Queue.dequeue_exn worklist in
      let old_clobbers =
        Hashtbl.find_or_add clobbers fn.name ~default:(fun () -> Reg.Set.empty)
      in
      Hashtbl.update to_restore fn.name ~f:(function
        | Some x -> x
        | None ->
          Set.inter
            (Hashtbl.find_exn defs fn.name)
            (callee_saved ~call_conv:fn.call_conv));
      let new_clobbers_raw =
        Reg.Set.union_list
          (Hashtbl.find_exn defs fn.name
           :: (Hashtbl.find_exn edges fn.name
               |> Hash_set.to_list
               |> List.map ~f:(fun fn' ->
                 Hashtbl.find clobbers fn'
                 (* CR-soon ewilliams: This won't work for extern functions, where we need to know a callconv and assume everything is clobbered. These don't exist yet. *)
                 |> Option.value ~default:Reg.Set.empty)))
      in
      let new_clobbers =
        Set.diff new_clobbers_raw (callee_saved ~call_conv:fn.call_conv)
      in
      Hashtbl.set clobbers ~key:fn.name ~data:new_clobbers;
      if not (Reg.Set.equal new_clobbers old_clobbers)
      then Map.iter functions ~f:(Queue.enqueue worklist)
    done;
    Map.map functions ~f:(fun fn ->
      { clobbers = Hashtbl.find_exn clobbers fn.name
      ; to_restore = Hashtbl.find_exn to_restore fn.name
      })
  ;;

  let process (functions : Function.t String.Map.t) =
    let state = init_state functions in
    (* Insert the clobber stuff and stack management in prologue and epilogue *)
    Map.iteri state ~f:(fun ~key:name ~data:{ to_restore; clobbers = _ } ->
      let fn = Map.find_exn functions name in
      fn.bytes_for_clobber_saves <- Set.length to_restore * 8;
      let prologue = Option.value_exn fn.prologue in
      let epilogue = Option.value_exn fn.epilogue in
      let to_restore = Set.to_list to_restore in
      let () =
        let header_bytes_excl_clobber_saves =
          fn.bytes_alloca'd + fn.bytes_for_spills
        in
        let new_prologue : Ir.t Vec.t = Vec.create () in
        (* change prologue *)
        if header_bytes_excl_clobber_saves > 0
        then
          Vec.push
            new_prologue
            (X86
               (sub
                  (Reg RSP)
                  (Imm (Int64.of_int header_bytes_excl_clobber_saves))));
        List.iter to_restore ~f:(fun reg ->
          Vec.push new_prologue (X86 (push (Reg reg))));
        Vec.push new_prologue (X86 (mov (Reg RBP) (Reg RSP)));
        if Function.stack_header_bytes fn > 0
        then
          Vec.push
            new_prologue
            (X86
               (add
                  (Reg RBP)
                  (Imm (Function.stack_header_bytes fn |> Int64.of_int))));
        Vec.append new_prologue prologue.instructions;
        prologue.instructions <- new_prologue
      in
      let () =
        (* change epilogue *)
        if List.is_empty to_restore
        then Vec.push epilogue.instructions (X86 (mov (Reg RSP) (Reg RBP)))
        else
          List.map
            ~f:Ir.x86
            ([ mov (Reg RSP) (Reg RBP)
             ; sub
                 (Reg RSP)
                 (Imm (Function.stack_header_bytes fn |> Int64.of_int))
             ]
             @ List.map (List.rev to_restore) ~f:pop
             @
             if fn.bytes_alloca'd + fn.bytes_for_spills > 0
             then
               [ add
                   (Reg RSP)
                   (Imm (fn.bytes_alloca'd + fn.bytes_for_spills |> Int64.of_int))
               ]
             else [])
          |> List.iter ~f:(Vec.push epilogue.instructions)
      in
      ());
    functions
  ;;
end

module Save_call_clobbers = struct
  module Liveness = struct
    type t =
      { live_in : Reg.Set.t
      ; live_out : Reg.Set.t
      }

    let empty = { live_in = Reg.Set.empty; live_out = Reg.Set.empty }
  end

  let is_physical_reg = function
    | Reg.Unallocated _ | Allocated _ -> false
    | _ -> true
  ;;

  let should_save reg =
    match reg with
    | Reg.RSP -> false
    | _ -> is_physical_reg reg
  ;;

  module Phys_liveness = struct
    type block_liveness =
      { mutable instructions : Liveness.t Vec.t
      ; mutable terminal : Liveness.t
      ; mutable overall : Liveness.t
      ; defs : Reg.Set.t
      ; uses : Reg.Set.t
      }

    type t = { blocks : block_liveness Block.Table.t }

    let block_liveness t block = Hashtbl.find_exn t.blocks block
    let filter_physical set = Set.filter set ~f:is_physical_reg
    let reg_union_list sets = Reg.Set.union_list sets

    let reg_defs_of_ir = function
      | Ir0.X86 x -> filter_physical (X86_ir.reg_defs x)
      | Ir0.X86_terminal xs ->
        reg_union_list (List.map xs ~f:X86_ir.reg_defs) |> filter_physical
      | _ -> Reg.Set.empty
    ;;

    let reg_uses_of_ir = function
      | Ir0.X86 x -> filter_physical (X86_ir.reg_uses x)
      | Ir0.X86_terminal xs ->
        reg_union_list (List.map xs ~f:X86_ir.reg_uses) |> filter_physical
      | _ -> Reg.Set.empty
    ;;

    let defs_and_uses (block : Block.t) =
      let defs = ref Reg.Set.empty in
      let uses = ref Reg.Set.empty in
      let update ir =
        let defs_ir = reg_defs_of_ir ir in
        let uses_ir = reg_uses_of_ir ir in
        uses := Set.union !uses (Set.diff uses_ir !defs);
        defs := Set.union !defs defs_ir
      in
      Vec.iter block.instructions ~f:update;
      update block.terminal;
      !defs, !uses
    ;;

    let create root =
      let blocks = Block.Table.create () in
      Block.iter root ~f:(fun block ->
        let defs, uses = defs_and_uses block in
        Hashtbl.add_exn
          blocks
          ~key:block
          ~data:
            { instructions = Vec.create ()
            ; terminal = Liveness.empty
            ; overall = Liveness.empty
            ; defs
            ; uses
            });
      { blocks }
    ;;

    let calculate_block_liveness t root =
      let queue = Queue.create () in
      Block.iter root ~f:(Queue.enqueue queue);
      while not (Queue.is_empty queue) do
        let block = Queue.dequeue_exn queue in
        let block_state = block_liveness t block in
        let succs =
          Ir0.call_blocks block.terminal |> List.map ~f:Call_block.block
        in
        let live_out =
          List.fold succs ~init:Reg.Set.empty ~f:(fun acc succ ->
            let succ_state = block_liveness t succ in
            Set.union acc succ_state.overall.live_in)
        in
        let live_in =
          Set.union block_state.uses (Set.diff live_out block_state.defs)
        in
        if not
             (Set.equal live_out block_state.overall.live_out
              && Set.equal live_in block_state.overall.live_in)
        then (
          block_state.overall <- { Liveness.live_in; live_out };
          Vec.iter block.parents ~f:(Queue.enqueue queue))
      done
    ;;

    let calculate_intra_block_liveness t root =
      let update_from_after
        ({ Liveness.live_in = next_live_in; _ } : Liveness.t)
        ir
        =
        let live_out = next_live_in in
        let live_in =
          Set.union (reg_uses_of_ir ir) (Set.diff live_out (reg_defs_of_ir ir))
        in
        { Liveness.live_in; live_out }
      in
      Block.iter root ~f:(fun block ->
        let block_state = block_liveness t block in
        let terminal_live_out = block_state.overall.live_out in
        let terminal_live_in =
          Set.union
            (reg_uses_of_ir block.terminal)
            (Set.diff terminal_live_out (reg_defs_of_ir block.terminal))
        in
        block_state.terminal
        <- { Liveness.live_in = terminal_live_in; live_out = terminal_live_out };
        Vec.clear block_state.instructions;
        let (_ : Liveness.t) =
          Vec.foldr
            block.instructions
            ~init:block_state.terminal
            ~f:(fun after ir ->
              let liveness = update_from_after after ir in
              Vec.push block_state.instructions liveness;
              liveness)
        in
        Vec.reverse_inplace block_state.instructions)
    ;;
  end

  let default_clobbers =
    let callee_saved = Clobbers.callee_saved ~call_conv:Call_conv.Default in
    Array.fold Reg.all_physical ~init:Reg.Set.empty ~f:(fun acc reg ->
      if should_save reg then Set.add acc reg else acc)
    |> fun all_physical -> Set.diff all_physical callee_saved
  ;;

  let regs_to_save ~state ~call_fn ~live_out =
    let callee_clobbers =
      match Map.find state call_fn with
      | Some (state : Clobbers.fn_state) -> state.clobbers
      | None -> default_clobbers
    in
    Set.inter callee_clobbers live_out
    |> Set.filter ~f:should_save
    |> Set.to_list
  ;;

  let rec find_following_call ~start ~len ~instructions =
    if start >= len
    then None
    else (
      match Vec.get instructions start with
      | Ir0.X86 (CALL { fn; _ }) -> Some fn
      | _ -> find_following_call ~start:(start + 1) ~len ~instructions)
  ;;

  let process_block ~state ~liveness block =
    let block_state = Phys_liveness.block_liveness liveness block in
    let instructions = block.instructions in
    let len = Vec.length instructions in
    let new_instructions = Vec.create () in
    let pending = Stack.create () in
    let rec loop idx =
      if idx >= len
      then ()
      else (
        let ir = Vec.get instructions idx in
        (match ir with
         | Ir0.X86 Save_clobbers ->
           let liveness_at_instr = Vec.get block_state.instructions idx in
           let call_fn =
             match find_following_call ~start:(idx + 1) ~len ~instructions with
             | Some fn -> fn
             | None -> failwith "Save_clobbers without following CALL"
           in
           let regs =
             regs_to_save
               ~state
               ~call_fn
               ~live_out:liveness_at_instr.Liveness.live_out
           in
           Stack.push pending regs;
           List.iter regs ~f:(fun reg ->
             Vec.push new_instructions (Ir0.X86 (push (Reg reg))))
         | Ir0.X86 Restore_clobbers ->
           let regs =
             match Stack.pop pending with
             | Some regs -> regs
             | None -> failwith "Restore_clobbers without matching save"
           in
           List.iter (List.rev regs) ~f:(fun reg ->
             Vec.push new_instructions (Ir0.X86 (pop reg)))
         | _ -> Vec.push new_instructions ir);
        loop (idx + 1))
    in
    loop 0;
    if not (Stack.is_empty pending)
    then failwith "Unbalanced Save_clobbers markers";
    block.instructions <- new_instructions;
    match block.terminal with
    | Ir0.X86 Save_clobbers | Ir0.X86 Restore_clobbers ->
      failwith "unexpected save/restore marker in terminal"
    | _ -> ()
  ;;

  let process (functions : Function.t String.Map.t) =
    let state = Clobbers.init_state functions in
    Map.iter functions ~f:(fun fn ->
      let liveness = Phys_liveness.create fn.root in
      Phys_liveness.calculate_block_liveness liveness fn.root;
      Phys_liveness.calculate_intra_block_liveness liveness fn.root;
      Block.iter fn.root ~f:(process_block ~state ~liveness));
    functions
  ;;
end

let compile ?dump_crap (functions : Function.t String.Map.t) =
  Map.map functions ~f:(fun fn ->
    Instruction_selection.run fn |> Regalloc.run ?dump_crap)
  |> Clobbers.process
  |> Save_call_clobbers.process
;;

let compile_to_asm ?dump_crap functions =
  compile ?dump_crap functions |> Lower.run
;;
