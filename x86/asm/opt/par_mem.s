	.file	"par_mem.c"
	.text
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC0:
	.string	"[-L <line size>] [-M len[K|M]] [-W <warmup>] [-N <repetitions>]\n"
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC1:
	.string	"L:M:W:N:"
.LC4:
	.string	"%.6f %.2f\n"
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
	subq	$248, %rsp
	.cfi_def_cfa_offset 304
	movl	%edi, %r14d
	movq	%rsi, %r13
	movq	%fs:40, %rax
	movq	%rax, 232(%rsp)
	xorl	%eax, %eax
	movl	$0, %edi
	call	get_enough@PLT
	cmpl	$999999, %eax
	movl	$1, %ebx
	movl	$11, %eax
	cmovle	%eax, %ebx
	call	getpagesize@PLT
	leal	15(%rax), %edx
	testl	%eax, %eax
	cmovns	%eax, %edx
	sarl	$4, %edx
	movslq	%edx, %rdx
	movq	%rdx, 168(%rsp)
	cltq
	movq	%rax, 176(%rsp)
	movl	$67108864, %ebp
	movl	$0, %r12d
	leaq	.LC1(%rip), %r15
	jmp	.L3
.L5:
	cmpl	$87, %eax
	jne	.L8
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	movl	%eax, %r12d
	jmp	.L3
.L6:
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	cltq
	movl	$8, %edx
	cmpq	%rdx, %rax
	cmovb	%rdx, %rax
	movq	%rax, 168(%rsp)
.L3:
	movq	%r15, %rdx
	movq	%r13, %rsi
	movl	%r14d, %edi
	call	mygetopt@PLT
	cmpl	$-1, %eax
	je	.L22
	cmpl	$78, %eax
	je	.L4
	jg	.L5
	cmpl	$76, %eax
	je	.L6
	cmpl	$77, %eax
	jne	.L8
	movq	myoptarg(%rip), %rdi
	call	bytes@PLT
	movq	%rax, %rbp
	jmp	.L3
.L4:
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	movl	%eax, %ebx
	jmp	.L3
.L8:
	leaq	.LC0(%rip), %rdx
	movq	%r13, %rsi
	movl	%r14d, %edi
	call	lmbench_usage@PLT
	jmp	.L3
.L22:
	movl	168(%rsp), %r13d
	sall	$4, %r13d
	movslq	%r13d, %rdi
	cmpq	%rdi, %rbp
	jb	.L13
	movq	%rsp, %r14
	leaq	.LC4(%rip), %r15
	jmp	.L16
.L14:
	addl	%r13d, %r13d
	movslq	%r13d, %rdi
	cmpq	%rbp, %rdi
	ja	.L13
.L16:
	movq	%r14, %rcx
	movl	%ebx, %edx
	movl	%r12d, %esi
	call	par_mem@PLT
	movapd	%xmm0, %xmm1
	pxor	%xmm2, %xmm2
	comisd	%xmm2, %xmm0
	jbe	.L14
	pxor	%xmm0, %xmm0
	cvtsi2sdl	%r13d, %xmm0
	divsd	.LC3(%rip), %xmm0
	movq	%r15, %rdx
	movl	$1, %esi
	movq	stderr(%rip), %rdi
	movl	$2, %eax
	call	__fprintf_chk@PLT
	jmp	.L14
.L13:
	movl	$0, %edi
	call	exit@PLT
	.cfi_endproc
.LFE72:
	.size	main, .-main
	.globl	id
	.section	.rodata.str1.1
.LC5:
	.string	"$Id$\n"
	.section	.data.rel.local,"aw"
	.align 8
	.type	id, @object
	.size	id, 8
id:
	.quad	.LC5
	.section	.rodata.cst8,"aM",@progbits,8
	.align 8
.LC3:
	.long	0
	.long	1093567616
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
