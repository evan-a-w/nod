	.file	"lat_pipe.c"
	.text
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"(r) read/write on pipe"
	.text
	.globl	doit
	.type	doit, @function
doit:
.LFB75:
	.cfi_startproc
	endbr64
	pushq	%r13
	.cfi_def_cfa_offset 16
	.cfi_offset 13, -16
	pushq	%r12
	.cfi_def_cfa_offset 24
	.cfi_offset 12, -24
	pushq	%rbp
	.cfi_def_cfa_offset 32
	.cfi_offset 6, -32
	pushq	%rbx
	.cfi_def_cfa_offset 40
	.cfi_offset 3, -40
	subq	$24, %rsp
	.cfi_def_cfa_offset 64
	movq	%rdi, %rbx
	movq	%fs:40, %rax
	movq	%rax, 8(%rsp)
	xorl	%eax, %eax
	movl	8(%rsi), %r13d
	movl	12(%rsi), %r12d
	leaq	7(%rsp), %rbp
.L2:
	testq	%rbx, %rbx
	je	.L8
	movl	$1, %edx
	movq	%rbp, %rsi
	movl	%r13d, %edi
	call	write@PLT
	cmpq	$1, %rax
	jne	.L3
	movl	$1, %edx
	movq	%rbp, %rsi
	movl	%r12d, %edi
	call	read@PLT
	subq	$1, %rbx
	cmpq	$1, %rax
	je	.L2
.L3:
	leaq	.LC0(%rip), %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L8:
	movq	8(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L9
	addq	$24, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 40
	popq	%rbx
	.cfi_def_cfa_offset 32
	popq	%rbp
	.cfi_def_cfa_offset 24
	popq	%r12
	.cfi_def_cfa_offset 16
	popq	%r13
	.cfi_def_cfa_offset 8
	ret
.L9:
	.cfi_restore_state
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE75:
	.size	doit, .-doit
	.globl	cleanup
	.type	cleanup, @function
cleanup:
.LFB74:
	.cfi_startproc
	endbr64
	testq	%rdi, %rdi
	jne	.L13
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movq	%rsi, %rbx
	movl	(%rsi), %edi
	testl	%edi, %edi
	jne	.L16
.L10:
	popq	%rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	ret
.L16:
	.cfi_restore_state
	movl	$9, %esi
	call	kill@PLT
	movl	$0, %edx
	movl	$0, %esi
	movl	(%rbx), %edi
	call	waitpid@PLT
	movl	$0, (%rbx)
	jmp	.L10
.L13:
	.cfi_def_cfa_offset 8
	.cfi_restore 3
	ret
	.cfi_endproc
.LFE74:
	.size	cleanup, .-cleanup
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC1:
	.string	"[-P <parallelism>] [-W <warmup>] [-N <repetitions>]\n"
	.section	.rodata.str1.1
.LC2:
	.string	"P:W:N:"
.LC3:
	.string	"Pipe latency"
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
	movl	$-1, %r14d
	movl	$0, %r13d
	movl	$1, 12(%rsp)
	leaq	.LC2(%rip), %r12
	leaq	.LC1(%rip), %r15
	jmp	.L18
.L19:
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	movl	%eax, 12(%rsp)
	testl	%eax, %eax
	jg	.L18
	movq	%r15, %rdx
	movq	%rbp, %rsi
	movl	%ebx, %edi
	call	lmbench_usage@PLT
	jmp	.L18
.L20:
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	movl	%eax, %r13d
.L18:
	movq	%r12, %rdx
	movq	%rbp, %rsi
	movl	%ebx, %edi
	call	mygetopt@PLT
	cmpl	$-1, %eax
	je	.L29
	cmpl	$80, %eax
	je	.L19
	cmpl	$87, %eax
	je	.L20
	cmpl	$78, %eax
	je	.L30
	movq	%r15, %rdx
	movq	%rbp, %rsi
	movl	%ebx, %edi
	call	lmbench_usage@PLT
	jmp	.L18
.L30:
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	movl	%eax, %r14d
	jmp	.L18
.L29:
	cmpl	%ebx, myoptind(%rip)
	jl	.L31
.L25:
	movl	$0, 16(%rsp)
	leaq	16(%rsp), %rax
	pushq	%rax
	.cfi_def_cfa_offset 120
	pushq	%r14
	.cfi_def_cfa_offset 128
	movl	%r13d, %r9d
	movl	28(%rsp), %r8d
	movl	$1000000, %ecx
	leaq	cleanup(%rip), %rdx
	leaq	doit(%rip), %rsi
	leaq	initialize(%rip), %rdi
	call	benchmp@PLT
	call	get_n@PLT
	movq	%rax, %rsi
	leaq	.LC3(%rip), %rdi
	call	micro@PLT
	addq	$16, %rsp
	.cfi_def_cfa_offset 112
	movq	40(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L32
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
.L31:
	.cfi_restore_state
	leaq	.LC1(%rip), %rdx
	movq	%rbp, %rsi
	movl	%ebx, %edi
	call	lmbench_usage@PLT
	jmp	.L25
.L32:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE72:
	.size	main, .-main
	.section	.rodata.str1.1
.LC4:
	.string	"(w) read/write on pipe"
	.text
	.globl	writer
	.type	writer, @function
writer:
.LFB76:
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
	subq	$16, %rsp
	.cfi_def_cfa_offset 48
	movl	%edi, %r12d
	movl	%esi, %ebx
	movq	%fs:40, %rax
	movq	%rax, 8(%rsp)
	xorl	%eax, %eax
	leaq	.LC4(%rip), %rbp
	jmp	.L34
.L35:
	movq	%rbp, %rdi
	call	perror@PLT
.L34:
	leaq	7(%rsp), %rsi
	movl	$1, %edx
	movl	%ebx, %edi
	call	read@PLT
	cmpq	$1, %rax
	jne	.L35
	leaq	7(%rsp), %rsi
	movl	$1, %edx
	movl	%r12d, %edi
	call	write@PLT
	cmpq	$1, %rax
	jne	.L35
	jmp	.L34
	.cfi_endproc
.LFE76:
	.size	writer, .-writer
	.section	.rodata.str1.1
.LC5:
	.string	"pipe"
.LC6:
	.string	"fork"
.LC7:
	.string	"(i) read/write on pipe"
	.text
	.globl	initialize
	.type	initialize, @function
initialize:
.LFB73:
	.cfi_startproc
	endbr64
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	subq	$16, %rsp
	.cfi_def_cfa_offset 32
	movq	%fs:40, %rax
	movq	%rax, 8(%rsp)
	xorl	%eax, %eax
	testq	%rdi, %rdi
	je	.L49
.L39:
	movq	8(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L50
	addq	$16, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 16
	popq	%rbx
	.cfi_def_cfa_offset 8
	ret
.L49:
	.cfi_restore_state
	movq	%rsi, %rbx
	leaq	4(%rsi), %rdi
	call	pipe@PLT
	cmpl	$-1, %eax
	je	.L51
	leaq	12(%rbx), %rdi
	call	pipe@PLT
	cmpl	$-1, %eax
	je	.L52
	movl	$0, %eax
	call	benchmp_childid@PLT
	movl	%eax, %edi
	movl	$1, %edx
	movl	$0, %esi
	call	handle_scheduler@PLT
	call	fork@PLT
	movl	%eax, (%rbx)
	cmpl	$-1, %eax
	je	.L43
	testl	%eax, %eax
	je	.L53
	movl	4(%rbx), %edi
	call	close@PLT
	movl	16(%rbx), %edi
	call	close@PLT
	leaq	7(%rsp), %rsi
	movl	8(%rbx), %edi
	movl	$1, %edx
	call	write@PLT
	cmpq	$1, %rax
	jne	.L45
	leaq	7(%rsp), %rsi
	movl	12(%rbx), %edi
	movl	$1, %edx
	call	read@PLT
	cmpq	$1, %rax
	je	.L39
.L45:
	leaq	.LC7(%rip), %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L51:
	leaq	.LC5(%rip), %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L52:
	leaq	.LC5(%rip), %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L53:
	call	benchmp_childid@PLT
	movl	%eax, %edi
	movl	$1, %edx
	movl	$1, %esi
	call	handle_scheduler@PLT
	movq	exit@GOTPCREL(%rip), %rsi
	movl	$15, %edi
	call	signal@PLT
	movl	8(%rbx), %edi
	call	close@PLT
	movl	12(%rbx), %edi
	call	close@PLT
	movl	4(%rbx), %esi
	movl	16(%rbx), %edi
	call	writer
.L43:
	leaq	.LC6(%rip), %rdi
	call	perror@PLT
	jmp	.L39
.L50:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE73:
	.size	initialize, .-initialize
	.globl	id
	.section	.rodata.str1.1
.LC8:
	.string	"$Id$\n"
	.section	.data.rel.local,"aw"
	.align 8
	.type	id, @object
	.size	id, 8
id:
	.quad	.LC8
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
