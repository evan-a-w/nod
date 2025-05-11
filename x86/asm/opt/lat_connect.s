	.file	"lat_connect.c"
	.text
	.globl	doclient
	.type	doclient, @function
doclient:
.LFB73:
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
	movq	(%rsi), %rbp
	leaq	-1(%rdi), %rbx
	testq	%rdi, %rdi
	je	.L1
.L3:
	movl	$8, %edx
	movl	$-31237, %esi
	movq	%rbp, %rdi
	call	tcp_connect@PLT
	movl	%eax, %edi
	call	close@PLT
	subq	$1, %rbx
	cmpq	$-1, %rbx
	jne	.L3
.L1:
	addq	$8, %rsp
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE73:
	.size	doclient, .-doclient
	.globl	server_main
	.type	server_main, @function
server_main:
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
	subq	$16, %rsp
	.cfi_def_cfa_offset 48
	movq	%fs:40, %rax
	movq	%rax, 8(%rsp)
	xorl	%eax, %eax
	movb	$49, 7(%rsp)
	movq	exit@GOTPCREL(%rip), %rsi
	movl	$14, %edi
	call	signal@PLT
	movl	$3600, %edi
	call	alarm@PLT
	movl	$8, %esi
	movl	$-31237, %edi
	call	tcp_server@PLT
	movl	%eax, %ebp
	leaq	7(%rsp), %r12
	jmp	.L8
.L7:
	movl	%ebx, %edi
	call	close@PLT
.L8:
	movl	$0, %esi
	movl	%ebp, %edi
	call	tcp_accept@PLT
	movl	%eax, %ebx
	movl	$1, %edx
	movq	%r12, %rsi
	movl	%eax, %edi
	call	read@PLT
	testq	%rax, %rax
	jle	.L7
	movl	$-31237, %edi
	call	tcp_done@PLT
	movl	$0, %edi
	call	exit@PLT
	.cfi_endproc
.LFE74:
	.size	server_main, .-server_main
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"0"
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC1:
	.string	"-s\n OR [-S] [-N <repetitions>] server\n"
	.section	.rodata.str1.1
.LC2:
	.string	"sSP:W:N:"
.LC3:
	.string	"TCP/IP connection cost to %s"
	.text
	.globl	main
	.type	main, @function
main:
.LFB72:
	.cfi_startproc
	endbr64
	pushq	%r14
	.cfi_def_cfa_offset 16
	.cfi_offset 14, -16
	pushq	%r13
	.cfi_def_cfa_offset 24
	.cfi_offset 13, -24
	pushq	%r12
	.cfi_def_cfa_offset 32
	.cfi_offset 12, -32
	pushq	%rbp
	.cfi_def_cfa_offset 40
	.cfi_offset 6, -40
	pushq	%rbx
	.cfi_def_cfa_offset 48
	.cfi_offset 3, -48
	subq	$288, %rsp
	.cfi_def_cfa_offset 336
	movl	%edi, %ebp
	movq	%rsi, %rbx
	movq	%fs:40, %rax
	movq	%rax, 280(%rsp)
	xorl	%eax, %eax
	movl	$-1, %r13d
	leaq	.LC2(%rip), %r12
	leaq	.LC1(%rip), %r14
.L12:
	movq	%r12, %rdx
	movq	%rbx, %rsi
	movl	%ebp, %edi
	call	mygetopt@PLT
	cmpl	$-1, %eax
	je	.L24
	cmpl	$83, %eax
	je	.L13
	cmpl	$115, %eax
	je	.L14
	cmpl	$78, %eax
	je	.L25
	movq	%r14, %rdx
	movq	%rbx, %rsi
	movl	%ebp, %edi
	call	lmbench_usage@PLT
	jmp	.L12
.L14:
	call	fork@PLT
	testl	%eax, %eax
	jne	.L17
	call	server_main
.L17:
	movl	$0, %edi
	call	exit@PLT
.L13:
	movslq	myoptind(%rip), %rax
	movq	(%rbx,%rax,8), %rdi
	movl	$0, %edx
	movl	$-31237, %esi
	call	tcp_connect@PLT
	movl	%eax, %ebx
	movl	$1, %edx
	leaq	.LC0(%rip), %rsi
	movl	%eax, %edi
	call	write@PLT
	movl	%ebx, %edi
	call	close@PLT
	movl	$0, %edi
	call	exit@PLT
.L25:
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	movl	%eax, %r13d
	jmp	.L12
.L24:
	movl	myoptind(%rip), %eax
	addl	$1, %eax
	cmpl	%ebp, %eax
	jne	.L26
.L20:
	movslq	myoptind(%rip), %rax
	movq	(%rbx,%rax,8), %rax
	movq	%rax, 8(%rsp)
	leaq	8(%rsp), %rax
	pushq	%rax
	.cfi_remember_state
	.cfi_def_cfa_offset 344
	pushq	%r13
	.cfi_def_cfa_offset 352
	movl	$0, %r9d
	movl	$1, %r8d
	movl	$0, %ecx
	movl	$0, %edx
	leaq	doclient(%rip), %rsi
	movl	$0, %edi
	call	benchmp@PLT
	leaq	32(%rsp), %rbx
	movq	24(%rsp), %r8
	leaq	.LC3(%rip), %rcx
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
.L26:
	.cfi_restore_state
	leaq	.LC1(%rip), %rdx
	movq	%rbx, %rsi
	movl	%ebp, %edi
	call	lmbench_usage@PLT
	jmp	.L20
	.cfi_endproc
.LFE72:
	.size	main, .-main
	.globl	id
	.section	.rodata.str1.1
.LC4:
	.string	"$Id$\n"
	.section	.data.rel.local,"aw"
	.align 8
	.type	id, @object
	.size	id, 8
id:
	.quad	.LC4
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
