	.file	"lat_sig.c"
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
	.globl	caught
	.bss
	.align 8
	.type	caught, @object
	.size	caught, 8
caught:
	.zero	8
	.globl	n
	.align 8
	.type	n, @object
	.size	n, 8
n:
	.zero	8
	.globl	adj
	.align 8
	.type	adj, @object
	.size	adj, 8
adj:
	.zero	8
	.text
	.globl	handler
	.type	handler, @function
handler:
.LFB8:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%edi, -4(%rbp)
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE8:
	.size	handler, .-handler
	.globl	prot_env
	.bss
	.align 32
	.type	prot_env, @object
	.size	prot_env, 200
prot_env:
	.zero	200
	.text
	.globl	do_send
	.type	do_send, @function
do_send:
.LFB9:
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
	call	getpid@PLT
	movl	%eax, -4(%rbp)
	jmp	.L3
.L4:
	movl	-4(%rbp), %eax
	movl	$0, %esi
	movl	%eax, %edi
	call	kill@PLT
.L3:
	subq	$1, -24(%rbp)
	cmpq	$0, -24(%rbp)
	jne	.L4
	nop
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE9:
	.size	do_send, .-do_send
	.globl	do_install
	.type	do_install, @function
do_install:
.LFB10:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$336, %rsp
	movq	%rdi, -328(%rbp)
	movq	%rsi, -336(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	jmp	.L6
.L7:
	leaq	handler(%rip), %rax
	movq	%rax, -320(%rbp)
	leaq	-320(%rbp), %rax
	addq	$8, %rax
	movq	%rax, %rdi
	call	sigemptyset@PLT
	movl	$0, -184(%rbp)
	leaq	-160(%rbp), %rdx
	leaq	-320(%rbp), %rax
	movq	%rax, %rsi
	movl	$10, %edi
	call	sigaction@PLT
.L6:
	movq	-328(%rbp), %rax
	leaq	-1(%rax), %rdx
	movq	%rdx, -328(%rbp)
	testq	%rax, %rax
	jne	.L7
	nop
	movq	-8(%rbp), %rax
	subq	%fs:40, %rax
	je	.L8
	call	__stack_chk_fail@PLT
.L8:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE10:
	.size	do_install, .-do_install
	.globl	do_catch
	.type	do_catch, @function
do_catch:
.LFB11:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$352, %rsp
	movq	%rdi, -344(%rbp)
	movq	%rsi, -352(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	call	getpid@PLT
	movl	%eax, -324(%rbp)
	leaq	handler(%rip), %rax
	movq	%rax, -320(%rbp)
	leaq	-320(%rbp), %rax
	addq	$8, %rax
	movq	%rax, %rdi
	call	sigemptyset@PLT
	movl	$0, -184(%rbp)
	leaq	-160(%rbp), %rdx
	leaq	-320(%rbp), %rax
	movq	%rax, %rsi
	movl	$10, %edi
	call	sigaction@PLT
	jmp	.L10
.L11:
	movl	-324(%rbp), %eax
	movl	$10, %esi
	movl	%eax, %edi
	call	kill@PLT
.L10:
	subq	$1, -344(%rbp)
	cmpq	$0, -344(%rbp)
	jne	.L11
	nop
	movq	-8(%rbp), %rax
	subq	%fs:40, %rax
	je	.L12
	call	__stack_chk_fail@PLT
.L12:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE11:
	.size	do_catch, .-do_catch
	.globl	prot
	.type	prot, @function
prot:
.LFB12:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movl	%edi, -4(%rbp)
	movq	caught(%rip), %rax
	addq	$1, %rax
	movq	%rax, caught(%rip)
	movq	caught(%rip), %rdx
	movq	n(%rip), %rax
	cmpq	%rax, %rdx
	jne	.L15
	movq	$0, caught(%rip)
	movl	$0, %eax
	call	benchmp_getstate@PLT
	movq	%rax, %rdi
	call	benchmp_interval@PLT
	movq	%rax, n(%rip)
.L15:
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE12:
	.size	prot, .-prot
	.section	.rodata
.LC1:
	.string	"mmap"
	.text
	.globl	initialize
	.type	initialize, @function
initialize:
.LFB13:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$192, %rsp
	movq	%rdi, -184(%rbp)
	movq	%rsi, -192(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movq	-192(%rbp), %rax
	movq	%rax, -168(%rbp)
	cmpq	$0, -184(%rbp)
	jne	.L21
	movq	-168(%rbp), %rax
	movq	(%rax), %rax
	movl	$0, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	open@PLT
	movl	%eax, -172(%rbp)
	movl	-172(%rbp), %eax
	movl	$0, %r9d
	movl	%eax, %r8d
	movl	$1, %ecx
	movl	$1, %edx
	movl	$4096, %esi
	movl	$0, %edi
	call	mmap@PLT
	movq	-168(%rbp), %rdx
	movq	%rax, 8(%rdx)
	movq	-168(%rbp), %rax
	movq	8(%rax), %rax
	cmpq	$-1, %rax
	jne	.L19
	leaq	.LC1(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L19:
	leaq	prot(%rip), %rax
	movq	%rax, -160(%rbp)
	leaq	-160(%rbp), %rax
	addq	$8, %rax
	movq	%rax, %rdi
	call	sigemptyset@PLT
	movl	$0, -24(%rbp)
	leaq	-160(%rbp), %rax
	movl	$0, %edx
	movq	%rax, %rsi
	movl	$11, %edi
	call	sigaction@PLT
	leaq	-160(%rbp), %rax
	movl	$0, %edx
	movq	%rax, %rsi
	movl	$7, %edi
	call	sigaction@PLT
	jmp	.L16
.L21:
	nop
.L16:
	movq	-8(%rbp), %rax
	subq	%fs:40, %rax
	je	.L20
	call	__stack_chk_fail@PLT
.L20:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE13:
	.size	initialize, .-initialize
	.globl	do_prot
	.type	do_prot, @function
do_prot:
.LFB14:
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
	movq	-32(%rbp), %rax
	movq	%rax, -8(%rbp)
	movq	-24(%rbp), %rax
	movq	%rax, n(%rip)
	movq	$0, caught(%rip)
	movl	$0, %edi
	call	start@PLT
	movq	-8(%rbp), %rax
	movq	8(%rax), %rax
	movb	$1, (%rax)
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE14:
	.size	do_prot, .-do_prot
	.globl	bench_catch
	.type	bench_catch, @function
bench_catch:
.LFB15:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%rbx
	subq	$40, %rsp
	.cfi_offset 3, -24
	movl	%edi, -36(%rbp)
	movl	%esi, -40(%rbp)
	movl	%edx, -44(%rbp)
	movl	-40(%rbp), %ecx
	movl	-36(%rbp), %edx
	pushq	$0
	movl	-44(%rbp), %eax
	pushq	%rax
	movl	%ecx, %r9d
	movl	%edx, %r8d
	movl	$0, %ecx
	movl	$0, %edx
	leaq	do_send(%rip), %rax
	movq	%rax, %rsi
	movl	$0, %edi
	call	benchmp@PLT
	addq	$16, %rsp
	call	usecs_spent@PLT
	movq	%rax, -32(%rbp)
	call	get_n@PLT
	movq	%rax, -24(%rbp)
	movl	-40(%rbp), %ecx
	movl	-36(%rbp), %edx
	pushq	$0
	movl	-44(%rbp), %eax
	pushq	%rax
	movl	%ecx, %r9d
	movl	%edx, %r8d
	movl	$0, %ecx
	movl	$0, %edx
	leaq	do_catch(%rip), %rax
	movq	%rax, %rsi
	movl	$0, %edi
	call	benchmp@PLT
	addq	$16, %rsp
	call	usecs_spent@PLT
	movq	%rax, %rbx
	call	get_n@PLT
	imulq	-32(%rbp), %rax
	movl	$0, %edx
	divq	-24(%rbp)
	cmpq	%rax, %rbx
	jbe	.L24
	call	usecs_spent@PLT
	movq	%rax, %rbx
	call	get_n@PLT
	imulq	-32(%rbp), %rax
	movl	$0, %edx
	divq	-24(%rbp)
	movq	%rax, %rdx
	movq	%rbx, %rax
	subq	%rdx, %rax
	movq	%rax, %rdi
	call	settime@PLT
	jmp	.L26
.L24:
	movl	$0, %edi
	call	settime@PLT
.L26:
	nop
	movq	-8(%rbp), %rbx
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE15:
	.size	bench_catch, .-bench_catch
	.globl	bench_prot
	.type	bench_prot, @function
bench_prot:
.LFB16:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%rbx
	subq	$88, %rsp
	.cfi_offset 3, -24
	movq	%rdi, -72(%rbp)
	movl	%esi, -76(%rbp)
	movl	%edx, -80(%rbp)
	movl	%ecx, -84(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -24(%rbp)
	xorl	%eax, %eax
	movq	-72(%rbp), %rax
	movq	%rax, -48(%rbp)
	movl	-84(%rbp), %edx
	movl	-80(%rbp), %ecx
	movl	-76(%rbp), %eax
	movl	%ecx, %esi
	movl	%eax, %edi
	call	bench_catch
	call	usecs_spent@PLT
	movq	%rax, -64(%rbp)
	call	get_n@PLT
	movq	%rax, -56(%rbp)
	movl	-80(%rbp), %ecx
	movl	-76(%rbp), %edx
	leaq	-48(%rbp), %rax
	pushq	%rax
	movl	-84(%rbp), %eax
	pushq	%rax
	movl	%ecx, %r9d
	movl	%edx, %r8d
	movl	$0, %ecx
	movl	$0, %edx
	leaq	do_prot(%rip), %rax
	movq	%rax, %rsi
	leaq	initialize(%rip), %rax
	movq	%rax, %rdi
	call	benchmp@PLT
	addq	$16, %rsp
	call	usecs_spent@PLT
	movq	%rax, %rbx
	call	get_n@PLT
	imulq	-64(%rbp), %rax
	movl	$0, %edx
	divq	-56(%rbp)
	cmpq	%rax, %rbx
	jbe	.L28
	call	usecs_spent@PLT
	movq	%rax, %rbx
	call	get_n@PLT
	imulq	-64(%rbp), %rax
	movl	$0, %edx
	divq	-56(%rbp)
	movq	%rax, %rdx
	movq	%rbx, %rax
	subq	%rdx, %rax
	movq	%rax, %rdi
	call	settime@PLT
	jmp	.L31
.L28:
	movl	$0, %edi
	call	settime@PLT
.L31:
	nop
	movq	-24(%rbp), %rax
	subq	%fs:40, %rax
	je	.L30
	call	__stack_chk_fail@PLT
.L30:
	movq	-8(%rbp), %rbx
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE16:
	.size	bench_prot, .-bench_prot
	.section	.rodata
	.align 8
.LC2:
	.string	"[-P <parallelism>] [-W <warmup>] [-N <repetitions>] install|catch|prot [file]\n"
.LC3:
	.string	"P:W:N:"
.LC4:
	.string	"install"
.LC5:
	.string	"Signal handler installation"
.LC6:
	.string	"catch"
.LC7:
	.string	"Signal handler overhead"
.LC8:
	.string	"prot"
.LC9:
	.string	"Protection fault"
	.text
	.globl	main
	.type	main, @function
main:
.LFB17:
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
	movl	$1, -24(%rbp)
	movl	$0, -20(%rbp)
	movl	$-1, -16(%rbp)
	leaq	.LC2(%rip), %rax
	movq	%rax, -8(%rbp)
	jmp	.L33
.L38:
	cmpl	$87, -12(%rbp)
	je	.L34
	cmpl	$87, -12(%rbp)
	jg	.L35
	cmpl	$78, -12(%rbp)
	je	.L36
	cmpl	$80, -12(%rbp)
	jne	.L35
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -24(%rbp)
	cmpl	$0, -24(%rbp)
	jg	.L33
	movq	-8(%rbp), %rdx
	movq	-48(%rbp), %rcx
	movl	-36(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	lmbench_usage@PLT
	jmp	.L33
.L34:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -20(%rbp)
	jmp	.L33
.L36:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -16(%rbp)
	jmp	.L33
.L35:
	movq	-8(%rbp), %rdx
	movq	-48(%rbp), %rcx
	movl	-36(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	lmbench_usage@PLT
	nop
.L33:
	movq	-48(%rbp), %rcx
	movl	-36(%rbp), %eax
	leaq	.LC3(%rip), %rdx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	mygetopt@PLT
	movl	%eax, -12(%rbp)
	cmpl	$-1, -12(%rbp)
	jne	.L38
	movl	-36(%rbp), %eax
	leal	-1(%rax), %edx
	movl	myoptind(%rip), %eax
	cmpl	%eax, %edx
	je	.L39
	movl	-36(%rbp), %eax
	leal	-2(%rax), %edx
	movl	myoptind(%rip), %eax
	cmpl	%eax, %edx
	je	.L39
	movq	-8(%rbp), %rdx
	movq	-48(%rbp), %rcx
	movl	-36(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	lmbench_usage@PLT
.L39:
	movl	myoptind(%rip), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-48(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	%rax, %rsi
	leaq	.LC4(%rip), %rax
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L40
	movl	-20(%rbp), %ecx
	movl	-24(%rbp), %edx
	pushq	$0
	movl	-16(%rbp), %eax
	pushq	%rax
	movl	%ecx, %r9d
	movl	%edx, %r8d
	movl	$0, %ecx
	movl	$0, %edx
	leaq	do_install(%rip), %rax
	movq	%rax, %rsi
	movl	$0, %edi
	call	benchmp@PLT
	addq	$16, %rsp
	call	get_n@PLT
	movq	%rax, %rsi
	leaq	.LC5(%rip), %rax
	movq	%rax, %rdi
	call	micro@PLT
	jmp	.L41
.L40:
	movl	myoptind(%rip), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-48(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	%rax, %rsi
	leaq	.LC6(%rip), %rax
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L42
	movl	-16(%rbp), %edx
	movl	-20(%rbp), %ecx
	movl	-24(%rbp), %eax
	movl	%ecx, %esi
	movl	%eax, %edi
	call	bench_catch
	call	get_n@PLT
	movq	%rax, %rsi
	leaq	.LC7(%rip), %rax
	movq	%rax, %rdi
	call	micro@PLT
	jmp	.L41
.L42:
	movl	myoptind(%rip), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-48(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	%rax, %rsi
	leaq	.LC8(%rip), %rax
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L43
	movl	-36(%rbp), %eax
	leal	-2(%rax), %edx
	movl	myoptind(%rip), %eax
	cmpl	%eax, %edx
	jne	.L43
	movl	myoptind(%rip), %eax
	cltq
	addq	$1, %rax
	leaq	0(,%rax,8), %rdx
	movq	-48(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movl	-16(%rbp), %ecx
	movl	-20(%rbp), %edx
	movl	-24(%rbp), %esi
	movq	%rax, %rdi
	call	bench_prot
	call	get_n@PLT
	movq	%rax, %rsi
	leaq	.LC9(%rip), %rax
	movq	%rax, %rdi
	call	micro@PLT
	jmp	.L41
.L43:
	movq	-8(%rbp), %rdx
	movq	-48(%rbp), %rcx
	movl	-36(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	lmbench_usage@PLT
.L41:
	movl	$0, %eax
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE17:
	.size	main, .-main
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
