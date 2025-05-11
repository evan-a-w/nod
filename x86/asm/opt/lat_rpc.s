	.file	"lat_rpc.c"
	.text
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"setting timeout"
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
	subq	$40, %rsp
	.cfi_def_cfa_offset 64
	movq	%fs:40, %rax
	movq	%rax, 24(%rsp)
	xorl	%eax, %eax
	testq	%rdi, %rdi
	je	.L7
.L1:
	movq	24(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L8
	addq	$40, %rsp
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
	movq	16(%rsi), %rcx
	movq	8(%rsi), %rdi
	movl	$1, %edx
	movl	$404040, %esi
	call	clnt_create@PLT
	movq	%rax, %rbp
	movq	%rax, 24(%rbx)
	testq	%rax, %rax
	je	.L9
	movq	16(%rbx), %rdi
	movq	8+proto(%rip), %rsi
	call	strcasecmp@PLT
	testl	%eax, %eax
	jne	.L1
	movq	$0, (%rsp)
	movq	$2500, 8(%rsp)
	movq	%rsp, %rdx
	movq	8(%rbp), %rax
	movl	$4, %esi
	movq	%rbp, %rdi
	call	*40(%rax)
	testl	%eax, %eax
	jne	.L1
	movq	24(%rbx), %rdi
	leaq	.LC0(%rip), %rsi
	call	clnt_perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L9:
	movq	8(%rbx), %rdi
	call	clnt_pcreateerror@PLT
	movl	$1, %edi
	call	exit@PLT
.L8:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE73:
	.size	initialize, .-initialize
	.section	.rodata.str1.1
.LC1:
	.string	"unable to free arguments\n"
	.text
	.type	xact_prog_1, @function
xact_prog_1:
.LFB79:
	.cfi_startproc
	endbr64
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	subq	$16, %rsp
	.cfi_def_cfa_offset 32
	movq	%rsi, %rbx
	movq	%fs:40, %rax
	movq	%rax, 8(%rsp)
	xorl	%eax, %eax
	movl	8(%rdi), %eax
	cmpl	$1, %eax
	je	.L11
	cmpl	$2, %eax
	je	.L12
	testl	%eax, %eax
	je	.L21
	movq	%rsi, %rdi
	call	svcerr_noproc@PLT
	jmp	.L10
.L21:
	movl	$0, %edx
	movq	xdr_void@GOTPCREL(%rip), %rsi
	movq	%rbx, %rdi
	call	svc_sendreply@PLT
.L10:
	movq	8(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L22
	addq	$16, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 16
	popq	%rbx
	.cfi_def_cfa_offset 8
	ret
.L11:
	.cfi_restore_state
	leaq	7(%rsp), %rdx
	movb	$0, 7(%rsp)
	movq	8(%rsi), %rax
	movq	xdr_char@GOTPCREL(%rip), %rsi
	movq	%rbx, %rdi
	call	*16(%rax)
	testl	%eax, %eax
	je	.L23
	leaq	r.0(%rip), %rdx
	movq	xdr_char@GOTPCREL(%rip), %rsi
	movq	%rbx, %rdi
	call	svc_sendreply@PLT
	testl	%eax, %eax
	je	.L24
.L17:
	leaq	7(%rsp), %rdx
	movq	8(%rbx), %rax
	movq	xdr_char@GOTPCREL(%rip), %rsi
	movq	%rbx, %rdi
	call	*32(%rax)
	testl	%eax, %eax
	jne	.L10
	movq	stderr(%rip), %rcx
	movl	$25, %edx
	movl	$1, %esi
	leaq	.LC1(%rip), %rdi
	call	fwrite@PLT
	movl	$1, %edi
	call	exit@PLT
.L12:
	movl	$0, %edx
	movq	xdr_void@GOTPCREL(%rip), %rsi
	movq	%rbx, %rdi
	call	svc_sendreply@PLT
	movl	$1, %esi
	movl	$404040, %edi
	call	pmap_unset@PLT
	movl	$0, %edi
	call	exit@PLT
.L23:
	movq	%rbx, %rdi
	call	svcerr_decode@PLT
	jmp	.L10
.L24:
	movq	%rbx, %rdi
	call	svcerr_systemerr@PLT
	jmp	.L17
.L22:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE79:
	.size	xact_prog_1, .-xact_prog_1
	.globl	client_rpc_xact_1
	.type	client_rpc_xact_1, @function
client_rpc_xact_1:
.LFB76:
	.cfi_startproc
	endbr64
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	movq	%rdi, %rcx
	movq	%rsi, %rdi
	movb	$0, res.1(%rip)
	movq	8(%rsi), %rax
	pushq	8+TIMEOUT(%rip)
	.cfi_def_cfa_offset 24
	pushq	TIMEOUT(%rip)
	.cfi_def_cfa_offset 32
	leaq	res.1(%rip), %r9
	movq	xdr_char@GOTPCREL(%rip), %rdx
	movq	%rdx, %r8
	movl	$1, %esi
	call	*(%rax)
	testl	%eax, %eax
	leaq	res.1(%rip), %rax
	movl	$0, %edx
	cmovne	%rdx, %rax
	addq	$24, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE76:
	.size	client_rpc_xact_1, .-client_rpc_xact_1
	.section	.rodata.str1.1
.LC2:
	.string	"lat_rpc: got bad data\n"
	.text
	.globl	doit
	.type	doit, @function
doit:
.LFB72:
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
	movq	%rdi, %rbx
	movq	%rsi, %rbp
	movq	%fs:40, %rax
	movq	%rax, 8(%rsp)
	xorl	%eax, %eax
	movb	$1, 7(%rsp)
	leaq	7(%rsp), %rdi
	movq	%rbx, %rsi
	call	client_rpc_xact_1
	testq	%rax, %rax
	je	.L34
	cmpb	$123, (%rax)
	jne	.L35
	movq	8(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L36
	addq	$24, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
.L34:
	.cfi_restore_state
	movq	%rbp, %rsi
	movq	%rbx, %rdi
	call	clnt_perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L35:
	movq	stderr(%rip), %rcx
	movl	$22, %edx
	movl	$1, %esi
	leaq	.LC2(%rip), %rdi
	call	fwrite@PLT
	movl	$1, %edi
	call	exit@PLT
.L36:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE72:
	.size	doit, .-doit
	.globl	benchmark
	.type	benchmark, @function
benchmark:
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
	movq	%rsi, %rbp
	leaq	-1(%rdi), %rbx
	testq	%rdi, %rdi
	je	.L37
.L39:
	movq	8(%rbp), %rsi
	movq	24(%rbp), %rdi
	call	doit
	subq	$1, %rbx
	cmpq	$-1, %rbx
	jne	.L39
.L37:
	addq	$8, %rsp
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE74:
	.size	benchmark, .-benchmark
	.globl	rpc_xact_1
	.type	rpc_xact_1, @function
rpc_xact_1:
.LFB77:
	.cfi_startproc
	endbr64
	leaq	r.0(%rip), %rax
	ret
	.cfi_endproc
.LFE77:
	.size	rpc_xact_1, .-rpc_xact_1
	.section	.rodata.str1.1
.LC3:
	.string	"cannot create udp service.\n"
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC4:
	.string	"unable to register (XACT_PROG, XACT_VERS, udp).\n"
	.section	.rodata.str1.1
.LC5:
	.string	"cannot create tcp service.\n"
	.section	.rodata.str1.8
	.align 8
.LC6:
	.string	"unable to register (XACT_PROG, XACT_VERS, tcp).\n"
	.section	.rodata.str1.1
.LC7:
	.string	"svc_run returned\n"
	.text
	.globl	server_main
	.type	server_main, @function
server_main:
.LFB78:
	.cfi_startproc
	endbr64
	pushq	%rax
	.cfi_def_cfa_offset 16
	popq	%rax
	.cfi_def_cfa_offset 8
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	movq	exit@GOTPCREL(%rip), %rsi
	movl	$14, %edi
	call	signal@PLT
	movl	$3600, %edi
	call	alarm@PLT
	movl	$1, %esi
	movl	$404040, %edi
	call	pmap_unset@PLT
	movl	$-1, %edi
	call	svcudp_create@PLT
	testq	%rax, %rax
	je	.L49
	movq	%rax, %rdi
	movl	$17, %r8d
	leaq	xact_prog_1(%rip), %rcx
	movl	$1, %edx
	movl	$404040, %esi
	call	svc_register@PLT
	testl	%eax, %eax
	jne	.L45
	movq	stderr(%rip), %rcx
	movl	$48, %edx
	movl	$1, %esi
	leaq	.LC4(%rip), %rdi
	call	fwrite@PLT
	movl	$1, %edi
	call	exit@PLT
.L49:
	movq	stderr(%rip), %rcx
	movl	$27, %edx
	movl	$1, %esi
	leaq	.LC3(%rip), %rdi
	call	fwrite@PLT
	movl	$1, %edi
	call	exit@PLT
.L45:
	movl	$0, %edx
	movl	$0, %esi
	movl	$-1, %edi
	call	svctcp_create@PLT
	movq	%rax, %rdi
	testq	%rax, %rax
	je	.L50
	movl	$6, %r8d
	leaq	xact_prog_1(%rip), %rcx
	movl	$1, %edx
	movl	$404040, %esi
	call	svc_register@PLT
	testl	%eax, %eax
	jne	.L47
	movq	stderr(%rip), %rcx
	movl	$48, %edx
	movl	$1, %esi
	leaq	.LC6(%rip), %rdi
	call	fwrite@PLT
	movl	$1, %edi
	call	exit@PLT
.L50:
	movq	stderr(%rip), %rcx
	movl	$27, %edx
	movl	$1, %esi
	leaq	.LC5(%rip), %rdi
	call	fwrite@PLT
	movl	$1, %edi
	call	exit@PLT
.L47:
	call	svc_run@PLT
	movq	stderr(%rip), %rcx
	movl	$17, %edx
	movl	$1, %esi
	leaq	.LC7(%rip), %rdi
	call	fwrite@PLT
	movl	$1, %edi
	call	exit@PLT
	.cfi_endproc
.LFE78:
	.size	server_main, .-server_main
	.section	.rodata.str1.1
.LC8:
	.string	"udp"
	.section	.rodata.str1.8
	.align 8
.LC9:
	.string	"-s\n OR [-p <tcp|udp>] [-P parallel] [-W <warmup>] [-N <repetitions>] serverhost\n OR -S serverhost\n"
	.section	.rodata.str1.1
.LC10:
	.string	"sS:m:p:P:W:N:"
.LC11:
	.string	"RPC/%s latency using %s"
	.text
	.globl	main
	.type	main, @function
main:
.LFB75:
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
	subq	$1096, %rsp
	.cfi_def_cfa_offset 1152
	movl	%edi, %ebp
	movq	%rsi, %rbx
	movq	%fs:40, %rax
	movq	%rax, 1080(%rsp)
	xorl	%eax, %eax
	movl	$1, 16(%rsp)
	movl	$0, %r14d
	movl	$-1, 12(%rsp)
	movl	$0, 8(%rsp)
	movl	$1, 4(%rsp)
	leaq	.LC10(%rip), %r13
	leaq	.LC9(%rip), %r15
	leaq	.L55(%rip), %r12
.L52:
	movq	%r13, %rdx
	movq	%rbx, %rsi
	movl	%ebp, %edi
	call	mygetopt@PLT
	cmpl	$-1, %eax
	je	.L74
	subl	$78, %eax
	cmpl	$37, %eax
	ja	.L53
	movl	%eax, %eax
	movslq	(%r12,%rax,4), %rax
	addq	%r12, %rax
	notrack jmp	*%rax
	.section	.rodata
	.align 4
	.align 4
.L55:
	.long	.L61-.L55
	.long	.L53-.L55
	.long	.L60-.L55
	.long	.L53-.L55
	.long	.L53-.L55
	.long	.L59-.L55
	.long	.L53-.L55
	.long	.L53-.L55
	.long	.L53-.L55
	.long	.L58-.L55
	.long	.L53-.L55
	.long	.L53-.L55
	.long	.L53-.L55
	.long	.L53-.L55
	.long	.L53-.L55
	.long	.L53-.L55
	.long	.L53-.L55
	.long	.L53-.L55
	.long	.L53-.L55
	.long	.L53-.L55
	.long	.L53-.L55
	.long	.L53-.L55
	.long	.L53-.L55
	.long	.L53-.L55
	.long	.L53-.L55
	.long	.L53-.L55
	.long	.L53-.L55
	.long	.L53-.L55
	.long	.L53-.L55
	.long	.L53-.L55
	.long	.L53-.L55
	.long	.L57-.L55
	.long	.L53-.L55
	.long	.L53-.L55
	.long	.L56-.L55
	.long	.L53-.L55
	.long	.L53-.L55
	.long	.L54-.L55
	.text
.L54:
	call	fork@PLT
	testl	%eax, %eax
	jne	.L62
	call	server_main
.L62:
	movl	$0, %edi
	call	exit@PLT
.L59:
	leaq	.LC8(%rip), %rcx
	movl	$1, %edx
	movl	$404040, %esi
	movq	myoptarg(%rip), %rdi
	call	clnt_create@PLT
	movq	%rax, %rdi
	testq	%rax, %rax
	je	.L75
	movq	8(%rax), %rax
	pushq	8+TIMEOUT(%rip)
	.cfi_remember_state
	.cfi_def_cfa_offset 1160
	pushq	TIMEOUT(%rip)
	.cfi_def_cfa_offset 1168
	movl	$0, %r9d
	movq	xdr_void@GOTPCREL(%rip), %rdx
	movq	%rdx, %r8
	movl	$0, %ecx
	movl	$2, %esi
	call	*(%rax)
	movl	$0, %edi
	call	exit@PLT
.L75:
	.cfi_restore_state
	movq	24(%rsp), %rdi
	call	clnt_pcreateerror@PLT
	movl	$1, %edi
	call	exit@PLT
.L57:
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	movl	%eax, 16(%rsp)
	jmp	.L52
.L56:
	movq	myoptarg(%rip), %r14
	jmp	.L52
.L60:
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	movl	%eax, 4(%rsp)
	testl	%eax, %eax
	jg	.L52
	movq	%r15, %rdx
	movq	%rbx, %rsi
	movl	%ebp, %edi
	call	lmbench_usage@PLT
	jmp	.L52
.L58:
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	movl	%eax, 8(%rsp)
	jmp	.L52
.L61:
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	movl	%eax, 12(%rsp)
	jmp	.L52
.L53:
	movq	%r15, %rdx
	movq	%rbx, %rsi
	movl	%ebp, %edi
	call	lmbench_usage@PLT
	jmp	.L52
.L74:
	leal	-1(%rbp), %eax
	cmpl	myoptind(%rip), %eax
	jne	.L76
.L66:
	movl	myoptind(%rip), %eax
	leal	1(%rax), %edx
	movl	%edx, myoptind(%rip)
	cltq
	movq	(%rbx,%rax,8), %rax
	movq	%rax, 24(%rsp)
	testq	%r14, %r14
	je	.L67
	movq	proto(%rip), %rsi
	movq	%r14, %rdi
	call	strcasecmp@PLT
	testl	%eax, %eax
	je	.L68
.L70:
	movq	8+proto(%rip), %rsi
	movq	%r14, %rdi
	call	strcasecmp@PLT
	testl	%eax, %eax
	jne	.L69
.L71:
	movq	8+proto(%rip), %rax
	movq	%rax, 32(%rsp)
	leaq	16(%rsp), %rax
	pushq	%rax
	.cfi_def_cfa_offset 1160
	movl	20(%rsp), %eax
	pushq	%rax
	.cfi_def_cfa_offset 1168
	movl	24(%rsp), %r9d
	movl	20(%rsp), %r8d
	movl	$2000000, %ecx
	movl	$0, %edx
	leaq	benchmark(%rip), %rsi
	leaq	initialize(%rip), %rdi
	call	benchmp@PLT
	leaq	64(%rsp), %rbx
	movq	40(%rsp), %r9
	movq	8+proto(%rip), %r8
	leaq	.LC11(%rip), %rcx
	movl	$1024, %edx
	movl	$1, %esi
	movq	%rbx, %rdi
	movl	$0, %eax
	call	__sprintf_chk@PLT
	call	get_n@PLT
	movq	%rax, %rsi
	movq	%rbx, %rdi
	call	micro@PLT
	addq	$16, %rsp
	.cfi_def_cfa_offset 1152
.L69:
	movl	$0, %edi
	call	exit@PLT
.L76:
	leaq	.LC9(%rip), %rdx
	movq	%rbx, %rsi
	movl	%ebp, %edi
	call	lmbench_usage@PLT
	jmp	.L66
.L68:
	movq	proto(%rip), %rax
	movq	%rax, 32(%rsp)
	leaq	16(%rsp), %rax
	pushq	%rax
	.cfi_def_cfa_offset 1160
	movl	20(%rsp), %eax
	pushq	%rax
	.cfi_def_cfa_offset 1168
	movl	24(%rsp), %r9d
	movl	20(%rsp), %r8d
	movl	$2000000, %ecx
	movl	$0, %edx
	leaq	benchmark(%rip), %rsi
	leaq	initialize(%rip), %rdi
	call	benchmp@PLT
	leaq	64(%rsp), %rbx
	movq	40(%rsp), %r9
	movq	proto(%rip), %r8
	leaq	.LC11(%rip), %rcx
	movl	$1024, %edx
	movl	$1, %esi
	movq	%rbx, %rdi
	movl	$0, %eax
	call	__sprintf_chk@PLT
	call	get_n@PLT
	movq	%rax, %rsi
	movq	%rbx, %rdi
	call	micro@PLT
	addq	$16, %rsp
	.cfi_def_cfa_offset 1152
	jmp	.L70
.L67:
	movq	proto(%rip), %rax
	movq	%rax, 32(%rsp)
	leaq	16(%rsp), %rax
	pushq	%rax
	.cfi_def_cfa_offset 1160
	movl	20(%rsp), %eax
	pushq	%rax
	.cfi_def_cfa_offset 1168
	movl	24(%rsp), %r9d
	movl	20(%rsp), %r8d
	movl	$2000000, %ecx
	movl	$0, %edx
	leaq	benchmark(%rip), %rsi
	leaq	initialize(%rip), %rdi
	call	benchmp@PLT
	leaq	64(%rsp), %rbx
	movq	40(%rsp), %r9
	movq	proto(%rip), %r8
	leaq	.LC11(%rip), %rcx
	movl	$1024, %edx
	movl	$1, %esi
	movq	%rbx, %rdi
	movl	$0, %eax
	call	__sprintf_chk@PLT
	call	get_n@PLT
	movq	%rax, %rsi
	movq	%rbx, %rdi
	call	micro@PLT
	addq	$16, %rsp
	.cfi_def_cfa_offset 1152
	jmp	.L71
	.cfi_endproc
.LFE75:
	.size	main, .-main
	.data
	.type	r.0, @object
	.size	r.0, 1
r.0:
	.byte	123
	.local	res.1
	.comm	res.1,1,1
	.globl	proto
	.section	.rodata.str1.1
.LC12:
	.string	"tcp"
	.section	.data.rel.local,"aw"
	.align 16
	.type	proto, @object
	.size	proto, 24
proto:
	.quad	.LC12
	.quad	.LC8
	.quad	0
	.section	.rodata
	.align 16
	.type	TIMEOUT, @object
	.size	TIMEOUT, 16
TIMEOUT:
	.quad	0
	.quad	25000
	.globl	id
	.section	.rodata.str1.1
.LC13:
	.string	"$Id$\n"
	.section	.data.rel.local
	.align 8
	.type	id, @object
	.size	id, 8
id:
	.quad	.LC13
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
