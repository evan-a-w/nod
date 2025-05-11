	.file	"lat_proc.c"
	.text
	.globl	cleanup
	.type	cleanup, @function
cleanup:
.LFB72:
	.cfi_startproc
	endbr64
	testq	%rdi, %rdi
	jne	.L4
	movl	child_pid(%rip), %edi
	testl	%edi, %edi
	jne	.L7
.L4:
	ret
.L7:
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	movl	$9, %esi
	call	kill@PLT
	movl	$0, %edx
	movl	$0, %esi
	movl	child_pid(%rip), %edi
	call	waitpid@PLT
	movl	$0, child_pid(%rip)
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE72:
	.size	cleanup, .-cleanup
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"fork"
	.text
	.globl	do_fork
	.type	do_fork, @function
do_fork:
.LFB76:
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
	movl	$0, %esi
	movl	$17, %edi
	call	signal@PLT
	movl	$0, %eax
	call	benchmp_childid@PLT
	movl	%eax, %edi
	movl	$1, %edx
	movl	$0, %esi
	call	handle_scheduler@PLT
	leaq	-1(%rbp), %rbx
	testq	%rbp, %rbp
	je	.L8
.L13:
	call	fork@PLT
	movl	%eax, %edi
	movl	%eax, child_pid(%rip)
	cmpl	$-1, %eax
	je	.L10
	testl	%eax, %eax
	je	.L17
	movl	$0, %edx
	movl	$0, %esi
	call	waitpid@PLT
	movl	$0, child_pid(%rip)
	subq	$1, %rbx
	cmpq	$-1, %rbx
	jne	.L13
.L8:
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
	leaq	.LC0(%rip), %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L17:
	movl	$0, %eax
	call	benchmp_childid@PLT
	movl	%eax, %edi
	movl	$1, %edx
	movl	$1, %esi
	call	handle_scheduler@PLT
	movl	$1, %edi
	call	exit@PLT
	.cfi_endproc
.LFE76:
	.size	do_fork, .-do_fork
	.section	.rodata.str1.1
.LC1:
	.string	"/tmp/hello"
.LC2:
	.string	"-c"
.LC3:
	.string	"sh"
.LC4:
	.string	"/bin/sh"
	.text
	.globl	do_shell
	.type	do_shell, @function
do_shell:
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
	movl	$0, %esi
	movl	$17, %edi
	call	signal@PLT
	movl	$0, %eax
	call	benchmp_childid@PLT
	movl	%eax, %edi
	movl	$1, %edx
	movl	$0, %esi
	call	handle_scheduler@PLT
	leaq	-1(%rbp), %rbx
	testq	%rbp, %rbp
	je	.L18
.L23:
	call	fork@PLT
	movl	%eax, %edi
	movl	%eax, child_pid(%rip)
	cmpl	$-1, %eax
	je	.L20
	testl	%eax, %eax
	je	.L27
	movl	$0, %edx
	movl	$0, %esi
	call	waitpid@PLT
	movl	$0, child_pid(%rip)
	subq	$1, %rbx
	cmpq	$-1, %rbx
	jne	.L23
.L18:
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
.L20:
	.cfi_restore_state
	leaq	.LC0(%rip), %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L27:
	movl	$0, %eax
	call	benchmp_childid@PLT
	movl	%eax, %edi
	movl	$1, %edx
	movl	$1, %esi
	call	handle_scheduler@PLT
	movl	$1, %edi
	call	close@PLT
	movl	$0, %r8d
	leaq	.LC1(%rip), %rcx
	leaq	.LC2(%rip), %rdx
	leaq	.LC3(%rip), %rsi
	leaq	.LC4(%rip), %rdi
	movl	$0, %eax
	call	execlp@PLT
	movl	$1, %edi
	call	exit@PLT
	.cfi_endproc
.LFE74:
	.size	do_shell, .-do_shell
	.globl	do_forkexec
	.type	do_forkexec, @function
do_forkexec:
.LFB75:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushq	%rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	subq	$40, %rsp
	.cfi_def_cfa_offset 64
	movq	%rdi, %rbp
	movq	%fs:40, %rax
	movq	%rax, 24(%rsp)
	xorl	%eax, %eax
	movl	$0, %esi
	movl	$17, %edi
	call	signal@PLT
	movl	$0, %eax
	call	benchmp_childid@PLT
	movl	%eax, %edi
	movl	$1, %edx
	movl	$0, %esi
	call	handle_scheduler@PLT
	testq	%rbp, %rbp
	je	.L28
	leaq	-1(%rbp), %rbx
	leaq	.LC1(%rip), %rbp
.L33:
	movq	%rbp, (%rsp)
	movq	$0, 8(%rsp)
	call	fork@PLT
	movl	%eax, %edi
	movl	%eax, child_pid(%rip)
	cmpl	$-1, %eax
	je	.L30
	testl	%eax, %eax
	je	.L38
	movl	$0, %edx
	movl	$0, %esi
	call	waitpid@PLT
	movl	$0, child_pid(%rip)
	subq	$1, %rbx
	cmpq	$-1, %rbx
	jne	.L33
.L28:
	movq	24(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L39
	addq	$40, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
.L30:
	.cfi_restore_state
	leaq	.LC0(%rip), %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L38:
	movl	$0, %eax
	call	benchmp_childid@PLT
	movl	%eax, %edi
	movl	$1, %edx
	movl	$1, %esi
	call	handle_scheduler@PLT
	movl	$1, %edi
	call	close@PLT
	movq	%rsp, %rsi
	movl	$0, %edx
	leaq	.LC1(%rip), %rdi
	call	execve@PLT
	movl	$1, %edi
	call	exit@PLT
.L39:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE75:
	.size	do_forkexec, .-do_forkexec
	.globl	do_procedure
	.type	do_procedure, @function
do_procedure:
.LFB77:
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
	movq	%rdi, %r12
	movl	(%rsi), %ebp
	movl	$0, %eax
	call	benchmp_childid@PLT
	movl	%eax, %edi
	movl	$1, %edx
	movl	$0, %esi
	call	handle_scheduler@PLT
	leaq	-1(%r12), %rbx
	testq	%r12, %r12
	je	.L40
.L42:
	movl	%ebp, %edi
	call	use_int@PLT
	subq	$1, %rbx
	cmpq	$-1, %rbx
	jne	.L42
.L40:
	popq	%rbx
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE77:
	.size	do_procedure, .-do_procedure
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC5:
	.string	"[-P <parallelism>] [-W <warmup>] [-N <repetitions>] procedure|fork|exec|shell\n"
	.section	.rodata.str1.1
.LC6:
	.string	"P:W:N:"
.LC7:
	.string	"procedure"
.LC8:
	.string	"Procedure call"
.LC9:
	.string	"Process fork+exit"
.LC10:
	.string	"exec"
.LC11:
	.string	"Process fork+execve"
.LC12:
	.string	"shell"
.LC13:
	.string	"Process fork+/bin/sh -c"
	.text
	.globl	main
	.type	main, @function
main:
.LFB73:
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
	movl	%edi, 12(%rsp)
	movq	%rsi, %rbx
	movl	$-1, %r13d
	movl	$0, %r12d
	movl	$1, %r14d
	leaq	.LC6(%rip), %rbp
	leaq	.LC5(%rip), %r15
	jmp	.L46
.L47:
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	movl	%eax, %r14d
	testl	%eax, %eax
	jg	.L46
	movq	%r15, %rdx
	movq	%rbx, %rsi
	movl	12(%rsp), %edi
	call	lmbench_usage@PLT
	jmp	.L46
.L48:
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	movl	%eax, %r12d
.L46:
	movq	%rbp, %rdx
	movq	%rbx, %rsi
	movl	12(%rsp), %edi
	call	mygetopt@PLT
	cmpl	$-1, %eax
	je	.L61
	cmpl	$80, %eax
	je	.L47
	cmpl	$87, %eax
	je	.L48
	cmpl	$78, %eax
	je	.L62
	movq	%r15, %rdx
	movq	%rbx, %rsi
	movl	12(%rsp), %edi
	call	lmbench_usage@PLT
	jmp	.L46
.L62:
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	movl	%eax, %r13d
	jmp	.L46
.L61:
	movl	12(%rsp), %edi
	movl	myoptind(%rip), %eax
	addl	$1, %eax
	cmpl	%edi, %eax
	jne	.L63
.L53:
	movslq	myoptind(%rip), %rax
	movq	(%rbx,%rax,8), %rbp
	movq	%rbp, %rsi
	leaq	.LC7(%rip), %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	je	.L64
	movq	%rbp, %rsi
	leaq	.LC0(%rip), %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	je	.L65
	movq	%rbp, %rsi
	leaq	.LC10(%rip), %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	je	.L66
	movq	%rbp, %rsi
	leaq	.LC12(%rip), %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L58
	pushq	$0
	.cfi_def_cfa_offset 88
	pushq	%r13
	.cfi_def_cfa_offset 96
	movl	%r12d, %r9d
	movl	%r14d, %r8d
	movl	$0, %ecx
	leaq	cleanup(%rip), %rdx
	leaq	do_shell(%rip), %rsi
	movl	$0, %edi
	call	benchmp@PLT
	call	get_n@PLT
	movq	%rax, %rsi
	leaq	.LC13(%rip), %rdi
	call	micro@PLT
	addq	$16, %rsp
	.cfi_def_cfa_offset 80
	jmp	.L55
.L63:
	leaq	.LC5(%rip), %rdx
	movq	%rbx, %rsi
	call	lmbench_usage@PLT
	jmp	.L53
.L64:
	leaq	12(%rsp), %rax
	pushq	%rax
	.cfi_def_cfa_offset 88
	pushq	%r13
	.cfi_def_cfa_offset 96
	movl	%r12d, %r9d
	movl	%r14d, %r8d
	movl	$0, %ecx
	leaq	cleanup(%rip), %rdx
	leaq	do_procedure(%rip), %rsi
	movl	$0, %edi
	call	benchmp@PLT
	call	get_n@PLT
	movq	%rax, %rsi
	leaq	.LC8(%rip), %rdi
	call	micro@PLT
	addq	$16, %rsp
	.cfi_def_cfa_offset 80
.L55:
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
.L65:
	.cfi_restore_state
	pushq	$0
	.cfi_def_cfa_offset 88
	pushq	%r13
	.cfi_def_cfa_offset 96
	movl	%r12d, %r9d
	movl	%r14d, %r8d
	movl	$0, %ecx
	leaq	cleanup(%rip), %rdx
	leaq	do_fork(%rip), %rsi
	movl	$0, %edi
	call	benchmp@PLT
	call	get_n@PLT
	movq	%rax, %rsi
	leaq	.LC9(%rip), %rdi
	call	micro@PLT
	addq	$16, %rsp
	.cfi_def_cfa_offset 80
	jmp	.L55
.L66:
	pushq	$0
	.cfi_def_cfa_offset 88
	pushq	%r13
	.cfi_def_cfa_offset 96
	movl	%r12d, %r9d
	movl	%r14d, %r8d
	movl	$0, %ecx
	leaq	cleanup(%rip), %rdx
	leaq	do_forkexec(%rip), %rsi
	movl	$0, %edi
	call	benchmp@PLT
	call	get_n@PLT
	movq	%rax, %rsi
	leaq	.LC11(%rip), %rdi
	call	micro@PLT
	addq	$16, %rsp
	.cfi_def_cfa_offset 80
	jmp	.L55
.L58:
	leaq	.LC5(%rip), %rdx
	movq	%rbx, %rsi
	movl	12(%rsp), %edi
	call	lmbench_usage@PLT
	jmp	.L55
	.cfi_endproc
.LFE73:
	.size	main, .-main
	.globl	child_pid
	.bss
	.align 4
	.type	child_pid, @object
	.size	child_pid, 4
child_pid:
	.zero	4
	.globl	id
	.section	.rodata.str1.1
.LC14:
	.string	"$Id$\n"
	.section	.data.rel.local,"aw"
	.align 8
	.type	id, @object
	.size	id, 8
id:
	.quad	.LC14
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
