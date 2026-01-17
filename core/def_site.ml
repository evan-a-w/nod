open! Core

type t =
  | Block_arg of
      { block : Block.t
      ; arg : int
      }
  | Instr of Instr_id.t
  | Undefined
