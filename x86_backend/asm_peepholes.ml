open! Core
open! Import
module Asm = X86_asm

(* Architecture-specific peephole optimizations for x86_64.
   These run after register allocation on concrete assembly instructions. *)

let equal_operand = Asm.equal_operand

(* Check if two instructions are the same *)
let equal_instr = Asm.equal_instr

(* Peephole patterns for x86_64 assembly *)

(* Pattern: mov dst, src; mov src, dst -> mov dst, src *)
let eliminate_redundant_move_pair items =
  match items with
  | Asm.Instr (Mov (dst1, src1)) :: Asm.Instr (Mov (dst2, src2)) :: rest
    when equal_operand dst1 src2 && equal_operand src1 dst2 ->
    Some (Asm.Instr (Mov (dst1, src1)) :: rest)
  | _ -> None
;;

(* Pattern: mov dst, src where dst = src -> eliminated *)
let eliminate_nop_move items =
  match items with
  | Asm.Instr (Mov (dst, src)) :: rest when equal_operand dst src ->
    Some rest
  | _ -> None
;;

(* Pattern: push r; pop r -> eliminated *)
let eliminate_push_pop_same items =
  match items with
  | Asm.Instr (Push (Reg r1)) :: Asm.Instr (Pop r2) :: rest
    when Asm.equal_reg r1 r2 -> Some rest
  | _ -> None
;;

(* Pattern: add dst, 0 -> eliminated *)
let eliminate_add_zero items =
  match items with
  | Asm.Instr (Add (_, Imm 0L)) :: rest -> Some rest
  | _ -> None
;;

(* Pattern: sub dst, 0 -> eliminated *)
let eliminate_sub_zero items =
  match items with
  | Asm.Instr (Sub (_, Imm 0L)) :: rest -> Some rest
  | _ -> None
;;

(* Pattern: and dst, -1 -> eliminated (all bits set) *)
let eliminate_and_all_ones items =
  match items with
  | Asm.Instr (And (_, Imm (-1L))) :: rest -> Some rest
  | _ -> None
;;

(* Pattern: or dst, 0 -> eliminated *)
let eliminate_or_zero items =
  match items with
  | Asm.Instr (Or (_, Imm 0L)) :: rest -> Some rest
  | _ -> None
;;

(* Pattern: mov dst, src1; op dst, src2 -> op dst, src2 if dst was dead before *)
(* This is conservative - we only apply when dst appears in src2 position of the op *)
let fold_move_into_binop items =
  match items with
  | Asm.Instr (Mov (dst1, src1)) :: Asm.Instr (Add (dst2, src2)) :: rest
    when equal_operand dst1 dst2 && equal_operand dst1 src2 ->
    Some (Asm.Instr (Add (dst2, src1)) :: rest)
  | Asm.Instr (Mov (dst1, src1)) :: Asm.Instr (Sub (dst2, src2)) :: rest
    when equal_operand dst1 dst2 && equal_operand dst1 src2 ->
    Some (Asm.Instr (Sub (dst2, src1)) :: rest)
  | _ -> None
;;

(* Pattern: jmp L1; L1: -> L1: (eliminate jump to next instruction) *)
let eliminate_jump_to_next items =
  match items with
  | Asm.Instr (Jmp target) :: Asm.Label label :: rest
    when String.equal target label -> Some (Asm.Label label :: rest)
  | _ -> None
;;

(* Pattern: je L1; L1: -> L1: (eliminate conditional jump to next instruction) *)
let eliminate_cond_jump_to_next items =
  match items with
  | Asm.Instr (Je target) :: Asm.Label label :: rest
    when String.equal target label -> Some (Asm.Label label :: rest)
  | Asm.Instr (Jne target) :: Asm.Label label :: rest
    when String.equal target label -> Some (Asm.Label label :: rest)
  | _ -> None
;;

(* Pattern: cmp r, r; setCC dst -> mov dst, 0 or mov dst, 1 depending on condition *)
let simplify_cmp_same_reg items =
  match items with
  | Asm.Instr (Cmp (op1, op2)) :: Asm.Instr (Sete dst) :: rest
    when equal_operand op1 op2 ->
    (* r == r is always true, so sete sets to 1 *)
    Some (Asm.Instr (Mov (dst, Imm 1L)) :: rest)
  | Asm.Instr (Cmp (op1, op2)) :: Asm.Instr (Setl dst) :: rest
    when equal_operand op1 op2 ->
    (* r < r is always false, so setl sets to 0 *)
    Some (Asm.Instr (Mov (dst, Imm 0L)) :: rest)
  | _ -> None
;;

(* Pattern: xor dst, dst -> faster way to zero a register (could use this in codegen but as optimization too) *)
(* This is already pretty optimal but we keep it for documentation *)

(* Pattern: mov dst, 0; test dst, dst -> xor dst, dst (smaller encoding) *)
(* Note: test instruction doesn't exist in our IR, so this is not applicable *)

(* All peephole patterns *)
let patterns =
  [ eliminate_nop_move
  ; eliminate_redundant_move_pair
  ; eliminate_push_pop_same
  ; eliminate_add_zero
  ; eliminate_sub_zero
  ; eliminate_and_all_ones
  ; eliminate_or_zero
  ; fold_move_into_binop
  ; eliminate_jump_to_next
  ; eliminate_cond_jump_to_next
  ; simplify_cmp_same_reg
  ]
;;

(* Apply peephole optimizations to a list of items *)
let rec optimize_pass items =
  match items with
  | [] -> []
  | _ ->
    (* Try each pattern *)
    let rec try_patterns pats =
      match pats with
      | [] -> None
      | pattern :: rest ->
        (match pattern items with
         | Some result -> Some result
         | None -> try_patterns rest)
    in
    (match try_patterns patterns with
     | Some optimized -> optimize_pass optimized
     | None ->
       (match items with
        | [] -> []
        | item :: rest -> item :: optimize_pass rest))
;;

(* Run peephole optimization until fixpoint *)
let optimize ?(max_iterations = 5) items =
  let rec loop iteration prev_items =
    if iteration >= max_iterations
    then prev_items
    else (
      let optimized = optimize_pass prev_items in
      if List.equal Asm.equal_item optimized prev_items
      then optimized
      else loop (iteration + 1) optimized)
  in
  loop 0 items
;;

(* Optimize a function *)
let optimize_function (fn : Asm.fn) = { fn with items = optimize fn.items }

(* Optimize a program *)
let optimize_program (program : Asm.program) = List.map program ~f:optimize_function
;;
