	.file	"bw_mmap_rd.c"
	.text
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"%d"
.LC1:
	.string	"%s%d"
.LC2:
	.string	"creating private tempfile"
	.text
	.globl	initialize
	.type	initialize, @function
initialize:
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
	subq	$4096, %rsp
	.cfi_def_cfa_offset 4128
	orq	$0, (%rsp)
	subq	$4096, %rsp
	.cfi_def_cfa_offset 8224
	orq	$0, (%rsp)
	subq	$16, %rsp
	.cfi_def_cfa_offset 8240
	movq	%fs:40, %rax
	movq	%rax, 8200(%rsp)
	xorl	%eax, %eax
	testq	%rdi, %rdi
	jne	.L1
	movq	%rsi, %rbx
	movl	$-1, 264(%rsi)
	movq	$0, 272(%rsi)
	cmpl	$0, 268(%rsi)
	jne	.L6
.L1:
	movq	8200(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L7
	addq	$8208, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 32
	popq	%rbx
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	ret
.L6:
	.cfi_restore_state
	call	getpid@PLT
	movl	%eax, %r8d
	movq	%rsp, %r12
	leaq	.LC0(%rip), %rcx
	movl	$8192, %edx
	movl	$1, %esi
	movq	%r12, %rdi
	movl	$0, %eax
	call	__sprintf_chk@PLT
	addq	$8, %rbx
	movq	%rbx, %rdi
	call	strlen@PLT
	movq	%rax, %rbp
	movq	%r12, %rdi
	call	strlen@PLT
	leaq	1(%rbp,%rax), %rdi
	call	malloc@PLT
	movq	%rax, %rbp
	call	getpid@PLT
	movl	%eax, %r9d
	movq	%rbx, %r8
	leaq	.LC1(%rip), %rcx
	movq	$-1, %rdx
	movl	$1, %esi
	movq	%rbp, %rdi
	movl	$0, %eax
	call	__sprintf_chk@PLT
	movl	$384, %edx
	movq	%rbp, %rsi
	movq	%rbx, %rdi
	call	cp@PLT
	testl	%eax, %eax
	js	.L8
	movl	$256, %edx
	movq	%rbp, %rsi
	movq	%rbx, %rdi
	call	__strcpy_chk@PLT
	jmp	.L1
.L8:
	leaq	.LC2(%rip), %rdi
	call	perror@PLT
	movq	%rbp, %rdi
	call	unlink@PLT
	movl	$1, %edi
	call	exit@PLT
.L7:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE73:
	.size	initialize, .-initialize
	.section	.rodata.str1.1
.LC3:
	.string	"x"
	.text
	.globl	init_open
	.type	init_open, @function
init_open:
.LFB74:
	.cfi_startproc
	endbr64
	testq	%rdi, %rdi
	je	.L16
	ret
.L16:
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movq	%rsi, %rbx
	call	initialize
	leaq	8(%rbx), %rdi
	movl	$0, %esi
	movl	$0, %eax
	call	open@PLT
	movl	%eax, %r8d
	movl	%eax, 264(%rbx)
	cmpl	$-1, %eax
	je	.L17
	movl	$0, %r9d
	movl	$1, %ecx
	movl	$1, %edx
	movq	(%rbx), %rsi
	movl	$0, %edi
	call	mmap@PLT
	movq	%rax, 272(%rbx)
	cmpq	$-1, %rax
	je	.L18
	popq	%rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	ret
.L17:
	.cfi_restore_state
	leaq	.LC3(%rip), %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L18:
	leaq	.LC3(%rip), %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
	.cfi_endproc
.LFE74:
	.size	init_open, .-init_open
	.globl	cleanup
	.type	cleanup, @function
cleanup:
.LFB75:
	.cfi_startproc
	endbr64
	testq	%rdi, %rdi
	jne	.L24
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movq	%rsi, %rbx
	movq	272(%rsi), %rdi
	testq	%rdi, %rdi
	je	.L21
	movq	(%rsi), %rsi
	call	munmap@PLT
.L21:
	movl	264(%rbx), %edi
	testl	%edi, %edi
	jns	.L27
.L22:
	cmpl	$0, 268(%rbx)
	jne	.L28
.L19:
	popq	%rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	ret
.L27:
	.cfi_restore_state
	call	close@PLT
	jmp	.L22
.L28:
	leaq	8(%rbx), %rdi
	call	unlink@PLT
	jmp	.L19
.L24:
	.cfi_def_cfa_offset 8
	.cfi_restore 3
	ret
	.cfi_endproc
.LFE75:
	.size	cleanup, .-cleanup
	.globl	time_no_open
	.type	time_no_open, @function
time_no_open:
.LFB76:
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
	movq	%rsi, %rbp
	leaq	-1(%rdi), %rbx
	testq	%rdi, %rdi
	je	.L29
.L31:
	movq	272(%rbp), %rdi
	movq	0(%rbp), %rsi
	call	bread@PLT
	subq	$1, %rbx
	cmpq	$-1, %rbx
	jne	.L31
.L29:
	addq	$8, %rsp
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE76:
	.size	time_no_open, .-time_no_open
	.globl	time_with_open
	.type	time_with_open, @function
time_with_open:
.LFB77:
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
	leaq	8(%rsi), %r14
	movq	(%rsi), %r12
	leaq	-1(%rdi), %r13
	testq	%rdi, %rdi
	je	.L34
.L38:
	movl	$0, %esi
	movq	%r14, %rdi
	movl	$0, %eax
	call	open@PLT
	movl	%eax, %ebx
	cmpl	$-1, %eax
	je	.L41
	movl	$0, %r9d
	movl	%eax, %r8d
	movl	$1, %ecx
	movl	$1, %edx
	movq	%r12, %rsi
	movl	$0, %edi
	call	mmap@PLT
	movq	%rax, %rbp
	cmpq	$-1, %rax
	je	.L42
	movq	%r12, %rsi
	movq	%rax, %rdi
	call	bread@PLT
	movl	%ebx, %edi
	call	close@PLT
	movq	%r12, %rsi
	movq	%rbp, %rdi
	call	munmap@PLT
	subq	$1, %r13
	cmpq	$-1, %r13
	jne	.L38
.L34:
	popq	%rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 40
	popq	%rbp
	.cfi_def_cfa_offset 32
	popq	%r12
	.cfi_def_cfa_offset 24
	popq	%r13
	.cfi_def_cfa_offset 16
	popq	%r14
	.cfi_def_cfa_offset 8
	ret
.L41:
	.cfi_restore_state
	leaq	.LC3(%rip), %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L42:
	leaq	.LC3(%rip), %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
	.cfi_endproc
.LFE77:
	.size	time_with_open, .-time_with_open
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC4:
	.string	"[-C] [-P <parallelism>] [-W <warmup>] [-N <repetitions>] <size> open2close|mmap_only <filename>"
	.section	.rodata.str1.1
.LC5:
	.string	"P:W:N:C"
.LC6:
	.string	"<size> out of range!\n"
.LC7:
	.string	"open2close"
.LC8:
	.string	"mmap_only"
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
	subq	$456, %rsp
	.cfi_def_cfa_offset 512
	movl	%edi, %ebp
	movq	%rsi, %rbx
	movq	%fs:40, %rax
	movq	%rax, 440(%rsp)
	xorl	%eax, %eax
	movl	$0, 428(%rsp)
	movl	$-1, %r14d
	movl	$0, 12(%rsp)
	movl	$1, %r13d
	leaq	.LC5(%rip), %r12
	leaq	.LC4(%rip), %r15
	jmp	.L44
.L46:
	cmpl	$87, %eax
	jne	.L49
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	movl	%eax, 12(%rsp)
.L44:
	movq	%r12, %rdx
	movq	%rbx, %rsi
	movl	%ebp, %edi
	call	mygetopt@PLT
	cmpl	$-1, %eax
	je	.L63
	cmpl	$80, %eax
	je	.L45
	jg	.L46
	cmpl	$67, %eax
	je	.L47
	cmpl	$78, %eax
	jne	.L49
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	movl	%eax, %r14d
	jmp	.L44
.L45:
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	movl	%eax, %r13d
	testl	%eax, %eax
	jg	.L44
	movq	%r15, %rdx
	movq	%rbx, %rsi
	movl	%ebp, %edi
	call	lmbench_usage@PLT
	jmp	.L44
.L47:
	movl	$1, 428(%rsp)
	jmp	.L44
.L49:
	movq	%r15, %rdx
	movq	%rbx, %rsi
	movl	%ebp, %edi
	call	lmbench_usage@PLT
	jmp	.L44
.L63:
	movl	myoptind(%rip), %eax
	addl	$3, %eax
	cmpl	%ebp, %eax
	jne	.L64
.L53:
	movslq	myoptind(%rip), %rax
	movq	(%rbx,%rax,8), %rdi
	call	bytes@PLT
	movq	%rax, %r12
	movq	%rax, 160(%rsp)
	movslq	myoptind(%rip), %rax
	movq	16(%rbx,%rax,8), %rsi
	leaq	168(%rsp), %r15
	movl	$256, %edx
	movq	%r15, %rdi
	call	__strcpy_chk@PLT
	leaq	16(%rsp), %rsi
	movq	%r15, %rdi
	call	stat@PLT
	cmpl	$-1, %eax
	je	.L65
	movl	40(%rsp), %eax
	andl	$61440, %eax
	cmpl	$32768, %eax
	je	.L66
.L55:
	cmpq	$511, %r12
	jbe	.L56
	movslq	myoptind(%rip), %rax
	movq	8(%rbx,%rax,8), %r15
	movq	%r15, %rsi
	leaq	.LC7(%rip), %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	je	.L67
	movq	%r15, %rsi
	leaq	.LC8(%rip), %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L60
	leaq	160(%rsp), %rax
	pushq	%rax
	.cfi_def_cfa_offset 520
	pushq	%r14
	.cfi_def_cfa_offset 528
	movl	28(%rsp), %r9d
	movl	%r13d, %r8d
	movl	$0, %ecx
	leaq	cleanup(%rip), %rdx
	leaq	time_no_open(%rip), %rsi
	leaq	init_open(%rip), %rdi
	call	benchmp@PLT
	addq	$16, %rsp
	.cfi_def_cfa_offset 512
.L59:
	call	get_n@PLT
	movslq	%r13d, %rsi
	imulq	%rax, %rsi
	movl	$0, %edx
	movq	%r12, %rdi
	call	bandwidth@PLT
	movq	440(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L68
	movl	$0, %eax
	addq	$456, %rsp
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
.L64:
	.cfi_restore_state
	leaq	.LC4(%rip), %rdx
	movq	%rbx, %rsi
	movl	%ebp, %edi
	call	lmbench_usage@PLT
	jmp	.L53
.L65:
	leaq	.LC3(%rip), %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L66:
	cmpq	64(%rsp), %r12
	jbe	.L55
.L56:
	movq	stderr(%rip), %rcx
	movl	$21, %edx
	movl	$1, %esi
	leaq	.LC6(%rip), %rdi
	call	fwrite@PLT
	movl	$1, %edi
	call	exit@PLT
.L67:
	leaq	160(%rsp), %rax
	pushq	%rax
	.cfi_def_cfa_offset 520
	pushq	%r14
	.cfi_def_cfa_offset 528
	movl	28(%rsp), %r9d
	movl	%r13d, %r8d
	movl	$0, %ecx
	leaq	cleanup(%rip), %rdx
	leaq	time_with_open(%rip), %rsi
	leaq	initialize(%rip), %rdi
	call	benchmp@PLT
	addq	$16, %rsp
	.cfi_def_cfa_offset 512
	jmp	.L59
.L60:
	leaq	.LC4(%rip), %rdx
	movq	%rbx, %rsi
	movl	%ebp, %edi
	call	lmbench_usage@PLT
	jmp	.L59
.L68:
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
