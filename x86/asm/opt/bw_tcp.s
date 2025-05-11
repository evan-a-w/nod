	.file	"bw_tcp.c"
	.text
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"valloc"
.LC1:
	.string	"socket connection"
.LC2:
	.string	"%lu"
.LC3:
	.string	"control write"
	.text
	.globl	initialize
	.type	initialize, @function
initialize:
.LFB73:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushq	%rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	subq	$120, %rsp
	.cfi_def_cfa_offset 144
	movq	%fs:40, %rax
	movq	%rax, 104(%rsp)
	xorl	%eax, %eax
	testq	%rdi, %rdi
	je	.L7
.L1:
	movq	104(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L8
	addq	$120, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
.L7:
	.cfi_restore_state
	movq	%rsi, %rbx
	movq	16(%rsi), %rdi
	call	valloc@PLT
	movq	%rax, %rdi
	movq	%rax, 40(%rbx)
	testq	%rax, %rax
	je	.L9
	movq	16(%rbx), %rsi
	call	touch@PLT
	movq	24(%rbx), %rdi
	movl	$11, %edx
	movl	$-31236, %esi
	call	tcp_connect@PLT
	movl	%eax, (%rbx)
	testl	%eax, %eax
	js	.L10
	movq	%rsp, %rbp
	movq	16(%rbx), %r8
	leaq	.LC2(%rip), %rcx
	movl	$100, %edx
	movl	$1, %esi
	movq	%rbp, %rdi
	movl	$0, %eax
	call	__sprintf_chk@PLT
	movq	%rbp, %rdi
	call	strlen@PLT
	leaq	1(%rax), %rdx
	movq	%rbp, %rsi
	movl	(%rbx), %edi
	call	write@PLT
	movq	%rax, %rbx
	movq	%rbp, %rdi
	call	strlen@PLT
	addq	$1, %rax
	cmpq	%rax, %rbx
	je	.L1
	leaq	.LC3(%rip), %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L9:
	leaq	.LC0(%rip), %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L10:
	leaq	.LC1(%rip), %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L8:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE73:
	.size	initialize, .-initialize
	.globl	loop_transfer
	.type	loop_transfer, @function
loop_transfer:
.LFB74:
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
	movq	%rsi, %rbp
	leaq	-1(%rdi), %r12
	testq	%rdi, %rdi
	jne	.L17
.L11:
	popq	%rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	ret
.L21:
	.cfi_restore_state
	movl	$1, %edi
	call	exit@PLT
.L13:
	subq	$1, %r12
	cmpq	$-1, %r12
	je	.L11
.L17:
	movq	8(%rbp), %rbx
	testq	%rbx, %rbx
	je	.L13
.L16:
	movq	16(%rbp), %rdx
	movq	40(%rbp), %rsi
	movl	0(%rbp), %edi
	call	read@PLT
	movl	%eax, %edx
	testl	%eax, %eax
	jle	.L21
	cltq
	cmpq	%rbx, %rax
	cmova	%ebx, %edx
	movslq	%edx, %rdx
	subq	%rdx, %rbx
	jne	.L16
	jmp	.L13
	.cfi_endproc
.LFE74:
	.size	loop_transfer, .-loop_transfer
	.globl	cleanup
	.type	cleanup, @function
cleanup:
.LFB75:
	.cfi_startproc
	endbr64
	testq	%rdi, %rdi
	je	.L28
	ret
.L28:
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	movl	(%rsi), %edi
	call	close@PLT
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE75:
	.size	cleanup, .-cleanup
	.section	.rodata.str1.1
.LC4:
	.string	"control nbytes"
	.text
	.globl	source
	.type	source, @function
source:
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
	addq	$-128, %rsp
	.cfi_def_cfa_offset 160
	movl	%edi, %ebp
	movq	%fs:40, %rax
	movq	%rax, 120(%rsp)
	xorl	%eax, %eax
	leaq	16(%rsp), %rsi
	movl	$12, %ecx
	movq	%rsi, %rdi
	rep stosq
	movl	$0, (%rdi)
	movl	$100, %edx
	movl	%ebp, %edi
	call	read@PLT
	testq	%rax, %rax
	jle	.L37
	leaq	8(%rsp), %rdx
	leaq	16(%rsp), %rdi
	leaq	.LC2(%rip), %rsi
	movl	$0, %eax
	call	__isoc99_sscanf@PLT
	movq	8(%rsp), %rbx
	testq	%rbx, %rbx
	jne	.L31
	movl	$-31236, %edi
	call	tcp_done@PLT
	call	getppid@PLT
	movl	%eax, %edi
	movl	$15, %esi
	call	kill@PLT
	movl	$0, %edi
	call	exit@PLT
.L37:
	leaq	.LC4(%rip), %rdi
	call	perror@PLT
	movl	$7, %edi
	call	exit@PLT
.L31:
	movq	%rbx, %rdi
	call	valloc@PLT
	movq	%rax, %r12
	testq	%rax, %rax
	je	.L38
	movq	%rbx, %rdx
	movl	$0, %esi
	movq	%rax, %rdi
	call	memset@PLT
.L33:
	movq	%rbx, %rdx
	movq	%r12, %rsi
	movl	%ebp, %edi
	call	write@PLT
	cmpq	%rbx, %rax
	je	.L33
	movq	%r12, %rdi
	call	free@PLT
	movq	120(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L39
	subq	$-128, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 32
	popq	%rbx
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	ret
.L38:
	.cfi_restore_state
	leaq	.LC0(%rip), %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L39:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE77:
	.size	source, .-source
	.section	.rodata.str1.1
.LC5:
	.string	"server socket creation"
.LC6:
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
	movl	$10, %esi
	movl	$-31236, %edi
	call	tcp_server@PLT
	testl	%eax, %eax
	js	.L49
	movl	%eax, %ebp
	movq	sigchld_wait_handler@GOTPCREL(%rip), %rsi
	movl	$17, %edi
	call	signal@PLT
	leaq	.LC6(%rip), %r12
	jmp	.L42
.L49:
	leaq	.LC5(%rip), %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L43:
	movq	%r12, %rdi
	call	perror@PLT
.L42:
	movl	$2, %esi
	movl	%ebp, %edi
	call	tcp_accept@PLT
	movl	%eax, %ebx
	call	fork@PLT
	cmpl	$-1, %eax
	je	.L43
	testl	%eax, %eax
	je	.L44
	movl	%ebx, %edi
	call	close@PLT
	jmp	.L42
.L44:
	movl	%ebx, %edi
	call	source
	movl	$0, %edi
	call	exit@PLT
	.cfi_endproc
.LFE76:
	.size	server_main, .-server_main
	.section	.rodata.str1.1
.LC7:
	.string	"0"
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC8:
	.string	"-s\n OR [-m <message size>] [-M <bytes to move>] [-P <parallelism>] [-W <warmup>] [-N <repetitions>] server\n OR -S serverhost\n"
	.section	.rodata.str1.1
.LC9:
	.string	"sS:m:M:P:W:N:"
.LC11:
	.string	"%.6f "
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
	subq	$88, %rsp
	.cfi_def_cfa_offset 144
	movl	%edi, %ebx
	movq	%rsi, %rbp
	movq	%fs:40, %rax
	movq	%rax, 72(%rsp)
	xorl	%eax, %eax
	movq	$0, 32(%rsp)
	movq	$0, 24(%rsp)
	movl	$-1, %r14d
	movl	$7500000, 12(%rsp)
	movl	$1, 8(%rsp)
	leaq	.LC9(%rip), %r13
	leaq	.LC8(%rip), %r15
	leaq	.L54(%rip), %r12
.L51:
	movq	%r13, %rdx
	movq	%rbp, %rsi
	movl	%ebx, %edi
	call	mygetopt@PLT
	cmpl	$-1, %eax
	je	.L77
	subl	$77, %eax
	cmpl	$38, %eax
	ja	.L52
	movl	%eax, %eax
	movslq	(%r12,%rax,4), %rax
	addq	%r12, %rax
	notrack jmp	*%rax
	.section	.rodata
	.align 4
	.align 4
.L54:
	.long	.L60-.L54
	.long	.L59-.L54
	.long	.L52-.L54
	.long	.L58-.L54
	.long	.L52-.L54
	.long	.L52-.L54
	.long	.L57-.L54
	.long	.L52-.L54
	.long	.L52-.L54
	.long	.L52-.L54
	.long	.L56-.L54
	.long	.L52-.L54
	.long	.L52-.L54
	.long	.L52-.L54
	.long	.L52-.L54
	.long	.L52-.L54
	.long	.L52-.L54
	.long	.L52-.L54
	.long	.L52-.L54
	.long	.L52-.L54
	.long	.L52-.L54
	.long	.L52-.L54
	.long	.L52-.L54
	.long	.L52-.L54
	.long	.L52-.L54
	.long	.L52-.L54
	.long	.L52-.L54
	.long	.L52-.L54
	.long	.L52-.L54
	.long	.L52-.L54
	.long	.L52-.L54
	.long	.L52-.L54
	.long	.L55-.L54
	.long	.L52-.L54
	.long	.L52-.L54
	.long	.L52-.L54
	.long	.L52-.L54
	.long	.L52-.L54
	.long	.L53-.L54
	.text
.L53:
	call	fork@PLT
	testl	%eax, %eax
	je	.L78
	movl	$0, %edi
	call	exit@PLT
.L78:
	call	server_main
.L57:
	movl	$0, %edx
	movl	$-31236, %esi
	movq	myoptarg(%rip), %rdi
	call	tcp_connect@PLT
	movl	%eax, %edi
	movl	$1, %edx
	leaq	.LC7(%rip), %rsi
	call	write@PLT
	movl	$0, %edi
	call	exit@PLT
.L55:
	movq	myoptarg(%rip), %rdi
	call	bytes@PLT
	movq	%rax, 32(%rsp)
	jmp	.L51
.L60:
	movq	myoptarg(%rip), %rdi
	call	bytes@PLT
	movq	%rax, 24(%rsp)
	jmp	.L51
.L58:
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	movl	%eax, 8(%rsp)
	testl	%eax, %eax
	jg	.L51
	movq	%r15, %rdx
	movq	%rbp, %rsi
	movl	%ebx, %edi
	call	lmbench_usage@PLT
	jmp	.L51
.L56:
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	movl	%eax, 12(%rsp)
	jmp	.L51
.L59:
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	movl	%eax, %r14d
	jmp	.L51
.L52:
	movq	%r15, %rdx
	movq	%rbp, %rsi
	movl	%ebx, %edi
	call	lmbench_usage@PLT
	jmp	.L51
.L77:
	movl	myoptind(%rip), %eax
	leal	-2(%rbx), %edx
	cmpl	%eax, %edx
	jg	.L75
	cmpl	%ebx, %eax
	jl	.L64
.L75:
	leaq	.LC8(%rip), %rdx
	movq	%rbp, %rsi
	movl	%ebx, %edi
	call	lmbench_usage@PLT
.L64:
	movl	myoptind(%rip), %eax
	leal	1(%rax), %edx
	movl	%edx, myoptind(%rip)
	cltq
	movq	0(%rbp,%rax,8), %rax
	movq	%rax, 40(%rsp)
	movq	32(%rsp), %rcx
	testq	%rcx, %rcx
	jne	.L66
	movq	24(%rsp), %rax
	testq	%rax, %rax
	jne	.L67
	movq	$65536, 24(%rsp)
	movq	$65536, 32(%rsp)
	jmp	.L70
.L67:
	movq	%rax, 32(%rsp)
	jmp	.L70
.L66:
	movq	24(%rsp), %rsi
	testq	%rsi, %rsi
	jne	.L69
	movq	%rcx, 24(%rsp)
	jmp	.L70
.L69:
	movq	%rsi, %rax
	movl	$0, %edx
	divq	%rcx
	testq	%rdx, %rdx
	je	.L70
	addq	%rsi, %rcx
	subq	%rdx, %rcx
	movq	%rcx, 24(%rsp)
.L70:
	leaq	16(%rsp), %rax
	pushq	%rax
	.cfi_def_cfa_offset 152
	pushq	%r14
	.cfi_def_cfa_offset 160
	movl	28(%rsp), %r9d
	movl	24(%rsp), %r8d
	movl	$0, %ecx
	leaq	cleanup(%rip), %rdx
	leaq	loop_transfer(%rip), %rsi
	leaq	initialize(%rip), %rdi
	call	benchmp@PLT
	call	usecs_spent@PLT
	addq	$16, %rsp
	.cfi_def_cfa_offset 144
	testq	%rax, %rax
	jne	.L79
.L71:
	movq	72(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L80
	movl	$0, %eax
	addq	$88, %rsp
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
.L79:
	.cfi_restore_state
	movq	32(%rsp), %rax
	testq	%rax, %rax
	js	.L72
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
.L73:
	divsd	.LC10(%rip), %xmm0
	leaq	.LC11(%rip), %rdx
	movl	$1, %esi
	movq	stderr(%rip), %rdi
	movl	$1, %eax
	call	__fprintf_chk@PLT
	movq	24(%rsp), %rbx
	call	get_n@PLT
	movslq	8(%rsp), %rdi
	imulq	%rbx, %rdi
	imulq	%rax, %rdi
	call	mb@PLT
	jmp	.L71
.L72:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
	jmp	.L73
.L80:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE72:
	.size	main, .-main
	.globl	id
	.section	.rodata.str1.1
.LC12:
	.string	"$Id$\n"
	.section	.data.rel.local,"aw"
	.align 8
	.type	id, @object
	.size	id, 8
id:
	.quad	.LC12
	.section	.rodata.cst8,"aM",@progbits,8
	.align 8
.LC10:
	.long	0
	.long	1093567616
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
