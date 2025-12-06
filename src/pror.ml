open! Core
include Pror_rs
module Bitset = Bitset
module Logic = Logic
module Solver_intf = Solver_intf

module Feel_solver : Solver_intf.S = struct
  include Feel.Solver

  let create_with_formula formula = create_with_formula formula

  let solve ?assumptions t =
    let res = solve ?assumptions t in
    match res with
    | Unsat { unsat_core } -> `Unsat (Feel.Clause.to_int_array unsat_core)
    | Sat { assignments } -> `Sat (Feel.Clause.to_int_array assignments)
  ;;
end

module Pror_solver : Solver_intf.S = struct
  include Pror_rs

  let create_with_formula = create_with_problem

  let solve ?assumptions t =
    let res =
      match assumptions with
      | None -> run t
      | Some assumptions -> run_with_assumptions t assumptions
    in
    match res with
    | UnsatCore unsat_core -> `Unsat unsat_core
    | Sat res ->
      `Sat (List.map res ~f:(fun (i, b) -> if b then i else -i) |> Array.of_list)
  ;;
end
