open! Core

module type S = sig
  module Instr : Instr_m.S
end

module type S_with_block = sig
  module Instr : Instr_m.S
  module Block : Block_m.S with type instr := Instr.t
end
