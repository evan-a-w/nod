	.file	"bw_unix.c"
	.text
	.globl	cleanup
	.type	cleanup, @function
cleanup:
.LFB73:
	.cfi_startproc
	endbr64
	testq	%rdi, %rdi
	je	.L8
	ret
.L8:
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movq	%rsi, %rbx
	movl	44(%rsi), %edi
	call	close@PLT
	movl	32(%rbx), %edi
	call	close@PLT
	movl	(%rbx), %edi
	testl	%edi, %edi
	jg	.L9
.L3:
	movl	$0, (%rbx)
	popq	%rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	ret
.L9:
	.cfi_restore_state
	movl	$9, %esi
	call	kill@PLT
	movl	$0, %edx
	movl	$0, %esi
	movl	(%rbx), %edi
	call	waitpid@PLT
	jmp	.L3
	.cfi_endproc
.LFE73:
	.size	cleanup, .-cleanup
	.globl	reader
	.type	reader, @function
reader:
.LFB74:
	.cfi_startproc
	endbr64
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
	subq	$24, %rsp
	.cfi_def_cfa_offset 64
	movq	%fs:40, %rax
	movq	%rax, 8(%rsp)
	xorl	%eax, %eax
	movq	16(%rsi), %rax
	movq	%rax, (%rsp)
	testq	%rdi, %rdi
	je	.L10
	movq	%rsi, %rbx
	leaq	-1(%rdi), %r12
	movq	%rsp, %r13
	jmp	.L15
.L20:
	movl	$1, %edi
	call	exit@PLT
.L12:
	subq	$1, %r12
	cmpq	$-1, %r12
	je	.L10
.L15:
	movl	44(%rbx), %edi
	movl	$8, %edx
	movq	%r13, %rsi
	call	write@PLT
	cmpq	$0, (%rsp)
	je	.L12
	movl	$0, %ebp
.L14:
	movq	8(%rbx), %rdx
	movq	24(%rbx), %rsi
	movl	32(%rbx), %edi
	call	read@PLT
	testq	%rax, %rax
	je	.L20
	addq	%rax, %rbp
	cmpq	%rbp, (%rsp)
	ja	.L14
	jmp	.L12
.L10:
	movq	8(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L21
	addq	$24, %rsp
	.cfi_remember_state
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
.L21:
	.cfi_restore_state
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE74:
	.size	reader, .-reader
	.globl	writer
	.type	writer, @function
writer:
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
	subq	$24, %rsp
	.cfi_def_cfa_offset 80
	movl	%edi, %r14d
	movl	%esi, %r13d
	movq	%rdx, %r12
	movq	%rcx, %rbp
	movq	%fs:40, %rax
	movq	%rax, 8(%rsp)
	xorl	%eax, %eax
	movq	%rsp, %r15
.L26:
	movl	$8, %edx
	movq	%r15, %rsi
	movl	%r14d, %edi
	call	read@PLT
	cmpq	$0, (%rsp)
	je	.L26
	movl	$0, %ebx
.L25:
	movq	8(%rbp), %rdx
	movq	%r12, %rsi
	movl	%r13d, %edi
	call	write@PLT
	testq	%rax, %rax
	js	.L30
	addq	%rax, %rbx
	cmpq	%rbx, (%rsp)
	ja	.L25
	jmp	.L26
.L30:
	movl	$1, %edi
	call	exit@PLT
	.cfi_endproc
.LFE75:
	.size	writer, .-writer
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"socketpair"
.LC1:
	.string	"pipe"
.LC2:
	.string	"fork"
	.text
	.globl	initialize
	.type	initialize, @function
initialize:
.LFB72:
	.cfi_startproc
	endbr64
	testq	%rdi, %rdi
	je	.L41
	ret
.L41:
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movq	%rsi, %rbx
	movl	$65536, %edi
	call	valloc@PLT
	movq	%rax, %rdi
	movq	%rax, 24(%rbx)
	movl	$65536, %esi
	call	touch@PLT
	movl	$0, 48(%rbx)
	leaq	32(%rbx), %rcx
	movl	$0, %edx
	movl	$1, %esi
	movl	$1, %edi
	call	socketpair@PLT
	cmpl	$-1, %eax
	je	.L42
	leaq	40(%rbx), %rdi
	call	pipe@PLT
	cmpl	$-1, %eax
	je	.L43
	movl	$0, %eax
	call	benchmp_childid@PLT
	movl	%eax, %edi
	movl	$1, %edx
	movl	$0, %esi
	call	handle_scheduler@PLT
	call	fork@PLT
	movl	%eax, (%rbx)
	cmpl	$-1, %eax
	je	.L35
	testl	%eax, %eax
	je	.L44
	movl	40(%rbx), %edi
	call	close@PLT
	movl	36(%rbx), %edi
	call	close@PLT
	jmp	.L31
.L42:
	leaq	.LC0(%rip), %rdi
	call	perror@PLT
	movl	$1, 48(%rbx)
	jmp	.L31
.L43:
	leaq	.LC1(%rip), %rdi
	call	perror@PLT
	movl	$2, 48(%rbx)
	jmp	.L31
.L44:
	call	benchmp_childid@PLT
	movl	%eax, %edi
	movl	$1, %edx
	movl	$1, %esi
	call	handle_scheduler@PLT
	movl	44(%rbx), %edi
	call	close@PLT
	movl	32(%rbx), %edi
	call	close@PLT
	movq	24(%rbx), %rdx
	movl	36(%rbx), %esi
	movl	40(%rbx), %edi
	movq	%rbx, %rcx
	call	writer
.L35:
	leaq	.LC2(%rip), %rdi
	call	perror@PLT
	movl	$3, 48(%rbx)
.L31:
	popq	%rbx
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE72:
	.size	initialize, .-initialize
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC3:
	.string	"[-m <message size>] [-M <total bytes>] [-P <parallelism>] [-W <warmup>] [-N <repetitions>]\n"
	.section	.rodata.str1.1
.LC4:
	.string	"m:M:P:W:N:"
	.section	.rodata.str1.8
	.align 8
.LC5:
	.string	"AF_UNIX sock stream bandwidth: "
	.text
	.globl	main
	.type	main, @function
main:
.LFB76:
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
	subq	$88, %rsp
	.cfi_def_cfa_offset 144
	movl	%edi, %ebx
	movq	%rsi, %rbp
	movq	%fs:40, %rax
	movq	%rax, 72(%rsp)
	xorl	%eax, %eax
	movq	$65536, 24(%rsp)
	movq	XFER(%rip), %rax
	movq	%rax, 32(%rsp)
	movl	$-1, %r14d
	movl	$0, 12(%rsp)
	movl	$1, 8(%rsp)
	leaq	.LC4(%rip), %r13
	leaq	.LC3(%rip), %r15
	leaq	.L49(%rip), %r12
	jmp	.L46
.L48:
	movq	myoptarg(%rip), %rdi
	call	bytes@PLT
	movq	%rax, 24(%rsp)
.L46:
	movq	%r13, %rdx
	movq	%rbp, %rsi
	movl	%ebx, %edi
	call	mygetopt@PLT
	cmpl	$-1, %eax
	je	.L62
	subl	$77, %eax
	cmpl	$32, %eax
	ja	.L47
	movl	%eax, %eax
	movslq	(%r12,%rax,4), %rax
	addq	%r12, %rax
	notrack jmp	*%rax
	.section	.rodata
	.align 4
	.align 4
.L49:
	.long	.L53-.L49
	.long	.L52-.L49
	.long	.L47-.L49
	.long	.L51-.L49
	.long	.L47-.L49
	.long	.L47-.L49
	.long	.L47-.L49
	.long	.L47-.L49
	.long	.L47-.L49
	.long	.L47-.L49
	.long	.L50-.L49
	.long	.L47-.L49
	.long	.L47-.L49
	.long	.L47-.L49
	.long	.L47-.L49
	.long	.L47-.L49
	.long	.L47-.L49
	.long	.L47-.L49
	.long	.L47-.L49
	.long	.L47-.L49
	.long	.L47-.L49
	.long	.L47-.L49
	.long	.L47-.L49
	.long	.L47-.L49
	.long	.L47-.L49
	.long	.L47-.L49
	.long	.L47-.L49
	.long	.L47-.L49
	.long	.L47-.L49
	.long	.L47-.L49
	.long	.L47-.L49
	.long	.L47-.L49
	.long	.L48-.L49
	.text
.L53:
	movq	myoptarg(%rip), %rdi
	call	bytes@PLT
	movq	%rax, 32(%rsp)
	jmp	.L46
.L51:
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	movl	%eax, 8(%rsp)
	testl	%eax, %eax
	jg	.L46
	movq	%r15, %rdx
	movq	%rbp, %rsi
	movl	%ebx, %edi
	call	lmbench_usage@PLT
	jmp	.L46
.L50:
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	movl	%eax, 12(%rsp)
	jmp	.L46
.L52:
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	movl	%eax, %r14d
	jmp	.L46
.L47:
	movq	%r15, %rdx
	movq	%rbp, %rsi
	movl	%ebx, %edi
	call	lmbench_usage@PLT
	jmp	.L46
.L62:
	leal	-1(%rbx), %edx
	movl	myoptind(%rip), %eax
	cmpl	%eax, %edx
	je	.L63
	jg	.L64
.L57:
	movl	$0, 16(%rsp)
	movq	32(%rsp), %rcx
	movq	%rcx, %rax
	movl	$0, %edx
	divq	24(%rsp)
	testq	%rdx, %rdx
	je	.L58
	addq	%rcx, %rcx
	subq	%rdx, %rcx
	movq	%rcx, 32(%rsp)
.L58:
	leaq	16(%rsp), %rax
	pushq	%rax
	.cfi_def_cfa_offset 152
	pushq	%r14
	.cfi_def_cfa_offset 160
	movl	28(%rsp), %r9d
	movl	24(%rsp), %r8d
	movl	$2000000, %ecx
	leaq	cleanup(%rip), %rdx
	leaq	reader(%rip), %rsi
	leaq	initialize(%rip), %rdi
	call	benchmp@PLT
	call	usecs_spent@PLT
	addq	$16, %rsp
	.cfi_def_cfa_offset 144
	testq	%rax, %rax
	jne	.L65
.L59:
	movq	72(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L66
	movl	$0, %eax
	addq	$88, %rsp
	.cfi_remember_state
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
.L63:
	.cfi_restore_state
	cltq
	movq	0(%rbp,%rax,8), %rdi
	call	bytes@PLT
	movq	%rax, 32(%rsp)
	jmp	.L57
.L64:
	leaq	.LC3(%rip), %rdx
	movq	%rbp, %rsi
	movl	%ebx, %edi
	call	lmbench_usage@PLT
	jmp	.L57
.L65:
	movq	stderr(%rip), %rcx
	movl	$31, %edx
	movl	$1, %esi
	leaq	.LC5(%rip), %rdi
	call	fwrite@PLT
	call	get_n@PLT
	movslq	8(%rsp), %rdi
	imulq	XFER(%rip), %rdi
	imulq	%rax, %rdi
	call	mb@PLT
	jmp	.L59
.L66:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE76:
	.size	main, .-main
	.globl	XFER
	.data
	.align 8
	.type	XFER, @object
	.size	XFER, 8
XFER:
	.quad	10485760
	.globl	id
	.section	.rodata.str1.1
.LC6:
	.string	"$Id$\n"
	.section	.data.rel.local,"aw"
	.align 8
	.type	id, @object
	.size	id, 8
id:
	.quad	.LC6
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
