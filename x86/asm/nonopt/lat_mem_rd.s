	.file	"lat_mem_rd.c"
	.text
	.globl	id
	.section	.rodata
	.align 8
.LC0:
	.string	"$Id: s.lat_mem_rd.c 1.13 98/06/30 16:13:49-07:00 lm@lm.bitmover.com $\n"
	.section	.data.rel.local,"aw"
	.align 8
	.type	id, @object
	.size	id, 8
id:
	.quad	.LC0
	.globl	fpInit
	.section	.data.rel,"aw"
	.align 8
	.type	fpInit, @object
	.size	fpInit, 8
fpInit:
	.quad	stride_initialize
	.section	.rodata
	.align 8
.LC1:
	.string	"[-P <parallelism>] [-W <warmup>] [-N <repetitions>] [-t] len [stride...]\n"
.LC2:
	.string	"tP:W:N:"
.LC3:
	.string	"\"stride=%d\n"
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
	subq	$80, %rsp
	movl	%edi, -68(%rbp)
	movq	%rsi, -80(%rbp)
	movl	$1, -48(%rbp)
	movl	$0, -44(%rbp)
	movl	$-1, -40(%rbp)
	leaq	.LC1(%rip), %rax
	movq	%rax, -24(%rbp)
	jmp	.L2
.L9:
	cmpl	$116, -36(%rbp)
	je	.L3
	cmpl	$116, -36(%rbp)
	jg	.L4
	cmpl	$87, -36(%rbp)
	je	.L5
	cmpl	$87, -36(%rbp)
	jg	.L4
	cmpl	$78, -36(%rbp)
	je	.L6
	cmpl	$80, -36(%rbp)
	je	.L7
	jmp	.L4
.L3:
	movq	thrash_initialize@GOTPCREL(%rip), %rax
	movq	%rax, fpInit(%rip)
	jmp	.L2
.L7:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -48(%rbp)
	cmpl	$0, -48(%rbp)
	jg	.L2
	movq	-24(%rbp), %rdx
	movq	-80(%rbp), %rcx
	movl	-68(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	lmbench_usage@PLT
	jmp	.L2
.L5:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -44(%rbp)
	jmp	.L2
.L6:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -40(%rbp)
	jmp	.L2
.L4:
	movq	-24(%rbp), %rdx
	movq	-80(%rbp), %rcx
	movl	-68(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	lmbench_usage@PLT
	nop
.L2:
	movq	-80(%rbp), %rcx
	movl	-68(%rbp), %eax
	leaq	.LC2(%rip), %rdx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	mygetopt@PLT
	movl	%eax, -36(%rbp)
	cmpl	$-1, -36(%rbp)
	jne	.L9
	movl	myoptind(%rip), %eax
	cmpl	%eax, -68(%rbp)
	jne	.L10
	movq	-24(%rbp), %rdx
	movq	-80(%rbp), %rcx
	movl	-68(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	lmbench_usage@PLT
.L10:
	movl	myoptind(%rip), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-80(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	cltq
	movq	%rax, -16(%rbp)
	salq	$20, -16(%rbp)
	movl	-68(%rbp), %eax
	leal	-1(%rax), %edx
	movl	myoptind(%rip), %eax
	cmpl	%eax, %edx
	jne	.L11
	movq	stderr(%rip), %rax
	movl	$64, %edx
	leaq	.LC3(%rip), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf@PLT
	movq	$512, -32(%rbp)
	jmp	.L12
.L13:
	movl	-40(%rbp), %edi
	movl	-44(%rbp), %ecx
	movl	-48(%rbp), %edx
	movq	-32(%rbp), %rsi
	movq	-16(%rbp), %rax
	movl	%edi, %r9d
	movl	%ecx, %r8d
	movl	%edx, %ecx
	movl	$64, %edx
	movq	%rax, %rdi
	call	loads
	movq	-32(%rbp), %rax
	movq	%rax, %rdi
	call	step
	movq	%rax, -32(%rbp)
.L12:
	movq	-32(%rbp), %rax
	cmpq	-16(%rbp), %rax
	jbe	.L13
	jmp	.L14
.L11:
	movl	myoptind(%rip), %eax
	addl	$1, %eax
	movl	%eax, -52(%rbp)
	jmp	.L15
.L18:
	movl	-52(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-80(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	bytes@PLT
	movq	%rax, -8(%rbp)
	movq	-8(%rbp), %rax
	movl	%eax, %edx
	movq	stderr(%rip), %rax
	leaq	.LC3(%rip), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf@PLT
	movq	$512, -32(%rbp)
	jmp	.L16
.L17:
	movl	-40(%rbp), %r8d
	movl	-44(%rbp), %edi
	movl	-48(%rbp), %ecx
	movq	-8(%rbp), %rdx
	movq	-32(%rbp), %rsi
	movq	-16(%rbp), %rax
	movl	%r8d, %r9d
	movl	%edi, %r8d
	movq	%rax, %rdi
	call	loads
	movq	-32(%rbp), %rax
	movq	%rax, %rdi
	call	step
	movq	%rax, -32(%rbp)
.L16:
	movq	-32(%rbp), %rax
	cmpq	-16(%rbp), %rax
	jbe	.L17
	movq	stderr(%rip), %rax
	movq	%rax, %rsi
	movl	$10, %edi
	call	fputc@PLT
	addl	$1, -52(%rbp)
.L15:
	movl	-52(%rbp), %eax
	cmpl	-68(%rbp), %eax
	jl	.L18
.L14:
	movl	$0, %eax
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
	movq	16(%rax), %rbx
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
	leaq	1(%rax), %r13
	jmp	.L21
.L24:
	movl	$0, %r12d
	jmp	.L22
.L23:
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
	addq	$1, %r12
.L22:
	cmpq	%r13, %r12
	jb	.L23
.L21:
	movq	-56(%rbp), %rax
	leaq	-1(%rax), %rdx
	movq	%rdx, -56(%rbp)
	testq	%rax, %rax
	jne	.L24
	movq	%rbx, %rdi
	call	use_pointer@PLT
	movq	-40(%rbp), %rax
	movq	%rbx, 16(%rax)
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
	.section	.rodata
.LC6:
	.string	"%.5f %.3f\n"
	.text
	.globl	loads
	.type	loads, @function
loads:
.LFB10:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$304, %rsp
	movq	%rdi, -264(%rbp)
	movq	%rsi, -272(%rbp)
	movq	%rdx, -280(%rbp)
	movl	%ecx, -284(%rbp)
	movl	%r8d, -288(%rbp)
	movl	%r9d, -292(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movq	-272(%rbp), %rax
	cmpq	-280(%rbp), %rax
	jb	.L35
	movl	$1, -92(%rbp)
	movq	-272(%rbp), %rax
	movq	%rax, -88(%rbp)
	movq	-264(%rbp), %rax
	movq	%rax, -80(%rbp)
	movq	-280(%rbp), %rax
	movq	%rax, -72(%rbp)
	call	getpagesize@PLT
	cltq
	movq	%rax, -64(%rbp)
	movq	-88(%rbp), %rdx
	movq	-72(%rbp), %rcx
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
	leaq	1(%rax), %rdx
	movq	%rdx, %rax
	salq	$2, %rax
	addq	%rdx, %rax
	leaq	0(,%rax,4), %rdx
	addq	%rdx, %rax
	salq	$2, %rax
	movq	%rax, -256(%rbp)
	movq	fpInit(%rip), %rax
	movl	-288(%rbp), %esi
	movl	-284(%rbp), %ecx
	leaq	-240(%rbp), %rdx
	pushq	%rdx
	movl	-292(%rbp), %edx
	pushq	%rdx
	movl	%esi, %r9d
	movl	%ecx, %r8d
	movl	$100000, %ecx
	movq	mem_cleanup@GOTPCREL(%rip), %rdx
	leaq	benchmark_loads(%rip), %rsi
	movq	%rax, %rdi
	call	benchmp@PLT
	addq	$16, %rsp
	movl	$0, %eax
	call	save_minimum@PLT
	call	usecs_spent@PLT
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
	movsd	%xmm0, -304(%rbp)
	call	get_n@PLT
	imulq	-256(%rbp), %rax
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
	movsd	-304(%rbp), %xmm1
	divsd	%xmm0, %xmm1
	movsd	%xmm1, -248(%rbp)
	movq	-272(%rbp), %rax
	testq	%rax, %rax
	js	.L32
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L33
.L32:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L33:
	movsd	.LC5(%rip), %xmm1
	divsd	%xmm1, %xmm0
	movq	%xmm0, %rdx
	movq	stderr(%rip), %rax
	movsd	-248(%rbp), %xmm0
	movapd	%xmm0, %xmm1
	movq	%rdx, %xmm0
	leaq	.LC6(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	movl	$2, %eax
	call	fprintf@PLT
	jmp	.L25
.L35:
	nop
.L25:
	movq	-8(%rbp), %rax
	subq	%fs:40, %rax
	je	.L34
	call	__stack_chk_fail@PLT
.L34:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE10:
	.size	loads, .-loads
	.globl	step
	.type	step, @function
step:
.LFB11:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -24(%rbp)
	cmpq	$1023, -24(%rbp)
	ja	.L37
	salq	-24(%rbp)
	jmp	.L38
.L37:
	cmpq	$4095, -24(%rbp)
	ja	.L39
	addq	$1024, -24(%rbp)
	jmp	.L38
.L39:
	movq	$4096, -8(%rbp)
	jmp	.L40
.L41:
	salq	-8(%rbp)
.L40:
	movq	-8(%rbp), %rax
	cmpq	-24(%rbp), %rax
	jbe	.L41
	movq	-8(%rbp), %rax
	shrq	$2, %rax
	addq	%rax, -24(%rbp)
.L38:
	movq	-24(%rbp), %rax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE11:
	.size	step, .-step
	.section	.rodata
	.align 8
.LC4:
	.long	0
	.long	1083129856
	.align 8
.LC5:
	.long	0
	.long	1093664768
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
