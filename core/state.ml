open! Core

type t = Ssa_state.t String.Table.t

let by_function : t = String.Table.create ()
let by_block : Ssa_state.t Block.Table.t = Block.Table.create ()

let reset () =
  Hashtbl.clear by_function;
  Hashtbl.clear by_block
;;

let ensure_function name =
  Hashtbl.find_or_add by_function name ~default:Ssa_state.create
;;

let register_function name state =
  Hashtbl.set by_function ~key:name ~data:state
;;

let register_block ~block ~state =
  Hashtbl.set by_block ~key:block ~data:state;
  Ssa_state.register_instr state block.Block.terminal
;;

let state_for_function name = Hashtbl.find_exn by_function name
let state_for_block block = Hashtbl.find_exn by_block block

let table () = by_function
