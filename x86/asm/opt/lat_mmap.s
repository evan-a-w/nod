	.file	"lat_mmap.c"
	.text
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"%d"
.LC1:
	.string	"malloc"
.LC2:
	.string	"%s%d"
.LC3:
	.string	"Could not copy file"
.LC4:
	.string	"x"
.LC5:
	.string	"Input file too small\n"
	.text
	.globl	init
	.type	init, @function
init:
.LFB73:
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
	subq	$144, %rsp
	.cfi_def_cfa_offset 176
	movq	%fs:40, %rax
	movq	%rax, 136(%rsp)
	xorl	%eax, %eax
	testq	%rdi, %rdi
	jne	.L1
	movq	%rsi, %rbx
	cmpl	$0, 16(%rsi)
	je	.L3
	call	getpid@PLT
	movl	%eax, %r8d
	movq	%rsp, %r12
	leaq	.LC0(%rip), %rcx
	movl	$128, %edx
	movl	$1, %esi
	movq	%r12, %rdi
	movl	$0, %eax
	call	__sprintf_chk@PLT
	movq	24(%rbx), %rdi
	call	strlen@PLT
	movq	%rax, %rbp
	movq	%r12, %rdi
	call	strlen@PLT
	leaq	1(%rbp,%rax), %rdi
	call	malloc@PLT
	movq	%rax, %rbp
	testq	%rax, %rax
	je	.L10
	call	getpid@PLT
	movl	%eax, %r9d
	movq	24(%rbx), %r8
	leaq	.LC2(%rip), %rcx
	movq	$-1, %rdx
	movl	$1, %esi
	movq	%rbp, %rdi
	movl	$0, %eax
	call	__sprintf_chk@PLT
	movq	24(%rbx), %rdi
	movl	$384, %edx
	movq	%rbp, %rsi
	call	cp@PLT
	testl	%eax, %eax
	js	.L11
	movq	%rbp, 24(%rbx)
.L3:
	movq	24(%rbx), %rdi
	movl	$2, %esi
	movl	$0, %eax
	call	open@PLT
	movl	%eax, 8(%rbx)
	cmpl	$-1, %eax
	je	.L12
	cmpl	$0, 16(%rbx)
	jne	.L13
.L7:
	movl	8(%rbx), %edi
	movl	$2, %edx
	movl	$0, %esi
	call	seekto@PLT
	cmpq	(%rbx), %rax
	jb	.L14
.L1:
	movq	136(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L15
	addq	$144, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 32
	popq	%rbx
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	ret
.L10:
	.cfi_restore_state
	leaq	.LC1(%rip), %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L11:
	leaq	.LC3(%rip), %rdi
	call	perror@PLT
	movq	%rbp, %rdi
	call	unlink@PLT
	movl	$1, %edi
	call	exit@PLT
.L12:
	leaq	.LC4(%rip), %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L13:
	movq	24(%rbx), %rdi
	call	unlink@PLT
	jmp	.L7
.L14:
	movq	stderr(%rip), %rcx
	movl	$21, %edx
	movl	$1, %esi
	leaq	.LC5(%rip), %rdi
	call	fwrite@PLT
	movl	$1, %edi
	call	exit@PLT
.L15:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE73:
	.size	init, .-init
	.globl	cleanup
	.type	cleanup, @function
cleanup:
.LFB74:
	.cfi_startproc
	endbr64
	testq	%rdi, %rdi
	je	.L22
	ret
.L22:
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	movl	8(%rsi), %edi
	call	close@PLT
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE74:
	.size	cleanup, .-cleanup
	.section	.rodata.str1.1
.LC6:
	.string	"mmap"
	.text
	.globl	domapping
	.type	domapping, @function
domapping:
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
	subq	$8, %rsp
	.cfi_def_cfa_offset 64
	movl	8(%rsi), %r13d
	movq	(%rsi), %r12
	movl	12(%rsi), %r14d
	testq	%rdi, %rdi
	je	.L23
	movl	%r12d, %ebx
	leaq	-1(%rdi), %rbp
	movabsq	$-3689348814741910323, %rdx
	movq	%r12, %rax
	mulq	%rdx
	shrq	$3, %rdx
	movq	%rdx, %r15
	jmp	.L30
.L35:
	leaq	.LC6(%rip), %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L26:
	leaq	(%rax,%r15), %rax
	cmpq	%rax, %rdi
	jnb	.L27
	movq	%rdi, %rdx
.L29:
	movb	%bl, (%rdx)
	addq	$16384, %rdx
	cmpq	%rdx, %rax
	ja	.L29
.L27:
	movq	%r12, %rsi
	call	munmap@PLT
	subq	$1, %rbp
	cmpq	$-1, %rbp
	je	.L23
.L30:
	movl	$0, %r9d
	movl	%r13d, %r8d
	movl	$1, %ecx
	movl	$3, %edx
	movq	%r12, %rsi
	movl	$0, %edi
	call	mmap@PLT
	movq	%rax, %rdi
	cmpq	$-1, %rax
	je	.L35
	testl	%r14d, %r14d
	je	.L26
	leaq	(%rax,%r12), %rax
	cmpq	%rax, %rdi
	jnb	.L27
	movq	%rdi, %rdx
.L28:
	movb	%bl, (%rdx)
	addq	$163840, %rdx
	cmpq	%rdx, %rax
	ja	.L28
	jmp	.L27
.L23:
	addq	$8, %rsp
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
	.cfi_endproc
.LFE75:
	.size	domapping, .-domapping
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC7:
	.string	"[-r] [-C] [-P <parallelism>] [-W <warmup>] [-N <repetitions>] size file\n"
	.section	.rodata.str1.1
.LC8:
	.string	"rP:W:N:C"
	.text
	.globl	main
	.type	main, @function
main:
.LFB72:
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
	movl	%edi, %ebp
	movq	%rsi, %rbx
	movq	%fs:40, %rax
	movq	%rax, 56(%rsp)
	xorl	%eax, %eax
	movl	$0, 28(%rsp)
	movl	$0, 32(%rsp)
	movl	$-1, %r14d
	movl	$0, %r13d
	movl	$1, 12(%rsp)
	leaq	.LC8(%rip), %r12
	leaq	.LC7(%rip), %r15
	jmp	.L37
.L54:
	cmpl	$67, %eax
	je	.L40
	cmpl	$78, %eax
	jne	.L42
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	movl	%eax, %r14d
	jmp	.L37
.L38:
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	movl	%eax, 12(%rsp)
	testl	%eax, %eax
	jg	.L37
	movq	%r15, %rdx
	movq	%rbx, %rsi
	movl	%ebp, %edi
	call	lmbench_usage@PLT
	jmp	.L37
.L43:
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	movl	%eax, %r13d
.L37:
	movq	%r12, %rdx
	movq	%rbx, %rsi
	movl	%ebp, %edi
	call	mygetopt@PLT
	cmpl	$-1, %eax
	je	.L53
	cmpl	$80, %eax
	je	.L38
	jle	.L54
	cmpl	$87, %eax
	je	.L43
	cmpl	$114, %eax
	jne	.L42
	movl	$1, 28(%rsp)
	jmp	.L37
.L40:
	movl	$1, 32(%rsp)
	jmp	.L37
.L42:
	movq	%r15, %rdx
	movq	%rbx, %rsi
	movl	%ebp, %edi
	call	lmbench_usage@PLT
	jmp	.L37
.L53:
	movl	myoptind(%rip), %eax
	addl	$2, %eax
	cmpl	%ebp, %eax
	jne	.L55
.L47:
	movslq	myoptind(%rip), %rax
	movq	(%rbx,%rax,8), %rdi
	call	bytes@PLT
	movq	%rax, 16(%rsp)
	movl	$1, %edx
	cmpq	$327679, %rax
	ja	.L56
.L36:
	movq	56(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L57
	movl	%edx, %eax
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
.L55:
	.cfi_restore_state
	leaq	.LC7(%rip), %rdx
	movq	%rbx, %rsi
	movl	%ebp, %edi
	call	lmbench_usage@PLT
	jmp	.L47
.L56:
	movslq	myoptind(%rip), %rax
	movq	8(%rbx,%rax,8), %rax
	movq	%rax, 40(%rsp)
	leaq	16(%rsp), %rax
	pushq	%rax
	.cfi_def_cfa_offset 136
	pushq	%r14
	.cfi_def_cfa_offset 144
	movl	%r13d, %r9d
	movl	28(%rsp), %r8d
	movl	$0, %ecx
	leaq	cleanup(%rip), %rdx
	leaq	domapping(%rip), %rsi
	leaq	init(%rip), %rdi
	call	benchmp@PLT
	call	usecs_spent@PLT
	addq	$16, %rsp
	.cfi_def_cfa_offset 128
	movl	$0, %edx
	testq	%rax, %rax
	je	.L36
	call	get_n@PLT
	movq	%rax, %rsi
	movq	16(%rsp), %rdi
	call	micromb@PLT
	movl	$0, %edx
	jmp	.L36
.L57:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE72:
	.size	main, .-main
	.globl	id
	.section	.rodata.str1.1
.LC9:
	.string	"$Id$\n"
	.section	.data.rel.local,"aw"
	.align 8
	.type	id, @object
	.size	id, 8
id:
	.quad	.LC9
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
