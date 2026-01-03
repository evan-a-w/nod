open Core

module Class = struct
  type t =
    | I64
    | F64
  [@@deriving sexp, equal, compare, hash, variants, enumerate]

  let bytes = function
    | I64 | F64 -> 8
  ;;
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
    | D0
    | D1
    | D2
    | D3
    | D4
    | D5
    | D6
    | D7
    | D8
    | D9
    | D10
    | D11
    | D12
    | D13
    | D14
    | D15
    | D16
    | D17
    | D18
    | D19
    | D20
    | D21
    | D22
    | D23
    | D24
    | D25
    | D26
    | D27
    | D28
    | D29
    | D30
    | D31
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
    ; D0
    ; D1
    ; D2
    ; D3
    ; D4
    ; D5
    ; D6
    ; D7
    ; D8
    ; D9
    ; D10
    ; D11
    ; D12
    ; D13
    ; D14
    ; D15
    ; D16
    ; D17
    ; D18
    ; D19
    ; D20
    ; D21
    ; D22
    ; D23
    ; D24
    ; D25
    ; D26
    ; D27
    ; D28
    ; D29
    ; D30
    ; D31
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
    | D0
    | D1
    | D2
    | D3
    | D4
    | D5
    | D6
    | D7
    | D8
    | D9
    | D10
    | D11
    | D12
    | D13
    | D14
    | D15
    | D16
    | D17
    | D18
    | D19
    | D20
    | D21
    | D22
    | D23
    | D24
    | D25
    | D26
    | D27
    | D28
    | D29
    | D30
    | D31 -> `Physical Class.F64
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
    | D0 -> 32
    | D1 -> 33
    | D2 -> 34
    | D3 -> 35
    | D4 -> 36
    | D5 -> 37
    | D6 -> 38
    | D7 -> 39
    | D8 -> 40
    | D9 -> 41
    | D10 -> 42
    | D11 -> 43
    | D12 -> 44
    | D13 -> 45
    | D14 -> 46
    | D15 -> 47
    | D16 -> 48
    | D17 -> 49
    | D18 -> 50
    | D19 -> 51
    | D20 -> 52
    | D21 -> 53
    | D22 -> 54
    | D23 -> 55
    | D24 -> 56
    | D25 -> 57
    | D26 -> 58
    | D27 -> 59
    | D28 -> 60
    | D29 -> 61
    | D30 -> 62
    | D31 -> 63
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
    | 32 -> d0
    | 33 -> d1
    | 34 -> d2
    | 35 -> d3
    | 36 -> d4
    | 37 -> d5
    | 38 -> d6
    | 39 -> d7
    | 40 -> d8
    | 41 -> d9
    | 42 -> d10
    | 43 -> d11
    | 44 -> d12
    | 45 -> d13
    | 46 -> d14
    | 47 -> d15
    | 48 -> d16
    | 49 -> d17
    | 50 -> d18
    | 51 -> d19
    | 52 -> d20
    | 53 -> d21
    | 54 -> d22
    | 55 -> d23
    | 56 -> d24
    | 57 -> d25
    | 58 -> d26
    | 59 -> d27
    | 60 -> d28
    | 61 -> d29
    | 62 -> d30
    | 63 -> d31
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
let d0 = vec Raw.D0
let d1 = vec Raw.D1
let d2 = vec Raw.D2
let d3 = vec Raw.D3
let d4 = vec Raw.D4
let d5 = vec Raw.D5
let d6 = vec Raw.D6
let d7 = vec Raw.D7
let d8 = vec Raw.D8
let d9 = vec Raw.D9
let d10 = vec Raw.D10
let d11 = vec Raw.D11
let d12 = vec Raw.D12
let d13 = vec Raw.D13
let d14 = vec Raw.D14
let d15 = vec Raw.D15
let d16 = vec Raw.D16
let d17 = vec Raw.D17
let d18 = vec Raw.D18
let d19 = vec Raw.D19
let d20 = vec Raw.D20
let d21 = vec Raw.D21
let d22 = vec Raw.D22
let d23 = vec Raw.D23
let d24 = vec Raw.D24
let d25 = vec Raw.D25
let d26 = vec Raw.D26
let d27 = vec Raw.D27
let d28 = vec Raw.D28
let d29 = vec Raw.D29
let d30 = vec Raw.D30
let d31 = vec Raw.D31

let arguments ~(call_conv : Call_conv.t) (class_ : Class.t) =
  match class_, call_conv with
  | I64, Default -> [ x0; x1; x2; x3; x4; x5; x6; x7 ]
  | F64, Default -> [ d0; d1; d2; d3; d4; d5; d6; d7 ]
;;

let callee_saved ~(call_conv : Call_conv.t) (class_ : Class.t) =
  match class_, call_conv with
  | I64, Default -> [ x19; x20; x21; x22; x23; x24; x25; x26; x27; x28; fp ]
  | F64, Default -> [ d8; d9; d10; d11; d12; d13; d14; d15 ]
;;

let results ~(call_conv : Call_conv.t) (class_ : Class.t) =
  match class_, call_conv with
  | I64, Default -> [ x0; x1 ]
  | F64, Default -> [ d0; d1 ]
;;

let all_physical =
  List.map Raw.all_physical ~f:(fun raw ->
    match Raw.class_ raw with
    | `Physical class_ -> create ~class_ ~raw
    | `Variable -> failwith "raw register should be physical")
;;

let scratch ~class_ =
  match class_ with
  | Class.I64 -> [ x14; x15; x16 ]
  | Class.F64 -> [ d29; d30; d31 ]
;;

let allocable ~class_ =
  match class_ with
  | Class.I64 ->
    [ x0
    ; x1
    ; x2
    ; x3
    ; x4
    ; x5
    ; x6
    ; x7
    ; x8
    ; x9
    ; x10
    ; x11
    ; x12
    ; x13
    ; x17
    ; x19
    ; x20
    ; x21
    ; x22
    ; x23
    ; x24
    ; x25
    ; x26
    ; x27
    ; x28
    ]
  | Class.F64 ->
    [ d0
    ; d1
    ; d2
    ; d3
    ; d4
    ; d5
    ; d6
    ; d7
    ; d8
    ; d9
    ; d10
    ; d11
    ; d12
    ; d13
    ; d14
    ; d15
    ; d16
    ; d17
    ; d18
    ; d19
    ; d20
    ; d21
    ; d22
    ; d23
    ; d24
    ; d25
    ; d26
    ; d27
    ; d28
    ]
;;

include functor Comparable.Make
include functor Hashable.Make
