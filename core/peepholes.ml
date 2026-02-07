open! Core
open! Import
module Ir = Nod_ir.Ir
module Lit_or_var = Nod_ir.Lit_or_var
module Mem = Nod_ir.Mem

let literal_of_operand = function
  | Lit_or_var.Lit lit -> Some lit
  | Lit_or_var.Var value -> value.Value_state.opt_tags.constant
  | Lit_or_var.Global _ -> None
;;

let is_const operand value =
  match literal_of_operand operand with
  | Some lit -> Int64.equal lit value
  | None -> false
;;

let operands_equal a b =
  match a, b with
  | Lit_or_var.Var v1, Lit_or_var.Var v2 -> Value_state.equal v1 v2
  | _ -> false
;;

let replace_with_move ~value operand = Some (Ir.Move (value, operand))

let replace_with_zero ~value =
  replace_with_move ~value (Lit_or_var.Lit Int64.zero)
;;

let replace_with_neg ~value operand =
  let zero = Lit_or_var.Lit Int64.zero in
  Some (Ir.Sub { dest = value; src1 = zero; src2 = operand })
;;

let non_zero_constant operand =
  match literal_of_operand operand with
  | Some lit when not (Int64.equal lit Int64.zero) -> Some lit
  | _ -> None
;;

let defining_instruction fn_state (value : Value_state.t) =
  match value.Value_state.def with
  | Def_site.Instr instr_id -> Fn_state.instr fn_state instr_id
  | Def_site.Block_arg _ | Def_site.Undefined -> None
;;

let simplify_operand fn_state operand =
  let rec loop operand visited =
    match operand with
    | Lit_or_var.Lit _ | Lit_or_var.Global _ -> operand, false
    | Lit_or_var.Var value ->
      let id = value.Value_state.id in
      if Set.mem visited id
      then operand, false
      else (
        let visited = Set.add visited id in
        match defining_instruction fn_state value with
        | None -> operand, false
        | Some instr ->
          (match instr.Instr_state.ir with
           | Ir.Move (_, src) ->
             let simplified, _ = loop src visited in
             if Lit_or_var.equal Value_state.equal operand simplified
             then operand, false
             else simplified, true
           | _ -> operand, false))
  in
  loop operand Value_id.Set.empty
;;

let simplify_mem fn_state mem =
  match mem with
  | Mem.Address ({ base; offset } as address) ->
    let base', base_changed = simplify_operand fn_state base in
    (match base' with
     | Lit_or_var.Global global when Int.equal offset 0 ->
       Mem.Global global, true
     | _ ->
       if base_changed
       then Mem.Address { address with base = base' }, true
       else mem, false)
  | _ -> mem, false
;;

let simplify_non_arith ~fn_state ~ir =
  match ir with
  | Ir.Move (dest, operand) ->
    let operand', changed = simplify_operand fn_state operand in
    if changed then Some (Ir.Move (dest, operand')) else None
  | Ir.Load (dest, mem) ->
    let mem', changed = simplify_mem fn_state mem in
    if changed then Some (Ir.Load (dest, mem')) else None
  | Ir.Atomic_load atomic_load ->
    let addr', changed = simplify_mem fn_state atomic_load.addr in
    if changed
    then Some (Ir.Atomic_load { atomic_load with addr = addr' })
    else None
  | Ir.Atomic_rmw atomic_rmw ->
    let addr', changed = simplify_mem fn_state atomic_rmw.addr in
    if changed
    then Some (Ir.Atomic_rmw { atomic_rmw with addr = addr' })
    else None
  | Ir.Atomic_cmpxchg atomic_cmpxchg ->
    let addr', changed = simplify_mem fn_state atomic_cmpxchg.addr in
    if changed
    then Some (Ir.Atomic_cmpxchg { atomic_cmpxchg with addr = addr' })
    else None
  | Ir.Load_field load_field ->
    let base', changed = simplify_operand fn_state load_field.base in
    if changed
    then Some (Ir.Load_field { load_field with base = base' })
    else None
  | _ -> None
;;

let simplify1 ~value ~ir =
  match ir with
  | Ir.Add { src1; src2; _ } when is_const src1 Int64.zero ->
    replace_with_move ~value src2
  | Ir.Add { src1; src2; _ } when is_const src2 Int64.zero ->
    replace_with_move ~value src1
  | Ir.Sub { src1; src2; _ } when operands_equal src1 src2 ->
    replace_with_zero ~value
  | Ir.Sub { src1; src2; _ } when is_const src2 Int64.zero ->
    replace_with_move ~value src1
  | Ir.Mul { src1; src2; _ }
    when is_const src1 Int64.zero || is_const src2 Int64.zero ->
    replace_with_zero ~value
  | Ir.Mul { src1; src2; _ } when is_const src1 Int64.one ->
    replace_with_move ~value src2
  | Ir.Mul { src1; src2; _ } when is_const src2 Int64.one ->
    replace_with_move ~value src1
  | Ir.Mul { src1; src2; _ } when is_const src1 Int64.minus_one ->
    replace_with_neg ~value src2
  | Ir.Mul { src1; src2; _ } when is_const src2 Int64.minus_one ->
    replace_with_neg ~value src1
  | Ir.Div { src1; src2; _ } when is_const src2 Int64.one ->
    replace_with_move ~value src1
  | Ir.Div { src1; src2; _ } when is_const src2 Int64.minus_one ->
    replace_with_neg ~value src1
  | Ir.Div { src1; src2; _ } ->
    (match literal_of_operand src1, non_zero_constant src2 with
     | Some numerator, Some _ when Int64.equal numerator Int64.zero ->
       replace_with_zero ~value
     | _ -> None)
  | Ir.Mod { src1 = _; src2; _ }
    when is_const src2 Int64.one || is_const src2 Int64.minus_one ->
    replace_with_zero ~value
  | Ir.Mod { src1; src2; _ } ->
    (match literal_of_operand src1, non_zero_constant src2 with
     | Some numerator, Some _ when Int64.equal numerator Int64.zero ->
       replace_with_zero ~value
     | _ -> None)
  | Ir.And { src1; src2; _ }
    when is_const src1 Int64.zero || is_const src2 Int64.zero ->
    replace_with_zero ~value
  | Ir.And { src1; src2; _ } when is_const src1 Int64.minus_one ->
    replace_with_move ~value src2
  | Ir.And { src1; src2; _ } when is_const src2 Int64.minus_one ->
    replace_with_move ~value src1
  | Ir.And { src1; src2; _ } when operands_equal src1 src2 ->
    replace_with_move ~value src1
  | Ir.Or { src1; src2; _ } when is_const src1 Int64.zero ->
    replace_with_move ~value src2
  | Ir.Or { src1; src2; _ } when is_const src2 Int64.zero ->
    replace_with_move ~value src1
  | Ir.Or { src1; src2; _ }
    when is_const src1 Int64.minus_one || is_const src2 Int64.minus_one ->
    replace_with_move ~value (Nod_ir.Lit_or_var.Lit Int64.minus_one)
  | Ir.Or { src1; src2; _ } when operands_equal src1 src2 ->
    replace_with_move ~value src1
  | Ir.Lt { src1; src2; _ } when operands_equal src1 src2 ->
    replace_with_zero ~value
  | _ -> None
;;

let simplify ~fn_state ~value ~ir =
  match simplify1 ~value ~ir with
  | Some _ as simplified -> simplified
  | None -> simplify_non_arith ~fn_state ~ir
;;
