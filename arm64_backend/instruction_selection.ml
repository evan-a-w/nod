open! Core
open! Import
open! Common
open Arm64_ir
module Reg = Arm64_reg
module Class = Arm64_reg.Class

type t =
  { block_names : int String.Table.t
  ; var_names : int String.Table.t
  ; var_classes : Class.t Var.Table.t
  ; fn_state : Fn_state.t
  ; fn : Function.t
  }
[@@deriving fields]

let require_class t var class_ =
  match Hashtbl.find t.var_classes var with
  | None -> Hashtbl.set t.var_classes ~key:var ~data:class_
  | Some existing ->
    if not (Class.equal existing class_)
    then
      failwithf
        "register class mismatch for %s: saw %s and %s"
        (Var.name var)
        (Sexp.to_string_hum (Class.sexp_of_t existing))
        (Sexp.to_string_hum (Class.sexp_of_t class_))
        ()
;;

let class_of_type type_ = if Type.is_float type_ then Class.F64 else Class.I64

let class_of_var t var =
  match Hashtbl.find t.var_classes var with
  | Some class_ -> class_
  | None ->
    let class_ = class_of_type (Var.type_ var) in
    Hashtbl.set t.var_classes ~key:var ~data:class_;
    class_
;;

let reg_of_var t var = Reg.unallocated ~class_:(class_of_var t var) var

let type_of_class = function
  | Class.I64 -> Type.I64
  | Class.F64 -> Type.F64
;;

let class_of_lit_or_var t = function
  | Ir.Lit_or_var.Lit _ -> Class.I64
  | Ir.Lit_or_var.Var v -> class_of_var t v
  | Ir.Lit_or_var.Global _ -> Class.I64
;;

let fresh_var ?(type_ = Type.I64) t base =
  Var.create ~name:(Util.new_name t.var_names base) ~type_
;;

let fresh_like_var t var =
  Var.create
    ~name:(Util.new_name t.var_names (Var.name var))
    ~type_:(Var.type_ var)
;;

let replace_instructions t ~(block : Block.t) irs =
  let rec clear = function
    | None -> ()
    | Some instr ->
      let next = instr.Instr_state.next in
      Fn_state.remove_instr t.fn_state ~block ~instr;
      clear next
  in
  clear (Block.instructions block);
  List.iter irs ~f:(fun ir -> Fn_state.append_ir t.fn_state ~block ~ir)
;;

let append_instructions t ~(block : Block.t) irs =
  List.iter irs ~f:(fun ir -> Fn_state.append_ir t.fn_state ~block ~ir)
;;


let lower_aggregates_exn ~fn_state (fn : Function.t) =
  match Ir.lower_aggregates ~fn_state ~root:fn.root with
  | Ok () -> ()
  | Error err -> failwith (Nod_error.to_string err)
;;

let operand_of_lit_or_var t ~class_ (lit_or_var : Ir.Lit_or_var.t) =
  match lit_or_var with
  | Ir.Lit_or_var.Lit l -> [], Imm l
  | Ir.Lit_or_var.Var v ->
    require_class t v class_;
    [], Reg (Reg.unallocated ~class_ v)
  | Ir.Lit_or_var.Global g ->
    if not (Class.equal class_ Class.I64)
    then failwith "global addresses are only supported in integer contexts";
    let tmp = fresh_var t "global_addr" in
    let reg = Reg.unallocated ~class_:Class.I64 tmp in
    [ Adr { dst = reg; target = Jump_target.Label g.Global.name } ], Reg reg
;;

let rec mem_operand t mem =
  match mem with
  | Ir.Mem.Global global ->
    mem_operand t (Ir.Mem.address (Ir.Lit_or_var.Global global))
  | Ir.Mem.Stack_slot _ -> [], Ir.Mem.to_arm64_ir_operand mem
  | Ir.Mem.Address { base; offset } ->
    let pre_base, base_op = operand_of_lit_or_var t ~class_:Class.I64 base in
    let pre_addr, base_reg =
      match base_op with
      | Reg reg -> pre_base, reg
      | Imm _ ->
        let tmp =
          Reg.allocated ~class_:Class.I64 (fresh_var t "tmp_addr") None
        in
        pre_base @ [ Move { dst = tmp; src = base_op } ], tmp
      | Mem _ | Spill_slot _ ->
        failwith "unexpected operand in address computation"
    in
    pre_addr, Mem (base_reg, offset)
;;

let expand_atomic_rmw t =
  let used_names = String.Hash_set.create () in
  Block.iter t.fn.root ~f:(fun block ->
    Hash_set.add used_names (Block.id_hum block));
  let fresh_name base =
    let rec loop attempt =
      let candidate =
        if attempt = 0 then base else sprintf "%s_%d" base attempt
      in
      if Hash_set.mem used_names candidate
      then loop (attempt + 1)
      else (
        Hash_set.add used_names candidate;
        candidate)
    in
    loop 0
  in
  let rmw_loop_instrs ({ dest; addr; src; op; order = _ } : Ir.atomic_rmw) =
    require_class t dest Class.I64;
    let pre_addr, addr_op = mem_operand t addr in
    let pre_src, src_op = operand_of_lit_or_var t ~class_:Class.I64 src in
    let dst = reg_of_var t dest in
    let status = fresh_var t "rmw_status" in
    let status_reg = reg_of_var t status in
    let new_val = fresh_var t "rmw_new" in
    let new_reg = reg_of_var t new_val in
    let compute =
      match op with
      | Ir.Rmw_op.Xchg -> [ Move { dst = new_reg; src = src_op } ]
      | Add ->
        [ Int_binary { op = Int_op.Add; dst = new_reg; lhs = Reg dst; rhs = src_op }
        ]
      | Sub ->
        [ Int_binary { op = Int_op.Sub; dst = new_reg; lhs = Reg dst; rhs = src_op }
        ]
      | And ->
        [ Int_binary { op = Int_op.And; dst = new_reg; lhs = Reg dst; rhs = src_op }
        ]
      | Or ->
        [ Int_binary { op = Int_op.Orr; dst = new_reg; lhs = Reg dst; rhs = src_op }
        ]
      | Xor ->
        [ Int_binary { op = Int_op.Eor; dst = new_reg; lhs = Reg dst; rhs = src_op }
        ]
    in
    ( pre_addr
      @ pre_src
      @ [ Ldaxr { dst; addr = addr_op } ]
      @ compute
      @ [ Stlxr { status = status_reg; src = Reg new_reg; addr = addr_op } ]
    , status )
  in
  let rec split_block block =
    let instrs = Instr_state.to_ir_list (Block.instructions block) in
    match
      List.findi instrs ~f:(fun _ instr ->
        match instr with
        | Atomic_rmw _ -> true
        | _ -> false)
    with
    | None -> ()
    | Some (idx, Atomic_rmw atomic) ->
      let before = List.take instrs idx in
      let after = List.drop instrs (idx + 1) in
      let original_terminal = (Block.terminal block).Instr_state.ir in
      let cont_block =
        Block.create
          ~id_hum:(fresh_name (Block.id_hum block ^ "__atomic_rmw_cont"))
          ~terminal:
            (Fn_state.alloc_instr t.fn_state ~ir:original_terminal)
      in
      Block.set_dfs_id cont_block (Some 0);
      replace_instructions t ~block:cont_block after;
      let loop_block =
        Block.create
          ~id_hum:(fresh_name (Block.id_hum block ^ "__atomic_rmw_loop"))
          ~terminal:(Fn_state.alloc_instr t.fn_state ~ir:Noop)
      in
      Block.set_dfs_id loop_block (Some 0);
      let loop_instrs, status_var = rmw_loop_instrs atomic in
      replace_instructions
        t
        ~block:loop_block
        (List.map loop_instrs ~f:Ir0.arm64);
      let loop_cb = { Call_block.block = loop_block; args = [] } in
      let cont_cb = { Call_block.block = cont_block; args = [] } in
      Fn_state.replace_terminal_ir
        t.fn_state
        ~block:loop_block
        ~with_:
          (Branch
             (Cond
                { cond = Ir.Lit_or_var.Var status_var
                ; if_true = loop_cb
                ; if_false = cont_cb
                }));
      let before =
        match atomic.order with
        | Ir.Memory_order.Seq_cst -> before @ [ Ir0.arm64 Dmb ]
        | _ -> before
      in
      let after =
        match atomic.order with
        | Ir.Memory_order.Seq_cst -> Ir0.arm64 Dmb :: after
        | _ -> after
      in
      replace_instructions t ~block:cont_block after;
      replace_instructions t ~block before;
      Fn_state.replace_terminal_ir
        t.fn_state
        ~block
        ~with_:(Branch (Uncond loop_cb));
      split_block cont_block
    | Some _ -> ()
  in
  Block.iter t.fn.root ~f:split_block;
  Block.iter_and_update_bookkeeping t.fn.root ~f:(fun _ -> ());
  t
;;

let ir_to_arm64_ir ~this_call_conv t (ir : Ir.t) =
  assert (Call_conv.(equal this_call_conv default));
  let int_operand = operand_of_lit_or_var t ~class_:Class.I64 in
  let float_operand = operand_of_lit_or_var t ~class_:Class.F64 in
  let make_int_arith op ({ dest; src1; src2 } : Ir.arith) =
    require_class t dest Class.I64;
    let pre1, lhs = int_operand src1 in
    let pre2, rhs = int_operand src2 in
    pre1
    @ pre2
    @ [ Int_binary { op; dst = reg_of_var t dest; lhs; rhs } ]
  in
  let make_float_arith op ({ dest; src1; src2 } : Ir.arith) =
    require_class t dest Class.F64;
    let pre1, lhs = float_operand src1 in
    let pre2, rhs = float_operand src2 in
    pre1
    @ pre2
    @ [ Float_binary { op; dst = reg_of_var t dest; lhs; rhs } ]
  in
  let cmp_zero cond =
    let pre, lhs = int_operand cond in
    pre @ [ Comp { kind = Comp_kind.Int; lhs; rhs = Imm Int64.zero } ]
  in
  let mem_operand = mem_operand t in
  let dmb_if_seq_cst = function
    | Ir.Memory_order.Seq_cst -> [ Dmb ]
    | _ -> []
  in
  let dmb_if_any_seq_cst success_order failure_order =
    if Ir.Memory_order.equal success_order Ir.Memory_order.Seq_cst
       || Ir.Memory_order.equal failure_order Ir.Memory_order.Seq_cst
    then [ Dmb ]
    else []
  in
  match ir with
  | Arm64 x -> [ x ]
  | Ir0.Arm64_terminal xs -> xs
  | X86 _ | X86_terminal _ -> []
  | Noop | Unreachable -> []
  | Load_field _ | Store_field _ | Memcpy _ ->
    failwith "aggregate instructions must be lowered before selection"
  | And arith -> make_int_arith Int_op.And arith
  | Or arith -> make_int_arith Int_op.Orr arith
  | Add arith -> make_int_arith Int_op.Add arith
  | Sub arith -> make_int_arith Int_op.Sub arith
  | Mul arith -> make_int_arith Int_op.Mul arith
  | Div arith -> make_int_arith Int_op.Sdiv arith
  | Mod arith -> make_int_arith Int_op.Smod arith
  | Fadd arith -> make_float_arith Float_op.Fadd arith
  | Fsub arith -> make_float_arith Float_op.Fsub arith
  | Fmul arith -> make_float_arith Float_op.Fmul arith
  | Fdiv arith -> make_float_arith Float_op.Fdiv arith
  | Lt arith ->
    (* Signed less than comparison: dest = 1 if src1 < src2, else 0 *)
    require_class t arith.dest Class.I64;
    let dest_reg = reg_of_var t arith.dest in
    let pre1, op1 = operand_of_lit_or_var t ~class_:Class.I64 arith.src1 in
    let pre2, op2 = operand_of_lit_or_var t ~class_:Class.I64 arith.src2 in
    (* Compare src1 with src2, then set dest to 1 if less than, else 0 *)
    pre1
    @ pre2
    @ [ Comp { kind = Comp_kind.Int; lhs = op1; rhs = op2 }
      ; Cset { condition = Condition.Lt; dst = dest_reg }
      ]
  | Return lit_or_var ->
    let class_ = class_of_lit_or_var t lit_or_var in
    let pre, op = operand_of_lit_or_var t ~class_ lit_or_var in
    pre @ [ Ret [ op ] ]
  | Move (v, lit_or_var) ->
    let class_ = if Type.is_float (Var.type_ v) then Class.F64 else Class.I64 in
    require_class t v class_;
    let pre, src = operand_of_lit_or_var t ~class_ lit_or_var in
    pre @ [ Move { dst = reg_of_var t v; src } ]
  | Cast (dest, src) ->
    let dest_type = Var.type_ dest in
    let src_type =
      match src with
      | Ir.Lit_or_var.Var v -> Var.type_ v
      | Ir.Lit_or_var.Lit _ -> Type.I64
      | Ir.Lit_or_var.Global g -> Type.Ptr_typed g.Global.type_
    in
    let dest_class = if Type.is_float dest_type then Class.F64 else Class.I64 in
    let src_class = if Type.is_float src_type then Class.F64 else Class.I64 in
    require_class t dest dest_class;
    let dst = reg_of_var t dest in
    let pre, src_op = operand_of_lit_or_var t ~class_:src_class src in
    (match src_class, dest_class with
     | Class.I64, Class.F64 ->
       pre @ [ Convert { op = Convert_op.Int_to_float; dst; src = src_op } ]
     | Class.F64, Class.I64 ->
       pre @ [ Convert { op = Convert_op.Float_to_int; dst; src = src_op } ]
     | _ -> pre @ [ Move { dst; src = src_op } ])
  | Load (v, mem) ->
    require_class t v Class.I64;
    let prelude, addr = mem_operand mem in
    prelude @ [ Load { dst = reg_of_var t v; addr } ]
  | Store (lit_or_var, mem) ->
    let pre_mem, addr = mem_operand mem in
    let pre_val, src = int_operand lit_or_var in
    pre_mem @ pre_val @ [ Store { src; addr } ]
  | Call { fn; results; args } ->
    assert (Call_conv.(equal (call_conv ~fn) default));
    let gp_arg_regs =
      ref (Reg.arguments ~call_conv:(call_conv ~fn) Class.I64)
    in
    let fp_arg_regs =
      ref (Reg.arguments ~call_conv:(call_conv ~fn) Class.F64)
    in
    Breadcrumbs.arm64_stack_args;
    let take_arg_reg = function
      | Class.I64 ->
        (match !gp_arg_regs with
         | reg :: rest ->
           gp_arg_regs := rest;
           reg
         | [] -> failwith "stack arguments not yet supported on arm64 (gp)")
      | Class.F64 ->
        (match !fp_arg_regs with
         | reg :: rest ->
           fp_arg_regs := rest;
           reg
         | [] -> failwith "stack arguments not yet supported on arm64 (fp)")
    in
    let reg_arg_moves, call_args =
      List.map args ~f:(fun arg ->
        let class_ = class_of_lit_or_var t arg in
        let pre, operand = operand_of_lit_or_var t ~class_ arg in
        let reg = take_arg_reg class_ in
        let forced = Reg.allocated ~class_ (fresh_var t "arg_reg") (Some reg) in
        pre @ [ Move { dst = forced; src = operand } ], operand)
      |> List.unzip
    in
    let reg_arg_moves = List.concat reg_arg_moves in
    let gp_result_regs =
      ref (Reg.results ~call_conv:(call_conv ~fn) Class.I64)
    in
    let fp_result_regs =
      ref (Reg.results ~call_conv:(call_conv ~fn) Class.F64)
    in
    let take_result_reg class_ =
      match class_ with
      | Class.I64 ->
        (match !gp_result_regs with
         | reg :: rest ->
           gp_result_regs := rest;
           reg
         | [] -> failwith "too many gp call results on arm64")
      | Class.F64 ->
        (match !fp_result_regs with
         | reg :: rest ->
           fp_result_regs := rest;
           reg
         | [] -> failwith "too many fp call results on arm64")
    in
    let post_moves, updated_results =
      List.map results ~f:(fun res ->
        let class_ = class_of_var t res in
        let reg = take_result_reg class_ in
        let forced =
          Reg.allocated ~class_ (fresh_var t "tmp_force_physical") (Some reg)
        in
        let instr = Move { dst = reg_of_var t res; src = Reg forced } in
        instr, forced)
      |> List.unzip
    in
    [ Save_clobbers ]
    @ reg_arg_moves
    @ [ Call { fn; results = updated_results; args = call_args } ]
    @ post_moves
    @ [ Restore_clobbers ]
  | Alloca { dest; size = Ir.Lit_or_var.Lit i } ->
    [ alloca (Reg (reg_of_var t dest)) i ]
  | Alloca { dest; size = Ir.Lit_or_var.Var v } ->
    [ Int_binary
        { op = Int_op.Sub
        ; dst = Reg.sp
        ; lhs = Reg Reg.sp
        ; rhs = Reg (reg_of_var t v)
        }
    ; Move { dst = reg_of_var t dest; src = Reg Reg.sp }
    ]
  | Alloca { size = Ir.Lit_or_var.Global _; _ } ->
    failwith "alloca size must be a literal or variable"
  | Atomic_load { dest; addr; order } ->
    require_class t dest Class.I64;
    let pre_addr, addr = mem_operand addr in
    let load =
      match order with
      | Ir.Memory_order.Relaxed -> Load { dst = reg_of_var t dest; addr }
      | Acquire | Release | Acq_rel | Seq_cst ->
        Ldar { dst = reg_of_var t dest; addr }
    in
    pre_addr @ dmb_if_seq_cst order @ [ load ] @ dmb_if_seq_cst order
  | Atomic_store { addr; src; order } ->
    let pre_addr, addr = mem_operand addr in
    let pre_src, src = int_operand src in
    let store =
      match order with
      | Ir.Memory_order.Relaxed -> Store { src; addr }
      | Acquire | Release | Acq_rel | Seq_cst -> Stlr { src; addr }
    in
    pre_addr @ pre_src @ dmb_if_seq_cst order @ [ store ] @ dmb_if_seq_cst order
  | Atomic_cmpxchg
      { dest
      ; success
      ; addr
      ; expected
      ; desired
      ; success_order
      ; failure_order
      }
    ->
    require_class t dest Class.I64;
    require_class t success Class.I64;
    let pre_addr, addr = mem_operand addr in
    let pre_expected, expected_op = int_operand expected in
    let pre_desired, desired_op = int_operand desired in
    let dst = reg_of_var t dest in
    let success_reg = reg_of_var t success in
    let expected_copy = fresh_var t "cmpxchg_expected" in
    let expected_copy_reg = reg_of_var t expected_copy in
    let desired_tmp = fresh_var t "cmpxchg_desired" in
    let desired_reg = reg_of_var t desired_tmp in
    let tmp_xor = fresh_var t "cmpxchg_xor" in
    let tmp_neg = fresh_var t "cmpxchg_neg" in
    let tmp_or = fresh_var t "cmpxchg_or" in
    let tmp_shift = fresh_var t "cmpxchg_shift" in
    let tmp_mask = fresh_var t "cmpxchg_mask" in
    let seq_dmb = dmb_if_any_seq_cst success_order failure_order in
    seq_dmb
    @ pre_addr
    @ pre_expected
    @ pre_desired
    @ [ Move { dst; src = expected_op }
      ; Move { dst = expected_copy_reg; src = Reg dst }
      ; Move { dst = desired_reg; src = desired_op }
      ; Casal { dst; expected = Reg dst; desired = Reg desired_reg; addr }
      ; Int_binary
          { op = Int_op.Eor
          ; dst = reg_of_var t tmp_xor
          ; lhs = Reg dst
          ; rhs = Reg expected_copy_reg
          }
      ; Int_binary
          { op = Int_op.Sub
          ; dst = reg_of_var t tmp_neg
          ; lhs = Imm 0L
          ; rhs = Reg (reg_of_var t tmp_xor)
          }
      ; Int_binary
          { op = Int_op.Orr
          ; dst = reg_of_var t tmp_or
          ; lhs = Reg (reg_of_var t tmp_xor)
          ; rhs = Reg (reg_of_var t tmp_neg)
          }
      ; Int_binary
          { op = Int_op.Asr
          ; dst = reg_of_var t tmp_shift
          ; lhs = Reg (reg_of_var t tmp_or)
          ; rhs = Imm 63L
          }
      ; Int_binary
          { op = Int_op.And
          ; dst = reg_of_var t tmp_mask
          ; lhs = Reg (reg_of_var t tmp_shift)
          ; rhs = Imm 1L
          }
      ; Int_binary
          { op = Int_op.Sub
          ; dst = success_reg
          ; lhs = Imm 1L
          ; rhs = Reg (reg_of_var t tmp_mask)
          }
      ]
    @ seq_dmb
  | Atomic_rmw _ ->
    failwith "atomic_rmw should be lowered before ARM64 instruction selection"
  | Branch (Uncond cb) -> [ Jump cb ]
  | Branch (Cond { cond; if_true; if_false }) ->
    let cmp_instrs = cmp_zero cond in
    cmp_instrs
    @ [ Conditional_branch
          { condition = Condition.Ne; then_ = if_true; else_ = Some if_false }
      ]
;;

let get_fn = fn

let create ~fn_state fn =
  { block_names = String.Table.create ()
  ; var_names = String.Table.create ()
  ; var_classes = Var.Table.create ()
  ; fn_state
  ; fn
  }
;;

let add_count tbl s =
  Hashtbl.update tbl s ~f:(function
    | None -> 0
    | Some i -> i + 1)
;;

let mint_intermediate
  t
  ~(from_block : Block.t)
  ~(to_call_block : Block.t Call_block.t)
  =
  let id_hum =
    "intermediate_"
    ^ Block.id_hum from_block
    ^ "_to_"
    ^ Block.id_hum to_call_block.block
    |> Util.new_name t.block_names
  in
  let block =
    Block.create
      ~id_hum
      ~terminal:
        (Fn_state.alloc_instr t.fn_state ~ir:(Ir0.Arm64 (jump to_call_block)))
  in
  (* I can't be bothered to make this not confusing, but we want to set this
       so it gets updated in [Block.iter_and_update_bookkeeping]*)
  Block.set_dfs_id block (Some 0);
  (* The intermediate block doesn't need formal parameters - it's just a place
     to insert phi moves. The phi moves will be generated by insert_par_moves
     based on the mismatch between to_call_block.args and to_call_block.block.args *)
  { Call_block.block; args = to_call_block.args }
;;

let make_prologue t =
  let id_hum = t.fn.name ^ "__prologue" |> Util.new_name t.block_names in
  let args = List.map t.fn.args ~f:(fun arg -> fresh_like_var t arg) in
  let gp_arg_regs = ref (Reg.arguments ~call_conv:(call_conv ~fn) Class.I64) in
  let fp_arg_regs = ref (Reg.arguments ~call_conv:(call_conv ~fn) Class.F64) in
  let take_arg_reg class_ =
    match class_ with
    | Class.I64 ->
      (match !gp_arg_regs with
       | reg :: rest ->
         gp_arg_regs := rest;
         reg
       | [] -> failwith "stack arguments not yet supported on arm64")
    | Class.F64 ->
      (match !fp_arg_regs with
       | reg :: rest ->
         fp_arg_regs := rest;
         reg
       | [] -> failwith "stack arguments not yet supported on arm64")
  in
  let reg_arg_moves =
    List.map args ~f:(fun arg ->
      let class_ = class_of_var t arg in
      let reg = take_arg_reg class_ in
      Move { dst = Reg.allocated ~class_ arg (Some reg); src = Reg reg })
  in
  let block =
    Block.create
      ~id_hum
      ~terminal:
        (Fn_state.alloc_instr
           t.fn_state
           ~ir:(Ir0.Arm64 (Jump { block = t.fn.root; args })))
  in
  assert (Call_conv.(equal t.fn.call_conv default));
  Block.set_dfs_id block (Some 0);
  Block.Expert.set_args block (Vec.of_list args);
  replace_instructions
    t
    ~block
    (List.map ~f:Ir.arm64 (reg_arg_moves @ [ tag_def nop (Reg Reg.fp) ]));
  block
;;

let make_epilogue t ~ret_shape =
  let id_hum = t.fn.name ^ "__epilogue" |> Util.new_name t.block_names in
  let args =
    List.init (Option.value ret_shape ~default:0) ~f:(fun i ->
      fresh_var t ("res__" ^ Int.to_string i))
  in
  let gp_res_regs = ref (Reg.results ~call_conv:(call_conv ~fn) Class.I64) in
  let fp_res_regs = ref (Reg.results ~call_conv:(call_conv ~fn) Class.F64) in
  let take_res_reg class_ =
    match class_ with
    | Class.I64 ->
      (match !gp_res_regs with
       | reg :: rest ->
         gp_res_regs := rest;
         reg
       | [] -> failwith "too many gp return values on arm64")
    | Class.F64 ->
      (match !fp_res_regs with
       | reg :: rest ->
         fp_res_regs := rest;
         reg
       | [] -> failwith "too many fp return values on arm64")
  in
  let reg_res_moves, args' =
    List.map args ~f:(fun arg ->
      let class_ = class_of_var t arg in
      let reg = take_res_reg class_ in
      let forced = Reg.allocated ~class_ arg (Some reg) in
      Move { dst = reg; src = Reg forced }, Reg forced)
    |> List.unzip
  in
  let block =
    Block.create
      ~id_hum
      ~terminal:(Fn_state.alloc_instr t.fn_state ~ir:(Ir0.Arm64 (Ret args')))
  in
  assert (Call_conv.(equal t.fn.call_conv default));
  Block.set_dfs_id block (Some 0);
  Block.Expert.set_args block (Vec.of_list args);
  replace_instructions t ~block (List.map ~f:Ir.arm64 reg_res_moves);
  block
;;

let split_blocks_and_add_prologue_and_epilogue t =
  let ret_shape =
    let r = ref None in
    let update arm64_ir =
      let this =
        match arm64_ir with
        | Ret l -> Some (List.length l)
        | _ -> None
      in
      match !r, this with
      | Some a, Some b when a = b -> ()
      | Some _, None | None, None -> ()
      | Some _, Some _ -> failwith "diff ret shape"
      | None, Some _ -> r := this
    in
    Block.iter_instructions t.fn.root ~f:(fun instr ->
      on_arch_irs instr.Instr_state.ir ~f:update);
    !r
  in
  let prologue = make_prologue t in
  let epilogue = make_epilogue t ~ret_shape in
  (* CR-soon: Omit prologue and epilogue if unneeded (eg. leaf fn) *)
  t.fn.prologue <- Some prologue;
  t.fn.epilogue <- Some epilogue;
  t.fn.root <- prologue;
  Block.iter_and_update_bookkeeping t.fn.root ~f:(fun block ->
    let map_ir ir =
      (match ir with
       | Ir0.Arm64 (Alloca (_, i)) ->
         t.fn.bytes_statically_alloca'd
         <- Int64.to_int_exn i + t.fn.bytes_statically_alloca'd
       | _ -> ());
      Ir.map_arm64_operands ir ~f:(function
        | Arm64_ir.Mem ({ reg = Unallocated var; class_ }, offset) ->
          Arm64_ir.Mem (Reg.allocated ~class_ var None, offset)
        | x -> x)
    in
    let instructions =
      Instr_state.to_ir_list (Block.instructions block) |> List.map ~f:map_ir
    in
    replace_instructions t ~block instructions;
    (* Create intermediate blocks when we go to multiple, for ease of
           implementation of copies for phis *)
    match true_terminal block with
    | None -> ()
    | Some true_terminal ->
      let epilogue_jmp operands_to_ret =
        let args =
          List.zip_exn operands_to_ret (Vec.to_list (Block.args epilogue))
          |> List.map ~f:(fun (operand, arg) ->
            match operand with
            | Reg reg ->
              (match var_of_reg reg with
               | Some v -> v
               | None ->
                 let v = fresh_like_var t arg in
                 Fn_state.append_ir
                   t.fn_state
                   ~block
                   ~ir:
                     (Ir0.Arm64 (Move { dst = reg_of_var t v; src = operand }));
                 v)
            | other ->
              let v = fresh_like_var t arg in
              Fn_state.append_ir
                t.fn_state
                ~block
                ~ir:(Ir0.Arm64 (Move { dst = reg_of_var t v; src = other }));
              v)
        in
        Jump { Call_block.block = epilogue; args }
      in
      (match true_terminal with
       | Ret l when not (phys_equal block epilogue) ->
         replace_true_terminal ~fn_state:t.fn_state block (epilogue_jmp l)
       | Ret _ | Jump _ -> ()
       | Conditional_branch { condition; then_; else_ = None } ->
         replace_true_terminal
           ~fn_state:t.fn_state
           block
           (Conditional_branch { condition; then_; else_ = None })
       | Conditional_branch { condition; then_; else_ = Some else_ } ->
        let then_ =
          mint_intermediate t ~from_block:block ~to_call_block:then_
        in
        let else_ =
          mint_intermediate t ~from_block:block ~to_call_block:else_
        in
        Block.Expert.set_insert_phi_moves block false;
        replace_true_terminal
           ~fn_state:t.fn_state
           block
           (Conditional_branch { condition; then_; else_ = Some else_ })
       | Tag_use _
       | Tag_def _
       | Nop
       | Alloca _
       | Move _
       | Load _
       | Store _
       | Int_binary _
       | Float_binary _
       | Convert _
       | Bitcast _
       | Adr _
       | Comp _
       | Label _
       | Call _
       | Dmb
       | Ldar _
       | Stlr _
       | Ldaxr _
       | Stlxr _
       | Casal _
       | Cset _
       | Save_clobbers
       | Restore_clobbers -> ()));
  t
;;

let par_moves t ~dst_to_src =
  (* Convert vars to regs once and reuse the same reg objects throughout *)
  let dst_src_regs =
    List.map dst_to_src ~f:(fun (dst, src) ->
      reg_of_var t dst, reg_of_var t src)
  in
  let pending = Reg.Map.of_alist_exn dst_src_regs |> Ref.create in
  let temp class_ =
    Reg.unallocated
      ~class_
      (fresh_var ~type_:(type_of_class class_) t "regalloc_scratch")
  in
  let emitted = Vec.create () in
  let emit (dst : Reg.t) src =
    if Reg.equal dst src
    then ()
    else Vec.push emitted (Ir.arm64 (Move { dst; src = Reg src }))
  in
  let rec go () =
    if Map.is_empty !pending
    then ()
    else (
      let emitted_any =
        Map.fold !pending ~init:false ~f:(fun ~key:dst ~data:src emitted_any ->
          if Map.mem !pending src
          then emitted_any
          else (
            emit dst src;
            pending := Map.remove !pending dst;
            true))
      in
      if not emitted_any
      then (
        (* Break a dependency cycle by saving one destination, performing its move,
           and rewriting remaining uses of that destination to use the temp. *)
        let dst, src = Map.min_elt_exn !pending in
        let tmp = temp dst.class_ in
        emit tmp dst;
        emit dst src;
        pending := Map.remove !pending dst;
        pending
        := Map.map !pending ~f:(fun src' ->
             if Reg.equal src' dst then tmp else src'));
      go ())
  in
  go ();
  emitted
;;

let insert_par_moves t =
  Block.iter t.fn.root ~f:(fun block ->
    if not (Block.insert_phi_moves block)
    then ()
    else (
      match true_terminal block with
      | None -> ()
      | Some true_terminal ->
        (match true_terminal with
        | Jump cb ->
           let dst_to_src =
             List.zip_exn (Vec.to_list (Block.args cb.block)) cb.args
           in
           append_instructions
             t
             ~block
             (par_moves t ~dst_to_src |> Vec.to_list)
        | Ret _ -> ()
         | Conditional_branch _ -> failwith "bug"
         | Tag_use _
         | Tag_def _
         | Nop
         | Move _
         | Load _
         | Store _
         | Int_binary _
         | Float_binary _
         | Convert _
         | Bitcast _
         | Adr _
         | Comp _
         | Label _
         | Call _
         | Dmb
         | Ldar _
         | Stlr _
         | Ldaxr _
         | Stlxr _
         | Casal _
         | Cset _
         | Save_clobbers
         | Restore_clobbers
         | Alloca _ -> ())));
  t
;;

let remove_call_block_args t =
  Block.iter t.fn.root ~f:(fun block ->
    Fn_state.replace_terminal_ir
      t.fn_state
      ~block
      ~with_:(Ir.remove_block_args (Block.terminal block).Instr_state.ir)
    (* We don't need [Vec.clear_block_args] because we have a flag in liveness checking to consider them or not. *));
  t
;;

let simple_translation_to_arm64_ir ~this_call_conv t =
  let lower_ir ir =
    let res = ir_to_arm64_ir ~this_call_conv t ir in
    List.iter res ~f:(fun ir ->
      List.iter (Arm64_ir.vars ir) ~f:(fun var ->
        add_count t.var_names (Var.name var)));
    res
  in
  Block.iter t.fn.root ~f:(fun block ->
    add_count t.block_names (Block.id_hum block);
    let instructions =
      Instr_state.to_ir_list (Block.instructions block)
      |> List.concat_map ~f:(fun ir ->
           lower_ir ir |> List.map ~f:Ir0.arm64)
    in
    replace_instructions t ~block instructions;
    Fn_state.replace_terminal_ir
      t.fn_state
      ~block
      ~with_:
        (Ir.arm64_terminal
           (lower_ir (Block.terminal block).Instr_state.ir)));
  t
;;

let run ~fn_state (fn : Function.t) =
  lower_aggregates_exn ~fn_state fn;
  fn
  |> create ~fn_state
  |> expand_atomic_rmw
  |> simple_translation_to_arm64_ir ~this_call_conv:fn.call_conv
  |> split_blocks_and_add_prologue_and_epilogue
  |> insert_par_moves
  |> remove_call_block_args
  (* CR-soon: Some peephole opts to make things less absurd
       omit pointless instructions (eg. moves to constants, moves to same reg, etc.)
  *)
  |> get_fn
;;

module For_testing = struct
  let run_deebg (fn : Function.t) =
    let fn_state = Fn_state.of_cfg ~root:fn.root in
    lower_aggregates_exn ~fn_state fn;
    fn
    |> create ~fn_state
    |> expand_atomic_rmw
    |> simple_translation_to_arm64_ir ~this_call_conv:fn.call_conv
    |> split_blocks_and_add_prologue_and_epilogue
    |> insert_par_moves
    (* |> remove_call_block_args *)
    |> get_fn
  ;;
end
