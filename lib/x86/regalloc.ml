open Core
open Ir

(* Fixed set of x86-64 registers to allocate *)
let phys_regs =
  [ "rax"
  ; "rbx"
  ; "rcx"
  ; "rdx"
  ; "rsi"
  ; "rdi"
  ; "rbp"
  ; "rsp"
  ; "r8"
  ; "r9"
  ; "r10"
  ; "r11"
  ; "r12"
  ; "r13"
  ; "r14"
  ; "r15"
  ]
;;

type loc =
  | Reg of string
  | Spill of int

type var_interval =
  { var : Var.t
  ; start : int
  ; end_ : int
  }

(** Compute live intervals for each variable. **)
let compute_intervals instrs =
  let first_def = Hashtbl.Poly.create () in
  let last_use = Hashtbl.Poly.create () in
  List.iteri instrs ~f:(fun idx instr ->
    Option.iter (T.def instr) ~f:(fun v ->
      Hashtbl.set
        first_def
        ~key:v
        ~data:(Hashtbl.find_or_add first_def v ~default:(fun () -> idx)));
    List.iter (T.uses instr) ~f:(fun v -> Hashtbl.set last_use ~key:v ~data:idx));
  Hashtbl.keys first_def
  |> List.map ~f:(fun v ->
    let s = Hashtbl.find_exn first_def v in
    let e = Hashtbl.find_or_add last_use v ~default:(fun () -> s) in
    { var = v; start = s; end_ = e })
;;

(** Linear scan register allocation on intervals. **)
let linear_scan intervals =
  let active = ref [] in
  let loc_map = Hashtbl.Poly.create () in
  let spill_count = ref 0 in
  let expire_old current =
    active := List.filter !active ~f:(fun iv -> iv.end_ > current.start)
  in
  let allocate iv =
    expire_old iv;
    let used =
      List.filter !active ~f:(fun iv ->
        match Hashtbl.find_exn loc_map iv.var with
        | Reg _ -> true
        | Spill _ -> false)
      |> List.map ~f:(fun iv ->
        match Hashtbl.find_exn loc_map iv.var with
        | Reg r -> r
        | _ -> assert false)
    in
    match
      List.find phys_regs ~f:(fun r ->
        not (List.mem used r ~equal:String.equal))
    with
    | Some r ->
      Hashtbl.set loc_map ~key:iv.var ~data:(Reg r);
      active := iv :: !active
    | None ->
      (* Spill the interval with the farthest end or this one *)
      let spill_candidate =
        List.max_elt !active ~compare:(fun a b -> Int.compare a.end_ b.end_)
        |> Option.value_exn
      in
      if spill_candidate.end_ > iv.end_
      then (
        (* spill candidate *)
        Hashtbl.set
          loc_map
          ~key:spill_candidate.var
          ~data:
            (Spill
               (incr spill_count;
                !spill_count));
        Hashtbl.set
          loc_map
          ~key:iv.var
          ~data:
            (Reg
               (match
                  List.find phys_regs ~f:(fun r ->
                    not (List.mem used r ~equal:String.equal))
                with
                | Some r -> r
                | None -> assert false));
        active
        := iv
           :: List.filter !active ~f:(fun x ->
             not (Var.equal x.var spill_candidate.var)))
      else
        (* spill this interval *)
        Hashtbl.set
          loc_map
          ~key:iv.var
          ~data:
            (Spill
               (incr spill_count;
                !spill_count))
  in
  List.sort intervals ~compare:(fun a b -> Int.compare a.start b.start)
  |> List.iter ~f:allocate;
  loc_map, !spill_count
;;

(** Rewrite instructions: insert loads/stores for spilled vars and rename regs. **)
let rewrite instrs =
  let intervals = compute_intervals instrs in
  let loc_map, _ = linear_scan intervals in
  let new_instrs = ref [] in
  List.iter instrs ~f:(fun instr ->
    let renames = Hashtbl.Poly.create () in
    (* Insert loads for each use if spilled *)
    List.iter (T.uses instr) ~f:(fun v ->
      match Hashtbl.find_exn loc_map v with
      | Spill slot ->
        let tmp = sprintf "spill_%d_tmp" slot in
        Hashtbl.set renames ~key:v ~data:tmp;
        new_instrs := !new_instrs @ [ Load (tmp, Mem.Stack_slot slot) ]
      | Reg _ -> ());
    (* Rewrite the instruction *)
    let instr' =
      instr
      |> T.map_uses ~f:(fun v ->
        match Hashtbl.find renames v with
        | Some tmp -> tmp
        | None ->
          (match Hashtbl.find_exn loc_map v with
           | Reg r -> r
           | Spill slot -> sprintf "spill_%d_tmp" slot))
      |> T.map_defs ~f:(fun v ->
        match Hashtbl.find_exn loc_map v with
        | Reg r -> r
        | Spill slot ->
          let tmp = sprintf "spill_%d_tmp" slot in
          Hashtbl.set renames ~key:v ~data:tmp;
          tmp)
    in
    new_instrs := !new_instrs @ [ instr' ];
    (* Insert stores for each def if spilled *)
    Option.iter (T.def instr) ~f:(fun v ->
      match Hashtbl.find_exn loc_map v with
      | Spill slot ->
        let tmp = Hashtbl.find_exn renames v in
        new_instrs
        := !new_instrs @ [ Store (Lit_or_var.Var tmp, Mem.Stack_slot slot) ]
      | Reg _ -> ()));
  !new_instrs
;;

let allocate instrs = rewrite instrs
