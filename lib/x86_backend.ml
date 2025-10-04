open! Core
open X86_ir

let ir_to_x86_ir (ir : Ir.t) =
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
    [ mov (Reg (Reg.allocated  Reg.rax) (Ir.Lit_or_var.to_x86_ir_operand src1)
    ; make_instr (Ir.Lit_or_var.to_x86_ir_operand src2)
    ; mov (reg dest) (Reg take_reg)
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
  | Return lit_or_var -> [ RET (operand_of_lit_or_var lit_or_var) ]
  | Move (v, lit_or_var) -> [ mov (reg v) (operand_of_lit_or_var lit_or_var) ]
  | Load (v, mem) -> [ mov (reg v) (Ir.Mem.to_x86_ir_operand mem) ]
  | Store (lit_or_var, mem) ->
    [ mov
        (Ir.Mem.to_x86_ir_operand mem)
        (Ir0.Lit_or_var.to_x86_ir_operand lit_or_var)
    ]
  | Mul arith -> mul_div_mod arith ~take_reg:Reg.rax ~make_instr:imul
  | Div arith -> mul_div_mod arith ~take_reg:Reg.rax ~make_instr:idiv
  | Mod arith -> mul_div_mod arith ~take_reg:Reg.rdx ~make_instr:mod_
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
  | Noop | And _ | Or _ | Add _ | Sub _ | Mul _ | Div _ | Mod _
  | Load (_, _)
  | Store (_, _)
  | Move (_, _)
  | Branch _ | Return _ | Unreachable -> None
;;

let replace_true_terminal (x86_block : Block.t) new_true_terminal =
  match x86_block.terminal with
  | X86 _terminal -> x86_block.terminal <- X86 new_true_terminal
  | X86_terminal terminals ->
    x86_block.terminal
    <- X86_terminal
         (List.take terminals (List.length terminals - 1)
          @ [ new_true_terminal ])
  | Noop | And _ | Or _ | Add _ | Sub _ | Mul _ | Div _ | Mod _
  | Load (_, _)
  | Store (_, _)
  | Move (_, _)
  | Branch _ | Return _ | Unreachable -> ()
;;

module Out_of_ssa = struct
  type t =
    { block_names : int String.Table.t
    ; var_names : int String.Table.t
    ; root : Block.t
    }
  [@@deriving fields]

  let create root =
    { block_names = String.Table.create ()
    ; var_names = String.Table.create ()
    ; root
    }
  ;;

  let add_count tbl s =
    Hashtbl.update tbl s ~f:(function
      | None -> 0
      | Some i -> i + 1)
  ;;

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

  let simple_translation_to_x86_ir t =
    let ir_to_x86_ir ir =
      let res = ir_to_x86_ir ir in
      List.iter res ~f:(fun ir ->
        List.iter (X86_ir.vars ir) ~f:(add_count t.var_names));
      res
    in
    Block.iter t.root ~f:(fun block ->
      add_count t.block_names block.id_hum;
      block.instructions
      <- Vec.concat_map block.instructions ~f:(fun ir ->
           ir_to_x86_ir ir |> Vec.of_list |> Vec.map ~f:Ir0.x86);
      block.terminal <- Ir.x86_terminal (ir_to_x86_ir block.terminal));
    t
  ;;

  let split_blocks t =
    Block.iter_and_update_bookkeeping t.root ~f:(fun block ->
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
        (match true_terminal with
         | RET _ | JMP _ | JNE (_, None) | JE (_, None) -> ()
         | JE (a, Some b) -> rep X86_ir.je a b
         | JNE (a, Some b) -> rep X86_ir.jne a b
         | NOOP
         | AND (_, _)
         | OR (_, _)
         | MOV (_, _)
         | ADD (_, _)
         | SUB (_, _)
         | IMUL _ | IDIV _ | MOD _ | LABEL _
         | CMP (_, _) -> ()));
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
    Block.iter t.root ~f:(fun block ->
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
           | RET _ ->
             (* CR ewilliams: need to do moves for this actually *)
             ()
           | JNE _ | JE _ ->
             (* [block.insert_phi_moves] should be false *) failwith "bug"
           | NOOP
           | AND (_, _)
           | OR (_, _)
           | MOV (_, _)
           | ADD (_, _)
           | SUB (_, _)
           | IMUL _ | IDIV _ | MOD _ | LABEL _
           | CMP (_, _) -> ())));
    t
  ;;

  let remove_call_block_args t =
    Block.iter t.root ~f:(fun block ->
      block.terminal <- Ir.remove_block_args block.terminal);
    t
  ;;

  let process block =
    block
    |> create
    |> simple_translation_to_x86_ir
    |> split_blocks
    |> insert_par_moves
    |> remove_call_block_args
    |> root
  ;;
end

module Reg_numbering = struct
  type var_state =
    { mutable num_uses : int
    ; id : int
    }
  [@@deriving fields, sexp]

  type t =
    { vars : var_state Var.Table.t
    ; id_to_var : Var.t Int.Table.t
    }
  [@@deriving fields, sexp]

  let num_reg_types = List.length Reg.Variants.descriptions

  let var_state t var =
    match Hashtbl.find t.vars var with
    | Some state -> state
    | None ->
      let id = Hashtbl.length t.vars + 1 in
      let res = { num_uses = 0; id } in
      Hashtbl.set t.vars ~key:var ~data:res;
      Hashtbl.set t.id_to_var ~key:id ~data:var;
      res
  ;;

  let var_id t var = (var_state t var).id
  let id_var t id = Hashtbl.find_exn t.id_to_var id

  let reg_id t (reg : Reg.t) =
    match reg with
    | Unallocated v -> num_reg_types + (var_state t v).id
    | other -> Reg.Variants.to_rank other
  ;;

  let reg_of_id t id : Reg.t =
    match id with
    | id when id >= num_reg_types ->
      Reg.unallocated (Hashtbl.find_exn t.id_to_var (id - num_reg_types))
    | 1 -> Junk
    | 2 -> RBP
    | 3 -> RSP
    | 4 -> RAX
    | 5 -> RBX
    | 6 -> RCX
    | 7 -> RDX
    | 8 -> RSI
    | 9 -> RDI
    | 10 -> R8
    | 11 -> R9
    | 12 -> R10
    | 13 -> R11
    | 14 -> R12
    | 15 -> R13
    | 16 -> R14
    | 17 -> R15
    | _ -> failwith "impossible"
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
end

module Liveness = struct
  type t =
    { (* CR ewilliams: prob use bitsets *)
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
    Block.iter root ~f:(fun block ->
      let block_liveness = block_liveness t block in
      let live_out = block_liveness.overall.live_out in
      let f live_out ir =
        let live_in =
          Set.union (ir_uses t ir) (Set.diff live_out (ir_defs t ir))
        in
        { Liveness.live_in; live_out }
      in
      block_liveness.terminal <- f live_out block.terminal;
      (* prob unnecessary *)
      Vec.clear block_liveness.instructions;
      let (_ : Liveness.t) =
        Vec.foldr
          block.instructions
          ~init:block_liveness.terminal
          ~f:(fun { live_out; live_in = _ } ir ->
            let liveness = f live_out ir in
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
end

module Regalloc = struct
  let create_interference_graph liveness_state root =
    let edges = Int.Table.create () in
    let add_edge u v =
      if u <> v
      then (
        Hashtbl.update edges u ~f:(function
          | None -> Int.Set.singleton v
          | Some s -> Set.add s v);
        Hashtbl.update edges v ~f:(function
          | None -> Int.Set.singleton u
          | Some s -> Set.add s u))
    in
    Block.iter root ~f:(fun block ->
      let block_liveness = Liveness_state.block_liveness liveness_state block in
      List.zip_exn
        (Vec.to_list block.instructions @ [ block.terminal ])
        (Vec.to_list block_liveness.instructions @ [ block_liveness.terminal ])
      |> List.iter ~f:(fun (ir, liveness) ->
        List.iter (Ir.defs ir) ~f:(fun var ->
          let u = Liveness_state.var_id liveness_state var in
          Set.iter liveness.live_out ~f:(add_edge u))));
    edges
  ;;

  let print_readable_interference ~edges ~reg_numbering =
    let edges =
      Hashtbl.to_alist edges
      |> List.map ~f:(fun (id, ids) ->
        ( Reg_numbering.reg_of_id reg_numbering id
        , Set.map (module Reg) ids ~f:(Reg_numbering.reg_of_id reg_numbering) ))
    in
    print_s [%sexp (edges : (Reg.t * Reg.Set.t) list)]
  ;;

  let run root =
    let reg_numbering = Reg_numbering.create root in
    let liveness_state = Liveness_state.create ~reg_numbering root in
    let edges = create_interference_graph liveness_state root in
    print_readable_interference ~edges ~reg_numbering;
    root
  ;;
end

let compile block = Out_of_ssa.process block |> Regalloc.run
