	.file	"bw_unix.c"
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
	.globl	XFER
	.data
	.align 8
	.type	XFER, @object
	.size	XFER, 8
XFER:
	.quad	10485760
	.section	.rodata
.LC1:
	.string	"socketpair"
.LC2:
	.string	"pipe"
.LC3:
	.string	"fork"
	.text
	.globl	initialize
	.type	initialize, @function
initialize:
.LFB8:
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
	jne	.L9
	movl	$65536, %edi
	call	valloc@PLT
	movq	%rax, %rdx
	movq	-8(%rbp), %rax
	movq	%rdx, 24(%rax)
	movq	-8(%rbp), %rax
	movq	24(%rax), %rax
	movl	$65536, %esi
	movq	%rax, %rdi
	call	touch@PLT
	movq	-8(%rbp), %rax
	movl	$0, 48(%rax)
	movq	-8(%rbp), %rax
	addq	$32, %rax
	movq	%rax, %rcx
	movl	$0, %edx
	movl	$1, %esi
	movl	$1, %edi
	call	socketpair@PLT
	cmpl	$-1, %eax
	jne	.L4
	leaq	.LC1(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movq	-8(%rbp), %rax
	movl	$1, 48(%rax)
	jmp	.L1
.L4:
	movq	-8(%rbp), %rax
	addq	$40, %rax
	movq	%rax, %rdi
	call	pipe@PLT
	cmpl	$-1, %eax
	jne	.L5
	leaq	.LC2(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movq	-8(%rbp), %rax
	movl	$2, 48(%rax)
	jmp	.L1
.L5:
	movl	$0, %eax
	call	benchmp_childid@PLT
	movl	$1, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	handle_scheduler@PLT
	call	fork@PLT
	movl	%eax, %edx
	movq	-8(%rbp), %rax
	movl	%edx, (%rax)
	movq	-8(%rbp), %rax
	movl	(%rax), %eax
	cmpl	$-1, %eax
	je	.L6
	testl	%eax, %eax
	jne	.L10
	movl	$0, %eax
	call	benchmp_childid@PLT
	movl	$1, %edx
	movl	$1, %esi
	movl	%eax, %edi
	call	handle_scheduler@PLT
	movq	-8(%rbp), %rax
	movl	44(%rax), %eax
	movl	%eax, %edi
	call	close@PLT
	movq	-8(%rbp), %rax
	movl	32(%rax), %eax
	movl	%eax, %edi
	call	close@PLT
	movq	-8(%rbp), %rax
	movq	24(%rax), %rdx
	movq	-8(%rbp), %rax
	movl	36(%rax), %esi
	movq	-8(%rbp), %rax
	movl	40(%rax), %eax
	movq	-8(%rbp), %rcx
	movl	%eax, %edi
	call	writer
	jmp	.L1
.L6:
	leaq	.LC3(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movq	-8(%rbp), %rax
	movl	$3, 48(%rax)
	jmp	.L1
.L10:
	nop
	movq	-8(%rbp), %rax
	movl	40(%rax), %eax
	movl	%eax, %edi
	call	close@PLT
	movq	-8(%rbp), %rax
	movl	36(%rax), %eax
	movl	%eax, %edi
	call	close@PLT
	jmp	.L1
.L9:
	nop
.L1:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE8:
	.size	initialize, .-initialize
	.globl	cleanup
	.type	cleanup, @function
cleanup:
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
	jne	.L15
	movq	-8(%rbp), %rax
	movl	44(%rax), %eax
	movl	%eax, %edi
	call	close@PLT
	movq	-8(%rbp), %rax
	movl	32(%rax), %eax
	movl	%eax, %edi
	call	close@PLT
	movq	-8(%rbp), %rax
	movl	(%rax), %eax
	testl	%eax, %eax
	jle	.L14
	movq	-8(%rbp), %rax
	movl	(%rax), %eax
	movl	$9, %esi
	movl	%eax, %edi
	call	kill@PLT
	movq	-8(%rbp), %rax
	movl	(%rax), %eax
	movl	$0, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	waitpid@PLT
.L14:
	movq	-8(%rbp), %rax
	movl	$0, (%rax)
	jmp	.L11
.L15:
	nop
.L11:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE9:
	.size	cleanup, .-cleanup
	.globl	reader
	.type	reader, @function
reader:
.LFB10:
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
	movq	%rax, -24(%rbp)
	movq	-24(%rbp), %rax
	movq	16(%rax), %rax
	movq	%rax, -40(%rbp)
	jmp	.L17
.L21:
	movq	-24(%rbp), %rax
	movl	44(%rax), %eax
	leaq	-40(%rbp), %rcx
	movl	$8, %edx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	write@PLT
	movq	$0, -32(%rbp)
	jmp	.L18
.L20:
	movq	-24(%rbp), %rax
	movq	8(%rax), %rdx
	movq	-24(%rbp), %rax
	movq	24(%rax), %rcx
	movq	-24(%rbp), %rax
	movl	32(%rax), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	read@PLT
	movq	%rax, -16(%rbp)
	cmpq	$0, -16(%rbp)
	jne	.L19
	movl	$1, %edi
	call	exit@PLT
.L19:
	movq	-16(%rbp), %rax
	addq	%rax, -32(%rbp)
.L18:
	movq	-40(%rbp), %rax
	cmpq	%rax, -32(%rbp)
	jb	.L20
.L17:
	movq	-56(%rbp), %rax
	leaq	-1(%rax), %rdx
	movq	%rdx, -56(%rbp)
	testq	%rax, %rax
	jne	.L21
	nop
	movq	-8(%rbp), %rax
	subq	%fs:40, %rax
	je	.L22
	call	__stack_chk_fail@PLT
.L22:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE10:
	.size	reader, .-reader
	.globl	writer
	.type	writer, @function
writer:
.LFB11:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$80, %rsp
	movl	%edi, -52(%rbp)
	movl	%esi, -56(%rbp)
	movq	%rdx, -64(%rbp)
	movq	%rcx, -72(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movq	-72(%rbp), %rax
	movq	%rax, -24(%rbp)
.L27:
	leaq	-40(%rbp), %rcx
	movl	-52(%rbp), %eax
	movl	$8, %edx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	read@PLT
	movq	$0, -32(%rbp)
	jmp	.L24
.L26:
	movq	-24(%rbp), %rax
	movq	8(%rax), %rdx
	movq	-64(%rbp), %rcx
	movl	-56(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	write@PLT
	movq	%rax, -16(%rbp)
	cmpq	$0, -16(%rbp)
	jns	.L25
	movl	$1, %edi
	call	exit@PLT
.L25:
	movq	-16(%rbp), %rax
	addq	%rax, -32(%rbp)
.L24:
	movq	-40(%rbp), %rax
	cmpq	%rax, -32(%rbp)
	jb	.L26
	jmp	.L27
	.cfi_endproc
.LFE11:
	.size	writer, .-writer
	.section	.rodata
	.align 8
.LC4:
	.string	"[-m <message size>] [-M <total bytes>] [-P <parallelism>] [-W <warmup>] [-N <repetitions>]\n"
.LC5:
	.string	"m:M:P:W:N:"
	.align 8
.LC6:
	.string	"AF_UNIX sock stream bandwidth: "
	.text
	.globl	main
	.type	main, @function
main:
.LFB12:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$112, %rsp
	movl	%edi, -100(%rbp)
	movq	%rsi, -112(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movl	$1, -88(%rbp)
	movl	$0, -84(%rbp)
	movl	$-1, -80(%rbp)
	leaq	.LC4(%rip), %rax
	movq	%rax, -72(%rbp)
	movq	$65536, -56(%rbp)
	movq	XFER(%rip), %rax
	movq	%rax, -48(%rbp)
	jmp	.L30
.L39:
	movl	-76(%rbp), %eax
	subl	$77, %eax
	cmpl	$32, %eax
	ja	.L31
	movl	%eax, %eax
	leaq	0(,%rax,4), %rdx
	leaq	.L33(%rip), %rax
	movl	(%rdx,%rax), %eax
	cltq
	leaq	.L33(%rip), %rdx
	addq	%rdx, %rax
	notrack jmp	*%rax
	.section	.rodata
	.align 4
	.align 4
.L33:
	.long	.L37-.L33
	.long	.L36-.L33
	.long	.L31-.L33
	.long	.L35-.L33
	.long	.L31-.L33
	.long	.L31-.L33
	.long	.L31-.L33
	.long	.L31-.L33
	.long	.L31-.L33
	.long	.L31-.L33
	.long	.L34-.L33
	.long	.L31-.L33
	.long	.L31-.L33
	.long	.L31-.L33
	.long	.L31-.L33
	.long	.L31-.L33
	.long	.L31-.L33
	.long	.L31-.L33
	.long	.L31-.L33
	.long	.L31-.L33
	.long	.L31-.L33
	.long	.L31-.L33
	.long	.L31-.L33
	.long	.L31-.L33
	.long	.L31-.L33
	.long	.L31-.L33
	.long	.L31-.L33
	.long	.L31-.L33
	.long	.L31-.L33
	.long	.L31-.L33
	.long	.L31-.L33
	.long	.L31-.L33
	.long	.L32-.L33
	.text
.L32:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	bytes@PLT
	movq	%rax, -56(%rbp)
	jmp	.L30
.L37:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	bytes@PLT
	movq	%rax, -48(%rbp)
	jmp	.L30
.L35:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -88(%rbp)
	cmpl	$0, -88(%rbp)
	jg	.L30
	movq	-72(%rbp), %rdx
	movq	-112(%rbp), %rcx
	movl	-100(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	lmbench_usage@PLT
	jmp	.L30
.L34:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -84(%rbp)
	jmp	.L30
.L36:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -80(%rbp)
	jmp	.L30
.L31:
	movq	-72(%rbp), %rdx
	movq	-112(%rbp), %rcx
	movl	-100(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	lmbench_usage@PLT
	nop
.L30:
	movq	-112(%rbp), %rcx
	movl	-100(%rbp), %eax
	leaq	.LC5(%rip), %rdx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	mygetopt@PLT
	movl	%eax, -76(%rbp)
	cmpl	$-1, -76(%rbp)
	jne	.L39
	movl	-100(%rbp), %eax
	leal	-1(%rax), %edx
	movl	myoptind(%rip), %eax
	cmpl	%eax, %edx
	jne	.L40
	movl	myoptind(%rip), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-112(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	bytes@PLT
	movq	%rax, -48(%rbp)
	jmp	.L41
.L40:
	movl	-100(%rbp), %eax
	leal	-1(%rax), %edx
	movl	myoptind(%rip), %eax
	cmpl	%eax, %edx
	jle	.L41
	movq	-72(%rbp), %rdx
	movq	-112(%rbp), %rcx
	movl	-100(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	lmbench_usage@PLT
.L41:
	movl	$0, -64(%rbp)
	movq	-48(%rbp), %rax
	movq	-56(%rbp), %rcx
	movl	$0, %edx
	divq	%rcx
	movq	%rdx, %rax
	testq	%rax, %rax
	je	.L42
	movq	-48(%rbp), %rdi
	movq	-48(%rbp), %rcx
	movq	-48(%rbp), %rax
	movq	-56(%rbp), %rsi
	movl	$0, %edx
	divq	%rsi
	movq	%rcx, %rax
	subq	%rdx, %rax
	addq	%rdi, %rax
	movq	%rax, -48(%rbp)
.L42:
	movl	-84(%rbp), %ecx
	movl	-88(%rbp), %edx
	leaq	-64(%rbp), %rax
	pushq	%rax
	movl	-80(%rbp), %eax
	pushq	%rax
	movl	%ecx, %r9d
	movl	%edx, %r8d
	movl	$2000000, %ecx
	leaq	cleanup(%rip), %rax
	movq	%rax, %rdx
	leaq	reader(%rip), %rax
	movq	%rax, %rsi
	leaq	initialize(%rip), %rax
	movq	%rax, %rdi
	call	benchmp@PLT
	addq	$16, %rsp
	call	usecs_spent@PLT
	testq	%rax, %rax
	je	.L43
	movq	stderr(%rip), %rax
	movq	%rax, %rcx
	movl	$31, %edx
	movl	$1, %esi
	leaq	.LC6(%rip), %rax
	movq	%rax, %rdi
	call	fwrite@PLT
	call	get_n@PLT
	movl	-88(%rbp), %edx
	movslq	%edx, %rdx
	imulq	%rax, %rdx
	movq	XFER(%rip), %rax
	imulq	%rdx, %rax
	movq	%rax, %rdi
	call	mb@PLT
.L43:
	movl	$0, %eax
	movq	-8(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L45
	call	__stack_chk_fail@PLT
.L45:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE12:
	.size	main, .-main
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
