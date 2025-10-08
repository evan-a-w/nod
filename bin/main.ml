open! Core
open! Nod
open! Nod_test

(* let build_classifications ~classifications dir =
  Core_unix.ls_dir_detailed dir
  |> List.fold
       ~init:classifications
       ~f:(fun acc { Core_unix.Readdir_detailed.name; _ } ->
         match
           In_channel.read_all (dir ^ "/" ^ name)
           |> Parser.parse_string
                (* ~config:
                  { classification_config =
                      Instruction.Classification.Config.Any
                  } *)
         with
         | Error _ -> failwith "fl"
         | Ok asm ->
           List.fold asm ~init:acc ~f:(fun acc asm ->
             match asm with
             | Asm.Directive _ | Asm.Label _ -> acc
             | Instruction instr ->
               (match Instruction.mnemonic_and_instruction_kind instr with
                | None -> acc
                | Some (mnemonic, kind) ->
                  Map.update acc mnemonic ~f:(function
                    | None -> Instruction.Instruction_kind.Set.singleton kind
                    | Some s -> Set.add s kind))))
;; *)

(* let () = Test_x86.test Examples.Textual.fib *)

(* let () =
  let classifications =
    build_classifications ~classifications:Mnemonic.Map.empty "./x86/asm/nonopt"
  in
  let classifications =
    build_classifications ~classifications "./x86/asm/opt"
  in
  print_s
    [%sexp (classifications : Instruction.Classification.t Mnemonic.Map.t)]
;; *)

let _stepped3 () =
  let formula =
    [| [| 3; -10; -13; 1; 12; 15; 9; -5; 6; 14; 4 |]
     ; [| -10; 14; 5; -3; -12; -6; 8; -4; 11; 9; -15; 1; -7; -13 |]
     ; [| -4; 10; 12; -5; 8; 15; -6; -13; -7 |]
     ; [| -13; -15; -12; -11; 14; 8; 5 |]
     ; [| 13; 3; 8; 5; 10; 12; -14; -11 |]
     ; [| -4; -13 |]
     ; [| 14; 11 |]
     ; [| -14; 13; -5; -6 |]
     ; [| -5; 4; -14 |]
     ; [| 12; -6; 8; 2 |]
     ; [| -4; 8; 6; 15; -3; -13; 9; 12; 2; 1; 11; 7; 10; -5 |]
     ; [| -14; 9; 5; -11; -15; 1; -4; 12; 13; -2 |]
     ; [| 15; -7; -12; 6 |]
     ; [| 11; -8; -15; 13; 1; -3; 5; -12; 7; -14; -9; 10 |]
     ; [| -11; -2; -1; -3; -12; -13; -6; 14; -5; -10; -4; -9 |]
     ; [| -9; -10; 6; 14; -5; 11; 7; -2; 8; -4; -3 |]
     ; [| 6; 5; -14; 12; 1; -13; 10; 9; 11; 7; -8; -2; -15; 3; -4 |]
     ; [| 2; 3; -10; 8; 15; -4; -14; 1 |]
     ; [| 9; 3 |]
     ; [| -8; 7; -4; -5; -2 |]
     ; [| -2; -15; -14; 3; -11; -7; 1; 12 |]
     ; [| -3; -5; 8 |]
     ; [| -15; -4; 3; -1; 12; -10; -14; -2; 13; -6; -8 |]
     ; [| -11; -14; -3; -9; 8; -1; -13; 7; 5 |]
     ; [| -3 |]
     ; [| 14; -3; 15; 7; 4; -8; -13; 10; -12; 6; -5; 2; -9; -1; -11 |]
     ; [| 12; 8; -2; -6; -5; -15; 10; 7; -9 |]
     ; [| 15; 13 |]
     ; [| 9; -1; -15; -3; 2; 12; 6; 14; 5 |]
     ; [| -1; 13; -4; 11 |]
     ; [| 14; 6; -5; 12 |]
     ; [| 13; -6; 3; 9; 7; 10; 1; -4; -15 |]
     ; [| -3; -8 |]
     ; [| -2; 8; -12; 14; 7 |]
     ; [| -9; 2; -12; -11; 3 |]
     ; [| 4; -10 |]
     ; [| 11; 9; -8; 7; 1; 5; 6; -4 |]
     ; [| 7; -14; 6; 5; 15; -13; -1; -3; -11; 8 |]
     ; [| 2; 9; 3; 5; 1; -7 |]
     ; [| 9; -11; 3 |]
     ; [| -7; 1; 9; 12; 10; 4; 11; 6; 2; -15 |]
     ; [| 9; -6 |]
     ; [| 12; 5; -6; 14; 8; 10; 13; -7; -2; -11; 15; -3; 9; 1; -4 |]
     ; [| -10; -9; -8 |]
     ; [| 12; -15; 8; -2; 6; 3; -14; 10 |]
     ; [| 15; -9; 4; 6; -7 |]
     ; [| 4; 10; -2; 8; -9; -14; -12 |]
     ; [| -10 |]
     ; [| -14; -3 |]
     ; [| 1; 6; 5; -11; 12; 2; -9; 10; 4; 7 |]
     ; [| -6; -1; 11 |]
     ; [| -7; -10; -3; 15; 11; -14; 8 |]
     ; [| -14; -8; -12; -15; 10; 9; 6; -13; 3; 4; 5; 7; 1; 2 |]
     ; [| 3; -12; -5; -1 |]
     ; [| 6; -9; 10; 13; -4; 1; -15; 14; 2; -7; 5; 8; 11; 12 |]
     ; [| -10; 3 |]
     ; [| -5; 1; -4; 11; 12; 15; 3; -13; 9; 14; -10; -7; 2; 6; 8 |]
     ; [| 3; -9; 6; 7; -5; -14; 15 |]
     ; [| -11; -5; -1; -7; -15; 12; -8; -3 |]
     ; [| -1; -9; -12; -2; 11; 3; -7; -5; 6; 14; 15; -13; -8 |]
     ; [| 3; -12; 6; -15; -10; -8; 1; 13; -4; -9; 14; 2 |]
     ; [| 13; 1; -3; -15; 2; 14 |]
     ; [| 6; -4; -15; 7; 8; -5; 3; -2; 1; -11 |]
     ; [| 4 |]
     ; [| 4; -2; 12; -6; 13; -15 |]
     ; [| -1; 4; -8; 9; 13; -5; -14 |]
     ; [| -1; -7; 8; 10; 11; 6; 3; 2 |]
     ; [| 6; 11; 3; -10; -13; -8; -14; -4 |]
     ; [| -4; -12; 5; 13; -10; -9; 7; 1; 11; -3; 8 |]
     ; [| -10; -2; 7; -3; 11; 1; -14; 12; 13 |]
     ; [| 7; 14; -6; -10; -8 |]
     ; [| -5; -1; -7; -14; -11; 8 |]
     ; [| 15; -3; 8; 7; 2; 14 |]
     ; [| -3 |]
     ; [| -13; -11; 10; -14; 9; -5; 15; 3; -1 |]
     ; [| 4; -9; 11; 7; -3; -5; -2 |]
     ; [| 8; -6; -3; -7 |]
     ; [| -8; 14; -5; -2; 10; -9; -11 |]
     ; [| -10; -14; 11 |]
     ; [| -13; -5; 11; 3; 8; 12; 15 |]
     ; [| 2; 12; -14; 8; -13; -3 |]
     ; [| 11; 2; -12; -3; -8; -14; 5; 10; 4; 15; -1 |]
     ; [| -11; 2; 1; 8; 4; 7; -10; -5 |]
    |]
  in
  match Pror_rs.create_with_problem formula |> Pror_rs.run with
  | Sat l -> print_s [%message "Sat" (l : (int * bool) list)]
  | UnsatCore l -> print_s [%message "UnsatCore" (l : int array)]
;;

(* let () = Nod_test.Test_x86.test Nod.Examples.Textual.super_triv *)
let () =
  Nod_test.Test_x86.test
    ~opt_flags:Eir.Opt_flags.no_opt
    ~dump_crap:false
    Nod.Examples.Textual.e2
;;

(* stepped3 () *)
