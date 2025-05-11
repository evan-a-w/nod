	.file	"bw_mem.c"
	.text
	.globl	id
	.section	.rodata
.LC0:
	.string	"$Id$"
	.section	.data.rel.local,"aw"
	.align 8
	.type	id, @object
	.size	id, 8
id:
	.quad	.LC0
	.section	.rodata
	.align 8
.LC1:
	.string	"[-P <parallelism>] [-W <warmup>] [-N <repetitions>] <size> what [conflict]\nwhat: rd wr rdwr cp fwr frd fcp bzero bcopy\n<size> must be larger than 512"
.LC3:
	.string	"P:W:N:"
.LC4:
	.string	"cp"
.LC5:
	.string	"fcp"
.LC6:
	.string	"bcopy"
.LC7:
	.string	"rd"
.LC8:
	.string	"wr"
.LC9:
	.string	"rdwr"
.LC10:
	.string	"frd"
.LC11:
	.string	"fwr"
.LC12:
	.string	"bzero"
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
	pushq	%r12
	pushq	%rbx
	addq	$-128, %rsp
	.cfi_offset 12, -24
	.cfi_offset 3, -32
	movl	%edi, -132(%rbp)
	movq	%rsi, -144(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -24(%rbp)
	xorl	%eax, %eax
	movl	$1, -128(%rbp)
	movl	$0, -124(%rbp)
	movl	$-1, -120(%rbp)
	leaq	.LC1(%rip), %rax
	movq	%rax, -112(%rbp)
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -96(%rbp)
	jmp	.L2
.L7:
	cmpl	$87, -116(%rbp)
	je	.L3
	cmpl	$87, -116(%rbp)
	jg	.L4
	cmpl	$78, -116(%rbp)
	je	.L5
	cmpl	$80, -116(%rbp)
	jne	.L4
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -128(%rbp)
	cmpl	$0, -128(%rbp)
	jg	.L2
	movq	-112(%rbp), %rdx
	movq	-144(%rbp), %rcx
	movl	-132(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	lmbench_usage@PLT
	jmp	.L2
.L3:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -124(%rbp)
	jmp	.L2
.L5:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -120(%rbp)
	jmp	.L2
.L4:
	movq	-112(%rbp), %rdx
	movq	-144(%rbp), %rcx
	movl	-132(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	lmbench_usage@PLT
	nop
.L2:
	movq	-144(%rbp), %rcx
	movl	-132(%rbp), %eax
	leaq	.LC3(%rip), %rdx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	mygetopt@PLT
	movl	%eax, -116(%rbp)
	cmpl	$-1, -116(%rbp)
	jne	.L7
	movl	$0, -80(%rbp)
	movl	-80(%rbp), %eax
	movl	%eax, -76(%rbp)
	movl	myoptind(%rip), %eax
	addl	$3, %eax
	cmpl	%eax, -132(%rbp)
	jne	.L8
	movl	$1, -76(%rbp)
	jmp	.L9
.L8:
	movl	myoptind(%rip), %eax
	addl	$2, %eax
	cmpl	%eax, -132(%rbp)
	je	.L9
	movq	-112(%rbp), %rdx
	movq	-144(%rbp), %rcx
	movl	-132(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	lmbench_usage@PLT
.L9:
	movl	myoptind(%rip), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-144(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	bytes@PLT
	movq	%rax, -88(%rbp)
	movq	-88(%rbp), %rax
	movq	%rax, -104(%rbp)
	movq	-88(%rbp), %rax
	cmpq	$511, %rax
	ja	.L10
	movq	-112(%rbp), %rdx
	movq	-144(%rbp), %rcx
	movl	-132(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	lmbench_usage@PLT
.L10:
	movl	myoptind(%rip), %eax
	cltq
	addq	$1, %rax
	leaq	0(,%rax,8), %rdx
	movq	-144(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	leaq	.LC4(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	je	.L11
	movl	myoptind(%rip), %eax
	cltq
	addq	$1, %rax
	leaq	0(,%rax,8), %rdx
	movq	-144(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	leaq	.LC5(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	je	.L11
	movl	myoptind(%rip), %eax
	cltq
	addq	$1, %rax
	leaq	0(,%rax,8), %rdx
	movq	-144(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	leaq	.LC6(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L12
.L11:
	movl	$1, -80(%rbp)
.L12:
	movl	myoptind(%rip), %eax
	cltq
	addq	$1, %rax
	leaq	0(,%rax,8), %rdx
	movq	-144(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	leaq	.LC7(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L13
	movl	-124(%rbp), %ecx
	movl	-128(%rbp), %edx
	leaq	-96(%rbp), %rax
	pushq	%rax
	movl	-120(%rbp), %eax
	pushq	%rax
	movl	%ecx, %r9d
	movl	%edx, %r8d
	movl	$0, %ecx
	leaq	cleanup(%rip), %rax
	movq	%rax, %rdx
	leaq	rd(%rip), %rax
	movq	%rax, %rsi
	leaq	init_loop(%rip), %rax
	movq	%rax, %rdi
	call	benchmp@PLT
	addq	$16, %rsp
	jmp	.L14
.L13:
	movl	myoptind(%rip), %eax
	cltq
	addq	$1, %rax
	leaq	0(,%rax,8), %rdx
	movq	-144(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	leaq	.LC8(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L15
	movl	-124(%rbp), %ecx
	movl	-128(%rbp), %edx
	leaq	-96(%rbp), %rax
	pushq	%rax
	movl	-120(%rbp), %eax
	pushq	%rax
	movl	%ecx, %r9d
	movl	%edx, %r8d
	movl	$0, %ecx
	leaq	cleanup(%rip), %rax
	movq	%rax, %rdx
	leaq	wr(%rip), %rax
	movq	%rax, %rsi
	leaq	init_loop(%rip), %rax
	movq	%rax, %rdi
	call	benchmp@PLT
	addq	$16, %rsp
	jmp	.L14
.L15:
	movl	myoptind(%rip), %eax
	cltq
	addq	$1, %rax
	leaq	0(,%rax,8), %rdx
	movq	-144(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	leaq	.LC9(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L16
	movl	-124(%rbp), %ecx
	movl	-128(%rbp), %edx
	leaq	-96(%rbp), %rax
	pushq	%rax
	movl	-120(%rbp), %eax
	pushq	%rax
	movl	%ecx, %r9d
	movl	%edx, %r8d
	movl	$0, %ecx
	leaq	cleanup(%rip), %rax
	movq	%rax, %rdx
	leaq	rdwr(%rip), %rax
	movq	%rax, %rsi
	leaq	init_loop(%rip), %rax
	movq	%rax, %rdi
	call	benchmp@PLT
	addq	$16, %rsp
	jmp	.L14
.L16:
	movl	myoptind(%rip), %eax
	cltq
	addq	$1, %rax
	leaq	0(,%rax,8), %rdx
	movq	-144(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	leaq	.LC4(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L17
	movl	-124(%rbp), %ecx
	movl	-128(%rbp), %edx
	leaq	-96(%rbp), %rax
	pushq	%rax
	movl	-120(%rbp), %eax
	pushq	%rax
	movl	%ecx, %r9d
	movl	%edx, %r8d
	movl	$0, %ecx
	leaq	cleanup(%rip), %rax
	movq	%rax, %rdx
	leaq	mcp(%rip), %rax
	movq	%rax, %rsi
	leaq	init_loop(%rip), %rax
	movq	%rax, %rdi
	call	benchmp@PLT
	addq	$16, %rsp
	jmp	.L14
.L17:
	movl	myoptind(%rip), %eax
	cltq
	addq	$1, %rax
	leaq	0(,%rax,8), %rdx
	movq	-144(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	leaq	.LC10(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L18
	movl	-124(%rbp), %ecx
	movl	-128(%rbp), %edx
	leaq	-96(%rbp), %rax
	pushq	%rax
	movl	-120(%rbp), %eax
	pushq	%rax
	movl	%ecx, %r9d
	movl	%edx, %r8d
	movl	$0, %ecx
	leaq	cleanup(%rip), %rax
	movq	%rax, %rdx
	leaq	frd(%rip), %rax
	movq	%rax, %rsi
	leaq	init_loop(%rip), %rax
	movq	%rax, %rdi
	call	benchmp@PLT
	addq	$16, %rsp
	jmp	.L14
.L18:
	movl	myoptind(%rip), %eax
	cltq
	addq	$1, %rax
	leaq	0(,%rax,8), %rdx
	movq	-144(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	leaq	.LC11(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L19
	movl	-124(%rbp), %ecx
	movl	-128(%rbp), %edx
	leaq	-96(%rbp), %rax
	pushq	%rax
	movl	-120(%rbp), %eax
	pushq	%rax
	movl	%ecx, %r9d
	movl	%edx, %r8d
	movl	$0, %ecx
	leaq	cleanup(%rip), %rax
	movq	%rax, %rdx
	leaq	fwr(%rip), %rax
	movq	%rax, %rsi
	leaq	init_loop(%rip), %rax
	movq	%rax, %rdi
	call	benchmp@PLT
	addq	$16, %rsp
	jmp	.L14
.L19:
	movl	myoptind(%rip), %eax
	cltq
	addq	$1, %rax
	leaq	0(,%rax,8), %rdx
	movq	-144(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	leaq	.LC5(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L20
	movl	-124(%rbp), %ecx
	movl	-128(%rbp), %edx
	leaq	-96(%rbp), %rax
	pushq	%rax
	movl	-120(%rbp), %eax
	pushq	%rax
	movl	%ecx, %r9d
	movl	%edx, %r8d
	movl	$0, %ecx
	leaq	cleanup(%rip), %rax
	movq	%rax, %rdx
	leaq	fcp(%rip), %rax
	movq	%rax, %rsi
	leaq	init_loop(%rip), %rax
	movq	%rax, %rdi
	call	benchmp@PLT
	addq	$16, %rsp
	jmp	.L14
.L20:
	movl	myoptind(%rip), %eax
	cltq
	addq	$1, %rax
	leaq	0(,%rax,8), %rdx
	movq	-144(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	leaq	.LC12(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L21
	movl	-124(%rbp), %ecx
	movl	-128(%rbp), %edx
	leaq	-96(%rbp), %rax
	pushq	%rax
	movl	-120(%rbp), %eax
	pushq	%rax
	movl	%ecx, %r9d
	movl	%edx, %r8d
	movl	$0, %ecx
	leaq	cleanup(%rip), %rax
	movq	%rax, %rdx
	leaq	loop_bzero(%rip), %rax
	movq	%rax, %rsi
	leaq	init_loop(%rip), %rax
	movq	%rax, %rdi
	call	benchmp@PLT
	addq	$16, %rsp
	jmp	.L14
.L21:
	movl	myoptind(%rip), %eax
	cltq
	addq	$1, %rax
	leaq	0(,%rax,8), %rdx
	movq	-144(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	leaq	.LC6(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L22
	movl	-124(%rbp), %ecx
	movl	-128(%rbp), %edx
	leaq	-96(%rbp), %rax
	pushq	%rax
	movl	-120(%rbp), %eax
	pushq	%rax
	movl	%ecx, %r9d
	movl	%edx, %r8d
	movl	$0, %ecx
	leaq	cleanup(%rip), %rax
	movq	%rax, %rdx
	leaq	loop_bcopy(%rip), %rax
	movq	%rax, %rsi
	leaq	init_loop(%rip), %rax
	movq	%rax, %rdi
	call	benchmp@PLT
	addq	$16, %rsp
	jmp	.L14
.L22:
	movq	-112(%rbp), %rdx
	movq	-144(%rbp), %rcx
	movl	-132(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	lmbench_usage@PLT
.L14:
	movq	-96(%rbp), %r12
	call	get_n@PLT
	movl	-128(%rbp), %edx
	movslq	%edx, %rdx
	imulq	%rdx, %rax
	movq	%rax, %rbx
	call	usecs_spent@PLT
	movq	%rax, %rcx
	movq	-104(%rbp), %rax
	movq	%r12, %xmm0
	movq	%rbx, %rdx
	movq	%rax, %rsi
	movq	%rcx, %rdi
	call	adjusted_bandwidth
	movl	$0, %eax
	movq	-24(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L24
	call	__stack_chk_fail@PLT
.L24:
	leaq	-16(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE8:
	.size	main, .-main
	.globl	init_overhead
	.type	init_overhead, @function
init_overhead:
.LFB9:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE9:
	.size	init_overhead, .-init_overhead
	.section	.rodata
.LC13:
	.string	"malloc"
	.text
	.globl	init_loop
	.type	init_loop, @function
init_loop:
.LFB10:
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
	movq	%rax, -16(%rbp)
	cmpq	$0, -24(%rbp)
	jne	.L31
	movq	-16(%rbp), %rax
	movq	8(%rax), %rax
	movq	%rax, %rdi
	call	valloc@PLT
	movq	%rax, %rdx
	movq	-16(%rbp), %rax
	movq	%rdx, 24(%rax)
	movq	-16(%rbp), %rax
	movq	$0, 40(%rax)
	movq	-16(%rbp), %rax
	movq	24(%rax), %rax
	leaq	-4(%rax), %rdx
	movq	-16(%rbp), %rax
	movq	%rdx, 48(%rax)
	movq	-16(%rbp), %rax
	movq	24(%rax), %rdx
	movq	-16(%rbp), %rax
	movq	8(%rax), %rax
	subq	$512, %rax
	addq	%rax, %rdx
	movq	-16(%rbp), %rax
	movq	%rdx, 48(%rax)
	movq	-16(%rbp), %rax
	movq	8(%rax), %rdx
	movq	-16(%rbp), %rax
	movq	%rdx, 56(%rax)
	movq	-16(%rbp), %rax
	movq	24(%rax), %rax
	testq	%rax, %rax
	jne	.L29
	leaq	.LC13(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L29:
	movq	-16(%rbp), %rax
	movq	8(%rax), %rdx
	movq	-16(%rbp), %rax
	movq	24(%rax), %rax
	movl	$0, %esi
	movq	%rax, %rdi
	call	memset@PLT
	movq	-16(%rbp), %rax
	movl	16(%rax), %eax
	cmpl	$1, %eax
	jne	.L26
	movq	-16(%rbp), %rax
	movq	8(%rax), %rax
	addq	$2048, %rax
	movq	%rax, %rdi
	call	valloc@PLT
	movq	%rax, %rdx
	movq	-16(%rbp), %rax
	movq	%rdx, 32(%rax)
	movq	-16(%rbp), %rax
	movq	32(%rax), %rdx
	movq	-16(%rbp), %rax
	movq	%rdx, 40(%rax)
	movq	-16(%rbp), %rax
	movq	32(%rax), %rax
	testq	%rax, %rax
	jne	.L30
	leaq	.LC13(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L30:
	movq	-16(%rbp), %rax
	movl	20(%rax), %eax
	testl	%eax, %eax
	je	.L26
	movq	-16(%rbp), %rax
	movq	32(%rax), %rax
	movq	%rax, -8(%rbp)
	addq	$1920, -8(%rbp)
	movq	-16(%rbp), %rax
	movq	-8(%rbp), %rdx
	movq	%rdx, 32(%rax)
	jmp	.L26
.L31:
	nop
.L26:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE10:
	.size	init_loop, .-init_loop
	.globl	cleanup
	.type	cleanup, @function
cleanup:
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
	movq	%rsi, -32(%rbp)
	movq	-32(%rbp), %rax
	movq	%rax, -8(%rbp)
	cmpq	$0, -24(%rbp)
	jne	.L35
	movq	-8(%rbp), %rax
	movq	24(%rax), %rax
	movq	%rax, %rdi
	call	free@PLT
	movq	-8(%rbp), %rax
	movq	40(%rax), %rax
	testq	%rax, %rax
	je	.L32
	movq	-8(%rbp), %rax
	movq	40(%rax), %rax
	movq	%rax, %rdi
	call	free@PLT
	jmp	.L32
.L35:
	nop
.L32:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE11:
	.size	cleanup, .-cleanup
	.globl	rd
	.type	rd, @function
rd:
.LFB12:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$40, %rsp
	.cfi_offset 13, -24
	.cfi_offset 12, -32
	.cfi_offset 3, -40
	movq	%rdi, -56(%rbp)
	movq	%rsi, -64(%rbp)
	movq	-64(%rbp), %rax
	movq	%rax, -40(%rbp)
	movq	-40(%rbp), %rax
	movq	48(%rax), %r13
	movl	$0, %r12d
	jmp	.L37
.L40:
	movq	-40(%rbp), %rax
	movq	24(%rax), %rbx
	jmp	.L38
.L39:
	movl	(%rbx), %edx
	leaq	16(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	32(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	48(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	64(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	80(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	96(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	112(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	128(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	144(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	160(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	176(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	192(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	208(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	224(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	240(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	256(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	272(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	288(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	304(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	320(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	336(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	352(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	368(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	384(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	400(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	416(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	432(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	448(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	464(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	480(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	496(%rbx), %rax
	movl	(%rax), %eax
	addl	%edx, %eax
	addl	%eax, %r12d
	addq	$512, %rbx
.L38:
	cmpq	%r13, %rbx
	jbe	.L39
.L37:
	movq	-56(%rbp), %rax
	leaq	-1(%rax), %rdx
	movq	%rdx, -56(%rbp)
	testq	%rax, %rax
	jne	.L40
	movl	%r12d, %edi
	call	use_int@PLT
	nop
	addq	$40, %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE12:
	.size	rd, .-rd
	.globl	wr
	.type	wr, @function
wr:
.LFB13:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r12
	pushq	%rbx
	.cfi_offset 12, -24
	.cfi_offset 3, -32
	movq	%rdi, -40(%rbp)
	movq	%rsi, -48(%rbp)
	movq	-48(%rbp), %rax
	movq	%rax, -24(%rbp)
	movq	-24(%rbp), %rax
	movq	48(%rax), %r12
	jmp	.L42
.L45:
	movq	-24(%rbp), %rax
	movq	24(%rax), %rbx
	jmp	.L43
.L44:
	movl	$1, (%rbx)
	leaq	16(%rbx), %rax
	movl	$1, (%rax)
	leaq	32(%rbx), %rax
	movl	$1, (%rax)
	leaq	48(%rbx), %rax
	movl	$1, (%rax)
	leaq	64(%rbx), %rax
	movl	$1, (%rax)
	leaq	80(%rbx), %rax
	movl	$1, (%rax)
	leaq	96(%rbx), %rax
	movl	$1, (%rax)
	leaq	112(%rbx), %rax
	movl	$1, (%rax)
	leaq	128(%rbx), %rax
	movl	$1, (%rax)
	leaq	144(%rbx), %rax
	movl	$1, (%rax)
	leaq	160(%rbx), %rax
	movl	$1, (%rax)
	leaq	176(%rbx), %rax
	movl	$1, (%rax)
	leaq	192(%rbx), %rax
	movl	$1, (%rax)
	leaq	208(%rbx), %rax
	movl	$1, (%rax)
	leaq	224(%rbx), %rax
	movl	$1, (%rax)
	leaq	240(%rbx), %rax
	movl	$1, (%rax)
	leaq	256(%rbx), %rax
	movl	$1, (%rax)
	leaq	272(%rbx), %rax
	movl	$1, (%rax)
	leaq	288(%rbx), %rax
	movl	$1, (%rax)
	leaq	304(%rbx), %rax
	movl	$1, (%rax)
	leaq	320(%rbx), %rax
	movl	$1, (%rax)
	leaq	336(%rbx), %rax
	movl	$1, (%rax)
	leaq	352(%rbx), %rax
	movl	$1, (%rax)
	leaq	368(%rbx), %rax
	movl	$1, (%rax)
	leaq	384(%rbx), %rax
	movl	$1, (%rax)
	leaq	400(%rbx), %rax
	movl	$1, (%rax)
	leaq	416(%rbx), %rax
	movl	$1, (%rax)
	leaq	432(%rbx), %rax
	movl	$1, (%rax)
	leaq	448(%rbx), %rax
	movl	$1, (%rax)
	leaq	464(%rbx), %rax
	movl	$1, (%rax)
	leaq	480(%rbx), %rax
	movl	$1, (%rax)
	leaq	496(%rbx), %rax
	movl	$1, (%rax)
	addq	$512, %rbx
.L43:
	cmpq	%r12, %rbx
	jbe	.L44
.L42:
	movq	-40(%rbp), %rax
	leaq	-1(%rax), %rdx
	movq	%rdx, -40(%rbp)
	testq	%rax, %rax
	jne	.L45
	nop
	nop
	popq	%rbx
	popq	%r12
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE13:
	.size	wr, .-wr
	.globl	rdwr
	.type	rdwr, @function
rdwr:
.LFB14:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$40, %rsp
	.cfi_offset 13, -24
	.cfi_offset 12, -32
	.cfi_offset 3, -40
	movq	%rdi, -56(%rbp)
	movq	%rsi, -64(%rbp)
	movq	-64(%rbp), %rax
	movq	%rax, -40(%rbp)
	movq	-40(%rbp), %rax
	movq	48(%rax), %r13
	movl	$0, %r12d
	jmp	.L47
.L50:
	movq	-40(%rbp), %rax
	movq	24(%rax), %rbx
	jmp	.L48
.L49:
	movl	(%rbx), %eax
	addl	%eax, %r12d
	movl	$1, (%rbx)
	leaq	16(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %r12d
	leaq	16(%rbx), %rax
	movl	$1, (%rax)
	leaq	32(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %r12d
	leaq	32(%rbx), %rax
	movl	$1, (%rax)
	leaq	48(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %r12d
	leaq	48(%rbx), %rax
	movl	$1, (%rax)
	leaq	64(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %r12d
	leaq	64(%rbx), %rax
	movl	$1, (%rax)
	leaq	80(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %r12d
	leaq	80(%rbx), %rax
	movl	$1, (%rax)
	leaq	96(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %r12d
	leaq	96(%rbx), %rax
	movl	$1, (%rax)
	leaq	112(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %r12d
	leaq	112(%rbx), %rax
	movl	$1, (%rax)
	leaq	128(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %r12d
	leaq	128(%rbx), %rax
	movl	$1, (%rax)
	leaq	144(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %r12d
	leaq	144(%rbx), %rax
	movl	$1, (%rax)
	leaq	160(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %r12d
	leaq	160(%rbx), %rax
	movl	$1, (%rax)
	leaq	176(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %r12d
	leaq	176(%rbx), %rax
	movl	$1, (%rax)
	leaq	192(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %r12d
	leaq	192(%rbx), %rax
	movl	$1, (%rax)
	leaq	208(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %r12d
	leaq	208(%rbx), %rax
	movl	$1, (%rax)
	leaq	224(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %r12d
	leaq	224(%rbx), %rax
	movl	$1, (%rax)
	leaq	240(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %r12d
	leaq	240(%rbx), %rax
	movl	$1, (%rax)
	leaq	256(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %r12d
	leaq	256(%rbx), %rax
	movl	$1, (%rax)
	leaq	272(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %r12d
	leaq	272(%rbx), %rax
	movl	$1, (%rax)
	leaq	288(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %r12d
	leaq	288(%rbx), %rax
	movl	$1, (%rax)
	leaq	304(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %r12d
	leaq	304(%rbx), %rax
	movl	$1, (%rax)
	leaq	320(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %r12d
	leaq	320(%rbx), %rax
	movl	$1, (%rax)
	leaq	336(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %r12d
	leaq	336(%rbx), %rax
	movl	$1, (%rax)
	leaq	352(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %r12d
	leaq	352(%rbx), %rax
	movl	$1, (%rax)
	leaq	368(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %r12d
	leaq	368(%rbx), %rax
	movl	$1, (%rax)
	leaq	384(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %r12d
	leaq	384(%rbx), %rax
	movl	$1, (%rax)
	leaq	400(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %r12d
	leaq	400(%rbx), %rax
	movl	$1, (%rax)
	leaq	416(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %r12d
	leaq	416(%rbx), %rax
	movl	$1, (%rax)
	leaq	432(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %r12d
	leaq	432(%rbx), %rax
	movl	$1, (%rax)
	leaq	448(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %r12d
	leaq	448(%rbx), %rax
	movl	$1, (%rax)
	leaq	464(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %r12d
	leaq	464(%rbx), %rax
	movl	$1, (%rax)
	leaq	480(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %r12d
	leaq	480(%rbx), %rax
	movl	$1, (%rax)
	leaq	496(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %r12d
	leaq	496(%rbx), %rax
	movl	$1, (%rax)
	addq	$512, %rbx
.L48:
	cmpq	%r13, %rbx
	jbe	.L49
.L47:
	movq	-56(%rbp), %rax
	leaq	-1(%rax), %rdx
	movq	%rdx, -56(%rbp)
	testq	%rax, %rax
	jne	.L50
	movl	%r12d, %edi
	call	use_int@PLT
	nop
	addq	$40, %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE14:
	.size	rdwr, .-rdwr
	.globl	mcp
	.type	mcp, @function
mcp:
.LFB15:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$40, %rsp
	.cfi_offset 13, -24
	.cfi_offset 12, -32
	.cfi_offset 3, -40
	movq	%rdi, -56(%rbp)
	movq	%rsi, -64(%rbp)
	movq	-64(%rbp), %rax
	movq	%rax, -40(%rbp)
	movq	-40(%rbp), %rax
	movq	48(%rax), %r13
	movq	$0, -48(%rbp)
	jmp	.L52
.L55:
	movq	-40(%rbp), %rax
	movq	24(%rax), %rbx
	movq	-40(%rbp), %rax
	movq	32(%rax), %r12
	jmp	.L53
.L54:
	movl	(%rbx), %eax
	movl	%eax, (%r12)
	leaq	16(%r12), %rax
	movl	16(%rbx), %edx
	movl	%edx, (%rax)
	leaq	32(%r12), %rax
	movl	32(%rbx), %edx
	movl	%edx, (%rax)
	leaq	48(%r12), %rax
	movl	48(%rbx), %edx
	movl	%edx, (%rax)
	leaq	64(%r12), %rax
	movl	64(%rbx), %edx
	movl	%edx, (%rax)
	leaq	80(%r12), %rax
	movl	80(%rbx), %edx
	movl	%edx, (%rax)
	leaq	96(%r12), %rax
	movl	96(%rbx), %edx
	movl	%edx, (%rax)
	leaq	112(%r12), %rax
	movl	112(%rbx), %edx
	movl	%edx, (%rax)
	leaq	128(%r12), %rax
	movl	128(%rbx), %edx
	movl	%edx, (%rax)
	leaq	144(%r12), %rax
	movl	144(%rbx), %edx
	movl	%edx, (%rax)
	leaq	160(%r12), %rax
	movl	160(%rbx), %edx
	movl	%edx, (%rax)
	leaq	176(%r12), %rax
	movl	176(%rbx), %edx
	movl	%edx, (%rax)
	leaq	192(%r12), %rax
	movl	192(%rbx), %edx
	movl	%edx, (%rax)
	leaq	208(%r12), %rax
	movl	208(%rbx), %edx
	movl	%edx, (%rax)
	leaq	224(%r12), %rax
	movl	224(%rbx), %edx
	movl	%edx, (%rax)
	leaq	240(%r12), %rax
	movl	240(%rbx), %edx
	movl	%edx, (%rax)
	leaq	256(%r12), %rax
	movl	256(%rbx), %edx
	movl	%edx, (%rax)
	leaq	272(%r12), %rax
	movl	272(%rbx), %edx
	movl	%edx, (%rax)
	leaq	288(%r12), %rax
	movl	288(%rbx), %edx
	movl	%edx, (%rax)
	leaq	304(%r12), %rax
	movl	304(%rbx), %edx
	movl	%edx, (%rax)
	leaq	320(%r12), %rax
	movl	320(%rbx), %edx
	movl	%edx, (%rax)
	leaq	336(%r12), %rax
	movl	336(%rbx), %edx
	movl	%edx, (%rax)
	leaq	352(%r12), %rax
	movl	352(%rbx), %edx
	movl	%edx, (%rax)
	leaq	368(%r12), %rax
	movl	368(%rbx), %edx
	movl	%edx, (%rax)
	leaq	384(%r12), %rax
	movl	384(%rbx), %edx
	movl	%edx, (%rax)
	leaq	400(%r12), %rax
	movl	400(%rbx), %edx
	movl	%edx, (%rax)
	leaq	416(%r12), %rax
	movl	416(%rbx), %edx
	movl	%edx, (%rax)
	leaq	432(%r12), %rax
	movl	432(%rbx), %edx
	movl	%edx, (%rax)
	leaq	448(%r12), %rax
	movl	448(%rbx), %edx
	movl	%edx, (%rax)
	leaq	464(%r12), %rax
	movl	464(%rbx), %edx
	movl	%edx, (%rax)
	leaq	480(%r12), %rax
	movl	480(%rbx), %edx
	movl	%edx, (%rax)
	leaq	496(%r12), %rax
	movl	496(%rbx), %edx
	movl	%edx, (%rax)
	addq	$512, %rbx
	addq	$512, %r12
.L53:
	cmpq	%r13, %rbx
	jbe	.L54
	movq	%rbx, -48(%rbp)
.L52:
	movq	-56(%rbp), %rax
	leaq	-1(%rax), %rdx
	movq	%rdx, -56(%rbp)
	testq	%rax, %rax
	jne	.L55
	movq	-48(%rbp), %rax
	movq	%rax, %rdi
	call	use_pointer@PLT
	nop
	addq	$40, %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE15:
	.size	mcp, .-mcp
	.globl	fwr
	.type	fwr, @function
fwr:
.LFB16:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r12
	pushq	%rbx
	subq	$32, %rsp
	.cfi_offset 12, -24
	.cfi_offset 3, -32
	movq	%rdi, -40(%rbp)
	movq	%rsi, -48(%rbp)
	movq	-48(%rbp), %rax
	movq	%rax, -24(%rbp)
	movq	-24(%rbp), %rax
	movq	48(%rax), %r12
	movq	$0, -32(%rbp)
	jmp	.L57
.L60:
	movq	-24(%rbp), %rax
	movq	24(%rax), %rbx
	jmp	.L58
.L59:
	leaq	508(%rbx), %rax
	movl	$1, (%rax)
	leaq	504(%rbx), %rdx
	movl	(%rax), %eax
	movl	%eax, (%rdx)
	leaq	500(%rbx), %rax
	movl	(%rdx), %edx
	movl	%edx, (%rax)
	leaq	496(%rbx), %rdx
	movl	(%rax), %eax
	movl	%eax, (%rdx)
	leaq	492(%rbx), %rax
	movl	(%rdx), %edx
	movl	%edx, (%rax)
	leaq	488(%rbx), %rdx
	movl	(%rax), %eax
	movl	%eax, (%rdx)
	leaq	484(%rbx), %rax
	movl	(%rdx), %edx
	movl	%edx, (%rax)
	leaq	480(%rbx), %rdx
	movl	(%rax), %eax
	movl	%eax, (%rdx)
	leaq	476(%rbx), %rax
	movl	(%rdx), %edx
	movl	%edx, (%rax)
	leaq	472(%rbx), %rdx
	movl	(%rax), %eax
	movl	%eax, (%rdx)
	leaq	468(%rbx), %rax
	movl	(%rdx), %edx
	movl	%edx, (%rax)
	leaq	464(%rbx), %rdx
	movl	(%rax), %eax
	movl	%eax, (%rdx)
	leaq	460(%rbx), %rax
	movl	(%rdx), %edx
	movl	%edx, (%rax)
	leaq	456(%rbx), %rdx
	movl	(%rax), %eax
	movl	%eax, (%rdx)
	leaq	452(%rbx), %rax
	movl	(%rdx), %edx
	movl	%edx, (%rax)
	leaq	448(%rbx), %rdx
	movl	(%rax), %eax
	movl	%eax, (%rdx)
	leaq	444(%rbx), %rax
	movl	(%rdx), %edx
	movl	%edx, (%rax)
	leaq	440(%rbx), %rdx
	movl	(%rax), %eax
	movl	%eax, (%rdx)
	leaq	436(%rbx), %rax
	movl	(%rdx), %edx
	movl	%edx, (%rax)
	leaq	432(%rbx), %rdx
	movl	(%rax), %eax
	movl	%eax, (%rdx)
	leaq	428(%rbx), %rax
	movl	(%rdx), %edx
	movl	%edx, (%rax)
	leaq	424(%rbx), %rdx
	movl	(%rax), %eax
	movl	%eax, (%rdx)
	leaq	420(%rbx), %rax
	movl	(%rdx), %edx
	movl	%edx, (%rax)
	leaq	416(%rbx), %rdx
	movl	(%rax), %eax
	movl	%eax, (%rdx)
	leaq	412(%rbx), %rax
	movl	(%rdx), %edx
	movl	%edx, (%rax)
	leaq	408(%rbx), %rdx
	movl	(%rax), %eax
	movl	%eax, (%rdx)
	leaq	404(%rbx), %rax
	movl	(%rdx), %edx
	movl	%edx, (%rax)
	leaq	400(%rbx), %rdx
	movl	(%rax), %eax
	movl	%eax, (%rdx)
	leaq	396(%rbx), %rax
	movl	(%rdx), %edx
	movl	%edx, (%rax)
	leaq	392(%rbx), %rdx
	movl	(%rax), %eax
	movl	%eax, (%rdx)
	leaq	388(%rbx), %rax
	movl	(%rdx), %edx
	movl	%edx, (%rax)
	leaq	384(%rbx), %rdx
	movl	(%rax), %eax
	movl	%eax, (%rdx)
	leaq	380(%rbx), %rax
	movl	(%rdx), %edx
	movl	%edx, (%rax)
	leaq	376(%rbx), %rdx
	movl	(%rax), %eax
	movl	%eax, (%rdx)
	leaq	372(%rbx), %rax
	movl	(%rdx), %edx
	movl	%edx, (%rax)
	leaq	368(%rbx), %rdx
	movl	(%rax), %eax
	movl	%eax, (%rdx)
	leaq	364(%rbx), %rax
	movl	(%rdx), %edx
	movl	%edx, (%rax)
	leaq	360(%rbx), %rdx
	movl	(%rax), %eax
	movl	%eax, (%rdx)
	leaq	356(%rbx), %rax
	movl	(%rdx), %edx
	movl	%edx, (%rax)
	leaq	352(%rbx), %rdx
	movl	(%rax), %eax
	movl	%eax, (%rdx)
	leaq	348(%rbx), %rax
	movl	(%rdx), %edx
	movl	%edx, (%rax)
	leaq	344(%rbx), %rdx
	movl	(%rax), %eax
	movl	%eax, (%rdx)
	leaq	340(%rbx), %rax
	movl	(%rdx), %edx
	movl	%edx, (%rax)
	leaq	336(%rbx), %rdx
	movl	(%rax), %eax
	movl	%eax, (%rdx)
	leaq	332(%rbx), %rax
	movl	(%rdx), %edx
	movl	%edx, (%rax)
	leaq	328(%rbx), %rdx
	movl	(%rax), %eax
	movl	%eax, (%rdx)
	leaq	324(%rbx), %rax
	movl	(%rdx), %edx
	movl	%edx, (%rax)
	leaq	320(%rbx), %rdx
	movl	(%rax), %eax
	movl	%eax, (%rdx)
	leaq	316(%rbx), %rax
	movl	(%rdx), %edx
	movl	%edx, (%rax)
	leaq	312(%rbx), %rdx
	movl	(%rax), %eax
	movl	%eax, (%rdx)
	leaq	308(%rbx), %rax
	movl	(%rdx), %edx
	movl	%edx, (%rax)
	leaq	304(%rbx), %rdx
	movl	(%rax), %eax
	movl	%eax, (%rdx)
	leaq	300(%rbx), %rax
	movl	(%rdx), %edx
	movl	%edx, (%rax)
	leaq	296(%rbx), %rdx
	movl	(%rax), %eax
	movl	%eax, (%rdx)
	leaq	292(%rbx), %rax
	movl	(%rdx), %edx
	movl	%edx, (%rax)
	leaq	288(%rbx), %rdx
	movl	(%rax), %eax
	movl	%eax, (%rdx)
	leaq	284(%rbx), %rax
	movl	(%rdx), %edx
	movl	%edx, (%rax)
	leaq	280(%rbx), %rdx
	movl	(%rax), %eax
	movl	%eax, (%rdx)
	leaq	276(%rbx), %rax
	movl	(%rdx), %edx
	movl	%edx, (%rax)
	leaq	272(%rbx), %rdx
	movl	(%rax), %eax
	movl	%eax, (%rdx)
	leaq	268(%rbx), %rax
	movl	(%rdx), %edx
	movl	%edx, (%rax)
	leaq	264(%rbx), %rdx
	movl	(%rax), %eax
	movl	%eax, (%rdx)
	leaq	260(%rbx), %rax
	movl	(%rdx), %edx
	movl	%edx, (%rax)
	leaq	256(%rbx), %rdx
	movl	(%rax), %eax
	movl	%eax, (%rdx)
	leaq	252(%rbx), %rax
	movl	(%rdx), %edx
	movl	%edx, (%rax)
	leaq	248(%rbx), %rdx
	movl	(%rax), %eax
	movl	%eax, (%rdx)
	leaq	244(%rbx), %rax
	movl	(%rdx), %edx
	movl	%edx, (%rax)
	leaq	240(%rbx), %rdx
	movl	(%rax), %eax
	movl	%eax, (%rdx)
	leaq	236(%rbx), %rax
	movl	(%rdx), %edx
	movl	%edx, (%rax)
	leaq	232(%rbx), %rdx
	movl	(%rax), %eax
	movl	%eax, (%rdx)
	leaq	228(%rbx), %rax
	movl	(%rdx), %edx
	movl	%edx, (%rax)
	leaq	224(%rbx), %rdx
	movl	(%rax), %eax
	movl	%eax, (%rdx)
	leaq	220(%rbx), %rax
	movl	(%rdx), %edx
	movl	%edx, (%rax)
	leaq	216(%rbx), %rdx
	movl	(%rax), %eax
	movl	%eax, (%rdx)
	leaq	212(%rbx), %rax
	movl	(%rdx), %edx
	movl	%edx, (%rax)
	leaq	208(%rbx), %rdx
	movl	(%rax), %eax
	movl	%eax, (%rdx)
	leaq	204(%rbx), %rax
	movl	(%rdx), %edx
	movl	%edx, (%rax)
	leaq	200(%rbx), %rdx
	movl	(%rax), %eax
	movl	%eax, (%rdx)
	leaq	196(%rbx), %rax
	movl	(%rdx), %edx
	movl	%edx, (%rax)
	leaq	192(%rbx), %rdx
	movl	(%rax), %eax
	movl	%eax, (%rdx)
	leaq	188(%rbx), %rax
	movl	(%rdx), %edx
	movl	%edx, (%rax)
	leaq	184(%rbx), %rdx
	movl	(%rax), %eax
	movl	%eax, (%rdx)
	leaq	180(%rbx), %rax
	movl	(%rdx), %edx
	movl	%edx, (%rax)
	leaq	176(%rbx), %rdx
	movl	(%rax), %eax
	movl	%eax, (%rdx)
	leaq	172(%rbx), %rax
	movl	(%rdx), %edx
	movl	%edx, (%rax)
	leaq	168(%rbx), %rdx
	movl	(%rax), %eax
	movl	%eax, (%rdx)
	leaq	164(%rbx), %rax
	movl	(%rdx), %edx
	movl	%edx, (%rax)
	leaq	160(%rbx), %rdx
	movl	(%rax), %eax
	movl	%eax, (%rdx)
	leaq	156(%rbx), %rax
	movl	(%rdx), %edx
	movl	%edx, (%rax)
	leaq	152(%rbx), %rdx
	movl	(%rax), %eax
	movl	%eax, (%rdx)
	leaq	148(%rbx), %rax
	movl	(%rdx), %edx
	movl	%edx, (%rax)
	leaq	144(%rbx), %rdx
	movl	(%rax), %eax
	movl	%eax, (%rdx)
	leaq	140(%rbx), %rax
	movl	(%rdx), %edx
	movl	%edx, (%rax)
	leaq	136(%rbx), %rdx
	movl	(%rax), %eax
	movl	%eax, (%rdx)
	leaq	132(%rbx), %rax
	movl	(%rdx), %edx
	movl	%edx, (%rax)
	leaq	128(%rbx), %rdx
	movl	(%rax), %eax
	movl	%eax, (%rdx)
	leaq	124(%rbx), %rax
	movl	(%rdx), %edx
	movl	%edx, (%rax)
	leaq	120(%rbx), %rdx
	movl	(%rax), %eax
	movl	%eax, (%rdx)
	leaq	116(%rbx), %rax
	movl	(%rdx), %edx
	movl	%edx, (%rax)
	leaq	112(%rbx), %rdx
	movl	(%rax), %eax
	movl	%eax, (%rdx)
	leaq	108(%rbx), %rax
	movl	(%rdx), %edx
	movl	%edx, (%rax)
	leaq	104(%rbx), %rdx
	movl	(%rax), %eax
	movl	%eax, (%rdx)
	leaq	100(%rbx), %rax
	movl	(%rdx), %edx
	movl	%edx, (%rax)
	leaq	96(%rbx), %rdx
	movl	(%rax), %eax
	movl	%eax, (%rdx)
	leaq	92(%rbx), %rax
	movl	(%rdx), %edx
	movl	%edx, (%rax)
	leaq	88(%rbx), %rdx
	movl	(%rax), %eax
	movl	%eax, (%rdx)
	leaq	84(%rbx), %rax
	movl	(%rdx), %edx
	movl	%edx, (%rax)
	leaq	80(%rbx), %rdx
	movl	(%rax), %eax
	movl	%eax, (%rdx)
	leaq	76(%rbx), %rax
	movl	(%rdx), %edx
	movl	%edx, (%rax)
	leaq	72(%rbx), %rdx
	movl	(%rax), %eax
	movl	%eax, (%rdx)
	leaq	68(%rbx), %rax
	movl	(%rdx), %edx
	movl	%edx, (%rax)
	leaq	64(%rbx), %rdx
	movl	(%rax), %eax
	movl	%eax, (%rdx)
	leaq	60(%rbx), %rax
	movl	(%rdx), %edx
	movl	%edx, (%rax)
	leaq	56(%rbx), %rdx
	movl	(%rax), %eax
	movl	%eax, (%rdx)
	leaq	52(%rbx), %rax
	movl	(%rdx), %edx
	movl	%edx, (%rax)
	leaq	48(%rbx), %rdx
	movl	(%rax), %eax
	movl	%eax, (%rdx)
	leaq	44(%rbx), %rax
	movl	(%rdx), %edx
	movl	%edx, (%rax)
	leaq	40(%rbx), %rdx
	movl	(%rax), %eax
	movl	%eax, (%rdx)
	leaq	36(%rbx), %rax
	movl	(%rdx), %edx
	movl	%edx, (%rax)
	leaq	32(%rbx), %rdx
	movl	(%rax), %eax
	movl	%eax, (%rdx)
	leaq	28(%rbx), %rax
	movl	(%rdx), %edx
	movl	%edx, (%rax)
	leaq	24(%rbx), %rdx
	movl	(%rax), %eax
	movl	%eax, (%rdx)
	leaq	20(%rbx), %rax
	movl	(%rdx), %edx
	movl	%edx, (%rax)
	leaq	16(%rbx), %rdx
	movl	(%rax), %eax
	movl	%eax, (%rdx)
	leaq	12(%rbx), %rax
	movl	(%rdx), %edx
	movl	%edx, (%rax)
	leaq	8(%rbx), %rdx
	movl	(%rax), %eax
	movl	%eax, (%rdx)
	leaq	4(%rbx), %rax
	movl	(%rdx), %edx
	movl	%edx, (%rax)
	movl	(%rax), %eax
	movl	%eax, (%rbx)
	addq	$512, %rbx
.L58:
	cmpq	%r12, %rbx
	jbe	.L59
	movq	%rbx, -32(%rbp)
.L57:
	movq	-40(%rbp), %rax
	leaq	-1(%rax), %rdx
	movq	%rdx, -40(%rbp)
	testq	%rax, %rax
	jne	.L60
	movq	-32(%rbp), %rax
	movq	%rax, %rdi
	call	use_pointer@PLT
	nop
	addq	$32, %rsp
	popq	%rbx
	popq	%r12
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE16:
	.size	fwr, .-fwr
	.globl	frd
	.type	frd, @function
frd:
.LFB17:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$40, %rsp
	.cfi_offset 13, -24
	.cfi_offset 12, -32
	.cfi_offset 3, -40
	movq	%rdi, -56(%rbp)
	movq	%rsi, -64(%rbp)
	movq	-64(%rbp), %rax
	movq	%rax, -40(%rbp)
	movl	$0, %r12d
	movq	-40(%rbp), %rax
	movq	48(%rax), %r13
	jmp	.L62
.L65:
	movq	-40(%rbp), %rax
	movq	24(%rax), %rbx
	jmp	.L63
.L64:
	movl	(%rbx), %edx
	leaq	4(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	8(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	12(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	16(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	20(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	24(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	28(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	32(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	36(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	40(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	44(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	48(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	52(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	56(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	60(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	64(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	68(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	72(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	76(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	80(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	84(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	88(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	92(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	96(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	100(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	104(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	108(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	112(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	116(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	120(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	124(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	128(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	132(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	136(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	140(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	144(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	148(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	152(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	156(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	160(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	164(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	168(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	172(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	176(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	180(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	184(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	188(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	192(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	196(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	200(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	204(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	208(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	212(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	216(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	220(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	224(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	228(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	232(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	236(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	240(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	244(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	248(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	252(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	256(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	260(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	264(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	268(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	272(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	276(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	280(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	284(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	288(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	292(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	296(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	300(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	304(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	308(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	312(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	316(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	320(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	324(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	328(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	332(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	336(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	340(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	344(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	348(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	352(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	356(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	360(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	364(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	368(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	372(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	376(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	380(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	384(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	388(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	392(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	396(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	400(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	404(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	408(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	412(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	416(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	420(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	424(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	428(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	432(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	436(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	440(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	444(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	448(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	452(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	456(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	460(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	464(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	468(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	472(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	476(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	480(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	484(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	488(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	492(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	496(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	500(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	504(%rbx), %rax
	movl	(%rax), %eax
	addl	%eax, %edx
	leaq	508(%rbx), %rax
	movl	(%rax), %eax
	addl	%edx, %eax
	addl	%eax, %r12d
	addq	$512, %rbx
.L63:
	cmpq	%r13, %rbx
	jbe	.L64
.L62:
	movq	-56(%rbp), %rax
	leaq	-1(%rax), %rdx
	movq	%rdx, -56(%rbp)
	testq	%rax, %rax
	jne	.L65
	movl	%r12d, %edi
	call	use_int@PLT
	nop
	addq	$40, %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE17:
	.size	frd, .-frd
	.globl	fcp
	.type	fcp, @function
fcp:
.LFB18:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	.cfi_offset 13, -24
	.cfi_offset 12, -32
	.cfi_offset 3, -40
	movq	%rdi, -48(%rbp)
	movq	%rsi, -56(%rbp)
	movq	-56(%rbp), %rax
	movq	%rax, -32(%rbp)
	movq	-32(%rbp), %rax
	movq	48(%rax), %r13
	jmp	.L67
.L70:
	movq	-32(%rbp), %rax
	movq	24(%rax), %rbx
	movq	-32(%rbp), %rax
	movq	32(%rax), %r12
	jmp	.L68
.L69:
	movl	(%rbx), %eax
	movl	%eax, (%r12)
	leaq	4(%r12), %rax
	movl	4(%rbx), %edx
	movl	%edx, (%rax)
	leaq	8(%r12), %rax
	movl	8(%rbx), %edx
	movl	%edx, (%rax)
	leaq	12(%r12), %rax
	movl	12(%rbx), %edx
	movl	%edx, (%rax)
	leaq	16(%r12), %rax
	movl	16(%rbx), %edx
	movl	%edx, (%rax)
	leaq	20(%r12), %rax
	movl	20(%rbx), %edx
	movl	%edx, (%rax)
	leaq	24(%r12), %rax
	movl	24(%rbx), %edx
	movl	%edx, (%rax)
	leaq	28(%r12), %rax
	movl	28(%rbx), %edx
	movl	%edx, (%rax)
	leaq	32(%r12), %rax
	movl	32(%rbx), %edx
	movl	%edx, (%rax)
	leaq	36(%r12), %rax
	movl	36(%rbx), %edx
	movl	%edx, (%rax)
	leaq	40(%r12), %rax
	movl	40(%rbx), %edx
	movl	%edx, (%rax)
	leaq	44(%r12), %rax
	movl	44(%rbx), %edx
	movl	%edx, (%rax)
	leaq	48(%r12), %rax
	movl	48(%rbx), %edx
	movl	%edx, (%rax)
	leaq	52(%r12), %rax
	movl	52(%rbx), %edx
	movl	%edx, (%rax)
	leaq	56(%r12), %rax
	movl	56(%rbx), %edx
	movl	%edx, (%rax)
	leaq	60(%r12), %rax
	movl	60(%rbx), %edx
	movl	%edx, (%rax)
	leaq	64(%r12), %rax
	movl	64(%rbx), %edx
	movl	%edx, (%rax)
	leaq	68(%r12), %rax
	movl	68(%rbx), %edx
	movl	%edx, (%rax)
	leaq	72(%r12), %rax
	movl	72(%rbx), %edx
	movl	%edx, (%rax)
	leaq	76(%r12), %rax
	movl	76(%rbx), %edx
	movl	%edx, (%rax)
	leaq	80(%r12), %rax
	movl	80(%rbx), %edx
	movl	%edx, (%rax)
	leaq	84(%r12), %rax
	movl	84(%rbx), %edx
	movl	%edx, (%rax)
	leaq	88(%r12), %rax
	movl	88(%rbx), %edx
	movl	%edx, (%rax)
	leaq	92(%r12), %rax
	movl	92(%rbx), %edx
	movl	%edx, (%rax)
	leaq	96(%r12), %rax
	movl	96(%rbx), %edx
	movl	%edx, (%rax)
	leaq	100(%r12), %rax
	movl	100(%rbx), %edx
	movl	%edx, (%rax)
	leaq	104(%r12), %rax
	movl	104(%rbx), %edx
	movl	%edx, (%rax)
	leaq	108(%r12), %rax
	movl	108(%rbx), %edx
	movl	%edx, (%rax)
	leaq	112(%r12), %rax
	movl	112(%rbx), %edx
	movl	%edx, (%rax)
	leaq	116(%r12), %rax
	movl	116(%rbx), %edx
	movl	%edx, (%rax)
	leaq	120(%r12), %rax
	movl	120(%rbx), %edx
	movl	%edx, (%rax)
	leaq	124(%r12), %rax
	movl	124(%rbx), %edx
	movl	%edx, (%rax)
	leaq	128(%r12), %rax
	movl	128(%rbx), %edx
	movl	%edx, (%rax)
	leaq	132(%r12), %rax
	movl	132(%rbx), %edx
	movl	%edx, (%rax)
	leaq	136(%r12), %rax
	movl	136(%rbx), %edx
	movl	%edx, (%rax)
	leaq	140(%r12), %rax
	movl	140(%rbx), %edx
	movl	%edx, (%rax)
	leaq	144(%r12), %rax
	movl	144(%rbx), %edx
	movl	%edx, (%rax)
	leaq	148(%r12), %rax
	movl	148(%rbx), %edx
	movl	%edx, (%rax)
	leaq	152(%r12), %rax
	movl	152(%rbx), %edx
	movl	%edx, (%rax)
	leaq	156(%r12), %rax
	movl	156(%rbx), %edx
	movl	%edx, (%rax)
	leaq	160(%r12), %rax
	movl	160(%rbx), %edx
	movl	%edx, (%rax)
	leaq	164(%r12), %rax
	movl	164(%rbx), %edx
	movl	%edx, (%rax)
	leaq	168(%r12), %rax
	movl	168(%rbx), %edx
	movl	%edx, (%rax)
	leaq	172(%r12), %rax
	movl	172(%rbx), %edx
	movl	%edx, (%rax)
	leaq	176(%r12), %rax
	movl	176(%rbx), %edx
	movl	%edx, (%rax)
	leaq	180(%r12), %rax
	movl	180(%rbx), %edx
	movl	%edx, (%rax)
	leaq	184(%r12), %rax
	movl	184(%rbx), %edx
	movl	%edx, (%rax)
	leaq	188(%r12), %rax
	movl	188(%rbx), %edx
	movl	%edx, (%rax)
	leaq	192(%r12), %rax
	movl	192(%rbx), %edx
	movl	%edx, (%rax)
	leaq	196(%r12), %rax
	movl	196(%rbx), %edx
	movl	%edx, (%rax)
	leaq	200(%r12), %rax
	movl	200(%rbx), %edx
	movl	%edx, (%rax)
	leaq	204(%r12), %rax
	movl	204(%rbx), %edx
	movl	%edx, (%rax)
	leaq	208(%r12), %rax
	movl	208(%rbx), %edx
	movl	%edx, (%rax)
	leaq	212(%r12), %rax
	movl	212(%rbx), %edx
	movl	%edx, (%rax)
	leaq	216(%r12), %rax
	movl	216(%rbx), %edx
	movl	%edx, (%rax)
	leaq	220(%r12), %rax
	movl	220(%rbx), %edx
	movl	%edx, (%rax)
	leaq	224(%r12), %rax
	movl	224(%rbx), %edx
	movl	%edx, (%rax)
	leaq	228(%r12), %rax
	movl	228(%rbx), %edx
	movl	%edx, (%rax)
	leaq	232(%r12), %rax
	movl	232(%rbx), %edx
	movl	%edx, (%rax)
	leaq	236(%r12), %rax
	movl	236(%rbx), %edx
	movl	%edx, (%rax)
	leaq	240(%r12), %rax
	movl	240(%rbx), %edx
	movl	%edx, (%rax)
	leaq	244(%r12), %rax
	movl	244(%rbx), %edx
	movl	%edx, (%rax)
	leaq	248(%r12), %rax
	movl	248(%rbx), %edx
	movl	%edx, (%rax)
	leaq	252(%r12), %rax
	movl	252(%rbx), %edx
	movl	%edx, (%rax)
	leaq	256(%r12), %rax
	movl	256(%rbx), %edx
	movl	%edx, (%rax)
	leaq	260(%r12), %rax
	movl	260(%rbx), %edx
	movl	%edx, (%rax)
	leaq	264(%r12), %rax
	movl	264(%rbx), %edx
	movl	%edx, (%rax)
	leaq	268(%r12), %rax
	movl	268(%rbx), %edx
	movl	%edx, (%rax)
	leaq	272(%r12), %rax
	movl	272(%rbx), %edx
	movl	%edx, (%rax)
	leaq	276(%r12), %rax
	movl	276(%rbx), %edx
	movl	%edx, (%rax)
	leaq	280(%r12), %rax
	movl	280(%rbx), %edx
	movl	%edx, (%rax)
	leaq	284(%r12), %rax
	movl	284(%rbx), %edx
	movl	%edx, (%rax)
	leaq	288(%r12), %rax
	movl	288(%rbx), %edx
	movl	%edx, (%rax)
	leaq	292(%r12), %rax
	movl	292(%rbx), %edx
	movl	%edx, (%rax)
	leaq	296(%r12), %rax
	movl	296(%rbx), %edx
	movl	%edx, (%rax)
	leaq	300(%r12), %rax
	movl	300(%rbx), %edx
	movl	%edx, (%rax)
	leaq	304(%r12), %rax
	movl	304(%rbx), %edx
	movl	%edx, (%rax)
	leaq	308(%r12), %rax
	movl	308(%rbx), %edx
	movl	%edx, (%rax)
	leaq	312(%r12), %rax
	movl	312(%rbx), %edx
	movl	%edx, (%rax)
	leaq	316(%r12), %rax
	movl	316(%rbx), %edx
	movl	%edx, (%rax)
	leaq	320(%r12), %rax
	movl	320(%rbx), %edx
	movl	%edx, (%rax)
	leaq	324(%r12), %rax
	movl	324(%rbx), %edx
	movl	%edx, (%rax)
	leaq	328(%r12), %rax
	movl	328(%rbx), %edx
	movl	%edx, (%rax)
	leaq	332(%r12), %rax
	movl	332(%rbx), %edx
	movl	%edx, (%rax)
	leaq	336(%r12), %rax
	movl	336(%rbx), %edx
	movl	%edx, (%rax)
	leaq	340(%r12), %rax
	movl	340(%rbx), %edx
	movl	%edx, (%rax)
	leaq	344(%r12), %rax
	movl	344(%rbx), %edx
	movl	%edx, (%rax)
	leaq	348(%r12), %rax
	movl	348(%rbx), %edx
	movl	%edx, (%rax)
	leaq	352(%r12), %rax
	movl	352(%rbx), %edx
	movl	%edx, (%rax)
	leaq	356(%r12), %rax
	movl	356(%rbx), %edx
	movl	%edx, (%rax)
	leaq	360(%r12), %rax
	movl	360(%rbx), %edx
	movl	%edx, (%rax)
	leaq	364(%r12), %rax
	movl	364(%rbx), %edx
	movl	%edx, (%rax)
	leaq	368(%r12), %rax
	movl	368(%rbx), %edx
	movl	%edx, (%rax)
	leaq	372(%r12), %rax
	movl	372(%rbx), %edx
	movl	%edx, (%rax)
	leaq	376(%r12), %rax
	movl	376(%rbx), %edx
	movl	%edx, (%rax)
	leaq	380(%r12), %rax
	movl	380(%rbx), %edx
	movl	%edx, (%rax)
	leaq	384(%r12), %rax
	movl	384(%rbx), %edx
	movl	%edx, (%rax)
	leaq	388(%r12), %rax
	movl	388(%rbx), %edx
	movl	%edx, (%rax)
	leaq	392(%r12), %rax
	movl	392(%rbx), %edx
	movl	%edx, (%rax)
	leaq	396(%r12), %rax
	movl	396(%rbx), %edx
	movl	%edx, (%rax)
	leaq	400(%r12), %rax
	movl	400(%rbx), %edx
	movl	%edx, (%rax)
	leaq	404(%r12), %rax
	movl	404(%rbx), %edx
	movl	%edx, (%rax)
	leaq	408(%r12), %rax
	movl	408(%rbx), %edx
	movl	%edx, (%rax)
	leaq	412(%r12), %rax
	movl	412(%rbx), %edx
	movl	%edx, (%rax)
	leaq	416(%r12), %rax
	movl	416(%rbx), %edx
	movl	%edx, (%rax)
	leaq	420(%r12), %rax
	movl	420(%rbx), %edx
	movl	%edx, (%rax)
	leaq	424(%r12), %rax
	movl	424(%rbx), %edx
	movl	%edx, (%rax)
	leaq	428(%r12), %rax
	movl	428(%rbx), %edx
	movl	%edx, (%rax)
	leaq	432(%r12), %rax
	movl	432(%rbx), %edx
	movl	%edx, (%rax)
	leaq	436(%r12), %rax
	movl	436(%rbx), %edx
	movl	%edx, (%rax)
	leaq	440(%r12), %rax
	movl	440(%rbx), %edx
	movl	%edx, (%rax)
	leaq	444(%r12), %rax
	movl	444(%rbx), %edx
	movl	%edx, (%rax)
	leaq	448(%r12), %rax
	movl	448(%rbx), %edx
	movl	%edx, (%rax)
	leaq	452(%r12), %rax
	movl	452(%rbx), %edx
	movl	%edx, (%rax)
	leaq	456(%r12), %rax
	movl	456(%rbx), %edx
	movl	%edx, (%rax)
	leaq	460(%r12), %rax
	movl	460(%rbx), %edx
	movl	%edx, (%rax)
	leaq	464(%r12), %rax
	movl	464(%rbx), %edx
	movl	%edx, (%rax)
	leaq	468(%r12), %rax
	movl	468(%rbx), %edx
	movl	%edx, (%rax)
	leaq	472(%r12), %rax
	movl	472(%rbx), %edx
	movl	%edx, (%rax)
	leaq	476(%r12), %rax
	movl	476(%rbx), %edx
	movl	%edx, (%rax)
	leaq	480(%r12), %rax
	movl	480(%rbx), %edx
	movl	%edx, (%rax)
	leaq	484(%r12), %rax
	movl	484(%rbx), %edx
	movl	%edx, (%rax)
	leaq	488(%r12), %rax
	movl	488(%rbx), %edx
	movl	%edx, (%rax)
	leaq	492(%r12), %rax
	movl	492(%rbx), %edx
	movl	%edx, (%rax)
	leaq	496(%r12), %rax
	movl	496(%rbx), %edx
	movl	%edx, (%rax)
	leaq	500(%r12), %rax
	movl	500(%rbx), %edx
	movl	%edx, (%rax)
	leaq	504(%r12), %rax
	movl	504(%rbx), %edx
	movl	%edx, (%rax)
	leaq	508(%r12), %rax
	movl	508(%rbx), %edx
	movl	%edx, (%rax)
	addq	$512, %rbx
	addq	$512, %r12
.L68:
	cmpq	%r13, %rbx
	jbe	.L69
.L67:
	movq	-48(%rbp), %rax
	leaq	-1(%rax), %rdx
	movq	%rdx, -48(%rbp)
	testq	%rax, %rax
	jne	.L70
	nop
	nop
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE18:
	.size	fcp, .-fcp
	.globl	loop_bzero
	.type	loop_bzero, @function
loop_bzero:
.LFB19:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r12
	pushq	%rbx
	subq	$32, %rsp
	.cfi_offset 12, -24
	.cfi_offset 3, -32
	movq	%rdi, -40(%rbp)
	movq	%rsi, -48(%rbp)
	movq	-48(%rbp), %rax
	movq	%rax, -24(%rbp)
	movq	-24(%rbp), %rax
	movq	24(%rax), %rbx
	movq	-24(%rbp), %rax
	movq	56(%rax), %r12
	jmp	.L72
.L73:
	movq	%rbx, %rax
	movq	%r12, %rdx
	movl	$0, %esi
	movq	%rax, %rdi
	call	memset@PLT
.L72:
	movq	-40(%rbp), %rax
	leaq	-1(%rax), %rdx
	movq	%rdx, -40(%rbp)
	testq	%rax, %rax
	jne	.L73
	nop
	nop
	addq	$32, %rsp
	popq	%rbx
	popq	%r12
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE19:
	.size	loop_bzero, .-loop_bzero
	.globl	loop_bcopy
	.type	loop_bcopy, @function
loop_bcopy:
.LFB20:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$40, %rsp
	.cfi_offset 13, -24
	.cfi_offset 12, -32
	.cfi_offset 3, -40
	movq	%rdi, -56(%rbp)
	movq	%rsi, -64(%rbp)
	movq	-64(%rbp), %rax
	movq	%rax, -40(%rbp)
	movq	-40(%rbp), %rax
	movq	24(%rax), %rbx
	movq	-40(%rbp), %rax
	movq	32(%rax), %r12
	movq	-40(%rbp), %rax
	movq	56(%rax), %r13
	jmp	.L75
.L76:
	movq	%r13, %rdx
	movq	%rbx, %rsi
	movq	%r12, %rdi
	call	memmove@PLT
.L75:
	movq	-56(%rbp), %rax
	leaq	-1(%rax), %rdx
	movq	%rdx, -56(%rbp)
	testq	%rax, %rax
	jne	.L76
	nop
	nop
	addq	$40, %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE20:
	.size	loop_bcopy, .-loop_bcopy
	.section	.rodata
.LC16:
	.string	"%.6f "
.LC17:
	.string	"%.2f "
.LC18:
	.string	"%.6f\n"
.LC19:
	.string	"%.2f\n"
	.text
	.globl	adjusted_bandwidth
	.type	adjusted_bandwidth, @function
adjusted_bandwidth:
.LFB21:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$48, %rsp
	movq	%rdi, -24(%rbp)
	movq	%rsi, -32(%rbp)
	movq	%rdx, -40(%rbp)
	movsd	%xmm0, -48(%rbp)
	movq	-24(%rbp), %rax
	testq	%rax, %rax
	js	.L78
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L79
.L78:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L79:
	movq	-40(%rbp), %rax
	testq	%rax, %rax
	js	.L80
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rax, %xmm1
	jmp	.L81
.L80:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rdx, %xmm1
	addsd	%xmm1, %xmm1
.L81:
	divsd	%xmm1, %xmm0
	subsd	-48(%rbp), %xmm0
	movsd	.LC14(%rip), %xmm1
	divsd	%xmm1, %xmm0
	movsd	%xmm0, -16(%rbp)
	movq	-32(%rbp), %rax
	testq	%rax, %rax
	js	.L82
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L83
.L82:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L83:
	movsd	.LC14(%rip), %xmm1
	divsd	%xmm1, %xmm0
	movsd	%xmm0, -8(%rbp)
	pxor	%xmm0, %xmm0
	comisd	-16(%rbp), %xmm0
	jnb	.L97
	movq	ftiming(%rip), %rax
	testq	%rax, %rax
	jne	.L87
	movq	stderr(%rip), %rax
	movq	%rax, ftiming(%rip)
.L87:
	movsd	.LC15(%rip), %xmm0
	comisd	-8(%rbp), %xmm0
	jbe	.L95
	movq	ftiming(%rip), %rax
	movq	-8(%rbp), %rdx
	movq	%rdx, %xmm0
	leaq	.LC16(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	movl	$1, %eax
	call	fprintf@PLT
	jmp	.L90
.L95:
	movq	ftiming(%rip), %rax
	movq	-8(%rbp), %rdx
	movq	%rdx, %xmm0
	leaq	.LC17(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	movl	$1, %eax
	call	fprintf@PLT
.L90:
	movsd	-8(%rbp), %xmm0
	movapd	%xmm0, %xmm1
	divsd	-16(%rbp), %xmm1
	movsd	.LC15(%rip), %xmm0
	comisd	%xmm1, %xmm0
	jbe	.L96
	movsd	-8(%rbp), %xmm0
	divsd	-16(%rbp), %xmm0
	movq	%xmm0, %rdx
	movq	ftiming(%rip), %rax
	movq	%rdx, %xmm0
	leaq	.LC18(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	movl	$1, %eax
	call	fprintf@PLT
	jmp	.L77
.L96:
	movsd	-8(%rbp), %xmm0
	divsd	-16(%rbp), %xmm0
	movq	%xmm0, %rdx
	movq	ftiming(%rip), %rax
	movq	%rdx, %xmm0
	leaq	.LC19(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	movl	$1, %eax
	call	fprintf@PLT
	jmp	.L77
.L97:
	nop
.L77:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE21:
	.size	adjusted_bandwidth, .-adjusted_bandwidth
	.section	.rodata
	.align 8
.LC14:
	.long	0
	.long	1093567616
	.align 8
.LC15:
	.long	0
	.long	1072693248
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
