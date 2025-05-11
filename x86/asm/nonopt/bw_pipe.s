	.file	"bw_pipe.c"
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
	.align 4
	.type	XFER, @object
	.size	XFER, 4
XFER:
	.long	10485760
	.section	.rodata
.LC1:
	.string	"pipe"
.LC2:
	.string	"child: no memory"
.LC3:
	.string	"fork"
.LC4:
	.string	"parent: no memory"
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
	pushq	%rbx
	subq	$56, %rsp
	.cfi_offset 3, -24
	movq	%rdi, -56(%rbp)
	movq	%rsi, -64(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -24(%rbp)
	xorl	%eax, %eax
	movq	-64(%rbp), %rax
	movq	%rax, -40(%rbp)
	cmpq	$0, -56(%rbp)
	jne	.L12
	leaq	-32(%rbp), %rax
	movq	%rax, %rdi
	call	pipe@PLT
	cmpl	$-1, %eax
	jne	.L4
	leaq	.LC1(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L4:
	movl	$0, %eax
	call	benchmp_childid@PLT
	movl	$1, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	handle_scheduler@PLT
	call	fork@PLT
	movl	%eax, %edx
	movq	-40(%rbp), %rax
	movl	%edx, (%rax)
	movq	-40(%rbp), %rax
	movl	(%rax), %eax
	cmpl	$-1, %eax
	je	.L5
	testl	%eax, %eax
	jne	.L13
	movl	-32(%rbp), %eax
	movl	%eax, %edi
	call	close@PLT
	movl	$0, %eax
	call	benchmp_childid@PLT
	movl	$1, %edx
	movl	$1, %esi
	movl	%eax, %edi
	call	handle_scheduler@PLT
	movq	-40(%rbp), %rax
	movq	8(%rax), %rax
	movq	%rax, %rdi
	call	valloc@PLT
	movq	%rax, %rdx
	movq	-40(%rbp), %rax
	movq	%rdx, 24(%rax)
	movq	-40(%rbp), %rax
	movq	24(%rax), %rax
	testq	%rax, %rax
	jne	.L7
	leaq	.LC2(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$2, %edi
	call	exit@PLT
.L7:
	movq	-40(%rbp), %rax
	movq	8(%rax), %rdx
	movq	-40(%rbp), %rax
	movq	24(%rax), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	touch@PLT
	movq	-40(%rbp), %rax
	movq	8(%rax), %rdx
	movq	-40(%rbp), %rax
	movq	24(%rax), %rcx
	movl	-28(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	writer
	jmp	.L1
.L5:
	leaq	.LC3(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$3, %edi
	call	exit@PLT
.L13:
	nop
	movl	-28(%rbp), %eax
	movl	%eax, %edi
	call	close@PLT
	movl	-32(%rbp), %edx
	movq	-40(%rbp), %rax
	movl	%edx, 32(%rax)
	movq	-40(%rbp), %rax
	movq	8(%rax), %rbx
	call	getpagesize@PLT
	cltq
	addq	%rbx, %rax
	movq	%rax, %rdi
	call	valloc@PLT
	movq	%rax, %rdx
	movq	-40(%rbp), %rax
	movq	%rdx, 24(%rax)
	movq	-40(%rbp), %rax
	movq	24(%rax), %rax
	testq	%rax, %rax
	jne	.L8
	leaq	.LC4(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$4, %edi
	call	exit@PLT
.L8:
	movq	-40(%rbp), %rax
	movq	8(%rax), %rbx
	call	getpagesize@PLT
	cltq
	leaq	(%rbx,%rax), %rdx
	movq	-40(%rbp), %rax
	movq	24(%rax), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	touch@PLT
	movq	-40(%rbp), %rax
	movq	24(%rax), %rax
	leaq	128(%rax), %rdx
	movq	-40(%rbp), %rax
	movq	%rdx, 24(%rax)
	jmp	.L1
.L12:
	nop
.L1:
	movq	-24(%rbp), %rax
	subq	%fs:40, %rax
	je	.L10
	call	__stack_chk_fail@PLT
.L10:
	movq	-8(%rbp), %rbx
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
	jne	.L18
	movq	-8(%rbp), %rax
	movl	32(%rax), %eax
	movl	%eax, %edi
	call	close@PLT
	movq	-8(%rbp), %rax
	movl	(%rax), %eax
	testl	%eax, %eax
	jle	.L17
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
.L17:
	movq	-8(%rbp), %rax
	movl	$0, (%rax)
	jmp	.L14
.L18:
	nop
.L14:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE9:
	.size	cleanup, .-cleanup
	.section	.rodata
	.align 8
.LC5:
	.string	"bw_pipe: reader: error in read"
	.text
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
	subq	$48, %rsp
	movq	%rdi, -40(%rbp)
	movq	%rsi, -48(%rbp)
	movq	-48(%rbp), %rax
	movq	%rax, -16(%rbp)
	jmp	.L20
.L24:
	movq	$0, -24(%rbp)
	jmp	.L21
.L23:
	movq	-16(%rbp), %rax
	movq	8(%rax), %rdx
	movq	-16(%rbp), %rax
	movq	24(%rax), %rcx
	movq	-16(%rbp), %rax
	movl	32(%rax), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	read@PLT
	movq	%rax, -8(%rbp)
	cmpq	$0, -8(%rbp)
	jns	.L22
	leaq	.LC5(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L22:
	movq	-8(%rbp), %rax
	addq	%rax, -24(%rbp)
.L21:
	movq	-16(%rbp), %rax
	movq	16(%rax), %rax
	cmpq	%rax, -24(%rbp)
	jb	.L23
.L20:
	movq	-40(%rbp), %rax
	leaq	-1(%rax), %rdx
	movq	%rdx, -40(%rbp)
	testq	%rax, %rax
	jne	.L24
	nop
	nop
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
	subq	$48, %rsp
	movl	%edi, -20(%rbp)
	movq	%rsi, -32(%rbp)
	movq	%rdx, -40(%rbp)
.L29:
	movq	$0, -16(%rbp)
	jmp	.L26
.L28:
	movq	-40(%rbp), %rax
	subq	-16(%rbp), %rax
	movq	%rax, %rdx
	movq	-32(%rbp), %rcx
	movl	-20(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	write@PLT
	movq	%rax, -8(%rbp)
	cmpq	$0, -8(%rbp)
	jns	.L27
	movl	$0, %edi
	call	exit@PLT
.L27:
	movq	-8(%rbp), %rax
	addq	%rax, -16(%rbp)
.L26:
	movq	-16(%rbp), %rax
	cmpq	-40(%rbp), %rax
	jb	.L28
	jmp	.L29
	.cfi_endproc
.LFE11:
	.size	writer, .-writer
	.section	.rodata
	.align 8
.LC6:
	.string	"[-m <message size>] [-M <total bytes>] [-P <parallelism>] [-W <warmup>] [-N <repetitions>]\n"
.LC7:
	.string	"m:M:P:W:N:"
.LC8:
	.string	"Pipe bandwidth: "
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
	subq	$96, %rsp
	movl	%edi, -84(%rbp)
	movq	%rsi, -96(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movl	$1, -72(%rbp)
	movl	$0, -68(%rbp)
	movl	$-1, -64(%rbp)
	leaq	.LC6(%rip), %rax
	movq	%rax, -56(%rbp)
	movq	$65536, -40(%rbp)
	movl	XFER(%rip), %eax
	cltq
	movq	%rax, -32(%rbp)
	jmp	.L31
.L40:
	movl	-60(%rbp), %eax
	subl	$77, %eax
	cmpl	$32, %eax
	ja	.L32
	movl	%eax, %eax
	leaq	0(,%rax,4), %rdx
	leaq	.L34(%rip), %rax
	movl	(%rdx,%rax), %eax
	cltq
	leaq	.L34(%rip), %rdx
	addq	%rdx, %rax
	notrack jmp	*%rax
	.section	.rodata
	.align 4
	.align 4
.L34:
	.long	.L38-.L34
	.long	.L37-.L34
	.long	.L32-.L34
	.long	.L36-.L34
	.long	.L32-.L34
	.long	.L32-.L34
	.long	.L32-.L34
	.long	.L32-.L34
	.long	.L32-.L34
	.long	.L32-.L34
	.long	.L35-.L34
	.long	.L32-.L34
	.long	.L32-.L34
	.long	.L32-.L34
	.long	.L32-.L34
	.long	.L32-.L34
	.long	.L32-.L34
	.long	.L32-.L34
	.long	.L32-.L34
	.long	.L32-.L34
	.long	.L32-.L34
	.long	.L32-.L34
	.long	.L32-.L34
	.long	.L32-.L34
	.long	.L32-.L34
	.long	.L32-.L34
	.long	.L32-.L34
	.long	.L32-.L34
	.long	.L32-.L34
	.long	.L32-.L34
	.long	.L32-.L34
	.long	.L32-.L34
	.long	.L33-.L34
	.text
.L33:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	bytes@PLT
	movq	%rax, -40(%rbp)
	jmp	.L31
.L38:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	bytes@PLT
	movq	%rax, -32(%rbp)
	jmp	.L31
.L36:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -72(%rbp)
	cmpl	$0, -72(%rbp)
	jg	.L31
	movq	-56(%rbp), %rdx
	movq	-96(%rbp), %rcx
	movl	-84(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	lmbench_usage@PLT
	jmp	.L31
.L35:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -68(%rbp)
	jmp	.L31
.L37:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -64(%rbp)
	jmp	.L31
.L32:
	movq	-56(%rbp), %rdx
	movq	-96(%rbp), %rcx
	movl	-84(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	lmbench_usage@PLT
	nop
.L31:
	movq	-96(%rbp), %rcx
	movl	-84(%rbp), %eax
	leaq	.LC7(%rip), %rdx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	mygetopt@PLT
	movl	%eax, -60(%rbp)
	cmpl	$-1, -60(%rbp)
	jne	.L40
	movl	myoptind(%rip), %eax
	cmpl	%eax, -84(%rbp)
	jle	.L41
	movq	-56(%rbp), %rdx
	movq	-96(%rbp), %rcx
	movl	-84(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	lmbench_usage@PLT
.L41:
	movq	-32(%rbp), %rdx
	movq	-40(%rbp), %rax
	cmpq	%rax, %rdx
	jnb	.L42
	movq	-40(%rbp), %rax
	movq	%rax, -32(%rbp)
	jmp	.L43
.L42:
	movq	-32(%rbp), %rax
	movq	-40(%rbp), %rcx
	movl	$0, %edx
	divq	%rcx
	movq	%rdx, %rax
	testq	%rax, %rax
	je	.L43
	movq	-32(%rbp), %rdi
	movq	-32(%rbp), %rcx
	movq	-32(%rbp), %rax
	movq	-40(%rbp), %rsi
	movl	$0, %edx
	divq	%rsi
	movq	%rcx, %rax
	subq	%rdx, %rax
	addq	%rdi, %rax
	movq	%rax, -32(%rbp)
.L43:
	movl	-68(%rbp), %ecx
	movl	-72(%rbp), %edx
	leaq	-48(%rbp), %rax
	pushq	%rax
	movl	-64(%rbp), %eax
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
	je	.L44
	movq	stderr(%rip), %rax
	movq	%rax, %rcx
	movl	$16, %edx
	movl	$1, %esi
	leaq	.LC8(%rip), %rax
	movq	%rax, %rdi
	call	fwrite@PLT
	call	get_n@PLT
	movl	-72(%rbp), %edx
	movslq	%edx, %rdx
	imulq	%rax, %rdx
	movq	-32(%rbp), %rax
	imulq	%rdx, %rax
	movq	%rax, %rdi
	call	mb@PLT
.L44:
	movl	$0, %eax
	movq	-8(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L46
	call	__stack_chk_fail@PLT
.L46:
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
