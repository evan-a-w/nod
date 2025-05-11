	.file	"lat_ctx.c"
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
	.string	"[-P <parallelism>] [-W <warmup>] [-N <repetitions>] [-s kbytes] processes [processes ...]\n"
.LC3:
	.string	"s:P:W:N:"
.LC4:
	.string	"\n\"size=%dk ovr=%.2f\n"
.LC5:
	.string	"%d %.2f\n"
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
	addq	$-128, %rsp
	movl	%edi, -116(%rbp)
	movq	%rsi, -128(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movl	$1, -96(%rbp)
	movl	$0, -92(%rbp)
	movl	$-1, -88(%rbp)
	leaq	.LC1(%rip), %rax
	movq	%rax, -80(%rbp)
	movl	$0, -64(%rbp)
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -56(%rbp)
	movq	$0, -40(%rbp)
	jmp	.L2
.L8:
	cmpl	$115, -84(%rbp)
	je	.L3
	cmpl	$115, -84(%rbp)
	jg	.L4
	cmpl	$87, -84(%rbp)
	je	.L5
	cmpl	$87, -84(%rbp)
	jg	.L4
	cmpl	$78, -84(%rbp)
	je	.L6
	cmpl	$80, -84(%rbp)
	jne	.L4
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -96(%rbp)
	cmpl	$0, -96(%rbp)
	jg	.L2
	movq	-80(%rbp), %rdx
	movq	-128(%rbp), %rcx
	movl	-116(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	lmbench_usage@PLT
	jmp	.L2
.L5:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -92(%rbp)
	jmp	.L2
.L6:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -88(%rbp)
	jmp	.L2
.L3:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	sall	$10, %eax
	movl	%eax, -64(%rbp)
	jmp	.L2
.L4:
	movq	-80(%rbp), %rdx
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
	movl	%eax, -84(%rbp)
	cmpl	$-1, -84(%rbp)
	jne	.L8
	movl	myoptind(%rip), %eax
	cmpl	%eax, -116(%rbp)
	jg	.L9
	movq	-80(%rbp), %rdx
	movq	-128(%rbp), %rcx
	movl	-116(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	lmbench_usage@PLT
.L9:
	movl	myoptind(%rip), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-128(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -100(%rbp)
	movl	myoptind(%rip), %eax
	movl	%eax, -104(%rbp)
	jmp	.L10
.L12:
	movl	-104(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-128(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -48(%rbp)
	movl	-48(%rbp), %eax
	cmpl	%eax, -100(%rbp)
	jge	.L11
	movl	-48(%rbp), %eax
	movl	%eax, -100(%rbp)
.L11:
	addl	$1, -104(%rbp)
.L10:
	movl	-104(%rbp), %eax
	cmpl	-116(%rbp), %eax
	jl	.L12
	movl	-100(%rbp), %eax
	movl	%eax, -48(%rbp)
	movl	-92(%rbp), %edx
	leaq	-64(%rbp), %rax
	pushq	%rax
	movl	-88(%rbp), %eax
	pushq	%rax
	movl	%edx, %r9d
	movl	$1, %r8d
	movl	$0, %ecx
	leaq	cleanup_overhead(%rip), %rax
	movq	%rax, %rdx
	leaq	benchmark_overhead(%rip), %rax
	movq	%rax, %rsi
	leaq	initialize_overhead(%rip), %rax
	movq	%rax, %rdi
	call	benchmp@PLT
	addq	$16, %rsp
	call	usecs_spent@PLT
	testq	%rax, %rax
	jne	.L13
	movl	$0, %eax
	jmp	.L27
.L13:
	call	usecs_spent@PLT
	testq	%rax, %rax
	js	.L15
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L16
.L15:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L16:
	movsd	%xmm0, -56(%rbp)
	call	get_n@PLT
	movsd	-56(%rbp), %xmm1
	testq	%rax, %rax
	js	.L17
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L18
.L17:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L18:
	divsd	%xmm0, %xmm1
	movsd	%xmm1, -56(%rbp)
	movq	-56(%rbp), %rdx
	movl	-64(%rbp), %eax
	leal	1023(%rax), %ecx
	testl	%eax, %eax
	cmovs	%ecx, %eax
	sarl	$10, %eax
	movl	%eax, %ecx
	movq	stderr(%rip), %rax
	movq	%rdx, %xmm0
	movl	%ecx, %edx
	leaq	.LC4(%rip), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	movl	$1, %eax
	call	fprintf@PLT
	movl	myoptind(%rip), %eax
	movl	%eax, -104(%rbp)
	jmp	.L19
.L26:
	movl	-104(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-128(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -48(%rbp)
	movl	-92(%rbp), %ecx
	movl	-96(%rbp), %edx
	leaq	-64(%rbp), %rax
	pushq	%rax
	movl	-88(%rbp), %eax
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
	movsd	%xmm0, -72(%rbp)
	call	get_n@PLT
	testq	%rax, %rax
	js	.L22
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L23
.L22:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L23:
	movsd	-72(%rbp), %xmm1
	divsd	%xmm0, %xmm1
	movsd	%xmm1, -72(%rbp)
	movl	-48(%rbp), %eax
	pxor	%xmm1, %xmm1
	cvtsi2sdl	%eax, %xmm1
	movsd	-72(%rbp), %xmm0
	divsd	%xmm1, %xmm0
	movsd	%xmm0, -72(%rbp)
	movsd	-56(%rbp), %xmm1
	movsd	-72(%rbp), %xmm0
	subsd	%xmm1, %xmm0
	movsd	%xmm0, -72(%rbp)
	movsd	-72(%rbp), %xmm0
	pxor	%xmm1, %xmm1
	comisd	%xmm1, %xmm0
	jbe	.L24
	movl	-48(%rbp), %edx
	movq	stderr(%rip), %rax
	movq	-72(%rbp), %rcx
	movq	%rcx, %xmm0
	leaq	.LC5(%rip), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	movl	$1, %eax
	call	fprintf@PLT
.L24:
	addl	$1, -104(%rbp)
.L19:
	movl	-104(%rbp), %eax
	cmpl	-116(%rbp), %eax
	jl	.L26
	movl	$0, %eax
.L27:
	movq	-8(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L28
	call	__stack_chk_fail@PLT
.L28:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE8:
	.size	main, .-main
	.section	.rodata
.LC6:
	.string	"malloc"
	.text
	.globl	initialize_overhead
	.type	initialize_overhead, @function
initialize_overhead:
.LFB9:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$48, %rsp
	movq	%rdi, -40(%rbp)
	movq	%rsi, -48(%rbp)
	movq	-48(%rbp), %rax
	movq	%rax, -8(%rbp)
	cmpq	$0, -40(%rbp)
	jne	.L40
	movq	-8(%rbp), %rax
	movq	$0, 24(%rax)
	movq	-8(%rbp), %rax
	movl	16(%rax), %eax
	cltq
	salq	$4, %rax
	movq	%rax, %rdi
	call	malloc@PLT
	movq	%rax, %rdx
	movq	-8(%rbp), %rax
	movq	%rdx, 32(%rax)
	movq	-8(%rbp), %rax
	movl	(%rax), %eax
	testl	%eax, %eax
	jle	.L33
	movq	-8(%rbp), %rax
	movl	(%rax), %eax
	cltq
	movq	%rax, %rdi
	call	malloc@PLT
	movq	%rax, %rdx
	jmp	.L34
.L33:
	movl	$0, %edx
.L34:
	movq	-8(%rbp), %rax
	movq	%rdx, 40(%rax)
	movq	-8(%rbp), %rax
	movq	32(%rax), %rax
	testq	%rax, %rax
	je	.L35
	movq	-8(%rbp), %rax
	movl	(%rax), %eax
	testl	%eax, %eax
	jle	.L36
	movq	-8(%rbp), %rax
	movq	40(%rax), %rax
	testq	%rax, %rax
	jne	.L36
.L35:
	leaq	.LC6(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L36:
	movq	-8(%rbp), %rax
	movq	32(%rax), %rdx
	movq	-8(%rbp), %rax
	movl	16(%rax), %eax
	cltq
	salq	$3, %rax
	addq	%rdx, %rax
	movq	%rax, -16(%rbp)
	movl	$0, -24(%rbp)
	jmp	.L37
.L38:
	movq	-8(%rbp), %rax
	movq	32(%rax), %rdx
	movl	-24(%rbp), %eax
	cltq
	salq	$3, %rax
	addq	%rax, %rdx
	movq	-16(%rbp), %rax
	movq	%rax, (%rdx)
	addq	$8, -16(%rbp)
	addl	$1, -24(%rbp)
.L37:
	movq	-8(%rbp), %rax
	movl	16(%rax), %eax
	cmpl	%eax, -24(%rbp)
	jl	.L38
	movq	-8(%rbp), %rax
	movq	40(%rax), %rax
	testq	%rax, %rax
	je	.L39
	movq	-8(%rbp), %rax
	movl	(%rax), %eax
	movslq	%eax, %rdx
	movq	-8(%rbp), %rax
	movq	40(%rax), %rax
	movl	$0, %esi
	movq	%rax, %rdi
	call	memset@PLT
.L39:
	movq	-8(%rbp), %rax
	movl	16(%rax), %edx
	movq	-8(%rbp), %rax
	movq	32(%rax), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	create_pipes
	movl	%eax, -20(%rbp)
	movq	-8(%rbp), %rax
	movl	16(%rax), %eax
	cmpl	%eax, -20(%rbp)
	jge	.L30
	movq	-48(%rbp), %rax
	movq	%rax, %rsi
	movl	$0, %edi
	call	cleanup_overhead
	movl	$1, %edi
	call	exit@PLT
.L40:
	nop
.L30:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE9:
	.size	initialize_overhead, .-initialize_overhead
	.globl	cleanup_overhead
	.type	cleanup_overhead, @function
cleanup_overhead:
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
	jne	.L46
	movl	$0, -12(%rbp)
	jmp	.L44
.L45:
	movq	-8(%rbp), %rax
	movq	32(%rax), %rdx
	movl	-12(%rbp), %eax
	cltq
	salq	$3, %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movl	(%rax), %eax
	movl	%eax, %edi
	call	close@PLT
	movq	-8(%rbp), %rax
	movq	32(%rax), %rdx
	movl	-12(%rbp), %eax
	cltq
	salq	$3, %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	addq	$4, %rax
	movl	(%rax), %eax
	movl	%eax, %edi
	call	close@PLT
	addl	$1, -12(%rbp)
.L44:
	movq	-8(%rbp), %rax
	movl	16(%rax), %eax
	cmpl	%eax, -12(%rbp)
	jl	.L45
	movq	-8(%rbp), %rax
	movq	32(%rax), %rax
	movq	%rax, %rdi
	call	free@PLT
	movq	-8(%rbp), %rax
	movq	40(%rax), %rax
	testq	%rax, %rax
	je	.L41
	movq	-8(%rbp), %rax
	movq	40(%rax), %rax
	movq	%rax, %rdi
	call	free@PLT
	jmp	.L41
.L46:
	nop
.L41:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE10:
	.size	cleanup_overhead, .-cleanup_overhead
	.globl	benchmark_overhead
	.type	benchmark_overhead, @function
benchmark_overhead:
.LFB11:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$48, %rsp
	movq	%rdi, -40(%rbp)
	movq	%rsi, -48(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movq	-48(%rbp), %rax
	movq	%rax, -16(%rbp)
	movl	$0, -20(%rbp)
	movl	$1, -24(%rbp)
	jmp	.L48
.L52:
	movq	-16(%rbp), %rax
	movq	32(%rax), %rdx
	movl	-20(%rbp), %eax
	cltq
	salq	$3, %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	addq	$4, %rax
	movl	(%rax), %eax
	leaq	-24(%rbp), %rcx
	movl	$4, %edx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	write@PLT
	cmpq	$4, %rax
	je	.L49
	movl	$1, %edi
	call	exit@PLT
.L49:
	movq	-16(%rbp), %rax
	movq	32(%rax), %rdx
	movl	-20(%rbp), %eax
	cltq
	salq	$3, %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movl	(%rax), %eax
	leaq	-24(%rbp), %rcx
	movl	$4, %edx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	read@PLT
	cmpq	$4, %rax
	je	.L50
	movl	$1, %edi
	call	exit@PLT
.L50:
	addl	$1, -20(%rbp)
	movq	-16(%rbp), %rax
	movl	16(%rax), %eax
	cmpl	%eax, -20(%rbp)
	jne	.L51
	movl	$0, -20(%rbp)
.L51:
	movq	-16(%rbp), %rax
	movl	(%rax), %eax
	movslq	%eax, %rdx
	movq	-16(%rbp), %rax
	movq	40(%rax), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	bread@PLT
.L48:
	movq	-40(%rbp), %rax
	leaq	-1(%rax), %rdx
	movq	%rdx, -40(%rbp)
	testq	%rax, %rax
	jne	.L52
	nop
	movq	-8(%rbp), %rax
	subq	%fs:40, %rax
	je	.L53
	call	__stack_chk_fail@PLT
.L53:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE11:
	.size	benchmark_overhead, .-benchmark_overhead
	.globl	initialize
	.type	initialize, @function
initialize:
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
	movq	-32(%rbp), %rax
	movq	%rax, -8(%rbp)
	cmpq	$0, -24(%rbp)
	jne	.L58
	movq	-32(%rbp), %rdx
	movq	-24(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	initialize_overhead
	movq	-8(%rbp), %rax
	movl	16(%rax), %eax
	cltq
	salq	$2, %rax
	movq	%rax, %rdi
	call	malloc@PLT
	movq	%rax, %rdx
	movq	-8(%rbp), %rax
	movq	%rdx, 24(%rax)
	movq	-8(%rbp), %rax
	movq	24(%rax), %rax
	testq	%rax, %rax
	jne	.L57
	movl	$1, %edi
	call	exit@PLT
.L57:
	movq	-8(%rbp), %rax
	movl	16(%rax), %eax
	cltq
	leaq	0(,%rax,4), %rdx
	movq	-8(%rbp), %rax
	movq	24(%rax), %rax
	movl	$0, %esi
	movq	%rax, %rdi
	call	memset@PLT
	movq	-8(%rbp), %rax
	movl	(%rax), %ecx
	movq	-8(%rbp), %rax
	movl	16(%rax), %edx
	movq	-8(%rbp), %rax
	movq	24(%rax), %rsi
	movq	-8(%rbp), %rax
	movq	32(%rax), %rax
	movq	%rax, %rdi
	call	create_daemons
	movl	%eax, -12(%rbp)
	movq	-8(%rbp), %rax
	movl	16(%rax), %eax
	cmpl	%eax, -12(%rbp)
	jge	.L54
	movq	-32(%rbp), %rax
	movq	%rax, %rsi
	movl	$0, %edi
	call	cleanup
	movl	$1, %edi
	call	exit@PLT
.L58:
	nop
.L54:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE12:
	.size	initialize, .-initialize
	.globl	cleanup
	.type	cleanup, @function
cleanup:
.LFB13:
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
	jne	.L67
	movq	-32(%rbp), %rdx
	movq	-24(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	cleanup_overhead
	movl	$1, -12(%rbp)
	jmp	.L62
.L65:
	movq	-8(%rbp), %rax
	movq	24(%rax), %rdx
	movl	-12(%rbp), %eax
	cltq
	salq	$2, %rax
	addq	%rdx, %rax
	movl	(%rax), %eax
	testl	%eax, %eax
	jle	.L63
	movq	-8(%rbp), %rax
	movq	24(%rax), %rdx
	movl	-12(%rbp), %eax
	cltq
	salq	$2, %rax
	addq	%rdx, %rax
	movl	(%rax), %eax
	movl	$9, %esi
	movl	%eax, %edi
	call	kill@PLT
	movq	-8(%rbp), %rax
	movq	24(%rax), %rdx
	movl	-12(%rbp), %eax
	cltq
	salq	$2, %rax
	addq	%rdx, %rax
	movl	(%rax), %eax
	movl	$0, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	waitpid@PLT
.L63:
	addl	$1, -12(%rbp)
.L62:
	movq	-8(%rbp), %rax
	movq	24(%rax), %rax
	testq	%rax, %rax
	je	.L64
	movq	-8(%rbp), %rax
	movl	16(%rax), %eax
	cmpl	%eax, -12(%rbp)
	jl	.L65
.L64:
	movq	-8(%rbp), %rax
	movq	24(%rax), %rax
	testq	%rax, %rax
	je	.L66
	movq	-8(%rbp), %rax
	movq	24(%rax), %rax
	movq	%rax, %rdi
	call	free@PLT
.L66:
	movq	-8(%rbp), %rax
	movq	$0, 24(%rax)
	jmp	.L59
.L67:
	nop
.L59:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE13:
	.size	cleanup, .-cleanup
	.globl	benchmark
	.type	benchmark, @function
benchmark:
.LFB14:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$48, %rsp
	movq	%rdi, -40(%rbp)
	movq	%rsi, -48(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movq	-48(%rbp), %rax
	movq	%rax, -16(%rbp)
	jmp	.L69
.L72:
	movq	-16(%rbp), %rax
	movq	32(%rax), %rax
	movq	(%rax), %rax
	addq	$4, %rax
	movl	(%rax), %eax
	leaq	-20(%rbp), %rcx
	movl	$4, %edx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	write@PLT
	cmpq	$4, %rax
	je	.L70
	movl	$1, %edi
	call	exit@PLT
.L70:
	movq	-16(%rbp), %rax
	movq	32(%rax), %rdx
	movq	-16(%rbp), %rax
	movl	16(%rax), %eax
	cltq
	salq	$3, %rax
	subq	$8, %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movl	(%rax), %eax
	leaq	-20(%rbp), %rcx
	movl	$4, %edx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	read@PLT
	cmpq	$4, %rax
	je	.L71
	movl	$1, %edi
	call	exit@PLT
.L71:
	movq	-16(%rbp), %rax
	movl	(%rax), %eax
	movslq	%eax, %rdx
	movq	-16(%rbp), %rax
	movq	40(%rax), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	bread@PLT
.L69:
	movq	-40(%rbp), %rax
	leaq	-1(%rax), %rdx
	movq	%rdx, -40(%rbp)
	testq	%rax, %rax
	jne	.L72
	nop
	movq	-8(%rbp), %rax
	subq	%fs:40, %rax
	je	.L73
	call	__stack_chk_fail@PLT
.L73:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE14:
	.size	benchmark, .-benchmark
	.globl	doit
	.type	doit, @function
doit:
.LFB15:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$48, %rsp
	movl	%edi, -36(%rbp)
	movl	%esi, -40(%rbp)
	movl	%edx, -44(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movq	$0, -16(%rbp)
	cmpl	$0, -44(%rbp)
	je	.L81
	movl	-44(%rbp), %eax
	cltq
	movq	%rax, %rdi
	call	malloc@PLT
	movq	%rax, -16(%rbp)
	cmpq	$0, -16(%rbp)
	jne	.L76
	leaq	.LC6(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$3, %edi
	call	exit@PLT
.L76:
	movl	-44(%rbp), %eax
	cltq
	movq	-16(%rbp), %rdx
	movq	%rdx, %rcx
	movq	%rax, %rdx
	movl	$0, %esi
	movq	%rcx, %rdi
	call	memset@PLT
.L81:
	leaq	-20(%rbp), %rcx
	movl	-36(%rbp), %eax
	movl	$4, %edx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	read@PLT
	cmpq	$4, %rax
	jne	.L83
	cmpl	$0, -44(%rbp)
	je	.L79
	movl	-44(%rbp), %eax
	movslq	%eax, %rdx
	movq	-16(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	bread@PLT
.L79:
	leaq	-20(%rbp), %rcx
	movl	-40(%rbp), %eax
	movl	$4, %edx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	write@PLT
	cmpq	$4, %rax
	jne	.L84
	jmp	.L81
.L83:
	nop
	jmp	.L78
.L84:
	nop
.L78:
	movl	$1, %edi
	call	exit@PLT
	.cfi_endproc
.LFE15:
	.size	doit, .-doit
	.globl	create_daemons
	.type	create_daemons, @function
create_daemons:
.LFB16:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%rbx
	subq	$72, %rsp
	.cfi_offset 3, -24
	movq	%rdi, -56(%rbp)
	movq	%rsi, -64(%rbp)
	movl	%edx, -68(%rbp)
	movl	%ecx, -72(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -24(%rbp)
	xorl	%eax, %eax
	movl	-68(%rbp), %eax
	leal	-1(%rax), %ebx
	movl	$0, %eax
	call	benchmp_childid@PLT
	movl	%ebx, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	handle_scheduler@PLT
	movl	$1, -32(%rbp)
	jmp	.L86
.L95:
	movl	-32(%rbp), %eax
	cltq
	leaq	0(,%rax,4), %rdx
	movq	-64(%rbp), %rax
	leaq	(%rdx,%rax), %rbx
	call	fork@PLT
	movl	%eax, (%rbx)
	movl	(%rbx), %eax
	cmpl	$-1, %eax
	je	.L87
	testl	%eax, %eax
	je	.L88
	jmp	.L89
.L87:
	movl	-32(%rbp), %eax
	jmp	.L98
.L88:
	movl	-68(%rbp), %eax
	leal	-1(%rax), %ebx
	movl	$0, %eax
	call	benchmp_childid@PLT
	movl	%eax, %ecx
	movl	-32(%rbp), %eax
	movl	%ebx, %edx
	movl	%eax, %esi
	movl	%ecx, %edi
	call	handle_scheduler@PLT
	movl	$0, -28(%rbp)
	jmp	.L91
.L94:
	movl	-32(%rbp), %eax
	subl	$1, %eax
	cmpl	%eax, -28(%rbp)
	je	.L92
	movl	-28(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-56(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movl	(%rax), %eax
	movl	%eax, %edi
	call	close@PLT
.L92:
	movl	-28(%rbp), %eax
	cmpl	-32(%rbp), %eax
	je	.L93
	movl	-28(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-56(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	addq	$4, %rax
	movl	(%rax), %eax
	movl	%eax, %edi
	call	close@PLT
.L93:
	addl	$1, -28(%rbp)
.L91:
	movl	-28(%rbp), %eax
	cmpl	-68(%rbp), %eax
	jl	.L94
	movl	-32(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-56(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	addq	$4, %rax
	movl	(%rax), %ecx
	movl	-32(%rbp), %eax
	cltq
	salq	$3, %rax
	leaq	-8(%rax), %rdx
	movq	-56(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movl	(%rax), %eax
	movl	-72(%rbp), %edx
	movl	%ecx, %esi
	movl	%eax, %edi
	call	doit
.L89:
	addl	$1, -32(%rbp)
.L86:
	movl	-32(%rbp), %eax
	cmpl	-68(%rbp), %eax
	jl	.L95
	movq	-56(%rbp), %rax
	movq	(%rax), %rax
	addq	$4, %rax
	movl	(%rax), %eax
	leaq	-36(%rbp), %rcx
	movl	$4, %edx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	write@PLT
	cmpq	$4, %rax
	jne	.L96
	movl	-68(%rbp), %eax
	cltq
	salq	$3, %rax
	leaq	-8(%rax), %rdx
	movq	-56(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movl	(%rax), %eax
	leaq	-36(%rbp), %rcx
	movl	$4, %edx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	read@PLT
	cmpq	$4, %rax
	je	.L97
.L96:
	movl	$1, %edi
	call	exit@PLT
.L97:
	movl	-68(%rbp), %eax
.L98:
	movq	-24(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L99
	call	__stack_chk_fail@PLT
.L99:
	movq	-8(%rbp), %rbx
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE16:
	.size	create_daemons, .-create_daemons
	.globl	create_pipes
	.type	create_pipes, @function
create_pipes:
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
	movl	%esi, -28(%rbp)
	call	morefds@PLT
	movl	$0, -4(%rbp)
	jmp	.L101
.L104:
	movl	-4(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	pipe@PLT
	cmpl	$-1, %eax
	jne	.L102
	movl	-4(%rbp), %eax
	jmp	.L103
.L102:
	addl	$1, -4(%rbp)
.L101:
	movl	-4(%rbp), %eax
	cmpl	-28(%rbp), %eax
	jl	.L104
	movl	-28(%rbp), %eax
.L103:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE17:
	.size	create_pipes, .-create_pipes
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
