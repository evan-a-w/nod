	.file	"lat_udp.c"
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
	testq	%rdi, %rdi
	je	.L8
	ret
.L8:
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movq	%rsi, %rbx
	movq	16(%rsi), %rdi
	movl	$0, %edx
	movq	$-31238, %rsi
	call	udp_connect@PLT
	movl	%eax, (%rbx)
	movl	$0, 4(%rbx)
	movslq	8(%rbx), %rdi
	call	malloc@PLT
	movq	%rax, 24(%rbx)
	testq	%rax, %rax
	je	.L9
	leaq	timeout(%rip), %rsi
	movl	$14, %edi
	call	signal@PLT
	movl	$15, %edi
	call	alarm@PLT
	popq	%rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	ret
.L9:
	.cfi_restore_state
	leaq	.LC0(%rip), %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
	.cfi_endproc
.LFE73:
	.size	init, .-init
	.section	.rodata.str1.1
.LC1:
	.string	"lat_udp client: send failed"
.LC2:
	.string	"lat_udp client: recv failed"
	.text
	.globl	doit
	.type	doit, @function
doit:
.LFB74:
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
	subq	$8, %rsp
	.cfi_def_cfa_offset 48
	movq	%rdi, %r12
	movq	%rsi, %rbx
	movl	4(%rsi), %ebp
	movl	(%rsi), %r13d
	movl	$15, %edi
	call	alarm@PLT
.L11:
	testq	%r12, %r12
	je	.L16
	movq	24(%rbx), %rdx
	movl	%ebp, %eax
	bswap	%eax
	movl	%eax, (%rdx)
	movslq	8(%rbx), %rdx
	movq	24(%rbx), %rsi
	movl	$0, %ecx
	movl	%r13d, %edi
	call	send@PLT
	movq	%rax, %rcx
	movl	8(%rbx), %edx
	movslq	%edx, %rax
	cmpq	%rax, %rcx
	jne	.L17
	movslq	%edx, %rdx
	movq	24(%rbx), %rsi
	movl	$0, %ecx
	movl	%r13d, %edi
	call	recv@PLT
	subq	$1, %r12
	addl	$1, %ebp
	movslq	8(%rbx), %rdx
	cmpq	%rax, %rdx
	je	.L11
	leaq	.LC2(%rip), %rdi
	call	perror@PLT
	movl	$5, %edi
	call	exit@PLT
.L17:
	leaq	.LC1(%rip), %rdi
	call	perror@PLT
	movl	$5, %edi
	call	exit@PLT
.L16:
	movl	%ebp, 4(%rbx)
	addq	$8, %rsp
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
	.cfi_endproc
.LFE74:
	.size	doit, .-doit
	.globl	cleanup
	.type	cleanup, @function
cleanup:
.LFB75:
	.cfi_startproc
	endbr64
	testq	%rdi, %rdi
	je	.L24
	ret
.L24:
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movq	%rsi, %rbx
	movl	(%rsi), %edi
	call	close@PLT
	movq	24(%rbx), %rdi
	call	free@PLT
	popq	%rbx
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE75:
	.size	cleanup, .-cleanup
	.section	.rodata.str1.1
.LC3:
	.string	"Recv timed out\n"
	.text
	.globl	timeout
	.type	timeout, @function
timeout:
.LFB76:
	.cfi_startproc
	endbr64
	pushq	%rax
	.cfi_def_cfa_offset 16
	popq	%rax
	.cfi_def_cfa_offset 8
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	movq	stderr(%rip), %rcx
	movl	$15, %edx
	movl	$1, %esi
	leaq	.LC3(%rip), %rdi
	call	fwrite@PLT
	movl	$1, %edi
	call	exit@PLT
	.cfi_endproc
.LFE76:
	.size	timeout, .-timeout
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC4:
	.string	"lat_udp server: recvfrom: got wrong size\n"
	.section	.rodata.str1.1
.LC5:
	.string	"lat_udp sendto"
	.text
	.globl	server_main
	.type	server_main, @function
server_main:
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
	subq	$48, %rsp
	.cfi_def_cfa_offset 80
	movq	%fs:40, %rax
	movq	%rax, 40(%rsp)
	xorl	%eax, %eax
	movl	$10485760, %edi
	call	valloc@PLT
	testq	%rax, %rax
	je	.L35
	movq	%rax, %rbx
	movq	exit@GOTPCREL(%rip), %rsi
	movl	$14, %edi
	call	signal@PLT
	movl	$3600, %edi
	call	alarm@PLT
	movl	$8, %esi
	movq	$-31238, %rdi
	call	udp_server@PLT
	movl	%eax, %ebp
	leaq	12(%rsp), %r12
.L31:
	movl	$16, 12(%rsp)
	movq	%r12, %r9
	leaq	16(%rsp), %r8
	movl	$0, %ecx
	movl	$10485760, %edx
	movq	%rbx, %rsi
	movl	%ebp, %edi
	call	recvfrom@PLT
	testl	%eax, %eax
	js	.L36
	movl	(%rbx), %edx
	bswap	%edx
	testl	%edx, %edx
	js	.L37
	movslq	%eax, %rdx
	movl	$16, %r9d
	leaq	16(%rsp), %r8
	movl	$0, %ecx
	movq	%rbx, %rsi
	movl	%ebp, %edi
	call	sendto@PLT
	testq	%rax, %rax
	jns	.L31
	leaq	.LC5(%rip), %rdi
	call	perror@PLT
	movl	$9, %edi
	call	exit@PLT
.L35:
	leaq	.LC0(%rip), %rdi
	call	perror@PLT
	movl	$4, %edi
	call	exit@PLT
.L36:
	movq	stderr(%rip), %rcx
	movl	$41, %edx
	movl	$1, %esi
	leaq	.LC4(%rip), %rdi
	call	fwrite@PLT
	movl	$9, %edi
	call	exit@PLT
.L37:
	movq	$-31238, %rdi
	call	udp_done@PLT
	movl	$0, %edi
	call	exit@PLT
	.cfi_endproc
.LFE77:
	.size	server_main, .-server_main
	.section	.rodata.str1.8
	.align 8
.LC6:
	.string	"-s\n OR [-S] [-m <message size>] [-P <parallelism>] [-W <warmup>] [-N <repetitions>] server\n NOTE: message size must be >= 4\n"
	.section	.rodata.str1.1
.LC7:
	.string	"sS:m:P:W:N:"
.LC8:
	.string	"UDP latency using %s"
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
	movl	$4, %r15d
	movl	$-1, 12(%rsp)
	movl	$0, 8(%rsp)
	movl	$1, 4(%rsp)
	leaq	.LC7(%rip), %r13
	leaq	.LC6(%rip), %r14
	leaq	.L42(%rip), %r12
.L39:
	movq	%r13, %rdx
	movq	%rbx, %rsi
	movl	%ebp, %edi
	call	mygetopt@PLT
	cmpl	$-1, %eax
	je	.L57
	subl	$78, %eax
	cmpl	$37, %eax
	ja	.L40
	movl	%eax, %eax
	movslq	(%r12,%rax,4), %rax
	addq	%r12, %rax
	notrack jmp	*%rax
	.section	.rodata
	.align 4
	.align 4
.L42:
	.long	.L47-.L42
	.long	.L40-.L42
	.long	.L46-.L42
	.long	.L40-.L42
	.long	.L40-.L42
	.long	.L45-.L42
	.long	.L40-.L42
	.long	.L40-.L42
	.long	.L40-.L42
	.long	.L44-.L42
	.long	.L40-.L42
	.long	.L40-.L42
	.long	.L40-.L42
	.long	.L40-.L42
	.long	.L40-.L42
	.long	.L40-.L42
	.long	.L40-.L42
	.long	.L40-.L42
	.long	.L40-.L42
	.long	.L40-.L42
	.long	.L40-.L42
	.long	.L40-.L42
	.long	.L40-.L42
	.long	.L40-.L42
	.long	.L40-.L42
	.long	.L40-.L42
	.long	.L40-.L42
	.long	.L40-.L42
	.long	.L40-.L42
	.long	.L40-.L42
	.long	.L40-.L42
	.long	.L43-.L42
	.long	.L40-.L42
	.long	.L40-.L42
	.long	.L40-.L42
	.long	.L40-.L42
	.long	.L40-.L42
	.long	.L41-.L42
	.text
.L41:
	call	fork@PLT
	testl	%eax, %eax
	jne	.L48
	call	server_main
.L48:
	movl	$0, %edi
	call	exit@PLT
.L45:
	movl	$0, %edx
	movq	$-31238, %rsi
	movq	myoptarg(%rip), %rdi
	call	udp_connect@PLT
	movl	%eax, %ebp
	movl	$-1, %ebx
	leaq	16(%rsp), %r12
.L49:
	movl	%ebx, %eax
	bswap	%eax
	movl	%eax, 16(%rsp)
	movl	$0, %ecx
	movl	$4, %edx
	movq	%r12, %rsi
	movl	%ebp, %edi
	call	send@PLT
	subl	$1, %ebx
	cmpl	$-5, %ebx
	jne	.L49
	movl	%ebp, %edi
	call	close@PLT
	movl	$0, %edi
	call	exit@PLT
.L43:
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	cmpl	$3, %eax
	jbe	.L58
	movl	%eax, %r15d
	cmpl	$10485760, %eax
	jle	.L39
	movq	%r14, %rdx
	movq	%rbx, %rsi
	movl	%ebp, %edi
	call	lmbench_usage@PLT
	movl	$10485760, %r15d
	jmp	.L39
.L58:
	movq	%r14, %rdx
	movq	%rbx, %rsi
	movl	%ebp, %edi
	call	lmbench_usage@PLT
	movl	$4, %r15d
	jmp	.L39
.L46:
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	movl	%eax, 4(%rsp)
	testl	%eax, %eax
	jg	.L39
	movq	%r14, %rdx
	movq	%rbx, %rsi
	movl	%ebp, %edi
	call	lmbench_usage@PLT
	jmp	.L39
.L44:
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	movl	%eax, 8(%rsp)
	jmp	.L39
.L47:
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	movl	%eax, 12(%rsp)
	jmp	.L39
.L40:
	movq	%r14, %rdx
	movq	%rbx, %rsi
	movl	%ebp, %edi
	call	lmbench_usage@PLT
	jmp	.L39
.L57:
	movl	myoptind(%rip), %eax
	addl	$1, %eax
	cmpl	%ebp, %eax
	jne	.L59
.L53:
	movslq	myoptind(%rip), %rax
	movq	(%rbx,%rax,8), %rax
	movq	%rax, 32(%rsp)
	movl	%r15d, 24(%rsp)
	leaq	16(%rsp), %rax
	pushq	%rax
	.cfi_remember_state
	.cfi_def_cfa_offset 392
	movl	20(%rsp), %eax
	pushq	%rax
	.cfi_def_cfa_offset 400
	movl	24(%rsp), %r9d
	movl	20(%rsp), %r8d
	movl	$1000000, %ecx
	leaq	cleanup(%rip), %rdx
	leaq	doit(%rip), %rsi
	leaq	init(%rip), %rdi
	call	benchmp@PLT
	leaq	64(%rsp), %rbx
	movq	48(%rsp), %r8
	leaq	.LC8(%rip), %rcx
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
.L59:
	.cfi_restore_state
	leaq	.LC6(%rip), %rdx
	movq	%rbx, %rsi
	movl	%ebp, %edi
	call	lmbench_usage@PLT
	jmp	.L53
	.cfi_endproc
.LFE72:
	.size	main, .-main
	.globl	id
	.section	.rodata.str1.1
.LC9:
	.string	"$Id$\n"
	.section	.data.rel.local,"aw"
	.align 8
	.type	id, @object
	.size	id, 8
id:
	.quad	.LC9
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
