	.file	"lat_pmake.c"
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
	.string	"[-P <parallelism>] [-W <warmup>] [-N <repetitions>] Njobs usecs...\n"
.LC2:
	.string	"P:W:N:"
.LC3:
	.string	"\"pmake jobs=%d\n"
.LC5:
	.string	"%llu %.2f\n"
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
	pushq	%rbx
	subq	$1160, %rsp
	.cfi_offset 3, -24
	movl	%edi, -1156(%rbp)
	movq	%rsi, -1168(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -24(%rbp)
	xorl	%eax, %eax
	movl	$1, -1144(%rbp)
	movl	$0, -1140(%rbp)
	movl	$-1, -1136(%rbp)
	leaq	.LC1(%rip), %rax
	movq	%rax, -1128(%rbp)
	jmp	.L2
.L7:
	cmpl	$87, -1132(%rbp)
	je	.L3
	cmpl	$87, -1132(%rbp)
	jg	.L4
	cmpl	$78, -1132(%rbp)
	je	.L5
	cmpl	$80, -1132(%rbp)
	jne	.L4
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -1144(%rbp)
	cmpl	$0, -1144(%rbp)
	jg	.L2
	movq	-1128(%rbp), %rdx
	movq	-1168(%rbp), %rcx
	movl	-1156(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	lmbench_usage@PLT
	jmp	.L2
.L3:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -1140(%rbp)
	jmp	.L2
.L5:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -1136(%rbp)
	jmp	.L2
.L4:
	movq	-1128(%rbp), %rdx
	movq	-1168(%rbp), %rcx
	movl	-1156(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	lmbench_usage@PLT
	nop
.L2:
	movq	-1168(%rbp), %rcx
	movl	-1156(%rbp), %eax
	leaq	.LC2(%rip), %rdx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	mygetopt@PLT
	movl	%eax, -1132(%rbp)
	cmpl	$-1, -1132(%rbp)
	jne	.L7
	movl	myoptind(%rip), %eax
	addl	$1, %eax
	cmpl	%eax, -1156(%rbp)
	jg	.L8
	movq	-1128(%rbp), %rdx
	movq	-1168(%rbp), %rcx
	movl	-1156(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	lmbench_usage@PLT
.L8:
	movl	myoptind(%rip), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-1168(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -1104(%rbp)
	movq	$0, -1072(%rbp)
	movl	-1104(%rbp), %edx
	movq	stderr(%rip), %rax
	leaq	.LC3(%rip), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf@PLT
	jmp	.L9
.L16:
	movl	myoptind(%rip), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-1168(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	bytes@PLT
	movq	%rax, -1120(%rbp)
	leaq	-1104(%rbp), %rax
	pushq	%rax
	pushq	$11
	movl	$0, %r9d
	movl	$1, %r8d
	movl	$0, %ecx
	movl	$0, %edx
	leaq	work(%rip), %rax
	movq	%rax, %rsi
	leaq	setup(%rip), %rax
	movq	%rax, %rdi
	call	benchmp@PLT
	addq	$16, %rsp
	call	usecs_spent@PLT
	testq	%rax, %rax
	jne	.L10
	movl	$1, %edi
	call	exit@PLT
.L10:
	call	get_n@PLT
	imulq	-1120(%rbp), %rax
	movq	%rax, %rbx
	call	usecs_spent@PLT
	movq	%rax, %rsi
	movq	%rbx, %rax
	movl	$0, %edx
	divq	%rsi
	movq	%rax, -1096(%rbp)
	movl	-1140(%rbp), %ecx
	movl	-1144(%rbp), %edx
	leaq	-1104(%rbp), %rax
	pushq	%rax
	movl	-1136(%rbp), %eax
	pushq	%rax
	movl	%ecx, %r9d
	movl	%edx, %r8d
	movl	$0, %ecx
	movl	$0, %edx
	leaq	bench(%rip), %rax
	movq	%rax, %rsi
	leaq	setup(%rip), %rax
	movq	%rax, %rdi
	call	benchmp@PLT
	addq	$16, %rsp
	call	usecs_spent@PLT
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
	movsd	%xmm0, -1112(%rbp)
	call	get_n@PLT
	testq	%rax, %rax
	js	.L13
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L14
.L13:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L14:
	movsd	-1112(%rbp), %xmm1
	divsd	%xmm0, %xmm1
	movsd	%xmm1, -1112(%rbp)
	movsd	-1112(%rbp), %xmm0
	pxor	%xmm1, %xmm1
	comisd	%xmm1, %xmm0
	ja	.L19
	jmp	.L9
.L19:
	movq	stderr(%rip), %rax
	movq	-1112(%rbp), %rcx
	movq	-1120(%rbp), %rdx
	movq	%rcx, %xmm0
	leaq	.LC5(%rip), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	movl	$1, %eax
	call	fprintf@PLT
.L9:
	movl	myoptind(%rip), %eax
	addl	$1, %eax
	movl	%eax, myoptind(%rip)
	movl	myoptind(%rip), %eax
	cmpl	%eax, -1156(%rbp)
	jg	.L16
	movl	$0, %eax
	movq	-24(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L18
	call	__stack_chk_fail@PLT
.L18:
	movq	-8(%rbp), %rbx
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE8:
	.size	main, .-main
	.section	.rodata
.LC6:
	.string	"malloc"
	.text
	.globl	setup
	.type	setup, @function
setup:
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
	jne	.L24
	movl	$8, %edi
	call	malloc@PLT
	movq	%rax, %rdx
	movq	-24(%rbp), %rax
	movq	%rdx, 16(%rax)
	movq	-24(%rbp), %rax
	movq	16(%rax), %rax
	testq	%rax, %rax
	jne	.L23
	leaq	.LC6(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L23:
	movq	-24(%rbp), %rax
	movq	16(%rax), %rax
	movq	-24(%rbp), %rdx
	movq	16(%rdx), %rdx
	movq	%rdx, (%rax)
	movq	-24(%rbp), %rax
	movq	16(%rax), %rdx
	movq	-24(%rbp), %rax
	movq	%rdx, 24(%rax)
	movq	-24(%rbp), %rax
	movl	(%rax), %ebx
	movl	$0, %eax
	call	benchmp_childid@PLT
	movl	%ebx, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	handle_scheduler@PLT
	jmp	.L20
.L24:
	nop
.L20:
	movq	-8(%rbp), %rbx
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE9:
	.size	setup, .-setup
	.globl	bench
	.type	bench, @function
bench:
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
	subq	$48, %rsp
	.cfi_offset 12, -24
	.cfi_offset 3, -32
	movq	%rdi, %rbx
	movq	%rsi, -56(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -24(%rbp)
	xorl	%eax, %eax
	movq	-56(%rbp), %rax
	movq	%rax, -32(%rbp)
	movq	-32(%rbp), %rax
	movl	(%rax), %eax
	cltq
	salq	$2, %rax
	movq	%rax, %rdi
	call	malloc@PLT
	movq	%rax, %rdx
	movq	-32(%rbp), %rax
	movq	%rdx, 32(%rax)
	movq	-32(%rbp), %rax
	movq	32(%rax), %rax
	testq	%rax, %rax
	jne	.L27
	leaq	.LC6(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$2, %edi
	call	exit@PLT
.L34:
	movl	$0, -36(%rbp)
	jmp	.L28
.L30:
	movq	-32(%rbp), %rax
	movq	32(%rax), %rdx
	movl	-36(%rbp), %eax
	cltq
	salq	$2, %rax
	leaq	(%rdx,%rax), %r12
	call	fork@PLT
	movl	%eax, (%r12)
	movl	(%r12), %eax
	testl	%eax, %eax
	jne	.L29
	movq	-32(%rbp), %rax
	movl	(%rax), %ebx
	movl	-36(%rbp), %eax
	leal	1(%rax), %r12d
	movl	$0, %eax
	call	benchmp_childid@PLT
	movl	%ebx, %edx
	movl	%r12d, %esi
	movl	%eax, %edi
	call	handle_scheduler@PLT
	movq	-32(%rbp), %rax
	movq	8(%rax), %rax
	movq	-32(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	work
	movl	$0, %edi
	call	exit@PLT
.L29:
	addl	$1, -36(%rbp)
.L28:
	movq	-32(%rbp), %rax
	movl	(%rax), %eax
	cmpl	%eax, -36(%rbp)
	jl	.L30
	movl	$0, -36(%rbp)
	jmp	.L31
.L33:
	movq	-32(%rbp), %rax
	movq	32(%rax), %rdx
	movl	-36(%rbp), %eax
	cltq
	salq	$2, %rax
	addq	%rdx, %rax
	movl	(%rax), %eax
	leaq	-40(%rbp), %rcx
	movl	$0, %edx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	waitpid@PLT
	movq	-32(%rbp), %rax
	movq	32(%rax), %rdx
	movl	-36(%rbp), %eax
	cltq
	salq	$2, %rax
	addq	%rdx, %rax
	movl	$-1, (%rax)
	movl	-40(%rbp), %eax
	andl	$127, %eax
	testl	%eax, %eax
	je	.L32
	movq	-56(%rbp), %rax
	movq	%rax, %rsi
	movl	$0, %edi
	call	cleanup
	movl	$1, %edi
	call	exit@PLT
.L32:
	addl	$1, -36(%rbp)
.L31:
	movq	-32(%rbp), %rax
	movl	(%rax), %eax
	cmpl	%eax, -36(%rbp)
	jl	.L33
.L27:
	movq	%rbx, %rax
	leaq	-1(%rax), %rbx
	testq	%rax, %rax
	jne	.L34
	nop
	movq	-24(%rbp), %rax
	subq	%fs:40, %rax
	je	.L35
	call	__stack_chk_fail@PLT
.L35:
	addq	$48, %rsp
	popq	%rbx
	popq	%r12
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE10:
	.size	bench, .-bench
	.globl	cleanup
	.type	cleanup, @function
cleanup:
.LFB11:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%rsi, -24(%rbp)
	movq	-24(%rbp), %rax
	movq	%rax, -8(%rbp)
	movl	$0, -12(%rbp)
	jmp	.L37
.L39:
	movq	-8(%rbp), %rax
	movq	32(%rax), %rdx
	movl	-12(%rbp), %eax
	cltq
	salq	$2, %rax
	addq	%rdx, %rax
	movl	(%rax), %eax
	testl	%eax, %eax
	jle	.L38
	movq	-8(%rbp), %rax
	movq	32(%rax), %rdx
	movl	-12(%rbp), %eax
	cltq
	salq	$2, %rax
	addq	%rdx, %rax
	movl	(%rax), %eax
	movl	$9, %esi
	movl	%eax, %edi
	call	kill@PLT
	movq	-8(%rbp), %rax
	movq	32(%rax), %rdx
	movl	-12(%rbp), %eax
	cltq
	salq	$2, %rax
	addq	%rdx, %rax
	movl	(%rax), %eax
	movl	$0, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	waitpid@PLT
	movq	-8(%rbp), %rax
	movq	32(%rax), %rdx
	movl	-12(%rbp), %eax
	cltq
	salq	$2, %rax
	addq	%rdx, %rax
	movl	$-1, (%rax)
.L38:
	addl	$1, -12(%rbp)
.L37:
	movq	-8(%rbp), %rax
	movl	(%rax), %eax
	cmpl	%eax, -12(%rbp)
	jl	.L39
	nop
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE11:
	.size	cleanup, .-cleanup
	.globl	work
	.type	work, @function
work:
.LFB12:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%rbx
	.cfi_offset 3, -24
	movq	%rdi, %rax
	movq	%rsi, -32(%rbp)
	movq	-32(%rbp), %rdx
	movq	%rdx, -16(%rbp)
	movq	-16(%rbp), %rdx
	movq	24(%rdx), %rbx
	jmp	.L41
.L42:
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
.L41:
	movq	%rax, %rdx
	leaq	-1(%rdx), %rax
	testq	%rdx, %rdx
	jne	.L42
	movq	-16(%rbp), %rax
	movq	%rbx, 24(%rax)
	nop
	movq	-8(%rbp), %rbx
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE12:
	.size	work, .-work
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
