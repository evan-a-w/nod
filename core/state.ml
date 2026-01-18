open! Core

type t = Ssa_state.t String.Table.t

let create () = String.Table.create ()
let reset t = Hashtbl.clear t

let ensure_function t name =
  Hashtbl.find_or_add t name ~default:Ssa_state.create
;;

let register_function t name state = Hashtbl.set t ~key:name ~data:state
let state_for_function t name = Hashtbl.find_exn t name
let table t = t

let register_block ~block ~state =
  Ssa_state.register_instr state block.Block.terminal
;;
