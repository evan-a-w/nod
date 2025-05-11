	.file	"bw_pipe.c"
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
	movl	32(%rsi), %edi
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
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC0:
	.string	"bw_pipe: reader: error in read"
	.text
	.globl	reader
	.type	reader, @function
reader:
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
	movq	%rsi, %rbx
	leaq	-1(%rdi), %r12
	testq	%rdi, %rdi
	jne	.L11
.L10:
	popq	%rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	ret
.L21:
	.cfi_restore_state
	leaq	.LC0(%rip), %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L15:
	subq	$1, %r12
	cmpq	$-1, %r12
	je	.L10
.L11:
	movl	$0, %ebp
	cmpq	$0, 16(%rbx)
	je	.L15
.L14:
	movq	8(%rbx), %rdx
	movq	24(%rbx), %rsi
	movl	32(%rbx), %edi
	call	read@PLT
	testq	%rax, %rax
	js	.L21
	addq	%rax, %rbp
	cmpq	%rbp, 16(%rbx)
	ja	.L14
	jmp	.L15
	.cfi_endproc
.LFE74:
	.size	reader, .-reader
	.globl	writer
	.type	writer, @function
writer:
.LFB75:
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
	subq	$8, %rsp
	.cfi_def_cfa_offset 48
	movl	%edi, %r13d
	movq	%rsi, %r12
	movq	%rdx, %rbp
.L26:
	testq	%rbp, %rbp
	je	.L26
	movl	$0, %ebx
.L25:
	movq	%rbp, %rdx
	subq	%rbx, %rdx
	movq	%r12, %rsi
	movl	%r13d, %edi
	call	write@PLT
	testq	%rax, %rax
	js	.L29
	addq	%rax, %rbx
	cmpq	%rbx, %rbp
	ja	.L25
	jmp	.L26
.L29:
	movl	$0, %edi
	call	exit@PLT
	.cfi_endproc
.LFE75:
	.size	writer, .-writer
	.section	.rodata.str1.1,"aMS",@progbits,1
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
.LFB72:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushq	%rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	subq	$24, %rsp
	.cfi_def_cfa_offset 48
	movq	%fs:40, %rax
	movq	%rax, 8(%rsp)
	xorl	%eax, %eax
	testq	%rdi, %rdi
	je	.L39
.L30:
	movq	8(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L40
	addq	$24, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
.L39:
	.cfi_restore_state
	movq	%rsi, %rbx
	movq	%rsp, %rdi
	call	pipe@PLT
	cmpl	$-1, %eax
	je	.L41
	movl	$0, %eax
	call	benchmp_childid@PLT
	movl	%eax, %edi
	movl	$1, %edx
	movl	$0, %esi
	call	handle_scheduler@PLT
	call	fork@PLT
	movl	%eax, (%rbx)
	cmpl	$-1, %eax
	je	.L33
	testl	%eax, %eax
	jne	.L34
	movl	(%rsp), %edi
	call	close@PLT
	movl	$0, %eax
	call	benchmp_childid@PLT
	movl	%eax, %edi
	movl	$1, %edx
	movl	$1, %esi
	call	handle_scheduler@PLT
	movq	8(%rbx), %rdi
	call	valloc@PLT
	movq	%rax, %rdi
	movq	%rax, 24(%rbx)
	testq	%rax, %rax
	je	.L42
	movq	8(%rbx), %rsi
	call	touch@PLT
	movq	8(%rbx), %rdx
	movq	24(%rbx), %rsi
	movl	4(%rsp), %edi
	call	writer
.L41:
	leaq	.LC1(%rip), %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L42:
	leaq	.LC2(%rip), %rdi
	call	perror@PLT
	movl	$2, %edi
	call	exit@PLT
.L33:
	leaq	.LC3(%rip), %rdi
	call	perror@PLT
	movl	$3, %edi
	call	exit@PLT
.L34:
	movl	4(%rsp), %edi
	call	close@PLT
	movl	(%rsp), %eax
	movl	%eax, 32(%rbx)
	call	getpagesize@PLT
	movslq	%eax, %rbp
	movq	%rbp, %rdi
	addq	8(%rbx), %rdi
	call	valloc@PLT
	movq	%rax, %rdi
	movq	%rax, 24(%rbx)
	testq	%rax, %rax
	je	.L43
	movq	%rbp, %rsi
	addq	8(%rbx), %rsi
	call	touch@PLT
	subq	$-128, 24(%rbx)
	jmp	.L30
.L43:
	leaq	.LC4(%rip), %rdi
	call	perror@PLT
	movl	$4, %edi
	call	exit@PLT
.L40:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE72:
	.size	initialize, .-initialize
	.section	.rodata.str1.8
	.align 8
.LC5:
	.string	"[-m <message size>] [-M <total bytes>] [-P <parallelism>] [-W <warmup>] [-N <repetitions>]\n"
	.section	.rodata.str1.1
.LC6:
	.string	"m:M:P:W:N:"
.LC7:
	.string	"Pipe bandwidth: "
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
	subq	$72, %rsp
	.cfi_def_cfa_offset 128
	movl	%edi, %ebx
	movq	%rsi, %rbp
	movq	%fs:40, %rax
	movq	%rax, 56(%rsp)
	xorl	%eax, %eax
	movq	$65536, 24(%rsp)
	movslq	XFER(%rip), %rax
	movq	%rax, 32(%rsp)
	movl	$-1, %r14d
	movl	$0, 12(%rsp)
	movl	$1, 8(%rsp)
	leaq	.LC6(%rip), %r13
	leaq	.LC5(%rip), %r15
	leaq	.L48(%rip), %r12
	jmp	.L45
.L47:
	movq	myoptarg(%rip), %rdi
	call	bytes@PLT
	movq	%rax, 24(%rsp)
.L45:
	movq	%r13, %rdx
	movq	%rbp, %rsi
	movl	%ebx, %edi
	call	mygetopt@PLT
	cmpl	$-1, %eax
	je	.L61
	subl	$77, %eax
	cmpl	$32, %eax
	ja	.L46
	movl	%eax, %eax
	movslq	(%r12,%rax,4), %rax
	addq	%r12, %rax
	notrack jmp	*%rax
	.section	.rodata
	.align 4
	.align 4
.L48:
	.long	.L52-.L48
	.long	.L51-.L48
	.long	.L46-.L48
	.long	.L50-.L48
	.long	.L46-.L48
	.long	.L46-.L48
	.long	.L46-.L48
	.long	.L46-.L48
	.long	.L46-.L48
	.long	.L46-.L48
	.long	.L49-.L48
	.long	.L46-.L48
	.long	.L46-.L48
	.long	.L46-.L48
	.long	.L46-.L48
	.long	.L46-.L48
	.long	.L46-.L48
	.long	.L46-.L48
	.long	.L46-.L48
	.long	.L46-.L48
	.long	.L46-.L48
	.long	.L46-.L48
	.long	.L46-.L48
	.long	.L46-.L48
	.long	.L46-.L48
	.long	.L46-.L48
	.long	.L46-.L48
	.long	.L46-.L48
	.long	.L46-.L48
	.long	.L46-.L48
	.long	.L46-.L48
	.long	.L46-.L48
	.long	.L47-.L48
	.text
.L52:
	movq	myoptarg(%rip), %rdi
	call	bytes@PLT
	movq	%rax, 32(%rsp)
	jmp	.L45
.L50:
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	movl	%eax, 8(%rsp)
	testl	%eax, %eax
	jg	.L45
	movq	%r15, %rdx
	movq	%rbp, %rsi
	movl	%ebx, %edi
	call	lmbench_usage@PLT
	jmp	.L45
.L49:
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	movl	%eax, 12(%rsp)
	jmp	.L45
.L51:
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	movl	%eax, %r14d
	jmp	.L45
.L46:
	movq	%r15, %rdx
	movq	%rbp, %rsi
	movl	%ebx, %edi
	call	lmbench_usage@PLT
	jmp	.L45
.L61:
	cmpl	%ebx, myoptind(%rip)
	jl	.L62
.L55:
	movq	32(%rsp), %rcx
	movq	24(%rsp), %rsi
	cmpq	%rsi, %rcx
	jnb	.L56
	movq	%rsi, 32(%rsp)
.L57:
	leaq	16(%rsp), %rax
	pushq	%rax
	.cfi_def_cfa_offset 136
	pushq	%r14
	.cfi_def_cfa_offset 144
	movl	28(%rsp), %r9d
	movl	24(%rsp), %r8d
	movl	$2000000, %ecx
	leaq	cleanup(%rip), %rdx
	leaq	reader(%rip), %rsi
	leaq	initialize(%rip), %rdi
	call	benchmp@PLT
	call	usecs_spent@PLT
	addq	$16, %rsp
	.cfi_def_cfa_offset 128
	testq	%rax, %rax
	jne	.L63
.L58:
	movq	56(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L64
	movl	$0, %eax
	addq	$72, %rsp
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
.L62:
	.cfi_restore_state
	leaq	.LC5(%rip), %rdx
	movq	%rbp, %rsi
	movl	%ebx, %edi
	call	lmbench_usage@PLT
	jmp	.L55
.L56:
	movq	%rcx, %rax
	movl	$0, %edx
	divq	%rsi
	testq	%rdx, %rdx
	je	.L57
	addq	%rcx, %rcx
	subq	%rdx, %rcx
	movq	%rcx, 32(%rsp)
	jmp	.L57
.L63:
	movq	stderr(%rip), %rcx
	movl	$16, %edx
	movl	$1, %esi
	leaq	.LC7(%rip), %rdi
	call	fwrite@PLT
	call	get_n@PLT
	movslq	8(%rsp), %rdi
	imulq	32(%rsp), %rdi
	imulq	%rax, %rdi
	call	mb@PLT
	jmp	.L58
.L64:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE76:
	.size	main, .-main
	.globl	XFER
	.data
	.align 4
	.type	XFER, @object
	.size	XFER, 4
XFER:
	.long	10485760
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
