open! Core
open! Import
open! Common
open Ir

let default_clobbers =
  let callee_saved =
    Reg.callee_saved ~call_conv:Call_conv.Default Reg.Class.I64
    @ Reg.callee_saved ~call_conv:Call_conv.Default Reg.Class.F64
    |> Reg.Set.of_list
  in
  let all_physical =
    List.filter_map Reg.all_physical ~f:Util.should_save |> Reg.Set.of_list
  in
  Core.Set.diff all_physical callee_saved
;;

let regs_to_save ~state ~call_fn ~live_out =
  let callee_clobbers =
    match Core.Map.find state call_fn with
    | Some (state : Calc_clobbers.t) -> state.clobbers
    | None -> default_clobbers
  in
  (* TODO: I think this is fine to not filter for [should_save], because the phys calc liveness turns defs into the should save defs etc. This isn't that obvious though *)
  Core.Set.to_list (Core.Set.inter callee_clobbers live_out)
;;

let rec find_following_call
  ~(start : int)
  ~(len : int)
  ~(instructions : ('var, 'block) Nod_ir.Ir.t Vec.t)
  =
  if Int.(start >= len)
  then None
  else (
    match Vec.get instructions start with
    | Arm64 (Call { fn; _ }) -> Some fn
    | _ -> find_following_call ~start:(start + 1) ~len ~instructions)
;;

let reg_save_size reg =
  match Reg.class_ reg with
  | Reg.Class.I64 -> 8
  | Reg.Class.F64 -> 8
;;

let layout_reg_saves regs =
  let total, slots_rev =
    List.fold regs ~init:(0, []) ~f:(fun (offset, acc) reg ->
      let size = reg_save_size reg in
      let acc = (reg, offset) :: acc in
      offset + size, acc)
  in
  total, List.rev slots_rev
;;

let align_stack (bytes : int) =
  if Int.(bytes % 16 = 0) then bytes else bytes + (16 - (bytes % 16))
;;

let imm_of_int n = Int64.of_int n |> Arm64_ir.Imm
let sp_operand = Arm64_ir.Reg Reg.sp

let sub_sp bytes =
  Ir.arm64
    (Int_binary
       { op = Int_op.Sub
       ; dst = Reg.sp
       ; lhs = sp_operand
       ; rhs = imm_of_int bytes
       })
;;

let add_sp bytes =
  Ir.arm64
    (Int_binary
       { op = Int_op.Add
       ; dst = Reg.sp
       ; lhs = sp_operand
       ; rhs = imm_of_int bytes
       })
;;

let add_fp bytes =
  Ir.arm64
    (Int_binary
       { op = Int_op.Add
       ; dst = Reg.fp
       ; lhs = Arm64_ir.Reg Reg.fp
       ; rhs = imm_of_int bytes
       })
;;

let move_fp_to_sp = Ir.arm64 (Move { dst = Reg.fp; src = sp_operand })
let move_sp_to_fp = Ir.arm64 (Move { dst = Reg.sp; src = Arm64_ir.Reg Reg.fp })

let store_reg_at_sp reg offset =
  Ir.arm64
    (Store { src = Arm64_ir.Reg reg; addr = Arm64_ir.Mem (Reg.sp, offset) })
;;

let load_reg_from_sp reg offset =
  Ir.arm64 (Load { dst = reg; addr = Arm64_ir.Mem (Reg.sp, offset) })
;;

let save_and_restore_in_prologue_and_epilogue
  ~fn_state_by_name
  ~(state : Calc_clobbers.t String.Map.t)
  (functions : Function.t String.Map.t)
  =
  (* Insert the clobber stuff and stack management in prologue and epilogue *)
  Core.Map.iteri state ~f:(fun ~key:name ~data:{ to_restore; clobbers = _ } ->
    let fn = Core.Map.find_exn functions name in
    let to_restore = Core.Set.to_list to_restore in
    let bytes_for_clobber_saves, save_slots = layout_reg_saves to_restore in
    fn.bytes_for_clobber_saves <- bytes_for_clobber_saves;
    let prologue = Option.value_exn fn.prologue in
    let epilogue = Option.value_exn fn.epilogue in
    let header_bytes_excl_clobber_saves =
      fn.bytes_statically_alloca'd + fn.bytes_for_spills
    in
    let total_stack_usage =
      header_bytes_excl_clobber_saves + bytes_for_clobber_saves
    in
    let aligned_stack_usage =
      if Int.(total_stack_usage % 16 = 0)
      then total_stack_usage
      else total_stack_usage + (16 - (total_stack_usage % 16))
    in
    let header_bytes_excl_clobber_saves =
      header_bytes_excl_clobber_saves + (aligned_stack_usage - total_stack_usage)
    in
    let fn_state = Core.Map.find_exn fn_state_by_name name in
    let to_value = Fn_state.value_ir fn_state in
    let () =
      (* change prologue *)
      let new_prologue : (Value_state.t, Block.t) Nod_ir.Ir.t Vec.t =
        Vec.create ()
      in
      if Int.(aligned_stack_usage > 0)
      then Vec.push new_prologue (to_value (sub_sp aligned_stack_usage));
      List.iter save_slots ~f:(fun (reg, offset) ->
        Vec.push
          new_prologue
          (to_value
             (store_reg_at_sp
                reg
                (offset + fn.bytes_for_spills + fn.bytes_statically_alloca'd))));
      Vec.push new_prologue (to_value move_fp_to_sp);
      Vec.append
        new_prologue
        (Instr_state.to_ir_list (Block.instructions prologue) |> Vec.of_list);
      Fn_state.replace_irs
        fn_state
        ~block:prologue
        ~irs:(Vec.to_list new_prologue)
    in
    let () =
      (* change epilogue *)
      let new_epilogue =
        Instr_state.to_ir_list (Block.instructions epilogue) |> Vec.of_list
      in
      if List.is_empty to_restore
      then (
        Vec.push new_epilogue (to_value move_sp_to_fp);
        if Int.(header_bytes_excl_clobber_saves > 0)
        then
          Vec.push
            new_epilogue
            (to_value (add_sp header_bytes_excl_clobber_saves)))
      else
        ([ move_sp_to_fp ]
         @ List.map save_slots ~f:(fun (reg, offset) ->
           load_reg_from_sp
             reg
             (offset + fn.bytes_for_spills + fn.bytes_statically_alloca'd))
         @
         if Int.(aligned_stack_usage > 0)
         then [ add_sp aligned_stack_usage ]
         else [])
        |> List.iter ~f:(fun ir -> Vec.push new_epilogue (to_value ir));
      Fn_state.replace_irs
        fn_state
        ~block:epilogue
        ~irs:(Vec.to_list new_epilogue)
    in
    ())
;;

let save_and_restore_around_calls
  (type a)
  (module Calc_liveness : Calc_liveness.S
    with type Liveness_state.t = a
     and type Arg.t = Reg.t)
  ~fn_state
  ~state
  ~(liveness_state : a)
  (block : Block.t)
  =
  let open Calc_liveness in
  let block_state = Liveness_state.block_liveness liveness_state block in
  let instructions =
    Instr_state.to_ir_list (Block.instructions block) |> Vec.of_list
  in
  let to_value = Fn_state.value_ir fn_state in
  let len = Vec.length instructions in
  let new_instructions : (Value_state.t, Block.t) Nod_ir.Ir.t Vec.t =
    Vec.create ()
  in
  let pending = Stack.create () in
  let rec loop idx =
    if Int.(idx >= len)
    then ()
    else (
      let ir = Vec.get instructions idx in
      (match ir with
       | Nod_ir.Ir.Arm64 Save_clobbers ->
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
         let bytes, slots = layout_reg_saves regs in
         let aligned_bytes = align_stack bytes in
         Stack.push pending (slots, aligned_bytes);
         if Int.(aligned_bytes > 0)
         then Vec.push new_instructions (to_value (sub_sp aligned_bytes));
         List.iter slots ~f:(fun (reg, off) ->
           Vec.push new_instructions (to_value (store_reg_at_sp reg off)))
       | Nod_ir.Ir.Arm64 Restore_clobbers ->
         let slots, bytes =
           match Stack.pop pending with
           | Some layout -> layout
           | None -> failwith "Restore_clobbers without matching save"
         in
         List.iter (List.rev slots) ~f:(fun (reg, off) ->
           Vec.push new_instructions (to_value (load_reg_from_sp reg off)));
         if Int.(bytes > 0)
         then Vec.push new_instructions (to_value (add_sp bytes))
       | _ -> Vec.push new_instructions ir);
      loop (idx + 1))
  in
  loop 0;
  if not (Stack.is_empty pending)
  then failwith "Unbalanced Save_clobbers markers";
  Fn_state.replace_irs fn_state ~block ~irs:(Vec.to_list new_instructions);
  match (Block.terminal block).Instr_state.ir with
  | Nod_ir.Ir.Arm64 Save_clobbers | Nod_ir.Ir.Arm64 Restore_clobbers ->
    failwith "unexpected save/restore marker in terminal"
  | _ -> ()
;;

let process ~fn_state_by_name (functions : Function.t String.Map.t) =
  let state = Calc_clobbers.init_state functions in
  save_and_restore_in_prologue_and_epilogue ~fn_state_by_name ~state functions;
  Core.Map.iteri functions ~f:(fun ~key:name ~data:fn ->
    let fn_state = Core.Map.find_exn fn_state_by_name name in
    let reg_numbering = Reg_numbering.create fn.root in
    let (module Calc_liveness) = Calc_liveness.phys ~reg_numbering in
    let liveness_state = Calc_liveness.Liveness_state.create ~root:fn.root in
    Block.iter
      fn.root
      ~f:
        (save_and_restore_around_calls
           (module Calc_liveness)
           ~fn_state
           ~state
           ~liveness_state);
    let alloca_offset = ref 0 in
    Block.iter fn.root ~f:(fun block ->
      let map_ir ir =
        let ir = Nod_ir.Ir.map_vars ir ~f:Value_state.var in
        let ir =
          match ir with
          | Arm64 (Alloca (dest, i)) ->
            let offset = !alloca_offset in
            alloca_offset := !alloca_offset + Int64.to_int_exn i;
            (match dest with
             | Reg dst ->
               Nod_ir.Ir.Arm64
                 (Int_binary
                    { op = Int_op.Add
                    ; dst
                    ; lhs = Reg Reg.fp
                    ; rhs = Imm (Int64.of_int offset)
                    })
             | _ -> failwith "alloca dest must be a register")
          | ir -> ir
        in
        let ir =
          Ir.map_arm64_operands ir ~f:(function
            | Spill_slot i ->
              let offset = fn.bytes_statically_alloca'd + (i * 8) in
              Mem (Reg.fp, offset)
            | x -> x)
        in
        Fn_state.value_ir fn_state ir
      in
      let instructions =
        Instr_state.to_ir_list (Block.instructions block) |> List.map ~f:map_ir
      in
      Fn_state.replace_irs fn_state ~block ~irs:instructions;
      Fn_state.replace_terminal_ir
        fn_state
        ~block
        ~with_:(map_ir (Block.terminal block).Instr_state.ir)));
  functions
;;
