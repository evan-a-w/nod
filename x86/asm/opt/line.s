	.file	"line.c"
	.text
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC0:
	.string	"[-v] [-W <warmup>] [-N <repetitions>][-M len[K|M]]\n"
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC1:
	.string	"avM:W:N:"
.LC2:
	.string	"cache line size: %d bytes\n"
.LC3:
	.string	"%d\n"
	.text
	.globl	main
	.type	main, @function
main:
.LFB72:
	.cfi_startproc
	endbr64
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$264, %rsp
	.cfi_def_cfa_offset 320
	movl	%edi, %ebp
	movq	%rsi, %rbx
	movq	%fs:40, %rax
	movq	%rax, 248(%rsp)
	xorl	%eax, %eax
	movl	$0, %edi
	call	get_enough@PLT
	cmpl	$999999, %eax
	movl	$1, %edx
	movl	$11, %eax
	cmovg	%edx, %eax
	movl	%eax, 12(%rsp)
	movq	$8, 184(%rsp)
	call	getpagesize@PLT
	cltq
	movq	%rax, 192(%rsp)
	movq	$67108864, (%rsp)
	movl	$0, 8(%rsp)
	movl	$0, %r13d
	leaq	.LC1(%rip), %r12
	leaq	.LC0(%rip), %r15
	movl	$1, %r14d
	jmp	.L9
.L5:
	cmpl	$118, %eax
	jne	.L8
	movl	%r14d, %r13d
.L9:
	movq	%r12, %rdx
	movq	%rbx, %rsi
	movl	%ebp, %edi
	call	mygetopt@PLT
	cmpl	$-1, %eax
	je	.L18
	cmpl	$87, %eax
	je	.L4
	jg	.L5
	cmpl	$77, %eax
	je	.L6
	cmpl	$78, %eax
	jne	.L8
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	movl	%eax, 12(%rsp)
	jmp	.L9
.L6:
	movq	myoptarg(%rip), %rdi
	call	bytes@PLT
	movq	%rax, (%rsp)
	jmp	.L9
.L4:
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	movl	%eax, 8(%rsp)
	jmp	.L9
.L8:
	movq	%r15, %rdx
	movq	%rbx, %rsi
	movl	%ebp, %edi
	call	lmbench_usage@PLT
	jmp	.L9
.L18:
	leaq	16(%rsp), %rcx
	movl	12(%rsp), %edx
	movl	8(%rsp), %esi
	movq	(%rsp), %rdi
	call	line_find@PLT
	movl	%eax, %edx
	testl	%eax, %eax
	jle	.L12
	testl	%r13d, %r13d
	je	.L13
	leaq	.LC2(%rip), %rsi
	movl	$1, %edi
	movl	$0, %eax
	call	__printf_chk@PLT
.L12:
	movq	248(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L19
	movl	$0, %eax
	addq	$264, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
.L13:
	.cfi_restore_state
	leaq	.LC3(%rip), %rsi
	movl	$1, %edi
	movl	$0, %eax
	call	__printf_chk@PLT
	jmp	.L12
.L19:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE72:
	.size	main, .-main
	.globl	id
	.section	.rodata.str1.1
.LC4:
	.string	"$Id$\n"
	.section	.data.rel.local,"aw"
	.align 8
	.type	id, @object
	.size	id, 8
id:
	.quad	.LC4
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
