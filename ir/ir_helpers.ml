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

type 'var arith =
  { dest : 'var
  ; src1 : 'var Lit_or_var.t
  ; src2 : 'var Lit_or_var.t
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

type 'var alloca =
  { dest : 'var
  ; size : 'var Lit_or_var.t
  }
[@@deriving sexp, compare, equal, hash]

let map_alloca_defs t ~f = { t with dest = f t.dest }
let map_alloca_uses t ~f = { t with size = Lit_or_var.map_vars ~f t.size }
let map_alloca_lit_or_vars t ~f = { t with size = f t.size }

type 'var load_field =
  { dest : 'var
  ; base : 'var Lit_or_var.t
  ; type_ : Type.t
  ; indices : int list
  }
[@@deriving sexp, compare, equal, hash]

type 'var store_field =
  { base : 'var Lit_or_var.t
  ; src : 'var Lit_or_var.t
  ; type_ : Type.t
  ; indices : int list
  }
[@@deriving sexp, compare, equal, hash]

type 'var memcpy =
  { dest : 'var Lit_or_var.t
  ; src : 'var Lit_or_var.t
  ; type_ : Type.t
  }
[@@deriving sexp, compare, equal, hash]

type 'var atomic_load =
  { dest : 'var
  ; addr : 'var Mem.t
  ; order : Memory_order.t
  }
[@@deriving sexp, compare, equal, hash]

type 'var atomic_store =
  { addr : 'var Mem.t
  ; src : 'var Lit_or_var.t
  ; order : Memory_order.t
  }
[@@deriving sexp, compare, equal, hash]

type 'var atomic_rmw =
  { dest : 'var
  ; addr : 'var Mem.t
  ; src : 'var Lit_or_var.t
  ; op : Rmw_op.t
  ; order : Memory_order.t
  }
[@@deriving sexp, compare, equal, hash]

type 'var atomic_cmpxchg =
  { dest : 'var (* returns old value *)
  ; success : 'var (* 1 if succeeded, 0 if failed *)
  ; addr : 'var Mem.t
  ; expected : 'var Lit_or_var.t
  ; desired : 'var Lit_or_var.t
  ; success_order : Memory_order.t
  ; failure_order : Memory_order.t
  }
[@@deriving sexp, compare, equal, hash]

let map_load_field_defs (t : 'var load_field) ~f = { t with dest = f t.dest }

let map_load_field_uses (t : 'var load_field) ~f =
  { t with base = Lit_or_var.map_vars t.base ~f }
;;

let map_load_field_lit_or_vars (t : 'var load_field) ~f =
  { t with base = f t.base }
;;

let map_store_field_uses (t : 'var store_field) ~f =
  { t with
    base = Lit_or_var.map_vars t.base ~f
  ; src = Lit_or_var.map_vars t.src ~f
  }
;;

let map_store_field_lit_or_vars (t : 'var store_field) ~f =
  { t with base = f t.base; src = f t.src }
;;

let map_memcpy_uses (t : 'var memcpy) ~f =
  { t with
    dest = Lit_or_var.map_vars t.dest ~f
  ; src = Lit_or_var.map_vars t.src ~f
  }
;;

let map_memcpy_lit_or_vars (t : 'var memcpy) ~f =
  { t with dest = f t.dest; src = f t.src }
;;

let map_atomic_load_defs (t : 'var atomic_load) ~f = { t with dest = f t.dest }

let map_atomic_load_uses (t : 'var atomic_load) ~f =
  { t with addr = Mem.map_vars t.addr ~f }
;;

let map_atomic_store_uses (t : 'var atomic_store) ~f =
  { t with addr = Mem.map_vars t.addr ~f; src = Lit_or_var.map_vars t.src ~f }
;;

let map_atomic_store_lit_or_vars (t : 'var atomic_store) ~f =
  { t with src = f t.src; addr = Mem.map_lit_or_vars t.addr ~f }
;;

let map_atomic_rmw_defs (t : 'var atomic_rmw) ~f = { t with dest = f t.dest }

let map_atomic_rmw_uses (t : 'var atomic_rmw) ~f =
  { t with addr = Mem.map_vars t.addr ~f; src = Lit_or_var.map_vars t.src ~f }
;;

let map_atomic_rmw_lit_or_vars (t : 'var atomic_rmw) ~f =
  { t with src = f t.src; addr = Mem.map_lit_or_vars t.addr ~f }
;;

let map_atomic_cmpxchg_defs (t : 'var atomic_cmpxchg) ~f =
  { t with dest = f t.dest; success = f t.success }
;;

let map_atomic_cmpxchg_uses (t : 'var atomic_cmpxchg) ~f =
  { t with
    addr = Mem.map_vars t.addr ~f
  ; expected = Lit_or_var.map_vars t.expected ~f
  ; desired = Lit_or_var.map_vars t.desired ~f
  }
;;

let map_atomic_cmpxchg_lit_or_vars (t : 'var atomic_cmpxchg) ~f =
  { t with
    expected = f t.expected
  ; desired = f t.desired
  ; addr = Mem.map_lit_or_vars t.addr ~f
  }
;;
