	.file	"bw_tcp.c"
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
	.string	"-s\n OR [-m <message size>] [-M <bytes to move>] [-P <parallelism>] [-W <warmup>] [-N <repetitions>] server\n OR -S serverhost\n"
.LC2:
	.string	"0"
.LC3:
	.string	"sS:m:M:P:W:N:"
.LC5:
	.string	"%.6f "
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
	pushq	%rbx
	subq	$120, %rsp
	.cfi_offset 3, -24
	movl	%edi, -116(%rbp)
	movq	%rsi, -128(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -24(%rbp)
	xorl	%eax, %eax
	movl	$1, -112(%rbp)
	movl	$7500000, -108(%rbp)
	movl	$-1, -104(%rbp)
	movl	$0, -100(%rbp)
	leaq	.LC1(%rip), %rax
	movq	%rax, -88(%rbp)
	movq	$0, -64(%rbp)
	movq	$0, -72(%rbp)
	jmp	.L2
.L14:
	movl	-96(%rbp), %eax
	subl	$77, %eax
	cmpl	$38, %eax
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
	.long	.L11-.L5
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
	jne	.L12
	movl	$0, %eax
	call	server_main
.L12:
	movl	$0, %edi
	call	exit@PLT
.L8:
	movq	myoptarg(%rip), %rax
	movl	$0, %edx
	movl	$-31236, %esi
	movq	%rax, %rdi
	call	tcp_connect@PLT
	movl	%eax, -92(%rbp)
	movl	-92(%rbp), %eax
	movl	$1, %edx
	leaq	.LC2(%rip), %rcx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	write@PLT
	movl	$0, %edi
	call	exit@PLT
.L6:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	bytes@PLT
	movq	%rax, -64(%rbp)
	jmp	.L2
.L11:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	bytes@PLT
	movq	%rax, -72(%rbp)
	jmp	.L2
.L9:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -112(%rbp)
	cmpl	$0, -112(%rbp)
	jg	.L2
	movq	-88(%rbp), %rdx
	movq	-128(%rbp), %rcx
	movl	-116(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	lmbench_usage@PLT
	jmp	.L2
.L7:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -108(%rbp)
	jmp	.L2
.L10:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -104(%rbp)
	jmp	.L2
.L3:
	movq	-88(%rbp), %rdx
	movq	-128(%rbp), %rcx
	movl	-116(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	lmbench_usage@PLT
	nop
.L2:
	movq	-128(%rbp), %rcx
	movl	-116(%rbp), %eax
	leaq	.LC3(%rip), %rdx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	mygetopt@PLT
	movl	%eax, -96(%rbp)
	cmpl	$-1, -96(%rbp)
	jne	.L14
	movl	-116(%rbp), %eax
	leal	-2(%rax), %edx
	movl	myoptind(%rip), %eax
	cmpl	%eax, %edx
	jg	.L15
	movl	myoptind(%rip), %eax
	cmpl	%eax, -116(%rbp)
	jg	.L16
.L15:
	movq	-88(%rbp), %rdx
	movq	-128(%rbp), %rcx
	movl	-116(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	lmbench_usage@PLT
.L16:
	movl	myoptind(%rip), %eax
	leal	1(%rax), %edx
	movl	%edx, myoptind(%rip)
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-128(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	%rax, -56(%rbp)
	movq	-64(%rbp), %rax
	testq	%rax, %rax
	jne	.L17
	movq	-72(%rbp), %rax
	testq	%rax, %rax
	jne	.L17
	movq	$65536, -72(%rbp)
	movq	$65536, -64(%rbp)
	jmp	.L18
.L17:
	movq	-64(%rbp), %rax
	testq	%rax, %rax
	jne	.L19
	movq	-72(%rbp), %rax
	movq	%rax, -64(%rbp)
	jmp	.L18
.L19:
	movq	-72(%rbp), %rax
	testq	%rax, %rax
	jne	.L18
	movq	-64(%rbp), %rax
	movq	%rax, -72(%rbp)
.L18:
	movq	-72(%rbp), %rax
	movq	-64(%rbp), %rcx
	movl	$0, %edx
	divq	%rcx
	movq	%rdx, %rax
	testq	%rax, %rax
	je	.L20
	movq	-72(%rbp), %rdi
	movq	-64(%rbp), %rcx
	movq	-72(%rbp), %rax
	movq	-64(%rbp), %rsi
	movl	$0, %edx
	divq	%rsi
	movq	%rcx, %rax
	subq	%rdx, %rax
	addq	%rdi, %rax
	movq	%rax, -72(%rbp)
.L20:
	movl	-108(%rbp), %ecx
	movl	-112(%rbp), %edx
	leaq	-80(%rbp), %rax
	pushq	%rax
	movl	-104(%rbp), %eax
	pushq	%rax
	movl	%ecx, %r9d
	movl	%edx, %r8d
	movl	$0, %ecx
	leaq	cleanup(%rip), %rax
	movq	%rax, %rdx
	leaq	loop_transfer(%rip), %rax
	movq	%rax, %rsi
	leaq	initialize(%rip), %rax
	movq	%rax, %rdi
	call	benchmp@PLT
	addq	$16, %rsp
	call	usecs_spent@PLT
	testq	%rax, %rax
	je	.L21
	movq	-64(%rbp), %rax
	testq	%rax, %rax
	js	.L22
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L23
.L22:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L23:
	movsd	.LC4(%rip), %xmm1
	divsd	%xmm1, %xmm0
	movq	%xmm0, %rdx
	movq	stderr(%rip), %rax
	movq	%rdx, %xmm0
	leaq	.LC5(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	movl	$1, %eax
	call	fprintf@PLT
	movq	-72(%rbp), %rbx
	call	get_n@PLT
	imulq	%rax, %rbx
	movq	%rbx, %rdx
	movl	-112(%rbp), %eax
	cltq
	imulq	%rdx, %rax
	movq	%rax, %rdi
	call	mb@PLT
.L21:
	movl	$0, %eax
	movq	-24(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L25
	call	__stack_chk_fail@PLT
.L25:
	movq	-8(%rbp), %rbx
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE8:
	.size	main, .-main
	.section	.rodata
.LC6:
	.string	"valloc"
.LC7:
	.string	"socket connection"
.LC8:
	.string	"%lu"
.LC9:
	.string	"control write"
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
	pushq	%rbx
	subq	$152, %rsp
	.cfi_offset 3, -24
	movq	%rdi, -152(%rbp)
	movq	%rsi, -160(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -24(%rbp)
	xorl	%eax, %eax
	movq	-160(%rbp), %rax
	movq	%rax, -136(%rbp)
	cmpq	$0, -152(%rbp)
	jne	.L33
	movq	-136(%rbp), %rax
	movq	16(%rax), %rax
	movq	%rax, %rdi
	call	valloc@PLT
	movq	%rax, %rdx
	movq	-136(%rbp), %rax
	movq	%rdx, 40(%rax)
	movq	-136(%rbp), %rax
	movq	40(%rax), %rax
	testq	%rax, %rax
	jne	.L29
	leaq	.LC6(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L29:
	movq	-136(%rbp), %rax
	movq	16(%rax), %rdx
	movq	-136(%rbp), %rax
	movq	40(%rax), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	touch@PLT
	movq	-136(%rbp), %rax
	movq	24(%rax), %rax
	movl	$11, %edx
	movl	$-31236, %esi
	movq	%rax, %rdi
	call	tcp_connect@PLT
	movq	-136(%rbp), %rdx
	movl	%eax, (%rdx)
	movq	-136(%rbp), %rax
	movl	(%rax), %eax
	testl	%eax, %eax
	jns	.L30
	leaq	.LC7(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L30:
	movq	-136(%rbp), %rax
	movq	16(%rax), %rdx
	leaq	-128(%rbp), %rax
	leaq	.LC8(%rip), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	sprintf@PLT
	leaq	-128(%rbp), %rax
	movq	%rax, %rdi
	call	strlen@PLT
	leaq	1(%rax), %rdx
	movq	-136(%rbp), %rax
	movl	(%rax), %eax
	leaq	-128(%rbp), %rcx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	write@PLT
	movq	%rax, %rbx
	leaq	-128(%rbp), %rax
	movq	%rax, %rdi
	call	strlen@PLT
	addq	$1, %rax
	cmpq	%rax, %rbx
	je	.L26
	leaq	.LC9(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L33:
	nop
.L26:
	movq	-24(%rbp), %rax
	subq	%fs:40, %rax
	je	.L32
	call	__stack_chk_fail@PLT
.L32:
	movq	-8(%rbp), %rbx
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE9:
	.size	initialize, .-initialize
	.globl	loop_transfer
	.type	loop_transfer, @function
loop_transfer:
.LFB10:
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
	movq	-48(%rbp), %rax
	movq	%rax, -8(%rbp)
	jmp	.L35
.L40:
	movq	-8(%rbp), %rax
	movq	8(%rax), %rax
	movq	%rax, -16(%rbp)
	jmp	.L36
.L39:
	movq	-8(%rbp), %rax
	movq	16(%rax), %rdx
	movq	-8(%rbp), %rax
	movq	40(%rax), %rcx
	movq	-8(%rbp), %rax
	movl	(%rax), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	read@PLT
	movl	%eax, -20(%rbp)
	cmpl	$0, -20(%rbp)
	jg	.L37
	movl	$1, %edi
	call	exit@PLT
.L37:
	movl	-20(%rbp), %eax
	cltq
	cmpq	%rax, -16(%rbp)
	jnb	.L38
	movq	-16(%rbp), %rax
	movl	%eax, -20(%rbp)
.L38:
	movl	-20(%rbp), %eax
	cltq
	subq	%rax, -16(%rbp)
.L36:
	cmpq	$0, -16(%rbp)
	jne	.L39
.L35:
	movq	-40(%rbp), %rax
	leaq	-1(%rax), %rdx
	movq	%rdx, -40(%rbp)
	testq	%rax, %rax
	jne	.L40
	nop
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE10:
	.size	loop_transfer, .-loop_transfer
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
	jne	.L44
	movq	-8(%rbp), %rax
	movl	(%rax), %eax
	movl	%eax, %edi
	call	close@PLT
	jmp	.L41
.L44:
	nop
.L41:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE11:
	.size	cleanup, .-cleanup
	.section	.rodata
.LC10:
	.string	"server socket creation"
.LC11:
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
	movl	$10, %esi
	movl	$-31236, %edi
	call	tcp_server@PLT
	movl	%eax, -8(%rbp)
	cmpl	$0, -8(%rbp)
	jns	.L46
	leaq	.LC10(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L46:
	movq	sigchld_wait_handler@GOTPCREL(%rip), %rax
	movq	%rax, %rsi
	movl	$17, %edi
	call	signal@PLT
.L51:
	movl	-8(%rbp), %eax
	movl	$2, %esi
	movl	%eax, %edi
	call	tcp_accept@PLT
	movl	%eax, -4(%rbp)
	call	fork@PLT
	cmpl	$-1, %eax
	je	.L47
	testl	%eax, %eax
	je	.L48
	jmp	.L52
.L47:
	leaq	.LC11(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	jmp	.L50
.L48:
	movl	-4(%rbp), %eax
	movl	%eax, %edi
	call	source
	movl	$0, %edi
	call	exit@PLT
.L52:
	movl	-4(%rbp), %eax
	movl	%eax, %edi
	call	close@PLT
	nop
.L50:
	jmp	.L51
	.cfi_endproc
.LFE12:
	.size	server_main, .-server_main
	.section	.rodata
.LC12:
	.string	"control nbytes"
	.text
	.globl	source
	.type	source, @function
source:
.LFB13:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$160, %rsp
	movl	%edi, -148(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	leaq	-112(%rbp), %rax
	movq	%rax, %rdx
	movl	$0, %eax
	movl	$12, %ecx
	movq	%rdx, %rdi
	rep stosq
	movq	%rdi, %rdx
	movl	%eax, (%rdx)
	addq	$4, %rdx
	leaq	-112(%rbp), %rcx
	movl	-148(%rbp), %eax
	movl	$100, %edx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	read@PLT
	testq	%rax, %rax
	jg	.L54
	leaq	.LC12(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$7, %edi
	call	exit@PLT
.L54:
	leaq	-136(%rbp), %rdx
	leaq	-112(%rbp), %rax
	leaq	.LC8(%rip), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf@PLT
	movq	-136(%rbp), %rax
	movq	%rax, -128(%rbp)
	cmpq	$0, -128(%rbp)
	jne	.L55
	movl	$-31236, %edi
	call	tcp_done@PLT
	call	getppid@PLT
	movl	$15, %esi
	movl	%eax, %edi
	call	kill@PLT
	movl	$0, %edi
	call	exit@PLT
.L55:
	movq	-128(%rbp), %rax
	movq	%rax, %rdi
	call	valloc@PLT
	movq	%rax, -120(%rbp)
	cmpq	$0, -120(%rbp)
	jne	.L56
	leaq	.LC6(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L56:
	movq	-120(%rbp), %rax
	movq	%rax, %rcx
	movq	-128(%rbp), %rax
	movq	%rax, %rdx
	movl	$0, %esi
	movq	%rcx, %rdi
	call	memset@PLT
	nop
.L57:
	movq	-128(%rbp), %rdx
	movq	-120(%rbp), %rcx
	movl	-148(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	write@PLT
	movq	-128(%rbp), %rdx
	cmpq	%rdx, %rax
	je	.L57
	movq	-120(%rbp), %rax
	movq	%rax, %rdi
	call	free@PLT
	nop
	movq	-8(%rbp), %rax
	subq	%fs:40, %rax
	je	.L58
	call	__stack_chk_fail@PLT
.L58:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE13:
	.size	source, .-source
	.section	.rodata
	.align 8
.LC4:
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
