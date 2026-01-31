open! Core
open! Import
open Ir

module Reg = struct
  include X86_reg

  type nonrec t = Typed_var.t X86_reg.t [@@deriving sexp, compare, hash, equal]

  module Raw = struct
    include X86_reg.Raw

    type nonrec t = Typed_var.t X86_reg.Raw.t
    [@@deriving sexp, compare, hash, equal]
  end

  include functor Comparable.Make
end

module Arch_ir = struct
  type t = (Typed_var.t, Block.t) X86_ir.t

  let fn (t : t) : string option = X86_ir.fn t
  let reg_defs t = Reg.Set.of_list (X86_ir.reg_defs t)
  let reg_uses t = Reg.Set.of_list (X86_ir.reg_uses t)
end

let var_ir ir = Nod_ir.Ir.map_vars ir ~f:Value_state.var

let on_arch_irs (ir : Ir.t) ~f =
  match ir with
  | X86 x86 -> f x86
  | X86_terminal x86s -> List.iter x86s ~f
  | _ -> ()
;;

let to_arch_irs (ir : Ir.t) =
  match ir with
  | X86 x86 -> [ x86 ]
  | X86_terminal x86s -> x86s
  | _ -> []
;;

(* CR-soon This should lookup smth *)
let call_conv ~fn:_ = Call_conv.Default

let bytes_for_args ~fn:({ args; call_conv = Default; _ } : Function.t) =
  let gp_args = X86_reg.arguments ~call_conv:Default X86_reg.Class.I64 in
  Int.max (List.length args - List.length gp_args) 0
;;

let true_terminal (x86_block : Block.t) : (Typed_var.t, Block.t) X86_ir.t option
  =
  match var_ir (Block.terminal x86_block).Instr_state.ir with
  | X86 terminal -> Some terminal
  | X86_terminal terminals -> List.last terminals
  | Arm64 _ | Arm64_terminal _ -> None
  | Noop
  | And _
  | Or _
  | Add _
  | Sub _
  | Mul _
  | Div _
  | Mod _
  | Lt _
  | Alloca _
  | Fadd _
  | Fsub _
  | Fmul _
  | Fdiv _
  | Load (_, _)
  | Store (_, _)
  | Load_field _
  | Store_field _
  | Memcpy _
  | Atomic_load _
  | Atomic_store _
  | Atomic_rmw _
  | Atomic_cmpxchg _
  | Move (_, _)
  | Cast (_, _)
  | Branch _ | Return _ | Unreachable | Call _ -> None
;;

let replace_true_terminal ~fn_state (x86_block : Block.t) new_true_terminal =
  let terminal_ir = (Block.terminal x86_block).Instr_state.ir in
  match terminal_ir with
  | X86 _terminal ->
    let with_ir = Fn_state.value_ir fn_state (X86 new_true_terminal) in
    Fn_state.replace_terminal_ir fn_state ~block:x86_block ~with_:with_ir
  | X86_terminal terminals ->
    let new_true_terminal =
      match Fn_state.value_ir fn_state (X86 new_true_terminal) with
      | X86 terminal -> terminal
      | _ -> failwith "expected X86 terminal"
    in
    Fn_state.replace_terminal_ir
      fn_state
      ~block:x86_block
      ~with_:
        (X86_terminal
           (List.take terminals (List.length terminals - 1)
            @ [ new_true_terminal ]))
  | Noop
  | And _
  | Or _
  | Add _
  | Sub _
  | Mul _
  | Div _
  | Mod _
  | Lt _
  | Fadd _
  | Fsub _
  | Fmul _
  | Fdiv _
  | Alloca _
  | Call _
  | Load (_, _)
  | Store (_, _)
  | Load_field _
  | Store_field _
  | Memcpy _
  | Atomic_load _
  | Atomic_store _
  | Atomic_rmw _
  | Atomic_cmpxchg _
  | Move (_, _)
  | Cast (_, _)
  | Branch _ | Return _ | Arm64 _ | Arm64_terminal _ | Unreachable -> ()
;;

let ( >> ) f g = Fn.compose g f

include functor Nod_backend_common.Backend_common.M
