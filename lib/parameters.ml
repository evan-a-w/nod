open! Core

module type S = sig
  module Instr : Instr.S
end

module type S_with_block = sig
  module Instr : Instr.S
  module Block : Block.S with type instr := Instr.t
end
