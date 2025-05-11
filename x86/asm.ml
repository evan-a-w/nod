open! Core

module Reg = struct
  type t =
    (* 64-bit general-purpose *)
    | RAX
    | RBX
    | RCX
    | RDX
    | RSI
    | RDI
    | RBP
    | RSP
    | R8
    | R9
    | R10
    | R11
    | R12
    | R13
    | R14
    | R15
    (* 32-bit general-purpose *)
    | EAX
    | EBX
    | ECX
    | EDX
    | ESI
    | EDI
    | EBP
    | ESP
    | R8D
    | R9D
    | R10D
    | R11D
    | R12D
    | R13D
    | R14D
    | R15D
    (* 16-bit general-purpose *)
    | AX
    | BX
    | CX
    | DX
    | SI
    | DI
    | BP
    | SP
    | R8W
    | R9W
    | R10W
    | R11W
    | R12W
    | R13W
    | R14W
    | R15W
    (* 8-bit low and high halves *)
    | AL
    | BL
    | CL
    | DL
    | AH
    | BH
    | CH
    | DH
    | SIL
    | DIL
    | BPL
    | SPL
    | R8B
    | R9B
    | R10B
    | R11B
    | R12B
    | R13B
    | R14B
    | R15B
    (* SIMD / floating-point registers *)
    | XMM0
    | XMM1
    | XMM2
    | XMM3
    | XMM4
    | XMM5
    | XMM6
    | XMM7
    | XMM8
    | XMM9
    | XMM10
    | XMM11
    | XMM12
    | XMM13
    | XMM14
    | XMM15
    (* Segment registers *)
    | CS
    | DS
    | ES
    | FS
    | GS
    | SS
  [@@deriving sexp, compare, hash, variants]
end

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
