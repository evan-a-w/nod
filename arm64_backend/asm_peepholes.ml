open! Core
open! Import
module Asm = Arm64_asm

(* Architecture-specific peephole optimizations for ARM64.
   These run after register allocation on concrete assembly instructions. *)

let equal_operand = Asm.equal_operand
let equal_reg = Asm.equal_reg
let equal_instr = Asm.equal_instr

(* Peephole patterns for ARM64 assembly *)

(* Pattern: mov dst, src where dst = src (as register) -> eliminated *)
let eliminate_nop_move items =
  match items with
  | Asm.Instr (Mov { dst; src = Reg src_reg }) :: rest
    when equal_reg dst src_reg -> Some rest
  | _ -> None
;;

(* Pattern: mov dst1, src; mov dst2, (Reg dst1) where dst2 = src -> mov dst1, src *)
let eliminate_redundant_move_chain items =
  match items with
  | Asm.Instr (Mov { dst = dst1; src = src1 }) :: Asm.Instr (Mov { dst = dst2; src = Reg src2_reg }) :: rest
    when equal_reg dst1 src2_reg && equal_operand src1 (Reg dst2) ->
    Some (Asm.Instr (Mov { dst = dst1; src = src1 }) :: rest)
  | _ -> None
;;

(* Pattern: str src, addr; ldr dst, addr where src = dst -> str src, addr *)
(* Conservative: only when addr is the same and no intervening memory ops *)
let eliminate_store_load_same items =
  match items with
  | Asm.Instr (Str { src = Reg src_reg; addr = addr1 })
    :: Asm.Instr (Ldr { dst; addr = addr2 })
    :: rest
    when equal_operand addr1 addr2 && equal_reg src_reg dst ->
    Some (Asm.Instr (Str { src = Reg src_reg; addr = addr1 }) :: rest)
  | _ -> None
;;

(* Pattern: add dst, lhs, rhs where rhs is zero register or #0 -> mov dst, lhs *)
let simplify_add_zero items =
  match items with
  | Asm.Instr (Add { dst; lhs; rhs }) :: rest
    when equal_reg rhs lhs && equal_reg dst lhs ->
    (* add dst, dst, dst is unusual but if it happens, becomes lsl dst, dst, #1
       Actually for now just skip this pattern if dst = lhs = rhs *)
    None
  | Asm.Instr (Add { dst; lhs; rhs = _ }) :: rest
    (* In ARM64, we can't add immediate directly in Add instruction in our IR
       so this pattern is less common *)
    -> None
  | _ -> None
;;

(* Pattern: sub dst, lhs, rhs where rhs = lhs -> mov dst, #0 *)
(* Note: ARM64 doesn't have direct mov immediate in all cases, might need different encoding *)
let simplify_sub_same items =
  match items with
  | Asm.Instr (Sub { dst; lhs; rhs }) :: rest when equal_reg lhs rhs ->
    (* sub dst, r, r -> mov dst, #0 (or eor dst, r, r for zero) *)
    (* Using mov with immediate 0 *)
    Some (Asm.Instr (Mov { dst; src = Imm 0L }) :: rest)
  | _ -> None
;;

(* Pattern: orr dst, lhs, rhs where lhs = rhs -> mov dst, lhs *)
let simplify_orr_same items =
  match items with
  | Asm.Instr (Orr { dst; lhs; rhs }) :: rest when equal_reg lhs rhs ->
    Some (Asm.Instr (Mov { dst; src = Reg lhs }) :: rest)
  | _ -> None
;;

(* Pattern: and dst, lhs, rhs where lhs = rhs -> mov dst, lhs *)
let simplify_and_same items =
  match items with
  | Asm.Instr (And { dst; lhs; rhs }) :: rest when equal_reg lhs rhs ->
    Some (Asm.Instr (Mov { dst; src = Reg lhs }) :: rest)
  | _ -> None
;;

(* Pattern: eor dst, lhs, rhs where lhs = rhs -> mov dst, #0 *)
let simplify_eor_same items =
  match items with
  | Asm.Instr (Eor { dst; lhs; rhs }) :: rest when equal_reg lhs rhs ->
    Some (Asm.Instr (Mov { dst; src = Imm 0L }) :: rest)
  | _ -> None
;;

(* Pattern: cmp lhs, rhs; cset dst, cond where lhs = rhs ->
   mov dst, #1 (for eq) or mov dst, #0 (for ne, lt, etc.) *)
let simplify_cmp_same items =
  match items with
  | Asm.Instr (Cmp { lhs; rhs }) :: Asm.Instr (Cset { dst; condition }) :: rest
    when equal_operand lhs rhs ->
    (match condition with
     | Arm64_ir.Condition.Eq | Ge | Le ->
       (* r == r, r >= r, r <= r are all true *)
       Some (Asm.Instr (Mov { dst; src = Imm 1L }) :: rest)
     | Ne | Lt | Gt ->
       (* r != r, r < r, r > r are all false *)
       Some (Asm.Instr (Mov { dst; src = Imm 0L }) :: rest)
     | Pl | Mi ->
       (* These are sign-based, r is never negative relative to itself *)
       (* pl (positive or zero) would be true, mi (negative) would be false *)
       (match condition with
        | Pl -> Some (Asm.Instr (Mov { dst; src = Imm 1L }) :: rest)
        | Mi -> Some (Asm.Instr (Mov { dst; src = Imm 0L }) :: rest)
        | _ -> None))
  | _ -> None
;;

(* Pattern: fcmp lhs, rhs; cset dst, cond where lhs = rhs -> similar to integer *)
let simplify_fcmp_same items =
  match items with
  | Asm.Instr (Fcmp { lhs; rhs }) :: Asm.Instr (Cset { dst; condition }) :: rest
    when equal_operand lhs rhs ->
    (match condition with
     | Arm64_ir.Condition.Eq | Ge | Le ->
       Some (Asm.Instr (Mov { dst; src = Imm 1L }) :: rest)
     | Ne | Lt | Gt ->
       Some (Asm.Instr (Mov { dst; src = Imm 0L }) :: rest)
     | Pl | Mi -> None (* Not typically used with fcmp *))
  | _ -> None
;;

(* Pattern: b L1; L1: -> L1: (eliminate branch to next instruction) *)
let eliminate_branch_to_next items =
  match items with
  | Asm.Instr (B target) :: Asm.Label label :: rest
    when String.equal target label -> Some (Asm.Label label :: rest)
  | _ -> None
;;

(* Pattern: b.cond L1; L1: -> L1: (eliminate conditional branch to next instruction) *)
let eliminate_cond_branch_to_next items =
  match items with
  | Asm.Instr (Bcond { target; _ }) :: Asm.Label label :: rest
    when String.equal target label -> Some (Asm.Label label :: rest)
  | _ -> None
;;

(* Pattern: mul dst, lhs, rhs where rhs is #1 -> mov dst, lhs *)
(* Note: our IR has mul with registers only, not immediates *)

(* Pattern: lsl dst, lhs, rhs where rhs is #0 -> mov dst, lhs *)
(* Again, our IR uses registers for shifts *)

(* Pattern: mov dst, src1; add dst, dst, src2 -> add dst, src1, src2 *)
let fold_move_into_add items =
  match items with
  | Asm.Instr (Mov { dst = dst1; src = Reg src1 })
    :: Asm.Instr (Add { dst = dst2; lhs; rhs })
    :: rest
    when equal_reg dst1 dst2 && equal_reg dst2 lhs ->
    Some (Asm.Instr (Add { dst = dst2; lhs = src1; rhs }) :: rest)
  | Asm.Instr (Mov { dst = dst1; src = Reg src1 })
    :: Asm.Instr (Add { dst = dst2; lhs; rhs })
    :: rest
    when equal_reg dst1 dst2 && equal_reg dst2 rhs ->
    Some (Asm.Instr (Add { dst = dst2; lhs; rhs = src1 }) :: rest)
  | _ -> None
;;

(* Pattern: mov dst, src1; sub dst, dst, src2 -> sub dst, src1, src2 *)
let fold_move_into_sub items =
  match items with
  | Asm.Instr (Mov { dst = dst1; src = Reg src1 })
    :: Asm.Instr (Sub { dst = dst2; lhs; rhs })
    :: rest
    when equal_reg dst1 dst2 && equal_reg dst2 lhs ->
    Some (Asm.Instr (Sub { dst = dst2; lhs = src1; rhs }) :: rest)
  | _ -> None
;;

(* All peephole patterns *)
let patterns =
  [ eliminate_nop_move
  ; eliminate_redundant_move_chain
  ; eliminate_store_load_same
  ; simplify_sub_same
  ; simplify_orr_same
  ; simplify_and_same
  ; simplify_eor_same
  ; simplify_cmp_same
  ; simplify_fcmp_same
  ; eliminate_branch_to_next
  ; eliminate_cond_branch_to_next
  ; fold_move_into_add
  ; fold_move_into_sub
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
