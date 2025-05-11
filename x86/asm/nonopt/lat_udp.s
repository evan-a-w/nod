	.file	"lat_udp.c"
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
	.string	"-s\n OR [-S] [-m <message size>] [-P <parallelism>] [-W <warmup>] [-N <repetitions>] server\n NOTE: message size must be >= 4\n"
.LC2:
	.string	"sS:m:P:W:N:"
.LC3:
	.string	"UDP latency using %s"
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
	subq	$368, %rsp
	movl	%edi, -356(%rbp)
	movq	%rsi, -368(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movl	$1, -340(%rbp)
	movl	$0, -336(%rbp)
	movl	$-1, -332(%rbp)
	movl	$4, -328(%rbp)
	leaq	.LC1(%rip), %rax
	movq	%rax, -312(%rbp)
	jmp	.L2
.L17:
	movl	-320(%rbp), %eax
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
	movq	$-31238, %rsi
	movq	%rax, %rdi
	call	udp_connect@PLT
	movl	%eax, -316(%rbp)
	movl	$-1, -324(%rbp)
	jmp	.L12
.L13:
	movl	-324(%rbp), %eax
	movl	%eax, %edi
	call	htonl@PLT
	movl	%eax, -304(%rbp)
	leaq	-304(%rbp), %rsi
	movl	-316(%rbp), %eax
	movl	$0, %ecx
	movl	$4, %edx
	movl	%eax, %edi
	call	send@PLT
	subl	$1, -324(%rbp)
.L12:
	cmpl	$-4, -324(%rbp)
	jge	.L13
	movl	-316(%rbp), %eax
	movl	%eax, %edi
	call	close@PLT
	movl	$0, %edi
	call	exit@PLT
.L6:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -328(%rbp)
	movl	-328(%rbp), %eax
	cmpl	$3, %eax
	ja	.L14
	movq	-312(%rbp), %rdx
	movq	-368(%rbp), %rcx
	movl	-356(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	lmbench_usage@PLT
	movl	$4, -328(%rbp)
.L14:
	cmpl	$10485760, -328(%rbp)
	jle	.L2
	movq	-312(%rbp), %rdx
	movq	-368(%rbp), %rcx
	movl	-356(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	lmbench_usage@PLT
	movl	$10485760, -328(%rbp)
	jmp	.L2
.L9:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -340(%rbp)
	cmpl	$0, -340(%rbp)
	jg	.L2
	movq	-312(%rbp), %rdx
	movq	-368(%rbp), %rcx
	movl	-356(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	lmbench_usage@PLT
	jmp	.L2
.L7:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -336(%rbp)
	jmp	.L2
.L10:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -332(%rbp)
	jmp	.L2
.L3:
	movq	-312(%rbp), %rdx
	movq	-368(%rbp), %rcx
	movl	-356(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	lmbench_usage@PLT
	nop
.L2:
	movq	-368(%rbp), %rcx
	movl	-356(%rbp), %eax
	leaq	.LC2(%rip), %rdx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	mygetopt@PLT
	movl	%eax, -320(%rbp)
	cmpl	$-1, -320(%rbp)
	jne	.L17
	movl	myoptind(%rip), %eax
	addl	$1, %eax
	cmpl	%eax, -356(%rbp)
	je	.L18
	movq	-312(%rbp), %rdx
	movq	-368(%rbp), %rcx
	movl	-356(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	lmbench_usage@PLT
.L18:
	movl	myoptind(%rip), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-368(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	%rax, -288(%rbp)
	movl	-328(%rbp), %eax
	movl	%eax, -296(%rbp)
	movl	-336(%rbp), %ecx
	movl	-340(%rbp), %edx
	leaq	-304(%rbp), %rax
	pushq	%rax
	movl	-332(%rbp), %eax
	pushq	%rax
	movl	%ecx, %r9d
	movl	%edx, %r8d
	movl	$1000000, %ecx
	leaq	cleanup(%rip), %rax
	movq	%rax, %rdx
	leaq	doit(%rip), %rax
	movq	%rax, %rsi
	leaq	init(%rip), %rax
	movq	%rax, %rdi
	call	benchmp@PLT
	addq	$16, %rsp
	movq	-288(%rbp), %rdx
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
	subq	$32, %rsp
	movq	%rdi, -24(%rbp)
	movq	%rsi, -32(%rbp)
	movq	-32(%rbp), %rax
	movq	%rax, -8(%rbp)
	cmpq	$0, -24(%rbp)
	jne	.L24
	movq	-8(%rbp), %rax
	movq	16(%rax), %rax
	movl	$0, %edx
	movq	$-31238, %rsi
	movq	%rax, %rdi
	call	udp_connect@PLT
	movq	-8(%rbp), %rdx
	movl	%eax, (%rdx)
	movq	-8(%rbp), %rax
	movl	$0, 4(%rax)
	movq	-8(%rbp), %rax
	movl	8(%rax), %eax
	cltq
	movq	%rax, %rdi
	call	malloc@PLT
	movq	%rax, %rdx
	movq	-8(%rbp), %rax
	movq	%rdx, 24(%rax)
	movq	-8(%rbp), %rax
	movq	24(%rax), %rax
	testq	%rax, %rax
	jne	.L23
	leaq	.LC4(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L23:
	leaq	timeout(%rip), %rax
	movq	%rax, %rsi
	movl	$14, %edi
	call	signal@PLT
	movl	$15, %edi
	call	alarm@PLT
	jmp	.L20
.L24:
	nop
.L20:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE9:
	.size	init, .-init
	.section	.rodata
.LC5:
	.string	"lat_udp client: send failed"
.LC6:
	.string	"lat_udp client: recv failed"
	.text
	.globl	doit
	.type	doit, @function
doit:
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
	movq	-8(%rbp), %rax
	movl	4(%rax), %eax
	movl	%eax, -16(%rbp)
	movq	-8(%rbp), %rax
	movl	(%rax), %eax
	movl	%eax, -12(%rbp)
	movl	$15, %edi
	call	alarm@PLT
	jmp	.L26
.L28:
	movl	-16(%rbp), %eax
	leal	1(%rax), %edx
	movl	%edx, -16(%rbp)
	movl	%eax, %edi
	call	htonl@PLT
	movl	%eax, %edx
	movq	-8(%rbp), %rax
	movq	24(%rax), %rax
	movl	%edx, (%rax)
	movq	-8(%rbp), %rax
	movl	8(%rax), %eax
	movslq	%eax, %rdx
	movq	-8(%rbp), %rax
	movq	24(%rax), %rsi
	movl	-12(%rbp), %eax
	movl	$0, %ecx
	movl	%eax, %edi
	call	send@PLT
	movq	-8(%rbp), %rdx
	movl	8(%rdx), %edx
	movslq	%edx, %rdx
	cmpq	%rdx, %rax
	je	.L27
	leaq	.LC5(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$5, %edi
	call	exit@PLT
.L27:
	movq	-8(%rbp), %rax
	movl	8(%rax), %eax
	movslq	%eax, %rdx
	movq	-8(%rbp), %rax
	movq	24(%rax), %rsi
	movl	-12(%rbp), %eax
	movl	$0, %ecx
	movl	%eax, %edi
	call	recv@PLT
	movq	-8(%rbp), %rdx
	movl	8(%rdx), %edx
	movslq	%edx, %rdx
	cmpq	%rdx, %rax
	je	.L26
	leaq	.LC6(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$5, %edi
	call	exit@PLT
.L26:
	movq	-24(%rbp), %rax
	leaq	-1(%rax), %rdx
	movq	%rdx, -24(%rbp)
	testq	%rax, %rax
	jne	.L28
	movq	-8(%rbp), %rax
	movl	-16(%rbp), %edx
	movl	%edx, 4(%rax)
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE10:
	.size	doit, .-doit
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
	movq	%rdi, -24(%rbp)
	movq	%rsi, -32(%rbp)
	movq	-32(%rbp), %rax
	movq	%rax, -8(%rbp)
	cmpq	$0, -24(%rbp)
	jne	.L32
	movq	-8(%rbp), %rax
	movl	(%rax), %eax
	movl	%eax, %edi
	call	close@PLT
	movq	-8(%rbp), %rax
	movq	24(%rax), %rax
	movq	%rax, %rdi
	call	free@PLT
	jmp	.L29
.L32:
	nop
.L29:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE11:
	.size	cleanup, .-cleanup
	.section	.rodata
.LC7:
	.string	"Recv timed out\n"
	.text
	.globl	timeout
	.type	timeout, @function
timeout:
.LFB12:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	stderr(%rip), %rax
	movq	%rax, %rcx
	movl	$15, %edx
	movl	$1, %esi
	leaq	.LC7(%rip), %rax
	movq	%rax, %rdi
	call	fwrite@PLT
	movl	$1, %edi
	call	exit@PLT
	.cfi_endproc
.LFE12:
	.size	timeout, .-timeout
	.section	.rodata
	.align 8
.LC8:
	.string	"lat_udp server: recvfrom: got wrong size\n"
.LC9:
	.string	"lat_udp sendto"
	.text
	.globl	server_main
	.type	server_main, @function
server_main:
.LFB13:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$64, %rsp
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movl	$10485760, %edi
	call	valloc@PLT
	movq	%rax, -40(%rbp)
	movl	$0, -56(%rbp)
	cmpq	$0, -40(%rbp)
	jne	.L35
	leaq	.LC4(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$4, %edi
	call	exit@PLT
.L35:
	movq	exit@GOTPCREL(%rip), %rax
	movq	%rax, %rsi
	movl	$14, %edi
	call	signal@PLT
	movl	$3600, %edi
	call	alarm@PLT
	movl	$8, %esi
	movq	$-31238, %rdi
	call	udp_server@PLT
	movl	%eax, -52(%rbp)
.L40:
	movl	$16, -60(%rbp)
	leaq	-60(%rbp), %rcx
	leaq	-32(%rbp), %rdx
	movq	-40(%rbp), %rsi
	movl	-52(%rbp), %eax
	movq	%rcx, %r9
	movq	%rdx, %r8
	movl	$0, %ecx
	movl	$10485760, %edx
	movl	%eax, %edi
	call	recvfrom@PLT
	movl	%eax, -48(%rbp)
	cmpl	$0, -48(%rbp)
	jns	.L36
	movq	stderr(%rip), %rax
	movq	%rax, %rcx
	movl	$41, %edx
	movl	$1, %esi
	leaq	.LC8(%rip), %rax
	movq	%rax, %rdi
	call	fwrite@PLT
	movl	$9, %edi
	call	exit@PLT
.L36:
	movq	-40(%rbp), %rax
	movl	(%rax), %eax
	movl	%eax, %edi
	call	ntohl@PLT
	movl	%eax, -44(%rbp)
	cmpl	$0, -44(%rbp)
	jns	.L37
	movq	$-31238, %rdi
	call	udp_done@PLT
	movl	$0, %edi
	call	exit@PLT
.L37:
	addl	$1, -56(%rbp)
	movl	-56(%rbp), %eax
	cmpl	-44(%rbp), %eax
	je	.L38
	movl	-44(%rbp), %eax
	movl	%eax, -56(%rbp)
.L38:
	movl	-56(%rbp), %eax
	movl	%eax, %edi
	call	htonl@PLT
	movl	%eax, %edx
	movq	-40(%rbp), %rax
	movl	%edx, (%rax)
	movl	-48(%rbp), %eax
	movslq	%eax, %rdx
	leaq	-32(%rbp), %rcx
	movq	-40(%rbp), %rsi
	movl	-52(%rbp), %eax
	movl	$16, %r9d
	movq	%rcx, %r8
	movl	$0, %ecx
	movl	%eax, %edi
	call	sendto@PLT
	testq	%rax, %rax
	jns	.L40
	leaq	.LC9(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$9, %edi
	call	exit@PLT
	.cfi_endproc
.LFE13:
	.size	server_main, .-server_main
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
