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

  let default_clobbers =
    let callee_saved = Clobbers.callee_saved ~call_conv:Call_conv.Default in
    Array.fold Reg.all_physical ~init:Reg.Set.empty ~f:(fun acc reg ->
      if Reg.should_save reg then Set.add acc reg else acc)
    |> fun all_physical -> Set.diff all_physical callee_saved
  ;;

  let regs_to_save ~state ~call_fn ~live_out =
    let callee_clobbers =
      match Map.find state call_fn with
      | Some (state : Clobbers.fn_state) -> state.clobbers
      | None -> default_clobbers
    in
    Set.inter callee_clobbers live_out
    |> Set.filter ~f:Reg.should_save
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

  let process_block
    (type a)
    (module Calc_liveness : Calc_liveness.S
      with type Liveness_state.t = a
       and type Arg.t = Reg.t)
    ~state
    ~(liveness_state : a)
    (block : Block.t)
    =
    let open Calc_liveness in
    let block_state = Liveness_state.block_liveness liveness_state block in
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
               ~live_out:
                 (Liveness.live_out' liveness_at_instr |> Reg.Set.of_list)
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
      let reg_numbering = Reg_numbering.create fn.root in
      let (module Calc_liveness) = Calc_liveness.phys ~reg_numbering in
      let liveness_state = Calc_liveness.Liveness_state.create ~root:fn.root in
      Block.iter
        fn.root
        ~f:(process_block (module Calc_liveness) ~state ~liveness_state));
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
