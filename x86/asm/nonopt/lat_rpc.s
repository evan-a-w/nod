	.file	"lat_rpc.c"
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
.LC1:
	.string	"lat_rpc: got bad data\n"
	.text
	.globl	doit
	.type	doit, @function
doit:
.LFB8:
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
	movb	$1, -17(%rbp)
	movq	-40(%rbp), %rdx
	leaq	-17(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	client_rpc_xact_1
	movq	%rax, -16(%rbp)
	cmpq	$0, -16(%rbp)
	jne	.L2
	movq	-48(%rbp), %rdx
	movq	-40(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	clnt_perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L2:
	movq	-16(%rbp), %rax
	movzbl	(%rax), %eax
	cmpb	$123, %al
	je	.L5
	movq	stderr(%rip), %rax
	movq	%rax, %rcx
	movl	$22, %edx
	movl	$1, %esi
	leaq	.LC1(%rip), %rax
	movq	%rax, %rdi
	call	fwrite@PLT
	movl	$1, %edi
	call	exit@PLT
.L5:
	nop
	movq	-8(%rbp), %rax
	subq	%fs:40, %rax
	je	.L4
	call	__stack_chk_fail@PLT
.L4:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE8:
	.size	doit, .-doit
	.data
	.align 16
	.type	TIMEOUT, @object
	.size	TIMEOUT, 16
TIMEOUT:
	.quad	0
	.quad	25000
	.globl	proto
	.section	.rodata
.LC2:
	.string	"tcp"
.LC3:
	.string	"udp"
	.section	.data.rel.local
	.align 16
	.type	proto, @object
	.size	proto, 24
proto:
	.quad	.LC2
	.quad	.LC3
	.quad	0
	.section	.rodata
.LC4:
	.string	"setting timeout"
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
	subq	$64, %rsp
	movq	%rdi, -56(%rbp)
	movq	%rsi, -64(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movq	-64(%rbp), %rax
	movq	%rax, -40(%rbp)
	cmpq	$0, -56(%rbp)
	jne	.L12
	movq	-40(%rbp), %rax
	movq	16(%rax), %rdx
	movq	-40(%rbp), %rax
	movq	8(%rax), %rax
	movq	%rdx, %rcx
	movl	$1, %edx
	movl	$404040, %esi
	movq	%rax, %rdi
	call	clnt_create@PLT
	movq	-40(%rbp), %rdx
	movq	%rax, 24(%rdx)
	movq	-40(%rbp), %rax
	movq	24(%rax), %rax
	testq	%rax, %rax
	jne	.L9
	movq	-40(%rbp), %rax
	movq	8(%rax), %rax
	movq	%rax, %rdi
	call	clnt_pcreateerror@PLT
	movl	$1, %edi
	call	exit@PLT
.L9:
	movq	8+proto(%rip), %rdx
	movq	-40(%rbp), %rax
	movq	16(%rax), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcasecmp@PLT
	testl	%eax, %eax
	jne	.L6
	movq	$0, -32(%rbp)
	movq	$2500, -24(%rbp)
	movq	-40(%rbp), %rax
	movq	24(%rax), %rax
	movq	8(%rax), %rax
	movq	40(%rax), %rcx
	movq	-40(%rbp), %rax
	movq	24(%rax), %rax
	leaq	-32(%rbp), %rdx
	movl	$4, %esi
	movq	%rax, %rdi
	call	*%rcx
	testl	%eax, %eax
	jne	.L6
	movq	-40(%rbp), %rax
	movq	24(%rax), %rax
	leaq	.LC4(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	clnt_perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L12:
	nop
.L6:
	movq	-8(%rbp), %rax
	subq	%fs:40, %rax
	je	.L11
	call	__stack_chk_fail@PLT
.L11:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE9:
	.size	initialize, .-initialize
	.globl	benchmark
	.type	benchmark, @function
benchmark:
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
	jmp	.L14
.L15:
	movq	-8(%rbp), %rax
	movq	8(%rax), %rdx
	movq	-8(%rbp), %rax
	movq	24(%rax), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	doit
.L14:
	movq	-24(%rbp), %rax
	leaq	-1(%rax), %rdx
	movq	%rdx, -24(%rbp)
	testq	%rax, %rax
	jne	.L15
	nop
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE10:
	.size	benchmark, .-benchmark
	.section	.rodata
	.align 8
.LC5:
	.string	"-s\n OR [-p <tcp|udp>] [-P parallel] [-W <warmup>] [-N <repetitions>] serverhost\n OR -S serverhost\n"
.LC6:
	.string	"sS:m:p:P:W:N:"
.LC7:
	.string	"RPC/%s latency using %s"
	.text
	.globl	main
	.type	main, @function
main:
.LFB11:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$1136, %rsp
	movl	%edi, -1124(%rbp)
	movq	%rsi, -1136(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movl	$1, -1112(%rbp)
	movl	$0, -1108(%rbp)
	movl	$-1, -1104(%rbp)
	movq	$0, -1096(%rbp)
	leaq	.LC5(%rip), %rax
	movq	%rax, -1088(%rbp)
	movl	$1, -1072(%rbp)
	jmp	.L17
.L30:
	movl	-1100(%rbp), %eax
	subl	$78, %eax
	cmpl	$37, %eax
	ja	.L18
	movl	%eax, %eax
	leaq	0(,%rax,4), %rdx
	leaq	.L20(%rip), %rax
	movl	(%rdx,%rax), %eax
	cltq
	leaq	.L20(%rip), %rdx
	addq	%rdx, %rax
	notrack jmp	*%rax
	.section	.rodata
	.align 4
	.align 4
.L20:
	.long	.L26-.L20
	.long	.L18-.L20
	.long	.L25-.L20
	.long	.L18-.L20
	.long	.L18-.L20
	.long	.L24-.L20
	.long	.L18-.L20
	.long	.L18-.L20
	.long	.L18-.L20
	.long	.L23-.L20
	.long	.L18-.L20
	.long	.L18-.L20
	.long	.L18-.L20
	.long	.L18-.L20
	.long	.L18-.L20
	.long	.L18-.L20
	.long	.L18-.L20
	.long	.L18-.L20
	.long	.L18-.L20
	.long	.L18-.L20
	.long	.L18-.L20
	.long	.L18-.L20
	.long	.L18-.L20
	.long	.L18-.L20
	.long	.L18-.L20
	.long	.L18-.L20
	.long	.L18-.L20
	.long	.L18-.L20
	.long	.L18-.L20
	.long	.L18-.L20
	.long	.L18-.L20
	.long	.L22-.L20
	.long	.L18-.L20
	.long	.L18-.L20
	.long	.L21-.L20
	.long	.L18-.L20
	.long	.L18-.L20
	.long	.L19-.L20
	.text
.L19:
	call	fork@PLT
	testl	%eax, %eax
	jne	.L27
	movl	$0, %eax
	call	server_main
.L27:
	movl	$0, %edi
	call	exit@PLT
.L24:
	movq	myoptarg(%rip), %rax
	leaq	.LC3(%rip), %rdx
	movq	%rdx, %rcx
	movl	$1, %edx
	movl	$404040, %esi
	movq	%rax, %rdi
	call	clnt_create@PLT
	movq	%rax, -1080(%rbp)
	cmpq	$0, -1080(%rbp)
	jne	.L28
	movq	-1064(%rbp), %rax
	movq	%rax, %rdi
	call	clnt_pcreateerror@PLT
	movl	$1, %edi
	call	exit@PLT
.L28:
	movq	-1080(%rbp), %rax
	movq	8(%rax), %rax
	movq	(%rax), %r10
	movq	-1080(%rbp), %rax
	pushq	8+TIMEOUT(%rip)
	pushq	TIMEOUT(%rip)
	movl	$0, %r9d
	movq	xdr_void@GOTPCREL(%rip), %rdx
	movq	%rdx, %r8
	movl	$0, %ecx
	movq	xdr_void@GOTPCREL(%rip), %rdx
	movl	$2, %esi
	movq	%rax, %rdi
	call	*%r10
	addq	$16, %rsp
	movl	$0, %edi
	call	exit@PLT
.L22:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -1072(%rbp)
	jmp	.L17
.L21:
	movq	myoptarg(%rip), %rax
	movq	%rax, -1096(%rbp)
	jmp	.L17
.L25:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -1112(%rbp)
	cmpl	$0, -1112(%rbp)
	jg	.L17
	movq	-1088(%rbp), %rdx
	movq	-1136(%rbp), %rcx
	movl	-1124(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	lmbench_usage@PLT
	jmp	.L17
.L23:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -1108(%rbp)
	jmp	.L17
.L26:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -1104(%rbp)
	jmp	.L17
.L18:
	movq	-1088(%rbp), %rdx
	movq	-1136(%rbp), %rcx
	movl	-1124(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	lmbench_usage@PLT
	nop
.L17:
	movq	-1136(%rbp), %rcx
	movl	-1124(%rbp), %eax
	leaq	.LC6(%rip), %rdx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	mygetopt@PLT
	movl	%eax, -1100(%rbp)
	cmpl	$-1, -1100(%rbp)
	jne	.L30
	movl	-1124(%rbp), %eax
	leal	-1(%rax), %edx
	movl	myoptind(%rip), %eax
	cmpl	%eax, %edx
	je	.L31
	movq	-1088(%rbp), %rdx
	movq	-1136(%rbp), %rcx
	movl	-1124(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	lmbench_usage@PLT
.L31:
	movl	myoptind(%rip), %eax
	leal	1(%rax), %edx
	movl	%edx, myoptind(%rip)
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-1136(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	%rax, -1064(%rbp)
	cmpq	$0, -1096(%rbp)
	je	.L32
	movq	proto(%rip), %rdx
	movq	-1096(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcasecmp@PLT
	testl	%eax, %eax
	jne	.L33
.L32:
	movq	proto(%rip), %rax
	movq	%rax, -1056(%rbp)
	movl	-1108(%rbp), %ecx
	movl	-1112(%rbp), %edx
	leaq	-1072(%rbp), %rax
	pushq	%rax
	movl	-1104(%rbp), %eax
	pushq	%rax
	movl	%ecx, %r9d
	movl	%edx, %r8d
	movl	$2000000, %ecx
	movl	$0, %edx
	leaq	benchmark(%rip), %rax
	movq	%rax, %rsi
	leaq	initialize(%rip), %rax
	movq	%rax, %rdi
	call	benchmp@PLT
	addq	$16, %rsp
	movq	-1064(%rbp), %rcx
	movq	proto(%rip), %rdx
	leaq	-1040(%rbp), %rax
	leaq	.LC7(%rip), %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	sprintf@PLT
	call	get_n@PLT
	movq	%rax, %rdx
	leaq	-1040(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	micro@PLT
.L33:
	cmpq	$0, -1096(%rbp)
	je	.L34
	movq	8+proto(%rip), %rdx
	movq	-1096(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcasecmp@PLT
	testl	%eax, %eax
	jne	.L35
.L34:
	movq	8+proto(%rip), %rax
	movq	%rax, -1056(%rbp)
	movl	-1108(%rbp), %ecx
	movl	-1112(%rbp), %edx
	leaq	-1072(%rbp), %rax
	pushq	%rax
	movl	-1104(%rbp), %eax
	pushq	%rax
	movl	%ecx, %r9d
	movl	%edx, %r8d
	movl	$2000000, %ecx
	movl	$0, %edx
	leaq	benchmark(%rip), %rax
	movq	%rax, %rsi
	leaq	initialize(%rip), %rax
	movq	%rax, %rdi
	call	benchmp@PLT
	addq	$16, %rsp
	movq	-1064(%rbp), %rcx
	movq	8+proto(%rip), %rdx
	leaq	-1040(%rbp), %rax
	leaq	.LC7(%rip), %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	sprintf@PLT
	call	get_n@PLT
	movq	%rax, %rdx
	leaq	-1040(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	micro@PLT
.L35:
	movl	$0, %edi
	call	exit@PLT
	.cfi_endproc
.LFE11:
	.size	main, .-main
	.globl	client_rpc_xact_1
	.type	client_rpc_xact_1, @function
client_rpc_xact_1:
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
	movb	$0, res.1(%rip)
	movq	-16(%rbp), %rax
	movq	8(%rax), %rax
	movq	(%rax), %r10
	movq	-8(%rbp), %rdx
	movq	-16(%rbp), %rax
	pushq	8+TIMEOUT(%rip)
	pushq	TIMEOUT(%rip)
	leaq	res.1(%rip), %r9
	movq	xdr_char@GOTPCREL(%rip), %rcx
	movq	%rcx, %r8
	movq	%rdx, %rcx
	movq	xdr_char@GOTPCREL(%rip), %rdx
	movl	$1, %esi
	movq	%rax, %rdi
	call	*%r10
	addq	$16, %rsp
	testl	%eax, %eax
	je	.L38
	movl	$0, %eax
	jmp	.L39
.L38:
	leaq	res.1(%rip), %rax
.L39:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE12:
	.size	client_rpc_xact_1, .-client_rpc_xact_1
	.globl	rpc_xact_1
	.type	rpc_xact_1, @function
rpc_xact_1:
.LFB13:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -8(%rbp)
	leaq	r.0(%rip), %rax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE13:
	.size	rpc_xact_1, .-rpc_xact_1
	.section	.rodata
.LC8:
	.string	"cannot create udp service.\n"
	.align 8
.LC9:
	.string	"unable to register (XACT_PROG, XACT_VERS, udp).\n"
.LC10:
	.string	"cannot create tcp service.\n"
	.align 8
.LC11:
	.string	"unable to register (XACT_PROG, XACT_VERS, tcp).\n"
.LC12:
	.string	"svc_run returned\n"
	.text
	.globl	server_main
	.type	server_main, @function
server_main:
.LFB14:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%rbx
	subq	$8, %rsp
	.cfi_offset 3, -24
	movq	exit@GOTPCREL(%rip), %rax
	movq	%rax, %rsi
	movl	$14, %edi
	call	signal@PLT
	movl	$3600, %edi
	call	alarm@PLT
	movl	$1, %esi
	movl	$404040, %edi
	call	pmap_unset@PLT
	movl	$-1, %edi
	call	svcudp_create@PLT
	movq	%rax, %rbx
	testq	%rbx, %rbx
	jne	.L43
	movq	stderr(%rip), %rax
	movq	%rax, %rcx
	movl	$27, %edx
	movl	$1, %esi
	leaq	.LC8(%rip), %rax
	movq	%rax, %rdi
	call	fwrite@PLT
	movl	$1, %edi
	call	exit@PLT
.L43:
	movl	$17, %r8d
	leaq	xact_prog_1(%rip), %rax
	movq	%rax, %rcx
	movl	$1, %edx
	movl	$404040, %esi
	movq	%rbx, %rdi
	call	svc_register@PLT
	testl	%eax, %eax
	jne	.L44
	movq	stderr(%rip), %rax
	movq	%rax, %rcx
	movl	$48, %edx
	movl	$1, %esi
	leaq	.LC9(%rip), %rax
	movq	%rax, %rdi
	call	fwrite@PLT
	movl	$1, %edi
	call	exit@PLT
.L44:
	movl	$0, %edx
	movl	$0, %esi
	movl	$-1, %edi
	call	svctcp_create@PLT
	movq	%rax, %rbx
	testq	%rbx, %rbx
	jne	.L45
	movq	stderr(%rip), %rax
	movq	%rax, %rcx
	movl	$27, %edx
	movl	$1, %esi
	leaq	.LC10(%rip), %rax
	movq	%rax, %rdi
	call	fwrite@PLT
	movl	$1, %edi
	call	exit@PLT
.L45:
	movl	$6, %r8d
	leaq	xact_prog_1(%rip), %rax
	movq	%rax, %rcx
	movl	$1, %edx
	movl	$404040, %esi
	movq	%rbx, %rdi
	call	svc_register@PLT
	testl	%eax, %eax
	jne	.L46
	movq	stderr(%rip), %rax
	movq	%rax, %rcx
	movl	$48, %edx
	movl	$1, %esi
	leaq	.LC11(%rip), %rax
	movq	%rax, %rdi
	call	fwrite@PLT
	movl	$1, %edi
	call	exit@PLT
.L46:
	call	svc_run@PLT
	movq	stderr(%rip), %rax
	movq	%rax, %rcx
	movl	$17, %edx
	movl	$1, %esi
	leaq	.LC12(%rip), %rax
	movq	%rax, %rdi
	call	fwrite@PLT
	movl	$1, %edi
	call	exit@PLT
	.cfi_endproc
.LFE14:
	.size	server_main, .-server_main
	.section	.rodata
.LC13:
	.string	"unable to free arguments\n"
	.text
	.type	xact_prog_1, @function
xact_prog_1:
.LFB15:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%rbx
	subq	$72, %rsp
	.cfi_offset 3, -24
	movq	%rdi, -72(%rbp)
	movq	%rsi, %rbx
	movq	%fs:40, %rax
	movq	%rax, -24(%rbp)
	xorl	%eax, %eax
	movq	-72(%rbp), %rax
	movl	8(%rax), %eax
	cmpl	$2, %eax
	je	.L48
	cmpl	$2, %eax
	ja	.L49
	testl	%eax, %eax
	je	.L50
	cmpl	$1, %eax
	je	.L51
	jmp	.L49
.L50:
	movl	$0, %edx
	movq	xdr_void@GOTPCREL(%rip), %rax
	movq	%rax, %rsi
	movq	%rbx, %rdi
	call	svc_sendreply@PLT
	jmp	.L47
.L51:
	movq	xdr_char@GOTPCREL(%rip), %rax
	movq	%rax, -56(%rbp)
	movq	xdr_char@GOTPCREL(%rip), %rax
	movq	%rax, -48(%rbp)
	leaq	rpc_xact_1(%rip), %rax
	movq	%rax, -40(%rbp)
	nop
	leaq	-57(%rbp), %rax
	movb	$0, (%rax)
	movq	8(%rbx), %rax
	movq	16(%rax), %rcx
	leaq	-57(%rbp), %rdx
	movq	-56(%rbp), %rax
	movq	%rax, %rsi
	movq	%rbx, %rdi
	call	*%rcx
	testl	%eax, %eax
	jne	.L54
	jmp	.L59
.L48:
	movl	$0, %edx
	movq	xdr_void@GOTPCREL(%rip), %rax
	movq	%rax, %rsi
	movq	%rbx, %rdi
	call	svc_sendreply@PLT
	movl	$1, %esi
	movl	$404040, %edi
	call	pmap_unset@PLT
	movl	$0, %edi
	call	exit@PLT
.L49:
	movq	%rbx, %rdi
	call	svcerr_noproc@PLT
	jmp	.L47
.L59:
	movq	%rbx, %rdi
	call	svcerr_decode@PLT
	jmp	.L47
.L54:
	movq	-72(%rbp), %rdx
	leaq	-57(%rbp), %rax
	movq	-40(%rbp), %rcx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	*%rcx
	movq	%rax, -32(%rbp)
	cmpq	$0, -32(%rbp)
	je	.L55
	movq	-32(%rbp), %rdx
	movq	-48(%rbp), %rax
	movq	%rax, %rsi
	movq	%rbx, %rdi
	call	svc_sendreply@PLT
	testl	%eax, %eax
	jne	.L55
	movq	%rbx, %rdi
	call	svcerr_systemerr@PLT
.L55:
	movq	8(%rbx), %rax
	movq	32(%rax), %rcx
	leaq	-57(%rbp), %rdx
	movq	-56(%rbp), %rax
	movq	%rax, %rsi
	movq	%rbx, %rdi
	call	*%rcx
	testl	%eax, %eax
	jne	.L60
	movq	stderr(%rip), %rax
	movq	%rax, %rcx
	movl	$25, %edx
	movl	$1, %esi
	leaq	.LC13(%rip), %rax
	movq	%rax, %rdi
	call	fwrite@PLT
	movl	$1, %edi
	call	exit@PLT
.L60:
	nop
.L47:
	movq	-24(%rbp), %rax
	subq	%fs:40, %rax
	je	.L58
	call	__stack_chk_fail@PLT
.L58:
	movq	-8(%rbp), %rbx
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE15:
	.size	xact_prog_1, .-xact_prog_1
	.local	res.1
	.comm	res.1,1,1
	.data
	.type	r.0, @object
	.size	r.0, 1
r.0:
	.byte	123
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
