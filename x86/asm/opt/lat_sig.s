	.file	"lat_sig.c"
	.text
	.globl	handler
	.type	handler, @function
handler:
.LFB72:
	.cfi_startproc
	endbr64
	ret
	.cfi_endproc
.LFE72:
	.size	handler, .-handler
	.globl	do_send
	.type	do_send, @function
do_send:
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
	movq	%rdi, %rbx
	call	getpid@PLT
	movl	%eax, %ebp
	subq	$1, %rbx
	je	.L2
.L4:
	movl	$0, %esi
	movl	%ebp, %edi
	call	kill@PLT
	subq	$1, %rbx
	jne	.L4
.L2:
	addq	$8, %rsp
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE73:
	.size	do_send, .-do_send
	.globl	do_install
	.type	do_install, @function
do_install:
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
	subq	$320, %rsp
	.cfi_def_cfa_offset 352
	movq	%fs:40, %rax
	movq	%rax, 312(%rsp)
	xorl	%eax, %eax
	testq	%rdi, %rdi
	je	.L7
	leaq	-1(%rdi), %rbx
	leaq	handler(%rip), %r12
.L9:
	movq	%r12, (%rsp)
	movq	%rsp, %rbp
	leaq	8(%rsp), %rdi
	call	sigemptyset@PLT
	movl	$0, 136(%rsp)
	leaq	160(%rsp), %rdx
	movq	%rbp, %rsi
	movl	$10, %edi
	call	sigaction@PLT
	subq	$1, %rbx
	cmpq	$-1, %rbx
	jne	.L9
.L7:
	movq	312(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L13
	addq	$320, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 32
	popq	%rbx
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	ret
.L13:
	.cfi_restore_state
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE74:
	.size	do_install, .-do_install
	.globl	do_catch
	.type	do_catch, @function
do_catch:
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
	subq	$320, %rsp
	.cfi_def_cfa_offset 352
	movq	%rdi, %rbx
	movq	%fs:40, %rax
	movq	%rax, 312(%rsp)
	xorl	%eax, %eax
	call	getpid@PLT
	movl	%eax, %ebp
	leaq	handler(%rip), %rax
	movq	%rax, (%rsp)
	movq	%rsp, %r12
	leaq	8(%rsp), %rdi
	call	sigemptyset@PLT
	movl	$0, 136(%rsp)
	leaq	160(%rsp), %rdx
	movq	%r12, %rsi
	movl	$10, %edi
	call	sigaction@PLT
	subq	$1, %rbx
	je	.L14
.L16:
	movl	$10, %esi
	movl	%ebp, %edi
	call	kill@PLT
	subq	$1, %rbx
	jne	.L16
.L14:
	movq	312(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L20
	addq	$320, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 32
	popq	%rbx
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	ret
.L20:
	.cfi_restore_state
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE75:
	.size	do_catch, .-do_catch
	.globl	prot
	.type	prot, @function
prot:
.LFB76:
	.cfi_startproc
	endbr64
	movq	caught(%rip), %rax
	addq	$1, %rax
	movq	%rax, caught(%rip)
	cmpq	n(%rip), %rax
	je	.L27
	ret
.L27:
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	movq	$0, caught(%rip)
	movl	$0, %eax
	call	benchmp_getstate@PLT
	movq	%rax, %rdi
	call	benchmp_interval@PLT
	movq	%rax, n(%rip)
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE76:
	.size	prot, .-prot
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"mmap"
	.text
	.globl	initialize
	.type	initialize, @function
initialize:
.LFB77:
	.cfi_startproc
	endbr64
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	subq	$160, %rsp
	.cfi_def_cfa_offset 176
	movq	%fs:40, %rax
	movq	%rax, 152(%rsp)
	xorl	%eax, %eax
	testq	%rdi, %rdi
	je	.L33
.L28:
	movq	152(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L34
	addq	$160, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 16
	popq	%rbx
	.cfi_def_cfa_offset 8
	ret
.L33:
	.cfi_restore_state
	movq	%rsi, %rbx
	movl	$0, %esi
	movq	(%rbx), %rdi
	call	open@PLT
	movl	%eax, %r8d
	movl	$0, %r9d
	movl	$1, %ecx
	movl	$1, %edx
	movl	$4096, %esi
	movl	$0, %edi
	call	mmap@PLT
	movq	%rax, 8(%rbx)
	cmpq	$-1, %rax
	je	.L35
	leaq	prot(%rip), %rax
	movq	%rax, (%rsp)
	movq	%rsp, %rbx
	leaq	8(%rsp), %rdi
	call	sigemptyset@PLT
	movl	$0, 136(%rsp)
	movl	$0, %edx
	movq	%rbx, %rsi
	movl	$11, %edi
	call	sigaction@PLT
	movl	$0, %edx
	movq	%rbx, %rsi
	movl	$7, %edi
	call	sigaction@PLT
	jmp	.L28
.L35:
	leaq	.LC0(%rip), %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L34:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE77:
	.size	initialize, .-initialize
	.globl	do_prot
	.type	do_prot, @function
do_prot:
.LFB78:
	.cfi_startproc
	endbr64
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movq	%rsi, %rbx
	movq	%rdi, n(%rip)
	movq	$0, caught(%rip)
	movl	$0, %edi
	call	start@PLT
	movq	8(%rbx), %rax
	movb	$1, (%rax)
	popq	%rbx
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE78:
	.size	do_prot, .-do_prot
	.globl	bench_catch
	.type	bench_catch, @function
bench_catch:
.LFB79:
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
	movl	%edi, %ebp
	movl	%esi, %r13d
	movl	%edx, %r14d
	pushq	$0
	.cfi_def_cfa_offset 56
	pushq	%rdx
	.cfi_def_cfa_offset 64
	movl	%esi, %r9d
	movl	%edi, %r8d
	movl	$0, %ecx
	movl	$0, %edx
	leaq	do_send(%rip), %rsi
	movl	$0, %edi
	call	benchmp@PLT
	call	usecs_spent@PLT
	movq	%rax, %r12
	call	get_n@PLT
	movq	%rax, %rbx
	pushq	$0
	.cfi_def_cfa_offset 72
	pushq	%r14
	.cfi_def_cfa_offset 80
	movl	%r13d, %r9d
	movl	%ebp, %r8d
	movl	$0, %ecx
	movl	$0, %edx
	leaq	do_catch(%rip), %rsi
	movl	$0, %edi
	call	benchmp@PLT
	addq	$32, %rsp
	.cfi_def_cfa_offset 48
	call	usecs_spent@PLT
	movq	%rax, %rbp
	call	get_n@PLT
	imulq	%r12, %rax
	movl	$0, %edx
	divq	%rbx
	cmpq	%rax, %rbp
	jbe	.L39
	call	usecs_spent@PLT
	movq	%rax, %rbp
	call	get_n@PLT
	imulq	%r12, %rax
	movl	$0, %edx
	divq	%rbx
	movq	%rbp, %rdi
	subq	%rax, %rdi
	call	settime@PLT
.L38:
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
.L39:
	.cfi_restore_state
	movl	$0, %edi
	call	settime@PLT
	jmp	.L38
	.cfi_endproc
.LFE79:
	.size	bench_catch, .-bench_catch
	.globl	bench_prot
	.type	bench_prot, @function
bench_prot:
.LFB80:
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
	subq	$32, %rsp
	.cfi_def_cfa_offset 80
	movl	%esi, %ebp
	movl	%edx, %r13d
	movl	%ecx, %r14d
	movq	%fs:40, %rax
	movq	%rax, 24(%rsp)
	xorl	%eax, %eax
	movq	%rdi, (%rsp)
	movl	%ecx, %edx
	movl	%r13d, %esi
	movl	%ebp, %edi
	call	bench_catch
	call	usecs_spent@PLT
	movq	%rax, %r12
	call	get_n@PLT
	movq	%rax, %rbx
	movq	%rsp, %rax
	pushq	%rax
	.cfi_def_cfa_offset 88
	pushq	%r14
	.cfi_def_cfa_offset 96
	movl	%r13d, %r9d
	movl	%ebp, %r8d
	movl	$0, %ecx
	movl	$0, %edx
	leaq	do_prot(%rip), %rsi
	leaq	initialize(%rip), %rdi
	call	benchmp@PLT
	call	usecs_spent@PLT
	movq	%rax, %rbp
	call	get_n@PLT
	imulq	%r12, %rax
	movl	$0, %edx
	divq	%rbx
	addq	$16, %rsp
	.cfi_def_cfa_offset 80
	cmpq	%rax, %rbp
	jbe	.L43
	call	usecs_spent@PLT
	movq	%rax, %rbp
	call	get_n@PLT
	imulq	%r12, %rax
	movl	$0, %edx
	divq	%rbx
	movq	%rbp, %rdi
	subq	%rax, %rdi
	call	settime@PLT
.L42:
	movq	24(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L47
	addq	$32, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 48
	popq	%rbx
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
.L43:
	.cfi_restore_state
	movl	$0, %edi
	call	settime@PLT
	jmp	.L42
.L47:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE80:
	.size	bench_prot, .-bench_prot
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC1:
	.string	"[-P <parallelism>] [-W <warmup>] [-N <repetitions>] install|catch|prot [file]\n"
	.section	.rodata.str1.1
.LC2:
	.string	"P:W:N:"
.LC3:
	.string	"install"
.LC4:
	.string	"Signal handler installation"
.LC5:
	.string	"catch"
.LC6:
	.string	"Signal handler overhead"
.LC7:
	.string	"prot"
.LC8:
	.string	"Protection fault"
	.text
	.globl	main
	.type	main, @function
main:
.LFB81:
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
	movl	$-1, %r12d
	movl	$0, 12(%rsp)
	movl	$1, 8(%rsp)
	leaq	.LC2(%rip), %r13
	leaq	.LC1(%rip), %r14
	jmp	.L49
.L50:
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	movl	%eax, 8(%rsp)
	testl	%eax, %eax
	jg	.L49
	movq	%r14, %rdx
	movq	%rbp, %rsi
	movl	%ebx, %edi
	call	lmbench_usage@PLT
	jmp	.L49
.L51:
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	movl	%eax, 12(%rsp)
.L49:
	movq	%r13, %rdx
	movq	%rbp, %rsi
	movl	%ebx, %edi
	call	mygetopt@PLT
	cmpl	$-1, %eax
	je	.L63
	cmpl	$80, %eax
	je	.L50
	cmpl	$87, %eax
	je	.L51
	cmpl	$78, %eax
	je	.L64
	movq	%r14, %rdx
	movq	%rbp, %rsi
	movl	%ebx, %edi
	call	lmbench_usage@PLT
	jmp	.L49
.L64:
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	movl	%eax, %r12d
	jmp	.L49
.L63:
	movl	myoptind(%rip), %eax
	leal	-1(%rbx), %edx
	cmpl	%eax, %edx
	je	.L56
	leal	-2(%rbx), %edx
	cmpl	%edx, %eax
	jne	.L65
.L56:
	movl	myoptind(%rip), %r14d
	movslq	%r14d, %rax
	leaq	0(,%rax,8), %r15
	movq	0(%rbp,%rax,8), %r13
	movq	%r13, %rsi
	leaq	.LC3(%rip), %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	je	.L66
	movq	%r13, %rsi
	leaq	.LC5(%rip), %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	je	.L67
	movq	%r13, %rsi
	leaq	.LC7(%rip), %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L60
	leal	-2(%rbx), %eax
	cmpl	%eax, %r14d
	je	.L68
.L60:
	leaq	.LC1(%rip), %rdx
	movq	%rbp, %rsi
	movl	%ebx, %edi
	call	lmbench_usage@PLT
.L58:
	movl	$0, %eax
	addq	$24, %rsp
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
.L65:
	.cfi_restore_state
	leaq	.LC1(%rip), %rdx
	movq	%rbp, %rsi
	movl	%ebx, %edi
	call	lmbench_usage@PLT
	jmp	.L56
.L66:
	pushq	$0
	.cfi_def_cfa_offset 88
	pushq	%r12
	.cfi_def_cfa_offset 96
	movl	28(%rsp), %r9d
	movl	24(%rsp), %r8d
	movl	$0, %ecx
	movl	$0, %edx
	leaq	do_install(%rip), %rsi
	movl	$0, %edi
	call	benchmp@PLT
	call	get_n@PLT
	movq	%rax, %rsi
	leaq	.LC4(%rip), %rdi
	call	micro@PLT
	addq	$16, %rsp
	.cfi_def_cfa_offset 80
	jmp	.L58
.L67:
	movl	%r12d, %edx
	movl	12(%rsp), %esi
	movl	8(%rsp), %edi
	call	bench_catch
	call	get_n@PLT
	movq	%rax, %rsi
	leaq	.LC6(%rip), %rdi
	call	micro@PLT
	jmp	.L58
.L68:
	movq	8(%rbp,%r15), %rdi
	movl	%r12d, %ecx
	movl	12(%rsp), %edx
	movl	8(%rsp), %esi
	call	bench_prot
	call	get_n@PLT
	movq	%rax, %rsi
	leaq	.LC8(%rip), %rdi
	call	micro@PLT
	jmp	.L58
	.cfi_endproc
.LFE81:
	.size	main, .-main
	.globl	prot_env
	.bss
	.align 32
	.type	prot_env, @object
	.size	prot_env, 200
prot_env:
	.zero	200
	.globl	adj
	.align 8
	.type	adj, @object
	.size	adj, 8
adj:
	.zero	8
	.globl	n
	.align 8
	.type	n, @object
	.size	n, 8
n:
	.zero	8
	.globl	caught
	.align 8
	.type	caught, @object
	.size	caught, 8
caught:
	.zero	8
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
