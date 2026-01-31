open! Core
open! Import
open Ir

module Reg = struct
  include Arm64_reg

  type nonrec t = Typed_var.t Arm64_reg.t [@@deriving sexp, compare, hash, equal]

  module Raw = struct
    include Arm64_reg.Raw

    type nonrec t = Typed_var.t Arm64_reg.Raw.t
    [@@deriving sexp, compare, hash, equal]
  end

  include functor Comparable.Make
end

module Arch_ir = struct
  type t = (Typed_var.t, Block.t) Arm64_ir.t

  let fn (t : t) : string option = Arm64_ir.fn t
  let reg_defs t = Reg.Set.of_list (Arm64_ir.reg_defs t)
  let reg_uses t = Reg.Set.of_list (Arm64_ir.reg_uses t)
end

let on_arch_irs (ir : Ir.t) ~f =
  match ir with
  | Arm64 arm64 -> f arm64
  | Arm64_terminal arm64s -> List.iter arm64s ~f
  | _ -> ()
;;

let to_arch_irs (ir : Ir.t) =
  match ir with
  | Arm64 arm64 -> [ arm64 ]
  | Arm64_terminal arm64s -> arm64s
  | _ -> []
;;

(* CR-soon This should lookup smth *)
let call_conv ~fn:_ = Call_conv.Default

let bytes_for_args ~fn:({ args; call_conv = Default; _ } : Function.t) =
  let gp_args = Arm64_reg.arguments ~call_conv:Default Arm64_reg.Class.I64 in
  Int.max (List.length args - List.length gp_args) 0
;;

let true_terminal (block : Block.t) : (Typed_var.t, Block.t) Arm64_ir.t option =
  match (Block.terminal block).Instr_state.ir with
  | Arm64 terminal -> Some terminal
  | Arm64_terminal terminals -> List.last terminals
  | X86 _ | X86_terminal _ -> None
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
  | Load _
  | Store _
  | Load_field _
  | Store_field _
  | Memcpy _
  | Atomic_load _
  | Atomic_store _
  | Atomic_rmw _
  | Atomic_cmpxchg _
  | Move _
  | Cast _
  | Branch _
  | Return _
  | Unreachable
  | Call _ -> None
;;

let replace_true_terminal ~fn_state (block : Block.t) new_true_terminal =
  let terminal_ir = (Block.terminal block).Instr_state.ir in
  match terminal_ir with
  | Arm64 _terminal ->
    Fn_state.replace_terminal_ir
      fn_state
      ~block
      ~with_:(Arm64 new_true_terminal)
  | Arm64_terminal terminals ->
    Fn_state.replace_terminal_ir
      fn_state
      ~block
      ~with_:
        (Arm64_terminal
           (List.take terminals (List.length terminals - 1) @ [ new_true_terminal ]))
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
  | Branch _ | Return _ | X86 _ | X86_terminal _ | Unreachable -> ()
;;

let ( >> ) f g = Fn.compose g f

include functor Nod_backend_common.Backend_common.M
