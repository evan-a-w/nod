	.file	"lat_connect.c"
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
	.string	"-s\n OR [-S] [-N <repetitions>] server\n"
.LC2:
	.string	"0"
.LC3:
	.string	"sSP:W:N:"
.LC4:
	.string	"TCP/IP connection cost to %s"
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
	subq	$320, %rsp
	movl	%edi, -308(%rbp)
	movq	%rsi, -320(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movl	$-1, -300(%rbp)
	leaq	.LC1(%rip), %rax
	movq	%rax, -280(%rbp)
	jmp	.L2
.L8:
	cmpl	$115, -296(%rbp)
	je	.L3
	cmpl	$115, -296(%rbp)
	jg	.L4
	cmpl	$78, -296(%rbp)
	je	.L5
	cmpl	$83, -296(%rbp)
	je	.L6
	jmp	.L4
.L3:
	call	fork@PLT
	testl	%eax, %eax
	jne	.L7
	movl	$0, %eax
	call	server_main
.L7:
	movl	$0, %edi
	call	exit@PLT
.L6:
	movl	myoptind(%rip), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-320(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movl	$0, %edx
	movl	$-31237, %esi
	movq	%rax, %rdi
	call	tcp_connect@PLT
	movl	%eax, -292(%rbp)
	movl	-292(%rbp), %eax
	movl	$1, %edx
	leaq	.LC2(%rip), %rcx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	write@PLT
	movl	-292(%rbp), %eax
	movl	%eax, %edi
	call	close@PLT
	movl	$0, %edi
	call	exit@PLT
.L5:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -300(%rbp)
	jmp	.L2
.L4:
	movq	-280(%rbp), %rdx
	movq	-320(%rbp), %rcx
	movl	-308(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	lmbench_usage@PLT
	nop
.L2:
	movq	-320(%rbp), %rcx
	movl	-308(%rbp), %eax
	leaq	.LC3(%rip), %rdx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	mygetopt@PLT
	movl	%eax, -296(%rbp)
	cmpl	$-1, -296(%rbp)
	jne	.L8
	movl	myoptind(%rip), %eax
	addl	$1, %eax
	cmpl	%eax, -308(%rbp)
	je	.L9
	movq	-280(%rbp), %rdx
	movq	-320(%rbp), %rcx
	movl	-308(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	lmbench_usage@PLT
.L9:
	movl	myoptind(%rip), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-320(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	%rax, -288(%rbp)
	leaq	-288(%rbp), %rax
	pushq	%rax
	movl	-300(%rbp), %eax
	pushq	%rax
	movl	$0, %r9d
	movl	$1, %r8d
	movl	$0, %ecx
	movl	$0, %edx
	leaq	doclient(%rip), %rax
	movq	%rax, %rsi
	movl	$0, %edi
	call	benchmp@PLT
	addq	$16, %rsp
	movq	-288(%rbp), %rdx
	leaq	-272(%rbp), %rax
	leaq	.LC4(%rip), %rcx
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
	.globl	doclient
	.type	doclient, @function
doclient:
.LFB9:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r12
	pushq	%rbx
	subq	$32, %rsp
	.cfi_offset 12, -24
	.cfi_offset 3, -32
	movq	%rdi, -40(%rbp)
	movq	%rsi, -48(%rbp)
	movq	-48(%rbp), %rax
	movq	%rax, -24(%rbp)
	movq	-24(%rbp), %rax
	movq	(%rax), %r12
	jmp	.L12
.L13:
	movl	$8, %edx
	movl	$-31237, %esi
	movq	%r12, %rdi
	call	tcp_connect@PLT
	movl	%eax, %ebx
	movl	%ebx, %edi
	call	close@PLT
.L12:
	movq	-40(%rbp), %rax
	leaq	-1(%rax), %rdx
	movq	%rdx, -40(%rbp)
	testq	%rax, %rax
	jne	.L13
	nop
	nop
	addq	$32, %rsp
	popq	%rbx
	popq	%r12
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE9:
	.size	doclient, .-doclient
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
	movb	$49, -17(%rbp)
	movq	exit@GOTPCREL(%rip), %rax
	movq	%rax, %rsi
	movl	$14, %edi
	call	signal@PLT
	movl	$3600, %edi
	call	alarm@PLT
	movl	$8, %esi
	movl	$-31237, %edi
	call	tcp_server@PLT
	movl	%eax, -16(%rbp)
.L16:
	movl	-16(%rbp), %eax
	movl	$0, %esi
	movl	%eax, %edi
	call	tcp_accept@PLT
	movl	%eax, -12(%rbp)
	leaq	-17(%rbp), %rcx
	movl	-12(%rbp), %eax
	movl	$1, %edx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	read@PLT
	testq	%rax, %rax
	jle	.L15
	movl	$-31237, %edi
	call	tcp_done@PLT
	movl	$0, %edi
	call	exit@PLT
.L15:
	movl	-12(%rbp), %eax
	movl	%eax, %edi
	call	close@PLT
	jmp	.L16
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
