open! Core
open! Import
open! Common
module Class = X86_reg.Class

type t =
  { block_names : int String.Table.t
  ; var_names : int String.Table.t
  ; var_classes : Class.t Var.Table.t
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

let operand_of_lit_or_var t ~class_ (lit_or_var : Ir.Lit_or_var.t) =
  match lit_or_var with
  | Lit l -> Imm l
  | Var v ->
    require_class t v class_;
    Reg (Reg.unallocated ~class_ v)
;;

let ir_to_x86_ir ~this_call_conv t (ir : Ir.t) =
  assert (Call_conv.(equal this_call_conv default));
  let make_arith f ({ dest; src1; src2 } : Ir.arith) =
    require_class t dest Class.I64;
    let dest_op = Reg (reg_of_var t dest) in
    [ mov dest_op (operand_of_lit_or_var t ~class_:Class.I64 src1)
    ; f dest_op (operand_of_lit_or_var t ~class_:Class.I64 src2)
    ]
  in
  let reg v = Reg (reg_of_var t v) in
  let mul_div_mod ({ dest; src1; src2 } : Ir.arith) ~make_instr ~take_reg =
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
    let src2_op = operand_of_lit_or_var t ~class_:Class.I64 src2 in
    let src2_final, extra_mov =
      match src2_op with
      | Imm _ ->
        let tmp_reg =
          Reg.allocated ~class_:Class.I64 (fresh_var t "tmp_imm") None
        in
        Reg tmp_reg, [ mov (Reg tmp_reg) src2_op ]
      | Reg _ | Mem _ -> src2_op, []
    in
    extra_mov
    @ [ mov (Reg tmp_rax) (operand_of_lit_or_var t ~class_:Class.I64 src1)
      ; tag_def
          (tag_def
             (tag_use (make_instr src2_final) (Reg tmp_rax))
             (Reg tmp_dst))
          (Reg tmp_other)
      ; mov (reg dest) (Reg tmp_dst)
      ]
  in
  match ir with
  | X86 x -> [ x ]
  | X86_terminal xs -> xs
  | Arm64 _ | Arm64_terminal _ -> []
  | Noop | Unreachable -> []
  | And arith -> make_arith and_ arith
  | Or arith -> make_arith or_ arith
  | Add arith -> make_arith add arith
  | Sub arith -> make_arith sub arith
  | Fadd arith ->
    require_class t arith.dest Class.F64;
    let dest_op = Reg (reg_of_var t arith.dest) in
    [ movsd dest_op (operand_of_lit_or_var t ~class_:Class.F64 arith.src1)
    ; addsd dest_op (operand_of_lit_or_var t ~class_:Class.F64 arith.src2)
    ]
  | Fsub arith ->
    require_class t arith.dest Class.F64;
    let dest_op = Reg (reg_of_var t arith.dest) in
    [ movsd dest_op (operand_of_lit_or_var t ~class_:Class.F64 arith.src1)
    ; subsd dest_op (operand_of_lit_or_var t ~class_:Class.F64 arith.src2)
    ]
  | Fmul arith ->
    require_class t arith.dest Class.F64;
    let dest_op = Reg (reg_of_var t arith.dest) in
    [ movsd dest_op (operand_of_lit_or_var t ~class_:Class.F64 arith.src1)
    ; mulsd dest_op (operand_of_lit_or_var t ~class_:Class.F64 arith.src2)
    ]
  | Fdiv arith ->
    require_class t arith.dest Class.F64;
    let dest_op = Reg (reg_of_var t arith.dest) in
    [ movsd dest_op (operand_of_lit_or_var t ~class_:Class.F64 arith.src1)
    ; divsd dest_op (operand_of_lit_or_var t ~class_:Class.F64 arith.src2)
    ]
  | Return lit_or_var ->
    [ RET [ operand_of_lit_or_var t ~class_:Class.I64 lit_or_var ] ]
  | Move (v, lit_or_var) ->
    let class_ = if Type.is_float (Var.type_ v) then Class.F64 else Class.I64 in
    require_class t v class_;
    [ mov (reg v) (operand_of_lit_or_var t ~class_ lit_or_var) ]
  | Cast (dest, src) ->
    (* Type conversion between different types *)
    let dest_type = Var.type_ dest in
    let src_type =
      match src with
      | Ir.Lit_or_var.Var v -> Var.type_ v
      | Ir.Lit_or_var.Lit _ -> Type.I64 (* literals are treated as i64 *)
    in
    let dest_class = if Type.is_float dest_type then Class.F64 else Class.I64 in
    let src_class = if Type.is_float src_type then Class.F64 else Class.I64 in
    require_class t dest dest_class;
    (match src_type, dest_type with
     | t1, t2 when Type.is_integer t1 && Type.is_float t2 ->
       (* Int to float conversion *)
       (* cvtsi2sd can't take immediates, so we need to load literals into a register first *)
       let src_operand = operand_of_lit_or_var t ~class_:src_class src in
       (match src_operand with
        | Imm _ ->
          (* Load immediate into a temporary register first *)
          let tmp_reg =
            Reg.allocated ~class_:Class.I64 (fresh_var t "tmp_cvt") None
          in
          [ mov (Reg tmp_reg) src_operand
          ; cvtsi2sd (Reg (reg_of_var t dest)) (Reg tmp_reg)
          ]
        | Reg _ | Mem _ -> [ cvtsi2sd (Reg (reg_of_var t dest)) src_operand ])
     | t1, t2 when Type.is_float t1 && Type.is_integer t2 ->
       (* Float to int conversion (with truncation) *)
       [ cvttsd2si
           (Reg (reg_of_var t dest))
           (operand_of_lit_or_var t ~class_:src_class src)
       ]
     | t1, t2 when Type.is_integer t1 && Type.is_integer t2 ->
       (* Int to int conversion (sign-extend or truncate) *)
       (* For now, just use mov - x86 will handle sign extension/truncation *)
       [ mov
           (Reg (reg_of_var t dest))
           (operand_of_lit_or_var t ~class_:Class.I64 src)
       ]
     | _ ->
       (* Float to float or other conversions not yet supported *)
       failwithf
         "Unsupported cast from %s to %s"
         (Type.to_string src_type)
         (Type.to_string dest_type)
         ())
  | Load (v, mem) ->
    require_class t v Class.I64;
    let pre, mem_op =
      match mem with
      | Ir.Mem.Stack_slot _ -> [], Ir.Mem.to_x86_ir_operand mem
      | Ir.Mem.Address { base = Ir.Lit_or_var.Var v; offset } ->
        let base = Reg.allocated ~class_:Class.I64 v None in
        [], Mem (base, offset)
      | Ir.Mem.Address { base = Ir.Lit_or_var.Lit addr; offset } ->
        let tmp_addr =
          Reg.allocated ~class_:Class.I64 (fresh_var t "tmp_addr") None
        in
        [ mov (Reg tmp_addr) (Imm addr) ], Mem (tmp_addr, offset)
    in
    pre @ [ mov (reg v) mem_op ]
  | Store (lit_or_var, mem) ->
    let pre, mem_op =
      match mem with
      | Ir.Mem.Stack_slot _ -> [], Ir.Mem.to_x86_ir_operand mem
      | Ir.Mem.Address { base = Ir.Lit_or_var.Var v; offset } ->
        let base = Reg.allocated ~class_:Class.I64 v None in
        [], Mem (base, offset)
      | Ir.Mem.Address { base = Ir.Lit_or_var.Lit addr; offset } ->
        let tmp_addr =
          Reg.allocated ~class_:Class.I64 (fresh_var t "tmp_addr") None
        in
        [ mov (Reg tmp_addr) (Imm addr) ], Mem (tmp_addr, offset)
    in
    pre @ [ mov mem_op (operand_of_lit_or_var t ~class_:Class.I64 lit_or_var) ]
  | Mul arith -> mul_div_mod arith ~take_reg:Reg.rax ~make_instr:imul
  | Div arith -> mul_div_mod arith ~take_reg:Reg.rax ~make_instr:idiv
  | Mod arith -> mul_div_mod arith ~take_reg:Reg.rdx ~make_instr:mod_
  | Call { fn; results; args } ->
    assert (Call_conv.(equal (call_conv ~fn) default));
    let gp_arg_regs = Reg.arguments ~call_conv:(call_conv ~fn) Class.I64 in
    let reg_args, stack_args = List.split_n args (List.length gp_arg_regs) in
    let stack_arg_pushes =
      List.rev stack_args
      |> List.map ~f:(fun arg ->
        push (operand_of_lit_or_var t ~class_:Class.I64 arg))
    in
    let reg_arg_moves =
      List.zip_with_remainder reg_args gp_arg_regs
      |> fst
      |> List.map ~f:(fun (arg, reg) ->
        let force_physical =
          Reg.allocated ~class_:Class.I64 (fresh_var t "arg_reg") (Some reg)
        in
        mov (Reg force_physical) (operand_of_lit_or_var t ~class_:Class.I64 arg))
    in
    let pre_moves = stack_arg_pushes @ reg_arg_moves in
    (* CR-soon: compound results via arg to pointer *)
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
      if List.is_empty stack_args
      then []
      else
        [ add (Reg Reg.rsp) (Imm (Int64.of_int (List.length stack_args * 8))) ]
    in
    [ save_clobbers ]
    @ pre_moves
    @ [ CALL
          { fn
          ; results = updated_results
          ; args = List.map args ~f:(operand_of_lit_or_var t ~class_:Class.I64)
          }
      ]
    @ post_moves
    @ post_pop
    @ [ restore_clobbers ]
  | Alloca { dest; size = Lit i } -> [ alloca (Reg (Reg.unallocated dest)) i ]
  | Alloca { dest; size = Var v } ->
    [ mov (reg dest) (Reg Reg.rsp)
    ; sub (Reg Reg.rsp) (Reg (Reg.unallocated v))
    ]
  | Branch (Uncond cb) -> [ jmp cb ]
  | Branch (Cond { cond; if_true; if_false }) ->
    [ cmp (operand_of_lit_or_var t ~class_:Class.I64 cond) (Imm Int64.zero)
    ; jne if_true (Some if_false)
    ]
;;

let get_fn = fn

let create fn =
  { block_names = String.Table.create ()
  ; var_names = String.Table.create ()
  ; var_classes = Var.Table.create ()
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
    "intermediate_" ^ from_block.id_hum ^ "_to_" ^ to_call_block.block.id_hum
    |> Util.new_name t.block_names
  in
  let block = Block.create ~id_hum ~terminal:(X86 (X86_ir.jmp to_call_block)) in
  (* I can't be bothered to make this not confusing, but we want to set this
       so it gets updated in [Block.iter_and_update_bookkeeping]*)
  block.dfs_id <- Some 0;
  (* The intermediate block doesn't need formal parameters - it's just a place
     to insert phi moves. The phi moves will be generated by insert_par_moves
     based on the mismatch between to_call_block.args and to_call_block.block.args *)
  { Call_block.block; args = to_call_block.args }
;;

let make_prologue t =
  let id_hum = t.fn.name ^ "__prologue" |> Util.new_name t.block_names in
  (* As we go in, stack is like
       arg_n, arg_n+1, ..., return addr
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
      let stack_offset = (i + 1) * 8 in
      mov (Reg (Reg.unallocated arg)) (Mem (Reg.rbp, stack_offset)))
  in
  let block =
    Block.create ~id_hum ~terminal:(X86 (jmp { block = t.fn.root; args }))
  in
  assert (Call_conv.(equal t.fn.call_conv default));
  (* I can't be bothered to make this not confusing, but we want to set this
       so it gets updated in [Block.iter_and_update_bookkeeping]*)
  block.dfs_id <- Some 0;
  block.args <- Vec.of_list args;
  block.instructions
  <- List.map
       ~f:Ir.x86
       (reg_arg_moves
        @ stack_arg_moves
        @ [ tag_def noop (Reg Reg.rbp) ]
          (* clobber and stack adjustment/saves will be added here later. Also subtracting stack for spills and alloca *)
       )
     |> Vec.of_list;
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
  let block = Block.create ~id_hum ~terminal:(X86 (RET args')) in
  assert (Call_conv.(equal t.fn.call_conv default));
  (* I can't be bothered to make this not confusing, but we want to set this
       so it gets updated in [Block.iter_and_update_bookkeeping]*)
  block.dfs_id <- Some 0;
  block.args <- Vec.of_list args;
  block.instructions
  <- List.map
       ~f:Ir.x86
       reg_res_moves (* clobbers restores will be added here later *)
     |> Vec.of_list;
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
    Block.iter_instructions t.fn.root ~f:(on_arch_irs ~f:update);
    !r
  in
  let prologue = make_prologue t in
  let epilogue = make_epilogue t ~ret_shape in
  (* CR-soon: Omit prologue and epilogue if unneeded (eg. leaf fn) *)
  t.fn.prologue <- Some prologue;
  t.fn.epilogue <- Some epilogue;
  t.fn.root <- prologue;
  Block.iter_and_update_bookkeeping t.fn.root ~f:(fun block ->
    Vec.map_inplace block.instructions ~f:(function
      | X86 (ALLOCA (dest, i)) ->
        let offset = t.fn.bytes_alloca'd in
        t.fn.bytes_alloca'd <- Int64.to_int_exn i + t.fn.bytes_alloca'd;
        (match dest with
         | Reg _ ->
           X86_terminal
             ([ mov dest (Reg Reg.rbp) ]
              @
              if offset = 0
              then []
              else [ add dest (Imm (Int64.of_int offset)) ])
         | _ -> failwith "alloca dest must be a register")
      | ir -> ir);
    (* Create intermediate blocks when we go to multiple, for ease of
           implementation of copies for phis *)
    match true_terminal block with
    | None -> ()
    | Some true_terminal ->
      let rep make a b =
        block.insert_phi_moves <- false;
        replace_true_terminal
          block
          (make
             (mint_intermediate t ~from_block:block ~to_call_block:a)
             (Some (mint_intermediate t ~from_block:block ~to_call_block:b)))
      in
      let epilogue_jmp operands_to_ret =
        let args =
          List.zip_exn operands_to_ret (Vec.to_list epilogue.args)
          |> List.map ~f:(fun (operand, arg) ->
            match operand with
            | Reg reg ->
              (match var_of_reg reg with
               | Some v -> v
               | None ->
                 let v = fresh_like_var t arg in
                 Vec.push
                   block.instructions
                   (X86 (mov (Reg (Reg.unallocated v)) operand));
                 v)
            | other ->
              let v = fresh_like_var t arg in
              Vec.push
                block.instructions
                (X86 (mov (Reg (Reg.unallocated v)) other));
              v)
        in
        jmp { Call_block.block = epilogue; args }
      in
      (match true_terminal with
       | RET l when not (phys_equal block epilogue) ->
         replace_true_terminal block (epilogue_jmp l)
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
       | Save_clobbers | Restore_clobbers | CALL _ | PUSH _ | POP _ -> ()));
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
    if not block.insert_phi_moves
    then ()
    else (
      match true_terminal block with
      | None -> ()
      | Some true_terminal ->
        (match true_terminal with
         | JMP cb ->
           let dst_to_src = List.zip_exn (Vec.to_list cb.block.args) cb.args in
           Vec.append block.instructions (par_moves t ~dst_to_src)
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
         | CALL _ | PUSH _ | POP _ -> ())));
  t
;;

let remove_call_block_args t =
  Block.iter t.fn.root ~f:(fun block ->
    block.terminal <- Ir.remove_block_args block.terminal
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
    add_count t.block_names block.id_hum;
    block.instructions
    <- Vec.concat_map block.instructions ~f:(fun ir ->
         lower_ir ir |> Vec.of_list |> Vec.map ~f:Ir0.x86);
    block.terminal <- Ir.x86_terminal (lower_ir block.terminal));
  t
;;

let run (fn : Function.t) =
  fn
  |> create
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
    fn
    |> create
    |> simple_translation_to_x86_ir ~this_call_conv:fn.call_conv
    |> split_blocks_and_add_prologue_and_epilogue
    |> insert_par_moves
    (* |> remove_call_block_args *)
    |> get_fn
  ;;
end
