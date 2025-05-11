	.file	"stream.c"
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
	.string	"[-v <stream version 1|2>] [-M <len>[K|M]] [-P <parallelism>] [-W <warmup>] [-N <repetitions>]\n"
.LC3:
	.string	"v:M:P:W:N:"
.LC4:
	.string	"STREAM copy latency"
.LC5:
	.string	"STREAM copy bandwidth: "
.LC6:
	.string	"STREAM scale latency"
.LC7:
	.string	"STREAM scale bandwidth: "
.LC8:
	.string	"STREAM add latency"
.LC9:
	.string	"STREAM add bandwidth: "
.LC10:
	.string	"STREAM triad latency"
.LC11:
	.string	"STREAM triad bandwidth: "
.LC12:
	.string	"STREAM2 fill latency"
.LC13:
	.string	"STREAM2 fill bandwidth: "
.LC14:
	.string	"STREAM2 copy latency"
.LC15:
	.string	"STREAM2 copy bandwidth: "
.LC16:
	.string	"STREAM2 daxpy latency"
.LC17:
	.string	"STREAM2 daxpy bandwidth: "
.LC18:
	.string	"STREAM2 sum latency"
.LC19:
	.string	"STREAM2 sum bandwidth: "
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
	subq	$120, %rsp
	.cfi_offset 3, -24
	movl	%edi, -116(%rbp)
	movq	%rsi, -128(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -24(%rbp)
	xorl	%eax, %eax
	movl	$1, -108(%rbp)
	movl	$1, -104(%rbp)
	movl	$0, -100(%rbp)
	movl	$-1, -96(%rbp)
	leaq	.LC1(%rip), %rax
	movq	%rax, -88(%rbp)
	movl	$24000000, -32(%rbp)
	movsd	.LC2(%rip), %xmm0
	movsd	%xmm0, -40(%rbp)
	jmp	.L2
.L11:
	cmpl	$118, -92(%rbp)
	je	.L3
	cmpl	$118, -92(%rbp)
	jg	.L4
	cmpl	$87, -92(%rbp)
	je	.L5
	cmpl	$87, -92(%rbp)
	jg	.L4
	cmpl	$80, -92(%rbp)
	je	.L6
	cmpl	$80, -92(%rbp)
	jg	.L4
	cmpl	$77, -92(%rbp)
	je	.L7
	cmpl	$78, -92(%rbp)
	je	.L8
	jmp	.L4
.L3:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -108(%rbp)
	cmpl	$1, -108(%rbp)
	je	.L2
	cmpl	$2, -108(%rbp)
	je	.L2
	movq	-88(%rbp), %rdx
	movq	-128(%rbp), %rcx
	movl	-116(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	lmbench_usage@PLT
	jmp	.L2
.L6:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -104(%rbp)
	cmpl	$0, -104(%rbp)
	jg	.L2
	movq	-88(%rbp), %rdx
	movq	-128(%rbp), %rcx
	movl	-116(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	lmbench_usage@PLT
	jmp	.L2
.L7:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	bytes@PLT
	movl	%eax, -32(%rbp)
	jmp	.L2
.L5:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -100(%rbp)
	jmp	.L2
.L8:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -96(%rbp)
	jmp	.L2
.L4:
	movq	-88(%rbp), %rdx
	movq	-128(%rbp), %rcx
	movl	-116(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	lmbench_usage@PLT
	nop
.L2:
	movq	-128(%rbp), %rcx
	movl	-116(%rbp), %eax
	leaq	.LC3(%rip), %rdx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	mygetopt@PLT
	movl	%eax, -92(%rbp)
	cmpl	$-1, -92(%rbp)
	jne	.L11
	jmp	.L12
.L13:
	movl	-32(%rbp), %eax
	movl	%eax, %edx
	shrl	$31, %edx
	addl	%edx, %eax
	sarl	%eax
	movl	%eax, -32(%rbp)
.L12:
	movl	-32(%rbp), %eax
	cltq
	movq	%rax, %rdi
	call	malloc@PLT
	movq	%rax, -80(%rbp)
	cmpq	$0, -80(%rbp)
	je	.L13
	movq	-80(%rbp), %rax
	movq	%rax, %rdi
	call	free@PLT
	movl	-32(%rbp), %eax
	cltq
	movabsq	$-6148914691236517205, %rdx
	mulq	%rdx
	movq	%rdx, %rax
	shrq	$4, %rax
	movl	%eax, -32(%rbp)
	movl	-32(%rbp), %eax
	movslq	%eax, %rdx
	movl	-104(%rbp), %eax
	cltq
	imulq	%rdx, %rax
	salq	$3, %rax
	movq	%rax, -72(%rbp)
	cmpl	$1, -108(%rbp)
	jne	.L14
	movl	-100(%rbp), %ecx
	movl	-104(%rbp), %edx
	leaq	-64(%rbp), %rax
	pushq	%rax
	movl	-96(%rbp), %eax
	pushq	%rax
	movl	%ecx, %r9d
	movl	%edx, %r8d
	movl	$0, %ecx
	leaq	cleanup(%rip), %rax
	movq	%rax, %rdx
	leaq	copy(%rip), %rax
	movq	%rax, %rsi
	leaq	initialize(%rip), %rax
	movq	%rax, %rdi
	call	benchmp@PLT
	addq	$16, %rsp
	call	usecs_spent@PLT
	testq	%rax, %rax
	je	.L15
	cmpl	$1, -104(%rbp)
	jg	.L16
	movl	$0, %eax
	call	save_minimum@PLT
.L16:
	movl	-32(%rbp), %eax
	movslq	%eax, %rbx
	call	get_n@PLT
	imulq	%rbx, %rax
	movq	%rax, %rsi
	leaq	.LC4(%rip), %rax
	movq	%rax, %rdi
	call	nano@PLT
	movq	stderr(%rip), %rax
	movq	%rax, %rcx
	movl	$23, %edx
	movl	$1, %esi
	leaq	.LC5(%rip), %rax
	movq	%rax, %rdi
	call	fwrite@PLT
	call	get_n@PLT
	imulq	-72(%rbp), %rax
	addq	%rax, %rax
	movq	%rax, %rdi
	call	mb@PLT
.L15:
	movl	-100(%rbp), %ecx
	movl	-104(%rbp), %edx
	leaq	-64(%rbp), %rax
	pushq	%rax
	movl	-96(%rbp), %eax
	pushq	%rax
	movl	%ecx, %r9d
	movl	%edx, %r8d
	movl	$0, %ecx
	leaq	cleanup(%rip), %rax
	movq	%rax, %rdx
	leaq	scale(%rip), %rax
	movq	%rax, %rsi
	leaq	initialize(%rip), %rax
	movq	%rax, %rdi
	call	benchmp@PLT
	addq	$16, %rsp
	call	usecs_spent@PLT
	testq	%rax, %rax
	je	.L17
	cmpl	$1, -104(%rbp)
	jg	.L18
	movl	$0, %eax
	call	save_minimum@PLT
.L18:
	movl	-32(%rbp), %eax
	movslq	%eax, %rbx
	call	get_n@PLT
	imulq	%rbx, %rax
	movq	%rax, %rsi
	leaq	.LC6(%rip), %rax
	movq	%rax, %rdi
	call	nano@PLT
	movq	stderr(%rip), %rax
	movq	%rax, %rcx
	movl	$24, %edx
	movl	$1, %esi
	leaq	.LC7(%rip), %rax
	movq	%rax, %rdi
	call	fwrite@PLT
	call	get_n@PLT
	imulq	-72(%rbp), %rax
	addq	%rax, %rax
	movq	%rax, %rdi
	call	mb@PLT
.L17:
	movl	-100(%rbp), %ecx
	movl	-104(%rbp), %edx
	leaq	-64(%rbp), %rax
	pushq	%rax
	movl	-96(%rbp), %eax
	pushq	%rax
	movl	%ecx, %r9d
	movl	%edx, %r8d
	movl	$0, %ecx
	leaq	cleanup(%rip), %rax
	movq	%rax, %rdx
	leaq	add(%rip), %rax
	movq	%rax, %rsi
	leaq	initialize(%rip), %rax
	movq	%rax, %rdi
	call	benchmp@PLT
	addq	$16, %rsp
	call	usecs_spent@PLT
	testq	%rax, %rax
	je	.L19
	cmpl	$1, -104(%rbp)
	jg	.L20
	movl	$0, %eax
	call	save_minimum@PLT
.L20:
	movl	-32(%rbp), %eax
	movslq	%eax, %rbx
	call	get_n@PLT
	imulq	%rbx, %rax
	movq	%rax, %rsi
	leaq	.LC8(%rip), %rax
	movq	%rax, %rdi
	call	nano@PLT
	movq	stderr(%rip), %rax
	movq	%rax, %rcx
	movl	$22, %edx
	movl	$1, %esi
	leaq	.LC9(%rip), %rax
	movq	%rax, %rdi
	call	fwrite@PLT
	call	get_n@PLT
	imulq	-72(%rbp), %rax
	movq	%rax, %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	movq	%rax, %rdi
	call	mb@PLT
.L19:
	movl	-100(%rbp), %ecx
	movl	-104(%rbp), %edx
	leaq	-64(%rbp), %rax
	pushq	%rax
	movl	-96(%rbp), %eax
	pushq	%rax
	movl	%ecx, %r9d
	movl	%edx, %r8d
	movl	$0, %ecx
	leaq	cleanup(%rip), %rax
	movq	%rax, %rdx
	leaq	triad(%rip), %rax
	movq	%rax, %rsi
	leaq	initialize(%rip), %rax
	movq	%rax, %rdi
	call	benchmp@PLT
	addq	$16, %rsp
	call	usecs_spent@PLT
	testq	%rax, %rax
	je	.L21
	cmpl	$1, -104(%rbp)
	jg	.L22
	movl	$0, %eax
	call	save_minimum@PLT
.L22:
	movl	-32(%rbp), %eax
	movslq	%eax, %rbx
	call	get_n@PLT
	imulq	%rbx, %rax
	movq	%rax, %rsi
	leaq	.LC10(%rip), %rax
	movq	%rax, %rdi
	call	nano@PLT
	movq	stderr(%rip), %rax
	movq	%rax, %rcx
	movl	$24, %edx
	movl	$1, %esi
	leaq	.LC11(%rip), %rax
	movq	%rax, %rdi
	call	fwrite@PLT
	call	get_n@PLT
	imulq	-72(%rbp), %rax
	movq	%rax, %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	movq	%rax, %rdi
	call	mb@PLT
	jmp	.L21
.L14:
	movl	-100(%rbp), %ecx
	movl	-104(%rbp), %edx
	leaq	-64(%rbp), %rax
	pushq	%rax
	movl	-96(%rbp), %eax
	pushq	%rax
	movl	%ecx, %r9d
	movl	%edx, %r8d
	movl	$0, %ecx
	leaq	cleanup(%rip), %rax
	movq	%rax, %rdx
	leaq	fill(%rip), %rax
	movq	%rax, %rsi
	leaq	initialize(%rip), %rax
	movq	%rax, %rdi
	call	benchmp@PLT
	addq	$16, %rsp
	call	usecs_spent@PLT
	testq	%rax, %rax
	je	.L23
	cmpl	$1, -104(%rbp)
	jg	.L24
	movl	$0, %eax
	call	save_minimum@PLT
.L24:
	movl	-32(%rbp), %eax
	movslq	%eax, %rbx
	call	get_n@PLT
	imulq	%rbx, %rax
	movq	%rax, %rsi
	leaq	.LC12(%rip), %rax
	movq	%rax, %rdi
	call	nano@PLT
	movq	stderr(%rip), %rax
	movq	%rax, %rcx
	movl	$24, %edx
	movl	$1, %esi
	leaq	.LC13(%rip), %rax
	movq	%rax, %rdi
	call	fwrite@PLT
	call	get_n@PLT
	imulq	-72(%rbp), %rax
	movq	%rax, %rdi
	call	mb@PLT
.L23:
	movl	-100(%rbp), %ecx
	movl	-104(%rbp), %edx
	leaq	-64(%rbp), %rax
	pushq	%rax
	movl	-96(%rbp), %eax
	pushq	%rax
	movl	%ecx, %r9d
	movl	%edx, %r8d
	movl	$0, %ecx
	leaq	cleanup(%rip), %rax
	movq	%rax, %rdx
	leaq	copy(%rip), %rax
	movq	%rax, %rsi
	leaq	initialize(%rip), %rax
	movq	%rax, %rdi
	call	benchmp@PLT
	addq	$16, %rsp
	call	usecs_spent@PLT
	testq	%rax, %rax
	je	.L25
	cmpl	$1, -104(%rbp)
	jg	.L26
	movl	$0, %eax
	call	save_minimum@PLT
.L26:
	movl	-32(%rbp), %eax
	movslq	%eax, %rbx
	call	get_n@PLT
	imulq	%rbx, %rax
	movq	%rax, %rsi
	leaq	.LC14(%rip), %rax
	movq	%rax, %rdi
	call	nano@PLT
	movq	stderr(%rip), %rax
	movq	%rax, %rcx
	movl	$24, %edx
	movl	$1, %esi
	leaq	.LC15(%rip), %rax
	movq	%rax, %rdi
	call	fwrite@PLT
	call	get_n@PLT
	imulq	-72(%rbp), %rax
	addq	%rax, %rax
	movq	%rax, %rdi
	call	mb@PLT
.L25:
	movl	-100(%rbp), %ecx
	movl	-104(%rbp), %edx
	leaq	-64(%rbp), %rax
	pushq	%rax
	movl	-96(%rbp), %eax
	pushq	%rax
	movl	%ecx, %r9d
	movl	%edx, %r8d
	movl	$0, %ecx
	leaq	cleanup(%rip), %rax
	movq	%rax, %rdx
	leaq	daxpy(%rip), %rax
	movq	%rax, %rsi
	leaq	initialize(%rip), %rax
	movq	%rax, %rdi
	call	benchmp@PLT
	addq	$16, %rsp
	call	usecs_spent@PLT
	testq	%rax, %rax
	je	.L27
	cmpl	$1, -104(%rbp)
	jg	.L28
	movl	$0, %eax
	call	save_minimum@PLT
.L28:
	movl	-32(%rbp), %eax
	movslq	%eax, %rbx
	call	get_n@PLT
	imulq	%rbx, %rax
	movq	%rax, %rsi
	leaq	.LC16(%rip), %rax
	movq	%rax, %rdi
	call	nano@PLT
	movq	stderr(%rip), %rax
	movq	%rax, %rcx
	movl	$25, %edx
	movl	$1, %esi
	leaq	.LC17(%rip), %rax
	movq	%rax, %rdi
	call	fwrite@PLT
	call	get_n@PLT
	imulq	-72(%rbp), %rax
	movq	%rax, %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	movq	%rax, %rdi
	call	mb@PLT
.L27:
	movl	-100(%rbp), %ecx
	movl	-104(%rbp), %edx
	leaq	-64(%rbp), %rax
	pushq	%rax
	movl	-96(%rbp), %eax
	pushq	%rax
	movl	%ecx, %r9d
	movl	%edx, %r8d
	movl	$0, %ecx
	leaq	cleanup(%rip), %rax
	movq	%rax, %rdx
	leaq	sum(%rip), %rax
	movq	%rax, %rsi
	leaq	initialize(%rip), %rax
	movq	%rax, %rdi
	call	benchmp@PLT
	addq	$16, %rsp
	call	usecs_spent@PLT
	testq	%rax, %rax
	je	.L21
	cmpl	$1, -104(%rbp)
	jg	.L29
	movl	$0, %eax
	call	save_minimum@PLT
.L29:
	movl	-32(%rbp), %eax
	movslq	%eax, %rbx
	call	get_n@PLT
	imulq	%rbx, %rax
	movq	%rax, %rsi
	leaq	.LC18(%rip), %rax
	movq	%rax, %rdi
	call	nano@PLT
	movq	stderr(%rip), %rax
	movq	%rax, %rcx
	movl	$23, %edx
	movl	$1, %esi
	leaq	.LC19(%rip), %rax
	movq	%rax, %rdi
	call	fwrite@PLT
	call	get_n@PLT
	imulq	-72(%rbp), %rax
	movq	%rax, %rdi
	call	mb@PLT
.L21:
	movl	$0, %eax
	movq	-24(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L31
	call	__stack_chk_fail@PLT
.L31:
	movq	-8(%rbp), %rbx
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE8:
	.size	main, .-main
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
	subq	$32, %rsp
	movq	%rdi, -24(%rbp)
	movq	%rsi, -32(%rbp)
	movq	-32(%rbp), %rax
	movq	%rax, -8(%rbp)
	cmpq	$0, -24(%rbp)
	jne	.L39
	movq	-8(%rbp), %rax
	movl	32(%rax), %eax
	cltq
	salq	$3, %rax
	movq	%rax, %rdi
	call	malloc@PLT
	movq	%rax, %rdx
	movq	-8(%rbp), %rax
	movq	%rdx, (%rax)
	movq	-8(%rbp), %rax
	movl	32(%rax), %eax
	cltq
	salq	$3, %rax
	movq	%rax, %rdi
	call	malloc@PLT
	movq	%rax, %rdx
	movq	-8(%rbp), %rax
	movq	%rdx, 8(%rax)
	movq	-8(%rbp), %rax
	movl	32(%rax), %eax
	cltq
	salq	$3, %rax
	movq	%rax, %rdi
	call	malloc@PLT
	movq	%rax, %rdx
	movq	-8(%rbp), %rax
	movq	%rdx, 16(%rax)
	movq	-8(%rbp), %rax
	movq	(%rax), %rax
	testq	%rax, %rax
	je	.L35
	movq	-8(%rbp), %rax
	movq	8(%rax), %rax
	testq	%rax, %rax
	je	.L35
	movq	-8(%rbp), %rax
	movq	16(%rax), %rax
	testq	%rax, %rax
	jne	.L36
.L35:
	movl	$1, %edi
	call	exit@PLT
.L36:
	movl	$0, -12(%rbp)
	jmp	.L37
.L38:
	movq	-8(%rbp), %rax
	movq	(%rax), %rdx
	movl	-12(%rbp), %eax
	cltq
	salq	$3, %rax
	addq	%rdx, %rax
	movsd	.LC20(%rip), %xmm0
	movsd	%xmm0, (%rax)
	movq	-8(%rbp), %rax
	movq	8(%rax), %rdx
	movl	-12(%rbp), %eax
	cltq
	salq	$3, %rax
	addq	%rdx, %rax
	movsd	.LC21(%rip), %xmm0
	movsd	%xmm0, (%rax)
	movq	-8(%rbp), %rax
	movq	16(%rax), %rdx
	movl	-12(%rbp), %eax
	cltq
	salq	$3, %rax
	addq	%rdx, %rax
	pxor	%xmm0, %xmm0
	movsd	%xmm0, (%rax)
	addl	$1, -12(%rbp)
.L37:
	movq	-8(%rbp), %rax
	movl	32(%rax), %eax
	cmpl	%eax, -12(%rbp)
	jl	.L38
	jmp	.L32
.L39:
	nop
.L32:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE9:
	.size	initialize, .-initialize
	.globl	copy
	.type	copy, @function
copy:
.LFB10:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	.cfi_offset 14, -24
	.cfi_offset 13, -32
	.cfi_offset 12, -40
	.cfi_offset 3, -48
	movq	%rdi, -56(%rbp)
	movq	%rsi, -64(%rbp)
	movq	-64(%rbp), %rax
	movq	%rax, -40(%rbp)
	jmp	.L41
.L44:
	movq	-40(%rbp), %rax
	movl	32(%rax), %r13d
	movq	-40(%rbp), %rax
	movq	(%rax), %r12
	movq	-40(%rbp), %rax
	movq	16(%rax), %r14
	movq	-40(%rbp), %rax
	movq	8(%rax), %rdx
	movq	-40(%rbp), %rax
	movq	%rdx, (%rax)
	movq	-40(%rbp), %rax
	movq	16(%rax), %rdx
	movq	-40(%rbp), %rax
	movq	%rdx, 8(%rax)
	movq	-40(%rbp), %rax
	movq	%r12, 16(%rax)
	movl	$0, %ebx
	jmp	.L42
.L43:
	movslq	%ebx, %rax
	salq	$3, %rax
	leaq	(%r12,%rax), %rdx
	movslq	%ebx, %rax
	salq	$3, %rax
	addq	%r14, %rax
	movsd	(%rdx), %xmm0
	movsd	%xmm0, (%rax)
	addl	$1, %ebx
.L42:
	cmpl	%r13d, %ebx
	jl	.L43
.L41:
	movq	-56(%rbp), %rax
	leaq	-1(%rax), %rdx
	movq	%rdx, -56(%rbp)
	testq	%rax, %rax
	jne	.L44
	nop
	nop
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE10:
	.size	copy, .-copy
	.globl	scale
	.type	scale, @function
scale:
.LFB11:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	.cfi_offset 14, -24
	.cfi_offset 13, -32
	.cfi_offset 12, -40
	.cfi_offset 3, -48
	movq	%rdi, -56(%rbp)
	movq	%rsi, -64(%rbp)
	movq	-64(%rbp), %rax
	movq	%rax, -40(%rbp)
	jmp	.L46
.L49:
	movq	-40(%rbp), %rax
	movl	32(%rax), %r12d
	movq	-40(%rbp), %rax
	movq	(%rax), %rbx
	movq	-40(%rbp), %rax
	movq	8(%rax), %r13
	movq	-40(%rbp), %rax
	movq	16(%rax), %r14
	movq	-40(%rbp), %rax
	movsd	24(%rax), %xmm1
	movapd	%xmm1, %xmm3
	movq	-40(%rbp), %rax
	movq	8(%rax), %rdx
	movq	-40(%rbp), %rax
	movq	%rdx, (%rax)
	movq	-40(%rbp), %rax
	movq	16(%rax), %rdx
	movq	-40(%rbp), %rax
	movq	%rdx, 8(%rax)
	movq	-40(%rbp), %rax
	movq	%rbx, 16(%rax)
	movl	$0, %ebx
	jmp	.L47
.L48:
	movslq	%ebx, %rax
	salq	$3, %rax
	addq	%r14, %rax
	movsd	(%rax), %xmm0
	movslq	%ebx, %rax
	salq	$3, %rax
	addq	%r13, %rax
	movapd	%xmm3, %xmm2
	mulsd	%xmm2, %xmm0
	movsd	%xmm0, (%rax)
	addl	$1, %ebx
.L47:
	cmpl	%r12d, %ebx
	jl	.L48
.L46:
	movq	-56(%rbp), %rax
	leaq	-1(%rax), %rdx
	movq	%rdx, -56(%rbp)
	testq	%rax, %rax
	jne	.L49
	nop
	nop
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE11:
	.size	scale, .-scale
	.globl	add
	.type	add, @function
add:
.LFB12:
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
	.cfi_offset 15, -24
	.cfi_offset 14, -32
	.cfi_offset 13, -40
	.cfi_offset 12, -48
	.cfi_offset 3, -56
	movq	%rdi, -64(%rbp)
	movq	%rsi, -72(%rbp)
	movq	-72(%rbp), %rax
	movq	%rax, -48(%rbp)
	jmp	.L51
.L54:
	movq	-48(%rbp), %rax
	movl	32(%rax), %r13d
	movq	-48(%rbp), %rax
	movq	(%rax), %r12
	movq	-48(%rbp), %rax
	movq	8(%rax), %r14
	movq	-48(%rbp), %rax
	movq	16(%rax), %r15
	movq	-48(%rbp), %rax
	movq	8(%rax), %rdx
	movq	-48(%rbp), %rax
	movq	%rdx, (%rax)
	movq	-48(%rbp), %rax
	movq	16(%rax), %rdx
	movq	-48(%rbp), %rax
	movq	%rdx, 8(%rax)
	movq	-48(%rbp), %rax
	movq	%r12, 16(%rax)
	movl	$0, %ebx
	jmp	.L52
.L53:
	movslq	%ebx, %rax
	salq	$3, %rax
	addq	%r12, %rax
	movsd	(%rax), %xmm1
	movslq	%ebx, %rax
	salq	$3, %rax
	addq	%r14, %rax
	movsd	(%rax), %xmm0
	movslq	%ebx, %rax
	salq	$3, %rax
	addq	%r15, %rax
	addsd	%xmm1, %xmm0
	movsd	%xmm0, (%rax)
	addl	$1, %ebx
.L52:
	cmpl	%r13d, %ebx
	jl	.L53
.L51:
	movq	-64(%rbp), %rax
	leaq	-1(%rax), %rdx
	movq	%rdx, -64(%rbp)
	testq	%rax, %rax
	jne	.L54
	nop
	nop
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE12:
	.size	add, .-add
	.globl	triad
	.type	triad, @function
triad:
.LFB13:
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
	.cfi_offset 15, -24
	.cfi_offset 14, -32
	.cfi_offset 13, -40
	.cfi_offset 12, -48
	.cfi_offset 3, -56
	movq	%rdi, -64(%rbp)
	movq	%rsi, -72(%rbp)
	movq	-72(%rbp), %rax
	movq	%rax, -48(%rbp)
	jmp	.L56
.L59:
	movq	-48(%rbp), %rax
	movl	32(%rax), %r13d
	movq	-48(%rbp), %rax
	movq	(%rax), %r12
	movq	-48(%rbp), %rax
	movq	8(%rax), %r14
	movq	-48(%rbp), %rax
	movq	16(%rax), %r15
	movq	-48(%rbp), %rax
	movsd	24(%rax), %xmm2
	movapd	%xmm2, %xmm4
	movq	-48(%rbp), %rax
	movq	8(%rax), %rdx
	movq	-48(%rbp), %rax
	movq	%rdx, (%rax)
	movq	-48(%rbp), %rax
	movq	16(%rax), %rdx
	movq	-48(%rbp), %rax
	movq	%rdx, 8(%rax)
	movq	-48(%rbp), %rax
	movq	%r12, 16(%rax)
	movl	$0, %ebx
	jmp	.L57
.L58:
	movslq	%ebx, %rax
	salq	$3, %rax
	addq	%r14, %rax
	movsd	(%rax), %xmm1
	movslq	%ebx, %rax
	salq	$3, %rax
	addq	%r15, %rax
	movsd	(%rax), %xmm0
	movapd	%xmm4, %xmm3
	mulsd	%xmm3, %xmm0
	movslq	%ebx, %rax
	salq	$3, %rax
	addq	%r12, %rax
	addsd	%xmm1, %xmm0
	movsd	%xmm0, (%rax)
	addl	$1, %ebx
.L57:
	cmpl	%r13d, %ebx
	jl	.L58
.L56:
	movq	-64(%rbp), %rax
	leaq	-1(%rax), %rdx
	movq	%rdx, -64(%rbp)
	testq	%rax, %rax
	jne	.L59
	nop
	nop
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE13:
	.size	triad, .-triad
	.globl	fill
	.type	fill, @function
fill:
.LFB14:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	.cfi_offset 13, -24
	.cfi_offset 12, -32
	.cfi_offset 3, -40
	movq	%rdi, -48(%rbp)
	movq	%rsi, -56(%rbp)
	movq	-56(%rbp), %rax
	movq	%rax, -32(%rbp)
	jmp	.L61
.L64:
	movq	-32(%rbp), %rax
	movl	32(%rax), %r13d
	movq	-32(%rbp), %rax
	movq	(%rax), %r12
	movq	-32(%rbp), %rax
	movq	8(%rax), %rdx
	movq	-32(%rbp), %rax
	movq	%rdx, (%rax)
	movq	-32(%rbp), %rax
	movq	16(%rax), %rdx
	movq	-32(%rbp), %rax
	movq	%rdx, 8(%rax)
	movq	-32(%rbp), %rax
	movq	%r12, 16(%rax)
	movl	$0, %ebx
	jmp	.L62
.L63:
	movslq	%ebx, %rax
	salq	$3, %rax
	addq	%r12, %rax
	pxor	%xmm0, %xmm0
	movsd	%xmm0, (%rax)
	addl	$1, %ebx
.L62:
	cmpl	%r13d, %ebx
	jl	.L63
.L61:
	movq	-48(%rbp), %rax
	leaq	-1(%rax), %rdx
	movq	%rdx, -48(%rbp)
	testq	%rax, %rax
	jne	.L64
	nop
	nop
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE14:
	.size	fill, .-fill
	.globl	daxpy
	.type	daxpy, @function
daxpy:
.LFB15:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	.cfi_offset 14, -24
	.cfi_offset 13, -32
	.cfi_offset 12, -40
	.cfi_offset 3, -48
	movq	%rdi, -56(%rbp)
	movq	%rsi, -64(%rbp)
	movq	-64(%rbp), %rax
	movq	%rax, -40(%rbp)
	jmp	.L66
.L69:
	movq	-40(%rbp), %rax
	movl	32(%rax), %r13d
	movq	-40(%rbp), %rax
	movq	(%rax), %r12
	movq	-40(%rbp), %rax
	movq	8(%rax), %r14
	movq	-40(%rbp), %rax
	movsd	24(%rax), %xmm2
	movapd	%xmm2, %xmm4
	movq	-40(%rbp), %rax
	movq	8(%rax), %rdx
	movq	-40(%rbp), %rax
	movq	%rdx, (%rax)
	movq	-40(%rbp), %rax
	movq	16(%rax), %rdx
	movq	-40(%rbp), %rax
	movq	%rdx, 8(%rax)
	movq	-40(%rbp), %rax
	movq	%r12, 16(%rax)
	movl	$0, %ebx
	jmp	.L67
.L68:
	movslq	%ebx, %rax
	salq	$3, %rax
	addq	%r12, %rax
	movsd	(%rax), %xmm1
	movslq	%ebx, %rax
	salq	$3, %rax
	addq	%r14, %rax
	movsd	(%rax), %xmm0
	movapd	%xmm4, %xmm3
	mulsd	%xmm3, %xmm0
	movslq	%ebx, %rax
	salq	$3, %rax
	addq	%r12, %rax
	addsd	%xmm1, %xmm0
	movsd	%xmm0, (%rax)
	addl	$1, %ebx
.L67:
	cmpl	%r13d, %ebx
	jl	.L68
.L66:
	movq	-56(%rbp), %rax
	leaq	-1(%rax), %rdx
	movq	%rdx, -56(%rbp)
	testq	%rax, %rax
	jne	.L69
	nop
	nop
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE15:
	.size	daxpy, .-daxpy
	.globl	sum
	.type	sum, @function
sum:
.LFB16:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$40, %rsp
	.cfi_offset 13, -24
	.cfi_offset 12, -32
	.cfi_offset 3, -40
	movq	%rdi, -56(%rbp)
	movq	%rsi, -64(%rbp)
	movq	-64(%rbp), %rax
	movq	%rax, -40(%rbp)
	pxor	%xmm1, %xmm1
	movapd	%xmm1, %xmm3
	jmp	.L71
.L74:
	movq	-40(%rbp), %rax
	movl	32(%rax), %r13d
	movq	-40(%rbp), %rax
	movq	(%rax), %r12
	movq	-40(%rbp), %rax
	movq	8(%rax), %rdx
	movq	-40(%rbp), %rax
	movq	%rdx, (%rax)
	movq	-40(%rbp), %rax
	movq	16(%rax), %rdx
	movq	-40(%rbp), %rax
	movq	%rdx, 8(%rax)
	movq	-40(%rbp), %rax
	movq	%r12, 16(%rax)
	movl	$0, %ebx
	jmp	.L72
.L73:
	movslq	%ebx, %rax
	salq	$3, %rax
	addq	%r12, %rax
	movsd	(%rax), %xmm0
	movapd	%xmm3, %xmm2
	addsd	%xmm2, %xmm0
	movapd	%xmm0, %xmm3
	addl	$1, %ebx
.L72:
	cmpl	%r13d, %ebx
	jl	.L73
.L71:
	movq	-56(%rbp), %rax
	leaq	-1(%rax), %rdx
	movq	%rdx, -56(%rbp)
	testq	%rax, %rax
	jne	.L74
	cvttsd2sil	%xmm3, %eax
	movl	%eax, %edi
	call	use_int@PLT
	nop
	addq	$40, %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE16:
	.size	sum, .-sum
	.globl	cleanup
	.type	cleanup, @function
cleanup:
.LFB17:
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
	jne	.L78
	movq	-8(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	free@PLT
	movq	-8(%rbp), %rax
	movq	8(%rax), %rax
	movq	%rax, %rdi
	call	free@PLT
	movq	-8(%rbp), %rax
	movq	16(%rax), %rax
	movq	%rax, %rdi
	call	free@PLT
	jmp	.L75
.L78:
	nop
.L75:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE17:
	.size	cleanup, .-cleanup
	.section	.rodata
	.align 8
.LC2:
	.long	0
	.long	1074266112
	.align 8
.LC20:
	.long	0
	.long	1072693248
	.align 8
.LC21:
	.long	0
	.long	1073741824
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
