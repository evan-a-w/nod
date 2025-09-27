open! Core

module Dominator = struct
  type t =
    { parent : int Vec.t
    ; semi : int Vec.t
    ; blocks : Block.t Vec.t
    ; bucket : Int.Hash_set.t Vec.t
    ; dom : int Vec.t
    ; ancestor : int Vec.t
    ; label : int Vec.t
    ; dominance_frontier : Int.Hash_set.t Vec.t
    }

  let dfs block =
    let blocks = Vec.create () in
    let parent = Vec.create () in
    let semi = Vec.create () in
    let i = ref 0 in
    let rec go block =
      match Block.dfs_id block with
      | None ->
        Block.set_dfs_id block (Some !i);
        Vec.push semi !i;
        incr i;
        Vec.push blocks block;
        Vec.iter (Block.children block) ~f:(fun b ->
          go b;
          Vec.fill_to_length
            parent
            ~length:(Block.id_exn b + 1)
            ~f:(fun _ -> -1);
          Vec.set parent (Block.id_exn b) (Block.id_exn block))
      | Some _ -> ()
    in
    go block;
    let bucket = Vec.map blocks ~f:(fun _ -> Int.Hash_set.create ()) in
    let dom = Vec.map blocks ~f:(fun _ -> -1) in
    let ancestor = Vec.map semi ~f:(fun _ -> -1) in
    let label = Vec.map semi ~f:Fn.id in
    let dominance_frontier =
      Vec.map semi ~f:(fun _ -> Int.Hash_set.create ())
    in
    { parent; blocks; bucket; dom; semi; ancestor; label; dominance_frontier }
  ;;

  let link st v w = Vec.set st.ancestor w v

  let rec compress st v =
    if Vec.get st.ancestor (Vec.get st.ancestor v) <> -1
    then (
      compress st (Vec.get st.ancestor v);
      if Vec.get st.semi (Vec.get st.label (Vec.get st.ancestor v))
         < Vec.get st.semi (Vec.get st.label v)
      then Vec.set st.label v (Vec.get st.label (Vec.get st.ancestor v));
      Vec.set st.ancestor v (Vec.get st.ancestor (Vec.get st.ancestor v)))
  ;;

  let eval st v =
    if Vec.get st.ancestor v = -1
    then v
    else (
      compress st v;
      Vec.get st.label v)
  ;;

  let step_2_3 st =
    for i = Vec.length st.blocks - 1 downto 1 do
      let w = Vec.get st.blocks i in
      Vec.iter (Block.parents w) ~f:(fun v ->
        let u = eval st (Block.id_exn v) in
        if Vec.get st.semi u < Vec.get st.semi i
        then Vec.set st.semi i (Vec.get st.semi u));
      Hash_set.add (Vec.get st.bucket (Vec.get st.semi i)) i;
      link st (Vec.get st.parent i) i;
      List.iter
        (Hash_set.to_list (Vec.get st.bucket (Vec.get st.parent i)))
        ~f:(fun v ->
          Hash_set.remove (Vec.get st.bucket (Vec.get st.parent v)) v;
          let u = eval st v in
          Vec.set
            st.dom
            v
            (if Vec.get st.semi u < Vec.get st.semi v
             then u
             else Vec.get st.parent i))
    done;
    st
  ;;

  let step_4 st =
    for i = 1 to Vec.length st.blocks - 1 do
      if Vec.get st.dom i <> Vec.get st.semi i
      then Vec.set st.dom i (Vec.get st.dom (Vec.get st.dom i))
    done;
    Vec.set st.dom 0 0;
    st
  ;;

  let dominance_frontier st =
    Vec.iter st.blocks ~f:(fun block ->
      let b = Block.id_exn block in
      if Vec.length (Block.parents block) >= 2
      then
        Vec.iter block.parents ~f:(fun p ->
          let runner = ref (Block.id_exn p) in
          while !runner <> Vec.get st.dom b do
            Hash_set.add (Vec.get st.dominance_frontier !runner) b;
            runner := Vec.get st.dom !runner
          done)
      else ());
    st
  ;;

  let create block = block |> dfs |> step_2_3 |> step_4 |> dominance_frontier
end

module Def_uses = struct
  type t =
    { dominator : Dominator.t
    ; vars : String.Hash_set.t
    ; uses : Block.Hash_set.t String.Table.t
    ; defs : Block.Hash_set.t String.Table.t
    ; root : Block.t
    }
  [@@deriving fields]

  let update_def_uses t ~block =
    Vec.iter (Block.instructions block) ~f:(fun instr ->
      let uses = Ir.uses instr in
      let defs = Ir.defs instr in
      let update tbl x =
        Hash_set.add t.vars x;
        Hash_set.add
          (Hashtbl.find_or_add tbl x ~default:Block.Hash_set.create)
          block
      in
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
        Vec.iter (Block.children block) ~f:go)
    in
    go t.root;
    t
  ;;

  let create root =
    let t =
      { dominator = Dominator.create root
      ; vars = String.Hash_set.create ()
      ; uses = String.Table.create ()
      ; defs = String.Table.create ()
      ; root
      }
    in
    t |> calc_def_uses
  ;;

  let df t ~block =
    Vec.get t.dominator.dominance_frontier (Block.id_exn block)
    |> Hash_set.to_list
    |> List.map ~f:(fun i -> Vec.get t.dominator.blocks i)
  ;;

  let rec uniq_name t name =
    if not (Hash_set.mem t.vars name)
    then (
      Hash_set.add t.vars name;
      name)
    else (
      let no_number = String.rstrip name ~drop:(fun c -> Char.is_digit c) in
      let number = String.chop_prefix_exn name ~prefix:no_number in
      if String.equal number ""
      then uniq_name t (name ^ "1")
      else uniq_name t (no_number ^ Int.to_string (Int.of_string number + 1)))
  ;;
end

type t =
  { reaching_def : string String.Table.t
  ; definition : Block.t String.Table.t
  ; in_order : Block.t Vec.t
  ; def_uses : Def_uses.t
  ; numbers : int String.Table.t
  ; immediate_dominees : Block.Hash_set.t Block.Table.t
  ; dominate_queries : bool Block.Pair.Table.t
  }

let calculate_dominator_tree t =
  let seen = Block.Hash_set.create () in
  let rec go block =
    if Hash_set.mem seen block
    then ()
    else (
      Hash_set.add seen block;
      let idom =
        Vec.get t.def_uses.dominator.dom (Block.id_exn block)
        |> Vec.get t.def_uses.dominator.blocks
      in
      Hash_set.add
        (Hashtbl.find_or_add
           t.immediate_dominees
           idom
           ~default:Block.Hash_set.create)
        block;
      Vec.iter (Block.children block) ~f:go)
  in
  go t.def_uses.root;
  t
;;

let rec dominates t block1 block2 =
  (* print_s [%message "dominates" block1.Block.id_hum block2.Block.id_hum]; *)
  if phys_equal block1 block2
     || Hashtbl.find t.immediate_dominees block1
        |> Option.map ~f:(fun set -> Hash_set.mem set block2)
        |> Option.value ~default:false
  then true
  else (
    match Hashtbl.find t.dominate_queries (block1, block2) with
    | Some res -> res
    | None ->
      (* set to false so dfs doesn't loop *)
      Hashtbl.set t.dominate_queries ~key:(block1, block2) ~data:false;
      let res =
        Hashtbl.find t.immediate_dominees block1
        |> Option.value ~default:(Block.Hash_set.create ~size:0 ())
        |> Hash_set.exists ~f:(fun block -> dominates t block block2)
      in
      Hashtbl.set t.dominate_queries ~key:(block1, block2) ~data:res;
      res)
;;

let new_name t v =
  let v = String.split v ~on:'%' |> List.hd_exn in
  match Hashtbl.find t.numbers v with
  | None ->
    Hashtbl.set t.numbers ~key:v ~data:0;
    v
  | Some n ->
    Hashtbl.set t.numbers ~key:v ~data:(n + 1);
    v ^ "%" ^ Int.to_string n
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
          if not (Vec.mem block.args var ~compare:String.compare)
          then Vec.push block.args var;
          Hash_set.add defs block)));
  t
;;

let add_args_to_calls t =
  let rec go block =
    Block.set_terminal block (Block.terminal block |> Ir.add_block_args);
    Option.iter
      (Hashtbl.find t.immediate_dominees block)
      ~f:
        (Hash_set.iter ~f:(fun block' ->
           if phys_equal block' block then () else go block'))
  in
  go t.def_uses.root;
  t
;;

let uses_in_block_ex_calls ~block =
  let f (defs, uses) instr =
    let uses = Set.union uses (Set.diff (Ir.uses_ex_args instr) defs) in
    let defs =
      Set.union defs (Ir.def instr |> Option.to_list |> String.Set.of_list)
    in
    defs, uses
  in
  let acc =
    Vec.fold
      block.Block.instructions
      ~init:(String.Set.empty, String.Set.empty)
      ~f
  in
  let _defs, uses = f acc block.terminal in
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
  let uses = go String.Set.empty t.def_uses.root in
  let rec go' block =
    let pre_len = Vec.length block.Block.args in
    Vec.filter_inplace block.args ~f:(Set.mem uses);
    if Vec.length block.args <> pre_len
    then
      Vec.iter block.parents ~f:(fun block' ->
        Block.set_terminal block' (Block.terminal block' |> Ir.add_block_args));
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
  let stacks = ref String.Map.empty in
  let push_name v v' =
    let stack = Map.find !stacks v |> Option.value ~default:[] in
    stacks := Map.set !stacks ~key:v ~data:(v' :: stack)
  in
  let name v =
    match Map.find !stacks v with
    | None | Some [] -> v
    | Some (x :: _) -> x
  in
  let rec go block =
    let replace_use = name in
    let replace_uses instr = Ir.map_uses instr ~f:replace_use in
    let replace_def v =
      let v' = new_name t v in
      push_name v v';
      v'
    in
    let replace_defs instr = Ir.map_defs instr ~f:replace_def in
    let stacks_before = !stacks in
    block.Block.args <- Vec.map block.Block.args ~f:replace_def;
    block.Block.instructions
    <- Vec.map block.instructions ~f:(fun instr ->
         instr |> replace_uses |> replace_defs);
    Block.terminal block |> replace_uses |> Block.set_terminal block;
    Vec.iter block.Block.children ~f:(fun block' ->
      block'.args <- Vec.map block'.args ~f:replace_use);
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

let create_uninit ~in_order def_uses =
  { def_uses
  ; in_order
  ; immediate_dominees = Block.Table.create ()
  ; reaching_def = String.Table.create ()
  ; definition = String.Table.create ()
  ; numbers = String.Table.create ()
  ; dominate_queries = Block.Pair.Table.create ()
  }
;;

let set_defs t =
  let rec go block =
    Vec.iter block.Block.instructions ~f:(fun instr ->
      Option.iter (Ir.def instr) ~f:(fun key ->
        Hashtbl.set t.definition ~key ~data:block));
    Option.iter
      (Hashtbl.find t.immediate_dominees block)
      ~f:
        (Hash_set.iter ~f:(fun block' ->
           if phys_equal block' block then () else go block'))
  in
  go t.def_uses.root;
  t
;;

let create (root, _block_by_label, in_order) =
  Def_uses.create root
  |> create_uninit ~in_order
  |> calculate_dominator_tree
  |> insert_args
  |> add_args_to_calls
  |> prune_args
  (* |> set_defs *)
  |> rename
;;

let root t = t.def_uses.root
