	.file	"lat_usleep.c"
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
	.globl	value
	.align 32
	.type	value, @object
	.size	value, 32
value:
	.zero	32
	.text
	.globl	bench_usleep
	.type	bench_usleep, @function
bench_usleep:
.LFB8:
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
	jmp	.L2
.L3:
	movq	-8(%rbp), %rax
	movq	(%rax), %rax
	movl	%eax, %edi
	call	usleep@PLT
.L2:
	movq	-24(%rbp), %rax
	leaq	-1(%rax), %rdx
	movq	%rdx, -24(%rbp)
	testq	%rax, %rax
	jne	.L3
	nop
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE8:
	.size	bench_usleep, .-bench_usleep
	.globl	bench_nanosleep
	.type	bench_nanosleep, @function
bench_nanosleep:
.LFB9:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$80, %rsp
	movq	%rdi, -72(%rbp)
	movq	%rsi, -80(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movq	-80(%rbp), %rax
	movq	%rax, -56(%rbp)
	movq	$0, -48(%rbp)
	movq	-56(%rbp), %rax
	movq	(%rax), %rax
	imulq	$1000, %rax, %rax
	movq	%rax, -40(%rbp)
	jmp	.L5
.L7:
	leaq	-32(%rbp), %rdx
	leaq	-48(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	nanosleep@PLT
	testl	%eax, %eax
	jns	.L5
	nop
.L6:
	leaq	-32(%rbp), %rdx
	leaq	-32(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	nanosleep@PLT
	testl	%eax, %eax
	js	.L6
.L5:
	movq	-72(%rbp), %rax
	leaq	-1(%rax), %rdx
	movq	%rdx, -72(%rbp)
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
.LFE9:
	.size	bench_nanosleep, .-bench_nanosleep
	.globl	bench_select
	.type	bench_select, @function
bench_select:
.LFB10:
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
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movq	-64(%rbp), %rax
	movq	%rax, -40(%rbp)
	jmp	.L10
.L11:
	movq	$0, -32(%rbp)
	movq	-40(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -24(%rbp)
	leaq	-32(%rbp), %rax
	movq	%rax, %r8
	movl	$0, %ecx
	movl	$0, %edx
	movl	$0, %esi
	movl	$0, %edi
	call	select@PLT
.L10:
	movq	-56(%rbp), %rax
	leaq	-1(%rax), %rdx
	movq	%rdx, -56(%rbp)
	testq	%rax, %rax
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
.LFE10:
	.size	bench_select, .-bench_select
	.globl	interval
	.type	interval, @function
interval:
.LFB11:
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
	jne	.L14
	movq	$0, caught(%rip)
	movl	$0, %eax
	call	benchmp_getstate@PLT
	movq	%rax, %rdi
	call	benchmp_interval@PLT
	movq	%rax, n(%rip)
.L14:
	movl	$0, %edx
	leaq	value(%rip), %rax
	movq	%rax, %rsi
	movl	$0, %edi
	call	setitimer@PLT
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE11:
	.size	interval, .-interval
	.globl	initialize
	.type	initialize, @function
initialize:
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
	cmpq	$0, -184(%rbp)
	jne	.L19
	movq	$0, value(%rip)
	movq	-168(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, 8+value(%rip)
	movq	$0, 16+value(%rip)
	movq	-168(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, 24+value(%rip)
	leaq	interval(%rip), %rax
	movq	%rax, -160(%rbp)
	leaq	-160(%rbp), %rax
	addq	$8, %rax
	movq	%rax, %rdi
	call	sigemptyset@PLT
	movl	$0, -24(%rbp)
	leaq	-160(%rbp), %rax
	movl	$0, %edx
	movq	%rax, %rsi
	movl	$14, %edi
	call	sigaction@PLT
	jmp	.L15
.L19:
	nop
.L15:
	movq	-8(%rbp), %rax
	subq	%fs:40, %rax
	je	.L18
	call	__stack_chk_fail@PLT
.L18:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE12:
	.size	initialize, .-initialize
	.globl	bench_itimer
	.type	bench_itimer, @function
bench_itimer:
.LFB13:
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
	movq	-8(%rbp), %rax
	movq	%rax, n(%rip)
	movq	$0, caught(%rip)
	movl	$0, %edi
	call	start@PLT
	movl	$0, %edx
	leaq	value(%rip), %rax
	movq	%rax, %rsi
	movl	$0, %edi
	call	setitimer@PLT
.L21:
	movl	$100000, %edi
	call	sleep@PLT
	jmp	.L21
	.cfi_endproc
.LFE13:
	.size	bench_itimer, .-bench_itimer
	.section	.rodata
.LC1:
	.string	"sched_setscheduler"
	.text
	.globl	set_realtime
	.type	set_realtime, @function
set_realtime:
.LFB14:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movl	$2, %edi
	call	sched_get_priority_max@PLT
	movl	%eax, -12(%rbp)
	leaq	-12(%rbp), %rax
	movq	%rax, %rdx
	movl	$2, %esi
	movl	$0, %edi
	call	sched_setscheduler@PLT
	testl	%eax, %eax
	js	.L23
	movl	$1, %eax
	jmp	.L25
.L23:
	leaq	.LC1(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$0, %eax
.L25:
	movq	-8(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L26
	call	__stack_chk_fail@PLT
.L26:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE14:
	.size	set_realtime, .-set_realtime
	.section	.rodata
.LC2:
	.string	""
.LC3:
	.string	"usleep"
	.align 8
.LC4:
	.string	"[-r] [-u <method>] [-P <parallelism>] [-W <warmup>] [-N <repetitions>] usecs\nmethod=usleep|nanosleep|select|pselect|itimer\n"
.LC5:
	.string	"nanosleep"
.LC6:
	.string	"select"
.LC7:
	.string	"itimer"
.LC8:
	.string	"ru:W:N:"
.LC9:
	.string	"realtime "
.LC10:
	.string	"%s%s %lu microseconds"
	.text
	.globl	main
	.type	main, @function
main:
.LFB15:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$608, %rsp
	movl	%edi, -596(%rbp)
	movq	%rsi, -608(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movl	$0, -584(%rbp)
	movl	$1, -580(%rbp)
	movl	$0, -576(%rbp)
	movl	$-1, -572(%rbp)
	movl	$0, -568(%rbp)
	leaq	.LC2(%rip), %rax
	movq	%rax, -552(%rbp)
	leaq	.LC3(%rip), %rax
	movq	%rax, -544(%rbp)
	leaq	.LC4(%rip), %rax
	movq	%rax, -536(%rbp)
	movl	$0, -584(%rbp)
	jmp	.L28
.L42:
	movl	-564(%rbp), %eax
	subl	$78, %eax
	cmpl	$39, %eax
	ja	.L29
	movl	%eax, %eax
	leaq	0(,%rax,4), %rdx
	leaq	.L31(%rip), %rax
	movl	(%rdx,%rax), %eax
	cltq
	leaq	.L31(%rip), %rdx
	addq	%rdx, %rax
	notrack jmp	*%rax
	.section	.rodata
	.align 4
	.align 4
.L31:
	.long	.L35-.L31
	.long	.L29-.L31
	.long	.L34-.L31
	.long	.L29-.L31
	.long	.L29-.L31
	.long	.L29-.L31
	.long	.L29-.L31
	.long	.L29-.L31
	.long	.L29-.L31
	.long	.L33-.L31
	.long	.L29-.L31
	.long	.L29-.L31
	.long	.L29-.L31
	.long	.L29-.L31
	.long	.L29-.L31
	.long	.L29-.L31
	.long	.L29-.L31
	.long	.L29-.L31
	.long	.L29-.L31
	.long	.L29-.L31
	.long	.L29-.L31
	.long	.L29-.L31
	.long	.L29-.L31
	.long	.L29-.L31
	.long	.L29-.L31
	.long	.L29-.L31
	.long	.L29-.L31
	.long	.L29-.L31
	.long	.L29-.L31
	.long	.L29-.L31
	.long	.L29-.L31
	.long	.L29-.L31
	.long	.L29-.L31
	.long	.L29-.L31
	.long	.L29-.L31
	.long	.L29-.L31
	.long	.L32-.L31
	.long	.L29-.L31
	.long	.L29-.L31
	.long	.L30-.L31
	.text
.L32:
	movl	$1, -584(%rbp)
	jmp	.L28
.L30:
	movq	myoptarg(%rip), %rax
	leaq	.LC3(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L36
	movl	$0, -568(%rbp)
	leaq	.LC3(%rip), %rax
	movq	%rax, -544(%rbp)
	jmp	.L28
.L36:
	movq	myoptarg(%rip), %rax
	leaq	.LC5(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L38
	movl	$1, -568(%rbp)
	leaq	.LC5(%rip), %rax
	movq	%rax, -544(%rbp)
	jmp	.L28
.L38:
	movq	myoptarg(%rip), %rax
	leaq	.LC6(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L39
	movl	$2, -568(%rbp)
	leaq	.LC6(%rip), %rax
	movq	%rax, -544(%rbp)
	jmp	.L28
.L39:
	movq	myoptarg(%rip), %rax
	leaq	.LC7(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L40
	movl	$4, -568(%rbp)
	leaq	.LC7(%rip), %rax
	movq	%rax, -544(%rbp)
	jmp	.L28
.L40:
	movq	-536(%rbp), %rdx
	movq	-608(%rbp), %rcx
	movl	-596(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	lmbench_usage@PLT
	jmp	.L28
.L34:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -580(%rbp)
	cmpl	$0, -580(%rbp)
	jg	.L28
	movq	-536(%rbp), %rdx
	movq	-608(%rbp), %rcx
	movl	-596(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	lmbench_usage@PLT
	jmp	.L28
.L33:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -576(%rbp)
	jmp	.L28
.L35:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -572(%rbp)
	jmp	.L28
.L29:
	movq	-536(%rbp), %rdx
	movq	-608(%rbp), %rcx
	movl	-596(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	lmbench_usage@PLT
	nop
.L28:
	movq	-608(%rbp), %rcx
	movl	-596(%rbp), %eax
	leaq	.LC8(%rip), %rdx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	mygetopt@PLT
	movl	%eax, -564(%rbp)
	cmpl	$-1, -564(%rbp)
	jne	.L42
	movl	-596(%rbp), %eax
	leal	-1(%rax), %edx
	movl	myoptind(%rip), %eax
	cmpl	%eax, %edx
	je	.L43
	movq	-536(%rbp), %rdx
	movq	-608(%rbp), %rcx
	movl	-596(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	lmbench_usage@PLT
.L43:
	movl	myoptind(%rip), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-608(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	bytes@PLT
	movq	%rax, -560(%rbp)
	cmpl	$0, -584(%rbp)
	je	.L44
	movl	$0, %eax
	call	set_realtime
	testl	%eax, %eax
	je	.L44
	leaq	.LC9(%rip), %rax
	movq	%rax, -552(%rbp)
.L44:
	cmpl	$4, -568(%rbp)
	je	.L45
	cmpl	$4, -568(%rbp)
	ja	.L46
	cmpl	$2, -568(%rbp)
	je	.L47
	cmpl	$2, -568(%rbp)
	ja	.L46
	cmpl	$0, -568(%rbp)
	je	.L48
	cmpl	$1, -568(%rbp)
	je	.L49
	jmp	.L46
.L48:
	movl	-576(%rbp), %ecx
	movl	-580(%rbp), %edx
	leaq	-560(%rbp), %rax
	pushq	%rax
	movl	-572(%rbp), %eax
	pushq	%rax
	movl	%ecx, %r9d
	movl	%edx, %r8d
	movl	$0, %ecx
	movl	$0, %edx
	leaq	bench_usleep(%rip), %rax
	movq	%rax, %rsi
	movl	$0, %edi
	call	benchmp@PLT
	addq	$16, %rsp
	jmp	.L50
.L49:
	movl	-576(%rbp), %ecx
	movl	-580(%rbp), %edx
	leaq	-560(%rbp), %rax
	pushq	%rax
	movl	-572(%rbp), %eax
	pushq	%rax
	movl	%ecx, %r9d
	movl	%edx, %r8d
	movl	$0, %ecx
	movl	$0, %edx
	leaq	bench_nanosleep(%rip), %rax
	movq	%rax, %rsi
	movl	$0, %edi
	call	benchmp@PLT
	addq	$16, %rsp
	jmp	.L50
.L47:
	movl	-576(%rbp), %ecx
	movl	-580(%rbp), %edx
	leaq	-560(%rbp), %rax
	pushq	%rax
	movl	-572(%rbp), %eax
	pushq	%rax
	movl	%ecx, %r9d
	movl	%edx, %r8d
	movl	$0, %ecx
	movl	$0, %edx
	leaq	bench_select(%rip), %rax
	movq	%rax, %rsi
	movl	$0, %edi
	call	benchmp@PLT
	addq	$16, %rsp
	jmp	.L50
.L45:
	movl	-576(%rbp), %ecx
	movl	-580(%rbp), %edx
	leaq	-560(%rbp), %rax
	pushq	%rax
	movl	-572(%rbp), %eax
	pushq	%rax
	movl	%ecx, %r9d
	movl	%edx, %r8d
	movl	$0, %ecx
	movl	$0, %edx
	leaq	bench_itimer(%rip), %rax
	movq	%rax, %rsi
	leaq	initialize(%rip), %rax
	movq	%rax, %rdi
	call	benchmp@PLT
	addq	$16, %rsp
	jmp	.L50
.L46:
	movq	-536(%rbp), %rdx
	movq	-608(%rbp), %rcx
	movl	-596(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	lmbench_usage@PLT
	nop
.L50:
	movq	-560(%rbp), %rsi
	movq	-544(%rbp), %rcx
	movq	-552(%rbp), %rdx
	leaq	-528(%rbp), %rax
	movq	%rsi, %r8
	leaq	.LC10(%rip), %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	sprintf@PLT
	call	get_n@PLT
	movq	%rax, %rdx
	leaq	-528(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	micro@PLT
	movl	$0, %eax
	movq	-8(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L52
	call	__stack_chk_fail@PLT
.L52:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE15:
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
