.text
.globl fact
fact:
  mov x14, #32
  sub sp, sp, x14
  str x27, [sp]
  str x28, [sp, #8]
  str x29, [sp, #16]
  str x30, [sp, #24]
  mov x29, sp
  mov x0, x0
  mov x27, x0
fact___root:
  cmp x27, #0
  b.eq fact__intermediate__root_to_else0
fact__intermediate__root_to_then0:
  b fact__then0
fact__intermediate__root_to_else0:
  b fact__else0
fact__then0:
  mov x14, #1
  sub x28, x27, x14
  mov x0, x28
  bl fact
  mov x28, x0
  mul x28, x27, x28
  mov x0, x28
  b fact__fact__epilogue
fact__else0:
  mov x28, #1
  mov x0, x28
fact__fact__epilogue:
  mov x0, x0
  mov sp, x29
  ldr x27, [sp]
  ldr x28, [sp, #8]
  ldr x29, [sp, #16]
  ldr x30, [sp, #24]
  mov x14, #32
  add sp, sp, x14
  ret

.globl root
root:
  mov x14, #32
  sub sp, sp, x14
  str x28, [sp]
  str x29, [sp, #8]
  str x30, [sp, #16]
  mov x29, sp
  mov x0, x0
  mov x28, x0
root___root:
  mov x0, x28
  bl fact
  mov x28, x0
  mov x0, x28
root__root__epilogue:
  mov x0, x0
  mov sp, x29
  ldr x28, [sp]
  ldr x29, [sp, #8]
  ldr x30, [sp, #16]
  mov x14, #32
  add sp, sp, x14
  ret
.section .note.GNU-stack,"",@progbits
