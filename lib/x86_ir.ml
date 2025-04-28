open Core

module T = struct
  module Reg = struct
    type 'a t =
      | Unallocated of 'a
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
    [@@deriving sexp, equal, compare, hash, variants]
  end

  type 'a operand =
    | Reg of 'a Reg.t
    | Imm of Int64.t
    | Mem of 'a Reg.t * int (* [reg + disp] *)
  [@@deriving sexp, equal, compare, hash]

  type ('a, 'block) instr =
    | NOOP
    | MOV of 'a operand * 'a operand
    | ADD of 'a operand * 'a operand
    | SUB of 'a operand * 'a operand
    | MUL of 'a operand * 'a operand
    | IDIV of 'a operand (* divide RAX by 'a operand  result in RAX, RDX *)
    | LABEL of 'block
    | LABEL_NOT_BLOCK of string
    | JMP of 'block
    | CMP of 'a operand * 'a operand
      (* second arg is so we can store info of next block in case it's false

         not actually needed in my code rn *)
    | JE of 'block * 'block option
    | JNE of 'block * 'block option
    | RET of 'a operand
    | PAR_MOV of ('a operand * 'a operand) list
  [@@deriving sexp, equal, compare, hash]

  let fold_operand op ~f ~init = f init op

  let fold_operands ins ~f ~init =
    match ins with
    | MOV (dst, src)
    | ADD (dst, src)
    | SUB (dst, src)
    | MUL (dst, src)
    | CMP (dst, src) ->
      let init = fold_operand dst ~f ~init in
      fold_operand src ~f ~init
    | PAR_MOV l -> List.fold l ~init ~f:(fun acc (a, b) -> f (f acc a) b)
    | IDIV op | RET op -> fold_operand op ~f ~init
    | NOOP | LABEL _ | JMP _ | JE _ | JNE _ | LABEL_NOT_BLOCK _ -> init
  ;;

  let map_reg r ~f =
    match r with
    | Reg.Unallocated v -> f v
    | _ -> Reg r
  ;;

  let map_var_operand op ~f =
    match op with
    | Reg r -> map_reg r ~f
    | Imm _ -> op
    | Mem (r, disp) ->
      (match map_reg r ~f with
       | Reg r -> Mem (r, disp)
       | _ -> failwith "expected reg, got non reg, in [map_var_operand]")
  ;;

  let map_var_operands ins ~f =
    match ins with
    | MOV (dst, src) -> MOV (map_var_operand dst ~f, map_var_operand src ~f)
    | ADD (dst, src) -> ADD (map_var_operand dst ~f, map_var_operand src ~f)
    | SUB (dst, src) -> SUB (map_var_operand dst ~f, map_var_operand src ~f)
    | MUL (dst, src) -> MUL (map_var_operand dst ~f, map_var_operand src ~f)
    | IDIV op -> IDIV (map_var_operand op ~f)
    | CMP (a, b) -> CMP (map_var_operand a ~f, map_var_operand b ~f)
    | RET op -> RET (map_var_operand op ~f)
    | PAR_MOV l ->
      PAR_MOV
        (List.map l ~f:(fun (a, b) ->
           map_var_operand a ~f, map_var_operand b ~f))
    | NOOP | LABEL _ | JMP _ | JE _ | JNE _ | LABEL_NOT_BLOCK _ ->
      ins (* no virtual‑uses *)
  ;;
end

include T

module type Arg = sig
  type t [@@deriving sexp, equal, compare, hash]

  include Comparable.S with type t := t
  include Hashable.S with type t := t
end

module Make (Var : Arg) = struct
  include T
  module Var = Var

  type 'block t' = (Var.t, 'block) instr [@@deriving sexp, equal, compare, hash]

  module rec Instr : (Instr_m.S_plain with type t = Block.t t') = struct
    type t = Block.t t' [@@deriving sexp, compare, hash]
  end

  and Block : (Block_m.S with type instr := Instr.t) = Block_m.Make (Instr)

  module Reg_comparable = struct
    module T = struct
      type t = Var.t Reg.t [@@deriving sexp, compare]
    end

    include T
    include Comparable.Make (T)
  end

  let vars_of_reg = function
    | Reg.Unallocated v -> Var.Set.singleton v
    | _ -> Var.Set.empty
  ;;

  let vars_of_operand = function
    | Reg r -> vars_of_reg r
    | Imm _ -> Var.Set.empty
    | Mem (r, _disp) -> vars_of_reg r
  ;;

  let defs ins : Var.Set.t =
    match ins with
    | PAR_MOV l ->
      List.fold l ~init:Var.Set.empty ~f:(fun acc (a, _) ->
        Set.union acc (vars_of_operand a))
    | MOV (dst, _) -> vars_of_operand dst
    | ADD (dst, _) | SUB (dst, _) | MUL (dst, _) -> vars_of_operand dst
    | IDIV _ -> Var.Set.empty (* RAX/RDX: real regs *)
    | NOOP | RET _ | CMP _ | LABEL _ | JMP _ | JE _ | JNE _ | LABEL_NOT_BLOCK _
      -> Var.Set.empty
  ;;

  let uses ins : Var.Set.t =
    match ins with
    | PAR_MOV l ->
      List.fold l ~init:Var.Set.empty ~f:(fun acc (_, a) ->
        Set.union acc (vars_of_operand a))
    | MOV (_, src) -> vars_of_operand src
    | ADD (dst, src) | SUB (dst, src) | MUL (dst, src) ->
      Set.union (vars_of_operand dst) (vars_of_operand src)
    | IDIV op -> Set.union (vars_of_operand op) (vars_of_operand (Reg Reg.RAX))
    | CMP (a, b) -> Set.union (vars_of_operand a) (vars_of_operand b)
    | RET op -> vars_of_operand op
    | NOOP | LABEL _ | JMP _ | JE _ | JNE _ | LABEL_NOT_BLOCK _ -> Var.Set.empty
  ;;

  let blocks instr =
    match instr with
    | NOOP
    | MOV _
    | ADD _
    | SUB _
    | MUL _
    | IDIV _
    | CMP _
    | RET _
    | PAR_MOV _
    | LABEL_NOT_BLOCK _ -> []
    | LABEL lbl | JMP lbl -> [ lbl ]
    | JE (lbl, next) | JNE (lbl, next) -> lbl :: Option.to_list next
  ;;

  let map_blocks (instr : 'a t') ~(f : 'a -> 'b) : 'b t' =
    match instr with
    | LABEL_NOT_BLOCK s -> LABEL_NOT_BLOCK s
    | PAR_MOV l -> PAR_MOV l
    | MOV (x, y) -> MOV (x, y)
    | ADD (x, y) -> ADD (x, y)
    | SUB (x, y) -> SUB (x, y)
    | MUL (x, y) -> MUL (x, y)
    | IDIV x -> IDIV x
    | LABEL lbl -> LABEL (f lbl)
    | JMP lbl -> JMP (f lbl)
    | CMP (x, y) -> CMP (x, y)
    | JE (lbl, next) -> JE (f lbl, Option.map next ~f)
    | JNE (lbl, next) -> JNE (f lbl, Option.map next ~f)
    | RET x -> RET x
    | NOOP -> NOOP
  ;;

  let unreachable = NOOP
  let jump_to block = JMP block

  let is_terminal = function
    | JMP _ | JNE _ | JE _ | RET _ -> true
    | LABEL_NOT_BLOCK _ | PAR_MOV _ | NOOP
    | MOV (_, _)
    | ADD (_, _)
    | SUB (_, _)
    | MUL (_, _)
    | IDIV _ | LABEL _
    | CMP (_, _) -> false
  ;;
end
