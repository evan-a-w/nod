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
val rbp : 'var t
val rsp : 'var t
val rax : 'var t
val rbx : 'var t
val rcx : 'var t
val rdx : 'var t
val rsi : 'var t
val rdi : 'var t
val r8 : 'var t
val r9 : 'var t
val r10 : 'var t
val r11 : 'var t
val r12 : 'var t
val r13 : 'var t
val r14 : 'var t
val r15 : 'var t
val xmm0 : 'var t
val xmm1 : 'var t
val xmm2 : 'var t
val xmm3 : 'var t
val xmm4 : 'var t
val xmm5 : 'var t
val xmm6 : 'var t
val xmm7 : 'var t
val xmm8 : 'var t
val xmm9 : 'var t
val xmm10 : 'var t
val xmm11 : 'var t
val xmm12 : 'var t
val xmm13 : 'var t
val xmm14 : 'var t
val xmm15 : 'var t
val arguments : call_conv:Call_conv.t -> Class.t -> 'var t list
val callee_saved : call_conv:Call_conv.t -> Class.t -> 'var t list
val results : call_conv:Call_conv.t -> Class.t -> 'var t list
val all_physical : 'var t list
val allocable : class_:Class.t -> 'var t list
val map_vars : 'var t -> f:('var -> 'var2) -> 'var2 t
