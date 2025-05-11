	.file	"lib_stats.c"
	.text
	.globl	int_compare
	.type	int_compare, @function
int_compare:
.LFB8:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	-8(%rbp), %rax
	movl	(%rax), %edx
	movq	-16(%rbp), %rax
	movl	(%rax), %eax
	cmpl	%eax, %edx
	jge	.L2
	movl	$-1, %eax
	jmp	.L3
.L2:
	movq	-8(%rbp), %rax
	movl	(%rax), %edx
	movq	-16(%rbp), %rax
	movl	(%rax), %eax
	cmpl	%eax, %edx
	jle	.L4
	movl	$1, %eax
	jmp	.L3
.L4:
	movl	$0, %eax
.L3:
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE8:
	.size	int_compare, .-int_compare
	.globl	uint64_compare
	.type	uint64_compare, @function
uint64_compare:
.LFB9:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	-8(%rbp), %rax
	movq	(%rax), %rdx
	movq	-16(%rbp), %rax
	movq	(%rax), %rax
	cmpq	%rax, %rdx
	jnb	.L6
	movl	$-1, %eax
	jmp	.L7
.L6:
	movq	-8(%rbp), %rax
	movq	(%rax), %rdx
	movq	-16(%rbp), %rax
	movq	(%rax), %rax
	cmpq	%rax, %rdx
	jbe	.L8
	movl	$1, %eax
	jmp	.L7
.L8:
	movl	$0, %eax
.L7:
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE9:
	.size	uint64_compare, .-uint64_compare
	.globl	double_compare
	.type	double_compare, @function
double_compare:
.LFB10:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	-8(%rbp), %rax
	movsd	(%rax), %xmm1
	movq	-16(%rbp), %rax
	movsd	(%rax), %xmm0
	comisd	%xmm1, %xmm0
	jbe	.L17
	movl	$-1, %eax
	jmp	.L12
.L17:
	movq	-8(%rbp), %rax
	movsd	(%rax), %xmm0
	movq	-16(%rbp), %rax
	movsd	(%rax), %xmm1
	comisd	%xmm1, %xmm0
	jbe	.L18
	movl	$1, %eax
	jmp	.L12
.L18:
	movl	$0, %eax
.L12:
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE10:
	.size	double_compare, .-double_compare
	.globl	int_median
	.type	int_median, @function
int_median:
.LFB11:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movl	%esi, -12(%rbp)
	movl	-12(%rbp), %eax
	movslq	%eax, %rsi
	movq	-8(%rbp), %rax
	leaq	int_compare(%rip), %rdx
	movq	%rdx, %rcx
	movl	$4, %edx
	movq	%rax, %rdi
	call	qsort@PLT
	cmpl	$0, -12(%rbp)
	jne	.L20
	movl	$0, %eax
	jmp	.L21
.L20:
	movl	-12(%rbp), %eax
	andl	$1, %eax
	testl	%eax, %eax
	je	.L22
	movl	-12(%rbp), %eax
	movl	%eax, %edx
	shrl	$31, %edx
	addl	%edx, %eax
	sarl	%eax
	cltq
	leaq	0(,%rax,4), %rdx
	movq	-8(%rbp), %rax
	addq	%rdx, %rax
	movl	(%rax), %eax
	jmp	.L21
.L22:
	movl	-12(%rbp), %eax
	movl	%eax, %edx
	shrl	$31, %edx
	addl	%edx, %eax
	sarl	%eax
	cltq
	salq	$2, %rax
	leaq	-4(%rax), %rdx
	movq	-8(%rbp), %rax
	addq	%rdx, %rax
	movl	(%rax), %edx
	movl	-12(%rbp), %eax
	movl	%eax, %ecx
	shrl	$31, %ecx
	addl	%ecx, %eax
	sarl	%eax
	cltq
	leaq	0(,%rax,4), %rcx
	movq	-8(%rbp), %rax
	addq	%rcx, %rax
	movl	(%rax), %eax
	addl	%edx, %eax
	movl	%eax, %edx
	shrl	$31, %edx
	addl	%edx, %eax
	sarl	%eax
.L21:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE11:
	.size	int_median, .-int_median
	.globl	uint64_median
	.type	uint64_median, @function
uint64_median:
.LFB12:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movl	%esi, -12(%rbp)
	movl	-12(%rbp), %eax
	movslq	%eax, %rsi
	movq	-8(%rbp), %rax
	leaq	uint64_compare(%rip), %rdx
	movq	%rdx, %rcx
	movl	$8, %edx
	movq	%rax, %rdi
	call	qsort@PLT
	cmpl	$0, -12(%rbp)
	jne	.L24
	movl	$0, %eax
	jmp	.L25
.L24:
	movl	-12(%rbp), %eax
	andl	$1, %eax
	testl	%eax, %eax
	je	.L26
	movl	-12(%rbp), %eax
	movl	%eax, %edx
	shrl	$31, %edx
	addl	%edx, %eax
	sarl	%eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-8(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	jmp	.L25
.L26:
	movl	-12(%rbp), %eax
	movl	%eax, %edx
	shrl	$31, %edx
	addl	%edx, %eax
	sarl	%eax
	cltq
	salq	$3, %rax
	leaq	-8(%rax), %rdx
	movq	-8(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rdx
	movl	-12(%rbp), %eax
	movl	%eax, %ecx
	shrl	$31, %ecx
	addl	%ecx, %eax
	sarl	%eax
	cltq
	leaq	0(,%rax,8), %rcx
	movq	-8(%rbp), %rax
	addq	%rcx, %rax
	movq	(%rax), %rax
	addq	%rdx, %rax
	shrq	%rax
.L25:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE12:
	.size	uint64_median, .-uint64_median
	.globl	double_median
	.type	double_median, @function
double_median:
.LFB13:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movl	%esi, -12(%rbp)
	movl	-12(%rbp), %eax
	movslq	%eax, %rsi
	movq	-8(%rbp), %rax
	leaq	double_compare(%rip), %rdx
	movq	%rdx, %rcx
	movl	$8, %edx
	movq	%rax, %rdi
	call	qsort@PLT
	cmpl	$0, -12(%rbp)
	jne	.L28
	pxor	%xmm0, %xmm0
	jmp	.L29
.L28:
	movl	-12(%rbp), %eax
	andl	$1, %eax
	testl	%eax, %eax
	je	.L30
	movl	-12(%rbp), %eax
	movl	%eax, %edx
	shrl	$31, %edx
	addl	%edx, %eax
	sarl	%eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-8(%rbp), %rax
	addq	%rdx, %rax
	movsd	(%rax), %xmm0
	jmp	.L29
.L30:
	movl	-12(%rbp), %eax
	movl	%eax, %edx
	shrl	$31, %edx
	addl	%edx, %eax
	sarl	%eax
	cltq
	salq	$3, %rax
	leaq	-8(%rax), %rdx
	movq	-8(%rbp), %rax
	addq	%rdx, %rax
	movsd	(%rax), %xmm1
	movl	-12(%rbp), %eax
	movl	%eax, %edx
	shrl	$31, %edx
	addl	%edx, %eax
	sarl	%eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-8(%rbp), %rax
	addq	%rdx, %rax
	movsd	(%rax), %xmm0
	addsd	%xmm1, %xmm0
	movsd	.LC1(%rip), %xmm1
	divsd	%xmm1, %xmm0
.L29:
	movq	%xmm0, %rax
	movq	%rax, %xmm0
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE13:
	.size	double_median, .-double_median
	.globl	int_mean
	.type	int_mean, @function
int_mean:
.LFB14:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -24(%rbp)
	movl	%esi, -28(%rbp)
	movl	$0, -4(%rbp)
	movl	$0, -8(%rbp)
	jmp	.L32
.L33:
	movl	-8(%rbp), %eax
	cltq
	leaq	0(,%rax,4), %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movl	(%rax), %eax
	addl	%eax, -4(%rbp)
	addl	$1, -8(%rbp)
.L32:
	movl	-8(%rbp), %eax
	cmpl	-28(%rbp), %eax
	jl	.L33
	movl	-4(%rbp), %eax
	cltd
	idivl	-28(%rbp)
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE14:
	.size	int_mean, .-int_mean
	.globl	uint64_mean
	.type	uint64_mean, @function
uint64_mean:
.LFB15:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -24(%rbp)
	movl	%esi, -28(%rbp)
	movq	$0, -8(%rbp)
	movl	$0, -12(%rbp)
	jmp	.L36
.L37:
	movl	-12(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	addq	%rax, -8(%rbp)
	addl	$1, -12(%rbp)
.L36:
	movl	-12(%rbp), %eax
	cmpl	-28(%rbp), %eax
	jl	.L37
	movl	-28(%rbp), %eax
	movslq	%eax, %rcx
	movq	-8(%rbp), %rax
	movl	$0, %edx
	divq	%rcx
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE15:
	.size	uint64_mean, .-uint64_mean
	.globl	double_mean
	.type	double_mean, @function
double_mean:
.LFB16:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -24(%rbp)
	movl	%esi, -28(%rbp)
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -8(%rbp)
	movl	$0, -12(%rbp)
	jmp	.L40
.L41:
	movl	-12(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movsd	(%rax), %xmm0
	movsd	-8(%rbp), %xmm1
	addsd	%xmm1, %xmm0
	movsd	%xmm0, -8(%rbp)
	addl	$1, -12(%rbp)
.L40:
	movl	-12(%rbp), %eax
	cmpl	-28(%rbp), %eax
	jl	.L41
	pxor	%xmm1, %xmm1
	cvtsi2sdl	-28(%rbp), %xmm1
	movsd	-8(%rbp), %xmm0
	divsd	%xmm1, %xmm0
	movq	%xmm0, %rax
	movq	%rax, %xmm0
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE16:
	.size	double_mean, .-double_mean
	.globl	int_min
	.type	int_min, @function
int_min:
.LFB17:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -24(%rbp)
	movl	%esi, -28(%rbp)
	movq	-24(%rbp), %rax
	movl	(%rax), %eax
	movl	%eax, -4(%rbp)
	movl	$1, -8(%rbp)
	jmp	.L44
.L46:
	movl	-8(%rbp), %eax
	cltq
	leaq	0(,%rax,4), %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movl	(%rax), %eax
	cmpl	%eax, -4(%rbp)
	jle	.L45
	movl	-8(%rbp), %eax
	cltq
	leaq	0(,%rax,4), %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movl	(%rax), %eax
	movl	%eax, -4(%rbp)
.L45:
	addl	$1, -8(%rbp)
.L44:
	movl	-8(%rbp), %eax
	cmpl	-28(%rbp), %eax
	jl	.L46
	movl	-4(%rbp), %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE17:
	.size	int_min, .-int_min
	.globl	uint64_min
	.type	uint64_min, @function
uint64_min:
.LFB18:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -24(%rbp)
	movl	%esi, -28(%rbp)
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -8(%rbp)
	movl	$1, -12(%rbp)
	jmp	.L49
.L51:
	movl	-12(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	cmpq	%rax, -8(%rbp)
	jbe	.L50
	movl	-12(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	%rax, -8(%rbp)
.L50:
	addl	$1, -12(%rbp)
.L49:
	movl	-12(%rbp), %eax
	cmpl	-28(%rbp), %eax
	jl	.L51
	movq	-8(%rbp), %rax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE18:
	.size	uint64_min, .-uint64_min
	.globl	double_min
	.type	double_min, @function
double_min:
.LFB19:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -24(%rbp)
	movl	%esi, -28(%rbp)
	movq	-24(%rbp), %rax
	movsd	(%rax), %xmm0
	movsd	%xmm0, -8(%rbp)
	movl	$1, -12(%rbp)
	jmp	.L54
.L57:
	movl	-12(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movsd	(%rax), %xmm1
	movsd	-8(%rbp), %xmm0
	comisd	%xmm1, %xmm0
	jbe	.L55
	movl	-12(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movsd	(%rax), %xmm0
	movsd	%xmm0, -8(%rbp)
.L55:
	addl	$1, -12(%rbp)
.L54:
	movl	-12(%rbp), %eax
	cmpl	-28(%rbp), %eax
	jl	.L57
	movsd	-8(%rbp), %xmm0
	movq	%xmm0, %rax
	movq	%rax, %xmm0
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE19:
	.size	double_min, .-double_min
	.globl	int_max
	.type	int_max, @function
int_max:
.LFB20:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -24(%rbp)
	movl	%esi, -28(%rbp)
	movq	-24(%rbp), %rax
	movl	(%rax), %eax
	movl	%eax, -4(%rbp)
	movl	$1, -8(%rbp)
	jmp	.L61
.L63:
	movl	-8(%rbp), %eax
	cltq
	leaq	0(,%rax,4), %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movl	(%rax), %eax
	cmpl	%eax, -4(%rbp)
	jge	.L62
	movl	-8(%rbp), %eax
	cltq
	leaq	0(,%rax,4), %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movl	(%rax), %eax
	movl	%eax, -4(%rbp)
.L62:
	addl	$1, -8(%rbp)
.L61:
	movl	-8(%rbp), %eax
	cmpl	-28(%rbp), %eax
	jl	.L63
	movl	-4(%rbp), %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE20:
	.size	int_max, .-int_max
	.globl	uint64_max
	.type	uint64_max, @function
uint64_max:
.LFB21:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -24(%rbp)
	movl	%esi, -28(%rbp)
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -8(%rbp)
	movl	$1, -12(%rbp)
	jmp	.L66
.L68:
	movl	-12(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	cmpq	%rax, -8(%rbp)
	jnb	.L67
	movl	-12(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	%rax, -8(%rbp)
.L67:
	addl	$1, -12(%rbp)
.L66:
	movl	-12(%rbp), %eax
	cmpl	-28(%rbp), %eax
	jl	.L68
	movq	-8(%rbp), %rax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE21:
	.size	uint64_max, .-uint64_max
	.globl	double_max
	.type	double_max, @function
double_max:
.LFB22:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -24(%rbp)
	movl	%esi, -28(%rbp)
	movq	-24(%rbp), %rax
	movsd	(%rax), %xmm0
	movsd	%xmm0, -8(%rbp)
	movl	$1, -12(%rbp)
	jmp	.L71
.L74:
	movl	-12(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movsd	(%rax), %xmm0
	comisd	-8(%rbp), %xmm0
	jbe	.L72
	movl	-12(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movsd	(%rax), %xmm0
	movsd	%xmm0, -8(%rbp)
.L72:
	addl	$1, -12(%rbp)
.L71:
	movl	-12(%rbp), %eax
	cmpl	-28(%rbp), %eax
	jl	.L74
	movsd	-8(%rbp), %xmm0
	movq	%xmm0, %rax
	movq	%rax, %xmm0
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE22:
	.size	double_max, .-double_max
	.globl	int_variance
	.type	int_variance, @function
int_variance:
.LFB23:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%rdi, -24(%rbp)
	movl	%esi, -28(%rbp)
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -8(%rbp)
	movl	-28(%rbp), %edx
	movq	-24(%rbp), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	int_mean
	movl	%eax, -12(%rbp)
	movl	$0, -16(%rbp)
	jmp	.L78
.L79:
	movl	-16(%rbp), %eax
	cltq
	leaq	0(,%rax,4), %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movl	(%rax), %eax
	subl	-12(%rbp), %eax
	movl	%eax, %edx
	movl	-16(%rbp), %eax
	cltq
	leaq	0(,%rax,4), %rcx
	movq	-24(%rbp), %rax
	addq	%rcx, %rax
	movl	(%rax), %eax
	subl	-12(%rbp), %eax
	imull	%edx, %eax
	pxor	%xmm0, %xmm0
	cvtsi2sdl	%eax, %xmm0
	movsd	-8(%rbp), %xmm1
	addsd	%xmm1, %xmm0
	movsd	%xmm0, -8(%rbp)
	addl	$1, -16(%rbp)
.L78:
	movl	-16(%rbp), %eax
	cmpl	-28(%rbp), %eax
	jl	.L79
	movl	-28(%rbp), %eax
	subl	$1, %eax
	pxor	%xmm1, %xmm1
	cvtsi2sdl	%eax, %xmm1
	movsd	-8(%rbp), %xmm0
	divsd	%xmm1, %xmm0
	movq	%xmm0, %rax
	movq	%rax, %xmm0
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE23:
	.size	int_variance, .-int_variance
	.globl	uint64_variance
	.type	uint64_variance, @function
uint64_variance:
.LFB24:
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
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -16(%rbp)
	movl	-44(%rbp), %edx
	movq	-40(%rbp), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	uint64_mean
	movq	%rax, -8(%rbp)
	movl	$0, -20(%rbp)
	jmp	.L82
.L85:
	movl	-20(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-40(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	subq	-8(%rbp), %rax
	movq	%rax, %rdx
	movl	-20(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rcx
	movq	-40(%rbp), %rax
	addq	%rcx, %rax
	movq	(%rax), %rax
	subq	-8(%rbp), %rax
	imulq	%rdx, %rax
	testq	%rax, %rax
	js	.L83
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L84
.L83:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L84:
	movsd	-16(%rbp), %xmm1
	addsd	%xmm1, %xmm0
	movsd	%xmm0, -16(%rbp)
	addl	$1, -20(%rbp)
.L82:
	movl	-20(%rbp), %eax
	cmpl	-44(%rbp), %eax
	jl	.L85
	movl	-44(%rbp), %eax
	subl	$1, %eax
	pxor	%xmm1, %xmm1
	cvtsi2sdl	%eax, %xmm1
	movsd	-16(%rbp), %xmm0
	divsd	%xmm1, %xmm0
	movq	%xmm0, %rax
	movq	%rax, %xmm0
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE24:
	.size	uint64_variance, .-uint64_variance
	.globl	double_variance
	.type	double_variance, @function
double_variance:
.LFB25:
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
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -16(%rbp)
	movl	-44(%rbp), %edx
	movq	-40(%rbp), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	double_mean
	movq	%xmm0, %rax
	movq	%rax, -8(%rbp)
	movl	$0, -20(%rbp)
	jmp	.L88
.L89:
	movl	-20(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-40(%rbp), %rax
	addq	%rdx, %rax
	movsd	(%rax), %xmm0
	movapd	%xmm0, %xmm1
	subsd	-8(%rbp), %xmm1
	movl	-20(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-40(%rbp), %rax
	addq	%rdx, %rax
	movsd	(%rax), %xmm0
	subsd	-8(%rbp), %xmm0
	mulsd	%xmm1, %xmm0
	movsd	-16(%rbp), %xmm1
	addsd	%xmm1, %xmm0
	movsd	%xmm0, -16(%rbp)
	addl	$1, -20(%rbp)
.L88:
	movl	-20(%rbp), %eax
	cmpl	-44(%rbp), %eax
	jl	.L89
	movl	-44(%rbp), %eax
	subl	$1, %eax
	pxor	%xmm1, %xmm1
	cvtsi2sdl	%eax, %xmm1
	movsd	-16(%rbp), %xmm0
	divsd	%xmm1, %xmm0
	movq	%xmm0, %rax
	movq	%rax, %xmm0
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE25:
	.size	double_variance, .-double_variance
	.globl	int_moment
	.type	int_moment, @function
int_moment:
.LFB26:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$64, %rsp
	movl	%edi, -52(%rbp)
	movq	%rsi, -64(%rbp)
	movl	%edx, -56(%rbp)
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -24(%rbp)
	movl	-56(%rbp), %edx
	movq	-64(%rbp), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	int_mean
	movl	%eax, -28(%rbp)
	movl	$0, -36(%rbp)
	jmp	.L92
.L95:
	movl	-36(%rbp), %eax
	cltq
	leaq	0(,%rax,4), %rdx
	movq	-64(%rbp), %rax
	addq	%rdx, %rax
	movl	(%rax), %eax
	subl	-28(%rbp), %eax
	pxor	%xmm0, %xmm0
	cvtsi2sdl	%eax, %xmm0
	movsd	%xmm0, -8(%rbp)
	movsd	-8(%rbp), %xmm0
	movsd	%xmm0, -16(%rbp)
	movl	$1, -32(%rbp)
	jmp	.L93
.L94:
	movsd	-16(%rbp), %xmm0
	mulsd	-8(%rbp), %xmm0
	movsd	%xmm0, -16(%rbp)
	addl	$1, -32(%rbp)
.L93:
	movl	-32(%rbp), %eax
	cmpl	-52(%rbp), %eax
	jl	.L94
	movsd	-24(%rbp), %xmm0
	addsd	-16(%rbp), %xmm0
	movsd	%xmm0, -24(%rbp)
	addl	$1, -36(%rbp)
.L92:
	movl	-36(%rbp), %eax
	cmpl	-56(%rbp), %eax
	jl	.L95
	pxor	%xmm1, %xmm1
	cvtsi2sdl	-56(%rbp), %xmm1
	movsd	-24(%rbp), %xmm0
	divsd	%xmm1, %xmm0
	movq	%xmm0, %rax
	movq	%rax, %xmm0
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE26:
	.size	int_moment, .-int_moment
	.globl	uint64_moment
	.type	uint64_moment, @function
uint64_moment:
.LFB27:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$64, %rsp
	movl	%edi, -52(%rbp)
	movq	%rsi, -64(%rbp)
	movl	%edx, -56(%rbp)
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -32(%rbp)
	movl	-56(%rbp), %edx
	movq	-64(%rbp), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	uint64_mean
	movq	%rax, -16(%rbp)
	movl	$0, -40(%rbp)
	jmp	.L98
.L103:
	movl	-40(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-64(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	subq	-16(%rbp), %rax
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
	movsd	%xmm0, -8(%rbp)
	movsd	-8(%rbp), %xmm0
	movsd	%xmm0, -24(%rbp)
	movl	$1, -36(%rbp)
	jmp	.L101
.L102:
	movsd	-24(%rbp), %xmm0
	mulsd	-8(%rbp), %xmm0
	movsd	%xmm0, -24(%rbp)
	addl	$1, -36(%rbp)
.L101:
	movl	-36(%rbp), %eax
	cmpl	-52(%rbp), %eax
	jl	.L102
	movsd	-32(%rbp), %xmm0
	addsd	-24(%rbp), %xmm0
	movsd	%xmm0, -32(%rbp)
	addl	$1, -40(%rbp)
.L98:
	movl	-40(%rbp), %eax
	cmpl	-56(%rbp), %eax
	jl	.L103
	pxor	%xmm1, %xmm1
	cvtsi2sdl	-56(%rbp), %xmm1
	movsd	-32(%rbp), %xmm0
	divsd	%xmm1, %xmm0
	movq	%xmm0, %rax
	movq	%rax, %xmm0
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE27:
	.size	uint64_moment, .-uint64_moment
	.globl	double_moment
	.type	double_moment, @function
double_moment:
.LFB28:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$64, %rsp
	movl	%edi, -52(%rbp)
	movq	%rsi, -64(%rbp)
	movl	%edx, -56(%rbp)
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -32(%rbp)
	movl	-56(%rbp), %edx
	movq	-64(%rbp), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	double_mean
	movq	%xmm0, %rax
	movq	%rax, -16(%rbp)
	movl	$0, -40(%rbp)
	jmp	.L106
.L109:
	movl	-40(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-64(%rbp), %rax
	addq	%rdx, %rax
	movsd	(%rax), %xmm0
	subsd	-16(%rbp), %xmm0
	movsd	%xmm0, -8(%rbp)
	movsd	-8(%rbp), %xmm0
	movsd	%xmm0, -24(%rbp)
	movl	$1, -36(%rbp)
	jmp	.L107
.L108:
	movsd	-24(%rbp), %xmm0
	mulsd	-8(%rbp), %xmm0
	movsd	%xmm0, -24(%rbp)
	addl	$1, -36(%rbp)
.L107:
	movl	-36(%rbp), %eax
	cmpl	-52(%rbp), %eax
	jl	.L108
	movsd	-32(%rbp), %xmm0
	addsd	-24(%rbp), %xmm0
	movsd	%xmm0, -32(%rbp)
	addl	$1, -40(%rbp)
.L106:
	movl	-40(%rbp), %eax
	cmpl	-56(%rbp), %eax
	jl	.L109
	pxor	%xmm1, %xmm1
	cvtsi2sdl	-56(%rbp), %xmm1
	movsd	-32(%rbp), %xmm0
	divsd	%xmm1, %xmm0
	movq	%xmm0, %rax
	movq	%rax, %xmm0
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE28:
	.size	double_moment, .-double_moment
	.globl	int_stderr
	.type	int_stderr, @function
int_stderr:
.LFB29:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movl	%esi, -12(%rbp)
	movl	-12(%rbp), %edx
	movq	-8(%rbp), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	int_variance
	movq	%xmm0, %rax
	movq	%rax, %xmm0
	call	sqrt@PLT
	movq	%xmm0, %rax
	movq	%rax, %xmm0
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE29:
	.size	int_stderr, .-int_stderr
	.globl	uint64_stderr
	.type	uint64_stderr, @function
uint64_stderr:
.LFB30:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movl	%esi, -12(%rbp)
	movl	-12(%rbp), %edx
	movq	-8(%rbp), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	uint64_variance
	movq	%xmm0, %rax
	movq	%rax, %xmm0
	call	sqrt@PLT
	movq	%xmm0, %rax
	movq	%rax, %xmm0
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE30:
	.size	uint64_stderr, .-uint64_stderr
	.globl	double_stderr
	.type	double_stderr, @function
double_stderr:
.LFB31:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movl	%esi, -12(%rbp)
	movl	-12(%rbp), %edx
	movq	-8(%rbp), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	double_variance
	movq	%xmm0, %rax
	movq	%rax, %xmm0
	call	sqrt@PLT
	movq	%xmm0, %rax
	movq	%rax, %xmm0
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE31:
	.size	double_stderr, .-double_stderr
	.globl	int_skew
	.type	int_skew, @function
int_skew:
.LFB32:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%rdi, -24(%rbp)
	movl	%esi, -28(%rbp)
	movl	-28(%rbp), %edx
	movq	-24(%rbp), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	int_stderr
	movq	%xmm0, %rax
	movq	%rax, -16(%rbp)
	movl	-28(%rbp), %edx
	movq	-24(%rbp), %rax
	movq	%rax, %rsi
	movl	$3, %edi
	call	int_moment
	movq	%xmm0, %rax
	movq	%rax, -8(%rbp)
	movsd	-16(%rbp), %xmm0
	mulsd	%xmm0, %xmm0
	movapd	%xmm0, %xmm1
	mulsd	-16(%rbp), %xmm1
	movsd	-8(%rbp), %xmm0
	divsd	%xmm1, %xmm0
	movq	%xmm0, %rax
	movq	%rax, %xmm0
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE32:
	.size	int_skew, .-int_skew
	.globl	uint64_skew
	.type	uint64_skew, @function
uint64_skew:
.LFB33:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%rdi, -24(%rbp)
	movl	%esi, -28(%rbp)
	movl	-28(%rbp), %edx
	movq	-24(%rbp), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	uint64_stderr
	movq	%xmm0, %rax
	movq	%rax, -16(%rbp)
	movl	-28(%rbp), %edx
	movq	-24(%rbp), %rax
	movq	%rax, %rsi
	movl	$3, %edi
	call	uint64_moment
	movq	%xmm0, %rax
	movq	%rax, -8(%rbp)
	movsd	-16(%rbp), %xmm0
	mulsd	%xmm0, %xmm0
	movapd	%xmm0, %xmm1
	mulsd	-16(%rbp), %xmm1
	movsd	-8(%rbp), %xmm0
	divsd	%xmm1, %xmm0
	movq	%xmm0, %rax
	movq	%rax, %xmm0
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE33:
	.size	uint64_skew, .-uint64_skew
	.globl	double_skew
	.type	double_skew, @function
double_skew:
.LFB34:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%rdi, -24(%rbp)
	movl	%esi, -28(%rbp)
	movl	-28(%rbp), %edx
	movq	-24(%rbp), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	double_stderr
	movq	%xmm0, %rax
	movq	%rax, -16(%rbp)
	movl	-28(%rbp), %edx
	movq	-24(%rbp), %rax
	movq	%rax, %rsi
	movl	$3, %edi
	call	double_moment
	movq	%xmm0, %rax
	movq	%rax, -8(%rbp)
	movsd	-16(%rbp), %xmm0
	mulsd	%xmm0, %xmm0
	movapd	%xmm0, %xmm1
	mulsd	-16(%rbp), %xmm1
	movsd	-8(%rbp), %xmm0
	divsd	%xmm1, %xmm0
	movq	%xmm0, %rax
	movq	%rax, %xmm0
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE34:
	.size	double_skew, .-double_skew
	.globl	int_kurtosis
	.type	int_kurtosis, @function
int_kurtosis:
.LFB35:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%rdi, -24(%rbp)
	movl	%esi, -28(%rbp)
	movl	-28(%rbp), %edx
	movq	-24(%rbp), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	int_variance
	movq	%xmm0, %rax
	movq	%rax, -16(%rbp)
	movl	-28(%rbp), %edx
	movq	-24(%rbp), %rax
	movq	%rax, %rsi
	movl	$4, %edi
	call	int_moment
	movq	%xmm0, %rax
	movq	%rax, -8(%rbp)
	movsd	-16(%rbp), %xmm0
	movapd	%xmm0, %xmm1
	mulsd	%xmm0, %xmm1
	movsd	-8(%rbp), %xmm0
	divsd	%xmm1, %xmm0
	movsd	.LC2(%rip), %xmm1
	subsd	%xmm1, %xmm0
	movq	%xmm0, %rax
	movq	%rax, %xmm0
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE35:
	.size	int_kurtosis, .-int_kurtosis
	.globl	uint64_kurtosis
	.type	uint64_kurtosis, @function
uint64_kurtosis:
.LFB36:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%rdi, -24(%rbp)
	movl	%esi, -28(%rbp)
	movl	-28(%rbp), %edx
	movq	-24(%rbp), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	uint64_variance
	movq	%xmm0, %rax
	movq	%rax, -16(%rbp)
	movl	-28(%rbp), %edx
	movq	-24(%rbp), %rax
	movq	%rax, %rsi
	movl	$4, %edi
	call	uint64_moment
	movq	%xmm0, %rax
	movq	%rax, -8(%rbp)
	movsd	-16(%rbp), %xmm0
	movapd	%xmm0, %xmm1
	mulsd	%xmm0, %xmm1
	movsd	-8(%rbp), %xmm0
	divsd	%xmm1, %xmm0
	movsd	.LC2(%rip), %xmm1
	subsd	%xmm1, %xmm0
	movq	%xmm0, %rax
	movq	%rax, %xmm0
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE36:
	.size	uint64_kurtosis, .-uint64_kurtosis
	.globl	double_kurtosis
	.type	double_kurtosis, @function
double_kurtosis:
.LFB37:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%rdi, -24(%rbp)
	movl	%esi, -28(%rbp)
	movl	-28(%rbp), %edx
	movq	-24(%rbp), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	double_variance
	movq	%xmm0, %rax
	movq	%rax, -16(%rbp)
	movl	-28(%rbp), %edx
	movq	-24(%rbp), %rax
	movq	%rax, %rsi
	movl	$4, %edi
	call	double_moment
	movq	%xmm0, %rax
	movq	%rax, -8(%rbp)
	movsd	-16(%rbp), %xmm0
	movapd	%xmm0, %xmm1
	mulsd	%xmm0, %xmm1
	movsd	-8(%rbp), %xmm0
	divsd	%xmm1, %xmm0
	movsd	.LC2(%rip), %xmm1
	subsd	%xmm1, %xmm0
	movq	%xmm0, %rax
	movq	%rax, %xmm0
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE37:
	.size	double_kurtosis, .-double_kurtosis
	.globl	int_bootstrap_stderr
	.type	int_bootstrap_stderr, @function
int_bootstrap_stderr:
.LFB38:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$80, %rsp
	movq	%rdi, -56(%rbp)
	movl	%esi, -60(%rbp)
	movq	%rdx, -72(%rbp)
	movl	-60(%rbp), %eax
	cltq
	salq	$2, %rax
	movq	%rax, %rdi
	call	malloc@PLT
	movq	%rax, -16(%rbp)
	movl	$1600, %edi
	call	malloc@PLT
	movq	%rax, -8(%rbp)
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -32(%rbp)
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -24(%rbp)
	movl	$0, -40(%rbp)
	jmp	.L130
.L133:
	movl	$0, -36(%rbp)
	jmp	.L131
.L132:
	call	rand@PLT
	cltd
	idivl	-60(%rbp)
	movl	%edx, %eax
	cltq
	leaq	0(,%rax,4), %rdx
	movq	-56(%rbp), %rax
	addq	%rdx, %rax
	movl	-36(%rbp), %edx
	movslq	%edx, %rdx
	leaq	0(,%rdx,4), %rcx
	movq	-16(%rbp), %rdx
	addq	%rcx, %rdx
	movl	(%rax), %eax
	movl	%eax, (%rdx)
	addl	$1, -36(%rbp)
.L131:
	movl	-36(%rbp), %eax
	cmpl	-60(%rbp), %eax
	jl	.L132
	movl	-60(%rbp), %edx
	movq	-16(%rbp), %rax
	movq	-72(%rbp), %rcx
	movl	%edx, %esi
	movq	%rax, %rdi
	call	*%rcx
	movl	%eax, %edx
	movl	-40(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rcx
	movq	-8(%rbp), %rax
	addq	%rcx, %rax
	pxor	%xmm0, %xmm0
	cvtsi2sdl	%edx, %xmm0
	movsd	%xmm0, (%rax)
	movl	-40(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-8(%rbp), %rax
	addq	%rdx, %rax
	movsd	(%rax), %xmm0
	movsd	-32(%rbp), %xmm1
	addsd	%xmm1, %xmm0
	movsd	%xmm0, -32(%rbp)
	addl	$1, -40(%rbp)
.L130:
	cmpl	$199, -40(%rbp)
	jle	.L133
	movsd	-32(%rbp), %xmm0
	movsd	.LC3(%rip), %xmm1
	divsd	%xmm1, %xmm0
	movsd	%xmm0, -32(%rbp)
	movl	$0, -40(%rbp)
	jmp	.L134
.L135:
	movl	-40(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-8(%rbp), %rax
	addq	%rdx, %rax
	movsd	(%rax), %xmm0
	movapd	%xmm0, %xmm1
	subsd	-32(%rbp), %xmm1
	movl	-40(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-8(%rbp), %rax
	addq	%rdx, %rax
	movsd	(%rax), %xmm0
	subsd	-32(%rbp), %xmm0
	mulsd	%xmm1, %xmm0
	movsd	-24(%rbp), %xmm1
	addsd	%xmm1, %xmm0
	movsd	%xmm0, -24(%rbp)
	addl	$1, -40(%rbp)
.L134:
	cmpl	$199, -40(%rbp)
	jle	.L135
	movsd	-24(%rbp), %xmm0
	movsd	.LC4(%rip), %xmm1
	divsd	%xmm1, %xmm0
	movsd	%xmm0, -24(%rbp)
	movq	-16(%rbp), %rax
	movq	%rax, %rdi
	call	free@PLT
	movq	-8(%rbp), %rax
	movq	%rax, %rdi
	call	free@PLT
	movq	-24(%rbp), %rax
	movq	%rax, %xmm0
	call	sqrt@PLT
	movq	%xmm0, %rax
	movq	%rax, %xmm0
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE38:
	.size	int_bootstrap_stderr, .-int_bootstrap_stderr
	.globl	uint64_bootstrap_stderr
	.type	uint64_bootstrap_stderr, @function
uint64_bootstrap_stderr:
.LFB39:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$80, %rsp
	movq	%rdi, -56(%rbp)
	movl	%esi, -60(%rbp)
	movq	%rdx, -72(%rbp)
	movl	-60(%rbp), %eax
	cltq
	salq	$3, %rax
	movq	%rax, %rdi
	call	malloc@PLT
	movq	%rax, -16(%rbp)
	movl	$1600, %edi
	call	malloc@PLT
	movq	%rax, -8(%rbp)
	movl	$0, -40(%rbp)
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -32(%rbp)
	jmp	.L138
.L143:
	movl	$0, -36(%rbp)
	jmp	.L139
.L140:
	call	rand@PLT
	cltd
	idivl	-60(%rbp)
	movl	%edx, %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-56(%rbp), %rax
	addq	%rdx, %rax
	movl	-36(%rbp), %edx
	movslq	%edx, %rdx
	leaq	0(,%rdx,8), %rcx
	movq	-16(%rbp), %rdx
	addq	%rcx, %rdx
	movq	(%rax), %rax
	movq	%rax, (%rdx)
	addl	$1, -36(%rbp)
.L139:
	movl	-36(%rbp), %eax
	cmpl	-60(%rbp), %eax
	jl	.L140
	movl	-60(%rbp), %edx
	movq	-16(%rbp), %rax
	movq	-72(%rbp), %rcx
	movl	%edx, %esi
	movq	%rax, %rdi
	call	*%rcx
	movl	-40(%rbp), %edx
	movslq	%edx, %rdx
	leaq	0(,%rdx,8), %rcx
	movq	-8(%rbp), %rdx
	addq	%rdx, %rcx
	testq	%rax, %rax
	js	.L141
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L142
.L141:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L142:
	movsd	%xmm0, (%rcx)
	movl	-40(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-8(%rbp), %rax
	addq	%rdx, %rax
	movsd	(%rax), %xmm0
	movsd	-32(%rbp), %xmm1
	addsd	%xmm1, %xmm0
	movsd	%xmm0, -32(%rbp)
	addl	$1, -40(%rbp)
.L138:
	cmpl	$199, -40(%rbp)
	jle	.L143
	movsd	-32(%rbp), %xmm0
	movsd	.LC3(%rip), %xmm1
	divsd	%xmm1, %xmm0
	movsd	%xmm0, -32(%rbp)
	movl	$0, -40(%rbp)
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -24(%rbp)
	jmp	.L144
.L145:
	movl	-40(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-8(%rbp), %rax
	addq	%rdx, %rax
	movsd	(%rax), %xmm0
	movapd	%xmm0, %xmm1
	subsd	-32(%rbp), %xmm1
	movl	-40(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-8(%rbp), %rax
	addq	%rdx, %rax
	movsd	(%rax), %xmm0
	subsd	-32(%rbp), %xmm0
	mulsd	%xmm1, %xmm0
	movsd	-24(%rbp), %xmm1
	addsd	%xmm1, %xmm0
	movsd	%xmm0, -24(%rbp)
	addl	$1, -40(%rbp)
.L144:
	cmpl	$199, -40(%rbp)
	jle	.L145
	movq	-16(%rbp), %rax
	movq	%rax, %rdi
	call	free@PLT
	movq	-8(%rbp), %rax
	movq	%rax, %rdi
	call	free@PLT
	movsd	-24(%rbp), %xmm0
	movsd	.LC4(%rip), %xmm1
	divsd	%xmm1, %xmm0
	movq	%xmm0, %rax
	movq	%rax, %xmm0
	call	sqrt@PLT
	movq	%xmm0, %rax
	movq	%rax, %xmm0
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE39:
	.size	uint64_bootstrap_stderr, .-uint64_bootstrap_stderr
	.globl	double_bootstrap_stderr
	.type	double_bootstrap_stderr, @function
double_bootstrap_stderr:
.LFB40:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%rbx
	subq	$88, %rsp
	.cfi_offset 3, -24
	movq	%rdi, -72(%rbp)
	movl	%esi, -76(%rbp)
	movq	%rdx, -88(%rbp)
	movl	-76(%rbp), %eax
	cltq
	salq	$3, %rax
	movq	%rax, %rdi
	call	malloc@PLT
	movq	%rax, -32(%rbp)
	movl	$1600, %edi
	call	malloc@PLT
	movq	%rax, -24(%rbp)
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -48(%rbp)
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -40(%rbp)
	movl	$0, -56(%rbp)
	jmp	.L148
.L151:
	movl	$0, -52(%rbp)
	jmp	.L149
.L150:
	call	rand@PLT
	cltd
	idivl	-76(%rbp)
	movl	%edx, %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-72(%rbp), %rax
	addq	%rax, %rdx
	movl	-52(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rcx
	movq	-32(%rbp), %rax
	addq	%rcx, %rax
	movsd	(%rdx), %xmm0
	movsd	%xmm0, (%rax)
	addl	$1, -52(%rbp)
.L149:
	movl	-52(%rbp), %eax
	cmpl	-76(%rbp), %eax
	jl	.L150
	movl	-56(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-24(%rbp), %rax
	leaq	(%rdx,%rax), %rbx
	movl	-76(%rbp), %edx
	movq	-32(%rbp), %rax
	movq	-88(%rbp), %rcx
	movl	%edx, %esi
	movq	%rax, %rdi
	call	*%rcx
	movq	%xmm0, %rax
	movq	%rax, (%rbx)
	movl	-56(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movsd	(%rax), %xmm0
	movsd	-48(%rbp), %xmm1
	addsd	%xmm1, %xmm0
	movsd	%xmm0, -48(%rbp)
	addl	$1, -56(%rbp)
.L148:
	cmpl	$199, -56(%rbp)
	jle	.L151
	movsd	-48(%rbp), %xmm0
	movsd	.LC3(%rip), %xmm1
	divsd	%xmm1, %xmm0
	movsd	%xmm0, -48(%rbp)
	movl	$0, -56(%rbp)
	jmp	.L152
.L153:
	movl	-56(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movsd	(%rax), %xmm0
	movapd	%xmm0, %xmm1
	subsd	-48(%rbp), %xmm1
	movl	-56(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movsd	(%rax), %xmm0
	subsd	-48(%rbp), %xmm0
	mulsd	%xmm1, %xmm0
	movsd	-40(%rbp), %xmm1
	addsd	%xmm1, %xmm0
	movsd	%xmm0, -40(%rbp)
	addl	$1, -56(%rbp)
.L152:
	cmpl	$199, -56(%rbp)
	jle	.L153
	movsd	-40(%rbp), %xmm0
	movsd	.LC4(%rip), %xmm1
	divsd	%xmm1, %xmm0
	movsd	%xmm0, -40(%rbp)
	movq	-32(%rbp), %rax
	movq	%rax, %rdi
	call	free@PLT
	movq	-24(%rbp), %rax
	movq	%rax, %rdi
	call	free@PLT
	movq	-40(%rbp), %rax
	movq	%rax, %xmm0
	call	sqrt@PLT
	movq	%xmm0, %rax
	movq	%rax, %xmm0
	movq	-8(%rbp), %rbx
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE40:
	.size	double_bootstrap_stderr, .-double_bootstrap_stderr
	.globl	regression
	.type	regression, @function
regression:
.LFB41:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	addq	$-128, %rsp
	movq	%rdi, -88(%rbp)
	movq	%rsi, -96(%rbp)
	movq	%rdx, -104(%rbp)
	movl	%ecx, -108(%rbp)
	movq	%r8, -120(%rbp)
	movq	%r9, -128(%rbp)
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -64(%rbp)
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -56(%rbp)
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -48(%rbp)
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -40(%rbp)
	movl	$0, -68(%rbp)
	jmp	.L156
.L159:
	cmpq	$0, -104(%rbp)
	je	.L157
	movl	-68(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-104(%rbp), %rax
	addq	%rdx, %rax
	movsd	(%rax), %xmm1
	movl	-68(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-104(%rbp), %rax
	addq	%rdx, %rax
	movsd	(%rax), %xmm0
	mulsd	%xmm1, %xmm0
	jmp	.L158
.L157:
	movsd	.LC5(%rip), %xmm0
.L158:
	movsd	.LC5(%rip), %xmm1
	divsd	%xmm0, %xmm1
	movsd	%xmm1, -8(%rbp)
	movsd	-64(%rbp), %xmm0
	addsd	-8(%rbp), %xmm0
	movsd	%xmm0, -64(%rbp)
	movl	-68(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-88(%rbp), %rax
	addq	%rdx, %rax
	movsd	(%rax), %xmm0
	mulsd	-8(%rbp), %xmm0
	movsd	-56(%rbp), %xmm1
	addsd	%xmm1, %xmm0
	movsd	%xmm0, -56(%rbp)
	movl	-68(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-96(%rbp), %rax
	addq	%rdx, %rax
	movsd	(%rax), %xmm0
	mulsd	-8(%rbp), %xmm0
	movsd	-48(%rbp), %xmm1
	addsd	%xmm1, %xmm0
	movsd	%xmm0, -48(%rbp)
	addl	$1, -68(%rbp)
.L156:
	movl	-68(%rbp), %eax
	cmpl	-108(%rbp), %eax
	jl	.L159
	movq	-128(%rbp), %rax
	pxor	%xmm0, %xmm0
	movsd	%xmm0, (%rax)
	movsd	-56(%rbp), %xmm0
	divsd	-64(%rbp), %xmm0
	movsd	%xmm0, -32(%rbp)
	movl	$0, -68(%rbp)
	jmp	.L160
.L165:
	movl	-68(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-88(%rbp), %rax
	addq	%rdx, %rax
	movsd	(%rax), %xmm0
	movapd	%xmm0, %xmm1
	subsd	-32(%rbp), %xmm1
	cmpq	$0, -104(%rbp)
	je	.L161
	movl	-68(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-104(%rbp), %rax
	addq	%rdx, %rax
	movsd	(%rax), %xmm0
	jmp	.L162
.L161:
	movsd	.LC5(%rip), %xmm0
.L162:
	divsd	%xmm0, %xmm1
	movsd	%xmm1, -16(%rbp)
	movsd	-16(%rbp), %xmm0
	mulsd	%xmm0, %xmm0
	movsd	-40(%rbp), %xmm1
	addsd	%xmm1, %xmm0
	movsd	%xmm0, -40(%rbp)
	movq	-128(%rbp), %rax
	movsd	(%rax), %xmm2
	movl	-68(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-96(%rbp), %rax
	addq	%rdx, %rax
	movsd	(%rax), %xmm0
	movapd	%xmm0, %xmm1
	mulsd	-16(%rbp), %xmm1
	cmpq	$0, -104(%rbp)
	je	.L163
	movl	-68(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-104(%rbp), %rax
	addq	%rdx, %rax
	movsd	(%rax), %xmm0
	jmp	.L164
.L163:
	movsd	.LC5(%rip), %xmm0
.L164:
	divsd	%xmm0, %xmm1
	addsd	%xmm1, %xmm2
	movapd	%xmm2, %xmm0
	movq	-128(%rbp), %rax
	movsd	%xmm0, (%rax)
	addl	$1, -68(%rbp)
.L160:
	movl	-68(%rbp), %eax
	cmpl	-108(%rbp), %eax
	jl	.L165
	movq	-128(%rbp), %rax
	movsd	(%rax), %xmm0
	divsd	-40(%rbp), %xmm0
	movq	-128(%rbp), %rax
	movsd	%xmm0, (%rax)
	movq	-128(%rbp), %rax
	movsd	(%rax), %xmm0
	movapd	%xmm0, %xmm1
	mulsd	-56(%rbp), %xmm1
	movsd	-48(%rbp), %xmm0
	subsd	%xmm1, %xmm0
	divsd	-64(%rbp), %xmm0
	movq	-120(%rbp), %rax
	movsd	%xmm0, (%rax)
	movsd	-56(%rbp), %xmm0
	mulsd	%xmm0, %xmm0
	movsd	-64(%rbp), %xmm1
	movapd	%xmm1, %xmm2
	mulsd	-40(%rbp), %xmm2
	movapd	%xmm0, %xmm1
	divsd	%xmm2, %xmm1
	movsd	.LC5(%rip), %xmm0
	addsd	%xmm1, %xmm0
	divsd	-64(%rbp), %xmm0
	movq	%xmm0, %rax
	movq	%rax, %xmm0
	call	sqrt@PLT
	movq	%xmm0, %rax
	movq	16(%rbp), %rdx
	movq	%rax, (%rdx)
	movsd	.LC5(%rip), %xmm0
	divsd	-40(%rbp), %xmm0
	movq	%xmm0, %rax
	movq	%rax, %xmm0
	call	sqrt@PLT
	movq	%xmm0, %rax
	movq	24(%rbp), %rdx
	movq	%rax, (%rdx)
	movq	32(%rbp), %rax
	pxor	%xmm0, %xmm0
	movsd	%xmm0, (%rax)
	movl	$0, -68(%rbp)
	jmp	.L166
.L169:
	movl	-68(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-96(%rbp), %rax
	addq	%rdx, %rax
	movsd	(%rax), %xmm0
	movq	-120(%rbp), %rax
	movsd	(%rax), %xmm2
	movq	-128(%rbp), %rax
	movsd	(%rax), %xmm3
	movl	-68(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-88(%rbp), %rax
	addq	%rdx, %rax
	movsd	(%rax), %xmm1
	mulsd	%xmm3, %xmm1
	addsd	%xmm1, %xmm2
	movapd	%xmm0, %xmm1
	subsd	%xmm2, %xmm1
	cmpq	$0, -104(%rbp)
	je	.L167
	movl	-68(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-104(%rbp), %rax
	addq	%rdx, %rax
	movsd	(%rax), %xmm0
	jmp	.L168
.L167:
	movsd	.LC5(%rip), %xmm0
.L168:
	divsd	%xmm0, %xmm1
	movsd	%xmm1, -24(%rbp)
	movq	32(%rbp), %rax
	movsd	(%rax), %xmm1
	movsd	-24(%rbp), %xmm0
	mulsd	%xmm0, %xmm0
	addsd	%xmm1, %xmm0
	movq	32(%rbp), %rax
	movsd	%xmm0, (%rax)
	addl	$1, -68(%rbp)
.L166:
	movl	-68(%rbp), %eax
	cmpl	-108(%rbp), %eax
	jl	.L169
	cmpq	$0, -104(%rbp)
	jne	.L171
	movq	32(%rbp), %rax
	movsd	(%rax), %xmm0
	movl	-108(%rbp), %eax
	subl	$2, %eax
	pxor	%xmm1, %xmm1
	cvtsi2sdl	%eax, %xmm1
	divsd	%xmm1, %xmm0
	movq	%xmm0, %rax
	movq	%rax, %xmm0
	call	sqrt@PLT
	movq	16(%rbp), %rax
	movsd	(%rax), %xmm1
	mulsd	%xmm1, %xmm0
	movq	16(%rbp), %rax
	movsd	%xmm0, (%rax)
	movq	32(%rbp), %rax
	movsd	(%rax), %xmm0
	movl	-108(%rbp), %eax
	subl	$2, %eax
	pxor	%xmm1, %xmm1
	cvtsi2sdl	%eax, %xmm1
	divsd	%xmm1, %xmm0
	movq	%xmm0, %rax
	movq	%rax, %xmm0
	call	sqrt@PLT
	movq	24(%rbp), %rax
	movsd	(%rax), %xmm1
	mulsd	%xmm1, %xmm0
	movq	24(%rbp), %rax
	movsd	%xmm0, (%rax)
.L171:
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE41:
	.size	regression, .-regression
	.section	.rodata
	.align 8
.LC1:
	.long	0
	.long	1073741824
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
