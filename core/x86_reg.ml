open Core

module Raw = struct
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
    | Unallocated of Var.t
    | (* [t option] is [Some] if we force a particular reg, [None] if we force any reg *)
      Allocated of Var.t * t option
  [@@deriving sexp, equal, compare, hash, variants]

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
     ; XMM0
     ; XMM1
     ; XMM2
     ; XMM3
     ; XMM4
     ; XMM5
     ; XMM6
     ; XMM7
     ; XMM8
     ; XMM9
     ; XMM10
     ; XMM11
     ; XMM12
     ; XMM13
     ; XMM14
     ; XMM15
    |]
  ;;

  let is_physical = function
    | Unallocated _ | Allocated _ -> false
    | _ -> true
  ;;

  let should_save = function
    | RSP -> false
    | reg -> is_physical reg
  ;;

  include functor Comparable.Make
  include functor Hashable.Make
end

module Class = struct
  type t =
    | I64
    | F64
  [@@deriving sexp, equal, compare, hash, variants]

  let arguments ?(call_conv = Call_conv.default) t : Raw.t list =
    match t, call_conv with
    | I64, Default -> [ RDI; RSI; RDX; RCX; R8; R9 ]
    | F64, Default -> [ XMM0; XMM1; XMM2; XMM3; XMM4; XMM5; XMM6; XMM7 ]
  ;;

  let callee_saved ?(call_conv = Call_conv.default) t : Raw.t list =
    match t, call_conv with
    | I64, Default -> [ RBX; RSP; RBP; R12; R13; R14; R15 ]
    | F64, Default -> []
  ;;

  let results ?(call_conv = Call_conv.default) t : Raw.t list =
    match t, call_conv with
    | I64, Default -> [ RAX; RDX ]
    | F64, Default -> [ XMM0; XMM1 ]
  ;;
end

type t =
  { reg : Raw.t
  ; class_ : Class.t
  }
[@@deriving sexp, equal, compare, hash]

let raw t = t.reg
let class_ t = t.class_

let rec default_class = function
  | Raw.XMM0
  | Raw.XMM1
  | Raw.XMM2
  | Raw.XMM3
  | Raw.XMM4
  | Raw.XMM5
  | Raw.XMM6
  | Raw.XMM7
  | Raw.XMM8
  | Raw.XMM9
  | Raw.XMM10
  | Raw.XMM11
  | Raw.XMM12
  | Raw.XMM13
  | Raw.XMM14
  | Raw.XMM15 -> Class.F64
  | Raw.Allocated (_, Some forced) -> default_class forced
  | _ -> Class.I64
;;

let make ?class_ reg =
  let class_ = Option.value class_ ~default:(default_class reg) in
  { reg; class_ }
;;

let physical ?class_ reg = make ?class_ reg
let is_physical t = Raw.is_physical t.reg
let should_save t = Raw.should_save t.reg
let with_class t class_ = { t with class_ }
let with_raw t reg = { reg; class_ = t.class_ }

let unallocated ?(class_ = Class.I64) var =
  { reg = Raw.Unallocated var; class_ }
;;

let allocated ?class_ var forced =
  let class_ =
    match class_, forced with
    | Some class_, _ -> class_
    | None, Some reg -> reg.class_
    | None, None -> Class.I64
  in
  let forced = Option.map forced ~f:raw in
  { reg = Raw.Allocated (var, forced); class_ }
;;

let arguments ?(call_conv = Call_conv.default) class_ =
  Class.arguments ~call_conv class_ |> List.map ~f:(physical ~class_)
;;

let results ?(call_conv = Call_conv.default) class_ =
  Class.results ~call_conv class_ |> List.map ~f:(physical ~class_)
;;

let callee_saved ?(call_conv = Call_conv.default) class_ =
  Class.callee_saved ~call_conv class_ |> List.map ~f:(physical ~class_)
;;

let all_physical = Array.map Raw.all_physical ~f:make
let gp raw = physical ~class_:Class.I64 raw
let xmm raw = physical ~class_:Class.F64 raw
let rbp = gp Raw.RBP
let rsp = gp Raw.RSP
let rax = gp Raw.RAX
let rbx = gp Raw.RBX
let rcx = gp Raw.RCX
let rdx = gp Raw.RDX
let rsi = gp Raw.RSI
let rdi = gp Raw.RDI
let r8 = gp Raw.R8
let r9 = gp Raw.R9
let r10 = gp Raw.R10
let r11 = gp Raw.R11
let r12 = gp Raw.R12
let r13 = gp Raw.R13
let r14 = gp Raw.R14
let r15 = gp Raw.R15
let xmm0 = xmm Raw.XMM0
let xmm1 = xmm Raw.XMM1
let xmm2 = xmm Raw.XMM2
let xmm3 = xmm Raw.XMM3
let xmm4 = xmm Raw.XMM4
let xmm5 = xmm Raw.XMM5
let xmm6 = xmm Raw.XMM6
let xmm7 = xmm Raw.XMM7
let xmm8 = xmm Raw.XMM8
let xmm9 = xmm Raw.XMM9
let xmm10 = xmm Raw.XMM10
let xmm11 = xmm Raw.XMM11
let xmm12 = xmm Raw.XMM12
let xmm13 = xmm Raw.XMM13
let xmm14 = xmm Raw.XMM14
let xmm15 = xmm Raw.XMM15

include functor Comparable.Make
include functor Hashable.Make
