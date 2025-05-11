	.file	"lat_dram_page.c"
	.text
	.globl	benchmark_loads
	.type	benchmark_loads, @function
benchmark_loads:
.LFB73:
	.cfi_startproc
	endbr64
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	movq	%rdi, %r8
	movq	8(%rsi), %rdi
	movq	168(%rsi), %rax
	leaq	(%rax,%rax,4), %rax
	leaq	(%rax,%rax,4), %rcx
	salq	$2, %rcx
	movq	152(%rsi), %rax
	movl	$0, %edx
	divq	%rcx
	leal	1(%rax), %ecx
	leaq	-1(%r8), %rsi
	testq	%r8, %r8
	jne	.L2
.L3:
	call	use_pointer@PLT
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	ret
.L4:
	.cfi_restore_state
	movq	(%rdi), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdi
	addl	$1, %eax
	cmpl	%eax, %ecx
	jne	.L4
.L5:
	subq	$1, %rsi
	cmpq	$-1, %rsi
	je	.L3
.L2:
	movl	$0, %eax
	testl	%ecx, %ecx
	jg	.L4
	jmp	.L5
	.cfi_endproc
.LFE73:
	.size	benchmark_loads, .-benchmark_loads
	.globl	regroup
	.type	regroup, @function
regroup:
.LFB74:
	.cfi_startproc
	endbr64
	cmpl	$1, %esi
	jle	.L24
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movq	%rdi, %r9
	movl	%esi, %r10d
	movq	%rdx, %r8
	movq	8(%rdx), %rdi
	movq	%r9, %rsi
	leal	-2(%r10), %eax
	leaq	8(%r9,%rax,8), %rbx
	movl	$0, %r11d
	jmp	.L13
.L14:
	leaq	(%rdi,%rax), %rdx
	addq	(%rsi), %rdx
	addq	8(%rsi), %rax
	addq	%rdi, %rax
	movq	%rax, (%rdx)
	addl	$8, %ecx
	movslq	%ecx, %rax
	cmpq	176(%r8), %rax
	jb	.L14
.L16:
	addq	$8, %rsi
	cmpq	%rbx, %rsi
	je	.L15
.L13:
	movl	$0, %ecx
	movq	%r11, %rax
	cmpq	$0, 176(%r8)
	jne	.L14
	jmp	.L16
.L15:
	movslq	%r10d, %r10
	movq	%rdi, %rsi
	addq	-8(%r9,%r10,8), %rsi
	movq	176(%r8), %rax
	leaq	(%rsi,%rax), %r10
	testq	%rax, %rax
	je	.L11
	movl	$0, %ecx
	movl	$0, %eax
	jmp	.L18
.L17:
	addl	$8, %ecx
	movslq	%ecx, %rax
	cmpq	176(%r8), %rax
	jnb	.L11
.L18:
	leaq	(%rsi,%rax), %rdx
	movq	(%rdx), %rax
	cmpq	%rax, %rsi
	ja	.L17
	cmpq	%rax, %r10
	jbe	.L17
	subq	%rsi, %rax
	cltq
	addq	(%r9), %rax
	addq	%rdi, %rax
	movq	%rax, (%rdx)
	jmp	.L17
.L11:
	popq	%rbx
	.cfi_def_cfa_offset 8
	ret
.L24:
	.cfi_restore 3
	ret
	.cfi_endproc
.LFE74:
	.size	regroup, .-regroup
	.globl	dram_page_initialize
	.type	dram_page_initialize, @function
dram_page_initialize:
.LFB75:
	.cfi_startproc
	endbr64
	testq	%rdi, %rdi
	je	.L37
	ret
.L37:
	pushq	%r12
	.cfi_def_cfa_offset 16
	.cfi_offset 12, -16
	pushq	%rbp
	.cfi_def_cfa_offset 24
	.cfi_offset 6, -24
	pushq	%rbx
	.cfi_def_cfa_offset 32
	.cfi_offset 3, -32
	movq	%rdi, %rbx
	movq	%rsi, %rbp
	movl	$0, %edi
	call	mem_initialize@PLT
	movq	192(%rbp), %rax
	testq	%rax, %rax
	je	.L29
	movl	$0, %r12d
.L31:
	movl	232(%rbp), %esi
	movslq	%esi, %rcx
	movq	%rax, %rdx
	subq	%rbx, %rdx
	subl	%r12d, %eax
	cmpq	%rdx, %rcx
	cmova	%eax, %esi
	movq	208(%rbp), %rax
	leaq	(%rax,%rbx,8), %rdi
	movq	%rbp, %rdx
	call	regroup
	movl	%r12d, %ebx
	addl	232(%rbp), %ebx
	movl	%ebx, %r12d
	movslq	%ebx, %rbx
	movq	192(%rbp), %rax
	cmpq	%rax, %rbx
	jb	.L31
.L29:
	movq	%rbp, %rsi
	movl	$1, %edi
	call	benchmark_loads
	popq	%rbx
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE75:
	.size	dram_page_initialize, .-dram_page_initialize
	.globl	loads
	.type	loads, @function
loads:
.LFB76:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r14
	pushq	%rbx
	.cfi_offset 14, -24
	.cfi_offset 3, -32
	movl	%edx, %r9d
	movl	%ecx, %r10d
	movslq	%esi, %rax
	movq	%rax, 152(%r8)
	movq	%rax, 160(%r8)
	movq	168(%r8), %rdx
	leaq	(%rdx,%rdx,4), %rdx
	leaq	(%rdx,%rdx,4), %rcx
	salq	$2, %rcx
	movl	$0, %edx
	divq	%rcx
	addq	$1, %rax
	imull	$100, %eax, %ebx
	pushq	%r8
	pushq	%r10
	movl	$1, %r8d
	movl	$0, %ecx
	movq	mem_cleanup@GOTPCREL(%rip), %rdx
	leaq	benchmark_loads(%rip), %rsi
	call	benchmp@PLT
	call	usecs_spent@PLT
	movq	%rax, %r14
	call	get_n@PLT
	movq	%rax, %rdx
	testq	%r14, %r14
	js	.L39
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%r14, %xmm0
.L40:
	mulsd	.LC0(%rip), %xmm0
	movslq	%ebx, %rax
	imulq	%rdx, %rax
	testq	%rax, %rax
	js	.L41
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rax, %xmm1
.L42:
	divsd	%xmm1, %xmm0
	addq	$16, %rsp
	leaq	-16(%rbp), %rsp
	popq	%rbx
	popq	%r14
	popq	%rbp
	.cfi_remember_state
	.cfi_def_cfa 7, 8
	ret
.L39:
	.cfi_restore_state
	movq	%r14, %rcx
	movq	%r14, %rax
	shrq	%rax
	andl	$1, %ecx
	orq	%rcx, %rax
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	addsd	%xmm0, %xmm0
	jmp	.L40
.L41:
	shrq	%rax
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rax, %xmm1
	addsd	%xmm1, %xmm1
	jmp	.L42
	.cfi_endproc
.LFE76:
	.size	loads, .-loads
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC1:
	.string	"[-v] [-W <warmup>] [-N <repetitions>][-M len[K|M]]\n"
	.section	.rodata.str1.1,"aMS",@progbits,1
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
	subq	$280, %rsp
	.cfi_def_cfa_offset 336
	movl	%edi, %ebp
	movq	%rsi, %rbx
	movq	%fs:40, %rax
	movq	%rax, 264(%rsp)
	xorl	%eax, %eax
	movl	$1, 164(%rsp)
	movq	$8, 184(%rsp)
	call	getpagesize@PLT
	cltq
	movq	%rax, 192(%rsp)
	movl	$16, 248(%rsp)
	movl	$-1, %r14d
	movl	$0, 12(%rsp)
	movl	$67108864, (%rsp)
	leaq	.LC2(%rip), %r13
	leaq	.LC1(%rip), %r15
	leaq	.L48(%rip), %r12
	jmp	.L45
.L52:
	movq	myoptarg(%rip), %rdi
	call	bytes@PLT
	movq	%rax, 184(%rsp)
.L45:
	movq	%r13, %rdx
	movq	%rbx, %rsi
	movl	%ebp, %edi
	call	mygetopt@PLT
	cmpl	$-1, %eax
	je	.L62
	subl	$76, %eax
	cmpl	$11, %eax
	ja	.L46
	movl	%eax, %eax
	movslq	(%r12,%rax,4), %rax
	addq	%r12, %rax
	notrack jmp	*%rax
	.section	.rodata
	.align 4
	.align 4
.L48:
	.long	.L52-.L48
	.long	.L51-.L48
	.long	.L50-.L48
	.long	.L46-.L48
	.long	.L46-.L48
	.long	.L46-.L48
	.long	.L46-.L48
	.long	.L46-.L48
	.long	.L49-.L48
	.long	.L46-.L48
	.long	.L46-.L48
	.long	.L47-.L48
	.text
.L49:
	movq	myoptarg(%rip), %rdi
	call	bytes@PLT
	movl	%eax, 248(%rsp)
	jmp	.L45
.L51:
	movq	myoptarg(%rip), %rdi
	call	bytes@PLT
	movl	%eax, (%rsp)
	jmp	.L45
.L47:
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	movl	%eax, 12(%rsp)
	jmp	.L45
.L50:
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	movl	%eax, %r14d
	jmp	.L45
.L46:
	movq	%r15, %rdx
	movq	%rbx, %rsi
	movl	%ebp, %edi
	call	lmbench_usage@PLT
	jmp	.L45
.L62:
	leaq	16(%rsp), %rbx
	movq	%rbx, %r8
	movl	%r14d, %ecx
	movl	12(%rsp), %ebp
	movl	%ebp, %edx
	movl	(%rsp), %r15d
	movl	%r15d, %esi
	movq	mem_initialize@GOTPCREL(%rip), %rdi
	call	loads
	movsd	%xmm0, (%rsp)
	movq	%rbx, %r8
	movl	%r14d, %ecx
	movl	%ebp, %edx
	movl	%r15d, %esi
	leaq	dram_page_initialize(%rip), %rdi
	call	loads
	movapd	%xmm0, %xmm1
	mulsd	.LC3(%rip), %xmm1
	movsd	(%rsp), %xmm2
	comisd	%xmm2, %xmm1
	jbe	.L60
	subsd	%xmm2, %xmm0
	leaq	.LC4(%rip), %rdx
	movl	$1, %esi
	movq	stderr(%rip), %rdi
	movl	$1, %eax
	call	__fprintf_chk@PLT
.L57:
	movq	264(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L63
	movl	$0, %eax
	addq	$280, %rsp
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
.L60:
	.cfi_restore_state
	movq	stderr(%rip), %rcx
	movl	$4, %edx
	movl	$1, %esi
	leaq	.LC5(%rip), %rdi
	call	fwrite@PLT
	jmp	.L57
.L63:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE72:
	.size	main, .-main
	.globl	id
	.section	.rodata.str1.1
.LC6:
	.string	"$Id$\n"
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
.LC3:
	.long	1717986918
	.long	1072588390
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
