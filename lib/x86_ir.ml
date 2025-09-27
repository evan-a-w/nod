open Core

module Reg = struct
  type t =
    | Unallocated of Var.t
    | Junk
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

  include functor Comparable.Make
  include functor Hashable.Make
end

type operand =
  | Reg of Reg.t
  | Imm of Int64.t
  | Mem of Reg.t * int (* [reg + disp] *)
[@@deriving sexp, equal, compare, hash]

type 'block t =
  | NOOP
  | AND of operand * operand
  | OR of operand * operand
  | MOV of operand * operand
  | ADD of operand * operand
  | SUB of operand * operand
  | MUL of operand * operand
  | IDIV of operand (* divide RAX by 'a operand  result in RAX, RDX *)
  | LABEL of string
  | CMP of operand * operand
    (* second arg is so we can store info of next block in case it's false

         not actually needed in my code rn *)
  | JE of 'block Call_block.t * 'block Call_block.t option
  | JNE of 'block Call_block.t * 'block Call_block.t option
  | RET of operand
  | PAR_MOV of (operand * operand) list
[@@deriving sexp, equal, compare, hash]

let fold_operand op ~f ~init = f init op

let fold_operands ins ~f ~init =
  match ins with
  | MOV (dst, src)
  | AND (dst, src)
  | OR (dst, src)
  | ADD (dst, src)
  | SUB (dst, src)
  | MUL (dst, src)
  | CMP (dst, src) ->
    let init = fold_operand dst ~f ~init in
    fold_operand src ~f ~init
  | PAR_MOV l -> List.fold l ~init ~f:(fun acc (a, b) -> f (f acc a) b)
  | IDIV op | RET op -> fold_operand op ~f ~init
  | NOOP | LABEL _ | JE _ | JNE _ -> init
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
  | AND (dst, src) -> AND (map_var_operand dst ~f, map_var_operand src ~f)
  | OR (dst, src) -> OR (map_var_operand dst ~f, map_var_operand src ~f)
  | MOV (dst, src) -> MOV (map_var_operand dst ~f, map_var_operand src ~f)
  | ADD (dst, src) -> ADD (map_var_operand dst ~f, map_var_operand src ~f)
  | SUB (dst, src) -> SUB (map_var_operand dst ~f, map_var_operand src ~f)
  | MUL (dst, src) -> MUL (map_var_operand dst ~f, map_var_operand src ~f)
  | IDIV op -> IDIV (map_var_operand op ~f)
  | CMP (a, b) -> CMP (map_var_operand a ~f, map_var_operand b ~f)
  | RET op -> RET (map_var_operand op ~f)
  | PAR_MOV l ->
    PAR_MOV
      (List.map l ~f:(fun (a, b) -> map_var_operand a ~f, map_var_operand b ~f))
  | NOOP | LABEL _ | JE _ | JNE _ -> ins (* no virtual‑uses *)
;;

module type Arg = sig
  type t [@@deriving sexp, equal, compare, hash]

  include Comparable.S with type t := t
  include Hashable.S with type t := t

  val of_string : string -> t
  val to_string : string -> t
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
  | AND (dst, _) | OR (dst, _) | ADD (dst, _) | SUB (dst, _) | MUL (dst, _) ->
    vars_of_operand dst
  | IDIV _ -> Var.Set.empty (* RAX/RDX: real regs *)
  | NOOP | RET _ | CMP _ | LABEL _ | JE _ | JNE _ -> Var.Set.empty
;;

let uses ins : Var.Set.t =
  match ins with
  | PAR_MOV l ->
    List.fold l ~init:Var.Set.empty ~f:(fun acc (_, a) ->
      Set.union acc (vars_of_operand a))
  | MOV (_, src) -> vars_of_operand src
  | ADD (dst, src)
  | SUB (dst, src)
  | MUL (dst, src)
  | AND (dst, src)
  | OR (dst, src) -> Set.union (vars_of_operand dst) (vars_of_operand src)
  | IDIV op -> Set.union (vars_of_operand op) (vars_of_operand (Reg Reg.RAX))
  | CMP (a, b) -> Set.union (vars_of_operand a) (vars_of_operand b)
  | RET op -> vars_of_operand op
  | NOOP | LABEL _ | JE _ | JNE _ -> Var.Set.empty
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
  | AND _
  | OR _
  | PAR_MOV _
  | LABEL _ -> []
  | JE (lbl, next) | JNE (lbl, next) ->
    List.concat_map ~f:Call_block.blocks (lbl :: Option.to_list next)
;;

let map_blocks (instr : 'a t) ~(f : 'a -> 'b) : 'b t =
  match instr with
  | LABEL s -> LABEL s
  | PAR_MOV l -> PAR_MOV l
  | AND (x, y) -> AND (x, y)
  | OR (x, y) -> OR (x, y)
  | MOV (x, y) -> MOV (x, y)
  | ADD (x, y) -> ADD (x, y)
  | SUB (x, y) -> SUB (x, y)
  | MUL (x, y) -> MUL (x, y)
  | IDIV x -> IDIV x
  | CMP (x, y) -> CMP (x, y)
  | JE (lbl, next) ->
    JE
      ( Call_block.map_blocks ~f lbl
      , Option.map next ~f:(Call_block.map_blocks ~f) )
  | JNE (lbl, next) ->
    JNE
      ( Call_block.map_blocks ~f lbl
      , Option.map next ~f:(Call_block.map_blocks ~f) )
  | RET x -> RET x
  | NOOP -> NOOP
;;

let filter_map_call_blocks t ~f =
  match t with
  | NOOP
  | MOV _
  | ADD _
  | SUB _
  | MUL _
  | IDIV _
  | CMP _
  | RET _
  | AND _
  | OR _
  | PAR_MOV _
  | LABEL _ -> []
  | JE (lbl, next) | JNE (lbl, next) ->
    (f lbl |> Option.to_list) @ (Option.bind next ~f |> Option.to_list)
;;

let unreachable = NOOP

let is_terminal = function
  | JNE _ | JE _ | RET _ -> true
  | NOOP
  | AND (_, _)
  | OR (_, _)
  | MOV (_, _)
  | ADD (_, _)
  | SUB (_, _)
  | MUL (_, _)
  | IDIV _ | LABEL _
  | CMP (_, _)
  | PAR_MOV _ -> false
;;
