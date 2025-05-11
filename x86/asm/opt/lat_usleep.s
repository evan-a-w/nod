	.file	"lat_usleep.c"
	.text
	.globl	bench_usleep
	.type	bench_usleep, @function
bench_usleep:
.LFB72:
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
	je	.L1
.L3:
	movl	0(%rbp), %edi
	call	usleep@PLT
	subq	$1, %rbx
	cmpq	$-1, %rbx
	jne	.L3
.L1:
	addq	$8, %rsp
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE72:
	.size	bench_usleep, .-bench_usleep
	.globl	bench_nanosleep
	.type	bench_nanosleep, @function
bench_nanosleep:
.LFB73:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushq	%rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	subq	$56, %rsp
	.cfi_def_cfa_offset 80
	movq	%fs:40, %rax
	movq	%rax, 40(%rsp)
	xorl	%eax, %eax
	movq	$0, (%rsp)
	imulq	$1000, (%rsi), %rax
	movq	%rax, 8(%rsp)
	testq	%rdi, %rdi
	je	.L6
	leaq	-1(%rdi), %rbp
	leaq	16(%rsp), %rbx
	jmp	.L10
.L8:
	subq	$1, %rbp
	cmpq	$-1, %rbp
	je	.L6
.L10:
	movq	%rsp, %rdi
	movq	%rbx, %rsi
	call	nanosleep@PLT
	testl	%eax, %eax
	jns	.L8
.L9:
	movq	%rbx, %rsi
	movq	%rbx, %rdi
	call	nanosleep@PLT
	testl	%eax, %eax
	js	.L9
	jmp	.L8
.L6:
	movq	40(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L15
	addq	$56, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
.L15:
	.cfi_restore_state
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE73:
	.size	bench_nanosleep, .-bench_nanosleep
	.globl	bench_select
	.type	bench_select, @function
bench_select:
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
	subq	$32, %rsp
	.cfi_def_cfa_offset 64
	movq	%fs:40, %rax
	movq	%rax, 24(%rsp)
	xorl	%eax, %eax
	testq	%rdi, %rdi
	je	.L16
	movq	%rsi, %rbp
	leaq	-1(%rdi), %rbx
	movq	%rsp, %r12
.L18:
	movq	$0, (%rsp)
	movq	0(%rbp), %rax
	movq	%rax, 8(%rsp)
	movq	%r12, %r8
	movl	$0, %ecx
	movl	$0, %edx
	movl	$0, %esi
	movl	$0, %edi
	call	select@PLT
	subq	$1, %rbx
	cmpq	$-1, %rbx
	jne	.L18
.L16:
	movq	24(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L22
	addq	$32, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 32
	popq	%rbx
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	ret
.L22:
	.cfi_restore_state
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE74:
	.size	bench_select, .-bench_select
	.globl	interval
	.type	interval, @function
interval:
.LFB75:
	.cfi_startproc
	endbr64
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	movq	caught(%rip), %rax
	addq	$1, %rax
	movq	%rax, caught(%rip)
	cmpq	n(%rip), %rax
	je	.L26
.L24:
	movl	$0, %edx
	leaq	value(%rip), %rsi
	movl	$0, %edi
	call	setitimer@PLT
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	ret
.L26:
	.cfi_restore_state
	movq	$0, caught(%rip)
	movl	$0, %eax
	call	benchmp_getstate@PLT
	movq	%rax, %rdi
	call	benchmp_interval@PLT
	movq	%rax, n(%rip)
	jmp	.L24
	.cfi_endproc
.LFE75:
	.size	interval, .-interval
	.globl	initialize
	.type	initialize, @function
initialize:
.LFB76:
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
	je	.L31
.L27:
	movq	152(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L32
	addq	$160, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 16
	popq	%rbx
	.cfi_def_cfa_offset 8
	ret
.L31:
	.cfi_restore_state
	movq	$0, value(%rip)
	movq	(%rsi), %rax
	movq	%rax, 8+value(%rip)
	movq	$0, 16+value(%rip)
	movq	(%rsi), %rax
	movq	%rax, 24+value(%rip)
	leaq	interval(%rip), %rax
	movq	%rax, (%rsp)
	movq	%rsp, %rbx
	leaq	8(%rsp), %rdi
	call	sigemptyset@PLT
	movl	$0, 136(%rsp)
	movl	$0, %edx
	movq	%rbx, %rsi
	movl	$14, %edi
	call	sigaction@PLT
	jmp	.L27
.L32:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE76:
	.size	initialize, .-initialize
	.globl	bench_itimer
	.type	bench_itimer, @function
bench_itimer:
.LFB77:
	.cfi_startproc
	endbr64
	pushq	%rax
	.cfi_def_cfa_offset 16
	popq	%rax
	.cfi_def_cfa_offset 8
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	movq	%rdi, n(%rip)
	movq	$0, caught(%rip)
	movl	$0, %edi
	call	start@PLT
	movl	$0, %edx
	leaq	value(%rip), %rsi
	movl	$0, %edi
	call	setitimer@PLT
.L34:
	movl	$100000, %edi
	call	sleep@PLT
	jmp	.L34
	.cfi_endproc
.LFE77:
	.size	bench_itimer, .-bench_itimer
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"sched_setscheduler"
	.text
	.globl	set_realtime
	.type	set_realtime, @function
set_realtime:
.LFB78:
	.cfi_startproc
	endbr64
	subq	$24, %rsp
	.cfi_def_cfa_offset 32
	movq	%fs:40, %rax
	movq	%rax, 8(%rsp)
	xorl	%eax, %eax
	movl	$2, %edi
	call	sched_get_priority_max@PLT
	movl	%eax, 4(%rsp)
	leaq	4(%rsp), %rdx
	movl	$2, %esi
	movl	$0, %edi
	call	sched_setscheduler@PLT
	movl	%eax, %edx
	movl	$1, %eax
	testl	%edx, %edx
	js	.L41
.L36:
	movq	8(%rsp), %rdx
	subq	%fs:40, %rdx
	jne	.L42
	addq	$24, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	ret
.L41:
	.cfi_restore_state
	leaq	.LC0(%rip), %rdi
	call	perror@PLT
	movl	$0, %eax
	jmp	.L36
.L42:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE78:
	.size	set_realtime, .-set_realtime
	.section	.rodata.str1.1
.LC1:
	.string	"nanosleep"
.LC2:
	.string	"usleep"
.LC3:
	.string	"itimer"
.LC4:
	.string	"select"
.LC5:
	.string	""
.LC6:
	.string	"realtime "
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC7:
	.string	"[-r] [-u <method>] [-P <parallelism>] [-W <warmup>] [-N <repetitions>] usecs\nmethod=usleep|nanosleep|select|pselect|itimer\n"
	.section	.rodata.str1.1
.LC8:
	.string	"ru:W:N:"
.LC9:
	.string	"%s%s %lu microseconds"
	.text
	.globl	main
	.type	main, @function
main:
.LFB79:
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
	subq	$584, %rsp
	.cfi_def_cfa_offset 640
	movl	%edi, %ebx
	movq	%rsi, %rbp
	movq	%fs:40, %rax
	movq	%rax, 568(%rsp)
	xorl	%eax, %eax
	leaq	.LC2(%rip), %rax
	movq	%rax, 8(%rsp)
	movl	$0, %r14d
	movl	$-1, 24(%rsp)
	movl	$0, 20(%rsp)
	movl	$1, 16(%rsp)
	movl	$0, 28(%rsp)
	leaq	.LC8(%rip), %r13
	leaq	.L47(%rip), %r12
	jmp	.L44
.L46:
	movq	myoptarg(%rip), %r15
	leaq	.LC2(%rip), %rsi
	movq	%r15, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	je	.L64
	leaq	.LC1(%rip), %rsi
	movq	%r15, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	je	.L65
	leaq	.LC4(%rip), %rsi
	movq	%r15, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	je	.L66
	leaq	.LC3(%rip), %rsi
	movq	%r15, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L73
	leaq	.LC3(%rip), %rax
	movq	%rax, 8(%rsp)
	movl	$4, %r14d
	jmp	.L44
.L73:
	leaq	.LC7(%rip), %rdx
	movq	%rbp, %rsi
	movl	%ebx, %edi
	call	lmbench_usage@PLT
	jmp	.L44
.L50:
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	movl	%eax, 16(%rsp)
	testl	%eax, %eax
	jg	.L44
	leaq	.LC7(%rip), %rdx
	movq	%rbp, %rsi
	movl	%ebx, %edi
	call	lmbench_usage@PLT
	jmp	.L44
.L49:
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	movl	%eax, 20(%rsp)
.L44:
	movq	%r13, %rdx
	movq	%rbp, %rsi
	movl	%ebx, %edi
	call	mygetopt@PLT
	cmpl	$-1, %eax
	je	.L74
	subl	$78, %eax
	cmpl	$39, %eax
	ja	.L45
	movl	%eax, %eax
	movslq	(%r12,%rax,4), %rax
	addq	%r12, %rax
	notrack jmp	*%rax
	.section	.rodata
	.align 4
	.align 4
.L47:
	.long	.L51-.L47
	.long	.L45-.L47
	.long	.L50-.L47
	.long	.L45-.L47
	.long	.L45-.L47
	.long	.L45-.L47
	.long	.L45-.L47
	.long	.L45-.L47
	.long	.L45-.L47
	.long	.L49-.L47
	.long	.L45-.L47
	.long	.L45-.L47
	.long	.L45-.L47
	.long	.L45-.L47
	.long	.L45-.L47
	.long	.L45-.L47
	.long	.L45-.L47
	.long	.L45-.L47
	.long	.L45-.L47
	.long	.L45-.L47
	.long	.L45-.L47
	.long	.L45-.L47
	.long	.L45-.L47
	.long	.L45-.L47
	.long	.L45-.L47
	.long	.L45-.L47
	.long	.L45-.L47
	.long	.L45-.L47
	.long	.L45-.L47
	.long	.L45-.L47
	.long	.L45-.L47
	.long	.L45-.L47
	.long	.L45-.L47
	.long	.L45-.L47
	.long	.L45-.L47
	.long	.L45-.L47
	.long	.L63-.L47
	.long	.L45-.L47
	.long	.L45-.L47
	.long	.L46-.L47
	.text
.L51:
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	movl	%eax, 24(%rsp)
	jmp	.L44
.L45:
	leaq	.LC7(%rip), %rdx
	movq	%rbp, %rsi
	movl	%ebx, %edi
	call	lmbench_usage@PLT
	jmp	.L44
.L63:
	movl	$1, 28(%rsp)
	jmp	.L44
.L64:
	leaq	.LC2(%rip), %rax
	movq	%rax, 8(%rsp)
	movl	$0, %r14d
	jmp	.L44
.L65:
	leaq	.LC1(%rip), %rax
	movq	%rax, 8(%rsp)
	movl	$1, %r14d
	jmp	.L44
.L66:
	leaq	.LC4(%rip), %rax
	movq	%rax, 8(%rsp)
	movl	$2, %r14d
	jmp	.L44
.L74:
	leal	-1(%rbx), %eax
	cmpl	myoptind(%rip), %eax
	jne	.L75
.L53:
	movslq	myoptind(%rip), %rax
	movq	0(%rbp,%rax,8), %rdi
	call	bytes@PLT
	movq	%rax, 40(%rsp)
	leaq	.LC5(%rip), %r12
	cmpl	$0, 28(%rsp)
	jne	.L76
.L54:
	cmpl	$2, %r14d
	je	.L55
	ja	.L56
	testl	%r14d, %r14d
	je	.L77
	leaq	40(%rsp), %rax
	pushq	%rax
	.cfi_def_cfa_offset 648
	movl	32(%rsp), %eax
	pushq	%rax
	.cfi_def_cfa_offset 656
	movl	36(%rsp), %r9d
	movl	32(%rsp), %r8d
	movl	$0, %ecx
	movl	$0, %edx
	leaq	bench_nanosleep(%rip), %rsi
	movl	$0, %edi
	call	benchmp@PLT
	addq	$16, %rsp
	.cfi_def_cfa_offset 640
	jmp	.L61
.L75:
	leaq	.LC7(%rip), %rdx
	movq	%rbp, %rsi
	movl	%ebx, %edi
	call	lmbench_usage@PLT
	jmp	.L53
.L76:
	movl	$0, %eax
	call	set_realtime
	testl	%eax, %eax
	leaq	.LC6(%rip), %rax
	cmovne	%rax, %r12
	jmp	.L54
.L56:
	cmpl	$4, %r14d
	jne	.L78
	leaq	40(%rsp), %rax
	pushq	%rax
	.cfi_def_cfa_offset 648
	movl	32(%rsp), %eax
	pushq	%rax
	.cfi_def_cfa_offset 656
	movl	36(%rsp), %r9d
	movl	32(%rsp), %r8d
	movl	$0, %ecx
	movl	$0, %edx
	leaq	bench_itimer(%rip), %rsi
	leaq	initialize(%rip), %rdi
	call	benchmp@PLT
	addq	$16, %rsp
	.cfi_def_cfa_offset 640
	jmp	.L61
.L77:
	leaq	40(%rsp), %rax
	pushq	%rax
	.cfi_def_cfa_offset 648
	movl	32(%rsp), %eax
	pushq	%rax
	.cfi_def_cfa_offset 656
	movl	36(%rsp), %r9d
	movl	32(%rsp), %r8d
	movl	$0, %ecx
	movl	$0, %edx
	leaq	bench_usleep(%rip), %rsi
	movl	$0, %edi
	call	benchmp@PLT
	addq	$16, %rsp
	.cfi_def_cfa_offset 640
.L61:
	leaq	48(%rsp), %rbx
	subq	$8, %rsp
	.cfi_def_cfa_offset 648
	pushq	48(%rsp)
	.cfi_def_cfa_offset 656
	movq	24(%rsp), %r9
	movq	%r12, %r8
	leaq	.LC9(%rip), %rcx
	movl	$512, %edx
	movl	$1, %esi
	movq	%rbx, %rdi
	movl	$0, %eax
	call	__sprintf_chk@PLT
	call	get_n@PLT
	movq	%rax, %rsi
	movq	%rbx, %rdi
	call	micro@PLT
	addq	$16, %rsp
	.cfi_def_cfa_offset 640
	movq	568(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L79
	movl	$0, %eax
	addq	$584, %rsp
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
	leaq	40(%rsp), %rax
	pushq	%rax
	.cfi_def_cfa_offset 648
	movl	32(%rsp), %eax
	pushq	%rax
	.cfi_def_cfa_offset 656
	movl	36(%rsp), %r9d
	movl	32(%rsp), %r8d
	movl	$0, %ecx
	movl	$0, %edx
	leaq	bench_select(%rip), %rsi
	movl	$0, %edi
	call	benchmp@PLT
	addq	$16, %rsp
	.cfi_def_cfa_offset 640
	jmp	.L61
.L78:
	leaq	.LC7(%rip), %rdx
	movq	%rbp, %rsi
	movl	%ebx, %edi
	call	lmbench_usage@PLT
	jmp	.L61
.L79:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE79:
	.size	main, .-main
	.globl	value
	.bss
	.align 32
	.type	value, @object
	.size	value, 32
value:
	.zero	32
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
.LC10:
	.string	"$Id$\n"
	.section	.data.rel.local,"aw"
	.align 8
	.type	id, @object
	.size	id, 8
id:
	.quad	.LC10
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
