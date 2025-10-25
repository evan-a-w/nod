open! Core
open! Import
open! Common

module Raw = X86_reg.Raw

let phys_reg_limit = Array.length Raw.all_physical

type var_state =
  { mutable num_uses : int
  ; id : int
  ; var : Var.t
  }
[@@deriving fields, sexp]

let var_state_score { num_uses; id = _; var = _ } = num_uses

type t =
  { vars : var_state Var.Table.t
  ; id_to_var : Var.t Int.Table.t
  }
[@@deriving fields, sexp]

let var_state t var =
  match Hashtbl.find t.vars var with
  | Some state -> state
  | None ->
    let id = Hashtbl.length t.vars in
    let res = { num_uses = 0; id; var } in
    Hashtbl.set t.vars ~key:var ~data:res;
    Hashtbl.set t.id_to_var ~key:id ~data:var;
    res
;;

let var_id t var = (var_state t var).id
let id_var t id = Hashtbl.find_exn t.id_to_var id

let reg_id t (reg : Reg.t) =
  match Reg.raw reg with
  | Raw.RBP -> 0
  | Raw.RSP -> 1
  | Raw.RAX -> 2
  | Raw.RBX -> 3
  | Raw.RCX -> 4
  | Raw.RDX -> 5
  | Raw.RSI -> 6
  | Raw.RDI -> 7
  | Raw.R8 -> 8
  | Raw.R9 -> 9
  | Raw.R10 -> 10
  | Raw.R11 -> 11
  | Raw.R12 -> 12
  | Raw.R13 -> 13
  | Raw.R14 -> 14
  | Raw.R15 -> 15
  | Raw.XMM0 -> 16
  | Raw.XMM1 -> 17
  | Raw.XMM2 -> 18
  | Raw.XMM3 -> 19
  | Raw.XMM4 -> 20
  | Raw.XMM5 -> 21
  | Raw.XMM6 -> 22
  | Raw.XMM7 -> 23
  | Raw.XMM8 -> 24
  | Raw.XMM9 -> 25
  | Raw.XMM10 -> 26
  | Raw.XMM11 -> 27
  | Raw.XMM12 -> 28
  | Raw.XMM13 -> 29
  | Raw.XMM14 -> 30
  | Raw.XMM15 -> 31
  | Raw.Unallocated var | Raw.Allocated (var, _) -> phys_reg_limit + var_id t var
;;

let id_reg t id : Reg.t =
  match id with
  | 0 -> Reg.rbp
  | 1 -> Reg.rsp
  | 2 -> Reg.rax
  | 3 -> Reg.rbx
  | 4 -> Reg.rcx
  | 5 -> Reg.rdx
  | 6 -> Reg.rsi
  | 7 -> Reg.rdi
  | 8 -> Reg.r8
  | 9 -> Reg.r9
  | 10 -> Reg.r10
  | 11 -> Reg.r11
  | 12 -> Reg.r12
  | 13 -> Reg.r13
  | 14 -> Reg.r14
  | 15 -> Reg.r15
  | 16 -> Reg.xmm0
  | 17 -> Reg.xmm1
  | 18 -> Reg.xmm2
  | 19 -> Reg.xmm3
  | 20 -> Reg.xmm4
  | 21 -> Reg.xmm5
  | 22 -> Reg.xmm6
  | 23 -> Reg.xmm7
  | 24 -> Reg.xmm8
  | 25 -> Reg.xmm9
  | 26 -> Reg.xmm10
  | 27 -> Reg.xmm11
  | 28 -> Reg.xmm12
  | 29 -> Reg.xmm13
  | 30 -> Reg.xmm14
  | 31 -> Reg.xmm15
  | other ->
    let id = other - phys_reg_limit in
    Reg.unallocated (id_var t id)
;;

let create (root : Block.t) =
  let t = { vars = Var.Table.create (); id_to_var = Int.Table.create () } in
  let add_use v =
    let s = var_state t v in
    s.num_uses <- s.num_uses + 1
  in
  Block.iter_instructions root ~f:(fun ir ->
    Ir.uses ir |> List.iter ~f:add_use;
    Ir.defs ir
    |> List.iter ~f:(fun def ->
      let (_ : var_state) = var_state t def in
      ()));
  t
;;
