open! Core

(* Literals are represented as integers: positive for variable, negative for negation *)
module Literal = struct
  type t = int [@@deriving sexp, compare, equal, hash]

  let var t = abs t
  let sign t = t > 0
  let negate t = -t
  let of_var ~sign var = if sign then var else -var
end

(* Variable assignment *)
module Assignment = struct
  type t =
    | Unassigned
    | True
    | False
  [@@deriving sexp, compare, equal]

  let of_bool = function
    | true -> True
    | false -> False
  ;;

  let to_bool = function
    | True -> Some true
    | False -> Some false
    | Unassigned -> None
  ;;

  let negate = function
    | True -> False
    | False -> True
    | Unassigned -> Unassigned
  ;;
end

(* Clause representation *)
module Clause = struct
  type t =
    { literals : int array
    ; mutable watched : int * int (* indices of watched literals *)
    }
  [@@deriving sexp]

  let create literals =
    let len = Array.length literals in
    let watched = if len >= 2 then 0, 1 else if len = 1 then 0, 0 else 0, 0 in
    { literals; watched }
  ;;

  let of_array arr = create arr
  let length t = Array.length t.literals
  let is_empty t = length t = 0

  let is_unit t assignments =
    let unassigned = ref None in
    let satisfied = ref false in
    Array.iter t.literals ~f:(fun lit ->
      let var = Literal.var lit in
      let sign = Literal.sign lit in
      match assignments.(var) with
      | Assignment.Unassigned -> unassigned := Some lit
      | Assignment.True when sign -> satisfied := true
      | Assignment.False when not sign -> satisfied := true
      | _ -> ());
    if !satisfied
    then None
    else (
      match !unassigned with
      | Some lit ->
        (* Check if all others are false *)
        let all_others_false =
          Array.for_all t.literals ~f:(fun l ->
            if l = lit
            then true
            else (
              let v = Literal.var l in
              let s = Literal.sign l in
              match assignments.(v) with
              | Assignment.Unassigned -> false
              | Assignment.True -> not s
              | Assignment.False -> s))
        in
        if all_others_false then Some lit else None
      | None -> None)
  ;;

  let is_satisfied t assignments =
    Array.exists t.literals ~f:(fun lit ->
      let var = Literal.var lit in
      let sign = Literal.sign lit in
      match assignments.(var) with
      | Assignment.True when sign -> true
      | Assignment.False when not sign -> true
      | _ -> false)
  ;;

  let is_conflicting t assignments =
    (not (is_satisfied t assignments))
    && Array.for_all t.literals ~f:(fun lit ->
      let var = Literal.var lit in
      let sign = Literal.sign lit in
      match assignments.(var) with
      | Assignment.Unassigned -> false
      | Assignment.True -> not sign
      | Assignment.False -> sign)
  ;;
end

(* Decision level tracking *)
type reason =
  | Decision
  | Propagated of int (* clause index *)
[@@deriving sexp]

type var_info =
  { mutable assignment : Assignment.t
  ; mutable level : int
  ; mutable reason : reason option
  ; mutable activity : float
  }
[@@deriving sexp]

(* Main solver state *)
type t =
  { clauses : Clause.t Vec.t
  ; learned : Clause.t Vec.t
  ; variables : var_info Vec.t
  ; mutable decision_level : int
  ; trail : int Vec.t (* stack of assigned variables *)
  ; trail_lim : int Vec.t (* decision level boundaries in trail *)
  ; var_inc : float ref (* for VSIDS *)
  ; clause_inc : float ref
  }

let create () =
  { clauses = Vec.create ()
  ; learned = Vec.create ()
  ; variables = Vec.create ()
  ; decision_level = 0
  ; trail = Vec.create ()
  ; trail_lim = Vec.create ()
  ; var_inc = ref 1.0
  ; clause_inc = ref 1.0
  }
;;

let num_vars t = Vec.length t.variables

let ensure_var t var =
  while num_vars t <= var do
    Vec.push
      t.variables
      { assignment = Unassigned; level = -1; reason = None; activity = 0.0 }
  done
;;

let add_clause t literals =
  (* Ensure all variables exist *)
  Array.iter literals ~f:(fun lit -> ensure_var t (Literal.var lit));
  let clause = Clause.of_array literals in
  Vec.push t.clauses clause
;;

let create_with_problem clauses =
  let t = create () in
  Array.iter clauses ~f:(fun clause_arr -> add_clause t clause_arr);
  t
;;

(* Assignment operations *)
let assign t var value level reason =
  let info = Vec.get t.variables var in
  info.assignment <- Assignment.of_bool value;
  info.level <- level;
  info.reason <- Some reason;
  Vec.push t.trail var
;;

let unassign t var =
  let info = Vec.get t.variables var in
  info.assignment <- Unassigned;
  info.level <- -1;
  info.reason <- None
;;

let get_assignment t var =
  if var < num_vars t then (Vec.get t.variables var).assignment else Unassigned
;;

let assignments_array t =
  let arr = Array.create ~len:(num_vars t) Assignment.Unassigned in
  for i = 0 to num_vars t - 1 do
    arr.(i) <- (Vec.get t.variables i).assignment
  done;
  arr
;;

(* Evaluate a literal under current assignment *)
let eval_literal t lit =
  let var = Literal.var lit in
  let sign = Literal.sign lit in
  match get_assignment t var with
  | Assignment.Unassigned -> None
  | Assignment.True -> Some sign
  | Assignment.False -> Some (not sign)
;;

(* Boolean Constraint Propagation *)
let propagate t =
  let rec fixpoint () =
    let old_trail_len = Vec.length t.trail in
    let assignments = assignments_array t in
    let conflict = ref None in
    let check_clauses clauses offset =
      Vec.iteri clauses ~f:(fun clause_idx clause ->
        let is_sat = Clause.is_satisfied clause assignments in
        if Option.is_none !conflict && not is_sat
        then (
          let unit_result = Clause.is_unit clause assignments in
          match unit_result with
          | Some unit_lit ->
            let unit_var = Literal.var unit_lit in
            let unit_sign = Literal.sign unit_lit in
            (match get_assignment t unit_var with
             | Assignment.Unassigned ->
               assign
                 t
                 unit_var
                 unit_sign
                 t.decision_level
                 (Propagated (offset + clause_idx));
               (* Bump activity *)
               let info = Vec.get t.variables unit_var in
               info.activity <- info.activity +. !(t.var_inc)
             | Assignment.True when not unit_sign ->
               conflict := Some (offset + clause_idx)
             | Assignment.False when unit_sign ->
               conflict := Some (offset + clause_idx)
             | _ -> ())
          | None ->
            if Clause.is_conflicting clause assignments
            then conflict := Some (offset + clause_idx)))
    in
    check_clauses t.clauses 0;
    if Option.is_none !conflict
    then check_clauses t.learned (Vec.length t.clauses);
    match !conflict with
    | Some _ as c -> c
    | None ->
      let new_trail_len = Vec.length t.trail in
      (* If we assigned new variables, need to propagate again *)
      if new_trail_len > old_trail_len then fixpoint () else None
  in
  fixpoint ()
;;

(* Conflict analysis *)
let analyze_conflict t conflict_clause_idx =
  (* Simple conflict analysis: just return the conflict clause *)
  let clause =
    if conflict_clause_idx < Vec.length t.clauses
    then Vec.get t.clauses conflict_clause_idx
    else Vec.get t.learned (conflict_clause_idx - Vec.length t.clauses)
  in
  (* Find the decision level to backtrack to *)
  let max_level = ref 0 in
  Array.iter clause.literals ~f:(fun lit ->
    let var = Literal.var lit in
    let info = Vec.get t.variables var in
    if info.level > 0 && info.level < t.decision_level
    then max_level := Int.max !max_level info.level);
  (* Return backtrack level and learned clause (just use conflict for now) *)
  !max_level, Array.copy clause.literals
;;

(* Backtrack to a given decision level *)
let backtrack t level =
  (* Unassign all variables assigned after this level *)
  let rec unassign_loop () =
    if Vec.length t.trail > 0
    then (
      let last_idx = Vec.length t.trail - 1 in
      let var = Vec.get t.trail last_idx in
      let info = Vec.get t.variables var in
      if info.level > level
      then (
        unassign t var;
        Vec.pop_exn t.trail |> ignore;
        unassign_loop ()))
  in
  unassign_loop ();
  (* Adjust decision level *)
  t.decision_level <- level;
  (* Adjust trail limits *)
  let rec trim_trail_lim () =
    if Vec.length t.trail_lim > level
    then (
      Vec.pop_exn t.trail_lim |> ignore;
      trim_trail_lim ())
  in
  trim_trail_lim ()
;;

(* Variable selection using VSIDS *)
let select_variable t =
  let best = ref None in
  let best_activity = ref Float.neg_infinity in
  for i = 1 to num_vars t - 1 do
    let info = Vec.get t.variables i in
    match info.assignment with
    | Assignment.Unassigned ->
      if Float.(info.activity > !best_activity)
      then (
        best := Some i;
        best_activity := info.activity)
    | _ -> ()
  done;
  !best
;;

(* Decay variable activities *)
let decay_activities t = t.var_inc := !(t.var_inc) *. 1.05

(* Main CDCL search *)
type sat_result =
  | Sat of (int * bool) list
  | UnsatCore of int array

let run t =
  (* Check for empty clause (immediate UNSAT) *)
  let has_empty_clause () =
    let result = ref false in
    Vec.iter t.clauses ~f:(fun clause ->
      if Clause.is_empty clause then result := true);
    if not !result
    then
      Vec.iter t.learned ~f:(fun clause ->
        if Clause.is_empty clause then result := true);
    !result
  in
  if has_empty_clause ()
  then UnsatCore [||]
  else (
    let rec search () =
      (* Propagate *)
      match propagate t with
      | Some conflict_idx ->
        (* Conflict *)
        if t.decision_level = 0
        then (
          (* UNSAT at level 0 *)
          let clause =
            if conflict_idx < Vec.length t.clauses
            then Vec.get t.clauses conflict_idx
            else Vec.get t.learned (conflict_idx - Vec.length t.clauses)
          in
          UnsatCore (Array.map clause.literals ~f:Literal.var))
        else (
          (* Analyze conflict and backtrack *)
          let backtrack_level, learned_clause =
            analyze_conflict t conflict_idx
          in
          Vec.push t.learned (Clause.of_array learned_clause);
          backtrack t backtrack_level;
          decay_activities t;
          search ())
      | None ->
        (* No conflict, check if all variables are assigned *)
        let all_assigned () =
          let result = ref true in
          (* Skip variable 0, it's just a placeholder *)
          for i = 1 to num_vars t - 1 do
            let info = Vec.get t.variables i in
            match info.assignment with
            | Assignment.Unassigned -> result := false
            | _ -> ()
          done;
          !result
        in
        if all_assigned ()
        then (
          (* SAT - extract model *)
          let model = ref [] in
          for i = 1 to num_vars t - 1 do
            let info = Vec.get t.variables i in
            match info.assignment with
            | Assignment.True -> model := (i, true) :: !model
            | Assignment.False -> model := (i, false) :: !model
            | Assignment.Unassigned -> ()
          done;
          Sat (List.rev !model))
        else (
          (* Make a decision *)
          match select_variable t with
          | None -> Sat [] (* No variables to assign *)
          | Some var ->
            t.decision_level <- t.decision_level + 1;
            Vec.push t.trail_lim (Vec.length t.trail);
            assign t var true t.decision_level Decision;
            search ())
    in
    search ())
;;

(* Bitset type - using the pror bitset implementation *)
type bitset = Pror.bitset
