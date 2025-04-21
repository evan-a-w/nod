open! Core
open! Ir
open! X86_ir

let free_regs =
  [ Reg.RAX; RBX; RCX; RDX; RSI; RDI; R8; R9; R10; R11; R12; R13; R14; R15 ]
;;

module Interval = struct
  module T = struct
    type t =
      { start : int
      ; end_ : int
      ; reg : Reg.t
      }
    [@@deriving sexp, equal, compare, hash]
  end

  include T
  include Comparable.Make (T)
  include Hashable.Make (T)
end

module State = struct
  type t =
    { free_regs : Reg.t list
    ; live_intervals : Interval.Set.t
    ; intervals_by_end_point : Interval.t Int.Map.t
    }
  [@@deriving sexp]
end

let process _instrs = ()
