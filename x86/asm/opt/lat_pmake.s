	.file	"lat_pmake.c"
	.text
	.globl	work
	.type	work, @function
work:
.LFB76:
	.cfi_startproc
	endbr64
	movq	24(%rsi), %rdx
	leaq	-1(%rdi), %rax
	testq	%rdi, %rdi
	je	.L2
.L3:
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
	subq	$1, %rax
	cmpq	$-1, %rax
	jne	.L3
.L2:
	movq	%rdx, 24(%rsi)
	ret
	.cfi_endproc
.LFE76:
	.size	work, .-work
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"malloc"
	.text
	.globl	setup
	.type	setup, @function
setup:
.LFB73:
	.cfi_startproc
	endbr64
	testq	%rdi, %rdi
	je	.L12
	ret
.L12:
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movq	%rsi, %rbx
	movl	$8, %edi
	call	malloc@PLT
	movq	%rax, 16(%rbx)
	testq	%rax, %rax
	je	.L13
	movq	%rax, (%rax)
	movq	%rax, 24(%rbx)
	movl	(%rbx), %ebx
	movl	$0, %eax
	call	benchmp_childid@PLT
	movl	%eax, %edi
	movl	%ebx, %edx
	movl	$0, %esi
	call	handle_scheduler@PLT
	popq	%rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	ret
.L13:
	.cfi_restore_state
	leaq	.LC0(%rip), %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
	.cfi_endproc
.LFE73:
	.size	setup, .-setup
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC1:
	.string	"[-P <parallelism>] [-W <warmup>] [-N <repetitions>] Njobs usecs...\n"
	.section	.rodata.str1.1
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
.LFB72:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$72, %rsp
	.cfi_offset 15, -24
	.cfi_offset 14, -32
	.cfi_offset 13, -40
	.cfi_offset 12, -48
	.cfi_offset 3, -56
	movl	%edi, %r13d
	movq	%rsi, %r14
	movq	%fs:40, %rax
	movq	%rax, -56(%rbp)
	xorl	%eax, %eax
	movl	$-1, %r15d
	movl	$0, -108(%rbp)
	movl	$1, -112(%rbp)
	leaq	.LC2(%rip), %rbx
	jmp	.L15
.L16:
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	movl	%eax, -112(%rbp)
	testl	%eax, %eax
	jg	.L15
	leaq	.LC1(%rip), %rdx
	movq	%r14, %rsi
	movl	%r13d, %edi
	call	lmbench_usage@PLT
	jmp	.L15
.L17:
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	movl	%eax, -108(%rbp)
.L15:
	movq	%rbx, %rdx
	movq	%r14, %rsi
	movl	%r13d, %edi
	call	mygetopt@PLT
	cmpl	$-1, %eax
	je	.L36
	cmpl	$80, %eax
	je	.L16
	cmpl	$87, %eax
	je	.L17
	cmpl	$78, %eax
	je	.L37
	leaq	.LC1(%rip), %rdx
	movq	%r14, %rsi
	movl	%r13d, %edi
	call	lmbench_usage@PLT
	jmp	.L15
.L37:
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	movl	%eax, %r15d
	jmp	.L15
.L36:
	movl	myoptind(%rip), %eax
	addl	$1, %eax
	cmpl	%r13d, %eax
	jge	.L38
.L22:
	movslq	myoptind(%rip), %rax
	movq	(%r14,%rax,8), %rdi
	movl	$10, %edx
	movl	$0, %esi
	call	strtol@PLT
	movl	%eax, %ecx
	movl	%eax, -96(%rbp)
	movq	$0, -64(%rbp)
	leaq	.LC3(%rip), %rdx
	movl	$1, %esi
	movq	stderr(%rip), %rdi
	movl	$0, %eax
	call	__fprintf_chk@PLT
	leaq	setup(%rip), %r12
	jmp	.L29
.L38:
	leaq	.LC1(%rip), %rdx
	movq	%r14, %rsi
	movl	%r13d, %edi
	call	lmbench_usage@PLT
	jmp	.L22
.L41:
	movl	$1, %edi
	call	exit@PLT
.L25:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
	movq	%xmm0, %rbx
	jmp	.L26
.L27:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rdx, %xmm1
	addsd	%xmm1, %xmm1
.L28:
	movq	%rbx, %xmm0
	divsd	%xmm1, %xmm0
	addq	$16, %rsp
	comisd	.LC4(%rip), %xmm0
	ja	.L39
.L29:
	movl	myoptind(%rip), %eax
	addl	$1, %eax
	movl	%eax, myoptind(%rip)
	cmpl	%r13d, %eax
	jge	.L40
	cltq
	movq	(%r14,%rax,8), %rdi
	call	bytes@PLT
	movq	%rax, -104(%rbp)
	leaq	-96(%rbp), %rax
	pushq	%rax
	pushq	$11
	movl	$0, %r9d
	movl	$1, %r8d
	movl	$0, %ecx
	movl	$0, %edx
	leaq	work(%rip), %rsi
	movq	%r12, %rdi
	call	benchmp@PLT
	call	usecs_spent@PLT
	addq	$16, %rsp
	testq	%rax, %rax
	je	.L41
	call	get_n@PLT
	imulq	-104(%rbp), %rax
	movq	%rax, %rbx
	call	usecs_spent@PLT
	movq	%rax, %rcx
	movq	%rbx, %rax
	movl	$0, %edx
	divq	%rcx
	movq	%rax, -88(%rbp)
	leaq	-96(%rbp), %rax
	pushq	%rax
	pushq	%r15
	movl	-108(%rbp), %r9d
	movl	-112(%rbp), %r8d
	movl	$0, %ecx
	movl	$0, %edx
	leaq	bench(%rip), %rsi
	movq	%r12, %rdi
	call	benchmp@PLT
	call	usecs_spent@PLT
	testq	%rax, %rax
	js	.L25
	pxor	%xmm2, %xmm2
	cvtsi2sdq	%rax, %xmm2
	movq	%xmm2, %rbx
.L26:
	call	get_n@PLT
	testq	%rax, %rax
	js	.L27
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rax, %xmm1
	jmp	.L28
.L39:
	movq	-104(%rbp), %rcx
	leaq	.LC5(%rip), %rdx
	movl	$1, %esi
	movq	stderr(%rip), %rdi
	movl	$1, %eax
	call	__fprintf_chk@PLT
	jmp	.L29
.L40:
	movq	-56(%rbp), %rax
	subq	%fs:40, %rax
	jne	.L42
	movl	$0, %eax
	leaq	-40(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_remember_state
	.cfi_def_cfa 7, 8
	ret
.L42:
	.cfi_restore_state
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE72:
	.size	main, .-main
	.globl	cleanup
	.type	cleanup, @function
cleanup:
.LFB75:
	.cfi_startproc
	endbr64
	cmpl	$0, (%rsi)
	jle	.L49
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushq	%rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	subq	$8, %rsp
	.cfi_def_cfa_offset 32
	movq	%rsi, %rbp
	movl	$0, %ebx
	jmp	.L46
.L45:
	addq	$1, %rbx
	cmpl	%ebx, 0(%rbp)
	jle	.L52
.L46:
	movq	32(%rbp), %rax
	movl	(%rax,%rbx,4), %edi
	testl	%edi, %edi
	jle	.L45
	movl	$9, %esi
	call	kill@PLT
	movq	32(%rbp), %rax
	movl	(%rax,%rbx,4), %edi
	movl	$0, %edx
	movl	$0, %esi
	call	waitpid@PLT
	movq	32(%rbp), %rax
	movl	$-1, (%rax,%rbx,4)
	jmp	.L45
.L52:
	addq	$8, %rsp
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
.L49:
	.cfi_restore 3
	.cfi_restore 6
	ret
	.cfi_endproc
.LFE75:
	.size	cleanup, .-cleanup
	.globl	bench
	.type	bench, @function
bench:
.LFB74:
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
	movq	%rdi, %rbp
	movq	%rsi, %rbx
	movq	%fs:40, %rax
	movq	%rax, 8(%rsp)
	xorl	%eax, %eax
	movslq	(%rsi), %rdi
	salq	$2, %rdi
	call	malloc@PLT
	movq	%rax, 32(%rbx)
	testq	%rax, %rax
	je	.L54
	leaq	-1(%rbp), %r14
	leaq	4(%rsp), %r13
	testq	%rbp, %rbp
	je	.L53
.L55:
	movl	$0, %ebp
	cmpl	$0, (%rbx)
	jle	.L59
.L58:
	movl	%ebp, %r15d
	movq	32(%rbx), %rax
	leaq	(%rax,%rbp,4), %r12
	call	fork@PLT
	movl	%eax, (%r12)
	testl	%eax, %eax
	je	.L69
	movl	(%rbx), %eax
	addq	$1, %rbp
	cmpl	%ebp, %eax
	jg	.L58
	testl	%eax, %eax
	jle	.L59
	movl	$0, %ebp
.L61:
	movq	32(%rbx), %rax
	movl	(%rax,%rbp,4), %edi
	movl	$0, %edx
	movq	%r13, %rsi
	call	waitpid@PLT
	movq	32(%rbx), %rax
	movl	$-1, (%rax,%rbp,4)
	testb	$127, 4(%rsp)
	jne	.L70
	addq	$1, %rbp
	cmpl	%ebp, (%rbx)
	jg	.L61
.L59:
	subq	$1, %r14
	cmpq	$-1, %r14
	jne	.L55
.L53:
	movq	8(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L71
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
.L54:
	.cfi_restore_state
	leaq	.LC0(%rip), %rdi
	call	perror@PLT
	movl	$2, %edi
	call	exit@PLT
.L69:
	movl	(%rbx), %ebp
	call	benchmp_childid@PLT
	movl	%eax, %edi
	leal	1(%r15), %esi
	movl	%ebp, %edx
	call	handle_scheduler@PLT
	movq	8(%rbx), %rdi
	movq	%rbx, %rsi
	call	work
	movl	$0, %edi
	call	exit@PLT
.L70:
	movq	%rbx, %rsi
	movl	$0, %edi
	call	cleanup
	movl	$1, %edi
	call	exit@PLT
.L71:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE74:
	.size	bench, .-bench
	.globl	id
	.section	.rodata.str1.1
.LC6:
	.string	"$Id$\n"
	.section	.data.rel.local,"aw"
	.align 8
	.type	id, @object
	.size	id, 8
id:
	.quad	.LC6
	.section	.rodata.cst8,"aM",@progbits,8
	.align 8
.LC4:
	.long	0
	.long	0
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
