open! Core

let test_case name f =
  printf "Testing %s... " name;
  try
    f ();
    print_endline "✓"
  with
  | e ->
    print_endline "✗";
    printf "  Error: %s\n" (Exn.to_string e);
    raise e
;;

let () =
  print_endline "\n=== Testing OSAT CDCL SAT Solver ===\n";
  (* Test 1: Empty problem (should be SAT) *)
  test_case "empty problem" (fun () ->
    let t = Osat.create () in
    match Osat.run t with
    | Sat model ->
      assert (List.length model = 0);
      printf "  Result: SAT with empty model\n"
    | UnsatCore _ -> failwith "Expected SAT, got UNSAT");
  (* Test 2: Single unit clause (x1) - should be SAT with x1=true *)
  test_case "single unit clause" (fun () ->
    let t = Osat.create_with_problem [| [| 1 |] |] in
    match Osat.run t with
    | Sat model ->
      printf "  Model: ";
      List.iter model ~f:(fun (var, value) -> printf "%d=%b " var value);
      print_endline "";
      let value = List.Assoc.find_exn model ~equal:Int.equal 1 in
      assert value
    | UnsatCore _ -> failwith "Expected SAT, got UNSAT");
  (* Test 3: Simple UNSAT (x1) ∧ (¬x1) *)
  test_case "simple UNSAT" (fun () ->
    let t = Osat.create_with_problem [| [| 1 |]; [| -1 |] |] in
    match Osat.run t with
    | Sat _ -> failwith "Expected UNSAT, got SAT"
    | UnsatCore core ->
      printf "  UNSAT core: ";
      Array.iter core ~f:(fun var -> printf "%d " var);
      print_endline "");
  (* Test 4: Simple SAT (x1 ∨ x2) ∧ (¬x1 ∨ x3) ∧ (¬x2 ∨ ¬x3) *)
  test_case "simple SAT problem" (fun () ->
    let t =
      Osat.create_with_problem [| [| 1; 2 |]; [| -1; 3 |]; [| -2; -3 |] |]
    in
    match Osat.run t with
    | Sat model ->
      printf "  Model: ";
      List.iter model ~f:(fun (var, value) -> printf "%d=%b " var value);
      print_endline "";
      (* Verify the model satisfies all clauses *)
      let get_val var = List.Assoc.find_exn model ~equal:Int.equal var in
      (* Clause 1: x1 ∨ x2 *)
      assert (get_val 1 || get_val 2);
      (* Clause 2: ¬x1 ∨ x3 *)
      assert ((not (get_val 1)) || get_val 3);
      (* Clause 3: ¬x2 ∨ ¬x3 *)
      assert ((not (get_val 2)) || not (get_val 3))
    | UnsatCore _ -> failwith "Expected SAT, got UNSAT");
  (* Test 5: Unit propagation chain (x1) ∧ (¬x1 ∨ x2) ∧ (¬x2 ∨ x3) *)
  test_case "unit propagation chain" (fun () ->
    let t = Osat.create_with_problem [| [| 1 |]; [| -1; 2 |]; [| -2; 3 |] |] in
    match Osat.run t with
    | Sat model ->
      printf "  Model: ";
      List.iter model ~f:(fun (var, value) -> printf "%d=%b " var value);
      print_endline "";
      let get_val var = List.Assoc.find_exn model ~equal:Int.equal var in
      (* All should be true due to unit propagation *)
      assert (get_val 1);
      assert (get_val 2);
      assert (get_val 3)
    | UnsatCore _ -> failwith "Expected SAT, got UNSAT");
  (* Test 6: At-most-one constraint (x1 ∨ x2 ∨ x3) ∧ (¬x1 ∨ ¬x2) ∧ (¬x1 ∨ ¬x3) ∧ (¬x2 ∨ ¬x3) *)
  test_case "at-most-one constraint" (fun () ->
    let t =
      Osat.create_with_problem
        [| [| 1; 2; 3 |]; [| -1; -2 |]; [| -1; -3 |]; [| -2; -3 |] |]
    in
    match Osat.run t with
    | Sat model ->
      printf "  Model: ";
      List.iter model ~f:(fun (var, value) -> printf "%d=%b " var value);
      print_endline "";
      let get_val var = List.Assoc.find_exn model ~equal:Int.equal var in
      (* Exactly one should be true *)
      let count = List.count [ 1; 2; 3 ] ~f:(fun v -> get_val v) in
      assert (count = 1)
    | UnsatCore _ -> failwith "Expected SAT, got UNSAT");
  (* Test 7: Four-way UNSAT (x1 ∨ x2) ∧ (¬x1 ∨ x2) ∧ (x1 ∨ ¬x2) ∧ (¬x1 ∨ ¬x2) *)
  test_case "four-way UNSAT" (fun () ->
    let t =
      Osat.create_with_problem
        [| [| 1; 2 |]; [| -1; 2 |]; [| 1; -2 |]; [| -1; -2 |] |]
    in
    match Osat.run t with
    | Sat _ -> failwith "Expected UNSAT, got SAT"
    | UnsatCore core ->
      printf "  UNSAT core: ";
      Array.iter core ~f:(fun var -> printf "%d " var);
      print_endline "");
  (* Test 8: Larger SAT problem *)
  test_case "larger SAT problem" (fun () ->
    let t =
      Osat.create_with_problem
        [| [| 1; 2; 3 |]
         ; [| -1; 4 |]
         ; [| -2; 4 |]
         ; [| -3; 4 |]
         ; [| -4; 5 |]
         ; [| 1; -5 |]
        |]
    in
    match Osat.run t with
    | Sat model ->
      printf "  Model size: %d variables\n" (List.length model);
      (* Verify the solution *)
      let get_val var = List.Assoc.find_exn model ~equal:Int.equal var in
      assert (get_val 1 || get_val 2 || get_val 3);
      assert ((not (get_val 1)) || get_val 4);
      assert ((not (get_val 2)) || get_val 4);
      assert ((not (get_val 3)) || get_val 4);
      assert ((not (get_val 4)) || get_val 5);
      assert (get_val 1 || not (get_val 5))
    | UnsatCore _ -> failwith "Expected SAT, got UNSAT");
  print_endline "\n=== All tests passed! ===\n"
;;
