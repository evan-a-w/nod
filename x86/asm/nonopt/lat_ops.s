	.file	"lat_ops.c"
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
	.string	"malloc"
	.text
	.globl	float_initialize
	.type	float_initialize, @function
float_initialize:
.LFB8:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r12
	pushq	%rbx
	subq	$32, %rsp
	.cfi_offset 12, -24
	.cfi_offset 3, -32
	movq	%rdi, -40(%rbp)
	movq	%rsi, -48(%rbp)
	movq	-48(%rbp), %rax
	movq	%rax, -24(%rbp)
	cmpq	$0, -40(%rbp)
	jne	.L7
	movq	-24(%rbp), %rax
	movl	4(%rax), %eax
	cltq
	salq	$2, %rax
	movq	%rax, %rdi
	call	malloc@PLT
	movq	%rax, %r12
	movq	-24(%rbp), %rax
	movq	%r12, 16(%rax)
	movq	-24(%rbp), %rax
	movq	16(%rax), %rax
	testq	%rax, %rax
	jne	.L4
	leaq	.LC1(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L4:
	movl	$0, %ebx
	jmp	.L5
.L6:
	movslq	%ebx, %rax
	salq	$2, %rax
	addq	%r12, %rax
	movss	.LC2(%rip), %xmm0
	movss	%xmm0, (%rax)
	addl	$1, %ebx
.L5:
	movq	-24(%rbp), %rax
	movl	4(%rax), %eax
	cmpl	%eax, %ebx
	jl	.L6
	jmp	.L1
.L7:
	nop
.L1:
	addq	$32, %rsp
	popq	%rbx
	popq	%r12
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE8:
	.size	float_initialize, .-float_initialize
	.globl	double_initialize
	.type	double_initialize, @function
double_initialize:
.LFB9:
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
	movq	%rdi, -40(%rbp)
	movq	%rsi, -48(%rbp)
	movq	-48(%rbp), %rax
	movq	%rax, -24(%rbp)
	cmpq	$0, -40(%rbp)
	jne	.L14
	movq	-24(%rbp), %rax
	movl	4(%rax), %eax
	cltq
	salq	$3, %rax
	movq	%rax, %rdi
	call	malloc@PLT
	movq	%rax, %rdx
	movq	-24(%rbp), %rax
	movq	%rdx, 16(%rax)
	movq	-24(%rbp), %rax
	movq	16(%rax), %rax
	testq	%rax, %rax
	jne	.L11
	leaq	.LC1(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L11:
	movl	$0, %ebx
	jmp	.L12
.L13:
	movq	-24(%rbp), %rax
	movq	16(%rax), %rdx
	movslq	%ebx, %rax
	salq	$3, %rax
	addq	%rdx, %rax
	movsd	.LC3(%rip), %xmm0
	movsd	%xmm0, (%rax)
	addl	$1, %ebx
.L12:
	movq	-24(%rbp), %rax
	movl	4(%rax), %eax
	cmpl	%eax, %ebx
	jl	.L13
	jmp	.L8
.L14:
	nop
.L8:
	movq	-8(%rbp), %rbx
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE9:
	.size	double_initialize, .-double_initialize
	.globl	cleanup
	.type	cleanup, @function
cleanup:
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
	jne	.L18
	movq	-8(%rbp), %rax
	movq	16(%rax), %rax
	testq	%rax, %rax
	je	.L15
	movq	-8(%rbp), %rax
	movq	16(%rax), %rax
	movq	%rax, %rdi
	call	free@PLT
	jmp	.L15
.L18:
	nop
.L15:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE10:
	.size	cleanup, .-cleanup
	.globl	do_integer_bitwise
	.type	do_integer_bitwise, @function
do_integer_bitwise:
.LFB11:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r12
	pushq	%rbx
	subq	$32, %rsp
	.cfi_offset 12, -24
	.cfi_offset 3, -32
	movq	%rdi, -40(%rbp)
	movq	%rsi, -48(%rbp)
	movq	-48(%rbp), %rax
	movq	%rax, -24(%rbp)
	movq	-24(%rbp), %rax
	movl	(%rax), %ebx
	movq	-40(%rbp), %rax
	movl	%eax, %r12d
	jmp	.L20
.L21:
	movq	-40(%rbp), %rax
	movl	%eax, %edx
	movl	%ebx, %eax
	xorl	%edx, %eax
	movl	%eax, %ebx
	xorl	%ebx, %r12d
	orl	%r12d, %ebx
	movq	-40(%rbp), %rax
	movl	%eax, %edx
	movl	%ebx, %eax
	xorl	%edx, %eax
	movl	%eax, %ebx
	xorl	%ebx, %r12d
	orl	%r12d, %ebx
	movq	-40(%rbp), %rax
	movl	%eax, %edx
	movl	%ebx, %eax
	xorl	%edx, %eax
	movl	%eax, %ebx
	xorl	%ebx, %r12d
	orl	%r12d, %ebx
	movq	-40(%rbp), %rax
	movl	%eax, %edx
	movl	%ebx, %eax
	xorl	%edx, %eax
	movl	%eax, %ebx
	xorl	%ebx, %r12d
	orl	%r12d, %ebx
	movq	-40(%rbp), %rax
	movl	%eax, %edx
	movl	%ebx, %eax
	xorl	%edx, %eax
	movl	%eax, %ebx
	xorl	%ebx, %r12d
	orl	%r12d, %ebx
	movq	-40(%rbp), %rax
	movl	%eax, %edx
	movl	%ebx, %eax
	xorl	%edx, %eax
	movl	%eax, %ebx
	xorl	%ebx, %r12d
	orl	%r12d, %ebx
	movq	-40(%rbp), %rax
	movl	%eax, %edx
	movl	%ebx, %eax
	xorl	%edx, %eax
	movl	%eax, %ebx
	xorl	%ebx, %r12d
	orl	%r12d, %ebx
	movq	-40(%rbp), %rax
	movl	%eax, %edx
	movl	%ebx, %eax
	xorl	%edx, %eax
	movl	%eax, %ebx
	xorl	%ebx, %r12d
	orl	%r12d, %ebx
	movq	-40(%rbp), %rax
	movl	%eax, %edx
	movl	%ebx, %eax
	xorl	%edx, %eax
	movl	%eax, %ebx
	xorl	%ebx, %r12d
	orl	%r12d, %ebx
	movq	-40(%rbp), %rax
	movl	%eax, %edx
	movl	%ebx, %eax
	xorl	%edx, %eax
	movl	%eax, %ebx
	xorl	%ebx, %r12d
	orl	%r12d, %ebx
	movq	-40(%rbp), %rax
	movl	%eax, %edx
	movl	%ebx, %eax
	xorl	%edx, %eax
	movl	%eax, %ebx
	xorl	%ebx, %r12d
	orl	%r12d, %ebx
	movq	-40(%rbp), %rax
	movl	%eax, %edx
	movl	%ebx, %eax
	xorl	%edx, %eax
	movl	%eax, %ebx
	xorl	%ebx, %r12d
	orl	%r12d, %ebx
	movq	-40(%rbp), %rax
	movl	%eax, %edx
	movl	%ebx, %eax
	xorl	%edx, %eax
	movl	%eax, %ebx
	xorl	%ebx, %r12d
	orl	%r12d, %ebx
	movq	-40(%rbp), %rax
	movl	%eax, %edx
	movl	%ebx, %eax
	xorl	%edx, %eax
	movl	%eax, %ebx
	xorl	%ebx, %r12d
	orl	%r12d, %ebx
	movq	-40(%rbp), %rax
	movl	%eax, %edx
	movl	%ebx, %eax
	xorl	%edx, %eax
	movl	%eax, %ebx
	xorl	%ebx, %r12d
	orl	%r12d, %ebx
	movq	-40(%rbp), %rax
	movl	%eax, %edx
	movl	%ebx, %eax
	xorl	%edx, %eax
	movl	%eax, %ebx
	xorl	%ebx, %r12d
	orl	%r12d, %ebx
	movq	-40(%rbp), %rax
	movl	%eax, %edx
	movl	%ebx, %eax
	xorl	%edx, %eax
	movl	%eax, %ebx
	xorl	%ebx, %r12d
	orl	%r12d, %ebx
	movq	-40(%rbp), %rax
	movl	%eax, %edx
	movl	%ebx, %eax
	xorl	%edx, %eax
	movl	%eax, %ebx
	xorl	%ebx, %r12d
	orl	%r12d, %ebx
	movq	-40(%rbp), %rax
	movl	%eax, %edx
	movl	%ebx, %eax
	xorl	%edx, %eax
	movl	%eax, %ebx
	xorl	%ebx, %r12d
	orl	%r12d, %ebx
	movq	-40(%rbp), %rax
	movl	%eax, %edx
	movl	%ebx, %eax
	xorl	%edx, %eax
	movl	%eax, %ebx
	xorl	%ebx, %r12d
	orl	%r12d, %ebx
	movq	-40(%rbp), %rax
	movl	%eax, %edx
	movl	%ebx, %eax
	xorl	%edx, %eax
	movl	%eax, %ebx
	xorl	%ebx, %r12d
	orl	%r12d, %ebx
	movq	-40(%rbp), %rax
	movl	%eax, %edx
	movl	%ebx, %eax
	xorl	%edx, %eax
	movl	%eax, %ebx
	xorl	%ebx, %r12d
	orl	%r12d, %ebx
	movq	-40(%rbp), %rax
	movl	%eax, %edx
	movl	%ebx, %eax
	xorl	%edx, %eax
	movl	%eax, %ebx
	xorl	%ebx, %r12d
	orl	%r12d, %ebx
	movq	-40(%rbp), %rax
	movl	%eax, %edx
	movl	%ebx, %eax
	xorl	%edx, %eax
	movl	%eax, %ebx
	xorl	%ebx, %r12d
	orl	%r12d, %ebx
	movq	-40(%rbp), %rax
	movl	%eax, %edx
	movl	%ebx, %eax
	xorl	%edx, %eax
	movl	%eax, %ebx
	xorl	%ebx, %r12d
	orl	%r12d, %ebx
	movq	-40(%rbp), %rax
	movl	%eax, %edx
	movl	%ebx, %eax
	xorl	%edx, %eax
	movl	%eax, %ebx
	xorl	%ebx, %r12d
	orl	%r12d, %ebx
	movq	-40(%rbp), %rax
	movl	%eax, %edx
	movl	%ebx, %eax
	xorl	%edx, %eax
	movl	%eax, %ebx
	xorl	%ebx, %r12d
	orl	%r12d, %ebx
	movq	-40(%rbp), %rax
	movl	%eax, %edx
	movl	%ebx, %eax
	xorl	%edx, %eax
	movl	%eax, %ebx
	xorl	%ebx, %r12d
	orl	%r12d, %ebx
	movq	-40(%rbp), %rax
	movl	%eax, %edx
	movl	%ebx, %eax
	xorl	%edx, %eax
	movl	%eax, %ebx
	xorl	%ebx, %r12d
	orl	%r12d, %ebx
	movq	-40(%rbp), %rax
	movl	%eax, %edx
	movl	%ebx, %eax
	xorl	%edx, %eax
	movl	%eax, %ebx
	xorl	%ebx, %r12d
	orl	%r12d, %ebx
	movq	-40(%rbp), %rax
	movl	%eax, %edx
	movl	%ebx, %eax
	xorl	%edx, %eax
	movl	%eax, %ebx
	xorl	%ebx, %r12d
	orl	%r12d, %ebx
	movq	-40(%rbp), %rax
	movl	%eax, %edx
	movl	%ebx, %eax
	xorl	%edx, %eax
	movl	%eax, %ebx
	xorl	%ebx, %r12d
	orl	%r12d, %ebx
	movq	-40(%rbp), %rax
	movl	%eax, %edx
	movl	%ebx, %eax
	xorl	%edx, %eax
	movl	%eax, %ebx
	xorl	%ebx, %r12d
	orl	%r12d, %ebx
	movq	-40(%rbp), %rax
	movl	%eax, %edx
	movl	%ebx, %eax
	xorl	%edx, %eax
	movl	%eax, %ebx
	xorl	%ebx, %r12d
	orl	%r12d, %ebx
	movq	-40(%rbp), %rax
	movl	%eax, %edx
	movl	%ebx, %eax
	xorl	%edx, %eax
	movl	%eax, %ebx
	xorl	%ebx, %r12d
	orl	%r12d, %ebx
	movq	-40(%rbp), %rax
	movl	%eax, %edx
	movl	%ebx, %eax
	xorl	%edx, %eax
	movl	%eax, %ebx
	xorl	%ebx, %r12d
	orl	%r12d, %ebx
	movq	-40(%rbp), %rax
	movl	%eax, %edx
	movl	%ebx, %eax
	xorl	%edx, %eax
	movl	%eax, %ebx
	xorl	%ebx, %r12d
	orl	%r12d, %ebx
	movq	-40(%rbp), %rax
	movl	%eax, %edx
	movl	%ebx, %eax
	xorl	%edx, %eax
	movl	%eax, %ebx
	xorl	%ebx, %r12d
	orl	%r12d, %ebx
	movq	-40(%rbp), %rax
	movl	%eax, %edx
	movl	%ebx, %eax
	xorl	%edx, %eax
	movl	%eax, %ebx
	xorl	%ebx, %r12d
	orl	%r12d, %ebx
	movq	-40(%rbp), %rax
	movl	%eax, %edx
	movl	%ebx, %eax
	xorl	%edx, %eax
	movl	%eax, %ebx
	xorl	%ebx, %r12d
	orl	%r12d, %ebx
	movq	-40(%rbp), %rax
	movl	%eax, %edx
	movl	%ebx, %eax
	xorl	%edx, %eax
	movl	%eax, %ebx
	xorl	%ebx, %r12d
	orl	%r12d, %ebx
	movq	-40(%rbp), %rax
	movl	%eax, %edx
	movl	%ebx, %eax
	xorl	%edx, %eax
	movl	%eax, %ebx
	xorl	%ebx, %r12d
	orl	%r12d, %ebx
	movq	-40(%rbp), %rax
	movl	%eax, %edx
	movl	%ebx, %eax
	xorl	%edx, %eax
	movl	%eax, %ebx
	xorl	%ebx, %r12d
	orl	%r12d, %ebx
	movq	-40(%rbp), %rax
	movl	%eax, %edx
	movl	%ebx, %eax
	xorl	%edx, %eax
	movl	%eax, %ebx
	xorl	%ebx, %r12d
	orl	%r12d, %ebx
	movq	-40(%rbp), %rax
	movl	%eax, %edx
	movl	%ebx, %eax
	xorl	%edx, %eax
	movl	%eax, %ebx
	xorl	%ebx, %r12d
	orl	%r12d, %ebx
	movq	-40(%rbp), %rax
	movl	%eax, %edx
	movl	%ebx, %eax
	xorl	%edx, %eax
	movl	%eax, %ebx
	xorl	%ebx, %r12d
	orl	%r12d, %ebx
	movq	-40(%rbp), %rax
	movl	%eax, %edx
	movl	%ebx, %eax
	xorl	%edx, %eax
	movl	%eax, %ebx
	xorl	%ebx, %r12d
	orl	%r12d, %ebx
	movq	-40(%rbp), %rax
	movl	%eax, %edx
	movl	%ebx, %eax
	xorl	%edx, %eax
	movl	%eax, %ebx
	xorl	%ebx, %r12d
	orl	%r12d, %ebx
	movq	-40(%rbp), %rax
	movl	%eax, %edx
	movl	%ebx, %eax
	xorl	%edx, %eax
	movl	%eax, %ebx
	xorl	%ebx, %r12d
	orl	%r12d, %ebx
	movq	-40(%rbp), %rax
	movl	%eax, %edx
	movl	%ebx, %eax
	xorl	%edx, %eax
	movl	%eax, %ebx
	xorl	%ebx, %r12d
	orl	%r12d, %ebx
	movq	-40(%rbp), %rax
	movl	%eax, %edx
	movl	%ebx, %eax
	xorl	%edx, %eax
	movl	%eax, %ebx
	xorl	%ebx, %r12d
	orl	%r12d, %ebx
	movq	-40(%rbp), %rax
	movl	%eax, %edx
	movl	%ebx, %eax
	xorl	%edx, %eax
	movl	%eax, %ebx
	xorl	%ebx, %r12d
	orl	%r12d, %ebx
	movq	-40(%rbp), %rax
	movl	%eax, %edx
	movl	%ebx, %eax
	xorl	%edx, %eax
	movl	%eax, %ebx
	xorl	%ebx, %r12d
	orl	%r12d, %ebx
	movq	-40(%rbp), %rax
	movl	%eax, %edx
	movl	%ebx, %eax
	xorl	%edx, %eax
	movl	%eax, %ebx
	xorl	%ebx, %r12d
	orl	%r12d, %ebx
	movq	-40(%rbp), %rax
	movl	%eax, %edx
	movl	%ebx, %eax
	xorl	%edx, %eax
	movl	%eax, %ebx
	xorl	%ebx, %r12d
	orl	%r12d, %ebx
	movq	-40(%rbp), %rax
	movl	%eax, %edx
	movl	%ebx, %eax
	xorl	%edx, %eax
	movl	%eax, %ebx
	xorl	%ebx, %r12d
	orl	%r12d, %ebx
	movq	-40(%rbp), %rax
	movl	%eax, %edx
	movl	%ebx, %eax
	xorl	%edx, %eax
	movl	%eax, %ebx
	xorl	%ebx, %r12d
	orl	%r12d, %ebx
	movq	-40(%rbp), %rax
	movl	%eax, %edx
	movl	%ebx, %eax
	xorl	%edx, %eax
	movl	%eax, %ebx
	xorl	%ebx, %r12d
	orl	%r12d, %ebx
	movq	-40(%rbp), %rax
	movl	%eax, %edx
	movl	%ebx, %eax
	xorl	%edx, %eax
	movl	%eax, %ebx
	xorl	%ebx, %r12d
	orl	%r12d, %ebx
	movq	-40(%rbp), %rax
	movl	%eax, %edx
	movl	%ebx, %eax
	xorl	%edx, %eax
	movl	%eax, %ebx
	xorl	%ebx, %r12d
	orl	%r12d, %ebx
	movq	-40(%rbp), %rax
	movl	%eax, %edx
	movl	%ebx, %eax
	xorl	%edx, %eax
	movl	%eax, %ebx
	xorl	%ebx, %r12d
	orl	%r12d, %ebx
	movq	-40(%rbp), %rax
	movl	%eax, %edx
	movl	%ebx, %eax
	xorl	%edx, %eax
	movl	%eax, %ebx
	xorl	%ebx, %r12d
	orl	%r12d, %ebx
	movq	-40(%rbp), %rax
	movl	%eax, %edx
	movl	%ebx, %eax
	xorl	%edx, %eax
	movl	%eax, %ebx
	xorl	%ebx, %r12d
	orl	%r12d, %ebx
	movq	-40(%rbp), %rax
	movl	%eax, %edx
	movl	%ebx, %eax
	xorl	%edx, %eax
	movl	%eax, %ebx
	xorl	%ebx, %r12d
	orl	%r12d, %ebx
	movq	-40(%rbp), %rax
	movl	%eax, %edx
	movl	%ebx, %eax
	xorl	%edx, %eax
	movl	%eax, %ebx
	xorl	%ebx, %r12d
	orl	%r12d, %ebx
	movq	-40(%rbp), %rax
	movl	%eax, %edx
	movl	%ebx, %eax
	xorl	%edx, %eax
	movl	%eax, %ebx
	xorl	%ebx, %r12d
	orl	%r12d, %ebx
	movq	-40(%rbp), %rax
	movl	%eax, %edx
	movl	%ebx, %eax
	xorl	%edx, %eax
	movl	%eax, %ebx
	xorl	%ebx, %r12d
	orl	%r12d, %ebx
	movq	-40(%rbp), %rax
	movl	%eax, %edx
	movl	%ebx, %eax
	xorl	%edx, %eax
	movl	%eax, %ebx
	xorl	%ebx, %r12d
	orl	%r12d, %ebx
	movq	-40(%rbp), %rax
	movl	%eax, %edx
	movl	%ebx, %eax
	xorl	%edx, %eax
	movl	%eax, %ebx
	xorl	%ebx, %r12d
	orl	%r12d, %ebx
	movq	-40(%rbp), %rax
	movl	%eax, %edx
	movl	%ebx, %eax
	xorl	%edx, %eax
	movl	%eax, %ebx
	xorl	%ebx, %r12d
	orl	%r12d, %ebx
	movq	-40(%rbp), %rax
	movl	%eax, %edx
	movl	%ebx, %eax
	xorl	%edx, %eax
	movl	%eax, %ebx
	xorl	%ebx, %r12d
	orl	%r12d, %ebx
	movq	-40(%rbp), %rax
	movl	%eax, %edx
	movl	%ebx, %eax
	xorl	%edx, %eax
	movl	%eax, %ebx
	xorl	%ebx, %r12d
	orl	%r12d, %ebx
	movq	-40(%rbp), %rax
	movl	%eax, %edx
	movl	%ebx, %eax
	xorl	%edx, %eax
	movl	%eax, %ebx
	xorl	%ebx, %r12d
	orl	%r12d, %ebx
	movq	-40(%rbp), %rax
	movl	%eax, %edx
	movl	%ebx, %eax
	xorl	%edx, %eax
	movl	%eax, %ebx
	xorl	%ebx, %r12d
	orl	%r12d, %ebx
	movq	-40(%rbp), %rax
	movl	%eax, %edx
	movl	%ebx, %eax
	xorl	%edx, %eax
	movl	%eax, %ebx
	xorl	%ebx, %r12d
	orl	%r12d, %ebx
	movq	-40(%rbp), %rax
	movl	%eax, %edx
	movl	%ebx, %eax
	xorl	%edx, %eax
	movl	%eax, %ebx
	xorl	%ebx, %r12d
	orl	%r12d, %ebx
	movq	-40(%rbp), %rax
	movl	%eax, %edx
	movl	%ebx, %eax
	xorl	%edx, %eax
	movl	%eax, %ebx
	xorl	%ebx, %r12d
	orl	%r12d, %ebx
	movq	-40(%rbp), %rax
	movl	%eax, %edx
	movl	%ebx, %eax
	xorl	%edx, %eax
	movl	%eax, %ebx
	xorl	%ebx, %r12d
	orl	%r12d, %ebx
	movq	-40(%rbp), %rax
	movl	%eax, %edx
	movl	%ebx, %eax
	xorl	%edx, %eax
	movl	%eax, %ebx
	xorl	%ebx, %r12d
	orl	%r12d, %ebx
	movq	-40(%rbp), %rax
	movl	%eax, %edx
	movl	%ebx, %eax
	xorl	%edx, %eax
	movl	%eax, %ebx
	xorl	%ebx, %r12d
	orl	%r12d, %ebx
	movq	-40(%rbp), %rax
	movl	%eax, %edx
	movl	%ebx, %eax
	xorl	%edx, %eax
	movl	%eax, %ebx
	xorl	%ebx, %r12d
	orl	%r12d, %ebx
	movq	-40(%rbp), %rax
	movl	%eax, %edx
	movl	%ebx, %eax
	xorl	%edx, %eax
	movl	%eax, %ebx
	xorl	%ebx, %r12d
	orl	%r12d, %ebx
	movq	-40(%rbp), %rax
	movl	%eax, %edx
	movl	%ebx, %eax
	xorl	%edx, %eax
	movl	%eax, %ebx
	xorl	%ebx, %r12d
	orl	%r12d, %ebx
	movq	-40(%rbp), %rax
	movl	%eax, %edx
	movl	%ebx, %eax
	xorl	%edx, %eax
	movl	%eax, %ebx
	xorl	%ebx, %r12d
	orl	%r12d, %ebx
	movq	-40(%rbp), %rax
	movl	%eax, %edx
	movl	%ebx, %eax
	xorl	%edx, %eax
	movl	%eax, %ebx
	xorl	%ebx, %r12d
	orl	%r12d, %ebx
	movq	-40(%rbp), %rax
	movl	%eax, %edx
	movl	%ebx, %eax
	xorl	%edx, %eax
	movl	%eax, %ebx
	xorl	%ebx, %r12d
	orl	%r12d, %ebx
	movq	-40(%rbp), %rax
	movl	%eax, %edx
	movl	%ebx, %eax
	xorl	%edx, %eax
	movl	%eax, %ebx
	xorl	%ebx, %r12d
	orl	%r12d, %ebx
	movq	-40(%rbp), %rax
	movl	%eax, %edx
	movl	%ebx, %eax
	xorl	%edx, %eax
	movl	%eax, %ebx
	xorl	%ebx, %r12d
	orl	%r12d, %ebx
	movq	-40(%rbp), %rax
	movl	%eax, %edx
	movl	%ebx, %eax
	xorl	%edx, %eax
	movl	%eax, %ebx
	xorl	%ebx, %r12d
	orl	%r12d, %ebx
	movq	-40(%rbp), %rax
	movl	%eax, %edx
	movl	%ebx, %eax
	xorl	%edx, %eax
	movl	%eax, %ebx
	xorl	%ebx, %r12d
	orl	%r12d, %ebx
	movq	-40(%rbp), %rax
	movl	%eax, %edx
	movl	%ebx, %eax
	xorl	%edx, %eax
	movl	%eax, %ebx
	xorl	%ebx, %r12d
	orl	%r12d, %ebx
	movq	-40(%rbp), %rax
	movl	%eax, %edx
	movl	%ebx, %eax
	xorl	%edx, %eax
	movl	%eax, %ebx
	xorl	%ebx, %r12d
	orl	%r12d, %ebx
	movq	-40(%rbp), %rax
	movl	%eax, %edx
	movl	%ebx, %eax
	xorl	%edx, %eax
	movl	%eax, %ebx
	xorl	%ebx, %r12d
	orl	%r12d, %ebx
	movq	-40(%rbp), %rax
	movl	%eax, %edx
	movl	%ebx, %eax
	xorl	%edx, %eax
	movl	%eax, %ebx
	xorl	%ebx, %r12d
	orl	%r12d, %ebx
	movq	-40(%rbp), %rax
	movl	%eax, %edx
	movl	%ebx, %eax
	xorl	%edx, %eax
	movl	%eax, %ebx
	xorl	%ebx, %r12d
	orl	%r12d, %ebx
	movq	-40(%rbp), %rax
	movl	%eax, %edx
	movl	%ebx, %eax
	xorl	%edx, %eax
	movl	%eax, %ebx
	xorl	%ebx, %r12d
	orl	%r12d, %ebx
	movq	-40(%rbp), %rax
	movl	%eax, %edx
	movl	%ebx, %eax
	xorl	%edx, %eax
	movl	%eax, %ebx
	xorl	%ebx, %r12d
	orl	%r12d, %ebx
	movq	-40(%rbp), %rax
	movl	%eax, %edx
	movl	%ebx, %eax
	xorl	%edx, %eax
	movl	%eax, %ebx
	xorl	%ebx, %r12d
	orl	%r12d, %ebx
	movq	-40(%rbp), %rax
	movl	%eax, %edx
	movl	%ebx, %eax
	xorl	%edx, %eax
	movl	%eax, %ebx
	xorl	%ebx, %r12d
	orl	%r12d, %ebx
	movq	-40(%rbp), %rax
	movl	%eax, %edx
	movl	%ebx, %eax
	xorl	%edx, %eax
	movl	%eax, %ebx
	xorl	%ebx, %r12d
	orl	%r12d, %ebx
.L20:
	movq	-40(%rbp), %rax
	leaq	-1(%rax), %rdx
	movq	%rdx, -40(%rbp)
	testq	%rax, %rax
	jne	.L21
	movl	%ebx, %edi
	call	use_int@PLT
	nop
	addq	$32, %rsp
	popq	%rbx
	popq	%r12
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE11:
	.size	do_integer_bitwise, .-do_integer_bitwise
	.globl	do_integer_add
	.type	do_integer_add, @function
do_integer_add:
.LFB12:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r12
	pushq	%rbx
	subq	$32, %rsp
	.cfi_offset 12, -24
	.cfi_offset 3, -32
	movq	%rdi, -40(%rbp)
	movq	%rsi, -48(%rbp)
	movq	-48(%rbp), %rax
	movq	%rax, -24(%rbp)
	movq	-24(%rbp), %rax
	movl	(%rax), %eax
	leal	57(%rax), %ebx
	jmp	.L23
.L26:
	movl	$1, %r12d
	jmp	.L24
.L25:
	leal	(%rbx,%rbx), %eax
	leal	(%r12,%rax), %ebx
	leal	(%rbx,%rbx), %eax
	leal	(%r12,%rax), %ebx
	leal	(%rbx,%rbx), %eax
	leal	(%r12,%rax), %ebx
	leal	(%rbx,%rbx), %eax
	leal	(%r12,%rax), %ebx
	leal	(%rbx,%rbx), %eax
	leal	(%r12,%rax), %ebx
	leal	(%rbx,%rbx), %eax
	leal	(%r12,%rax), %ebx
	leal	(%rbx,%rbx), %eax
	leal	(%r12,%rax), %ebx
	leal	(%rbx,%rbx), %eax
	leal	(%r12,%rax), %ebx
	leal	(%rbx,%rbx), %eax
	leal	(%r12,%rax), %ebx
	leal	(%rbx,%rbx), %eax
	leal	(%r12,%rax), %ebx
	addl	$1, %r12d
.L24:
	cmpl	$1000, %r12d
	jle	.L25
.L23:
	movq	-40(%rbp), %rax
	leaq	-1(%rax), %rdx
	movq	%rdx, -40(%rbp)
	testq	%rax, %rax
	jne	.L26
	movl	%ebx, %edi
	call	use_int@PLT
	nop
	addq	$32, %rsp
	popq	%rbx
	popq	%r12
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE12:
	.size	do_integer_add, .-do_integer_add
	.globl	do_integer_mul
	.type	do_integer_mul, @function
do_integer_mul:
.LFB13:
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
	movq	-40(%rbp), %rax
	movl	(%rax), %eax
	leal	37431(%rax), %ebx
	movq	-40(%rbp), %rax
	movl	(%rax), %eax
	leal	4(%rax), %r12d
	movl	%ebx, %eax
	imull	%r12d, %eax
	imull	%r12d, %eax
	imull	%r12d, %eax
	imull	%r12d, %eax
	imull	%r12d, %eax
	imull	%r12d, %eax
	imull	%r12d, %eax
	imull	%r12d, %eax
	imull	%r12d, %eax
	imull	%r12d, %eax
	subl	%ebx, %eax
	movl	%eax, %r13d
	jmp	.L28
.L29:
	imull	%r12d, %ebx
	imull	%r12d, %ebx
	imull	%r12d, %ebx
	imull	%r12d, %ebx
	imull	%r12d, %ebx
	imull	%r12d, %ebx
	imull	%r12d, %ebx
	imull	%r12d, %ebx
	imull	%r12d, %ebx
	imull	%r12d, %ebx
	subl	%r13d, %ebx
	imull	%r12d, %ebx
	imull	%r12d, %ebx
	imull	%r12d, %ebx
	imull	%r12d, %ebx
	imull	%r12d, %ebx
	imull	%r12d, %ebx
	imull	%r12d, %ebx
	imull	%r12d, %ebx
	imull	%r12d, %ebx
	imull	%r12d, %ebx
	subl	%r13d, %ebx
.L28:
	movq	-56(%rbp), %rax
	leaq	-1(%rax), %rdx
	movq	%rdx, -56(%rbp)
	testq	%rax, %rax
	jne	.L29
	movl	%ebx, %edi
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
.LFE13:
	.size	do_integer_mul, .-do_integer_mul
	.globl	do_integer_div
	.type	do_integer_div, @function
do_integer_div:
.LFB14:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r12
	pushq	%rbx
	subq	$32, %rsp
	.cfi_offset 12, -24
	.cfi_offset 3, -32
	movq	%rdi, -40(%rbp)
	movq	%rsi, -48(%rbp)
	movq	-48(%rbp), %rax
	movq	%rax, -24(%rbp)
	movq	-24(%rbp), %rax
	movl	(%rax), %eax
	leal	36(%rax), %ebx
	leal	1(%rbx), %eax
	sall	$20, %eax
	movl	%eax, %r12d
	jmp	.L31
.L32:
	movl	%r12d, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ebx
	movl	%r12d, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ebx
	movl	%r12d, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ebx
	movl	%r12d, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ebx
	movl	%r12d, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ebx
	movl	%r12d, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ebx
	movl	%r12d, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ebx
	movl	%r12d, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ebx
	movl	%r12d, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ebx
	movl	%r12d, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ebx
	movl	%r12d, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ebx
	movl	%r12d, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ebx
	movl	%r12d, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ebx
	movl	%r12d, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ebx
	movl	%r12d, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ebx
	movl	%r12d, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ebx
	movl	%r12d, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ebx
	movl	%r12d, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ebx
	movl	%r12d, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ebx
	movl	%r12d, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ebx
	movl	%r12d, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ebx
	movl	%r12d, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ebx
	movl	%r12d, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ebx
	movl	%r12d, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ebx
	movl	%r12d, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ebx
	movl	%r12d, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ebx
	movl	%r12d, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ebx
	movl	%r12d, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ebx
	movl	%r12d, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ebx
	movl	%r12d, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ebx
	movl	%r12d, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ebx
	movl	%r12d, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ebx
	movl	%r12d, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ebx
	movl	%r12d, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ebx
	movl	%r12d, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ebx
	movl	%r12d, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ebx
	movl	%r12d, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ebx
	movl	%r12d, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ebx
	movl	%r12d, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ebx
	movl	%r12d, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ebx
	movl	%r12d, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ebx
	movl	%r12d, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ebx
	movl	%r12d, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ebx
	movl	%r12d, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ebx
	movl	%r12d, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ebx
	movl	%r12d, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ebx
	movl	%r12d, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ebx
	movl	%r12d, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ebx
	movl	%r12d, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ebx
	movl	%r12d, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ebx
	movl	%r12d, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ebx
	movl	%r12d, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ebx
	movl	%r12d, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ebx
	movl	%r12d, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ebx
	movl	%r12d, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ebx
	movl	%r12d, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ebx
	movl	%r12d, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ebx
	movl	%r12d, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ebx
	movl	%r12d, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ebx
	movl	%r12d, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ebx
	movl	%r12d, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ebx
	movl	%r12d, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ebx
	movl	%r12d, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ebx
	movl	%r12d, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ebx
	movl	%r12d, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ebx
	movl	%r12d, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ebx
	movl	%r12d, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ebx
	movl	%r12d, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ebx
	movl	%r12d, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ebx
	movl	%r12d, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ebx
	movl	%r12d, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ebx
	movl	%r12d, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ebx
	movl	%r12d, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ebx
	movl	%r12d, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ebx
	movl	%r12d, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ebx
	movl	%r12d, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ebx
	movl	%r12d, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ebx
	movl	%r12d, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ebx
	movl	%r12d, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ebx
	movl	%r12d, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ebx
	movl	%r12d, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ebx
	movl	%r12d, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ebx
	movl	%r12d, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ebx
	movl	%r12d, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ebx
	movl	%r12d, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ebx
	movl	%r12d, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ebx
	movl	%r12d, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ebx
	movl	%r12d, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ebx
	movl	%r12d, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ebx
	movl	%r12d, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ebx
	movl	%r12d, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ebx
	movl	%r12d, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ebx
	movl	%r12d, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ebx
	movl	%r12d, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ebx
	movl	%r12d, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ebx
	movl	%r12d, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ebx
	movl	%r12d, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ebx
	movl	%r12d, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ebx
	movl	%r12d, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ebx
	movl	%r12d, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ebx
.L31:
	movq	-40(%rbp), %rax
	leaq	-1(%rax), %rdx
	movq	%rdx, -40(%rbp)
	testq	%rax, %rax
	jne	.L32
	movl	%ebx, %edi
	call	use_int@PLT
	nop
	addq	$32, %rsp
	popq	%rbx
	popq	%r12
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE14:
	.size	do_integer_div, .-do_integer_div
	.globl	do_integer_mod
	.type	do_integer_mod, @function
do_integer_mod:
.LFB15:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r12
	pushq	%rbx
	subq	$32, %rsp
	.cfi_offset 12, -24
	.cfi_offset 3, -32
	movq	%rdi, -40(%rbp)
	movq	%rsi, -48(%rbp)
	movq	-48(%rbp), %rax
	movq	%rax, -24(%rbp)
	movq	-24(%rbp), %rax
	movl	(%rax), %eax
	movl	%eax, %edx
	movq	-40(%rbp), %rax
	addl	%edx, %eax
	movl	%eax, %ebx
	movq	-24(%rbp), %rax
	movl	(%rax), %eax
	leal	62(%rax), %r12d
	jmp	.L34
.L35:
	movl	%ebx, %eax
	cltd
	idivl	%r12d
	movl	%edx, %ebx
	orl	%r12d, %ebx
	movl	%ebx, %eax
	cltd
	idivl	%r12d
	movl	%edx, %ebx
	orl	%r12d, %ebx
	movl	%ebx, %eax
	cltd
	idivl	%r12d
	movl	%edx, %ebx
	orl	%r12d, %ebx
	movl	%ebx, %eax
	cltd
	idivl	%r12d
	movl	%edx, %ebx
	orl	%r12d, %ebx
	movl	%ebx, %eax
	cltd
	idivl	%r12d
	movl	%edx, %ebx
	orl	%r12d, %ebx
	movl	%ebx, %eax
	cltd
	idivl	%r12d
	movl	%edx, %ebx
	orl	%r12d, %ebx
	movl	%ebx, %eax
	cltd
	idivl	%r12d
	movl	%edx, %ebx
	orl	%r12d, %ebx
	movl	%ebx, %eax
	cltd
	idivl	%r12d
	movl	%edx, %ebx
	orl	%r12d, %ebx
	movl	%ebx, %eax
	cltd
	idivl	%r12d
	movl	%edx, %ebx
	orl	%r12d, %ebx
	movl	%ebx, %eax
	cltd
	idivl	%r12d
	movl	%edx, %ebx
	orl	%r12d, %ebx
	movl	%ebx, %eax
	cltd
	idivl	%r12d
	movl	%edx, %ebx
	orl	%r12d, %ebx
	movl	%ebx, %eax
	cltd
	idivl	%r12d
	movl	%edx, %ebx
	orl	%r12d, %ebx
	movl	%ebx, %eax
	cltd
	idivl	%r12d
	movl	%edx, %ebx
	orl	%r12d, %ebx
	movl	%ebx, %eax
	cltd
	idivl	%r12d
	movl	%edx, %ebx
	orl	%r12d, %ebx
	movl	%ebx, %eax
	cltd
	idivl	%r12d
	movl	%edx, %ebx
	orl	%r12d, %ebx
	movl	%ebx, %eax
	cltd
	idivl	%r12d
	movl	%edx, %ebx
	orl	%r12d, %ebx
	movl	%ebx, %eax
	cltd
	idivl	%r12d
	movl	%edx, %ebx
	orl	%r12d, %ebx
	movl	%ebx, %eax
	cltd
	idivl	%r12d
	movl	%edx, %ebx
	orl	%r12d, %ebx
	movl	%ebx, %eax
	cltd
	idivl	%r12d
	movl	%edx, %ebx
	orl	%r12d, %ebx
	movl	%ebx, %eax
	cltd
	idivl	%r12d
	movl	%edx, %ebx
	orl	%r12d, %ebx
	movl	%ebx, %eax
	cltd
	idivl	%r12d
	movl	%edx, %ebx
	orl	%r12d, %ebx
	movl	%ebx, %eax
	cltd
	idivl	%r12d
	movl	%edx, %ebx
	orl	%r12d, %ebx
	movl	%ebx, %eax
	cltd
	idivl	%r12d
	movl	%edx, %ebx
	orl	%r12d, %ebx
	movl	%ebx, %eax
	cltd
	idivl	%r12d
	movl	%edx, %ebx
	orl	%r12d, %ebx
	movl	%ebx, %eax
	cltd
	idivl	%r12d
	movl	%edx, %ebx
	orl	%r12d, %ebx
	movl	%ebx, %eax
	cltd
	idivl	%r12d
	movl	%edx, %ebx
	orl	%r12d, %ebx
	movl	%ebx, %eax
	cltd
	idivl	%r12d
	movl	%edx, %ebx
	orl	%r12d, %ebx
	movl	%ebx, %eax
	cltd
	idivl	%r12d
	movl	%edx, %ebx
	orl	%r12d, %ebx
	movl	%ebx, %eax
	cltd
	idivl	%r12d
	movl	%edx, %ebx
	orl	%r12d, %ebx
	movl	%ebx, %eax
	cltd
	idivl	%r12d
	movl	%edx, %ebx
	orl	%r12d, %ebx
	movl	%ebx, %eax
	cltd
	idivl	%r12d
	movl	%edx, %ebx
	orl	%r12d, %ebx
	movl	%ebx, %eax
	cltd
	idivl	%r12d
	movl	%edx, %ebx
	orl	%r12d, %ebx
	movl	%ebx, %eax
	cltd
	idivl	%r12d
	movl	%edx, %ebx
	orl	%r12d, %ebx
	movl	%ebx, %eax
	cltd
	idivl	%r12d
	movl	%edx, %ebx
	orl	%r12d, %ebx
	movl	%ebx, %eax
	cltd
	idivl	%r12d
	movl	%edx, %ebx
	orl	%r12d, %ebx
	movl	%ebx, %eax
	cltd
	idivl	%r12d
	movl	%edx, %ebx
	orl	%r12d, %ebx
	movl	%ebx, %eax
	cltd
	idivl	%r12d
	movl	%edx, %ebx
	orl	%r12d, %ebx
	movl	%ebx, %eax
	cltd
	idivl	%r12d
	movl	%edx, %ebx
	orl	%r12d, %ebx
	movl	%ebx, %eax
	cltd
	idivl	%r12d
	movl	%edx, %ebx
	orl	%r12d, %ebx
	movl	%ebx, %eax
	cltd
	idivl	%r12d
	movl	%edx, %ebx
	orl	%r12d, %ebx
	movl	%ebx, %eax
	cltd
	idivl	%r12d
	movl	%edx, %ebx
	orl	%r12d, %ebx
	movl	%ebx, %eax
	cltd
	idivl	%r12d
	movl	%edx, %ebx
	orl	%r12d, %ebx
	movl	%ebx, %eax
	cltd
	idivl	%r12d
	movl	%edx, %ebx
	orl	%r12d, %ebx
	movl	%ebx, %eax
	cltd
	idivl	%r12d
	movl	%edx, %ebx
	orl	%r12d, %ebx
	movl	%ebx, %eax
	cltd
	idivl	%r12d
	movl	%edx, %ebx
	orl	%r12d, %ebx
	movl	%ebx, %eax
	cltd
	idivl	%r12d
	movl	%edx, %ebx
	orl	%r12d, %ebx
	movl	%ebx, %eax
	cltd
	idivl	%r12d
	movl	%edx, %ebx
	orl	%r12d, %ebx
	movl	%ebx, %eax
	cltd
	idivl	%r12d
	movl	%edx, %ebx
	orl	%r12d, %ebx
	movl	%ebx, %eax
	cltd
	idivl	%r12d
	movl	%edx, %ebx
	orl	%r12d, %ebx
	movl	%ebx, %eax
	cltd
	idivl	%r12d
	movl	%edx, %ebx
	orl	%r12d, %ebx
	movl	%ebx, %eax
	cltd
	idivl	%r12d
	movl	%edx, %ebx
	orl	%r12d, %ebx
	movl	%ebx, %eax
	cltd
	idivl	%r12d
	movl	%edx, %ebx
	orl	%r12d, %ebx
	movl	%ebx, %eax
	cltd
	idivl	%r12d
	movl	%edx, %ebx
	orl	%r12d, %ebx
	movl	%ebx, %eax
	cltd
	idivl	%r12d
	movl	%edx, %ebx
	orl	%r12d, %ebx
	movl	%ebx, %eax
	cltd
	idivl	%r12d
	movl	%edx, %ebx
	orl	%r12d, %ebx
	movl	%ebx, %eax
	cltd
	idivl	%r12d
	movl	%edx, %ebx
	orl	%r12d, %ebx
	movl	%ebx, %eax
	cltd
	idivl	%r12d
	movl	%edx, %ebx
	orl	%r12d, %ebx
	movl	%ebx, %eax
	cltd
	idivl	%r12d
	movl	%edx, %ebx
	orl	%r12d, %ebx
	movl	%ebx, %eax
	cltd
	idivl	%r12d
	movl	%edx, %ebx
	orl	%r12d, %ebx
	movl	%ebx, %eax
	cltd
	idivl	%r12d
	movl	%edx, %ebx
	orl	%r12d, %ebx
	movl	%ebx, %eax
	cltd
	idivl	%r12d
	movl	%edx, %ebx
	orl	%r12d, %ebx
	movl	%ebx, %eax
	cltd
	idivl	%r12d
	movl	%edx, %ebx
	orl	%r12d, %ebx
	movl	%ebx, %eax
	cltd
	idivl	%r12d
	movl	%edx, %ebx
	orl	%r12d, %ebx
	movl	%ebx, %eax
	cltd
	idivl	%r12d
	movl	%edx, %ebx
	orl	%r12d, %ebx
	movl	%ebx, %eax
	cltd
	idivl	%r12d
	movl	%edx, %ebx
	orl	%r12d, %ebx
	movl	%ebx, %eax
	cltd
	idivl	%r12d
	movl	%edx, %ebx
	orl	%r12d, %ebx
	movl	%ebx, %eax
	cltd
	idivl	%r12d
	movl	%edx, %ebx
	orl	%r12d, %ebx
	movl	%ebx, %eax
	cltd
	idivl	%r12d
	movl	%edx, %ebx
	orl	%r12d, %ebx
	movl	%ebx, %eax
	cltd
	idivl	%r12d
	movl	%edx, %ebx
	orl	%r12d, %ebx
	movl	%ebx, %eax
	cltd
	idivl	%r12d
	movl	%edx, %ebx
	orl	%r12d, %ebx
	movl	%ebx, %eax
	cltd
	idivl	%r12d
	movl	%edx, %ebx
	orl	%r12d, %ebx
	movl	%ebx, %eax
	cltd
	idivl	%r12d
	movl	%edx, %ebx
	orl	%r12d, %ebx
	movl	%ebx, %eax
	cltd
	idivl	%r12d
	movl	%edx, %ebx
	orl	%r12d, %ebx
	movl	%ebx, %eax
	cltd
	idivl	%r12d
	movl	%edx, %ebx
	orl	%r12d, %ebx
	movl	%ebx, %eax
	cltd
	idivl	%r12d
	movl	%edx, %ebx
	orl	%r12d, %ebx
	movl	%ebx, %eax
	cltd
	idivl	%r12d
	movl	%edx, %ebx
	orl	%r12d, %ebx
	movl	%ebx, %eax
	cltd
	idivl	%r12d
	movl	%edx, %ebx
	orl	%r12d, %ebx
	movl	%ebx, %eax
	cltd
	idivl	%r12d
	movl	%edx, %ebx
	orl	%r12d, %ebx
	movl	%ebx, %eax
	cltd
	idivl	%r12d
	movl	%edx, %ebx
	orl	%r12d, %ebx
	movl	%ebx, %eax
	cltd
	idivl	%r12d
	movl	%edx, %ebx
	orl	%r12d, %ebx
	movl	%ebx, %eax
	cltd
	idivl	%r12d
	movl	%edx, %ebx
	orl	%r12d, %ebx
	movl	%ebx, %eax
	cltd
	idivl	%r12d
	movl	%edx, %ebx
	orl	%r12d, %ebx
	movl	%ebx, %eax
	cltd
	idivl	%r12d
	movl	%edx, %ebx
	orl	%r12d, %ebx
	movl	%ebx, %eax
	cltd
	idivl	%r12d
	movl	%edx, %ebx
	orl	%r12d, %ebx
	movl	%ebx, %eax
	cltd
	idivl	%r12d
	movl	%edx, %ebx
	orl	%r12d, %ebx
	movl	%ebx, %eax
	cltd
	idivl	%r12d
	movl	%edx, %ebx
	orl	%r12d, %ebx
	movl	%ebx, %eax
	cltd
	idivl	%r12d
	movl	%edx, %ebx
	orl	%r12d, %ebx
	movl	%ebx, %eax
	cltd
	idivl	%r12d
	movl	%edx, %ebx
	orl	%r12d, %ebx
	movl	%ebx, %eax
	cltd
	idivl	%r12d
	movl	%edx, %ebx
	orl	%r12d, %ebx
	movl	%ebx, %eax
	cltd
	idivl	%r12d
	movl	%edx, %ebx
	orl	%r12d, %ebx
	movl	%ebx, %eax
	cltd
	idivl	%r12d
	movl	%edx, %ebx
	orl	%r12d, %ebx
	movl	%ebx, %eax
	cltd
	idivl	%r12d
	movl	%edx, %ebx
	orl	%r12d, %ebx
	movl	%ebx, %eax
	cltd
	idivl	%r12d
	movl	%edx, %ebx
	orl	%r12d, %ebx
	movl	%ebx, %eax
	cltd
	idivl	%r12d
	movl	%edx, %ebx
	orl	%r12d, %ebx
	movl	%ebx, %eax
	cltd
	idivl	%r12d
	movl	%edx, %ebx
	orl	%r12d, %ebx
	movl	%ebx, %eax
	cltd
	idivl	%r12d
	movl	%edx, %ebx
	orl	%r12d, %ebx
	movl	%ebx, %eax
	cltd
	idivl	%r12d
	movl	%edx, %ebx
	orl	%r12d, %ebx
	movl	%ebx, %eax
	cltd
	idivl	%r12d
	movl	%edx, %ebx
	orl	%r12d, %ebx
	movl	%ebx, %eax
	cltd
	idivl	%r12d
	movl	%edx, %ebx
	orl	%r12d, %ebx
	movl	%ebx, %eax
	cltd
	idivl	%r12d
	movl	%edx, %ebx
	orl	%r12d, %ebx
.L34:
	movq	-40(%rbp), %rax
	leaq	-1(%rax), %rdx
	movq	%rdx, -40(%rbp)
	testq	%rax, %rax
	jne	.L35
	movl	%ebx, %edi
	call	use_int@PLT
	nop
	addq	$32, %rsp
	popq	%rbx
	popq	%r12
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE15:
	.size	do_integer_mod, .-do_integer_mod
	.globl	do_int64_bitwise
	.type	do_int64_bitwise, @function
do_int64_bitwise:
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
	movq	-40(%rbp), %rax
	movl	(%rax), %eax
	movslq	%eax, %rdx
	movq	-40(%rbp), %rax
	movl	(%rax), %eax
	cltq
	salq	$32, %rax
	orq	%rax, %rdx
	movq	%rdx, %rbx
	movq	-56(%rbp), %rax
	salq	$32, %rax
	movq	%rax, %rdx
	movq	-56(%rbp), %rax
	orq	%rax, %rdx
	movq	%rdx, %r12
	movq	-56(%rbp), %rax
	salq	$34, %rax
	leaq	-1(%rax), %r13
	jmp	.L37
.L38:
	xorq	%r13, %rbx
	xorq	%rbx, %r12
	orq	%r12, %rbx
	xorq	%r13, %rbx
	xorq	%rbx, %r12
	orq	%r12, %rbx
	xorq	%r13, %rbx
	xorq	%rbx, %r12
	orq	%r12, %rbx
	xorq	%r13, %rbx
	xorq	%rbx, %r12
	orq	%r12, %rbx
	xorq	%r13, %rbx
	xorq	%rbx, %r12
	orq	%r12, %rbx
	xorq	%r13, %rbx
	xorq	%rbx, %r12
	orq	%r12, %rbx
	xorq	%r13, %rbx
	xorq	%rbx, %r12
	orq	%r12, %rbx
	xorq	%r13, %rbx
	xorq	%rbx, %r12
	orq	%r12, %rbx
	xorq	%r13, %rbx
	xorq	%rbx, %r12
	orq	%r12, %rbx
	xorq	%r13, %rbx
	xorq	%rbx, %r12
	orq	%r12, %rbx
	xorq	%r13, %rbx
	xorq	%rbx, %r12
	orq	%r12, %rbx
	xorq	%r13, %rbx
	xorq	%rbx, %r12
	orq	%r12, %rbx
	xorq	%r13, %rbx
	xorq	%rbx, %r12
	orq	%r12, %rbx
	xorq	%r13, %rbx
	xorq	%rbx, %r12
	orq	%r12, %rbx
	xorq	%r13, %rbx
	xorq	%rbx, %r12
	orq	%r12, %rbx
	xorq	%r13, %rbx
	xorq	%rbx, %r12
	orq	%r12, %rbx
	xorq	%r13, %rbx
	xorq	%rbx, %r12
	orq	%r12, %rbx
	xorq	%r13, %rbx
	xorq	%rbx, %r12
	orq	%r12, %rbx
	xorq	%r13, %rbx
	xorq	%rbx, %r12
	orq	%r12, %rbx
	xorq	%r13, %rbx
	xorq	%rbx, %r12
	orq	%r12, %rbx
	xorq	%r13, %rbx
	xorq	%rbx, %r12
	orq	%r12, %rbx
	xorq	%r13, %rbx
	xorq	%rbx, %r12
	orq	%r12, %rbx
	xorq	%r13, %rbx
	xorq	%rbx, %r12
	orq	%r12, %rbx
	xorq	%r13, %rbx
	xorq	%rbx, %r12
	orq	%r12, %rbx
	xorq	%r13, %rbx
	xorq	%rbx, %r12
	orq	%r12, %rbx
	xorq	%r13, %rbx
	xorq	%rbx, %r12
	orq	%r12, %rbx
	xorq	%r13, %rbx
	xorq	%rbx, %r12
	orq	%r12, %rbx
	xorq	%r13, %rbx
	xorq	%rbx, %r12
	orq	%r12, %rbx
	xorq	%r13, %rbx
	xorq	%rbx, %r12
	orq	%r12, %rbx
	xorq	%r13, %rbx
	xorq	%rbx, %r12
	orq	%r12, %rbx
	xorq	%r13, %rbx
	xorq	%rbx, %r12
	orq	%r12, %rbx
	xorq	%r13, %rbx
	xorq	%rbx, %r12
	orq	%r12, %rbx
	xorq	%r13, %rbx
	xorq	%rbx, %r12
	orq	%r12, %rbx
	xorq	%r13, %rbx
	xorq	%rbx, %r12
	orq	%r12, %rbx
	xorq	%r13, %rbx
	xorq	%rbx, %r12
	orq	%r12, %rbx
	xorq	%r13, %rbx
	xorq	%rbx, %r12
	orq	%r12, %rbx
	xorq	%r13, %rbx
	xorq	%rbx, %r12
	orq	%r12, %rbx
	xorq	%r13, %rbx
	xorq	%rbx, %r12
	orq	%r12, %rbx
	xorq	%r13, %rbx
	xorq	%rbx, %r12
	orq	%r12, %rbx
	xorq	%r13, %rbx
	xorq	%rbx, %r12
	orq	%r12, %rbx
	xorq	%r13, %rbx
	xorq	%rbx, %r12
	orq	%r12, %rbx
	xorq	%r13, %rbx
	xorq	%rbx, %r12
	orq	%r12, %rbx
	xorq	%r13, %rbx
	xorq	%rbx, %r12
	orq	%r12, %rbx
	xorq	%r13, %rbx
	xorq	%rbx, %r12
	orq	%r12, %rbx
	xorq	%r13, %rbx
	xorq	%rbx, %r12
	orq	%r12, %rbx
	xorq	%r13, %rbx
	xorq	%rbx, %r12
	orq	%r12, %rbx
	xorq	%r13, %rbx
	xorq	%rbx, %r12
	orq	%r12, %rbx
	xorq	%r13, %rbx
	xorq	%rbx, %r12
	orq	%r12, %rbx
	xorq	%r13, %rbx
	xorq	%rbx, %r12
	orq	%r12, %rbx
	xorq	%r13, %rbx
	xorq	%rbx, %r12
	orq	%r12, %rbx
	xorq	%r13, %rbx
	xorq	%rbx, %r12
	orq	%r12, %rbx
	xorq	%r13, %rbx
	xorq	%rbx, %r12
	orq	%r12, %rbx
	xorq	%r13, %rbx
	xorq	%rbx, %r12
	orq	%r12, %rbx
	xorq	%r13, %rbx
	xorq	%rbx, %r12
	orq	%r12, %rbx
	xorq	%r13, %rbx
	xorq	%rbx, %r12
	orq	%r12, %rbx
	xorq	%r13, %rbx
	xorq	%rbx, %r12
	orq	%r12, %rbx
	xorq	%r13, %rbx
	xorq	%rbx, %r12
	orq	%r12, %rbx
	xorq	%r13, %rbx
	xorq	%rbx, %r12
	orq	%r12, %rbx
	xorq	%r13, %rbx
	xorq	%rbx, %r12
	orq	%r12, %rbx
	xorq	%r13, %rbx
	xorq	%rbx, %r12
	orq	%r12, %rbx
	xorq	%r13, %rbx
	xorq	%rbx, %r12
	orq	%r12, %rbx
	xorq	%r13, %rbx
	xorq	%rbx, %r12
	orq	%r12, %rbx
	xorq	%r13, %rbx
	xorq	%rbx, %r12
	orq	%r12, %rbx
	xorq	%r13, %rbx
	xorq	%rbx, %r12
	orq	%r12, %rbx
	xorq	%r13, %rbx
	xorq	%rbx, %r12
	orq	%r12, %rbx
	xorq	%r13, %rbx
	xorq	%rbx, %r12
	orq	%r12, %rbx
	xorq	%r13, %rbx
	xorq	%rbx, %r12
	orq	%r12, %rbx
	xorq	%r13, %rbx
	xorq	%rbx, %r12
	orq	%r12, %rbx
	xorq	%r13, %rbx
	xorq	%rbx, %r12
	orq	%r12, %rbx
	xorq	%r13, %rbx
	xorq	%rbx, %r12
	orq	%r12, %rbx
	xorq	%r13, %rbx
	xorq	%rbx, %r12
	orq	%r12, %rbx
	xorq	%r13, %rbx
	xorq	%rbx, %r12
	orq	%r12, %rbx
	xorq	%r13, %rbx
	xorq	%rbx, %r12
	orq	%r12, %rbx
	xorq	%r13, %rbx
	xorq	%rbx, %r12
	orq	%r12, %rbx
	xorq	%r13, %rbx
	xorq	%rbx, %r12
	orq	%r12, %rbx
	xorq	%r13, %rbx
	xorq	%rbx, %r12
	orq	%r12, %rbx
	xorq	%r13, %rbx
	xorq	%rbx, %r12
	orq	%r12, %rbx
	xorq	%r13, %rbx
	xorq	%rbx, %r12
	orq	%r12, %rbx
	xorq	%r13, %rbx
	xorq	%rbx, %r12
	orq	%r12, %rbx
	xorq	%r13, %rbx
	xorq	%rbx, %r12
	orq	%r12, %rbx
	xorq	%r13, %rbx
	xorq	%rbx, %r12
	orq	%r12, %rbx
	xorq	%r13, %rbx
	xorq	%rbx, %r12
	orq	%r12, %rbx
	xorq	%r13, %rbx
	xorq	%rbx, %r12
	orq	%r12, %rbx
	xorq	%r13, %rbx
	xorq	%rbx, %r12
	orq	%r12, %rbx
	xorq	%r13, %rbx
	xorq	%rbx, %r12
	orq	%r12, %rbx
	xorq	%r13, %rbx
	xorq	%rbx, %r12
	orq	%r12, %rbx
	xorq	%r13, %rbx
	xorq	%rbx, %r12
	orq	%r12, %rbx
	xorq	%r13, %rbx
	xorq	%rbx, %r12
	orq	%r12, %rbx
	xorq	%r13, %rbx
	xorq	%rbx, %r12
	orq	%r12, %rbx
	xorq	%r13, %rbx
	xorq	%rbx, %r12
	orq	%r12, %rbx
	xorq	%r13, %rbx
	xorq	%rbx, %r12
	orq	%r12, %rbx
	xorq	%r13, %rbx
	xorq	%rbx, %r12
	orq	%r12, %rbx
	xorq	%r13, %rbx
	xorq	%rbx, %r12
	orq	%r12, %rbx
	xorq	%r13, %rbx
	xorq	%rbx, %r12
	orq	%r12, %rbx
	xorq	%r13, %rbx
	xorq	%rbx, %r12
	orq	%r12, %rbx
	xorq	%r13, %rbx
	xorq	%rbx, %r12
	orq	%r12, %rbx
	xorq	%r13, %rbx
	xorq	%rbx, %r12
	orq	%r12, %rbx
	xorq	%r13, %rbx
	xorq	%rbx, %r12
	orq	%r12, %rbx
	xorq	%r13, %rbx
	xorq	%rbx, %r12
	orq	%r12, %rbx
	xorq	%r13, %rbx
	xorq	%rbx, %r12
	orq	%r12, %rbx
	subq	$1, %r13
.L37:
	movq	-56(%rbp), %rax
	leaq	-1(%rax), %rdx
	movq	%rdx, -56(%rbp)
	testq	%rax, %rax
	jne	.L38
	movl	%ebx, %eax
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
	.size	do_int64_bitwise, .-do_int64_bitwise
	.globl	do_int64_add
	.type	do_int64_add, @function
do_int64_add:
.LFB17:
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
	movq	-40(%rbp), %rax
	movl	(%rax), %eax
	cltq
	leaq	37420(%rax), %rbx
	movq	-40(%rbp), %rax
	movl	(%rax), %eax
	cltq
	leaq	21698324(%rax), %r13
	movq	-40(%rbp), %rax
	movl	(%rax), %eax
	addl	$254, %eax
	cltq
	salq	$30, %rax
	addq	%rax, %rbx
	movq	-40(%rbp), %rax
	movl	(%rax), %eax
	addl	$65534, %eax
	cltq
	salq	$29, %rax
	addq	%rax, %r13
	jmp	.L40
.L43:
	movl	$1, %r12d
	jmp	.L41
.L42:
	leaq	(%rbx,%rbx), %rax
	leaq	(%r12,%rax), %rbx
	leaq	(%rbx,%rbx), %rax
	leaq	(%r12,%rax), %rbx
	leaq	(%rbx,%rbx), %rax
	leaq	(%r12,%rax), %rbx
	leaq	(%rbx,%rbx), %rax
	leaq	(%r12,%rax), %rbx
	leaq	(%rbx,%rbx), %rax
	leaq	(%r12,%rax), %rbx
	leaq	(%rbx,%rbx), %rax
	leaq	(%r12,%rax), %rbx
	leaq	(%rbx,%rbx), %rax
	leaq	(%r12,%rax), %rbx
	leaq	(%rbx,%rbx), %rax
	leaq	(%r12,%rax), %rbx
	leaq	(%rbx,%rbx), %rax
	leaq	(%r12,%rax), %rbx
	leaq	(%rbx,%rbx), %rax
	leaq	(%r12,%rax), %rbx
	addq	$1, %r12
.L41:
	cmpq	$1000, %r12
	jle	.L42
.L40:
	movq	-56(%rbp), %rax
	leaq	-1(%rax), %rdx
	movq	%rdx, -56(%rbp)
	testq	%rax, %rax
	jne	.L43
	movl	%ebx, %edx
	movl	%r13d, %eax
	addl	%edx, %eax
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
.LFE17:
	.size	do_int64_add, .-do_int64_add
	.globl	do_int64_mul
	.type	do_int64_mul, @function
do_int64_mul:
.LFB18:
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
	movq	-40(%rbp), %rax
	movl	(%rax), %eax
	cltq
	leaq	37420(%rax), %rbx
	movq	-40(%rbp), %rax
	movl	(%rax), %eax
	cltq
	leaq	4(%rax), %r12
	movq	-40(%rbp), %rax
	movl	(%rax), %eax
	addl	$6, %eax
	cltq
	salq	$32, %rax
	addq	%rax, %rbx
	movq	%rbx, %rax
	imulq	%r12, %rax
	imulq	%r12, %rax
	imulq	%r12, %rax
	imulq	%r12, %rax
	imulq	%r12, %rax
	imulq	%r12, %rax
	imulq	%r12, %rax
	imulq	%r12, %rax
	imulq	%r12, %rax
	imulq	%r12, %rax
	subq	%rbx, %rax
	movq	%rax, %r13
	jmp	.L45
.L46:
	imulq	%r12, %rbx
	imulq	%r12, %rbx
	imulq	%r12, %rbx
	imulq	%r12, %rbx
	imulq	%r12, %rbx
	imulq	%r12, %rbx
	imulq	%r12, %rbx
	imulq	%r12, %rbx
	imulq	%r12, %rbx
	imulq	%r12, %rbx
	subq	%r13, %rbx
	imulq	%r12, %rbx
	imulq	%r12, %rbx
	imulq	%r12, %rbx
	imulq	%r12, %rbx
	imulq	%r12, %rbx
	imulq	%r12, %rbx
	imulq	%r12, %rbx
	imulq	%r12, %rbx
	imulq	%r12, %rbx
	imulq	%r12, %rbx
	subq	%r13, %rbx
.L45:
	movq	-56(%rbp), %rax
	leaq	-1(%rax), %rdx
	movq	%rdx, -56(%rbp)
	testq	%rax, %rax
	jne	.L46
	movl	%ebx, %eax
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
.LFE18:
	.size	do_int64_mul, .-do_int64_mul
	.globl	do_int64_div
	.type	do_int64_div, @function
do_int64_div:
.LFB19:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r12
	pushq	%rbx
	subq	$32, %rsp
	.cfi_offset 12, -24
	.cfi_offset 3, -32
	movq	%rdi, -40(%rbp)
	movq	%rsi, -48(%rbp)
	movq	-48(%rbp), %rax
	movq	%rax, -24(%rbp)
	movq	-24(%rbp), %rax
	movl	(%rax), %eax
	cltq
	leaq	36(%rax), %rbx
	movq	%rbx, %rax
	salq	$33, %rax
	addq	%rax, %rbx
	leaq	17(%rbx), %rax
	salq	$13, %rax
	movq	%rax, %r12
	jmp	.L48
.L49:
	movq	%r12, %rax
	cqto
	idivq	%rbx
	movq	%rax, %rbx
	movq	%r12, %rax
	cqto
	idivq	%rbx
	movq	%rax, %rbx
	movq	%r12, %rax
	cqto
	idivq	%rbx
	movq	%rax, %rbx
	movq	%r12, %rax
	cqto
	idivq	%rbx
	movq	%rax, %rbx
	movq	%r12, %rax
	cqto
	idivq	%rbx
	movq	%rax, %rbx
	movq	%r12, %rax
	cqto
	idivq	%rbx
	movq	%rax, %rbx
	movq	%r12, %rax
	cqto
	idivq	%rbx
	movq	%rax, %rbx
	movq	%r12, %rax
	cqto
	idivq	%rbx
	movq	%rax, %rbx
	movq	%r12, %rax
	cqto
	idivq	%rbx
	movq	%rax, %rbx
	movq	%r12, %rax
	cqto
	idivq	%rbx
	movq	%rax, %rbx
	movq	%r12, %rax
	cqto
	idivq	%rbx
	movq	%rax, %rbx
	movq	%r12, %rax
	cqto
	idivq	%rbx
	movq	%rax, %rbx
	movq	%r12, %rax
	cqto
	idivq	%rbx
	movq	%rax, %rbx
	movq	%r12, %rax
	cqto
	idivq	%rbx
	movq	%rax, %rbx
	movq	%r12, %rax
	cqto
	idivq	%rbx
	movq	%rax, %rbx
	movq	%r12, %rax
	cqto
	idivq	%rbx
	movq	%rax, %rbx
	movq	%r12, %rax
	cqto
	idivq	%rbx
	movq	%rax, %rbx
	movq	%r12, %rax
	cqto
	idivq	%rbx
	movq	%rax, %rbx
	movq	%r12, %rax
	cqto
	idivq	%rbx
	movq	%rax, %rbx
	movq	%r12, %rax
	cqto
	idivq	%rbx
	movq	%rax, %rbx
	movq	%r12, %rax
	cqto
	idivq	%rbx
	movq	%rax, %rbx
	movq	%r12, %rax
	cqto
	idivq	%rbx
	movq	%rax, %rbx
	movq	%r12, %rax
	cqto
	idivq	%rbx
	movq	%rax, %rbx
	movq	%r12, %rax
	cqto
	idivq	%rbx
	movq	%rax, %rbx
	movq	%r12, %rax
	cqto
	idivq	%rbx
	movq	%rax, %rbx
	movq	%r12, %rax
	cqto
	idivq	%rbx
	movq	%rax, %rbx
	movq	%r12, %rax
	cqto
	idivq	%rbx
	movq	%rax, %rbx
	movq	%r12, %rax
	cqto
	idivq	%rbx
	movq	%rax, %rbx
	movq	%r12, %rax
	cqto
	idivq	%rbx
	movq	%rax, %rbx
	movq	%r12, %rax
	cqto
	idivq	%rbx
	movq	%rax, %rbx
	movq	%r12, %rax
	cqto
	idivq	%rbx
	movq	%rax, %rbx
	movq	%r12, %rax
	cqto
	idivq	%rbx
	movq	%rax, %rbx
	movq	%r12, %rax
	cqto
	idivq	%rbx
	movq	%rax, %rbx
	movq	%r12, %rax
	cqto
	idivq	%rbx
	movq	%rax, %rbx
	movq	%r12, %rax
	cqto
	idivq	%rbx
	movq	%rax, %rbx
	movq	%r12, %rax
	cqto
	idivq	%rbx
	movq	%rax, %rbx
	movq	%r12, %rax
	cqto
	idivq	%rbx
	movq	%rax, %rbx
	movq	%r12, %rax
	cqto
	idivq	%rbx
	movq	%rax, %rbx
	movq	%r12, %rax
	cqto
	idivq	%rbx
	movq	%rax, %rbx
	movq	%r12, %rax
	cqto
	idivq	%rbx
	movq	%rax, %rbx
	movq	%r12, %rax
	cqto
	idivq	%rbx
	movq	%rax, %rbx
	movq	%r12, %rax
	cqto
	idivq	%rbx
	movq	%rax, %rbx
	movq	%r12, %rax
	cqto
	idivq	%rbx
	movq	%rax, %rbx
	movq	%r12, %rax
	cqto
	idivq	%rbx
	movq	%rax, %rbx
	movq	%r12, %rax
	cqto
	idivq	%rbx
	movq	%rax, %rbx
	movq	%r12, %rax
	cqto
	idivq	%rbx
	movq	%rax, %rbx
	movq	%r12, %rax
	cqto
	idivq	%rbx
	movq	%rax, %rbx
	movq	%r12, %rax
	cqto
	idivq	%rbx
	movq	%rax, %rbx
	movq	%r12, %rax
	cqto
	idivq	%rbx
	movq	%rax, %rbx
	movq	%r12, %rax
	cqto
	idivq	%rbx
	movq	%rax, %rbx
	movq	%r12, %rax
	cqto
	idivq	%rbx
	movq	%rax, %rbx
	movq	%r12, %rax
	cqto
	idivq	%rbx
	movq	%rax, %rbx
	movq	%r12, %rax
	cqto
	idivq	%rbx
	movq	%rax, %rbx
	movq	%r12, %rax
	cqto
	idivq	%rbx
	movq	%rax, %rbx
	movq	%r12, %rax
	cqto
	idivq	%rbx
	movq	%rax, %rbx
	movq	%r12, %rax
	cqto
	idivq	%rbx
	movq	%rax, %rbx
	movq	%r12, %rax
	cqto
	idivq	%rbx
	movq	%rax, %rbx
	movq	%r12, %rax
	cqto
	idivq	%rbx
	movq	%rax, %rbx
	movq	%r12, %rax
	cqto
	idivq	%rbx
	movq	%rax, %rbx
	movq	%r12, %rax
	cqto
	idivq	%rbx
	movq	%rax, %rbx
	movq	%r12, %rax
	cqto
	idivq	%rbx
	movq	%rax, %rbx
	movq	%r12, %rax
	cqto
	idivq	%rbx
	movq	%rax, %rbx
	movq	%r12, %rax
	cqto
	idivq	%rbx
	movq	%rax, %rbx
	movq	%r12, %rax
	cqto
	idivq	%rbx
	movq	%rax, %rbx
	movq	%r12, %rax
	cqto
	idivq	%rbx
	movq	%rax, %rbx
	movq	%r12, %rax
	cqto
	idivq	%rbx
	movq	%rax, %rbx
	movq	%r12, %rax
	cqto
	idivq	%rbx
	movq	%rax, %rbx
	movq	%r12, %rax
	cqto
	idivq	%rbx
	movq	%rax, %rbx
	movq	%r12, %rax
	cqto
	idivq	%rbx
	movq	%rax, %rbx
	movq	%r12, %rax
	cqto
	idivq	%rbx
	movq	%rax, %rbx
	movq	%r12, %rax
	cqto
	idivq	%rbx
	movq	%rax, %rbx
	movq	%r12, %rax
	cqto
	idivq	%rbx
	movq	%rax, %rbx
	movq	%r12, %rax
	cqto
	idivq	%rbx
	movq	%rax, %rbx
	movq	%r12, %rax
	cqto
	idivq	%rbx
	movq	%rax, %rbx
	movq	%r12, %rax
	cqto
	idivq	%rbx
	movq	%rax, %rbx
	movq	%r12, %rax
	cqto
	idivq	%rbx
	movq	%rax, %rbx
	movq	%r12, %rax
	cqto
	idivq	%rbx
	movq	%rax, %rbx
	movq	%r12, %rax
	cqto
	idivq	%rbx
	movq	%rax, %rbx
	movq	%r12, %rax
	cqto
	idivq	%rbx
	movq	%rax, %rbx
	movq	%r12, %rax
	cqto
	idivq	%rbx
	movq	%rax, %rbx
	movq	%r12, %rax
	cqto
	idivq	%rbx
	movq	%rax, %rbx
	movq	%r12, %rax
	cqto
	idivq	%rbx
	movq	%rax, %rbx
	movq	%r12, %rax
	cqto
	idivq	%rbx
	movq	%rax, %rbx
	movq	%r12, %rax
	cqto
	idivq	%rbx
	movq	%rax, %rbx
	movq	%r12, %rax
	cqto
	idivq	%rbx
	movq	%rax, %rbx
	movq	%r12, %rax
	cqto
	idivq	%rbx
	movq	%rax, %rbx
	movq	%r12, %rax
	cqto
	idivq	%rbx
	movq	%rax, %rbx
	movq	%r12, %rax
	cqto
	idivq	%rbx
	movq	%rax, %rbx
	movq	%r12, %rax
	cqto
	idivq	%rbx
	movq	%rax, %rbx
	movq	%r12, %rax
	cqto
	idivq	%rbx
	movq	%rax, %rbx
	movq	%r12, %rax
	cqto
	idivq	%rbx
	movq	%rax, %rbx
	movq	%r12, %rax
	cqto
	idivq	%rbx
	movq	%rax, %rbx
	movq	%r12, %rax
	cqto
	idivq	%rbx
	movq	%rax, %rbx
	movq	%r12, %rax
	cqto
	idivq	%rbx
	movq	%rax, %rbx
	movq	%r12, %rax
	cqto
	idivq	%rbx
	movq	%rax, %rbx
	movq	%r12, %rax
	cqto
	idivq	%rbx
	movq	%rax, %rbx
	movq	%r12, %rax
	cqto
	idivq	%rbx
	movq	%rax, %rbx
	movq	%r12, %rax
	cqto
	idivq	%rbx
	movq	%rax, %rbx
	movq	%r12, %rax
	cqto
	idivq	%rbx
	movq	%rax, %rbx
	movq	%r12, %rax
	cqto
	idivq	%rbx
	movq	%rax, %rbx
.L48:
	movq	-40(%rbp), %rax
	leaq	-1(%rax), %rdx
	movq	%rdx, -40(%rbp)
	testq	%rax, %rax
	jne	.L49
	movl	%ebx, %eax
	movl	%eax, %edi
	call	use_int@PLT
	nop
	addq	$32, %rsp
	popq	%rbx
	popq	%r12
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE19:
	.size	do_int64_div, .-do_int64_div
	.globl	do_int64_mod
	.type	do_int64_mod, @function
do_int64_mod:
.LFB20:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r12
	pushq	%rbx
	subq	$32, %rsp
	.cfi_offset 12, -24
	.cfi_offset 3, -32
	movq	%rdi, -40(%rbp)
	movq	%rsi, -48(%rbp)
	movq	-48(%rbp), %rax
	movq	%rax, -24(%rbp)
	movq	-40(%rbp), %rax
	salq	$32, %rax
	movq	%rax, %rdx
	movq	-40(%rbp), %rax
	addq	%rdx, %rax
	movq	%rax, %rbx
	movq	-24(%rbp), %rax
	movl	(%rax), %eax
	movslq	%eax, %rdx
	movq	-24(%rbp), %rax
	movl	(%rax), %eax
	cltq
	salq	$56, %rax
	leaq	(%rdx,%rax), %r12
	jmp	.L51
.L52:
	movq	%rbx, %rax
	cqto
	idivq	%r12
	movq	%rdx, %rbx
	orq	%r12, %rbx
	movq	%rbx, %rax
	cqto
	idivq	%r12
	movq	%rdx, %rbx
	orq	%r12, %rbx
	movq	%rbx, %rax
	cqto
	idivq	%r12
	movq	%rdx, %rbx
	orq	%r12, %rbx
	movq	%rbx, %rax
	cqto
	idivq	%r12
	movq	%rdx, %rbx
	orq	%r12, %rbx
	movq	%rbx, %rax
	cqto
	idivq	%r12
	movq	%rdx, %rbx
	orq	%r12, %rbx
	movq	%rbx, %rax
	cqto
	idivq	%r12
	movq	%rdx, %rbx
	orq	%r12, %rbx
	movq	%rbx, %rax
	cqto
	idivq	%r12
	movq	%rdx, %rbx
	orq	%r12, %rbx
	movq	%rbx, %rax
	cqto
	idivq	%r12
	movq	%rdx, %rbx
	orq	%r12, %rbx
	movq	%rbx, %rax
	cqto
	idivq	%r12
	movq	%rdx, %rbx
	orq	%r12, %rbx
	movq	%rbx, %rax
	cqto
	idivq	%r12
	movq	%rdx, %rbx
	orq	%r12, %rbx
	movq	%rbx, %rax
	cqto
	idivq	%r12
	movq	%rdx, %rbx
	orq	%r12, %rbx
	movq	%rbx, %rax
	cqto
	idivq	%r12
	movq	%rdx, %rbx
	orq	%r12, %rbx
	movq	%rbx, %rax
	cqto
	idivq	%r12
	movq	%rdx, %rbx
	orq	%r12, %rbx
	movq	%rbx, %rax
	cqto
	idivq	%r12
	movq	%rdx, %rbx
	orq	%r12, %rbx
	movq	%rbx, %rax
	cqto
	idivq	%r12
	movq	%rdx, %rbx
	orq	%r12, %rbx
	movq	%rbx, %rax
	cqto
	idivq	%r12
	movq	%rdx, %rbx
	orq	%r12, %rbx
	movq	%rbx, %rax
	cqto
	idivq	%r12
	movq	%rdx, %rbx
	orq	%r12, %rbx
	movq	%rbx, %rax
	cqto
	idivq	%r12
	movq	%rdx, %rbx
	orq	%r12, %rbx
	movq	%rbx, %rax
	cqto
	idivq	%r12
	movq	%rdx, %rbx
	orq	%r12, %rbx
	movq	%rbx, %rax
	cqto
	idivq	%r12
	movq	%rdx, %rbx
	orq	%r12, %rbx
	movq	%rbx, %rax
	cqto
	idivq	%r12
	movq	%rdx, %rbx
	orq	%r12, %rbx
	movq	%rbx, %rax
	cqto
	idivq	%r12
	movq	%rdx, %rbx
	orq	%r12, %rbx
	movq	%rbx, %rax
	cqto
	idivq	%r12
	movq	%rdx, %rbx
	orq	%r12, %rbx
	movq	%rbx, %rax
	cqto
	idivq	%r12
	movq	%rdx, %rbx
	orq	%r12, %rbx
	movq	%rbx, %rax
	cqto
	idivq	%r12
	movq	%rdx, %rbx
	orq	%r12, %rbx
	movq	%rbx, %rax
	cqto
	idivq	%r12
	movq	%rdx, %rbx
	orq	%r12, %rbx
	movq	%rbx, %rax
	cqto
	idivq	%r12
	movq	%rdx, %rbx
	orq	%r12, %rbx
	movq	%rbx, %rax
	cqto
	idivq	%r12
	movq	%rdx, %rbx
	orq	%r12, %rbx
	movq	%rbx, %rax
	cqto
	idivq	%r12
	movq	%rdx, %rbx
	orq	%r12, %rbx
	movq	%rbx, %rax
	cqto
	idivq	%r12
	movq	%rdx, %rbx
	orq	%r12, %rbx
	movq	%rbx, %rax
	cqto
	idivq	%r12
	movq	%rdx, %rbx
	orq	%r12, %rbx
	movq	%rbx, %rax
	cqto
	idivq	%r12
	movq	%rdx, %rbx
	orq	%r12, %rbx
	movq	%rbx, %rax
	cqto
	idivq	%r12
	movq	%rdx, %rbx
	orq	%r12, %rbx
	movq	%rbx, %rax
	cqto
	idivq	%r12
	movq	%rdx, %rbx
	orq	%r12, %rbx
	movq	%rbx, %rax
	cqto
	idivq	%r12
	movq	%rdx, %rbx
	orq	%r12, %rbx
	movq	%rbx, %rax
	cqto
	idivq	%r12
	movq	%rdx, %rbx
	orq	%r12, %rbx
	movq	%rbx, %rax
	cqto
	idivq	%r12
	movq	%rdx, %rbx
	orq	%r12, %rbx
	movq	%rbx, %rax
	cqto
	idivq	%r12
	movq	%rdx, %rbx
	orq	%r12, %rbx
	movq	%rbx, %rax
	cqto
	idivq	%r12
	movq	%rdx, %rbx
	orq	%r12, %rbx
	movq	%rbx, %rax
	cqto
	idivq	%r12
	movq	%rdx, %rbx
	orq	%r12, %rbx
	movq	%rbx, %rax
	cqto
	idivq	%r12
	movq	%rdx, %rbx
	orq	%r12, %rbx
	movq	%rbx, %rax
	cqto
	idivq	%r12
	movq	%rdx, %rbx
	orq	%r12, %rbx
	movq	%rbx, %rax
	cqto
	idivq	%r12
	movq	%rdx, %rbx
	orq	%r12, %rbx
	movq	%rbx, %rax
	cqto
	idivq	%r12
	movq	%rdx, %rbx
	orq	%r12, %rbx
	movq	%rbx, %rax
	cqto
	idivq	%r12
	movq	%rdx, %rbx
	orq	%r12, %rbx
	movq	%rbx, %rax
	cqto
	idivq	%r12
	movq	%rdx, %rbx
	orq	%r12, %rbx
	movq	%rbx, %rax
	cqto
	idivq	%r12
	movq	%rdx, %rbx
	orq	%r12, %rbx
	movq	%rbx, %rax
	cqto
	idivq	%r12
	movq	%rdx, %rbx
	orq	%r12, %rbx
	movq	%rbx, %rax
	cqto
	idivq	%r12
	movq	%rdx, %rbx
	orq	%r12, %rbx
	movq	%rbx, %rax
	cqto
	idivq	%r12
	movq	%rdx, %rbx
	orq	%r12, %rbx
	movq	%rbx, %rax
	cqto
	idivq	%r12
	movq	%rdx, %rbx
	orq	%r12, %rbx
	movq	%rbx, %rax
	cqto
	idivq	%r12
	movq	%rdx, %rbx
	orq	%r12, %rbx
	movq	%rbx, %rax
	cqto
	idivq	%r12
	movq	%rdx, %rbx
	orq	%r12, %rbx
	movq	%rbx, %rax
	cqto
	idivq	%r12
	movq	%rdx, %rbx
	orq	%r12, %rbx
	movq	%rbx, %rax
	cqto
	idivq	%r12
	movq	%rdx, %rbx
	orq	%r12, %rbx
	movq	%rbx, %rax
	cqto
	idivq	%r12
	movq	%rdx, %rbx
	orq	%r12, %rbx
	movq	%rbx, %rax
	cqto
	idivq	%r12
	movq	%rdx, %rbx
	orq	%r12, %rbx
	movq	%rbx, %rax
	cqto
	idivq	%r12
	movq	%rdx, %rbx
	orq	%r12, %rbx
	movq	%rbx, %rax
	cqto
	idivq	%r12
	movq	%rdx, %rbx
	orq	%r12, %rbx
	movq	%rbx, %rax
	cqto
	idivq	%r12
	movq	%rdx, %rbx
	orq	%r12, %rbx
	movq	%rbx, %rax
	cqto
	idivq	%r12
	movq	%rdx, %rbx
	orq	%r12, %rbx
	movq	%rbx, %rax
	cqto
	idivq	%r12
	movq	%rdx, %rbx
	orq	%r12, %rbx
	movq	%rbx, %rax
	cqto
	idivq	%r12
	movq	%rdx, %rbx
	orq	%r12, %rbx
	movq	%rbx, %rax
	cqto
	idivq	%r12
	movq	%rdx, %rbx
	orq	%r12, %rbx
	movq	%rbx, %rax
	cqto
	idivq	%r12
	movq	%rdx, %rbx
	orq	%r12, %rbx
	movq	%rbx, %rax
	cqto
	idivq	%r12
	movq	%rdx, %rbx
	orq	%r12, %rbx
	movq	%rbx, %rax
	cqto
	idivq	%r12
	movq	%rdx, %rbx
	orq	%r12, %rbx
	movq	%rbx, %rax
	cqto
	idivq	%r12
	movq	%rdx, %rbx
	orq	%r12, %rbx
	movq	%rbx, %rax
	cqto
	idivq	%r12
	movq	%rdx, %rbx
	orq	%r12, %rbx
	movq	%rbx, %rax
	cqto
	idivq	%r12
	movq	%rdx, %rbx
	orq	%r12, %rbx
	movq	%rbx, %rax
	cqto
	idivq	%r12
	movq	%rdx, %rbx
	orq	%r12, %rbx
	movq	%rbx, %rax
	cqto
	idivq	%r12
	movq	%rdx, %rbx
	orq	%r12, %rbx
	movq	%rbx, %rax
	cqto
	idivq	%r12
	movq	%rdx, %rbx
	orq	%r12, %rbx
	movq	%rbx, %rax
	cqto
	idivq	%r12
	movq	%rdx, %rbx
	orq	%r12, %rbx
	movq	%rbx, %rax
	cqto
	idivq	%r12
	movq	%rdx, %rbx
	orq	%r12, %rbx
	movq	%rbx, %rax
	cqto
	idivq	%r12
	movq	%rdx, %rbx
	orq	%r12, %rbx
	movq	%rbx, %rax
	cqto
	idivq	%r12
	movq	%rdx, %rbx
	orq	%r12, %rbx
	movq	%rbx, %rax
	cqto
	idivq	%r12
	movq	%rdx, %rbx
	orq	%r12, %rbx
	movq	%rbx, %rax
	cqto
	idivq	%r12
	movq	%rdx, %rbx
	orq	%r12, %rbx
	movq	%rbx, %rax
	cqto
	idivq	%r12
	movq	%rdx, %rbx
	orq	%r12, %rbx
	movq	%rbx, %rax
	cqto
	idivq	%r12
	movq	%rdx, %rbx
	orq	%r12, %rbx
	movq	%rbx, %rax
	cqto
	idivq	%r12
	movq	%rdx, %rbx
	orq	%r12, %rbx
	movq	%rbx, %rax
	cqto
	idivq	%r12
	movq	%rdx, %rbx
	orq	%r12, %rbx
	movq	%rbx, %rax
	cqto
	idivq	%r12
	movq	%rdx, %rbx
	orq	%r12, %rbx
	movq	%rbx, %rax
	cqto
	idivq	%r12
	movq	%rdx, %rbx
	orq	%r12, %rbx
	movq	%rbx, %rax
	cqto
	idivq	%r12
	movq	%rdx, %rbx
	orq	%r12, %rbx
	movq	%rbx, %rax
	cqto
	idivq	%r12
	movq	%rdx, %rbx
	orq	%r12, %rbx
	movq	%rbx, %rax
	cqto
	idivq	%r12
	movq	%rdx, %rbx
	orq	%r12, %rbx
	movq	%rbx, %rax
	cqto
	idivq	%r12
	movq	%rdx, %rbx
	orq	%r12, %rbx
	movq	%rbx, %rax
	cqto
	idivq	%r12
	movq	%rdx, %rbx
	orq	%r12, %rbx
	movq	%rbx, %rax
	cqto
	idivq	%r12
	movq	%rdx, %rbx
	orq	%r12, %rbx
	movq	%rbx, %rax
	cqto
	idivq	%r12
	movq	%rdx, %rbx
	orq	%r12, %rbx
	movq	%rbx, %rax
	cqto
	idivq	%r12
	movq	%rdx, %rbx
	orq	%r12, %rbx
	movq	%rbx, %rax
	cqto
	idivq	%r12
	movq	%rdx, %rbx
	orq	%r12, %rbx
	movq	%rbx, %rax
	cqto
	idivq	%r12
	movq	%rdx, %rbx
	orq	%r12, %rbx
	movq	%rbx, %rax
	cqto
	idivq	%r12
	movq	%rdx, %rbx
	orq	%r12, %rbx
	movq	%rbx, %rax
	cqto
	idivq	%r12
	movq	%rdx, %rbx
	orq	%r12, %rbx
	movq	%rbx, %rax
	cqto
	idivq	%r12
	movq	%rdx, %rbx
	orq	%r12, %rbx
	movq	%rbx, %rax
	cqto
	idivq	%r12
	movq	%rdx, %rbx
	orq	%r12, %rbx
	movq	%rbx, %rax
	cqto
	idivq	%r12
	movq	%rdx, %rbx
	orq	%r12, %rbx
.L51:
	movq	-40(%rbp), %rax
	leaq	-1(%rax), %rdx
	movq	%rdx, -40(%rbp)
	testq	%rax, %rax
	jne	.L52
	movl	%ebx, %eax
	movl	%eax, %edi
	call	use_int@PLT
	nop
	addq	$32, %rsp
	popq	%rbx
	popq	%r12
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE20:
	.size	do_int64_mod, .-do_int64_mod
	.globl	do_float_add
	.type	do_float_add, @function
do_float_add:
.LFB21:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$48, %rsp
	movq	%rdi, -24(%rbp)
	movq	%rsi, -32(%rbp)
	movq	-32(%rbp), %rax
	movq	%rax, -8(%rbp)
	movq	-8(%rbp), %rax
	movl	(%rax), %eax
	pxor	%xmm5, %xmm5
	cvtsi2ssl	%eax, %xmm5
	movaps	%xmm5, %xmm7
	movq	-8(%rbp), %rax
	movl	8(%rax), %eax
	pxor	%xmm6, %xmm6
	cvtsi2ssl	%eax, %xmm6
	movss	%xmm6, -36(%rbp)
	jmp	.L54
.L55:
	movaps	%xmm7, %xmm4
	movaps	%xmm4, %xmm0
	addss	%xmm4, %xmm0
	movaps	%xmm0, %xmm1
	addss	%xmm0, %xmm1
	movaps	%xmm1, %xmm2
	addss	%xmm1, %xmm2
	movaps	%xmm2, %xmm3
	addss	%xmm2, %xmm3
	movaps	%xmm3, %xmm4
	addss	%xmm3, %xmm4
	movaps	%xmm4, %xmm5
	addss	%xmm4, %xmm5
	movaps	%xmm5, %xmm6
	addss	%xmm5, %xmm6
	movaps	%xmm6, %xmm7
	addss	%xmm6, %xmm7
	movaps	%xmm7, %xmm0
	addss	%xmm7, %xmm0
	movaps	%xmm0, %xmm1
	addss	%xmm0, %xmm1
	movss	-36(%rbp), %xmm8
	addss	%xmm8, %xmm1
	movaps	%xmm1, %xmm2
	addss	%xmm1, %xmm2
	movaps	%xmm2, %xmm3
	addss	%xmm2, %xmm3
	movaps	%xmm3, %xmm4
	addss	%xmm3, %xmm4
	movaps	%xmm4, %xmm5
	addss	%xmm4, %xmm5
	movaps	%xmm5, %xmm6
	addss	%xmm5, %xmm6
	movaps	%xmm6, %xmm7
	addss	%xmm6, %xmm7
	movaps	%xmm7, %xmm0
	addss	%xmm7, %xmm0
	movaps	%xmm0, %xmm1
	addss	%xmm0, %xmm1
	movaps	%xmm1, %xmm2
	addss	%xmm1, %xmm2
	movaps	%xmm2, %xmm3
	addss	%xmm2, %xmm3
	addss	%xmm8, %xmm3
	movaps	%xmm3, %xmm7
.L54:
	movq	-24(%rbp), %rax
	leaq	-1(%rax), %rdx
	movq	%rdx, -24(%rbp)
	testq	%rax, %rax
	jne	.L55
	cvttss2sil	%xmm7, %eax
	movl	%eax, %edi
	call	use_int@PLT
	cvttss2sil	-36(%rbp), %eax
	movl	%eax, %edi
	call	use_int@PLT
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE21:
	.size	do_float_add, .-do_float_add
	.globl	do_float_mul
	.type	do_float_mul, @function
do_float_mul:
.LFB22:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$48, %rsp
	movq	%rdi, -24(%rbp)
	movq	%rsi, -32(%rbp)
	movq	-32(%rbp), %rax
	movq	%rax, -8(%rbp)
	movq	-8(%rbp), %rax
	movl	(%rax), %eax
	pxor	%xmm1, %xmm1
	cvtsi2ssl	%eax, %xmm1
	movss	.LC4(%rip), %xmm0
	mulss	%xmm0, %xmm1
	movaps	%xmm1, %xmm5
	movq	-8(%rbp), %rax
	movl	4(%rax), %eax
	pxor	%xmm1, %xmm1
	cvtsi2ssl	%eax, %xmm1
	movss	.LC5(%rip), %xmm0
	mulss	%xmm1, %xmm0
	movss	.LC6(%rip), %xmm1
	divss	%xmm1, %xmm0
	movss	%xmm0, -36(%rbp)
	jmp	.L57
.L58:
	movaps	%xmm5, %xmm6
	movaps	%xmm6, %xmm2
	mulss	%xmm6, %xmm2
	movss	-36(%rbp), %xmm0
	mulss	%xmm0, %xmm2
	movaps	%xmm2, %xmm3
	mulss	%xmm2, %xmm3
	mulss	%xmm0, %xmm3
	movaps	%xmm3, %xmm4
	mulss	%xmm3, %xmm4
	mulss	%xmm0, %xmm4
	movaps	%xmm4, %xmm5
	mulss	%xmm4, %xmm5
	mulss	%xmm0, %xmm5
	movaps	%xmm5, %xmm6
	mulss	%xmm5, %xmm6
	mulss	%xmm0, %xmm6
	movaps	%xmm6, %xmm7
	mulss	%xmm6, %xmm7
	movaps	%xmm0, %xmm6
	mulss	%xmm6, %xmm7
	movaps	%xmm7, %xmm2
	mulss	%xmm7, %xmm2
	movaps	%xmm0, %xmm6
	mulss	%xmm6, %xmm2
	movaps	%xmm2, %xmm0
	mulss	%xmm2, %xmm0
	mulss	%xmm6, %xmm0
	movaps	%xmm0, %xmm1
	mulss	%xmm0, %xmm1
	movaps	%xmm6, %xmm0
	mulss	%xmm0, %xmm1
	movaps	%xmm1, %xmm3
	mulss	%xmm1, %xmm3
	movaps	%xmm6, %xmm0
	mulss	%xmm0, %xmm3
	movaps	%xmm3, %xmm4
	mulss	%xmm3, %xmm4
	mulss	%xmm0, %xmm4
	movaps	%xmm4, %xmm5
	mulss	%xmm4, %xmm5
	mulss	%xmm0, %xmm5
	movaps	%xmm5, %xmm6
	mulss	%xmm5, %xmm6
	mulss	%xmm0, %xmm6
	movaps	%xmm6, %xmm7
	mulss	%xmm6, %xmm7
	movaps	%xmm0, %xmm6
	mulss	%xmm6, %xmm7
	movaps	%xmm7, %xmm2
	mulss	%xmm7, %xmm2
	movaps	%xmm0, %xmm6
	movaps	%xmm6, %xmm7
	mulss	%xmm7, %xmm2
	movaps	%xmm2, %xmm0
	mulss	%xmm2, %xmm0
	movaps	%xmm6, %xmm7
	mulss	%xmm7, %xmm0
	movaps	%xmm0, %xmm1
	mulss	%xmm0, %xmm1
	mulss	%xmm7, %xmm1
	movaps	%xmm1, %xmm3
	mulss	%xmm1, %xmm3
	mulss	%xmm7, %xmm3
	movaps	%xmm3, %xmm4
	mulss	%xmm3, %xmm4
	mulss	%xmm7, %xmm4
	movaps	%xmm4, %xmm5
	mulss	%xmm4, %xmm5
	mulss	%xmm7, %xmm5
.L57:
	movq	-24(%rbp), %rax
	leaq	-1(%rax), %rdx
	movq	%rdx, -24(%rbp)
	testq	%rax, %rax
	jne	.L58
	cvttss2sil	%xmm5, %eax
	movl	%eax, %edi
	call	use_int@PLT
	cvttss2sil	-36(%rbp), %eax
	movl	%eax, %edi
	call	use_int@PLT
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE22:
	.size	do_float_mul, .-do_float_mul
	.globl	do_float_div
	.type	do_float_div, @function
do_float_div:
.LFB23:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$48, %rsp
	movq	%rdi, -24(%rbp)
	movq	%rsi, -32(%rbp)
	movq	-32(%rbp), %rax
	movq	%rax, -8(%rbp)
	movq	-8(%rbp), %rax
	movl	(%rax), %eax
	pxor	%xmm1, %xmm1
	cvtsi2ssl	%eax, %xmm1
	movss	.LC7(%rip), %xmm0
	mulss	%xmm0, %xmm1
	movaps	%xmm1, %xmm8
	movq	-8(%rbp), %rax
	movl	4(%rax), %eax
	pxor	%xmm1, %xmm1
	cvtsi2ssl	%eax, %xmm1
	movss	.LC2(%rip), %xmm0
	mulss	%xmm1, %xmm0
	movss	.LC6(%rip), %xmm1
	divss	%xmm1, %xmm0
	movss	%xmm0, -36(%rbp)
	jmp	.L60
.L61:
	movss	-36(%rbp), %xmm4
	movaps	%xmm4, %xmm0
	movaps	%xmm8, %xmm2
	divss	%xmm2, %xmm0
	movaps	%xmm4, %xmm1
	divss	%xmm0, %xmm1
	movaps	%xmm4, %xmm0
	divss	%xmm1, %xmm0
	movaps	%xmm4, %xmm1
	divss	%xmm0, %xmm1
	movaps	%xmm4, %xmm0
	divss	%xmm1, %xmm0
	movaps	%xmm4, %xmm1
	divss	%xmm0, %xmm1
	movaps	%xmm4, %xmm0
	divss	%xmm1, %xmm0
	movaps	%xmm4, %xmm1
	divss	%xmm0, %xmm1
	movaps	%xmm4, %xmm0
	divss	%xmm1, %xmm0
	movaps	%xmm4, %xmm3
	divss	%xmm0, %xmm3
	movaps	%xmm3, %xmm1
	divss	%xmm4, %xmm1
	movaps	%xmm3, %xmm4
	divss	%xmm1, %xmm4
	movaps	%xmm3, %xmm0
	divss	%xmm4, %xmm0
	movaps	%xmm3, %xmm1
	divss	%xmm0, %xmm1
	movaps	%xmm3, %xmm0
	divss	%xmm1, %xmm0
	movaps	%xmm3, %xmm1
	divss	%xmm0, %xmm1
	movaps	%xmm3, %xmm0
	divss	%xmm1, %xmm0
	movaps	%xmm3, %xmm1
	divss	%xmm0, %xmm1
	movaps	%xmm3, %xmm0
	divss	%xmm1, %xmm0
	movaps	%xmm3, %xmm2
	divss	%xmm0, %xmm2
	movaps	%xmm2, %xmm1
	divss	%xmm3, %xmm1
	movaps	%xmm2, %xmm3
	divss	%xmm1, %xmm3
	movaps	%xmm2, %xmm6
	divss	%xmm3, %xmm6
	movaps	%xmm2, %xmm7
	divss	%xmm6, %xmm7
	movaps	%xmm2, %xmm0
	divss	%xmm7, %xmm0
	movaps	%xmm2, %xmm1
	divss	%xmm0, %xmm1
	movaps	%xmm2, %xmm6
	divss	%xmm1, %xmm6
	movaps	%xmm2, %xmm7
	divss	%xmm6, %xmm7
	movaps	%xmm2, %xmm0
	divss	%xmm7, %xmm0
	movaps	%xmm2, %xmm7
	divss	%xmm0, %xmm7
	movaps	%xmm7, %xmm1
	divss	%xmm2, %xmm1
	movaps	%xmm7, %xmm2
	divss	%xmm1, %xmm2
	movaps	%xmm7, %xmm6
	divss	%xmm2, %xmm6
	movaps	%xmm7, %xmm0
	divss	%xmm6, %xmm0
	movaps	%xmm7, %xmm1
	divss	%xmm0, %xmm1
	movaps	%xmm7, %xmm6
	divss	%xmm1, %xmm6
	movaps	%xmm7, %xmm0
	divss	%xmm6, %xmm0
	movaps	%xmm7, %xmm1
	divss	%xmm0, %xmm1
	movaps	%xmm7, %xmm6
	divss	%xmm1, %xmm6
	movaps	%xmm7, %xmm0
	divss	%xmm6, %xmm0
	movaps	%xmm0, %xmm6
	movaps	%xmm6, %xmm1
	divss	%xmm7, %xmm1
	movaps	%xmm6, %xmm7
	divss	%xmm1, %xmm7
	movaps	%xmm6, %xmm0
	divss	%xmm7, %xmm0
	movaps	%xmm6, %xmm7
	divss	%xmm0, %xmm7
	movaps	%xmm6, %xmm1
	divss	%xmm7, %xmm1
	movaps	%xmm6, %xmm7
	divss	%xmm1, %xmm7
	movaps	%xmm6, %xmm0
	divss	%xmm7, %xmm0
	movaps	%xmm6, %xmm7
	divss	%xmm0, %xmm7
	movaps	%xmm6, %xmm1
	divss	%xmm7, %xmm1
	movaps	%xmm6, %xmm5
	divss	%xmm1, %xmm5
	movaps	%xmm5, %xmm7
	divss	%xmm6, %xmm7
	movaps	%xmm5, %xmm6
	divss	%xmm7, %xmm6
	movaps	%xmm5, %xmm0
	divss	%xmm6, %xmm0
	movaps	%xmm5, %xmm6
	divss	%xmm0, %xmm6
	movaps	%xmm5, %xmm1
	divss	%xmm6, %xmm1
	movaps	%xmm5, %xmm6
	divss	%xmm1, %xmm6
	movaps	%xmm5, %xmm7
	divss	%xmm6, %xmm7
	movaps	%xmm5, %xmm6
	divss	%xmm7, %xmm6
	movaps	%xmm5, %xmm0
	divss	%xmm6, %xmm0
	movaps	%xmm5, %xmm4
	divss	%xmm0, %xmm4
	movaps	%xmm4, %xmm1
	divss	%xmm5, %xmm1
	movaps	%xmm4, %xmm5
	divss	%xmm1, %xmm5
	movaps	%xmm4, %xmm6
	divss	%xmm5, %xmm6
	movaps	%xmm4, %xmm7
	divss	%xmm6, %xmm7
	movaps	%xmm4, %xmm0
	divss	%xmm7, %xmm0
	movaps	%xmm4, %xmm1
	divss	%xmm0, %xmm1
	movaps	%xmm4, %xmm6
	divss	%xmm1, %xmm6
	movaps	%xmm4, %xmm7
	divss	%xmm6, %xmm7
	movaps	%xmm4, %xmm0
	divss	%xmm7, %xmm0
	movaps	%xmm4, %xmm3
	divss	%xmm0, %xmm3
	movaps	%xmm3, %xmm1
	divss	%xmm4, %xmm1
	movaps	%xmm3, %xmm4
	divss	%xmm1, %xmm4
	movaps	%xmm3, %xmm5
	divss	%xmm4, %xmm5
	movaps	%xmm3, %xmm6
	divss	%xmm5, %xmm6
	movaps	%xmm3, %xmm7
	divss	%xmm6, %xmm7
	movaps	%xmm3, %xmm0
	divss	%xmm7, %xmm0
	movaps	%xmm3, %xmm1
	divss	%xmm0, %xmm1
	movaps	%xmm3, %xmm2
	divss	%xmm1, %xmm2
	movaps	%xmm3, %xmm5
	divss	%xmm2, %xmm5
	movaps	%xmm3, %xmm2
	divss	%xmm5, %xmm2
	movaps	%xmm2, %xmm6
	divss	%xmm3, %xmm6
	movaps	%xmm2, %xmm3
	divss	%xmm6, %xmm3
	movaps	%xmm2, %xmm7
	divss	%xmm3, %xmm7
	movaps	%xmm2, %xmm0
	divss	%xmm7, %xmm0
	movaps	%xmm2, %xmm1
	divss	%xmm0, %xmm1
	movaps	%xmm2, %xmm4
	divss	%xmm1, %xmm4
	movaps	%xmm2, %xmm5
	divss	%xmm4, %xmm5
	movaps	%xmm2, %xmm6
	divss	%xmm5, %xmm6
	movaps	%xmm2, %xmm7
	divss	%xmm6, %xmm7
	movaps	%xmm2, %xmm5
	divss	%xmm7, %xmm5
	movaps	%xmm5, %xmm8
	movaps	%xmm5, %xmm0
	divss	%xmm2, %xmm0
	movaps	%xmm5, %xmm2
	divss	%xmm0, %xmm2
	movaps	%xmm5, %xmm1
	divss	%xmm2, %xmm1
	movaps	%xmm5, %xmm3
	divss	%xmm1, %xmm3
	movaps	%xmm5, %xmm4
	divss	%xmm3, %xmm4
	movaps	%xmm5, %xmm6
	divss	%xmm4, %xmm6
	movaps	%xmm5, %xmm7
	divss	%xmm6, %xmm7
	movaps	%xmm5, %xmm0
	divss	%xmm7, %xmm0
	movaps	%xmm5, %xmm1
	divss	%xmm0, %xmm1
	divss	%xmm1, %xmm5
	movss	%xmm5, -36(%rbp)
.L60:
	movq	-24(%rbp), %rax
	leaq	-1(%rax), %rdx
	movq	%rdx, -24(%rbp)
	testq	%rax, %rax
	jne	.L61
	cvttss2sil	%xmm8, %eax
	movl	%eax, %edi
	call	use_int@PLT
	cvttss2sil	-36(%rbp), %eax
	movl	%eax, %edi
	call	use_int@PLT
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE23:
	.size	do_float_div, .-do_float_div
	.globl	do_double_add
	.type	do_double_add, @function
do_double_add:
.LFB24:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$48, %rsp
	movq	%rdi, -24(%rbp)
	movq	%rsi, -32(%rbp)
	movq	-32(%rbp), %rax
	movq	%rax, -8(%rbp)
	movq	-8(%rbp), %rax
	movl	(%rax), %eax
	pxor	%xmm5, %xmm5
	cvtsi2sdl	%eax, %xmm5
	movapd	%xmm5, %xmm7
	movq	-8(%rbp), %rax
	movl	8(%rax), %eax
	pxor	%xmm6, %xmm6
	cvtsi2sdl	%eax, %xmm6
	movsd	%xmm6, -40(%rbp)
	jmp	.L63
.L64:
	movapd	%xmm7, %xmm4
	movapd	%xmm4, %xmm0
	addsd	%xmm4, %xmm0
	movapd	%xmm0, %xmm1
	addsd	%xmm0, %xmm1
	movapd	%xmm1, %xmm2
	addsd	%xmm1, %xmm2
	movapd	%xmm2, %xmm3
	addsd	%xmm2, %xmm3
	movapd	%xmm3, %xmm4
	addsd	%xmm3, %xmm4
	movapd	%xmm4, %xmm5
	addsd	%xmm4, %xmm5
	movapd	%xmm5, %xmm6
	addsd	%xmm5, %xmm6
	movapd	%xmm6, %xmm7
	addsd	%xmm6, %xmm7
	movapd	%xmm7, %xmm0
	addsd	%xmm7, %xmm0
	movapd	%xmm0, %xmm1
	addsd	%xmm0, %xmm1
	movsd	-40(%rbp), %xmm8
	addsd	%xmm8, %xmm1
	movapd	%xmm1, %xmm2
	addsd	%xmm1, %xmm2
	movapd	%xmm2, %xmm3
	addsd	%xmm2, %xmm3
	movapd	%xmm3, %xmm4
	addsd	%xmm3, %xmm4
	movapd	%xmm4, %xmm5
	addsd	%xmm4, %xmm5
	movapd	%xmm5, %xmm6
	addsd	%xmm5, %xmm6
	movapd	%xmm6, %xmm7
	addsd	%xmm6, %xmm7
	movapd	%xmm7, %xmm0
	addsd	%xmm7, %xmm0
	movapd	%xmm0, %xmm1
	addsd	%xmm0, %xmm1
	movapd	%xmm1, %xmm2
	addsd	%xmm1, %xmm2
	movapd	%xmm2, %xmm3
	addsd	%xmm2, %xmm3
	addsd	%xmm8, %xmm3
	movapd	%xmm3, %xmm7
.L63:
	movq	-24(%rbp), %rax
	leaq	-1(%rax), %rdx
	movq	%rdx, -24(%rbp)
	testq	%rax, %rax
	jne	.L64
	cvttsd2sil	%xmm7, %eax
	movl	%eax, %edi
	call	use_int@PLT
	cvttsd2sil	-40(%rbp), %eax
	movl	%eax, %edi
	call	use_int@PLT
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE24:
	.size	do_double_add, .-do_double_add
	.globl	do_double_mul
	.type	do_double_mul, @function
do_double_mul:
.LFB25:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$48, %rsp
	movq	%rdi, -24(%rbp)
	movq	%rsi, -32(%rbp)
	movq	-32(%rbp), %rax
	movq	%rax, -8(%rbp)
	movq	-8(%rbp), %rax
	movl	(%rax), %eax
	pxor	%xmm1, %xmm1
	cvtsi2sdl	%eax, %xmm1
	movsd	.LC8(%rip), %xmm0
	mulsd	%xmm0, %xmm1
	movapd	%xmm1, %xmm5
	movq	-8(%rbp), %rax
	movl	4(%rax), %eax
	pxor	%xmm1, %xmm1
	cvtsi2sdl	%eax, %xmm1
	movsd	.LC9(%rip), %xmm0
	mulsd	%xmm1, %xmm0
	movsd	.LC10(%rip), %xmm1
	divsd	%xmm1, %xmm0
	movsd	%xmm0, -40(%rbp)
	jmp	.L66
.L67:
	movapd	%xmm5, %xmm6
	movapd	%xmm6, %xmm2
	mulsd	%xmm6, %xmm2
	movsd	-40(%rbp), %xmm0
	mulsd	%xmm0, %xmm2
	movapd	%xmm2, %xmm3
	mulsd	%xmm2, %xmm3
	mulsd	%xmm0, %xmm3
	movapd	%xmm3, %xmm4
	mulsd	%xmm3, %xmm4
	mulsd	%xmm0, %xmm4
	movapd	%xmm4, %xmm5
	mulsd	%xmm4, %xmm5
	mulsd	%xmm0, %xmm5
	movapd	%xmm5, %xmm6
	mulsd	%xmm5, %xmm6
	mulsd	%xmm0, %xmm6
	movapd	%xmm6, %xmm7
	mulsd	%xmm6, %xmm7
	movapd	%xmm0, %xmm6
	mulsd	%xmm6, %xmm7
	movapd	%xmm7, %xmm2
	mulsd	%xmm7, %xmm2
	movapd	%xmm0, %xmm6
	mulsd	%xmm6, %xmm2
	movapd	%xmm2, %xmm0
	mulsd	%xmm2, %xmm0
	mulsd	%xmm6, %xmm0
	movapd	%xmm0, %xmm1
	mulsd	%xmm0, %xmm1
	movapd	%xmm6, %xmm0
	mulsd	%xmm0, %xmm1
	movapd	%xmm1, %xmm3
	mulsd	%xmm1, %xmm3
	movapd	%xmm6, %xmm0
	mulsd	%xmm0, %xmm3
	movapd	%xmm3, %xmm4
	mulsd	%xmm3, %xmm4
	mulsd	%xmm0, %xmm4
	movapd	%xmm4, %xmm5
	mulsd	%xmm4, %xmm5
	mulsd	%xmm0, %xmm5
	movapd	%xmm5, %xmm6
	mulsd	%xmm5, %xmm6
	mulsd	%xmm0, %xmm6
	movapd	%xmm6, %xmm7
	mulsd	%xmm6, %xmm7
	movapd	%xmm0, %xmm6
	mulsd	%xmm6, %xmm7
	movapd	%xmm7, %xmm2
	mulsd	%xmm7, %xmm2
	movapd	%xmm0, %xmm6
	movapd	%xmm6, %xmm7
	mulsd	%xmm7, %xmm2
	movapd	%xmm2, %xmm0
	mulsd	%xmm2, %xmm0
	movapd	%xmm6, %xmm7
	mulsd	%xmm7, %xmm0
	movapd	%xmm0, %xmm1
	mulsd	%xmm0, %xmm1
	mulsd	%xmm7, %xmm1
	movapd	%xmm1, %xmm3
	mulsd	%xmm1, %xmm3
	mulsd	%xmm7, %xmm3
	movapd	%xmm3, %xmm4
	mulsd	%xmm3, %xmm4
	mulsd	%xmm7, %xmm4
	movapd	%xmm4, %xmm5
	mulsd	%xmm4, %xmm5
	mulsd	%xmm7, %xmm5
.L66:
	movq	-24(%rbp), %rax
	leaq	-1(%rax), %rdx
	movq	%rdx, -24(%rbp)
	testq	%rax, %rax
	jne	.L67
	cvttsd2sil	%xmm5, %eax
	movl	%eax, %edi
	call	use_int@PLT
	cvttsd2sil	-40(%rbp), %eax
	movl	%eax, %edi
	call	use_int@PLT
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE25:
	.size	do_double_mul, .-do_double_mul
	.globl	do_double_div
	.type	do_double_div, @function
do_double_div:
.LFB26:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$48, %rsp
	movq	%rdi, -24(%rbp)
	movq	%rsi, -32(%rbp)
	movq	-32(%rbp), %rax
	movq	%rax, -8(%rbp)
	movq	-8(%rbp), %rax
	movl	(%rax), %eax
	pxor	%xmm1, %xmm1
	cvtsi2sdl	%eax, %xmm1
	movsd	.LC11(%rip), %xmm0
	mulsd	%xmm0, %xmm1
	movapd	%xmm1, %xmm8
	movq	-8(%rbp), %rax
	movl	4(%rax), %eax
	pxor	%xmm1, %xmm1
	cvtsi2sdl	%eax, %xmm1
	movsd	.LC3(%rip), %xmm0
	mulsd	%xmm1, %xmm0
	movsd	.LC10(%rip), %xmm1
	divsd	%xmm1, %xmm0
	movsd	%xmm0, -40(%rbp)
	jmp	.L69
.L70:
	movsd	-40(%rbp), %xmm4
	movapd	%xmm4, %xmm0
	movapd	%xmm8, %xmm2
	divsd	%xmm2, %xmm0
	movapd	%xmm4, %xmm1
	divsd	%xmm0, %xmm1
	movapd	%xmm4, %xmm0
	divsd	%xmm1, %xmm0
	movapd	%xmm4, %xmm1
	divsd	%xmm0, %xmm1
	movapd	%xmm4, %xmm0
	divsd	%xmm1, %xmm0
	movapd	%xmm4, %xmm1
	divsd	%xmm0, %xmm1
	movapd	%xmm4, %xmm0
	divsd	%xmm1, %xmm0
	movapd	%xmm4, %xmm1
	divsd	%xmm0, %xmm1
	movapd	%xmm4, %xmm0
	divsd	%xmm1, %xmm0
	movapd	%xmm4, %xmm3
	divsd	%xmm0, %xmm3
	movapd	%xmm3, %xmm1
	divsd	%xmm4, %xmm1
	movapd	%xmm3, %xmm4
	divsd	%xmm1, %xmm4
	movapd	%xmm3, %xmm0
	divsd	%xmm4, %xmm0
	movapd	%xmm3, %xmm1
	divsd	%xmm0, %xmm1
	movapd	%xmm3, %xmm0
	divsd	%xmm1, %xmm0
	movapd	%xmm3, %xmm1
	divsd	%xmm0, %xmm1
	movapd	%xmm3, %xmm0
	divsd	%xmm1, %xmm0
	movapd	%xmm3, %xmm1
	divsd	%xmm0, %xmm1
	movapd	%xmm3, %xmm0
	divsd	%xmm1, %xmm0
	movapd	%xmm3, %xmm2
	divsd	%xmm0, %xmm2
	movapd	%xmm2, %xmm1
	divsd	%xmm3, %xmm1
	movapd	%xmm2, %xmm3
	divsd	%xmm1, %xmm3
	movapd	%xmm2, %xmm6
	divsd	%xmm3, %xmm6
	movapd	%xmm2, %xmm7
	divsd	%xmm6, %xmm7
	movapd	%xmm2, %xmm0
	divsd	%xmm7, %xmm0
	movapd	%xmm2, %xmm1
	divsd	%xmm0, %xmm1
	movapd	%xmm2, %xmm6
	divsd	%xmm1, %xmm6
	movapd	%xmm2, %xmm7
	divsd	%xmm6, %xmm7
	movapd	%xmm2, %xmm0
	divsd	%xmm7, %xmm0
	movapd	%xmm2, %xmm7
	divsd	%xmm0, %xmm7
	movapd	%xmm7, %xmm1
	divsd	%xmm2, %xmm1
	movapd	%xmm7, %xmm2
	divsd	%xmm1, %xmm2
	movapd	%xmm7, %xmm6
	divsd	%xmm2, %xmm6
	movapd	%xmm7, %xmm0
	divsd	%xmm6, %xmm0
	movapd	%xmm7, %xmm1
	divsd	%xmm0, %xmm1
	movapd	%xmm7, %xmm6
	divsd	%xmm1, %xmm6
	movapd	%xmm7, %xmm0
	divsd	%xmm6, %xmm0
	movapd	%xmm7, %xmm1
	divsd	%xmm0, %xmm1
	movapd	%xmm7, %xmm6
	divsd	%xmm1, %xmm6
	movapd	%xmm7, %xmm0
	divsd	%xmm6, %xmm0
	movapd	%xmm0, %xmm6
	movapd	%xmm6, %xmm1
	divsd	%xmm7, %xmm1
	movapd	%xmm6, %xmm7
	divsd	%xmm1, %xmm7
	movapd	%xmm6, %xmm0
	divsd	%xmm7, %xmm0
	movapd	%xmm6, %xmm7
	divsd	%xmm0, %xmm7
	movapd	%xmm6, %xmm1
	divsd	%xmm7, %xmm1
	movapd	%xmm6, %xmm7
	divsd	%xmm1, %xmm7
	movapd	%xmm6, %xmm0
	divsd	%xmm7, %xmm0
	movapd	%xmm6, %xmm7
	divsd	%xmm0, %xmm7
	movapd	%xmm6, %xmm1
	divsd	%xmm7, %xmm1
	movapd	%xmm6, %xmm5
	divsd	%xmm1, %xmm5
	movapd	%xmm5, %xmm7
	divsd	%xmm6, %xmm7
	movapd	%xmm5, %xmm6
	divsd	%xmm7, %xmm6
	movapd	%xmm5, %xmm0
	divsd	%xmm6, %xmm0
	movapd	%xmm5, %xmm6
	divsd	%xmm0, %xmm6
	movapd	%xmm5, %xmm1
	divsd	%xmm6, %xmm1
	movapd	%xmm5, %xmm6
	divsd	%xmm1, %xmm6
	movapd	%xmm5, %xmm7
	divsd	%xmm6, %xmm7
	movapd	%xmm5, %xmm6
	divsd	%xmm7, %xmm6
	movapd	%xmm5, %xmm0
	divsd	%xmm6, %xmm0
	movapd	%xmm5, %xmm4
	divsd	%xmm0, %xmm4
	movapd	%xmm4, %xmm1
	divsd	%xmm5, %xmm1
	movapd	%xmm4, %xmm5
	divsd	%xmm1, %xmm5
	movapd	%xmm4, %xmm6
	divsd	%xmm5, %xmm6
	movapd	%xmm4, %xmm7
	divsd	%xmm6, %xmm7
	movapd	%xmm4, %xmm0
	divsd	%xmm7, %xmm0
	movapd	%xmm4, %xmm1
	divsd	%xmm0, %xmm1
	movapd	%xmm4, %xmm6
	divsd	%xmm1, %xmm6
	movapd	%xmm4, %xmm7
	divsd	%xmm6, %xmm7
	movapd	%xmm4, %xmm0
	divsd	%xmm7, %xmm0
	movapd	%xmm4, %xmm3
	divsd	%xmm0, %xmm3
	movapd	%xmm3, %xmm1
	divsd	%xmm4, %xmm1
	movapd	%xmm3, %xmm4
	divsd	%xmm1, %xmm4
	movapd	%xmm3, %xmm5
	divsd	%xmm4, %xmm5
	movapd	%xmm3, %xmm6
	divsd	%xmm5, %xmm6
	movapd	%xmm3, %xmm7
	divsd	%xmm6, %xmm7
	movapd	%xmm3, %xmm0
	divsd	%xmm7, %xmm0
	movapd	%xmm3, %xmm1
	divsd	%xmm0, %xmm1
	movapd	%xmm3, %xmm2
	divsd	%xmm1, %xmm2
	movapd	%xmm3, %xmm5
	divsd	%xmm2, %xmm5
	movapd	%xmm3, %xmm2
	divsd	%xmm5, %xmm2
	movapd	%xmm2, %xmm6
	divsd	%xmm3, %xmm6
	movapd	%xmm2, %xmm3
	divsd	%xmm6, %xmm3
	movapd	%xmm2, %xmm7
	divsd	%xmm3, %xmm7
	movapd	%xmm2, %xmm0
	divsd	%xmm7, %xmm0
	movapd	%xmm2, %xmm1
	divsd	%xmm0, %xmm1
	movapd	%xmm2, %xmm4
	divsd	%xmm1, %xmm4
	movapd	%xmm2, %xmm5
	divsd	%xmm4, %xmm5
	movapd	%xmm2, %xmm6
	divsd	%xmm5, %xmm6
	movapd	%xmm2, %xmm7
	divsd	%xmm6, %xmm7
	movapd	%xmm2, %xmm5
	divsd	%xmm7, %xmm5
	movapd	%xmm5, %xmm8
	movapd	%xmm5, %xmm0
	divsd	%xmm2, %xmm0
	movapd	%xmm5, %xmm2
	divsd	%xmm0, %xmm2
	movapd	%xmm5, %xmm1
	divsd	%xmm2, %xmm1
	movapd	%xmm5, %xmm3
	divsd	%xmm1, %xmm3
	movapd	%xmm5, %xmm4
	divsd	%xmm3, %xmm4
	movapd	%xmm5, %xmm6
	divsd	%xmm4, %xmm6
	movapd	%xmm5, %xmm7
	divsd	%xmm6, %xmm7
	movapd	%xmm5, %xmm0
	divsd	%xmm7, %xmm0
	movapd	%xmm5, %xmm1
	divsd	%xmm0, %xmm1
	divsd	%xmm1, %xmm5
	movsd	%xmm5, -40(%rbp)
.L69:
	movq	-24(%rbp), %rax
	leaq	-1(%rax), %rdx
	movq	%rdx, -24(%rbp)
	testq	%rax, %rax
	jne	.L70
	cvttsd2sil	%xmm8, %eax
	movl	%eax, %edi
	call	use_int@PLT
	cvttsd2sil	-40(%rbp), %eax
	movl	%eax, %edi
	call	use_int@PLT
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE26:
	.size	do_double_div, .-do_double_div
	.globl	do_float_bogomflops
	.type	do_float_bogomflops, @function
do_float_bogomflops:
.LFB27:
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
	movq	-32(%rbp), %rax
	movl	4(%rax), %eax
	movslq	%eax, %rdx
	imulq	$1717986919, %rdx, %rdx
	shrq	$32, %rdx
	sarl	$2, %edx
	sarl	$31, %eax
	subl	%eax, %edx
	movl	%edx, %r13d
	jmp	.L72
.L75:
	movq	-32(%rbp), %rax
	movq	16(%rax), %rbx
	movl	$0, %r12d
	jmp	.L73
.L74:
	movss	(%rbx), %xmm1
	movss	.LC12(%rip), %xmm0
	addss	%xmm0, %xmm1
	movss	(%rbx), %xmm2
	movss	.LC13(%rip), %xmm0
	subss	%xmm2, %xmm0
	mulss	%xmm1, %xmm0
	movss	(%rbx), %xmm1
	divss	%xmm1, %xmm0
	movss	%xmm0, (%rbx)
	leaq	4(%rbx), %rax
	movss	(%rax), %xmm1
	movss	.LC12(%rip), %xmm0
	addss	%xmm0, %xmm1
	leaq	4(%rbx), %rax
	movss	(%rax), %xmm2
	movss	.LC13(%rip), %xmm0
	subss	%xmm2, %xmm0
	mulss	%xmm1, %xmm0
	leaq	4(%rbx), %rax
	movss	(%rax), %xmm1
	leaq	4(%rbx), %rax
	divss	%xmm1, %xmm0
	movss	%xmm0, (%rax)
	leaq	8(%rbx), %rax
	movss	(%rax), %xmm1
	movss	.LC12(%rip), %xmm0
	addss	%xmm0, %xmm1
	leaq	8(%rbx), %rax
	movss	(%rax), %xmm2
	movss	.LC13(%rip), %xmm0
	subss	%xmm2, %xmm0
	mulss	%xmm1, %xmm0
	leaq	8(%rbx), %rax
	movss	(%rax), %xmm1
	leaq	8(%rbx), %rax
	divss	%xmm1, %xmm0
	movss	%xmm0, (%rax)
	leaq	12(%rbx), %rax
	movss	(%rax), %xmm1
	movss	.LC12(%rip), %xmm0
	addss	%xmm0, %xmm1
	leaq	12(%rbx), %rax
	movss	(%rax), %xmm2
	movss	.LC13(%rip), %xmm0
	subss	%xmm2, %xmm0
	mulss	%xmm1, %xmm0
	leaq	12(%rbx), %rax
	movss	(%rax), %xmm1
	leaq	12(%rbx), %rax
	divss	%xmm1, %xmm0
	movss	%xmm0, (%rax)
	leaq	16(%rbx), %rax
	movss	(%rax), %xmm1
	movss	.LC12(%rip), %xmm0
	addss	%xmm0, %xmm1
	leaq	16(%rbx), %rax
	movss	(%rax), %xmm2
	movss	.LC13(%rip), %xmm0
	subss	%xmm2, %xmm0
	mulss	%xmm1, %xmm0
	leaq	16(%rbx), %rax
	movss	(%rax), %xmm1
	leaq	16(%rbx), %rax
	divss	%xmm1, %xmm0
	movss	%xmm0, (%rax)
	leaq	20(%rbx), %rax
	movss	(%rax), %xmm1
	movss	.LC12(%rip), %xmm0
	addss	%xmm0, %xmm1
	leaq	20(%rbx), %rax
	movss	(%rax), %xmm2
	movss	.LC13(%rip), %xmm0
	subss	%xmm2, %xmm0
	mulss	%xmm1, %xmm0
	leaq	20(%rbx), %rax
	movss	(%rax), %xmm1
	leaq	20(%rbx), %rax
	divss	%xmm1, %xmm0
	movss	%xmm0, (%rax)
	leaq	24(%rbx), %rax
	movss	(%rax), %xmm1
	movss	.LC12(%rip), %xmm0
	addss	%xmm0, %xmm1
	leaq	24(%rbx), %rax
	movss	(%rax), %xmm2
	movss	.LC13(%rip), %xmm0
	subss	%xmm2, %xmm0
	mulss	%xmm1, %xmm0
	leaq	24(%rbx), %rax
	movss	(%rax), %xmm1
	leaq	24(%rbx), %rax
	divss	%xmm1, %xmm0
	movss	%xmm0, (%rax)
	leaq	28(%rbx), %rax
	movss	(%rax), %xmm1
	movss	.LC12(%rip), %xmm0
	addss	%xmm0, %xmm1
	leaq	28(%rbx), %rax
	movss	(%rax), %xmm2
	movss	.LC13(%rip), %xmm0
	subss	%xmm2, %xmm0
	mulss	%xmm1, %xmm0
	leaq	28(%rbx), %rax
	movss	(%rax), %xmm1
	leaq	28(%rbx), %rax
	divss	%xmm1, %xmm0
	movss	%xmm0, (%rax)
	leaq	32(%rbx), %rax
	movss	(%rax), %xmm1
	movss	.LC12(%rip), %xmm0
	addss	%xmm0, %xmm1
	leaq	32(%rbx), %rax
	movss	(%rax), %xmm2
	movss	.LC13(%rip), %xmm0
	subss	%xmm2, %xmm0
	mulss	%xmm1, %xmm0
	leaq	32(%rbx), %rax
	movss	(%rax), %xmm1
	leaq	32(%rbx), %rax
	divss	%xmm1, %xmm0
	movss	%xmm0, (%rax)
	leaq	36(%rbx), %rax
	movss	(%rax), %xmm1
	movss	.LC12(%rip), %xmm0
	addss	%xmm0, %xmm1
	leaq	36(%rbx), %rax
	movss	(%rax), %xmm2
	movss	.LC13(%rip), %xmm0
	subss	%xmm2, %xmm0
	mulss	%xmm1, %xmm0
	leaq	36(%rbx), %rax
	movss	(%rax), %xmm1
	leaq	36(%rbx), %rax
	divss	%xmm1, %xmm0
	movss	%xmm0, (%rax)
	addq	$40, %rbx
	addl	$1, %r12d
.L73:
	cmpl	%r13d, %r12d
	jl	.L74
.L72:
	movq	-48(%rbp), %rax
	leaq	-1(%rax), %rdx
	movq	%rdx, -48(%rbp)
	testq	%rax, %rax
	jne	.L75
	nop
	nop
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE27:
	.size	do_float_bogomflops, .-do_float_bogomflops
	.globl	do_double_bogomflops
	.type	do_double_bogomflops, @function
do_double_bogomflops:
.LFB28:
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
	movq	-32(%rbp), %rax
	movl	4(%rax), %eax
	movslq	%eax, %rdx
	imulq	$1717986919, %rdx, %rdx
	shrq	$32, %rdx
	sarl	$2, %edx
	sarl	$31, %eax
	subl	%eax, %edx
	movl	%edx, %r13d
	jmp	.L77
.L80:
	movq	-32(%rbp), %rax
	movq	16(%rax), %rbx
	movl	$0, %r12d
	jmp	.L78
.L79:
	movsd	(%rbx), %xmm1
	movsd	.LC14(%rip), %xmm0
	addsd	%xmm0, %xmm1
	movsd	(%rbx), %xmm2
	movsd	.LC15(%rip), %xmm0
	subsd	%xmm2, %xmm0
	mulsd	%xmm1, %xmm0
	movsd	(%rbx), %xmm1
	divsd	%xmm1, %xmm0
	movsd	%xmm0, (%rbx)
	leaq	8(%rbx), %rax
	movsd	(%rax), %xmm1
	movsd	.LC14(%rip), %xmm0
	addsd	%xmm0, %xmm1
	leaq	8(%rbx), %rax
	movsd	(%rax), %xmm2
	movsd	.LC15(%rip), %xmm0
	subsd	%xmm2, %xmm0
	mulsd	%xmm1, %xmm0
	leaq	8(%rbx), %rax
	movsd	(%rax), %xmm1
	leaq	8(%rbx), %rax
	divsd	%xmm1, %xmm0
	movsd	%xmm0, (%rax)
	leaq	16(%rbx), %rax
	movsd	(%rax), %xmm1
	movsd	.LC14(%rip), %xmm0
	addsd	%xmm0, %xmm1
	leaq	16(%rbx), %rax
	movsd	(%rax), %xmm2
	movsd	.LC15(%rip), %xmm0
	subsd	%xmm2, %xmm0
	mulsd	%xmm1, %xmm0
	leaq	16(%rbx), %rax
	movsd	(%rax), %xmm1
	leaq	16(%rbx), %rax
	divsd	%xmm1, %xmm0
	movsd	%xmm0, (%rax)
	leaq	24(%rbx), %rax
	movsd	(%rax), %xmm1
	movsd	.LC14(%rip), %xmm0
	addsd	%xmm0, %xmm1
	leaq	24(%rbx), %rax
	movsd	(%rax), %xmm2
	movsd	.LC15(%rip), %xmm0
	subsd	%xmm2, %xmm0
	mulsd	%xmm1, %xmm0
	leaq	24(%rbx), %rax
	movsd	(%rax), %xmm1
	leaq	24(%rbx), %rax
	divsd	%xmm1, %xmm0
	movsd	%xmm0, (%rax)
	leaq	32(%rbx), %rax
	movsd	(%rax), %xmm1
	movsd	.LC14(%rip), %xmm0
	addsd	%xmm0, %xmm1
	leaq	32(%rbx), %rax
	movsd	(%rax), %xmm2
	movsd	.LC15(%rip), %xmm0
	subsd	%xmm2, %xmm0
	mulsd	%xmm1, %xmm0
	leaq	32(%rbx), %rax
	movsd	(%rax), %xmm1
	leaq	32(%rbx), %rax
	divsd	%xmm1, %xmm0
	movsd	%xmm0, (%rax)
	leaq	40(%rbx), %rax
	movsd	(%rax), %xmm1
	movsd	.LC14(%rip), %xmm0
	addsd	%xmm0, %xmm1
	leaq	40(%rbx), %rax
	movsd	(%rax), %xmm2
	movsd	.LC15(%rip), %xmm0
	subsd	%xmm2, %xmm0
	mulsd	%xmm1, %xmm0
	leaq	40(%rbx), %rax
	movsd	(%rax), %xmm1
	leaq	40(%rbx), %rax
	divsd	%xmm1, %xmm0
	movsd	%xmm0, (%rax)
	leaq	48(%rbx), %rax
	movsd	(%rax), %xmm1
	movsd	.LC14(%rip), %xmm0
	addsd	%xmm0, %xmm1
	leaq	48(%rbx), %rax
	movsd	(%rax), %xmm2
	movsd	.LC15(%rip), %xmm0
	subsd	%xmm2, %xmm0
	mulsd	%xmm1, %xmm0
	leaq	48(%rbx), %rax
	movsd	(%rax), %xmm1
	leaq	48(%rbx), %rax
	divsd	%xmm1, %xmm0
	movsd	%xmm0, (%rax)
	leaq	56(%rbx), %rax
	movsd	(%rax), %xmm1
	movsd	.LC14(%rip), %xmm0
	addsd	%xmm0, %xmm1
	leaq	56(%rbx), %rax
	movsd	(%rax), %xmm2
	movsd	.LC15(%rip), %xmm0
	subsd	%xmm2, %xmm0
	mulsd	%xmm1, %xmm0
	leaq	56(%rbx), %rax
	movsd	(%rax), %xmm1
	leaq	56(%rbx), %rax
	divsd	%xmm1, %xmm0
	movsd	%xmm0, (%rax)
	leaq	64(%rbx), %rax
	movsd	(%rax), %xmm1
	movsd	.LC14(%rip), %xmm0
	addsd	%xmm0, %xmm1
	leaq	64(%rbx), %rax
	movsd	(%rax), %xmm2
	movsd	.LC15(%rip), %xmm0
	subsd	%xmm2, %xmm0
	mulsd	%xmm1, %xmm0
	leaq	64(%rbx), %rax
	movsd	(%rax), %xmm1
	leaq	64(%rbx), %rax
	divsd	%xmm1, %xmm0
	movsd	%xmm0, (%rax)
	leaq	72(%rbx), %rax
	movsd	(%rax), %xmm1
	movsd	.LC14(%rip), %xmm0
	addsd	%xmm0, %xmm1
	leaq	72(%rbx), %rax
	movsd	(%rax), %xmm2
	movsd	.LC15(%rip), %xmm0
	subsd	%xmm2, %xmm0
	mulsd	%xmm1, %xmm0
	leaq	72(%rbx), %rax
	movsd	(%rax), %xmm1
	leaq	72(%rbx), %rax
	divsd	%xmm1, %xmm0
	movsd	%xmm0, (%rax)
	addq	$80, %rbx
	addl	$1, %r12d
.L78:
	cmpl	%r13d, %r12d
	jl	.L79
.L77:
	movq	-48(%rbp), %rax
	leaq	-1(%rax), %rdx
	movq	%rdx, -48(%rbp)
	testq	%rax, %rax
	jne	.L80
	nop
	nop
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE28:
	.size	do_double_bogomflops, .-do_double_bogomflops
	.section	.rodata
	.align 8
.LC16:
	.string	"[-W <warmup>] [-N <repetitions>] [-P <parallel>] \n"
.LC17:
	.string	"W:N:P:"
.LC18:
	.string	"integer bit"
.LC19:
	.string	"integer add"
.LC20:
	.string	"integer mul"
.LC21:
	.string	"integer div"
.LC22:
	.string	"integer mod"
.LC23:
	.string	"int64 bit"
.LC24:
	.string	"uint64 add"
.LC25:
	.string	"int64 mul"
.LC26:
	.string	"int64 div"
.LC27:
	.string	"int64 mod"
.LC28:
	.string	"float add"
.LC29:
	.string	"float mul"
.LC30:
	.string	"float div"
.LC31:
	.string	"double add"
.LC32:
	.string	"double mul"
.LC33:
	.string	"double div"
.LC34:
	.string	"float bogomflops"
.LC35:
	.string	"double bogomflops"
	.text
	.globl	main
	.type	main, @function
main:
.LFB29:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%rbx
	subq	$104, %rsp
	.cfi_offset 3, -24
	movl	%edi, -100(%rbp)
	movq	%rsi, -112(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -24(%rbp)
	xorl	%eax, %eax
	movl	$0, -88(%rbp)
	movl	$1, -84(%rbp)
	movl	$-1, -80(%rbp)
	leaq	.LC16(%rip), %rax
	movq	%rax, -72(%rbp)
	movl	$1, -48(%rbp)
	movl	$1000, -44(%rbp)
	movl	$-1023, -40(%rbp)
	movq	$0, -32(%rbp)
	jmp	.L82
.L88:
	cmpl	$87, -76(%rbp)
	je	.L83
	cmpl	$87, -76(%rbp)
	jg	.L84
	cmpl	$78, -76(%rbp)
	je	.L85
	cmpl	$80, -76(%rbp)
	je	.L86
	jmp	.L84
.L83:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -88(%rbp)
	jmp	.L82
.L85:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -80(%rbp)
	jmp	.L82
.L86:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -84(%rbp)
	cmpl	$0, -84(%rbp)
	jg	.L82
	movq	-72(%rbp), %rdx
	movq	-112(%rbp), %rcx
	movl	-100(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	lmbench_usage@PLT
	jmp	.L82
.L84:
	movq	-72(%rbp), %rdx
	movq	-112(%rbp), %rcx
	movl	-100(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	lmbench_usage@PLT
	nop
.L82:
	movq	-112(%rbp), %rcx
	movl	-100(%rbp), %eax
	leaq	.LC17(%rip), %rdx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	mygetopt@PLT
	movl	%eax, -76(%rbp)
	cmpl	$-1, -76(%rbp)
	jne	.L88
	movl	-88(%rbp), %edx
	leaq	-48(%rbp), %rax
	pushq	%rax
	movl	-80(%rbp), %eax
	pushq	%rax
	movl	%edx, %r9d
	movl	$1, %r8d
	movl	$0, %ecx
	movl	$0, %edx
	leaq	do_integer_bitwise(%rip), %rax
	movq	%rax, %rsi
	movl	$0, %edi
	call	benchmp@PLT
	addq	$16, %rsp
	call	get_n@PLT
	imulq	$300, %rax, %rax
	movq	%rax, %rsi
	leaq	.LC18(%rip), %rax
	movq	%rax, %rdi
	call	nano@PLT
	call	usecs_spent@PLT
	movq	%rax, -64(%rbp)
	call	get_n@PLT
	imulq	$300, %rax, %rax
	movq	%rax, -56(%rbp)
	movl	-88(%rbp), %edx
	leaq	-48(%rbp), %rax
	pushq	%rax
	movl	-80(%rbp), %eax
	pushq	%rax
	movl	%edx, %r9d
	movl	$1, %r8d
	movl	$0, %ecx
	movl	$0, %edx
	leaq	do_integer_add(%rip), %rax
	movq	%rax, %rsi
	movl	$0, %edi
	call	benchmp@PLT
	addq	$16, %rsp
	call	get_n@PLT
	imulq	$20000, %rax, %rax
	movq	%rax, %rsi
	leaq	.LC19(%rip), %rax
	movq	%rax, %rdi
	call	nano@PLT
	movl	-88(%rbp), %edx
	leaq	-48(%rbp), %rax
	pushq	%rax
	movl	-80(%rbp), %eax
	pushq	%rax
	movl	%edx, %r9d
	movl	$1, %r8d
	movl	$0, %ecx
	movl	$0, %edx
	leaq	do_integer_mul(%rip), %rax
	movq	%rax, %rsi
	movl	$0, %edi
	call	benchmp@PLT
	addq	$16, %rsp
	call	usecs_spent@PLT
	movq	%rax, %rbx
	call	get_n@PLT
	imulq	-64(%rbp), %rax
	addq	%rax, %rax
	movl	$0, %edx
	divq	-56(%rbp)
	movq	%rax, %rdx
	movq	%rbx, %rax
	subq	%rdx, %rax
	movq	%rax, %rdi
	call	settime@PLT
	call	get_n@PLT
	movq	%rax, %rdx
	movq	%rdx, %rax
	salq	$2, %rax
	addq	%rdx, %rax
	salq	$2, %rax
	movq	%rax, %rsi
	leaq	.LC20(%rip), %rax
	movq	%rax, %rdi
	call	nano@PLT
	movl	-88(%rbp), %edx
	leaq	-48(%rbp), %rax
	pushq	%rax
	movl	-80(%rbp), %eax
	pushq	%rax
	movl	%edx, %r9d
	movl	$1, %r8d
	movl	$0, %ecx
	movl	$0, %edx
	leaq	do_integer_div(%rip), %rax
	movq	%rax, %rsi
	movl	$0, %edi
	call	benchmp@PLT
	addq	$16, %rsp
	call	get_n@PLT
	movq	%rax, %rdx
	movq	%rdx, %rax
	salq	$2, %rax
	addq	%rdx, %rax
	leaq	0(,%rax,4), %rdx
	addq	%rdx, %rax
	salq	$2, %rax
	movq	%rax, %rsi
	leaq	.LC21(%rip), %rax
	movq	%rax, %rdi
	call	nano@PLT
	movl	-88(%rbp), %edx
	leaq	-48(%rbp), %rax
	pushq	%rax
	movl	-80(%rbp), %eax
	pushq	%rax
	movl	%edx, %r9d
	movl	$1, %r8d
	movl	$0, %ecx
	movl	$0, %edx
	leaq	do_integer_mod(%rip), %rax
	movq	%rax, %rsi
	movl	$0, %edi
	call	benchmp@PLT
	addq	$16, %rsp
	call	usecs_spent@PLT
	movq	%rax, %rbx
	call	get_n@PLT
	imulq	-64(%rbp), %rax
	movq	%rax, %rdx
	movq	%rdx, %rax
	salq	$2, %rax
	addq	%rdx, %rax
	leaq	0(,%rax,4), %rdx
	addq	%rdx, %rax
	salq	$2, %rax
	movl	$0, %edx
	divq	-56(%rbp)
	movq	%rax, %rdx
	movq	%rbx, %rax
	subq	%rdx, %rax
	movq	%rax, %rdi
	call	settime@PLT
	call	get_n@PLT
	movq	%rax, %rdx
	movq	%rdx, %rax
	salq	$2, %rax
	addq	%rdx, %rax
	leaq	0(,%rax,4), %rdx
	addq	%rdx, %rax
	salq	$2, %rax
	movq	%rax, %rsi
	leaq	.LC22(%rip), %rax
	movq	%rax, %rdi
	call	nano@PLT
	movl	-88(%rbp), %edx
	leaq	-48(%rbp), %rax
	pushq	%rax
	movl	-80(%rbp), %eax
	pushq	%rax
	movl	%edx, %r9d
	movl	$1, %r8d
	movl	$0, %ecx
	movl	$0, %edx
	leaq	do_int64_bitwise(%rip), %rax
	movq	%rax, %rsi
	movl	$0, %edi
	call	benchmp@PLT
	addq	$16, %rsp
	call	get_n@PLT
	imulq	$300, %rax, %rax
	movq	%rax, %rsi
	leaq	.LC23(%rip), %rax
	movq	%rax, %rdi
	call	nano@PLT
	call	usecs_spent@PLT
	movq	%rax, -64(%rbp)
	call	get_n@PLT
	imulq	$300, %rax, %rax
	movq	%rax, -56(%rbp)
	movl	-88(%rbp), %edx
	leaq	-48(%rbp), %rax
	pushq	%rax
	movl	-80(%rbp), %eax
	pushq	%rax
	movl	%edx, %r9d
	movl	$1, %r8d
	movl	$0, %ecx
	movl	$0, %edx
	leaq	do_int64_add(%rip), %rax
	movq	%rax, %rsi
	movl	$0, %edi
	call	benchmp@PLT
	addq	$16, %rsp
	call	get_n@PLT
	imulq	$20000, %rax, %rax
	movq	%rax, %rsi
	leaq	.LC24(%rip), %rax
	movq	%rax, %rdi
	call	nano@PLT
	movl	-88(%rbp), %edx
	leaq	-48(%rbp), %rax
	pushq	%rax
	movl	-80(%rbp), %eax
	pushq	%rax
	movl	%edx, %r9d
	movl	$1, %r8d
	movl	$0, %ecx
	movl	$0, %edx
	leaq	do_int64_mul(%rip), %rax
	movq	%rax, %rsi
	movl	$0, %edi
	call	benchmp@PLT
	addq	$16, %rsp
	call	usecs_spent@PLT
	movq	%rax, %rbx
	call	get_n@PLT
	imulq	-64(%rbp), %rax
	addq	%rax, %rax
	movl	$0, %edx
	divq	-56(%rbp)
	movq	%rax, %rdx
	movq	%rbx, %rax
	subq	%rdx, %rax
	movq	%rax, %rdi
	call	settime@PLT
	call	get_n@PLT
	movq	%rax, %rdx
	movq	%rdx, %rax
	salq	$2, %rax
	addq	%rdx, %rax
	salq	$2, %rax
	movq	%rax, %rsi
	leaq	.LC25(%rip), %rax
	movq	%rax, %rdi
	call	nano@PLT
	movl	-88(%rbp), %edx
	leaq	-48(%rbp), %rax
	pushq	%rax
	movl	-80(%rbp), %eax
	pushq	%rax
	movl	%edx, %r9d
	movl	$1, %r8d
	movl	$0, %ecx
	movl	$0, %edx
	leaq	do_int64_div(%rip), %rax
	movq	%rax, %rsi
	movl	$0, %edi
	call	benchmp@PLT
	addq	$16, %rsp
	call	get_n@PLT
	movq	%rax, %rdx
	movq	%rdx, %rax
	salq	$2, %rax
	addq	%rdx, %rax
	leaq	0(,%rax,4), %rdx
	addq	%rdx, %rax
	salq	$2, %rax
	movq	%rax, %rsi
	leaq	.LC26(%rip), %rax
	movq	%rax, %rdi
	call	nano@PLT
	movl	-88(%rbp), %edx
	leaq	-48(%rbp), %rax
	pushq	%rax
	movl	-80(%rbp), %eax
	pushq	%rax
	movl	%edx, %r9d
	movl	$1, %r8d
	movl	$0, %ecx
	movl	$0, %edx
	leaq	do_int64_mod(%rip), %rax
	movq	%rax, %rsi
	movl	$0, %edi
	call	benchmp@PLT
	addq	$16, %rsp
	call	usecs_spent@PLT
	movq	%rax, %rbx
	call	get_n@PLT
	imulq	-64(%rbp), %rax
	movq	%rax, %rdx
	movq	%rdx, %rax
	salq	$2, %rax
	addq	%rdx, %rax
	leaq	0(,%rax,4), %rdx
	addq	%rdx, %rax
	salq	$2, %rax
	movl	$0, %edx
	divq	-56(%rbp)
	movq	%rax, %rdx
	movq	%rbx, %rax
	subq	%rdx, %rax
	movq	%rax, %rdi
	call	settime@PLT
	call	get_n@PLT
	movq	%rax, %rdx
	movq	%rdx, %rax
	salq	$2, %rax
	addq	%rdx, %rax
	leaq	0(,%rax,4), %rdx
	addq	%rdx, %rax
	salq	$2, %rax
	movq	%rax, %rsi
	leaq	.LC27(%rip), %rax
	movq	%rax, %rdi
	call	nano@PLT
	movl	-88(%rbp), %edx
	leaq	-48(%rbp), %rax
	pushq	%rax
	movl	-80(%rbp), %eax
	pushq	%rax
	movl	%edx, %r9d
	movl	$1, %r8d
	movl	$0, %ecx
	movl	$0, %edx
	leaq	do_float_add(%rip), %rax
	movq	%rax, %rsi
	movl	$0, %edi
	call	benchmp@PLT
	addq	$16, %rsp
	call	get_n@PLT
	movq	%rax, %rdx
	movq	%rdx, %rax
	salq	$2, %rax
	addq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	addq	%rax, %rax
	movq	%rax, %rsi
	leaq	.LC28(%rip), %rax
	movq	%rax, %rdi
	call	nano@PLT
	movl	-88(%rbp), %edx
	leaq	-48(%rbp), %rax
	pushq	%rax
	movl	-80(%rbp), %eax
	pushq	%rax
	movl	%edx, %r9d
	movl	$1, %r8d
	movl	$0, %ecx
	movl	$0, %edx
	leaq	do_float_mul(%rip), %rax
	movq	%rax, %rsi
	movl	$0, %edi
	call	benchmp@PLT
	addq	$16, %rsp
	call	get_n@PLT
	movq	%rax, %rdx
	movq	%rdx, %rax
	salq	$2, %rax
	addq	%rdx, %rax
	salq	$3, %rax
	movq	%rax, %rsi
	leaq	.LC29(%rip), %rax
	movq	%rax, %rdi
	call	nano@PLT
	movl	-88(%rbp), %edx
	leaq	-48(%rbp), %rax
	pushq	%rax
	movl	-80(%rbp), %eax
	pushq	%rax
	movl	%edx, %r9d
	movl	$1, %r8d
	movl	$0, %ecx
	movl	$0, %edx
	leaq	do_float_div(%rip), %rax
	movq	%rax, %rsi
	movl	$0, %edi
	call	benchmp@PLT
	addq	$16, %rsp
	call	get_n@PLT
	movq	%rax, %rdx
	movq	%rdx, %rax
	salq	$2, %rax
	addq	%rdx, %rax
	leaq	0(,%rax,4), %rdx
	addq	%rdx, %rax
	salq	$2, %rax
	movq	%rax, %rsi
	leaq	.LC30(%rip), %rax
	movq	%rax, %rdi
	call	nano@PLT
	movl	-88(%rbp), %edx
	leaq	-48(%rbp), %rax
	pushq	%rax
	movl	-80(%rbp), %eax
	pushq	%rax
	movl	%edx, %r9d
	movl	$1, %r8d
	movl	$0, %ecx
	movl	$0, %edx
	leaq	do_double_add(%rip), %rax
	movq	%rax, %rsi
	movl	$0, %edi
	call	benchmp@PLT
	addq	$16, %rsp
	call	get_n@PLT
	movq	%rax, %rdx
	movq	%rdx, %rax
	salq	$2, %rax
	addq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	addq	%rax, %rax
	movq	%rax, %rsi
	leaq	.LC31(%rip), %rax
	movq	%rax, %rdi
	call	nano@PLT
	movl	-88(%rbp), %edx
	leaq	-48(%rbp), %rax
	pushq	%rax
	movl	-80(%rbp), %eax
	pushq	%rax
	movl	%edx, %r9d
	movl	$1, %r8d
	movl	$0, %ecx
	movl	$0, %edx
	leaq	do_double_mul(%rip), %rax
	movq	%rax, %rsi
	movl	$0, %edi
	call	benchmp@PLT
	addq	$16, %rsp
	call	get_n@PLT
	movq	%rax, %rdx
	movq	%rdx, %rax
	salq	$2, %rax
	addq	%rdx, %rax
	salq	$3, %rax
	movq	%rax, %rsi
	leaq	.LC32(%rip), %rax
	movq	%rax, %rdi
	call	nano@PLT
	movl	-88(%rbp), %edx
	leaq	-48(%rbp), %rax
	pushq	%rax
	movl	-80(%rbp), %eax
	pushq	%rax
	movl	%edx, %r9d
	movl	$1, %r8d
	movl	$0, %ecx
	movl	$0, %edx
	leaq	do_double_div(%rip), %rax
	movq	%rax, %rsi
	movl	$0, %edi
	call	benchmp@PLT
	addq	$16, %rsp
	call	get_n@PLT
	movq	%rax, %rdx
	movq	%rdx, %rax
	salq	$2, %rax
	addq	%rdx, %rax
	leaq	0(,%rax,4), %rdx
	addq	%rdx, %rax
	salq	$2, %rax
	movq	%rax, %rsi
	leaq	.LC33(%rip), %rax
	movq	%rax, %rdi
	call	nano@PLT
	movl	-88(%rbp), %ecx
	movl	-84(%rbp), %edx
	leaq	-48(%rbp), %rax
	pushq	%rax
	movl	-80(%rbp), %eax
	pushq	%rax
	movl	%ecx, %r9d
	movl	%edx, %r8d
	movl	$0, %ecx
	leaq	cleanup(%rip), %rax
	movq	%rax, %rdx
	leaq	do_float_bogomflops(%rip), %rax
	movq	%rax, %rsi
	leaq	float_initialize(%rip), %rax
	movq	%rax, %rdi
	call	benchmp@PLT
	addq	$16, %rsp
	call	get_n@PLT
	movl	-44(%rbp), %edx
	movslq	%edx, %rdx
	imulq	%rdx, %rax
	movq	%rax, %rsi
	leaq	.LC34(%rip), %rax
	movq	%rax, %rdi
	call	nano@PLT
	movq	stdout(%rip), %rax
	movq	%rax, %rdi
	call	fflush@PLT
	movq	stderr(%rip), %rax
	movq	%rax, %rdi
	call	fflush@PLT
	movl	-88(%rbp), %ecx
	movl	-84(%rbp), %edx
	leaq	-48(%rbp), %rax
	pushq	%rax
	movl	-80(%rbp), %eax
	pushq	%rax
	movl	%ecx, %r9d
	movl	%edx, %r8d
	movl	$0, %ecx
	leaq	cleanup(%rip), %rax
	movq	%rax, %rdx
	leaq	do_double_bogomflops(%rip), %rax
	movq	%rax, %rsi
	leaq	double_initialize(%rip), %rax
	movq	%rax, %rdi
	call	benchmp@PLT
	addq	$16, %rsp
	call	get_n@PLT
	movl	-44(%rbp), %edx
	movslq	%edx, %rdx
	imulq	%rdx, %rax
	movq	%rax, %rsi
	leaq	.LC35(%rip), %rax
	movq	%rax, %rdi
	call	nano@PLT
	movq	stdout(%rip), %rax
	movq	%rax, %rdi
	call	fflush@PLT
	movq	stderr(%rip), %rax
	movq	%rax, %rdi
	call	fflush@PLT
	movl	$0, %eax
	movq	-24(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L90
	call	__stack_chk_fail@PLT
.L90:
	movq	-8(%rbp), %rbx
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE29:
	.size	main, .-main
	.section	.rodata
	.align 4
.LC2:
	.long	1078530011
	.align 8
.LC3:
	.long	1405670641
	.long	1074340347
	.align 4
.LC4:
	.long	1090519040
	.align 4
.LC5:
	.long	1040187392
	.align 4
.LC6:
	.long	1148846080
	.align 4
.LC7:
	.long	1068827891
	.align 8
.LC8:
	.long	0
	.long	1075838976
	.align 8
.LC9:
	.long	0
	.long	1069547520
	.align 8
.LC10:
	.long	0
	.long	1083129856
	.align 8
.LC11:
	.long	1708926943
	.long	1073127582
	.align 4
.LC12:
	.long	1065353216
	.align 4
.LC13:
	.long	1069547520
	.align 8
.LC14:
	.long	0
	.long	1072693248
	.align 8
.LC15:
	.long	0
	.long	1073217536
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
