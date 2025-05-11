	.file	"bw_file_rd.c"
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
	subq	$144, %rsp
	.cfi_def_cfa_offset 176
	movq	%fs:40, %rax
	movq	%rax, 136(%rsp)
	xorl	%eax, %eax
	testq	%rdi, %rdi
	jne	.L1
	movq	%rsi, %rbx
	movl	$-1, 256(%rsi)
	cmpl	$0, 260(%rsi)
	jne	.L6
.L1:
	movq	136(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L7
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
.L6:
	.cfi_restore_state
	call	getpid@PLT
	movl	%eax, %r8d
	movq	%rsp, %r12
	leaq	.LC0(%rip), %rcx
	movl	$128, %edx
	movl	$1, %esi
	movq	%r12, %rdi
	movl	$0, %eax
	call	__sprintf_chk@PLT
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
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC3:
	.string	"ofd = open(state->filename, O_RDONLY)"
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
	movl	$0, %esi
	movq	%rbx, %rdi
	movl	$0, %eax
	call	open@PLT
	cmpl	$-1, %eax
	je	.L17
	movl	%eax, 256(%rbx)
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
	.cfi_endproc
.LFE74:
	.size	init_open, .-init_open
	.globl	cleanup
	.type	cleanup, @function
cleanup:
.LFB77:
	.cfi_startproc
	endbr64
	testq	%rdi, %rdi
	jne	.L22
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movq	%rsi, %rbx
	movl	256(%rsi), %edi
	testl	%edi, %edi
	jns	.L25
.L20:
	cmpl	$0, 260(%rbx)
	jne	.L26
.L18:
	popq	%rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	ret
.L25:
	.cfi_restore_state
	call	close@PLT
	jmp	.L20
.L26:
	movq	%rbx, %rdi
	call	unlink@PLT
	jmp	.L18
.L22:
	.cfi_def_cfa_offset 8
	.cfi_restore 3
	ret
	.cfi_endproc
.LFE77:
	.size	cleanup, .-cleanup
	.globl	doit
	.type	doit, @function
doit:
.LFB72:
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
	movl	%edi, %r12d
	movq	count(%rip), %rbx
	movq	xfersize(%rip), %rbp
	testq	%rbx, %rbx
	je	.L27
.L29:
	cmpq	%rbx, %rbp
	cmova	%rbx, %rbp
	cmpq	%rbx, %rbp
	movq	%rbx, %rdx
	cmovbe	%rbp, %rdx
	movq	buf(%rip), %rsi
	movl	%r12d, %edi
	call	read@PLT
	testq	%rax, %rax
	jle	.L27
	movq	xfersize(%rip), %rsi
	cmpq	%rsi, %rbx
	cmovbe	%rbx, %rsi
	movq	buf(%rip), %rdi
	call	bread@PLT
	subq	%rbp, %rbx
	jne	.L29
.L27:
	popq	%rbx
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE72:
	.size	doit, .-doit
	.globl	time_with_open
	.type	time_with_open, @function
time_with_open:
.LFB75:
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
	movq	%rsi, %r12
	leaq	-1(%rdi), %rbp
	testq	%rdi, %rdi
	je	.L32
.L34:
	movl	$0, %esi
	movq	%r12, %rdi
	movl	$0, %eax
	call	open@PLT
	movl	%eax, %ebx
	movl	%eax, %edi
	call	doit
	movl	%ebx, %edi
	call	close@PLT
	subq	$1, %rbp
	cmpq	$-1, %rbp
	jne	.L34
.L32:
	popq	%rbx
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE75:
	.size	time_with_open, .-time_with_open
	.globl	time_io_only
	.type	time_io_only, @function
time_io_only:
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
	movl	256(%rsi), %ebp
	leaq	-1(%rdi), %rbx
	testq	%rdi, %rdi
	je	.L37
.L39:
	movl	$0, %edx
	movl	$0, %esi
	movl	%ebp, %edi
	call	lseek@PLT
	movl	%ebp, %edi
	call	doit
	subq	$1, %rbx
	cmpq	$-1, %rbx
	jne	.L39
.L37:
	addq	$8, %rsp
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE76:
	.size	time_io_only, .-time_io_only
	.section	.rodata.str1.8
	.align 8
.LC4:
	.string	"[-C] [-P <parallelism>] [-W <warmup>] [-N <repetitions>] <size> open2close|io_only <filename>\nmin size=%d\n"
	.section	.rodata.str1.1
.LC5:
	.string	"P:W:N:C"
.LC6:
	.string	"open2close"
.LC7:
	.string	"io_only"
	.text
	.globl	main
	.type	main, @function
main:
.LFB78:
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
	subq	$1320, %rsp
	.cfi_def_cfa_offset 1376
	movl	%edi, %ebp
	movq	%rsi, %rbx
	movq	%fs:40, %rax
	movq	%rax, 1304(%rsp)
	xorl	%eax, %eax
	leaq	272(%rsp), %rdi
	movl	$64, %r8d
	leaq	.LC4(%rip), %rcx
	movl	$1024, %edx
	movl	$1, %esi
	call	__sprintf_chk@PLT
	movl	$0, 260(%rsp)
	movl	$-1, %r15d
	movl	$0, %r14d
	movl	$1, %r13d
	leaq	.LC5(%rip), %r12
	jmp	.L43
.L45:
	cmpl	$87, %eax
	jne	.L48
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	movl	%eax, %r14d
.L43:
	movq	%r12, %rdx
	movq	%rbx, %rsi
	movl	%ebp, %edi
	call	mygetopt@PLT
	cmpl	$-1, %eax
	je	.L60
	cmpl	$80, %eax
	je	.L44
	jg	.L45
	cmpl	$67, %eax
	je	.L46
	cmpl	$78, %eax
	jne	.L48
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	movl	%eax, %r15d
	jmp	.L43
.L44:
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	movl	%eax, %r13d
	testl	%eax, %eax
	jg	.L43
	leaq	272(%rsp), %rdx
	movq	%rbx, %rsi
	movl	%ebp, %edi
	call	lmbench_usage@PLT
	jmp	.L43
.L46:
	movl	$1, 260(%rsp)
	jmp	.L43
.L48:
	leaq	272(%rsp), %rdx
	movq	%rbx, %rsi
	movl	%ebp, %edi
	call	lmbench_usage@PLT
	jmp	.L43
.L60:
	movl	myoptind(%rip), %eax
	addl	$3, %eax
	cmpl	%ebp, %eax
	jne	.L61
.L52:
	movslq	myoptind(%rip), %rax
	addq	$2, %rax
	leaq	0(,%rax,8), %r12
	movq	(%rbx,%rax,8), %rsi
	movq	%rsp, %rdi
	movl	$256, %edx
	call	__strcpy_chk@PLT
	movq	-16(%rbx,%r12), %rdi
	call	bytes@PLT
	movq	%rax, count(%rip)
	cmpq	$511, %rax
	jbe	.L62
	movl	$65536, %edx
	cmpq	%rdx, %rax
	cmova	%rdx, %rax
	movq	%rax, xfersize(%rip)
	movl	$65536, %edi
	call	valloc@PLT
	movq	%rax, %rdi
	movq	%rax, buf(%rip)
	movl	$65536, %edx
	movl	$0, %esi
	call	memset@PLT
	movslq	myoptind(%rip), %rax
	movq	8(%rbx,%rax,8), %r12
	movq	%r12, %rsi
	leaq	.LC6(%rip), %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	je	.L63
	movq	%r12, %rsi
	leaq	.LC7(%rip), %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L57
	movq	%rsp, %rax
	pushq	%rax
	.cfi_def_cfa_offset 1384
	pushq	%r15
	.cfi_def_cfa_offset 1392
	movl	%r14d, %r9d
	movl	%r13d, %r8d
	movl	$0, %ecx
	leaq	cleanup(%rip), %rdx
	leaq	time_io_only(%rip), %rsi
	leaq	init_open(%rip), %rdi
	call	benchmp@PLT
	addq	$16, %rsp
	.cfi_def_cfa_offset 1376
.L56:
	call	get_n@PLT
	movslq	%r13d, %rsi
	imulq	%rax, %rsi
	movl	$0, %edx
	movq	count(%rip), %rdi
	call	bandwidth@PLT
	movq	1304(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L64
	movl	$0, %eax
	addq	$1320, %rsp
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
.L61:
	.cfi_restore_state
	leaq	272(%rsp), %rdx
	movq	%rbx, %rsi
	movl	%ebp, %edi
	call	lmbench_usage@PLT
	jmp	.L52
.L62:
	movl	$1, %edi
	call	exit@PLT
.L63:
	movq	%rsp, %rax
	pushq	%rax
	.cfi_def_cfa_offset 1384
	pushq	%r15
	.cfi_def_cfa_offset 1392
	movl	%r14d, %r9d
	movl	%r13d, %r8d
	movl	$0, %ecx
	leaq	cleanup(%rip), %rdx
	leaq	time_with_open(%rip), %rsi
	leaq	initialize(%rip), %rdi
	call	benchmp@PLT
	addq	$16, %rsp
	.cfi_def_cfa_offset 1376
	jmp	.L56
.L57:
	leaq	272(%rsp), %rdx
	movq	%rbx, %rsi
	movl	%ebp, %edi
	call	lmbench_usage@PLT
	jmp	.L56
.L64:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE78:
	.size	main, .-main
	.globl	count
	.bss
	.align 8
	.type	count, @object
	.size	count, 8
count:
	.zero	8
	.globl	xfersize
	.align 8
	.type	xfersize, @object
	.size	xfersize, 8
xfersize:
	.zero	8
	.globl	buf
	.align 8
	.type	buf, @object
	.size	buf, 8
buf:
	.zero	8
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
