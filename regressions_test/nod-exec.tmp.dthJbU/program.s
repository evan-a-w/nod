.text
.globl _root
_root:
  mov x14, #32
  sub sp, sp, x14
  str x26, [sp]
  str x27, [sp, #8]
  str x28, [sp, #16]
  str x29, [sp, #24]
  mov x29, sp
root__start:
  mov x27, #1
  mov x28, #0
  mov x26, x27
  mov x28, x28
root__check:
root__body:
  mov x14, #1
  add x27, x14, x28
  mov x14, #1
  add x28, x14, x26
  mov x26, x28
  mov x28, x27
  b root__check
