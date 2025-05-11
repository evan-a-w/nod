	.file	"lib_mem.c"
	.text
	.globl	mem_benchmarks
	.section	.data.rel.local,"aw"
	.align 32
	.type	mem_benchmarks, @object
	.size	mem_benchmarks, 128
mem_benchmarks:
	.quad	mem_benchmark_0
	.quad	mem_benchmark_1
	.quad	mem_benchmark_2
	.quad	mem_benchmark_3
	.quad	mem_benchmark_4
	.quad	mem_benchmark_5
	.quad	mem_benchmark_6
	.quad	mem_benchmark_7
	.quad	mem_benchmark_8
	.quad	mem_benchmark_9
	.quad	mem_benchmark_10
	.quad	mem_benchmark_11
	.quad	mem_benchmark_12
	.quad	mem_benchmark_13
	.quad	mem_benchmark_14
	.quad	mem_benchmark_15
	.local	mem_benchmark_rerun
	.comm	mem_benchmark_rerun,4,4
	.text
	.globl	mem_benchmark_0
	.type	mem_benchmark_0, @function
mem_benchmark_0:
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
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L2
	movq	-16(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.153(%rip), %rax
	cmpq	%rax, %rdx
	je	.L3
.L2:
	movq	-16(%rbp), %rax
	movq	16(%rax), %rax
	jmp	.L4
.L3:
	movq	sp0.152(%rip), %rax
.L4:
	movq	%rax, %rbx
	jmp	.L5
.L6:
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
	movq	(%rbx), %rbx
.L5:
	movq	-32(%rbp), %rax
	leaq	-1(%rax), %rdx
	movq	%rdx, -32(%rbp)
	testq	%rax, %rax
	jne	.L6
	movq	%rbx, sp0.152(%rip)
	movq	-16(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, addr_save.153(%rip)
	movl	$1, mem_benchmark_rerun(%rip)
	movq	-8(%rbp), %rbx
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE8:
	.size	mem_benchmark_0, .-mem_benchmark_0
	.globl	mem_benchmark_1
	.type	mem_benchmark_1, @function
mem_benchmark_1:
.LFB9:
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
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L8
	movq	-24(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.151(%rip), %rax
	cmpq	%rax, %rdx
	je	.L9
.L8:
	movq	-24(%rbp), %rax
	movq	16(%rax), %rax
	jmp	.L10
.L9:
	movq	sp0.150(%rip), %rax
.L10:
	movq	%rax, %r12
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L11
	movq	-24(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.151(%rip), %rax
	cmpq	%rax, %rdx
	je	.L12
.L11:
	movq	-24(%rbp), %rax
	movq	24(%rax), %rax
	jmp	.L13
.L12:
	movq	sp1.149(%rip), %rax
.L13:
	movq	%rax, %rbx
	jmp	.L14
.L15:
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r12), %r12
	movq	(%rbx), %rbx
.L14:
	movq	-40(%rbp), %rax
	leaq	-1(%rax), %rdx
	movq	%rdx, -40(%rbp)
	testq	%rax, %rax
	jne	.L15
	movq	%r12, sp0.150(%rip)
	movq	%rbx, sp1.149(%rip)
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, addr_save.151(%rip)
	movl	$1, mem_benchmark_rerun(%rip)
	popq	%rbx
	popq	%r12
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE9:
	.size	mem_benchmark_1, .-mem_benchmark_1
	.globl	mem_benchmark_2
	.type	mem_benchmark_2, @function
mem_benchmark_2:
.LFB10:
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
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L17
	movq	-32(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.148(%rip), %rax
	cmpq	%rax, %rdx
	je	.L18
.L17:
	movq	-32(%rbp), %rax
	movq	16(%rax), %rax
	jmp	.L19
.L18:
	movq	sp0.147(%rip), %rax
.L19:
	movq	%rax, %r13
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L20
	movq	-32(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.148(%rip), %rax
	cmpq	%rax, %rdx
	je	.L21
.L20:
	movq	-32(%rbp), %rax
	movq	24(%rax), %rax
	jmp	.L22
.L21:
	movq	sp1.146(%rip), %rax
.L22:
	movq	%rax, %r12
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L23
	movq	-32(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.148(%rip), %rax
	cmpq	%rax, %rdx
	je	.L24
.L23:
	movq	-32(%rbp), %rax
	movq	32(%rax), %rax
	jmp	.L25
.L24:
	movq	sp2.145(%rip), %rax
.L25:
	movq	%rax, %rbx
	jmp	.L26
.L27:
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
.L26:
	movq	-48(%rbp), %rax
	leaq	-1(%rax), %rdx
	movq	%rdx, -48(%rbp)
	testq	%rax, %rax
	jne	.L27
	movq	%r13, sp0.147(%rip)
	movq	%r12, sp1.146(%rip)
	movq	%rbx, sp2.145(%rip)
	movq	-32(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, addr_save.148(%rip)
	movl	$1, mem_benchmark_rerun(%rip)
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE10:
	.size	mem_benchmark_2, .-mem_benchmark_2
	.globl	mem_benchmark_3
	.type	mem_benchmark_3, @function
mem_benchmark_3:
.LFB11:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	.cfi_offset 14, -24
	.cfi_offset 13, -32
	.cfi_offset 12, -40
	.cfi_offset 3, -48
	movq	%rdi, -56(%rbp)
	movq	%rsi, -64(%rbp)
	movq	-64(%rbp), %rax
	movq	%rax, -40(%rbp)
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L29
	movq	-40(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.144(%rip), %rax
	cmpq	%rax, %rdx
	je	.L30
.L29:
	movq	-40(%rbp), %rax
	movq	16(%rax), %rax
	jmp	.L31
.L30:
	movq	sp0.143(%rip), %rax
.L31:
	movq	%rax, %r14
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L32
	movq	-40(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.144(%rip), %rax
	cmpq	%rax, %rdx
	je	.L33
.L32:
	movq	-40(%rbp), %rax
	movq	24(%rax), %rax
	jmp	.L34
.L33:
	movq	sp1.142(%rip), %rax
.L34:
	movq	%rax, %r13
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L35
	movq	-40(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.144(%rip), %rax
	cmpq	%rax, %rdx
	je	.L36
.L35:
	movq	-40(%rbp), %rax
	movq	32(%rax), %rax
	jmp	.L37
.L36:
	movq	sp2.141(%rip), %rax
.L37:
	movq	%rax, %r12
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L38
	movq	-40(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.144(%rip), %rax
	cmpq	%rax, %rdx
	je	.L39
.L38:
	movq	-40(%rbp), %rax
	movq	40(%rax), %rax
	jmp	.L40
.L39:
	movq	sp3.140(%rip), %rax
.L40:
	movq	%rax, %rbx
	jmp	.L41
.L42:
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
.L41:
	movq	-56(%rbp), %rax
	leaq	-1(%rax), %rdx
	movq	%rdx, -56(%rbp)
	testq	%rax, %rax
	jne	.L42
	movq	%r14, sp0.143(%rip)
	movq	%r13, sp1.142(%rip)
	movq	%r12, sp2.141(%rip)
	movq	%rbx, sp3.140(%rip)
	movq	-40(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, addr_save.144(%rip)
	movl	$1, mem_benchmark_rerun(%rip)
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE11:
	.size	mem_benchmark_3, .-mem_benchmark_3
	.globl	mem_benchmark_4
	.type	mem_benchmark_4, @function
mem_benchmark_4:
.LFB12:
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
	movq	%rsi, -72(%rbp)
	movq	-72(%rbp), %rax
	movq	%rax, -48(%rbp)
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L44
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.139(%rip), %rax
	cmpq	%rax, %rdx
	je	.L45
.L44:
	movq	-48(%rbp), %rax
	movq	16(%rax), %rax
	jmp	.L46
.L45:
	movq	sp0.138(%rip), %rax
.L46:
	movq	%rax, %r15
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L47
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.139(%rip), %rax
	cmpq	%rax, %rdx
	je	.L48
.L47:
	movq	-48(%rbp), %rax
	movq	24(%rax), %rax
	jmp	.L49
.L48:
	movq	sp1.137(%rip), %rax
.L49:
	movq	%rax, %r14
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L50
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.139(%rip), %rax
	cmpq	%rax, %rdx
	je	.L51
.L50:
	movq	-48(%rbp), %rax
	movq	32(%rax), %rax
	jmp	.L52
.L51:
	movq	sp2.136(%rip), %rax
.L52:
	movq	%rax, %r13
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L53
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.139(%rip), %rax
	cmpq	%rax, %rdx
	je	.L54
.L53:
	movq	-48(%rbp), %rax
	movq	40(%rax), %rax
	jmp	.L55
.L54:
	movq	sp3.135(%rip), %rax
.L55:
	movq	%rax, %r12
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L56
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.139(%rip), %rax
	cmpq	%rax, %rdx
	je	.L57
.L56:
	movq	-48(%rbp), %rax
	movq	48(%rax), %rax
	jmp	.L58
.L57:
	movq	sp4.134(%rip), %rax
.L58:
	movq	%rax, %rbx
	jmp	.L59
.L60:
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
.L59:
	movq	-64(%rbp), %rax
	leaq	-1(%rax), %rdx
	movq	%rdx, -64(%rbp)
	testq	%rax, %rax
	jne	.L60
	movq	%r15, sp0.138(%rip)
	movq	%r14, sp1.137(%rip)
	movq	%r13, sp2.136(%rip)
	movq	%r12, sp3.135(%rip)
	movq	%rbx, sp4.134(%rip)
	movq	-48(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, addr_save.139(%rip)
	movl	$1, mem_benchmark_rerun(%rip)
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE12:
	.size	mem_benchmark_4, .-mem_benchmark_4
	.globl	mem_benchmark_5
	.type	mem_benchmark_5, @function
mem_benchmark_5:
.LFB13:
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
	movq	%rsi, -72(%rbp)
	movq	-72(%rbp), %rax
	movq	%rax, -48(%rbp)
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L62
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.133(%rip), %rax
	cmpq	%rax, %rdx
	je	.L63
.L62:
	movq	-48(%rbp), %rax
	movq	16(%rax), %rax
	jmp	.L64
.L63:
	movq	sp0.132(%rip), %rax
.L64:
	movq	%rax, %rcx
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L65
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.133(%rip), %rax
	cmpq	%rax, %rdx
	je	.L66
.L65:
	movq	-48(%rbp), %rax
	movq	24(%rax), %rax
	jmp	.L67
.L66:
	movq	sp1.131(%rip), %rax
.L67:
	movq	%rax, %r15
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L68
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.133(%rip), %rax
	cmpq	%rax, %rdx
	je	.L69
.L68:
	movq	-48(%rbp), %rax
	movq	32(%rax), %rax
	jmp	.L70
.L69:
	movq	sp2.130(%rip), %rax
.L70:
	movq	%rax, %r14
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L71
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.133(%rip), %rax
	cmpq	%rax, %rdx
	je	.L72
.L71:
	movq	-48(%rbp), %rax
	movq	40(%rax), %rax
	jmp	.L73
.L72:
	movq	sp3.129(%rip), %rax
.L73:
	movq	%rax, %r13
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L74
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.133(%rip), %rax
	cmpq	%rax, %rdx
	je	.L75
.L74:
	movq	-48(%rbp), %rax
	movq	48(%rax), %rax
	jmp	.L76
.L75:
	movq	sp4.128(%rip), %rax
.L76:
	movq	%rax, %r12
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L77
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.133(%rip), %rax
	cmpq	%rax, %rdx
	je	.L78
.L77:
	movq	-48(%rbp), %rax
	movq	56(%rax), %rax
	jmp	.L79
.L78:
	movq	sp5.127(%rip), %rax
.L79:
	movq	%rax, %rbx
	jmp	.L80
.L81:
	movq	%rcx, %rax
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	%rax, %rcx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
.L80:
	movq	-64(%rbp), %rax
	leaq	-1(%rax), %rdx
	movq	%rdx, -64(%rbp)
	testq	%rax, %rax
	jne	.L81
	movq	%rcx, %rax
	movq	%rax, sp0.132(%rip)
	movq	%r15, sp1.131(%rip)
	movq	%r14, sp2.130(%rip)
	movq	%r13, sp3.129(%rip)
	movq	%r12, sp4.128(%rip)
	movq	%rbx, sp5.127(%rip)
	movq	-48(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, addr_save.133(%rip)
	movl	$1, mem_benchmark_rerun(%rip)
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE13:
	.size	mem_benchmark_5, .-mem_benchmark_5
	.globl	mem_benchmark_6
	.type	mem_benchmark_6, @function
mem_benchmark_6:
.LFB14:
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
	movq	%rsi, -72(%rbp)
	movq	-72(%rbp), %rax
	movq	%rax, -48(%rbp)
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L83
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.126(%rip), %rax
	cmpq	%rax, %rdx
	je	.L84
.L83:
	movq	-48(%rbp), %rax
	movq	16(%rax), %rax
	jmp	.L85
.L84:
	movq	sp0.125(%rip), %rax
.L85:
	movq	%rax, %rdi
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L86
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.126(%rip), %rax
	cmpq	%rax, %rdx
	je	.L87
.L86:
	movq	-48(%rbp), %rax
	movq	24(%rax), %rax
	jmp	.L88
.L87:
	movq	sp1.124(%rip), %rax
.L88:
	movq	%rax, %rcx
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L89
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.126(%rip), %rax
	cmpq	%rax, %rdx
	je	.L90
.L89:
	movq	-48(%rbp), %rax
	movq	32(%rax), %rax
	jmp	.L91
.L90:
	movq	sp2.123(%rip), %rax
.L91:
	movq	%rax, %r15
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L92
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.126(%rip), %rax
	cmpq	%rax, %rdx
	je	.L93
.L92:
	movq	-48(%rbp), %rax
	movq	40(%rax), %rax
	jmp	.L94
.L93:
	movq	sp3.122(%rip), %rax
.L94:
	movq	%rax, %r14
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L95
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.126(%rip), %rax
	cmpq	%rax, %rdx
	je	.L96
.L95:
	movq	-48(%rbp), %rax
	movq	48(%rax), %rax
	jmp	.L97
.L96:
	movq	sp4.121(%rip), %rax
.L97:
	movq	%rax, %r13
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L98
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.126(%rip), %rax
	cmpq	%rax, %rdx
	je	.L99
.L98:
	movq	-48(%rbp), %rax
	movq	56(%rax), %rax
	jmp	.L100
.L99:
	movq	sp5.120(%rip), %rax
.L100:
	movq	%rax, %r12
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L101
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.126(%rip), %rax
	cmpq	%rax, %rdx
	je	.L102
.L101:
	movq	-48(%rbp), %rax
	movq	64(%rax), %rax
	jmp	.L103
.L102:
	movq	sp6.119(%rip), %rax
.L103:
	movq	%rax, %rbx
	jmp	.L104
.L105:
	movq	%rdi, %rax
	movq	(%rax), %rax
	movq	(%rcx), %rsi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rdi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdi), %rcx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rcx), %rsi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rdi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdi), %rcx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rcx), %rsi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rdi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdi), %rcx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rcx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdx), %rsi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rdi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdi), %rcx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rcx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdx), %rsi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rdi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdi), %rcx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rcx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdx), %rsi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rdi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdi), %rcx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rcx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdx), %rsi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rdi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdi), %rcx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rcx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdx), %rsi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rdi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdi), %rcx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rcx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdx), %rsi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rdi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdi), %rcx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rcx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdx), %rsi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rdi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdi), %rcx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rcx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdx), %rsi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rdi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdi), %rcx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rcx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdx), %rsi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rdi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdi), %rcx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rcx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdx), %rsi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rdi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdi), %rcx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rcx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdx), %rsi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rdi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdi), %rcx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rcx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdx), %rsi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rdi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdi), %rcx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rcx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdx), %rsi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rdi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdi), %rcx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rcx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdx), %rsi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rdi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdi), %rcx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rcx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdx), %rsi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rdi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdi), %rcx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rcx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdx), %rsi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rdi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdi), %rcx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rcx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdx), %rsi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rdi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdi), %rcx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rcx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdx), %rsi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rdi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdi), %rcx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rcx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdx), %rsi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rdi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdi), %rcx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rcx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdx), %rsi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rdi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdi), %rcx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rcx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdx), %rsi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rdi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdi), %rcx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rcx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdx), %rsi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rdi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdi), %rcx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rcx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdx), %rsi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	%rax, %rdi
	movq	(%rsi), %rax
	movq	%rax, %rcx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
.L104:
	movq	-64(%rbp), %rax
	leaq	-1(%rax), %rdx
	movq	%rdx, -64(%rbp)
	testq	%rax, %rax
	jne	.L105
	movq	%rdi, %rax
	movq	%rax, sp0.125(%rip)
	movq	%rcx, %rax
	movq	%rax, sp1.124(%rip)
	movq	%r15, sp2.123(%rip)
	movq	%r14, sp3.122(%rip)
	movq	%r13, sp4.121(%rip)
	movq	%r12, sp5.120(%rip)
	movq	%rbx, sp6.119(%rip)
	movq	-48(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, addr_save.126(%rip)
	movl	$1, mem_benchmark_rerun(%rip)
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE14:
	.size	mem_benchmark_6, .-mem_benchmark_6
	.globl	mem_benchmark_7
	.type	mem_benchmark_7, @function
mem_benchmark_7:
.LFB15:
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
	movq	%rsi, -72(%rbp)
	movq	-72(%rbp), %rax
	movq	%rax, -48(%rbp)
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L107
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.118(%rip), %rax
	cmpq	%rax, %rdx
	je	.L108
.L107:
	movq	-48(%rbp), %rax
	movq	16(%rax), %rax
	jmp	.L109
.L108:
	movq	sp0.117(%rip), %rax
.L109:
	movq	%rax, %rsi
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L110
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.118(%rip), %rax
	cmpq	%rax, %rdx
	je	.L111
.L110:
	movq	-48(%rbp), %rax
	movq	24(%rax), %rax
	jmp	.L112
.L111:
	movq	sp1.116(%rip), %rax
.L112:
	movq	%rax, %rcx
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L113
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.118(%rip), %rax
	cmpq	%rax, %rdx
	je	.L114
.L113:
	movq	-48(%rbp), %rax
	movq	32(%rax), %rax
	jmp	.L115
.L114:
	movq	sp2.115(%rip), %rax
.L115:
	movq	%rax, %rdi
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L116
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.118(%rip), %rax
	cmpq	%rax, %rdx
	je	.L117
.L116:
	movq	-48(%rbp), %rax
	movq	40(%rax), %rax
	jmp	.L118
.L117:
	movq	sp3.114(%rip), %rax
.L118:
	movq	%rax, %r15
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L119
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.118(%rip), %rax
	cmpq	%rax, %rdx
	je	.L120
.L119:
	movq	-48(%rbp), %rax
	movq	48(%rax), %rax
	jmp	.L121
.L120:
	movq	sp4.113(%rip), %rax
.L121:
	movq	%rax, %r14
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L122
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.118(%rip), %rax
	cmpq	%rax, %rdx
	je	.L123
.L122:
	movq	-48(%rbp), %rax
	movq	56(%rax), %rax
	jmp	.L124
.L123:
	movq	sp5.112(%rip), %rax
.L124:
	movq	%rax, %r13
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L125
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.118(%rip), %rax
	cmpq	%rax, %rdx
	je	.L126
.L125:
	movq	-48(%rbp), %rax
	movq	64(%rax), %rax
	jmp	.L127
.L126:
	movq	sp6.111(%rip), %rax
.L127:
	movq	%rax, %r12
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L128
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.118(%rip), %rax
	cmpq	%rax, %rdx
	je	.L129
.L128:
	movq	-48(%rbp), %rax
	movq	72(%rax), %rax
	jmp	.L130
.L129:
	movq	sp7.110(%rip), %rax
.L130:
	movq	%rax, %rbx
	jmp	.L131
.L132:
	movq	%rsi, %rax
	movq	(%rax), %rax
	movq	(%rcx), %rsi
	movq	(%rdi), %rcx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rdi
	movq	(%rcx), %rsi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdi), %rcx
	movq	(%rsi), %rdi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rcx), %rsi
	movq	(%rdi), %rcx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rdi
	movq	(%rcx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdi), %rsi
	movq	(%rdx), %rcx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rdi
	movq	(%rcx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdi), %rsi
	movq	(%rdx), %rcx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rdi
	movq	(%rcx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdi), %rsi
	movq	(%rdx), %rcx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rdi
	movq	(%rcx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdi), %rsi
	movq	(%rdx), %rcx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rdi
	movq	(%rcx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdi), %rsi
	movq	(%rdx), %rcx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rdi
	movq	(%rcx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdi), %rsi
	movq	(%rdx), %rcx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rdi
	movq	(%rcx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdi), %rsi
	movq	(%rdx), %rcx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rdi
	movq	(%rcx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdi), %rsi
	movq	(%rdx), %rcx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rdi
	movq	(%rcx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdi), %rsi
	movq	(%rdx), %rcx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rdi
	movq	(%rcx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdi), %rsi
	movq	(%rdx), %rcx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rdi
	movq	(%rcx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdi), %rsi
	movq	(%rdx), %rcx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rdi
	movq	(%rcx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdi), %rsi
	movq	(%rdx), %rcx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rdi
	movq	(%rcx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdi), %rsi
	movq	(%rdx), %rcx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rdi
	movq	(%rcx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdi), %rsi
	movq	(%rdx), %rcx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rdi
	movq	(%rcx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdi), %rsi
	movq	(%rdx), %rcx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rdi
	movq	(%rcx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdi), %rsi
	movq	(%rdx), %rcx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rdi
	movq	(%rcx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdi), %rsi
	movq	(%rdx), %rcx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rdi
	movq	(%rcx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdi), %rsi
	movq	(%rdx), %rcx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rdi
	movq	(%rcx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdi), %rsi
	movq	(%rdx), %rcx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rdi
	movq	(%rcx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdi), %rsi
	movq	(%rdx), %rcx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rdi
	movq	(%rcx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdi), %rsi
	movq	(%rdx), %rcx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rdi
	movq	(%rcx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdi), %rsi
	movq	(%rdx), %rcx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rdi
	movq	(%rcx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdi), %rsi
	movq	(%rdx), %rcx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rdi
	movq	(%rcx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdi), %rsi
	movq	(%rdx), %rcx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rdi
	movq	(%rcx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdi), %rsi
	movq	(%rdx), %rcx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rdi
	movq	(%rcx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdi), %rsi
	movq	(%rdx), %rcx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rdi
	movq	(%rcx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdi), %rsi
	movq	(%rdx), %rcx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rdi
	movq	(%rcx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdi), %rsi
	movq	(%rdx), %rcx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rdi
	movq	(%rcx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdi), %rsi
	movq	(%rdx), %rcx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rdi
	movq	(%rcx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdi), %rsi
	movq	(%rdx), %rcx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rdi
	movq	(%rcx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdi), %rsi
	movq	(%rdx), %rcx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rdi
	movq	(%rcx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdi), %rsi
	movq	(%rdx), %rcx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rdi
	movq	(%rcx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdi), %rsi
	movq	(%rdx), %rcx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rdi
	movq	(%rcx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdi), %rsi
	movq	(%rdx), %rcx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rdi
	movq	(%rcx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdi), %rsi
	movq	(%rdx), %rcx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rdi
	movq	(%rcx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdi), %rsi
	movq	(%rdx), %rcx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rdi
	movq	(%rcx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdi), %rsi
	movq	(%rdx), %rcx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rdi
	movq	(%rcx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdi), %rsi
	movq	(%rdx), %rcx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rdi
	movq	(%rcx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdi), %rsi
	movq	(%rdx), %rcx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rdi
	movq	(%rcx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdi), %rsi
	movq	(%rdx), %rcx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rdi
	movq	(%rcx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdi), %rsi
	movq	(%rdx), %rcx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rdi
	movq	(%rcx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdi), %rsi
	movq	(%rdx), %rcx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rdi
	movq	(%rcx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdi), %rsi
	movq	(%rdx), %rcx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rdi
	movq	(%rcx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdi), %rsi
	movq	(%rdx), %rcx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rdi
	movq	(%rcx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdi), %rsi
	movq	(%rdx), %rcx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rdi
	movq	(%rcx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdi), %rsi
	movq	(%rdx), %rcx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rdi
	movq	(%rcx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdi), %rsi
	movq	(%rdx), %rcx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rdi
	movq	(%rcx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	%rax, %rsi
	movq	(%rdi), %rax
	movq	%rax, %rcx
	movq	(%rdx), %rax
	movq	%rax, %rdi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
.L131:
	movq	-64(%rbp), %rax
	leaq	-1(%rax), %rdx
	movq	%rdx, -64(%rbp)
	testq	%rax, %rax
	jne	.L132
	movq	%rsi, %rax
	movq	%rax, sp0.117(%rip)
	movq	%rcx, %rax
	movq	%rax, sp1.116(%rip)
	movq	%rdi, %rax
	movq	%rax, sp2.115(%rip)
	movq	%r15, sp3.114(%rip)
	movq	%r14, sp4.113(%rip)
	movq	%r13, sp5.112(%rip)
	movq	%r12, sp6.111(%rip)
	movq	%rbx, sp7.110(%rip)
	movq	-48(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, addr_save.118(%rip)
	movl	$1, mem_benchmark_rerun(%rip)
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE15:
	.size	mem_benchmark_7, .-mem_benchmark_7
	.globl	mem_benchmark_8
	.type	mem_benchmark_8, @function
mem_benchmark_8:
.LFB16:
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
	movq	%rsi, -72(%rbp)
	movq	-72(%rbp), %rax
	movq	%rax, -48(%rbp)
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L134
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.109(%rip), %rax
	cmpq	%rax, %rdx
	je	.L135
.L134:
	movq	-48(%rbp), %rax
	movq	16(%rax), %rax
	jmp	.L136
.L135:
	movq	sp0.108(%rip), %rax
.L136:
	movq	%rax, %rsi
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L137
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.109(%rip), %rax
	cmpq	%rax, %rdx
	je	.L138
.L137:
	movq	-48(%rbp), %rax
	movq	24(%rax), %rax
	jmp	.L139
.L138:
	movq	sp1.107(%rip), %rax
.L139:
	movq	%rax, %r8
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L140
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.109(%rip), %rax
	cmpq	%rax, %rdx
	je	.L141
.L140:
	movq	-48(%rbp), %rax
	movq	32(%rax), %rax
	jmp	.L142
.L141:
	movq	sp2.106(%rip), %rax
.L142:
	movq	%rax, %r9
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L143
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.109(%rip), %rax
	cmpq	%rax, %rdx
	je	.L144
.L143:
	movq	-48(%rbp), %rax
	movq	40(%rax), %rax
	jmp	.L145
.L144:
	movq	sp3.105(%rip), %rax
.L145:
	movq	%rax, %r10
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L146
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.109(%rip), %rax
	cmpq	%rax, %rdx
	je	.L147
.L146:
	movq	-48(%rbp), %rax
	movq	48(%rax), %rax
	jmp	.L148
.L147:
	movq	sp4.104(%rip), %rax
.L148:
	movq	%rax, %r15
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L149
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.109(%rip), %rax
	cmpq	%rax, %rdx
	je	.L150
.L149:
	movq	-48(%rbp), %rax
	movq	56(%rax), %rax
	jmp	.L151
.L150:
	movq	sp5.103(%rip), %rax
.L151:
	movq	%rax, %r14
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L152
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.109(%rip), %rax
	cmpq	%rax, %rdx
	je	.L153
.L152:
	movq	-48(%rbp), %rax
	movq	64(%rax), %rax
	jmp	.L154
.L153:
	movq	sp6.102(%rip), %rax
.L154:
	movq	%rax, %r13
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L155
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.109(%rip), %rax
	cmpq	%rax, %rdx
	je	.L156
.L155:
	movq	-48(%rbp), %rax
	movq	72(%rax), %rax
	jmp	.L157
.L156:
	movq	sp7.101(%rip), %rax
.L157:
	movq	%rax, %r12
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L158
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.109(%rip), %rax
	cmpq	%rax, %rdx
	je	.L159
.L158:
	movq	-48(%rbp), %rax
	movq	80(%rax), %rax
	jmp	.L160
.L159:
	movq	sp8.100(%rip), %rax
.L160:
	movq	%rax, %rbx
	jmp	.L161
.L162:
	movq	%rsi, %rax
	movq	(%rax), %rax
	movq	%r8, %rcx
	movq	(%rcx), %rsi
	movq	%r9, %rdi
	movq	(%rdi), %rcx
	movq	%r10, %rdi
	movq	(%rdi), %rdi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rdx
	movq	(%rdi), %rcx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rdi
	movq	(%rdx), %rsi
	movq	(%rcx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdi), %rcx
	movq	(%rsi), %rdi
	movq	(%rdx), %rsi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rcx), %rdx
	movq	(%rdi), %rcx
	movq	(%rsi), %rdi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdx), %rsi
	movq	(%rcx), %rdx
	movq	(%rdi), %rcx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rdi
	movq	(%rdx), %rsi
	movq	(%rcx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdi), %rcx
	movq	(%rsi), %rdi
	movq	(%rdx), %rsi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rcx), %rdx
	movq	(%rdi), %rcx
	movq	(%rsi), %rdi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdx), %rsi
	movq	(%rcx), %rdx
	movq	(%rdi), %rcx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rdi
	movq	(%rdx), %rsi
	movq	(%rcx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdi), %rcx
	movq	(%rsi), %rdi
	movq	(%rdx), %rsi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rcx), %rdx
	movq	(%rdi), %rcx
	movq	(%rsi), %rdi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdx), %rsi
	movq	(%rcx), %rdx
	movq	(%rdi), %rcx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rdi
	movq	(%rdx), %rsi
	movq	(%rcx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdi), %rcx
	movq	(%rsi), %rdi
	movq	(%rdx), %rsi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rcx), %rdx
	movq	(%rdi), %rcx
	movq	(%rsi), %rdi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdx), %rsi
	movq	(%rcx), %rdx
	movq	(%rdi), %rcx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rdi
	movq	(%rdx), %rsi
	movq	(%rcx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdi), %rcx
	movq	(%rsi), %rdi
	movq	(%rdx), %rsi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rcx), %rdx
	movq	(%rdi), %rcx
	movq	(%rsi), %rdi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdx), %rsi
	movq	(%rcx), %rdx
	movq	(%rdi), %rcx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rdi
	movq	(%rdx), %rsi
	movq	(%rcx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdi), %rcx
	movq	(%rsi), %rdi
	movq	(%rdx), %rsi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rcx), %rdx
	movq	(%rdi), %rcx
	movq	(%rsi), %rdi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdx), %rsi
	movq	(%rcx), %rdx
	movq	(%rdi), %rcx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rdi
	movq	(%rdx), %rsi
	movq	(%rcx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdi), %rcx
	movq	(%rsi), %rdi
	movq	(%rdx), %rsi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rcx), %rdx
	movq	(%rdi), %rcx
	movq	(%rsi), %rdi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdx), %rsi
	movq	(%rcx), %rdx
	movq	(%rdi), %rcx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rdi
	movq	(%rdx), %rsi
	movq	(%rcx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdi), %rcx
	movq	(%rsi), %rdi
	movq	(%rdx), %rsi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rcx), %rdx
	movq	(%rdi), %rcx
	movq	(%rsi), %rdi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdx), %rsi
	movq	(%rcx), %rdx
	movq	(%rdi), %rcx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rdi
	movq	(%rdx), %rsi
	movq	(%rcx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdi), %rcx
	movq	(%rsi), %rdi
	movq	(%rdx), %rsi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rcx), %rdx
	movq	(%rdi), %rcx
	movq	(%rsi), %rdi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdx), %rsi
	movq	(%rcx), %rdx
	movq	(%rdi), %rcx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rdi
	movq	(%rdx), %rsi
	movq	(%rcx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdi), %rcx
	movq	(%rsi), %rdi
	movq	(%rdx), %rsi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rcx), %rdx
	movq	(%rdi), %rcx
	movq	(%rsi), %rdi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdx), %rsi
	movq	(%rcx), %rdx
	movq	(%rdi), %rcx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rdi
	movq	(%rdx), %rsi
	movq	(%rcx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdi), %rcx
	movq	(%rsi), %rdi
	movq	(%rdx), %rsi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rcx), %rdx
	movq	(%rdi), %rcx
	movq	(%rsi), %rdi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdx), %rsi
	movq	(%rcx), %rdx
	movq	(%rdi), %rcx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rdi
	movq	(%rdx), %rsi
	movq	(%rcx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdi), %rcx
	movq	(%rsi), %rdi
	movq	(%rdx), %rsi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rcx), %rdx
	movq	(%rdi), %rcx
	movq	(%rsi), %rdi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdx), %rsi
	movq	(%rcx), %rdx
	movq	(%rdi), %rcx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rdi
	movq	(%rdx), %rsi
	movq	(%rcx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdi), %rcx
	movq	(%rsi), %rdi
	movq	(%rdx), %rsi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rcx), %rdx
	movq	(%rdi), %rcx
	movq	(%rsi), %rdi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdx), %rsi
	movq	(%rcx), %rdx
	movq	(%rdi), %rcx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rdi
	movq	(%rdx), %rsi
	movq	(%rcx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdi), %rcx
	movq	(%rsi), %rdi
	movq	(%rdx), %rsi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rcx), %rdx
	movq	(%rdi), %rcx
	movq	(%rsi), %rdi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdx), %rsi
	movq	(%rcx), %rdx
	movq	(%rdi), %rcx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rdi
	movq	(%rdx), %rsi
	movq	(%rcx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdi), %rcx
	movq	(%rsi), %rdi
	movq	(%rdx), %rsi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rcx), %rdx
	movq	(%rdi), %rcx
	movq	(%rsi), %rdi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdx), %rsi
	movq	(%rcx), %rdx
	movq	(%rdi), %rcx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rdi
	movq	(%rdx), %rsi
	movq	(%rcx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdi), %rcx
	movq	(%rsi), %rdi
	movq	(%rdx), %rsi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rcx), %rdx
	movq	(%rdi), %rcx
	movq	(%rsi), %rdi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdx), %rsi
	movq	(%rcx), %rdx
	movq	(%rdi), %rcx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rdi
	movq	(%rdx), %rsi
	movq	(%rcx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdi), %rcx
	movq	(%rsi), %rdi
	movq	(%rdx), %rsi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rcx), %rdx
	movq	(%rdi), %rcx
	movq	(%rsi), %rdi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdx), %rsi
	movq	(%rcx), %rdx
	movq	(%rdi), %rcx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rdi
	movq	(%rdx), %rsi
	movq	(%rcx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdi), %rcx
	movq	(%rsi), %rdi
	movq	(%rdx), %rsi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rcx), %rdx
	movq	(%rdi), %rcx
	movq	(%rsi), %rdi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdx), %rsi
	movq	(%rcx), %rdx
	movq	(%rdi), %rcx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rdi
	movq	(%rdx), %rsi
	movq	(%rcx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdi), %rcx
	movq	(%rsi), %rdi
	movq	(%rdx), %rsi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rcx), %rdx
	movq	(%rdi), %rcx
	movq	(%rsi), %rdi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdx), %rsi
	movq	(%rcx), %rdx
	movq	(%rdi), %rcx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rdi
	movq	(%rdx), %rsi
	movq	(%rcx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdi), %rcx
	movq	(%rsi), %rdi
	movq	(%rdx), %rsi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rcx), %rdx
	movq	(%rdi), %rcx
	movq	(%rsi), %rdi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdx), %rsi
	movq	(%rcx), %rdx
	movq	(%rdi), %rcx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rdi
	movq	(%rdx), %rsi
	movq	(%rcx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdi), %rcx
	movq	(%rsi), %rdi
	movq	(%rdx), %rsi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rcx), %rdx
	movq	(%rdi), %rcx
	movq	(%rsi), %rdi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdx), %rsi
	movq	(%rcx), %rdx
	movq	(%rdi), %rcx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rdi
	movq	(%rdx), %rsi
	movq	(%rcx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdi), %rcx
	movq	(%rsi), %rdi
	movq	(%rdx), %rsi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rcx), %rdx
	movq	(%rdi), %rcx
	movq	(%rsi), %rdi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdx), %rsi
	movq	(%rcx), %rdx
	movq	(%rdi), %rcx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rdi
	movq	(%rdx), %rsi
	movq	(%rcx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdi), %rcx
	movq	(%rsi), %rdi
	movq	(%rdx), %rsi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rcx), %rdx
	movq	(%rdi), %rcx
	movq	(%rsi), %rdi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdx), %rsi
	movq	(%rcx), %rdx
	movq	(%rdi), %rcx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rdi
	movq	(%rdx), %rsi
	movq	(%rcx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rdi), %rcx
	movq	(%rsi), %rdi
	movq	(%rdx), %rsi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rcx), %rdx
	movq	(%rdi), %rcx
	movq	(%rsi), %rdi
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	%rax, %rsi
	movq	(%rdx), %rax
	movq	%rax, %r8
	movq	(%rcx), %rax
	movq	%rax, %r9
	movq	(%rdi), %rax
	movq	%rax, %r10
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
.L161:
	movq	-64(%rbp), %rax
	leaq	-1(%rax), %rdx
	movq	%rdx, -64(%rbp)
	testq	%rax, %rax
	jne	.L162
	movq	%rsi, %rax
	movq	%rax, sp0.108(%rip)
	movq	%r8, %rax
	movq	%rax, sp1.107(%rip)
	movq	%r9, %rax
	movq	%rax, sp2.106(%rip)
	movq	%r10, %rax
	movq	%rax, sp3.105(%rip)
	movq	%r15, sp4.104(%rip)
	movq	%r14, sp5.103(%rip)
	movq	%r13, sp6.102(%rip)
	movq	%r12, sp7.101(%rip)
	movq	%rbx, sp8.100(%rip)
	movq	-48(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, addr_save.109(%rip)
	movl	$1, mem_benchmark_rerun(%rip)
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE16:
	.size	mem_benchmark_8, .-mem_benchmark_8
	.globl	mem_benchmark_9
	.type	mem_benchmark_9, @function
mem_benchmark_9:
.LFB17:
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
	movq	%rsi, -72(%rbp)
	movq	-72(%rbp), %rax
	movq	%rax, -48(%rbp)
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L164
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.99(%rip), %rax
	cmpq	%rax, %rdx
	je	.L165
.L164:
	movq	-48(%rbp), %rax
	movq	16(%rax), %rax
	jmp	.L166
.L165:
	movq	sp0.98(%rip), %rax
.L166:
	movq	%rax, %r8
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L167
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.99(%rip), %rax
	cmpq	%rax, %rdx
	je	.L168
.L167:
	movq	-48(%rbp), %rax
	movq	24(%rax), %rax
	jmp	.L169
.L168:
	movq	sp1.97(%rip), %rax
.L169:
	movq	%rax, %rsi
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L170
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.99(%rip), %rax
	cmpq	%rax, %rdx
	je	.L171
.L170:
	movq	-48(%rbp), %rax
	movq	32(%rax), %rax
	jmp	.L172
.L171:
	movq	sp2.96(%rip), %rax
.L172:
	movq	%rax, %r9
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L173
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.99(%rip), %rax
	cmpq	%rax, %rdx
	je	.L174
.L173:
	movq	-48(%rbp), %rax
	movq	40(%rax), %rax
	jmp	.L175
.L174:
	movq	sp3.95(%rip), %rax
.L175:
	movq	%rax, %r10
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L176
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.99(%rip), %rax
	cmpq	%rax, %rdx
	je	.L177
.L176:
	movq	-48(%rbp), %rax
	movq	48(%rax), %rax
	jmp	.L178
.L177:
	movq	sp4.94(%rip), %rax
.L178:
	movq	%rax, %r11
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L179
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.99(%rip), %rax
	cmpq	%rax, %rdx
	je	.L180
.L179:
	movq	-48(%rbp), %rax
	movq	56(%rax), %rax
	jmp	.L181
.L180:
	movq	sp5.93(%rip), %rax
.L181:
	movq	%rax, %r15
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L182
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.99(%rip), %rax
	cmpq	%rax, %rdx
	je	.L183
.L182:
	movq	-48(%rbp), %rax
	movq	64(%rax), %rax
	jmp	.L184
.L183:
	movq	sp6.92(%rip), %rax
.L184:
	movq	%rax, %r14
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L185
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.99(%rip), %rax
	cmpq	%rax, %rdx
	je	.L186
.L185:
	movq	-48(%rbp), %rax
	movq	72(%rax), %rax
	jmp	.L187
.L186:
	movq	sp7.91(%rip), %rax
.L187:
	movq	%rax, %r13
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L188
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.99(%rip), %rax
	cmpq	%rax, %rdx
	je	.L189
.L188:
	movq	-48(%rbp), %rax
	movq	80(%rax), %rax
	jmp	.L190
.L189:
	movq	sp8.90(%rip), %rax
.L190:
	movq	%rax, %r12
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L191
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.99(%rip), %rax
	cmpq	%rax, %rdx
	je	.L192
.L191:
	movq	-48(%rbp), %rax
	movq	88(%rax), %rax
	jmp	.L193
.L192:
	movq	sp9.89(%rip), %rax
.L193:
	movq	%rax, %rbx
	jmp	.L194
.L195:
	movq	%r8, %rax
	movq	(%rax), %rax
	movq	%rsi, %rcx
	movq	(%rcx), %rsi
	movq	%r9, %rdi
	movq	(%rdi), %rcx
	movq	%r10, %rdi
	movq	(%rdi), %rdi
	movq	%r11, %rdx
	movq	(%rdx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	%rax, %r8
	movq	(%rsi), %rax
	movq	%rax, %rsi
	movq	(%rcx), %rax
	movq	%rax, %r9
	movq	(%rdi), %rax
	movq	%rax, %r10
	movq	(%rdx), %rax
	movq	%rax, %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
.L194:
	movq	-64(%rbp), %rax
	leaq	-1(%rax), %rdx
	movq	%rdx, -64(%rbp)
	testq	%rax, %rax
	jne	.L195
	movq	%r8, %rax
	movq	%rax, sp0.98(%rip)
	movq	%rsi, %rax
	movq	%rax, sp1.97(%rip)
	movq	%r9, %rax
	movq	%rax, sp2.96(%rip)
	movq	%r10, %rax
	movq	%rax, sp3.95(%rip)
	movq	%r11, %rax
	movq	%rax, sp4.94(%rip)
	movq	%r15, sp5.93(%rip)
	movq	%r14, sp6.92(%rip)
	movq	%r13, sp7.91(%rip)
	movq	%r12, sp8.90(%rip)
	movq	%rbx, sp9.89(%rip)
	movq	-48(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, addr_save.99(%rip)
	movl	$1, mem_benchmark_rerun(%rip)
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE17:
	.size	mem_benchmark_9, .-mem_benchmark_9
	.globl	mem_benchmark_10
	.type	mem_benchmark_10, @function
mem_benchmark_10:
.LFB18:
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
	movq	%rsi, -72(%rbp)
	movq	-72(%rbp), %rax
	movq	%rax, -48(%rbp)
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L197
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.88(%rip), %rax
	cmpq	%rax, %rdx
	je	.L198
.L197:
	movq	-48(%rbp), %rax
	movq	16(%rax), %rax
	jmp	.L199
.L198:
	movq	sp0.87(%rip), %rax
.L199:
	movq	%rax, %r8
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L200
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.88(%rip), %rax
	cmpq	%rax, %rdx
	je	.L201
.L200:
	movq	-48(%rbp), %rax
	movq	24(%rax), %rax
	jmp	.L202
.L201:
	movq	sp1.86(%rip), %rax
.L202:
	movq	%rax, %rsi
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L203
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.88(%rip), %rax
	cmpq	%rax, %rdx
	je	.L204
.L203:
	movq	-48(%rbp), %rax
	movq	32(%rax), %rax
	jmp	.L205
.L204:
	movq	sp2.85(%rip), %rax
.L205:
	movq	%rax, %r9
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L206
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.88(%rip), %rax
	cmpq	%rax, %rdx
	je	.L207
.L206:
	movq	-48(%rbp), %rax
	movq	40(%rax), %rax
	jmp	.L208
.L207:
	movq	sp3.84(%rip), %rax
.L208:
	movq	%rax, %r10
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L209
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.88(%rip), %rax
	cmpq	%rax, %rdx
	je	.L210
.L209:
	movq	-48(%rbp), %rax
	movq	48(%rax), %rax
	jmp	.L211
.L210:
	movq	sp4.83(%rip), %rax
.L211:
	movq	%rax, -80(%rbp)
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L212
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.88(%rip), %rax
	cmpq	%rax, %rdx
	je	.L213
.L212:
	movq	-48(%rbp), %rax
	movq	56(%rax), %rax
	jmp	.L214
.L213:
	movq	sp5.82(%rip), %rax
.L214:
	movq	%rax, %r11
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L215
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.88(%rip), %rax
	cmpq	%rax, %rdx
	je	.L216
.L215:
	movq	-48(%rbp), %rax
	movq	64(%rax), %rax
	jmp	.L217
.L216:
	movq	sp6.81(%rip), %rax
.L217:
	movq	%rax, %r15
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L218
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.88(%rip), %rax
	cmpq	%rax, %rdx
	je	.L219
.L218:
	movq	-48(%rbp), %rax
	movq	72(%rax), %rax
	jmp	.L220
.L219:
	movq	sp7.80(%rip), %rax
.L220:
	movq	%rax, %r14
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L221
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.88(%rip), %rax
	cmpq	%rax, %rdx
	je	.L222
.L221:
	movq	-48(%rbp), %rax
	movq	80(%rax), %rax
	jmp	.L223
.L222:
	movq	sp8.79(%rip), %rax
.L223:
	movq	%rax, %r13
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L224
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.88(%rip), %rax
	cmpq	%rax, %rdx
	je	.L225
.L224:
	movq	-48(%rbp), %rax
	movq	88(%rax), %rax
	jmp	.L226
.L225:
	movq	sp9.78(%rip), %rax
.L226:
	movq	%rax, %r12
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L227
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.88(%rip), %rax
	cmpq	%rax, %rdx
	je	.L228
.L227:
	movq	-48(%rbp), %rax
	movq	96(%rax), %rax
	jmp	.L229
.L228:
	movq	sp10.77(%rip), %rax
.L229:
	movq	%rax, %rbx
	jmp	.L230
.L231:
	movq	%r8, %rax
	movq	(%rax), %rax
	movq	%rsi, %rcx
	movq	(%rcx), %rsi
	movq	%r9, %rdi
	movq	(%rdi), %rcx
	movq	%r10, %rdi
	movq	(%rdi), %rdi
	movq	-80(%rbp), %rdx
	movq	(%rdx), %rdx
	movq	%r11, %r8
	movq	(%r8), %r9
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r10
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r10), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r11), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r8), %r9
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r10
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r10), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r11), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r8), %r9
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r10
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r10), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r11), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r8), %r9
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r10
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r10), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r11), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r8), %r9
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r10
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r10), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r11), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r8), %r9
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r10
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r10), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r11), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r8), %r9
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r10
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r10), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r11), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r8), %r9
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r10
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r10), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r11), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r8), %r9
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r10
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r10), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r11), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r8), %r9
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r10
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r10), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r11), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r8), %r9
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r10
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r10), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r11), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r8), %r9
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r10
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r10), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r11), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r8), %r9
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r10
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r10), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r11), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r8), %r9
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r10
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r10), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r11), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r8), %r9
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r10
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r10), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r11), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r8), %r9
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r10
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r10), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r11), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r8), %r9
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r10
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r10), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r11), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r8), %r9
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r10
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r10), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r11), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r8), %r9
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r10
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r10), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r11), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r8), %r9
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r10
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r10), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r11), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r8), %r9
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r10
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r10), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r11), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r8), %r9
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r10
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r10), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r11), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r8), %r9
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r10
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r10), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r11), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r8), %r9
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r10
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r10), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r11), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r8), %r9
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r10
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r10), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	%rax, %r8
	movq	(%rsi), %rax
	movq	%rax, %rsi
	movq	(%rcx), %rax
	movq	%rax, %r9
	movq	(%rdi), %rax
	movq	%rax, %r10
	movq	(%rdx), %rax
	movq	%rax, -80(%rbp)
	movq	(%r11), %rax
	movq	%rax, %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
.L230:
	movq	-64(%rbp), %rax
	leaq	-1(%rax), %rdx
	movq	%rdx, -64(%rbp)
	testq	%rax, %rax
	jne	.L231
	movq	%r8, %rax
	movq	%rax, sp0.87(%rip)
	movq	%rsi, %rax
	movq	%rax, sp1.86(%rip)
	movq	%r9, %rax
	movq	%rax, sp2.85(%rip)
	movq	%r10, %rax
	movq	%rax, sp3.84(%rip)
	movq	-80(%rbp), %rax
	movq	%rax, sp4.83(%rip)
	movq	%r11, %rax
	movq	%rax, sp5.82(%rip)
	movq	%r15, sp6.81(%rip)
	movq	%r14, sp7.80(%rip)
	movq	%r13, sp8.79(%rip)
	movq	%r12, sp9.78(%rip)
	movq	%rbx, sp10.77(%rip)
	movq	-48(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, addr_save.88(%rip)
	movl	$1, mem_benchmark_rerun(%rip)
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE18:
	.size	mem_benchmark_10, .-mem_benchmark_10
	.globl	mem_benchmark_11
	.type	mem_benchmark_11, @function
mem_benchmark_11:
.LFB19:
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
	movq	%rsi, -72(%rbp)
	movq	-72(%rbp), %rax
	movq	%rax, -48(%rbp)
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L233
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.76(%rip), %rax
	cmpq	%rax, %rdx
	je	.L234
.L233:
	movq	-48(%rbp), %rax
	movq	16(%rax), %rax
	jmp	.L235
.L234:
	movq	sp0.75(%rip), %rax
.L235:
	movq	%rax, %r8
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L236
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.76(%rip), %rax
	cmpq	%rax, %rdx
	je	.L237
.L236:
	movq	-48(%rbp), %rax
	movq	24(%rax), %rax
	jmp	.L238
.L237:
	movq	sp1.74(%rip), %rax
.L238:
	movq	%rax, %rsi
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L239
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.76(%rip), %rax
	cmpq	%rax, %rdx
	je	.L240
.L239:
	movq	-48(%rbp), %rax
	movq	32(%rax), %rax
	jmp	.L241
.L240:
	movq	sp2.73(%rip), %rax
.L241:
	movq	%rax, %r10
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L242
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.76(%rip), %rax
	cmpq	%rax, %rdx
	je	.L243
.L242:
	movq	-48(%rbp), %rax
	movq	40(%rax), %rax
	jmp	.L244
.L243:
	movq	sp3.72(%rip), %rax
.L244:
	movq	%rax, -80(%rbp)
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L245
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.76(%rip), %rax
	cmpq	%rax, %rdx
	je	.L246
.L245:
	movq	-48(%rbp), %rax
	movq	48(%rax), %rax
	jmp	.L247
.L246:
	movq	sp4.71(%rip), %rax
.L247:
	movq	%rax, -88(%rbp)
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L248
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.76(%rip), %rax
	cmpq	%rax, %rdx
	je	.L249
.L248:
	movq	-48(%rbp), %rax
	movq	56(%rax), %rax
	jmp	.L250
.L249:
	movq	sp5.70(%rip), %rax
.L250:
	movq	%rax, %r9
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L251
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.76(%rip), %rax
	cmpq	%rax, %rdx
	je	.L252
.L251:
	movq	-48(%rbp), %rax
	movq	64(%rax), %rax
	jmp	.L253
.L252:
	movq	sp6.69(%rip), %rax
.L253:
	movq	%rax, %r11
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L254
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.76(%rip), %rax
	cmpq	%rax, %rdx
	je	.L255
.L254:
	movq	-48(%rbp), %rax
	movq	72(%rax), %rax
	jmp	.L256
.L255:
	movq	sp7.68(%rip), %rax
.L256:
	movq	%rax, %r15
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L257
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.76(%rip), %rax
	cmpq	%rax, %rdx
	je	.L258
.L257:
	movq	-48(%rbp), %rax
	movq	80(%rax), %rax
	jmp	.L259
.L258:
	movq	sp8.67(%rip), %rax
.L259:
	movq	%rax, %r14
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L260
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.76(%rip), %rax
	cmpq	%rax, %rdx
	je	.L261
.L260:
	movq	-48(%rbp), %rax
	movq	88(%rax), %rax
	jmp	.L262
.L261:
	movq	sp9.66(%rip), %rax
.L262:
	movq	%rax, %r13
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L263
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.76(%rip), %rax
	cmpq	%rax, %rdx
	je	.L264
.L263:
	movq	-48(%rbp), %rax
	movq	96(%rax), %rax
	jmp	.L265
.L264:
	movq	sp10.65(%rip), %rax
.L265:
	movq	%rax, %r12
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L266
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.76(%rip), %rax
	cmpq	%rax, %rdx
	je	.L267
.L266:
	movq	-48(%rbp), %rax
	movq	104(%rax), %rax
	jmp	.L268
.L267:
	movq	sp11.64(%rip), %rax
.L268:
	movq	%rax, %rbx
	jmp	.L269
.L270:
	movq	%r8, %rax
	movq	(%rax), %rax
	movq	%rsi, %rcx
	movq	(%rcx), %rsi
	movq	%r10, %rdi
	movq	(%rdi), %rcx
	movq	-80(%rbp), %rdi
	movq	(%rdi), %rdi
	movq	-88(%rbp), %rdx
	movq	(%rdx), %rdx
	movq	%r9, %r8
	movq	(%r8), %r9
	movq	%r11, %r10
	movq	(%r10), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r8
	movq	(%r11), %r10
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r8), %r9
	movq	(%r10), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r8
	movq	(%r11), %r10
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r8), %r9
	movq	(%r10), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r8
	movq	(%r11), %r10
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r8), %r9
	movq	(%r10), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r8
	movq	(%r11), %r10
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r8), %r9
	movq	(%r10), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r8
	movq	(%r11), %r10
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r8), %r9
	movq	(%r10), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r8
	movq	(%r11), %r10
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r8), %r9
	movq	(%r10), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r8
	movq	(%r11), %r10
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r8), %r9
	movq	(%r10), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r8
	movq	(%r11), %r10
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r8), %r9
	movq	(%r10), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r8
	movq	(%r11), %r10
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r8), %r9
	movq	(%r10), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r8
	movq	(%r11), %r10
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r8), %r9
	movq	(%r10), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r8
	movq	(%r11), %r10
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r8), %r9
	movq	(%r10), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r8
	movq	(%r11), %r10
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r8), %r9
	movq	(%r10), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r8
	movq	(%r11), %r10
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r8), %r9
	movq	(%r10), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r8
	movq	(%r11), %r10
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r8), %r9
	movq	(%r10), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r8
	movq	(%r11), %r10
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r8), %r9
	movq	(%r10), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r8
	movq	(%r11), %r10
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r8), %r9
	movq	(%r10), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r8
	movq	(%r11), %r10
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r8), %r9
	movq	(%r10), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r8
	movq	(%r11), %r10
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r8), %r9
	movq	(%r10), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r8
	movq	(%r11), %r10
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r8), %r9
	movq	(%r10), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r8
	movq	(%r11), %r10
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r8), %r9
	movq	(%r10), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r8
	movq	(%r11), %r10
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r8), %r9
	movq	(%r10), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r8
	movq	(%r11), %r10
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r8), %r9
	movq	(%r10), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r8
	movq	(%r11), %r10
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r8), %r9
	movq	(%r10), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r8
	movq	(%r11), %r10
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r8), %r9
	movq	(%r10), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r8
	movq	(%r11), %r10
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r8), %r9
	movq	(%r10), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r8
	movq	(%r11), %r10
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r8), %r9
	movq	(%r10), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r8
	movq	(%r11), %r10
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r8), %r9
	movq	(%r10), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r8
	movq	(%r11), %r10
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r8), %r9
	movq	(%r10), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r8
	movq	(%r11), %r10
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r8), %r9
	movq	(%r10), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r8
	movq	(%r11), %r10
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r8), %r9
	movq	(%r10), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r8
	movq	(%r11), %r10
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r8), %r9
	movq	(%r10), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r8
	movq	(%r11), %r10
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r8), %r9
	movq	(%r10), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r8
	movq	(%r11), %r10
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r8), %r9
	movq	(%r10), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r8
	movq	(%r11), %r10
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r8), %r9
	movq	(%r10), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r8
	movq	(%r11), %r10
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r8), %r9
	movq	(%r10), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r8
	movq	(%r11), %r10
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r8), %r9
	movq	(%r10), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r8
	movq	(%r11), %r10
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r8), %r9
	movq	(%r10), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r8
	movq	(%r11), %r10
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r8), %r9
	movq	(%r10), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r8
	movq	(%r11), %r10
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r8), %r9
	movq	(%r10), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r8
	movq	(%r11), %r10
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r8), %r9
	movq	(%r10), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r8
	movq	(%r11), %r10
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r8), %r9
	movq	(%r10), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r8
	movq	(%r11), %r10
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r8), %r9
	movq	(%r10), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r8
	movq	(%r11), %r10
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r8), %r9
	movq	(%r10), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r8
	movq	(%r11), %r10
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r8), %r9
	movq	(%r10), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r8
	movq	(%r11), %r10
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r8), %r9
	movq	(%r10), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r8
	movq	(%r11), %r10
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r8), %r9
	movq	(%r10), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r8
	movq	(%r11), %r10
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r8), %r9
	movq	(%r10), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r8
	movq	(%r11), %r10
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r8), %r9
	movq	(%r10), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r8
	movq	(%r11), %r10
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r8), %r9
	movq	(%r10), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	%rax, %r8
	movq	(%rsi), %rax
	movq	%rax, %rsi
	movq	(%rcx), %rax
	movq	%rax, %r10
	movq	(%rdi), %rax
	movq	%rax, -80(%rbp)
	movq	(%rdx), %rax
	movq	%rax, -88(%rbp)
	movq	(%r9), %rax
	movq	%rax, %r9
	movq	(%r11), %rax
	movq	%rax, %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
.L269:
	movq	-64(%rbp), %rax
	leaq	-1(%rax), %rdx
	movq	%rdx, -64(%rbp)
	testq	%rax, %rax
	jne	.L270
	movq	%r8, %rax
	movq	%rax, sp0.75(%rip)
	movq	%rsi, %rax
	movq	%rax, sp1.74(%rip)
	movq	%r10, %rax
	movq	%rax, sp2.73(%rip)
	movq	-80(%rbp), %rax
	movq	%rax, sp3.72(%rip)
	movq	-88(%rbp), %rax
	movq	%rax, sp4.71(%rip)
	movq	%r9, %rax
	movq	%rax, sp5.70(%rip)
	movq	%r11, %rax
	movq	%rax, sp6.69(%rip)
	movq	%r15, sp7.68(%rip)
	movq	%r14, sp8.67(%rip)
	movq	%r13, sp9.66(%rip)
	movq	%r12, sp10.65(%rip)
	movq	%rbx, sp11.64(%rip)
	movq	-48(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, addr_save.76(%rip)
	movl	$1, mem_benchmark_rerun(%rip)
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE19:
	.size	mem_benchmark_11, .-mem_benchmark_11
	.globl	mem_benchmark_12
	.type	mem_benchmark_12, @function
mem_benchmark_12:
.LFB20:
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
	movq	%rsi, -72(%rbp)
	movq	-72(%rbp), %rax
	movq	%rax, -48(%rbp)
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L272
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.63(%rip), %rax
	cmpq	%rax, %rdx
	je	.L273
.L272:
	movq	-48(%rbp), %rax
	movq	16(%rax), %rax
	jmp	.L274
.L273:
	movq	sp0.62(%rip), %rax
.L274:
	movq	%rax, %r11
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L275
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.63(%rip), %rax
	cmpq	%rax, %rdx
	je	.L276
.L275:
	movq	-48(%rbp), %rax
	movq	24(%rax), %rax
	jmp	.L277
.L276:
	movq	sp1.61(%rip), %rax
.L277:
	movq	%rax, %rsi
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L278
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.63(%rip), %rax
	cmpq	%rax, %rdx
	je	.L279
.L278:
	movq	-48(%rbp), %rax
	movq	32(%rax), %rax
	jmp	.L280
.L279:
	movq	sp2.60(%rip), %rax
.L280:
	movq	%rax, -80(%rbp)
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L281
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.63(%rip), %rax
	cmpq	%rax, %rdx
	je	.L282
.L281:
	movq	-48(%rbp), %rax
	movq	40(%rax), %rax
	jmp	.L283
.L282:
	movq	sp3.59(%rip), %rax
.L283:
	movq	%rax, -88(%rbp)
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L284
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.63(%rip), %rax
	cmpq	%rax, %rdx
	je	.L285
.L284:
	movq	-48(%rbp), %rax
	movq	48(%rax), %rax
	jmp	.L286
.L285:
	movq	sp4.58(%rip), %rax
.L286:
	movq	%rax, -96(%rbp)
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L287
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.63(%rip), %rax
	cmpq	%rax, %rdx
	je	.L288
.L287:
	movq	-48(%rbp), %rax
	movq	56(%rax), %rax
	jmp	.L289
.L288:
	movq	sp5.57(%rip), %rax
.L289:
	movq	%rax, %r10
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L290
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.63(%rip), %rax
	cmpq	%rax, %rdx
	je	.L291
.L290:
	movq	-48(%rbp), %rax
	movq	64(%rax), %rax
	jmp	.L292
.L291:
	movq	sp6.56(%rip), %rax
.L292:
	movq	%rax, -104(%rbp)
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L293
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.63(%rip), %rax
	cmpq	%rax, %rdx
	je	.L294
.L293:
	movq	-48(%rbp), %rax
	movq	72(%rax), %rax
	jmp	.L295
.L294:
	movq	sp7.55(%rip), %rax
.L295:
	movq	%rax, -112(%rbp)
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L296
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.63(%rip), %rax
	cmpq	%rax, %rdx
	je	.L297
.L296:
	movq	-48(%rbp), %rax
	movq	80(%rax), %rax
	jmp	.L298
.L297:
	movq	sp8.54(%rip), %rax
.L298:
	movq	%rax, %r15
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L299
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.63(%rip), %rax
	cmpq	%rax, %rdx
	je	.L300
.L299:
	movq	-48(%rbp), %rax
	movq	88(%rax), %rax
	jmp	.L301
.L300:
	movq	sp9.53(%rip), %rax
.L301:
	movq	%rax, %r14
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L302
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.63(%rip), %rax
	cmpq	%rax, %rdx
	je	.L303
.L302:
	movq	-48(%rbp), %rax
	movq	96(%rax), %rax
	jmp	.L304
.L303:
	movq	sp10.52(%rip), %rax
.L304:
	movq	%rax, %r13
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L305
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.63(%rip), %rax
	cmpq	%rax, %rdx
	je	.L306
.L305:
	movq	-48(%rbp), %rax
	movq	104(%rax), %rax
	jmp	.L307
.L306:
	movq	sp11.51(%rip), %rax
.L307:
	movq	%rax, %r12
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L308
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.63(%rip), %rax
	cmpq	%rax, %rdx
	je	.L309
.L308:
	movq	-48(%rbp), %rax
	movq	112(%rax), %rax
	jmp	.L310
.L309:
	movq	sp12.50(%rip), %rax
.L310:
	movq	%rax, %rbx
	jmp	.L311
.L312:
	movq	%r11, %rax
	movq	(%rax), %rax
	movq	%rsi, %rcx
	movq	(%rcx), %rsi
	movq	-80(%rbp), %rdi
	movq	(%rdi), %rcx
	movq	-88(%rbp), %rdi
	movq	(%rdi), %rdi
	movq	-96(%rbp), %rdx
	movq	(%rdx), %rdx
	movq	%r10, %r8
	movq	(%r8), %r9
	movq	-104(%rbp), %r10
	movq	(%r10), %r11
	movq	-112(%rbp), %r8
	movq	(%r8), %r10
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r8
	movq	(%r11), %r9
	movq	(%r10), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r8), %r10
	movq	(%r9), %r8
	movq	(%r11), %r9
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r10), %r11
	movq	(%r8), %r10
	movq	(%r9), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r11), %r9
	movq	(%r10), %r11
	movq	(%r8), %r10
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r8
	movq	(%r11), %r9
	movq	(%r10), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r8), %r10
	movq	(%r9), %r8
	movq	(%r11), %r9
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r10), %r11
	movq	(%r8), %r10
	movq	(%r9), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r11), %r9
	movq	(%r10), %r11
	movq	(%r8), %r10
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r8
	movq	(%r11), %r9
	movq	(%r10), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r8), %r10
	movq	(%r9), %r8
	movq	(%r11), %r9
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r10), %r11
	movq	(%r8), %r10
	movq	(%r9), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r11), %r9
	movq	(%r10), %r11
	movq	(%r8), %r10
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r8
	movq	(%r11), %r9
	movq	(%r10), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r8), %r10
	movq	(%r9), %r8
	movq	(%r11), %r9
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r10), %r11
	movq	(%r8), %r10
	movq	(%r9), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r11), %r9
	movq	(%r10), %r11
	movq	(%r8), %r10
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r8
	movq	(%r11), %r9
	movq	(%r10), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r8), %r10
	movq	(%r9), %r8
	movq	(%r11), %r9
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r10), %r11
	movq	(%r8), %r10
	movq	(%r9), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r11), %r9
	movq	(%r10), %r11
	movq	(%r8), %r10
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r8
	movq	(%r11), %r9
	movq	(%r10), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r8), %r10
	movq	(%r9), %r8
	movq	(%r11), %r9
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r10), %r11
	movq	(%r8), %r10
	movq	(%r9), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r11), %r9
	movq	(%r10), %r11
	movq	(%r8), %r10
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r8
	movq	(%r11), %r9
	movq	(%r10), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r8), %r10
	movq	(%r9), %r8
	movq	(%r11), %r9
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r10), %r11
	movq	(%r8), %r10
	movq	(%r9), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r11), %r9
	movq	(%r10), %r11
	movq	(%r8), %r10
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r8
	movq	(%r11), %r9
	movq	(%r10), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r8), %r10
	movq	(%r9), %r8
	movq	(%r11), %r9
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r10), %r11
	movq	(%r8), %r10
	movq	(%r9), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r11), %r9
	movq	(%r10), %r11
	movq	(%r8), %r10
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r8
	movq	(%r11), %r9
	movq	(%r10), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r8), %r10
	movq	(%r9), %r8
	movq	(%r11), %r9
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r10), %r11
	movq	(%r8), %r10
	movq	(%r9), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r11), %r9
	movq	(%r10), %r11
	movq	(%r8), %r10
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r8
	movq	(%r11), %r9
	movq	(%r10), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r8), %r10
	movq	(%r9), %r8
	movq	(%r11), %r9
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r10), %r11
	movq	(%r8), %r10
	movq	(%r9), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r11), %r9
	movq	(%r10), %r11
	movq	(%r8), %r10
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r8
	movq	(%r11), %r9
	movq	(%r10), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r8), %r10
	movq	(%r9), %r8
	movq	(%r11), %r9
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r10), %r11
	movq	(%r8), %r10
	movq	(%r9), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r11), %r9
	movq	(%r10), %r11
	movq	(%r8), %r10
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r8
	movq	(%r11), %r9
	movq	(%r10), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r8), %r10
	movq	(%r9), %r8
	movq	(%r11), %r9
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r10), %r11
	movq	(%r8), %r10
	movq	(%r9), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r11), %r9
	movq	(%r10), %r11
	movq	(%r8), %r10
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r8
	movq	(%r11), %r9
	movq	(%r10), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r8), %r10
	movq	(%r9), %r8
	movq	(%r11), %r9
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r10), %r11
	movq	(%r8), %r10
	movq	(%r9), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r11), %r9
	movq	(%r10), %r11
	movq	(%r8), %r10
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r8
	movq	(%r11), %r9
	movq	(%r10), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r8), %r10
	movq	(%r9), %r8
	movq	(%r11), %r9
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r10), %r11
	movq	(%r8), %r10
	movq	(%r9), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r11), %r9
	movq	(%r10), %r11
	movq	(%r8), %r10
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r8
	movq	(%r11), %r9
	movq	(%r10), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r8), %r10
	movq	(%r9), %r8
	movq	(%r11), %r9
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r10), %r11
	movq	(%r8), %r10
	movq	(%r9), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r11), %r9
	movq	(%r10), %r11
	movq	(%r8), %r10
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r8
	movq	(%r11), %r9
	movq	(%r10), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r8), %r10
	movq	(%r9), %r8
	movq	(%r11), %r9
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r10), %r11
	movq	(%r8), %r10
	movq	(%r9), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r11), %r9
	movq	(%r10), %r11
	movq	(%r8), %r10
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r8
	movq	(%r11), %r9
	movq	(%r10), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r8), %r10
	movq	(%r9), %r8
	movq	(%r11), %r9
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r10), %r11
	movq	(%r8), %r10
	movq	(%r9), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r11), %r9
	movq	(%r10), %r11
	movq	(%r8), %r10
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r8
	movq	(%r11), %r9
	movq	(%r10), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r8), %r10
	movq	(%r9), %r8
	movq	(%r11), %r9
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r10), %r11
	movq	(%r8), %r10
	movq	(%r9), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r11), %r9
	movq	(%r10), %r11
	movq	(%r8), %r10
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r8
	movq	(%r11), %r9
	movq	(%r10), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r8), %r10
	movq	(%r9), %r8
	movq	(%r11), %r9
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r10), %r11
	movq	(%r8), %r10
	movq	(%r9), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r11), %r9
	movq	(%r10), %r11
	movq	(%r8), %r10
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r8
	movq	(%r11), %r9
	movq	(%r10), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r8), %r10
	movq	(%r9), %r8
	movq	(%r11), %r9
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r10), %r11
	movq	(%r8), %r10
	movq	(%r9), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r11), %r9
	movq	(%r10), %r11
	movq	(%r8), %r10
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r8
	movq	(%r11), %r9
	movq	(%r10), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r8), %r10
	movq	(%r9), %r8
	movq	(%r11), %r9
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r10), %r11
	movq	(%r8), %r10
	movq	(%r9), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r11), %r9
	movq	(%r10), %r11
	movq	(%r8), %r10
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r8
	movq	(%r11), %r9
	movq	(%r10), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r8), %r10
	movq	(%r9), %r8
	movq	(%r11), %r9
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r10), %r11
	movq	(%r8), %r10
	movq	(%r9), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r11), %r9
	movq	(%r10), %r11
	movq	(%r8), %r10
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r8
	movq	(%r11), %r9
	movq	(%r10), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r8), %r10
	movq	(%r9), %r8
	movq	(%r11), %r9
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r10), %r11
	movq	(%r8), %r10
	movq	(%r9), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r11), %r9
	movq	(%r10), %r11
	movq	(%r8), %r10
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r8
	movq	(%r11), %r9
	movq	(%r10), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r8), %r10
	movq	(%r9), %r8
	movq	(%r11), %r9
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r10), %r11
	movq	(%r8), %r10
	movq	(%r9), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r11), %r9
	movq	(%r10), %r11
	movq	(%r8), %r10
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r8
	movq	(%r11), %r9
	movq	(%r10), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r8), %r10
	movq	(%r9), %r8
	movq	(%r11), %r9
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	%rax, %r11
	movq	(%rsi), %rax
	movq	%rax, %rsi
	movq	(%rcx), %rax
	movq	%rax, -80(%rbp)
	movq	(%rdi), %rax
	movq	%rax, -88(%rbp)
	movq	(%rdx), %rax
	movq	%rax, -96(%rbp)
	movq	(%r10), %rax
	movq	%rax, %r10
	movq	(%r8), %rax
	movq	%rax, -104(%rbp)
	movq	(%r9), %rax
	movq	%rax, -112(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
.L311:
	movq	-64(%rbp), %rax
	leaq	-1(%rax), %rdx
	movq	%rdx, -64(%rbp)
	testq	%rax, %rax
	jne	.L312
	movq	%r11, %rax
	movq	%rax, sp0.62(%rip)
	movq	%rsi, %rax
	movq	%rax, sp1.61(%rip)
	movq	-80(%rbp), %rax
	movq	%rax, sp2.60(%rip)
	movq	-88(%rbp), %rax
	movq	%rax, sp3.59(%rip)
	movq	-96(%rbp), %rax
	movq	%rax, sp4.58(%rip)
	movq	%r10, %rax
	movq	%rax, sp5.57(%rip)
	movq	-104(%rbp), %rax
	movq	%rax, sp6.56(%rip)
	movq	-112(%rbp), %rax
	movq	%rax, sp7.55(%rip)
	movq	%r15, sp8.54(%rip)
	movq	%r14, sp9.53(%rip)
	movq	%r13, sp10.52(%rip)
	movq	%r12, sp11.51(%rip)
	movq	%rbx, sp12.50(%rip)
	movq	-48(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, addr_save.63(%rip)
	movl	$1, mem_benchmark_rerun(%rip)
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE20:
	.size	mem_benchmark_12, .-mem_benchmark_12
	.globl	mem_benchmark_13
	.type	mem_benchmark_13, @function
mem_benchmark_13:
.LFB21:
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
	movq	%rsi, -72(%rbp)
	movq	-72(%rbp), %rax
	movq	%rax, -48(%rbp)
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L314
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.49(%rip), %rax
	cmpq	%rax, %rdx
	je	.L315
.L314:
	movq	-48(%rbp), %rax
	movq	16(%rax), %rax
	jmp	.L316
.L315:
	movq	sp0.48(%rip), %rax
.L316:
	movq	%rax, -80(%rbp)
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L317
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.49(%rip), %rax
	cmpq	%rax, %rdx
	je	.L318
.L317:
	movq	-48(%rbp), %rax
	movq	24(%rax), %rax
	jmp	.L319
.L318:
	movq	sp1.47(%rip), %rax
.L319:
	movq	%rax, %rsi
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L320
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.49(%rip), %rax
	cmpq	%rax, %rdx
	je	.L321
.L320:
	movq	-48(%rbp), %rax
	movq	32(%rax), %rax
	jmp	.L322
.L321:
	movq	sp2.46(%rip), %rax
.L322:
	movq	%rax, -88(%rbp)
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L323
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.49(%rip), %rax
	cmpq	%rax, %rdx
	je	.L324
.L323:
	movq	-48(%rbp), %rax
	movq	40(%rax), %rax
	jmp	.L325
.L324:
	movq	sp3.45(%rip), %rax
.L325:
	movq	%rax, -96(%rbp)
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L326
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.49(%rip), %rax
	cmpq	%rax, %rdx
	je	.L327
.L326:
	movq	-48(%rbp), %rax
	movq	48(%rax), %rax
	jmp	.L328
.L327:
	movq	sp4.44(%rip), %rax
.L328:
	movq	%rax, -104(%rbp)
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L329
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.49(%rip), %rax
	cmpq	%rax, %rdx
	je	.L330
.L329:
	movq	-48(%rbp), %rax
	movq	56(%rax), %rax
	jmp	.L331
.L330:
	movq	sp5.43(%rip), %rax
.L331:
	movq	%rax, %r9
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L332
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.49(%rip), %rax
	cmpq	%rax, %rdx
	je	.L333
.L332:
	movq	-48(%rbp), %rax
	movq	64(%rax), %rax
	jmp	.L334
.L333:
	movq	sp6.42(%rip), %rax
.L334:
	movq	%rax, %r11
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L335
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.49(%rip), %rax
	cmpq	%rax, %rdx
	je	.L336
.L335:
	movq	-48(%rbp), %rax
	movq	72(%rax), %rax
	jmp	.L337
.L336:
	movq	sp7.41(%rip), %rax
.L337:
	movq	%rax, -112(%rbp)
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L338
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.49(%rip), %rax
	cmpq	%rax, %rdx
	je	.L339
.L338:
	movq	-48(%rbp), %rax
	movq	80(%rax), %rax
	jmp	.L340
.L339:
	movq	sp8.40(%rip), %rax
.L340:
	movq	%rax, -120(%rbp)
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L341
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.49(%rip), %rax
	cmpq	%rax, %rdx
	je	.L342
.L341:
	movq	-48(%rbp), %rax
	movq	88(%rax), %rax
	jmp	.L343
.L342:
	movq	sp9.39(%rip), %rax
.L343:
	movq	%rax, %r15
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L344
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.49(%rip), %rax
	cmpq	%rax, %rdx
	je	.L345
.L344:
	movq	-48(%rbp), %rax
	movq	96(%rax), %rax
	jmp	.L346
.L345:
	movq	sp10.38(%rip), %rax
.L346:
	movq	%rax, %r14
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L347
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.49(%rip), %rax
	cmpq	%rax, %rdx
	je	.L348
.L347:
	movq	-48(%rbp), %rax
	movq	104(%rax), %rax
	jmp	.L349
.L348:
	movq	sp11.37(%rip), %rax
.L349:
	movq	%rax, %r13
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L350
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.49(%rip), %rax
	cmpq	%rax, %rdx
	je	.L351
.L350:
	movq	-48(%rbp), %rax
	movq	112(%rax), %rax
	jmp	.L352
.L351:
	movq	sp12.36(%rip), %rax
.L352:
	movq	%rax, %r12
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L353
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.49(%rip), %rax
	cmpq	%rax, %rdx
	je	.L354
.L353:
	movq	-48(%rbp), %rax
	movq	120(%rax), %rax
	jmp	.L355
.L354:
	movq	sp13.35(%rip), %rax
.L355:
	movq	%rax, %rbx
	jmp	.L356
.L357:
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rsi, %rcx
	movq	(%rcx), %rsi
	movq	-88(%rbp), %rdi
	movq	(%rdi), %rcx
	movq	-96(%rbp), %rdi
	movq	(%rdi), %rdi
	movq	-104(%rbp), %rdx
	movq	(%rdx), %rdx
	movq	%r9, %r8
	movq	(%r8), %r9
	movq	%r11, %r10
	movq	(%r10), %r11
	movq	-112(%rbp), %r8
	movq	(%r8), %r10
	movq	-120(%rbp), %r8
	movq	(%r8), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rax
	movq	%rax, %rsi
	movq	(%rcx), %rax
	movq	%rax, -88(%rbp)
	movq	(%rdi), %rax
	movq	%rax, -96(%rbp)
	movq	(%rdx), %rax
	movq	%rax, -104(%rbp)
	movq	(%r9), %rax
	movq	%rax, %r9
	movq	(%r11), %rax
	movq	%rax, %r11
	movq	(%r10), %rax
	movq	%rax, -112(%rbp)
	movq	(%r8), %rax
	movq	%rax, -120(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
.L356:
	movq	-64(%rbp), %rdx
	leaq	-1(%rdx), %rax
	movq	%rax, -64(%rbp)
	testq	%rdx, %rdx
	jne	.L357
	movq	-80(%rbp), %rax
	movq	%rax, sp0.48(%rip)
	movq	%rsi, %rax
	movq	%rax, sp1.47(%rip)
	movq	-88(%rbp), %rax
	movq	%rax, sp2.46(%rip)
	movq	-96(%rbp), %rax
	movq	%rax, sp3.45(%rip)
	movq	-104(%rbp), %rax
	movq	%rax, sp4.44(%rip)
	movq	%r9, %rax
	movq	%rax, sp5.43(%rip)
	movq	%r11, %rax
	movq	%rax, sp6.42(%rip)
	movq	-112(%rbp), %rax
	movq	%rax, sp7.41(%rip)
	movq	-120(%rbp), %rax
	movq	%rax, sp8.40(%rip)
	movq	%r15, sp9.39(%rip)
	movq	%r14, sp10.38(%rip)
	movq	%r13, sp11.37(%rip)
	movq	%r12, sp12.36(%rip)
	movq	%rbx, sp13.35(%rip)
	movq	-48(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, addr_save.49(%rip)
	movl	$1, mem_benchmark_rerun(%rip)
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE21:
	.size	mem_benchmark_13, .-mem_benchmark_13
	.globl	mem_benchmark_14
	.type	mem_benchmark_14, @function
mem_benchmark_14:
.LFB22:
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
	movq	%rsi, -72(%rbp)
	movq	-72(%rbp), %rax
	movq	%rax, -48(%rbp)
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L359
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.34(%rip), %rax
	cmpq	%rax, %rdx
	je	.L360
.L359:
	movq	-48(%rbp), %rax
	movq	16(%rax), %rax
	jmp	.L361
.L360:
	movq	sp0.33(%rip), %rax
.L361:
	movq	%rax, -80(%rbp)
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L362
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.34(%rip), %rax
	cmpq	%rax, %rdx
	je	.L363
.L362:
	movq	-48(%rbp), %rax
	movq	24(%rax), %rax
	jmp	.L364
.L363:
	movq	sp1.32(%rip), %rax
.L364:
	movq	%rax, -96(%rbp)
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L365
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.34(%rip), %rax
	cmpq	%rax, %rdx
	je	.L366
.L365:
	movq	-48(%rbp), %rax
	movq	32(%rax), %rax
	jmp	.L367
.L366:
	movq	sp2.31(%rip), %rax
.L367:
	movq	%rax, -104(%rbp)
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L368
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.34(%rip), %rax
	cmpq	%rax, %rdx
	je	.L369
.L368:
	movq	-48(%rbp), %rax
	movq	40(%rax), %rax
	jmp	.L370
.L369:
	movq	sp3.30(%rip), %rax
.L370:
	movq	%rax, -112(%rbp)
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L371
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.34(%rip), %rax
	cmpq	%rax, %rdx
	je	.L372
.L371:
	movq	-48(%rbp), %rax
	movq	48(%rax), %rax
	jmp	.L373
.L372:
	movq	sp4.29(%rip), %rax
.L373:
	movq	%rax, -120(%rbp)
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L374
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.34(%rip), %rax
	cmpq	%rax, %rdx
	je	.L375
.L374:
	movq	-48(%rbp), %rax
	movq	56(%rax), %rax
	jmp	.L376
.L375:
	movq	sp5.28(%rip), %rax
.L376:
	movq	%rax, %r9
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L377
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.34(%rip), %rax
	cmpq	%rax, %rdx
	je	.L378
.L377:
	movq	-48(%rbp), %rax
	movq	64(%rax), %rax
	jmp	.L379
.L378:
	movq	sp6.27(%rip), %rax
.L379:
	movq	%rax, %r11
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L380
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.34(%rip), %rax
	cmpq	%rax, %rdx
	je	.L381
.L380:
	movq	-48(%rbp), %rax
	movq	72(%rax), %rax
	jmp	.L382
.L381:
	movq	sp7.26(%rip), %rax
.L382:
	movq	%rax, -128(%rbp)
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L383
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.34(%rip), %rax
	cmpq	%rax, %rdx
	je	.L384
.L383:
	movq	-48(%rbp), %rax
	movq	80(%rax), %rax
	jmp	.L385
.L384:
	movq	sp8.25(%rip), %rax
.L385:
	movq	%rax, -136(%rbp)
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L386
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.34(%rip), %rax
	cmpq	%rax, %rdx
	je	.L387
.L386:
	movq	-48(%rbp), %rax
	movq	88(%rax), %rax
	jmp	.L388
.L387:
	movq	sp9.24(%rip), %rax
.L388:
	movq	%rax, -88(%rbp)
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L389
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.34(%rip), %rax
	cmpq	%rax, %rdx
	je	.L390
.L389:
	movq	-48(%rbp), %rax
	movq	96(%rax), %rax
	jmp	.L391
.L390:
	movq	sp10.23(%rip), %rax
.L391:
	movq	%rax, %r15
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L392
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.34(%rip), %rax
	cmpq	%rax, %rdx
	je	.L393
.L392:
	movq	-48(%rbp), %rax
	movq	104(%rax), %rax
	jmp	.L394
.L393:
	movq	sp11.22(%rip), %rax
.L394:
	movq	%rax, %r14
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L395
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.34(%rip), %rax
	cmpq	%rax, %rdx
	je	.L396
.L395:
	movq	-48(%rbp), %rax
	movq	112(%rax), %rax
	jmp	.L397
.L396:
	movq	sp12.21(%rip), %rax
.L397:
	movq	%rax, %r13
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L398
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.34(%rip), %rax
	cmpq	%rax, %rdx
	je	.L399
.L398:
	movq	-48(%rbp), %rax
	movq	120(%rax), %rax
	jmp	.L400
.L399:
	movq	sp13.20(%rip), %rax
.L400:
	movq	%rax, %r12
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L401
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.34(%rip), %rax
	cmpq	%rax, %rdx
	je	.L402
.L401:
	movq	-48(%rbp), %rax
	movq	128(%rax), %rax
	jmp	.L403
.L402:
	movq	sp14.19(%rip), %rax
.L403:
	movq	%rax, %rbx
	jmp	.L404
.L405:
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	-96(%rbp), %rcx
	movq	(%rcx), %rsi
	movq	-104(%rbp), %rdi
	movq	(%rdi), %rcx
	movq	-112(%rbp), %rdi
	movq	(%rdi), %rdi
	movq	-120(%rbp), %rdx
	movq	(%rdx), %rdx
	movq	%r9, %r8
	movq	(%r8), %r9
	movq	%r11, %r10
	movq	(%r10), %r11
	movq	-128(%rbp), %r8
	movq	(%r8), %r10
	movq	-136(%rbp), %r8
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	%rsi, -96(%rbp)
	movq	(%rcx), %rcx
	movq	%rcx, -104(%rbp)
	movq	(%rdi), %rsi
	movq	%rsi, -112(%rbp)
	movq	(%rdx), %rcx
	movq	%rcx, -120(%rbp)
	movq	(%r9), %rsi
	movq	%rsi, %r9
	movq	(%r11), %rdi
	movq	%rdi, %r11
	movq	(%r10), %rcx
	movq	%rcx, -128(%rbp)
	movq	(%r8), %rsi
	movq	%rsi, -136(%rbp)
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
.L404:
	movq	-64(%rbp), %rdx
	leaq	-1(%rdx), %rax
	movq	%rax, -64(%rbp)
	testq	%rdx, %rdx
	jne	.L405
	movq	-80(%rbp), %rax
	movq	%rax, sp0.33(%rip)
	movq	-96(%rbp), %rax
	movq	%rax, sp1.32(%rip)
	movq	-104(%rbp), %rax
	movq	%rax, sp2.31(%rip)
	movq	-112(%rbp), %rax
	movq	%rax, sp3.30(%rip)
	movq	-120(%rbp), %rax
	movq	%rax, sp4.29(%rip)
	movq	%r9, %rax
	movq	%rax, sp5.28(%rip)
	movq	%r11, %rax
	movq	%rax, sp6.27(%rip)
	movq	-128(%rbp), %rax
	movq	%rax, sp7.26(%rip)
	movq	-136(%rbp), %rax
	movq	%rax, sp8.25(%rip)
	movq	-88(%rbp), %rax
	movq	%rax, sp9.24(%rip)
	movq	%r15, sp10.23(%rip)
	movq	%r14, sp11.22(%rip)
	movq	%r13, sp12.21(%rip)
	movq	%r12, sp13.20(%rip)
	movq	%rbx, sp14.19(%rip)
	movq	-48(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, addr_save.34(%rip)
	movl	$1, mem_benchmark_rerun(%rip)
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE22:
	.size	mem_benchmark_14, .-mem_benchmark_14
	.globl	mem_benchmark_15
	.type	mem_benchmark_15, @function
mem_benchmark_15:
.LFB23:
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
	movq	%rsi, -72(%rbp)
	movq	-72(%rbp), %rax
	movq	%rax, -48(%rbp)
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L407
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.18(%rip), %rax
	cmpq	%rax, %rdx
	je	.L408
.L407:
	movq	-48(%rbp), %rax
	movq	16(%rax), %rax
	jmp	.L409
.L408:
	movq	sp0.17(%rip), %rax
.L409:
	movq	%rax, -80(%rbp)
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L410
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.18(%rip), %rax
	cmpq	%rax, %rdx
	je	.L411
.L410:
	movq	-48(%rbp), %rax
	movq	24(%rax), %rax
	jmp	.L412
.L411:
	movq	sp1.16(%rip), %rax
.L412:
	movq	%rax, -104(%rbp)
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L413
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.18(%rip), %rax
	cmpq	%rax, %rdx
	je	.L414
.L413:
	movq	-48(%rbp), %rax
	movq	32(%rax), %rax
	jmp	.L415
.L414:
	movq	sp2.15(%rip), %rax
.L415:
	movq	%rax, -112(%rbp)
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L416
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.18(%rip), %rax
	cmpq	%rax, %rdx
	je	.L417
.L416:
	movq	-48(%rbp), %rax
	movq	40(%rax), %rax
	jmp	.L418
.L417:
	movq	sp3.14(%rip), %rax
.L418:
	movq	%rax, -120(%rbp)
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L419
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.18(%rip), %rax
	cmpq	%rax, %rdx
	je	.L420
.L419:
	movq	-48(%rbp), %rax
	movq	48(%rax), %rax
	jmp	.L421
.L420:
	movq	sp4.13(%rip), %rax
.L421:
	movq	%rax, -128(%rbp)
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L422
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.18(%rip), %rax
	cmpq	%rax, %rdx
	je	.L423
.L422:
	movq	-48(%rbp), %rax
	movq	56(%rax), %rax
	jmp	.L424
.L423:
	movq	sp5.12(%rip), %rax
.L424:
	movq	%rax, %r9
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L425
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.18(%rip), %rax
	cmpq	%rax, %rdx
	je	.L426
.L425:
	movq	-48(%rbp), %rax
	movq	64(%rax), %rax
	jmp	.L427
.L426:
	movq	sp6.11(%rip), %rax
.L427:
	movq	%rax, %r11
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L428
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.18(%rip), %rax
	cmpq	%rax, %rdx
	je	.L429
.L428:
	movq	-48(%rbp), %rax
	movq	72(%rax), %rax
	jmp	.L430
.L429:
	movq	sp7.10(%rip), %rax
.L430:
	movq	%rax, -136(%rbp)
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L431
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.18(%rip), %rax
	cmpq	%rax, %rdx
	je	.L432
.L431:
	movq	-48(%rbp), %rax
	movq	80(%rax), %rax
	jmp	.L433
.L432:
	movq	sp8.9(%rip), %rax
.L433:
	movq	%rax, -144(%rbp)
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L434
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.18(%rip), %rax
	cmpq	%rax, %rdx
	je	.L435
.L434:
	movq	-48(%rbp), %rax
	movq	88(%rax), %rax
	jmp	.L436
.L435:
	movq	sp9.8(%rip), %rax
.L436:
	movq	%rax, -88(%rbp)
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L437
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.18(%rip), %rax
	cmpq	%rax, %rdx
	je	.L438
.L437:
	movq	-48(%rbp), %rax
	movq	96(%rax), %rax
	jmp	.L439
.L438:
	movq	sp10.7(%rip), %rax
.L439:
	movq	%rax, -96(%rbp)
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L440
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.18(%rip), %rax
	cmpq	%rax, %rdx
	je	.L441
.L440:
	movq	-48(%rbp), %rax
	movq	104(%rax), %rax
	jmp	.L442
.L441:
	movq	sp11.6(%rip), %rax
.L442:
	movq	%rax, %r15
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L443
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.18(%rip), %rax
	cmpq	%rax, %rdx
	je	.L444
.L443:
	movq	-48(%rbp), %rax
	movq	112(%rax), %rax
	jmp	.L445
.L444:
	movq	sp12.5(%rip), %rax
.L445:
	movq	%rax, %r14
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L446
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.18(%rip), %rax
	cmpq	%rax, %rdx
	je	.L447
.L446:
	movq	-48(%rbp), %rax
	movq	120(%rax), %rax
	jmp	.L448
.L447:
	movq	sp13.4(%rip), %rax
.L448:
	movq	%rax, %r13
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L449
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.18(%rip), %rax
	cmpq	%rax, %rdx
	je	.L450
.L449:
	movq	-48(%rbp), %rax
	movq	128(%rax), %rax
	jmp	.L451
.L450:
	movq	sp14.3(%rip), %rax
.L451:
	movq	%rax, %r12
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L452
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	addr_save.18(%rip), %rax
	cmpq	%rax, %rdx
	je	.L453
.L452:
	movq	-48(%rbp), %rax
	movq	136(%rax), %rax
	jmp	.L454
.L453:
	movq	sp15.2(%rip), %rax
.L454:
	movq	%rax, %rbx
	jmp	.L455
.L456:
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	-104(%rbp), %rcx
	movq	(%rcx), %rsi
	movq	-112(%rbp), %rdi
	movq	(%rdi), %rcx
	movq	-120(%rbp), %rdi
	movq	(%rdi), %rdi
	movq	-128(%rbp), %rdx
	movq	(%rdx), %rdx
	movq	%r9, %r8
	movq	(%r8), %r9
	movq	%r11, %r10
	movq	(%r10), %r11
	movq	-136(%rbp), %r8
	movq	(%r8), %r10
	movq	-144(%rbp), %r8
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%r9), %r9
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r8), %r8
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	(%rsi), %rsi
	movq	%rsi, -104(%rbp)
	movq	(%rcx), %rcx
	movq	%rcx, -112(%rbp)
	movq	(%rdi), %rsi
	movq	%rsi, -120(%rbp)
	movq	(%rdx), %rcx
	movq	%rcx, -128(%rbp)
	movq	(%r9), %rsi
	movq	%rsi, %r9
	movq	(%r11), %rdi
	movq	%rdi, %r11
	movq	(%r10), %rcx
	movq	%rcx, -136(%rbp)
	movq	(%r8), %rsi
	movq	%rsi, -144(%rbp)
	movq	-88(%rbp), %rax
	movq	(%rax), %rdi
	movq	%rdi, -88(%rbp)
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -96(%rbp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	(%rbx), %rbx
.L455:
	movq	-64(%rbp), %rdx
	leaq	-1(%rdx), %rax
	movq	%rax, -64(%rbp)
	testq	%rdx, %rdx
	jne	.L456
	movq	-80(%rbp), %rax
	movq	%rax, sp0.17(%rip)
	movq	-104(%rbp), %rax
	movq	%rax, sp1.16(%rip)
	movq	-112(%rbp), %rax
	movq	%rax, sp2.15(%rip)
	movq	-120(%rbp), %rax
	movq	%rax, sp3.14(%rip)
	movq	-128(%rbp), %rax
	movq	%rax, sp4.13(%rip)
	movq	%r9, %rax
	movq	%rax, sp5.12(%rip)
	movq	%r11, %rax
	movq	%rax, sp6.11(%rip)
	movq	-136(%rbp), %rax
	movq	%rax, sp7.10(%rip)
	movq	-144(%rbp), %rax
	movq	%rax, sp8.9(%rip)
	movq	-88(%rbp), %rax
	movq	%rax, sp9.8(%rip)
	movq	-96(%rbp), %rax
	movq	%rax, sp10.7(%rip)
	movq	%r15, sp11.6(%rip)
	movq	%r14, sp12.5(%rip)
	movq	%r13, sp13.4(%rip)
	movq	%r12, sp14.3(%rip)
	movq	%rbx, sp15.2(%rip)
	movq	-48(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, addr_save.18(%rip)
	movl	$1, mem_benchmark_rerun(%rip)
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE23:
	.size	mem_benchmark_15, .-mem_benchmark_15
	.globl	mem_reset
	.type	mem_reset, @function
mem_reset:
.LFB24:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	$0, mem_benchmark_rerun(%rip)
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE24:
	.size	mem_reset, .-mem_reset
	.globl	mem_cleanup
	.type	mem_cleanup, @function
mem_cleanup:
.LFB25:
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
	jne	.L464
	movq	-8(%rbp), %rax
	movq	(%rax), %rax
	testq	%rax, %rax
	je	.L461
	movq	-8(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	free@PLT
	movq	-8(%rbp), %rax
	movq	$0, (%rax)
.L461:
	movq	-8(%rbp), %rax
	movq	216(%rax), %rax
	testq	%rax, %rax
	je	.L462
	movq	-8(%rbp), %rax
	movq	216(%rax), %rax
	movq	%rax, %rdi
	call	free@PLT
	movq	-8(%rbp), %rax
	movq	$0, 216(%rax)
.L462:
	movq	-8(%rbp), %rax
	movq	208(%rax), %rax
	testq	%rax, %rax
	je	.L463
	movq	-8(%rbp), %rax
	movq	208(%rax), %rax
	movq	%rax, %rdi
	call	free@PLT
	movq	-8(%rbp), %rax
	movq	$0, 208(%rax)
.L463:
	movq	-8(%rbp), %rax
	movq	224(%rax), %rax
	testq	%rax, %rax
	je	.L458
	movq	-8(%rbp), %rax
	movq	224(%rax), %rax
	movq	%rax, %rdi
	call	free@PLT
	movq	-8(%rbp), %rax
	movq	$0, 224(%rax)
	jmp	.L458
.L464:
	nop
.L458:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE25:
	.size	mem_cleanup, .-mem_cleanup
	.globl	tlb_cleanup
	.type	tlb_cleanup, @function
tlb_cleanup:
.LFB26:
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
	movq	-16(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -8(%rbp)
	cmpq	$0, -40(%rbp)
	jne	.L473
	cmpq	$0, -8(%rbp)
	je	.L468
	movq	$0, -24(%rbp)
	jmp	.L469
.L471:
	movq	-24(%rbp), %rax
	leaq	0(,%rax,8), %rdx
	movq	-8(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	testq	%rax, %rax
	je	.L470
	movq	-24(%rbp), %rax
	leaq	0(,%rax,8), %rdx
	movq	-8(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	free@PLT
.L470:
	addq	$1, -24(%rbp)
.L469:
	movq	-16(%rbp), %rax
	movq	192(%rax), %rax
	cmpq	%rax, -24(%rbp)
	jb	.L471
	movq	-8(%rbp), %rax
	movq	%rax, %rdi
	call	free@PLT
	movq	-16(%rbp), %rax
	movq	$0, (%rax)
.L468:
	movq	-16(%rbp), %rax
	movq	208(%rax), %rax
	testq	%rax, %rax
	je	.L472
	movq	-16(%rbp), %rax
	movq	208(%rax), %rax
	movq	%rax, %rdi
	call	free@PLT
	movq	-16(%rbp), %rax
	movq	$0, 208(%rax)
.L472:
	movq	-16(%rbp), %rax
	movq	216(%rax), %rax
	testq	%rax, %rax
	je	.L465
	movq	-16(%rbp), %rax
	movq	216(%rax), %rax
	movq	%rax, %rdi
	call	free@PLT
	movq	-16(%rbp), %rax
	movq	$0, 216(%rax)
	jmp	.L465
.L473:
	nop
.L465:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE26:
	.size	tlb_cleanup, .-tlb_cleanup
	.section	.rodata
.LC0:
	.string	"base_initialize: malloc"
	.text
	.globl	base_initialize
	.type	base_initialize, @function
base_initialize:
.LFB27:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%rbx
	subq	$104, %rsp
	.cfi_offset 3, -24
	movq	%rdi, -104(%rbp)
	movq	%rsi, -112(%rbp)
	movq	-112(%rbp), %rax
	movq	%rax, -88(%rbp)
	cmpq	$0, -104(%rbp)
	jne	.L481
	movq	-88(%rbp), %rax
	movl	$0, 144(%rax)
	movq	-88(%rbp), %rax
	movq	152(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	-88(%rbp), %rax
	movq	168(%rax), %rax
	shrq	$3, %rax
	movq	%rax, -72(%rbp)
	movq	-88(%rbp), %rax
	movq	176(%rax), %rax
	movq	-88(%rbp), %rdx
	movq	168(%rdx), %rsi
	movl	$0, %edx
	divq	%rsi
	movq	%rax, -64(%rbp)
	movq	-88(%rbp), %rax
	movq	176(%rax), %rdx
	movq	-80(%rbp), %rax
	addq	%rdx, %rax
	leaq	-1(%rax), %rcx
	movq	-88(%rbp), %rax
	movq	176(%rax), %rsi
	movq	%rcx, %rax
	movl	$0, %edx
	divq	%rsi
	movq	%rax, -56(%rbp)
	movq	-88(%rbp), %rax
	movq	160(%rax), %rdx
	movq	-88(%rbp), %rax
	movq	176(%rax), %rax
	addq	%rdx, %rax
	leaq	-1(%rax), %rcx
	movq	-88(%rbp), %rax
	movq	176(%rax), %rdi
	movq	%rcx, %rax
	movl	$0, %edx
	divq	%rdi
	movq	%rax, -48(%rbp)
	call	getpid@PLT
	movl	%eax, %edi
	call	srand@PLT
	movq	$0, -40(%rbp)
	movq	$0, -32(%rbp)
	movq	-88(%rbp), %rax
	movq	176(%rax), %rdx
	movq	-48(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	permutation@PLT
	movq	%rax, -24(%rbp)
	movq	-88(%rbp), %rax
	movq	160(%rax), %rdx
	movq	-88(%rbp), %rax
	movq	176(%rax), %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	movq	%rax, %rdi
	call	malloc@PLT
	movq	%rax, %rdx
	movq	-88(%rbp), %rax
	movq	%rdx, (%rax)
	movq	-88(%rbp), %rax
	movq	(%rax), %rbx
	testq	%rbx, %rbx
	jne	.L477
	leaq	.LC0(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L477:
	movq	-88(%rbp), %rax
	movq	-72(%rbp), %rdx
	movq	%rdx, 200(%rax)
	movq	-88(%rbp), %rax
	movq	-64(%rbp), %rdx
	movq	%rdx, 184(%rax)
	movq	-88(%rbp), %rax
	movq	-56(%rbp), %rdx
	movq	%rdx, 192(%rax)
	movq	-88(%rbp), %rax
	movq	-32(%rbp), %rdx
	movq	%rdx, 216(%rax)
	movq	-88(%rbp), %rax
	movq	-24(%rbp), %rdx
	movq	%rdx, 208(%rax)
	movq	-88(%rbp), %rax
	movq	-40(%rbp), %rdx
	movq	%rdx, 224(%rax)
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	testq	%rax, %rax
	je	.L482
	cmpq	$0, -24(%rbp)
	je	.L482
	movq	%rbx, %rdx
	movq	-88(%rbp), %rax
	movq	176(%rax), %rcx
	movq	%rdx, %rax
	movl	$0, %edx
	divq	%rcx
	movq	%rdx, %rax
	testq	%rax, %rax
	je	.L480
	movq	-88(%rbp), %rax
	movq	176(%rax), %rcx
	movq	%rbx, %rdx
	movq	-88(%rbp), %rax
	movq	176(%rax), %rsi
	movq	%rdx, %rax
	movl	$0, %edx
	divq	%rsi
	movq	%rcx, %rax
	subq	%rdx, %rax
	addq	%rax, %rbx
.L480:
	movq	-88(%rbp), %rax
	movq	%rbx, 8(%rax)
	movq	-88(%rbp), %rax
	movl	$1, 144(%rax)
	movl	$0, %eax
	call	mem_reset
	jmp	.L474
.L481:
	nop
	jmp	.L474
.L482:
	nop
.L474:
	movq	-8(%rbp), %rbx
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE27:
	.size	base_initialize, .-base_initialize
	.globl	stride_initialize
	.type	stride_initialize, @function
stride_initialize:
.LFB28:
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
	movq	-64(%rbp), %rax
	movq	%rax, -32(%rbp)
	movq	-32(%rbp), %rax
	movq	152(%rax), %rax
	movq	%rax, -24(%rbp)
	movq	-32(%rbp), %rax
	movq	168(%rax), %rax
	movq	%rax, -16(%rbp)
	movq	-64(%rbp), %rdx
	movq	-56(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	base_initialize
	movq	-32(%rbp), %rax
	movl	144(%rax), %eax
	testl	%eax, %eax
	je	.L488
	movq	-32(%rbp), %rax
	movq	8(%rax), %rax
	movq	%rax, -8(%rbp)
	movq	-16(%rbp), %rax
	movq	%rax, -40(%rbp)
	jmp	.L486
.L487:
	movq	-40(%rbp), %rax
	subq	-16(%rbp), %rax
	movq	%rax, %rdx
	movq	-8(%rbp), %rax
	addq	%rdx, %rax
	movq	-8(%rbp), %rcx
	movq	-40(%rbp), %rdx
	addq	%rcx, %rdx
	movq	%rdx, (%rax)
	movq	-16(%rbp), %rax
	addq	%rax, -40(%rbp)
.L486:
	movq	-40(%rbp), %rax
	cmpq	-24(%rbp), %rax
	jb	.L487
	movq	-40(%rbp), %rax
	subq	-16(%rbp), %rax
	movq	%rax, %rdx
	movq	-8(%rbp), %rax
	addq	%rax, %rdx
	movq	-8(%rbp), %rax
	movq	%rax, (%rdx)
	movq	-32(%rbp), %rax
	movq	-8(%rbp), %rdx
	movq	%rdx, 16(%rax)
	movl	$0, %eax
	call	mem_reset
	jmp	.L483
.L488:
	nop
.L483:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE28:
	.size	stride_initialize, .-stride_initialize
	.section	.rodata
.LC1:
	.string	"thrash_initialize: malloc"
	.text
	.globl	thrash_initialize
	.type	thrash_initialize, @function
thrash_initialize:
.LFB29:
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
	movq	-80(%rbp), %rax
	movq	%rax, -48(%rbp)
	movq	-80(%rbp), %rdx
	movq	-72(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	base_initialize
	movq	-48(%rbp), %rax
	movl	144(%rax), %eax
	testl	%eax, %eax
	je	.L504
	movq	-48(%rbp), %rax
	movq	8(%rax), %rax
	movq	%rax, -40(%rbp)
	movq	-48(%rbp), %rax
	movq	152(%rax), %rax
	movq	-48(%rbp), %rdx
	movq	176(%rdx), %rcx
	movl	$0, %edx
	divq	%rcx
	movq	%rdx, %rax
	testq	%rax, %rax
	je	.L492
	movq	-48(%rbp), %rax
	movq	152(%rax), %rax
	movq	-48(%rbp), %rdx
	movq	168(%rdx), %rdi
	movl	$0, %edx
	divq	%rdi
	movq	%rax, %rdx
	movq	-48(%rbp), %rax
	movq	%rdx, 200(%rax)
	movq	-48(%rbp), %rax
	movq	168(%rax), %rax
	movl	%eax, %edx
	movq	-48(%rbp), %rax
	movq	200(%rax), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	words_initialize
	movq	-48(%rbp), %rdx
	movq	%rax, 224(%rdx)
	movq	-48(%rbp), %rax
	movq	224(%rax), %rax
	testq	%rax, %rax
	jne	.L493
	leaq	.LC1(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L493:
	movq	$0, -64(%rbp)
	jmp	.L494
.L495:
	movq	-48(%rbp), %rax
	movq	224(%rax), %rdx
	movq	-64(%rbp), %rax
	addq	$1, %rax
	salq	$3, %rax
	addq	%rdx, %rax
	movq	(%rax), %rcx
	movq	-48(%rbp), %rax
	movq	224(%rax), %rdx
	movq	-64(%rbp), %rax
	salq	$3, %rax
	addq	%rdx, %rax
	movq	(%rax), %rdx
	movq	-40(%rbp), %rax
	addq	%rdx, %rax
	movq	-40(%rbp), %rdx
	addq	%rcx, %rdx
	movq	%rdx, (%rax)
	addq	$1, -64(%rbp)
.L494:
	movq	-48(%rbp), %rax
	movq	200(%rax), %rax
	subq	$1, %rax
	cmpq	%rax, -64(%rbp)
	jb	.L495
	movq	-48(%rbp), %rax
	movq	224(%rax), %rdx
	movq	-64(%rbp), %rax
	salq	$3, %rax
	addq	%rdx, %rax
	movq	(%rax), %rdx
	movq	-40(%rbp), %rax
	addq	%rax, %rdx
	movq	-40(%rbp), %rax
	movq	%rax, (%rdx)
	movq	-48(%rbp), %rax
	movq	-40(%rbp), %rdx
	movq	%rdx, 16(%rax)
	jmp	.L496
.L492:
	movq	-48(%rbp), %rax
	movq	176(%rax), %rax
	movq	-48(%rbp), %rdx
	movq	168(%rdx), %rdi
	movl	$0, %edx
	divq	%rdi
	movq	%rax, %rdx
	movq	-48(%rbp), %rax
	movq	%rdx, 200(%rax)
	movq	-48(%rbp), %rax
	movq	168(%rax), %rax
	movl	%eax, %edx
	movq	-48(%rbp), %rax
	movq	200(%rax), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	words_initialize
	movq	-48(%rbp), %rdx
	movq	%rax, 224(%rdx)
	movq	-48(%rbp), %rax
	movq	224(%rax), %rax
	testq	%rax, %rax
	jne	.L497
	leaq	.LC1(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$2, %edi
	call	exit@PLT
.L497:
	movq	$0, -64(%rbp)
	jmp	.L498
.L501:
	movq	-48(%rbp), %rax
	movq	208(%rax), %rdx
	movq	-64(%rbp), %rax
	salq	$3, %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rbp)
	movq	-48(%rbp), %rax
	movq	208(%rax), %rdx
	movq	-64(%rbp), %rax
	addq	$1, %rax
	salq	$3, %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	%rax, -24(%rbp)
	movq	$0, -56(%rbp)
	jmp	.L499
.L500:
	movq	-48(%rbp), %rax
	movq	224(%rax), %rsi
	movq	-64(%rbp), %rdx
	movq	-56(%rbp), %rax
	addq	%rax, %rdx
	movq	-48(%rbp), %rax
	movq	200(%rax), %rcx
	movq	%rdx, %rax
	movl	$0, %edx
	divq	%rcx
	movq	%rdx, %rax
	salq	$3, %rax
	addq	%rsi, %rax
	movq	(%rax), %rdx
	movq	-32(%rbp), %rax
	addq	%rdx, %rax
	movq	%rax, -16(%rbp)
	movq	-48(%rbp), %rax
	movq	224(%rax), %rsi
	movq	-64(%rbp), %rdx
	movq	-56(%rbp), %rax
	addq	%rdx, %rax
	leaq	1(%rax), %rdx
	movq	-48(%rbp), %rax
	movq	200(%rax), %rcx
	movq	%rdx, %rax
	movl	$0, %edx
	divq	%rcx
	movq	%rdx, %rax
	salq	$3, %rax
	addq	%rsi, %rax
	movq	(%rax), %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movq	%rax, -8(%rbp)
	movq	-40(%rbp), %rdx
	movq	-16(%rbp), %rax
	addq	%rdx, %rax
	movq	-40(%rbp), %rcx
	movq	-8(%rbp), %rdx
	addq	%rcx, %rdx
	movq	%rdx, (%rax)
	addq	$1, -56(%rbp)
.L499:
	movq	-48(%rbp), %rax
	movq	200(%rax), %rax
	cmpq	%rax, -56(%rbp)
	jb	.L500
	addq	$1, -64(%rbp)
.L498:
	movq	-48(%rbp), %rax
	movq	192(%rax), %rax
	subq	$1, %rax
	cmpq	%rax, -64(%rbp)
	jb	.L501
	movq	-48(%rbp), %rax
	movq	208(%rax), %rdx
	movq	-64(%rbp), %rax
	salq	$3, %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rbp)
	movq	-48(%rbp), %rax
	movq	208(%rax), %rax
	movq	(%rax), %rax
	movq	%rax, -24(%rbp)
	movq	$0, -56(%rbp)
	jmp	.L502
.L503:
	movq	-48(%rbp), %rax
	movq	224(%rax), %rsi
	movq	-64(%rbp), %rdx
	movq	-56(%rbp), %rax
	addq	%rax, %rdx
	movq	-48(%rbp), %rax
	movq	200(%rax), %rcx
	movq	%rdx, %rax
	movl	$0, %edx
	divq	%rcx
	movq	%rdx, %rax
	salq	$3, %rax
	addq	%rsi, %rax
	movq	(%rax), %rdx
	movq	-32(%rbp), %rax
	addq	%rdx, %rax
	movq	%rax, -16(%rbp)
	movq	-48(%rbp), %rax
	movq	224(%rax), %rsi
	movq	-56(%rbp), %rax
	leaq	1(%rax), %rdx
	movq	-48(%rbp), %rax
	movq	200(%rax), %rcx
	movq	%rdx, %rax
	movl	$0, %edx
	divq	%rcx
	movq	%rdx, %rax
	salq	$3, %rax
	addq	%rsi, %rax
	movq	(%rax), %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movq	%rax, -8(%rbp)
	movq	-40(%rbp), %rdx
	movq	-16(%rbp), %rax
	addq	%rdx, %rax
	movq	-40(%rbp), %rcx
	movq	-8(%rbp), %rdx
	addq	%rcx, %rdx
	movq	%rdx, (%rax)
	addq	$1, -56(%rbp)
.L502:
	movq	-48(%rbp), %rax
	movq	200(%rax), %rax
	cmpq	%rax, -56(%rbp)
	jb	.L503
	movq	-48(%rbp), %rax
	movq	208(%rax), %rax
	movq	(%rax), %rdx
	movq	-40(%rbp), %rax
	addq	%rax, %rdx
	movq	-48(%rbp), %rax
	movq	%rdx, 16(%rax)
.L496:
	movl	$0, %eax
	call	mem_reset
	jmp	.L489
.L504:
	nop
.L489:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE29:
	.size	thrash_initialize, .-thrash_initialize
	.section	.rodata
.LC2:
	.string	"mem_initialize: malloc"
	.text
	.globl	mem_initialize
	.type	mem_initialize, @function
mem_initialize:
.LFB30:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%rbx
	subq	$104, %rsp
	.cfi_offset 3, -24
	movq	%rdi, -104(%rbp)
	movq	%rsi, -112(%rbp)
	movq	-112(%rbp), %rax
	movq	%rax, -48(%rbp)
	cmpq	$0, -104(%rbp)
	jne	.L526
	movq	-112(%rbp), %rdx
	movq	-104(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	base_initialize
	movq	-48(%rbp), %rax
	movl	144(%rax), %eax
	testl	%eax, %eax
	je	.L527
	movq	-48(%rbp), %rax
	movl	$0, 144(%rax)
	movq	-48(%rbp), %rax
	movq	152(%rax), %rax
	movq	-48(%rbp), %rdx
	movq	168(%rdx), %rdi
	movl	$0, %edx
	divq	%rdi
	movl	%eax, -68(%rbp)
	movq	-48(%rbp), %rax
	movq	200(%rax), %rax
	movl	%eax, -64(%rbp)
	movq	-48(%rbp), %rax
	movq	184(%rax), %rax
	movl	%eax, -60(%rbp)
	movq	-48(%rbp), %rax
	movq	192(%rax), %rax
	movl	%eax, -56(%rbp)
	movl	-64(%rbp), %eax
	cltq
	movl	$8, %esi
	movq	%rax, %rdi
	call	words_initialize
	movq	-48(%rbp), %rdx
	movq	%rax, 224(%rdx)
	movq	-48(%rbp), %rax
	movq	224(%rax), %rax
	movq	%rax, -40(%rbp)
	movq	-48(%rbp), %rax
	movq	168(%rax), %rax
	movl	%eax, %edx
	movl	-60(%rbp), %eax
	cltq
	movl	%edx, %esi
	movq	%rax, %rdi
	call	words_initialize
	movq	-48(%rbp), %rdx
	movq	%rax, 216(%rdx)
	movq	-48(%rbp), %rax
	movq	216(%rax), %rax
	movq	%rax, -32(%rbp)
	movq	-48(%rbp), %rax
	movq	208(%rax), %rax
	movq	%rax, -24(%rbp)
	movq	-48(%rbp), %rax
	movq	8(%rax), %rbx
	movq	-48(%rbp), %rax
	movq	(%rax), %rax
	testq	%rax, %rax
	je	.L509
	cmpq	$0, -24(%rbp)
	je	.L509
	cmpq	$0, -32(%rbp)
	je	.L509
	cmpq	$0, -40(%rbp)
	jne	.L510
.L509:
	leaq	.LC2(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L510:
	movl	$0, -72(%rbp)
	movl	-60(%rbp), %eax
	subl	$1, %eax
	movl	%eax, -80(%rbp)
	movl	$0, -84(%rbp)
	jmp	.L511
.L521:
	movl	$0, -80(%rbp)
	jmp	.L512
.L517:
	movl	$0, -76(%rbp)
	jmp	.L513
.L514:
	movl	-84(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rdx
	movl	-80(%rbp), %eax
	cltq
	addq	$1, %rax
	leaq	0(,%rax,8), %rcx
	movq	-32(%rbp), %rax
	addq	%rcx, %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	movl	-76(%rbp), %eax
	cltq
	addq	%rax, %rdx
	movl	-84(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rcx
	movq	-24(%rbp), %rax
	addq	%rcx, %rax
	movq	(%rax), %rcx
	movl	-80(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rsi
	movq	-32(%rbp), %rax
	addq	%rsi, %rax
	movq	(%rax), %rax
	addq	%rax, %rcx
	movl	-76(%rbp), %eax
	cltq
	addq	%rcx, %rax
	addq	%rbx, %rax
	addq	%rbx, %rdx
	movq	%rdx, (%rax)
	movl	-76(%rbp), %eax
	addl	$8, %eax
	movl	%eax, -76(%rbp)
.L513:
	movl	-76(%rbp), %eax
	movslq	%eax, %rdx
	movq	-48(%rbp), %rax
	movq	168(%rax), %rax
	cmpq	%rax, %rdx
	jb	.L514
	movq	-48(%rbp), %rax
	movl	148(%rax), %edi
	movl	-68(%rbp), %eax
	cltd
	idivl	%edi
	movl	%eax, %ecx
	movl	-72(%rbp), %eax
	cltd
	idivl	%ecx
	movl	%edx, %eax
	testl	%eax, %eax
	jne	.L515
	movq	-48(%rbp), %rax
	movl	148(%rax), %edi
	movl	-68(%rbp), %eax
	cltd
	idivl	%edi
	movl	%eax, %edi
	movl	-72(%rbp), %eax
	cltd
	idivl	%edi
	cmpl	$15, %eax
	jg	.L515
	movq	-48(%rbp), %rax
	movl	148(%rax), %edi
	movl	-68(%rbp), %eax
	cltd
	idivl	%edi
	movl	%eax, %esi
	movl	-72(%rbp), %eax
	cltd
	idivl	%esi
	movl	%eax, -76(%rbp)
	movl	-84(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rdx
	movl	-80(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rcx
	movq	-32(%rbp), %rax
	addq	%rcx, %rax
	movq	(%rax), %rax
	leaq	(%rdx,%rax), %rcx
	movl	-76(%rbp), %eax
	cltd
	idivl	-64(%rbp)
	movl	%edx, %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-40(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	addq	%rcx, %rax
	leaq	(%rbx,%rax), %rcx
	movq	-48(%rbp), %rax
	movl	-76(%rbp), %edx
	movslq	%edx, %rdx
	addq	$2, %rdx
	movq	%rcx, (%rax,%rdx,8)
.L515:
	addl	$1, -80(%rbp)
	addl	$1, -72(%rbp)
.L512:
	movl	-60(%rbp), %eax
	subl	$1, %eax
	cmpl	%eax, -80(%rbp)
	jge	.L516
	movl	-68(%rbp), %eax
	subl	$1, %eax
	cmpl	%eax, -72(%rbp)
	jl	.L517
.L516:
	movl	-56(%rbp), %eax
	subl	$1, %eax
	cmpl	%eax, -84(%rbp)
	jge	.L518
	movl	$0, -76(%rbp)
	jmp	.L519
.L520:
	movl	-84(%rbp), %eax
	cltq
	addq	$1, %rax
	leaq	0(,%rax,8), %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rdx
	movq	-32(%rbp), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	movl	-76(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rcx
	movq	-40(%rbp), %rax
	addq	%rcx, %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	movl	-84(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rcx
	movq	-24(%rbp), %rax
	addq	%rcx, %rax
	movq	(%rax), %rcx
	movl	-80(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rsi
	movq	-32(%rbp), %rax
	addq	%rsi, %rax
	movq	(%rax), %rax
	addq	%rax, %rcx
	movl	-76(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rsi
	movq	-40(%rbp), %rax
	addq	%rsi, %rax
	movq	(%rax), %rax
	addq	%rcx, %rax
	addq	%rbx, %rax
	addq	%rbx, %rdx
	movq	%rdx, (%rax)
	addl	$1, -76(%rbp)
.L519:
	movl	-76(%rbp), %eax
	cmpl	-64(%rbp), %eax
	jl	.L520
.L518:
	addl	$1, -84(%rbp)
.L511:
	movl	-84(%rbp), %eax
	cmpl	-56(%rbp), %eax
	jl	.L521
	movl	$0, -76(%rbp)
	jmp	.L522
.L525:
	movl	-64(%rbp), %eax
	subl	$1, %eax
	cmpl	%eax, -76(%rbp)
	je	.L523
	movl	-76(%rbp), %eax
	addl	$1, %eax
	jmp	.L524
.L523:
	movl	$0, %eax
.L524:
	movl	%eax, -52(%rbp)
	movq	-24(%rbp), %rax
	movq	(%rax), %rdx
	movq	-32(%rbp), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	movl	-52(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rcx
	movq	-40(%rbp), %rax
	addq	%rcx, %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	movl	-56(%rbp), %eax
	cltq
	salq	$3, %rax
	leaq	-8(%rax), %rcx
	movq	-24(%rbp), %rax
	addq	%rcx, %rax
	movq	(%rax), %rcx
	movl	-80(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rsi
	movq	-32(%rbp), %rax
	addq	%rsi, %rax
	movq	(%rax), %rax
	addq	%rax, %rcx
	movl	-76(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rsi
	movq	-40(%rbp), %rax
	addq	%rsi, %rax
	movq	(%rax), %rax
	addq	%rcx, %rax
	addq	%rbx, %rax
	addq	%rbx, %rdx
	movq	%rdx, (%rax)
	addl	$1, -76(%rbp)
.L522:
	movl	-76(%rbp), %eax
	cmpl	-64(%rbp), %eax
	jl	.L525
	movl	$0, %eax
	call	mem_reset
	movq	-48(%rbp), %rax
	movl	148(%rax), %eax
	subl	$1, %eax
	cltq
	leaq	0(,%rax,8), %rdx
	leaq	mem_benchmarks(%rip), %rax
	movq	(%rdx,%rax), %rcx
	movl	-64(%rbp), %eax
	imull	-68(%rbp), %eax
	addl	$100, %eax
	movslq	%eax, %rdx
	imulq	$1374389535, %rdx, %rdx
	shrq	$32, %rdx
	sarl	$5, %edx
	sarl	$31, %eax
	movl	%eax, %esi
	movl	%edx, %eax
	subl	%esi, %eax
	cltq
	movq	-48(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	*%rcx
	movq	-48(%rbp), %rax
	movl	$1, 144(%rax)
	jmp	.L505
.L526:
	nop
	jmp	.L505
.L527:
	nop
.L505:
	movq	-8(%rbp), %rbx
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE30:
	.size	mem_initialize, .-mem_initialize
	.globl	line_initialize
	.type	line_initialize, @function
line_initialize:
.LFB31:
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
	movq	%rdi, -72(%rbp)
	movq	%rsi, -80(%rbp)
	movq	-80(%rbp), %rax
	movq	%rax, -40(%rbp)
	cmpq	$0, -72(%rbp)
	jne	.L540
	movq	-80(%rbp), %rdx
	movq	-72(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	base_initialize
	movq	-40(%rbp), %rax
	movl	144(%rax), %eax
	testl	%eax, %eax
	je	.L541
	movq	-40(%rbp), %rax
	movl	$0, 144(%rax)
	movq	-40(%rbp), %rax
	movq	184(%rax), %rax
	movl	%eax, -48(%rbp)
	movq	-40(%rbp), %rax
	movq	192(%rax), %rax
	movl	%eax, -44(%rbp)
	movq	-40(%rbp), %rax
	movq	168(%rax), %rax
	movl	%eax, %edx
	movl	-48(%rbp), %eax
	cltq
	movl	%edx, %esi
	movq	%rax, %rdi
	call	words_initialize
	movq	-40(%rbp), %rdx
	movq	%rax, 216(%rdx)
	movq	-40(%rbp), %rax
	movq	216(%rax), %rax
	movq	%rax, -32(%rbp)
	movq	-40(%rbp), %rax
	movq	208(%rax), %rax
	movq	%rax, -24(%rbp)
	movq	-40(%rbp), %rax
	movq	8(%rax), %rbx
	movq	-40(%rbp), %rax
	movl	$1, 148(%rax)
	movq	-40(%rbp), %rax
	movq	(%rax), %rax
	testq	%rax, %rax
	je	.L542
	cmpq	$0, -32(%rbp)
	je	.L542
	cmpq	$0, -24(%rbp)
	je	.L542
	movl	$0, -56(%rbp)
	jmp	.L534
.L539:
	movl	$0, -52(%rbp)
	jmp	.L535
.L536:
	movl	-56(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rdx
	movl	-52(%rbp), %eax
	cltq
	addq	$1, %rax
	leaq	0(,%rax,8), %rcx
	movq	-32(%rbp), %rax
	addq	%rcx, %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	movl	-56(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rcx
	movq	-24(%rbp), %rax
	addq	%rcx, %rax
	movq	(%rax), %rcx
	movl	-52(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rsi
	movq	-32(%rbp), %rax
	addq	%rsi, %rax
	movq	(%rax), %rax
	addq	%rcx, %rax
	addq	%rbx, %rax
	addq	%rbx, %rdx
	movq	%rdx, (%rax)
	addl	$1, -52(%rbp)
.L535:
	movl	-48(%rbp), %eax
	subl	$1, %eax
	cmpl	%eax, -52(%rbp)
	jl	.L536
	movl	-44(%rbp), %eax
	subl	$1, %eax
	cmpl	%eax, -56(%rbp)
	jge	.L537
	movl	-56(%rbp), %eax
	addl	$1, %eax
	cltq
	leaq	0(,%rax,8), %rdx
	jmp	.L538
.L537:
	movl	$0, %edx
.L538:
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rdx
	movq	-32(%rbp), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	movl	-56(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rcx
	movq	-24(%rbp), %rax
	addq	%rcx, %rax
	movq	(%rax), %rcx
	movl	-52(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rsi
	movq	-32(%rbp), %rax
	addq	%rsi, %rax
	movq	(%rax), %rax
	addq	%rcx, %rax
	addq	%rbx, %rax
	addq	%rbx, %rdx
	movq	%rdx, (%rax)
	addl	$1, -56(%rbp)
.L534:
	movl	-56(%rbp), %eax
	cmpl	-44(%rbp), %eax
	jl	.L539
	movq	-24(%rbp), %rax
	movq	(%rax), %rdx
	movq	-32(%rbp), %rax
	movq	(%rax), %rax
	addq	%rdx, %rax
	leaq	(%rbx,%rax), %rdx
	movq	-40(%rbp), %rax
	movq	%rdx, 16(%rax)
	movl	$0, %eax
	call	mem_reset
	movl	-48(%rbp), %eax
	imull	-44(%rbp), %eax
	addl	$100, %eax
	movslq	%eax, %rdx
	imulq	$1374389535, %rdx, %rdx
	shrq	$32, %rdx
	sarl	$5, %edx
	sarl	$31, %eax
	movl	%eax, %ecx
	movl	%edx, %eax
	subl	%ecx, %eax
	cltq
	movq	-40(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	mem_benchmark_0
	movq	-40(%rbp), %rax
	movl	$1, 144(%rax)
	jmp	.L528
.L540:
	nop
	jmp	.L528
.L541:
	nop
	jmp	.L528
.L542:
	nop
.L528:
	movq	-8(%rbp), %rbx
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE31:
	.size	line_initialize, .-line_initialize
	.section	.rodata
.LC3:
	.string	"tlb_initialize: malloc"
.LC4:
	.string	"tlb_initialize: valloc"
	.text
	.globl	tlb_initialize
	.type	tlb_initialize, @function
tlb_initialize:
.LFB32:
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
	movq	%rdi, -88(%rbp)
	movq	%rsi, -96(%rbp)
	movq	$0, -56(%rbp)
	movq	$0, -48(%rbp)
	movq	$0, -40(%rbp)
	movq	-96(%rbp), %rax
	movq	%rax, -32(%rbp)
	cmpq	$0, -88(%rbp)
	jne	.L561
	movq	-32(%rbp), %rax
	movl	$0, 144(%rax)
	movq	-32(%rbp), %rax
	movq	176(%rax), %rax
	movl	%eax, -68(%rbp)
	movl	-68(%rbp), %eax
	cltq
	shrq	$3, %rax
	movl	%eax, -64(%rbp)
	movq	-32(%rbp), %rax
	movq	152(%rax), %rax
	movl	-68(%rbp), %edx
	movslq	%edx, %rsi
	movl	$0, %edx
	divq	%rsi
	movl	%eax, -60(%rbp)
	call	getpid@PLT
	movl	%eax, %ebx
	call	getppid@PLT
	sall	$7, %eax
	xorl	%ebx, %eax
	movl	%eax, %edi
	call	srand@PLT
	movl	-64(%rbp), %eax
	cltq
	movl	$8, %esi
	movq	%rax, %rdi
	call	words_initialize
	movq	%rax, -40(%rbp)
	movl	-60(%rbp), %eax
	cltq
	salq	$3, %rax
	movq	%rax, %rdi
	call	malloc@PLT
	movq	%rax, -56(%rbp)
	movl	-60(%rbp), %eax
	cltq
	salq	$3, %rax
	movq	%rax, %rdi
	call	malloc@PLT
	movq	%rax, -48(%rbp)
	cmpq	$0, -40(%rbp)
	je	.L546
	cmpq	$0, -56(%rbp)
	je	.L546
	cmpq	$0, -48(%rbp)
	jne	.L547
.L546:
	leaq	.LC3(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L547:
	movq	-32(%rbp), %rax
	movq	$1, 200(%rax)
	movl	-64(%rbp), %eax
	movslq	%eax, %rdx
	movq	-32(%rbp), %rax
	movq	%rdx, 184(%rax)
	movl	-60(%rbp), %eax
	movslq	%eax, %rdx
	movq	-32(%rbp), %rax
	movq	%rdx, 192(%rax)
	movq	-32(%rbp), %rax
	movq	$0, 224(%rax)
	movq	-32(%rbp), %rax
	movq	-40(%rbp), %rdx
	movq	%rdx, 216(%rax)
	movq	-32(%rbp), %rax
	movq	-56(%rbp), %rdx
	movq	%rdx, 208(%rax)
	movq	-32(%rbp), %rax
	movq	-48(%rbp), %rdx
	movq	%rdx, (%rax)
	cmpq	$0, -48(%rbp)
	je	.L548
	movl	-60(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-48(%rbp), %rax
	movl	$0, %esi
	movq	%rax, %rdi
	call	memset@PLT
.L548:
	cmpq	$0, -56(%rbp)
	je	.L549
	movl	-60(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-56(%rbp), %rax
	movl	$0, %esi
	movq	%rax, %rdi
	call	memset@PLT
.L549:
	cmpq	$0, -48(%rbp)
	je	.L562
	cmpq	$0, -56(%rbp)
	je	.L562
	cmpq	$0, -40(%rbp)
	je	.L562
	movl	$0, -76(%rbp)
	jmp	.L552
.L556:
	movl	-68(%rbp), %eax
	cltq
	movl	-76(%rbp), %edx
	movslq	%edx, %rdx
	leaq	0(,%rdx,8), %rcx
	movq	-48(%rbp), %rdx
	leaq	(%rcx,%rdx), %rbx
	movq	%rax, %rdi
	call	valloc@PLT
	movq	%rax, (%rbx)
	movq	(%rbx), %rbx
	testq	%rbx, %rbx
	jne	.L553
	leaq	.LC4(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$4, %edi
	call	exit@PLT
.L553:
	movq	%rbx, %rdx
	movl	-68(%rbp), %eax
	movslq	%eax, %rcx
	movq	%rdx, %rax
	movl	$0, %edx
	divq	%rcx
	movq	%rdx, %rax
	testq	%rax, %rax
	je	.L554
	movq	%rbx, %rdi
	call	free@PLT
	movl	-68(%rbp), %eax
	addl	%eax, %eax
	cltq
	movl	-76(%rbp), %edx
	movslq	%edx, %rdx
	leaq	0(,%rdx,8), %rcx
	movq	-48(%rbp), %rdx
	leaq	(%rcx,%rdx), %rbx
	movq	%rax, %rdi
	call	valloc@PLT
	movq	%rax, (%rbx)
	movq	(%rbx), %rbx
	testq	%rbx, %rbx
	jne	.L555
	leaq	.LC4(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$5, %edi
	call	exit@PLT
.L555:
	movl	-68(%rbp), %eax
	movslq	%eax, %rcx
	movq	%rbx, %rdx
	movl	-68(%rbp), %eax
	movslq	%eax, %rsi
	movq	%rdx, %rax
	movl	$0, %edx
	divq	%rsi
	movq	%rcx, %rax
	subq	%rdx, %rax
	addq	%rax, %rbx
.L554:
	movl	-76(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-56(%rbp), %rax
	addq	%rdx, %rax
	movq	%rbx, (%rax)
	addl	$1, -76(%rbp)
.L552:
	movl	-76(%rbp), %eax
	cmpl	-60(%rbp), %eax
	jl	.L556
	call	rand@PLT
	sall	$15, %eax
	movl	%eax, %ebx
	call	rand@PLT
	xorl	%ebx, %eax
	movl	%eax, -72(%rbp)
	movl	-60(%rbp), %eax
	subl	$2, %eax
	movl	%eax, -76(%rbp)
	jmp	.L557
.L558:
	movl	-72(%rbp), %eax
	leal	(%rax,%rax), %ebx
	call	rand@PLT
	sarl	$4, %eax
	xorl	%ebx, %eax
	movl	%eax, -72(%rbp)
	movl	-76(%rbp), %ecx
	movl	-72(%rbp), %eax
	movl	$0, %edx
	divl	%ecx
	movl	%edx, %eax
	addl	$1, %eax
	movl	%eax, %eax
	leaq	0(,%rax,8), %rdx
	movq	-56(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	%rax, -24(%rbp)
	movl	-76(%rbp), %eax
	cltq
	addq	$1, %rax
	leaq	0(,%rax,8), %rdx
	movq	-56(%rbp), %rax
	leaq	(%rdx,%rax), %rcx
	movl	-76(%rbp), %esi
	movl	-72(%rbp), %eax
	movl	$0, %edx
	divl	%esi
	movl	%edx, %eax
	addl	$1, %eax
	movl	%eax, %eax
	leaq	0(,%rax,8), %rdx
	movq	-56(%rbp), %rax
	addq	%rax, %rdx
	movq	(%rcx), %rax
	movq	%rax, (%rdx)
	movl	-76(%rbp), %eax
	cltq
	addq	$1, %rax
	leaq	0(,%rax,8), %rdx
	movq	-56(%rbp), %rax
	addq	%rax, %rdx
	movq	-24(%rbp), %rax
	movq	%rax, (%rdx)
	subl	$1, -76(%rbp)
.L557:
	cmpl	$0, -76(%rbp)
	jg	.L558
	movl	$0, -76(%rbp)
	jmp	.L559
.L560:
	movl	-76(%rbp), %eax
	cltq
	addq	$1, %rax
	leaq	0(,%rax,8), %rdx
	movq	-56(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rsi
	movl	-76(%rbp), %eax
	addl	$1, %eax
	cltd
	idivl	-64(%rbp)
	movl	%edx, %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-40(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rcx
	movl	-76(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-56(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rdi
	movl	-76(%rbp), %eax
	cltd
	idivl	-64(%rbp)
	movl	%edx, %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-40(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	addq	%rdi, %rax
	leaq	(%rsi,%rcx), %rdx
	movq	%rdx, (%rax)
	addl	$1, -76(%rbp)
.L559:
	movl	-60(%rbp), %eax
	subl	$1, %eax
	cmpl	%eax, -76(%rbp)
	jl	.L560
	movq	-56(%rbp), %rax
	movq	(%rax), %rsi
	movq	-40(%rbp), %rax
	movq	(%rax), %rcx
	movl	-76(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-56(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rdi
	movl	-76(%rbp), %eax
	cltd
	idivl	-64(%rbp)
	movl	%edx, %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-40(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	addq	%rdi, %rax
	leaq	(%rsi,%rcx), %rdx
	movq	%rdx, (%rax)
	movq	-56(%rbp), %rax
	movq	(%rax), %rdx
	movq	-40(%rbp), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	movq	-32(%rbp), %rax
	movq	%rdx, 16(%rax)
	movl	$0, %eax
	call	mem_reset
	movl	-60(%rbp), %eax
	addl	$100, %eax
	movslq	%eax, %rdx
	imulq	$1374389535, %rdx, %rdx
	shrq	$32, %rdx
	sarl	$5, %edx
	sarl	$31, %eax
	movl	%eax, %ecx
	movl	%edx, %eax
	subl	%ecx, %eax
	cltq
	movq	-32(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	mem_benchmark_0
	movq	-32(%rbp), %rax
	movl	$1, 144(%rax)
	jmp	.L543
.L561:
	nop
	jmp	.L543
.L562:
	nop
.L543:
	movq	-8(%rbp), %rbx
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE32:
	.size	tlb_initialize, .-tlb_initialize
	.globl	words_initialize
	.type	words_initialize, @function
words_initialize:
.LFB33:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$48, %rsp
	movq	%rdi, -40(%rbp)
	movl	%esi, -44(%rbp)
	movq	-40(%rbp), %rax
	salq	$3, %rax
	movq	%rax, %rdi
	call	malloc@PLT
	movq	%rax, -8(%rbp)
	cmpq	$0, -8(%rbp)
	jne	.L564
	movl	$0, %eax
	jmp	.L565
.L564:
	movq	-40(%rbp), %rax
	leaq	0(,%rax,8), %rdx
	movq	-8(%rbp), %rax
	movl	$0, %esi
	movq	%rax, %rdi
	call	memset@PLT
	movq	-40(%rbp), %rax
	shrq	%rax
	movq	%rax, -32(%rbp)
	movq	$0, -16(%rbp)
	jmp	.L566
.L567:
	shrq	-32(%rbp)
	addq	$1, -16(%rbp)
.L566:
	cmpq	$0, -32(%rbp)
	jne	.L567
	movq	$0, -32(%rbp)
	jmp	.L568
.L572:
	movq	$0, -24(%rbp)
	jmp	.L569
.L571:
	movq	-24(%rbp), %rax
	movl	$1, %edx
	movl	%eax, %ecx
	sall	%cl, %edx
	movl	%edx, %eax
	cltq
	andq	-32(%rbp), %rax
	testq	%rax, %rax
	je	.L570
	movq	-32(%rbp), %rax
	leaq	0(,%rax,8), %rdx
	movq	-8(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rsi
	movq	-16(%rbp), %rax
	movl	%eax, %edx
	movq	-24(%rbp), %rax
	movl	%eax, %ecx
	movl	%edx, %eax
	subl	%ecx, %eax
	subl	$1, %eax
	movl	$1, %edx
	movl	%eax, %ecx
	sall	%cl, %edx
	movl	%edx, %eax
	movslq	%eax, %rdx
	movq	-32(%rbp), %rax
	leaq	0(,%rax,8), %rcx
	movq	-8(%rbp), %rax
	addq	%rcx, %rax
	orq	%rsi, %rdx
	movq	%rdx, (%rax)
.L570:
	addq	$1, -24(%rbp)
.L569:
	movq	-24(%rbp), %rax
	cmpq	-16(%rbp), %rax
	jb	.L571
	movq	-32(%rbp), %rax
	leaq	0(,%rax,8), %rdx
	movq	-8(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rcx
	movl	-44(%rbp), %eax
	cltq
	movq	-32(%rbp), %rdx
	leaq	0(,%rdx,8), %rsi
	movq	-8(%rbp), %rdx
	addq	%rsi, %rdx
	imulq	%rcx, %rax
	movq	%rax, (%rdx)
	addq	$1, -32(%rbp)
.L568:
	movq	-32(%rbp), %rax
	cmpq	-40(%rbp), %rax
	jb	.L572
	movq	-8(%rbp), %rax
.L565:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE33:
	.size	words_initialize, .-words_initialize
	.globl	line_find
	.type	line_find, @function
line_find:
.LFB34:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$80, %rsp
	movq	%rdi, -56(%rbp)
	movl	%esi, -60(%rbp)
	movl	%edx, -64(%rbp)
	movq	%rcx, -72(%rbp)
	call	getpagesize@PLT
	leal	15(%rax), %edx
	testl	%eax, %eax
	cmovs	%edx, %eax
	sarl	$4, %eax
	cltq
	movq	%rax, -16(%rbp)
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -24(%rbp)
	movq	$0, -40(%rbp)
	movq	$0, -32(%rbp)
	cmpl	$0, -64(%rbp)
	jns	.L574
	movl	$11, -64(%rbp)
.L574:
	movq	-72(%rbp), %rax
	movl	$1, 148(%rax)
	movq	-72(%rbp), %rax
	movq	$8, 168(%rax)
	movq	-72(%rbp), %rax
	movq	$0, (%rax)
	jmp	.L575
.L577:
	movq	-72(%rbp), %rax
	movq	-56(%rbp), %rdx
	movq	%rdx, 160(%rax)
	movq	-72(%rbp), %rax
	movq	160(%rax), %rdx
	movq	-72(%rbp), %rax
	movq	%rdx, 152(%rax)
	movq	-72(%rbp), %rax
	movq	%rax, %rsi
	movl	$0, %edi
	call	line_initialize
	movq	-72(%rbp), %rax
	movq	(%rax), %rax
	testq	%rax, %rax
	jne	.L575
	shrq	-56(%rbp)
.L575:
	movq	-72(%rbp), %rax
	movq	(%rax), %rax
	testq	%rax, %rax
	jne	.L576
	cmpq	$0, -56(%rbp)
	jne	.L577
.L576:
	movq	-72(%rbp), %rax
	movq	(%rax), %rax
	testq	%rax, %rax
	jne	.L578
	movq	$-1, %rax
	jmp	.L579
.L578:
	movq	$8, -48(%rbp)
	jmp	.L580
.L588:
	movq	-72(%rbp), %rcx
	movl	-64(%rbp), %edx
	movl	-60(%rbp), %esi
	movq	-48(%rbp), %rax
	movq	%rax, %rdi
	call	line_test
	movq	%xmm0, %rax
	movq	%rax, -8(%rbp)
	pxor	%xmm0, %xmm0
	ucomisd	-8(%rbp), %xmm0
	jp	.L581
	pxor	%xmm0, %xmm0
	ucomisd	-8(%rbp), %xmm0
	je	.L592
.L581:
	cmpq	$8, -48(%rbp)
	jbe	.L584
	movsd	-24(%rbp), %xmm1
	movsd	.LC6(%rip), %xmm0
	mulsd	%xmm0, %xmm1
	movsd	-8(%rbp), %xmm0
	comisd	%xmm1, %xmm0
	jbe	.L591
	movq	$1, -40(%rbp)
	jmp	.L584
.L591:
	cmpq	$0, -40(%rbp)
	je	.L584
	movsd	-24(%rbp), %xmm1
	movsd	.LC7(%rip), %xmm0
	mulsd	%xmm1, %xmm0
	comisd	-8(%rbp), %xmm0
	jbe	.L584
	movq	-48(%rbp), %rax
	shrq	%rax
	movq	%rax, -32(%rbp)
	jmp	.L583
.L584:
	movsd	-8(%rbp), %xmm0
	movsd	%xmm0, -24(%rbp)
	salq	-48(%rbp)
.L580:
	movq	-48(%rbp), %rax
	cmpq	-16(%rbp), %rax
	jbe	.L588
	jmp	.L583
.L592:
	nop
.L583:
	movq	-72(%rbp), %rax
	movq	%rax, %rsi
	movl	$0, %edi
	call	mem_cleanup
	movq	-32(%rbp), %rax
.L579:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE34:
	.size	line_find, .-line_find
	.section	.rodata
.LC8:
	.string	"line_test: malloc"
	.text
	.globl	line_test
	.type	line_test, @function
line_test:
.LFB35:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%rbx
	subq	$168, %rsp
	.cfi_offset 3, -24
	movq	%rdi, -136(%rbp)
	movl	%esi, -140(%rbp)
	movl	%edx, -144(%rbp)
	movq	%rcx, -152(%rbp)
	movq	-152(%rbp), %rax
	movq	192(%rax), %rax
	movq	%rax, -80(%rbp)
	movq	-152(%rbp), %rax
	movq	176(%rax), %rax
	movl	$0, %edx
	divq	-136(%rbp)
	movq	%rax, -72(%rbp)
	movq	-152(%rbp), %rax
	movq	8(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-152(%rbp), %rax
	movq	208(%rax), %rax
	movq	(%rax), %rdx
	movq	-152(%rbp), %rax
	movq	216(%rax), %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	movq	-104(%rbp), %rax
	addq	%rdx, %rax
	movq	%rax, -64(%rbp)
	cmpl	$0, -144(%rbp)
	jns	.L594
	movl	$11, -144(%rbp)
.L594:
	movq	-152(%rbp), %rax
	movq	184(%rax), %rax
	cmpq	%rax, -72(%rbp)
	jnb	.L595
	movq	-152(%rbp), %rax
	movq	8(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	$0, -112(%rbp)
	jmp	.L596
.L597:
	movq	-152(%rbp), %rax
	movq	208(%rax), %rdx
	movq	-112(%rbp), %rax
	addq	$1, %rax
	salq	$3, %rax
	addq	%rdx, %rax
	movq	(%rax), %rdx
	movq	-152(%rbp), %rax
	movq	216(%rax), %rax
	movq	(%rax), %rax
	leaq	(%rdx,%rax), %rsi
	movq	-152(%rbp), %rax
	movq	208(%rax), %rdx
	movq	-112(%rbp), %rax
	salq	$3, %rax
	addq	%rdx, %rax
	movq	(%rax), %rdx
	movq	-152(%rbp), %rax
	movq	216(%rax), %rcx
	movq	-72(%rbp), %rax
	salq	$3, %rax
	subq	$8, %rax
	addq	%rcx, %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	movq	-104(%rbp), %rax
	addq	%rdx, %rax
	movq	-104(%rbp), %rdx
	addq	%rsi, %rdx
	movq	%rdx, (%rax)
	addq	$1, -112(%rbp)
.L596:
	movq	-80(%rbp), %rax
	subq	$1, %rax
	cmpq	%rax, -112(%rbp)
	jb	.L597
	movq	-152(%rbp), %rax
	movq	208(%rax), %rax
	movq	(%rax), %rdx
	movq	-152(%rbp), %rax
	movq	216(%rax), %rax
	movq	(%rax), %rax
	leaq	(%rdx,%rax), %rsi
	movq	-152(%rbp), %rax
	movq	208(%rax), %rdx
	movq	-80(%rbp), %rax
	salq	$3, %rax
	subq	$8, %rax
	addq	%rdx, %rax
	movq	(%rax), %rdx
	movq	-152(%rbp), %rax
	movq	216(%rax), %rcx
	movq	-72(%rbp), %rax
	salq	$3, %rax
	subq	$8, %rax
	addq	%rcx, %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	movq	-104(%rbp), %rax
	addq	%rdx, %rax
	movq	-104(%rbp), %rdx
	addq	%rsi, %rdx
	movq	%rdx, (%rax)
.L595:
	movl	$0, %eax
	call	get_results@PLT
	movq	%rax, -56(%rbp)
	movl	-144(%rbp), %eax
	movl	%eax, %edi
	call	sizeof_result@PLT
	cltq
	movq	%rax, %rdi
	call	malloc@PLT
	movq	%rax, -48(%rbp)
	cmpq	$0, -48(%rbp)
	jne	.L598
	leaq	.LC8(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L598:
	movq	-48(%rbp), %rax
	movq	%rax, %rdi
	call	insertinit@PLT
	movq	-64(%rbp), %rax
	movq	%rax, -104(%rbp)
	movq	$0, -112(%rbp)
	jmp	.L599
.L629:
	movl	$0, %edi
	call	get_enough@PLT
	movl	%eax, -116(%rbp)
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -88(%rbp)
	jmp	.L600
.L615:
	movl	$0, %edi
	call	start@PLT
	movq	__iterations.1(%rip), %rax
	movq	%rax, -96(%rbp)
	jmp	.L601
.L602:
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -104(%rbp)
	subq	$1, -96(%rbp)
.L601:
	cmpq	$0, -96(%rbp)
	jne	.L602
	movl	$0, %esi
	movl	$0, %edi
	call	stop@PLT
	testq	%rax, %rax
	js	.L603
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L604
.L603:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L604:
	movsd	%xmm0, -88(%rbp)
	pxor	%xmm1, %xmm1
	cvtsi2sdl	-116(%rbp), %xmm1
	movsd	.LC9(%rip), %xmm0
	mulsd	%xmm1, %xmm0
	comisd	-88(%rbp), %xmm0
	ja	.L605
	pxor	%xmm1, %xmm1
	cvtsi2sdl	-116(%rbp), %xmm1
	movsd	.LC10(%rip), %xmm0
	mulsd	%xmm0, %xmm1
	movsd	-88(%rbp), %xmm0
	comisd	%xmm1, %xmm0
	ja	.L605
	jmp	.L600
.L605:
	movsd	-88(%rbp), %xmm0
	comisd	.LC11(%rip), %xmm0
	jbe	.L640
	movq	__iterations.1(%rip), %rax
	testq	%rax, %rax
	js	.L609
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L610
.L609:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L610:
	divsd	-88(%rbp), %xmm0
	movsd	%xmm0, -32(%rbp)
	pxor	%xmm1, %xmm1
	cvtsi2sdl	-116(%rbp), %xmm1
	movsd	.LC12(%rip), %xmm0
	mulsd	%xmm1, %xmm0
	movsd	-32(%rbp), %xmm1
	mulsd	%xmm1, %xmm0
	movsd	%xmm0, -32(%rbp)
	movsd	-32(%rbp), %xmm1
	movsd	.LC13(%rip), %xmm0
	addsd	%xmm1, %xmm0
	comisd	.LC14(%rip), %xmm0
	jnb	.L611
	cvttsd2siq	%xmm0, %rax
	jmp	.L612
.L611:
	movsd	.LC14(%rip), %xmm1
	subsd	%xmm1, %xmm0
	cvttsd2siq	%xmm0, %rax
	movabsq	$-9223372036854775808, %rdx
	xorq	%rdx, %rax
.L612:
	movq	%rax, __iterations.1(%rip)
	jmp	.L600
.L640:
	movq	__iterations.1(%rip), %rax
	cmpq	$134217728, %rax
	jbe	.L613
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -88(%rbp)
	jmp	.L614
.L613:
	movq	__iterations.1(%rip), %rax
	salq	$3, %rax
	movq	%rax, __iterations.1(%rip)
.L600:
	pxor	%xmm1, %xmm1
	cvtsi2sdl	-116(%rbp), %xmm1
	movsd	.LC15(%rip), %xmm0
	mulsd	%xmm1, %xmm0
	comisd	-88(%rbp), %xmm0
	ja	.L615
.L614:
	movq	__iterations.1(%rip), %rax
	movq	%rax, %rdi
	call	save_n@PLT
	movsd	-88(%rbp), %xmm0
	comisd	.LC14(%rip), %xmm0
	jnb	.L616
	movsd	-88(%rbp), %xmm0
	cvttsd2siq	%xmm0, %rax
	jmp	.L617
.L616:
	movsd	-88(%rbp), %xmm0
	movsd	.LC14(%rip), %xmm1
	subsd	%xmm1, %xmm0
	cvttsd2siq	%xmm0, %rax
	movabsq	$-9223372036854775808, %rdx
	xorq	%rdx, %rax
.L617:
	movq	%rax, %rdi
	call	settime@PLT
	call	usecs_spent@PLT
	testq	%rax, %rax
	js	.L618
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L619
.L618:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L619:
	movsd	%xmm0, -24(%rbp)
	call	t_overhead@PLT
	testq	%rax, %rax
	js	.L620
	pxor	%xmm2, %xmm2
	cvtsi2sdq	%rax, %xmm2
	movsd	%xmm2, -160(%rbp)
	jmp	.L621
.L620:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
	movsd	%xmm0, -160(%rbp)
.L621:
	call	get_n@PLT
	testq	%rax, %rax
	js	.L622
	pxor	%xmm3, %xmm3
	cvtsi2sdq	%rax, %xmm3
	movsd	%xmm3, -168(%rbp)
	jmp	.L623
.L622:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
	movsd	%xmm0, -168(%rbp)
.L623:
	call	l_overhead@PLT
	mulsd	-168(%rbp), %xmm0
	movsd	-160(%rbp), %xmm1
	addsd	%xmm0, %xmm1
	movsd	-24(%rbp), %xmm0
	subsd	%xmm1, %xmm0
	movsd	%xmm0, -24(%rbp)
	movsd	-24(%rbp), %xmm0
	pxor	%xmm1, %xmm1
	comisd	%xmm1, %xmm0
	jb	.L641
	movsd	-24(%rbp), %xmm0
	comisd	.LC14(%rip), %xmm0
	jnb	.L626
	movsd	-24(%rbp), %xmm0
	cvttsd2siq	%xmm0, %rax
	jmp	.L628
.L626:
	movsd	-24(%rbp), %xmm0
	movsd	.LC14(%rip), %xmm1
	subsd	%xmm1, %xmm0
	cvttsd2siq	%xmm0, %rax
	movabsq	$-9223372036854775808, %rdx
	xorq	%rdx, %rax
	jmp	.L628
.L641:
	movl	$0, %eax
.L628:
	movq	%rax, %rdi
	call	settime@PLT
	call	get_n@PLT
	movq	%rax, %rbx
	call	usecs_spent@PLT
	movq	%rax, %rcx
	movq	-48(%rbp), %rax
	movq	%rax, %rdx
	movq	%rbx, %rsi
	movq	%rcx, %rdi
	call	insertsort@PLT
	addq	$1, -112(%rbp)
.L599:
	movl	-144(%rbp), %eax
	cltq
	cmpq	%rax, -112(%rbp)
	jb	.L629
	movq	-104(%rbp), %rax
	movq	%rax, %rdi
	call	use_pointer@PLT
	movq	-48(%rbp), %rax
	movq	%rax, %rdi
	call	set_results@PLT
	call	usecs_spent@PLT
	testq	%rax, %rax
	js	.L630
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L631
.L630:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L631:
	movsd	.LC16(%rip), %xmm1
	mulsd	%xmm1, %xmm0
	movsd	%xmm0, -160(%rbp)
	call	get_n@PLT
	testq	%rax, %rax
	js	.L632
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L633
.L632:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L633:
	movsd	-160(%rbp), %xmm1
	divsd	%xmm0, %xmm1
	movsd	%xmm1, -40(%rbp)
	movq	-56(%rbp), %rax
	movq	%rax, %rdi
	call	set_results@PLT
	movq	-48(%rbp), %rax
	movq	%rax, %rdi
	call	free@PLT
	movq	-152(%rbp), %rax
	movq	184(%rax), %rax
	cmpq	%rax, -72(%rbp)
	jnb	.L634
	movq	-152(%rbp), %rax
	movq	8(%rax), %rax
	movq	%rax, -104(%rbp)
	movq	$0, -112(%rbp)
	jmp	.L635
.L636:
	movq	-152(%rbp), %rax
	movq	208(%rax), %rdx
	movq	-112(%rbp), %rax
	salq	$3, %rax
	addq	%rdx, %rax
	movq	(%rax), %rdx
	movq	-152(%rbp), %rax
	movq	216(%rax), %rcx
	movq	-72(%rbp), %rax
	salq	$3, %rax
	addq	%rcx, %rax
	movq	(%rax), %rax
	leaq	(%rdx,%rax), %rsi
	movq	-152(%rbp), %rax
	movq	208(%rax), %rdx
	movq	-112(%rbp), %rax
	salq	$3, %rax
	addq	%rdx, %rax
	movq	(%rax), %rdx
	movq	-152(%rbp), %rax
	movq	216(%rax), %rcx
	movq	-72(%rbp), %rax
	salq	$3, %rax
	subq	$8, %rax
	addq	%rcx, %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	movq	-104(%rbp), %rax
	addq	%rdx, %rax
	movq	-104(%rbp), %rdx
	addq	%rsi, %rdx
	movq	%rdx, (%rax)
	addq	$1, -112(%rbp)
.L635:
	movq	-80(%rbp), %rax
	subq	$1, %rax
	cmpq	%rax, -112(%rbp)
	jb	.L636
	movq	-152(%rbp), %rax
	movq	208(%rax), %rdx
	movq	-80(%rbp), %rax
	salq	$3, %rax
	subq	$8, %rax
	addq	%rdx, %rax
	movq	(%rax), %rdx
	movq	-152(%rbp), %rax
	movq	216(%rax), %rcx
	movq	-72(%rbp), %rax
	salq	$3, %rax
	addq	%rcx, %rax
	movq	(%rax), %rax
	leaq	(%rdx,%rax), %rsi
	movq	-152(%rbp), %rax
	movq	208(%rax), %rdx
	movq	-80(%rbp), %rax
	salq	$3, %rax
	subq	$8, %rax
	addq	%rdx, %rax
	movq	(%rax), %rdx
	movq	-152(%rbp), %rax
	movq	216(%rax), %rcx
	movq	-72(%rbp), %rax
	salq	$3, %rax
	subq	$8, %rax
	addq	%rcx, %rax
	movq	(%rax), %rax
	addq	%rax, %rdx
	movq	-104(%rbp), %rax
	addq	%rdx, %rax
	movq	-104(%rbp), %rdx
	addq	%rsi, %rdx
	movq	%rdx, (%rax)
.L634:
	movsd	-40(%rbp), %xmm0
	movq	%xmm0, %rax
	movq	%rax, %xmm0
	movq	-8(%rbp), %rbx
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE35:
	.size	line_test, .-line_test
	.globl	par_mem
	.type	par_mem, @function
par_mem:
.LFB36:
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
	movq	%rdi, -360(%rbp)
	movl	%esi, -364(%rbp)
	movl	%edx, -368(%rbp)
	movq	%rcx, -376(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -24(%rbp)
	xorl	%eax, %eax
	movq	$1, -328(%rbp)
	movq	-376(%rbp), %rax
	movl	$1, 148(%rax)
	movsd	.LC13(%rip), %xmm0
	movsd	%xmm0, -312(%rbp)
	cmpl	$0, -368(%rbp)
	jns	.L643
	movl	$11, -368(%rbp)
.L643:
	movq	-376(%rbp), %rax
	movq	$0, (%rax)
	jmp	.L644
.L646:
	movq	-376(%rbp), %rax
	movq	-360(%rbp), %rdx
	movq	%rdx, 160(%rax)
	movq	-376(%rbp), %rax
	movq	160(%rax), %rdx
	movq	-376(%rbp), %rax
	movq	%rdx, 152(%rax)
	movq	-376(%rbp), %rax
	movq	%rax, %rsi
	movl	$0, %edi
	call	mem_initialize
	movq	-376(%rbp), %rax
	movq	(%rax), %rax
	testq	%rax, %rax
	jne	.L644
	shrq	-360(%rbp)
.L644:
	movq	-376(%rbp), %rax
	movq	(%rax), %rax
	testq	%rax, %rax
	jne	.L645
	cmpq	$0, -360(%rbp)
	jne	.L646
.L645:
	movq	-376(%rbp), %rax
	movq	(%rax), %rax
	testq	%rax, %rax
	jne	.L647
	movsd	.LC17(%rip), %xmm0
	jmp	.L648
.L647:
	movl	$0, -340(%rbp)
	jmp	.L649
.L698:
	movl	$0, -336(%rbp)
	jmp	.L650
.L651:
	movq	-376(%rbp), %rax
	movq	168(%rax), %rbx
	movq	-360(%rbp), %rax
	movl	$0, %edx
	divq	%rbx
	movq	%rax, -248(%rbp)
	movl	-340(%rbp), %eax
	addl	$1, %eax
	movslq	%eax, %rbx
	movq	-248(%rbp), %rax
	movl	$0, %edx
	divq	%rbx
	movq	%rax, -240(%rbp)
	movq	-376(%rbp), %rax
	movq	176(%rax), %rax
	movq	-376(%rbp), %rdx
	movq	168(%rdx), %rbx
	movl	$0, %edx
	divq	%rbx
	movq	%rax, -232(%rbp)
	movl	-336(%rbp), %eax
	cltq
	movq	-240(%rbp), %rdx
	imulq	%rdx, %rax
	movq	%rax, -224(%rbp)
	movl	-336(%rbp), %eax
	movslq	%eax, %rdx
	movq	-376(%rbp), %rax
	movq	200(%rax), %rax
	imulq	%rdx, %rax
	movl	-340(%rbp), %edx
	addl	$1, %edx
	movslq	%edx, %rsi
	movl	$0, %edx
	divq	%rsi
	movq	%rax, -216(%rbp)
	movq	-376(%rbp), %rax
	movq	8(%rax), %rsi
	movq	-376(%rbp), %rax
	movq	208(%rax), %rcx
	movq	-224(%rbp), %rax
	movl	$0, %edx
	divq	-232(%rbp)
	salq	$3, %rax
	addq	%rcx, %rax
	movq	(%rax), %rcx
	movq	-376(%rbp), %rax
	movq	216(%rax), %rdi
	movq	-224(%rbp), %rax
	movl	$0, %edx
	divq	-232(%rbp)
	movq	%rdx, %rax
	salq	$3, %rax
	addq	%rdi, %rax
	movq	(%rax), %rax
	leaq	(%rcx,%rax), %r8
	movq	-376(%rbp), %rax
	movq	224(%rax), %rdi
	movq	-376(%rbp), %rax
	movq	200(%rax), %rcx
	movq	-216(%rbp), %rax
	movl	$0, %edx
	divq	%rcx
	movq	%rdx, %rax
	salq	$3, %rax
	addq	%rdi, %rax
	movq	(%rax), %rax
	addq	%r8, %rax
	leaq	(%rsi,%rax), %rcx
	movq	-376(%rbp), %rax
	movl	-336(%rbp), %edx
	movslq	%edx, %rdx
	addq	$2, %rdx
	movq	%rcx, (%rax,%rdx,8)
	addl	$1, -336(%rbp)
.L650:
	movl	-336(%rbp), %eax
	cmpl	-340(%rbp), %eax
	jle	.L651
	movl	$0, %eax
	call	mem_reset
	movl	-340(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	leaq	mem_benchmarks(%rip), %rax
	movq	(%rdx,%rax), %rcx
	movq	-360(%rbp), %rax
	shrq	$3, %rax
	addq	$100, %rax
	shrq	$2, %rax
	movabsq	$2951479051793528259, %rdx
	mulq	%rdx
	shrq	$2, %rdx
	movq	-376(%rbp), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	*%rcx
	leaq	-208(%rbp), %rax
	movq	%rax, %rdi
	call	insertinit@PLT
	movq	$11, -280(%rbp)
	movl	-340(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	leaq	mem_benchmarks(%rip), %rax
	movq	(%rdx,%rax), %rcx
	movq	-376(%rbp), %rdx
	movq	-328(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	*%rcx
	movq	$1, -328(%rbp)
	movq	$0, -304(%rbp)
	jmp	.L652
.L683:
	movl	$0, %edi
	call	get_enough@PLT
	movl	%eax, -332(%rbp)
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -288(%rbp)
	jmp	.L653
.L668:
	movl	$0, %edi
	call	start@PLT
	movq	__iterations.0(%rip), %rax
	movq	%rax, -296(%rbp)
	jmp	.L654
.L655:
	movl	-340(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	leaq	mem_benchmarks(%rip), %rax
	movq	(%rdx,%rax), %rcx
	movq	-376(%rbp), %rdx
	movq	-296(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	*%rcx
	movq	$1, -296(%rbp)
	subq	$1, -296(%rbp)
.L654:
	cmpq	$0, -296(%rbp)
	jne	.L655
	movl	$0, %esi
	movl	$0, %edi
	call	stop@PLT
	testq	%rax, %rax
	js	.L656
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L657
.L656:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L657:
	movsd	%xmm0, -288(%rbp)
	pxor	%xmm1, %xmm1
	cvtsi2sdl	-332(%rbp), %xmm1
	movsd	.LC9(%rip), %xmm0
	mulsd	%xmm1, %xmm0
	comisd	-288(%rbp), %xmm0
	ja	.L658
	pxor	%xmm1, %xmm1
	cvtsi2sdl	-332(%rbp), %xmm1
	movsd	.LC10(%rip), %xmm0
	mulsd	%xmm0, %xmm1
	movsd	-288(%rbp), %xmm0
	comisd	%xmm1, %xmm0
	ja	.L658
	jmp	.L653
.L658:
	movsd	-288(%rbp), %xmm0
	comisd	.LC11(%rip), %xmm0
	jbe	.L703
	movq	__iterations.0(%rip), %rax
	testq	%rax, %rax
	js	.L662
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L663
.L662:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L663:
	divsd	-288(%rbp), %xmm0
	movsd	%xmm0, -264(%rbp)
	pxor	%xmm1, %xmm1
	cvtsi2sdl	-332(%rbp), %xmm1
	movsd	.LC12(%rip), %xmm0
	mulsd	%xmm1, %xmm0
	movsd	-264(%rbp), %xmm1
	mulsd	%xmm1, %xmm0
	movsd	%xmm0, -264(%rbp)
	movsd	-264(%rbp), %xmm1
	movsd	.LC13(%rip), %xmm0
	addsd	%xmm1, %xmm0
	comisd	.LC14(%rip), %xmm0
	jnb	.L664
	cvttsd2siq	%xmm0, %rax
	jmp	.L665
.L664:
	movsd	.LC14(%rip), %xmm1
	subsd	%xmm1, %xmm0
	cvttsd2siq	%xmm0, %rax
	movabsq	$-9223372036854775808, %rdx
	xorq	%rdx, %rax
.L665:
	movq	%rax, __iterations.0(%rip)
	jmp	.L653
.L703:
	movq	__iterations.0(%rip), %rax
	cmpq	$134217728, %rax
	jbe	.L666
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -288(%rbp)
	jmp	.L667
.L666:
	movq	__iterations.0(%rip), %rax
	salq	$3, %rax
	movq	%rax, __iterations.0(%rip)
.L653:
	pxor	%xmm1, %xmm1
	cvtsi2sdl	-332(%rbp), %xmm1
	movsd	.LC15(%rip), %xmm0
	mulsd	%xmm1, %xmm0
	comisd	-288(%rbp), %xmm0
	ja	.L668
.L667:
	movq	__iterations.0(%rip), %rax
	movq	%rax, %rdi
	call	save_n@PLT
	movsd	-288(%rbp), %xmm0
	comisd	.LC14(%rip), %xmm0
	jnb	.L669
	movsd	-288(%rbp), %xmm0
	cvttsd2siq	%xmm0, %rax
	jmp	.L670
.L669:
	movsd	-288(%rbp), %xmm0
	movsd	.LC14(%rip), %xmm1
	subsd	%xmm1, %xmm0
	cvttsd2siq	%xmm0, %rax
	movabsq	$-9223372036854775808, %rdx
	xorq	%rdx, %rax
.L670:
	movq	%rax, %rdi
	call	settime@PLT
	call	usecs_spent@PLT
	testq	%rax, %rax
	js	.L671
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L672
.L671:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L672:
	movsd	%xmm0, -256(%rbp)
	call	t_overhead@PLT
	testq	%rax, %rax
	js	.L673
	pxor	%xmm2, %xmm2
	cvtsi2sdq	%rax, %xmm2
	movsd	%xmm2, -384(%rbp)
	jmp	.L674
.L673:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
	movsd	%xmm0, -384(%rbp)
.L674:
	call	get_n@PLT
	testq	%rax, %rax
	js	.L675
	pxor	%xmm3, %xmm3
	cvtsi2sdq	%rax, %xmm3
	movsd	%xmm3, -392(%rbp)
	jmp	.L676
.L675:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
	movsd	%xmm0, -392(%rbp)
.L676:
	call	l_overhead@PLT
	mulsd	-392(%rbp), %xmm0
	movsd	-384(%rbp), %xmm1
	addsd	%xmm0, %xmm1
	movsd	-256(%rbp), %xmm0
	subsd	%xmm1, %xmm0
	movsd	%xmm0, -256(%rbp)
	movsd	-256(%rbp), %xmm0
	pxor	%xmm1, %xmm1
	comisd	%xmm1, %xmm0
	jb	.L704
	movsd	-256(%rbp), %xmm0
	comisd	.LC14(%rip), %xmm0
	jnb	.L679
	movsd	-256(%rbp), %xmm0
	cvttsd2siq	%xmm0, %rax
	jmp	.L681
.L679:
	movsd	-256(%rbp), %xmm0
	movsd	.LC14(%rip), %xmm1
	subsd	%xmm1, %xmm0
	cvttsd2siq	%xmm0, %rax
	movabsq	$-9223372036854775808, %rdx
	xorq	%rdx, %rax
	jmp	.L681
.L704:
	movl	$0, %eax
.L681:
	movq	%rax, %rdi
	call	settime@PLT
	call	usecs_spent@PLT
	testq	%rax, %rax
	je	.L682
	call	get_n@PLT
	movq	%rax, %rbx
	call	usecs_spent@PLT
	movq	%rax, %rcx
	leaq	-208(%rbp), %rax
	movq	%rax, %rdx
	movq	%rbx, %rsi
	movq	%rcx, %rdi
	call	insertsort@PLT
.L682:
	addq	$1, -304(%rbp)
.L652:
	movq	-304(%rbp), %rax
	cmpq	-280(%rbp), %rax
	jl	.L683
	movl	$0, %eax
	call	get_results@PLT
	movq	-208(%rbp), %rcx
	movq	-200(%rbp), %rbx
	movq	%rcx, (%rax)
	movq	%rbx, 8(%rax)
	movq	-192(%rbp), %rcx
	movq	-184(%rbp), %rbx
	movq	%rcx, 16(%rax)
	movq	%rbx, 24(%rax)
	movq	-176(%rbp), %rcx
	movq	-168(%rbp), %rbx
	movq	%rcx, 32(%rax)
	movq	%rbx, 40(%rax)
	movq	-160(%rbp), %rcx
	movq	-152(%rbp), %rbx
	movq	%rcx, 48(%rax)
	movq	%rbx, 56(%rax)
	movq	-144(%rbp), %rcx
	movq	-136(%rbp), %rbx
	movq	%rcx, 64(%rax)
	movq	%rbx, 72(%rax)
	movq	-128(%rbp), %rcx
	movq	-120(%rbp), %rbx
	movq	%rcx, 80(%rax)
	movq	%rbx, 88(%rax)
	movq	-112(%rbp), %rcx
	movq	-104(%rbp), %rbx
	movq	%rcx, 96(%rax)
	movq	%rbx, 104(%rax)
	movq	-96(%rbp), %rcx
	movq	-88(%rbp), %rbx
	movq	%rcx, 112(%rax)
	movq	%rbx, 120(%rax)
	movq	-80(%rbp), %rcx
	movq	-72(%rbp), %rbx
	movq	%rcx, 128(%rax)
	movq	%rbx, 136(%rax)
	movq	-64(%rbp), %rcx
	movq	-56(%rbp), %rbx
	movq	%rcx, 144(%rax)
	movq	%rbx, 152(%rax)
	movq	-48(%rbp), %rcx
	movq	-40(%rbp), %rbx
	movq	%rcx, 160(%rax)
	movq	%rbx, 168(%rax)
	movq	-32(%rbp), %rdx
	movq	%rdx, 176(%rax)
	cmpl	$0, -340(%rbp)
	jne	.L684
	call	usecs_spent@PLT
	testq	%rax, %rax
	js	.L685
	pxor	%xmm5, %xmm5
	cvtsi2sdq	%rax, %xmm5
	movsd	%xmm5, -384(%rbp)
	jmp	.L686
.L685:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
	movsd	%xmm0, -384(%rbp)
.L686:
	call	get_n@PLT
	testq	%rax, %rax
	js	.L687
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L688
.L687:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L688:
	movsd	-384(%rbp), %xmm1
	divsd	%xmm0, %xmm1
	movsd	%xmm1, -320(%rbp)
	jmp	.L689
.L684:
	call	usecs_spent@PLT
	testq	%rax, %rax
	je	.L689
	movsd	-320(%rbp), %xmm0
	movsd	%xmm0, -272(%rbp)
	call	usecs_spent@PLT
	testq	%rax, %rax
	js	.L690
	pxor	%xmm6, %xmm6
	cvtsi2sdq	%rax, %xmm6
	movsd	%xmm6, -384(%rbp)
	jmp	.L691
.L690:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
	movsd	%xmm0, -384(%rbp)
.L691:
	movl	-340(%rbp), %eax
	addl	$1, %eax
	movslq	%eax, %rbx
	call	get_n@PLT
	imulq	%rbx, %rax
	testq	%rax, %rax
	js	.L692
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L693
.L692:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L693:
	movsd	-384(%rbp), %xmm1
	divsd	%xmm0, %xmm1
	movsd	-272(%rbp), %xmm0
	divsd	%xmm1, %xmm0
	movsd	%xmm0, -272(%rbp)
	movsd	-272(%rbp), %xmm0
	comisd	-312(%rbp), %xmm0
	jbe	.L694
	movsd	-272(%rbp), %xmm0
	movsd	%xmm0, -312(%rbp)
.L694:
	movsd	-312(%rbp), %xmm1
	movsd	.LC18(%rip), %xmm0
	mulsd	%xmm0, %xmm1
	pxor	%xmm0, %xmm0
	cvtsi2sdl	-340(%rbp), %xmm0
	comisd	%xmm1, %xmm0
	ja	.L705
.L689:
	addl	$1, -340(%rbp)
.L649:
	cmpl	$15, -340(%rbp)
	jle	.L698
	jmp	.L697
.L705:
	nop
.L697:
	movq	-376(%rbp), %rax
	movq	%rax, %rsi
	movl	$0, %edi
	call	mem_cleanup
	movsd	-312(%rbp), %xmm0
.L648:
	movq	%xmm0, %rax
	movq	-24(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L699
	call	__stack_chk_fail@PLT
.L699:
	movq	%rax, %xmm0
	movq	-8(%rbp), %rbx
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE36:
	.size	par_mem, .-par_mem
	.local	addr_save.153
	.comm	addr_save.153,8,8
	.local	sp0.152
	.comm	sp0.152,8,8
	.local	addr_save.151
	.comm	addr_save.151,8,8
	.local	sp0.150
	.comm	sp0.150,8,8
	.local	sp1.149
	.comm	sp1.149,8,8
	.local	addr_save.148
	.comm	addr_save.148,8,8
	.local	sp0.147
	.comm	sp0.147,8,8
	.local	sp1.146
	.comm	sp1.146,8,8
	.local	sp2.145
	.comm	sp2.145,8,8
	.local	addr_save.144
	.comm	addr_save.144,8,8
	.local	sp0.143
	.comm	sp0.143,8,8
	.local	sp1.142
	.comm	sp1.142,8,8
	.local	sp2.141
	.comm	sp2.141,8,8
	.local	sp3.140
	.comm	sp3.140,8,8
	.local	addr_save.139
	.comm	addr_save.139,8,8
	.local	sp0.138
	.comm	sp0.138,8,8
	.local	sp1.137
	.comm	sp1.137,8,8
	.local	sp2.136
	.comm	sp2.136,8,8
	.local	sp3.135
	.comm	sp3.135,8,8
	.local	sp4.134
	.comm	sp4.134,8,8
	.local	addr_save.133
	.comm	addr_save.133,8,8
	.local	sp0.132
	.comm	sp0.132,8,8
	.local	sp1.131
	.comm	sp1.131,8,8
	.local	sp2.130
	.comm	sp2.130,8,8
	.local	sp3.129
	.comm	sp3.129,8,8
	.local	sp4.128
	.comm	sp4.128,8,8
	.local	sp5.127
	.comm	sp5.127,8,8
	.local	addr_save.126
	.comm	addr_save.126,8,8
	.local	sp0.125
	.comm	sp0.125,8,8
	.local	sp1.124
	.comm	sp1.124,8,8
	.local	sp2.123
	.comm	sp2.123,8,8
	.local	sp3.122
	.comm	sp3.122,8,8
	.local	sp4.121
	.comm	sp4.121,8,8
	.local	sp5.120
	.comm	sp5.120,8,8
	.local	sp6.119
	.comm	sp6.119,8,8
	.local	addr_save.118
	.comm	addr_save.118,8,8
	.local	sp0.117
	.comm	sp0.117,8,8
	.local	sp1.116
	.comm	sp1.116,8,8
	.local	sp2.115
	.comm	sp2.115,8,8
	.local	sp3.114
	.comm	sp3.114,8,8
	.local	sp4.113
	.comm	sp4.113,8,8
	.local	sp5.112
	.comm	sp5.112,8,8
	.local	sp6.111
	.comm	sp6.111,8,8
	.local	sp7.110
	.comm	sp7.110,8,8
	.local	addr_save.109
	.comm	addr_save.109,8,8
	.local	sp0.108
	.comm	sp0.108,8,8
	.local	sp1.107
	.comm	sp1.107,8,8
	.local	sp2.106
	.comm	sp2.106,8,8
	.local	sp3.105
	.comm	sp3.105,8,8
	.local	sp4.104
	.comm	sp4.104,8,8
	.local	sp5.103
	.comm	sp5.103,8,8
	.local	sp6.102
	.comm	sp6.102,8,8
	.local	sp7.101
	.comm	sp7.101,8,8
	.local	sp8.100
	.comm	sp8.100,8,8
	.local	addr_save.99
	.comm	addr_save.99,8,8
	.local	sp0.98
	.comm	sp0.98,8,8
	.local	sp1.97
	.comm	sp1.97,8,8
	.local	sp2.96
	.comm	sp2.96,8,8
	.local	sp3.95
	.comm	sp3.95,8,8
	.local	sp4.94
	.comm	sp4.94,8,8
	.local	sp5.93
	.comm	sp5.93,8,8
	.local	sp6.92
	.comm	sp6.92,8,8
	.local	sp7.91
	.comm	sp7.91,8,8
	.local	sp8.90
	.comm	sp8.90,8,8
	.local	sp9.89
	.comm	sp9.89,8,8
	.local	addr_save.88
	.comm	addr_save.88,8,8
	.local	sp0.87
	.comm	sp0.87,8,8
	.local	sp1.86
	.comm	sp1.86,8,8
	.local	sp2.85
	.comm	sp2.85,8,8
	.local	sp3.84
	.comm	sp3.84,8,8
	.local	sp4.83
	.comm	sp4.83,8,8
	.local	sp5.82
	.comm	sp5.82,8,8
	.local	sp6.81
	.comm	sp6.81,8,8
	.local	sp7.80
	.comm	sp7.80,8,8
	.local	sp8.79
	.comm	sp8.79,8,8
	.local	sp9.78
	.comm	sp9.78,8,8
	.local	sp10.77
	.comm	sp10.77,8,8
	.local	addr_save.76
	.comm	addr_save.76,8,8
	.local	sp0.75
	.comm	sp0.75,8,8
	.local	sp1.74
	.comm	sp1.74,8,8
	.local	sp2.73
	.comm	sp2.73,8,8
	.local	sp3.72
	.comm	sp3.72,8,8
	.local	sp4.71
	.comm	sp4.71,8,8
	.local	sp5.70
	.comm	sp5.70,8,8
	.local	sp6.69
	.comm	sp6.69,8,8
	.local	sp7.68
	.comm	sp7.68,8,8
	.local	sp8.67
	.comm	sp8.67,8,8
	.local	sp9.66
	.comm	sp9.66,8,8
	.local	sp10.65
	.comm	sp10.65,8,8
	.local	sp11.64
	.comm	sp11.64,8,8
	.local	addr_save.63
	.comm	addr_save.63,8,8
	.local	sp0.62
	.comm	sp0.62,8,8
	.local	sp1.61
	.comm	sp1.61,8,8
	.local	sp2.60
	.comm	sp2.60,8,8
	.local	sp3.59
	.comm	sp3.59,8,8
	.local	sp4.58
	.comm	sp4.58,8,8
	.local	sp5.57
	.comm	sp5.57,8,8
	.local	sp6.56
	.comm	sp6.56,8,8
	.local	sp7.55
	.comm	sp7.55,8,8
	.local	sp8.54
	.comm	sp8.54,8,8
	.local	sp9.53
	.comm	sp9.53,8,8
	.local	sp10.52
	.comm	sp10.52,8,8
	.local	sp11.51
	.comm	sp11.51,8,8
	.local	sp12.50
	.comm	sp12.50,8,8
	.local	addr_save.49
	.comm	addr_save.49,8,8
	.local	sp0.48
	.comm	sp0.48,8,8
	.local	sp1.47
	.comm	sp1.47,8,8
	.local	sp2.46
	.comm	sp2.46,8,8
	.local	sp3.45
	.comm	sp3.45,8,8
	.local	sp4.44
	.comm	sp4.44,8,8
	.local	sp5.43
	.comm	sp5.43,8,8
	.local	sp6.42
	.comm	sp6.42,8,8
	.local	sp7.41
	.comm	sp7.41,8,8
	.local	sp8.40
	.comm	sp8.40,8,8
	.local	sp9.39
	.comm	sp9.39,8,8
	.local	sp10.38
	.comm	sp10.38,8,8
	.local	sp11.37
	.comm	sp11.37,8,8
	.local	sp12.36
	.comm	sp12.36,8,8
	.local	sp13.35
	.comm	sp13.35,8,8
	.local	addr_save.34
	.comm	addr_save.34,8,8
	.local	sp0.33
	.comm	sp0.33,8,8
	.local	sp1.32
	.comm	sp1.32,8,8
	.local	sp2.31
	.comm	sp2.31,8,8
	.local	sp3.30
	.comm	sp3.30,8,8
	.local	sp4.29
	.comm	sp4.29,8,8
	.local	sp5.28
	.comm	sp5.28,8,8
	.local	sp6.27
	.comm	sp6.27,8,8
	.local	sp7.26
	.comm	sp7.26,8,8
	.local	sp8.25
	.comm	sp8.25,8,8
	.local	sp9.24
	.comm	sp9.24,8,8
	.local	sp10.23
	.comm	sp10.23,8,8
	.local	sp11.22
	.comm	sp11.22,8,8
	.local	sp12.21
	.comm	sp12.21,8,8
	.local	sp13.20
	.comm	sp13.20,8,8
	.local	sp14.19
	.comm	sp14.19,8,8
	.local	addr_save.18
	.comm	addr_save.18,8,8
	.local	sp0.17
	.comm	sp0.17,8,8
	.local	sp1.16
	.comm	sp1.16,8,8
	.local	sp2.15
	.comm	sp2.15,8,8
	.local	sp3.14
	.comm	sp3.14,8,8
	.local	sp4.13
	.comm	sp4.13,8,8
	.local	sp5.12
	.comm	sp5.12,8,8
	.local	sp6.11
	.comm	sp6.11,8,8
	.local	sp7.10
	.comm	sp7.10,8,8
	.local	sp8.9
	.comm	sp8.9,8,8
	.local	sp9.8
	.comm	sp9.8,8,8
	.local	sp10.7
	.comm	sp10.7,8,8
	.local	sp11.6
	.comm	sp11.6,8,8
	.local	sp12.5
	.comm	sp12.5,8,8
	.local	sp13.4
	.comm	sp13.4,8,8
	.local	sp14.3
	.comm	sp14.3,8,8
	.local	sp15.2
	.comm	sp15.2,8,8
	.data
	.align 8
	.type	__iterations.1, @object
	.size	__iterations.1, 8
__iterations.1:
	.quad	1
	.align 8
	.type	__iterations.0, @object
	.size	__iterations.0, 8
__iterations.0:
	.quad	1
	.section	.rodata
	.align 8
.LC6:
	.long	-858993459
	.long	1073007820
	.align 8
.LC7:
	.long	1717986918
	.long	1072850534
	.align 8
.LC9:
	.long	2061584302
	.long	1072672276
	.align 8
.LC10:
	.long	858993459
	.long	1072902963
	.align 8
.LC11:
	.long	0
	.long	1080213504
	.align 8
.LC12:
	.long	-1717986918
	.long	1072798105
	.align 8
.LC13:
	.long	0
	.long	1072693248
	.align 8
.LC14:
	.long	0
	.long	1138753536
	.align 8
.LC15:
	.long	1717986918
	.long	1072588390
	.align 8
.LC16:
	.long	0
	.long	1076101120
	.align 8
.LC17:
	.long	0
	.long	-1074790400
	.align 8
.LC18:
	.long	0
	.long	1074790400
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
