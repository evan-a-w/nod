open! Core

let () =
  print_endline "Testing four-way UNSAT with debug...";
  let t =
    Osat.create_with_problem
      [| [| 1; 2 |]; [| -1; 2 |]; [| 1; -2 |]; [| -1; -2 |] |]
  in
  print_endline "Problem created, running solver...";
  let result = Osat.run t in
  match result with
  | Sat _ -> print_endline "SAT (unexpected)"
  | UnsatCore core ->
    printf "UNSAT core: ";
    Array.iter core ~f:(fun var -> printf "%d " var);
    print_endline ""
;;
