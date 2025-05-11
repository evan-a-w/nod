	.file	"mhz.c"
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
.LC1:
	.string	"p=(TYPE**)*p;"
	.text
	.globl	name_1
	.type	name_1, @function
name_1:
.LFB8:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	leaq	.LC1(%rip), %rax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE8:
	.size	name_1, .-name_1
	.globl	_mhz_1
	.type	_mhz_1, @function
_mhz_1:
.LFB9:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rsi, %rax
	movq	%rdx, %rsi
	movq	%rcx, %rdx
	jmp	.L4
.L5:
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
	subq	$1, %rdi
.L4:
	testq	%rdi, %rdi
	jg	.L5
	movq	%rsi, %rcx
	addq	%rcx, %rdx
	salq	$3, %rdx
	addq	%rdx, %rax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE9:
	.size	_mhz_1, .-_mhz_1
	.globl	mhz_1
	.type	mhz_1, @function
mhz_1:
.LFB10:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$112, %rsp
	movl	%edi, -84(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movq	$1, -40(%rbp)
	leaq	-72(%rbp), %rax
	movq	%rax, -72(%rbp)
	movq	-72(%rbp), %rax
	movq	%rax, -32(%rbp)
	movq	$0, -64(%rbp)
	movq	-32(%rbp), %rax
	movl	$1, %ecx
	movl	$1, %edx
	movq	%rax, %rsi
	movl	$1, %edi
	call	_mhz_1
	movl	-84(%rbp), %eax
	movl	%eax, %edi
	call	get_enough@PLT
	movl	%eax, -76(%rbp)
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -48(%rbp)
	jmp	.L8
.L23:
	movl	$0, %edi
	call	start@PLT
	movq	__iterations.8(%rip), %rax
	movq	%rax, -56(%rbp)
	jmp	.L9
.L10:
	movq	-56(%rbp), %rax
	movq	-40(%rbp), %rcx
	movq	-40(%rbp), %rdx
	movq	-32(%rbp), %rsi
	movq	%rax, %rdi
	call	_mhz_1
	movq	%rax, -64(%rbp)
	movq	$1, -56(%rbp)
	subq	$1, -56(%rbp)
.L9:
	cmpq	$0, -56(%rbp)
	jne	.L10
	movl	$0, %esi
	movl	$0, %edi
	call	stop@PLT
	testq	%rax, %rax
	js	.L11
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L12
.L11:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L12:
	movsd	%xmm0, -48(%rbp)
	pxor	%xmm1, %xmm1
	cvtsi2sdl	-76(%rbp), %xmm1
	movsd	.LC3(%rip), %xmm0
	mulsd	%xmm1, %xmm0
	comisd	-48(%rbp), %xmm0
	ja	.L13
	pxor	%xmm1, %xmm1
	cvtsi2sdl	-76(%rbp), %xmm1
	movsd	.LC4(%rip), %xmm0
	mulsd	%xmm0, %xmm1
	movsd	-48(%rbp), %xmm0
	comisd	%xmm1, %xmm0
	ja	.L13
	jmp	.L8
.L13:
	movsd	-48(%rbp), %xmm0
	comisd	.LC5(%rip), %xmm0
	jbe	.L40
	movq	__iterations.8(%rip), %rax
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
	divsd	-48(%rbp), %xmm0
	movsd	%xmm0, -24(%rbp)
	pxor	%xmm1, %xmm1
	cvtsi2sdl	-76(%rbp), %xmm1
	movsd	.LC6(%rip), %xmm0
	mulsd	%xmm1, %xmm0
	movsd	-24(%rbp), %xmm1
	mulsd	%xmm1, %xmm0
	movsd	%xmm0, -24(%rbp)
	movsd	-24(%rbp), %xmm1
	movsd	.LC7(%rip), %xmm0
	addsd	%xmm1, %xmm0
	comisd	.LC8(%rip), %xmm0
	jnb	.L19
	cvttsd2siq	%xmm0, %rax
	jmp	.L20
.L19:
	movsd	.LC8(%rip), %xmm1
	subsd	%xmm1, %xmm0
	cvttsd2siq	%xmm0, %rax
	movabsq	$-9223372036854775808, %rdx
	xorq	%rdx, %rax
.L20:
	movq	%rax, __iterations.8(%rip)
	jmp	.L8
.L40:
	movq	__iterations.8(%rip), %rax
	cmpq	$134217728, %rax
	jbe	.L21
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -48(%rbp)
	jmp	.L22
.L21:
	movq	__iterations.8(%rip), %rax
	salq	$3, %rax
	movq	%rax, __iterations.8(%rip)
.L8:
	pxor	%xmm1, %xmm1
	cvtsi2sdl	-76(%rbp), %xmm1
	movsd	.LC9(%rip), %xmm0
	mulsd	%xmm1, %xmm0
	comisd	-48(%rbp), %xmm0
	ja	.L23
.L22:
	movq	__iterations.8(%rip), %rax
	movq	%rax, %rdi
	call	save_n@PLT
	movsd	-48(%rbp), %xmm0
	comisd	.LC8(%rip), %xmm0
	jnb	.L24
	movsd	-48(%rbp), %xmm0
	cvttsd2siq	%xmm0, %rax
	jmp	.L25
.L24:
	movsd	-48(%rbp), %xmm0
	movsd	.LC8(%rip), %xmm1
	subsd	%xmm1, %xmm0
	cvttsd2siq	%xmm0, %rax
	movabsq	$-9223372036854775808, %rdx
	xorq	%rdx, %rax
.L25:
	movq	%rax, %rdi
	call	settime@PLT
	call	usecs_spent@PLT
	testq	%rax, %rax
	js	.L26
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L27
.L26:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L27:
	movsd	%xmm0, -16(%rbp)
	call	t_overhead@PLT
	testq	%rax, %rax
	js	.L28
	pxor	%xmm2, %xmm2
	cvtsi2sdq	%rax, %xmm2
	movsd	%xmm2, -96(%rbp)
	jmp	.L29
.L28:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
	movsd	%xmm0, -96(%rbp)
.L29:
	call	get_n@PLT
	testq	%rax, %rax
	js	.L30
	pxor	%xmm3, %xmm3
	cvtsi2sdq	%rax, %xmm3
	movsd	%xmm3, -104(%rbp)
	jmp	.L31
.L30:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
	movsd	%xmm0, -104(%rbp)
.L31:
	call	l_overhead@PLT
	mulsd	-104(%rbp), %xmm0
	movsd	-96(%rbp), %xmm1
	addsd	%xmm0, %xmm1
	movsd	-16(%rbp), %xmm0
	subsd	%xmm1, %xmm0
	movsd	%xmm0, -16(%rbp)
	movsd	-16(%rbp), %xmm0
	pxor	%xmm1, %xmm1
	comisd	%xmm1, %xmm0
	jb	.L41
	movsd	-16(%rbp), %xmm0
	comisd	.LC8(%rip), %xmm0
	jnb	.L34
	movsd	-16(%rbp), %xmm0
	cvttsd2siq	%xmm0, %rax
	jmp	.L36
.L34:
	movsd	-16(%rbp), %xmm0
	movsd	.LC8(%rip), %xmm1
	subsd	%xmm1, %xmm0
	cvttsd2siq	%xmm0, %rax
	movabsq	$-9223372036854775808, %rdx
	xorq	%rdx, %rax
	jmp	.L36
.L41:
	movl	$0, %eax
.L36:
	movq	%rax, %rdi
	call	settime@PLT
	movq	-64(%rbp), %rax
	movq	%rax, %rdi
	call	use_pointer@PLT
	call	get_n@PLT
	movq	%rax, %rdx
	movq	%rdx, %rax
	salq	$2, %rax
	addq	%rdx, %rax
	leaq	0(,%rax,4), %rdx
	addq	%rdx, %rax
	salq	$2, %rax
	movq	%rax, %rdi
	call	save_n@PLT
	movq	-8(%rbp), %rax
	subq	%fs:40, %rax
	je	.L37
	call	__stack_chk_fail@PLT
.L37:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE10:
	.size	mhz_1, .-mhz_1
	.section	.rodata
.LC10:
	.string	"a^=a+a;"
	.text
	.globl	name_2
	.type	name_2, @function
name_2:
.LFB11:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	leaq	.LC10(%rip), %rax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE11:
	.size	name_2, .-name_2
	.globl	_mhz_2
	.type	_mhz_2, @function
_mhz_2:
.LFB12:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdx, %rax
	movq	%rcx, %rdx
	jmp	.L45
.L46:
	leaq	(%rax,%rax), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rax), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rax), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rax), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rax), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rax), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rax), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rax), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rax), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rax), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rax), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rax), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rax), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rax), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rax), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rax), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rax), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rax), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rax), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rax), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rax), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rax), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rax), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rax), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rax), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rax), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rax), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rax), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rax), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rax), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rax), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rax), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rax), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rax), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rax), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rax), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rax), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rax), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rax), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rax), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rax), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rax), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rax), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rax), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rax), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rax), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rax), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rax), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rax), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rax), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rax), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rax), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rax), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rax), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rax), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rax), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rax), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rax), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rax), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rax), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rax), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rax), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rax), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rax), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rax), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rax), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rax), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rax), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rax), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rax), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rax), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rax), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rax), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rax), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rax), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rax), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rax), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rax), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rax), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rax), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rax), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rax), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rax), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rax), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rax), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rax), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rax), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rax), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rax), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rax), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rax), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rax), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rax), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rax), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rax), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rax), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rax), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rax), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rax), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rax), %rcx
	xorq	%rcx, %rax
	subq	$1, %rdi
.L45:
	testq	%rdi, %rdi
	jg	.L46
	movq	%rax, %rcx
	movq	%rdx, %rax
	addq	%rcx, %rax
	salq	$3, %rax
	addq	%rsi, %rax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE12:
	.size	_mhz_2, .-_mhz_2
	.globl	mhz_2
	.type	mhz_2, @function
mhz_2:
.LFB13:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$112, %rsp
	movl	%edi, -84(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movq	$1, -40(%rbp)
	leaq	-72(%rbp), %rax
	movq	%rax, -72(%rbp)
	movq	-72(%rbp), %rax
	movq	%rax, -32(%rbp)
	movq	$0, -64(%rbp)
	movq	-32(%rbp), %rax
	movl	$1, %ecx
	movl	$1, %edx
	movq	%rax, %rsi
	movl	$1, %edi
	call	_mhz_2
	movl	-84(%rbp), %eax
	movl	%eax, %edi
	call	get_enough@PLT
	movl	%eax, -76(%rbp)
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -48(%rbp)
	jmp	.L49
.L64:
	movl	$0, %edi
	call	start@PLT
	movq	__iterations.7(%rip), %rax
	movq	%rax, -56(%rbp)
	jmp	.L50
.L51:
	movq	-56(%rbp), %rax
	movq	-40(%rbp), %rcx
	movq	-40(%rbp), %rdx
	movq	-32(%rbp), %rsi
	movq	%rax, %rdi
	call	_mhz_2
	movq	%rax, -64(%rbp)
	movq	$1, -56(%rbp)
	subq	$1, -56(%rbp)
.L50:
	cmpq	$0, -56(%rbp)
	jne	.L51
	movl	$0, %esi
	movl	$0, %edi
	call	stop@PLT
	testq	%rax, %rax
	js	.L52
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L53
.L52:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L53:
	movsd	%xmm0, -48(%rbp)
	pxor	%xmm1, %xmm1
	cvtsi2sdl	-76(%rbp), %xmm1
	movsd	.LC3(%rip), %xmm0
	mulsd	%xmm1, %xmm0
	comisd	-48(%rbp), %xmm0
	ja	.L54
	pxor	%xmm1, %xmm1
	cvtsi2sdl	-76(%rbp), %xmm1
	movsd	.LC4(%rip), %xmm0
	mulsd	%xmm0, %xmm1
	movsd	-48(%rbp), %xmm0
	comisd	%xmm1, %xmm0
	ja	.L54
	jmp	.L49
.L54:
	movsd	-48(%rbp), %xmm0
	comisd	.LC5(%rip), %xmm0
	jbe	.L81
	movq	__iterations.7(%rip), %rax
	testq	%rax, %rax
	js	.L58
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L59
.L58:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L59:
	divsd	-48(%rbp), %xmm0
	movsd	%xmm0, -24(%rbp)
	pxor	%xmm1, %xmm1
	cvtsi2sdl	-76(%rbp), %xmm1
	movsd	.LC6(%rip), %xmm0
	mulsd	%xmm1, %xmm0
	movsd	-24(%rbp), %xmm1
	mulsd	%xmm1, %xmm0
	movsd	%xmm0, -24(%rbp)
	movsd	-24(%rbp), %xmm1
	movsd	.LC7(%rip), %xmm0
	addsd	%xmm1, %xmm0
	comisd	.LC8(%rip), %xmm0
	jnb	.L60
	cvttsd2siq	%xmm0, %rax
	jmp	.L61
.L60:
	movsd	.LC8(%rip), %xmm1
	subsd	%xmm1, %xmm0
	cvttsd2siq	%xmm0, %rax
	movabsq	$-9223372036854775808, %rdx
	xorq	%rdx, %rax
.L61:
	movq	%rax, __iterations.7(%rip)
	jmp	.L49
.L81:
	movq	__iterations.7(%rip), %rax
	cmpq	$134217728, %rax
	jbe	.L62
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -48(%rbp)
	jmp	.L63
.L62:
	movq	__iterations.7(%rip), %rax
	salq	$3, %rax
	movq	%rax, __iterations.7(%rip)
.L49:
	pxor	%xmm1, %xmm1
	cvtsi2sdl	-76(%rbp), %xmm1
	movsd	.LC9(%rip), %xmm0
	mulsd	%xmm1, %xmm0
	comisd	-48(%rbp), %xmm0
	ja	.L64
.L63:
	movq	__iterations.7(%rip), %rax
	movq	%rax, %rdi
	call	save_n@PLT
	movsd	-48(%rbp), %xmm0
	comisd	.LC8(%rip), %xmm0
	jnb	.L65
	movsd	-48(%rbp), %xmm0
	cvttsd2siq	%xmm0, %rax
	jmp	.L66
.L65:
	movsd	-48(%rbp), %xmm0
	movsd	.LC8(%rip), %xmm1
	subsd	%xmm1, %xmm0
	cvttsd2siq	%xmm0, %rax
	movabsq	$-9223372036854775808, %rdx
	xorq	%rdx, %rax
.L66:
	movq	%rax, %rdi
	call	settime@PLT
	call	usecs_spent@PLT
	testq	%rax, %rax
	js	.L67
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L68
.L67:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L68:
	movsd	%xmm0, -16(%rbp)
	call	t_overhead@PLT
	testq	%rax, %rax
	js	.L69
	pxor	%xmm2, %xmm2
	cvtsi2sdq	%rax, %xmm2
	movsd	%xmm2, -96(%rbp)
	jmp	.L70
.L69:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
	movsd	%xmm0, -96(%rbp)
.L70:
	call	get_n@PLT
	testq	%rax, %rax
	js	.L71
	pxor	%xmm3, %xmm3
	cvtsi2sdq	%rax, %xmm3
	movsd	%xmm3, -104(%rbp)
	jmp	.L72
.L71:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
	movsd	%xmm0, -104(%rbp)
.L72:
	call	l_overhead@PLT
	mulsd	-104(%rbp), %xmm0
	movsd	-96(%rbp), %xmm1
	addsd	%xmm0, %xmm1
	movsd	-16(%rbp), %xmm0
	subsd	%xmm1, %xmm0
	movsd	%xmm0, -16(%rbp)
	movsd	-16(%rbp), %xmm0
	pxor	%xmm1, %xmm1
	comisd	%xmm1, %xmm0
	jb	.L82
	movsd	-16(%rbp), %xmm0
	comisd	.LC8(%rip), %xmm0
	jnb	.L75
	movsd	-16(%rbp), %xmm0
	cvttsd2siq	%xmm0, %rax
	jmp	.L77
.L75:
	movsd	-16(%rbp), %xmm0
	movsd	.LC8(%rip), %xmm1
	subsd	%xmm1, %xmm0
	cvttsd2siq	%xmm0, %rax
	movabsq	$-9223372036854775808, %rdx
	xorq	%rdx, %rax
	jmp	.L77
.L82:
	movl	$0, %eax
.L77:
	movq	%rax, %rdi
	call	settime@PLT
	movq	-64(%rbp), %rax
	movq	%rax, %rdi
	call	use_pointer@PLT
	call	get_n@PLT
	movq	%rax, %rdx
	movq	%rdx, %rax
	salq	$2, %rax
	addq	%rdx, %rax
	leaq	0(,%rax,4), %rdx
	addq	%rdx, %rax
	salq	$2, %rax
	movq	%rax, %rdi
	call	save_n@PLT
	movq	-8(%rbp), %rax
	subq	%fs:40, %rax
	je	.L78
	call	__stack_chk_fail@PLT
.L78:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE13:
	.size	mhz_2, .-mhz_2
	.section	.rodata
.LC11:
	.string	"a^=a+a+a;"
	.text
	.globl	name_3
	.type	name_3, @function
name_3:
.LFB14:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	leaq	.LC11(%rip), %rax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE14:
	.size	name_3, .-name_3
	.globl	_mhz_3
	.type	_mhz_3, @function
_mhz_3:
.LFB15:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdx, %rax
	jmp	.L86
.L87:
	movq	%rax, %rdx
	addq	%rdx, %rdx
	addq	%rax, %rdx
	xorq	%rdx, %rax
	movq	%rax, %rdx
	addq	%rdx, %rdx
	addq	%rax, %rdx
	xorq	%rdx, %rax
	movq	%rax, %rdx
	addq	%rdx, %rdx
	addq	%rax, %rdx
	xorq	%rdx, %rax
	movq	%rax, %rdx
	addq	%rdx, %rdx
	addq	%rax, %rdx
	xorq	%rdx, %rax
	movq	%rax, %rdx
	addq	%rdx, %rdx
	addq	%rax, %rdx
	xorq	%rdx, %rax
	movq	%rax, %rdx
	addq	%rdx, %rdx
	addq	%rax, %rdx
	xorq	%rdx, %rax
	movq	%rax, %rdx
	addq	%rdx, %rdx
	addq	%rax, %rdx
	xorq	%rdx, %rax
	movq	%rax, %rdx
	addq	%rdx, %rdx
	addq	%rax, %rdx
	xorq	%rdx, %rax
	movq	%rax, %rdx
	addq	%rdx, %rdx
	addq	%rax, %rdx
	xorq	%rdx, %rax
	movq	%rax, %rdx
	addq	%rdx, %rdx
	addq	%rax, %rdx
	xorq	%rdx, %rax
	movq	%rax, %rdx
	addq	%rdx, %rdx
	addq	%rax, %rdx
	xorq	%rdx, %rax
	movq	%rax, %rdx
	addq	%rdx, %rdx
	addq	%rax, %rdx
	xorq	%rdx, %rax
	movq	%rax, %rdx
	addq	%rdx, %rdx
	addq	%rax, %rdx
	xorq	%rdx, %rax
	movq	%rax, %rdx
	addq	%rdx, %rdx
	addq	%rax, %rdx
	xorq	%rdx, %rax
	movq	%rax, %rdx
	addq	%rdx, %rdx
	addq	%rax, %rdx
	xorq	%rdx, %rax
	movq	%rax, %rdx
	addq	%rdx, %rdx
	addq	%rax, %rdx
	xorq	%rdx, %rax
	movq	%rax, %rdx
	addq	%rdx, %rdx
	addq	%rax, %rdx
	xorq	%rdx, %rax
	movq	%rax, %rdx
	addq	%rdx, %rdx
	addq	%rax, %rdx
	xorq	%rdx, %rax
	movq	%rax, %rdx
	addq	%rdx, %rdx
	addq	%rax, %rdx
	xorq	%rdx, %rax
	movq	%rax, %rdx
	addq	%rdx, %rdx
	addq	%rax, %rdx
	xorq	%rdx, %rax
	movq	%rax, %rdx
	addq	%rdx, %rdx
	addq	%rax, %rdx
	xorq	%rdx, %rax
	movq	%rax, %rdx
	addq	%rdx, %rdx
	addq	%rax, %rdx
	xorq	%rdx, %rax
	movq	%rax, %rdx
	addq	%rdx, %rdx
	addq	%rax, %rdx
	xorq	%rdx, %rax
	movq	%rax, %rdx
	addq	%rdx, %rdx
	addq	%rax, %rdx
	xorq	%rdx, %rax
	movq	%rax, %rdx
	addq	%rdx, %rdx
	addq	%rax, %rdx
	xorq	%rdx, %rax
	movq	%rax, %rdx
	addq	%rdx, %rdx
	addq	%rax, %rdx
	xorq	%rdx, %rax
	movq	%rax, %rdx
	addq	%rdx, %rdx
	addq	%rax, %rdx
	xorq	%rdx, %rax
	movq	%rax, %rdx
	addq	%rdx, %rdx
	addq	%rax, %rdx
	xorq	%rdx, %rax
	movq	%rax, %rdx
	addq	%rdx, %rdx
	addq	%rax, %rdx
	xorq	%rdx, %rax
	movq	%rax, %rdx
	addq	%rdx, %rdx
	addq	%rax, %rdx
	xorq	%rdx, %rax
	movq	%rax, %rdx
	addq	%rdx, %rdx
	addq	%rax, %rdx
	xorq	%rdx, %rax
	movq	%rax, %rdx
	addq	%rdx, %rdx
	addq	%rax, %rdx
	xorq	%rdx, %rax
	movq	%rax, %rdx
	addq	%rdx, %rdx
	addq	%rax, %rdx
	xorq	%rdx, %rax
	movq	%rax, %rdx
	addq	%rdx, %rdx
	addq	%rax, %rdx
	xorq	%rdx, %rax
	movq	%rax, %rdx
	addq	%rdx, %rdx
	addq	%rax, %rdx
	xorq	%rdx, %rax
	movq	%rax, %rdx
	addq	%rdx, %rdx
	addq	%rax, %rdx
	xorq	%rdx, %rax
	movq	%rax, %rdx
	addq	%rdx, %rdx
	addq	%rax, %rdx
	xorq	%rdx, %rax
	movq	%rax, %rdx
	addq	%rdx, %rdx
	addq	%rax, %rdx
	xorq	%rdx, %rax
	movq	%rax, %rdx
	addq	%rdx, %rdx
	addq	%rax, %rdx
	xorq	%rdx, %rax
	movq	%rax, %rdx
	addq	%rdx, %rdx
	addq	%rax, %rdx
	xorq	%rdx, %rax
	movq	%rax, %rdx
	addq	%rdx, %rdx
	addq	%rax, %rdx
	xorq	%rdx, %rax
	movq	%rax, %rdx
	addq	%rdx, %rdx
	addq	%rax, %rdx
	xorq	%rdx, %rax
	movq	%rax, %rdx
	addq	%rdx, %rdx
	addq	%rax, %rdx
	xorq	%rdx, %rax
	movq	%rax, %rdx
	addq	%rdx, %rdx
	addq	%rax, %rdx
	xorq	%rdx, %rax
	movq	%rax, %rdx
	addq	%rdx, %rdx
	addq	%rax, %rdx
	xorq	%rdx, %rax
	movq	%rax, %rdx
	addq	%rdx, %rdx
	addq	%rax, %rdx
	xorq	%rdx, %rax
	movq	%rax, %rdx
	addq	%rdx, %rdx
	addq	%rax, %rdx
	xorq	%rdx, %rax
	movq	%rax, %rdx
	addq	%rdx, %rdx
	addq	%rax, %rdx
	xorq	%rdx, %rax
	movq	%rax, %rdx
	addq	%rdx, %rdx
	addq	%rax, %rdx
	xorq	%rdx, %rax
	movq	%rax, %rdx
	addq	%rdx, %rdx
	addq	%rax, %rdx
	xorq	%rdx, %rax
	movq	%rax, %rdx
	addq	%rdx, %rdx
	addq	%rax, %rdx
	xorq	%rdx, %rax
	movq	%rax, %rdx
	addq	%rdx, %rdx
	addq	%rax, %rdx
	xorq	%rdx, %rax
	movq	%rax, %rdx
	addq	%rdx, %rdx
	addq	%rax, %rdx
	xorq	%rdx, %rax
	movq	%rax, %rdx
	addq	%rdx, %rdx
	addq	%rax, %rdx
	xorq	%rdx, %rax
	movq	%rax, %rdx
	addq	%rdx, %rdx
	addq	%rax, %rdx
	xorq	%rdx, %rax
	movq	%rax, %rdx
	addq	%rdx, %rdx
	addq	%rax, %rdx
	xorq	%rdx, %rax
	movq	%rax, %rdx
	addq	%rdx, %rdx
	addq	%rax, %rdx
	xorq	%rdx, %rax
	movq	%rax, %rdx
	addq	%rdx, %rdx
	addq	%rax, %rdx
	xorq	%rdx, %rax
	movq	%rax, %rdx
	addq	%rdx, %rdx
	addq	%rax, %rdx
	xorq	%rdx, %rax
	movq	%rax, %rdx
	addq	%rdx, %rdx
	addq	%rax, %rdx
	xorq	%rdx, %rax
	movq	%rax, %rdx
	addq	%rdx, %rdx
	addq	%rax, %rdx
	xorq	%rdx, %rax
	movq	%rax, %rdx
	addq	%rdx, %rdx
	addq	%rax, %rdx
	xorq	%rdx, %rax
	movq	%rax, %rdx
	addq	%rdx, %rdx
	addq	%rax, %rdx
	xorq	%rdx, %rax
	movq	%rax, %rdx
	addq	%rdx, %rdx
	addq	%rax, %rdx
	xorq	%rdx, %rax
	movq	%rax, %rdx
	addq	%rdx, %rdx
	addq	%rax, %rdx
	xorq	%rdx, %rax
	movq	%rax, %rdx
	addq	%rdx, %rdx
	addq	%rax, %rdx
	xorq	%rdx, %rax
	movq	%rax, %rdx
	addq	%rdx, %rdx
	addq	%rax, %rdx
	xorq	%rdx, %rax
	movq	%rax, %rdx
	addq	%rdx, %rdx
	addq	%rax, %rdx
	xorq	%rdx, %rax
	movq	%rax, %rdx
	addq	%rdx, %rdx
	addq	%rax, %rdx
	xorq	%rdx, %rax
	movq	%rax, %rdx
	addq	%rdx, %rdx
	addq	%rax, %rdx
	xorq	%rdx, %rax
	movq	%rax, %rdx
	addq	%rdx, %rdx
	addq	%rax, %rdx
	xorq	%rdx, %rax
	movq	%rax, %rdx
	addq	%rdx, %rdx
	addq	%rax, %rdx
	xorq	%rdx, %rax
	movq	%rax, %rdx
	addq	%rdx, %rdx
	addq	%rax, %rdx
	xorq	%rdx, %rax
	movq	%rax, %rdx
	addq	%rdx, %rdx
	addq	%rax, %rdx
	xorq	%rdx, %rax
	movq	%rax, %rdx
	addq	%rdx, %rdx
	addq	%rax, %rdx
	xorq	%rdx, %rax
	movq	%rax, %rdx
	addq	%rdx, %rdx
	addq	%rax, %rdx
	xorq	%rdx, %rax
	movq	%rax, %rdx
	addq	%rdx, %rdx
	addq	%rax, %rdx
	xorq	%rdx, %rax
	movq	%rax, %rdx
	addq	%rdx, %rdx
	addq	%rax, %rdx
	xorq	%rdx, %rax
	movq	%rax, %rdx
	addq	%rdx, %rdx
	addq	%rax, %rdx
	xorq	%rdx, %rax
	movq	%rax, %rdx
	addq	%rdx, %rdx
	addq	%rax, %rdx
	xorq	%rdx, %rax
	movq	%rax, %rdx
	addq	%rdx, %rdx
	addq	%rax, %rdx
	xorq	%rdx, %rax
	movq	%rax, %rdx
	addq	%rdx, %rdx
	addq	%rax, %rdx
	xorq	%rdx, %rax
	movq	%rax, %rdx
	addq	%rdx, %rdx
	addq	%rax, %rdx
	xorq	%rdx, %rax
	movq	%rax, %rdx
	addq	%rdx, %rdx
	addq	%rax, %rdx
	xorq	%rdx, %rax
	movq	%rax, %rdx
	addq	%rdx, %rdx
	addq	%rax, %rdx
	xorq	%rdx, %rax
	movq	%rax, %rdx
	addq	%rdx, %rdx
	addq	%rax, %rdx
	xorq	%rdx, %rax
	movq	%rax, %rdx
	addq	%rdx, %rdx
	addq	%rax, %rdx
	xorq	%rdx, %rax
	movq	%rax, %rdx
	addq	%rdx, %rdx
	addq	%rax, %rdx
	xorq	%rdx, %rax
	movq	%rax, %rdx
	addq	%rdx, %rdx
	addq	%rax, %rdx
	xorq	%rdx, %rax
	movq	%rax, %rdx
	addq	%rdx, %rdx
	addq	%rax, %rdx
	xorq	%rdx, %rax
	movq	%rax, %rdx
	addq	%rdx, %rdx
	addq	%rax, %rdx
	xorq	%rdx, %rax
	movq	%rax, %rdx
	addq	%rdx, %rdx
	addq	%rax, %rdx
	xorq	%rdx, %rax
	movq	%rax, %rdx
	addq	%rdx, %rdx
	addq	%rax, %rdx
	xorq	%rdx, %rax
	movq	%rax, %rdx
	addq	%rdx, %rdx
	addq	%rax, %rdx
	xorq	%rdx, %rax
	movq	%rax, %rdx
	addq	%rdx, %rdx
	addq	%rax, %rdx
	xorq	%rdx, %rax
	movq	%rax, %rdx
	addq	%rdx, %rdx
	addq	%rax, %rdx
	xorq	%rdx, %rax
	movq	%rax, %rdx
	addq	%rdx, %rdx
	addq	%rax, %rdx
	xorq	%rdx, %rax
	movq	%rax, %rdx
	addq	%rdx, %rdx
	addq	%rax, %rdx
	xorq	%rdx, %rax
	movq	%rax, %rdx
	addq	%rdx, %rdx
	addq	%rax, %rdx
	xorq	%rdx, %rax
	movq	%rax, %rdx
	addq	%rdx, %rdx
	addq	%rax, %rdx
	xorq	%rdx, %rax
	subq	$1, %rdi
.L86:
	testq	%rdi, %rdi
	jg	.L87
	movq	%rax, %rdx
	movq	%rcx, %rax
	addq	%rdx, %rax
	salq	$3, %rax
	addq	%rsi, %rax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE15:
	.size	_mhz_3, .-_mhz_3
	.globl	mhz_3
	.type	mhz_3, @function
mhz_3:
.LFB16:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$112, %rsp
	movl	%edi, -84(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movq	$1, -40(%rbp)
	leaq	-72(%rbp), %rax
	movq	%rax, -72(%rbp)
	movq	-72(%rbp), %rax
	movq	%rax, -32(%rbp)
	movq	$0, -64(%rbp)
	movq	-32(%rbp), %rax
	movl	$1, %ecx
	movl	$1, %edx
	movq	%rax, %rsi
	movl	$1, %edi
	call	_mhz_3
	movl	-84(%rbp), %eax
	movl	%eax, %edi
	call	get_enough@PLT
	movl	%eax, -76(%rbp)
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -48(%rbp)
	jmp	.L90
.L105:
	movl	$0, %edi
	call	start@PLT
	movq	__iterations.6(%rip), %rax
	movq	%rax, -56(%rbp)
	jmp	.L91
.L92:
	movq	-56(%rbp), %rax
	movq	-40(%rbp), %rcx
	movq	-40(%rbp), %rdx
	movq	-32(%rbp), %rsi
	movq	%rax, %rdi
	call	_mhz_3
	movq	%rax, -64(%rbp)
	movq	$1, -56(%rbp)
	subq	$1, -56(%rbp)
.L91:
	cmpq	$0, -56(%rbp)
	jne	.L92
	movl	$0, %esi
	movl	$0, %edi
	call	stop@PLT
	testq	%rax, %rax
	js	.L93
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L94
.L93:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L94:
	movsd	%xmm0, -48(%rbp)
	pxor	%xmm1, %xmm1
	cvtsi2sdl	-76(%rbp), %xmm1
	movsd	.LC3(%rip), %xmm0
	mulsd	%xmm1, %xmm0
	comisd	-48(%rbp), %xmm0
	ja	.L95
	pxor	%xmm1, %xmm1
	cvtsi2sdl	-76(%rbp), %xmm1
	movsd	.LC4(%rip), %xmm0
	mulsd	%xmm0, %xmm1
	movsd	-48(%rbp), %xmm0
	comisd	%xmm1, %xmm0
	ja	.L95
	jmp	.L90
.L95:
	movsd	-48(%rbp), %xmm0
	comisd	.LC5(%rip), %xmm0
	jbe	.L122
	movq	__iterations.6(%rip), %rax
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
	divsd	-48(%rbp), %xmm0
	movsd	%xmm0, -24(%rbp)
	pxor	%xmm1, %xmm1
	cvtsi2sdl	-76(%rbp), %xmm1
	movsd	.LC6(%rip), %xmm0
	mulsd	%xmm1, %xmm0
	movsd	-24(%rbp), %xmm1
	mulsd	%xmm1, %xmm0
	movsd	%xmm0, -24(%rbp)
	movsd	-24(%rbp), %xmm1
	movsd	.LC7(%rip), %xmm0
	addsd	%xmm1, %xmm0
	comisd	.LC8(%rip), %xmm0
	jnb	.L101
	cvttsd2siq	%xmm0, %rax
	jmp	.L102
.L101:
	movsd	.LC8(%rip), %xmm1
	subsd	%xmm1, %xmm0
	cvttsd2siq	%xmm0, %rax
	movabsq	$-9223372036854775808, %rdx
	xorq	%rdx, %rax
.L102:
	movq	%rax, __iterations.6(%rip)
	jmp	.L90
.L122:
	movq	__iterations.6(%rip), %rax
	cmpq	$134217728, %rax
	jbe	.L103
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -48(%rbp)
	jmp	.L104
.L103:
	movq	__iterations.6(%rip), %rax
	salq	$3, %rax
	movq	%rax, __iterations.6(%rip)
.L90:
	pxor	%xmm1, %xmm1
	cvtsi2sdl	-76(%rbp), %xmm1
	movsd	.LC9(%rip), %xmm0
	mulsd	%xmm1, %xmm0
	comisd	-48(%rbp), %xmm0
	ja	.L105
.L104:
	movq	__iterations.6(%rip), %rax
	movq	%rax, %rdi
	call	save_n@PLT
	movsd	-48(%rbp), %xmm0
	comisd	.LC8(%rip), %xmm0
	jnb	.L106
	movsd	-48(%rbp), %xmm0
	cvttsd2siq	%xmm0, %rax
	jmp	.L107
.L106:
	movsd	-48(%rbp), %xmm0
	movsd	.LC8(%rip), %xmm1
	subsd	%xmm1, %xmm0
	cvttsd2siq	%xmm0, %rax
	movabsq	$-9223372036854775808, %rdx
	xorq	%rdx, %rax
.L107:
	movq	%rax, %rdi
	call	settime@PLT
	call	usecs_spent@PLT
	testq	%rax, %rax
	js	.L108
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L109
.L108:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L109:
	movsd	%xmm0, -16(%rbp)
	call	t_overhead@PLT
	testq	%rax, %rax
	js	.L110
	pxor	%xmm2, %xmm2
	cvtsi2sdq	%rax, %xmm2
	movsd	%xmm2, -96(%rbp)
	jmp	.L111
.L110:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
	movsd	%xmm0, -96(%rbp)
.L111:
	call	get_n@PLT
	testq	%rax, %rax
	js	.L112
	pxor	%xmm3, %xmm3
	cvtsi2sdq	%rax, %xmm3
	movsd	%xmm3, -104(%rbp)
	jmp	.L113
.L112:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
	movsd	%xmm0, -104(%rbp)
.L113:
	call	l_overhead@PLT
	mulsd	-104(%rbp), %xmm0
	movsd	-96(%rbp), %xmm1
	addsd	%xmm0, %xmm1
	movsd	-16(%rbp), %xmm0
	subsd	%xmm1, %xmm0
	movsd	%xmm0, -16(%rbp)
	movsd	-16(%rbp), %xmm0
	pxor	%xmm1, %xmm1
	comisd	%xmm1, %xmm0
	jb	.L123
	movsd	-16(%rbp), %xmm0
	comisd	.LC8(%rip), %xmm0
	jnb	.L116
	movsd	-16(%rbp), %xmm0
	cvttsd2siq	%xmm0, %rax
	jmp	.L118
.L116:
	movsd	-16(%rbp), %xmm0
	movsd	.LC8(%rip), %xmm1
	subsd	%xmm1, %xmm0
	cvttsd2siq	%xmm0, %rax
	movabsq	$-9223372036854775808, %rdx
	xorq	%rdx, %rax
	jmp	.L118
.L123:
	movl	$0, %eax
.L118:
	movq	%rax, %rdi
	call	settime@PLT
	movq	-64(%rbp), %rax
	movq	%rax, %rdi
	call	use_pointer@PLT
	call	get_n@PLT
	movq	%rax, %rdx
	movq	%rdx, %rax
	salq	$2, %rax
	addq	%rdx, %rax
	leaq	0(,%rax,4), %rdx
	addq	%rdx, %rax
	salq	$2, %rax
	movq	%rax, %rdi
	call	save_n@PLT
	movq	-8(%rbp), %rax
	subq	%fs:40, %rax
	je	.L119
	call	__stack_chk_fail@PLT
.L119:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE16:
	.size	mhz_3, .-mhz_3
	.section	.rodata
.LC12:
	.string	"a>>=b;"
	.text
	.globl	name_4
	.type	name_4, @function
name_4:
.LFB17:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	leaq	.LC12(%rip), %rax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE17:
	.size	name_4, .-name_4
	.globl	_mhz_4
	.type	_mhz_4, @function
_mhz_4:
.LFB18:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdx, %rax
	movq	%rcx, %rdx
	jmp	.L127
.L128:
	movl	%edx, %ecx
	sarq	%cl, %rax
	movl	%edx, %ecx
	sarq	%cl, %rax
	movl	%edx, %ecx
	sarq	%cl, %rax
	movl	%edx, %ecx
	sarq	%cl, %rax
	movl	%edx, %ecx
	sarq	%cl, %rax
	movl	%edx, %ecx
	sarq	%cl, %rax
	movl	%edx, %ecx
	sarq	%cl, %rax
	movl	%edx, %ecx
	sarq	%cl, %rax
	movl	%edx, %ecx
	sarq	%cl, %rax
	movl	%edx, %ecx
	sarq	%cl, %rax
	movl	%edx, %ecx
	sarq	%cl, %rax
	movl	%edx, %ecx
	sarq	%cl, %rax
	movl	%edx, %ecx
	sarq	%cl, %rax
	movl	%edx, %ecx
	sarq	%cl, %rax
	movl	%edx, %ecx
	sarq	%cl, %rax
	movl	%edx, %ecx
	sarq	%cl, %rax
	movl	%edx, %ecx
	sarq	%cl, %rax
	movl	%edx, %ecx
	sarq	%cl, %rax
	movl	%edx, %ecx
	sarq	%cl, %rax
	movl	%edx, %ecx
	sarq	%cl, %rax
	movl	%edx, %ecx
	sarq	%cl, %rax
	movl	%edx, %ecx
	sarq	%cl, %rax
	movl	%edx, %ecx
	sarq	%cl, %rax
	movl	%edx, %ecx
	sarq	%cl, %rax
	movl	%edx, %ecx
	sarq	%cl, %rax
	movl	%edx, %ecx
	sarq	%cl, %rax
	movl	%edx, %ecx
	sarq	%cl, %rax
	movl	%edx, %ecx
	sarq	%cl, %rax
	movl	%edx, %ecx
	sarq	%cl, %rax
	movl	%edx, %ecx
	sarq	%cl, %rax
	movl	%edx, %ecx
	sarq	%cl, %rax
	movl	%edx, %ecx
	sarq	%cl, %rax
	movl	%edx, %ecx
	sarq	%cl, %rax
	movl	%edx, %ecx
	sarq	%cl, %rax
	movl	%edx, %ecx
	sarq	%cl, %rax
	movl	%edx, %ecx
	sarq	%cl, %rax
	movl	%edx, %ecx
	sarq	%cl, %rax
	movl	%edx, %ecx
	sarq	%cl, %rax
	movl	%edx, %ecx
	sarq	%cl, %rax
	movl	%edx, %ecx
	sarq	%cl, %rax
	movl	%edx, %ecx
	sarq	%cl, %rax
	movl	%edx, %ecx
	sarq	%cl, %rax
	movl	%edx, %ecx
	sarq	%cl, %rax
	movl	%edx, %ecx
	sarq	%cl, %rax
	movl	%edx, %ecx
	sarq	%cl, %rax
	movl	%edx, %ecx
	sarq	%cl, %rax
	movl	%edx, %ecx
	sarq	%cl, %rax
	movl	%edx, %ecx
	sarq	%cl, %rax
	movl	%edx, %ecx
	sarq	%cl, %rax
	movl	%edx, %ecx
	sarq	%cl, %rax
	movl	%edx, %ecx
	sarq	%cl, %rax
	movl	%edx, %ecx
	sarq	%cl, %rax
	movl	%edx, %ecx
	sarq	%cl, %rax
	movl	%edx, %ecx
	sarq	%cl, %rax
	movl	%edx, %ecx
	sarq	%cl, %rax
	movl	%edx, %ecx
	sarq	%cl, %rax
	movl	%edx, %ecx
	sarq	%cl, %rax
	movl	%edx, %ecx
	sarq	%cl, %rax
	movl	%edx, %ecx
	sarq	%cl, %rax
	movl	%edx, %ecx
	sarq	%cl, %rax
	movl	%edx, %ecx
	sarq	%cl, %rax
	movl	%edx, %ecx
	sarq	%cl, %rax
	movl	%edx, %ecx
	sarq	%cl, %rax
	movl	%edx, %ecx
	sarq	%cl, %rax
	movl	%edx, %ecx
	sarq	%cl, %rax
	movl	%edx, %ecx
	sarq	%cl, %rax
	movl	%edx, %ecx
	sarq	%cl, %rax
	movl	%edx, %ecx
	sarq	%cl, %rax
	movl	%edx, %ecx
	sarq	%cl, %rax
	movl	%edx, %ecx
	sarq	%cl, %rax
	movl	%edx, %ecx
	sarq	%cl, %rax
	movl	%edx, %ecx
	sarq	%cl, %rax
	movl	%edx, %ecx
	sarq	%cl, %rax
	movl	%edx, %ecx
	sarq	%cl, %rax
	movl	%edx, %ecx
	sarq	%cl, %rax
	movl	%edx, %ecx
	sarq	%cl, %rax
	movl	%edx, %ecx
	sarq	%cl, %rax
	movl	%edx, %ecx
	sarq	%cl, %rax
	movl	%edx, %ecx
	sarq	%cl, %rax
	movl	%edx, %ecx
	sarq	%cl, %rax
	movl	%edx, %ecx
	sarq	%cl, %rax
	movl	%edx, %ecx
	sarq	%cl, %rax
	movl	%edx, %ecx
	sarq	%cl, %rax
	movl	%edx, %ecx
	sarq	%cl, %rax
	movl	%edx, %ecx
	sarq	%cl, %rax
	movl	%edx, %ecx
	sarq	%cl, %rax
	movl	%edx, %ecx
	sarq	%cl, %rax
	movl	%edx, %ecx
	sarq	%cl, %rax
	movl	%edx, %ecx
	sarq	%cl, %rax
	movl	%edx, %ecx
	sarq	%cl, %rax
	movl	%edx, %ecx
	sarq	%cl, %rax
	movl	%edx, %ecx
	sarq	%cl, %rax
	movl	%edx, %ecx
	sarq	%cl, %rax
	movl	%edx, %ecx
	sarq	%cl, %rax
	movl	%edx, %ecx
	sarq	%cl, %rax
	movl	%edx, %ecx
	sarq	%cl, %rax
	movl	%edx, %ecx
	sarq	%cl, %rax
	movl	%edx, %ecx
	sarq	%cl, %rax
	movl	%edx, %ecx
	sarq	%cl, %rax
	movl	%edx, %ecx
	sarq	%cl, %rax
	subq	$1, %rdi
.L127:
	testq	%rdi, %rdi
	jg	.L128
	movq	%rax, %rcx
	movq	%rdx, %rax
	addq	%rcx, %rax
	salq	$3, %rax
	addq	%rsi, %rax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE18:
	.size	_mhz_4, .-_mhz_4
	.globl	mhz_4
	.type	mhz_4, @function
mhz_4:
.LFB19:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$112, %rsp
	movl	%edi, -84(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movq	$1, -40(%rbp)
	leaq	-72(%rbp), %rax
	movq	%rax, -72(%rbp)
	movq	-72(%rbp), %rax
	movq	%rax, -32(%rbp)
	movq	$0, -64(%rbp)
	movq	-32(%rbp), %rax
	movl	$1, %ecx
	movl	$1, %edx
	movq	%rax, %rsi
	movl	$1, %edi
	call	_mhz_4
	movl	-84(%rbp), %eax
	movl	%eax, %edi
	call	get_enough@PLT
	movl	%eax, -76(%rbp)
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -48(%rbp)
	jmp	.L131
.L146:
	movl	$0, %edi
	call	start@PLT
	movq	__iterations.5(%rip), %rax
	movq	%rax, -56(%rbp)
	jmp	.L132
.L133:
	movq	-56(%rbp), %rax
	movq	-40(%rbp), %rcx
	movq	-40(%rbp), %rdx
	movq	-32(%rbp), %rsi
	movq	%rax, %rdi
	call	_mhz_4
	movq	%rax, -64(%rbp)
	movq	$1, -56(%rbp)
	subq	$1, -56(%rbp)
.L132:
	cmpq	$0, -56(%rbp)
	jne	.L133
	movl	$0, %esi
	movl	$0, %edi
	call	stop@PLT
	testq	%rax, %rax
	js	.L134
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L135
.L134:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L135:
	movsd	%xmm0, -48(%rbp)
	pxor	%xmm1, %xmm1
	cvtsi2sdl	-76(%rbp), %xmm1
	movsd	.LC3(%rip), %xmm0
	mulsd	%xmm1, %xmm0
	comisd	-48(%rbp), %xmm0
	ja	.L136
	pxor	%xmm1, %xmm1
	cvtsi2sdl	-76(%rbp), %xmm1
	movsd	.LC4(%rip), %xmm0
	mulsd	%xmm0, %xmm1
	movsd	-48(%rbp), %xmm0
	comisd	%xmm1, %xmm0
	ja	.L136
	jmp	.L131
.L136:
	movsd	-48(%rbp), %xmm0
	comisd	.LC5(%rip), %xmm0
	jbe	.L163
	movq	__iterations.5(%rip), %rax
	testq	%rax, %rax
	js	.L140
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L141
.L140:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L141:
	divsd	-48(%rbp), %xmm0
	movsd	%xmm0, -24(%rbp)
	pxor	%xmm1, %xmm1
	cvtsi2sdl	-76(%rbp), %xmm1
	movsd	.LC6(%rip), %xmm0
	mulsd	%xmm1, %xmm0
	movsd	-24(%rbp), %xmm1
	mulsd	%xmm1, %xmm0
	movsd	%xmm0, -24(%rbp)
	movsd	-24(%rbp), %xmm1
	movsd	.LC7(%rip), %xmm0
	addsd	%xmm1, %xmm0
	comisd	.LC8(%rip), %xmm0
	jnb	.L142
	cvttsd2siq	%xmm0, %rax
	jmp	.L143
.L142:
	movsd	.LC8(%rip), %xmm1
	subsd	%xmm1, %xmm0
	cvttsd2siq	%xmm0, %rax
	movabsq	$-9223372036854775808, %rdx
	xorq	%rdx, %rax
.L143:
	movq	%rax, __iterations.5(%rip)
	jmp	.L131
.L163:
	movq	__iterations.5(%rip), %rax
	cmpq	$134217728, %rax
	jbe	.L144
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -48(%rbp)
	jmp	.L145
.L144:
	movq	__iterations.5(%rip), %rax
	salq	$3, %rax
	movq	%rax, __iterations.5(%rip)
.L131:
	pxor	%xmm1, %xmm1
	cvtsi2sdl	-76(%rbp), %xmm1
	movsd	.LC9(%rip), %xmm0
	mulsd	%xmm1, %xmm0
	comisd	-48(%rbp), %xmm0
	ja	.L146
.L145:
	movq	__iterations.5(%rip), %rax
	movq	%rax, %rdi
	call	save_n@PLT
	movsd	-48(%rbp), %xmm0
	comisd	.LC8(%rip), %xmm0
	jnb	.L147
	movsd	-48(%rbp), %xmm0
	cvttsd2siq	%xmm0, %rax
	jmp	.L148
.L147:
	movsd	-48(%rbp), %xmm0
	movsd	.LC8(%rip), %xmm1
	subsd	%xmm1, %xmm0
	cvttsd2siq	%xmm0, %rax
	movabsq	$-9223372036854775808, %rdx
	xorq	%rdx, %rax
.L148:
	movq	%rax, %rdi
	call	settime@PLT
	call	usecs_spent@PLT
	testq	%rax, %rax
	js	.L149
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L150
.L149:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L150:
	movsd	%xmm0, -16(%rbp)
	call	t_overhead@PLT
	testq	%rax, %rax
	js	.L151
	pxor	%xmm2, %xmm2
	cvtsi2sdq	%rax, %xmm2
	movsd	%xmm2, -96(%rbp)
	jmp	.L152
.L151:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
	movsd	%xmm0, -96(%rbp)
.L152:
	call	get_n@PLT
	testq	%rax, %rax
	js	.L153
	pxor	%xmm3, %xmm3
	cvtsi2sdq	%rax, %xmm3
	movsd	%xmm3, -104(%rbp)
	jmp	.L154
.L153:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
	movsd	%xmm0, -104(%rbp)
.L154:
	call	l_overhead@PLT
	mulsd	-104(%rbp), %xmm0
	movsd	-96(%rbp), %xmm1
	addsd	%xmm0, %xmm1
	movsd	-16(%rbp), %xmm0
	subsd	%xmm1, %xmm0
	movsd	%xmm0, -16(%rbp)
	movsd	-16(%rbp), %xmm0
	pxor	%xmm1, %xmm1
	comisd	%xmm1, %xmm0
	jb	.L164
	movsd	-16(%rbp), %xmm0
	comisd	.LC8(%rip), %xmm0
	jnb	.L157
	movsd	-16(%rbp), %xmm0
	cvttsd2siq	%xmm0, %rax
	jmp	.L159
.L157:
	movsd	-16(%rbp), %xmm0
	movsd	.LC8(%rip), %xmm1
	subsd	%xmm1, %xmm0
	cvttsd2siq	%xmm0, %rax
	movabsq	$-9223372036854775808, %rdx
	xorq	%rdx, %rax
	jmp	.L159
.L164:
	movl	$0, %eax
.L159:
	movq	%rax, %rdi
	call	settime@PLT
	movq	-64(%rbp), %rax
	movq	%rax, %rdi
	call	use_pointer@PLT
	call	get_n@PLT
	movq	%rax, %rdx
	movq	%rdx, %rax
	salq	$2, %rax
	addq	%rdx, %rax
	leaq	0(,%rax,4), %rdx
	addq	%rdx, %rax
	salq	$2, %rax
	movq	%rax, %rdi
	call	save_n@PLT
	movq	-8(%rbp), %rax
	subq	%fs:40, %rax
	je	.L160
	call	__stack_chk_fail@PLT
.L160:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE19:
	.size	mhz_4, .-mhz_4
	.section	.rodata
.LC13:
	.string	"a>>=a+a;"
	.text
	.globl	name_5
	.type	name_5, @function
name_5:
.LFB20:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	leaq	.LC13(%rip), %rax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE20:
	.size	name_5, .-name_5
	.globl	_mhz_5
	.type	_mhz_5, @function
_mhz_5:
.LFB21:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdx, %rax
	movq	%rcx, %rdx
	jmp	.L168
.L169:
	movl	%eax, %ecx
	addl	%ecx, %ecx
	sarq	%cl, %rax
	movl	%eax, %ecx
	addl	%ecx, %ecx
	sarq	%cl, %rax
	movl	%eax, %ecx
	addl	%ecx, %ecx
	sarq	%cl, %rax
	movl	%eax, %ecx
	addl	%ecx, %ecx
	sarq	%cl, %rax
	movl	%eax, %ecx
	addl	%ecx, %ecx
	sarq	%cl, %rax
	movl	%eax, %ecx
	addl	%ecx, %ecx
	sarq	%cl, %rax
	movl	%eax, %ecx
	addl	%ecx, %ecx
	sarq	%cl, %rax
	movl	%eax, %ecx
	addl	%ecx, %ecx
	sarq	%cl, %rax
	movl	%eax, %ecx
	addl	%ecx, %ecx
	sarq	%cl, %rax
	movl	%eax, %ecx
	addl	%ecx, %ecx
	sarq	%cl, %rax
	movl	%eax, %ecx
	addl	%ecx, %ecx
	sarq	%cl, %rax
	movl	%eax, %ecx
	addl	%ecx, %ecx
	sarq	%cl, %rax
	movl	%eax, %ecx
	addl	%ecx, %ecx
	sarq	%cl, %rax
	movl	%eax, %ecx
	addl	%ecx, %ecx
	sarq	%cl, %rax
	movl	%eax, %ecx
	addl	%ecx, %ecx
	sarq	%cl, %rax
	movl	%eax, %ecx
	addl	%ecx, %ecx
	sarq	%cl, %rax
	movl	%eax, %ecx
	addl	%ecx, %ecx
	sarq	%cl, %rax
	movl	%eax, %ecx
	addl	%ecx, %ecx
	sarq	%cl, %rax
	movl	%eax, %ecx
	addl	%ecx, %ecx
	sarq	%cl, %rax
	movl	%eax, %ecx
	addl	%ecx, %ecx
	sarq	%cl, %rax
	movl	%eax, %ecx
	addl	%ecx, %ecx
	sarq	%cl, %rax
	movl	%eax, %ecx
	addl	%ecx, %ecx
	sarq	%cl, %rax
	movl	%eax, %ecx
	addl	%ecx, %ecx
	sarq	%cl, %rax
	movl	%eax, %ecx
	addl	%ecx, %ecx
	sarq	%cl, %rax
	movl	%eax, %ecx
	addl	%ecx, %ecx
	sarq	%cl, %rax
	movl	%eax, %ecx
	addl	%ecx, %ecx
	sarq	%cl, %rax
	movl	%eax, %ecx
	addl	%ecx, %ecx
	sarq	%cl, %rax
	movl	%eax, %ecx
	addl	%ecx, %ecx
	sarq	%cl, %rax
	movl	%eax, %ecx
	addl	%ecx, %ecx
	sarq	%cl, %rax
	movl	%eax, %ecx
	addl	%ecx, %ecx
	sarq	%cl, %rax
	movl	%eax, %ecx
	addl	%ecx, %ecx
	sarq	%cl, %rax
	movl	%eax, %ecx
	addl	%ecx, %ecx
	sarq	%cl, %rax
	movl	%eax, %ecx
	addl	%ecx, %ecx
	sarq	%cl, %rax
	movl	%eax, %ecx
	addl	%ecx, %ecx
	sarq	%cl, %rax
	movl	%eax, %ecx
	addl	%ecx, %ecx
	sarq	%cl, %rax
	movl	%eax, %ecx
	addl	%ecx, %ecx
	sarq	%cl, %rax
	movl	%eax, %ecx
	addl	%ecx, %ecx
	sarq	%cl, %rax
	movl	%eax, %ecx
	addl	%ecx, %ecx
	sarq	%cl, %rax
	movl	%eax, %ecx
	addl	%ecx, %ecx
	sarq	%cl, %rax
	movl	%eax, %ecx
	addl	%ecx, %ecx
	sarq	%cl, %rax
	movl	%eax, %ecx
	addl	%ecx, %ecx
	sarq	%cl, %rax
	movl	%eax, %ecx
	addl	%ecx, %ecx
	sarq	%cl, %rax
	movl	%eax, %ecx
	addl	%ecx, %ecx
	sarq	%cl, %rax
	movl	%eax, %ecx
	addl	%ecx, %ecx
	sarq	%cl, %rax
	movl	%eax, %ecx
	addl	%ecx, %ecx
	sarq	%cl, %rax
	movl	%eax, %ecx
	addl	%ecx, %ecx
	sarq	%cl, %rax
	movl	%eax, %ecx
	addl	%ecx, %ecx
	sarq	%cl, %rax
	movl	%eax, %ecx
	addl	%ecx, %ecx
	sarq	%cl, %rax
	movl	%eax, %ecx
	addl	%ecx, %ecx
	sarq	%cl, %rax
	movl	%eax, %ecx
	addl	%ecx, %ecx
	sarq	%cl, %rax
	movl	%eax, %ecx
	addl	%ecx, %ecx
	sarq	%cl, %rax
	movl	%eax, %ecx
	addl	%ecx, %ecx
	sarq	%cl, %rax
	movl	%eax, %ecx
	addl	%ecx, %ecx
	sarq	%cl, %rax
	movl	%eax, %ecx
	addl	%ecx, %ecx
	sarq	%cl, %rax
	movl	%eax, %ecx
	addl	%ecx, %ecx
	sarq	%cl, %rax
	movl	%eax, %ecx
	addl	%ecx, %ecx
	sarq	%cl, %rax
	movl	%eax, %ecx
	addl	%ecx, %ecx
	sarq	%cl, %rax
	movl	%eax, %ecx
	addl	%ecx, %ecx
	sarq	%cl, %rax
	movl	%eax, %ecx
	addl	%ecx, %ecx
	sarq	%cl, %rax
	movl	%eax, %ecx
	addl	%ecx, %ecx
	sarq	%cl, %rax
	movl	%eax, %ecx
	addl	%ecx, %ecx
	sarq	%cl, %rax
	movl	%eax, %ecx
	addl	%ecx, %ecx
	sarq	%cl, %rax
	movl	%eax, %ecx
	addl	%ecx, %ecx
	sarq	%cl, %rax
	movl	%eax, %ecx
	addl	%ecx, %ecx
	sarq	%cl, %rax
	movl	%eax, %ecx
	addl	%ecx, %ecx
	sarq	%cl, %rax
	movl	%eax, %ecx
	addl	%ecx, %ecx
	sarq	%cl, %rax
	movl	%eax, %ecx
	addl	%ecx, %ecx
	sarq	%cl, %rax
	movl	%eax, %ecx
	addl	%ecx, %ecx
	sarq	%cl, %rax
	movl	%eax, %ecx
	addl	%ecx, %ecx
	sarq	%cl, %rax
	movl	%eax, %ecx
	addl	%ecx, %ecx
	sarq	%cl, %rax
	movl	%eax, %ecx
	addl	%ecx, %ecx
	sarq	%cl, %rax
	movl	%eax, %ecx
	addl	%ecx, %ecx
	sarq	%cl, %rax
	movl	%eax, %ecx
	addl	%ecx, %ecx
	sarq	%cl, %rax
	movl	%eax, %ecx
	addl	%ecx, %ecx
	sarq	%cl, %rax
	movl	%eax, %ecx
	addl	%ecx, %ecx
	sarq	%cl, %rax
	movl	%eax, %ecx
	addl	%ecx, %ecx
	sarq	%cl, %rax
	movl	%eax, %ecx
	addl	%ecx, %ecx
	sarq	%cl, %rax
	movl	%eax, %ecx
	addl	%ecx, %ecx
	sarq	%cl, %rax
	movl	%eax, %ecx
	addl	%ecx, %ecx
	sarq	%cl, %rax
	movl	%eax, %ecx
	addl	%ecx, %ecx
	sarq	%cl, %rax
	movl	%eax, %ecx
	addl	%ecx, %ecx
	sarq	%cl, %rax
	movl	%eax, %ecx
	addl	%ecx, %ecx
	sarq	%cl, %rax
	movl	%eax, %ecx
	addl	%ecx, %ecx
	sarq	%cl, %rax
	movl	%eax, %ecx
	addl	%ecx, %ecx
	sarq	%cl, %rax
	movl	%eax, %ecx
	addl	%ecx, %ecx
	sarq	%cl, %rax
	movl	%eax, %ecx
	addl	%ecx, %ecx
	sarq	%cl, %rax
	movl	%eax, %ecx
	addl	%ecx, %ecx
	sarq	%cl, %rax
	movl	%eax, %ecx
	addl	%ecx, %ecx
	sarq	%cl, %rax
	movl	%eax, %ecx
	addl	%ecx, %ecx
	sarq	%cl, %rax
	movl	%eax, %ecx
	addl	%ecx, %ecx
	sarq	%cl, %rax
	movl	%eax, %ecx
	addl	%ecx, %ecx
	sarq	%cl, %rax
	movl	%eax, %ecx
	addl	%ecx, %ecx
	sarq	%cl, %rax
	movl	%eax, %ecx
	addl	%ecx, %ecx
	sarq	%cl, %rax
	movl	%eax, %ecx
	addl	%ecx, %ecx
	sarq	%cl, %rax
	movl	%eax, %ecx
	addl	%ecx, %ecx
	sarq	%cl, %rax
	movl	%eax, %ecx
	addl	%ecx, %ecx
	sarq	%cl, %rax
	movl	%eax, %ecx
	addl	%ecx, %ecx
	sarq	%cl, %rax
	movl	%eax, %ecx
	addl	%ecx, %ecx
	sarq	%cl, %rax
	movl	%eax, %ecx
	addl	%ecx, %ecx
	sarq	%cl, %rax
	movl	%eax, %ecx
	addl	%ecx, %ecx
	sarq	%cl, %rax
	subq	$1, %rdi
.L168:
	testq	%rdi, %rdi
	jg	.L169
	movq	%rax, %rcx
	movq	%rdx, %rax
	addq	%rcx, %rax
	salq	$3, %rax
	addq	%rsi, %rax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE21:
	.size	_mhz_5, .-_mhz_5
	.globl	mhz_5
	.type	mhz_5, @function
mhz_5:
.LFB22:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$112, %rsp
	movl	%edi, -84(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movq	$1, -40(%rbp)
	leaq	-72(%rbp), %rax
	movq	%rax, -72(%rbp)
	movq	-72(%rbp), %rax
	movq	%rax, -32(%rbp)
	movq	$0, -64(%rbp)
	movq	-32(%rbp), %rax
	movl	$1, %ecx
	movl	$1, %edx
	movq	%rax, %rsi
	movl	$1, %edi
	call	_mhz_5
	movl	-84(%rbp), %eax
	movl	%eax, %edi
	call	get_enough@PLT
	movl	%eax, -76(%rbp)
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -48(%rbp)
	jmp	.L172
.L187:
	movl	$0, %edi
	call	start@PLT
	movq	__iterations.4(%rip), %rax
	movq	%rax, -56(%rbp)
	jmp	.L173
.L174:
	movq	-56(%rbp), %rax
	movq	-40(%rbp), %rcx
	movq	-40(%rbp), %rdx
	movq	-32(%rbp), %rsi
	movq	%rax, %rdi
	call	_mhz_5
	movq	%rax, -64(%rbp)
	movq	$1, -56(%rbp)
	subq	$1, -56(%rbp)
.L173:
	cmpq	$0, -56(%rbp)
	jne	.L174
	movl	$0, %esi
	movl	$0, %edi
	call	stop@PLT
	testq	%rax, %rax
	js	.L175
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L176
.L175:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L176:
	movsd	%xmm0, -48(%rbp)
	pxor	%xmm1, %xmm1
	cvtsi2sdl	-76(%rbp), %xmm1
	movsd	.LC3(%rip), %xmm0
	mulsd	%xmm1, %xmm0
	comisd	-48(%rbp), %xmm0
	ja	.L177
	pxor	%xmm1, %xmm1
	cvtsi2sdl	-76(%rbp), %xmm1
	movsd	.LC4(%rip), %xmm0
	mulsd	%xmm0, %xmm1
	movsd	-48(%rbp), %xmm0
	comisd	%xmm1, %xmm0
	ja	.L177
	jmp	.L172
.L177:
	movsd	-48(%rbp), %xmm0
	comisd	.LC5(%rip), %xmm0
	jbe	.L204
	movq	__iterations.4(%rip), %rax
	testq	%rax, %rax
	js	.L181
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L182
.L181:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L182:
	divsd	-48(%rbp), %xmm0
	movsd	%xmm0, -24(%rbp)
	pxor	%xmm1, %xmm1
	cvtsi2sdl	-76(%rbp), %xmm1
	movsd	.LC6(%rip), %xmm0
	mulsd	%xmm1, %xmm0
	movsd	-24(%rbp), %xmm1
	mulsd	%xmm1, %xmm0
	movsd	%xmm0, -24(%rbp)
	movsd	-24(%rbp), %xmm1
	movsd	.LC7(%rip), %xmm0
	addsd	%xmm1, %xmm0
	comisd	.LC8(%rip), %xmm0
	jnb	.L183
	cvttsd2siq	%xmm0, %rax
	jmp	.L184
.L183:
	movsd	.LC8(%rip), %xmm1
	subsd	%xmm1, %xmm0
	cvttsd2siq	%xmm0, %rax
	movabsq	$-9223372036854775808, %rdx
	xorq	%rdx, %rax
.L184:
	movq	%rax, __iterations.4(%rip)
	jmp	.L172
.L204:
	movq	__iterations.4(%rip), %rax
	cmpq	$134217728, %rax
	jbe	.L185
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -48(%rbp)
	jmp	.L186
.L185:
	movq	__iterations.4(%rip), %rax
	salq	$3, %rax
	movq	%rax, __iterations.4(%rip)
.L172:
	pxor	%xmm1, %xmm1
	cvtsi2sdl	-76(%rbp), %xmm1
	movsd	.LC9(%rip), %xmm0
	mulsd	%xmm1, %xmm0
	comisd	-48(%rbp), %xmm0
	ja	.L187
.L186:
	movq	__iterations.4(%rip), %rax
	movq	%rax, %rdi
	call	save_n@PLT
	movsd	-48(%rbp), %xmm0
	comisd	.LC8(%rip), %xmm0
	jnb	.L188
	movsd	-48(%rbp), %xmm0
	cvttsd2siq	%xmm0, %rax
	jmp	.L189
.L188:
	movsd	-48(%rbp), %xmm0
	movsd	.LC8(%rip), %xmm1
	subsd	%xmm1, %xmm0
	cvttsd2siq	%xmm0, %rax
	movabsq	$-9223372036854775808, %rdx
	xorq	%rdx, %rax
.L189:
	movq	%rax, %rdi
	call	settime@PLT
	call	usecs_spent@PLT
	testq	%rax, %rax
	js	.L190
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L191
.L190:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L191:
	movsd	%xmm0, -16(%rbp)
	call	t_overhead@PLT
	testq	%rax, %rax
	js	.L192
	pxor	%xmm2, %xmm2
	cvtsi2sdq	%rax, %xmm2
	movsd	%xmm2, -96(%rbp)
	jmp	.L193
.L192:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
	movsd	%xmm0, -96(%rbp)
.L193:
	call	get_n@PLT
	testq	%rax, %rax
	js	.L194
	pxor	%xmm3, %xmm3
	cvtsi2sdq	%rax, %xmm3
	movsd	%xmm3, -104(%rbp)
	jmp	.L195
.L194:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
	movsd	%xmm0, -104(%rbp)
.L195:
	call	l_overhead@PLT
	mulsd	-104(%rbp), %xmm0
	movsd	-96(%rbp), %xmm1
	addsd	%xmm0, %xmm1
	movsd	-16(%rbp), %xmm0
	subsd	%xmm1, %xmm0
	movsd	%xmm0, -16(%rbp)
	movsd	-16(%rbp), %xmm0
	pxor	%xmm1, %xmm1
	comisd	%xmm1, %xmm0
	jb	.L205
	movsd	-16(%rbp), %xmm0
	comisd	.LC8(%rip), %xmm0
	jnb	.L198
	movsd	-16(%rbp), %xmm0
	cvttsd2siq	%xmm0, %rax
	jmp	.L200
.L198:
	movsd	-16(%rbp), %xmm0
	movsd	.LC8(%rip), %xmm1
	subsd	%xmm1, %xmm0
	cvttsd2siq	%xmm0, %rax
	movabsq	$-9223372036854775808, %rdx
	xorq	%rdx, %rax
	jmp	.L200
.L205:
	movl	$0, %eax
.L200:
	movq	%rax, %rdi
	call	settime@PLT
	movq	-64(%rbp), %rax
	movq	%rax, %rdi
	call	use_pointer@PLT
	call	get_n@PLT
	movq	%rax, %rdx
	movq	%rdx, %rax
	salq	$2, %rax
	addq	%rdx, %rax
	leaq	0(,%rax,4), %rdx
	addq	%rdx, %rax
	salq	$2, %rax
	movq	%rax, %rdi
	call	save_n@PLT
	movq	-8(%rbp), %rax
	subq	%fs:40, %rax
	je	.L201
	call	__stack_chk_fail@PLT
.L201:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE22:
	.size	mhz_5, .-mhz_5
	.section	.rodata
.LC14:
	.string	"a^=a<<b;"
	.text
	.globl	name_6
	.type	name_6, @function
name_6:
.LFB23:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	leaq	.LC14(%rip), %rax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE23:
	.size	name_6, .-name_6
	.globl	_mhz_6
	.type	_mhz_6, @function
_mhz_6:
.LFB24:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdx, %rax
	movq	%rcx, %rdx
	jmp	.L209
.L210:
	movl	%edx, %ecx
	movq	%rax, %r8
	salq	%cl, %r8
	movq	%r8, %rcx
	xorq	%rcx, %rax
	movl	%edx, %ecx
	movq	%rax, %r9
	salq	%cl, %r9
	movq	%r9, %rcx
	xorq	%rcx, %rax
	movl	%edx, %ecx
	movq	%rax, %r10
	salq	%cl, %r10
	movq	%r10, %rcx
	xorq	%rcx, %rax
	movl	%edx, %ecx
	movq	%rax, %r11
	salq	%cl, %r11
	movq	%r11, %rcx
	xorq	%rcx, %rax
	movl	%edx, %ecx
	movq	%rax, %r8
	salq	%cl, %r8
	movq	%r8, %rcx
	xorq	%rcx, %rax
	movl	%edx, %ecx
	movq	%rax, %r9
	salq	%cl, %r9
	movq	%r9, %rcx
	xorq	%rcx, %rax
	movl	%edx, %ecx
	movq	%rax, %r10
	salq	%cl, %r10
	movq	%r10, %rcx
	xorq	%rcx, %rax
	movl	%edx, %ecx
	movq	%rax, %r11
	salq	%cl, %r11
	movq	%r11, %rcx
	xorq	%rcx, %rax
	movl	%edx, %ecx
	movq	%rax, %r8
	salq	%cl, %r8
	movq	%r8, %rcx
	xorq	%rcx, %rax
	movl	%edx, %ecx
	movq	%rax, %r9
	salq	%cl, %r9
	movq	%r9, %rcx
	xorq	%rcx, %rax
	movl	%edx, %ecx
	movq	%rax, %r10
	salq	%cl, %r10
	movq	%r10, %rcx
	xorq	%rcx, %rax
	movl	%edx, %ecx
	movq	%rax, %r11
	salq	%cl, %r11
	movq	%r11, %rcx
	xorq	%rcx, %rax
	movl	%edx, %ecx
	movq	%rax, %r8
	salq	%cl, %r8
	movq	%r8, %rcx
	xorq	%rcx, %rax
	movl	%edx, %ecx
	movq	%rax, %r9
	salq	%cl, %r9
	movq	%r9, %rcx
	xorq	%rcx, %rax
	movl	%edx, %ecx
	movq	%rax, %r10
	salq	%cl, %r10
	movq	%r10, %rcx
	xorq	%rcx, %rax
	movl	%edx, %ecx
	movq	%rax, %r11
	salq	%cl, %r11
	movq	%r11, %rcx
	xorq	%rcx, %rax
	movl	%edx, %ecx
	movq	%rax, %r8
	salq	%cl, %r8
	movq	%r8, %rcx
	xorq	%rcx, %rax
	movl	%edx, %ecx
	movq	%rax, %r9
	salq	%cl, %r9
	movq	%r9, %rcx
	xorq	%rcx, %rax
	movl	%edx, %ecx
	movq	%rax, %r10
	salq	%cl, %r10
	movq	%r10, %rcx
	xorq	%rcx, %rax
	movl	%edx, %ecx
	movq	%rax, %r11
	salq	%cl, %r11
	movq	%r11, %rcx
	xorq	%rcx, %rax
	movl	%edx, %ecx
	movq	%rax, %r8
	salq	%cl, %r8
	movq	%r8, %rcx
	xorq	%rcx, %rax
	movl	%edx, %ecx
	movq	%rax, %r9
	salq	%cl, %r9
	movq	%r9, %rcx
	xorq	%rcx, %rax
	movl	%edx, %ecx
	movq	%rax, %r10
	salq	%cl, %r10
	movq	%r10, %rcx
	xorq	%rcx, %rax
	movl	%edx, %ecx
	movq	%rax, %r11
	salq	%cl, %r11
	movq	%r11, %rcx
	xorq	%rcx, %rax
	movl	%edx, %ecx
	movq	%rax, %r8
	salq	%cl, %r8
	movq	%r8, %rcx
	xorq	%rcx, %rax
	movl	%edx, %ecx
	movq	%rax, %r9
	salq	%cl, %r9
	movq	%r9, %rcx
	xorq	%rcx, %rax
	movl	%edx, %ecx
	movq	%rax, %r10
	salq	%cl, %r10
	movq	%r10, %rcx
	xorq	%rcx, %rax
	movl	%edx, %ecx
	movq	%rax, %r11
	salq	%cl, %r11
	movq	%r11, %rcx
	xorq	%rcx, %rax
	movl	%edx, %ecx
	movq	%rax, %r8
	salq	%cl, %r8
	movq	%r8, %rcx
	xorq	%rcx, %rax
	movl	%edx, %ecx
	movq	%rax, %r9
	salq	%cl, %r9
	movq	%r9, %rcx
	xorq	%rcx, %rax
	movl	%edx, %ecx
	movq	%rax, %r10
	salq	%cl, %r10
	movq	%r10, %rcx
	xorq	%rcx, %rax
	movl	%edx, %ecx
	movq	%rax, %r11
	salq	%cl, %r11
	movq	%r11, %rcx
	xorq	%rcx, %rax
	movl	%edx, %ecx
	movq	%rax, %r8
	salq	%cl, %r8
	movq	%r8, %rcx
	xorq	%rcx, %rax
	movl	%edx, %ecx
	movq	%rax, %r9
	salq	%cl, %r9
	movq	%r9, %rcx
	xorq	%rcx, %rax
	movl	%edx, %ecx
	movq	%rax, %r10
	salq	%cl, %r10
	movq	%r10, %rcx
	xorq	%rcx, %rax
	movl	%edx, %ecx
	movq	%rax, %r11
	salq	%cl, %r11
	movq	%r11, %rcx
	xorq	%rcx, %rax
	movl	%edx, %ecx
	movq	%rax, %r8
	salq	%cl, %r8
	movq	%r8, %rcx
	xorq	%rcx, %rax
	movl	%edx, %ecx
	movq	%rax, %r9
	salq	%cl, %r9
	movq	%r9, %rcx
	xorq	%rcx, %rax
	movl	%edx, %ecx
	movq	%rax, %r10
	salq	%cl, %r10
	movq	%r10, %rcx
	xorq	%rcx, %rax
	movl	%edx, %ecx
	movq	%rax, %r11
	salq	%cl, %r11
	movq	%r11, %rcx
	xorq	%rcx, %rax
	movl	%edx, %ecx
	movq	%rax, %r8
	salq	%cl, %r8
	movq	%r8, %rcx
	xorq	%rcx, %rax
	movl	%edx, %ecx
	movq	%rax, %r9
	salq	%cl, %r9
	movq	%r9, %rcx
	xorq	%rcx, %rax
	movl	%edx, %ecx
	movq	%rax, %r10
	salq	%cl, %r10
	movq	%r10, %rcx
	xorq	%rcx, %rax
	movl	%edx, %ecx
	movq	%rax, %r11
	salq	%cl, %r11
	movq	%r11, %rcx
	xorq	%rcx, %rax
	movl	%edx, %ecx
	movq	%rax, %r8
	salq	%cl, %r8
	movq	%r8, %rcx
	xorq	%rcx, %rax
	movl	%edx, %ecx
	movq	%rax, %r9
	salq	%cl, %r9
	movq	%r9, %rcx
	xorq	%rcx, %rax
	movl	%edx, %ecx
	movq	%rax, %r10
	salq	%cl, %r10
	movq	%r10, %rcx
	xorq	%rcx, %rax
	movl	%edx, %ecx
	movq	%rax, %r11
	salq	%cl, %r11
	movq	%r11, %rcx
	xorq	%rcx, %rax
	movl	%edx, %ecx
	movq	%rax, %r8
	salq	%cl, %r8
	movq	%r8, %rcx
	xorq	%rcx, %rax
	movl	%edx, %ecx
	movq	%rax, %r9
	salq	%cl, %r9
	movq	%r9, %rcx
	xorq	%rcx, %rax
	movl	%edx, %ecx
	movq	%rax, %r10
	salq	%cl, %r10
	movq	%r10, %rcx
	xorq	%rcx, %rax
	movl	%edx, %ecx
	movq	%rax, %r11
	salq	%cl, %r11
	movq	%r11, %rcx
	xorq	%rcx, %rax
	movl	%edx, %ecx
	movq	%rax, %r8
	salq	%cl, %r8
	movq	%r8, %rcx
	xorq	%rcx, %rax
	movl	%edx, %ecx
	movq	%rax, %r9
	salq	%cl, %r9
	movq	%r9, %rcx
	xorq	%rcx, %rax
	movl	%edx, %ecx
	movq	%rax, %r10
	salq	%cl, %r10
	movq	%r10, %rcx
	xorq	%rcx, %rax
	movl	%edx, %ecx
	movq	%rax, %r11
	salq	%cl, %r11
	movq	%r11, %rcx
	xorq	%rcx, %rax
	movl	%edx, %ecx
	movq	%rax, %r8
	salq	%cl, %r8
	movq	%r8, %rcx
	xorq	%rcx, %rax
	movl	%edx, %ecx
	movq	%rax, %r9
	salq	%cl, %r9
	movq	%r9, %rcx
	xorq	%rcx, %rax
	movl	%edx, %ecx
	movq	%rax, %r10
	salq	%cl, %r10
	movq	%r10, %rcx
	xorq	%rcx, %rax
	movl	%edx, %ecx
	movq	%rax, %r11
	salq	%cl, %r11
	movq	%r11, %rcx
	xorq	%rcx, %rax
	movl	%edx, %ecx
	movq	%rax, %r8
	salq	%cl, %r8
	movq	%r8, %rcx
	xorq	%rcx, %rax
	movl	%edx, %ecx
	movq	%rax, %r9
	salq	%cl, %r9
	movq	%r9, %rcx
	xorq	%rcx, %rax
	movl	%edx, %ecx
	movq	%rax, %r10
	salq	%cl, %r10
	movq	%r10, %rcx
	xorq	%rcx, %rax
	movl	%edx, %ecx
	movq	%rax, %r11
	salq	%cl, %r11
	movq	%r11, %rcx
	xorq	%rcx, %rax
	movl	%edx, %ecx
	movq	%rax, %r8
	salq	%cl, %r8
	movq	%r8, %rcx
	xorq	%rcx, %rax
	movl	%edx, %ecx
	movq	%rax, %r9
	salq	%cl, %r9
	movq	%r9, %rcx
	xorq	%rcx, %rax
	movl	%edx, %ecx
	movq	%rax, %r10
	salq	%cl, %r10
	movq	%r10, %rcx
	xorq	%rcx, %rax
	movl	%edx, %ecx
	movq	%rax, %r11
	salq	%cl, %r11
	movq	%r11, %rcx
	xorq	%rcx, %rax
	movl	%edx, %ecx
	movq	%rax, %r8
	salq	%cl, %r8
	movq	%r8, %rcx
	xorq	%rcx, %rax
	movl	%edx, %ecx
	movq	%rax, %r9
	salq	%cl, %r9
	movq	%r9, %rcx
	xorq	%rcx, %rax
	movl	%edx, %ecx
	movq	%rax, %r10
	salq	%cl, %r10
	movq	%r10, %rcx
	xorq	%rcx, %rax
	movl	%edx, %ecx
	movq	%rax, %r11
	salq	%cl, %r11
	movq	%r11, %rcx
	xorq	%rcx, %rax
	movl	%edx, %ecx
	movq	%rax, %r8
	salq	%cl, %r8
	movq	%r8, %rcx
	xorq	%rcx, %rax
	movl	%edx, %ecx
	movq	%rax, %r9
	salq	%cl, %r9
	movq	%r9, %rcx
	xorq	%rcx, %rax
	movl	%edx, %ecx
	movq	%rax, %r10
	salq	%cl, %r10
	movq	%r10, %rcx
	xorq	%rcx, %rax
	movl	%edx, %ecx
	movq	%rax, %r11
	salq	%cl, %r11
	movq	%r11, %rcx
	xorq	%rcx, %rax
	movl	%edx, %ecx
	movq	%rax, %r8
	salq	%cl, %r8
	movq	%r8, %rcx
	xorq	%rcx, %rax
	movl	%edx, %ecx
	movq	%rax, %r9
	salq	%cl, %r9
	movq	%r9, %rcx
	xorq	%rcx, %rax
	movl	%edx, %ecx
	movq	%rax, %r10
	salq	%cl, %r10
	movq	%r10, %rcx
	xorq	%rcx, %rax
	movl	%edx, %ecx
	movq	%rax, %r11
	salq	%cl, %r11
	movq	%r11, %rcx
	xorq	%rcx, %rax
	movl	%edx, %ecx
	movq	%rax, %r8
	salq	%cl, %r8
	movq	%r8, %rcx
	xorq	%rcx, %rax
	movl	%edx, %ecx
	movq	%rax, %r9
	salq	%cl, %r9
	movq	%r9, %rcx
	xorq	%rcx, %rax
	movl	%edx, %ecx
	movq	%rax, %r10
	salq	%cl, %r10
	movq	%r10, %rcx
	xorq	%rcx, %rax
	movl	%edx, %ecx
	movq	%rax, %r11
	salq	%cl, %r11
	movq	%r11, %rcx
	xorq	%rcx, %rax
	movl	%edx, %ecx
	movq	%rax, %r8
	salq	%cl, %r8
	movq	%r8, %rcx
	xorq	%rcx, %rax
	movl	%edx, %ecx
	movq	%rax, %r9
	salq	%cl, %r9
	movq	%r9, %rcx
	xorq	%rcx, %rax
	movl	%edx, %ecx
	movq	%rax, %r10
	salq	%cl, %r10
	movq	%r10, %rcx
	xorq	%rcx, %rax
	movl	%edx, %ecx
	movq	%rax, %r11
	salq	%cl, %r11
	movq	%r11, %rcx
	xorq	%rcx, %rax
	movl	%edx, %ecx
	movq	%rax, %r8
	salq	%cl, %r8
	movq	%r8, %rcx
	xorq	%rcx, %rax
	movl	%edx, %ecx
	movq	%rax, %r9
	salq	%cl, %r9
	movq	%r9, %rcx
	xorq	%rcx, %rax
	movl	%edx, %ecx
	movq	%rax, %r10
	salq	%cl, %r10
	movq	%r10, %rcx
	xorq	%rcx, %rax
	movl	%edx, %ecx
	movq	%rax, %r11
	salq	%cl, %r11
	movq	%r11, %rcx
	xorq	%rcx, %rax
	movl	%edx, %ecx
	movq	%rax, %r8
	salq	%cl, %r8
	movq	%r8, %rcx
	xorq	%rcx, %rax
	movl	%edx, %ecx
	movq	%rax, %r9
	salq	%cl, %r9
	movq	%r9, %rcx
	xorq	%rcx, %rax
	movl	%edx, %ecx
	movq	%rax, %r10
	salq	%cl, %r10
	movq	%r10, %rcx
	xorq	%rcx, %rax
	movl	%edx, %ecx
	movq	%rax, %r11
	salq	%cl, %r11
	movq	%r11, %rcx
	xorq	%rcx, %rax
	movl	%edx, %ecx
	movq	%rax, %r8
	salq	%cl, %r8
	movq	%r8, %rcx
	xorq	%rcx, %rax
	movl	%edx, %ecx
	movq	%rax, %r9
	salq	%cl, %r9
	movq	%r9, %rcx
	xorq	%rcx, %rax
	movl	%edx, %ecx
	movq	%rax, %r10
	salq	%cl, %r10
	movq	%r10, %rcx
	xorq	%rcx, %rax
	movl	%edx, %ecx
	movq	%rax, %r11
	salq	%cl, %r11
	movq	%r11, %rcx
	xorq	%rcx, %rax
	subq	$1, %rdi
.L209:
	testq	%rdi, %rdi
	jg	.L210
	movq	%rax, %rcx
	movq	%rdx, %rax
	addq	%rcx, %rax
	salq	$3, %rax
	addq	%rsi, %rax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE24:
	.size	_mhz_6, .-_mhz_6
	.globl	mhz_6
	.type	mhz_6, @function
mhz_6:
.LFB25:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$112, %rsp
	movl	%edi, -84(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movq	$1, -40(%rbp)
	leaq	-72(%rbp), %rax
	movq	%rax, -72(%rbp)
	movq	-72(%rbp), %rax
	movq	%rax, -32(%rbp)
	movq	$0, -64(%rbp)
	movq	-32(%rbp), %rax
	movl	$1, %ecx
	movl	$1, %edx
	movq	%rax, %rsi
	movl	$1, %edi
	call	_mhz_6
	movl	-84(%rbp), %eax
	movl	%eax, %edi
	call	get_enough@PLT
	movl	%eax, -76(%rbp)
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -48(%rbp)
	jmp	.L213
.L228:
	movl	$0, %edi
	call	start@PLT
	movq	__iterations.3(%rip), %rax
	movq	%rax, -56(%rbp)
	jmp	.L214
.L215:
	movq	-56(%rbp), %rax
	movq	-40(%rbp), %rcx
	movq	-40(%rbp), %rdx
	movq	-32(%rbp), %rsi
	movq	%rax, %rdi
	call	_mhz_6
	movq	%rax, -64(%rbp)
	movq	$1, -56(%rbp)
	subq	$1, -56(%rbp)
.L214:
	cmpq	$0, -56(%rbp)
	jne	.L215
	movl	$0, %esi
	movl	$0, %edi
	call	stop@PLT
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
	movsd	%xmm0, -48(%rbp)
	pxor	%xmm1, %xmm1
	cvtsi2sdl	-76(%rbp), %xmm1
	movsd	.LC3(%rip), %xmm0
	mulsd	%xmm1, %xmm0
	comisd	-48(%rbp), %xmm0
	ja	.L218
	pxor	%xmm1, %xmm1
	cvtsi2sdl	-76(%rbp), %xmm1
	movsd	.LC4(%rip), %xmm0
	mulsd	%xmm0, %xmm1
	movsd	-48(%rbp), %xmm0
	comisd	%xmm1, %xmm0
	ja	.L218
	jmp	.L213
.L218:
	movsd	-48(%rbp), %xmm0
	comisd	.LC5(%rip), %xmm0
	jbe	.L245
	movq	__iterations.3(%rip), %rax
	testq	%rax, %rax
	js	.L222
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L223
.L222:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L223:
	divsd	-48(%rbp), %xmm0
	movsd	%xmm0, -24(%rbp)
	pxor	%xmm1, %xmm1
	cvtsi2sdl	-76(%rbp), %xmm1
	movsd	.LC6(%rip), %xmm0
	mulsd	%xmm1, %xmm0
	movsd	-24(%rbp), %xmm1
	mulsd	%xmm1, %xmm0
	movsd	%xmm0, -24(%rbp)
	movsd	-24(%rbp), %xmm1
	movsd	.LC7(%rip), %xmm0
	addsd	%xmm1, %xmm0
	comisd	.LC8(%rip), %xmm0
	jnb	.L224
	cvttsd2siq	%xmm0, %rax
	jmp	.L225
.L224:
	movsd	.LC8(%rip), %xmm1
	subsd	%xmm1, %xmm0
	cvttsd2siq	%xmm0, %rax
	movabsq	$-9223372036854775808, %rdx
	xorq	%rdx, %rax
.L225:
	movq	%rax, __iterations.3(%rip)
	jmp	.L213
.L245:
	movq	__iterations.3(%rip), %rax
	cmpq	$134217728, %rax
	jbe	.L226
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -48(%rbp)
	jmp	.L227
.L226:
	movq	__iterations.3(%rip), %rax
	salq	$3, %rax
	movq	%rax, __iterations.3(%rip)
.L213:
	pxor	%xmm1, %xmm1
	cvtsi2sdl	-76(%rbp), %xmm1
	movsd	.LC9(%rip), %xmm0
	mulsd	%xmm1, %xmm0
	comisd	-48(%rbp), %xmm0
	ja	.L228
.L227:
	movq	__iterations.3(%rip), %rax
	movq	%rax, %rdi
	call	save_n@PLT
	movsd	-48(%rbp), %xmm0
	comisd	.LC8(%rip), %xmm0
	jnb	.L229
	movsd	-48(%rbp), %xmm0
	cvttsd2siq	%xmm0, %rax
	jmp	.L230
.L229:
	movsd	-48(%rbp), %xmm0
	movsd	.LC8(%rip), %xmm1
	subsd	%xmm1, %xmm0
	cvttsd2siq	%xmm0, %rax
	movabsq	$-9223372036854775808, %rdx
	xorq	%rdx, %rax
.L230:
	movq	%rax, %rdi
	call	settime@PLT
	call	usecs_spent@PLT
	testq	%rax, %rax
	js	.L231
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L232
.L231:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L232:
	movsd	%xmm0, -16(%rbp)
	call	t_overhead@PLT
	testq	%rax, %rax
	js	.L233
	pxor	%xmm2, %xmm2
	cvtsi2sdq	%rax, %xmm2
	movsd	%xmm2, -96(%rbp)
	jmp	.L234
.L233:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
	movsd	%xmm0, -96(%rbp)
.L234:
	call	get_n@PLT
	testq	%rax, %rax
	js	.L235
	pxor	%xmm3, %xmm3
	cvtsi2sdq	%rax, %xmm3
	movsd	%xmm3, -104(%rbp)
	jmp	.L236
.L235:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
	movsd	%xmm0, -104(%rbp)
.L236:
	call	l_overhead@PLT
	mulsd	-104(%rbp), %xmm0
	movsd	-96(%rbp), %xmm1
	addsd	%xmm0, %xmm1
	movsd	-16(%rbp), %xmm0
	subsd	%xmm1, %xmm0
	movsd	%xmm0, -16(%rbp)
	movsd	-16(%rbp), %xmm0
	pxor	%xmm1, %xmm1
	comisd	%xmm1, %xmm0
	jb	.L246
	movsd	-16(%rbp), %xmm0
	comisd	.LC8(%rip), %xmm0
	jnb	.L239
	movsd	-16(%rbp), %xmm0
	cvttsd2siq	%xmm0, %rax
	jmp	.L241
.L239:
	movsd	-16(%rbp), %xmm0
	movsd	.LC8(%rip), %xmm1
	subsd	%xmm1, %xmm0
	cvttsd2siq	%xmm0, %rax
	movabsq	$-9223372036854775808, %rdx
	xorq	%rdx, %rax
	jmp	.L241
.L246:
	movl	$0, %eax
.L241:
	movq	%rax, %rdi
	call	settime@PLT
	movq	-64(%rbp), %rax
	movq	%rax, %rdi
	call	use_pointer@PLT
	call	get_n@PLT
	movq	%rax, %rdx
	movq	%rdx, %rax
	salq	$2, %rax
	addq	%rdx, %rax
	leaq	0(,%rax,4), %rdx
	addq	%rdx, %rax
	salq	$2, %rax
	movq	%rax, %rdi
	call	save_n@PLT
	movq	-8(%rbp), %rax
	subq	%fs:40, %rax
	je	.L242
	call	__stack_chk_fail@PLT
.L242:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE25:
	.size	mhz_6, .-mhz_6
	.section	.rodata
.LC15:
	.string	"a^=a+b;"
	.text
	.globl	name_7
	.type	name_7, @function
name_7:
.LFB26:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	leaq	.LC15(%rip), %rax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE26:
	.size	name_7, .-name_7
	.globl	_mhz_7
	.type	_mhz_7, @function
_mhz_7:
.LFB27:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdx, %rax
	movq	%rcx, %rdx
	jmp	.L250
.L251:
	leaq	(%rax,%rdx), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	xorq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	xorq	%rcx, %rax
	subq	$1, %rdi
.L250:
	testq	%rdi, %rdi
	jg	.L251
	movq	%rax, %rcx
	movq	%rdx, %rax
	addq	%rcx, %rax
	salq	$3, %rax
	addq	%rsi, %rax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE27:
	.size	_mhz_7, .-_mhz_7
	.globl	mhz_7
	.type	mhz_7, @function
mhz_7:
.LFB28:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$112, %rsp
	movl	%edi, -84(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movq	$1, -40(%rbp)
	leaq	-72(%rbp), %rax
	movq	%rax, -72(%rbp)
	movq	-72(%rbp), %rax
	movq	%rax, -32(%rbp)
	movq	$0, -64(%rbp)
	movq	-32(%rbp), %rax
	movl	$1, %ecx
	movl	$1, %edx
	movq	%rax, %rsi
	movl	$1, %edi
	call	_mhz_7
	movl	-84(%rbp), %eax
	movl	%eax, %edi
	call	get_enough@PLT
	movl	%eax, -76(%rbp)
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -48(%rbp)
	jmp	.L254
.L269:
	movl	$0, %edi
	call	start@PLT
	movq	__iterations.2(%rip), %rax
	movq	%rax, -56(%rbp)
	jmp	.L255
.L256:
	movq	-56(%rbp), %rax
	movq	-40(%rbp), %rcx
	movq	-40(%rbp), %rdx
	movq	-32(%rbp), %rsi
	movq	%rax, %rdi
	call	_mhz_7
	movq	%rax, -64(%rbp)
	movq	$1, -56(%rbp)
	subq	$1, -56(%rbp)
.L255:
	cmpq	$0, -56(%rbp)
	jne	.L256
	movl	$0, %esi
	movl	$0, %edi
	call	stop@PLT
	testq	%rax, %rax
	js	.L257
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L258
.L257:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L258:
	movsd	%xmm0, -48(%rbp)
	pxor	%xmm1, %xmm1
	cvtsi2sdl	-76(%rbp), %xmm1
	movsd	.LC3(%rip), %xmm0
	mulsd	%xmm1, %xmm0
	comisd	-48(%rbp), %xmm0
	ja	.L259
	pxor	%xmm1, %xmm1
	cvtsi2sdl	-76(%rbp), %xmm1
	movsd	.LC4(%rip), %xmm0
	mulsd	%xmm0, %xmm1
	movsd	-48(%rbp), %xmm0
	comisd	%xmm1, %xmm0
	ja	.L259
	jmp	.L254
.L259:
	movsd	-48(%rbp), %xmm0
	comisd	.LC5(%rip), %xmm0
	jbe	.L286
	movq	__iterations.2(%rip), %rax
	testq	%rax, %rax
	js	.L263
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L264
.L263:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L264:
	divsd	-48(%rbp), %xmm0
	movsd	%xmm0, -24(%rbp)
	pxor	%xmm1, %xmm1
	cvtsi2sdl	-76(%rbp), %xmm1
	movsd	.LC6(%rip), %xmm0
	mulsd	%xmm1, %xmm0
	movsd	-24(%rbp), %xmm1
	mulsd	%xmm1, %xmm0
	movsd	%xmm0, -24(%rbp)
	movsd	-24(%rbp), %xmm1
	movsd	.LC7(%rip), %xmm0
	addsd	%xmm1, %xmm0
	comisd	.LC8(%rip), %xmm0
	jnb	.L265
	cvttsd2siq	%xmm0, %rax
	jmp	.L266
.L265:
	movsd	.LC8(%rip), %xmm1
	subsd	%xmm1, %xmm0
	cvttsd2siq	%xmm0, %rax
	movabsq	$-9223372036854775808, %rdx
	xorq	%rdx, %rax
.L266:
	movq	%rax, __iterations.2(%rip)
	jmp	.L254
.L286:
	movq	__iterations.2(%rip), %rax
	cmpq	$134217728, %rax
	jbe	.L267
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -48(%rbp)
	jmp	.L268
.L267:
	movq	__iterations.2(%rip), %rax
	salq	$3, %rax
	movq	%rax, __iterations.2(%rip)
.L254:
	pxor	%xmm1, %xmm1
	cvtsi2sdl	-76(%rbp), %xmm1
	movsd	.LC9(%rip), %xmm0
	mulsd	%xmm1, %xmm0
	comisd	-48(%rbp), %xmm0
	ja	.L269
.L268:
	movq	__iterations.2(%rip), %rax
	movq	%rax, %rdi
	call	save_n@PLT
	movsd	-48(%rbp), %xmm0
	comisd	.LC8(%rip), %xmm0
	jnb	.L270
	movsd	-48(%rbp), %xmm0
	cvttsd2siq	%xmm0, %rax
	jmp	.L271
.L270:
	movsd	-48(%rbp), %xmm0
	movsd	.LC8(%rip), %xmm1
	subsd	%xmm1, %xmm0
	cvttsd2siq	%xmm0, %rax
	movabsq	$-9223372036854775808, %rdx
	xorq	%rdx, %rax
.L271:
	movq	%rax, %rdi
	call	settime@PLT
	call	usecs_spent@PLT
	testq	%rax, %rax
	js	.L272
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L273
.L272:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L273:
	movsd	%xmm0, -16(%rbp)
	call	t_overhead@PLT
	testq	%rax, %rax
	js	.L274
	pxor	%xmm2, %xmm2
	cvtsi2sdq	%rax, %xmm2
	movsd	%xmm2, -96(%rbp)
	jmp	.L275
.L274:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
	movsd	%xmm0, -96(%rbp)
.L275:
	call	get_n@PLT
	testq	%rax, %rax
	js	.L276
	pxor	%xmm3, %xmm3
	cvtsi2sdq	%rax, %xmm3
	movsd	%xmm3, -104(%rbp)
	jmp	.L277
.L276:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
	movsd	%xmm0, -104(%rbp)
.L277:
	call	l_overhead@PLT
	mulsd	-104(%rbp), %xmm0
	movsd	-96(%rbp), %xmm1
	addsd	%xmm0, %xmm1
	movsd	-16(%rbp), %xmm0
	subsd	%xmm1, %xmm0
	movsd	%xmm0, -16(%rbp)
	movsd	-16(%rbp), %xmm0
	pxor	%xmm1, %xmm1
	comisd	%xmm1, %xmm0
	jb	.L287
	movsd	-16(%rbp), %xmm0
	comisd	.LC8(%rip), %xmm0
	jnb	.L280
	movsd	-16(%rbp), %xmm0
	cvttsd2siq	%xmm0, %rax
	jmp	.L282
.L280:
	movsd	-16(%rbp), %xmm0
	movsd	.LC8(%rip), %xmm1
	subsd	%xmm1, %xmm0
	cvttsd2siq	%xmm0, %rax
	movabsq	$-9223372036854775808, %rdx
	xorq	%rdx, %rax
	jmp	.L282
.L287:
	movl	$0, %eax
.L282:
	movq	%rax, %rdi
	call	settime@PLT
	movq	-64(%rbp), %rax
	movq	%rax, %rdi
	call	use_pointer@PLT
	call	get_n@PLT
	movq	%rax, %rdx
	movq	%rdx, %rax
	salq	$2, %rax
	addq	%rdx, %rax
	leaq	0(,%rax,4), %rdx
	addq	%rdx, %rax
	salq	$2, %rax
	movq	%rax, %rdi
	call	save_n@PLT
	movq	-8(%rbp), %rax
	subq	%fs:40, %rax
	je	.L283
	call	__stack_chk_fail@PLT
.L283:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE28:
	.size	mhz_7, .-mhz_7
	.section	.rodata
.LC16:
	.string	"a+=(a+b)&07;"
	.text
	.globl	name_8
	.type	name_8, @function
name_8:
.LFB29:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	leaq	.LC16(%rip), %rax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE29:
	.size	name_8, .-name_8
	.globl	_mhz_8
	.type	_mhz_8, @function
_mhz_8:
.LFB30:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdx, %rax
	movq	%rcx, %rdx
	jmp	.L291
.L292:
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rcx, %rax
	leaq	(%rax,%rdx), %rcx
	andl	$7, %ecx
	addq	%rcx, %rax
	subq	$1, %rdi
.L291:
	testq	%rdi, %rdi
	jg	.L292
	movq	%rax, %rcx
	movq	%rdx, %rax
	addq	%rcx, %rax
	salq	$3, %rax
	addq	%rsi, %rax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE30:
	.size	_mhz_8, .-_mhz_8
	.globl	mhz_8
	.type	mhz_8, @function
mhz_8:
.LFB31:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$112, %rsp
	movl	%edi, -84(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movq	$1, -40(%rbp)
	leaq	-72(%rbp), %rax
	movq	%rax, -72(%rbp)
	movq	-72(%rbp), %rax
	movq	%rax, -32(%rbp)
	movq	$0, -64(%rbp)
	movq	-32(%rbp), %rax
	movl	$1, %ecx
	movl	$1, %edx
	movq	%rax, %rsi
	movl	$1, %edi
	call	_mhz_8
	movl	-84(%rbp), %eax
	movl	%eax, %edi
	call	get_enough@PLT
	movl	%eax, -76(%rbp)
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -48(%rbp)
	jmp	.L295
.L310:
	movl	$0, %edi
	call	start@PLT
	movq	__iterations.1(%rip), %rax
	movq	%rax, -56(%rbp)
	jmp	.L296
.L297:
	movq	-56(%rbp), %rax
	movq	-40(%rbp), %rcx
	movq	-40(%rbp), %rdx
	movq	-32(%rbp), %rsi
	movq	%rax, %rdi
	call	_mhz_8
	movq	%rax, -64(%rbp)
	movq	$1, -56(%rbp)
	subq	$1, -56(%rbp)
.L296:
	cmpq	$0, -56(%rbp)
	jne	.L297
	movl	$0, %esi
	movl	$0, %edi
	call	stop@PLT
	testq	%rax, %rax
	js	.L298
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L299
.L298:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L299:
	movsd	%xmm0, -48(%rbp)
	pxor	%xmm1, %xmm1
	cvtsi2sdl	-76(%rbp), %xmm1
	movsd	.LC3(%rip), %xmm0
	mulsd	%xmm1, %xmm0
	comisd	-48(%rbp), %xmm0
	ja	.L300
	pxor	%xmm1, %xmm1
	cvtsi2sdl	-76(%rbp), %xmm1
	movsd	.LC4(%rip), %xmm0
	mulsd	%xmm0, %xmm1
	movsd	-48(%rbp), %xmm0
	comisd	%xmm1, %xmm0
	ja	.L300
	jmp	.L295
.L300:
	movsd	-48(%rbp), %xmm0
	comisd	.LC5(%rip), %xmm0
	jbe	.L327
	movq	__iterations.1(%rip), %rax
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
	divsd	-48(%rbp), %xmm0
	movsd	%xmm0, -24(%rbp)
	pxor	%xmm1, %xmm1
	cvtsi2sdl	-76(%rbp), %xmm1
	movsd	.LC6(%rip), %xmm0
	mulsd	%xmm1, %xmm0
	movsd	-24(%rbp), %xmm1
	mulsd	%xmm1, %xmm0
	movsd	%xmm0, -24(%rbp)
	movsd	-24(%rbp), %xmm1
	movsd	.LC7(%rip), %xmm0
	addsd	%xmm1, %xmm0
	comisd	.LC8(%rip), %xmm0
	jnb	.L306
	cvttsd2siq	%xmm0, %rax
	jmp	.L307
.L306:
	movsd	.LC8(%rip), %xmm1
	subsd	%xmm1, %xmm0
	cvttsd2siq	%xmm0, %rax
	movabsq	$-9223372036854775808, %rdx
	xorq	%rdx, %rax
.L307:
	movq	%rax, __iterations.1(%rip)
	jmp	.L295
.L327:
	movq	__iterations.1(%rip), %rax
	cmpq	$134217728, %rax
	jbe	.L308
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -48(%rbp)
	jmp	.L309
.L308:
	movq	__iterations.1(%rip), %rax
	salq	$3, %rax
	movq	%rax, __iterations.1(%rip)
.L295:
	pxor	%xmm1, %xmm1
	cvtsi2sdl	-76(%rbp), %xmm1
	movsd	.LC9(%rip), %xmm0
	mulsd	%xmm1, %xmm0
	comisd	-48(%rbp), %xmm0
	ja	.L310
.L309:
	movq	__iterations.1(%rip), %rax
	movq	%rax, %rdi
	call	save_n@PLT
	movsd	-48(%rbp), %xmm0
	comisd	.LC8(%rip), %xmm0
	jnb	.L311
	movsd	-48(%rbp), %xmm0
	cvttsd2siq	%xmm0, %rax
	jmp	.L312
.L311:
	movsd	-48(%rbp), %xmm0
	movsd	.LC8(%rip), %xmm1
	subsd	%xmm1, %xmm0
	cvttsd2siq	%xmm0, %rax
	movabsq	$-9223372036854775808, %rdx
	xorq	%rdx, %rax
.L312:
	movq	%rax, %rdi
	call	settime@PLT
	call	usecs_spent@PLT
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
	movsd	%xmm0, -16(%rbp)
	call	t_overhead@PLT
	testq	%rax, %rax
	js	.L315
	pxor	%xmm2, %xmm2
	cvtsi2sdq	%rax, %xmm2
	movsd	%xmm2, -96(%rbp)
	jmp	.L316
.L315:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
	movsd	%xmm0, -96(%rbp)
.L316:
	call	get_n@PLT
	testq	%rax, %rax
	js	.L317
	pxor	%xmm3, %xmm3
	cvtsi2sdq	%rax, %xmm3
	movsd	%xmm3, -104(%rbp)
	jmp	.L318
.L317:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
	movsd	%xmm0, -104(%rbp)
.L318:
	call	l_overhead@PLT
	mulsd	-104(%rbp), %xmm0
	movsd	-96(%rbp), %xmm1
	addsd	%xmm0, %xmm1
	movsd	-16(%rbp), %xmm0
	subsd	%xmm1, %xmm0
	movsd	%xmm0, -16(%rbp)
	movsd	-16(%rbp), %xmm0
	pxor	%xmm1, %xmm1
	comisd	%xmm1, %xmm0
	jb	.L328
	movsd	-16(%rbp), %xmm0
	comisd	.LC8(%rip), %xmm0
	jnb	.L321
	movsd	-16(%rbp), %xmm0
	cvttsd2siq	%xmm0, %rax
	jmp	.L323
.L321:
	movsd	-16(%rbp), %xmm0
	movsd	.LC8(%rip), %xmm1
	subsd	%xmm1, %xmm0
	cvttsd2siq	%xmm0, %rax
	movabsq	$-9223372036854775808, %rdx
	xorq	%rdx, %rax
	jmp	.L323
.L328:
	movl	$0, %eax
.L323:
	movq	%rax, %rdi
	call	settime@PLT
	movq	-64(%rbp), %rax
	movq	%rax, %rdi
	call	use_pointer@PLT
	call	get_n@PLT
	movq	%rax, %rdx
	movq	%rdx, %rax
	salq	$2, %rax
	addq	%rdx, %rax
	leaq	0(,%rax,4), %rdx
	addq	%rdx, %rax
	salq	$2, %rax
	movq	%rax, %rdi
	call	save_n@PLT
	movq	-8(%rbp), %rax
	subq	%fs:40, %rax
	je	.L324
	call	__stack_chk_fail@PLT
.L324:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE31:
	.size	mhz_8, .-mhz_8
	.section	.rodata
.LC17:
	.string	"a^=n;b^=a;a|=b;"
	.text
	.globl	name_9
	.type	name_9, @function
name_9:
.LFB32:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	leaq	.LC17(%rip), %rax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE32:
	.size	name_9, .-name_9
	.globl	_mhz_9
	.type	_mhz_9, @function
_mhz_9:
.LFB33:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdx, %rax
	movq	%rcx, %rdx
	jmp	.L332
.L333:
	xorq	%rdi, %rax
	xorq	%rax, %rdx
	orq	%rdx, %rax
	xorq	%rdi, %rax
	xorq	%rax, %rdx
	orq	%rdx, %rax
	xorq	%rdi, %rax
	xorq	%rax, %rdx
	orq	%rdx, %rax
	xorq	%rdi, %rax
	xorq	%rax, %rdx
	orq	%rdx, %rax
	xorq	%rdi, %rax
	xorq	%rax, %rdx
	orq	%rdx, %rax
	xorq	%rdi, %rax
	xorq	%rax, %rdx
	orq	%rdx, %rax
	xorq	%rdi, %rax
	xorq	%rax, %rdx
	orq	%rdx, %rax
	xorq	%rdi, %rax
	xorq	%rax, %rdx
	orq	%rdx, %rax
	xorq	%rdi, %rax
	xorq	%rax, %rdx
	orq	%rdx, %rax
	xorq	%rdi, %rax
	xorq	%rax, %rdx
	orq	%rdx, %rax
	xorq	%rdi, %rax
	xorq	%rax, %rdx
	orq	%rdx, %rax
	xorq	%rdi, %rax
	xorq	%rax, %rdx
	orq	%rdx, %rax
	xorq	%rdi, %rax
	xorq	%rax, %rdx
	orq	%rdx, %rax
	xorq	%rdi, %rax
	xorq	%rax, %rdx
	orq	%rdx, %rax
	xorq	%rdi, %rax
	xorq	%rax, %rdx
	orq	%rdx, %rax
	xorq	%rdi, %rax
	xorq	%rax, %rdx
	orq	%rdx, %rax
	xorq	%rdi, %rax
	xorq	%rax, %rdx
	orq	%rdx, %rax
	xorq	%rdi, %rax
	xorq	%rax, %rdx
	orq	%rdx, %rax
	xorq	%rdi, %rax
	xorq	%rax, %rdx
	orq	%rdx, %rax
	xorq	%rdi, %rax
	xorq	%rax, %rdx
	orq	%rdx, %rax
	xorq	%rdi, %rax
	xorq	%rax, %rdx
	orq	%rdx, %rax
	xorq	%rdi, %rax
	xorq	%rax, %rdx
	orq	%rdx, %rax
	xorq	%rdi, %rax
	xorq	%rax, %rdx
	orq	%rdx, %rax
	xorq	%rdi, %rax
	xorq	%rax, %rdx
	orq	%rdx, %rax
	xorq	%rdi, %rax
	xorq	%rax, %rdx
	orq	%rdx, %rax
	xorq	%rdi, %rax
	xorq	%rax, %rdx
	orq	%rdx, %rax
	xorq	%rdi, %rax
	xorq	%rax, %rdx
	orq	%rdx, %rax
	xorq	%rdi, %rax
	xorq	%rax, %rdx
	orq	%rdx, %rax
	xorq	%rdi, %rax
	xorq	%rax, %rdx
	orq	%rdx, %rax
	xorq	%rdi, %rax
	xorq	%rax, %rdx
	orq	%rdx, %rax
	xorq	%rdi, %rax
	xorq	%rax, %rdx
	orq	%rdx, %rax
	xorq	%rdi, %rax
	xorq	%rax, %rdx
	orq	%rdx, %rax
	xorq	%rdi, %rax
	xorq	%rax, %rdx
	orq	%rdx, %rax
	xorq	%rdi, %rax
	xorq	%rax, %rdx
	orq	%rdx, %rax
	xorq	%rdi, %rax
	xorq	%rax, %rdx
	orq	%rdx, %rax
	xorq	%rdi, %rax
	xorq	%rax, %rdx
	orq	%rdx, %rax
	xorq	%rdi, %rax
	xorq	%rax, %rdx
	orq	%rdx, %rax
	xorq	%rdi, %rax
	xorq	%rax, %rdx
	orq	%rdx, %rax
	xorq	%rdi, %rax
	xorq	%rax, %rdx
	orq	%rdx, %rax
	xorq	%rdi, %rax
	xorq	%rax, %rdx
	orq	%rdx, %rax
	xorq	%rdi, %rax
	xorq	%rax, %rdx
	orq	%rdx, %rax
	xorq	%rdi, %rax
	xorq	%rax, %rdx
	orq	%rdx, %rax
	xorq	%rdi, %rax
	xorq	%rax, %rdx
	orq	%rdx, %rax
	xorq	%rdi, %rax
	xorq	%rax, %rdx
	orq	%rdx, %rax
	xorq	%rdi, %rax
	xorq	%rax, %rdx
	orq	%rdx, %rax
	xorq	%rdi, %rax
	xorq	%rax, %rdx
	orq	%rdx, %rax
	xorq	%rdi, %rax
	xorq	%rax, %rdx
	orq	%rdx, %rax
	xorq	%rdi, %rax
	xorq	%rax, %rdx
	orq	%rdx, %rax
	xorq	%rdi, %rax
	xorq	%rax, %rdx
	orq	%rdx, %rax
	xorq	%rdi, %rax
	xorq	%rax, %rdx
	orq	%rdx, %rax
	xorq	%rdi, %rax
	xorq	%rax, %rdx
	orq	%rdx, %rax
	xorq	%rdi, %rax
	xorq	%rax, %rdx
	orq	%rdx, %rax
	xorq	%rdi, %rax
	xorq	%rax, %rdx
	orq	%rdx, %rax
	xorq	%rdi, %rax
	xorq	%rax, %rdx
	orq	%rdx, %rax
	xorq	%rdi, %rax
	xorq	%rax, %rdx
	orq	%rdx, %rax
	xorq	%rdi, %rax
	xorq	%rax, %rdx
	orq	%rdx, %rax
	xorq	%rdi, %rax
	xorq	%rax, %rdx
	orq	%rdx, %rax
	xorq	%rdi, %rax
	xorq	%rax, %rdx
	orq	%rdx, %rax
	xorq	%rdi, %rax
	xorq	%rax, %rdx
	orq	%rdx, %rax
	xorq	%rdi, %rax
	xorq	%rax, %rdx
	orq	%rdx, %rax
	xorq	%rdi, %rax
	xorq	%rax, %rdx
	orq	%rdx, %rax
	xorq	%rdi, %rax
	xorq	%rax, %rdx
	orq	%rdx, %rax
	xorq	%rdi, %rax
	xorq	%rax, %rdx
	orq	%rdx, %rax
	xorq	%rdi, %rax
	xorq	%rax, %rdx
	orq	%rdx, %rax
	xorq	%rdi, %rax
	xorq	%rax, %rdx
	orq	%rdx, %rax
	xorq	%rdi, %rax
	xorq	%rax, %rdx
	orq	%rdx, %rax
	xorq	%rdi, %rax
	xorq	%rax, %rdx
	orq	%rdx, %rax
	xorq	%rdi, %rax
	xorq	%rax, %rdx
	orq	%rdx, %rax
	xorq	%rdi, %rax
	xorq	%rax, %rdx
	orq	%rdx, %rax
	xorq	%rdi, %rax
	xorq	%rax, %rdx
	orq	%rdx, %rax
	xorq	%rdi, %rax
	xorq	%rax, %rdx
	orq	%rdx, %rax
	xorq	%rdi, %rax
	xorq	%rax, %rdx
	orq	%rdx, %rax
	xorq	%rdi, %rax
	xorq	%rax, %rdx
	orq	%rdx, %rax
	xorq	%rdi, %rax
	xorq	%rax, %rdx
	orq	%rdx, %rax
	xorq	%rdi, %rax
	xorq	%rax, %rdx
	orq	%rdx, %rax
	xorq	%rdi, %rax
	xorq	%rax, %rdx
	orq	%rdx, %rax
	xorq	%rdi, %rax
	xorq	%rax, %rdx
	orq	%rdx, %rax
	xorq	%rdi, %rax
	xorq	%rax, %rdx
	orq	%rdx, %rax
	xorq	%rdi, %rax
	xorq	%rax, %rdx
	orq	%rdx, %rax
	xorq	%rdi, %rax
	xorq	%rax, %rdx
	orq	%rdx, %rax
	xorq	%rdi, %rax
	xorq	%rax, %rdx
	orq	%rdx, %rax
	xorq	%rdi, %rax
	xorq	%rax, %rdx
	orq	%rdx, %rax
	xorq	%rdi, %rax
	xorq	%rax, %rdx
	orq	%rdx, %rax
	xorq	%rdi, %rax
	xorq	%rax, %rdx
	orq	%rdx, %rax
	xorq	%rdi, %rax
	xorq	%rax, %rdx
	orq	%rdx, %rax
	xorq	%rdi, %rax
	xorq	%rax, %rdx
	orq	%rdx, %rax
	xorq	%rdi, %rax
	xorq	%rax, %rdx
	orq	%rdx, %rax
	xorq	%rdi, %rax
	xorq	%rax, %rdx
	orq	%rdx, %rax
	xorq	%rdi, %rax
	xorq	%rax, %rdx
	orq	%rdx, %rax
	xorq	%rdi, %rax
	xorq	%rax, %rdx
	orq	%rdx, %rax
	xorq	%rdi, %rax
	xorq	%rax, %rdx
	orq	%rdx, %rax
	xorq	%rdi, %rax
	xorq	%rax, %rdx
	orq	%rdx, %rax
	xorq	%rdi, %rax
	xorq	%rax, %rdx
	orq	%rdx, %rax
	xorq	%rdi, %rax
	xorq	%rax, %rdx
	orq	%rdx, %rax
	xorq	%rdi, %rax
	xorq	%rax, %rdx
	orq	%rdx, %rax
	xorq	%rdi, %rax
	xorq	%rax, %rdx
	orq	%rdx, %rax
	xorq	%rdi, %rax
	xorq	%rax, %rdx
	orq	%rdx, %rax
	xorq	%rdi, %rax
	xorq	%rax, %rdx
	orq	%rdx, %rax
	xorq	%rdi, %rax
	xorq	%rax, %rdx
	orq	%rdx, %rax
	xorq	%rdi, %rax
	xorq	%rax, %rdx
	orq	%rdx, %rax
	subq	$1, %rdi
.L332:
	testq	%rdi, %rdi
	jg	.L333
	movq	%rax, %rcx
	movq	%rdx, %rax
	addq	%rcx, %rax
	salq	$3, %rax
	addq	%rsi, %rax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE33:
	.size	_mhz_9, .-_mhz_9
	.globl	mhz_9
	.type	mhz_9, @function
mhz_9:
.LFB34:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$112, %rsp
	movl	%edi, -84(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movq	$1, -40(%rbp)
	leaq	-72(%rbp), %rax
	movq	%rax, -72(%rbp)
	movq	-72(%rbp), %rax
	movq	%rax, -32(%rbp)
	movq	$0, -64(%rbp)
	movq	-32(%rbp), %rax
	movl	$1, %ecx
	movl	$1, %edx
	movq	%rax, %rsi
	movl	$1, %edi
	call	_mhz_9
	movl	-84(%rbp), %eax
	movl	%eax, %edi
	call	get_enough@PLT
	movl	%eax, -76(%rbp)
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -48(%rbp)
	jmp	.L336
.L351:
	movl	$0, %edi
	call	start@PLT
	movq	__iterations.0(%rip), %rax
	movq	%rax, -56(%rbp)
	jmp	.L337
.L338:
	movq	-56(%rbp), %rax
	movq	-40(%rbp), %rcx
	movq	-40(%rbp), %rdx
	movq	-32(%rbp), %rsi
	movq	%rax, %rdi
	call	_mhz_9
	movq	%rax, -64(%rbp)
	movq	$1, -56(%rbp)
	subq	$1, -56(%rbp)
.L337:
	cmpq	$0, -56(%rbp)
	jne	.L338
	movl	$0, %esi
	movl	$0, %edi
	call	stop@PLT
	testq	%rax, %rax
	js	.L339
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L340
.L339:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L340:
	movsd	%xmm0, -48(%rbp)
	pxor	%xmm1, %xmm1
	cvtsi2sdl	-76(%rbp), %xmm1
	movsd	.LC3(%rip), %xmm0
	mulsd	%xmm1, %xmm0
	comisd	-48(%rbp), %xmm0
	ja	.L341
	pxor	%xmm1, %xmm1
	cvtsi2sdl	-76(%rbp), %xmm1
	movsd	.LC4(%rip), %xmm0
	mulsd	%xmm0, %xmm1
	movsd	-48(%rbp), %xmm0
	comisd	%xmm1, %xmm0
	ja	.L341
	jmp	.L336
.L341:
	movsd	-48(%rbp), %xmm0
	comisd	.LC5(%rip), %xmm0
	jbe	.L368
	movq	__iterations.0(%rip), %rax
	testq	%rax, %rax
	js	.L345
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L346
.L345:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L346:
	divsd	-48(%rbp), %xmm0
	movsd	%xmm0, -24(%rbp)
	pxor	%xmm1, %xmm1
	cvtsi2sdl	-76(%rbp), %xmm1
	movsd	.LC6(%rip), %xmm0
	mulsd	%xmm1, %xmm0
	movsd	-24(%rbp), %xmm1
	mulsd	%xmm1, %xmm0
	movsd	%xmm0, -24(%rbp)
	movsd	-24(%rbp), %xmm1
	movsd	.LC7(%rip), %xmm0
	addsd	%xmm1, %xmm0
	comisd	.LC8(%rip), %xmm0
	jnb	.L347
	cvttsd2siq	%xmm0, %rax
	jmp	.L348
.L347:
	movsd	.LC8(%rip), %xmm1
	subsd	%xmm1, %xmm0
	cvttsd2siq	%xmm0, %rax
	movabsq	$-9223372036854775808, %rdx
	xorq	%rdx, %rax
.L348:
	movq	%rax, __iterations.0(%rip)
	jmp	.L336
.L368:
	movq	__iterations.0(%rip), %rax
	cmpq	$134217728, %rax
	jbe	.L349
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -48(%rbp)
	jmp	.L350
.L349:
	movq	__iterations.0(%rip), %rax
	salq	$3, %rax
	movq	%rax, __iterations.0(%rip)
.L336:
	pxor	%xmm1, %xmm1
	cvtsi2sdl	-76(%rbp), %xmm1
	movsd	.LC9(%rip), %xmm0
	mulsd	%xmm1, %xmm0
	comisd	-48(%rbp), %xmm0
	ja	.L351
.L350:
	movq	__iterations.0(%rip), %rax
	movq	%rax, %rdi
	call	save_n@PLT
	movsd	-48(%rbp), %xmm0
	comisd	.LC8(%rip), %xmm0
	jnb	.L352
	movsd	-48(%rbp), %xmm0
	cvttsd2siq	%xmm0, %rax
	jmp	.L353
.L352:
	movsd	-48(%rbp), %xmm0
	movsd	.LC8(%rip), %xmm1
	subsd	%xmm1, %xmm0
	cvttsd2siq	%xmm0, %rax
	movabsq	$-9223372036854775808, %rdx
	xorq	%rdx, %rax
.L353:
	movq	%rax, %rdi
	call	settime@PLT
	call	usecs_spent@PLT
	testq	%rax, %rax
	js	.L354
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L355
.L354:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L355:
	movsd	%xmm0, -16(%rbp)
	call	t_overhead@PLT
	testq	%rax, %rax
	js	.L356
	pxor	%xmm2, %xmm2
	cvtsi2sdq	%rax, %xmm2
	movsd	%xmm2, -96(%rbp)
	jmp	.L357
.L356:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
	movsd	%xmm0, -96(%rbp)
.L357:
	call	get_n@PLT
	testq	%rax, %rax
	js	.L358
	pxor	%xmm3, %xmm3
	cvtsi2sdq	%rax, %xmm3
	movsd	%xmm3, -104(%rbp)
	jmp	.L359
.L358:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
	movsd	%xmm0, -104(%rbp)
.L359:
	call	l_overhead@PLT
	mulsd	-104(%rbp), %xmm0
	movsd	-96(%rbp), %xmm1
	addsd	%xmm0, %xmm1
	movsd	-16(%rbp), %xmm0
	subsd	%xmm1, %xmm0
	movsd	%xmm0, -16(%rbp)
	movsd	-16(%rbp), %xmm0
	pxor	%xmm1, %xmm1
	comisd	%xmm1, %xmm0
	jb	.L369
	movsd	-16(%rbp), %xmm0
	comisd	.LC8(%rip), %xmm0
	jnb	.L362
	movsd	-16(%rbp), %xmm0
	cvttsd2siq	%xmm0, %rax
	jmp	.L364
.L362:
	movsd	-16(%rbp), %xmm0
	movsd	.LC8(%rip), %xmm1
	subsd	%xmm1, %xmm0
	cvttsd2siq	%xmm0, %rax
	movabsq	$-9223372036854775808, %rdx
	xorq	%rdx, %rax
	jmp	.L364
.L369:
	movl	$0, %eax
.L364:
	movq	%rax, %rdi
	call	settime@PLT
	movq	-64(%rbp), %rax
	movq	%rax, %rdi
	call	use_pointer@PLT
	call	get_n@PLT
	movq	%rax, %rdx
	movq	%rdx, %rax
	salq	$2, %rax
	addq	%rdx, %rax
	leaq	0(,%rax,4), %rdx
	addq	%rdx, %rax
	salq	$2, %rax
	movq	%rax, %rdi
	call	save_n@PLT
	movq	-8(%rbp), %rax
	subq	%fs:40, %rax
	je	.L365
	call	__stack_chk_fail@PLT
.L365:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE34:
	.size	mhz_9, .-mhz_9
	.globl	loops
	.section	.data.rel.local
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
	.text
	.globl	filter_data
	.type	filter_data, @function
filter_data:
.LFB35:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$48, %rsp
	movq	%rdi, -40(%rbp)
	movl	%esi, -44(%rbp)
	movl	-44(%rbp), %eax
	addl	$1, %eax
	cltq
	salq	$3, %rax
	movq	%rax, %rdi
	call	malloc@PLT
	movq	%rax, -8(%rbp)
	movl	$0, -24(%rbp)
	jmp	.L371
.L372:
	movl	-24(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-40(%rbp), %rax
	addq	%rax, %rdx
	movl	-24(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rcx
	movq	-8(%rbp), %rax
	addq	%rcx, %rax
	movsd	(%rdx), %xmm0
	movsd	%xmm0, (%rax)
	addl	$1, -24(%rbp)
.L371:
	movl	-24(%rbp), %eax
	cmpl	-44(%rbp), %eax
	jl	.L372
	movl	-44(%rbp), %eax
	movslq	%eax, %rsi
	movq	-8(%rbp), %rax
	movq	double_compare@GOTPCREL(%rip), %rdx
	movq	%rdx, %rcx
	movl	$8, %edx
	movq	%rax, %rdi
	call	qsort@PLT
	movl	-44(%rbp), %eax
	movl	%eax, %edx
	shrl	$31, %edx
	addl	%edx, %eax
	sarl	%eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-8(%rbp), %rax
	addq	%rdx, %rax
	movsd	(%rax), %xmm0
	movsd	%xmm0, -16(%rbp)
	cmpl	$0, -44(%rbp)
	jle	.L373
	movl	-44(%rbp), %eax
	andl	$1, %eax
	testl	%eax, %eax
	jne	.L373
	movl	-44(%rbp), %eax
	movl	%eax, %edx
	shrl	$31, %edx
	addl	%edx, %eax
	sarl	%eax
	cltq
	salq	$3, %rax
	leaq	-8(%rax), %rdx
	movq	-8(%rbp), %rax
	addq	%rdx, %rax
	movsd	(%rax), %xmm0
	addsd	-16(%rbp), %xmm0
	movsd	.LC18(%rip), %xmm1
	divsd	%xmm1, %xmm0
	movsd	%xmm0, -16(%rbp)
.L373:
	movq	-8(%rbp), %rax
	movq	%rax, %rdi
	call	free@PLT
	movl	$0, -24(%rbp)
	movl	$0, -20(%rbp)
	jmp	.L374
.L379:
	movsd	-16(%rbp), %xmm1
	movsd	.LC19(%rip), %xmm0
	mulsd	%xmm0, %xmm1
	movl	-24(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-40(%rbp), %rax
	addq	%rdx, %rax
	movsd	(%rax), %xmm0
	comisd	%xmm1, %xmm0
	jbe	.L375
	movl	-24(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-40(%rbp), %rax
	addq	%rdx, %rax
	movsd	(%rax), %xmm1
	movsd	-16(%rbp), %xmm2
	movsd	.LC20(%rip), %xmm0
	mulsd	%xmm2, %xmm0
	comisd	%xmm1, %xmm0
	jbe	.L375
	movl	-24(%rbp), %eax
	cmpl	-20(%rbp), %eax
	jle	.L378
	movl	-24(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-40(%rbp), %rax
	addq	%rax, %rdx
	movl	-20(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rcx
	movq	-40(%rbp), %rax
	addq	%rcx, %rax
	movsd	(%rdx), %xmm0
	movsd	%xmm0, (%rax)
.L378:
	addl	$1, -20(%rbp)
.L375:
	addl	$1, -24(%rbp)
.L374:
	movl	-24(%rbp), %eax
	cmpl	-44(%rbp), %eax
	jl	.L379
	movl	-20(%rbp), %eax
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE35:
	.size	filter_data, .-filter_data
	.globl	classes
	.type	classes, @function
classes:
.LFB36:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$48, %rsp
	movq	%rdi, -40(%rbp)
	movl	%esi, -44(%rbp)
	movl	-44(%rbp), %eax
	cltq
	salq	$3, %rax
	movq	%rax, %rdi
	call	malloc@PLT
	movq	%rax, -8(%rbp)
	movl	$0, -24(%rbp)
	jmp	.L384
.L385:
	movl	-24(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-40(%rbp), %rax
	addq	%rax, %rdx
	movl	-24(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rcx
	movq	-8(%rbp), %rax
	addq	%rcx, %rax
	movsd	(%rdx), %xmm0
	movsd	%xmm0, (%rax)
	addl	$1, -24(%rbp)
.L384:
	movl	-24(%rbp), %eax
	cmpl	-44(%rbp), %eax
	jl	.L385
	movl	-44(%rbp), %eax
	movslq	%eax, %rsi
	movq	-8(%rbp), %rax
	movq	double_compare@GOTPCREL(%rip), %rdx
	movq	%rdx, %rcx
	movl	$8, %edx
	movq	%rax, %rdi
	call	qsort@PLT
	movl	-44(%rbp), %eax
	movl	%eax, %edx
	shrl	$31, %edx
	addl	%edx, %eax
	sarl	%eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-8(%rbp), %rax
	addq	%rdx, %rax
	movsd	(%rax), %xmm0
	movsd	%xmm0, -16(%rbp)
	movl	-44(%rbp), %eax
	andl	$1, %eax
	testl	%eax, %eax
	jne	.L386
	movl	-44(%rbp), %eax
	movl	%eax, %edx
	shrl	$31, %edx
	addl	%edx, %eax
	sarl	%eax
	cltq
	salq	$3, %rax
	leaq	-8(%rax), %rdx
	movq	-8(%rbp), %rax
	addq	%rdx, %rax
	movsd	(%rax), %xmm0
	addsd	-16(%rbp), %xmm0
	movsd	.LC18(%rip), %xmm1
	divsd	%xmm1, %xmm0
	movsd	%xmm0, -16(%rbp)
.L386:
	movl	$1, -24(%rbp)
	movl	$1, -20(%rbp)
	jmp	.L387
.L390:
	movl	-24(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-8(%rbp), %rax
	addq	%rdx, %rax
	movsd	(%rax), %xmm0
	movl	-24(%rbp), %eax
	cltq
	salq	$3, %rax
	leaq	-8(%rax), %rdx
	movq	-8(%rbp), %rax
	addq	%rdx, %rax
	movsd	(%rax), %xmm1
	subsd	%xmm1, %xmm0
	movsd	-16(%rbp), %xmm2
	movsd	.LC19(%rip), %xmm1
	mulsd	%xmm2, %xmm1
	comisd	%xmm1, %xmm0
	jbe	.L388
	addl	$1, -20(%rbp)
.L388:
	addl	$1, -24(%rbp)
.L387:
	movl	-24(%rbp), %eax
	cmpl	-44(%rbp), %eax
	jl	.L390
	movq	-8(%rbp), %rax
	movq	%rax, %rdi
	call	free@PLT
	movl	-20(%rbp), %eax
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE36:
	.size	classes, .-classes
	.globl	mode
	.type	mode, @function
mode:
.LFB37:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$48, %rsp
	movq	%rdi, -40(%rbp)
	movl	%esi, -44(%rbp)
	movl	-44(%rbp), %eax
	movslq	%eax, %rsi
	movq	-40(%rbp), %rax
	movq	double_compare@GOTPCREL(%rip), %rdx
	movq	%rdx, %rcx
	movl	$8, %edx
	movq	%rax, %rdi
	call	qsort@PLT
	movl	$1, -20(%rbp)
	movl	$1, -16(%rbp)
	movq	-40(%rbp), %rax
	movsd	(%rax), %xmm1
	movsd	.LC21(%rip), %xmm0
	addsd	%xmm1, %xmm0
	cvttsd2sil	%xmm0, %eax
	movl	%eax, -12(%rbp)
	movq	-40(%rbp), %rax
	movsd	(%rax), %xmm1
	movsd	.LC21(%rip), %xmm0
	addsd	%xmm1, %xmm0
	cvttsd2sil	%xmm0, %eax
	movl	%eax, -8(%rbp)
	movl	$1, -24(%rbp)
	jmp	.L394
.L397:
	movl	-24(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-40(%rbp), %rax
	addq	%rdx, %rax
	movsd	(%rax), %xmm1
	movsd	.LC21(%rip), %xmm0
	addsd	%xmm1, %xmm0
	cvttsd2sil	%xmm0, %eax
	movl	%eax, -4(%rbp)
	movl	-8(%rbp), %eax
	cmpl	-4(%rbp), %eax
	je	.L395
	movl	-4(%rbp), %eax
	movl	%eax, -8(%rbp)
	movl	$0, -16(%rbp)
.L395:
	addl	$1, -16(%rbp)
	movl	-16(%rbp), %eax
	cmpl	-20(%rbp), %eax
	jle	.L396
	movl	-8(%rbp), %eax
	movl	%eax, -12(%rbp)
	movl	-16(%rbp), %eax
	movl	%eax, -20(%rbp)
.L396:
	addl	$1, -24(%rbp)
.L394:
	movl	-24(%rbp), %eax
	cmpl	-44(%rbp), %eax
	jl	.L397
	movl	-12(%rbp), %eax
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE37:
	.size	mode, .-mode
	.globl	cross_values
	.type	cross_values, @function
cross_values:
.LFB38:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$48, %rsp
	movq	%rdi, -24(%rbp)
	movl	%esi, -28(%rbp)
	movq	%rdx, -40(%rbp)
	movq	%rcx, -48(%rbp)
	movl	-28(%rbp), %eax
	imull	%eax, %eax
	cltq
	salq	$3, %rax
	movq	%rax, %rdi
	call	malloc@PLT
	movq	%rax, %rdx
	movq	-40(%rbp), %rax
	movq	%rdx, (%rax)
	movq	-48(%rbp), %rax
	movl	$0, (%rax)
	movl	$0, -8(%rbp)
	jmp	.L400
.L406:
	movl	-8(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-24(%rbp), %rax
	leaq	(%rdx,%rax), %rsi
	movq	-40(%rbp), %rax
	movq	(%rax), %rdi
	movq	-48(%rbp), %rax
	movl	(%rax), %eax
	leal	1(%rax), %ecx
	movq	-48(%rbp), %rdx
	movl	%ecx, (%rdx)
	cltq
	salq	$3, %rax
	addq	%rdi, %rax
	movsd	(%rsi), %xmm0
	movsd	%xmm0, (%rax)
	movl	-8(%rbp), %eax
	addl	$1, %eax
	movl	%eax, -4(%rbp)
	jmp	.L401
.L405:
	movl	-8(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movsd	(%rax), %xmm0
	movl	-4(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movsd	(%rax), %xmm2
	movapd	%xmm0, %xmm1
	subsd	%xmm2, %xmm1
	pxor	%xmm0, %xmm0
	comisd	%xmm1, %xmm0
	jbe	.L408
	movl	-8(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movsd	(%rax), %xmm0
	movl	-4(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movsd	(%rax), %xmm1
	subsd	%xmm1, %xmm0
	movq	.LC22(%rip), %xmm1
	xorpd	%xmm1, %xmm0
	jmp	.L404
.L408:
	movl	-8(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movsd	(%rax), %xmm0
	movl	-4(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movsd	(%rax), %xmm1
	subsd	%xmm1, %xmm0
.L404:
	movq	-40(%rbp), %rax
	movq	(%rax), %rsi
	movq	-48(%rbp), %rax
	movl	(%rax), %eax
	leal	1(%rax), %ecx
	movq	-48(%rbp), %rdx
	movl	%ecx, (%rdx)
	cltq
	salq	$3, %rax
	addq	%rsi, %rax
	movsd	%xmm0, (%rax)
	addl	$1, -4(%rbp)
.L401:
	movl	-4(%rbp), %eax
	cmpl	-28(%rbp), %eax
	jl	.L405
	addl	$1, -8(%rbp)
.L400:
	movl	-8(%rbp), %eax
	cmpl	-28(%rbp), %eax
	jl	.L406
	nop
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE38:
	.size	cross_values, .-cross_values
	.globl	gcd
	.type	gcd, @function
gcd:
.LFB39:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	addq	$-128, %rsp
	movq	%rdi, -120(%rbp)
	movl	%esi, -124(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -32(%rbp)
	movl	-124(%rbp), %eax
	imull	%eax, %eax
	cltq
	salq	$3, %rax
	movq	%rax, %rdi
	call	malloc@PLT
	movq	%rax, -24(%rbp)
	movl	-124(%rbp), %edx
	movq	-120(%rbp), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	double_min@PLT
	movq	%xmm0, %rax
	movq	%rax, -16(%rbp)
	movsd	-16(%rbp), %xmm0
	movsd	%xmm0, -40(%rbp)
	leaq	-104(%rbp), %rcx
	leaq	-48(%rbp), %rdx
	movl	-124(%rbp), %esi
	movq	-120(%rbp), %rax
	movq	%rax, %rdi
	call	cross_values
	movq	-48(%rbp), %rcx
	movl	-104(%rbp), %eax
	leal	1(%rax), %edx
	movl	%edx, -104(%rbp)
	cltq
	salq	$3, %rax
	addq	%rcx, %rax
	pxor	%xmm0, %xmm0
	movsd	%xmm0, (%rax)
	movl	$1, -96(%rbp)
	jmp	.L410
.L416:
	movl	$0, -100(%rbp)
	jmp	.L411
.L412:
	pxor	%xmm1, %xmm1
	cvtsi2sdl	-96(%rbp), %xmm1
	movq	-48(%rbp), %rdx
	movl	-100(%rbp), %eax
	cltq
	salq	$3, %rax
	addq	%rdx, %rax
	movsd	(%rax), %xmm0
	mulsd	%xmm1, %xmm0
	movapd	%xmm0, %xmm1
	divsd	-16(%rbp), %xmm1
	movsd	.LC21(%rip), %xmm0
	addsd	%xmm1, %xmm0
	cvttsd2sil	%xmm0, %eax
	movl	%eax, -92(%rbp)
	movl	-100(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	pxor	%xmm0, %xmm0
	cvtsi2sdl	-92(%rbp), %xmm0
	movsd	%xmm0, (%rax)
	addl	$1, -100(%rbp)
.L411:
	movl	-104(%rbp), %eax
	cmpl	%eax, -100(%rbp)
	jl	.L412
	movl	-104(%rbp), %edx
	movq	-48(%rbp), %rsi
	leaq	-80(%rbp), %r8
	leaq	-88(%rbp), %rdi
	movq	-24(%rbp), %rax
	subq	$8, %rsp
	leaq	-56(%rbp), %rcx
	pushq	%rcx
	leaq	-64(%rbp), %rcx
	pushq	%rcx
	leaq	-72(%rbp), %rcx
	pushq	%rcx
	movq	%r8, %r9
	movq	%rdi, %r8
	movl	%edx, %ecx
	movl	$0, %edx
	movq	%rax, %rdi
	call	regression@PLT
	addq	$32, %rsp
	cmpl	$1, -96(%rbp)
	je	.L413
	movl	-96(%rbp), %eax
	imull	%eax, %eax
	pxor	%xmm1, %xmm1
	cvtsi2sdl	%eax, %xmm1
	movsd	-56(%rbp), %xmm0
	mulsd	%xmm0, %xmm1
	movsd	-32(%rbp), %xmm0
	comisd	%xmm1, %xmm0
	jbe	.L414
.L413:
	movsd	-80(%rbp), %xmm0
	movsd	%xmm0, -40(%rbp)
	movsd	-56(%rbp), %xmm0
	movsd	%xmm0, -32(%rbp)
.L414:
	addl	$1, -96(%rbp)
.L410:
	cmpl	$5, -96(%rbp)
	jle	.L416
	movq	-24(%rbp), %rax
	movq	%rax, %rdi
	call	free@PLT
	movq	-48(%rbp), %rax
	movq	%rax, %rdi
	call	free@PLT
	movsd	-40(%rbp), %xmm0
	movq	%xmm0, %rax
	movq	-8(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L418
	call	__stack_chk_fail@PLT
.L418:
	movq	%rax, %xmm0
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE39:
	.size	gcd, .-gcd
	.globl	compute_mhz
	.type	compute_mhz, @function
compute_mhz:
.LFB40:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$4096, %rsp
	orq	$0, (%rsp)
	subq	$144, %rsp
	movq	%rdi, -4232(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movl	$0, -4220(%rbp)
	jmp	.L420
.L433:
	movl	$0, -4208(%rbp)
	movl	$0, -4204(%rbp)
	jmp	.L421
.L432:
	movl	$0, -4216(%rbp)
	movl	$0, -4212(%rbp)
	jmp	.L422
.L428:
	movl	-4216(%rbp), %eax
	movl	-4208(%rbp), %edx
	movl	%eax, %ecx
	sarl	%cl, %edx
	movl	%edx, %eax
	andl	$1, %eax
	testl	%eax, %eax
	je	.L423
	movl	-4216(%rbp), %eax
	cltq
	imulq	$184, %rax, %rdx
	movq	-4232(%rbp), %rax
	addq	%rdx, %rax
	movl	(%rax), %eax
	cmpl	$5, %eax
	jle	.L423
	movl	-4216(%rbp), %eax
	cltq
	imulq	$184, %rax, %rdx
	movq	-4232(%rbp), %rax
	leaq	(%rdx,%rax), %rcx
	movl	-4216(%rbp), %eax
	cltq
	imulq	$184, %rax, %rdx
	movq	-4232(%rbp), %rax
	addq	%rdx, %rax
	movl	(%rax), %eax
	subl	$1, %eax
	subl	-4220(%rbp), %eax
	cltq
	salq	$4, %rax
	addq	%rcx, %rax
	addq	$8, %rax
	movq	(%rax), %rax
	testq	%rax, %rax
	js	.L424
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L425
.L424:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L425:
	movl	-4216(%rbp), %eax
	cltq
	imulq	$184, %rax, %rdx
	movq	-4232(%rbp), %rax
	leaq	(%rdx,%rax), %rcx
	movl	-4216(%rbp), %eax
	cltq
	imulq	$184, %rax, %rdx
	movq	-4232(%rbp), %rax
	addq	%rdx, %rax
	movl	(%rax), %eax
	subl	$1, %eax
	subl	-4220(%rbp), %eax
	cltq
	salq	$4, %rax
	addq	%rcx, %rax
	addq	$16, %rax
	movq	(%rax), %rax
	testq	%rax, %rax
	js	.L426
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rax, %xmm1
	jmp	.L427
.L426:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rdx, %xmm1
	addsd	%xmm1, %xmm1
.L427:
	movl	-4212(%rbp), %eax
	leal	1(%rax), %edx
	movl	%edx, -4212(%rbp)
	divsd	%xmm1, %xmm0
	cltq
	movsd	%xmm0, -4192(%rbp,%rax,8)
.L423:
	addl	$1, -4216(%rbp)
.L422:
	movl	-4216(%rbp), %eax
	cmpl	$8, %eax
	jbe	.L428
	cmpl	$1, -4212(%rbp)
	jle	.L441
	movl	-4212(%rbp), %edx
	leaq	-4192(%rbp), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	filter_data
	movl	%eax, -4212(%rbp)
	cmpl	$1, -4212(%rbp)
	jle	.L441
	movl	-4212(%rbp), %edx
	leaq	-4192(%rbp), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	classes
	cmpl	$1, %eax
	jle	.L441
	movl	-4212(%rbp), %edx
	leaq	-4192(%rbp), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	gcd
	movapd	%xmm0, %xmm1
	movl	-4204(%rbp), %eax
	leal	1(%rax), %edx
	movl	%edx, -4204(%rbp)
	movsd	.LC7(%rip), %xmm0
	divsd	%xmm1, %xmm0
	cltq
	movsd	%xmm0, -4112(%rbp,%rax,8)
	jmp	.L431
.L441:
	nop
.L431:
	addl	$1, -4208(%rbp)
.L421:
	cmpl	$511, -4208(%rbp)
	jle	.L432
	movl	-4204(%rbp), %edx
	leaq	-4112(%rbp), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	mode
	movl	-4220(%rbp), %edx
	movslq	%edx, %rdx
	movl	%eax, -4200(%rbp,%rdx,4)
	addl	$1, -4220(%rbp)
.L420:
	cmpl	$1, -4220(%rbp)
	jle	.L433
	movl	-4200(%rbp), %eax
	movl	-4196(%rbp), %edx
	subl	%edx, %eax
	testl	%eax, %eax
	jns	.L434
	movl	-4196(%rbp), %eax
	movl	-4200(%rbp), %edx
	subl	%edx, %eax
	pxor	%xmm0, %xmm0
	cvtsi2sdl	%eax, %xmm0
	jmp	.L435
.L434:
	movl	-4200(%rbp), %eax
	movl	-4196(%rbp), %edx
	subl	%edx, %eax
	pxor	%xmm0, %xmm0
	cvtsi2sdl	%eax, %xmm0
.L435:
	movl	-4200(%rbp), %eax
	pxor	%xmm2, %xmm2
	cvtsi2sdl	%eax, %xmm2
	movapd	%xmm0, %xmm1
	divsd	%xmm2, %xmm1
	movsd	.LC23(%rip), %xmm0
	comisd	%xmm1, %xmm0
	jnb	.L436
	movl	-4200(%rbp), %eax
	movl	-4196(%rbp), %edx
	subl	%edx, %eax
	cmpl	$-1, %eax
	jl	.L437
	movl	-4200(%rbp), %eax
	movl	-4196(%rbp), %edx
	subl	%edx, %eax
	cmpl	$1, %eax
	jg	.L437
.L436:
	movl	-4200(%rbp), %eax
	jmp	.L439
.L437:
	movl	$-1, %eax
.L439:
	movq	-8(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L440
	call	__stack_chk_fail@PLT
.L440:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE40:
	.size	compute_mhz, .-compute_mhz
	.globl	save_data
	.type	save_data, @function
save_data:
.LFB41:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%rbx
	.cfi_offset 3, -24
	movq	%rdi, -32(%rbp)
	movq	%rsi, -40(%rbp)
	movl	$0, -12(%rbp)
	jmp	.L443
.L444:
	movl	-12(%rbp), %eax
	cltq
	imulq	$184, %rax, %rdx
	movq	-32(%rbp), %rax
	addq	%rax, %rdx
	movl	-12(%rbp), %eax
	cltq
	imulq	$184, %rax, %rcx
	movq	-40(%rbp), %rax
	addq	%rcx, %rax
	movq	(%rdx), %rcx
	movq	8(%rdx), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	16(%rdx), %rcx
	movq	24(%rdx), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	32(%rdx), %rcx
	movq	40(%rdx), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	movq	48(%rdx), %rcx
	movq	56(%rdx), %rbx
	movq	%rcx, 48(%rax)
	movq	%rbx, 56(%rax)
	movq	64(%rdx), %rcx
	movq	72(%rdx), %rbx
	movq	%rcx, 64(%rax)
	movq	%rbx, 72(%rax)
	movq	80(%rdx), %rcx
	movq	88(%rdx), %rbx
	movq	%rcx, 80(%rax)
	movq	%rbx, 88(%rax)
	movq	96(%rdx), %rcx
	movq	104(%rdx), %rbx
	movq	%rcx, 96(%rax)
	movq	%rbx, 104(%rax)
	movq	112(%rdx), %rcx
	movq	120(%rdx), %rbx
	movq	%rcx, 112(%rax)
	movq	%rbx, 120(%rax)
	movq	128(%rdx), %rcx
	movq	136(%rdx), %rbx
	movq	%rcx, 128(%rax)
	movq	%rbx, 136(%rax)
	movq	144(%rdx), %rcx
	movq	152(%rdx), %rbx
	movq	%rcx, 144(%rax)
	movq	%rbx, 152(%rax)
	movq	160(%rdx), %rcx
	movq	168(%rdx), %rbx
	movq	%rcx, 160(%rax)
	movq	%rbx, 168(%rax)
	movq	176(%rdx), %rdx
	movq	%rdx, 176(%rax)
	addl	$1, -12(%rbp)
.L443:
	movl	-12(%rbp), %eax
	cmpl	$8, %eax
	jbe	.L444
	nop
	nop
	movq	-8(%rbp), %rbx
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE41:
	.size	save_data, .-save_data
	.section	.rodata
.LC24:
	.string	"CPU"
.LC25:
	.string	"uname"
.LC26:
	.string	"email"
	.align 8
.LC27:
	.string	"/* \"%s\", \"%s\", \"%s\", %d, %.0f, %d, %f, %lu */\n"
.LC28:
	.string	"result_t* data[] = { "
.LC29:
	.string	"\t/* %s */ { %d, {"
.LC31:
	.string	"\n\t\t{ /* %f */ %lu, %lu}"
.LC32:
	.string	", "
.LC33:
	.string	"}},"
.LC34:
	.string	"}}"
.LC35:
	.string	"};"
	.text
	.globl	print_data
	.type	print_data, @function
print_data:
.LFB42:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r12
	pushq	%rbx
	subq	$144, %rsp
	.cfi_offset 12, -24
	.cfi_offset 3, -32
	movsd	%xmm0, -152(%rbp)
	movq	%rdi, -160(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -24(%rbp)
	xorl	%eax, %eax
	leaq	.LC24(%rip), %rax
	movq	%rax, -120(%rbp)
	leaq	.LC25(%rip), %rax
	movq	%rax, -112(%rbp)
	leaq	.LC26(%rip), %rax
	movq	%rax, -104(%rbp)
	movl	$-1, -124(%rbp)
	movl	$0, %eax
	call	name_1
	movq	%rax, -96(%rbp)
	movl	$0, %eax
	call	name_2
	movq	%rax, -88(%rbp)
	movl	$0, %eax
	call	name_3
	movq	%rax, -80(%rbp)
	movl	$0, %eax
	call	name_4
	movq	%rax, -72(%rbp)
	movl	$0, %eax
	call	name_5
	movq	%rax, -64(%rbp)
	movl	$0, %eax
	call	name_6
	movq	%rax, -56(%rbp)
	movl	$0, %eax
	call	name_7
	movq	%rax, -48(%rbp)
	movl	$0, %eax
	call	name_8
	movq	%rax, -40(%rbp)
	movl	$0, %eax
	call	name_9
	movq	%rax, -32(%rbp)
	call	t_overhead@PLT
	movq	%rax, %rbx
	call	l_overhead@PLT
	movq	%xmm0, %r12
	movl	$0, %edi
	call	get_enough@PLT
	movl	%eax, %edi
	movq	-152(%rbp), %rsi
	movl	-124(%rbp), %r8d
	movq	-104(%rbp), %rcx
	movq	-112(%rbp), %rdx
	movq	-120(%rbp), %rax
	subq	$8, %rsp
	pushq	%rbx
	movq	%r12, %xmm1
	movl	%edi, %r9d
	movq	%rsi, %xmm0
	movq	%rax, %rsi
	leaq	.LC27(%rip), %rax
	movq	%rax, %rdi
	movl	$2, %eax
	call	printf@PLT
	addq	$16, %rsp
	leaq	.LC28(%rip), %rax
	movq	%rax, %rdi
	call	puts@PLT
	movl	$0, -132(%rbp)
	jmp	.L446
.L456:
	movl	-132(%rbp), %eax
	cltq
	imulq	$184, %rax, %rdx
	movq	-160(%rbp), %rax
	addq	%rdx, %rax
	movl	(%rax), %edx
	movl	-132(%rbp), %eax
	cltq
	movq	-96(%rbp,%rax,8), %rax
	movq	%rax, %rsi
	leaq	.LC29(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf@PLT
	movl	$0, -128(%rbp)
	jmp	.L447
.L453:
	movl	-132(%rbp), %eax
	cltq
	imulq	$184, %rax, %rdx
	movq	-160(%rbp), %rax
	addq	%rax, %rdx
	movl	-128(%rbp), %eax
	cltq
	salq	$4, %rax
	addq	%rdx, %rax
	addq	$16, %rax
	movq	(%rax), %rsi
	movl	-132(%rbp), %eax
	cltq
	imulq	$184, %rax, %rdx
	movq	-160(%rbp), %rax
	addq	%rax, %rdx
	movl	-128(%rbp), %eax
	cltq
	salq	$4, %rax
	addq	%rdx, %rax
	addq	$8, %rax
	movq	(%rax), %rcx
	movl	-132(%rbp), %eax
	cltq
	imulq	$184, %rax, %rdx
	movq	-160(%rbp), %rax
	addq	%rax, %rdx
	movl	-128(%rbp), %eax
	cltq
	salq	$4, %rax
	addq	%rdx, %rax
	addq	$8, %rax
	movq	(%rax), %rax
	testq	%rax, %rax
	js	.L448
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L449
.L448:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L449:
	movl	-132(%rbp), %eax
	cltq
	imulq	$184, %rax, %rdx
	movq	-160(%rbp), %rax
	addq	%rax, %rdx
	movl	-128(%rbp), %eax
	cltq
	salq	$4, %rax
	addq	%rdx, %rax
	addq	$16, %rax
	movq	(%rax), %rax
	testq	%rax, %rax
	js	.L450
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rax, %xmm1
	jmp	.L451
.L450:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rdx, %xmm1
	addsd	%xmm1, %xmm1
.L451:
	movsd	.LC30(%rip), %xmm2
	mulsd	%xmm2, %xmm1
	divsd	%xmm1, %xmm0
	movq	%xmm0, %rax
	movq	%rsi, %rdx
	movq	%rcx, %rsi
	movq	%rax, %xmm0
	leaq	.LC31(%rip), %rax
	movq	%rax, %rdi
	movl	$1, %eax
	call	printf@PLT
	cmpl	$9, -128(%rbp)
	jg	.L452
	leaq	.LC32(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf@PLT
.L452:
	addl	$1, -128(%rbp)
.L447:
	movl	-132(%rbp), %eax
	cltq
	imulq	$184, %rax, %rdx
	movq	-160(%rbp), %rax
	addq	%rdx, %rax
	movl	(%rax), %eax
	cmpl	%eax, -128(%rbp)
	jl	.L453
	movl	-132(%rbp), %eax
	cmpl	$7, %eax
	ja	.L454
	leaq	.LC33(%rip), %rax
	movq	%rax, %rdi
	call	puts@PLT
	jmp	.L455
.L454:
	leaq	.LC34(%rip), %rax
	movq	%rax, %rdi
	call	puts@PLT
.L455:
	addl	$1, -132(%rbp)
.L446:
	movl	-132(%rbp), %eax
	cmpl	$8, %eax
	jbe	.L456
	leaq	.LC35(%rip), %rax
	movq	%rax, %rdi
	call	puts@PLT
	nop
	movq	-24(%rbp), %rax
	subq	%fs:40, %rax
	je	.L457
	call	__stack_chk_fail@PLT
.L457:
	leaq	-16(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE42:
	.size	print_data, .-print_data
	.section	.rodata
.LC36:
	.string	"[-d] [-c]\n"
.LC37:
	.string	"LOOP_O=0.0"
	.align 8
.LC40:
	.string	"mhz: should take approximately %.0f seconds\n"
.LC42:
	.string	"%.4f\n"
.LC43:
	.string	"cd"
.LC44:
	.string	"-1 System too busy"
.LC45:
	.string	"%d MHz, %.4f nanosec clock\n"
	.text
	.globl	main
	.type	main, @function
main:
.LFB43:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r12
	pushq	%rbx
	subq	$3392, %rsp
	.cfi_offset 12, -24
	.cfi_offset 3, -32
	movl	%edi, -3396(%rbp)
	movq	%rsi, -3408(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -24(%rbp)
	xorl	%eax, %eax
	movl	$-1, -3368(%rbp)
	leaq	.LC36(%rip), %rax
	movq	%rax, -3360(%rbp)
	leaq	.LC37(%rip), %rax
	movq	%rax, %rdi
	call	putenv@PLT
	movl	$0, %edi
	call	get_enough@PLT
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$3, %rax
	addq	%rdx, %rax
	movq	%rax, %rdx
	salq	$5, %rdx
	addq	%rdx, %rax
	testq	%rax, %rax
	js	.L459
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L460
.L459:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L460:
	movsd	.LC38(%rip), %xmm1
	divsd	%xmm1, %xmm0
	movsd	%xmm0, -3352(%rbp)
	movsd	-3352(%rbp), %xmm0
	comisd	.LC39(%rip), %xmm0
	jbe	.L461
	movq	stderr(%rip), %rax
	movq	-3352(%rbp), %rdx
	movq	%rdx, %xmm0
	leaq	.LC40(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	movl	$1, %eax
	call	fprintf@PLT
.L461:
	movl	$0, -3380(%rbp)
	jmp	.L463
.L471:
	movl	$0, -3376(%rbp)
	jmp	.L464
.L465:
	leaq	-3344(%rbp), %rdx
	movl	-3376(%rbp), %eax
	cltq
	imulq	$184, %rax, %rax
	addq	%rdx, %rax
	movq	%rax, %rdi
	call	insertinit@PLT
	addl	$1, -3376(%rbp)
.L464:
	movl	-3376(%rbp), %eax
	cmpl	$8, %eax
	jbe	.L465
	movl	$0, -3376(%rbp)
	jmp	.L466
.L469:
	movl	$0, -3372(%rbp)
	jmp	.L467
.L468:
	movl	-3372(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	leaq	loops(%rip), %rax
	movq	(%rdx,%rax), %rax
	movl	$0, %edi
	call	*%rax
	leaq	-3344(%rbp), %rdx
	movl	-3372(%rbp), %eax
	cltq
	imulq	$184, %rax, %rax
	leaq	(%rdx,%rax), %rbx
	call	get_n@PLT
	movq	%rax, %r12
	call	usecs_spent@PLT
	movq	%rbx, %rdx
	movq	%r12, %rsi
	movq	%rax, %rdi
	call	insertsort@PLT
	addl	$1, -3372(%rbp)
.L467:
	movl	-3372(%rbp), %eax
	cmpl	$8, %eax
	jbe	.L468
	addl	$1, -3376(%rbp)
.L466:
	cmpl	$10, -3376(%rbp)
	jle	.L469
	leaq	-1680(%rbp), %rdx
	leaq	-3344(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	save_data
	leaq	-3344(%rbp), %rax
	movq	%rax, %rdi
	call	compute_mhz
	movl	%eax, -3368(%rbp)
	addl	$1, -3380(%rbp)
.L463:
	cmpl	$2, -3380(%rbp)
	jg	.L472
	cmpl	$0, -3368(%rbp)
	js	.L471
	jmp	.L472
.L477:
	cmpl	$99, -3364(%rbp)
	je	.L473
	cmpl	$100, -3364(%rbp)
	je	.L474
	jmp	.L482
.L473:
	cmpl	$0, -3368(%rbp)
	jle	.L472
	pxor	%xmm1, %xmm1
	cvtsi2sdl	-3368(%rbp), %xmm1
	movsd	.LC41(%rip), %xmm0
	divsd	%xmm1, %xmm0
	movq	%xmm0, %rax
	movq	%rax, %xmm0
	leaq	.LC42(%rip), %rax
	movq	%rax, %rdi
	movl	$1, %eax
	call	printf@PLT
	movl	$0, -3368(%rbp)
	jmp	.L472
.L474:
	pxor	%xmm2, %xmm2
	cvtsi2sdl	-3368(%rbp), %xmm2
	movq	%xmm2, %rax
	leaq	-1680(%rbp), %rdx
	movq	%rdx, %rdi
	movq	%rax, %xmm0
	call	print_data
	jmp	.L472
.L482:
	movq	-3360(%rbp), %rdx
	movq	-3408(%rbp), %rcx
	movl	-3396(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	lmbench_usage@PLT
	nop
.L472:
	movq	-3408(%rbp), %rcx
	movl	-3396(%rbp), %eax
	leaq	.LC43(%rip), %rdx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	mygetopt@PLT
	movl	%eax, -3364(%rbp)
	cmpl	$-1, -3364(%rbp)
	jne	.L477
	cmpl	$0, -3368(%rbp)
	jns	.L478
	leaq	.LC44(%rip), %rax
	movq	%rax, %rdi
	call	puts@PLT
	movl	$1, %edi
	call	exit@PLT
.L478:
	cmpl	$0, -3368(%rbp)
	jle	.L479
	pxor	%xmm1, %xmm1
	cvtsi2sdl	-3368(%rbp), %xmm1
	movsd	.LC41(%rip), %xmm0
	divsd	%xmm1, %xmm0
	movq	%xmm0, %rdx
	movl	-3368(%rbp), %eax
	movq	%rdx, %xmm0
	movl	%eax, %esi
	leaq	.LC45(%rip), %rax
	movq	%rax, %rdi
	movl	$1, %eax
	call	printf@PLT
.L479:
	movl	$0, %edi
	call	exit@PLT
	.cfi_endproc
.LFE43:
	.size	main, .-main
	.data
	.align 8
	.type	__iterations.8, @object
	.size	__iterations.8, 8
__iterations.8:
	.quad	1
	.align 8
	.type	__iterations.7, @object
	.size	__iterations.7, 8
__iterations.7:
	.quad	1
	.align 8
	.type	__iterations.6, @object
	.size	__iterations.6, 8
__iterations.6:
	.quad	1
	.align 8
	.type	__iterations.5, @object
	.size	__iterations.5, 8
__iterations.5:
	.quad	1
	.align 8
	.type	__iterations.4, @object
	.size	__iterations.4, 8
__iterations.4:
	.quad	1
	.align 8
	.type	__iterations.3, @object
	.size	__iterations.3, 8
__iterations.3:
	.quad	1
	.align 8
	.type	__iterations.2, @object
	.size	__iterations.2, 8
__iterations.2:
	.quad	1
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
.LC9:
	.long	1717986918
	.long	1072588390
	.align 8
.LC18:
	.long	0
	.long	1073741824
	.align 8
.LC19:
	.long	-1717986918
	.long	1068079513
	.align 8
.LC20:
	.long	0
	.long	1077149696
	.align 8
.LC21:
	.long	0
	.long	1071644672
	.align 16
.LC22:
	.long	0
	.long	-2147483648
	.long	0
	.long	0
	.align 8
.LC23:
	.long	1202590843
	.long	1065646817
	.align 8
.LC30:
	.long	0
	.long	1079574528
	.align 8
.LC38:
	.long	0
	.long	1093567616
	.align 8
.LC39:
	.long	0
	.long	1074266112
	.align 8
.LC41:
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
