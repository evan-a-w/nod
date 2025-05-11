	.file	"stream.c"
	.text
	.globl	copy
	.type	copy, @function
copy:
.LFB74:
	.cfi_startproc
	endbr64
	leaq	-1(%rdi), %r8
	testq	%rdi, %rdi
	je	.L1
.L5:
	movl	32(%rsi), %edx
	movq	(%rsi), %rcx
	movq	16(%rsi), %rdi
	movq	8(%rsi), %rax
	movq	%rax, (%rsi)
	movq	%rdi, 8(%rsi)
	movq	%rcx, 16(%rsi)
	testl	%edx, %edx
	jle	.L3
	movl	%edx, %edx
	movl	$0, %eax
.L4:
	movsd	(%rcx,%rax,8), %xmm0
	movsd	%xmm0, (%rdi,%rax,8)
	addq	$1, %rax
	cmpq	%rdx, %rax
	jne	.L4
.L3:
	subq	$1, %r8
	cmpq	$-1, %r8
	jne	.L5
.L1:
	ret
	.cfi_endproc
.LFE74:
	.size	copy, .-copy
	.globl	scale
	.type	scale, @function
scale:
.LFB75:
	.cfi_startproc
	endbr64
	leaq	-1(%rdi), %r8
	testq	%rdi, %rdi
	je	.L8
.L12:
	movl	32(%rsi), %edx
	movq	(%rsi), %rax
	movq	8(%rsi), %rcx
	movq	16(%rsi), %rdi
	movsd	24(%rsi), %xmm1
	movq	%rcx, (%rsi)
	movq	%rdi, 8(%rsi)
	movq	%rax, 16(%rsi)
	testl	%edx, %edx
	jle	.L10
	movl	%edx, %edx
	movl	$0, %eax
.L11:
	movapd	%xmm1, %xmm0
	mulsd	(%rdi,%rax,8), %xmm0
	movsd	%xmm0, (%rcx,%rax,8)
	addq	$1, %rax
	cmpq	%rdx, %rax
	jne	.L11
.L10:
	subq	$1, %r8
	cmpq	$-1, %r8
	jne	.L12
.L8:
	ret
	.cfi_endproc
.LFE75:
	.size	scale, .-scale
	.globl	add
	.type	add, @function
add:
.LFB76:
	.cfi_startproc
	endbr64
	leaq	-1(%rdi), %r9
	testq	%rdi, %rdi
	je	.L15
.L19:
	movl	32(%rsi), %edx
	movq	(%rsi), %rcx
	movq	8(%rsi), %rdi
	movq	16(%rsi), %r8
	movq	%rdi, (%rsi)
	movq	%r8, 8(%rsi)
	movq	%rcx, 16(%rsi)
	testl	%edx, %edx
	jle	.L17
	movl	%edx, %edx
	movl	$0, %eax
.L18:
	movsd	(%rcx,%rax,8), %xmm0
	addsd	(%rdi,%rax,8), %xmm0
	movsd	%xmm0, (%r8,%rax,8)
	addq	$1, %rax
	cmpq	%rdx, %rax
	jne	.L18
.L17:
	subq	$1, %r9
	cmpq	$-1, %r9
	jne	.L19
.L15:
	ret
	.cfi_endproc
.LFE76:
	.size	add, .-add
	.globl	triad
	.type	triad, @function
triad:
.LFB77:
	.cfi_startproc
	endbr64
	leaq	-1(%rdi), %r9
	testq	%rdi, %rdi
	je	.L22
.L26:
	movl	32(%rsi), %edx
	movq	(%rsi), %rcx
	movq	8(%rsi), %rdi
	movq	16(%rsi), %r8
	movsd	24(%rsi), %xmm1
	movq	%rdi, (%rsi)
	movq	%r8, 8(%rsi)
	movq	%rcx, 16(%rsi)
	testl	%edx, %edx
	jle	.L24
	movl	%edx, %edx
	movl	$0, %eax
.L25:
	movapd	%xmm1, %xmm0
	mulsd	(%r8,%rax,8), %xmm0
	addsd	(%rdi,%rax,8), %xmm0
	movsd	%xmm0, (%rcx,%rax,8)
	addq	$1, %rax
	cmpq	%rdx, %rax
	jne	.L25
.L24:
	subq	$1, %r9
	cmpq	$-1, %r9
	jne	.L26
.L22:
	ret
	.cfi_endproc
.LFE77:
	.size	triad, .-triad
	.globl	fill
	.type	fill, @function
fill:
.LFB78:
	.cfi_startproc
	endbr64
	leaq	-1(%rdi), %rcx
	testq	%rdi, %rdi
	je	.L29
.L33:
	movl	32(%rsi), %edi
	movq	(%rsi), %rdx
	movq	16(%rsi), %rax
	movq	8(%rsi), %r8
	movq	%r8, (%rsi)
	movq	%rax, 8(%rsi)
	movq	%rdx, 16(%rsi)
	testl	%edi, %edi
	jle	.L31
	movq	%rdx, %rax
	leal	-1(%rdi), %edi
	leaq	8(%rdx,%rdi,8), %rdx
.L32:
	movq	$0x000000000, (%rax)
	addq	$8, %rax
	cmpq	%rdx, %rax
	jne	.L32
.L31:
	subq	$1, %rcx
	cmpq	$-1, %rcx
	jne	.L33
.L29:
	ret
	.cfi_endproc
.LFE78:
	.size	fill, .-fill
	.globl	daxpy
	.type	daxpy, @function
daxpy:
.LFB79:
	.cfi_startproc
	endbr64
	leaq	-1(%rdi), %r8
	testq	%rdi, %rdi
	je	.L36
.L40:
	movl	32(%rsi), %ecx
	movq	(%rsi), %rdx
	movq	8(%rsi), %rdi
	movq	16(%rsi), %rax
	movsd	24(%rsi), %xmm1
	movq	%rdi, (%rsi)
	movq	%rax, 8(%rsi)
	movq	%rdx, 16(%rsi)
	testl	%ecx, %ecx
	jle	.L38
	movl	%ecx, %ecx
	movl	$0, %eax
.L39:
	movapd	%xmm1, %xmm0
	mulsd	(%rdi,%rax,8), %xmm0
	addsd	(%rdx,%rax,8), %xmm0
	movsd	%xmm0, (%rdx,%rax,8)
	addq	$1, %rax
	cmpq	%rcx, %rax
	jne	.L39
.L38:
	subq	$1, %r8
	cmpq	$-1, %r8
	jne	.L40
.L36:
	ret
	.cfi_endproc
.LFE79:
	.size	daxpy, .-daxpy
	.globl	cleanup
	.type	cleanup, @function
cleanup:
.LFB81:
	.cfi_startproc
	endbr64
	testq	%rdi, %rdi
	je	.L49
	ret
.L49:
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movq	%rsi, %rbx
	movq	(%rsi), %rdi
	call	free@PLT
	movq	8(%rbx), %rdi
	call	free@PLT
	movq	16(%rbx), %rdi
	call	free@PLT
	popq	%rbx
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE81:
	.size	cleanup, .-cleanup
	.globl	initialize
	.type	initialize, @function
initialize:
.LFB73:
	.cfi_startproc
	endbr64
	testq	%rdi, %rdi
	je	.L60
	ret
.L60:
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
	subq	$8, %rsp
	.cfi_def_cfa_offset 64
	movq	%rdi, %rbx
	movq	%rsi, %rbp
	movl	32(%rsi), %r13d
	movslq	%r13d, %r12
	salq	$3, %r12
	movq	%r12, %rdi
	call	malloc@PLT
	movq	%rax, %r14
	movq	%rax, 0(%rbp)
	movq	%r12, %rdi
	call	malloc@PLT
	movq	%rax, %r15
	movq	%rax, 8(%rbp)
	movq	%r12, %rdi
	call	malloc@PLT
	movq	%rax, 16(%rbp)
	testq	%r15, %r15
	sete	%dl
	testq	%r14, %r14
	sete	%cl
	orb	%cl, %dl
	jne	.L52
	testq	%rax, %rax
	je	.L52
	movsd	.LC1(%rip), %xmm1
	movsd	.LC2(%rip), %xmm0
	testl	%r13d, %r13d
	jle	.L50
.L53:
	movq	0(%rbp), %rax
	movsd	%xmm1, (%rax,%rbx,8)
	movq	8(%rbp), %rax
	movsd	%xmm0, (%rax,%rbx,8)
	movq	16(%rbp), %rax
	movq	$0x000000000, (%rax,%rbx,8)
	addq	$1, %rbx
	cmpl	%ebx, 32(%rbp)
	jg	.L53
.L50:
	addq	$8, %rsp
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
.L52:
	.cfi_restore_state
	movl	$1, %edi
	call	exit@PLT
	.cfi_endproc
.LFE73:
	.size	initialize, .-initialize
	.globl	sum
	.type	sum, @function
sum:
.LFB80:
	.cfi_startproc
	endbr64
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	testq	%rdi, %rdi
	je	.L66
	leaq	-1(%rdi), %rcx
	movl	32(%rsi), %r8d
	leal	-1(%r8), %r9d
	salq	$3, %r9
	pxor	%xmm0, %xmm0
.L65:
	movq	(%rsi), %rdx
	movq	16(%rsi), %rax
	movq	8(%rsi), %rdi
	movq	%rdi, (%rsi)
	movq	%rax, 8(%rsi)
	movq	%rdx, 16(%rsi)
	testl	%r8d, %r8d
	jle	.L63
	movq	%rdx, %rax
	leaq	8(%rdx,%r9), %rdx
.L64:
	addsd	(%rax), %xmm0
	addq	$8, %rax
	cmpq	%rdx, %rax
	jne	.L64
.L63:
	subq	$1, %rcx
	cmpq	$-1, %rcx
	jne	.L65
.L62:
	cvttsd2sil	%xmm0, %edi
	call	use_int@PLT
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	ret
.L66:
	.cfi_restore_state
	pxor	%xmm0, %xmm0
	jmp	.L62
	.cfi_endproc
.LFE80:
	.size	sum, .-sum
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC4:
	.string	"[-v <stream version 1|2>] [-M <len>[K|M]] [-P <parallelism>] [-W <warmup>] [-N <repetitions>]\n"
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC5:
	.string	"v:M:P:W:N:"
.LC6:
	.string	"STREAM copy latency"
.LC7:
	.string	"STREAM copy bandwidth: "
.LC8:
	.string	"STREAM scale latency"
.LC9:
	.string	"STREAM scale bandwidth: "
.LC10:
	.string	"STREAM add latency"
.LC11:
	.string	"STREAM add bandwidth: "
.LC12:
	.string	"STREAM triad latency"
.LC13:
	.string	"STREAM triad bandwidth: "
.LC14:
	.string	"STREAM2 fill latency"
.LC15:
	.string	"STREAM2 fill bandwidth: "
.LC16:
	.string	"STREAM2 copy latency"
.LC17:
	.string	"STREAM2 copy bandwidth: "
.LC18:
	.string	"STREAM2 daxpy latency"
.LC19:
	.string	"STREAM2 daxpy bandwidth: "
.LC20:
	.string	"STREAM2 sum latency"
.LC21:
	.string	"STREAM2 sum bandwidth: "
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
	subq	$72, %rsp
	.cfi_def_cfa_offset 128
	movl	%edi, %ebp
	movq	%rsi, %rbx
	movq	%fs:40, %rax
	movq	%rax, 56(%rsp)
	xorl	%eax, %eax
	movl	$24000000, 48(%rsp)
	movq	.LC3(%rip), %rax
	movq	%rax, 40(%rsp)
	movl	$-1, %r15d
	movl	$0, %r14d
	movl	$1, %r13d
	movl	$1, 12(%rsp)
	leaq	.LC5(%rip), %r12
	jmp	.L71
.L101:
	cmpl	$77, %eax
	je	.L74
	cmpl	$78, %eax
	jne	.L76
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	movl	%eax, %r15d
	jmp	.L71
.L72:
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	movl	%eax, %r13d
	testl	%eax, %eax
	jg	.L71
	leaq	.LC4(%rip), %rdx
	movq	%rbx, %rsi
	movl	%ebp, %edi
	call	lmbench_usage@PLT
	jmp	.L71
.L74:
	movq	myoptarg(%rip), %rdi
	call	bytes@PLT
	movl	%eax, 48(%rsp)
.L71:
	movq	%r12, %rdx
	movq	%rbx, %rsi
	movl	%ebp, %edi
	call	mygetopt@PLT
	cmpl	$-1, %eax
	je	.L100
	cmpl	$80, %eax
	je	.L72
	jle	.L101
	cmpl	$87, %eax
	je	.L77
	cmpl	$118, %eax
	jne	.L76
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	movl	%eax, 12(%rsp)
	subl	$1, %eax
	cmpl	$1, %eax
	jbe	.L71
	leaq	.LC4(%rip), %rdx
	movq	%rbx, %rsi
	movl	%ebp, %edi
	call	lmbench_usage@PLT
	jmp	.L71
.L77:
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	movl	%eax, %r14d
	jmp	.L71
.L76:
	leaq	.LC4(%rip), %rdx
	movq	%rbx, %rsi
	movl	%ebp, %edi
	call	lmbench_usage@PLT
	jmp	.L71
.L100:
	movl	$2, %r12d
.L80:
	movl	48(%rsp), %ebp
	movslq	%ebp, %rbx
	movq	%rbx, %rdi
	call	malloc@PLT
	movq	%rax, %rdi
	testq	%rax, %rax
	je	.L81
	call	free@PLT
	movabsq	$-6148914691236517205, %rdx
	movq	%rbx, %rax
	mulq	%rdx
	shrq	$4, %rdx
	movl	%edx, 48(%rsp)
	movslq	%edx, %rbx
	movslq	%r13d, %rax
	imulq	%rax, %rbx
	cmpl	$1, 12(%rsp)
	je	.L102
	leaq	0(,%rbx,8), %rbp
	leaq	16(%rsp), %rax
	pushq	%rax
	.cfi_def_cfa_offset 136
	pushq	%r15
	.cfi_def_cfa_offset 144
	movl	%r14d, %r9d
	movl	%r13d, %r8d
	movl	$0, %ecx
	leaq	cleanup(%rip), %rdx
	leaq	fill(%rip), %rsi
	leaq	initialize(%rip), %rdi
	call	benchmp@PLT
	call	usecs_spent@PLT
	addq	$16, %rsp
	.cfi_def_cfa_offset 128
	testq	%rax, %rax
	je	.L91
	cmpl	$1, %r13d
	jle	.L103
.L92:
	movslq	48(%rsp), %r12
	call	get_n@PLT
	movq	%r12, %rsi
	imulq	%rax, %rsi
	leaq	.LC14(%rip), %rdi
	call	nano@PLT
	movq	stderr(%rip), %rcx
	movl	$24, %edx
	movl	$1, %esi
	leaq	.LC15(%rip), %rdi
	call	fwrite@PLT
	call	get_n@PLT
	imulq	%rbp, %rax
	movq	%rax, %rdi
	call	mb@PLT
.L91:
	leaq	16(%rsp), %rax
	pushq	%rax
	.cfi_def_cfa_offset 136
	pushq	%r15
	.cfi_def_cfa_offset 144
	movl	%r14d, %r9d
	movl	%r13d, %r8d
	movl	$0, %ecx
	leaq	cleanup(%rip), %rdx
	leaq	copy(%rip), %rsi
	leaq	initialize(%rip), %rdi
	call	benchmp@PLT
	call	usecs_spent@PLT
	addq	$16, %rsp
	.cfi_def_cfa_offset 128
	testq	%rax, %rax
	je	.L93
	cmpl	$1, %r13d
	jle	.L104
.L94:
	movslq	48(%rsp), %r12
	call	get_n@PLT
	movq	%r12, %rsi
	imulq	%rax, %rsi
	leaq	.LC16(%rip), %rdi
	call	nano@PLT
	movq	stderr(%rip), %rcx
	movl	$24, %edx
	movl	$1, %esi
	leaq	.LC17(%rip), %rdi
	call	fwrite@PLT
	call	get_n@PLT
	imulq	%rbx, %rax
	movq	%rax, %rdi
	salq	$4, %rdi
	call	mb@PLT
.L93:
	leaq	16(%rsp), %rax
	pushq	%rax
	.cfi_def_cfa_offset 136
	pushq	%r15
	.cfi_def_cfa_offset 144
	movl	%r14d, %r9d
	movl	%r13d, %r8d
	movl	$0, %ecx
	leaq	cleanup(%rip), %rdx
	leaq	daxpy(%rip), %rsi
	leaq	initialize(%rip), %rdi
	call	benchmp@PLT
	call	usecs_spent@PLT
	addq	$16, %rsp
	.cfi_def_cfa_offset 128
	testq	%rax, %rax
	je	.L95
	cmpl	$1, %r13d
	jle	.L105
.L96:
	movslq	48(%rsp), %r12
	call	get_n@PLT
	movq	%r12, %rsi
	imulq	%rax, %rsi
	leaq	.LC18(%rip), %rdi
	call	nano@PLT
	movq	stderr(%rip), %rcx
	movl	$25, %edx
	movl	$1, %esi
	leaq	.LC19(%rip), %rdi
	call	fwrite@PLT
	call	get_n@PLT
	imulq	%rax, %rbx
	imulq	$24, %rbx, %rdi
	call	mb@PLT
.L95:
	leaq	16(%rsp), %rax
	pushq	%rax
	.cfi_def_cfa_offset 136
	pushq	%r15
	.cfi_def_cfa_offset 144
	movl	%r14d, %r9d
	movl	%r13d, %r8d
	movl	$0, %ecx
	leaq	cleanup(%rip), %rdx
	leaq	sum(%rip), %rsi
	leaq	initialize(%rip), %rdi
	call	benchmp@PLT
	call	usecs_spent@PLT
	addq	$16, %rsp
	.cfi_def_cfa_offset 128
	testq	%rax, %rax
	je	.L89
	cmpl	$1, %r13d
	jle	.L106
.L97:
	movslq	48(%rsp), %rbx
	call	get_n@PLT
	imulq	%rax, %rbx
	movq	%rbx, %rsi
	leaq	.LC20(%rip), %rdi
	call	nano@PLT
	movq	stderr(%rip), %rcx
	movl	$23, %edx
	movl	$1, %esi
	leaq	.LC21(%rip), %rdi
	call	fwrite@PLT
	call	get_n@PLT
	imulq	%rbp, %rax
	movq	%rax, %rdi
	call	mb@PLT
.L89:
	movq	56(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L107
	movl	$0, %eax
	addq	$72, %rsp
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
.L81:
	.cfi_restore_state
	movl	%ebp, %eax
	cltd
	idivl	%r12d
	movl	%eax, 48(%rsp)
	jmp	.L80
.L102:
	leaq	16(%rsp), %rax
	pushq	%rax
	.cfi_def_cfa_offset 136
	pushq	%r15
	.cfi_def_cfa_offset 144
	movl	%r14d, %r9d
	movl	%r13d, %r8d
	movl	$0, %ecx
	leaq	cleanup(%rip), %rdx
	leaq	copy(%rip), %rsi
	leaq	initialize(%rip), %rdi
	call	benchmp@PLT
	call	usecs_spent@PLT
	addq	$16, %rsp
	.cfi_def_cfa_offset 128
	testq	%rax, %rax
	je	.L83
	cmpl	$1, %r13d
	jle	.L108
.L84:
	movslq	48(%rsp), %rbp
	call	get_n@PLT
	movq	%rbp, %rsi
	imulq	%rax, %rsi
	leaq	.LC6(%rip), %rdi
	call	nano@PLT
	movq	stderr(%rip), %rcx
	movl	$23, %edx
	movl	$1, %esi
	leaq	.LC7(%rip), %rdi
	call	fwrite@PLT
	call	get_n@PLT
	imulq	%rbx, %rax
	movq	%rax, %rdi
	salq	$4, %rdi
	call	mb@PLT
.L83:
	leaq	16(%rsp), %rax
	pushq	%rax
	.cfi_def_cfa_offset 136
	pushq	%r15
	.cfi_def_cfa_offset 144
	movl	%r14d, %r9d
	movl	%r13d, %r8d
	movl	$0, %ecx
	leaq	cleanup(%rip), %rdx
	leaq	scale(%rip), %rsi
	leaq	initialize(%rip), %rdi
	call	benchmp@PLT
	call	usecs_spent@PLT
	addq	$16, %rsp
	.cfi_def_cfa_offset 128
	testq	%rax, %rax
	je	.L85
	cmpl	$1, %r13d
	jle	.L109
.L86:
	movslq	48(%rsp), %rbp
	call	get_n@PLT
	movq	%rbp, %rsi
	imulq	%rax, %rsi
	leaq	.LC8(%rip), %rdi
	call	nano@PLT
	movq	stderr(%rip), %rcx
	movl	$24, %edx
	movl	$1, %esi
	leaq	.LC9(%rip), %rdi
	call	fwrite@PLT
	call	get_n@PLT
	imulq	%rbx, %rax
	movq	%rax, %rdi
	salq	$4, %rdi
	call	mb@PLT
.L85:
	leaq	16(%rsp), %rax
	pushq	%rax
	.cfi_def_cfa_offset 136
	pushq	%r15
	.cfi_def_cfa_offset 144
	movl	%r14d, %r9d
	movl	%r13d, %r8d
	movl	$0, %ecx
	leaq	cleanup(%rip), %rdx
	leaq	add(%rip), %rsi
	leaq	initialize(%rip), %rdi
	call	benchmp@PLT
	call	usecs_spent@PLT
	addq	$16, %rsp
	.cfi_def_cfa_offset 128
	testq	%rax, %rax
	je	.L87
	cmpl	$1, %r13d
	jle	.L110
.L88:
	movslq	48(%rsp), %rbp
	call	get_n@PLT
	movq	%rbp, %rsi
	imulq	%rax, %rsi
	leaq	.LC10(%rip), %rdi
	call	nano@PLT
	movq	stderr(%rip), %rcx
	movl	$22, %edx
	movl	$1, %esi
	leaq	.LC11(%rip), %rdi
	call	fwrite@PLT
	call	get_n@PLT
	imulq	%rbx, %rax
	imulq	$24, %rax, %rdi
	call	mb@PLT
.L87:
	leaq	16(%rsp), %rax
	pushq	%rax
	.cfi_def_cfa_offset 136
	pushq	%r15
	.cfi_def_cfa_offset 144
	movl	%r14d, %r9d
	movl	%r13d, %r8d
	movl	$0, %ecx
	leaq	cleanup(%rip), %rdx
	leaq	triad(%rip), %rsi
	leaq	initialize(%rip), %rdi
	call	benchmp@PLT
	call	usecs_spent@PLT
	addq	$16, %rsp
	.cfi_def_cfa_offset 128
	testq	%rax, %rax
	je	.L89
	cmpl	$1, %r13d
	jle	.L111
.L90:
	movslq	48(%rsp), %rbp
	call	get_n@PLT
	movq	%rbp, %rsi
	imulq	%rax, %rsi
	leaq	.LC12(%rip), %rdi
	call	nano@PLT
	movq	stderr(%rip), %rcx
	movl	$24, %edx
	movl	$1, %esi
	leaq	.LC13(%rip), %rdi
	call	fwrite@PLT
	call	get_n@PLT
	imulq	%rbx, %rax
	imulq	$24, %rax, %rdi
	call	mb@PLT
	jmp	.L89
.L108:
	movl	$0, %eax
	call	save_minimum@PLT
	jmp	.L84
.L109:
	movl	$0, %eax
	call	save_minimum@PLT
	jmp	.L86
.L110:
	movl	$0, %eax
	call	save_minimum@PLT
	jmp	.L88
.L111:
	movl	$0, %eax
	call	save_minimum@PLT
	jmp	.L90
.L103:
	movl	$0, %eax
	call	save_minimum@PLT
	jmp	.L92
.L104:
	movl	$0, %eax
	call	save_minimum@PLT
	jmp	.L94
.L105:
	movl	$0, %eax
	call	save_minimum@PLT
	jmp	.L96
.L106:
	movl	$0, %eax
	call	save_minimum@PLT
	jmp	.L97
.L107:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE72:
	.size	main, .-main
	.globl	id
	.section	.rodata.str1.1
.LC22:
	.string	"$Id$\n"
	.section	.data.rel.local,"aw"
	.align 8
	.type	id, @object
	.size	id, 8
id:
	.quad	.LC22
	.section	.rodata.cst8,"aM",@progbits,8
	.align 8
.LC1:
	.long	0
	.long	1072693248
	.align 8
.LC2:
	.long	0
	.long	1073741824
	.align 8
.LC3:
	.long	0
	.long	1074266112
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
