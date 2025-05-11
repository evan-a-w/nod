	.file	"tlb.c"
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
	.string	"[-c] [-L <line size>] [-M len[K|M]] [-W <warmup>] [-N <repetitions>]\n"
.LC2:
	.string	"cL:M:W:N:"
	.align 8
.LC3:
	.string	"tlb: %d pages %.5f nanoseconds\n"
.LC4:
	.string	"tlb: %d pages\n"
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
	movl	$0, -284(%rbp)
	movl	$0, -280(%rbp)
	movl	$0, %edi
	call	get_enough@PLT
	cmpl	$999999, %eax
	jle	.L2
	movl	$1, %eax
	jmp	.L3
.L2:
	movl	$11, %eax
.L3:
	movl	%eax, -276(%rbp)
	leaq	.LC1(%rip), %rax
	movq	%rax, -248(%rbp)
	movl	$16384, -288(%rbp)
	movl	$1, -92(%rbp)
	call	getpagesize@PLT
	cltq
	movq	%rax, -64(%rbp)
	movq	$8, -72(%rbp)
	movl	$2, -272(%rbp)
	jmp	.L4
.L12:
	movl	-268(%rbp), %eax
	subl	$76, %eax
	cmpl	$23, %eax
	ja	.L5
	movl	%eax, %eax
	leaq	0(,%rax,4), %rdx
	leaq	.L7(%rip), %rax
	movl	(%rdx,%rax), %eax
	cltq
	leaq	.L7(%rip), %rdx
	addq	%rdx, %rax
	notrack jmp	*%rax
	.section	.rodata
	.align 4
	.align 4
.L7:
	.long	.L11-.L7
	.long	.L10-.L7
	.long	.L9-.L7
	.long	.L5-.L7
	.long	.L5-.L7
	.long	.L5-.L7
	.long	.L5-.L7
	.long	.L5-.L7
	.long	.L5-.L7
	.long	.L5-.L7
	.long	.L5-.L7
	.long	.L8-.L7
	.long	.L5-.L7
	.long	.L5-.L7
	.long	.L5-.L7
	.long	.L5-.L7
	.long	.L5-.L7
	.long	.L5-.L7
	.long	.L5-.L7
	.long	.L5-.L7
	.long	.L5-.L7
	.long	.L5-.L7
	.long	.L5-.L7
	.long	.L6-.L7
	.text
.L6:
	movl	$1, -284(%rbp)
	jmp	.L4
.L11:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	cltq
	movq	%rax, -72(%rbp)
	jmp	.L4
.L10:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	bytes@PLT
	movl	%eax, -288(%rbp)
	call	getpagesize@PLT
	movl	%eax, %esi
	movl	-288(%rbp), %eax
	cltd
	idivl	%esi
	movl	%eax, -288(%rbp)
	jmp	.L4
.L8:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -280(%rbp)
	jmp	.L4
.L9:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -276(%rbp)
	jmp	.L4
.L5:
	movq	-248(%rbp), %rdx
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
	jne	.L12
	leaq	-256(%rbp), %r8
	leaq	-264(%rbp), %rdi
	movl	-276(%rbp), %ecx
	movl	-280(%rbp), %edx
	movl	-288(%rbp), %eax
	subq	$8, %rsp
	leaq	-240(%rbp), %rsi
	pushq	%rsi
	movq	%r8, %r9
	movq	%rdi, %r8
	movl	%eax, %esi
	movl	$8, %edi
	call	find_tlb
	addq	$16, %rsp
	movl	%eax, -272(%rbp)
	cmpl	$0, -272(%rbp)
	jle	.L13
	cmpl	$0, -284(%rbp)
	je	.L14
	movl	-272(%rbp), %eax
	leal	(%rax,%rax), %edi
	leaq	-240(%rbp), %r8
	leaq	-256(%rbp), %rsi
	leaq	-264(%rbp), %rcx
	movl	-276(%rbp), %edx
	movl	-280(%rbp), %eax
	movq	%r8, %r9
	movq	%rsi, %r8
	movl	%eax, %esi
	call	compute_times
	movsd	-264(%rbp), %xmm0
	movsd	-256(%rbp), %xmm1
	subsd	%xmm1, %xmm0
	movq	%xmm0, %rcx
	movq	stderr(%rip), %rax
	movl	-272(%rbp), %edx
	movq	%rcx, %xmm0
	leaq	.LC3(%rip), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	movl	$1, %eax
	call	fprintf@PLT
	jmp	.L13
.L14:
	movq	stderr(%rip), %rax
	movl	-272(%rbp), %edx
	leaq	.LC4(%rip), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf@PLT
.L13:
	movl	$0, %eax
	movq	-8(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L16
	call	__stack_chk_fail@PLT
.L16:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE8:
	.size	main, .-main
	.globl	find_tlb
	.type	find_tlb, @function
find_tlb:
.LFB9:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$48, %rsp
	movl	%edi, -20(%rbp)
	movl	%esi, -24(%rbp)
	movl	%edx, -28(%rbp)
	movl	%ecx, -32(%rbp)
	movq	%r8, -40(%rbp)
	movq	%r9, -48(%rbp)
	movl	-20(%rbp), %eax
	movl	%eax, -12(%rbp)
	jmp	.L18
.L22:
	movq	-48(%rbp), %rdi
	movq	-40(%rbp), %rcx
	movl	-32(%rbp), %edx
	movl	-28(%rbp), %esi
	movl	-12(%rbp), %eax
	movq	16(%rbp), %r9
	movq	%rdi, %r8
	movl	%eax, %edi
	call	compute_times
	movq	-40(%rbp), %rax
	movsd	(%rax), %xmm0
	movq	-48(%rbp), %rax
	movsd	(%rax), %xmm1
	divsd	%xmm1, %xmm0
	comisd	.LC5(%rip), %xmm0
	jbe	.L32
	movl	-12(%rbp), %eax
	sarl	%eax
	movl	%eax, -8(%rbp)
	movl	-12(%rbp), %eax
	movl	%eax, -4(%rbp)
	movl	-4(%rbp), %eax
	subl	-8(%rbp), %eax
	movl	%eax, %edx
	shrl	$31, %edx
	addl	%edx, %eax
	sarl	%eax
	movl	%eax, %edx
	movl	-8(%rbp), %eax
	addl	%edx, %eax
	movl	%eax, -12(%rbp)
	jmp	.L21
.L32:
	sall	-12(%rbp)
.L18:
	movl	-12(%rbp), %eax
	cmpl	-24(%rbp), %eax
	jle	.L22
.L21:
	movl	-12(%rbp), %eax
	cmpl	-24(%rbp), %eax
	jl	.L25
	movq	16(%rbp), %rax
	movq	$0, 152(%rax)
	movl	$0, %eax
	jmp	.L24
.L29:
	movq	-48(%rbp), %rdi
	movq	-40(%rbp), %rcx
	movl	-32(%rbp), %edx
	movl	-28(%rbp), %esi
	movl	-12(%rbp), %eax
	movq	16(%rbp), %r9
	movq	%rdi, %r8
	movl	%eax, %edi
	call	compute_times
	movq	-40(%rbp), %rax
	movsd	(%rax), %xmm0
	movq	-48(%rbp), %rax
	movsd	(%rax), %xmm1
	divsd	%xmm1, %xmm0
	comisd	.LC5(%rip), %xmm0
	jbe	.L33
	movl	-12(%rbp), %eax
	movl	%eax, -4(%rbp)
	jmp	.L28
.L33:
	movl	-12(%rbp), %eax
	movl	%eax, -8(%rbp)
.L28:
	movl	-4(%rbp), %eax
	subl	-8(%rbp), %eax
	movl	%eax, %edx
	shrl	$31, %edx
	addl	%edx, %eax
	sarl	%eax
	movl	%eax, %edx
	movl	-8(%rbp), %eax
	addl	%edx, %eax
	movl	%eax, -12(%rbp)
.L25:
	movl	-8(%rbp), %eax
	addl	$1, %eax
	cmpl	%eax, -4(%rbp)
	jg	.L29
	movl	-8(%rbp), %eax
.L24:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE9:
	.size	find_tlb, .-find_tlb
	.globl	compute_times
	.type	compute_times, @function
compute_times:
.LFB10:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%rbx
	subq	$552, %rsp
	.cfi_offset 3, -24
	movl	%edi, -500(%rbp)
	movl	%esi, -504(%rbp)
	movl	%edx, -508(%rbp)
	movq	%rcx, -520(%rbp)
	movq	%r8, -528(%rbp)
	movq	%r9, -536(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -24(%rbp)
	xorl	%eax, %eax
	movl	$0, %eax
	call	get_results@PLT
	movq	%rax, -440(%rbp)
	leaq	-400(%rbp), %rax
	movq	%rax, %rdi
	call	insertinit@PLT
	leaq	-208(%rbp), %rax
	movq	%rax, %rdi
	call	insertinit@PLT
	movl	-500(%rbp), %eax
	movslq	%eax, %rdx
	movq	-536(%rbp), %rax
	movq	176(%rax), %rax
	imulq	%rax, %rdx
	movq	-536(%rbp), %rax
	movq	%rdx, 152(%rax)
	movl	-500(%rbp), %eax
	movslq	%eax, %rdx
	movq	-536(%rbp), %rax
	movq	176(%rax), %rax
	imulq	%rax, %rdx
	movq	-536(%rbp), %rax
	movq	%rdx, 160(%rax)
	movq	-536(%rbp), %rax
	movq	%rax, %rsi
	movl	$0, %edi
	call	tlb_initialize@PLT
	movq	-536(%rbp), %rax
	movl	144(%rax), %eax
	testl	%eax, %eax
	je	.L35
	movl	$0, -484(%rbp)
	jmp	.L36
.L66:
	movl	$0, %edi
	call	get_enough@PLT
	movl	%eax, -480(%rbp)
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -464(%rbp)
	jmp	.L37
.L52:
	movl	$0, %edi
	call	start@PLT
	movq	__iterations.1(%rip), %rax
	movq	%rax, -472(%rbp)
	jmp	.L38
.L39:
	movq	-536(%rbp), %rdx
	movq	-472(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	mem_benchmark_0@PLT
	movq	$1, -472(%rbp)
	subq	$1, -472(%rbp)
.L38:
	cmpq	$0, -472(%rbp)
	jne	.L39
	movl	$0, %esi
	movl	$0, %edi
	call	stop@PLT
	testq	%rax, %rax
	js	.L40
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L41
.L40:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L41:
	movsd	%xmm0, -464(%rbp)
	pxor	%xmm1, %xmm1
	cvtsi2sdl	-480(%rbp), %xmm1
	movsd	.LC7(%rip), %xmm0
	mulsd	%xmm1, %xmm0
	comisd	-464(%rbp), %xmm0
	ja	.L42
	pxor	%xmm1, %xmm1
	cvtsi2sdl	-480(%rbp), %xmm1
	movsd	.LC8(%rip), %xmm0
	mulsd	%xmm0, %xmm1
	movsd	-464(%rbp), %xmm0
	comisd	%xmm1, %xmm0
	ja	.L42
	jmp	.L37
.L42:
	movsd	-464(%rbp), %xmm0
	comisd	.LC9(%rip), %xmm0
	jbe	.L112
	movq	__iterations.1(%rip), %rax
	testq	%rax, %rax
	js	.L46
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L47
.L46:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L47:
	divsd	-464(%rbp), %xmm0
	movsd	%xmm0, -432(%rbp)
	pxor	%xmm1, %xmm1
	cvtsi2sdl	-480(%rbp), %xmm1
	movsd	.LC10(%rip), %xmm0
	mulsd	%xmm1, %xmm0
	movsd	-432(%rbp), %xmm1
	mulsd	%xmm1, %xmm0
	movsd	%xmm0, -432(%rbp)
	movsd	-432(%rbp), %xmm1
	movsd	.LC11(%rip), %xmm0
	addsd	%xmm1, %xmm0
	comisd	.LC12(%rip), %xmm0
	jnb	.L48
	cvttsd2siq	%xmm0, %rax
	jmp	.L49
.L48:
	movsd	.LC12(%rip), %xmm1
	subsd	%xmm1, %xmm0
	cvttsd2siq	%xmm0, %rax
	movabsq	$-9223372036854775808, %rdx
	xorq	%rdx, %rax
.L49:
	movq	%rax, __iterations.1(%rip)
	jmp	.L37
.L112:
	movq	__iterations.1(%rip), %rax
	cmpq	$134217728, %rax
	jbe	.L50
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -464(%rbp)
	jmp	.L51
.L50:
	movq	__iterations.1(%rip), %rax
	salq	$3, %rax
	movq	%rax, __iterations.1(%rip)
.L37:
	pxor	%xmm1, %xmm1
	cvtsi2sdl	-480(%rbp), %xmm1
	movsd	.LC13(%rip), %xmm0
	mulsd	%xmm1, %xmm0
	comisd	-464(%rbp), %xmm0
	ja	.L52
.L51:
	movq	__iterations.1(%rip), %rax
	movq	%rax, %rdi
	call	save_n@PLT
	movsd	-464(%rbp), %xmm0
	comisd	.LC12(%rip), %xmm0
	jnb	.L53
	movsd	-464(%rbp), %xmm0
	cvttsd2siq	%xmm0, %rax
	jmp	.L54
.L53:
	movsd	-464(%rbp), %xmm0
	movsd	.LC12(%rip), %xmm1
	subsd	%xmm1, %xmm0
	cvttsd2siq	%xmm0, %rax
	movabsq	$-9223372036854775808, %rdx
	xorq	%rdx, %rax
.L54:
	movq	%rax, %rdi
	call	settime@PLT
	call	usecs_spent@PLT
	testq	%rax, %rax
	js	.L55
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L56
.L55:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L56:
	movsd	%xmm0, -424(%rbp)
	call	t_overhead@PLT
	testq	%rax, %rax
	js	.L57
	pxor	%xmm2, %xmm2
	cvtsi2sdq	%rax, %xmm2
	movsd	%xmm2, -544(%rbp)
	jmp	.L58
.L57:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
	movsd	%xmm0, -544(%rbp)
.L58:
	call	get_n@PLT
	testq	%rax, %rax
	js	.L59
	pxor	%xmm3, %xmm3
	cvtsi2sdq	%rax, %xmm3
	movsd	%xmm3, -552(%rbp)
	jmp	.L60
.L59:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
	movsd	%xmm0, -552(%rbp)
.L60:
	call	l_overhead@PLT
	mulsd	-552(%rbp), %xmm0
	movsd	-544(%rbp), %xmm1
	addsd	%xmm0, %xmm1
	movsd	-424(%rbp), %xmm0
	subsd	%xmm1, %xmm0
	movsd	%xmm0, -424(%rbp)
	movsd	-424(%rbp), %xmm0
	pxor	%xmm1, %xmm1
	comisd	%xmm1, %xmm0
	jb	.L113
	movsd	-424(%rbp), %xmm0
	comisd	.LC12(%rip), %xmm0
	jnb	.L63
	movsd	-424(%rbp), %xmm0
	cvttsd2siq	%xmm0, %rax
	jmp	.L65
.L63:
	movsd	-424(%rbp), %xmm0
	movsd	.LC12(%rip), %xmm1
	subsd	%xmm1, %xmm0
	cvttsd2siq	%xmm0, %rax
	movabsq	$-9223372036854775808, %rdx
	xorq	%rdx, %rax
	jmp	.L65
.L113:
	movl	$0, %eax
.L65:
	movq	%rax, %rdi
	call	settime@PLT
	call	get_n@PLT
	movq	%rax, %rbx
	call	usecs_spent@PLT
	movq	%rax, %rcx
	leaq	-400(%rbp), %rax
	movq	%rax, %rdx
	movq	%rbx, %rsi
	movq	%rcx, %rdi
	call	insertsort@PLT
	addl	$1, -484(%rbp)
.L36:
	cmpl	$10, -484(%rbp)
	jle	.L66
.L35:
	movq	-536(%rbp), %rax
	movq	%rax, %rsi
	movl	$0, %edi
	call	tlb_cleanup@PLT
	movl	-500(%rbp), %eax
	movslq	%eax, %rdx
	movq	-536(%rbp), %rax
	movq	168(%rax), %rax
	imulq	%rax, %rdx
	movq	-536(%rbp), %rax
	movq	%rdx, 152(%rax)
	movl	-500(%rbp), %eax
	movslq	%eax, %rdx
	movq	-536(%rbp), %rax
	movq	168(%rax), %rax
	imulq	%rax, %rdx
	movq	-536(%rbp), %rax
	movq	%rdx, 160(%rax)
	movq	-536(%rbp), %rax
	movq	%rax, %rsi
	movl	$0, %edi
	call	mem_initialize@PLT
	movq	-536(%rbp), %rax
	movl	144(%rax), %eax
	testl	%eax, %eax
	je	.L67
	movl	$0, -484(%rbp)
	jmp	.L68
.L98:
	movl	$0, %edi
	call	get_enough@PLT
	movl	%eax, -476(%rbp)
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -448(%rbp)
	jmp	.L69
.L84:
	movl	$0, %edi
	call	start@PLT
	movq	__iterations.0(%rip), %rax
	movq	%rax, -456(%rbp)
	jmp	.L70
.L71:
	movq	-536(%rbp), %rdx
	movq	-456(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	mem_benchmark_0@PLT
	movq	$1, -456(%rbp)
	subq	$1, -456(%rbp)
.L70:
	cmpq	$0, -456(%rbp)
	jne	.L71
	movl	$0, %esi
	movl	$0, %edi
	call	stop@PLT
	testq	%rax, %rax
	js	.L72
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L73
.L72:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L73:
	movsd	%xmm0, -448(%rbp)
	pxor	%xmm1, %xmm1
	cvtsi2sdl	-476(%rbp), %xmm1
	movsd	.LC7(%rip), %xmm0
	mulsd	%xmm1, %xmm0
	comisd	-448(%rbp), %xmm0
	ja	.L74
	pxor	%xmm1, %xmm1
	cvtsi2sdl	-476(%rbp), %xmm1
	movsd	.LC8(%rip), %xmm0
	mulsd	%xmm0, %xmm1
	movsd	-448(%rbp), %xmm0
	comisd	%xmm1, %xmm0
	ja	.L74
	jmp	.L69
.L74:
	movsd	-448(%rbp), %xmm0
	comisd	.LC9(%rip), %xmm0
	jbe	.L114
	movq	__iterations.0(%rip), %rax
	testq	%rax, %rax
	js	.L78
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L79
.L78:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L79:
	divsd	-448(%rbp), %xmm0
	movsd	%xmm0, -416(%rbp)
	pxor	%xmm1, %xmm1
	cvtsi2sdl	-476(%rbp), %xmm1
	movsd	.LC10(%rip), %xmm0
	mulsd	%xmm1, %xmm0
	movsd	-416(%rbp), %xmm1
	mulsd	%xmm1, %xmm0
	movsd	%xmm0, -416(%rbp)
	movsd	-416(%rbp), %xmm1
	movsd	.LC11(%rip), %xmm0
	addsd	%xmm1, %xmm0
	comisd	.LC12(%rip), %xmm0
	jnb	.L80
	cvttsd2siq	%xmm0, %rax
	jmp	.L81
.L80:
	movsd	.LC12(%rip), %xmm1
	subsd	%xmm1, %xmm0
	cvttsd2siq	%xmm0, %rax
	movabsq	$-9223372036854775808, %rdx
	xorq	%rdx, %rax
.L81:
	movq	%rax, __iterations.0(%rip)
	jmp	.L69
.L114:
	movq	__iterations.0(%rip), %rax
	cmpq	$134217728, %rax
	jbe	.L82
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -448(%rbp)
	jmp	.L83
.L82:
	movq	__iterations.0(%rip), %rax
	salq	$3, %rax
	movq	%rax, __iterations.0(%rip)
.L69:
	pxor	%xmm1, %xmm1
	cvtsi2sdl	-476(%rbp), %xmm1
	movsd	.LC13(%rip), %xmm0
	mulsd	%xmm1, %xmm0
	comisd	-448(%rbp), %xmm0
	ja	.L84
.L83:
	movq	__iterations.0(%rip), %rax
	movq	%rax, %rdi
	call	save_n@PLT
	movsd	-448(%rbp), %xmm0
	comisd	.LC12(%rip), %xmm0
	jnb	.L85
	movsd	-448(%rbp), %xmm0
	cvttsd2siq	%xmm0, %rax
	jmp	.L86
.L85:
	movsd	-448(%rbp), %xmm0
	movsd	.LC12(%rip), %xmm1
	subsd	%xmm1, %xmm0
	cvttsd2siq	%xmm0, %rax
	movabsq	$-9223372036854775808, %rdx
	xorq	%rdx, %rax
.L86:
	movq	%rax, %rdi
	call	settime@PLT
	call	usecs_spent@PLT
	testq	%rax, %rax
	js	.L87
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L88
.L87:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L88:
	movsd	%xmm0, -408(%rbp)
	call	t_overhead@PLT
	testq	%rax, %rax
	js	.L89
	pxor	%xmm5, %xmm5
	cvtsi2sdq	%rax, %xmm5
	movsd	%xmm5, -544(%rbp)
	jmp	.L90
.L89:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
	movsd	%xmm0, -544(%rbp)
.L90:
	call	get_n@PLT
	testq	%rax, %rax
	js	.L91
	pxor	%xmm6, %xmm6
	cvtsi2sdq	%rax, %xmm6
	movsd	%xmm6, -552(%rbp)
	jmp	.L92
.L91:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
	movsd	%xmm0, -552(%rbp)
.L92:
	call	l_overhead@PLT
	mulsd	-552(%rbp), %xmm0
	movsd	-544(%rbp), %xmm1
	addsd	%xmm0, %xmm1
	movsd	-408(%rbp), %xmm0
	subsd	%xmm1, %xmm0
	movsd	%xmm0, -408(%rbp)
	movsd	-408(%rbp), %xmm0
	pxor	%xmm1, %xmm1
	comisd	%xmm1, %xmm0
	jb	.L115
	movsd	-408(%rbp), %xmm0
	comisd	.LC12(%rip), %xmm0
	jnb	.L95
	movsd	-408(%rbp), %xmm0
	cvttsd2siq	%xmm0, %rax
	jmp	.L97
.L95:
	movsd	-408(%rbp), %xmm0
	movsd	.LC12(%rip), %xmm1
	subsd	%xmm1, %xmm0
	cvttsd2siq	%xmm0, %rax
	movabsq	$-9223372036854775808, %rdx
	xorq	%rdx, %rax
	jmp	.L97
.L115:
	movl	$0, %eax
.L97:
	movq	%rax, %rdi
	call	settime@PLT
	call	get_n@PLT
	movq	%rax, %rbx
	call	usecs_spent@PLT
	movq	%rax, %rcx
	leaq	-208(%rbp), %rax
	movq	%rax, %rdx
	movq	%rbx, %rsi
	movq	%rcx, %rdi
	call	insertsort@PLT
	addl	$1, -484(%rbp)
.L68:
	cmpl	$10, -484(%rbp)
	jle	.L98
.L67:
	movq	-536(%rbp), %rax
	movq	%rax, %rsi
	movl	$0, %edi
	call	mem_cleanup@PLT
	leaq	-400(%rbp), %rax
	movq	%rax, %rdi
	call	set_results@PLT
	call	usecs_spent@PLT
	testq	%rax, %rax
	js	.L99
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L100
.L99:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L100:
	movsd	.LC14(%rip), %xmm1
	mulsd	%xmm1, %xmm0
	movsd	%xmm0, -544(%rbp)
	call	get_n@PLT
	testq	%rax, %rax
	js	.L101
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L102
.L101:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L102:
	movsd	.LC15(%rip), %xmm1
	mulsd	%xmm0, %xmm1
	movsd	-544(%rbp), %xmm0
	divsd	%xmm1, %xmm0
	movq	-520(%rbp), %rax
	movsd	%xmm0, (%rax)
	leaq	-208(%rbp), %rax
	movq	%rax, %rdi
	call	set_results@PLT
	call	usecs_spent@PLT
	testq	%rax, %rax
	js	.L103
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L104
.L103:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L104:
	movsd	.LC14(%rip), %xmm1
	mulsd	%xmm1, %xmm0
	movsd	%xmm0, -544(%rbp)
	call	get_n@PLT
	testq	%rax, %rax
	js	.L105
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L106
.L105:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L106:
	movsd	.LC15(%rip), %xmm1
	mulsd	%xmm0, %xmm1
	movsd	-544(%rbp), %xmm0
	divsd	%xmm1, %xmm0
	movq	-528(%rbp), %rax
	movsd	%xmm0, (%rax)
	movq	-440(%rbp), %rax
	movq	%rax, %rdi
	call	set_results@PLT
	nop
	movq	-24(%rbp), %rax
	subq	%fs:40, %rax
	je	.L107
	call	__stack_chk_fail@PLT
.L107:
	movq	-8(%rbp), %rbx
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE10:
	.size	compute_times, .-compute_times
	.data
	.align 8
	.type	__iterations.1, @object
	.size	__iterations.1, 8
__iterations.1:
	.quad	1
	.align 8
	.type	__iterations.0, @object
	.size	__iterations.0, 8
__iterations.0:
	.quad	1
	.section	.rodata
	.align 8
.LC5:
	.long	1717986918
	.long	1072850534
	.align 8
.LC7:
	.long	2061584302
	.long	1072672276
	.align 8
.LC8:
	.long	858993459
	.long	1072902963
	.align 8
.LC9:
	.long	0
	.long	1080213504
	.align 8
.LC10:
	.long	-1717986918
	.long	1072798105
	.align 8
.LC11:
	.long	0
	.long	1072693248
	.align 8
.LC12:
	.long	0
	.long	1138753536
	.align 8
.LC13:
	.long	1717986918
	.long	1072588390
	.align 8
.LC14:
	.long	0
	.long	1083129856
	.align 8
.LC15:
	.long	0
	.long	1079574528
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
