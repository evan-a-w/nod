	.file	"lib_debug.c"
	.text
	.globl	percent_point
	.type	percent_point, @function
percent_point:
.LFB8:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$48, %rsp
	movsd	%xmm0, -40(%rbp)
	movl	$0, %eax
	call	get_results@PLT
	movq	%rax, -16(%rbp)
	movsd	.LC0(%rip), %xmm0
	movapd	%xmm0, %xmm1
	subsd	-40(%rbp), %xmm1
	movq	-16(%rbp), %rax
	movl	(%rax), %eax
	subl	$1, %eax
	pxor	%xmm0, %xmm0
	cvtsi2sdl	%eax, %xmm0
	mulsd	%xmm1, %xmm0
	movsd	%xmm0, -8(%rbp)
	movq	-8(%rbp), %rax
	movq	%rax, %xmm0
	call	floor@PLT
	movq	%xmm0, %rax
	movq	%rax, %xmm2
	ucomisd	-8(%rbp), %xmm2
	jp	.L2
	movq	%rax, %xmm3
	ucomisd	-8(%rbp), %xmm3
	jne	.L2
	movsd	-8(%rbp), %xmm0
	cvttsd2sil	%xmm0, %eax
	movq	-16(%rbp), %rdx
	cltq
	salq	$4, %rax
	addq	%rdx, %rax
	addq	$8, %rax
	movq	(%rax), %rax
	testq	%rax, %rax
	js	.L4
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L5
.L4:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L5:
	movsd	-8(%rbp), %xmm1
	cvttsd2sil	%xmm1, %eax
	movq	-16(%rbp), %rdx
	cltq
	salq	$4, %rax
	addq	%rdx, %rax
	addq	$16, %rax
	movq	(%rax), %rax
	testq	%rax, %rax
	js	.L6
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rax, %xmm1
	jmp	.L7
.L6:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rdx, %xmm1
	addsd	%xmm1, %xmm1
.L7:
	divsd	%xmm1, %xmm0
	movsd	%xmm0, -24(%rbp)
	jmp	.L8
.L2:
	movsd	-8(%rbp), %xmm0
	cvttsd2sil	%xmm0, %eax
	movq	-16(%rbp), %rdx
	cltq
	salq	$4, %rax
	addq	%rdx, %rax
	addq	$8, %rax
	movq	(%rax), %rax
	testq	%rax, %rax
	js	.L9
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L10
.L9:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L10:
	movsd	-8(%rbp), %xmm1
	cvttsd2sil	%xmm1, %eax
	movq	-16(%rbp), %rdx
	cltq
	salq	$4, %rax
	addq	%rdx, %rax
	addq	$16, %rax
	movq	(%rax), %rax
	testq	%rax, %rax
	js	.L11
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rax, %xmm1
	jmp	.L12
.L11:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rdx, %xmm1
	addsd	%xmm1, %xmm1
.L12:
	divsd	%xmm1, %xmm0
	movsd	%xmm0, -24(%rbp)
	movsd	-8(%rbp), %xmm0
	cvttsd2sil	%xmm0, %eax
	addl	$1, %eax
	movq	-16(%rbp), %rdx
	cltq
	salq	$4, %rax
	addq	%rdx, %rax
	addq	$8, %rax
	movq	(%rax), %rax
	testq	%rax, %rax
	js	.L13
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L14
.L13:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L14:
	movsd	-8(%rbp), %xmm1
	cvttsd2sil	%xmm1, %eax
	addl	$1, %eax
	movq	-16(%rbp), %rdx
	cltq
	salq	$4, %rax
	addq	%rdx, %rax
	addq	$16, %rax
	movq	(%rax), %rax
	testq	%rax, %rax
	js	.L15
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rax, %xmm1
	jmp	.L16
.L15:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rdx, %xmm1
	addsd	%xmm1, %xmm1
.L16:
	divsd	%xmm1, %xmm0
	movsd	-24(%rbp), %xmm1
	addsd	%xmm1, %xmm0
	movsd	%xmm0, -24(%rbp)
	movsd	-24(%rbp), %xmm0
	movsd	.LC1(%rip), %xmm1
	divsd	%xmm1, %xmm0
	movsd	%xmm0, -24(%rbp)
.L8:
	movsd	-24(%rbp), %xmm0
	movq	%xmm0, %rax
	movq	%rax, %xmm0
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE8:
	.size	percent_point, .-percent_point
	.section	.rodata
.LC2:
	.string	"N=%d, t={"
.LC3:
	.string	"%.2f"
.LC4:
	.string	", "
.LC5:
	.string	"}\n"
.LC6:
	.string	"\t/* %d {"
.LC7:
	.string	"%llu/%llu"
.LC8:
	.string	"} */\n"
	.text
	.globl	print_results
	.type	print_results, @function
print_results:
.LFB9:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movl	%edi, -20(%rbp)
	movl	$0, %eax
	call	get_results@PLT
	movq	%rax, -8(%rbp)
	movq	-8(%rbp), %rax
	movl	(%rax), %edx
	movq	stderr(%rip), %rax
	leaq	.LC2(%rip), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf@PLT
	movl	$0, -12(%rbp)
	jmp	.L20
.L26:
	movq	-8(%rbp), %rdx
	movl	-12(%rbp), %eax
	cltq
	salq	$4, %rax
	addq	%rdx, %rax
	addq	$8, %rax
	movq	(%rax), %rax
	testq	%rax, %rax
	js	.L21
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L22
.L21:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L22:
	movq	-8(%rbp), %rdx
	movl	-12(%rbp), %eax
	cltq
	salq	$4, %rax
	addq	%rdx, %rax
	addq	$16, %rax
	movq	(%rax), %rax
	testq	%rax, %rax
	js	.L23
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rax, %xmm1
	jmp	.L24
.L23:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rdx, %xmm1
	addsd	%xmm1, %xmm1
.L24:
	divsd	%xmm1, %xmm0
	movq	%xmm0, %rdx
	movq	stderr(%rip), %rax
	movq	%rdx, %xmm0
	leaq	.LC3(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	movl	$1, %eax
	call	fprintf@PLT
	movq	-8(%rbp), %rax
	movl	(%rax), %eax
	subl	$1, %eax
	cmpl	%eax, -12(%rbp)
	jge	.L25
	movq	stderr(%rip), %rax
	movq	%rax, %rcx
	movl	$2, %edx
	movl	$1, %esi
	leaq	.LC4(%rip), %rax
	movq	%rax, %rdi
	call	fwrite@PLT
.L25:
	addl	$1, -12(%rbp)
.L20:
	movq	-8(%rbp), %rax
	movl	(%rax), %eax
	cmpl	%eax, -12(%rbp)
	jl	.L26
	movq	stderr(%rip), %rax
	movq	%rax, %rcx
	movl	$2, %edx
	movl	$1, %esi
	leaq	.LC5(%rip), %rax
	movq	%rax, %rdi
	call	fwrite@PLT
	cmpl	$0, -20(%rbp)
	je	.L31
	movq	-8(%rbp), %rax
	movl	(%rax), %edx
	movq	stderr(%rip), %rax
	leaq	.LC6(%rip), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf@PLT
	movl	$0, -12(%rbp)
	jmp	.L28
.L30:
	movq	-8(%rbp), %rdx
	movl	-12(%rbp), %eax
	cltq
	salq	$4, %rax
	addq	%rdx, %rax
	addq	$16, %rax
	movq	(%rax), %rcx
	movq	-8(%rbp), %rdx
	movl	-12(%rbp), %eax
	cltq
	salq	$4, %rax
	addq	%rdx, %rax
	addq	$8, %rax
	movq	(%rax), %rdx
	movq	stderr(%rip), %rax
	leaq	.LC7(%rip), %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf@PLT
	movq	-8(%rbp), %rax
	movl	(%rax), %eax
	subl	$1, %eax
	cmpl	%eax, -12(%rbp)
	jge	.L29
	movq	stderr(%rip), %rax
	movq	%rax, %rcx
	movl	$2, %edx
	movl	$1, %esi
	leaq	.LC4(%rip), %rax
	movq	%rax, %rdi
	call	fwrite@PLT
.L29:
	addl	$1, -12(%rbp)
.L28:
	movq	-8(%rbp), %rax
	movl	(%rax), %eax
	cmpl	%eax, -12(%rbp)
	jl	.L30
	movq	stderr(%rip), %rax
	movq	%rax, %rcx
	movl	$5, %edx
	movl	$1, %esi
	leaq	.LC8(%rip), %rax
	movq	%rax, %rdi
	call	fwrite@PLT
.L31:
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE9:
	.size	print_results, .-print_results
	.section	.rodata
.LC14:
	.string	"%lu\t%e\t%e\t%e\t%e\t%e\n"
	.text
	.globl	bw_quartile
	.type	bw_quartile, @function
bw_quartile:
.LFB10:
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
	movq	-24(%rbp), %rax
	testq	%rax, %rax
	js	.L33
	pxor	%xmm4, %xmm4
	cvtsi2sdq	%rax, %xmm4
	movsd	%xmm4, -32(%rbp)
	jmp	.L34
.L33:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
	movsd	%xmm0, -32(%rbp)
.L34:
	movq	.LC0(%rip), %rax
	movq	%rax, %xmm0
	call	percent_point
	movsd	.LC9(%rip), %xmm1
	mulsd	%xmm1, %xmm0
	movsd	-32(%rbp), %xmm5
	divsd	%xmm0, %xmm5
	movsd	%xmm5, -40(%rbp)
	movq	-24(%rbp), %rax
	testq	%rax, %rax
	js	.L35
	pxor	%xmm4, %xmm4
	cvtsi2sdq	%rax, %xmm4
	movsd	%xmm4, -32(%rbp)
	jmp	.L36
.L35:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
	movsd	%xmm0, -32(%rbp)
.L36:
	movq	.LC10(%rip), %rax
	movq	%rax, %xmm0
	call	percent_point
	movsd	.LC9(%rip), %xmm1
	mulsd	%xmm1, %xmm0
	movsd	-32(%rbp), %xmm6
	divsd	%xmm0, %xmm6
	movsd	%xmm6, -48(%rbp)
	movq	-24(%rbp), %rax
	testq	%rax, %rax
	js	.L37
	pxor	%xmm5, %xmm5
	cvtsi2sdq	%rax, %xmm5
	movsd	%xmm5, -32(%rbp)
	jmp	.L38
.L37:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
	movsd	%xmm0, -32(%rbp)
.L38:
	movq	.LC11(%rip), %rax
	movq	%rax, %xmm0
	call	percent_point
	movsd	.LC9(%rip), %xmm1
	mulsd	%xmm1, %xmm0
	movsd	-32(%rbp), %xmm7
	divsd	%xmm0, %xmm7
	movsd	%xmm7, -56(%rbp)
	movq	-24(%rbp), %rax
	testq	%rax, %rax
	js	.L39
	pxor	%xmm6, %xmm6
	cvtsi2sdq	%rax, %xmm6
	movsd	%xmm6, -32(%rbp)
	jmp	.L40
.L39:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
	movsd	%xmm0, -32(%rbp)
.L40:
	movq	.LC12(%rip), %rax
	movq	%rax, %xmm0
	call	percent_point
	movsd	.LC9(%rip), %xmm1
	mulsd	%xmm1, %xmm0
	movsd	-32(%rbp), %xmm2
	divsd	%xmm0, %xmm2
	movsd	%xmm2, -64(%rbp)
	movq	-24(%rbp), %rax
	testq	%rax, %rax
	js	.L41
	pxor	%xmm7, %xmm7
	cvtsi2sdq	%rax, %xmm7
	movsd	%xmm7, -32(%rbp)
	jmp	.L42
.L41:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
	movsd	%xmm0, -32(%rbp)
.L42:
	movq	.LC13(%rip), %rax
	movq	%rax, %xmm0
	call	percent_point
	movsd	.LC9(%rip), %xmm1
	mulsd	%xmm1, %xmm0
	movsd	-32(%rbp), %xmm3
	divsd	%xmm0, %xmm3
	movq	%xmm3, %rbx
	call	get_n@PLT
	movq	%rax, %rdx
	movq	stderr(%rip), %rax
	movsd	-40(%rbp), %xmm4
	movsd	-48(%rbp), %xmm3
	movsd	-56(%rbp), %xmm2
	movsd	-64(%rbp), %xmm1
	movq	%rbx, %xmm0
	leaq	.LC14(%rip), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	movl	$5, %eax
	call	fprintf@PLT
	nop
	movq	-8(%rbp), %rbx
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE10:
	.size	bw_quartile, .-bw_quartile
	.globl	nano_quartile
	.type	nano_quartile, @function
nano_quartile:
.LFB11:
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
	movq	.LC0(%rip), %rax
	movq	%rax, %xmm0
	call	percent_point
	movsd	.LC15(%rip), %xmm1
	mulsd	%xmm0, %xmm1
	movq	-24(%rbp), %rax
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
	divsd	%xmm0, %xmm1
	movsd	%xmm1, -32(%rbp)
	movq	.LC10(%rip), %rax
	movq	%rax, %xmm0
	call	percent_point
	movsd	.LC15(%rip), %xmm1
	mulsd	%xmm0, %xmm1
	movq	-24(%rbp), %rax
	testq	%rax, %rax
	js	.L46
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L47
.L46:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L47:
	divsd	%xmm0, %xmm1
	movsd	%xmm1, -40(%rbp)
	movq	.LC11(%rip), %rax
	movq	%rax, %xmm0
	call	percent_point
	movsd	.LC15(%rip), %xmm1
	mulsd	%xmm0, %xmm1
	movq	-24(%rbp), %rax
	testq	%rax, %rax
	js	.L48
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L49
.L48:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L49:
	divsd	%xmm0, %xmm1
	movsd	%xmm1, -48(%rbp)
	movq	.LC12(%rip), %rax
	movq	%rax, %xmm0
	call	percent_point
	movsd	.LC15(%rip), %xmm1
	mulsd	%xmm0, %xmm1
	movq	-24(%rbp), %rax
	testq	%rax, %rax
	js	.L50
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L51
.L50:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L51:
	divsd	%xmm0, %xmm1
	movsd	%xmm1, -56(%rbp)
	movq	.LC13(%rip), %rax
	movq	%rax, %xmm0
	call	percent_point
	movsd	.LC15(%rip), %xmm1
	mulsd	%xmm0, %xmm1
	movq	-24(%rbp), %rax
	testq	%rax, %rax
	js	.L52
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L53
.L52:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L53:
	divsd	%xmm0, %xmm1
	movq	%xmm1, %rbx
	call	get_n@PLT
	movq	%rax, %rdx
	movq	stderr(%rip), %rax
	movsd	-32(%rbp), %xmm4
	movsd	-40(%rbp), %xmm3
	movsd	-48(%rbp), %xmm2
	movsd	-56(%rbp), %xmm1
	movq	%rbx, %xmm0
	leaq	.LC14(%rip), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	movl	$5, %eax
	call	fprintf@PLT
	nop
	movq	-8(%rbp), %rbx
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE11:
	.size	nano_quartile, .-nano_quartile
	.section	.rodata
.LC16:
	.string	"\t%lu\t%lu\t%lu\n"
	.text
	.globl	print_mem
	.type	print_mem, @function
print_mem:
.LFB12:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$64, %rsp
	movq	%rdi, -40(%rbp)
	movq	%rsi, -48(%rbp)
	movq	%rdx, -56(%rbp)
	call	getpagesize@PLT
	cltq
	movq	%rax, -24(%rbp)
	movq	-40(%rbp), %rax
	movq	%rax, -16(%rbp)
	movq	-40(%rbp), %rax
	movq	%rax, -32(%rbp)
	jmp	.L55
.L56:
	movq	-32(%rbp), %rax
	subq	-16(%rbp), %rax
	movq	%rax, -8(%rbp)
	movq	-8(%rbp), %rax
	movl	$0, %edx
	divq	-56(%rbp)
	movq	%rdx, %rax
	shrq	$3, %rax
	movq	%rax, %rcx
	movq	-8(%rbp), %rax
	movl	$0, %edx
	divq	-24(%rbp)
	movq	%rdx, %rax
	movl	$0, %edx
	divq	-56(%rbp)
	movq	%rax, %rsi
	movq	-8(%rbp), %rax
	movl	$0, %edx
	divq	-24(%rbp)
	movq	%rax, %rdx
	movq	stderr(%rip), %rax
	movq	%rcx, %r8
	movq	%rsi, %rcx
	leaq	.LC16(%rip), %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf@PLT
	movq	-32(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rbp)
.L55:
	movq	-32(%rbp), %rax
	movq	(%rax), %rax
	cmpq	%rax, -40(%rbp)
	jne	.L56
	nop
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE12:
	.size	print_mem, .-print_mem
	.section	.rodata
	.align 8
.LC17:
	.string	"check_mem: pointer out of range!\n"
	.align 8
.LC18:
	.string	"check_mem: pointer chain doesn't loop\n"
	.text
	.globl	check_mem
	.type	check_mem, @function
check_mem:
.LFB13:
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
	shrq	$3, %rax
	addq	$1, %rax
	movq	%rax, -8(%rbp)
	movq	-40(%rbp), %rax
	movq	%rax, -24(%rbp)
	movq	$0, -16(%rbp)
	jmp	.L58
.L62:
	movq	-24(%rbp), %rax
	cmpq	-40(%rbp), %rax
	jb	.L59
	movq	-40(%rbp), %rdx
	movq	-48(%rbp), %rax
	addq	%rdx, %rax
	cmpq	%rax, -24(%rbp)
	jb	.L60
.L59:
	movq	stderr(%rip), %rax
	movq	%rax, %rcx
	movl	$33, %edx
	movl	$1, %esi
	leaq	.LC17(%rip), %rax
	movq	%rax, %rdi
	call	fwrite@PLT
.L60:
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -24(%rbp)
	addq	$1, -16(%rbp)
.L58:
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	cmpq	%rax, -40(%rbp)
	je	.L61
	movq	-16(%rbp), %rax
	cmpq	-8(%rbp), %rax
	jb	.L62
.L61:
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	cmpq	%rax, -40(%rbp)
	je	.L64
	movq	stderr(%rip), %rax
	movq	%rax, %rcx
	movl	$38, %edx
	movl	$1, %esi
	leaq	.LC18(%rip), %rax
	movq	%rax, %rdi
	call	fwrite@PLT
.L64:
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE13:
	.size	check_mem, .-check_mem
	.section	.rodata
	.align 8
.LC0:
	.long	0
	.long	1072693248
	.align 8
.LC1:
	.long	0
	.long	1073741824
	.align 8
.LC9:
	.long	0
	.long	1093567616
	.align 8
.LC10:
	.long	0
	.long	1072168960
	.align 8
.LC11:
	.long	0
	.long	1071644672
	.align 8
.LC12:
	.long	0
	.long	1070596096
	.align 8
.LC13:
	.long	0
	.long	0
	.align 8
.LC15:
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
