	.file	"lat_sem.c"
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
	.string	"Semaphore latency"
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
	subq	$64, %rsp
	movl	%edi, -52(%rbp)
	movq	%rsi, -64(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movl	$1, -40(%rbp)
	movl	$0, -36(%rbp)
	movl	$-1, -32(%rbp)
	leaq	.LC1(%rip), %rax
	movq	%rax, -24(%rbp)
	jmp	.L2
.L7:
	cmpl	$87, -28(%rbp)
	je	.L3
	cmpl	$87, -28(%rbp)
	jg	.L4
	cmpl	$78, -28(%rbp)
	je	.L5
	cmpl	$80, -28(%rbp)
	jne	.L4
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -40(%rbp)
	cmpl	$0, -40(%rbp)
	jg	.L2
	movq	-24(%rbp), %rdx
	movq	-64(%rbp), %rcx
	movl	-52(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	lmbench_usage@PLT
	jmp	.L2
.L3:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -36(%rbp)
	jmp	.L2
.L5:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -32(%rbp)
	jmp	.L2
.L4:
	movq	-24(%rbp), %rdx
	movq	-64(%rbp), %rcx
	movl	-52(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	lmbench_usage@PLT
	nop
.L2:
	movq	-64(%rbp), %rcx
	movl	-52(%rbp), %eax
	leaq	.LC2(%rip), %rdx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	mygetopt@PLT
	movl	%eax, -28(%rbp)
	cmpl	$-1, -28(%rbp)
	jne	.L7
	movl	myoptind(%rip), %eax
	cmpl	%eax, -52(%rbp)
	jle	.L8
	movq	-24(%rbp), %rdx
	movq	-64(%rbp), %rcx
	movl	-52(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	lmbench_usage@PLT
.L8:
	movl	$0, -16(%rbp)
	movl	-36(%rbp), %ecx
	movl	-40(%rbp), %edx
	leaq	-16(%rbp), %rax
	pushq	%rax
	movl	-32(%rbp), %eax
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
	addq	%rax, %rax
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
	.string	"fork"
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
	subq	$32, %rsp
	movq	%rdi, -24(%rbp)
	movq	%rsi, -32(%rbp)
	movq	-32(%rbp), %rax
	movq	%rax, -8(%rbp)
	cmpq	$0, -24(%rbp)
	jne	.L16
	movl	$1920, %edx
	movl	$2, %esi
	movl	$0, %edi
	call	semget@PLT
	movq	-8(%rbp), %rdx
	movl	%eax, 4(%rdx)
	movq	-8(%rbp), %rax
	movl	4(%rax), %eax
	movl	$0, %ecx
	movl	$16, %edx
	movl	$0, %esi
	movl	%eax, %edi
	movl	$0, %eax
	call	semctl@PLT
	movq	-8(%rbp), %rax
	movl	4(%rax), %eax
	movl	$0, %ecx
	movl	$16, %edx
	movl	$1, %esi
	movl	%eax, %edi
	movl	$0, %eax
	call	semctl@PLT
	movl	$0, %eax
	call	benchmp_childid@PLT
	movl	$1, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	handle_scheduler@PLT
	call	fork@PLT
	movl	%eax, %edx
	movq	-8(%rbp), %rax
	movl	%edx, (%rax)
	movq	-8(%rbp), %rax
	movl	(%rax), %eax
	cmpl	$-1, %eax
	je	.L14
	testl	%eax, %eax
	jne	.L17
	movq	exit@GOTPCREL(%rip), %rax
	movq	%rax, %rsi
	movl	$15, %edi
	call	signal@PLT
	movl	$0, %eax
	call	benchmp_childid@PLT
	movl	$1, %edx
	movl	$1, %esi
	movl	%eax, %edi
	call	handle_scheduler@PLT
	movq	-8(%rbp), %rax
	movl	4(%rax), %eax
	movl	%eax, %edi
	call	writer
	jmp	.L11
.L14:
	leaq	.LC4(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	jmp	.L11
.L16:
	nop
	jmp	.L11
.L17:
	nop
.L11:
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
	jne	.L22
	movq	-8(%rbp), %rax
	movl	(%rax), %eax
	testl	%eax, %eax
	je	.L21
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
.L21:
	movq	-8(%rbp), %rax
	movl	4(%rax), %eax
	movl	$0, %edx
	movl	$0, %esi
	movl	%eax, %edi
	movl	$0, %eax
	call	semctl@PLT
	jmp	.L18
.L22:
	nop
.L18:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE10:
	.size	cleanup, .-cleanup
	.section	.rodata
.LC5:
	.string	"(r) error on semaphore"
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
	pushq	%rbx
	subq	$56, %rsp
	.cfi_offset 3, -24
	movq	%rdi, %rbx
	movq	%rsi, -56(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -24(%rbp)
	xorl	%eax, %eax
	movq	-56(%rbp), %rax
	movq	%rax, -48(%rbp)
	movw	$1, -36(%rbp)
	movw	$-1, -34(%rbp)
	movw	$0, -32(%rbp)
	movw	$0, -30(%rbp)
	movw	$1, -28(%rbp)
	movw	$0, -26(%rbp)
	jmp	.L24
.L25:
	movq	-48(%rbp), %rax
	movl	4(%rax), %eax
	leaq	-36(%rbp), %rcx
	movl	$2, %edx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	semop@PLT
	testl	%eax, %eax
	jns	.L24
	leaq	.LC5(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L24:
	movq	%rbx, %rax
	leaq	-1(%rax), %rbx
	testq	%rax, %rax
	jne	.L25
	nop
	movq	-24(%rbp), %rax
	subq	%fs:40, %rax
	je	.L26
	call	__stack_chk_fail@PLT
.L26:
	movq	-8(%rbp), %rbx
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE11:
	.size	doit, .-doit
	.section	.rodata
	.align 8
.LC6:
	.string	"(w) error on initial semaphore"
.LC7:
	.string	"(w) error on semaphore"
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
	pushq	%rbx
	subq	$40, %rsp
	.cfi_offset 3, -24
	movl	%edi, %ebx
	movq	%fs:40, %rax
	movq	%rax, -24(%rbp)
	xorl	%eax, %eax
	movw	$1, -36(%rbp)
	movw	$1, -34(%rbp)
	movw	$0, -32(%rbp)
	leaq	-36(%rbp), %rax
	movl	$1, %edx
	movq	%rax, %rsi
	movl	%ebx, %edi
	call	semop@PLT
	testl	%eax, %eax
	jns	.L28
	leaq	.LC6(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L28:
	movw	$0, -36(%rbp)
	movw	$-1, -34(%rbp)
	movw	$0, -32(%rbp)
	movw	$1, -30(%rbp)
	movw	$1, -28(%rbp)
	movw	$0, -26(%rbp)
.L30:
	leaq	-36(%rbp), %rax
	movl	$2, %edx
	movq	%rax, %rsi
	movl	%ebx, %edi
	call	semop@PLT
	testl	%eax, %eax
	jns	.L30
	leaq	.LC7(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
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
