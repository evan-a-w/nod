open! Core
open! Import
open! Common
open Arm64_ir
module Reg = Arm64_reg
module Raw = Arm64_reg.Raw

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
  | Raw.SP -> "sp"
  | Raw.X0 -> "x0"
  | Raw.X1 -> "x1"
  | Raw.X2 -> "x2"
  | Raw.X3 -> "x3"
  | Raw.X4 -> "x4"
  | Raw.X5 -> "x5"
  | Raw.X6 -> "x6"
  | Raw.X7 -> "x7"
  | Raw.X8 -> "x8"
  | Raw.X9 -> "x9"
  | Raw.X10 -> "x10"
  | Raw.X11 -> "x11"
  | Raw.X12 -> "x12"
  | Raw.X13 -> "x13"
  | Raw.X14 -> "x14"
  | Raw.X15 -> "x15"
  | Raw.X16 -> "x16"
  | Raw.X17 -> "x17"
  | Raw.X18 -> "x18"
  | Raw.X19 -> "x19"
  | Raw.X20 -> "x20"
  | Raw.X21 -> "x21"
  | Raw.X22 -> "x22"
  | Raw.X23 -> "x23"
  | Raw.X24 -> "x24"
  | Raw.X25 -> "x25"
  | Raw.X26 -> "x26"
  | Raw.X27 -> "x27"
  | Raw.X28 -> "x28"
  | Raw.X29 -> "x29"
  | Raw.X30 -> "x30"
  | Raw.D0 -> "d0"
  | Raw.D1 -> "d1"
  | Raw.D2 -> "d2"
  | Raw.D3 -> "d3"
  | Raw.D4 -> "d4"
  | Raw.D5 -> "d5"
  | Raw.D6 -> "d6"
  | Raw.D7 -> "d7"
  | Raw.D8 -> "d8"
  | Raw.D9 -> "d9"
  | Raw.D10 -> "d10"
  | Raw.D11 -> "d11"
  | Raw.D12 -> "d12"
  | Raw.D13 -> "d13"
  | Raw.D14 -> "d14"
  | Raw.D15 -> "d15"
  | Raw.D16 -> "d16"
  | Raw.D17 -> "d17"
  | Raw.D18 -> "d18"
  | Raw.D19 -> "d19"
  | Raw.D20 -> "d20"
  | Raw.D21 -> "d21"
  | Raw.D22 -> "d22"
  | Raw.D23 -> "d23"
  | Raw.D24 -> "d24"
  | Raw.D25 -> "d25"
  | Raw.D26 -> "d26"
  | Raw.D27 -> "d27"
  | Raw.D28 -> "d28"
  | Raw.D29 -> "d29"
  | Raw.D30 -> "d30"
  | Raw.D31 -> "d31"
  | Raw.Unallocated v | Raw.Allocated (v, None) ->
    sanitize_identifier (Var.name v)
  | Raw.Allocated (_, Some reg) -> string_of_raw reg
;;

let string_of_reg reg = string_of_raw (Reg.raw reg)

let string_of_mem reg disp =
  let base = string_of_reg reg in
  match disp with
  | 0 -> sprintf "[%s]" base
  | d when d > 0 -> sprintf "[%s, #%d]" base d
  | d -> sprintf "[%s, #%d]" base d
;;

let string_of_operand = function
  | Reg reg -> string_of_reg reg
  | Imm imm -> sprintf "#%Ld" imm
  | Mem (reg, disp) -> string_of_mem reg disp
;;

let gpr_scratch_pool = Arm64_reg.scratch ~class_:I64
let fpr_scratch_pool = Arm64_reg.scratch ~class_:F64

let rec pick_scratch pool avoid =
  match pool with
  | [] -> failwith "no scratch registers available"
  | reg :: rest ->
    if List.exists avoid ~f:(Reg.equal reg)
    then pick_scratch rest avoid
    else reg
;;

let ensure_gpr operand ~dst ~avoid =
  match operand with
  | Reg reg -> [], string_of_reg reg, avoid
  | Imm imm ->
    let scratch = pick_scratch gpr_scratch_pool (dst :: avoid) in
    ( [ sprintf "mov %s, #%Ld" (string_of_reg scratch) imm ]
    , string_of_reg scratch
    , scratch :: avoid )
  | Mem (reg, disp) ->
    let scratch = pick_scratch gpr_scratch_pool (dst :: avoid) in
    ( [ sprintf "ldr %s, %s" (string_of_reg scratch) (string_of_mem reg disp) ]
    , string_of_reg scratch
    , scratch :: avoid )
;;

let ensure_fpr operand ~dst ~avoid =
  match operand with
  | Reg reg -> [], string_of_reg reg, avoid
  | Mem (reg, disp) ->
    let scratch = pick_scratch fpr_scratch_pool (dst :: avoid) in
    ( [ sprintf "ldr %s, %s" (string_of_reg scratch) (string_of_mem reg disp) ]
    , string_of_reg scratch
    , scratch :: avoid )
  | Imm imm ->
    let fp_scratch = pick_scratch fpr_scratch_pool (dst :: avoid) in
    let gpr_scratch = pick_scratch gpr_scratch_pool [] in
    ( [ sprintf "mov %s, #%Ld" (string_of_reg gpr_scratch) imm
      ; sprintf
          "fmov %s, %s"
          (string_of_reg fp_scratch)
          (string_of_reg gpr_scratch)
      ]
    , string_of_reg fp_scratch
    , fp_scratch :: avoid )
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

let is_next_block ~idx_by_block ~current_idx target_block =
  match Hashtbl.find idx_by_block target_block with
  | None -> false
  | Some target_idx -> target_idx = current_idx + 1
;;

let string_of_condition = function
  | Condition.Eq -> "eq"
  | Ne -> "ne"
  | Lt -> "lt"
  | Le -> "le"
  | Gt -> "gt"
  | Ge -> "ge"
  | Pl -> "pl"
  | Mi -> "mi"
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

let string_of_jump_target = function
  | Jump_target.Reg reg -> string_of_reg reg
  | Imm imm -> sprintf "#%Ld" imm
  | Symbol sym -> sanitize_identifier (Symbol.to_string sym)
;;

let lower_int_binary ~op ~dst ~lhs ~rhs =
  let dst_name = string_of_reg dst in
  let lhs_setup, lhs_reg, used = ensure_gpr lhs ~dst ~avoid:[] in
  let rhs_setup, rhs_reg, used = ensure_gpr rhs ~dst ~avoid:used in
  let body =
    match op with
    | Int_op.Add -> [ sprintf "add %s, %s, %s" dst_name lhs_reg rhs_reg ]
    | Sub -> [ sprintf "sub %s, %s, %s" dst_name lhs_reg rhs_reg ]
    | Mul -> [ sprintf "mul %s, %s, %s" dst_name lhs_reg rhs_reg ]
    | Sdiv -> [ sprintf "sdiv %s, %s, %s" dst_name lhs_reg rhs_reg ]
    | Smod ->
      let scratch = pick_scratch gpr_scratch_pool (dst :: used) in
      [ sprintf "sdiv %s, %s, %s" (string_of_reg scratch) lhs_reg rhs_reg
      ; sprintf
          "msub %s, %s, %s, %s"
          dst_name
          (string_of_reg scratch)
          rhs_reg
          lhs_reg
      ]
    | And -> [ sprintf "and %s, %s, %s" dst_name lhs_reg rhs_reg ]
    | Orr -> [ sprintf "orr %s, %s, %s" dst_name lhs_reg rhs_reg ]
    | Eor -> [ sprintf "eor %s, %s, %s" dst_name lhs_reg rhs_reg ]
    | Lsl -> [ sprintf "lsl %s, %s, %s" dst_name lhs_reg rhs_reg ]
    | Lsr -> [ sprintf "lsr %s, %s, %s" dst_name lhs_reg rhs_reg ]
    | Asr -> [ sprintf "asr %s, %s, %s" dst_name lhs_reg rhs_reg ]
  in
  lhs_setup @ rhs_setup @ body
;;

let lower_float_binary ~op ~dst ~lhs ~rhs =
  let dst_name = string_of_reg dst in
  let lhs_setup, lhs_reg, used = ensure_fpr lhs ~dst ~avoid:[] in
  let rhs_setup, rhs_reg, _used = ensure_fpr rhs ~dst ~avoid:used in
  let mnem =
    match op with
    | Float_op.Fadd -> "fadd"
    | Fsub -> "fsub"
    | Fmul -> "fmul"
    | Fdiv -> "fdiv"
  in
  lhs_setup
  @ rhs_setup
  @ [ sprintf "%s %s, %s, %s" mnem dst_name lhs_reg rhs_reg ]
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
    add_line buffer ".text";
    let used_labels = String.Hash_set.create () in
    List.iteri functions_alist ~f:(fun fn_index (name, fn) ->
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
      let lower_instruction ~current_idx instr =
        let instr = unwrap_tags instr in
        match instr with
        | Nop | Save_clobbers | Restore_clobbers | Alloca _ -> `No_emit
        | Move { dst; src } ->
          `Emit
            [ sprintf "mov %s, %s" (string_of_reg dst) (string_of_operand src) ]
        | Load { dst; addr } ->
          `Emit
            [ sprintf "ldr %s, %s" (string_of_reg dst) (string_of_operand addr)
            ]
        | Store { src; addr } ->
          let addr_str = string_of_operand addr in
          (match src with
           | Reg reg ->
             `Emit [ sprintf "str %s, %s" (string_of_reg reg) addr_str ]
           | _ ->
             let setup, src_reg, _ = ensure_gpr src ~dst:Reg.sp ~avoid:[] in
             `Emit (setup @ [ sprintf "str %s, %s" src_reg addr_str ]))
        | Int_binary { op; dst; lhs; rhs } ->
          `Emit (lower_int_binary ~op ~dst ~lhs ~rhs)
        | Float_binary { op; dst; lhs; rhs } ->
          `Emit (lower_float_binary ~op ~dst ~lhs ~rhs)
        | Convert { op; dst; src } ->
          let dst_name = string_of_reg dst in
          (match op with
           | Convert_op.Int_to_float ->
             let setup, src_reg, _ = ensure_gpr src ~dst ~avoid:[] in
             `Emit (setup @ [ sprintf "scvtf %s, %s" dst_name src_reg ])
           | Float_to_int ->
             let setup, src_reg, _ = ensure_fpr src ~dst ~avoid:[] in
             `Emit (setup @ [ sprintf "fcvtzs %s, %s" dst_name src_reg ]))
        | Bitcast { dst; src } ->
          `Emit
            [ sprintf "mov %s, %s" (string_of_reg dst) (string_of_operand src) ]
        | Adr { dst; target } ->
          `Emit
            [ sprintf
                "adr %s, %s"
                (string_of_reg dst)
                (string_of_jump_target target)
            ]
        | Comp { kind; lhs; rhs } ->
          let lhs_s = string_of_operand lhs in
          let rhs = string_of_operand rhs in
          (match kind with
           | Comp_kind.Int ->
             (match lhs with
              | Reg _ -> `Emit [ sprintf "cmp %s, %s" lhs_s rhs ]
              | _ ->
                let scratch =
                  Reg (pick_scratch gpr_scratch_pool []) |> string_of_operand
                in
                `Emit
                  [ sprintf "mov %s, %s" scratch lhs_s
                  ; sprintf "cmp %s, %s" scratch rhs
                  ])
           | Float ->
             (match lhs with
              | Reg _ -> `Emit [ sprintf "fcmp %s, %s" lhs_s rhs ]
              | _ ->
                let scratch =
                  Reg (pick_scratch fpr_scratch_pool []) |> string_of_operand
                in
                `Emit
                  [ sprintf "fmov %s, %s" scratch lhs_s
                  ; sprintf "fcmp %s, %s" scratch rhs
                  ]))
        | Conditional_branch { condition; then_; else_ } ->
          `Branch (condition, then_, else_)
        | Jump cb ->
          if is_next_block ~idx_by_block ~current_idx cb.Call_block.block
          then `No_emit
          else `Emit [ sprintf "b %s" (label_of_call_block cb) ]
        | Call { fn = callee; _ } ->
          let callee = global_prefix ^ sanitize_identifier callee in
          `Emit [ sprintf "bl %s" callee ]
        | Ret _ -> `Emit [ "ret" ]
        | Label s ->
          let label = ensure_unique (sanitize_identifier s) in
          `Emit_label label
        | Tag_use _ | Tag_def _ -> assert false
      in
      let handle_branch ~current_idx condition cb else_opt =
        let emit_branch cond target =
          emit_instruction (sprintf "b.%s %s" (string_of_condition cond) target)
        in
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
          emit_branch cond (label_of_call_block else_cb)
        | true, _, None -> ()
        | false, true, _ -> emit_branch condition (label_of_call_block cb)
        | false, false, Some else_cb ->
          emit_branch condition (label_of_call_block cb);
          emit_instruction (sprintf "b %s" (label_of_call_block else_cb))
        | false, false, None -> emit_branch condition (label_of_call_block cb)
      in
      let process_instruction ~current_idx instr =
        match lower_instruction ~current_idx instr with
        | `No_emit -> ()
        | `Emit_label label -> emit_label label
        | `Branch (cond, cb, else_opt) ->
          handle_branch ~current_idx cond cb else_opt
        | `Emit lines -> List.iter lines ~f:emit_instruction
      in
      Vec.iteri blocks ~f:(fun idx block ->
        let label = label_of_block block in
        add_line buffer (label ^ ":");
        let instructions = Vec.to_list block.Block.instructions in
        List.iter instructions ~f:(fun ir ->
          match ir with
          | Ir0.Arm64 x -> process_instruction ~current_idx:idx x
          | Ir0.Arm64_terminal xs ->
            List.iter xs ~f:(process_instruction ~current_idx:idx)
          | _ -> ());
        match block.Block.terminal with
        | Ir0.Arm64_terminal xs ->
          List.iter xs ~f:(process_instruction ~current_idx:idx)
        | Ir0.Arm64 x -> process_instruction ~current_idx:idx x
        | _ -> ()));
    (match system with
     | `Linux ->
       Buffer.add_string buffer {|.section .note.GNU-stack,"",@progbits|};
       Buffer.add_string buffer "\n"
     | `Darwin | `Other -> ());
    Buffer.contents buffer
;;
