	.file	"lat_fs.c"
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
	.string	"[-s <file size>] [-n <max files per dir>] [-P <parallelism>] [-W <warmup>] [-N <repetitions>] [<dir>]\n"
.LC2:
	.string	"s:n:P:W:N:"
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
	subq	$112, %rsp
	movl	%edi, -100(%rbp)
	movq	%rsi, -112(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movl	$1, -88(%rbp)
	movl	$0, -84(%rbp)
	movl	$-1, -80(%rbp)
	leaq	.LC1(%rip), %rax
	movq	%rax, -72(%rbp)
	movq	$0, -16(%rbp)
	movq	$100, -56(%rbp)
	movq	$0, -64(%rbp)
	jmp	.L2
.L11:
	movl	-76(%rbp), %eax
	subl	$78, %eax
	cmpl	$37, %eax
	ja	.L3
	movl	%eax, %eax
	leaq	0(,%rax,4), %rdx
	leaq	.L5(%rip), %rax
	movl	(%rdx,%rax), %eax
	cltq
	leaq	.L5(%rip), %rdx
	addq	%rdx, %rax
	notrack jmp	*%rax
	.section	.rodata
	.align 4
	.align 4
.L5:
	.long	.L9-.L5
	.long	.L3-.L5
	.long	.L8-.L5
	.long	.L3-.L5
	.long	.L3-.L5
	.long	.L3-.L5
	.long	.L3-.L5
	.long	.L3-.L5
	.long	.L3-.L5
	.long	.L7-.L5
	.long	.L3-.L5
	.long	.L3-.L5
	.long	.L3-.L5
	.long	.L3-.L5
	.long	.L3-.L5
	.long	.L3-.L5
	.long	.L3-.L5
	.long	.L3-.L5
	.long	.L3-.L5
	.long	.L3-.L5
	.long	.L3-.L5
	.long	.L3-.L5
	.long	.L3-.L5
	.long	.L3-.L5
	.long	.L3-.L5
	.long	.L3-.L5
	.long	.L3-.L5
	.long	.L3-.L5
	.long	.L3-.L5
	.long	.L3-.L5
	.long	.L3-.L5
	.long	.L3-.L5
	.long	.L6-.L5
	.long	.L3-.L5
	.long	.L3-.L5
	.long	.L3-.L5
	.long	.L3-.L5
	.long	.L4-.L5
	.text
.L4:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	bytes@PLT
	movq	%rax, -16(%rbp)
	jmp	.L2
.L6:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	bytes@PLT
	movq	%rax, -56(%rbp)
	jmp	.L2
.L8:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -88(%rbp)
	cmpl	$0, -88(%rbp)
	jg	.L2
	movq	-72(%rbp), %rdx
	movq	-112(%rbp), %rcx
	movl	-100(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	lmbench_usage@PLT
	jmp	.L2
.L7:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -84(%rbp)
	jmp	.L2
.L9:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -80(%rbp)
	jmp	.L2
.L3:
	movq	-72(%rbp), %rdx
	movq	-112(%rbp), %rcx
	movl	-100(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	lmbench_usage@PLT
	nop
.L2:
	movq	-112(%rbp), %rcx
	movl	-100(%rbp), %eax
	leaq	.LC2(%rip), %rdx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	mygetopt@PLT
	movl	%eax, -76(%rbp)
	cmpl	$-1, -76(%rbp)
	jne	.L11
	movl	-100(%rbp), %eax
	leal	-1(%rax), %edx
	movl	myoptind(%rip), %eax
	cmpl	%eax, %edx
	jle	.L12
	movq	-72(%rbp), %rdx
	movq	-112(%rbp), %rcx
	movl	-100(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	lmbench_usage@PLT
.L12:
	movl	-100(%rbp), %eax
	leal	-1(%rax), %edx
	movl	myoptind(%rip), %eax
	cmpl	%eax, %edx
	jne	.L13
	movq	-112(%rbp), %rax
	movq	8(%rax), %rax
	movq	%rax, -64(%rbp)
.L13:
	movq	-16(%rbp), %rax
	testq	%rax, %rax
	je	.L14
	movq	-16(%rbp), %rax
	leaq	-64(%rbp), %rdi
	movl	-80(%rbp), %ecx
	movl	-84(%rbp), %edx
	movl	-88(%rbp), %esi
	movq	%rdi, %r8
	movq	%rax, %rdi
	call	measure
	jmp	.L15
.L14:
	movl	$0, -92(%rbp)
	jmp	.L16
.L17:
	movl	-92(%rbp), %eax
	cltq
	leaq	0(,%rax,4), %rdx
	leaq	sizes.0(%rip), %rax
	movl	(%rdx,%rax), %eax
	cltq
	movq	%rax, -16(%rbp)
	movq	-16(%rbp), %rax
	leaq	-64(%rbp), %rdi
	movl	-80(%rbp), %ecx
	movl	-84(%rbp), %edx
	movl	-88(%rbp), %esi
	movq	%rdi, %r8
	movq	%rax, %rdi
	call	measure
	addl	$1, -92(%rbp)
.L16:
	movl	-92(%rbp), %eax
	cmpl	$3, %eax
	jbe	.L17
.L15:
	movl	$0, %eax
	movq	-8(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L19
	call	__stack_chk_fail@PLT
.L19:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE8:
	.size	main, .-main
	.section	.rodata
.LC3:
	.string	"%luk"
.LC5:
	.string	"\t%lu\t%.0f"
.LC6:
	.string	"\t-1\t-1"
.LC7:
	.string	"\t%.0f"
.LC8:
	.string	"\t-1"
	.text
	.globl	measure
	.type	measure, @function
measure:
.LFB9:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%rbx
	subq	$56, %rsp
	.cfi_offset 3, -24
	movq	%rdi, -24(%rbp)
	movl	%esi, -28(%rbp)
	movl	%edx, -32(%rbp)
	movl	%ecx, -36(%rbp)
	movq	%r8, -48(%rbp)
	movq	-24(%rbp), %rax
	shrq	$10, %rax
	movq	%rax, %rdx
	movq	stderr(%rip), %rax
	leaq	.LC3(%rip), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf@PLT
	movl	-32(%rbp), %ecx
	movl	-28(%rbp), %edx
	pushq	-48(%rbp)
	movl	-36(%rbp), %eax
	pushq	%rax
	movl	%ecx, %r9d
	movl	%edx, %r8d
	movl	$0, %ecx
	leaq	cleanup_mk(%rip), %rax
	movq	%rax, %rdx
	leaq	benchmark_mk(%rip), %rax
	movq	%rax, %rsi
	leaq	setup_names(%rip), %rax
	movq	%rax, %rdi
	call	benchmp@PLT
	addq	$16, %rsp
	call	usecs_spent@PLT
	testq	%rax, %rax
	je	.L21
	call	get_n@PLT
	testq	%rax, %rax
	js	.L22
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L23
.L22:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L23:
	movsd	.LC4(%rip), %xmm1
	mulsd	%xmm1, %xmm0
	movsd	%xmm0, -56(%rbp)
	call	usecs_spent@PLT
	testq	%rax, %rax
	js	.L24
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L25
.L24:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L25:
	movsd	-56(%rbp), %xmm2
	divsd	%xmm0, %xmm2
	movq	%xmm2, %rbx
	call	get_n@PLT
	movq	%rax, %rdx
	movq	stderr(%rip), %rax
	movq	%rbx, %xmm0
	leaq	.LC5(%rip), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	movl	$1, %eax
	call	fprintf@PLT
	jmp	.L26
.L21:
	movq	stderr(%rip), %rax
	movq	%rax, %rcx
	movl	$6, %edx
	movl	$1, %esi
	leaq	.LC6(%rip), %rax
	movq	%rax, %rdi
	call	fwrite@PLT
.L26:
	movl	-32(%rbp), %ecx
	movl	-28(%rbp), %edx
	pushq	-48(%rbp)
	movl	-36(%rbp), %eax
	pushq	%rax
	movl	%ecx, %r9d
	movl	%edx, %r8d
	movl	$0, %ecx
	leaq	cleanup_names(%rip), %rax
	movq	%rax, %rdx
	leaq	benchmark_rm(%rip), %rax
	movq	%rax, %rsi
	leaq	setup_rm(%rip), %rax
	movq	%rax, %rdi
	call	benchmp@PLT
	addq	$16, %rsp
	call	usecs_spent@PLT
	testq	%rax, %rax
	je	.L27
	call	get_n@PLT
	testq	%rax, %rax
	js	.L28
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L29
.L28:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L29:
	movsd	.LC4(%rip), %xmm1
	mulsd	%xmm1, %xmm0
	movsd	%xmm0, -56(%rbp)
	call	usecs_spent@PLT
	testq	%rax, %rax
	js	.L30
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L31
.L30:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L31:
	movsd	-56(%rbp), %xmm3
	divsd	%xmm0, %xmm3
	movq	%xmm3, %rdx
	movq	stderr(%rip), %rax
	movq	%rdx, %xmm0
	leaq	.LC7(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	movl	$1, %eax
	call	fprintf@PLT
	jmp	.L32
.L27:
	movq	stderr(%rip), %rax
	movq	%rax, %rcx
	movl	$3, %edx
	movl	$1, %esi
	leaq	.LC8(%rip), %rax
	movq	%rax, %rdi
	call	fwrite@PLT
.L32:
	movq	stderr(%rip), %rax
	movq	%rax, %rsi
	movl	$10, %edi
	call	fputc@PLT
	nop
	movq	-8(%rbp), %rbx
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE9:
	.size	measure, .-measure
	.globl	mkfile
	.type	mkfile, @function
mkfile:
.LFB10:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	leaq	-131072(%rsp), %r11
.LPSRL0:
	subq	$4096, %rsp
	orq	$0, (%rsp)
	cmpq	%r11, %rsp
	jne	.LPSRL0
	subq	$48, %rsp
	movq	%rdi, -131112(%rbp)
	movq	%rsi, -131120(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movq	-131112(%rbp), %rax
	movl	$438, %esi
	movq	%rax, %rdi
	call	creat@PLT
	movl	%eax, -131100(%rbp)
	jmp	.L34
.L35:
	movq	-131120(%rbp), %rax
	movl	$131072, %edx
	cmpq	%rdx, %rax
	cmova	%rdx, %rax
	movq	%rax, -131096(%rbp)
	movq	-131096(%rbp), %rdx
	leaq	-131088(%rbp), %rcx
	movl	-131100(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	write@PLT
	movq	-131096(%rbp), %rax
	subq	%rax, -131120(%rbp)
.L34:
	cmpq	$0, -131120(%rbp)
	jne	.L35
	movl	-131100(%rbp), %eax
	movl	%eax, %edi
	call	close@PLT
	nop
	movq	-8(%rbp), %rax
	subq	%fs:40, %rax
	je	.L36
	call	__stack_chk_fail@PLT
.L36:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE10:
	.size	mkfile, .-mkfile
	.section	.rodata
.LC9:
	.string	"%s/%ld"
	.text
	.globl	setup_names_recurse
	.type	setup_names_recurse, @function
setup_names_recurse:
.LFB11:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%rbx
	subq	$4096, %rsp
	orq	$0, (%rsp)
	subq	$4096, %rsp
	orq	$0, (%rsp)
	subq	$104, %rsp
	.cfi_offset 3, -24
	movq	%rdi, -8280(%rbp)
	movq	%rsi, -8288(%rbp)
	movl	%edx, -8292(%rbp)
	movq	%rcx, -8304(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -24(%rbp)
	xorl	%eax, %eax
	movq	-8304(%rbp), %rax
	movq	40(%rax), %rdx
	movq	-8288(%rbp), %rax
	movq	(%rax), %rax
	salq	$3, %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	%rax, -8256(%rbp)
	cmpl	$0, -8292(%rbp)
	jle	.L38
	movq	-8304(%rbp), %rax
	movq	8(%rax), %rax
	movq	%rax, -8264(%rbp)
	movq	$1, -8272(%rbp)
	jmp	.L39
.L40:
	movq	-8304(%rbp), %rax
	movq	8(%rax), %rax
	movq	-8264(%rbp), %rdx
	imulq	%rdx, %rax
	movq	%rax, -8264(%rbp)
	addq	$1, -8272(%rbp)
.L39:
	movl	-8292(%rbp), %eax
	cltq
	cmpq	%rax, -8272(%rbp)
	jl	.L40
	movq	-8304(%rbp), %rax
	movq	16(%rax), %rax
	movq	%rax, %rcx
	movq	-8280(%rbp), %rax
	movq	(%rax), %rdx
	movq	%rcx, %rax
	subq	%rdx, %rax
	movq	-8264(%rbp), %rbx
	movl	$0, %edx
	divq	%rbx
	addq	$1, %rax
	movq	%rax, -8248(%rbp)
	movq	$0, -8272(%rbp)
	jmp	.L41
.L43:
	movq	-8272(%rbp), %rcx
	movq	-8256(%rbp), %rdx
	leaq	-8240(%rbp), %rax
	leaq	.LC9(%rip), %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	sprintf@PLT
	movq	-8304(%rbp), %rax
	movq	40(%rax), %rcx
	movq	-8288(%rbp), %rax
	movq	(%rax), %rax
	leaq	1(%rax), %rdx
	movq	-8288(%rbp), %rax
	movq	%rdx, (%rax)
	movq	-8288(%rbp), %rax
	movq	(%rax), %rax
	salq	$3, %rax
	leaq	(%rcx,%rax), %rbx
	leaq	-8240(%rbp), %rax
	movq	%rax, %rdi
	call	strdup@PLT
	movq	%rax, (%rbx)
	leaq	-8240(%rbp), %rax
	movl	$511, %esi
	movq	%rax, %rdi
	call	mkdir@PLT
	movl	-8292(%rbp), %eax
	leal	-1(%rax), %edi
	movq	-8304(%rbp), %rdx
	movq	-8288(%rbp), %rsi
	movq	-8280(%rbp), %rax
	movq	%rdx, %rcx
	movl	%edi, %edx
	movq	%rax, %rdi
	call	setup_names_recurse
	addq	$1, -8272(%rbp)
.L41:
	movq	-8304(%rbp), %rax
	movq	8(%rax), %rax
	cmpq	%rax, -8272(%rbp)
	jge	.L47
	movq	-8272(%rbp), %rax
	cmpq	-8248(%rbp), %rax
	jge	.L47
	movq	-8280(%rbp), %rax
	movq	(%rax), %rdx
	movq	-8304(%rbp), %rax
	movq	16(%rax), %rax
	cmpq	%rax, %rdx
	jb	.L43
	jmp	.L47
.L38:
	movq	$0, -8272(%rbp)
	jmp	.L44
.L45:
	movq	-8272(%rbp), %rcx
	movq	-8256(%rbp), %rdx
	leaq	-8240(%rbp), %rax
	leaq	.LC9(%rip), %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	sprintf@PLT
	movq	-8304(%rbp), %rax
	movq	24(%rax), %rsi
	movq	-8280(%rbp), %rax
	movq	(%rax), %rax
	leaq	1(%rax), %rcx
	movq	-8280(%rbp), %rdx
	movq	%rcx, (%rdx)
	salq	$3, %rax
	leaq	(%rsi,%rax), %rbx
	leaq	-8240(%rbp), %rax
	movq	%rax, %rdi
	call	strdup@PLT
	movq	%rax, (%rbx)
	addq	$1, -8272(%rbp)
.L44:
	movq	-8304(%rbp), %rax
	movq	8(%rax), %rax
	cmpq	%rax, -8272(%rbp)
	jge	.L47
	movq	-8280(%rbp), %rax
	movq	(%rax), %rdx
	movq	-8304(%rbp), %rax
	movq	16(%rax), %rax
	cmpq	%rax, %rdx
	jb	.L45
.L47:
	nop
	movq	-24(%rbp), %rax
	subq	%fs:40, %rax
	je	.L46
	call	__stack_chk_fail@PLT
.L46:
	movq	-8(%rbp), %rbx
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE11:
	.size	setup_names_recurse, .-setup_names_recurse
	.section	.rodata
.LC10:
	.string	"malloc"
.LC11:
	.string	"lat_fs_%d_XXXXXX"
.LC12:
	.string	"tempnam failed"
.LC13:
	.string	"mkdir failed"
	.align 8
.LC14:
	.string	"setup_names: ERROR: foff=%lu, iterations=%lu, doff=%lu, ndirs=%lu, depth=%ld\n"
	.text
	.globl	setup_names
	.type	setup_names, @function
setup_names:
.LFB12:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$368, %rsp
	movq	%rdi, -360(%rbp)
	movq	%rsi, -368(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movq	-368(%rbp), %rax
	movq	%rax, -304(%rbp)
	cmpq	$0, -360(%rbp)
	je	.L68
	movq	$0, -312(%rbp)
	movq	-360(%rbp), %rdx
	movq	-304(%rbp), %rax
	movq	%rdx, 16(%rax)
	movq	-304(%rbp), %rax
	movq	8(%rax), %rax
	movq	%rax, %rcx
	movq	-360(%rbp), %rax
	movl	$0, %edx
	divq	%rcx
	movq	%rax, %rdx
	movq	-304(%rbp), %rax
	movq	%rdx, 32(%rax)
	movq	-304(%rbp), %rax
	movq	8(%rax), %rax
	movq	%rax, %rcx
	movq	-360(%rbp), %rax
	movl	$0, %edx
	divq	%rcx
	movq	%rdx, %rax
	testq	%rax, %rax
	je	.L51
	movq	-304(%rbp), %rax
	movq	32(%rax), %rax
	leaq	1(%rax), %rdx
	movq	-304(%rbp), %rax
	movq	%rdx, 32(%rax)
.L51:
	movq	-304(%rbp), %rax
	movq	32(%rax), %rax
	movq	%rax, -320(%rbp)
	jmp	.L52
.L55:
	movq	-304(%rbp), %rax
	movq	8(%rax), %rcx
	movq	-320(%rbp), %rax
	cqto
	idivq	%rcx
	movq	%rax, %rsi
	movq	-304(%rbp), %rax
	movq	8(%rax), %rcx
	movq	-320(%rbp), %rax
	cqto
	idivq	%rcx
	movq	%rdx, %rax
	testq	%rax, %rax
	je	.L53
	movl	$1, %eax
	jmp	.L54
.L53:
	movl	$0, %eax
.L54:
	addq	%rsi, %rax
	movq	%rax, -320(%rbp)
	movq	-304(%rbp), %rax
	movq	32(%rax), %rdx
	movq	-320(%rbp), %rax
	addq	%rax, %rdx
	movq	-304(%rbp), %rax
	movq	%rdx, 32(%rax)
	addq	$1, -312(%rbp)
.L52:
	cmpq	$1, -320(%rbp)
	jg	.L55
	movq	-360(%rbp), %rax
	salq	$3, %rax
	movq	%rax, %rdi
	call	malloc@PLT
	movq	%rax, %rdx
	movq	-304(%rbp), %rax
	movq	%rdx, 24(%rax)
	movq	-304(%rbp), %rax
	movq	32(%rax), %rax
	salq	$3, %rax
	movq	%rax, %rdi
	call	malloc@PLT
	movq	%rax, %rdx
	movq	-304(%rbp), %rax
	movq	%rdx, 40(%rax)
	cmpq	$0, -360(%rbp)
	je	.L56
	movq	-304(%rbp), %rax
	movq	24(%rax), %rax
	testq	%rax, %rax
	je	.L57
.L56:
	movq	-304(%rbp), %rax
	movq	32(%rax), %rax
	testq	%rax, %rax
	je	.L58
	movq	-304(%rbp), %rax
	movq	40(%rax), %rax
	testq	%rax, %rax
	jne	.L58
.L57:
	leaq	.LC10(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L58:
	movq	$0, -328(%rbp)
	jmp	.L59
.L60:
	movq	-304(%rbp), %rax
	movq	24(%rax), %rdx
	movq	-328(%rbp), %rax
	salq	$3, %rax
	addq	%rdx, %rax
	movq	$0, (%rax)
	addq	$1, -328(%rbp)
.L59:
	movq	-328(%rbp), %rax
	cmpq	%rax, -360(%rbp)
	ja	.L60
	movq	$0, -328(%rbp)
	jmp	.L61
.L62:
	movq	-304(%rbp), %rax
	movq	40(%rax), %rdx
	movq	-328(%rbp), %rax
	salq	$3, %rax
	addq	%rdx, %rax
	movq	$0, (%rax)
	addq	$1, -328(%rbp)
.L61:
	movq	-304(%rbp), %rax
	movq	32(%rax), %rax
	cmpq	%rax, -328(%rbp)
	jl	.L62
	call	getpid@PLT
	movl	%eax, %edx
	leaq	-288(%rbp), %rax
	leaq	.LC11(%rip), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	sprintf@PLT
	movq	-304(%rbp), %rax
	movq	(%rax), %rax
	leaq	-288(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	tempnam@PLT
	movq	%rax, -296(%rbp)
	cmpq	$0, -296(%rbp)
	jne	.L63
	leaq	.LC12(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L63:
	movq	-296(%rbp), %rax
	movl	$448, %esi
	movq	%rax, %rdi
	call	mkdir@PLT
	testl	%eax, %eax
	je	.L64
	leaq	.LC13(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L64:
	movq	-304(%rbp), %rax
	movq	40(%rax), %rax
	movq	-296(%rbp), %rdx
	movq	%rdx, (%rax)
	movq	$0, -344(%rbp)
	movq	$0, -336(%rbp)
	movq	-312(%rbp), %rax
	movl	%eax, %edi
	movq	-304(%rbp), %rdx
	leaq	-336(%rbp), %rsi
	leaq	-344(%rbp), %rax
	movq	%rdx, %rcx
	movl	%edi, %edx
	movq	%rax, %rdi
	call	setup_names_recurse
	movq	-344(%rbp), %rax
	cmpq	%rax, -360(%rbp)
	jne	.L65
	movq	-304(%rbp), %rax
	movq	32(%rax), %rax
	leaq	-1(%rax), %rdx
	movq	-336(%rbp), %rax
	cmpq	%rax, %rdx
	je	.L48
.L65:
	movq	-304(%rbp), %rax
	movq	32(%rax), %rax
	movq	%rax, %rdi
	movq	-336(%rbp), %rsi
	movq	-344(%rbp), %rdx
	movq	stderr(%rip), %rax
	movq	-360(%rbp), %rcx
	subq	$8, %rsp
	pushq	-312(%rbp)
	movq	%rdi, %r9
	movq	%rsi, %r8
	leaq	.LC14(%rip), %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf@PLT
	addq	$16, %rsp
	jmp	.L48
.L68:
	nop
.L48:
	movq	-8(%rbp), %rax
	subq	%fs:40, %rax
	je	.L67
	call	__stack_chk_fail@PLT
.L67:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE12:
	.size	setup_names, .-setup_names
	.globl	cleanup_names
	.type	cleanup_names, @function
cleanup_names:
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
	cmpq	$0, -24(%rbp)
	je	.L78
	movq	$0, -16(%rbp)
	jmp	.L72
.L74:
	movq	-8(%rbp), %rax
	movq	24(%rax), %rdx
	movq	-16(%rbp), %rax
	salq	$3, %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	testq	%rax, %rax
	je	.L73
	movq	-8(%rbp), %rax
	movq	24(%rax), %rdx
	movq	-16(%rbp), %rax
	salq	$3, %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	free@PLT
.L73:
	addq	$1, -16(%rbp)
.L72:
	movq	-8(%rbp), %rax
	movq	16(%rax), %rax
	cmpq	%rax, -16(%rbp)
	jl	.L74
	movq	-8(%rbp), %rax
	movq	24(%rax), %rax
	movq	%rax, %rdi
	call	free@PLT
	movq	-8(%rbp), %rax
	movq	$0, 16(%rax)
	movq	-8(%rbp), %rax
	movq	32(%rax), %rax
	subq	$1, %rax
	movq	%rax, -16(%rbp)
	jmp	.L75
.L77:
	movq	-8(%rbp), %rax
	movq	40(%rax), %rdx
	movq	-16(%rbp), %rax
	salq	$3, %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	testq	%rax, %rax
	je	.L76
	movq	-8(%rbp), %rax
	movq	40(%rax), %rdx
	movq	-16(%rbp), %rax
	salq	$3, %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	rmdir@PLT
	movq	-8(%rbp), %rax
	movq	40(%rax), %rdx
	movq	-16(%rbp), %rax
	salq	$3, %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	free@PLT
.L76:
	subq	$1, -16(%rbp)
.L75:
	cmpq	$0, -16(%rbp)
	jns	.L77
	movq	-8(%rbp), %rax
	movq	40(%rax), %rax
	movq	%rax, %rdi
	call	free@PLT
	movq	-8(%rbp), %rax
	movq	$0, 32(%rax)
	jmp	.L69
.L78:
	nop
.L69:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE13:
	.size	cleanup_names, .-cleanup_names
	.globl	setup_rm
	.type	setup_rm, @function
setup_rm:
.LFB14:
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
	cmpq	$0, -8(%rbp)
	je	.L82
	movq	-16(%rbp), %rdx
	movq	-8(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	setup_names
	movq	-16(%rbp), %rdx
	movq	-8(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	benchmark_mk
	jmp	.L79
.L82:
	nop
.L79:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE14:
	.size	setup_rm, .-setup_rm
	.globl	cleanup_mk
	.type	cleanup_mk, @function
cleanup_mk:
.LFB15:
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
	cmpq	$0, -8(%rbp)
	je	.L86
	movq	-16(%rbp), %rdx
	movq	-8(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	benchmark_rm
	movq	-16(%rbp), %rdx
	movq	-8(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	cleanup_names
	jmp	.L83
.L86:
	nop
.L83:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE15:
	.size	cleanup_mk, .-cleanup_mk
	.section	.rodata
	.align 8
.LC15:
	.string	"benchmark_mk: null filename at %lu of %lu\n"
	.text
	.globl	benchmark_mk
	.type	benchmark_mk, @function
benchmark_mk:
.LFB16:
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
	jmp	.L88
.L90:
	movq	-8(%rbp), %rax
	movq	24(%rax), %rdx
	movq	-24(%rbp), %rax
	salq	$3, %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	testq	%rax, %rax
	jne	.L89
	movq	-8(%rbp), %rax
	movq	16(%rax), %rcx
	movq	stderr(%rip), %rax
	movq	-24(%rbp), %rdx
	leaq	.LC15(%rip), %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf@PLT
	jmp	.L88
.L89:
	movq	-8(%rbp), %rax
	movq	48(%rax), %rdx
	movq	-8(%rbp), %rax
	movq	24(%rax), %rcx
	movq	-24(%rbp), %rax
	salq	$3, %rax
	addq	%rcx, %rax
	movq	(%rax), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	mkfile
.L88:
	movq	-24(%rbp), %rax
	leaq	-1(%rax), %rdx
	movq	%rdx, -24(%rbp)
	testq	%rax, %rax
	jne	.L90
	nop
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE16:
	.size	benchmark_mk, .-benchmark_mk
	.section	.rodata
	.align 8
.LC16:
	.string	"benchmark_rm: null filename at %lu of %lu\n"
	.text
	.globl	benchmark_rm
	.type	benchmark_rm, @function
benchmark_rm:
.LFB17:
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
	jmp	.L92
.L94:
	movq	-8(%rbp), %rax
	movq	24(%rax), %rdx
	movq	-24(%rbp), %rax
	salq	$3, %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	testq	%rax, %rax
	jne	.L93
	movq	-8(%rbp), %rax
	movq	16(%rax), %rcx
	movq	stderr(%rip), %rax
	movq	-24(%rbp), %rdx
	leaq	.LC16(%rip), %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf@PLT
	jmp	.L92
.L93:
	movq	-8(%rbp), %rax
	movq	24(%rax), %rdx
	movq	-24(%rbp), %rax
	salq	$3, %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	unlink@PLT
.L92:
	movq	-24(%rbp), %rax
	leaq	-1(%rax), %rdx
	movq	%rdx, -24(%rbp)
	testq	%rax, %rax
	jne	.L94
	nop
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE17:
	.size	benchmark_rm, .-benchmark_rm
	.data
	.align 16
	.type	sizes.0, @object
	.size	sizes.0, 16
sizes.0:
	.long	0
	.long	1024
	.long	4096
	.long	10240
	.section	.rodata
	.align 8
.LC4:
	.long	0
	.long	1093567616
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
