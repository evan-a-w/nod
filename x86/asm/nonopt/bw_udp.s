	.file	"bw_udp.c"
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
	.string	"-s\n OR [-m <message size>] [-W <warmup>] [-N <repetitions>] server [size]\n OR -S serverhost\n"
.LC2:
	.string	"sS:m:W:N:"
.LC3:
	.string	"valloc"
	.align 8
.LC4:
	.string	"socket UDP bandwidth using %s: "
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
	subq	$136, %rsp
	.cfi_offset 3, -24
	movl	%edi, -132(%rbp)
	movq	%rsi, -144(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -24(%rbp)
	xorl	%eax, %eax
	movl	$1, -104(%rbp)
	movl	$0, -116(%rbp)
	movl	$-1, -112(%rbp)
	movl	$0, -100(%rbp)
	leaq	.LC1(%rip), %rax
	movq	%rax, -88(%rbp)
	movq	$0, -64(%rbp)
	movq	$10485760, -72(%rbp)
	jmp	.L2
.L13:
	movl	-96(%rbp), %eax
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
	.long	.L9-.L5
	.long	.L3-.L5
	.long	.L3-.L5
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
	jne	.L10
	movl	$0, %eax
	call	server_main
.L10:
	movl	$0, %edi
	call	exit@PLT
.L8:
	movq	myoptarg(%rip), %rax
	movl	$0, %edx
	movq	$-31238, %rsi
	movq	%rax, %rdi
	call	udp_connect@PLT
	movl	%eax, -92(%rbp)
	movl	$-1, -108(%rbp)
	jmp	.L11
.L12:
	movl	-108(%rbp), %eax
	movl	%eax, %edi
	call	htonl@PLT
	movl	%eax, -120(%rbp)
	leaq	-120(%rbp), %rsi
	movl	-92(%rbp), %eax
	movl	$0, %ecx
	movl	$4, %edx
	movl	%eax, %edi
	call	send@PLT
	subl	$1, -108(%rbp)
.L11:
	cmpl	$-4, -108(%rbp)
	jge	.L12
	movl	-92(%rbp), %eax
	movl	%eax, %edi
	call	close@PLT
	movl	$0, %edi
	call	exit@PLT
.L6:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	cltq
	movq	%rax, -64(%rbp)
	jmp	.L2
.L7:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -116(%rbp)
	jmp	.L2
.L9:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -112(%rbp)
	jmp	.L2
.L3:
	movq	-88(%rbp), %rdx
	movq	-144(%rbp), %rcx
	movl	-132(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	lmbench_usage@PLT
	nop
.L2:
	movq	-144(%rbp), %rcx
	movl	-132(%rbp), %eax
	leaq	.LC2(%rip), %rdx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	mygetopt@PLT
	movl	%eax, -96(%rbp)
	cmpl	$-1, -96(%rbp)
	jne	.L13
	movl	-132(%rbp), %eax
	leal	-2(%rax), %edx
	movl	myoptind(%rip), %eax
	cmpl	%eax, %edx
	jg	.L14
	movl	myoptind(%rip), %eax
	cmpl	%eax, -132(%rbp)
	jg	.L15
.L14:
	movq	-88(%rbp), %rdx
	movq	-144(%rbp), %rcx
	movl	-132(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	lmbench_usage@PLT
.L15:
	movl	myoptind(%rip), %eax
	leal	1(%rax), %edx
	movl	%edx, myoptind(%rip)
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-144(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	%rax, -56(%rbp)
	movl	myoptind(%rip), %eax
	cmpl	%eax, -132(%rbp)
	jle	.L16
	movl	myoptind(%rip), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-144(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	bytes@PLT
	movq	%rax, -72(%rbp)
.L16:
	movq	-64(%rbp), %rax
	testq	%rax, %rax
	jne	.L17
	movq	-72(%rbp), %rax
	movq	%rax, -64(%rbp)
.L17:
	movq	-72(%rbp), %rax
	movq	-64(%rbp), %rcx
	cqto
	idivq	%rcx
	movq	%rdx, %rax
	testq	%rax, %rax
	je	.L18
	movq	-72(%rbp), %rdi
	movq	-72(%rbp), %rcx
	movq	-72(%rbp), %rax
	movq	-64(%rbp), %rsi
	cqto
	idivq	%rsi
	movq	%rcx, %rax
	subq	%rdx, %rax
	addq	%rdi, %rax
	movq	%rax, -72(%rbp)
.L18:
	movq	-64(%rbp), %rax
	movq	%rax, %rdi
	call	valloc@PLT
	movq	%rax, -40(%rbp)
	movq	-40(%rbp), %rax
	testq	%rax, %rax
	jne	.L19
	leaq	.LC3(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L19:
	movq	-64(%rbp), %rax
	movq	%rax, %rdx
	movq	-40(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	touch@PLT
	movl	-116(%rbp), %ecx
	movl	-104(%rbp), %edx
	leaq	-80(%rbp), %rax
	pushq	%rax
	movl	-112(%rbp), %eax
	pushq	%rax
	movl	%ecx, %r9d
	movl	%edx, %r8d
	movl	$7500000, %ecx
	leaq	cleanup(%rip), %rax
	movq	%rax, %rdx
	leaq	loop_transfer(%rip), %rax
	movq	%rax, %rsi
	leaq	init(%rip), %rax
	movq	%rax, %rdi
	call	benchmp@PLT
	addq	$16, %rsp
.L20:
	movq	-56(%rbp), %rdx
	movq	stderr(%rip), %rax
	leaq	.LC4(%rip), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf@PLT
	movq	-72(%rbp), %rax
	movq	%rax, %rbx
	call	get_n@PLT
	imulq	%rax, %rbx
	movq	%rbx, %rdx
	movl	-104(%rbp), %eax
	cltq
	imulq	%rdx, %rax
	movq	%rax, %rdi
	call	mb@PLT
	movl	$0, %eax
	movq	-24(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L22
	call	__stack_chk_fail@PLT
.L22:
	movq	-8(%rbp), %rbx
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE8:
	.size	main, .-main
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
	jne	.L26
	movq	-8(%rbp), %rax
	movq	24(%rax), %rax
	movl	$0, %edx
	movq	$-31238, %rsi
	movq	%rax, %rdi
	call	udp_connect@PLT
	movq	-8(%rbp), %rdx
	movl	%eax, (%rdx)
	movq	-8(%rbp), %rax
	movl	$0, 4(%rax)
	movq	-8(%rbp), %rax
	movq	16(%rax), %rax
	movq	%rax, %rdi
	call	malloc@PLT
	movq	%rax, %rdx
	movq	-8(%rbp), %rax
	movq	%rdx, 40(%rax)
	jmp	.L23
.L26:
	nop
.L23:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE9:
	.size	init, .-init
	.section	.rodata
.LC5:
	.string	"bw_udp client: send failed"
.LC6:
	.string	"bw_udp client: recv failed"
	.text
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
	subq	$80, %rsp
	movq	%rdi, -72(%rbp)
	movq	%rsi, -80(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movq	-80(%rbp), %rax
	movq	%rax, -48(%rbp)
	movq	-48(%rbp), %rax
	movq	24(%rax), %rax
	movq	%rax, -40(%rbp)
	movq	-48(%rbp), %rax
	movl	(%rax), %eax
	movl	%eax, -60(%rbp)
	movq	-48(%rbp), %rax
	movq	8(%rax), %rax
	movq	%rax, -56(%rbp)
	movq	-48(%rbp), %rax
	movq	8(%rax), %rax
	movq	%rax, -32(%rbp)
	movq	-48(%rbp), %rax
	movq	16(%rax), %rax
	movq	%rax, -24(%rbp)
	jmp	.L28
.L33:
	leaq	-32(%rbp), %rsi
	movl	-60(%rbp), %eax
	movl	$0, %ecx
	movl	$16, %edx
	movl	%eax, %edi
	call	send@PLT
	cmpq	$16, %rax
	je	.L30
	leaq	.LC5(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$5, %edi
	call	exit@PLT
.L32:
	movq	-48(%rbp), %rax
	movq	16(%rax), %rax
	movq	%rax, %rdx
	movq	-48(%rbp), %rax
	movq	40(%rax), %rsi
	movl	-60(%rbp), %eax
	movl	$0, %ecx
	movl	%eax, %edi
	call	recv@PLT
	movq	-48(%rbp), %rdx
	movq	16(%rdx), %rdx
	cmpq	%rdx, %rax
	je	.L31
	leaq	.LC6(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$5, %edi
	call	exit@PLT
.L31:
	movq	-48(%rbp), %rax
	movq	16(%rax), %rax
	subq	%rax, -56(%rbp)
.L30:
	cmpq	$0, -56(%rbp)
	jg	.L32
.L28:
	movq	-72(%rbp), %rax
	leaq	-1(%rax), %rdx
	movq	%rdx, -72(%rbp)
	testq	%rax, %rax
	jne	.L33
	nop
	movq	-8(%rbp), %rax
	subq	%fs:40, %rax
	je	.L34
	call	__stack_chk_fail@PLT
.L34:
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
	jne	.L38
	movq	-8(%rbp), %rax
	movl	(%rax), %eax
	movl	%eax, %edi
	call	close@PLT
	movq	-8(%rbp), %rax
	movq	40(%rax), %rax
	movq	%rax, %rdi
	call	free@PLT
	jmp	.L35
.L38:
	nop
.L35:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE11:
	.size	cleanup, .-cleanup
	.section	.rodata
	.align 8
.LC7:
	.string	"bw_udp server: recvfrom: got wrong size\n"
.LC8:
	.string	"bw_udp sendto"
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
	subq	$80, %rsp
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movl	$10485760, %edi
	call	valloc@PLT
	movq	%rax, -48(%rbp)
	movl	$0, -64(%rbp)
	movq	exit@GOTPCREL(%rip), %rax
	movq	%rax, %rsi
	movl	$14, %edi
	call	signal@PLT
	movl	$3600, %edi
	call	alarm@PLT
	movl	$0, %esi
	movq	$-31238, %rdi
	call	udp_server@PLT
	movl	%eax, -60(%rbp)
.L44:
	movl	$16, -68(%rbp)
	leaq	-68(%rbp), %rcx
	leaq	-32(%rbp), %rdx
	movq	-48(%rbp), %rsi
	movl	-60(%rbp), %eax
	movq	%rcx, %r9
	movq	%rdx, %r8
	movl	$0, %ecx
	movl	$16, %edx
	movl	%eax, %edi
	call	recvfrom@PLT
	testq	%rax, %rax
	jns	.L40
	movq	stderr(%rip), %rax
	movq	%rax, %rcx
	movl	$40, %edx
	movl	$1, %esi
	leaq	.LC7(%rip), %rax
	movq	%rax, %rdi
	call	fwrite@PLT
	movl	$9, %edi
	call	exit@PLT
.L40:
	movq	-48(%rbp), %rax
	movq	(%rax), %rax
	movl	%eax, %edi
	call	ntohl@PLT
	movl	%eax, %eax
	movq	%rax, -56(%rbp)
	movq	-48(%rbp), %rax
	addq	$8, %rax
	movq	(%rax), %rax
	movl	%eax, %edi
	call	ntohl@PLT
	movl	%eax, %eax
	movq	%rax, -40(%rbp)
	jmp	.L41
.L43:
	movq	-40(%rbp), %rdx
	leaq	-32(%rbp), %rcx
	movq	-48(%rbp), %rsi
	movl	-60(%rbp), %eax
	movl	$16, %r9d
	movq	%rcx, %r8
	movl	$0, %ecx
	movl	%eax, %edi
	call	sendto@PLT
	testq	%rax, %rax
	jns	.L42
	leaq	.LC8(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$9, %edi
	call	exit@PLT
.L42:
	movq	-40(%rbp), %rax
	subq	%rax, -56(%rbp)
.L41:
	cmpq	$0, -56(%rbp)
	jg	.L43
	jmp	.L44
	.cfi_endproc
.LFE12:
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
