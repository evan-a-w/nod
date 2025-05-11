	.file	"lat_tcp.c"
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
	.string	"-s\n OR [-m <message size>] [-P <parallelism>] [-W <warmup>] [-N <repetitions>] server\n OR -S server\n"
.LC2:
	.string	"sS:m:P:W:N:"
.LC3:
	.string	"TCP latency using %s"
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
	subq	$352, %rsp
	movl	%edi, -340(%rbp)
	movq	%rsi, -352(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movl	$1, -328(%rbp)
	movl	$0, -324(%rbp)
	movl	$-1, -320(%rbp)
	leaq	.LC1(%rip), %rax
	movq	%rax, -312(%rbp)
	movl	$1, -304(%rbp)
	jmp	.L2
.L13:
	movl	-316(%rbp), %eax
	subl	$78, %eax
	cmpl	$37, %eax
	ja	.L3
	movl	%eax, %eax
	leaq	0(,%rax,4), %rdx
	leaq	.L5(%rip), %rax
	movl	(%rdx,%rax), %eax
	cltq
	leaq	.L5(%rip), %rdx
	addq	%rdx, %rax
	notrack jmp	*%rax
	.section	.rodata
	.align 4
	.align 4
.L5:
	.long	.L10-.L5
	.long	.L3-.L5
	.long	.L9-.L5
	.long	.L3-.L5
	.long	.L3-.L5
	.long	.L8-.L5
	.long	.L3-.L5
	.long	.L3-.L5
	.long	.L3-.L5
	.long	.L7-.L5
	.long	.L3-.L5
	.long	.L3-.L5
	.long	.L3-.L5
	.long	.L3-.L5
	.long	.L3-.L5
	.long	.L3-.L5
	.long	.L3-.L5
	.long	.L3-.L5
	.long	.L3-.L5
	.long	.L3-.L5
	.long	.L3-.L5
	.long	.L3-.L5
	.long	.L3-.L5
	.long	.L3-.L5
	.long	.L3-.L5
	.long	.L3-.L5
	.long	.L3-.L5
	.long	.L3-.L5
	.long	.L3-.L5
	.long	.L3-.L5
	.long	.L3-.L5
	.long	.L6-.L5
	.long	.L3-.L5
	.long	.L3-.L5
	.long	.L3-.L5
	.long	.L3-.L5
	.long	.L3-.L5
	.long	.L4-.L5
	.text
.L4:
	call	fork@PLT
	testl	%eax, %eax
	jne	.L11
	movl	$0, %eax
	call	server_main
.L11:
	movl	$0, %edi
	call	exit@PLT
.L8:
	movq	myoptarg(%rip), %rax
	movl	$0, %edx
	movl	$-31234, %esi
	movq	%rax, %rdi
	call	tcp_connect@PLT
	movl	%eax, -300(%rbp)
	movl	-300(%rbp), %eax
	movl	%eax, %edi
	call	close@PLT
	movl	$0, %edi
	call	exit@PLT
.L6:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -304(%rbp)
	jmp	.L2
.L9:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -328(%rbp)
	cmpl	$0, -328(%rbp)
	jg	.L2
	movq	-312(%rbp), %rdx
	movq	-352(%rbp), %rcx
	movl	-340(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	lmbench_usage@PLT
	jmp	.L2
.L7:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -324(%rbp)
	jmp	.L2
.L10:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -320(%rbp)
	jmp	.L2
.L3:
	movq	-312(%rbp), %rdx
	movq	-352(%rbp), %rcx
	movl	-340(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	lmbench_usage@PLT
	nop
.L2:
	movq	-352(%rbp), %rcx
	movl	-340(%rbp), %eax
	leaq	.LC2(%rip), %rdx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	mygetopt@PLT
	movl	%eax, -316(%rbp)
	cmpl	$-1, -316(%rbp)
	jne	.L13
	movl	-340(%rbp), %eax
	leal	-1(%rax), %edx
	movl	myoptind(%rip), %eax
	cmpl	%eax, %edx
	je	.L14
	movq	-312(%rbp), %rdx
	movq	-352(%rbp), %rcx
	movl	-340(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	lmbench_usage@PLT
.L14:
	movl	myoptind(%rip), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-352(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	%rax, -296(%rbp)
	movl	-324(%rbp), %ecx
	movl	-328(%rbp), %edx
	leaq	-304(%rbp), %rax
	pushq	%rax
	movl	-320(%rbp), %eax
	pushq	%rax
	movl	%ecx, %r9d
	movl	%edx, %r8d
	movl	$2000000, %ecx
	leaq	cleanup(%rip), %rax
	movq	%rax, %rdx
	leaq	doclient(%rip), %rax
	movq	%rax, %rsi
	leaq	init(%rip), %rax
	movq	%rax, %rdi
	call	benchmp@PLT
	addq	$16, %rsp
	movq	-296(%rbp), %rdx
	leaq	-272(%rbp), %rax
	leaq	.LC3(%rip), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	sprintf@PLT
	call	get_n@PLT
	movq	%rax, %rdx
	leaq	-272(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	micro@PLT
	movl	$0, %edi
	call	exit@PLT
	.cfi_endproc
.LFE8:
	.size	main, .-main
	.section	.rodata
.LC4:
	.string	"malloc"
	.text
	.globl	init
	.type	init, @function
init:
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
	movq	-16(%rbp), %rax
	movl	(%rax), %eax
	movl	%eax, %edi
	call	htonl@PLT
	movl	%eax, -20(%rbp)
	cmpq	$0, -40(%rbp)
	jne	.L21
	movq	-16(%rbp), %rax
	movq	8(%rax), %rax
	movl	$0, %edx
	movl	$-31234, %esi
	movq	%rax, %rdi
	call	tcp_connect@PLT
	movq	-16(%rbp), %rdx
	movl	%eax, 4(%rdx)
	movq	-16(%rbp), %rax
	movl	(%rax), %eax
	cltq
	movq	%rax, %rdi
	call	malloc@PLT
	movq	%rax, %rdx
	movq	-16(%rbp), %rax
	movq	%rdx, 16(%rax)
	movq	-16(%rbp), %rax
	movq	16(%rax), %rax
	testq	%rax, %rax
	jne	.L19
	leaq	.LC4(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L19:
	movq	-16(%rbp), %rax
	movl	4(%rax), %eax
	leaq	-20(%rbp), %rcx
	movl	$4, %edx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	write@PLT
	jmp	.L16
.L21:
	nop
.L16:
	movq	-8(%rbp), %rax
	subq	%fs:40, %rax
	je	.L20
	call	__stack_chk_fail@PLT
.L20:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE9:
	.size	init, .-init
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
	jne	.L25
	movq	-8(%rbp), %rax
	movl	4(%rax), %eax
	movl	%eax, %edi
	call	close@PLT
	movq	-8(%rbp), %rax
	movq	16(%rax), %rax
	movq	%rax, %rdi
	call	free@PLT
	jmp	.L22
.L25:
	nop
.L22:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE10:
	.size	cleanup, .-cleanup
	.globl	doclient
	.type	doclient, @function
doclient:
.LFB11:
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
	movq	-8(%rbp), %rax
	movl	4(%rax), %eax
	movl	%eax, -12(%rbp)
	jmp	.L27
.L28:
	movq	-8(%rbp), %rax
	movl	(%rax), %eax
	movslq	%eax, %rdx
	movq	-8(%rbp), %rax
	movq	16(%rax), %rcx
	movl	-12(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	write@PLT
	movq	-8(%rbp), %rax
	movl	(%rax), %eax
	movslq	%eax, %rdx
	movq	-8(%rbp), %rax
	movq	16(%rax), %rcx
	movl	-12(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	read@PLT
.L27:
	movq	-24(%rbp), %rax
	leaq	-1(%rax), %rdx
	movq	%rdx, -24(%rbp)
	testq	%rax, %rax
	jne	.L28
	nop
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE11:
	.size	doclient, .-doclient
	.section	.rodata
.LC5:
	.string	"fork"
	.text
	.globl	server_main
	.type	server_main, @function
server_main:
.LFB12:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movq	exit@GOTPCREL(%rip), %rax
	movq	%rax, %rsi
	movl	$14, %edi
	call	signal@PLT
	movl	$3600, %edi
	call	alarm@PLT
	movq	sigchld_wait_handler@GOTPCREL(%rip), %rax
	movq	%rax, %rsi
	movl	$17, %edi
	call	signal@PLT
	movl	$8, %esi
	movl	$-31234, %edi
	call	tcp_server@PLT
	movl	%eax, -8(%rbp)
.L34:
	movl	-8(%rbp), %eax
	movl	$0, %esi
	movl	%eax, %edi
	call	tcp_accept@PLT
	movl	%eax, -4(%rbp)
	call	fork@PLT
	cmpl	$-1, %eax
	je	.L30
	testl	%eax, %eax
	je	.L31
	jmp	.L35
.L30:
	leaq	.LC5(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	jmp	.L33
.L31:
	movl	-4(%rbp), %eax
	movl	%eax, %edi
	call	doserver
	movl	$0, %edi
	call	exit@PLT
.L35:
	movl	-4(%rbp), %eax
	movl	%eax, %edi
	call	close@PLT
	nop
.L33:
	jmp	.L34
	.cfi_endproc
.LFE12:
	.size	server_main, .-server_main
	.globl	doserver
	.type	doserver, @function
doserver:
.LFB13:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$48, %rsp
	movl	%edi, -36(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	leaq	-24(%rbp), %rcx
	movl	-36(%rbp), %eax
	movl	$4, %edx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	read@PLT
	cmpq	$4, %rax
	jne	.L37
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	ntohl@PLT
	movl	%eax, -20(%rbp)
	movl	-20(%rbp), %eax
	cltq
	movq	%rax, %rdi
	call	malloc@PLT
	movq	%rax, -16(%rbp)
	cmpq	$0, -16(%rbp)
	jne	.L38
	leaq	.LC4(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$4, %edi
	call	exit@PLT
.L38:
	movl	$0, -24(%rbp)
	jmp	.L39
.L40:
	movl	-20(%rbp), %eax
	movslq	%eax, %rdx
	movq	-16(%rbp), %rcx
	movl	-36(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	write@PLT
	movl	-24(%rbp), %eax
	addl	$1, %eax
	movl	%eax, -24(%rbp)
.L39:
	movl	-20(%rbp), %eax
	movslq	%eax, %rdx
	movq	-16(%rbp), %rcx
	movl	-36(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	read@PLT
	testq	%rax, %rax
	jg	.L40
	movq	-16(%rbp), %rax
	movq	%rax, %rdi
	call	free@PLT
	nop
	movq	-8(%rbp), %rax
	subq	%fs:40, %rax
	je	.L41
	jmp	.L42
.L37:
	movl	$-31234, %edi
	call	tcp_done@PLT
	call	getppid@PLT
	movl	$15, %esi
	movl	%eax, %edi
	call	kill@PLT
	movl	$0, %edi
	call	exit@PLT
.L42:
	call	__stack_chk_fail@PLT
.L41:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE13:
	.size	doserver, .-doserver
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
