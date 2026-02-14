open! Core
open! Import

module Dominance = struct
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

  let fn_state t = t.fn_state

  let frontier_blocks t ~block =
    Nod_vec.get t.dominance_frontier (Block.id_exn block)
    |> Hash_set.to_list
    |> List.map ~f:(fun idx -> Nod_vec.get t.blocks idx)
  ;;

  let idom_tree t =
    let table = Block.Table.create () in
    let seen = Block.Hash_set.create () in
    let rec go block =
      if Hash_set.mem seen block
      then ()
      else (
        Hash_set.add seen block;
        let idom =
          Nod_vec.get t.dom (Block.id_exn block) |> Nod_vec.get t.blocks
        in
        Hash_set.add
          (Hashtbl.find_or_add table idom ~default:Block.Hash_set.create)
          block;
        Nod_vec.iter (Block.children block) ~f:go)
    in
    go (Nod_vec.get t.blocks 0);
    table
  ;;
end

module Def_use = struct
  type t =
    { dominance : Dominance.t
    ; vars : Typed_var.Hash_set.t
    ; uses : Block.Hash_set.t Typed_var.Table.t
    ; defs : Block.Hash_set.t Typed_var.Table.t
    ; root : Block.t
    }
  [@@deriving fields]

  let fn_state t = Dominance.fn_state t.dominance
  let root t = t.root
  let vars t = t.vars
  let defs t = t.defs
  let uses t = t.uses
  let dominance t = t.dominance
  let var_of_value (value : Value_state.t) = Value_state.var value

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
      { dominance = Dominance.create ~fn_state root
      ; vars = Typed_var.Hash_set.create ()
      ; uses = Typed_var.Table.create ()
      ; defs = Typed_var.Table.create ()
      ; root
      }
    in
    t |> calc_def_uses
  ;;

  let df t ~block = Dominance.frontier_blocks t.dominance ~block
end
