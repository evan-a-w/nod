	.file	"cache.c"
	.text
	.globl	mem_benchmark
	.type	mem_benchmark, @function
mem_benchmark:
.LFB72:
	.cfi_startproc
	endbr64
	movq	addr_save(%rip), %rdx
	testq	%rdx, %rdx
	je	.L6
.L2:
	leaq	-1(%rdi), %rax
	testq	%rdi, %rdi
	je	.L3
.L4:
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	subq	$1, %rax
	cmpq	$-1, %rax
	jne	.L4
.L3:
	movq	%rdx, addr_save(%rip)
	ret
.L6:
	movq	16(%rsi), %rdx
	jmp	.L2
	.cfi_endproc
.LFE72:
	.size	mem_benchmark, .-mem_benchmark
	.globl	find_cache
	.type	find_cache, @function
find_cache:
.LFB74:
	.cfi_startproc
	endbr64
	movl	%edi, %ecx
	movl	%esi, %r8d
	movq	%rdx, %r10
	cmpl	$1, %edi
	jle	.L8
	movslq	%edi, %rax
	leaq	0(,%rax,8), %rdx
	subq	%rax, %rdx
	salq	$3, %rdx
	leaq	(%r10,%rdx), %rax
	leaq	-56(%r10,%rdx), %rdx
	leal	-2(%rdi), %edi
	leaq	0(,%rdi,8), %rsi
	subq	%rdi, %rsi
	salq	$3, %rsi
	subq	%rsi, %rdx
	pxor	%xmm1, %xmm1
.L13:
	movsd	-16(%rax), %xmm0
	comisd	%xmm1, %xmm0
	ja	.L8
	subq	$56, %rax
	cmpq	%rdx, %rax
	jne	.L13
.L8:
	movl	$-1, %edx
	cmpl	%r8d, %ecx
	jge	.L7
	movslq	%ecx, %rdx
	leaq	0(,%rdx,8), %rax
	subq	%rdx, %rax
	leaq	(%r10,%rax,8), %rax
	movsd	.LC0(%rip), %xmm1
	movl	$-1, %edx
	pxor	%xmm2, %xmm2
	movsd	.LC2(%rip), %xmm5
	movapd	%xmm5, %xmm3
	movapd	%xmm5, %xmm4
	jmp	.L18
.L26:
	movl	$-1, %edx
.L7:
	movl	%edx, %eax
	ret
.L15:
	movapd	%xmm0, %xmm1
	comisd	%xmm5, %xmm0
	jbe	.L16
	movapd	%xmm0, %xmm1
	movl	%ecx, %edx
.L19:
	movslq	%edx, %r9
	leaq	0(,%r9,8), %rsi
	subq	%r9, %rsi
	movq	(%r10,%rsi,8), %rsi
	addq	%rsi, %rsi
	cmpq	(%rdi), %rsi
	jbe	.L7
.L14:
	addl	$1, %ecx
	addq	$56, %rax
	cmpl	%ecx, %r8d
	je	.L26
.L18:
	movq	%rax, %rdi
	comisd	24(%rax), %xmm2
	ja	.L14
	movsd	40(%rax), %xmm0
	comisd	%xmm1, %xmm0
	ja	.L15
	ucomisd	%xmm4, %xmm0
	cmova	%ecx, %edx
.L16:
	comisd	%xmm3, %xmm1
	jbe	.L14
	jmp	.L19
	.cfi_endproc
.LFE74:
	.size	find_cache, .-find_cache
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC3:
	.string	"malloc"
	.text
	.globl	measure
	.type	measure, @function
measure:
.LFB78:
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
	subq	$88, %rsp
	.cfi_def_cfa_offset 144
	movq	%rdi, %r13
	movl	%esi, %r14d
	movq	%rdx, 56(%rsp)
	movq	%rcx, %rbx
	movq	208(%rcx), %r15
	call	getpagesize@PLT
	movslq	%eax, %rcx
	leaq	-1(%rcx,%r13), %rax
	movl	$0, %edx
	divq	%rcx
	movq	%rax, 40(%rsp)
	movq	184(%rbx), %rax
	movq	%rax, 32(%rsp)
	movq	%r13, %rax
	movl	$0, %edx
	divq	%rcx
	testq	%rdx, %rdx
	je	.L28
	movq	%rdx, %rax
	movl	$0, %edx
	divq	168(%rbx)
	movq	%rax, 32(%rsp)
.L28:
	movl	$0, %eax
	call	get_results@PLT
	movq	%rax, 48(%rsp)
	movl	%r14d, %edi
	call	sizeof_result@PLT
	movslq	%eax, %rdi
	call	malloc@PLT
	movq	%rax, 24(%rsp)
	testq	%rax, %rax
	je	.L98
	movq	24(%rsp), %rdi
	call	insertinit@PLT
	movq	8(%rbx), %rbp
	movq	40(%rsp), %r8
	subq	$1, %r8
	je	.L30
	movq	%r15, %rsi
	movl	$0, %edi
	jmp	.L31
.L98:
	leaq	.LC3(%rip), %rdi
	call	perror@PLT
	movl	$3, %edi
	call	exit@PLT
.L32:
	movq	216(%rbx), %rax
	movq	224(%rbx), %rdx
	movq	(%rdx,%rcx,8), %r9
	movq	184(%rbx), %r10
	leaq	0(%rbp,%r9), %rdx
	addq	-8(%rax,%r10,8), %rdx
	addq	(%rsi), %rdx
	movq	(%rax), %rax
	addq	8(%rsi), %rax
	addq	%r9, %rax
	addq	%rbp, %rax
	movq	%rax, (%rdx)
	addq	$1, %rcx
	cmpq	%rcx, 200(%rbx)
	ja	.L32
.L33:
	addq	$1, %rdi
	addq	$8, %rsi
	cmpq	%r8, %rdi
	je	.L30
.L31:
	movl	$0, %ecx
	cmpq	$0, 200(%rbx)
	jne	.L32
	jmp	.L33
.L30:
	movq	200(%rbx), %rdi
	testq	%rdi, %rdi
	je	.L34
	movq	40(%rsp), %rax
	leaq	-8(%r15,%rax,8), %r12
	movq	32(%rsp), %rax
	leaq	-8(,%rax,8), %r11
	movl	$0, %r8d
	movl	$0, %esi
.L35:
	movq	216(%rbx), %r10
	movq	224(%rbx), %r9
	addq	$1, %rsi
	movq	%rbp, %rcx
	addq	(%r10,%r11), %rcx
	addq	(%r12), %rcx
	addq	(%r9,%r8), %rcx
	movq	%rsi, %rax
	movl	$0, %edx
	divq	%rdi
	movq	(%r10), %rax
	addq	(%r15), %rax
	addq	(%r9,%rdx,8), %rax
	addq	%rbp, %rax
	movq	%rax, (%rcx)
	movq	200(%rbx), %rdi
	addq	$8, %r8
	cmpq	%rdi, %rsi
	jb	.L35
.L34:
	movq	$0, addr_save(%rip)
	movq	216(%rbx), %rdx
	movq	(%r15), %rax
	addq	(%rdx), %rax
	movq	224(%rbx), %rdx
	addq	(%rdx), %rax
	addq	%rbp, %rax
	movq	%rax, 16(%rbx)
	shrq	$3, %r13
	leaq	100(%r13), %rdx
	shrq	$2, %rdx
	movabsq	$2951479051793528259, %rcx
	movq	%rdx, %rax
	mulq	%rcx
	movq	%rdx, %rdi
	shrq	$2, %rdi
	movq	%rbx, %rsi
	call	mem_benchmark
	movslq	%r14d, %rax
	testq	%rax, %rax
	je	.L36
	movl	$0, %r14d
	movq	%r15, 64(%rsp)
	movq	%rbp, 72(%rsp)
	movq	24(%rsp), %rbp
	movq	%rax, %r15
	jmp	.L64
.L99:
	movq	%rbx, %rsi
	call	mem_benchmark
	jmp	.L39
.L40:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
	movsd	%xmm0, 8(%rsp)
	jmp	.L41
.L47:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rdx, %xmm1
	addsd	%xmm1, %xmm1
	jmp	.L48
.L49:
	subsd	.LC10(%rip), %xmm0
	cvttsd2siq	%xmm0, %rax
	movq	%rax, __iterations.1(%rip)
	btcq	$63, __iterations.1(%rip)
	jmp	.L43
.L93:
	movq	__iterations.1(%rip), %rax
	cmpq	$134217728, %rax
	ja	.L79
	salq	$3, %rax
	movq	%rax, __iterations.1(%rip)
.L43:
	movq	%r12, %xmm4
	comisd	8(%rsp), %xmm4
	jbe	.L37
.L51:
	movl	$0, %edi
	call	start@PLT
	movq	__iterations.1(%rip), %rdi
	testq	%rdi, %rdi
	jne	.L99
.L39:
	movl	$0, %esi
	movl	$0, %edi
	call	stop@PLT
	testq	%rax, %rax
	js	.L40
	pxor	%xmm7, %xmm7
	cvtsi2sdq	%rax, %xmm7
	movsd	%xmm7, 8(%rsp)
.L41:
	movsd	.LC5(%rip), %xmm0
	movsd	16(%rsp), %xmm2
	mulsd	%xmm2, %xmm0
	movsd	8(%rsp), %xmm3
	comisd	%xmm3, %xmm0
	ja	.L42
	mulsd	.LC6(%rip), %xmm2
	comisd	%xmm2, %xmm3
	jbe	.L43
.L42:
	movsd	8(%rsp), %xmm6
	comisd	.LC7(%rip), %xmm6
	jbe	.L93
	movq	__iterations.1(%rip), %rax
	testq	%rax, %rax
	js	.L47
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rax, %xmm1
.L48:
	divsd	8(%rsp), %xmm1
	movsd	16(%rsp), %xmm0
	mulsd	.LC8(%rip), %xmm0
	mulsd	%xmm1, %xmm0
	addsd	.LC9(%rip), %xmm0
	comisd	.LC10(%rip), %xmm0
	jnb	.L49
	cvttsd2siq	%xmm0, %rax
	movq	%rax, __iterations.1(%rip)
	jmp	.L43
.L79:
	pxor	%xmm7, %xmm7
	movsd	%xmm7, 8(%rsp)
.L37:
	movq	__iterations.1(%rip), %rdi
	call	save_n@PLT
	movsd	8(%rsp), %xmm4
	comisd	.LC10(%rip), %xmm4
	jnb	.L52
	cvttsd2siq	%xmm4, %rdi
.L53:
	call	settime@PLT
	call	usecs_spent@PLT
	testq	%rax, %rax
	js	.L54
	pxor	%xmm5, %xmm5
	cvtsi2sdq	%rax, %xmm5
	movsd	%xmm5, 8(%rsp)
.L55:
	call	t_overhead@PLT
	movq	%rax, %r12
	call	get_n@PLT
	movq	%rax, %r13
	call	l_overhead@PLT
	movapd	%xmm0, %xmm1
	testq	%r13, %r13
	js	.L56
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%r13, %xmm0
.L57:
	mulsd	%xmm1, %xmm0
	testq	%r12, %r12
	js	.L58
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%r12, %xmm1
.L59:
	addsd	%xmm1, %xmm0
	movsd	8(%rsp), %xmm1
	subsd	%xmm0, %xmm1
	movl	$0, %edi
	comisd	.LC1(%rip), %xmm1
	jb	.L60
	comisd	.LC10(%rip), %xmm1
	jnb	.L62
	cvttsd2siq	%xmm1, %rdi
.L60:
	call	settime@PLT
	call	get_n@PLT
	movq	%rax, %r12
	call	usecs_spent@PLT
	movq	%rax, %rdi
	movq	%rbp, %rdx
	movq	%r12, %rsi
	call	insertsort@PLT
	addq	$1, %r14
	cmpq	%r15, %r14
	je	.L100
.L64:
	movl	$0, %edi
	call	get_enough@PLT
	pxor	%xmm6, %xmm6
	cvtsi2sdl	%eax, %xmm6
	movsd	%xmm6, 16(%rsp)
	movsd	.LC4(%rip), %xmm7
	mulsd	%xmm6, %xmm7
	movq	%xmm7, %r12
	pxor	%xmm6, %xmm6
	comisd	%xmm6, %xmm7
	ja	.L51
	pxor	%xmm6, %xmm6
	movsd	%xmm6, 8(%rsp)
	jmp	.L37
.L52:
	movsd	8(%rsp), %xmm0
	subsd	.LC10(%rip), %xmm0
	cvttsd2siq	%xmm0, %rdi
	btcq	$63, %rdi
	jmp	.L53
.L54:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
	movsd	%xmm0, 8(%rsp)
	jmp	.L55
.L56:
	movq	%r13, %rax
	shrq	%rax
	andl	$1, %r13d
	orq	%r13, %rax
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	addsd	%xmm0, %xmm0
	jmp	.L57
.L58:
	movq	%r12, %rax
	shrq	%rax
	andl	$1, %r12d
	orq	%r12, %rax
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rax, %xmm1
	addsd	%xmm1, %xmm1
	jmp	.L59
.L62:
	subsd	.LC10(%rip), %xmm1
	cvttsd2siq	%xmm1, %rdi
	btcq	$63, %rdi
	jmp	.L60
.L100:
	movq	64(%rsp), %r15
	movq	72(%rsp), %rbp
.L36:
	movq	24(%rsp), %rdi
	call	set_results@PLT
	call	usecs_spent@PLT
	movq	%rax, %r12
	call	get_n@PLT
	testq	%r12, %r12
	js	.L65
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%r12, %xmm1
.L66:
	mulsd	.LC11(%rip), %xmm1
	testq	%rax, %rax
	js	.L67
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
.L68:
	mulsd	.LC12(%rip), %xmm0
	divsd	%xmm0, %xmm1
	movq	%xmm1, %r13
	movl	$0, %eax
	call	save_minimum@PLT
	call	usecs_spent@PLT
	movq	%rax, %r12
	call	get_n@PLT
	testq	%r12, %r12
	js	.L69
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%r12, %xmm0
.L70:
	mulsd	.LC11(%rip), %xmm0
	testq	%rax, %rax
	js	.L71
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rax, %xmm1
.L72:
	mulsd	.LC12(%rip), %xmm1
	divsd	%xmm1, %xmm0
	ucomisd	.LC1(%rip), %xmm0
	jp	.L84
	movsd	.LC0(%rip), %xmm1
	jne	.L84
.L73:
	movq	56(%rsp), %rax
	movsd	%xmm1, (%rax)
	movq	48(%rsp), %rdi
	call	set_results@PLT
	movq	24(%rsp), %rdi
	call	free@PLT
	movq	32(%rsp), %rax
	cmpq	%rax, 184(%rbx)
	jbe	.L27
	cmpq	$0, 200(%rbx)
	je	.L27
	movq	40(%rsp), %rcx
	leaq	-8(%r15,%rcx,8), %r8
	salq	$3, %rax
	movq	%rax, %rdi
	leaq	-8(%rax), %r9
	movl	$0, %ecx
.L76:
	movq	(%r8), %rax
	movq	216(%rbx), %r10
	movq	224(%rbx), %rdx
	movq	(%rdx,%rcx,8), %rsi
	leaq	0(%rbp,%rax), %rdx
	addq	%rsi, %rdx
	addq	(%r10,%r9), %rdx
	addq	(%r10,%rdi), %rax
	addq	%rsi, %rax
	addq	%rbp, %rax
	movq	%rax, (%rdx)
	addq	$1, %rcx
	cmpq	%rcx, 200(%rbx)
	ja	.L76
.L27:
	movq	%r13, %xmm0
	addq	$88, %rsp
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
.L65:
	.cfi_restore_state
	movq	%r12, %rdx
	shrq	%rdx
	andl	$1, %r12d
	orq	%r12, %rdx
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rdx, %xmm1
	addsd	%xmm1, %xmm1
	jmp	.L66
.L67:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
	jmp	.L68
.L69:
	movq	%r12, %rdx
	shrq	%rdx
	andl	$1, %r12d
	orq	%r12, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
	jmp	.L70
.L71:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rdx, %xmm1
	addsd	%xmm1, %xmm1
	jmp	.L72
.L84:
	movq	%r13, %xmm1
	divsd	%xmm0, %xmm1
	jmp	.L73
	.cfi_endproc
.LFE78:
	.size	measure, .-measure
	.globl	remove_chunk
	.type	remove_chunk, @function
remove_chunk:
.LFB79:
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
	movq	%rsi, %r14
	movq	%rdx, %rax
	movq	%r8, %r13
	movl	%r9d, 12(%rsp)
	movq	96(%rsp), %r15
	movq	%fs:40, %rdx
	movq	%rdx, 24(%rsp)
	xorl	%edx, %edx
	leaq	(%rdi,%rsi), %rdx
	cmpq	%rax, %rdx
	jnb	.L102
	testq	%rsi, %rsi
	je	.L103
	leaq	(%rcx,%rdi,8), %rbx
	leaq	-8(%rcx,%rax,8), %rbp
	leaq	(%rcx,%rdx,8), %r12
	movq	%rbp, %rdx
	movq	%rbx, %rax
.L104:
	movq	(%rax), %rcx
	movq	(%rdx), %rsi
	movq	%rsi, (%rax)
	movq	%rcx, (%rdx)
	addq	$8, %rax
	subq	$8, %rdx
	cmpq	%r12, %rax
	jne	.L104
	call	getpagesize@PLT
	leaq	16(%rsp), %rdx
	cltq
	imulq	%r14, %rax
	movq	%r13, %rdi
	subq	%rax, %rdi
	movq	%r15, %rcx
	movl	12(%rsp), %esi
	call	measure
.L106:
	movq	(%rbx), %rax
	movq	0(%rbp), %rdx
	movq	%rdx, (%rbx)
	movq	%rax, 0(%rbp)
	addq	$8, %rbx
	subq	$8, %rbp
	cmpq	%r12, %rbx
	jne	.L106
	jmp	.L101
.L102:
	call	getpagesize@PLT
	leaq	16(%rsp), %rdx
	cltq
	imulq	%r14, %rax
	movq	%r13, %rdi
	subq	%rax, %rdi
	movq	%r15, %rcx
	movl	12(%rsp), %esi
	call	measure
.L101:
	movq	24(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L113
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
.L103:
	.cfi_restore_state
	leaq	16(%rsp), %rdx
	movq	%r15, %rcx
	movl	12(%rsp), %esi
	movq	%r8, %rdi
	call	measure
	jmp	.L101
.L113:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE79:
	.size	remove_chunk, .-remove_chunk
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC13:
	.string	"check_memory: bad memory reference for size %lu\n"
	.align 8
.LC14:
	.string	"check_memory: unwanted memory cycle! page=%lu\n"
	.align 8
.LC15:
	.string	"check_memory: wrong word count, expected %lu, got %lu\n"
	.text
	.globl	check_memory
	.type	check_memory, @function
check_memory:
.LFB82:
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
	movq	%rdi, %rbx
	movq	%rdi, 24(%rsp)
	movq	%rsi, %r14
	call	getpagesize@PLT
	movslq	%eax, %rsi
	movq	%rsi, 8(%rsp)
	leaq	-1(%rsi,%rbx), %rax
	movl	$0, %edx
	divq	%rsi
	movq	%rax, %rbx
	movq	%rax, 16(%rsp)
	movq	208(%r14), %rdx
	movq	216(%r14), %rax
	movq	(%rax), %rax
	addq	(%rdx), %rax
	movq	224(%r14), %rdx
	addq	(%rdx), %rax
	addq	8(%r14), %rax
	movq	%rax, (%rsp)
	movq	(%rax), %rbp
	movq	%rbp, %r15
	movl	$1, %r13d
	movl	$0, %r12d
	jmp	.L115
.L126:
	movq	%r12, %rcx
.L116:
	cmpq	%rcx, %rbx
	je	.L118
.L119:
	movq	%rcx, %rax
	movl	$0, %edx
	divq	16(%rsp)
	movq	%rdx, %r12
	movq	0(%rbp), %rbp
	testb	$1, %r13b
	je	.L123
	movq	(%r15), %r15
.L123:
	movq	(%r15), %rax
	cmpq	%rax, 0(%rbp)
	je	.L132
.L115:
	cmpq	(%rsp), %rbp
	je	.L133
	addq	$1, %r13
	movq	%rbp, %rcx
	subq	8(%r14), %rcx
	movq	%rcx, %rax
	movl	$0, %edx
	divq	8(%rsp)
	movq	%rcx, %rax
	subq	%rdx, %rax
	cmpq	%rbx, %r12
	jnb	.L126
	movq	208(%r14), %rdx
	movq	%r12, %rcx
.L117:
	cmpq	%rax, (%rdx,%rcx,8)
	je	.L116
	addq	$1, %rcx
	cmpq	%rcx, %rbx
	jne	.L117
.L118:
	testq	%r12, %r12
	je	.L120
	movq	208(%r14), %rdx
	movl	$0, %ecx
.L122:
	cmpq	%rax, (%rdx,%rcx,8)
	je	.L121
	addq	$1, %rcx
	cmpq	%rcx, %r12
	jne	.L122
.L120:
	movq	24(%rsp), %rcx
	leaq	.LC13(%rip), %rdx
	movl	$1, %esi
	movq	stderr(%rip), %rdi
	movl	$0, %eax
	call	__fprintf_chk@PLT
	movq	%r12, %rcx
	jmp	.L119
.L121:
	cmpq	%rcx, %r12
	jne	.L119
	movq	%rcx, %r12
	jmp	.L120
.L132:
	leaq	.LC14(%rip), %rdx
	movl	$1, %esi
	movq	stderr(%rip), %rdi
	movl	$0, %eax
	call	__fprintf_chk@PLT
.L114:
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
.L133:
	.cfi_restore_state
	movq	24(%rsp), %rcx
	shrq	$3, %rcx
	cmpq	%rcx, %r13
	je	.L114
	movq	%r13, %r8
	leaq	.LC15(%rip), %rdx
	movl	$1, %esi
	movq	stderr(%rip), %rdi
	movl	$0, %eax
	call	__fprintf_chk@PLT
	jmp	.L114
	.cfi_endproc
.LFE82:
	.size	check_memory, .-check_memory
	.globl	pagesort
	.type	pagesort, @function
pagesort:
.LFB83:
	.cfi_startproc
	endbr64
	cmpq	$1, %rdi
	je	.L145
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movq	%rdi, %r10
	movq	%rdx, %rcx
	movq	%rsi, %rdi
	leaq	0(,%r10,8), %r8
	movl	$1, %ebx
	jmp	.L140
.L137:
	addq	$8, %rax
	cmpq	%r8, %rax
	je	.L136
.L139:
	movsd	(%rcx), %xmm0
	movsd	(%rdx,%rax), %xmm1
	comisd	%xmm1, %xmm0
	jbe	.L137
	movsd	%xmm1, (%rcx)
	movsd	%xmm0, (%rdx,%rax)
	movq	(%rdi), %r9
	movq	(%rsi,%rax), %r11
	movq	%r11, (%rdi)
	movq	%r9, (%rsi,%rax)
	jmp	.L137
.L136:
	addq	$1, %rbx
	addq	$8, %rcx
	addq	$8, %rdi
	cmpq	%rbx, %r10
	je	.L148
.L140:
	cmpq	%rbx, %r10
	jbe	.L136
	movslq	%ebx, %rax
	salq	$3, %rax
	jmp	.L139
.L148:
	popq	%rbx
	.cfi_def_cfa_offset 8
	ret
.L145:
	.cfi_restore 3
	ret
	.cfi_endproc
.LFE83:
	.size	pagesort, .-pagesort
	.globl	fixup_chunk
	.type	fixup_chunk, @function
fixup_chunk:
.LFB81:
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
	subq	$344, %rsp
	.cfi_def_cfa_offset 400
	movq	%rdi, 112(%rsp)
	movq	%rsi, %r15
	movq	%rdx, %rbp
	movq	%rdx, 32(%rsp)
	movq	%rcx, 16(%rsp)
	movq	%r8, 88(%rsp)
	movq	%r9, 120(%rsp)
	movsd	%xmm0, 8(%rsp)
	movq	408(%rsp), %rbx
	movq	%rbx, (%rsp)
	movq	%fs:40, %rax
	movq	%rax, 328(%rsp)
	xorl	%eax, %eax
	call	getpagesize@PLT
	movslq	%eax, %rdi
	movq	%rdi, 24(%rsp)
	movq	%rbx, %rcx
	movq	160(%rbx), %rax
	leaq	-1(%rdi,%rax), %rax
	movl	$0, %edx
	divq	%rdi
	movq	%rax, %rbx
	movq	%rax, %r14
	subq	%rbp, %r14
	movq	208(%rcx), %rax
	movq	%rax, 64(%rsp)
	leaq	0(,%rbp,8), %rax
	movq	%rax, 40(%rsp)
	leaq	0(,%rbx,8), %rdi
	call	malloc@PLT
	movq	%rax, 104(%rsp)
	testq	%rax, %rax
	je	.L190
	leaq	0(,%rbx,4), %rax
	movq	%rax, 136(%rsp)
	movq	%rax, %rdx
	movq	16(%rsp), %rbx
	movq	%rbx, %rsi
	movq	104(%rsp), %rdi
	call	memcpy@PLT
	movq	112(%rsp), %rdi
	leaq	(%rdi,%r15), %rax
	movq	%rax, 128(%rsp)
	movq	32(%rsp), %rcx
	cmpq	%rcx, %rax
	jnb	.L151
	testq	%r15, %r15
	je	.L151
	leaq	(%rbx,%rdi,8), %rdx
	movq	%rcx, %rax
	subq	%r15, %rax
	leaq	(%rbx,%rax,8), %rax
	addq	40(%rsp), %rbx
	movq	%rbx, %rdi
.L152:
	movq	(%rdx), %rcx
	movq	(%rax), %rsi
	movq	%rsi, (%rdx)
	movq	%rcx, (%rax)
	addq	$8, %rdx
	addq	$8, %rax
	cmpq	%rdi, %rax
	jne	.L152
	cmpq	%r14, available_index.0(%rip)
	jnb	.L173
	jmp	.L174
.L190:
	leaq	.LC3(%rip), %rdi
	call	perror@PLT
	movl	$4, %edi
	call	exit@PLT
.L151:
	cmpq	%r14, available_index.0(%rip)
	jb	.L154
.L173:
	movq	$0, available_index.0(%rip)
.L154:
	testq	%r15, %r15
	je	.L155
.L174:
	movq	%r15, %r12
	movl	$0, %ebx
	movq	%r14, 56(%rsp)
	movq	24(%rsp), %r14
	movq	%r15, 48(%rsp)
	movq	16(%rsp), %r15
	jmp	.L159
.L185:
	subq	$1, %r12
	movsd	%xmm0, 160(%rsp,%r12,8)
	leaq	(%r15,%r13,8), %rdx
	movq	(%rdx), %rcx
	addq	%r12, %rbp
	leaq	(%r15,%rbp,8), %rax
	movq	(%rax), %rsi
	movq	%rsi, (%rdx)
	movq	%rcx, (%rax)
.L158:
	cmpq	%r12, %rbx
	jnb	.L191
.L159:
	movq	32(%rsp), %rbp
	subq	48(%rsp), %rbp
	leaq	0(%rbp,%rbx), %r13
	leaq	152(%rsp), %rdx
	leaq	1(%r13), %rdi
	imulq	%r14, %rdi
	movq	(%rsp), %rcx
	movl	400(%rsp), %esi
	call	measure
	movsd	.LC16(%rip), %xmm1
	mulsd	%xmm0, %xmm1
	movsd	8(%rsp), %xmm3
	comisd	%xmm1, %xmm3
	jb	.L185
	movsd	%xmm0, 160(%rsp,%rbx,8)
	addq	$1, %rbx
	jmp	.L158
.L191:
	movq	56(%rsp), %r14
	movq	48(%rsp), %r15
	movq	32(%rsp), %rbp
	movq	%rbp, %rax
	subq	%r15, %rax
	movq	%rax, 56(%rsp)
	leaq	160(%rsp,%rbx,8), %rdx
	addq	%rbx, %rax
	movq	16(%rsp), %rcx
	leaq	(%rcx,%rax,8), %rsi
	movq	%r15, %rdi
	subq	%rbx, %rdi
	call	pagesort
	cmpq	%r15, %rbp
	ja	.L160
	movq	%r15, %rbp
	shrq	%rbp
	cmpq	%rbp, %rbx
	jb	.L192
.L160:
	cmpq	%r15, %rbx
	jnb	.L161
	movq	32(%rsp), %rax
	addq	%rax, %rax
	movq	%rax, 72(%rsp)
	je	.L161
	movl	$0, %r13d
	movl	$0, 84(%rsp)
	leaq	-1(%r14), %rax
	movq	%rax, 48(%rsp)
	movq	16(%rsp), %rax
	movq	40(%rsp), %rcx
	leaq	-8(%rax,%rcx), %rax
	movq	%rax, 96(%rsp)
	jmp	.L168
.L192:
	leaq	152(%rsp), %rdx
	movq	56(%rsp), %rax
	leaq	1(%rax,%rbp), %rdi
	imulq	24(%rsp), %rdi
	movq	(%rsp), %rcx
	movl	400(%rsp), %esi
	call	measure
	movsd	%xmm0, 8(%rsp)
	movq	%rbp, %rbx
	jmp	.L160
.L194:
	movq	88(%rsp), %rax
	movl	$0, %edx
	divq	24(%rsp)
	testq	%rdx, %rdx
	cmovne	88(%rsp), %rdi
	jmp	.L162
.L195:
	movsd	%xmm0, 160(%rsp,%r14,8)
	movq	96(%rsp), %rcx
	movq	(%rcx), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 0(%rbp)
	leaq	160(%rsp,%rbx,8), %rdx
	movq	%r15, %rdi
	subq	%rbx, %rdi
	movq	%r12, %rsi
	call	pagesort
	jmp	.L163
.L165:
	addq	$1, %r13
	cmpq	%r15, %rbx
	jnb	.L167
	cmpq	72(%rsp), %r13
	je	.L193
.L168:
	movq	56(%rsp), %rax
	leaq	(%rax,%rbx), %rcx
	movq	%r13, %rax
	addq	available_index.0(%rip), %rax
	movq	48(%rsp), %rsi
	movl	$0, %edx
	divq	%rsi
	subq	%rdx, %rsi
	leaq	1(%rcx), %rdi
	imulq	24(%rsp), %rdi
	leaq	-1(%r15), %r14
	cmpq	%rbx, %r14
	je	.L194
.L162:
	movq	16(%rsp), %rax
	leaq	(%rax,%rcx,8), %r12
	movq	(%r12), %rax
	movq	40(%rsp), %rcx
	leaq	(%rcx,%rsi,8), %rbp
	addq	64(%rsp), %rbp
	movq	0(%rbp), %rdx
	movq	%rdx, (%r12)
	movq	%rax, 0(%rbp)
	leaq	152(%rsp), %rdx
	movq	(%rsp), %rcx
	movl	400(%rsp), %esi
	call	measure
	movq	(%r12), %rax
	movq	0(%rbp), %rdx
	movq	%rdx, (%r12)
	movq	%rax, 0(%rbp)
	movsd	160(%rsp,%r14,8), %xmm1
	comisd	%xmm0, %xmm1
	ja	.L195
.L163:
	movsd	.LC16(%rip), %xmm0
	mulsd	160(%rsp,%rbx,8), %xmm0
	movsd	8(%rsp), %xmm2
	comisd	%xmm0, %xmm2
	jb	.L165
	addq	$1, %rbx
	addl	$1, 84(%rsp)
	jmp	.L165
.L193:
	movq	72(%rsp), %r13
.L167:
	movq	%r13, %rax
	addq	available_index.0(%rip), %rax
	movl	$0, %edx
	divq	48(%rsp)
	movq	%rdx, available_index.0(%rip)
	cmpl	$0, 84(%rsp)
	jne	.L196
.L169:
	movq	104(%rsp), %rdi
	call	free@PLT
	movq	328(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L197
	movl	84(%rsp), %eax
	addq	$344, %rsp
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
.L196:
	.cfi_restore_state
	leaq	152(%rsp), %rdx
	movq	(%rsp), %rcx
	movl	400(%rsp), %esi
	movq	88(%rsp), %rdi
	call	measure
	movsd	.LC17(%rip), %xmm1
	movq	120(%rsp), %rax
	mulsd	(%rax), %xmm1
	comisd	%xmm1, %xmm0
	jnb	.L198
	movq	120(%rsp), %rax
	movsd	%xmm0, (%rax)
	movq	128(%rsp), %rbx
	movq	32(%rsp), %rax
	cmpq	%rax, %rbx
	jnb	.L169
	testq	%r15, %r15
	je	.L169
	movq	16(%rsp), %rcx
	movq	112(%rsp), %rsi
	leaq	(%rcx,%rsi,8), %rax
	leaq	(%rcx,%rbx,8), %rdi
	movq	56(%rsp), %rdx
	subq	%rsi, %rdx
.L172:
	movq	(%rax), %rcx
	movq	(%rax,%rdx,8), %rsi
	movq	%rsi, (%rax)
	movq	%rcx, (%rax,%rdx,8)
	addq	$8, %rax
	cmpq	%rdi, %rax
	jne	.L172
	jmp	.L169
.L198:
	movq	136(%rsp), %rdx
	movq	104(%rsp), %rsi
	movq	16(%rsp), %rdi
	call	memcpy@PLT
	movl	$0, 84(%rsp)
	jmp	.L169
.L161:
	leaq	-1(%r14), %rcx
	movq	available_index.0(%rip), %rax
	movl	$0, %edx
	divq	%rcx
	movq	%rdx, available_index.0(%rip)
	movl	$0, 84(%rsp)
	jmp	.L169
.L155:
	movq	32(%rsp), %rax
	subq	%r15, %rax
	movq	%rax, 56(%rsp)
	leaq	160(%rsp), %rdx
	movq	16(%rsp), %rbx
	leaq	(%rbx,%rax,8), %rsi
	movq	%r15, %rdi
	call	pagesort
	movq	%r15, %rbx
	jmp	.L160
.L197:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE81:
	.size	fixup_chunk, .-fixup_chunk
	.globl	test_chunk
	.type	test_chunk, @function
test_chunk:
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
	subq	$56, %rsp
	.cfi_def_cfa_offset 112
	movq	%rdi, %rbx
	movq	%rdx, %r15
	movq	%rcx, %r12
	movq	%r8, 8(%rsp)
	movq	%r9, %r14
	cmpq	$20, %rsi
	ja	.L200
	cmpq	%rdx, %rsi
	jb	.L212
.L200:
	leaq	19(%rsi), %rdx
	movabsq	$-3689348814741910323, %rcx
	movq	%rdx, %rax
	mulq	%rcx
	shrq	$4, %rdx
	movq	%rdx, %rbp
	leaq	(%rsi,%rbx), %r13
	movl	$0, 28(%rsp)
	cmpq	%r13, %rbx
	jnb	.L199
	movsd	(%r14), %xmm4
	movsd	%xmm4, 32(%rsp)
	movq	%r12, 16(%rsp)
	movq	120(%rsp), %r12
	jmp	.L206
.L212:
	pushq	120(%rsp)
	.cfi_def_cfa_offset 120
	movl	120(%rsp), %eax
	pushq	%rax
	.cfi_def_cfa_offset 128
	movq	24(%rsp), %r8
	call	fixup_chunk
	movl	%eax, 44(%rsp)
	addq	$16, %rsp
	.cfi_def_cfa_offset 112
.L199:
	movl	28(%rsp), %eax
	addq	$56, %rsp
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
.L208:
	.cfi_restore_state
	movl	$1, 28(%rsp)
.L203:
	addq	%rbp, %rbx
	cmpq	%r13, %rbx
	jnb	.L199
.L206:
	leaq	(%rbx,%rbp), %rdx
	movq	%r13, %rax
	subq	%rbx, %rax
	cmpq	%r13, %rdx
	cmova	%rax, %rbp
	subq	$8, %rsp
	.cfi_def_cfa_offset 120
	pushq	%r12
	.cfi_def_cfa_offset 128
	movl	128(%rsp), %r9d
	movq	24(%rsp), %r8
	movq	32(%rsp), %rcx
	movq	%r15, %rdx
	movq	%rbp, %rsi
	movq	%rbx, %rdi
	call	remove_chunk
	movsd	%xmm0, 16(%rsp)
	movsd	.LC5(%rip), %xmm0
	mulsd	(%r14), %xmm0
	addq	$16, %rsp
	.cfi_def_cfa_offset 112
	movsd	(%rsp), %xmm1
	comisd	%xmm0, %xmm1
	jnb	.L203
	movsd	32(%rsp), %xmm2
	mulsd	.LC17(%rip), %xmm2
	movsd	%xmm2, 40(%rsp)
	comisd	%xmm2, %xmm1
	jnb	.L203
	subq	$8, %rsp
	.cfi_def_cfa_offset 120
	pushq	%r12
	.cfi_def_cfa_offset 128
	movl	128(%rsp), %r9d
	movq	24(%rsp), %r8
	movq	32(%rsp), %rcx
	movq	%r15, %rdx
	movq	%rbp, %rsi
	movq	%rbx, %rdi
	call	remove_chunk
	addq	$16, %rsp
	.cfi_def_cfa_offset 112
	maxsd	(%rsp), %xmm0
	movapd	%xmm0, %xmm3
	movsd	%xmm0, (%rsp)
	movsd	(%r14), %xmm0
	mulsd	.LC5(%rip), %xmm0
	comisd	%xmm0, %xmm3
	jnb	.L203
	movapd	%xmm3, %xmm0
	comisd	40(%rsp), %xmm3
	jnb	.L203
	pushq	%r12
	.cfi_def_cfa_offset 120
	movl	120(%rsp), %eax
	pushq	%rax
	.cfi_def_cfa_offset 128
	movq	%r14, %r9
	movq	24(%rsp), %r8
	movq	32(%rsp), %rcx
	movq	%r15, %rdx
	movq	%rbp, %rsi
	movq	%rbx, %rdi
	call	test_chunk
	addq	$16, %rsp
	.cfi_def_cfa_offset 112
	testl	%eax, %eax
	jne	.L208
	movsd	(%rsp), %xmm5
	movsd	%xmm5, 32(%rsp)
	jmp	.L203
	.cfi_endproc
.LFE80:
	.size	test_chunk, .-test_chunk
	.globl	collect_sample
	.type	collect_sample, @function
collect_sample:
.LFB77:
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
	subq	$24, %rsp
	.cfi_def_cfa_offset 80
	movl	%edi, %r13d
	movq	%rsi, %rbp
	movq	%rdx, %r12
	movq	%fs:40, %rax
	movq	%rax, 8(%rsp)
	xorl	%eax, %eax
	movq	(%rdx), %r15
	call	getpagesize@PLT
	movslq	%eax, %rcx
	leaq	-1(%r15,%rcx), %rax
	movl	$0, %edx
	divq	%rcx
	movq	%rax, %rbx
	movl	%eax, %r14d
	leaq	32(%r12), %rdx
	movq	%rbp, %rcx
	movl	%r13d, %esi
	movq	%r15, %rdi
	call	measure
	movsd	%xmm0, (%rsp)
	cmpl	$1, %ebx
	jle	.L214
	movl	$0, %ebx
.L215:
	movslq	%r14d, %rsi
	movq	208(%rbp), %rcx
	pushq	%rbp
	.cfi_def_cfa_offset 88
	pushq	%r13
	.cfi_def_cfa_offset 96
	pxor	%xmm0, %xmm0
	leaq	16(%rsp), %r9
	movq	(%r12), %r8
	movq	%rsi, %rdx
	movl	$0, %edi
	call	test_chunk
	addl	$1, %ebx
	addq	$16, %rsp
	.cfi_def_cfa_offset 80
	cmpl	$7, %ebx
	jg	.L214
	testl	%eax, %eax
	jne	.L215
.L214:
	movsd	(%rsp), %xmm0
	movsd	%xmm0, 24(%r12)
	comisd	.LC1(%rip), %xmm0
	seta	%al
	movzbl	%al, %eax
	movq	8(%rsp), %rdx
	subq	%fs:40, %rdx
	jne	.L220
	addq	$24, %rsp
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
.L220:
	.cfi_restore_state
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE77:
	.size	collect_sample, .-collect_sample
	.globl	search
	.type	search, @function
search:
.LFB76:
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
	subq	$8, %rsp
	.cfi_def_cfa_offset 64
	movl	%edi, %ebp
	movl	%esi, %r13d
	movl	%edx, %r14d
	movq	%rcx, %r15
	movq	%r8, %r12
	movl	%esi, %edx
	subl	%edi, %edx
	movl	%edx, %ebx
	shrl	$31, %ebx
	addl	%edx, %ebx
	sarl	%ebx
	addl	%edi, %ebx
	movslq	%edi, %rcx
	leaq	0(,%rcx,8), %rax
	subq	%rcx, %rax
	leaq	(%r8,%rax,8), %rax
	movsd	24(%rax), %xmm1
	comisd	.LC1(%rip), %xmm1
	jbe	.L222
	movslq	%esi, %rsi
	leaq	0(,%rsi,8), %rcx
	subq	%rsi, %rcx
	leaq	(%r8,%rcx,8), %rcx
	movsd	24(%rcx), %xmm0
	divsd	%xmm1, %xmm0
	movsd	%xmm0, 40(%rax)
	movapd	%xmm0, %xmm1
	subsd	.LC9(%rip), %xmm1
	pxor	%xmm2, %xmm2
	cvtsi2sdl	%edx, %xmm2
	divsd	%xmm2, %xmm1
	movsd	%xmm1, 48(%rax)
	movsd	.LC18(%rip), %xmm1
	comisd	%xmm0, %xmm1
	jbe	.L222
	movsd	24(%rcx), %xmm0
	movsd	%xmm0, 24(%rax)
	movq	.LC9(%rip), %rdi
	movq	%rdi, 40(%rax)
	movq	$0x000000000, 48(%rax)
	jmp	.L221
.L222:
	cmpl	%ebx, %ebp
	je	.L221
	cmpl	%ebx, %r13d
	je	.L221
	movsd	40(%rax), %xmm0
	comisd	.LC19(%rip), %xmm0
	ja	.L226
	movsd	.LC20(%rip), %xmm1
	comisd	%xmm0, %xmm1
	jbe	.L221
.L226:
	movslq	%ebx, %rdx
	leaq	0(,%rdx,8), %rax
	subq	%rdx, %rax
	leaq	(%r12,%rax,8), %rdx
	movq	%r15, %rsi
	movl	%r14d, %edi
	call	collect_sample
	movq	%r12, %r8
	movq	%r15, %rcx
	movl	%r14d, %edx
	movl	%r13d, %esi
	movl	%ebx, %edi
	call	search
	movq	%r12, %r8
	movq	%r15, %rcx
	movl	%r14d, %edx
	movl	%ebx, %esi
	movl	%ebp, %edi
	call	search
.L221:
	addq	$8, %rsp
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
	.cfi_endproc
.LFE76:
	.size	search, .-search
	.globl	collect_data
	.type	collect_data, @function
collect_data:
.LFB75:
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
	movq	%rdi, %rbx
	movq	%rsi, %r14
	movq	%rdx, %r12
	movl	%ecx, %r15d
	movq	%r8, 8(%rsp)
	movq	%fs:40, %rax
	movq	%rax, 248(%rsp)
	xorl	%eax, %eax
	movq	%rdi, %r13
	shrq	$2, %r13
	movl	$1, 164(%rsp)
	movq	%rdx, 168(%rsp)
	movq	%rdx, 176(%rsp)
	movq	%rsi, 184(%rsp)
	call	getpagesize@PLT
	cltq
	movq	%rax, 192(%rsp)
	movq	$0, 16(%rsp)
	cmpq	%r12, %rbx
	ja	.L269
	movq	%r13, %rcx
	movq	%rbx, %rdx
	movl	$0, %ebp
	movl	$0, %eax
	jmp	.L232
.L257:
	addq	%rcx, %rcx
	cmpq	%rdx, %r12
	jb	.L270
	movl	$0, %eax
.L232:
	addl	$1, %ebp
	addl	$1, %eax
	addq	%rcx, %rdx
	cmpl	$3, %eax
	jg	.L257
	cmpq	%rdx, %r12
	jnb	.L232
	jmp	.L257
.L270:
	movslq	%ebp, %rax
	leaq	0(,%rax,8), %rdi
	subq	%rax, %rdi
	salq	$3, %rdi
	call	malloc@PLT
	movq	%rax, (%rsp)
	movq	8(%rsp), %rsi
	movq	%rax, (%rsi)
	testq	%rax, %rax
	je	.L236
	movl	$0, %edx
	movsd	.LC0(%rip), %xmm0
	jmp	.L237
.L236:
	leaq	.LC3(%rip), %rdi
	call	perror@PLT
	movl	$2, %edi
	call	exit@PLT
.L258:
	addq	%r13, %r13
	cmpq	%rbx, %r12
	jb	.L252
	movl	$0, %edx
.L238:
	addq	$56, %rax
.L237:
	movq	%rbx, (%rax)
	movq	%r14, 16(%rax)
	movsd	%xmm0, 24(%rax)
	movsd	%xmm0, 40(%rax)
	movsd	%xmm0, 48(%rax)
	addl	$1, %edx
	addq	%r13, %rbx
	cmpl	$3, %edx
	jg	.L258
	cmpq	%rbx, %r12
	jnb	.L238
	jmp	.L258
.L272:
	testl	%ebp, %ebp
	jle	.L245
	movq	(%rsp), %rsi
	leaq	8(%rsi), %rax
	leal	-1(%rbp), %ecx
	leaq	0(,%rcx,8), %rdx
	subq	%rcx, %rdx
	leaq	64(%rsi,%rdx,8), %rdx
.L246:
	movq	%r12, (%rax)
	addq	$56, %rax
	cmpq	%rax, %rdx
	jne	.L246
.L245:
	cmpq	$0, 208(%rsp)
	je	.L247
	movl	$0, %eax
.L248:
	movq	%rax, %rcx
	imulq	192(%rsp), %rcx
	movq	224(%rsp), %rdx
	movq	%rcx, (%rdx,%rax,8)
	addq	$1, %rax
	cmpq	%rax, 208(%rsp)
	ja	.L248
.L247:
	movslq	%ebp, %rax
	leaq	0(,%rax,8), %r12
	subq	%rax, %r12
	salq	$3, %r12
	movq	(%rsp), %r14
	leaq	-56(%r14,%r12), %rbx
	leaq	16(%rsp), %rcx
	leaq	32(%rbx), %rdx
	movl	%r15d, %esi
	movq	(%rbx), %rdi
	call	measure
	movsd	%xmm0, 24(%rbx)
	addq	$32, %rbx
	addq	%r14, %r12
	pxor	%xmm1, %xmm1
	comisd	%xmm0, %xmm1
	jb	.L249
.L251:
	leaq	16(%rsp), %rcx
	movq	-32(%rbx), %rdi
	movq	%rbx, %rdx
	movl	%r15d, %esi
	call	measure
	movsd	%xmm0, -8(%rbx)
	subl	$1, %ebp
	movsd	-88(%r12), %xmm0
	subq	$56, %rbx
	subq	$56, %r12
	pxor	%xmm2, %xmm2
	comisd	%xmm0, %xmm2
	jnb	.L251
.L249:
	leaq	16(%rsp), %rbx
	movq	(%rsp), %r14
	leaq	32(%r14), %rdx
	movq	%rbx, %rcx
	movl	%r15d, %esi
	movq	(%r14), %rdi
	call	measure
	movq	%r14, %r8
	movsd	%xmm0, 24(%r14)
	leal	-1(%rbp), %esi
	movq	%rbx, %rcx
	movl	%r15d, %edx
	movl	$0, %edi
	call	search
	movq	%rbx, %rsi
	movl	$0, %edi
	call	mem_cleanup@PLT
	movq	248(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L271
	movl	%ebp, %eax
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
.L269:
	.cfi_restore_state
	movl	$0, %edi
	call	malloc@PLT
	movq	%rax, (%rsp)
	movq	8(%rsp), %rsi
	movq	%rax, (%rsi)
	testq	%rax, %rax
	je	.L236
	movl	$0, %ebp
.L252:
	leaq	16(%rsp), %rbx
.L241:
	cmpq	$0, 16(%rsp)
	jne	.L272
	movq	%rbx, %rsi
	movl	$0, %edi
	call	mem_initialize@PLT
	cmpq	$0, 16(%rsp)
	jne	.L241
	movq	%r12, %rcx
	shrq	%rcx
	movq	%rcx, %r12
	movq	%rcx, 176(%rsp)
	movq	%rcx, 168(%rsp)
	movslq	%ebp, %rax
	leaq	0(,%rax,8), %rdx
	subq	%rax, %rdx
	leaq	0(,%rdx,8), %rax
	movq	(%rsp), %rsi
	cmpq	-56(%rsi,%rdx,8), %rcx
	jnb	.L241
	addq	%rsi, %rax
.L243:
	subl	$1, %ebp
	subq	$56, %rax
	cmpq	%r12, -56(%rax)
	ja	.L243
	jmp	.L241
.L271:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE75:
	.size	collect_data, .-collect_data
	.section	.rodata.str1.8
	.align 8
.LC21:
	.string	"[-c] [-L <line size>] [-M len[K|M]] [-W <warmup>] [-N <repetitions>]\n"
	.section	.rodata.str1.1
.LC22:
	.string	"L:M:W:N:"
	.section	.rodata.str1.8
	.align 8
.LC25:
	.string	"L%d cache: %lu bytes %.2f nanoseconds %ld linesize %.2f parallelism\n"
	.align 8
.LC26:
	.string	"Memory latency: %.2f nanoseconds %.2f parallelism\n"
	.text
	.globl	main
	.type	main, @function
main:
.LFB73:
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
	subq	$328, %rsp
	.cfi_def_cfa_offset 384
	movl	%edi, %r12d
	movq	%rsi, %rbp
	movq	%fs:40, %rax
	movq	%rax, 312(%rsp)
	xorl	%eax, %eax
	movl	$0, %edi
	call	get_enough@PLT
	cmpl	$999999, %eax
	movl	$1, %edx
	movl	$11, %eax
	cmovg	%edx, %eax
	movl	%eax, 4(%rsp)
	movl	$33554432, %r14d
	movl	$0, %ebx
	movl	$0, 24(%rsp)
	leaq	.LC22(%rip), %r13
	jmp	.L275
.L277:
	cmpl	$87, %eax
	jne	.L280
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	movl	%eax, 24(%rsp)
	jmp	.L275
.L278:
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	movslq	%eax, %rdx
	cmpq	$7, %rdx
	movl	$8, %ebx
	cmova	%rdx, %rbx
.L275:
	movq	%r13, %rdx
	movq	%rbp, %rsi
	movl	%r12d, %edi
	call	mygetopt@PLT
	cmpl	$-1, %eax
	je	.L332
	cmpl	$78, %eax
	je	.L276
	jg	.L277
	cmpl	$76, %eax
	je	.L278
	cmpl	$77, %eax
	jne	.L280
	movq	myoptarg(%rip), %rdi
	call	bytes@PLT
	movq	%rax, %r14
	jmp	.L275
.L276:
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	movl	%eax, 4(%rsp)
	jmp	.L275
.L280:
	leaq	.LC21(%rip), %rdx
	movq	%rbp, %rsi
	movl	%r12d, %edi
	call	lmbench_usage@PLT
	jmp	.L275
.L332:
	movl	%eax, %r15d
	movl	$0, %edi
	call	sched_pin@PLT
	movl	$1, 228(%rsp)
	movq	%r14, 232(%rsp)
	movq	%r14, 240(%rsp)
	call	getpagesize@PLT
	movl	%eax, %ebp
	cltq
	movq	%rax, 256(%rsp)
	testq	%rbx, %rbx
	je	.L333
.L284:
	leaq	72(%rsp), %r8
	movl	4(%rsp), %ecx
	movq	%r14, %rdx
	movq	%rbx, %rsi
	movl	$512, %edi
	call	collect_data
	movl	%eax, 44(%rsp)
	movq	72(%rsp), %r12
	cltq
	leaq	0(,%rax,8), %rdx
	subq	%rax, %rdx
	leaq	0(,%rdx,8), %rsi
	movq	%rsi, 56(%rsp)
	subq	$56, %rsi
	movq	%rsi, 48(%rsp)
	leaq	(%r12,%rsi), %r13
	movq	%rbx, 16(%r13)
	leaq	0(,%rax,4), %rbx
	movq	%rbx, %rdi
	call	malloc@PLT
	movq	%rax, %rbp
	testq	%rax, %rax
	je	.L334
	movq	%rbx, %rdx
	movl	$0, %esi
	movq	%rax, %rdi
	call	memset@PLT
	movl	$0, %r14d
	movsd	.LC0(%rip), %xmm0
	movl	$0, %ebx
	movl	%r15d, 8(%rsp)
	movl	44(%rsp), %r15d
	jmp	.L287
.L333:
	leaq	80(%rsp), %rcx
	movl	4(%rsp), %edx
	movl	24(%rsp), %esi
	movq	%r14, %rdi
	call	line_find@PLT
	movq	%rax, %rbx
	testq	%rax, %rax
	jne	.L285
	movl	$16, %ecx
	movl	%ebp, %eax
	cltd
	idivl	%ecx
	movslq	%eax, %rbx
.L285:
	movq	%rbx, 248(%rsp)
	jmp	.L284
.L334:
	leaq	.LC3(%rip), %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L329:
	movl	8(%rsp), %r15d
	jmp	.L288
.L291:
	movl	%edx, 0(%rbp,%r14,4)
	movslq	%ebx, %rbx
	leaq	0(,%rbx,8), %rax
	subq	%rbx, %rax
	salq	$3, %rax
	movsd	24(%r12,%rax), %xmm0
	comisd	.LC1(%rip), %xmm0
	jbe	.L335
.L294:
	leal	1(%rdx), %ebx
	addq	$1, %r14
.L287:
	movl	%r14d, (%rsp)
	movq	%r12, %rdx
	movl	%r15d, %esi
	movl	%ebx, %edi
	call	find_cache
	movl	%eax, %edx
	testl	%eax, %eax
	js	.L336
	movslq	%edx, %rcx
	leaq	0(,%rcx,8), %rax
	subq	%rcx, %rax
	leaq	(%r12,%rax,8), %rax
	movsd	24(%rax), %xmm0
	divsd	24(%r13), %xmm0
	comisd	.LC23(%rip), %xmm0
	ja	.L329
	movq	(%rax), %rcx
	movl	%ecx, %eax
	cmpl	$7, %ecx
	jle	.L289
.L290:
	sarl	%eax
	cmpl	$7, %eax
	jg	.L290
.L289:
	andl	$-3, %eax
	cmpl	$5, %eax
	jne	.L291
	addl	$1, %edx
	cmpl	%edx, %r15d
	jg	.L291
	movl	8(%rsp), %r15d
	jmp	.L288
.L335:
	movsd	-32(%r12,%rax), %xmm0
	jmp	.L294
.L336:
	movl	8(%rsp), %r15d
.L288:
	cmpl	$0, (%rsp)
	jle	.L292
	movq	%rbp, 8(%rsp)
	movl	%r15d, %edx
	movl	$0, %ebx
	leaq	80(%rsp), %rax
	movq	%rax, 16(%rsp)
	movl	%r15d, 28(%rsp)
	movl	%ebx, %r15d
	jmp	.L293
.L337:
	xorpd	.LC24(%rip), %xmm0
	jmp	.L299
.L301:
	ucomisd	%xmm0, %xmm1
	cmova	%eax, %r12d
.L298:
	addl	$1, %eax
	addq	$56, %rdx
	cmpl	%r13d, %eax
	je	.L297
.L304:
	comisd	80(%rdx), %xmm2
	jnb	.L298
	movslq	%r12d, %rsi
	leaq	0(,%rsi,8), %rcx
	subq	%rsi, %rcx
	leaq	(%rdi,%rcx,8), %rcx
	comisd	24(%rcx), %xmm3
	jnb	.L318
	movsd	104(%rdx), %xmm0
	comisd	%xmm0, %xmm5
	ja	.L337
.L299:
	movsd	48(%rcx), %xmm1
	comisd	%xmm1, %xmm4
	jbe	.L301
	xorpd	.LC24(%rip), %xmm1
	jmp	.L301
.L318:
	movl	%eax, %r12d
	jmp	.L298
.L317:
	movl	%eax, %r12d
.L297:
	movl	(%rsp), %eax
	subl	$1, %eax
	cmpl	%r15d, %eax
	je	.L338
	movl	%r13d, %edx
	addl	4(%r8), %edx
	movl	%edx, %eax
	shrl	$31, %eax
	addl	%edx, %eax
	sarl	%eax
	movl	%eax, %r14d
	movl	44(%rsp), %ebx
	cmpl	%eax, %ebx
	jle	.L319
	cltq
	leaq	0(,%rax,8), %rbp
	subq	%rax, %rbp
	salq	$3, %rbp
	movl	%r13d, 32(%rsp)
	movl	%r15d, 36(%rsp)
	movl	%r12d, 40(%rsp)
	movl	24(%rsp), %r12d
	movl	4(%rsp), %r13d
	movq	16(%rsp), %r15
.L307:
	movq	72(%rsp), %rax
	movq	(%rax,%rbp), %rdi
	movq	%r15, %rcx
	movl	%r13d, %edx
	movl	%r12d, %esi
	call	line_find@PLT
	movq	72(%rsp), %rdx
	movq	%rax, 16(%rdx,%rbp)
	addl	$1, %r14d
	addq	$56, %rbp
	testq	%rax, %rax
	jg	.L330
	cmpl	%r14d, %ebx
	jg	.L307
	movl	32(%rsp), %r13d
	movq	%rax, %rbx
	movl	36(%rsp), %r15d
	movl	40(%rsp), %r12d
	jmp	.L306
.L338:
	movq	72(%rsp), %rax
	movq	48(%rsp), %rbx
	movq	16(%rax,%rbx), %rbx
.L306:
	movslq	%r13d, %rax
	leaq	0(,%rax,8), %rbp
	subq	%rax, %rbp
	movq	72(%rsp), %rax
	movq	-56(%rax,%rbp,8), %rdi
	movq	16(%rsp), %rcx
	movl	4(%rsp), %edx
	movl	24(%rsp), %esi
	call	par_mem@PLT
	movapd	%xmm0, %xmm1
	movq	72(%rsp), %rdx
	addl	$1, %r15d
	movslq	%r12d, %r12
	leaq	0(,%r12,8), %rax
	subq	%r12, %rax
	movsd	24(%rdx,%rax,8), %xmm0
	movq	%rbx, %r9
	movq	(%rdx,%rbp,8), %r8
	movl	%r15d, %ecx
	leaq	.LC25(%rip), %rdx
	movl	$1, %esi
	movq	stderr(%rip), %rdi
	movl	$2, %eax
	call	__fprintf_chk@PLT
	cmpl	(%rsp), %r15d
	je	.L292
	testl	%r15d, %r15d
	cmovle	28(%rsp), %r13d
	addq	$4, 8(%rsp)
	movl	%r13d, %edx
.L293:
	leal	1(%rdx), %eax
	movq	8(%rsp), %rbx
	movq	%rbx, %r8
	movl	(%rbx), %r13d
	cmpl	%r13d, %eax
	jge	.L317
	movq	72(%rsp), %rdi
	movslq	%edx, %rdx
	leaq	0(,%rdx,8), %rcx
	subq	%rdx, %rcx
	leaq	(%rdi,%rcx,8), %rdx
	movl	%eax, %r12d
	pxor	%xmm2, %xmm2
	movapd	%xmm2, %xmm3
	movapd	%xmm2, %xmm5
	movapd	%xmm2, %xmm4
	jmp	.L304
.L319:
	movq	$-1, %rbx
	jmp	.L306
.L330:
	movl	32(%rsp), %r13d
	movq	%rax, %rbx
	movl	36(%rsp), %r15d
	movl	40(%rsp), %r12d
	jmp	.L306
.L292:
	movl	44(%rsp), %r15d
	subl	$1, %r15d
	js	.L320
	movq	48(%rsp), %rcx
	addq	72(%rsp), %rcx
	movq	56(%rsp), %rax
	addq	72(%rsp), %rax
	movl	%r15d, %edx
	pxor	%xmm2, %xmm2
	movsd	.LC5(%rip), %xmm3
	jmp	.L313
.L311:
	subl	$1, %r15d
	subq	$56, %rax
	cmpl	$-1, %r15d
	je	.L310
.L313:
	movsd	-32(%rax), %xmm0
	comisd	%xmm0, %xmm2
	ja	.L311
	movapd	%xmm3, %xmm1
	mulsd	24(%rcx), %xmm1
	ucomisd	%xmm1, %xmm0
	cmova	%r15d, %edx
	jmp	.L311
.L320:
	movl	%r15d, %edx
.L310:
	leaq	80(%rsp), %rcx
	movslq	%edx, %rdx
	leaq	0(,%rdx,8), %rax
	subq	%rdx, %rax
	salq	$3, %rax
	addq	72(%rsp), %rax
	movl	4(%rsp), %edx
	movl	24(%rsp), %esi
	movq	(%rax), %rdi
	call	par_mem@PLT
	movapd	%xmm0, %xmm1
	movq	72(%rsp), %rax
	movq	48(%rsp), %rbx
	movsd	24(%rax,%rbx), %xmm0
	leaq	.LC26(%rip), %rdx
	movl	$1, %esi
	movq	stderr(%rip), %rdi
	movl	$2, %eax
	call	__fprintf_chk@PLT
	movl	$0, %edi
	call	exit@PLT
	.cfi_endproc
.LFE73:
	.size	main, .-main
	.local	available_index.0
	.comm	available_index.0,8,8
	.data
	.align 8
	.type	__iterations.1, @object
	.size	__iterations.1, 8
__iterations.1:
	.quad	1
	.local	addr_save
	.comm	addr_save,8,8
	.globl	id
	.section	.rodata.str1.1
.LC27:
	.string	"$Id$\n"
	.section	.data.rel.local,"aw"
	.align 8
	.type	id, @object
	.size	id, 8
id:
	.quad	.LC27
	.section	.rodata.cst8,"aM",@progbits,8
	.align 8
.LC0:
	.long	0
	.long	-1074790400
	.set	.LC1,.LC24+8
	.align 8
.LC2:
	.long	0
	.long	1073217536
	.align 8
.LC4:
	.long	1717986918
	.long	1072588390
	.align 8
.LC5:
	.long	2061584302
	.long	1072672276
	.align 8
.LC6:
	.long	858993459
	.long	1072902963
	.align 8
.LC7:
	.long	0
	.long	1080213504
	.align 8
.LC8:
	.long	-1717986918
	.long	1072798105
	.align 8
.LC9:
	.long	0
	.long	1072693248
	.align 8
.LC10:
	.long	0
	.long	1138753536
	.align 8
.LC11:
	.long	0
	.long	1083129856
	.align 8
.LC12:
	.long	0
	.long	1079574528
	.align 8
.LC16:
	.long	1030792151
	.long	1072682762
	.align 8
.LC17:
	.long	-652835029
	.long	1072691150
	.align 8
.LC18:
	.long	-171798692
	.long	1072651304
	.align 8
.LC19:
	.long	-1717986918
	.long	1073060249
	.align 8
.LC20:
	.long	1889785610
	.long	1072630333
	.align 8
.LC23:
	.long	0
	.long	1071644672
	.section	.rodata.cst16,"aM",@progbits,16
	.align 16
.LC24:
	.long	0
	.long	-2147483648
	.long	0
	.long	0
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
