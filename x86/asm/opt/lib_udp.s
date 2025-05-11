	.file	"lib_udp.c"
	.text
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"socket"
.LC1:
	.string	"bind"
	.text
	.globl	udp_server
	.type	udp_server, @function
udp_server:
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
	subq	$32, %rsp
	.cfi_def_cfa_offset 64
	movq	%rdi, %r12
	movl	%esi, %ebp
	movq	%fs:40, %rax
	movq	%rax, 24(%rsp)
	xorl	%eax, %eax
	movl	$17, %edx
	movl	$2, %esi
	movl	$2, %edi
	call	socket@PLT
	testl	%eax, %eax
	js	.L6
	movl	%eax, %ebx
	movl	%ebp, %esi
	movl	%eax, %edi
	call	sock_optimize@PLT
	movq	%rsp, %rsi
	movq	$0, (%rsp)
	movq	$0, 8(%rsp)
	movw	$2, (%rsp)
	movl	%r12d, %eax
	rolw	$8, %ax
	movw	%ax, 2(%rsp)
	movl	$16, %edx
	movl	%ebx, %edi
	call	bind@PLT
	testl	%eax, %eax
	js	.L7
	movq	24(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L8
	movl	%ebx, %eax
	addq	$32, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 32
	popq	%rbx
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	ret
.L6:
	.cfi_restore_state
	leaq	.LC0(%rip), %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L7:
	leaq	.LC1(%rip), %rdi
	call	perror@PLT
	movl	$2, %edi
	call	exit@PLT
.L8:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE72:
	.size	udp_server, .-udp_server
	.globl	udp_done
	.type	udp_done, @function
udp_done:
.LFB73:
	.cfi_startproc
	endbr64
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	movl	$1, %esi
	call	pmap_unset@PLT
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE73:
	.size	udp_done, .-udp_done
	.section	.rodata.str1.1
.LC2:
	.string	"connect"
	.text
	.globl	udp_connect
	.type	udp_connect, @function
udp_connect:
.LFB74:
	.cfi_startproc
	endbr64
	pushq	%r13
	.cfi_def_cfa_offset 16
	.cfi_offset 13, -16
	pushq	%r12
	.cfi_def_cfa_offset 24
	.cfi_offset 12, -24
	pushq	%rbp
	.cfi_def_cfa_offset 32
	.cfi_offset 6, -32
	pushq	%rbx
	.cfi_def_cfa_offset 40
	.cfi_offset 3, -40
	subq	$40, %rsp
	.cfi_def_cfa_offset 80
	movq	%rdi, %r12
	movq	%rsi, %rbp
	movl	%edx, %r13d
	movq	%fs:40, %rax
	movq	%rax, 24(%rsp)
	xorl	%eax, %eax
	movl	$17, %edx
	movl	$2, %esi
	movl	$2, %edi
	call	socket@PLT
	testl	%eax, %eax
	js	.L17
	movl	%eax, %ebx
	movl	%r13d, %esi
	movl	%eax, %edi
	call	sock_optimize@PLT
	movq	%r12, %rdi
	call	gethostbyname@PLT
	testq	%rax, %rax
	je	.L18
	movq	%rsp, %r12
	movq	$0, (%rsp)
	movq	$0, 8(%rsp)
	movw	$2, (%rsp)
	movslq	20(%rax), %rdx
	movq	24(%rax), %rax
	leaq	4(%rsp), %rdi
	movl	$12, %ecx
	movq	(%rax), %rsi
	call	__memmove_chk@PLT
	rolw	$8, %bp
	movw	%bp, 2(%rsp)
	movl	$16, %edx
	movq	%r12, %rsi
	movl	%ebx, %edi
	call	connect@PLT
	testl	%eax, %eax
	js	.L19
	movq	24(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L20
	movl	%ebx, %eax
	addq	$40, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 40
	popq	%rbx
	.cfi_def_cfa_offset 32
	popq	%rbp
	.cfi_def_cfa_offset 24
	popq	%r12
	.cfi_def_cfa_offset 16
	popq	%r13
	.cfi_def_cfa_offset 8
	ret
.L17:
	.cfi_restore_state
	leaq	.LC0(%rip), %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L18:
	movq	%r12, %rdi
	call	perror@PLT
	movl	$2, %edi
	call	exit@PLT
.L19:
	leaq	.LC2(%rip), %rdi
	call	perror@PLT
	movl	$4, %edi
	call	exit@PLT
.L20:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE74:
	.size	udp_connect, .-udp_connect
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
