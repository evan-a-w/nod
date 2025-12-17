open! Core
open! Import

module type S = sig
  module Reg : Reg.S

  module Arch_ir : sig
    type t

    val fn : t -> string option
    val reg_defs : t -> Reg.t list
    val reg_uses : t -> Reg.t list
  end

  val arch_reg_defs : Ir.t -> Reg.t list
  val arch_reg_uses : Ir.t -> Reg.t list
  val on_arch_irs : Ir.t -> f:(Arch_ir.t -> unit) -> unit
  val to_arch_irs : Ir.t -> Arch_ir.t list
end
