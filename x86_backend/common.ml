open! Core
open! Import

let new_name map v =
  let v' =
    match Hashtbl.find map v with
    | None -> v
    | Some i -> v ^ Int.to_string i
  in
  Hashtbl.update map v ~f:(function
    | None -> 0
    | Some i -> i + 1);
  v'
;;

let on_x86_irs (ir : Ir.t) ~f =
  match ir with
  | X86 x86 -> f x86
  | X86_terminal x86s -> List.iter x86s ~f
  | _ -> ()
;;

(* CR-soon ewilliams: This should lookup smth *)
let call_conv ~fn:_ = Call_conv.Default

let bytes_for_args ~fn:({ args; call_conv = Default; _ } : Function.t) =
  Int.max (List.length args - List.length Reg.integer_arguments) 0
;;

let true_terminal (x86_block : Block.t) : Block.t X86_ir.t option =
  match x86_block.terminal with
  | X86 terminal -> Some terminal
  | X86_terminal terminals -> List.last terminals
  | Noop | And _ | Or _ | Add _ | Sub _ | Mul _ | Div _ | Mod _ | Alloca _
  | Load (_, _)
  | Store (_, _)
  | Move (_, _)
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
  | Noop | And _ | Or _ | Add _ | Sub _ | Mul _ | Div _ | Mod _ | Alloca _
  | Load (_, _)
  | Store (_, _)
  | Move (_, _)
  | Branch _ | Return _ | Unreachable | Call _ -> ()
;;

let ( >> ) f g = Fn.compose g f
