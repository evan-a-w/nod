open! Core
open! Import
module Reg = X86_reg
module Raw = X86_reg.Raw

module Jump_target = struct
  type 'var t =
    | Reg of 'var Reg.t
    | Imm of Int64.t
    | Symbol of Symbol.t
end

type 'var operand =
  | Reg of 'var Reg.t
  | Imm of Int64.t
  | Mem of 'var Reg.t * int (* [reg + disp] *)
  | Spill_slot of int
  | Symbol of string
    (* bit of a hack, used so regalloc can run before we do clobber stuff *)
[@@deriving sexp, equal, compare, hash]

let reg_of_operand_exn = function
  | Reg r -> r
  | _ -> failwith "Not operand reg"
;;

type ('var, 'block) t =
  | NOOP
  (* Use this tag things for regalloc bs where we mint temp vars and make them allocated to a particular hw reg when we need *)
  | Tag_use of ('var, 'block) t * 'var operand
  | Tag_def of ('var, 'block) t * 'var operand
  | AND of 'var operand * 'var operand
  | OR of 'var operand * 'var operand
  | MOV of 'var operand * 'var operand
  | ADD of 'var operand * 'var operand
  | SUB of 'var operand * 'var operand
  | IMUL of 'var operand (* multiply RAX by operand  result RDX:RAX *)
  | IDIV of
      'var operand (* divide RDX:RAX by operand  result in RAX, mod in RDX *)
  | MOD of
      'var operand (* divide RDX:RAX by operand  result in RDX, quot in RAX *)
  (* SSE float instructions *)
  | ADDSD of 'var operand * 'var operand (* double precision add *)
  | SUBSD of 'var operand * 'var operand (* double precision sub *)
  | MULSD of 'var operand * 'var operand (* double precision mul *)
  | DIVSD of 'var operand * 'var operand (* double precision div *)
  | MOVSD of 'var operand * 'var operand (* f64 move *)
  | MOVQ of
      'var operand * 'var operand (* move quadword (for i64<->f64 bitcast) *)
  (* Type conversion instructions *)
  | CVTSI2SD of 'var operand * 'var operand (* convert int64 to f64 *)
  | CVTTSD2SI of
      'var operand * 'var operand (* convert f64 to int64 with truncation *)
  (* Atomic operations *)
  | MFENCE (* memory fence - full barrier *)
  | XCHG of
      'var operand * 'var operand (* atomic exchange - always locked on x86 *)
  | LOCK_ADD of 'var operand * 'var operand (* locked add *)
  | LOCK_SUB of 'var operand * 'var operand (* locked sub *)
  | LOCK_AND of 'var operand * 'var operand (* locked and *)
  | LOCK_OR of 'var operand * 'var operand (* locked or *)
  | LOCK_XOR of 'var operand * 'var operand (* locked xor *)
  | LOCK_CMPXCHG of
      { dest : 'var operand (* memory location *)
      ; expected :
          'var operand (* register with expected value, typically RAX *)
      ; desired : 'var operand (* register with desired value *)
      }
  | Save_clobbers
  | Restore_clobbers
  | CALL of
      { fn : string
      ; results : 'var Reg.t list
      ; args : 'var operand list
      }
  | PUSH of 'var operand
  | POP of 'var Reg.t
  | LABEL of string
  | CMP of 'var operand * 'var operand
  | SETE of 'var operand
  | SETL of 'var operand (* set if less than, signed *)
  | JE of ('var, 'block) Call_block.t * ('var, 'block) Call_block.t option
  | JNE of ('var, 'block) Call_block.t * ('var, 'block) Call_block.t option
  | JMP of ('var, 'block) Call_block.t
  | RET of 'var operand list
  | ALLOCA of 'var operand * Int64.t
[@@deriving sexp, equal, compare, hash, variants]

let fn = function
  | CALL { fn; _ } -> Some fn
  | NOOP
  | Tag_use (_, _)
  | Tag_def (_, _)
  | AND (_, _)
  | OR (_, _)
  | MOV (_, _)
  | ADD (_, _)
  | SUB (_, _)
  | IMUL _ | IDIV _ | MOD _
  | ADDSD (_, _)
  | SUBSD (_, _)
  | MULSD (_, _)
  | DIVSD (_, _)
  | MOVSD (_, _)
  | MOVQ (_, _)
  | CVTSI2SD (_, _)
  | CVTTSD2SI (_, _)
  | MFENCE
  | XCHG (_, _)
  | LOCK_ADD (_, _)
  | LOCK_SUB (_, _)
  | LOCK_AND (_, _)
  | LOCK_OR (_, _)
  | LOCK_XOR (_, _)
  | LOCK_CMPXCHG _ | Save_clobbers | Restore_clobbers | PUSH _ | POP _ | LABEL _
  | CMP (_, _)
  | SETE _ | SETL _
  | JE (_, _)
  | JNE (_, _)
  | JMP _ | RET _
  | ALLOCA (_, _) -> None
;;

let fold_operand op ~f ~init = f init op

let fold_operands ins ~f ~init =
  match ins with
  | Save_clobbers | Restore_clobbers | MFENCE -> init
  | ALLOCA (r, _) | Tag_use (_, r) | Tag_def (_, r) -> f init r
  | MOV (dst, src)
  | AND (dst, src)
  | OR (dst, src)
  | ADD (dst, src)
  | SUB (dst, src)
  | CMP (dst, src)
  | ADDSD (dst, src)
  | SUBSD (dst, src)
  | MULSD (dst, src)
  | DIVSD (dst, src)
  | MOVSD (dst, src)
  | MOVQ (dst, src)
  | CVTSI2SD (dst, src)
  | CVTTSD2SI (dst, src)
  | XCHG (dst, src)
  | LOCK_ADD (dst, src)
  | LOCK_SUB (dst, src)
  | LOCK_AND (dst, src)
  | LOCK_OR (dst, src)
  | LOCK_XOR (dst, src) ->
    let init = fold_operand dst ~f ~init in
    fold_operand src ~f ~init
  | SETE dst | SETL dst -> fold_operand dst ~f ~init
  | LOCK_CMPXCHG { dest; expected; desired } ->
    let init = fold_operand dest ~f ~init in
    let init = fold_operand expected ~f ~init in
    fold_operand desired ~f ~init
  | IMUL op | IDIV op | MOD op -> fold_operand op ~f ~init
  | RET ops -> List.fold ops ~init ~f:(fun acc -> fold_operand ~f ~init:acc)
  | CALL { results; args; _ } ->
    let init = List.fold results ~init ~f:(fun acc reg -> f acc (Reg reg)) in
    List.fold args ~init ~f:(fun acc op -> f acc op)
  | PUSH op ->
    let init = fold_operand op ~f ~init in
    fold_operand (Reg Reg.rsp) ~f ~init
  | POP reg ->
    let init = fold_operand (Reg reg) ~f ~init in
    fold_operand (Reg Reg.rsp) ~f ~init
  | NOOP | LABEL _ | JE _ | JNE _ | JMP _ -> init
;;

let map_var_operand op ~f =
  match op with
  | Reg r -> Reg (Reg.map_vars r ~f)
  | Imm i -> Imm i
  | Spill_slot s -> Spill_slot s
  | Symbol s -> Symbol s
  | Mem (r, disp) -> Mem (Reg.map_vars r ~f, disp)
;;

let rec map_var_operands ins ~f =
  match ins with
  | Save_clobbers -> Save_clobbers
  | Restore_clobbers -> Restore_clobbers
  | MFENCE -> MFENCE
  | ALLOCA (a, b) -> ALLOCA (map_var_operand a ~f, b)
  | Tag_def (ins, r) -> Tag_def (map_var_operands ins ~f, map_var_operand r ~f)
  | Tag_use (ins, r) -> Tag_use (map_var_operands ins ~f, map_var_operand r ~f)
  | AND (dst, src) -> AND (map_var_operand dst ~f, map_var_operand src ~f)
  | OR (dst, src) -> OR (map_var_operand dst ~f, map_var_operand src ~f)
  | MOV (dst, src) -> MOV (map_var_operand dst ~f, map_var_operand src ~f)
  | ADD (dst, src) -> ADD (map_var_operand dst ~f, map_var_operand src ~f)
  | SUB (dst, src) -> SUB (map_var_operand dst ~f, map_var_operand src ~f)
  | ADDSD (dst, src) -> ADDSD (map_var_operand dst ~f, map_var_operand src ~f)
  | SUBSD (dst, src) -> SUBSD (map_var_operand dst ~f, map_var_operand src ~f)
  | MULSD (dst, src) -> MULSD (map_var_operand dst ~f, map_var_operand src ~f)
  | DIVSD (dst, src) -> DIVSD (map_var_operand dst ~f, map_var_operand src ~f)
  | MOVSD (dst, src) -> MOVSD (map_var_operand dst ~f, map_var_operand src ~f)
  | MOVQ (dst, src) -> MOVQ (map_var_operand dst ~f, map_var_operand src ~f)
  | CVTSI2SD (dst, src) ->
    CVTSI2SD (map_var_operand dst ~f, map_var_operand src ~f)
  | CVTTSD2SI (dst, src) ->
    CVTTSD2SI (map_var_operand dst ~f, map_var_operand src ~f)
  | SETE dst -> SETE (map_var_operand dst ~f)
  | SETL dst -> SETL (map_var_operand dst ~f)
  | XCHG (dst, src) -> XCHG (map_var_operand dst ~f, map_var_operand src ~f)
  | LOCK_ADD (dst, src) ->
    LOCK_ADD (map_var_operand dst ~f, map_var_operand src ~f)
  | LOCK_SUB (dst, src) ->
    LOCK_SUB (map_var_operand dst ~f, map_var_operand src ~f)
  | LOCK_AND (dst, src) ->
    LOCK_AND (map_var_operand dst ~f, map_var_operand src ~f)
  | LOCK_OR (dst, src) ->
    LOCK_OR (map_var_operand dst ~f, map_var_operand src ~f)
  | LOCK_XOR (dst, src) ->
    LOCK_XOR (map_var_operand dst ~f, map_var_operand src ~f)
  | LOCK_CMPXCHG { dest; expected; desired } ->
    LOCK_CMPXCHG
      { dest = map_var_operand dest ~f
      ; expected = map_var_operand expected ~f
      ; desired = map_var_operand desired ~f
      }
  | IDIV op -> IDIV (map_var_operand op ~f)
  | IMUL op -> IMUL (map_var_operand op ~f)
  | MOD op -> MOD (map_var_operand op ~f)
  | CALL { fn; results; args } ->
    let map_result r =
      match map_var_operand (Reg r) ~f with
      | Reg r' -> r'
      | _ -> failwith "expected reg operand in CALL results"
    in
    CALL
      { fn
      ; results = List.map results ~f:map_result
      ; args = List.map args ~f:(fun op -> map_var_operand op ~f)
      }
  | PUSH op -> PUSH (map_var_operand op ~f)
  | POP reg ->
    (match map_var_operand (Reg reg) ~f with
     | Reg reg' -> POP reg'
     | _ -> failwith "expected reg operand in POP")
  | CMP (a, b) -> CMP (map_var_operand a ~f, map_var_operand b ~f)
  | RET ops -> RET (List.map ~f:(map_var_operand ~f) ops)
  | JE (lbl, next) ->
    let map_cb cb = Call_block.map_uses cb ~f in
    JE (map_cb lbl, Option.map next ~f:map_cb)
  | JNE (lbl, next) ->
    let map_cb cb = Call_block.map_uses cb ~f in
    JNE (map_cb lbl, Option.map next ~f:map_cb)
  | JMP lbl -> JMP (Call_block.map_uses lbl ~f)
  | NOOP -> NOOP
  | LABEL s -> LABEL s
;;

let var_of_reg (reg : 'var Reg.t) =
  match Reg.raw reg with
  | Raw.Unallocated v | Raw.Allocated (v, _) -> Some v
  | _ -> None
;;

let vars_of_reg (reg : 'var Reg.t) =
  match Reg.raw reg with
  | Raw.Unallocated v | Raw.Allocated (v, _) -> [ v ]
  | _ -> []
;;

let vars_of_operand = function
  | Reg r -> vars_of_reg r
  | Imm _ | Spill_slot _ | Symbol _ -> []
  | Mem (r, _disp) -> vars_of_reg r
;;

let regs_of_operand = function
  | Reg r -> [ r ]
  | Spill_slot _ ->
    Breadcrumbs.frame_pointer_omission;
    [ X86_reg.rbp ]
  | Imm _ | Symbol _ -> []
  | Mem (r, _disp) -> [ r ]
;;

let map_virtual_reg reg ~f =
  match Reg.raw reg with
  | Raw.Unallocated v -> Reg.unallocated ~class_:(Reg.class_ reg) (f v)
  | Raw.Allocated (v, forced) ->
    let forced =
      Option.map forced ~f:(fun raw -> Reg.create ~class_:(Reg.class_ reg) ~raw)
    in
    Reg.allocated ~class_:(Reg.class_ reg) (f v) forced
  | _ -> reg
;;

let regs_of_def_operand = function
  | Reg r -> [ r ]
  | Imm _ | Mem _ | Spill_slot _ | Symbol _ -> []
;;

let regs_of_mem_base = function
  | Mem (r, _) -> [ r ]
  | Spill_slot _ -> [ Reg.rbp ]
  | Reg _ | Imm _ | Symbol _ -> []
;;

let map_def_reg = map_virtual_reg
let map_use_reg = map_virtual_reg

let map_def_operand op ~f =
  match op with
  | Reg r -> Reg (map_def_reg r ~f)
  | Imm _ | Spill_slot _ | Symbol _ -> op
  | Mem (r, disp) -> Mem (map_def_reg r ~f, disp)
;;

let map_use_operand op ~f =
  match op with
  | Reg r -> Reg (map_use_reg r ~f)
  | Spill_slot _ | Imm _ | Symbol _ -> op
  | Mem (r, disp) -> Mem (map_use_reg r ~f, disp)
;;

let rec reg_defs ins =
  match ins with
  | Save_clobbers | Restore_clobbers | MFENCE -> []
  | Tag_def (ins, r) -> regs_of_operand r @ reg_defs ins
  | Tag_use (ins, _) -> reg_defs ins
  | MOV (dst, _)
  | MOVQ (dst, _)
  | MOVSD (dst, _)
  | CVTSI2SD (dst, _)
  | CVTTSD2SI (dst, _) -> regs_of_def_operand dst
  | ALLOCA (dst, _)
  | AND (dst, _)
  | OR (dst, _)
  | ADD (dst, _)
  | SUB (dst, _)
  | ADDSD (dst, _)
  | SUBSD (dst, _)
  | MULSD (dst, _)
  | DIVSD (dst, _) -> regs_of_def_operand dst
  | SETE dst | SETL dst -> regs_of_def_operand dst
  (* Atomic RMW operations define both operands (dest gets old value, dest is also read) *)
  | XCHG (dst, _)
  | LOCK_ADD (dst, _)
  | LOCK_SUB (dst, _)
  | LOCK_AND (dst, _)
  | LOCK_OR (dst, _)
  | LOCK_XOR (dst, _) -> regs_of_def_operand dst
  (* CMPXCHG writes to the expected register (EAX) with old value, and may write to dest *)
  | LOCK_CMPXCHG { dest; expected; desired = _ } ->
    regs_of_def_operand dest @ regs_of_def_operand expected
  | IDIV _ | MOD _ | IMUL _ -> [ Reg.rax; Reg.rdx ]
  | CALL { results; _ } -> results
  | PUSH _ -> [ Reg.rsp ]
  | POP reg -> [ Reg.rsp; reg ]
  | NOOP | RET _ | CMP _ | LABEL _ | JE _ | JNE _ | JMP _ -> []
;;

let rec reg_uses ins =
  match ins with
  | Save_clobbers | Restore_clobbers | MFENCE -> []
  | Tag_use (ins, r) -> regs_of_operand r @ reg_uses ins
  | Tag_def (ins, _) -> reg_uses ins
  | IDIV op | MOD op -> regs_of_operand op @ [ Reg.rax; Reg.rdx ]
  | IMUL op -> regs_of_operand op @ [ Reg.rax ]
  | MOV (dst, src)
  | MOVQ (dst, src)
  | MOVSD (dst, src)
  | CVTSI2SD (dst, src)
  | CVTTSD2SI (dst, src) -> regs_of_operand src @ regs_of_mem_base dst
  | SETE dst | SETL dst -> regs_of_mem_base dst
  | ADD (dst, src)
  | SUB (dst, src)
  | AND (dst, src)
  | OR (dst, src)
  | ADDSD (dst, src)
  | SUBSD (dst, src)
  | MULSD (dst, src)
  | DIVSD (dst, src) -> regs_of_operand dst @ regs_of_operand src
  (* Atomic RMW operations use both operands *)
  | XCHG (dst, src)
  | LOCK_ADD (dst, src)
  | LOCK_SUB (dst, src)
  | LOCK_AND (dst, src)
  | LOCK_OR (dst, src)
  | LOCK_XOR (dst, src) -> regs_of_operand dst @ regs_of_operand src
  (* CMPXCHG uses all three operands *)
  | LOCK_CMPXCHG { dest; expected; desired } ->
    regs_of_operand dest @ regs_of_operand expected @ regs_of_operand desired
  | CMP (a, b) -> regs_of_operand a @ regs_of_operand b
  | RET ops -> List.concat_map ops ~f:regs_of_operand
  | PUSH op -> Reg.rsp :: regs_of_operand op
  | POP _ -> [ Reg.rsp ]
  | CALL { args; _ } -> List.concat_map args ~f:regs_of_operand
  | JE (a, b) | JNE (a, b) ->
    Call_block.uses a
    @ (Option.map b ~f:Call_block.uses |> Option.value ~default:[])
    |> List.map ~f:Reg.unallocated
  | JMP a -> Call_block.uses a |> List.map ~f:Reg.unallocated
  | ALLOCA _ | NOOP | LABEL _ -> []
;;

let regs ins = reg_defs ins @ reg_uses ins
let vars ins = regs ins |> List.filter_map ~f:var_of_reg
let defs ins = reg_defs ins |> List.filter_map ~f:var_of_reg
let uses ins = reg_uses ins |> List.filter_map ~f:var_of_reg

let rec blocks instr =
  match instr with
  | Save_clobbers | Restore_clobbers | MFENCE -> []
  | Tag_use (ins, _) | Tag_def (ins, _) -> blocks ins
  | NOOP
  | MOV _
  | ADD _
  | SUB _
  | ADDSD _
  | SUBSD _
  | MULSD _
  | DIVSD _
  | MOVQ _
  | MOVSD _
  | CVTSI2SD _
  | CVTTSD2SI _
  | XCHG _
  | LOCK_ADD _
  | LOCK_SUB _
  | LOCK_AND _
  | LOCK_OR _
  | LOCK_XOR _
  | LOCK_CMPXCHG _
  | IMUL _
  | IDIV _
  | MOD _
  | CMP _
  | SETE _
  | SETL _
  | RET _
  | AND _
  | OR _
  | CALL _
  | PUSH _
  | POP _
  | ALLOCA _
  | LABEL _ -> []
  | JMP lbl -> Call_block.blocks lbl
  | JE (lbl, next) | JNE (lbl, next) ->
    List.concat_map ~f:Call_block.blocks (lbl :: Option.to_list next)
;;

let rec map_blocks (instr : ('var, 'a) t) ~(f : 'a -> 'b) : ('var, 'b) t =
  match instr with
  | Save_clobbers -> Save_clobbers
  | Restore_clobbers -> Restore_clobbers
  | MFENCE -> MFENCE
  | ALLOCA (a, b) -> ALLOCA (a, b)
  | Tag_def (ins, r) -> Tag_def (map_blocks ins ~f, r)
  | Tag_use (ins, r) -> Tag_use (map_blocks ins ~f, r)
  | LABEL s -> LABEL s
  | AND (x, y) -> AND (x, y)
  | OR (x, y) -> OR (x, y)
  | MOV (x, y) -> MOV (x, y)
  | MOVSD (x, y) -> MOVSD (x, y)
  | MOVQ (x, y) -> MOVQ (x, y)
  | CVTSI2SD (x, y) -> CVTSI2SD (x, y)
  | CVTTSD2SI (x, y) -> CVTTSD2SI (x, y)
  | ADD (x, y) -> ADD (x, y)
  | SUB (x, y) -> SUB (x, y)
  | ADDSD (x, y) -> ADDSD (x, y)
  | SUBSD (x, y) -> SUBSD (x, y)
  | MULSD (x, y) -> MULSD (x, y)
  | DIVSD (x, y) -> DIVSD (x, y)
  | XCHG (x, y) -> XCHG (x, y)
  | LOCK_ADD (x, y) -> LOCK_ADD (x, y)
  | LOCK_SUB (x, y) -> LOCK_SUB (x, y)
  | LOCK_AND (x, y) -> LOCK_AND (x, y)
  | LOCK_OR (x, y) -> LOCK_OR (x, y)
  | LOCK_XOR (x, y) -> LOCK_XOR (x, y)
  | LOCK_CMPXCHG r -> LOCK_CMPXCHG r
  | IMUL x -> IMUL x
  | IDIV x -> IDIV x
  | MOD x -> MOD x
  | CALL call -> CALL call
  | PUSH op -> PUSH op
  | POP reg -> POP reg
  | CMP (x, y) -> CMP (x, y)
  | SETE x -> SETE x
  | SETL x -> SETL x
  | JE (lbl, next) ->
    JE
      ( Call_block.map_blocks ~f lbl
      , Option.map next ~f:(Call_block.map_blocks ~f) )
  | JNE (lbl, next) ->
    JNE
      ( Call_block.map_blocks ~f lbl
      , Option.map next ~f:(Call_block.map_blocks ~f) )
  | JMP lbl -> JMP (Call_block.map_blocks ~f lbl)
  | RET x -> RET x
  | NOOP -> NOOP
;;

let rec filter_map_call_blocks t ~f =
  match t with
  | Save_clobbers | Restore_clobbers | MFENCE -> []
  | Tag_use (ins, _) | Tag_def (ins, _) -> filter_map_call_blocks ins ~f
  | NOOP
  | MOV _
  | MOVQ _
  | MOVSD _
  | CVTSI2SD _
  | CVTTSD2SI _
  | ALLOCA _
  | ADD _
  | SUB _
  | ADDSD _
  | SUBSD _
  | MULSD _
  | DIVSD _
  | XCHG _
  | LOCK_ADD _
  | LOCK_SUB _
  | LOCK_AND _
  | LOCK_OR _
  | LOCK_XOR _
  | LOCK_CMPXCHG _
  | IMUL _
  | IDIV _
  | MOD _
  | CMP _
  | SETE _
  | SETL _
  | RET _
  | AND _
  | OR _
  | CALL _
  | PUSH _
  | POP _
  | LABEL _ -> []
  | JMP lbl -> f lbl |> Option.to_list
  | JE (lbl, next) | JNE (lbl, next) ->
    (f lbl |> Option.to_list) @ (Option.bind next ~f |> Option.to_list)
;;

let unreachable = NOOP

let rec map_defs t ~f =
  let map_dst op = map_def_operand op ~f in
  match t with
  | Save_clobbers -> Save_clobbers
  | Restore_clobbers -> Restore_clobbers
  | MFENCE -> MFENCE
  | ALLOCA (a, b) -> ALLOCA (map_dst a, b)
  | Tag_def (ins, r) -> Tag_def (map_defs ins ~f, map_dst r)
  | Tag_use (ins, r) -> Tag_use (map_defs ins ~f, r)
  | MOV (dst, src) -> MOV (map_dst dst, src)
  | MOVQ (dst, src) -> MOVQ (map_dst dst, src)
  | MOVSD (dst, src) -> MOVSD (map_dst dst, src)
  | CVTSI2SD (dst, src) -> CVTSI2SD (map_dst dst, src)
  | CVTTSD2SI (dst, src) -> CVTTSD2SI (map_dst dst, src)
  | SETE dst -> SETE (map_dst dst)
  | SETL dst -> SETL (map_dst dst)
  | AND (dst, src) -> AND (map_dst dst, src)
  | OR (dst, src) -> OR (map_dst dst, src)
  | ADD (dst, src) -> ADD (map_dst dst, src)
  | SUB (dst, src) -> SUB (map_dst dst, src)
  | ADDSD (dst, src) -> ADDSD (map_dst dst, src)
  | SUBSD (dst, src) -> SUBSD (map_dst dst, src)
  | MULSD (dst, src) -> MULSD (map_dst dst, src)
  | DIVSD (dst, src) -> DIVSD (map_dst dst, src)
  | XCHG (dst, src) -> XCHG (map_dst dst, src)
  | LOCK_ADD (dst, src) -> LOCK_ADD (map_dst dst, src)
  | LOCK_SUB (dst, src) -> LOCK_SUB (map_dst dst, src)
  | LOCK_AND (dst, src) -> LOCK_AND (map_dst dst, src)
  | LOCK_OR (dst, src) -> LOCK_OR (map_dst dst, src)
  | LOCK_XOR (dst, src) -> LOCK_XOR (map_dst dst, src)
  | LOCK_CMPXCHG { dest; expected; desired } ->
    LOCK_CMPXCHG { dest = map_dst dest; expected = map_dst expected; desired }
  | CALL { fn; results; args } ->
    CALL { fn; results = List.map results ~f:(fun r -> map_def_reg r ~f); args }
  | POP reg -> POP (map_def_reg reg ~f)
  | PUSH _ -> t
  | NOOP | IDIV _ | MOD _ | LABEL _ | IMUL _
  | CMP (_, _)
  | JE (_, _)
  | JNE (_, _)
  | JMP _ | RET _ -> t
;;

let rec map_uses t ~f =
  let map_op op = map_use_operand op ~f in
  let map_call_block cb = Call_block.map_uses cb ~f in
  match t with
  | Save_clobbers -> Save_clobbers
  | Restore_clobbers -> Restore_clobbers
  | MFENCE -> MFENCE
  | Tag_def (ins, r) -> Tag_def (map_uses ins ~f, r)
  | Tag_use (ins, r) -> Tag_use (map_uses ins ~f, map_op r)
  | MOV (dst, src) -> MOV (dst, map_op src)
  | MOVSD (dst, src) -> MOVSD (dst, map_op src)
  | MOVQ (dst, src) -> MOVQ (dst, map_op src)
  | CVTSI2SD (dst, src) -> CVTSI2SD (dst, map_op src)
  | CVTTSD2SI (dst, src) -> CVTTSD2SI (dst, map_op src)
  | SETE dst -> SETE (map_op dst)
  | SETL dst -> SETL (map_op dst)
  | AND (dst, src) -> AND (map_op dst, map_op src)
  | OR (dst, src) -> OR (map_op dst, map_op src)
  | ADD (dst, src) -> ADD (map_op dst, map_op src)
  | SUB (dst, src) -> SUB (map_op dst, map_op src)
  | ADDSD (dst, src) -> ADDSD (map_op dst, map_op src)
  | SUBSD (dst, src) -> SUBSD (map_op dst, map_op src)
  | MULSD (dst, src) -> MULSD (map_op dst, map_op src)
  | DIVSD (dst, src) -> DIVSD (map_op dst, map_op src)
  | XCHG (dst, src) -> XCHG (map_op dst, map_op src)
  | LOCK_ADD (dst, src) -> LOCK_ADD (map_op dst, map_op src)
  | LOCK_SUB (dst, src) -> LOCK_SUB (map_op dst, map_op src)
  | LOCK_AND (dst, src) -> LOCK_AND (map_op dst, map_op src)
  | LOCK_OR (dst, src) -> LOCK_OR (map_op dst, map_op src)
  | LOCK_XOR (dst, src) -> LOCK_XOR (map_op dst, map_op src)
  | LOCK_CMPXCHG { dest; expected; desired } ->
    LOCK_CMPXCHG
      { dest = map_op dest
      ; expected = map_op expected
      ; desired = map_op desired
      }
  | IMUL op -> IMUL (map_op op)
  | IDIV op -> IDIV (map_op op)
  | MOD op -> MOD (map_op op)
  | CMP (a, b) -> CMP (map_op a, map_op b)
  | RET ops -> RET (List.map ~f:map_op ops)
  | CALL { fn; results; args } ->
    CALL { fn; results; args = List.map args ~f:map_op }
  | PUSH op -> PUSH (map_op op)
  | POP reg -> POP reg
  | JE (lbl, next) -> JE (map_call_block lbl, Option.map next ~f:map_call_block)
  | JNE (lbl, next) ->
    JNE (map_call_block lbl, Option.map next ~f:map_call_block)
  | JMP lbl -> JMP (map_call_block lbl)
  | NOOP | LABEL _ | ALLOCA _ -> t
;;

let rec map_operands t ~f =
  match t with
  | Save_clobbers -> Save_clobbers
  | Restore_clobbers -> Restore_clobbers
  | MFENCE -> MFENCE
  | ALLOCA (a, b) -> ALLOCA (f a, b)
  | Tag_def (ins, r) -> Tag_def (map_operands ins ~f, f r)
  | Tag_use (ins, r) -> Tag_use (map_operands ins ~f, f r)
  | MOV (dst, src) -> MOV (f dst, f src)
  | MOVSD (dst, src) -> MOVSD (f dst, f src)
  | MOVQ (dst, src) -> MOVQ (f dst, f src)
  | CVTSI2SD (dst, src) -> CVTSI2SD (f dst, f src)
  | CVTTSD2SI (dst, src) -> CVTTSD2SI (f dst, f src)
  | SETE dst -> SETE (f dst)
  | SETL dst -> SETL (f dst)
  | AND (dst, src) -> AND (f dst, f src)
  | OR (dst, src) -> OR (f dst, f src)
  | ADD (dst, src) -> ADD (f dst, f src)
  | SUB (dst, src) -> SUB (f dst, f src)
  | ADDSD (dst, src) -> ADDSD (f dst, f src)
  | SUBSD (dst, src) -> SUBSD (f dst, f src)
  | MULSD (dst, src) -> MULSD (f dst, f src)
  | DIVSD (dst, src) -> DIVSD (f dst, f src)
  | XCHG (dst, src) -> XCHG (f dst, f src)
  | LOCK_ADD (dst, src) -> LOCK_ADD (f dst, f src)
  | LOCK_SUB (dst, src) -> LOCK_SUB (f dst, f src)
  | LOCK_AND (dst, src) -> LOCK_AND (f dst, f src)
  | LOCK_OR (dst, src) -> LOCK_OR (f dst, f src)
  | LOCK_XOR (dst, src) -> LOCK_XOR (f dst, f src)
  | LOCK_CMPXCHG { dest; expected; desired } ->
    LOCK_CMPXCHG { dest = f dest; expected = f expected; desired = f desired }
  | IMUL op -> IMUL (f op)
  | IDIV op -> IDIV (f op)
  | MOD op -> MOD (f op)
  | CMP (a, b) -> CMP (f a, f b)
  | RET ops -> RET (List.map ~f ops)
  | CALL { fn; results; args } ->
    let map_result r =
      match f (Reg r) with
      | Reg r' -> r'
      | _ -> failwith "expected reg operand when mapping CALL results"
    in
    CALL
      { fn; results = List.map results ~f:map_result; args = List.map args ~f }
  | PUSH op -> PUSH (f op)
  | POP reg ->
    (match f (Reg reg) with
     | Reg reg' -> POP reg'
     | _ -> failwith "expected reg operand when mapping POP")
  | JE _ | JNE _ | JMP _ | NOOP | LABEL _ -> t
;;

let rec map_call_blocks t ~f =
  match t with
  | Save_clobbers -> Save_clobbers
  | Restore_clobbers -> Restore_clobbers
  | MFENCE -> MFENCE
  | Tag_def (ins, r) -> Tag_def (map_call_blocks ins ~f, r)
  | Tag_use (ins, r) -> Tag_use (map_call_blocks ins ~f, r)
  | JE (lbl, next) -> JE (f lbl, Option.map next ~f)
  | JNE (lbl, next) -> JNE (f lbl, Option.map next ~f)
  | JMP lbl -> JMP (f lbl)
  | NOOP -> NOOP
  | AND (a, b) -> AND (a, b)
  | OR (a, b) -> OR (a, b)
  | MOV (a, b) -> MOV (a, b)
  | MOVSD (a, b) -> MOVSD (a, b)
  | MOVQ (a, b) -> MOVQ (a, b)
  | CVTSI2SD (a, b) -> CVTSI2SD (a, b)
  | CVTTSD2SI (a, b) -> CVTTSD2SI (a, b)
  | ADD (a, b) -> ADD (a, b)
  | SUB (a, b) -> SUB (a, b)
  | ADDSD (a, b) -> ADDSD (a, b)
  | SUBSD (a, b) -> SUBSD (a, b)
  | MULSD (a, b) -> MULSD (a, b)
  | DIVSD (a, b) -> DIVSD (a, b)
  | XCHG (a, b) -> XCHG (a, b)
  | LOCK_ADD (a, b) -> LOCK_ADD (a, b)
  | LOCK_SUB (a, b) -> LOCK_SUB (a, b)
  | LOCK_AND (a, b) -> LOCK_AND (a, b)
  | LOCK_OR (a, b) -> LOCK_OR (a, b)
  | LOCK_XOR (a, b) -> LOCK_XOR (a, b)
  | ALLOCA (a, b) -> ALLOCA (a, b)
  | CMP (a, b) -> CMP (a, b)
  | LOCK_CMPXCHG x -> LOCK_CMPXCHG x
  | SETE x -> SETE x
  | SETL x -> SETL x
  | IMUL x -> IMUL x
  | IDIV x -> IDIV x
  | MOD x -> MOD x
  | LABEL x -> LABEL x
  | RET x -> RET x
  | CALL x -> CALL x
  | PUSH x -> PUSH x
  | POP x -> POP x
;;

let rec iter_call_blocks t ~f =
  match t with
  | Save_clobbers | Restore_clobbers | MFENCE -> ()
  | Tag_def (ins, _) | Tag_use (ins, _) -> iter_call_blocks ins ~f
  | JE (lbl, next) ->
    f lbl;
    Option.iter next ~f
  | JNE (lbl, next) ->
    f lbl;
    Option.iter next ~f
  | JMP lbl -> f lbl
  | NOOP
  | AND (_, _)
  | OR (_, _)
  | MOV (_, _)
  | MOVSD (_, _)
  | MOVQ (_, _)
  | CVTSI2SD (_, _)
  | CVTTSD2SI (_, _)
  | SETE _ | SETL _
  | ADD (_, _)
  | SUB (_, _)
  | ADDSD (_, _)
  | SUBSD (_, _)
  | MULSD (_, _)
  | DIVSD (_, _)
  | XCHG (_, _)
  | LOCK_ADD (_, _)
  | LOCK_SUB (_, _)
  | LOCK_AND (_, _)
  | LOCK_OR (_, _)
  | LOCK_XOR (_, _)
  | LOCK_CMPXCHG _ | IMUL _ | IDIV _ | MOD _ | LABEL _
  | CMP (_, _)
  | ALLOCA _ | RET _ | CALL _ | PUSH _ | POP _ -> ()
;;

let rec call_blocks = function
  | Save_clobbers | Restore_clobbers | MFENCE -> []
  | Tag_def (ins, _) | Tag_use (ins, _) -> call_blocks ins
  | JE (lbl, next) | JNE (lbl, next) -> lbl :: Option.to_list next
  | JMP lbl -> [ lbl ]
  | NOOP
  | AND (_, _)
  | OR (_, _)
  | MOV (_, _)
  | MOVSD (_, _)
  | MOVQ (_, _)
  | CVTSI2SD (_, _)
  | CVTTSD2SI (_, _)
  | SETE _ | SETL _
  | ADD (_, _)
  | SUB (_, _)
  | ADDSD (_, _)
  | SUBSD (_, _)
  | MULSD (_, _)
  | DIVSD (_, _)
  | XCHG (_, _)
  | LOCK_ADD (_, _)
  | LOCK_SUB (_, _)
  | LOCK_AND (_, _)
  | LOCK_OR (_, _)
  | LOCK_XOR (_, _)
  | LOCK_CMPXCHG _ | IMUL _ | IDIV _ | MOD _ | LABEL _
  | CMP (_, _)
  | ALLOCA _ | RET _ | CALL _ | PUSH _ | POP _ -> []
;;

let rec is_terminal = function
  | Save_clobbers | Restore_clobbers | MFENCE -> false
  | Tag_def (ins, _) | Tag_use (ins, _) -> is_terminal ins
  | JNE _ | JE _ | RET _ | JMP _ -> true
  | NOOP
  | AND (_, _)
  | OR (_, _)
  | MOV (_, _)
  | MOVSD (_, _)
  | MOVQ (_, _)
  | CVTSI2SD (_, _)
  | CVTTSD2SI (_, _)
  | SETE _ | SETL _
  | ADD (_, _)
  | SUB (_, _)
  | ADDSD (_, _)
  | SUBSD (_, _)
  | MULSD (_, _)
  | DIVSD (_, _)
  | XCHG (_, _)
  | LOCK_ADD (_, _)
  | LOCK_SUB (_, _)
  | LOCK_AND (_, _)
  | LOCK_OR (_, _)
  | LOCK_XOR (_, _)
  | LOCK_CMPXCHG _ | IMUL _ | IDIV _ | LABEL _ | MOD _
  | CMP (_, _)
  | ALLOCA _ | CALL _ | PUSH _ | POP _ -> false
;;
