open! Core
open! Import
open! Common
module Reg = X86_reg
module Raw = X86_reg.Raw

let run (functions : Function.t String.Map.t) =
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
  in
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
  in
  let string_of_reg reg = string_of_raw (Reg.raw reg) in
  let string_of_mem reg disp =
    let base = string_of_reg reg in
    match disp with
    | 0 -> sprintf "[%s]" base
    | d when d > 0 -> sprintf "[%s + %d]" base d
    | d -> sprintf "[%s - %d]" base (-d)
  in
  let string_of_operand = function
    | Reg reg -> string_of_reg reg
    | Imm imm -> Int64.to_string imm
    | Mem (reg, disp) -> string_of_mem reg disp
  in
  let is_valid_move_dest = function
    | Reg _ | Mem _ -> true
    | Imm _ -> false
  in
  let rec unwrap_tags = function
    | Tag_use (ins, _) | Tag_def (ins, _) -> unwrap_tags ins
    | ins -> ins
  in
  let add_line buf line =
    Buffer.add_string buf line;
    Buffer.add_char buf '\n'
  in
  let functions_alist = Map.to_alist functions in
  match functions_alist with
  | [] -> ""
  | _ ->
    let buffer = Buffer.create 1024 in
    add_line buffer ".intel_syntax noprefix";
    add_line buffer ".text";
    let used_labels = String.Hash_set.create () in
    List.iteri functions_alist ~f:(fun fn_index (name, fn) ->
      if fn_index > 0 then Buffer.add_char buffer '\n';
      let fn_label_base = sanitize_identifier name in
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
      let blocks =
        let acc = ref [] in
        Block.iter fn.Function.root ~f:(fun block -> acc := block :: !acc);
        List.rev !acc
      in
      let label_by_block = Block.Table.create () in
      List.iteri blocks ~f:(fun idx block ->
        let base_label =
          if idx = 0
          then fn_label
          else sanitize_identifier (sprintf "%s__%s" name block.Block.id_hum)
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
      let lower_instruction instr =
        let instr = unwrap_tags instr in
        match instr with
        | NOOP | Save_clobbers | Restore_clobbers -> `No_emit
        | MOV (dst, src) ->
          `Emit
            (if (not (is_valid_move_dest dst)) || [%equal: operand] dst src
             then []
             else
               [ sprintf
                   "mov %s, %s"
                   (string_of_operand dst)
                   (string_of_operand src)
               ])
        | MOVSD (dst, src) ->
          `Emit
            [ sprintf
                "movsd %s, %s"
                (string_of_operand dst)
                (string_of_operand src)
            ]
        | MOVQ (dst, src) ->
          `Emit
            [ sprintf
                "movq %s, %s"
                (string_of_operand dst)
                (string_of_operand src)
            ]
        | ADD (dst, src) ->
          `Emit
            [ sprintf
                "add %s, %s"
                (string_of_operand dst)
                (string_of_operand src)
            ]
        | SUB (dst, src) ->
          `Emit
            [ sprintf
                "sub %s, %s"
                (string_of_operand dst)
                (string_of_operand src)
            ]
        | ADDSD (dst, src) ->
          `Emit
            [ sprintf
                "addsd %s, %s"
                (string_of_operand dst)
                (string_of_operand src)
            ]
        | SUBSD (dst, src) ->
          `Emit
            [ sprintf
                "subsd %s, %s"
                (string_of_operand dst)
                (string_of_operand src)
            ]
        | MULSD (dst, src) ->
          `Emit
            [ sprintf
                "mulsd %s, %s"
                (string_of_operand dst)
                (string_of_operand src)
            ]
        | DIVSD (dst, src) ->
          `Emit
            [ sprintf
                "divsd %s, %s"
                (string_of_operand dst)
                (string_of_operand src)
            ]
        | AND (dst, src) ->
          `Emit
            [ sprintf
                "and %s, %s"
                (string_of_operand dst)
                (string_of_operand src)
            ]
        | OR (dst, src) ->
          `Emit
            [ sprintf
                "or %s, %s"
                (string_of_operand dst)
                (string_of_operand src)
            ]
        | IMUL op -> `Emit [ sprintf "imul %s" (string_of_operand op) ]
        | IDIV op | MOD op -> `Emit [ sprintf "idiv %s" (string_of_operand op) ]
        | CMP (Imm a, Imm b) -> `Set_pending (Some (a, b))
        | CMP (a, b) ->
          `Emit
            [ sprintf "cmp %s, %s" (string_of_operand a) (string_of_operand b) ]
        | CALL { fn = callee; _ } ->
          let callee = sanitize_identifier callee in
          `Emit [ sprintf "call %s" callee ]
        | PUSH op -> `Emit [ sprintf "push %s" (string_of_operand op) ]
        | POP reg -> `Emit [ sprintf "pop %s" (string_of_reg reg) ]
        | JMP cb -> `Emit [ sprintf "jmp %s" (label_of_call_block cb) ]
        | JE (cb, else_) -> `Branch (`Je, cb, else_)
        | JNE (cb, else_) -> `Branch (`Jne, cb, else_)
        | RET _ -> `Emit [ "ret" ]
        | ALLOCA _ -> `Emit []
        | LABEL s ->
          let label = ensure_unique (sanitize_identifier s) in
          `Emit_label label
        | Tag_use _ | Tag_def _ -> assert false
      in
      let pending_const_cmp = ref None in
      let handle_branch branch_kind cb else_opt =
        let emit_branch kind target =
          match kind with
          | `Je -> emit_instruction (sprintf "je %s" target)
          | `Jne -> emit_instruction (sprintf "jne %s" target)
        in
        match !pending_const_cmp with
        | Some (lhs, rhs) ->
          pending_const_cmp := None;
          let take_branch =
            match branch_kind with
            | `Je -> Int64.equal lhs rhs
            | `Jne -> not (Int64.equal lhs rhs)
          in
          if take_branch
          then emit_instruction (sprintf "jmp %s" (label_of_call_block cb))
          else (
            match else_opt with
            | None -> ()
            | Some else_cb ->
              emit_instruction (sprintf "jmp %s" (label_of_call_block else_cb)))
        | None ->
          emit_branch branch_kind (label_of_call_block cb);
          Option.iter else_opt ~f:(fun else_cb ->
            emit_instruction (sprintf "jmp %s" (label_of_call_block else_cb)))
      in
      let process_instruction instr =
        match lower_instruction instr with
        | `No_emit -> ()
        | `Set_pending value -> pending_const_cmp := value
        | `Emit_label label ->
          pending_const_cmp := None;
          emit_label label
        | `Branch (kind, cb, else_opt) -> handle_branch kind cb else_opt
        | `Emit lines ->
          pending_const_cmp := None;
          List.iter lines ~f:emit_instruction
      in
      List.iter blocks ~f:(fun block ->
        let label = label_of_block block in
        add_line buffer (label ^ ":");
        pending_const_cmp := None;
        let instructions = Vec.to_list block.Block.instructions in
        List.iter instructions ~f:(fun ir ->
          match ir with
          | Ir0.X86 x -> process_instruction x
          | Ir0.X86_terminal xs -> List.iter xs ~f:process_instruction
          | _ -> ());
        match block.Block.terminal with
        | Ir0.X86_terminal xs -> List.iter xs ~f:process_instruction
        | Ir0.X86 x -> process_instruction x
        | _ -> ()));
    Buffer.contents buffer
;;
