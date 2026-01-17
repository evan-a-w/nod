open! Core
open! Import

(* Convert between the old Block-based IR and the new Graph IR *)

module To_graph = struct
  type context =
    { func : Graph_ir.Func.t
    ; var_map : Graph_ir.Value.t Var.Table.t
    ; block_map : Graph_ir.Block.t Block.Table.t
    ; mutable next_block_id : int
    }

  let fresh_block_id ctx =
    let id = ctx.next_block_id in
    ctx.next_block_id <- id + 1;
    id
  ;;

  let get_or_create_value ctx var =
    Hashtbl.find_or_add ctx.var_map var ~default:(fun () ->
      Graph_ir.Func.fresh_value
        ctx.func
        ~type_:(Var.type_ var)
        ~def:Graph_ir.Value.Undef)
  ;;

  let convert_lit_or_var ctx : Ir0.Lit_or_var.t -> Graph_ir.Value.t = function
    | Lit i ->
      (* Create a constant value - for now represented as Move from undefined *)
      let const_type = Type.I64 in
      let const_val =
        Graph_ir.Func.fresh_value ctx.func ~type_:const_type ~def:Undef
      in
      (* TODO: Add a Const opcode or tag constants in metadata *)
      const_val
    | Var v -> get_or_create_value ctx v
    | Global g ->
      (* Globals are pointers *)
      Graph_ir.Func.fresh_value
        ctx.func
        ~type_:(Type.Ptr_typed g.Global.type_)
        ~def:Undef
  ;;

  let convert_mem ctx (mem : Ir0.Mem.t) : Ir0.Mem.t = mem

  let convert_instr ctx (instr : Ir.t) : Graph_ir.Instr.t option =
    match instr with
    | Noop -> None
    | Add { dest; src1; src2 } ->
      let op1 = convert_lit_or_var ctx src1 in
      let op2 = convert_lit_or_var ctx src2 in
      let result_type = Var.type_ dest in
      let new_instr =
        Graph_ir.Func.fresh_instr
          ctx.func
          ~opcode:Add
          ~operands:[| op1; op2 |]
          ~result_types:[| result_type |]
      in
      Hashtbl.set ctx.var_map ~key:dest ~data:new_instr.results.(0);
      Some new_instr
    | Sub { dest; src1; src2 } ->
      let op1 = convert_lit_or_var ctx src1 in
      let op2 = convert_lit_or_var ctx src2 in
      let new_instr =
        Graph_ir.Func.fresh_instr
          ctx.func
          ~opcode:Sub
          ~operands:[| op1; op2 |]
          ~result_types:[| Var.type_ dest |]
      in
      Hashtbl.set ctx.var_map ~key:dest ~data:new_instr.results.(0);
      Some new_instr
    | Mul { dest; src1; src2 } ->
      let op1 = convert_lit_or_var ctx src1 in
      let op2 = convert_lit_or_var ctx src2 in
      let new_instr =
        Graph_ir.Func.fresh_instr
          ctx.func
          ~opcode:Mul
          ~operands:[| op1; op2 |]
          ~result_types:[| Var.type_ dest |]
      in
      Hashtbl.set ctx.var_map ~key:dest ~data:new_instr.results.(0);
      Some new_instr
    | Div { dest; src1; src2 } ->
      let op1 = convert_lit_or_var ctx src1 in
      let op2 = convert_lit_or_var ctx src2 in
      let new_instr =
        Graph_ir.Func.fresh_instr
          ctx.func
          ~opcode:Div
          ~operands:[| op1; op2 |]
          ~result_types:[| Var.type_ dest |]
      in
      Hashtbl.set ctx.var_map ~key:dest ~data:new_instr.results.(0);
      Some new_instr
    | Mod { dest; src1; src2 } ->
      let op1 = convert_lit_or_var ctx src1 in
      let op2 = convert_lit_or_var ctx src2 in
      let new_instr =
        Graph_ir.Func.fresh_instr
          ctx.func
          ~opcode:Mod
          ~operands:[| op1; op2 |]
          ~result_types:[| Var.type_ dest |]
      in
      Hashtbl.set ctx.var_map ~key:dest ~data:new_instr.results.(0);
      Some new_instr
    | Lt { dest; src1; src2 } ->
      let op1 = convert_lit_or_var ctx src1 in
      let op2 = convert_lit_or_var ctx src2 in
      let new_instr =
        Graph_ir.Func.fresh_instr
          ctx.func
          ~opcode:Lt
          ~operands:[| op1; op2 |]
          ~result_types:[| Var.type_ dest |]
      in
      Hashtbl.set ctx.var_map ~key:dest ~data:new_instr.results.(0);
      Some new_instr
    | And { dest; src1; src2 } ->
      let op1 = convert_lit_or_var ctx src1 in
      let op2 = convert_lit_or_var ctx src2 in
      let new_instr =
        Graph_ir.Func.fresh_instr
          ctx.func
          ~opcode:And
          ~operands:[| op1; op2 |]
          ~result_types:[| Var.type_ dest |]
      in
      Hashtbl.set ctx.var_map ~key:dest ~data:new_instr.results.(0);
      Some new_instr
    | Or { dest; src1; src2 } ->
      let op1 = convert_lit_or_var ctx src1 in
      let op2 = convert_lit_or_var ctx src2 in
      let new_instr =
        Graph_ir.Func.fresh_instr
          ctx.func
          ~opcode:Or
          ~operands:[| op1; op2 |]
          ~result_types:[| Var.type_ dest |]
      in
      Hashtbl.set ctx.var_map ~key:dest ~data:new_instr.results.(0);
      Some new_instr
    | Fadd { dest; src1; src2 } ->
      let op1 = convert_lit_or_var ctx src1 in
      let op2 = convert_lit_or_var ctx src2 in
      let new_instr =
        Graph_ir.Func.fresh_instr
          ctx.func
          ~opcode:Fadd
          ~operands:[| op1; op2 |]
          ~result_types:[| Var.type_ dest |]
      in
      Hashtbl.set ctx.var_map ~key:dest ~data:new_instr.results.(0);
      Some new_instr
    | Fsub { dest; src1; src2 } ->
      let op1 = convert_lit_or_var ctx src1 in
      let op2 = convert_lit_or_var ctx src2 in
      let new_instr =
        Graph_ir.Func.fresh_instr
          ctx.func
          ~opcode:Fsub
          ~operands:[| op1; op2 |]
          ~result_types:[| Var.type_ dest |]
      in
      Hashtbl.set ctx.var_map ~key:dest ~data:new_instr.results.(0);
      Some new_instr
    | Fmul { dest; src1; src2 } ->
      let op1 = convert_lit_or_var ctx src1 in
      let op2 = convert_lit_or_var ctx src2 in
      let new_instr =
        Graph_ir.Func.fresh_instr
          ctx.func
          ~opcode:Fmul
          ~operands:[| op1; op2 |]
          ~result_types:[| Var.type_ dest |]
      in
      Hashtbl.set ctx.var_map ~key:dest ~data:new_instr.results.(0);
      Some new_instr
    | Fdiv { dest; src1; src2 } ->
      let op1 = convert_lit_or_var ctx src1 in
      let op2 = convert_lit_or_var ctx src2 in
      let new_instr =
        Graph_ir.Func.fresh_instr
          ctx.func
          ~opcode:Fdiv
          ~operands:[| op1; op2 |]
          ~result_types:[| Var.type_ dest |]
      in
      Hashtbl.set ctx.var_map ~key:dest ~data:new_instr.results.(0);
      Some new_instr
    | Move (dest, src) ->
      let op = convert_lit_or_var ctx src in
      let new_instr =
        Graph_ir.Func.fresh_instr
          ctx.func
          ~opcode:Move
          ~operands:[| op |]
          ~result_types:[| Var.type_ dest |]
      in
      Hashtbl.set ctx.var_map ~key:dest ~data:new_instr.results.(0);
      Some new_instr
    | Cast (dest, src) ->
      let op = convert_lit_or_var ctx src in
      let new_instr =
        Graph_ir.Func.fresh_instr
          ctx.func
          ~opcode:(Cast (Var.type_ dest))
          ~operands:[| op |]
          ~result_types:[| Var.type_ dest |]
      in
      Hashtbl.set ctx.var_map ~key:dest ~data:new_instr.results.(0);
      Some new_instr
    | Load (dest, mem) ->
      let mem' = convert_mem ctx mem in
      let new_instr =
        Graph_ir.Func.fresh_instr
          ctx.func
          ~opcode:(Load mem')
          ~operands:[||]
          ~result_types:[| Var.type_ dest |]
      in
      Hashtbl.set ctx.var_map ~key:dest ~data:new_instr.results.(0);
      Some new_instr
    | Store (src, mem) ->
      let op = convert_lit_or_var ctx src in
      let mem' = convert_mem ctx mem in
      let new_instr =
        Graph_ir.Func.fresh_instr
          ctx.func
          ~opcode:(Store mem')
          ~operands:[| op |]
          ~result_types:[||]
      in
      Some new_instr
    | Alloca { dest; size } ->
      let size_val = convert_lit_or_var ctx size in
      let new_instr =
        Graph_ir.Func.fresh_instr
          ctx.func
          ~opcode:Alloca
          ~operands:[| size_val |]
          ~result_types:[| Var.type_ dest |]
      in
      Hashtbl.set ctx.var_map ~key:dest ~data:new_instr.results.(0);
      Some new_instr
    | Atomic_load { dest; addr; order } ->
      let mem' = convert_mem ctx addr in
      let new_instr =
        Graph_ir.Func.fresh_instr
          ctx.func
          ~opcode:(Atomic_load (mem', order))
          ~operands:[||]
          ~result_types:[| Var.type_ dest |]
      in
      Hashtbl.set ctx.var_map ~key:dest ~data:new_instr.results.(0);
      Some new_instr
    | Atomic_store { addr; src; order } ->
      let op = convert_lit_or_var ctx src in
      let mem' = convert_mem ctx addr in
      let new_instr =
        Graph_ir.Func.fresh_instr
          ctx.func
          ~opcode:(Atomic_store (mem', order))
          ~operands:[| op |]
          ~result_types:[||]
      in
      Some new_instr
    | Atomic_rmw { dest; addr; src; op; order } ->
      let src_val = convert_lit_or_var ctx src in
      let mem' = convert_mem ctx addr in
      let new_instr =
        Graph_ir.Func.fresh_instr
          ctx.func
          ~opcode:(Atomic_rmw (mem', op, order))
          ~operands:[| src_val |]
          ~result_types:[| Var.type_ dest |]
      in
      Hashtbl.set ctx.var_map ~key:dest ~data:new_instr.results.(0);
      Some new_instr
    | Atomic_cmpxchg { dest; success; addr; expected; desired; success_order; failure_order } ->
      let expected_val = convert_lit_or_var ctx expected in
      let desired_val = convert_lit_or_var ctx desired in
      let mem' = convert_mem ctx addr in
      let new_instr =
        Graph_ir.Func.fresh_instr
          ctx.func
          ~opcode:(Atomic_cmpxchg { addr = mem'; success_order; failure_order })
          ~operands:[| expected_val; desired_val |]
          ~result_types:[| Var.type_ dest; Var.type_ success |]
      in
      Hashtbl.set ctx.var_map ~key:dest ~data:new_instr.results.(0);
      Hashtbl.set ctx.var_map ~key:success ~data:new_instr.results.(1);
      Some new_instr
    | Call { fn; results; args } ->
      let arg_vals = List.map args ~f:(convert_lit_or_var ctx) |> Array.of_list in
      let result_types = List.map results ~f:Var.type_ |> Array.of_list in
      let new_instr =
        Graph_ir.Func.fresh_instr
          ctx.func
          ~opcode:(Call fn)
          ~operands:arg_vals
          ~result_types
      in
      List.iteri results ~f:(fun i var ->
        Hashtbl.set ctx.var_map ~key:var ~data:new_instr.results.(i));
      Some new_instr
    | Branch _ | Return _ | Unreachable ->
      (* Handled separately as terminators *)
      None
    | Load_field _ | Store_field _ | Memcpy _ ->
      (* These should be lowered before conversion *)
      failwith "Load_field/Store_field/Memcpy should be lowered before Graph IR conversion"
    | Arm64 _ | Arm64_terminal _ | X86 _ | X86_terminal _ ->
      (* These are backend-specific and shouldn't appear here *)
      failwith "Backend-specific instructions should not appear in high-level IR"
  ;;

  let convert_block ctx (old_block : Block.t) : Graph_ir.Block.t =
    Hashtbl.find_or_add ctx.block_map old_block ~default:(fun () ->
      let id = fresh_block_id ctx in
      Graph_ir.Block.create ~id ~id_hum:old_block.id_hum)
  ;;

  let convert_function (old_fn : Function.t) : Graph_ir.Func.t =
    (* TODO: Infer return type from function signature or return statements *)
    let new_fn = Graph_ir.Func.create ~name:old_fn.name ~return_type:Type.I64 in
    let ctx =
      { func = new_fn
      ; var_map = Var.Table.create ()
      ; block_map = Block.Table.create ()
      ; next_block_id = 1
      }
    in

    (* First pass: create all blocks *)
    Block.iter old_fn.root ~f:(fun old_block ->
      let _ = convert_block ctx old_block in
      ());

    (* Second pass: convert block arguments (phi nodes) *)
    Block.iter old_fn.root ~f:(fun old_block ->
      let new_block = convert_block ctx old_block in
      let args =
        Vec.to_list old_block.args
        |> List.map ~f:(fun var ->
          let value =
            Graph_ir.Func.fresh_value
              ctx.func
              ~type_:(Var.type_ var)
              ~def:(Block_arg (new_block, 0))
          in
          Hashtbl.set ctx.var_map ~key:var ~data:value;
          value)
        |> Array.of_list
      in
      new_block.args <- args);

    (* Third pass: convert instructions *)
    Block.iter old_fn.root ~f:(fun old_block ->
      let new_block = convert_block ctx old_block in

      (* Convert regular instructions *)
      Vec.iter old_block.instructions ~f:(fun instr ->
        match convert_instr ctx instr with
        | None -> ()
        | Some new_instr -> Graph_ir.Block.add_instr new_block new_instr);

      (* Convert terminator *)
      match old_block.terminal with
      | Branch (Uncond { block; args }) ->
        let target_block = convert_block ctx block in
        let arg_vals = List.map args ~f:(get_or_create_value ctx) |> Array.of_list in
        new_block.terminator
        <- Branch
             { cond = None
             ; true_target = { target = target_block; args = arg_vals }
             ; false_target = None
             }
      | Branch (Cond { cond; if_true; if_false }) ->
        let cond_val = convert_lit_or_var ctx cond in
        let true_block = convert_block ctx if_true.block in
        let false_block = convert_block ctx if_false.block in
        let true_args =
          List.map if_true.args ~f:(get_or_create_value ctx) |> Array.of_list
        in
        let false_args =
          List.map if_false.args ~f:(get_or_create_value ctx) |> Array.of_list
        in
        new_block.terminator
        <- Branch
             { cond = Some cond_val
             ; true_target = { target = true_block; args = true_args }
             ; false_target =
                 Some { target = false_block; args = false_args }
             }
      | Return ret_val ->
        let ret_val_opt =
          match ret_val with
          | Lit i ->
            (* Create constant - simplified for now *)
            Some (convert_lit_or_var ctx (Lit i))
          | Var v -> Some (get_or_create_value ctx v)
          | Global g -> Some (convert_lit_or_var ctx (Global g))
        in
        new_block.terminator <- Return ret_val_opt
      | Unreachable -> new_block.terminator <- Unreachable
      | _ ->
        failwith
          (sprintf
             "Unexpected terminal instruction in block %s"
             old_block.id_hum));

    (* Set entry block *)
    new_fn.entry_block <- convert_block ctx old_fn.root;

    (* Build block list *)
    new_fn.blocks
    <- Hashtbl.data ctx.block_map
       |> List.sort ~compare:(fun b1 b2 -> Int.compare b1.id b2.id);

    (* Build CFG edges (predecessors/successors) *)
    List.iter new_fn.blocks ~f:(fun block ->
      match block.terminator with
      | Branch { cond = _; true_target; false_target } ->
        block.successors <- [ true_target ];
        true_target.target.predecessors <- block :: true_target.target.predecessors;
        (match false_target with
         | Some ft ->
           block.successors <- ft :: block.successors;
           ft.target.predecessors <- block :: ft.target.predecessors
         | None -> ())
      | Return _ | Unreachable -> ());

    new_fn
  ;;
end

(* Convert from Graph IR back to old IR *)
module From_graph = struct
  (* TODO: Implement reverse conversion for testing and gradual migration *)
  let convert_function (_fn : Graph_ir.Func.t) : Function.t =
    failwith "From_graph conversion not yet implemented"
  ;;
end
