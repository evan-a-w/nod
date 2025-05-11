	.file	"lat_tcp.c"
	.text
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"malloc"
	.text
	.globl	init
	.type	init, @function
init:
.LFB73:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushq	%rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	subq	$24, %rsp
	.cfi_def_cfa_offset 48
	movq	%fs:40, %rax
	movq	%rax, 8(%rsp)
	xorl	%eax, %eax
	movl	(%rsi), %eax
	bswap	%eax
	movl	%eax, 4(%rsp)
	testq	%rdi, %rdi
	je	.L6
.L1:
	movq	8(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L7
	addq	$24, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
.L6:
	.cfi_restore_state
	movq	%rsi, %rbx
	movq	8(%rsi), %rdi
	movl	$0, %edx
	movl	$-31234, %esi
	call	tcp_connect@PLT
	movl	%eax, %ebp
	movl	%eax, 4(%rbx)
	movslq	(%rbx), %rdi
	call	malloc@PLT
	movq	%rax, 16(%rbx)
	testq	%rax, %rax
	je	.L8
	leaq	4(%rsp), %rsi
	movl	$4, %edx
	movl	%ebp, %edi
	call	write@PLT
	jmp	.L1
.L8:
	leaq	.LC0(%rip), %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L7:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE73:
	.size	init, .-init
	.globl	cleanup
	.type	cleanup, @function
cleanup:
.LFB74:
	.cfi_startproc
	endbr64
	testq	%rdi, %rdi
	je	.L15
	ret
.L15:
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movq	%rsi, %rbx
	movl	4(%rsi), %edi
	call	close@PLT
	movq	16(%rbx), %rdi
	call	free@PLT
	popq	%rbx
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE74:
	.size	cleanup, .-cleanup
	.globl	doclient
	.type	doclient, @function
doclient:
.LFB75:
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
	movq	%rsi, %rbx
	movl	4(%rsi), %r12d
	leaq	-1(%rdi), %rbp
	testq	%rdi, %rdi
	je	.L16
.L18:
	movslq	(%rbx), %rdx
	movq	16(%rbx), %rsi
	movl	%r12d, %edi
	call	write@PLT
	movslq	(%rbx), %rdx
	movq	16(%rbx), %rsi
	movl	%r12d, %edi
	call	read@PLT
	subq	$1, %rbp
	cmpq	$-1, %rbp
	jne	.L18
.L16:
	popq	%rbx
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE75:
	.size	doclient, .-doclient
	.globl	doserver
	.type	doserver, @function
doserver:
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
	subq	$16, %rsp
	.cfi_def_cfa_offset 48
	movl	%edi, %ebx
	movq	%fs:40, %rax
	movq	%rax, 8(%rsp)
	xorl	%eax, %eax
	leaq	4(%rsp), %rsi
	movl	$4, %edx
	call	read@PLT
	cmpq	$4, %rax
	je	.L29
	movl	$-31234, %edi
	call	tcp_done@PLT
	call	getppid@PLT
	movl	%eax, %edi
	movl	$15, %esi
	call	kill@PLT
	movl	$0, %edi
	call	exit@PLT
.L29:
	movl	4(%rsp), %ebp
	bswap	%ebp
	movslq	%ebp, %rbp
	movq	%rbp, %rdi
	call	malloc@PLT
	movq	%rax, %r12
	testq	%rax, %rax
	je	.L30
	movl	$0, %eax
	jmp	.L23
.L30:
	leaq	.LC0(%rip), %rdi
	call	perror@PLT
	movl	$4, %edi
	call	exit@PLT
.L24:
	movq	%rbp, %rdx
	movq	%r12, %rsi
	movl	%ebx, %edi
	call	write@PLT
	movl	4(%rsp), %eax
	addl	$1, %eax
.L23:
	movl	%eax, 4(%rsp)
	movq	%rbp, %rdx
	movq	%r12, %rsi
	movl	%ebx, %edi
	call	read@PLT
	testq	%rax, %rax
	jg	.L24
	movq	%r12, %rdi
	call	free@PLT
	movq	8(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L31
	addq	$16, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 32
	popq	%rbx
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	ret
.L31:
	.cfi_restore_state
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE77:
	.size	doserver, .-doserver
	.section	.rodata.str1.1
.LC1:
	.string	"fork"
	.text
	.globl	server_main
	.type	server_main, @function
server_main:
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
	movq	exit@GOTPCREL(%rip), %rsi
	movl	$14, %edi
	call	signal@PLT
	movl	$3600, %edi
	call	alarm@PLT
	movq	sigchld_wait_handler@GOTPCREL(%rip), %rsi
	movl	$17, %edi
	call	signal@PLT
	movl	$8, %esi
	movl	$-31234, %edi
	call	tcp_server@PLT
	movl	%eax, %ebp
	leaq	.LC1(%rip), %r12
	jmp	.L33
.L34:
	movq	%r12, %rdi
	call	perror@PLT
.L33:
	movl	$0, %esi
	movl	%ebp, %edi
	call	tcp_accept@PLT
	movl	%eax, %ebx
	call	fork@PLT
	cmpl	$-1, %eax
	je	.L34
	testl	%eax, %eax
	je	.L35
	movl	%ebx, %edi
	call	close@PLT
	jmp	.L33
.L35:
	movl	%ebx, %edi
	call	doserver
	movl	$0, %edi
	call	exit@PLT
	.cfi_endproc
.LFE76:
	.size	server_main, .-server_main
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC2:
	.string	"-s\n OR [-m <message size>] [-P <parallelism>] [-W <warmup>] [-N <repetitions>] server\n OR -S server\n"
	.section	.rodata.str1.1
.LC3:
	.string	"sS:m:P:W:N:"
.LC4:
	.string	"TCP latency using %s"
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
	subq	$328, %rsp
	.cfi_def_cfa_offset 384
	movl	%edi, %ebp
	movq	%rsi, %rbx
	movq	%fs:40, %rax
	movq	%rax, 312(%rsp)
	xorl	%eax, %eax
	movl	$1, 16(%rsp)
	movl	$-1, %r14d
	movl	$0, 12(%rsp)
	movl	$1, 8(%rsp)
	leaq	.LC3(%rip), %r13
	leaq	.LC2(%rip), %r15
	leaq	.L44(%rip), %r12
.L41:
	movq	%r13, %rdx
	movq	%rbx, %rsi
	movl	%ebp, %edi
	call	mygetopt@PLT
	cmpl	$-1, %eax
	je	.L56
	subl	$78, %eax
	cmpl	$37, %eax
	ja	.L42
	movl	%eax, %eax
	movslq	(%r12,%rax,4), %rax
	addq	%r12, %rax
	notrack jmp	*%rax
	.section	.rodata
	.align 4
	.align 4
.L44:
	.long	.L49-.L44
	.long	.L42-.L44
	.long	.L48-.L44
	.long	.L42-.L44
	.long	.L42-.L44
	.long	.L47-.L44
	.long	.L42-.L44
	.long	.L42-.L44
	.long	.L42-.L44
	.long	.L46-.L44
	.long	.L42-.L44
	.long	.L42-.L44
	.long	.L42-.L44
	.long	.L42-.L44
	.long	.L42-.L44
	.long	.L42-.L44
	.long	.L42-.L44
	.long	.L42-.L44
	.long	.L42-.L44
	.long	.L42-.L44
	.long	.L42-.L44
	.long	.L42-.L44
	.long	.L42-.L44
	.long	.L42-.L44
	.long	.L42-.L44
	.long	.L42-.L44
	.long	.L42-.L44
	.long	.L42-.L44
	.long	.L42-.L44
	.long	.L42-.L44
	.long	.L42-.L44
	.long	.L45-.L44
	.long	.L42-.L44
	.long	.L42-.L44
	.long	.L42-.L44
	.long	.L42-.L44
	.long	.L42-.L44
	.long	.L43-.L44
	.text
.L43:
	call	fork@PLT
	testl	%eax, %eax
	jne	.L50
	call	server_main
.L50:
	movl	$0, %edi
	call	exit@PLT
.L47:
	movl	$0, %edx
	movl	$-31234, %esi
	movq	myoptarg(%rip), %rdi
	call	tcp_connect@PLT
	movl	%eax, %edi
	movl	%eax, 20(%rsp)
	call	close@PLT
	movl	$0, %edi
	call	exit@PLT
.L45:
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	movl	%eax, 16(%rsp)
	jmp	.L41
.L48:
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	movl	%eax, 8(%rsp)
	testl	%eax, %eax
	jg	.L41
	movq	%r15, %rdx
	movq	%rbx, %rsi
	movl	%ebp, %edi
	call	lmbench_usage@PLT
	jmp	.L41
.L46:
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	movl	%eax, 12(%rsp)
	jmp	.L41
.L49:
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	movl	%eax, %r14d
	jmp	.L41
.L42:
	movq	%r15, %rdx
	movq	%rbx, %rsi
	movl	%ebp, %edi
	call	lmbench_usage@PLT
	jmp	.L41
.L56:
	leal	-1(%rbp), %eax
	cmpl	myoptind(%rip), %eax
	jne	.L57
.L53:
	movslq	myoptind(%rip), %rax
	movq	(%rbx,%rax,8), %rax
	movq	%rax, 24(%rsp)
	leaq	16(%rsp), %rax
	pushq	%rax
	.cfi_remember_state
	.cfi_def_cfa_offset 392
	pushq	%r14
	.cfi_def_cfa_offset 400
	movl	28(%rsp), %r9d
	movl	24(%rsp), %r8d
	movl	$2000000, %ecx
	leaq	cleanup(%rip), %rdx
	leaq	doclient(%rip), %rsi
	leaq	init(%rip), %rdi
	call	benchmp@PLT
	leaq	64(%rsp), %rbx
	movq	40(%rsp), %r8
	leaq	.LC4(%rip), %rcx
	movl	$256, %edx
	movl	$1, %esi
	movq	%rbx, %rdi
	movl	$0, %eax
	call	__sprintf_chk@PLT
	call	get_n@PLT
	movq	%rax, %rsi
	movq	%rbx, %rdi
	call	micro@PLT
	movl	$0, %edi
	call	exit@PLT
.L57:
	.cfi_restore_state
	leaq	.LC2(%rip), %rdx
	movq	%rbx, %rsi
	movl	%ebp, %edi
	call	lmbench_usage@PLT
	jmp	.L53
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
