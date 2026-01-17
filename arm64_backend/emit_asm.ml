open! Core
open! Import
open Arm64_ir
module Reg = Arm64_reg
module Raw = Arm64_reg.Raw
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
  | Spill_slot _ -> failwith "Shouldn't have spill slot here"
  | Reg reg -> string_of_reg reg
  | Imm imm -> sprintf "#%Ld" imm
  | Mem (reg, disp) -> string_of_mem reg disp
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

let string_of_jump_target = function
  | Jump_target.Reg reg -> string_of_reg reg
  | Imm imm -> sprintf "#%Ld" imm
  | Symbol sym -> sanitize_identifier (Symbol.to_string sym)
  | Label label -> label
;;

let string_of_instr = function
  | Asm.Mov { dst; src } ->
    sprintf "mov %s, %s" (string_of_reg dst) (string_of_operand src)
  | Ldr { dst; addr } ->
    sprintf "ldr %s, %s" (string_of_reg dst) (string_of_operand addr)
  | Str { src; addr } ->
    sprintf "str %s, %s" (string_of_operand src) (string_of_operand addr)
  | Dmb -> "dmb ish"
  | Ldar { dst; addr } ->
    sprintf "ldar %s, %s" (string_of_reg dst) (string_of_operand addr)
  | Stlr { src; addr } ->
    sprintf "stlr %s, %s" (string_of_operand src) (string_of_operand addr)
  | Ldaxr { dst; addr } ->
    sprintf "ldaxr %s, %s" (string_of_reg dst) (string_of_operand addr)
  | Stlxr { status; src; addr } ->
    sprintf
      "stlxr %s, %s, %s"
      (string_of_reg status)
      (string_of_operand src)
      (string_of_operand addr)
  | Casal { expected; desired; addr } ->
    sprintf
      "casal %s, %s, %s"
      (string_of_reg expected)
      (string_of_reg desired)
      (string_of_operand addr)
  | Add { dst; lhs; rhs } ->
    sprintf
      "add %s, %s, %s"
      (string_of_reg dst)
      (string_of_reg lhs)
      (string_of_reg rhs)
  | Sub { dst; lhs; rhs } ->
    sprintf
      "sub %s, %s, %s"
      (string_of_reg dst)
      (string_of_reg lhs)
      (string_of_reg rhs)
  | Mul { dst; lhs; rhs } ->
    sprintf
      "mul %s, %s, %s"
      (string_of_reg dst)
      (string_of_reg lhs)
      (string_of_reg rhs)
  | Sdiv { dst; lhs; rhs } ->
    sprintf
      "sdiv %s, %s, %s"
      (string_of_reg dst)
      (string_of_reg lhs)
      (string_of_reg rhs)
  | Msub { dst; lhs; rhs; acc } ->
    sprintf
      "msub %s, %s, %s, %s"
      (string_of_reg dst)
      (string_of_reg lhs)
      (string_of_reg rhs)
      (string_of_reg acc)
  | And { dst; lhs; rhs } ->
    sprintf
      "and %s, %s, %s"
      (string_of_reg dst)
      (string_of_reg lhs)
      (string_of_reg rhs)
  | Orr { dst; lhs; rhs } ->
    sprintf
      "orr %s, %s, %s"
      (string_of_reg dst)
      (string_of_reg lhs)
      (string_of_reg rhs)
  | Eor { dst; lhs; rhs } ->
    sprintf
      "eor %s, %s, %s"
      (string_of_reg dst)
      (string_of_reg lhs)
      (string_of_reg rhs)
  | Lsl { dst; lhs; rhs } ->
    sprintf
      "lsl %s, %s, %s"
      (string_of_reg dst)
      (string_of_reg lhs)
      (string_of_reg rhs)
  | Lsr { dst; lhs; rhs } ->
    sprintf
      "lsr %s, %s, %s"
      (string_of_reg dst)
      (string_of_reg lhs)
      (string_of_reg rhs)
  | Asr { dst; lhs; rhs } ->
    sprintf
      "asr %s, %s, %s"
      (string_of_reg dst)
      (string_of_reg lhs)
      (string_of_reg rhs)
  | Fadd { dst; lhs; rhs } ->
    sprintf
      "fadd %s, %s, %s"
      (string_of_reg dst)
      (string_of_reg lhs)
      (string_of_reg rhs)
  | Fsub { dst; lhs; rhs } ->
    sprintf
      "fsub %s, %s, %s"
      (string_of_reg dst)
      (string_of_reg lhs)
      (string_of_reg rhs)
  | Fmul { dst; lhs; rhs } ->
    sprintf
      "fmul %s, %s, %s"
      (string_of_reg dst)
      (string_of_reg lhs)
      (string_of_reg rhs)
  | Fdiv { dst; lhs; rhs } ->
    sprintf
      "fdiv %s, %s, %s"
      (string_of_reg dst)
      (string_of_reg lhs)
      (string_of_reg rhs)
  | Scvtf { dst; src } ->
    sprintf "scvtf %s, %s" (string_of_reg dst) (string_of_reg src)
  | Fcvtzs { dst; src } ->
    sprintf "fcvtzs %s, %s" (string_of_reg dst) (string_of_reg src)
  | Fmov { dst; src } ->
    sprintf "fmov %s, %s" (string_of_reg dst) (string_of_operand src)
  | Cmp { lhs; rhs } ->
    sprintf "cmp %s, %s" (string_of_operand lhs) (string_of_operand rhs)
  | Fcmp { lhs; rhs } ->
    sprintf "fcmp %s, %s" (string_of_operand lhs) (string_of_operand rhs)
  | Cset { condition; dst } ->
    sprintf "cset %s, %s" (string_of_reg dst) (string_of_condition condition)
  | Adr { dst; target } ->
    sprintf "adr %s, %s" (string_of_reg dst) (string_of_jump_target target)
  | B target -> sprintf "b %s" target
  | Bcond { condition; target } ->
    sprintf "b.%s %s" (string_of_condition condition) target
  | Bl { asm_label; _ } -> sprintf "bl %s" asm_label
  | Ret -> "ret"
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
