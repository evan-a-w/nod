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

  let should_save reg =
    match reg with
    | RSP -> false
    | _ -> is_physical reg
  ;;

  include functor Comparable.Make
  include functor Hashable.Make
end

module Class = struct
  type t =
    | I64
    | F64
  [@@deriving sexp, equal, compare, hash, variants]

  let arguments ?(call_conv = Call_conv.default) t : Reg.t list =
    match t, call_conv with
    | I64, Default -> [ RDI; RSI; RDX; RCX; R8; R9 ]
    | F64, Default -> [ XMM0; XMM1; XMM2; XMM3; XMM4; XMM5; XMM6; XMM7 ]
  ;;

  let callee_saved ?(call_conv = Call_conv.default) t : Reg.t list =
    match t, call_conv with
    | I64, Default -> [ RBX; RSP; RBP; R12; R13; R14; R15 ]
    | F64, Default -> []
  ;;

  let results ?(call_conv = Call_conv.default) t : Reg.t list =
    match t, call_conv with
    | I64, Default -> [ RAX; RDX ]
    | F64, Default -> [ XMM0; XMM1 ]
  ;;
end

type t =
  { reg : Reg.t
  ; class_ : Class.t
  }
[@@deriving sexp, equal, compare, hash]

include functor Comparable.Make
include functor Hashable.Make
