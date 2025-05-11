	.file	"lib_mem.c"
	.text
	.globl	mem_benchmark_0
	.type	mem_benchmark_0, @function
mem_benchmark_0:
.LFB72:
	.cfi_startproc
	endbr64
	movq	%rsi, %rcx
	cmpl	$0, mem_benchmark_rerun(%rip)
	je	.L2
	movq	sp0.152(%rip), %rdx
	movq	addr_save.153(%rip), %rax
	cmpq	%rax, (%rsi)
	je	.L6
.L2:
	movq	16(%rcx), %rdx
.L6:
	leaq	-1(%rdi), %rax
	testq	%rdi, %rdi
	je	.L5
.L4:
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
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	subq	$1, %rax
	cmpq	$-1, %rax
	jne	.L4
.L5:
	movq	%rdx, sp0.152(%rip)
	movq	(%rcx), %rax
	movq	%rax, addr_save.153(%rip)
	movl	$1, mem_benchmark_rerun(%rip)
	ret
	.cfi_endproc
.LFE72:
	.size	mem_benchmark_0, .-mem_benchmark_0
	.globl	mem_benchmark_1
	.type	mem_benchmark_1, @function
mem_benchmark_1:
.LFB73:
	.cfi_startproc
	endbr64
	cmpl	$0, mem_benchmark_rerun(%rip)
	je	.L10
	movq	addr_save.151(%rip), %rax
	movq	sp0.150(%rip), %rdx
	cmpq	%rax, (%rsi)
	je	.L12
	movq	16(%rsi), %rdx
	movq	addr_save.151(%rip), %rax
	cmpq	%rax, (%rsi)
	jne	.L16
.L12:
	movq	sp1.149(%rip), %rcx
	jmp	.L15
.L10:
	movq	16(%rsi), %rdx
.L16:
	movq	24(%rsi), %rcx
.L15:
	leaq	-1(%rdi), %rax
	testq	%rdi, %rdi
	je	.L14
.L13:
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	subq	$1, %rax
	cmpq	$-1, %rax
	jne	.L13
.L14:
	movq	%rdx, sp0.150(%rip)
	movq	%rcx, sp1.149(%rip)
	movq	(%rsi), %rax
	movq	%rax, addr_save.151(%rip)
	movl	$1, mem_benchmark_rerun(%rip)
	ret
	.cfi_endproc
.LFE73:
	.size	mem_benchmark_1, .-mem_benchmark_1
	.globl	mem_benchmark_2
	.type	mem_benchmark_2, @function
mem_benchmark_2:
.LFB74:
	.cfi_startproc
	endbr64
	movq	%rsi, %r8
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L21
	movq	addr_save.148(%rip), %rdx
	cmpq	%rdx, (%rsi)
	je	.L35
	movq	16(%rsi), %rdx
	movq	addr_save.148(%rip), %rcx
	cmpq	%rcx, (%rsi)
	je	.L23
	movq	24(%r8), %rcx
	testl	%eax, %eax
	je	.L24
	movq	addr_save.148(%rip), %rax
	cmpq	%rax, (%r8)
	jne	.L24
	jmp	.L26
.L35:
	movq	sp0.147(%rip), %rdx
.L23:
	movq	sp1.146(%rip), %rcx
.L26:
	movq	sp2.145(%rip), %rsi
	jmp	.L29
.L21:
	movq	16(%rsi), %rdx
	movq	24(%rsi), %rcx
.L24:
	movq	32(%r8), %rsi
.L29:
	leaq	-1(%rdi), %rax
	testq	%rdi, %rdi
	je	.L28
.L27:
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	subq	$1, %rax
	cmpq	$-1, %rax
	jne	.L27
.L28:
	movq	%rdx, sp0.147(%rip)
	movq	%rcx, sp1.146(%rip)
	movq	%rsi, sp2.145(%rip)
	movq	(%r8), %rax
	movq	%rax, addr_save.148(%rip)
	movl	$1, mem_benchmark_rerun(%rip)
	ret
	.cfi_endproc
.LFE74:
	.size	mem_benchmark_2, .-mem_benchmark_2
	.globl	mem_benchmark_3
	.type	mem_benchmark_3, @function
mem_benchmark_3:
.LFB75:
	.cfi_startproc
	endbr64
	movq	%rsi, %r9
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L37
	movq	addr_save.144(%rip), %rdx
	cmpq	%rdx, (%rsi)
	je	.L55
	movq	16(%rsi), %rdx
	movq	addr_save.144(%rip), %rcx
	cmpq	%rcx, (%rsi)
	je	.L39
	movq	24(%r9), %rcx
	testl	%eax, %eax
	je	.L40
	movq	addr_save.144(%rip), %rsi
	cmpq	%rsi, (%r9)
	je	.L42
	movq	32(%r9), %rsi
	testl	%eax, %eax
	je	.L43
	movq	addr_save.144(%rip), %rax
	cmpq	%rax, (%r9)
	jne	.L43
	jmp	.L45
.L55:
	movq	sp0.143(%rip), %rdx
.L39:
	movq	sp1.142(%rip), %rcx
.L42:
	movq	sp2.141(%rip), %rsi
.L45:
	movq	sp3.140(%rip), %r8
	jmp	.L48
.L37:
	movq	16(%rsi), %rdx
	movq	24(%rsi), %rcx
.L40:
	movq	32(%r9), %rsi
.L43:
	movq	40(%r9), %r8
.L48:
	leaq	-1(%rdi), %rax
	testq	%rdi, %rdi
	je	.L47
.L46:
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %r8
	subq	$1, %rax
	cmpq	$-1, %rax
	jne	.L46
.L47:
	movq	%rdx, sp0.143(%rip)
	movq	%rcx, sp1.142(%rip)
	movq	%rsi, sp2.141(%rip)
	movq	%r8, sp3.140(%rip)
	movq	(%r9), %rax
	movq	%rax, addr_save.144(%rip)
	movl	$1, mem_benchmark_rerun(%rip)
	ret
	.cfi_endproc
.LFE75:
	.size	mem_benchmark_3, .-mem_benchmark_3
	.globl	mem_benchmark_4
	.type	mem_benchmark_4, @function
mem_benchmark_4:
.LFB76:
	.cfi_startproc
	endbr64
	movq	%rsi, %r10
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L57
	movq	addr_save.139(%rip), %rdx
	cmpq	%rdx, (%rsi)
	je	.L79
	movq	16(%rsi), %rdx
	movq	addr_save.139(%rip), %rcx
	cmpq	%rcx, (%rsi)
	je	.L59
	movq	24(%r10), %rcx
	testl	%eax, %eax
	je	.L60
	movq	addr_save.139(%rip), %rsi
	cmpq	%rsi, (%r10)
	je	.L62
	movq	32(%r10), %rsi
	testl	%eax, %eax
	je	.L63
	movq	addr_save.139(%rip), %r11
	cmpq	%r11, (%r10)
	je	.L65
	movq	40(%r10), %r8
	testl	%eax, %eax
	je	.L66
	movq	addr_save.139(%rip), %rax
	cmpq	%rax, (%r10)
	jne	.L66
	jmp	.L68
.L79:
	movq	sp0.138(%rip), %rdx
.L59:
	movq	sp1.137(%rip), %rcx
.L62:
	movq	sp2.136(%rip), %rsi
.L65:
	movq	sp3.135(%rip), %r8
.L68:
	movq	sp4.134(%rip), %r9
	jmp	.L71
.L57:
	movq	16(%rsi), %rdx
	movq	24(%rsi), %rcx
.L60:
	movq	32(%r10), %rsi
.L63:
	movq	40(%r10), %r8
.L66:
	movq	48(%r10), %r9
.L71:
	leaq	-1(%rdi), %rax
	testq	%rdi, %rdi
	je	.L70
.L69:
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%rdi), %r9
	subq	$1, %rax
	cmpq	$-1, %rax
	jne	.L69
.L70:
	movq	%rdx, sp0.138(%rip)
	movq	%rcx, sp1.137(%rip)
	movq	%rsi, sp2.136(%rip)
	movq	%r8, sp3.135(%rip)
	movq	%r9, sp4.134(%rip)
	movq	(%r10), %rax
	movq	%rax, addr_save.139(%rip)
	movl	$1, mem_benchmark_rerun(%rip)
	ret
	.cfi_endproc
.LFE76:
	.size	mem_benchmark_4, .-mem_benchmark_4
	.globl	mem_benchmark_5
	.type	mem_benchmark_5, @function
mem_benchmark_5:
.LFB77:
	.cfi_startproc
	endbr64
	movq	%rsi, %r11
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L81
	movq	addr_save.133(%rip), %rdx
	cmpq	%rdx, (%rsi)
	je	.L106
	movq	16(%rsi), %rdx
	movq	addr_save.133(%rip), %rcx
	cmpq	%rcx, (%rsi)
	je	.L83
	movq	24(%r11), %rcx
	testl	%eax, %eax
	je	.L84
	movq	addr_save.133(%rip), %rsi
	cmpq	%rsi, (%r11)
	je	.L86
	movq	32(%r11), %rsi
	testl	%eax, %eax
	je	.L87
	movq	addr_save.133(%rip), %r10
	cmpq	%r10, (%r11)
	je	.L98
	movq	40(%r11), %r8
	movq	addr_save.133(%rip), %r10
	cmpq	%r10, (%r11)
	je	.L89
	movq	48(%r11), %r9
	testl	%eax, %eax
	je	.L90
	movq	addr_save.133(%rip), %rax
	cmpq	%rax, (%r11)
	jne	.L90
	jmp	.L92
.L106:
	movq	sp0.132(%rip), %rdx
.L83:
	movq	sp1.131(%rip), %rcx
.L86:
	movq	sp2.130(%rip), %rsi
.L98:
	movq	sp3.129(%rip), %r8
.L89:
	movq	sp4.128(%rip), %r9
.L92:
	movq	sp5.127(%rip), %r10
	jmp	.L95
.L81:
	movq	16(%rsi), %rdx
	movq	24(%rsi), %rcx
.L84:
	movq	32(%r11), %rsi
.L87:
	movq	40(%r11), %r8
	movq	48(%r11), %r9
.L90:
	movq	56(%r11), %r10
.L95:
	leaq	-1(%rdi), %rax
	testq	%rdi, %rdi
	je	.L94
.L93:
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %r10
	subq	$1, %rax
	cmpq	$-1, %rax
	jne	.L93
.L94:
	movq	%rdx, sp0.132(%rip)
	movq	%rcx, sp1.131(%rip)
	movq	%rsi, sp2.130(%rip)
	movq	%r8, sp3.129(%rip)
	movq	%r9, sp4.128(%rip)
	movq	%r10, sp5.127(%rip)
	movq	(%r11), %rax
	movq	%rax, addr_save.133(%rip)
	movl	$1, mem_benchmark_rerun(%rip)
	ret
	.cfi_endproc
.LFE77:
	.size	mem_benchmark_5, .-mem_benchmark_5
	.globl	mem_benchmark_6
	.type	mem_benchmark_6, @function
mem_benchmark_6:
.LFB78:
	.cfi_startproc
	endbr64
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movq	%rsi, %rbx
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L108
	movq	addr_save.126(%rip), %rdx
	cmpq	%rdx, (%rsi)
	je	.L138
	movq	16(%rsi), %rdx
	movq	addr_save.126(%rip), %rcx
	cmpq	%rcx, (%rsi)
	je	.L110
	movq	24(%rbx), %rcx
	testl	%eax, %eax
	je	.L111
	movq	addr_save.126(%rip), %rsi
	cmpq	%rsi, (%rbx)
	je	.L113
	movq	32(%rbx), %rsi
	testl	%eax, %eax
	je	.L114
	movq	addr_save.126(%rip), %r11
	cmpq	%r11, (%rbx)
	je	.L116
	movq	40(%rbx), %r8
	testl	%eax, %eax
	je	.L117
	movq	addr_save.126(%rip), %r11
	cmpq	%r11, (%rbx)
	je	.L128
	movq	48(%rbx), %r9
	movq	addr_save.126(%rip), %r11
	cmpq	%r11, (%rbx)
	je	.L119
	movq	56(%rbx), %r10
	testl	%eax, %eax
	je	.L120
	movq	addr_save.126(%rip), %rax
	cmpq	%rax, (%rbx)
	jne	.L120
	jmp	.L122
.L138:
	movq	sp0.125(%rip), %rdx
.L110:
	movq	sp1.124(%rip), %rcx
.L113:
	movq	sp2.123(%rip), %rsi
.L116:
	movq	sp3.122(%rip), %r8
.L128:
	movq	sp4.121(%rip), %r9
.L119:
	movq	sp5.120(%rip), %r10
.L122:
	movq	sp6.119(%rip), %r11
	jmp	.L125
.L108:
	movq	16(%rsi), %rdx
	movq	24(%rsi), %rcx
.L111:
	movq	32(%rbx), %rsi
.L114:
	movq	40(%rbx), %r8
.L117:
	movq	48(%rbx), %r9
	movq	56(%rbx), %r10
.L120:
	movq	64(%rbx), %r11
.L125:
	leaq	-1(%rdi), %rax
	testq	%rdi, %rdi
	je	.L124
.L123:
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %r11
	subq	$1, %rax
	cmpq	$-1, %rax
	jne	.L123
.L124:
	movq	%rdx, sp0.125(%rip)
	movq	%rcx, sp1.124(%rip)
	movq	%rsi, sp2.123(%rip)
	movq	%r8, sp3.122(%rip)
	movq	%r9, sp4.121(%rip)
	movq	%r10, sp5.120(%rip)
	movq	%r11, sp6.119(%rip)
	movq	(%rbx), %rax
	movq	%rax, addr_save.126(%rip)
	movl	$1, mem_benchmark_rerun(%rip)
	popq	%rbx
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE78:
	.size	mem_benchmark_6, .-mem_benchmark_6
	.globl	mem_benchmark_7
	.type	mem_benchmark_7, @function
mem_benchmark_7:
.LFB79:
	.cfi_startproc
	endbr64
	pushq	%r12
	.cfi_def_cfa_offset 16
	.cfi_offset 12, -16
	pushq	%rbp
	.cfi_def_cfa_offset 24
	.cfi_offset 6, -24
	pushq	%rbx
	.cfi_def_cfa_offset 32
	.cfi_offset 3, -32
	movq	%rsi, %r12
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L140
	movq	addr_save.118(%rip), %rbx
	movq	sp0.117(%rip), %rdx
	cmpq	%rbx, (%rsi)
	je	.L142
	movq	16(%rsi), %rdx
	movq	addr_save.118(%rip), %rbx
	cmpq	%rbx, (%rsi)
	je	.L142
	movq	24(%r12), %rcx
	testl	%eax, %eax
	je	.L143
	movq	addr_save.118(%rip), %rbx
	cmpq	%rbx, (%r12)
	je	.L145
	movq	32(%r12), %rsi
	testl	%eax, %eax
	je	.L146
	movq	addr_save.118(%rip), %rbx
	cmpq	%rbx, (%r12)
	je	.L148
	movq	40(%r12), %r8
	testl	%eax, %eax
	je	.L149
	movq	addr_save.118(%rip), %rbx
	cmpq	%rbx, (%r12)
	je	.L163
	movq	48(%r12), %r9
	movq	addr_save.118(%rip), %rbx
	cmpq	%rbx, (%r12)
	je	.L151
	movq	56(%r12), %r10
	testl	%eax, %eax
	je	.L152
	movq	addr_save.118(%rip), %rax
	cmpq	%rax, (%r12)
	je	.L160
	movq	64(%r12), %r11
	movq	addr_save.118(%rip), %rax
	cmpq	%rax, (%r12)
	jne	.L158
	jmp	.L154
.L142:
	movq	sp1.116(%rip), %rcx
.L145:
	movq	sp2.115(%rip), %rsi
.L148:
	movq	sp3.114(%rip), %r8
.L163:
	movq	sp4.113(%rip), %r9
.L151:
	movq	sp5.112(%rip), %r10
.L160:
	movq	sp6.111(%rip), %r11
.L154:
	movq	sp7.110(%rip), %rbx
	jmp	.L157
.L140:
	movq	16(%rsi), %rdx
	movq	24(%rsi), %rcx
.L143:
	movq	32(%r12), %rsi
.L146:
	movq	40(%r12), %r8
.L149:
	movq	48(%r12), %r9
	movq	56(%r12), %r10
.L152:
	movq	64(%r12), %r11
.L158:
	movq	72(%r12), %rbx
.L157:
	leaq	-1(%rdi), %rax
	testq	%rdi, %rdi
	je	.L156
.L155:
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %rdi
	movq	(%rbx), %r11
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rbx
	movq	(%r11), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r11
	movq	(%rbx), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %rbx
	movq	(%r11), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r11
	movq	(%rbx), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rbx
	movq	(%r11), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %r11
	movq	(%rbx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rbx
	movq	(%r11), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %r11
	movq	(%rbx), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %rbx
	movq	(%r11), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r11
	movq	(%rbx), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %rbx
	movq	(%r11), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %r11
	movq	(%rbx), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rbx
	movq	(%r11), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %r11
	movq	(%rbx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rbx
	movq	(%r11), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r11
	movq	(%rbx), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %rbx
	movq	(%r11), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r11
	movq	(%rbx), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rbx
	movq	(%r11), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %r11
	movq	(%rbx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rbx
	movq	(%r11), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %r11
	movq	(%rbx), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %rbx
	movq	(%r11), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r11
	movq	(%rbx), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %rbx
	movq	(%r11), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %r11
	movq	(%rbx), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rbx
	movq	(%r11), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %r11
	movq	(%rbx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rbx
	movq	(%r11), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r11
	movq	(%rbx), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %rbx
	movq	(%r11), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r11
	movq	(%rbx), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rbx
	movq	(%r11), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %r11
	movq	(%rbx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rbx
	movq	(%r11), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %r11
	movq	(%rbx), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %rbx
	movq	(%r11), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r11
	movq	(%rbx), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %rbx
	movq	(%r11), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %r11
	movq	(%rbx), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rbx
	movq	(%r11), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %r11
	movq	(%rbx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rbx
	movq	(%r11), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r11
	movq	(%rbx), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %rbx
	movq	(%r11), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r11
	movq	(%rbx), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rbx
	movq	(%r11), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %r11
	movq	(%rbx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rbx
	movq	(%r11), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %r11
	movq	(%rbx), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %rbx
	movq	(%r11), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r11
	movq	(%rbx), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %rbx
	movq	(%r11), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %r11
	movq	(%rbx), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rbx
	movq	(%r11), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %r11
	movq	(%rbx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rbx
	movq	(%r11), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r11
	movq	(%rbx), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %rbx
	movq	(%r11), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r11
	movq	(%rbx), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rbx
	movq	(%r11), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %r11
	movq	(%rbx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rbx
	movq	(%r11), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %r11
	movq	(%rbx), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %rbx
	movq	(%r11), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r11
	movq	(%rbx), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %rbx
	movq	(%r11), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %r11
	movq	(%rbx), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rbx
	movq	(%r11), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %r11
	movq	(%rbx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rbx
	movq	(%r11), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r11
	movq	(%rbx), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %rbx
	movq	(%r11), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r11
	movq	(%rbx), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rbx
	movq	(%r11), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %r11
	movq	(%rbx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rbx
	movq	(%r11), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %r11
	movq	(%rbx), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %rbx
	movq	(%r11), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r11
	movq	(%rbx), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %rbx
	movq	(%r11), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %r11
	movq	(%rbx), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rbx
	movq	(%r11), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %r11
	movq	(%rbx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rbx
	movq	(%r11), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r11
	movq	(%rbx), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %rbx
	movq	(%r11), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r11
	movq	(%rbx), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rbx
	movq	(%r11), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %r11
	movq	(%rbx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rbx
	movq	(%r11), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %r11
	movq	(%rbx), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %rbx
	movq	(%r11), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r11
	movq	(%rbx), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %rbx
	movq	(%r11), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %r11
	movq	(%rbx), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rbx
	movq	(%r11), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %r11
	movq	(%rbx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rbx
	movq	(%r11), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r11
	movq	(%rbx), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %rbx
	movq	(%r11), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r11
	movq	(%rbx), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rbx
	movq	(%r11), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %r11
	movq	(%rbx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rbx
	movq	(%r11), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %r11
	movq	(%rbx), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %rbx
	movq	(%r11), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r11
	movq	(%rbx), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %rbx
	movq	(%r11), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %r11
	movq	(%rbx), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rbx
	movq	(%r11), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %rdi
	movq	(%rdx), %rbp
	movq	(%rbx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%rdi), %r11
	movq	0(%rbp), %rbx
	subq	$1, %rax
	cmpq	$-1, %rax
	jne	.L155
.L156:
	movq	%rdx, sp0.117(%rip)
	movq	%rcx, sp1.116(%rip)
	movq	%rsi, sp2.115(%rip)
	movq	%r8, sp3.114(%rip)
	movq	%r9, sp4.113(%rip)
	movq	%r10, sp5.112(%rip)
	movq	%r11, sp6.111(%rip)
	movq	%rbx, sp7.110(%rip)
	movq	(%r12), %rax
	movq	%rax, addr_save.118(%rip)
	movl	$1, mem_benchmark_rerun(%rip)
	popq	%rbx
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE79:
	.size	mem_benchmark_7, .-mem_benchmark_7
	.globl	mem_benchmark_8
	.type	mem_benchmark_8, @function
mem_benchmark_8:
.LFB80:
	.cfi_startproc
	endbr64
	pushq	%r14
	.cfi_def_cfa_offset 16
	.cfi_offset 14, -16
	pushq	%r13
	.cfi_def_cfa_offset 24
	.cfi_offset 13, -24
	pushq	%r12
	.cfi_def_cfa_offset 32
	.cfi_offset 12, -32
	pushq	%rbp
	.cfi_def_cfa_offset 40
	.cfi_offset 6, -40
	pushq	%rbx
	.cfi_def_cfa_offset 48
	.cfi_offset 3, -48
	movq	%rsi, %r14
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L174
	movq	addr_save.109(%rip), %rbx
	movq	sp0.108(%rip), %rdx
	cmpq	%rbx, (%rsi)
	je	.L176
	movq	16(%rsi), %rdx
	movq	addr_save.109(%rip), %rbx
	cmpq	%rbx, (%rsi)
	je	.L176
	movq	24(%r14), %rcx
	testl	%eax, %eax
	je	.L177
	movq	addr_save.109(%rip), %rbx
	cmpq	%rbx, (%r14)
	je	.L179
	movq	32(%r14), %rsi
	testl	%eax, %eax
	je	.L180
	movq	addr_save.109(%rip), %rbx
	cmpq	%rbx, (%r14)
	je	.L182
	movq	40(%r14), %r8
	testl	%eax, %eax
	je	.L183
	movq	addr_save.109(%rip), %rbx
	cmpq	%rbx, (%r14)
	je	.L185
	movq	48(%r14), %r9
	testl	%eax, %eax
	je	.L186
	movq	addr_save.109(%rip), %rbx
	cmpq	%rbx, (%r14)
	je	.L200
	movq	56(%r14), %r10
	movq	addr_save.109(%rip), %rbx
	cmpq	%rbx, (%r14)
	je	.L188
	movq	64(%r14), %r11
	testl	%eax, %eax
	je	.L189
	movq	addr_save.109(%rip), %rax
	cmpq	%rax, (%r14)
	je	.L197
	movq	72(%r14), %rbx
	movq	addr_save.109(%rip), %rax
	cmpq	%rax, (%r14)
	jne	.L195
	jmp	.L191
.L176:
	movq	sp1.107(%rip), %rcx
.L179:
	movq	sp2.106(%rip), %rsi
.L182:
	movq	sp3.105(%rip), %r8
.L185:
	movq	sp4.104(%rip), %r9
.L200:
	movq	sp5.103(%rip), %r10
.L188:
	movq	sp6.102(%rip), %r11
.L197:
	movq	sp7.101(%rip), %rbx
.L191:
	movq	sp8.100(%rip), %rbp
	jmp	.L194
.L174:
	movq	16(%rsi), %rdx
	movq	24(%rsi), %rcx
.L177:
	movq	32(%r14), %rsi
.L180:
	movq	40(%r14), %r8
.L183:
	movq	48(%r14), %r9
.L186:
	movq	56(%r14), %r10
	movq	64(%r14), %r11
.L189:
	movq	72(%r14), %rbx
.L195:
	movq	80(%r14), %rbp
.L194:
	leaq	-1(%rdi), %rax
	testq	%rdi, %rdi
	je	.L193
.L192:
	movq	(%rdx), %r12
	movq	(%rcx), %r13
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %rdi
	movq	(%r11), %rdx
	movq	(%rbx), %rcx
	movq	0(%rbp), %r10
	movq	(%r12), %r11
	movq	0(%r13), %rbx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rbp
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r10), %r10
	movq	(%r11), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r10), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %rbp
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rbx
	movq	0(%rbp), %rbp
	movq	(%r10), %r10
	movq	(%r11), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r10), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rbp
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %rbx
	movq	0(%rbp), %rbp
	movq	(%r10), %r10
	movq	(%r11), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r10), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rbp
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r10), %r10
	movq	(%r11), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r10), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %rbp
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rbx
	movq	0(%rbp), %rbp
	movq	(%r10), %r10
	movq	(%r11), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r10), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rbp
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %rbx
	movq	0(%rbp), %rbp
	movq	(%r10), %r10
	movq	(%r11), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r10), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rbp
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r10), %r10
	movq	(%r11), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r10), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %rbp
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rbx
	movq	0(%rbp), %rbp
	movq	(%r10), %r10
	movq	(%r11), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r10), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rbp
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %rbx
	movq	0(%rbp), %rbp
	movq	(%r10), %r10
	movq	(%r11), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r10), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rbp
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r10), %r10
	movq	(%r11), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r10), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %rbp
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rbx
	movq	0(%rbp), %rbp
	movq	(%r10), %r10
	movq	(%r11), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r10), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rbp
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %rbx
	movq	0(%rbp), %rbp
	movq	(%r10), %r10
	movq	(%r11), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r10), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rbp
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r10), %r10
	movq	(%r11), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r10), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %rbp
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rbx
	movq	0(%rbp), %rbp
	movq	(%r10), %r10
	movq	(%r11), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r10), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rbp
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %rbx
	movq	0(%rbp), %rbp
	movq	(%r10), %r10
	movq	(%r11), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r10), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rbp
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r10), %r10
	movq	(%r11), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r10), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %rbp
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rbx
	movq	0(%rbp), %rbp
	movq	(%r10), %r10
	movq	(%r11), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r10), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rbp
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %rbx
	movq	0(%rbp), %rbp
	movq	(%r10), %r10
	movq	(%r11), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r10), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rbp
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r10), %r10
	movq	(%r11), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r10), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %rbp
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rbx
	movq	0(%rbp), %rbp
	movq	(%r10), %r10
	movq	(%r11), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r10), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rbp
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %rbx
	movq	0(%rbp), %rbp
	movq	(%r10), %r10
	movq	(%r11), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r10), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rbp
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r10), %r10
	movq	(%r11), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r10), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %rbp
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rbx
	movq	0(%rbp), %rbp
	movq	(%r10), %r10
	movq	(%r11), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r10), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rbp
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %rbx
	movq	0(%rbp), %rbp
	movq	(%r10), %r10
	movq	(%r11), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r10), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rbp
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r10), %r10
	movq	(%r11), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r10), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %rbp
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rbx
	movq	0(%rbp), %rbp
	movq	(%r10), %r10
	movq	(%r11), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r10), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rbp
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %rbx
	movq	0(%rbp), %rbp
	movq	(%r10), %r10
	movq	(%r11), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r10), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rbp
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %rdi
	movq	(%rdx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r10), %r12
	movq	(%r11), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%rdi), %r10
	movq	(%rbx), %r11
	movq	0(%rbp), %rbx
	movq	(%r12), %rbp
	subq	$1, %rax
	cmpq	$-1, %rax
	jne	.L192
.L193:
	movq	%rdx, sp0.108(%rip)
	movq	%rcx, sp1.107(%rip)
	movq	%rsi, sp2.106(%rip)
	movq	%r8, sp3.105(%rip)
	movq	%r9, sp4.104(%rip)
	movq	%r10, sp5.103(%rip)
	movq	%r11, sp6.102(%rip)
	movq	%rbx, sp7.101(%rip)
	movq	%rbp, sp8.100(%rip)
	movq	(%r14), %rax
	movq	%rax, addr_save.109(%rip)
	movl	$1, mem_benchmark_rerun(%rip)
	popq	%rbx
	.cfi_def_cfa_offset 40
	popq	%rbp
	.cfi_def_cfa_offset 32
	popq	%r12
	.cfi_def_cfa_offset 24
	popq	%r13
	.cfi_def_cfa_offset 16
	popq	%r14
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE80:
	.size	mem_benchmark_8, .-mem_benchmark_8
	.globl	mem_benchmark_9
	.type	mem_benchmark_9, @function
mem_benchmark_9:
.LFB81:
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
	movq	%rdi, %r12
	movq	%rsi, -8(%rsp)
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L212
	movq	addr_save.99(%rip), %rcx
	cmpq	%rcx, (%rsi)
	je	.L253
	movq	-8(%rsp), %rcx
	movq	16(%rcx), %rdx
	movq	addr_save.99(%rip), %rsi
	cmpq	%rsi, (%rcx)
	je	.L214
	movq	-8(%rsp), %rcx
	movq	24(%rcx), %rcx
	testl	%eax, %eax
	je	.L215
	movq	-8(%rsp), %rdi
	movq	addr_save.99(%rip), %rsi
	cmpq	%rsi, (%rdi)
	je	.L217
	movq	32(%rdi), %rsi
	testl	%eax, %eax
	je	.L218
	movq	-8(%rsp), %rdi
	movq	addr_save.99(%rip), %rbx
	cmpq	%rbx, (%rdi)
	je	.L220
	movq	40(%rdi), %rdi
	testl	%eax, %eax
	je	.L221
	movq	-8(%rsp), %rbx
	movq	addr_save.99(%rip), %r14
	cmpq	%r14, (%rbx)
	je	.L223
	movq	48(%rbx), %r8
	testl	%eax, %eax
	je	.L224
	movq	-8(%rsp), %rbx
	movq	addr_save.99(%rip), %r15
	cmpq	%r15, (%rbx)
	je	.L226
	movq	56(%rbx), %r9
	testl	%eax, %eax
	je	.L227
	movq	-8(%rsp), %rbx
	movq	addr_save.99(%rip), %r14
	cmpq	%r14, (%rbx)
	je	.L241
	movq	-8(%rsp), %rbx
	movq	64(%rbx), %r10
	movq	addr_save.99(%rip), %r15
	cmpq	%r15, (%rbx)
	je	.L229
	movq	-8(%rsp), %rbx
	movq	72(%rbx), %r11
	testl	%eax, %eax
	je	.L230
	movq	-8(%rsp), %rax
	movq	addr_save.99(%rip), %rbx
	cmpq	%rbx, (%rax)
	je	.L238
	movq	-8(%rsp), %rax
	movq	80(%rax), %rbx
	movq	addr_save.99(%rip), %r14
	cmpq	%r14, (%rax)
	jne	.L236
	jmp	.L232
.L253:
	movq	sp0.98(%rip), %rdx
.L214:
	movq	sp1.97(%rip), %rcx
.L217:
	movq	sp2.96(%rip), %rsi
.L220:
	movq	sp3.95(%rip), %rdi
.L223:
	movq	sp4.94(%rip), %r8
.L226:
	movq	sp5.93(%rip), %r9
.L241:
	movq	sp6.92(%rip), %r10
.L229:
	movq	sp7.91(%rip), %r11
.L238:
	movq	sp8.90(%rip), %rbx
.L232:
	movq	sp9.89(%rip), %rbp
	jmp	.L235
.L212:
	movq	-8(%rsp), %rax
	movq	16(%rax), %rdx
	movq	24(%rax), %rcx
.L215:
	movq	-8(%rsp), %rax
	movq	32(%rax), %rsi
.L218:
	movq	-8(%rsp), %rax
	movq	40(%rax), %rdi
.L221:
	movq	-8(%rsp), %rax
	movq	48(%rax), %r8
.L224:
	movq	-8(%rsp), %rax
	movq	56(%rax), %r9
.L227:
	movq	-8(%rsp), %rax
	movq	64(%rax), %r10
	movq	72(%rax), %r11
.L230:
	movq	-8(%rsp), %rax
	movq	80(%rax), %rbx
.L236:
	movq	-8(%rsp), %rax
	movq	88(%rax), %rbp
.L235:
	leaq	-1(%r12), %rax
	testq	%r12, %r12
	je	.L234
.L233:
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%r8), %r12
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %r8
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rbp
	movq	(%r12), %r12
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rdi
	movq	(%r8), %r8
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %rsi
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%rdx), %rdx
	movq	(%rcx), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	(%r9), %r9
	movq	(%r10), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%rdx), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	(%r9), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%r8), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r8
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %r12
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rdi
	movq	(%r8), %r8
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rbp
	movq	(%r12), %r12
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rsi
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%rdx), %rdx
	movq	(%rcx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%rdx), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	(%r9), %r9
	movq	(%r10), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%r8), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	(%r9), %r8
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %rdi
	movq	(%r8), %r8
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %r12
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rsi
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%rdx), %rdx
	movq	(%rcx), %rbp
	movq	(%r12), %r12
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%rdx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%r8), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	(%r9), %r9
	movq	(%r10), %r8
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	(%r9), %rdi
	movq	(%r8), %r8
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %rsi
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%rdx), %rdx
	movq	(%rcx), %r12
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%rdx), %rbp
	movq	(%r12), %r12
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%r8), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r8
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	(%r9), %r9
	movq	(%r10), %rdi
	movq	(%r8), %r8
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	(%r9), %rsi
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%rdx), %rdx
	movq	(%rcx), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%rdx), %r12
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%r8), %rbp
	movq	(%r12), %r12
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %r8
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %rdi
	movq	(%r8), %r8
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	(%r9), %r9
	movq	(%r10), %rsi
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%rdx), %rdx
	movq	(%rcx), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	(%r9), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%rdx), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%r8), %r12
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %r8
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rbp
	movq	(%r12), %r12
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rdi
	movq	(%r8), %r8
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %rsi
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%rdx), %rdx
	movq	(%rcx), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	(%r9), %r9
	movq	(%r10), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%rdx), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	(%r9), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%r8), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r8
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %r12
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rdi
	movq	(%r8), %r8
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rbp
	movq	(%r12), %r12
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rsi
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%rdx), %rdx
	movq	(%rcx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%rdx), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	(%r9), %r9
	movq	(%r10), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%r8), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	(%r9), %r8
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %rdi
	movq	(%r8), %r8
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %r12
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rsi
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%rdx), %rdx
	movq	(%rcx), %rbp
	movq	(%r12), %r12
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%rdx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%r8), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	(%r9), %r9
	movq	(%r10), %r8
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	(%r9), %rdi
	movq	(%r8), %r8
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %rsi
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%rdx), %rdx
	movq	(%rcx), %r12
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%rdx), %rbp
	movq	(%r12), %r12
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%r8), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r8
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	(%r9), %r9
	movq	(%r10), %rdi
	movq	(%r8), %r8
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	(%r9), %rsi
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%rdx), %rdx
	movq	(%rcx), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%rdx), %r12
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%r8), %rbp
	movq	(%r12), %r12
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %r8
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %rdi
	movq	(%r8), %r8
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	(%r9), %r9
	movq	(%r10), %rsi
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%rdx), %rdx
	movq	(%rcx), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	(%r9), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%rdx), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%r8), %r12
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %r8
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rbp
	movq	(%r12), %r12
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rdi
	movq	(%r8), %r8
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %rsi
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%rdx), %rdx
	movq	(%rcx), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	(%r9), %r9
	movq	(%r10), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%rdx), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	(%r9), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%r8), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r8
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %r12
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rdi
	movq	(%r8), %r8
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rbp
	movq	(%r12), %r12
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rsi
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%rdx), %rdx
	movq	(%rcx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%rdx), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	(%r9), %r9
	movq	(%r10), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%r8), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	(%r9), %r8
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %rdi
	movq	(%r8), %r8
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %r12
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rsi
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%rdx), %rdx
	movq	(%rcx), %rbp
	movq	(%r12), %r12
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%rdx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%r8), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	(%r9), %r9
	movq	(%r10), %r8
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	(%r9), %rdi
	movq	(%r8), %r8
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %rsi
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%rdx), %rdx
	movq	(%rcx), %r12
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%rdx), %rbp
	movq	(%r12), %r12
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%r8), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r8
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	(%r9), %r9
	movq	(%r10), %rdi
	movq	(%r8), %r8
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	(%r9), %rsi
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%rdx), %rdx
	movq	(%rcx), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%rdx), %r12
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%r8), %rbp
	movq	(%r12), %r12
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %r8
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %rdi
	movq	(%r8), %r8
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	(%r9), %r9
	movq	(%r10), %rsi
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%rdx), %rdx
	movq	(%rcx), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	(%r9), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%rdx), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%r8), %r12
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %r8
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rbp
	movq	(%r12), %r12
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rdi
	movq	(%r8), %r8
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %rsi
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%rdx), %rdx
	movq	(%rcx), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	(%r9), %r9
	movq	(%r10), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%rdx), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	(%r9), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%r8), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r8
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %r12
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rdi
	movq	(%r8), %r8
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rbp
	movq	(%r12), %r12
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rsi
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%rdx), %rdx
	movq	(%rcx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%rdx), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	(%r9), %r9
	movq	(%r10), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%r8), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	(%r9), %r8
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %rdi
	movq	(%r8), %r8
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %r12
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rsi
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%rdx), %rdx
	movq	(%rcx), %rbp
	movq	(%r12), %r12
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%rdx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%r8), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	(%r9), %r9
	movq	(%r10), %r8
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	(%r9), %rdi
	movq	(%r8), %r8
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %rsi
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%rdx), %rdx
	movq	(%rcx), %r12
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%rdx), %rbp
	movq	(%r12), %r12
	movq	(%r9), %r13
	movq	(%r10), %r14
	movq	(%r11), %r15
	movq	(%rbx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	0(%rbp), %r9
	movq	(%r12), %r10
	movq	0(%r13), %r11
	movq	(%r14), %rbx
	movq	(%r15), %rbp
	subq	$1, %rax
	cmpq	$-1, %rax
	jne	.L233
.L234:
	movq	%rdx, sp0.98(%rip)
	movq	%rcx, sp1.97(%rip)
	movq	%rsi, sp2.96(%rip)
	movq	%rdi, sp3.95(%rip)
	movq	%r8, sp4.94(%rip)
	movq	%r9, sp5.93(%rip)
	movq	%r10, sp6.92(%rip)
	movq	%r11, sp7.91(%rip)
	movq	%rbx, sp8.90(%rip)
	movq	%rbp, sp9.89(%rip)
	movq	-8(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, addr_save.99(%rip)
	movl	$1, mem_benchmark_rerun(%rip)
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
	.cfi_endproc
.LFE81:
	.size	mem_benchmark_9, .-mem_benchmark_9
	.globl	mem_benchmark_10
	.type	mem_benchmark_10, @function
mem_benchmark_10:
.LFB82:
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
	movq	%rdi, %r13
	movq	%rsi, -8(%rsp)
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L255
	movq	addr_save.88(%rip), %rcx
	cmpq	%rcx, (%rsi)
	je	.L299
	movq	-8(%rsp), %rcx
	movq	16(%rcx), %rdx
	movq	addr_save.88(%rip), %rsi
	cmpq	%rsi, (%rcx)
	je	.L257
	movq	-8(%rsp), %rcx
	movq	24(%rcx), %rcx
	testl	%eax, %eax
	je	.L258
	movq	-8(%rsp), %rsi
	movq	addr_save.88(%rip), %rdi
	cmpq	%rdi, (%rsi)
	je	.L260
	movq	32(%rsi), %rsi
	testl	%eax, %eax
	je	.L261
	movq	-8(%rsp), %rdi
	movq	addr_save.88(%rip), %rbx
	cmpq	%rbx, (%rdi)
	je	.L263
	movq	40(%rdi), %rdi
	testl	%eax, %eax
	je	.L264
	movq	-8(%rsp), %rbx
	movq	addr_save.88(%rip), %r15
	cmpq	%r15, (%rbx)
	je	.L266
	movq	48(%rbx), %r8
	testl	%eax, %eax
	je	.L267
	movq	-8(%rsp), %rbx
	movq	addr_save.88(%rip), %r15
	cmpq	%r15, (%rbx)
	je	.L287
	movq	-8(%rsp), %rbx
	movq	56(%rbx), %r9
	movq	addr_save.88(%rip), %r15
	cmpq	%r15, (%rbx)
	je	.L269
	movq	-8(%rsp), %rbx
	movq	64(%rbx), %r10
	testl	%eax, %eax
	je	.L270
	movq	-8(%rsp), %rbx
	movq	addr_save.88(%rip), %r15
	cmpq	%r15, (%rbx)
	je	.L284
	movq	-8(%rsp), %rbx
	movq	72(%rbx), %r11
	movq	addr_save.88(%rip), %r15
	cmpq	%r15, (%rbx)
	je	.L272
	movq	-8(%rsp), %rbx
	movq	80(%rbx), %rbx
	testl	%eax, %eax
	je	.L273
	movq	-8(%rsp), %rax
	movq	addr_save.88(%rip), %r15
	cmpq	%r15, (%rax)
	je	.L281
	movq	-8(%rsp), %rax
	movq	88(%rax), %rbp
	movq	addr_save.88(%rip), %r15
	cmpq	%r15, (%rax)
	jne	.L279
	jmp	.L275
.L299:
	movq	sp0.87(%rip), %rdx
.L257:
	movq	sp1.86(%rip), %rcx
.L260:
	movq	sp2.85(%rip), %rsi
.L263:
	movq	sp3.84(%rip), %rdi
.L266:
	movq	sp4.83(%rip), %r8
.L287:
	movq	sp5.82(%rip), %r9
.L269:
	movq	sp6.81(%rip), %r10
.L284:
	movq	sp7.80(%rip), %r11
.L272:
	movq	sp8.79(%rip), %rbx
.L281:
	movq	sp9.78(%rip), %rbp
.L275:
	movq	sp10.77(%rip), %r12
	jmp	.L278
.L255:
	movq	-8(%rsp), %rax
	movq	16(%rax), %rdx
	movq	24(%rax), %rcx
.L258:
	movq	-8(%rsp), %rax
	movq	32(%rax), %rsi
.L261:
	movq	-8(%rsp), %rax
	movq	40(%rax), %rdi
.L264:
	movq	-8(%rsp), %rax
	movq	48(%rax), %r8
.L267:
	movq	-8(%rsp), %rax
	movq	56(%rax), %r9
	movq	64(%rax), %r10
.L270:
	movq	-8(%rsp), %rax
	movq	72(%rax), %r11
	movq	80(%rax), %rbx
.L273:
	movq	-8(%rsp), %rax
	movq	88(%rax), %rbp
.L279:
	movq	-8(%rsp), %rax
	movq	96(%rax), %r12
.L278:
	leaq	-1(%r13), %rax
	testq	%r13, %r13
	je	.L277
.L276:
	movq	(%rdx), %r14
	movq	(%rcx), %r13
	movq	(%rsi), %r15
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rdx
	movq	(%r12), %rcx
	movq	(%r14), %rsi
	movq	0(%r13), %rbp
	movq	(%r15), %r12
	movq	(%rdi), %r13
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r8), %r8
	movq	(%r9), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r8), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %r13
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %r12
	movq	0(%r13), %r13
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r8), %r8
	movq	(%r9), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r8), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %r13
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %r12
	movq	0(%r13), %r13
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r8), %r8
	movq	(%r9), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r8), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %r13
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %r12
	movq	0(%r13), %r13
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r8), %r8
	movq	(%r9), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r8), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %r13
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %r12
	movq	0(%r13), %r13
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r8), %r8
	movq	(%r9), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r8), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %r13
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %r12
	movq	0(%r13), %r13
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r8), %r8
	movq	(%r9), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r8), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %r13
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %r12
	movq	0(%r13), %r13
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r8), %r8
	movq	(%r9), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r8), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %r13
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %r12
	movq	0(%r13), %r13
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r8), %r8
	movq	(%r9), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r8), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %r13
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %r12
	movq	0(%r13), %r13
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r8), %r8
	movq	(%r9), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r8), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %r13
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %r12
	movq	0(%r13), %r13
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r8), %r8
	movq	(%r9), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r8), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %r13
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %r12
	movq	0(%r13), %r13
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r8), %r8
	movq	(%r9), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r8), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %r13
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %r12
	movq	0(%r13), %r13
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r8), %r8
	movq	(%r9), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r8), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %r13
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %r12
	movq	0(%r13), %r13
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r8), %r8
	movq	(%r9), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r8), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %r13
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %r12
	movq	0(%r13), %r13
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %rdx
	movq	(%rcx), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%rdx), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r8), %r14
	movq	(%r9), %rdx
	movq	(%rcx), %rcx
	movq	(%rsi), %rsi
	movq	(%rdi), %rdi
	movq	(%r10), %r8
	movq	(%r11), %r9
	movq	(%rbx), %r10
	movq	0(%rbp), %r11
	movq	(%r12), %rbx
	movq	0(%r13), %rbp
	movq	(%r14), %r12
	subq	$1, %rax
	cmpq	$-1, %rax
	jne	.L276
.L277:
	movq	%rdx, sp0.87(%rip)
	movq	%rcx, sp1.86(%rip)
	movq	%rsi, sp2.85(%rip)
	movq	%rdi, sp3.84(%rip)
	movq	%r8, sp4.83(%rip)
	movq	%r9, sp5.82(%rip)
	movq	%r10, sp6.81(%rip)
	movq	%r11, sp7.80(%rip)
	movq	%rbx, sp8.79(%rip)
	movq	%rbp, sp9.78(%rip)
	movq	%r12, sp10.77(%rip)
	movq	-8(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, addr_save.88(%rip)
	movl	$1, mem_benchmark_rerun(%rip)
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
	.cfi_endproc
.LFE82:
	.size	mem_benchmark_10, .-mem_benchmark_10
	.globl	mem_benchmark_11
	.type	mem_benchmark_11, @function
mem_benchmark_11:
.LFB83:
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
	movq	%rdi, %r15
	movq	%rsi, %rdx
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L301
	movq	addr_save.76(%rip), %rcx
	movq	sp0.75(%rip), %rsi
	cmpq	%rcx, (%rdx)
	je	.L303
	movq	16(%rdx), %rsi
	movq	addr_save.76(%rip), %rcx
	cmpq	%rcx, (%rdx)
	je	.L303
	movq	24(%rdx), %rcx
	testl	%eax, %eax
	je	.L304
	movq	addr_save.76(%rip), %rbx
	cmpq	%rbx, (%rdx)
	je	.L306
	movq	32(%rdx), %rdi
	testl	%eax, %eax
	je	.L307
	movq	addr_save.76(%rip), %rbx
	cmpq	%rbx, (%rdx)
	je	.L309
	movq	40(%rdx), %r8
	testl	%eax, %eax
	je	.L310
	movq	addr_save.76(%rip), %rbx
	cmpq	%rbx, (%rdx)
	je	.L312
	movq	48(%rdx), %r9
	testl	%eax, %eax
	je	.L313
	movq	addr_save.76(%rip), %rbx
	cmpq	%rbx, (%rdx)
	je	.L315
	movq	56(%rdx), %r10
	testl	%eax, %eax
	je	.L316
	movq	addr_save.76(%rip), %rbx
	cmpq	%rbx, (%rdx)
	je	.L336
	movq	64(%rdx), %r11
	movq	addr_save.76(%rip), %rbx
	cmpq	%rbx, (%rdx)
	je	.L318
	movq	72(%rdx), %rbx
	testl	%eax, %eax
	je	.L319
	movq	addr_save.76(%rip), %r14
	cmpq	%r14, (%rdx)
	je	.L333
	movq	80(%rdx), %rbp
	movq	addr_save.76(%rip), %r14
	cmpq	%r14, (%rdx)
	je	.L321
	movq	88(%rdx), %r12
	testl	%eax, %eax
	je	.L322
	movq	addr_save.76(%rip), %rax
	cmpq	%rax, (%rdx)
	je	.L330
	movq	96(%rdx), %r13
	movq	addr_save.76(%rip), %rax
	cmpq	%rax, (%rdx)
	jne	.L328
	jmp	.L324
.L303:
	movq	sp1.74(%rip), %rcx
.L306:
	movq	sp2.73(%rip), %rdi
.L309:
	movq	sp3.72(%rip), %r8
.L312:
	movq	sp4.71(%rip), %r9
.L315:
	movq	sp5.70(%rip), %r10
.L336:
	movq	sp6.69(%rip), %r11
.L318:
	movq	sp7.68(%rip), %rbx
.L333:
	movq	sp8.67(%rip), %rbp
.L321:
	movq	sp9.66(%rip), %r12
.L330:
	movq	sp10.65(%rip), %r13
.L324:
	movq	sp11.64(%rip), %r14
	jmp	.L327
.L301:
	movq	16(%rsi), %rsi
	movq	24(%rdx), %rcx
.L304:
	movq	32(%rdx), %rdi
.L307:
	movq	40(%rdx), %r8
.L310:
	movq	48(%rdx), %r9
.L313:
	movq	56(%rdx), %r10
.L316:
	movq	64(%rdx), %r11
	movq	72(%rdx), %rbx
.L319:
	movq	80(%rdx), %rbp
	movq	88(%rdx), %r12
.L322:
	movq	96(%rdx), %r13
.L328:
	movq	104(%rdx), %r14
.L327:
	leaq	-1(%r15), %rax
	testq	%r15, %r15
	je	.L326
.L325:
	movq	(%rsi), %rsi
	movq	(%rcx), %r15
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r14), %rcx
	movq	(%rsi), %r14
	movq	(%r15), %r15
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %rsi
	movq	(%rcx), %r13
	movq	(%r14), %r14
	movq	(%r15), %r15
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %rcx
	movq	(%rsi), %r12
	movq	0(%r13), %r13
	movq	(%r14), %r14
	movq	(%r15), %r15
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rsi
	movq	(%rcx), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r14), %r14
	movq	(%r15), %r15
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rcx
	movq	(%rsi), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r14), %r14
	movq	(%r15), %r15
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %rsi
	movq	(%rcx), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r14), %r14
	movq	(%r15), %r15
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %rcx
	movq	(%rsi), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r14), %r14
	movq	(%r15), %r15
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%r9), %rsi
	movq	(%rcx), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r14), %r14
	movq	(%r15), %r15
	movq	(%rdi), %rdi
	movq	(%r8), %rcx
	movq	(%rsi), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r14), %r14
	movq	(%r15), %r15
	movq	(%rdi), %rsi
	movq	(%rcx), %rdi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r14), %r14
	movq	(%r15), %rcx
	movq	(%rsi), %r15
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r14), %rsi
	movq	(%rcx), %r14
	movq	(%r15), %r15
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %rcx
	movq	(%rsi), %r13
	movq	(%r14), %r14
	movq	(%r15), %r15
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %rsi
	movq	(%rcx), %r12
	movq	0(%r13), %r13
	movq	(%r14), %r14
	movq	(%r15), %r15
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rcx
	movq	(%rsi), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r14), %r14
	movq	(%r15), %r15
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rsi
	movq	(%rcx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r14), %r14
	movq	(%r15), %r15
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %rcx
	movq	(%rsi), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r14), %r14
	movq	(%r15), %r15
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %rsi
	movq	(%rcx), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r14), %r14
	movq	(%r15), %r15
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%r9), %rcx
	movq	(%rsi), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r14), %r14
	movq	(%r15), %r15
	movq	(%rdi), %rdi
	movq	(%r8), %rsi
	movq	(%rcx), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r14), %r14
	movq	(%r15), %r15
	movq	(%rdi), %rcx
	movq	(%rsi), %rdi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r14), %r14
	movq	(%r15), %rsi
	movq	(%rcx), %r15
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r14), %rcx
	movq	(%rsi), %r14
	movq	(%r15), %r15
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %rsi
	movq	(%rcx), %r13
	movq	(%r14), %r14
	movq	(%r15), %r15
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %rcx
	movq	(%rsi), %r12
	movq	0(%r13), %r13
	movq	(%r14), %r14
	movq	(%r15), %r15
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rsi
	movq	(%rcx), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r14), %r14
	movq	(%r15), %r15
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rcx
	movq	(%rsi), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r14), %r14
	movq	(%r15), %r15
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %rsi
	movq	(%rcx), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r14), %r14
	movq	(%r15), %r15
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %rcx
	movq	(%rsi), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r14), %r14
	movq	(%r15), %r15
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%r9), %rsi
	movq	(%rcx), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r14), %r14
	movq	(%r15), %r15
	movq	(%rdi), %rdi
	movq	(%r8), %rcx
	movq	(%rsi), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r14), %r14
	movq	(%r15), %r15
	movq	(%rdi), %rsi
	movq	(%rcx), %rdi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r14), %r14
	movq	(%r15), %rcx
	movq	(%rsi), %r15
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r14), %rsi
	movq	(%rcx), %r14
	movq	(%r15), %r15
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %rcx
	movq	(%rsi), %r13
	movq	(%r14), %r14
	movq	(%r15), %r15
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %rsi
	movq	(%rcx), %r12
	movq	0(%r13), %r13
	movq	(%r14), %r14
	movq	(%r15), %r15
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rcx
	movq	(%rsi), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r14), %r14
	movq	(%r15), %r15
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rsi
	movq	(%rcx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r14), %r14
	movq	(%r15), %r15
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %rcx
	movq	(%rsi), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r14), %r14
	movq	(%r15), %r15
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %rsi
	movq	(%rcx), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r14), %r14
	movq	(%r15), %r15
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%r9), %rcx
	movq	(%rsi), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r14), %r14
	movq	(%r15), %r15
	movq	(%rdi), %rdi
	movq	(%r8), %rsi
	movq	(%rcx), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r14), %r14
	movq	(%r15), %r15
	movq	(%rdi), %rcx
	movq	(%rsi), %rdi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r14), %r14
	movq	(%r15), %rsi
	movq	(%rcx), %r15
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r14), %rcx
	movq	(%rsi), %r14
	movq	(%r15), %r15
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %rsi
	movq	(%rcx), %r13
	movq	(%r14), %r14
	movq	(%r15), %r15
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %rcx
	movq	(%rsi), %r12
	movq	0(%r13), %r13
	movq	(%r14), %r14
	movq	(%r15), %r15
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rsi
	movq	(%rcx), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r14), %r14
	movq	(%r15), %r15
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rcx
	movq	(%rsi), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r14), %r14
	movq	(%r15), %r15
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %rsi
	movq	(%rcx), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r14), %r14
	movq	(%r15), %r15
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %rcx
	movq	(%rsi), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r14), %r14
	movq	(%r15), %r15
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%r9), %rsi
	movq	(%rcx), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r14), %r14
	movq	(%r15), %r15
	movq	(%rdi), %rdi
	movq	(%r8), %rcx
	movq	(%rsi), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r14), %r14
	movq	(%r15), %r15
	movq	(%rdi), %rsi
	movq	(%rcx), %rdi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r14), %r14
	movq	(%r15), %rcx
	movq	(%rsi), %r15
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r14), %rsi
	movq	(%rcx), %r14
	movq	(%r15), %r15
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %rcx
	movq	(%rsi), %r13
	movq	(%r14), %r14
	movq	(%r15), %r15
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %rsi
	movq	(%rcx), %r12
	movq	0(%r13), %r13
	movq	(%r14), %r14
	movq	(%r15), %r15
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rcx
	movq	(%rsi), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r14), %r14
	movq	(%r15), %r15
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rsi
	movq	(%rcx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r14), %r14
	movq	(%r15), %r15
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %rcx
	movq	(%rsi), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r14), %r14
	movq	(%r15), %r15
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %rsi
	movq	(%rcx), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r14), %r14
	movq	(%r15), %r15
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%r9), %rcx
	movq	(%rsi), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r14), %r14
	movq	(%r15), %r15
	movq	(%rdi), %rdi
	movq	(%r8), %rsi
	movq	(%rcx), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r14), %r14
	movq	(%r15), %r15
	movq	(%rdi), %rcx
	movq	(%rsi), %rdi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r14), %r14
	movq	(%r15), %rsi
	movq	(%rcx), %r15
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r14), %rcx
	movq	(%rsi), %r14
	movq	(%r15), %r15
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %rsi
	movq	(%rcx), %r13
	movq	(%r14), %r14
	movq	(%r15), %r15
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %rcx
	movq	(%rsi), %r12
	movq	0(%r13), %r13
	movq	(%r14), %r14
	movq	(%r15), %r15
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rsi
	movq	(%rcx), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r14), %r14
	movq	(%r15), %r15
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rcx
	movq	(%rsi), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r14), %r14
	movq	(%r15), %r15
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %rsi
	movq	(%rcx), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r14), %r14
	movq	(%r15), %r15
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %rcx
	movq	(%rsi), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r14), %r14
	movq	(%r15), %r15
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%r9), %rsi
	movq	(%rcx), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r14), %r14
	movq	(%r15), %r15
	movq	(%rdi), %rdi
	movq	(%r8), %rcx
	movq	(%rsi), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r14), %r14
	movq	(%r15), %r15
	movq	(%rdi), %rsi
	movq	(%rcx), %rdi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r14), %r14
	movq	(%r15), %rcx
	movq	(%rsi), %r15
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r14), %rsi
	movq	(%rcx), %r14
	movq	(%r15), %r15
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %rcx
	movq	(%rsi), %r13
	movq	(%r14), %r14
	movq	(%r15), %r15
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %rsi
	movq	(%rcx), %r12
	movq	0(%r13), %r13
	movq	(%r14), %r14
	movq	(%r15), %r15
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rcx
	movq	(%rsi), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r14), %r14
	movq	(%r15), %r15
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rsi
	movq	(%rcx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r14), %r14
	movq	(%r15), %r15
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %rcx
	movq	(%rsi), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r14), %r14
	movq	(%r15), %r15
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %rsi
	movq	(%rcx), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r14), %r14
	movq	(%r15), %r15
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%r9), %rcx
	movq	(%rsi), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r14), %r14
	movq	(%r15), %r15
	movq	(%rdi), %rdi
	movq	(%r8), %rsi
	movq	(%rcx), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r14), %r14
	movq	(%r15), %r15
	movq	(%rdi), %rcx
	movq	(%rsi), %rdi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r14), %r14
	movq	(%r15), %rsi
	movq	(%rcx), %r15
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r14), %rcx
	movq	(%rsi), %r14
	movq	(%r15), %r15
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %rsi
	movq	(%rcx), %r13
	movq	(%r14), %r14
	movq	(%r15), %r15
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %rcx
	movq	(%rsi), %r12
	movq	0(%r13), %r13
	movq	(%r14), %r14
	movq	(%r15), %r15
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rsi
	movq	(%rcx), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r14), %r14
	movq	(%r15), %r15
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rcx
	movq	(%rsi), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r14), %r14
	movq	(%r15), %r15
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %rsi
	movq	(%rcx), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r14), %r14
	movq	(%r15), %r15
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %rcx
	movq	(%rsi), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r14), %r14
	movq	(%r15), %r15
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%r9), %rsi
	movq	(%rcx), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r14), %r14
	movq	(%r15), %r15
	movq	(%rdi), %rdi
	movq	(%r8), %rcx
	movq	(%rsi), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r14), %r14
	movq	(%r15), %r15
	movq	(%rdi), %rsi
	movq	(%rcx), %rdi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r14), %r14
	movq	(%r15), %rcx
	movq	(%rsi), %r15
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r14), %rsi
	movq	(%rcx), %r14
	movq	(%r15), %r15
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %rcx
	movq	(%rsi), %r13
	movq	(%r14), %r14
	movq	(%r15), %r15
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %rsi
	movq	(%rcx), %r12
	movq	0(%r13), %r13
	movq	(%r14), %r14
	movq	(%r15), %r15
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rcx
	movq	(%rsi), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r14), %r14
	movq	(%r15), %r15
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rsi
	movq	(%rcx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r14), %r14
	movq	(%r15), %r15
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %r10
	movq	(%r11), %rcx
	movq	(%rsi), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r14), %r14
	movq	(%r15), %r15
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%r9), %r9
	movq	(%r10), %rsi
	movq	(%rcx), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r14), %r14
	movq	(%r15), %r15
	movq	(%rdi), %rdi
	movq	(%r8), %r8
	movq	(%r9), %rcx
	movq	(%rsi), %r9
	movq	(%r10), %r10
	movq	(%r11), %r11
	movq	(%rbx), %rbx
	movq	0(%rbp), %rbp
	movq	(%r12), %r12
	movq	0(%r13), %r13
	movq	(%r14), %r14
	movq	(%r15), %r15
	movq	(%rdi), %rsi
	movq	%rsi, -8(%rsp)
	movq	(%r8), %rsi
	movq	(%rcx), %rcx
	movq	(%r9), %rdi
	movq	(%r10), %r8
	movq	(%r11), %r9
	movq	(%rbx), %r10
	movq	0(%rbp), %r11
	movq	(%r12), %rbx
	movq	0(%r13), %rbp
	movq	(%r14), %r12
	movq	(%r15), %r13
	movq	-8(%rsp), %r14
	movq	(%r14), %r14
	subq	$1, %rax
	cmpq	$-1, %rax
	jne	.L325
.L326:
	movq	%rsi, sp0.75(%rip)
	movq	%rcx, sp1.74(%rip)
	movq	%rdi, sp2.73(%rip)
	movq	%r8, sp3.72(%rip)
	movq	%r9, sp4.71(%rip)
	movq	%r10, sp5.70(%rip)
	movq	%r11, sp6.69(%rip)
	movq	%rbx, sp7.68(%rip)
	movq	%rbp, sp8.67(%rip)
	movq	%r12, sp9.66(%rip)
	movq	%r13, sp10.65(%rip)
	movq	%r14, sp11.64(%rip)
	movq	(%rdx), %rax
	movq	%rax, addr_save.76(%rip)
	movl	$1, mem_benchmark_rerun(%rip)
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
	.cfi_endproc
.LFE83:
	.size	mem_benchmark_11, .-mem_benchmark_11
	.globl	mem_benchmark_12
	.type	mem_benchmark_12, @function
mem_benchmark_12:
.LFB84:
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
	movq	%rdi, %rbp
	movq	%rsi, -8(%rsp)
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L350
	movq	addr_save.63(%rip), %rcx
	movq	sp0.62(%rip), %r12
	cmpq	%rcx, (%rsi)
	je	.L352
	movq	-8(%rsp), %rdx
	movq	16(%rdx), %r12
	movq	addr_save.63(%rip), %rcx
	cmpq	%rcx, (%rdx)
	je	.L352
	movq	-8(%rsp), %rdx
	movq	24(%rdx), %r13
	testl	%eax, %eax
	je	.L353
	movq	-8(%rsp), %rcx
	movq	addr_save.63(%rip), %rdx
	cmpq	%rdx, (%rcx)
	je	.L355
	movq	32(%rcx), %r15
	testl	%eax, %eax
	je	.L356
	movq	-8(%rsp), %rdx
	movq	addr_save.63(%rip), %rcx
	cmpq	%rcx, (%rdx)
	je	.L358
	movq	40(%rdx), %rcx
	movq	%rcx, -48(%rsp)
	testl	%eax, %eax
	je	.L359
	movq	-8(%rsp), %rcx
	movq	addr_save.63(%rip), %rdx
	cmpq	%rdx, (%rcx)
	je	.L361
	movq	48(%rcx), %rbx
	testl	%eax, %eax
	je	.L362
	movq	-8(%rsp), %rdx
	movq	addr_save.63(%rip), %rcx
	cmpq	%rcx, (%rdx)
	je	.L364
	movq	56(%rdx), %r11
	testl	%eax, %eax
	je	.L365
	movq	-8(%rsp), %rcx
	movq	addr_save.63(%rip), %rdx
	cmpq	%rdx, (%rcx)
	je	.L367
	movq	64(%rcx), %r10
	testl	%eax, %eax
	je	.L368
	movq	-8(%rsp), %rcx
	movq	addr_save.63(%rip), %rdx
	cmpq	%rdx, (%rcx)
	je	.L388
	movq	-8(%rsp), %rcx
	movq	72(%rcx), %r9
	movq	addr_save.63(%rip), %rdx
	cmpq	%rdx, (%rcx)
	je	.L370
	movq	-8(%rsp), %rcx
	movq	80(%rcx), %r8
	testl	%eax, %eax
	je	.L371
	movq	-8(%rsp), %rdx
	movq	addr_save.63(%rip), %rcx
	cmpq	%rcx, (%rdx)
	je	.L385
	movq	-8(%rsp), %rdx
	movq	88(%rdx), %rdi
	movq	addr_save.63(%rip), %rcx
	cmpq	%rcx, (%rdx)
	je	.L373
	movq	-8(%rsp), %rdx
	movq	96(%rdx), %rsi
	testl	%eax, %eax
	je	.L374
	movq	-8(%rsp), %rax
	movq	addr_save.63(%rip), %rdx
	cmpq	%rdx, (%rax)
	je	.L382
	movq	-8(%rsp), %rax
	movq	104(%rax), %rdx
	movq	addr_save.63(%rip), %rcx
	cmpq	%rcx, (%rax)
	jne	.L380
	jmp	.L376
.L352:
	movq	sp1.61(%rip), %r13
.L355:
	movq	sp2.60(%rip), %r15
.L358:
	movq	sp3.59(%rip), %rax
	movq	%rax, -48(%rsp)
.L361:
	movq	sp4.58(%rip), %rbx
.L364:
	movq	sp5.57(%rip), %r11
.L367:
	movq	sp6.56(%rip), %r10
.L388:
	movq	sp7.55(%rip), %r9
.L370:
	movq	sp8.54(%rip), %r8
.L385:
	movq	sp9.53(%rip), %rdi
.L373:
	movq	sp10.52(%rip), %rsi
.L382:
	movq	sp11.51(%rip), %rdx
.L376:
	movq	sp12.50(%rip), %rcx
	jmp	.L379
.L350:
	movq	-8(%rsp), %rax
	movq	16(%rax), %r12
	movq	24(%rax), %r13
.L353:
	movq	-8(%rsp), %rax
	movq	32(%rax), %r15
.L356:
	movq	-8(%rsp), %rax
	movq	40(%rax), %rax
	movq	%rax, -48(%rsp)
.L359:
	movq	-8(%rsp), %rax
	movq	48(%rax), %rbx
.L362:
	movq	-8(%rsp), %rax
	movq	56(%rax), %r11
.L365:
	movq	-8(%rsp), %rax
	movq	64(%rax), %r10
.L368:
	movq	-8(%rsp), %rax
	movq	72(%rax), %r9
	movq	80(%rax), %r8
.L371:
	movq	-8(%rsp), %rax
	movq	88(%rax), %rdi
	movq	96(%rax), %rsi
.L374:
	movq	-8(%rsp), %rax
	movq	104(%rax), %rdx
.L380:
	movq	-8(%rsp), %rax
	movq	112(%rax), %rcx
.L379:
	leaq	-1(%rbp), %rax
	testq	%rbp, %rbp
	je	.L378
.L377:
	movq	(%r12), %r14
	movq	0(%r13), %r13
	movq	(%r15), %r12
	movq	-48(%rsp), %r15
	movq	(%r15), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rdx), %rdx
	movq	(%rcx), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %rcx
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rdx), %r12
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %rdx
	movq	(%rcx), %r13
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%r12), %r12
	movq	(%r15), %r15
	movq	(%r14), %rcx
	movq	(%rdx), %r14
	movq	0(%r13), %r13
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%r12), %r12
	movq	(%r15), %rdx
	movq	(%rcx), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%r12), %rcx
	movq	(%rdx), %r12
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rdx
	movq	(%rcx), %rsi
	movq	(%r12), %r12
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rcx
	movq	(%rdx), %rdi
	movq	(%rsi), %rsi
	movq	(%r12), %r12
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %rdx
	movq	(%rcx), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%r12), %r12
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %rcx
	movq	(%rdx), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%r12), %r12
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %rdx
	movq	(%rcx), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%r12), %r12
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %rcx
	movq	(%rdx), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%r12), %r12
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	0(%rbp), %rbp
	movq	(%rbx), %rdx
	movq	(%rcx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%r12), %r12
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	0(%rbp), %rcx
	movq	(%rdx), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%r12), %r12
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %rdx
	movq	(%rcx), %r13
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%r12), %r12
	movq	(%r15), %r15
	movq	(%r14), %rcx
	movq	(%rdx), %r14
	movq	0(%r13), %r13
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%r12), %r12
	movq	(%r15), %rdx
	movq	(%rcx), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%r12), %rcx
	movq	(%rdx), %r12
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rdx
	movq	(%rcx), %rsi
	movq	(%r12), %r12
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rcx
	movq	(%rdx), %rdi
	movq	(%rsi), %rsi
	movq	(%r12), %r12
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %rdx
	movq	(%rcx), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%r12), %r12
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %rcx
	movq	(%rdx), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%r12), %r12
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %rdx
	movq	(%rcx), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%r12), %r12
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %rcx
	movq	(%rdx), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%r12), %r12
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	0(%rbp), %rbp
	movq	(%rbx), %rdx
	movq	(%rcx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%r12), %r12
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	0(%rbp), %rcx
	movq	(%rdx), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%r12), %r12
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %rdx
	movq	(%rcx), %r13
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%r12), %r12
	movq	(%r15), %r15
	movq	(%r14), %rcx
	movq	(%rdx), %r14
	movq	0(%r13), %r13
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%r12), %r12
	movq	(%r15), %rdx
	movq	(%rcx), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%r12), %rcx
	movq	(%rdx), %r12
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rdx
	movq	(%rcx), %rsi
	movq	(%r12), %r12
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rcx
	movq	(%rdx), %rdi
	movq	(%rsi), %rsi
	movq	(%r12), %r12
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %rdx
	movq	(%rcx), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%r12), %r12
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %rcx
	movq	(%rdx), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%r12), %r12
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %rdx
	movq	(%rcx), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%r12), %r12
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %rcx
	movq	(%rdx), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%r12), %r12
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	0(%rbp), %rbp
	movq	(%rbx), %rdx
	movq	(%rcx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%r12), %r12
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	0(%rbp), %rcx
	movq	(%rdx), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%r12), %r12
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %rdx
	movq	(%rcx), %r13
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%r12), %r12
	movq	(%r15), %r15
	movq	(%r14), %rcx
	movq	(%rdx), %r14
	movq	0(%r13), %r13
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%r12), %r12
	movq	(%r15), %rdx
	movq	(%rcx), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%r12), %rcx
	movq	(%rdx), %r12
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rdx
	movq	(%rcx), %rsi
	movq	(%r12), %r12
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rcx
	movq	(%rdx), %rdi
	movq	(%rsi), %rsi
	movq	(%r12), %r12
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %rdx
	movq	(%rcx), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%r12), %r12
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %rcx
	movq	(%rdx), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%r12), %r12
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %rdx
	movq	(%rcx), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%r12), %r12
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %rcx
	movq	(%rdx), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%r12), %r12
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	0(%rbp), %rbp
	movq	(%rbx), %rdx
	movq	(%rcx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%r12), %r12
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	0(%rbp), %rcx
	movq	(%rdx), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%r12), %r12
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %rdx
	movq	(%rcx), %r13
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%r12), %r12
	movq	(%r15), %r15
	movq	(%r14), %rcx
	movq	(%rdx), %r14
	movq	0(%r13), %r13
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%r12), %r12
	movq	(%r15), %rdx
	movq	(%rcx), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%r12), %rcx
	movq	(%rdx), %r12
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rdx
	movq	(%rcx), %rsi
	movq	(%r12), %r12
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rcx
	movq	(%rdx), %rdi
	movq	(%rsi), %rsi
	movq	(%r12), %r12
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %rdx
	movq	(%rcx), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%r12), %r12
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %rcx
	movq	(%rdx), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%r12), %r12
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %rdx
	movq	(%rcx), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%r12), %r12
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %rcx
	movq	(%rdx), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%r12), %r12
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	0(%rbp), %rbp
	movq	(%rbx), %rdx
	movq	(%rcx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%r12), %r12
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	0(%rbp), %rcx
	movq	(%rdx), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%r12), %r12
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %rdx
	movq	(%rcx), %r13
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%r12), %r12
	movq	(%r15), %r15
	movq	(%r14), %rcx
	movq	(%rdx), %r14
	movq	0(%r13), %r13
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%r12), %r12
	movq	(%r15), %rdx
	movq	(%rcx), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%r12), %rcx
	movq	(%rdx), %r12
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rdx
	movq	(%rcx), %rsi
	movq	(%r12), %r12
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rcx
	movq	(%rdx), %rdi
	movq	(%rsi), %rsi
	movq	(%r12), %r12
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %rdx
	movq	(%rcx), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%r12), %r12
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %rcx
	movq	(%rdx), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%r12), %r12
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %rdx
	movq	(%rcx), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%r12), %r12
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %rcx
	movq	(%rdx), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%r12), %r12
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	0(%rbp), %rbp
	movq	(%rbx), %rdx
	movq	(%rcx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%r12), %r12
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	0(%rbp), %rcx
	movq	(%rdx), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%r12), %r12
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %rdx
	movq	(%rcx), %r13
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%r12), %r12
	movq	(%r15), %r15
	movq	(%r14), %rcx
	movq	(%rdx), %r14
	movq	0(%r13), %r13
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%r12), %r12
	movq	(%r15), %rdx
	movq	(%rcx), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%r12), %rcx
	movq	(%rdx), %r12
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rdx
	movq	(%rcx), %rsi
	movq	(%r12), %r12
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rcx
	movq	(%rdx), %rdi
	movq	(%rsi), %rsi
	movq	(%r12), %r12
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %rdx
	movq	(%rcx), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%r12), %r12
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %rcx
	movq	(%rdx), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%r12), %r12
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %rdx
	movq	(%rcx), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%r12), %r12
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %rcx
	movq	(%rdx), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%r12), %r12
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	0(%rbp), %rbp
	movq	(%rbx), %rdx
	movq	(%rcx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%r12), %r12
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	0(%rbp), %rcx
	movq	(%rdx), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%r12), %r12
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %rdx
	movq	(%rcx), %r13
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%r12), %r12
	movq	(%r15), %r15
	movq	(%r14), %rcx
	movq	(%rdx), %r14
	movq	0(%r13), %r13
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%r12), %r12
	movq	(%r15), %rdx
	movq	(%rcx), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%r12), %rcx
	movq	(%rdx), %r12
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rdx
	movq	(%rcx), %rsi
	movq	(%r12), %r12
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rcx
	movq	(%rdx), %rdi
	movq	(%rsi), %rsi
	movq	(%r12), %r12
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %rdx
	movq	(%rcx), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%r12), %r12
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %rcx
	movq	(%rdx), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%r12), %r12
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %rdx
	movq	(%rcx), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%r12), %r12
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %rcx
	movq	(%rdx), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%r12), %r12
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	0(%rbp), %rbp
	movq	(%rbx), %rdx
	movq	(%rcx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%r12), %r12
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	0(%rbp), %rcx
	movq	(%rdx), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%r12), %r12
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %rdx
	movq	(%rcx), %r13
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%r12), %r12
	movq	(%r15), %r15
	movq	(%r14), %rcx
	movq	(%rdx), %r14
	movq	0(%r13), %r13
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%r12), %r12
	movq	(%r15), %rdx
	movq	(%rcx), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%r12), %rcx
	movq	(%rdx), %r12
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rdx
	movq	(%rcx), %rsi
	movq	(%r12), %r12
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rcx
	movq	(%rdx), %rdi
	movq	(%rsi), %rsi
	movq	(%r12), %r12
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %rdx
	movq	(%rcx), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%r12), %r12
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %rcx
	movq	(%rdx), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%r12), %r12
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %rdx
	movq	(%rcx), %rcx
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%r12), %r10
	movq	%r10, -40(%rsp)
	movq	(%r15), %r15
	movq	%r15, -32(%rsp)
	movq	(%r14), %r14
	movq	0(%r13), %r12
	movq	%r12, -24(%rsp)
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	%rbx, -16(%rsp)
	movq	(%r11), %r12
	movq	(%rdx), %r13
	movq	(%rcx), %r15
	movq	(%r9), %r9
	movq	%r9, -48(%rsp)
	movq	(%r8), %rbx
	movq	(%rdi), %r11
	movq	(%rsi), %r10
	movq	-40(%rsp), %rdx
	movq	(%rdx), %r9
	movq	-32(%rsp), %rcx
	movq	(%rcx), %r8
	movq	(%r14), %rdi
	movq	-24(%rsp), %rdx
	movq	(%rdx), %rsi
	movq	0(%rbp), %rdx
	movq	-16(%rsp), %rcx
	movq	(%rcx), %rcx
	subq	$1, %rax
	cmpq	$-1, %rax
	jne	.L377
.L378:
	movq	%r12, sp0.62(%rip)
	movq	%r13, sp1.61(%rip)
	movq	%r15, sp2.60(%rip)
	movq	-48(%rsp), %rax
	movq	%rax, sp3.59(%rip)
	movq	%rbx, sp4.58(%rip)
	movq	%r11, sp5.57(%rip)
	movq	%r10, sp6.56(%rip)
	movq	%r9, sp7.55(%rip)
	movq	%r8, sp8.54(%rip)
	movq	%rdi, sp9.53(%rip)
	movq	%rsi, sp10.52(%rip)
	movq	%rdx, sp11.51(%rip)
	movq	%rcx, sp12.50(%rip)
	movq	-8(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, addr_save.63(%rip)
	movl	$1, mem_benchmark_rerun(%rip)
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
	.cfi_endproc
.LFE84:
	.size	mem_benchmark_12, .-mem_benchmark_12
	.globl	mem_benchmark_13
	.type	mem_benchmark_13, @function
mem_benchmark_13:
.LFB85:
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
	movq	%rdi, %r11
	movq	%rsi, -8(%rsp)
	movl	mem_benchmark_rerun(%rip), %edx
	testl	%edx, %edx
	je	.L404
	movq	addr_save.49(%rip), %rcx
	movq	sp0.48(%rip), %rbp
	cmpq	%rcx, (%rsi)
	je	.L406
	movq	-8(%rsp), %rax
	movq	16(%rax), %rbp
	movq	addr_save.49(%rip), %rcx
	cmpq	%rcx, (%rax)
	je	.L406
	movq	-8(%rsp), %rax
	movq	24(%rax), %r12
	testl	%edx, %edx
	je	.L407
	movq	-8(%rsp), %rax
	movq	addr_save.49(%rip), %rcx
	cmpq	%rcx, (%rax)
	je	.L409
	movq	32(%rax), %r13
	testl	%edx, %edx
	je	.L410
	movq	-8(%rsp), %rax
	movq	addr_save.49(%rip), %rcx
	cmpq	%rcx, (%rax)
	je	.L412
	movq	40(%rax), %rax
	movq	%rax, -48(%rsp)
	testl	%edx, %edx
	je	.L413
	movq	-8(%rsp), %rax
	movq	addr_save.49(%rip), %rcx
	cmpq	%rcx, (%rax)
	je	.L415
	movq	48(%rax), %rax
	movq	%rax, -40(%rsp)
	testl	%edx, %edx
	je	.L416
	movq	-8(%rsp), %rax
	movq	addr_save.49(%rip), %rcx
	cmpq	%rcx, (%rax)
	je	.L418
	movq	56(%rax), %rbx
	testl	%edx, %edx
	je	.L419
	movq	-8(%rsp), %rax
	movq	addr_save.49(%rip), %rcx
	cmpq	%rcx, (%rax)
	je	.L421
	movq	64(%rax), %r10
	testl	%edx, %edx
	je	.L422
	movq	-8(%rsp), %rax
	movq	addr_save.49(%rip), %rcx
	cmpq	%rcx, (%rax)
	je	.L424
	movq	72(%rax), %r9
	testl	%edx, %edx
	je	.L425
	movq	-8(%rsp), %rax
	movq	addr_save.49(%rip), %rsi
	cmpq	%rsi, (%rax)
	je	.L445
	movq	-8(%rsp), %rax
	movq	80(%rax), %r8
	movq	addr_save.49(%rip), %rcx
	cmpq	%rcx, (%rax)
	je	.L427
	movq	-8(%rsp), %rax
	movq	88(%rax), %rdi
	testl	%edx, %edx
	je	.L428
	movq	-8(%rsp), %rax
	movq	addr_save.49(%rip), %rsi
	cmpq	%rsi, (%rax)
	je	.L442
	movq	-8(%rsp), %rax
	movq	96(%rax), %rsi
	movq	addr_save.49(%rip), %rcx
	cmpq	%rcx, (%rax)
	je	.L430
	movq	-8(%rsp), %rax
	movq	104(%rax), %rcx
	testl	%edx, %edx
	je	.L431
	movq	-8(%rsp), %rax
	movq	addr_save.49(%rip), %r15
	cmpq	%r15, (%rax)
	je	.L433
	movq	112(%rax), %rax
	testl	%edx, %edx
	je	.L434
	movq	-8(%rsp), %rdx
	movq	addr_save.49(%rip), %r15
	cmpq	%r15, (%rdx)
	jne	.L434
	jmp	.L436
.L406:
	movq	sp1.47(%rip), %r12
.L409:
	movq	sp2.46(%rip), %r13
.L412:
	movq	sp3.45(%rip), %rax
	movq	%rax, -48(%rsp)
.L415:
	movq	sp4.44(%rip), %rax
	movq	%rax, -40(%rsp)
.L418:
	movq	sp5.43(%rip), %rbx
.L421:
	movq	sp6.42(%rip), %r10
.L424:
	movq	sp7.41(%rip), %r9
.L445:
	movq	sp8.40(%rip), %r8
.L427:
	movq	sp9.39(%rip), %rdi
.L442:
	movq	sp10.38(%rip), %rsi
.L430:
	movq	sp11.37(%rip), %rcx
.L433:
	movq	sp12.36(%rip), %rax
.L436:
	movq	sp13.35(%rip), %rdx
	jmp	.L439
.L404:
	movq	-8(%rsp), %rax
	movq	16(%rax), %rbp
	movq	24(%rax), %r12
.L407:
	movq	-8(%rsp), %rax
	movq	32(%rax), %r13
.L410:
	movq	-8(%rsp), %rax
	movq	40(%rax), %rax
	movq	%rax, -48(%rsp)
.L413:
	movq	-8(%rsp), %rax
	movq	48(%rax), %rax
	movq	%rax, -40(%rsp)
.L416:
	movq	-8(%rsp), %rax
	movq	56(%rax), %rbx
.L419:
	movq	-8(%rsp), %rax
	movq	64(%rax), %r10
.L422:
	movq	-8(%rsp), %rax
	movq	72(%rax), %r9
.L425:
	movq	-8(%rsp), %rax
	movq	80(%rax), %r8
	movq	88(%rax), %rdi
.L428:
	movq	-8(%rsp), %rax
	movq	96(%rax), %rsi
	movq	104(%rax), %rcx
.L431:
	movq	-8(%rsp), %rax
	movq	112(%rax), %rax
.L434:
	movq	-8(%rsp), %rdx
	movq	120(%rdx), %rdx
.L439:
	leaq	-1(%r11), %r15
	movq	%r15, -56(%rsp)
	testq	%r11, %r11
	je	.L438
	movq	%rbp, %r11
	movq	%r12, %rbp
	movq	%r13, %r12
.L437:
	movq	(%r11), %r15
	movq	0(%rbp), %r14
	movq	(%r12), %r13
	movq	-48(%rsp), %r11
	movq	(%r11), %r12
	movq	-40(%rsp), %r11
	movq	(%r11), %rbp
	movq	(%rbx), %rbx
	movq	(%r10), %r11
	movq	(%r9), %r10
	movq	(%r8), %r9
	movq	(%rdi), %r8
	movq	(%rsi), %rdi
	movq	(%rcx), %rsi
	movq	(%rax), %rcx
	movq	(%rdx), %rdx
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %rax
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rdx
	movq	(%rax), %rbx
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%r11), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rax
	movq	(%rdx), %rbp
	movq	(%rbx), %rbx
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%r11), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %rdx
	movq	(%rax), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%r11), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %rax
	movq	(%rdx), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%r11), %r11
	movq	(%r15), %r15
	movq	(%r14), %rdx
	movq	(%rax), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%r11), %r11
	movq	(%r15), %rax
	movq	(%rdx), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%r11), %rdx
	movq	(%rax), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rax
	movq	(%rdx), %rcx
	movq	(%r11), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rdx
	movq	(%rax), %rsi
	movq	(%rcx), %rcx
	movq	(%r11), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rax
	movq	(%rdx), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%r11), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %rdx
	movq	(%rax), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%r11), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r10), %r10
	movq	(%r9), %rax
	movq	(%rdx), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%r11), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r10), %rdx
	movq	(%rax), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%r11), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rax
	movq	(%rdx), %rbx
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%r11), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rdx
	movq	(%rax), %rbp
	movq	(%rbx), %rbx
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%r11), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %rax
	movq	(%rdx), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%r11), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %rdx
	movq	(%rax), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%r11), %r11
	movq	(%r15), %r15
	movq	(%r14), %rax
	movq	(%rdx), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%r11), %r11
	movq	(%r15), %rdx
	movq	(%rax), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%r11), %rax
	movq	(%rdx), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rdx
	movq	(%rax), %rcx
	movq	(%r11), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rax
	movq	(%rdx), %rsi
	movq	(%rcx), %rcx
	movq	(%r11), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdx
	movq	(%rax), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%r11), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %rax
	movq	(%rdx), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%r11), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r10), %r10
	movq	(%r9), %rdx
	movq	(%rax), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%r11), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r10), %rax
	movq	(%rdx), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%r11), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rdx
	movq	(%rax), %rbx
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%r11), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rax
	movq	(%rdx), %rbp
	movq	(%rbx), %rbx
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%r11), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %rdx
	movq	(%rax), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%r11), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %rax
	movq	(%rdx), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%r11), %r11
	movq	(%r15), %r15
	movq	(%r14), %rdx
	movq	(%rax), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%r11), %r11
	movq	(%r15), %rax
	movq	(%rdx), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%r11), %rdx
	movq	(%rax), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rax
	movq	(%rdx), %rcx
	movq	(%r11), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rdx
	movq	(%rax), %rsi
	movq	(%rcx), %rcx
	movq	(%r11), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rax
	movq	(%rdx), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%r11), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %rdx
	movq	(%rax), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%r11), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r10), %r10
	movq	(%r9), %rax
	movq	(%rdx), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%r11), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r10), %rdx
	movq	(%rax), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%r11), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rax
	movq	(%rdx), %rbx
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%r11), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rdx
	movq	(%rax), %rbp
	movq	(%rbx), %rbx
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%r11), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %rax
	movq	(%rdx), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%r11), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %rdx
	movq	(%rax), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%r11), %r11
	movq	(%r15), %r15
	movq	(%r14), %rax
	movq	(%rdx), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%r11), %r11
	movq	(%r15), %rdx
	movq	(%rax), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%r11), %rax
	movq	(%rdx), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rdx
	movq	(%rax), %rcx
	movq	(%r11), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rax
	movq	(%rdx), %rsi
	movq	(%rcx), %rcx
	movq	(%r11), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdx
	movq	(%rax), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%r11), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %rax
	movq	(%rdx), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%r11), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r10), %r10
	movq	(%r9), %rdx
	movq	(%rax), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%r11), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r10), %rax
	movq	(%rdx), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%r11), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rdx
	movq	(%rax), %rbx
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%r11), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rax
	movq	(%rdx), %rbp
	movq	(%rbx), %rbx
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%r11), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %rdx
	movq	(%rax), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%r11), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %rax
	movq	(%rdx), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%r11), %r11
	movq	(%r15), %r15
	movq	(%r14), %rdx
	movq	(%rax), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%r11), %r11
	movq	(%r15), %rax
	movq	(%rdx), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%r11), %rdx
	movq	(%rax), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rax
	movq	(%rdx), %rcx
	movq	(%r11), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rdx
	movq	(%rax), %rsi
	movq	(%rcx), %rcx
	movq	(%r11), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rax
	movq	(%rdx), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%r11), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %rdx
	movq	(%rax), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%r11), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r10), %r10
	movq	(%r9), %rax
	movq	(%rdx), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%r11), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r10), %rdx
	movq	(%rax), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%r11), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rax
	movq	(%rdx), %rbx
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%r11), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rdx
	movq	(%rax), %rbp
	movq	(%rbx), %rbx
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%r11), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %rax
	movq	(%rdx), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%r11), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %rdx
	movq	(%rax), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%r11), %r11
	movq	(%r15), %r15
	movq	(%r14), %rax
	movq	(%rdx), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%r11), %r11
	movq	(%r15), %rdx
	movq	(%rax), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%r11), %rax
	movq	(%rdx), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rdx
	movq	(%rax), %rcx
	movq	(%r11), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rax
	movq	(%rdx), %rsi
	movq	(%rcx), %rcx
	movq	(%r11), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdx
	movq	(%rax), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%r11), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %rax
	movq	(%rdx), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%r11), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r10), %r10
	movq	(%r9), %rdx
	movq	(%rax), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%r11), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r10), %rax
	movq	(%rdx), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%r11), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rdx
	movq	(%rax), %rbx
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%r11), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rax
	movq	(%rdx), %rbp
	movq	(%rbx), %rbx
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%r11), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %rdx
	movq	(%rax), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%r11), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %rax
	movq	(%rdx), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%r11), %r11
	movq	(%r15), %r15
	movq	(%r14), %rdx
	movq	(%rax), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%r11), %r11
	movq	(%r15), %rax
	movq	(%rdx), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%r11), %rdx
	movq	(%rax), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rax
	movq	(%rdx), %rcx
	movq	(%r11), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rdx
	movq	(%rax), %rsi
	movq	(%rcx), %rcx
	movq	(%r11), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rax
	movq	(%rdx), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%r11), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %rdx
	movq	(%rax), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%r11), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r10), %r10
	movq	(%r9), %rax
	movq	(%rdx), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%r11), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r10), %rdx
	movq	(%rax), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%r11), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rax
	movq	(%rdx), %rbx
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%r11), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rdx
	movq	(%rax), %rbp
	movq	(%rbx), %rbx
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%r11), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %rax
	movq	(%rdx), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%r11), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %rdx
	movq	(%rax), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%r11), %r11
	movq	(%r15), %r15
	movq	(%r14), %rax
	movq	(%rdx), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%r11), %r11
	movq	(%r15), %rdx
	movq	(%rax), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%r11), %rax
	movq	(%rdx), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rdx
	movq	(%rax), %rcx
	movq	(%r11), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rax
	movq	(%rdx), %rsi
	movq	(%rcx), %rcx
	movq	(%r11), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdx
	movq	(%rax), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%r11), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %rax
	movq	(%rdx), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%r11), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r10), %r10
	movq	(%r9), %rdx
	movq	(%rax), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%r11), %r11
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r10), %rax
	movq	(%rdx), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%r11), %rdx
	movq	%rdx, -32(%rsp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r11
	movq	%r11, -24(%rsp)
	movq	0(%rbp), %rbp
	movq	%rbp, -16(%rsp)
	movq	(%rbx), %rdx
	movq	(%rax), %r11
	movq	(%r10), %rbp
	movq	(%r9), %r12
	movq	(%r8), %rbx
	movq	%rbx, -48(%rsp)
	movq	(%rdi), %rdi
	movq	%rdi, -40(%rsp)
	movq	(%rsi), %rbx
	movq	(%rcx), %r10
	movq	-32(%rsp), %rax
	movq	(%rax), %r9
	movq	(%r15), %r8
	movq	(%r14), %rdi
	movq	0(%r13), %rsi
	movq	-24(%rsp), %rax
	movq	(%rax), %rcx
	movq	-16(%rsp), %rax
	movq	(%rax), %rax
	movq	(%rdx), %rdx
	subq	$1, -56(%rsp)
	movq	-56(%rsp), %r14
	cmpq	$-1, %r14
	jne	.L437
	movq	%r12, %r13
	movq	%rbp, %r12
	movq	%r11, %rbp
.L438:
	movq	%rbp, sp0.48(%rip)
	movq	%r12, sp1.47(%rip)
	movq	%r13, sp2.46(%rip)
	movq	-48(%rsp), %r15
	movq	%r15, sp3.45(%rip)
	movq	-40(%rsp), %r15
	movq	%r15, sp4.44(%rip)
	movq	%rbx, sp5.43(%rip)
	movq	%r10, sp6.42(%rip)
	movq	%r9, sp7.41(%rip)
	movq	%r8, sp8.40(%rip)
	movq	%rdi, sp9.39(%rip)
	movq	%rsi, sp10.38(%rip)
	movq	%rcx, sp11.37(%rip)
	movq	%rax, sp12.36(%rip)
	movq	%rdx, sp13.35(%rip)
	movq	-8(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, addr_save.49(%rip)
	movl	$1, mem_benchmark_rerun(%rip)
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
	.cfi_endproc
.LFE85:
	.size	mem_benchmark_13, .-mem_benchmark_13
	.globl	mem_benchmark_14
	.type	mem_benchmark_14, @function
mem_benchmark_14:
.LFB86:
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
	movq	%rdi, -32(%rsp)
	movq	%rsi, -24(%rsp)
	movl	mem_benchmark_rerun(%rip), %eax
	testl	%eax, %eax
	je	.L463
	movq	addr_save.34(%rip), %rbx
	movq	sp0.33(%rip), %r15
	cmpq	%rbx, (%rsi)
	je	.L465
	movq	-24(%rsp), %rbx
	movq	16(%rbx), %r15
	movq	addr_save.34(%rip), %rdi
	cmpq	%rdi, (%rbx)
	je	.L465
	movq	-24(%rsp), %rdx
	movq	24(%rdx), %r14
	testl	%eax, %eax
	je	.L466
	movq	-24(%rsp), %rcx
	movq	addr_save.34(%rip), %rbx
	cmpq	%rbx, (%rcx)
	je	.L468
	movq	32(%rcx), %r13
	testl	%eax, %eax
	je	.L469
	movq	-24(%rsp), %rbx
	movq	addr_save.34(%rip), %rdx
	cmpq	%rdx, (%rbx)
	je	.L471
	movq	40(%rbx), %r12
	testl	%eax, %eax
	je	.L472
	movq	-24(%rsp), %rdx
	movq	addr_save.34(%rip), %rbx
	cmpq	%rbx, (%rdx)
	je	.L474
	movq	48(%rdx), %rbp
	testl	%eax, %eax
	je	.L475
	movq	-24(%rsp), %rcx
	movq	addr_save.34(%rip), %rdx
	cmpq	%rdx, (%rcx)
	je	.L477
	movq	56(%rcx), %rbx
	testl	%eax, %eax
	je	.L478
	movq	-24(%rsp), %rdi
	movq	addr_save.34(%rip), %rcx
	cmpq	%rcx, (%rdi)
	je	.L480
	movq	64(%rdi), %r11
	testl	%eax, %eax
	je	.L481
	movq	-24(%rsp), %rsi
	movq	addr_save.34(%rip), %rcx
	cmpq	%rcx, (%rsi)
	je	.L507
	movq	-24(%rsp), %rsi
	movq	72(%rsi), %r10
	movq	addr_save.34(%rip), %rcx
	cmpq	%rcx, (%rsi)
	je	.L483
	movq	-24(%rsp), %rdi
	movq	80(%rdi), %r9
	testl	%eax, %eax
	je	.L484
	movq	-24(%rsp), %rcx
	movq	addr_save.34(%rip), %rdi
	cmpq	%rdi, (%rcx)
	je	.L504
	movq	-24(%rsp), %rdi
	movq	88(%rdi), %r8
	movq	addr_save.34(%rip), %rcx
	cmpq	%rcx, (%rdi)
	je	.L486
	movq	-24(%rsp), %rdx
	movq	96(%rdx), %rdi
	testl	%eax, %eax
	je	.L487
	movq	-24(%rsp), %rcx
	movq	addr_save.34(%rip), %rsi
	cmpq	%rsi, (%rcx)
	je	.L501
	movq	-24(%rsp), %rcx
	movq	104(%rcx), %rsi
	movq	addr_save.34(%rip), %rdx
	cmpq	%rdx, (%rcx)
	je	.L489
	movq	-24(%rsp), %rcx
	movq	112(%rcx), %rdx
	movq	%rdx, -16(%rsp)
	testl	%eax, %eax
	je	.L490
	movq	-24(%rsp), %rdx
	movq	addr_save.34(%rip), %rcx
	cmpq	%rcx, (%rdx)
	je	.L492
	movq	120(%rdx), %rdx
	testl	%eax, %eax
	je	.L493
	movq	-24(%rsp), %rax
	movq	addr_save.34(%rip), %rcx
	cmpq	%rcx, (%rax)
	jne	.L493
	jmp	.L495
.L465:
	movq	sp1.32(%rip), %r14
.L468:
	movq	sp2.31(%rip), %r13
.L471:
	movq	sp3.30(%rip), %r12
.L474:
	movq	sp4.29(%rip), %rbp
.L477:
	movq	sp5.28(%rip), %rbx
.L480:
	movq	sp6.27(%rip), %r11
.L507:
	movq	sp7.26(%rip), %r10
.L483:
	movq	sp8.25(%rip), %r9
.L504:
	movq	sp9.24(%rip), %r8
.L486:
	movq	sp10.23(%rip), %rdi
.L501:
	movq	sp11.22(%rip), %rsi
.L489:
	movq	sp12.21(%rip), %rax
	movq	%rax, -16(%rsp)
.L492:
	movq	sp13.20(%rip), %rdx
.L495:
	movq	sp14.19(%rip), %rax
	movq	%rax, -8(%rsp)
	jmp	.L498
.L463:
	movq	-24(%rsp), %rax
	movq	16(%rax), %r15
	movq	24(%rax), %r14
.L466:
	movq	-24(%rsp), %rax
	movq	32(%rax), %r13
.L469:
	movq	-24(%rsp), %rax
	movq	40(%rax), %r12
.L472:
	movq	-24(%rsp), %rax
	movq	48(%rax), %rbp
.L475:
	movq	-24(%rsp), %rax
	movq	56(%rax), %rbx
.L478:
	movq	-24(%rsp), %rax
	movq	64(%rax), %r11
.L481:
	movq	-24(%rsp), %rax
	movq	72(%rax), %r10
	movq	80(%rax), %r9
.L484:
	movq	-24(%rsp), %rax
	movq	88(%rax), %r8
	movq	96(%rax), %rdi
.L487:
	movq	-24(%rsp), %rax
	movq	104(%rax), %rsi
	movq	112(%rax), %rax
	movq	%rax, -16(%rsp)
.L490:
	movq	-24(%rsp), %rax
	movq	120(%rax), %rdx
.L493:
	movq	-24(%rsp), %rax
	movq	128(%rax), %rax
	movq	%rax, -8(%rsp)
.L498:
	movq	-32(%rsp), %rcx
	movq	%rcx, %rax
	subq	$1, %rax
	movq	%rax, -32(%rsp)
	testq	%rcx, %rcx
	je	.L497
	movq	-16(%rsp), %rcx
	movq	-8(%rsp), %rax
.L496:
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rax), %rax
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	(%rax), %rax
	subq	$1, -32(%rsp)
	cmpq	$-1, -32(%rsp)
	jne	.L496
	movq	%rcx, -16(%rsp)
	movq	%rax, -8(%rsp)
.L497:
	movq	%r15, sp0.33(%rip)
	movq	%r14, sp1.32(%rip)
	movq	%r13, sp2.31(%rip)
	movq	%r12, sp3.30(%rip)
	movq	%rbp, sp4.29(%rip)
	movq	%rbx, sp5.28(%rip)
	movq	%r11, sp6.27(%rip)
	movq	%r10, sp7.26(%rip)
	movq	%r9, sp8.25(%rip)
	movq	%r8, sp9.24(%rip)
	movq	%rdi, sp10.23(%rip)
	movq	%rsi, sp11.22(%rip)
	movq	-16(%rsp), %rax
	movq	%rax, sp12.21(%rip)
	movq	%rdx, sp13.20(%rip)
	movq	-8(%rsp), %rax
	movq	%rax, sp14.19(%rip)
	movq	-24(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, addr_save.34(%rip)
	movl	$1, mem_benchmark_rerun(%rip)
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
	.cfi_endproc
.LFE86:
	.size	mem_benchmark_14, .-mem_benchmark_14
	.globl	mem_benchmark_15
	.type	mem_benchmark_15, @function
mem_benchmark_15:
.LFB87:
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
	movq	%rdi, -8(%rsp)
	movq	%rsi, -24(%rsp)
	movl	mem_benchmark_rerun(%rip), %eax
	movl	%eax, -48(%rsp)
	testl	%eax, %eax
	je	.L525
	movq	addr_save.18(%rip), %rax
	movq	sp0.17(%rip), %r15
	cmpq	%rax, (%rsi)
	je	.L527
	movq	-24(%rsp), %rax
	movq	16(%rax), %r15
	movq	addr_save.18(%rip), %rbx
	cmpq	%rbx, (%rax)
	je	.L527
	movq	-24(%rsp), %rax
	movq	24(%rax), %r14
	cmpl	$0, -48(%rsp)
	je	.L528
	movq	-24(%rsp), %rax
	movq	addr_save.18(%rip), %rdx
	cmpq	%rdx, (%rax)
	je	.L530
	movq	32(%rax), %r13
	cmpl	$0, -48(%rsp)
	je	.L531
	movq	-24(%rsp), %rax
	movq	addr_save.18(%rip), %rcx
	cmpq	%rcx, (%rax)
	je	.L533
	movq	40(%rax), %r12
	cmpl	$0, -48(%rsp)
	je	.L534
	movq	-24(%rsp), %rax
	movq	addr_save.18(%rip), %rbx
	cmpq	%rbx, (%rax)
	je	.L536
	movq	48(%rax), %rbp
	cmpl	$0, -48(%rsp)
	je	.L537
	movq	-24(%rsp), %rax
	movq	addr_save.18(%rip), %rdx
	cmpq	%rdx, (%rax)
	je	.L539
	movq	56(%rax), %rbx
	cmpl	$0, -48(%rsp)
	je	.L540
	movq	-24(%rsp), %rax
	movq	addr_save.18(%rip), %rcx
	cmpq	%rcx, (%rax)
	je	.L542
	movq	64(%rax), %r11
	cmpl	$0, -48(%rsp)
	je	.L543
	movq	-24(%rsp), %rax
	movq	addr_save.18(%rip), %rdx
	cmpq	%rdx, (%rax)
	je	.L545
	movq	72(%rax), %r10
	cmpl	$0, -48(%rsp)
	je	.L546
	movq	-24(%rsp), %rax
	movq	addr_save.18(%rip), %rcx
	cmpq	%rcx, (%rax)
	je	.L548
	movq	80(%rax), %r9
	cmpl	$0, -48(%rsp)
	je	.L549
	movq	-24(%rsp), %rax
	movq	addr_save.18(%rip), %rcx
	cmpq	%rcx, (%rax)
	je	.L572
	movq	-24(%rsp), %rax
	movq	88(%rax), %r8
	movq	addr_save.18(%rip), %rdx
	cmpq	%rdx, (%rax)
	je	.L551
	movq	-24(%rsp), %rax
	movq	96(%rax), %rdi
	cmpl	$0, -48(%rsp)
	je	.L552
	movq	-24(%rsp), %rax
	movq	addr_save.18(%rip), %rdx
	cmpq	%rdx, (%rax)
	je	.L569
	movq	-24(%rsp), %rax
	movq	104(%rax), %rsi
	movq	addr_save.18(%rip), %rdx
	cmpq	%rdx, (%rax)
	je	.L554
	movq	-24(%rsp), %rax
	movq	112(%rax), %rcx
	cmpl	$0, -48(%rsp)
	je	.L555
	movq	-24(%rsp), %rax
	movq	addr_save.18(%rip), %rdx
	cmpq	%rdx, (%rax)
	je	.L557
	movq	120(%rax), %rax
	movq	%rax, -16(%rsp)
	cmpl	$0, -48(%rsp)
	je	.L558
	movq	-24(%rsp), %rax
	movq	addr_save.18(%rip), %rdx
	cmpq	%rdx, (%rax)
	je	.L560
	movq	128(%rax), %rax
	movq	%rax, -40(%rsp)
	cmpl	$0, -48(%rsp)
	je	.L561
	movq	-24(%rsp), %rax
	movq	addr_save.18(%rip), %rdx
	cmpq	%rdx, (%rax)
	jne	.L561
	jmp	.L563
.L527:
	movq	sp1.16(%rip), %r14
.L530:
	movq	sp2.15(%rip), %r13
.L533:
	movq	sp3.14(%rip), %r12
.L536:
	movq	sp4.13(%rip), %rbp
.L539:
	movq	sp5.12(%rip), %rbx
.L542:
	movq	sp6.11(%rip), %r11
.L545:
	movq	sp7.10(%rip), %r10
.L548:
	movq	sp8.9(%rip), %r9
.L572:
	movq	sp9.8(%rip), %r8
.L551:
	movq	sp10.7(%rip), %rdi
.L569:
	movq	sp11.6(%rip), %rsi
.L554:
	movq	sp12.5(%rip), %rcx
.L557:
	movq	sp13.4(%rip), %rax
	movq	%rax, -16(%rsp)
.L560:
	movq	sp14.3(%rip), %rax
	movq	%rax, -40(%rsp)
.L563:
	movq	sp15.2(%rip), %rax
	movq	%rax, -32(%rsp)
	jmp	.L566
.L525:
	movq	-24(%rsp), %rax
	movq	16(%rax), %r15
	movq	24(%rax), %r14
.L528:
	movq	-24(%rsp), %rax
	movq	32(%rax), %r13
.L531:
	movq	-24(%rsp), %rax
	movq	40(%rax), %r12
.L534:
	movq	-24(%rsp), %rax
	movq	48(%rax), %rbp
.L537:
	movq	-24(%rsp), %rax
	movq	56(%rax), %rbx
.L540:
	movq	-24(%rsp), %rax
	movq	64(%rax), %r11
.L543:
	movq	-24(%rsp), %rax
	movq	72(%rax), %r10
.L546:
	movq	-24(%rsp), %rax
	movq	80(%rax), %r9
.L549:
	movq	-24(%rsp), %rax
	movq	88(%rax), %r8
	movq	96(%rax), %rdi
.L552:
	movq	-24(%rsp), %rax
	movq	104(%rax), %rsi
	movq	112(%rax), %rcx
.L555:
	movq	-24(%rsp), %rax
	movq	120(%rax), %rax
	movq	%rax, -16(%rsp)
.L558:
	movq	-24(%rsp), %rax
	movq	128(%rax), %rax
	movq	%rax, -40(%rsp)
.L561:
	movq	-24(%rsp), %rax
	movq	136(%rax), %rax
	movq	%rax, -32(%rsp)
.L566:
	movq	-8(%rsp), %rdx
	movq	%rdx, %rax
	subq	$1, %rax
	movq	%rax, -48(%rsp)
	movq	%rdx, %rax
	movq	-16(%rsp), %rdx
	testq	%rax, %rax
	je	.L565
.L564:
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	-40(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rsp)
	movq	-32(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rsp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	-40(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rsp)
	movq	-32(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rsp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	-40(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rsp)
	movq	-32(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rsp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	-40(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rsp)
	movq	-32(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rsp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	-40(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rsp)
	movq	-32(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rsp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	-40(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rsp)
	movq	-32(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rsp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	-40(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rsp)
	movq	-32(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rsp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	-40(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rsp)
	movq	-32(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rsp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	-40(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rsp)
	movq	-32(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rsp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	-40(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rsp)
	movq	-32(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rsp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	-40(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rsp)
	movq	-32(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rsp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	-40(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rsp)
	movq	-32(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rsp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	-40(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rsp)
	movq	-32(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rsp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	-40(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rsp)
	movq	-32(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rsp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	-40(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rsp)
	movq	-32(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rsp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	-40(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rsp)
	movq	-32(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rsp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	-40(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rsp)
	movq	-32(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rsp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	-40(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rsp)
	movq	-32(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rsp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	-40(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rsp)
	movq	-32(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rsp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	-40(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rsp)
	movq	-32(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rsp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	-40(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rsp)
	movq	-32(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rsp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	-40(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rsp)
	movq	-32(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rsp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	-40(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rsp)
	movq	-32(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rsp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	-40(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rsp)
	movq	-32(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rsp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	-40(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rsp)
	movq	-32(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rsp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	-40(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rsp)
	movq	-32(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rsp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	-40(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rsp)
	movq	-32(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rsp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	-40(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rsp)
	movq	-32(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rsp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	-40(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rsp)
	movq	-32(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rsp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	-40(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rsp)
	movq	-32(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rsp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	-40(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rsp)
	movq	-32(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rsp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	-40(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rsp)
	movq	-32(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rsp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	-40(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rsp)
	movq	-32(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rsp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	-40(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rsp)
	movq	-32(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rsp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	-40(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rsp)
	movq	-32(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rsp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	-40(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rsp)
	movq	-32(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rsp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	-40(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rsp)
	movq	-32(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rsp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	-40(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rsp)
	movq	-32(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rsp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	-40(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rsp)
	movq	-32(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rsp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	-40(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rsp)
	movq	-32(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rsp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	-40(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rsp)
	movq	-32(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rsp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	-40(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rsp)
	movq	-32(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rsp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	-40(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rsp)
	movq	-32(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rsp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	-40(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rsp)
	movq	-32(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rsp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	-40(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rsp)
	movq	-32(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rsp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	-40(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rsp)
	movq	-32(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rsp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	-40(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rsp)
	movq	-32(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rsp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	-40(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rsp)
	movq	-32(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rsp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	-40(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rsp)
	movq	-32(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rsp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	-40(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rsp)
	movq	-32(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rsp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	-40(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rsp)
	movq	-32(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rsp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	-40(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rsp)
	movq	-32(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rsp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	-40(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rsp)
	movq	-32(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rsp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	-40(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rsp)
	movq	-32(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rsp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	-40(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rsp)
	movq	-32(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rsp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	-40(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rsp)
	movq	-32(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rsp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	-40(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rsp)
	movq	-32(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rsp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	-40(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rsp)
	movq	-32(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rsp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	-40(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rsp)
	movq	-32(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rsp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	-40(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rsp)
	movq	-32(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rsp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	-40(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rsp)
	movq	-32(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rsp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	-40(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rsp)
	movq	-32(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rsp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	-40(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rsp)
	movq	-32(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rsp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	-40(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rsp)
	movq	-32(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rsp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	-40(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rsp)
	movq	-32(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rsp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	-40(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rsp)
	movq	-32(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rsp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	-40(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rsp)
	movq	-32(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rsp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	-40(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rsp)
	movq	-32(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rsp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	-40(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rsp)
	movq	-32(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rsp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	-40(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rsp)
	movq	-32(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rsp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	-40(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rsp)
	movq	-32(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rsp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	-40(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rsp)
	movq	-32(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rsp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	-40(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rsp)
	movq	-32(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rsp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	-40(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rsp)
	movq	-32(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rsp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	-40(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rsp)
	movq	-32(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rsp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	-40(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rsp)
	movq	-32(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rsp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	-40(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rsp)
	movq	-32(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rsp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	-40(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rsp)
	movq	-32(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rsp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	-40(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rsp)
	movq	-32(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rsp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	-40(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rsp)
	movq	-32(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rsp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	-40(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rsp)
	movq	-32(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rsp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	-40(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rsp)
	movq	-32(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rsp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	-40(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rsp)
	movq	-32(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rsp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	-40(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rsp)
	movq	-32(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rsp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	-40(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rsp)
	movq	-32(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rsp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	-40(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rsp)
	movq	-32(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rsp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	-40(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rsp)
	movq	-32(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rsp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	-40(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rsp)
	movq	-32(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rsp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	-40(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rsp)
	movq	-32(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rsp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	-40(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rsp)
	movq	-32(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rsp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	-40(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rsp)
	movq	-32(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rsp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	-40(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rsp)
	movq	-32(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rsp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	-40(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rsp)
	movq	-32(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rsp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	-40(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rsp)
	movq	-32(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rsp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	-40(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rsp)
	movq	-32(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rsp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	-40(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rsp)
	movq	-32(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rsp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	-40(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rsp)
	movq	-32(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rsp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	-40(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rsp)
	movq	-32(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rsp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	-40(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rsp)
	movq	-32(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rsp)
	movq	(%r15), %r15
	movq	(%r14), %r14
	movq	0(%r13), %r13
	movq	(%r12), %r12
	movq	0(%rbp), %rbp
	movq	(%rbx), %rbx
	movq	(%r11), %r11
	movq	(%r10), %r10
	movq	(%r9), %r9
	movq	(%r8), %r8
	movq	(%rdi), %rdi
	movq	(%rsi), %rsi
	movq	(%rcx), %rcx
	movq	(%rdx), %rdx
	movq	-40(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rsp)
	movq	-32(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rsp)
	subq	$1, -48(%rsp)
	movq	-48(%rsp), %rax
	cmpq	$-1, %rax
	jne	.L564
	movq	%rdx, -16(%rsp)
.L565:
	movq	%r15, sp0.17(%rip)
	movq	%r14, sp1.16(%rip)
	movq	%r13, sp2.15(%rip)
	movq	%r12, sp3.14(%rip)
	movq	%rbp, sp4.13(%rip)
	movq	%rbx, sp5.12(%rip)
	movq	%r11, sp6.11(%rip)
	movq	%r10, sp7.10(%rip)
	movq	%r9, sp8.9(%rip)
	movq	%r8, sp9.8(%rip)
	movq	%rdi, sp10.7(%rip)
	movq	%rsi, sp11.6(%rip)
	movq	%rcx, sp12.5(%rip)
	movq	-16(%rsp), %rax
	movq	%rax, sp13.4(%rip)
	movq	-40(%rsp), %rax
	movq	%rax, sp14.3(%rip)
	movq	-32(%rsp), %rax
	movq	%rax, sp15.2(%rip)
	movq	-24(%rsp), %rax
	movq	(%rax), %rax
	movq	%rax, addr_save.18(%rip)
	movl	$1, mem_benchmark_rerun(%rip)
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
	.cfi_endproc
.LFE87:
	.size	mem_benchmark_15, .-mem_benchmark_15
	.globl	mem_reset
	.type	mem_reset, @function
mem_reset:
.LFB88:
	.cfi_startproc
	endbr64
	movl	$0, mem_benchmark_rerun(%rip)
	ret
	.cfi_endproc
.LFE88:
	.size	mem_reset, .-mem_reset
	.globl	mem_cleanup
	.type	mem_cleanup, @function
mem_cleanup:
.LFB89:
	.cfi_startproc
	endbr64
	testq	%rdi, %rdi
	jne	.L598
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movq	%rsi, %rbx
	movq	(%rsi), %rdi
	testq	%rdi, %rdi
	je	.L594
	call	free@PLT
	movq	$0, (%rbx)
.L594:
	movq	216(%rbx), %rdi
	testq	%rdi, %rdi
	je	.L595
	call	free@PLT
	movq	$0, 216(%rbx)
.L595:
	movq	208(%rbx), %rdi
	testq	%rdi, %rdi
	je	.L596
	call	free@PLT
	movq	$0, 208(%rbx)
.L596:
	movq	224(%rbx), %rdi
	testq	%rdi, %rdi
	je	.L592
	call	free@PLT
	movq	$0, 224(%rbx)
.L592:
	popq	%rbx
	.cfi_def_cfa_offset 8
	ret
.L598:
	.cfi_restore 3
	ret
	.cfi_endproc
.LFE89:
	.size	mem_cleanup, .-mem_cleanup
	.globl	tlb_cleanup
	.type	tlb_cleanup, @function
tlb_cleanup:
.LFB90:
	.cfi_startproc
	endbr64
	testq	%rdi, %rdi
	jne	.L610
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
	movq	(%rsi), %r12
	testq	%r12, %r12
	je	.L603
	cmpq	$0, 192(%rsi)
	jne	.L606
.L604:
	movq	%r12, %rdi
	call	free@PLT
	movq	$0, 0(%rbp)
.L603:
	movq	208(%rbp), %rdi
	testq	%rdi, %rdi
	je	.L607
	call	free@PLT
	movq	$0, 208(%rbp)
.L607:
	movq	216(%rbp), %rdi
	testq	%rdi, %rdi
	je	.L601
	call	free@PLT
	movq	$0, 216(%rbp)
.L601:
	popq	%rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	ret
.L605:
	.cfi_restore_state
	addq	$1, %rbx
	cmpq	%rbx, 192(%rbp)
	jbe	.L604
.L606:
	movq	(%r12,%rbx,8), %rdi
	testq	%rdi, %rdi
	je	.L605
	call	free@PLT
	jmp	.L605
.L610:
	.cfi_def_cfa_offset 8
	.cfi_restore 3
	.cfi_restore 6
	.cfi_restore 12
	ret
	.cfi_endproc
.LFE90:
	.size	tlb_cleanup, .-tlb_cleanup
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"base_initialize: malloc"
	.text
	.globl	base_initialize
	.type	base_initialize, @function
base_initialize:
.LFB91:
	.cfi_startproc
	endbr64
	testq	%rdi, %rdi
	je	.L621
	ret
.L621:
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
	subq	$8, %rsp
	.cfi_def_cfa_offset 64
	movq	%rsi, %rbx
	movl	$0, 144(%rsi)
	movq	168(%rsi), %rsi
	movq	%rsi, %r15
	shrq	$3, %r15
	movq	176(%rbx), %rcx
	movq	%rcx, %rax
	movl	$0, %edx
	divq	%rsi
	movq	%rax, %r14
	movq	%rcx, %rax
	addq	152(%rbx), %rax
	subq	$1, %rax
	movl	$0, %edx
	divq	%rcx
	movq	%rax, %r12
	movq	%rcx, %rax
	addq	160(%rbx), %rax
	subq	$1, %rax
	movl	$0, %edx
	divq	%rcx
	movq	%rax, %rbp
	call	getpid@PLT
	movl	%eax, %edi
	call	srand@PLT
	movq	176(%rbx), %rsi
	movq	%rbp, %rdi
	call	permutation@PLT
	movq	%rax, %r13
	movq	176(%rbx), %rbp
	movq	160(%rbx), %rax
	leaq	(%rax,%rbp,2), %rdi
	call	malloc@PLT
	movq	%rax, %rcx
	movq	%rax, (%rbx)
	testq	%rax, %rax
	je	.L622
	movq	%r15, 200(%rbx)
	movq	%r14, 184(%rbx)
	movq	%r12, 192(%rbx)
	movq	$0, 216(%rbx)
	movq	%r13, 208(%rbx)
	movq	$0, 224(%rbx)
	testq	%r13, %r13
	je	.L613
	movl	$0, %edx
	divq	%rbp
	subq	%rdx, %rbp
	addq	%rcx, %rbp
	testq	%rdx, %rdx
	cmovne	%rbp, %rcx
	movq	%rcx, 8(%rbx)
	movl	$1, 144(%rbx)
	movl	$0, mem_benchmark_rerun(%rip)
.L613:
	addq	$8, %rsp
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
.L622:
	.cfi_restore_state
	leaq	.LC0(%rip), %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
	.cfi_endproc
.LFE91:
	.size	base_initialize, .-base_initialize
	.globl	stride_initialize
	.type	stride_initialize, @function
stride_initialize:
.LFB92:
	.cfi_startproc
	endbr64
	pushq	%r12
	.cfi_def_cfa_offset 16
	.cfi_offset 12, -16
	pushq	%rbp
	.cfi_def_cfa_offset 24
	.cfi_offset 6, -24
	pushq	%rbx
	.cfi_def_cfa_offset 32
	.cfi_offset 3, -32
	movq	%rsi, %rbp
	movq	152(%rsi), %r12
	movq	168(%rsi), %rbx
	call	base_initialize
	cmpl	$0, 144(%rbp)
	je	.L623
	movq	8(%rbp), %rcx
	cmpq	%rbx, %r12
	jbe	.L627
	movq	%rbx, %rax
	movq	%rcx, %rsi
	subq	%rbx, %rsi
.L626:
	leaq	(%rcx,%rax), %rdx
	movq	%rdx, (%rsi,%rax)
	addq	%rbx, %rax
	cmpq	%rax, %r12
	ja	.L626
.L625:
	subq	%rbx, %rax
	movq	%rcx, (%rcx,%rax)
	movq	%rcx, 16(%rbp)
	movl	$0, mem_benchmark_rerun(%rip)
.L623:
	popq	%rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	ret
.L627:
	.cfi_restore_state
	movq	%rbx, %rax
	jmp	.L625
	.cfi_endproc
.LFE92:
	.size	stride_initialize, .-stride_initialize
	.globl	words_initialize
	.type	words_initialize, @function
words_initialize:
.LFB97:
	.cfi_startproc
	endbr64
	pushq	%r13
	.cfi_def_cfa_offset 16
	.cfi_offset 13, -16
	pushq	%r12
	.cfi_def_cfa_offset 24
	.cfi_offset 12, -24
	pushq	%rbp
	.cfi_def_cfa_offset 32
	.cfi_offset 6, -32
	pushq	%rbx
	.cfi_def_cfa_offset 40
	.cfi_offset 3, -40
	subq	$8, %rsp
	.cfi_def_cfa_offset 48
	movq	%rdi, %rbx
	movl	%esi, %r12d
	leaq	0(,%rdi,8), %r13
	movq	%r13, %rdi
	call	malloc@PLT
	movq	%rax, %rbp
	testq	%rax, %rax
	je	.L630
	movq	%r13, %rdx
	movl	$0, %esi
	movq	%rax, %rdi
	call	memset@PLT
	movq	%rbx, %rax
	shrq	%rax
	je	.L632
	movl	$0, %r8d
.L633:
	addq	$1, %r8
	shrq	%rax
	jne	.L633
.L634:
	movq	%rbp, %rdi
	movl	$0, %r9d
	movl	$1, %esi
	leal	-1(%r8), %r10d
	movslq	%r12d, %r12
	jmp	.L637
.L632:
	testq	%rbx, %rbx
	jne	.L646
.L630:
	movq	%rbp, %rax
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 40
	popq	%rbx
	.cfi_def_cfa_offset 32
	popq	%rbp
	.cfi_def_cfa_offset 24
	popq	%r12
	.cfi_def_cfa_offset 16
	popq	%r13
	.cfi_def_cfa_offset 8
	ret
.L635:
	.cfi_restore_state
	addq	$1, %rax
	cmpq	%rax, %r8
	je	.L638
.L636:
	movl	%esi, %edx
	movl	%eax, %ecx
	sall	%cl, %edx
	movslq	%edx, %rdx
	testq	%r9, %rdx
	je	.L635
	movl	%r10d, %ecx
	subl	%eax, %ecx
	movl	%esi, %edx
	sall	%cl, %edx
	movslq	%edx, %rdx
	orq	%rdx, (%rdi)
	jmp	.L635
.L638:
	movq	%r12, %rax
	imulq	(%rdi), %rax
	movq	%rax, (%rdi)
	addq	$1, %r9
	addq	$8, %rdi
	cmpq	%r9, %rbx
	jbe	.L630
.L637:
	movl	$0, %eax
	testq	%r8, %r8
	jne	.L636
	jmp	.L638
.L646:
	movq	%rax, %r8
	jmp	.L634
	.cfi_endproc
.LFE97:
	.size	words_initialize, .-words_initialize
	.section	.rodata.str1.1
.LC1:
	.string	"thrash_initialize: malloc"
	.text
	.globl	thrash_initialize
	.type	thrash_initialize, @function
thrash_initialize:
.LFB93:
	.cfi_startproc
	endbr64
	pushq	%r14
	.cfi_def_cfa_offset 16
	.cfi_offset 14, -16
	pushq	%r13
	.cfi_def_cfa_offset 24
	.cfi_offset 13, -24
	pushq	%r12
	.cfi_def_cfa_offset 32
	.cfi_offset 12, -32
	pushq	%rbp
	.cfi_def_cfa_offset 40
	.cfi_offset 6, -40
	pushq	%rbx
	.cfi_def_cfa_offset 48
	.cfi_offset 3, -48
	movq	%rsi, %rbx
	call	base_initialize
	cmpl	$0, 144(%rbx)
	je	.L647
	movq	8(%rbx), %rbp
	movq	152(%rbx), %rdi
	movq	176(%rbx), %rcx
	movq	%rdi, %rax
	movl	$0, %edx
	divq	%rcx
	movq	%rdx, %r14
	movq	%rdx, %r12
	testq	%rdx, %rdx
	je	.L649
	movq	168(%rbx), %rsi
	movq	%rdi, %rax
	movl	$0, %edx
	divq	%rsi
	movq	%rax, %rdi
	movq	%rax, 200(%rbx)
	call	words_initialize
	movq	%rax, 224(%rbx)
	testq	%rax, %rax
	je	.L650
	movl	$8, %eax
	movl	$0, %ecx
	cmpq	$1, 200(%rbx)
	je	.L652
.L651:
	movq	224(%rbx), %rdx
	addq	$1, %rcx
	movq	-8(%rdx,%rax), %rsi
	movq	%rbp, %rdi
	addq	(%rdx,%rax), %rdi
	movq	%rdi, 0(%rbp,%rsi)
	addq	$8, %rax
	movq	200(%rbx), %rsi
	leaq	-1(%rsi), %rdx
	cmpq	%rdx, %rcx
	jb	.L651
.L652:
	movq	224(%rbx), %rax
	movq	(%rax,%rcx,8), %rax
	movq	%rbp, 0(%rbp,%rax)
.L653:
	movq	%rbp, 16(%rbx)
	movl	$0, mem_benchmark_rerun(%rip)
.L647:
	popq	%rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 40
	popq	%rbp
	.cfi_def_cfa_offset 32
	popq	%r12
	.cfi_def_cfa_offset 24
	popq	%r13
	.cfi_def_cfa_offset 16
	popq	%r14
	.cfi_def_cfa_offset 8
	ret
.L650:
	.cfi_restore_state
	leaq	.LC1(%rip), %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L649:
	movq	168(%rbx), %rsi
	movq	%rcx, %rax
	movl	$0, %edx
	divq	%rsi
	movq	%rax, %rdi
	movq	%rax, 200(%rbx)
	call	words_initialize
	movq	%rax, 224(%rbx)
	testq	%rax, %rax
	je	.L654
	movq	%r14, %r13
	cmpq	$1, 192(%rbx)
	jne	.L655
.L656:
	movq	208(%rbx), %rax
	movq	(%rax,%r13,8), %r9
	movq	(%rax), %r8
	movq	200(%rbx), %rcx
	testq	%rcx, %rcx
	je	.L659
.L660:
	movq	224(%rbx), %rsi
	leaq	0(%r13,%r12), %rax
	movl	$0, %edx
	divq	%rcx
	movq	%r9, %rdi
	addq	(%rsi,%rdx,8), %rdi
	addq	$1, %r12
	movq	%r12, %rax
	movl	$0, %edx
	divq	%rcx
	movq	%r8, %rax
	addq	(%rsi,%rdx,8), %rax
	addq	%rbp, %rax
	movq	%rax, 0(%rbp,%rdi)
	movq	200(%rbx), %rcx
	cmpq	%rcx, %r12
	jb	.L660
.L659:
	movq	208(%rbx), %rax
	addq	(%rax), %rbp
	jmp	.L653
.L654:
	leaq	.LC1(%rip), %rdi
	call	perror@PLT
	movl	$2, %edi
	call	exit@PLT
.L657:
	movq	192(%rbx), %rax
	subq	$1, %rax
	cmpq	%rax, %r13
	jnb	.L656
.L655:
	movq	208(%rbx), %rax
	leaq	0(,%r13,8), %rdx
	movq	(%rax,%r13,8), %r8
	movq	%r13, %r9
	addq	$1, %r13
	movq	8(%rax,%rdx), %r10
	movq	200(%rbx), %rcx
	testq	%rcx, %rcx
	je	.L657
	movq	%r12, %rsi
	addq	%rbp, %r8
	movq	%r13, %r11
.L658:
	movq	224(%rbx), %r14
	leaq	(%r9,%rsi), %rax
	movl	$0, %edx
	divq	%rcx
	movq	%r8, %rdi
	addq	(%r14,%rdx,8), %rdi
	leaq	(%r11,%rsi), %rax
	movl	$0, %edx
	divq	%rcx
	movq	%r10, %rax
	addq	(%r14,%rdx,8), %rax
	addq	%rbp, %rax
	movq	%rax, (%rdi)
	addq	$1, %rsi
	movq	200(%rbx), %rcx
	cmpq	%rsi, %rcx
	ja	.L658
	jmp	.L657
	.cfi_endproc
.LFE93:
	.size	thrash_initialize, .-thrash_initialize
	.section	.rodata.str1.1
.LC2:
	.string	"mem_initialize: malloc"
	.text
	.globl	mem_initialize
	.type	mem_initialize, @function
mem_initialize:
.LFB94:
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
	subq	$104, %rsp
	.cfi_def_cfa_offset 160
	movq	%rdi, 48(%rsp)
	testq	%rdi, %rdi
	je	.L701
.L670:
	addq	$104, %rsp
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
.L701:
	.cfi_restore_state
	movq	%rsi, %rbx
	call	base_initialize
	cmpl	$0, 144(%rbx)
	je	.L670
	movl	$0, 144(%rbx)
	movq	152(%rbx), %rax
	movl	$0, %edx
	divq	168(%rbx)
	movq	%rax, 80(%rsp)
	movl	%eax, %ebp
	movq	200(%rbx), %rax
	movq	%rax, 64(%rsp)
	movl	%eax, 24(%rsp)
	movq	184(%rbx), %r14
	movq	192(%rbx), %rdi
	movq	%rdi, 88(%rsp)
	movl	%edi, 28(%rsp)
	movslq	%eax, %rdi
	movl	$8, %esi
	call	words_initialize
	movq	%rax, %r15
	movq	%rax, 16(%rsp)
	movq	%rax, 224(%rbx)
	movslq	%r14d, %rdi
	movl	168(%rbx), %esi
	call	words_initialize
	movq	%rax, %r13
	movq	%rax, 216(%rbx)
	movq	208(%rbx), %rax
	movq	%rax, 72(%rsp)
	movq	8(%rbx), %rsi
	cmpq	$0, (%rbx)
	je	.L672
	testq	%rax, %rax
	sete	%al
	testq	%r13, %r13
	sete	%dl
	orb	%dl, %al
	jne	.L672
	testq	%r15, %r15
	je	.L672
	leal	-1(%r14), %eax
	movl	%eax, 32(%rsp)
	cmpl	$0, 88(%rsp)
	jle	.L687
	movq	72(%rsp), %rdi
	movq	64(%rsp), %rax
	leal	-1(%rax), %eax
	movq	16(%rsp), %rcx
	leaq	8(%rcx,%rax,8), %rax
	movq	%rax, 56(%rsp)
	movl	$0, %r8d
	movl	$0, 12(%rsp)
	leal	-1(%rbp), %eax
	movl	%eax, 40(%rsp)
	movl	80(%rsp), %eax
	leal	-1(%rax), %r12d
	leal	-1(%r14), %eax
	movl	%eax, 44(%rsp)
	movq	48(%rsp), %r11
	movl	28(%rsp), %eax
	subl	$1, %eax
	movl	%eax, 36(%rsp)
	jmp	.L676
.L672:
	leaq	.LC2(%rip), %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L678:
	leal	(%r10,%r8), %edx
	addl	$1, %r8d
	cmpl	%r9d, %r8d
	je	.L688
	addq	$8, %rcx
	cmpl	%r12d, %r8d
	je	.L689
.L683:
	movq	%r11, %rax
	movl	$0, %r15d
	cmpq	$0, 168(%rbx)
	je	.L680
.L677:
	movq	(%rdi), %rdx
	leaq	(%rsi,%rdx), %r14
	addq	%rax, %r14
	addq	(%rcx), %r14
	addq	8(%rcx), %rdx
	addq	%rax, %rdx
	addq	%rsi, %rdx
	movq	%rdx, (%r14)
	addl	$8, %r15d
	movslq	%r15d, %rax
	cmpq	168(%rbx), %rax
	jb	.L677
.L680:
	movl	%ebp, %eax
	cltd
	idivl	148(%rbx)
	movl	%eax, %r14d
	movl	%r8d, %eax
	cltd
	idivl	%r14d
	testl	%edx, %edx
	jne	.L678
	movl	%r8d, %eax
	cltd
	idivl	%r14d
	cmpl	$15, %eax
	jg	.L678
	movslq	%eax, %r14
	cltd
	idivl	24(%rsp)
	movslq	%edx, %rdx
	movq	(%rcx), %rax
	addq	(%rdi), %rax
	movq	16(%rsp), %r15
	addq	(%r15,%rdx,8), %rax
	addq	%rsi, %rax
	movq	%rax, 16(%rbx,%r14,8)
	jmp	.L678
.L688:
	movl	%r9d, %r8d
.L679:
	movl	12(%rsp), %ecx
	cmpl	%ecx, 36(%rsp)
	jg	.L702
.L681:
	addl	$1, 12(%rsp)
	movl	12(%rsp), %eax
	addq	$8, %rdi
	cmpl	%eax, 28(%rsp)
	je	.L675
.L676:
	cmpl	$0, 32(%rsp)
	jle	.L691
	cmpl	%r8d, 40(%rsp)
	jle	.L692
	movq	%r13, %rcx
	movl	44(%rsp), %eax
	leal	(%rax,%r8), %r9d
	movl	$1, %r10d
	subl	%r8d, %r10d
	jmp	.L683
.L689:
	movl	%r12d, %r8d
	jmp	.L679
.L691:
	movl	$0, %edx
	jmp	.L679
.L692:
	movl	$0, %edx
	jmp	.L679
.L702:
	cmpl	$0, 24(%rsp)
	jle	.L681
	movslq	%edx, %rax
	leaq	0(%r13,%rax,8), %r10
	movq	16(%rsp), %r9
	movq	56(%rsp), %r14
.L682:
	movq	%rsi, %rcx
	addq	(%r9), %rcx
	addq	(%rdi), %rcx
	addq	(%r10), %rcx
	movq	0(%r13), %rax
	addq	8(%rdi), %rax
	addq	(%r9), %rax
	addq	%rsi, %rax
	movq	%rax, (%rcx)
	addq	$8, %r9
	cmpq	%r14, %r9
	jne	.L682
	jmp	.L681
.L687:
	movl	32(%rsp), %edx
.L675:
	movq	64(%rsp), %rdi
	testl	%edi, %edi
	jle	.L684
	movslq	88(%rsp), %rax
	movq	72(%rsp), %r12
	leaq	-8(%r12,%rax,8), %r9
	movslq	%edx, %rdx
	leaq	0(%r13,%rdx,8), %r10
	leal	-1(%rdi), %r8d
	movl	24(%rsp), %r11d
	subl	$1, %r11d
	movl	$0, %edi
	movq	16(%rsp), %rbp
	movq	48(%rsp), %rcx
	jmp	.L686
.L694:
	movq	%rax, %rcx
.L686:
	leal	1(%rcx), %r14d
	cmpl	%ecx, %r11d
	cmove	%edi, %r14d
	movq	%rsi, %rdx
	addq	(%r9), %rdx
	addq	(%r10), %rdx
	addq	0(%rbp,%rcx,8), %rdx
	movq	0(%r13), %rax
	addq	(%r12), %rax
	movslq	%r14d, %r14
	addq	0(%rbp,%r14,8), %rax
	addq	%rsi, %rax
	movq	%rax, (%rdx)
	leaq	1(%rcx), %rax
	cmpq	%rcx, %r8
	jne	.L694
.L684:
	movl	$0, mem_benchmark_rerun(%rip)
	movl	64(%rsp), %eax
	imull	80(%rsp), %eax
	addl	$100, %eax
	movslq	%eax, %rdi
	imulq	$1374389535, %rdi, %rdi
	sarq	$37, %rdi
	sarl	$31, %eax
	subl	%eax, %edi
	movslq	%edi, %rdi
	movl	148(%rbx), %eax
	subl	$1, %eax
	cltq
	movq	%rbx, %rsi
	leaq	mem_benchmarks(%rip), %rdx
	call	*(%rdx,%rax,8)
	movl	$1, 144(%rbx)
	jmp	.L670
	.cfi_endproc
.LFE94:
	.size	mem_initialize, .-mem_initialize
	.globl	line_initialize
	.type	line_initialize, @function
line_initialize:
.LFB95:
	.cfi_startproc
	endbr64
	testq	%rdi, %rdi
	je	.L720
	ret
.L720:
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
	subq	$40, %rsp
	.cfi_def_cfa_offset 96
	movq	%rdi, %rbp
	movq	%rsi, %rbx
	movl	$0, %edi
	call	base_initialize
	cmpl	$0, 144(%rbx)
	jne	.L721
.L703:
	addq	$40, %rsp
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
.L721:
	.cfi_restore_state
	movl	$0, 144(%rbx)
	movq	184(%rbx), %r15
	movq	%r15, 8(%rsp)
	movq	192(%rbx), %r14
	movq	%r14, 16(%rsp)
	movslq	%r15d, %rdi
	movl	168(%rbx), %esi
	call	words_initialize
	movq	%rax, %r10
	movq	%rax, 216(%rbx)
	movq	208(%rbx), %r12
	movq	8(%rbx), %rsi
	movl	$1, 148(%rbx)
	cmpq	$0, (%rbx)
	je	.L703
	testq	%rax, %rax
	je	.L703
	testq	%r12, %r12
	je	.L703
	movl	%r14d, %r13d
	testl	%r14d, %r14d
	jle	.L705
	leal	-1(%r15), %r14d
	leal	-2(%r15), %eax
	leaq	8(%r10,%rax,8), %r8
	movl	%r14d, %eax
	testl	%r14d, %r14d
	movl	$0, %edx
	cmovle	%edx, %eax
	cltq
	leaq	(%r10,%rax,8), %r15
	movq	%r12, %rdi
	movl	$0, %r9d
	leal	-1(%r13), %r11d
	movl	$8, %eax
	subq	%r12, %rax
	movq	%rbx, 24(%rsp)
	movq	%rax, %rbx
	jmp	.L706
.L707:
	movq	(%rdi), %rax
	leaq	(%rsi,%rax), %rcx
	addq	(%rdx), %rcx
	addq	8(%rdx), %rax
	addq	%rsi, %rax
	movq	%rax, (%rcx)
	addq	$8, %rdx
	cmpq	%r8, %rdx
	jne	.L707
.L709:
	cmpl	%r9d, %r11d
	leaq	(%rbx,%rdi), %rax
	cmovle	%rbp, %rax
	movq	%rsi, %rdx
	addq	(%rdi), %rdx
	addq	(%r15), %rdx
	movq	%rsi, %rcx
	addq	(%r10), %rcx
	addq	(%r12,%rax), %rcx
	movq	%rcx, (%rdx)
	addl	$1, %r9d
	addq	$8, %rdi
	cmpl	%r9d, %r13d
	je	.L714
.L706:
	movq	%r10, %rdx
	testl	%r14d, %r14d
	jg	.L707
	jmp	.L709
.L714:
	movq	24(%rsp), %rbx
.L705:
	addq	(%r10), %rsi
	addq	(%r12), %rsi
	movq	%rsi, 16(%rbx)
	movl	$0, mem_benchmark_rerun(%rip)
	movl	16(%rsp), %eax
	imull	8(%rsp), %eax
	addl	$100, %eax
	movslq	%eax, %rdi
	imulq	$1374389535, %rdi, %rdi
	sarq	$37, %rdi
	sarl	$31, %eax
	subl	%eax, %edi
	movslq	%edi, %rdi
	movq	%rbx, %rsi
	call	mem_benchmark_0
	movl	$1, 144(%rbx)
	jmp	.L703
	.cfi_endproc
.LFE95:
	.size	line_initialize, .-line_initialize
	.section	.rodata.str1.1
.LC3:
	.string	"tlb_initialize: malloc"
.LC4:
	.string	"tlb_initialize: valloc"
	.text
	.globl	tlb_initialize
	.type	tlb_initialize, @function
tlb_initialize:
.LFB96:
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
	subq	$56, %rsp
	.cfi_def_cfa_offset 112
	movq	%rsi, 40(%rsp)
	testq	%rdi, %rdi
	je	.L741
.L722:
	addq	$56, %rsp
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
.L741:
	.cfi_restore_state
	movq	%rsi, %rax
	movl	$0, 144(%rsi)
	movq	176(%rsi), %rsi
	movq	%rsi, 24(%rsp)
	movslq	%esi, %rbp
	movq	%rbp, %rbx
	shrq	$3, %rbx
	movl	%ebx, 20(%rsp)
	movq	152(%rax), %rax
	movl	$0, %edx
	divq	%rbp
	movq	%rax, 32(%rsp)
	call	getpid@PLT
	movl	%eax, %r12d
	call	getppid@PLT
	movl	%eax, %edi
	sall	$7, %edi
	xorl	%r12d, %edi
	call	srand@PLT
	movslq	%ebx, %rcx
	movq	%rcx, 8(%rsp)
	movl	$8, %esi
	movq	%rcx, %rdi
	call	words_initialize
	movq	%rax, %r15
	movslq	32(%rsp), %r12
	leaq	0(,%r12,8), %rbx
	movq	%rbx, %rdi
	call	malloc@PLT
	movq	%rax, %r13
	movq	%rbx, %rdi
	call	malloc@PLT
	movq	%rax, %r14
	testq	%r15, %r15
	sete	%al
	testq	%r13, %r13
	sete	%dl
	orb	%dl, %al
	jne	.L736
	testq	%r14, %r14
	je	.L736
	movq	40(%rsp), %rax
	movq	$1, 200(%rax)
	movq	8(%rsp), %rsi
	movq	%rsi, 184(%rax)
	movq	%r12, 192(%rax)
	movq	$0, 224(%rax)
	movq	%r15, 216(%rax)
	movq	%r13, 208(%rax)
	movq	%r14, (%rax)
	movq	%rbx, %rdx
	movl	$0, %esi
	movq	%r14, %rdi
	call	memset@PLT
	movq	%rbx, %rdx
	movl	$0, %esi
	movq	%r13, %rdi
	call	memset@PLT
	movq	32(%rsp), %rsi
	testl	%esi, %esi
	jle	.L726
	movl	24(%rsp), %eax
	addl	%eax, %eax
	cltq
	movq	%rax, 24(%rsp)
	movq	%r14, %rbx
	movq	%r13, %r12
	leal	-1(%rsi), %eax
	leaq	8(%r14,%rax,8), %r14
	jmp	.L730
.L736:
	leaq	.LC3(%rip), %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L742:
	leaq	.LC4(%rip), %rdi
	call	perror@PLT
	movl	$4, %edi
	call	exit@PLT
.L743:
	leaq	.LC4(%rip), %rdi
	call	perror@PLT
	movl	$5, %edi
	call	exit@PLT
.L728:
	movq	%rdi, (%r12)
	addq	$8, %rbx
	addq	$8, %r12
	cmpq	%r14, %rbx
	je	.L726
.L730:
	movq	%rbp, %rdi
	call	valloc@PLT
	movq	%rax, %rdi
	movq	%rbx, 8(%rsp)
	movq	%rax, (%rbx)
	testq	%rax, %rax
	je	.L742
	movl	$0, %edx
	divq	%rbp
	testq	%rdx, %rdx
	je	.L728
	call	free@PLT
	movq	24(%rsp), %rdi
	call	valloc@PLT
	movq	%rax, %rdi
	movq	8(%rsp), %rax
	movq	%rdi, (%rax)
	testq	%rdi, %rdi
	je	.L743
	movq	%rdi, %rax
	movl	$0, %edx
	divq	%rbp
	movq	%rbp, %rax
	subq	%rdx, %rax
	addq	%rax, %rdi
	jmp	.L728
.L726:
	call	rand@PLT
	movl	%eax, %ebx
	call	rand@PLT
	movl	%ebx, %ecx
	sall	$15, %ecx
	xorl	%eax, %ecx
	movl	%ecx, %ebp
	movl	32(%rsp), %eax
	leal	-2(%rax), %ebx
	testl	%ebx, %ebx
	jle	.L731
	movslq	%ebx, %rbx
.L732:
	addl	%ebp, %ebp
	call	rand@PLT
	sarl	$4, %eax
	xorl	%eax, %ebp
	movl	%ebp, %eax
	movl	$0, %edx
	divl	%ebx
	leal	1(%rdx), %eax
	leaq	0(%r13,%rax,8), %rax
	movq	(%rax), %rdx
	movq	8(%r13,%rbx,8), %rsi
	movq	%rsi, (%rax)
	movq	%rdx, 8(%r13,%rbx,8)
	subq	$1, %rbx
	testl	%ebx, %ebx
	jg	.L732
.L731:
	movq	32(%rsp), %rax
	cmpl	$1, %eax
	jle	.L735
	leaq	8(%r13), %rsi
	leal	-1(%rax), %r9d
	movl	$0, %ecx
.L734:
	movl	%ecx, %eax
	addl	$1, %ecx
	movl	20(%rsp), %ebx
	cltd
	idivl	%ebx
	movslq	%edx, %rdx
	movq	-8(%rsi), %r8
	movq	(%r15,%rdx,8), %rdi
	movl	%ecx, %eax
	cltd
	idivl	%ebx
	movslq	%edx, %rdx
	movq	(%r15,%rdx,8), %rax
	addq	(%rsi), %rax
	movq	%rax, (%r8,%rdi)
	addq	$8, %rsi
	cmpl	%r9d, %ecx
	jne	.L734
.L733:
	movslq	%ecx, %rsi
	movl	%ecx, %eax
	cltd
	idivl	20(%rsp)
	movslq	%edx, %rdx
	movq	0(%r13,%rsi,8), %rcx
	movq	(%r15,%rdx,8), %rdx
	movq	(%r15), %rax
	addq	0(%r13), %rax
	movq	%rax, (%rcx,%rdx)
	movq	(%r15), %rax
	addq	0(%r13), %rax
	movq	40(%rsp), %rbx
	movq	%rax, 16(%rbx)
	movl	$0, mem_benchmark_rerun(%rip)
	movl	32(%rsp), %eax
	addl	$100, %eax
	movslq	%eax, %rdi
	imulq	$1374389535, %rdi, %rdi
	sarq	$37, %rdi
	sarl	$31, %eax
	subl	%eax, %edi
	movslq	%edi, %rdi
	movq	%rbx, %rsi
	call	mem_benchmark_0
	movl	$1, 144(%rbx)
	jmp	.L722
.L735:
	movl	$0, %ecx
	jmp	.L733
	.cfi_endproc
.LFE96:
	.size	tlb_initialize, .-tlb_initialize
	.section	.rodata.str1.1
.LC6:
	.string	"line_test: malloc"
	.text
	.globl	line_test
	.type	line_test, @function
line_test:
.LFB99:
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
	subq	$56, %rsp
	.cfi_def_cfa_offset 112
	movl	%edx, %ebp
	movq	%rcx, %r13
	movq	192(%rcx), %rsi
	movq	%rsi, 32(%rsp)
	movq	176(%rcx), %rax
	movl	$0, %edx
	divq	%rdi
	movq	%rax, 24(%rsp)
	movq	8(%rcx), %rdx
	movq	208(%rcx), %rax
	movq	216(%rcx), %rcx
	movq	%rdx, %rbx
	addq	(%rcx), %rbx
	addq	(%rax), %rbx
	testl	%ebp, %ebp
	movl	$11, %eax
	cmovs	%eax, %ebp
	movq	24(%rsp), %rax
	cmpq	%rax, 184(%r13)
	jbe	.L746
	subq	$1, %rsi
	movq	%rsi, %r10
	je	.L747
	leaq	-8(,%rax,8), %r9
	movl	$8, %eax
	movl	$0, %edi
.L748:
	movq	208(%r13), %r8
	addq	$1, %rdi
	movq	216(%r13), %rsi
	movq	%rdx, %rcx
	addq	-8(%r8,%rax), %rcx
	addq	(%rsi,%r9), %rcx
	movq	%rdx, %r11
	addq	(%rsi), %r11
	movq	%r11, %rsi
	addq	(%r8,%rax), %rsi
	movq	%rsi, (%rcx)
	addq	$8, %rax
	cmpq	%r10, %rdi
	jne	.L748
.L747:
	movq	208(%r13), %rsi
	movq	216(%r13), %rax
	movq	32(%rsp), %rdi
	movq	%rdx, %rcx
	addq	-8(%rsi,%rdi,8), %rcx
	movq	24(%rsp), %rdi
	addq	-8(%rax,%rdi,8), %rcx
	addq	(%rax), %rdx
	movq	%rdx, %rax
	addq	(%rsi), %rax
	movq	%rax, (%rcx)
.L746:
	movl	$0, %eax
	call	get_results@PLT
	movq	%rax, 40(%rsp)
	movl	%ebp, %edi
	call	sizeof_result@PLT
	movslq	%eax, %rdi
	call	malloc@PLT
	movq	%rax, %r15
	testq	%rax, %rax
	je	.L802
	movq	%rax, %rdi
	call	insertinit@PLT
	movslq	%ebp, %rax
	movq	%rax, 16(%rsp)
	testq	%rax, %rax
	je	.L750
	movl	$0, %r14d
	jmp	.L779
.L802:
	leaq	.LC6(%rip), %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L755:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
	movsd	%xmm0, (%rsp)
	jmp	.L756
.L762:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rdx, %xmm1
	addsd	%xmm1, %xmm1
	jmp	.L763
.L764:
	subsd	.LC13(%rip), %xmm0
	cvttsd2siq	%xmm0, %rax
	movq	%rax, __iterations.1(%rip)
	btcq	$63, __iterations.1(%rip)
	jmp	.L758
.L799:
	movq	__iterations.1(%rip), %rax
	cmpq	$134217728, %rax
	ja	.L788
	salq	$3, %rax
	movq	%rax, __iterations.1(%rip)
.L758:
	movq	%rbp, %xmm4
	comisd	(%rsp), %xmm4
	jbe	.L751
.L766:
	movl	$0, %edi
	call	start@PLT
	movq	__iterations.1(%rip), %rax
	testq	%rax, %rax
	je	.L753
.L754:
	movq	(%rbx), %rdx
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
	movq	(%rdx), %rbx
	subq	$1, %rax
	jne	.L754
.L753:
	movl	$0, %esi
	movl	$0, %edi
	call	stop@PLT
	testq	%rax, %rax
	js	.L755
	pxor	%xmm7, %xmm7
	cvtsi2sdq	%rax, %xmm7
	movsd	%xmm7, (%rsp)
.L756:
	movsd	.LC8(%rip), %xmm0
	movsd	8(%rsp), %xmm2
	mulsd	%xmm2, %xmm0
	movsd	(%rsp), %xmm3
	comisd	%xmm3, %xmm0
	ja	.L757
	mulsd	.LC9(%rip), %xmm2
	comisd	%xmm2, %xmm3
	jbe	.L758
.L757:
	movsd	(%rsp), %xmm6
	comisd	.LC10(%rip), %xmm6
	jbe	.L799
	movq	__iterations.1(%rip), %rax
	testq	%rax, %rax
	js	.L762
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rax, %xmm1
.L763:
	divsd	(%rsp), %xmm1
	movsd	8(%rsp), %xmm0
	mulsd	.LC11(%rip), %xmm0
	mulsd	%xmm1, %xmm0
	addsd	.LC12(%rip), %xmm0
	comisd	.LC13(%rip), %xmm0
	jnb	.L764
	cvttsd2siq	%xmm0, %rax
	movq	%rax, __iterations.1(%rip)
	jmp	.L758
.L788:
	pxor	%xmm7, %xmm7
	movsd	%xmm7, (%rsp)
.L751:
	movq	__iterations.1(%rip), %rdi
	call	save_n@PLT
	movsd	(%rsp), %xmm4
	comisd	.LC13(%rip), %xmm4
	jnb	.L767
	cvttsd2siq	%xmm4, %rdi
.L768:
	call	settime@PLT
	call	usecs_spent@PLT
	testq	%rax, %rax
	js	.L769
	pxor	%xmm5, %xmm5
	cvtsi2sdq	%rax, %xmm5
	movsd	%xmm5, (%rsp)
.L770:
	call	t_overhead@PLT
	movq	%rax, %rbp
	call	get_n@PLT
	movq	%rax, %r12
	call	l_overhead@PLT
	movapd	%xmm0, %xmm1
	testq	%r12, %r12
	js	.L771
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%r12, %xmm0
.L772:
	mulsd	%xmm1, %xmm0
	testq	%rbp, %rbp
	js	.L773
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rbp, %xmm1
.L774:
	addsd	%xmm1, %xmm0
	movsd	(%rsp), %xmm1
	subsd	%xmm0, %xmm1
	movl	$0, %edi
	comisd	.LC5(%rip), %xmm1
	jb	.L775
	comisd	.LC13(%rip), %xmm1
	jnb	.L777
	cvttsd2siq	%xmm1, %rdi
.L775:
	call	settime@PLT
	call	get_n@PLT
	movq	%rax, %rbp
	call	usecs_spent@PLT
	movq	%rax, %rdi
	movq	%r15, %rdx
	movq	%rbp, %rsi
	call	insertsort@PLT
	addq	$1, %r14
	cmpq	16(%rsp), %r14
	je	.L750
.L779:
	movl	$0, %edi
	call	get_enough@PLT
	pxor	%xmm6, %xmm6
	cvtsi2sdl	%eax, %xmm6
	movsd	%xmm6, 8(%rsp)
	movsd	.LC7(%rip), %xmm7
	mulsd	%xmm6, %xmm7
	movq	%xmm7, %rbp
	pxor	%xmm6, %xmm6
	comisd	%xmm6, %xmm7
	ja	.L766
	pxor	%xmm6, %xmm6
	movsd	%xmm6, (%rsp)
	jmp	.L751
.L767:
	movsd	(%rsp), %xmm0
	subsd	.LC13(%rip), %xmm0
	cvttsd2siq	%xmm0, %rdi
	btcq	$63, %rdi
	jmp	.L768
.L769:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
	movsd	%xmm0, (%rsp)
	jmp	.L770
.L771:
	movq	%r12, %rax
	shrq	%rax
	andl	$1, %r12d
	orq	%r12, %rax
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	addsd	%xmm0, %xmm0
	jmp	.L772
.L773:
	movq	%rbp, %rax
	shrq	%rax
	andl	$1, %ebp
	orq	%rbp, %rax
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rax, %xmm1
	addsd	%xmm1, %xmm1
	jmp	.L774
.L777:
	subsd	.LC13(%rip), %xmm1
	cvttsd2siq	%xmm1, %rdi
	btcq	$63, %rdi
	jmp	.L775
.L750:
	movq	%rbx, %rdi
	call	use_pointer@PLT
	movq	%r15, %rdi
	call	set_results@PLT
	call	usecs_spent@PLT
	movq	%rax, %rbx
	call	get_n@PLT
	testq	%rbx, %rbx
	js	.L780
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rbx, %xmm0
.L781:
	mulsd	.LC14(%rip), %xmm0
	testq	%rax, %rax
	js	.L782
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rax, %xmm1
.L783:
	divsd	%xmm1, %xmm0
	movq	%xmm0, %rbx
	movq	40(%rsp), %rdi
	call	set_results@PLT
	movq	%r15, %rdi
	call	free@PLT
	movq	24(%rsp), %rax
	cmpq	%rax, 184(%r13)
	jbe	.L744
	movq	8(%r13), %rsi
	movq	32(%rsp), %r10
	subq	$1, %r10
	je	.L785
	leaq	0(,%rax,8), %r8
	leaq	-8(%r8), %r9
	movl	$0, %edx
.L786:
	movq	208(%r13), %rax
	movq	(%rax,%rdx,8), %rax
	movq	216(%r13), %rdi
	leaq	(%rsi,%rax), %rcx
	addq	(%rdi,%r9), %rcx
	addq	(%rdi,%r8), %rax
	addq	%rsi, %rax
	movq	%rax, (%rcx)
	addq	$1, %rdx
	cmpq	%r10, %rdx
	jne	.L786
.L785:
	movq	208(%r13), %rax
	movq	32(%rsp), %rcx
	movq	-8(%rax,%rcx,8), %rax
	movq	216(%r13), %rcx
	leaq	(%rsi,%rax), %rdx
	movq	24(%rsp), %rdi
	addq	-8(%rcx,%rdi,8), %rdx
	addq	(%rcx,%rdi,8), %rax
	addq	%rax, %rsi
	movq	%rsi, (%rdx)
.L744:
	movq	%rbx, %xmm0
	addq	$56, %rsp
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
.L780:
	.cfi_restore_state
	movq	%rbx, %rdx
	shrq	%rdx
	andl	$1, %ebx
	orq	%rbx, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
	jmp	.L781
.L782:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rdx, %xmm1
	addsd	%xmm1, %xmm1
	jmp	.L783
	.cfi_endproc
.LFE99:
	.size	line_test, .-line_test
	.globl	line_find
	.type	line_find, @function
line_find:
.LFB98:
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
	movq	%rdi, %rbx
	movl	%esi, %r14d
	movl	%edx, %r13d
	movq	%rcx, %rbp
	call	getpagesize@PLT
	leal	15(%rax), %r12d
	testl	%eax, %eax
	cmovns	%eax, %r12d
	sarl	$4, %r12d
	movslq	%r12d, %r12
	testl	%r13d, %r13d
	movl	$11, %eax
	cmovs	%eax, %r13d
	movl	$1, 148(%rbp)
	movq	$8, 168(%rbp)
	movq	$0, 0(%rbp)
	testq	%rbx, %rbx
	jne	.L807
	movq	$-1, %rax
	jmp	.L803
.L825:
	shrq	%rbx
	je	.L824
.L807:
	movq	%rbx, 160(%rbp)
	movq	%rbx, 152(%rbp)
	movq	%rbp, %rsi
	movl	$0, %edi
	call	line_initialize
	cmpq	$0, 0(%rbp)
	je	.L825
	pxor	%xmm0, %xmm0
	movl	$0, %r15d
	movl	$8, %ebx
	cmpq	$7, %r12
	ja	.L812
	movl	$0, %ebx
	jmp	.L808
.L824:
	movq	$-1, %rax
	jmp	.L803
.L815:
	movl	$1, %r15d
.L810:
	addq	%rbx, %rbx
	cmpq	%rbx, %r12
	jb	.L826
.L812:
	movsd	%xmm0, 8(%rsp)
	movq	%rbp, %rcx
	movl	%r13d, %edx
	movl	%r14d, %esi
	movq	%rbx, %rdi
	call	line_test
	pxor	%xmm2, %xmm2
	ucomisd	%xmm2, %xmm0
	jp	.L817
	je	.L814
.L817:
	cmpq	$8, %rbx
	jbe	.L810
	movsd	8(%rsp), %xmm3
	movapd	%xmm3, %xmm1
	mulsd	.LC15(%rip), %xmm1
	comisd	%xmm1, %xmm0
	ja	.L815
	testq	%r15, %r15
	je	.L810
	mulsd	.LC16(%rip), %xmm3
	comisd	%xmm0, %xmm3
	jbe	.L810
	shrq	%rbx
	jmp	.L808
.L826:
	movl	$0, %ebx
	jmp	.L808
.L814:
	movl	$0, %ebx
.L808:
	movq	%rbp, %rsi
	movl	$0, %edi
	call	mem_cleanup
	movq	%rbx, %rax
.L803:
	addq	$24, %rsp
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
	.cfi_endproc
.LFE98:
	.size	line_find, .-line_find
	.globl	par_mem
	.type	par_mem, @function
par_mem:
.LFB100:
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
	movq	%fs:40, %rax
	movq	%rax, 264(%rsp)
	xorl	%eax, %eax
	movl	$1, 148(%rcx)
	movq	$0, (%rcx)
	testq	%rdi, %rdi
	je	.L879
	movq	%rcx, %rbx
	movq	%rdi, %rbp
	jmp	.L830
.L896:
	shrq	%rbp
	je	.L895
.L830:
	movq	%rbp, 160(%rbx)
	movq	%rbp, 152(%rbx)
	movq	%rbx, %rsi
	movl	$0, %edi
	call	mem_initialize
	cmpq	$0, (%rbx)
	je	.L896
	movq	%rbp, 56(%rsp)
	movq	%rbp, %rdx
	shrq	$3, %rdx
	addq	$100, %rdx
	shrq	$2, %rdx
	movabsq	$2951479051793528259, %rcx
	movq	%rdx, %rax
	mulq	%rcx
	shrq	$2, %rdx
	movq	%rdx, 48(%rsp)
	leaq	mem_benchmarks(%rip), %rax
	movq	%rax, 24(%rsp)
	leaq	24(%rbx), %rax
	movq	%rax, 32(%rsp)
	movl	$1, %r15d
	movsd	.LC12(%rip), %xmm7
	movsd	%xmm7, 64(%rsp)
	jmp	.L877
.L895:
	movsd	.LC17(%rip), %xmm5
	movsd	%xmm5, 64(%rsp)
	jmp	.L827
.L835:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
	movsd	%xmm0, 8(%rsp)
	jmp	.L836
.L842:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rdx, %xmm1
	addsd	%xmm1, %xmm1
	jmp	.L843
.L844:
	subsd	.LC13(%rip), %xmm0
	cvttsd2siq	%xmm0, %rax
	movq	%rax, __iterations.0(%rip)
	btcq	$63, __iterations.0(%rip)
	jmp	.L838
.L892:
	movq	__iterations.0(%rip), %rax
	cmpq	$134217728, %rax
	ja	.L881
	salq	$3, %rax
	movq	%rax, __iterations.0(%rip)
.L838:
	movq	%r12, %xmm4
	comisd	8(%rsp), %xmm4
	jbe	.L832
.L846:
	movl	$0, %edi
	call	start@PLT
	movq	__iterations.0(%rip), %rdi
	testq	%rdi, %rdi
	je	.L834
	movq	%rbx, %rsi
	call	*0(%rbp)
.L834:
	movl	$0, %esi
	movl	$0, %edi
	call	stop@PLT
	testq	%rax, %rax
	js	.L835
	pxor	%xmm7, %xmm7
	cvtsi2sdq	%rax, %xmm7
	movsd	%xmm7, 8(%rsp)
.L836:
	movsd	16(%rsp), %xmm2
	movapd	%xmm2, %xmm0
	mulsd	.LC8(%rip), %xmm0
	movsd	8(%rsp), %xmm3
	comisd	%xmm3, %xmm0
	ja	.L837
	mulsd	.LC9(%rip), %xmm2
	comisd	%xmm2, %xmm3
	jbe	.L838
.L837:
	movsd	8(%rsp), %xmm6
	comisd	.LC10(%rip), %xmm6
	jbe	.L892
	movq	__iterations.0(%rip), %rax
	testq	%rax, %rax
	js	.L842
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rax, %xmm1
.L843:
	divsd	8(%rsp), %xmm1
	movsd	16(%rsp), %xmm0
	mulsd	.LC11(%rip), %xmm0
	mulsd	%xmm1, %xmm0
	addsd	.LC12(%rip), %xmm0
	comisd	.LC13(%rip), %xmm0
	jnb	.L844
	cvttsd2siq	%xmm0, %rax
	movq	%rax, __iterations.0(%rip)
	jmp	.L838
.L881:
	pxor	%xmm7, %xmm7
	movsd	%xmm7, 8(%rsp)
.L832:
	movq	__iterations.0(%rip), %rdi
	call	save_n@PLT
	movsd	8(%rsp), %xmm4
	comisd	.LC13(%rip), %xmm4
	jnb	.L847
	cvttsd2siq	%xmm4, %rdi
.L848:
	call	settime@PLT
	call	usecs_spent@PLT
	testq	%rax, %rax
	js	.L849
	pxor	%xmm5, %xmm5
	cvtsi2sdq	%rax, %xmm5
	movsd	%xmm5, 8(%rsp)
.L850:
	call	t_overhead@PLT
	movq	%rax, %r12
	call	get_n@PLT
	movq	%rax, %r13
	call	l_overhead@PLT
	movapd	%xmm0, %xmm1
	testq	%r13, %r13
	js	.L851
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%r13, %xmm0
.L852:
	mulsd	%xmm1, %xmm0
	testq	%r12, %r12
	js	.L853
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%r12, %xmm1
.L854:
	addsd	%xmm1, %xmm0
	movsd	8(%rsp), %xmm1
	subsd	%xmm0, %xmm1
	movl	$0, %edi
	comisd	.LC5(%rip), %xmm1
	jb	.L855
	comisd	.LC13(%rip), %xmm1
	jnb	.L857
	cvttsd2siq	%xmm1, %rdi
.L855:
	call	settime@PLT
	call	usecs_spent@PLT
	testq	%rax, %rax
	jne	.L897
.L859:
	subq	$1, %r14
	je	.L898
.L860:
	movl	$0, %edi
	call	get_enough@PLT
	pxor	%xmm6, %xmm6
	cvtsi2sdl	%eax, %xmm6
	movsd	%xmm6, 16(%rsp)
	movsd	.LC7(%rip), %xmm7
	mulsd	%xmm6, %xmm7
	movq	%xmm7, %r12
	pxor	%xmm6, %xmm6
	comisd	%xmm6, %xmm7
	ja	.L846
	pxor	%xmm5, %xmm5
	movsd	%xmm5, 8(%rsp)
	jmp	.L832
.L847:
	movsd	8(%rsp), %xmm0
	subsd	.LC13(%rip), %xmm0
	cvttsd2siq	%xmm0, %rdi
	btcq	$63, %rdi
	jmp	.L848
.L849:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
	movsd	%xmm0, 8(%rsp)
	jmp	.L850
.L851:
	movq	%r13, %rax
	shrq	%rax
	andl	$1, %r13d
	orq	%r13, %rax
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	addsd	%xmm0, %xmm0
	jmp	.L852
.L853:
	movq	%r12, %rax
	shrq	%rax
	andl	$1, %r12d
	orq	%r12, %rax
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rax, %xmm1
	addsd	%xmm1, %xmm1
	jmp	.L854
.L857:
	subsd	.LC13(%rip), %xmm1
	cvttsd2siq	%xmm1, %rdi
	btcq	$63, %rdi
	jmp	.L855
.L897:
	call	get_n@PLT
	movq	%rax, %r12
	call	usecs_spent@PLT
	movq	%rax, %rdi
	leaq	80(%rsp), %rdx
	movq	%r12, %rsi
	call	insertsort@PLT
	jmp	.L859
.L898:
	movl	$0, %eax
	call	get_results@PLT
	movdqa	80(%rsp), %xmm6
	movups	%xmm6, (%rax)
	movdqa	96(%rsp), %xmm7
	movups	%xmm7, 16(%rax)
	movdqa	112(%rsp), %xmm5
	movups	%xmm5, 32(%rax)
	movdqa	128(%rsp), %xmm6
	movups	%xmm6, 48(%rax)
	movdqa	144(%rsp), %xmm7
	movups	%xmm7, 64(%rax)
	movdqa	160(%rsp), %xmm5
	movups	%xmm5, 80(%rax)
	movdqa	176(%rsp), %xmm6
	movups	%xmm6, 96(%rax)
	movdqa	192(%rsp), %xmm7
	movups	%xmm7, 112(%rax)
	movdqa	208(%rsp), %xmm5
	movups	%xmm5, 128(%rax)
	movdqa	224(%rsp), %xmm6
	movups	%xmm6, 144(%rax)
	movdqa	240(%rsp), %xmm7
	movups	%xmm7, 160(%rax)
	movq	256(%rsp), %rdx
	movq	%rdx, 176(%rax)
	cmpl	$0, 44(%rsp)
	je	.L899
	call	usecs_spent@PLT
	testq	%rax, %rax
	jne	.L900
.L867:
	cmpl	$15, %r15d
	jg	.L874
.L866:
	addq	$8, 24(%rsp)
	addq	$1, %r15
	addq	$8, 32(%rsp)
.L877:
	movl	%r15d, %eax
	subl	$1, %eax
	movl	%eax, 44(%rsp)
	js	.L876
	movq	168(%rbx), %rcx
	movq	56(%rsp), %rax
	movl	$0, %edx
	divq	%rcx
	movl	$0, %edx
	divq	%r15
	movq	%rax, %r13
	movq	176(%rbx), %rax
	movl	$0, %edx
	divq	%rcx
	movq	%rax, %r10
	movq	200(%rbx), %r9
	movq	8(%rbx), %r14
	movq	208(%rbx), %r12
	movq	216(%rbx), %rbp
	movq	224(%rbx), %r11
	leaq	16(%rbx), %r8
	movl	$0, %edi
	movl	$0, %esi
	movq	%rbx, 8(%rsp)
	movq	32(%rsp), %rbx
.L831:
	movq	%rdi, %rax
	movl	$0, %edx
	divq	%r10
	movq	0(%rbp,%rdx,8), %rcx
	addq	(%r12,%rax,8), %rcx
	movq	%rsi, %rax
	movl	$0, %edx
	divq	%r15
	movl	$0, %edx
	divq	%r9
	addq	(%r11,%rdx,8), %rcx
	addq	%r14, %rcx
	movq	%rcx, (%r8)
	addq	%r9, %rsi
	addq	%r13, %rdi
	addq	$8, %r8
	cmpq	%r8, %rbx
	jne	.L831
	movq	8(%rsp), %rbx
.L876:
	movl	$0, mem_benchmark_rerun(%rip)
	movq	24(%rsp), %r14
	movq	%r14, %rbp
	movq	%rbx, %rsi
	movq	48(%rsp), %rdi
	call	*(%r14)
	leaq	80(%rsp), %rdi
	call	insertinit@PLT
	movq	%rbx, %rsi
	movl	$1, %edi
	call	*(%r14)
	movl	$11, %r14d
	jmp	.L860
.L899:
	call	usecs_spent@PLT
	movq	%rax, %rbp
	call	get_n@PLT
	testq	%rbp, %rbp
	js	.L862
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rbp, %xmm1
.L863:
	testq	%rax, %rax
	js	.L864
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
.L865:
	divsd	%xmm0, %xmm1
	movsd	%xmm1, 72(%rsp)
	jmp	.L866
.L862:
	movq	%rbp, %rdx
	shrq	%rdx
	andl	$1, %ebp
	orq	%rbp, %rdx
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rdx, %xmm1
	addsd	%xmm1, %xmm1
	jmp	.L863
.L864:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
	jmp	.L865
.L900:
	call	usecs_spent@PLT
	movq	%rax, %rbp
	call	get_n@PLT
	testq	%rbp, %rbp
	js	.L868
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rbp, %xmm0
.L869:
	imulq	%r15, %rax
	testq	%rax, %rax
	js	.L870
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rax, %xmm1
.L871:
	divsd	%xmm1, %xmm0
	movsd	72(%rsp), %xmm1
	divsd	%xmm0, %xmm1
	maxsd	64(%rsp), %xmm1
	movsd	%xmm1, 64(%rsp)
	mulsd	.LC18(%rip), %xmm1
	movapd	%xmm1, %xmm0
	pxor	%xmm1, %xmm1
	cvtsi2sdl	44(%rsp), %xmm1
	comisd	%xmm0, %xmm1
	jbe	.L867
.L874:
	movq	%rbx, %rsi
	movl	$0, %edi
	call	mem_cleanup
.L827:
	movq	264(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L901
	movsd	64(%rsp), %xmm0
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
.L868:
	.cfi_restore_state
	movq	%rbp, %rdx
	shrq	%rdx
	andl	$1, %ebp
	orq	%rbp, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
	jmp	.L869
.L870:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rdx, %xmm1
	addsd	%xmm1, %xmm1
	jmp	.L871
.L879:
	movsd	.LC17(%rip), %xmm6
	movsd	%xmm6, 64(%rsp)
	jmp	.L827
.L901:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE100:
	.size	par_mem, .-par_mem
	.data
	.align 8
	.type	__iterations.0, @object
	.size	__iterations.0, 8
__iterations.0:
	.quad	1
	.align 8
	.type	__iterations.1, @object
	.size	__iterations.1, 8
__iterations.1:
	.quad	1
	.local	sp15.2
	.comm	sp15.2,8,8
	.local	sp14.3
	.comm	sp14.3,8,8
	.local	sp13.4
	.comm	sp13.4,8,8
	.local	sp12.5
	.comm	sp12.5,8,8
	.local	sp11.6
	.comm	sp11.6,8,8
	.local	sp10.7
	.comm	sp10.7,8,8
	.local	sp9.8
	.comm	sp9.8,8,8
	.local	sp8.9
	.comm	sp8.9,8,8
	.local	sp7.10
	.comm	sp7.10,8,8
	.local	sp6.11
	.comm	sp6.11,8,8
	.local	sp5.12
	.comm	sp5.12,8,8
	.local	sp4.13
	.comm	sp4.13,8,8
	.local	sp3.14
	.comm	sp3.14,8,8
	.local	sp2.15
	.comm	sp2.15,8,8
	.local	sp1.16
	.comm	sp1.16,8,8
	.local	sp0.17
	.comm	sp0.17,8,8
	.local	addr_save.18
	.comm	addr_save.18,8,8
	.local	sp14.19
	.comm	sp14.19,8,8
	.local	sp13.20
	.comm	sp13.20,8,8
	.local	sp12.21
	.comm	sp12.21,8,8
	.local	sp11.22
	.comm	sp11.22,8,8
	.local	sp10.23
	.comm	sp10.23,8,8
	.local	sp9.24
	.comm	sp9.24,8,8
	.local	sp8.25
	.comm	sp8.25,8,8
	.local	sp7.26
	.comm	sp7.26,8,8
	.local	sp6.27
	.comm	sp6.27,8,8
	.local	sp5.28
	.comm	sp5.28,8,8
	.local	sp4.29
	.comm	sp4.29,8,8
	.local	sp3.30
	.comm	sp3.30,8,8
	.local	sp2.31
	.comm	sp2.31,8,8
	.local	sp1.32
	.comm	sp1.32,8,8
	.local	sp0.33
	.comm	sp0.33,8,8
	.local	addr_save.34
	.comm	addr_save.34,8,8
	.local	sp13.35
	.comm	sp13.35,8,8
	.local	sp12.36
	.comm	sp12.36,8,8
	.local	sp11.37
	.comm	sp11.37,8,8
	.local	sp10.38
	.comm	sp10.38,8,8
	.local	sp9.39
	.comm	sp9.39,8,8
	.local	sp8.40
	.comm	sp8.40,8,8
	.local	sp7.41
	.comm	sp7.41,8,8
	.local	sp6.42
	.comm	sp6.42,8,8
	.local	sp5.43
	.comm	sp5.43,8,8
	.local	sp4.44
	.comm	sp4.44,8,8
	.local	sp3.45
	.comm	sp3.45,8,8
	.local	sp2.46
	.comm	sp2.46,8,8
	.local	sp1.47
	.comm	sp1.47,8,8
	.local	sp0.48
	.comm	sp0.48,8,8
	.local	addr_save.49
	.comm	addr_save.49,8,8
	.local	sp12.50
	.comm	sp12.50,8,8
	.local	sp11.51
	.comm	sp11.51,8,8
	.local	sp10.52
	.comm	sp10.52,8,8
	.local	sp9.53
	.comm	sp9.53,8,8
	.local	sp8.54
	.comm	sp8.54,8,8
	.local	sp7.55
	.comm	sp7.55,8,8
	.local	sp6.56
	.comm	sp6.56,8,8
	.local	sp5.57
	.comm	sp5.57,8,8
	.local	sp4.58
	.comm	sp4.58,8,8
	.local	sp3.59
	.comm	sp3.59,8,8
	.local	sp2.60
	.comm	sp2.60,8,8
	.local	sp1.61
	.comm	sp1.61,8,8
	.local	sp0.62
	.comm	sp0.62,8,8
	.local	addr_save.63
	.comm	addr_save.63,8,8
	.local	sp11.64
	.comm	sp11.64,8,8
	.local	sp10.65
	.comm	sp10.65,8,8
	.local	sp9.66
	.comm	sp9.66,8,8
	.local	sp8.67
	.comm	sp8.67,8,8
	.local	sp7.68
	.comm	sp7.68,8,8
	.local	sp6.69
	.comm	sp6.69,8,8
	.local	sp5.70
	.comm	sp5.70,8,8
	.local	sp4.71
	.comm	sp4.71,8,8
	.local	sp3.72
	.comm	sp3.72,8,8
	.local	sp2.73
	.comm	sp2.73,8,8
	.local	sp1.74
	.comm	sp1.74,8,8
	.local	sp0.75
	.comm	sp0.75,8,8
	.local	addr_save.76
	.comm	addr_save.76,8,8
	.local	sp10.77
	.comm	sp10.77,8,8
	.local	sp9.78
	.comm	sp9.78,8,8
	.local	sp8.79
	.comm	sp8.79,8,8
	.local	sp7.80
	.comm	sp7.80,8,8
	.local	sp6.81
	.comm	sp6.81,8,8
	.local	sp5.82
	.comm	sp5.82,8,8
	.local	sp4.83
	.comm	sp4.83,8,8
	.local	sp3.84
	.comm	sp3.84,8,8
	.local	sp2.85
	.comm	sp2.85,8,8
	.local	sp1.86
	.comm	sp1.86,8,8
	.local	sp0.87
	.comm	sp0.87,8,8
	.local	addr_save.88
	.comm	addr_save.88,8,8
	.local	sp9.89
	.comm	sp9.89,8,8
	.local	sp8.90
	.comm	sp8.90,8,8
	.local	sp7.91
	.comm	sp7.91,8,8
	.local	sp6.92
	.comm	sp6.92,8,8
	.local	sp5.93
	.comm	sp5.93,8,8
	.local	sp4.94
	.comm	sp4.94,8,8
	.local	sp3.95
	.comm	sp3.95,8,8
	.local	sp2.96
	.comm	sp2.96,8,8
	.local	sp1.97
	.comm	sp1.97,8,8
	.local	sp0.98
	.comm	sp0.98,8,8
	.local	addr_save.99
	.comm	addr_save.99,8,8
	.local	sp8.100
	.comm	sp8.100,8,8
	.local	sp7.101
	.comm	sp7.101,8,8
	.local	sp6.102
	.comm	sp6.102,8,8
	.local	sp5.103
	.comm	sp5.103,8,8
	.local	sp4.104
	.comm	sp4.104,8,8
	.local	sp3.105
	.comm	sp3.105,8,8
	.local	sp2.106
	.comm	sp2.106,8,8
	.local	sp1.107
	.comm	sp1.107,8,8
	.local	sp0.108
	.comm	sp0.108,8,8
	.local	addr_save.109
	.comm	addr_save.109,8,8
	.local	sp7.110
	.comm	sp7.110,8,8
	.local	sp6.111
	.comm	sp6.111,8,8
	.local	sp5.112
	.comm	sp5.112,8,8
	.local	sp4.113
	.comm	sp4.113,8,8
	.local	sp3.114
	.comm	sp3.114,8,8
	.local	sp2.115
	.comm	sp2.115,8,8
	.local	sp1.116
	.comm	sp1.116,8,8
	.local	sp0.117
	.comm	sp0.117,8,8
	.local	addr_save.118
	.comm	addr_save.118,8,8
	.local	sp6.119
	.comm	sp6.119,8,8
	.local	sp5.120
	.comm	sp5.120,8,8
	.local	sp4.121
	.comm	sp4.121,8,8
	.local	sp3.122
	.comm	sp3.122,8,8
	.local	sp2.123
	.comm	sp2.123,8,8
	.local	sp1.124
	.comm	sp1.124,8,8
	.local	sp0.125
	.comm	sp0.125,8,8
	.local	addr_save.126
	.comm	addr_save.126,8,8
	.local	sp5.127
	.comm	sp5.127,8,8
	.local	sp4.128
	.comm	sp4.128,8,8
	.local	sp3.129
	.comm	sp3.129,8,8
	.local	sp2.130
	.comm	sp2.130,8,8
	.local	sp1.131
	.comm	sp1.131,8,8
	.local	sp0.132
	.comm	sp0.132,8,8
	.local	addr_save.133
	.comm	addr_save.133,8,8
	.local	sp4.134
	.comm	sp4.134,8,8
	.local	sp3.135
	.comm	sp3.135,8,8
	.local	sp2.136
	.comm	sp2.136,8,8
	.local	sp1.137
	.comm	sp1.137,8,8
	.local	sp0.138
	.comm	sp0.138,8,8
	.local	addr_save.139
	.comm	addr_save.139,8,8
	.local	sp3.140
	.comm	sp3.140,8,8
	.local	sp2.141
	.comm	sp2.141,8,8
	.local	sp1.142
	.comm	sp1.142,8,8
	.local	sp0.143
	.comm	sp0.143,8,8
	.local	addr_save.144
	.comm	addr_save.144,8,8
	.local	sp2.145
	.comm	sp2.145,8,8
	.local	sp1.146
	.comm	sp1.146,8,8
	.local	sp0.147
	.comm	sp0.147,8,8
	.local	addr_save.148
	.comm	addr_save.148,8,8
	.local	sp1.149
	.comm	sp1.149,8,8
	.local	sp0.150
	.comm	sp0.150,8,8
	.local	addr_save.151
	.comm	addr_save.151,8,8
	.local	sp0.152
	.comm	sp0.152,8,8
	.local	addr_save.153
	.comm	addr_save.153,8,8
	.local	mem_benchmark_rerun
	.comm	mem_benchmark_rerun,4,4
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
	.section	.rodata.cst8,"aM",@progbits,8
	.align 8
.LC5:
	.long	0
	.long	0
	.align 8
.LC7:
	.long	1717986918
	.long	1072588390
	.align 8
.LC8:
	.long	2061584302
	.long	1072672276
	.align 8
.LC9:
	.long	858993459
	.long	1072902963
	.align 8
.LC10:
	.long	0
	.long	1080213504
	.align 8
.LC11:
	.long	-1717986918
	.long	1072798105
	.align 8
.LC12:
	.long	0
	.long	1072693248
	.align 8
.LC13:
	.long	0
	.long	1138753536
	.align 8
.LC14:
	.long	0
	.long	1076101120
	.align 8
.LC15:
	.long	-858993459
	.long	1073007820
	.align 8
.LC16:
	.long	1717986918
	.long	1072850534
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
