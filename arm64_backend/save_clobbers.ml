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
    match Vec.get instructions start with
    | Ir0.X86 (CALL { fn; _ }) -> Some fn
    | _ -> find_following_call ~start:(start + 1) ~len ~instructions)
;;

let save_and_restore_in_prologue_and_epilogue
  ~(state : Calc_clobbers.t String.Map.t)
  (functions : Function.t String.Map.t)
  =
  (* Insert the clobber stuff and stack management in prologue and epilogue *)
  Map.iteri state ~f:(fun ~key:name ~data:{ to_restore; clobbers = _ } ->
    let fn = Map.find_exn functions name in
    fn.bytes_for_clobber_saves <- Set.length to_restore * 8;
    let prologue = Option.value_exn fn.prologue in
    let epilogue = Option.value_exn fn.epilogue in
    let to_restore = Set.to_list to_restore in
    let () =
      (* change prologue *)
      let header_bytes_excl_clobber_saves =
        fn.bytes_alloca'd + fn.bytes_for_spills
      in
      let new_prologue : Ir.t Vec.t = Vec.create () in
      if header_bytes_excl_clobber_saves > 0
      then
        Vec.push
          new_prologue
          (X86
             (sub
                (Reg Reg.rsp)
                (Imm (Int64.of_int header_bytes_excl_clobber_saves))));
      List.iter to_restore ~f:(fun reg ->
        Vec.push new_prologue (X86 (push (Reg reg))));
      Vec.push new_prologue (X86 (mov (Reg Reg.rbp) (Reg Reg.rsp)));
      if fn.bytes_for_clobber_saves > 0
      then
        Vec.push
          new_prologue
          (X86
             (add
                (Reg Reg.rbp)
                (Imm (fn.bytes_for_clobber_saves |> Int64.of_int))));
      Vec.append new_prologue prologue.instructions;
      prologue.instructions <- new_prologue
    in
    let () =
      (* change epilogue *)
      if List.is_empty to_restore
      then
        Vec.push epilogue.instructions (X86 (mov (Reg Reg.rsp) (Reg Reg.rbp)))
      else
        List.map
          ~f:Ir.x86
          ([ mov (Reg Reg.rsp) (Reg Reg.rbp)
           ; sub
               (Reg Reg.rsp)
               (Imm (fn.bytes_for_clobber_saves |> Int64.of_int))
           ]
           @ List.map (List.rev to_restore) ~f:pop
           @
           if fn.bytes_alloca'd + fn.bytes_for_spills > 0
           then
             [ add
                 (Reg Reg.rsp)
                 (Imm (fn.bytes_alloca'd + fn.bytes_for_spills |> Int64.of_int))
             ]
           else [])
        |> List.iter ~f:(Vec.push epilogue.instructions)
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
             ~live_out:(Liveness.live_out' liveness_at_instr |> Reg.Set.of_list)
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
  let state = Calc_clobbers.init_state functions in
  save_and_restore_in_prologue_and_epilogue ~state functions;
  Map.iter functions ~f:(fun fn ->
    let reg_numbering = Reg_numbering.create fn.root in
    let (module Calc_liveness) = Calc_liveness.phys ~reg_numbering in
    let liveness_state = Calc_liveness.Liveness_state.create ~root:fn.root in
    Block.iter
      fn.root
      ~f:
        (save_and_restore_around_calls
           (module Calc_liveness)
           ~state
           ~liveness_state));
  functions
;;
