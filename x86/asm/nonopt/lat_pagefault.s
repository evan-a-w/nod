	.file	"lat_pagefault.c"
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
	.string	"[-C] [-P <parallel>] [-W <warmup>] [-N <repetitions>] file\n"
.LC2:
	.string	"P:W:N:C"
.LC3:
	.string	"x"
.LC5:
	.string	"Pagefaults on %s"
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
	pushq	%rbx
	subq	$2344, %rsp
	.cfi_offset 3, -24
	movl	%edi, -2324(%rbp)
	movq	%rsi, -2336(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -24(%rbp)
	xorl	%eax, %eax
	movl	$1, -2312(%rbp)
	movl	$0, -2308(%rbp)
	movl	$-1, -2304(%rbp)
	leaq	.LC1(%rip), %rax
	movq	%rax, -2296(%rbp)
	movl	$0, -2260(%rbp)
	jmp	.L2
.L9:
	cmpl	$87, -2300(%rbp)
	je	.L3
	cmpl	$87, -2300(%rbp)
	jg	.L4
	cmpl	$80, -2300(%rbp)
	je	.L5
	cmpl	$80, -2300(%rbp)
	jg	.L4
	cmpl	$67, -2300(%rbp)
	je	.L6
	cmpl	$78, -2300(%rbp)
	je	.L7
	jmp	.L4
.L5:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -2312(%rbp)
	cmpl	$0, -2312(%rbp)
	jg	.L2
	movq	-2296(%rbp), %rdx
	movq	-2336(%rbp), %rcx
	movl	-2324(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	lmbench_usage@PLT
	jmp	.L2
.L3:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -2308(%rbp)
	jmp	.L2
.L7:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -2304(%rbp)
	jmp	.L2
.L6:
	movl	$1, -2260(%rbp)
	jmp	.L2
.L4:
	movq	-2296(%rbp), %rdx
	movq	-2336(%rbp), %rcx
	movl	-2324(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	lmbench_usage@PLT
	nop
.L2:
	movq	-2336(%rbp), %rcx
	movl	-2324(%rbp), %eax
	leaq	.LC2(%rip), %rdx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	mygetopt@PLT
	movl	%eax, -2300(%rbp)
	cmpl	$-1, -2300(%rbp)
	jne	.L9
	movl	-2324(%rbp), %eax
	leal	-1(%rax), %edx
	movl	myoptind(%rip), %eax
	cmpl	%eax, %edx
	je	.L10
	movq	-2296(%rbp), %rdx
	movq	-2336(%rbp), %rcx
	movl	-2324(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	lmbench_usage@PLT
.L10:
	movl	myoptind(%rip), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-2336(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	%rax, -2256(%rbp)
	movq	-2256(%rbp), %rax
	leaq	-2224(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	stat@PLT
	cmpl	$-1, %eax
	jne	.L11
	leaq	.LC3(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L11:
	movq	-2176(%rbp), %rax
	movq	%rax, %rbx
	call	getpagesize@PLT
	movslq	%eax, %rsi
	movq	%rbx, %rax
	movl	$0, %edx
	divq	%rsi
	movl	%eax, -2264(%rbp)
	movl	-2308(%rbp), %ecx
	movl	-2312(%rbp), %edx
	leaq	-2272(%rbp), %rax
	pushq	%rax
	movl	-2304(%rbp), %eax
	pushq	%rax
	movl	%ecx, %r9d
	movl	%edx, %r8d
	movl	$0, %ecx
	leaq	cleanup(%rip), %rax
	movq	%rax, %rdx
	leaq	benchmark_mmap(%rip), %rax
	movq	%rax, %rsi
	leaq	initialize(%rip), %rax
	movq	%rax, %rdi
	call	benchmp@PLT
	addq	$16, %rsp
	call	usecs_spent@PLT
	testq	%rax, %rax
	js	.L12
	pxor	%xmm2, %xmm2
	cvtsi2sdq	%rax, %xmm2
	movsd	%xmm2, -2344(%rbp)
	jmp	.L13
.L12:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
	movsd	%xmm0, -2344(%rbp)
.L13:
	call	get_n@PLT
	testq	%rax, %rax
	js	.L14
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L15
.L14:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L15:
	movsd	-2344(%rbp), %xmm1
	divsd	%xmm0, %xmm1
	movsd	%xmm1, -2288(%rbp)
	movl	-2308(%rbp), %ecx
	movl	-2312(%rbp), %edx
	leaq	-2272(%rbp), %rax
	pushq	%rax
	movl	-2304(%rbp), %eax
	pushq	%rax
	movl	%ecx, %r9d
	movl	%edx, %r8d
	movl	$0, %ecx
	leaq	cleanup(%rip), %rax
	movq	%rax, %rdx
	leaq	benchmark(%rip), %rax
	movq	%rax, %rsi
	leaq	initialize(%rip), %rax
	movq	%rax, %rdi
	call	benchmp@PLT
	addq	$16, %rsp
	call	usecs_spent@PLT
	testq	%rax, %rax
	js	.L16
	pxor	%xmm3, %xmm3
	cvtsi2sdq	%rax, %xmm3
	movsd	%xmm3, -2344(%rbp)
	jmp	.L17
.L16:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
	movsd	%xmm0, -2344(%rbp)
.L17:
	call	get_n@PLT
	testq	%rax, %rax
	js	.L18
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L19
.L18:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L19:
	movsd	-2344(%rbp), %xmm1
	divsd	%xmm0, %xmm1
	movsd	%xmm1, -2280(%rbp)
	call	get_n@PLT
	testq	%rax, %rax
	js	.L20
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L21
.L20:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L21:
	movsd	-2280(%rbp), %xmm1
	subsd	-2288(%rbp), %xmm1
	mulsd	%xmm1, %xmm0
	comisd	.LC4(%rip), %xmm0
	jnb	.L22
	cvttsd2siq	%xmm0, %rax
	jmp	.L23
.L22:
	movsd	.LC4(%rip), %xmm1
	subsd	%xmm1, %xmm0
	cvttsd2siq	%xmm0, %rax
	movabsq	$-9223372036854775808, %rdx
	xorq	%rdx, %rax
.L23:
	movq	%rax, %rdi
	call	settime@PLT
	movq	-2256(%rbp), %rdx
	leaq	-2080(%rbp), %rax
	leaq	.LC5(%rip), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	sprintf@PLT
	movl	-2264(%rbp), %eax
	movslq	%eax, %rbx
	call	get_n@PLT
	imulq	%rax, %rbx
	movq	%rbx, %rdx
	leaq	-2080(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	micro@PLT
	movl	$0, %eax
	movq	-24(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L25
	call	__stack_chk_fail@PLT
.L25:
	movq	-8(%rbp), %rbx
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE8:
	.size	main, .-main
	.section	.rodata
.LC6:
	.string	"%d"
.LC7:
	.string	"malloc"
.LC8:
	.string	"%s%d"
.LC9:
	.string	"Could not copy file"
.LC10:
	.string	"lat_pagefault: %s too small\n"
.LC11:
	.string	"msync"
	.text
	.globl	initialize
	.type	initialize, @function
initialize:
.LFB9:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%rbx
	subq	$344, %rsp
	.cfi_offset 3, -24
	movq	%rdi, -344(%rbp)
	movq	%rsi, -352(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -24(%rbp)
	xorl	%eax, %eax
	movq	-352(%rbp), %rax
	movq	%rax, -320(%rbp)
	cmpq	$0, -344(%rbp)
	jne	.L38
	movq	-320(%rbp), %rax
	movl	12(%rax), %eax
	testl	%eax, %eax
	je	.L29
	call	getpid@PLT
	movl	%eax, %edx
	leaq	-160(%rbp), %rax
	leaq	.LC6(%rip), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	sprintf@PLT
	movq	-320(%rbp), %rax
	movq	16(%rax), %rax
	movq	%rax, %rdi
	call	strlen@PLT
	movq	%rax, %rbx
	leaq	-160(%rbp), %rax
	movq	%rax, %rdi
	call	strlen@PLT
	addq	%rbx, %rax
	addq	$1, %rax
	movq	%rax, %rdi
	call	malloc@PLT
	movq	%rax, -312(%rbp)
	cmpq	$0, -312(%rbp)
	jne	.L30
	leaq	.LC7(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L30:
	call	getpid@PLT
	movl	%eax, %ecx
	movq	-320(%rbp), %rax
	movq	16(%rax), %rdx
	movq	-312(%rbp), %rax
	leaq	.LC8(%rip), %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	sprintf@PLT
	movq	-320(%rbp), %rax
	movq	16(%rax), %rax
	movq	-312(%rbp), %rcx
	movl	$384, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	cp@PLT
	testl	%eax, %eax
	jns	.L31
	leaq	.LC9(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movq	-312(%rbp), %rax
	movq	%rax, %rdi
	call	unlink@PLT
	movl	$1, %edi
	call	exit@PLT
.L31:
	movq	-320(%rbp), %rax
	movq	-312(%rbp), %rdx
	movq	%rdx, 16(%rax)
.L29:
	movq	-320(%rbp), %rax
	movq	16(%rax), %rax
	movl	$0, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	open@PLT
	movq	-320(%rbp), %rdx
	movl	%eax, (%rdx)
	movq	-320(%rbp), %rax
	movl	(%rax), %eax
	cmpl	$-1, %eax
	jne	.L32
	leaq	.LC3(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L32:
	movq	-320(%rbp), %rax
	movl	12(%rax), %eax
	testl	%eax, %eax
	je	.L33
	movq	-320(%rbp), %rax
	movq	16(%rax), %rax
	movq	%rax, %rdi
	call	unlink@PLT
.L33:
	movq	-320(%rbp), %rax
	movl	(%rax), %eax
	leaq	-304(%rbp), %rdx
	movq	%rdx, %rsi
	movl	%eax, %edi
	call	fstat@PLT
	cmpl	$-1, %eax
	jne	.L34
	leaq	.LC3(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L34:
	call	getpid@PLT
	movl	%eax, %edi
	call	srand@PLT
	call	getpagesize@PLT
	movl	%eax, -324(%rbp)
	movq	-256(%rbp), %rax
	movl	%eax, %edx
	movq	-320(%rbp), %rax
	movl	%edx, 4(%rax)
	movq	-320(%rbp), %rax
	movl	4(%rax), %ecx
	movq	-320(%rbp), %rax
	movl	4(%rax), %eax
	cltd
	idivl	-324(%rbp)
	movl	%edx, %eax
	subl	%eax, %ecx
	movl	%ecx, %edx
	movq	-320(%rbp), %rax
	movl	%edx, 4(%rax)
	movq	-320(%rbp), %rax
	movl	4(%rax), %eax
	cltd
	idivl	-324(%rbp)
	movl	%eax, %edx
	movq	-320(%rbp), %rax
	movl	%edx, 8(%rax)
	movl	-324(%rbp), %eax
	movslq	%eax, %rdx
	movq	-320(%rbp), %rax
	movl	8(%rax), %eax
	cltq
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	permutation@PLT
	movq	-320(%rbp), %rdx
	movq	%rax, 32(%rdx)
	movq	-320(%rbp), %rax
	movl	4(%rax), %eax
	cmpl	$1048575, %eax
	jg	.L35
	movq	-320(%rbp), %rax
	movq	16(%rax), %rdx
	movq	stderr(%rip), %rax
	leaq	.LC10(%rip), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf@PLT
	movl	$1, %edi
	call	exit@PLT
.L35:
	movq	-320(%rbp), %rax
	movl	(%rax), %edx
	movq	-320(%rbp), %rax
	movl	4(%rax), %eax
	cltq
	movl	$0, %r9d
	movl	%edx, %r8d
	movl	$1, %ecx
	movl	$1, %edx
	movq	%rax, %rsi
	movl	$0, %edi
	call	mmap@PLT
	movq	-320(%rbp), %rdx
	movq	%rax, 24(%rdx)
	movq	-320(%rbp), %rax
	movl	4(%rax), %eax
	movslq	%eax, %rcx
	movq	-320(%rbp), %rax
	movq	24(%rax), %rax
	movl	$2, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	msync@PLT
	testl	%eax, %eax
	je	.L26
	leaq	.LC11(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L38:
	nop
.L26:
	movq	-24(%rbp), %rax
	subq	%fs:40, %rax
	je	.L37
	call	__stack_chk_fail@PLT
.L37:
	movq	-8(%rbp), %rbx
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE9:
	.size	initialize, .-initialize
	.globl	cleanup
	.type	cleanup, @function
cleanup:
.LFB10:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%rdi, -24(%rbp)
	movq	%rsi, -32(%rbp)
	movq	-32(%rbp), %rax
	movq	%rax, -8(%rbp)
	cmpq	$0, -24(%rbp)
	jne	.L43
	movq	-8(%rbp), %rax
	movl	4(%rax), %eax
	movslq	%eax, %rdx
	movq	-8(%rbp), %rax
	movq	24(%rax), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	munmap@PLT
	movq	-8(%rbp), %rax
	movl	(%rax), %eax
	testl	%eax, %eax
	js	.L42
	movq	-8(%rbp), %rax
	movl	(%rax), %eax
	movl	%eax, %edi
	call	close@PLT
.L42:
	movq	-8(%rbp), %rax
	movq	32(%rax), %rax
	movq	%rax, %rdi
	call	free@PLT
	jmp	.L39
.L43:
	nop
.L39:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE10:
	.size	cleanup, .-cleanup
	.globl	benchmark
	.type	benchmark, @function
benchmark:
.LFB11:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%rdi, -24(%rbp)
	movq	%rsi, -32(%rbp)
	movl	$0, -12(%rbp)
	movq	-32(%rbp), %rax
	movq	%rax, -8(%rbp)
	jmp	.L45
.L48:
	movl	$0, -16(%rbp)
	jmp	.L46
.L47:
	movq	-8(%rbp), %rax
	movq	24(%rax), %rdx
	movq	-8(%rbp), %rax
	movq	32(%rax), %rcx
	movl	-16(%rbp), %eax
	cltq
	salq	$3, %rax
	addq	%rcx, %rax
	movq	(%rax), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	movsbl	%al, %eax
	addl	%eax, -12(%rbp)
	addl	$1, -16(%rbp)
.L46:
	movq	-8(%rbp), %rax
	movl	8(%rax), %eax
	cmpl	%eax, -16(%rbp)
	jl	.L47
	movq	-8(%rbp), %rax
	movl	4(%rax), %eax
	movslq	%eax, %rdx
	movq	-8(%rbp), %rax
	movq	24(%rax), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	munmap@PLT
	movq	-8(%rbp), %rax
	movl	(%rax), %edx
	movq	-8(%rbp), %rax
	movl	4(%rax), %eax
	cltq
	movl	$0, %r9d
	movl	%edx, %r8d
	movl	$1, %ecx
	movl	$1, %edx
	movq	%rax, %rsi
	movl	$0, %edi
	call	mmap@PLT
	movq	-8(%rbp), %rdx
	movq	%rax, 24(%rdx)
	movq	-8(%rbp), %rax
	movl	4(%rax), %eax
	movslq	%eax, %rcx
	movq	-8(%rbp), %rax
	movq	24(%rax), %rax
	movl	$2, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	msync@PLT
	testl	%eax, %eax
	je	.L45
	leaq	.LC11(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L45:
	movq	-24(%rbp), %rax
	leaq	-1(%rax), %rdx
	movq	%rdx, -24(%rbp)
	testq	%rax, %rax
	jne	.L48
	movl	-12(%rbp), %eax
	movl	%eax, %edi
	call	use_int@PLT
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE11:
	.size	benchmark, .-benchmark
	.globl	benchmark_mmap
	.type	benchmark_mmap, @function
benchmark_mmap:
.LFB12:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%rdi, -24(%rbp)
	movq	%rsi, -32(%rbp)
	movl	$0, -12(%rbp)
	movq	-32(%rbp), %rax
	movq	%rax, -8(%rbp)
	jmp	.L50
.L51:
	movq	-8(%rbp), %rax
	movl	4(%rax), %eax
	movslq	%eax, %rdx
	movq	-8(%rbp), %rax
	movq	24(%rax), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	munmap@PLT
	movq	-8(%rbp), %rax
	movl	(%rax), %edx
	movq	-8(%rbp), %rax
	movl	4(%rax), %eax
	cltq
	movl	$0, %r9d
	movl	%edx, %r8d
	movl	$1, %ecx
	movl	$1, %edx
	movq	%rax, %rsi
	movl	$0, %edi
	call	mmap@PLT
	movq	-8(%rbp), %rdx
	movq	%rax, 24(%rdx)
	movq	-8(%rbp), %rax
	movl	4(%rax), %eax
	movslq	%eax, %rcx
	movq	-8(%rbp), %rax
	movq	24(%rax), %rax
	movl	$2, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	msync@PLT
	testl	%eax, %eax
	je	.L50
	leaq	.LC11(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L50:
	movq	-24(%rbp), %rax
	leaq	-1(%rax), %rdx
	movq	%rdx, -24(%rbp)
	testq	%rax, %rax
	jne	.L51
	movl	-12(%rbp), %eax
	movl	%eax, %edi
	call	use_int@PLT
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE12:
	.size	benchmark_mmap, .-benchmark_mmap
	.section	.rodata
	.align 8
.LC4:
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
