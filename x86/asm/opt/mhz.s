	.file	"mhz.c"
	.text
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"p=(TYPE**)*p;"
	.text
	.globl	name_1
	.type	name_1, @function
name_1:
.LFB72:
	.cfi_startproc
	endbr64
	leaq	.LC0(%rip), %rax
	ret
	.cfi_endproc
.LFE72:
	.size	name_1, .-name_1
	.globl	_mhz_1
	.type	_mhz_1, @function
_mhz_1:
.LFB73:
	.cfi_startproc
	endbr64
	movq	%rdi, %rax
	movq	%rdx, %rdi
	testq	%rax, %rax
	jle	.L3
.L4:
	movq	(%rsi), %rdx
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
	movq	(%rdx), %rsi
	subq	$1, %rax
	jne	.L4
.L3:
	addq	%rcx, %rdi
	leaq	(%rsi,%rdi,8), %rax
	ret
	.cfi_endproc
.LFE73:
	.size	_mhz_1, .-_mhz_1
	.globl	mhz_1
	.type	mhz_1, @function
mhz_1:
.LFB74:
	.cfi_startproc
	endbr64
	pushq	%r14
	.cfi_def_cfa_offset 16
	.cfi_offset 14, -16
	pushq	%r12
	.cfi_def_cfa_offset 24
	.cfi_offset 12, -24
	pushq	%rbp
	.cfi_def_cfa_offset 32
	.cfi_offset 6, -32
	pushq	%rbx
	.cfi_def_cfa_offset 40
	.cfi_offset 3, -40
	subq	$40, %rsp
	.cfi_def_cfa_offset 80
	movq	%fs:40, %rax
	movq	%rax, 24(%rsp)
	xorl	%eax, %eax
	leaq	16(%rsp), %rax
	movq	%rax, 16(%rsp)
	call	get_enough@PLT
	pxor	%xmm6, %xmm6
	cvtsi2sdl	%eax, %xmm6
	movsd	%xmm6, 8(%rsp)
	mulsd	.LC2(%rip), %xmm6
	movq	%xmm6, %rbp
	movl	$0, %ebx
	comisd	.LC1(%rip), %xmm6
	ja	.L21
	pxor	%xmm5, %xmm5
	movsd	%xmm5, (%rsp)
	movl	$0, %ebx
	jmp	.L7
.L10:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
	movsd	%xmm0, (%rsp)
	jmp	.L11
.L17:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rdx, %xmm1
	addsd	%xmm1, %xmm1
	jmp	.L18
.L19:
	subsd	.LC8(%rip), %xmm0
	cvttsd2siq	%xmm0, %rax
	movq	%rax, __iterations.8(%rip)
	btcq	$63, __iterations.8(%rip)
	jmp	.L13
.L44:
	movq	__iterations.8(%rip), %rax
	cmpq	$134217728, %rax
	ja	.L36
	salq	$3, %rax
	movq	%rax, __iterations.8(%rip)
.L13:
	movq	%rbp, %xmm4
	comisd	(%rsp), %xmm4
	jbe	.L7
.L21:
	movl	$0, %edi
	call	start@PLT
	movq	__iterations.8(%rip), %rdi
	testq	%rdi, %rdi
	je	.L9
	leaq	16(%rsp), %rsi
	movl	$1, %ecx
	movl	$1, %edx
	call	_mhz_1
	movq	%rax, %rbx
.L9:
	movl	$0, %esi
	movl	$0, %edi
	call	stop@PLT
	testq	%rax, %rax
	js	.L10
	pxor	%xmm7, %xmm7
	cvtsi2sdq	%rax, %xmm7
	movsd	%xmm7, (%rsp)
.L11:
	movsd	.LC3(%rip), %xmm0
	movsd	8(%rsp), %xmm2
	mulsd	%xmm2, %xmm0
	movsd	(%rsp), %xmm3
	comisd	%xmm3, %xmm0
	ja	.L12
	mulsd	.LC4(%rip), %xmm2
	comisd	%xmm2, %xmm3
	jbe	.L13
.L12:
	movsd	(%rsp), %xmm6
	comisd	.LC5(%rip), %xmm6
	jbe	.L44
	movq	__iterations.8(%rip), %rax
	testq	%rax, %rax
	js	.L17
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rax, %xmm1
.L18:
	divsd	(%rsp), %xmm1
	movsd	8(%rsp), %xmm0
	mulsd	.LC6(%rip), %xmm0
	mulsd	%xmm1, %xmm0
	addsd	.LC7(%rip), %xmm0
	comisd	.LC8(%rip), %xmm0
	jnb	.L19
	cvttsd2siq	%xmm0, %rax
	movq	%rax, __iterations.8(%rip)
	jmp	.L13
.L36:
	pxor	%xmm5, %xmm5
	movsd	%xmm5, (%rsp)
.L7:
	movq	__iterations.8(%rip), %rdi
	call	save_n@PLT
	movsd	(%rsp), %xmm7
	comisd	.LC8(%rip), %xmm7
	jnb	.L22
	cvttsd2siq	%xmm7, %rdi
.L23:
	call	settime@PLT
	call	usecs_spent@PLT
	testq	%rax, %rax
	js	.L24
	pxor	%xmm4, %xmm4
	cvtsi2sdq	%rax, %xmm4
	movq	%xmm4, %r14
.L25:
	call	t_overhead@PLT
	movq	%rax, %rbp
	call	get_n@PLT
	movq	%rax, %r12
	call	l_overhead@PLT
	movapd	%xmm0, %xmm1
	testq	%r12, %r12
	js	.L26
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%r12, %xmm0
.L27:
	mulsd	%xmm1, %xmm0
	testq	%rbp, %rbp
	js	.L28
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rbp, %xmm1
.L29:
	addsd	%xmm1, %xmm0
	movq	%r14, %xmm1
	subsd	%xmm0, %xmm1
	movl	$0, %edi
	comisd	.LC1(%rip), %xmm1
	jb	.L30
	comisd	.LC8(%rip), %xmm1
	jnb	.L32
	cvttsd2siq	%xmm1, %rdi
.L30:
	call	settime@PLT
	movq	%rbx, %rdi
	call	use_pointer@PLT
	call	get_n@PLT
	leaq	(%rax,%rax,4), %rax
	leaq	(%rax,%rax,4), %rdi
	salq	$2, %rdi
	call	save_n@PLT
	movq	24(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L47
	addq	$40, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 40
	popq	%rbx
	.cfi_def_cfa_offset 32
	popq	%rbp
	.cfi_def_cfa_offset 24
	popq	%r12
	.cfi_def_cfa_offset 16
	popq	%r14
	.cfi_def_cfa_offset 8
	ret
.L22:
	.cfi_restore_state
	movsd	(%rsp), %xmm0
	subsd	.LC8(%rip), %xmm0
	cvttsd2siq	%xmm0, %rdi
	btcq	$63, %rdi
	jmp	.L23
.L24:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rdx, %xmm1
	addsd	%xmm1, %xmm1
	movq	%xmm1, %r14
	jmp	.L25
.L26:
	movq	%r12, %rax
	shrq	%rax
	andl	$1, %r12d
	orq	%r12, %rax
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	addsd	%xmm0, %xmm0
	jmp	.L27
.L28:
	movq	%rbp, %rax
	shrq	%rax
	andl	$1, %ebp
	orq	%rbp, %rax
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rax, %xmm1
	addsd	%xmm1, %xmm1
	jmp	.L29
.L32:
	subsd	.LC8(%rip), %xmm1
	cvttsd2siq	%xmm1, %rdi
	btcq	$63, %rdi
	jmp	.L30
.L47:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE74:
	.size	mhz_1, .-mhz_1
	.section	.rodata.str1.1
.LC9:
	.string	"a^=a+a;"
	.text
	.globl	name_2
	.type	name_2, @function
name_2:
.LFB75:
	.cfi_startproc
	endbr64
	leaq	.LC9(%rip), %rax
	ret
	.cfi_endproc
.LFE75:
	.size	name_2, .-name_2
	.globl	_mhz_2
	.type	_mhz_2, @function
_mhz_2:
.LFB76:
	.cfi_startproc
	endbr64
	testq	%rdi, %rdi
	jle	.L50
.L51:
	leaq	(%rdx,%rdx), %rax
	xorq	%rdx, %rax
	leaq	(%rax,%rax), %rdx
	xorq	%rax, %rdx
	leaq	(%rdx,%rdx), %rax
	xorq	%rdx, %rax
	leaq	(%rax,%rax), %rdx
	xorq	%rax, %rdx
	leaq	(%rdx,%rdx), %rax
	xorq	%rdx, %rax
	leaq	(%rax,%rax), %rdx
	xorq	%rax, %rdx
	leaq	(%rdx,%rdx), %rax
	xorq	%rdx, %rax
	leaq	(%rax,%rax), %rdx
	xorq	%rax, %rdx
	leaq	(%rdx,%rdx), %rax
	xorq	%rdx, %rax
	leaq	(%rax,%rax), %rdx
	xorq	%rax, %rdx
	leaq	(%rdx,%rdx), %rax
	xorq	%rdx, %rax
	leaq	(%rax,%rax), %rdx
	xorq	%rax, %rdx
	leaq	(%rdx,%rdx), %rax
	xorq	%rdx, %rax
	leaq	(%rax,%rax), %rdx
	xorq	%rax, %rdx
	leaq	(%rdx,%rdx), %rax
	xorq	%rdx, %rax
	leaq	(%rax,%rax), %rdx
	xorq	%rax, %rdx
	leaq	(%rdx,%rdx), %rax
	xorq	%rdx, %rax
	leaq	(%rax,%rax), %rdx
	xorq	%rax, %rdx
	leaq	(%rdx,%rdx), %rax
	xorq	%rdx, %rax
	leaq	(%rax,%rax), %rdx
	xorq	%rax, %rdx
	leaq	(%rdx,%rdx), %rax
	xorq	%rdx, %rax
	leaq	(%rax,%rax), %rdx
	xorq	%rax, %rdx
	leaq	(%rdx,%rdx), %rax
	xorq	%rdx, %rax
	leaq	(%rax,%rax), %rdx
	xorq	%rax, %rdx
	leaq	(%rdx,%rdx), %rax
	xorq	%rdx, %rax
	leaq	(%rax,%rax), %rdx
	xorq	%rax, %rdx
	leaq	(%rdx,%rdx), %rax
	xorq	%rdx, %rax
	leaq	(%rax,%rax), %rdx
	xorq	%rax, %rdx
	leaq	(%rdx,%rdx), %rax
	xorq	%rdx, %rax
	leaq	(%rax,%rax), %rdx
	xorq	%rax, %rdx
	leaq	(%rdx,%rdx), %rax
	xorq	%rdx, %rax
	leaq	(%rax,%rax), %rdx
	xorq	%rax, %rdx
	leaq	(%rdx,%rdx), %rax
	xorq	%rdx, %rax
	leaq	(%rax,%rax), %rdx
	xorq	%rax, %rdx
	leaq	(%rdx,%rdx), %rax
	xorq	%rdx, %rax
	leaq	(%rax,%rax), %rdx
	xorq	%rax, %rdx
	leaq	(%rdx,%rdx), %rax
	xorq	%rdx, %rax
	leaq	(%rax,%rax), %rdx
	xorq	%rax, %rdx
	leaq	(%rdx,%rdx), %rax
	xorq	%rdx, %rax
	leaq	(%rax,%rax), %rdx
	xorq	%rax, %rdx
	leaq	(%rdx,%rdx), %rax
	xorq	%rdx, %rax
	leaq	(%rax,%rax), %rdx
	xorq	%rax, %rdx
	leaq	(%rdx,%rdx), %rax
	xorq	%rdx, %rax
	leaq	(%rax,%rax), %rdx
	xorq	%rax, %rdx
	leaq	(%rdx,%rdx), %rax
	xorq	%rdx, %rax
	leaq	(%rax,%rax), %rdx
	xorq	%rax, %rdx
	leaq	(%rdx,%rdx), %rax
	xorq	%rdx, %rax
	leaq	(%rax,%rax), %rdx
	xorq	%rax, %rdx
	leaq	(%rdx,%rdx), %rax
	xorq	%rdx, %rax
	leaq	(%rax,%rax), %rdx
	xorq	%rax, %rdx
	leaq	(%rdx,%rdx), %rax
	xorq	%rdx, %rax
	leaq	(%rax,%rax), %rdx
	xorq	%rax, %rdx
	leaq	(%rdx,%rdx), %rax
	xorq	%rdx, %rax
	leaq	(%rax,%rax), %rdx
	xorq	%rax, %rdx
	leaq	(%rdx,%rdx), %rax
	xorq	%rdx, %rax
	leaq	(%rax,%rax), %rdx
	xorq	%rax, %rdx
	leaq	(%rdx,%rdx), %rax
	xorq	%rdx, %rax
	leaq	(%rax,%rax), %rdx
	xorq	%rax, %rdx
	leaq	(%rdx,%rdx), %rax
	xorq	%rdx, %rax
	leaq	(%rax,%rax), %rdx
	xorq	%rax, %rdx
	leaq	(%rdx,%rdx), %rax
	xorq	%rdx, %rax
	leaq	(%rax,%rax), %rdx
	xorq	%rax, %rdx
	leaq	(%rdx,%rdx), %rax
	xorq	%rdx, %rax
	leaq	(%rax,%rax), %rdx
	xorq	%rax, %rdx
	leaq	(%rdx,%rdx), %rax
	xorq	%rdx, %rax
	leaq	(%rax,%rax), %rdx
	xorq	%rax, %rdx
	leaq	(%rdx,%rdx), %rax
	xorq	%rdx, %rax
	leaq	(%rax,%rax), %rdx
	xorq	%rax, %rdx
	leaq	(%rdx,%rdx), %rax
	xorq	%rdx, %rax
	leaq	(%rax,%rax), %rdx
	xorq	%rax, %rdx
	leaq	(%rdx,%rdx), %rax
	xorq	%rdx, %rax
	leaq	(%rax,%rax), %rdx
	xorq	%rax, %rdx
	leaq	(%rdx,%rdx), %rax
	xorq	%rdx, %rax
	leaq	(%rax,%rax), %rdx
	xorq	%rax, %rdx
	leaq	(%rdx,%rdx), %rax
	xorq	%rdx, %rax
	leaq	(%rax,%rax), %rdx
	xorq	%rax, %rdx
	leaq	(%rdx,%rdx), %rax
	xorq	%rdx, %rax
	leaq	(%rax,%rax), %rdx
	xorq	%rax, %rdx
	leaq	(%rdx,%rdx), %rax
	xorq	%rdx, %rax
	leaq	(%rax,%rax), %rdx
	xorq	%rax, %rdx
	leaq	(%rdx,%rdx), %rax
	xorq	%rdx, %rax
	leaq	(%rax,%rax), %rdx
	xorq	%rax, %rdx
	leaq	(%rdx,%rdx), %rax
	xorq	%rdx, %rax
	leaq	(%rax,%rax), %rdx
	xorq	%rax, %rdx
	leaq	(%rdx,%rdx), %rax
	xorq	%rdx, %rax
	leaq	(%rax,%rax), %rdx
	xorq	%rax, %rdx
	leaq	(%rdx,%rdx), %rax
	xorq	%rdx, %rax
	leaq	(%rax,%rax), %rdx
	xorq	%rax, %rdx
	leaq	(%rdx,%rdx), %rax
	xorq	%rdx, %rax
	leaq	(%rax,%rax), %rdx
	xorq	%rax, %rdx
	leaq	(%rdx,%rdx), %rax
	xorq	%rdx, %rax
	leaq	(%rax,%rax), %rdx
	xorq	%rax, %rdx
	leaq	(%rdx,%rdx), %rax
	xorq	%rdx, %rax
	leaq	(%rax,%rax), %rdx
	xorq	%rax, %rdx
	leaq	(%rdx,%rdx), %rax
	xorq	%rdx, %rax
	leaq	(%rax,%rax), %rdx
	xorq	%rax, %rdx
	leaq	(%rdx,%rdx), %rax
	xorq	%rdx, %rax
	leaq	(%rax,%rax), %rdx
	xorq	%rax, %rdx
	leaq	(%rdx,%rdx), %rax
	xorq	%rdx, %rax
	leaq	(%rax,%rax), %rdx
	xorq	%rax, %rdx
	subq	$1, %rdi
	jne	.L51
.L50:
	addq	%rcx, %rdx
	leaq	(%rsi,%rdx,8), %rax
	ret
	.cfi_endproc
.LFE76:
	.size	_mhz_2, .-_mhz_2
	.globl	mhz_2
	.type	mhz_2, @function
mhz_2:
.LFB77:
	.cfi_startproc
	endbr64
	pushq	%r14
	.cfi_def_cfa_offset 16
	.cfi_offset 14, -16
	pushq	%r12
	.cfi_def_cfa_offset 24
	.cfi_offset 12, -24
	pushq	%rbp
	.cfi_def_cfa_offset 32
	.cfi_offset 6, -32
	pushq	%rbx
	.cfi_def_cfa_offset 40
	.cfi_offset 3, -40
	subq	$40, %rsp
	.cfi_def_cfa_offset 80
	movq	%fs:40, %rax
	movq	%rax, 24(%rsp)
	xorl	%eax, %eax
	leaq	16(%rsp), %rax
	movq	%rax, 16(%rsp)
	call	get_enough@PLT
	pxor	%xmm6, %xmm6
	cvtsi2sdl	%eax, %xmm6
	movsd	%xmm6, 8(%rsp)
	mulsd	.LC2(%rip), %xmm6
	movq	%xmm6, %rbp
	movl	$0, %ebx
	comisd	.LC1(%rip), %xmm6
	ja	.L68
	pxor	%xmm5, %xmm5
	movsd	%xmm5, (%rsp)
	movl	$0, %ebx
	jmp	.L54
.L57:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
	movsd	%xmm0, (%rsp)
	jmp	.L58
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
	subsd	.LC8(%rip), %xmm0
	cvttsd2siq	%xmm0, %rax
	movq	%rax, __iterations.7(%rip)
	btcq	$63, __iterations.7(%rip)
	jmp	.L60
.L91:
	movq	__iterations.7(%rip), %rax
	cmpq	$134217728, %rax
	ja	.L83
	salq	$3, %rax
	movq	%rax, __iterations.7(%rip)
.L60:
	movq	%rbp, %xmm4
	comisd	(%rsp), %xmm4
	jbe	.L54
.L68:
	movl	$0, %edi
	call	start@PLT
	movq	__iterations.7(%rip), %rdi
	testq	%rdi, %rdi
	je	.L56
	leaq	16(%rsp), %rsi
	movl	$1, %ecx
	movl	$1, %edx
	call	_mhz_2
	movq	%rax, %rbx
.L56:
	movl	$0, %esi
	movl	$0, %edi
	call	stop@PLT
	testq	%rax, %rax
	js	.L57
	pxor	%xmm7, %xmm7
	cvtsi2sdq	%rax, %xmm7
	movsd	%xmm7, (%rsp)
.L58:
	movsd	.LC3(%rip), %xmm0
	movsd	8(%rsp), %xmm2
	mulsd	%xmm2, %xmm0
	movsd	(%rsp), %xmm3
	comisd	%xmm3, %xmm0
	ja	.L59
	mulsd	.LC4(%rip), %xmm2
	comisd	%xmm2, %xmm3
	jbe	.L60
.L59:
	movsd	(%rsp), %xmm6
	comisd	.LC5(%rip), %xmm6
	jbe	.L91
	movq	__iterations.7(%rip), %rax
	testq	%rax, %rax
	js	.L64
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rax, %xmm1
.L65:
	divsd	(%rsp), %xmm1
	movsd	8(%rsp), %xmm0
	mulsd	.LC6(%rip), %xmm0
	mulsd	%xmm1, %xmm0
	addsd	.LC7(%rip), %xmm0
	comisd	.LC8(%rip), %xmm0
	jnb	.L66
	cvttsd2siq	%xmm0, %rax
	movq	%rax, __iterations.7(%rip)
	jmp	.L60
.L83:
	pxor	%xmm5, %xmm5
	movsd	%xmm5, (%rsp)
.L54:
	movq	__iterations.7(%rip), %rdi
	call	save_n@PLT
	movsd	(%rsp), %xmm7
	comisd	.LC8(%rip), %xmm7
	jnb	.L69
	cvttsd2siq	%xmm7, %rdi
.L70:
	call	settime@PLT
	call	usecs_spent@PLT
	testq	%rax, %rax
	js	.L71
	pxor	%xmm4, %xmm4
	cvtsi2sdq	%rax, %xmm4
	movq	%xmm4, %r14
.L72:
	call	t_overhead@PLT
	movq	%rax, %rbp
	call	get_n@PLT
	movq	%rax, %r12
	call	l_overhead@PLT
	movapd	%xmm0, %xmm1
	testq	%r12, %r12
	js	.L73
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%r12, %xmm0
.L74:
	mulsd	%xmm1, %xmm0
	testq	%rbp, %rbp
	js	.L75
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rbp, %xmm1
.L76:
	addsd	%xmm1, %xmm0
	movq	%r14, %xmm1
	subsd	%xmm0, %xmm1
	movl	$0, %edi
	comisd	.LC1(%rip), %xmm1
	jb	.L77
	comisd	.LC8(%rip), %xmm1
	jnb	.L79
	cvttsd2siq	%xmm1, %rdi
.L77:
	call	settime@PLT
	movq	%rbx, %rdi
	call	use_pointer@PLT
	call	get_n@PLT
	leaq	(%rax,%rax,4), %rax
	leaq	(%rax,%rax,4), %rdi
	salq	$2, %rdi
	call	save_n@PLT
	movq	24(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L94
	addq	$40, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 40
	popq	%rbx
	.cfi_def_cfa_offset 32
	popq	%rbp
	.cfi_def_cfa_offset 24
	popq	%r12
	.cfi_def_cfa_offset 16
	popq	%r14
	.cfi_def_cfa_offset 8
	ret
.L69:
	.cfi_restore_state
	movsd	(%rsp), %xmm0
	subsd	.LC8(%rip), %xmm0
	cvttsd2siq	%xmm0, %rdi
	btcq	$63, %rdi
	jmp	.L70
.L71:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rdx, %xmm1
	addsd	%xmm1, %xmm1
	movq	%xmm1, %r14
	jmp	.L72
.L73:
	movq	%r12, %rax
	shrq	%rax
	andl	$1, %r12d
	orq	%r12, %rax
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	addsd	%xmm0, %xmm0
	jmp	.L74
.L75:
	movq	%rbp, %rax
	shrq	%rax
	andl	$1, %ebp
	orq	%rbp, %rax
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rax, %xmm1
	addsd	%xmm1, %xmm1
	jmp	.L76
.L79:
	subsd	.LC8(%rip), %xmm1
	cvttsd2siq	%xmm1, %rdi
	btcq	$63, %rdi
	jmp	.L77
.L94:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE77:
	.size	mhz_2, .-mhz_2
	.section	.rodata.str1.1
.LC10:
	.string	"a^=a+a+a;"
	.text
	.globl	name_3
	.type	name_3, @function
name_3:
.LFB78:
	.cfi_startproc
	endbr64
	leaq	.LC10(%rip), %rax
	ret
	.cfi_endproc
.LFE78:
	.size	name_3, .-name_3
	.globl	_mhz_3
	.type	_mhz_3, @function
_mhz_3:
.LFB79:
	.cfi_startproc
	endbr64
	testq	%rdi, %rdi
	jle	.L97
.L98:
	leaq	(%rdx,%rdx,2), %rax
	xorq	%rdx, %rax
	leaq	(%rax,%rax,2), %rdx
	xorq	%rax, %rdx
	leaq	(%rdx,%rdx,2), %rax
	xorq	%rdx, %rax
	leaq	(%rax,%rax,2), %rdx
	xorq	%rax, %rdx
	leaq	(%rdx,%rdx,2), %rax
	xorq	%rdx, %rax
	leaq	(%rax,%rax,2), %rdx
	xorq	%rax, %rdx
	leaq	(%rdx,%rdx,2), %rax
	xorq	%rdx, %rax
	leaq	(%rax,%rax,2), %rdx
	xorq	%rax, %rdx
	leaq	(%rdx,%rdx,2), %rax
	xorq	%rdx, %rax
	leaq	(%rax,%rax,2), %rdx
	xorq	%rax, %rdx
	leaq	(%rdx,%rdx,2), %rax
	xorq	%rdx, %rax
	leaq	(%rax,%rax,2), %rdx
	xorq	%rax, %rdx
	leaq	(%rdx,%rdx,2), %rax
	xorq	%rdx, %rax
	leaq	(%rax,%rax,2), %rdx
	xorq	%rax, %rdx
	leaq	(%rdx,%rdx,2), %rax
	xorq	%rdx, %rax
	leaq	(%rax,%rax,2), %rdx
	xorq	%rax, %rdx
	leaq	(%rdx,%rdx,2), %rax
	xorq	%rdx, %rax
	leaq	(%rax,%rax,2), %rdx
	xorq	%rax, %rdx
	leaq	(%rdx,%rdx,2), %rax
	xorq	%rdx, %rax
	leaq	(%rax,%rax,2), %rdx
	xorq	%rax, %rdx
	leaq	(%rdx,%rdx,2), %rax
	xorq	%rdx, %rax
	leaq	(%rax,%rax,2), %rdx
	xorq	%rax, %rdx
	leaq	(%rdx,%rdx,2), %rax
	xorq	%rdx, %rax
	leaq	(%rax,%rax,2), %rdx
	xorq	%rax, %rdx
	leaq	(%rdx,%rdx,2), %rax
	xorq	%rdx, %rax
	leaq	(%rax,%rax,2), %rdx
	xorq	%rax, %rdx
	leaq	(%rdx,%rdx,2), %rax
	xorq	%rdx, %rax
	leaq	(%rax,%rax,2), %rdx
	xorq	%rax, %rdx
	leaq	(%rdx,%rdx,2), %rax
	xorq	%rdx, %rax
	leaq	(%rax,%rax,2), %rdx
	xorq	%rax, %rdx
	leaq	(%rdx,%rdx,2), %rax
	xorq	%rdx, %rax
	leaq	(%rax,%rax,2), %rdx
	xorq	%rax, %rdx
	leaq	(%rdx,%rdx,2), %rax
	xorq	%rdx, %rax
	leaq	(%rax,%rax,2), %rdx
	xorq	%rax, %rdx
	leaq	(%rdx,%rdx,2), %rax
	xorq	%rdx, %rax
	leaq	(%rax,%rax,2), %rdx
	xorq	%rax, %rdx
	leaq	(%rdx,%rdx,2), %rax
	xorq	%rdx, %rax
	leaq	(%rax,%rax,2), %rdx
	xorq	%rax, %rdx
	leaq	(%rdx,%rdx,2), %rax
	xorq	%rdx, %rax
	leaq	(%rax,%rax,2), %rdx
	xorq	%rax, %rdx
	leaq	(%rdx,%rdx,2), %rax
	xorq	%rdx, %rax
	leaq	(%rax,%rax,2), %rdx
	xorq	%rax, %rdx
	leaq	(%rdx,%rdx,2), %rax
	xorq	%rdx, %rax
	leaq	(%rax,%rax,2), %rdx
	xorq	%rax, %rdx
	leaq	(%rdx,%rdx,2), %rax
	xorq	%rdx, %rax
	leaq	(%rax,%rax,2), %rdx
	xorq	%rax, %rdx
	leaq	(%rdx,%rdx,2), %rax
	xorq	%rdx, %rax
	leaq	(%rax,%rax,2), %rdx
	xorq	%rax, %rdx
	leaq	(%rdx,%rdx,2), %rax
	xorq	%rdx, %rax
	leaq	(%rax,%rax,2), %rdx
	xorq	%rax, %rdx
	leaq	(%rdx,%rdx,2), %rax
	xorq	%rdx, %rax
	leaq	(%rax,%rax,2), %rdx
	xorq	%rax, %rdx
	leaq	(%rdx,%rdx,2), %rax
	xorq	%rdx, %rax
	leaq	(%rax,%rax,2), %rdx
	xorq	%rax, %rdx
	leaq	(%rdx,%rdx,2), %rax
	xorq	%rdx, %rax
	leaq	(%rax,%rax,2), %rdx
	xorq	%rax, %rdx
	leaq	(%rdx,%rdx,2), %rax
	xorq	%rdx, %rax
	leaq	(%rax,%rax,2), %rdx
	xorq	%rax, %rdx
	leaq	(%rdx,%rdx,2), %rax
	xorq	%rdx, %rax
	leaq	(%rax,%rax,2), %rdx
	xorq	%rax, %rdx
	leaq	(%rdx,%rdx,2), %rax
	xorq	%rdx, %rax
	leaq	(%rax,%rax,2), %rdx
	xorq	%rax, %rdx
	leaq	(%rdx,%rdx,2), %rax
	xorq	%rdx, %rax
	leaq	(%rax,%rax,2), %rdx
	xorq	%rax, %rdx
	leaq	(%rdx,%rdx,2), %rax
	xorq	%rdx, %rax
	leaq	(%rax,%rax,2), %rdx
	xorq	%rax, %rdx
	leaq	(%rdx,%rdx,2), %rax
	xorq	%rdx, %rax
	leaq	(%rax,%rax,2), %rdx
	xorq	%rax, %rdx
	leaq	(%rdx,%rdx,2), %rax
	xorq	%rdx, %rax
	leaq	(%rax,%rax,2), %rdx
	xorq	%rax, %rdx
	leaq	(%rdx,%rdx,2), %rax
	xorq	%rdx, %rax
	leaq	(%rax,%rax,2), %rdx
	xorq	%rax, %rdx
	leaq	(%rdx,%rdx,2), %rax
	xorq	%rdx, %rax
	leaq	(%rax,%rax,2), %rdx
	xorq	%rax, %rdx
	leaq	(%rdx,%rdx,2), %rax
	xorq	%rdx, %rax
	leaq	(%rax,%rax,2), %rdx
	xorq	%rax, %rdx
	leaq	(%rdx,%rdx,2), %rax
	xorq	%rdx, %rax
	leaq	(%rax,%rax,2), %rdx
	xorq	%rax, %rdx
	leaq	(%rdx,%rdx,2), %rax
	xorq	%rdx, %rax
	leaq	(%rax,%rax,2), %rdx
	xorq	%rax, %rdx
	leaq	(%rdx,%rdx,2), %rax
	xorq	%rdx, %rax
	leaq	(%rax,%rax,2), %rdx
	xorq	%rax, %rdx
	leaq	(%rdx,%rdx,2), %rax
	xorq	%rdx, %rax
	leaq	(%rax,%rax,2), %rdx
	xorq	%rax, %rdx
	leaq	(%rdx,%rdx,2), %rax
	xorq	%rdx, %rax
	leaq	(%rax,%rax,2), %rdx
	xorq	%rax, %rdx
	leaq	(%rdx,%rdx,2), %rax
	xorq	%rdx, %rax
	leaq	(%rax,%rax,2), %rdx
	xorq	%rax, %rdx
	leaq	(%rdx,%rdx,2), %rax
	xorq	%rdx, %rax
	leaq	(%rax,%rax,2), %rdx
	xorq	%rax, %rdx
	leaq	(%rdx,%rdx,2), %rax
	xorq	%rdx, %rax
	leaq	(%rax,%rax,2), %rdx
	xorq	%rax, %rdx
	leaq	(%rdx,%rdx,2), %rax
	xorq	%rdx, %rax
	leaq	(%rax,%rax,2), %rdx
	xorq	%rax, %rdx
	leaq	(%rdx,%rdx,2), %rax
	xorq	%rdx, %rax
	leaq	(%rax,%rax,2), %rdx
	xorq	%rax, %rdx
	leaq	(%rdx,%rdx,2), %rax
	xorq	%rdx, %rax
	leaq	(%rax,%rax,2), %rdx
	xorq	%rax, %rdx
	leaq	(%rdx,%rdx,2), %rax
	xorq	%rdx, %rax
	leaq	(%rax,%rax,2), %rdx
	xorq	%rax, %rdx
	subq	$1, %rdi
	jne	.L98
.L97:
	addq	%rcx, %rdx
	leaq	(%rsi,%rdx,8), %rax
	ret
	.cfi_endproc
.LFE79:
	.size	_mhz_3, .-_mhz_3
	.globl	mhz_3
	.type	mhz_3, @function
mhz_3:
.LFB80:
	.cfi_startproc
	endbr64
	pushq	%r14
	.cfi_def_cfa_offset 16
	.cfi_offset 14, -16
	pushq	%r12
	.cfi_def_cfa_offset 24
	.cfi_offset 12, -24
	pushq	%rbp
	.cfi_def_cfa_offset 32
	.cfi_offset 6, -32
	pushq	%rbx
	.cfi_def_cfa_offset 40
	.cfi_offset 3, -40
	subq	$40, %rsp
	.cfi_def_cfa_offset 80
	movq	%fs:40, %rax
	movq	%rax, 24(%rsp)
	xorl	%eax, %eax
	leaq	16(%rsp), %rax
	movq	%rax, 16(%rsp)
	call	get_enough@PLT
	pxor	%xmm6, %xmm6
	cvtsi2sdl	%eax, %xmm6
	movsd	%xmm6, 8(%rsp)
	mulsd	.LC2(%rip), %xmm6
	movq	%xmm6, %rbp
	movl	$0, %ebx
	comisd	.LC1(%rip), %xmm6
	ja	.L115
	pxor	%xmm5, %xmm5
	movsd	%xmm5, (%rsp)
	movl	$0, %ebx
	jmp	.L101
.L104:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
	movsd	%xmm0, (%rsp)
	jmp	.L105
.L111:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rdx, %xmm1
	addsd	%xmm1, %xmm1
	jmp	.L112
.L113:
	subsd	.LC8(%rip), %xmm0
	cvttsd2siq	%xmm0, %rax
	movq	%rax, __iterations.6(%rip)
	btcq	$63, __iterations.6(%rip)
	jmp	.L107
.L138:
	movq	__iterations.6(%rip), %rax
	cmpq	$134217728, %rax
	ja	.L130
	salq	$3, %rax
	movq	%rax, __iterations.6(%rip)
.L107:
	movq	%rbp, %xmm4
	comisd	(%rsp), %xmm4
	jbe	.L101
.L115:
	movl	$0, %edi
	call	start@PLT
	movq	__iterations.6(%rip), %rdi
	testq	%rdi, %rdi
	je	.L103
	leaq	16(%rsp), %rsi
	movl	$1, %ecx
	movl	$1, %edx
	call	_mhz_3
	movq	%rax, %rbx
.L103:
	movl	$0, %esi
	movl	$0, %edi
	call	stop@PLT
	testq	%rax, %rax
	js	.L104
	pxor	%xmm7, %xmm7
	cvtsi2sdq	%rax, %xmm7
	movsd	%xmm7, (%rsp)
.L105:
	movsd	.LC3(%rip), %xmm0
	movsd	8(%rsp), %xmm2
	mulsd	%xmm2, %xmm0
	movsd	(%rsp), %xmm3
	comisd	%xmm3, %xmm0
	ja	.L106
	mulsd	.LC4(%rip), %xmm2
	comisd	%xmm2, %xmm3
	jbe	.L107
.L106:
	movsd	(%rsp), %xmm6
	comisd	.LC5(%rip), %xmm6
	jbe	.L138
	movq	__iterations.6(%rip), %rax
	testq	%rax, %rax
	js	.L111
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rax, %xmm1
.L112:
	divsd	(%rsp), %xmm1
	movsd	8(%rsp), %xmm0
	mulsd	.LC6(%rip), %xmm0
	mulsd	%xmm1, %xmm0
	addsd	.LC7(%rip), %xmm0
	comisd	.LC8(%rip), %xmm0
	jnb	.L113
	cvttsd2siq	%xmm0, %rax
	movq	%rax, __iterations.6(%rip)
	jmp	.L107
.L130:
	pxor	%xmm5, %xmm5
	movsd	%xmm5, (%rsp)
.L101:
	movq	__iterations.6(%rip), %rdi
	call	save_n@PLT
	movsd	(%rsp), %xmm7
	comisd	.LC8(%rip), %xmm7
	jnb	.L116
	cvttsd2siq	%xmm7, %rdi
.L117:
	call	settime@PLT
	call	usecs_spent@PLT
	testq	%rax, %rax
	js	.L118
	pxor	%xmm4, %xmm4
	cvtsi2sdq	%rax, %xmm4
	movq	%xmm4, %r14
.L119:
	call	t_overhead@PLT
	movq	%rax, %rbp
	call	get_n@PLT
	movq	%rax, %r12
	call	l_overhead@PLT
	movapd	%xmm0, %xmm1
	testq	%r12, %r12
	js	.L120
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%r12, %xmm0
.L121:
	mulsd	%xmm1, %xmm0
	testq	%rbp, %rbp
	js	.L122
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rbp, %xmm1
.L123:
	addsd	%xmm1, %xmm0
	movq	%r14, %xmm1
	subsd	%xmm0, %xmm1
	movl	$0, %edi
	comisd	.LC1(%rip), %xmm1
	jb	.L124
	comisd	.LC8(%rip), %xmm1
	jnb	.L126
	cvttsd2siq	%xmm1, %rdi
.L124:
	call	settime@PLT
	movq	%rbx, %rdi
	call	use_pointer@PLT
	call	get_n@PLT
	leaq	(%rax,%rax,4), %rax
	leaq	(%rax,%rax,4), %rdi
	salq	$2, %rdi
	call	save_n@PLT
	movq	24(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L141
	addq	$40, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 40
	popq	%rbx
	.cfi_def_cfa_offset 32
	popq	%rbp
	.cfi_def_cfa_offset 24
	popq	%r12
	.cfi_def_cfa_offset 16
	popq	%r14
	.cfi_def_cfa_offset 8
	ret
.L116:
	.cfi_restore_state
	movsd	(%rsp), %xmm0
	subsd	.LC8(%rip), %xmm0
	cvttsd2siq	%xmm0, %rdi
	btcq	$63, %rdi
	jmp	.L117
.L118:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rdx, %xmm1
	addsd	%xmm1, %xmm1
	movq	%xmm1, %r14
	jmp	.L119
.L120:
	movq	%r12, %rax
	shrq	%rax
	andl	$1, %r12d
	orq	%r12, %rax
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	addsd	%xmm0, %xmm0
	jmp	.L121
.L122:
	movq	%rbp, %rax
	shrq	%rax
	andl	$1, %ebp
	orq	%rbp, %rax
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rax, %xmm1
	addsd	%xmm1, %xmm1
	jmp	.L123
.L126:
	subsd	.LC8(%rip), %xmm1
	cvttsd2siq	%xmm1, %rdi
	btcq	$63, %rdi
	jmp	.L124
.L141:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE80:
	.size	mhz_3, .-mhz_3
	.section	.rodata.str1.1
.LC11:
	.string	"a>>=b;"
	.text
	.globl	name_4
	.type	name_4, @function
name_4:
.LFB81:
	.cfi_startproc
	endbr64
	leaq	.LC11(%rip), %rax
	ret
	.cfi_endproc
.LFE81:
	.size	name_4, .-name_4
	.globl	_mhz_4
	.type	_mhz_4, @function
_mhz_4:
.LFB82:
	.cfi_startproc
	endbr64
	movq	%rdi, %rax
	testq	%rdi, %rdi
	jle	.L144
.L145:
	sarq	%cl, %rdx
	sarq	%cl, %rdx
	sarq	%cl, %rdx
	sarq	%cl, %rdx
	sarq	%cl, %rdx
	sarq	%cl, %rdx
	sarq	%cl, %rdx
	sarq	%cl, %rdx
	sarq	%cl, %rdx
	sarq	%cl, %rdx
	sarq	%cl, %rdx
	sarq	%cl, %rdx
	sarq	%cl, %rdx
	sarq	%cl, %rdx
	sarq	%cl, %rdx
	sarq	%cl, %rdx
	sarq	%cl, %rdx
	sarq	%cl, %rdx
	sarq	%cl, %rdx
	sarq	%cl, %rdx
	sarq	%cl, %rdx
	sarq	%cl, %rdx
	sarq	%cl, %rdx
	sarq	%cl, %rdx
	sarq	%cl, %rdx
	sarq	%cl, %rdx
	sarq	%cl, %rdx
	sarq	%cl, %rdx
	sarq	%cl, %rdx
	sarq	%cl, %rdx
	sarq	%cl, %rdx
	sarq	%cl, %rdx
	sarq	%cl, %rdx
	sarq	%cl, %rdx
	sarq	%cl, %rdx
	sarq	%cl, %rdx
	sarq	%cl, %rdx
	sarq	%cl, %rdx
	sarq	%cl, %rdx
	sarq	%cl, %rdx
	sarq	%cl, %rdx
	sarq	%cl, %rdx
	sarq	%cl, %rdx
	sarq	%cl, %rdx
	sarq	%cl, %rdx
	sarq	%cl, %rdx
	sarq	%cl, %rdx
	sarq	%cl, %rdx
	sarq	%cl, %rdx
	sarq	%cl, %rdx
	sarq	%cl, %rdx
	sarq	%cl, %rdx
	sarq	%cl, %rdx
	sarq	%cl, %rdx
	sarq	%cl, %rdx
	sarq	%cl, %rdx
	sarq	%cl, %rdx
	sarq	%cl, %rdx
	sarq	%cl, %rdx
	sarq	%cl, %rdx
	sarq	%cl, %rdx
	sarq	%cl, %rdx
	sarq	%cl, %rdx
	sarq	%cl, %rdx
	sarq	%cl, %rdx
	sarq	%cl, %rdx
	sarq	%cl, %rdx
	sarq	%cl, %rdx
	sarq	%cl, %rdx
	sarq	%cl, %rdx
	sarq	%cl, %rdx
	sarq	%cl, %rdx
	sarq	%cl, %rdx
	sarq	%cl, %rdx
	sarq	%cl, %rdx
	sarq	%cl, %rdx
	sarq	%cl, %rdx
	sarq	%cl, %rdx
	sarq	%cl, %rdx
	sarq	%cl, %rdx
	sarq	%cl, %rdx
	sarq	%cl, %rdx
	sarq	%cl, %rdx
	sarq	%cl, %rdx
	sarq	%cl, %rdx
	sarq	%cl, %rdx
	sarq	%cl, %rdx
	sarq	%cl, %rdx
	sarq	%cl, %rdx
	sarq	%cl, %rdx
	sarq	%cl, %rdx
	sarq	%cl, %rdx
	sarq	%cl, %rdx
	sarq	%cl, %rdx
	sarq	%cl, %rdx
	sarq	%cl, %rdx
	sarq	%cl, %rdx
	sarq	%cl, %rdx
	sarq	%cl, %rdx
	sarq	%cl, %rdx
	subq	$1, %rax
	jne	.L145
.L144:
	addq	%rcx, %rdx
	leaq	(%rsi,%rdx,8), %rax
	ret
	.cfi_endproc
.LFE82:
	.size	_mhz_4, .-_mhz_4
	.globl	mhz_4
	.type	mhz_4, @function
mhz_4:
.LFB83:
	.cfi_startproc
	endbr64
	pushq	%r14
	.cfi_def_cfa_offset 16
	.cfi_offset 14, -16
	pushq	%r12
	.cfi_def_cfa_offset 24
	.cfi_offset 12, -24
	pushq	%rbp
	.cfi_def_cfa_offset 32
	.cfi_offset 6, -32
	pushq	%rbx
	.cfi_def_cfa_offset 40
	.cfi_offset 3, -40
	subq	$40, %rsp
	.cfi_def_cfa_offset 80
	movq	%fs:40, %rax
	movq	%rax, 24(%rsp)
	xorl	%eax, %eax
	leaq	16(%rsp), %rax
	movq	%rax, 16(%rsp)
	call	get_enough@PLT
	pxor	%xmm6, %xmm6
	cvtsi2sdl	%eax, %xmm6
	movsd	%xmm6, 8(%rsp)
	mulsd	.LC2(%rip), %xmm6
	movq	%xmm6, %rbp
	movl	$0, %ebx
	comisd	.LC1(%rip), %xmm6
	ja	.L162
	pxor	%xmm5, %xmm5
	movsd	%xmm5, (%rsp)
	movl	$0, %ebx
	jmp	.L148
.L151:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
	movsd	%xmm0, (%rsp)
	jmp	.L152
.L158:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rdx, %xmm1
	addsd	%xmm1, %xmm1
	jmp	.L159
.L160:
	subsd	.LC8(%rip), %xmm0
	cvttsd2siq	%xmm0, %rax
	movq	%rax, __iterations.5(%rip)
	btcq	$63, __iterations.5(%rip)
	jmp	.L154
.L185:
	movq	__iterations.5(%rip), %rax
	cmpq	$134217728, %rax
	ja	.L177
	salq	$3, %rax
	movq	%rax, __iterations.5(%rip)
.L154:
	movq	%rbp, %xmm4
	comisd	(%rsp), %xmm4
	jbe	.L148
.L162:
	movl	$0, %edi
	call	start@PLT
	movq	__iterations.5(%rip), %rdi
	testq	%rdi, %rdi
	je	.L150
	leaq	16(%rsp), %rsi
	movl	$1, %ecx
	movl	$1, %edx
	call	_mhz_4
	movq	%rax, %rbx
.L150:
	movl	$0, %esi
	movl	$0, %edi
	call	stop@PLT
	testq	%rax, %rax
	js	.L151
	pxor	%xmm7, %xmm7
	cvtsi2sdq	%rax, %xmm7
	movsd	%xmm7, (%rsp)
.L152:
	movsd	.LC3(%rip), %xmm0
	movsd	8(%rsp), %xmm2
	mulsd	%xmm2, %xmm0
	movsd	(%rsp), %xmm3
	comisd	%xmm3, %xmm0
	ja	.L153
	mulsd	.LC4(%rip), %xmm2
	comisd	%xmm2, %xmm3
	jbe	.L154
.L153:
	movsd	(%rsp), %xmm6
	comisd	.LC5(%rip), %xmm6
	jbe	.L185
	movq	__iterations.5(%rip), %rax
	testq	%rax, %rax
	js	.L158
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rax, %xmm1
.L159:
	divsd	(%rsp), %xmm1
	movsd	8(%rsp), %xmm0
	mulsd	.LC6(%rip), %xmm0
	mulsd	%xmm1, %xmm0
	addsd	.LC7(%rip), %xmm0
	comisd	.LC8(%rip), %xmm0
	jnb	.L160
	cvttsd2siq	%xmm0, %rax
	movq	%rax, __iterations.5(%rip)
	jmp	.L154
.L177:
	pxor	%xmm5, %xmm5
	movsd	%xmm5, (%rsp)
.L148:
	movq	__iterations.5(%rip), %rdi
	call	save_n@PLT
	movsd	(%rsp), %xmm7
	comisd	.LC8(%rip), %xmm7
	jnb	.L163
	cvttsd2siq	%xmm7, %rdi
.L164:
	call	settime@PLT
	call	usecs_spent@PLT
	testq	%rax, %rax
	js	.L165
	pxor	%xmm4, %xmm4
	cvtsi2sdq	%rax, %xmm4
	movq	%xmm4, %r14
.L166:
	call	t_overhead@PLT
	movq	%rax, %rbp
	call	get_n@PLT
	movq	%rax, %r12
	call	l_overhead@PLT
	movapd	%xmm0, %xmm1
	testq	%r12, %r12
	js	.L167
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%r12, %xmm0
.L168:
	mulsd	%xmm1, %xmm0
	testq	%rbp, %rbp
	js	.L169
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rbp, %xmm1
.L170:
	addsd	%xmm1, %xmm0
	movq	%r14, %xmm1
	subsd	%xmm0, %xmm1
	movl	$0, %edi
	comisd	.LC1(%rip), %xmm1
	jb	.L171
	comisd	.LC8(%rip), %xmm1
	jnb	.L173
	cvttsd2siq	%xmm1, %rdi
.L171:
	call	settime@PLT
	movq	%rbx, %rdi
	call	use_pointer@PLT
	call	get_n@PLT
	leaq	(%rax,%rax,4), %rax
	leaq	(%rax,%rax,4), %rdi
	salq	$2, %rdi
	call	save_n@PLT
	movq	24(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L188
	addq	$40, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 40
	popq	%rbx
	.cfi_def_cfa_offset 32
	popq	%rbp
	.cfi_def_cfa_offset 24
	popq	%r12
	.cfi_def_cfa_offset 16
	popq	%r14
	.cfi_def_cfa_offset 8
	ret
.L163:
	.cfi_restore_state
	movsd	(%rsp), %xmm0
	subsd	.LC8(%rip), %xmm0
	cvttsd2siq	%xmm0, %rdi
	btcq	$63, %rdi
	jmp	.L164
.L165:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rdx, %xmm1
	addsd	%xmm1, %xmm1
	movq	%xmm1, %r14
	jmp	.L166
.L167:
	movq	%r12, %rax
	shrq	%rax
	andl	$1, %r12d
	orq	%r12, %rax
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	addsd	%xmm0, %xmm0
	jmp	.L168
.L169:
	movq	%rbp, %rax
	shrq	%rax
	andl	$1, %ebp
	orq	%rbp, %rax
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rax, %xmm1
	addsd	%xmm1, %xmm1
	jmp	.L170
.L173:
	subsd	.LC8(%rip), %xmm1
	cvttsd2siq	%xmm1, %rdi
	btcq	$63, %rdi
	jmp	.L171
.L188:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE83:
	.size	mhz_4, .-mhz_4
	.section	.rodata.str1.1
.LC12:
	.string	"a>>=a+a;"
	.text
	.globl	name_5
	.type	name_5, @function
name_5:
.LFB84:
	.cfi_startproc
	endbr64
	leaq	.LC12(%rip), %rax
	ret
	.cfi_endproc
.LFE84:
	.size	name_5, .-name_5
	.globl	_mhz_5
	.type	_mhz_5, @function
_mhz_5:
.LFB85:
	.cfi_startproc
	endbr64
	movq	%rdi, %rax
	movq	%rcx, %rdi
	testq	%rax, %rax
	jle	.L191
.L192:
	leal	(%rdx,%rdx), %ecx
	sarq	%cl, %rdx
	leal	(%rdx,%rdx), %ecx
	sarq	%cl, %rdx
	leal	(%rdx,%rdx), %ecx
	sarq	%cl, %rdx
	leal	(%rdx,%rdx), %ecx
	sarq	%cl, %rdx
	leal	(%rdx,%rdx), %ecx
	sarq	%cl, %rdx
	leal	(%rdx,%rdx), %ecx
	sarq	%cl, %rdx
	leal	(%rdx,%rdx), %ecx
	sarq	%cl, %rdx
	leal	(%rdx,%rdx), %ecx
	sarq	%cl, %rdx
	leal	(%rdx,%rdx), %ecx
	sarq	%cl, %rdx
	leal	(%rdx,%rdx), %ecx
	sarq	%cl, %rdx
	leal	(%rdx,%rdx), %ecx
	sarq	%cl, %rdx
	leal	(%rdx,%rdx), %ecx
	sarq	%cl, %rdx
	leal	(%rdx,%rdx), %ecx
	sarq	%cl, %rdx
	leal	(%rdx,%rdx), %ecx
	sarq	%cl, %rdx
	leal	(%rdx,%rdx), %ecx
	sarq	%cl, %rdx
	leal	(%rdx,%rdx), %ecx
	sarq	%cl, %rdx
	leal	(%rdx,%rdx), %ecx
	sarq	%cl, %rdx
	leal	(%rdx,%rdx), %ecx
	sarq	%cl, %rdx
	leal	(%rdx,%rdx), %ecx
	sarq	%cl, %rdx
	leal	(%rdx,%rdx), %ecx
	sarq	%cl, %rdx
	leal	(%rdx,%rdx), %ecx
	sarq	%cl, %rdx
	leal	(%rdx,%rdx), %ecx
	sarq	%cl, %rdx
	leal	(%rdx,%rdx), %ecx
	sarq	%cl, %rdx
	leal	(%rdx,%rdx), %ecx
	sarq	%cl, %rdx
	leal	(%rdx,%rdx), %ecx
	sarq	%cl, %rdx
	leal	(%rdx,%rdx), %ecx
	sarq	%cl, %rdx
	leal	(%rdx,%rdx), %ecx
	sarq	%cl, %rdx
	leal	(%rdx,%rdx), %ecx
	sarq	%cl, %rdx
	leal	(%rdx,%rdx), %ecx
	sarq	%cl, %rdx
	leal	(%rdx,%rdx), %ecx
	sarq	%cl, %rdx
	leal	(%rdx,%rdx), %ecx
	sarq	%cl, %rdx
	leal	(%rdx,%rdx), %ecx
	sarq	%cl, %rdx
	leal	(%rdx,%rdx), %ecx
	sarq	%cl, %rdx
	leal	(%rdx,%rdx), %ecx
	sarq	%cl, %rdx
	leal	(%rdx,%rdx), %ecx
	sarq	%cl, %rdx
	leal	(%rdx,%rdx), %ecx
	sarq	%cl, %rdx
	leal	(%rdx,%rdx), %ecx
	sarq	%cl, %rdx
	leal	(%rdx,%rdx), %ecx
	sarq	%cl, %rdx
	leal	(%rdx,%rdx), %ecx
	sarq	%cl, %rdx
	leal	(%rdx,%rdx), %ecx
	sarq	%cl, %rdx
	leal	(%rdx,%rdx), %ecx
	sarq	%cl, %rdx
	leal	(%rdx,%rdx), %ecx
	sarq	%cl, %rdx
	leal	(%rdx,%rdx), %ecx
	sarq	%cl, %rdx
	leal	(%rdx,%rdx), %ecx
	sarq	%cl, %rdx
	leal	(%rdx,%rdx), %ecx
	sarq	%cl, %rdx
	leal	(%rdx,%rdx), %ecx
	sarq	%cl, %rdx
	leal	(%rdx,%rdx), %ecx
	sarq	%cl, %rdx
	leal	(%rdx,%rdx), %ecx
	sarq	%cl, %rdx
	leal	(%rdx,%rdx), %ecx
	sarq	%cl, %rdx
	leal	(%rdx,%rdx), %ecx
	sarq	%cl, %rdx
	leal	(%rdx,%rdx), %ecx
	sarq	%cl, %rdx
	leal	(%rdx,%rdx), %ecx
	sarq	%cl, %rdx
	leal	(%rdx,%rdx), %ecx
	sarq	%cl, %rdx
	leal	(%rdx,%rdx), %ecx
	sarq	%cl, %rdx
	leal	(%rdx,%rdx), %ecx
	sarq	%cl, %rdx
	leal	(%rdx,%rdx), %ecx
	sarq	%cl, %rdx
	leal	(%rdx,%rdx), %ecx
	sarq	%cl, %rdx
	leal	(%rdx,%rdx), %ecx
	sarq	%cl, %rdx
	leal	(%rdx,%rdx), %ecx
	sarq	%cl, %rdx
	leal	(%rdx,%rdx), %ecx
	sarq	%cl, %rdx
	leal	(%rdx,%rdx), %ecx
	sarq	%cl, %rdx
	leal	(%rdx,%rdx), %ecx
	sarq	%cl, %rdx
	leal	(%rdx,%rdx), %ecx
	sarq	%cl, %rdx
	leal	(%rdx,%rdx), %ecx
	sarq	%cl, %rdx
	leal	(%rdx,%rdx), %ecx
	sarq	%cl, %rdx
	leal	(%rdx,%rdx), %ecx
	sarq	%cl, %rdx
	leal	(%rdx,%rdx), %ecx
	sarq	%cl, %rdx
	leal	(%rdx,%rdx), %ecx
	sarq	%cl, %rdx
	leal	(%rdx,%rdx), %ecx
	sarq	%cl, %rdx
	leal	(%rdx,%rdx), %ecx
	sarq	%cl, %rdx
	leal	(%rdx,%rdx), %ecx
	sarq	%cl, %rdx
	leal	(%rdx,%rdx), %ecx
	sarq	%cl, %rdx
	leal	(%rdx,%rdx), %ecx
	sarq	%cl, %rdx
	leal	(%rdx,%rdx), %ecx
	sarq	%cl, %rdx
	leal	(%rdx,%rdx), %ecx
	sarq	%cl, %rdx
	leal	(%rdx,%rdx), %ecx
	sarq	%cl, %rdx
	leal	(%rdx,%rdx), %ecx
	sarq	%cl, %rdx
	leal	(%rdx,%rdx), %ecx
	sarq	%cl, %rdx
	leal	(%rdx,%rdx), %ecx
	sarq	%cl, %rdx
	leal	(%rdx,%rdx), %ecx
	sarq	%cl, %rdx
	leal	(%rdx,%rdx), %ecx
	sarq	%cl, %rdx
	leal	(%rdx,%rdx), %ecx
	sarq	%cl, %rdx
	leal	(%rdx,%rdx), %ecx
	sarq	%cl, %rdx
	leal	(%rdx,%rdx), %ecx
	sarq	%cl, %rdx
	leal	(%rdx,%rdx), %ecx
	sarq	%cl, %rdx
	leal	(%rdx,%rdx), %ecx
	sarq	%cl, %rdx
	leal	(%rdx,%rdx), %ecx
	sarq	%cl, %rdx
	leal	(%rdx,%rdx), %ecx
	sarq	%cl, %rdx
	leal	(%rdx,%rdx), %ecx
	sarq	%cl, %rdx
	leal	(%rdx,%rdx), %ecx
	sarq	%cl, %rdx
	leal	(%rdx,%rdx), %ecx
	sarq	%cl, %rdx
	leal	(%rdx,%rdx), %ecx
	sarq	%cl, %rdx
	leal	(%rdx,%rdx), %ecx
	sarq	%cl, %rdx
	leal	(%rdx,%rdx), %ecx
	sarq	%cl, %rdx
	leal	(%rdx,%rdx), %ecx
	sarq	%cl, %rdx
	leal	(%rdx,%rdx), %ecx
	sarq	%cl, %rdx
	leal	(%rdx,%rdx), %ecx
	sarq	%cl, %rdx
	leal	(%rdx,%rdx), %ecx
	sarq	%cl, %rdx
	leal	(%rdx,%rdx), %ecx
	sarq	%cl, %rdx
	leal	(%rdx,%rdx), %ecx
	sarq	%cl, %rdx
	subq	$1, %rax
	jne	.L192
.L191:
	addq	%rdi, %rdx
	leaq	(%rsi,%rdx,8), %rax
	ret
	.cfi_endproc
.LFE85:
	.size	_mhz_5, .-_mhz_5
	.globl	mhz_5
	.type	mhz_5, @function
mhz_5:
.LFB86:
	.cfi_startproc
	endbr64
	pushq	%r14
	.cfi_def_cfa_offset 16
	.cfi_offset 14, -16
	pushq	%r12
	.cfi_def_cfa_offset 24
	.cfi_offset 12, -24
	pushq	%rbp
	.cfi_def_cfa_offset 32
	.cfi_offset 6, -32
	pushq	%rbx
	.cfi_def_cfa_offset 40
	.cfi_offset 3, -40
	subq	$40, %rsp
	.cfi_def_cfa_offset 80
	movq	%fs:40, %rax
	movq	%rax, 24(%rsp)
	xorl	%eax, %eax
	leaq	16(%rsp), %rax
	movq	%rax, 16(%rsp)
	call	get_enough@PLT
	pxor	%xmm6, %xmm6
	cvtsi2sdl	%eax, %xmm6
	movsd	%xmm6, 8(%rsp)
	mulsd	.LC2(%rip), %xmm6
	movq	%xmm6, %rbp
	movl	$0, %ebx
	comisd	.LC1(%rip), %xmm6
	ja	.L209
	pxor	%xmm5, %xmm5
	movsd	%xmm5, (%rsp)
	movl	$0, %ebx
	jmp	.L195
.L198:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
	movsd	%xmm0, (%rsp)
	jmp	.L199
.L205:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rdx, %xmm1
	addsd	%xmm1, %xmm1
	jmp	.L206
.L207:
	subsd	.LC8(%rip), %xmm0
	cvttsd2siq	%xmm0, %rax
	movq	%rax, __iterations.4(%rip)
	btcq	$63, __iterations.4(%rip)
	jmp	.L201
.L232:
	movq	__iterations.4(%rip), %rax
	cmpq	$134217728, %rax
	ja	.L224
	salq	$3, %rax
	movq	%rax, __iterations.4(%rip)
.L201:
	movq	%rbp, %xmm4
	comisd	(%rsp), %xmm4
	jbe	.L195
.L209:
	movl	$0, %edi
	call	start@PLT
	movq	__iterations.4(%rip), %rdi
	testq	%rdi, %rdi
	je	.L197
	leaq	16(%rsp), %rsi
	movl	$1, %ecx
	movl	$1, %edx
	call	_mhz_5
	movq	%rax, %rbx
.L197:
	movl	$0, %esi
	movl	$0, %edi
	call	stop@PLT
	testq	%rax, %rax
	js	.L198
	pxor	%xmm7, %xmm7
	cvtsi2sdq	%rax, %xmm7
	movsd	%xmm7, (%rsp)
.L199:
	movsd	.LC3(%rip), %xmm0
	movsd	8(%rsp), %xmm2
	mulsd	%xmm2, %xmm0
	movsd	(%rsp), %xmm3
	comisd	%xmm3, %xmm0
	ja	.L200
	mulsd	.LC4(%rip), %xmm2
	comisd	%xmm2, %xmm3
	jbe	.L201
.L200:
	movsd	(%rsp), %xmm6
	comisd	.LC5(%rip), %xmm6
	jbe	.L232
	movq	__iterations.4(%rip), %rax
	testq	%rax, %rax
	js	.L205
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rax, %xmm1
.L206:
	divsd	(%rsp), %xmm1
	movsd	8(%rsp), %xmm0
	mulsd	.LC6(%rip), %xmm0
	mulsd	%xmm1, %xmm0
	addsd	.LC7(%rip), %xmm0
	comisd	.LC8(%rip), %xmm0
	jnb	.L207
	cvttsd2siq	%xmm0, %rax
	movq	%rax, __iterations.4(%rip)
	jmp	.L201
.L224:
	pxor	%xmm5, %xmm5
	movsd	%xmm5, (%rsp)
.L195:
	movq	__iterations.4(%rip), %rdi
	call	save_n@PLT
	movsd	(%rsp), %xmm7
	comisd	.LC8(%rip), %xmm7
	jnb	.L210
	cvttsd2siq	%xmm7, %rdi
.L211:
	call	settime@PLT
	call	usecs_spent@PLT
	testq	%rax, %rax
	js	.L212
	pxor	%xmm4, %xmm4
	cvtsi2sdq	%rax, %xmm4
	movq	%xmm4, %r14
.L213:
	call	t_overhead@PLT
	movq	%rax, %rbp
	call	get_n@PLT
	movq	%rax, %r12
	call	l_overhead@PLT
	movapd	%xmm0, %xmm1
	testq	%r12, %r12
	js	.L214
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%r12, %xmm0
.L215:
	mulsd	%xmm1, %xmm0
	testq	%rbp, %rbp
	js	.L216
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rbp, %xmm1
.L217:
	addsd	%xmm1, %xmm0
	movq	%r14, %xmm1
	subsd	%xmm0, %xmm1
	movl	$0, %edi
	comisd	.LC1(%rip), %xmm1
	jb	.L218
	comisd	.LC8(%rip), %xmm1
	jnb	.L220
	cvttsd2siq	%xmm1, %rdi
.L218:
	call	settime@PLT
	movq	%rbx, %rdi
	call	use_pointer@PLT
	call	get_n@PLT
	leaq	(%rax,%rax,4), %rax
	leaq	(%rax,%rax,4), %rdi
	salq	$2, %rdi
	call	save_n@PLT
	movq	24(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L235
	addq	$40, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 40
	popq	%rbx
	.cfi_def_cfa_offset 32
	popq	%rbp
	.cfi_def_cfa_offset 24
	popq	%r12
	.cfi_def_cfa_offset 16
	popq	%r14
	.cfi_def_cfa_offset 8
	ret
.L210:
	.cfi_restore_state
	movsd	(%rsp), %xmm0
	subsd	.LC8(%rip), %xmm0
	cvttsd2siq	%xmm0, %rdi
	btcq	$63, %rdi
	jmp	.L211
.L212:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rdx, %xmm1
	addsd	%xmm1, %xmm1
	movq	%xmm1, %r14
	jmp	.L213
.L214:
	movq	%r12, %rax
	shrq	%rax
	andl	$1, %r12d
	orq	%r12, %rax
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	addsd	%xmm0, %xmm0
	jmp	.L215
.L216:
	movq	%rbp, %rax
	shrq	%rax
	andl	$1, %ebp
	orq	%rbp, %rax
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rax, %xmm1
	addsd	%xmm1, %xmm1
	jmp	.L217
.L220:
	subsd	.LC8(%rip), %xmm1
	cvttsd2siq	%xmm1, %rdi
	btcq	$63, %rdi
	jmp	.L218
.L235:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE86:
	.size	mhz_5, .-mhz_5
	.section	.rodata.str1.1
.LC13:
	.string	"a^=a<<b;"
	.text
	.globl	name_6
	.type	name_6, @function
name_6:
.LFB87:
	.cfi_startproc
	endbr64
	leaq	.LC13(%rip), %rax
	ret
	.cfi_endproc
.LFE87:
	.size	name_6, .-name_6
	.globl	_mhz_6
	.type	_mhz_6, @function
_mhz_6:
.LFB88:
	.cfi_startproc
	endbr64
	testq	%rdi, %rdi
	jle	.L238
.L239:
	movq	%rdx, %rax
	salq	%cl, %rax
	xorq	%rdx, %rax
	movq	%rax, %rdx
	salq	%cl, %rdx
	xorq	%rax, %rdx
	movq	%rdx, %rax
	salq	%cl, %rax
	xorq	%rdx, %rax
	movq	%rax, %rdx
	salq	%cl, %rdx
	xorq	%rax, %rdx
	movq	%rdx, %rax
	salq	%cl, %rax
	xorq	%rdx, %rax
	movq	%rax, %rdx
	salq	%cl, %rdx
	xorq	%rax, %rdx
	movq	%rdx, %rax
	salq	%cl, %rax
	xorq	%rdx, %rax
	movq	%rax, %rdx
	salq	%cl, %rdx
	xorq	%rax, %rdx
	movq	%rdx, %rax
	salq	%cl, %rax
	xorq	%rdx, %rax
	movq	%rax, %rdx
	salq	%cl, %rdx
	xorq	%rax, %rdx
	movq	%rdx, %rax
	salq	%cl, %rax
	xorq	%rdx, %rax
	movq	%rax, %rdx
	salq	%cl, %rdx
	xorq	%rax, %rdx
	movq	%rdx, %rax
	salq	%cl, %rax
	xorq	%rdx, %rax
	movq	%rax, %rdx
	salq	%cl, %rdx
	xorq	%rax, %rdx
	movq	%rdx, %rax
	salq	%cl, %rax
	xorq	%rdx, %rax
	movq	%rax, %rdx
	salq	%cl, %rdx
	xorq	%rax, %rdx
	movq	%rdx, %rax
	salq	%cl, %rax
	xorq	%rdx, %rax
	movq	%rax, %rdx
	salq	%cl, %rdx
	xorq	%rax, %rdx
	movq	%rdx, %rax
	salq	%cl, %rax
	xorq	%rdx, %rax
	movq	%rax, %rdx
	salq	%cl, %rdx
	xorq	%rax, %rdx
	movq	%rdx, %rax
	salq	%cl, %rax
	xorq	%rdx, %rax
	movq	%rax, %rdx
	salq	%cl, %rdx
	xorq	%rax, %rdx
	movq	%rdx, %rax
	salq	%cl, %rax
	xorq	%rdx, %rax
	movq	%rax, %rdx
	salq	%cl, %rdx
	xorq	%rax, %rdx
	movq	%rdx, %rax
	salq	%cl, %rax
	xorq	%rdx, %rax
	movq	%rax, %rdx
	salq	%cl, %rdx
	xorq	%rax, %rdx
	movq	%rdx, %rax
	salq	%cl, %rax
	xorq	%rdx, %rax
	movq	%rax, %rdx
	salq	%cl, %rdx
	xorq	%rax, %rdx
	movq	%rdx, %rax
	salq	%cl, %rax
	xorq	%rdx, %rax
	movq	%rax, %rdx
	salq	%cl, %rdx
	xorq	%rax, %rdx
	movq	%rdx, %rax
	salq	%cl, %rax
	xorq	%rdx, %rax
	movq	%rax, %rdx
	salq	%cl, %rdx
	xorq	%rax, %rdx
	movq	%rdx, %rax
	salq	%cl, %rax
	xorq	%rdx, %rax
	movq	%rax, %rdx
	salq	%cl, %rdx
	xorq	%rax, %rdx
	movq	%rdx, %rax
	salq	%cl, %rax
	xorq	%rdx, %rax
	movq	%rax, %rdx
	salq	%cl, %rdx
	xorq	%rax, %rdx
	movq	%rdx, %rax
	salq	%cl, %rax
	xorq	%rdx, %rax
	movq	%rax, %rdx
	salq	%cl, %rdx
	xorq	%rax, %rdx
	movq	%rdx, %rax
	salq	%cl, %rax
	xorq	%rdx, %rax
	movq	%rax, %rdx
	salq	%cl, %rdx
	xorq	%rax, %rdx
	movq	%rdx, %rax
	salq	%cl, %rax
	xorq	%rdx, %rax
	movq	%rax, %rdx
	salq	%cl, %rdx
	xorq	%rax, %rdx
	movq	%rdx, %rax
	salq	%cl, %rax
	xorq	%rdx, %rax
	movq	%rax, %rdx
	salq	%cl, %rdx
	xorq	%rax, %rdx
	movq	%rdx, %rax
	salq	%cl, %rax
	xorq	%rdx, %rax
	movq	%rax, %rdx
	salq	%cl, %rdx
	xorq	%rax, %rdx
	movq	%rdx, %rax
	salq	%cl, %rax
	xorq	%rdx, %rax
	movq	%rax, %rdx
	salq	%cl, %rdx
	xorq	%rax, %rdx
	movq	%rdx, %rax
	salq	%cl, %rax
	xorq	%rdx, %rax
	movq	%rax, %rdx
	salq	%cl, %rdx
	xorq	%rax, %rdx
	movq	%rdx, %rax
	salq	%cl, %rax
	xorq	%rdx, %rax
	movq	%rax, %rdx
	salq	%cl, %rdx
	xorq	%rax, %rdx
	movq	%rdx, %rax
	salq	%cl, %rax
	xorq	%rdx, %rax
	movq	%rax, %rdx
	salq	%cl, %rdx
	xorq	%rax, %rdx
	movq	%rdx, %rax
	salq	%cl, %rax
	xorq	%rdx, %rax
	movq	%rax, %rdx
	salq	%cl, %rdx
	xorq	%rax, %rdx
	movq	%rdx, %rax
	salq	%cl, %rax
	xorq	%rdx, %rax
	movq	%rax, %rdx
	salq	%cl, %rdx
	xorq	%rax, %rdx
	movq	%rdx, %rax
	salq	%cl, %rax
	xorq	%rdx, %rax
	movq	%rax, %rdx
	salq	%cl, %rdx
	xorq	%rax, %rdx
	movq	%rdx, %rax
	salq	%cl, %rax
	xorq	%rdx, %rax
	movq	%rax, %rdx
	salq	%cl, %rdx
	xorq	%rax, %rdx
	movq	%rdx, %rax
	salq	%cl, %rax
	xorq	%rdx, %rax
	movq	%rax, %rdx
	salq	%cl, %rdx
	xorq	%rax, %rdx
	movq	%rdx, %rax
	salq	%cl, %rax
	xorq	%rdx, %rax
	movq	%rax, %rdx
	salq	%cl, %rdx
	xorq	%rax, %rdx
	movq	%rdx, %rax
	salq	%cl, %rax
	xorq	%rdx, %rax
	movq	%rax, %rdx
	salq	%cl, %rdx
	xorq	%rax, %rdx
	movq	%rdx, %rax
	salq	%cl, %rax
	xorq	%rdx, %rax
	movq	%rax, %rdx
	salq	%cl, %rdx
	xorq	%rax, %rdx
	movq	%rdx, %rax
	salq	%cl, %rax
	xorq	%rdx, %rax
	movq	%rax, %rdx
	salq	%cl, %rdx
	xorq	%rax, %rdx
	movq	%rdx, %rax
	salq	%cl, %rax
	xorq	%rdx, %rax
	movq	%rax, %rdx
	salq	%cl, %rdx
	xorq	%rax, %rdx
	movq	%rdx, %rax
	salq	%cl, %rax
	xorq	%rdx, %rax
	movq	%rax, %rdx
	salq	%cl, %rdx
	xorq	%rax, %rdx
	movq	%rdx, %rax
	salq	%cl, %rax
	xorq	%rdx, %rax
	movq	%rax, %rdx
	salq	%cl, %rdx
	xorq	%rax, %rdx
	movq	%rdx, %rax
	salq	%cl, %rax
	xorq	%rdx, %rax
	movq	%rax, %rdx
	salq	%cl, %rdx
	xorq	%rax, %rdx
	movq	%rdx, %rax
	salq	%cl, %rax
	xorq	%rdx, %rax
	movq	%rax, %rdx
	salq	%cl, %rdx
	xorq	%rax, %rdx
	movq	%rdx, %rax
	salq	%cl, %rax
	xorq	%rdx, %rax
	movq	%rax, %rdx
	salq	%cl, %rdx
	xorq	%rax, %rdx
	movq	%rdx, %rax
	salq	%cl, %rax
	xorq	%rdx, %rax
	movq	%rax, %rdx
	salq	%cl, %rdx
	xorq	%rax, %rdx
	movq	%rdx, %rax
	salq	%cl, %rax
	xorq	%rdx, %rax
	movq	%rax, %rdx
	salq	%cl, %rdx
	xorq	%rax, %rdx
	movq	%rdx, %rax
	salq	%cl, %rax
	xorq	%rdx, %rax
	movq	%rax, %rdx
	salq	%cl, %rdx
	xorq	%rax, %rdx
	movq	%rdx, %rax
	salq	%cl, %rax
	xorq	%rdx, %rax
	movq	%rax, %rdx
	salq	%cl, %rdx
	xorq	%rax, %rdx
	movq	%rdx, %rax
	salq	%cl, %rax
	xorq	%rdx, %rax
	movq	%rax, %rdx
	salq	%cl, %rdx
	xorq	%rax, %rdx
	movq	%rdx, %rax
	salq	%cl, %rax
	xorq	%rdx, %rax
	movq	%rax, %rdx
	salq	%cl, %rdx
	xorq	%rax, %rdx
	movq	%rdx, %rax
	salq	%cl, %rax
	xorq	%rdx, %rax
	movq	%rax, %rdx
	salq	%cl, %rdx
	xorq	%rax, %rdx
	movq	%rdx, %rax
	salq	%cl, %rax
	xorq	%rdx, %rax
	movq	%rax, %rdx
	salq	%cl, %rdx
	xorq	%rax, %rdx
	subq	$1, %rdi
	jne	.L239
.L238:
	addq	%rcx, %rdx
	leaq	(%rsi,%rdx,8), %rax
	ret
	.cfi_endproc
.LFE88:
	.size	_mhz_6, .-_mhz_6
	.globl	mhz_6
	.type	mhz_6, @function
mhz_6:
.LFB89:
	.cfi_startproc
	endbr64
	pushq	%r14
	.cfi_def_cfa_offset 16
	.cfi_offset 14, -16
	pushq	%r12
	.cfi_def_cfa_offset 24
	.cfi_offset 12, -24
	pushq	%rbp
	.cfi_def_cfa_offset 32
	.cfi_offset 6, -32
	pushq	%rbx
	.cfi_def_cfa_offset 40
	.cfi_offset 3, -40
	subq	$40, %rsp
	.cfi_def_cfa_offset 80
	movq	%fs:40, %rax
	movq	%rax, 24(%rsp)
	xorl	%eax, %eax
	leaq	16(%rsp), %rax
	movq	%rax, 16(%rsp)
	call	get_enough@PLT
	pxor	%xmm6, %xmm6
	cvtsi2sdl	%eax, %xmm6
	movsd	%xmm6, 8(%rsp)
	mulsd	.LC2(%rip), %xmm6
	movq	%xmm6, %rbp
	movl	$0, %ebx
	comisd	.LC1(%rip), %xmm6
	ja	.L256
	pxor	%xmm5, %xmm5
	movsd	%xmm5, (%rsp)
	movl	$0, %ebx
	jmp	.L242
.L245:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
	movsd	%xmm0, (%rsp)
	jmp	.L246
.L252:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rdx, %xmm1
	addsd	%xmm1, %xmm1
	jmp	.L253
.L254:
	subsd	.LC8(%rip), %xmm0
	cvttsd2siq	%xmm0, %rax
	movq	%rax, __iterations.3(%rip)
	btcq	$63, __iterations.3(%rip)
	jmp	.L248
.L279:
	movq	__iterations.3(%rip), %rax
	cmpq	$134217728, %rax
	ja	.L271
	salq	$3, %rax
	movq	%rax, __iterations.3(%rip)
.L248:
	movq	%rbp, %xmm4
	comisd	(%rsp), %xmm4
	jbe	.L242
.L256:
	movl	$0, %edi
	call	start@PLT
	movq	__iterations.3(%rip), %rdi
	testq	%rdi, %rdi
	je	.L244
	leaq	16(%rsp), %rsi
	movl	$1, %ecx
	movl	$1, %edx
	call	_mhz_6
	movq	%rax, %rbx
.L244:
	movl	$0, %esi
	movl	$0, %edi
	call	stop@PLT
	testq	%rax, %rax
	js	.L245
	pxor	%xmm7, %xmm7
	cvtsi2sdq	%rax, %xmm7
	movsd	%xmm7, (%rsp)
.L246:
	movsd	.LC3(%rip), %xmm0
	movsd	8(%rsp), %xmm2
	mulsd	%xmm2, %xmm0
	movsd	(%rsp), %xmm3
	comisd	%xmm3, %xmm0
	ja	.L247
	mulsd	.LC4(%rip), %xmm2
	comisd	%xmm2, %xmm3
	jbe	.L248
.L247:
	movsd	(%rsp), %xmm6
	comisd	.LC5(%rip), %xmm6
	jbe	.L279
	movq	__iterations.3(%rip), %rax
	testq	%rax, %rax
	js	.L252
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rax, %xmm1
.L253:
	divsd	(%rsp), %xmm1
	movsd	8(%rsp), %xmm0
	mulsd	.LC6(%rip), %xmm0
	mulsd	%xmm1, %xmm0
	addsd	.LC7(%rip), %xmm0
	comisd	.LC8(%rip), %xmm0
	jnb	.L254
	cvttsd2siq	%xmm0, %rax
	movq	%rax, __iterations.3(%rip)
	jmp	.L248
.L271:
	pxor	%xmm5, %xmm5
	movsd	%xmm5, (%rsp)
.L242:
	movq	__iterations.3(%rip), %rdi
	call	save_n@PLT
	movsd	(%rsp), %xmm7
	comisd	.LC8(%rip), %xmm7
	jnb	.L257
	cvttsd2siq	%xmm7, %rdi
.L258:
	call	settime@PLT
	call	usecs_spent@PLT
	testq	%rax, %rax
	js	.L259
	pxor	%xmm4, %xmm4
	cvtsi2sdq	%rax, %xmm4
	movq	%xmm4, %r14
.L260:
	call	t_overhead@PLT
	movq	%rax, %rbp
	call	get_n@PLT
	movq	%rax, %r12
	call	l_overhead@PLT
	movapd	%xmm0, %xmm1
	testq	%r12, %r12
	js	.L261
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%r12, %xmm0
.L262:
	mulsd	%xmm1, %xmm0
	testq	%rbp, %rbp
	js	.L263
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rbp, %xmm1
.L264:
	addsd	%xmm1, %xmm0
	movq	%r14, %xmm1
	subsd	%xmm0, %xmm1
	movl	$0, %edi
	comisd	.LC1(%rip), %xmm1
	jb	.L265
	comisd	.LC8(%rip), %xmm1
	jnb	.L267
	cvttsd2siq	%xmm1, %rdi
.L265:
	call	settime@PLT
	movq	%rbx, %rdi
	call	use_pointer@PLT
	call	get_n@PLT
	leaq	(%rax,%rax,4), %rax
	leaq	(%rax,%rax,4), %rdi
	salq	$2, %rdi
	call	save_n@PLT
	movq	24(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L282
	addq	$40, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 40
	popq	%rbx
	.cfi_def_cfa_offset 32
	popq	%rbp
	.cfi_def_cfa_offset 24
	popq	%r12
	.cfi_def_cfa_offset 16
	popq	%r14
	.cfi_def_cfa_offset 8
	ret
.L257:
	.cfi_restore_state
	movsd	(%rsp), %xmm0
	subsd	.LC8(%rip), %xmm0
	cvttsd2siq	%xmm0, %rdi
	btcq	$63, %rdi
	jmp	.L258
.L259:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rdx, %xmm1
	addsd	%xmm1, %xmm1
	movq	%xmm1, %r14
	jmp	.L260
.L261:
	movq	%r12, %rax
	shrq	%rax
	andl	$1, %r12d
	orq	%r12, %rax
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	addsd	%xmm0, %xmm0
	jmp	.L262
.L263:
	movq	%rbp, %rax
	shrq	%rax
	andl	$1, %ebp
	orq	%rbp, %rax
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rax, %xmm1
	addsd	%xmm1, %xmm1
	jmp	.L264
.L267:
	subsd	.LC8(%rip), %xmm1
	cvttsd2siq	%xmm1, %rdi
	btcq	$63, %rdi
	jmp	.L265
.L282:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE89:
	.size	mhz_6, .-mhz_6
	.section	.rodata.str1.1
.LC14:
	.string	"a^=a+b;"
	.text
	.globl	name_7
	.type	name_7, @function
name_7:
.LFB90:
	.cfi_startproc
	endbr64
	leaq	.LC14(%rip), %rax
	ret
	.cfi_endproc
.LFE90:
	.size	name_7, .-name_7
	.globl	_mhz_7
	.type	_mhz_7, @function
_mhz_7:
.LFB91:
	.cfi_startproc
	endbr64
	movq	%rcx, %rax
	testq	%rdi, %rdi
	jle	.L285
.L286:
	leaq	(%rax,%rdx), %rcx
	xorq	%rdx, %rcx
	leaq	(%rax,%rcx), %rdx
	xorq	%rcx, %rdx
	leaq	(%rax,%rdx), %rcx
	xorq	%rdx, %rcx
	leaq	(%rax,%rcx), %rdx
	xorq	%rcx, %rdx
	leaq	(%rax,%rdx), %rcx
	xorq	%rdx, %rcx
	leaq	(%rax,%rcx), %rdx
	xorq	%rcx, %rdx
	leaq	(%rax,%rdx), %rcx
	xorq	%rdx, %rcx
	leaq	(%rax,%rcx), %rdx
	xorq	%rcx, %rdx
	leaq	(%rax,%rdx), %rcx
	xorq	%rdx, %rcx
	leaq	(%rax,%rcx), %rdx
	xorq	%rcx, %rdx
	leaq	(%rax,%rdx), %rcx
	xorq	%rdx, %rcx
	leaq	(%rax,%rcx), %rdx
	xorq	%rcx, %rdx
	leaq	(%rax,%rdx), %rcx
	xorq	%rdx, %rcx
	leaq	(%rax,%rcx), %rdx
	xorq	%rcx, %rdx
	leaq	(%rax,%rdx), %rcx
	xorq	%rdx, %rcx
	leaq	(%rax,%rcx), %rdx
	xorq	%rcx, %rdx
	leaq	(%rax,%rdx), %rcx
	xorq	%rdx, %rcx
	leaq	(%rax,%rcx), %rdx
	xorq	%rcx, %rdx
	leaq	(%rax,%rdx), %rcx
	xorq	%rdx, %rcx
	leaq	(%rax,%rcx), %rdx
	xorq	%rcx, %rdx
	leaq	(%rax,%rdx), %rcx
	xorq	%rdx, %rcx
	leaq	(%rax,%rcx), %rdx
	xorq	%rcx, %rdx
	leaq	(%rax,%rdx), %rcx
	xorq	%rdx, %rcx
	leaq	(%rax,%rcx), %rdx
	xorq	%rcx, %rdx
	leaq	(%rax,%rdx), %rcx
	xorq	%rdx, %rcx
	leaq	(%rax,%rcx), %rdx
	xorq	%rcx, %rdx
	leaq	(%rax,%rdx), %rcx
	xorq	%rdx, %rcx
	leaq	(%rax,%rcx), %rdx
	xorq	%rcx, %rdx
	leaq	(%rax,%rdx), %rcx
	xorq	%rdx, %rcx
	leaq	(%rax,%rcx), %rdx
	xorq	%rcx, %rdx
	leaq	(%rax,%rdx), %rcx
	xorq	%rdx, %rcx
	leaq	(%rax,%rcx), %rdx
	xorq	%rcx, %rdx
	leaq	(%rax,%rdx), %rcx
	xorq	%rdx, %rcx
	leaq	(%rax,%rcx), %rdx
	xorq	%rcx, %rdx
	leaq	(%rax,%rdx), %rcx
	xorq	%rdx, %rcx
	leaq	(%rax,%rcx), %rdx
	xorq	%rcx, %rdx
	leaq	(%rax,%rdx), %rcx
	xorq	%rdx, %rcx
	leaq	(%rax,%rcx), %rdx
	xorq	%rcx, %rdx
	leaq	(%rax,%rdx), %rcx
	xorq	%rdx, %rcx
	leaq	(%rax,%rcx), %rdx
	xorq	%rcx, %rdx
	leaq	(%rax,%rdx), %rcx
	xorq	%rdx, %rcx
	leaq	(%rax,%rcx), %rdx
	xorq	%rcx, %rdx
	leaq	(%rax,%rdx), %rcx
	xorq	%rdx, %rcx
	leaq	(%rax,%rcx), %rdx
	xorq	%rcx, %rdx
	leaq	(%rax,%rdx), %rcx
	xorq	%rdx, %rcx
	leaq	(%rax,%rcx), %rdx
	xorq	%rcx, %rdx
	leaq	(%rax,%rdx), %rcx
	xorq	%rdx, %rcx
	leaq	(%rax,%rcx), %rdx
	xorq	%rcx, %rdx
	leaq	(%rax,%rdx), %rcx
	xorq	%rdx, %rcx
	leaq	(%rax,%rcx), %rdx
	xorq	%rcx, %rdx
	leaq	(%rax,%rdx), %rcx
	xorq	%rdx, %rcx
	leaq	(%rax,%rcx), %rdx
	xorq	%rcx, %rdx
	leaq	(%rax,%rdx), %rcx
	xorq	%rdx, %rcx
	leaq	(%rax,%rcx), %rdx
	xorq	%rcx, %rdx
	leaq	(%rax,%rdx), %rcx
	xorq	%rdx, %rcx
	leaq	(%rax,%rcx), %rdx
	xorq	%rcx, %rdx
	leaq	(%rax,%rdx), %rcx
	xorq	%rdx, %rcx
	leaq	(%rax,%rcx), %rdx
	xorq	%rcx, %rdx
	leaq	(%rax,%rdx), %rcx
	xorq	%rdx, %rcx
	leaq	(%rax,%rcx), %rdx
	xorq	%rcx, %rdx
	leaq	(%rax,%rdx), %rcx
	xorq	%rdx, %rcx
	leaq	(%rax,%rcx), %rdx
	xorq	%rcx, %rdx
	leaq	(%rax,%rdx), %rcx
	xorq	%rdx, %rcx
	leaq	(%rax,%rcx), %rdx
	xorq	%rcx, %rdx
	leaq	(%rax,%rdx), %rcx
	xorq	%rdx, %rcx
	leaq	(%rax,%rcx), %rdx
	xorq	%rcx, %rdx
	leaq	(%rax,%rdx), %rcx
	xorq	%rdx, %rcx
	leaq	(%rax,%rcx), %rdx
	xorq	%rcx, %rdx
	leaq	(%rax,%rdx), %rcx
	xorq	%rdx, %rcx
	leaq	(%rax,%rcx), %rdx
	xorq	%rcx, %rdx
	leaq	(%rax,%rdx), %rcx
	xorq	%rdx, %rcx
	leaq	(%rax,%rcx), %rdx
	xorq	%rcx, %rdx
	leaq	(%rax,%rdx), %rcx
	xorq	%rdx, %rcx
	leaq	(%rax,%rcx), %rdx
	xorq	%rcx, %rdx
	leaq	(%rax,%rdx), %rcx
	xorq	%rdx, %rcx
	leaq	(%rax,%rcx), %rdx
	xorq	%rcx, %rdx
	leaq	(%rax,%rdx), %rcx
	xorq	%rdx, %rcx
	leaq	(%rax,%rcx), %rdx
	xorq	%rcx, %rdx
	leaq	(%rax,%rdx), %rcx
	xorq	%rdx, %rcx
	leaq	(%rax,%rcx), %rdx
	xorq	%rcx, %rdx
	leaq	(%rax,%rdx), %rcx
	xorq	%rdx, %rcx
	leaq	(%rax,%rcx), %rdx
	xorq	%rcx, %rdx
	leaq	(%rax,%rdx), %rcx
	xorq	%rdx, %rcx
	leaq	(%rax,%rcx), %rdx
	xorq	%rcx, %rdx
	leaq	(%rax,%rdx), %rcx
	xorq	%rdx, %rcx
	leaq	(%rax,%rcx), %rdx
	xorq	%rcx, %rdx
	leaq	(%rax,%rdx), %rcx
	xorq	%rdx, %rcx
	leaq	(%rax,%rcx), %rdx
	xorq	%rcx, %rdx
	leaq	(%rax,%rdx), %rcx
	xorq	%rdx, %rcx
	leaq	(%rax,%rcx), %rdx
	xorq	%rcx, %rdx
	leaq	(%rax,%rdx), %rcx
	xorq	%rdx, %rcx
	leaq	(%rax,%rcx), %rdx
	xorq	%rcx, %rdx
	leaq	(%rax,%rdx), %rcx
	xorq	%rdx, %rcx
	leaq	(%rax,%rcx), %rdx
	xorq	%rcx, %rdx
	leaq	(%rax,%rdx), %rcx
	xorq	%rdx, %rcx
	leaq	(%rax,%rcx), %rdx
	xorq	%rcx, %rdx
	leaq	(%rax,%rdx), %rcx
	xorq	%rdx, %rcx
	leaq	(%rax,%rcx), %rdx
	xorq	%rcx, %rdx
	leaq	(%rax,%rdx), %rcx
	xorq	%rdx, %rcx
	leaq	(%rax,%rcx), %rdx
	xorq	%rcx, %rdx
	subq	$1, %rdi
	jne	.L286
.L285:
	addq	%rax, %rdx
	leaq	(%rsi,%rdx,8), %rax
	ret
	.cfi_endproc
.LFE91:
	.size	_mhz_7, .-_mhz_7
	.globl	mhz_7
	.type	mhz_7, @function
mhz_7:
.LFB92:
	.cfi_startproc
	endbr64
	pushq	%r14
	.cfi_def_cfa_offset 16
	.cfi_offset 14, -16
	pushq	%r12
	.cfi_def_cfa_offset 24
	.cfi_offset 12, -24
	pushq	%rbp
	.cfi_def_cfa_offset 32
	.cfi_offset 6, -32
	pushq	%rbx
	.cfi_def_cfa_offset 40
	.cfi_offset 3, -40
	subq	$40, %rsp
	.cfi_def_cfa_offset 80
	movq	%fs:40, %rax
	movq	%rax, 24(%rsp)
	xorl	%eax, %eax
	leaq	16(%rsp), %rax
	movq	%rax, 16(%rsp)
	call	get_enough@PLT
	pxor	%xmm6, %xmm6
	cvtsi2sdl	%eax, %xmm6
	movsd	%xmm6, 8(%rsp)
	mulsd	.LC2(%rip), %xmm6
	movq	%xmm6, %rbp
	movl	$0, %ebx
	comisd	.LC1(%rip), %xmm6
	ja	.L303
	pxor	%xmm5, %xmm5
	movsd	%xmm5, (%rsp)
	movl	$0, %ebx
	jmp	.L289
.L292:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
	movsd	%xmm0, (%rsp)
	jmp	.L293
.L299:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rdx, %xmm1
	addsd	%xmm1, %xmm1
	jmp	.L300
.L301:
	subsd	.LC8(%rip), %xmm0
	cvttsd2siq	%xmm0, %rax
	movq	%rax, __iterations.2(%rip)
	btcq	$63, __iterations.2(%rip)
	jmp	.L295
.L326:
	movq	__iterations.2(%rip), %rax
	cmpq	$134217728, %rax
	ja	.L318
	salq	$3, %rax
	movq	%rax, __iterations.2(%rip)
.L295:
	movq	%rbp, %xmm4
	comisd	(%rsp), %xmm4
	jbe	.L289
.L303:
	movl	$0, %edi
	call	start@PLT
	movq	__iterations.2(%rip), %rdi
	testq	%rdi, %rdi
	je	.L291
	leaq	16(%rsp), %rsi
	movl	$1, %ecx
	movl	$1, %edx
	call	_mhz_7
	movq	%rax, %rbx
.L291:
	movl	$0, %esi
	movl	$0, %edi
	call	stop@PLT
	testq	%rax, %rax
	js	.L292
	pxor	%xmm7, %xmm7
	cvtsi2sdq	%rax, %xmm7
	movsd	%xmm7, (%rsp)
.L293:
	movsd	.LC3(%rip), %xmm0
	movsd	8(%rsp), %xmm2
	mulsd	%xmm2, %xmm0
	movsd	(%rsp), %xmm3
	comisd	%xmm3, %xmm0
	ja	.L294
	mulsd	.LC4(%rip), %xmm2
	comisd	%xmm2, %xmm3
	jbe	.L295
.L294:
	movsd	(%rsp), %xmm6
	comisd	.LC5(%rip), %xmm6
	jbe	.L326
	movq	__iterations.2(%rip), %rax
	testq	%rax, %rax
	js	.L299
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rax, %xmm1
.L300:
	divsd	(%rsp), %xmm1
	movsd	8(%rsp), %xmm0
	mulsd	.LC6(%rip), %xmm0
	mulsd	%xmm1, %xmm0
	addsd	.LC7(%rip), %xmm0
	comisd	.LC8(%rip), %xmm0
	jnb	.L301
	cvttsd2siq	%xmm0, %rax
	movq	%rax, __iterations.2(%rip)
	jmp	.L295
.L318:
	pxor	%xmm5, %xmm5
	movsd	%xmm5, (%rsp)
.L289:
	movq	__iterations.2(%rip), %rdi
	call	save_n@PLT
	movsd	(%rsp), %xmm7
	comisd	.LC8(%rip), %xmm7
	jnb	.L304
	cvttsd2siq	%xmm7, %rdi
.L305:
	call	settime@PLT
	call	usecs_spent@PLT
	testq	%rax, %rax
	js	.L306
	pxor	%xmm4, %xmm4
	cvtsi2sdq	%rax, %xmm4
	movq	%xmm4, %r14
.L307:
	call	t_overhead@PLT
	movq	%rax, %rbp
	call	get_n@PLT
	movq	%rax, %r12
	call	l_overhead@PLT
	movapd	%xmm0, %xmm1
	testq	%r12, %r12
	js	.L308
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%r12, %xmm0
.L309:
	mulsd	%xmm1, %xmm0
	testq	%rbp, %rbp
	js	.L310
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rbp, %xmm1
.L311:
	addsd	%xmm1, %xmm0
	movq	%r14, %xmm1
	subsd	%xmm0, %xmm1
	movl	$0, %edi
	comisd	.LC1(%rip), %xmm1
	jb	.L312
	comisd	.LC8(%rip), %xmm1
	jnb	.L314
	cvttsd2siq	%xmm1, %rdi
.L312:
	call	settime@PLT
	movq	%rbx, %rdi
	call	use_pointer@PLT
	call	get_n@PLT
	leaq	(%rax,%rax,4), %rax
	leaq	(%rax,%rax,4), %rdi
	salq	$2, %rdi
	call	save_n@PLT
	movq	24(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L329
	addq	$40, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 40
	popq	%rbx
	.cfi_def_cfa_offset 32
	popq	%rbp
	.cfi_def_cfa_offset 24
	popq	%r12
	.cfi_def_cfa_offset 16
	popq	%r14
	.cfi_def_cfa_offset 8
	ret
.L304:
	.cfi_restore_state
	movsd	(%rsp), %xmm0
	subsd	.LC8(%rip), %xmm0
	cvttsd2siq	%xmm0, %rdi
	btcq	$63, %rdi
	jmp	.L305
.L306:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rdx, %xmm1
	addsd	%xmm1, %xmm1
	movq	%xmm1, %r14
	jmp	.L307
.L308:
	movq	%r12, %rax
	shrq	%rax
	andl	$1, %r12d
	orq	%r12, %rax
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	addsd	%xmm0, %xmm0
	jmp	.L309
.L310:
	movq	%rbp, %rax
	shrq	%rax
	andl	$1, %ebp
	orq	%rbp, %rax
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rax, %xmm1
	addsd	%xmm1, %xmm1
	jmp	.L311
.L314:
	subsd	.LC8(%rip), %xmm1
	cvttsd2siq	%xmm1, %rdi
	btcq	$63, %rdi
	jmp	.L312
.L329:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE92:
	.size	mhz_7, .-mhz_7
	.section	.rodata.str1.1
.LC15:
	.string	"a+=(a+b)&07;"
	.text
	.globl	name_8
	.type	name_8, @function
name_8:
.LFB93:
	.cfi_startproc
	endbr64
	leaq	.LC15(%rip), %rax
	ret
	.cfi_endproc
.LFE93:
	.size	name_8, .-name_8
	.globl	_mhz_8
	.type	_mhz_8, @function
_mhz_8:
.LFB94:
	.cfi_startproc
	endbr64
	movq	%rcx, %rax
	testq	%rdi, %rdi
	jle	.L332
.L333:
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rdx, %rcx
	leaq	(%rax,%rcx), %rdx
	andl	$7, %edx
	addq	%rcx, %rdx
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rdx, %rcx
	leaq	(%rax,%rcx), %rdx
	andl	$7, %edx
	addq	%rcx, %rdx
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rdx, %rcx
	leaq	(%rax,%rcx), %rdx
	andl	$7, %edx
	addq	%rcx, %rdx
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rdx, %rcx
	leaq	(%rax,%rcx), %rdx
	andl	$7, %edx
	addq	%rcx, %rdx
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rdx, %rcx
	leaq	(%rax,%rcx), %rdx
	andl	$7, %edx
	addq	%rcx, %rdx
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rdx, %rcx
	leaq	(%rax,%rcx), %rdx
	andl	$7, %edx
	addq	%rcx, %rdx
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rdx, %rcx
	leaq	(%rax,%rcx), %rdx
	andl	$7, %edx
	addq	%rcx, %rdx
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rdx, %rcx
	leaq	(%rax,%rcx), %rdx
	andl	$7, %edx
	addq	%rcx, %rdx
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rdx, %rcx
	leaq	(%rax,%rcx), %rdx
	andl	$7, %edx
	addq	%rcx, %rdx
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rdx, %rcx
	leaq	(%rax,%rcx), %rdx
	andl	$7, %edx
	addq	%rcx, %rdx
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rdx, %rcx
	leaq	(%rax,%rcx), %rdx
	andl	$7, %edx
	addq	%rcx, %rdx
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rdx, %rcx
	leaq	(%rax,%rcx), %rdx
	andl	$7, %edx
	addq	%rcx, %rdx
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rdx, %rcx
	leaq	(%rax,%rcx), %rdx
	andl	$7, %edx
	addq	%rcx, %rdx
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rdx, %rcx
	leaq	(%rax,%rcx), %rdx
	andl	$7, %edx
	addq	%rcx, %rdx
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rdx, %rcx
	leaq	(%rax,%rcx), %rdx
	andl	$7, %edx
	addq	%rcx, %rdx
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rdx, %rcx
	leaq	(%rax,%rcx), %rdx
	andl	$7, %edx
	addq	%rcx, %rdx
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rdx, %rcx
	leaq	(%rax,%rcx), %rdx
	andl	$7, %edx
	addq	%rcx, %rdx
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rdx, %rcx
	leaq	(%rax,%rcx), %rdx
	andl	$7, %edx
	addq	%rcx, %rdx
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rdx, %rcx
	leaq	(%rax,%rcx), %rdx
	andl	$7, %edx
	addq	%rcx, %rdx
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rdx, %rcx
	leaq	(%rax,%rcx), %rdx
	andl	$7, %edx
	addq	%rcx, %rdx
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rdx, %rcx
	leaq	(%rax,%rcx), %rdx
	andl	$7, %edx
	addq	%rcx, %rdx
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rdx, %rcx
	leaq	(%rax,%rcx), %rdx
	andl	$7, %edx
	addq	%rcx, %rdx
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rdx, %rcx
	leaq	(%rax,%rcx), %rdx
	andl	$7, %edx
	addq	%rcx, %rdx
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rdx, %rcx
	leaq	(%rax,%rcx), %rdx
	andl	$7, %edx
	addq	%rcx, %rdx
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rdx, %rcx
	leaq	(%rax,%rcx), %rdx
	andl	$7, %edx
	addq	%rcx, %rdx
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rdx, %rcx
	leaq	(%rax,%rcx), %rdx
	andl	$7, %edx
	addq	%rcx, %rdx
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rdx, %rcx
	leaq	(%rax,%rcx), %rdx
	andl	$7, %edx
	addq	%rcx, %rdx
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rdx, %rcx
	leaq	(%rax,%rcx), %rdx
	andl	$7, %edx
	addq	%rcx, %rdx
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rdx, %rcx
	leaq	(%rax,%rcx), %rdx
	andl	$7, %edx
	addq	%rcx, %rdx
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rdx, %rcx
	leaq	(%rax,%rcx), %rdx
	andl	$7, %edx
	addq	%rcx, %rdx
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rdx, %rcx
	leaq	(%rax,%rcx), %rdx
	andl	$7, %edx
	addq	%rcx, %rdx
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rdx, %rcx
	leaq	(%rax,%rcx), %rdx
	andl	$7, %edx
	addq	%rcx, %rdx
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rdx, %rcx
	leaq	(%rax,%rcx), %rdx
	andl	$7, %edx
	addq	%rcx, %rdx
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rdx, %rcx
	leaq	(%rax,%rcx), %rdx
	andl	$7, %edx
	addq	%rcx, %rdx
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rdx, %rcx
	leaq	(%rax,%rcx), %rdx
	andl	$7, %edx
	addq	%rcx, %rdx
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rdx, %rcx
	leaq	(%rax,%rcx), %rdx
	andl	$7, %edx
	addq	%rcx, %rdx
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rdx, %rcx
	leaq	(%rax,%rcx), %rdx
	andl	$7, %edx
	addq	%rcx, %rdx
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rdx, %rcx
	leaq	(%rax,%rcx), %rdx
	andl	$7, %edx
	addq	%rcx, %rdx
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rdx, %rcx
	leaq	(%rax,%rcx), %rdx
	andl	$7, %edx
	addq	%rcx, %rdx
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rdx, %rcx
	leaq	(%rax,%rcx), %rdx
	andl	$7, %edx
	addq	%rcx, %rdx
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rdx, %rcx
	leaq	(%rax,%rcx), %rdx
	andl	$7, %edx
	addq	%rcx, %rdx
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rdx, %rcx
	leaq	(%rax,%rcx), %rdx
	andl	$7, %edx
	addq	%rcx, %rdx
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rdx, %rcx
	leaq	(%rax,%rcx), %rdx
	andl	$7, %edx
	addq	%rcx, %rdx
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rdx, %rcx
	leaq	(%rax,%rcx), %rdx
	andl	$7, %edx
	addq	%rcx, %rdx
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rdx, %rcx
	leaq	(%rax,%rcx), %rdx
	andl	$7, %edx
	addq	%rcx, %rdx
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rdx, %rcx
	leaq	(%rax,%rcx), %rdx
	andl	$7, %edx
	addq	%rcx, %rdx
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rdx, %rcx
	leaq	(%rax,%rcx), %rdx
	andl	$7, %edx
	addq	%rcx, %rdx
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rdx, %rcx
	leaq	(%rax,%rcx), %rdx
	andl	$7, %edx
	addq	%rcx, %rdx
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rdx, %rcx
	leaq	(%rax,%rcx), %rdx
	andl	$7, %edx
	addq	%rcx, %rdx
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rdx, %rcx
	leaq	(%rax,%rcx), %rdx
	andl	$7, %edx
	addq	%rcx, %rdx
	subq	$1, %rdi
	jne	.L333
.L332:
	addq	%rax, %rdx
	leaq	(%rsi,%rdx,8), %rax
	ret
	.cfi_endproc
.LFE94:
	.size	_mhz_8, .-_mhz_8
	.globl	mhz_8
	.type	mhz_8, @function
mhz_8:
.LFB95:
	.cfi_startproc
	endbr64
	pushq	%r14
	.cfi_def_cfa_offset 16
	.cfi_offset 14, -16
	pushq	%r12
	.cfi_def_cfa_offset 24
	.cfi_offset 12, -24
	pushq	%rbp
	.cfi_def_cfa_offset 32
	.cfi_offset 6, -32
	pushq	%rbx
	.cfi_def_cfa_offset 40
	.cfi_offset 3, -40
	subq	$40, %rsp
	.cfi_def_cfa_offset 80
	movq	%fs:40, %rax
	movq	%rax, 24(%rsp)
	xorl	%eax, %eax
	leaq	16(%rsp), %rax
	movq	%rax, 16(%rsp)
	call	get_enough@PLT
	pxor	%xmm6, %xmm6
	cvtsi2sdl	%eax, %xmm6
	movsd	%xmm6, 8(%rsp)
	mulsd	.LC2(%rip), %xmm6
	movq	%xmm6, %rbp
	movl	$0, %ebx
	comisd	.LC1(%rip), %xmm6
	ja	.L350
	pxor	%xmm5, %xmm5
	movsd	%xmm5, (%rsp)
	movl	$0, %ebx
	jmp	.L336
.L339:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
	movsd	%xmm0, (%rsp)
	jmp	.L340
.L346:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rdx, %xmm1
	addsd	%xmm1, %xmm1
	jmp	.L347
.L348:
	subsd	.LC8(%rip), %xmm0
	cvttsd2siq	%xmm0, %rax
	movq	%rax, __iterations.1(%rip)
	btcq	$63, __iterations.1(%rip)
	jmp	.L342
.L373:
	movq	__iterations.1(%rip), %rax
	cmpq	$134217728, %rax
	ja	.L365
	salq	$3, %rax
	movq	%rax, __iterations.1(%rip)
.L342:
	movq	%rbp, %xmm4
	comisd	(%rsp), %xmm4
	jbe	.L336
.L350:
	movl	$0, %edi
	call	start@PLT
	movq	__iterations.1(%rip), %rdi
	testq	%rdi, %rdi
	je	.L338
	leaq	16(%rsp), %rsi
	movl	$1, %ecx
	movl	$1, %edx
	call	_mhz_8
	movq	%rax, %rbx
.L338:
	movl	$0, %esi
	movl	$0, %edi
	call	stop@PLT
	testq	%rax, %rax
	js	.L339
	pxor	%xmm7, %xmm7
	cvtsi2sdq	%rax, %xmm7
	movsd	%xmm7, (%rsp)
.L340:
	movsd	.LC3(%rip), %xmm0
	movsd	8(%rsp), %xmm2
	mulsd	%xmm2, %xmm0
	movsd	(%rsp), %xmm3
	comisd	%xmm3, %xmm0
	ja	.L341
	mulsd	.LC4(%rip), %xmm2
	comisd	%xmm2, %xmm3
	jbe	.L342
.L341:
	movsd	(%rsp), %xmm6
	comisd	.LC5(%rip), %xmm6
	jbe	.L373
	movq	__iterations.1(%rip), %rax
	testq	%rax, %rax
	js	.L346
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rax, %xmm1
.L347:
	divsd	(%rsp), %xmm1
	movsd	8(%rsp), %xmm0
	mulsd	.LC6(%rip), %xmm0
	mulsd	%xmm1, %xmm0
	addsd	.LC7(%rip), %xmm0
	comisd	.LC8(%rip), %xmm0
	jnb	.L348
	cvttsd2siq	%xmm0, %rax
	movq	%rax, __iterations.1(%rip)
	jmp	.L342
.L365:
	pxor	%xmm5, %xmm5
	movsd	%xmm5, (%rsp)
.L336:
	movq	__iterations.1(%rip), %rdi
	call	save_n@PLT
	movsd	(%rsp), %xmm7
	comisd	.LC8(%rip), %xmm7
	jnb	.L351
	cvttsd2siq	%xmm7, %rdi
.L352:
	call	settime@PLT
	call	usecs_spent@PLT
	testq	%rax, %rax
	js	.L353
	pxor	%xmm4, %xmm4
	cvtsi2sdq	%rax, %xmm4
	movq	%xmm4, %r14
.L354:
	call	t_overhead@PLT
	movq	%rax, %rbp
	call	get_n@PLT
	movq	%rax, %r12
	call	l_overhead@PLT
	movapd	%xmm0, %xmm1
	testq	%r12, %r12
	js	.L355
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%r12, %xmm0
.L356:
	mulsd	%xmm1, %xmm0
	testq	%rbp, %rbp
	js	.L357
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rbp, %xmm1
.L358:
	addsd	%xmm1, %xmm0
	movq	%r14, %xmm1
	subsd	%xmm0, %xmm1
	movl	$0, %edi
	comisd	.LC1(%rip), %xmm1
	jb	.L359
	comisd	.LC8(%rip), %xmm1
	jnb	.L361
	cvttsd2siq	%xmm1, %rdi
.L359:
	call	settime@PLT
	movq	%rbx, %rdi
	call	use_pointer@PLT
	call	get_n@PLT
	leaq	(%rax,%rax,4), %rax
	leaq	(%rax,%rax,4), %rdi
	salq	$2, %rdi
	call	save_n@PLT
	movq	24(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L376
	addq	$40, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 40
	popq	%rbx
	.cfi_def_cfa_offset 32
	popq	%rbp
	.cfi_def_cfa_offset 24
	popq	%r12
	.cfi_def_cfa_offset 16
	popq	%r14
	.cfi_def_cfa_offset 8
	ret
.L351:
	.cfi_restore_state
	movsd	(%rsp), %xmm0
	subsd	.LC8(%rip), %xmm0
	cvttsd2siq	%xmm0, %rdi
	btcq	$63, %rdi
	jmp	.L352
.L353:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rdx, %xmm1
	addsd	%xmm1, %xmm1
	movq	%xmm1, %r14
	jmp	.L354
.L355:
	movq	%r12, %rax
	shrq	%rax
	andl	$1, %r12d
	orq	%r12, %rax
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	addsd	%xmm0, %xmm0
	jmp	.L356
.L357:
	movq	%rbp, %rax
	shrq	%rax
	andl	$1, %ebp
	orq	%rbp, %rax
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rax, %xmm1
	addsd	%xmm1, %xmm1
	jmp	.L358
.L361:
	subsd	.LC8(%rip), %xmm1
	cvttsd2siq	%xmm1, %rdi
	btcq	$63, %rdi
	jmp	.L359
.L376:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE95:
	.size	mhz_8, .-mhz_8
	.section	.rodata.str1.1
.LC16:
	.string	"a^=n;b^=a;a|=b;"
	.text
	.globl	name_9
	.type	name_9, @function
name_9:
.LFB96:
	.cfi_startproc
	endbr64
	leaq	.LC16(%rip), %rax
	ret
	.cfi_endproc
.LFE96:
	.size	name_9, .-name_9
	.globl	_mhz_9
	.type	_mhz_9, @function
_mhz_9:
.LFB97:
	.cfi_startproc
	endbr64
	movq	%rdi, %rax
	movq	%rsi, %rdi
	movq	%rcx, %r8
	testq	%rax, %rax
	jle	.L379
.L380:
	xorq	%rax, %rdx
	movq	%rdx, %rcx
	xorq	%r8, %rcx
	orq	%r8, %rdx
	xorq	%rax, %rdx
	movq	%rcx, %rsi
	xorq	%rdx, %rsi
	orq	%rdx, %rcx
	xorq	%rax, %rcx
	movq	%rsi, %rdx
	xorq	%rcx, %rdx
	orq	%rcx, %rsi
	xorq	%rax, %rsi
	movq	%rdx, %rcx
	xorq	%rsi, %rcx
	orq	%rsi, %rdx
	xorq	%rax, %rdx
	movq	%rcx, %rsi
	xorq	%rdx, %rsi
	orq	%rdx, %rcx
	xorq	%rax, %rcx
	movq	%rsi, %rdx
	xorq	%rcx, %rdx
	orq	%rcx, %rsi
	xorq	%rax, %rsi
	movq	%rdx, %rcx
	xorq	%rsi, %rcx
	orq	%rsi, %rdx
	xorq	%rax, %rdx
	movq	%rcx, %rsi
	xorq	%rdx, %rsi
	orq	%rdx, %rcx
	xorq	%rax, %rcx
	movq	%rsi, %rdx
	xorq	%rcx, %rdx
	orq	%rcx, %rsi
	xorq	%rax, %rsi
	movq	%rdx, %rcx
	xorq	%rsi, %rcx
	orq	%rsi, %rdx
	xorq	%rax, %rdx
	movq	%rcx, %rsi
	xorq	%rdx, %rsi
	orq	%rdx, %rcx
	xorq	%rax, %rcx
	movq	%rsi, %rdx
	xorq	%rcx, %rdx
	orq	%rcx, %rsi
	xorq	%rax, %rsi
	movq	%rdx, %rcx
	xorq	%rsi, %rcx
	orq	%rsi, %rdx
	xorq	%rax, %rdx
	movq	%rcx, %rsi
	xorq	%rdx, %rsi
	orq	%rdx, %rcx
	xorq	%rax, %rcx
	movq	%rsi, %rdx
	xorq	%rcx, %rdx
	orq	%rcx, %rsi
	xorq	%rax, %rsi
	movq	%rdx, %rcx
	xorq	%rsi, %rcx
	orq	%rsi, %rdx
	xorq	%rax, %rdx
	movq	%rcx, %rsi
	xorq	%rdx, %rsi
	orq	%rdx, %rcx
	xorq	%rax, %rcx
	movq	%rsi, %rdx
	xorq	%rcx, %rdx
	orq	%rcx, %rsi
	xorq	%rax, %rsi
	movq	%rdx, %rcx
	xorq	%rsi, %rcx
	orq	%rsi, %rdx
	xorq	%rax, %rdx
	movq	%rcx, %rsi
	xorq	%rdx, %rsi
	orq	%rdx, %rcx
	xorq	%rax, %rcx
	movq	%rsi, %rdx
	xorq	%rcx, %rdx
	orq	%rcx, %rsi
	xorq	%rax, %rsi
	movq	%rdx, %rcx
	xorq	%rsi, %rcx
	orq	%rsi, %rdx
	xorq	%rax, %rdx
	movq	%rcx, %rsi
	xorq	%rdx, %rsi
	orq	%rdx, %rcx
	xorq	%rax, %rcx
	movq	%rsi, %rdx
	xorq	%rcx, %rdx
	orq	%rcx, %rsi
	xorq	%rax, %rsi
	movq	%rdx, %rcx
	xorq	%rsi, %rcx
	orq	%rsi, %rdx
	xorq	%rax, %rdx
	movq	%rcx, %rsi
	xorq	%rdx, %rsi
	orq	%rdx, %rcx
	xorq	%rax, %rcx
	movq	%rsi, %rdx
	xorq	%rcx, %rdx
	orq	%rcx, %rsi
	xorq	%rax, %rsi
	movq	%rdx, %rcx
	xorq	%rsi, %rcx
	orq	%rsi, %rdx
	xorq	%rax, %rdx
	movq	%rcx, %rsi
	xorq	%rdx, %rsi
	orq	%rdx, %rcx
	xorq	%rax, %rcx
	movq	%rsi, %rdx
	xorq	%rcx, %rdx
	orq	%rcx, %rsi
	xorq	%rax, %rsi
	movq	%rdx, %rcx
	xorq	%rsi, %rcx
	orq	%rsi, %rdx
	xorq	%rax, %rdx
	movq	%rcx, %rsi
	xorq	%rdx, %rsi
	orq	%rdx, %rcx
	xorq	%rax, %rcx
	movq	%rsi, %rdx
	xorq	%rcx, %rdx
	orq	%rcx, %rsi
	xorq	%rax, %rsi
	movq	%rdx, %rcx
	xorq	%rsi, %rcx
	orq	%rsi, %rdx
	xorq	%rax, %rdx
	movq	%rcx, %rsi
	xorq	%rdx, %rsi
	orq	%rdx, %rcx
	xorq	%rax, %rcx
	movq	%rsi, %rdx
	xorq	%rcx, %rdx
	orq	%rcx, %rsi
	xorq	%rax, %rsi
	movq	%rdx, %rcx
	xorq	%rsi, %rcx
	orq	%rsi, %rdx
	xorq	%rax, %rdx
	movq	%rcx, %rsi
	xorq	%rdx, %rsi
	orq	%rdx, %rcx
	xorq	%rax, %rcx
	movq	%rsi, %rdx
	xorq	%rcx, %rdx
	orq	%rcx, %rsi
	xorq	%rax, %rsi
	movq	%rdx, %rcx
	xorq	%rsi, %rcx
	orq	%rsi, %rdx
	xorq	%rax, %rdx
	movq	%rcx, %rsi
	xorq	%rdx, %rsi
	orq	%rdx, %rcx
	xorq	%rax, %rcx
	movq	%rsi, %rdx
	xorq	%rcx, %rdx
	orq	%rcx, %rsi
	xorq	%rax, %rsi
	movq	%rdx, %rcx
	xorq	%rsi, %rcx
	orq	%rsi, %rdx
	xorq	%rax, %rdx
	movq	%rcx, %rsi
	xorq	%rdx, %rsi
	orq	%rdx, %rcx
	xorq	%rax, %rcx
	movq	%rsi, %rdx
	xorq	%rcx, %rdx
	orq	%rcx, %rsi
	xorq	%rax, %rsi
	movq	%rdx, %rcx
	xorq	%rsi, %rcx
	orq	%rsi, %rdx
	xorq	%rax, %rdx
	movq	%rcx, %rsi
	xorq	%rdx, %rsi
	orq	%rdx, %rcx
	xorq	%rax, %rcx
	movq	%rsi, %rdx
	xorq	%rcx, %rdx
	orq	%rcx, %rsi
	xorq	%rax, %rsi
	movq	%rdx, %rcx
	xorq	%rsi, %rcx
	orq	%rsi, %rdx
	xorq	%rax, %rdx
	movq	%rcx, %rsi
	xorq	%rdx, %rsi
	orq	%rdx, %rcx
	xorq	%rax, %rcx
	movq	%rsi, %rdx
	xorq	%rcx, %rdx
	orq	%rcx, %rsi
	xorq	%rax, %rsi
	movq	%rdx, %rcx
	xorq	%rsi, %rcx
	orq	%rsi, %rdx
	xorq	%rax, %rdx
	movq	%rcx, %rsi
	xorq	%rdx, %rsi
	orq	%rdx, %rcx
	xorq	%rax, %rcx
	movq	%rsi, %rdx
	xorq	%rcx, %rdx
	orq	%rcx, %rsi
	xorq	%rax, %rsi
	movq	%rdx, %rcx
	xorq	%rsi, %rcx
	orq	%rsi, %rdx
	xorq	%rax, %rdx
	movq	%rcx, %rsi
	xorq	%rdx, %rsi
	orq	%rdx, %rcx
	xorq	%rax, %rcx
	movq	%rsi, %rdx
	xorq	%rcx, %rdx
	orq	%rcx, %rsi
	xorq	%rax, %rsi
	movq	%rdx, %rcx
	xorq	%rsi, %rcx
	orq	%rsi, %rdx
	xorq	%rax, %rdx
	movq	%rcx, %rsi
	xorq	%rdx, %rsi
	orq	%rdx, %rcx
	xorq	%rax, %rcx
	movq	%rsi, %rdx
	xorq	%rcx, %rdx
	orq	%rcx, %rsi
	xorq	%rax, %rsi
	movq	%rdx, %rcx
	xorq	%rsi, %rcx
	orq	%rsi, %rdx
	xorq	%rax, %rdx
	movq	%rcx, %rsi
	xorq	%rdx, %rsi
	orq	%rdx, %rcx
	xorq	%rax, %rcx
	movq	%rsi, %rdx
	xorq	%rcx, %rdx
	orq	%rcx, %rsi
	xorq	%rax, %rsi
	movq	%rdx, %rcx
	xorq	%rsi, %rcx
	orq	%rsi, %rdx
	xorq	%rax, %rdx
	movq	%rcx, %rsi
	xorq	%rdx, %rsi
	orq	%rdx, %rcx
	xorq	%rax, %rcx
	movq	%rsi, %rdx
	xorq	%rcx, %rdx
	orq	%rcx, %rsi
	xorq	%rax, %rsi
	movq	%rdx, %rcx
	xorq	%rsi, %rcx
	orq	%rsi, %rdx
	xorq	%rax, %rdx
	movq	%rcx, %rsi
	xorq	%rdx, %rsi
	orq	%rdx, %rcx
	xorq	%rax, %rcx
	movq	%rsi, %rdx
	xorq	%rcx, %rdx
	orq	%rcx, %rsi
	xorq	%rax, %rsi
	movq	%rdx, %rcx
	xorq	%rsi, %rcx
	orq	%rsi, %rdx
	xorq	%rax, %rdx
	movq	%rcx, %rsi
	xorq	%rdx, %rsi
	orq	%rdx, %rcx
	xorq	%rax, %rcx
	movq	%rsi, %rdx
	xorq	%rcx, %rdx
	orq	%rcx, %rsi
	xorq	%rax, %rsi
	movq	%rdx, %rcx
	xorq	%rsi, %rcx
	orq	%rsi, %rdx
	xorq	%rax, %rdx
	movq	%rcx, %rsi
	xorq	%rdx, %rsi
	orq	%rdx, %rcx
	xorq	%rax, %rcx
	movq	%rsi, %rdx
	xorq	%rcx, %rdx
	orq	%rcx, %rsi
	xorq	%rax, %rsi
	movq	%rdx, %rcx
	xorq	%rsi, %rcx
	orq	%rsi, %rdx
	xorq	%rax, %rdx
	movq	%rcx, %rsi
	xorq	%rdx, %rsi
	orq	%rdx, %rcx
	xorq	%rax, %rcx
	movq	%rsi, %rdx
	xorq	%rcx, %rdx
	orq	%rcx, %rsi
	xorq	%rax, %rsi
	movq	%rdx, %rcx
	xorq	%rsi, %rcx
	orq	%rsi, %rdx
	xorq	%rax, %rdx
	movq	%rcx, %rsi
	xorq	%rdx, %rsi
	orq	%rdx, %rcx
	xorq	%rax, %rcx
	movq	%rsi, %rdx
	xorq	%rcx, %rdx
	orq	%rcx, %rsi
	xorq	%rax, %rsi
	movq	%rdx, %rcx
	xorq	%rsi, %rcx
	orq	%rsi, %rdx
	xorq	%rax, %rdx
	movq	%rcx, %rsi
	xorq	%rdx, %rsi
	orq	%rdx, %rcx
	xorq	%rax, %rcx
	movq	%rsi, %rdx
	xorq	%rcx, %rdx
	orq	%rcx, %rsi
	xorq	%rax, %rsi
	movq	%rdx, %rcx
	xorq	%rsi, %rcx
	orq	%rsi, %rdx
	xorq	%rax, %rdx
	movq	%rcx, %rsi
	xorq	%rdx, %rsi
	orq	%rdx, %rcx
	xorq	%rax, %rcx
	movq	%rsi, %rdx
	xorq	%rcx, %rdx
	orq	%rcx, %rsi
	xorq	%rax, %rsi
	movq	%rdx, %rcx
	xorq	%rsi, %rcx
	orq	%rsi, %rdx
	xorq	%rax, %rdx
	movq	%rcx, %rsi
	xorq	%rdx, %rsi
	orq	%rdx, %rcx
	xorq	%rax, %rcx
	movq	%rsi, %rdx
	xorq	%rcx, %rdx
	orq	%rcx, %rsi
	xorq	%rax, %rsi
	movq	%rdx, %rcx
	xorq	%rsi, %rcx
	orq	%rsi, %rdx
	xorq	%rax, %rdx
	movq	%rcx, %rsi
	xorq	%rdx, %rsi
	orq	%rdx, %rcx
	xorq	%rax, %rcx
	movq	%rsi, %rdx
	xorq	%rcx, %rdx
	orq	%rcx, %rsi
	xorq	%rax, %rsi
	movq	%rdx, %rcx
	xorq	%rsi, %rcx
	orq	%rsi, %rdx
	xorq	%rax, %rdx
	movq	%rcx, %rsi
	xorq	%rdx, %rsi
	orq	%rdx, %rcx
	xorq	%rax, %rcx
	movq	%rsi, %rdx
	xorq	%rcx, %rdx
	orq	%rcx, %rsi
	xorq	%rax, %rsi
	movq	%rdx, %rcx
	xorq	%rsi, %rcx
	orq	%rsi, %rdx
	xorq	%rax, %rdx
	movq	%rcx, %rsi
	xorq	%rdx, %rsi
	orq	%rdx, %rcx
	xorq	%rax, %rcx
	movq	%rsi, %rdx
	xorq	%rcx, %rdx
	orq	%rcx, %rsi
	xorq	%rax, %rsi
	movq	%rdx, %r8
	xorq	%rsi, %r8
	orq	%rsi, %rdx
	subq	$1, %rax
	jne	.L380
.L379:
	addq	%r8, %rdx
	leaq	(%rdi,%rdx,8), %rax
	ret
	.cfi_endproc
.LFE97:
	.size	_mhz_9, .-_mhz_9
	.globl	mhz_9
	.type	mhz_9, @function
mhz_9:
.LFB98:
	.cfi_startproc
	endbr64
	pushq	%r14
	.cfi_def_cfa_offset 16
	.cfi_offset 14, -16
	pushq	%r12
	.cfi_def_cfa_offset 24
	.cfi_offset 12, -24
	pushq	%rbp
	.cfi_def_cfa_offset 32
	.cfi_offset 6, -32
	pushq	%rbx
	.cfi_def_cfa_offset 40
	.cfi_offset 3, -40
	subq	$40, %rsp
	.cfi_def_cfa_offset 80
	movq	%fs:40, %rax
	movq	%rax, 24(%rsp)
	xorl	%eax, %eax
	leaq	16(%rsp), %rax
	movq	%rax, 16(%rsp)
	call	get_enough@PLT
	pxor	%xmm6, %xmm6
	cvtsi2sdl	%eax, %xmm6
	movsd	%xmm6, 8(%rsp)
	mulsd	.LC2(%rip), %xmm6
	movq	%xmm6, %rbp
	movl	$0, %ebx
	comisd	.LC1(%rip), %xmm6
	ja	.L397
	pxor	%xmm5, %xmm5
	movsd	%xmm5, (%rsp)
	movl	$0, %ebx
	jmp	.L383
.L386:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
	movsd	%xmm0, (%rsp)
	jmp	.L387
.L393:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rdx, %xmm1
	addsd	%xmm1, %xmm1
	jmp	.L394
.L395:
	subsd	.LC8(%rip), %xmm0
	cvttsd2siq	%xmm0, %rax
	movq	%rax, __iterations.0(%rip)
	btcq	$63, __iterations.0(%rip)
	jmp	.L389
.L420:
	movq	__iterations.0(%rip), %rax
	cmpq	$134217728, %rax
	ja	.L412
	salq	$3, %rax
	movq	%rax, __iterations.0(%rip)
.L389:
	movq	%rbp, %xmm4
	comisd	(%rsp), %xmm4
	jbe	.L383
.L397:
	movl	$0, %edi
	call	start@PLT
	movq	__iterations.0(%rip), %rdi
	testq	%rdi, %rdi
	je	.L385
	leaq	16(%rsp), %rsi
	movl	$1, %ecx
	movl	$1, %edx
	call	_mhz_9
	movq	%rax, %rbx
.L385:
	movl	$0, %esi
	movl	$0, %edi
	call	stop@PLT
	testq	%rax, %rax
	js	.L386
	pxor	%xmm7, %xmm7
	cvtsi2sdq	%rax, %xmm7
	movsd	%xmm7, (%rsp)
.L387:
	movsd	.LC3(%rip), %xmm0
	movsd	8(%rsp), %xmm2
	mulsd	%xmm2, %xmm0
	movsd	(%rsp), %xmm3
	comisd	%xmm3, %xmm0
	ja	.L388
	mulsd	.LC4(%rip), %xmm2
	comisd	%xmm2, %xmm3
	jbe	.L389
.L388:
	movsd	(%rsp), %xmm6
	comisd	.LC5(%rip), %xmm6
	jbe	.L420
	movq	__iterations.0(%rip), %rax
	testq	%rax, %rax
	js	.L393
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rax, %xmm1
.L394:
	divsd	(%rsp), %xmm1
	movsd	8(%rsp), %xmm0
	mulsd	.LC6(%rip), %xmm0
	mulsd	%xmm1, %xmm0
	addsd	.LC7(%rip), %xmm0
	comisd	.LC8(%rip), %xmm0
	jnb	.L395
	cvttsd2siq	%xmm0, %rax
	movq	%rax, __iterations.0(%rip)
	jmp	.L389
.L412:
	pxor	%xmm5, %xmm5
	movsd	%xmm5, (%rsp)
.L383:
	movq	__iterations.0(%rip), %rdi
	call	save_n@PLT
	movsd	(%rsp), %xmm7
	comisd	.LC8(%rip), %xmm7
	jnb	.L398
	cvttsd2siq	%xmm7, %rdi
.L399:
	call	settime@PLT
	call	usecs_spent@PLT
	testq	%rax, %rax
	js	.L400
	pxor	%xmm4, %xmm4
	cvtsi2sdq	%rax, %xmm4
	movq	%xmm4, %r14
.L401:
	call	t_overhead@PLT
	movq	%rax, %rbp
	call	get_n@PLT
	movq	%rax, %r12
	call	l_overhead@PLT
	movapd	%xmm0, %xmm1
	testq	%r12, %r12
	js	.L402
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%r12, %xmm0
.L403:
	mulsd	%xmm1, %xmm0
	testq	%rbp, %rbp
	js	.L404
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rbp, %xmm1
.L405:
	addsd	%xmm1, %xmm0
	movq	%r14, %xmm1
	subsd	%xmm0, %xmm1
	movl	$0, %edi
	comisd	.LC1(%rip), %xmm1
	jb	.L406
	comisd	.LC8(%rip), %xmm1
	jnb	.L408
	cvttsd2siq	%xmm1, %rdi
.L406:
	call	settime@PLT
	movq	%rbx, %rdi
	call	use_pointer@PLT
	call	get_n@PLT
	leaq	(%rax,%rax,4), %rax
	leaq	(%rax,%rax,4), %rdi
	salq	$2, %rdi
	call	save_n@PLT
	movq	24(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L423
	addq	$40, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 40
	popq	%rbx
	.cfi_def_cfa_offset 32
	popq	%rbp
	.cfi_def_cfa_offset 24
	popq	%r12
	.cfi_def_cfa_offset 16
	popq	%r14
	.cfi_def_cfa_offset 8
	ret
.L398:
	.cfi_restore_state
	movsd	(%rsp), %xmm0
	subsd	.LC8(%rip), %xmm0
	cvttsd2siq	%xmm0, %rdi
	btcq	$63, %rdi
	jmp	.L399
.L400:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rdx, %xmm1
	addsd	%xmm1, %xmm1
	movq	%xmm1, %r14
	jmp	.L401
.L402:
	movq	%r12, %rax
	shrq	%rax
	andl	$1, %r12d
	orq	%r12, %rax
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	addsd	%xmm0, %xmm0
	jmp	.L403
.L404:
	movq	%rbp, %rax
	shrq	%rax
	andl	$1, %ebp
	orq	%rbp, %rax
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rax, %xmm1
	addsd	%xmm1, %xmm1
	jmp	.L405
.L408:
	subsd	.LC8(%rip), %xmm1
	cvttsd2siq	%xmm1, %rdi
	btcq	$63, %rdi
	jmp	.L406
.L423:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE98:
	.size	mhz_9, .-mhz_9
	.globl	filter_data
	.type	filter_data, @function
filter_data:
.LFB99:
	.cfi_startproc
	endbr64
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
	subq	$24, %rsp
	.cfi_def_cfa_offset 64
	movq	%rdi, %rbx
	movl	%esi, %r13d
	leal	1(%rsi), %edi
	movslq	%edi, %rdi
	salq	$3, %rdi
	call	malloc@PLT
	movq	%rax, %r12
	testl	%r13d, %r13d
	jle	.L425
	movl	%r13d, %ebp
	movl	$0, %eax
.L426:
	movsd	(%rbx,%rax,8), %xmm0
	movsd	%xmm0, (%r12,%rax,8)
	addq	$1, %rax
	cmpq	%rax, %rbp
	jne	.L426
	movslq	%r13d, %rsi
	movq	double_compare@GOTPCREL(%rip), %rcx
	movl	$8, %edx
	movq	%r12, %rdi
	call	qsort@PLT
	movl	%r13d, %eax
	shrl	$31, %eax
	addl	%r13d, %eax
	sarl	%eax
	cltq
	leaq	0(,%rax,8), %rdx
	movsd	(%r12,%rax,8), %xmm4
	movsd	%xmm4, 8(%rsp)
	testb	$1, %r13b
	jne	.L428
	movsd	8(%rsp), %xmm0
	addsd	-8(%r12,%rdx), %xmm0
	mulsd	.LC17(%rip), %xmm0
	movsd	%xmm0, 8(%rsp)
.L428:
	movq	%r12, %rdi
	call	free@PLT
	movsd	8(%rsp), %xmm1
	mulsd	.LC19(%rip), %xmm1
	movl	$0, %eax
	movl	$0, %edx
	movsd	.LC18(%rip), %xmm3
	jmp	.L433
.L432:
	addl	$1, %edx
.L429:
	addq	$1, %rax
	cmpq	%rax, %rbp
	je	.L424
.L433:
	movsd	(%rbx,%rax,8), %xmm0
	comisd	%xmm1, %xmm0
	jbe	.L429
	movsd	8(%rsp), %xmm2
	mulsd	%xmm3, %xmm2
	comisd	%xmm0, %xmm2
	jbe	.L429
	cmpl	%eax, %edx
	jge	.L432
	movslq	%edx, %rcx
	movsd	%xmm0, (%rbx,%rcx,8)
	jmp	.L432
.L425:
	movslq	%r13d, %rsi
	movq	double_compare@GOTPCREL(%rip), %rcx
	movl	$8, %edx
	movq	%rax, %rdi
	call	qsort@PLT
	movq	%r12, %rdi
	call	free@PLT
	movl	$0, %edx
.L424:
	movl	%edx, %eax
	addq	$24, %rsp
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
	.cfi_endproc
.LFE99:
	.size	filter_data, .-filter_data
	.globl	classes
	.type	classes, @function
classes:
.LFB100:
	.cfi_startproc
	endbr64
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
	movq	%rdi, %r12
	movl	%esi, %ebx
	movslq	%esi, %r13
	leaq	0(,%r13,8), %rdi
	call	malloc@PLT
	movq	%rax, %rbp
	testl	%ebx, %ebx
	jle	.L443
	movl	%ebx, %edx
	movl	$0, %eax
.L444:
	movsd	(%r12,%rax,8), %xmm0
	movsd	%xmm0, 0(%rbp,%rax,8)
	addq	$1, %rax
	cmpq	%rdx, %rax
	jne	.L444
.L443:
	movq	double_compare@GOTPCREL(%rip), %rcx
	movl	$8, %edx
	movq	%r13, %rsi
	movq	%rbp, %rdi
	call	qsort@PLT
	movl	%ebx, %eax
	shrl	$31, %eax
	addl	%ebx, %eax
	sarl	%eax
	cltq
	leaq	0(,%rax,8), %rdx
	movsd	0(%rbp,%rax,8), %xmm1
	testb	$1, %bl
	jne	.L445
	addsd	-8(%rbp,%rdx), %xmm1
	mulsd	.LC17(%rip), %xmm1
.L445:
	cmpl	$1, %ebx
	jle	.L450
	mulsd	.LC19(%rip), %xmm1
	movq	%rbp, %rax
	leal	-1(%rbx), %edx
	leaq	0(%rbp,%rdx,8), %rcx
	movl	$1, %ebx
.L449:
	movsd	8(%rax), %xmm0
	subsd	(%rax), %xmm0
	comisd	%xmm1, %xmm0
	seta	%dl
	movzbl	%dl, %edx
	addl	%edx, %ebx
	addq	$8, %rax
	cmpq	%rcx, %rax
	jne	.L449
.L446:
	movq	%rbp, %rdi
	call	free@PLT
	movl	%ebx, %eax
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
.L450:
	.cfi_restore_state
	movl	$1, %ebx
	jmp	.L446
	.cfi_endproc
.LFE100:
	.size	classes, .-classes
	.globl	mode
	.type	mode, @function
mode:
.LFB101:
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
	movq	%rdi, %rbx
	movl	%esi, %ebp
	movslq	%esi, %rsi
	movq	double_compare@GOTPCREL(%rip), %rcx
	movl	$8, %edx
	call	qsort@PLT
	movsd	.LC17(%rip), %xmm0
	addsd	(%rbx), %xmm0
	cvttsd2sil	%xmm0, %r10d
	cmpl	$1, %ebp
	jle	.L455
	leaq	8(%rbx), %rdx
	leal	-2(%rbp), %eax
	leaq	16(%rbx,%rax,8), %r9
	movl	%r10d, %ecx
	movl	$1, %eax
	movl	$1, %edi
	movsd	.LC17(%rip), %xmm1
	movl	$0, %r8d
	jmp	.L459
.L458:
	addq	$8, %rdx
	cmpq	%r9, %rdx
	je	.L455
.L459:
	movl	%ecx, %esi
	movapd	%xmm1, %xmm0
	addsd	(%rdx), %xmm0
	cvttsd2sil	%xmm0, %ecx
	cmpl	%esi, %ecx
	cmovne	%r8d, %eax
	addl	$1, %eax
	cmpl	%edi, %eax
	jle	.L458
	movl	%ecx, %r10d
	movl	%eax, %edi
	jmp	.L458
.L455:
	movl	%r10d, %eax
	addq	$8, %rsp
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE101:
	.size	mode, .-mode
	.globl	cross_values
	.type	cross_values, @function
cross_values:
.LFB102:
	.cfi_startproc
	endbr64
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
	movq	%rdi, %r13
	movl	%esi, %r12d
	movq	%rdx, %rbp
	movq	%rcx, %rbx
	movl	%esi, %edi
	imull	%esi, %edi
	movslq	%edi, %rdi
	salq	$3, %rdi
	call	malloc@PLT
	movq	%rax, 0(%rbp)
	movl	$0, (%rbx)
	testl	%r12d, %r12d
	jle	.L462
	movq	%r13, %r8
	movl	%r12d, %r10d
	movl	$1, %r9d
	pxor	%xmm1, %xmm1
	movq	.LC20(%rip), %xmm2
	jmp	.L467
.L464:
	movq	0(%rbp), %rcx
	movl	(%rbx), %eax
	leal	1(%rax), %esi
	movl	%esi, (%rbx)
	cltq
	movsd	%xmm0, (%rcx,%rax,8)
	addq	$1, %rdx
	cmpl	%edx, %r12d
	jle	.L471
.L466:
	movsd	(%rdi), %xmm0
	subsd	0(%r13,%rdx,8), %xmm0
	comisd	%xmm0, %xmm1
	jbe	.L464
	xorpd	%xmm2, %xmm0
	jmp	.L464
.L471:
	addq	$1, %r9
	addq	$8, %r8
.L467:
	movq	0(%rbp), %rdx
	movl	(%rbx), %eax
	leal	1(%rax), %ecx
	movl	%ecx, (%rbx)
	movq	%r8, %rdi
	movsd	(%r8), %xmm0
	cltq
	movsd	%xmm0, (%rdx,%rax,8)
	cmpq	%r10, %r9
	je	.L462
	movq	%r9, %rdx
	jmp	.L466
.L462:
	addq	$8, %rsp
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
	.cfi_endproc
.LFE102:
	.size	cross_values, .-cross_values
	.globl	gcd
	.type	gcd, @function
gcd:
.LFB103:
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
	movq	%rdi, %r12
	movl	%esi, %ebp
	movq	%fs:40, %rax
	movq	%rax, 72(%rsp)
	xorl	%eax, %eax
	movl	%esi, %edi
	imull	%esi, %edi
	movslq	%edi, %rdi
	salq	$3, %rdi
	call	malloc@PLT
	movq	%rax, %rbx
	movl	%ebp, %esi
	movq	%r12, %rdi
	call	double_min@PLT
	movsd	%xmm0, (%rsp)
	leaq	20(%rsp), %rcx
	leaq	64(%rsp), %rdx
	movl	%ebp, %esi
	movq	%r12, %rdi
	call	cross_values
	movq	64(%rsp), %rbp
	movl	20(%rsp), %eax
	leal	1(%rax), %r14d
	movl	%r14d, 20(%rsp)
	movslq	%eax, %rdx
	movq	$0x000000000, 0(%rbp,%rdx,8)
	movl	%eax, %eax
	leaq	8(,%rax,8), %r12
	movsd	(%rsp), %xmm5
	movsd	%xmm5, 8(%rsp)
	movq	.LC1(%rip), %r15
	movl	$1, %r13d
	jmp	.L473
.L475:
	movsd	32(%rsp), %xmm4
	movsd	%xmm4, 8(%rsp)
	movq	56(%rsp), %r15
.L476:
	addl	$1, %r13d
	cmpl	$6, %r13d
	je	.L478
.L473:
	movl	$0, %eax
	testl	%r14d, %r14d
	jle	.L479
	pxor	%xmm1, %xmm1
	cvtsi2sdl	%r13d, %xmm1
.L474:
	movapd	%xmm1, %xmm0
	mulsd	0(%rbp,%rax), %xmm0
	divsd	(%rsp), %xmm0
	addsd	.LC17(%rip), %xmm0
	cvttsd2sil	%xmm0, %edx
	pxor	%xmm0, %xmm0
	cvtsi2sdl	%edx, %xmm0
	movsd	%xmm0, (%rbx,%rax)
	addq	$8, %rax
	cmpq	%rax, %r12
	jne	.L474
.L479:
	subq	$8, %rsp
	.cfi_def_cfa_offset 152
	leaq	64(%rsp), %rax
	pushq	%rax
	.cfi_def_cfa_offset 160
	leaq	64(%rsp), %rax
	pushq	%rax
	.cfi_def_cfa_offset 168
	leaq	64(%rsp), %rax
	pushq	%rax
	.cfi_def_cfa_offset 176
	leaq	64(%rsp), %r9
	leaq	56(%rsp), %r8
	movl	%r14d, %ecx
	movl	$0, %edx
	movq	%rbp, %rsi
	movq	%rbx, %rdi
	call	regression@PLT
	addq	$32, %rsp
	.cfi_def_cfa_offset 144
	cmpl	$1, %r13d
	je	.L475
	movl	%r13d, %eax
	imull	%r13d, %eax
	pxor	%xmm0, %xmm0
	cvtsi2sdl	%eax, %xmm0
	mulsd	56(%rsp), %xmm0
	movq	%r15, %xmm3
	comisd	%xmm0, %xmm3
	jbe	.L476
	jmp	.L475
.L478:
	movq	%rbx, %rdi
	call	free@PLT
	movq	%rbp, %rdi
	call	free@PLT
	movq	72(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L485
	movsd	8(%rsp), %xmm0
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
.L485:
	.cfi_restore_state
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE103:
	.size	gcd, .-gcd
	.globl	compute_mhz
	.type	compute_mhz, @function
compute_mhz:
.LFB104:
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
	subq	$4096, %rsp
	.cfi_def_cfa_offset 4152
	orq	$0, (%rsp)
	subq	$136, %rsp
	.cfi_def_cfa_offset 4288
	movq	%rdi, %r13
	movq	%fs:40, %rax
	movq	%rax, 4216(%rsp)
	xorl	%eax, %eax
	movq	$0, 8(%rsp)
	movl	$0, %r14d
	leaq	32(%rsp), %r12
	jmp	.L487
.L489:
	movq	%r8, %r9
	shrq	%r9
	andl	$1, %r8d
	orq	%r8, %r9
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%r9, %xmm0
	addsd	%xmm0, %xmm0
	jmp	.L490
.L491:
	movq	%rdx, %r8
	shrq	%r8
	andl	$1, %edx
	orq	%rdx, %r8
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%r8, %xmm1
	addsd	%xmm1, %xmm1
.L492:
	divsd	%xmm1, %xmm0
	movsd	%xmm0, 32(%rsp,%rsi,8)
	movl	%edi, %esi
.L488:
	addl	$1, %eax
	addq	$184, %rcx
	cmpl	$9, %eax
	je	.L505
.L493:
	btl	%eax, %ebx
	jnc	.L488
	movl	(%rcx), %edx
	cmpl	$5, %edx
	jle	.L488
	subl	$1, %edx
	subl	4(%rsp), %edx
	movslq	%edx, %rdx
	salq	$4, %rdx
	addq	%rcx, %rdx
	leal	1(%rsi), %edi
	movslq	%esi, %rsi
	movq	8(%rdx), %r8
	testq	%r8, %r8
	js	.L489
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%r8, %xmm0
.L490:
	movq	16(%rdx), %rdx
	testq	%rdx, %rdx
	js	.L491
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rdx, %xmm1
	jmp	.L492
.L505:
	cmpl	$1, %esi
	jle	.L494
	movq	%r12, %rdi
	call	filter_data
	movl	%eax, %ebp
	cmpl	$1, %eax
	jle	.L494
	movl	%eax, %esi
	movq	%r12, %rdi
	call	classes
	cmpl	$1, %eax
	jle	.L494
	movl	%ebp, %esi
	movq	%r12, %rdi
	call	gcd
	movapd	%xmm0, %xmm1
	movslq	%r15d, %rax
	movsd	.LC7(%rip), %xmm0
	divsd	%xmm1, %xmm0
	movsd	%xmm0, 112(%rsp,%rax,8)
	leal	1(%r15), %r15d
.L494:
	addl	$1, %ebx
	cmpl	$512, %ebx
	je	.L495
.L497:
	movq	%r13, %rcx
	movl	%r14d, %esi
	movl	$0, %eax
	jmp	.L493
.L495:
	leaq	112(%rsp), %rdi
	movl	%r15d, %esi
	call	mode
	movq	8(%rsp), %rdi
	movl	%eax, 24(%rsp,%rdi,4)
	addq	$1, %rdi
	movq	%rdi, 8(%rsp)
	cmpq	$2, %rdi
	je	.L496
.L487:
	movl	8(%rsp), %eax
	movl	%eax, 4(%rsp)
	movl	%r14d, %r15d
	movl	$0, %ebx
	jmp	.L497
.L496:
	movl	24(%rsp), %eax
	movl	28(%rsp), %edx
	movl	%eax, %ecx
	subl	%edx, %ecx
	js	.L506
	pxor	%xmm0, %xmm0
	cvtsi2sdl	%ecx, %xmm0
.L499:
	pxor	%xmm1, %xmm1
	cvtsi2sdl	%eax, %xmm1
	divsd	%xmm1, %xmm0
	movsd	.LC21(%rip), %xmm1
	comisd	%xmm0, %xmm1
	jnb	.L486
	addl	$1, %ecx
	cmpl	$3, %ecx
	movl	$-1, %edx
	cmovnb	%edx, %eax
.L486:
	movq	4216(%rsp), %rdx
	subq	%fs:40, %rdx
	jne	.L507
	addq	$4232, %rsp
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
.L506:
	.cfi_restore_state
	subl	%eax, %edx
	pxor	%xmm0, %xmm0
	cvtsi2sdl	%edx, %xmm0
	jmp	.L499
.L507:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE104:
	.size	compute_mhz, .-compute_mhz
	.globl	save_data
	.type	save_data, @function
save_data:
.LFB105:
	.cfi_startproc
	endbr64
	movl	$0, %eax
.L509:
	movdqu	(%rdi,%rax), %xmm0
	movups	%xmm0, (%rsi,%rax)
	movdqu	16(%rdi,%rax), %xmm1
	movups	%xmm1, 16(%rsi,%rax)
	movdqu	32(%rdi,%rax), %xmm2
	movups	%xmm2, 32(%rsi,%rax)
	movdqu	48(%rdi,%rax), %xmm3
	movups	%xmm3, 48(%rsi,%rax)
	movdqu	64(%rdi,%rax), %xmm4
	movups	%xmm4, 64(%rsi,%rax)
	movdqu	80(%rdi,%rax), %xmm5
	movups	%xmm5, 80(%rsi,%rax)
	movdqu	96(%rdi,%rax), %xmm6
	movups	%xmm6, 96(%rsi,%rax)
	movdqu	112(%rdi,%rax), %xmm7
	movups	%xmm7, 112(%rsi,%rax)
	movdqu	128(%rdi,%rax), %xmm0
	movups	%xmm0, 128(%rsi,%rax)
	movdqu	144(%rdi,%rax), %xmm1
	movups	%xmm1, 144(%rsi,%rax)
	movdqu	160(%rdi,%rax), %xmm2
	movups	%xmm2, 160(%rsi,%rax)
	movq	176(%rdi,%rax), %rdx
	movq	%rdx, 176(%rsi,%rax)
	addq	$184, %rax
	cmpq	$1656, %rax
	jne	.L509
	ret
	.cfi_endproc
.LFE105:
	.size	save_data, .-save_data
	.section	.rodata.str1.1
.LC22:
	.string	"email"
.LC23:
	.string	"uname"
.LC24:
	.string	"CPU"
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC25:
	.string	"/* \"%s\", \"%s\", \"%s\", %d, %.0f, %d, %f, %lu */\n"
	.section	.rodata.str1.1
.LC26:
	.string	"result_t* data[] = { "
.LC27:
	.string	"\t/* %s */ { %d, {"
.LC29:
	.string	"\n\t\t{ /* %f */ %lu, %lu}"
.LC30:
	.string	", "
.LC31:
	.string	"}},"
.LC32:
	.string	"}}"
.LC33:
	.string	"};"
	.text
	.globl	print_data
	.type	print_data, @function
print_data:
.LFB106:
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
	movq	%xmm0, %rbx
	movq	%rdi, %r13
	movq	%fs:40, %rax
	movq	%rax, 72(%rsp)
	xorl	%eax, %eax
	leaq	.LC0(%rip), %rax
	movq	%rax, (%rsp)
	leaq	.LC9(%rip), %rax
	movq	%rax, 8(%rsp)
	leaq	.LC10(%rip), %rax
	movq	%rax, 16(%rsp)
	leaq	.LC11(%rip), %rax
	movq	%rax, 24(%rsp)
	leaq	.LC12(%rip), %rax
	movq	%rax, 32(%rsp)
	leaq	.LC13(%rip), %rax
	movq	%rax, 40(%rsp)
	leaq	.LC14(%rip), %rax
	movq	%rax, 48(%rsp)
	leaq	.LC15(%rip), %rax
	movq	%rax, 56(%rsp)
	leaq	.LC16(%rip), %rax
	movq	%rax, 64(%rsp)
	call	t_overhead@PLT
	movq	%rax, %r12
	call	l_overhead@PLT
	movq	%xmm0, %rbp
	movl	$0, %edi
	call	get_enough@PLT
	pushq	%r12
	.cfi_def_cfa_offset 152
	pushq	%rax
	.cfi_def_cfa_offset 160
	movq	%rbp, %xmm1
	movq	%rbx, %xmm0
	movl	$-1, %r9d
	leaq	.LC22(%rip), %r8
	leaq	.LC23(%rip), %rcx
	leaq	.LC24(%rip), %rdx
	leaq	.LC25(%rip), %rsi
	movl	$1, %edi
	movl	$2, %eax
	call	__printf_chk@PLT
	leaq	.LC26(%rip), %rdi
	call	puts@PLT
	addq	$16, %rsp
	.cfi_def_cfa_offset 144
	movl	$0, %r14d
	leaq	.LC30(%rip), %r15
	jmp	.L521
.L513:
	movq	%rdx, %rax
	shrq	%rax
	movq	%rdx, %rsi
	andl	$1, %esi
	orq	%rsi, %rax
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	addsd	%xmm0, %xmm0
	jmp	.L514
.L515:
	movq	%rcx, %rax
	shrq	%rax
	movq	%rcx, %rsi
	andl	$1, %esi
	orq	%rsi, %rax
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rax, %xmm1
	addsd	%xmm1, %xmm1
.L516:
	mulsd	.LC28(%rip), %xmm1
	divsd	%xmm1, %xmm0
	movq	%r12, %rsi
	movl	$1, %edi
	movl	$1, %eax
	call	__printf_chk@PLT
	cmpl	$9, %ebx
	jle	.L526
.L517:
	addq	$1, %rbx
	cmpl	%ebx, 0(%rbp)
	jle	.L512
.L518:
	movq	%rbx, %rax
	salq	$4, %rax
	movq	16(%rbp,%rax), %rcx
	movq	8(%rbp,%rax), %rdx
	testq	%rdx, %rdx
	js	.L513
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
.L514:
	testq	%rcx, %rcx
	js	.L515
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rcx, %xmm1
	jmp	.L516
.L526:
	movq	%r15, %rsi
	movl	$1, %edi
	movl	$0, %eax
	call	__printf_chk@PLT
	jmp	.L517
.L512:
	cmpl	$7, %r14d
	ja	.L519
	leaq	.LC31(%rip), %rdi
	call	puts@PLT
.L520:
	addq	$1, %r14
	addq	$184, %r13
	cmpq	$9, %r14
	je	.L527
.L521:
	movq	%r13, %rbp
	movq	(%rsp,%r14,8), %rdx
	movl	0(%r13), %ecx
	leaq	.LC27(%rip), %rsi
	movl	$1, %edi
	movl	$0, %eax
	call	__printf_chk@PLT
	cmpl	$0, 0(%r13)
	jle	.L512
	movl	$0, %ebx
	leaq	.LC29(%rip), %r12
	jmp	.L518
.L519:
	leaq	.LC32(%rip), %rdi
	call	puts@PLT
	jmp	.L520
.L527:
	leaq	.LC33(%rip), %rdi
	call	puts@PLT
	movq	72(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L528
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
.L528:
	.cfi_restore_state
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE106:
	.size	print_data, .-print_data
	.section	.rodata.str1.1
.LC34:
	.string	"LOOP_O=0.0"
	.section	.rodata.str1.8
	.align 8
.LC37:
	.string	"mhz: should take approximately %.0f seconds\n"
	.section	.rodata.str1.1
.LC39:
	.string	"%.4f\n"
.LC40:
	.string	"[-d] [-c]\n"
.LC41:
	.string	"cd"
.LC42:
	.string	"-1 System too busy"
.LC43:
	.string	"%d MHz, %.4f nanosec clock\n"
	.text
	.globl	main
	.type	main, @function
main:
.LFB107:
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
	subq	$3352, %rsp
	.cfi_def_cfa_offset 3408
	movl	%edi, 4(%rsp)
	movq	%rsi, 8(%rsp)
	movq	%fs:40, %rax
	movq	%rax, 3336(%rsp)
	xorl	%eax, %eax
	leaq	.LC34(%rip), %rdi
	call	putenv@PLT
	movl	$0, %edi
	call	get_enough@PLT
	cltq
	leaq	(%rax,%rax,8), %rax
	movq	%rax, %rdx
	salq	$5, %rdx
	addq	%rdx, %rax
	js	.L530
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
.L531:
	divsd	.LC35(%rip), %xmm0
	comisd	.LC36(%rip), %xmm0
	ja	.L554
.L532:
	movl	$0, (%rsp)
	leaq	16(%rsp), %r15
	jmp	.L534
.L530:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
	jmp	.L531
.L554:
	leaq	.LC37(%rip), %rdx
	movl	$1, %esi
	movq	stderr(%rip), %rdi
	movl	$1, %eax
	call	__fprintf_chk@PLT
	jmp	.L532
.L555:
	subl	$1, %r14d
	je	.L538
.L536:
	leaq	loops(%rip), %r12
	movq	%r15, %rbx
.L537:
	movl	$0, %edi
	call	*(%r12)
	call	get_n@PLT
	movq	%rax, %rbp
	call	usecs_spent@PLT
	movq	%rax, %rdi
	movq	%rbx, %rdx
	movq	%rbp, %rsi
	call	insertsort@PLT
	addq	$8, %r12
	addq	$184, %rbx
	cmpq	%r13, %rbx
	jne	.L537
	jmp	.L555
.L538:
	leaq	1680(%rsp), %rsi
	movq	%r15, %rdi
	call	save_data
	movq	%r15, %rdi
	call	compute_mhz
	movl	%eax, %ebx
	addl	$1, (%rsp)
	movl	(%rsp), %eax
	cmpl	$2, %eax
	jg	.L539
	testl	%ebx, %ebx
	jns	.L539
.L534:
	leaq	1672(%rsp), %r13
	movq	%r15, %rbx
.L535:
	movq	%rbx, %rdi
	call	insertinit@PLT
	addq	$184, %rbx
	cmpq	%r13, %rbx
	jne	.L535
	movl	$11, %r14d
	jmp	.L536
.L540:
	testl	%ebx, %ebx
	jle	.L551
	pxor	%xmm1, %xmm1
	cvtsi2sdl	%ebx, %xmm1
	movsd	.LC38(%rip), %xmm0
	divsd	%xmm1, %xmm0
	movq	%r13, %rsi
	movl	$1, %edi
	movl	$1, %eax
	call	__printf_chk@PLT
	movl	$0, %ebx
	jmp	.L551
.L541:
	leaq	1680(%rsp), %rdi
	pxor	%xmm0, %xmm0
	cvtsi2sdl	%ebx, %xmm0
	call	print_data
.L551:
	movq	%rbp, %rdx
	movq	8(%rsp), %rsi
	movl	4(%rsp), %edi
	call	mygetopt@PLT
	cmpl	$-1, %eax
	je	.L556
	cmpl	$99, %eax
	je	.L540
	cmpl	$100, %eax
	je	.L541
	movq	%r12, %rdx
	movq	8(%rsp), %rsi
	movl	4(%rsp), %edi
	call	lmbench_usage@PLT
	jmp	.L551
.L539:
	leaq	.LC41(%rip), %rbp
	leaq	.LC39(%rip), %r13
	leaq	.LC40(%rip), %r12
	jmp	.L551
.L556:
	testl	%ebx, %ebx
	js	.L557
	jg	.L558
.L546:
	movl	$0, %edi
	call	exit@PLT
.L557:
	leaq	.LC42(%rip), %rdi
	call	puts@PLT
	movl	$1, %edi
	call	exit@PLT
.L558:
	pxor	%xmm1, %xmm1
	cvtsi2sdl	%ebx, %xmm1
	movsd	.LC38(%rip), %xmm0
	divsd	%xmm1, %xmm0
	movl	%ebx, %edx
	leaq	.LC43(%rip), %rsi
	movl	$1, %edi
	movl	$1, %eax
	call	__printf_chk@PLT
	jmp	.L546
	.cfi_endproc
.LFE107:
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
	.align 8
	.type	__iterations.2, @object
	.size	__iterations.2, 8
__iterations.2:
	.quad	1
	.align 8
	.type	__iterations.3, @object
	.size	__iterations.3, 8
__iterations.3:
	.quad	1
	.align 8
	.type	__iterations.4, @object
	.size	__iterations.4, 8
__iterations.4:
	.quad	1
	.align 8
	.type	__iterations.5, @object
	.size	__iterations.5, 8
__iterations.5:
	.quad	1
	.align 8
	.type	__iterations.6, @object
	.size	__iterations.6, 8
__iterations.6:
	.quad	1
	.align 8
	.type	__iterations.7, @object
	.size	__iterations.7, 8
__iterations.7:
	.quad	1
	.align 8
	.type	__iterations.8, @object
	.size	__iterations.8, 8
__iterations.8:
	.quad	1
	.globl	loops
	.section	.data.rel.local,"aw"
	.align 32
	.type	loops, @object
	.size	loops, 72
loops:
	.quad	mhz_1
	.quad	mhz_2
	.quad	mhz_3
	.quad	mhz_4
	.quad	mhz_5
	.quad	mhz_6
	.quad	mhz_7
	.quad	mhz_8
	.quad	mhz_9
	.globl	id
	.section	.rodata.str1.1
.LC44:
	.string	"$Id$\n"
	.section	.data.rel.local
	.align 8
	.type	id, @object
	.size	id, 8
id:
	.quad	.LC44
	.set	.LC1,.LC20+8
	.section	.rodata.cst8,"aM",@progbits,8
	.align 8
.LC2:
	.long	1717986918
	.long	1072588390
	.align 8
.LC3:
	.long	2061584302
	.long	1072672276
	.align 8
.LC4:
	.long	858993459
	.long	1072902963
	.align 8
.LC5:
	.long	0
	.long	1080213504
	.align 8
.LC6:
	.long	-1717986918
	.long	1072798105
	.align 8
.LC7:
	.long	0
	.long	1072693248
	.align 8
.LC8:
	.long	0
	.long	1138753536
	.align 8
.LC17:
	.long	0
	.long	1071644672
	.align 8
.LC18:
	.long	0
	.long	1077149696
	.align 8
.LC19:
	.long	-1717986918
	.long	1068079513
	.section	.rodata.cst16,"aM",@progbits,16
	.align 16
.LC20:
	.long	0
	.long	-2147483648
	.long	0
	.long	0
	.section	.rodata.cst8
	.align 8
.LC21:
	.long	1202590843
	.long	1065646817
	.align 8
.LC28:
	.long	0
	.long	1079574528
	.align 8
.LC35:
	.long	0
	.long	1093567616
	.align 8
.LC36:
	.long	0
	.long	1074266112
	.align 8
.LC38:
	.long	0
	.long	1083129856
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
