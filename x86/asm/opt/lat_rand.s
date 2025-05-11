	.file	"lat_rand.c"
	.text
	.globl	bench_drand48
	.type	bench_drand48, @function
bench_drand48:
.LFB73:
	.cfi_startproc
	endbr64
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	subq	$16, %rsp
	.cfi_def_cfa_offset 32
	testq	%rdi, %rdi
	je	.L4
	leaq	-1(%rdi), %rbx
	pxor	%xmm2, %xmm2
	movsd	%xmm2, 8(%rsp)
.L3:
	call	drand48@PLT
	addsd	8(%rsp), %xmm0
	movsd	%xmm0, 8(%rsp)
	subq	$1, %rbx
	cmpq	$-1, %rbx
	jne	.L3
.L2:
	cvttsd2sil	8(%rsp), %edi
	call	use_int@PLT
	addq	$16, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 16
	popq	%rbx
	.cfi_def_cfa_offset 8
	ret
.L4:
	.cfi_restore_state
	pxor	%xmm3, %xmm3
	movsd	%xmm3, 8(%rsp)
	jmp	.L2
	.cfi_endproc
.LFE73:
	.size	bench_drand48, .-bench_drand48
	.globl	bench_lrand48
	.type	bench_lrand48, @function
bench_lrand48:
.LFB74:
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
	testq	%rdi, %rdi
	je	.L10
	leaq	-1(%rdi), %rbx
	movl	$0, %ebp
.L9:
	call	lrand48@PLT
	addq	%rax, %rbp
	subq	$1, %rbx
	cmpq	$-1, %rbx
	jne	.L9
.L8:
	movl	%ebp, %edi
	call	use_int@PLT
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
.L10:
	.cfi_restore_state
	movl	$0, %ebp
	jmp	.L8
	.cfi_endproc
.LFE74:
	.size	bench_lrand48, .-bench_lrand48
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC1:
	.string	"[-P <parallelism>] [-W <warmup>] [-N <repetitions>]\n"
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC2:
	.string	"P:W:N:"
.LC3:
	.string	"drand48 latency"
.LC4:
	.string	"lrand48 latency"
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
	subq	$24, %rsp
	.cfi_def_cfa_offset 80
	movl	%edi, %ebx
	movq	%rsi, %rbp
	movl	$-1, %r14d
	movl	$0, %r13d
	movl	$1, 12(%rsp)
	leaq	.LC2(%rip), %r12
	leaq	.LC1(%rip), %r15
	jmp	.L14
.L15:
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	movl	%eax, 12(%rsp)
	testl	%eax, %eax
	jg	.L14
	movq	%r15, %rdx
	movq	%rbp, %rsi
	movl	%ebx, %edi
	call	lmbench_usage@PLT
	jmp	.L14
.L16:
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	movl	%eax, %r13d
.L14:
	movq	%r12, %rdx
	movq	%rbp, %rsi
	movl	%ebx, %edi
	call	mygetopt@PLT
	cmpl	$-1, %eax
	je	.L24
	cmpl	$80, %eax
	je	.L15
	cmpl	$87, %eax
	je	.L16
	cmpl	$78, %eax
	je	.L25
	movq	%r15, %rdx
	movq	%rbp, %rsi
	movl	%ebx, %edi
	call	lmbench_usage@PLT
	jmp	.L14
.L25:
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	movl	%eax, %r14d
	jmp	.L14
.L24:
	cmpl	%ebx, myoptind(%rip)
	jl	.L26
.L21:
	pushq	$0
	.cfi_def_cfa_offset 88
	pushq	%r14
	.cfi_def_cfa_offset 96
	movl	%r13d, %r9d
	movl	28(%rsp), %ebx
	movl	%ebx, %r8d
	movl	$0, %ecx
	movl	$0, %edx
	leaq	bench_drand48(%rip), %rsi
	movl	$0, %edi
	call	benchmp@PLT
	call	get_n@PLT
	movq	%rax, %rsi
	leaq	.LC3(%rip), %rdi
	call	nano@PLT
	pushq	$0
	.cfi_def_cfa_offset 104
	pushq	%r14
	.cfi_def_cfa_offset 112
	movl	%r13d, %r9d
	movl	%ebx, %r8d
	movl	$0, %ecx
	movl	$0, %edx
	leaq	bench_lrand48(%rip), %rsi
	movl	$0, %edi
	call	benchmp@PLT
	addq	$32, %rsp
	.cfi_def_cfa_offset 80
	call	get_n@PLT
	movq	%rax, %rsi
	leaq	.LC4(%rip), %rdi
	call	nano@PLT
	movl	$0, %eax
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
.L26:
	.cfi_restore_state
	leaq	.LC1(%rip), %rdx
	movq	%rbp, %rsi
	movl	%ebx, %edi
	call	lmbench_usage@PLT
	jmp	.L21
	.cfi_endproc
.LFE72:
	.size	main, .-main
	.globl	id
	.section	.rodata.str1.1
.LC5:
	.string	"$Id$\n"
	.section	.data.rel.local,"aw"
	.align 8
	.type	id, @object
	.size	id, 8
id:
	.quad	.LC5
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
