open! Core
open X86_ir

let new_name map v =
  let v' =
    match Hashtbl.find map v with
    | None -> v
    | Some i -> v ^ Int.to_string i
  in
  Hashtbl.update map v ~f:(function
    | None -> 0
    | Some i -> i + 1);
  v'
;;

let on_x86_irs (ir : Ir.t) ~f =
  match ir with
  | X86 x86 -> f x86
  | X86_terminal x86s -> List.iter x86s ~f
  | _ -> ()
;;

(* CR-soon ewilliams: This should lookup smth *)
let call_conv ~fn:_ = Call_conv.Default

let bytes_for_args ~fn:({ args; call_conv = Default; _ } : Function.t) =
  Int.max (List.length args - List.length Reg.integer_arguments) 0
;;

let ir_to_x86_ir ~this_call_conv ~var_names (ir : Ir.t) =
  assert (Call_conv.(equal this_call_conv default));
  let operand_of_lit_or_var (lit_or_var : Ir.Lit_or_var.t) =
    match lit_or_var with
    | Lit l -> Imm l
    | Var v -> Reg (Reg.unallocated v)
  in
  let make_arith f ({ dest; src1; src2 } : Ir.arith) =
    let dest = Reg (Reg.unallocated dest) in
    [ mov dest (operand_of_lit_or_var src1)
    ; f dest (operand_of_lit_or_var src2)
    ]
  in
  let reg v = Reg (Reg.unallocated v) in
  let mul_div_mod ({ dest; src1; src2 } : Ir.arith) ~make_instr ~take_reg =
    let tmp_rax = Reg.allocated (new_name var_names "tmp_rax") (Some Reg.rax) in
    let tmp_dst =
      Reg.allocated (new_name var_names "tmp_dst") (Some take_reg)
    in
    [ mov (Reg tmp_rax) (Ir.Lit_or_var.to_x86_ir_operand src1)
    ; tag_def
        (tag_use
           (make_instr (Ir.Lit_or_var.to_x86_ir_operand src2))
           (Reg tmp_rax))
        (Reg tmp_dst)
    ; mov (reg dest) (Reg tmp_dst)
    ]
  in
  match ir with
  | X86 x -> [ x ]
  | X86_terminal xs -> xs
  | Noop | Unreachable -> []
  | And arith -> make_arith and_ arith
  | Or arith -> make_arith or_ arith
  | Add arith -> make_arith add arith
  | Sub arith -> make_arith sub arith
  | Return lit_or_var -> [ RET [ operand_of_lit_or_var lit_or_var ] ]
  | Move (v, lit_or_var) -> [ mov (reg v) (operand_of_lit_or_var lit_or_var) ]
  | Load (v, mem) ->
    let force_physical =
      Reg.allocated (new_name var_names "tmp_force_physical") None
    in
    [ mov (Reg force_physical) (Ir.Mem.to_x86_ir_operand mem)
    ; mov (reg v) (Reg force_physical)
    ]
  | Store (lit_or_var, mem) ->
    let force_physical =
      Reg.allocated (new_name var_names "tmp_force_physical") None
    in
    [ mov (Reg force_physical) (operand_of_lit_or_var lit_or_var)
    ; mov
        (Ir.Mem.to_x86_ir_operand mem)
        (Ir0.Lit_or_var.to_x86_ir_operand lit_or_var)
    ]
  | Mul arith -> mul_div_mod arith ~take_reg:Reg.rax ~make_instr:imul
  | Div arith -> mul_div_mod arith ~take_reg:Reg.rax ~make_instr:idiv
  | Mod arith -> mul_div_mod arith ~take_reg:Reg.rdx ~make_instr:mod_
  | Call { fn; results; args } ->
    assert (Call_conv.(equal (call_conv ~fn) default));
    let num_stack_args =
      Int.max 0 (List.length args - List.length Reg.integer_arguments)
    in
    let pre_moves =
      Sequence.zip_full
        (Sequence.of_list args)
        (Sequence.of_list X86_ir.Reg.integer_arguments)
      |> Sequence.filter_map ~f:(function
        | `Right _ -> None
        | `Left x -> Some (push (operand_of_lit_or_var x))
        | `Both (arg, reg) ->
          let force_physical =
            Reg.allocated (new_name var_names "arg_reg") (Some reg)
          in
          let instr = mov (Reg force_physical) (operand_of_lit_or_var arg) in
          Some instr)
      |> Sequence.to_list
    in
    (* CR-soon ewilliams: compound results via arg to pointer *)
    assert (List.length results <= 2);
    let post_moves =
      Sequence.zip_full
        (Sequence.of_list results)
        (Sequence.of_list X86_ir.Reg.integer_results)
      |> Sequence.filter_map ~f:(function
        | `Right _ -> None
        | `Left _ -> failwith "impossible"
        | `Both (res, reg) ->
          let instr = mov (Reg (Reg.unallocated res)) (Reg reg) in
          Some instr)
      |> Sequence.to_list
    in
    let post_pop =
      if num_stack_args = 0
      then []
      else [ sub (Reg RSP) (Imm (Int64.of_int (num_stack_args * 8))) ]
    in
    [ save_clobbers ]
    @ pre_moves
    @ [ CALL
          { fn
          ; results = List.map results ~f:Reg.unallocated
          ; args = List.map args ~f:operand_of_lit_or_var
          }
      ]
    @ post_moves
    @ post_pop
    @ [ restore_clobbers ]
  | Alloca { dest; size = Lit i } -> [ alloca (Reg (Reg.unallocated dest)) i ]
  | Alloca { dest; size = Var v } ->
    [ mov (reg dest) (Reg Reg.RSP)
    ; sub (Reg Reg.RSP) (Reg (Reg.unallocated v))
    ]
  | Branch (Uncond cb) -> [ jmp cb ]
  | Branch (Cond { cond; if_true; if_false }) ->
    [ cmp (operand_of_lit_or_var cond) (Imm Int64.zero)
    ; jne if_true (Some if_false)
    ]
;;

let true_terminal (x86_block : Block.t) : Block.t X86_ir.t option =
  match x86_block.terminal with
  | X86 terminal -> Some terminal
  | X86_terminal terminals -> List.last terminals
  | Noop | And _ | Or _ | Add _ | Sub _ | Mul _ | Div _ | Mod _ | Alloca _
  | Load (_, _)
  | Store (_, _)
  | Move (_, _)
  | Branch _ | Return _ | Unreachable | Call _ -> None
;;

let replace_true_terminal (x86_block : Block.t) new_true_terminal =
  match x86_block.terminal with
  | X86 _terminal -> x86_block.terminal <- X86 new_true_terminal
  | X86_terminal terminals ->
    x86_block.terminal
    <- X86_terminal
         (List.take terminals (List.length terminals - 1)
          @ [ new_true_terminal ])
  | Noop | And _ | Or _ | Add _ | Sub _ | Mul _ | Div _ | Mod _ | Alloca _
  | Load (_, _)
  | Store (_, _)
  | Move (_, _)
  | Branch _ | Return _ | Unreachable | Call _ -> ()
;;

module Out_of_ssa = struct
  type t =
    { block_names : int String.Table.t
    ; var_names : int String.Table.t
    ; fn : Function.t
    }
  [@@deriving fields]

  let get_fn = fn

  let create fn =
    { block_names = String.Table.create ()
    ; var_names = String.Table.create ()
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
      |> new_name t.block_names
    in
    let block =
      Block.create ~id_hum ~terminal:(X86 (X86_ir.jmp to_call_block))
    in
    (* I can't be bothered to make this not confusing, but we want to set this
       so it gets updated in [Block.iter_and_update_bookkeeping]*)
    block.dfs_id <- Some 0;
    block.args <- Vec.of_list to_call_block.args;
    { Call_block.block; args = to_call_block.args }
  ;;

  let simple_translation_to_x86_ir ~this_call_conv t =
    let ir_to_x86_ir ir =
      let res = ir_to_x86_ir ~this_call_conv ~var_names:t.var_names ir in
      List.iter res ~f:(fun ir ->
        List.iter (X86_ir.vars ir) ~f:(add_count t.var_names));
      res
    in
    Block.iter t.fn.root ~f:(fun block ->
      add_count t.block_names block.id_hum;
      block.instructions
      <- Vec.concat_map block.instructions ~f:(fun ir ->
           ir_to_x86_ir ir |> Vec.of_list |> Vec.map ~f:Ir0.x86);
      block.terminal <- Ir.x86_terminal (ir_to_x86_ir block.terminal));
    t
  ;;

  let make_prologue t =
    let id_hum = t.fn.name ^ "__prologue" |> new_name t.block_names in
    (* As we go in, stack is like
       arg_n, arg_n+1, ..., return addr
    *)
    let args = List.map t.fn.args ~f:(new_name t.var_names) in
    let reg_args, args_on_stack =
      List.split_n args (List.length Reg.integer_arguments)
    in
    let reg_arg_moves =
      List.zip_with_remainder reg_args Reg.integer_arguments
      |> fst
      |> List.map ~f:(fun (arg, reg) ->
        mov (Reg (Reg.allocated arg (Some reg))) (Reg reg))
    in
    let stack_arg_moves =
      List.rev args_on_stack
      |> List.mapi ~f:(fun i arg ->
        let stack_offset =
          (* go to front of this reg, and we also need to skip the ret addr *)
          -((i + 2) * 8)
        in
        mov (Reg (Reg.unallocated arg)) (Mem (RSP, stack_offset)))
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
          @ [ mov (Reg RBP) (Reg RSP) ]
            (* clobber saves will be added here later. Also subtracting stack for spills and alloca *)
         )
       |> Vec.of_list;
    block
  ;;

  let make_epilogue t ~ret_shape =
    let id_hum = t.fn.name ^ "__epilogue" |> new_name t.block_names in
    (* As we go in, stack is like
       arg_n, arg_n+1, ..., return addr
    *)
    let args =
      List.init (Option.value ret_shape ~default:0) ~f:(fun i ->
        new_name t.var_names ("res__" ^ Int.to_string i))
    in
    let reg_res_moves =
      List.zip_with_remainder args Reg.integer_results
      |> fst
      |> List.map ~f:(fun (arg, reg) ->
        mov (Reg (Reg.allocated arg (Some reg))) (Reg reg))
    in
    let args' =
      List.zip_with_remainder args Reg.integer_results
      |> fst
      |> List.map ~f:(fun (arg, reg) -> Reg (Reg.allocated arg (Some reg)))
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
      Block.iter_instructions t.fn.root ~f:(on_x86_irs ~f:update);
      !r
    in
    let prologue = make_prologue t in
    let epilogue = make_epilogue t ~ret_shape in
    (* CR-soon ewilliams: Omit prologue and epilogue if unneeded (eg. leaf fn) *)
    t.fn.prologue <- Some prologue;
    t.fn.epilogue <- Some epilogue;
    t.fn.root <- prologue;
    Block.iter_and_update_bookkeeping t.fn.root ~f:(fun block ->
      Vec.map_inplace block.instructions ~f:(function
        | X86 (ALLOCA (dest, i)) ->
          let ir = mov dest (Mem (RBP, t.fn.bytes_alloca'd)) in
          t.fn.bytes_alloca'd <- Int64.to_int_exn i + t.fn.bytes_alloca'd;
          X86 ir
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
              | Reg (Allocated (v, _) | Unallocated v) -> v
              | other ->
                let v = new_name t.var_names arg in
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
         | IMUL _ | IDIV _ | MOD _ | LABEL _
         | CMP (_, _)
         | Save_clobbers | Restore_clobbers | CALL _ | PUSH _ | POP _ -> ()));
    t
  ;;

  let par_moves t ~dst_to_src =
    let pending =
      List.map dst_to_src ~f:(fun (dst, src) ->
        Reg.unallocated dst, Reg.unallocated src)
      |> Reg.Map.of_alist_exn
      |> Ref.create
    in
    let temp () = new_name t.var_names "regalloc_scratch" |> Reg.unallocated in
    let emitted = Vec.create () in
    let emit dst src =
      if Reg.equal dst src
      then ()
      else Vec.push emitted (Ir.x86 (mov (Reg dst) (Reg src)))
    in
    let rec go () =
      if Map.is_empty !pending
      then ()
      else (
        let emitted_any =
          Map.fold
            !pending
            ~init:false
            ~f:(fun ~key:dst ~data:src emitted_any ->
              if Map.mem !pending src
              then emitted_any
              else (
                emit dst src;
                pending := Map.remove !pending dst;
                true))
        in
        if not emitted_any
        then (
          let _dst, src = Map.min_elt_exn !pending in
          let tmp = temp () in
          emit tmp src;
          pending
          := Map.map !pending ~f:(fun src' ->
               if Reg.equal src' src then tmp else src'));
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
             let dst_to_src =
               List.zip_exn (Vec.to_list cb.block.args) cb.args
             in
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
           | IMUL _ | IDIV _ | MOD _ | LABEL _
           | CMP (_, _)
           | CALL _ | PUSH _ | POP _ -> ())));
    t
  ;;

  let remove_call_block_args t =
    Block.iter t.fn.root ~f:(fun block ->
      block.terminal <- Ir.remove_block_args block.terminal);
    t
  ;;

  let process (fn : Function.t) =
    fn
    |> create
    |> simple_translation_to_x86_ir ~this_call_conv:fn.call_conv
    |> split_blocks_and_add_prologue_and_epilogue
    |> insert_par_moves
    |> remove_call_block_args
    (* CR-soon ewilliams: Some peephole opts to make things less absurd
       omit pointless instructions (eg. moves to constants, moves to same reg, etc.)
    *)
    |> get_fn
  ;;
end

module Reg_numbering = struct
  type var_state =
    { mutable num_uses : int
    ; id : int
    ; var : string
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
end

module Liveness = struct
  type t =
    { (* CR-soon ewilliams: prob use bitsets *)
      live_in : Int.Set.t
    ; live_out : Int.Set.t
    }
  [@@deriving fields, equal, compare, sexp]

  let empty = { live_in = Int.Set.empty; live_out = Int.Set.empty }
end

module Liveness_state = struct
  type block_liveness =
    { mutable instructions : Liveness.t Vec.t
    ; mutable terminal : Liveness.t
    ; mutable overall : Liveness.t
    ; defs : Int.Set.t
    ; uses : Int.Set.t
    }
  [@@deriving fields, sexp]

  type t =
    { blocks : block_liveness Block.Table.t
    ; reg_numbering : Reg_numbering.t
    }
  [@@deriving fields, sexp]

  let block_liveness t block = Hashtbl.find_exn t.blocks block
  let var_id t v = (Reg_numbering.var_state t.reg_numbering v).id
  let ir_uses t ir = Ir.uses ir |> List.map ~f:(var_id t) |> Int.Set.of_list
  let ir_defs t ir = Ir.defs ir |> List.map ~f:(var_id t) |> Int.Set.of_list

  (* uses = uses that aren't yet defined in block *)
  let defs_and_uses t ~(block : Block.t) =
    let f (~defs, ~uses) (ir : Ir.t) =
      let new_uses = Set.diff (ir_uses t ir) defs in
      let uses = Set.union uses new_uses in
      let defs = Set.union defs (ir_defs t ir) in
      ~defs, ~uses
    in
    let uses =
      List.map (Vec.to_list block.args) ~f:(var_id t) |> Int.Set.of_list
    in
    let acc =
      Vec.fold block.instructions ~init:(~defs:Int.Set.empty, ~uses) ~f
    in
    f acc block.terminal
  ;;

  let calculate_intra_block_liveness t root =
    (* print_s [%sexp (t.reg_numbering : Reg_numbering.t)]; *)
    Block.iter root ~f:(fun block ->
      let block_liveness = block_liveness t block in
      let f ({ live_in; _ } : Liveness.t) ir =
        let new_live_in =
          Set.union (ir_uses t ir) (Set.diff live_in (ir_defs t ir))
        in
        (* let () = *)
        (*   let live_out = *)
        (*     String.Set.map live_in ~f:(Reg_numbering.id_var t.reg_numbering) *)
        (*   in *)
        (*   let live_in = *)
        (*     String.Set.map new_live_in ~f:(Reg_numbering.id_var t.reg_numbering) *)
        (*   in *)
        (*   print_s *)
        (*     [%message *)
        (*       (ir : Ir.t) *)
        (*         ~_: *)
        (*           ([%sexp { live_in : String.Set.t; live_out : String.Set.t }] *)
        (*            : Sexp.t)] *)
        (* in *)
        { Liveness.live_in = new_live_in; live_out = live_in }
      in
      block_liveness.terminal <- f block_liveness.overall block.terminal;
      (* prob unnecessary *)
      Vec.clear block_liveness.instructions;
      let (_ : Liveness.t) =
        Vec.foldr
          block.instructions
          ~init:block_liveness.terminal
          ~f:(fun liveness ir ->
            let liveness = f liveness ir in
            Vec.push block_liveness.instructions liveness;
            liveness)
      in
      Vec.reverse_inplace block_liveness.instructions)
  ;;

  let initialize_block_liveness t block =
    let ~defs, ~uses = defs_and_uses t ~block in
    Hashtbl.set
      t.blocks
      ~key:block
      ~data:
        { instructions = Vec.create ()
        ; terminal = Liveness.empty
        ; overall = Liveness.empty
        ; defs
        ; uses
        }
  ;;

  let calculate_block_liveness t root =
    let worklist = Queue.create () in
    Block.iter root ~f:(Queue.enqueue worklist);
    while not (Queue.is_empty worklist) do
      let block = Queue.dequeue_exn worklist in
      (* live_out[b] = U LIVE_IN[succ] *)
      let new_live_out =
        block.children
        |> Vec.to_list
        |> List.map ~f:(fun block ->
          block_liveness t block |> overall |> Liveness.live_in)
        |> Int.Set.union_list
      in
      (* live_in[b] = use U (live_out / def) *)
      let new_live_in =
        Set.union
          (block_liveness t block).uses
          (Set.diff new_live_out (block_liveness t block).defs)
      in
      let new_liveness =
        { Liveness.live_in = new_live_in; live_out = new_live_out }
      in
      if not (Liveness.equal new_liveness (block_liveness t block).overall)
      then (
        (block_liveness t block).overall <- new_liveness;
        (* only needs pred blocks but cbf to compute *)
        Block.iter root ~f:(Queue.enqueue worklist))
    done
  ;;

  let create ~reg_numbering root =
    let t = { blocks = Block.Table.create (); reg_numbering } in
    Block.iter root ~f:(initialize_block_liveness t);
    calculate_block_liveness t root;
    calculate_intra_block_liveness t root;
    t
  ;;

  let block_instructions_with_liveness t ~(block : Block.t) =
    let block_liveness = block_liveness t block in
    let instructions =
      List.zip_exn
        (Vec.to_list block.instructions)
        (Vec.to_list block_liveness.instructions)
    in
    let terminal = block.terminal, block_liveness.terminal in
    ~instructions, ~terminal
  ;;
end

module Regalloc = struct
  module Interference_graph = struct
    module Var_pair = struct
      type t = int * int [@@deriving sexp, compare, equal]

      let create a b : t = if a <= b then a, b else b, a

      include functor Comparable.Make
    end

    type t = Var_pair.Set.t [@@deriving sexp, compare, equal]

    let interfere t a b = if a = b then t else Set.add t (Var_pair.create a b)
    let empty = Var_pair.Set.empty
    let edges t = t

    let create ~reg_numbering:_ ~liveness_state root =
      let t = ref empty in
      let add_edge u v = t := interfere !t u v in
      Block.iter root ~f:(fun block ->
        let block_liveness =
          Liveness_state.block_liveness liveness_state block
        in
        let zipped =
          List.zip_exn
            (Vec.to_list block.instructions @ [ block.terminal ])
            (Vec.to_list block_liveness.instructions
             @ [ block_liveness.terminal ])
          (* |> List.map ~f:(fun (ir, liveness) -> *)
          (*   let live_in = *)
          (*     String.Set.map *)
          (*       liveness.live_in *)
          (*       ~f:(Reg_numbering.id_var reg_numbering) *)
          (*   in *)
          (*   let live_out = *)
          (*     String.Set.map *)
          (*       liveness.live_out *)
          (*       ~f:(Reg_numbering.id_var reg_numbering) *)
          (*   in *)
          (*   ( ir *)
          (*   , ( liveness *)
          (*     , ( [%sexp { live_in : String.Set.t; live_out : String.Set.t }] *)
          (*       , Ir.uses ir *)
          (*       , Ir.defs ir ) ) )) *)
        in
        (* print_s *)
        (*   [%message *)
        (*     (zipped : (Ir.t * (_ * (Sexp.t * string list * string list))) list)]; *)
        List.iter zipped ~f:(fun (ir, liveness (* , _) *)) ->
          List.iter (Ir.defs ir) ~f:(fun var ->
            let u = Liveness_state.var_id liveness_state var in
            Set.iter liveness.live_out ~f:(add_edge u))));
      !t
    ;;

    let print ~reg_numbering t =
      let edges =
        Set.to_list t
        |> List.map ~f:(fun (a, b) ->
          ( Reg_numbering.id_var reg_numbering a
          , Reg_numbering.id_var reg_numbering b ))
      in
      print_s [%sexp (edges : (String.t * String.t) list)]
    ;;
  end

  module Assignment = struct
    type t =
      | Spill
      | Reg of Reg.t
    [@@deriving sexp, compare, hash, variants]
  end

  let update_assignment ~assignments ~var ~to_ =
    Hashtbl.update assignments var ~f:(function
      | None -> Assignment.reg to_
      | Some (Assignment.Reg to' as x) when Reg.equal to' to_ -> x
      | Some a ->
        Error.raise_s
          [%message
            "Want to assign phys reg but already found"
              (a : Assignment.t)
              (to_ : Reg.t)])
  ;;

  let initialize_assignments root =
    let assignments = Var.Table.create () in
    let don't_spill = Var.Hash_set.create () in
    Block.iter_instructions root ~f:(fun ir ->
      Ir.x86_regs ir
      |> List.iter ~f:(function
        (* pretty ugly, cbf to clean *)
        | Allocated (_, Some (Allocated _)) | Allocated (_, Some (Unallocated _))
          -> failwith "bug"
        | Reg.Allocated (var, Some to_) ->
          update_assignment ~assignments ~var ~to_
        | Reg.Allocated (var, None) -> Hash_set.add don't_spill var
        | _ -> ()));
    ~assignments, ~don't_spill
  ;;

  let implies a b = [| [| -a; b |] |]
  let iff a b = [| [| -a; b |]; [| -b; a |] |]
  let xor a b = iff a (-b)

  let at_most_one variables =
    [| [| -variables.(i); -variables.(j) |]
       for i = 0 to Array.length variables - 1
       for j = i + 1 to Array.length variables - 1
    |]
  ;;

  let exactly_one variables =
    Array.concat
      [ [| variables |]
      ; [| [| -variables.(i); -variables.(j) |]
           for i = 0 to Array.length variables - 1
           for j = i + 1 to Array.length variables - 1
        |]
      ]
  ;;

  module type Sat = sig
    val run : unit -> unit
  end

  let run_sat
    ~dump_crap
    ~reg_numbering
    ~interference_graph
    ~assignments
    ~don't_spill
    =
    let (module Sat) =
      (module struct
        let reg_pool : Reg.t array =
          [| RAX; RBX; RCX; RDX; R8; R9; R10; R11; R12; R13; R14; R15 |]
        ;;

        let sat_vars_per_var_id =
          (* there is also a var for if spilled, but that is just 0 index (phys reg ids are > 0)*)
          Array.length reg_pool + 1
        ;;

        (* Can eventually fuse non interfering registers

     but if one is allocated to a specific physical register, we can only fuse variables that don't interfere with the same physical register

     After all this can kill moves to same reg
        *)

        let var_ids =
          Reg_numbering.vars reg_numbering
          |> Hashtbl.data
          |> List.map ~f:Reg_numbering.id
          |> Array.of_list
        ;;

        let spill var_id = (var_id * sat_vars_per_var_id) + 1
        let reg_sat var_id idx = spill var_id + idx + 1

        let backout_sat_var var =
          let var_id = (var - 1) / sat_vars_per_var_id in
          let reg = (var - 1) mod sat_vars_per_var_id in
          if reg = 0
          then var_id, `Spill
          else var_id, `Assignment reg_pool.(reg - 1)
        ;;

        let all_reg_assignments var_id =
          [| reg_sat var_id i for i = 0 to Array.length reg_pool - 1 |]
        ;;

        let sat_constraints =
          (*
             Setup:
             1. a variable for whether [id] is spilled
                - use this as a flag before each relevant condition, so we can disable them easily via assumptions
                - start by pushing assumptions that all of these are false, and if we spill a variable, push it as true
             2. a variable for each physical reg saying [id] is assigned that physical reg
                - exactly one of these must be true
                - when variables are conflicting, we push a constraint to have [^a or ^b]
          *)
          let exactly_one_reg_per_var =
            Array.concat_map var_ids ~f:(fun var_id ->
              Array.map
                (exactly_one (all_reg_assignments var_id))
                ~f:(fun arr -> Array.append [| spill var_id |] arr))
          in
          let interferences =
            Interference_graph.edges interference_graph
            |> Set.to_array
            |> Array.concat_map ~f:(fun (var_id, var_id') ->
              Array.zip_exn
                (all_reg_assignments var_id)
                (all_reg_assignments var_id')
              |> Array.map ~f:(fun (ass, ass') -> [| -ass; -ass' |]))
          in
          Array.append exactly_one_reg_per_var interferences
        ;;

        let () =
          if dump_crap
          then
            print_s
              [%message "SAT constraints" (sat_constraints : int array array)]
        ;;

        let pror = Pror_rs.create_with_problem sat_constraints

        let to_spill =
          Reg_numbering.vars reg_numbering
          |> Hashtbl.data
          |> List.filter ~f:(fun { var; _ } ->
            (not (Hashtbl.mem assignments var))
            && not (Hash_set.mem don't_spill var))
          |> List.sort
               ~compare:
                 (Comparable.lift Int.compare ~f:Reg_numbering.var_state_score)
          |> Ref.create
        ;;

        let assumptions () =
          Reg_numbering.vars reg_numbering
          |> Hashtbl.to_alist
          |> Array.of_list
          |> Array.map ~f:(fun (var, { id; _ }) ->
            match (Hashtbl.find assignments var : Assignment.t option) with
            | Some Spill -> spill id
            | Some (Reg reg) ->
              (match
                 Array.findi reg_pool ~f:(fun _i reg' -> Reg.equal reg reg')
               with
               | None -> spill id
               (* we can just pretend it doesn't exist in this case, because it doesn't affect other assignments *)
               | Some (i, _) -> reg_sat id i)
            | None -> -spill id)
        ;;

        let rec run () =
          let assumptions = assumptions () in
          if dump_crap then print_s [%message "LOOP" (assumptions : int array)];
          match Pror_rs.run_with_assumptions pror assumptions, !to_spill with
          | UnsatCore core, [] ->
            Error.raise_s
              [%message
                "Can't assign, but nothing to spill"
                  (assignments : Assignment.t String.Table.t)
                  (core : int array)]
          | ( UnsatCore _
            , ({ var = key; _ } : Reg_numbering.var_state) :: rest_to_spill ) ->
            to_spill := rest_to_spill;
            Hashtbl.add_exn assignments ~key ~data:Spill;
            run ()
          | Sat res, _ ->
            if dump_crap then print_s [%message (res : (int * bool) list)];
            List.iter res ~f:(fun (sat_var, b) ->
              let var_id, x = backout_sat_var sat_var in
              let var = Reg_numbering.id_var reg_numbering var_id in
              match x with
              | `Assignment reg when b ->
                update_assignment ~assignments ~var ~to_:reg
              | `Assignment _ | `Spill -> ())
        ;;
      end : Sat)
    in
    Sat.run ()
  ;;

  let replace_regs ~fn ~assignments ~liveness_state ~reg_numbering =
    let root = fn.Function.root in
    let spill_slot_by_var = String.Table.create () in
    let free_spill_slots = ref Int.Set.empty in
    let used_spill_slots = ref Int.Set.empty in
    let get_spill_slot () =
      match Set.min_elt !free_spill_slots with
      | None -> Set.length !used_spill_slots
      | Some x ->
        free_spill_slots := Set.remove !free_spill_slots x;
        x
    in
    let free_spill_slot spill_slot =
      free_spill_slots := Set.add !free_spill_slots spill_slot
    in
    let prev_liveness = ref None in
    let update_slots ({ live_in; live_out } : Liveness.t) =
      let opened = Set.diff live_out live_in in
      let closed = Set.diff live_in live_out in
      Set.iter opened ~f:(fun var_id ->
        let var = Reg_numbering.id_var reg_numbering var_id in
        if Hashtbl.mem spill_slot_by_var var
        then ()
        else
          Hashtbl.add_exn spill_slot_by_var ~key:var ~data:(get_spill_slot ()));
      Set.iter closed ~f:(fun var_id ->
        let var = Reg_numbering.id_var reg_numbering var_id in
        Hashtbl.find_and_remove spill_slot_by_var var
        |> Option.iter ~f:free_spill_slot)
    in
    let map_ir ir =
      let map_reg = function
        | Reg.Unallocated v ->
          (match Hashtbl.find_exn assignments v with
           | Assignment.Spill ->
             (* RBP is whatever stack is at start of fn

                Stack looks like args then ret pointer then spills then actual state
             *)
             Mem
               ( RBP
               , fn.bytes_alloca'd + (Hashtbl.find_exn spill_slot_by_var v * 8)
               )
           | Reg r -> Reg r)
        | Allocated (v, _) ->
          Reg
            (Hashtbl.find_exn assignments v
             |> Assignment.reg_val
             |> Option.value_exn)
        | reg -> Reg reg
      in
      Ir.map_x86_operands ir ~f:(function
        | Reg r -> map_reg r
        | Mem (r, offset) ->
          Mem
            ( map_reg r
              |> (* safe because we enforce no spills on the mem regs *)
              reg_of_operand_exn
            , offset )
        | Imm _ as t -> t)
    in
    Block.iter root ~f:(fun block ->
      let block_liveness = Liveness_state.block_liveness liveness_state block in
      (match !prev_liveness with
       | None -> ()
       | Some ({ live_out; _ } : Liveness.t) ->
         update_slots
           { live_in = live_out; live_out = block_liveness.overall.live_in });
      let new_instructions =
        Vec.zip_exn block.instructions block_liveness.instructions
        |> Vec.map ~f:(fun (instruction, liveness) ->
          update_slots liveness;
          map_ir instruction)
      in
      block.instructions <- new_instructions;
      update_slots block_liveness.terminal;
      block.terminal <- map_ir block.terminal;
      prev_liveness := Some block_liveness.terminal);
    let spill_slots_used =
      match Set.max_elt !free_spill_slots, Set.max_elt !used_spill_slots with
      | None, None -> 0
      | Some a, Some b -> Int.max a b
      | Some a, None | None, Some a -> a
    in
    spill_slots_used
  ;;

  let run ?(dump_crap = false) (fn : Function.t) =
    let reg_numbering = Reg_numbering.create fn.root in
    let liveness_state = Liveness_state.create ~reg_numbering fn.root in
    let interference_graph =
      Interference_graph.create ~reg_numbering ~liveness_state fn.root
    in
    if dump_crap then Interference_graph.print interference_graph ~reg_numbering;
    let ~assignments, ~don't_spill = initialize_assignments fn.root in
    let () =
      run_sat
        ~dump_crap
        ~reg_numbering
        ~interference_graph
        ~assignments
        ~don't_spill
    in
    if dump_crap
    then print_s [%sexp (assignments : Assignment.t String.Table.t)];
    let spill_slots_used =
      replace_regs ~fn ~assignments ~liveness_state ~reg_numbering
    in
    fn.bytes_for_spills <- spill_slots_used * 8;
    fn
  ;;
end

module Clobbers = struct
  type fn_state =
    { to_restore : Reg.Set.t
    ; clobbers : Reg.Set.t
    }

  let calc_edges (functions : Function.t String.Map.t) =
    let edges = String.Table.create () in
    let defs = String.Table.create () in
    let uses_fn fn1 fn2 =
      let edges =
        Hashtbl.find_or_add edges fn1 ~default:String.Hash_set.create
      in
      Hash_set.add edges fn2
    in
    Map.iter functions ~f:(fun function_ ->
      let this_defs = ref Reg.Set.empty in
      Hashtbl.add_exn
        edges
        ~key:function_.name
        ~data:(String.Hash_set.create ());
      Block.iter_instructions function_.root ~f:(fun ir ->
        this_defs := Set.union !this_defs (Ir.x86_reg_defs ir |> Reg.Set.of_list);
        on_x86_irs ir ~f:(fun x86_ir ->
          match x86_ir with
          | CALL { fn; results = _; args = _ } -> uses_fn function_.name fn
          | _ -> ()));
      Hashtbl.add_exn defs ~key:function_.name ~data:!this_defs);
    ~edges, ~defs
  ;;

  let callee_saved ~call_conv =
    match (call_conv : Call_conv.t) with
    | Default -> Reg.integer_callee_saved |> Reg.Set.of_list
  ;;

  let init_state (functions : Function.t String.Map.t) : fn_state String.Map.t =
    (* dumb algo to work out clobbers, I think doing scc to sort out cycles first would make it O(n) instead *)
    let ~edges, ~defs = calc_edges functions in
    let worklist = Queue.create () in
    let clobbers = String.Table.create () in
    let to_restore = String.Table.create () in
    Map.iter functions ~f:(Queue.enqueue worklist);
    while not (Queue.is_empty worklist) do
      let fn = Queue.dequeue_exn worklist in
      let old_clobbers =
        Hashtbl.find_or_add clobbers fn.name ~default:(fun () -> Reg.Set.empty)
      in
      Hashtbl.update to_restore fn.name ~f:(function
        | Some x -> x
        | None ->
          Set.inter
            (Hashtbl.find_exn defs fn.name)
            (callee_saved ~call_conv:fn.call_conv));
      let new_clobbers_raw =
        Reg.Set.union_list
          (Hashtbl.find_exn defs fn.name
           :: (Hashtbl.find_exn edges fn.name
               |> Hash_set.to_list
               |> List.map ~f:(fun fn' ->
                 Hashtbl.find clobbers fn'
                 (* CR-soon ewilliams: This won't work for extern functions, where we need to know a callconv and assume everything is clobbered. These don't exist yet. *)
                 |> Option.value ~default:Reg.Set.empty)))
      in
      let new_clobbers =
        Set.diff new_clobbers_raw (callee_saved ~call_conv:fn.call_conv)
      in
      Hashtbl.set clobbers ~key:fn.name ~data:new_clobbers;
      if not (Reg.Set.equal new_clobbers old_clobbers)
      then Map.iter functions ~f:(Queue.enqueue worklist)
    done;
    Map.map functions ~f:(fun fn ->
      { clobbers = Hashtbl.find_exn clobbers fn.name
      ; to_restore = Hashtbl.find_exn to_restore fn.name
      })
  ;;

  let process (functions : Function.t String.Map.t) =
    let state = init_state functions in
    (* Insert the clobber stuff and stack management in prologue and epilogue *)
    Map.iteri state ~f:(fun ~key:name ~data:{ to_restore; clobbers = _ } ->
      let fn = Map.find_exn functions name in
      fn.bytes_for_clobber_saves <- Set.length to_restore * 8;
      let prologue = Option.value_exn fn.prologue in
      let epilogue = Option.value_exn fn.epilogue in
      let to_restore = Set.to_list to_restore in
      let () =
        (* change prologue *)
        if fn.bytes_alloca'd + fn.bytes_for_spills > 0
        then
          Vec.push
            prologue.instructions
            (X86
               (sub
                  (Reg RSP)
                  (Imm (fn.bytes_alloca'd + fn.bytes_for_spills |> Int64.of_int))));
        List.iter to_restore ~f:(fun reg ->
          Vec.push prologue.instructions (X86 (push (Reg reg))))
      in
      let () =
        (* change epilogue *)
        if List.is_empty to_restore
        then Vec.push epilogue.instructions (X86 (mov (Reg RSP) (Reg RBP)))
        else
          List.map
            ~f:Ir.x86
            ([ mov (Reg RSP) (Reg RBP)
             ; sub
                 (Reg RSP)
                 (Imm (Function.stack_header_bytes fn |> Int64.of_int))
             ]
             @ List.map (List.rev to_restore) ~f:pop
             @
             if fn.bytes_alloca'd + fn.bytes_for_spills > 0
             then
               [ add
                   (Reg RSP)
                   (Imm (fn.bytes_alloca'd + fn.bytes_for_spills |> Int64.of_int))
               ]
             else [])
          |> List.iter ~f:(Vec.push epilogue.instructions)
      in
      ());
    functions
  ;;
end

module Save_call_clobbers = struct
  module Liveness = struct
    type t =
      { live_in : Reg.Set.t
      ; live_out : Reg.Set.t
      }

    let empty = { live_in = Reg.Set.empty; live_out = Reg.Set.empty }
  end

  let is_physical_reg = function
    | Reg.Unallocated _ | Allocated _ -> false
    | _ -> true
  ;;

  let should_save reg =
    match reg with
    | Reg.RSP | Reg.RBP -> false
    | _ -> is_physical_reg reg
  ;;

  module Phys_liveness = struct
    type block_liveness =
      { mutable instructions : Liveness.t Vec.t
      ; mutable terminal : Liveness.t
      ; mutable overall : Liveness.t
      ; defs : Reg.Set.t
      ; uses : Reg.Set.t
      }

    type t = { blocks : block_liveness Block.Table.t }

    let block_liveness t block = Hashtbl.find_exn t.blocks block
    let filter_physical set = Set.filter set ~f:is_physical_reg
    let reg_union_list sets = Reg.Set.union_list sets

    let reg_defs_of_ir = function
      | Ir0.X86 x -> filter_physical (X86_ir.reg_defs x)
      | Ir0.X86_terminal xs ->
        reg_union_list (List.map xs ~f:X86_ir.reg_defs) |> filter_physical
      | _ -> Reg.Set.empty
    ;;

    let reg_uses_of_ir = function
      | Ir0.X86 x -> filter_physical (X86_ir.reg_uses x)
      | Ir0.X86_terminal xs ->
        reg_union_list (List.map xs ~f:X86_ir.reg_uses) |> filter_physical
      | _ -> Reg.Set.empty
    ;;

    let defs_and_uses (block : Block.t) =
      let defs = ref Reg.Set.empty in
      let uses = ref Reg.Set.empty in
      let update ir =
        let defs_ir = reg_defs_of_ir ir in
        let uses_ir = reg_uses_of_ir ir in
        uses := Set.union !uses (Set.diff uses_ir !defs);
        defs := Set.union !defs defs_ir
      in
      Vec.iter block.instructions ~f:update;
      update block.terminal;
      !defs, !uses
    ;;

    let create root =
      let blocks = Block.Table.create () in
      Block.iter root ~f:(fun block ->
        let defs, uses = defs_and_uses block in
        Hashtbl.add_exn
          blocks
          ~key:block
          ~data:
            { instructions = Vec.create ()
            ; terminal = Liveness.empty
            ; overall = Liveness.empty
            ; defs
            ; uses
            });
      { blocks }
    ;;

    let calculate_block_liveness t root =
      let queue = Queue.create () in
      Block.iter root ~f:(Queue.enqueue queue);
      while not (Queue.is_empty queue) do
        let block = Queue.dequeue_exn queue in
        let block_state = block_liveness t block in
        let succs =
          Ir0.call_blocks block.terminal |> List.map ~f:Call_block.block
        in
        let live_out =
          List.fold succs ~init:Reg.Set.empty ~f:(fun acc succ ->
            let succ_state = block_liveness t succ in
            Set.union acc succ_state.overall.live_in)
        in
        let live_in =
          Set.union block_state.uses (Set.diff live_out block_state.defs)
        in
        if not
             (Set.equal live_out block_state.overall.live_out
              && Set.equal live_in block_state.overall.live_in)
        then (
          block_state.overall <- { Liveness.live_in; live_out };
          Vec.iter block.parents ~f:(Queue.enqueue queue))
      done
    ;;

    let calculate_intra_block_liveness t root =
      let update_from_after
        ({ Liveness.live_in = next_live_in; _ } : Liveness.t)
        ir
        =
        let live_out = next_live_in in
        let live_in =
          Set.union (reg_uses_of_ir ir) (Set.diff live_out (reg_defs_of_ir ir))
        in
        { Liveness.live_in; live_out }
      in
      Block.iter root ~f:(fun block ->
        let block_state = block_liveness t block in
        let terminal_live_out = block_state.overall.live_out in
        let terminal_live_in =
          Set.union
            (reg_uses_of_ir block.terminal)
            (Set.diff terminal_live_out (reg_defs_of_ir block.terminal))
        in
        block_state.terminal
        <- { Liveness.live_in = terminal_live_in; live_out = terminal_live_out };
        Vec.clear block_state.instructions;
        let (_ : Liveness.t) =
          Vec.foldr
            block.instructions
            ~init:block_state.terminal
            ~f:(fun after ir ->
              let liveness = update_from_after after ir in
              Vec.push block_state.instructions liveness;
              liveness)
        in
        Vec.reverse_inplace block_state.instructions)
    ;;
  end

  let default_clobbers =
    let callee_saved = Clobbers.callee_saved ~call_conv:Call_conv.Default in
    Array.fold Reg.all_physical ~init:Reg.Set.empty ~f:(fun acc reg ->
      if should_save reg then Set.add acc reg else acc)
    |> fun all_physical -> Set.diff all_physical callee_saved
  ;;

  let regs_to_save ~state ~call_fn ~live_out =
    let callee_clobbers =
      match Map.find state call_fn with
      | Some (state : Clobbers.fn_state) -> state.clobbers
      | None -> default_clobbers
    in
    Set.inter callee_clobbers live_out
    |> Set.filter ~f:should_save
    |> Set.to_list
  ;;

  let rec find_following_call ~start ~len ~instructions =
    if start >= len
    then None
    else (
      match Vec.get instructions start with
      | Ir0.X86 (CALL { fn; _ }) -> Some fn
      | _ -> find_following_call ~start:(start + 1) ~len ~instructions)
  ;;

  let process_block ~state ~liveness block =
    let block_state = Phys_liveness.block_liveness liveness block in
    let instructions = block.instructions in
    let len = Vec.length instructions in
    let new_instructions = Vec.create () in
    let pending = Stack.create () in
    let rec loop idx =
      if idx >= len
      then ()
      else (
        let ir = Vec.get instructions idx in
        (match ir with
         | Ir0.X86 Save_clobbers ->
           let liveness_at_instr = Vec.get block_state.instructions idx in
           let call_fn =
             match find_following_call ~start:(idx + 1) ~len ~instructions with
             | Some fn -> fn
             | None -> failwith "Save_clobbers without following CALL"
           in
           let regs =
             regs_to_save
               ~state
               ~call_fn
               ~live_out:liveness_at_instr.Liveness.live_out
           in
           Stack.push pending regs;
           List.iter regs ~f:(fun reg ->
             Vec.push new_instructions (Ir0.X86 (push (Reg reg))))
         | Ir0.X86 Restore_clobbers ->
           let regs =
             match Stack.pop pending with
             | Some regs -> regs
             | None -> failwith "Restore_clobbers without matching save"
           in
           List.iter (List.rev regs) ~f:(fun reg ->
             Vec.push new_instructions (Ir0.X86 (pop reg)))
         | _ -> Vec.push new_instructions ir);
        loop (idx + 1))
    in
    loop 0;
    if not (Stack.is_empty pending)
    then failwith "Unbalanced Save_clobbers markers";
    block.instructions <- new_instructions;
    match block.terminal with
    | Ir0.X86 Save_clobbers | Ir0.X86 Restore_clobbers ->
      failwith "unexpected save/restore marker in terminal"
    | _ -> ()
  ;;

  let process (functions : Function.t String.Map.t) =
    let state = Clobbers.init_state functions in
    Map.iter functions ~f:(fun fn ->
      let liveness = Phys_liveness.create fn.root in
      Phys_liveness.calculate_block_liveness liveness fn.root;
      Phys_liveness.calculate_intra_block_liveness liveness fn.root;
      Block.iter fn.root ~f:(process_block ~state ~liveness));
    functions
  ;;
end

let compile ?dump_crap (functions : Function.t String.Map.t) =
  Map.map functions ~f:(fun fn ->
    Out_of_ssa.process fn |> Regalloc.run ?dump_crap)
  |> Clobbers.process
  |> Save_call_clobbers.process
;;
