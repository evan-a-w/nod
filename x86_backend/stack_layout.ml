open! Core
open! Import
include Common.Stack_layout

module External = struct
  include External

  let of_function ~num_results (fn : Function.t) =
    let () = Breadcrumbs.add_typed_function_args in
    let gp_arg_regs = Reg.arguments ~call_conv:fn.call_conv Reg.Class.I64 in
    let reg_args = List.take gp_arg_regs (List.length fn.args) in
    let stack_args = List.length fn.args - List.length reg_args in
    let gp_result_regs = Reg.results ~call_conv:fn.call_conv Reg.Class.I64 in
    let reg_results = List.take gp_result_regs num_results in
    let stack_results = num_results - List.length reg_results in
    { reg_args; stack_args; reg_results; stack_results }
  ;;
end
