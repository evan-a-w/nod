	.file	"lib_stats.c"
	.text
	.globl	int_compare
	.type	int_compare, @function
int_compare:
.LFB72:
	.cfi_startproc
	endbr64
	movl	(%rdi), %ecx
	movl	(%rsi), %edx
	movl	$-1, %eax
	cmpl	%edx, %ecx
	jl	.L1
	setg	%al
	movzbl	%al, %eax
.L1:
	ret
	.cfi_endproc
.LFE72:
	.size	int_compare, .-int_compare
	.globl	uint64_compare
	.type	uint64_compare, @function
uint64_compare:
.LFB73:
	.cfi_startproc
	endbr64
	movq	(%rdi), %rcx
	movq	(%rsi), %rdx
	movl	$-1, %eax
	cmpq	%rdx, %rcx
	jb	.L4
	seta	%al
	movzbl	%al, %eax
.L4:
	ret
	.cfi_endproc
.LFE73:
	.size	uint64_compare, .-uint64_compare
	.globl	double_compare
	.type	double_compare, @function
double_compare:
.LFB74:
	.cfi_startproc
	endbr64
	movsd	(%rdi), %xmm1
	movsd	(%rsi), %xmm0
	movl	$-1, %eax
	comisd	%xmm1, %xmm0
	ja	.L7
	comisd	%xmm0, %xmm1
	seta	%al
	movzbl	%al, %eax
.L7:
	ret
	.cfi_endproc
.LFE74:
	.size	double_compare, .-double_compare
	.globl	int_median
	.type	int_median, @function
int_median:
.LFB75:
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
	movq	%rdi, %rbp
	movl	%esi, %ebx
	movslq	%esi, %rsi
	leaq	int_compare(%rip), %rcx
	movl	$4, %edx
	call	qsort@PLT
	movl	%ebx, %eax
	testl	%ebx, %ebx
	je	.L10
	testb	$1, %bl
	jne	.L15
	shrl	$31, %eax
	addl	%ebx, %eax
	sarl	%eax
	cltq
	movl	0(%rbp,%rax,4), %edx
	addl	-4(%rbp,%rax,4), %edx
	movl	%edx, %eax
	shrl	$31, %eax
	addl	%edx, %eax
	sarl	%eax
.L10:
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
.L15:
	.cfi_restore_state
	shrl	$31, %eax
	addl	%ebx, %eax
	sarl	%eax
	cltq
	movl	0(%rbp,%rax,4), %eax
	jmp	.L10
	.cfi_endproc
.LFE75:
	.size	int_median, .-int_median
	.globl	uint64_median
	.type	uint64_median, @function
uint64_median:
.LFB76:
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
	movq	%rdi, %rbp
	movl	%esi, %ebx
	movslq	%esi, %rsi
	leaq	uint64_compare(%rip), %rcx
	movl	$8, %edx
	call	qsort@PLT
	movl	$0, %eax
	testl	%ebx, %ebx
	je	.L16
	testb	$1, %bl
	jne	.L21
	movl	%ebx, %edx
	shrl	$31, %edx
	addl	%ebx, %edx
	sarl	%edx
	movslq	%edx, %rdx
	movq	0(%rbp,%rdx,8), %rax
	addq	-8(%rbp,%rdx,8), %rax
	shrq	%rax
.L16:
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
.L21:
	.cfi_restore_state
	movl	%ebx, %eax
	shrl	$31, %eax
	addl	%ebx, %eax
	sarl	%eax
	cltq
	movq	0(%rbp,%rax,8), %rax
	jmp	.L16
	.cfi_endproc
.LFE76:
	.size	uint64_median, .-uint64_median
	.globl	double_median
	.type	double_median, @function
double_median:
.LFB77:
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
	movq	%rdi, %rbp
	movl	%esi, %ebx
	movslq	%esi, %rsi
	leaq	double_compare(%rip), %rcx
	movl	$8, %edx
	call	qsort@PLT
	pxor	%xmm0, %xmm0
	testl	%ebx, %ebx
	je	.L22
	testb	$1, %bl
	jne	.L27
	movl	%ebx, %eax
	shrl	$31, %eax
	addl	%ebx, %eax
	sarl	%eax
	cltq
	movsd	-8(%rbp,%rax,8), %xmm0
	addsd	0(%rbp,%rax,8), %xmm0
	mulsd	.LC1(%rip), %xmm0
.L22:
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
.L27:
	.cfi_restore_state
	movl	%ebx, %eax
	shrl	$31, %eax
	addl	%ebx, %eax
	sarl	%eax
	cltq
	movsd	0(%rbp,%rax,8), %xmm0
	jmp	.L22
	.cfi_endproc
.LFE77:
	.size	double_median, .-double_median
	.globl	int_mean
	.type	int_mean, @function
int_mean:
.LFB78:
	.cfi_startproc
	endbr64
	testl	%esi, %esi
	jle	.L31
	movq	%rdi, %rdx
	leal	-1(%rsi), %eax
	leaq	4(%rdi,%rax,4), %rcx
	movl	$0, %eax
.L30:
	addl	(%rdx), %eax
	addq	$4, %rdx
	cmpq	%rcx, %rdx
	jne	.L30
.L29:
	cltd
	idivl	%esi
	ret
.L31:
	movl	$0, %eax
	jmp	.L29
	.cfi_endproc
.LFE78:
	.size	int_mean, .-int_mean
	.globl	uint64_mean
	.type	uint64_mean, @function
uint64_mean:
.LFB79:
	.cfi_startproc
	endbr64
	testl	%esi, %esi
	jle	.L36
	movq	%rdi, %rdx
	leal	-1(%rsi), %eax
	leaq	8(%rdi,%rax,8), %rcx
	movl	$0, %eax
.L35:
	addq	(%rdx), %rax
	addq	$8, %rdx
	cmpq	%rcx, %rdx
	jne	.L35
.L34:
	movslq	%esi, %rsi
	movl	$0, %edx
	divq	%rsi
	ret
.L36:
	movl	$0, %eax
	jmp	.L34
	.cfi_endproc
.LFE79:
	.size	uint64_mean, .-uint64_mean
	.globl	double_mean
	.type	double_mean, @function
double_mean:
.LFB80:
	.cfi_startproc
	endbr64
	testl	%esi, %esi
	jle	.L41
	movq	%rdi, %rax
	leal	-1(%rsi), %edx
	leaq	8(%rdi,%rdx,8), %rdx
	pxor	%xmm0, %xmm0
.L40:
	addsd	(%rax), %xmm0
	addq	$8, %rax
	cmpq	%rdx, %rax
	jne	.L40
.L39:
	pxor	%xmm1, %xmm1
	cvtsi2sdl	%esi, %xmm1
	divsd	%xmm1, %xmm0
	ret
.L41:
	pxor	%xmm0, %xmm0
	jmp	.L39
	.cfi_endproc
.LFE80:
	.size	double_mean, .-double_mean
	.globl	int_min
	.type	int_min, @function
int_min:
.LFB81:
	.cfi_startproc
	endbr64
	movl	(%rdi), %edx
	cmpl	$1, %esi
	jle	.L43
	leaq	4(%rdi), %rax
	leal	-2(%rsi), %ecx
	leaq	8(%rdi,%rcx,4), %rsi
.L45:
	movl	(%rax), %ecx
	cmpl	%ecx, %edx
	cmovg	%ecx, %edx
	addq	$4, %rax
	cmpq	%rsi, %rax
	jne	.L45
.L43:
	movl	%edx, %eax
	ret
	.cfi_endproc
.LFE81:
	.size	int_min, .-int_min
	.globl	uint64_min
	.type	uint64_min, @function
uint64_min:
.LFB82:
	.cfi_startproc
	endbr64
	movq	(%rdi), %rdx
	cmpl	$1, %esi
	jle	.L47
	leaq	8(%rdi), %rax
	leal	-2(%rsi), %ecx
	leaq	16(%rdi,%rcx,8), %rsi
.L49:
	movq	(%rax), %rcx
	cmpq	%rcx, %rdx
	cmova	%rcx, %rdx
	addq	$8, %rax
	cmpq	%rsi, %rax
	jne	.L49
.L47:
	movq	%rdx, %rax
	ret
	.cfi_endproc
.LFE82:
	.size	uint64_min, .-uint64_min
	.globl	double_min
	.type	double_min, @function
double_min:
.LFB83:
	.cfi_startproc
	endbr64
	movsd	(%rdi), %xmm0
	cmpl	$1, %esi
	jle	.L51
	leaq	8(%rdi), %rax
	leal	-2(%rsi), %edx
	leaq	16(%rdi,%rdx,8), %rdx
.L55:
	movsd	(%rax), %xmm1
	minsd	%xmm0, %xmm1
	movapd	%xmm1, %xmm0
	addq	$8, %rax
	cmpq	%rdx, %rax
	jne	.L55
.L51:
	ret
	.cfi_endproc
.LFE83:
	.size	double_min, .-double_min
	.globl	int_max
	.type	int_max, @function
int_max:
.LFB84:
	.cfi_startproc
	endbr64
	movl	(%rdi), %edx
	cmpl	$1, %esi
	jle	.L58
	leaq	4(%rdi), %rax
	leal	-2(%rsi), %ecx
	leaq	8(%rdi,%rcx,4), %rsi
.L60:
	movl	(%rax), %ecx
	cmpl	%ecx, %edx
	cmovl	%ecx, %edx
	addq	$4, %rax
	cmpq	%rsi, %rax
	jne	.L60
.L58:
	movl	%edx, %eax
	ret
	.cfi_endproc
.LFE84:
	.size	int_max, .-int_max
	.globl	uint64_max
	.type	uint64_max, @function
uint64_max:
.LFB85:
	.cfi_startproc
	endbr64
	movq	(%rdi), %rdx
	cmpl	$1, %esi
	jle	.L62
	leaq	8(%rdi), %rax
	leal	-2(%rsi), %ecx
	leaq	16(%rdi,%rcx,8), %rsi
.L64:
	movq	(%rax), %rcx
	cmpq	%rcx, %rdx
	cmovb	%rcx, %rdx
	addq	$8, %rax
	cmpq	%rsi, %rax
	jne	.L64
.L62:
	movq	%rdx, %rax
	ret
	.cfi_endproc
.LFE85:
	.size	uint64_max, .-uint64_max
	.globl	double_max
	.type	double_max, @function
double_max:
.LFB86:
	.cfi_startproc
	endbr64
	movsd	(%rdi), %xmm0
	cmpl	$1, %esi
	jle	.L66
	leaq	8(%rdi), %rax
	leal	-2(%rsi), %edx
	leaq	16(%rdi,%rdx,8), %rdx
.L70:
	movsd	(%rax), %xmm1
	maxsd	%xmm0, %xmm1
	movapd	%xmm1, %xmm0
	addq	$8, %rax
	cmpq	%rdx, %rax
	jne	.L70
.L66:
	ret
	.cfi_endproc
.LFE86:
	.size	double_max, .-double_max
	.globl	int_variance
	.type	int_variance, @function
int_variance:
.LFB87:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushq	%rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	movq	%rdi, %rbp
	movl	%esi, %ebx
	call	int_mean
	testl	%ebx, %ebx
	jle	.L76
	movq	%rbp, %rcx
	leal	-1(%rbx), %edx
	leaq	4(%rbp,%rdx,4), %rsi
	pxor	%xmm0, %xmm0
.L75:
	movl	(%rcx), %edx
	subl	%eax, %edx
	imull	%edx, %edx
	pxor	%xmm1, %xmm1
	cvtsi2sdl	%edx, %xmm1
	addsd	%xmm1, %xmm0
	addq	$4, %rcx
	cmpq	%rsi, %rcx
	jne	.L75
.L74:
	subl	$1, %ebx
	pxor	%xmm1, %xmm1
	cvtsi2sdl	%ebx, %xmm1
	divsd	%xmm1, %xmm0
	popq	%rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
.L76:
	.cfi_restore_state
	pxor	%xmm0, %xmm0
	jmp	.L74
	.cfi_endproc
.LFE87:
	.size	int_variance, .-int_variance
	.globl	uint64_variance
	.type	uint64_variance, @function
uint64_variance:
.LFB88:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushq	%rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	movq	%rdi, %rbp
	movl	%esi, %ebx
	call	uint64_mean
	testl	%ebx, %ebx
	jle	.L84
	movq	%rbp, %rcx
	leal	-1(%rbx), %edx
	leaq	8(%rbp,%rdx,8), %rdi
	pxor	%xmm0, %xmm0
	jmp	.L83
.L81:
	movq	%rdx, %rsi
	shrq	%rsi
	andl	$1, %edx
	orq	%rdx, %rsi
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rsi, %xmm1
	addsd	%xmm1, %xmm1
.L82:
	addsd	%xmm1, %xmm0
	addq	$8, %rcx
	cmpq	%rdi, %rcx
	je	.L80
.L83:
	movq	(%rcx), %rdx
	subq	%rax, %rdx
	imulq	%rdx, %rdx
	testq	%rdx, %rdx
	js	.L81
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rdx, %xmm1
	jmp	.L82
.L84:
	pxor	%xmm0, %xmm0
.L80:
	subl	$1, %ebx
	pxor	%xmm1, %xmm1
	cvtsi2sdl	%ebx, %xmm1
	divsd	%xmm1, %xmm0
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE88:
	.size	uint64_variance, .-uint64_variance
	.globl	double_variance
	.type	double_variance, @function
double_variance:
.LFB89:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushq	%rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	movq	%rdi, %rbp
	movl	%esi, %ebx
	call	double_mean
	testl	%ebx, %ebx
	jle	.L90
	movapd	%xmm0, %xmm2
	movq	%rbp, %rax
	leal	-1(%rbx), %edx
	leaq	8(%rbp,%rdx,8), %rdx
	pxor	%xmm0, %xmm0
.L89:
	movsd	(%rax), %xmm1
	subsd	%xmm2, %xmm1
	mulsd	%xmm1, %xmm1
	addsd	%xmm1, %xmm0
	addq	$8, %rax
	cmpq	%rdx, %rax
	jne	.L89
.L88:
	subl	$1, %ebx
	pxor	%xmm1, %xmm1
	cvtsi2sdl	%ebx, %xmm1
	divsd	%xmm1, %xmm0
	popq	%rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
.L90:
	.cfi_restore_state
	pxor	%xmm0, %xmm0
	jmp	.L88
	.cfi_endproc
.LFE89:
	.size	double_variance, .-double_variance
	.globl	int_moment
	.type	int_moment, @function
int_moment:
.LFB90:
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
	movl	%edi, %ebx
	movq	%rsi, %r12
	movl	%edx, %ebp
	movl	%edx, %esi
	movq	%r12, %rdi
	call	int_mean
	testl	%ebp, %ebp
	jle	.L98
	movq	%r12, %rcx
	leal	-1(%rbp), %edx
	leaq	4(%r12,%rdx,4), %rsi
	pxor	%xmm0, %xmm0
.L97:
	movl	(%rcx), %edx
	subl	%eax, %edx
	pxor	%xmm2, %xmm2
	cvtsi2sdl	%edx, %xmm2
	cmpl	$1, %ebx
	jle	.L99
	movapd	%xmm2, %xmm1
	movl	$1, %edx
.L96:
	mulsd	%xmm2, %xmm1
	addl	$1, %edx
	cmpl	%edx, %ebx
	jne	.L96
.L95:
	addsd	%xmm1, %xmm0
	addq	$4, %rcx
	cmpq	%rsi, %rcx
	jne	.L97
.L94:
	pxor	%xmm1, %xmm1
	cvtsi2sdl	%ebp, %xmm1
	divsd	%xmm1, %xmm0
	popq	%rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	ret
.L99:
	.cfi_restore_state
	movapd	%xmm2, %xmm1
	jmp	.L95
.L98:
	pxor	%xmm0, %xmm0
	jmp	.L94
	.cfi_endproc
.LFE90:
	.size	int_moment, .-int_moment
	.globl	uint64_moment
	.type	uint64_moment, @function
uint64_moment:
.LFB91:
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
	movl	%edi, %ebx
	movq	%rsi, %r12
	movl	%edx, %ebp
	movl	%edx, %esi
	movq	%r12, %rdi
	call	uint64_mean
	testl	%ebp, %ebp
	jle	.L110
	movq	%r12, %rcx
	leal	-1(%rbp), %edx
	leaq	8(%r12,%rdx,8), %rdi
	pxor	%xmm0, %xmm0
	jmp	.L109
.L105:
	movq	%rdx, %rsi
	shrq	%rsi
	andl	$1, %edx
	orq	%rdx, %rsi
	pxor	%xmm2, %xmm2
	cvtsi2sdq	%rsi, %xmm2
	addsd	%xmm2, %xmm2
.L106:
	cmpl	$1, %ebx
	jle	.L111
	movapd	%xmm2, %xmm1
	movl	$1, %edx
.L108:
	mulsd	%xmm2, %xmm1
	addl	$1, %edx
	cmpl	%edx, %ebx
	jne	.L108
.L107:
	addsd	%xmm1, %xmm0
	addq	$8, %rcx
	cmpq	%rdi, %rcx
	je	.L104
.L109:
	movq	(%rcx), %rdx
	subq	%rax, %rdx
	js	.L105
	pxor	%xmm2, %xmm2
	cvtsi2sdq	%rdx, %xmm2
	jmp	.L106
.L111:
	movapd	%xmm2, %xmm1
	jmp	.L107
.L110:
	pxor	%xmm0, %xmm0
.L104:
	pxor	%xmm1, %xmm1
	cvtsi2sdl	%ebp, %xmm1
	divsd	%xmm1, %xmm0
	popq	%rbx
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE91:
	.size	uint64_moment, .-uint64_moment
	.globl	double_moment
	.type	double_moment, @function
double_moment:
.LFB92:
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
	movl	%edi, %ebx
	movq	%rsi, %r12
	movl	%edx, %ebp
	movl	%edx, %esi
	movq	%r12, %rdi
	call	double_mean
	testl	%ebp, %ebp
	jle	.L120
	movapd	%xmm0, %xmm3
	movq	%r12, %rdx
	leal	-1(%rbp), %eax
	leaq	8(%r12,%rax,8), %rcx
	pxor	%xmm0, %xmm0
.L119:
	movsd	(%rdx), %xmm2
	subsd	%xmm3, %xmm2
	cmpl	$1, %ebx
	jle	.L121
	movapd	%xmm2, %xmm1
	movl	$1, %eax
.L118:
	mulsd	%xmm2, %xmm1
	addl	$1, %eax
	cmpl	%eax, %ebx
	jne	.L118
.L117:
	addsd	%xmm1, %xmm0
	addq	$8, %rdx
	cmpq	%rcx, %rdx
	jne	.L119
.L116:
	pxor	%xmm1, %xmm1
	cvtsi2sdl	%ebp, %xmm1
	divsd	%xmm1, %xmm0
	popq	%rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	ret
.L121:
	.cfi_restore_state
	movapd	%xmm2, %xmm1
	jmp	.L117
.L120:
	pxor	%xmm0, %xmm0
	jmp	.L116
	.cfi_endproc
.LFE92:
	.size	double_moment, .-double_moment
	.globl	int_stderr
	.type	int_stderr, @function
int_stderr:
.LFB93:
	.cfi_startproc
	endbr64
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	call	int_variance
	pxor	%xmm1, %xmm1
	ucomisd	%xmm0, %xmm1
	ja	.L130
	sqrtsd	%xmm0, %xmm0
.L125:
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	ret
.L130:
	.cfi_restore_state
	call	sqrt@PLT
	jmp	.L125
	.cfi_endproc
.LFE93:
	.size	int_stderr, .-int_stderr
	.globl	uint64_stderr
	.type	uint64_stderr, @function
uint64_stderr:
.LFB94:
	.cfi_startproc
	endbr64
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	call	uint64_variance
	pxor	%xmm1, %xmm1
	ucomisd	%xmm0, %xmm1
	ja	.L137
	sqrtsd	%xmm0, %xmm0
.L132:
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	ret
.L137:
	.cfi_restore_state
	call	sqrt@PLT
	jmp	.L132
	.cfi_endproc
.LFE94:
	.size	uint64_stderr, .-uint64_stderr
	.globl	double_stderr
	.type	double_stderr, @function
double_stderr:
.LFB95:
	.cfi_startproc
	endbr64
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	call	double_variance
	pxor	%xmm1, %xmm1
	ucomisd	%xmm0, %xmm1
	ja	.L144
	sqrtsd	%xmm0, %xmm0
.L139:
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	ret
.L144:
	.cfi_restore_state
	call	sqrt@PLT
	jmp	.L139
	.cfi_endproc
.LFE95:
	.size	double_stderr, .-double_stderr
	.globl	int_skew
	.type	int_skew, @function
int_skew:
.LFB96:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushq	%rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	subq	$24, %rsp
	.cfi_def_cfa_offset 48
	movq	%rdi, %rbx
	movl	%esi, %ebp
	call	int_stderr
	movsd	%xmm0, 8(%rsp)
	movl	%ebp, %edx
	movq	%rbx, %rsi
	movl	$3, %edi
	call	int_moment
	movsd	8(%rsp), %xmm2
	movapd	%xmm2, %xmm1
	mulsd	%xmm2, %xmm1
	mulsd	%xmm2, %xmm1
	divsd	%xmm1, %xmm0
	addq	$24, %rsp
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE96:
	.size	int_skew, .-int_skew
	.globl	uint64_skew
	.type	uint64_skew, @function
uint64_skew:
.LFB97:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushq	%rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	subq	$24, %rsp
	.cfi_def_cfa_offset 48
	movq	%rdi, %rbx
	movl	%esi, %ebp
	call	uint64_stderr
	movsd	%xmm0, 8(%rsp)
	movl	%ebp, %edx
	movq	%rbx, %rsi
	movl	$3, %edi
	call	uint64_moment
	movsd	8(%rsp), %xmm2
	movapd	%xmm2, %xmm1
	mulsd	%xmm2, %xmm1
	mulsd	%xmm2, %xmm1
	divsd	%xmm1, %xmm0
	addq	$24, %rsp
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE97:
	.size	uint64_skew, .-uint64_skew
	.globl	double_skew
	.type	double_skew, @function
double_skew:
.LFB98:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushq	%rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	subq	$24, %rsp
	.cfi_def_cfa_offset 48
	movq	%rdi, %rbx
	movl	%esi, %ebp
	call	double_stderr
	movsd	%xmm0, 8(%rsp)
	movl	%ebp, %edx
	movq	%rbx, %rsi
	movl	$3, %edi
	call	double_moment
	movsd	8(%rsp), %xmm2
	movapd	%xmm2, %xmm1
	mulsd	%xmm2, %xmm1
	mulsd	%xmm2, %xmm1
	divsd	%xmm1, %xmm0
	addq	$24, %rsp
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE98:
	.size	double_skew, .-double_skew
	.globl	int_kurtosis
	.type	int_kurtosis, @function
int_kurtosis:
.LFB99:
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
	call	int_variance
	movsd	%xmm0, (%rsp)
	movl	%ebp, %edx
	movq	%rbx, %rsi
	movl	$4, %edi
	call	int_moment
	movsd	(%rsp), %xmm1
	mulsd	%xmm1, %xmm1
	divsd	%xmm1, %xmm0
	subsd	.LC2(%rip), %xmm0
	addq	$8, %rsp
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE99:
	.size	int_kurtosis, .-int_kurtosis
	.globl	uint64_kurtosis
	.type	uint64_kurtosis, @function
uint64_kurtosis:
.LFB100:
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
	call	uint64_variance
	movsd	%xmm0, (%rsp)
	movl	%ebp, %edx
	movq	%rbx, %rsi
	movl	$4, %edi
	call	uint64_moment
	movsd	(%rsp), %xmm1
	mulsd	%xmm1, %xmm1
	divsd	%xmm1, %xmm0
	subsd	.LC2(%rip), %xmm0
	addq	$8, %rsp
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE100:
	.size	uint64_kurtosis, .-uint64_kurtosis
	.globl	double_kurtosis
	.type	double_kurtosis, @function
double_kurtosis:
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
	call	double_variance
	movsd	%xmm0, (%rsp)
	movl	%ebp, %edx
	movq	%rbx, %rsi
	movl	$4, %edi
	call	double_moment
	movsd	(%rsp), %xmm1
	mulsd	%xmm1, %xmm1
	divsd	%xmm1, %xmm0
	subsd	.LC2(%rip), %xmm0
	addq	$8, %rsp
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE101:
	.size	double_kurtosis, .-double_kurtosis
	.globl	int_bootstrap_stderr
	.type	int_bootstrap_stderr, @function
int_bootstrap_stderr:
.LFB102:
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
	movq	%rdi, %r12
	movl	%esi, %ebp
	movq	%rdx, 32(%rsp)
	movslq	%esi, %rdi
	salq	$2, %rdi
	call	malloc@PLT
	movq	%rax, %rbx
	movq	%rax, 8(%rsp)
	movl	$1600, %edi
	call	malloc@PLT
	movq	%rax, %r15
	movq	%rax, 40(%rsp)
	movq	%rax, %r14
	leaq	1600(%rax), %rax
	movq	%rax, 24(%rsp)
	leal	-1(%rbp), %eax
	leaq	4(%rbx,%rax,4), %r13
	pxor	%xmm5, %xmm5
	movsd	%xmm5, 16(%rsp)
	jmp	.L159
.L160:
	call	rand@PLT
	cltd
	idivl	%ebp
	movslq	%edx, %rdx
	movl	(%r12,%rdx,4), %eax
	movl	%eax, (%rbx)
	addq	$4, %rbx
	cmpq	%r13, %rbx
	jne	.L160
.L162:
	movl	%ebp, %esi
	movq	8(%rsp), %rdi
	movq	32(%rsp), %rax
	call	*%rax
	pxor	%xmm0, %xmm0
	cvtsi2sdl	%eax, %xmm0
	movsd	%xmm0, (%r15)
	addsd	16(%rsp), %xmm0
	movsd	%xmm0, 16(%rsp)
	addq	$8, %r15
	cmpq	24(%rsp), %r15
	je	.L161
.L159:
	movq	8(%rsp), %rbx
	testl	%ebp, %ebp
	jg	.L160
	jmp	.L162
.L161:
	movsd	16(%rsp), %xmm1
	divsd	.LC3(%rip), %xmm1
	pxor	%xmm2, %xmm2
.L163:
	movsd	(%r14), %xmm0
	subsd	%xmm1, %xmm0
	mulsd	%xmm0, %xmm0
	addsd	%xmm0, %xmm2
	addq	$8, %r14
	cmpq	24(%rsp), %r14
	jne	.L163
	movapd	%xmm2, %xmm4
	divsd	.LC4(%rip), %xmm4
	movsd	%xmm4, 16(%rsp)
	movq	8(%rsp), %rdi
	call	free@PLT
	movq	40(%rsp), %rdi
	call	free@PLT
	pxor	%xmm0, %xmm0
	movsd	16(%rsp), %xmm4
	ucomisd	%xmm4, %xmm0
	ja	.L172
	sqrtsd	%xmm4, %xmm4
	movapd	%xmm4, %xmm0
.L158:
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
.L172:
	.cfi_restore_state
	movsd	16(%rsp), %xmm0
	call	sqrt@PLT
	jmp	.L158
	.cfi_endproc
.LFE102:
	.size	int_bootstrap_stderr, .-int_bootstrap_stderr
	.globl	uint64_bootstrap_stderr
	.type	uint64_bootstrap_stderr, @function
uint64_bootstrap_stderr:
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
	subq	$56, %rsp
	.cfi_def_cfa_offset 112
	movq	%rdi, %r12
	movl	%esi, %ebp
	movq	%rdx, 32(%rsp)
	movslq	%esi, %rdi
	salq	$3, %rdi
	call	malloc@PLT
	movq	%rax, %rbx
	movq	%rax, 8(%rsp)
	movl	$1600, %edi
	call	malloc@PLT
	movq	%rax, %r15
	movq	%rax, 40(%rsp)
	movq	%rax, %r14
	leaq	1600(%rax), %rax
	movq	%rax, 24(%rsp)
	leal	-1(%rbp), %eax
	leaq	8(%rbx,%rax,8), %r13
	pxor	%xmm4, %xmm4
	movsd	%xmm4, 16(%rsp)
	jmp	.L175
.L177:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L178:
	movsd	%xmm0, (%r15)
	addsd	16(%rsp), %xmm0
	movsd	%xmm0, 16(%rsp)
	addq	$8, %r15
	cmpq	24(%rsp), %r15
	je	.L179
.L175:
	movq	8(%rsp), %rbx
	testl	%ebp, %ebp
	jle	.L180
.L176:
	call	rand@PLT
	cltd
	idivl	%ebp
	movslq	%edx, %rdx
	movq	(%r12,%rdx,8), %rax
	movq	%rax, (%rbx)
	addq	$8, %rbx
	cmpq	%r13, %rbx
	jne	.L176
.L180:
	movl	%ebp, %esi
	movq	8(%rsp), %rdi
	movq	32(%rsp), %rax
	call	*%rax
	testq	%rax, %rax
	js	.L177
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L178
.L179:
	movsd	16(%rsp), %xmm1
	divsd	.LC3(%rip), %xmm1
	pxor	%xmm5, %xmm5
	movsd	%xmm5, 16(%rsp)
.L181:
	movsd	(%r14), %xmm0
	subsd	%xmm1, %xmm0
	mulsd	%xmm0, %xmm0
	addsd	16(%rsp), %xmm0
	movsd	%xmm0, 16(%rsp)
	addq	$8, %r14
	cmpq	24(%rsp), %r14
	jne	.L181
	movq	8(%rsp), %rdi
	call	free@PLT
	movq	40(%rsp), %rdi
	call	free@PLT
	movsd	16(%rsp), %xmm0
	divsd	.LC4(%rip), %xmm0
	pxor	%xmm1, %xmm1
	ucomisd	%xmm0, %xmm1
	ja	.L190
	sqrtsd	%xmm0, %xmm0
.L174:
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
.L190:
	.cfi_restore_state
	call	sqrt@PLT
	jmp	.L174
	.cfi_endproc
.LFE103:
	.size	uint64_bootstrap_stderr, .-uint64_bootstrap_stderr
	.globl	double_bootstrap_stderr
	.type	double_bootstrap_stderr, @function
double_bootstrap_stderr:
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
	subq	$56, %rsp
	.cfi_def_cfa_offset 112
	movq	%rdi, %r12
	movl	%esi, %ebp
	movq	%rdx, 32(%rsp)
	movslq	%esi, %rdi
	salq	$3, %rdi
	call	malloc@PLT
	movq	%rax, %rbx
	movq	%rax, 8(%rsp)
	movl	$1600, %edi
	call	malloc@PLT
	movq	%rax, %r15
	movq	%rax, 40(%rsp)
	movq	%rax, %r14
	leaq	1600(%rax), %rax
	movq	%rax, 24(%rsp)
	leal	-1(%rbp), %eax
	leaq	8(%rbx,%rax,8), %r13
	pxor	%xmm5, %xmm5
	movsd	%xmm5, 16(%rsp)
	jmp	.L193
.L194:
	call	rand@PLT
	cltd
	idivl	%ebp
	movslq	%edx, %rdx
	movsd	(%r12,%rdx,8), %xmm0
	movsd	%xmm0, (%rbx)
	addq	$8, %rbx
	cmpq	%r13, %rbx
	jne	.L194
.L196:
	movl	%ebp, %esi
	movq	8(%rsp), %rdi
	movq	32(%rsp), %rax
	call	*%rax
	movsd	%xmm0, (%r15)
	addsd	16(%rsp), %xmm0
	movsd	%xmm0, 16(%rsp)
	addq	$8, %r15
	cmpq	24(%rsp), %r15
	je	.L195
.L193:
	movq	8(%rsp), %rbx
	testl	%ebp, %ebp
	jg	.L194
	jmp	.L196
.L195:
	movsd	16(%rsp), %xmm1
	divsd	.LC3(%rip), %xmm1
	pxor	%xmm2, %xmm2
.L197:
	movsd	(%r14), %xmm0
	subsd	%xmm1, %xmm0
	mulsd	%xmm0, %xmm0
	addsd	%xmm0, %xmm2
	addq	$8, %r14
	cmpq	24(%rsp), %r14
	jne	.L197
	movapd	%xmm2, %xmm4
	divsd	.LC4(%rip), %xmm4
	movsd	%xmm4, 16(%rsp)
	movq	8(%rsp), %rdi
	call	free@PLT
	movq	40(%rsp), %rdi
	call	free@PLT
	pxor	%xmm0, %xmm0
	movsd	16(%rsp), %xmm4
	ucomisd	%xmm4, %xmm0
	ja	.L206
	sqrtsd	%xmm4, %xmm4
	movapd	%xmm4, %xmm0
.L192:
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
.L206:
	.cfi_restore_state
	movsd	16(%rsp), %xmm0
	call	sqrt@PLT
	jmp	.L192
	.cfi_endproc
.LFE104:
	.size	double_bootstrap_stderr, .-double_bootstrap_stderr
	.globl	regression
	.type	regression, @function
regression:
.LFB105:
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
	movq	%rdi, %r12
	movq	%rsi, %r13
	movq	%rdx, %rbx
	movl	%ecx, 12(%rsp)
	movq	%r8, %r15
	movq	%r9, %rbp
	movq	96(%rsp), %r14
	testl	%ecx, %ecx
	jle	.L209
	movl	%ecx, %edx
	movl	$0, %eax
	pxor	%xmm5, %xmm5
	movapd	%xmm5, %xmm0
	movapd	%xmm5, %xmm4
	movsd	.LC5(%rip), %xmm6
	movapd	%xmm6, %xmm3
	jmp	.L211
.L210:
	movapd	%xmm3, %xmm1
	divsd	%xmm2, %xmm1
	addsd	%xmm1, %xmm4
	movapd	%xmm1, %xmm2
	mulsd	(%r12,%rax,8), %xmm2
	addsd	%xmm2, %xmm0
	mulsd	0(%r13,%rax,8), %xmm1
	addsd	%xmm1, %xmm5
	addq	$1, %rax
	cmpq	%rdx, %rax
	je	.L248
.L211:
	movapd	%xmm6, %xmm2
	testq	%rbx, %rbx
	je	.L210
	movsd	(%rbx,%rax,8), %xmm2
	mulsd	%xmm2, %xmm2
	jmp	.L210
.L213:
	divsd	%xmm2, %xmm1
	movapd	%xmm1, %xmm3
	mulsd	%xmm1, %xmm3
	addsd	(%rsp), %xmm3
	movsd	%xmm3, (%rsp)
	mulsd	0(%r13,%rax,8), %xmm1
	divsd	%xmm2, %xmm1
	addsd	0(%rbp), %xmm1
	movsd	%xmm1, 0(%rbp)
	addq	$1, %rax
	cmpq	%rdx, %rax
	je	.L231
.L214:
	movsd	(%r12,%rax,8), %xmm1
	subsd	%xmm7, %xmm1
	movapd	%xmm6, %xmm2
	testq	%rbx, %rbx
	je	.L213
	movsd	(%rbx,%rax,8), %xmm2
	jmp	.L213
.L243:
	call	sqrt@PLT
	jmp	.L217
.L244:
	call	sqrt@PLT
	jmp	.L220
.L222:
	divsd	%xmm1, %xmm0
	mulsd	%xmm0, %xmm0
	addsd	(%r14), %xmm0
	movsd	%xmm0, (%r14)
	addq	$1, %rax
	cmpq	%rdx, %rax
	je	.L221
.L223:
	movsd	0(%rbp), %xmm1
	mulsd	(%r12,%rax,8), %xmm1
	addsd	(%r15), %xmm1
	movsd	0(%r13,%rax,8), %xmm0
	subsd	%xmm1, %xmm0
	movapd	%xmm2, %xmm1
	testq	%rbx, %rbx
	je	.L222
	movsd	(%rbx,%rax,8), %xmm1
	jmp	.L222
.L221:
	testq	%rbx, %rbx
	je	.L249
.L208:
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
.L249:
	.cfi_restore_state
	movl	12(%rsp), %eax
	subl	$2, %eax
	pxor	%xmm4, %xmm4
	cvtsi2sdl	%eax, %xmm4
	movsd	%xmm4, (%rsp)
	movsd	(%r14), %xmm0
	divsd	%xmm4, %xmm0
	pxor	%xmm1, %xmm1
	ucomisd	%xmm0, %xmm1
	ja	.L245
	sqrtsd	%xmm0, %xmm0
.L227:
	movq	80(%rsp), %rax
	mulsd	(%rax), %xmm0
	movsd	%xmm0, (%rax)
	movsd	(%r14), %xmm0
	divsd	(%rsp), %xmm0
	pxor	%xmm1, %xmm1
	ucomisd	%xmm0, %xmm1
	ja	.L246
	sqrtsd	%xmm0, %xmm0
.L230:
	movq	88(%rsp), %rax
	mulsd	(%rax), %xmm0
	movsd	%xmm0, (%rax)
	jmp	.L208
.L245:
	call	sqrt@PLT
	jmp	.L227
.L246:
	call	sqrt@PLT
	jmp	.L230
.L248:
	movq	$0x000000000, 0(%rbp)
	movapd	%xmm0, %xmm7
	divsd	%xmm4, %xmm7
	movl	$0, %eax
	pxor	%xmm6, %xmm6
	movsd	%xmm6, (%rsp)
	movsd	.LC5(%rip), %xmm6
	jmp	.L214
.L209:
	movq	$0x000000000, (%r9)
	pxor	%xmm5, %xmm5
	movapd	%xmm5, %xmm0
	movapd	%xmm5, %xmm4
	movsd	%xmm5, (%rsp)
.L231:
	movsd	0(%rbp), %xmm1
	movsd	(%rsp), %xmm7
	divsd	%xmm7, %xmm1
	movsd	%xmm1, 0(%rbp)
	mulsd	%xmm0, %xmm1
	subsd	%xmm1, %xmm5
	divsd	%xmm4, %xmm5
	movsd	%xmm5, (%r15)
	mulsd	%xmm0, %xmm0
	mulsd	%xmm4, %xmm7
	divsd	%xmm7, %xmm0
	addsd	.LC5(%rip), %xmm0
	divsd	%xmm4, %xmm0
	pxor	%xmm1, %xmm1
	ucomisd	%xmm0, %xmm1
	ja	.L243
	sqrtsd	%xmm0, %xmm0
.L217:
	movq	80(%rsp), %rax
	movsd	%xmm0, (%rax)
	movsd	.LC5(%rip), %xmm0
	divsd	(%rsp), %xmm0
	pxor	%xmm1, %xmm1
	ucomisd	%xmm0, %xmm1
	ja	.L244
	sqrtsd	%xmm0, %xmm0
.L220:
	movq	88(%rsp), %rax
	movsd	%xmm0, (%rax)
	movq	$0x000000000, (%r14)
	movl	12(%rsp), %eax
	testl	%eax, %eax
	jle	.L221
	movl	%eax, %edx
	movl	$0, %eax
	movsd	.LC5(%rip), %xmm2
	jmp	.L223
	.cfi_endproc
.LFE105:
	.size	regression, .-regression
	.section	.rodata.cst8,"aM",@progbits,8
	.align 8
.LC1:
	.long	0
	.long	1071644672
	.align 8
.LC2:
	.long	0
	.long	1074266112
	.align 8
.LC3:
	.long	0
	.long	1080623104
	.align 8
.LC4:
	.long	0
	.long	1080614912
	.align 8
.LC5:
	.long	0
	.long	1072693248
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
