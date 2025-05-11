	.file	"lib_timing.c"
	.text
	.local	start_tv
	.comm	start_tv,16,16
	.local	stop_tv
	.comm	stop_tv,16,16
	.globl	ftiming
	.bss
	.align 8
	.type	ftiming, @object
	.size	ftiming, 8
ftiming:
	.zero	8
	.local	use_result_dummy
	.comm	use_result_dummy,8,8
	.local	iterations
	.comm	iterations,8,8
	.local	ru_start
	.comm	ru_start,144,32
	.local	ru_stop
	.comm	ru_stop,144,32
	.section	.rodata
	.align 8
.LC2:
	.string	"real=%.2f sys=%.2f user=%.2f idle=%.2f stall=%.0f%% "
	.align 8
.LC3:
	.string	"rd=%d wr=%d min=%d maj=%d ctx=%d\n"
	.text
	.globl	rusage
	.type	rusage, @function
rusage:
.LFB8:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	16+ru_stop(%rip), %rax
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rax, %xmm1
	movq	24+ru_stop(%rip), %rax
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	movsd	.LC0(%rip), %xmm2
	divsd	%xmm2, %xmm0
	addsd	%xmm1, %xmm0
	movq	16+ru_start(%rip), %rax
	pxor	%xmm2, %xmm2
	cvtsi2sdq	%rax, %xmm2
	movq	24+ru_start(%rip), %rax
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rax, %xmm1
	movsd	.LC0(%rip), %xmm3
	divsd	%xmm3, %xmm1
	addsd	%xmm2, %xmm1
	subsd	%xmm1, %xmm0
	movsd	%xmm0, -32(%rbp)
	movq	ru_stop(%rip), %rax
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rax, %xmm1
	movq	8+ru_stop(%rip), %rax
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	movsd	.LC0(%rip), %xmm2
	divsd	%xmm2, %xmm0
	addsd	%xmm1, %xmm0
	movq	ru_start(%rip), %rax
	pxor	%xmm2, %xmm2
	cvtsi2sdq	%rax, %xmm2
	movq	8+ru_start(%rip), %rax
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rax, %xmm1
	movsd	.LC0(%rip), %xmm3
	divsd	%xmm3, %xmm1
	addsd	%xmm2, %xmm1
	subsd	%xmm1, %xmm0
	movsd	%xmm0, -24(%rbp)
	call	timespent
	movq	%xmm0, %rax
	movsd	-32(%rbp), %xmm0
	movapd	%xmm0, %xmm1
	addsd	-24(%rbp), %xmm1
	movq	%rax, %xmm0
	subsd	%xmm1, %xmm0
	movsd	%xmm0, -16(%rbp)
	call	timespent
	movsd	-16(%rbp), %xmm1
	divsd	%xmm0, %xmm1
	movsd	.LC1(%rip), %xmm0
	mulsd	%xmm1, %xmm0
	movsd	%xmm0, -8(%rbp)
	movq	ftiming(%rip), %rax
	testq	%rax, %rax
	jne	.L2
	movq	stderr(%rip), %rax
	movq	%rax, ftiming(%rip)
.L2:
	call	timespent
	movq	%xmm0, %rax
	movq	ftiming(%rip), %rdx
	movsd	-8(%rbp), %xmm3
	movsd	-16(%rbp), %xmm2
	movsd	-24(%rbp), %xmm1
	movsd	-32(%rbp), %xmm0
	movapd	%xmm3, %xmm4
	movapd	%xmm2, %xmm3
	movapd	%xmm1, %xmm2
	movapd	%xmm0, %xmm1
	movq	%rax, %xmm0
	leaq	.LC2(%rip), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	movl	$5, %eax
	call	fprintf@PLT
	movq	128+ru_stop(%rip), %rax
	movl	%eax, %edx
	movq	128+ru_start(%rip), %rax
	movl	%eax, %ecx
	movl	%edx, %eax
	subl	%ecx, %eax
	movl	%eax, %ecx
	movq	136+ru_stop(%rip), %rax
	movl	%eax, %edx
	movq	136+ru_start(%rip), %rax
	movl	%eax, %esi
	movl	%edx, %eax
	subl	%esi, %eax
	leal	(%rcx,%rax), %edx
	movq	72+ru_stop(%rip), %rax
	movl	%eax, %ecx
	movq	72+ru_start(%rip), %rax
	movl	%eax, %esi
	movl	%ecx, %eax
	subl	%esi, %eax
	movl	%eax, %r8d
	movq	64+ru_stop(%rip), %rax
	movl	%eax, %ecx
	movq	64+ru_start(%rip), %rax
	movl	%eax, %esi
	movl	%ecx, %eax
	subl	%esi, %eax
	movl	%eax, %edi
	movq	96+ru_stop(%rip), %rax
	movl	%eax, %ecx
	movq	96+ru_start(%rip), %rax
	movl	%eax, %esi
	movl	%ecx, %eax
	subl	%esi, %eax
	movl	%eax, %ecx
	movq	88+ru_stop(%rip), %rax
	movl	%eax, %esi
	movq	88+ru_start(%rip), %rax
	movl	%eax, %r9d
	movl	%esi, %eax
	subl	%r9d, %eax
	movl	%eax, %esi
	movq	ftiming(%rip), %rax
	subq	$8, %rsp
	pushq	%rdx
	movl	%r8d, %r9d
	movl	%edi, %r8d
	movl	%esi, %edx
	leaq	.LC3(%rip), %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf@PLT
	addq	$16, %rsp
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE8:
	.size	rusage, .-rusage
	.section	.rodata
.LC4:
	.string	"Usage: %s %s"
	.text
	.globl	lmbench_usage
	.type	lmbench_usage, @function
lmbench_usage:
.LFB9:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movl	%edi, -4(%rbp)
	movq	%rsi, -16(%rbp)
	movq	%rdx, -24(%rbp)
	movq	-16(%rbp), %rax
	movq	(%rax), %rdx
	movq	stderr(%rip), %rax
	movq	-24(%rbp), %rcx
	leaq	.LC4(%rip), %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf@PLT
	movl	$-1, %edi
	call	exit@PLT
	.cfi_endproc
.LFE9:
	.size	lmbench_usage, .-lmbench_usage
	.globl	sigchld_wait_handler
	.type	sigchld_wait_handler, @function
sigchld_wait_handler:
.LFB10:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movl	%edi, -4(%rbp)
	movl	$0, %edi
	call	wait@PLT
	leaq	sigchld_wait_handler(%rip), %rax
	movq	%rax, %rsi
	movl	$17, %edi
	call	signal@PLT
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE10:
	.size	sigchld_wait_handler, .-sigchld_wait_handler
	.local	benchmp_sigterm_received
	.comm	benchmp_sigterm_received,4,4
	.local	benchmp_sigchld_received
	.comm	benchmp_sigchld_received,4,4
	.local	benchmp_sigalrm_pid
	.comm	benchmp_sigalrm_pid,4,4
	.local	benchmp_sigalrm_timeout
	.comm	benchmp_sigalrm_timeout,4,4
	.globl	benchmp_sigterm_handler
	.bss
	.align 8
	.type	benchmp_sigterm_handler, @object
	.size	benchmp_sigterm_handler, 8
benchmp_sigterm_handler:
	.zero	8
	.globl	benchmp_sigchld_handler
	.align 8
	.type	benchmp_sigchld_handler, @object
	.size	benchmp_sigchld_handler, 8
benchmp_sigchld_handler:
	.zero	8
	.globl	benchmp_sigalrm_handler
	.align 8
	.type	benchmp_sigalrm_handler, @object
	.size	benchmp_sigalrm_handler, 8
benchmp_sigalrm_handler:
	.zero	8
	.text
	.globl	benchmp_sigterm
	.type	benchmp_sigterm, @function
benchmp_sigterm:
.LFB11:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%edi, -4(%rbp)
	movl	$1, benchmp_sigterm_received(%rip)
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE11:
	.size	benchmp_sigterm, .-benchmp_sigterm
	.globl	benchmp_sigchld
	.type	benchmp_sigchld, @function
benchmp_sigchld:
.LFB12:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movl	%edi, -4(%rbp)
	movl	$0, %esi
	movl	$17, %edi
	call	signal@PLT
	movl	$1, benchmp_sigchld_received(%rip)
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE12:
	.size	benchmp_sigchld, .-benchmp_sigchld
	.globl	benchmp_sigalrm
	.type	benchmp_sigalrm, @function
benchmp_sigalrm:
.LFB13:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movl	%edi, -4(%rbp)
	movl	$1, %esi
	movl	$14, %edi
	call	signal@PLT
	movl	benchmp_sigalrm_pid(%rip), %eax
	movl	$15, %esi
	movl	%eax, %edi
	call	kill@PLT
	movl	$1, benchmp_sigalrm_timeout(%rip)
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE13:
	.size	benchmp_sigalrm, .-benchmp_sigalrm
	.globl	benchmp
	.type	benchmp, @function
benchmp:
.LFB14:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%rbx
	subq	$136, %rsp
	.cfi_offset 3, -24
	movq	%rdi, -104(%rbp)
	movq	%rsi, -112(%rbp)
	movq	%rdx, -120(%rbp)
	movl	%ecx, -124(%rbp)
	movl	%r8d, -128(%rbp)
	movl	%r9d, -132(%rbp)
	movq	24(%rbp), %rax
	movq	%rax, -144(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -24(%rbp)
	xorl	%eax, %eax
	movq	$1, -88(%rbp)
	movq	$0, -72(%rbp)
	movl	-124(%rbp), %eax
	movl	%eax, %edi
	call	get_enough
	movl	%eax, -124(%rbp)
	cmpl	$0, 16(%rbp)
	jns	.L9
	cmpl	$1, -128(%rbp)
	jg	.L10
	cmpl	$999999, -124(%rbp)
	jle	.L11
.L10:
	movl	$1, %eax
	jmp	.L12
.L11:
	movl	$11, %eax
.L12:
	movl	%eax, 16(%rbp)
.L9:
	movl	$0, %edi
	call	settime
	movl	$1, %edi
	call	save_n
	cmpl	$1, -128(%rbp)
	jle	.L13
	movl	-132(%rbp), %r8d
	movl	-124(%rbp), %ecx
	movq	-120(%rbp), %rdx
	movq	-112(%rbp), %rsi
	movq	-104(%rbp), %rax
	pushq	-144(%rbp)
	movl	16(%rbp), %edi
	pushq	%rdi
	movl	%r8d, %r9d
	movl	$1, %r8d
	movq	%rax, %rdi
	call	benchmp
	addq	$16, %rsp
	call	usecs_spent
	testq	%rax, %rax
	je	.L44
	call	get_n
	movq	%rax, -88(%rbp)
	cmpl	$999999, -124(%rbp)
	jg	.L16
	call	get_n
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
	movsd	.LC0(%rip), %xmm1
	mulsd	%xmm1, %xmm0
	movsd	%xmm0, -64(%rbp)
	call	usecs_spent
	testq	%rax, %rax
	js	.L19
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L20
.L19:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L20:
	movsd	-64(%rbp), %xmm1
	divsd	%xmm0, %xmm1
	movsd	%xmm1, -64(%rbp)
	movsd	-64(%rbp), %xmm0
	comisd	.LC5(%rip), %xmm0
	jnb	.L21
	movsd	-64(%rbp), %xmm0
	cvttsd2siq	%xmm0, %rax
	jmp	.L22
.L21:
	movsd	-64(%rbp), %xmm0
	movsd	.LC5(%rip), %xmm1
	subsd	%xmm1, %xmm0
	cvttsd2siq	%xmm0, %rax
	movabsq	$-9223372036854775808, %rdx
	xorq	%rdx, %rax
.L22:
	addq	$1, %rax
	movq	%rax, -88(%rbp)
.L16:
	movl	$0, %edi
	call	settime
	movl	$1, %edi
	call	save_n
.L13:
	leaq	-56(%rbp), %rax
	movq	%rax, %rdi
	call	pipe@PLT
	testl	%eax, %eax
	js	.L45
	leaq	-48(%rbp), %rax
	movq	%rax, %rdi
	call	pipe@PLT
	testl	%eax, %eax
	js	.L45
	leaq	-40(%rbp), %rax
	movq	%rax, %rdi
	call	pipe@PLT
	testl	%eax, %eax
	js	.L45
	leaq	-32(%rbp), %rax
	movq	%rax, %rdi
	call	pipe@PLT
	testl	%eax, %eax
	js	.L45
	movl	$0, benchmp_sigchld_received(%rip)
	movl	$0, benchmp_sigterm_received(%rip)
	leaq	benchmp_sigterm(%rip), %rax
	movq	%rax, %rsi
	movl	$15, %edi
	call	signal@PLT
	movq	%rax, benchmp_sigterm_handler(%rip)
	leaq	benchmp_sigchld(%rip), %rax
	movq	%rax, %rsi
	movl	$17, %edi
	call	signal@PLT
	movq	%rax, benchmp_sigchld_handler(%rip)
	movl	-128(%rbp), %eax
	cltq
	salq	$2, %rax
	movq	%rax, %rdi
	call	malloc@PLT
	movq	%rax, -72(%rbp)
	cmpq	$0, -72(%rbp)
	je	.L46
	movl	-128(%rbp), %eax
	cltq
	leaq	0(,%rax,4), %rdx
	movq	-72(%rbp), %rax
	movl	$0, %esi
	movq	%rax, %rdi
	call	memset@PLT
	movq	$0, -80(%rbp)
	jmp	.L26
.L32:
	movl	benchmp_sigterm_received(%rip), %eax
	testl	%eax, %eax
	jne	.L47
	movq	-80(%rbp), %rax
	leaq	0(,%rax,4), %rdx
	movq	-72(%rbp), %rax
	leaq	(%rdx,%rax), %rbx
	call	fork@PLT
	movl	%eax, (%rbx)
	movl	(%rbx), %eax
	cmpl	$-1, %eax
	je	.L48
	testl	%eax, %eax
	je	.L30
	jmp	.L43
.L30:
	movl	-56(%rbp), %eax
	movl	%eax, %edi
	call	close@PLT
	movl	-44(%rbp), %eax
	movl	%eax, %edi
	call	close@PLT
	movl	-36(%rbp), %eax
	movl	%eax, %edi
	call	close@PLT
	movl	-28(%rbp), %eax
	movl	%eax, %edi
	call	close@PLT
	movq	-80(%rbp), %rax
	movl	$0, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	handle_scheduler@PLT
	movl	-32(%rbp), %edi
	movl	-40(%rbp), %ecx
	movl	-48(%rbp), %r9d
	movl	-52(%rbp), %r10d
	movq	-80(%rbp), %rax
	movl	%eax, %r11d
	movq	-120(%rbp), %rdx
	movq	-112(%rbp), %rsi
	movq	-104(%rbp), %rax
	subq	$8, %rsp
	pushq	-144(%rbp)
	movl	16(%rbp), %r8d
	pushq	%r8
	movl	-128(%rbp), %r8d
	pushq	%r8
	pushq	-88(%rbp)
	movl	-124(%rbp), %r8d
	pushq	%r8
	pushq	%rdi
	pushq	%rcx
	movl	%r10d, %r8d
	movl	%r11d, %ecx
	movq	%rax, %rdi
	call	benchmp_child
	addq	$64, %rsp
	movl	$0, %edi
	call	exit@PLT
.L43:
	addq	$1, -80(%rbp)
.L26:
	movl	-128(%rbp), %eax
	cltq
	cmpq	%rax, -80(%rbp)
	jl	.L32
	movl	-52(%rbp), %eax
	movl	%eax, %edi
	call	close@PLT
	movl	-48(%rbp), %eax
	movl	%eax, %edi
	call	close@PLT
	movl	-40(%rbp), %eax
	movl	%eax, %edi
	call	close@PLT
	movl	-32(%rbp), %eax
	movl	%eax, %edi
	call	close@PLT
	movl	-28(%rbp), %ecx
	movl	-36(%rbp), %edx
	movl	-44(%rbp), %esi
	movl	-56(%rbp), %eax
	movl	-128(%rbp), %r9d
	movq	-72(%rbp), %r8
	movl	-124(%rbp), %edi
	pushq	%rdi
	movl	16(%rbp), %edi
	pushq	%rdi
	movl	-132(%rbp), %edi
	pushq	%rdi
	pushq	-88(%rbp)
	movl	%eax, %edi
	call	benchmp_parent
	addq	$32, %rsp
	jmp	.L33
.L47:
	nop
	jmp	.L28
.L48:
	nop
.L28:
	movl	$0, %esi
	movl	$17, %edi
	call	signal@PLT
	jmp	.L34
.L35:
	movq	-80(%rbp), %rax
	leaq	0(,%rax,4), %rdx
	movq	-72(%rbp), %rax
	addq	%rdx, %rax
	movl	(%rax), %eax
	movl	$15, %esi
	movl	%eax, %edi
	call	kill@PLT
	movq	-80(%rbp), %rax
	leaq	0(,%rax,4), %rdx
	movq	-72(%rbp), %rax
	addq	%rdx, %rax
	movl	(%rax), %eax
	movl	$0, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	waitpid@PLT
.L34:
	subq	$1, -80(%rbp)
	cmpq	$0, -80(%rbp)
	jns	.L35
	nop
.L33:
	movl	-124(%rbp), %eax
	movslq	%eax, %rdx
	imulq	$1125899907, %rdx, %rdx
	shrq	$32, %rdx
	sarl	$17, %edx
	sarl	$31, %eax
	movl	%eax, %ecx
	movl	%edx, %eax
	subl	%ecx, %eax
	addl	$2, %eax
	movl	%eax, benchmp_sigalrm_timeout(%rip)
	movl	benchmp_sigalrm_timeout(%rip), %eax
	cmpl	$4, %eax
	jg	.L36
	movl	$5, benchmp_sigalrm_timeout(%rip)
.L36:
	movl	$0, %esi
	movl	$17, %edi
	call	signal@PLT
	jmp	.L37
.L38:
	movq	-80(%rbp), %rax
	leaq	0(,%rax,4), %rdx
	movq	-72(%rbp), %rax
	addq	%rdx, %rax
	movl	(%rax), %eax
	movl	%eax, benchmp_sigalrm_pid(%rip)
	leaq	benchmp_sigalrm(%rip), %rax
	movq	%rax, %rsi
	movl	$14, %edi
	call	signal@PLT
	movq	%rax, benchmp_sigalrm_handler(%rip)
	movl	benchmp_sigalrm_timeout(%rip), %eax
	movl	%eax, %edi
	call	alarm@PLT
	movq	-80(%rbp), %rax
	leaq	0(,%rax,4), %rdx
	movq	-72(%rbp), %rax
	addq	%rdx, %rax
	movl	(%rax), %eax
	movl	$0, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	waitpid@PLT
	movl	$0, %edi
	call	alarm@PLT
	movq	benchmp_sigalrm_handler(%rip), %rax
	movq	%rax, %rsi
	movl	$14, %edi
	call	signal@PLT
.L37:
	movq	-80(%rbp), %rax
	leaq	-1(%rax), %rdx
	movq	%rdx, -80(%rbp)
	testq	%rax, %rax
	jg	.L38
	cmpq	$0, -72(%rbp)
	je	.L8
	movq	-72(%rbp), %rax
	movq	%rax, %rdi
	call	free@PLT
	jmp	.L8
.L44:
	nop
	jmp	.L8
.L45:
	nop
	jmp	.L8
.L46:
	nop
.L8:
	movq	-24(%rbp), %rax
	subq	%fs:40, %rax
	je	.L41
	call	__stack_chk_fail@PLT
.L41:
	movq	-8(%rbp), %rbx
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE14:
	.size	benchmp, .-benchmp
	.globl	benchmp_parent
	.type	benchmp_parent, @function
benchmp_parent:
.LFB15:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$464, %rsp
	movl	%edi, -436(%rbp)
	movl	%esi, -440(%rbp)
	movl	%edx, -444(%rbp)
	movl	%ecx, -448(%rbp)
	movq	%r8, -456(%rbp)
	movl	%r9d, -460(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movq	$0, -384(%rbp)
	movq	$0, -376(%rbp)
	movq	$0, -368(%rbp)
	movl	benchmp_sigchld_received(%rip), %eax
	testl	%eax, %eax
	jne	.L97
	movl	benchmp_sigterm_received(%rip), %eax
	testl	%eax, %eax
	jne	.L97
	movl	32(%rbp), %eax
	movl	%eax, %edi
	call	sizeof_result
	cltq
	movq	%rax, %rdi
	call	malloc@PLT
	movq	%rax, -384(%rbp)
	movl	-460(%rbp), %eax
	imull	32(%rbp), %eax
	movl	%eax, %edi
	call	sizeof_result
	cltq
	movq	%rax, %rdi
	call	malloc@PLT
	movq	%rax, -376(%rbp)
	movl	-460(%rbp), %eax
	cltq
	movq	%rax, %rdi
	call	malloc@PLT
	movq	%rax, -368(%rbp)
	cmpq	$0, -384(%rbp)
	je	.L98
	cmpq	$0, -376(%rbp)
	je	.L98
	cmpq	$0, -368(%rbp)
	je	.L98
	movl	$0, -424(%rbp)
	jmp	.L56
.L65:
	movl	$0, -416(%rbp)
	leaq	-272(%rbp), %rax
	movq	%rax, -320(%rbp)
	movl	$0, -412(%rbp)
	jmp	.L57
.L58:
	movq	-320(%rbp), %rax
	movl	-412(%rbp), %edx
	movq	$0, (%rax,%rdx,8)
	addl	$1, -412(%rbp)
.L57:
	cmpl	$15, -412(%rbp)
	jbe	.L58
	leaq	-144(%rbp), %rax
	movq	%rax, -312(%rbp)
	movl	$0, -408(%rbp)
	jmp	.L59
.L60:
	movq	-312(%rbp), %rax
	movl	-408(%rbp), %edx
	movq	$0, (%rax,%rdx,8)
	addl	$1, -408(%rbp)
.L59:
	cmpl	$15, -408(%rbp)
	jbe	.L60
	movl	-436(%rbp), %eax
	leal	63(%rax), %edx
	testl	%eax, %eax
	cmovs	%edx, %eax
	sarl	$6, %eax
	movl	%eax, %esi
	movslq	%esi, %rax
	movq	-272(%rbp,%rax,8), %rdx
	movl	-436(%rbp), %eax
	andl	$63, %eax
	movl	$1, %edi
	movl	%eax, %ecx
	salq	%cl, %rdi
	movq	%rdi, %rax
	orq	%rax, %rdx
	movslq	%esi, %rax
	movq	%rdx, -272(%rbp,%rax,8)
	movl	-436(%rbp), %eax
	leal	63(%rax), %edx
	testl	%eax, %eax
	cmovs	%edx, %eax
	sarl	$6, %eax
	movl	%eax, %esi
	movslq	%esi, %rax
	movq	-144(%rbp,%rax,8), %rdx
	movl	-436(%rbp), %eax
	andl	$63, %eax
	movl	$1, %edi
	movl	%eax, %ecx
	salq	%cl, %rdi
	movq	%rdi, %rax
	orq	%rax, %rdx
	movslq	%esi, %rax
	movq	%rdx, -144(%rbp,%rax,8)
	movq	$1, -304(%rbp)
	movq	$0, -296(%rbp)
	movl	-436(%rbp), %eax
	leal	1(%rax), %edi
	leaq	-304(%rbp), %rcx
	leaq	-144(%rbp), %rdx
	leaq	-272(%rbp), %rax
	movq	%rcx, %r8
	movq	%rdx, %rcx
	movl	$0, %edx
	movq	%rax, %rsi
	call	select@PLT
	movl	benchmp_sigchld_received(%rip), %eax
	testl	%eax, %eax
	jne	.L99
	movl	benchmp_sigterm_received(%rip), %eax
	testl	%eax, %eax
	jne	.L99
	movl	-436(%rbp), %eax
	leal	63(%rax), %edx
	testl	%eax, %eax
	cmovs	%edx, %eax
	sarl	$6, %eax
	cltq
	movq	-144(%rbp,%rax,8), %rdx
	movl	-436(%rbp), %eax
	andl	$63, %eax
	movl	$1, %esi
	movl	%eax, %ecx
	salq	%cl, %rsi
	movq	%rsi, %rax
	andq	%rdx, %rax
	testq	%rax, %rax
	jne	.L99
	movl	-436(%rbp), %eax
	leal	63(%rax), %edx
	testl	%eax, %eax
	cmovs	%edx, %eax
	sarl	$6, %eax
	cltq
	movq	-272(%rbp,%rax,8), %rdx
	movl	-436(%rbp), %eax
	andl	$63, %eax
	movl	$1, %esi
	movl	%eax, %ecx
	salq	%cl, %rsi
	movq	%rsi, %rax
	andq	%rdx, %rax
	testq	%rax, %rax
	je	.L100
	movl	-460(%rbp), %eax
	cltq
	movl	-424(%rbp), %edx
	movslq	%edx, %rcx
	subq	%rcx, %rax
	movq	%rax, %rdx
	movq	-368(%rbp), %rcx
	movl	-436(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	read@PLT
	movl	%eax, -416(%rbp)
	cmpl	$0, -416(%rbp)
	js	.L101
	jmp	.L64
.L100:
	nop
.L64:
	movl	-416(%rbp), %eax
	addl	%eax, -424(%rbp)
.L56:
	movl	-424(%rbp), %eax
	movslq	%eax, %rdx
	movl	-460(%rbp), %eax
	cltq
	cmpq	%rax, %rdx
	jb	.L65
	cmpl	$0, 24(%rbp)
	jle	.L66
	movl	24(%rbp), %eax
	movslq	%eax, %rdx
	imulq	$1125899907, %rdx, %rdx
	shrq	$32, %rdx
	sarl	$18, %edx
	sarl	$31, %eax
	movl	%eax, %ecx
	movl	%edx, %eax
	subl	%ecx, %eax
	cltq
	movq	%rax, -288(%rbp)
	movl	24(%rbp), %eax
	movslq	%eax, %rdx
	imulq	$1125899907, %rdx, %rdx
	shrq	$32, %rdx
	sarl	$18, %edx
	movl	%eax, %ecx
	sarl	$31, %ecx
	subl	%ecx, %edx
	imull	$1000000, %edx, %ecx
	subl	%ecx, %eax
	movl	%eax, %edx
	movslq	%edx, %rax
	movq	%rax, -280(%rbp)
	leaq	-288(%rbp), %rax
	movq	%rax, %r8
	movl	$0, %ecx
	movl	$0, %edx
	movl	$0, %esi
	movl	$0, %edi
	call	select@PLT
.L66:
	movl	-460(%rbp), %eax
	movslq	%eax, %rdx
	movq	-368(%rbp), %rcx
	movl	-440(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	write@PLT
	movl	$0, -424(%rbp)
	jmp	.L67
.L76:
	movl	$0, -416(%rbp)
	leaq	-272(%rbp), %rax
	movq	%rax, -336(%rbp)
	movl	$0, -404(%rbp)
	jmp	.L68
.L69:
	movq	-336(%rbp), %rax
	movl	-404(%rbp), %edx
	movq	$0, (%rax,%rdx,8)
	addl	$1, -404(%rbp)
.L68:
	cmpl	$15, -404(%rbp)
	jbe	.L69
	leaq	-144(%rbp), %rax
	movq	%rax, -328(%rbp)
	movl	$0, -400(%rbp)
	jmp	.L70
.L71:
	movq	-328(%rbp), %rax
	movl	-400(%rbp), %edx
	movq	$0, (%rax,%rdx,8)
	addl	$1, -400(%rbp)
.L70:
	cmpl	$15, -400(%rbp)
	jbe	.L71
	movl	-436(%rbp), %eax
	leal	63(%rax), %edx
	testl	%eax, %eax
	cmovs	%edx, %eax
	sarl	$6, %eax
	movl	%eax, %esi
	movslq	%esi, %rax
	movq	-272(%rbp,%rax,8), %rdx
	movl	-436(%rbp), %eax
	andl	$63, %eax
	movl	$1, %edi
	movl	%eax, %ecx
	salq	%cl, %rdi
	movq	%rdi, %rax
	orq	%rax, %rdx
	movslq	%esi, %rax
	movq	%rdx, -272(%rbp,%rax,8)
	movl	-436(%rbp), %eax
	leal	63(%rax), %edx
	testl	%eax, %eax
	cmovs	%edx, %eax
	sarl	$6, %eax
	movl	%eax, %esi
	movslq	%esi, %rax
	movq	-144(%rbp,%rax,8), %rdx
	movl	-436(%rbp), %eax
	andl	$63, %eax
	movl	$1, %edi
	movl	%eax, %ecx
	salq	%cl, %rdi
	movq	%rdi, %rax
	orq	%rax, %rdx
	movslq	%esi, %rax
	movq	%rdx, -144(%rbp,%rax,8)
	movq	$1, -304(%rbp)
	movq	$0, -296(%rbp)
	movl	-436(%rbp), %eax
	leal	1(%rax), %edi
	leaq	-304(%rbp), %rcx
	leaq	-144(%rbp), %rdx
	leaq	-272(%rbp), %rax
	movq	%rcx, %r8
	movq	%rdx, %rcx
	movl	$0, %edx
	movq	%rax, %rsi
	call	select@PLT
	movl	benchmp_sigchld_received(%rip), %eax
	testl	%eax, %eax
	jne	.L102
	movl	benchmp_sigterm_received(%rip), %eax
	testl	%eax, %eax
	jne	.L102
	movl	-436(%rbp), %eax
	leal	63(%rax), %edx
	testl	%eax, %eax
	cmovs	%edx, %eax
	sarl	$6, %eax
	cltq
	movq	-144(%rbp,%rax,8), %rdx
	movl	-436(%rbp), %eax
	andl	$63, %eax
	movl	$1, %esi
	movl	%eax, %ecx
	salq	%cl, %rsi
	movq	%rsi, %rax
	andq	%rdx, %rax
	testq	%rax, %rax
	jne	.L102
	movl	-436(%rbp), %eax
	leal	63(%rax), %edx
	testl	%eax, %eax
	cmovs	%edx, %eax
	sarl	$6, %eax
	cltq
	movq	-272(%rbp,%rax,8), %rdx
	movl	-436(%rbp), %eax
	andl	$63, %eax
	movl	$1, %esi
	movl	%eax, %ecx
	salq	%cl, %rsi
	movq	%rsi, %rax
	andq	%rdx, %rax
	testq	%rax, %rax
	je	.L103
	movl	-460(%rbp), %eax
	cltq
	movl	-424(%rbp), %edx
	movslq	%edx, %rcx
	subq	%rcx, %rax
	movq	%rax, %rdx
	movq	-368(%rbp), %rcx
	movl	-436(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	read@PLT
	movl	%eax, -416(%rbp)
	cmpl	$0, -416(%rbp)
	js	.L104
	jmp	.L75
.L103:
	nop
.L75:
	movl	-416(%rbp), %eax
	addl	%eax, -424(%rbp)
.L67:
	movl	-424(%rbp), %eax
	movslq	%eax, %rdx
	movl	-460(%rbp), %eax
	cltq
	cmpq	%rax, %rdx
	jb	.L76
	movq	-376(%rbp), %rax
	movq	%rax, %rdi
	call	insertinit
	movl	$0, -424(%rbp)
	jmp	.L77
.L90:
	movl	32(%rbp), %eax
	movl	%eax, %edi
	call	sizeof_result
	movl	%eax, -396(%rbp)
	movq	-384(%rbp), %rax
	movq	%rax, -360(%rbp)
	leaq	-272(%rbp), %rax
	movq	%rax, -352(%rbp)
	movl	$0, -392(%rbp)
	jmp	.L78
.L79:
	movq	-352(%rbp), %rax
	movl	-392(%rbp), %edx
	movq	$0, (%rax,%rdx,8)
	addl	$1, -392(%rbp)
.L78:
	cmpl	$15, -392(%rbp)
	jbe	.L79
	leaq	-144(%rbp), %rax
	movq	%rax, -344(%rbp)
	movl	$0, -388(%rbp)
	jmp	.L80
.L81:
	movq	-344(%rbp), %rax
	movl	-388(%rbp), %edx
	movq	$0, (%rax,%rdx,8)
	addl	$1, -388(%rbp)
.L80:
	cmpl	$15, -388(%rbp)
	jbe	.L81
	movq	-360(%rbp), %rcx
	movl	-444(%rbp), %eax
	movl	$1, %edx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	write@PLT
	jmp	.L82
.L87:
	movl	$0, -416(%rbp)
	movl	-436(%rbp), %eax
	leal	63(%rax), %edx
	testl	%eax, %eax
	cmovs	%edx, %eax
	sarl	$6, %eax
	movl	%eax, %esi
	movslq	%esi, %rax
	movq	-272(%rbp,%rax,8), %rdx
	movl	-436(%rbp), %eax
	andl	$63, %eax
	movl	$1, %edi
	movl	%eax, %ecx
	salq	%cl, %rdi
	movq	%rdi, %rax
	orq	%rax, %rdx
	movslq	%esi, %rax
	movq	%rdx, -272(%rbp,%rax,8)
	movl	-436(%rbp), %eax
	leal	63(%rax), %edx
	testl	%eax, %eax
	cmovs	%edx, %eax
	sarl	$6, %eax
	movl	%eax, %esi
	movslq	%esi, %rax
	movq	-144(%rbp,%rax,8), %rdx
	movl	-436(%rbp), %eax
	andl	$63, %eax
	movl	$1, %edi
	movl	%eax, %ecx
	salq	%cl, %rdi
	movq	%rdi, %rax
	orq	%rax, %rdx
	movslq	%esi, %rax
	movq	%rdx, -144(%rbp,%rax,8)
	movq	$1, -304(%rbp)
	movq	$0, -296(%rbp)
	movl	-436(%rbp), %eax
	leal	1(%rax), %edi
	leaq	-304(%rbp), %rcx
	leaq	-144(%rbp), %rdx
	leaq	-272(%rbp), %rax
	movq	%rcx, %r8
	movq	%rdx, %rcx
	movl	$0, %edx
	movq	%rax, %rsi
	call	select@PLT
	movl	benchmp_sigchld_received(%rip), %eax
	testl	%eax, %eax
	jne	.L105
	movl	benchmp_sigterm_received(%rip), %eax
	testl	%eax, %eax
	jne	.L105
	movl	-436(%rbp), %eax
	leal	63(%rax), %edx
	testl	%eax, %eax
	cmovs	%edx, %eax
	sarl	$6, %eax
	cltq
	movq	-144(%rbp,%rax,8), %rdx
	movl	-436(%rbp), %eax
	andl	$63, %eax
	movl	$1, %esi
	movl	%eax, %ecx
	salq	%cl, %rsi
	movq	%rsi, %rax
	andq	%rdx, %rax
	testq	%rax, %rax
	jne	.L105
	movl	-436(%rbp), %eax
	leal	63(%rax), %edx
	testl	%eax, %eax
	cmovs	%edx, %eax
	sarl	$6, %eax
	cltq
	movq	-272(%rbp,%rax,8), %rdx
	movl	-436(%rbp), %eax
	andl	$63, %eax
	movl	$1, %esi
	movl	%eax, %ecx
	salq	%cl, %rsi
	movq	%rsi, %rax
	andq	%rdx, %rax
	testq	%rax, %rax
	je	.L106
	movl	-396(%rbp), %eax
	movslq	%eax, %rdx
	movq	-360(%rbp), %rcx
	movl	-436(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	read@PLT
	movl	%eax, -416(%rbp)
	cmpl	$0, -416(%rbp)
	js	.L107
	jmp	.L86
.L106:
	nop
.L86:
	movl	-416(%rbp), %eax
	subl	%eax, -396(%rbp)
	movl	-416(%rbp), %eax
	cltq
	addq	%rax, -360(%rbp)
.L82:
	cmpl	$0, -396(%rbp)
	jg	.L87
	movl	$0, -420(%rbp)
	jmp	.L88
.L89:
	movq	-384(%rbp), %rdx
	movl	-420(%rbp), %eax
	cltq
	salq	$4, %rax
	addq	%rdx, %rax
	addq	$16, %rax
	movq	(%rax), %rcx
	movq	-384(%rbp), %rdx
	movl	-420(%rbp), %eax
	cltq
	salq	$4, %rax
	addq	%rdx, %rax
	addq	$8, %rax
	movq	(%rax), %rax
	movq	-376(%rbp), %rdx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	insertsort
	addl	$1, -420(%rbp)
.L88:
	movq	-384(%rbp), %rax
	movl	(%rax), %eax
	cmpl	%eax, -420(%rbp)
	jl	.L89
	addl	$1, -424(%rbp)
.L77:
	movl	-424(%rbp), %eax
	cmpl	-460(%rbp), %eax
	jl	.L90
	movl	$0, %esi
	movl	$17, %edi
	call	signal@PLT
	movl	-460(%rbp), %eax
	movslq	%eax, %rdx
	movq	-384(%rbp), %rcx
	movl	-448(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	write@PLT
	movq	-376(%rbp), %rax
	movq	%rax, %rdi
	call	set_results
	jmp	.L91
.L97:
	nop
	jmp	.L52
.L99:
	nop
	jmp	.L52
.L101:
	nop
	jmp	.L52
.L102:
	nop
	jmp	.L52
.L104:
	nop
	jmp	.L52
.L105:
	nop
	jmp	.L52
.L107:
	nop
.L52:
	movl	$0, %esi
	movl	$17, %edi
	call	signal@PLT
	movl	$0, -424(%rbp)
	jmp	.L92
.L93:
	movl	-424(%rbp), %eax
	cltq
	leaq	0(,%rax,4), %rdx
	movq	-456(%rbp), %rax
	addq	%rdx, %rax
	movl	(%rax), %eax
	movl	$15, %esi
	movl	%eax, %edi
	call	kill@PLT
	movl	-424(%rbp), %eax
	cltq
	leaq	0(,%rax,4), %rdx
	movq	-456(%rbp), %rax
	addq	%rdx, %rax
	movl	(%rax), %eax
	movl	$0, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	waitpid@PLT
	addl	$1, -424(%rbp)
.L92:
	movl	-424(%rbp), %eax
	cmpl	-460(%rbp), %eax
	jl	.L93
	movq	-376(%rbp), %rax
	movq	%rax, %rdi
	call	free@PLT
.L91:
	movl	-436(%rbp), %eax
	movl	%eax, %edi
	call	close@PLT
	movl	-440(%rbp), %eax
	movl	%eax, %edi
	call	close@PLT
	movl	-444(%rbp), %eax
	movl	%eax, %edi
	call	close@PLT
	movl	-448(%rbp), %eax
	movl	%eax, %edi
	call	close@PLT
	cmpq	$0, -384(%rbp)
	je	.L94
	movq	-384(%rbp), %rax
	movq	%rax, %rdi
	call	free@PLT
.L94:
	cmpq	$0, -368(%rbp)
	je	.L49
	movq	-368(%rbp), %rax
	movq	%rax, %rdi
	call	free@PLT
	jmp	.L49
.L98:
	nop
.L49:
	movq	-8(%rbp), %rax
	subq	%fs:40, %rax
	je	.L96
	call	__stack_chk_fail@PLT
.L96:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE15:
	.size	benchmp_parent, .-benchmp_parent
	.local	_benchmp_child_state
	.comm	_benchmp_child_state,120,32
	.globl	benchmp_childid
	.type	benchmp_childid, @function
benchmp_childid:
.LFB16:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	32+_benchmp_child_state(%rip), %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE16:
	.size	benchmp_childid, .-benchmp_childid
	.globl	benchmp_child_sigchld
	.type	benchmp_child_sigchld, @function
benchmp_child_sigchld:
.LFB17:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movl	%edi, -4(%rbp)
	movq	24+_benchmp_child_state(%rip), %rax
	testq	%rax, %rax
	je	.L111
	movl	$0, %esi
	movl	$17, %edi
	call	signal@PLT
	movq	24+_benchmp_child_state(%rip), %rax
	leaq	_benchmp_child_state(%rip), %rdx
	movq	%rdx, %rsi
	movl	$0, %edi
	call	*%rax
.L111:
	movl	$1, %edi
	call	exit@PLT
	.cfi_endproc
.LFE17:
	.size	benchmp_child_sigchld, .-benchmp_child_sigchld
	.globl	benchmp_child_sigterm
	.type	benchmp_child_sigterm, @function
benchmp_child_sigterm:
.LFB18:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movl	%edi, -20(%rbp)
	movl	$1, %esi
	movl	$15, %edi
	call	signal@PLT
	movq	24+_benchmp_child_state(%rip), %rax
	testq	%rax, %rax
	je	.L113
	movl	$0, %esi
	movl	$17, %edi
	call	signal@PLT
	movq	%rax, -8(%rbp)
	leaq	benchmp_child_sigchld(%rip), %rax
	cmpq	%rax, -8(%rbp)
	je	.L114
	cmpq	$0, -8(%rbp)
	je	.L114
	movq	-8(%rbp), %rax
	movq	%rax, %rsi
	movl	$17, %edi
	call	signal@PLT
.L114:
	movq	24+_benchmp_child_state(%rip), %rax
	leaq	_benchmp_child_state(%rip), %rdx
	movq	%rdx, %rsi
	movl	$0, %edi
	call	*%rax
.L113:
	movl	$0, %edi
	call	exit@PLT
	.cfi_endproc
.LFE18:
	.size	benchmp_child_sigterm, .-benchmp_child_sigterm
	.globl	benchmp_getstate
	.type	benchmp_getstate, @function
benchmp_getstate:
.LFB19:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	leaq	_benchmp_child_state(%rip), %rax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE19:
	.size	benchmp_getstate, .-benchmp_getstate
	.globl	benchmp_child
	.type	benchmp_child, @function
benchmp_child:
.LFB20:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$64, %rsp
	movq	%rdi, -24(%rbp)
	movq	%rsi, -32(%rbp)
	movq	%rdx, -40(%rbp)
	movl	%ecx, -44(%rbp)
	movl	%r8d, -48(%rbp)
	movl	%r9d, -52(%rbp)
	cmpl	$1, 48(%rbp)
	jle	.L118
	call	get_n
	jmp	.L119
.L118:
	movl	$1, %eax
.L119:
	movq	%rax, -8(%rbp)
	movl	$0, _benchmp_child_state(%rip)
	movq	-24(%rbp), %rax
	movq	%rax, 8+_benchmp_child_state(%rip)
	movq	-32(%rbp), %rax
	movq	%rax, 16+_benchmp_child_state(%rip)
	movq	-40(%rbp), %rax
	movq	%rax, 24+_benchmp_child_state(%rip)
	movl	-44(%rbp), %eax
	movl	%eax, 32+_benchmp_child_state(%rip)
	movl	-48(%rbp), %eax
	movl	%eax, 36+_benchmp_child_state(%rip)
	movl	-52(%rbp), %eax
	movl	%eax, 40+_benchmp_child_state(%rip)
	movl	16(%rbp), %eax
	movl	%eax, 44+_benchmp_child_state(%rip)
	movl	24(%rbp), %eax
	movl	%eax, 48+_benchmp_child_state(%rip)
	movl	32(%rbp), %eax
	movl	%eax, 52+_benchmp_child_state(%rip)
	movq	40(%rbp), %rax
	movq	%rax, 56+_benchmp_child_state(%rip)
	movq	-8(%rbp), %rax
	movq	%rax, 80+_benchmp_child_state(%rip)
	movl	48(%rbp), %eax
	movl	%eax, 64+_benchmp_child_state(%rip)
	movl	56(%rbp), %eax
	movl	%eax, 68+_benchmp_child_state(%rip)
	movq	64(%rbp), %rax
	movq	%rax, 72+_benchmp_child_state(%rip)
	movl	$1, 88+_benchmp_child_state(%rip)
	movq	$0, 96+_benchmp_child_state(%rip)
	movl	56(%rbp), %eax
	movl	%eax, %edi
	call	sizeof_result
	movl	%eax, 104+_benchmp_child_state(%rip)
	movl	104+_benchmp_child_state(%rip), %eax
	cltq
	movq	%rax, %rdi
	call	malloc@PLT
	movq	%rax, 112+_benchmp_child_state(%rip)
	movq	112+_benchmp_child_state(%rip), %rax
	testq	%rax, %rax
	je	.L130
	movq	112+_benchmp_child_state(%rip), %rax
	movq	%rax, %rdi
	call	insertinit
	movq	112+_benchmp_child_state(%rip), %rax
	movq	%rax, %rdi
	call	set_results
	movq	benchmp_sigchld_handler(%rip), %rax
	testq	%rax, %rax
	je	.L122
	movq	benchmp_sigchld_handler(%rip), %rax
	movq	%rax, %rsi
	movl	$17, %edi
	call	signal@PLT
	jmp	.L123
.L122:
	leaq	benchmp_child_sigchld(%rip), %rax
	movq	%rax, %rsi
	movl	$17, %edi
	call	signal@PLT
.L123:
	cmpq	$0, -24(%rbp)
	je	.L124
	movq	64(%rbp), %rax
	movq	-24(%rbp), %rdx
	movq	%rax, %rsi
	movl	$0, %edi
	call	*%rdx
.L124:
	movq	benchmp_sigterm_handler(%rip), %rax
	testq	%rax, %rax
	je	.L125
	movq	benchmp_sigterm_handler(%rip), %rax
	movq	%rax, %rsi
	movl	$15, %edi
	call	signal@PLT
	jmp	.L126
.L125:
	leaq	benchmp_child_sigterm(%rip), %rax
	movq	%rax, %rsi
	movl	$15, %edi
	call	signal@PLT
.L126:
	movl	benchmp_sigterm_received(%rip), %eax
	testl	%eax, %eax
	je	.L127
	movl	$15, %edi
	call	benchmp_child_sigterm
.L127:
	movq	112+_benchmp_child_state(%rip), %rax
	movq	%rax, %rdi
	call	insertinit
.L128:
	leaq	_benchmp_child_state(%rip), %rax
	movq	%rax, %rdi
	call	benchmp_interval
	movq	%rax, %rcx
	movq	64(%rbp), %rax
	movq	-32(%rbp), %rdx
	movq	%rax, %rsi
	movq	%rcx, %rdi
	call	*%rdx
	jmp	.L128
.L130:
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE20:
	.size	benchmp_child, .-benchmp_child
	.globl	benchmp_interval
	.type	benchmp_interval, @function
benchmp_interval:
.LFB21:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r12
	pushq	%rbx
	subq	$240, %rsp
	.cfi_offset 12, -24
	.cfi_offset 3, -32
	movq	%rdi, -232(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -24(%rbp)
	xorl	%eax, %eax
	movq	-232(%rbp), %rax
	movq	%rax, -200(%rbp)
	movq	-200(%rbp), %rax
	movl	(%rax), %eax
	cmpl	$1, %eax
	jne	.L132
	movq	-200(%rbp), %rax
	movq	56(%rax), %rax
	jmp	.L133
.L132:
	movq	-200(%rbp), %rax
	movq	80(%rax), %rax
.L133:
	movq	%rax, -216(%rbp)
	movq	-200(%rbp), %rax
	movl	88(%rax), %eax
	testl	%eax, %eax
	je	.L134
	movq	-200(%rbp), %rax
	movl	52(%rax), %eax
	pxor	%xmm0, %xmm0
	cvtsi2sdl	%eax, %xmm0
	movsd	%xmm0, -208(%rbp)
	jmp	.L135
.L134:
	movl	$0, %esi
	movl	$0, %edi
	call	stop
	testq	%rax, %rax
	js	.L136
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L137
.L136:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L137:
	movsd	%xmm0, -208(%rbp)
	movq	-200(%rbp), %rax
	movq	24(%rax), %rax
	testq	%rax, %rax
	je	.L138
	movq	benchmp_sigchld_handler(%rip), %rax
	testq	%rax, %rax
	jne	.L139
	movl	$0, %esi
	movl	$17, %edi
	call	signal@PLT
.L139:
	movq	-200(%rbp), %rax
	movq	24(%rax), %rcx
	movq	-200(%rbp), %rax
	movq	72(%rax), %rdx
	movq	-216(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	*%rcx
.L138:
	movq	-200(%rbp), %rax
	movq	56(%rax), %rax
	movq	%rax, %rdi
	call	save_n
	call	t_overhead
	testq	%rax, %rax
	js	.L140
	pxor	%xmm2, %xmm2
	cvtsi2sdq	%rax, %xmm2
	movsd	%xmm2, -240(%rbp)
	jmp	.L141
.L140:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
	movsd	%xmm0, -240(%rbp)
.L141:
	call	get_n
	testq	%rax, %rax
	js	.L142
	pxor	%xmm3, %xmm3
	cvtsi2sdq	%rax, %xmm3
	movsd	%xmm3, -248(%rbp)
	jmp	.L143
.L142:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
	movsd	%xmm0, -248(%rbp)
.L143:
	call	l_overhead
	mulsd	-248(%rbp), %xmm0
	movsd	-240(%rbp), %xmm1
	addsd	%xmm0, %xmm1
	movsd	-208(%rbp), %xmm0
	subsd	%xmm1, %xmm0
	movsd	%xmm0, -208(%rbp)
	movsd	-208(%rbp), %xmm0
	pxor	%xmm1, %xmm1
	comisd	%xmm1, %xmm0
	jb	.L186
	movsd	-208(%rbp), %xmm0
	comisd	.LC5(%rip), %xmm0
	jnb	.L146
	movsd	-208(%rbp), %xmm0
	cvttsd2siq	%xmm0, %rax
	jmp	.L147
.L146:
	movsd	-208(%rbp), %xmm0
	movsd	.LC5(%rip), %xmm1
	subsd	%xmm1, %xmm0
	cvttsd2siq	%xmm0, %rax
	movabsq	$-9223372036854775808, %rdx
	xorq	%rdx, %rax
.L147:
	testq	%rax, %rax
	js	.L148
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L149
.L148:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L149:
	comisd	.LC5(%rip), %xmm0
	jnb	.L150
	cvttsd2siq	%xmm0, %rax
	jmp	.L152
.L150:
	movsd	.LC5(%rip), %xmm1
	subsd	%xmm1, %xmm0
	cvttsd2siq	%xmm0, %rax
	movabsq	$-9223372036854775808, %rdx
	xorq	%rdx, %rax
	jmp	.L152
.L186:
	movl	$0, %eax
.L152:
	movq	%rax, %rdi
	call	settime
.L135:
	call	getppid@PLT
	cmpl	$1, %eax
	jne	.L153
	movq	-200(%rbp), %rax
	movq	24(%rax), %rax
	testq	%rax, %rax
	je	.L153
	movq	benchmp_sigchld_handler(%rip), %rax
	testq	%rax, %rax
	jne	.L154
	movl	$0, %esi
	movl	$17, %edi
	call	signal@PLT
.L154:
	movq	-200(%rbp), %rax
	movq	24(%rax), %rdx
	movq	-200(%rbp), %rax
	movq	72(%rax), %rax
	movq	%rax, %rsi
	movl	$0, %edi
	call	*%rdx
	movl	$0, %edi
	call	exit@PLT
.L153:
	movq	$0, -176(%rbp)
	movq	$0, -168(%rbp)
	leaq	-160(%rbp), %rax
	movq	%rax, -192(%rbp)
	movl	$0, -220(%rbp)
	jmp	.L155
.L156:
	movq	-192(%rbp), %rax
	movl	-220(%rbp), %edx
	movq	$0, (%rax,%rdx,8)
	addl	$1, -220(%rbp)
.L155:
	cmpl	$15, -220(%rbp)
	jbe	.L156
	movq	-200(%rbp), %rax
	movl	(%rax), %eax
	cmpl	$2, %eax
	je	.L157
	cmpl	$2, %eax
	ja	.L158
	testl	%eax, %eax
	je	.L159
	cmpl	$1, %eax
	je	.L160
	jmp	.L158
.L159:
	movq	-200(%rbp), %rax
	movq	80(%rax), %rax
	movq	%rax, -216(%rbp)
	movq	-200(%rbp), %rax
	movl	40(%rax), %eax
	leal	63(%rax), %edx
	testl	%eax, %eax
	cmovs	%edx, %eax
	sarl	$6, %eax
	movl	%eax, %esi
	movslq	%esi, %rax
	movq	-160(%rbp,%rax,8), %rdx
	movq	-200(%rbp), %rax
	movl	40(%rax), %eax
	andl	$63, %eax
	movl	$1, %edi
	movl	%eax, %ecx
	salq	%cl, %rdi
	movq	%rdi, %rax
	orq	%rax, %rdx
	movslq	%esi, %rax
	movq	%rdx, -160(%rbp,%rax,8)
	movq	-200(%rbp), %rax
	movl	40(%rax), %eax
	leal	1(%rax), %edi
	leaq	-176(%rbp), %rdx
	leaq	-160(%rbp), %rax
	movq	%rdx, %r8
	movl	$0, %ecx
	movl	$0, %edx
	movq	%rax, %rsi
	call	select@PLT
	movq	-200(%rbp), %rax
	movl	40(%rax), %eax
	leal	63(%rax), %edx
	testl	%eax, %eax
	cmovs	%edx, %eax
	sarl	$6, %eax
	cltq
	movq	-160(%rbp,%rax,8), %rdx
	movq	-200(%rbp), %rax
	movl	40(%rax), %eax
	andl	$63, %eax
	movl	$1, %esi
	movl	%eax, %ecx
	salq	%cl, %rsi
	movq	%rsi, %rax
	andq	%rdx, %rax
	testq	%rax, %rax
	je	.L161
	movq	-200(%rbp), %rax
	movl	$1, (%rax)
	movq	-200(%rbp), %rax
	movl	40(%rax), %eax
	leaq	-221(%rbp), %rcx
	movl	$1, %edx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	read@PLT
	movq	-200(%rbp), %rax
	movq	56(%rax), %rax
	movq	%rax, -216(%rbp)
.L161:
	movq	-200(%rbp), %rax
	movl	88(%rax), %eax
	testl	%eax, %eax
	je	.L188
	movq	-200(%rbp), %rax
	movl	$0, 88(%rax)
	movq	-200(%rbp), %rax
	movl	36(%rax), %eax
	leaq	-221(%rbp), %rcx
	movl	$1, %edx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	write@PLT
	jmp	.L188
.L160:
	movq	-200(%rbp), %rax
	movq	56(%rax), %rax
	movq	%rax, -216(%rbp)
	movq	-200(%rbp), %rax
	movl	64(%rax), %eax
	cmpl	$1, %eax
	jg	.L163
	movq	-200(%rbp), %rax
	movl	52(%rax), %eax
	pxor	%xmm1, %xmm1
	cvtsi2sdl	%eax, %xmm1
	movsd	.LC7(%rip), %xmm0
	mulsd	%xmm0, %xmm1
	movsd	-208(%rbp), %xmm0
	comisd	%xmm1, %xmm0
	jbe	.L164
.L163:
	movl	$0, %eax
	call	get_results
	movq	%rax, %r12
	call	get_n
	movq	%rax, %rbx
	call	usecs_spent
	movq	%r12, %rdx
	movq	%rbx, %rsi
	movq	%rax, %rdi
	call	insertsort
	movq	-200(%rbp), %rax
	movq	96(%rax), %rax
	leaq	1(%rax), %rdx
	movq	-200(%rbp), %rax
	movq	%rdx, 96(%rax)
	movq	-200(%rbp), %rax
	movq	96(%rax), %rdx
	movq	-200(%rbp), %rax
	movl	68(%rax), %eax
	cltq
	cmpq	%rax, %rdx
	jl	.L164
	movq	-200(%rbp), %rax
	movl	$2, (%rax)
.L164:
	movq	-200(%rbp), %rax
	movl	64(%rax), %eax
	cmpl	$1, %eax
	jne	.L166
	movq	-200(%rbp), %rax
	movl	52(%rax), %eax
	pxor	%xmm1, %xmm1
	cvtsi2sdl	%eax, %xmm1
	movsd	.LC8(%rip), %xmm0
	mulsd	%xmm1, %xmm0
	comisd	-208(%rbp), %xmm0
	ja	.L167
	movq	-200(%rbp), %rax
	movl	52(%rax), %eax
	pxor	%xmm1, %xmm1
	cvtsi2sdl	%eax, %xmm1
	movsd	.LC9(%rip), %xmm0
	mulsd	%xmm0, %xmm1
	movsd	-208(%rbp), %xmm0
	comisd	%xmm1, %xmm0
	jbe	.L166
.L167:
	movsd	-208(%rbp), %xmm0
	comisd	.LC10(%rip), %xmm0
	jbe	.L187
	movq	-216(%rbp), %rax
	testq	%rax, %rax
	js	.L171
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L172
.L171:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L172:
	divsd	-208(%rbp), %xmm0
	movsd	%xmm0, -184(%rbp)
	movq	-200(%rbp), %rax
	movl	52(%rax), %eax
	pxor	%xmm1, %xmm1
	cvtsi2sdl	%eax, %xmm1
	movsd	.LC11(%rip), %xmm0
	mulsd	%xmm1, %xmm0
	movsd	-184(%rbp), %xmm1
	mulsd	%xmm1, %xmm0
	movsd	%xmm0, -184(%rbp)
	movsd	-184(%rbp), %xmm1
	movsd	.LC12(%rip), %xmm0
	addsd	%xmm1, %xmm0
	comisd	.LC5(%rip), %xmm0
	jnb	.L173
	cvttsd2siq	%xmm0, %rax
	movq	%rax, -216(%rbp)
	jmp	.L174
.L173:
	movsd	.LC5(%rip), %xmm1
	subsd	%xmm1, %xmm0
	cvttsd2siq	%xmm0, %rax
	movq	%rax, -216(%rbp)
	movabsq	$-9223372036854775808, %rax
	xorq	%rax, -216(%rbp)
.L174:
	movq	-216(%rbp), %rax
	movq	%rax, -216(%rbp)
	jmp	.L166
.L187:
	salq	$3, -216(%rbp)
	cmpq	$134217728, -216(%rbp)
	ja	.L175
	pxor	%xmm0, %xmm0
	comisd	-208(%rbp), %xmm0
	jbe	.L166
	cmpq	$1048576, -216(%rbp)
	jbe	.L166
.L175:
	movq	-200(%rbp), %rax
	movl	$2, (%rax)
.L166:
	movq	-200(%rbp), %rax
	movq	-216(%rbp), %rdx
	movq	%rdx, 56(%rax)
	movq	-200(%rbp), %rax
	movl	(%rax), %eax
	cmpl	$2, %eax
	jne	.L189
	movq	-200(%rbp), %rax
	movl	36(%rax), %eax
	leaq	-221(%rbp), %rcx
	movl	$1, %edx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	write@PLT
	movq	-200(%rbp), %rax
	movq	80(%rax), %rax
	movq	%rax, -216(%rbp)
	jmp	.L189
.L157:
	movq	-200(%rbp), %rax
	movq	80(%rax), %rax
	movq	%rax, -216(%rbp)
	movq	-200(%rbp), %rax
	movl	44(%rax), %eax
	leal	63(%rax), %edx
	testl	%eax, %eax
	cmovs	%edx, %eax
	sarl	$6, %eax
	movl	%eax, %esi
	movslq	%esi, %rax
	movq	-160(%rbp,%rax,8), %rdx
	movq	-200(%rbp), %rax
	movl	44(%rax), %eax
	andl	$63, %eax
	movl	$1, %edi
	movl	%eax, %ecx
	salq	%cl, %rdi
	movq	%rdi, %rax
	orq	%rax, %rdx
	movslq	%esi, %rax
	movq	%rdx, -160(%rbp,%rax,8)
	movq	-200(%rbp), %rax
	movl	44(%rax), %eax
	leal	1(%rax), %edi
	leaq	-176(%rbp), %rdx
	leaq	-160(%rbp), %rax
	movq	%rdx, %r8
	movl	$0, %ecx
	movl	$0, %edx
	movq	%rax, %rsi
	call	select@PLT
	movq	-200(%rbp), %rax
	movl	44(%rax), %eax
	leal	63(%rax), %edx
	testl	%eax, %eax
	cmovs	%edx, %eax
	sarl	$6, %eax
	cltq
	movq	-160(%rbp,%rax,8), %rdx
	movq	-200(%rbp), %rax
	movl	44(%rax), %eax
	andl	$63, %eax
	movl	$1, %esi
	movl	%eax, %ecx
	salq	%cl, %rsi
	movq	%rsi, %rax
	andq	%rdx, %rax
	testq	%rax, %rax
	je	.L158
	movq	-200(%rbp), %rax
	movl	44(%rax), %eax
	leaq	-221(%rbp), %rcx
	movl	$1, %edx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	read@PLT
	movq	-200(%rbp), %rax
	movl	104(%rax), %eax
	movslq	%eax, %rbx
	movl	$0, %eax
	call	get_results
	movq	%rax, %rcx
	movq	-200(%rbp), %rax
	movl	36(%rax), %eax
	movq	%rbx, %rdx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	write@PLT
	movq	-200(%rbp), %rax
	movq	24(%rax), %rax
	testq	%rax, %rax
	je	.L178
	movq	benchmp_sigchld_handler(%rip), %rax
	testq	%rax, %rax
	jne	.L179
	movl	$0, %esi
	movl	$17, %edi
	call	signal@PLT
.L179:
	movq	-200(%rbp), %rax
	movq	24(%rax), %rdx
	movq	-200(%rbp), %rax
	movq	72(%rax), %rax
	movq	%rax, %rsi
	movl	$0, %edi
	call	*%rdx
.L178:
	movq	-200(%rbp), %rax
	movl	48(%rax), %eax
	leaq	-221(%rbp), %rcx
	movl	$1, %edx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	read@PLT
	movl	$0, %edi
	call	exit@PLT
.L188:
	nop
	jmp	.L158
.L189:
	nop
.L158:
	movq	-200(%rbp), %rax
	movq	8(%rax), %rax
	testq	%rax, %rax
	je	.L180
	movq	-200(%rbp), %rax
	movq	8(%rax), %rcx
	movq	-200(%rbp), %rax
	movq	72(%rax), %rdx
	movq	-216(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	*%rcx
.L180:
	movl	$0, %edi
	call	start
	movq	-216(%rbp), %rax
	movq	-24(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L182
	call	__stack_chk_fail@PLT
.L182:
	addq	$240, %rsp
	popq	%rbx
	popq	%r12
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE21:
	.size	benchmp_interval, .-benchmp_interval
	.globl	timing
	.type	timing, @function
timing:
.LFB22:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -8(%rbp)
	movq	-8(%rbp), %rax
	movq	%rax, ftiming(%rip)
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE22:
	.size	timing, .-timing
	.globl	start
	.type	start, @function
start:
.LFB23:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	cmpq	$0, -8(%rbp)
	jne	.L192
	leaq	start_tv(%rip), %rax
	movq	%rax, -8(%rbp)
.L192:
	leaq	ru_start(%rip), %rax
	movq	%rax, %rsi
	movl	$0, %edi
	call	getrusage@PLT
	movq	-8(%rbp), %rax
	movl	$0, %esi
	movq	%rax, %rdi
	call	gettimeofday@PLT
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE23:
	.size	start, .-start
	.globl	stop
	.type	stop, @function
stop:
.LFB24:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	cmpq	$0, -16(%rbp)
	jne	.L194
	leaq	stop_tv(%rip), %rax
	movq	%rax, -16(%rbp)
.L194:
	movq	-16(%rbp), %rax
	movl	$0, %esi
	movq	%rax, %rdi
	call	gettimeofday@PLT
	leaq	ru_stop(%rip), %rax
	movq	%rax, %rsi
	movl	$0, %edi
	call	getrusage@PLT
	cmpq	$0, -8(%rbp)
	jne	.L195
	leaq	start_tv(%rip), %rax
	movq	%rax, -8(%rbp)
.L195:
	movq	-16(%rbp), %rdx
	movq	-8(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	tvdelta
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE24:
	.size	stop, .-stop
	.globl	now
	.type	now, @function
now:
.LFB25:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$48, %rsp
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	leaq	-32(%rbp), %rax
	movl	$0, %esi
	movq	%rax, %rdi
	call	gettimeofday@PLT
	movq	-32(%rbp), %rax
	movq	%rax, -40(%rbp)
	movq	-40(%rbp), %rax
	imulq	$1000000, %rax, %rax
	movq	%rax, -40(%rbp)
	movq	-24(%rbp), %rax
	addq	%rax, -40(%rbp)
	movq	-40(%rbp), %rax
	movq	-8(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L199
	call	__stack_chk_fail@PLT
.L199:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE25:
	.size	now, .-now
	.globl	Now
	.type	Now, @function
Now:
.LFB26:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	leaq	-32(%rbp), %rax
	movl	$0, %esi
	movq	%rax, %rdi
	call	gettimeofday@PLT
	movq	-32(%rbp), %rax
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rax, %xmm1
	movsd	.LC0(%rip), %xmm0
	mulsd	%xmm0, %xmm1
	movq	-24(%rbp), %rax
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	addsd	%xmm1, %xmm0
	movq	%xmm0, %rax
	movq	-8(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L202
	call	__stack_chk_fail@PLT
.L202:
	movq	%rax, %xmm0
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE26:
	.size	Now, .-Now
	.globl	delta
	.type	delta, @function
delta:
.LFB27:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$64, %rsp
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	leaq	-48(%rbp), %rax
	movl	$0, %esi
	movq	%rax, %rdi
	call	gettimeofday@PLT
	movq	8+last.13(%rip), %rax
	testq	%rax, %rax
	je	.L204
	leaq	-48(%rbp), %rcx
	leaq	-32(%rbp), %rax
	leaq	last.13(%rip), %rdx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	tvsub
	movq	-48(%rbp), %rax
	movq	-40(%rbp), %rdx
	movq	%rax, last.13(%rip)
	movq	%rdx, 8+last.13(%rip)
	movq	-32(%rbp), %rax
	movq	%rax, -56(%rbp)
	movq	-56(%rbp), %rax
	imulq	$1000000, %rax, %rax
	movq	%rax, -56(%rbp)
	movq	-24(%rbp), %rax
	addq	%rax, -56(%rbp)
	movq	-56(%rbp), %rax
	jmp	.L206
.L204:
	movq	-48(%rbp), %rax
	movq	-40(%rbp), %rdx
	movq	%rax, last.13(%rip)
	movq	%rdx, 8+last.13(%rip)
	movl	$0, %eax
.L206:
	movq	-8(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L207
	call	__stack_chk_fail@PLT
.L207:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE27:
	.size	delta, .-delta
	.globl	Delta
	.type	Delta, @function
Delta:
.LFB28:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$48, %rsp
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	leaq	-48(%rbp), %rax
	movl	$0, %esi
	movq	%rax, %rdi
	call	gettimeofday@PLT
	leaq	-48(%rbp), %rcx
	leaq	-32(%rbp), %rax
	leaq	start_tv(%rip), %rdx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	tvsub
	movq	-32(%rbp), %rax
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rax, %xmm1
	movq	-24(%rbp), %rax
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	movsd	.LC0(%rip), %xmm2
	divsd	%xmm2, %xmm0
	addsd	%xmm1, %xmm0
	movq	%xmm0, %rax
	movq	-8(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L210
	call	__stack_chk_fail@PLT
.L210:
	movq	%rax, %xmm0
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE28:
	.size	Delta, .-Delta
	.globl	save_n
	.type	save_n, @function
save_n:
.LFB29:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -8(%rbp)
	movq	-8(%rbp), %rax
	movq	%rax, iterations(%rip)
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE29:
	.size	save_n, .-save_n
	.globl	get_n
	.type	get_n, @function
get_n:
.LFB30:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	iterations(%rip), %rax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE30:
	.size	get_n, .-get_n
	.globl	settime
	.type	settime, @function
settime:
.LFB31:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -8(%rbp)
	movq	$0, start_tv(%rip)
	movq	$0, 8+start_tv(%rip)
	movq	-8(%rbp), %rax
	movabsq	$4835703278458516699, %rdx
	mulq	%rdx
	movq	%rdx, %rax
	shrq	$18, %rax
	movq	%rax, stop_tv(%rip)
	movq	-8(%rbp), %rcx
	movabsq	$4835703278458516699, %rdx
	movq	%rcx, %rax
	mulq	%rdx
	movq	%rdx, %rax
	shrq	$18, %rax
	imulq	$1000000, %rax, %rdx
	movq	%rcx, %rax
	subq	%rdx, %rax
	movq	%rax, 8+stop_tv(%rip)
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE31:
	.size	settime, .-settime
	.section	.rodata
	.align 8
.LC13:
	.string	"%.4f MB in %.4f secs, %.4f MB/sec\n"
.LC14:
	.string	"%.6f "
.LC15:
	.string	"%.2f "
.LC16:
	.string	"%.6f\n"
.LC17:
	.string	"%.2f\n"
	.text
	.globl	bandwidth
	.type	bandwidth, @function
bandwidth:
.LFB32:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$80, %rsp
	movq	%rdi, -56(%rbp)
	movq	%rsi, -64(%rbp)
	movl	%edx, -68(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	leaq	-32(%rbp), %rax
	leaq	start_tv(%rip), %rdx
	leaq	stop_tv(%rip), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	tvsub
	movq	-32(%rbp), %rax
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	movsd	%xmm0, -48(%rbp)
	movsd	-48(%rbp), %xmm1
	movsd	.LC0(%rip), %xmm0
	mulsd	%xmm1, %xmm0
	movsd	%xmm0, -48(%rbp)
	movq	-24(%rbp), %rax
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	movsd	-48(%rbp), %xmm1
	addsd	%xmm1, %xmm0
	movsd	%xmm0, -48(%rbp)
	movsd	-48(%rbp), %xmm0
	movsd	.LC0(%rip), %xmm1
	divsd	%xmm1, %xmm0
	movsd	%xmm0, -48(%rbp)
	movq	-64(%rbp), %rax
	testq	%rax, %rax
	js	.L216
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L217
.L216:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L217:
	movsd	-48(%rbp), %xmm1
	divsd	%xmm0, %xmm1
	movsd	%xmm1, -48(%rbp)
	movq	-56(%rbp), %rax
	testq	%rax, %rax
	js	.L218
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L219
.L218:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L219:
	movsd	.LC0(%rip), %xmm1
	divsd	%xmm1, %xmm0
	movsd	%xmm0, -40(%rbp)
	movq	ftiming(%rip), %rax
	testq	%rax, %rax
	jne	.L220
	movq	stderr(%rip), %rax
	movq	%rax, ftiming(%rip)
.L220:
	cmpl	$0, -68(%rbp)
	je	.L221
	movsd	-40(%rbp), %xmm0
	movapd	%xmm0, %xmm1
	divsd	-48(%rbp), %xmm1
	movq	ftiming(%rip), %rax
	movsd	-48(%rbp), %xmm0
	movq	-40(%rbp), %rdx
	movapd	%xmm1, %xmm2
	movapd	%xmm0, %xmm1
	movq	%rdx, %xmm0
	leaq	.LC13(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	movl	$3, %eax
	call	fprintf@PLT
	jmp	.L233
.L221:
	movsd	.LC12(%rip), %xmm0
	comisd	-40(%rbp), %xmm0
	jbe	.L231
	movq	ftiming(%rip), %rax
	movq	-40(%rbp), %rdx
	movq	%rdx, %xmm0
	leaq	.LC14(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	movl	$1, %eax
	call	fprintf@PLT
	jmp	.L225
.L231:
	movq	ftiming(%rip), %rax
	movq	-40(%rbp), %rdx
	movq	%rdx, %xmm0
	leaq	.LC15(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	movl	$1, %eax
	call	fprintf@PLT
.L225:
	movsd	-40(%rbp), %xmm0
	movapd	%xmm0, %xmm1
	divsd	-48(%rbp), %xmm1
	movsd	.LC12(%rip), %xmm0
	comisd	%xmm1, %xmm0
	jbe	.L232
	movsd	-40(%rbp), %xmm0
	divsd	-48(%rbp), %xmm0
	movq	%xmm0, %rdx
	movq	ftiming(%rip), %rax
	movq	%rdx, %xmm0
	leaq	.LC16(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	movl	$1, %eax
	call	fprintf@PLT
	jmp	.L233
.L232:
	movsd	-40(%rbp), %xmm0
	divsd	-48(%rbp), %xmm0
	movq	%xmm0, %rdx
	movq	ftiming(%rip), %rax
	movq	%rdx, %xmm0
	leaq	.LC17(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	movl	$1, %eax
	call	fprintf@PLT
.L233:
	nop
	movq	-8(%rbp), %rax
	subq	%fs:40, %rax
	je	.L228
	call	__stack_chk_fail@PLT
.L228:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE32:
	.size	bandwidth, .-bandwidth
	.section	.rodata
.LC19:
	.string	"%.0f KB/sec\n"
	.text
	.globl	kb
	.type	kb, @function
kb:
.LFB33:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$64, %rsp
	movq	%rdi, -56(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	leaq	-32(%rbp), %rax
	leaq	start_tv(%rip), %rdx
	leaq	stop_tv(%rip), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	tvsub
	movq	-32(%rbp), %rax
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rax, %xmm1
	movq	-24(%rbp), %rax
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	movsd	.LC0(%rip), %xmm2
	divsd	%xmm2, %xmm0
	addsd	%xmm1, %xmm0
	movsd	%xmm0, -48(%rbp)
	movq	-56(%rbp), %rax
	testq	%rax, %rax
	js	.L235
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L236
.L235:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L236:
	pxor	%xmm1, %xmm1
	ucomisd	-48(%rbp), %xmm1
	jp	.L245
	pxor	%xmm1, %xmm1
	ucomisd	-48(%rbp), %xmm1
	je	.L237
.L245:
	movsd	-48(%rbp), %xmm1
	jmp	.L239
.L237:
	movsd	.LC12(%rip), %xmm1
.L239:
	divsd	%xmm1, %xmm0
	movsd	%xmm0, -40(%rbp)
	pxor	%xmm0, %xmm0
	ucomisd	-48(%rbp), %xmm0
	jp	.L240
	pxor	%xmm0, %xmm0
	ucomisd	-48(%rbp), %xmm0
	je	.L246
.L240:
	movq	ftiming(%rip), %rax
	testq	%rax, %rax
	jne	.L243
	movq	stderr(%rip), %rax
	movq	%rax, ftiming(%rip)
.L243:
	movsd	-40(%rbp), %xmm0
	movsd	.LC18(%rip), %xmm1
	divsd	%xmm1, %xmm0
	movq	%xmm0, %rdx
	movq	ftiming(%rip), %rax
	movq	%rdx, %xmm0
	leaq	.LC19(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	movl	$1, %eax
	call	fprintf@PLT
	jmp	.L234
.L246:
	nop
.L234:
	movq	-8(%rbp), %rax
	subq	%fs:40, %rax
	je	.L244
	call	__stack_chk_fail@PLT
.L244:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE33:
	.size	kb, .-kb
	.section	.rodata
.LC20:
	.string	"%.2f MB/sec\n"
	.text
	.globl	mb
	.type	mb, @function
mb:
.LFB34:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$64, %rsp
	movq	%rdi, -56(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	leaq	-32(%rbp), %rax
	leaq	start_tv(%rip), %rdx
	leaq	stop_tv(%rip), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	tvsub
	movq	-32(%rbp), %rax
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rax, %xmm1
	movq	-24(%rbp), %rax
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	movsd	.LC0(%rip), %xmm2
	divsd	%xmm2, %xmm0
	addsd	%xmm1, %xmm0
	movsd	%xmm0, -48(%rbp)
	movq	-56(%rbp), %rax
	testq	%rax, %rax
	js	.L248
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L249
.L248:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L249:
	pxor	%xmm1, %xmm1
	ucomisd	-48(%rbp), %xmm1
	jp	.L258
	pxor	%xmm1, %xmm1
	ucomisd	-48(%rbp), %xmm1
	je	.L250
.L258:
	movsd	-48(%rbp), %xmm1
	jmp	.L252
.L250:
	movsd	.LC12(%rip), %xmm1
.L252:
	divsd	%xmm1, %xmm0
	movsd	%xmm0, -40(%rbp)
	pxor	%xmm0, %xmm0
	ucomisd	-48(%rbp), %xmm0
	jp	.L253
	pxor	%xmm0, %xmm0
	ucomisd	-48(%rbp), %xmm0
	je	.L259
.L253:
	movq	ftiming(%rip), %rax
	testq	%rax, %rax
	jne	.L256
	movq	stderr(%rip), %rax
	movq	%rax, ftiming(%rip)
.L256:
	movsd	-40(%rbp), %xmm0
	movsd	.LC0(%rip), %xmm1
	divsd	%xmm1, %xmm0
	movq	%xmm0, %rdx
	movq	ftiming(%rip), %rax
	movq	%rdx, %xmm0
	leaq	.LC20(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	movl	$1, %eax
	call	fprintf@PLT
	jmp	.L247
.L259:
	nop
.L247:
	movq	-8(%rbp), %rax
	subq	%fs:40, %rax
	je	.L257
	call	__stack_chk_fail@PLT
.L257:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE34:
	.size	mb, .-mb
	.section	.rodata
.LC21:
	.string	"%d %dKB xfers in %.2f secs, "
.LC22:
	.string	"%.1fKB in "
.LC23:
	.string	"/xfer"
.LC24:
	.string	"s"
.LC25:
	.string	"%.0f millisec%s, "
.LC26:
	.string	"%.4f millisec%s, "
.LC27:
	.string	"%.2f KB/sec\n"
	.text
	.globl	latency
	.type	latency, @function
latency:
.LFB35:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$64, %rsp
	movq	%rdi, -56(%rbp)
	movq	%rsi, -64(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movq	ftiming(%rip), %rax
	testq	%rax, %rax
	jne	.L261
	movq	stderr(%rip), %rax
	movq	%rax, ftiming(%rip)
.L261:
	leaq	-32(%rbp), %rax
	leaq	start_tv(%rip), %rdx
	leaq	stop_tv(%rip), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	tvsub
	movq	-32(%rbp), %rax
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rax, %xmm1
	movq	-24(%rbp), %rax
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	movsd	.LC0(%rip), %xmm2
	divsd	%xmm2, %xmm0
	addsd	%xmm1, %xmm0
	movsd	%xmm0, -40(%rbp)
	pxor	%xmm0, %xmm0
	ucomisd	-40(%rbp), %xmm0
	jp	.L262
	pxor	%xmm0, %xmm0
	ucomisd	-40(%rbp), %xmm0
	je	.L298
.L262:
	cmpq	$1, -56(%rbp)
	jbe	.L265
	movq	-64(%rbp), %rax
	testq	%rax, %rax
	js	.L266
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L267
.L266:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L267:
	movsd	.LC18(%rip), %xmm1
	divsd	%xmm1, %xmm0
	cvttsd2sil	%xmm0, %edx
	movq	-56(%rbp), %rax
	movl	%eax, %esi
	movq	ftiming(%rip), %rax
	movq	-40(%rbp), %rcx
	movq	%rcx, %xmm0
	movl	%edx, %ecx
	movl	%esi, %edx
	leaq	.LC21(%rip), %rsi
	movq	%rax, %rdi
	movl	$1, %eax
	call	fprintf@PLT
	jmp	.L268
.L265:
	movq	-64(%rbp), %rax
	testq	%rax, %rax
	js	.L269
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L270
.L269:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L270:
	movsd	.LC18(%rip), %xmm1
	divsd	%xmm1, %xmm0
	movq	%xmm0, %rdx
	movq	ftiming(%rip), %rax
	movq	%rdx, %xmm0
	leaq	.LC22(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	movl	$1, %eax
	call	fprintf@PLT
.L268:
	movsd	-40(%rbp), %xmm1
	movsd	.LC18(%rip), %xmm0
	mulsd	%xmm0, %xmm1
	movq	-56(%rbp), %rax
	testq	%rax, %rax
	js	.L271
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L272
.L271:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L272:
	divsd	%xmm0, %xmm1
	comisd	.LC1(%rip), %xmm1
	jbe	.L296
	cmpq	$1, -56(%rbp)
	jbe	.L275
	leaq	.LC23(%rip), %rcx
	jmp	.L276
.L275:
	leaq	.LC24(%rip), %rcx
.L276:
	movsd	-40(%rbp), %xmm1
	movsd	.LC18(%rip), %xmm0
	mulsd	%xmm0, %xmm1
	movq	-56(%rbp), %rax
	testq	%rax, %rax
	js	.L277
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L278
.L277:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L278:
	divsd	%xmm0, %xmm1
	movq	%xmm1, %rsi
	movq	ftiming(%rip), %rax
	movq	%rcx, %rdx
	movq	%rsi, %xmm0
	leaq	.LC25(%rip), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	movl	$1, %eax
	call	fprintf@PLT
	jmp	.L279
.L296:
	cmpq	$1, -56(%rbp)
	jbe	.L280
	leaq	.LC23(%rip), %rcx
	jmp	.L281
.L280:
	leaq	.LC24(%rip), %rcx
.L281:
	movsd	-40(%rbp), %xmm1
	movsd	.LC18(%rip), %xmm0
	mulsd	%xmm0, %xmm1
	movq	-56(%rbp), %rax
	testq	%rax, %rax
	js	.L282
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L283
.L282:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L283:
	divsd	%xmm0, %xmm1
	movq	%xmm1, %rsi
	movq	ftiming(%rip), %rax
	movq	%rcx, %rdx
	movq	%rsi, %xmm0
	leaq	.LC26(%rip), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	movl	$1, %eax
	call	fprintf@PLT
.L279:
	movq	-56(%rbp), %rax
	imulq	-64(%rbp), %rax
	testq	%rax, %rax
	js	.L284
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L285
.L284:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L285:
	movsd	-40(%rbp), %xmm2
	movsd	.LC0(%rip), %xmm1
	mulsd	%xmm2, %xmm1
	divsd	%xmm1, %xmm0
	movsd	.LC12(%rip), %xmm1
	comisd	%xmm1, %xmm0
	jbe	.L297
	movq	-56(%rbp), %rax
	imulq	-64(%rbp), %rax
	testq	%rax, %rax
	js	.L288
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L289
.L288:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L289:
	movsd	-40(%rbp), %xmm2
	movsd	.LC0(%rip), %xmm1
	mulsd	%xmm2, %xmm1
	divsd	%xmm1, %xmm0
	movq	%xmm0, %rdx
	movq	ftiming(%rip), %rax
	movq	%rdx, %xmm0
	leaq	.LC20(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	movl	$1, %eax
	call	fprintf@PLT
	jmp	.L260
.L297:
	movq	-56(%rbp), %rax
	imulq	-64(%rbp), %rax
	testq	%rax, %rax
	js	.L291
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L292
.L291:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L292:
	movsd	-40(%rbp), %xmm2
	movsd	.LC18(%rip), %xmm1
	mulsd	%xmm2, %xmm1
	divsd	%xmm1, %xmm0
	movq	%xmm0, %rdx
	movq	ftiming(%rip), %rax
	movq	%rdx, %xmm0
	leaq	.LC27(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	movl	$1, %eax
	call	fprintf@PLT
	jmp	.L260
.L298:
	nop
.L260:
	movq	-8(%rbp), %rax
	subq	%fs:40, %rax
	je	.L293
	call	__stack_chk_fail@PLT
.L293:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE35:
	.size	latency, .-latency
	.section	.rodata
	.align 8
.LC28:
	.string	"%d context switches in %.2f secs, %.0f microsec/switch\n"
	.text
	.globl	context
	.type	context, @function
context:
.LFB36:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$64, %rsp
	movq	%rdi, -56(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	leaq	-32(%rbp), %rax
	leaq	start_tv(%rip), %rdx
	leaq	stop_tv(%rip), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	tvsub
	movq	-32(%rbp), %rax
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rax, %xmm1
	movq	-24(%rbp), %rax
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	movsd	.LC0(%rip), %xmm2
	divsd	%xmm2, %xmm0
	addsd	%xmm1, %xmm0
	movsd	%xmm0, -40(%rbp)
	pxor	%xmm0, %xmm0
	ucomisd	-40(%rbp), %xmm0
	jp	.L300
	pxor	%xmm0, %xmm0
	ucomisd	-40(%rbp), %xmm0
	je	.L307
.L300:
	movq	ftiming(%rip), %rax
	testq	%rax, %rax
	jne	.L303
	movq	stderr(%rip), %rax
	movq	%rax, ftiming(%rip)
.L303:
	movsd	-40(%rbp), %xmm1
	movsd	.LC0(%rip), %xmm0
	mulsd	%xmm0, %xmm1
	movq	-56(%rbp), %rax
	testq	%rax, %rax
	js	.L304
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L305
.L304:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L305:
	divsd	%xmm0, %xmm1
	movq	-56(%rbp), %rax
	movl	%eax, %ecx
	movq	ftiming(%rip), %rax
	movq	-40(%rbp), %rdx
	movq	%rdx, %xmm0
	movl	%ecx, %edx
	leaq	.LC28(%rip), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	movl	$2, %eax
	call	fprintf@PLT
	jmp	.L299
.L307:
	nop
.L299:
	movq	-8(%rbp), %rax
	subq	%fs:40, %rax
	je	.L306
	call	__stack_chk_fail@PLT
.L306:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE36:
	.size	context, .-context
	.section	.rodata
.LC29:
	.string	"%s: %.2f nanoseconds\n"
	.text
	.globl	nano
	.type	nano, @function
nano:
.LFB37:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$64, %rsp
	movq	%rdi, -56(%rbp)
	movq	%rsi, -64(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	leaq	-32(%rbp), %rax
	leaq	start_tv(%rip), %rdx
	leaq	stop_tv(%rip), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	tvsub
	movq	-32(%rbp), %rax
	imulq	$1000000, %rax, %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	movsd	%xmm0, -40(%rbp)
	movsd	-40(%rbp), %xmm1
	movsd	.LC18(%rip), %xmm0
	mulsd	%xmm1, %xmm0
	movsd	%xmm0, -40(%rbp)
	pxor	%xmm0, %xmm0
	ucomisd	-40(%rbp), %xmm0
	jp	.L309
	pxor	%xmm0, %xmm0
	ucomisd	-40(%rbp), %xmm0
	je	.L316
.L309:
	movq	ftiming(%rip), %rax
	testq	%rax, %rax
	jne	.L312
	movq	stderr(%rip), %rax
	movq	%rax, ftiming(%rip)
.L312:
	movq	-64(%rbp), %rax
	testq	%rax, %rax
	js	.L313
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L314
.L313:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L314:
	movsd	-40(%rbp), %xmm1
	divsd	%xmm0, %xmm1
	movq	%xmm1, %rcx
	movq	ftiming(%rip), %rax
	movq	-56(%rbp), %rdx
	movq	%rcx, %xmm0
	leaq	.LC29(%rip), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	movl	$1, %eax
	call	fprintf@PLT
	jmp	.L308
.L316:
	nop
.L308:
	movq	-8(%rbp), %rax
	subq	%fs:40, %rax
	je	.L315
	call	__stack_chk_fail@PLT
.L315:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE37:
	.size	nano, .-nano
	.section	.rodata
.LC30:
	.string	"%s: %.4f microseconds\n"
	.text
	.globl	micro
	.type	micro, @function
micro:
.LFB38:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$64, %rsp
	movq	%rdi, -56(%rbp)
	movq	%rsi, -64(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	leaq	-32(%rbp), %rax
	leaq	start_tv(%rip), %rdx
	leaq	stop_tv(%rip), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	tvsub
	movq	-32(%rbp), %rax
	imulq	$1000000, %rax, %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	movsd	%xmm0, -40(%rbp)
	movq	-64(%rbp), %rax
	testq	%rax, %rax
	js	.L318
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L319
.L318:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L319:
	movsd	-40(%rbp), %xmm1
	divsd	%xmm0, %xmm1
	movsd	%xmm1, -40(%rbp)
	pxor	%xmm0, %xmm0
	ucomisd	-40(%rbp), %xmm0
	jp	.L320
	pxor	%xmm0, %xmm0
	ucomisd	-40(%rbp), %xmm0
	je	.L325
.L320:
	movq	ftiming(%rip), %rax
	testq	%rax, %rax
	jne	.L323
	movq	stderr(%rip), %rax
	movq	%rax, ftiming(%rip)
.L323:
	movq	ftiming(%rip), %rax
	movq	-40(%rbp), %rcx
	movq	-56(%rbp), %rdx
	movq	%rcx, %xmm0
	leaq	.LC30(%rip), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	movl	$1, %eax
	call	fprintf@PLT
	jmp	.L317
.L325:
	nop
.L317:
	movq	-8(%rbp), %rax
	subq	%fs:40, %rax
	je	.L324
	call	__stack_chk_fail@PLT
.L324:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE38:
	.size	micro, .-micro
	.section	.rodata
.LC32:
	.string	"%.6f %.0f\n"
.LC33:
	.string	"%.6f %.3f\n"
	.text
	.globl	micromb
	.type	micromb, @function
micromb:
.LFB39:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$64, %rsp
	movq	%rdi, -56(%rbp)
	movq	%rsi, -64(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	leaq	-32(%rbp), %rax
	leaq	start_tv(%rip), %rdx
	leaq	stop_tv(%rip), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	tvsub
	movq	-32(%rbp), %rax
	imulq	$1000000, %rax, %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	movsd	%xmm0, -48(%rbp)
	movq	-64(%rbp), %rax
	testq	%rax, %rax
	js	.L327
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L328
.L327:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L328:
	movsd	-48(%rbp), %xmm1
	divsd	%xmm0, %xmm1
	movsd	%xmm1, -48(%rbp)
	movq	-56(%rbp), %rax
	testq	%rax, %rax
	js	.L329
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L330
.L329:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L330:
	movsd	%xmm0, -40(%rbp)
	movsd	-40(%rbp), %xmm0
	movsd	.LC0(%rip), %xmm1
	divsd	%xmm1, %xmm0
	movsd	%xmm0, -40(%rbp)
	pxor	%xmm0, %xmm0
	ucomisd	-48(%rbp), %xmm0
	jp	.L331
	pxor	%xmm0, %xmm0
	ucomisd	-48(%rbp), %xmm0
	je	.L341
.L331:
	movq	ftiming(%rip), %rax
	testq	%rax, %rax
	jne	.L334
	movq	stderr(%rip), %rax
	movq	%rax, ftiming(%rip)
.L334:
	movsd	-48(%rbp), %xmm0
	comisd	.LC31(%rip), %xmm0
	jb	.L340
	movq	ftiming(%rip), %rax
	movsd	-48(%rbp), %xmm0
	movq	-40(%rbp), %rdx
	movapd	%xmm0, %xmm1
	movq	%rdx, %xmm0
	leaq	.LC32(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	movl	$2, %eax
	call	fprintf@PLT
	jmp	.L326
.L340:
	movq	ftiming(%rip), %rax
	movsd	-48(%rbp), %xmm0
	movq	-40(%rbp), %rdx
	movapd	%xmm0, %xmm1
	movq	%rdx, %xmm0
	leaq	.LC33(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	movl	$2, %eax
	call	fprintf@PLT
	jmp	.L326
.L341:
	nop
.L326:
	movq	-8(%rbp), %rax
	subq	%fs:40, %rax
	je	.L338
	call	__stack_chk_fail@PLT
.L338:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE39:
	.size	micromb, .-micromb
	.section	.rodata
.LC34:
	.string	"%s: %d milliseconds\n"
	.text
	.globl	milli
	.type	milli, @function
milli:
.LFB40:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$64, %rsp
	movq	%rdi, -56(%rbp)
	movq	%rsi, -64(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	leaq	-32(%rbp), %rax
	leaq	start_tv(%rip), %rdx
	leaq	stop_tv(%rip), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	tvsub
	movq	-32(%rbp), %rax
	imulq	$1000, %rax, %rsi
	movq	-24(%rbp), %rcx
	movabsq	$2361183241434822607, %rdx
	movq	%rcx, %rax
	imulq	%rdx
	movq	%rdx, %rax
	sarq	$7, %rax
	sarq	$63, %rcx
	movq	%rcx, %rdx
	subq	%rdx, %rax
	addq	%rsi, %rax
	movq	%rax, -40(%rbp)
	movq	-40(%rbp), %rax
	movl	$0, %edx
	divq	-64(%rbp)
	movq	%rax, -40(%rbp)
	movq	-40(%rbp), %rax
	testq	%rax, %rax
	js	.L343
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L344
.L343:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L344:
	pxor	%xmm1, %xmm1
	ucomisd	%xmm1, %xmm0
	jp	.L345
	pxor	%xmm1, %xmm1
	ucomisd	%xmm1, %xmm0
	je	.L350
.L345:
	movq	ftiming(%rip), %rax
	testq	%rax, %rax
	jne	.L348
	movq	stderr(%rip), %rax
	movq	%rax, ftiming(%rip)
.L348:
	movq	-40(%rbp), %rax
	movl	%eax, %ecx
	movq	ftiming(%rip), %rax
	movq	-56(%rbp), %rdx
	leaq	.LC34(%rip), %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf@PLT
	jmp	.L342
.L350:
	nop
.L342:
	movq	-8(%rbp), %rax
	subq	%fs:40, %rax
	je	.L349
	call	__stack_chk_fail@PLT
.L349:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE40:
	.size	milli, .-milli
	.section	.rodata
	.align 8
.LC35:
	.string	"%d in %.2f secs, %.0f microseconds each\n"
	.text
	.globl	ptime
	.type	ptime, @function
ptime:
.LFB41:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$64, %rsp
	movq	%rdi, -56(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	leaq	-32(%rbp), %rax
	leaq	start_tv(%rip), %rdx
	leaq	stop_tv(%rip), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	tvsub
	movq	-32(%rbp), %rax
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rax, %xmm1
	movq	-24(%rbp), %rax
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	movsd	.LC0(%rip), %xmm2
	divsd	%xmm2, %xmm0
	addsd	%xmm1, %xmm0
	movsd	%xmm0, -40(%rbp)
	pxor	%xmm0, %xmm0
	ucomisd	-40(%rbp), %xmm0
	jp	.L352
	pxor	%xmm0, %xmm0
	ucomisd	-40(%rbp), %xmm0
	je	.L359
.L352:
	movq	ftiming(%rip), %rax
	testq	%rax, %rax
	jne	.L355
	movq	stderr(%rip), %rax
	movq	%rax, ftiming(%rip)
.L355:
	movsd	-40(%rbp), %xmm1
	movsd	.LC0(%rip), %xmm0
	mulsd	%xmm0, %xmm1
	movq	-56(%rbp), %rax
	testq	%rax, %rax
	js	.L356
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L357
.L356:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L357:
	divsd	%xmm0, %xmm1
	movq	-56(%rbp), %rax
	movl	%eax, %ecx
	movq	ftiming(%rip), %rax
	movq	-40(%rbp), %rdx
	movq	%rdx, %xmm0
	movl	%ecx, %edx
	leaq	.LC35(%rip), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	movl	$2, %eax
	call	fprintf@PLT
	jmp	.L351
.L359:
	nop
.L351:
	movq	-8(%rbp), %rax
	subq	%fs:40, %rax
	je	.L358
	call	__stack_chk_fail@PLT
.L358:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE41:
	.size	ptime, .-ptime
	.globl	tvdelta
	.type	tvdelta, @function
tvdelta:
.LFB42:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$64, %rsp
	movq	%rdi, -56(%rbp)
	movq	%rsi, -64(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movq	-56(%rbp), %rdx
	movq	-64(%rbp), %rcx
	leaq	-32(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	tvsub
	movq	-32(%rbp), %rax
	movq	%rax, -40(%rbp)
	movq	-40(%rbp), %rax
	imulq	$1000000, %rax, %rax
	movq	%rax, -40(%rbp)
	movq	-24(%rbp), %rax
	addq	%rax, -40(%rbp)
	movq	-40(%rbp), %rax
	movq	-8(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L362
	call	__stack_chk_fail@PLT
.L362:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE42:
	.size	tvdelta, .-tvdelta
	.section	.rodata
.LC36:
	.string	"lib_timing.c"
.LC37:
	.string	"tdiff->tv_usec >= 0"
	.text
	.globl	tvsub
	.type	tvsub, @function
tvsub:
.LFB43:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	%rdx, -24(%rbp)
	movq	-16(%rbp), %rax
	movq	(%rax), %rdx
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	subq	%rax, %rdx
	movq	-8(%rbp), %rax
	movq	%rdx, (%rax)
	movq	-16(%rbp), %rax
	movq	8(%rax), %rdx
	movq	-24(%rbp), %rax
	movq	8(%rax), %rax
	subq	%rax, %rdx
	movq	-8(%rbp), %rax
	movq	%rdx, 8(%rax)
	movq	-8(%rbp), %rax
	movq	8(%rax), %rax
	testq	%rax, %rax
	jns	.L364
	movq	-8(%rbp), %rax
	movq	(%rax), %rax
	testq	%rax, %rax
	jle	.L364
	movq	-8(%rbp), %rax
	movq	(%rax), %rax
	leaq	-1(%rax), %rdx
	movq	-8(%rbp), %rax
	movq	%rdx, (%rax)
	movq	-8(%rbp), %rax
	movq	8(%rax), %rax
	leaq	1000000(%rax), %rdx
	movq	-8(%rbp), %rax
	movq	%rdx, 8(%rax)
	movq	-8(%rbp), %rax
	movq	8(%rax), %rax
	testq	%rax, %rax
	jns	.L364
	leaq	__PRETTY_FUNCTION__.12(%rip), %rax
	movq	%rax, %rcx
	movl	$1099, %edx
	leaq	.LC36(%rip), %rax
	movq	%rax, %rsi
	leaq	.LC37(%rip), %rax
	movq	%rax, %rdi
	call	__assert_fail@PLT
.L364:
	movq	-8(%rbp), %rax
	movq	8(%rax), %rax
	testq	%rax, %rax
	js	.L365
	movq	-16(%rbp), %rax
	movq	(%rax), %rdx
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	cmpq	%rax, %rdx
	jge	.L367
.L365:
	movq	-8(%rbp), %rax
	movq	$0, (%rax)
	movq	-8(%rbp), %rax
	movq	$0, 8(%rax)
.L367:
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE43:
	.size	tvsub, .-tvsub
	.globl	usecs_spent
	.type	usecs_spent, @function
usecs_spent:
.LFB44:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	leaq	stop_tv(%rip), %rax
	movq	%rax, %rsi
	leaq	start_tv(%rip), %rax
	movq	%rax, %rdi
	call	tvdelta
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE44:
	.size	usecs_spent, .-usecs_spent
	.globl	timespent
	.type	timespent, @function
timespent:
.LFB45:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	leaq	-32(%rbp), %rax
	leaq	start_tv(%rip), %rdx
	leaq	stop_tv(%rip), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	tvsub
	movq	-32(%rbp), %rax
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rax, %xmm1
	movq	-24(%rbp), %rax
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	movsd	.LC0(%rip), %xmm2
	divsd	%xmm2, %xmm0
	addsd	%xmm1, %xmm0
	movq	%xmm0, %rax
	movq	-8(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L372
	call	__stack_chk_fail@PLT
.L372:
	movq	%rax, %xmm0
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE45:
	.size	timespent, .-timespent
	.local	p64buf
	.comm	p64buf,200,32
	.local	n
	.comm	n,4,4
	.section	.rodata
.LC38:
	.string	"0x%x%08x"
.LC39:
	.string	"0x%x"
	.text
	.globl	p64
	.type	p64, @function
p64:
.LFB46:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%rdi, -24(%rbp)
	movl	n(%rip), %eax
	leal	1(%rax), %edx
	movl	%edx, n(%rip)
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$2, %rax
	addq	%rdx, %rax
	salq	$2, %rax
	leaq	p64buf(%rip), %rdx
	addq	%rdx, %rax
	movq	%rax, -16(%rbp)
	movl	n(%rip), %eax
	cmpl	$10, %eax
	jne	.L374
	movl	$0, n(%rip)
.L374:
	leaq	-24(%rbp), %rax
	movq	%rax, -8(%rbp)
	movq	-8(%rbp), %rax
	addq	$4, %rax
	movl	(%rax), %eax
	testl	%eax, %eax
	je	.L375
	movq	-8(%rbp), %rax
	movl	(%rax), %ecx
	movq	-8(%rbp), %rax
	addq	$4, %rax
	movl	(%rax), %edx
	movq	-16(%rbp), %rax
	leaq	.LC38(%rip), %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	sprintf@PLT
	jmp	.L376
.L375:
	movq	-8(%rbp), %rax
	movl	(%rax), %edx
	movq	-16(%rbp), %rax
	leaq	.LC39(%rip), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	sprintf@PLT
.L376:
	movq	-16(%rbp), %rax
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE46:
	.size	p64, .-p64
	.section	.rodata
.LC40:
	.string	" KMGTPE"
.LC43:
	.string	"0"
.LC44:
	.string	"%.4f%c"
.LC45:
	.string	"%.2f%c"
	.text
	.globl	p64sz
	.type	p64sz, @function
p64sz:
.LFB47:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$48, %rsp
	movq	%rdi, -40(%rbp)
	movq	-40(%rbp), %rax
	testq	%rax, %rax
	js	.L379
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L380
.L379:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L380:
	movsd	%xmm0, -24(%rbp)
	leaq	.LC40(%rip), %rax
	movq	%rax, -16(%rbp)
	movl	$0, -28(%rbp)
	movl	n(%rip), %eax
	leal	1(%rax), %edx
	movl	%edx, n(%rip)
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$2, %rax
	addq	%rdx, %rax
	salq	$2, %rax
	leaq	p64buf(%rip), %rdx
	addq	%rdx, %rax
	movq	%rax, -8(%rbp)
	movl	n(%rip), %eax
	cmpl	$10, %eax
	jne	.L382
	movl	$0, n(%rip)
	jmp	.L382
.L383:
	addl	$1, -28(%rbp)
	movsd	-24(%rbp), %xmm0
	movsd	.LC41(%rip), %xmm1
	divsd	%xmm1, %xmm0
	movsd	%xmm0, -24(%rbp)
.L382:
	movsd	-24(%rbp), %xmm0
	comisd	.LC42(%rip), %xmm0
	ja	.L383
	pxor	%xmm0, %xmm0
	ucomisd	-24(%rbp), %xmm0
	jp	.L384
	pxor	%xmm0, %xmm0
	ucomisd	-24(%rbp), %xmm0
	jne	.L384
	leaq	.LC43(%rip), %rax
	jmp	.L386
.L384:
	movsd	.LC1(%rip), %xmm0
	comisd	-24(%rbp), %xmm0
	jbe	.L392
	movl	-28(%rbp), %eax
	movslq	%eax, %rdx
	movq	-16(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	movsbl	%al, %edx
	movq	-24(%rbp), %rcx
	movq	-8(%rbp), %rax
	movq	%rcx, %xmm0
	leaq	.LC44(%rip), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	movl	$1, %eax
	call	sprintf@PLT
	jmp	.L389
.L392:
	movl	-28(%rbp), %eax
	movslq	%eax, %rdx
	movq	-16(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	movsbl	%al, %edx
	movq	-24(%rbp), %rcx
	movq	-8(%rbp), %rax
	movq	%rcx, %xmm0
	leaq	.LC45(%rip), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	movl	$1, %eax
	call	sprintf@PLT
.L389:
	movq	-8(%rbp), %rax
.L386:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE47:
	.size	p64sz, .-p64sz
	.globl	last
	.type	last, @function
last:
.LFB48:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -8(%rbp)
	nop
.L394:
	movq	-8(%rbp), %rax
	leaq	1(%rax), %rdx
	movq	%rdx, -8(%rbp)
	movzbl	(%rax), %eax
	testb	%al, %al
	jne	.L394
	movq	-8(%rbp), %rax
	movzbl	-2(%rax), %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE48:
	.size	last, .-last
	.section	.rodata
.LC46:
	.string	"%llu"
	.text
	.globl	bytes
	.type	bytes, @function
bytes:
.LFB49:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%rdi, -24(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	leaq	-16(%rbp), %rdx
	movq	-24(%rbp), %rax
	leaq	.LC46(%rip), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf@PLT
	testl	%eax, %eax
	jg	.L397
	movl	$0, %eax
	jmp	.L407
.L397:
	movq	-24(%rbp), %rax
	movq	%rax, %rdi
	call	last
	movsbl	%al, %eax
	subl	$71, %eax
	cmpl	$38, %eax
	ja	.L399
	movl	%eax, %eax
	leaq	0(,%rax,4), %rdx
	leaq	.L401(%rip), %rax
	movl	(%rdx,%rax), %eax
	cltq
	leaq	.L401(%rip), %rdx
	addq	%rdx, %rax
	notrack jmp	*%rax
	.section	.rodata
	.align 4
	.align 4
.L401:
	.long	.L406-.L401
	.long	.L399-.L401
	.long	.L399-.L401
	.long	.L399-.L401
	.long	.L405-.L401
	.long	.L399-.L401
	.long	.L404-.L401
	.long	.L399-.L401
	.long	.L399-.L401
	.long	.L399-.L401
	.long	.L399-.L401
	.long	.L399-.L401
	.long	.L399-.L401
	.long	.L399-.L401
	.long	.L399-.L401
	.long	.L399-.L401
	.long	.L399-.L401
	.long	.L399-.L401
	.long	.L399-.L401
	.long	.L399-.L401
	.long	.L399-.L401
	.long	.L399-.L401
	.long	.L399-.L401
	.long	.L399-.L401
	.long	.L399-.L401
	.long	.L399-.L401
	.long	.L399-.L401
	.long	.L399-.L401
	.long	.L399-.L401
	.long	.L399-.L401
	.long	.L399-.L401
	.long	.L399-.L401
	.long	.L403-.L401
	.long	.L399-.L401
	.long	.L399-.L401
	.long	.L399-.L401
	.long	.L402-.L401
	.long	.L399-.L401
	.long	.L400-.L401
	.text
.L402:
	movq	-16(%rbp), %rax
	salq	$10, %rax
	movq	%rax, -16(%rbp)
	jmp	.L399
.L405:
	movq	-16(%rbp), %rax
	imulq	$1000, %rax, %rax
	movq	%rax, -16(%rbp)
	jmp	.L399
.L400:
	movq	-16(%rbp), %rax
	salq	$20, %rax
	movq	%rax, -16(%rbp)
	jmp	.L399
.L404:
	movq	-16(%rbp), %rax
	imulq	$1000000, %rax, %rax
	movq	%rax, -16(%rbp)
	jmp	.L399
.L403:
	movq	-16(%rbp), %rax
	salq	$30, %rax
	movq	%rax, -16(%rbp)
	jmp	.L399
.L406:
	movq	-16(%rbp), %rax
	imulq	$1000000000, %rax, %rax
	movq	%rax, -16(%rbp)
	nop
.L399:
	movq	-16(%rbp), %rax
.L407:
	movq	-8(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L408
	call	__stack_chk_fail@PLT
.L408:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE49:
	.size	bytes, .-bytes
	.globl	use_int
	.type	use_int, @function
use_int:
.LFB50:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%edi, -4(%rbp)
	movl	-4(%rbp), %eax
	movslq	%eax, %rdx
	movq	use_result_dummy(%rip), %rax
	addq	%rdx, %rax
	movq	%rax, use_result_dummy(%rip)
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE50:
	.size	use_int, .-use_int
	.globl	use_pointer
	.type	use_pointer, @function
use_pointer:
.LFB51:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -8(%rbp)
	movq	use_result_dummy(%rip), %rdx
	movq	-8(%rbp), %rax
	addq	%rdx, %rax
	movq	%rax, use_result_dummy(%rip)
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE51:
	.size	use_pointer, .-use_pointer
	.globl	sizeof_result
	.type	sizeof_result, @function
sizeof_result:
.LFB52:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%edi, -4(%rbp)
	cmpl	$11, -4(%rbp)
	jg	.L412
	movl	$184, %eax
	jmp	.L413
.L412:
	movl	-4(%rbp), %eax
	subl	$11, %eax
	cltq
	sall	$4, %eax
	addl	$184, %eax
.L413:
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE52:
	.size	sizeof_result, .-sizeof_result
	.globl	insertinit
	.type	insertinit, @function
insertinit:
.LFB53:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -8(%rbp)
	movq	-8(%rbp), %rax
	movl	$0, (%rax)
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE53:
	.size	insertinit, .-insertinit
	.globl	insertsort
	.type	insertsort, @function
insertsort:
.LFB54:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -24(%rbp)
	movq	%rsi, -32(%rbp)
	movq	%rdx, -40(%rbp)
	cmpq	$0, -24(%rbp)
	je	.L435
	movl	$0, -8(%rbp)
	jmp	.L418
.L432:
	movq	-24(%rbp), %rax
	testq	%rax, %rax
	js	.L419
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L420
.L419:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L420:
	movq	-32(%rbp), %rax
	testq	%rax, %rax
	js	.L421
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rax, %xmm1
	jmp	.L422
.L421:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rdx, %xmm1
	addsd	%xmm1, %xmm1
.L422:
	movapd	%xmm0, %xmm2
	divsd	%xmm1, %xmm2
	movq	-40(%rbp), %rdx
	movl	-8(%rbp), %eax
	cltq
	salq	$4, %rax
	addq	%rdx, %rax
	addq	$8, %rax
	movq	(%rax), %rax
	testq	%rax, %rax
	js	.L423
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L424
.L423:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L424:
	movq	-40(%rbp), %rdx
	movl	-8(%rbp), %eax
	cltq
	salq	$4, %rax
	addq	%rdx, %rax
	addq	$16, %rax
	movq	(%rax), %rax
	testq	%rax, %rax
	js	.L425
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rax, %xmm1
	jmp	.L426
.L425:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rdx, %xmm1
	addsd	%xmm1, %xmm1
.L426:
	divsd	%xmm1, %xmm0
	comisd	%xmm0, %xmm2
	jbe	.L434
	movq	-40(%rbp), %rax
	movl	(%rax), %eax
	movl	%eax, -4(%rbp)
	jmp	.L429
.L430:
	movl	-4(%rbp), %eax
	leal	-1(%rax), %edx
	movq	-40(%rbp), %rcx
	movl	-4(%rbp), %eax
	cltq
	salq	$4, %rax
	addq	%rax, %rcx
	movq	-40(%rbp), %rsi
	movslq	%edx, %rax
	salq	$4, %rax
	addq	%rsi, %rax
	movq	16(%rax), %rdx
	movq	8(%rax), %rax
	movq	%rax, 8(%rcx)
	movq	%rdx, 16(%rcx)
	subl	$1, -4(%rbp)
.L429:
	movl	-4(%rbp), %eax
	cmpl	-8(%rbp), %eax
	jg	.L430
	jmp	.L431
.L434:
	addl	$1, -8(%rbp)
.L418:
	movq	-40(%rbp), %rax
	movl	(%rax), %eax
	cmpl	%eax, -8(%rbp)
	jl	.L432
.L431:
	movq	-40(%rbp), %rdx
	movl	-8(%rbp), %eax
	cltq
	salq	$4, %rax
	addq	%rdx, %rax
	leaq	8(%rax), %rdx
	movq	-24(%rbp), %rax
	movq	%rax, (%rdx)
	movq	-40(%rbp), %rdx
	movl	-8(%rbp), %eax
	cltq
	salq	$4, %rax
	addq	%rdx, %rax
	leaq	16(%rax), %rdx
	movq	-32(%rbp), %rax
	movq	%rax, (%rdx)
	movq	-40(%rbp), %rax
	movl	(%rax), %eax
	leal	1(%rax), %edx
	movq	-40(%rbp), %rax
	movl	%edx, (%rax)
	jmp	.L415
.L435:
	nop
.L415:
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE54:
	.size	insertsort, .-insertsort
	.local	_results
	.comm	_results,184,32
	.section	.data.rel.local,"aw"
	.align 8
	.type	results, @object
	.size	results, 8
results:
	.quad	_results
	.text
	.globl	get_results
	.type	get_results, @function
get_results:
.LFB55:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	results(%rip), %rax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE55:
	.size	get_results, .-get_results
	.globl	set_results
	.type	set_results, @function
set_results:
.LFB56:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movq	-8(%rbp), %rax
	movq	%rax, results(%rip)
	movl	$0, %eax
	call	save_median
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE56:
	.size	set_results, .-set_results
	.globl	save_minimum
	.type	save_minimum, @function
save_minimum:
.LFB57:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	results(%rip), %rax
	movl	(%rax), %eax
	testl	%eax, %eax
	jne	.L440
	movl	$1, %edi
	call	save_n
	movl	$0, %edi
	call	settime
	jmp	.L442
.L440:
	movq	results(%rip), %rdx
	movq	results(%rip), %rax
	movl	(%rax), %eax
	subl	$1, %eax
	cltq
	salq	$4, %rax
	addq	%rdx, %rax
	addq	$16, %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	save_n
	movq	results(%rip), %rdx
	movq	results(%rip), %rax
	movl	(%rax), %eax
	subl	$1, %eax
	cltq
	salq	$4, %rax
	addq	%rdx, %rax
	addq	$8, %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	settime
.L442:
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE57:
	.size	save_minimum, .-save_minimum
	.globl	save_median
	.type	save_median, @function
save_median:
.LFB58:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	results(%rip), %rax
	movl	(%rax), %eax
	movl	%eax, %edx
	shrl	$31, %edx
	addl	%edx, %eax
	sarl	%eax
	movl	%eax, -20(%rbp)
	movq	results(%rip), %rax
	movl	(%rax), %eax
	testl	%eax, %eax
	jne	.L444
	movq	$1, -8(%rbp)
	movq	$0, -16(%rbp)
	jmp	.L445
.L444:
	movq	results(%rip), %rax
	movl	(%rax), %eax
	andl	$1, %eax
	testl	%eax, %eax
	je	.L446
	movq	results(%rip), %rdx
	movl	-20(%rbp), %eax
	cltq
	salq	$4, %rax
	addq	%rdx, %rax
	addq	$16, %rax
	movq	(%rax), %rax
	movq	%rax, -8(%rbp)
	movq	results(%rip), %rdx
	movl	-20(%rbp), %eax
	cltq
	salq	$4, %rax
	addq	%rdx, %rax
	addq	$8, %rax
	movq	(%rax), %rax
	movq	%rax, -16(%rbp)
	jmp	.L445
.L446:
	movq	results(%rip), %rdx
	movl	-20(%rbp), %eax
	cltq
	salq	$4, %rax
	addq	%rdx, %rax
	addq	$16, %rax
	movq	(%rax), %rdx
	movq	results(%rip), %rcx
	movl	-20(%rbp), %eax
	subl	$1, %eax
	cltq
	salq	$4, %rax
	addq	%rcx, %rax
	addq	$16, %rax
	movq	(%rax), %rax
	addq	%rdx, %rax
	shrq	%rax
	movq	%rax, -8(%rbp)
	movq	results(%rip), %rdx
	movl	-20(%rbp), %eax
	cltq
	salq	$4, %rax
	addq	%rdx, %rax
	addq	$8, %rax
	movq	(%rax), %rdx
	movq	results(%rip), %rcx
	movl	-20(%rbp), %eax
	subl	$1, %eax
	cltq
	salq	$4, %rax
	addq	%rcx, %rax
	addq	$8, %rax
	movq	(%rax), %rax
	addq	%rdx, %rax
	shrq	%rax
	movq	%rax, -16(%rbp)
.L445:
	movq	-8(%rbp), %rax
	movq	%rax, %rdi
	call	save_n
	movq	-16(%rbp), %rax
	movq	%rax, %rdi
	call	settime
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE58:
	.size	save_median, .-save_median
	.type	one_op, @function
one_op:
.LFB59:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%rbx
	subq	$40, %rsp
	.cfi_offset 3, -24
	movq	%rdi, %rbx
	movl	$0, %edi
	call	get_enough
	movl	%eax, -44(%rbp)
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -32(%rbp)
	jmp	.L448
.L463:
	movl	$0, %edi
	call	start
	movq	__iterations.11(%rip), %rax
	movq	%rax, -40(%rbp)
	jmp	.L449
.L450:
	movq	(%rbx), %rax
	movq	%rax, %rbx
	subq	$1, -40(%rbp)
.L449:
	cmpq	$0, -40(%rbp)
	jne	.L450
	movl	$0, %esi
	movl	$0, %edi
	call	stop
	testq	%rax, %rax
	js	.L451
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L452
.L451:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L452:
	movsd	%xmm0, -32(%rbp)
	pxor	%xmm1, %xmm1
	cvtsi2sdl	-44(%rbp), %xmm1
	movsd	.LC8(%rip), %xmm0
	mulsd	%xmm1, %xmm0
	comisd	-32(%rbp), %xmm0
	ja	.L453
	pxor	%xmm1, %xmm1
	cvtsi2sdl	-44(%rbp), %xmm1
	movsd	.LC9(%rip), %xmm0
	mulsd	%xmm0, %xmm1
	movsd	-32(%rbp), %xmm0
	comisd	%xmm1, %xmm0
	ja	.L453
	jmp	.L448
.L453:
	movsd	-32(%rbp), %xmm0
	comisd	.LC10(%rip), %xmm0
	jbe	.L468
	movq	__iterations.11(%rip), %rax
	testq	%rax, %rax
	js	.L457
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L458
.L457:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L458:
	divsd	-32(%rbp), %xmm0
	movsd	%xmm0, -24(%rbp)
	pxor	%xmm1, %xmm1
	cvtsi2sdl	-44(%rbp), %xmm1
	movsd	.LC11(%rip), %xmm0
	mulsd	%xmm1, %xmm0
	movsd	-24(%rbp), %xmm1
	mulsd	%xmm1, %xmm0
	movsd	%xmm0, -24(%rbp)
	movsd	-24(%rbp), %xmm1
	movsd	.LC12(%rip), %xmm0
	addsd	%xmm1, %xmm0
	comisd	.LC5(%rip), %xmm0
	jnb	.L459
	cvttsd2siq	%xmm0, %rax
	jmp	.L460
.L459:
	movsd	.LC5(%rip), %xmm1
	subsd	%xmm1, %xmm0
	cvttsd2siq	%xmm0, %rax
	movabsq	$-9223372036854775808, %rdx
	xorq	%rdx, %rax
.L460:
	movq	%rax, __iterations.11(%rip)
	jmp	.L448
.L468:
	movq	__iterations.11(%rip), %rax
	cmpq	$134217728, %rax
	jbe	.L461
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -32(%rbp)
	jmp	.L462
.L461:
	movq	__iterations.11(%rip), %rax
	salq	$3, %rax
	movq	%rax, __iterations.11(%rip)
.L448:
	pxor	%xmm1, %xmm1
	cvtsi2sdl	-44(%rbp), %xmm1
	movsd	.LC7(%rip), %xmm0
	mulsd	%xmm1, %xmm0
	comisd	-32(%rbp), %xmm0
	ja	.L463
.L462:
	movq	__iterations.11(%rip), %rax
	movq	%rax, %rdi
	call	save_n
	movsd	-32(%rbp), %xmm0
	comisd	.LC5(%rip), %xmm0
	jnb	.L464
	movsd	-32(%rbp), %xmm0
	cvttsd2siq	%xmm0, %rax
	jmp	.L465
.L464:
	movsd	-32(%rbp), %xmm0
	movsd	.LC5(%rip), %xmm1
	subsd	%xmm1, %xmm0
	cvttsd2siq	%xmm0, %rax
	movabsq	$-9223372036854775808, %rdx
	xorq	%rdx, %rax
.L465:
	movq	%rax, %rdi
	call	settime
	movq	%rbx, %rax
	movq	-8(%rbp), %rbx
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE59:
	.size	one_op, .-one_op
	.type	two_op, @function
two_op:
.LFB60:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%rbx
	subq	$40, %rsp
	.cfi_offset 3, -24
	movq	%rdi, %rbx
	movl	$0, %edi
	call	get_enough
	movl	%eax, -44(%rbp)
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -32(%rbp)
	jmp	.L470
.L485:
	movl	$0, %edi
	call	start
	movq	__iterations.10(%rip), %rax
	movq	%rax, -40(%rbp)
	jmp	.L471
.L472:
	movq	(%rbx), %rax
	movq	%rax, %rbx
	movq	(%rbx), %rax
	movq	%rax, %rbx
	subq	$1, -40(%rbp)
.L471:
	cmpq	$0, -40(%rbp)
	jne	.L472
	movl	$0, %esi
	movl	$0, %edi
	call	stop
	testq	%rax, %rax
	js	.L473
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L474
.L473:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L474:
	movsd	%xmm0, -32(%rbp)
	pxor	%xmm1, %xmm1
	cvtsi2sdl	-44(%rbp), %xmm1
	movsd	.LC8(%rip), %xmm0
	mulsd	%xmm1, %xmm0
	comisd	-32(%rbp), %xmm0
	ja	.L475
	pxor	%xmm1, %xmm1
	cvtsi2sdl	-44(%rbp), %xmm1
	movsd	.LC9(%rip), %xmm0
	mulsd	%xmm0, %xmm1
	movsd	-32(%rbp), %xmm0
	comisd	%xmm1, %xmm0
	ja	.L475
	jmp	.L470
.L475:
	movsd	-32(%rbp), %xmm0
	comisd	.LC10(%rip), %xmm0
	jbe	.L490
	movq	__iterations.10(%rip), %rax
	testq	%rax, %rax
	js	.L479
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L480
.L479:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L480:
	divsd	-32(%rbp), %xmm0
	movsd	%xmm0, -24(%rbp)
	pxor	%xmm1, %xmm1
	cvtsi2sdl	-44(%rbp), %xmm1
	movsd	.LC11(%rip), %xmm0
	mulsd	%xmm1, %xmm0
	movsd	-24(%rbp), %xmm1
	mulsd	%xmm1, %xmm0
	movsd	%xmm0, -24(%rbp)
	movsd	-24(%rbp), %xmm1
	movsd	.LC12(%rip), %xmm0
	addsd	%xmm1, %xmm0
	comisd	.LC5(%rip), %xmm0
	jnb	.L481
	cvttsd2siq	%xmm0, %rax
	jmp	.L482
.L481:
	movsd	.LC5(%rip), %xmm1
	subsd	%xmm1, %xmm0
	cvttsd2siq	%xmm0, %rax
	movabsq	$-9223372036854775808, %rdx
	xorq	%rdx, %rax
.L482:
	movq	%rax, __iterations.10(%rip)
	jmp	.L470
.L490:
	movq	__iterations.10(%rip), %rax
	cmpq	$134217728, %rax
	jbe	.L483
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -32(%rbp)
	jmp	.L484
.L483:
	movq	__iterations.10(%rip), %rax
	salq	$3, %rax
	movq	%rax, __iterations.10(%rip)
.L470:
	pxor	%xmm1, %xmm1
	cvtsi2sdl	-44(%rbp), %xmm1
	movsd	.LC7(%rip), %xmm0
	mulsd	%xmm1, %xmm0
	comisd	-32(%rbp), %xmm0
	ja	.L485
.L484:
	movq	__iterations.10(%rip), %rax
	movq	%rax, %rdi
	call	save_n
	movsd	-32(%rbp), %xmm0
	comisd	.LC5(%rip), %xmm0
	jnb	.L486
	movsd	-32(%rbp), %xmm0
	cvttsd2siq	%xmm0, %rax
	jmp	.L487
.L486:
	movsd	-32(%rbp), %xmm0
	movsd	.LC5(%rip), %xmm1
	subsd	%xmm1, %xmm0
	cvttsd2siq	%xmm0, %rax
	movabsq	$-9223372036854775808, %rdx
	xorq	%rdx, %rax
.L487:
	movq	%rax, %rdi
	call	settime
	movq	%rbx, %rax
	movq	-8(%rbp), %rbx
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE60:
	.size	two_op, .-two_op
	.section	.data.rel.local
	.align 8
	.type	p, @object
	.size	p, 8
p:
	.quad	p
	.align 8
	.type	q, @object
	.size	q, 8
q:
	.quad	q
	.section	.rodata
.LC47:
	.string	"LOOP_O"
	.text
	.globl	l_overhead
	.type	l_overhead, @function
l_overhead:
.LFB61:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r12
	pushq	%rbx
	subq	$432, %rsp
	.cfi_offset 12, -24
	.cfi_offset 3, -32
	movq	%fs:40, %rax
	movq	%rax, -24(%rbp)
	xorl	%eax, %eax
	call	init_timing
	movl	initialized.9(%rip), %eax
	testl	%eax, %eax
	je	.L492
	movsd	overhead.8(%rip), %xmm0
	jmp	.L510
.L492:
	movl	$1, initialized.9(%rip)
	leaq	.LC47(%rip), %rax
	movq	%rax, %rdi
	call	getenv@PLT
	testq	%rax, %rax
	je	.L494
	leaq	.LC47(%rip), %rax
	movq	%rax, %rdi
	call	getenv@PLT
	movq	%rax, %rdi
	call	atof@PLT
	movq	%xmm0, %rax
	movq	%rax, overhead.8(%rip)
	jmp	.L495
.L494:
	movl	$0, %eax
	call	get_results
	movq	%rax, -424(%rbp)
	call	get_n
	movq	%rax, -416(%rbp)
	call	usecs_spent
	movq	%rax, -408(%rbp)
	leaq	-400(%rbp), %rax
	movq	%rax, %rdi
	call	insertinit
	leaq	-208(%rbp), %rax
	movq	%rax, %rdi
	call	insertinit
	movl	$0, -428(%rbp)
	jmp	.L496
.L499:
	movq	p(%rip), %rax
	movq	%rax, %rdi
	call	one_op
	movq	%rax, %rdi
	call	use_pointer
	call	usecs_spent
	movq	%rax, %rbx
	call	t_overhead
	cmpq	%rax, %rbx
	jbe	.L497
	call	get_n
	movq	%rax, %r12
	call	usecs_spent
	movq	%rax, %rbx
	call	t_overhead
	movq	%rbx, %rcx
	subq	%rax, %rcx
	leaq	-400(%rbp), %rax
	movq	%rax, %rdx
	movq	%r12, %rsi
	movq	%rcx, %rdi
	call	insertsort
.L497:
	movq	p(%rip), %rax
	movq	%rax, %rdi
	call	two_op
	movq	%rax, %rdi
	call	use_pointer
	call	usecs_spent
	movq	%rax, %rbx
	call	t_overhead
	cmpq	%rax, %rbx
	jbe	.L498
	call	get_n
	movq	%rax, %r12
	call	usecs_spent
	movq	%rax, %rbx
	call	t_overhead
	movq	%rbx, %rcx
	subq	%rax, %rcx
	leaq	-208(%rbp), %rax
	movq	%rax, %rdx
	movq	%r12, %rsi
	movq	%rcx, %rdi
	call	insertsort
.L498:
	addl	$1, -428(%rbp)
.L496:
	cmpl	$10, -428(%rbp)
	jle	.L499
	leaq	-400(%rbp), %rax
	movq	%rax, %rdi
	call	set_results
	movl	$0, %eax
	call	save_minimum
	call	usecs_spent
	testq	%rax, %rax
	js	.L500
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L501
.L500:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L501:
	addsd	%xmm0, %xmm0
	movsd	%xmm0, -440(%rbp)
	call	get_n
	testq	%rax, %rax
	js	.L502
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L503
.L502:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L503:
	movsd	-440(%rbp), %xmm1
	divsd	%xmm0, %xmm1
	movsd	%xmm1, overhead.8(%rip)
	leaq	-208(%rbp), %rax
	movq	%rax, %rdi
	call	set_results
	movl	$0, %eax
	call	save_minimum
	call	usecs_spent
	testq	%rax, %rax
	js	.L504
	pxor	%xmm2, %xmm2
	cvtsi2sdq	%rax, %xmm2
	movsd	%xmm2, -440(%rbp)
	jmp	.L505
.L504:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
	movsd	%xmm0, -440(%rbp)
.L505:
	call	get_n
	testq	%rax, %rax
	js	.L506
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L507
.L506:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L507:
	movsd	-440(%rbp), %xmm1
	divsd	%xmm0, %xmm1
	movsd	overhead.8(%rip), %xmm0
	subsd	%xmm1, %xmm0
	movsd	%xmm0, overhead.8(%rip)
	movsd	overhead.8(%rip), %xmm1
	pxor	%xmm0, %xmm0
	comisd	%xmm1, %xmm0
	jbe	.L508
	pxor	%xmm0, %xmm0
	movsd	%xmm0, overhead.8(%rip)
.L508:
	movq	-424(%rbp), %rax
	movq	%rax, %rdi
	call	set_results
	movq	-416(%rbp), %rax
	movq	%rax, %rdi
	call	save_n
	movq	-408(%rbp), %rax
	movq	%rax, %rdi
	call	settime
.L495:
	movsd	overhead.8(%rip), %xmm0
.L510:
	movq	%xmm0, %rax
	movq	-24(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L511
	call	__stack_chk_fail@PLT
.L511:
	movq	%rax, %xmm0
	addq	$432, %rsp
	popq	%rbx
	popq	%r12
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE61:
	.size	l_overhead, .-l_overhead
	.section	.rodata
.LC48:
	.string	"TIMING_O"
	.text
	.globl	t_overhead
	.type	t_overhead, @function
t_overhead:
.LFB62:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%rbx
	subq	$280, %rsp
	.cfi_offset 3, -24
	movq	%fs:40, %rax
	movq	%rax, -24(%rbp)
	xorl	%eax, %eax
	call	init_timing
	movl	initialized.7(%rip), %eax
	testl	%eax, %eax
	je	.L514
	movq	overhead.6(%rip), %rax
	jmp	.L540
.L514:
	movl	$1, initialized.7(%rip)
	leaq	.LC48(%rip), %rax
	movq	%rax, %rdi
	call	getenv@PLT
	testq	%rax, %rax
	je	.L516
	leaq	.LC48(%rip), %rax
	movq	%rax, %rdi
	call	getenv@PLT
	movq	%rax, %rdi
	call	atof@PLT
	comisd	.LC5(%rip), %xmm0
	jnb	.L517
	cvttsd2siq	%xmm0, %rax
	jmp	.L518
.L517:
	movsd	.LC5(%rip), %xmm1
	subsd	%xmm1, %xmm0
	cvttsd2siq	%xmm0, %rax
	movabsq	$-9223372036854775808, %rdx
	xorq	%rdx, %rax
.L518:
	movq	%rax, overhead.6(%rip)
	jmp	.L519
.L516:
	movl	$0, %edi
	call	get_enough
	cmpl	$50000, %eax
	jg	.L519
	movl	$0, %eax
	call	get_results
	movq	%rax, -256(%rbp)
	call	get_n
	movq	%rax, -248(%rbp)
	call	usecs_spent
	movq	%rax, -240(%rbp)
	leaq	-208(%rbp), %rax
	movq	%rax, %rdi
	call	insertinit
	movl	$0, -280(%rbp)
	jmp	.L520
.L539:
	movl	$0, %edi
	call	get_enough
	movl	%eax, -276(%rbp)
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -264(%rbp)
	jmp	.L521
.L536:
	movl	$0, %edi
	call	start
	movq	__iterations.5(%rip), %rax
	movq	%rax, -272(%rbp)
	jmp	.L522
.L523:
	leaq	-224(%rbp), %rax
	movl	$0, %esi
	movq	%rax, %rdi
	call	gettimeofday@PLT
	subq	$1, -272(%rbp)
.L522:
	cmpq	$0, -272(%rbp)
	jne	.L523
	movl	$0, %esi
	movl	$0, %edi
	call	stop
	testq	%rax, %rax
	js	.L524
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L525
.L524:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L525:
	movsd	%xmm0, -264(%rbp)
	pxor	%xmm1, %xmm1
	cvtsi2sdl	-276(%rbp), %xmm1
	movsd	.LC8(%rip), %xmm0
	mulsd	%xmm1, %xmm0
	comisd	-264(%rbp), %xmm0
	ja	.L526
	pxor	%xmm1, %xmm1
	cvtsi2sdl	-276(%rbp), %xmm1
	movsd	.LC9(%rip), %xmm0
	mulsd	%xmm0, %xmm1
	movsd	-264(%rbp), %xmm0
	comisd	%xmm1, %xmm0
	ja	.L526
	jmp	.L521
.L526:
	movsd	-264(%rbp), %xmm0
	comisd	.LC10(%rip), %xmm0
	jbe	.L543
	movq	__iterations.5(%rip), %rax
	testq	%rax, %rax
	js	.L530
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L531
.L530:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L531:
	divsd	-264(%rbp), %xmm0
	movsd	%xmm0, -232(%rbp)
	pxor	%xmm1, %xmm1
	cvtsi2sdl	-276(%rbp), %xmm1
	movsd	.LC11(%rip), %xmm0
	mulsd	%xmm1, %xmm0
	movsd	-232(%rbp), %xmm1
	mulsd	%xmm1, %xmm0
	movsd	%xmm0, -232(%rbp)
	movsd	-232(%rbp), %xmm1
	movsd	.LC12(%rip), %xmm0
	addsd	%xmm1, %xmm0
	comisd	.LC5(%rip), %xmm0
	jnb	.L532
	cvttsd2siq	%xmm0, %rax
	jmp	.L533
.L532:
	movsd	.LC5(%rip), %xmm1
	subsd	%xmm1, %xmm0
	cvttsd2siq	%xmm0, %rax
	movabsq	$-9223372036854775808, %rdx
	xorq	%rdx, %rax
.L533:
	movq	%rax, __iterations.5(%rip)
	jmp	.L521
.L543:
	movq	__iterations.5(%rip), %rax
	cmpq	$134217728, %rax
	jbe	.L534
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -264(%rbp)
	jmp	.L535
.L534:
	movq	__iterations.5(%rip), %rax
	salq	$3, %rax
	movq	%rax, __iterations.5(%rip)
.L521:
	pxor	%xmm1, %xmm1
	cvtsi2sdl	-276(%rbp), %xmm1
	movsd	.LC7(%rip), %xmm0
	mulsd	%xmm1, %xmm0
	comisd	-264(%rbp), %xmm0
	ja	.L536
.L535:
	movq	__iterations.5(%rip), %rax
	movq	%rax, %rdi
	call	save_n
	movsd	-264(%rbp), %xmm0
	comisd	.LC5(%rip), %xmm0
	jnb	.L537
	movsd	-264(%rbp), %xmm0
	cvttsd2siq	%xmm0, %rax
	jmp	.L538
.L537:
	movsd	-264(%rbp), %xmm0
	movsd	.LC5(%rip), %xmm1
	subsd	%xmm1, %xmm0
	cvttsd2siq	%xmm0, %rax
	movabsq	$-9223372036854775808, %rdx
	xorq	%rdx, %rax
.L538:
	movq	%rax, %rdi
	call	settime
	call	get_n
	movq	%rax, %rbx
	call	usecs_spent
	movq	%rax, %rcx
	leaq	-208(%rbp), %rax
	movq	%rax, %rdx
	movq	%rbx, %rsi
	movq	%rcx, %rdi
	call	insertsort
	addl	$1, -280(%rbp)
.L520:
	cmpl	$10, -280(%rbp)
	jle	.L539
	leaq	-208(%rbp), %rax
	movq	%rax, %rdi
	call	set_results
	movl	$0, %eax
	call	save_minimum
	call	usecs_spent
	movq	%rax, %rbx
	call	get_n
	movq	%rax, %rcx
	movq	%rbx, %rax
	movl	$0, %edx
	divq	%rcx
	movq	%rax, overhead.6(%rip)
	movq	-256(%rbp), %rax
	movq	%rax, %rdi
	call	set_results
	movq	-248(%rbp), %rax
	movq	%rax, %rdi
	call	save_n
	movq	-240(%rbp), %rax
	movq	%rax, %rdi
	call	settime
.L519:
	movq	overhead.6(%rip), %rax
.L540:
	movq	-24(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L541
	call	__stack_chk_fail@PLT
.L541:
	movq	-8(%rbp), %rbx
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE62:
	.size	t_overhead, .-t_overhead
	.local	long_enough
	.comm	long_enough,4,4
	.globl	get_enough
	.type	get_enough, @function
get_enough:
.LFB63:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movl	%edi, -4(%rbp)
	call	init_timing
	movl	long_enough(%rip), %edx
	movl	-4(%rbp), %eax
	cmpl	%eax, %edx
	cmovge	%edx, %eax
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE63:
	.size	get_enough, .-get_enough
	.type	init_timing, @function
init_timing:
.LFB64:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	done.4(%rip), %eax
	testl	%eax, %eax
	jne	.L549
	movl	$1, done.4(%rip)
	movl	$0, %eax
	call	compute_enough
	movl	%eax, long_enough(%rip)
	call	t_overhead
	call	l_overhead
	jmp	.L546
.L549:
	nop
.L546:
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE64:
	.size	init_timing, .-init_timing
	.type	enough_duration, @function
enough_duration:
.LFB65:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, %rdx
	movq	%rsi, %rax
	jmp	.L551
.L552:
	movq	(%rax), %rax
	movq	(%rax), %rax
	movq	(%rax), %rax
	movq	(%rax), %rax
	movq	(%rax), %rax
	movq	(%rax), %rax
	movq	(%rax), %rax
	movq	(%rax), %rax
	movq	(%rax), %rax
	movq	(%rax), %rax
.L551:
	movq	%rdx, %rcx
	leaq	-1(%rcx), %rdx
	testq	%rcx, %rcx
	jg	.L552
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE65:
	.size	enough_duration, .-enough_duration
	.type	duration, @function
duration:
.LFB66:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$48, %rsp
	movq	%rdi, -40(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	leaq	-32(%rbp), %rax
	movq	%rax, -32(%rbp)
	leaq	-32(%rbp), %rax
	movq	%rax, -24(%rbp)
	movl	$0, %edi
	call	start
	movq	-24(%rbp), %rdx
	movq	-40(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	enough_duration
	movq	%rax, -24(%rbp)
	movl	$0, %esi
	movl	$0, %edi
	call	stop
	movq	%rax, -16(%rbp)
	movq	-24(%rbp), %rax
	movq	%rax, %rdi
	call	use_pointer
	movq	-16(%rbp), %rax
	movq	-8(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L556
	call	__stack_chk_fail@PLT
.L556:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE66:
	.size	duration, .-duration
	.type	time_N, @function
time_N:
.LFB67:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$240, %rsp
	movq	%rdi, -232(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movl	$0, %eax
	call	get_results
	movq	%rax, -208(%rbp)
	leaq	-192(%rbp), %rax
	movq	%rax, %rdi
	call	insertinit
	movl	$1, -212(%rbp)
	jmp	.L558
.L559:
	movq	-232(%rbp), %rax
	movq	%rax, %rdi
	call	duration
	movq	%rax, -200(%rbp)
	leaq	-192(%rbp), %rdx
	movq	-232(%rbp), %rcx
	movq	-200(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	insertsort
	addl	$1, -212(%rbp)
.L558:
	cmpl	$10, -212(%rbp)
	jle	.L559
	leaq	-192(%rbp), %rax
	movq	%rax, %rdi
	call	set_results
	movl	$0, %eax
	call	save_minimum
	call	usecs_spent
	movq	%rax, -200(%rbp)
	movq	-208(%rbp), %rax
	movq	%rax, %rdi
	call	set_results
	movq	-200(%rbp), %rax
	movq	-8(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L561
	call	__stack_chk_fail@PLT
.L561:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE67:
	.size	time_N, .-time_N
	.type	find_N, @function
find_N:
.LFB68:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movl	%edi, -20(%rbp)
	movq	usecs.3(%rip), %rax
	testq	%rax, %rax
	jne	.L563
	movq	N.2(%rip), %rax
	movq	%rax, %rdi
	call	time_N
	movq	%rax, usecs.3(%rip)
.L563:
	movl	$0, -12(%rbp)
	jmp	.L564
.L581:
	pxor	%xmm1, %xmm1
	cvtsi2sdl	-20(%rbp), %xmm1
	movsd	.LC49(%rip), %xmm0
	mulsd	%xmm0, %xmm1
	movq	usecs.3(%rip), %rax
	testq	%rax, %rax
	js	.L565
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L566
.L565:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L566:
	comisd	%xmm1, %xmm0
	jbe	.L567
	movq	usecs.3(%rip), %rax
	testq	%rax, %rax
	js	.L569
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L570
.L569:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L570:
	pxor	%xmm2, %xmm2
	cvtsi2sdl	-20(%rbp), %xmm2
	movsd	.LC50(%rip), %xmm1
	mulsd	%xmm2, %xmm1
	comisd	%xmm0, %xmm1
	jbe	.L567
	movq	N.2(%rip), %rax
	jmp	.L572
.L567:
	movq	usecs.3(%rip), %rax
	cmpq	$999, %rax
	ja	.L573
	movq	N.2(%rip), %rdx
	movq	%rdx, %rax
	salq	$2, %rax
	addq	%rdx, %rax
	addq	%rax, %rax
	movq	%rax, N.2(%rip)
	jmp	.L574
.L573:
	movq	N.2(%rip), %rax
	testq	%rax, %rax
	js	.L575
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L576
.L575:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L576:
	movsd	%xmm0, -8(%rbp)
	movq	usecs.3(%rip), %rax
	testq	%rax, %rax
	js	.L577
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L578
.L577:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L578:
	movsd	-8(%rbp), %xmm1
	divsd	%xmm0, %xmm1
	movsd	%xmm1, -8(%rbp)
	pxor	%xmm0, %xmm0
	cvtsi2sdl	-20(%rbp), %xmm0
	movsd	-8(%rbp), %xmm1
	mulsd	%xmm1, %xmm0
	movsd	%xmm0, -8(%rbp)
	movsd	-8(%rbp), %xmm1
	movsd	.LC12(%rip), %xmm0
	addsd	%xmm1, %xmm0
	comisd	.LC5(%rip), %xmm0
	jnb	.L579
	cvttsd2siq	%xmm0, %rax
	jmp	.L580
.L579:
	movsd	.LC5(%rip), %xmm1
	subsd	%xmm1, %xmm0
	cvttsd2siq	%xmm0, %rax
	movabsq	$-9223372036854775808, %rdx
	xorq	%rdx, %rax
.L580:
	movq	%rax, N.2(%rip)
.L574:
	movq	N.2(%rip), %rax
	movq	%rax, %rdi
	call	time_N
	movq	%rax, usecs.3(%rip)
	addl	$1, -12(%rbp)
.L564:
	cmpl	$9, -12(%rbp)
	jle	.L581
	movl	$0, %eax
.L572:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE68:
	.size	find_N, .-find_N
	.data
	.align 16
	.type	test_points, @object
	.size	test_points, 24
test_points:
	.long	-1546188227
	.long	1072708976
	.long	-2061584302
	.long	1072714219
	.long	687194767
	.long	1072729948
	.text
	.type	test_time, @function
test_time:
.LFB69:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$64, %rsp
	movl	%edi, -52(%rbp)
	movl	-52(%rbp), %eax
	movl	%eax, %edi
	call	find_N
	movq	%rax, -40(%rbp)
	cmpq	$0, -40(%rbp)
	jne	.L585
	movl	$0, %eax
	jmp	.L586
.L585:
	movq	-40(%rbp), %rax
	movq	%rax, %rdi
	call	time_N
	movq	%rax, -32(%rbp)
	movl	$0, -44(%rbp)
	jmp	.L587
.L602:
	movq	-40(%rbp), %rax
	testq	%rax, %rax
	js	.L588
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L589
.L588:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L589:
	movl	-44(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	leaq	test_points(%rip), %rax
	movsd	(%rdx,%rax), %xmm1
	mulsd	%xmm1, %xmm0
	cvttsd2sil	%xmm0, %eax
	cltq
	movq	%rax, %rdi
	call	time_N
	movq	%rax, -24(%rbp)
	movq	-32(%rbp), %rax
	testq	%rax, %rax
	js	.L590
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L591
.L590:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L591:
	movl	-44(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	leaq	test_points(%rip), %rax
	movsd	(%rdx,%rax), %xmm1
	mulsd	%xmm1, %xmm0
	comisd	.LC5(%rip), %xmm0
	jnb	.L592
	cvttsd2siq	%xmm0, %rax
	movq	%rax, -16(%rbp)
	jmp	.L593
.L592:
	movsd	.LC5(%rip), %xmm1
	subsd	%xmm1, %xmm0
	cvttsd2siq	%xmm0, %rax
	movq	%rax, -16(%rbp)
	movabsq	$-9223372036854775808, %rax
	xorq	%rax, -16(%rbp)
.L593:
	movq	-16(%rbp), %rax
	movq	%rax, -16(%rbp)
	movq	-16(%rbp), %rax
	cmpq	-24(%rbp), %rax
	jbe	.L594
	movq	-16(%rbp), %rax
	subq	-24(%rbp), %rax
	jmp	.L595
.L594:
	movq	-24(%rbp), %rax
	subq	-16(%rbp), %rax
.L595:
	movq	%rax, -8(%rbp)
	movq	-8(%rbp), %rax
	testq	%rax, %rax
	js	.L596
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L597
.L596:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L597:
	movq	-16(%rbp), %rax
	testq	%rax, %rax
	js	.L598
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rax, %xmm1
	jmp	.L599
.L598:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rdx, %xmm1
	addsd	%xmm1, %xmm1
.L599:
	divsd	%xmm1, %xmm0
	comisd	.LC51(%rip), %xmm0
	jbe	.L604
	movl	$0, %eax
	jmp	.L586
.L604:
	addl	$1, -44(%rbp)
.L587:
	movl	-44(%rbp), %eax
	cmpl	$2, %eax
	jbe	.L602
	movl	$1, %eax
.L586:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE69:
	.size	test_time, .-test_time
	.data
	.align 16
	.type	possibilities, @object
	.size	possibilities, 16
possibilities:
	.long	5000
	.long	10000
	.long	50000
	.long	100000
	.section	.rodata
.LC52:
	.string	"ENOUGH"
	.text
	.type	compute_enough, @function
compute_enough:
.LFB70:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	leaq	.LC52(%rip), %rax
	movq	%rax, %rdi
	call	getenv@PLT
	testq	%rax, %rax
	je	.L606
	leaq	.LC52(%rip), %rax
	movq	%rax, %rdi
	call	getenv@PLT
	movq	%rax, %rdi
	call	atoi@PLT
	jmp	.L607
.L606:
	movl	$0, -4(%rbp)
	jmp	.L608
.L610:
	movl	-4(%rbp), %eax
	cltq
	leaq	0(,%rax,4), %rdx
	leaq	possibilities(%rip), %rax
	movl	(%rdx,%rax), %eax
	movl	%eax, %edi
	call	test_time
	testl	%eax, %eax
	je	.L609
	movl	-4(%rbp), %eax
	cltq
	leaq	0(,%rax,4), %rdx
	leaq	possibilities(%rip), %rax
	movl	(%rdx,%rax), %eax
	jmp	.L607
.L609:
	addl	$1, -4(%rbp)
.L608:
	movl	-4(%rbp), %eax
	cmpl	$3, %eax
	jbe	.L610
	movl	$1000000, %eax
.L607:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE70:
	.size	compute_enough, .-compute_enough
	.globl	morefds
	.type	morefds, @function
morefds:
.LFB71:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	leaq	-32(%rbp), %rax
	movq	%rax, %rsi
	movl	$7, %edi
	call	getrlimit@PLT
	movq	-24(%rbp), %rax
	movq	%rax, -32(%rbp)
	leaq	-32(%rbp), %rax
	movq	%rax, %rsi
	movl	$7, %edi
	call	setrlimit@PLT
	nop
	movq	-8(%rbp), %rax
	subq	%fs:40, %rax
	je	.L612
	call	__stack_chk_fail@PLT
.L612:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE71:
	.size	morefds, .-morefds
	.globl	bread
	.type	bread, @function
bread:
.LFB72:
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
	movq	$0, -32(%rbp)
	movq	-48(%rbp), %rbx
	movq	-56(%rbp), %rdx
	movq	-48(%rbp), %rax
	leaq	(%rdx,%rax), %r13
	leaq	1024(%rbx), %r12
	jmp	.L614
.L615:
	movq	(%rbx), %rdx
	leaq	8(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	16(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	24(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	32(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	40(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	48(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	56(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	64(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	72(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	80(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	88(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	96(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	104(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	112(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	120(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	128(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	136(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	144(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	152(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	160(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	168(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	176(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	184(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	192(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	200(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	208(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	216(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	224(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	232(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	240(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	248(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	256(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	264(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	272(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	280(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	288(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	296(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	304(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	312(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	320(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	328(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	336(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	344(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	352(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	360(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	368(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	376(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	384(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	392(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	400(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	408(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	416(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	424(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	432(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	440(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	448(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	456(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	464(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	472(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	480(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	488(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	496(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	504(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	512(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	520(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	528(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	536(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	544(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	552(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	560(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	568(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	576(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	584(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	592(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	600(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	608(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	616(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	624(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	632(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	640(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	648(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	656(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	664(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	672(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	680(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	688(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	696(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	704(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	712(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	720(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	728(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	736(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	744(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	752(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	760(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	768(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	776(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	784(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	792(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	800(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	808(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	816(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	824(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	832(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	840(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	848(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	856(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	864(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	872(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	880(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	888(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	896(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	904(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	912(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	920(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	928(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	936(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	944(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	952(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	960(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	968(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	976(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	984(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	992(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	1000(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	1008(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	1016(%rbx), %rax
	movq	(%rax), %rax
	addq	%rdx, %rax
	addq	%rax, -32(%rbp)
	movq	%r12, %rbx
	addq	$1024, %r12
.L614:
	cmpq	%r13, %r12
	jbe	.L615
	leaq	128(%rbx), %r12
	jmp	.L616
.L617:
	movq	(%rbx), %rdx
	leaq	8(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	16(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	24(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	32(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	40(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	48(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	56(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	64(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	72(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	80(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	88(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	96(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	104(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	112(%rbx), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	leaq	120(%rbx), %rax
	movq	(%rax), %rax
	addq	%rdx, %rax
	addq	%rax, -32(%rbp)
	movq	%r12, %rbx
	subq	$-128, %r12
.L616:
	cmpq	%r13, %r12
	jbe	.L617
	leaq	8(%rbx), %r12
	jmp	.L618
.L619:
	movq	(%rbx), %rax
	addq	%rax, -32(%rbp)
	movq	%r12, %rbx
	addq	$8, %r12
.L618:
	cmpq	%r13, %r12
	jbe	.L619
	movq	-32(%rbp), %rax
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE72:
	.size	bread, .-bread
	.globl	touch
	.type	touch, @function
touch:
.LFB73:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	psize.1(%rip), %rax
	testq	%rax, %rax
	jne	.L623
	call	getpagesize@PLT
	cltq
	movq	%rax, psize.1(%rip)
	jmp	.L623
.L624:
	movq	-8(%rbp), %rax
	movb	$1, (%rax)
	movq	psize.1(%rip), %rax
	addq	%rax, -8(%rbp)
	movq	psize.1(%rip), %rax
	subq	%rax, -16(%rbp)
.L623:
	movq	psize.1(%rip), %rax
	cmpq	%rax, -16(%rbp)
	jnb	.L624
	nop
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE73:
	.size	touch, .-touch
	.globl	permutation
	.type	permutation, @function
permutation:
.LFB74:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%rbx
	subq	$56, %rsp
	.cfi_offset 3, -24
	movq	%rdi, -56(%rbp)
	movq	%rsi, -64(%rbp)
	movq	-56(%rbp), %rax
	salq	$3, %rax
	movq	%rax, %rdi
	call	malloc@PLT
	movq	%rax, -40(%rbp)
	cmpq	$0, -40(%rbp)
	jne	.L626
	movl	$0, %eax
	jmp	.L627
.L626:
	movq	$0, -48(%rbp)
	jmp	.L628
.L629:
	movq	-48(%rbp), %rax
	leaq	0(,%rax,8), %rdx
	movq	-40(%rbp), %rax
	addq	%rax, %rdx
	movq	-48(%rbp), %rax
	imulq	-64(%rbp), %rax
	movq	%rax, (%rdx)
	addq	$1, -48(%rbp)
.L628:
	movq	-48(%rbp), %rax
	cmpq	-56(%rbp), %rax
	jb	.L629
	movq	r.0(%rip), %rax
	testq	%rax, %rax
	jne	.L630
	call	getpid@PLT
	sall	$6, %eax
	movl	%eax, %ebx
	call	getppid@PLT
	xorl	%eax, %ebx
	call	rand@PLT
	xorl	%eax, %ebx
	call	rand@PLT
	sall	$10, %eax
	xorl	%ebx, %eax
	cltq
	movq	%rax, r.0(%rip)
.L630:
	movq	$0, -48(%rbp)
	jmp	.L631
.L632:
	movq	r.0(%rip), %rax
	leaq	(%rax,%rax), %rbx
	call	rand@PLT
	cltq
	xorq	%rbx, %rax
	movq	%rax, r.0(%rip)
	movq	r.0(%rip), %rax
	movl	$0, %edx
	divq	-56(%rbp)
	movq	%rdx, -32(%rbp)
	movq	-32(%rbp), %rax
	leaq	0(,%rax,8), %rdx
	movq	-40(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	%rax, -24(%rbp)
	movq	-48(%rbp), %rax
	leaq	0(,%rax,8), %rdx
	movq	-40(%rbp), %rax
	addq	%rdx, %rax
	movq	-32(%rbp), %rdx
	leaq	0(,%rdx,8), %rcx
	movq	-40(%rbp), %rdx
	addq	%rcx, %rdx
	movq	(%rax), %rax
	movq	%rax, (%rdx)
	movq	-48(%rbp), %rax
	leaq	0(,%rax,8), %rdx
	movq	-40(%rbp), %rax
	addq	%rax, %rdx
	movq	-24(%rbp), %rax
	movq	%rax, (%rdx)
	addq	$1, -48(%rbp)
.L631:
	movq	-48(%rbp), %rax
	cmpq	-56(%rbp), %rax
	jb	.L632
	movq	-40(%rbp), %rax
.L627:
	movq	-8(%rbp), %rbx
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE74:
	.size	permutation, .-permutation
	.globl	cp
	.type	cp, @function
cp:
.LFB75:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$4096, %rsp
	orq	$0, (%rsp)
	subq	$4096, %rsp
	orq	$0, (%rsp)
	subq	$64, %rsp
	movq	%rdi, -8232(%rbp)
	movq	%rsi, -8240(%rbp)
	movl	%edx, -8244(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movq	-8232(%rbp), %rax
	movl	$0, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	open@PLT
	movl	%eax, -8224(%rbp)
	cmpl	$0, -8224(%rbp)
	jns	.L634
	movl	$-1, %eax
	jmp	.L639
.L634:
	movl	-8244(%rbp), %edx
	movq	-8240(%rbp), %rax
	movl	$578, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	open@PLT
	movl	%eax, -8220(%rbp)
	cmpl	$0, -8220(%rbp)
	jns	.L637
	movl	$-1, %eax
	jmp	.L639
.L638:
	movq	-8216(%rbp), %rdx
	leaq	-8208(%rbp), %rcx
	movl	-8220(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	write@PLT
	cmpq	%rax, -8216(%rbp)
	jle	.L637
	movl	$-1, %eax
	jmp	.L639
.L637:
	leaq	-8208(%rbp), %rcx
	movl	-8224(%rbp), %eax
	movl	$8192, %edx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	read@PLT
	movq	%rax, -8216(%rbp)
	cmpq	$0, -8216(%rbp)
	jg	.L638
	movl	-8220(%rbp), %eax
	movl	%eax, %edi
	call	fsync@PLT
	movl	-8224(%rbp), %eax
	movl	%eax, %edi
	call	close@PLT
	movl	-8220(%rbp), %eax
	movl	%eax, %edi
	call	close@PLT
	movl	$0, %eax
.L639:
	movq	-8(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L640
	call	__stack_chk_fail@PLT
.L640:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE75:
	.size	cp, .-cp
	.globl	seekto
	.type	seekto, @function
seekto:
.LFB76:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movl	%edi, -20(%rbp)
	movq	%rsi, -32(%rbp)
	movl	%edx, -24(%rbp)
	movq	$0, -8(%rbp)
	cmpq	$0, -32(%rbp)
	js	.L642
	movl	$1073741824, %eax
	jmp	.L643
.L642:
	movl	$-1073741824, %eax
.L643:
	movl	%eax, -16(%rbp)
	cmpl	$2, -24(%rbp)
	je	.L644
	cmpl	$2, -24(%rbp)
	jg	.L657
	cmpl	$0, -24(%rbp)
	je	.L646
	cmpl	$1, -24(%rbp)
	je	.L647
	jmp	.L657
.L646:
	movl	-20(%rbp), %eax
	movl	$0, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	lseek@PLT
	jmp	.L648
.L644:
	movl	-20(%rbp), %eax
	movl	$2, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	lseek@PLT
	cmpq	$-1, %rax
	jne	.L658
	movq	$-1, %rax
	jmp	.L650
.L647:
	cmpq	$0, -32(%rbp)
	jne	.L657
	movl	-20(%rbp), %eax
	movl	$1, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	lseek@PLT
	jmp	.L650
.L657:
	nop
	jmp	.L651
.L658:
	nop
.L648:
	jmp	.L651
.L654:
	movl	-16(%rbp), %eax
	movslq	%eax, %rcx
	movl	-20(%rbp), %eax
	movl	$1, %edx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	lseek@PLT
	cmpq	$-1, %rax
	jne	.L652
	call	__errno_location@PLT
	movl	(%rax), %eax
	testl	%eax, %eax
	je	.L652
	movq	$-1, %rax
	jmp	.L650
.L652:
	movl	-16(%rbp), %eax
	cltq
	addq	%rax, -8(%rbp)
.L651:
	movq	-32(%rbp), %rax
	subq	-8(%rbp), %rax
	movq	%rax, %rdx
	movl	-16(%rbp), %eax
	cltq
	cmpq	%rax, %rdx
	jge	.L653
	cmpl	$0, -16(%rbp)
	js	.L654
.L653:
	cmpl	$0, -16(%rbp)
	jle	.L655
	movl	-16(%rbp), %eax
	movslq	%eax, %rdx
	movq	-32(%rbp), %rax
	subq	-8(%rbp), %rax
	cmpq	%rax, %rdx
	jl	.L654
.L655:
	movq	-32(%rbp), %rax
	movl	%eax, %edx
	movq	-8(%rbp), %rax
	movl	%eax, %ecx
	movl	%edx, %eax
	subl	%ecx, %eax
	movslq	%eax, %rcx
	movl	-20(%rbp), %eax
	movl	$1, %edx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	lseek@PLT
	movl	%eax, -12(%rbp)
	cmpl	$-1, -12(%rbp)
	je	.L656
	cmpl	$0, -24(%rbp)
	jne	.L656
	movq	-32(%rbp), %rax
	jmp	.L650
.L656:
	movl	-12(%rbp), %eax
	cltq
.L650:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE76:
	.size	seekto, .-seekto
	.local	last.13
	.comm	last.13,16,16
	.section	.rodata
	.type	__PRETTY_FUNCTION__.12, @object
	.size	__PRETTY_FUNCTION__.12, 6
__PRETTY_FUNCTION__.12:
	.string	"tvsub"
	.data
	.align 8
	.type	__iterations.11, @object
	.size	__iterations.11, 8
__iterations.11:
	.quad	1
	.align 8
	.type	__iterations.10, @object
	.size	__iterations.10, 8
__iterations.10:
	.quad	1
	.local	initialized.9
	.comm	initialized.9,4,4
	.local	overhead.8
	.comm	overhead.8,8,8
	.local	initialized.7
	.comm	initialized.7,4,4
	.local	overhead.6
	.comm	overhead.6,8,8
	.align 8
	.type	__iterations.5, @object
	.size	__iterations.5, 8
__iterations.5:
	.quad	1
	.local	done.4
	.comm	done.4,4,4
	.local	usecs.3
	.comm	usecs.3,8,8
	.align 8
	.type	N.2, @object
	.size	N.2, 8
N.2:
	.quad	10000
	.local	psize.1
	.comm	psize.1,8,8
	.local	r.0
	.comm	r.0,8,8
	.section	.rodata
	.align 8
.LC0:
	.long	0
	.long	1093567616
	.align 8
.LC1:
	.long	0
	.long	1079574528
	.align 8
.LC5:
	.long	0
	.long	1138753536
	.align 8
.LC7:
	.long	1717986918
	.long	1072588390
	.align 8
.LC8:
	.long	2061584302
	.long	1072672276
	.align 8
.LC9:
	.long	858993459
	.long	1072902963
	.align 8
.LC10:
	.long	0
	.long	1080213504
	.align 8
.LC11:
	.long	-1717986918
	.long	1072798105
	.align 8
.LC12:
	.long	0
	.long	1072693248
	.align 8
.LC18:
	.long	0
	.long	1083129856
	.align 8
.LC31:
	.long	0
	.long	1076101120
	.align 8
.LC41:
	.long	0
	.long	1083179008
	.align 8
.LC42:
	.long	0
	.long	1082130432
	.align 8
.LC49:
	.long	-171798692
	.long	1072651304
	.align 8
.LC50:
	.long	-2061584302
	.long	1072714219
	.align 8
.LC51:
	.long	1202590843
	.long	1063549665
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
