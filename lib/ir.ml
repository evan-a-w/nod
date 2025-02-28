open! Core

module Make (Params : Parameters.S) = struct
  include Params

  module Block = struct
    type t =
      { parents : t Vec.t
      ; children : t Vec.t
      ; instructions : Instr.t Vec.t
      ; mutable terminal : Instr.t
      ; mutable dfs_id : int option
      }
  end

  module Dominator = struct
    type st =
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
        match block.Block.dfs_id with
        | None ->
          block.Block.dfs_id <- Some !i;
          Vec.push semi !i;
          incr i;
          Vec.push blocks block;
          Vec.iter block.Block.children ~f:(fun b ->
            go b;
            Vec.fill_to_length
              parent
              ~length:(Option.value_exn b.Block.dfs_id + 1)
              ~f:(fun _ -> -1);
            Vec.set
              parent
              (Option.value_exn b.Block.dfs_id)
              (Option.value_exn block.Block.dfs_id))
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
        Vec.iter w.Block.parents ~f:(fun v ->
          let u = eval st (Option.value_exn v.Block.dfs_id) in
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
        let b = Option.value_exn block.Block.dfs_id in
        if Vec.length block.Block.parents >= 2
        then
          Vec.iter block.parents ~f:(fun p ->
            let runner = ref (Option.value_exn p.Block.dfs_id) in
            while !runner <> Vec.get st.dom b do
              Hash_set.add (Vec.get st.dominance_frontier !runner) b;
              runner := Vec.get st.dom !runner
            done)
        else ());
      st
    ;;

    let run block = block |> dfs |> step_2_3 |> step_4 |> dominance_frontier
  end
end
