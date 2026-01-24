open! Core
open! Import
open! Common

let default_clobbers =
  let callee_saved =
    Reg.callee_saved ~call_conv:Call_conv.Default X86_reg.Class.I64
    @ Reg.callee_saved ~call_conv:Call_conv.Default X86_reg.Class.F64
    |> Reg.Set.of_list
  in
  let all_physical =
    List.filter_map Reg.all_physical ~f:Util.should_save |> Reg.Set.of_list
  in
  Set.diff all_physical callee_saved
;;

let regs_to_save ~state ~call_fn ~live_out =
  let callee_clobbers =
    match Map.find state call_fn with
    | Some (state : Calc_clobbers.t) -> state.clobbers
    | None -> default_clobbers
  in
  (* TODO: I think this is fine to not filter for [should_save], because the phys calc liveness turns defs into the should save defs etc. This isn't that obvious though *)
  Set.inter callee_clobbers live_out |> Set.to_list
;;

let rec find_following_call ~start ~len ~instructions =
  if start >= len
  then None
  else (
    match instructions.(start) with
    | Ir0.X86 (CALL { fn; _ }) -> Some fn
    | _ -> find_following_call ~start:(start + 1) ~len ~instructions)
;;

let save_and_restore_in_prologue_and_epilogue
  ~(clobbers : Calc_clobbers.t String.Map.t)
  ~(ssa_states : State.t)
  (functions : Function.t String.Map.t)
  =
  (* Insert the clobber stuff and stack management in prologue and epilogue *)
  Map.iteri clobbers ~f:(fun ~key:name ~data:{ to_restore; clobbers = _ } ->
    let fn = Map.find_exn functions name in
    let prologue = Option.value_exn fn.prologue in
    let epilogue = Option.value_exn fn.epilogue in
    let function_state = State.state_for_function ssa_states name in
    let prologue_state = function_state in
    let epilogue_state = function_state in
    let () = Breadcrumbs.frame_pointer_omission in
    (* always restore RBP (so just remove it here, and we push it below anyway) *)
    let to_restore =
      Set.remove to_restore Reg.rbp
      |> Set.to_list
      |> List.filter_map ~f:Util.should_save
    in
    fn.bytes_for_clobber_saves <- List.length to_restore * 8;
    (* align to 16 bytes *)
    fn.bytes_for_padding
    <- (let m =
          ((* 8 bytes for return address on stack, 8 for rbp (ofc 16 is redundant, but for clarity) *)
           8
           + 8
           + fn.bytes_for_spills
           + fn.bytes_statically_alloca'd
           + fn.bytes_for_clobber_saves)
          mod 16
        in
        if m = 0 then 0 else 16 - m);
    let extra_bytes_after_callee_saves =
      fn.bytes_for_spills + fn.bytes_statically_alloca'd + fn.bytes_for_padding
    in
    let () =
      (* change prologue *)
      let new_prologue =
        [ Ir0.X86 (push (Reg Reg.rbp)); Ir0.X86 (mov (Reg Reg.rbp) (Reg Reg.rsp)) ]
        @ List.map to_restore ~f:(fun reg -> Ir0.X86 (push (Reg reg)))
        @ (if extra_bytes_after_callee_saves > 0
           then
             [ Ir0.X86
                 (sub
                    (Reg Reg.rsp)
                    (Imm (extra_bytes_after_callee_saves |> Int64.of_int))) ]
           else [])
        @ Block.instrs_to_ir_list prologue
      in
      Ssa_state.replace_block_instructions
        prologue_state
        ~block:prologue
        ~irs:new_prologue
    in
    let () =
      (* change epilogue *)
      let new_epilogue =
        Block.instrs_to_ir_list epilogue
        @ [ Ir0.X86
              (sub
                 (* sub rbp first, because we don't want rsp to be above places we care about in case the os clobbers them *)
                 (Reg Reg.rbp)
                 (Imm (fn.bytes_for_clobber_saves |> Int64.of_int)))
          ; Ir0.X86 (mov (Reg Reg.rsp) (Reg Reg.rbp))
          ]
        @ List.rev_map to_restore ~f:(fun reg -> Ir0.X86 (pop reg))
        @ [ Ir0.X86 (pop Reg.rbp) ]
      in
      Ssa_state.replace_block_instructions
        epilogue_state
        ~block:epilogue
        ~irs:new_epilogue
    in
    ())
;;

let save_and_restore_around_calls
  (type a)
  (module Calc_liveness : Calc_liveness.S
    with type Liveness_state.t = a
     and type Arg.t = Reg.t)
  ~state
  ~(liveness_state : a)
  ~(ssa_state : Ssa_state.t)
  (block : Block.t)
  =
  let open Calc_liveness in
  let block_state = Liveness_state.block_liveness liveness_state block in
  let instructions = Block.instrs_to_ir_list block |> Array.of_list in
  let len = Array.length instructions in
  let new_instructions = Vec.create () in
  let pending = Stack.create () in
  let rec loop idx =
    if idx >= len
    then ()
    else (
      let ir = instructions.(idx) in
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
             ~live_out:(Liveness.live_out' liveness_at_instr |> Reg.Set.of_list)
         in
         let sub_for_align =
           let m = Stack.length pending * 8 mod 16 in
           if m = 0 then 0 else 16 - m
         in
         Stack.push pending (regs, sub_for_align);
         if sub_for_align <> 0
         then
           Vec.push
             new_instructions
             (Ir0.X86 (sub (Reg Reg.rsp) (Imm (Int64.of_int sub_for_align))));
         List.iter regs ~f:(fun reg ->
           Vec.push new_instructions (Ir0.X86 (push (Reg reg))))
       | Ir0.X86 Restore_clobbers ->
         let regs, sub_for_align =
           match Stack.pop pending with
           | Some regs -> regs
           | None -> failwith "Restore_clobbers without matching save"
         in
         List.iter (List.rev regs) ~f:(fun reg ->
           Vec.push new_instructions (Ir0.X86 (pop reg)));
         if sub_for_align <> 0
         then
           Vec.push
             new_instructions
             (Ir0.X86 (add (Reg Reg.rsp) (Imm (Int64.of_int sub_for_align))))
       | _ -> Vec.push new_instructions ir);
      loop (idx + 1))
  in
  loop 0;
  if not (Stack.is_empty pending)
  then failwith "Unbalanced Save_clobbers markers";
  Ssa_state.replace_block_instructions
    ssa_state
    ~block
    ~irs:(Vec.to_list new_instructions);
  match block.terminal.ir with
  | Ir0.X86 Save_clobbers | Ir0.X86 Restore_clobbers ->
    failwith "unexpected save/restore marker in terminal"
  | _ -> ()
;;

let process ~state (functions : Function.t String.Map.t) =
  let clobbers_state = Calc_clobbers.init_state functions in
  save_and_restore_in_prologue_and_epilogue
    ~clobbers:clobbers_state
    ~ssa_states:state
    functions;
  Map.iter functions ~f:(fun fn ->
    let reg_numbering = Reg_numbering.create fn.root in
    let (module Calc_liveness) = Calc_liveness.phys ~reg_numbering in
    let liveness_state = Calc_liveness.Liveness_state.create ~root:fn.root in
    Block.iter
      fn.root
      ~f:
        (save_and_restore_around_calls
           (module Calc_liveness)
           ~state:clobbers_state
           ~liveness_state
           ~ssa_state:(State.state_for_function state fn.name));
    let alloca_offset =
      ref
        (fn.bytes_for_clobber_saves + fn.bytes_for_padding + fn.bytes_for_spills)
    in
    let function_state = State.state_for_function state fn.name in
    Block.iter fn.root ~f:(fun block ->
      let map_ir (ir : Ir.t) =
        let ir =
          match ir with
          | X86 (ALLOCA (dest, i)) ->
            alloca_offset := !alloca_offset + Int64.to_int_exn i;
            (match dest with
             | Reg _ ->
               Ir.x86_terminal
                 ([ mov dest (Reg Reg.rbp) ]
                  @ [ sub dest (Imm (Int64.of_int !alloca_offset)) ])
             | _ -> failwith "alloca dest must be a register")
          | ir -> ir
        in
        Ir.map_x86_operands ir ~f:(function
          | Spill_slot i ->
            let offset =
              -(fn.bytes_for_padding + fn.bytes_for_clobber_saves + ((i + 1) * 8)
               )
            in
            Mem (Reg.rbp, offset)
          | x -> x)
      in
      let instrs = Block.instrs_to_ir_list block |> List.map ~f:map_ir in
      Ssa_state.replace_block_instructions function_state ~block ~irs:instrs;
      Ssa_state.set_terminal_ir function_state ~block ~ir:(map_ir block.terminal.ir)));
  functions
;;
