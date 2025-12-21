open Core

module Class = struct
  type t =
    | I64
    | F64
  [@@deriving sexp, equal, compare, hash, variants, enumerate]
end

module Raw = struct
  type t =
    | SP
    | X0
    | X1
    | X2
    | X3
    | X4
    | X5
    | X6
    | X7
    | X8
    | X9
    | X10
    | X11
    | X12
    | X13
    | X14
    | X15
    | X16
    | X17
    | X18
    | X19
    | X20
    | X21
    | X22
    | X23
    | X24
    | X25
    | X26
    | X27
    | X28
    | X29
    | X30
    | V0
    | V1
    | V2
    | V3
    | V4
    | V5
    | V6
    | V7
    | V8
    | V9
    | V10
    | V11
    | V12
    | V13
    | V14
    | V15
    | V16
    | V17
    | V18
    | V19
    | V20
    | V21
    | V22
    | V23
    | V24
    | V25
    | V26
    | V27
    | V28
    | V29
    | V30
    | V31
    | Unallocated of Var.t
    | Allocated of Var.t * t option
  [@@deriving sexp, equal, compare, hash, variants]

  let all_physical =
    [ SP
    ; X0
    ; X1
    ; X2
    ; X3
    ; X4
    ; X5
    ; X6
    ; X7
    ; X8
    ; X9
    ; X10
    ; X11
    ; X12
    ; X13
    ; X14
    ; X15
    ; X16
    ; X17
    ; X18
    ; X19
    ; X20
    ; X21
    ; X22
    ; X23
    ; X24
    ; X25
    ; X26
    ; X27
    ; X28
    ; X29
    ; X30
    ; V0
    ; V1
    ; V2
    ; V3
    ; V4
    ; V5
    ; V6
    ; V7
    ; V8
    ; V9
    ; V10
    ; V11
    ; V12
    ; V13
    ; V14
    ; V15
    ; V16
    ; V17
    ; V18
    ; V19
    ; V20
    ; V21
    ; V22
    ; V23
    ; V24
    ; V25
    ; V26
    ; V27
    ; V28
    ; V29
    ; V30
    ; V31
    ]
  ;;

  let rec to_physical = function
    | Allocated (_, None) | Unallocated _ -> None
    | Allocated (_, Some reg) -> to_physical reg
    | other -> Some other
  ;;

  let should_save = function
    | SP -> None
    | other -> to_physical other
  ;;

  let phys_reg_limit = List.length all_physical

  let rec class_ = function
    | V0
    | V1
    | V2
    | V3
    | V4
    | V5
    | V6
    | V7
    | V8
    | V9
    | V10
    | V11
    | V12
    | V13
    | V14
    | V15
    | V16
    | V17
    | V18
    | V19
    | V20
    | V21
    | V22
    | V23
    | V24
    | V25
    | V26
    | V27
    | V28
    | V29
    | V30
    | V31 -> `Physical Class.F64
    | Allocated (_, Some forced) -> class_ forced
    | SP
    | X0
    | X1
    | X2
    | X3
    | X4
    | X5
    | X6
    | X7
    | X8
    | X9
    | X10
    | X11
    | X12
    | X13
    | X14
    | X15
    | X16
    | X17
    | X18
    | X19
    | X20
    | X21
    | X22
    | X23
    | X24
    | X25
    | X26
    | X27
    | X28
    | X29
    | X30 -> `Physical Class.I64
    | Unallocated _ | Allocated (_, _) -> `Variable
  ;;

  let to_id ~var_id = function
    | SP -> 0
    | X0 -> 1
    | X1 -> 2
    | X2 -> 3
    | X3 -> 4
    | X4 -> 5
    | X5 -> 6
    | X6 -> 7
    | X7 -> 8
    | X8 -> 9
    | X9 -> 10
    | X10 -> 11
    | X11 -> 12
    | X12 -> 13
    | X13 -> 14
    | X14 -> 15
    | X15 -> 16
    | X16 -> 17
    | X17 -> 18
    | X18 -> 19
    | X19 -> 20
    | X20 -> 21
    | X21 -> 22
    | X22 -> 23
    | X23 -> 24
    | X24 -> 25
    | X25 -> 26
    | X26 -> 27
    | X27 -> 28
    | X28 -> 29
    | X29 -> 30
    | X30 -> 31
    | V0 -> 32
    | V1 -> 33
    | V2 -> 34
    | V3 -> 35
    | V4 -> 36
    | V5 -> 37
    | V6 -> 38
    | V7 -> 39
    | V8 -> 40
    | V9 -> 41
    | V10 -> 42
    | V11 -> 43
    | V12 -> 44
    | V13 -> 45
    | V14 -> 46
    | V15 -> 47
    | V16 -> 48
    | V17 -> 49
    | V18 -> 50
    | V19 -> 51
    | V20 -> 52
    | V21 -> 53
    | V22 -> 54
    | V23 -> 55
    | V24 -> 56
    | V25 -> 57
    | V26 -> 58
    | V27 -> 59
    | V28 -> 60
    | V29 -> 61
    | V30 -> 62
    | V31 -> 63
    | Unallocated var | Allocated (var, _) -> phys_reg_limit + var_id var
  ;;

  let of_id ~id_var id =
    match id with
    | 0 -> sp
    | 1 -> x0
    | 2 -> x1
    | 3 -> x2
    | 4 -> x3
    | 5 -> x4
    | 6 -> x5
    | 7 -> x6
    | 8 -> x7
    | 9 -> x8
    | 10 -> x9
    | 11 -> x10
    | 12 -> x11
    | 13 -> x12
    | 14 -> x13
    | 15 -> x14
    | 16 -> x15
    | 17 -> x16
    | 18 -> x17
    | 19 -> x18
    | 20 -> x19
    | 21 -> x20
    | 22 -> x21
    | 23 -> x22
    | 24 -> x23
    | 25 -> x24
    | 26 -> x25
    | 27 -> x26
    | 28 -> x27
    | 29 -> x28
    | 30 -> x29
    | 31 -> x30
    | 32 -> v0
    | 33 -> v1
    | 34 -> v2
    | 35 -> v3
    | 36 -> v4
    | 37 -> v5
    | 38 -> v6
    | 39 -> v7
    | 40 -> v8
    | 41 -> v9
    | 42 -> v10
    | 43 -> v11
    | 44 -> v12
    | 45 -> v13
    | 46 -> v14
    | 47 -> v15
    | 48 -> v16
    | 49 -> v17
    | 50 -> v18
    | 51 -> v19
    | 52 -> v20
    | 53 -> v21
    | 54 -> v22
    | 55 -> v23
    | 56 -> v24
    | 57 -> v25
    | 58 -> v26
    | 59 -> v27
    | 60 -> v28
    | 61 -> v29
    | 62 -> v30
    | 63 -> v31
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

let allocated ~class_ var forced =
  let forced = Option.map forced ~f:raw in
  { reg = Raw.Allocated (var, forced); class_ }
;;

let gp raw = create ~class_:Class.I64 ~raw
let vec raw = create ~class_:Class.F64 ~raw
let sp = gp Raw.SP
let fp = gp Raw.X29
let lr = gp Raw.X30
let x0 = gp Raw.X0
let x1 = gp Raw.X1
let x2 = gp Raw.X2
let x3 = gp Raw.X3
let x4 = gp Raw.X4
let x5 = gp Raw.X5
let x6 = gp Raw.X6
let x7 = gp Raw.X7
let x8 = gp Raw.X8
let x9 = gp Raw.X9
let x10 = gp Raw.X10
let x11 = gp Raw.X11
let x12 = gp Raw.X12
let x13 = gp Raw.X13
let x14 = gp Raw.X14
let x15 = gp Raw.X15
let x16 = gp Raw.X16
let x17 = gp Raw.X17
let x18 = gp Raw.X18
let x19 = gp Raw.X19
let x20 = gp Raw.X20
let x21 = gp Raw.X21
let x22 = gp Raw.X22
let x23 = gp Raw.X23
let x24 = gp Raw.X24
let x25 = gp Raw.X25
let x26 = gp Raw.X26
let x27 = gp Raw.X27
let x28 = gp Raw.X28
let x29 = fp
let x30 = lr
let v0 = vec Raw.V0
let v1 = vec Raw.V1
let v2 = vec Raw.V2
let v3 = vec Raw.V3
let v4 = vec Raw.V4
let v5 = vec Raw.V5
let v6 = vec Raw.V6
let v7 = vec Raw.V7
let v8 = vec Raw.V8
let v9 = vec Raw.V9
let v10 = vec Raw.V10
let v11 = vec Raw.V11
let v12 = vec Raw.V12
let v13 = vec Raw.V13
let v14 = vec Raw.V14
let v15 = vec Raw.V15
let v16 = vec Raw.V16
let v17 = vec Raw.V17
let v18 = vec Raw.V18
let v19 = vec Raw.V19
let v20 = vec Raw.V20
let v21 = vec Raw.V21
let v22 = vec Raw.V22
let v23 = vec Raw.V23
let v24 = vec Raw.V24
let v25 = vec Raw.V25
let v26 = vec Raw.V26
let v27 = vec Raw.V27
let v28 = vec Raw.V28
let v29 = vec Raw.V29
let v30 = vec Raw.V30
let v31 = vec Raw.V31

let arguments ~(call_conv : Call_conv.t) (class_ : Class.t) =
  match class_, call_conv with
  | I64, Default -> [ x0; x1; x2; x3; x4; x5; x6; x7 ]
  | F64, Default -> [ v0; v1; v2; v3; v4; v5; v6; v7 ]
;;

let callee_saved ~(call_conv : Call_conv.t) (class_ : Class.t) =
  match class_, call_conv with
  | I64, Default -> [ x19; x20; x21; x22; x23; x24; x25; x26; x27; x28; fp ]
  | F64, Default -> [ v8; v9; v10; v11; v12; v13; v14; v15 ]
;;

let results ~(call_conv : Call_conv.t) (class_ : Class.t) =
  match class_, call_conv with
  | I64, Default -> [ x0; x1 ]
  | F64, Default -> [ v0; v1 ]
;;

let all_physical =
  List.map Raw.all_physical ~f:(fun raw ->
    match Raw.class_ raw with
    | `Physical class_ -> create ~class_ ~raw
    | `Variable -> failwith "raw register should be physical")
;;

let allocable ~class_ =
  match class_ with
  | Class.I64 -> [ rax; rbx; rcx; rdx; r8; r9; r10; r11; r12; r13; r14; r15 ]
  | Class.F64 ->
    [ xmm0
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
