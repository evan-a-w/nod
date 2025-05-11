	.file	"par_mem.c"
	.text
	.globl	id
	.section	.rodata
.LC0:
	.string	"$Id$\n"
	.section	.data.rel.local,"aw"
	.align 8
	.type	id, @object
	.size	id, 8
id:
	.quad	.LC0
	.section	.rodata
	.align 8
.LC1:
	.string	"[-L <line size>] [-M len[K|M]] [-W <warmup>] [-N <repetitions>]\n"
.LC2:
	.string	"L:M:W:N:"
.LC5:
	.string	"%.6f %.2f\n"
	.text
	.globl	main
	.type	main, @function
main:
.LFB8:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$304, %rsp
	movl	%edi, -292(%rbp)
	movq	%rsi, -304(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movl	$0, -276(%rbp)
	movl	$0, %edi
	call	get_enough@PLT
	cmpl	$999999, %eax
	jle	.L2
	movl	$1, %eax
	jmp	.L3
.L2:
	movl	$11, %eax
.L3:
	movl	%eax, -272(%rbp)
	movq	$67108864, -264(%rbp)
	leaq	.LC1(%rip), %rax
	movq	%rax, -256(%rbp)
	call	getpagesize@PLT
	leal	15(%rax), %edx
	testl	%eax, %eax
	cmovs	%edx, %eax
	sarl	$4, %eax
	cltq
	movq	%rax, -72(%rbp)
	call	getpagesize@PLT
	cltq
	movq	%rax, -64(%rbp)
	jmp	.L4
.L11:
	cmpl	$87, -268(%rbp)
	je	.L5
	cmpl	$87, -268(%rbp)
	jg	.L6
	cmpl	$78, -268(%rbp)
	je	.L7
	cmpl	$78, -268(%rbp)
	jg	.L6
	cmpl	$76, -268(%rbp)
	je	.L8
	cmpl	$77, -268(%rbp)
	je	.L9
	jmp	.L6
.L8:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	cltq
	movq	%rax, -72(%rbp)
	movq	-72(%rbp), %rax
	cmpq	$7, %rax
	ja	.L4
	movq	$8, -72(%rbp)
	jmp	.L4
.L9:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	bytes@PLT
	movq	%rax, -264(%rbp)
	jmp	.L4
.L5:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -276(%rbp)
	jmp	.L4
.L7:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -272(%rbp)
	jmp	.L4
.L6:
	movq	-256(%rbp), %rdx
	movq	-304(%rbp), %rcx
	movl	-292(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	lmbench_usage@PLT
	nop
.L4:
	movq	-304(%rbp), %rcx
	movl	-292(%rbp), %eax
	leaq	.LC2(%rip), %rdx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	mygetopt@PLT
	movl	%eax, -268(%rbp)
	cmpl	$-1, -268(%rbp)
	jne	.L11
	movq	-72(%rbp), %rax
	sall	$4, %eax
	movl	%eax, -280(%rbp)
	jmp	.L12
.L15:
	movl	-280(%rbp), %eax
	cltq
	leaq	-240(%rbp), %rcx
	movl	-272(%rbp), %edx
	movl	-276(%rbp), %esi
	movq	%rax, %rdi
	call	par_mem@PLT
	movq	%xmm0, %rax
	movq	%rax, -248(%rbp)
	movsd	-248(%rbp), %xmm0
	pxor	%xmm1, %xmm1
	comisd	%xmm1, %xmm0
	jbe	.L13
	pxor	%xmm0, %xmm0
	cvtsi2sdl	-280(%rbp), %xmm0
	movsd	.LC4(%rip), %xmm1
	divsd	%xmm1, %xmm0
	movq	%xmm0, %rdx
	movq	stderr(%rip), %rax
	movsd	-248(%rbp), %xmm0
	movapd	%xmm0, %xmm1
	movq	%rdx, %xmm0
	leaq	.LC5(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	movl	$2, %eax
	call	fprintf@PLT
.L13:
	sall	-280(%rbp)
.L12:
	movl	-280(%rbp), %eax
	cltq
	cmpq	%rax, -264(%rbp)
	jnb	.L15
	movl	$0, %edi
	call	exit@PLT
	.cfi_endproc
.LFE8:
	.size	main, .-main
	.section	.rodata
	.align 8
.LC4:
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
