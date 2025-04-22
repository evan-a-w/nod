open Core
open Ir

module Reg = struct
  module T = struct
    type t =
      | Unallocated of Var.t
      | RBP
      | RSP
      | RAX
      | RBX
      | RCX
      | RDX
      | RSI
      | RDI
      | R8
      | R9
      | R10
      | R11
      | R12
      | R13
      | R14
      | R15
    [@@deriving sexp, equal, compare, hash]
  end

  include T
  include Comparable.Make (T)
  include Hashable.Make (T)
end

type operand =
  | Reg of Reg.t
  | Imm of Int64.t
  | Mem of Reg.t * int (* [reg + disp] *)
[@@deriving sexp, equal, compare, hash]

type t =
  | MOV of operand * operand
  | ADD of operand * operand
  | SUB of operand * operand
  | MUL of operand * operand
  | IDIV of operand (* divide RAX by operand, result in RAX, RDX *)
  | LABEL of string
  | JMP of string
  | CMP of operand * operand
  | JE of string
  | JNE of string
  | RET of operand
[@@deriving sexp, equal, compare, hash]

let vars_of_reg = function
  | Reg.Unallocated v -> Var.Set.singleton v
  | _ -> Var.Set.empty
;;

let vars_of_operand = function
  | Reg r -> vars_of_reg r
  | Imm _ -> Var.Set.empty
  | Mem (r, _disp) -> vars_of_reg r
;;

let map_reg r ~f =
  match r with
  | Reg.Unallocated v -> Reg.Unallocated (f v)
  | _ -> r
;;

let map_operand op ~f =
  match op with
  | Reg r -> Reg (map_reg r ~f)
  | Imm _ -> op
  | Mem (r, disp) -> Mem (map_reg r ~f, disp)
;;

let defs (ins : t) : Var.Set.t =
  match ins with
  | MOV (dst, _) -> vars_of_operand dst
  | ADD (dst, _) | SUB (dst, _) | MUL (dst, _) -> vars_of_operand dst
  | IDIV _ -> Var.Set.empty (* RAX/RDX: real regs *)
  | RET _ | CMP _ | LABEL _ | JMP _ | JE _ | JNE _ -> Var.Set.empty
;;

let uses (ins : t) : Var.Set.t =
  match ins with
  | MOV (_, src) -> vars_of_operand src
  | ADD (dst, src) | SUB (dst, src) | MUL (dst, src) ->
    Set.union (vars_of_operand dst) (vars_of_operand src)
  | IDIV op -> Set.union (vars_of_operand op) (vars_of_operand (Reg Reg.RAX))
  | CMP (a, b) -> Set.union (vars_of_operand a) (vars_of_operand b)
  | RET op -> vars_of_operand op
  | LABEL _ | JMP _ | JE _ | JNE _ -> Var.Set.empty
;;

let map_defs (ins : t) ~(f : Var.t -> Var.t) : t =
  match ins with
  | MOV (dst, src) -> MOV (map_operand dst ~f, src)
  | ADD (dst, src) -> ADD (map_operand dst ~f, src)
  | SUB (dst, src) -> SUB (map_operand dst ~f, src)
  | MUL (dst, src) -> MUL (map_operand dst ~f, src)
  | IDIV _ | LABEL _ | JMP _ | CMP (_, _) | JE _ | JNE _ | RET _ ->
    ins (* no virtual‑defs *)
;;

let map_uses (ins : t) ~(f : Var.t -> Var.t) : t =
  match ins with
  | MOV (dst, src) -> MOV (dst, map_operand src ~f)
  | ADD (dst, src) -> ADD (map_operand dst ~f, map_operand src ~f)
  | SUB (dst, src) -> SUB (map_operand dst ~f, map_operand src ~f)
  | MUL (dst, src) -> MUL (map_operand dst ~f, map_operand src ~f)
  | IDIV op -> IDIV (map_operand op ~f)
  | CMP (a, b) -> CMP (map_operand a ~f, map_operand b ~f)
  | RET op -> RET (map_operand op ~f)
  | LABEL _ | JMP _ | JE _ | JNE _ -> ins (* no virtual‑uses *)
;;
