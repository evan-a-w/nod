	.file	"lat_syscall.c"
	.text
	.globl	id
	.section	.rodata
	.align 8
.LC0:
	.string	"$Id: s.lat_syscall.c 1.11 97/06/15 22:38:58-07:00 lm $\n"
	.section	.data.rel.local,"aw"
	.align 8
	.type	id, @object
	.size	id, 8
id:
	.quad	.LC0
	.text
	.globl	do_getppid
	.type	do_getppid, @function
do_getppid:
.LFB8:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	jmp	.L2
.L3:
	call	getppid@PLT
.L2:
	movq	-8(%rbp), %rax
	leaq	-1(%rax), %rdx
	movq	%rdx, -8(%rbp)
	testq	%rax, %rax
	jne	.L3
	nop
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE8:
	.size	do_getppid, .-do_getppid
	.section	.rodata
.LC1:
	.string	"/dev/null"
	.text
	.globl	do_write
	.type	do_write, @function
do_write:
.LFB9:
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
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movq	-48(%rbp), %rax
	movq	%rax, -16(%rbp)
	jmp	.L5
.L7:
	movq	-16(%rbp), %rax
	movl	(%rax), %eax
	leaq	-17(%rbp), %rcx
	movl	$1, %edx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	write@PLT
	cmpq	$1, %rax
	je	.L5
	leaq	.LC1(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	jmp	.L4
.L5:
	movq	-40(%rbp), %rax
	leaq	-1(%rax), %rdx
	movq	%rdx, -40(%rbp)
	testq	%rax, %rax
	jne	.L7
.L4:
	movq	-8(%rbp), %rax
	subq	%fs:40, %rax
	je	.L8
	call	__stack_chk_fail@PLT
.L8:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE9:
	.size	do_write, .-do_write
	.section	.rodata
.LC2:
	.string	"/dev/zero"
	.text
	.globl	do_read
	.type	do_read, @function
do_read:
.LFB10:
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
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movq	-48(%rbp), %rax
	movq	%rax, -16(%rbp)
	jmp	.L10
.L12:
	movq	-16(%rbp), %rax
	movl	(%rax), %eax
	leaq	-17(%rbp), %rcx
	movl	$1, %edx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	read@PLT
	cmpq	$1, %rax
	je	.L10
	leaq	.LC2(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	jmp	.L9
.L10:
	movq	-40(%rbp), %rax
	leaq	-1(%rax), %rdx
	movq	%rdx, -40(%rbp)
	testq	%rax, %rax
	jne	.L12
.L9:
	movq	-8(%rbp), %rax
	subq	%fs:40, %rax
	je	.L13
	call	__stack_chk_fail@PLT
.L13:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE10:
	.size	do_read, .-do_read
	.globl	do_stat
	.type	do_stat, @function
do_stat:
.LFB11:
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
	jmp	.L15
.L17:
	movq	-168(%rbp), %rax
	movq	8(%rax), %rax
	leaq	-160(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	stat@PLT
	cmpl	$-1, %eax
	jne	.L15
	movq	-168(%rbp), %rax
	movq	8(%rax), %rax
	movq	%rax, %rdi
	call	perror@PLT
	jmp	.L14
.L15:
	movq	-184(%rbp), %rax
	leaq	-1(%rax), %rdx
	movq	%rdx, -184(%rbp)
	testq	%rax, %rax
	jne	.L17
.L14:
	movq	-8(%rbp), %rax
	subq	%fs:40, %rax
	je	.L18
	call	__stack_chk_fail@PLT
.L18:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE11:
	.size	do_stat, .-do_stat
	.section	.rodata
.LC3:
	.string	"fstat"
	.text
	.globl	do_fstat
	.type	do_fstat, @function
do_fstat:
.LFB12:
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
	jmp	.L20
.L22:
	movq	-168(%rbp), %rax
	movl	(%rax), %eax
	leaq	-160(%rbp), %rdx
	movq	%rdx, %rsi
	movl	%eax, %edi
	call	fstat@PLT
	cmpl	$-1, %eax
	jne	.L20
	leaq	.LC3(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	jmp	.L19
.L20:
	movq	-184(%rbp), %rax
	leaq	-1(%rax), %rdx
	movq	%rdx, -184(%rbp)
	testq	%rax, %rax
	jne	.L22
.L19:
	movq	-8(%rbp), %rax
	subq	%fs:40, %rax
	je	.L23
	call	__stack_chk_fail@PLT
.L23:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE12:
	.size	do_fstat, .-do_fstat
	.globl	do_openclose
	.type	do_openclose, @function
do_openclose:
.LFB13:
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
	jmp	.L25
.L28:
	movq	-8(%rbp), %rax
	movq	8(%rax), %rax
	movl	$0, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	open@PLT
	movl	%eax, -12(%rbp)
	cmpl	$-1, -12(%rbp)
	jne	.L26
	movq	-8(%rbp), %rax
	movq	8(%rax), %rax
	movq	%rax, %rdi
	call	perror@PLT
	jmp	.L24
.L26:
	movl	-12(%rbp), %eax
	movl	%eax, %edi
	call	close@PLT
.L25:
	movq	-24(%rbp), %rax
	leaq	-1(%rax), %rdx
	movq	%rdx, -24(%rbp)
	testq	%rax, %rax
	jne	.L28
.L24:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE13:
	.size	do_openclose, .-do_openclose
	.section	.rodata
	.align 8
.LC4:
	.string	"[-P <parallelism>] [-W <warmup>] [-N <repetitions>] null|read|write|stat|fstat|open [file]\n"
.LC5:
	.string	"P:W:N:"
.LC6:
	.string	"/usr/include/sys/types.h"
.LC7:
	.string	"null"
.LC8:
	.string	"Simple syscall"
.LC9:
	.string	"write"
.LC10:
	.string	"Simple write"
.LC11:
	.string	"read"
.LC12:
	.string	"Simple read: -1\n"
.LC13:
	.string	"Simple read"
.LC14:
	.string	"stat"
.LC15:
	.string	"Simple stat"
.LC16:
	.string	"Simple fstat"
.LC17:
	.string	"open"
.LC18:
	.string	"Simple open/close"
	.text
	.globl	main
	.type	main, @function
main:
.LFB14:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$80, %rsp
	movl	%edi, -68(%rbp)
	movq	%rsi, -80(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movl	$1, -56(%rbp)
	movl	$0, -52(%rbp)
	movl	$-1, -48(%rbp)
	leaq	.LC4(%rip), %rax
	movq	%rax, -40(%rbp)
	jmp	.L30
.L35:
	cmpl	$87, -44(%rbp)
	je	.L31
	cmpl	$87, -44(%rbp)
	jg	.L32
	cmpl	$78, -44(%rbp)
	je	.L33
	cmpl	$80, -44(%rbp)
	jne	.L32
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -56(%rbp)
	cmpl	$0, -56(%rbp)
	jg	.L30
	movq	-40(%rbp), %rdx
	movq	-80(%rbp), %rcx
	movl	-68(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	lmbench_usage@PLT
	jmp	.L30
.L31:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -52(%rbp)
	jmp	.L30
.L33:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -48(%rbp)
	jmp	.L30
.L32:
	movq	-40(%rbp), %rdx
	movq	-80(%rbp), %rcx
	movl	-68(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	lmbench_usage@PLT
	nop
.L30:
	movq	-80(%rbp), %rcx
	movl	-68(%rbp), %eax
	leaq	.LC5(%rip), %rdx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	mygetopt@PLT
	movl	%eax, -44(%rbp)
	cmpl	$-1, -44(%rbp)
	jne	.L35
	movl	-68(%rbp), %eax
	leal	-1(%rax), %edx
	movl	myoptind(%rip), %eax
	cmpl	%eax, %edx
	je	.L36
	movl	-68(%rbp), %eax
	leal	-2(%rax), %edx
	movl	myoptind(%rip), %eax
	cmpl	%eax, %edx
	je	.L36
	movq	-40(%rbp), %rdx
	movq	-80(%rbp), %rcx
	movl	-68(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	lmbench_usage@PLT
.L36:
	leaq	.LC6(%rip), %rax
	movq	%rax, -24(%rbp)
	movl	-68(%rbp), %eax
	leal	-2(%rax), %edx
	movl	myoptind(%rip), %eax
	cmpl	%eax, %edx
	jne	.L37
	movl	myoptind(%rip), %eax
	cltq
	addq	$1, %rax
	leaq	0(,%rax,8), %rdx
	movq	-80(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	%rax, -24(%rbp)
.L37:
	movl	myoptind(%rip), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-80(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	%rax, %rsi
	leaq	.LC7(%rip), %rax
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L38
	movl	-52(%rbp), %ecx
	movl	-56(%rbp), %edx
	leaq	-32(%rbp), %rax
	pushq	%rax
	movl	-48(%rbp), %eax
	pushq	%rax
	movl	%ecx, %r9d
	movl	%edx, %r8d
	movl	$0, %ecx
	movl	$0, %edx
	leaq	do_getppid(%rip), %rax
	movq	%rax, %rsi
	movl	$0, %edi
	call	benchmp@PLT
	addq	$16, %rsp
	call	get_n@PLT
	movq	%rax, %rsi
	leaq	.LC8(%rip), %rax
	movq	%rax, %rdi
	call	micro@PLT
	jmp	.L39
.L38:
	movl	myoptind(%rip), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-80(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	%rax, %rsi
	leaq	.LC9(%rip), %rax
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L40
	movl	$1, %esi
	leaq	.LC1(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	open@PLT
	movl	%eax, -32(%rbp)
	movl	-52(%rbp), %ecx
	movl	-56(%rbp), %edx
	leaq	-32(%rbp), %rax
	pushq	%rax
	movl	-48(%rbp), %eax
	pushq	%rax
	movl	%ecx, %r9d
	movl	%edx, %r8d
	movl	$0, %ecx
	movl	$0, %edx
	leaq	do_write(%rip), %rax
	movq	%rax, %rsi
	movl	$0, %edi
	call	benchmp@PLT
	addq	$16, %rsp
	call	get_n@PLT
	movq	%rax, %rsi
	leaq	.LC10(%rip), %rax
	movq	%rax, %rdi
	call	micro@PLT
	movl	-32(%rbp), %eax
	movl	%eax, %edi
	call	close@PLT
	jmp	.L39
.L40:
	movl	myoptind(%rip), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-80(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	%rax, %rsi
	leaq	.LC11(%rip), %rax
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L41
	movl	$0, %esi
	leaq	.LC2(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	open@PLT
	movl	%eax, -32(%rbp)
	movl	-32(%rbp), %eax
	cmpl	$-1, %eax
	jne	.L42
	movq	stderr(%rip), %rax
	movq	%rax, %rcx
	movl	$16, %edx
	movl	$1, %esi
	leaq	.LC12(%rip), %rax
	movq	%rax, %rdi
	call	fwrite@PLT
	movl	$1, %eax
	jmp	.L47
.L42:
	movl	-52(%rbp), %ecx
	movl	-56(%rbp), %edx
	leaq	-32(%rbp), %rax
	pushq	%rax
	movl	-48(%rbp), %eax
	pushq	%rax
	movl	%ecx, %r9d
	movl	%edx, %r8d
	movl	$0, %ecx
	movl	$0, %edx
	leaq	do_read(%rip), %rax
	movq	%rax, %rsi
	movl	$0, %edi
	call	benchmp@PLT
	addq	$16, %rsp
	call	get_n@PLT
	movq	%rax, %rsi
	leaq	.LC13(%rip), %rax
	movq	%rax, %rdi
	call	micro@PLT
	movl	-32(%rbp), %eax
	movl	%eax, %edi
	call	close@PLT
	jmp	.L39
.L41:
	movl	myoptind(%rip), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-80(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	%rax, %rsi
	leaq	.LC14(%rip), %rax
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L44
	movl	-52(%rbp), %ecx
	movl	-56(%rbp), %edx
	leaq	-32(%rbp), %rax
	pushq	%rax
	movl	-48(%rbp), %eax
	pushq	%rax
	movl	%ecx, %r9d
	movl	%edx, %r8d
	movl	$0, %ecx
	movl	$0, %edx
	leaq	do_stat(%rip), %rax
	movq	%rax, %rsi
	movl	$0, %edi
	call	benchmp@PLT
	addq	$16, %rsp
	call	get_n@PLT
	movq	%rax, %rsi
	leaq	.LC15(%rip), %rax
	movq	%rax, %rdi
	call	micro@PLT
	jmp	.L39
.L44:
	movl	myoptind(%rip), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-80(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	%rax, %rsi
	leaq	.LC3(%rip), %rax
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L45
	movq	-24(%rbp), %rax
	movl	$0, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	open@PLT
	movl	%eax, -32(%rbp)
	movl	-52(%rbp), %ecx
	movl	-56(%rbp), %edx
	leaq	-32(%rbp), %rax
	pushq	%rax
	movl	-48(%rbp), %eax
	pushq	%rax
	movl	%ecx, %r9d
	movl	%edx, %r8d
	movl	$0, %ecx
	movl	$0, %edx
	leaq	do_fstat(%rip), %rax
	movq	%rax, %rsi
	movl	$0, %edi
	call	benchmp@PLT
	addq	$16, %rsp
	call	get_n@PLT
	movq	%rax, %rsi
	leaq	.LC16(%rip), %rax
	movq	%rax, %rdi
	call	micro@PLT
	movl	-32(%rbp), %eax
	movl	%eax, %edi
	call	close@PLT
	jmp	.L39
.L45:
	movl	myoptind(%rip), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-80(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	%rax, %rsi
	leaq	.LC17(%rip), %rax
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L46
	movl	-52(%rbp), %ecx
	movl	-56(%rbp), %edx
	leaq	-32(%rbp), %rax
	pushq	%rax
	movl	-48(%rbp), %eax
	pushq	%rax
	movl	%ecx, %r9d
	movl	%edx, %r8d
	movl	$0, %ecx
	movl	$0, %edx
	leaq	do_openclose(%rip), %rax
	movq	%rax, %rsi
	movl	$0, %edi
	call	benchmp@PLT
	addq	$16, %rsp
	call	get_n@PLT
	movq	%rax, %rsi
	leaq	.LC18(%rip), %rax
	movq	%rax, %rdi
	call	micro@PLT
	jmp	.L39
.L46:
	movq	-40(%rbp), %rdx
	movq	-80(%rbp), %rcx
	movl	-68(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	lmbench_usage@PLT
.L39:
	movl	$0, %eax
.L47:
	movq	-8(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L48
	call	__stack_chk_fail@PLT
.L48:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE14:
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
