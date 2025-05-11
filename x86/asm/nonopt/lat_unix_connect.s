	.file	"lat_unix_connect.c"
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
	.string	"/tmp/af_unix"
.LC2:
	.string	"error on iteration %lu\n"
	.text
	.globl	benchmark
	.type	benchmark, @function
benchmark:
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
	jmp	.L2
.L4:
	leaq	.LC1(%rip), %rax
	movq	%rax, %rdi
	call	unix_connect@PLT
	movl	%eax, -4(%rbp)
	cmpl	$0, -4(%rbp)
	jg	.L3
	movq	-24(%rbp), %rax
	movq	%rax, %rsi
	leaq	.LC2(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf@PLT
.L3:
	movl	-4(%rbp), %eax
	movl	%eax, %edi
	call	close@PLT
.L2:
	movq	-24(%rbp), %rax
	leaq	-1(%rax), %rdx
	movq	%rdx, -24(%rbp)
	testq	%rax, %rax
	jne	.L4
	nop
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE8:
	.size	benchmark, .-benchmark
	.section	.rodata
	.align 8
.LC3:
	.string	"-s\n OR [-P <parallelism>] [-W <warmup>] [-N <repetitions>]\n OR -S\n"
.LC4:
	.string	"-s"
.LC5:
	.string	"-S"
.LC6:
	.string	"0"
.LC7:
	.string	"P:W:N:"
.LC8:
	.string	"UNIX connection cost"
	.text
	.globl	main
	.type	main, @function
main:
.LFB9:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$48, %rsp
	movl	%edi, -36(%rbp)
	movq	%rsi, -48(%rbp)
	movl	$1, -28(%rbp)
	movl	$0, -24(%rbp)
	movl	$-1, -20(%rbp)
	leaq	.LC3(%rip), %rax
	movq	%rax, -8(%rbp)
	cmpl	$2, -36(%rbp)
	jne	.L9
	movq	-48(%rbp), %rax
	addq	$8, %rax
	movq	(%rax), %rax
	leaq	.LC4(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L7
	call	fork@PLT
	testl	%eax, %eax
	jne	.L8
	call	server_main
.L8:
	movl	$0, %edi
	call	exit@PLT
.L7:
	movq	-48(%rbp), %rax
	addq	$8, %rax
	movq	(%rax), %rax
	leaq	.LC5(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L9
	leaq	.LC1(%rip), %rax
	movq	%rax, %rdi
	call	unix_connect@PLT
	movl	%eax, -16(%rbp)
	movl	-16(%rbp), %eax
	movl	$1, %edx
	leaq	.LC6(%rip), %rcx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	write@PLT
	movl	-16(%rbp), %eax
	movl	%eax, %edi
	call	close@PLT
	movl	$0, %edi
	call	exit@PLT
.L14:
	cmpl	$87, -12(%rbp)
	je	.L10
	cmpl	$87, -12(%rbp)
	jg	.L11
	cmpl	$78, -12(%rbp)
	je	.L12
	cmpl	$80, -12(%rbp)
	jne	.L11
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -28(%rbp)
	cmpl	$0, -28(%rbp)
	jg	.L9
	movq	-8(%rbp), %rdx
	movq	-48(%rbp), %rcx
	movl	-36(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	lmbench_usage@PLT
	jmp	.L9
.L10:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -24(%rbp)
	jmp	.L9
.L12:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -20(%rbp)
	jmp	.L9
.L11:
	movq	-8(%rbp), %rdx
	movq	-48(%rbp), %rcx
	movl	-36(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	lmbench_usage@PLT
	nop
.L9:
	movq	-48(%rbp), %rcx
	movl	-36(%rbp), %eax
	leaq	.LC7(%rip), %rdx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	mygetopt@PLT
	movl	%eax, -12(%rbp)
	cmpl	$-1, -12(%rbp)
	jne	.L14
	movl	myoptind(%rip), %eax
	cmpl	%eax, -36(%rbp)
	je	.L15
	movq	-8(%rbp), %rdx
	movq	-48(%rbp), %rcx
	movl	-36(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	lmbench_usage@PLT
.L15:
	movl	-24(%rbp), %ecx
	movl	-28(%rbp), %edx
	pushq	$0
	movl	-20(%rbp), %eax
	pushq	%rax
	movl	%ecx, %r9d
	movl	%edx, %r8d
	movl	$0, %ecx
	movl	$0, %edx
	leaq	benchmark(%rip), %rax
	movq	%rax, %rsi
	movl	$0, %edi
	call	benchmp@PLT
	addq	$16, %rsp
	call	get_n@PLT
	movq	%rax, %rsi
	leaq	.LC8(%rip), %rax
	movq	%rax, %rdi
	call	micro@PLT
	movl	$0, %eax
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE9:
	.size	main, .-main
	.globl	server_main
	.type	server_main, @function
server_main:
.LFB10:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movq	exit@GOTPCREL(%rip), %rax
	movq	%rax, %rsi
	movl	$14, %edi
	call	signal@PLT
	movl	$3600, %edi
	call	alarm@PLT
	leaq	.LC1(%rip), %rax
	movq	%rax, %rdi
	call	unix_server@PLT
	movl	%eax, -16(%rbp)
.L19:
	movl	-16(%rbp), %eax
	movl	%eax, %edi
	call	unix_accept@PLT
	movl	%eax, -12(%rbp)
	movb	$0, -17(%rbp)
	leaq	-17(%rbp), %rcx
	movl	-12(%rbp), %eax
	movl	$1, %edx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	read@PLT
	movzbl	-17(%rbp), %eax
	testb	%al, %al
	je	.L18
	movzbl	-17(%rbp), %eax
	cmpb	$48, %al
	jne	.L18
	movl	-16(%rbp), %eax
	leaq	.LC1(%rip), %rdx
	movq	%rdx, %rsi
	movl	%eax, %edi
	call	unix_done@PLT
	movl	$0, %edi
	call	exit@PLT
.L18:
	movl	-12(%rbp), %eax
	movl	%eax, %edi
	call	close@PLT
	jmp	.L19
	.cfi_endproc
.LFE10:
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
