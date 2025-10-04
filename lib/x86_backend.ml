open! Core

let ir_to_x86_ir (ir : Ir.t) =
  let open X86_ir in
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
    [ mov (Reg Reg.rax) (Ir.Lit_or_var.to_x86_ir_operand src1)
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

module Regalloc = struct
  open X86_ir

  type t =
    { var_ids : int Var.Table.t
    ; var_id_to_var : Var.t Int.Table.t
    ; interferences : Int.Hash_set.t Int.Table.t
    }

  let num_reg_types = List.length Reg.Variants.descriptions

  let var_id t var =
    match Hashtbl.find t.var_ids var with
    | Some id -> id
    | None ->
      let id = Hashtbl.length t.var_ids in
      Hashtbl.set t.var_ids ~key:var ~data:id;
      Hashtbl.set t.var_id_to_var ~key:id ~data:var;
      id
  ;;

  let reg_id t (reg : Reg.t) =
    match reg with
    | Unallocated v -> num_reg_types + var_id t v
    | other -> Reg.Variants.to_rank other
  ;;

  let reg_of_id t id : Reg.t =
    match id with
    | id when id >= num_reg_types ->
      Reg.unallocated (Hashtbl.find_exn t.var_id_to_var (id - num_reg_types))
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
end

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

let mint_intermediate
  (from_block : Block.t)
  (to_call_block : Block.t Call_block.t)
  ~block_names
  =
  let name = "int_" ^ from_block.id_hum ^ "_to_" ^ to_call_block.block.id_hum in
  let rec go name =
    if Hash_set.mem block_names name then go name ^ "_" else name
  in
  let name = go name in
  Hash_set.add block_names name;
  let block =
    Block.create ~id_hum:name ~terminal:(X86 (X86_ir.jmp to_call_block))
  in
  block.args <- Vec.of_list to_call_block.args;
  { Call_block.block; args = to_call_block.args }
;;

let compile (root : Block.t) =
  let block_names = String.Hash_set.create () in
  Block.iter root ~f:(fun block ->
    Hash_set.add block_names block.id_hum;
    block.instructions
    <- Vec.concat_map block.instructions ~f:(fun ir ->
         ir_to_x86_ir ir |> Vec.of_list |> Vec.map ~f:Ir0.x86);
    block.terminal <- Ir.x86_terminal (ir_to_x86_ir block.terminal));
  Block.iter root ~f:(fun block ->
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
             (mint_intermediate block a ~block_names)
             (Some (mint_intermediate block b ~block_names)))
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
       | CMP (_, _)
       | PAR_MOV _ -> ()));
  root
;;
