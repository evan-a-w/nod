open Core

module Reg = struct
  type t =
    | RBP (* frame pointer *)
    | RSP (* stack pointer *)
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
    | Unallocated of Var.t
    | (* [t option] is [Some] if we force a particular reg, [None] if we force any reg *)
      Allocated of Var.t * t option
  [@@deriving sexp, equal, compare, hash, variants]

  let integer_arguments = [ RDI; RSI; RDX; RCX; R8; R9 ]
  let integer_results = [ RDI; RSI; RDX; RCX; R8; R9 ]

  (* let float_arguments = [ XMM0; XMM1; XMM2; XMM3; XMM4; XMM5; XMM6; XMM7 ] *)
  (* let float_results = [] *)
  let num_physical = List.length Variants.descriptions - 2

  let all_physical =
    [| RBP
     ; RSP
     ; RAX
     ; RBX
     ; RCX
     ; RDX
     ; RSI
     ; RDI
     ; R8
     ; R9
     ; R10
     ; R11
     ; R12
     ; R13
     ; R14
     ; R15
    |]
  ;;

  include functor Comparable.Make
  include functor Hashable.Make
end

module Symbol =
  String_id.Make
    (struct
      let module_name = "Symbol"
    end)
    ()

module Jump_target = struct
  type t =
    | Reg of Reg.t
    | Imm of Int64.t
    | Symbol of Symbol.t
end

type operand =
  | Reg of Reg.t
  | Imm of Int64.t
  | Mem of Reg.t * int (* [reg + disp] *)
[@@deriving sexp, equal, compare, hash]

let reg_of_operand_exn = function
  | Reg r -> r
  | _ -> failwith "Not operand reg"
;;

type 'block t =
  | NOOP
  (* Use this tag things for regalloc bs where we mint temp vars and make them allocated to a particular hw reg when we need *)
  | Tag_use of 'block t * operand
  | Tag_def of 'block t * operand
  | AND of operand * operand
  | OR of operand * operand
  | MOV of operand * operand
  | ADD of operand * operand
  | SUB of operand * operand
  | IMUL of operand (* multiply RAX by operand  result RDX:RAX *)
  | IDIV of operand (* divide RDX:RAX by operand  result in RAX, mod in RDX *)
  | MOD of operand (* divide RDX:RAX by operand  result in RDX, quot in RAX *)
  | CALL of
      { fn : string
      ; results : Reg.t list
      ; args : operand list
      }
  | LABEL of string
  | CMP of operand * operand
  | JE of 'block Call_block.t * 'block Call_block.t option
  | JNE of 'block Call_block.t * 'block Call_block.t option
  | JMP of 'block Call_block.t
  | RET of operand
[@@deriving sexp, equal, compare, hash, variants]

let fold_operand op ~f ~init = f init op

let fold_operands ins ~f ~init =
  match ins with
  | Tag_use (_, r) | Tag_def (_, r) -> f init r
  | MOV (dst, src)
  | AND (dst, src)
  | OR (dst, src)
  | ADD (dst, src)
  | SUB (dst, src)
  | CMP (dst, src) ->
    let init = fold_operand dst ~f ~init in
    fold_operand src ~f ~init
  | IMUL op | IDIV op | MOD op | RET op -> fold_operand op ~f ~init
  | CALL { results; args; _ } ->
    let init = List.fold results ~init ~f:(fun acc reg -> f acc (Reg reg)) in
    List.fold args ~init ~f:(fun acc op -> f acc op)
  | NOOP | LABEL _ | JE _ | JNE _ | JMP _ -> init
;;

let map_reg r ~f =
  match r with
  | Reg.Unallocated v | Reg.Allocated (v, _) -> f v
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

let rec map_var_operands ins ~f =
  match ins with
  | Tag_def (ins, r) -> Tag_def (map_var_operands ins ~f, map_var_operand r ~f)
  | Tag_use (ins, r) -> Tag_use (map_var_operands ins ~f, map_var_operand r ~f)
  | AND (dst, src) -> AND (map_var_operand dst ~f, map_var_operand src ~f)
  | OR (dst, src) -> OR (map_var_operand dst ~f, map_var_operand src ~f)
  | MOV (dst, src) -> MOV (map_var_operand dst ~f, map_var_operand src ~f)
  | ADD (dst, src) -> ADD (map_var_operand dst ~f, map_var_operand src ~f)
  | SUB (dst, src) -> SUB (map_var_operand dst ~f, map_var_operand src ~f)
  | IDIV op -> IDIV (map_var_operand op ~f)
  | IMUL op -> IMUL (map_var_operand op ~f)
  | MOD op -> MOD (map_var_operand op ~f)
  | CALL { fn; results; args } ->
    let map_result r =
      match map_var_operand (Reg r) ~f with
      | Reg r' -> r'
      | _ -> failwith "expected reg operand in CALL results"
    in
    CALL
      { fn
      ; results = List.map results ~f:map_result
      ; args = List.map args ~f:(fun op -> map_var_operand op ~f)
      }
  | CMP (a, b) -> CMP (map_var_operand a ~f, map_var_operand b ~f)
  | RET op -> RET (map_var_operand op ~f)
  | NOOP | LABEL _ | JE _ | JNE _ | JMP _ -> ins (* no virtual‑uses *)
;;

let var_of_reg = function
  | Reg.Unallocated v | Allocated (v, _) -> Some v
  | _ -> None
;;

let vars_of_reg = function
  | Reg.Unallocated v | Allocated (v, _) -> Var.Set.singleton v
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
  | Reg.Allocated (v, r) -> Reg.Allocated (f v, r)
  | _ -> r
;;

let map_use_reg r ~f =
  match r with
  | Reg.Unallocated v -> Reg.Unallocated (f v)
  | Reg.Allocated (v, r) -> Reg.Allocated (f v, r)
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

let rec reg_defs ins : Reg.Set.t =
  match ins with
  | Tag_def (ins, r) -> Set.union (regs_of_operand r) (reg_defs ins)
  | Tag_use (ins, _) -> reg_defs ins
  | MOV (dst, _) -> regs_of_operand dst
  | AND (dst, _) | OR (dst, _) | ADD (dst, _) | SUB (dst, _) ->
    regs_of_operand dst
  | IDIV _ | MOD _ | IMUL _ -> Reg.Set.of_list [ Reg.rax; Reg.rdx ]
  | CALL { results; _ } -> Reg.Set.of_list results
  | NOOP | RET _ | CMP _ | LABEL _ | JE _ | JNE _ | JMP _ -> Reg.Set.empty
;;

let rec reg_uses ins : Reg.Set.t =
  match ins with
  | Tag_use (ins, r) -> Set.union (regs_of_operand r) (reg_uses ins)
  | Tag_def (ins, _) -> reg_uses ins
  | IDIV op | MOD op ->
    Set.union (regs_of_operand op) (Reg.Set.of_list [ Reg.rax; Reg.rdx ])
  | IMUL op -> Set.union (regs_of_operand op) (Reg.Set.of_list [ Reg.rax ])
  | MOV (_, src) -> regs_of_operand src
  | ADD (dst, src) | SUB (dst, src) | AND (dst, src) | OR (dst, src) ->
    Set.union (regs_of_operand dst) (regs_of_operand src)
  | CMP (a, b) -> Set.union (regs_of_operand a) (regs_of_operand b)
  | RET op -> regs_of_operand op
  | CALL { args; _ } ->
    List.fold args ~init:Reg.Set.empty ~f:(fun acc op ->
      Set.union acc (regs_of_operand op))
  | NOOP | LABEL _ | JE _ | JNE _ | JMP _ -> Reg.Set.empty
;;

let regs ins = Set.union (reg_defs ins) (reg_uses ins) |> Set.to_list

let vars ins =
  Set.union (reg_defs ins) (reg_uses ins)
  |> Set.filter_map (module Var) ~f:var_of_reg
  |> Set.to_list
;;

let defs ins = reg_defs ins |> Set.filter_map (module Var) ~f:var_of_reg
let uses ins = reg_uses ins |> Set.filter_map (module Var) ~f:var_of_reg

let rec blocks instr =
  match instr with
  | Tag_use (ins, _) | Tag_def (ins, _) -> blocks ins
  | NOOP
  | MOV _
  | ADD _
  | SUB _
  | IMUL _
  | IDIV _
  | MOD _
  | CMP _
  | RET _
  | AND _
  | OR _
  | CALL _
  | LABEL _ -> []
  | JMP lbl -> Call_block.blocks lbl
  | JE (lbl, next) | JNE (lbl, next) ->
    List.concat_map ~f:Call_block.blocks (lbl :: Option.to_list next)
;;

let rec map_blocks (instr : 'a t) ~(f : 'a -> 'b) : 'b t =
  match instr with
  | Tag_def (ins, r) -> Tag_def (map_blocks ins ~f, r)
  | Tag_use (ins, r) -> Tag_use (map_blocks ins ~f, r)
  | LABEL s -> LABEL s
  | AND (x, y) -> AND (x, y)
  | OR (x, y) -> OR (x, y)
  | MOV (x, y) -> MOV (x, y)
  | ADD (x, y) -> ADD (x, y)
  | SUB (x, y) -> SUB (x, y)
  | IMUL x -> IMUL x
  | IDIV x -> IDIV x
  | MOD x -> MOD x
  | CALL call -> CALL call
  | CMP (x, y) -> CMP (x, y)
  | JE (lbl, next) ->
    JE
      ( Call_block.map_blocks ~f lbl
      , Option.map next ~f:(Call_block.map_blocks ~f) )
  | JNE (lbl, next) ->
    JNE
      ( Call_block.map_blocks ~f lbl
      , Option.map next ~f:(Call_block.map_blocks ~f) )
  | JMP lbl -> JMP (Call_block.map_blocks ~f lbl)
  | RET x -> RET x
  | NOOP -> NOOP
;;

let rec filter_map_call_blocks t ~f =
  match t with
  | Tag_use (ins, _) | Tag_def (ins, _) -> filter_map_call_blocks ins ~f
  | NOOP
  | MOV _
  | ADD _
  | SUB _
  | IMUL _
  | IDIV _
  | MOD _
  | CMP _
  | RET _
  | AND _
  | OR _
  | CALL _
  | LABEL _ -> []
  | JMP lbl -> f lbl |> Option.to_list
  | JE (lbl, next) | JNE (lbl, next) ->
    (f lbl |> Option.to_list) @ (Option.bind next ~f |> Option.to_list)
;;

let unreachable = NOOP

let rec map_defs t ~f =
  let map_dst op = map_def_operand op ~f in
  match t with
  | Tag_def (ins, r) -> Tag_def (map_defs ins ~f, map_dst r)
  | Tag_use (ins, r) -> Tag_use (map_defs ins ~f, r)
  | MOV (dst, src) -> MOV (map_dst dst, src)
  | AND (dst, src) -> AND (map_dst dst, src)
  | OR (dst, src) -> OR (map_dst dst, src)
  | ADD (dst, src) -> ADD (map_dst dst, src)
  | SUB (dst, src) -> SUB (map_dst dst, src)
  | CALL { fn; results; args } ->
    CALL { fn; results = List.map results ~f:(fun r -> map_def_reg r ~f); args }
  | NOOP | IDIV _ | MOD _ | LABEL _ | IMUL _
  | CMP (_, _)
  | JE (_, _)
  | JNE (_, _)
  | JMP _ | RET _ -> t
;;

let rec map_uses t ~f =
  let map_op op = map_use_operand op ~f in
  let map_call_block cb = Call_block.map_uses cb ~f in
  match t with
  | Tag_def (ins, r) -> Tag_def (map_uses ins ~f, r)
  | Tag_use (ins, r) -> Tag_use (map_uses ins ~f, map_op r)
  | MOV (dst, src) -> MOV (dst, map_op src)
  | AND (dst, src) -> AND (map_op dst, map_op src)
  | OR (dst, src) -> OR (map_op dst, map_op src)
  | ADD (dst, src) -> ADD (map_op dst, map_op src)
  | SUB (dst, src) -> SUB (map_op dst, map_op src)
  | IMUL op -> IMUL (map_op op)
  | IDIV op -> IDIV (map_op op)
  | MOD op -> MOD (map_op op)
  | CMP (a, b) -> CMP (map_op a, map_op b)
  | RET op -> RET (map_op op)
  | CALL { fn; results; args } ->
    CALL { fn; results; args = List.map args ~f:map_op }
  | JE (lbl, next) -> JE (map_call_block lbl, Option.map next ~f:map_call_block)
  | JNE (lbl, next) ->
    JNE (map_call_block lbl, Option.map next ~f:map_call_block)
  | JMP lbl -> JMP (map_call_block lbl)
  | NOOP | LABEL _ -> t
;;

let rec map_operands t ~f =
  match t with
  | Tag_def (ins, r) -> Tag_def (map_operands ins ~f, f r)
  | Tag_use (ins, r) -> Tag_use (map_operands ins ~f, f r)
  | MOV (dst, src) -> MOV (f dst, f src)
  | AND (dst, src) -> AND (f dst, f src)
  | OR (dst, src) -> OR (f dst, f src)
  | ADD (dst, src) -> ADD (f dst, f src)
  | SUB (dst, src) -> SUB (f dst, f src)
  | IMUL op -> IMUL (f op)
  | IDIV op -> IDIV (f op)
  | MOD op -> MOD (f op)
  | CMP (a, b) -> CMP (f a, f b)
  | RET op -> RET (f op)
  | CALL { fn; results; args } ->
    let map_result r =
      match f (Reg r) with
      | Reg r' -> r'
      | _ -> failwith "expected reg operand when mapping CALL results"
    in
    CALL
      { fn; results = List.map results ~f:map_result; args = List.map args ~f }
  | JE _ | JNE _ | JMP _ | NOOP | LABEL _ -> t
;;

let rec map_call_blocks t ~f =
  match t with
  | Tag_def (ins, r) -> Tag_def (map_call_blocks ins ~f, r)
  | Tag_use (ins, r) -> Tag_use (map_call_blocks ins ~f, r)
  | JE (lbl, next) -> JE (f lbl, Option.map next ~f)
  | JNE (lbl, next) -> JNE (f lbl, Option.map next ~f)
  | JMP lbl -> JMP (f lbl)
  | NOOP
  | AND (_, _)
  | OR (_, _)
  | MOV (_, _)
  | ADD (_, _)
  | SUB (_, _)
  | IMUL _ | IDIV _ | MOD _ | LABEL _
  | CMP (_, _)
  | RET _ | CALL _ -> t
;;

let rec iter_call_blocks t ~f =
  match t with
  | Tag_def (ins, _) | Tag_use (ins, _) -> iter_call_blocks ins ~f
  | JE (lbl, next) ->
    f lbl;
    Option.iter next ~f
  | JNE (lbl, next) ->
    f lbl;
    Option.iter next ~f
  | JMP lbl -> f lbl
  | NOOP
  | AND (_, _)
  | OR (_, _)
  | MOV (_, _)
  | ADD (_, _)
  | SUB (_, _)
  | IMUL _ | IDIV _ | MOD _ | LABEL _
  | CMP (_, _)
  | RET _ | CALL _ -> ()
;;

let rec call_blocks = function
  | Tag_def (ins, _) | Tag_use (ins, _) -> call_blocks ins
  | JE (lbl, next) | JNE (lbl, next) -> lbl :: Option.to_list next
  | JMP lbl -> [ lbl ]
  | NOOP
  | AND (_, _)
  | OR (_, _)
  | MOV (_, _)
  | ADD (_, _)
  | SUB (_, _)
  | IMUL _ | IDIV _ | MOD _ | LABEL _
  | CMP (_, _)
  | RET _ | CALL _ -> []
;;

let map_lit_or_vars t ~f:_ = t

let rec is_terminal = function
  | Tag_def (ins, _) | Tag_use (ins, _) -> is_terminal ins
  | JNE _ | JE _ | RET _ | JMP _ -> true
  | NOOP
  | AND (_, _)
  | OR (_, _)
  | MOV (_, _)
  | ADD (_, _)
  | SUB (_, _)
  | IMUL _ | IDIV _ | LABEL _ | MOD _
  | CMP (_, _)
  | CALL _ -> false
;;
