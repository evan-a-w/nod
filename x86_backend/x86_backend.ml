open! Core
open! Import
open! Common

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
    Block.iter root ~f:(fun block ->
      let block_liveness = block_liveness t block in
      let f ({ live_in; _ } : Liveness.t) ir =
        let new_live_in =
          Set.union (ir_uses t ir) (Set.diff live_in (ir_defs t ir))
        in
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

        let pror = Pror.create_with_problem sat_constraints

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
          match Pror.run_with_assumptions pror assumptions, !to_spill with
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
        let header_bytes_excl_clobber_saves =
          fn.bytes_alloca'd + fn.bytes_for_spills
        in
        let new_prologue : Ir.t Vec.t = Vec.create () in
        (* change prologue *)
        if header_bytes_excl_clobber_saves > 0
        then
          Vec.push
            new_prologue
            (X86
               (sub
                  (Reg RSP)
                  (Imm (Int64.of_int header_bytes_excl_clobber_saves))));
        List.iter to_restore ~f:(fun reg ->
          Vec.push new_prologue (X86 (push (Reg reg))));
        Vec.push new_prologue (X86 (mov (Reg RBP) (Reg RSP)));
        if Function.stack_header_bytes fn > 0
        then
          Vec.push
            new_prologue
            (X86
               (add
                  (Reg RBP)
                  (Imm (Function.stack_header_bytes fn |> Int64.of_int))));
        Vec.append new_prologue prologue.instructions;
        prologue.instructions <- new_prologue
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
    | Reg.RSP -> false
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
    Instruction_selection.run fn |> Regalloc.run ?dump_crap)
  |> Clobbers.process
  |> Save_call_clobbers.process
;;

let lower (functions : Function.t String.Map.t) =
  let sanitize_identifier s =
    let sanitized =
      String.filter_map s ~f:(fun c ->
        match c with
        | 'A' .. 'Z' -> Some (Char.lowercase c)
        | 'a' .. 'z' | '0' .. '9' | '_' -> Some c
        | _ -> Some '_')
    in
    let sanitized = if String.is_empty sanitized then "_" else sanitized in
    if Char.is_digit sanitized.[0] then "_" ^ sanitized else sanitized
  in
  let rec string_of_reg = function
    | Reg.RAX -> "rax"
    | Reg.RBX -> "rbx"
    | Reg.RCX -> "rcx"
    | Reg.RDX -> "rdx"
    | Reg.RSI -> "rsi"
    | Reg.RDI -> "rdi"
    | Reg.RSP -> "rsp"
    | Reg.RBP -> "rbp"
    | Reg.R8 -> "r8"
    | Reg.R9 -> "r9"
    | Reg.R10 -> "r10"
    | Reg.R11 -> "r11"
    | Reg.R12 -> "r12"
    | Reg.R13 -> "r13"
    | Reg.R14 -> "r14"
    | Reg.R15 -> "r15"
    | Reg.Unallocated v | Reg.Allocated (v, None) -> sanitize_identifier v
    | Reg.Allocated (_, Some reg) -> string_of_reg reg
  in
  let string_of_mem reg disp =
    let base = string_of_reg reg in
    match disp with
    | 0 -> sprintf "[%s]" base
    | d when d > 0 -> sprintf "[%s + %d]" base d
    | d -> sprintf "[%s - %d]" base (-d)
  in
  let string_of_operand = function
    | Reg reg -> string_of_reg reg
    | Imm imm -> Int64.to_string imm
    | Mem (reg, disp) -> string_of_mem reg disp
  in
  let is_valid_move_dest = function
    | Reg _ | Mem _ -> true
    | Imm _ -> false
  in
  let rec unwrap_tags = function
    | Tag_use (ins, _) | Tag_def (ins, _) -> unwrap_tags ins
    | ins -> ins
  in
  let add_line buf line =
    Buffer.add_string buf line;
    Buffer.add_char buf '\n'
  in
  let functions_alist = Map.to_alist functions in
  match functions_alist with
  | [] -> ""
  | _ ->
    let buffer = Buffer.create 1024 in
    add_line buffer ".intel_syntax noprefix";
    add_line buffer ".text";
    let used_labels = String.Hash_set.create () in
    List.iteri functions_alist ~f:(fun fn_index (name, fn) ->
      if fn_index > 0 then Buffer.add_char buffer '\n';
      let fn_label_base = sanitize_identifier name in
      let ensure_unique label =
        let rec loop attempt =
          let candidate =
            if attempt = 0 then label else sprintf "%s_%d" label attempt
          in
          if Hash_set.mem used_labels candidate
          then loop (attempt + 1)
          else (
            Hash_set.add used_labels candidate;
            candidate)
        in
        loop 0
      in
      let fn_label = ensure_unique fn_label_base in
      add_line buffer (sprintf ".globl %s" fn_label);
      let blocks =
        let acc = ref [] in
        Block.iter fn.Function.root ~f:(fun block -> acc := block :: !acc);
        List.rev !acc
      in
      let label_by_block = Block.Table.create () in
      List.iteri blocks ~f:(fun idx block ->
        let base_label =
          if idx = 0
          then fn_label
          else sanitize_identifier (sprintf "%s__%s" name block.Block.id_hum)
        in
        let base_label =
          if idx = 0 then base_label else ensure_unique base_label
        in
        Hashtbl.add_exn label_by_block ~key:block ~data:base_label);
      let emit_instruction line = add_line buffer ("  " ^ line) in
      let emit_label label = add_line buffer (label ^ ":") in
      let label_of_block block = Hashtbl.find_exn label_by_block block in
      let label_of_call_block call_block =
        label_of_block call_block.Call_block.block
      in
      let lower_instruction instr =
        let instr = unwrap_tags instr in
        match instr with
        | NOOP | Save_clobbers | Restore_clobbers -> `No_emit
        | MOV (dst, src) ->
          `Emit
            (if (not (is_valid_move_dest dst)) || [%equal: operand] dst src
             then []
             else
               [ sprintf
                   "mov %s, %s"
                   (string_of_operand dst)
                   (string_of_operand src)
               ])
        | ADD (dst, src) ->
          `Emit
            [ sprintf
                "add %s, %s"
                (string_of_operand dst)
                (string_of_operand src)
            ]
        | SUB (dst, src) ->
          `Emit
            [ sprintf
                "sub %s, %s"
                (string_of_operand dst)
                (string_of_operand src)
            ]
        | AND (dst, src) ->
          `Emit
            [ sprintf
                "and %s, %s"
                (string_of_operand dst)
                (string_of_operand src)
            ]
        | OR (dst, src) ->
          `Emit
            [ sprintf
                "or %s, %s"
                (string_of_operand dst)
                (string_of_operand src)
            ]
        | IMUL op -> `Emit [ sprintf "imul %s" (string_of_operand op) ]
        | IDIV op | MOD op -> `Emit [ sprintf "idiv %s" (string_of_operand op) ]
        | CMP (Imm a, Imm b) -> `Set_pending (Some (a, b))
        | CMP (a, b) ->
          `Emit
            [ sprintf "cmp %s, %s" (string_of_operand a) (string_of_operand b) ]
        | CALL { fn = callee; _ } ->
          let callee = sanitize_identifier callee in
          `Emit [ sprintf "call %s" callee ]
        | PUSH op -> `Emit [ sprintf "push %s" (string_of_operand op) ]
        | POP reg -> `Emit [ sprintf "pop %s" (string_of_reg reg) ]
        | JMP cb -> `Emit [ sprintf "jmp %s" (label_of_call_block cb) ]
        | JE (cb, else_) -> `Branch (`Je, cb, else_)
        | JNE (cb, else_) -> `Branch (`Jne, cb, else_)
        | RET _ -> `Emit [ "ret" ]
        | ALLOCA _ -> `Emit []
        | LABEL s ->
          let label = ensure_unique (sanitize_identifier s) in
          `Emit_label label
        | Tag_use _ | Tag_def _ -> assert false
      in
      let pending_const_cmp = ref None in
      let handle_branch branch_kind cb else_opt =
        let emit_branch kind target =
          match kind with
          | `Je -> emit_instruction (sprintf "je %s" target)
          | `Jne -> emit_instruction (sprintf "jne %s" target)
        in
        match !pending_const_cmp with
        | Some (lhs, rhs) ->
          pending_const_cmp := None;
          let take_branch =
            match branch_kind with
            | `Je -> Int64.equal lhs rhs
            | `Jne -> not (Int64.equal lhs rhs)
          in
          if take_branch
          then emit_instruction (sprintf "jmp %s" (label_of_call_block cb))
          else (
            match else_opt with
            | None -> ()
            | Some else_cb ->
              emit_instruction (sprintf "jmp %s" (label_of_call_block else_cb)))
        | None ->
          emit_branch branch_kind (label_of_call_block cb);
          Option.iter else_opt ~f:(fun else_cb ->
            emit_instruction (sprintf "jmp %s" (label_of_call_block else_cb)))
      in
      let process_instruction instr =
        match lower_instruction instr with
        | `No_emit -> ()
        | `Set_pending value -> pending_const_cmp := value
        | `Emit_label label ->
          pending_const_cmp := None;
          emit_label label
        | `Branch (kind, cb, else_opt) -> handle_branch kind cb else_opt
        | `Emit lines ->
          pending_const_cmp := None;
          List.iter lines ~f:emit_instruction
      in
      List.iter blocks ~f:(fun block ->
        let label = label_of_block block in
        add_line buffer (label ^ ":");
        pending_const_cmp := None;
        let instructions = Vec.to_list block.Block.instructions in
        List.iter instructions ~f:(fun ir ->
          match ir with
          | Ir0.X86 x -> process_instruction x
          | Ir0.X86_terminal xs -> List.iter xs ~f:process_instruction
          | _ -> ());
        match block.Block.terminal with
        | Ir0.X86_terminal xs -> List.iter xs ~f:process_instruction
        | Ir0.X86 x -> process_instruction x
        | _ -> ()));
    Buffer.contents buffer
;;

let compile_to_asm ?dump_crap functions = compile ?dump_crap functions |> lower
