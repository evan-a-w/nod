	.file	"lat_ops.c"
	.text
	.globl	do_float_bogomflops
	.type	do_float_bogomflops, @function
do_float_bogomflops:
.LFB91:
	.cfi_startproc
	endbr64
	movq	%rsi, %r8
	movl	4(%rsi), %r9d
	movslq	%r9d, %rcx
	imulq	$1717986919, %rcx, %rcx
	sarq	$34, %rcx
	movl	%r9d, %eax
	sarl	$31, %eax
	subl	%eax, %ecx
	leaq	-1(%rdi), %rsi
	testq	%rdi, %rdi
	je	.L1
	movss	.LC0(%rip), %xmm1
	movss	.LC1(%rip), %xmm0
.L5:
	movq	16(%r8), %rax
	cmpl	$9, %r9d
	jle	.L3
	movl	$0, %edx
.L4:
	movss	(%rax), %xmm3
	movaps	%xmm3, %xmm2
	addss	%xmm1, %xmm2
	movaps	%xmm0, %xmm4
	subss	%xmm3, %xmm4
	mulss	%xmm4, %xmm2
	divss	%xmm3, %xmm2
	movss	%xmm2, (%rax)
	movss	4(%rax), %xmm3
	movaps	%xmm3, %xmm2
	addss	%xmm1, %xmm2
	movaps	%xmm0, %xmm4
	subss	%xmm3, %xmm4
	mulss	%xmm4, %xmm2
	divss	%xmm3, %xmm2
	movss	%xmm2, 4(%rax)
	movss	8(%rax), %xmm3
	movaps	%xmm3, %xmm2
	addss	%xmm1, %xmm2
	movaps	%xmm0, %xmm4
	subss	%xmm3, %xmm4
	mulss	%xmm4, %xmm2
	divss	%xmm3, %xmm2
	movss	%xmm2, 8(%rax)
	movss	12(%rax), %xmm3
	movaps	%xmm3, %xmm2
	addss	%xmm1, %xmm2
	movaps	%xmm0, %xmm4
	subss	%xmm3, %xmm4
	mulss	%xmm4, %xmm2
	divss	%xmm3, %xmm2
	movss	%xmm2, 12(%rax)
	movss	16(%rax), %xmm3
	movaps	%xmm3, %xmm2
	addss	%xmm1, %xmm2
	movaps	%xmm0, %xmm4
	subss	%xmm3, %xmm4
	mulss	%xmm4, %xmm2
	divss	%xmm3, %xmm2
	movss	%xmm2, 16(%rax)
	movss	20(%rax), %xmm3
	movaps	%xmm3, %xmm2
	addss	%xmm1, %xmm2
	movaps	%xmm0, %xmm4
	subss	%xmm3, %xmm4
	mulss	%xmm4, %xmm2
	divss	%xmm3, %xmm2
	movss	%xmm2, 20(%rax)
	movss	24(%rax), %xmm3
	movaps	%xmm3, %xmm2
	addss	%xmm1, %xmm2
	movaps	%xmm0, %xmm4
	subss	%xmm3, %xmm4
	mulss	%xmm4, %xmm2
	divss	%xmm3, %xmm2
	movss	%xmm2, 24(%rax)
	movss	28(%rax), %xmm3
	movaps	%xmm3, %xmm2
	addss	%xmm1, %xmm2
	movaps	%xmm0, %xmm4
	subss	%xmm3, %xmm4
	mulss	%xmm4, %xmm2
	divss	%xmm3, %xmm2
	movss	%xmm2, 28(%rax)
	movss	32(%rax), %xmm3
	movaps	%xmm3, %xmm2
	addss	%xmm1, %xmm2
	movaps	%xmm0, %xmm4
	subss	%xmm3, %xmm4
	mulss	%xmm4, %xmm2
	divss	%xmm3, %xmm2
	movss	%xmm2, 32(%rax)
	movss	36(%rax), %xmm3
	movaps	%xmm3, %xmm2
	addss	%xmm1, %xmm2
	movaps	%xmm0, %xmm4
	subss	%xmm3, %xmm4
	mulss	%xmm4, %xmm2
	divss	%xmm3, %xmm2
	movss	%xmm2, 36(%rax)
	addq	$40, %rax
	addl	$1, %edx
	cmpl	%edx, %ecx
	jg	.L4
.L3:
	subq	$1, %rsi
	cmpq	$-1, %rsi
	jne	.L5
.L1:
	ret
	.cfi_endproc
.LFE91:
	.size	do_float_bogomflops, .-do_float_bogomflops
	.globl	do_double_bogomflops
	.type	do_double_bogomflops, @function
do_double_bogomflops:
.LFB92:
	.cfi_startproc
	endbr64
	movq	%rsi, %r8
	movl	4(%rsi), %r9d
	movslq	%r9d, %rcx
	imulq	$1717986919, %rcx, %rcx
	sarq	$34, %rcx
	movl	%r9d, %eax
	sarl	$31, %eax
	subl	%eax, %ecx
	leaq	-1(%rdi), %rsi
	testq	%rdi, %rdi
	je	.L8
	movsd	.LC2(%rip), %xmm1
	movsd	.LC3(%rip), %xmm0
.L12:
	movq	16(%r8), %rax
	cmpl	$9, %r9d
	jle	.L10
	movl	$0, %edx
.L11:
	movsd	(%rax), %xmm3
	movapd	%xmm3, %xmm2
	addsd	%xmm1, %xmm2
	movapd	%xmm0, %xmm4
	subsd	%xmm3, %xmm4
	mulsd	%xmm4, %xmm2
	divsd	%xmm3, %xmm2
	movsd	%xmm2, (%rax)
	movsd	8(%rax), %xmm3
	movapd	%xmm3, %xmm2
	addsd	%xmm1, %xmm2
	movapd	%xmm0, %xmm4
	subsd	%xmm3, %xmm4
	mulsd	%xmm4, %xmm2
	divsd	%xmm3, %xmm2
	movsd	%xmm2, 8(%rax)
	movsd	16(%rax), %xmm3
	movapd	%xmm3, %xmm2
	addsd	%xmm1, %xmm2
	movapd	%xmm0, %xmm4
	subsd	%xmm3, %xmm4
	mulsd	%xmm4, %xmm2
	divsd	%xmm3, %xmm2
	movsd	%xmm2, 16(%rax)
	movsd	24(%rax), %xmm3
	movapd	%xmm3, %xmm2
	addsd	%xmm1, %xmm2
	movapd	%xmm0, %xmm4
	subsd	%xmm3, %xmm4
	mulsd	%xmm4, %xmm2
	divsd	%xmm3, %xmm2
	movsd	%xmm2, 24(%rax)
	movsd	32(%rax), %xmm3
	movapd	%xmm3, %xmm2
	addsd	%xmm1, %xmm2
	movapd	%xmm0, %xmm4
	subsd	%xmm3, %xmm4
	mulsd	%xmm4, %xmm2
	divsd	%xmm3, %xmm2
	movsd	%xmm2, 32(%rax)
	movsd	40(%rax), %xmm3
	movapd	%xmm3, %xmm2
	addsd	%xmm1, %xmm2
	movapd	%xmm0, %xmm4
	subsd	%xmm3, %xmm4
	mulsd	%xmm4, %xmm2
	divsd	%xmm3, %xmm2
	movsd	%xmm2, 40(%rax)
	movsd	48(%rax), %xmm3
	movapd	%xmm3, %xmm2
	addsd	%xmm1, %xmm2
	movapd	%xmm0, %xmm4
	subsd	%xmm3, %xmm4
	mulsd	%xmm4, %xmm2
	divsd	%xmm3, %xmm2
	movsd	%xmm2, 48(%rax)
	movsd	56(%rax), %xmm3
	movapd	%xmm3, %xmm2
	addsd	%xmm1, %xmm2
	movapd	%xmm0, %xmm4
	subsd	%xmm3, %xmm4
	mulsd	%xmm4, %xmm2
	divsd	%xmm3, %xmm2
	movsd	%xmm2, 56(%rax)
	movsd	64(%rax), %xmm3
	movapd	%xmm3, %xmm2
	addsd	%xmm1, %xmm2
	movapd	%xmm0, %xmm4
	subsd	%xmm3, %xmm4
	mulsd	%xmm4, %xmm2
	divsd	%xmm3, %xmm2
	movsd	%xmm2, 64(%rax)
	movsd	72(%rax), %xmm3
	movapd	%xmm3, %xmm2
	addsd	%xmm1, %xmm2
	movapd	%xmm0, %xmm4
	subsd	%xmm3, %xmm4
	mulsd	%xmm4, %xmm2
	divsd	%xmm3, %xmm2
	movsd	%xmm2, 72(%rax)
	addq	$80, %rax
	addl	$1, %edx
	cmpl	%edx, %ecx
	jg	.L11
.L10:
	subq	$1, %rsi
	cmpq	$-1, %rsi
	jne	.L12
.L8:
	ret
	.cfi_endproc
.LFE92:
	.size	do_double_bogomflops, .-do_double_bogomflops
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC4:
	.string	"malloc"
	.text
	.globl	float_initialize
	.type	float_initialize, @function
float_initialize:
.LFB72:
	.cfi_startproc
	endbr64
	testq	%rdi, %rdi
	je	.L25
	ret
.L25:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushq	%rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	subq	$8, %rsp
	.cfi_def_cfa_offset 32
	movq	%rsi, %rbp
	movl	4(%rsi), %ebx
	movslq	%ebx, %rdi
	salq	$2, %rdi
	call	malloc@PLT
	movq	%rax, 16(%rbp)
	testq	%rax, %rax
	je	.L17
	testl	%ebx, %ebx
	jle	.L15
	movq	%rax, %rdx
	movl	%ebx, %ebx
	leaq	(%rax,%rbx,4), %rax
	movss	.LC5(%rip), %xmm0
.L19:
	movss	%xmm0, (%rdx)
	addq	$4, %rdx
	cmpq	%rax, %rdx
	jne	.L19
.L15:
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
.L17:
	.cfi_restore_state
	leaq	.LC4(%rip), %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
	.cfi_endproc
.LFE72:
	.size	float_initialize, .-float_initialize
	.globl	double_initialize
	.type	double_initialize, @function
double_initialize:
.LFB73:
	.cfi_startproc
	endbr64
	testq	%rdi, %rdi
	je	.L36
	ret
.L36:
	pushq	%r12
	.cfi_def_cfa_offset 16
	.cfi_offset 12, -16
	pushq	%rbp
	.cfi_def_cfa_offset 24
	.cfi_offset 6, -24
	pushq	%rbx
	.cfi_def_cfa_offset 32
	.cfi_offset 3, -32
	movq	%rdi, %rbx
	movq	%rsi, %rbp
	movl	4(%rsi), %r12d
	movslq	%r12d, %rdi
	salq	$3, %rdi
	call	malloc@PLT
	movq	%rax, 16(%rbp)
	testq	%rax, %rax
	je	.L28
	movsd	.LC6(%rip), %xmm0
	testl	%r12d, %r12d
	jle	.L26
.L29:
	movq	16(%rbp), %rax
	movsd	%xmm0, (%rax,%rbx,8)
	addq	$1, %rbx
	cmpl	%ebx, 4(%rbp)
	jg	.L29
.L26:
	popq	%rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	ret
.L28:
	.cfi_restore_state
	leaq	.LC4(%rip), %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
	.cfi_endproc
.LFE73:
	.size	double_initialize, .-double_initialize
	.globl	cleanup
	.type	cleanup, @function
cleanup:
.LFB74:
	.cfi_startproc
	endbr64
	testq	%rdi, %rdi
	jne	.L40
	movq	16(%rsi), %rdi
	testq	%rdi, %rdi
	je	.L40
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	call	free@PLT
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
.L40:
	ret
	.cfi_endproc
.LFE74:
	.size	cleanup, .-cleanup
	.globl	do_integer_bitwise
	.type	do_integer_bitwise, @function
do_integer_bitwise:
.LFB75:
	.cfi_startproc
	endbr64
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	movq	%rdi, %rdx
	movl	(%rsi), %edi
	movl	%edx, %esi
	leaq	-1(%rdx), %rax
	testq	%rdx, %rdx
	je	.L44
.L45:
	xorl	%eax, %edi
	movl	%edi, %ecx
	xorl	%esi, %ecx
	orl	%esi, %edi
	xorl	%eax, %edi
	movl	%ecx, %edx
	xorl	%edi, %edx
	orl	%edi, %ecx
	xorl	%eax, %ecx
	movl	%edx, %esi
	xorl	%ecx, %esi
	orl	%ecx, %edx
	xorl	%eax, %edx
	movl	%esi, %ecx
	xorl	%edx, %ecx
	orl	%edx, %esi
	xorl	%eax, %esi
	movl	%ecx, %edx
	xorl	%esi, %edx
	orl	%esi, %ecx
	xorl	%eax, %ecx
	movl	%edx, %esi
	xorl	%ecx, %esi
	orl	%ecx, %edx
	xorl	%eax, %edx
	movl	%esi, %ecx
	xorl	%edx, %ecx
	orl	%edx, %esi
	xorl	%eax, %esi
	movl	%ecx, %edx
	xorl	%esi, %edx
	orl	%esi, %ecx
	xorl	%eax, %ecx
	movl	%edx, %esi
	xorl	%ecx, %esi
	orl	%ecx, %edx
	xorl	%eax, %edx
	movl	%esi, %ecx
	xorl	%edx, %ecx
	orl	%edx, %esi
	xorl	%eax, %esi
	movl	%ecx, %edx
	xorl	%esi, %edx
	orl	%esi, %ecx
	xorl	%eax, %ecx
	movl	%edx, %esi
	xorl	%ecx, %esi
	orl	%ecx, %edx
	xorl	%eax, %edx
	movl	%esi, %ecx
	xorl	%edx, %ecx
	orl	%edx, %esi
	xorl	%eax, %esi
	movl	%ecx, %edx
	xorl	%esi, %edx
	orl	%esi, %ecx
	xorl	%eax, %ecx
	movl	%edx, %esi
	xorl	%ecx, %esi
	orl	%ecx, %edx
	xorl	%eax, %edx
	movl	%esi, %ecx
	xorl	%edx, %ecx
	orl	%edx, %esi
	xorl	%eax, %esi
	movl	%ecx, %edx
	xorl	%esi, %edx
	orl	%esi, %ecx
	xorl	%eax, %ecx
	movl	%edx, %esi
	xorl	%ecx, %esi
	orl	%ecx, %edx
	xorl	%eax, %edx
	movl	%esi, %ecx
	xorl	%edx, %ecx
	orl	%edx, %esi
	xorl	%eax, %esi
	movl	%ecx, %edx
	xorl	%esi, %edx
	orl	%esi, %ecx
	xorl	%eax, %ecx
	movl	%edx, %esi
	xorl	%ecx, %esi
	orl	%ecx, %edx
	xorl	%eax, %edx
	movl	%esi, %ecx
	xorl	%edx, %ecx
	orl	%edx, %esi
	xorl	%eax, %esi
	movl	%ecx, %edx
	xorl	%esi, %edx
	orl	%esi, %ecx
	xorl	%eax, %ecx
	movl	%edx, %esi
	xorl	%ecx, %esi
	orl	%ecx, %edx
	xorl	%eax, %edx
	movl	%esi, %ecx
	xorl	%edx, %ecx
	orl	%edx, %esi
	xorl	%eax, %esi
	movl	%ecx, %edx
	xorl	%esi, %edx
	orl	%esi, %ecx
	xorl	%eax, %ecx
	movl	%edx, %esi
	xorl	%ecx, %esi
	orl	%ecx, %edx
	xorl	%eax, %edx
	movl	%esi, %ecx
	xorl	%edx, %ecx
	orl	%edx, %esi
	xorl	%eax, %esi
	movl	%ecx, %edx
	xorl	%esi, %edx
	orl	%esi, %ecx
	xorl	%eax, %ecx
	movl	%edx, %esi
	xorl	%ecx, %esi
	orl	%ecx, %edx
	xorl	%eax, %edx
	movl	%esi, %ecx
	xorl	%edx, %ecx
	orl	%edx, %esi
	xorl	%eax, %esi
	movl	%ecx, %edx
	xorl	%esi, %edx
	orl	%esi, %ecx
	xorl	%eax, %ecx
	movl	%edx, %esi
	xorl	%ecx, %esi
	orl	%ecx, %edx
	xorl	%eax, %edx
	movl	%esi, %ecx
	xorl	%edx, %ecx
	orl	%edx, %esi
	xorl	%eax, %esi
	movl	%ecx, %edx
	xorl	%esi, %edx
	orl	%esi, %ecx
	xorl	%eax, %ecx
	movl	%edx, %esi
	xorl	%ecx, %esi
	orl	%ecx, %edx
	xorl	%eax, %edx
	movl	%esi, %ecx
	xorl	%edx, %ecx
	orl	%edx, %esi
	xorl	%eax, %esi
	movl	%ecx, %edx
	xorl	%esi, %edx
	orl	%esi, %ecx
	xorl	%eax, %ecx
	movl	%edx, %esi
	xorl	%ecx, %esi
	orl	%ecx, %edx
	xorl	%eax, %edx
	movl	%esi, %ecx
	xorl	%edx, %ecx
	orl	%edx, %esi
	xorl	%eax, %esi
	movl	%ecx, %edx
	xorl	%esi, %edx
	orl	%esi, %ecx
	xorl	%eax, %ecx
	movl	%edx, %esi
	xorl	%ecx, %esi
	orl	%ecx, %edx
	xorl	%eax, %edx
	movl	%esi, %ecx
	xorl	%edx, %ecx
	orl	%edx, %esi
	xorl	%eax, %esi
	movl	%ecx, %edx
	xorl	%esi, %edx
	orl	%esi, %ecx
	xorl	%eax, %ecx
	movl	%edx, %esi
	xorl	%ecx, %esi
	orl	%ecx, %edx
	xorl	%eax, %edx
	movl	%esi, %ecx
	xorl	%edx, %ecx
	orl	%edx, %esi
	xorl	%eax, %esi
	movl	%ecx, %edx
	xorl	%esi, %edx
	orl	%esi, %ecx
	xorl	%eax, %ecx
	movl	%edx, %esi
	xorl	%ecx, %esi
	orl	%ecx, %edx
	xorl	%eax, %edx
	movl	%esi, %ecx
	xorl	%edx, %ecx
	orl	%edx, %esi
	xorl	%eax, %esi
	movl	%ecx, %edx
	xorl	%esi, %edx
	orl	%esi, %ecx
	xorl	%eax, %ecx
	movl	%edx, %esi
	xorl	%ecx, %esi
	orl	%ecx, %edx
	xorl	%eax, %edx
	movl	%esi, %ecx
	xorl	%edx, %ecx
	orl	%edx, %esi
	xorl	%eax, %esi
	movl	%ecx, %edx
	xorl	%esi, %edx
	orl	%esi, %ecx
	xorl	%eax, %ecx
	movl	%edx, %esi
	xorl	%ecx, %esi
	orl	%ecx, %edx
	xorl	%eax, %edx
	movl	%esi, %ecx
	xorl	%edx, %ecx
	orl	%edx, %esi
	xorl	%eax, %esi
	movl	%ecx, %edx
	xorl	%esi, %edx
	orl	%esi, %ecx
	xorl	%eax, %ecx
	movl	%edx, %esi
	xorl	%ecx, %esi
	orl	%ecx, %edx
	xorl	%eax, %edx
	movl	%esi, %ecx
	xorl	%edx, %ecx
	orl	%edx, %esi
	xorl	%eax, %esi
	movl	%ecx, %edx
	xorl	%esi, %edx
	orl	%esi, %ecx
	xorl	%eax, %ecx
	movl	%edx, %esi
	xorl	%ecx, %esi
	orl	%ecx, %edx
	xorl	%eax, %edx
	movl	%esi, %ecx
	xorl	%edx, %ecx
	orl	%edx, %esi
	xorl	%eax, %esi
	movl	%ecx, %edx
	xorl	%esi, %edx
	orl	%esi, %ecx
	xorl	%eax, %ecx
	movl	%edx, %esi
	xorl	%ecx, %esi
	orl	%ecx, %edx
	xorl	%eax, %edx
	movl	%esi, %ecx
	xorl	%edx, %ecx
	orl	%edx, %esi
	xorl	%eax, %esi
	movl	%ecx, %edx
	xorl	%esi, %edx
	orl	%esi, %ecx
	xorl	%eax, %ecx
	movl	%edx, %esi
	xorl	%ecx, %esi
	orl	%ecx, %edx
	xorl	%eax, %edx
	movl	%esi, %ecx
	xorl	%edx, %ecx
	orl	%edx, %esi
	xorl	%eax, %esi
	movl	%ecx, %edx
	xorl	%esi, %edx
	orl	%esi, %ecx
	xorl	%eax, %ecx
	movl	%edx, %esi
	xorl	%ecx, %esi
	orl	%ecx, %edx
	xorl	%eax, %edx
	movl	%esi, %ecx
	xorl	%edx, %ecx
	orl	%edx, %esi
	xorl	%eax, %esi
	movl	%ecx, %edx
	xorl	%esi, %edx
	orl	%esi, %ecx
	xorl	%eax, %ecx
	movl	%edx, %esi
	xorl	%ecx, %esi
	orl	%ecx, %edx
	xorl	%eax, %edx
	movl	%esi, %ecx
	xorl	%edx, %ecx
	orl	%edx, %esi
	xorl	%eax, %esi
	movl	%ecx, %edx
	xorl	%esi, %edx
	orl	%esi, %ecx
	xorl	%eax, %ecx
	movl	%edx, %esi
	xorl	%ecx, %esi
	orl	%ecx, %edx
	xorl	%eax, %edx
	movl	%esi, %ecx
	xorl	%edx, %ecx
	orl	%edx, %esi
	xorl	%eax, %esi
	movl	%ecx, %edx
	xorl	%esi, %edx
	orl	%esi, %ecx
	xorl	%eax, %ecx
	movl	%edx, %esi
	xorl	%ecx, %esi
	orl	%ecx, %edx
	xorl	%eax, %edx
	movl	%esi, %ecx
	xorl	%edx, %ecx
	orl	%edx, %esi
	xorl	%eax, %esi
	movl	%ecx, %edx
	xorl	%esi, %edx
	orl	%esi, %ecx
	xorl	%eax, %ecx
	movl	%edx, %esi
	xorl	%ecx, %esi
	orl	%ecx, %edx
	xorl	%eax, %edx
	movl	%esi, %ecx
	xorl	%edx, %ecx
	orl	%edx, %esi
	xorl	%eax, %esi
	movl	%ecx, %edx
	xorl	%esi, %edx
	orl	%esi, %ecx
	xorl	%eax, %ecx
	movl	%edx, %esi
	xorl	%ecx, %esi
	orl	%ecx, %edx
	xorl	%eax, %edx
	movl	%esi, %ecx
	xorl	%edx, %ecx
	orl	%edx, %esi
	xorl	%eax, %esi
	movl	%ecx, %edx
	xorl	%esi, %edx
	orl	%esi, %ecx
	xorl	%eax, %ecx
	movl	%edx, %esi
	xorl	%ecx, %esi
	orl	%ecx, %edx
	xorl	%eax, %edx
	movl	%esi, %ecx
	xorl	%edx, %ecx
	orl	%edx, %esi
	xorl	%eax, %esi
	movl	%ecx, %edx
	xorl	%esi, %edx
	orl	%esi, %ecx
	xorl	%eax, %ecx
	movl	%edx, %esi
	xorl	%ecx, %esi
	orl	%ecx, %edx
	xorl	%eax, %edx
	movl	%esi, %ecx
	xorl	%edx, %ecx
	orl	%edx, %esi
	xorl	%eax, %esi
	movl	%ecx, %edx
	xorl	%esi, %edx
	orl	%esi, %ecx
	xorl	%eax, %ecx
	movl	%edx, %esi
	xorl	%ecx, %esi
	orl	%ecx, %edx
	xorl	%eax, %edx
	movl	%esi, %ecx
	xorl	%edx, %ecx
	orl	%edx, %esi
	xorl	%eax, %esi
	movl	%ecx, %edx
	xorl	%esi, %edx
	orl	%esi, %ecx
	xorl	%eax, %ecx
	movl	%edx, %esi
	xorl	%ecx, %esi
	orl	%ecx, %edx
	xorl	%eax, %edx
	movl	%esi, %ecx
	xorl	%edx, %ecx
	orl	%edx, %esi
	xorl	%eax, %esi
	movl	%ecx, %edx
	xorl	%esi, %edx
	orl	%esi, %ecx
	xorl	%eax, %ecx
	movl	%edx, %edi
	xorl	%ecx, %edi
	orl	%ecx, %edx
	xorl	%eax, %edx
	movl	%edi, %esi
	xorl	%edx, %esi
	orl	%edx, %edi
	subq	$1, %rax
	cmpq	$-1, %rax
	jne	.L45
.L44:
	call	use_int@PLT
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE75:
	.size	do_integer_bitwise, .-do_integer_bitwise
	.globl	do_integer_add
	.type	do_integer_add, @function
do_integer_add:
.LFB76:
	.cfi_startproc
	endbr64
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	movq	%rdi, %rax
	movl	(%rsi), %edi
	addl	$57, %edi
	leaq	-1(%rax), %rcx
	testq	%rax, %rax
	je	.L50
.L49:
	movl	$1, %eax
.L51:
	leal	(%rax,%rdi,2), %edx
	leal	(%rax,%rdx,2), %edx
	leal	(%rax,%rdx,2), %edx
	leal	(%rax,%rdx,2), %edx
	leal	(%rax,%rdx,2), %edx
	leal	(%rax,%rdx,2), %edx
	leal	(%rax,%rdx,2), %edx
	leal	(%rax,%rdx,2), %edx
	leal	(%rax,%rdx,2), %edx
	leal	(%rax,%rdx,2), %edi
	addl	$1, %eax
	cmpl	$1001, %eax
	jne	.L51
	subq	$1, %rcx
	cmpq	$-1, %rcx
	jne	.L49
.L50:
	call	use_int@PLT
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE76:
	.size	do_integer_add, .-do_integer_add
	.globl	do_integer_mul
	.type	do_integer_mul, @function
do_integer_mul:
.LFB77:
	.cfi_startproc
	endbr64
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	movq	%rdi, %r8
	movl	(%rsi), %eax
	leal	37431(%rax), %edi
	addl	$4, %eax
	movl	%edi, %edx
	imull	%eax, %edx
	imull	%eax, %edx
	imull	%eax, %edx
	imull	%eax, %edx
	imull	%eax, %edx
	imull	%eax, %edx
	imull	%eax, %edx
	imull	%eax, %edx
	imull	%eax, %edx
	imull	%eax, %edx
	subl	%edi, %edx
	leaq	-1(%r8), %rcx
	testq	%r8, %r8
	je	.L56
.L57:
	imull	%eax, %edi
	imull	%eax, %edi
	imull	%eax, %edi
	imull	%eax, %edi
	imull	%eax, %edi
	imull	%eax, %edi
	imull	%eax, %edi
	imull	%eax, %edi
	imull	%eax, %edi
	imull	%eax, %edi
	subl	%edx, %edi
	imull	%eax, %edi
	imull	%eax, %edi
	imull	%eax, %edi
	imull	%eax, %edi
	imull	%eax, %edi
	imull	%eax, %edi
	imull	%eax, %edi
	imull	%eax, %edi
	imull	%eax, %edi
	imull	%eax, %edi
	subl	%edx, %edi
	subq	$1, %rcx
	cmpq	$-1, %rcx
	jne	.L57
.L56:
	call	use_int@PLT
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE77:
	.size	do_integer_mul, .-do_integer_mul
	.globl	do_integer_div
	.type	do_integer_div, @function
do_integer_div:
.LFB78:
	.cfi_startproc
	endbr64
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	movq	%rdi, %rax
	movl	(%rsi), %ecx
	leal	36(%rcx), %edi
	addl	$37, %ecx
	sall	$20, %ecx
	leaq	-1(%rax), %rsi
	testq	%rax, %rax
	je	.L61
.L62:
	movl	%ecx, %eax
	cltd
	idivl	%edi
	movl	%eax, %edi
	movl	%ecx, %eax
	cltd
	idivl	%edi
	movl	%eax, %edi
	movl	%ecx, %eax
	cltd
	idivl	%edi
	movl	%eax, %edi
	movl	%ecx, %eax
	cltd
	idivl	%edi
	movl	%eax, %edi
	movl	%ecx, %eax
	cltd
	idivl	%edi
	movl	%eax, %edi
	movl	%ecx, %eax
	cltd
	idivl	%edi
	movl	%eax, %edi
	movl	%ecx, %eax
	cltd
	idivl	%edi
	movl	%eax, %edi
	movl	%ecx, %eax
	cltd
	idivl	%edi
	movl	%eax, %edi
	movl	%ecx, %eax
	cltd
	idivl	%edi
	movl	%eax, %edi
	movl	%ecx, %eax
	cltd
	idivl	%edi
	movl	%eax, %edi
	movl	%ecx, %eax
	cltd
	idivl	%edi
	movl	%eax, %edi
	movl	%ecx, %eax
	cltd
	idivl	%edi
	movl	%eax, %edi
	movl	%ecx, %eax
	cltd
	idivl	%edi
	movl	%eax, %edi
	movl	%ecx, %eax
	cltd
	idivl	%edi
	movl	%eax, %edi
	movl	%ecx, %eax
	cltd
	idivl	%edi
	movl	%eax, %edi
	movl	%ecx, %eax
	cltd
	idivl	%edi
	movl	%eax, %edi
	movl	%ecx, %eax
	cltd
	idivl	%edi
	movl	%eax, %edi
	movl	%ecx, %eax
	cltd
	idivl	%edi
	movl	%eax, %edi
	movl	%ecx, %eax
	cltd
	idivl	%edi
	movl	%eax, %edi
	movl	%ecx, %eax
	cltd
	idivl	%edi
	movl	%eax, %edi
	movl	%ecx, %eax
	cltd
	idivl	%edi
	movl	%eax, %edi
	movl	%ecx, %eax
	cltd
	idivl	%edi
	movl	%eax, %edi
	movl	%ecx, %eax
	cltd
	idivl	%edi
	movl	%eax, %edi
	movl	%ecx, %eax
	cltd
	idivl	%edi
	movl	%eax, %edi
	movl	%ecx, %eax
	cltd
	idivl	%edi
	movl	%eax, %edi
	movl	%ecx, %eax
	cltd
	idivl	%edi
	movl	%eax, %edi
	movl	%ecx, %eax
	cltd
	idivl	%edi
	movl	%eax, %edi
	movl	%ecx, %eax
	cltd
	idivl	%edi
	movl	%eax, %edi
	movl	%ecx, %eax
	cltd
	idivl	%edi
	movl	%eax, %edi
	movl	%ecx, %eax
	cltd
	idivl	%edi
	movl	%eax, %edi
	movl	%ecx, %eax
	cltd
	idivl	%edi
	movl	%eax, %edi
	movl	%ecx, %eax
	cltd
	idivl	%edi
	movl	%eax, %edi
	movl	%ecx, %eax
	cltd
	idivl	%edi
	movl	%eax, %edi
	movl	%ecx, %eax
	cltd
	idivl	%edi
	movl	%eax, %edi
	movl	%ecx, %eax
	cltd
	idivl	%edi
	movl	%eax, %edi
	movl	%ecx, %eax
	cltd
	idivl	%edi
	movl	%eax, %edi
	movl	%ecx, %eax
	cltd
	idivl	%edi
	movl	%eax, %edi
	movl	%ecx, %eax
	cltd
	idivl	%edi
	movl	%eax, %edi
	movl	%ecx, %eax
	cltd
	idivl	%edi
	movl	%eax, %edi
	movl	%ecx, %eax
	cltd
	idivl	%edi
	movl	%eax, %edi
	movl	%ecx, %eax
	cltd
	idivl	%edi
	movl	%eax, %edi
	movl	%ecx, %eax
	cltd
	idivl	%edi
	movl	%eax, %edi
	movl	%ecx, %eax
	cltd
	idivl	%edi
	movl	%eax, %edi
	movl	%ecx, %eax
	cltd
	idivl	%edi
	movl	%eax, %edi
	movl	%ecx, %eax
	cltd
	idivl	%edi
	movl	%eax, %edi
	movl	%ecx, %eax
	cltd
	idivl	%edi
	movl	%eax, %edi
	movl	%ecx, %eax
	cltd
	idivl	%edi
	movl	%eax, %edi
	movl	%ecx, %eax
	cltd
	idivl	%edi
	movl	%eax, %edi
	movl	%ecx, %eax
	cltd
	idivl	%edi
	movl	%eax, %edi
	movl	%ecx, %eax
	cltd
	idivl	%edi
	movl	%eax, %edi
	movl	%ecx, %eax
	cltd
	idivl	%edi
	movl	%eax, %edi
	movl	%ecx, %eax
	cltd
	idivl	%edi
	movl	%eax, %edi
	movl	%ecx, %eax
	cltd
	idivl	%edi
	movl	%eax, %edi
	movl	%ecx, %eax
	cltd
	idivl	%edi
	movl	%eax, %edi
	movl	%ecx, %eax
	cltd
	idivl	%edi
	movl	%eax, %edi
	movl	%ecx, %eax
	cltd
	idivl	%edi
	movl	%eax, %edi
	movl	%ecx, %eax
	cltd
	idivl	%edi
	movl	%eax, %edi
	movl	%ecx, %eax
	cltd
	idivl	%edi
	movl	%eax, %edi
	movl	%ecx, %eax
	cltd
	idivl	%edi
	movl	%eax, %edi
	movl	%ecx, %eax
	cltd
	idivl	%edi
	movl	%eax, %edi
	movl	%ecx, %eax
	cltd
	idivl	%edi
	movl	%eax, %edi
	movl	%ecx, %eax
	cltd
	idivl	%edi
	movl	%eax, %edi
	movl	%ecx, %eax
	cltd
	idivl	%edi
	movl	%eax, %edi
	movl	%ecx, %eax
	cltd
	idivl	%edi
	movl	%eax, %edi
	movl	%ecx, %eax
	cltd
	idivl	%edi
	movl	%eax, %edi
	movl	%ecx, %eax
	cltd
	idivl	%edi
	movl	%eax, %edi
	movl	%ecx, %eax
	cltd
	idivl	%edi
	movl	%eax, %edi
	movl	%ecx, %eax
	cltd
	idivl	%edi
	movl	%eax, %edi
	movl	%ecx, %eax
	cltd
	idivl	%edi
	movl	%eax, %edi
	movl	%ecx, %eax
	cltd
	idivl	%edi
	movl	%eax, %edi
	movl	%ecx, %eax
	cltd
	idivl	%edi
	movl	%eax, %edi
	movl	%ecx, %eax
	cltd
	idivl	%edi
	movl	%eax, %edi
	movl	%ecx, %eax
	cltd
	idivl	%edi
	movl	%eax, %edi
	movl	%ecx, %eax
	cltd
	idivl	%edi
	movl	%eax, %edi
	movl	%ecx, %eax
	cltd
	idivl	%edi
	movl	%eax, %edi
	movl	%ecx, %eax
	cltd
	idivl	%edi
	movl	%eax, %edi
	movl	%ecx, %eax
	cltd
	idivl	%edi
	movl	%eax, %edi
	movl	%ecx, %eax
	cltd
	idivl	%edi
	movl	%eax, %edi
	movl	%ecx, %eax
	cltd
	idivl	%edi
	movl	%eax, %edi
	movl	%ecx, %eax
	cltd
	idivl	%edi
	movl	%eax, %edi
	movl	%ecx, %eax
	cltd
	idivl	%edi
	movl	%eax, %edi
	movl	%ecx, %eax
	cltd
	idivl	%edi
	movl	%eax, %edi
	movl	%ecx, %eax
	cltd
	idivl	%edi
	movl	%eax, %edi
	movl	%ecx, %eax
	cltd
	idivl	%edi
	movl	%eax, %edi
	movl	%ecx, %eax
	cltd
	idivl	%edi
	movl	%eax, %edi
	movl	%ecx, %eax
	cltd
	idivl	%edi
	movl	%eax, %edi
	movl	%ecx, %eax
	cltd
	idivl	%edi
	movl	%eax, %edi
	movl	%ecx, %eax
	cltd
	idivl	%edi
	movl	%eax, %edi
	movl	%ecx, %eax
	cltd
	idivl	%edi
	movl	%eax, %edi
	movl	%ecx, %eax
	cltd
	idivl	%edi
	movl	%eax, %edi
	movl	%ecx, %eax
	cltd
	idivl	%edi
	movl	%eax, %edi
	movl	%ecx, %eax
	cltd
	idivl	%edi
	movl	%eax, %edi
	movl	%ecx, %eax
	cltd
	idivl	%edi
	movl	%eax, %edi
	movl	%ecx, %eax
	cltd
	idivl	%edi
	movl	%eax, %edi
	movl	%ecx, %eax
	cltd
	idivl	%edi
	movl	%eax, %edi
	movl	%ecx, %eax
	cltd
	idivl	%edi
	movl	%eax, %edi
	movl	%ecx, %eax
	cltd
	idivl	%edi
	movl	%eax, %edi
	movl	%ecx, %eax
	cltd
	idivl	%edi
	movl	%eax, %edi
	movl	%ecx, %eax
	cltd
	idivl	%edi
	movl	%eax, %edi
	movl	%ecx, %eax
	cltd
	idivl	%edi
	movl	%eax, %edi
	subq	$1, %rsi
	cmpq	$-1, %rsi
	jne	.L62
.L61:
	call	use_int@PLT
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE78:
	.size	do_integer_div, .-do_integer_div
	.globl	do_integer_mod
	.type	do_integer_mod, @function
do_integer_mod:
.LFB79:
	.cfi_startproc
	endbr64
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	movl	(%rsi), %ecx
	leal	(%rcx,%rdi), %eax
	addl	$62, %ecx
	leaq	-1(%rdi), %rsi
	testq	%rdi, %rdi
	je	.L66
.L67:
	cltd
	idivl	%ecx
	movl	%edx, %eax
	orl	%ecx, %eax
	cltd
	idivl	%ecx
	movl	%edx, %eax
	orl	%ecx, %eax
	cltd
	idivl	%ecx
	movl	%edx, %eax
	orl	%ecx, %eax
	cltd
	idivl	%ecx
	movl	%edx, %eax
	orl	%ecx, %eax
	cltd
	idivl	%ecx
	movl	%edx, %eax
	orl	%ecx, %eax
	cltd
	idivl	%ecx
	movl	%edx, %eax
	orl	%ecx, %eax
	cltd
	idivl	%ecx
	movl	%edx, %eax
	orl	%ecx, %eax
	cltd
	idivl	%ecx
	movl	%edx, %eax
	orl	%ecx, %eax
	cltd
	idivl	%ecx
	movl	%edx, %eax
	orl	%ecx, %eax
	cltd
	idivl	%ecx
	movl	%edx, %eax
	orl	%ecx, %eax
	cltd
	idivl	%ecx
	movl	%edx, %eax
	orl	%ecx, %eax
	cltd
	idivl	%ecx
	movl	%edx, %eax
	orl	%ecx, %eax
	cltd
	idivl	%ecx
	movl	%edx, %eax
	orl	%ecx, %eax
	cltd
	idivl	%ecx
	movl	%edx, %eax
	orl	%ecx, %eax
	cltd
	idivl	%ecx
	movl	%edx, %eax
	orl	%ecx, %eax
	cltd
	idivl	%ecx
	movl	%edx, %eax
	orl	%ecx, %eax
	cltd
	idivl	%ecx
	movl	%edx, %eax
	orl	%ecx, %eax
	cltd
	idivl	%ecx
	movl	%edx, %eax
	orl	%ecx, %eax
	cltd
	idivl	%ecx
	movl	%edx, %eax
	orl	%ecx, %eax
	cltd
	idivl	%ecx
	movl	%edx, %eax
	orl	%ecx, %eax
	cltd
	idivl	%ecx
	movl	%edx, %eax
	orl	%ecx, %eax
	cltd
	idivl	%ecx
	movl	%edx, %eax
	orl	%ecx, %eax
	cltd
	idivl	%ecx
	movl	%edx, %eax
	orl	%ecx, %eax
	cltd
	idivl	%ecx
	movl	%edx, %eax
	orl	%ecx, %eax
	cltd
	idivl	%ecx
	movl	%edx, %eax
	orl	%ecx, %eax
	cltd
	idivl	%ecx
	movl	%edx, %eax
	orl	%ecx, %eax
	cltd
	idivl	%ecx
	movl	%edx, %eax
	orl	%ecx, %eax
	cltd
	idivl	%ecx
	movl	%edx, %eax
	orl	%ecx, %eax
	cltd
	idivl	%ecx
	movl	%edx, %eax
	orl	%ecx, %eax
	cltd
	idivl	%ecx
	movl	%edx, %eax
	orl	%ecx, %eax
	cltd
	idivl	%ecx
	movl	%edx, %eax
	orl	%ecx, %eax
	cltd
	idivl	%ecx
	movl	%edx, %eax
	orl	%ecx, %eax
	cltd
	idivl	%ecx
	movl	%edx, %eax
	orl	%ecx, %eax
	cltd
	idivl	%ecx
	movl	%edx, %eax
	orl	%ecx, %eax
	cltd
	idivl	%ecx
	movl	%edx, %eax
	orl	%ecx, %eax
	cltd
	idivl	%ecx
	movl	%edx, %eax
	orl	%ecx, %eax
	cltd
	idivl	%ecx
	movl	%edx, %eax
	orl	%ecx, %eax
	cltd
	idivl	%ecx
	movl	%edx, %eax
	orl	%ecx, %eax
	cltd
	idivl	%ecx
	movl	%edx, %eax
	orl	%ecx, %eax
	cltd
	idivl	%ecx
	movl	%edx, %eax
	orl	%ecx, %eax
	cltd
	idivl	%ecx
	movl	%edx, %eax
	orl	%ecx, %eax
	cltd
	idivl	%ecx
	movl	%edx, %eax
	orl	%ecx, %eax
	cltd
	idivl	%ecx
	movl	%edx, %eax
	orl	%ecx, %eax
	cltd
	idivl	%ecx
	movl	%edx, %eax
	orl	%ecx, %eax
	cltd
	idivl	%ecx
	movl	%edx, %eax
	orl	%ecx, %eax
	cltd
	idivl	%ecx
	movl	%edx, %eax
	orl	%ecx, %eax
	cltd
	idivl	%ecx
	movl	%edx, %eax
	orl	%ecx, %eax
	cltd
	idivl	%ecx
	movl	%edx, %eax
	orl	%ecx, %eax
	cltd
	idivl	%ecx
	movl	%edx, %eax
	orl	%ecx, %eax
	cltd
	idivl	%ecx
	movl	%edx, %eax
	orl	%ecx, %eax
	cltd
	idivl	%ecx
	movl	%edx, %eax
	orl	%ecx, %eax
	cltd
	idivl	%ecx
	movl	%edx, %eax
	orl	%ecx, %eax
	cltd
	idivl	%ecx
	movl	%edx, %eax
	orl	%ecx, %eax
	cltd
	idivl	%ecx
	movl	%edx, %eax
	orl	%ecx, %eax
	cltd
	idivl	%ecx
	movl	%edx, %eax
	orl	%ecx, %eax
	cltd
	idivl	%ecx
	movl	%edx, %eax
	orl	%ecx, %eax
	cltd
	idivl	%ecx
	movl	%edx, %eax
	orl	%ecx, %eax
	cltd
	idivl	%ecx
	movl	%edx, %eax
	orl	%ecx, %eax
	cltd
	idivl	%ecx
	movl	%edx, %eax
	orl	%ecx, %eax
	cltd
	idivl	%ecx
	movl	%edx, %eax
	orl	%ecx, %eax
	cltd
	idivl	%ecx
	movl	%edx, %eax
	orl	%ecx, %eax
	cltd
	idivl	%ecx
	movl	%edx, %eax
	orl	%ecx, %eax
	cltd
	idivl	%ecx
	movl	%edx, %eax
	orl	%ecx, %eax
	cltd
	idivl	%ecx
	movl	%edx, %eax
	orl	%ecx, %eax
	cltd
	idivl	%ecx
	movl	%edx, %eax
	orl	%ecx, %eax
	cltd
	idivl	%ecx
	movl	%edx, %eax
	orl	%ecx, %eax
	cltd
	idivl	%ecx
	movl	%edx, %eax
	orl	%ecx, %eax
	cltd
	idivl	%ecx
	movl	%edx, %eax
	orl	%ecx, %eax
	cltd
	idivl	%ecx
	movl	%edx, %eax
	orl	%ecx, %eax
	cltd
	idivl	%ecx
	movl	%edx, %eax
	orl	%ecx, %eax
	cltd
	idivl	%ecx
	movl	%edx, %eax
	orl	%ecx, %eax
	cltd
	idivl	%ecx
	movl	%edx, %eax
	orl	%ecx, %eax
	cltd
	idivl	%ecx
	movl	%edx, %eax
	orl	%ecx, %eax
	cltd
	idivl	%ecx
	movl	%edx, %eax
	orl	%ecx, %eax
	cltd
	idivl	%ecx
	movl	%edx, %eax
	orl	%ecx, %eax
	cltd
	idivl	%ecx
	movl	%edx, %eax
	orl	%ecx, %eax
	cltd
	idivl	%ecx
	movl	%edx, %eax
	orl	%ecx, %eax
	cltd
	idivl	%ecx
	movl	%edx, %eax
	orl	%ecx, %eax
	cltd
	idivl	%ecx
	movl	%edx, %eax
	orl	%ecx, %eax
	cltd
	idivl	%ecx
	movl	%edx, %eax
	orl	%ecx, %eax
	cltd
	idivl	%ecx
	movl	%edx, %eax
	orl	%ecx, %eax
	cltd
	idivl	%ecx
	movl	%edx, %eax
	orl	%ecx, %eax
	cltd
	idivl	%ecx
	movl	%edx, %eax
	orl	%ecx, %eax
	cltd
	idivl	%ecx
	movl	%edx, %eax
	orl	%ecx, %eax
	cltd
	idivl	%ecx
	movl	%edx, %eax
	orl	%ecx, %eax
	cltd
	idivl	%ecx
	movl	%edx, %eax
	orl	%ecx, %eax
	cltd
	idivl	%ecx
	movl	%edx, %eax
	orl	%ecx, %eax
	cltd
	idivl	%ecx
	movl	%edx, %eax
	orl	%ecx, %eax
	cltd
	idivl	%ecx
	movl	%edx, %eax
	orl	%ecx, %eax
	cltd
	idivl	%ecx
	movl	%edx, %eax
	orl	%ecx, %eax
	cltd
	idivl	%ecx
	movl	%edx, %eax
	orl	%ecx, %eax
	cltd
	idivl	%ecx
	movl	%edx, %eax
	orl	%ecx, %eax
	cltd
	idivl	%ecx
	movl	%edx, %eax
	orl	%ecx, %eax
	cltd
	idivl	%ecx
	movl	%edx, %eax
	orl	%ecx, %eax
	cltd
	idivl	%ecx
	movl	%edx, %eax
	orl	%ecx, %eax
	cltd
	idivl	%ecx
	movl	%edx, %eax
	orl	%ecx, %eax
	cltd
	idivl	%ecx
	movl	%edx, %eax
	orl	%ecx, %eax
	cltd
	idivl	%ecx
	movl	%edx, %eax
	orl	%ecx, %eax
	cltd
	idivl	%ecx
	movl	%edx, %eax
	orl	%ecx, %eax
	cltd
	idivl	%ecx
	movl	%edx, %eax
	orl	%ecx, %eax
	subq	$1, %rsi
	cmpq	$-1, %rsi
	jne	.L67
.L66:
	movl	%eax, %edi
	call	use_int@PLT
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE79:
	.size	do_integer_mod, .-do_integer_mod
	.globl	do_int64_bitwise
	.type	do_int64_bitwise, @function
do_int64_bitwise:
.LFB80:
	.cfi_startproc
	endbr64
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	movq	%rdi, %rdx
	movslq	(%rsi), %rax
	movq	%rax, %rdi
	salq	$32, %rdi
	orq	%rax, %rdi
	movq	%rdx, %rsi
	salq	$32, %rsi
	orq	%rdx, %rsi
	movq	%rdx, %r8
	salq	$34, %r8
	testq	%rdx, %rdx
	je	.L71
	leaq	-1(%r8), %rax
	subq	%rdx, %r8
	subq	$1, %r8
.L72:
	xorq	%rax, %rdi
	movq	%rdi, %rcx
	xorq	%rsi, %rcx
	orq	%rsi, %rdi
	xorq	%rax, %rdi
	movq	%rcx, %rdx
	xorq	%rdi, %rdx
	orq	%rdi, %rcx
	xorq	%rax, %rcx
	movq	%rdx, %rsi
	xorq	%rcx, %rsi
	orq	%rcx, %rdx
	xorq	%rax, %rdx
	movq	%rsi, %rcx
	xorq	%rdx, %rcx
	orq	%rdx, %rsi
	xorq	%rax, %rsi
	movq	%rcx, %rdx
	xorq	%rsi, %rdx
	orq	%rsi, %rcx
	xorq	%rax, %rcx
	movq	%rdx, %rsi
	xorq	%rcx, %rsi
	orq	%rcx, %rdx
	xorq	%rax, %rdx
	movq	%rsi, %rcx
	xorq	%rdx, %rcx
	orq	%rdx, %rsi
	xorq	%rax, %rsi
	movq	%rcx, %rdx
	xorq	%rsi, %rdx
	orq	%rsi, %rcx
	xorq	%rax, %rcx
	movq	%rdx, %rsi
	xorq	%rcx, %rsi
	orq	%rcx, %rdx
	xorq	%rax, %rdx
	movq	%rsi, %rcx
	xorq	%rdx, %rcx
	orq	%rdx, %rsi
	xorq	%rax, %rsi
	movq	%rcx, %rdx
	xorq	%rsi, %rdx
	orq	%rsi, %rcx
	xorq	%rax, %rcx
	movq	%rdx, %rsi
	xorq	%rcx, %rsi
	orq	%rcx, %rdx
	xorq	%rax, %rdx
	movq	%rsi, %rcx
	xorq	%rdx, %rcx
	orq	%rdx, %rsi
	xorq	%rax, %rsi
	movq	%rcx, %rdx
	xorq	%rsi, %rdx
	orq	%rsi, %rcx
	xorq	%rax, %rcx
	movq	%rdx, %rsi
	xorq	%rcx, %rsi
	orq	%rcx, %rdx
	xorq	%rax, %rdx
	movq	%rsi, %rcx
	xorq	%rdx, %rcx
	orq	%rdx, %rsi
	xorq	%rax, %rsi
	movq	%rcx, %rdx
	xorq	%rsi, %rdx
	orq	%rsi, %rcx
	xorq	%rax, %rcx
	movq	%rdx, %rsi
	xorq	%rcx, %rsi
	orq	%rcx, %rdx
	xorq	%rax, %rdx
	movq	%rsi, %rcx
	xorq	%rdx, %rcx
	orq	%rdx, %rsi
	xorq	%rax, %rsi
	movq	%rcx, %rdx
	xorq	%rsi, %rdx
	orq	%rsi, %rcx
	xorq	%rax, %rcx
	movq	%rdx, %rsi
	xorq	%rcx, %rsi
	orq	%rcx, %rdx
	xorq	%rax, %rdx
	movq	%rsi, %rcx
	xorq	%rdx, %rcx
	orq	%rdx, %rsi
	xorq	%rax, %rsi
	movq	%rcx, %rdx
	xorq	%rsi, %rdx
	orq	%rsi, %rcx
	xorq	%rax, %rcx
	movq	%rdx, %rsi
	xorq	%rcx, %rsi
	orq	%rcx, %rdx
	xorq	%rax, %rdx
	movq	%rsi, %rcx
	xorq	%rdx, %rcx
	orq	%rdx, %rsi
	xorq	%rax, %rsi
	movq	%rcx, %rdx
	xorq	%rsi, %rdx
	orq	%rsi, %rcx
	xorq	%rax, %rcx
	movq	%rdx, %rsi
	xorq	%rcx, %rsi
	orq	%rcx, %rdx
	xorq	%rax, %rdx
	movq	%rsi, %rcx
	xorq	%rdx, %rcx
	orq	%rdx, %rsi
	xorq	%rax, %rsi
	movq	%rcx, %rdx
	xorq	%rsi, %rdx
	orq	%rsi, %rcx
	xorq	%rax, %rcx
	movq	%rdx, %rsi
	xorq	%rcx, %rsi
	orq	%rcx, %rdx
	xorq	%rax, %rdx
	movq	%rsi, %rcx
	xorq	%rdx, %rcx
	orq	%rdx, %rsi
	xorq	%rax, %rsi
	movq	%rcx, %rdx
	xorq	%rsi, %rdx
	orq	%rsi, %rcx
	xorq	%rax, %rcx
	movq	%rdx, %rsi
	xorq	%rcx, %rsi
	orq	%rcx, %rdx
	xorq	%rax, %rdx
	movq	%rsi, %rcx
	xorq	%rdx, %rcx
	orq	%rdx, %rsi
	xorq	%rax, %rsi
	movq	%rcx, %rdx
	xorq	%rsi, %rdx
	orq	%rsi, %rcx
	xorq	%rax, %rcx
	movq	%rdx, %rsi
	xorq	%rcx, %rsi
	orq	%rcx, %rdx
	xorq	%rax, %rdx
	movq	%rsi, %rcx
	xorq	%rdx, %rcx
	orq	%rdx, %rsi
	xorq	%rax, %rsi
	movq	%rcx, %rdx
	xorq	%rsi, %rdx
	orq	%rsi, %rcx
	xorq	%rax, %rcx
	movq	%rdx, %rsi
	xorq	%rcx, %rsi
	orq	%rcx, %rdx
	xorq	%rax, %rdx
	movq	%rsi, %rcx
	xorq	%rdx, %rcx
	orq	%rdx, %rsi
	xorq	%rax, %rsi
	movq	%rcx, %rdx
	xorq	%rsi, %rdx
	orq	%rsi, %rcx
	xorq	%rax, %rcx
	movq	%rdx, %rsi
	xorq	%rcx, %rsi
	orq	%rcx, %rdx
	xorq	%rax, %rdx
	movq	%rsi, %rcx
	xorq	%rdx, %rcx
	orq	%rdx, %rsi
	xorq	%rax, %rsi
	movq	%rcx, %rdx
	xorq	%rsi, %rdx
	orq	%rsi, %rcx
	xorq	%rax, %rcx
	movq	%rdx, %rsi
	xorq	%rcx, %rsi
	orq	%rcx, %rdx
	xorq	%rax, %rdx
	movq	%rsi, %rcx
	xorq	%rdx, %rcx
	orq	%rdx, %rsi
	xorq	%rax, %rsi
	movq	%rcx, %rdx
	xorq	%rsi, %rdx
	orq	%rsi, %rcx
	xorq	%rax, %rcx
	movq	%rdx, %rsi
	xorq	%rcx, %rsi
	orq	%rcx, %rdx
	xorq	%rax, %rdx
	movq	%rsi, %rcx
	xorq	%rdx, %rcx
	orq	%rdx, %rsi
	xorq	%rax, %rsi
	movq	%rcx, %rdx
	xorq	%rsi, %rdx
	orq	%rsi, %rcx
	xorq	%rax, %rcx
	movq	%rdx, %rsi
	xorq	%rcx, %rsi
	orq	%rcx, %rdx
	xorq	%rax, %rdx
	movq	%rsi, %rcx
	xorq	%rdx, %rcx
	orq	%rdx, %rsi
	xorq	%rax, %rsi
	movq	%rcx, %rdx
	xorq	%rsi, %rdx
	orq	%rsi, %rcx
	xorq	%rax, %rcx
	movq	%rdx, %rsi
	xorq	%rcx, %rsi
	orq	%rcx, %rdx
	xorq	%rax, %rdx
	movq	%rsi, %rcx
	xorq	%rdx, %rcx
	orq	%rdx, %rsi
	xorq	%rax, %rsi
	movq	%rcx, %rdx
	xorq	%rsi, %rdx
	orq	%rsi, %rcx
	xorq	%rax, %rcx
	movq	%rdx, %rsi
	xorq	%rcx, %rsi
	orq	%rcx, %rdx
	xorq	%rax, %rdx
	movq	%rsi, %rcx
	xorq	%rdx, %rcx
	orq	%rdx, %rsi
	xorq	%rax, %rsi
	movq	%rcx, %rdx
	xorq	%rsi, %rdx
	orq	%rsi, %rcx
	xorq	%rax, %rcx
	movq	%rdx, %rsi
	xorq	%rcx, %rsi
	orq	%rcx, %rdx
	xorq	%rax, %rdx
	movq	%rsi, %rcx
	xorq	%rdx, %rcx
	orq	%rdx, %rsi
	xorq	%rax, %rsi
	movq	%rcx, %rdx
	xorq	%rsi, %rdx
	orq	%rsi, %rcx
	xorq	%rax, %rcx
	movq	%rdx, %rsi
	xorq	%rcx, %rsi
	orq	%rcx, %rdx
	xorq	%rax, %rdx
	movq	%rsi, %rcx
	xorq	%rdx, %rcx
	orq	%rdx, %rsi
	xorq	%rax, %rsi
	movq	%rcx, %rdx
	xorq	%rsi, %rdx
	orq	%rsi, %rcx
	xorq	%rax, %rcx
	movq	%rdx, %rsi
	xorq	%rcx, %rsi
	orq	%rcx, %rdx
	xorq	%rax, %rdx
	movq	%rsi, %rcx
	xorq	%rdx, %rcx
	orq	%rdx, %rsi
	xorq	%rax, %rsi
	movq	%rcx, %rdx
	xorq	%rsi, %rdx
	orq	%rsi, %rcx
	xorq	%rax, %rcx
	movq	%rdx, %rsi
	xorq	%rcx, %rsi
	orq	%rcx, %rdx
	xorq	%rax, %rdx
	movq	%rsi, %rcx
	xorq	%rdx, %rcx
	orq	%rdx, %rsi
	xorq	%rax, %rsi
	movq	%rcx, %rdx
	xorq	%rsi, %rdx
	orq	%rsi, %rcx
	xorq	%rax, %rcx
	movq	%rdx, %rsi
	xorq	%rcx, %rsi
	orq	%rcx, %rdx
	xorq	%rax, %rdx
	movq	%rsi, %rcx
	xorq	%rdx, %rcx
	orq	%rdx, %rsi
	xorq	%rax, %rsi
	movq	%rcx, %rdx
	xorq	%rsi, %rdx
	orq	%rsi, %rcx
	xorq	%rax, %rcx
	movq	%rdx, %rsi
	xorq	%rcx, %rsi
	orq	%rcx, %rdx
	xorq	%rax, %rdx
	movq	%rsi, %rcx
	xorq	%rdx, %rcx
	orq	%rdx, %rsi
	xorq	%rax, %rsi
	movq	%rcx, %rdx
	xorq	%rsi, %rdx
	orq	%rsi, %rcx
	xorq	%rax, %rcx
	movq	%rdx, %rsi
	xorq	%rcx, %rsi
	orq	%rcx, %rdx
	xorq	%rax, %rdx
	movq	%rsi, %rcx
	xorq	%rdx, %rcx
	orq	%rdx, %rsi
	xorq	%rax, %rsi
	movq	%rcx, %rdx
	xorq	%rsi, %rdx
	orq	%rsi, %rcx
	xorq	%rax, %rcx
	movq	%rdx, %rsi
	xorq	%rcx, %rsi
	orq	%rcx, %rdx
	xorq	%rax, %rdx
	movq	%rsi, %rcx
	xorq	%rdx, %rcx
	orq	%rdx, %rsi
	xorq	%rax, %rsi
	movq	%rcx, %rdx
	xorq	%rsi, %rdx
	orq	%rsi, %rcx
	xorq	%rax, %rcx
	movq	%rdx, %rsi
	xorq	%rcx, %rsi
	orq	%rcx, %rdx
	xorq	%rax, %rdx
	movq	%rsi, %rcx
	xorq	%rdx, %rcx
	orq	%rdx, %rsi
	xorq	%rax, %rsi
	movq	%rcx, %rdx
	xorq	%rsi, %rdx
	orq	%rsi, %rcx
	xorq	%rax, %rcx
	movq	%rdx, %rsi
	xorq	%rcx, %rsi
	orq	%rcx, %rdx
	xorq	%rax, %rdx
	movq	%rsi, %rcx
	xorq	%rdx, %rcx
	orq	%rdx, %rsi
	xorq	%rax, %rsi
	movq	%rcx, %rdx
	xorq	%rsi, %rdx
	orq	%rsi, %rcx
	xorq	%rax, %rcx
	movq	%rdx, %rsi
	xorq	%rcx, %rsi
	orq	%rcx, %rdx
	xorq	%rax, %rdx
	movq	%rsi, %rcx
	xorq	%rdx, %rcx
	orq	%rdx, %rsi
	xorq	%rax, %rsi
	movq	%rcx, %rdx
	xorq	%rsi, %rdx
	orq	%rsi, %rcx
	xorq	%rax, %rcx
	movq	%rdx, %rsi
	xorq	%rcx, %rsi
	orq	%rcx, %rdx
	xorq	%rax, %rdx
	movq	%rsi, %rcx
	xorq	%rdx, %rcx
	orq	%rdx, %rsi
	xorq	%rax, %rsi
	movq	%rcx, %rdx
	xorq	%rsi, %rdx
	orq	%rsi, %rcx
	xorq	%rax, %rcx
	movq	%rdx, %rsi
	xorq	%rcx, %rsi
	orq	%rcx, %rdx
	xorq	%rax, %rdx
	movq	%rsi, %rcx
	xorq	%rdx, %rcx
	orq	%rdx, %rsi
	xorq	%rax, %rsi
	movq	%rcx, %rdx
	xorq	%rsi, %rdx
	orq	%rsi, %rcx
	xorq	%rax, %rcx
	movq	%rdx, %rdi
	xorq	%rcx, %rdi
	orq	%rcx, %rdx
	xorq	%rax, %rdx
	movq	%rdi, %rsi
	xorq	%rdx, %rsi
	orq	%rdx, %rdi
	subq	$1, %rax
	cmpq	%r8, %rax
	jne	.L72
.L71:
	call	use_int@PLT
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE80:
	.size	do_int64_bitwise, .-do_int64_bitwise
	.globl	do_int64_add
	.type	do_int64_add, @function
do_int64_add:
.LFB81:
	.cfi_startproc
	endbr64
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	movl	(%rsi), %eax
	movslq	%eax, %rcx
	leal	254(%rax), %edx
	movslq	%edx, %rdx
	salq	$30, %rdx
	leaq	37420(%rcx,%rdx), %rdx
	addl	$65534, %eax
	cltq
	salq	$29, %rax
	leaq	21698324(%rcx,%rax), %rsi
	leaq	-1(%rdi), %rcx
	testq	%rdi, %rdi
	je	.L77
.L76:
	movl	$1, %eax
.L78:
	leaq	(%rax,%rdx,2), %rdx
	leaq	(%rax,%rdx,2), %rdx
	leaq	(%rax,%rdx,2), %rdx
	leaq	(%rax,%rdx,2), %rdx
	leaq	(%rax,%rdx,2), %rdx
	leaq	(%rax,%rdx,2), %rdx
	leaq	(%rax,%rdx,2), %rdx
	leaq	(%rax,%rdx,2), %rdx
	leaq	(%rax,%rdx,2), %rdx
	leaq	(%rax,%rdx,2), %rdx
	addq	$1, %rax
	cmpq	$1001, %rax
	jne	.L78
	subq	$1, %rcx
	cmpq	$-1, %rcx
	jne	.L76
.L77:
	leal	(%rdx,%rsi), %edi
	call	use_int@PLT
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE81:
	.size	do_int64_add, .-do_int64_add
	.globl	do_int64_mul
	.type	do_int64_mul, @function
do_int64_mul:
.LFB82:
	.cfi_startproc
	endbr64
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	movq	%rdi, %r8
	movl	(%rsi), %edx
	movslq	%edx, %rcx
	leaq	4(%rcx), %rax
	addl	$6, %edx
	salq	$32, %rdx
	leaq	37420(%rcx,%rdx), %rdi
	movq	%rax, %rdx
	imulq	%rdi, %rdx
	imulq	%rax, %rdx
	imulq	%rax, %rdx
	imulq	%rax, %rdx
	imulq	%rax, %rdx
	imulq	%rax, %rdx
	imulq	%rax, %rdx
	imulq	%rax, %rdx
	imulq	%rax, %rdx
	imulq	%rax, %rdx
	subq	%rdi, %rdx
	leaq	-1(%r8), %rcx
	testq	%r8, %r8
	je	.L83
.L84:
	imulq	%rax, %rdi
	imulq	%rax, %rdi
	imulq	%rax, %rdi
	imulq	%rax, %rdi
	imulq	%rax, %rdi
	imulq	%rax, %rdi
	imulq	%rax, %rdi
	imulq	%rax, %rdi
	imulq	%rax, %rdi
	imulq	%rax, %rdi
	subq	%rdx, %rdi
	imulq	%rax, %rdi
	imulq	%rax, %rdi
	imulq	%rax, %rdi
	imulq	%rax, %rdi
	imulq	%rax, %rdi
	imulq	%rax, %rdi
	imulq	%rax, %rdi
	imulq	%rax, %rdi
	imulq	%rax, %rdi
	imulq	%rax, %rdi
	subq	%rdx, %rdi
	subq	$1, %rcx
	cmpq	$-1, %rcx
	jne	.L84
.L83:
	call	use_int@PLT
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE82:
	.size	do_int64_mul, .-do_int64_mul
	.globl	do_int64_div
	.type	do_int64_div, @function
do_int64_div:
.LFB83:
	.cfi_startproc
	endbr64
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	movslq	(%rsi), %rax
	addq	$36, %rax
	movq	%rax, %rcx
	salq	$33, %rcx
	addq	%rax, %rcx
	movq	%rcx, %rsi
	addq	$17, %rcx
	salq	$13, %rcx
	leaq	-1(%rdi), %r8
	testq	%rdi, %rdi
	je	.L88
.L89:
	movq	%rcx, %rax
	cqto
	idivq	%rsi
	movq	%rax, %rsi
	movq	%rcx, %rax
	cqto
	idivq	%rsi
	movq	%rax, %rsi
	movq	%rcx, %rax
	cqto
	idivq	%rsi
	movq	%rax, %rsi
	movq	%rcx, %rax
	cqto
	idivq	%rsi
	movq	%rax, %rsi
	movq	%rcx, %rax
	cqto
	idivq	%rsi
	movq	%rax, %rsi
	movq	%rcx, %rax
	cqto
	idivq	%rsi
	movq	%rax, %rsi
	movq	%rcx, %rax
	cqto
	idivq	%rsi
	movq	%rax, %rsi
	movq	%rcx, %rax
	cqto
	idivq	%rsi
	movq	%rax, %rsi
	movq	%rcx, %rax
	cqto
	idivq	%rsi
	movq	%rax, %rsi
	movq	%rcx, %rax
	cqto
	idivq	%rsi
	movq	%rax, %rsi
	movq	%rcx, %rax
	cqto
	idivq	%rsi
	movq	%rax, %rsi
	movq	%rcx, %rax
	cqto
	idivq	%rsi
	movq	%rax, %rsi
	movq	%rcx, %rax
	cqto
	idivq	%rsi
	movq	%rax, %rsi
	movq	%rcx, %rax
	cqto
	idivq	%rsi
	movq	%rax, %rsi
	movq	%rcx, %rax
	cqto
	idivq	%rsi
	movq	%rax, %rsi
	movq	%rcx, %rax
	cqto
	idivq	%rsi
	movq	%rax, %rsi
	movq	%rcx, %rax
	cqto
	idivq	%rsi
	movq	%rax, %rsi
	movq	%rcx, %rax
	cqto
	idivq	%rsi
	movq	%rax, %rsi
	movq	%rcx, %rax
	cqto
	idivq	%rsi
	movq	%rax, %rsi
	movq	%rcx, %rax
	cqto
	idivq	%rsi
	movq	%rax, %rsi
	movq	%rcx, %rax
	cqto
	idivq	%rsi
	movq	%rax, %rsi
	movq	%rcx, %rax
	cqto
	idivq	%rsi
	movq	%rax, %rsi
	movq	%rcx, %rax
	cqto
	idivq	%rsi
	movq	%rax, %rsi
	movq	%rcx, %rax
	cqto
	idivq	%rsi
	movq	%rax, %rsi
	movq	%rcx, %rax
	cqto
	idivq	%rsi
	movq	%rax, %rsi
	movq	%rcx, %rax
	cqto
	idivq	%rsi
	movq	%rax, %rsi
	movq	%rcx, %rax
	cqto
	idivq	%rsi
	movq	%rax, %rsi
	movq	%rcx, %rax
	cqto
	idivq	%rsi
	movq	%rax, %rsi
	movq	%rcx, %rax
	cqto
	idivq	%rsi
	movq	%rax, %rsi
	movq	%rcx, %rax
	cqto
	idivq	%rsi
	movq	%rax, %rsi
	movq	%rcx, %rax
	cqto
	idivq	%rsi
	movq	%rax, %rsi
	movq	%rcx, %rax
	cqto
	idivq	%rsi
	movq	%rax, %rsi
	movq	%rcx, %rax
	cqto
	idivq	%rsi
	movq	%rax, %rsi
	movq	%rcx, %rax
	cqto
	idivq	%rsi
	movq	%rax, %rsi
	movq	%rcx, %rax
	cqto
	idivq	%rsi
	movq	%rax, %rsi
	movq	%rcx, %rax
	cqto
	idivq	%rsi
	movq	%rax, %rsi
	movq	%rcx, %rax
	cqto
	idivq	%rsi
	movq	%rax, %rsi
	movq	%rcx, %rax
	cqto
	idivq	%rsi
	movq	%rax, %rsi
	movq	%rcx, %rax
	cqto
	idivq	%rsi
	movq	%rax, %rsi
	movq	%rcx, %rax
	cqto
	idivq	%rsi
	movq	%rax, %rsi
	movq	%rcx, %rax
	cqto
	idivq	%rsi
	movq	%rax, %rsi
	movq	%rcx, %rax
	cqto
	idivq	%rsi
	movq	%rax, %rsi
	movq	%rcx, %rax
	cqto
	idivq	%rsi
	movq	%rax, %rsi
	movq	%rcx, %rax
	cqto
	idivq	%rsi
	movq	%rax, %rsi
	movq	%rcx, %rax
	cqto
	idivq	%rsi
	movq	%rax, %rsi
	movq	%rcx, %rax
	cqto
	idivq	%rsi
	movq	%rax, %rsi
	movq	%rcx, %rax
	cqto
	idivq	%rsi
	movq	%rax, %rsi
	movq	%rcx, %rax
	cqto
	idivq	%rsi
	movq	%rax, %rsi
	movq	%rcx, %rax
	cqto
	idivq	%rsi
	movq	%rax, %rsi
	movq	%rcx, %rax
	cqto
	idivq	%rsi
	movq	%rax, %rsi
	movq	%rcx, %rax
	cqto
	idivq	%rsi
	movq	%rax, %rsi
	movq	%rcx, %rax
	cqto
	idivq	%rsi
	movq	%rax, %rsi
	movq	%rcx, %rax
	cqto
	idivq	%rsi
	movq	%rax, %rsi
	movq	%rcx, %rax
	cqto
	idivq	%rsi
	movq	%rax, %rsi
	movq	%rcx, %rax
	cqto
	idivq	%rsi
	movq	%rax, %rsi
	movq	%rcx, %rax
	cqto
	idivq	%rsi
	movq	%rax, %rsi
	movq	%rcx, %rax
	cqto
	idivq	%rsi
	movq	%rax, %rsi
	movq	%rcx, %rax
	cqto
	idivq	%rsi
	movq	%rax, %rsi
	movq	%rcx, %rax
	cqto
	idivq	%rsi
	movq	%rax, %rsi
	movq	%rcx, %rax
	cqto
	idivq	%rsi
	movq	%rax, %rsi
	movq	%rcx, %rax
	cqto
	idivq	%rsi
	movq	%rax, %rsi
	movq	%rcx, %rax
	cqto
	idivq	%rsi
	movq	%rax, %rsi
	movq	%rcx, %rax
	cqto
	idivq	%rsi
	movq	%rax, %rsi
	movq	%rcx, %rax
	cqto
	idivq	%rsi
	movq	%rax, %rsi
	movq	%rcx, %rax
	cqto
	idivq	%rsi
	movq	%rax, %rsi
	movq	%rcx, %rax
	cqto
	idivq	%rsi
	movq	%rax, %rsi
	movq	%rcx, %rax
	cqto
	idivq	%rsi
	movq	%rax, %rsi
	movq	%rcx, %rax
	cqto
	idivq	%rsi
	movq	%rax, %rsi
	movq	%rcx, %rax
	cqto
	idivq	%rsi
	movq	%rax, %rsi
	movq	%rcx, %rax
	cqto
	idivq	%rsi
	movq	%rax, %rsi
	movq	%rcx, %rax
	cqto
	idivq	%rsi
	movq	%rax, %rsi
	movq	%rcx, %rax
	cqto
	idivq	%rsi
	movq	%rax, %rsi
	movq	%rcx, %rax
	cqto
	idivq	%rsi
	movq	%rax, %rsi
	movq	%rcx, %rax
	cqto
	idivq	%rsi
	movq	%rax, %rsi
	movq	%rcx, %rax
	cqto
	idivq	%rsi
	movq	%rax, %rsi
	movq	%rcx, %rax
	cqto
	idivq	%rsi
	movq	%rax, %rsi
	movq	%rcx, %rax
	cqto
	idivq	%rsi
	movq	%rax, %rsi
	movq	%rcx, %rax
	cqto
	idivq	%rsi
	movq	%rax, %rsi
	movq	%rcx, %rax
	cqto
	idivq	%rsi
	movq	%rax, %rsi
	movq	%rcx, %rax
	cqto
	idivq	%rsi
	movq	%rax, %rsi
	movq	%rcx, %rax
	cqto
	idivq	%rsi
	movq	%rax, %rsi
	movq	%rcx, %rax
	cqto
	idivq	%rsi
	movq	%rax, %rsi
	movq	%rcx, %rax
	cqto
	idivq	%rsi
	movq	%rax, %rsi
	movq	%rcx, %rax
	cqto
	idivq	%rsi
	movq	%rax, %rsi
	movq	%rcx, %rax
	cqto
	idivq	%rsi
	movq	%rax, %rsi
	movq	%rcx, %rax
	cqto
	idivq	%rsi
	movq	%rax, %rsi
	movq	%rcx, %rax
	cqto
	idivq	%rsi
	movq	%rax, %rsi
	movq	%rcx, %rax
	cqto
	idivq	%rsi
	movq	%rax, %rsi
	movq	%rcx, %rax
	cqto
	idivq	%rsi
	movq	%rax, %rsi
	movq	%rcx, %rax
	cqto
	idivq	%rsi
	movq	%rax, %rsi
	movq	%rcx, %rax
	cqto
	idivq	%rsi
	movq	%rax, %rsi
	movq	%rcx, %rax
	cqto
	idivq	%rsi
	movq	%rax, %rsi
	movq	%rcx, %rax
	cqto
	idivq	%rsi
	movq	%rax, %rsi
	movq	%rcx, %rax
	cqto
	idivq	%rsi
	movq	%rax, %rsi
	movq	%rcx, %rax
	cqto
	idivq	%rsi
	movq	%rax, %rsi
	movq	%rcx, %rax
	cqto
	idivq	%rsi
	movq	%rax, %rsi
	movq	%rcx, %rax
	cqto
	idivq	%rsi
	movq	%rax, %rsi
	movq	%rcx, %rax
	cqto
	idivq	%rsi
	movq	%rax, %rsi
	movq	%rcx, %rax
	cqto
	idivq	%rsi
	movq	%rax, %rsi
	movq	%rcx, %rax
	cqto
	idivq	%rsi
	movq	%rax, %rsi
	subq	$1, %r8
	cmpq	$-1, %r8
	jne	.L89
.L88:
	movl	%esi, %edi
	call	use_int@PLT
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE83:
	.size	do_int64_div, .-do_int64_div
	.globl	do_int64_mod
	.type	do_int64_mod, @function
do_int64_mod:
.LFB84:
	.cfi_startproc
	endbr64
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	movq	%rdi, %rax
	salq	$32, %rax
	addq	%rdi, %rax
	movslq	(%rsi), %rdx
	movq	%rdx, %rsi
	salq	$56, %rsi
	addq	%rdx, %rsi
	movq	%rsi, %rcx
	leaq	-1(%rdi), %r8
	testq	%rdi, %rdi
	je	.L93
.L94:
	cqto
	idivq	%rcx
	movq	%rdx, %rax
	orq	%rsi, %rax
	cqto
	idivq	%rcx
	movq	%rdx, %rax
	orq	%rsi, %rax
	cqto
	idivq	%rcx
	movq	%rdx, %rax
	orq	%rsi, %rax
	cqto
	idivq	%rcx
	movq	%rdx, %rax
	orq	%rsi, %rax
	cqto
	idivq	%rcx
	movq	%rdx, %rax
	orq	%rsi, %rax
	cqto
	idivq	%rcx
	movq	%rdx, %rax
	orq	%rsi, %rax
	cqto
	idivq	%rcx
	movq	%rdx, %rax
	orq	%rsi, %rax
	cqto
	idivq	%rcx
	movq	%rdx, %rax
	orq	%rsi, %rax
	cqto
	idivq	%rcx
	movq	%rdx, %rax
	orq	%rsi, %rax
	cqto
	idivq	%rcx
	movq	%rdx, %rax
	orq	%rsi, %rax
	cqto
	idivq	%rcx
	movq	%rdx, %rax
	orq	%rsi, %rax
	cqto
	idivq	%rcx
	movq	%rdx, %rax
	orq	%rsi, %rax
	cqto
	idivq	%rcx
	movq	%rdx, %rax
	orq	%rsi, %rax
	cqto
	idivq	%rcx
	movq	%rdx, %rax
	orq	%rsi, %rax
	cqto
	idivq	%rcx
	movq	%rdx, %rax
	orq	%rsi, %rax
	cqto
	idivq	%rcx
	movq	%rdx, %rax
	orq	%rsi, %rax
	cqto
	idivq	%rcx
	movq	%rdx, %rax
	orq	%rsi, %rax
	cqto
	idivq	%rcx
	movq	%rdx, %rax
	orq	%rsi, %rax
	cqto
	idivq	%rcx
	movq	%rdx, %rax
	orq	%rsi, %rax
	cqto
	idivq	%rcx
	movq	%rdx, %rax
	orq	%rsi, %rax
	cqto
	idivq	%rcx
	movq	%rdx, %rax
	orq	%rsi, %rax
	cqto
	idivq	%rcx
	movq	%rdx, %rax
	orq	%rsi, %rax
	cqto
	idivq	%rcx
	movq	%rdx, %rax
	orq	%rsi, %rax
	cqto
	idivq	%rcx
	movq	%rdx, %rax
	orq	%rsi, %rax
	cqto
	idivq	%rcx
	movq	%rdx, %rax
	orq	%rsi, %rax
	cqto
	idivq	%rcx
	movq	%rdx, %rax
	orq	%rsi, %rax
	cqto
	idivq	%rcx
	movq	%rdx, %rax
	orq	%rsi, %rax
	cqto
	idivq	%rcx
	movq	%rdx, %rax
	orq	%rsi, %rax
	cqto
	idivq	%rcx
	movq	%rdx, %rax
	orq	%rsi, %rax
	cqto
	idivq	%rcx
	movq	%rdx, %rax
	orq	%rsi, %rax
	cqto
	idivq	%rcx
	movq	%rdx, %rax
	orq	%rsi, %rax
	cqto
	idivq	%rcx
	movq	%rdx, %rax
	orq	%rsi, %rax
	cqto
	idivq	%rcx
	movq	%rdx, %rax
	orq	%rsi, %rax
	cqto
	idivq	%rcx
	movq	%rdx, %rax
	orq	%rsi, %rax
	cqto
	idivq	%rcx
	movq	%rdx, %rax
	orq	%rsi, %rax
	cqto
	idivq	%rcx
	movq	%rdx, %rax
	orq	%rsi, %rax
	cqto
	idivq	%rcx
	movq	%rdx, %rax
	orq	%rsi, %rax
	cqto
	idivq	%rcx
	movq	%rdx, %rax
	orq	%rsi, %rax
	cqto
	idivq	%rcx
	movq	%rdx, %rax
	orq	%rsi, %rax
	cqto
	idivq	%rcx
	movq	%rdx, %rax
	orq	%rsi, %rax
	cqto
	idivq	%rcx
	movq	%rdx, %rax
	orq	%rsi, %rax
	cqto
	idivq	%rcx
	movq	%rdx, %rax
	orq	%rsi, %rax
	cqto
	idivq	%rcx
	movq	%rdx, %rax
	orq	%rsi, %rax
	cqto
	idivq	%rcx
	movq	%rdx, %rax
	orq	%rsi, %rax
	cqto
	idivq	%rcx
	movq	%rdx, %rax
	orq	%rsi, %rax
	cqto
	idivq	%rcx
	movq	%rdx, %rax
	orq	%rsi, %rax
	cqto
	idivq	%rcx
	movq	%rdx, %rax
	orq	%rsi, %rax
	cqto
	idivq	%rcx
	movq	%rdx, %rax
	orq	%rsi, %rax
	cqto
	idivq	%rcx
	movq	%rdx, %rax
	orq	%rsi, %rax
	cqto
	idivq	%rcx
	movq	%rdx, %rax
	orq	%rsi, %rax
	cqto
	idivq	%rcx
	movq	%rdx, %rax
	orq	%rsi, %rax
	cqto
	idivq	%rcx
	movq	%rdx, %rax
	orq	%rsi, %rax
	cqto
	idivq	%rcx
	movq	%rdx, %rax
	orq	%rsi, %rax
	cqto
	idivq	%rcx
	movq	%rdx, %rax
	orq	%rsi, %rax
	cqto
	idivq	%rcx
	movq	%rdx, %rax
	orq	%rsi, %rax
	cqto
	idivq	%rcx
	movq	%rdx, %rax
	orq	%rsi, %rax
	cqto
	idivq	%rcx
	movq	%rdx, %rax
	orq	%rsi, %rax
	cqto
	idivq	%rcx
	movq	%rdx, %rax
	orq	%rsi, %rax
	cqto
	idivq	%rcx
	movq	%rdx, %rax
	orq	%rsi, %rax
	cqto
	idivq	%rcx
	movq	%rdx, %rax
	orq	%rsi, %rax
	cqto
	idivq	%rcx
	movq	%rdx, %rax
	orq	%rsi, %rax
	cqto
	idivq	%rcx
	movq	%rdx, %rax
	orq	%rsi, %rax
	cqto
	idivq	%rcx
	movq	%rdx, %rax
	orq	%rsi, %rax
	cqto
	idivq	%rcx
	movq	%rdx, %rax
	orq	%rsi, %rax
	cqto
	idivq	%rcx
	movq	%rdx, %rax
	orq	%rsi, %rax
	cqto
	idivq	%rcx
	movq	%rdx, %rax
	orq	%rsi, %rax
	cqto
	idivq	%rcx
	movq	%rdx, %rax
	orq	%rsi, %rax
	cqto
	idivq	%rcx
	movq	%rdx, %rax
	orq	%rsi, %rax
	cqto
	idivq	%rcx
	movq	%rdx, %rax
	orq	%rsi, %rax
	cqto
	idivq	%rcx
	movq	%rdx, %rax
	orq	%rsi, %rax
	cqto
	idivq	%rcx
	movq	%rdx, %rax
	orq	%rsi, %rax
	cqto
	idivq	%rcx
	movq	%rdx, %rax
	orq	%rsi, %rax
	cqto
	idivq	%rcx
	movq	%rdx, %rax
	orq	%rsi, %rax
	cqto
	idivq	%rcx
	movq	%rdx, %rax
	orq	%rsi, %rax
	cqto
	idivq	%rcx
	movq	%rdx, %rax
	orq	%rsi, %rax
	cqto
	idivq	%rcx
	movq	%rdx, %rax
	orq	%rsi, %rax
	cqto
	idivq	%rcx
	movq	%rdx, %rax
	orq	%rsi, %rax
	cqto
	idivq	%rcx
	movq	%rdx, %rax
	orq	%rsi, %rax
	cqto
	idivq	%rcx
	movq	%rdx, %rax
	orq	%rsi, %rax
	cqto
	idivq	%rcx
	movq	%rdx, %rax
	orq	%rsi, %rax
	cqto
	idivq	%rcx
	movq	%rdx, %rax
	orq	%rsi, %rax
	cqto
	idivq	%rcx
	movq	%rdx, %rax
	orq	%rsi, %rax
	cqto
	idivq	%rcx
	movq	%rdx, %rax
	orq	%rsi, %rax
	cqto
	idivq	%rcx
	movq	%rdx, %rax
	orq	%rsi, %rax
	cqto
	idivq	%rcx
	movq	%rdx, %rax
	orq	%rsi, %rax
	cqto
	idivq	%rcx
	movq	%rdx, %rax
	orq	%rsi, %rax
	cqto
	idivq	%rcx
	movq	%rdx, %rax
	orq	%rsi, %rax
	cqto
	idivq	%rcx
	movq	%rdx, %rax
	orq	%rsi, %rax
	cqto
	idivq	%rcx
	movq	%rdx, %rax
	orq	%rsi, %rax
	cqto
	idivq	%rcx
	movq	%rdx, %rax
	orq	%rsi, %rax
	cqto
	idivq	%rcx
	movq	%rdx, %rax
	orq	%rsi, %rax
	cqto
	idivq	%rcx
	movq	%rdx, %rax
	orq	%rsi, %rax
	cqto
	idivq	%rcx
	movq	%rdx, %rax
	orq	%rsi, %rax
	cqto
	idivq	%rcx
	movq	%rdx, %rax
	orq	%rsi, %rax
	cqto
	idivq	%rcx
	movq	%rdx, %rax
	orq	%rsi, %rax
	cqto
	idivq	%rcx
	movq	%rdx, %rax
	orq	%rsi, %rax
	cqto
	idivq	%rcx
	movq	%rdx, %rax
	orq	%rsi, %rax
	cqto
	idivq	%rcx
	movq	%rdx, %rax
	orq	%rsi, %rax
	cqto
	idivq	%rcx
	movq	%rdx, %rax
	orq	%rsi, %rax
	cqto
	idivq	%rcx
	movq	%rdx, %rax
	orq	%rsi, %rax
	subq	$1, %r8
	cmpq	$-1, %r8
	jne	.L94
.L93:
	movl	%eax, %edi
	call	use_int@PLT
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE84:
	.size	do_int64_mod, .-do_int64_mod
	.globl	do_float_add
	.type	do_float_add, @function
do_float_add:
.LFB85:
	.cfi_startproc
	endbr64
	subq	$24, %rsp
	.cfi_def_cfa_offset 32
	pxor	%xmm0, %xmm0
	cvtsi2ssl	(%rsi), %xmm0
	pxor	%xmm2, %xmm2
	cvtsi2ssl	8(%rsi), %xmm2
	movss	%xmm2, 12(%rsp)
	leaq	-1(%rdi), %rax
	testq	%rdi, %rdi
	je	.L98
.L99:
	addss	%xmm0, %xmm0
	addss	%xmm0, %xmm0
	addss	%xmm0, %xmm0
	addss	%xmm0, %xmm0
	addss	%xmm0, %xmm0
	addss	%xmm0, %xmm0
	addss	%xmm0, %xmm0
	addss	%xmm0, %xmm0
	addss	%xmm0, %xmm0
	addss	%xmm0, %xmm0
	movss	12(%rsp), %xmm1
	addss	%xmm1, %xmm0
	addss	%xmm0, %xmm0
	addss	%xmm0, %xmm0
	addss	%xmm0, %xmm0
	addss	%xmm0, %xmm0
	addss	%xmm0, %xmm0
	addss	%xmm0, %xmm0
	addss	%xmm0, %xmm0
	addss	%xmm0, %xmm0
	addss	%xmm0, %xmm0
	addss	%xmm0, %xmm0
	addss	%xmm1, %xmm0
	subq	$1, %rax
	cmpq	$-1, %rax
	jne	.L99
.L98:
	cvttss2sil	%xmm0, %edi
	call	use_int@PLT
	cvttss2sil	12(%rsp), %edi
	call	use_int@PLT
	addq	$24, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE85:
	.size	do_float_add, .-do_float_add
	.globl	do_float_mul
	.type	do_float_mul, @function
do_float_mul:
.LFB86:
	.cfi_startproc
	endbr64
	subq	$24, %rsp
	.cfi_def_cfa_offset 32
	pxor	%xmm0, %xmm0
	cvtsi2ssl	(%rsi), %xmm0
	mulss	.LC7(%rip), %xmm0
	pxor	%xmm1, %xmm1
	cvtsi2ssl	4(%rsi), %xmm1
	mulss	.LC8(%rip), %xmm1
	divss	.LC9(%rip), %xmm1
	movss	%xmm1, 12(%rsp)
	leaq	-1(%rdi), %rax
	testq	%rdi, %rdi
	je	.L103
.L104:
	mulss	%xmm0, %xmm0
	movss	12(%rsp), %xmm2
	mulss	%xmm2, %xmm0
	mulss	%xmm0, %xmm0
	mulss	%xmm2, %xmm0
	mulss	%xmm0, %xmm0
	mulss	%xmm2, %xmm0
	mulss	%xmm0, %xmm0
	mulss	%xmm2, %xmm0
	mulss	%xmm0, %xmm0
	mulss	%xmm2, %xmm0
	mulss	%xmm0, %xmm0
	mulss	%xmm2, %xmm0
	mulss	%xmm0, %xmm0
	mulss	%xmm2, %xmm0
	mulss	%xmm0, %xmm0
	mulss	%xmm2, %xmm0
	mulss	%xmm0, %xmm0
	mulss	%xmm2, %xmm0
	mulss	%xmm0, %xmm0
	mulss	%xmm2, %xmm0
	mulss	%xmm0, %xmm0
	mulss	%xmm2, %xmm0
	mulss	%xmm0, %xmm0
	mulss	%xmm2, %xmm0
	mulss	%xmm0, %xmm0
	mulss	%xmm2, %xmm0
	mulss	%xmm0, %xmm0
	mulss	%xmm2, %xmm0
	mulss	%xmm0, %xmm0
	mulss	%xmm2, %xmm0
	mulss	%xmm0, %xmm0
	mulss	%xmm2, %xmm0
	mulss	%xmm0, %xmm0
	mulss	%xmm2, %xmm0
	mulss	%xmm0, %xmm0
	mulss	%xmm2, %xmm0
	mulss	%xmm0, %xmm0
	mulss	%xmm2, %xmm0
	mulss	%xmm0, %xmm0
	mulss	%xmm2, %xmm0
	subq	$1, %rax
	cmpq	$-1, %rax
	jne	.L104
.L103:
	cvttss2sil	%xmm0, %edi
	call	use_int@PLT
	cvttss2sil	12(%rsp), %edi
	call	use_int@PLT
	addq	$24, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE86:
	.size	do_float_mul, .-do_float_mul
	.globl	do_float_div
	.type	do_float_div, @function
do_float_div:
.LFB87:
	.cfi_startproc
	endbr64
	subq	$24, %rsp
	.cfi_def_cfa_offset 32
	pxor	%xmm0, %xmm0
	cvtsi2ssl	(%rsi), %xmm0
	mulss	.LC10(%rip), %xmm0
	pxor	%xmm1, %xmm1
	cvtsi2ssl	4(%rsi), %xmm1
	mulss	.LC5(%rip), %xmm1
	divss	.LC9(%rip), %xmm1
	movss	%xmm1, 12(%rsp)
	leaq	-1(%rdi), %rax
	testq	%rdi, %rdi
	je	.L108
.L109:
	movss	12(%rsp), %xmm4
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
	movaps	%xmm4, %xmm1
	divss	%xmm0, %xmm1
	movaps	%xmm4, %xmm0
	divss	%xmm1, %xmm0
	movaps	%xmm0, %xmm2
	divss	%xmm4, %xmm2
	movaps	%xmm0, %xmm1
	divss	%xmm2, %xmm1
	movaps	%xmm0, %xmm2
	divss	%xmm1, %xmm2
	movaps	%xmm0, %xmm1
	divss	%xmm2, %xmm1
	movaps	%xmm0, %xmm2
	divss	%xmm1, %xmm2
	movaps	%xmm0, %xmm1
	divss	%xmm2, %xmm1
	movaps	%xmm0, %xmm2
	divss	%xmm1, %xmm2
	movaps	%xmm0, %xmm1
	divss	%xmm2, %xmm1
	movaps	%xmm0, %xmm2
	divss	%xmm1, %xmm2
	movaps	%xmm0, %xmm1
	divss	%xmm2, %xmm1
	movaps	%xmm1, %xmm2
	divss	%xmm0, %xmm2
	movaps	%xmm1, %xmm0
	divss	%xmm2, %xmm0
	movaps	%xmm1, %xmm2
	divss	%xmm0, %xmm2
	movaps	%xmm1, %xmm0
	divss	%xmm2, %xmm0
	movaps	%xmm1, %xmm2
	divss	%xmm0, %xmm2
	movaps	%xmm1, %xmm0
	divss	%xmm2, %xmm0
	movaps	%xmm1, %xmm2
	divss	%xmm0, %xmm2
	movaps	%xmm1, %xmm0
	divss	%xmm2, %xmm0
	movaps	%xmm1, %xmm2
	divss	%xmm0, %xmm2
	movaps	%xmm1, %xmm0
	divss	%xmm2, %xmm0
	movaps	%xmm0, %xmm2
	divss	%xmm1, %xmm2
	movaps	%xmm0, %xmm1
	divss	%xmm2, %xmm1
	movaps	%xmm0, %xmm2
	divss	%xmm1, %xmm2
	movaps	%xmm0, %xmm1
	divss	%xmm2, %xmm1
	movaps	%xmm0, %xmm2
	divss	%xmm1, %xmm2
	movaps	%xmm0, %xmm1
	divss	%xmm2, %xmm1
	movaps	%xmm0, %xmm2
	divss	%xmm1, %xmm2
	movaps	%xmm0, %xmm1
	divss	%xmm2, %xmm1
	movaps	%xmm0, %xmm2
	divss	%xmm1, %xmm2
	movaps	%xmm0, %xmm1
	divss	%xmm2, %xmm1
	movaps	%xmm1, %xmm2
	divss	%xmm0, %xmm2
	movaps	%xmm1, %xmm0
	divss	%xmm2, %xmm0
	movaps	%xmm1, %xmm2
	divss	%xmm0, %xmm2
	movaps	%xmm1, %xmm0
	divss	%xmm2, %xmm0
	movaps	%xmm1, %xmm2
	divss	%xmm0, %xmm2
	movaps	%xmm1, %xmm0
	divss	%xmm2, %xmm0
	movaps	%xmm1, %xmm2
	divss	%xmm0, %xmm2
	movaps	%xmm1, %xmm0
	divss	%xmm2, %xmm0
	movaps	%xmm1, %xmm2
	divss	%xmm0, %xmm2
	movaps	%xmm1, %xmm0
	divss	%xmm2, %xmm0
	movaps	%xmm0, %xmm2
	divss	%xmm1, %xmm2
	movaps	%xmm0, %xmm1
	divss	%xmm2, %xmm1
	movaps	%xmm0, %xmm2
	divss	%xmm1, %xmm2
	movaps	%xmm0, %xmm1
	divss	%xmm2, %xmm1
	movaps	%xmm0, %xmm2
	divss	%xmm1, %xmm2
	movaps	%xmm0, %xmm1
	divss	%xmm2, %xmm1
	movaps	%xmm0, %xmm2
	divss	%xmm1, %xmm2
	movaps	%xmm0, %xmm1
	divss	%xmm2, %xmm1
	movaps	%xmm0, %xmm2
	divss	%xmm1, %xmm2
	movaps	%xmm0, %xmm1
	divss	%xmm2, %xmm1
	movaps	%xmm1, %xmm2
	divss	%xmm0, %xmm2
	movaps	%xmm1, %xmm0
	divss	%xmm2, %xmm0
	movaps	%xmm1, %xmm2
	divss	%xmm0, %xmm2
	movaps	%xmm1, %xmm0
	divss	%xmm2, %xmm0
	movaps	%xmm1, %xmm2
	divss	%xmm0, %xmm2
	movaps	%xmm1, %xmm0
	divss	%xmm2, %xmm0
	movaps	%xmm1, %xmm2
	divss	%xmm0, %xmm2
	movaps	%xmm1, %xmm0
	divss	%xmm2, %xmm0
	movaps	%xmm1, %xmm2
	divss	%xmm0, %xmm2
	movaps	%xmm1, %xmm0
	divss	%xmm2, %xmm0
	movaps	%xmm0, %xmm2
	divss	%xmm1, %xmm2
	movaps	%xmm0, %xmm1
	divss	%xmm2, %xmm1
	movaps	%xmm0, %xmm2
	divss	%xmm1, %xmm2
	movaps	%xmm0, %xmm1
	divss	%xmm2, %xmm1
	movaps	%xmm0, %xmm2
	divss	%xmm1, %xmm2
	movaps	%xmm0, %xmm1
	divss	%xmm2, %xmm1
	movaps	%xmm0, %xmm2
	divss	%xmm1, %xmm2
	movaps	%xmm0, %xmm1
	divss	%xmm2, %xmm1
	movaps	%xmm0, %xmm2
	divss	%xmm1, %xmm2
	movaps	%xmm0, %xmm1
	divss	%xmm2, %xmm1
	movaps	%xmm1, %xmm2
	divss	%xmm0, %xmm2
	movaps	%xmm1, %xmm0
	divss	%xmm2, %xmm0
	movaps	%xmm1, %xmm2
	divss	%xmm0, %xmm2
	movaps	%xmm1, %xmm0
	divss	%xmm2, %xmm0
	movaps	%xmm1, %xmm2
	divss	%xmm0, %xmm2
	movaps	%xmm1, %xmm0
	divss	%xmm2, %xmm0
	movaps	%xmm1, %xmm2
	divss	%xmm0, %xmm2
	movaps	%xmm1, %xmm0
	divss	%xmm2, %xmm0
	movaps	%xmm1, %xmm2
	divss	%xmm0, %xmm2
	movaps	%xmm1, %xmm0
	divss	%xmm2, %xmm0
	movaps	%xmm0, %xmm3
	divss	%xmm1, %xmm3
	movaps	%xmm0, %xmm2
	divss	%xmm3, %xmm2
	movaps	%xmm0, %xmm1
	divss	%xmm2, %xmm1
	movaps	%xmm0, %xmm2
	divss	%xmm1, %xmm2
	movaps	%xmm0, %xmm1
	divss	%xmm2, %xmm1
	movaps	%xmm0, %xmm2
	divss	%xmm1, %xmm2
	movaps	%xmm0, %xmm1
	divss	%xmm2, %xmm1
	movaps	%xmm0, %xmm2
	divss	%xmm1, %xmm2
	movaps	%xmm0, %xmm1
	divss	%xmm2, %xmm1
	movaps	%xmm0, %xmm5
	divss	%xmm1, %xmm5
	movss	%xmm5, 12(%rsp)
	subq	$1, %rax
	cmpq	$-1, %rax
	jne	.L109
.L108:
	cvttss2sil	%xmm0, %edi
	call	use_int@PLT
	cvttss2sil	12(%rsp), %edi
	call	use_int@PLT
	addq	$24, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE87:
	.size	do_float_div, .-do_float_div
	.globl	do_double_add
	.type	do_double_add, @function
do_double_add:
.LFB88:
	.cfi_startproc
	endbr64
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	pxor	%xmm0, %xmm0
	cvtsi2sdl	(%rsi), %xmm0
	movl	8(%rsi), %ebx
	pxor	%xmm1, %xmm1
	cvtsi2sdl	%ebx, %xmm1
	leaq	-1(%rdi), %rax
	testq	%rdi, %rdi
	je	.L113
.L114:
	addsd	%xmm0, %xmm0
	addsd	%xmm0, %xmm0
	addsd	%xmm0, %xmm0
	addsd	%xmm0, %xmm0
	addsd	%xmm0, %xmm0
	addsd	%xmm0, %xmm0
	addsd	%xmm0, %xmm0
	addsd	%xmm0, %xmm0
	addsd	%xmm0, %xmm0
	addsd	%xmm0, %xmm0
	addsd	%xmm1, %xmm0
	addsd	%xmm0, %xmm0
	addsd	%xmm0, %xmm0
	addsd	%xmm0, %xmm0
	addsd	%xmm0, %xmm0
	addsd	%xmm0, %xmm0
	addsd	%xmm0, %xmm0
	addsd	%xmm0, %xmm0
	addsd	%xmm0, %xmm0
	addsd	%xmm0, %xmm0
	addsd	%xmm0, %xmm0
	addsd	%xmm1, %xmm0
	subq	$1, %rax
	cmpq	$-1, %rax
	jne	.L114
.L113:
	cvttsd2sil	%xmm0, %edi
	call	use_int@PLT
	movl	%ebx, %edi
	call	use_int@PLT
	popq	%rbx
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE88:
	.size	do_double_add, .-do_double_add
	.globl	do_double_mul
	.type	do_double_mul, @function
do_double_mul:
.LFB89:
	.cfi_startproc
	endbr64
	subq	$24, %rsp
	.cfi_def_cfa_offset 32
	pxor	%xmm0, %xmm0
	cvtsi2sdl	(%rsi), %xmm0
	mulsd	.LC11(%rip), %xmm0
	pxor	%xmm1, %xmm1
	cvtsi2sdl	4(%rsi), %xmm1
	mulsd	.LC12(%rip), %xmm1
	divsd	.LC13(%rip), %xmm1
	movsd	%xmm1, 8(%rsp)
	leaq	-1(%rdi), %rax
	testq	%rdi, %rdi
	je	.L118
.L119:
	mulsd	%xmm0, %xmm0
	movsd	8(%rsp), %xmm2
	mulsd	%xmm2, %xmm0
	mulsd	%xmm0, %xmm0
	mulsd	%xmm2, %xmm0
	mulsd	%xmm0, %xmm0
	mulsd	%xmm2, %xmm0
	mulsd	%xmm0, %xmm0
	mulsd	%xmm2, %xmm0
	mulsd	%xmm0, %xmm0
	mulsd	%xmm2, %xmm0
	mulsd	%xmm0, %xmm0
	mulsd	%xmm2, %xmm0
	mulsd	%xmm0, %xmm0
	mulsd	%xmm2, %xmm0
	mulsd	%xmm0, %xmm0
	mulsd	%xmm2, %xmm0
	mulsd	%xmm0, %xmm0
	mulsd	%xmm2, %xmm0
	mulsd	%xmm0, %xmm0
	mulsd	%xmm2, %xmm0
	mulsd	%xmm0, %xmm0
	mulsd	%xmm2, %xmm0
	mulsd	%xmm0, %xmm0
	mulsd	%xmm2, %xmm0
	mulsd	%xmm0, %xmm0
	mulsd	%xmm2, %xmm0
	mulsd	%xmm0, %xmm0
	mulsd	%xmm2, %xmm0
	mulsd	%xmm0, %xmm0
	mulsd	%xmm2, %xmm0
	mulsd	%xmm0, %xmm0
	mulsd	%xmm2, %xmm0
	mulsd	%xmm0, %xmm0
	mulsd	%xmm2, %xmm0
	mulsd	%xmm0, %xmm0
	mulsd	%xmm2, %xmm0
	mulsd	%xmm0, %xmm0
	mulsd	%xmm2, %xmm0
	mulsd	%xmm0, %xmm0
	mulsd	%xmm2, %xmm0
	subq	$1, %rax
	cmpq	$-1, %rax
	jne	.L119
.L118:
	cvttsd2sil	%xmm0, %edi
	call	use_int@PLT
	cvttsd2sil	8(%rsp), %edi
	call	use_int@PLT
	addq	$24, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE89:
	.size	do_double_mul, .-do_double_mul
	.globl	do_double_div
	.type	do_double_div, @function
do_double_div:
.LFB90:
	.cfi_startproc
	endbr64
	subq	$24, %rsp
	.cfi_def_cfa_offset 32
	pxor	%xmm0, %xmm0
	cvtsi2sdl	(%rsi), %xmm0
	mulsd	.LC14(%rip), %xmm0
	pxor	%xmm1, %xmm1
	cvtsi2sdl	4(%rsi), %xmm1
	mulsd	.LC6(%rip), %xmm1
	divsd	.LC13(%rip), %xmm1
	movsd	%xmm1, 8(%rsp)
	leaq	-1(%rdi), %rax
	testq	%rdi, %rdi
	je	.L123
.L124:
	movsd	8(%rsp), %xmm4
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
	movapd	%xmm4, %xmm1
	divsd	%xmm0, %xmm1
	movapd	%xmm4, %xmm0
	divsd	%xmm1, %xmm0
	movapd	%xmm0, %xmm2
	divsd	%xmm4, %xmm2
	movapd	%xmm0, %xmm1
	divsd	%xmm2, %xmm1
	movapd	%xmm0, %xmm2
	divsd	%xmm1, %xmm2
	movapd	%xmm0, %xmm1
	divsd	%xmm2, %xmm1
	movapd	%xmm0, %xmm2
	divsd	%xmm1, %xmm2
	movapd	%xmm0, %xmm1
	divsd	%xmm2, %xmm1
	movapd	%xmm0, %xmm2
	divsd	%xmm1, %xmm2
	movapd	%xmm0, %xmm1
	divsd	%xmm2, %xmm1
	movapd	%xmm0, %xmm2
	divsd	%xmm1, %xmm2
	movapd	%xmm0, %xmm1
	divsd	%xmm2, %xmm1
	movapd	%xmm1, %xmm2
	divsd	%xmm0, %xmm2
	movapd	%xmm1, %xmm0
	divsd	%xmm2, %xmm0
	movapd	%xmm1, %xmm2
	divsd	%xmm0, %xmm2
	movapd	%xmm1, %xmm0
	divsd	%xmm2, %xmm0
	movapd	%xmm1, %xmm2
	divsd	%xmm0, %xmm2
	movapd	%xmm1, %xmm0
	divsd	%xmm2, %xmm0
	movapd	%xmm1, %xmm2
	divsd	%xmm0, %xmm2
	movapd	%xmm1, %xmm0
	divsd	%xmm2, %xmm0
	movapd	%xmm1, %xmm2
	divsd	%xmm0, %xmm2
	movapd	%xmm1, %xmm0
	divsd	%xmm2, %xmm0
	movapd	%xmm0, %xmm2
	divsd	%xmm1, %xmm2
	movapd	%xmm0, %xmm1
	divsd	%xmm2, %xmm1
	movapd	%xmm0, %xmm2
	divsd	%xmm1, %xmm2
	movapd	%xmm0, %xmm1
	divsd	%xmm2, %xmm1
	movapd	%xmm0, %xmm2
	divsd	%xmm1, %xmm2
	movapd	%xmm0, %xmm1
	divsd	%xmm2, %xmm1
	movapd	%xmm0, %xmm2
	divsd	%xmm1, %xmm2
	movapd	%xmm0, %xmm1
	divsd	%xmm2, %xmm1
	movapd	%xmm0, %xmm2
	divsd	%xmm1, %xmm2
	movapd	%xmm0, %xmm1
	divsd	%xmm2, %xmm1
	movapd	%xmm1, %xmm2
	divsd	%xmm0, %xmm2
	movapd	%xmm1, %xmm0
	divsd	%xmm2, %xmm0
	movapd	%xmm1, %xmm2
	divsd	%xmm0, %xmm2
	movapd	%xmm1, %xmm0
	divsd	%xmm2, %xmm0
	movapd	%xmm1, %xmm2
	divsd	%xmm0, %xmm2
	movapd	%xmm1, %xmm0
	divsd	%xmm2, %xmm0
	movapd	%xmm1, %xmm2
	divsd	%xmm0, %xmm2
	movapd	%xmm1, %xmm0
	divsd	%xmm2, %xmm0
	movapd	%xmm1, %xmm2
	divsd	%xmm0, %xmm2
	movapd	%xmm1, %xmm0
	divsd	%xmm2, %xmm0
	movapd	%xmm0, %xmm2
	divsd	%xmm1, %xmm2
	movapd	%xmm0, %xmm1
	divsd	%xmm2, %xmm1
	movapd	%xmm0, %xmm2
	divsd	%xmm1, %xmm2
	movapd	%xmm0, %xmm1
	divsd	%xmm2, %xmm1
	movapd	%xmm0, %xmm2
	divsd	%xmm1, %xmm2
	movapd	%xmm0, %xmm1
	divsd	%xmm2, %xmm1
	movapd	%xmm0, %xmm2
	divsd	%xmm1, %xmm2
	movapd	%xmm0, %xmm1
	divsd	%xmm2, %xmm1
	movapd	%xmm0, %xmm2
	divsd	%xmm1, %xmm2
	movapd	%xmm0, %xmm1
	divsd	%xmm2, %xmm1
	movapd	%xmm1, %xmm2
	divsd	%xmm0, %xmm2
	movapd	%xmm1, %xmm0
	divsd	%xmm2, %xmm0
	movapd	%xmm1, %xmm2
	divsd	%xmm0, %xmm2
	movapd	%xmm1, %xmm0
	divsd	%xmm2, %xmm0
	movapd	%xmm1, %xmm2
	divsd	%xmm0, %xmm2
	movapd	%xmm1, %xmm0
	divsd	%xmm2, %xmm0
	movapd	%xmm1, %xmm2
	divsd	%xmm0, %xmm2
	movapd	%xmm1, %xmm0
	divsd	%xmm2, %xmm0
	movapd	%xmm1, %xmm2
	divsd	%xmm0, %xmm2
	movapd	%xmm1, %xmm0
	divsd	%xmm2, %xmm0
	movapd	%xmm0, %xmm2
	divsd	%xmm1, %xmm2
	movapd	%xmm0, %xmm1
	divsd	%xmm2, %xmm1
	movapd	%xmm0, %xmm2
	divsd	%xmm1, %xmm2
	movapd	%xmm0, %xmm1
	divsd	%xmm2, %xmm1
	movapd	%xmm0, %xmm2
	divsd	%xmm1, %xmm2
	movapd	%xmm0, %xmm1
	divsd	%xmm2, %xmm1
	movapd	%xmm0, %xmm2
	divsd	%xmm1, %xmm2
	movapd	%xmm0, %xmm1
	divsd	%xmm2, %xmm1
	movapd	%xmm0, %xmm2
	divsd	%xmm1, %xmm2
	movapd	%xmm0, %xmm1
	divsd	%xmm2, %xmm1
	movapd	%xmm1, %xmm2
	divsd	%xmm0, %xmm2
	movapd	%xmm1, %xmm0
	divsd	%xmm2, %xmm0
	movapd	%xmm1, %xmm2
	divsd	%xmm0, %xmm2
	movapd	%xmm1, %xmm0
	divsd	%xmm2, %xmm0
	movapd	%xmm1, %xmm2
	divsd	%xmm0, %xmm2
	movapd	%xmm1, %xmm0
	divsd	%xmm2, %xmm0
	movapd	%xmm1, %xmm2
	divsd	%xmm0, %xmm2
	movapd	%xmm1, %xmm0
	divsd	%xmm2, %xmm0
	movapd	%xmm1, %xmm2
	divsd	%xmm0, %xmm2
	movapd	%xmm1, %xmm0
	divsd	%xmm2, %xmm0
	movapd	%xmm0, %xmm3
	divsd	%xmm1, %xmm3
	movapd	%xmm0, %xmm2
	divsd	%xmm3, %xmm2
	movapd	%xmm0, %xmm1
	divsd	%xmm2, %xmm1
	movapd	%xmm0, %xmm2
	divsd	%xmm1, %xmm2
	movapd	%xmm0, %xmm1
	divsd	%xmm2, %xmm1
	movapd	%xmm0, %xmm2
	divsd	%xmm1, %xmm2
	movapd	%xmm0, %xmm1
	divsd	%xmm2, %xmm1
	movapd	%xmm0, %xmm2
	divsd	%xmm1, %xmm2
	movapd	%xmm0, %xmm1
	divsd	%xmm2, %xmm1
	movapd	%xmm0, %xmm5
	divsd	%xmm1, %xmm5
	movsd	%xmm5, 8(%rsp)
	subq	$1, %rax
	cmpq	$-1, %rax
	jne	.L124
.L123:
	cvttsd2sil	%xmm0, %edi
	call	use_int@PLT
	cvttsd2sil	8(%rsp), %edi
	call	use_int@PLT
	addq	$24, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE90:
	.size	do_double_div, .-do_double_div
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC15:
	.string	"[-W <warmup>] [-N <repetitions>] [-P <parallel>] \n"
	.section	.rodata.str1.1
.LC16:
	.string	"W:N:P:"
.LC17:
	.string	"integer bit"
.LC18:
	.string	"integer add"
.LC19:
	.string	"integer mul"
.LC20:
	.string	"integer div"
.LC21:
	.string	"integer mod"
.LC22:
	.string	"int64 bit"
.LC23:
	.string	"uint64 add"
.LC24:
	.string	"int64 mul"
.LC25:
	.string	"int64 div"
.LC26:
	.string	"int64 mod"
.LC27:
	.string	"float add"
.LC28:
	.string	"float mul"
.LC29:
	.string	"float div"
.LC30:
	.string	"double add"
.LC31:
	.string	"double mul"
.LC32:
	.string	"double div"
.LC33:
	.string	"float bogomflops"
.LC34:
	.string	"double bogomflops"
	.text
	.globl	main
	.type	main, @function
main:
.LFB93:
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
	movl	%edi, %r13d
	movq	%rsi, %r12
	movq	%fs:40, %rax
	movq	%rax, 40(%rsp)
	xorl	%eax, %eax
	movl	$1, 16(%rsp)
	movl	$1000, 20(%rsp)
	movl	$-1023, 24(%rsp)
	movq	$0, 32(%rsp)
	movl	$-1, %ebp
	movl	$1, 12(%rsp)
	movl	$0, %ebx
	leaq	.LC16(%rip), %r14
	leaq	.LC15(%rip), %r15
	jmp	.L128
.L130:
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	movl	%eax, %ebx
.L128:
	movq	%r14, %rdx
	movq	%r12, %rsi
	movl	%r13d, %edi
	call	mygetopt@PLT
	cmpl	$-1, %eax
	je	.L138
	cmpl	$80, %eax
	je	.L129
	cmpl	$87, %eax
	je	.L130
	cmpl	$78, %eax
	je	.L139
	movq	%r15, %rdx
	movq	%r12, %rsi
	movl	%r13d, %edi
	call	lmbench_usage@PLT
	jmp	.L128
.L139:
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	movl	%eax, %ebp
	jmp	.L128
.L129:
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	movl	%eax, 12(%rsp)
	testl	%eax, %eax
	jg	.L128
	movq	%r15, %rdx
	movq	%r12, %rsi
	movl	%r13d, %edi
	call	lmbench_usage@PLT
	jmp	.L128
.L138:
	leaq	16(%rsp), %r12
	pushq	%r12
	.cfi_def_cfa_offset 120
	pushq	%rbp
	.cfi_def_cfa_offset 128
	movl	%ebx, %r9d
	movl	$1, %r8d
	movl	$0, %ecx
	movl	$0, %edx
	leaq	do_integer_bitwise(%rip), %rsi
	movl	$0, %edi
	call	benchmp@PLT
	call	get_n@PLT
	imulq	$300, %rax, %rsi
	leaq	.LC17(%rip), %rdi
	call	nano@PLT
	call	usecs_spent@PLT
	movq	%rax, %r14
	call	get_n@PLT
	imulq	$300, %rax, %r13
	pushq	%r12
	.cfi_def_cfa_offset 136
	pushq	%rbp
	.cfi_def_cfa_offset 144
	movl	%ebx, %r9d
	movl	$1, %r8d
	movl	$0, %ecx
	movl	$0, %edx
	leaq	do_integer_add(%rip), %rsi
	movl	$0, %edi
	call	benchmp@PLT
	addq	$32, %rsp
	.cfi_def_cfa_offset 112
	call	get_n@PLT
	imulq	$20000, %rax, %rsi
	leaq	.LC18(%rip), %rdi
	call	nano@PLT
	pushq	%r12
	.cfi_def_cfa_offset 120
	pushq	%rbp
	.cfi_def_cfa_offset 128
	movl	%ebx, %r9d
	movl	$1, %r8d
	movl	$0, %ecx
	movl	$0, %edx
	leaq	do_integer_mul(%rip), %rsi
	movl	$0, %edi
	call	benchmp@PLT
	call	usecs_spent@PLT
	movq	%rax, %r15
	call	get_n@PLT
	imulq	%r14, %rax
	addq	%rax, %rax
	movl	$0, %edx
	divq	%r13
	movq	%r15, %rdi
	subq	%rax, %rdi
	call	settime@PLT
	call	get_n@PLT
	leaq	(%rax,%rax,4), %rsi
	salq	$2, %rsi
	leaq	.LC19(%rip), %rdi
	call	nano@PLT
	pushq	%r12
	.cfi_def_cfa_offset 136
	pushq	%rbp
	.cfi_def_cfa_offset 144
	movl	%ebx, %r9d
	movl	$1, %r8d
	movl	$0, %ecx
	movl	$0, %edx
	leaq	do_integer_div(%rip), %rsi
	movl	$0, %edi
	call	benchmp@PLT
	addq	$32, %rsp
	.cfi_def_cfa_offset 112
	call	get_n@PLT
	leaq	(%rax,%rax,4), %rax
	leaq	(%rax,%rax,4), %rsi
	salq	$2, %rsi
	leaq	.LC20(%rip), %rdi
	call	nano@PLT
	pushq	%r12
	.cfi_def_cfa_offset 120
	pushq	%rbp
	.cfi_def_cfa_offset 128
	movl	%ebx, %r9d
	movl	$1, %r8d
	movl	$0, %ecx
	movl	$0, %edx
	leaq	do_integer_mod(%rip), %rsi
	movl	$0, %edi
	call	benchmp@PLT
	call	usecs_spent@PLT
	movq	%rax, %r15
	call	get_n@PLT
	imulq	%r14, %rax
	leaq	(%rax,%rax,4), %rax
	leaq	(%rax,%rax,4), %rax
	salq	$2, %rax
	movl	$0, %edx
	divq	%r13
	movq	%r15, %rdi
	subq	%rax, %rdi
	call	settime@PLT
	call	get_n@PLT
	leaq	(%rax,%rax,4), %rax
	leaq	(%rax,%rax,4), %rsi
	salq	$2, %rsi
	leaq	.LC21(%rip), %rdi
	call	nano@PLT
	pushq	%r12
	.cfi_def_cfa_offset 136
	pushq	%rbp
	.cfi_def_cfa_offset 144
	movl	%ebx, %r9d
	movl	$1, %r8d
	movl	$0, %ecx
	movl	$0, %edx
	leaq	do_int64_bitwise(%rip), %rsi
	movl	$0, %edi
	call	benchmp@PLT
	addq	$32, %rsp
	.cfi_def_cfa_offset 112
	call	get_n@PLT
	imulq	$300, %rax, %rsi
	leaq	.LC22(%rip), %rdi
	call	nano@PLT
	call	usecs_spent@PLT
	movq	%rax, %r14
	call	get_n@PLT
	imulq	$300, %rax, %r13
	pushq	%r12
	.cfi_def_cfa_offset 120
	pushq	%rbp
	.cfi_def_cfa_offset 128
	movl	%ebx, %r9d
	movl	$1, %r8d
	movl	$0, %ecx
	movl	$0, %edx
	leaq	do_int64_add(%rip), %rsi
	movl	$0, %edi
	call	benchmp@PLT
	call	get_n@PLT
	imulq	$20000, %rax, %rsi
	leaq	.LC23(%rip), %rdi
	call	nano@PLT
	pushq	%r12
	.cfi_def_cfa_offset 136
	pushq	%rbp
	.cfi_def_cfa_offset 144
	movl	%ebx, %r9d
	movl	$1, %r8d
	movl	$0, %ecx
	movl	$0, %edx
	leaq	do_int64_mul(%rip), %rsi
	movl	$0, %edi
	call	benchmp@PLT
	addq	$32, %rsp
	.cfi_def_cfa_offset 112
	call	usecs_spent@PLT
	movq	%rax, %r15
	call	get_n@PLT
	imulq	%r14, %rax
	addq	%rax, %rax
	movl	$0, %edx
	divq	%r13
	movq	%r15, %rdi
	subq	%rax, %rdi
	call	settime@PLT
	call	get_n@PLT
	leaq	(%rax,%rax,4), %rsi
	salq	$2, %rsi
	leaq	.LC24(%rip), %rdi
	call	nano@PLT
	pushq	%r12
	.cfi_def_cfa_offset 120
	pushq	%rbp
	.cfi_def_cfa_offset 128
	movl	%ebx, %r9d
	movl	$1, %r8d
	movl	$0, %ecx
	movl	$0, %edx
	leaq	do_int64_div(%rip), %rsi
	movl	$0, %edi
	call	benchmp@PLT
	call	get_n@PLT
	leaq	(%rax,%rax,4), %rax
	leaq	(%rax,%rax,4), %rsi
	salq	$2, %rsi
	leaq	.LC25(%rip), %rdi
	call	nano@PLT
	pushq	%r12
	.cfi_def_cfa_offset 136
	pushq	%rbp
	.cfi_def_cfa_offset 144
	movl	%ebx, %r9d
	movl	$1, %r8d
	movl	$0, %ecx
	movl	$0, %edx
	leaq	do_int64_mod(%rip), %rsi
	movl	$0, %edi
	call	benchmp@PLT
	addq	$32, %rsp
	.cfi_def_cfa_offset 112
	call	usecs_spent@PLT
	movq	%rax, %r15
	call	get_n@PLT
	imulq	%r14, %rax
	leaq	(%rax,%rax,4), %rax
	leaq	(%rax,%rax,4), %rax
	salq	$2, %rax
	movl	$0, %edx
	divq	%r13
	movq	%r15, %rdi
	subq	%rax, %rdi
	call	settime@PLT
	call	get_n@PLT
	leaq	(%rax,%rax,4), %rax
	leaq	(%rax,%rax,4), %rsi
	salq	$2, %rsi
	leaq	.LC26(%rip), %rdi
	call	nano@PLT
	pushq	%r12
	.cfi_def_cfa_offset 120
	pushq	%rbp
	.cfi_def_cfa_offset 128
	movl	%ebx, %r9d
	movl	$1, %r8d
	movl	$0, %ecx
	movl	$0, %edx
	leaq	do_float_add(%rip), %rsi
	movl	$0, %edi
	call	benchmp@PLT
	call	get_n@PLT
	leaq	(%rax,%rax,4), %rdx
	leaq	(%rax,%rdx,2), %rsi
	addq	%rsi, %rsi
	leaq	.LC27(%rip), %rdi
	call	nano@PLT
	pushq	%r12
	.cfi_def_cfa_offset 136
	pushq	%rbp
	.cfi_def_cfa_offset 144
	movl	%ebx, %r9d
	movl	$1, %r8d
	movl	$0, %ecx
	movl	$0, %edx
	leaq	do_float_mul(%rip), %rsi
	movl	$0, %edi
	call	benchmp@PLT
	addq	$32, %rsp
	.cfi_def_cfa_offset 112
	call	get_n@PLT
	leaq	(%rax,%rax,4), %rsi
	salq	$3, %rsi
	leaq	.LC28(%rip), %rdi
	call	nano@PLT
	pushq	%r12
	.cfi_def_cfa_offset 120
	pushq	%rbp
	.cfi_def_cfa_offset 128
	movl	%ebx, %r9d
	movl	$1, %r8d
	movl	$0, %ecx
	movl	$0, %edx
	leaq	do_float_div(%rip), %rsi
	movl	$0, %edi
	call	benchmp@PLT
	call	get_n@PLT
	leaq	(%rax,%rax,4), %rax
	leaq	(%rax,%rax,4), %rsi
	salq	$2, %rsi
	leaq	.LC29(%rip), %rdi
	call	nano@PLT
	pushq	%r12
	.cfi_def_cfa_offset 136
	pushq	%rbp
	.cfi_def_cfa_offset 144
	movl	%ebx, %r9d
	movl	$1, %r8d
	movl	$0, %ecx
	movl	$0, %edx
	leaq	do_double_add(%rip), %rsi
	movl	$0, %edi
	call	benchmp@PLT
	addq	$32, %rsp
	.cfi_def_cfa_offset 112
	call	get_n@PLT
	leaq	(%rax,%rax,4), %rdx
	leaq	(%rax,%rdx,2), %rsi
	addq	%rsi, %rsi
	leaq	.LC30(%rip), %rdi
	call	nano@PLT
	pushq	%r12
	.cfi_def_cfa_offset 120
	pushq	%rbp
	.cfi_def_cfa_offset 128
	movl	%ebx, %r9d
	movl	$1, %r8d
	movl	$0, %ecx
	movl	$0, %edx
	leaq	do_double_mul(%rip), %rsi
	movl	$0, %edi
	call	benchmp@PLT
	call	get_n@PLT
	leaq	(%rax,%rax,4), %rsi
	salq	$3, %rsi
	leaq	.LC31(%rip), %rdi
	call	nano@PLT
	pushq	%r12
	.cfi_def_cfa_offset 136
	pushq	%rbp
	.cfi_def_cfa_offset 144
	movl	%ebx, %r9d
	movl	$1, %r8d
	movl	$0, %ecx
	movl	$0, %edx
	leaq	do_double_div(%rip), %rsi
	movl	$0, %edi
	call	benchmp@PLT
	addq	$32, %rsp
	.cfi_def_cfa_offset 112
	call	get_n@PLT
	leaq	(%rax,%rax,4), %rax
	leaq	(%rax,%rax,4), %rsi
	salq	$2, %rsi
	leaq	.LC32(%rip), %rdi
	call	nano@PLT
	pushq	%r12
	.cfi_def_cfa_offset 120
	pushq	%rbp
	.cfi_def_cfa_offset 128
	movl	%ebx, %r9d
	movl	28(%rsp), %r15d
	movl	%r15d, %r8d
	movl	$0, %ecx
	leaq	cleanup(%rip), %r13
	movq	%r13, %rdx
	leaq	do_float_bogomflops(%rip), %rsi
	leaq	float_initialize(%rip), %rdi
	call	benchmp@PLT
	call	get_n@PLT
	movslq	36(%rsp), %rsi
	imulq	%rax, %rsi
	leaq	.LC33(%rip), %rdi
	call	nano@PLT
	movq	stdout(%rip), %rdi
	call	fflush@PLT
	movq	stderr(%rip), %rdi
	call	fflush@PLT
	pushq	%r12
	.cfi_def_cfa_offset 136
	pushq	%rbp
	.cfi_def_cfa_offset 144
	movl	%ebx, %r9d
	movl	%r15d, %r8d
	movl	$0, %ecx
	movq	%r13, %rdx
	leaq	do_double_bogomflops(%rip), %rsi
	leaq	double_initialize(%rip), %rdi
	call	benchmp@PLT
	addq	$32, %rsp
	.cfi_def_cfa_offset 112
	call	get_n@PLT
	movslq	20(%rsp), %rsi
	imulq	%rax, %rsi
	leaq	.LC34(%rip), %rdi
	call	nano@PLT
	movq	stdout(%rip), %rdi
	call	fflush@PLT
	movq	stderr(%rip), %rdi
	call	fflush@PLT
	movq	40(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L140
	movl	$0, %eax
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
.L140:
	.cfi_restore_state
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE93:
	.size	main, .-main
	.globl	id
	.section	.rodata.str1.1
.LC35:
	.string	"$Id$\n"
	.section	.data.rel.local,"aw"
	.align 8
	.type	id, @object
	.size	id, 8
id:
	.quad	.LC35
	.section	.rodata.cst4,"aM",@progbits,4
	.align 4
.LC0:
	.long	1065353216
	.set	.LC1,.LC12+4
	.section	.rodata.cst8,"aM",@progbits,8
	.align 8
.LC2:
	.long	0
	.long	1072693248
	.align 8
.LC3:
	.long	0
	.long	1073217536
	.section	.rodata.cst4
	.align 4
.LC5:
	.long	1078530011
	.section	.rodata.cst8
	.align 8
.LC6:
	.long	1405670641
	.long	1074340347
	.section	.rodata.cst4
	.align 4
.LC7:
	.long	1090519040
	.align 4
.LC8:
	.long	1040187392
	.align 4
.LC9:
	.long	1148846080
	.align 4
.LC10:
	.long	1068827891
	.section	.rodata.cst8
	.align 8
.LC11:
	.long	0
	.long	1075838976
	.align 8
.LC12:
	.long	0
	.long	1069547520
	.align 8
.LC13:
	.long	0
	.long	1083129856
	.align 8
.LC14:
	.long	1708926943
	.long	1073127582
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
