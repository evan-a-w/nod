This file provides guidance to AI agents when working with the Nod repository.

## Build & Test Workflow
- Build everything: `dune build`
- Run the CLI: `dune exec nod -- --help`
- **Run the test suite after every change:** `dune runtest`
- Promote expect output when needed: `dune runtest --auto-promote`
- Format before handing off: `dune fmt` (enforces `.ocamlformat`, profile `janestreet`, margin 80)

## High-Level Architecture
Nod consumes a textual IR, lowers it into SSA form, applies a handful of optimisations, and emits x86-64 or arm64 assembly. The major stages are:

1. **Frontend (`frontend/`)** – `lexer.ml`, `parser.ml`, and `parser_comb.ml` turn the textual input into labelled instruction streams per function.
2. **CFG construction (`core/cfg.ml`)** – `process` and `process'` convert those streams into real `Block.t` graphs with explicit predecessors/successors.
3. **SSA conversion (`core/ssa.ml`)** – `Ssa.convert_program` takes a program plus a shared `State.t` (mapping function names to `Fn_state.t`) and rewrites each CFG into SSA form while keeping instruction/value metadata consistent.
4. **Optimisation (`core/eir_opt.ml`)** – the `Eir_opt` passes currently support constant propagation, dead-code elimination, and a stub GVN; they operate directly on the SSA CFG using dominance info recomputed per function.
5. **Backends (`x86_backend/`, `arm64_backend/`)** – instruction selection, liveness, and SAT-based register allocation (via the `oxsat` submodule) lower SSA to architecture-specific IR and finally to assembly text.

`lib/nod.ml` ties the pieces together so downstream users can call `Nod.compile` without depending on internal modules.

## Key Modules & Data Structures
- **`Block.t`** – CFG node holding instruction lists, a terminal instruction, and φ-parameters (`args`).
- **`Call_block.t`** – a `{ block; args }` pair where `args : Typed_var.t list`, used for branch targets and successors.
- **`Fn_state.t` / `State.t`** – allocator/state-tracker for per-function values/instructions. `State.t` maps function names to their mutable `Fn_state.t`.
- **`Program.t` and `Function.t`** – `Nod_ir` functors instantiated with `Typed_var.t` (vars) and `Block.t` (blocks). Most helpers use `Function.map_root` or `Program.map_function_roots`.
- **`Vec` (`vec/`)** – dynamic array used heavily for block arguments, dominance info, etc.
- **`oxsat/`** – SAT solver used by `x86_backend/regalloc.ml` and the arm64 counterpart to perform graph colouring.

## Repository Layout (selected)
- `frontend/` – lexer, parser, parser combinators
- `core/` – CFG (`cfg.ml`), SSA (`ssa.ml`), optimisations (`eir_opt.ml`), IR definitions, and supporting types
- `x86_backend/`, `arm64_backend/` – architecture-specific lowering and register allocation
- `dsl/` – PPX-based DSL used inside tests/expectations
- `test_lib/`, `test_opt/`, `debug_test/`, `regressions_test/` – expect tests and helper harnesses
- `vec/` – small vector abstraction shared across the project
- `oxsat/` – SAT solver dependency for register allocation

## Testing Guidelines
- Prefer inline `%expect_test` blocks (via `ppx_jane`) and place them near the code under test (usually in `test_lib/test_*.ml`).
- Keep deterministic outputs so CI-friendly promotion works; if expected output changes intentionally, run `dune runtest --auto-promote` and commit the updated files.
- For pure logic without textual output, add `let%test_unit` cases adjacent to the implementation.
- Always finish work by running `dune runtest`; failing to do so usually leaves stale `%expect` artifacts.
- But consider testing only relevant modules (so it's much faster, eg. [dune runtest test_opt])

## Style Preferences
- Use `open! Core` (and other Jane Street libraries) at the top of each file; avoid `open`ing project modules broadly—refer to them via explicit module prefixes.
- Let `.ocamlformat` handle indentation and alignment; do not manually line up code.
- Modules follow the OCaml naming convention (`foo_bar.ml` → `Foo_bar`), filenames stay lowercase_with_underscores.
- Write interface (mli) files with minimal interfaces and safe apis.
- Prefer using ppx_nod to write nod ir rather than textual strings.

## Source Language Quick Reference
- Variables: `%name:type` (e.g., `%x:i64`)
- Instructions look like: `add %dest:i64, %src1, 42`
- Labels end with `:` and are referenced by name in branch targets.
- Branch syntax: `branch %cond, if_true_label, if_false_label`
- Supported primitive types include `i64`, `i32`, `ptr`, tuples, and aggregates (see `Nod_ir.Type`).
- ppx_nod can be used to write ir, eg.
```ocaml
let fn =
[%nod fun (t : ptr) ->
  let len = load_record_field binary_heap.len t in
  let i_slot = alloca (lit 8L) in
  store index i_slot;
  return (lit 0L)]
;;
```
