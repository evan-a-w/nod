open! Core

type t = Fn_state.t String.Table.t

let create () = String.Table.create ()
let fn_state t name = Hashtbl.find_or_add t name ~default:Fn_state.create
