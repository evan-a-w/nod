open! Core
module Std = Stdlib
module Nod_error = Nod_common.Nod_error
module Pos = Nod_common.Pos
module Token = Nod_common.Token
module Frontend = Nod_frontend
module Parser = Nod_frontend.Parser
module Lexer = Nod_frontend.Lexer
module Parser_comb = Nod_frontend.Parser_comb
module State = Nod_frontend.State
module Low = Nod_low.Low
module Low_error = Nod_low.Error
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
module X86_asm = Nod_x86_backend.X86_asm
module X86_backend = Nod_x86_backend.X86_backend
module X86_jit = Nod_x86_backend.Jit
module Arm64_asm = Nod_arm64_backend.Arm64_asm
module Arm64_backend = Nod_arm64_backend.Arm64_backend
module Examples = Nod_examples.Examples

type arch =
  [ `Arm64
  | `X86_64
  | `Other
  ]

let parse_arch s : arch =
  match s with
  | "x86_64" | "amd64" -> `X86_64
  | "arm64" | "aarch64" -> `Arm64
  | _ -> `Other
;;

let architecture () : arch =
  Core_unix.uname ()
  |> Core_unix.Utsname.machine
  |> String.lowercase
  |> parse_arch
;;

let only_on_arch arch f = if Poly.(architecture () = arch) then f () else ()

module Eir = struct
  include Nod_core.Eir

  let compile_parsed = Nod_core.Eir.compile

  let compile ?opt_flags program =
    Parser.parse_string program
    |> Result.bind ~f:(fun parsed -> compile_parsed ?opt_flags (Ok parsed))
  ;;
end

let compile ?opt_flags source = Eir.compile ?opt_flags source

let make_harness_source
  ?(fn_name = "root")
  ?(fn_arg_type = "void")
  ?(fn_arg = "")
  ()
  =
  [%string
    {|
#include <stdint.h>
#include <stdio.h>

extern int64_t %{fn_name}(%{fn_arg_type});

int main(void) {
  printf("%lld\n", (long long) %{fn_name}(%{fn_arg}));
  return 0;
}
|}]
;;

let harness_source = make_harness_source ()

let gc_runtime_source =
  {|
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

typedef struct gc_descr {
  struct gc_descr* next;
  uint64_t mask_len;
  uint64_t mask[];
} gc_descr;

typedef struct gc_object {
  struct gc_object* next;
  gc_descr* descr;
  uint64_t size;
  uint8_t marked;
} gc_object;

typedef struct gc_frame {
  struct gc_frame* prev;
  uint64_t count;
  uint64_t roots[];
} gc_frame;

static gc_object* gc_objects = NULL;
static gc_descr* gc_descrs = NULL;
static gc_frame* gc_frames = NULL;
static uint64_t gc_bytes_allocated = 0;
static uint64_t gc_threshold = 1024 * 1024;

static gc_descr* gc_descr_equal(const uint64_t* mask, uint64_t mask_len)
{
  for (gc_descr* descr = gc_descrs; descr != NULL; descr = descr->next) {
    if (descr->mask_len != mask_len) {
      continue;
    }
    if (mask_len == 0) {
      return descr;
    }
    if (memcmp(descr->mask, mask, mask_len * sizeof(uint64_t)) == 0) {
      return descr;
    }
  }
  return NULL;
}

static gc_descr* gc_get_descr(const uint64_t* mask, uint64_t mask_len)
{
  gc_descr* existing = gc_descr_equal(mask, mask_len);
  if (existing != NULL) {
    return existing;
  }
  size_t bytes = sizeof(gc_descr) + (size_t)mask_len * sizeof(uint64_t);
  gc_descr* descr = (gc_descr*)malloc(bytes);
  if (descr == NULL) {
    abort();
  }
  descr->next = gc_descrs;
  descr->mask_len = mask_len;
  if (mask_len > 0 && mask != NULL) {
    memcpy(descr->mask, mask, mask_len * sizeof(uint64_t));
  }
  gc_descrs = descr;
  return descr;
}

void nod_gc_push_frame(void* frame, uint64_t count)
{
  gc_frame* f = (gc_frame*)frame;
  f->prev = gc_frames;
  f->count = count;
  if (count > 0) {
    memset(f->roots, 0, (size_t)count * sizeof(uint64_t));
  }
  gc_frames = f;
}

void nod_gc_pop_frame(void)
{
  if (gc_frames != NULL) {
    gc_frames = gc_frames->prev;
  }
}

typedef struct gc_worklist {
  gc_object** items;
  size_t count;
  size_t capacity;
} gc_worklist;

static void gc_worklist_push(gc_worklist* work, gc_object* obj)
{
  if (work->count == work->capacity) {
    size_t new_cap = work->capacity == 0 ? 64 : work->capacity * 2;
    gc_object** next =
        (gc_object**)realloc(work->items, new_cap * sizeof(gc_object*));
    if (next == NULL) {
      abort();
    }
    work->items = next;
    work->capacity = new_cap;
  }
  work->items[work->count++] = obj;
}

static gc_object* gc_find_object(void* ptr)
{
  uint8_t* addr = (uint8_t*)ptr;
  for (gc_object* obj = gc_objects; obj != NULL; obj = obj->next) {
    uint8_t* payload = (uint8_t*)(obj + 1);
    uint8_t* end = payload + obj->size;
    if (addr >= payload && addr < end) {
      return obj;
    }
  }
  return NULL;
}

static void gc_mark_value(uint64_t value, gc_worklist* work)
{
  if (value == 0) {
    return;
  }
  gc_object* obj = gc_find_object((void*)(uintptr_t)value);
  if (obj == NULL || obj->marked) {
    return;
  }
  obj->marked = 1;
  gc_worklist_push(work, obj);
}

static void gc_mark_roots(gc_worklist* work)
{
  for (gc_frame* frame = gc_frames; frame != NULL; frame = frame->prev) {
    for (uint64_t i = 0; i < frame->count; i++) {
      gc_mark_value(frame->roots[i], work);
    }
  }
}

static void gc_scan_object(gc_object* obj, gc_worklist* work)
{
  gc_descr* descr = obj->descr;
  if (descr->mask_len == 0) {
    return;
  }
  uint64_t words = (obj->size + 7) / 8;
  uint64_t* payload = (uint64_t*)(obj + 1);
  for (uint64_t word = 0; word < words; word++) {
    uint64_t mask_word = 0;
    uint64_t idx = word / 64;
    if (idx < descr->mask_len) {
      mask_word = descr->mask[idx];
    }
    if ((mask_word >> (word % 64)) & 1ULL) {
      gc_mark_value(payload[word], work);
    }
  }
}

void nod_gc_collect(void)
{
  gc_worklist work = {0};
  gc_mark_roots(&work);
  while (work.count > 0) {
    gc_object* obj = work.items[--work.count];
    gc_scan_object(obj, &work);
  }
  free(work.items);

  gc_object** cursor = &gc_objects;
  while (*cursor != NULL) {
    gc_object* obj = *cursor;
    if (!obj->marked) {
      *cursor = obj->next;
      gc_bytes_allocated -= obj->size;
      free(obj);
    } else {
      obj->marked = 0;
      cursor = &obj->next;
    }
  }
  uint64_t next = gc_bytes_allocated * 2;
  if (next < 1024 * 1024) {
    next = 1024 * 1024;
  }
  gc_threshold = next;
}

void* nod_gc_alloc(uint64_t size, const uint64_t* mask, uint64_t mask_len)
{
  if (size == 0) {
    size = 1;
  }
  if (gc_bytes_allocated + size > gc_threshold) {
    nod_gc_collect();
  }
  gc_descr* descr = gc_get_descr(mask, mask_len);
  gc_object* obj = (gc_object*)malloc(sizeof(gc_object) + (size_t)size);
  if (obj == NULL) {
    abort();
  }
  obj->next = gc_objects;
  obj->descr = descr;
  obj->size = size;
  obj->marked = 0;
  gc_objects = obj;
  gc_bytes_allocated += size;
  return (void*)(obj + 1);
}

uint64_t nod_gc_live_bytes(void)
{
  return gc_bytes_allocated;
}
|}
;;

let quote_command prog args =
  String.concat ~sep:" " (Filename.quote prog :: List.map args ~f:Filename.quote)
;;

let run_command_exn ?cwd prog args =
  let command = quote_command prog args in
  let command =
    match cwd with
    | None -> command
    | Some dir -> sprintf "cd %s && %s" (Filename.quote dir) command
  in
  match Std.Sys.command command with
  | 0 -> ()
  | code -> failwith (sprintf "command failed (%d): %s" code command)
;;

let run_shell_exn ?cwd command =
  let command =
    match cwd with
    | None -> command
    | Some dir -> sprintf "cd %s && %s" (Filename.quote dir) command
  in
  match Std.Sys.command command with
  | 0 -> ()
  | code -> failwith (sprintf "command failed (%d): %s" code command)
;;

let host_system =
  lazy
    (match
       String.lowercase (Core_unix.uname () |> Core_unix.Utsname.sysname)
     with
     | "darwin" -> `Darwin
     | "linux" -> `Linux
     | _ -> `Other)
;;

let host_arch = lazy (architecture ())

let use_qemu_arm64 =
  lazy
    (Std.Sys.command "which qemu-aarch64 > /dev/null" = 0
     || Array.find
          (Core_unix.environment ())
          ~f:(String.is_prefix ~prefix:"USE_QEMU_ARM64")
        |> Option.is_some)
;;

let compile_and_lower_functions
  ~(arch : [ `X86_64 | `Arm64 | `Other ])
  ~(system : [ `Darwin | `Linux | `Other ])
  functions
  =
  match arch with
  | `X86_64 -> X86_backend.compile_to_asm ~system functions
  | `Arm64 -> Arm64_backend.compile_to_asm ~system functions
  | `Other -> failwith "unsupported target architecture"
;;

type lowered_items =
  | X86 of X86_asm.program
  | Arm64 of Arm64_asm.program

let compile_and_lower_functions_to_items
  ~(arch : [ `X86_64 | `Arm64 | `Other ])
  ~(system : [ `Darwin | `Linux | `Other ])
  functions
  =
  match arch with
  | `X86_64 -> X86_backend.compile_to_items ~system functions |> fun items -> X86 items
  | `Arm64 ->
    Arm64_backend.compile_to_items ~system functions |> fun items -> Arm64 items
  | `Other -> failwith "unsupported target architecture"
;;

let compile_and_lower
  ~(arch : [ `X86_64 | `Arm64 | `Other ])
  ~(system : [ `Darwin | `Linux | `Other ])
  ?(opt_flags = Eir.Opt_flags.no_opt)
  program
  =
  match Eir.compile ~opt_flags program with
  | Error err ->
    Or_error.error_string (Nod_error.to_string err) |> Or_error.ok_exn
  | Ok functions -> compile_and_lower_functions ~arch ~system functions
;;

let compile_and_lower_items
  ~(arch : [ `X86_64 | `Arm64 | `Other ])
  ~(system : [ `Darwin | `Linux | `Other ])
  ?(opt_flags = Eir.Opt_flags.no_opt)
  program
  =
  match Eir.compile ~opt_flags program with
  | Error err ->
    Or_error.error_string (Nod_error.to_string err) |> Or_error.ok_exn
  | Ok functions ->
    compile_and_lower_functions_to_items ~arch ~system functions
;;

type jit_module = X86_jit.Module.t

let compile_and_jit_x86
  ~(system : [ `Darwin | `Linux | `Other ])
  ?(opt_flags = Eir.Opt_flags.no_opt)
  ?dump_crap
  ?externals
  program
  =
  match Eir.compile ~opt_flags program with
  | Error err ->
    Or_error.error_string (Nod_error.to_string err) |> Or_error.ok_exn
  | Ok functions ->
    X86_jit.compile ?dump_crap ?externals ~system functions
;;

let qemu_aarch64_ld_prefix =
  lazy
    (let candidates =
       [ Std.Sys.getenv_opt "QEMU_AARCH64_LD_PREFIX"
       ; Some "/usr/aarch64-linux-gnu"
       ]
     in
     List.filter_opt candidates
     |> List.find ~f:(fun dir ->
       try
         match (Core_unix.stat dir).st_kind with
         | Core_unix.S_DIR -> true
         | _ -> false
       with
       | _ -> false))
;;

let execute_asm
  ~(arch : [ `X86_64 | `Arm64 | `Other ])
  ~(system : [ `Darwin | `Linux | `Other ])
  ?(harness = harness_source)
  asm
  =
  let temp_dir = Core_unix.mkdtemp "nod-exec" in
  let host_architecture = Lazy.force host_arch in
  let use_rosetta =
    Poly.(arch = `X86_64)
    && Poly.(host_architecture = `Arm64)
    && Poly.(system = `Darwin)
  in
  let compiler =
    match system with
    | `Darwin -> "clang"
    | `Linux | `Other -> "clang"
  in
  let arch_args =
    match host_architecture, arch, system with
    | `Arm64, `X86_64, `Darwin ->
      [ "-arch"; "x86_64"; "-target"; "x86_64-apple-macos11" ]
    | `Arm64, `Arm64, `Darwin ->
      [ "-arch"; "arm64"; "-target"; "arm64-apple-macos11" ]
    | `X86_64, `Arm64, `Linux when Lazy.force use_qemu_arm64 ->
      [ "--target=aarch64-linux-gnu" ]
    | _ -> []
  in
  let run_shell_runtime ?cwd command =
    match host_architecture, arch, system with
    | `Arm64, `X86_64, `Darwin when use_rosetta ->
      let command =
        quote_command "arch" [ "-x86_64"; "/bin/zsh"; "-c"; command ]
      in
      run_shell_exn ?cwd command
    | `X86_64, `Arm64, `Linux when Lazy.force use_qemu_arm64 ->
      let qemu_args =
        match Lazy.force qemu_aarch64_ld_prefix with
        | None -> []
        | Some dir -> [ "-L"; dir ]
      in
      let command =
        sprintf "%s %s" (quote_command "qemu-aarch64" qemu_args) command
      in
      run_shell_exn ?cwd command
    | _ -> run_shell_exn ?cwd command
  in
  Exn.protect
    ~f:(fun () ->
      let asm_path = Filename.concat temp_dir "program.s" in
      Out_channel.write_all asm_path ~data:asm;
      let harness_path = Filename.concat temp_dir "main.c" in
      Out_channel.write_all harness_path ~data:harness;
      let gc_runtime_path = Filename.concat temp_dir "gc_runtime.c" in
      Out_channel.write_all gc_runtime_path ~data:gc_runtime_source;
      (match arch, host_architecture with
       | `X86_64, `X86_64 -> ()
       | `X86_64, `Arm64 when use_rosetta -> ()
       | `Arm64, `Arm64 -> ()
       | `Arm64, `X86_64 when Lazy.force use_qemu_arm64 -> ()
       | _ -> failwith "execution is not supported on this host");
      run_shell_exn
        ~cwd:temp_dir
        (quote_command
           compiler
           ([ "-Wall"; "-Werror"; "-O0" ]
            @ arch_args
            @ [ "main.c"; "program.s"; "gc_runtime.c"; "-o"; "program" ]));
      let output_file = "stdout.txt" in
      let output_path = Filename.concat temp_dir output_file in
      run_shell_runtime
        ~cwd:temp_dir
        (sprintf
           "%s > %s"
           (quote_command "./program" [])
           (Filename.quote output_file));
      In_channel.read_all output_path |> String.strip)
    ~finally:(fun () ->
      let _ = Std.Sys.command (quote_command "rm" [ "-rf"; temp_dir ]) in
      ())
;;

let compile_and_execute
  ~(arch : [ `X86_64 | `Arm64 | `Other ])
  ~(system : [ `Darwin | `Linux | `Other ])
  ?(harness = harness_source)
  ?(opt_flags = Eir.Opt_flags.no_opt)
  program
  =
  let asm = compile_and_lower ~arch ~system ~opt_flags program in
  execute_asm ~arch ~system ~harness asm
;;
