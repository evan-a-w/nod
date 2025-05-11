#!/usr/bin/env bash
set -uo pipefail

usage() {
  cat <<EOF
Usage: $(basename "$0") <src_dir> <compiler> [cflags...]

Compiles all .c files in <src_dir> to assembly in ./asm,
ignoring individual compile errors and continuing.

  <src_dir>   Directory containing .c files
  <compiler>  e.g. clang, gcc, clangd
  [cflags...] Any flags you want to pass to the compiler

Example:
  $(basename "$0") src gcc -O2 -march=native
EOF
  exit 1
}

# require at least src_dir and compiler
if [[ $# -lt 2 ]]; then
  usage
fi

src_dir=$1
compiler=$2
shift 2
cflags=( "$@" )

# make sure source dir exists
if [[ ! -d "$src_dir" ]]; then
  echo "Error: source directory '$src_dir' not found." >&2
  exit 1
fi

# prepare output dir
out_dir=asm
mkdir -p "$out_dir"

shopt -s nullglob
for src in "$src_dir"/*.c; do
  base=$(basename "$src" .c)
  out="$out_dir/${base}.s"
  echo "→ Compiling $src → $out"
  # run the compile, but if it fails, print a warning and keep going
  if ! "$compiler" "${cflags[@]}" -S "$src" -o "$out"; then
    echo "  ⚠️  Failed to compile $src, skipping."
    continue
  fi
done

echo "Done. Assembly files (and any failures) are logged above."
