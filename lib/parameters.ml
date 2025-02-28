open! Core

module type S = sig
  module Instr : Instr.S
end
