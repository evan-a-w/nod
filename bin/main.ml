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
