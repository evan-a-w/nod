open! Core
open! Import
module Reg = X86_reg
module Raw = X86_reg.Raw
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

let rec string_of_raw8 = function
  | Raw.RAX -> "al"
  | Raw.RBX -> "bl"
  | Raw.RCX -> "cl"
  | Raw.RDX -> "dl"
  | Raw.RSI -> "sil"
  | Raw.RDI -> "dil"
  | Raw.RSP -> "spl"
  | Raw.RBP -> "bpl"
  | Raw.R8 -> "r8b"
  | Raw.R9 -> "r9b"
  | Raw.R10 -> "r10b"
  | Raw.R11 -> "r11b"
  | Raw.R12 -> "r12b"
  | Raw.R13 -> "r13b"
  | Raw.R14 -> "r14b"
  | Raw.R15 -> "r15b"
  | Raw.XMM0
  | Raw.XMM1
  | Raw.XMM2
  | Raw.XMM3
  | Raw.XMM4
  | Raw.XMM5
  | Raw.XMM6
  | Raw.XMM7
  | Raw.XMM8
  | Raw.XMM9
  | Raw.XMM10
  | Raw.XMM11
  | Raw.XMM12
  | Raw.XMM13
  | Raw.XMM14
  | Raw.XMM15 -> failwith "expected gpr for byte register"
  | Raw.Unallocated v | Raw.Allocated (v, None) ->
    sanitize_identifier (Var.name v) ^ "b"
  | Raw.Allocated (_, Some reg) -> string_of_raw8 reg
;;

let string_of_reg8 reg = string_of_raw8 (Reg.raw reg)

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
  | Symbol sym -> sym
;;

let string_of_operand_with_size ~size_for_mem operand =
  match operand with
  | Mem (reg, disp) -> sprintf "%s %s" size_for_mem (string_of_mem reg disp)
  | _ -> string_of_operand operand
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

let string_of_instr = function
  | Asm.Mov (Reg dst, Symbol sym) ->
    sprintf "lea %s, [rip + %s]" (string_of_reg dst) sym
  | Asm.Mov (dst, src) -> emit_binary_instr "mov" dst src
  | Movsd (dst, src) -> emit_binary_instr "movsd" dst src
  | Movq (dst, src) -> emit_binary_instr "movq" dst src
  | Cvtsi2sd (dst, src) -> emit_binary_instr "cvtsi2sd" dst src
  | Cvttsd2si (dst, src) -> emit_binary_instr "cvttsd2si" dst src
  | Add (dst, src) -> emit_binary_instr "add" dst src
  | Sub (dst, src) -> emit_binary_instr "sub" dst src
  | Addsd (dst, src) -> emit_binary_instr "addsd" dst src
  | Subsd (dst, src) -> emit_binary_instr "subsd" dst src
  | Mulsd (dst, src) -> emit_binary_instr "mulsd" dst src
  | Divsd (dst, src) -> emit_binary_instr "divsd" dst src
  | And (dst, src) -> emit_binary_instr "and" dst src
  | Or (dst, src) -> emit_binary_instr "or" dst src
  | Imul op -> sprintf "imul %s" (string_of_operand op)
  | Idiv op -> sprintf "idiv %s" (string_of_operand op)
  | Mod op -> sprintf "idiv %s" (string_of_operand op)
  | Cmp (lhs, rhs) -> emit_binary_instr "cmp" lhs rhs
  | Sete dst ->
    (match dst with
     | Reg reg -> sprintf "sete %s" (string_of_reg8 reg)
     | Mem _ ->
       sprintf
         "sete %s"
         (string_of_operand_with_size ~size_for_mem:"byte ptr" dst)
     | Imm _ | Spill_slot _ | Symbol _ ->
       failwith "sete expects register or memory operand")
  | Call { asm_label; _ } -> sprintf "call %s" asm_label
  | Push op -> sprintf "push %s" (string_of_operand op)
  | Pop reg -> sprintf "pop %s" (string_of_reg reg)
  | Jmp target -> sprintf "jmp %s" target
  | Je target -> sprintf "je %s" target
  | Jne target -> sprintf "jne %s" target
  | Ret -> "ret"
  (* Atomic operations *)
  | Mfence -> "mfence"
  | Xchg (dst, src) -> emit_binary_instr "xchg" dst src
  | Lock_add (dst, src) -> emit_binary_instr "lock add" dst src
  | Lock_sub (dst, src) -> emit_binary_instr "lock sub" dst src
  | Lock_and (dst, src) -> emit_binary_instr "lock and" dst src
  | Lock_or (dst, src) -> emit_binary_instr "lock or" dst src
  | Lock_xor (dst, src) -> emit_binary_instr "lock xor" dst src
  | Lock_cmpxchg { dest; expected = _; desired } ->
    (* CMPXCHG compares RAX (expected) with dest, if equal stores desired to dest *)
    (* Note: expected should already be in RAX by the instruction selection *)
    sprintf
      "lock cmpxchg %s, %s"
      (string_of_operand dest)
      (string_of_operand desired)
;;

let add_line buf line =
  Buffer.add_string buf line;
  Buffer.add_char buf '\n'
;;

let run ~system ?(globals = []) (program : Asm.program) =
  match program, globals with
  | [], [] -> ""
  | _ ->
    let buffer = Buffer.create 1024 in
    add_line buffer ".intel_syntax noprefix";
    let global_prefix =
      match system with
      | `Darwin -> "_"
      | `Linux | `Other -> ""
    in
    let label_of name = global_prefix ^ sanitize_identifier name in
    let data_lines =
      Nod_backend_common.Global_data.data_section_lines ~label_of globals
    in
    List.iter data_lines ~f:(add_line buffer);
    add_line buffer ".text";
    List.iteri program ~f:(fun fn_index fn ->
      if fn_index > 0 then Buffer.add_char buffer '\n';
      add_line buffer (sprintf ".globl %s" fn.asm_label);
      List.iter fn.items ~f:(function
        | Asm.Label label -> add_line buffer (label ^ ":")
        | Asm.Instr instr -> add_line buffer ("  " ^ string_of_instr instr)));
    (match system with
     | `Linux ->
       Buffer.add_string buffer {|.section .note.GNU-stack,"",@progbits|};
       Buffer.add_char buffer '\n'
     | `Darwin | `Other -> ());
    Buffer.contents buffer
;;
