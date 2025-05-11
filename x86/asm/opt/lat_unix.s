	.file	"lat_unix.c"
	.text
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"socketpair"
.LC1:
	.string	"buffer allocation\n"
	.text
	.globl	initialize
	.type	initialize, @function
initialize:
.LFB73:
	.cfi_startproc
	endbr64
	testq	%rdi, %rdi
	je	.L11
	ret
.L11:
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movq	%rsi, %rbx
	movq	%rsi, %rcx
	movl	$0, %edx
	movl	$1, %esi
	movl	$1, %edi
	call	socketpair@PLT
	cmpl	$-1, %eax
	je	.L12
.L3:
	movslq	12(%rbx), %rdi
	call	malloc@PLT
	movq	%rax, 16(%rbx)
	testq	%rax, %rax
	je	.L13
	movl	$0, %eax
	call	benchmp_childid@PLT
	movl	%eax, %edi
	movl	$1, %edx
	movl	$0, %esi
	call	handle_scheduler@PLT
	call	fork@PLT
	movl	%eax, 8(%rbx)
	testl	%eax, %eax
	je	.L14
	popq	%rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	ret
.L12:
	.cfi_restore_state
	leaq	.LC0(%rip), %rdi
	call	perror@PLT
	jmp	.L3
.L13:
	movq	stderr(%rip), %rcx
	movl	$18, %edx
	movl	$1, %esi
	leaq	.LC1(%rip), %rdi
	call	fwrite@PLT
	movl	$1, %edi
	call	exit@PLT
.L14:
	call	benchmp_childid@PLT
	movl	%eax, %edi
	movl	$1, %edx
	movl	$1, %esi
	call	handle_scheduler@PLT
	movq	exit@GOTPCREL(%rip), %rsi
	movl	$15, %edi
	call	signal@PLT
	jmp	.L5
.L6:
	movslq	%edx, %rdx
	movq	16(%rbx), %rsi
	movl	(%rbx), %edi
	call	write@PLT
.L5:
	movslq	12(%rbx), %rdx
	movq	16(%rbx), %rsi
	movl	(%rbx), %edi
	call	read@PLT
	movl	12(%rbx), %edx
	movslq	%edx, %rcx
	cmpq	%rax, %rcx
	je	.L6
	movl	$0, %edi
	call	exit@PLT
	.cfi_endproc
.LFE73:
	.size	initialize, .-initialize
	.globl	cleanup
	.type	cleanup, @function
cleanup:
.LFB75:
	.cfi_startproc
	endbr64
	testq	%rdi, %rdi
	jne	.L18
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movq	%rsi, %rbx
	movl	8(%rsi), %edi
	testl	%edi, %edi
	jne	.L21
.L15:
	popq	%rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	ret
.L21:
	.cfi_restore_state
	movl	$9, %esi
	call	kill@PLT
	movl	8(%rbx), %edi
	movl	$0, %edx
	movl	$0, %esi
	call	waitpid@PLT
	movl	$0, 8(%rbx)
	jmp	.L15
.L18:
	.cfi_def_cfa_offset 8
	.cfi_restore 3
	ret
	.cfi_endproc
.LFE75:
	.size	cleanup, .-cleanup
	.globl	benchmark
	.type	benchmark, @function
benchmark:
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
	movq	%rdi, %rbp
	movq	%rsi, %rbx
.L23:
	testq	%rbp, %rbp
	je	.L28
	movslq	12(%rbx), %rdx
	movq	16(%rbx), %rsi
	movl	4(%rbx), %edi
	call	write@PLT
	movq	%rax, %rcx
	movl	12(%rbx), %edx
	movslq	%edx, %rax
	cmpq	%rax, %rcx
	jne	.L24
	movq	%rax, %rdx
	movq	16(%rbx), %rsi
	movl	4(%rbx), %edi
	call	read@PLT
	subq	$1, %rbp
	movslq	12(%rbx), %rdx
	cmpq	%rax, %rdx
	je	.L23
.L24:
	movq	%rbx, %rsi
	movl	$0, %edi
	call	cleanup
	movl	$0, %edi
	call	exit@PLT
.L28:
	addq	$8, %rsp
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE74:
	.size	benchmark, .-benchmark
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC2:
	.string	"[-m <message size>] [-P <parallelism>] [-W <warmup>] [-N <repetitions>]\n"
	.section	.rodata.str1.1
.LC3:
	.string	"m:P:W:N:"
.LC4:
	.string	"AF_UNIX sock stream latency"
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
	subq	$56, %rsp
	.cfi_def_cfa_offset 112
	movl	%edi, %ebx
	movq	%rsi, %rbp
	movq	%fs:40, %rax
	movq	%rax, 40(%rsp)
	xorl	%eax, %eax
	movl	$1, 28(%rsp)
	movl	$0, 24(%rsp)
	movl	$-1, %r14d
	movl	$0, %r13d
	movl	$1, 12(%rsp)
	leaq	.LC3(%rip), %r12
	leaq	.LC2(%rip), %r15
	jmp	.L30
.L32:
	cmpl	$109, %eax
	jne	.L35
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	movl	%eax, 28(%rsp)
.L30:
	movq	%r12, %rdx
	movq	%rbp, %rsi
	movl	%ebx, %edi
	call	mygetopt@PLT
	cmpl	$-1, %eax
	je	.L41
	cmpl	$87, %eax
	je	.L31
	jg	.L32
	cmpl	$78, %eax
	je	.L33
	cmpl	$80, %eax
	jne	.L35
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	movl	%eax, 12(%rsp)
	testl	%eax, %eax
	jg	.L30
	movq	%r15, %rdx
	movq	%rbp, %rsi
	movl	%ebx, %edi
	call	lmbench_usage@PLT
	jmp	.L30
.L31:
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	movl	%eax, %r13d
	jmp	.L30
.L33:
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	movl	%eax, %r14d
	jmp	.L30
.L35:
	movq	%r15, %rdx
	movq	%rbp, %rsi
	movl	%ebx, %edi
	call	lmbench_usage@PLT
	jmp	.L30
.L41:
	cmpl	%ebx, myoptind(%rip)
	jl	.L42
.L38:
	leaq	16(%rsp), %rax
	pushq	%rax
	.cfi_def_cfa_offset 120
	pushq	%r14
	.cfi_def_cfa_offset 128
	movl	%r13d, %r9d
	movl	28(%rsp), %r8d
	movl	$0, %ecx
	leaq	cleanup(%rip), %rdx
	leaq	benchmark(%rip), %rsi
	leaq	initialize(%rip), %rdi
	call	benchmp@PLT
	call	get_n@PLT
	movq	%rax, %rsi
	leaq	.LC4(%rip), %rdi
	call	micro@PLT
	addq	$16, %rsp
	.cfi_def_cfa_offset 112
	movq	40(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L43
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
.L42:
	.cfi_restore_state
	leaq	.LC2(%rip), %rdx
	movq	%rbp, %rsi
	movl	%ebx, %edi
	call	lmbench_usage@PLT
	jmp	.L38
.L43:
	call	__stack_chk_fail@PLT
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
