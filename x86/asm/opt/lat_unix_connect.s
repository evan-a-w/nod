	.file	"lat_unix_connect.c"
	.text
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"/tmp/af_unix"
.LC1:
	.string	"error on iteration %lu\n"
	.text
	.globl	benchmark
	.type	benchmark, @function
benchmark:
.LFB72:
	.cfi_startproc
	endbr64
	testq	%rdi, %rdi
	je	.L7
	pushq	%r13
	.cfi_def_cfa_offset 16
	.cfi_offset 13, -16
	pushq	%r12
	.cfi_def_cfa_offset 24
	.cfi_offset 12, -24
	pushq	%rbp
	.cfi_def_cfa_offset 32
	.cfi_offset 6, -32
	pushq	%rbx
	.cfi_def_cfa_offset 40
	.cfi_offset 3, -40
	subq	$8, %rsp
	.cfi_def_cfa_offset 48
	leaq	-1(%rdi), %rbp
	leaq	.LC0(%rip), %r12
	leaq	.LC1(%rip), %r13
	jmp	.L4
.L3:
	movl	%ebx, %edi
	call	close@PLT
	subq	$1, %rbp
	cmpq	$-1, %rbp
	je	.L10
.L4:
	movq	%r12, %rdi
	call	unix_connect@PLT
	movl	%eax, %ebx
	testl	%eax, %eax
	jg	.L3
	movq	%rbp, %rdx
	movq	%r13, %rsi
	movl	$1, %edi
	movl	$0, %eax
	call	__printf_chk@PLT
	jmp	.L3
.L10:
	addq	$8, %rsp
	.cfi_def_cfa_offset 40
	popq	%rbx
	.cfi_def_cfa_offset 32
	popq	%rbp
	.cfi_def_cfa_offset 24
	popq	%r12
	.cfi_def_cfa_offset 16
	popq	%r13
	.cfi_def_cfa_offset 8
	ret
.L7:
	.cfi_restore 3
	.cfi_restore 6
	.cfi_restore 12
	.cfi_restore 13
	ret
	.cfi_endproc
.LFE72:
	.size	benchmark, .-benchmark
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
	movq	exit@GOTPCREL(%rip), %rsi
	movl	$14, %edi
	call	signal@PLT
	movl	$3600, %edi
	call	alarm@PLT
	leaq	.LC0(%rip), %rdi
	call	unix_server@PLT
	movl	%eax, %ebp
	leaq	7(%rsp), %r12
	jmp	.L13
.L12:
	movl	%ebx, %edi
	call	close@PLT
.L13:
	movl	%ebp, %edi
	call	unix_accept@PLT
	movl	%eax, %ebx
	movb	$0, 7(%rsp)
	movl	$1, %edx
	movq	%r12, %rsi
	movl	%eax, %edi
	call	read@PLT
	cmpb	$48, 7(%rsp)
	jne	.L12
	leaq	.LC0(%rip), %rsi
	movl	%ebp, %edi
	call	unix_done@PLT
	movl	$0, %edi
	call	exit@PLT
	.cfi_endproc
.LFE74:
	.size	server_main, .-server_main
	.section	.rodata.str1.1
.LC2:
	.string	"-s"
.LC3:
	.string	"-S"
.LC4:
	.string	"0"
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC5:
	.string	"-s\n OR [-P <parallelism>] [-W <warmup>] [-N <repetitions>]\n OR -S\n"
	.section	.rodata.str1.1
.LC6:
	.string	"P:W:N:"
.LC7:
	.string	"UNIX connection cost"
	.text
	.globl	main
	.type	main, @function
main:
.LFB73:
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
	subq	$24, %rsp
	.cfi_def_cfa_offset 80
	movl	%edi, %ebx
	movq	%rsi, %rbp
	cmpl	$2, %edi
	je	.L32
	movl	$-1, %r14d
	movl	$0, %r13d
	movl	$1, 12(%rsp)
.L17:
	leaq	.LC6(%rip), %r12
	leaq	.LC5(%rip), %r15
	jmp	.L29
.L32:
	movq	8(%rsi), %r12
	leaq	.LC2(%rip), %rsi
	movq	%r12, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	je	.L33
	leaq	.LC3(%rip), %rsi
	movq	%r12, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	je	.L34
	movl	$-1, %r14d
	movl	$0, %r13d
	movl	$1, 12(%rsp)
	jmp	.L17
.L33:
	call	fork@PLT
	testl	%eax, %eax
	je	.L35
	movl	$0, %edi
	call	exit@PLT
.L35:
	call	server_main
.L34:
	leaq	.LC0(%rip), %rdi
	call	unix_connect@PLT
	movl	%eax, %ebx
	movl	$1, %edx
	leaq	.LC4(%rip), %rsi
	movl	%eax, %edi
	call	write@PLT
	movl	%ebx, %edi
	call	close@PLT
	movl	$0, %edi
	call	exit@PLT
.L20:
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	movl	%eax, 12(%rsp)
	testl	%eax, %eax
	jg	.L29
	movq	%r15, %rdx
	movq	%rbp, %rsi
	movl	%ebx, %edi
	call	lmbench_usage@PLT
	jmp	.L29
.L21:
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	movl	%eax, %r13d
.L29:
	movq	%r12, %rdx
	movq	%rbp, %rsi
	movl	%ebx, %edi
	call	mygetopt@PLT
	cmpl	$-1, %eax
	je	.L36
	cmpl	$80, %eax
	je	.L20
	cmpl	$87, %eax
	je	.L21
	cmpl	$78, %eax
	je	.L37
	movq	%r15, %rdx
	movq	%rbp, %rsi
	movl	%ebx, %edi
	call	lmbench_usage@PLT
	jmp	.L29
.L37:
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	movl	%eax, %r14d
	jmp	.L29
.L36:
	cmpl	%ebx, myoptind(%rip)
	jne	.L38
.L26:
	pushq	$0
	.cfi_def_cfa_offset 88
	pushq	%r14
	.cfi_def_cfa_offset 96
	movl	%r13d, %r9d
	movl	28(%rsp), %r8d
	movl	$0, %ecx
	movl	$0, %edx
	leaq	benchmark(%rip), %rsi
	movl	$0, %edi
	call	benchmp@PLT
	call	get_n@PLT
	movq	%rax, %rsi
	leaq	.LC7(%rip), %rdi
	call	micro@PLT
	movl	$0, %eax
	addq	$40, %rsp
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
.L38:
	.cfi_def_cfa_offset 80
	leaq	.LC5(%rip), %rdx
	movq	%rbp, %rsi
	movl	%ebx, %edi
	call	lmbench_usage@PLT
	jmp	.L26
	.cfi_endproc
.LFE73:
	.size	main, .-main
	.globl	id
	.section	.rodata.str1.1
.LC8:
	.string	"$Id$\n"
	.section	.data.rel.local,"aw"
	.align 8
	.type	id, @object
	.size	id, 8
id:
	.quad	.LC8
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
