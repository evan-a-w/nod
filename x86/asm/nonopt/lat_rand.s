	.file	"lat_rand.c"
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
	.string	"[-P <parallelism>] [-W <warmup>] [-N <repetitions>]\n"
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
.LFB8:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$48, %rsp
	movl	%edi, -36(%rbp)
	movq	%rsi, -48(%rbp)
	movl	$1, -24(%rbp)
	movl	$0, -20(%rbp)
	movl	$-1, -16(%rbp)
	leaq	.LC1(%rip), %rax
	movq	%rax, -8(%rbp)
	jmp	.L2
.L7:
	cmpl	$87, -12(%rbp)
	je	.L3
	cmpl	$87, -12(%rbp)
	jg	.L4
	cmpl	$78, -12(%rbp)
	je	.L5
	cmpl	$80, -12(%rbp)
	jne	.L4
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -24(%rbp)
	cmpl	$0, -24(%rbp)
	jg	.L2
	movq	-8(%rbp), %rdx
	movq	-48(%rbp), %rcx
	movl	-36(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	lmbench_usage@PLT
	jmp	.L2
.L3:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -20(%rbp)
	jmp	.L2
.L5:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -16(%rbp)
	jmp	.L2
.L4:
	movq	-8(%rbp), %rdx
	movq	-48(%rbp), %rcx
	movl	-36(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	lmbench_usage@PLT
	nop
.L2:
	movq	-48(%rbp), %rcx
	movl	-36(%rbp), %eax
	leaq	.LC2(%rip), %rdx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	mygetopt@PLT
	movl	%eax, -12(%rbp)
	cmpl	$-1, -12(%rbp)
	jne	.L7
	movl	myoptind(%rip), %eax
	cmpl	%eax, -36(%rbp)
	jle	.L8
	movq	-8(%rbp), %rdx
	movq	-48(%rbp), %rcx
	movl	-36(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	lmbench_usage@PLT
.L8:
	movl	-20(%rbp), %ecx
	movl	-24(%rbp), %edx
	pushq	$0
	movl	-16(%rbp), %eax
	pushq	%rax
	movl	%ecx, %r9d
	movl	%edx, %r8d
	movl	$0, %ecx
	movl	$0, %edx
	leaq	bench_drand48(%rip), %rax
	movq	%rax, %rsi
	movl	$0, %edi
	call	benchmp@PLT
	addq	$16, %rsp
	call	get_n@PLT
	movq	%rax, %rsi
	leaq	.LC3(%rip), %rax
	movq	%rax, %rdi
	call	nano@PLT
	movl	-20(%rbp), %ecx
	movl	-24(%rbp), %edx
	pushq	$0
	movl	-16(%rbp), %eax
	pushq	%rax
	movl	%ecx, %r9d
	movl	%edx, %r8d
	movl	$0, %ecx
	movl	$0, %edx
	leaq	bench_lrand48(%rip), %rax
	movq	%rax, %rsi
	movl	$0, %edi
	call	benchmp@PLT
	addq	$16, %rsp
	call	get_n@PLT
	movq	%rax, %rsi
	leaq	.LC4(%rip), %rax
	movq	%rax, %rdi
	call	nano@PLT
	movl	$0, %eax
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE8:
	.size	main, .-main
	.globl	bench_drand48
	.type	bench_drand48, @function
bench_drand48:
.LFB9:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%rbx
	subq	$24, %rsp
	.cfi_offset 3, -24
	movq	%rdi, %rbx
	movq	%rsi, -24(%rbp)
	pxor	%xmm1, %xmm1
	movsd	%xmm1, -32(%rbp)
	jmp	.L11
.L12:
	call	drand48@PLT
	addsd	-32(%rbp), %xmm0
	movsd	%xmm0, -32(%rbp)
.L11:
	movq	%rbx, %rax
	leaq	-1(%rax), %rbx
	testq	%rax, %rax
	jne	.L12
	cvttsd2sil	-32(%rbp), %eax
	movl	%eax, %edi
	call	use_int@PLT
	nop
	movq	-8(%rbp), %rbx
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE9:
	.size	bench_drand48, .-bench_drand48
	.globl	bench_lrand48
	.type	bench_lrand48, @function
bench_lrand48:
.LFB10:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r12
	pushq	%rbx
	subq	$16, %rsp
	.cfi_offset 12, -24
	.cfi_offset 3, -32
	movq	%rdi, %r12
	movq	%rsi, -24(%rbp)
	movl	$0, %ebx
	jmp	.L14
.L15:
	call	lrand48@PLT
	addq	%rax, %rbx
.L14:
	movq	%r12, %rax
	leaq	-1(%rax), %r12
	testq	%rax, %rax
	jne	.L15
	movl	%ebx, %eax
	movl	%eax, %edi
	call	use_int@PLT
	nop
	addq	$16, %rsp
	popq	%rbx
	popq	%r12
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE10:
	.size	bench_lrand48, .-bench_lrand48
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
