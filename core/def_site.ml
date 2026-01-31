open! Core

type t =
  | Block_arg of
      { block_id : string
      ; arg : int
      }
  | Instr of Instr_id.t
  | Undefined
