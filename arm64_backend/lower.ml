open! Core
open! Import
open! Common
open Arm64_ir
module Reg = Arm64_reg
module Asm = Arm64_asm

let sanitize_identifier s =
  let sanitized =
    String.filter_map s ~f:(fun c ->
      match c with
      | 'A' .. 'Z' -> Some (Char.lowercase c)
      | 'a' .. 'z' | '0' .. '9' | '_' -> Some c
      | _ -> Some '_')
  in
  let sanitized = if String.is_empty sanitized then "_" else sanitized in
  if Char.is_digit sanitized.[0] then "_" ^ sanitized else sanitized
;;

let gpr_scratch_pool = Arm64_reg.scratch ~class_:I64
let fpr_scratch_pool = Arm64_reg.scratch ~class_:F64

let rec pick_scratch pool avoid =
  match pool with
  | [] -> failwith "no scratch registers available"
  | reg :: rest ->
    if List.exists avoid ~f:(fun r -> Arm64_reg.equal Poly.equal reg r)
    then pick_scratch rest avoid
    else reg
;;

let ensure_gpr operand ~dst ~avoid =
  match operand with
  | Spill_slot _ -> failwith "Shouldn't have spill slot here"
  | Reg reg -> [], reg, avoid
  | Imm imm ->
    let scratch = pick_scratch gpr_scratch_pool (dst :: avoid) in
    [ Asm.Mov { dst = scratch; src = Imm imm } ], scratch, scratch :: avoid
  | Mem (reg, disp) ->
    let scratch = pick_scratch gpr_scratch_pool (dst :: avoid) in
    ( [ Asm.Ldr { dst = scratch; addr = Mem (reg, disp) } ]
    , scratch
    , scratch :: avoid )
;;

let ensure_fpr operand ~dst ~avoid =
  match operand with
  | Spill_slot _ -> failwith "Shouldn't have spill slot here"
  | Reg reg -> [], reg, avoid
  | Mem (reg, disp) ->
    let scratch = pick_scratch fpr_scratch_pool (dst :: avoid) in
    ( [ Asm.Ldr { dst = scratch; addr = Mem (reg, disp) } ]
    , scratch
    , scratch :: avoid )
  | Imm imm ->
    let fp_scratch = pick_scratch fpr_scratch_pool (dst :: avoid) in
    let gpr_scratch = pick_scratch gpr_scratch_pool [] in
    ( [ Asm.Mov { dst = gpr_scratch; src = Imm imm }
      ; Asm.Fmov { dst = fp_scratch; src = Reg gpr_scratch }
      ]
    , fp_scratch
    , fp_scratch :: avoid )
;;

let rec unwrap_tags = function
  | Tag_use (ins, _) | Tag_def (ins, _) -> unwrap_tags ins
  | ins -> ins
;;

let order_blocks root =
  let idx_by_block = Block.Table.create () in
  let blocks = Nod_vec.create () in
  let try_push block =
    let idx = Nod_vec.length blocks in
    match Hashtbl.add idx_by_block ~key:block ~data:idx with
    | `Duplicate -> ()
    | `Ok -> Nod_vec.push blocks block
  in
  let seen = Block.Hash_set.create () in
  let q = Queue.of_list [ root ] in
  let rec go () =
    match Queue.dequeue q with
    | None -> ()
    | Some block ->
      (match Hash_set.mem seen block with
       | true -> go ()
       | false ->
         Hash_set.add seen block;
         try_push block;
         Nod_vec.iter (Block.children block) ~f:(fun child ->
           if Nod_vec.length (Block.parents child) = 1
              && not (Hashtbl.mem idx_by_block child)
           then try_push child);
         Nod_vec.iter (Block.children block) ~f:(Queue.enqueue q);
         go ())
  in
  go ();
  ~idx_by_block, ~blocks
;;

let is_next_block ~idx_by_block ~current_idx target_block =
  match Hashtbl.find idx_by_block target_block with
  | None -> false
  | Some target_idx -> target_idx = current_idx + 1
;;

let invert_condition = function
  | Condition.Eq -> Condition.Ne
  | Ne -> Eq
  | Lt -> Ge
  | Le -> Gt
  | Gt -> Le
  | Ge -> Lt
  | Pl -> Mi
  | Mi -> Pl
;;

let lower_int_binary ~op ~dst ~lhs ~rhs =
  let lhs_setup, lhs_reg, used = ensure_gpr lhs ~dst ~avoid:[] in
  let rhs_setup, rhs_reg, used = ensure_gpr rhs ~dst ~avoid:used in
  let body =
    match op with
    | Int_op.Add -> [ Asm.Add { dst; lhs = lhs_reg; rhs = rhs_reg } ]
    | Sub -> [ Asm.Sub { dst; lhs = lhs_reg; rhs = rhs_reg } ]
    | Mul -> [ Asm.Mul { dst; lhs = lhs_reg; rhs = rhs_reg } ]
    | Sdiv -> [ Asm.Sdiv { dst; lhs = lhs_reg; rhs = rhs_reg } ]
    | Smod ->
      let scratch = pick_scratch gpr_scratch_pool (dst :: used) in
      [ Asm.Sdiv { dst = scratch; lhs = lhs_reg; rhs = rhs_reg }
      ; Asm.Msub { dst; lhs = scratch; rhs = rhs_reg; acc = lhs_reg }
      ]
    | And -> [ Asm.And { dst; lhs = lhs_reg; rhs = rhs_reg } ]
    | Orr -> [ Asm.Orr { dst; lhs = lhs_reg; rhs = rhs_reg } ]
    | Eor -> [ Asm.Eor { dst; lhs = lhs_reg; rhs = rhs_reg } ]
    | Lsl -> [ Asm.Lsl { dst; lhs = lhs_reg; rhs = rhs_reg } ]
    | Lsr -> [ Asm.Lsr { dst; lhs = lhs_reg; rhs = rhs_reg } ]
    | Asr -> [ Asm.Asr { dst; lhs = lhs_reg; rhs = rhs_reg } ]
  in
  lhs_setup @ rhs_setup @ body
;;

let lower_float_binary ~op ~dst ~lhs ~rhs =
  let lhs_setup, lhs_reg, used = ensure_fpr lhs ~dst ~avoid:[] in
  let rhs_setup, rhs_reg, _used = ensure_fpr rhs ~dst ~avoid:used in
  let body =
    match op with
    | Float_op.Fadd -> [ Asm.Fadd { dst; lhs = lhs_reg; rhs = rhs_reg } ]
    | Fsub -> [ Asm.Fsub { dst; lhs = lhs_reg; rhs = rhs_reg } ]
    | Fmul -> [ Asm.Fmul { dst; lhs = lhs_reg; rhs = rhs_reg } ]
    | Fdiv -> [ Asm.Fdiv { dst; lhs = lhs_reg; rhs = rhs_reg } ]
  in
  lhs_setup @ rhs_setup @ body
;;

type lower_action =
  | No_emit
  | Emit_label of string
  | Branch of
      Condition.t
      * (unit, Block.t) Call_block.t
      * (unit, Block.t) Call_block.t option
  | Emit of Asm.instr list

let lower_to_items ~system (functions : Function.t String.Map.t) =
  let functions_alist = Map.to_alist functions in
  match functions_alist with
  | [] -> []
  | _ ->
    let global_prefix =
      match system with
      | `Darwin -> "_"
      | `Linux | `Other -> ""
    in
    let asm_label name = global_prefix ^ sanitize_identifier name in
    let symbol_of_fn name =
      let asm_label = asm_label name in
      { Asm.name; asm_label }
    in
    let used_labels = String.Hash_set.create () in
    List.map functions_alist ~f:(fun (name, fn) ->
      let sanitized_name = sanitize_identifier name in
      let fn_label_base = global_prefix ^ sanitized_name in
      let ensure_unique label =
        let rec loop attempt =
          let candidate =
            if attempt = 0 then label else sprintf "%s_%d" label attempt
          in
          if Hash_set.mem used_labels candidate
          then loop (attempt + 1)
          else (
            Hash_set.add used_labels candidate;
            candidate)
        in
        loop 0
      in
      let fn_label = ensure_unique fn_label_base in
      let ~idx_by_block, ~blocks = order_blocks fn.root in
      let label_by_block = Block.Table.create () in
      Nod_vec.iteri blocks ~f:(fun idx block ->
        let base_label =
          if idx = 0
          then fn_label
          else
            sanitize_identifier
              (sprintf "%s__%s" sanitized_name (Block.id_hum block))
        in
        let base_label =
          if idx = 0 then base_label else ensure_unique base_label
        in
        Hashtbl.add_exn label_by_block ~key:block ~data:base_label);
      let items_rev = ref [] in
      let emit_instruction instr = items_rev := Asm.Instr instr :: !items_rev in
      let emit_label label = items_rev := Asm.Label label :: !items_rev in
      let label_of_block block = Hashtbl.find_exn label_by_block block in
      let label_of_call_block call_block =
        label_of_block call_block.Call_block.block
      in
      let lower_instruction ~current_idx instr =
        let instr = Arm64_ir.map_var_operands instr ~f:(fun _ -> ()) in
        let instr = unwrap_tags instr in
        let instr =
          match instr with
          | Adr { dst; target = Jump_target.Label name } ->
            Adr { dst; target = Jump_target.Label (asm_label name) }
          | _ -> instr
        in
        match instr with
        | Nop | Save_clobbers | Restore_clobbers | Alloca _ -> No_emit
        | Move { dst; src = (Reg _ | Imm _) as src } ->
          Emit [ Asm.Mov { dst; src } ]
        | Move { dst; src = (Spill_slot _ | Mem _) as addr }
        | Load { dst; addr } -> Emit [ Asm.Ldr { dst; addr } ]
        | Dmb -> Emit [ Asm.Dmb ]
        | Ldar { dst; addr } -> Emit [ Asm.Ldar { dst; addr } ]
        | Ldaxr { dst; addr } -> Emit [ Asm.Ldaxr { dst; addr } ]
        | Store { src; addr } ->
          (match src with
           | Reg reg -> Emit [ Asm.Str { src = Reg reg; addr } ]
           | _ ->
             let setup, src_reg, _ = ensure_gpr src ~dst:Reg.sp ~avoid:[] in
             Emit (setup @ [ Asm.Str { src = Reg src_reg; addr } ]))
        | Stlr { src; addr } ->
          (match src with
           | Reg reg -> Emit [ Asm.Stlr { src = Reg reg; addr } ]
           | _ ->
             let setup, src_reg, _ = ensure_gpr src ~dst:Reg.sp ~avoid:[] in
             Emit (setup @ [ Asm.Stlr { src = Reg src_reg; addr } ]))
        | Stlxr { status; src; addr } ->
          (match src with
           | Reg reg -> Emit [ Asm.Stlxr { status; src = Reg reg; addr } ]
           | _ ->
             let setup, src_reg, _ = ensure_gpr src ~dst:status ~avoid:[] in
             Emit (setup @ [ Asm.Stlxr { status; src = Reg src_reg; addr } ]))
        | Casal { dst; expected; desired; addr } ->
          let expected_setup, expected_reg, used =
            ensure_gpr expected ~dst ~avoid:[]
          in
          let desired_setup, desired_reg, _ =
            ensure_gpr desired ~dst ~avoid:(expected_reg :: used)
          in
          let move_dst =
            if Reg.equal Poly.equal expected_reg dst
            then []
            else [ Asm.Mov { dst; src = Reg expected_reg } ]
          in
          Emit
            (expected_setup
             @ desired_setup
             @ [ Asm.Casal
                   { expected = expected_reg; desired = desired_reg; addr }
               ]
             @ move_dst)
        | Int_binary { op; dst; lhs; rhs } ->
          Emit (lower_int_binary ~op ~dst ~lhs ~rhs)
        | Float_binary { op; dst; lhs; rhs } ->
          Emit (lower_float_binary ~op ~dst ~lhs ~rhs)
        | Convert { op; dst; src } ->
          (match op with
           | Convert_op.Int_to_float ->
             let setup, src_reg, _ = ensure_gpr src ~dst ~avoid:[] in
             Emit (setup @ [ Asm.Scvtf { dst; src = src_reg } ])
           | Float_to_int ->
             let setup, src_reg, _ = ensure_fpr src ~dst ~avoid:[] in
             Emit (setup @ [ Asm.Fcvtzs { dst; src = src_reg } ]))
        | Bitcast { dst; src } -> Emit [ Asm.Mov { dst; src } ]
        | Adr { dst; target } -> Emit [ Asm.Adr { dst; target } ]
        | Comp { kind; lhs; rhs } ->
          (match kind with
           | Comp_kind.Int ->
             (match lhs with
              | Reg _ -> Emit [ Asm.Cmp { lhs; rhs } ]
              | _ ->
                let scratch = pick_scratch gpr_scratch_pool [] in
                Emit
                  [ Asm.Mov { dst = scratch; src = lhs }
                  ; Asm.Cmp { lhs = Reg scratch; rhs }
                  ])
           | Float ->
             (match lhs with
              | Reg _ -> Emit [ Asm.Fcmp { lhs; rhs } ]
              | _ ->
                let scratch = pick_scratch fpr_scratch_pool [] in
                Emit
                  [ Asm.Fmov { dst = scratch; src = lhs }
                  ; Asm.Fcmp { lhs = Reg scratch; rhs }
                  ]))
        | Cset { condition; dst } -> Emit [ Asm.Cset { condition; dst } ]
        | Conditional_branch { condition; then_; else_ } ->
          Branch (condition, then_, else_)
        | Jump cb ->
          if is_next_block ~idx_by_block ~current_idx cb.Call_block.block
          then No_emit
          else Emit [ Asm.B (label_of_call_block cb) ]
        | Call { fn = callee; _ } ->
          let symbol = symbol_of_fn callee in
          Emit [ Asm.Bl symbol ]
        | Ret _ -> Emit [ Asm.Ret ]
        | Label s ->
          let label = ensure_unique (sanitize_identifier s) in
          Emit_label label
        | Tag_use _ | Tag_def _ -> assert false
      in
      let handle_branch ~current_idx condition cb else_opt =
        let target_is_next =
          is_next_block ~idx_by_block ~current_idx cb.Call_block.block
        in
        let else_is_next =
          match else_opt with
          | None -> false
          | Some else_cb ->
            is_next_block ~idx_by_block ~current_idx else_cb.Call_block.block
        in
        match target_is_next, else_is_next, else_opt with
        | true, _, Some else_cb ->
          let cond = invert_condition condition in
          emit_instruction
            (Asm.Bcond
               { condition = cond; target = label_of_call_block else_cb })
        | true, _, None -> ()
        | false, true, _ ->
          emit_instruction
            (Asm.Bcond { condition; target = label_of_call_block cb })
        | false, false, Some else_cb ->
          emit_instruction
            (Asm.Bcond { condition; target = label_of_call_block cb });
          emit_instruction (Asm.B (label_of_call_block else_cb))
        | false, false, None ->
          emit_instruction
            (Asm.Bcond { condition; target = label_of_call_block cb })
      in
      let process_instruction ~current_idx instr =
        match lower_instruction ~current_idx instr with
        | No_emit -> ()
        | Emit_label label -> emit_label label
        | Branch (cond, cb, else_opt) ->
          handle_branch ~current_idx cond cb else_opt
        | Emit lines -> List.iter lines ~f:emit_instruction
      in
      Nod_vec.iteri blocks ~f:(fun idx block ->
        let label = label_of_block block in
        emit_label label;
        let instructions = Instr_state.to_ir_list (Block.instructions block) in
        List.iter instructions ~f:(fun ir ->
          match ir with
          | Nod_ir.Ir.Arm64 x -> process_instruction ~current_idx:idx x
          | Nod_ir.Ir.Arm64_terminal xs ->
            List.iter xs ~f:(process_instruction ~current_idx:idx)
          | _ -> ());
        match (Block.terminal block).Instr_state.ir with
        | Nod_ir.Ir.Arm64_terminal xs ->
          List.iter xs ~f:(process_instruction ~current_idx:idx)
        | Nod_ir.Ir.Arm64 x -> process_instruction ~current_idx:idx x
        | _ -> ());
      { Asm.name; asm_label = fn_label; items = List.rev !items_rev })
;;

let run ~system ?(globals = []) functions =
  lower_to_items ~system functions
  |> Asm_peepholes.optimize_program
  |> Emit_asm.run ~system ~globals
;;
