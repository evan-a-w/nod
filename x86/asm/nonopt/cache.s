	.file	"cache.c"
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
	.local	addr_save
	.comm	addr_save,8,8
	.text
	.globl	mem_benchmark
	.type	mem_benchmark, @function
mem_benchmark:
.LFB8:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%rbx
	.cfi_offset 3, -24
	movq	%rdi, -32(%rbp)
	movq	%rsi, -40(%rbp)
	movq	-40(%rbp), %rax
	movq	%rax, -16(%rbp)
	movq	addr_save(%rip), %rax
	testq	%rax, %rax
	jne	.L2
	movq	-16(%rbp), %rax
	movq	16(%rax), %rax
	jmp	.L3
.L2:
	movq	addr_save(%rip), %rax
.L3:
	movq	%rax, %rbx
	jmp	.L4
.L5:
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
.L4:
	movq	-32(%rbp), %rax
	leaq	-1(%rax), %rdx
	movq	%rdx, -32(%rbp)
	testq	%rax, %rax
	jne	.L5
	movq	%rbx, addr_save(%rip)
	nop
	movq	-8(%rbp), %rbx
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE8:
	.size	mem_benchmark, .-mem_benchmark
	.section	.rodata
	.align 8
.LC1:
	.string	"[-c] [-L <line size>] [-M len[K|M]] [-W <warmup>] [-N <repetitions>]\n"
.LC2:
	.string	"L:M:W:N:"
.LC3:
	.string	"malloc"
	.align 8
.LC8:
	.string	"L%d cache: %lu bytes %.2f nanoseconds %ld linesize %.2f parallelism\n"
	.align 8
.LC10:
	.string	"Memory latency: %.2f nanoseconds %.2f parallelism\n"
	.text
	.globl	main
	.type	main, @function
main:
.LFB9:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$368, %rsp
	movl	%edi, -356(%rbp)
	movq	%rsi, -368(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movl	$0, -320(%rbp)
	movl	$0, %edi
	call	get_enough@PLT
	cmpl	$999999, %eax
	jle	.L7
	movl	$1, %eax
	jmp	.L8
.L7:
	movl	$11, %eax
.L8:
	movl	%eax, -316(%rbp)
	movq	$0, -296(%rbp)
	movq	$33554432, -288(%rbp)
	leaq	.LC1(%rip), %rax
	movq	%rax, -272(%rbp)
	jmp	.L9
.L16:
	cmpl	$87, -344(%rbp)
	je	.L10
	cmpl	$87, -344(%rbp)
	jg	.L11
	cmpl	$78, -344(%rbp)
	je	.L12
	cmpl	$78, -344(%rbp)
	jg	.L11
	cmpl	$76, -344(%rbp)
	je	.L13
	cmpl	$77, -344(%rbp)
	je	.L14
	jmp	.L11
.L13:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	cltq
	movq	%rax, -296(%rbp)
	movq	-296(%rbp), %rax
	cmpq	$7, %rax
	ja	.L9
	movq	$8, -296(%rbp)
	jmp	.L9
.L14:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	bytes@PLT
	movq	%rax, -288(%rbp)
	jmp	.L9
.L10:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -320(%rbp)
	jmp	.L9
.L12:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -316(%rbp)
	jmp	.L9
.L11:
	movq	-272(%rbp), %rdx
	movq	-368(%rbp), %rcx
	movl	-356(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	lmbench_usage@PLT
	nop
.L9:
	movq	-368(%rbp), %rcx
	movl	-356(%rbp), %eax
	leaq	.LC2(%rip), %rdx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	mygetopt@PLT
	movl	%eax, -344(%rbp)
	cmpl	$-1, -344(%rbp)
	jne	.L16
	movl	$0, %edi
	call	sched_pin@PLT
	movl	$1, -92(%rbp)
	movq	-288(%rbp), %rax
	movq	%rax, -88(%rbp)
	movq	-288(%rbp), %rax
	movq	%rax, -80(%rbp)
	call	getpagesize@PLT
	cltq
	movq	%rax, -64(%rbp)
	cmpq	$0, -296(%rbp)
	jne	.L17
	leaq	-240(%rbp), %rcx
	movl	-316(%rbp), %edx
	movl	-320(%rbp), %esi
	movq	-288(%rbp), %rax
	movq	%rax, %rdi
	call	line_find@PLT
	movq	%rax, -296(%rbp)
	cmpq	$0, -296(%rbp)
	jne	.L18
	call	getpagesize@PLT
	leal	15(%rax), %edx
	testl	%eax, %eax
	cmovs	%edx, %eax
	sarl	$4, %eax
	cltq
	movq	%rax, -296(%rbp)
.L18:
	movq	-296(%rbp), %rax
	movq	%rax, -72(%rbp)
.L17:
	movq	-296(%rbp), %rax
	leaq	-304(%rbp), %rsi
	movl	-316(%rbp), %ecx
	movq	-288(%rbp), %rdx
	movq	%rsi, %r8
	movq	%rax, %rsi
	movl	$512, %edi
	call	collect_data
	movl	%eax, -312(%rbp)
	movq	-304(%rbp), %rcx
	movl	-312(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$3, %rax
	subq	%rdx, %rax
	salq	$3, %rax
	subq	$56, %rax
	leaq	(%rcx,%rax), %rdx
	movq	-296(%rbp), %rax
	movq	%rax, 16(%rdx)
	movl	-312(%rbp), %eax
	cltq
	salq	$2, %rax
	movq	%rax, %rdi
	call	malloc@PLT
	movq	%rax, -264(%rbp)
	cmpq	$0, -264(%rbp)
	jne	.L19
	leaq	.LC3(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L19:
	movl	-312(%rbp), %eax
	cltq
	leaq	0(,%rax,4), %rdx
	movq	-264(%rbp), %rax
	movl	$0, %esi
	movq	%rax, %rdi
	call	memset@PLT
	movl	$0, -332(%rbp)
	movl	$0, -308(%rbp)
	movl	$0, -328(%rbp)
	movsd	.LC4(%rip), %xmm0
	movsd	%xmm0, -280(%rbp)
	jmp	.L20
.L31:
	movq	-304(%rbp), %rcx
	movl	-340(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$3, %rax
	subq	%rdx, %rax
	salq	$3, %rax
	addq	%rcx, %rax
	movsd	24(%rax), %xmm0
	movq	-304(%rbp), %rcx
	movl	-312(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$3, %rax
	subq	%rdx, %rax
	salq	$3, %rax
	subq	$56, %rax
	addq	%rcx, %rax
	movsd	24(%rax), %xmm1
	divsd	%xmm1, %xmm0
	comisd	.LC5(%rip), %xmm0
	ja	.L67
	movq	-304(%rbp), %rcx
	movl	-340(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$3, %rax
	subq	%rdx, %rax
	salq	$3, %rax
	addq	%rcx, %rax
	movq	(%rax), %rax
	movl	%eax, -344(%rbp)
	jmp	.L24
.L25:
	sarl	-344(%rbp)
.L24:
	cmpl	$7, -344(%rbp)
	jg	.L25
	cmpl	$5, -344(%rbp)
	je	.L26
	cmpl	$7, -344(%rbp)
	jne	.L27
.L26:
	addl	$1, -340(%rbp)
	movl	-340(%rbp), %eax
	cmpl	-312(%rbp), %eax
	jge	.L68
.L27:
	movl	-328(%rbp), %eax
	cltq
	leaq	0(,%rax,4), %rdx
	movq	-264(%rbp), %rax
	addq	%rax, %rdx
	movl	-340(%rbp), %eax
	movl	%eax, (%rdx)
	movq	-304(%rbp), %rcx
	movl	-332(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$3, %rax
	subq	%rdx, %rax
	salq	$3, %rax
	addq	%rcx, %rax
	movsd	24(%rax), %xmm0
	pxor	%xmm1, %xmm1
	comisd	%xmm1, %xmm0
	jbe	.L64
	movq	-304(%rbp), %rcx
	movl	-332(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$3, %rax
	subq	%rdx, %rax
	salq	$3, %rax
	addq	%rcx, %rax
	movsd	24(%rax), %xmm0
	jmp	.L30
.L64:
	movq	-304(%rbp), %rcx
	movl	-332(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$3, %rax
	subq	%rdx, %rax
	salq	$3, %rax
	subq	$56, %rax
	addq	%rcx, %rax
	movsd	24(%rax), %xmm0
.L30:
	movsd	%xmm0, -280(%rbp)
	addl	$1, -328(%rbp)
	movl	-340(%rbp), %eax
	addl	$1, %eax
	movl	%eax, -332(%rbp)
	movl	-340(%rbp), %eax
	movl	%eax, -308(%rbp)
.L20:
	movq	-304(%rbp), %rdx
	movq	-280(%rbp), %rsi
	movl	-312(%rbp), %ecx
	movl	-332(%rbp), %eax
	movq	%rsi, %xmm0
	movl	%ecx, %esi
	movl	%eax, %edi
	call	find_cache
	movl	%eax, -340(%rbp)
	cmpl	$0, -340(%rbp)
	jns	.L31
	jmp	.L23
.L67:
	nop
	jmp	.L23
.L68:
	nop
.L23:
	movl	$0, -340(%rbp)
	jmp	.L32
.L52:
	cmpl	$0, -340(%rbp)
	jle	.L33
	movl	-340(%rbp), %eax
	cltq
	salq	$2, %rax
	leaq	-4(%rax), %rdx
	movq	-264(%rbp), %rax
	addq	%rdx, %rax
	movl	(%rax), %eax
	jmp	.L34
.L33:
	movl	$-1, %eax
.L34:
	movl	%eax, -308(%rbp)
	movl	-308(%rbp), %eax
	addl	$1, %eax
	movl	%eax, -324(%rbp)
	movl	-324(%rbp), %eax
	movl	%eax, -336(%rbp)
	jmp	.L35
.L47:
	movq	-304(%rbp), %rcx
	movl	-336(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$3, %rax
	subq	%rdx, %rax
	salq	$3, %rax
	addq	%rcx, %rax
	movsd	24(%rax), %xmm1
	pxor	%xmm0, %xmm0
	comisd	%xmm1, %xmm0
	jnb	.L69
	movq	-304(%rbp), %rcx
	movl	-324(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$3, %rax
	subq	%rdx, %rax
	salq	$3, %rax
	addq	%rcx, %rax
	movsd	24(%rax), %xmm1
	pxor	%xmm0, %xmm0
	comisd	%xmm1, %xmm0
	jnb	.L39
	movq	-304(%rbp), %rcx
	movl	-336(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$3, %rax
	subq	%rdx, %rax
	salq	$3, %rax
	addq	%rcx, %rax
	movsd	48(%rax), %xmm1
	pxor	%xmm0, %xmm0
	comisd	%xmm1, %xmm0
	jbe	.L65
	movq	-304(%rbp), %rcx
	movl	-336(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$3, %rax
	subq	%rdx, %rax
	salq	$3, %rax
	addq	%rcx, %rax
	movsd	48(%rax), %xmm0
	movq	.LC7(%rip), %xmm1
	xorpd	%xmm0, %xmm1
	jmp	.L42
.L65:
	movq	-304(%rbp), %rcx
	movl	-336(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$3, %rax
	subq	%rdx, %rax
	salq	$3, %rax
	addq	%rcx, %rax
	movsd	48(%rax), %xmm1
.L42:
	movq	-304(%rbp), %rcx
	movl	-324(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$3, %rax
	subq	%rdx, %rax
	salq	$3, %rax
	addq	%rcx, %rax
	movsd	48(%rax), %xmm2
	pxor	%xmm0, %xmm0
	comisd	%xmm2, %xmm0
	jbe	.L66
	movq	-304(%rbp), %rcx
	movl	-324(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$3, %rax
	subq	%rdx, %rax
	salq	$3, %rax
	addq	%rcx, %rax
	movsd	48(%rax), %xmm0
	movq	.LC7(%rip), %xmm2
	xorpd	%xmm2, %xmm0
	jmp	.L45
.L66:
	movq	-304(%rbp), %rcx
	movl	-324(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$3, %rax
	subq	%rdx, %rax
	salq	$3, %rax
	addq	%rcx, %rax
	movsd	48(%rax), %xmm0
.L45:
	comisd	%xmm1, %xmm0
	jbe	.L38
.L39:
	movl	-336(%rbp), %eax
	movl	%eax, -324(%rbp)
	jmp	.L38
.L69:
	nop
.L38:
	addl	$1, -336(%rbp)
.L35:
	movl	-340(%rbp), %eax
	cltq
	leaq	0(,%rax,4), %rdx
	movq	-264(%rbp), %rax
	addq	%rdx, %rax
	movl	(%rax), %eax
	cmpl	%eax, -336(%rbp)
	jl	.L47
	movl	-328(%rbp), %eax
	subl	$1, %eax
	cmpl	%eax, -340(%rbp)
	jne	.L48
	movq	-304(%rbp), %rcx
	movl	-312(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$3, %rax
	subq	%rdx, %rax
	salq	$3, %rax
	subq	$56, %rax
	addq	%rcx, %rax
	movq	16(%rax), %rax
	movq	%rax, -296(%rbp)
	jmp	.L49
.L48:
	movl	-340(%rbp), %eax
	cltq
	leaq	0(,%rax,4), %rdx
	movq	-264(%rbp), %rax
	addq	%rdx, %rax
	movl	(%rax), %edx
	movl	-340(%rbp), %eax
	cltq
	addq	$1, %rax
	leaq	0(,%rax,4), %rcx
	movq	-264(%rbp), %rax
	addq	%rcx, %rax
	movl	(%rax), %eax
	addl	%edx, %eax
	movl	%eax, %edx
	shrl	$31, %edx
	addl	%edx, %eax
	sarl	%eax
	movl	%eax, -336(%rbp)
	movq	$-1, -296(%rbp)
	jmp	.L50
.L51:
	movq	-304(%rbp), %rcx
	movl	-336(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$3, %rax
	subq	%rdx, %rax
	salq	$3, %rax
	addq	%rcx, %rax
	movq	(%rax), %rax
	leaq	-240(%rbp), %rcx
	movl	-316(%rbp), %edx
	movl	-320(%rbp), %esi
	movq	%rax, %rdi
	call	line_find@PLT
	movq	%rax, %rdx
	movq	-304(%rbp), %rsi
	movl	-336(%rbp), %eax
	movslq	%eax, %rcx
	movq	%rcx, %rax
	salq	$3, %rax
	subq	%rcx, %rax
	salq	$3, %rax
	addq	%rsi, %rax
	movq	%rdx, 16(%rax)
	movq	-304(%rbp), %rcx
	movl	-336(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$3, %rax
	subq	%rdx, %rax
	salq	$3, %rax
	addq	%rcx, %rax
	movq	16(%rax), %rax
	movq	%rax, -296(%rbp)
	addl	$1, -336(%rbp)
.L50:
	cmpq	$0, -296(%rbp)
	jg	.L49
	movl	-336(%rbp), %eax
	cmpl	-312(%rbp), %eax
	jl	.L51
.L49:
	movq	-304(%rbp), %rcx
	movl	-340(%rbp), %eax
	cltq
	leaq	0(,%rax,4), %rdx
	movq	-264(%rbp), %rax
	addq	%rdx, %rax
	movl	(%rax), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$3, %rax
	subq	%rdx, %rax
	salq	$3, %rax
	subq	$56, %rax
	addq	%rcx, %rax
	movq	(%rax), %rax
	leaq	-240(%rbp), %rcx
	movl	-316(%rbp), %edx
	movl	-320(%rbp), %esi
	movq	%rax, %rdi
	call	par_mem@PLT
	movq	%xmm0, %rax
	movq	%rax, -248(%rbp)
	movq	-304(%rbp), %rcx
	movl	-324(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$3, %rax
	subq	%rdx, %rax
	salq	$3, %rax
	addq	%rcx, %rax
	movq	24(%rax), %rcx
	movq	-304(%rbp), %rsi
	movl	-340(%rbp), %eax
	cltq
	leaq	0(,%rax,4), %rdx
	movq	-264(%rbp), %rax
	addq	%rdx, %rax
	movl	(%rax), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$3, %rax
	subq	%rdx, %rax
	salq	$3, %rax
	addq	%rsi, %rax
	movq	(%rax), %rdx
	movl	-340(%rbp), %eax
	leal	1(%rax), %esi
	movq	stderr(%rip), %rax
	movsd	-248(%rbp), %xmm0
	movq	-296(%rbp), %rdi
	movapd	%xmm0, %xmm1
	movq	%rdi, %r8
	movq	%rcx, %xmm0
	movq	%rdx, %rcx
	movl	%esi, %edx
	leaq	.LC8(%rip), %rsi
	movq	%rax, %rdi
	movl	$2, %eax
	call	fprintf@PLT
	addl	$1, -340(%rbp)
.L32:
	movl	-340(%rbp), %eax
	cmpl	-328(%rbp), %eax
	jl	.L52
	movl	-312(%rbp), %eax
	subl	$1, %eax
	movl	%eax, -336(%rbp)
	movl	-312(%rbp), %eax
	subl	$1, %eax
	movl	%eax, -340(%rbp)
	jmp	.L53
.L58:
	movq	-304(%rbp), %rcx
	movl	-340(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$3, %rax
	subq	%rdx, %rax
	salq	$3, %rax
	addq	%rcx, %rax
	movsd	24(%rax), %xmm1
	pxor	%xmm0, %xmm0
	comisd	%xmm1, %xmm0
	ja	.L70
	movq	-304(%rbp), %rcx
	movl	-340(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$3, %rax
	subq	%rdx, %rax
	salq	$3, %rax
	addq	%rcx, %rax
	movsd	24(%rax), %xmm0
	movq	-304(%rbp), %rcx
	movl	-312(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$3, %rax
	subq	%rdx, %rax
	salq	$3, %rax
	subq	$56, %rax
	addq	%rcx, %rax
	movsd	24(%rax), %xmm2
	movsd	.LC9(%rip), %xmm1
	mulsd	%xmm2, %xmm1
	comisd	%xmm1, %xmm0
	jbe	.L56
	movl	-340(%rbp), %eax
	movl	%eax, -336(%rbp)
	jmp	.L56
.L70:
	nop
.L56:
	subl	$1, -340(%rbp)
.L53:
	cmpl	$0, -340(%rbp)
	jns	.L58
	movq	-304(%rbp), %rcx
	movl	-336(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$3, %rax
	subq	%rdx, %rax
	salq	$3, %rax
	addq	%rcx, %rax
	movq	(%rax), %rax
	leaq	-240(%rbp), %rcx
	movl	-316(%rbp), %edx
	movl	-320(%rbp), %esi
	movq	%rax, %rdi
	call	par_mem@PLT
	movq	%xmm0, %rax
	movq	%rax, -256(%rbp)
	movq	-304(%rbp), %rcx
	movl	-312(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$3, %rax
	subq	%rdx, %rax
	salq	$3, %rax
	subq	$56, %rax
	addq	%rcx, %rax
	movq	24(%rax), %rdx
	movq	stderr(%rip), %rax
	movsd	-256(%rbp), %xmm0
	movapd	%xmm0, %xmm1
	movq	%rdx, %xmm0
	leaq	.LC10(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	movl	$2, %eax
	call	fprintf@PLT
	movl	$0, %edi
	call	exit@PLT
	.cfi_endproc
.LFE9:
	.size	main, .-main
	.globl	find_cache
	.type	find_cache, @function
find_cache:
.LFB10:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%edi, -36(%rbp)
	movl	%esi, -40(%rbp)
	movsd	%xmm0, -48(%rbp)
	movq	%rdx, -56(%rbp)
	movsd	.LC4(%rip), %xmm0
	movsd	%xmm0, -8(%rbp)
	cmpl	$0, -36(%rbp)
	je	.L72
	movl	-36(%rbp), %eax
	subl	$1, %eax
	jmp	.L73
.L72:
	movl	-36(%rbp), %eax
.L73:
	movl	%eax, -12(%rbp)
	jmp	.L74
.L78:
	movl	-12(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$3, %rax
	subq	%rdx, %rax
	salq	$3, %rax
	movq	%rax, %rdx
	movq	-56(%rbp), %rax
	addq	%rdx, %rax
	movsd	40(%rax), %xmm0
	pxor	%xmm1, %xmm1
	comisd	%xmm1, %xmm0
	ja	.L94
	subl	$1, -12(%rbp)
.L74:
	cmpl	$0, -12(%rbp)
	jg	.L78
	jmp	.L77
.L94:
	nop
.L77:
	movl	-36(%rbp), %eax
	movl	%eax, -20(%rbp)
	movl	$-1, -16(%rbp)
	jmp	.L79
.L90:
	movl	-20(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$3, %rax
	subq	%rdx, %rax
	salq	$3, %rax
	movq	%rax, %rdx
	movq	-56(%rbp), %rax
	addq	%rdx, %rax
	movsd	24(%rax), %xmm1
	pxor	%xmm0, %xmm0
	comisd	%xmm1, %xmm0
	ja	.L95
	movl	-20(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$3, %rax
	subq	%rdx, %rax
	salq	$3, %rax
	movq	%rax, %rdx
	movq	-56(%rbp), %rax
	addq	%rdx, %rax
	movsd	40(%rax), %xmm0
	comisd	-8(%rbp), %xmm0
	jbe	.L83
	movl	-20(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$3, %rax
	subq	%rdx, %rax
	salq	$3, %rax
	movq	%rax, %rdx
	movq	-56(%rbp), %rax
	addq	%rdx, %rax
	movsd	40(%rax), %xmm0
	movsd	%xmm0, -8(%rbp)
.L83:
	movl	-20(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$3, %rax
	subq	%rdx, %rax
	salq	$3, %rax
	movq	%rax, %rdx
	movq	-56(%rbp), %rax
	addq	%rdx, %rax
	movsd	40(%rax), %xmm0
	comisd	.LC11(%rip), %xmm0
	jbe	.L85
	movl	-20(%rbp), %eax
	movl	%eax, -16(%rbp)
.L85:
	movsd	-8(%rbp), %xmm0
	comisd	.LC11(%rip), %xmm0
	jbe	.L87
	movl	-16(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$3, %rax
	subq	%rdx, %rax
	salq	$3, %rax
	movq	%rax, %rdx
	movq	-56(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	leaq	(%rax,%rax), %rcx
	movl	-20(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$3, %rax
	subq	%rdx, %rax
	salq	$3, %rax
	movq	%rax, %rdx
	movq	-56(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	cmpq	%rax, %rcx
	ja	.L87
	movl	-16(%rbp), %eax
	jmp	.L89
.L87:
	movl	-20(%rbp), %eax
	movl	%eax, -12(%rbp)
	jmp	.L82
.L95:
	nop
.L82:
	addl	$1, -20(%rbp)
.L79:
	movl	-20(%rbp), %eax
	cmpl	-40(%rbp), %eax
	jl	.L90
	movl	$-1, %eax
.L89:
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE10:
	.size	find_cache, .-find_cache
	.globl	collect_data
	.type	collect_data, @function
collect_data:
.LFB11:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%rbx
	subq	$344, %rsp
	.cfi_offset 3, -24
	movq	%rdi, -312(%rbp)
	movq	%rsi, -320(%rbp)
	movq	%rdx, -328(%rbp)
	movl	%ecx, -332(%rbp)
	movq	%r8, -344(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -24(%rbp)
	xorl	%eax, %eax
	movq	-312(%rbp), %rax
	movq	%rax, -280(%rbp)
	movq	-312(%rbp), %rax
	shrq	$2, %rax
	movq	%rax, -272(%rbp)
	movl	$1, -108(%rbp)
	movq	-328(%rbp), %rax
	movq	%rax, -104(%rbp)
	movq	-328(%rbp), %rax
	movq	%rax, -96(%rbp)
	movq	-320(%rbp), %rax
	movq	%rax, -88(%rbp)
	call	getpagesize@PLT
	cltq
	movq	%rax, -80(%rbp)
	movq	$0, -256(%rbp)
	movq	-312(%rbp), %rax
	movq	%rax, -280(%rbp)
	movq	-312(%rbp), %rax
	shrq	$2, %rax
	movq	%rax, -272(%rbp)
	movl	$0, -288(%rbp)
	jmp	.L97
.L101:
	movl	$0, -292(%rbp)
	jmp	.L98
.L100:
	addl	$1, -288(%rbp)
	addl	$1, -292(%rbp)
	movq	-272(%rbp), %rax
	addq	%rax, -280(%rbp)
.L98:
	cmpl	$3, -292(%rbp)
	jg	.L99
	movq	-280(%rbp), %rax
	cmpq	-328(%rbp), %rax
	jbe	.L100
.L99:
	salq	-272(%rbp)
.L97:
	movq	-280(%rbp), %rax
	cmpq	-328(%rbp), %rax
	jbe	.L101
	movl	-288(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$3, %rax
	subq	%rdx, %rax
	salq	$3, %rax
	movq	%rax, %rdi
	call	malloc@PLT
	movq	%rax, %rdx
	movq	-344(%rbp), %rax
	movq	%rdx, (%rax)
	movq	-344(%rbp), %rax
	movq	(%rax), %rax
	testq	%rax, %rax
	jne	.L102
	leaq	.LC3(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$2, %edi
	call	exit@PLT
.L102:
	movq	-344(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -264(%rbp)
	movq	-312(%rbp), %rax
	movq	%rax, -280(%rbp)
	movq	-312(%rbp), %rax
	shrq	$2, %rax
	movq	%rax, -272(%rbp)
	movl	$0, -284(%rbp)
	jmp	.L103
.L107:
	movl	$0, -292(%rbp)
	jmp	.L104
.L106:
	movl	-284(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$3, %rax
	subq	%rdx, %rax
	salq	$3, %rax
	movq	%rax, %rdx
	movq	-264(%rbp), %rax
	addq	%rax, %rdx
	movq	-280(%rbp), %rax
	movq	%rax, (%rdx)
	movl	-284(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$3, %rax
	subq	%rdx, %rax
	salq	$3, %rax
	movq	%rax, %rdx
	movq	-264(%rbp), %rax
	addq	%rax, %rdx
	movq	-320(%rbp), %rax
	movq	%rax, 16(%rdx)
	movl	-284(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$3, %rax
	subq	%rdx, %rax
	salq	$3, %rax
	movq	%rax, %rdx
	movq	-264(%rbp), %rax
	addq	%rdx, %rax
	movsd	.LC4(%rip), %xmm0
	movsd	%xmm0, 24(%rax)
	movl	-284(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$3, %rax
	subq	%rdx, %rax
	salq	$3, %rax
	movq	%rax, %rdx
	movq	-264(%rbp), %rax
	addq	%rdx, %rax
	movsd	.LC4(%rip), %xmm0
	movsd	%xmm0, 40(%rax)
	movl	-284(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$3, %rax
	subq	%rdx, %rax
	salq	$3, %rax
	movq	%rax, %rdx
	movq	-264(%rbp), %rax
	addq	%rdx, %rax
	movsd	.LC4(%rip), %xmm0
	movsd	%xmm0, 48(%rax)
	addl	$1, -292(%rbp)
	addl	$1, -284(%rbp)
	movq	-272(%rbp), %rax
	addq	%rax, -280(%rbp)
.L104:
	cmpl	$3, -292(%rbp)
	jg	.L105
	movq	-280(%rbp), %rax
	cmpq	-328(%rbp), %rax
	jbe	.L106
.L105:
	salq	-272(%rbp)
.L103:
	movq	-280(%rbp), %rax
	cmpq	-328(%rbp), %rax
	jbe	.L107
	jmp	.L108
.L111:
	leaq	-256(%rbp), %rax
	movq	%rax, %rsi
	movl	$0, %edi
	call	mem_initialize@PLT
	movq	-256(%rbp), %rax
	testq	%rax, %rax
	jne	.L108
	movq	-328(%rbp), %rax
	shrq	%rax
	movq	%rax, -328(%rbp)
	movq	-328(%rbp), %rax
	movq	%rax, -96(%rbp)
	movq	-96(%rbp), %rax
	movq	%rax, -104(%rbp)
	jmp	.L109
.L110:
	subl	$1, -288(%rbp)
.L109:
	movl	-288(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$3, %rax
	subq	%rdx, %rax
	salq	$3, %rax
	leaq	-56(%rax), %rdx
	movq	-264(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	cmpq	%rax, -328(%rbp)
	jb	.L110
.L108:
	movq	-256(%rbp), %rax
	testq	%rax, %rax
	je	.L111
	movl	$0, -292(%rbp)
	jmp	.L112
.L113:
	movl	-292(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$3, %rax
	subq	%rdx, %rax
	salq	$3, %rax
	movq	%rax, %rdx
	movq	-264(%rbp), %rax
	addq	%rax, %rdx
	movq	-328(%rbp), %rax
	movq	%rax, 8(%rdx)
	addl	$1, -292(%rbp)
.L112:
	movl	-292(%rbp), %eax
	cmpl	-288(%rbp), %eax
	jl	.L113
	movl	$0, -292(%rbp)
	jmp	.L114
.L115:
	movl	-292(%rbp), %eax
	movslq	%eax, %rcx
	movq	-80(%rbp), %rax
	movq	-48(%rbp), %rsi
	movl	-292(%rbp), %edx
	movslq	%edx, %rdx
	salq	$3, %rdx
	addq	%rsi, %rdx
	imulq	%rcx, %rax
	movq	%rax, (%rdx)
	addl	$1, -292(%rbp)
.L114:
	movl	-292(%rbp), %eax
	movslq	%eax, %rdx
	movq	-64(%rbp), %rax
	cmpq	%rax, %rdx
	jb	.L115
	movl	-288(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$3, %rax
	subq	%rdx, %rax
	salq	$3, %rax
	leaq	-56(%rax), %rdx
	movq	-264(%rbp), %rax
	addq	%rdx, %rax
	leaq	32(%rax), %rsi
	movl	-288(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$3, %rax
	subq	%rdx, %rax
	salq	$3, %rax
	leaq	-56(%rax), %rdx
	movq	-264(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rdi
	movl	-288(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$3, %rax
	subq	%rdx, %rax
	salq	$3, %rax
	leaq	-56(%rax), %rdx
	movq	-264(%rbp), %rax
	leaq	(%rdx,%rax), %rbx
	leaq	-256(%rbp), %rdx
	movl	-332(%rbp), %eax
	movq	%rdx, %rcx
	movq	%rsi, %rdx
	movl	%eax, %esi
	call	measure
	movq	%xmm0, %rax
	movq	%rax, 24(%rbx)
	jmp	.L116
.L117:
	movl	-288(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$3, %rax
	subq	%rdx, %rax
	salq	$3, %rax
	leaq	-56(%rax), %rdx
	movq	-264(%rbp), %rax
	addq	%rdx, %rax
	leaq	32(%rax), %rsi
	movl	-288(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$3, %rax
	subq	%rdx, %rax
	salq	$3, %rax
	leaq	-56(%rax), %rdx
	movq	-264(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rdi
	movl	-288(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$3, %rax
	subq	%rdx, %rax
	salq	$3, %rax
	leaq	-56(%rax), %rdx
	movq	-264(%rbp), %rax
	leaq	(%rdx,%rax), %rbx
	leaq	-256(%rbp), %rdx
	movl	-332(%rbp), %eax
	movq	%rdx, %rcx
	movq	%rsi, %rdx
	movl	%eax, %esi
	call	measure
	movq	%xmm0, %rax
	movq	%rax, 24(%rbx)
	subl	$1, -288(%rbp)
.L116:
	movl	-288(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$3, %rax
	subq	%rdx, %rax
	salq	$3, %rax
	leaq	-56(%rax), %rdx
	movq	-264(%rbp), %rax
	addq	%rdx, %rax
	movsd	24(%rax), %xmm1
	pxor	%xmm0, %xmm0
	comisd	%xmm1, %xmm0
	jnb	.L117
	movq	-264(%rbp), %rax
	leaq	32(%rax), %rdi
	movq	-264(%rbp), %rax
	movq	(%rax), %rax
	leaq	-256(%rbp), %rdx
	movl	-332(%rbp), %esi
	movq	%rdx, %rcx
	movq	%rdi, %rdx
	movq	%rax, %rdi
	call	measure
	movq	%xmm0, %rax
	movq	-264(%rbp), %rdx
	movq	%rax, 24(%rdx)
	movl	-288(%rbp), %eax
	leal	-1(%rax), %esi
	movq	-264(%rbp), %rcx
	leaq	-256(%rbp), %rdx
	movl	-332(%rbp), %eax
	movq	%rcx, %r8
	movq	%rdx, %rcx
	movl	%eax, %edx
	movl	$0, %edi
	call	search
	leaq	-256(%rbp), %rax
	movq	%rax, %rsi
	movl	$0, %edi
	call	mem_cleanup@PLT
	movl	-288(%rbp), %eax
	movq	-24(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L119
	call	__stack_chk_fail@PLT
.L119:
	movq	-8(%rbp), %rbx
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE11:
	.size	collect_data, .-collect_data
	.globl	search
	.type	search, @function
search:
.LFB12:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$48, %rsp
	movl	%edi, -20(%rbp)
	movl	%esi, -24(%rbp)
	movl	%edx, -28(%rbp)
	movq	%rcx, -40(%rbp)
	movq	%r8, -48(%rbp)
	movl	-24(%rbp), %eax
	subl	-20(%rbp), %eax
	movl	%eax, %edx
	shrl	$31, %edx
	addl	%edx, %eax
	sarl	%eax
	movl	%eax, %edx
	movl	-20(%rbp), %eax
	addl	%edx, %eax
	movl	%eax, -4(%rbp)
	movl	-20(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$3, %rax
	subq	%rdx, %rax
	salq	$3, %rax
	movq	%rax, %rdx
	movq	-48(%rbp), %rax
	addq	%rdx, %rax
	movsd	24(%rax), %xmm0
	pxor	%xmm1, %xmm1
	comisd	%xmm1, %xmm0
	jbe	.L121
	movl	-24(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$3, %rax
	subq	%rdx, %rax
	salq	$3, %rax
	movq	%rax, %rdx
	movq	-48(%rbp), %rax
	addq	%rdx, %rax
	movsd	24(%rax), %xmm0
	movl	-20(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$3, %rax
	subq	%rdx, %rax
	salq	$3, %rax
	movq	%rax, %rdx
	movq	-48(%rbp), %rax
	addq	%rdx, %rax
	movsd	24(%rax), %xmm1
	movl	-20(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$3, %rax
	subq	%rdx, %rax
	salq	$3, %rax
	movq	%rax, %rdx
	movq	-48(%rbp), %rax
	addq	%rdx, %rax
	divsd	%xmm1, %xmm0
	movsd	%xmm0, 40(%rax)
	movl	-20(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$3, %rax
	subq	%rdx, %rax
	salq	$3, %rax
	movq	%rax, %rdx
	movq	-48(%rbp), %rax
	addq	%rdx, %rax
	movsd	40(%rax), %xmm0
	movsd	.LC12(%rip), %xmm1
	subsd	%xmm1, %xmm0
	movl	-24(%rbp), %eax
	subl	-20(%rbp), %eax
	pxor	%xmm1, %xmm1
	cvtsi2sdl	%eax, %xmm1
	movl	-20(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$3, %rax
	subq	%rdx, %rax
	salq	$3, %rax
	movq	%rax, %rdx
	movq	-48(%rbp), %rax
	addq	%rdx, %rax
	divsd	%xmm1, %xmm0
	movsd	%xmm0, 48(%rax)
	movl	-20(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$3, %rax
	subq	%rdx, %rax
	salq	$3, %rax
	movq	%rax, %rdx
	movq	-48(%rbp), %rax
	addq	%rdx, %rax
	movsd	40(%rax), %xmm1
	movsd	.LC13(%rip), %xmm0
	comisd	%xmm1, %xmm0
	jbe	.L121
	movl	-24(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$3, %rax
	subq	%rdx, %rax
	salq	$3, %rax
	movq	%rax, %rdx
	movq	-48(%rbp), %rax
	leaq	(%rdx,%rax), %rcx
	movl	-20(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$3, %rax
	subq	%rdx, %rax
	salq	$3, %rax
	movq	%rax, %rdx
	movq	-48(%rbp), %rax
	addq	%rdx, %rax
	movsd	24(%rcx), %xmm0
	movsd	%xmm0, 24(%rax)
	movl	-20(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$3, %rax
	subq	%rdx, %rax
	salq	$3, %rax
	movq	%rax, %rdx
	movq	-48(%rbp), %rax
	addq	%rdx, %rax
	movsd	.LC12(%rip), %xmm0
	movsd	%xmm0, 40(%rax)
	movl	-20(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$3, %rax
	subq	%rdx, %rax
	salq	$3, %rax
	movq	%rax, %rdx
	movq	-48(%rbp), %rax
	addq	%rdx, %rax
	pxor	%xmm0, %xmm0
	movsd	%xmm0, 48(%rax)
.L121:
	movl	-4(%rbp), %eax
	cmpl	-20(%rbp), %eax
	je	.L132
	movl	-4(%rbp), %eax
	cmpl	-24(%rbp), %eax
	je	.L132
	movl	-20(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$3, %rax
	subq	%rdx, %rax
	salq	$3, %rax
	movq	%rax, %rdx
	movq	-48(%rbp), %rax
	addq	%rdx, %rax
	movsd	40(%rax), %xmm0
	comisd	.LC14(%rip), %xmm0
	ja	.L127
	movl	-20(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$3, %rax
	subq	%rdx, %rax
	salq	$3, %rax
	movq	%rax, %rdx
	movq	-48(%rbp), %rax
	addq	%rdx, %rax
	movsd	40(%rax), %xmm1
	movsd	.LC15(%rip), %xmm0
	comisd	%xmm1, %xmm0
	ja	.L127
	jmp	.L120
.L127:
	movl	-4(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$3, %rax
	subq	%rdx, %rax
	salq	$3, %rax
	movq	%rax, %rdx
	movq	-48(%rbp), %rax
	addq	%rax, %rdx
	movq	-40(%rbp), %rcx
	movl	-28(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	collect_sample
	movq	-48(%rbp), %rdi
	movq	-40(%rbp), %rcx
	movl	-28(%rbp), %edx
	movl	-24(%rbp), %esi
	movl	-4(%rbp), %eax
	movq	%rdi, %r8
	movl	%eax, %edi
	call	search
	movq	-48(%rbp), %rdi
	movq	-40(%rbp), %rcx
	movl	-28(%rbp), %edx
	movl	-4(%rbp), %esi
	movl	-20(%rbp), %eax
	movq	%rdi, %r8
	movl	%eax, %edi
	call	search
	jmp	.L120
.L132:
	nop
.L120:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE12:
	.size	search, .-search
	.globl	collect_sample
	.type	collect_sample, @function
collect_sample:
.LFB13:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%rbx
	subq	$72, %rsp
	.cfi_offset 3, -24
	movl	%edi, -52(%rbp)
	movq	%rsi, -64(%rbp)
	movq	%rdx, -72(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -24(%rbp)
	xorl	%eax, %eax
	movq	-72(%rbp), %rax
	movq	(%rax), %rbx
	call	getpagesize@PLT
	cltq
	addq	%rbx, %rax
	leaq	-1(%rax), %rbx
	call	getpagesize@PLT
	movslq	%eax, %rcx
	movq	%rbx, %rax
	movl	$0, %edx
	divq	%rcx
	movl	%eax, -36(%rbp)
	movq	-72(%rbp), %rax
	leaq	32(%rax), %rdi
	movq	-72(%rbp), %rax
	movq	(%rax), %rax
	movq	-64(%rbp), %rdx
	movl	-52(%rbp), %esi
	movq	%rdx, %rcx
	movq	%rdi, %rdx
	movq	%rax, %rdi
	call	measure
	movq	%xmm0, %rax
	movq	%rax, -32(%rbp)
	cmpl	$1, -36(%rbp)
	jle	.L134
	movl	$0, -44(%rbp)
	movl	$1, -40(%rbp)
	jmp	.L135
.L136:
	movq	-72(%rbp), %rax
	movq	(%rax), %rdi
	movq	-64(%rbp), %rax
	movq	208(%rax), %rcx
	movl	-36(%rbp), %eax
	movslq	%eax, %rdx
	movl	-36(%rbp), %eax
	cltq
	leaq	-32(%rbp), %r8
	pushq	-64(%rbp)
	movl	-52(%rbp), %esi
	pushq	%rsi
	movq	.LC6(%rip), %rsi
	movq	%rsi, %xmm0
	movq	%r8, %r9
	movq	%rdi, %r8
	movq	%rax, %rsi
	movl	$0, %edi
	call	test_chunk
	addq	$16, %rsp
	movl	%eax, -40(%rbp)
	addl	$1, -44(%rbp)
.L135:
	cmpl	$7, -44(%rbp)
	jg	.L134
	cmpl	$0, -40(%rbp)
	jne	.L136
.L134:
	movsd	-32(%rbp), %xmm0
	movq	-72(%rbp), %rax
	movsd	%xmm0, 24(%rax)
	movq	-72(%rbp), %rax
	movsd	24(%rax), %xmm0
	pxor	%xmm1, %xmm1
	comisd	%xmm1, %xmm0
	seta	%al
	movzbl	%al, %eax
	movq	-24(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L138
	call	__stack_chk_fail@PLT
.L138:
	movq	-8(%rbp), %rbx
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE13:
	.size	collect_sample, .-collect_sample
	.globl	measure
	.type	measure, @function
measure:
.LFB14:
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
	movq	%rdi, -152(%rbp)
	movl	%esi, -156(%rbp)
	movq	%rdx, -168(%rbp)
	movq	%rcx, -176(%rbp)
	movq	-176(%rbp), %rax
	movq	208(%rax), %rax
	movq	%rax, -88(%rbp)
	call	getpagesize@PLT
	movslq	%eax, %rdx
	movq	-152(%rbp), %rax
	addq	%rdx, %rax
	leaq	-1(%rax), %rbx
	call	getpagesize@PLT
	movslq	%eax, %rsi
	movq	%rbx, %rax
	movl	$0, %edx
	divq	%rsi
	movq	%rax, -80(%rbp)
	movq	-176(%rbp), %rax
	movq	184(%rax), %rax
	movq	%rax, -112(%rbp)
	call	getpagesize@PLT
	movslq	%eax, %rcx
	movq	-152(%rbp), %rax
	movl	$0, %edx
	divq	%rcx
	movq	%rdx, %rax
	testq	%rax, %rax
	je	.L140
	call	getpagesize@PLT
	movslq	%eax, %rcx
	movq	-152(%rbp), %rax
	movl	$0, %edx
	divq	%rcx
	movq	%rdx, %rcx
	movq	-176(%rbp), %rax
	movq	168(%rax), %rbx
	movq	%rcx, %rax
	movl	$0, %edx
	divq	%rbx
	movq	%rax, -112(%rbp)
.L140:
	movl	$0, %eax
	call	get_results@PLT
	movq	%rax, -72(%rbp)
	movl	-156(%rbp), %eax
	movl	%eax, %edi
	call	sizeof_result@PLT
	cltq
	movq	%rax, %rdi
	call	malloc@PLT
	movq	%rax, -64(%rbp)
	cmpq	$0, -64(%rbp)
	jne	.L141
	leaq	.LC3(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$3, %edi
	call	exit@PLT
.L141:
	movq	-64(%rbp), %rax
	movq	%rax, %rdi
	call	insertinit@PLT
	movq	-176(%rbp), %rax
	movq	8(%rax), %rax
	movq	%rax, -56(%rbp)
	movq	$0, -128(%rbp)
	jmp	.L142
.L145:
	movq	$0, -120(%rbp)
	jmp	.L143
.L144:
	movq	-128(%rbp), %rax
	addq	$1, %rax
	leaq	0(,%rax,8), %rdx
	movq	-88(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rdx
	movq	-176(%rbp), %rax
	movq	216(%rax), %rax
	movq	(%rax), %rax
	leaq	(%rdx,%rax), %rcx
	movq	-176(%rbp), %rax
	movq	224(%rax), %rdx
	movq	-120(%rbp), %rax
	salq	$3, %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	leaq	(%rcx,%rax), %rsi
	movq	-128(%rbp), %rax
	leaq	0(,%rax,8), %rdx
	movq	-88(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rdx
	movq	-176(%rbp), %rax
	movq	216(%rax), %rcx
	movq	-176(%rbp), %rax
	movq	184(%rax), %rax
	salq	$3, %rax
	subq	$8, %rax
	addq	%rcx, %rax
	movq	(%rax), %rax
	leaq	(%rdx,%rax), %rcx
	movq	-176(%rbp), %rax
	movq	224(%rax), %rdx
	movq	-120(%rbp), %rax
	salq	$3, %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	leaq	(%rcx,%rax), %rdx
	movq	-56(%rbp), %rax
	addq	%rdx, %rax
	movq	-56(%rbp), %rdx
	addq	%rsi, %rdx
	movq	%rdx, (%rax)
	addq	$1, -120(%rbp)
.L143:
	movq	-176(%rbp), %rax
	movq	200(%rax), %rax
	cmpq	%rax, -120(%rbp)
	jb	.L144
	addq	$1, -128(%rbp)
.L142:
	movq	-80(%rbp), %rax
	subq	$1, %rax
	cmpq	%rax, -128(%rbp)
	jb	.L145
	movq	$0, -120(%rbp)
	jmp	.L146
.L147:
	movq	-88(%rbp), %rax
	movq	(%rax), %rdx
	movq	-176(%rbp), %rax
	movq	216(%rax), %rax
	movq	(%rax), %rax
	leaq	(%rdx,%rax), %rdi
	movq	-176(%rbp), %rax
	movq	224(%rax), %rsi
	movq	-120(%rbp), %rax
	leaq	1(%rax), %rdx
	movq	-176(%rbp), %rax
	movq	200(%rax), %rcx
	movq	%rdx, %rax
	movl	$0, %edx
	divq	%rcx
	movq	%rdx, %rax
	salq	$3, %rax
	addq	%rsi, %rax
	movq	(%rax), %rax
	leaq	(%rdi,%rax), %rsi
	movq	-80(%rbp), %rax
	salq	$3, %rax
	leaq	-8(%rax), %rdx
	movq	-88(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rdx
	movq	-176(%rbp), %rax
	movq	216(%rax), %rcx
	movq	-112(%rbp), %rax
	salq	$3, %rax
	subq	$8, %rax
	addq	%rcx, %rax
	movq	(%rax), %rax
	leaq	(%rdx,%rax), %rcx
	movq	-176(%rbp), %rax
	movq	224(%rax), %rdx
	movq	-120(%rbp), %rax
	salq	$3, %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	leaq	(%rcx,%rax), %rdx
	movq	-56(%rbp), %rax
	addq	%rdx, %rax
	movq	-56(%rbp), %rdx
	addq	%rsi, %rdx
	movq	%rdx, (%rax)
	addq	$1, -120(%rbp)
.L146:
	movq	-176(%rbp), %rax
	movq	200(%rax), %rax
	cmpq	%rax, -120(%rbp)
	jb	.L147
	movq	$0, addr_save(%rip)
	movq	-88(%rbp), %rax
	movq	(%rax), %rdx
	movq	-176(%rbp), %rax
	movq	216(%rax), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	movq	-176(%rbp), %rax
	movq	224(%rax), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	movq	-56(%rbp), %rax
	addq	%rax, %rdx
	movq	-176(%rbp), %rax
	movq	%rdx, 16(%rax)
	movq	-152(%rbp), %rax
	shrq	$3, %rax
	addq	$100, %rax
	shrq	$2, %rax
	movabsq	$2951479051793528259, %rdx
	mulq	%rdx
	shrq	$2, %rdx
	movq	-176(%rbp), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	mem_benchmark
	movq	$0, -128(%rbp)
	jmp	.L148
.L178:
	movl	$0, %edi
	call	get_enough@PLT
	movl	%eax, -132(%rbp)
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -96(%rbp)
	jmp	.L149
.L164:
	movl	$0, %edi
	call	start@PLT
	movq	__iterations.1(%rip), %rax
	movq	%rax, -104(%rbp)
	jmp	.L150
.L151:
	movq	-176(%rbp), %rdx
	movq	-104(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	mem_benchmark
	movq	$1, -104(%rbp)
	subq	$1, -104(%rbp)
.L150:
	cmpq	$0, -104(%rbp)
	jne	.L151
	movl	$0, %esi
	movl	$0, %edi
	call	stop@PLT
	testq	%rax, %rax
	js	.L152
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L153
.L152:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L153:
	movsd	%xmm0, -96(%rbp)
	pxor	%xmm1, %xmm1
	cvtsi2sdl	-132(%rbp), %xmm1
	movsd	.LC9(%rip), %xmm0
	mulsd	%xmm1, %xmm0
	comisd	-96(%rbp), %xmm0
	ja	.L154
	pxor	%xmm1, %xmm1
	cvtsi2sdl	-132(%rbp), %xmm1
	movsd	.LC16(%rip), %xmm0
	mulsd	%xmm0, %xmm1
	movsd	-96(%rbp), %xmm0
	comisd	%xmm1, %xmm0
	ja	.L154
	jmp	.L149
.L154:
	movsd	-96(%rbp), %xmm0
	comisd	.LC17(%rip), %xmm0
	jbe	.L197
	movq	__iterations.1(%rip), %rax
	testq	%rax, %rax
	js	.L158
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L159
.L158:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L159:
	divsd	-96(%rbp), %xmm0
	movsd	%xmm0, -32(%rbp)
	pxor	%xmm1, %xmm1
	cvtsi2sdl	-132(%rbp), %xmm1
	movsd	.LC18(%rip), %xmm0
	mulsd	%xmm1, %xmm0
	movsd	-32(%rbp), %xmm1
	mulsd	%xmm1, %xmm0
	movsd	%xmm0, -32(%rbp)
	movsd	-32(%rbp), %xmm1
	movsd	.LC12(%rip), %xmm0
	addsd	%xmm1, %xmm0
	comisd	.LC19(%rip), %xmm0
	jnb	.L160
	cvttsd2siq	%xmm0, %rax
	jmp	.L161
.L160:
	movsd	.LC19(%rip), %xmm1
	subsd	%xmm1, %xmm0
	cvttsd2siq	%xmm0, %rax
	movabsq	$-9223372036854775808, %rdx
	xorq	%rdx, %rax
.L161:
	movq	%rax, __iterations.1(%rip)
	jmp	.L149
.L197:
	movq	__iterations.1(%rip), %rax
	cmpq	$134217728, %rax
	jbe	.L162
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -96(%rbp)
	jmp	.L163
.L162:
	movq	__iterations.1(%rip), %rax
	salq	$3, %rax
	movq	%rax, __iterations.1(%rip)
.L149:
	pxor	%xmm1, %xmm1
	cvtsi2sdl	-132(%rbp), %xmm1
	movsd	.LC20(%rip), %xmm0
	mulsd	%xmm1, %xmm0
	comisd	-96(%rbp), %xmm0
	ja	.L164
.L163:
	movq	__iterations.1(%rip), %rax
	movq	%rax, %rdi
	call	save_n@PLT
	movsd	-96(%rbp), %xmm0
	comisd	.LC19(%rip), %xmm0
	jnb	.L165
	movsd	-96(%rbp), %xmm0
	cvttsd2siq	%xmm0, %rax
	jmp	.L166
.L165:
	movsd	-96(%rbp), %xmm0
	movsd	.LC19(%rip), %xmm1
	subsd	%xmm1, %xmm0
	cvttsd2siq	%xmm0, %rax
	movabsq	$-9223372036854775808, %rdx
	xorq	%rdx, %rax
.L166:
	movq	%rax, %rdi
	call	settime@PLT
	call	usecs_spent@PLT
	testq	%rax, %rax
	js	.L167
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L168
.L167:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L168:
	movsd	%xmm0, -24(%rbp)
	call	t_overhead@PLT
	testq	%rax, %rax
	js	.L169
	pxor	%xmm2, %xmm2
	cvtsi2sdq	%rax, %xmm2
	movsd	%xmm2, -184(%rbp)
	jmp	.L170
.L169:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
	movsd	%xmm0, -184(%rbp)
.L170:
	call	get_n@PLT
	testq	%rax, %rax
	js	.L171
	pxor	%xmm3, %xmm3
	cvtsi2sdq	%rax, %xmm3
	movsd	%xmm3, -192(%rbp)
	jmp	.L172
.L171:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
	movsd	%xmm0, -192(%rbp)
.L172:
	call	l_overhead@PLT
	mulsd	-192(%rbp), %xmm0
	movsd	-184(%rbp), %xmm1
	addsd	%xmm0, %xmm1
	movsd	-24(%rbp), %xmm0
	subsd	%xmm1, %xmm0
	movsd	%xmm0, -24(%rbp)
	movsd	-24(%rbp), %xmm0
	pxor	%xmm1, %xmm1
	comisd	%xmm1, %xmm0
	jb	.L198
	movsd	-24(%rbp), %xmm0
	comisd	.LC19(%rip), %xmm0
	jnb	.L175
	movsd	-24(%rbp), %xmm0
	cvttsd2siq	%xmm0, %rax
	jmp	.L177
.L175:
	movsd	-24(%rbp), %xmm0
	movsd	.LC19(%rip), %xmm1
	subsd	%xmm1, %xmm0
	cvttsd2siq	%xmm0, %rax
	movabsq	$-9223372036854775808, %rdx
	xorq	%rdx, %rax
	jmp	.L177
.L198:
	movl	$0, %eax
.L177:
	movq	%rax, %rdi
	call	settime@PLT
	call	get_n@PLT
	movq	%rax, %rbx
	call	usecs_spent@PLT
	movq	%rax, %rcx
	movq	-64(%rbp), %rax
	movq	%rax, %rdx
	movq	%rbx, %rsi
	movq	%rcx, %rdi
	call	insertsort@PLT
	addq	$1, -128(%rbp)
.L148:
	movl	-156(%rbp), %eax
	cltq
	cmpq	%rax, -128(%rbp)
	jb	.L178
	movq	-64(%rbp), %rax
	movq	%rax, %rdi
	call	set_results@PLT
	call	usecs_spent@PLT
	testq	%rax, %rax
	js	.L179
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L180
.L179:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L180:
	movsd	.LC21(%rip), %xmm1
	mulsd	%xmm1, %xmm0
	movsd	%xmm0, -184(%rbp)
	call	get_n@PLT
	testq	%rax, %rax
	js	.L181
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L182
.L181:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L182:
	movsd	.LC22(%rip), %xmm1
	mulsd	%xmm0, %xmm1
	movsd	-184(%rbp), %xmm0
	divsd	%xmm1, %xmm0
	movsd	%xmm0, -48(%rbp)
	movl	$0, %eax
	call	save_minimum@PLT
	call	usecs_spent@PLT
	testq	%rax, %rax
	js	.L183
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L184
.L183:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L184:
	movsd	.LC21(%rip), %xmm1
	mulsd	%xmm1, %xmm0
	movsd	%xmm0, -184(%rbp)
	call	get_n@PLT
	testq	%rax, %rax
	js	.L185
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L186
.L185:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L186:
	movsd	.LC22(%rip), %xmm1
	mulsd	%xmm0, %xmm1
	movsd	-184(%rbp), %xmm0
	divsd	%xmm1, %xmm0
	movsd	%xmm0, -40(%rbp)
	pxor	%xmm0, %xmm0
	ucomisd	-40(%rbp), %xmm0
	jp	.L196
	pxor	%xmm0, %xmm0
	ucomisd	-40(%rbp), %xmm0
	je	.L187
.L196:
	movsd	-48(%rbp), %xmm0
	divsd	-40(%rbp), %xmm0
	movq	-168(%rbp), %rax
	movsd	%xmm0, (%rax)
	jmp	.L189
.L187:
	movq	-168(%rbp), %rax
	movsd	.LC4(%rip), %xmm0
	movsd	%xmm0, (%rax)
.L189:
	movq	-72(%rbp), %rax
	movq	%rax, %rdi
	call	set_results@PLT
	movq	-64(%rbp), %rax
	movq	%rax, %rdi
	call	free@PLT
	movq	-176(%rbp), %rax
	movq	184(%rax), %rax
	cmpq	%rax, -112(%rbp)
	jnb	.L190
	movq	$0, -120(%rbp)
	jmp	.L191
.L192:
	movq	-80(%rbp), %rax
	salq	$3, %rax
	leaq	-8(%rax), %rdx
	movq	-88(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rdx
	movq	-176(%rbp), %rax
	movq	216(%rax), %rcx
	movq	-112(%rbp), %rax
	salq	$3, %rax
	addq	%rcx, %rax
	movq	(%rax), %rax
	leaq	(%rdx,%rax), %rcx
	movq	-176(%rbp), %rax
	movq	224(%rax), %rdx
	movq	-120(%rbp), %rax
	salq	$3, %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	leaq	(%rcx,%rax), %rsi
	movq	-80(%rbp), %rax
	salq	$3, %rax
	leaq	-8(%rax), %rdx
	movq	-88(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rdx
	movq	-176(%rbp), %rax
	movq	216(%rax), %rcx
	movq	-112(%rbp), %rax
	salq	$3, %rax
	subq	$8, %rax
	addq	%rcx, %rax
	movq	(%rax), %rax
	leaq	(%rdx,%rax), %rcx
	movq	-176(%rbp), %rax
	movq	224(%rax), %rdx
	movq	-120(%rbp), %rax
	salq	$3, %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	leaq	(%rcx,%rax), %rdx
	movq	-56(%rbp), %rax
	addq	%rdx, %rax
	movq	-56(%rbp), %rdx
	addq	%rsi, %rdx
	movq	%rdx, (%rax)
	addq	$1, -120(%rbp)
.L191:
	movq	-176(%rbp), %rax
	movq	200(%rax), %rax
	cmpq	%rax, -120(%rbp)
	jb	.L192
.L190:
	movsd	-48(%rbp), %xmm0
	movq	%xmm0, %rax
	movq	%rax, %xmm0
	movq	-8(%rbp), %rbx
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE14:
	.size	measure, .-measure
	.globl	remove_chunk
	.type	remove_chunk, @function
remove_chunk:
.LFB15:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$112, %rsp
	movq	%rdi, -56(%rbp)
	movq	%rsi, -64(%rbp)
	movq	%rdx, -72(%rbp)
	movq	%rcx, -80(%rbp)
	movq	%r8, -88(%rbp)
	movl	%r9d, -92(%rbp)
	movq	16(%rbp), %rax
	movq	%rax, -104(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movq	-56(%rbp), %rdx
	movq	-64(%rbp), %rax
	addq	%rdx, %rax
	cmpq	%rax, -72(%rbp)
	jbe	.L200
	movq	$0, -32(%rbp)
	jmp	.L201
.L202:
	movq	-56(%rbp), %rdx
	movq	-32(%rbp), %rax
	addq	%rdx, %rax
	leaq	0(,%rax,8), %rdx
	movq	-80(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	%rax, -24(%rbp)
	movq	-72(%rbp), %rax
	subq	-32(%rbp), %rax
	subq	$1, %rax
	leaq	0(,%rax,8), %rdx
	movq	-80(%rbp), %rax
	addq	%rdx, %rax
	movq	-56(%rbp), %rcx
	movq	-32(%rbp), %rdx
	addq	%rcx, %rdx
	leaq	0(,%rdx,8), %rcx
	movq	-80(%rbp), %rdx
	addq	%rcx, %rdx
	movq	(%rax), %rax
	movq	%rax, (%rdx)
	movq	-72(%rbp), %rax
	subq	-32(%rbp), %rax
	subq	$1, %rax
	leaq	0(,%rax,8), %rdx
	movq	-80(%rbp), %rax
	addq	%rax, %rdx
	movq	-24(%rbp), %rax
	movq	%rax, (%rdx)
	addq	$1, -32(%rbp)
.L201:
	movq	-32(%rbp), %rax
	cmpq	-64(%rbp), %rax
	jb	.L202
.L200:
	call	getpagesize@PLT
	cltq
	imulq	-64(%rbp), %rax
	movq	%rax, %rdx
	movq	-88(%rbp), %rax
	subq	%rdx, %rax
	movq	%rax, %rdi
	movq	-104(%rbp), %rcx
	leaq	-40(%rbp), %rdx
	movl	-92(%rbp), %eax
	movl	%eax, %esi
	call	measure
	movq	%xmm0, %rax
	movq	%rax, -16(%rbp)
	movq	-56(%rbp), %rdx
	movq	-64(%rbp), %rax
	addq	%rdx, %rax
	cmpq	%rax, -72(%rbp)
	jbe	.L203
	movq	$0, -32(%rbp)
	jmp	.L204
.L205:
	movq	-56(%rbp), %rdx
	movq	-32(%rbp), %rax
	addq	%rdx, %rax
	leaq	0(,%rax,8), %rdx
	movq	-80(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	%rax, -24(%rbp)
	movq	-72(%rbp), %rax
	subq	-32(%rbp), %rax
	subq	$1, %rax
	leaq	0(,%rax,8), %rdx
	movq	-80(%rbp), %rax
	addq	%rdx, %rax
	movq	-56(%rbp), %rcx
	movq	-32(%rbp), %rdx
	addq	%rcx, %rdx
	leaq	0(,%rdx,8), %rcx
	movq	-80(%rbp), %rdx
	addq	%rcx, %rdx
	movq	(%rax), %rax
	movq	%rax, (%rdx)
	movq	-72(%rbp), %rax
	subq	-32(%rbp), %rax
	subq	$1, %rax
	leaq	0(,%rax,8), %rdx
	movq	-80(%rbp), %rax
	addq	%rax, %rdx
	movq	-24(%rbp), %rax
	movq	%rax, (%rdx)
	addq	$1, -32(%rbp)
.L204:
	movq	-32(%rbp), %rax
	cmpq	-64(%rbp), %rax
	jb	.L205
.L203:
	movsd	-16(%rbp), %xmm0
	movq	%xmm0, %rax
	movq	-8(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L207
	call	__stack_chk_fail@PLT
.L207:
	movq	%rax, %xmm0
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE15:
	.size	remove_chunk, .-remove_chunk
	.globl	test_chunk
	.type	test_chunk, @function
test_chunk:
.LFB16:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	addq	$-128, %rsp
	movq	%rdi, -72(%rbp)
	movq	%rsi, -80(%rbp)
	movq	%rdx, -88(%rbp)
	movq	%rcx, -96(%rbp)
	movq	%r8, -104(%rbp)
	movq	%r9, -112(%rbp)
	movsd	%xmm0, -120(%rbp)
	movl	$0, -56(%rbp)
	cmpq	$20, -80(%rbp)
	ja	.L209
	movq	-80(%rbp), %rax
	cmpq	-88(%rbp), %rax
	jnb	.L209
	movq	-120(%rbp), %rdi
	movq	-112(%rbp), %r9
	movq	-104(%rbp), %r10
	movq	-96(%rbp), %rcx
	movq	-88(%rbp), %rdx
	movq	-80(%rbp), %rsi
	movq	-72(%rbp), %rax
	pushq	24(%rbp)
	movl	16(%rbp), %r8d
	pushq	%r8
	movq	%rdi, %xmm0
	movq	%r10, %r8
	movq	%rax, %rdi
	call	fixup_chunk
	addq	$16, %rsp
	jmp	.L210
.L209:
	movq	-112(%rbp), %rax
	movsd	(%rax), %xmm0
	movsd	%xmm0, -16(%rbp)
	movq	-80(%rbp), %rax
	addq	$19, %rax
	movabsq	$-3689348814741910323, %rdx
	mulq	%rdx
	movq	%rdx, %rax
	shrq	$4, %rax
	movq	%rax, -32(%rbp)
	movq	-72(%rbp), %rax
	movq	%rax, -48(%rbp)
	movq	$0, -40(%rbp)
	jmp	.L211
.L225:
	movq	-48(%rbp), %rdx
	movq	-32(%rbp), %rax
	addq	%rax, %rdx
	movq	-72(%rbp), %rcx
	movq	-80(%rbp), %rax
	addq	%rcx, %rax
	cmpq	%rax, %rdx
	jbe	.L212
	movq	-72(%rbp), %rdx
	movq	-80(%rbp), %rax
	addq	%rdx, %rax
	subq	-48(%rbp), %rax
	movq	%rax, -32(%rbp)
.L212:
	movq	-104(%rbp), %rdi
	movq	-96(%rbp), %rcx
	movq	-88(%rbp), %rdx
	movq	-32(%rbp), %rsi
	movq	-48(%rbp), %rax
	subq	$8, %rsp
	pushq	24(%rbp)
	movl	16(%rbp), %r9d
	movq	%rdi, %r8
	movq	%rax, %rdi
	call	remove_chunk
	addq	$16, %rsp
	movq	%xmm0, %rax
	movq	%rax, -24(%rbp)
	movq	-112(%rbp), %rax
	movsd	(%rax), %xmm1
	movsd	.LC9(%rip), %xmm0
	mulsd	%xmm0, %xmm1
	movsd	-24(%rbp), %xmm0
	comisd	%xmm1, %xmm0
	jnb	.L227
	movsd	-16(%rbp), %xmm1
	movsd	.LC23(%rip), %xmm0
	mulsd	%xmm0, %xmm1
	movsd	-24(%rbp), %xmm0
	comisd	%xmm1, %xmm0
	jnb	.L228
	movq	-104(%rbp), %rdi
	movq	-96(%rbp), %rcx
	movq	-88(%rbp), %rdx
	movq	-32(%rbp), %rsi
	movq	-48(%rbp), %rax
	subq	$8, %rsp
	pushq	24(%rbp)
	movl	16(%rbp), %r9d
	movq	%rdi, %r8
	movq	%rax, %rdi
	call	remove_chunk
	addq	$16, %rsp
	movq	%xmm0, %rax
	movq	%rax, -8(%rbp)
	movsd	-8(%rbp), %xmm0
	comisd	-24(%rbp), %xmm0
	jbe	.L218
	movsd	-8(%rbp), %xmm0
	movsd	%xmm0, -24(%rbp)
.L218:
	movq	-112(%rbp), %rax
	movsd	(%rax), %xmm1
	movsd	.LC9(%rip), %xmm0
	mulsd	%xmm0, %xmm1
	movsd	-24(%rbp), %xmm0
	comisd	%xmm1, %xmm0
	jnb	.L229
	movsd	-16(%rbp), %xmm1
	movsd	.LC23(%rip), %xmm0
	mulsd	%xmm0, %xmm1
	movsd	-24(%rbp), %xmm0
	comisd	%xmm1, %xmm0
	jnb	.L230
	movq	-24(%rbp), %rdi
	movq	-112(%rbp), %r9
	movq	-104(%rbp), %r10
	movq	-96(%rbp), %rcx
	movq	-88(%rbp), %rdx
	movq	-32(%rbp), %rsi
	movq	-48(%rbp), %rax
	pushq	24(%rbp)
	movl	16(%rbp), %r8d
	pushq	%r8
	movq	%rdi, %xmm0
	movq	%r10, %r8
	movq	%rax, %rdi
	call	test_chunk
	addq	$16, %rsp
	movl	%eax, -52(%rbp)
	cmpl	$0, -52(%rbp)
	je	.L224
	movl	$1, -56(%rbp)
	jmp	.L215
.L224:
	movsd	-24(%rbp), %xmm0
	movsd	%xmm0, -16(%rbp)
	jmp	.L215
.L227:
	nop
	jmp	.L215
.L228:
	nop
	jmp	.L215
.L229:
	nop
	jmp	.L215
.L230:
	nop
.L215:
	movq	-32(%rbp), %rax
	addq	%rax, -48(%rbp)
	addq	$1, -40(%rbp)
.L211:
	movq	-72(%rbp), %rdx
	movq	-80(%rbp), %rax
	addq	%rdx, %rax
	cmpq	%rax, -48(%rbp)
	jb	.L225
	movl	-56(%rbp), %eax
.L210:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE16:
	.size	test_chunk, .-test_chunk
	.globl	fixup_chunk
	.type	fixup_chunk, @function
fixup_chunk:
.LFB17:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%rbx
	subq	$392, %rsp
	.cfi_offset 3, -24
	movq	%rdi, -344(%rbp)
	movq	%rsi, -352(%rbp)
	movq	%rdx, -360(%rbp)
	movq	%rcx, -368(%rbp)
	movq	%r8, -376(%rbp)
	movq	%r9, -384(%rbp)
	movsd	%xmm0, -392(%rbp)
	movq	24(%rbp), %rax
	movq	%rax, -400(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -24(%rbp)
	xorl	%eax, %eax
	movl	$0, -332(%rbp)
	movq	-400(%rbp), %rax
	movq	160(%rax), %rbx
	call	getpagesize@PLT
	cltq
	addq	%rbx, %rax
	leaq	-1(%rax), %rbx
	call	getpagesize@PLT
	movslq	%eax, %rsi
	movq	%rbx, %rax
	movl	$0, %edx
	divq	%rsi
	movq	%rax, -296(%rbp)
	movq	-296(%rbp), %rax
	subq	-360(%rbp), %rax
	movq	%rax, -288(%rbp)
	movq	-400(%rbp), %rax
	movq	208(%rax), %rdx
	movq	-360(%rbp), %rax
	salq	$3, %rax
	addq	%rdx, %rax
	movq	%rax, -280(%rbp)
	movq	-384(%rbp), %rax
	movsd	(%rax), %xmm0
	movsd	%xmm0, -272(%rbp)
	movq	-296(%rbp), %rax
	salq	$3, %rax
	movq	%rax, %rdi
	call	malloc@PLT
	movq	%rax, -264(%rbp)
	cmpq	$0, -264(%rbp)
	jne	.L232
	leaq	.LC3(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$4, %edi
	call	exit@PLT
.L232:
	movq	-296(%rbp), %rax
	leaq	0(,%rax,4), %rdx
	movq	-368(%rbp), %rcx
	movq	-264(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	memmove@PLT
	movq	-344(%rbp), %rdx
	movq	-352(%rbp), %rax
	addq	%rdx, %rax
	cmpq	%rax, -360(%rbp)
	jbe	.L233
	movq	$0, -320(%rbp)
	jmp	.L234
.L235:
	movq	-344(%rbp), %rdx
	movq	-320(%rbp), %rax
	addq	%rdx, %rax
	leaq	0(,%rax,8), %rdx
	movq	-368(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	%rax, -256(%rbp)
	movq	-360(%rbp), %rax
	subq	-352(%rbp), %rax
	movq	%rax, %rdx
	movq	-320(%rbp), %rax
	addq	%rdx, %rax
	leaq	0(,%rax,8), %rdx
	movq	-368(%rbp), %rax
	addq	%rdx, %rax
	movq	-344(%rbp), %rcx
	movq	-320(%rbp), %rdx
	addq	%rcx, %rdx
	leaq	0(,%rdx,8), %rcx
	movq	-368(%rbp), %rdx
	addq	%rcx, %rdx
	movq	(%rax), %rax
	movq	%rax, (%rdx)
	movq	-360(%rbp), %rax
	subq	-352(%rbp), %rax
	movq	%rax, %rdx
	movq	-320(%rbp), %rax
	addq	%rdx, %rax
	leaq	0(,%rax,8), %rdx
	movq	-368(%rbp), %rax
	addq	%rax, %rdx
	movq	-256(%rbp), %rax
	movq	%rax, (%rdx)
	addq	$1, -320(%rbp)
.L234:
	movq	-320(%rbp), %rax
	cmpq	-352(%rbp), %rax
	jb	.L235
.L233:
	movq	available_index.0(%rip), %rax
	cmpq	%rax, -288(%rbp)
	ja	.L236
	movq	$0, available_index.0(%rip)
.L236:
	movq	$0, -320(%rbp)
	movq	-352(%rbp), %rax
	movq	%rax, -312(%rbp)
	jmp	.L237
.L240:
	movq	-360(%rbp), %rax
	subq	-352(%rbp), %rax
	movq	%rax, %rdx
	movq	-320(%rbp), %rax
	addq	%rdx, %rax
	leaq	1(%rax), %rbx
	call	getpagesize@PLT
	cltq
	imulq	%rbx, %rax
	movq	-400(%rbp), %rcx
	leaq	-328(%rbp), %rdx
	movl	16(%rbp), %esi
	movq	%rax, %rdi
	call	measure
	movq	%xmm0, %rax
	movq	%rax, -248(%rbp)
	movsd	-248(%rbp), %xmm1
	movsd	.LC24(%rip), %xmm0
	mulsd	%xmm0, %xmm1
	movsd	-392(%rbp), %xmm0
	comisd	%xmm1, %xmm0
	jb	.L261
	movq	-320(%rbp), %rax
	movsd	-248(%rbp), %xmm0
	movsd	%xmm0, -192(%rbp,%rax,8)
	addq	$1, -320(%rbp)
	jmp	.L237
.L261:
	subq	$1, -312(%rbp)
	movq	-312(%rbp), %rax
	movsd	-248(%rbp), %xmm0
	movsd	%xmm0, -192(%rbp,%rax,8)
	movq	-360(%rbp), %rax
	subq	-352(%rbp), %rax
	movq	%rax, %rdx
	movq	-320(%rbp), %rax
	addq	%rdx, %rax
	leaq	0(,%rax,8), %rdx
	movq	-368(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	%rax, -200(%rbp)
	movq	-360(%rbp), %rax
	subq	-352(%rbp), %rax
	movq	%rax, %rdx
	movq	-312(%rbp), %rax
	addq	%rdx, %rax
	leaq	0(,%rax,8), %rdx
	movq	-368(%rbp), %rax
	leaq	(%rdx,%rax), %rcx
	movq	-360(%rbp), %rax
	subq	-352(%rbp), %rax
	movq	%rax, %rdx
	movq	-320(%rbp), %rax
	addq	%rdx, %rax
	leaq	0(,%rax,8), %rdx
	movq	-368(%rbp), %rax
	addq	%rax, %rdx
	movq	(%rcx), %rax
	movq	%rax, (%rdx)
	movq	-360(%rbp), %rax
	subq	-352(%rbp), %rax
	movq	%rax, %rdx
	movq	-312(%rbp), %rax
	addq	%rdx, %rax
	leaq	0(,%rax,8), %rdx
	movq	-368(%rbp), %rax
	addq	%rax, %rdx
	movq	-200(%rbp), %rax
	movq	%rax, (%rdx)
.L237:
	movq	-320(%rbp), %rax
	cmpq	-312(%rbp), %rax
	jb	.L240
	leaq	-192(%rbp), %rdx
	movq	-320(%rbp), %rax
	salq	$3, %rax
	addq	%rax, %rdx
	movq	-360(%rbp), %rax
	subq	-352(%rbp), %rax
	movq	%rax, %rcx
	movq	-320(%rbp), %rax
	addq	%rcx, %rax
	leaq	0(,%rax,8), %rcx
	movq	-368(%rbp), %rax
	addq	%rax, %rcx
	movq	-352(%rbp), %rax
	subq	-320(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	pagesort
	movq	-352(%rbp), %rax
	cmpq	-360(%rbp), %rax
	jb	.L241
	movq	-352(%rbp), %rax
	shrq	%rax
	cmpq	%rax, -320(%rbp)
	jnb	.L241
	movq	-352(%rbp), %rax
	shrq	%rax
	movq	%rax, -320(%rbp)
	movq	-360(%rbp), %rax
	subq	-352(%rbp), %rax
	movq	%rax, %rdx
	movq	-320(%rbp), %rax
	addq	%rdx, %rax
	leaq	1(%rax), %rbx
	call	getpagesize@PLT
	cltq
	imulq	%rbx, %rax
	movq	-400(%rbp), %rcx
	leaq	-328(%rbp), %rdx
	movl	16(%rbp), %esi
	movq	%rax, %rdi
	call	measure
	movq	%xmm0, %rax
	movq	%rax, -248(%rbp)
	movsd	-248(%rbp), %xmm0
	movsd	%xmm0, -392(%rbp)
.L241:
	movq	$0, -312(%rbp)
	jmp	.L242
.L249:
	movq	-360(%rbp), %rax
	subq	-352(%rbp), %rax
	movq	%rax, %rdx
	movq	-320(%rbp), %rax
	addq	%rdx, %rax
	movq	%rax, -240(%rbp)
	movq	-288(%rbp), %rax
	subq	$1, %rax
	movq	%rax, -232(%rbp)
	movq	available_index.0(%rip), %rdx
	movq	-312(%rbp), %rax
	addq	%rdx, %rax
	movq	-288(%rbp), %rdx
	leaq	-1(%rdx), %rcx
	movl	$0, %edx
	divq	%rcx
	movq	%rdx, %rax
	subq	%rax, -232(%rbp)
	movq	-240(%rbp), %rax
	leaq	1(%rax), %rbx
	call	getpagesize@PLT
	cltq
	imulq	%rbx, %rax
	movq	%rax, -304(%rbp)
	movq	-352(%rbp), %rax
	subq	$1, %rax
	cmpq	%rax, -320(%rbp)
	jne	.L243
	call	getpagesize@PLT
	movslq	%eax, %rcx
	movq	-376(%rbp), %rax
	movl	$0, %edx
	divq	%rcx
	movq	%rdx, %rax
	testq	%rax, %rax
	je	.L243
	movq	-376(%rbp), %rax
	movq	%rax, -304(%rbp)
.L243:
	movq	-240(%rbp), %rax
	leaq	0(,%rax,8), %rdx
	movq	-368(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	%rax, -224(%rbp)
	movq	-232(%rbp), %rax
	leaq	0(,%rax,8), %rdx
	movq	-280(%rbp), %rax
	addq	%rdx, %rax
	movq	-240(%rbp), %rdx
	leaq	0(,%rdx,8), %rcx
	movq	-368(%rbp), %rdx
	addq	%rcx, %rdx
	movq	(%rax), %rax
	movq	%rax, (%rdx)
	movq	-232(%rbp), %rax
	leaq	0(,%rax,8), %rdx
	movq	-280(%rbp), %rax
	addq	%rax, %rdx
	movq	-224(%rbp), %rax
	movq	%rax, (%rdx)
	movq	-400(%rbp), %rcx
	leaq	-328(%rbp), %rdx
	movq	-304(%rbp), %rax
	movl	16(%rbp), %esi
	movq	%rax, %rdi
	call	measure
	movq	%xmm0, %rax
	movq	%rax, -248(%rbp)
	movq	-240(%rbp), %rax
	leaq	0(,%rax,8), %rdx
	movq	-368(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	%rax, -216(%rbp)
	movq	-232(%rbp), %rax
	leaq	0(,%rax,8), %rdx
	movq	-280(%rbp), %rax
	addq	%rdx, %rax
	movq	-240(%rbp), %rdx
	leaq	0(,%rdx,8), %rcx
	movq	-368(%rbp), %rdx
	addq	%rcx, %rdx
	movq	(%rax), %rax
	movq	%rax, (%rdx)
	movq	-232(%rbp), %rax
	leaq	0(,%rax,8), %rdx
	movq	-280(%rbp), %rax
	addq	%rax, %rdx
	movq	-216(%rbp), %rax
	movq	%rax, (%rdx)
	movq	-352(%rbp), %rax
	subq	$1, %rax
	movsd	-192(%rbp,%rax,8), %xmm0
	comisd	-248(%rbp), %xmm0
	jbe	.L244
	movq	-352(%rbp), %rax
	subq	$1, %rax
	movsd	-248(%rbp), %xmm0
	movsd	%xmm0, -192(%rbp,%rax,8)
	movq	-360(%rbp), %rax
	salq	$3, %rax
	leaq	-8(%rax), %rdx
	movq	-368(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	%rax, -208(%rbp)
	movq	-232(%rbp), %rax
	leaq	0(,%rax,8), %rdx
	movq	-280(%rbp), %rax
	addq	%rdx, %rax
	movq	-360(%rbp), %rdx
	salq	$3, %rdx
	leaq	-8(%rdx), %rcx
	movq	-368(%rbp), %rdx
	addq	%rcx, %rdx
	movq	(%rax), %rax
	movq	%rax, (%rdx)
	movq	-232(%rbp), %rax
	leaq	0(,%rax,8), %rdx
	movq	-280(%rbp), %rax
	addq	%rax, %rdx
	movq	-208(%rbp), %rax
	movq	%rax, (%rdx)
	leaq	-192(%rbp), %rdx
	movq	-320(%rbp), %rax
	salq	$3, %rax
	addq	%rax, %rdx
	movq	-360(%rbp), %rax
	subq	-352(%rbp), %rax
	movq	%rax, %rcx
	movq	-320(%rbp), %rax
	addq	%rcx, %rax
	leaq	0(,%rax,8), %rcx
	movq	-368(%rbp), %rax
	addq	%rax, %rcx
	movq	-352(%rbp), %rax
	subq	-320(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	pagesort
.L244:
	movq	-320(%rbp), %rax
	movsd	-192(%rbp,%rax,8), %xmm1
	movsd	.LC24(%rip), %xmm0
	mulsd	%xmm0, %xmm1
	movsd	-392(%rbp), %xmm0
	comisd	%xmm1, %xmm0
	jb	.L246
	addq	$1, -320(%rbp)
	addl	$1, -332(%rbp)
.L246:
	addq	$1, -312(%rbp)
.L242:
	movq	-320(%rbp), %rax
	cmpq	-352(%rbp), %rax
	jnb	.L248
	movq	-360(%rbp), %rax
	addq	%rax, %rax
	cmpq	%rax, -312(%rbp)
	jb	.L249
.L248:
	movq	available_index.0(%rip), %rdx
	movq	-312(%rbp), %rax
	addq	%rdx, %rax
	movq	-288(%rbp), %rdx
	leaq	-1(%rdx), %rcx
	movl	$0, %edx
	divq	%rcx
	movq	%rdx, %rax
	movq	%rax, available_index.0(%rip)
	cmpl	$0, -332(%rbp)
	je	.L250
	movq	-400(%rbp), %rcx
	leaq	-328(%rbp), %rdx
	movq	-376(%rbp), %rax
	movl	16(%rbp), %esi
	movq	%rax, %rdi
	call	measure
	movq	%xmm0, %rax
	movq	%rax, -272(%rbp)
	movq	-384(%rbp), %rax
	movsd	(%rax), %xmm1
	movsd	.LC23(%rip), %xmm0
	mulsd	%xmm0, %xmm1
	movsd	-272(%rbp), %xmm0
	comisd	%xmm1, %xmm0
	jb	.L262
	movl	$0, -332(%rbp)
	movq	-296(%rbp), %rax
	leaq	0(,%rax,4), %rdx
	movq	-264(%rbp), %rcx
	movq	-368(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	memmove@PLT
	jmp	.L250
.L262:
	movq	-384(%rbp), %rax
	movsd	-272(%rbp), %xmm0
	movsd	%xmm0, (%rax)
	movq	-344(%rbp), %rdx
	movq	-352(%rbp), %rax
	addq	%rdx, %rax
	cmpq	%rax, -360(%rbp)
	jbe	.L250
	movq	$0, -320(%rbp)
	jmp	.L253
.L254:
	movq	-344(%rbp), %rdx
	movq	-320(%rbp), %rax
	addq	%rdx, %rax
	leaq	0(,%rax,8), %rdx
	movq	-368(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	%rax, -256(%rbp)
	movq	-360(%rbp), %rax
	subq	-352(%rbp), %rax
	movq	%rax, %rdx
	movq	-320(%rbp), %rax
	addq	%rdx, %rax
	leaq	0(,%rax,8), %rdx
	movq	-368(%rbp), %rax
	addq	%rdx, %rax
	movq	-344(%rbp), %rcx
	movq	-320(%rbp), %rdx
	addq	%rcx, %rdx
	leaq	0(,%rdx,8), %rcx
	movq	-368(%rbp), %rdx
	addq	%rcx, %rdx
	movq	(%rax), %rax
	movq	%rax, (%rdx)
	movq	-360(%rbp), %rax
	subq	-352(%rbp), %rax
	movq	%rax, %rdx
	movq	-320(%rbp), %rax
	addq	%rdx, %rax
	leaq	0(,%rax,8), %rdx
	movq	-368(%rbp), %rax
	addq	%rax, %rdx
	movq	-256(%rbp), %rax
	movq	%rax, (%rdx)
	addq	$1, -320(%rbp)
.L253:
	movq	-320(%rbp), %rax
	cmpq	-352(%rbp), %rax
	jb	.L254
.L250:
	movq	-264(%rbp), %rax
	movq	%rax, %rdi
	call	free@PLT
	movl	-332(%rbp), %eax
	movq	-24(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L256
	call	__stack_chk_fail@PLT
.L256:
	movq	-8(%rbp), %rbx
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE17:
	.size	fixup_chunk, .-fixup_chunk
	.section	.rodata
	.align 8
.LC25:
	.string	"check_memory: bad memory reference for size %lu\n"
	.align 8
.LC26:
	.string	"check_memory: unwanted memory cycle! page=%lu\n"
	.align 8
.LC27:
	.string	"check_memory: wrong word count, expected %lu, got %lu\n"
	.text
	.globl	check_memory
	.type	check_memory, @function
check_memory:
.LFB18:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$112, %rsp
	movq	%rdi, -104(%rbp)
	movq	%rsi, -112(%rbp)
	call	getpagesize@PLT
	cltq
	movq	%rax, -48(%rbp)
	movq	-104(%rbp), %rdx
	movq	-48(%rbp), %rax
	addq	%rdx, %rax
	subq	$1, %rax
	movl	$0, %edx
	divq	-48(%rbp)
	movq	%rax, -40(%rbp)
	movq	-104(%rbp), %rax
	shrq	$3, %rax
	movq	%rax, -32(%rbp)
	movq	$1, -72(%rbp)
	movq	$0, -80(%rbp)
	movq	-112(%rbp), %rax
	movq	8(%rax), %rdx
	movq	-112(%rbp), %rax
	movq	208(%rax), %rax
	movq	(%rax), %rcx
	movq	-112(%rbp), %rax
	movq	216(%rax), %rax
	movq	(%rax), %rax
	addq	%rax, %rcx
	movq	-112(%rbp), %rax
	movq	224(%rax), %rax
	movq	(%rax), %rax
	addq	%rcx, %rax
	addq	%rdx, %rax
	movq	%rax, -24(%rbp)
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -64(%rbp)
	movq	-64(%rbp), %rax
	movq	%rax, -56(%rbp)
	jmp	.L264
.L276:
	addq	$1, -72(%rbp)
	movq	-64(%rbp), %rdx
	movq	-112(%rbp), %rax
	movq	8(%rax), %rax
	movq	%rax, %rcx
	movq	%rdx, %rax
	subq	%rcx, %rax
	movq	%rax, -16(%rbp)
	movq	-16(%rbp), %rcx
	movq	-16(%rbp), %rax
	movl	$0, %edx
	divq	-48(%rbp)
	movq	%rcx, %rax
	subq	%rdx, %rax
	movq	%rax, -8(%rbp)
	movq	-80(%rbp), %rax
	movq	%rax, -88(%rbp)
	jmp	.L265
.L268:
	movq	-112(%rbp), %rax
	movq	208(%rax), %rdx
	movq	-88(%rbp), %rax
	salq	$3, %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	cmpq	%rax, -8(%rbp)
	je	.L277
	addq	$1, -88(%rbp)
.L265:
	movq	-88(%rbp), %rax
	cmpq	-40(%rbp), %rax
	jb	.L268
	jmp	.L267
.L277:
	nop
.L267:
	movq	-88(%rbp), %rax
	cmpq	-40(%rbp), %rax
	jne	.L269
	movq	$0, -88(%rbp)
	jmp	.L270
.L273:
	movq	-112(%rbp), %rax
	movq	208(%rax), %rdx
	movq	-88(%rbp), %rax
	salq	$3, %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	cmpq	%rax, -8(%rbp)
	je	.L278
	addq	$1, -88(%rbp)
.L270:
	movq	-88(%rbp), %rax
	cmpq	-80(%rbp), %rax
	jb	.L273
	jmp	.L272
.L278:
	nop
.L272:
	movq	-88(%rbp), %rax
	cmpq	-80(%rbp), %rax
	jne	.L269
	movq	stderr(%rip), %rax
	movq	-104(%rbp), %rdx
	leaq	.LC25(%rip), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf@PLT
.L269:
	movq	-88(%rbp), %rax
	movl	$0, %edx
	divq	-40(%rbp)
	movq	%rdx, -80(%rbp)
	movq	-64(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -64(%rbp)
	movq	-72(%rbp), %rax
	andl	$1, %eax
	testq	%rax, %rax
	je	.L274
	movq	-56(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -56(%rbp)
.L274:
	movq	-64(%rbp), %rax
	movq	(%rax), %rdx
	movq	-56(%rbp), %rax
	movq	(%rax), %rax
	cmpq	%rax, %rdx
	jne	.L264
	movq	stderr(%rip), %rax
	movq	-88(%rbp), %rdx
	leaq	.LC26(%rip), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf@PLT
	jmp	.L263
.L264:
	movq	-64(%rbp), %rax
	cmpq	-24(%rbp), %rax
	jne	.L276
	movq	-72(%rbp), %rax
	cmpq	-32(%rbp), %rax
	je	.L263
	movq	stderr(%rip), %rax
	movq	-72(%rbp), %rcx
	movq	-32(%rbp), %rdx
	leaq	.LC27(%rip), %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf@PLT
.L263:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE18:
	.size	check_memory, .-check_memory
	.globl	pagesort
	.type	pagesort, @function
pagesort:
.LFB19:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -40(%rbp)
	movq	%rsi, -48(%rbp)
	movq	%rdx, -56(%rbp)
	movl	$0, -24(%rbp)
	jmp	.L280
.L285:
	movl	-24(%rbp), %eax
	addl	$1, %eax
	movl	%eax, -20(%rbp)
	jmp	.L281
.L284:
	movl	-24(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-56(%rbp), %rax
	addq	%rdx, %rax
	movsd	(%rax), %xmm0
	movl	-20(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-56(%rbp), %rax
	addq	%rdx, %rax
	movsd	(%rax), %xmm1
	comisd	%xmm1, %xmm0
	jbe	.L282
	movl	-24(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-56(%rbp), %rax
	addq	%rdx, %rax
	movsd	(%rax), %xmm0
	movsd	%xmm0, -16(%rbp)
	movl	-20(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-56(%rbp), %rax
	addq	%rax, %rdx
	movl	-24(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rcx
	movq	-56(%rbp), %rax
	addq	%rcx, %rax
	movsd	(%rdx), %xmm0
	movsd	%xmm0, (%rax)
	movl	-20(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-56(%rbp), %rax
	addq	%rdx, %rax
	movsd	-16(%rbp), %xmm0
	movsd	%xmm0, (%rax)
	movl	-24(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-48(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	%rax, -8(%rbp)
	movl	-20(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-48(%rbp), %rax
	addq	%rdx, %rax
	movl	-24(%rbp), %edx
	movslq	%edx, %rdx
	leaq	0(,%rdx,8), %rcx
	movq	-48(%rbp), %rdx
	addq	%rcx, %rdx
	movq	(%rax), %rax
	movq	%rax, (%rdx)
	movl	-20(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-48(%rbp), %rax
	addq	%rax, %rdx
	movq	-8(%rbp), %rax
	movq	%rax, (%rdx)
.L282:
	addl	$1, -20(%rbp)
.L281:
	movl	-20(%rbp), %eax
	cltq
	cmpq	%rax, -40(%rbp)
	ja	.L284
	addl	$1, -24(%rbp)
.L280:
	movl	-24(%rbp), %eax
	cltq
	movq	-40(%rbp), %rdx
	subq	$1, %rdx
	cmpq	%rdx, %rax
	jb	.L285
	nop
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE19:
	.size	pagesort, .-pagesort
	.data
	.align 8
	.type	__iterations.1, @object
	.size	__iterations.1, 8
__iterations.1:
	.quad	1
	.local	available_index.0
	.comm	available_index.0,8,8
	.section	.rodata
	.align 8
.LC4:
	.long	0
	.long	-1074790400
	.align 8
.LC5:
	.long	0
	.long	1071644672
	.align 8
.LC6:
	.long	0
	.long	0
	.align 16
.LC7:
	.long	0
	.long	-2147483648
	.long	0
	.long	0
	.align 8
.LC9:
	.long	2061584302
	.long	1072672276
	.align 8
.LC11:
	.long	0
	.long	1073217536
	.align 8
.LC12:
	.long	0
	.long	1072693248
	.align 8
.LC13:
	.long	-171798692
	.long	1072651304
	.align 8
.LC14:
	.long	-1717986918
	.long	1073060249
	.align 8
.LC15:
	.long	1889785610
	.long	1072630333
	.align 8
.LC16:
	.long	858993459
	.long	1072902963
	.align 8
.LC17:
	.long	0
	.long	1080213504
	.align 8
.LC18:
	.long	-1717986918
	.long	1072798105
	.align 8
.LC19:
	.long	0
	.long	1138753536
	.align 8
.LC20:
	.long	1717986918
	.long	1072588390
	.align 8
.LC21:
	.long	0
	.long	1083129856
	.align 8
.LC22:
	.long	0
	.long	1079574528
	.align 8
.LC23:
	.long	-652835029
	.long	1072691150
	.align 8
.LC24:
	.long	1030792151
	.long	1072682762
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
