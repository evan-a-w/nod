#include <caml/alloc.h>
#include <caml/custom.h>
#include <caml/fail.h>
#include <caml/memory.h>
#include <caml/mlvalues.h>
#include <caml/signals.h>

#include <stdint.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>

#ifdef __APPLE__
#include <pthread.h>
#ifndef MAP_JIT
#define MAP_JIT 0x800
#endif
#endif

struct jit_region {
  void* ptr;
  size_t len;
};

static void jit_region_finalize(value v)
{
  struct jit_region* region = (struct jit_region*)Data_custom_val(v);
  if (region->ptr != NULL && region->len > 0) {
    munmap(region->ptr, region->len);
  }
  region->ptr = NULL;
  region->len = 0;
}

static struct custom_operations jit_region_ops = {
  "nod.jit_region",
  jit_region_finalize,
  custom_compare_default,
  custom_hash_default,
  custom_serialize_default,
  custom_deserialize_default,
  custom_compare_ext_default,
  custom_fixed_length_default
};

static size_t round_to_page(size_t len)
{
  long page = sysconf(_SC_PAGESIZE);
  if (page <= 0) {
    return len;
  }
  size_t page_size = (size_t)page;
  return (len + page_size - 1) & ~(page_size - 1);
}

CAMLprim value nod_jit_alloc(value v_len)
{
  CAMLparam1(v_len);
  size_t len = round_to_page((size_t)Long_val(v_len));
  int prot = PROT_READ | PROT_WRITE;
  int flags = MAP_PRIVATE;
#ifdef MAP_ANON
  flags |= MAP_ANON;
#else
  flags |= MAP_ANONYMOUS;
#endif
#ifdef __APPLE__
  flags |= MAP_JIT;
#endif
  void* ptr = mmap(NULL, len, prot, flags, -1, 0);
  if (ptr == MAP_FAILED) {
    caml_failwith("jit_alloc failed");
  }
  value block =
      caml_alloc_custom(&jit_region_ops, sizeof(struct jit_region), 0, 1);
  struct jit_region* region = (struct jit_region*)Data_custom_val(block);
  region->ptr = ptr;
  region->len = len;
#ifdef __APPLE__
  pthread_jit_write_protect_np(0);
#endif
  CAMLreturn(block);
}

CAMLprim value nod_jit_copy(value v_region, value v_bytes)
{
  CAMLparam2(v_region, v_bytes);
  struct jit_region* region = (struct jit_region*)Data_custom_val(v_region);
  mlsize_t len = caml_string_length(v_bytes);
  if (region->ptr == NULL || region->len < (size_t)len) {
    caml_failwith("jit_copy out of bounds");
  }
#ifdef __APPLE__
  pthread_jit_write_protect_np(0);
#endif
  memcpy(region->ptr, String_val(v_bytes), len);
  CAMLreturn(Val_unit);
}

CAMLprim value nod_jit_make_exec(value v_region)
{
  CAMLparam1(v_region);
  struct jit_region* region = (struct jit_region*)Data_custom_val(v_region);
  if (region->ptr == NULL || region->len == 0) {
    caml_failwith("jit_make_exec invalid region");
  }
#ifdef __APPLE__
  pthread_jit_write_protect_np(1);
#endif
  if (mprotect(region->ptr, region->len, PROT_READ | PROT_EXEC) != 0) {
    caml_failwith("jit_make_exec failed");
  }
  __builtin___clear_cache((char*)region->ptr,
                          (char*)region->ptr + region->len);
  CAMLreturn(Val_unit);
}

CAMLprim value nod_jit_ptr(value v_region)
{
  CAMLparam1(v_region);
  struct jit_region* region = (struct jit_region*)Data_custom_val(v_region);
  CAMLreturn(caml_copy_nativeint((intnat)region->ptr));
}

CAMLprim value nod_jit_call0_i64(value v_ptr)
{
  CAMLparam1(v_ptr);
  int64_t (*fn)(void) = (int64_t (*)(void))(intptr_t)Nativeint_val(v_ptr);
  int64_t result = fn();
  CAMLreturn(caml_copy_int64(result));
}

CAMLprim value nod_jit_call1_i64(value v_ptr, value v_arg0)
{
  CAMLparam2(v_ptr, v_arg0);
  int64_t (*fn)(int64_t) = (int64_t (*)(int64_t))(intptr_t)Nativeint_val(v_ptr);
  int64_t result = fn(Int64_val(v_arg0));
  CAMLreturn(caml_copy_int64(result));
}

CAMLprim value nod_jit_call2_i64(value v_ptr, value v_arg0, value v_arg1)
{
  CAMLparam3(v_ptr, v_arg0, v_arg1);
  int64_t (*fn)(int64_t, int64_t) =
      (int64_t (*)(int64_t, int64_t))(intptr_t)Nativeint_val(v_ptr);
  int64_t result = fn(Int64_val(v_arg0), Int64_val(v_arg1));
  CAMLreturn(caml_copy_int64(result));
}

static int64_t nod_jit_add3(int64_t x)
{
  return x + 3;
}

CAMLprim value nod_jit_add3_ptr(value v_unit)
{
  CAMLparam1(v_unit);
  CAMLreturn(caml_copy_nativeint((intnat)(intptr_t)&nod_jit_add3));
}

extern void* nod_gc_alloc(uint64_t size, const uint64_t* mask,
                          uint64_t mask_len);
extern void nod_gc_collect(void);
extern void nod_gc_push_frame(void* frame, uint64_t count);
extern void nod_gc_pop_frame(void);
extern uint64_t nod_gc_live_bytes(void);

CAMLprim value nod_gc_alloc_ptr(value v_unit)
{
  CAMLparam1(v_unit);
  CAMLreturn(caml_copy_nativeint((intnat)(intptr_t)&nod_gc_alloc));
}

CAMLprim value nod_gc_collect_ptr(value v_unit)
{
  CAMLparam1(v_unit);
  CAMLreturn(caml_copy_nativeint((intnat)(intptr_t)&nod_gc_collect));
}

CAMLprim value nod_gc_push_frame_ptr(value v_unit)
{
  CAMLparam1(v_unit);
  CAMLreturn(caml_copy_nativeint((intnat)(intptr_t)&nod_gc_push_frame));
}

CAMLprim value nod_gc_pop_frame_ptr(value v_unit)
{
  CAMLparam1(v_unit);
  CAMLreturn(caml_copy_nativeint((intnat)(intptr_t)&nod_gc_pop_frame));
}

CAMLprim value nod_gc_live_bytes_ptr(value v_unit)
{
  CAMLparam1(v_unit);
  CAMLreturn(caml_copy_nativeint((intnat)(intptr_t)&nod_gc_live_bytes));
}
