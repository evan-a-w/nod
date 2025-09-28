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

let var_of_reg = function
  | Reg.Unallocated v -> Some v
  | _ -> None
;;

let vars_of_reg = function
  | Reg.Unallocated v -> Var.Set.singleton v
  | _ -> Var.Set.empty
;;

let vars_of_operand = function
  | Reg r -> vars_of_reg r
  | Imm _ -> Var.Set.empty
  | Mem (r, _disp) -> vars_of_reg r
;;

let regs_of_operand = function
  | Reg r -> Reg.Set.singleton r
  | Imm _ -> Reg.Set.empty
  | Mem (r, _disp) -> Reg.Set.singleton r
;;

let map_def_reg r ~f =
  match r with
  | Reg.Unallocated v -> Reg.Unallocated (f v)
  | _ -> r
;;

let map_use_reg r ~f =
  match r with
  | Reg.Unallocated v -> Reg.Unallocated (f v)
  | _ -> r
;;

let map_def_operand op ~f =
  match op with
  | Reg r -> Reg (map_def_reg r ~f)
  | Imm _ -> op
  | Mem (r, disp) -> Mem (map_def_reg r ~f, disp)
;;

let map_use_operand op ~f =
  match op with
  | Reg r -> Reg (map_use_reg r ~f)
  | Imm _ -> op
  | Mem (r, disp) -> Mem (map_use_reg r ~f, disp)
;;

let reg_defs ins : Reg.Set.t =
  match ins with
  | PAR_MOV l ->
    List.fold l ~init:Reg.Set.empty ~f:(fun acc (a, _) ->
      Set.union acc (regs_of_operand a))
  | MOV (dst, _) -> regs_of_operand dst
  | AND (dst, _) | OR (dst, _) | ADD (dst, _) | SUB (dst, _) | MUL (dst, _) ->
    regs_of_operand dst
  | IDIV _ -> Reg.Set.of_list [ Reg.rax; Reg.rdx ]
  | NOOP | RET _ | CMP _ | LABEL _ | JE _ | JNE _ -> Reg.Set.empty
;;

let reg_uses ins : Reg.Set.t =
  match ins with
  | IDIV op ->
    Set.union (regs_of_operand op) (Reg.Set.of_list [ Reg.rax; Reg.rdx ])
  | PAR_MOV l ->
    List.fold l ~init:Reg.Set.empty ~f:(fun acc (_, a) ->
      Set.union acc (regs_of_operand a))
  | MOV (_, src) -> regs_of_operand src
  | ADD (dst, src)
  | SUB (dst, src)
  | MUL (dst, src)
  | AND (dst, src)
  | OR (dst, src) -> Set.union (regs_of_operand dst) (regs_of_operand src)
  | CMP (a, b) -> Set.union (regs_of_operand a) (regs_of_operand b)
  | RET op -> regs_of_operand op
  | NOOP | LABEL _ | JE _ | JNE _ -> Reg.Set.empty
;;

let defs ins = reg_defs ins |> Set.filter_map (module Var) ~f:var_of_reg
let uses ins = reg_uses ins |> Set.filter_map (module Var) ~f:var_of_reg

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

let map_defs t ~f =
  let map_dst op = map_def_operand op ~f in
  match t with
  | PAR_MOV l -> PAR_MOV (List.map l ~f:(fun (dst, src) -> map_dst dst, src))
  | MOV (dst, src) -> MOV (map_dst dst, src)
  | AND (dst, src) -> AND (map_dst dst, src)
  | OR (dst, src) -> OR (map_dst dst, src)
  | ADD (dst, src) -> ADD (map_dst dst, src)
  | SUB (dst, src) -> SUB (map_dst dst, src)
  | MUL (dst, src) -> MUL (map_dst dst, src)
  | _ -> t
;;

let map_uses t ~f =
  let map_op op = map_use_operand op ~f in
  let map_call_block cb = Call_block.map_uses cb ~f in
  match t with
  | PAR_MOV l -> PAR_MOV (List.map l ~f:(fun (dst, src) -> dst, map_op src))
  | MOV (dst, src) -> MOV (dst, map_op src)
  | AND (dst, src) -> AND (map_op dst, map_op src)
  | OR (dst, src) -> OR (map_op dst, map_op src)
  | ADD (dst, src) -> ADD (map_op dst, map_op src)
  | SUB (dst, src) -> SUB (map_op dst, map_op src)
  | MUL (dst, src) -> MUL (map_op dst, map_op src)
  | IDIV op -> IDIV (map_op op)
  | CMP (a, b) -> CMP (map_op a, map_op b)
  | RET op -> RET (map_op op)
  | JE (lbl, next) -> JE (map_call_block lbl, Option.map next ~f:map_call_block)
  | JNE (lbl, next) ->
    JNE (map_call_block lbl, Option.map next ~f:map_call_block)
  | _ -> t
;;

let map_call_blocks t ~f =
  match t with
  | JE (lbl, next) -> JE (f lbl, Option.map next ~f)
  | JNE (lbl, next) -> JNE (f lbl, Option.map next ~f)
  | _ -> t
;;

let iter_call_blocks t ~f =
  match t with
  | JE (lbl, next) ->
    f lbl;
    Option.iter next ~f
  | JNE (lbl, next) ->
    f lbl;
    Option.iter next ~f
  | _ -> ()
;;

let call_blocks = function
  | JE (lbl, next) | JNE (lbl, next) -> lbl :: Option.to_list next
  | _ -> []
;;

let map_lit_or_vars t ~f:_ = t

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
