	.file	"lat_mmap.c"
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
	.string	"[-r] [-C] [-P <parallelism>] [-W <warmup>] [-N <repetitions>] size file\n"
.LC2:
	.string	"rP:W:N:C"
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
	subq	$96, %rsp
	movl	%edi, -84(%rbp)
	movq	%rsi, -96(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movl	$1, -72(%rbp)
	movl	$0, -68(%rbp)
	movl	$-1, -64(%rbp)
	leaq	.LC1(%rip), %rax
	movq	%rax, -56(%rbp)
	movl	$0, -36(%rbp)
	movl	$0, -32(%rbp)
	jmp	.L2
.L10:
	cmpl	$114, -60(%rbp)
	je	.L3
	cmpl	$114, -60(%rbp)
	jg	.L4
	cmpl	$87, -60(%rbp)
	je	.L5
	cmpl	$87, -60(%rbp)
	jg	.L4
	cmpl	$80, -60(%rbp)
	je	.L6
	cmpl	$80, -60(%rbp)
	jg	.L4
	cmpl	$67, -60(%rbp)
	je	.L7
	cmpl	$78, -60(%rbp)
	je	.L8
	jmp	.L4
.L6:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -72(%rbp)
	cmpl	$0, -72(%rbp)
	jg	.L2
	movq	-56(%rbp), %rdx
	movq	-96(%rbp), %rcx
	movl	-84(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	lmbench_usage@PLT
	jmp	.L2
.L5:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -68(%rbp)
	jmp	.L2
.L8:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -64(%rbp)
	jmp	.L2
.L3:
	movl	$1, -36(%rbp)
	jmp	.L2
.L7:
	movl	$1, -32(%rbp)
	jmp	.L2
.L4:
	movq	-56(%rbp), %rdx
	movq	-96(%rbp), %rcx
	movl	-84(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	lmbench_usage@PLT
	nop
.L2:
	movq	-96(%rbp), %rcx
	movl	-84(%rbp), %eax
	leaq	.LC2(%rip), %rdx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	mygetopt@PLT
	movl	%eax, -60(%rbp)
	cmpl	$-1, -60(%rbp)
	jne	.L10
	movl	myoptind(%rip), %eax
	addl	$2, %eax
	cmpl	%eax, -84(%rbp)
	je	.L11
	movq	-56(%rbp), %rdx
	movq	-96(%rbp), %rcx
	movl	-84(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	lmbench_usage@PLT
.L11:
	movl	myoptind(%rip), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-96(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	bytes@PLT
	movq	%rax, -48(%rbp)
	movq	-48(%rbp), %rax
	cmpq	$327679, %rax
	ja	.L12
	movl	$1, %eax
	jmp	.L15
.L12:
	movl	myoptind(%rip), %eax
	cltq
	addq	$1, %rax
	leaq	0(,%rax,8), %rdx
	movq	-96(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	%rax, -24(%rbp)
	movl	-68(%rbp), %ecx
	movl	-72(%rbp), %edx
	leaq	-48(%rbp), %rax
	pushq	%rax
	movl	-64(%rbp), %eax
	pushq	%rax
	movl	%ecx, %r9d
	movl	%edx, %r8d
	movl	$0, %ecx
	leaq	cleanup(%rip), %rax
	movq	%rax, %rdx
	leaq	domapping(%rip), %rax
	movq	%rax, %rsi
	leaq	init(%rip), %rax
	movq	%rax, %rdi
	call	benchmp@PLT
	addq	$16, %rsp
	call	usecs_spent@PLT
	testq	%rax, %rax
	je	.L14
	call	get_n@PLT
	movq	%rax, %rdx
	movq	-48(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	micromb@PLT
.L14:
	movl	$0, %eax
.L15:
	movq	-8(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L16
	call	__stack_chk_fail@PLT
.L16:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE8:
	.size	main, .-main
	.section	.rodata
.LC3:
	.string	"%d"
.LC4:
	.string	"malloc"
.LC5:
	.string	"%s%d"
.LC6:
	.string	"Could not copy file"
.LC7:
	.string	"x"
.LC8:
	.string	"Input file too small\n"
	.text
	.globl	init
	.type	init, @function
init:
.LFB9:
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
	movq	%rax, -176(%rbp)
	cmpq	$0, -184(%rbp)
	jne	.L26
	movq	-176(%rbp), %rax
	movl	16(%rax), %eax
	testl	%eax, %eax
	je	.L20
	call	getpid@PLT
	movl	%eax, %edx
	leaq	-160(%rbp), %rax
	leaq	.LC3(%rip), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	sprintf@PLT
	movq	-176(%rbp), %rax
	movq	24(%rax), %rax
	movq	%rax, %rdi
	call	strlen@PLT
	movq	%rax, %rbx
	leaq	-160(%rbp), %rax
	movq	%rax, %rdi
	call	strlen@PLT
	addq	%rbx, %rax
	addq	$1, %rax
	movq	%rax, %rdi
	call	malloc@PLT
	movq	%rax, -168(%rbp)
	cmpq	$0, -168(%rbp)
	jne	.L21
	leaq	.LC4(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L21:
	call	getpid@PLT
	movl	%eax, %ecx
	movq	-176(%rbp), %rax
	movq	24(%rax), %rdx
	movq	-168(%rbp), %rax
	leaq	.LC5(%rip), %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	sprintf@PLT
	movq	-176(%rbp), %rax
	movq	24(%rax), %rax
	movq	-168(%rbp), %rcx
	movl	$384, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	cp@PLT
	testl	%eax, %eax
	jns	.L22
	leaq	.LC6(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movq	-168(%rbp), %rax
	movq	%rax, %rdi
	call	unlink@PLT
	movl	$1, %edi
	call	exit@PLT
.L22:
	movq	-176(%rbp), %rax
	movq	-168(%rbp), %rdx
	movq	%rdx, 24(%rax)
.L20:
	movq	-176(%rbp), %rax
	movq	24(%rax), %rax
	movl	$2, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	open@PLT
	movq	-176(%rbp), %rdx
	movl	%eax, 8(%rdx)
	movq	-176(%rbp), %rax
	movl	8(%rax), %eax
	cmpl	$-1, %eax
	jne	.L23
	leaq	.LC7(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L23:
	movq	-176(%rbp), %rax
	movl	16(%rax), %eax
	testl	%eax, %eax
	je	.L24
	movq	-176(%rbp), %rax
	movq	24(%rax), %rax
	movq	%rax, %rdi
	call	unlink@PLT
.L24:
	movq	-176(%rbp), %rax
	movl	8(%rax), %eax
	movl	$2, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	seekto@PLT
	movq	%rax, %rdx
	movq	-176(%rbp), %rax
	movq	(%rax), %rax
	cmpq	%rax, %rdx
	jnb	.L17
	movq	stderr(%rip), %rax
	movq	%rax, %rcx
	movl	$21, %edx
	movl	$1, %esi
	leaq	.LC8(%rip), %rax
	movq	%rax, %rdi
	call	fwrite@PLT
	movl	$1, %edi
	call	exit@PLT
.L26:
	nop
.L17:
	movq	-24(%rbp), %rax
	subq	%fs:40, %rax
	je	.L25
	call	__stack_chk_fail@PLT
.L25:
	movq	-8(%rbp), %rbx
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE9:
	.size	init, .-init
	.globl	cleanup
	.type	cleanup, @function
cleanup:
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
	movq	%rax, -8(%rbp)
	cmpq	$0, -24(%rbp)
	jne	.L30
	movq	-8(%rbp), %rax
	movl	8(%rax), %eax
	movl	%eax, %edi
	call	close@PLT
	jmp	.L27
.L30:
	nop
.L27:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE10:
	.size	cleanup, .-cleanup
	.section	.rodata
.LC9:
	.string	"mmap"
	.text
	.globl	domapping
	.type	domapping, @function
domapping:
.LFB11:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$56, %rsp
	.cfi_offset 15, -24
	.cfi_offset 14, -32
	.cfi_offset 13, -40
	.cfi_offset 12, -48
	.cfi_offset 3, -56
	movq	%rdi, -72(%rbp)
	movq	%rsi, -80(%rbp)
	movq	-80(%rbp), %rax
	movq	%rax, -56(%rbp)
	movq	-56(%rbp), %rax
	movl	8(%rax), %eax
	movl	%eax, -84(%rbp)
	movq	-56(%rbp), %rax
	movq	(%rax), %r13
	movq	-56(%rbp), %rax
	movl	12(%rax), %eax
	movl	%eax, -88(%rbp)
	movl	%r13d, %r15d
	jmp	.L32
.L40:
	movl	$0, %r9d
	movl	-84(%rbp), %r8d
	movl	$1, %ecx
	movl	$3, %edx
	movq	%r13, %rsi
	movl	$0, %edi
	call	mmap@PLT
	movq	%rax, %r12
	cmpq	$-1, %r12
	jne	.L33
	leaq	.LC9(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L33:
	cmpl	$0, -88(%rbp)
	je	.L34
	leaq	(%r12,%r13), %r14
	movq	%r12, %rbx
	jmp	.L35
.L36:
	movb	%r15b, (%rbx)
	addq	$163840, %rbx
.L35:
	cmpq	%r14, %rbx
	jb	.L36
	jmp	.L37
.L34:
	movabsq	$-3689348814741910323, %rdx
	movq	%r13, %rax
	mulq	%rdx
	movq	%rdx, %rax
	shrq	$3, %rax
	leaq	(%r12,%rax), %r14
	movq	%r12, %rbx
	jmp	.L38
.L39:
	movb	%r15b, (%rbx)
	addq	$16384, %rbx
.L38:
	cmpq	%r14, %rbx
	jb	.L39
.L37:
	movq	%r13, %rsi
	movq	%r12, %rdi
	call	munmap@PLT
.L32:
	movq	-72(%rbp), %rax
	leaq	-1(%rax), %rdx
	movq	%rdx, -72(%rbp)
	testq	%rax, %rax
	jne	.L40
	nop
	nop
	addq	$56, %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE11:
	.size	domapping, .-domapping
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
