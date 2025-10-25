open! Core
module Nod_error = Nod_common.Nod_error
module Pos = Nod_common.Pos
module Token = Nod_common.Token
module Frontend = Nod_frontend
module Parser = Nod_frontend.Parser
module Lexer = Nod_frontend.Lexer
module Parser_comb = Nod_frontend.Parser_comb
module State = Nod_frontend.State
module Block = Nod_core.Block
module Call_block = Nod_core.Call_block
module Call_conv = Nod_core.Call_conv
module Cfg = Nod_core.Cfg
module Clobbers = Nod_core.Clobbers
module Function = Nod_core.Function
module Function0 = Nod_core.Function0
module Import = Nod_core.Import
module Ir = Nod_core.Ir
module Ir0 = Nod_core.Ir0
module Ssa = Nod_core.Ssa
module Var = Nod_core.Var
module X86_ir = Nod_core.X86_ir
module X86_backend = Nod_x86_backend.X86_backend
module Examples = Nod_examples.Examples

module Eir = struct
  include Nod_core.Eir

  let compile_parsed = Nod_core.Eir.compile

  let compile ?opt_flags program =
    Parser.parse_string program
    |> Result.bind ~f:(fun parsed -> compile_parsed ?opt_flags (Ok parsed))
  ;;
end

let compile ?opt_flags source = Eir.compile ?opt_flags source
