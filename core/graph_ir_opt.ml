open! Core
open! Import

(* Advanced optimization passes for Graph IR *)

module G = Graph_ir

(* ===== Common Subexpression Elimination (CSE) ===== *)

module CSE = struct
  (* Hash table for tracking computed expressions *)
  (* We use instruction ID + operand IDs as the hash key *)
  module Expr_hash = struct
    type opcode_tag =
      | TAdd
      | TSub
      | TMul
      | TDiv
      | TMod
      | TLt
      | TAnd
      | TOr
      | TFadd
      | TFsub
      | TFmul
      | TFdiv
      | TMove
      | TCast
      | TOther
    [@@deriving sexp, compare, hash]

    type t =
      { opcode : opcode_tag
      ; operands : G.Value_id.t list
      }
    [@@deriving sexp, compare, hash]

    include Comparable.Make (struct
      type nonrec t = t [@@deriving sexp, compare]
    end)

    include Hashable.Make (struct
      type nonrec t = t [@@deriving sexp, compare, hash]
    end)

    let tag_of_opcode (op : G.Instr.opcode) : opcode_tag =
      match op with
      | Add -> TAdd
      | Sub -> TSub
      | Mul -> TMul
      | Div -> TDiv
      | Mod -> TMod
      | Lt -> TLt
      | And -> TAnd
      | Or -> TOr
      | Fadd -> TFadd
      | Fsub -> TFsub
      | Fmul -> TFmul
      | Fdiv -> TFdiv
      | Move -> TMove
      | Cast _ -> TCast
      | _ -> TOther
    ;;
  end

  let can_be_eliminated (opcode : G.Instr.opcode) =
    match opcode with
    (* Pure arithmetic and logical operations *)
    | Add | Sub | Mul | Div | Mod | Lt | And | Or | Fadd | Fsub | Fmul | Fdiv | Move
    | Cast _ ->
      true
    (* Operations with side effects cannot be eliminated *)
    | Load _ (* may depend on memory state *)
    | Store _ | Alloca | Atomic_load _ | Atomic_store _ | Atomic_rmw _
    | Atomic_cmpxchg _ | Call _ -> false
  ;;

  let hash_of_instr (instr : G.Instr.t) : Expr_hash.t option =
    let opcode = G.Instr.opcode instr in
    if can_be_eliminated opcode
    then (
      let opcode_tag = Expr_hash.tag_of_opcode opcode in
      let operands =
        Array.to_list (G.Instr.operands instr)
        |> List.map ~f:(fun v -> G.Value.id v)
      in
      Some { Expr_hash.opcode = opcode_tag; operands })
    else None
  ;;

  (* CSE within a single basic block *)
  let run_block (block : G.Block.t) =
    let expr_table = Expr_hash.Table.create () in
    let changed = ref false in
    let rec scan = function
      | None -> ()
      | Some instr ->
        let next = G.Instr.next instr in
        (match hash_of_instr instr with
         | None -> ()
         | Some hash ->
           (match Hashtbl.find expr_table hash with
            | Some existing_value ->
              (* Found a redundant computation! *)
              if Array.length (G.Instr.results instr) = 1
              then (
                let result = (G.Instr.results instr).(0) in
                G.Value.replace_all_uses_with result existing_value;
                (* Remove the instruction *)
                Array.iter (G.Instr.operands instr) ~f:(fun op ->
                  G.Value.remove_use op instr);
                G.Instr.remove instr;
                changed := true)
            | None ->
              (* First time seeing this expression, record it *)
              if Array.length (G.Instr.results instr) = 1
              then (
                let result = (G.Instr.results instr).(0) in
                Hashtbl.set expr_table ~key:hash ~data:result)));
        scan next
    in
    scan (G.Block.first_instr block);
    !changed
  ;;

  let run (func : G.Func.t) =
    let changed = ref false in
    G.Func.iter_blocks func ~f:(fun block ->
      if run_block block then changed := true);
    !changed
  ;;
end

(* ===== Global Value Numbering (GVN) ===== *)

module GVN = struct
  (* GVN is like CSE but works across basic blocks using dominator tree *)

  type value_number = int

  module VN_hash = CSE.Expr_hash

  type context =
    { mutable vn_table : G.Value.t VN_hash.Table.t
    ; mutable changed : bool
    }

  let create_context () = { vn_table = VN_hash.Table.create (); changed = false }

  let run_block ctx (block : G.Block.t) =
    let rec scan = function
      | None -> ()
      | Some instr ->
        let next = G.Instr.next instr in
        (match CSE.hash_of_instr instr with
         | None -> ()
         | Some hash ->
           (match Hashtbl.find ctx.vn_table hash with
            | Some existing_value ->
              (* Found equivalent value from dominating block *)
              if Array.length (G.Instr.results instr) = 1
              then (
                let result = (G.Instr.results instr).(0) in
                G.Value.replace_all_uses_with result existing_value;
                Array.iter (G.Instr.operands instr) ~f:(fun op ->
                  G.Value.remove_use op instr);
                G.Instr.remove instr;
                ctx.changed <- true)
            | None ->
              if Array.length (G.Instr.results instr) = 1
              then (
                let result = (G.Instr.results instr).(0) in
                Hashtbl.set ctx.vn_table ~key:hash ~data:result)));
        scan next
    in
    scan (G.Block.first_instr block)
  ;;

  let rec visit_dom_tree ctx (block : G.Block.t) =
    (* Save the current vn_table state *)
    let saved_vn_table = Hashtbl.copy ctx.vn_table in

    (* Process this block *)
    run_block ctx block;

    (* Visit dominated children *)
    List.iter (G.Block.dom_tree_children block) ~f:(visit_dom_tree ctx);

    (* Restore vn_table (scoping to dominator tree) *)
    ctx.vn_table <- saved_vn_table
  ;;

  let run (func : G.Func.t) =
    let ctx = create_context () in
    visit_dom_tree ctx func.entry_block;
    ctx.changed
  ;;
end

(* ===== Loop Detection ===== *)

module Loop = struct
  module Block_set = Hash_set.Make (struct
    type t = G.Block.t

    let sexp_of_t b = Int.sexp_of_t (G.Block.id b)
    let t_of_sexp _ = failwith "not implemented"
    let compare b1 b2 = Int.compare (G.Block.id b1) (G.Block.id b2)
    let hash b = Int.hash (G.Block.id b)
  end)

  type t =
    { header : G.Block.t
    ; blocks : Block_set.t
    ; exits : Block_set.t
    }

  let find_loops (func : G.Func.t) : t list =
    (* Simple loop detection using back edges *)
    let loops = ref [] in
    let visited = Block_set.create () in

    let rec dfs block path =
      if Hash_set.mem visited block
      then (
        (* Found a back edge if block is in current path *)
        if List.mem path block ~equal:phys_equal
        then (
          (* This is a loop header *)
          let loop_blocks = Block_set.create () in
          let rec collect_loop = function
            | [] -> ()
            | b :: rest ->
              Hash_set.add loop_blocks b;
              if phys_equal b block
              then ()
              else collect_loop rest
          in
          collect_loop path;
          loops
          := { header = block
             ; blocks = loop_blocks
             ; exits = Block_set.create ()
             }
             :: !loops))
      else (
        Hash_set.add visited block;
        let new_path = block :: path in
        List.iter (G.Block.successors block) ~f:(fun succ ->
          dfs succ.target new_path))
    in

    dfs func.entry_block [];
    !loops
  ;;
end

(* ===== Loop-Invariant Code Motion (LICM) ===== *)

module LICM = struct
  let is_loop_invariant loop (instr : G.Instr.t) =
    (* An instruction is loop invariant if all its operands are defined outside the loop *)
    Array.for_all (G.Instr.operands instr) ~f:(fun operand ->
      match G.Value.def operand with
      | Undef -> true
      | Block_arg (block, _) -> not (Hash_set.mem loop.Loop.blocks block)
      | Instr_result (def_instr, _) ->
        (match G.Instr.block def_instr with
         | None -> false
         | Some def_block -> not (Hash_set.mem loop.Loop.blocks def_block)))
    && not (G.Instr.has_side_effects instr)
  ;;

  let find_preheader (loop : Loop.t) : G.Block.t option =
    (* Find or create a preheader block *)
    let preds = G.Block.predecessors loop.header in
    let external_preds =
      List.filter preds ~f:(fun pred -> not (Hash_set.mem loop.blocks pred))
    in
    match external_preds with
    | [ single_pred ] ->
      (* Check if this predecessor only has one successor (our header) *)
      if List.length (G.Block.successors single_pred) = 1
      then Some single_pred
      else None
    | _ -> None
  ;;

  let hoist_instruction (instr : G.Instr.t) (preheader : G.Block.t) =
    (* Move instruction from loop to preheader *)
    G.Instr.remove instr;
    match G.Block.last_instr preheader with
    | Some last -> G.Instr.insert_before ~before:last instr
    | None -> G.Block.add_instr preheader instr
  ;;

  let run_loop (loop : Loop.t) =
    match find_preheader loop with
    | None -> false (* Can't do LICM without a preheader *)
    | Some preheader ->
      let changed = ref false in
      Hash_set.iter loop.blocks ~f:(fun block ->
        let rec scan = function
          | None -> ()
          | Some instr ->
            let next = G.Instr.next instr in
            if is_loop_invariant loop instr
            then (
              hoist_instruction instr preheader;
              changed := true);
            scan next
        in
        scan (G.Block.first_instr block));
      !changed
  ;;

  let run (func : G.Func.t) =
    let loops = Loop.find_loops func in
    let changed = ref false in
    List.iter loops ~f:(fun loop ->
      if run_loop loop then changed := true);
    !changed
  ;;
end

(* ===== Advanced Dead Code Elimination ===== *)

module DCE = struct
  (* Mark and sweep DCE: mark all live code, then delete unmarked *)

  module Instr_set = Hash_set.Make (struct
    type t = G.Instr.t

    let sexp_of_t i = Int.sexp_of_t (G.Instr.id i)
    let t_of_sexp _ = failwith "not implemented"
    let compare i1 i2 = Int.compare (G.Instr.id i1) (G.Instr.id i2)
    let hash i = Int.hash (G.Instr.id i)
  end)

  let mark_live (func : G.Func.t) : Instr_set.t =
    let live = Instr_set.create () in
    let worklist = Queue.create () in

    (* Mark all instructions with side effects as live *)
    G.Func.iter_instrs func ~f:(fun instr ->
      if G.Instr.has_side_effects instr
      then (
        Hash_set.add live instr;
        Queue.enqueue worklist instr));

    (* Also mark terminators as live *)
    G.Func.iter_blocks func ~f:(fun block ->
      match G.Block.terminator block with
      | Return (Some ret_val) ->
        (match G.Value.def ret_val with
         | Instr_result (instr, _) ->
           if not (Hash_set.mem live instr)
           then (
             Hash_set.add live instr;
             Queue.enqueue worklist instr)
         | _ -> ())
      | _ -> ());

    (* Propagate liveness backwards through use-def chains *)
    while not (Queue.is_empty worklist) do
      let instr = Queue.dequeue_exn worklist in
      Array.iter (G.Instr.operands instr) ~f:(fun operand ->
        match G.Value.def operand with
        | Instr_result (def_instr, _) ->
          if not (Hash_set.mem live def_instr)
          then (
            Hash_set.add live def_instr;
            Queue.enqueue worklist def_instr)
        | _ -> ())
    done;

    live
  ;;

  let run (func : G.Func.t) =
    let live = mark_live func in
    let changed = ref false in

    G.Func.iter_blocks func ~f:(fun block ->
      let rec scan = function
        | None -> ()
        | Some instr ->
          let next = G.Instr.next instr in
          if not (Hash_set.mem live instr)
          then (
            (* Remove dead instruction *)
            Array.iter (G.Instr.operands instr) ~f:(fun op ->
              G.Value.remove_use op instr);
            G.Instr.remove instr;
            changed := true);
          scan next
      in
      scan (G.Block.first_instr block));

    !changed
  ;;
end

(* ===== Constant Propagation ===== *)

module ConstProp = struct
  (* Track constant values *)
  type const_value =
    | Int of Int64.t
    | Unknown

  let eval_binop op (a : const_value) (b : const_value) : const_value =
    match a, b with
    | Int a, Int b ->
      (match op with
       | `Add -> Int Int64.(a + b)
       | `Sub -> Int Int64.(a - b)
       | `Mul -> Int Int64.(a * b)
       | `Div -> if Int64.(b = zero) then Unknown else Int Int64.(a / b)
       | `Mod -> if Int64.(b = zero) then Unknown else Int Int64.(rem a b)
       | `Lt -> Int (if Int64.(a < b) then 1L else 0L)
       | `And -> Int Int64.(a land b)
       | `Or -> Int Int64.(a lor b))
    | _ -> Unknown
  ;;

  let run (_func : G.Func.t) =
    (* TODO: Implement constant propagation *)
    (* Need to add a way to represent constants in the IR first *)
    false
  ;;
end

(* ===== Partial Redundancy Elimination (PRE) ===== *)

module PRE = struct
  (* PRE is complex - it combines CSE and code motion *)
  (* For now, implement a simpler version that just does anticipation-based hoisting *)

  let run (_func : G.Func.t) =
    (* TODO: Implement PRE *)
    (* This requires:
       1. Compute anticipated expressions (expressions that will be computed on all paths)
       2. Insert computations to make partially redundant expressions fully redundant
       3. Eliminate the now-redundant computations
    *)
    false
  ;;
end

(* ===== Copy Propagation ===== *)

module CopyProp = struct
  (* Replace uses of copies with the original value *)

  let run (func : G.Func.t) =
    let changed = ref false in

    G.Func.iter_instrs func ~f:(fun instr ->
      match G.Instr.opcode instr with
      | Move when Array.length (G.Instr.operands instr) = 1
                  && Array.length (G.Instr.results instr) = 1 ->
        let src = (G.Instr.operands instr).(0) in
        let dst = (G.Instr.results instr).(0) in
        G.Value.replace_all_uses_with dst src;
        G.Value.remove_use src instr;
        G.Instr.remove instr;
        changed := true
      | _ -> ());

    !changed
  ;;
end

(* ===== Optimization Pipeline ===== *)

let run_pass ~verbose ~name ~pass func =
  let start_time = Time_ns.now () in
  let changed = pass func in
  let elapsed = Time_ns.diff (Time_ns.now ()) start_time in
  if verbose
  then (
    if changed
    then
      printf
        !"[OPT] %s: changed (took %{Time_ns.Span})\n%!"
        name
        elapsed
    else printf !"[OPT] %s: no change (took %{Time_ns.Span})\n%!" name elapsed);
  changed
;;

let optimize ?(verbose = false) (func : G.Func.t) =
  let print msg = if verbose then print_endline msg in

  print "Starting optimization pipeline...";

  (* Run optimization passes to fixed point *)
  let changed = ref true in
  let iterations = ref 0 in

  while !changed && !iterations < 10 do
    incr iterations;
    print (sprintf "\n=== Iteration %d ===" !iterations);
    changed := false;

    (* DCE: Remove obviously dead code *)
    if run_pass ~verbose ~name:"DCE" ~pass:DCE.run func then changed := true;

    (* Copy propagation: Simplify moves *)
    if run_pass ~verbose ~name:"CopyProp" ~pass:CopyProp.run func then changed := true;

    (* CSE: Eliminate redundant computations within blocks *)
    if run_pass ~verbose ~name:"CSE" ~pass:CSE.run func then changed := true;

    (* GVN: Eliminate redundant computations across blocks *)
    if run_pass ~verbose ~name:"GVN" ~pass:GVN.run func then changed := true;

    (* LICM: Move loop-invariant code out of loops *)
    if run_pass ~verbose ~name:"LICM" ~pass:LICM.run func then changed := true;

    (* Final DCE: Clean up any newly dead code *)
    if run_pass ~verbose ~name:"DCE (final)" ~pass:DCE.run func then changed := true
  done;

  print (sprintf "\nOptimization complete after %d iterations" !iterations)
;;
