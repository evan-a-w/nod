open! Core
open Ir
open X86_ir
open Lit_or_var
open Mem

let reg_of_var (v : Var.t) : Var.t Reg.t = Unallocated v

let operand_of_lit_or_var = function
  | Lit n -> Imm n
  | Var v -> Reg (reg_of_var v)
;;

let operand_of_mem = function
  | Stack_slot i -> Mem (RBP, -8 * i)
  | Lit_or_var lom -> operand_of_lit_or_var lom
;;

(* Generate x86 instructions for a single IR instruction *)
let sel_instr ~instrs ir =
  let new_ =
    match ir with
    | Add { dest; src1; src2 } ->
      let rd = Reg (reg_of_var dest) in
      [ MOV (operand_of_lit_or_var src1, rd)
      ; ADD (operand_of_lit_or_var src2, rd)
      ]
    | Sub { dest; src1; src2 } ->
      let rd = Reg (reg_of_var dest) in
      [ MOV (operand_of_lit_or_var src1, rd)
      ; SUB (operand_of_lit_or_var src2, rd)
      ]
    | Mul { dest; src1; src2 } ->
      let rd = Reg (reg_of_var dest) in
      [ MOV (operand_of_lit_or_var src1, rd)
      ; MUL (operand_of_lit_or_var src2, rd)
      ]
    | Div { dest; src1; src2 } ->
      (* idiv uses RAX and RDX *)
      [ MOV (operand_of_lit_or_var src1, Reg RAX)
      ; CMP (Reg RAX, Reg RAX) (* clear RDX for signed division *)
      ; IDIV (operand_of_lit_or_var src2)
      ; MOV (Reg RAX, Reg (reg_of_var dest))
      ]
    | Mod { dest; src1; src2 } ->
      (* remainder after idiv is in RDX *)
      [ MOV (operand_of_lit_or_var src1, Reg RAX)
      ; CMP (Reg RAX, Reg RAX)
      ; IDIV (operand_of_lit_or_var src2)
      ; MOV (Reg RDX, Reg (reg_of_var dest))
      ]
    | Load (v, mem) ->
      let rd = Reg (reg_of_var v) in
      [ MOV (operand_of_mem mem, rd) ]
    | Store (val_, mem) ->
      [ MOV (operand_of_lit_or_var val_, operand_of_mem mem) ]
    | Move (v, src) -> MOV (operand_of_lit_or_var src, Reg (reg_of_var v)) :: []
    | Return rv -> [ MOV (operand_of_lit_or_var rv, Reg RAX); RET (Reg RAX) ]
    | Branch (Uncond b) -> [ JMP b.block.Block.id_hum ]
    | Branch (Cond { cond; if_true; if_false }) ->
      let c = operand_of_lit_or_var cond in
      [ CMP (c, Imm 0L)
      ; JNE (if_true.block.Block.id_hum, None)
      ; JMP if_false.block.Block.id_hum
      ]
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
  let block_starts = ref String.Map.empty in
  let block_adj = String.Table.create () in
  let seen = Block.Hash_set.create () in
  let rec go block =
    if Hash_set.mem seen block
    then ()
    else (
      Hash_set.add seen block;
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
  !block_starts, block_adj, instrs
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
  | NOOP
  | MOV (_, _)
  | ADD (_, _)
  | SUB (_, _)
  | MUL (_, _)
  | IDIV _ | LABEL _ | JMP _
  | CMP (_, _)
  | JE (_, _)
  | JNE (_, _) -> false
;;

let all_regs = Var_reg.Set.of_list (Regalloc.free_regs ())

let compile_and_regalloc root =
  let block_starts, block_adj, instrs = compile_linear root in
  let mappings, stack_end =
    Regalloc.process ~stack_offset:0 ~block_starts ~block_adj ~instrs
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
