open! Core
open! Import
open! Common
module Reg = X86_reg
module Asm = X86_asm

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

let is_valid_move_dest = function
  | Spill_slot _ -> failwith "unexpected spill slot"
  | Reg _ | Mem _ -> true
  | Imm _ | Symbol _ -> false
;;

let rec unwrap_tags = function
  | Tag_use (ins, _) | Tag_def (ins, _) -> unwrap_tags ins
  | ins -> ins
;;

let order_blocks root =
  let idx_by_block = Block.Table.create () in
  let blocks = Vec.create () in
  let try_push block =
    let idx = Vec.length blocks in
    match Hashtbl.add idx_by_block ~key:block ~data:idx with
    | `Duplicate -> ()
    | `Ok -> Vec.push blocks block
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
         Vec.iter (Block.children block) ~f:(fun child ->
           if Vec.length (Block.parents child) = 1
              && not (Hashtbl.mem idx_by_block child)
           then try_push child);
         Vec.iter (Block.children block) ~f:(Queue.enqueue q);
         go ())
  in
  go ();
  ~idx_by_block, ~blocks
;;

let lower_mem_mem_binop ~op ~dst ~src =
  let scratch = Reg Reg.r11 in
  [ Asm.Push (Reg Reg.r11)
  ; Asm.Mov (scratch, dst)
  ; op scratch src
  ; Asm.Mov (dst, scratch)
  ; Asm.Pop Reg.r11
  ]
;;

let lower_mem_mem_cmp ~lhs ~rhs =
  let scratch = Reg Reg.r11 in
  [ Asm.Push (Reg Reg.r11)
  ; Asm.Mov (scratch, lhs)
  ; Asm.Cmp (scratch, rhs)
  ; Asm.Pop Reg.r11
  ]
;;

let lower_mem_mem_mov ~dst ~src =
  let scratch = Reg Reg.r11 in
  [ Asm.Push (Reg Reg.r11)
  ; Asm.Mov (scratch, src)
  ; Asm.Mov (dst, scratch)
  ; Asm.Pop Reg.r11
  ]
;;

let is_next_block ~idx_by_block ~current_idx target_block =
  match Hashtbl.find idx_by_block target_block with
  | None -> false
  | Some target_idx -> target_idx = current_idx + 1
;;

let invert_branch_kind = function
  | `Je -> `Jne
  | `Jne -> `Je
;;

type lower_action =
  | No_emit
  | Set_pending of (Int64.t * Int64.t) option
  | Emit_label of string
  | Branch of
      [ `Je | `Jne ]
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
    let map_operand = function
      | Symbol name -> Symbol (asm_label name)
      | other -> other
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
      Vec.iteri blocks ~f:(fun idx block ->
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
      let lower_move' ~dst ~src make_instr =
        if (not (is_valid_move_dest dst))
           || [%equal: unit X86_ir.operand] dst src
        then []
        else (
          match dst, src with
          | Mem _, Mem _ -> lower_mem_mem_mov ~dst ~src
          | _ -> [ make_instr dst src ])
      in
      let lower_move ~dst ~src make_instr =
        Emit (lower_move' ~dst ~src make_instr)
      in
      let lower_sub' ~dst ~src =
        match dst, src with
        | Mem _, Mem _ ->
          lower_mem_mem_binop ~op:(fun a b -> Asm.Sub (a, b)) ~dst ~src
        | _ -> [ Asm.Sub (dst, src) ]
      in
      let lower_instruction ~current_idx instr =
        let instr = X86_ir.map_var_operands instr ~f:(fun _ -> ()) in
        let instr = X86_ir.map_operands instr ~f:map_operand in
        let instr = unwrap_tags instr in
        match instr with
        | NOOP | Save_clobbers | Restore_clobbers -> No_emit
        | MOV (dst, src) -> lower_move ~dst ~src (fun a b -> Asm.Mov (a, b))
        | MOVSD (dst, src) -> lower_move ~dst ~src (fun a b -> Asm.Movsd (a, b))
        | MOVQ (dst, src) -> lower_move ~dst ~src (fun a b -> Asm.Movq (a, b))
        | CVTSI2SD (dst, src) ->
          lower_move ~dst ~src (fun a b -> Asm.Cvtsi2sd (a, b))
        | CVTTSD2SI (dst, src) ->
          lower_move ~dst ~src (fun a b -> Asm.Cvttsd2si (a, b))
        | ADD (dst, src) ->
          Emit
            (match dst, src with
             | Mem _, Mem _ ->
               lower_mem_mem_binop ~op:(fun a b -> Asm.Add (a, b)) ~dst ~src
             | _ -> [ Asm.Add (dst, src) ])
        | SUB (dst, src) -> Emit (lower_sub' ~dst ~src)
        | ADDSD (dst, src) -> Emit [ Asm.Addsd (dst, src) ]
        | SUBSD (dst, src) -> Emit [ Asm.Subsd (dst, src) ]
        | MULSD (dst, src) -> Emit [ Asm.Mulsd (dst, src) ]
        | DIVSD (dst, src) -> Emit [ Asm.Divsd (dst, src) ]
        | AND (dst, src) ->
          Emit
            (match dst, src with
             | Mem _, Mem _ ->
               lower_mem_mem_binop ~op:(fun a b -> Asm.And (a, b)) ~dst ~src
             | _ -> [ Asm.And (dst, src) ])
        | OR (dst, src) ->
          Emit
            (match dst, src with
             | Mem _, Mem _ ->
               lower_mem_mem_binop ~op:(fun a b -> Asm.Or (a, b)) ~dst ~src
             | _ -> [ Asm.Or (dst, src) ])
        | IMUL op -> Emit [ Asm.Imul op ]
        | IDIV op ->
          Emit
            [ Asm.Cqo
              (* we actually are dividing one reg, so we must sign extend it into the other *)
            ; Asm.Idiv op
            ]
        | MOD op -> Emit [ Asm.Mod op ]
        | CMP (Imm a, Imm b) -> Set_pending (Some (a, b))
        | CMP (a, b) ->
          Emit
            (match a, b with
             | Mem _, Mem _ -> lower_mem_mem_cmp ~lhs:a ~rhs:b
             | _ -> [ Asm.Cmp (a, b) ])
        | SETE dst ->
          (match dst with
           | Reg _ | Mem _ -> Emit [ Asm.Sete dst ]
           | Imm _ | Spill_slot _ | Symbol _ ->
             failwith "sete expects register or memory operand")
        | SETL dst ->
          (match dst with
           | Reg _ | Mem _ -> Emit [ Asm.Setl dst ]
           | Imm _ | Spill_slot _ | Symbol _ ->
             failwith "setl expects register or memory operand")
        | CALL { fn = callee; _ } ->
          let symbol = symbol_of_fn callee in
          Emit [ Asm.Call symbol ]
        | PUSH op -> Emit [ Asm.Push op ]
        | POP reg -> Emit [ Asm.Pop reg ]
        | JMP cb ->
          if is_next_block ~idx_by_block ~current_idx cb.Call_block.block
          then Emit []
          else Emit [ Asm.Jmp (label_of_call_block cb) ]
        | JE (cb, else_) -> Branch (`Je, cb, else_)
        | JNE (cb, else_) -> Branch (`Jne, cb, else_)
        | RET _ -> Emit [ Asm.Ret ]
        | ALLOCA _ ->
          failwith "ALLOCA seen but should've been removed before lowering"
        | LABEL s ->
          let label = ensure_unique (sanitize_identifier s) in
          Emit_label label
        (* Atomic operations *)
        | MFENCE -> Emit [ Asm.Mfence ]
        | XCHG (dst, src) ->
          Emit
            (match dst, src with
             | Mem _, Mem _ ->
               (* XCHG cannot have both operands as memory, use temp register *)
               let scratch = Reg Reg.r11 in
               [ Asm.Push (Reg Reg.r11)
               ; Asm.Mov (scratch, src)
               ; Asm.Xchg (dst, scratch)
               ; Asm.Mov (src, scratch)
               ; Asm.Pop Reg.r11
               ]
             | _ -> [ Asm.Xchg (dst, src) ])
        | LOCK_ADD (dst, src) -> Emit [ Asm.Lock_add (dst, src) ]
        | LOCK_SUB (dst, src) -> Emit [ Asm.Lock_sub (dst, src) ]
        | LOCK_AND (dst, src) -> Emit [ Asm.Lock_and (dst, src) ]
        | LOCK_OR (dst, src) -> Emit [ Asm.Lock_or (dst, src) ]
        | LOCK_XOR (dst, src) -> Emit [ Asm.Lock_xor (dst, src) ]
        | LOCK_CMPXCHG { dest; expected; desired } ->
          Emit [ Asm.Lock_cmpxchg { dest; expected; desired } ]
        | Tag_use _ | Tag_def _ -> assert false
      in
      let pending_const_cmp = ref None in
      let emit_conditional_jump kind target =
        match kind with
        | `Je -> Asm.Je target
        | `Jne -> Asm.Jne target
      in
      let handle_branch ~current_idx branch_kind cb else_opt =
        match !pending_const_cmp with
        | Some (lhs, rhs) ->
          pending_const_cmp := None;
          let take_branch =
            match branch_kind with
            | `Je -> Int64.equal lhs rhs
            | `Jne -> not (Int64.equal lhs rhs)
          in
          if take_branch
          then (
            if not
                 (is_next_block ~idx_by_block ~current_idx cb.Call_block.block)
            then emit_instruction (Asm.Jmp (label_of_call_block cb)))
          else (
            match else_opt with
            | None -> ()
            | Some else_cb ->
              if not
                   (is_next_block
                      ~idx_by_block
                      ~current_idx
                      else_cb.Call_block.block)
              then emit_instruction (Asm.Jmp (label_of_call_block else_cb)))
        | None ->
          let target_is_next =
            is_next_block ~idx_by_block ~current_idx cb.Call_block.block
          in
          let else_is_next =
            match else_opt with
            | None -> false
            | Some else_cb ->
              is_next_block ~idx_by_block ~current_idx else_cb.Call_block.block
          in
          (match target_is_next, else_is_next, else_opt with
           | true, _, Some else_cb ->
             let inverted_kind = invert_branch_kind branch_kind in
             emit_instruction
               (emit_conditional_jump
                  inverted_kind
                  (label_of_call_block else_cb))
           | true, _, None -> ()
           | false, true, _ ->
             emit_instruction
               (emit_conditional_jump branch_kind (label_of_call_block cb))
           | false, false, Some else_cb ->
             emit_instruction
               (emit_conditional_jump branch_kind (label_of_call_block cb));
             emit_instruction (Asm.Jmp (label_of_call_block else_cb))
           | false, false, None ->
             emit_instruction
               (emit_conditional_jump branch_kind (label_of_call_block cb)))
      in
      let process_instruction ~current_idx instr =
        match lower_instruction ~current_idx instr with
        | No_emit -> ()
        | Set_pending value -> pending_const_cmp := value
        | Emit_label label ->
          pending_const_cmp := None;
          emit_label label
        | Branch (kind, cb, else_opt) ->
          handle_branch ~current_idx kind cb else_opt
        | Emit lines ->
          pending_const_cmp := None;
          List.iter lines ~f:emit_instruction
      in
      Vec.iteri blocks ~f:(fun idx block ->
        let label = label_of_block block in
        emit_label label;
        pending_const_cmp := None;
        let instructions = Instr_state.to_ir_list (Block.instructions block) in
        List.iter instructions ~f:(fun ir ->
          match ir with
          | Nod_ir.Ir.X86 x -> process_instruction ~current_idx:idx x
          | Nod_ir.Ir.X86_terminal xs ->
            List.iter xs ~f:(process_instruction ~current_idx:idx)
          | _ -> ());
        match (Block.terminal block).Instr_state.ir with
        | Nod_ir.Ir.X86_terminal xs ->
          List.iter xs ~f:(process_instruction ~current_idx:idx)
        | Nod_ir.Ir.X86 x -> process_instruction ~current_idx:idx x
        | _ -> ());
      { Asm.name; asm_label = fn_label; items = List.rev !items_rev })
;;

let run ~system ?(globals = []) functions =
  lower_to_items ~system functions
  |> Asm_peepholes.optimize_program
  |> Emit_asm.run ~system ~globals
;;
