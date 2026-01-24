open! Core
open! Import

module Rmw_op = struct
  type t =
    | Xchg
    | Add
    | Sub
    | And
    | Or
    | Xor
  [@@deriving sexp, compare, equal, hash]
end

type arith =
  { dest : Var.t
  ; src1 : Lit_or_var.t
  ; src2 : Lit_or_var.t
  }
[@@deriving sexp, compare, equal, hash]

let map_arith_defs t ~f = { t with dest = f t.dest }

let map_arith_uses t ~f =
  { t with
    src1 = Lit_or_var.map_vars ~f t.src1
  ; src2 = Lit_or_var.map_vars ~f t.src2
  }
;;

let map_arith_lit_or_vars t ~f = { t with src1 = f t.src1; src2 = f t.src2 }

type alloca =
  { dest : Var.t
  ; size : Lit_or_var.t
  }
[@@deriving sexp, compare, equal, hash]

let map_alloca_defs t ~f = { t with dest = f t.dest }
let map_alloca_uses t ~f = { t with size = Lit_or_var.map_vars ~f t.size }
let map_alloca_lit_or_vars t ~f = { t with size = f t.size }

type load_field =
  { dest : Var.t
  ; base : Lit_or_var.t
  ; type_ : Type.t
  ; indices : int list
  }
[@@deriving sexp, compare, equal, hash]

type store_field =
  { base : Lit_or_var.t
  ; src : Lit_or_var.t
  ; type_ : Type.t
  ; indices : int list
  }
[@@deriving sexp, compare, equal, hash]

type memcpy =
  { dest : Lit_or_var.t
  ; src : Lit_or_var.t
  ; type_ : Type.t
  }
[@@deriving sexp, compare, equal, hash]

type atomic_load =
  { dest : Var.t
  ; addr : Mem.t
  ; order : Memory_order.t
  }
[@@deriving sexp, compare, equal, hash]

type atomic_store =
  { addr : Mem.t
  ; src : Lit_or_var.t
  ; order : Memory_order.t
  }
[@@deriving sexp, compare, equal, hash]

type atomic_rmw =
  { dest : Var.t
  ; addr : Mem.t
  ; src : Lit_or_var.t
  ; op : Rmw_op.t
  ; order : Memory_order.t
  }
[@@deriving sexp, compare, equal, hash]

type atomic_cmpxchg =
  { dest : Var.t (* returns old value *)
  ; success : Var.t (* 1 if succeeded, 0 if failed *)
  ; addr : Mem.t
  ; expected : Lit_or_var.t
  ; desired : Lit_or_var.t
  ; success_order : Memory_order.t
  ; failure_order : Memory_order.t
  }
[@@deriving sexp, compare, equal, hash]

let map_load_field_defs (t : load_field) ~f = { t with dest = f t.dest }

let map_load_field_uses (t : load_field) ~f =
  { t with base = Lit_or_var.map_vars t.base ~f }
;;

let map_load_field_lit_or_vars (t : load_field) ~f = { t with base = f t.base }

let map_store_field_uses (t : store_field) ~f =
  { t with
    base = Lit_or_var.map_vars t.base ~f
  ; src = Lit_or_var.map_vars t.src ~f
  }
;;

let map_store_field_lit_or_vars (t : store_field) ~f =
  { t with base = f t.base; src = f t.src }
;;

let map_memcpy_uses (t : memcpy) ~f =
  { t with
    dest = Lit_or_var.map_vars t.dest ~f
  ; src = Lit_or_var.map_vars t.src ~f
  }
;;

let map_memcpy_lit_or_vars (t : memcpy) ~f =
  { t with dest = f t.dest; src = f t.src }
;;

let map_atomic_load_defs (t : atomic_load) ~f = { t with dest = f t.dest }

let map_atomic_load_uses (t : atomic_load) ~f =
  { t with addr = Mem.map_vars t.addr ~f }
;;

let map_atomic_store_uses (t : atomic_store) ~f =
  { t with addr = Mem.map_vars t.addr ~f; src = Lit_or_var.map_vars t.src ~f }
;;

let map_atomic_store_lit_or_vars (t : atomic_store) ~f =
  { t with src = f t.src; addr = Mem.map_lit_or_vars t.addr ~f }
;;

let map_atomic_rmw_defs (t : atomic_rmw) ~f = { t with dest = f t.dest }

let map_atomic_rmw_uses (t : atomic_rmw) ~f =
  { t with addr = Mem.map_vars t.addr ~f; src = Lit_or_var.map_vars t.src ~f }
;;

let map_atomic_rmw_lit_or_vars (t : atomic_rmw) ~f =
  { t with src = f t.src; addr = Mem.map_lit_or_vars t.addr ~f }
;;

let map_atomic_cmpxchg_defs (t : atomic_cmpxchg) ~f =
  { t with dest = f t.dest; success = f t.success }
;;

let map_atomic_cmpxchg_uses (t : atomic_cmpxchg) ~f =
  { t with
    addr = Mem.map_vars t.addr ~f
  ; expected = Lit_or_var.map_vars t.expected ~f
  ; desired = Lit_or_var.map_vars t.desired ~f
  }
;;

let map_atomic_cmpxchg_lit_or_vars (t : atomic_cmpxchg) ~f =
  { t with
    expected = f t.expected
  ; desired = f t.desired
  ; addr = Mem.map_lit_or_vars t.addr ~f
  }
;;
