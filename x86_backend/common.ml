open! Core
open! Import
module Reg = X86_reg

module Arch_ir = struct
  type t = Block.t X86_ir.t

  let fn (t : t) : string option = X86_ir.fn t
  let reg_defs t = X86_ir.reg_defs t
  let reg_uses t = X86_ir.reg_uses t
end

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

let true_terminal (x86_block : Block.t) : Block.t X86_ir.t option =
  match x86_block.terminal with
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
  | Move (_, _)
  | Cast (_, _)
  | Branch _ | Return _ | Unreachable | Call _ -> None
;;

let replace_true_terminal (x86_block : Block.t) new_true_terminal =
  match x86_block.terminal with
  | X86 _terminal -> x86_block.terminal <- X86 new_true_terminal
  | X86_terminal terminals ->
    x86_block.terminal
    <- X86_terminal
         (List.take terminals (List.length terminals - 1)
          @ [ new_true_terminal ])
  | Arm64 _ | Arm64_terminal _ -> ()
  | Noop
  | And _
  | Or _
  | Add _
  | Sub _
  | Mul _
  | Div _
  | Mod _
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
  | Move (_, _)
  | Cast (_, _)
  | Branch _ | Return _ | Unreachable | Call _ -> ()
;;

let ( >> ) f g = Fn.compose g f

include functor Nod_backend_common.Backend_common.M
