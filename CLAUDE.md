# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Nod is a compiler for a custom intermediate representation (IR) language that compiles to x86-64 assembly. The compiler pipeline transforms source code through multiple IRs (IR0 → IR → SSA → EIR → X86 IR → Assembly) with optimizations at each stage.

## Build and Test Commands

**Build:**
- `dune build` - Compile all libraries and the `nod` executable
- `dune exec nod -- emit-asm [--no-opt] [--dump-crap] [-o FILE] <input>` - Run compiler during development

**Test:**
- `dune runtest` - Execute all inline expect tests
- `dune runtest --auto-promote` - Accept new expect test outputs (same as `dune promote`)
- Single test: `dune runtest test_lib` - Run tests in specific library

**Other:**
- `dune fmt` - Format code according to `.ocamlformat` rules (required before committing)
- `opam install . --deps-only --with-test` - Install dependencies

**Rust FFI Component:**
- The `src/` directory contains Rust bindings to the `pror` library
- Build triggers `cargo build --release` automatically via dune rules

## Compiler Architecture

### Pipeline Stages

1. **Frontend (`frontend/`)** - Lexing and parsing
   - `lexer.ml` - Tokenizes source into `Token.t` stream
   - `parser.ml` - Parser combinator-based parser producing unprocessed CFG
   - `parser_comb.ml` - Generic parser combinator library
   - Output: `Parser.output` (function map with instruction sequences by label)

2. **CFG Construction (`core/cfg.ml`)** - Builds control flow graph
   - `process` - Converts label/instruction maps into linked `Block.t` graph
   - `process'` - Helper that handles terminal instructions and auto-generates labels
   - Output: `{ root : Block.t; blocks : Block.t String.Map.t; in_order : Block.t Vec.t }`

3. **SSA Transformation (`core/ssa.ml`)** - Converts to Static Single Assignment
   - `Dominator` module - Implements Lengauer-Tarjan dominance algorithm
   - Computes dominance frontiers for φ-node placement
   - Output: SSA form with block arguments for φ-nodes

4. **Optimization & IR Lowering (`core/eir.ml`)** - Extended IR with optimization
   - Entry point: `Eir.compile` or `Eir.compile_parsed`
   - `Opt_var` - Variables with use-def chains, location tracking, and tags
   - `Opt_flags` - Controls which optimizations run (DCE, constant propagation, etc.)
   - Tracks variable uses via `Loc.Hash_set.t` for efficient DCE
   - Plans for memory SSA, alias analysis, GVN, and store/load optimizations (see comments in eir.ml:4-48)

5. **X86 Backend (`x86_backend/`)** - Code generation and register allocation
   - `instruction_selection.ml` - Lower IR to X86 IR with virtual registers
   - `calc_liveness.ml` - Liveness analysis for register allocation
   - `regalloc.ml` - Register allocation with spilling
   - `assignment.ml` - Maps virtual regs to `Spill | Reg of Reg.t`
   - `calc_clobbers.ml` & `save_clobbers.ml` - Callee-saved register handling
   - `lower.ml` - Final assembly string generation
   - Output: x86-64 assembly text

### Core Data Structures

**IR Hierarchy:**
- `Ir0.t` - Basic IR with generic block references (`'block t`)
- `Ir.t` - Instantiated to `Block.t Ir0.t`, adds type checking (`Ir.Type_check`)
- `X86_ir.t` - x86-specific instructions with `operand = Reg | Imm | Mem`

**Blocks and Variables:**
- `Block.t` - CFG node with `instructions`, `terminal`, `children`, `parents`, `args` (for φ)
- `Var.t` - Named typed variable (`{ name : string; type_ : Type.t }`)
- `Call_block.t` - Block reference with arguments (`{ block : 'b; args : Var.t list }`)

**X86 Registers:**
- `X86_reg.t` - Register with allocation state:
  - `Unallocated of Var.t` - Virtual register
  - `Allocated of Var.t * Reg.t option` - With optional forced assignment
  - `Physical of Raw.t` - Hardware register

### Module Dependencies

```
lib/nod.ml (public interface)
├── frontend/ (nod_frontend)
│   ├── lexer.ml, parser.ml, parser_comb.ml
│   └── depends on: nod_common, nod_core
├── core/ (nod_core)
│   ├── cfg.ml, ssa.ml, eir.ml, ir.ml, ir0.ml
│   ├── function.ml, block.ml, var.ml, type.ml
│   ├── x86_ir.ml, x86_reg.ml
│   └── depends on: vec, pror, nod_common
├── x86_backend/ (nod_x86_backend)
│   ├── x86_backend.ml, assignment.ml, regalloc.ml
│   ├── instruction_selection.ml, lower.ml
│   ├── calc_liveness.ml, calc_clobbers.ml, save_clobbers.ml
│   └── depends on: nod_common, nod_core
└── common/ (nod_common)
    └── token.ml, pos.ml
```

## Testing Guidelines

- Tests use inline `%expect_test` annotations (ppx_jane)
- Test files in `test_lib/`: `test_parser.ml`, `test_cfg.ml`, `test_ssa.ml`, `test_x86.ml`, `test_x86_asm.ml`, `test_x86_execution.ml`
- Expect test pattern:
  ```ocaml
  let%expect_test "descriptive name" =
    input |> function_to_test;
    [%expect {| expected output |}]
  ```
- Use `dune runtest` to verify, `dune promote` to accept changes
- Keep golden outputs deterministic

## Code Style

- OCamlFormat enforced (profile=janestreet, margin=80)
- Use `open!` only for Jane Street imports at file top
- Rely on explicit module prefixes elsewhere
- Modules follow OCaml convention: `ssa.ml` → `Ssa` module
- Filenames: lowercase with underscores
- All code uses Jane Street Core (`open! Core`)
- Preprocessing: `ppx_jane` provides deriving extensions and inline test support
- Extension flag: `-extension-universe beta` enables experimental OCaml features

## Compiler Flags and Extensions

- Uses `-extension-universe beta` for experimental features like `module M = functor F`
- Deriving support: `[@@deriving sexp, compare, equal, hash]` via ppx_jane
- Inline tests enabled in all libraries except `bin/`

## Language Syntax (Input IR)

Variables: `%name:type` (e.g., `%x:i64`)
Instructions: `add %dest:i64, %src1, 42`
Labels: `label_name:`
Branches: `branch cond, true_label, false_label`
Types: `i64`, `i32`, `ptr`
