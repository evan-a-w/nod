	.file	"tlb.c"
	.text
	.globl	compute_times
	.type	compute_times, @function
compute_times:
.LFB74:
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
	subq	$424, %rsp
	.cfi_def_cfa_offset 480
	movl	%edi, %r14d
	movq	%rcx, %r15
	movq	%r8, 24(%rsp)
	movq	%r9, %rbx
	movq	%fs:40, %rax
	movq	%rax, 408(%rsp)
	xorl	%eax, %eax
	call	get_results@PLT
	movq	%rax, 16(%rsp)
	leaq	32(%rsp), %rdi
	call	insertinit@PLT
	leaq	224(%rsp), %rdi
	call	insertinit@PLT
	movslq	%r14d, %r14
	movq	%r14, %rax
	imulq	176(%rbx), %rax
	movq	%rax, 152(%rbx)
	movq	%rax, 160(%rbx)
	movq	%rbx, %rsi
	movl	$0, %edi
	call	tlb_initialize@PLT
	cmpl	$0, 144(%rbx)
	je	.L2
	movl	$11, %r13d
	jmp	.L30
.L92:
	movq	%rbx, %rsi
	call	mem_benchmark_0@PLT
	jmp	.L5
.L6:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
	movsd	%xmm0, (%rsp)
	jmp	.L7
.L13:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rdx, %xmm1
	addsd	%xmm1, %xmm1
	jmp	.L14
.L15:
	subsd	.LC7(%rip), %xmm0
	cvttsd2siq	%xmm0, %rax
	movq	%rax, __iterations.1(%rip)
	btcq	$63, __iterations.1(%rip)
	jmp	.L9
.L86:
	movq	__iterations.1(%rip), %rax
	cmpq	$134217728, %rax
	ja	.L70
	salq	$3, %rax
	movq	%rax, __iterations.1(%rip)
.L9:
	movq	%rbp, %xmm6
	comisd	(%rsp), %xmm6
	jbe	.L3
.L17:
	movl	$0, %edi
	call	start@PLT
	movq	__iterations.1(%rip), %rdi
	testq	%rdi, %rdi
	jne	.L92
.L5:
	movl	$0, %esi
	movl	$0, %edi
	call	stop@PLT
	testq	%rax, %rax
	js	.L6
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rax, %xmm1
	movsd	%xmm1, (%rsp)
.L7:
	movsd	.LC2(%rip), %xmm0
	movsd	8(%rsp), %xmm2
	mulsd	%xmm2, %xmm0
	movsd	(%rsp), %xmm4
	comisd	%xmm4, %xmm0
	ja	.L8
	mulsd	.LC3(%rip), %xmm2
	comisd	%xmm2, %xmm4
	jbe	.L9
.L8:
	movsd	(%rsp), %xmm6
	comisd	.LC4(%rip), %xmm6
	jbe	.L86
	movq	__iterations.1(%rip), %rax
	testq	%rax, %rax
	js	.L13
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rax, %xmm1
.L14:
	divsd	(%rsp), %xmm1
	movsd	8(%rsp), %xmm0
	mulsd	.LC5(%rip), %xmm0
	mulsd	%xmm1, %xmm0
	addsd	.LC6(%rip), %xmm0
	comisd	.LC7(%rip), %xmm0
	jnb	.L15
	cvttsd2siq	%xmm0, %rax
	movq	%rax, __iterations.1(%rip)
	jmp	.L9
.L70:
	pxor	%xmm4, %xmm4
	movsd	%xmm4, (%rsp)
.L3:
	movq	__iterations.1(%rip), %rdi
	call	save_n@PLT
	movsd	(%rsp), %xmm7
	comisd	.LC7(%rip), %xmm7
	jnb	.L18
	cvttsd2siq	%xmm7, %rdi
.L19:
	call	settime@PLT
	call	usecs_spent@PLT
	testq	%rax, %rax
	js	.L20
	pxor	%xmm7, %xmm7
	cvtsi2sdq	%rax, %xmm7
	movsd	%xmm7, (%rsp)
.L21:
	call	t_overhead@PLT
	movq	%rax, %rbp
	call	get_n@PLT
	movq	%rax, %r12
	call	l_overhead@PLT
	movapd	%xmm0, %xmm1
	testq	%r12, %r12
	js	.L22
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%r12, %xmm0
.L23:
	mulsd	%xmm1, %xmm0
	testq	%rbp, %rbp
	js	.L24
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rbp, %xmm1
.L25:
	addsd	%xmm1, %xmm0
	movsd	(%rsp), %xmm1
	subsd	%xmm0, %xmm1
	movl	$0, %edi
	comisd	.LC0(%rip), %xmm1
	jb	.L26
	comisd	.LC7(%rip), %xmm1
	jnb	.L28
	cvttsd2siq	%xmm1, %rdi
.L26:
	call	settime@PLT
	call	get_n@PLT
	movq	%rax, %rbp
	call	usecs_spent@PLT
	movq	%rax, %rdi
	leaq	32(%rsp), %rdx
	movq	%rbp, %rsi
	call	insertsort@PLT
	subl	$1, %r13d
	je	.L2
.L30:
	movl	$0, %edi
	call	get_enough@PLT
	pxor	%xmm5, %xmm5
	cvtsi2sdl	%eax, %xmm5
	movsd	%xmm5, 8(%rsp)
	movsd	.LC1(%rip), %xmm2
	mulsd	%xmm5, %xmm2
	movq	%xmm2, %rbp
	pxor	%xmm5, %xmm5
	comisd	%xmm5, %xmm2
	ja	.L17
	pxor	%xmm6, %xmm6
	movsd	%xmm6, (%rsp)
	jmp	.L3
.L18:
	movsd	(%rsp), %xmm0
	subsd	.LC7(%rip), %xmm0
	cvttsd2siq	%xmm0, %rdi
	btcq	$63, %rdi
	jmp	.L19
.L20:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
	movsd	%xmm0, (%rsp)
	jmp	.L21
.L22:
	movq	%r12, %rax
	shrq	%rax
	andl	$1, %r12d
	orq	%r12, %rax
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	addsd	%xmm0, %xmm0
	jmp	.L23
.L24:
	movq	%rbp, %rax
	shrq	%rax
	andl	$1, %ebp
	orq	%rbp, %rax
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rax, %xmm1
	addsd	%xmm1, %xmm1
	jmp	.L25
.L28:
	subsd	.LC7(%rip), %xmm1
	cvttsd2siq	%xmm1, %rdi
	btcq	$63, %rdi
	jmp	.L26
.L2:
	movq	%rbx, %rsi
	movl	$0, %edi
	call	tlb_cleanup@PLT
	imulq	168(%rbx), %r14
	movq	%r14, 152(%rbx)
	movq	%r14, 160(%rbx)
	movq	%rbx, %rsi
	movl	$0, %edi
	call	mem_initialize@PLT
	cmpl	$0, 144(%rbx)
	je	.L31
	movl	$11, %r13d
	jmp	.L59
.L93:
	movq	%rbx, %rsi
	call	mem_benchmark_0@PLT
	jmp	.L34
.L35:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
	movsd	%xmm0, (%rsp)
	jmp	.L36
.L42:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rdx, %xmm1
	addsd	%xmm1, %xmm1
	jmp	.L43
.L44:
	subsd	.LC7(%rip), %xmm0
	cvttsd2siq	%xmm0, %rax
	movq	%rax, __iterations.0(%rip)
	btcq	$63, __iterations.0(%rip)
	jmp	.L38
.L89:
	movq	__iterations.0(%rip), %rax
	cmpq	$134217728, %rax
	ja	.L73
	salq	$3, %rax
	movq	%rax, __iterations.0(%rip)
.L38:
	movq	%rbp, %xmm6
	comisd	(%rsp), %xmm6
	jbe	.L32
.L46:
	movl	$0, %edi
	call	start@PLT
	movq	__iterations.0(%rip), %rdi
	testq	%rdi, %rdi
	jne	.L93
.L34:
	movl	$0, %esi
	movl	$0, %edi
	call	stop@PLT
	testq	%rax, %rax
	js	.L35
	pxor	%xmm6, %xmm6
	cvtsi2sdq	%rax, %xmm6
	movsd	%xmm6, (%rsp)
.L36:
	movsd	.LC2(%rip), %xmm0
	movsd	8(%rsp), %xmm3
	mulsd	%xmm3, %xmm0
	movsd	(%rsp), %xmm5
	comisd	%xmm5, %xmm0
	ja	.L37
	mulsd	.LC3(%rip), %xmm3
	comisd	%xmm3, %xmm5
	jbe	.L38
.L37:
	movsd	(%rsp), %xmm7
	comisd	.LC4(%rip), %xmm7
	jbe	.L89
	movq	__iterations.0(%rip), %rax
	testq	%rax, %rax
	js	.L42
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rax, %xmm1
.L43:
	divsd	(%rsp), %xmm1
	movsd	8(%rsp), %xmm0
	mulsd	.LC5(%rip), %xmm0
	mulsd	%xmm1, %xmm0
	addsd	.LC6(%rip), %xmm0
	comisd	.LC7(%rip), %xmm0
	jnb	.L44
	cvttsd2siq	%xmm0, %rax
	movq	%rax, __iterations.0(%rip)
	jmp	.L38
.L73:
	pxor	%xmm2, %xmm2
	movsd	%xmm2, (%rsp)
.L32:
	movq	__iterations.0(%rip), %rdi
	call	save_n@PLT
	movsd	(%rsp), %xmm2
	comisd	.LC7(%rip), %xmm2
	jnb	.L47
	cvttsd2siq	%xmm2, %rdi
.L48:
	call	settime@PLT
	call	usecs_spent@PLT
	testq	%rax, %rax
	js	.L49
	pxor	%xmm3, %xmm3
	cvtsi2sdq	%rax, %xmm3
	movq	%xmm3, %r14
.L50:
	call	t_overhead@PLT
	movq	%rax, %rbp
	call	get_n@PLT
	movq	%rax, %r12
	call	l_overhead@PLT
	movapd	%xmm0, %xmm1
	testq	%r12, %r12
	js	.L51
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%r12, %xmm0
.L52:
	mulsd	%xmm1, %xmm0
	testq	%rbp, %rbp
	js	.L53
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rbp, %xmm1
.L54:
	addsd	%xmm1, %xmm0
	movq	%r14, %xmm1
	subsd	%xmm0, %xmm1
	movl	$0, %edi
	comisd	.LC0(%rip), %xmm1
	jb	.L55
	comisd	.LC7(%rip), %xmm1
	jnb	.L57
	cvttsd2siq	%xmm1, %rdi
.L55:
	call	settime@PLT
	call	get_n@PLT
	movq	%rax, %rbp
	call	usecs_spent@PLT
	movq	%rax, %rdi
	leaq	224(%rsp), %rdx
	movq	%rbp, %rsi
	call	insertsort@PLT
	subl	$1, %r13d
	je	.L31
.L59:
	movl	$0, %edi
	call	get_enough@PLT
	pxor	%xmm3, %xmm3
	cvtsi2sdl	%eax, %xmm3
	movsd	%xmm3, 8(%rsp)
	movsd	.LC1(%rip), %xmm5
	mulsd	%xmm3, %xmm5
	movq	%xmm5, %rbp
	movapd	%xmm5, %xmm4
	pxor	%xmm5, %xmm5
	comisd	%xmm5, %xmm4
	ja	.L46
	pxor	%xmm5, %xmm5
	movsd	%xmm5, (%rsp)
	jmp	.L32
.L47:
	movsd	(%rsp), %xmm0
	subsd	.LC7(%rip), %xmm0
	cvttsd2siq	%xmm0, %rdi
	btcq	$63, %rdi
	jmp	.L48
.L49:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
	movq	%xmm0, %r14
	jmp	.L50
.L51:
	movq	%r12, %rax
	shrq	%rax
	andl	$1, %r12d
	orq	%r12, %rax
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	addsd	%xmm0, %xmm0
	jmp	.L52
.L53:
	movq	%rbp, %rax
	shrq	%rax
	andl	$1, %ebp
	orq	%rbp, %rax
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rax, %xmm1
	addsd	%xmm1, %xmm1
	jmp	.L54
.L57:
	subsd	.LC7(%rip), %xmm1
	cvttsd2siq	%xmm1, %rdi
	btcq	$63, %rdi
	jmp	.L55
.L31:
	movq	%rbx, %rsi
	movl	$0, %edi
	call	mem_cleanup@PLT
	leaq	32(%rsp), %rdi
	call	set_results@PLT
	call	usecs_spent@PLT
	movq	%rax, %rbx
	call	get_n@PLT
	testq	%rbx, %rbx
	js	.L60
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rbx, %xmm0
.L61:
	mulsd	.LC8(%rip), %xmm0
	testq	%rax, %rax
	js	.L62
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rax, %xmm1
.L63:
	mulsd	.LC9(%rip), %xmm1
	divsd	%xmm1, %xmm0
	movsd	%xmm0, (%r15)
	leaq	224(%rsp), %rdi
	call	set_results@PLT
	call	usecs_spent@PLT
	movq	%rax, %rbx
	call	get_n@PLT
	testq	%rbx, %rbx
	js	.L64
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rbx, %xmm0
.L65:
	mulsd	.LC8(%rip), %xmm0
	testq	%rax, %rax
	js	.L66
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rax, %xmm1
.L67:
	mulsd	.LC9(%rip), %xmm1
	divsd	%xmm1, %xmm0
	movq	24(%rsp), %rax
	movsd	%xmm0, (%rax)
	movq	16(%rsp), %rdi
	call	set_results@PLT
	movq	408(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L94
	addq	$424, %rsp
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
.L60:
	.cfi_restore_state
	movq	%rbx, %rdx
	shrq	%rdx
	andl	$1, %ebx
	orq	%rbx, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
	jmp	.L61
.L62:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rdx, %xmm1
	addsd	%xmm1, %xmm1
	jmp	.L63
.L64:
	movq	%rbx, %rdx
	shrq	%rdx
	andl	$1, %ebx
	orq	%rbx, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
	jmp	.L65
.L66:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rdx, %xmm1
	addsd	%xmm1, %xmm1
	jmp	.L67
.L94:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE74:
	.size	compute_times, .-compute_times
	.globl	find_tlb
	.type	find_tlb, @function
find_tlb:
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
	subq	$24, %rsp
	.cfi_def_cfa_offset 80
	movl	%edi, %ebx
	movl	%esi, 12(%rsp)
	movl	%edx, 8(%rsp)
	movl	%ecx, %r15d
	movq	%r8, %r12
	movq	%r9, %r13
	cmpl	%esi, %edi
	jg	.L99
.L101:
	movq	80(%rsp), %r9
	movq	%r13, %r8
	movq	%r12, %rcx
	movl	%r15d, %edx
	movl	8(%rsp), %esi
	movl	%ebx, %edi
	call	compute_times
	movsd	(%r12), %xmm0
	divsd	0(%r13), %xmm0
	comisd	.LC10(%rip), %xmm0
	ja	.L113
	addl	%ebx, %ebx
	cmpl	%ebx, 12(%rsp)
	jge	.L101
.L99:
	movq	80(%rsp), %rax
	movq	$0, 152(%rax)
	movl	$0, %r14d
	jmp	.L95
.L113:
	movl	%ebx, %r14d
	sarl	%r14d
	movl	%ebx, %eax
	subl	%r14d, %eax
	movl	%eax, %ebp
	shrl	$31, %ebp
	addl	%eax, %ebp
	sarl	%ebp
	addl	%r14d, %ebp
	cmpl	%ebp, 12(%rsp)
	jle	.L99
	leal	1(%r14), %eax
	cmpl	%ebx, %eax
	jge	.L95
.L102:
	movq	80(%rsp), %r9
	movq	%r13, %r8
	movq	%r12, %rcx
	movl	%r15d, %edx
	movl	8(%rsp), %esi
	movl	%ebp, %edi
	call	compute_times
	movsd	(%r12), %xmm0
	divsd	0(%r13), %xmm0
	comisd	.LC10(%rip), %xmm0
	cmovbe	%ebp, %r14d
	cmova	%ebp, %ebx
	movl	%ebx, %eax
	subl	%r14d, %eax
	movl	%eax, %ebp
	shrl	$31, %ebp
	addl	%eax, %ebp
	sarl	%ebp
	addl	%r14d, %ebp
	leal	1(%r14), %eax
	cmpl	%ebx, %eax
	jl	.L102
.L95:
	movl	%r14d, %eax
	addq	$24, %rsp
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
.LFE73:
	.size	find_tlb, .-find_tlb
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC11:
	.string	"[-c] [-L <line size>] [-M len[K|M]] [-W <warmup>] [-N <repetitions>]\n"
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC12:
	.string	"cL:M:W:N:"
	.section	.rodata.str1.8
	.align 8
.LC13:
	.string	"tlb: %d pages %.5f nanoseconds\n"
	.section	.rodata.str1.1
.LC14:
	.string	"tlb: %d pages\n"
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
	subq	$280, %rsp
	.cfi_def_cfa_offset 336
	movl	%edi, %ebp
	movq	%rsi, %rbx
	movq	%fs:40, %rax
	movq	%rax, 264(%rsp)
	xorl	%eax, %eax
	movl	$0, %edi
	call	get_enough@PLT
	cmpl	$999999, %eax
	movl	$1, %edx
	movl	$11, %eax
	cmovg	%edx, %eax
	movl	%eax, 8(%rsp)
	movl	$1, 180(%rsp)
	call	getpagesize@PLT
	movl	%eax, %r15d
	cltq
	movq	%rax, 208(%rsp)
	movq	$8, 200(%rsp)
	movl	$0, 4(%rsp)
	movl	$0, 12(%rsp)
	movl	$16384, %r14d
	leaq	.LC12(%rip), %r13
	leaq	.L119(%rip), %r12
	jmp	.L118
.L123:
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	cltq
	movq	%rax, 200(%rsp)
.L118:
	movq	%r13, %rdx
	movq	%rbx, %rsi
	movl	%ebp, %edi
	call	mygetopt@PLT
	cmpl	$-1, %eax
	je	.L132
	subl	$76, %eax
	cmpl	$23, %eax
	ja	.L117
	movl	%eax, %eax
	movslq	(%r12,%rax,4), %rax
	addq	%r12, %rax
	notrack jmp	*%rax
	.section	.rodata
	.align 4
	.align 4
.L119:
	.long	.L123-.L119
	.long	.L122-.L119
	.long	.L121-.L119
	.long	.L117-.L119
	.long	.L117-.L119
	.long	.L117-.L119
	.long	.L117-.L119
	.long	.L117-.L119
	.long	.L117-.L119
	.long	.L117-.L119
	.long	.L117-.L119
	.long	.L120-.L119
	.long	.L117-.L119
	.long	.L117-.L119
	.long	.L117-.L119
	.long	.L117-.L119
	.long	.L117-.L119
	.long	.L117-.L119
	.long	.L117-.L119
	.long	.L117-.L119
	.long	.L117-.L119
	.long	.L117-.L119
	.long	.L117-.L119
	.long	.L130-.L119
	.text
.L122:
	movq	myoptarg(%rip), %rdi
	call	bytes@PLT
	cltd
	idivl	%r15d
	movl	%eax, %r14d
	jmp	.L118
.L120:
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	movl	%eax, 4(%rsp)
	jmp	.L118
.L121:
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	movl	%eax, 8(%rsp)
	jmp	.L118
.L117:
	leaq	.LC11(%rip), %rdx
	movq	%rbx, %rsi
	movl	%ebp, %edi
	call	lmbench_usage@PLT
	jmp	.L118
.L130:
	movl	$1, 12(%rsp)
	jmp	.L118
.L132:
	subq	$8, %rsp
	.cfi_def_cfa_offset 344
	leaq	40(%rsp), %rax
	pushq	%rax
	.cfi_def_cfa_offset 352
	leaq	40(%rsp), %r9
	leaq	32(%rsp), %r8
	movl	24(%rsp), %ebp
	movl	%ebp, %ecx
	movl	20(%rsp), %r15d
	movl	%r15d, %edx
	movl	%r14d, %esi
	movl	$8, %edi
	call	find_tlb
	movl	%eax, %ebx
	addq	$16, %rsp
	.cfi_def_cfa_offset 336
	testl	%eax, %eax
	jle	.L126
	cmpl	$0, 12(%rsp)
	je	.L127
	leaq	16(%rsp), %rcx
	leal	(%rax,%rax), %edi
	leaq	32(%rsp), %r9
	leaq	24(%rsp), %r8
	movl	%ebp, %edx
	movl	%r15d, %esi
	call	compute_times
	movsd	16(%rsp), %xmm0
	subsd	24(%rsp), %xmm0
	movl	%ebx, %ecx
	leaq	.LC13(%rip), %rdx
	movl	$1, %esi
	movq	stderr(%rip), %rdi
	movl	$1, %eax
	call	__fprintf_chk@PLT
.L126:
	movq	264(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L133
	movl	$0, %eax
	addq	$280, %rsp
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
.L127:
	.cfi_restore_state
	movl	%eax, %ecx
	leaq	.LC14(%rip), %rdx
	movl	$1, %esi
	movq	stderr(%rip), %rdi
	movl	$0, %eax
	call	__fprintf_chk@PLT
	jmp	.L126
.L133:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE72:
	.size	main, .-main
	.data
	.align 8
	.type	__iterations.0, @object
	.size	__iterations.0, 8
__iterations.0:
	.quad	1
	.align 8
	.type	__iterations.1, @object
	.size	__iterations.1, 8
__iterations.1:
	.quad	1
	.globl	id
	.section	.rodata.str1.1
.LC15:
	.string	"$Id$\n"
	.section	.data.rel.local,"aw"
	.align 8
	.type	id, @object
	.size	id, 8
id:
	.quad	.LC15
	.section	.rodata.cst8,"aM",@progbits,8
	.align 8
.LC0:
	.long	0
	.long	0
	.align 8
.LC1:
	.long	1717986918
	.long	1072588390
	.align 8
.LC2:
	.long	2061584302
	.long	1072672276
	.align 8
.LC3:
	.long	858993459
	.long	1072902963
	.align 8
.LC4:
	.long	0
	.long	1080213504
	.align 8
.LC5:
	.long	-1717986918
	.long	1072798105
	.align 8
.LC6:
	.long	0
	.long	1072693248
	.align 8
.LC7:
	.long	0
	.long	1138753536
	.align 8
.LC8:
	.long	0
	.long	1083129856
	.align 8
.LC9:
	.long	0
	.long	1079574528
	.align 8
.LC10:
	.long	1717986918
	.long	1072850534
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
