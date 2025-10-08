# Repository Guidelines

## Project Structure & Module Organization
- `lib/` hosts the primary Nod compiler components (IRs, SSA, CFG, x86 backend).
- `parser_core/` contains reusable parser combinators and token utilities consumed by the main library.
- `vec/` provides the small vector abstraction shared across modules.
- `bin/` exposes the `nod` CLI entry point; it links against the core library and test helpers.
- `test_lib/` groups inline test helpers and scenario suites; keep fixtures close to the code they exercise.
- Build artifacts land in `_build/`; leave it untracked and clean before releases.

## Build, Test, and Development Commands
- `opam install . --deps-only --with-test` installs OCaml, dune, core, and other prerequisites.
- `dune build` compiles all libraries and the public `nod` executable.
- `dune exec nod -- --help` runs the CLI with your arguments during development.
- `dune runtest` executes inline `%expect` suites; use `dune runtest --auto-promote` (or `dune promote`) to accept new expect output.
- `dune fmt` applies `.ocamlformat` rules—run it before committing.

## Coding Style & Naming Conventions
- Formatting is enforced by `.ocamlformat` (`profile=janestreet`, `margin=80`); trust the formatter and avoid manual alignment.
- Modules follow the OCaml convention (`ssa.ml` → `Ssa`); keep filenames lowercase with underscores.
- Prefer two-space indentation and the pipe-last style that ocamlformat enforces.
- Restrict `open!` to Jane Street imports at the top of files; rely on explicit module prefixes elsewhere.

## Testing Guidelines
- Place new expect tests in the relevant `test_lib/test_*.ml`; give descriptive labels such as `let%expect_test "cfg merges loops"`.
- Keep golden outputs deterministic; rerun `dune runtest` until clean, then promote updates intentionally.
- For logic without textual output, add `let%test_unit` cases adjacent to the implementation.
- Ensure new features cover both library behaviour (`lib/`) and any CLI surfaces via inline tests or end-to-end scenarios.
