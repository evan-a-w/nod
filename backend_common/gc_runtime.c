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
