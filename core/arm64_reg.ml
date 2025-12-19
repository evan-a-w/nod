open Core

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
    [| SP
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
    |]
  ;;

  let is_physical = function
    | Unallocated _ | Allocated _ -> false
    | _ -> true
  ;;

  let should_save = function
    | SP -> false
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
    | I64, Default -> [ X0; X1; X2; X3; X4; X5; X6; X7 ]
    | F64, Default -> [ V0; V1; V2; V3; V4; V5; V6; V7 ]
  ;;

  let callee_saved ?(call_conv = Call_conv.default) t : Raw.t list =
    match t, call_conv with
    | I64, Default -> [ X19; X20; X21; X22; X23; X24; X25; X26; X27; X28; X29 ]
    | F64, Default -> [ V8; V9; V10; V11; V12; V13; V14; V15 ]
  ;;

  let results ?(call_conv = Call_conv.default) t : Raw.t list =
    match t, call_conv with
    | I64, Default -> [ X0; X1 ]
    | F64, Default -> [ V0; V1 ]
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
  | Raw.V0
  | Raw.V1
  | Raw.V2
  | Raw.V3
  | Raw.V4
  | Raw.V5
  | Raw.V6
  | Raw.V7
  | Raw.V8
  | Raw.V9
  | Raw.V10
  | Raw.V11
  | Raw.V12
  | Raw.V13
  | Raw.V14
  | Raw.V15
  | Raw.V16
  | Raw.V17
  | Raw.V18
  | Raw.V19
  | Raw.V20
  | Raw.V21
  | Raw.V22
  | Raw.V23
  | Raw.V24
  | Raw.V25
  | Raw.V26
  | Raw.V27
  | Raw.V28
  | Raw.V29
  | Raw.V30
  | Raw.V31 -> Class.F64
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

let unallocated ?(class_ = Class.I64) var = { reg = Raw.Unallocated var; class_ }

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
let vec raw = physical ~class_:Class.F64 raw

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

include functor Comparable.Make
include functor Hashable.Make
