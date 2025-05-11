	.file	"lat_syscall.c"
	.text
	.globl	do_getppid
	.type	do_getppid, @function
do_getppid:
.LFB72:
	.cfi_startproc
	endbr64
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	leaq	-1(%rdi), %rbx
	testq	%rdi, %rdi
	je	.L1
.L3:
	call	getppid@PLT
	subq	$1, %rbx
	cmpq	$-1, %rbx
	jne	.L3
.L1:
	popq	%rbx
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE72:
	.size	do_getppid, .-do_getppid
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"/dev/null"
	.text
	.globl	do_write
	.type	do_write, @function
do_write:
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
	subq	$16, %rsp
	.cfi_def_cfa_offset 48
	movq	%rdi, %rbx
	movq	%rsi, %rbp
	movq	%fs:40, %rax
	movq	%rax, 8(%rsp)
	xorl	%eax, %eax
	leaq	7(%rsp), %r12
.L7:
	testq	%rbx, %rbx
	je	.L6
	movl	$1, %edx
	movq	%r12, %rsi
	movl	0(%rbp), %edi
	call	write@PLT
	subq	$1, %rbx
	cmpq	$1, %rax
	je	.L7
	leaq	.LC0(%rip), %rdi
	call	perror@PLT
.L6:
	movq	8(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L13
	addq	$16, %rsp
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
.LFE73:
	.size	do_write, .-do_write
	.section	.rodata.str1.1
.LC1:
	.string	"/dev/zero"
	.text
	.globl	do_read
	.type	do_read, @function
do_read:
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
	movq	%rdi, %rbx
	movq	%rsi, %rbp
	movq	%fs:40, %rax
	movq	%rax, 8(%rsp)
	xorl	%eax, %eax
	leaq	7(%rsp), %r12
.L15:
	testq	%rbx, %rbx
	je	.L14
	movl	$1, %edx
	movq	%r12, %rsi
	movl	0(%rbp), %edi
	call	read@PLT
	subq	$1, %rbx
	cmpq	$1, %rax
	je	.L15
	leaq	.LC1(%rip), %rdi
	call	perror@PLT
.L14:
	movq	8(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L21
	addq	$16, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 32
	popq	%rbx
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	ret
.L21:
	.cfi_restore_state
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE74:
	.size	do_read, .-do_read
	.globl	do_stat
	.type	do_stat, @function
do_stat:
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
	subq	$160, %rsp
	.cfi_def_cfa_offset 192
	movq	%rdi, %rbx
	movq	%rsi, %rbp
	movq	%fs:40, %rax
	movq	%rax, 152(%rsp)
	xorl	%eax, %eax
	movq	%rsp, %r12
.L23:
	testq	%rbx, %rbx
	je	.L22
	movq	8(%rbp), %rdi
	movq	%r12, %rsi
	call	stat@PLT
	subq	$1, %rbx
	cmpl	$-1, %eax
	jne	.L23
	movq	8(%rbp), %rdi
	call	perror@PLT
.L22:
	movq	152(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L29
	addq	$160, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 32
	popq	%rbx
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	ret
.L29:
	.cfi_restore_state
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE75:
	.size	do_stat, .-do_stat
	.section	.rodata.str1.1
.LC2:
	.string	"fstat"
	.text
	.globl	do_fstat
	.type	do_fstat, @function
do_fstat:
.LFB76:
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
	subq	$160, %rsp
	.cfi_def_cfa_offset 192
	movq	%rdi, %rbx
	movq	%rsi, %rbp
	movq	%fs:40, %rax
	movq	%rax, 152(%rsp)
	xorl	%eax, %eax
	movq	%rsp, %r12
.L31:
	testq	%rbx, %rbx
	je	.L30
	movq	%r12, %rsi
	movl	0(%rbp), %edi
	call	fstat@PLT
	subq	$1, %rbx
	cmpl	$-1, %eax
	jne	.L31
	leaq	.LC2(%rip), %rdi
	call	perror@PLT
.L30:
	movq	152(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L37
	addq	$160, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 32
	popq	%rbx
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	ret
.L37:
	.cfi_restore_state
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE76:
	.size	do_fstat, .-do_fstat
	.globl	do_openclose
	.type	do_openclose, @function
do_openclose:
.LFB77:
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
	je	.L38
.L41:
	movq	8(%rbp), %rdi
	movl	$0, %esi
	movl	$0, %eax
	call	open@PLT
	movl	%eax, %edi
	cmpl	$-1, %eax
	je	.L44
	call	close@PLT
	subq	$1, %rbx
	cmpq	$-1, %rbx
	jne	.L41
	jmp	.L38
.L44:
	movq	8(%rbp), %rdi
	call	perror@PLT
.L38:
	addq	$8, %rsp
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE77:
	.size	do_openclose, .-do_openclose
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC3:
	.string	"[-P <parallelism>] [-W <warmup>] [-N <repetitions>] null|read|write|stat|fstat|open [file]\n"
	.section	.rodata.str1.1
.LC4:
	.string	"P:W:N:"
.LC5:
	.string	"/usr/include/sys/types.h"
.LC6:
	.string	"null"
.LC7:
	.string	"Simple syscall"
.LC8:
	.string	"write"
.LC9:
	.string	"Simple write"
.LC10:
	.string	"read"
.LC11:
	.string	"Simple read: -1\n"
.LC12:
	.string	"Simple read"
.LC13:
	.string	"stat"
.LC14:
	.string	"Simple stat"
.LC15:
	.string	"Simple fstat"
.LC16:
	.string	"open"
.LC17:
	.string	"Simple open/close"
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
	subq	$56, %rsp
	.cfi_def_cfa_offset 112
	movl	%edi, %ebx
	movq	%rsi, %rbp
	movq	%fs:40, %rax
	movq	%rax, 40(%rsp)
	xorl	%eax, %eax
	movl	$-1, %r14d
	movl	$0, %r13d
	movl	$1, 12(%rsp)
	leaq	.LC4(%rip), %r12
	leaq	.LC3(%rip), %r15
	jmp	.L46
.L47:
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	movl	%eax, 12(%rsp)
	testl	%eax, %eax
	jg	.L46
	movq	%r15, %rdx
	movq	%rbp, %rsi
	movl	%ebx, %edi
	call	lmbench_usage@PLT
	jmp	.L46
.L48:
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	movl	%eax, %r13d
.L46:
	movq	%r12, %rdx
	movq	%rbp, %rsi
	movl	%ebx, %edi
	call	mygetopt@PLT
	cmpl	$-1, %eax
	je	.L66
	cmpl	$80, %eax
	je	.L47
	cmpl	$87, %eax
	je	.L48
	cmpl	$78, %eax
	je	.L67
	movq	%r15, %rdx
	movq	%rbp, %rsi
	movl	%ebx, %edi
	call	lmbench_usage@PLT
	jmp	.L46
.L67:
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	movl	%eax, %r14d
	jmp	.L46
.L66:
	movl	myoptind(%rip), %eax
	leal	-1(%rbx), %edx
	cmpl	%eax, %edx
	je	.L53
	leal	-2(%rbx), %edx
	cmpl	%edx, %eax
	jne	.L68
.L53:
	leaq	.LC5(%rip), %rax
	movq	%rax, 24(%rsp)
	movl	myoptind(%rip), %eax
	leal	-2(%rbx), %edx
	cmpl	%eax, %edx
	je	.L69
.L54:
	cltq
	movq	0(%rbp,%rax,8), %r15
	movq	%r15, %rsi
	leaq	.LC6(%rip), %rdi
	call	strcmp@PLT
	movl	%eax, %r12d
	testl	%eax, %eax
	je	.L70
	movq	%r15, %rsi
	leaq	.LC8(%rip), %rdi
	call	strcmp@PLT
	movl	%eax, %r12d
	testl	%eax, %eax
	je	.L71
	movq	%r15, %rsi
	leaq	.LC10(%rip), %rdi
	call	strcmp@PLT
	movl	%eax, %r12d
	testl	%eax, %eax
	je	.L72
	movq	%r15, %rsi
	leaq	.LC13(%rip), %rdi
	call	strcmp@PLT
	movl	%eax, %r12d
	testl	%eax, %eax
	je	.L73
	movq	%r15, %rsi
	leaq	.LC2(%rip), %rdi
	call	strcmp@PLT
	movl	%eax, %r12d
	testl	%eax, %eax
	je	.L74
	movq	%r15, %rsi
	leaq	.LC16(%rip), %rdi
	call	strcmp@PLT
	movl	%eax, %r12d
	testl	%eax, %eax
	jne	.L62
	leaq	16(%rsp), %rax
	pushq	%rax
	.cfi_def_cfa_offset 120
	pushq	%r14
	.cfi_def_cfa_offset 128
	movl	%r13d, %r9d
	movl	28(%rsp), %r8d
	movl	$0, %ecx
	movl	$0, %edx
	leaq	do_openclose(%rip), %rsi
	movl	$0, %edi
	call	benchmp@PLT
	call	get_n@PLT
	movq	%rax, %rsi
	leaq	.LC17(%rip), %rdi
	call	micro@PLT
	addq	$16, %rsp
	.cfi_def_cfa_offset 112
	jmp	.L45
.L68:
	leaq	.LC3(%rip), %rdx
	movq	%rbp, %rsi
	movl	%ebx, %edi
	call	lmbench_usage@PLT
	jmp	.L53
.L69:
	movslq	%eax, %rdx
	movq	8(%rbp,%rdx,8), %rdx
	movq	%rdx, 24(%rsp)
	jmp	.L54
.L70:
	leaq	16(%rsp), %rax
	pushq	%rax
	.cfi_def_cfa_offset 120
	pushq	%r14
	.cfi_def_cfa_offset 128
	movl	%r13d, %r9d
	movl	28(%rsp), %r8d
	movl	$0, %ecx
	movl	$0, %edx
	leaq	do_getppid(%rip), %rsi
	movl	$0, %edi
	call	benchmp@PLT
	call	get_n@PLT
	movq	%rax, %rsi
	leaq	.LC7(%rip), %rdi
	call	micro@PLT
	addq	$16, %rsp
	.cfi_def_cfa_offset 112
.L45:
	movq	40(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L75
	movl	%r12d, %eax
	addq	$56, %rsp
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
.L71:
	.cfi_restore_state
	movl	$1, %esi
	leaq	.LC0(%rip), %rdi
	movl	$0, %eax
	call	open@PLT
	movl	%eax, 16(%rsp)
	leaq	16(%rsp), %rax
	pushq	%rax
	.cfi_def_cfa_offset 120
	pushq	%r14
	.cfi_def_cfa_offset 128
	movl	%r13d, %r9d
	movl	28(%rsp), %r8d
	movl	$0, %ecx
	movl	$0, %edx
	leaq	do_write(%rip), %rsi
	movl	$0, %edi
	call	benchmp@PLT
	call	get_n@PLT
	movq	%rax, %rsi
	leaq	.LC9(%rip), %rdi
	call	micro@PLT
	movl	32(%rsp), %edi
	call	close@PLT
	addq	$16, %rsp
	.cfi_def_cfa_offset 112
	jmp	.L45
.L72:
	movl	$0, %esi
	leaq	.LC1(%rip), %rdi
	movl	$0, %eax
	call	open@PLT
	movl	%eax, 16(%rsp)
	cmpl	$-1, %eax
	je	.L76
	leaq	16(%rsp), %rax
	pushq	%rax
	.cfi_def_cfa_offset 120
	pushq	%r14
	.cfi_def_cfa_offset 128
	movl	%r13d, %r9d
	movl	28(%rsp), %r8d
	movl	$0, %ecx
	movl	$0, %edx
	leaq	do_read(%rip), %rsi
	movl	$0, %edi
	call	benchmp@PLT
	call	get_n@PLT
	movq	%rax, %rsi
	leaq	.LC12(%rip), %rdi
	call	micro@PLT
	movl	32(%rsp), %edi
	call	close@PLT
	addq	$16, %rsp
	.cfi_def_cfa_offset 112
	jmp	.L45
.L76:
	movq	stderr(%rip), %rcx
	movl	$16, %edx
	movl	$1, %esi
	leaq	.LC11(%rip), %rdi
	call	fwrite@PLT
	movl	$1, %r12d
	jmp	.L45
.L73:
	leaq	16(%rsp), %rax
	pushq	%rax
	.cfi_def_cfa_offset 120
	pushq	%r14
	.cfi_def_cfa_offset 128
	movl	%r13d, %r9d
	movl	28(%rsp), %r8d
	movl	$0, %ecx
	movl	$0, %edx
	leaq	do_stat(%rip), %rsi
	movl	$0, %edi
	call	benchmp@PLT
	call	get_n@PLT
	movq	%rax, %rsi
	leaq	.LC14(%rip), %rdi
	call	micro@PLT
	addq	$16, %rsp
	.cfi_def_cfa_offset 112
	jmp	.L45
.L74:
	movl	$0, %esi
	movq	24(%rsp), %rdi
	movl	$0, %eax
	call	open@PLT
	movl	%eax, 16(%rsp)
	leaq	16(%rsp), %rax
	pushq	%rax
	.cfi_def_cfa_offset 120
	pushq	%r14
	.cfi_def_cfa_offset 128
	movl	%r13d, %r9d
	movl	28(%rsp), %r8d
	movl	$0, %ecx
	movl	$0, %edx
	leaq	do_fstat(%rip), %rsi
	movl	$0, %edi
	call	benchmp@PLT
	call	get_n@PLT
	movq	%rax, %rsi
	leaq	.LC15(%rip), %rdi
	call	micro@PLT
	movl	32(%rsp), %edi
	call	close@PLT
	addq	$16, %rsp
	.cfi_def_cfa_offset 112
	jmp	.L45
.L62:
	leaq	.LC3(%rip), %rdx
	movq	%rbp, %rsi
	movl	%ebx, %edi
	call	lmbench_usage@PLT
	movl	$0, %r12d
	jmp	.L45
.L75:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE78:
	.size	main, .-main
	.globl	id
	.section	.rodata.str1.8
	.align 8
.LC18:
	.string	"$Id: s.lat_syscall.c 1.11 97/06/15 22:38:58-07:00 lm $\n"
	.section	.data.rel.local,"aw"
	.align 8
	.type	id, @object
	.size	id, 8
id:
	.quad	.LC18
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
