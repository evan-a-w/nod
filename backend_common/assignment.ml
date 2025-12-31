open! Core
open! Import

module M (Reg : Reg.S) = struct
  type t =
    | Spill
    | Reg of Reg.t
  [@@deriving sexp, compare, hash, variants, equal]
end
