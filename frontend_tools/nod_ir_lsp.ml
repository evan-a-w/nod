open! Core

module Types = Lsp.Types
module Token = Nod_common.Token
module Nod_error = Nod_common.Nod_error
module Pos = Nod_common.Pos

module Io = struct
  type 'a t = 'a Lwt.t

  let return = Lwt.return
  let raise = Lwt.fail

  module O = struct
    let ( let+ ) t f = Lwt.map f t
    let ( let* ) t f = Lwt.bind t f
  end
end

module Chan = struct
  type input = Lwt_io.input_channel
  type output = Lwt_io.output_channel

  let read_line = Lwt_io.read_line_opt

  let read_exactly ic len =
    let buf = Bytes.create len in
    Lwt.catch
      (fun () ->
        let open Lwt.Syntax in
        let* () = Lwt_io.read_into_exactly ic buf 0 len in
        Lwt.return_some (Bytes.to_string buf))
      (function
        | End_of_file -> Lwt.return_none
        | exn -> Lwt.fail exn)
  ;;

  let write oc chunks =
    let open Lwt.Syntax in
    let* () = Lwt_list.iter_s (Lwt_io.write oc) chunks in
    Lwt_io.flush oc
  ;;
end

module Lsp_io = Lsp.Io.Make (Io) (Chan)

type doc =
  { text : string
  ; version : int option
  }

type state =
  { docs : doc String.Table.t
  ; mutable shutdown_requested : bool
  }

let create_state () = { docs = String.Table.create (); shutdown_requested = false }
let uri_key uri = Lsp.Uri.to_string uri

let default_range =
  let start = Types.Position.create ~line:0 ~character:0 in
  let end_ = Types.Position.create ~line:0 ~character:1 in
  Types.Range.create ~start ~end_
;;

let range_of_pos pos ~length =
  let start = Types.Position.create ~line:pos.Pos.line ~character:pos.col in
  let end_ =
    Types.Position.create ~line:pos.Pos.line ~character:(pos.col + length)
  in
  Types.Range.create ~start ~end_
;;

let token_length = function
  | Token.L_paren
  | Token.R_paren
  | Token.L_brace
  | Token.R_brace
  | Token.L_bracket
  | Token.R_bracket
  | Token.Minus
  | Token.Plus
  | Token.Star
  | Token.Forward_slash
  | Token.Equal
  | Token.Less
  | Token.Greater
  | Token.Percent
  | Token.Colon
  | Token.Semi_colon
  | Token.Comma
  | Token.Dot -> 1
  | Token.L_brace_percent | Token.Percent_r_brace -> 2
  | Token.Not_equal | Token.Less_equal | Token.Greater_equal | Token.Arrow -> 2
  | Token.Keyword s | Token.Ident s -> String.length s
  | Token.String s -> String.length s + 2
  | Token.Int i -> String.length (Int.to_string i)
  | Token.Float f -> String.length (Float.to_string f)
  | Token.Bool b -> String.length (Bool.to_string b)
  | Token.Comment s -> String.length s + 4
;;

let find_ident_token tokens name =
  List.find_map tokens ~f:(fun (tok, pos) ->
    match tok with
    | Token.Ident s when String.equal s name -> Some (tok, pos)
    | _ -> None)
;;

let rec error_token error tokens =
  match error with
  | `Unexpected_token (tok, pos) -> Some (tok, pos)
  | `Unknown_instruction name
  | `Unknown_variable name
  | `Unknown_type name
  | `Duplicate_label name ->
    Option.bind tokens ~f:(fun tokens -> find_ident_token tokens name)
  | `Choices (err :: _) -> error_token err tokens
  | `Choices [] -> None
  | _ -> None
;;

let diagnostic_of_error error tokens =
  let range =
    match error_token error tokens with
    | Some (tok, pos) ->
      let length = token_length tok |> Int.max 1 in
      range_of_pos pos ~length
    | None -> default_range
  in
  let message = Nod_error.to_string error |> String.strip in
  Types.Diagnostic.create
    ~range
    ~severity:Types.DiagnosticSeverity.Error
    ~source:"nod-ir"
    ~message:(`String message)
    ()
;;

let parse_doc ~uri ~text =
  match Nod_frontend.Lexer.tokens ~file:(Lsp.Uri.to_string uri) text with
  | Error err -> Error (err, None)
  | Ok tokens ->
    (match
       Nod_frontend.Parser.parser ()
         (tokens, Nod_frontend.Parser.State.create ())
     with
     | Ok _ -> Ok ()
     | Error err -> Error (err, Some tokens))
;;

let publish_diagnostics ?version ~out ~uri diagnostics =
  let params =
    Types.PublishDiagnosticsParams.create ~diagnostics ~uri ?version ()
  in
  let notif = Lsp.Server_notification.PublishDiagnostics params in
  let packet =
    Jsonrpc.Packet.Notification (Lsp.Server_notification.to_jsonrpc notif)
  in
  Lsp_io.write out packet
;;

let update_and_diagnose state ~out ~uri ~text ~version =
  Hashtbl.set state.docs ~key:(uri_key uri) ~data:{ text; version };
  let diagnostics =
    match parse_doc ~uri ~text with
    | Ok () -> []
    | Error (err, tokens) -> [ diagnostic_of_error err tokens ]
  in
  publish_diagnostics ?version ~out ~uri diagnostics
;;

let clear_diagnostics ~out ~uri = publish_diagnostics ~out ~uri []

let send_response ~out response =
  Lsp_io.write out (Jsonrpc.Packet.Response response)
;;

let respond_error ~out ~id ~code ~message =
  let error = Jsonrpc.Response.Error.make ~code ~message () in
  send_response ~out (Jsonrpc.Response.error id error)
;;

let handle_request state ~out req =
  match Lsp.Client_request.of_jsonrpc req with
  | Error message ->
    respond_error
      ~out
      ~id:req.id
      ~code:Jsonrpc.Response.Error.Code.InvalidRequest
      ~message
  | Ok (Lsp.Client_request.E (Lsp.Client_request.Initialize _ as request)) ->
    let capabilities =
      Types.ServerCapabilities.create
        ~textDocumentSync:(`TextDocumentSyncKind Types.TextDocumentSyncKind.Full)
        ()
    in
    let serverInfo =
      Types.InitializeResult.create_serverInfo ~name:"nod-ir-lsp" ()
    in
    let result = Types.InitializeResult.create ~capabilities ~serverInfo () in
    let json = Lsp.Client_request.yojson_of_result request result in
    send_response ~out (Jsonrpc.Response.ok req.id json)
  | Ok (Lsp.Client_request.E (Lsp.Client_request.Shutdown as request)) ->
    state.shutdown_requested <- true;
    let json = Lsp.Client_request.yojson_of_result request () in
    send_response ~out (Jsonrpc.Response.ok req.id json)
  | Ok (Lsp.Client_request.E request) ->
    let message =
      Printf.sprintf "method not supported: %s" (Lsp.Client_request.method_ request)
    in
    respond_error
      ~out
      ~id:req.id
      ~code:Jsonrpc.Response.Error.Code.MethodNotFound
      ~message
;;

let handle_notification state ~out notif =
  match Lsp.Client_notification.of_jsonrpc notif with
  | Error _ -> Lwt.return_unit
  | Ok message ->
    (match message with
     | Lsp.Client_notification.TextDocumentDidOpen params ->
       let doc = params.textDocument in
       update_and_diagnose
         state
         ~out
         ~uri:doc.uri
         ~text:doc.text
         ~version:(Some doc.version)
     | Lsp.Client_notification.TextDocumentDidChange params ->
       let uri = params.textDocument.uri in
       let version = Some params.textDocument.version in
       let text =
         match List.last params.contentChanges with
         | Some change -> change.text
         | None ->
           (match Hashtbl.find state.docs (uri_key uri) with
            | Some doc -> doc.text
            | None -> "")
       in
       update_and_diagnose state ~out ~uri ~text ~version
     | Lsp.Client_notification.TextDocumentDidClose params ->
       let uri = params.textDocument.uri in
       Hashtbl.remove state.docs (uri_key uri);
       clear_diagnostics ~out ~uri
     | Lsp.Client_notification.Exit ->
       let code = if state.shutdown_requested then 0 else 1 in
       Stdlib.exit code
     | _ -> Lwt.return_unit)
;;

let handle_packet state ~out packet =
  match packet with
  | Jsonrpc.Packet.Notification notif -> handle_notification state ~out notif
  | Jsonrpc.Packet.Request req -> handle_request state ~out req
  | Jsonrpc.Packet.Batch_call calls ->
    let handle_call = function
      | `Notification notif -> handle_notification state ~out notif
      | `Request req -> handle_request state ~out req
    in
    Lwt_list.iter_s handle_call calls
  | Jsonrpc.Packet.Response _ | Jsonrpc.Packet.Batch_response _ ->
    Lwt.return_unit
;;

let rec loop state ~in_ ~out =
  let open Lwt.Syntax in
  let* packet = Lsp_io.read in_ in
  match packet with
  | None -> Lwt.return_unit
  | Some packet ->
    let* () = handle_packet state ~out packet in
    loop state ~in_ ~out
;;

let connect_channel = function
  | Lsp.Cli.Channel.Stdio -> Lwt.return (Lwt_io.stdin, Lwt_io.stdout)
  | Lsp.Cli.Channel.Pipe path ->
    let open Lwt.Syntax in
    let fd = Lwt_unix.socket Unix.PF_UNIX Unix.SOCK_STREAM 0 in
    let* () = Lwt_unix.connect fd (Unix.ADDR_UNIX path) in
    let in_ = Lwt_io.of_fd ~mode:Lwt_io.Input fd in
    let out = Lwt_io.of_fd ~mode:Lwt_io.Output fd in
    Lwt.return (in_, out)
  | Lsp.Cli.Channel.Socket port ->
    let open Lwt.Syntax in
    let fd = Lwt_unix.socket Unix.PF_INET Unix.SOCK_STREAM 0 in
    let addr = Unix.ADDR_INET (Unix.inet_addr_loopback, port) in
    let* () = Lwt_unix.connect fd addr in
    let in_ = Lwt_io.of_fd ~mode:Lwt_io.Input fd in
    let out = Lwt_io.of_fd ~mode:Lwt_io.Output fd in
    Lwt.return (in_, out)
;;

let () =
  let args = Lsp.Cli.Arg.create () in
  Stdlib.Arg.parse (Lsp.Cli.Arg.spec args) (fun _ -> ()) "nod-ir-lsp";
  let channel =
    match Lsp.Cli.Arg.channel args with
    | Ok channel -> channel
    | Error message ->
      eprintf "nod-ir-lsp: %s\n%!" message;
      Stdlib.exit 1
  in
  Lwt_main.run
    (let open Lwt.Syntax in
     let* in_, out = connect_channel channel in
     let state = create_state () in
     loop state ~in_ ~out)
;;
