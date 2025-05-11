	.file	"lib_unix.c"
	.text
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"socket"
.LC1:
	.string	"bind"
.LC2:
	.string	"listen"
	.text
	.globl	unix_server
	.type	unix_server, @function
unix_server:
.LFB72:
	.cfi_startproc
	endbr64
	pushq	%r12
	.cfi_def_cfa_offset 16
	.cfi_offset 12, -16
	pushq	%rbp
	.cfi_def_cfa_offset 24
	.cfi_offset 6, -24
	pushq	%rbx
	.cfi_def_cfa_offset 32
	.cfi_offset 3, -32
	addq	$-128, %rsp
	.cfi_def_cfa_offset 160
	movq	%rdi, %r12
	movq	%fs:40, %rax
	movq	%rax, 120(%rsp)
	xorl	%eax, %eax
	movl	$0, %edx
	movl	$1, %esi
	movl	$1, %edi
	call	socket@PLT
	testl	%eax, %eax
	js	.L7
	movl	%eax, %ebx
	movq	%rsp, %rbp
	movl	$13, %ecx
	movl	$0, %eax
	movq	%rbp, %rdi
	rep stosq
	movl	$0, (%rdi)
	movw	$0, 4(%rdi)
	movw	$1, (%rsp)
	leaq	2(%rsp), %rdi
	movl	$108, %edx
	movq	%r12, %rsi
	call	__strcpy_chk@PLT
	movl	$110, %edx
	movq	%rbp, %rsi
	movl	%ebx, %edi
	call	bind@PLT
	testl	%eax, %eax
	js	.L8
	movl	$100, %esi
	movl	%ebx, %edi
	call	listen@PLT
	testl	%eax, %eax
	js	.L9
	movq	120(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L10
	movl	%ebx, %eax
	subq	$-128, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 32
	popq	%rbx
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	ret
.L7:
	.cfi_restore_state
	leaq	.LC0(%rip), %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L8:
	leaq	.LC1(%rip), %rdi
	call	perror@PLT
	movl	$2, %edi
	call	exit@PLT
.L9:
	leaq	.LC2(%rip), %rdi
	call	perror@PLT
	movl	$4, %edi
	call	exit@PLT
.L10:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE72:
	.size	unix_server, .-unix_server
	.globl	unix_done
	.type	unix_done, @function
unix_done:
.LFB73:
	.cfi_startproc
	endbr64
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movq	%rsi, %rbx
	call	close@PLT
	movq	%rbx, %rdi
	call	unlink@PLT
	movl	$0, %eax
	popq	%rbx
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE73:
	.size	unix_done, .-unix_done
	.section	.rodata.str1.1
.LC3:
	.string	"accept"
	.text
	.globl	unix_accept
	.type	unix_accept, @function
unix_accept:
.LFB74:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushq	%rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	subq	$152, %rsp
	.cfi_def_cfa_offset 176
	movl	%edi, %ebx
	movq	%fs:40, %rax
	movq	%rax, 136(%rsp)
	xorl	%eax, %eax
	movl	$110, 12(%rsp)
	leaq	16(%rsp), %rdx
	movl	$13, %ecx
	movq	%rdx, %rdi
	rep stosq
	movl	$0, (%rdi)
	movw	$0, 4(%rdi)
	leaq	12(%rsp), %rbp
.L14:
	leaq	16(%rsp), %rsi
	movq	%rbp, %rdx
	movl	%ebx, %edi
	call	accept@PLT
	testl	%eax, %eax
	jns	.L13
	call	__errno_location@PLT
	cmpl	$4, (%rax)
	je	.L14
	leaq	.LC3(%rip), %rdi
	call	perror@PLT
	movl	$6, %edi
	call	exit@PLT
.L13:
	movq	136(%rsp), %rdx
	subq	%fs:40, %rdx
	jne	.L19
	addq	$152, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
.L19:
	.cfi_restore_state
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE74:
	.size	unix_accept, .-unix_accept
	.section	.rodata.str1.1
.LC4:
	.string	"connect"
	.text
	.globl	unix_connect
	.type	unix_connect, @function
unix_connect:
.LFB75:
	.cfi_startproc
	endbr64
	pushq	%r12
	.cfi_def_cfa_offset 16
	.cfi_offset 12, -16
	pushq	%rbp
	.cfi_def_cfa_offset 24
	.cfi_offset 6, -24
	pushq	%rbx
	.cfi_def_cfa_offset 32
	.cfi_offset 3, -32
	addq	$-128, %rsp
	.cfi_def_cfa_offset 160
	movq	%rdi, %r12
	movq	%fs:40, %rax
	movq	%rax, 120(%rsp)
	xorl	%eax, %eax
	movl	$0, %edx
	movl	$1, %esi
	movl	$1, %edi
	call	socket@PLT
	testl	%eax, %eax
	js	.L25
	movl	%eax, %ebx
	movq	%rsp, %rbp
	movl	$13, %ecx
	movl	$0, %eax
	movq	%rbp, %rdi
	rep stosq
	movl	$0, (%rdi)
	movw	$0, 4(%rdi)
	movw	$1, (%rsp)
	leaq	2(%rsp), %rdi
	movl	$108, %edx
	movq	%r12, %rsi
	call	__strcpy_chk@PLT
	movl	$110, %edx
	movq	%rbp, %rsi
	movl	%ebx, %edi
	call	connect@PLT
	testl	%eax, %eax
	js	.L26
	movq	120(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L27
	movl	%ebx, %eax
	subq	$-128, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 32
	popq	%rbx
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	ret
.L25:
	.cfi_restore_state
	leaq	.LC0(%rip), %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L26:
	leaq	.LC4(%rip), %rdi
	call	perror@PLT
	movl	$4, %edi
	call	exit@PLT
.L27:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE75:
	.size	unix_connect, .-unix_connect
	.ident	"GCC: (Ubuntu 11.4.0-1ubuntu1~22.04) 11.4.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	1f - 0f
	.long	4f - 1f
	.long	5
0:
	.string	"GNU"
1:
	.align 8
	.long	0xc0000002
	.long	3f - 2f
2:
	.long	0x3
3:
	.align 8
4:
