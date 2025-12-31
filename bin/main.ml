open! Core
open Import

let read_program source =
  Or_error.try_with (fun () ->
    if String.equal source "-"
    then In_channel.input_all In_channel.stdin
    else In_channel.read_all source)
;;

let compile_program ~opt_flags ~dump_crap program =
  match Eir.compile ~opt_flags program with
  | Error parse_error -> Or_error.error_string (Nod_error.to_string parse_error)
  | Ok functions ->
    let system = Lazy.force Nod.host_system in
    let asm =
      if dump_crap
      then X86_backend.compile_to_asm ~system ~dump_crap:true functions
      else X86_backend.compile_to_asm ~system functions
    in
    Or_error.return asm
;;

let write_output ~destination data =
  Or_error.try_with (fun () ->
    match destination with
    | None | Some "-" -> Out_channel.output_string Out_channel.stdout data
    | Some file -> Out_channel.write_all file ~data)
;;

type emit_asm_config =
  { input : string
  ; output : string option
  ; no_opt : bool
  ; dump_crap : bool
  ; arch : Nod.arch
  }

let rec parse_emit_asm ?override_arch args ~input ~output ~no_opt ~dump_crap =
  match args with
  | [] ->
    (match input with
     | None -> Or_error.error_string "missing input program"
     | Some input ->
       Or_error.return
         { input
         ; output
         ; no_opt
         ; dump_crap
         ; arch =
             (match override_arch with
              | None -> Lazy.force Nod.host_arch
              | Some arch -> arch)
         })
  | "--arch" :: arch :: rest ->
    parse_emit_asm
      ~override_arch:(Nod.parse_arch arch)
      rest
      ~input
      ~output
      ~no_opt:true
      ~dump_crap
  | "--arch" :: [] -> Or_error.error_string "flag --arch expects a filename"
  | "--no-opt" :: rest ->
    parse_emit_asm ?override_arch rest ~input ~output ~no_opt:true ~dump_crap
  | "--dump-crap" :: rest ->
    parse_emit_asm ?override_arch rest ~input ~output ~no_opt ~dump_crap:true
  | "-o" :: file :: rest ->
    parse_emit_asm
      ?override_arch
      rest
      ~input
      ~output:(Some file)
      ~no_opt
      ~dump_crap
  | "-o" :: [] -> Or_error.error_string "flag -o expects a filename"
  | arg :: rest when Option.is_none input ->
    parse_emit_asm
      ?override_arch
      rest
      ~input:(Some arg)
      ~output
      ~no_opt
      ~dump_crap
  | arg :: _ -> Or_error.errorf "unexpected argument: %s" arg
;;

let run_emit_asm config =
  let opt_flags =
    if config.no_opt then Eir.Opt_flags.no_opt else Eir.Opt_flags.default
  in
  let open Or_error.Let_syntax in
  let%bind program = read_program config.input in
  let%bind asm =
    compile_program ~opt_flags ~dump_crap:config.dump_crap program
  in
  write_output ~destination:config.output asm
;;

let run_run config =
  let opt_flags =
    if config.no_opt then Eir.Opt_flags.no_opt else Eir.Opt_flags.default
  in
  let%map.Or_error program = read_program config.input in
  Nod.compile_and_execute
    ~arch:config.arch
    ~system:(Lazy.force Nod.host_system)
    ~opt_flags
    program
;;

let usage =
  "Usage: nod {emit-asm, run} [--no-opt] [--dump-crap] [-o FILE] <program|->\n"
;;

let print_usage () = Out_channel.output_string Out_channel.stderr usage

let () =
  let argv = Array.to_list (Sys.get_argv ()) in
  match argv with
  | [] | [ _ ] ->
    print_usage ();
    exit 1
  | _ :: "deebg" :: _ ->
    (match
       Nod.compile ~opt_flags:Eir.Opt_flags.default Examples.Textual.sum_100
     with
     | Error e -> Nod_error.to_string e |> print_endline
     | Ok functions ->
       X86_backend.For_testing.print_selected_instructions functions)
  | _ :: "emit-asm" :: args ->
    (match
       parse_emit_asm
         args
         ~input:None
         ~output:None
         ~no_opt:false
         ~dump_crap:false
     with
     | Ok config ->
       (match run_emit_asm config with
        | Ok () -> ()
        | Error err ->
          Out_channel.output_string
            Out_channel.stderr
            (sprintf "nod: %s\n" (Error.to_string_hum err));
          exit 1)
     | Error err ->
       Out_channel.output_string
         Out_channel.stderr
         (sprintf "nod: %s\n" (Error.to_string_hum err));
       print_usage ();
       exit 1)
  | _ :: "run" :: args ->
    (match
       parse_emit_asm
         args
         ~input:None
         ~output:None
         ~no_opt:false
         ~dump_crap:false
     with
     | Ok config ->
       (match run_run config with
        | Ok s -> print_string s
        | Error err ->
          Out_channel.output_string
            Out_channel.stderr
            (sprintf "nod: %s\n" (Error.to_string_hum err));
          exit 1)
     | Error err ->
       Out_channel.output_string
         Out_channel.stderr
         (sprintf "nod: %s\n" (Error.to_string_hum err));
       print_usage ();
       exit 1)
  | _ :: _ ->
    print_usage ();
    exit 1
;;
