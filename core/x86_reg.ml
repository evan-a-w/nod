open Core

module Class = struct
  type t =
    | I64
    | F64
  [@@deriving sexp, equal, compare, hash, variants, enumerate]
end

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
    [ RBP
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
    ]
  ;;

  let rec to_physical = function
    | Allocated (_, None) | Unallocated _ -> None
    | Allocated (_, Some reg) -> to_physical reg
    | other -> Some other
  ;;

  let should_save = function
    | RSP -> None
    | other -> to_physical other
  ;;

  let phys_reg_limit = List.length all_physical

  let rec class_ = function
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
    | XMM15 -> `Physical Class.F64
    | Allocated (_, Some forced) -> class_ forced
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
    | R15 -> `Physical Class.I64
    | Unallocated _ | Allocated (_, _) -> `Variable
  ;;

  let to_id ~var_id t =
    match t with
    | RBP -> 0
    | RSP -> 1
    | RAX -> 2
    | RBX -> 3
    | RCX -> 4
    | RDX -> 5
    | RSI -> 6
    | RDI -> 7
    | R8 -> 8
    | R9 -> 9
    | R10 -> 10
    | R11 -> 11
    | R12 -> 12
    | R13 -> 13
    | R14 -> 14
    | R15 -> 15
    | XMM0 -> 16
    | XMM1 -> 17
    | XMM2 -> 18
    | XMM3 -> 19
    | XMM4 -> 20
    | XMM5 -> 21
    | XMM6 -> 22
    | XMM7 -> 23
    | XMM8 -> 24
    | XMM9 -> 25
    | XMM10 -> 26
    | XMM11 -> 27
    | XMM12 -> 28
    | XMM13 -> 29
    | XMM14 -> 30
    | XMM15 -> 31
    | Unallocated var | Allocated (var, _) -> phys_reg_limit + var_id var
  ;;

  let of_id ~id_var id =
    match id with
    | 0 -> rbp
    | 1 -> rsp
    | 2 -> rax
    | 3 -> rbx
    | 4 -> rcx
    | 5 -> rdx
    | 6 -> rsi
    | 7 -> rdi
    | 8 -> r8
    | 9 -> r9
    | 10 -> r10
    | 11 -> r11
    | 12 -> r12
    | 13 -> r13
    | 14 -> r14
    | 15 -> r15
    | 16 -> xmm0
    | 17 -> xmm1
    | 18 -> xmm2
    | 19 -> xmm3
    | 20 -> xmm4
    | 21 -> xmm5
    | 22 -> xmm6
    | 23 -> xmm7
    | 24 -> xmm8
    | 25 -> xmm9
    | 26 -> xmm10
    | 27 -> xmm11
    | 28 -> xmm12
    | 29 -> xmm13
    | 30 -> xmm14
    | 31 -> xmm15
    | other ->
      let id = other - phys_reg_limit in
      unallocated (id_var id)
  ;;

  include functor Comparable.Make
  include functor Hashable.Make
end

type t =
  { reg : Raw.t
  ; class_ : Class.t
  }
[@@deriving sexp, equal, compare, hash]

let raw t = t.reg
let class_ t = t.class_
let create ~class_ ~raw = { reg = raw; class_ }
let should_save t = Raw.should_save t.reg
let with_class t class_ = { t with class_ }
let with_raw t reg = { reg; class_ = t.class_ }

let unallocated ?(class_ = Class.I64) var =
  { reg = Raw.Unallocated var; class_ }
;;

let gp raw = create ~class_:Class.I64 ~raw
let xmm raw = create ~class_:Class.F64 ~raw
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

let arguments ~(call_conv : Call_conv.t) (class_ : Class.t) =
  match class_, call_conv with
  | I64, Default -> [ rdi; rsi; rdx; rcx; r8; r9 ]
  | F64, Default -> [ xmm0; xmm1; xmm2; xmm3; xmm4; xmm5; xmm6; xmm7 ]
;;

let callee_saved ~(call_conv : Call_conv.t) (class_ : Class.t) =
  match class_, call_conv with
  | I64, Call_conv.Default -> [ rbx; rsp; rbp; r12; r13; r14; r15 ]
  | F64, Default -> []
;;

let results ~(call_conv : Call_conv.t) (class_ : Class.t) =
  match class_, call_conv with
  | I64, Default -> [ rax; rdx ]
  | F64, Default -> [ xmm0; xmm1 ]
;;

let allocated ~class_ var forced =
  let forced = Option.map forced ~f:raw in
  { reg = Raw.Allocated (var, forced); class_ }
;;

let all_physical =
  [ rbp
  ; rsp
  ; rax
  ; rbx
  ; rcx
  ; rdx
  ; rsi
  ; rdi
  ; r8
  ; r9
  ; r10
  ; r11
  ; r12
  ; r13
  ; r14
  ; r15
  ; xmm0
  ; xmm1
  ; xmm2
  ; xmm3
  ; xmm4
  ; xmm5
  ; xmm6
  ; xmm7
  ; xmm8
  ; xmm9
  ; xmm10
  ; xmm11
  ; xmm12
  ; xmm13
  ; xmm14
  ; xmm15
  ]
;;

include functor Comparable.Make
include functor Hashable.Make
