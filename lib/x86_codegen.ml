open! Core
open Ir
open X86_ir
open Lit_or_var
open Mem

let reg_of_var (v : Var.t) : Var.t Reg.t = Unallocated v
let fresh_label_i = lazy (ref 0)

let fresh_label () =
  let fresh = Lazy.force fresh_label_i in
  let res = "%%local__" ^ Int.to_string !fresh in
  incr fresh;
  res
;;

let operand_of_lit_or_var = function
  | Lit n -> Imm n
  | Var v -> Reg (reg_of_var v)
;;

let operand_of_mem = function
  | Stack_slot i -> Mem (RBP, -8 * i)
  | Lit_or_var lom -> operand_of_lit_or_var lom
;;

let sel_instr ~instrs ir =
  let par_mov { Call_block.block; args } =
    match args with
    | [] -> []
    | _ ->
      [ PAR_MOV
          (List.map2_exn (Vec.to_list block.Block.args) args ~f:(fun a b ->
             Reg (Reg.Unallocated a), Reg (Reg.Unallocated b)))
      ]
  in
  let new_ =
    match ir with
    | Add { dest; src1; src2 } ->
      let rd = Reg (reg_of_var dest) in
      [ MOV (rd, operand_of_lit_or_var src1)
      ; ADD (rd, operand_of_lit_or_var src2)
      ]
    | And { dest; src1; src2 } ->
      let rd = Reg (reg_of_var dest) in
      [ MOV (rd, operand_of_lit_or_var src1)
      ; AND (rd, operand_of_lit_or_var src2)
      ]
    | Or { dest; src1; src2 } ->
      let rd = Reg (reg_of_var dest) in
      [ MOV (rd, operand_of_lit_or_var src1)
      ; OR (rd, operand_of_lit_or_var src2)
      ]
    | Sub { dest; src1; src2 } ->
      let rd = Reg (reg_of_var dest) in
      [ MOV (rd, operand_of_lit_or_var src1)
      ; SUB (rd, operand_of_lit_or_var src2)
      ]
    | Mul { dest; src1; src2 } ->
      let rd = Reg (reg_of_var dest) in
      [ MOV (rd, operand_of_lit_or_var src1)
      ; MUL (rd, operand_of_lit_or_var src2)
      ]
    | Div { dest; src1; src2 } ->
      (* idiv uses RAX and RDX *)
      [ MOV (Reg RAX, operand_of_lit_or_var src1)
      ; CMP (Reg RAX, Reg RAX) (* clear RDX for signed division *)
      ; IDIV (operand_of_lit_or_var src2)
      ; MOV (Reg (reg_of_var dest), Reg RAX)
      ]
    | Mod { dest; src1; src2 } ->
      (* remainder after idiv is in RDX *)
      [ MOV (Reg RAX, operand_of_lit_or_var src1)
      ; CMP (Reg RAX, Reg RAX)
      ; IDIV (operand_of_lit_or_var src2)
      ; MOV (Reg (reg_of_var dest), Reg RDX)
      ]
    | Load (v, mem) ->
      let rd = Reg (reg_of_var v) in
      [ MOV (rd, operand_of_mem mem) ]
    | Store (val_, mem) ->
      [ MOV (operand_of_mem mem, operand_of_lit_or_var val_) ]
    | Move (v, src) -> [ MOV (Reg (reg_of_var v), operand_of_lit_or_var src) ]
    | Return rv -> [ MOV (Reg RAX, operand_of_lit_or_var rv); RET (Reg RAX) ]
    | Branch (Uncond b) -> par_mov b @ [ JMP b.block.Block.id_hum ]
    | Branch (Cond { cond; if_true; if_false }) ->
      let c = operand_of_lit_or_var cond in
      let mov_if_false = par_mov if_false in
      let mov_if_true = par_mov if_true in
      (match mov_if_false, mov_if_true with
       | [], [] ->
         [ CMP (c, Imm 0L)
         ; JNE (if_true.block.Block.id_hum, None)
         ; JMP if_false.block.Block.id_hum
         ]
       | [], mov_if_true ->
         [ CMP (c, Imm 0L); JE (if_false.block.Block.id_hum, None) ]
         @ mov_if_true
         @ [ JMP if_true.block.Block.id_hum ]
       | mov_if_false, [] ->
         [ CMP (c, Imm 0L); JNE (if_true.block.Block.id_hum, None) ]
         @ mov_if_false
         @ [ JMP if_false.block.Block.id_hum ]
       | mov_if_false, mov_if_true ->
         let if_false_label = fresh_label () in
         List.concat
           [ [ CMP (c, Imm 0L); JE (if_false_label, None) ]
           ; mov_if_true
           ; [ JMP if_true.block.Block.id_hum; LABEL_NOT_BLOCK if_false_label ]
           ; mov_if_false
           ; [ JMP if_false.block.Block.id_hum ]
           ])
    | Noop -> []
    | Unreachable -> []
  in
  Vec.append_list instrs new_
;;

let compile_block ~instrs (blk : Block.t) =
  let label = LABEL blk.id_hum in
  Vec.push instrs label;
  Vec.iter blk.instructions ~f:(sel_instr ~instrs);
  sel_instr ~instrs blk.terminal
;;

let compile_linear root =
  let instrs = Vec.create () in
  let block_args = String.Table.create () in
  let block_starts = ref String.Map.empty in
  let block_adj = String.Table.create () in
  let seen = Block.Hash_set.create () in
  let rec go block =
    if Hash_set.mem seen block
    then ()
    else (
      Hash_set.add seen block;
      Hashtbl.set block_args ~key:block.id_hum ~data:block.args;
      Hashtbl.set
        block_adj
        ~key:block.id_hum
        ~data:(Ir.blocks block.terminal |> List.map ~f:Block.id_hum);
      block_starts
      := Map.set !block_starts ~key:block.Block.id_hum ~data:(Vec.length instrs);
      compile_block ~instrs block;
      List.iter (blocks block.terminal) ~f:go)
  in
  go root;
  block_args, !block_starts, block_adj, instrs
;;

module Regalloc = X86_regalloc.Make (Var)

let allocation ~mappings ~var ~idx =
  let allocs = Hashtbl.find_exn mappings var in
  let alloc, () =
    Map.closest_key
      allocs
      `Less_than
      (Regalloc.Allocation.fake
         ~var
         ~interval:{ start = idx; end_ = 100000000000 })
    |> Option.value_exn
  in
  alloc
;;

let operand ~mappings ~var ~idx =
  match (allocation ~mappings ~var ~idx).mapping with
  | Stack_slot i -> X86_ir.Mem (RSP, -i)
  | Reg r -> X86_ir.Reg r
;;

let vars_for_secondary_spill ~mappings ~instr ~idx =
  let needed = Var.Set.empty in
  X86_ir.fold_operands instr ~init:needed ~f:(fun acc operand ->
    match operand with
    | Mem (Unallocated var, _) ->
      (match (allocation ~mappings ~var ~idx).mapping with
       | Reg _ -> acc
       | Stack_slot _ -> Set.add acc var)
    | Reg _ | Imm _ | Mem (_, _) -> acc)
;;

module Var_reg = struct
  module T = struct
    type t = Var.t Reg.t [@@deriving sexp, compare]
  end

  include T
  include Comparable.Make (T)
end

let can't_spill ~instr =
  let needed = Var_reg.Set.empty in
  X86_ir.fold_operands instr ~init:needed ~f:(fun acc operand ->
    match operand with
    | Reg r | Mem (r, _) -> Set.add acc r
    | _ -> acc)
;;

let will_exit = function
  | RET _ -> true
  | PAR_MOV _ | NOOP
  | MOV (_, _)
  | ADD (_, _)
  | AND (_, _)
  | OR (_, _)
  | SUB (_, _)
  | MUL (_, _)
  | LABEL_NOT_BLOCK _ | IDIV _ | LABEL _ | JMP _
  | CMP (_, _)
  | JE (_, _)
  | JNE (_, _) -> false
;;

let all_regs = Var_reg.Set.of_list (Regalloc.free_regs ())

let compile_and_regalloc root =
  let block_args, block_starts, block_adj, instrs = compile_linear root in
  let mappings, stack_end =
    Regalloc.process
      ~stack_offset:0
      ~block_args
      ~block_starts
      ~block_adj
      ~instrs
  in
  let epilogue =
    if stack_end = 0
    then Vec.create ()
    else Vec.of_list [ SUB (Reg RSP, Imm (Int64.of_int 4)) ]
  in
  let res = Vec.create () in
  let push_epilogue () = Vec.iter epilogue ~f:(Vec.push res) in
  Vec.iteri instrs ~f:(fun idx instr ->
    if will_exit instr then push_epilogue ();
    let secondary_spill = vars_for_secondary_spill ~mappings ~instr ~idx in
    if Set.is_empty secondary_spill
    then
      Vec.push
        res
        (X86_ir.map_var_operands instr ~f:(fun var ->
           operand ~mappings ~var ~idx))
    else (
      let can't_spill = can't_spill ~instr in
      let free_regs = ref (Set.diff all_regs can't_spill) in
      let remap =
        Set.to_map secondary_spill ~f:(fun _ ->
          let reg = Set.min_elt_exn !free_regs in
          free_regs := Set.remove !free_regs reg;
          reg)
      in
      Map.iteri remap ~f:(fun ~key:var ~data:reg ->
        let op = operand ~mappings ~var ~idx in
        Vec.push res (MOV (Reg reg, op)));
      Vec.push
        res
        (X86_ir.map_var_operands instr ~f:(fun var ->
           match Map.find remap var with
           | Some reg -> Reg reg
           | None -> operand ~mappings ~var ~idx));
      Map.iteri remap ~f:(fun ~key:var ~data:reg ->
        let op = operand ~mappings ~var ~idx in
        Vec.push res (MOV (op, Reg reg)))));
  res
;;
