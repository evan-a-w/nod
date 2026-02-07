open! Core
open! Import

module Dominator = struct
  type t =
    { parent : int Nod_vec.t
    ; semi : int Nod_vec.t
    ; blocks : Block.t Nod_vec.t
    ; bucket : Int.Hash_set.t Nod_vec.t
    ; dom : int Nod_vec.t
    ; ancestor : int Nod_vec.t
    ; label : int Nod_vec.t
    ; dominance_frontier : Int.Hash_set.t Nod_vec.t
    ; fn_state : Fn_state.t
    }
  [@@deriving fields]

  let dfs ~fn_state block =
    let blocks = Nod_vec.create () in
    let parent = Nod_vec.create () in
    let semi = Nod_vec.create () in
    let i = ref 0 in
    let rec go block =
      match Block.dfs_id block with
      | None ->
        Block.set_dfs_id block (Some !i);
        Nod_vec.push semi !i;
        incr i;
        Nod_vec.push blocks block;
        Nod_vec.iter (Block.children block) ~f:(fun b ->
          go b;
          Nod_vec.fill_to_length
            parent
            ~length:(Block.id_exn b + 1)
            ~f:(fun _ -> -1);
          Nod_vec.set parent (Block.id_exn b) (Block.id_exn block))
      | Some _ -> ()
    in
    go block;
    let bucket = Nod_vec.map blocks ~f:(fun _ -> Int.Hash_set.create ()) in
    let dom = Nod_vec.map blocks ~f:(fun _ -> -1) in
    let ancestor = Nod_vec.map semi ~f:(fun _ -> -1) in
    let label = Nod_vec.map semi ~f:Fn.id in
    let dominance_frontier =
      Nod_vec.map semi ~f:(fun _ -> Int.Hash_set.create ())
    in
    { parent
    ; blocks
    ; bucket
    ; dom
    ; semi
    ; ancestor
    ; label
    ; dominance_frontier
    ; fn_state
    }
  ;;

  let link st v w = Nod_vec.set st.ancestor w v

  let rec compress st v =
    if Nod_vec.get st.ancestor (Nod_vec.get st.ancestor v) <> -1
    then (
      compress st (Nod_vec.get st.ancestor v);
      if Nod_vec.get st.semi (Nod_vec.get st.label (Nod_vec.get st.ancestor v))
         < Nod_vec.get st.semi (Nod_vec.get st.label v)
      then
        Nod_vec.set
          st.label
          v
          (Nod_vec.get st.label (Nod_vec.get st.ancestor v));
      Nod_vec.set
        st.ancestor
        v
        (Nod_vec.get st.ancestor (Nod_vec.get st.ancestor v)))
  ;;

  let eval st v =
    if Nod_vec.get st.ancestor v = -1
    then v
    else (
      compress st v;
      Nod_vec.get st.label v)
  ;;

  let step_2_3 st =
    for i = Nod_vec.length st.blocks - 1 downto 1 do
      let w = Nod_vec.get st.blocks i in
      Nod_vec.iter (Block.parents w) ~f:(fun v ->
        let u = eval st (Block.id_exn v) in
        if Nod_vec.get st.semi u < Nod_vec.get st.semi i
        then Nod_vec.set st.semi i (Nod_vec.get st.semi u));
      Hash_set.add (Nod_vec.get st.bucket (Nod_vec.get st.semi i)) i;
      link st (Nod_vec.get st.parent i) i;
      List.iter
        (Hash_set.to_list (Nod_vec.get st.bucket (Nod_vec.get st.parent i)))
        ~f:(fun v ->
          Hash_set.remove (Nod_vec.get st.bucket (Nod_vec.get st.parent v)) v;
          let u = eval st v in
          Nod_vec.set
            st.dom
            v
            (if Nod_vec.get st.semi u < Nod_vec.get st.semi v
             then u
             else Nod_vec.get st.parent i))
    done;
    st
  ;;

  let step_4 st =
    for i = 1 to Nod_vec.length st.blocks - 1 do
      if Nod_vec.get st.dom i <> Nod_vec.get st.semi i
      then Nod_vec.set st.dom i (Nod_vec.get st.dom (Nod_vec.get st.dom i))
    done;
    Nod_vec.set st.dom 0 0;
    st
  ;;

  let dominance_frontier st =
    Nod_vec.iter st.blocks ~f:(fun block ->
      let b = Block.id_exn block in
      if Nod_vec.length (Block.parents block) >= 2
      then
        Nod_vec.iter (Block.parents block) ~f:(fun p ->
          let runner = ref (Block.id_exn p) in
          while !runner <> Nod_vec.get st.dom b do
            Hash_set.add (Nod_vec.get st.dominance_frontier !runner) b;
            runner := Nod_vec.get st.dom !runner
          done)
      else ());
    st
  ;;

  let create ~fn_state block =
    block |> dfs ~fn_state |> step_2_3 |> step_4 |> dominance_frontier
  ;;
end

let var_of_value (value : Value_state.t) = Value_state.var value

module Def_uses = struct
  type t =
    { dominator : Dominator.t
    ; vars : Typed_var.Hash_set.t
    ; uses : Block.Hash_set.t Typed_var.Table.t
    ; defs : Block.Hash_set.t Typed_var.Table.t
    ; root : Block.t
    }
  [@@deriving fields]

  let fn_state t = Dominator.fn_state t.dominator

  let update_def_uses t ~block =
    let update tbl x =
      Hash_set.add t.vars x;
      Hash_set.add
        (Hashtbl.find_or_add tbl x ~default:Block.Hash_set.create)
        block
    in
    Nod_vec.iter (Block.args block) ~f:(update t.defs);
    Instr_state.iter (Block.instructions block) ~f:(fun instr ->
      let uses = Ir.uses instr.ir |> List.map ~f:var_of_value in
      let defs = Ir.defs instr.ir |> List.map ~f:var_of_value in
      List.iter uses ~f:(update t.uses);
      List.iter defs ~f:(update t.defs))
  ;;

  let calc_def_uses t =
    let seen = Block.Hash_set.create () in
    let rec go block =
      if not (Hash_set.mem seen block)
      then (
        Hash_set.add seen block;
        update_def_uses t ~block;
        Nod_vec.iter (Block.children block) ~f:go)
    in
    go t.root;
    t
  ;;

  let create ~fn_state root =
    let t =
      { dominator = Dominator.create ~fn_state root
      ; vars = Typed_var.Hash_set.create ()
      ; uses = Typed_var.Table.create ()
      ; defs = Typed_var.Table.create ()
      ; root
      }
    in
    t |> calc_def_uses
  ;;

  let df t ~block =
    Nod_vec.get t.dominator.dominance_frontier (Block.id_exn block)
    |> Hash_set.to_list
    |> List.map ~f:(fun i -> Nod_vec.get t.dominator.blocks i)
  ;;
end

type t =
  { def_uses : Def_uses.t
  ; numbers : int String.Table.t
  ; immediate_dominees : Block.Hash_set.t Block.Table.t
  }

let calculate_dominator_tree t =
  let seen = Block.Hash_set.create () in
  let rec go block =
    if Hash_set.mem seen block
    then ()
    else (
      Hash_set.add seen block;
      let idom =
        Nod_vec.get t.def_uses.dominator.dom (Block.id_exn block)
        |> Nod_vec.get t.def_uses.dominator.blocks
      in
      Hash_set.add
        (Hashtbl.find_or_add
           t.immediate_dominees
           idom
           ~default:Block.Hash_set.create)
        block;
      Nod_vec.iter (Block.children block) ~f:go)
  in
  go t.def_uses.root;
  t
;;

let new_name t var =
  let base = String.split (Typed_var.name var) ~on:'%' |> List.hd_exn in
  match Hashtbl.find t.numbers base with
  | None ->
    Hashtbl.set t.numbers ~key:base ~data:0;
    Typed_var.create ~name:base ~type_:(Typed_var.type_ var)
  | Some n ->
    Hashtbl.set t.numbers ~key:base ~data:(n + 1);
    Typed_var.create
      ~name:(base ^ "%" ^ Int.to_string n)
      ~type_:(Typed_var.type_ var)
;;

let insert_args t =
  let def_uses = t.def_uses in
  Hash_set.iter def_uses.vars ~f:(fun var ->
    match Hashtbl.find def_uses.defs var with
    | None -> ()
    | Some defs ->
      List.iter (Hash_set.to_list defs) ~f:(fun d ->
        Def_uses.df def_uses ~block:d
        |> List.iter ~f:(fun block ->
          if not (Nod_vec.mem (Block.args block) var ~compare:Typed_var.compare)
          then
            Fn_state.set_block_args
              (Def_uses.fn_state t.def_uses)
              ~block
              ~args:
                (Nod_vec.of_list (Nod_vec.to_list (Block.args block) @ [ var ]));
          Hash_set.add defs block)));
  t
;;

let fn_state t = Def_uses.fn_state t.def_uses

let add_block_args_value_ir t ir =
  Ir.map_call_blocks ir ~f:(fun { Call_block.block; args = _ } ->
    let args =
      Nod_vec.to_list (Block.args block)
      |> List.map ~f:(fun var -> Fn_state.ensure_value (fn_state t) ~var)
    in
    { Call_block.block; args })
;;

let add_args_to_calls t =
  let rec go block =
    Fn_state.replace_terminal_ir
      (fn_state t)
      ~block
      ~with_:(add_block_args_value_ir t (Block.terminal block).ir);
    Option.iter
      (Hashtbl.find t.immediate_dominees block)
      ~f:
        (Hash_set.iter ~f:(fun block' ->
           if phys_equal block' block then () else go block'))
  in
  go t.def_uses.root;
  t
;;

let uses_in_block_ex_calls ~(block : Block.t) =
  let f (defs, uses) instr =
    let uses =
      Set.union
        uses
        (Set.diff
           (Ir.uses_ex_args instr ~compare_var:Value_state.compare
            |> List.map ~f:var_of_value
            |> Typed_var.Set.of_list)
           defs)
    in
    let defs =
      Set.union
        defs
        (Ir.defs instr |> List.map ~f:var_of_value |> Typed_var.Set.of_list)
    in
    defs, uses
  in
  let acc =
    Instr_state.to_ir_list (Block.instructions block)
    |> List.fold ~init:(Typed_var.Set.empty, Typed_var.Set.empty) ~f
  in
  let _defs, uses = f acc (Block.terminal block).ir in
  uses
;;

let prune_args t =
  let rec go acc block =
    let acc = Set.union (uses_in_block_ex_calls ~block) acc in
    Option.fold
      ~init:acc
      (Hashtbl.find t.immediate_dominees block)
      ~f:(fun init ->
        Hash_set.fold ~init ~f:(fun acc block' ->
          if phys_equal block' block then acc else go acc block'))
  in
  let uses = go Typed_var.Set.empty t.def_uses.root in
  let rec go' block =
    let new_args = Nod_vec.filter (Block.args block) ~f:(Set.mem uses) in
    if Nod_vec.length new_args <> Nod_vec.length (Block.args block)
    then (
      Fn_state.set_block_args (fn_state t) ~block ~args:new_args;
      Nod_vec.iter (Block.parents block) ~f:(fun block' ->
        Fn_state.replace_terminal_ir
          (fn_state t)
          ~block:block'
          ~with_:(add_block_args_value_ir t (Block.terminal block').ir)));
    Option.iter
      (Hashtbl.find t.immediate_dominees block)
      ~f:
        (Hash_set.iter ~f:(fun block' ->
           if phys_equal block' block then () else go' block'))
  in
  go' t.def_uses.root;
  t
;;

let rename t =
  let stacks = ref Typed_var.Map.empty in
  let push_name var renamed_value =
    let stack = Map.find !stacks var |> Option.value ~default:[] in
    stacks := Map.set !stacks ~key:var ~data:(renamed_value :: stack)
  in
  let name value =
    match Map.find !stacks (Value_state.var value) with
    | None | Some [] -> value
    | Some (x :: _) -> x
  in
  let rec go block =
    let replace_use = name in
    let replace_uses instr = Ir.map_uses instr ~f:replace_use in
    let replace_def value =
      let var = Value_state.var value in
      let renamed_var = new_name t var in
      let renamed_value = Fn_state.ensure_value (fn_state t) ~var:renamed_var in
      push_name var renamed_value;
      renamed_value
    in
    let replace_defs instr = Ir.map_defs instr ~f:replace_def in
    let stacks_before = !stacks in
    let replace_arg var =
      let renamed_var = new_name t var in
      let renamed_value = Fn_state.ensure_value (fn_state t) ~var:renamed_var in
      push_name var renamed_value;
      renamed_var
    in
    Fn_state.set_block_args
      (fn_state t)
      ~block
      ~args:(Nod_vec.map (Block.args block) ~f:replace_arg);
    let rec rename_instrs instr =
      match instr with
      | None -> ()
      | Some instr ->
        let next = instr.Instr_state.next in
        let new_ir = instr.Instr_state.ir |> replace_uses |> replace_defs in
        let new_instr = Fn_state.alloc_instr (fn_state t) ~ir:new_ir in
        Fn_state.replace_instr
          (fn_state t)
          ~block
          ~instr
          ~with_instrs:[ new_instr ];
        rename_instrs next
    in
    rename_instrs (Block.instructions block);
    Fn_state.replace_terminal_ir
      (fn_state t)
      ~block
      ~with_:(replace_uses (Block.terminal block).ir);
    Option.iter
      (Hashtbl.find t.immediate_dominees block)
      ~f:
        (Hash_set.iter ~f:(fun block' ->
           if phys_equal block' block then () else go block'));
    stacks := stacks_before
  in
  go t.def_uses.root;
  t
;;

let create_uninit def_uses =
  { def_uses
  ; immediate_dominees = Block.Table.create ()
  ; numbers = String.Table.create ()
  }
;;

let create ~fn_state (~root, ~blocks:_, ~in_order:_) =
  Def_uses.create ~fn_state root
  |> create_uninit
  |> calculate_dominator_tree
  |> insert_args
  |> add_args_to_calls
  |> prune_args
  |> rename
;;

let root t = t.def_uses.root

let convert_program program ~state =
  let functions =
    Map.mapi program.Program.functions ~f:(fun ~key:name ~data:fn ->
      Function.map_root fn ~f:(fun root_data ->
        let ssa = create ~fn_state:(State.fn_state state name) root_data in
        root ssa))
  in
  { program with Program.functions }
;;
