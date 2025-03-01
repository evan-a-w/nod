open! Core

module Make (Params : Parameters.S) = struct
  include Params

  module Block = struct
    module T = struct
      type t =
        { args : string Vec.t
        ; parents : t Vec.t
        ; children : t Vec.t
        ; mutable instructions : Instr.t Vec.t
        ; mutable terminal : Instr.t
        ; mutable dfs_id : int option
        }

      let compare t1 t2 =
        Option.value_exn t1.dfs_id - Option.value_exn t2.dfs_id
      ;;

      let hash_fold_t s t = Int.hash_fold_t s (Option.value_exn t.dfs_id)
      let hash t = Int.hash (Option.value_exn t.dfs_id)
      let t_of_sexp _ = failwith ":()"
      let sexp_of_t t = Sexp.Atom (Int.to_string (Option.value_exn t.dfs_id))
    end

    include T
    include Comparable.Make (T)
    include Hashable.Make (T)
  end

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
      Vec.iter block.Block.instructions ~f:(fun instr ->
        let uses = Instr.uses instr in
        let defs = Instr.defs instr in
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
          Vec.iter block.Block.children ~f:go)
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
      Vec.get
        t.dominator.dominance_frontier
        (Option.value_exn block.Block.dfs_id)
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

  module Ssa = struct
    let insert_args (def_uses : Def_uses.t) =
      Hash_set.iter def_uses.vars ~f:(fun var ->
        match Hashtbl.find def_uses.defs var with
        | None -> ()
        | Some defs ->
          List.iter (Hash_set.to_list defs) ~f:(fun d ->
            Def_uses.df def_uses ~block:d
            |> List.iter ~f:(fun block ->
              if not (Vec.mem block.args var ~compare:String.compare)
              then Vec.push block.args var;
              Hash_set.add defs block)))
    ;;

    let rename (def_uses : Def_uses.t) ~root =
      let stack = String.Table.create () in
      let rec rename block =
        block.Block.instructions
        <- Vec.map block.Block.instructions ~f:(fun instr ->
             let instr =
               Instr.map_uses instr ~f:(fun s ->
                 Hashtbl.find stack s
                 |> Option.map ~f:Stack.top_exn
                 |> Option.value ~default:s)
             in
             let instr =
               Instr.map_defs instr ~f:(fun s ->
                 let new_name = Def_uses.uniq_name def_uses s in
                 let stack =
                   Hashtbl.find_or_add stack s ~default:Stack.create
                 in
                 Stack.push stack new_name;
                 new_name)
             in
             instr)
      in
      rename root
    ;;
  end
end
