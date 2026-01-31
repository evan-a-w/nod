open! Core
open! Import

include Nod_ir.Ir

type nonrec 'a t = (Typed_var.t, 'a) t [@@deriving sexp, compare, equal, hash]

module Branch = Nod_ir.Branch
module Call_block = Nod_ir.Call_block
module Mem = Nod_ir.Mem
module Lit_or_var = Nod_ir.Lit_or_var
