open! Core
open! Import
open! Common
module Reg = X86_reg
module Raw = X86_reg.Raw

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

let rec string_of_raw = function
  | Raw.RAX -> "rax"
  | Raw.RBX -> "rbx"
  | Raw.RCX -> "rcx"
  | Raw.RDX -> "rdx"
  | Raw.RSI -> "rsi"
  | Raw.RDI -> "rdi"
  | Raw.RSP -> "rsp"
  | Raw.RBP -> "rbp"
  | Raw.R8 -> "r8"
  | Raw.R9 -> "r9"
  | Raw.R10 -> "r10"
  | Raw.R11 -> "r11"
  | Raw.R12 -> "r12"
  | Raw.R13 -> "r13"
  | Raw.R14 -> "r14"
  | Raw.R15 -> "r15"
  | Raw.XMM0 -> "xmm0"
  | Raw.XMM1 -> "xmm1"
  | Raw.XMM2 -> "xmm2"
  | Raw.XMM3 -> "xmm3"
  | Raw.XMM4 -> "xmm4"
  | Raw.XMM5 -> "xmm5"
  | Raw.XMM6 -> "xmm6"
  | Raw.XMM7 -> "xmm7"
  | Raw.XMM8 -> "xmm8"
  | Raw.XMM9 -> "xmm9"
  | Raw.XMM10 -> "xmm10"
  | Raw.XMM11 -> "xmm11"
  | Raw.XMM12 -> "xmm12"
  | Raw.XMM13 -> "xmm13"
  | Raw.XMM14 -> "xmm14"
  | Raw.XMM15 -> "xmm15"
  | Raw.Unallocated v | Raw.Allocated (v, None) ->
    sanitize_identifier (Var.name v)
  | Raw.Allocated (_, Some reg) -> string_of_raw reg
;;

let string_of_reg reg = string_of_raw (Reg.raw reg)

let string_of_mem reg disp =
  let base = string_of_reg reg in
  match disp with
  | 0 -> sprintf "[%s]" base
  | d when d > 0 -> sprintf "[%s + %d]" base d
  | d -> sprintf "[%s - %d]" base (-d)
;;

let string_of_operand = function
  | Spill_slot _ -> failwith "unexpected spill slot"
  | Reg reg -> string_of_reg reg
  | Imm imm -> Int64.to_string imm
  | Mem (reg, disp) -> string_of_mem reg disp
;;

let string_of_operand_with_size ~size_for_mem operand =
  match operand with
  | Mem (reg, disp) -> sprintf "%s %s" size_for_mem (string_of_mem reg disp)
  | _ -> string_of_operand operand
;;

let is_valid_move_dest = function
  | Spill_slot _ -> failwith "unexpected spill slot"
  | Reg _ | Mem _ -> true
  | Imm _ -> false
;;

let rec unwrap_tags = function
  | Tag_use (ins, _) | Tag_def (ins, _) -> unwrap_tags ins
  | ins -> ins
;;

let add_line buf line =
  Buffer.add_string buf line;
  Buffer.add_char buf '\n'
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
         Vec.iter block.children ~f:(fun child ->
           if Vec.length child.parents = 1
              && not (Hashtbl.mem idx_by_block child)
           then try_push child);
         Vec.iter block.children ~f:(Queue.enqueue q);
         go ())
  in
  go ();
  ~idx_by_block, ~blocks
;;

let emit_binary_instr op dst src =
  match dst, src with
  | Mem _, Imm _ ->
    sprintf
      "%s %s, %s"
      op
      (string_of_operand_with_size ~size_for_mem:"qword ptr" dst)
      (string_of_operand src)
  | _ -> sprintf "%s %s, %s" op (string_of_operand dst) (string_of_operand src)
;;

let lower_mem_mem_binop ~op ~dst ~src =
  let scratch = Reg Reg.r11 in
  [ sprintf "push %s" (string_of_reg Reg.r11)
  ; emit_binary_instr "mov" scratch dst
  ; emit_binary_instr op scratch src
  ; emit_binary_instr "mov" dst scratch
  ; sprintf "pop %s" (string_of_reg Reg.r11)
  ]
;;

let lower_mem_mem_cmp ~lhs ~rhs =
  let scratch = Reg Reg.r11 in
  [ sprintf "push %s" (string_of_reg Reg.r11)
  ; emit_binary_instr "mov" scratch lhs
  ; emit_binary_instr "cmp" scratch rhs
  ; sprintf "pop %s" (string_of_reg Reg.r11)
  ]
;;

let lower_mem_mem_mov ~dst ~src =
  let scratch = Reg Reg.r11 in
  [ sprintf "push %s" (string_of_reg Reg.r11)
  ; emit_binary_instr "mov" scratch src
  ; emit_binary_instr "mov" dst scratch
  ; sprintf "pop %s" (string_of_reg Reg.r11)
  ]
;;

let is_next_block ~idx_by_block ~current_idx target_block =
  match Hashtbl.find idx_by_block target_block with
  | None -> false
  | Some target_idx -> target_idx = current_idx + 1
;;

let emit_conditional_jump kind target =
  match kind with
  | `Je -> sprintf "je %s" target
  | `Jne -> sprintf "jne %s" target
;;

let invert_branch_kind = function
  | `Je -> `Jne
  | `Jne -> `Je
;;

let run ~system (functions : Function.t String.Map.t) =
  let functions_alist = Map.to_alist functions in
  match functions_alist with
  | [] -> ""
  | _ ->
    let global_prefix =
      match system with
      | `Darwin -> "_"
      | `Linux | `Other -> ""
    in
    let buffer = Buffer.create 1024 in
    add_line buffer ".intel_syntax noprefix";
    add_line buffer ".text";
    let used_labels = String.Hash_set.create () in
    List.iteri functions_alist ~f:(fun fn_index (name, fn) ->
      let alloca_offset =
        ref
          (fn.bytes_for_clobber_saves
           + fn.bytes_for_padding
           + fn.bytes_for_spills)
      in
      if fn_index > 0 then Buffer.add_char buffer '\n';
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
      add_line buffer (sprintf ".globl %s" fn_label);
      let ~idx_by_block, ~blocks = order_blocks fn.root in
      let label_by_block = Block.Table.create () in
      Vec.iteri blocks ~f:(fun idx block ->
        let base_label =
          if idx = 0
          then fn_label
          else
            sanitize_identifier
              (sprintf "%s__%s" sanitized_name block.Block.id_hum)
        in
        let base_label =
          if idx = 0 then base_label else ensure_unique base_label
        in
        Hashtbl.add_exn label_by_block ~key:block ~data:base_label);
      let emit_instruction line = add_line buffer ("  " ^ line) in
      let emit_label label = add_line buffer (label ^ ":") in
      let label_of_block block = Hashtbl.find_exn label_by_block block in
      let label_of_call_block call_block =
        label_of_block call_block.Call_block.block
      in
      let lower_move' ~dst ~src s =
        if (not (is_valid_move_dest dst)) || [%equal: operand] dst src
        then []
        else (
          match dst, src with
          | Mem _, Mem _ -> lower_mem_mem_mov ~dst ~src
          | _ -> [ emit_binary_instr s dst src ])
      in
      let lower_move ~dst ~src s = `Emit (lower_move' ~dst ~src s) in
      let lower_sub' ~dst ~src =
        match dst, src with
        | Mem _, Mem _ -> lower_mem_mem_binop ~op:"sub" ~dst ~src
        | _ -> [ emit_binary_instr "sub" dst src ]
      in
      let lower_instruction ~current_idx instr =
        let instr = unwrap_tags instr in
        match instr with
        | NOOP | Save_clobbers | Restore_clobbers -> `No_emit
        | MOV (dst, src) -> lower_move ~dst ~src "mov"
        | MOVSD (dst, src) -> lower_move ~dst ~src "movsd"
        | MOVQ (dst, src) -> lower_move ~dst ~src "movq"
        | CVTSI2SD (dst, src) -> lower_move ~dst ~src "cvtsi2sd"
        | CVTTSD2SI (dst, src) -> lower_move ~dst ~src "cvttsd2si"
        | ADD (dst, src) ->
          `Emit
            (match dst, src with
             | Mem _, Mem _ -> lower_mem_mem_binop ~op:"add" ~dst ~src
             | _ -> [ emit_binary_instr "add" dst src ])
        | SUB (dst, src) -> `Emit (lower_sub' ~dst ~src)
        | ADDSD (dst, src) -> `Emit [ emit_binary_instr "addsd" dst src ]
        | SUBSD (dst, src) -> `Emit [ emit_binary_instr "subsd" dst src ]
        | MULSD (dst, src) -> `Emit [ emit_binary_instr "mulsd" dst src ]
        | DIVSD (dst, src) -> `Emit [ emit_binary_instr "divsd" dst src ]
        | AND (dst, src) ->
          `Emit
            (match dst, src with
             | Mem _, Mem _ -> lower_mem_mem_binop ~op:"and" ~dst ~src
             | _ -> [ emit_binary_instr "and" dst src ])
        | OR (dst, src) ->
          `Emit
            (match dst, src with
             | Mem _, Mem _ -> lower_mem_mem_binop ~op:"or" ~dst ~src
             | _ -> [ emit_binary_instr "or" dst src ])
        | IMUL op -> `Emit [ sprintf "imul %s" (string_of_operand op) ]
        | IDIV op | MOD op -> `Emit [ sprintf "idiv %s" (string_of_operand op) ]
        | CMP (Imm a, Imm b) -> `Set_pending (Some (a, b))
        | CMP (a, b) ->
          `Emit
            (match a, b with
             | Mem _, Mem _ -> lower_mem_mem_cmp ~lhs:a ~rhs:b
             | _ -> [ emit_binary_instr "cmp" a b ])
        | CALL { fn = callee; _ } ->
          let callee = global_prefix ^ sanitize_identifier callee in
          `Emit [ sprintf "call %s" callee ]
        | PUSH op -> `Emit [ sprintf "push %s" (string_of_operand op) ]
        | POP reg -> `Emit [ sprintf "pop %s" (string_of_reg reg) ]
        | JMP cb ->
          (* Optimize: omit jump to immediately following block *)
          if is_next_block ~idx_by_block ~current_idx cb.Call_block.block
          then `Emit []
          else `Emit [ sprintf "jmp %s" (label_of_call_block cb) ]
        | JE (cb, else_) -> `Branch (`Je, cb, else_)
        | JNE (cb, else_) -> `Branch (`Jne, cb, else_)
        | RET _ -> `Emit [ "ret" ]
        | ALLOCA (operand, i) ->
          alloca_offset := !alloca_offset + Int64.to_int_exn i;
          `Emit
            (lower_move' ~dst:operand ~src:(Reg Reg.rbp) "mov"
             @ lower_sub' ~dst:operand ~src:(Imm (Int64.of_int !alloca_offset))
            )
        | LABEL s ->
          let label = ensure_unique (sanitize_identifier s) in
          `Emit_label label
        | Tag_use _ | Tag_def _ -> assert false
      in
      let pending_const_cmp = ref None in
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
            if (* Jump to target if not next block *)
               not
                 (is_next_block ~idx_by_block ~current_idx cb.Call_block.block)
            then emit_instruction (sprintf "jmp %s" (label_of_call_block cb)))
          else (
            match else_opt with
            | None -> ()
            | Some else_cb ->
              (* Jump to else if not next block *)
              if not
                   (is_next_block
                      ~idx_by_block
                      ~current_idx
                      else_cb.Call_block.block)
              then
                emit_instruction
                  (sprintf "jmp %s" (label_of_call_block else_cb)))
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
             (* Target is next: invert condition and jump to else *)
             let inverted_kind = invert_branch_kind branch_kind in
             emit_instruction
               (emit_conditional_jump
                  inverted_kind
                  (label_of_call_block else_cb))
           | true, _, None ->
             (* Target is next and no else: no jump needed *)
             ()
           | false, true, _ ->
             (* Else is next: just emit conditional jump to target *)
             emit_instruction
               (emit_conditional_jump branch_kind (label_of_call_block cb))
           | false, false, Some else_cb ->
             (* Neither is next: emit both jumps, but prefer making else the fall-through *)
             (* This is a heuristic - we could switch the condition to optimize better *)
             emit_instruction
               (emit_conditional_jump branch_kind (label_of_call_block cb));
             emit_instruction (sprintf "jmp %s" (label_of_call_block else_cb))
           | false, false, None ->
             (* Only target, not next: emit conditional jump *)
             emit_instruction
               (emit_conditional_jump branch_kind (label_of_call_block cb)))
      in
      let process_instruction ~current_idx instr =
        match lower_instruction ~current_idx instr with
        | `No_emit -> ()
        | `Set_pending value -> pending_const_cmp := value
        | `Emit_label label ->
          pending_const_cmp := None;
          emit_label label
        | `Branch (kind, cb, else_opt) ->
          handle_branch ~current_idx kind cb else_opt
        | `Emit lines ->
          pending_const_cmp := None;
          List.iter lines ~f:emit_instruction
      in
      Vec.iteri blocks ~f:(fun idx block ->
        let label = label_of_block block in
        add_line buffer (label ^ ":");
        pending_const_cmp := None;
        let instructions = Vec.to_list block.Block.instructions in
        List.iter instructions ~f:(fun ir ->
          match ir with
          | Ir0.X86 x -> process_instruction ~current_idx:idx x
          | Ir0.X86_terminal xs ->
            List.iter xs ~f:(process_instruction ~current_idx:idx)
          | _ -> ());
        match block.Block.terminal with
        | Ir0.X86_terminal xs ->
          List.iter xs ~f:(process_instruction ~current_idx:idx)
        | Ir0.X86 x -> process_instruction ~current_idx:idx x
        | _ -> ()));
    (match system with
     | `Linux ->
       Buffer.add_string buffer {|.section .note.GNU-stack,"",@progbits|};
       Buffer.add_string buffer "\n"
     | `Darwin | `Other -> ());
    Buffer.contents buffer
;;
