open! Core
open! Import

module Class : sig
  type t =
    | I64
    | F64
  [@@deriving sexp, equal, compare, hash, variants, enumerate]

  val bytes : t -> int
end

module Raw : sig
  type 'var t =
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
    | Unallocated of 'var
    | Allocated of 'var * 'var t option
  [@@deriving sexp, equal, compare, hash, variants]

  val all_physical : 'var t list
  val to_physical : 'var t -> 'var t option
  val should_save : 'var t -> 'var t option
  val phys_reg_limit : int
  val class_ : 'var t -> [ `Physical of Class.t | `Variable ]
  val to_id : var_id:('var -> int) -> 'var t -> int
  val of_id : id_var:(int -> 'var) -> int -> 'var t
  val map_vars : 'var t -> f:('var -> 'var2) -> 'var2 t
end

type 'var t =
  { reg : 'var Raw.t
  ; class_ : Class.t
  }
[@@deriving sexp, equal, compare, hash]

val raw : 'var t -> 'var Raw.t
val class_ : 'var t -> Class.t
val create : class_:Class.t -> raw:'var Raw.t -> 'var t
val should_save : 'var t -> 'var Raw.t option
val with_class : 'var t -> Class.t -> 'var t
val with_raw : 'var t -> 'var Raw.t -> 'var t
val unallocated : ?class_:Class.t -> 'var -> 'var t
val allocated : class_:Class.t -> 'var -> 'var t option -> 'var t
val sp : 'var t
val fp : 'var t
val lr : 'var t
val x0 : 'var t
val x1 : 'var t
val x2 : 'var t
val x3 : 'var t
val x4 : 'var t
val x5 : 'var t
val x6 : 'var t
val x7 : 'var t
val x8 : 'var t
val x9 : 'var t
val x10 : 'var t
val x11 : 'var t
val x12 : 'var t
val x13 : 'var t
val x14 : 'var t
val x15 : 'var t
val x16 : 'var t
val x17 : 'var t
val x18 : 'var t
val x19 : 'var t
val x20 : 'var t
val x21 : 'var t
val x22 : 'var t
val x23 : 'var t
val x24 : 'var t
val x25 : 'var t
val x26 : 'var t
val x27 : 'var t
val x28 : 'var t
val x29 : 'var t
val x30 : 'var t
val d0 : 'var t
val d1 : 'var t
val d2 : 'var t
val d3 : 'var t
val d4 : 'var t
val d5 : 'var t
val d6 : 'var t
val d7 : 'var t
val d8 : 'var t
val d9 : 'var t
val d10 : 'var t
val d11 : 'var t
val d12 : 'var t
val d13 : 'var t
val d14 : 'var t
val d15 : 'var t
val d16 : 'var t
val d17 : 'var t
val d18 : 'var t
val d19 : 'var t
val d20 : 'var t
val d21 : 'var t
val d22 : 'var t
val d23 : 'var t
val d24 : 'var t
val d25 : 'var t
val d26 : 'var t
val d27 : 'var t
val d28 : 'var t
val d29 : 'var t
val d30 : 'var t
val d31 : 'var t
val arguments : call_conv:Call_conv.t -> Class.t -> 'var t list
val callee_saved : call_conv:Call_conv.t -> Class.t -> 'var t list
val results : call_conv:Call_conv.t -> Class.t -> 'var t list
val all_physical : 'var t list
val scratch : class_:Class.t -> 'var t list
val allocable : class_:Class.t -> 'var t list
val map_vars : 'var t -> f:('var -> 'var2) -> 'var2 t
