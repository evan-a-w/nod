open! Core
open! Import
module Asm = Arm64_asm
module Reg = Arm64_reg

(* Architecture-specific peephole optimizations for ARM64.
   These run after register allocation on concrete assembly instructions. *)

let equal_operand = Asm.equal_operand
let equal_reg = Asm.equal_reg
let equal_instr = Asm.equal_instr
let is_stack_base reg = equal_reg reg Reg.sp || equal_reg reg Reg.fp

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
  | Asm.Instr (Mov { dst = dst1; src = src1 })
    :: Asm.Instr (Mov { dst = dst2; src = Reg src2_reg })
    :: rest
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

(* Pattern: str src, [stack]; ldr dst, [stack] -> str src, [stack]; mov dst, src *)
let forward_stack_store_load items =
  match items with
  | Asm.Instr (Str { src = Reg src_reg; addr = Mem (base1, disp1) })
    :: Asm.Instr (Ldr { dst; addr = Mem (base2, disp2) })
    :: rest
    when is_stack_base base1 && equal_reg base1 base2 && Int.equal disp1 disp2
    ->
    Some
      (Asm.Instr (Str { src = Reg src_reg; addr = Mem (base1, disp1) })
       :: Asm.Instr (Mov { dst; src = Reg src_reg })
       :: rest)
  | _ -> None
;;

let invert_condition (condition : Arm64_ir.Condition.t) =
  let open Arm64_ir.Condition in
  match condition with
  | Eq -> Ne
  | Ne -> Eq
  | Lt -> Ge
  | Le -> Gt
  | Gt -> Le
  | Ge -> Lt
  | Pl -> Mi
  | Mi -> Pl
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
     | Ne | Lt | Gt -> Some (Asm.Instr (Mov { dst; src = Imm 0L }) :: rest)
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

(* Pattern: b.cond L1; b L2; L1: -> b.!cond L2; L1: *)
let invert_branch_with_fallthrough items =
  match items with
  | Asm.Instr (Bcond { condition; target })
    :: Asm.Instr (B fallthrough)
    :: Asm.Label label
    :: rest
    when String.equal target label ->
    Some
      (Asm.Instr
         (Bcond { condition = invert_condition condition; target = fallthrough })
       :: Asm.Label label
       :: rest)
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

let fold_move_into_int_binop items =
  let fold dst1 src_reg dst2 lhs rhs make rest =
    if equal_reg dst1 dst2
    then
      if equal_reg lhs dst1
      then Some (Asm.Instr (make ~dst:dst2 ~lhs:src_reg ~rhs) :: rest)
      else if equal_reg rhs dst1
      then Some (Asm.Instr (make ~dst:dst2 ~lhs ~rhs:src_reg) :: rest)
      else None
    else None
  in
  match items with
  | Asm.Instr (Mov { dst = dst1; src = Reg src_reg }) :: Asm.Instr instr :: rest
    ->
    (match instr with
     | Add { dst = dst2; lhs; rhs } ->
       fold
         dst1
         src_reg
         dst2
         lhs
         rhs
         (fun ~dst ~lhs ~rhs -> Add { dst; lhs; rhs })
         rest
     | Sub { dst = dst2; lhs; rhs } ->
       fold
         dst1
         src_reg
         dst2
         lhs
         rhs
         (fun ~dst ~lhs ~rhs -> Sub { dst; lhs; rhs })
         rest
     | Mul { dst = dst2; lhs; rhs } ->
       fold
         dst1
         src_reg
         dst2
         lhs
         rhs
         (fun ~dst ~lhs ~rhs -> Mul { dst; lhs; rhs })
         rest
     | Sdiv { dst = dst2; lhs; rhs } ->
       fold
         dst1
         src_reg
         dst2
         lhs
         rhs
         (fun ~dst ~lhs ~rhs -> Sdiv { dst; lhs; rhs })
         rest
     | And { dst = dst2; lhs; rhs } ->
       fold
         dst1
         src_reg
         dst2
         lhs
         rhs
         (fun ~dst ~lhs ~rhs -> And { dst; lhs; rhs })
         rest
     | Orr { dst = dst2; lhs; rhs } ->
       fold
         dst1
         src_reg
         dst2
         lhs
         rhs
         (fun ~dst ~lhs ~rhs -> Orr { dst; lhs; rhs })
         rest
     | Eor { dst = dst2; lhs; rhs } ->
       fold
         dst1
         src_reg
         dst2
         lhs
         rhs
         (fun ~dst ~lhs ~rhs -> Eor { dst; lhs; rhs })
         rest
     | Lsl { dst = dst2; lhs; rhs } ->
       fold
         dst1
         src_reg
         dst2
         lhs
         rhs
         (fun ~dst ~lhs ~rhs -> Lsl { dst; lhs; rhs })
         rest
     | Lsr { dst = dst2; lhs; rhs } ->
       fold
         dst1
         src_reg
         dst2
         lhs
         rhs
         (fun ~dst ~lhs ~rhs -> Lsr { dst; lhs; rhs })
         rest
     | Asr { dst = dst2; lhs; rhs } ->
       fold
         dst1
         src_reg
         dst2
         lhs
         rhs
         (fun ~dst ~lhs ~rhs -> Asr { dst; lhs; rhs })
         rest
     | _ -> None)
  | _ -> None
;;

let fold_move_into_float_binop items =
  let fold dst1 src_reg dst2 lhs rhs make rest =
    if equal_reg dst1 dst2
    then
      if equal_reg lhs dst1
      then Some (Asm.Instr (make ~dst:dst2 ~lhs:src_reg ~rhs) :: rest)
      else if equal_reg rhs dst1
      then Some (Asm.Instr (make ~dst:dst2 ~lhs ~rhs:src_reg) :: rest)
      else None
    else None
  in
  match items with
  | Asm.Instr (Mov { dst = dst1; src = Reg src_reg }) :: Asm.Instr instr :: rest
    ->
    (match instr with
     | Fadd { dst = dst2; lhs; rhs } ->
       fold
         dst1
         src_reg
         dst2
         lhs
         rhs
         (fun ~dst ~lhs ~rhs -> Fadd { dst; lhs; rhs })
         rest
     | Fsub { dst = dst2; lhs; rhs } ->
       fold
         dst1
         src_reg
         dst2
         lhs
         rhs
         (fun ~dst ~lhs ~rhs -> Fsub { dst; lhs; rhs })
         rest
     | Fmul { dst = dst2; lhs; rhs } ->
       fold
         dst1
         src_reg
         dst2
         lhs
         rhs
         (fun ~dst ~lhs ~rhs -> Fmul { dst; lhs; rhs })
         rest
     | Fdiv { dst = dst2; lhs; rhs } ->
       fold
         dst1
         src_reg
         dst2
         lhs
         rhs
         (fun ~dst ~lhs ~rhs -> Fdiv { dst; lhs; rhs })
         rest
     | _ -> None)
  | _ -> None
;;

(* Pattern: mul dst, a, b; sub dst, acc, dst -> msub dst, a, b, acc *)
let combine_mul_sub_to_msub items =
  match items with
  | Asm.Instr (Mul { dst = dst1; lhs; rhs })
    :: Asm.Instr (Sub { dst = dst2; lhs = acc; rhs = rhs2 })
    :: rest
    when equal_reg dst1 dst2 && equal_reg dst1 rhs2 ->
    Some (Asm.Instr (Msub { dst = dst2; lhs; rhs; acc }) :: rest)
  | _ -> None
;;

(* All peephole patterns *)
let patterns =
  [ eliminate_nop_move
  ; eliminate_redundant_move_chain
  ; eliminate_store_load_same
  ; forward_stack_store_load
  ; simplify_sub_same
  ; simplify_orr_same
  ; simplify_and_same
  ; simplify_eor_same
  ; simplify_cmp_same
  ; simplify_fcmp_same
  ; eliminate_branch_to_next
  ; invert_branch_with_fallthrough
  ; eliminate_cond_branch_to_next
  ; fold_move_into_add
  ; fold_move_into_sub
  ; fold_move_into_int_binop
  ; fold_move_into_float_binop
  ; combine_mul_sub_to_msub
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
let optimize_program (program : Asm.program) =
  List.map program ~f:optimize_function
;;

let%test_unit "arm64 peephole: invert branch with fallthrough" =
  let items =
    [ Asm.Instr (Bcond { condition = Arm64_ir.Condition.Eq; target = "L1" })
    ; Asm.Instr (B "L2")
    ; Asm.Label "L1"
    ; Asm.Instr Ret
    ]
  in
  let expected =
    [ Asm.Instr (Bcond { condition = Arm64_ir.Condition.Ne; target = "L2" })
    ; Asm.Label "L1"
    ; Asm.Instr Ret
    ]
  in
  let optimized = optimize items in
  if not (List.equal Asm.equal_item optimized expected)
  then raise_s [%message (optimized : Asm.item list) (expected : Asm.item list)]
;;

let%test_unit "arm64 peephole: forward stack store/load" =
  let addr = Mem (Reg.sp, 8) in
  let items =
    [ Asm.Instr (Str { src = Reg Reg.x1; addr })
    ; Asm.Instr (Ldr { dst = Reg.x2; addr })
    ]
  in
  let expected =
    [ Asm.Instr (Str { src = Reg Reg.x1; addr })
    ; Asm.Instr (Mov { dst = Reg.x2; src = Reg Reg.x1 })
    ]
  in
  let optimized = optimize items in
  if not (List.equal Asm.equal_item optimized expected)
  then raise_s [%message (optimized : Asm.item list) (expected : Asm.item list)]
;;

let%test_unit "arm64 peephole: fold move into add" =
  let items =
    [ Asm.Instr (Mov { dst = Reg.x0; src = Reg Reg.x1 })
    ; Asm.Instr (Add { dst = Reg.x0; lhs = Reg.x0; rhs = Reg.x2 })
    ]
  in
  let expected =
    [ Asm.Instr (Add { dst = Reg.x0; lhs = Reg.x1; rhs = Reg.x2 }) ]
  in
  let optimized = optimize items in
  if not (List.equal Asm.equal_item optimized expected)
  then raise_s [%message (optimized : Asm.item list) (expected : Asm.item list)]
;;

let%test_unit "arm64 peephole: combine mul/sub to msub" =
  let items =
    [ Asm.Instr (Mul { dst = Reg.x0; lhs = Reg.x1; rhs = Reg.x2 })
    ; Asm.Instr (Sub { dst = Reg.x0; lhs = Reg.x3; rhs = Reg.x0 })
    ]
  in
  let expected =
    [ Asm.Instr
        (Msub { dst = Reg.x0; lhs = Reg.x1; rhs = Reg.x2; acc = Reg.x3 })
    ]
  in
  let optimized = optimize items in
  if not (List.equal Asm.equal_item optimized expected)
  then raise_s [%message (optimized : Asm.item list) (expected : Asm.item list)]
;;
