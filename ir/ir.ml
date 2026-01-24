open! Core
open! Import
open! Ir_helpers

type ('var, 'block) t =
  | Noop
  | And of 'var arith
  | Or of 'var arith
  | Add of 'var arith
  | Sub of 'var arith
  | Mul of 'var arith
  | Div of 'var arith
  | Mod of 'var arith
  | Lt of 'var arith (* signed less than: dest = 1 if src1 < src2, else 0 *)
  | Fadd of 'var arith
  | Fsub of 'var arith
  | Fmul of 'var arith
  | Fdiv of 'var arith
  | Alloca of 'var alloca
  | Call of
      { fn : string
      ; results : 'var list
      ; args : 'var Lit_or_var.t list
      }
  | Load of 'var * 'var Mem.t
  | Store of 'var Lit_or_var.t * 'var Mem.t
  | Load_field of 'var load_field
  | Store_field of 'var store_field
  | Memcpy of 'var memcpy
  | Atomic_load of 'var atomic_load
  | Atomic_store of 'var atomic_store
  | Atomic_rmw of 'var atomic_rmw
  | Atomic_cmpxchg of 'var atomic_cmpxchg
  | Move of 'var * 'var Lit_or_var.t
  | Cast of 'var * 'var Lit_or_var.t
  (* Cast performs type conversion between different types:
     - Int -> Float: sign-extends and converts (cvtsi2sd/cvtsi2ss)
     - Float -> Int: truncates toward zero, overflow saturates (cvttsd2si/cvttss2si)
     - Float <-> Float: precision change, rounds to nearest (cvtsd2ss/cvtss2sd)
     - Int -> Int: truncate (larger -> smaller) or sign-extend (smaller -> larger)
  *)
  | Branch of ('var, 'block) Branch.t
  | Return of 'var Lit_or_var.t
  | Arm64 of ('var, 'block) Arm64_ir.t
  | Arm64_terminal of ('var, 'block) Arm64_ir.t list
  | X86 of ('var, 'block) X86_ir.t
  | X86_terminal of ('var, 'block) X86_ir.t list
  | Unreachable
[@@deriving sexp, compare, equal, variants, hash]

let filter_map_call_blocks t ~f =
  match t with
  | Arm64 arm64_ir -> Arm64_ir.filter_map_call_blocks arm64_ir ~f
  | Arm64_terminal arm64_irs ->
    List.concat_map arm64_irs ~f:(Arm64_ir.filter_map_call_blocks ~f)
  | X86 x86_ir -> X86_ir.filter_map_call_blocks x86_ir ~f
  | X86_terminal x86_irs ->
    List.concat_map x86_irs ~f:(X86_ir.filter_map_call_blocks ~f)
  | Alloca _
  | And _
  | Or _
  | Noop
  | Add _
  | Sub _
  | Mul _
  | Div _
  | Mod _
  | Lt _
  | Fadd _
  | Fsub _
  | Fmul _
  | Fdiv _
  | Move _
  | Cast _
  | Return _
  | Load _
  | Store _
  | Load_field _
  | Store_field _
  | Memcpy _
  | Atomic_load _
  | Atomic_store _
  | Atomic_rmw _
  | Atomic_cmpxchg _
  | Unreachable
  | Call _ -> []
  | Branch b -> Branch.filter_map_call_blocks b ~f
;;

(*
   [let t' = constant_fold t in
    not (phys_equal t t') iff t' is simpler than t
    ]
*)
let rec constant_fold = function
  | Add { src1 = Lit a; src2; dest } when Int64.(equal a zero) ->
    Move (dest, src2)
  | Add { src1 = Lit a; src2 = Lit b; dest } -> Move (dest, Lit Int64.(a + b))
  | Sub { src1; src2 = Lit b; dest } when Int64.(equal b zero) ->
    Move (dest, src1)
  | Sub { src1 = Lit a; src2 = Lit b; dest } -> Move (dest, Lit Int64.(a - b))
  | Mul { src1 = Lit a; src2; dest } when Int64.(equal a one) ->
    Move (dest, src2)
  | Mul { src1 = Lit a; src2 = Lit b; dest } -> Move (dest, Lit Int64.(a * b))
  | Div { src1; src2 = Lit b; dest } when Int64.(equal b one) ->
    Move (dest, src1)
  | Div { src1 = Lit a; src2 = Lit b; dest } -> Move (dest, Lit Int64.(a / b))
  | Mod { src1 = Lit a; src2 = Lit b; dest } -> Move (dest, Lit (Int64.rem a b))
  (* move to left *)
  | Add { src1; src2 = Lit _ as src2; dest } ->
    Add { src1 = src2; src2 = src1; dest } |> constant_fold
  | Mul { src1; src2 = Lit _ as src2; dest } ->
    Mul { src1 = src2; src2 = src1; dest } |> constant_fold
  | Branch b as t ->
    let b' = Branch.constant_fold b in
    if phys_equal b b' then t else Branch b'
  | t -> t
;;

let maybe_constant_fold t =
  let t' = constant_fold t in
  if phys_equal t t' then None else Some t'
;;

let constant = function
  | Move (_, Lit i) -> Some i
  | _ -> None
;;

let defs = function
  | Arm64 arm64_ir -> Arm64_ir.defs arm64_ir
  | Arm64_terminal arm64_irs -> List.concat_map arm64_irs ~f:Arm64_ir.defs
  | X86 x86_ir -> X86_ir.defs x86_ir
  | X86_terminal x86_irs -> List.concat_map x86_irs ~f:X86_ir.defs
  | Alloca a -> [ a.dest ]
  | And a
  | Or a
  | Add a
  | Sub a
  | Mul a
  | Div a
  | Mod a
  | Lt a
  | Fadd a
  | Fsub a
  | Fmul a
  | Fdiv a -> [ a.dest ]
  | Load (a, _) -> [ a ]
  | Load_field a -> [ a.dest ]
  | Atomic_load a -> [ a.dest ]
  | Atomic_rmw a -> [ a.dest ]
  | Atomic_cmpxchg a -> [ a.dest; a.success ]
  | Move (var, _) | Cast (var, _) -> [ var ]
  | Call { results; _ } -> results
  | Branch _
  | Unreachable
  | Noop
  | Return _
  | Store _
  | Store_field _
  | Memcpy _
  | Atomic_store _ -> []
;;

let blocks = function
  | Arm64 arm64_ir -> Arm64_ir.blocks arm64_ir
  | Arm64_terminal arm64_irs -> List.concat_map ~f:Arm64_ir.blocks arm64_irs
  | X86 x86_ir -> X86_ir.blocks x86_ir
  | X86_terminal x86_irs -> List.concat_map ~f:X86_ir.blocks x86_irs
  | Branch b -> Branch.blocks b
  | Alloca _
  | Add _
  | Sub _
  | Mul _
  | Div _
  | Mod _
  | Lt _
  | Fadd _
  | Fsub _
  | Fmul _
  | Fdiv _
  | Store _
  | Load _
  | Store_field _
  | Load_field _
  | Memcpy _
  | Atomic_load _
  | Atomic_store _
  | Atomic_rmw _
  | Atomic_cmpxchg _
  | And _
  | Or _
  | Move (_, _)
  | Cast (_, _)
  | Call _ | Unreachable | Noop | Return _ -> []
;;

let uses = function
  | Arm64 arm64_ir -> Arm64_ir.uses arm64_ir
  | Arm64_terminal arm64_irs -> List.concat_map arm64_irs ~f:Arm64_ir.uses
  | X86 x86_ir -> X86_ir.uses x86_ir
  | X86_terminal x86_irs -> List.concat_map x86_irs ~f:X86_ir.uses
  | Alloca a -> Lit_or_var.vars a.size
  | Add a
  | Sub a
  | Mul a
  | Div a
  | Mod a
  | Lt a
  | And a
  | Or a
  | Fadd a
  | Fsub a
  | Fmul a
  | Fdiv a -> Lit_or_var.vars a.src1 @ Lit_or_var.vars a.src2
  | Store (a, b) -> Lit_or_var.vars a @ Mem.vars b
  | Load (_, b) -> Mem.vars b
  | Load_field a -> Lit_or_var.vars a.base
  | Store_field a -> Lit_or_var.vars a.base @ Lit_or_var.vars a.src
  | Memcpy a -> Lit_or_var.vars a.dest @ Lit_or_var.vars a.src
  | Atomic_load a -> Mem.vars a.addr
  | Atomic_store a -> Lit_or_var.vars a.src @ Mem.vars a.addr
  | Atomic_rmw a -> Lit_or_var.vars a.src @ Mem.vars a.addr
  | Atomic_cmpxchg a ->
    Lit_or_var.vars a.expected @ Lit_or_var.vars a.desired @ Mem.vars a.addr
  | Move (_, src) | Cast (_, src) -> Lit_or_var.vars src
  | Call { args; _ } -> List.concat_map args ~f:Lit_or_var.vars
  | Branch b -> Branch.uses b
  | Return var -> Lit_or_var.vars var
  | Unreachable | Noop -> []
;;

let vars t = uses t @ defs t

let x86_regs t =
  match t with
  | X86 x86 -> X86_ir.regs x86
  | X86_terminal x86s -> List.concat_map x86s ~f:X86_ir.regs
  | _ -> []
;;

let x86_reg_defs t =
  match t with
  | X86 x86 -> X86_ir.reg_defs x86
  | X86_terminal x86s -> List.concat_map x86s ~f:X86_ir.reg_defs
  | _ -> []
;;

let arm64_regs t =
  match t with
  | Arm64 arm64 -> Arm64_ir.regs arm64
  | Arm64_terminal arm64s -> List.concat_map arm64s ~f:Arm64_ir.regs
  | _ -> []
;;

let arm64_reg_defs t =
  match t with
  | Arm64 arm64 -> Arm64_ir.reg_defs arm64
  | Arm64_terminal arm64s -> List.concat_map arm64s ~f:Arm64_ir.reg_defs
  | _ -> []
;;

let map_defs t ~f =
  match t with
  | Or a -> Or (map_arith_defs a ~f)
  | And a -> And (map_arith_defs a ~f)
  | Add a -> Add (map_arith_defs a ~f)
  | Mul a -> Mul (map_arith_defs a ~f)
  | Div a -> Div (map_arith_defs a ~f)
  | Mod a -> Mod (map_arith_defs a ~f)
  | Lt a -> Lt (map_arith_defs a ~f)
  | Sub a -> Sub (map_arith_defs a ~f)
  | Fadd a -> Fadd (map_arith_defs a ~f)
  | Fsub a -> Fsub (map_arith_defs a ~f)
  | Fmul a -> Fmul (map_arith_defs a ~f)
  | Fdiv a -> Fdiv (map_arith_defs a ~f)
  | Alloca a -> Alloca (map_alloca_defs a ~f)
  | Load (a, b) -> Load (f a, b)
  | Load_field a -> Load_field (map_load_field_defs a ~f)
  | Atomic_load a -> Atomic_load (map_atomic_load_defs a ~f)
  | Atomic_rmw a -> Atomic_rmw (map_atomic_rmw_defs a ~f)
  | Atomic_cmpxchg a -> Atomic_cmpxchg (map_atomic_cmpxchg_defs a ~f)
  | Move (var, b) -> Move (f var, b)
  | Cast (var, b) -> Cast (f var, b)
  | Call { fn; results; args } ->
    Call { fn; results = List.map results ~f; args }
  | Arm64 arm64_ir -> Arm64 (Arm64_ir.map_defs arm64_ir ~f)
  | Arm64_terminal arm64_irs ->
    Arm64_terminal (List.map ~f:(Arm64_ir.map_defs ~f) arm64_irs)
  | X86 x86_ir -> X86 (X86_ir.map_defs x86_ir ~f)
  | X86_terminal x86_irs ->
    X86_terminal (List.map ~f:(X86_ir.map_defs ~f) x86_irs)
  | Branch _
  | Unreachable
  | Noop
  | Return _
  | Store _
  | Store_field _
  | Memcpy _
  | Atomic_store _ -> t
;;

let map_uses t ~f =
  match t with
  | Or a -> Or (map_arith_uses a ~f)
  | And a -> And (map_arith_uses a ~f)
  | Add a -> Add (map_arith_uses a ~f)
  | Mul a -> Mul (map_arith_uses a ~f)
  | Div a -> Div (map_arith_uses a ~f)
  | Mod a -> Mod (map_arith_uses a ~f)
  | Lt a -> Lt (map_arith_uses a ~f)
  | Sub a -> Sub (map_arith_uses a ~f)
  | Fadd a -> Fadd (map_arith_uses a ~f)
  | Fsub a -> Fsub (map_arith_uses a ~f)
  | Fmul a -> Fmul (map_arith_uses a ~f)
  | Fdiv a -> Fdiv (map_arith_uses a ~f)
  | Alloca a -> Alloca (map_alloca_uses a ~f)
  | Store (a, b) -> Store (Lit_or_var.map_vars a ~f, Mem.map_vars b ~f)
  | Load (a, b) -> Load (a, Mem.map_vars b ~f)
  | Load_field a -> Load_field (map_load_field_uses a ~f)
  | Store_field a -> Store_field (map_store_field_uses a ~f)
  | Memcpy a -> Memcpy (map_memcpy_uses a ~f)
  | Atomic_load a -> Atomic_load (map_atomic_load_uses a ~f)
  | Atomic_store a -> Atomic_store (map_atomic_store_uses a ~f)
  | Atomic_rmw a -> Atomic_rmw (map_atomic_rmw_uses a ~f)
  | Atomic_cmpxchg a -> Atomic_cmpxchg (map_atomic_cmpxchg_uses a ~f)
  | Return use -> Return (Lit_or_var.map_vars use ~f)
  | Move (var, b) -> Move (var, Lit_or_var.map_vars b ~f)
  | Cast (var, b) -> Cast (var, Lit_or_var.map_vars b ~f)
  | Call { fn; results; args } ->
    Call { fn; results; args = List.map args ~f:(Lit_or_var.map_vars ~f) }
  | Branch b -> Branch (Branch.map_uses b ~f)
  | Arm64 arm64_ir -> Arm64 (Arm64_ir.map_uses arm64_ir ~f)
  | Arm64_terminal arm64_irs ->
    Arm64_terminal (List.map ~f:(Arm64_ir.map_uses ~f) arm64_irs)
  | X86 x86_ir -> X86 (X86_ir.map_uses x86_ir ~f)
  | X86_terminal x86_irs ->
    X86_terminal (List.map ~f:(X86_ir.map_uses ~f) x86_irs)
  | Unreachable -> Unreachable
  | Noop -> Noop
;;

let map_vars t ~f =
  let map_lit_or_var = Lit_or_var.map_vars ~f in
  let map_mem = Mem.map_vars ~f in
  let map_arith { dest; src1; src2 } =
    { dest = f dest; src1 = map_lit_or_var src1; src2 = map_lit_or_var src2 }
  in
  let map_alloca { dest; size } =
    { dest = f dest; size = map_lit_or_var size }
  in
  let map_load_field { dest; base; type_; indices } =
    { dest = f dest; base = map_lit_or_var base; type_; indices }
  in
  let map_store_field { base; src; type_; indices } =
    { base = map_lit_or_var base; src = map_lit_or_var src; type_; indices }
  in
  let map_memcpy { dest; src; type_ } =
    { dest = map_lit_or_var dest; src = map_lit_or_var src; type_ }
  in
  let map_atomic_load ({ dest; addr; order } : _ atomic_load) : _ atomic_load =
    { dest = f dest; addr = map_mem addr; order }
  in
  let map_atomic_store ({ addr; src; order } : _ atomic_store) : _ atomic_store =
    { addr = map_mem addr; src = map_lit_or_var src; order }
  in
  let map_atomic_rmw { dest; addr; src; op; order } =
    { dest = f dest; addr = map_mem addr; src = map_lit_or_var src; op; order }
  in
  let map_atomic_cmpxchg
    { dest; success; addr; expected; desired; success_order; failure_order }
    =
    { dest = f dest
    ; success = f success
    ; addr = map_mem addr
    ; expected = map_lit_or_var expected
    ; desired = map_lit_or_var desired
    ; success_order
    ; failure_order
    }
  in
  match t with
  | Or a -> Or (map_arith a)
  | And a -> And (map_arith a)
  | Add a -> Add (map_arith a)
  | Mul a -> Mul (map_arith a)
  | Div a -> Div (map_arith a)
  | Mod a -> Mod (map_arith a)
  | Lt a -> Lt (map_arith a)
  | Sub a -> Sub (map_arith a)
  | Fadd a -> Fadd (map_arith a)
  | Fsub a -> Fsub (map_arith a)
  | Fmul a -> Fmul (map_arith a)
  | Fdiv a -> Fdiv (map_arith a)
  | Alloca a -> Alloca (map_alloca a)
  | Store (a, b) -> Store (map_lit_or_var a, map_mem b)
  | Load (a, b) -> Load (f a, map_mem b)
  | Load_field a -> Load_field (map_load_field a)
  | Store_field a -> Store_field (map_store_field a)
  | Memcpy a -> Memcpy (map_memcpy a)
  | Atomic_load a -> Atomic_load (map_atomic_load a)
  | Atomic_store a -> Atomic_store (map_atomic_store a)
  | Atomic_rmw a -> Atomic_rmw (map_atomic_rmw a)
  | Atomic_cmpxchg a -> Atomic_cmpxchg (map_atomic_cmpxchg a)
  | Return use -> Return (map_lit_or_var use)
  | Move (var, b) -> Move (f var, map_lit_or_var b)
  | Cast (var, b) -> Cast (f var, map_lit_or_var b)
  | Call { fn; results; args } ->
    Call
      { fn
      ; results = List.map results ~f
      ; args = List.map args ~f:map_lit_or_var
      }
  | Branch b -> Branch (Branch.map_uses b ~f)
  | Arm64 arm64_ir -> Arm64 (Arm64_ir.map_var_operands arm64_ir ~f)
  | Arm64_terminal arm64_irs ->
    Arm64_terminal (List.map arm64_irs ~f:(Arm64_ir.map_var_operands ~f))
  | X86 x86_ir -> X86 (X86_ir.map_var_operands x86_ir ~f)
  | X86_terminal x86_irs ->
    X86_terminal (List.map x86_irs ~f:(X86_ir.map_var_operands ~f))
  | Unreachable -> Unreachable
  | Noop -> Noop
;;

let is_terminal = function
  | Arm64 arm64_ir -> Arm64_ir.is_terminal arm64_ir
  | Arm64_terminal _ -> true
  | X86 x86_ir -> X86_ir.is_terminal x86_ir
  | X86_terminal _ -> true
  | Branch _ | Unreachable | Return _ -> true
  | Alloca _
  | Add _
  | Mul _
  | Div _
  | Mod _
  | Lt _
  | Sub _
  | Fadd _
  | Fsub _
  | Fmul _
  | Fdiv _
  | Move _
  | Cast _
  | Noop
  | Load _
  | Store _
  | Load_field _
  | Store_field _
  | Memcpy _
  | Atomic_load _
  | Atomic_store _
  | Atomic_rmw _
  | Atomic_cmpxchg _
  | And _
  | Or _
  | Call _ -> false
;;

let map_call_blocks t ~f =
  match t with
  | Branch b -> Branch (Branch.map_call_blocks b ~f)
  | Arm64 arm64_ir -> Arm64 (Arm64_ir.map_call_blocks arm64_ir ~f)
  | Arm64_terminal arm64_irs ->
    Arm64_terminal (List.map ~f:(Arm64_ir.map_call_blocks ~f) arm64_irs)
  | X86 x86_ir -> X86 (X86_ir.map_call_blocks x86_ir ~f)
  | X86_terminal x86_irs ->
    X86_terminal (List.map ~f:(X86_ir.map_call_blocks ~f) x86_irs)
  | Move (a, b) -> Move (a, b)
  | Alloca x -> Alloca x
  | Add x -> Add x
  | Mul x -> Mul x
  | Div x -> Div x
  | Mod x -> Mod x
  | Lt x -> Lt x
  | Sub x -> Sub x
  | Fadd x -> Fadd x
  | Fsub x -> Fsub x
  | Fmul x -> Fmul x
  | Fdiv x -> Fdiv x
  | Cast (a, b) -> Cast (a, b)
  | Noop -> Noop
  | Load (a, b) -> Load (a, b)
  | Store (a, b) -> Store (a, b)
  | Load_field x -> Load_field x
  | Store_field x -> Store_field x
  | Memcpy x -> Memcpy x
  | Atomic_load x -> Atomic_load x
  | Atomic_store x -> Atomic_store x
  | Atomic_rmw x -> Atomic_rmw x
  | Atomic_cmpxchg x -> Atomic_cmpxchg x
  | Return x -> Return x
  | And x -> And x
  | Or x -> Or x
  | Call x -> Call x
  | Unreachable -> Unreachable
;;

let iter_call_blocks t ~f =
  match t with
  | Branch b -> Branch.iter_call_blocks b ~f
  | Arm64 arm64_ir -> Arm64_ir.iter_call_blocks arm64_ir ~f
  | Arm64_terminal arm64_irs ->
    List.iter ~f:(Arm64_ir.iter_call_blocks ~f) arm64_irs
  | X86 x86_ir -> X86_ir.iter_call_blocks x86_ir ~f
  | X86_terminal x86_irs -> List.iter ~f:(X86_ir.iter_call_blocks ~f) x86_irs
  | Alloca _
  | Unreachable
  | Add _
  | Mul _
  | Div _
  | Mod _
  | Lt _
  | Sub _
  | Fadd _
  | Fsub _
  | Fmul _
  | Fdiv _
  | Move _
  | Cast _
  | Noop
  | Load _
  | Store _
  | Load_field _
  | Store_field _
  | Memcpy _
  | Atomic_load _
  | Atomic_store _
  | Atomic_rmw _
  | Atomic_cmpxchg _
  | Return _
  | And _
  | Or _
  | Call _ -> ()
;;

let map_blocks (t : ('var, 'a) t) ~f : ('var, 'b) t =
  match t with
  | And a -> And a
  | Or a -> Or a
  | Add a -> Add a
  | Mul a -> Mul a
  | Div a -> Div a
  | Mod a -> Mod a
  | Lt a -> Lt a
  | Fadd a -> Fadd a
  | Fsub a -> Fsub a
  | Fmul a -> Fmul a
  | Fdiv a -> Fdiv a
  | Alloca a -> Alloca a
  | Store (a, b) -> Store (a, b)
  | Load (a, b) -> Load (a, b)
  | Load_field a -> Load_field a
  | Store_field a -> Store_field a
  | Memcpy a -> Memcpy a
  | Atomic_load a -> Atomic_load a
  | Atomic_store a -> Atomic_store a
  | Atomic_rmw a -> Atomic_rmw a
  | Atomic_cmpxchg a -> Atomic_cmpxchg a
  | Sub a -> Sub a
  | Move (var, b) -> Move (var, b)
  | Cast (var, b) -> Cast (var, b)
  | Call call -> Call call
  | Branch b -> Branch (Branch.map_blocks b ~f)
  | Noop -> Noop
  | Return var -> Return var
  | Unreachable -> Unreachable
  | Arm64 arm64_ir -> Arm64 (Arm64_ir.map_blocks arm64_ir ~f)
  | Arm64_terminal arm64_irs ->
    Arm64_terminal (List.map ~f:(Arm64_ir.map_blocks ~f) arm64_irs)
  | X86 x86_ir -> X86 (X86_ir.map_blocks x86_ir ~f)
  | X86_terminal x86_irs ->
    X86_terminal (List.map ~f:(X86_ir.map_blocks ~f) x86_irs)
;;

let map_lit_or_vars t ~f =
  match t with
  | Or a -> Or (map_arith_lit_or_vars a ~f)
  | And a -> And (map_arith_lit_or_vars a ~f)
  | Add a -> Add (map_arith_lit_or_vars a ~f)
  | Mul a -> Mul (map_arith_lit_or_vars a ~f)
  | Div a -> Div (map_arith_lit_or_vars a ~f)
  | Mod a -> Mod (map_arith_lit_or_vars a ~f)
  | Lt a -> Lt (map_arith_lit_or_vars a ~f)
  | Sub a -> Sub (map_arith_lit_or_vars a ~f)
  | Fadd a -> Fadd (map_arith_lit_or_vars a ~f)
  | Fsub a -> Fsub (map_arith_lit_or_vars a ~f)
  | Fmul a -> Fmul (map_arith_lit_or_vars a ~f)
  | Fdiv a -> Fdiv (map_arith_lit_or_vars a ~f)
  | Alloca a -> Alloca (map_alloca_lit_or_vars a ~f)
  | Store (a, b) -> Store (f a, Mem.map_lit_or_vars b ~f)
  | Load (a, b) -> Load (a, Mem.map_lit_or_vars b ~f)
  | Load_field a -> Load_field (map_load_field_lit_or_vars a ~f)
  | Store_field a -> Store_field (map_store_field_lit_or_vars a ~f)
  | Memcpy a -> Memcpy (map_memcpy_lit_or_vars a ~f)
  | Atomic_load a -> Atomic_load a
  | Atomic_store a -> Atomic_store (map_atomic_store_lit_or_vars a ~f)
  | Atomic_rmw a -> Atomic_rmw (map_atomic_rmw_lit_or_vars a ~f)
  | Atomic_cmpxchg a -> Atomic_cmpxchg (map_atomic_cmpxchg_lit_or_vars a ~f)
  | Move (var, b) -> Move (var, f b)
  | Cast (var, b) -> Cast (var, f b)
  | Call { fn; results; args } -> Call { fn; results; args = List.map args ~f }
  | Branch b -> Branch (Branch.map_lit_or_vars b ~f)
  | Return var -> Return (f var)
  | Noop -> Noop
  | Unreachable -> Unreachable
  | Arm64 _ | Arm64_terminal _ | X86 _ | X86_terminal _ -> t
;;

let jump_to block' =
  Branch (Branch.Uncond { Call_block.block = block'; args = [] })
;;

let call_blocks = function
  | And _
  | Or _
  | Add _
  | Mul _
  | Div _
  | Lt _
  | Load _
  | Store _
  | Load_field _
  | Store_field _
  | Memcpy _
  | Atomic_load _
  | Atomic_store _
  | Atomic_rmw _
  | Atomic_cmpxchg _
  | Mod _
  | Sub _
  | Fadd _
  | Fsub _
  | Fmul _
  | Fdiv _
  | Move _
  | Cast _
  | Alloca _
  | Unreachable
  | Noop
  | Return _
  | Call _ -> []
  | Arm64 arm64_ir -> Arm64_ir.call_blocks arm64_ir
  | Arm64_terminal arm64_irs ->
    List.concat_map ~f:Arm64_ir.call_blocks arm64_irs
  | X86 x86_ir -> X86_ir.call_blocks x86_ir
  | X86_terminal x86_irs -> List.concat_map ~f:X86_ir.call_blocks x86_irs
  | Branch (Branch.Cond { cond = _; if_true; if_false }) ->
    [ if_true; if_false ]
  | Branch (Branch.Uncond call) -> [ call ]
;;

let map_x86_operands t ~f =
  match t with
  | X86 x86_ir -> X86 (X86_ir.map_operands x86_ir ~f)
  | X86_terminal x86_irs ->
    X86_terminal (List.map ~f:(X86_ir.map_operands ~f) x86_irs)
  | _ -> t
;;

let map_arm64_operands t ~f =
  match t with
  | Arm64 arm64_ir -> Arm64 (Arm64_ir.map_operands arm64_ir ~f)
  | Arm64_terminal arm64_irs ->
    Arm64_terminal (List.map ~f:(Arm64_ir.map_operands ~f) arm64_irs)
  | _ -> t
;;

let uses_ex_args t ~compare_var =
  let equal a b = compare_var a b = 0 in
  let args =
    List.concat_map (call_blocks t) ~f:(fun { block = _; args } -> args)
  in
  List.filter (uses t) ~f:(fun var -> not (List.mem args var ~equal))
;;
