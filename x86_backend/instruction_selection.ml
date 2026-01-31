open! Core
open! Import
open! Common
module Class = X86_reg.Class

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

let class_of_var t var =
  match Hashtbl.find t.var_classes var with
  | Some class_ -> class_
  | None -> Class.I64
;;

let reg_of_var t var = Reg.unallocated ~class_:(class_of_var t var) var

let type_of_class = function
  | Class.I64 -> Type.I64
  | Class.F64 -> Type.F64
;;

let fresh_var ?(type_ = Type.I64) t base =
  Var.create ~name:(Util.new_name t.var_names base) ~type_
;;

let fresh_like_var t var =
  Var.create
    ~name:(Util.new_name t.var_names (Var.name var))
    ~type_:(Var.type_ var)
;;

let lower_aggregates_exn ~fn_state (fn : Function.t) =
  match Ir.lower_aggregates ~fn_state ~root:fn.root with
  | Ok () -> ()
  | Error err -> failwith (Nod_error.to_string err)
;;

let failure_order_of_rmw = function
  | Ir.Memory_order.Release -> Ir.Memory_order.Relaxed
  | Ir.Memory_order.Acq_rel -> Ir.Memory_order.Acquire
  | other -> other
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
  let rmw_loop_instrs ({ dest; addr; src; op; order } : Typed_var.t Nod_ir.Ir_helpers.atomic_rmw) =
    require_class t dest Class.I64;
    let new_val = fresh_var t "rmw_new" in
    let success = fresh_var t "rmw_success" in
    let dest_var = Ir.Lit_or_var.Var dest in
    let compute =
      match op with
      | Nod_ir.Ir_helpers.Rmw_op.Xchg -> [ Ir.move new_val src ]
      | Add -> [ Ir.add { dest = new_val; src1 = dest_var; src2 = src } ]
      | Sub -> [ Ir.sub { dest = new_val; src1 = dest_var; src2 = src } ]
      | And -> [ Ir.and_ { dest = new_val; src1 = dest_var; src2 = src } ]
      | Or -> [ Ir.or_ { dest = new_val; src1 = dest_var; src2 = src } ]
      | Xor ->
        let tmp_and = fresh_var t "rmw_and" in
        let tmp_sum = fresh_var t "rmw_sum" in
        let tmp_double = fresh_var t "rmw_double" in
        [ Ir.and_ { dest = tmp_and; src1 = dest_var; src2 = src }
        ; Ir.add { dest = tmp_sum; src1 = dest_var; src2 = src }
        ; Ir.add
            { dest = tmp_double
            ; src1 = Ir.Lit_or_var.Var tmp_and
            ; src2 = Ir.Lit_or_var.Var tmp_and
            }
        ; Ir.sub
            { dest = new_val
            ; src1 = Ir.Lit_or_var.Var tmp_sum
            ; src2 = Ir.Lit_or_var.Var tmp_double
            }
        ]
    in
    ( compute
      @ [ Ir.atomic_cmpxchg
            { dest
            ; success
            ; addr
            ; expected = dest_var
            ; desired = Ir.Lit_or_var.Var new_val
            ; success_order = order
            ; failure_order = failure_order_of_rmw order
            }
        ]
    , success )
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
          ~terminal:(Fn_state.alloc_instr t.fn_state ~ir:original_terminal)
      in
      Block.set_dfs_id cont_block (Some 0);
      Fn_state.replace_irs t.fn_state ~block:cont_block ~irs:after;
      let loop_block =
        Block.create
          ~id_hum:(fresh_name (Block.id_hum block ^ "__atomic_rmw_loop"))
          ~terminal:(Fn_state.alloc_instr t.fn_state ~ir:Noop)
      in
      Block.set_dfs_id loop_block (Some 0);
      let loop_instrs, success_var = rmw_loop_instrs atomic in
      Fn_state.replace_irs t.fn_state ~block:loop_block ~irs:loop_instrs;
      let loop_cb = { Call_block.block = loop_block; args = [] } in
      let cont_cb = { Call_block.block = cont_block; args = [] } in
      Fn_state.replace_terminal_ir
        t.fn_state
        ~block:loop_block
        ~with_:
          (Branch
             (Cond
                { cond = Ir.Lit_or_var.Var success_var
                ; if_true = cont_cb
                ; if_false = loop_cb
                }));
      let init_load =
        Ir.atomic_load
          { dest = atomic.dest
          ; addr = atomic.addr
          ; order = Ir.Memory_order.Relaxed
          }
      in
      Fn_state.replace_irs t.fn_state ~block ~irs:(before @ [ init_load ]);
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

let operand_of_lit_or_var t ~class_ (lit_or_var : Typed_var.t Nod_ir.Lit_or_var.t) =
  match lit_or_var with
  | Lit l -> [], Imm l
  | Var v ->
    require_class t v class_;
    [], Reg (Reg.unallocated ~class_ v)
  | Global g ->
    if not (Class.equal class_ Class.I64)
    then failwith "global addresses are only supported in integer contexts";
    let tmp = fresh_var t "global_addr" in
    let reg = Reg.unallocated ~class_:Class.I64 tmp in
    [ mov (Reg reg) (Symbol g.name) ], Reg reg
;;

let ir_to_x86_ir ~this_call_conv t (ir : Ir.t) =
  assert (Call_conv.(equal this_call_conv default));
  let make_arith f ({ dest; src1; src2 } : Typed_var.t Nod_ir.Ir_helpers.arith) =
    require_class t dest Class.I64;
    let dest_op = Reg (reg_of_var t dest) in
    let pre1, op1 = operand_of_lit_or_var t ~class_:Class.I64 src1 in
    let pre2, op2 = operand_of_lit_or_var t ~class_:Class.I64 src2 in
    pre1 @ pre2 @ [ mov dest_op op1; f dest_op op2 ]
  in
  let reg v = Reg (reg_of_var t v) in
  let mul_div_mod
    ({ dest; src1; src2 } : Typed_var.t Nod_ir.Ir_helpers.arith)
    ~make_instr
    ~take_reg
    =
    require_class t dest Class.I64;
    let tmp_rax =
      Reg.allocated ~class_:Class.I64 (fresh_var t "tmp_rax") (Some Reg.rax)
    in
    let tmp_dst =
      Reg.allocated ~class_:Class.I64 (fresh_var t "tmp_dst") (Some take_reg)
    in
    let other_reg = if Reg.equal take_reg Reg.rax then Reg.rdx else Reg.rax in
    let tmp_other =
      Reg.allocated
        ~class_:Class.I64
        (fresh_var t "tmp_clobber")
        (Some other_reg)
    in
    (* IMUL/IDIV only accept register or memory operands, not immediates.
       If src2 is a literal, we need to load it into a register first. *)
    let pre2, src2_op = operand_of_lit_or_var t ~class_:Class.I64 src2 in
    let src2_final, extra_mov =
      match src2_op with
      | Spill_slot _ -> failwith "unexpected spill slot"
      | Imm _ ->
        let tmp_reg =
          Reg.allocated ~class_:Class.I64 (fresh_var t "tmp_imm") None
        in
        Reg tmp_reg, [ mov (Reg tmp_reg) src2_op ]
      | Reg _ | Mem _ | Symbol _ -> src2_op, []
    in
    let pre1, src1_op = operand_of_lit_or_var t ~class_:Class.I64 src1 in
    pre2
    @ extra_mov
    @ pre1
    @ [ mov (Reg tmp_rax) src1_op
      ; tag_def
          (tag_def
             (tag_use (make_instr src2_final) (Reg tmp_rax))
             (Reg tmp_dst))
          (Reg tmp_other)
      ; mov (reg dest) (Reg tmp_dst)
      ]
  in
  let rec mem_operand mem =
    match mem with
    | Ir.Mem.Global global ->
      mem_operand (Ir.Mem.address (Ir.Lit_or_var.Global global))
    | Ir.Mem.Stack_slot _ -> [], Ir.Mem.to_x86_ir_operand mem
    | Ir.Mem.Address { base; offset } ->
      let pre_base, base_op = operand_of_lit_or_var t ~class_:Class.I64 base in
      let pre_addr, base_reg =
        match base_op with
        | Reg reg -> pre_base, reg
        | Imm _ | Symbol _ ->
          let tmp_addr =
            Reg.allocated ~class_:Class.I64 (fresh_var t "tmp_addr") None
          in
          pre_base @ [ mov (Reg tmp_addr) base_op ], tmp_addr
        | Mem _ | Spill_slot _ ->
          failwith "unexpected operand in address computation"
      in
      pre_addr, Mem (base_reg, offset)
  in
  match ir with
  | X86 x -> [ x ]
  | X86_terminal xs -> xs
  | Arm64 _ | Arm64_terminal _ -> []
  | Noop | Unreachable -> []
  | Load_field _ | Store_field _ | Memcpy _ ->
    failwith "aggregate instructions must be lowered before selection"
  | And arith -> make_arith and_ arith
  | Or arith -> make_arith or_ arith
  | Add arith -> make_arith add arith
  | Sub arith -> make_arith sub arith
  | Fadd arith ->
    require_class t arith.dest Class.F64;
    let dest_op = Reg (reg_of_var t arith.dest) in
    let pre1, op1 = operand_of_lit_or_var t ~class_:Class.F64 arith.src1 in
    let pre2, op2 = operand_of_lit_or_var t ~class_:Class.F64 arith.src2 in
    pre1 @ pre2 @ [ movsd dest_op op1; addsd dest_op op2 ]
  | Fsub arith ->
    require_class t arith.dest Class.F64;
    let dest_op = Reg (reg_of_var t arith.dest) in
    let pre1, op1 = operand_of_lit_or_var t ~class_:Class.F64 arith.src1 in
    let pre2, op2 = operand_of_lit_or_var t ~class_:Class.F64 arith.src2 in
    pre1 @ pre2 @ [ movsd dest_op op1; subsd dest_op op2 ]
  | Fmul arith ->
    require_class t arith.dest Class.F64;
    let dest_op = Reg (reg_of_var t arith.dest) in
    let pre1, op1 = operand_of_lit_or_var t ~class_:Class.F64 arith.src1 in
    let pre2, op2 = operand_of_lit_or_var t ~class_:Class.F64 arith.src2 in
    pre1 @ pre2 @ [ movsd dest_op op1; mulsd dest_op op2 ]
  | Fdiv arith ->
    require_class t arith.dest Class.F64;
    let dest_op = Reg (reg_of_var t arith.dest) in
    let pre1, op1 = operand_of_lit_or_var t ~class_:Class.F64 arith.src1 in
    let pre2, op2 = operand_of_lit_or_var t ~class_:Class.F64 arith.src2 in
    pre1 @ pre2 @ [ movsd dest_op op1; divsd dest_op op2 ]
  | Lt arith ->
    (* Signed less than comparison: dest = 1 if src1 < src2, else 0 *)
    require_class t arith.dest Class.I64;
    let dest_reg = reg_of_var t arith.dest in
    let pre1, op1 = operand_of_lit_or_var t ~class_:Class.I64 arith.src1 in
    let pre2, op2 = operand_of_lit_or_var t ~class_:Class.I64 arith.src2 in
    (* Zero out dest first (setl only sets lowest byte) *)
    pre1
    @ pre2
    @ [ mov (Reg dest_reg) (Imm 0L); cmp op1 op2; setl (Reg dest_reg) ]
  | Return lit_or_var ->
    let pre, op = operand_of_lit_or_var t ~class_:Class.I64 lit_or_var in
    pre @ [ RET [ op ] ]
  | Move (v, lit_or_var) ->
    let class_ = if Type.is_float (Var.type_ v) then Class.F64 else Class.I64 in
    require_class t v class_;
    let pre, op = operand_of_lit_or_var t ~class_ lit_or_var in
    pre @ [ mov (reg v) op ]
  | Cast (dest, src) ->
    (* Type conversion between different types *)
    let dest_type = Var.type_ dest in
    let src_type =
      match src with
      | Ir.Lit_or_var.Var v -> Var.type_ v
      | Ir.Lit_or_var.Lit _ -> Type.I64 (* literals are treated as i64 *)
      | Ir.Lit_or_var.Global g -> Type.Ptr_typed g.type_
    in
    let dest_class = if Type.is_float dest_type then Class.F64 else Class.I64 in
    let src_class = if Type.is_float src_type then Class.F64 else Class.I64 in
    require_class t dest dest_class;
    (match src_type, dest_type with
     | t1, t2 when Type.is_integer t1 && Type.is_float t2 ->
       (* Int to float conversion *)
       (* cvtsi2sd can't take immediates, so we need to load literals into a register first *)
       let pre, src_operand = operand_of_lit_or_var t ~class_:src_class src in
       pre
       @
         (match src_operand with
         | Spill_slot _ -> failwith "unexpected spill slot"
         | Imm _ ->
           (* Load immediate into a temporary register first *)
           let tmp_reg =
             Reg.allocated ~class_:Class.I64 (fresh_var t "tmp_cvt") None
           in
           [ mov (Reg tmp_reg) src_operand
           ; cvtsi2sd (Reg (reg_of_var t dest)) (Reg tmp_reg)
           ]
         | Reg _ | Mem _ | Symbol _ ->
           [ cvtsi2sd (Reg (reg_of_var t dest)) src_operand ])
     | t1, t2 when Type.is_float t1 && Type.is_integer t2 ->
       (* Float to int conversion (with truncation) *)
       let pre, src_operand = operand_of_lit_or_var t ~class_:src_class src in
       pre @ [ cvttsd2si (Reg (reg_of_var t dest)) src_operand ]
     | t1, t2 when Type.is_ptr t1 && Type.is_ptr t2 ->
       (* Pointer bitcasts are just integer moves. *)
       let pre, src_operand = operand_of_lit_or_var t ~class_:Class.I64 src in
       pre @ [ mov (Reg (reg_of_var t dest)) src_operand ]
     | t1, t2 when Type.is_integer t1 && Type.is_integer t2 ->
       (* Int to int conversion (sign-extend or truncate) *)
       (* For now, just use mov - x86 will handle sign extension/truncation *)
       let pre, src_operand = operand_of_lit_or_var t ~class_:Class.I64 src in
       pre @ [ mov (Reg (reg_of_var t dest)) src_operand ]
     | _ ->
       (* Float to float or other conversions not yet supported *)
       failwithf
         "Unsupported cast from %s to %s"
         (Type.to_string src_type)
         (Type.to_string dest_type)
         ())
  | Load (v, mem) ->
    require_class t v Class.I64;
    let pre, mem_op = mem_operand mem in
    pre @ [ mov (reg v) mem_op ]
  | Store (lit_or_var, mem) ->
    let pre_mem, mem_op = mem_operand mem in
    let pre_val, val_op =
      operand_of_lit_or_var t ~class_:Class.I64 lit_or_var
    in
    pre_mem @ pre_val @ [ mov mem_op val_op ]
  | Mul arith -> mul_div_mod arith ~take_reg:Reg.rax ~make_instr:imul
  | Div arith -> mul_div_mod arith ~take_reg:Reg.rax ~make_instr:idiv
  | Mod arith -> mul_div_mod arith ~take_reg:Reg.rdx ~make_instr:mod_
  | Call { fn; results; args } ->
    assert (Call_conv.(equal (call_conv ~fn) default));
    let gp_arg_regs = Reg.arguments ~call_conv:(call_conv ~fn) Class.I64 in
    let arg_infos =
      List.map args ~f:(operand_of_lit_or_var t ~class_:Class.I64)
    in
    let arg_operands = List.map arg_infos ~f:snd in
    let reg_infos, stack_infos =
      List.split_n arg_infos (List.length gp_arg_regs)
    in
    let stack_arg_pushes =
      List.rev stack_infos
      |> List.concat_map ~f:(fun (pre, op) -> pre @ [ push op ])
    in
    let reg_arg_moves =
      List.zip_with_remainder reg_infos gp_arg_regs
      |> fst
      |> List.concat_map ~f:(fun ((pre, op), reg) ->
        let force_physical =
          Reg.allocated ~class_:Class.I64 (fresh_var t "arg_reg") (Some reg)
        in
        pre @ [ mov (Reg force_physical) op ])
    in
    let pushed_bytes = List.length stack_infos * 8 in
    let extra_align = (16 - (pushed_bytes mod 16)) mod 16 in
    let pushed_bytes_with_align = pushed_bytes + extra_align in
    let align_stack =
      if extra_align = 0
      then []
      else [ sub (Reg Reg.rsp) (Imm (Int64.of_int extra_align)) ]
    in
    let pre_moves = align_stack @ stack_arg_pushes @ reg_arg_moves in
    assert (List.length results <= 2);
    let gp_result_regs = Reg.results ~call_conv:(call_conv ~fn) Class.I64 in
    let post_moves, results_with_physical =
      Sequence.zip_full
        (Sequence.of_list results)
        (Sequence.of_list gp_result_regs)
      |> Sequence.filter_map ~f:(function
        | `Right _ -> None
        | `Left _ -> failwith "impossible"
        | `Both (res, reg) ->
          let force_physical =
            Reg.allocated
              ~class_:Class.I64
              (fresh_var t "tmp_force_physical")
              (Some reg)
          in
          let instr = mov (Reg (Reg.unallocated res)) (Reg force_physical) in
          Some (instr, force_physical))
      |> Sequence.to_list
      |> List.unzip
    in
    let results_on_stack =
      List.drop results (List.length results_with_physical)
      |> List.map ~f:Reg.unallocated
    in
    let updated_results = results_with_physical @ results_on_stack in
    let post_pop =
      if pushed_bytes_with_align = 0
      then []
      else [ add (Reg Reg.rsp) (Imm (Int64.of_int pushed_bytes_with_align)) ]
    in
    [ save_clobbers ]
    @ pre_moves
    @ [ CALL { fn; results = updated_results; args = arg_operands } ]
    @ post_moves
    @ post_pop
    @ [ restore_clobbers ]
  | Alloca { dest; size = Lit i } -> [ alloca (Reg (Reg.unallocated dest)) i ]
  | Alloca { dest; size = Var v } ->
    [ sub (Reg Reg.rsp) (Reg (Reg.unallocated v))
    ; mov (reg dest) (Reg Reg.rsp)
    ]
  | Alloca { size = Global _; _ } ->
    failwith "alloca size must be a literal or variable"
  | Branch (Uncond cb) -> [ jmp cb ]
  | Branch (Cond { cond; if_true; if_false }) ->
    let pre, cond_op = operand_of_lit_or_var t ~class_:Class.I64 cond in
    pre @ [ cmp cond_op (Imm Int64.zero); jne if_true (Some if_false) ]
  (* Atomic operations - leverage x86 TSO memory model *)
  | Atomic_load { dest; addr; order } ->
    (* On x86 TSO: regular loads have acquire semantics, only seq_cst needs fence *)
    require_class t dest Class.I64;
    let pre, mem_op = mem_operand addr in
    let load_instr = [ mov (reg dest) mem_op ] in
    (match order with
     | Seq_cst -> pre @ [ mfence ] @ load_instr
     | Relaxed | Acquire | Release | Acq_rel -> pre @ load_instr)
  | Atomic_store { addr; src; order } ->
    (* On x86 TSO: regular stores have release semantics, seq_cst needs fence *)
    let pre_mem, mem_op = mem_operand addr in
    let pre_val, val_op = operand_of_lit_or_var t ~class_:Class.I64 src in
    let store_instr = [ mov mem_op val_op ] in
    (match order with
     | Seq_cst -> pre_mem @ pre_val @ store_instr @ [ mfence ]
     | Relaxed | Acquire | Release | Acq_rel -> pre_mem @ pre_val @ store_instr)
  | Atomic_rmw _ ->
    failwith "atomic_rmw should be lowered before x86 instruction selection"
  | Atomic_cmpxchg
      { dest
      ; success
      ; addr
      ; expected
      ; desired
      ; success_order = _
      ; failure_order = _
      } ->
    (* CMPXCHG on x86:
       - Compares RAX with memory location
       - If equal, stores desired value to memory and sets ZF
       - If not equal, loads memory value into RAX and clears ZF
       - Returns old value in RAX *)
    require_class t dest Class.I64;
    require_class t success Class.I64;
    let pre_mem, mem_op = mem_operand addr in
    let pre_expected, expected_op =
      operand_of_lit_or_var t ~class_:Class.I64 expected
    in
    let pre_desired, desired_op =
      operand_of_lit_or_var t ~class_:Class.I64 desired
    in
    let success_reg = Reg.allocated ~class_:Class.I64 success None in
    (* RAX must hold the expected value *)
    let rax_reg =
      Reg.allocated ~class_:Class.I64 (fresh_var t "cmpxchg_rax") (Some Reg.rax)
    in
    (* Desired value in another register *)
    let desired_reg =
      Reg.allocated ~class_:Class.I64 (fresh_var t "cmpxchg_desired") None
    in
    pre_mem
    @ pre_expected
    @ [ mov (Reg rax_reg) expected_op ]
    @ pre_desired
    @ [ mov (Reg desired_reg) desired_op
      ; LOCK_CMPXCHG
          { dest = mem_op; expected = Reg rax_reg; desired = Reg desired_reg }
        (* After CMPXCHG, RAX contains old value *)
      ; mov (reg dest) (Reg rax_reg)
      ; sete (Reg success_reg)
      ; and_ (Reg success_reg) (Imm Int64.one)
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
  ~(to_call_block : (Typed_var.t, Block.t) Call_block.t)
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
        (Fn_state.alloc_instr t.fn_state ~ir:(X86 (X86_ir.jmp to_call_block)))
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
  (* As we go in, stack is like
       arg_n, arg_n+1, ..., return addr

       we will later push rbp to save it, and then rbp will be at that point.

       This means that the saved rbp is directly at rbp, the return addr is rbp + 8, etc *)
  (* .
  *)
  let args = List.map t.fn.args ~f:(fun arg -> fresh_like_var t arg) in
  let gp_arg_regs = Reg.arguments ~call_conv:(call_conv ~fn) Class.I64 in
  let reg_args, args_on_stack = List.split_n args (List.length gp_arg_regs) in
  let reg_arg_moves =
    List.zip_with_remainder reg_args gp_arg_regs
    |> fst
    |> List.map ~f:(fun (arg, reg) ->
      mov
        (Reg (Reg.allocated ~class_:(Reg.class_ reg) arg (Some reg)))
        (Reg reg))
  in
  let stack_arg_moves =
    args_on_stack
    |> List.mapi ~f:(fun i arg ->
      let stack_offset = (i + 2) * 8 in
      mov (Reg (Reg.unallocated arg)) (Mem (Reg.rbp, stack_offset)))
  in
  let block =
    Block.create
      ~id_hum
      ~terminal:
        (Fn_state.alloc_instr
           t.fn_state
           ~ir:(X86 (jmp { block = t.fn.root; args })))
  in
  assert (Call_conv.(equal t.fn.call_conv default));
  (* I can't be bothered to make this not confusing, but we want to set this
       so it gets updated in [Block.iter_and_update_bookkeeping]*)
  Block.set_dfs_id block (Some 0);
  Fn_state.set_block_args t.fn_state ~block ~args:(Vec.of_list args);
  Fn_state.replace_irs
    t.fn_state
    ~block
    ~irs:
      (List.map
         ~f:Ir.x86
         (reg_arg_moves
          @ stack_arg_moves
          @ [ tag_def noop (Reg Reg.rbp) ]
            (* clobber and stack adjustment/saves will be added here later. Also subtracting stack for spills and alloca *)
         ));
  block
;;

let make_epilogue t ~ret_shape =
  let id_hum = t.fn.name ^ "__epilogue" |> Util.new_name t.block_names in
  (* As we go in, stack is like
       arg_n, arg_n+1, ..., return addr
  *)
  let args =
    List.init (Option.value ret_shape ~default:0) ~f:(fun i ->
      fresh_var t ("res__" ^ Int.to_string i))
  in
  Breadcrumbs.add_return_values_on_stack;
  let gp_res_regs = Reg.results ~call_conv:(call_conv ~fn) Class.I64 in
  let reg_res_moves =
    List.zip_with_remainder args gp_res_regs
    |> fst
    |> List.map ~f:(fun (arg, reg) ->
      mov
        (Reg reg)
        (Reg (Reg.allocated ~class_:(Reg.class_ reg) arg (Some reg))))
  in
  let args' =
    List.zip_with_remainder args gp_res_regs
    |> fst
    |> List.map ~f:(fun (arg, reg) ->
      Reg (Reg.allocated ~class_:(Reg.class_ reg) arg (Some reg)))
  in
  let block =
    Block.create
      ~id_hum
      ~terminal:(Fn_state.alloc_instr t.fn_state ~ir:(X86 (RET args')))
  in
  assert (Call_conv.(equal t.fn.call_conv default));
  (* I can't be bothered to make this not confusing, but we want to set this
       so it gets updated in [Block.iter_and_update_bookkeeping]*)
  Block.set_dfs_id block (Some 0);
  Fn_state.set_block_args t.fn_state ~block ~args:(Vec.of_list args);
  Fn_state.replace_irs
    t.fn_state
    ~block
    ~irs:
      (List.map
         ~f:Ir.x86
         reg_res_moves (* clobbers restores will be added here later *));
  block
;;

let split_blocks_and_add_prologue_and_epilogue t =
  let ret_shape =
    let r = ref None in
    let update x86_ir =
      let this =
        match x86_ir with
        | RET l -> Some (List.length l)
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
    Instr_state.iter (Block.instructions block) ~f:(fun instr ->
      match instr.Instr_state.ir with
      | X86 (ALLOCA (_, i)) ->
        t.fn.bytes_statically_alloca'd
        <- Int64.to_int_exn i + t.fn.bytes_statically_alloca'd
      | _ -> ());
    (* Create intermediate blocks when we go to multiple, for ease of
           implementation of copies for phis *)
    match true_terminal block with
    | None -> ()
    | Some true_terminal ->
      let rep make a b =
        Block.Expert.set_insert_phi_moves block false;
        replace_true_terminal
          ~fn_state:t.fn_state
          block
          (make
             (mint_intermediate t ~from_block:block ~to_call_block:a)
             (Some (mint_intermediate t ~from_block:block ~to_call_block:b)))
      in
      let epilogue_jmp operands_to_ret =
        let args =
          List.zip_exn operands_to_ret (Vec.to_list (Block.args epilogue))
          |> List.map ~f:(fun (operand, arg) ->
            match operand with
            | Reg reg ->
              (match X86_ir.var_of_reg reg with
               | Some v -> v
               | None ->
                 let v = fresh_like_var t arg in
                 Fn_state.append_ir
                   t.fn_state
                   ~block
                   ~ir:(X86 (mov (Reg (Reg.unallocated v)) operand));
                 v)
            | other ->
              let v = fresh_like_var t arg in
              Fn_state.append_ir
                t.fn_state
                ~block
                ~ir:(X86 (mov (Reg (Reg.unallocated v)) other));
              v)
        in
        jmp { Call_block.block = epilogue; args }
      in
      (match true_terminal with
       | RET l when not (phys_equal block epilogue) ->
         replace_true_terminal ~fn_state:t.fn_state block (epilogue_jmp l)
       | RET _ | JMP _ | JNE (_, None) | JE (_, None) -> ()
       | JE (a, Some b) -> rep X86_ir.je a b
       | JNE (a, Some b) ->
         rep X86_ir.jne a b
         (* both of these tag things should prob be handled *)
       | Tag_use _ | Tag_def _ | NOOP | ALLOCA _
       | AND (_, _)
       | OR (_, _)
       | MOV (_, _)
       | ADD (_, _)
       | SUB (_, _)
       | ADDSD (_, _)
       | SUBSD (_, _)
       | MULSD (_, _)
       | DIVSD (_, _)
       | MOVSD (_, _)
       | MOVQ (_, _)
       | CVTSI2SD (_, _)
       | CVTTSD2SI (_, _)
       | IMUL _ | IDIV _ | MOD _ | LABEL _
       | CMP (_, _)
       | Save_clobbers | Restore_clobbers | CALL _ | PUSH _ | POP _ | MFENCE
       | XCHG (_, _)
       | LOCK_ADD (_, _)
       | LOCK_SUB (_, _)
       | LOCK_AND (_, _)
       | LOCK_OR (_, _)
       | LOCK_XOR (_, _)
       | LOCK_CMPXCHG _ | SETE _ | SETL _ -> ()));
  t
;;

let par_moves t ~dst_to_src =
  let module Map = Core.Map.Poly in
  (* Convert vars to regs once and reuse the same reg objects throughout *)
  let dst_src_regs =
    List.map dst_to_src ~f:(fun (dst, src) ->
      reg_of_var t dst, reg_of_var t src)
  in
  let pending = Map.of_alist_exn dst_src_regs |> Ref.create in
  let temp class_ =
    Reg.unallocated
      ~class_
      (fresh_var ~type_:(type_of_class class_) t "regalloc_scratch")
  in
  let emitted = Vec.create () in
  let emit (dst : Reg.t) src =
    let mov' =
      match dst.class_ with
      | I64 -> mov
      | F64 -> movsd
    in
    if Reg.equal dst src
    then ()
    else Vec.push emitted (Ir.x86 (mov' (Reg dst) (Reg src)))
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
         | JMP cb ->
           let dst_to_src =
             List.zip_exn (Vec.to_list (Block.args cb.block)) cb.args
           in
           Fn_state.append_irs
             t.fn_state
             ~block
             ~irs:(par_moves t ~dst_to_src |> Vec.to_list)
         | RET _ -> ()
         | JNE _ | JE _ ->
           (* [block.insert_phi_moves] should be false *)
           failwith "bug"
           (* both of these tag things should prob be handled *)
         | Tag_use _ | Tag_def _ | NOOP
         | AND (_, _)
         | OR (_, _)
         | MOV (_, _)
         | Save_clobbers | Restore_clobbers | ALLOCA _
         | ADD (_, _)
         | SUB (_, _)
         | ADDSD (_, _)
         | SUBSD (_, _)
         | MULSD (_, _)
         | DIVSD (_, _)
         | MOVSD (_, _)
         | MOVQ (_, _)
         | CVTSI2SD (_, _)
         | CVTTSD2SI (_, _)
         | IMUL _ | IDIV _ | MOD _ | LABEL _
         | CMP (_, _)
         | CALL _ | PUSH _ | POP _ | MFENCE
         | XCHG (_, _)
         | LOCK_ADD (_, _)
         | LOCK_SUB (_, _)
         | LOCK_AND (_, _)
         | LOCK_OR (_, _)
         | LOCK_XOR (_, _)
         | LOCK_CMPXCHG _ | SETE _ | SETL _ -> ())));
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

let simple_translation_to_x86_ir ~this_call_conv t =
  let lower_ir ir =
    let res = ir_to_x86_ir ~this_call_conv t ir in
    List.iter res ~f:(fun ir ->
      List.iter (X86_ir.vars ir) ~f:(fun var ->
        add_count t.var_names (Var.name var)));
    res
  in
  Block.iter t.fn.root ~f:(fun block ->
    add_count t.block_names (Block.id_hum block);
    let instructions =
      Instr_state.to_ir_list (Block.instructions block)
      |> List.concat_map ~f:(fun ir -> lower_ir ir |> List.map ~f:Ir0.x86)
    in
    Fn_state.replace_irs t.fn_state ~block ~irs:instructions;
    Fn_state.replace_terminal_ir
      t.fn_state
      ~block
      ~with_:(Ir.x86_terminal (lower_ir (Block.terminal block).Instr_state.ir)));
  t
;;

let run ~fn_state (fn : Function.t) =
  lower_aggregates_exn ~fn_state fn;
  fn
  |> create ~fn_state
  |> expand_atomic_rmw
  |> simple_translation_to_x86_ir ~this_call_conv:fn.call_conv
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
    |> simple_translation_to_x86_ir ~this_call_conv:fn.call_conv
    |> split_blocks_and_add_prologue_and_epilogue
    |> insert_par_moves
    (* |> remove_call_block_args *)
    |> get_fn
  ;;
end
