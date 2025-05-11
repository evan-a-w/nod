	.file	"lat_select.c"
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
	.string	"[-n <#descriptors>] [-P <parallelism>] [-W <warmup>] [-N <repetitions>] file|tcp\n"
.LC2:
	.string	"P:W:N:n:"
.LC3:
	.string	"tcp"
.LC4:
	.string	"Select on %d tcp fd's"
.LC5:
	.string	"file"
.LC6:
	.string	"Select on %d fd's"
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
	subq	$512, %rsp
	movl	%edi, -500(%rbp)
	movq	%rsi, -512(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movl	$1, -488(%rbp)
	movl	$0, -484(%rbp)
	movl	$-1, -480(%rbp)
	leaq	.LC1(%rip), %rax
	movq	%rax, -472(%rbp)
	call	morefds@PLT
	movl	$200, -420(%rbp)
	jmp	.L2
.L8:
	cmpl	$110, -476(%rbp)
	je	.L3
	cmpl	$110, -476(%rbp)
	jg	.L4
	cmpl	$87, -476(%rbp)
	je	.L5
	cmpl	$87, -476(%rbp)
	jg	.L4
	cmpl	$78, -476(%rbp)
	je	.L6
	cmpl	$80, -476(%rbp)
	jne	.L4
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -488(%rbp)
	cmpl	$0, -488(%rbp)
	jg	.L2
	movq	-472(%rbp), %rdx
	movq	-512(%rbp), %rcx
	movl	-500(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	lmbench_usage@PLT
	jmp	.L2
.L5:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -484(%rbp)
	jmp	.L2
.L6:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -480(%rbp)
	jmp	.L2
.L3:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	bytes@PLT
	movl	%eax, -420(%rbp)
	jmp	.L2
.L4:
	movq	-472(%rbp), %rdx
	movq	-512(%rbp), %rcx
	movl	-500(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	lmbench_usage@PLT
	nop
.L2:
	movq	-512(%rbp), %rcx
	movl	-500(%rbp), %eax
	leaq	.LC2(%rip), %rdx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	mygetopt@PLT
	movl	%eax, -476(%rbp)
	cmpl	$-1, -476(%rbp)
	jne	.L8
	movl	myoptind(%rip), %eax
	addl	$1, %eax
	cmpl	%eax, -500(%rbp)
	je	.L9
	movq	-472(%rbp), %rdx
	movq	-512(%rbp), %rcx
	movl	-500(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	lmbench_usage@PLT
.L9:
	movl	myoptind(%rip), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-512(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	%rax, %rsi
	leaq	.LC3(%rip), %rax
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L10
	leaq	open_socket(%rip), %rax
	movq	%rax, -440(%rbp)
	leaq	-464(%rbp), %rax
	movq	%rax, %rdi
	call	server
	movl	-484(%rbp), %ecx
	movl	-488(%rbp), %edx
	leaq	-464(%rbp), %rax
	pushq	%rax
	movl	-480(%rbp), %eax
	pushq	%rax
	movl	%ecx, %r9d
	movl	%edx, %r8d
	movl	$0, %ecx
	leaq	cleanup(%rip), %rax
	movq	%rax, %rdx
	leaq	doit(%rip), %rax
	movq	%rax, %rsi
	leaq	initialize(%rip), %rax
	movq	%rax, %rdi
	call	benchmp@PLT
	addq	$16, %rsp
	movl	-420(%rbp), %edx
	leaq	-272(%rbp), %rax
	leaq	.LC4(%rip), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	sprintf@PLT
	movl	-432(%rbp), %eax
	movl	$9, %esi
	movl	%eax, %edi
	call	kill@PLT
	movl	-432(%rbp), %eax
	movl	$0, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	waitpid@PLT
	call	get_n@PLT
	movq	%rax, %rdx
	leaq	-272(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	micro@PLT
	jmp	.L11
.L10:
	movl	myoptind(%rip), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-512(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	%rax, %rsi
	leaq	.LC5(%rip), %rax
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L12
	leaq	open_file(%rip), %rax
	movq	%rax, -440(%rbp)
	leaq	-464(%rbp), %rax
	movq	%rax, %rdi
	call	server
	movl	-484(%rbp), %ecx
	movl	-488(%rbp), %edx
	leaq	-464(%rbp), %rax
	pushq	%rax
	movl	-480(%rbp), %eax
	pushq	%rax
	movl	%ecx, %r9d
	movl	%edx, %r8d
	movl	$0, %ecx
	leaq	cleanup(%rip), %rax
	movq	%rax, %rdx
	leaq	doit(%rip), %rax
	movq	%rax, %rsi
	leaq	initialize(%rip), %rax
	movq	%rax, %rdi
	call	benchmp@PLT
	addq	$16, %rsp
	leaq	-464(%rbp), %rax
	movq	%rax, %rdi
	call	unlink@PLT
	movl	-420(%rbp), %edx
	leaq	-272(%rbp), %rax
	leaq	.LC6(%rip), %rcx
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
	jmp	.L11
.L12:
	movq	-472(%rbp), %rdx
	movq	-512(%rbp), %rcx
	movl	-500(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	lmbench_usage@PLT
.L11:
	movl	$0, %edi
	call	exit@PLT
	.cfi_endproc
.LFE8:
	.size	main, .-main
	.section	.rodata
.LC7:
	.string	"lat_selectXXXXXX"
	.align 8
.LC8:
	.string	"lat_select: Could not create temp file %s"
	.align 8
.LC9:
	.string	"lat_select: Could not open tcp server socket"
	.align 8
.LC10:
	.string	"lat_select::server(): fork() failed"
	.text
	.globl	server
	.type	server, @function
server:
.LFB9:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$192, %rsp
	movq	%rdi, -184(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movq	-184(%rbp), %rax
	movq	%rax, -168(%rbp)
	call	getpid@PLT
	movl	%eax, -176(%rbp)
	movq	-168(%rbp), %rax
	movl	$0, 32(%rax)
	movq	-168(%rbp), %rax
	movq	24(%rax), %rax
	leaq	open_file(%rip), %rdx
	cmpq	%rdx, %rax
	jne	.L15
	movq	-168(%rbp), %rax
	leaq	.LC7(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	sprintf@PLT
	movq	-168(%rbp), %rax
	movq	%rax, %rdi
	call	mkstemp@PLT
	movq	-168(%rbp), %rdx
	movl	%eax, 40(%rdx)
	movq	-168(%rbp), %rax
	movl	40(%rax), %eax
	testl	%eax, %eax
	jg	.L16
	movq	-168(%rbp), %rdx
	leaq	-160(%rbp), %rax
	leaq	.LC8(%rip), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	sprintf@PLT
	leaq	-160(%rbp), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L16:
	movq	-168(%rbp), %rax
	movl	40(%rax), %eax
	movl	%eax, %edi
	call	close@PLT
	jmp	.L14
.L15:
	movl	$8, %esi
	movl	$-31233, %edi
	call	tcp_server@PLT
	movq	-168(%rbp), %rdx
	movl	%eax, 36(%rdx)
	movq	-168(%rbp), %rax
	movl	36(%rax), %eax
	testl	%eax, %eax
	jg	.L18
	leaq	.LC9(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L18:
	call	fork@PLT
	movl	%eax, %edx
	movq	-168(%rbp), %rax
	movl	%edx, 32(%rax)
	movq	-168(%rbp), %rax
	movl	32(%rax), %eax
	cmpl	$-1, %eax
	je	.L19
	testl	%eax, %eax
	jne	.L24
	jmp	.L21
.L22:
	movq	-168(%rbp), %rax
	movl	36(%rax), %eax
	movl	$0, %esi
	movl	%eax, %edi
	call	tcp_accept@PLT
	movl	%eax, -172(%rbp)
	movq	-168(%rbp), %rax
	leaq	40(%rax), %rcx
	movl	-172(%rbp), %eax
	movl	$1, %edx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	read@PLT
	movl	-172(%rbp), %eax
	movl	%eax, %edi
	call	close@PLT
.L21:
	call	getppid@PLT
	cmpl	%eax, -176(%rbp)
	je	.L22
	movl	$0, %edi
	call	exit@PLT
.L19:
	leaq	.LC10(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L24:
	nop
.L14:
	movq	-8(%rbp), %rax
	subq	%fs:40, %rax
	je	.L23
	call	__stack_chk_fail@PLT
.L23:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE9:
	.size	server, .-server
	.section	.rodata
.LC11:
	.string	"localhost"
	.text
	.globl	open_socket
	.type	open_socket, @function
open_socket:
.LFB10:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movl	$0, %edx
	movl	$-31233, %esi
	leaq	.LC11(%rip), %rax
	movq	%rax, %rdi
	call	tcp_connect@PLT
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE10:
	.size	open_socket, .-open_socket
	.globl	open_file
	.type	open_file, @function
open_file:
.LFB11:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%rdi, -24(%rbp)
	movq	-24(%rbp), %rax
	movq	%rax, -8(%rbp)
	movq	-8(%rbp), %rax
	movl	$0, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	open@PLT
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE11:
	.size	open_file, .-open_file
	.globl	doit
	.type	doit, @function
doit:
.LFB12:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%rbx
	subq	$184, %rsp
	.cfi_offset 3, -24
	movq	%rdi, -184(%rbp)
	movq	%rsi, -192(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -24(%rbp)
	xorl	%eax, %eax
	movq	-192(%rbp), %rax
	movq	%rax, -168(%rbp)
	movq	$0, tv.0(%rip)
	movq	$0, 8+tv.0(%rip)
	jmp	.L30
.L31:
	movq	-168(%rbp), %rax
	movq	56(%rax), %rcx
	movq	64(%rax), %rbx
	movq	%rcx, -160(%rbp)
	movq	%rbx, -152(%rbp)
	movq	72(%rax), %rcx
	movq	80(%rax), %rbx
	movq	%rcx, -144(%rbp)
	movq	%rbx, -136(%rbp)
	movq	88(%rax), %rcx
	movq	96(%rax), %rbx
	movq	%rcx, -128(%rbp)
	movq	%rbx, -120(%rbp)
	movq	104(%rax), %rcx
	movq	112(%rax), %rbx
	movq	%rcx, -112(%rbp)
	movq	%rbx, -104(%rbp)
	movq	120(%rax), %rcx
	movq	128(%rax), %rbx
	movq	%rcx, -96(%rbp)
	movq	%rbx, -88(%rbp)
	movq	136(%rax), %rcx
	movq	144(%rax), %rbx
	movq	%rcx, -80(%rbp)
	movq	%rbx, -72(%rbp)
	movq	152(%rax), %rcx
	movq	160(%rax), %rbx
	movq	%rcx, -64(%rbp)
	movq	%rbx, -56(%rbp)
	movq	176(%rax), %rdx
	movq	168(%rax), %rax
	movq	%rax, -48(%rbp)
	movq	%rdx, -40(%rbp)
	movq	-168(%rbp), %rax
	movl	44(%rax), %eax
	leaq	-160(%rbp), %rdx
	leaq	tv.0(%rip), %r8
	movl	$0, %ecx
	movl	$0, %esi
	movl	%eax, %edi
	call	select@PLT
.L30:
	movq	-184(%rbp), %rax
	leaq	-1(%rax), %rdx
	movq	%rdx, -184(%rbp)
	testq	%rax, %rax
	jne	.L31
	nop
	movq	-24(%rbp), %rax
	subq	%fs:40, %rax
	je	.L32
	call	__stack_chk_fail@PLT
.L32:
	movq	-8(%rbp), %rbx
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE12:
	.size	doit, .-doit
	.section	.rodata
.LC12:
	.string	"Could not open device"
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
	subq	$64, %rsp
	movq	%rdi, -56(%rbp)
	movq	%rsi, -64(%rbp)
	movq	-64(%rbp), %rax
	movq	%rax, -16(%rbp)
	movq	-16(%rbp), %rax
	movl	44(%rax), %eax
	movl	%eax, -28(%rbp)
	cmpq	$0, -56(%rbp)
	jne	.L44
	movq	-16(%rbp), %rax
	movq	24(%rax), %rdx
	movq	-64(%rbp), %rax
	movq	%rax, %rdi
	call	*%rdx
	movl	%eax, -24(%rbp)
	cmpl	$0, -24(%rbp)
	jg	.L36
	leaq	.LC12(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L36:
	movq	-16(%rbp), %rax
	movl	$0, 48(%rax)
	movq	-16(%rbp), %rax
	addq	$56, %rax
	movq	%rax, -8(%rbp)
	movl	$0, -32(%rbp)
	jmp	.L37
.L38:
	movq	-8(%rbp), %rax
	movl	-32(%rbp), %edx
	movq	$0, (%rax,%rdx,8)
	addl	$1, -32(%rbp)
.L37:
	cmpl	$15, -32(%rbp)
	jbe	.L38
	movl	$0, -36(%rbp)
	jmp	.L39
.L43:
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	dup@PLT
	movl	%eax, -20(%rbp)
	cmpl	$-1, -20(%rbp)
	je	.L45
	movq	-16(%rbp), %rax
	movl	48(%rax), %eax
	cmpl	%eax, -20(%rbp)
	jle	.L42
	movq	-16(%rbp), %rax
	movl	-20(%rbp), %edx
	movl	%edx, 48(%rax)
.L42:
	movl	-20(%rbp), %eax
	leal	63(%rax), %edx
	testl	%eax, %eax
	cmovs	%edx, %eax
	sarl	$6, %eax
	movl	%eax, %edx
	movq	-16(%rbp), %rax
	movslq	%edx, %rcx
	addq	$6, %rcx
	movq	8(%rax,%rcx,8), %rsi
	movl	-20(%rbp), %eax
	andl	$63, %eax
	movl	$1, %edi
	movl	%eax, %ecx
	salq	%cl, %rdi
	movq	%rdi, %rax
	orq	%rax, %rsi
	movq	%rsi, %rcx
	movq	-16(%rbp), %rax
	movslq	%edx, %rdx
	addq	$6, %rdx
	movq	%rcx, 8(%rax,%rdx,8)
	addl	$1, -36(%rbp)
.L39:
	movl	-36(%rbp), %eax
	cmpl	-28(%rbp), %eax
	jl	.L43
	jmp	.L41
.L45:
	nop
.L41:
	movq	-16(%rbp), %rax
	movl	48(%rax), %eax
	leal	1(%rax), %edx
	movq	-16(%rbp), %rax
	movl	%edx, 48(%rax)
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	close@PLT
	movl	-36(%rbp), %eax
	cmpl	-28(%rbp), %eax
	je	.L33
	movl	$1, %edi
	call	exit@PLT
.L44:
	nop
.L33:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE13:
	.size	initialize, .-initialize
	.globl	cleanup
	.type	cleanup, @function
cleanup:
.LFB14:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$48, %rsp
	movq	%rdi, -40(%rbp)
	movq	%rsi, -48(%rbp)
	movq	-48(%rbp), %rax
	movq	%rax, -16(%rbp)
	cmpq	$0, -40(%rbp)
	jne	.L54
	movl	$0, -24(%rbp)
	jmp	.L49
.L51:
	movl	-24(%rbp), %eax
	leal	63(%rax), %edx
	testl	%eax, %eax
	cmovs	%edx, %eax
	sarl	$6, %eax
	movl	%eax, %edx
	movq	-16(%rbp), %rax
	movslq	%edx, %rdx
	addq	$6, %rdx
	movq	8(%rax,%rdx,8), %rdx
	movl	-24(%rbp), %eax
	andl	$63, %eax
	movl	$1, %esi
	movl	%eax, %ecx
	salq	%cl, %rsi
	movq	%rsi, %rax
	andq	%rdx, %rax
	testq	%rax, %rax
	je	.L50
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	close@PLT
.L50:
	addl	$1, -24(%rbp)
.L49:
	movq	-16(%rbp), %rax
	movl	48(%rax), %eax
	cmpl	%eax, -24(%rbp)
	jle	.L51
	movq	-16(%rbp), %rax
	addq	$56, %rax
	movq	%rax, -8(%rbp)
	movl	$0, -20(%rbp)
	jmp	.L52
.L53:
	movq	-8(%rbp), %rax
	movl	-20(%rbp), %edx
	movq	$0, (%rax,%rdx,8)
	addl	$1, -20(%rbp)
.L52:
	cmpl	$15, -20(%rbp)
	jbe	.L53
	jmp	.L46
.L54:
	nop
.L46:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE14:
	.size	cleanup, .-cleanup
	.local	tv.0
	.comm	tv.0,16,16
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
