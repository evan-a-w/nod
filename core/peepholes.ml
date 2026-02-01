open! Core
open! Import
module Ir = Nod_ir.Ir
module Lit_or_var = Nod_ir.Lit_or_var

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

let simplify1 ~value ~ir =
  let open Ir in
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
  | Ir.Mod { src1; src2; _ }
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

let simplify ~value ~ir = simplify1 ~value ~ir
