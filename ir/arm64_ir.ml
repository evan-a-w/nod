open! Core
open! Import
module Reg = Arm64_reg
module Raw = Arm64_reg.Raw

module Jump_target = struct
  type 'var t =
    | Reg of 'var Reg.t
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

type 'var operand =
  | Reg of 'var Reg.t
  | Imm of Int64.t
  | Mem of 'var Reg.t * int (* [reg + offset] addressing *)
  | Spill_slot of int
[@@deriving sexp, equal, compare, hash]

let reg_of_operand_exn = function
  | Reg r -> r
  | _ -> failwith "operand is not a register"
;;

type ('var, 'block) t =
  | Nop
  | Tag_use of ('var, 'block) t * 'var operand
  | Tag_def of ('var, 'block) t * 'var operand
  | Move of
      { dst : 'var Reg.t
      ; src : 'var operand
      }
  | Load of
      { dst : 'var Reg.t
      ; addr : 'var operand
      }
  | Store of
      { src : 'var operand
      ; addr : 'var operand
      }
  | Int_binary of
      { op : Int_op.t
      ; dst : 'var Reg.t
      ; lhs : 'var operand
      ; rhs : 'var operand
      }
  | Float_binary of
      { op : Float_op.t
      ; dst : 'var Reg.t
      ; lhs : 'var operand
      ; rhs : 'var operand
      }
  | Convert of
      { op : Convert_op.t
      ; dst : 'var Reg.t
      ; src : 'var operand
      }
  | Bitcast of
      { dst : 'var Reg.t
      ; src : 'var operand
      }
  | Adr of
      { dst : 'var Reg.t
      ; target : 'var Jump_target.t
      }
  | Comp of
      { kind : Comp_kind.t
      ; lhs : 'var operand
      ; rhs : 'var operand
      }
  | Cset of
      { condition : Condition.t
      ; dst : 'var Reg.t
      }
  | Conditional_branch of
      { condition : Condition.t
      ; then_ : ('var, 'block) Call_block.t
      ; else_ : ('var, 'block) Call_block.t option
      }
  | Jump of ('var, 'block) Call_block.t
  | Call of
      { fn : string
      ; results : 'var Reg.t list
      ; args : 'var operand list
      }
  | Ret of 'var operand list
  | Label of string
  | Save_clobbers
  | Restore_clobbers
  | Alloca of 'var operand * Int64.t
  (* Atomic operations *)
  | Dmb (* Data Memory Barrier - full barrier *)
  | Ldar of
      { dst : 'var Reg.t
      ; addr : 'var operand
      }
    (* Load-Acquire Register *)
  | Stlr of
      { src : 'var operand
      ; addr : 'var operand
      }
    (* Store-Release Register *)
  | Ldaxr of
      { dst : 'var Reg.t
      ; addr : 'var operand
      }
    (* Load-Acquire Exclusive Register *)
  | Stlxr of
      { status : 'var Reg.t (* 0 on success, 1 on failure *)
      ; src : 'var operand
      ; addr : 'var operand
      }
    (* Store-Release Exclusive Register *)
  | Casal of
      { dst : 'var Reg.t (* receives old value *)
      ; expected : 'var operand (* compared value *)
      ; desired : 'var operand
      ; addr : 'var operand
      }
    (* Compare and Swap Acquire-Release *)
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
  | Cset _
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
  | Cset { dst; _ } -> fold_operand (Reg dst) ~f ~init
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

let rebuild_virtual_reg (reg : 'var Reg.t) ~var =
  match Reg.raw reg with
  | Raw.Unallocated _ -> Reg.unallocated ~class_:(Reg.class_ reg) var
  | Raw.Allocated (_, forced) ->
    let forced =
      Option.map forced ~f:(fun raw -> Reg.create ~class_:(Reg.class_ reg) ~raw)
    in
    Reg.allocated ~class_:(Reg.class_ reg) var forced
  | _ -> reg
;;

let map_reg (reg : 'var Reg.t) ~f =
  match Reg.raw reg with
  | Raw.Unallocated v | Raw.Allocated (v, _) ->
    Reg (rebuild_virtual_reg reg ~var:(f v))
  | _ -> Reg reg
;;

let map_jump_target target ~f =
  match target with
  | Jump_target.Reg reg -> Jump_target.Reg (f reg)
  | Jump_target.Imm i -> Jump_target.Imm i
  | Jump_target.Symbol s -> Jump_target.Symbol s
  | Jump_target.Label l -> Jump_target.Label l
;;

let map_var_operand op ~f =
  match op with
  | Reg r -> Reg (Reg.map_vars r ~f)
  | Imm i -> Imm i
  | Spill_slot s -> Spill_slot s
  | Mem (r, disp) -> Mem (Reg.map_vars r ~f, disp)
;;

let map_virtual_reg reg ~f = Reg.map_vars reg ~f
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
  | Cset { condition; dst } -> Cset { condition; dst = map_reg_definition dst }
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
      { status = map_reg_definition status
      ; src = map_op src
      ; addr = map_op addr
      }
  | Casal { dst; expected; desired; addr } ->
    Casal
      { dst = map_reg_definition dst
      ; expected = map_op expected
      ; desired = map_op desired
      ; addr = map_op addr
      }
;;

let var_of_reg (reg : 'var Reg.t) =
  match Reg.raw reg with
  | Raw.Unallocated v | Raw.Allocated (v, _) -> Some v
  | _ -> None
;;

let vars_of_reg (reg : 'var Reg.t) =
  match Reg.raw reg with
  | Raw.Unallocated v | Raw.Allocated (v, _) -> [ v ]
  | _ -> []
;;

let vars_of_operand = function
  | Reg r -> vars_of_reg r
  | Imm _ | Spill_slot _ -> []
  | Mem (r, _) -> vars_of_reg r
;;

let regs_of_operand = function
  | Reg r -> [ r ]
  | Spill_slot _ ->
    Breadcrumbs.frame_pointer_omission;
    [ Reg.fp ]
  | Imm _ -> []
  | Mem (r, _) -> [ r ]
;;

let regs_of_jump_target = function
  | Jump_target.Reg r -> [ r ]
  | Jump_target.Imm _ | Jump_target.Symbol _ | Jump_target.Label _ -> []
;;

let rec reg_defs ins =
  match ins with
  | Save_clobbers | Restore_clobbers | Nop | Label _ | Dmb | Stlr _ -> []
  | Tag_def (ins, op) -> regs_of_operand op @ reg_defs ins
  | Tag_use (ins, _) -> reg_defs ins
  | Alloca (dst, _) -> regs_of_operand dst
  | Move { dst; _ }
  | Load { dst; _ }
  | Int_binary { dst; _ }
  | Float_binary { dst; _ }
  | Convert { dst; _ }
  | Bitcast { dst; _ }
  | Adr { dst; _ }
  | Cset { dst; _ }
  | Ldar { dst; _ }
  | Ldaxr { dst; _ }
  | Casal { dst; _ } -> [ dst ]
  | Stlxr { status; _ } -> [ status ]
  | Call { results; _ } -> results @ [ Reg.lr ]
  | Store _ | Comp _ | Conditional_branch _ | Jump _ | Ret _ -> []
;;

let rec reg_uses ins =
  match ins with
  | Save_clobbers | Restore_clobbers | Nop | Label _ | Dmb -> []
  | Tag_use (ins, op) -> regs_of_operand op @ reg_uses ins
  | Tag_def (ins, _) -> reg_uses ins
  | Alloca _ -> []
  | Move { src; _ } -> regs_of_operand src
  | Load { addr; _ } | Ldar { addr; _ } | Ldaxr { addr; _ } ->
    regs_of_operand addr
  | Store { src; addr } | Stlr { src; addr } ->
    regs_of_operand src @ regs_of_operand addr
  | Stlxr { src; addr; _ } -> regs_of_operand src @ regs_of_operand addr
  | Casal { expected; desired; addr; _ } ->
    regs_of_operand expected @ regs_of_operand desired @ regs_of_operand addr
  | Int_binary { lhs; rhs; _ } | Float_binary { lhs; rhs; _ } ->
    regs_of_operand lhs @ regs_of_operand rhs
  | Convert { src; _ } | Bitcast { src; _ } -> regs_of_operand src
  | Adr { target; _ } -> regs_of_jump_target target
  | Comp { lhs; rhs; _ } -> regs_of_operand lhs @ regs_of_operand rhs
  | Cset _ -> []
  | Call { args; _ } -> List.concat_map args ~f:regs_of_operand
  | Ret ops -> List.concat_map ops ~f:regs_of_operand @ [ Reg.lr ]
  | Conditional_branch { then_; else_; _ } ->
    let then_uses = Call_block.uses then_ |> List.map ~f:Reg.unallocated in
    let else_uses =
      Option.value_map else_ ~default:[] ~f:(fun cb ->
        Call_block.uses cb |> List.map ~f:Reg.unallocated)
    in
    then_uses @ else_uses
  | Jump cb -> Call_block.uses cb |> List.map ~f:Reg.unallocated
;;

let regs ins = reg_defs ins @ reg_uses ins
let vars ins = regs ins |> List.filter_map ~f:var_of_reg
let defs ins = reg_defs ins |> List.filter_map ~f:var_of_reg
let uses ins = reg_uses ins |> List.filter_map ~f:var_of_reg

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

let rec map_blocks (instr : ('var, 'a) t) ~(f : 'a -> 'b) : ('var, 'b) t =
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
  | Cset cs -> Cset cs
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
  | Cset { condition; dst } -> Cset { condition; dst = map_def_reg dst ~f }
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
      { dst
      ; expected = map_op expected
      ; desired = map_op desired
      ; addr = map_op addr
      }
  | Int_binary { op; dst; lhs; rhs } ->
    Int_binary { op; dst; lhs = map_op lhs; rhs = map_op rhs }
  | Float_binary { op; dst; lhs; rhs } ->
    Float_binary { op; dst; lhs = map_op lhs; rhs = map_op rhs }
  | Convert { op; dst; src } -> Convert { op; dst; src = map_op src }
  | Bitcast { dst; src } -> Bitcast { dst; src = map_op src }
  | Adr { dst; target } ->
    Adr { dst; target = map_jump_target target ~f:(fun r -> map_use_reg r ~f) }
  | Comp { kind; lhs; rhs } -> Comp { kind; lhs = map_op lhs; rhs = map_op rhs }
  | Cset cs -> Cset cs
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
    | op -> Error.raise_s [%message "expected register operand"]
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
  | Ldaxr { dst; addr } ->
    Ldaxr { dst = map_reg_operand dst; addr = map_op addr }
  | Store { src; addr } -> Store { src = map_op src; addr = map_op addr }
  | Stlr { src; addr } -> Stlr { src = map_op src; addr = map_op addr }
  | Stlxr { status; src; addr } ->
    Stlxr
      { status = map_reg_operand status; src = map_op src; addr = map_op addr }
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
  | Cset { condition; dst } -> Cset { condition; dst = map_reg_operand dst }
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
  | Cset cs -> Cset cs
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
  | Cset _
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
    (t : ('var, 'block) t)
    ~(f : 'var operand -> must_be_reg:bool -> 'var operand)
    : ('var, 'block) t
    =
    let map_op ?(must_be_reg = false) op =
      let op' = f op ~must_be_reg in
      match must_be_reg, op' with
      | true, Reg _ -> op'
      | true, _ -> Error.raise_s [%message "expected register operand"]
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
    | Cset cs -> Cset cs
    | Call { fn; results; args } ->
      Call { fn; results; args = List.map args ~f:map_use_operand }
    | Ret ops -> Ret (List.map ops ~f:map_use_operand)
    | Conditional_branch { condition; then_; else_ } ->
      Conditional_branch
        { condition; then_ = map_cb then_; else_ = Option.map else_ ~f:map_cb }
    | Jump cb -> Jump (map_cb cb)
  ;;

  let rec map_def_operands
    (t : ('var, 'block) t)
    ~(f : 'var operand -> must_be_reg:bool -> 'var operand)
    : ('var, 'block) t
    =
    let map_op ?(must_be_reg = false) op =
      let op' = f op ~must_be_reg in
      match must_be_reg, op' with
      | true, Reg _ -> op'
      | true, _ -> Error.raise_s [%message "expected register operand"]
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
    | Stlxr { status; src; addr } ->
      Stlxr { status = map_reg status; src; addr }
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
    | Cset { condition; dst } -> Cset { condition; dst = map_reg dst }
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
