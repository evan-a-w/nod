.intel_syntax noprefix
.text
.globl _factorial
_factorial:
  push rbp
  mov rbp, rsp
  push r14
  push r15
  mov r14, rdi
factorial___root:
  cmp r14, 0
  je factorial__intermediate__root_to_ret_one
factorial__intermediate__root_to_check_one:
  jmp factorial__check_one
factorial__intermediate__root_to_ret_one:
  jmp factorial__ret_one
factorial__check_one:
  mov r15, r14
  sub r15, 1
  cmp r15, 0
  je factorial__intermediate_check_one_to_ret_one
factorial__intermediate_check_one_to_recurse:
  jmp factorial__recurse
factorial__intermediate_check_one_to_ret_one:
factorial__ret_one:
  mov r15, 1
  mov rax, r15
  jmp factorial__factorial__epilogue
factorial__recurse:
  mov rdi, r15
  call _factorial
  mov r15, rax
  mov rax, r14
  imul r15
  mov r15, rax
  mov rax, r15
factorial__factorial__epilogue:
  sub rbp, 16
  mov rsp, rbp
  pop r15
  pop r14
  pop rbp
  ret
