	.file	"lat_dram_page.c"
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
	.string	"[-v] [-W <warmup>] [-N <repetitions>][-M len[K|M]]\n"
.LC2:
	.string	"aL:T:M:W:N:"
.LC4:
	.string	"%f\n"
.LC5:
	.string	"0.0\n"
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
	subq	$320, %rsp
	movl	%edi, -308(%rbp)
	movq	%rsi, -320(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movl	$67108864, -296(%rbp)
	movl	$0, -292(%rbp)
	movl	$-1, -288(%rbp)
	leaq	.LC1(%rip), %rax
	movq	%rax, -280(%rbp)
	movl	$1, -108(%rbp)
	movq	$8, -88(%rbp)
	call	getpagesize@PLT
	cltq
	movq	%rax, -80(%rbp)
	movl	$16, -24(%rbp)
	jmp	.L2
.L10:
	movl	-284(%rbp), %eax
	subl	$76, %eax
	cmpl	$11, %eax
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
	.long	.L8-.L5
	.long	.L7-.L5
	.long	.L3-.L5
	.long	.L3-.L5
	.long	.L3-.L5
	.long	.L3-.L5
	.long	.L3-.L5
	.long	.L6-.L5
	.long	.L3-.L5
	.long	.L3-.L5
	.long	.L4-.L5
	.text
.L9:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	bytes@PLT
	movq	%rax, -88(%rbp)
	jmp	.L2
.L6:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	bytes@PLT
	movl	%eax, -24(%rbp)
	jmp	.L2
.L8:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	bytes@PLT
	movl	%eax, -296(%rbp)
	jmp	.L2
.L4:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -292(%rbp)
	jmp	.L2
.L7:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -288(%rbp)
	jmp	.L2
.L3:
	movq	-280(%rbp), %rdx
	movq	-320(%rbp), %rcx
	movl	-308(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	lmbench_usage@PLT
	nop
.L2:
	movq	-320(%rbp), %rcx
	movl	-308(%rbp), %eax
	leaq	.LC2(%rip), %rdx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	mygetopt@PLT
	movl	%eax, -284(%rbp)
	cmpl	$-1, -284(%rbp)
	jne	.L10
	leaq	-256(%rbp), %rsi
	movl	-288(%rbp), %ecx
	movl	-292(%rbp), %edx
	movl	-296(%rbp), %eax
	movq	%rsi, %r8
	movl	%eax, %esi
	movq	mem_initialize@GOTPCREL(%rip), %rax
	movq	%rax, %rdi
	call	loads
	movq	%xmm0, %rax
	movq	%rax, -272(%rbp)
	leaq	-256(%rbp), %rsi
	movl	-288(%rbp), %ecx
	movl	-292(%rbp), %edx
	movl	-296(%rbp), %eax
	movq	%rsi, %r8
	movl	%eax, %esi
	leaq	dram_page_initialize(%rip), %rax
	movq	%rax, %rdi
	call	loads
	movq	%xmm0, %rax
	movq	%rax, -264(%rbp)
	movsd	-264(%rbp), %xmm1
	movsd	.LC3(%rip), %xmm0
	mulsd	%xmm1, %xmm0
	comisd	-272(%rbp), %xmm0
	jbe	.L17
	movsd	-264(%rbp), %xmm0
	subsd	-272(%rbp), %xmm0
	movq	%xmm0, %rdx
	movq	stderr(%rip), %rax
	movq	%rdx, %xmm0
	leaq	.LC4(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	movl	$1, %eax
	call	fprintf@PLT
	jmp	.L13
.L17:
	movq	stderr(%rip), %rax
	movq	%rax, %rcx
	movl	$4, %edx
	movl	$1, %esi
	leaq	.LC5(%rip), %rax
	movq	%rax, %rdi
	call	fwrite@PLT
.L13:
	movl	$0, %eax
	movq	-8(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L15
	call	__stack_chk_fail@PLT
.L15:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE8:
	.size	main, .-main
	.globl	benchmark_loads
	.type	benchmark_loads, @function
benchmark_loads:
.LFB9:
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
	movq	8(%rax), %rbx
	movq	-40(%rbp), %rax
	movq	152(%rax), %rdx
	movq	-40(%rbp), %rax
	movq	168(%rax), %rcx
	movq	%rcx, %rax
	salq	$2, %rax
	addq	%rcx, %rax
	leaq	0(,%rax,4), %rcx
	addq	%rcx, %rax
	salq	$2, %rax
	movq	%rax, %rcx
	movq	%rdx, %rax
	movl	$0, %edx
	divq	%rcx
	addl	$1, %eax
	movl	%eax, %r13d
	jmp	.L19
.L22:
	movl	$0, %r12d
	jmp	.L20
.L21:
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	addl	$1, %r12d
.L20:
	cmpl	%r13d, %r12d
	jl	.L21
.L19:
	movq	-56(%rbp), %rax
	leaq	-1(%rax), %rdx
	movq	%rdx, -56(%rbp)
	testq	%rax, %rax
	jne	.L22
	movq	%rbx, %rdi
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
.LFE9:
	.size	benchmark_loads, .-benchmark_loads
	.globl	regroup
	.type	regroup, @function
regroup:
.LFB10:
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
	.cfi_offset 15, -24
	.cfi_offset 14, -32
	.cfi_offset 13, -40
	.cfi_offset 12, -48
	.cfi_offset 3, -56
	movq	%rdi, -64(%rbp)
	movl	%esi, -68(%rbp)
	movq	%rdx, -80(%rbp)
	movq	-80(%rbp), %rax
	movq	%rax, -48(%rbp)
	cmpl	$1, -68(%rbp)
	jle	.L33
	movq	-48(%rbp), %rax
	movq	8(%rax), %r14
	movl	$0, %ebx
	jmp	.L26
.L29:
	movl	$0, %r12d
	jmp	.L27
.L28:
	movslq	%ebx, %rax
	addq	$1, %rax
	leaq	0(,%rax,8), %rdx
	movq	-64(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rdx
	movslq	%r12d, %rax
	addq	%rax, %rdx
	movslq	%ebx, %rax
	leaq	0(,%rax,8), %rcx
	movq	-64(%rbp), %rax
	addq	%rcx, %rax
	movq	(%rax), %rcx
	movslq	%r12d, %rax
	addq	%rcx, %rax
	addq	%r14, %rax
	addq	%r14, %rdx
	movq	%rdx, (%rax)
	movl	%r12d, %eax
	addl	$8, %eax
	movl	%eax, %r12d
.L27:
	movslq	%r12d, %rdx
	movq	-48(%rbp), %rax
	movq	176(%rax), %rax
	cmpq	%rax, %rdx
	jb	.L28
	addl	$1, %ebx
.L26:
	movl	-68(%rbp), %eax
	subl	$1, %eax
	cmpl	%eax, %ebx
	jl	.L29
	movl	-68(%rbp), %eax
	cltq
	salq	$3, %rax
	leaq	-8(%rax), %rdx
	movq	-64(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	leaq	(%r14,%rax), %r13
	movq	-48(%rbp), %rax
	movq	176(%rax), %rax
	leaq	0(%r13,%rax), %r15
	movl	$0, %ebx
	jmp	.L30
.L32:
	movslq	%ebx, %rax
	addq	%r13, %rax
	movq	(%rax), %r12
	cmpq	%r12, %r13
	ja	.L31
	cmpq	%r15, %r12
	jnb	.L31
	movq	%r12, %rax
	subq	%r13, %rax
	movl	%eax, -52(%rbp)
	movq	-64(%rbp), %rax
	movq	(%rax), %rdx
	movl	-52(%rbp), %eax
	cltq
	addq	%rax, %rdx
	movslq	%ebx, %rax
	addq	%r13, %rax
	addq	%r14, %rdx
	movq	%rdx, (%rax)
.L31:
	movl	%ebx, %eax
	addl	$8, %eax
	movl	%eax, %ebx
.L30:
	movslq	%ebx, %rdx
	movq	-48(%rbp), %rax
	movq	176(%rax), %rax
	cmpq	%rax, %rdx
	jb	.L32
	jmp	.L23
.L33:
	nop
.L23:
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE10:
	.size	regroup, .-regroup
	.globl	dram_page_initialize
	.type	dram_page_initialize, @function
dram_page_initialize:
.LFB11:
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
	movq	-48(%rbp), %rax
	movq	%rax, -8(%rbp)
	cmpq	$0, -40(%rbp)
	jne	.L40
	movq	-48(%rbp), %rdx
	movq	-40(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	mem_initialize@PLT
	movl	$0, -24(%rbp)
	jmp	.L37
.L39:
	movq	-8(%rbp), %rax
	movl	232(%rax), %eax
	movl	%eax, -20(%rbp)
	movl	-20(%rbp), %eax
	movslq	%eax, %rdx
	movq	-16(%rbp), %rax
	movq	192(%rax), %rax
	movl	-24(%rbp), %ecx
	movslq	%ecx, %rcx
	subq	%rcx, %rax
	cmpq	%rax, %rdx
	jbe	.L38
	movq	-16(%rbp), %rax
	movq	192(%rax), %rax
	movl	-24(%rbp), %edx
	subl	%edx, %eax
	movl	%eax, -20(%rbp)
.L38:
	movq	-16(%rbp), %rax
	movq	208(%rax), %rdx
	movl	-24(%rbp), %eax
	cltq
	salq	$3, %rax
	leaq	(%rdx,%rax), %rcx
	movq	-48(%rbp), %rdx
	movl	-20(%rbp), %eax
	movl	%eax, %esi
	movq	%rcx, %rdi
	call	regroup
	movq	-8(%rbp), %rax
	movl	232(%rax), %eax
	addl	%eax, -24(%rbp)
.L37:
	movl	-24(%rbp), %eax
	movslq	%eax, %rdx
	movq	-16(%rbp), %rax
	movq	192(%rax), %rax
	cmpq	%rax, %rdx
	jb	.L39
	movq	-48(%rbp), %rax
	movq	%rax, %rsi
	movl	$1, %edi
	call	benchmark_loads
	jmp	.L34
.L40:
	nop
.L34:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE11:
	.size	dram_page_initialize, .-dram_page_initialize
	.globl	loads
	.type	loads, @function
loads:
.LFB12:
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
	movq	%rdi, -56(%rbp)
	movl	%esi, -60(%rbp)
	movl	%edx, -64(%rbp)
	movl	%ecx, -68(%rbp)
	movq	%r8, -80(%rbp)
	movl	$1, -40(%rbp)
	movq	-80(%rbp), %rax
	movq	%rax, -32(%rbp)
	movl	-60(%rbp), %eax
	movslq	%eax, %rdx
	movq	-32(%rbp), %rax
	movq	%rdx, 152(%rax)
	movl	-60(%rbp), %eax
	movslq	%eax, %rdx
	movq	-32(%rbp), %rax
	movq	%rdx, 160(%rax)
	movq	-32(%rbp), %rax
	movq	152(%rax), %rdx
	movq	-32(%rbp), %rax
	movq	168(%rax), %rcx
	movq	%rcx, %rax
	salq	$2, %rax
	addq	%rcx, %rax
	leaq	0(,%rax,4), %rcx
	addq	%rcx, %rax
	salq	$2, %rax
	movq	%rax, %rcx
	movq	%rdx, %rax
	movl	$0, %edx
	divq	%rcx
	addq	$1, %rax
	imull	$100, %eax, %eax
	movl	%eax, -36(%rbp)
	movl	-64(%rbp), %esi
	movl	-40(%rbp), %ecx
	movq	-56(%rbp), %rax
	pushq	-80(%rbp)
	movl	-68(%rbp), %edx
	pushq	%rdx
	movl	%esi, %r9d
	movl	%ecx, %r8d
	movl	$0, %ecx
	movq	mem_cleanup@GOTPCREL(%rip), %rdx
	leaq	benchmark_loads(%rip), %rsi
	movq	%rax, %rdi
	call	benchmp@PLT
	addq	$16, %rsp
	call	usecs_spent@PLT
	testq	%rax, %rax
	js	.L42
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L43
.L42:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L43:
	movsd	.LC6(%rip), %xmm1
	mulsd	%xmm1, %xmm0
	movsd	%xmm0, -88(%rbp)
	movl	-36(%rbp), %eax
	movslq	%eax, %rbx
	call	get_n@PLT
	imulq	%rbx, %rax
	testq	%rax, %rax
	js	.L44
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L45
.L44:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L45:
	movsd	-88(%rbp), %xmm1
	divsd	%xmm0, %xmm1
	movsd	%xmm1, -24(%rbp)
	movsd	-24(%rbp), %xmm0
	movq	%xmm0, %rax
	movq	%rax, %xmm0
	movq	-8(%rbp), %rbx
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE12:
	.size	loads, .-loads
	.section	.rodata
	.align 8
.LC3:
	.long	1717986918
	.long	1072588390
	.align 8
.LC6:
	.long	0
	.long	1083129856
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
