open! Core
include Ir0
module Block = Block
module Call_block = Call_block

type nonrec t = Block.t t [@@deriving sexp, compare, equal, hash]

let add_block_args =
  let on_call_block { Call_block.block; args = _ } =
    { Call_block.block; args = Vec.to_list block.Block.args }
  in
  function
  | ( Add _
    | And _
    | Or _
    | Mul _
    | Div _
    | Alloca _
    | Load _
    | Store _
    | Mod _
    | Sub _
    | Move _
    | Call _
    | Unreachable
    | Noop
    | Return _ ) as t -> t
  | X86 x86_ir -> X86 (X86_ir.map_call_blocks x86_ir ~f:on_call_block)
  | X86_terminal x86_irs ->
    X86_terminal (List.map ~f:(X86_ir.map_call_blocks ~f:on_call_block) x86_irs)
  | Branch (Branch.Cond { cond; if_true; if_false }) ->
    Branch
      (Branch.Cond
         { cond
         ; if_true = on_call_block if_true
         ; if_false = on_call_block if_false
         })
  | Branch (Branch.Uncond call) -> Branch (Branch.Uncond (on_call_block call))
;;

let remove_block_args =
  let on_call_block (call_block : Block.t Call_block.t) =
    { call_block with args = [] }
  in
  function
  | ( Add _
    | And _
    | Or _
    | Mul _
    | Div _
    | Alloca _
    | Load _
    | Store _
    | Mod _
    | Sub _
    | Move _
    | Call _
    | Unreachable
    | Noop
    | Return _ ) as t -> t
  | X86 x86_ir -> X86 (X86_ir.map_call_blocks x86_ir ~f:on_call_block)
  | X86_terminal x86_irs ->
    X86_terminal (List.map ~f:(X86_ir.map_call_blocks ~f:on_call_block) x86_irs)
  | Branch (Branch.Cond { cond; if_true; if_false }) ->
    Branch
      (Branch.Cond
         { cond
         ; if_true = on_call_block if_true
         ; if_false = on_call_block if_false
         })
  | Branch (Branch.Uncond call) -> Branch (Branch.Uncond (on_call_block call))
;;

let iter_blocks_and_args t ~f =
  iter_call_blocks t ~f:(fun { block; args } ->
    f ~block:block.Block.id_hum ~args)
;;

include functor Hashable.Make
include functor Comparable.Make
