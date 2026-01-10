open! Core
open! Import
module Reg = Arm64_reg
module Raw = Arm64_reg.Raw

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
    | Label of string
  [@@deriving sexp, equal, compare, hash]
end

module Condition = struct
  type t =
    | Eq
    | Ne
    | Lt
    | Le
    | Gt
    | Ge
    | Pl
    | Mi
  [@@deriving sexp, equal, compare, hash, enumerate]
end

module Int_op = struct
  type t =
    | Add
    | Sub
    | Mul
    | Sdiv
    | Smod
    | And
    | Orr
    | Eor
    | Lsl
    | Lsr
    | Asr
  [@@deriving sexp, equal, compare, hash, enumerate]
end

module Float_op = struct
  type t =
    | Fadd
    | Fsub
    | Fmul
    | Fdiv
  [@@deriving sexp, equal, compare, hash, enumerate]
end

module Convert_op = struct
  type t =
    | Int_to_float
    | Float_to_int
  [@@deriving sexp, equal, compare, hash, enumerate]
end

module Comp_kind = struct
  type t =
    | Int
    | Float
  [@@deriving sexp, equal, compare, hash, enumerate]
end

type operand =
  | Reg of Reg.t
  | Imm of Int64.t
  | Mem of Reg.t * int (* [reg + offset] addressing *)
  | Spill_slot of int
[@@deriving sexp, equal, compare, hash]

let reg_of_operand_exn = function
  | Reg r -> r
  | _ -> failwith "operand is not a register"
;;

type 'block t =
  | Nop
  | Tag_use of 'block t * operand
  | Tag_def of 'block t * operand
  | Move of
      { dst : Reg.t
      ; src : operand
      }
  | Load of
      { dst : Reg.t
      ; addr : operand
      }
  | Store of
      { src : operand
      ; addr : operand
      }
  | Int_binary of
      { op : Int_op.t
      ; dst : Reg.t
      ; lhs : operand
      ; rhs : operand
      }
  | Float_binary of
      { op : Float_op.t
      ; dst : Reg.t
      ; lhs : operand
      ; rhs : operand
      }
  | Convert of
      { op : Convert_op.t
      ; dst : Reg.t
      ; src : operand
      }
  | Bitcast of
      { dst : Reg.t
      ; src : operand
      }
  | Adr of
      { dst : Reg.t
      ; target : Jump_target.t
      }
  | Comp of
      { kind : Comp_kind.t
      ; lhs : operand
      ; rhs : operand
      }
  | Conditional_branch of
      { condition : Condition.t
      ; then_ : 'block Call_block.t
      ; else_ : 'block Call_block.t option
      }
  | Jump of 'block Call_block.t
  | Call of
      { fn : string
      ; results : Reg.t list
      ; args : operand list
      }
  | Ret of operand list
  | Label of string
  | Save_clobbers
  | Restore_clobbers
  | Alloca of operand * Int64.t
  (* Atomic operations *)
  | Dmb (* Data Memory Barrier - full barrier *)
  | Ldar of
      { dst : Reg.t
      ; addr : operand
      } (* Load-Acquire Register *)
  | Stlr of
      { src : operand
      ; addr : operand
      } (* Store-Release Register *)
  | Ldaxr of
      { dst : Reg.t
      ; addr : operand
      } (* Load-Acquire Exclusive Register *)
  | Stlxr of
      { status : Reg.t (* 0 on success, 1 on failure *)
      ; src : operand
      ; addr : operand
      } (* Store-Release Exclusive Register *)
  | Casal of
      { dst : Reg.t (* receives old value *)
      ; expected : operand (* compared value *)
      ; desired : operand
      ; addr : operand
      } (* Compare and Swap Acquire-Release *)
[@@deriving sexp, equal, compare, hash, variants]

let fn = function
  | Call { fn; _ } -> Some fn
  | Nop
  | Tag_use _
  | Tag_def _
  | Move _
  | Load _
  | Store _
  | Int_binary _
  | Float_binary _
  | Convert _
  | Bitcast _
  | Adr _
  | Comp _
  | Conditional_branch _
  | Jump _
  | Ret _
  | Label _
  | Save_clobbers
  | Restore_clobbers
  | Alloca _
  | Dmb
  | Ldar _
  | Stlr _
  | Ldaxr _
  | Stlxr _
  | Casal _ -> None
;;

let fold_operand op ~f ~init = f init op

let fold_jump_target target ~f ~init =
  match target with
  | Jump_target.Reg reg -> fold_operand (Reg reg) ~f ~init
  | Jump_target.Imm _ | Jump_target.Symbol _ | Jump_target.Label _ -> init
;;

let rec fold_operands ins ~f ~init =
  match ins with
  | Save_clobbers | Restore_clobbers | Nop | Label _ | Dmb -> init
  | Alloca (dst, _) -> fold_operand dst ~f ~init
  | Tag_use (ins, op) | Tag_def (ins, op) ->
    fold_operand op ~f ~init:(fold_operands ins ~f ~init)
  | Move { dst; src } ->
    let init = fold_operand (Reg dst) ~f ~init in
    fold_operand src ~f ~init
  | Load { dst; addr } ->
    let init = fold_operand (Reg dst) ~f ~init in
    fold_operand addr ~f ~init
  | Store { src; addr } ->
    let init = fold_operand src ~f ~init in
    fold_operand addr ~f ~init
  | Int_binary { op = _; dst; lhs; rhs }
  | Float_binary { op = _; dst; lhs; rhs } ->
    let init = fold_operand (Reg dst) ~f ~init in
    let init = fold_operand lhs ~f ~init in
    fold_operand rhs ~f ~init
  | Convert { op = _; dst; src } | Bitcast { dst; src } ->
    let init = fold_operand (Reg dst) ~f ~init in
    fold_operand src ~f ~init
  | Adr { dst; target } ->
    let init = fold_operand (Reg dst) ~f ~init in
    fold_jump_target target ~f ~init
  | Comp { lhs; rhs; _ } ->
    let init = fold_operand lhs ~f ~init in
    fold_operand rhs ~f ~init
  | Ret ops ->
    List.fold ops ~init ~f:(fun acc op -> fold_operand op ~f ~init:acc)
  | Call { results; args; _ } ->
    let init =
      List.fold results ~init ~f:(fun acc reg ->
        fold_operand (Reg reg) ~f ~init:acc)
    in
    List.fold args ~init ~f:(fun acc op -> fold_operand op ~f ~init:acc)
  | Conditional_branch _ | Jump _ -> init
  (* Atomic operations *)
  | Ldar { dst; addr } ->
    let init = fold_operand (Reg dst) ~f ~init in
    fold_operand addr ~f ~init
  | Stlr { src; addr } ->
    let init = fold_operand src ~f ~init in
    fold_operand addr ~f ~init
  | Ldaxr { dst; addr } ->
    let init = fold_operand (Reg dst) ~f ~init in
    fold_operand addr ~f ~init
  | Stlxr { status; src; addr } ->
    let init = fold_operand (Reg status) ~f ~init in
    let init = fold_operand src ~f ~init in
    fold_operand addr ~f ~init
  | Casal { dst; expected; desired; addr } ->
    let init = fold_operand (Reg dst) ~f ~init in
    let init = fold_operand expected ~f ~init in
    let init = fold_operand desired ~f ~init in
    fold_operand addr ~f ~init
;;

let rebuild_virtual_reg (reg : Reg.t) ~var =
  match Reg.raw reg with
  | Raw.Unallocated _ -> Reg.unallocated ~class_:(Reg.class_ reg) var
  | Raw.Allocated (_, forced) ->
    let forced =
      Option.map forced ~f:(fun raw -> Reg.create ~class_:(Reg.class_ reg) ~raw)
    in
    Reg.allocated ~class_:(Reg.class_ reg) var forced
  | _ -> reg
;;

let map_reg (reg : Reg.t) ~f =
  match Reg.raw reg with
  | Raw.Unallocated v | Raw.Allocated (v, _) ->
    Reg (rebuild_virtual_reg reg ~var:(f v))
  | _ -> Reg reg
;;

let map_jump_target target ~f =
  match target with
  | Jump_target.Reg reg -> Jump_target.Reg (f reg)
  | Jump_target.Imm _ | Jump_target.Symbol _ | Jump_target.Label _ -> target
;;

let map_var_operand op ~f =
  match op with
  | Reg r -> map_reg r ~f
  | Imm _ | Spill_slot _ -> op
  | Mem (r, disp) ->
    (match map_reg r ~f with
     | Reg r -> Mem (r, disp)
     | _ -> failwith "expected register operand")
;;

let map_virtual_reg reg ~f =
  match Reg.raw reg with
  | Raw.Unallocated v -> Reg.unallocated ~class_:(Reg.class_ reg) (f v)
  | Raw.Allocated (v, forced) ->
    let forced =
      Option.map forced ~f:(fun raw -> Reg.create ~class_:(Reg.class_ reg) ~raw)
    in
    Reg.allocated ~class_:(Reg.class_ reg) (f v) forced
  | _ -> reg
;;

let map_def_reg = map_virtual_reg
let map_use_reg = map_virtual_reg

let map_def_operand op ~f =
  match op with
  | Reg r -> Reg (map_def_reg r ~f)
  | Imm _ | Spill_slot _ -> op
  | Mem (r, disp) -> Mem (map_def_reg r ~f, disp)
;;

let map_use_operand op ~f =
  match op with
  | Reg r -> Reg (map_use_reg r ~f)
  | Imm _ | Spill_slot _ -> op
  | Mem (r, disp) -> Mem (map_use_reg r ~f, disp)
;;

let rec map_var_operands ins ~f =
  let map_reg_definition reg = map_virtual_reg reg ~f in
  let map_op op = map_var_operand op ~f in
  let map_jump = map_jump_target ~f:map_reg_definition in
  match ins with
  | Save_clobbers -> Save_clobbers
  | Restore_clobbers -> Restore_clobbers
  | Nop -> Nop
  | Label s -> Label s
  | Alloca (op, sz) -> Alloca (map_op op, sz)
  | Tag_def (ins, op) -> Tag_def (map_var_operands ins ~f, map_op op)
  | Tag_use (ins, op) -> Tag_use (map_var_operands ins ~f, map_op op)
  | Move { dst; src } -> Move { dst = map_reg_definition dst; src = map_op src }
  | Load { dst; addr } ->
    Load { dst = map_reg_definition dst; addr = map_op addr }
  | Store { src; addr } -> Store { src = map_op src; addr = map_op addr }
  | Int_binary { op; dst; lhs; rhs } ->
    Int_binary
      { op; dst = map_reg_definition dst; lhs = map_op lhs; rhs = map_op rhs }
  | Float_binary { op; dst; lhs; rhs } ->
    Float_binary
      { op; dst = map_reg_definition dst; lhs = map_op lhs; rhs = map_op rhs }
  | Convert { op; dst; src } ->
    Convert { op; dst = map_reg_definition dst; src = map_op src }
  | Bitcast { dst; src } ->
    Bitcast { dst = map_reg_definition dst; src = map_op src }
  | Adr { dst; target } ->
    Adr { dst = map_reg_definition dst; target = map_jump target }
  | Comp { kind; lhs; rhs } -> Comp { kind; lhs = map_op lhs; rhs = map_op rhs }
  | Call { fn; results; args } ->
    Call
      { fn
      ; results = List.map results ~f:map_reg_definition
      ; args = List.map args ~f:map_op
      }
  | Ret ops -> Ret (List.map ops ~f:map_op)
  | Conditional_branch { condition; then_; else_ } ->
    let map_cb cb = Call_block.map_uses cb ~f in
    Conditional_branch
      { condition; then_ = map_cb then_; else_ = Option.map else_ ~f:map_cb }
  | Jump cb -> Jump (Call_block.map_uses cb ~f)
  | Dmb -> Dmb
  | Ldar { dst; addr } ->
    Ldar { dst = map_reg_definition dst; addr = map_op addr }
  | Stlr { src; addr } -> Stlr { src = map_op src; addr = map_op addr }
  | Ldaxr { dst; addr } ->
    Ldaxr { dst = map_reg_definition dst; addr = map_op addr }
  | Stlxr { status; src; addr } ->
    Stlxr
      { status = map_reg_definition status; src = map_op src; addr = map_op addr }
  | Casal { dst; expected; desired; addr } ->
    Casal
      { dst = map_reg_definition dst
      ; expected = map_op expected
      ; desired = map_op desired
      ; addr = map_op addr
      }
;;

let var_of_reg = function
  | ({ reg = Raw.Unallocated v | Raw.Allocated (v, _); _ } : Reg.t) -> Some v
  | _ -> None
;;

let vars_of_reg = function
  | ({ reg = Raw.Unallocated v | Raw.Allocated (v, _); _ } : Reg.t) ->
    Var.Set.singleton v
  | _ -> Var.Set.empty
;;

let vars_of_operand = function
  | Reg r -> vars_of_reg r
  | Imm _ | Spill_slot _ -> Var.Set.empty
  | Mem (r, _) -> vars_of_reg r
;;

let regs_of_operand = function
  | Reg r -> Reg.Set.singleton r
  | Spill_slot _ ->
    Breadcrumbs.frame_pointer_omission;
    Reg.Set.singleton Reg.fp
  | Imm _ -> Reg.Set.empty
  | Mem (r, _) -> Reg.Set.singleton r
;;

let regs_of_jump_target = function
  | Jump_target.Reg r -> Reg.Set.singleton r
  | Jump_target.Imm _ | Jump_target.Symbol _ | Jump_target.Label _ -> Reg.Set.empty
;;

let rec reg_defs ins : Reg.Set.t =
  match ins with
  | Save_clobbers | Restore_clobbers | Nop | Label _ | Dmb | Stlr _ ->
    Reg.Set.empty
  | Tag_def (ins, op) -> Set.union (regs_of_operand op) (reg_defs ins)
  | Tag_use (ins, _) -> reg_defs ins
  | Alloca (dst, _) -> regs_of_operand dst
  | Move { dst; _ }
  | Load { dst; _ }
  | Int_binary { dst; _ }
  | Float_binary { dst; _ }
  | Convert { dst; _ }
  | Bitcast { dst; _ }
  | Adr { dst; _ }
  | Ldar { dst; _ }
  | Ldaxr { dst; _ }
  | Casal { dst; _ } -> Reg.Set.singleton dst
  | Stlxr { status; _ } -> Reg.Set.singleton status
  | Call { results; _ } -> Set.add (Reg.Set.of_list results) Reg.lr
  | Store _ | Comp _ | Conditional_branch _ | Jump _ | Ret _ -> Reg.Set.empty
;;

let rec reg_uses ins : Reg.Set.t =
  match ins with
  | Save_clobbers | Restore_clobbers | Nop | Label _ | Dmb -> Reg.Set.empty
  | Tag_use (ins, op) -> Set.union (regs_of_operand op) (reg_uses ins)
  | Tag_def (ins, _) -> reg_uses ins
  | Alloca _ -> Reg.Set.empty
  | Move { src; _ } -> regs_of_operand src
  | Load { addr; _ } | Ldar { addr; _ } | Ldaxr { addr; _ } ->
    regs_of_operand addr
  | Store { src; addr } | Stlr { src; addr } ->
    Set.union (regs_of_operand src) (regs_of_operand addr)
  | Stlxr { src; addr; _ } ->
    Set.union (regs_of_operand src) (regs_of_operand addr)
  | Casal { expected; desired; addr; _ } ->
    Reg.Set.union_list
      [ regs_of_operand expected; regs_of_operand desired; regs_of_operand addr ]
  | Int_binary { lhs; rhs; _ } | Float_binary { lhs; rhs; _ } ->
    Set.union (regs_of_operand lhs) (regs_of_operand rhs)
  | Convert { src; _ } | Bitcast { src; _ } -> regs_of_operand src
  | Adr { target; _ } -> regs_of_jump_target target
  | Comp { lhs; rhs; _ } ->
    Set.union (regs_of_operand lhs) (regs_of_operand rhs)
  | Call { args; _ } ->
    List.fold args ~init:Reg.Set.empty ~f:(fun acc op ->
      Set.union acc (regs_of_operand op))
  | Ret ops ->
    Set.add (Reg.Set.union_list (List.map ops ~f:regs_of_operand)) Reg.lr
  | Conditional_branch { then_; else_; _ } ->
    let use_cb cb =
      Call_block.uses cb |> List.map ~f:Reg.unallocated |> Reg.Set.of_list
    in
    let init = use_cb then_ in
    Option.value_map else_ ~default:init ~f:(fun cb ->
      Set.union init (use_cb cb))
  | Jump cb ->
    Call_block.uses cb |> List.map ~f:Reg.unallocated |> Reg.Set.of_list
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
  | Save_clobbers
  | Restore_clobbers
  | Nop
  | Label _
  | Dmb
  | Ldar _
  | Stlr _
  | Ldaxr _
  | Stlxr _
  | Casal _ -> []
  | Tag_use (ins, _) | Tag_def (ins, _) -> blocks ins
  | Conditional_branch { then_; else_; _ } ->
    Call_block.blocks then_
    @ Option.value_map else_ ~default:[] ~f:Call_block.blocks
  | Jump cb -> Call_block.blocks cb
  | _ -> []
;;

let rec map_blocks (instr : 'a t) ~(f : 'a -> 'b) : 'b t =
  match instr with
  | Save_clobbers -> Save_clobbers
  | Restore_clobbers -> Restore_clobbers
  | Nop -> Nop
  | Label s -> Label s
  | Alloca (op, sz) -> Alloca (op, sz)
  | Tag_def (ins, op) -> Tag_def (map_blocks ins ~f, op)
  | Tag_use (ins, op) -> Tag_use (map_blocks ins ~f, op)
  | Move mv -> Move mv
  | Load ld -> Load ld
  | Store st -> Store st
  | Int_binary bin -> Int_binary bin
  | Float_binary bin -> Float_binary bin
  | Convert conv -> Convert conv
  | Bitcast bc -> Bitcast bc
  | Adr adr -> Adr adr
  | Comp cmp -> Comp cmp
  | Call call -> Call call
  | Ret ops -> Ret ops
  | Dmb -> Dmb
  | Ldar ld -> Ldar ld
  | Stlr st -> Stlr st
  | Ldaxr ld -> Ldaxr ld
  | Stlxr st -> Stlxr st
  | Casal cas -> Casal cas
  | Conditional_branch { condition; then_; else_ } ->
    Conditional_branch
      { condition
      ; then_ = Call_block.map_blocks ~f then_
      ; else_ = Option.map else_ ~f:(Call_block.map_blocks ~f)
      }
  | Jump cb -> Jump (Call_block.map_blocks ~f cb)
;;

let rec filter_map_call_blocks t ~f =
  match t with
  | Save_clobbers
  | Restore_clobbers
  | Nop
  | Label _
  | Dmb
  | Ldar _
  | Stlr _
  | Ldaxr _
  | Stlxr _
  | Casal _ -> []
  | Tag_use (ins, _) | Tag_def (ins, _) -> filter_map_call_blocks ins ~f
  | Conditional_branch { then_; else_; _ } ->
    let mapped_then = f then_ |> Option.to_list in
    let mapped_else = Option.bind else_ ~f |> Option.to_list in
    mapped_then @ mapped_else
  | Jump cb -> f cb |> Option.to_list
  | _ -> []
;;

let unreachable = Nop

let rec map_defs t ~f =
  match t with
  | Save_clobbers -> Save_clobbers
  | Restore_clobbers -> Restore_clobbers
  | Nop -> Nop
  | Label s -> Label s
  | Dmb -> Dmb
  | Alloca (op, sz) -> Alloca (map_def_operand op ~f, sz)
  | Tag_def (ins, op) -> Tag_def (map_defs ins ~f, map_def_operand op ~f)
  | Tag_use (ins, op) -> Tag_use (map_defs ins ~f, op)
  | Move { dst; src } -> Move { dst = map_def_reg dst ~f; src }
  | Load { dst; addr } -> Load { dst = map_def_reg dst ~f; addr }
  | Ldar { dst; addr } -> Ldar { dst = map_def_reg dst ~f; addr }
  | Ldaxr { dst; addr } -> Ldaxr { dst = map_def_reg dst ~f; addr }
  | Casal { dst; expected; desired; addr } ->
    Casal { dst = map_def_reg dst ~f; expected; desired; addr }
  | Stlxr { status; src; addr } ->
    Stlxr { status = map_def_reg status ~f; src; addr }
  | Store st -> Store st
  | Stlr st -> Stlr st
  | Int_binary { op; dst; lhs; rhs } ->
    Int_binary { op; dst = map_def_reg dst ~f; lhs; rhs }
  | Float_binary { op; dst; lhs; rhs } ->
    Float_binary { op; dst = map_def_reg dst ~f; lhs; rhs }
  | Convert { op; dst; src } -> Convert { op; dst = map_def_reg dst ~f; src }
  | Bitcast { dst; src } -> Bitcast { dst = map_def_reg dst ~f; src }
  | Adr { dst; target } -> Adr { dst = map_def_reg dst ~f; target }
  | Comp cmp -> Comp cmp
  | Call { fn; results; args } ->
    Call { fn; results = List.map results ~f:(fun r -> map_def_reg r ~f); args }
  | Ret ops -> Ret ops
  | Conditional_branch branch -> Conditional_branch branch
  | Jump cb -> Jump cb
;;

let rec map_uses t ~f =
  let map_op op = map_use_operand op ~f in
  let map_cb cb = Call_block.map_uses cb ~f in
  match t with
  | Save_clobbers -> Save_clobbers
  | Restore_clobbers -> Restore_clobbers
  | Nop -> Nop
  | Label s -> Label s
  | Dmb -> Dmb
  | Alloca (op, sz) -> Alloca (op, sz)
  | Tag_def (ins, op) -> Tag_def (map_uses ins ~f, op)
  | Tag_use (ins, op) -> Tag_use (map_uses ins ~f, map_op op)
  | Move { dst; src } -> Move { dst; src = map_op src }
  | Load { dst; addr } -> Load { dst; addr = map_op addr }
  | Ldar { dst; addr } -> Ldar { dst; addr = map_op addr }
  | Ldaxr { dst; addr } -> Ldaxr { dst; addr = map_op addr }
  | Store { src; addr } -> Store { src = map_op src; addr = map_op addr }
  | Stlr { src; addr } -> Stlr { src = map_op src; addr = map_op addr }
  | Stlxr { status; src; addr } ->
    Stlxr { status; src = map_op src; addr = map_op addr }
  | Casal { dst; expected; desired; addr } ->
    Casal
      { dst; expected = map_op expected; desired = map_op desired; addr = map_op addr }
  | Int_binary { op; dst; lhs; rhs } ->
    Int_binary { op; dst; lhs = map_op lhs; rhs = map_op rhs }
  | Float_binary { op; dst; lhs; rhs } ->
    Float_binary { op; dst; lhs = map_op lhs; rhs = map_op rhs }
  | Convert { op; dst; src } -> Convert { op; dst; src = map_op src }
  | Bitcast { dst; src } -> Bitcast { dst; src = map_op src }
  | Adr { dst; target } ->
    Adr { dst; target = map_jump_target target ~f:(fun r -> map_use_reg r ~f) }
  | Comp { kind; lhs; rhs } -> Comp { kind; lhs = map_op lhs; rhs = map_op rhs }
  | Call { fn; results; args } ->
    Call { fn; results; args = List.map args ~f:map_op }
  | Ret ops -> Ret (List.map ops ~f:map_op)
  | Conditional_branch { condition; then_; else_ } ->
    Conditional_branch
      { condition; then_ = map_cb then_; else_ = Option.map else_ ~f:map_cb }
  | Jump cb -> Jump (map_cb cb)
;;

let rec map_operands t ~f =
  let map_reg_operand reg =
    match f (Reg reg) with
    | Reg reg' -> reg'
    | op -> Error.raise_s [%message "expected register operand" (op : operand)]
  in
  let map_op op = f op in
  match t with
  | Save_clobbers -> Save_clobbers
  | Restore_clobbers -> Restore_clobbers
  | Nop -> Nop
  | Label s -> Label s
  | Dmb -> Dmb
  | Alloca (op, sz) -> Alloca (map_op op, sz)
  | Tag_def (ins, op) -> Tag_def (map_operands ins ~f, map_op op)
  | Tag_use (ins, op) -> Tag_use (map_operands ins ~f, map_op op)
  | Move { dst; src } -> Move { dst = map_reg_operand dst; src = map_op src }
  | Load { dst; addr } -> Load { dst = map_reg_operand dst; addr = map_op addr }
  | Ldar { dst; addr } -> Ldar { dst = map_reg_operand dst; addr = map_op addr }
  | Ldaxr { dst; addr } -> Ldaxr { dst = map_reg_operand dst; addr = map_op addr }
  | Store { src; addr } -> Store { src = map_op src; addr = map_op addr }
  | Stlr { src; addr } -> Stlr { src = map_op src; addr = map_op addr }
  | Stlxr { status; src; addr } ->
    Stlxr { status = map_reg_operand status; src = map_op src; addr = map_op addr }
  | Casal { dst; expected; desired; addr } ->
    Casal
      { dst = map_reg_operand dst
      ; expected = map_op expected
      ; desired = map_op desired
      ; addr = map_op addr
      }
  | Int_binary { op; dst; lhs; rhs } ->
    Int_binary
      { op; dst = map_reg_operand dst; lhs = map_op lhs; rhs = map_op rhs }
  | Float_binary { op; dst; lhs; rhs } ->
    Float_binary
      { op; dst = map_reg_operand dst; lhs = map_op lhs; rhs = map_op rhs }
  | Convert { op; dst; src } ->
    Convert { op; dst = map_reg_operand dst; src = map_op src }
  | Bitcast { dst; src } ->
    Bitcast { dst = map_reg_operand dst; src = map_op src }
  | Adr { dst; target } ->
    let target =
      match target with
      | Jump_target.Reg r -> Jump_target.Reg (map_reg_operand r)
      | Jump_target.Imm _ | Jump_target.Symbol _ | Jump_target.Label _ -> target
    in
    Adr { dst = map_reg_operand dst; target }
  | Comp { kind; lhs; rhs } -> Comp { kind; lhs = map_op lhs; rhs = map_op rhs }
  | Call { fn; results; args } ->
    let map_result r =
      match f (Reg r) with
      | Reg r' -> r'
      | _ -> failwith "expected register operand"
    in
    Call
      { fn
      ; results = List.map results ~f:map_result
      ; args = List.map args ~f:map_op
      }
  | Ret ops -> Ret (List.map ops ~f:map_op)
  | Conditional_branch branch -> Conditional_branch branch
  | Jump cb -> Jump cb
;;

let rec map_call_blocks t ~f =
  match t with
  | Save_clobbers -> Save_clobbers
  | Restore_clobbers -> Restore_clobbers
  | Nop -> Nop
  | Label s -> Label s
  | Dmb -> Dmb
  | Alloca (op, sz) -> Alloca (op, sz)
  | Tag_def (ins, op) -> Tag_def (map_call_blocks ins ~f, op)
  | Tag_use (ins, op) -> Tag_use (map_call_blocks ins ~f, op)
  | Conditional_branch { condition; then_; else_ } ->
    Conditional_branch
      { condition; then_ = f then_; else_ = Option.map else_ ~f }
  | Jump cb -> Jump (f cb)
  | Move mv -> Move mv
  | Load ld -> Load ld
  | Ldar ld -> Ldar ld
  | Ldaxr ld -> Ldaxr ld
  | Store st -> Store st
  | Stlr st -> Stlr st
  | Stlxr st -> Stlxr st
  | Casal cas -> Casal cas
  | Int_binary bin -> Int_binary bin
  | Float_binary bin -> Float_binary bin
  | Convert conv -> Convert conv
  | Bitcast bc -> Bitcast bc
  | Adr adr -> Adr adr
  | Comp cmp -> Comp cmp
  | Call call -> Call call
  | Ret ops -> Ret ops
;;

let rec iter_call_blocks t ~f =
  match t with
  | Save_clobbers
  | Restore_clobbers
  | Nop
  | Label _
  | Dmb
  | Ldar _
  | Stlr _
  | Ldaxr _
  | Stlxr _
  | Casal _ -> ()
  | Tag_def (ins, _) | Tag_use (ins, _) -> iter_call_blocks ins ~f
  | Conditional_branch { then_; else_; _ } ->
    f then_;
    Option.iter else_ ~f
  | Jump cb -> f cb
  | _ -> ()
;;

let rec call_blocks = function
  | Save_clobbers
  | Restore_clobbers
  | Nop
  | Label _
  | Dmb
  | Ldar _
  | Stlr _
  | Ldaxr _
  | Stlxr _
  | Casal _ -> []
  | Tag_def (ins, _) | Tag_use (ins, _) -> call_blocks ins
  | Conditional_branch { then_; else_; _ } -> then_ :: Option.to_list else_
  | Jump cb -> [ cb ]
  | _ -> []
;;

let map_lit_or_vars t ~f:_ = t

let rec is_terminal = function
  | Save_clobbers | Restore_clobbers | Nop | Label _ -> false
  | Tag_def (ins, _) | Tag_use (ins, _) -> is_terminal ins
  | Ret _ | Jump _ | Conditional_branch _ -> true
  | Move _
  | Load _
  | Store _
  | Int_binary _
  | Float_binary _
  | Convert _
  | Bitcast _
  | Adr _
  | Comp _
  | Call _
  | Alloca _
  | Dmb
  | Ldar _
  | Stlr _
  | Ldaxr _
  | Stlxr _
  | Casal _ -> false
;;

module For_backend = struct
  let rec map_use_operands
    (t : 'a t)
    ~(f : operand -> must_be_reg:bool -> operand)
    : 'a t
    =
    let map_op ?(must_be_reg = false) op =
      let op' = f op ~must_be_reg in
      match must_be_reg, op' with
      | true, Reg _ -> op'
      | true, _ ->
        Error.raise_s [%message "expected register operand" (op' : operand)]
      | false, _ -> op'
    in
    let map_reg r =
      match map_op ~must_be_reg:true (Reg r) with
      | Reg r' -> r'
      | _ -> assert false
    in
    let map_use_operand op =
      match op with
      | Imm _ | Spill_slot _ -> op
      | Reg _ -> map_op op
      | Mem (r, disp) ->
        let r' = map_reg r in
        Mem (r', disp)
    in
    let map_jump_target = function
      | Jump_target.Reg r -> Jump_target.Reg (map_reg r)
      | (Jump_target.Imm _ | Jump_target.Symbol _ | Jump_target.Label _) as t ->
        t
    in
    let map_cb cb = cb in
    match t with
    | Save_clobbers -> Save_clobbers
    | Restore_clobbers -> Restore_clobbers
    | Nop -> Nop
    | Label s -> Label s
    | Dmb -> Dmb
    | Alloca (op, sz) -> Alloca (op, sz)
    | Tag_def (ins, op) -> Tag_def (map_use_operands ins ~f, op)
    | Tag_use (ins, op) -> Tag_use (map_use_operands ins ~f, map_use_operand op)
    | Move { dst; src } -> Move { dst; src = map_use_operand src }
    | Load { dst; addr } -> Load { dst; addr = map_use_operand addr }
    | Ldar { dst; addr } -> Ldar { dst; addr = map_use_operand addr }
    | Ldaxr { dst; addr } -> Ldaxr { dst; addr = map_use_operand addr }
    | Store { src; addr } ->
      Store { src = map_use_operand src; addr = map_use_operand addr }
    | Stlr { src; addr } ->
      Stlr { src = map_use_operand src; addr = map_use_operand addr }
    | Stlxr { status; src; addr } ->
      Stlxr { status; src = map_use_operand src; addr = map_use_operand addr }
    | Casal { dst; expected; desired; addr } ->
      Casal
        { dst
        ; expected = map_use_operand expected
        ; desired = map_use_operand desired
        ; addr = map_use_operand addr
        }
    | Int_binary { op; dst; lhs; rhs } ->
      Int_binary
        { op; dst; lhs = map_use_operand lhs; rhs = map_use_operand rhs }
    | Float_binary { op; dst; lhs; rhs } ->
      Float_binary
        { op; dst; lhs = map_use_operand lhs; rhs = map_use_operand rhs }
    | Convert { op; dst; src } -> Convert { op; dst; src = map_use_operand src }
    | Bitcast { dst; src } -> Bitcast { dst; src = map_use_operand src }
    | Adr { dst; target } -> Adr { dst; target = map_jump_target target }
    | Comp { kind; lhs; rhs } ->
      Comp { kind; lhs = map_use_operand lhs; rhs = map_use_operand rhs }
    | Call { fn; results; args } ->
      Call { fn; results; args = List.map args ~f:map_use_operand }
    | Ret ops -> Ret (List.map ops ~f:map_use_operand)
    | Conditional_branch { condition; then_; else_ } ->
      Conditional_branch
        { condition; then_ = map_cb then_; else_ = Option.map else_ ~f:map_cb }
    | Jump cb -> Jump (map_cb cb)
  ;;

  let rec map_def_operands
    (t : 'a t)
    ~(f : operand -> must_be_reg:bool -> operand)
    : 'a t
    =
    let map_op ?(must_be_reg = false) op =
      let op' = f op ~must_be_reg in
      match must_be_reg, op' with
      | true, Reg _ -> op'
      | true, _ ->
        Error.raise_s [%message "expected register operand" (op' : operand)]
      | false, _ -> op'
    in
    let map_reg r =
      match map_op ~must_be_reg:true (Reg r) with
      | Reg r' -> r'
      | _ -> assert false
    in
    let map_def_operand op =
      match op with
      | Imm _ | Spill_slot _ -> op
      | Reg _ -> map_op ~must_be_reg:true op
      | Mem (r, disp) ->
        let r' = map_reg r in
        Mem (r', disp)
    in
    let map_cb cb = cb in
    match t with
    | Save_clobbers -> Save_clobbers
    | Restore_clobbers -> Restore_clobbers
    | Nop -> Nop
    | Label s -> Label s
    | Dmb -> Dmb
    | Alloca (op, sz) -> Alloca (map_def_operand op, sz)
    | Tag_def (ins, op) -> Tag_def (map_def_operands ins ~f, map_def_operand op)
    | Tag_use (ins, op) -> Tag_use (map_def_operands ins ~f, op)
    | Move { dst; src } -> Move { dst = map_reg dst; src }
    | Load { dst; addr } -> Load { dst = map_reg dst; addr }
    | Ldar { dst; addr } -> Ldar { dst = map_reg dst; addr }
    | Ldaxr { dst; addr } -> Ldaxr { dst = map_reg dst; addr }
    | Casal { dst; expected; desired; addr } ->
      Casal { dst = map_reg dst; expected; desired; addr }
    | Stlxr { status; src; addr } -> Stlxr { status = map_reg status; src; addr }
    | Store st -> Store st
    | Stlr st -> Stlr st
    | Int_binary { op; dst; lhs; rhs } ->
      Int_binary { op; dst = map_reg dst; lhs; rhs }
    | Float_binary { op; dst; lhs; rhs } ->
      Float_binary { op; dst = map_reg dst; lhs; rhs }
    | Convert { op; dst; src } -> Convert { op; dst = map_reg dst; src }
    | Bitcast { dst; src } -> Bitcast { dst = map_reg dst; src }
    | Adr { dst; target } -> Adr { dst = map_reg dst; target }
    | Comp cmp -> Comp cmp
    | Call { fn; results; args } ->
      Call { fn; results = List.map results ~f:map_reg; args }
    | Ret ops -> Ret ops
    | Conditional_branch branch -> Conditional_branch branch
    | Jump cb -> Jump (map_cb cb)
  ;;

  let map_operand_regs ~f operand ~must_be_reg =
    match operand with
    | (Spill_slot _ | Imm _) as x -> x
    | Reg r -> f ~must_be_reg r
    | Mem (r, offset) ->
      Mem
        ( f ~must_be_reg:true r
          |> (* safe because we enforce no spills on the mem regs *)
          reg_of_operand_exn
        , offset )
  ;;

  let map_use_regs t ~f = map_use_operands t ~f:(map_operand_regs ~f)
  let map_def_regs t ~f = map_def_operands t ~f:(map_operand_regs ~f)
end
