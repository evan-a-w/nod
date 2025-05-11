	.file	"lat_pipe.c"
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
	.string	"Pipe latency"
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
	subq	$80, %rsp
	movl	%edi, -68(%rbp)
	movq	%rsi, -80(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movl	$1, -56(%rbp)
	movl	$0, -52(%rbp)
	movl	$-1, -48(%rbp)
	leaq	.LC1(%rip), %rax
	movq	%rax, -40(%rbp)
	jmp	.L2
.L7:
	cmpl	$87, -44(%rbp)
	je	.L3
	cmpl	$87, -44(%rbp)
	jg	.L4
	cmpl	$78, -44(%rbp)
	je	.L5
	cmpl	$80, -44(%rbp)
	jne	.L4
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -56(%rbp)
	cmpl	$0, -56(%rbp)
	jg	.L2
	movq	-40(%rbp), %rdx
	movq	-80(%rbp), %rcx
	movl	-68(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	lmbench_usage@PLT
	jmp	.L2
.L3:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -52(%rbp)
	jmp	.L2
.L5:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -48(%rbp)
	jmp	.L2
.L4:
	movq	-40(%rbp), %rdx
	movq	-80(%rbp), %rcx
	movl	-68(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	lmbench_usage@PLT
	nop
.L2:
	movq	-80(%rbp), %rcx
	movl	-68(%rbp), %eax
	leaq	.LC2(%rip), %rdx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	mygetopt@PLT
	movl	%eax, -44(%rbp)
	cmpl	$-1, -44(%rbp)
	jne	.L7
	movl	myoptind(%rip), %eax
	cmpl	%eax, -68(%rbp)
	jle	.L8
	movq	-40(%rbp), %rdx
	movq	-80(%rbp), %rcx
	movl	-68(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	lmbench_usage@PLT
.L8:
	movl	$0, -32(%rbp)
	movl	-52(%rbp), %ecx
	movl	-56(%rbp), %edx
	leaq	-32(%rbp), %rax
	pushq	%rax
	movl	-48(%rbp), %eax
	pushq	%rax
	movl	%ecx, %r9d
	movl	%edx, %r8d
	movl	$1000000, %ecx
	leaq	cleanup(%rip), %rax
	movq	%rax, %rdx
	leaq	doit(%rip), %rax
	movq	%rax, %rsi
	leaq	initialize(%rip), %rax
	movq	%rax, %rdi
	call	benchmp@PLT
	addq	$16, %rsp
	call	get_n@PLT
	movq	%rax, %rsi
	leaq	.LC3(%rip), %rax
	movq	%rax, %rdi
	call	micro@PLT
	movl	$0, %eax
	movq	-8(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L10
	call	__stack_chk_fail@PLT
.L10:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE8:
	.size	main, .-main
	.section	.rodata
.LC4:
	.string	"pipe"
.LC5:
	.string	"fork"
.LC6:
	.string	"(i) read/write on pipe"
	.text
	.globl	initialize
	.type	initialize, @function
initialize:
.LFB9:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$48, %rsp
	movq	%rdi, -40(%rbp)
	movq	%rsi, -48(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movq	-48(%rbp), %rax
	movq	%rax, -16(%rbp)
	cmpq	$0, -40(%rbp)
	jne	.L22
	movq	-16(%rbp), %rax
	addq	$4, %rax
	movq	%rax, %rdi
	call	pipe@PLT
	cmpl	$-1, %eax
	jne	.L14
	leaq	.LC4(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L14:
	movq	-16(%rbp), %rax
	addq	$12, %rax
	movq	%rax, %rdi
	call	pipe@PLT
	cmpl	$-1, %eax
	jne	.L15
	leaq	.LC4(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L15:
	movl	$0, %eax
	call	benchmp_childid@PLT
	movl	$1, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	handle_scheduler@PLT
	call	fork@PLT
	movl	%eax, %edx
	movq	-16(%rbp), %rax
	movl	%edx, (%rax)
	movq	-16(%rbp), %rax
	movl	(%rax), %eax
	cmpl	$-1, %eax
	je	.L16
	testl	%eax, %eax
	jne	.L17
	movl	$0, %eax
	call	benchmp_childid@PLT
	movl	$1, %edx
	movl	$1, %esi
	movl	%eax, %edi
	call	handle_scheduler@PLT
	movq	exit@GOTPCREL(%rip), %rax
	movq	%rax, %rsi
	movl	$15, %edi
	call	signal@PLT
	movq	-16(%rbp), %rax
	movl	8(%rax), %eax
	movl	%eax, %edi
	call	close@PLT
	movq	-16(%rbp), %rax
	movl	12(%rax), %eax
	movl	%eax, %edi
	call	close@PLT
	movq	-16(%rbp), %rax
	movl	4(%rax), %edx
	movq	-16(%rbp), %rax
	movl	16(%rax), %eax
	movl	%edx, %esi
	movl	%eax, %edi
	call	writer
	jmp	.L11
.L16:
	leaq	.LC5(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	jmp	.L11
.L17:
	movq	-16(%rbp), %rax
	movl	4(%rax), %eax
	movl	%eax, %edi
	call	close@PLT
	movq	-16(%rbp), %rax
	movl	16(%rax), %eax
	movl	%eax, %edi
	call	close@PLT
	nop
	movq	-16(%rbp), %rax
	movl	8(%rax), %eax
	leaq	-17(%rbp), %rcx
	movl	$1, %edx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	write@PLT
	cmpq	$1, %rax
	jne	.L18
	movq	-16(%rbp), %rax
	movl	12(%rax), %eax
	leaq	-17(%rbp), %rcx
	movl	$1, %edx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	read@PLT
	cmpq	$1, %rax
	je	.L11
.L18:
	leaq	.LC6(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L22:
	nop
.L11:
	movq	-8(%rbp), %rax
	subq	%fs:40, %rax
	je	.L21
	call	__stack_chk_fail@PLT
.L21:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE9:
	.size	initialize, .-initialize
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
	jne	.L26
	movq	-8(%rbp), %rax
	movl	(%rax), %eax
	testl	%eax, %eax
	je	.L23
	movq	-8(%rbp), %rax
	movl	(%rax), %eax
	movl	$9, %esi
	movl	%eax, %edi
	call	kill@PLT
	movq	-8(%rbp), %rax
	movl	(%rax), %eax
	movl	$0, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	waitpid@PLT
	movq	-8(%rbp), %rax
	movl	$0, (%rax)
	jmp	.L23
.L26:
	nop
.L23:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE10:
	.size	cleanup, .-cleanup
	.section	.rodata
.LC7:
	.string	"(r) read/write on pipe"
	.text
	.globl	doit
	.type	doit, @function
doit:
.LFB11:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$48, %rsp
	.cfi_offset 14, -24
	.cfi_offset 13, -32
	.cfi_offset 12, -40
	.cfi_offset 3, -48
	movq	%rdi, %rbx
	movq	%rsi, -72(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -40(%rbp)
	xorl	%eax, %eax
	movq	-72(%rbp), %rax
	movq	%rax, -48(%rbp)
	movq	-48(%rbp), %rax
	movl	8(%rax), %r13d
	movq	-48(%rbp), %rax
	movl	12(%rax), %r14d
	leaq	-49(%rbp), %r12
	jmp	.L28
.L30:
	movl	$1, %edx
	movq	%r12, %rsi
	movl	%r13d, %edi
	call	write@PLT
	cmpq	$1, %rax
	jne	.L29
	movl	$1, %edx
	movq	%r12, %rsi
	movl	%r14d, %edi
	call	read@PLT
	cmpq	$1, %rax
	je	.L28
.L29:
	leaq	.LC7(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L28:
	movq	%rbx, %rax
	leaq	-1(%rax), %rbx
	testq	%rax, %rax
	jne	.L30
	nop
	movq	-40(%rbp), %rax
	subq	%fs:40, %rax
	je	.L31
	call	__stack_chk_fail@PLT
.L31:
	addq	$48, %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE11:
	.size	doit, .-doit
	.section	.rodata
.LC8:
	.string	"(w) read/write on pipe"
	.text
	.globl	writer
	.type	writer, @function
writer:
.LFB12:
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
	subq	$24, %rsp
	.cfi_offset 13, -24
	.cfi_offset 12, -32
	.cfi_offset 3, -40
	movl	%edi, %r12d
	movl	%esi, %r13d
	movq	%fs:40, %rax
	movq	%rax, -40(%rbp)
	xorl	%eax, %eax
	leaq	-41(%rbp), %rbx
.L35:
	movl	$1, %edx
	movq	%rbx, %rsi
	movl	%r13d, %edi
	call	read@PLT
	cmpq	$1, %rax
	jne	.L33
	movl	$1, %edx
	movq	%rbx, %rsi
	movl	%r12d, %edi
	call	write@PLT
	cmpq	$1, %rax
	je	.L35
.L33:
	leaq	.LC8(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	jmp	.L35
	.cfi_endproc
.LFE12:
	.size	writer, .-writer
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
