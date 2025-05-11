open! Core

module Mem = struct
  (* segment:offset(base, index, scale) *)
  type t =
    { base : Reg.t option
    ; index : (Reg.t * int64) option
    ; offset : [ `Imm of int64 | `Label of Label.t ]
    ; seg : Reg.t option
    }
  [@@deriving sexp, compare, hash]
end

module Operand = struct
  module Kind = struct
    type t =
      | Reg
      | Imm
      | Mem
    [@@deriving sexp, compare, hash, variants]
  end

  type t =
    | Reg of Reg.t
    | Imm of int64
    | Mem of Mem.t
  [@@deriving sexp, compare, hash, variants]

  let kind = function
    | Reg _ -> Kind.reg
    | Imm _ -> Kind.imm
    | Mem _ -> Kind.mem
  ;;
end

module Condition_code = struct
  type t =
    | O (* overflow set          → JO / JNO *)
    | NO (* overflow clear        → JNO / JO  *)
    | B (* unsigned below        → JB / JNB  *)
    | NB (* unsigned not below    → JNB / JB  *)
    | Z (* zero / equal          → JE / JNE  *)
    | NZ (* not zero / not equal  → JNE / JE  *)
    | S (* sign / negative       → JS / JNS  *)
    | NS (* not sign / non-neg    → JNS / JS  *)
    | P (* parity even           → JP / JNP  *)
    | NP (* parity odd            → JNP / JP  *)
    | L (* signed less           → JL / JGE  *)
    | GE (* signed ≥              → JGE / JL  *)
    | LE (* signed ≤              → JLE / JG  *)
    | G (* signed greater        → JG / JLE *)
  [@@deriving sexp, compare, hash, variants]
end

type t =
  | Nullary of Mnemonic.t
  | Unary of Mnemonic.t * Operand.t
  | Binary of Mnemonic.t * Operand.t * Operand.t
  | N_ary of Mnemonic.t * Operand.t list
  | Call of Label.t
  | Jmp of Label.t
  | Cmp of Operand.t * Operand.t
  | Branch of Condition_code.t * Label.t * Label.t
[@@deriving sexp, compare, hash]

type instr = t

module Instruction_kind = struct
  module T = struct
    type t = Operand.Kind.t list [@@deriving sexp, compare]
  end

  include T
  include Comparable.Make (T)
end

let mnemonic_and_instruction_kind
  : t -> (Mnemonic.t * Instruction_kind.t) option
  = function
  | Nullary m -> Some (m, [])
  | Unary (m, a) -> Some (m, [ Operand.kind a ])
  | Binary (m, a, b) -> Some (m, [ Operand.kind a; Operand.kind b ])
  | N_ary (m, l) -> Some (m, List.map ~f:Operand.kind l)
  | Call _ | Jmp _ | Cmp _ | Branch _ -> None
;;

module Classification = struct
  type t = Instruction_kind.Set.t [@@deriving sexp, compare]

  module Config = struct
    type nonrec t =
      | Any
      | Allowed of t Mnemonic.Map.t
      | Not_allowed of t Mnemonic.Map.t

    let is_allowed t instr =
      match t, mnemonic_and_instruction_kind instr with
      | Any, _ | _, None -> true
      | Allowed map, Some (mnemonic, kind) ->
        Set.mem
          (Map.find map mnemonic
           |> Option.value ~default:Instruction_kind.Set.empty)
          kind
      | Not_allowed map, Some (mnemonic, kind) ->
        Set.mem
          (Map.find map mnemonic
           |> Option.value ~default:Instruction_kind.Set.empty)
          kind
        |> not
    ;;
  end
end
