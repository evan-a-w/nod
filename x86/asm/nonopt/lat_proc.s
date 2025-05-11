	.file	"lat_proc.c"
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
	.globl	child_pid
	.bss
	.align 4
	.type	child_pid, @object
	.size	child_pid, 4
child_pid:
	.zero	4
	.text
	.globl	cleanup
	.type	cleanup, @function
cleanup:
.LFB8:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	cmpq	$0, -8(%rbp)
	jne	.L4
	movl	child_pid(%rip), %eax
	testl	%eax, %eax
	je	.L1
	movl	child_pid(%rip), %eax
	movl	$9, %esi
	movl	%eax, %edi
	call	kill@PLT
	movl	child_pid(%rip), %eax
	movl	$0, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	waitpid@PLT
	movl	$0, child_pid(%rip)
	jmp	.L1
.L4:
	nop
.L1:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE8:
	.size	cleanup, .-cleanup
	.section	.rodata
	.align 8
.LC1:
	.string	"[-P <parallelism>] [-W <warmup>] [-N <repetitions>] procedure|fork|exec|shell\n"
.LC2:
	.string	"P:W:N:"
.LC3:
	.string	"procedure"
.LC4:
	.string	"Procedure call"
.LC5:
	.string	"fork"
.LC6:
	.string	"Process fork+exit"
.LC7:
	.string	"exec"
.LC8:
	.string	"Process fork+execve"
.LC9:
	.string	"shell"
.LC10:
	.string	"Process fork+/bin/sh -c"
	.text
	.globl	main
	.type	main, @function
main:
.LFB9:
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
	jmp	.L6
.L11:
	cmpl	$87, -12(%rbp)
	je	.L7
	cmpl	$87, -12(%rbp)
	jg	.L8
	cmpl	$78, -12(%rbp)
	je	.L9
	cmpl	$80, -12(%rbp)
	jne	.L8
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -24(%rbp)
	cmpl	$0, -24(%rbp)
	jg	.L6
	movl	-36(%rbp), %eax
	movq	-8(%rbp), %rdx
	movq	-48(%rbp), %rcx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	lmbench_usage@PLT
	jmp	.L6
.L7:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -20(%rbp)
	jmp	.L6
.L9:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -16(%rbp)
	jmp	.L6
.L8:
	movl	-36(%rbp), %eax
	movq	-8(%rbp), %rdx
	movq	-48(%rbp), %rcx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	lmbench_usage@PLT
	nop
.L6:
	movl	-36(%rbp), %eax
	movq	-48(%rbp), %rcx
	leaq	.LC2(%rip), %rdx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	mygetopt@PLT
	movl	%eax, -12(%rbp)
	cmpl	$-1, -12(%rbp)
	jne	.L11
	movl	myoptind(%rip), %eax
	leal	1(%rax), %edx
	movl	-36(%rbp), %eax
	cmpl	%eax, %edx
	je	.L12
	movl	-36(%rbp), %eax
	movq	-8(%rbp), %rdx
	movq	-48(%rbp), %rcx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	lmbench_usage@PLT
.L12:
	movl	myoptind(%rip), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-48(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	%rax, %rsi
	leaq	.LC3(%rip), %rax
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L13
	movl	-20(%rbp), %ecx
	movl	-24(%rbp), %edx
	leaq	-36(%rbp), %rax
	pushq	%rax
	movl	-16(%rbp), %eax
	pushq	%rax
	movl	%ecx, %r9d
	movl	%edx, %r8d
	movl	$0, %ecx
	leaq	cleanup(%rip), %rax
	movq	%rax, %rdx
	leaq	do_procedure(%rip), %rax
	movq	%rax, %rsi
	movl	$0, %edi
	call	benchmp@PLT
	addq	$16, %rsp
	call	get_n@PLT
	movq	%rax, %rsi
	leaq	.LC4(%rip), %rax
	movq	%rax, %rdi
	call	micro@PLT
	jmp	.L14
.L13:
	movl	myoptind(%rip), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-48(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	%rax, %rsi
	leaq	.LC5(%rip), %rax
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L15
	movl	-20(%rbp), %ecx
	movl	-24(%rbp), %edx
	pushq	$0
	movl	-16(%rbp), %eax
	pushq	%rax
	movl	%ecx, %r9d
	movl	%edx, %r8d
	movl	$0, %ecx
	leaq	cleanup(%rip), %rax
	movq	%rax, %rdx
	leaq	do_fork(%rip), %rax
	movq	%rax, %rsi
	movl	$0, %edi
	call	benchmp@PLT
	addq	$16, %rsp
	call	get_n@PLT
	movq	%rax, %rsi
	leaq	.LC6(%rip), %rax
	movq	%rax, %rdi
	call	micro@PLT
	jmp	.L14
.L15:
	movl	myoptind(%rip), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-48(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	%rax, %rsi
	leaq	.LC7(%rip), %rax
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L16
	movl	-20(%rbp), %ecx
	movl	-24(%rbp), %edx
	pushq	$0
	movl	-16(%rbp), %eax
	pushq	%rax
	movl	%ecx, %r9d
	movl	%edx, %r8d
	movl	$0, %ecx
	leaq	cleanup(%rip), %rax
	movq	%rax, %rdx
	leaq	do_forkexec(%rip), %rax
	movq	%rax, %rsi
	movl	$0, %edi
	call	benchmp@PLT
	addq	$16, %rsp
	call	get_n@PLT
	movq	%rax, %rsi
	leaq	.LC8(%rip), %rax
	movq	%rax, %rdi
	call	micro@PLT
	jmp	.L14
.L16:
	movl	myoptind(%rip), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-48(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	%rax, %rsi
	leaq	.LC9(%rip), %rax
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L17
	movl	-20(%rbp), %ecx
	movl	-24(%rbp), %edx
	pushq	$0
	movl	-16(%rbp), %eax
	pushq	%rax
	movl	%ecx, %r9d
	movl	%edx, %r8d
	movl	$0, %ecx
	leaq	cleanup(%rip), %rax
	movq	%rax, %rdx
	leaq	do_shell(%rip), %rax
	movq	%rax, %rsi
	movl	$0, %edi
	call	benchmp@PLT
	addq	$16, %rsp
	call	get_n@PLT
	movq	%rax, %rsi
	leaq	.LC10(%rip), %rax
	movq	%rax, %rdi
	call	micro@PLT
	jmp	.L14
.L17:
	movl	-36(%rbp), %eax
	movq	-8(%rbp), %rdx
	movq	-48(%rbp), %rcx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	lmbench_usage@PLT
.L14:
	movl	$0, %eax
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE9:
	.size	main, .-main
	.section	.rodata
.LC11:
	.string	"/tmp/hello"
.LC12:
	.string	"-c"
.LC13:
	.string	"sh"
.LC14:
	.string	"/bin/sh"
	.text
	.globl	do_shell
	.type	do_shell, @function
do_shell:
.LFB10:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movl	$0, %esi
	movl	$17, %edi
	call	signal@PLT
	movl	$0, %eax
	call	benchmp_childid@PLT
	movl	$1, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	handle_scheduler@PLT
	jmp	.L20
.L24:
	call	fork@PLT
	movl	%eax, child_pid(%rip)
	movl	child_pid(%rip), %eax
	cmpl	$-1, %eax
	je	.L21
	testl	%eax, %eax
	je	.L22
	jmp	.L25
.L21:
	leaq	.LC5(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L22:
	movl	$0, %eax
	call	benchmp_childid@PLT
	movl	$1, %edx
	movl	$1, %esi
	movl	%eax, %edi
	call	handle_scheduler@PLT
	movl	$1, %edi
	call	close@PLT
	movl	$0, %r8d
	leaq	.LC11(%rip), %rax
	movq	%rax, %rcx
	leaq	.LC12(%rip), %rax
	movq	%rax, %rdx
	leaq	.LC13(%rip), %rax
	movq	%rax, %rsi
	leaq	.LC14(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	execlp@PLT
	movl	$1, %edi
	call	exit@PLT
.L25:
	movl	child_pid(%rip), %eax
	movl	$0, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	waitpid@PLT
	movl	$0, child_pid(%rip)
.L20:
	movq	-8(%rbp), %rax
	leaq	-1(%rax), %rdx
	movq	%rdx, -8(%rbp)
	testq	%rax, %rax
	jne	.L24
	nop
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE10:
	.size	do_shell, .-do_shell
	.globl	do_forkexec
	.type	do_forkexec, @function
do_forkexec:
.LFB11:
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
	movl	$0, %esi
	movl	$17, %edi
	call	signal@PLT
	movl	$0, %eax
	call	benchmp_childid@PLT
	movl	$1, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	handle_scheduler@PLT
	jmp	.L27
.L31:
	leaq	.LC11(%rip), %rax
	movq	%rax, -32(%rbp)
	movq	$0, -24(%rbp)
	call	fork@PLT
	movl	%eax, child_pid(%rip)
	movl	child_pid(%rip), %eax
	cmpl	$-1, %eax
	je	.L28
	testl	%eax, %eax
	je	.L29
	jmp	.L33
.L28:
	leaq	.LC5(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L29:
	movl	$0, %eax
	call	benchmp_childid@PLT
	movl	$1, %edx
	movl	$1, %esi
	movl	%eax, %edi
	call	handle_scheduler@PLT
	movl	$1, %edi
	call	close@PLT
	leaq	-32(%rbp), %rax
	movl	$0, %edx
	movq	%rax, %rsi
	leaq	.LC11(%rip), %rax
	movq	%rax, %rdi
	call	execve@PLT
	movl	$1, %edi
	call	exit@PLT
.L33:
	movl	child_pid(%rip), %eax
	movl	$0, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	waitpid@PLT
	movl	$0, child_pid(%rip)
.L27:
	movq	-40(%rbp), %rax
	leaq	-1(%rax), %rdx
	movq	%rdx, -40(%rbp)
	testq	%rax, %rax
	jne	.L31
	nop
	movq	-8(%rbp), %rax
	subq	%fs:40, %rax
	je	.L32
	call	__stack_chk_fail@PLT
.L32:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE11:
	.size	do_forkexec, .-do_forkexec
	.globl	do_fork
	.type	do_fork, @function
do_fork:
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
	movq	%rsi, -16(%rbp)
	movl	$0, %esi
	movl	$17, %edi
	call	signal@PLT
	movl	$0, %eax
	call	benchmp_childid@PLT
	movl	$1, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	handle_scheduler@PLT
	jmp	.L35
.L39:
	call	fork@PLT
	movl	%eax, child_pid(%rip)
	movl	child_pid(%rip), %eax
	cmpl	$-1, %eax
	je	.L36
	testl	%eax, %eax
	je	.L37
	jmp	.L40
.L36:
	leaq	.LC5(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L37:
	movl	$0, %eax
	call	benchmp_childid@PLT
	movl	$1, %edx
	movl	$1, %esi
	movl	%eax, %edi
	call	handle_scheduler@PLT
	movl	$1, %edi
	call	exit@PLT
.L40:
	movl	child_pid(%rip), %eax
	movl	$0, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	waitpid@PLT
	movl	$0, child_pid(%rip)
.L35:
	movq	-8(%rbp), %rax
	leaq	-1(%rax), %rdx
	movq	%rdx, -8(%rbp)
	testq	%rax, %rax
	jne	.L39
	nop
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE12:
	.size	do_fork, .-do_fork
	.globl	do_procedure
	.type	do_procedure, @function
do_procedure:
.LFB13:
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
	movl	(%rax), %eax
	movl	%eax, -4(%rbp)
	movl	$0, %eax
	call	benchmp_childid@PLT
	movl	$1, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	handle_scheduler@PLT
	jmp	.L42
.L43:
	movl	-4(%rbp), %eax
	movl	%eax, %edi
	call	use_int@PLT
.L42:
	movq	-24(%rbp), %rax
	leaq	-1(%rax), %rdx
	movq	%rdx, -24(%rbp)
	testq	%rax, %rax
	jne	.L43
	nop
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE13:
	.size	do_procedure, .-do_procedure
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
