	.file	"lat_mem_rd.c"
	.text
	.globl	benchmark_loads
	.type	benchmark_loads, @function
benchmark_loads:
.LFB73:
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
	movq	16(%rsi), %rbx
	movq	168(%rsi), %rax
	leaq	(%rax,%rax,4), %rax
	leaq	(%rax,%rax,4), %rcx
	salq	$2, %rcx
	movq	152(%rsi), %rax
	movl	$0, %edx
	divq	%rcx
	leaq	1(%rax), %r8
	leaq	-1(%rdi), %rsi
	testq	%rdi, %rdi
	jne	.L2
.L3:
	movq	%rbx, %rdi
	call	use_pointer@PLT
	movq	%rbx, 16(%rbp)
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
.L4:
	.cfi_restore_state
	movq	(%rbx), %rcx
	movq	(%rcx), %rcx
	movq	(%rcx), %rcx
	movq	(%rcx), %rcx
	movq	(%rcx), %rcx
	movq	(%rcx), %rcx
	movq	(%rcx), %rcx
	movq	(%rcx), %rcx
	movq	(%rcx), %rcx
	movq	(%rcx), %rcx
	movq	(%rcx), %rcx
	movq	(%rcx), %rcx
	movq	(%rcx), %rcx
	movq	(%rcx), %rcx
	movq	(%rcx), %rcx
	movq	(%rcx), %rcx
	movq	(%rcx), %rcx
	movq	(%rcx), %rcx
	movq	(%rcx), %rcx
	movq	(%rcx), %rcx
	movq	(%rcx), %rcx
	movq	(%rcx), %rcx
	movq	(%rcx), %rcx
	movq	(%rcx), %rcx
	movq	(%rcx), %rcx
	movq	(%rcx), %rcx
	movq	(%rcx), %rcx
	movq	(%rcx), %rcx
	movq	(%rcx), %rcx
	movq	(%rcx), %rcx
	movq	(%rcx), %rcx
	movq	(%rcx), %rcx
	movq	(%rcx), %rcx
	movq	(%rcx), %rcx
	movq	(%rcx), %rcx
	movq	(%rcx), %rcx
	movq	(%rcx), %rcx
	movq	(%rcx), %rcx
	movq	(%rcx), %rcx
	movq	(%rcx), %rcx
	movq	(%rcx), %rcx
	movq	(%rcx), %rcx
	movq	(%rcx), %rcx
	movq	(%rcx), %rcx
	movq	(%rcx), %rcx
	movq	(%rcx), %rcx
	movq	(%rcx), %rcx
	movq	(%rcx), %rcx
	movq	(%rcx), %rcx
	movq	(%rcx), %rcx
	movq	(%rcx), %rcx
	movq	(%rcx), %rcx
	movq	(%rcx), %rcx
	movq	(%rcx), %rcx
	movq	(%rcx), %rcx
	movq	(%rcx), %rcx
	movq	(%rcx), %rcx
	movq	(%rcx), %rcx
	movq	(%rcx), %rcx
	movq	(%rcx), %rcx
	movq	(%rcx), %rcx
	movq	(%rcx), %rcx
	movq	(%rcx), %rcx
	movq	(%rcx), %rcx
	movq	(%rcx), %rcx
	movq	(%rcx), %rcx
	movq	(%rcx), %rcx
	movq	(%rcx), %rcx
	movq	(%rcx), %rcx
	movq	(%rcx), %rcx
	movq	(%rcx), %rcx
	movq	(%rcx), %rcx
	movq	(%rcx), %rcx
	movq	(%rcx), %rcx
	movq	(%rcx), %rcx
	movq	(%rcx), %rcx
	movq	(%rcx), %rcx
	movq	(%rcx), %rcx
	movq	(%rcx), %rcx
	movq	(%rcx), %rcx
	movq	(%rcx), %rcx
	movq	(%rcx), %rcx
	movq	(%rcx), %rcx
	movq	(%rcx), %rcx
	movq	(%rcx), %rcx
	movq	(%rcx), %rcx
	movq	(%rcx), %rcx
	movq	(%rcx), %rcx
	movq	(%rcx), %rcx
	movq	(%rcx), %rcx
	movq	(%rcx), %rcx
	movq	(%rcx), %rcx
	movq	(%rcx), %rcx
	movq	(%rcx), %rcx
	movq	(%rcx), %rcx
	movq	(%rcx), %rcx
	movq	(%rcx), %rcx
	movq	(%rcx), %rcx
	movq	(%rcx), %rcx
	movq	(%rcx), %rbx
	movq	%rdx, %rcx
	addq	$1, %rdx
	cmpq	%rcx, %rax
	jne	.L4
.L5:
	subq	$1, %rsi
	cmpq	$-1, %rsi
	je	.L3
.L2:
	movl	$0, %edx
	testq	%r8, %r8
	jne	.L4
	jmp	.L5
	.cfi_endproc
.LFE73:
	.size	benchmark_loads, .-benchmark_loads
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC2:
	.string	"%.5f %.3f\n"
	.text
	.globl	loads
	.type	loads, @function
loads:
.LFB74:
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
	subq	$248, %rsp
	.cfi_offset 15, -24
	.cfi_offset 14, -32
	.cfi_offset 13, -40
	.cfi_offset 12, -48
	.cfi_offset 3, -56
	movq	%rdi, %rax
	movq	%rdx, %rdi
	movq	%rdx, %r15
	movq	%fs:40, %rdx
	movq	%rdx, -56(%rbp)
	xorl	%edx, %edx
	cmpq	%rdi, %rsi
	jnb	.L21
.L11:
	movq	-56(%rbp), %rax
	subq	%fs:40, %rax
	jne	.L22
	leaq	-40(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_remember_state
	.cfi_def_cfa 7, 8
	ret
.L21:
	.cfi_restore_state
	movq	%rsi, %rbx
	movl	%ecx, %r12d
	movl	%r8d, %r13d
	movl	%r9d, %r14d
	movl	$1, -140(%rbp)
	movq	%rsi, -136(%rbp)
	movq	%rax, -128(%rbp)
	movq	%rdi, -120(%rbp)
	call	getpagesize@PLT
	cltq
	movq	%rax, -112(%rbp)
	leaq	-288(%rbp), %rax
	pushq	%rax
	pushq	%r14
	movl	%r13d, %r9d
	movl	%r12d, %r8d
	movl	$100000, %ecx
	movq	mem_cleanup@GOTPCREL(%rip), %rdx
	leaq	benchmark_loads(%rip), %rsi
	movq	fpInit(%rip), %rdi
	call	benchmp@PLT
	movl	$0, %eax
	call	save_minimum@PLT
	call	usecs_spent@PLT
	movq	%rax, %r12
	call	get_n@PLT
	movq	%rax, %rsi
	testq	%r12, %r12
	js	.L13
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%r12, %xmm1
.L14:
	mulsd	.LC0(%rip), %xmm1
	leaq	(%r15,%r15,4), %rax
	leaq	(%rax,%rax,4), %rcx
	salq	$2, %rcx
	movq	%rbx, %rax
	movl	$0, %edx
	divq	%rcx
	addq	$1, %rax
	imulq	%rsi, %rax
	leaq	(%rax,%rax,4), %rax
	leaq	(%rax,%rax,4), %rax
	salq	$2, %rax
	js	.L15
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
.L16:
	divsd	%xmm0, %xmm1
	testq	%rbx, %rbx
	js	.L17
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rbx, %xmm0
.L18:
	mulsd	.LC1(%rip), %xmm0
	leaq	.LC2(%rip), %rdx
	movl	$1, %esi
	movq	stderr(%rip), %rdi
	movl	$2, %eax
	call	__fprintf_chk@PLT
	addq	$16, %rsp
	jmp	.L11
.L13:
	movq	%r12, %rax
	shrq	%rax
	andl	$1, %r12d
	orq	%r12, %rax
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rax, %xmm1
	addsd	%xmm1, %xmm1
	jmp	.L14
.L15:
	shrq	%rax
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	addsd	%xmm0, %xmm0
	jmp	.L16
.L17:
	movq	%rbx, %rax
	shrq	%rax
	andl	$1, %ebx
	orq	%rbx, %rax
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	addsd	%xmm0, %xmm0
	jmp	.L18
.L22:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE74:
	.size	loads, .-loads
	.globl	step
	.type	step, @function
step:
.LFB75:
	.cfi_startproc
	endbr64
	cmpq	$1023, %rdi
	ja	.L24
	leaq	(%rdi,%rdi), %rax
	ret
.L24:
	cmpq	$4095, %rdi
	ja	.L27
	leaq	1024(%rdi), %rax
	ret
.L27:
	movl	$4096, %eax
.L26:
	addq	%rax, %rax
	cmpq	%rax, %rdi
	jnb	.L26
	shrq	$2, %rax
	addq	%rdi, %rax
	ret
	.cfi_endproc
.LFE75:
	.size	step, .-step
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC3:
	.string	"[-P <parallelism>] [-W <warmup>] [-N <repetitions>] [-t] len [stride...]\n"
	.section	.rodata.str1.1
.LC4:
	.string	"tP:W:N:"
.LC5:
	.string	"\"stride=%d\n"
	.text
	.globl	main
	.type	main, @function
main:
.LFB72:
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
	subq	$24, %rsp
	.cfi_def_cfa_offset 80
	movl	%edi, %ebx
	movq	%rsi, %r12
	movl	$-1, %r14d
	movl	$0, %r13d
	movl	$1, %r15d
	leaq	.LC4(%rip), %rbp
	jmp	.L30
.L32:
	cmpl	$116, %eax
	jne	.L35
	movq	thrash_initialize@GOTPCREL(%rip), %rax
	movq	%rax, fpInit(%rip)
.L30:
	movq	%rbp, %rdx
	movq	%r12, %rsi
	movl	%ebx, %edi
	call	mygetopt@PLT
	cmpl	$-1, %eax
	je	.L49
	cmpl	$87, %eax
	je	.L31
	jg	.L32
	cmpl	$78, %eax
	je	.L33
	cmpl	$80, %eax
	jne	.L35
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	movl	%eax, %r15d
	testl	%eax, %eax
	jg	.L30
	leaq	.LC3(%rip), %rdx
	movq	%r12, %rsi
	movl	%ebx, %edi
	call	lmbench_usage@PLT
	jmp	.L30
.L31:
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	movl	%eax, %r13d
	jmp	.L30
.L33:
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	movl	%eax, %r14d
	jmp	.L30
.L35:
	leaq	.LC3(%rip), %rdx
	movq	%r12, %rsi
	movl	%ebx, %edi
	call	lmbench_usage@PLT
	jmp	.L30
.L49:
	cmpl	%ebx, myoptind(%rip)
	je	.L50
.L38:
	movslq	myoptind(%rip), %rax
	movq	(%r12,%rax,8), %rdi
	movl	$10, %edx
	movl	$0, %esi
	call	strtol@PLT
	movslq	%eax, %rbp
	salq	$20, %rbp
	movl	myoptind(%rip), %eax
	leal	-1(%rbx), %edx
	cmpl	%eax, %edx
	je	.L51
	leal	1(%rax), %edx
	cmpl	%edx, %ebx
	jle	.L40
	movslq	%edx, %rdx
	leaq	(%r12,%rdx,8), %rdx
	movq	%rdx, (%rsp)
	subl	%eax, %ebx
	leal	-2(%rbx), %edx
	cltq
	addq	%rdx, %rax
	leaq	16(%r12,%rax,8), %rax
	movq	%rax, 8(%rsp)
.L44:
	movq	(%rsp), %rax
	movq	(%rax), %rdi
	call	bytes@PLT
	movq	%rax, %r12
	movl	%eax, %ecx
	leaq	.LC5(%rip), %rdx
	movl	$1, %esi
	movq	stderr(%rip), %rdi
	movl	$0, %eax
	call	__fprintf_chk@PLT
	cmpq	$511, %rbp
	jbe	.L42
	movl	$512, %ebx
.L43:
	movl	%r14d, %r9d
	movl	%r13d, %r8d
	movl	%r15d, %ecx
	movq	%r12, %rdx
	movq	%rbx, %rsi
	movq	%rbp, %rdi
	call	loads
	movq	%rbx, %rdi
	call	step
	movq	%rax, %rbx
	cmpq	%rax, %rbp
	jnb	.L43
.L42:
	movq	stderr(%rip), %rsi
	movl	$10, %edi
	call	fputc@PLT
	addq	$8, (%rsp)
	movq	(%rsp), %rax
	cmpq	8(%rsp), %rax
	jne	.L44
.L40:
	movl	$0, %eax
	addq	$24, %rsp
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
.L50:
	.cfi_restore_state
	leaq	.LC3(%rip), %rdx
	movq	%r12, %rsi
	movl	%ebx, %edi
	call	lmbench_usage@PLT
	jmp	.L38
.L51:
	movl	$64, %ecx
	leaq	.LC5(%rip), %rdx
	movl	$1, %esi
	movq	stderr(%rip), %rdi
	movl	$0, %eax
	call	__fprintf_chk@PLT
	cmpq	$511, %rbp
	jbe	.L40
	movl	$512, %ebx
.L41:
	movl	%r14d, %r9d
	movl	%r13d, %r8d
	movl	%r15d, %ecx
	movl	$64, %edx
	movq	%rbx, %rsi
	movq	%rbp, %rdi
	call	loads
	movq	%rbx, %rdi
	call	step
	movq	%rax, %rbx
	cmpq	%rax, %rbp
	jnb	.L41
	jmp	.L40
	.cfi_endproc
.LFE72:
	.size	main, .-main
	.globl	fpInit
	.section	.data.rel,"aw"
	.align 8
	.type	fpInit, @object
	.size	fpInit, 8
fpInit:
	.quad	stride_initialize
	.globl	id
	.section	.rodata.str1.8
	.align 8
.LC6:
	.string	"$Id: s.lat_mem_rd.c 1.13 98/06/30 16:13:49-07:00 lm@lm.bitmover.com $\n"
	.section	.data.rel.local,"aw"
	.align 8
	.type	id, @object
	.size	id, 8
id:
	.quad	.LC6
	.section	.rodata.cst8,"aM",@progbits,8
	.align 8
.LC0:
	.long	0
	.long	1083129856
	.align 8
.LC1:
	.long	0
	.long	1051721728
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
