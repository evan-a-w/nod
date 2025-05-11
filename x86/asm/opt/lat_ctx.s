	.file	"lat_ctx.c"
	.text
	.globl	cleanup_overhead
	.type	cleanup_overhead, @function
cleanup_overhead:
.LFB74:
	.cfi_startproc
	endbr64
	testq	%rdi, %rdi
	jne	.L7
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushq	%rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	subq	$8, %rsp
	.cfi_def_cfa_offset 32
	movq	%rdi, %rbx
	movq	%rsi, %rbp
	cmpl	$0, 16(%rsi)
	jle	.L3
.L4:
	movq	32(%rbp), %rax
	movq	(%rax,%rbx,8), %rax
	movl	(%rax), %edi
	call	close@PLT
	movq	32(%rbp), %rax
	movq	(%rax,%rbx,8), %rax
	movl	4(%rax), %edi
	call	close@PLT
	addq	$1, %rbx
	cmpl	%ebx, 16(%rbp)
	jg	.L4
.L3:
	movq	32(%rbp), %rdi
	call	free@PLT
	movq	40(%rbp), %rdi
	testq	%rdi, %rdi
	je	.L1
	call	free@PLT
.L1:
	addq	$8, %rsp
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
.L7:
	.cfi_restore 3
	.cfi_restore 6
	ret
	.cfi_endproc
.LFE74:
	.size	cleanup_overhead, .-cleanup_overhead
	.globl	benchmark_overhead
	.type	benchmark_overhead, @function
benchmark_overhead:
.LFB75:
	.cfi_startproc
	endbr64
	pushq	%r14
	.cfi_def_cfa_offset 16
	.cfi_offset 14, -16
	pushq	%r13
	.cfi_def_cfa_offset 24
	.cfi_offset 13, -24
	pushq	%r12
	.cfi_def_cfa_offset 32
	.cfi_offset 12, -32
	pushq	%rbp
	.cfi_def_cfa_offset 40
	.cfi_offset 6, -40
	pushq	%rbx
	.cfi_def_cfa_offset 48
	.cfi_offset 3, -48
	subq	$16, %rsp
	.cfi_def_cfa_offset 64
	movq	%fs:40, %rax
	movq	%rax, 8(%rsp)
	xorl	%eax, %eax
	movl	$1, 4(%rsp)
	testq	%rdi, %rdi
	je	.L10
	movq	%rsi, %rbp
	leaq	-1(%rdi), %r12
	movl	$0, %ebx
	leaq	4(%rsp), %r14
.L15:
	movslq	%ebx, %r13
	movq	32(%rbp), %rax
	movq	(%rax,%r13,8), %rax
	movl	4(%rax), %edi
	movl	$4, %edx
	movq	%r14, %rsi
	call	write@PLT
	cmpq	$4, %rax
	jne	.L19
	movq	32(%rbp), %rax
	movq	(%rax,%r13,8), %rax
	movl	$4, %edx
	movq	%r14, %rsi
	movl	(%rax), %edi
	call	read@PLT
	cmpq	$4, %rax
	jne	.L20
	addl	$1, %ebx
	cmpl	%ebx, 16(%rbp)
	movl	$0, %eax
	cmove	%eax, %ebx
	movslq	0(%rbp), %rsi
	movq	40(%rbp), %rdi
	call	bread@PLT
	subq	$1, %r12
	cmpq	$-1, %r12
	jne	.L15
.L10:
	movq	8(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L21
	addq	$16, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 48
	popq	%rbx
	.cfi_def_cfa_offset 40
	popq	%rbp
	.cfi_def_cfa_offset 32
	popq	%r12
	.cfi_def_cfa_offset 24
	popq	%r13
	.cfi_def_cfa_offset 16
	popq	%r14
	.cfi_def_cfa_offset 8
	ret
.L19:
	.cfi_restore_state
	movl	$1, %edi
	call	exit@PLT
.L20:
	movl	$1, %edi
	call	exit@PLT
.L21:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE75:
	.size	benchmark_overhead, .-benchmark_overhead
	.globl	benchmark
	.type	benchmark, @function
benchmark:
.LFB78:
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
	subq	$16, %rsp
	.cfi_def_cfa_offset 48
	movq	%fs:40, %rax
	movq	%rax, 8(%rsp)
	xorl	%eax, %eax
	testq	%rdi, %rdi
	je	.L22
	movq	%rsi, %rbx
	leaq	-1(%rdi), %rbp
	leaq	4(%rsp), %r12
.L26:
	movq	32(%rbx), %rax
	movq	(%rax), %rax
	movl	4(%rax), %edi
	movl	$4, %edx
	movq	%r12, %rsi
	call	write@PLT
	cmpq	$4, %rax
	jne	.L30
	movslq	16(%rbx), %rdx
	movq	32(%rbx), %rax
	movq	-8(%rax,%rdx,8), %rax
	movl	$4, %edx
	movq	%r12, %rsi
	movl	(%rax), %edi
	call	read@PLT
	cmpq	$4, %rax
	jne	.L31
	movslq	(%rbx), %rsi
	movq	40(%rbx), %rdi
	call	bread@PLT
	subq	$1, %rbp
	cmpq	$-1, %rbp
	jne	.L26
.L22:
	movq	8(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L32
	addq	$16, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 32
	popq	%rbx
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	ret
.L30:
	.cfi_restore_state
	movl	$1, %edi
	call	exit@PLT
.L31:
	movl	$1, %edi
	call	exit@PLT
.L32:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE78:
	.size	benchmark, .-benchmark
	.globl	cleanup
	.type	cleanup, @function
cleanup:
.LFB77:
	.cfi_startproc
	endbr64
	testq	%rdi, %rdi
	je	.L46
	ret
.L46:
	pushq	%r12
	.cfi_def_cfa_offset 16
	.cfi_offset 12, -16
	pushq	%rbp
	.cfi_def_cfa_offset 24
	.cfi_offset 6, -24
	pushq	%rbx
	.cfi_def_cfa_offset 32
	.cfi_offset 3, -32
	movq	%rsi, %rbx
	call	cleanup_overhead
	movq	24(%rbx), %rdi
	movl	$4, %ebp
	movl	$1, %r12d
	testq	%rdi, %rdi
	jne	.L35
	jmp	.L39
.L37:
	addl	$1, %r12d
	movq	24(%rbx), %rdi
	addq	$4, %rbp
	testq	%rdi, %rdi
	je	.L39
.L35:
	cmpl	%r12d, 16(%rbx)
	jle	.L47
	movl	(%rdi,%rbp), %edi
	testl	%edi, %edi
	jle	.L37
	movl	$9, %esi
	call	kill@PLT
	movq	24(%rbx), %rax
	movl	(%rax,%rbp), %edi
	movl	$0, %edx
	movl	$0, %esi
	call	waitpid@PLT
	jmp	.L37
.L47:
	testq	%rdi, %rdi
	je	.L39
	call	free@PLT
.L39:
	movq	$0, 24(%rbx)
	popq	%rbx
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE77:
	.size	cleanup, .-cleanup
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC1:
	.string	"[-P <parallelism>] [-W <warmup>] [-N <repetitions>] [-s kbytes] processes [processes ...]\n"
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC2:
	.string	"s:P:W:N:"
.LC3:
	.string	"\n\"size=%dk ovr=%.2f\n"
.LC4:
	.string	"%d %.2f\n"
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
	subq	$88, %rsp
	.cfi_offset 15, -24
	.cfi_offset 14, -32
	.cfi_offset 13, -40
	.cfi_offset 12, -48
	.cfi_offset 3, -56
	movl	%edi, %r12d
	movq	%rsi, %r13
	movq	%fs:40, %rax
	movq	%rax, -56(%rbp)
	xorl	%eax, %eax
	movl	$0, -112(%rbp)
	movq	$0x000000000, -104(%rbp)
	movq	$0, -88(%rbp)
	movl	$-1, %r14d
	movl	$0, -124(%rbp)
	movl	$1, -128(%rbp)
	leaq	.LC2(%rip), %rbx
	jmp	.L49
.L51:
	cmpl	$115, %eax
	jne	.L54
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	sall	$10, %eax
	movl	%eax, -112(%rbp)
	jmp	.L49
.L50:
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	movl	%eax, -124(%rbp)
.L49:
	movq	%rbx, %rdx
	movq	%r13, %rsi
	movl	%r12d, %edi
	call	mygetopt@PLT
	cmpl	$-1, %eax
	je	.L78
	cmpl	$87, %eax
	je	.L50
	jg	.L51
	cmpl	$78, %eax
	je	.L52
	cmpl	$80, %eax
	jne	.L54
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	movl	%eax, -128(%rbp)
	testl	%eax, %eax
	jg	.L49
	leaq	.LC1(%rip), %rdx
	movq	%r13, %rsi
	movl	%r12d, %edi
	call	lmbench_usage@PLT
	jmp	.L49
.L52:
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	movl	%eax, %r14d
	jmp	.L49
.L54:
	leaq	.LC1(%rip), %rdx
	movq	%r13, %rsi
	movl	%r12d, %edi
	call	lmbench_usage@PLT
	jmp	.L49
.L78:
	cmpl	%r12d, myoptind(%rip)
	jge	.L79
.L58:
	movslq	myoptind(%rip), %rax
	movq	0(%r13,%rax,8), %rdi
	movl	$10, %edx
	movl	$0, %esi
	call	strtol@PLT
	movl	%eax, -120(%rbp)
	movl	myoptind(%rip), %eax
	cmpl	%eax, %r12d
	jle	.L59
	movslq	%eax, %rdx
	leaq	0(%r13,%rdx,8), %rbx
	movl	%r12d, %ecx
	subl	%eax, %ecx
	leal	-1(%rcx), %eax
	addq	%rdx, %rax
	leaq	8(%r13,%rax,8), %r15
.L60:
	movl	$10, %edx
	movl	$0, %esi
	movq	(%rbx), %rdi
	call	strtol@PLT
	movl	%eax, -96(%rbp)
	movl	-120(%rbp), %ecx
	cmpl	%eax, %ecx
	cmovge	%ecx, %eax
	movl	%eax, -120(%rbp)
	addq	$8, %rbx
	cmpq	%r15, %rbx
	jne	.L60
.L59:
	movl	-120(%rbp), %eax
	movl	%eax, -96(%rbp)
	leaq	-112(%rbp), %rax
	pushq	%rax
	pushq	%r14
	movl	-124(%rbp), %r9d
	movl	$1, %r8d
	movl	$0, %ecx
	leaq	cleanup_overhead(%rip), %rdx
	leaq	benchmark_overhead(%rip), %rsi
	leaq	initialize_overhead(%rip), %rdi
	call	benchmp@PLT
	call	usecs_spent@PLT
	addq	$16, %rsp
	testq	%rax, %rax
	jne	.L80
.L61:
	movq	-56(%rbp), %rax
	subq	%fs:40, %rax
	jne	.L81
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
.L79:
	.cfi_restore_state
	leaq	.LC1(%rip), %rdx
	movq	%r13, %rsi
	movl	%r12d, %edi
	call	lmbench_usage@PLT
	jmp	.L58
.L80:
	call	usecs_spent@PLT
	testq	%rax, %rax
	js	.L62
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
.L63:
	movsd	%xmm0, -104(%rbp)
	call	get_n@PLT
	testq	%rax, %rax
	js	.L64
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rax, %xmm1
.L65:
	movsd	-104(%rbp), %xmm0
	divsd	%xmm1, %xmm0
	movsd	%xmm0, -104(%rbp)
	movl	-112(%rbp), %eax
	movl	$1024, %ecx
	cltd
	idivl	%ecx
	movl	%eax, %ecx
	leaq	.LC3(%rip), %rdx
	movl	$1, %esi
	movq	stderr(%rip), %rdi
	movl	$1, %eax
	call	__fprintf_chk@PLT
	movl	myoptind(%rip), %eax
	cmpl	%eax, %r12d
	jle	.L61
	movslq	%eax, %rdx
	leaq	0(%r13,%rdx,8), %rbx
	subl	%eax, %r12d
	leal	-1(%r12), %eax
	addq	%rdx, %rax
	leaq	8(%r13,%rax,8), %r12
	leaq	cleanup(%rip), %r13
	leaq	benchmark(%rip), %r15
	jmp	.L72
.L62:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
	jmp	.L63
.L64:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rdx, %xmm1
	addsd	%xmm1, %xmm1
	jmp	.L65
.L66:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
	movsd	%xmm0, -120(%rbp)
	jmp	.L67
.L68:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rdx, %xmm1
	addsd	%xmm1, %xmm1
	jmp	.L69
.L70:
	addq	$8, %rbx
	cmpq	%r12, %rbx
	je	.L61
.L72:
	movl	$10, %edx
	movl	$0, %esi
	movq	(%rbx), %rdi
	call	strtol@PLT
	movl	%eax, -96(%rbp)
	leaq	-112(%rbp), %rax
	pushq	%rax
	pushq	%r14
	movl	-124(%rbp), %r9d
	movl	-128(%rbp), %r8d
	movl	$0, %ecx
	movq	%r13, %rdx
	movq	%r15, %rsi
	leaq	initialize(%rip), %rdi
	call	benchmp@PLT
	call	usecs_spent@PLT
	testq	%rax, %rax
	js	.L66
	pxor	%xmm3, %xmm3
	cvtsi2sdq	%rax, %xmm3
	movsd	%xmm3, -120(%rbp)
.L67:
	call	get_n@PLT
	testq	%rax, %rax
	js	.L68
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rax, %xmm1
.L69:
	movsd	-120(%rbp), %xmm0
	divsd	%xmm1, %xmm0
	movl	-96(%rbp), %ecx
	pxor	%xmm1, %xmm1
	cvtsi2sdl	%ecx, %xmm1
	divsd	%xmm1, %xmm0
	subsd	-104(%rbp), %xmm0
	addq	$16, %rsp
	pxor	%xmm2, %xmm2
	comisd	%xmm2, %xmm0
	jbe	.L70
	leaq	.LC4(%rip), %rdx
	movl	$1, %esi
	movq	stderr(%rip), %rdi
	movl	$1, %eax
	call	__fprintf_chk@PLT
	jmp	.L70
.L81:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE72:
	.size	main, .-main
	.section	.rodata.str1.1
.LC5:
	.string	"malloc"
	.text
	.globl	doit
	.type	doit, @function
doit:
.LFB79:
	.cfi_startproc
	endbr64
	pushq	%r14
	.cfi_def_cfa_offset 16
	.cfi_offset 14, -16
	pushq	%r13
	.cfi_def_cfa_offset 24
	.cfi_offset 13, -24
	pushq	%r12
	.cfi_def_cfa_offset 32
	.cfi_offset 12, -32
	pushq	%rbp
	.cfi_def_cfa_offset 40
	.cfi_offset 6, -40
	pushq	%rbx
	.cfi_def_cfa_offset 48
	.cfi_offset 3, -48
	subq	$16, %rsp
	.cfi_def_cfa_offset 64
	movl	%edi, %r12d
	movl	%esi, %r13d
	movl	%edx, %ebp
	movq	%fs:40, %rax
	movq	%rax, 8(%rsp)
	xorl	%eax, %eax
	movl	$0, %r14d
	testl	%edx, %edx
	jne	.L92
.L83:
	leaq	4(%rsp), %rbx
	jmp	.L87
.L92:
	movslq	%edx, %rbx
	movq	%rbx, %rdi
	call	malloc@PLT
	movq	%rax, %r14
	testq	%rax, %rax
	je	.L93
	movq	%rbx, %rdx
	movl	$0, %esi
	movq	%rax, %rdi
	call	memset@PLT
	jmp	.L83
.L93:
	leaq	.LC5(%rip), %rdi
	call	perror@PLT
	movl	$3, %edi
	call	exit@PLT
.L86:
	movl	$4, %edx
	movq	%rbx, %rsi
	movl	%r13d, %edi
	call	write@PLT
	cmpq	$4, %rax
	jne	.L85
.L87:
	movl	$4, %edx
	movq	%rbx, %rsi
	movl	%r12d, %edi
	call	read@PLT
	cmpq	$4, %rax
	jne	.L85
	testl	%ebp, %ebp
	je	.L86
	movslq	%ebp, %rsi
	movq	%r14, %rdi
	call	bread@PLT
	jmp	.L86
.L85:
	movl	$1, %edi
	call	exit@PLT
	.cfi_endproc
.LFE79:
	.size	doit, .-doit
	.globl	create_daemons
	.type	create_daemons, @function
create_daemons:
.LFB80:
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
	subq	$40, %rsp
	.cfi_def_cfa_offset 96
	movq	%rdi, (%rsp)
	movq	%rsi, %r12
	movl	%edx, %ebp
	movl	%ecx, 12(%rsp)
	movq	%fs:40, %rax
	movq	%rax, 24(%rsp)
	xorl	%eax, %eax
	leal	-1(%rdx), %r14d
	call	benchmp_childid@PLT
	movl	%eax, %edi
	movl	%r14d, %edx
	movl	$0, %esi
	call	handle_scheduler@PLT
	cmpl	$1, %ebp
	jle	.L95
	movl	%ebp, %r15d
	movl	$1, %ebx
.L101:
	movl	%ebx, %r13d
	call	fork@PLT
	movl	%eax, (%r12,%rbx,4)
	cmpl	$-1, %eax
	je	.L94
	testl	%eax, %eax
	je	.L108
	addq	$1, %rbx
	cmpq	%r15, %rbx
	jne	.L101
.L95:
	leaq	20(%rsp), %rsi
	movq	(%rsp), %rbx
	movq	(%rbx), %rax
	movl	4(%rax), %edi
	movl	$4, %edx
	call	write@PLT
	cmpq	$4, %rax
	jne	.L102
	leaq	20(%rsp), %rsi
	movslq	%ebp, %rax
	movq	-8(%rbx,%rax,8), %rax
	movl	$4, %edx
	movl	(%rax), %edi
	call	read@PLT
	cmpq	$4, %rax
	jne	.L102
	movl	%ebp, %r13d
.L94:
	movq	24(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L109
	movl	%r13d, %eax
	addq	$40, %rsp
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
.L108:
	.cfi_restore_state
	call	benchmp_childid@PLT
	movl	%eax, %edi
	movl	%r14d, %edx
	movl	%ebx, %esi
	call	handle_scheduler@PLT
	movl	%ebp, %r15d
	movl	$0, %ebp
	leal	-1(%rbx), %r12d
	jmp	.L100
.L99:
	addq	$1, %rbp
	cmpq	%r15, %rbp
	je	.L110
.L100:
	movl	%ebp, %r14d
	cmpl	%ebp, %r12d
	je	.L98
	movq	(%rsp), %rax
	movq	(%rax,%rbp,8), %rax
	movl	(%rax), %edi
	call	close@PLT
.L98:
	cmpl	%r13d, %r14d
	je	.L99
	movq	(%rsp), %rax
	movq	(%rax,%rbp,8), %rax
	movl	4(%rax), %edi
	call	close@PLT
	jmp	.L99
.L110:
	movq	(%rsp), %rcx
	movq	(%rcx,%rbx,8), %rax
	movl	4(%rax), %esi
	movq	-8(%rcx,%rbx,8), %rax
	movl	12(%rsp), %edx
	movl	(%rax), %edi
	call	doit
.L102:
	movl	$1, %edi
	call	exit@PLT
.L109:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE80:
	.size	create_daemons, .-create_daemons
	.globl	create_pipes
	.type	create_pipes, @function
create_pipes:
.LFB81:
	.cfi_startproc
	endbr64
	pushq	%r14
	.cfi_def_cfa_offset 16
	.cfi_offset 14, -16
	pushq	%r13
	.cfi_def_cfa_offset 24
	.cfi_offset 13, -24
	pushq	%r12
	.cfi_def_cfa_offset 32
	.cfi_offset 12, -32
	pushq	%rbp
	.cfi_def_cfa_offset 40
	.cfi_offset 6, -40
	pushq	%rbx
	.cfi_def_cfa_offset 48
	.cfi_offset 3, -48
	movq	%rdi, %rbp
	movl	%esi, %r14d
	call	morefds@PLT
	testl	%r14d, %r14d
	jle	.L112
	movl	%r14d, %r13d
	movl	$0, %ebx
.L113:
	movq	0(%rbp,%rbx,8), %rdi
	call	pipe@PLT
	cmpl	$-1, %eax
	je	.L114
	addq	$1, %rbx
	cmpq	%r13, %rbx
	jne	.L113
	jmp	.L112
.L114:
	movl	%ebx, %r14d
.L112:
	movl	%r14d, %eax
	popq	%rbx
	.cfi_def_cfa_offset 40
	popq	%rbp
	.cfi_def_cfa_offset 32
	popq	%r12
	.cfi_def_cfa_offset 24
	popq	%r13
	.cfi_def_cfa_offset 16
	popq	%r14
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE81:
	.size	create_pipes, .-create_pipes
	.globl	initialize_overhead
	.type	initialize_overhead, @function
initialize_overhead:
.LFB73:
	.cfi_startproc
	endbr64
	testq	%rdi, %rdi
	je	.L130
	ret
.L130:
	pushq	%r14
	.cfi_def_cfa_offset 16
	.cfi_offset 14, -16
	pushq	%r13
	.cfi_def_cfa_offset 24
	.cfi_offset 13, -24
	pushq	%r12
	.cfi_def_cfa_offset 32
	.cfi_offset 12, -32
	pushq	%rbp
	.cfi_def_cfa_offset 40
	.cfi_offset 6, -40
	pushq	%rbx
	.cfi_def_cfa_offset 48
	.cfi_offset 3, -48
	movq	%rdi, %rbx
	movq	%rsi, %rbp
	movq	$0, 24(%rsi)
	movl	16(%rsi), %r13d
	movslq	%r13d, %r14
	movq	%r14, %rdi
	salq	$4, %rdi
	call	malloc@PLT
	movq	%rax, %r12
	movq	%rax, 32(%rbp)
	movl	0(%rbp), %edi
	testl	%edi, %edi
	jg	.L131
	movq	$0, 40(%rbp)
	testq	%rax, %rax
	je	.L120
.L121:
	leaq	(%r12,%r14,8), %rsi
	testl	%r13d, %r13d
	jle	.L122
	movl	$0, %eax
.L123:
	movq	32(%rbp), %rdx
	leaq	(%rsi,%rbx), %rcx
	movq	%rcx, (%rdx,%rbx)
	addl	$1, %eax
	addq	$8, %rbx
	cmpl	%eax, 16(%rbp)
	jg	.L123
.L122:
	movq	40(%rbp), %rdi
	testq	%rdi, %rdi
	je	.L124
	movslq	0(%rbp), %rdx
	movl	$0, %esi
	call	memset@PLT
.L124:
	movl	16(%rbp), %esi
	movq	32(%rbp), %rdi
	call	create_pipes
	cmpl	%eax, 16(%rbp)
	jg	.L132
	popq	%rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 40
	popq	%rbp
	.cfi_def_cfa_offset 32
	popq	%r12
	.cfi_def_cfa_offset 24
	popq	%r13
	.cfi_def_cfa_offset 16
	popq	%r14
	.cfi_def_cfa_offset 8
	ret
.L131:
	.cfi_restore_state
	movslq	%edi, %rdi
	call	malloc@PLT
	movq	%rax, 40(%rbp)
	testq	%r12, %r12
	je	.L120
	testq	%rax, %rax
	jne	.L121
.L120:
	leaq	.LC5(%rip), %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L132:
	movq	%rbp, %rsi
	movl	$0, %edi
	call	cleanup_overhead
	movl	$1, %edi
	call	exit@PLT
	.cfi_endproc
.LFE73:
	.size	initialize_overhead, .-initialize_overhead
	.globl	initialize
	.type	initialize, @function
initialize:
.LFB76:
	.cfi_startproc
	endbr64
	testq	%rdi, %rdi
	je	.L140
	ret
.L140:
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
	subq	$8, %rsp
	.cfi_def_cfa_offset 48
	movq	%rsi, %rbx
	call	initialize_overhead
	movl	16(%rbx), %r13d
	movslq	%r13d, %r12
	salq	$2, %r12
	movq	%r12, %rdi
	call	malloc@PLT
	movq	%rax, %rbp
	movq	%rax, 24(%rbx)
	testq	%rax, %rax
	je	.L141
	movq	%r12, %rdx
	movl	$0, %esi
	movq	%rax, %rdi
	call	memset@PLT
	movq	32(%rbx), %rdi
	movl	(%rbx), %ecx
	movl	%r13d, %edx
	movq	%rbp, %rsi
	call	create_daemons
	cmpl	%eax, 16(%rbx)
	jg	.L142
	addq	$8, %rsp
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
.L141:
	.cfi_restore_state
	movl	$1, %edi
	call	exit@PLT
.L142:
	movq	%rbx, %rsi
	movl	$0, %edi
	call	cleanup
	movl	$1, %edi
	call	exit@PLT
	.cfi_endproc
.LFE76:
	.size	initialize, .-initialize
	.globl	id
	.section	.rodata.str1.1
.LC6:
	.string	"$Id$\n"
	.section	.data.rel.local,"aw"
	.align 8
	.type	id, @object
	.size	id, 8
id:
	.quad	.LC6
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
