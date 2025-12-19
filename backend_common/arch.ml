open! Core
open! Import

module type S = sig
  module Reg : Reg.S

  module Arch_ir : sig
    type t

    val fn : t -> string option
    val reg_defs : t -> Reg.Set.t
    val reg_uses : t -> Reg.Set.t
  end

  val to_arch_irs : Ir.t -> Arch_ir.t list
end
