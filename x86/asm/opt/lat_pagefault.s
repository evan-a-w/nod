	.file	"lat_pagefault.c"
	.text
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"%d"
.LC1:
	.string	"malloc"
.LC2:
	.string	"%s%d"
.LC3:
	.string	"Could not copy file"
.LC4:
	.string	"x"
.LC5:
	.string	"lat_pagefault: %s too small\n"
.LC6:
	.string	"msync"
	.text
	.globl	initialize
	.type	initialize, @function
initialize:
.LFB73:
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
	subq	$288, %rsp
	.cfi_def_cfa_offset 320
	movq	%fs:40, %rax
	movq	%rax, 280(%rsp)
	xorl	%eax, %eax
	testq	%rdi, %rdi
	jne	.L1
	movq	%rsi, %rbx
	cmpl	$0, 12(%rsi)
	je	.L3
	call	getpid@PLT
	movl	%eax, %r8d
	leaq	144(%rsp), %r12
	leaq	.LC0(%rip), %rcx
	movl	$128, %edx
	movl	$1, %esi
	movq	%r12, %rdi
	movl	$0, %eax
	call	__sprintf_chk@PLT
	movq	16(%rbx), %rdi
	call	strlen@PLT
	movq	%rax, %rbp
	movq	%r12, %rdi
	call	strlen@PLT
	leaq	1(%rbp,%rax), %rdi
	call	malloc@PLT
	movq	%rax, %rbp
	testq	%rax, %rax
	je	.L12
	call	getpid@PLT
	movl	%eax, %r9d
	movq	16(%rbx), %r8
	leaq	.LC2(%rip), %rcx
	movq	$-1, %rdx
	movl	$1, %esi
	movq	%rbp, %rdi
	movl	$0, %eax
	call	__sprintf_chk@PLT
	movq	16(%rbx), %rdi
	movl	$384, %edx
	movq	%rbp, %rsi
	call	cp@PLT
	testl	%eax, %eax
	js	.L13
	movq	%rbp, 16(%rbx)
.L3:
	movq	16(%rbx), %rdi
	movl	$0, %esi
	movl	$0, %eax
	call	open@PLT
	movl	%eax, (%rbx)
	cmpl	$-1, %eax
	je	.L14
	cmpl	$0, 12(%rbx)
	jne	.L15
.L7:
	movq	%rsp, %rsi
	movl	(%rbx), %edi
	call	fstat@PLT
	cmpl	$-1, %eax
	je	.L16
	call	getpid@PLT
	movl	%eax, %edi
	call	srand@PLT
	call	getpagesize@PLT
	movl	%eax, %esi
	movq	48(%rsp), %rdi
	movl	%edi, %eax
	cltd
	idivl	%esi
	movl	%edi, %eax
	subl	%edx, %eax
	movl	%eax, 4(%rbx)
	cltd
	idivl	%esi
	movl	%eax, 8(%rbx)
	movslq	%esi, %rsi
	movslq	%eax, %rdi
	call	permutation@PLT
	movq	%rax, 32(%rbx)
	movl	4(%rbx), %esi
	cmpl	$1048575, %esi
	jle	.L17
	movslq	%esi, %rsi
	movl	$0, %r9d
	movl	(%rbx), %r8d
	movl	$1, %ecx
	movl	$1, %edx
	movl	$0, %edi
	call	mmap@PLT
	movq	%rax, %rdi
	movq	%rax, 24(%rbx)
	movslq	4(%rbx), %rsi
	movl	$2, %edx
	call	msync@PLT
	testl	%eax, %eax
	jne	.L18
.L1:
	movq	280(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L19
	addq	$288, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 32
	popq	%rbx
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	ret
.L12:
	.cfi_restore_state
	leaq	.LC1(%rip), %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L13:
	leaq	.LC3(%rip), %rdi
	call	perror@PLT
	movq	%rbp, %rdi
	call	unlink@PLT
	movl	$1, %edi
	call	exit@PLT
.L14:
	leaq	.LC4(%rip), %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L15:
	movq	16(%rbx), %rdi
	call	unlink@PLT
	jmp	.L7
.L16:
	leaq	.LC4(%rip), %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L17:
	movq	16(%rbx), %rcx
	leaq	.LC5(%rip), %rdx
	movl	$1, %esi
	movq	stderr(%rip), %rdi
	movl	$0, %eax
	call	__fprintf_chk@PLT
	movl	$1, %edi
	call	exit@PLT
.L18:
	leaq	.LC6(%rip), %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L19:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE73:
	.size	initialize, .-initialize
	.globl	cleanup
	.type	cleanup, @function
cleanup:
.LFB74:
	.cfi_startproc
	endbr64
	testq	%rdi, %rdi
	je	.L27
	ret
.L27:
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movq	%rsi, %rbx
	movslq	4(%rsi), %rsi
	movq	24(%rbx), %rdi
	call	munmap@PLT
	movl	(%rbx), %edi
	testl	%edi, %edi
	jns	.L28
.L22:
	movq	32(%rbx), %rdi
	call	free@PLT
	popq	%rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	ret
.L28:
	.cfi_restore_state
	call	close@PLT
	jmp	.L22
	.cfi_endproc
.LFE74:
	.size	cleanup, .-cleanup
	.globl	benchmark
	.type	benchmark, @function
benchmark:
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
	movq	%rdi, %r12
	movq	%rsi, %rbp
	movl	$0, %ebx
	jmp	.L30
.L33:
	movq	24(%rbp), %rsi
	movq	32(%rbp), %rax
	leal	-1(%rdx), %edx
	leaq	8(%rax,%rdx,8), %rcx
.L31:
	movq	(%rax), %rdx
	movsbl	(%rsi,%rdx), %edx
	addl	%edx, %ebx
	addq	$8, %rax
	cmpq	%rcx, %rax
	jne	.L31
.L34:
	movslq	4(%rbp), %rsi
	movq	24(%rbp), %rdi
	call	munmap@PLT
	movslq	4(%rbp), %rsi
	movl	$0, %r9d
	movl	0(%rbp), %r8d
	movl	$1, %ecx
	movl	$1, %edx
	movl	$0, %edi
	call	mmap@PLT
	movq	%rax, %rdi
	movq	%rax, 24(%rbp)
	movslq	4(%rbp), %rsi
	movl	$2, %edx
	call	msync@PLT
	subq	$1, %r12
	testl	%eax, %eax
	jne	.L38
.L30:
	testq	%r12, %r12
	je	.L32
	movl	8(%rbp), %edx
	testl	%edx, %edx
	jg	.L33
	jmp	.L34
.L38:
	leaq	.LC6(%rip), %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L32:
	movl	%ebx, %edi
	call	use_int@PLT
	popq	%rbx
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE75:
	.size	benchmark, .-benchmark
	.globl	benchmark_mmap
	.type	benchmark_mmap, @function
benchmark_mmap:
.LFB76:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushq	%rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	subq	$8, %rsp
	.cfi_def_cfa_offset 32
	movq	%rdi, %rbp
	movq	%rsi, %rbx
.L40:
	testq	%rbp, %rbp
	je	.L44
	movslq	4(%rbx), %rsi
	movq	24(%rbx), %rdi
	call	munmap@PLT
	movslq	4(%rbx), %rsi
	movl	$0, %r9d
	movl	(%rbx), %r8d
	movl	$1, %ecx
	movl	$1, %edx
	movl	$0, %edi
	call	mmap@PLT
	movq	%rax, %rdi
	movq	%rax, 24(%rbx)
	movslq	4(%rbx), %rsi
	movl	$2, %edx
	call	msync@PLT
	subq	$1, %rbp
	testl	%eax, %eax
	je	.L40
	leaq	.LC6(%rip), %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L44:
	movl	$0, %edi
	call	use_int@PLT
	addq	$8, %rsp
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE76:
	.size	benchmark_mmap, .-benchmark_mmap
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC7:
	.string	"[-C] [-P <parallel>] [-W <warmup>] [-N <repetitions>] file\n"
	.section	.rodata.str1.1
.LC8:
	.string	"P:W:N:C"
.LC10:
	.string	"Pagefaults on %s"
	.text
	.globl	main
	.type	main, @function
main:
.LFB72:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$2280, %rsp
	.cfi_offset 15, -24
	.cfi_offset 14, -32
	.cfi_offset 13, -40
	.cfi_offset 12, -48
	.cfi_offset 3, -56
	movl	%edi, -2312(%rbp)
	movq	%rsi, %rbx
	movq	%fs:40, %rax
	movq	%rax, -56(%rbp)
	xorl	%eax, %eax
	movl	$0, -2292(%rbp)
	movl	$-1, %r14d
	movl	$0, %r13d
	movl	$1, -2316(%rbp)
	leaq	.LC8(%rip), %r12
	leaq	.LC7(%rip), %r15
	jmp	.L46
.L48:
	cmpl	$87, %eax
	jne	.L51
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	movl	%eax, %r13d
.L46:
	movq	%r12, %rdx
	movq	%rbx, %rsi
	movl	-2312(%rbp), %edi
	call	mygetopt@PLT
	cmpl	$-1, %eax
	je	.L71
	cmpl	$80, %eax
	je	.L47
	jg	.L48
	cmpl	$67, %eax
	je	.L49
	cmpl	$78, %eax
	jne	.L51
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	movl	%eax, %r14d
	jmp	.L46
.L47:
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	movl	%eax, -2316(%rbp)
	testl	%eax, %eax
	jg	.L46
	movq	%r15, %rdx
	movq	%rbx, %rsi
	movl	-2312(%rbp), %edi
	call	lmbench_usage@PLT
	jmp	.L46
.L49:
	movl	$1, -2292(%rbp)
	jmp	.L46
.L51:
	movq	%r15, %rdx
	movq	%rbx, %rsi
	movl	-2312(%rbp), %edi
	call	lmbench_usage@PLT
	jmp	.L46
.L71:
	movl	-2312(%rbp), %edi
	leal	-1(%rdi), %eax
	cmpl	myoptind(%rip), %eax
	jne	.L72
.L55:
	movslq	myoptind(%rip), %rax
	movq	(%rbx,%rax,8), %rdi
	movq	%rdi, -2288(%rbp)
	leaq	-2256(%rbp), %rsi
	call	stat@PLT
	cmpl	$-1, %eax
	je	.L73
	call	getpagesize@PLT
	movslq	%eax, %rcx
	movq	-2208(%rbp), %rax
	movl	$0, %edx
	divq	%rcx
	movl	%eax, -2296(%rbp)
	leaq	-2304(%rbp), %rax
	pushq	%rax
	pushq	%r14
	movl	%r13d, %r9d
	movl	-2316(%rbp), %r8d
	movl	$0, %ecx
	leaq	cleanup(%rip), %rdx
	leaq	benchmark_mmap(%rip), %rsi
	leaq	initialize(%rip), %rdi
	call	benchmp@PLT
	call	usecs_spent@PLT
	movq	%rax, %rbx
	call	get_n@PLT
	testq	%rbx, %rbx
	js	.L57
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rbx, %xmm1
.L58:
	testq	%rax, %rax
	js	.L59
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
.L60:
	divsd	%xmm0, %xmm1
	movsd	%xmm1, -2312(%rbp)
	leaq	-2304(%rbp), %rax
	pushq	%rax
	pushq	%r14
	movl	%r13d, %r9d
	movl	-2316(%rbp), %r8d
	movl	$0, %ecx
	leaq	cleanup(%rip), %rdx
	leaq	benchmark(%rip), %rsi
	leaq	initialize(%rip), %rdi
	call	benchmp@PLT
	addq	$32, %rsp
	call	usecs_spent@PLT
	movq	%rax, %rbx
	call	get_n@PLT
	testq	%rbx, %rbx
	js	.L61
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rbx, %xmm1
.L62:
	testq	%rax, %rax
	js	.L63
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
.L64:
	divsd	%xmm0, %xmm1
	movq	%xmm1, %rbx
	call	get_n@PLT
	testq	%rax, %rax
	js	.L65
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
.L66:
	movq	%rbx, %xmm1
	subsd	-2312(%rbp), %xmm1
	mulsd	%xmm1, %xmm0
	comisd	.LC9(%rip), %xmm0
	jnb	.L67
	cvttsd2siq	%xmm0, %rdi
.L68:
	call	settime@PLT
	leaq	-2112(%rbp), %r15
	movq	-2288(%rbp), %r8
	leaq	.LC10(%rip), %rcx
	movl	$2048, %edx
	movl	$1, %esi
	movq	%r15, %rdi
	movl	$0, %eax
	call	__sprintf_chk@PLT
	movslq	-2296(%rbp), %rbx
	call	get_n@PLT
	imulq	%rax, %rbx
	movq	%rbx, %rsi
	movq	%r15, %rdi
	call	micro@PLT
	movq	-56(%rbp), %rax
	subq	%fs:40, %rax
	jne	.L74
	movl	$0, %eax
	leaq	-40(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_remember_state
	.cfi_def_cfa 7, 8
	ret
.L72:
	.cfi_restore_state
	leaq	.LC7(%rip), %rdx
	movq	%rbx, %rsi
	call	lmbench_usage@PLT
	jmp	.L55
.L73:
	leaq	.LC4(%rip), %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L57:
	movq	%rbx, %rdx
	shrq	%rdx
	andl	$1, %ebx
	orq	%rbx, %rdx
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rdx, %xmm1
	addsd	%xmm1, %xmm1
	jmp	.L58
.L59:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
	jmp	.L60
.L61:
	movq	%rbx, %rdx
	shrq	%rdx
	andl	$1, %ebx
	orq	%rbx, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
	movapd	%xmm0, %xmm1
	jmp	.L62
.L63:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
	jmp	.L64
.L65:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
	jmp	.L66
.L67:
	subsd	.LC9(%rip), %xmm0
	cvttsd2siq	%xmm0, %rdi
	btcq	$63, %rdi
	jmp	.L68
.L74:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE72:
	.size	main, .-main
	.globl	id
	.section	.rodata.str1.1
.LC11:
	.string	"$Id$\n"
	.section	.data.rel.local,"aw"
	.align 8
	.type	id, @object
	.size	id, 8
id:
	.quad	.LC11
	.section	.rodata.cst8,"aM",@progbits,8
	.align 8
.LC9:
	.long	0
	.long	1138753536
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
