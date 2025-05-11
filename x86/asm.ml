open! Core

module Mem = struct
  (* A full “memory operand”: [base + index*scale + disp] *)
  type t =
    { base : Reg.t option (* e.g. Some RAX or None for “[disp]” *)
    ; index : (Reg.t * int) option (* (index_reg, scale) *)
    ; disp : int64 (* signed displacement *)
    ; seg : Reg.t option (* optional segment override *)
    }
  [@@deriving sexp, compare, hash]
end

module Operand = struct
  (* The union of everything you can stick in an x86 slot: *)
  type t =
    | Reg of Reg.t
    | Imm of int64
    | Mem of Mem.t
  [@@deriving sexp, compare, hash]
end

module Mnemonic = String
module Label = String

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
  | Unary of Mnemonic.t * Operand.t (* e.g. NEG r64 *)
  | Move2 of
      Mnemonic.t * Operand.t * Operand.t (* MOV r64, r/m64 or MOV m64, r64 *)
  | BinReg of Mnemonic.t * Reg.t * Reg.t (* e.g. ADD r64, r64 *)
  | BinImm of Mnemonic.t * Reg.t * int64 (* e.g. ADD r64, imm32 *)
  | BinMem of Mnemonic.t * Mem.t * Reg.t (* e.g. MOV [r64+…], r64 *)
  | LoadMem of Mnemonic.t * Reg.t * Mem.t (* e.g. MOV r64, [r64+…] *)
  | ThreeOp of
      Mnemonic.t
      * Operand.t
      * Operand.t
      * Operand.t (* AVX/VEX: VFMADDPS xmm, xmm, xmm *)
  | Jmp of Label.t
  | Cmp of Operand.t * Operand.t
  | Branch of Condition_code.t * Label.t * Label.t
[@@deriving sexp, compare, hash]
