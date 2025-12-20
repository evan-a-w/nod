open! Core

module Lit = struct
  type t = Int64.t [@@deriving sexp, compare, equal, hash]
end

module Lit_or_var = struct
  type t =
    | Lit of Lit.t
    | Var of Var.t
  [@@deriving sexp, compare, equal, hash]

  let vars = function
    | Lit _ -> []
    | Var v -> [ v ]
  ;;

  let map_vars t ~f =
    match t with
    | Lit _ -> t
    | Var v -> Var (f v)
  ;;

  let to_x86_ir_operand t : X86_ir.operand =
    match t with
    | Lit l -> Imm l
    | Var v -> Reg (X86_reg.unallocated v)
  ;;
end

module Mem = struct
  type t =
    | Stack_slot of int (* bytes *)
    | Lit_or_var of Lit_or_var.t
  [@@deriving sexp, compare, equal, hash]

  let vars = function
    | Lit_or_var l -> Lit_or_var.vars l
    | Stack_slot _ -> []
  ;;

  let map_vars t ~f =
    match t with
    | Lit_or_var l -> Lit_or_var (Lit_or_var.map_vars l ~f)
    | Stack_slot _ -> t
  ;;

  let map_lit_or_vars t ~f =
    match t with
    | Lit_or_var l -> Lit_or_var (f l)
    | Stack_slot _ -> t
  ;;

  let to_x86_ir_operand t : X86_ir.operand =
    match t with
    | Lit_or_var l -> Lit_or_var.to_x86_ir_operand l
    | Stack_slot i -> Mem (X86_reg.rbp, i)
  ;;
end

module Block_id =
  String_id.Make
    (struct
      let module_name = "Block_id"
    end)
    ()

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

module Branch = struct
  type 'block t =
    | Cond of
        { cond : Lit_or_var.t
        ; if_true : 'block Call_block.t
        ; if_false : 'block Call_block.t
        }
    | Uncond of 'block Call_block.t
  [@@deriving sexp, compare, equal, hash]

  let filter_map_call_blocks t ~f =
    match t with
    | Uncond call_block -> f call_block |> Option.to_list
    | Cond { cond = _; if_true; if_false } ->
      (f if_true |> Option.to_list) @ (f if_false |> Option.to_list)
  ;;

  (*
     [let t' = constant_fold t in
      not (phys_equal t t') iff t' is simpler than t
     ]
  *)
  let constant_fold = function
    | Cond { cond = Lit x; if_true = _; if_false } when Int64.(x = zero) ->
      Uncond if_false
    | Cond { cond = Lit x; if_true; if_false = _ } when Int64.(x <> zero) ->
      Uncond if_true
    | t -> t
  ;;

  let blocks = function
    | Uncond c -> Call_block.blocks c
    | Cond { cond = _; if_true; if_false } ->
      Call_block.blocks if_true @ Call_block.blocks if_false
  ;;

  let uses = function
    | Cond { cond; if_true; if_false } ->
      List.concat
        [ Lit_or_var.vars cond
        ; Call_block.uses if_true
        ; Call_block.uses if_false
        ]
      |> Var.Set.of_list
      |> Set.to_list
    | Uncond call -> Call_block.uses call
  ;;

  let map_uses ~f = function
    | Cond { cond; if_true; if_false } ->
      Cond
        { cond = Lit_or_var.map_vars ~f cond
        ; if_true = Call_block.map_uses if_true ~f
        ; if_false = Call_block.map_uses if_false ~f
        }
    | Uncond call -> Uncond (Call_block.map_uses call ~f)
  ;;

  let map_blocks ~f = function
    | Cond { cond; if_true; if_false } ->
      Cond
        { cond
        ; if_true = Call_block.map_blocks if_true ~f
        ; if_false = Call_block.map_blocks if_false ~f
        }
    | Uncond call -> Uncond (Call_block.map_blocks call ~f)
  ;;

  let iter_call_blocks ~f = function
    | Cond { cond = _; if_true; if_false } ->
      f if_true;
      f if_false
    | Uncond call -> f call
  ;;

  let map_call_blocks ~f = function
    | Cond { cond; if_true; if_false } ->
      Cond { cond; if_true = f if_true; if_false = f if_false }
    | Uncond call -> Uncond (f call)
  ;;

  let map_lit_or_vars t ~f =
    match t with
    | Uncond _ -> t
    | Cond { cond; if_true; if_false } ->
      Cond { cond = f cond; if_true; if_false }
  ;;
end

type 'block t =
  | Noop
  | And of arith
  | Or of arith
  | Add of arith
  | Sub of arith
  | Mul of arith
  | Div of arith
  | Mod of arith
  | Fadd of arith
  | Fsub of arith
  | Fmul of arith
  | Fdiv of arith
  | Alloca of alloca
  | Call of
      { fn : string
      ; results : Var.t list
      ; args : Lit_or_var.t list
      }
  | Load of Var.t * Mem.t
  | Store of Lit_or_var.t * Mem.t
  | Move of Var.t * Lit_or_var.t
  | Cast of Var.t * Lit_or_var.t
  (* Cast performs type conversion between different types:
     - Int -> Float: sign-extends and converts (cvtsi2sd/cvtsi2ss)
     - Float -> Int: truncates toward zero, overflow saturates (cvttsd2si/cvttss2si)
     - Float <-> Float: precision change, rounds to nearest (cvtsd2ss/cvtss2sd)
     - Int -> Int: truncate (larger -> smaller) or sign-extend (smaller -> larger)
  *)
  | Branch of 'block Branch.t
  | Return of Lit_or_var.t
  | Arm64 of 'block Arm64_ir.t
  | Arm64_terminal of 'block Arm64_ir.t list
  | X86 of 'block X86_ir.t
  | X86_terminal of 'block X86_ir.t list
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
  | Fadd _
  | Fsub _
  | Fmul _
  | Fdiv _
  | Move _
  | Cast _
  | Return _
  | Load _
  | Store _
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
  | Arm64 arm64_ir -> Arm64_ir.defs arm64_ir |> Set.to_list
  | Arm64_terminal arm64_irs ->
    List.concat_map arm64_irs ~f:(Fn.compose Set.to_list Arm64_ir.defs)
    |> Var.Set.of_list
    |> Set.to_list
  | X86 x86_ir -> X86_ir.defs x86_ir |> Set.to_list
  | X86_terminal x86_irs ->
    List.concat_map x86_irs ~f:(Fn.compose Set.to_list X86_ir.defs)
    |> Var.Set.of_list
    |> Set.to_list
  | Alloca a -> [ a.dest ]
  | And a
  | Or a
  | Add a
  | Sub a
  | Mul a
  | Div a
  | Mod a
  | Fadd a
  | Fsub a
  | Fmul a
  | Fdiv a -> [ a.dest ]
  | Load (a, _) -> [ a ]
  | Move (var, _) | Cast (var, _) -> [ var ]
  | Call { results; _ } -> results
  | Branch _ | Unreachable | Noop | Return _ | Store _ -> []
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
  | Fadd _
  | Fsub _
  | Fmul _
  | Fdiv _
  | Store _
  | Load _
  | And _
  | Or _
  | Move (_, _)
  | Cast (_, _)
  | Call _ | Unreachable | Noop | Return _ -> []
;;

let uses = function
  | Arm64 arm64_ir -> Arm64_ir.uses arm64_ir |> Set.to_list
  | Arm64_terminal arm64_irs ->
    List.concat_map arm64_irs ~f:(Fn.compose Set.to_list Arm64_ir.uses)
    |> Var.Set.of_list
    |> Set.to_list
  | X86 x86_ir -> X86_ir.uses x86_ir |> Set.to_list
  | X86_terminal x86_irs ->
    List.concat_map x86_irs ~f:(Fn.compose Set.to_list X86_ir.uses)
    |> Var.Set.of_list
    |> Set.to_list
  | Alloca a -> Lit_or_var.vars a.size
  | Add a
  | Sub a
  | Mul a
  | Div a
  | Mod a
  | And a
  | Or a
  | Fadd a
  | Fsub a
  | Fmul a
  | Fdiv a -> Lit_or_var.vars a.src1 @ Lit_or_var.vars a.src2
  | Store (a, b) -> Lit_or_var.vars a @ Mem.vars b
  | Load (_, b) -> Mem.vars b
  | Move (_, src) | Cast (_, src) -> Lit_or_var.vars src
  | Call { args; _ } ->
    List.concat_map args ~f:Lit_or_var.vars |> Var.Set.of_list |> Set.to_list
  | Branch b -> Branch.uses b
  | Return var -> Lit_or_var.vars var
  | Unreachable | Noop -> []
;;

let vars t =
  Set.union (Var.Set.of_list (uses t)) (Var.Set.of_list (defs t)) |> Set.to_list
;;

let x86_regs t =
  match t with
  | X86 x86 -> X86_ir.regs x86
  | X86_terminal x86s ->
    List.map ~f:(Fn.compose X86_ir.Reg.Set.of_list X86_ir.regs) x86s
    |> X86_ir.Reg.Set.union_list
    |> Set.to_list
  | _ -> []
;;

let x86_reg_defs t =
  match t with
  | X86 x86 -> X86_ir.reg_defs x86 |> Set.to_list
  | X86_terminal x86s ->
    List.map ~f:X86_ir.reg_defs x86s |> X86_ir.Reg.Set.union_list |> Set.to_list
  | _ -> []
;;

let arm64_regs t =
  match t with
  | Arm64 arm64 -> Arm64_ir.regs arm64
  | Arm64_terminal arm64s ->
    List.map ~f:(Fn.compose Arm64_ir.Reg.Set.of_list Arm64_ir.regs) arm64s
    |> Arm64_ir.Reg.Set.union_list
    |> Set.to_list
  | _ -> []
;;

let arm64_reg_defs t =
  match t with
  | Arm64 arm64 -> Arm64_ir.reg_defs arm64 |> Set.to_list
  | Arm64_terminal arm64s ->
    List.map ~f:Arm64_ir.reg_defs arm64s
    |> Arm64_ir.Reg.Set.union_list
    |> Set.to_list
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
  | Sub a -> Sub (map_arith_defs a ~f)
  | Fadd a -> Fadd (map_arith_defs a ~f)
  | Fsub a -> Fsub (map_arith_defs a ~f)
  | Fmul a -> Fmul (map_arith_defs a ~f)
  | Fdiv a -> Fdiv (map_arith_defs a ~f)
  | Alloca a -> Alloca (map_alloca_defs a ~f)
  | Load (a, b) -> Load (f a, b)
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
  | Branch _ | Unreachable | Noop | Return _ | Store _ -> t
;;

let map_uses t ~f =
  match t with
  | Or a -> Or (map_arith_uses a ~f)
  | And a -> And (map_arith_uses a ~f)
  | Add a -> Add (map_arith_uses a ~f)
  | Mul a -> Mul (map_arith_uses a ~f)
  | Div a -> Div (map_arith_uses a ~f)
  | Mod a -> Mod (map_arith_uses a ~f)
  | Sub a -> Sub (map_arith_uses a ~f)
  | Fadd a -> Fadd (map_arith_uses a ~f)
  | Fsub a -> Fsub (map_arith_uses a ~f)
  | Fmul a -> Fmul (map_arith_uses a ~f)
  | Fdiv a -> Fdiv (map_arith_uses a ~f)
  | Alloca a -> Alloca (map_alloca_uses a ~f)
  | Store (a, b) -> Store (Lit_or_var.map_vars a ~f, Mem.map_vars b ~f)
  | Load (a, b) -> Load (a, Mem.map_vars b ~f)
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
  | Unreachable | Noop -> t
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
  | Alloca _
  | Unreachable
  | Add _
  | Mul _
  | Div _
  | Mod _
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
  | Return _
  | And _
  | Or _
  | Call _ -> t
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
  | Return _
  | And _
  | Or _
  | Call _ -> ()
;;

let map_blocks (t : 'a t) ~f : 'b t =
  match t with
  | And a -> And a
  | Or a -> Or a
  | Add a -> Add a
  | Mul a -> Mul a
  | Div a -> Div a
  | Mod a -> Mod a
  | Fadd a -> Fadd a
  | Fsub a -> Fsub a
  | Fmul a -> Fmul a
  | Fdiv a -> Fdiv a
  | Alloca a -> Alloca a
  | Store (a, b) -> Store (a, b)
  | Load (a, b) -> Load (a, b)
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
  | Sub a -> Sub (map_arith_lit_or_vars a ~f)
  | Fadd a -> Fadd (map_arith_lit_or_vars a ~f)
  | Fsub a -> Fsub (map_arith_lit_or_vars a ~f)
  | Fmul a -> Fmul (map_arith_lit_or_vars a ~f)
  | Fdiv a -> Fdiv (map_arith_lit_or_vars a ~f)
  | Alloca a -> Alloca (map_alloca_lit_or_vars a ~f)
  | Store (a, b) -> Store (f a, Mem.map_lit_or_vars b ~f)
  | Load (a, b) -> Load (a, Mem.map_lit_or_vars b ~f)
  | Move (var, b) -> Move (var, f b)
  | Cast (var, b) -> Cast (var, f b)
  | Call { fn; results; args } -> Call { fn; results; args = List.map args ~f }
  | Branch b -> Branch (Branch.map_lit_or_vars b ~f)
  | Return var -> Return (f var)
  | Noop -> Noop
  | Unreachable -> Unreachable
  | Arm64 arm64_ir -> Arm64 (Arm64_ir.map_lit_or_vars arm64_ir ~f)
  | Arm64_terminal arm64_irs ->
    Arm64_terminal (List.map ~f:(Arm64_ir.map_lit_or_vars ~f) arm64_irs)
  | X86 x86_ir -> X86 (X86_ir.map_lit_or_vars x86_ir ~f)
  | X86_terminal x86_irs ->
    X86_terminal (List.map ~f:(X86_ir.map_lit_or_vars ~f) x86_irs)
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
  | Load _
  | Store _
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

let uses_ex_args t =
  Set.diff
    (uses t |> Var.Set.of_list)
    (List.concat_map (call_blocks t) ~f:(fun { block = _; args } -> args)
     |> Var.Set.of_list)
;;
