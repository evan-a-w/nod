open! Core
open! Import
open! Common

type t =
  { to_restore : Reg.Set.t
  ; clobbers : Reg.Set.t
  }

let calc_edges (functions : Function.t String.Map.t) =
  let edges = String.Table.create () in
  let defs = String.Table.create () in
  let uses_fn fn1 fn2 =
    let edges = Hashtbl.find_or_add edges fn1 ~default:String.Hash_set.create in
    Hash_set.add edges fn2
  in
  Map.iter functions ~f:(fun function_ ->
    let this_defs = ref Reg.Set.empty in
    Hashtbl.add_exn edges ~key:function_.name ~data:(String.Hash_set.create ());
    Block.iter_instructions function_.root ~f:(fun ir ->
      this_defs := Set.union !this_defs (Ir.x86_reg_defs ir |> Reg.Set.of_list);
      on_x86_irs ir ~f:(fun x86_ir ->
        match x86_ir with
        | CALL { fn; results = _; args = _ } -> uses_fn function_.name fn
        | _ -> ()));
    Hashtbl.add_exn defs ~key:function_.name ~data:!this_defs);
  ~edges, ~defs
;;

let init_state (functions : Function.t String.Map.t) : t String.Map.t =
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
          (Reg.callee_saved ~call_conv:fn.call_conv));
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
      Set.diff new_clobbers_raw (Reg.callee_saved ~call_conv:fn.call_conv)
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
