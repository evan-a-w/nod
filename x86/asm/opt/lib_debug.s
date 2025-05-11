	.file	"lib_debug.c"
	.text
	.globl	percent_point
	.type	percent_point, @function
percent_point:
.LFB72:
	.cfi_startproc
	endbr64
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movq	%xmm0, %rbx
	movl	$0, %eax
	call	get_results@PLT
	movl	(%rax), %esi
	leal	-1(%rsi), %edx
	pxor	%xmm0, %xmm0
	cvtsi2sdl	%edx, %xmm0
	movsd	.LC0(%rip), %xmm1
	movq	%rbx, %xmm5
	subsd	%xmm5, %xmm1
	mulsd	%xmm1, %xmm0
	movapd	%xmm0, %xmm3
	movsd	.LC2(%rip), %xmm2
	movapd	%xmm0, %xmm1
	andpd	%xmm2, %xmm1
	movsd	.LC1(%rip), %xmm4
	ucomisd	%xmm1, %xmm4
	jbe	.L2
	cvttsd2siq	%xmm0, %rdx
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rdx, %xmm1
	movapd	%xmm1, %xmm3
	cmpnlesd	%xmm0, %xmm3
	movsd	.LC0(%rip), %xmm4
	andpd	%xmm4, %xmm3
	subsd	%xmm3, %xmm1
	andnpd	%xmm0, %xmm2
	movapd	%xmm1, %xmm3
	orpd	%xmm2, %xmm3
.L2:
	ucomisd	%xmm0, %xmm3
	jp	.L3
	jne	.L3
	cvttsd2sil	%xmm0, %edx
	movslq	%edx, %rdx
	salq	$4, %rdx
	addq	%rdx, %rax
	movq	8(%rax), %rdx
	testq	%rdx, %rdx
	js	.L5
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
.L6:
	movq	16(%rax), %rax
	testq	%rax, %rax
	js	.L7
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rax, %xmm1
.L8:
	divsd	%xmm1, %xmm0
.L1:
	popq	%rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	ret
.L5:
	.cfi_restore_state
	movq	%rdx, %rcx
	shrq	%rcx
	andl	$1, %edx
	orq	%rdx, %rcx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rcx, %xmm0
	addsd	%xmm0, %xmm0
	jmp	.L6
.L7:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rdx, %xmm1
	addsd	%xmm1, %xmm1
	jmp	.L8
.L3:
	cvttsd2sil	%xmm0, %edx
	movslq	%edx, %rdx
	salq	$4, %rdx
	addq	%rdx, %rax
	movq	8(%rax), %rdx
	testq	%rdx, %rdx
	js	.L10
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rdx, %xmm1
.L11:
	movq	16(%rax), %rdx
	testq	%rdx, %rdx
	js	.L12
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
.L13:
	divsd	%xmm0, %xmm1
	movq	24(%rax), %rdx
	testq	%rdx, %rdx
	js	.L14
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
.L15:
	movq	32(%rax), %rax
	testq	%rax, %rax
	js	.L16
	pxor	%xmm2, %xmm2
	cvtsi2sdq	%rax, %xmm2
.L17:
	divsd	%xmm2, %xmm0
	addsd	%xmm1, %xmm0
	mulsd	.LC3(%rip), %xmm0
	jmp	.L1
.L10:
	movq	%rdx, %rcx
	shrq	%rcx
	andl	$1, %edx
	orq	%rdx, %rcx
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rcx, %xmm1
	addsd	%xmm1, %xmm1
	jmp	.L11
.L12:
	movq	%rdx, %rcx
	shrq	%rcx
	andl	$1, %edx
	orq	%rdx, %rcx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rcx, %xmm0
	addsd	%xmm0, %xmm0
	jmp	.L13
.L14:
	movq	%rdx, %rcx
	shrq	%rcx
	andl	$1, %edx
	orq	%rdx, %rcx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rcx, %xmm0
	addsd	%xmm0, %xmm0
	jmp	.L15
.L16:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm2, %xmm2
	cvtsi2sdq	%rdx, %xmm2
	addsd	%xmm2, %xmm2
	jmp	.L17
	.cfi_endproc
.LFE72:
	.size	percent_point, .-percent_point
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC4:
	.string	"N=%d, t={"
.LC5:
	.string	"%.2f"
.LC6:
	.string	", "
.LC7:
	.string	"}\n"
.LC8:
	.string	"\t/* %d {"
.LC9:
	.string	"%llu/%llu"
.LC10:
	.string	"} */\n"
	.text
	.globl	print_results
	.type	print_results, @function
print_results:
.LFB73:
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
	movl	%edi, %r13d
	movl	$0, %eax
	call	get_results@PLT
	movq	%rax, %rbx
	movl	(%rax), %ecx
	leaq	.LC4(%rip), %rdx
	movl	$1, %esi
	movq	stderr(%rip), %rdi
	movl	$0, %eax
	call	__fprintf_chk@PLT
	cmpl	$0, (%rbx)
	jle	.L21
	movl	$0, %ebp
	leaq	.LC5(%rip), %r12
	leaq	.LC6(%rip), %r14
	jmp	.L27
.L22:
	movq	%rax, %rcx
	shrq	%rcx
	andl	$1, %eax
	orq	%rax, %rcx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rcx, %xmm0
	addsd	%xmm0, %xmm0
	jmp	.L23
.L24:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rdx, %xmm1
	addsd	%xmm1, %xmm1
.L25:
	divsd	%xmm1, %xmm0
	movq	%r12, %rdx
	movl	$1, %esi
	movq	stderr(%rip), %rdi
	movl	$1, %eax
	call	__fprintf_chk@PLT
	movl	(%rbx), %eax
	subl	$1, %eax
	cmpl	%ebp, %eax
	jg	.L35
.L26:
	addq	$1, %rbp
	cmpl	%ebp, (%rbx)
	jle	.L21
.L27:
	movq	%rbp, %rdx
	salq	$4, %rdx
	movq	8(%rbx,%rdx), %rax
	testq	%rax, %rax
	js	.L22
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
.L23:
	movq	16(%rbx,%rdx), %rax
	testq	%rax, %rax
	js	.L24
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rax, %xmm1
	jmp	.L25
.L35:
	movq	stderr(%rip), %rcx
	movl	$2, %edx
	movl	$1, %esi
	movq	%r14, %rdi
	call	fwrite@PLT
	jmp	.L26
.L21:
	movq	stderr(%rip), %rcx
	movl	$2, %edx
	movl	$1, %esi
	leaq	.LC7(%rip), %rdi
	call	fwrite@PLT
	testl	%r13d, %r13d
	jne	.L36
.L20:
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
.L36:
	.cfi_restore_state
	movl	(%rbx), %ecx
	leaq	.LC8(%rip), %rdx
	movl	$1, %esi
	movq	stderr(%rip), %rdi
	movl	$0, %eax
	call	__fprintf_chk@PLT
	cmpl	$0, (%rbx)
	jle	.L29
	movl	$0, %ebp
	leaq	.LC9(%rip), %r12
	leaq	.LC6(%rip), %r13
	jmp	.L31
.L30:
	addq	$1, %rbp
	cmpl	%ebp, (%rbx)
	jle	.L29
.L31:
	movq	%rbp, %rax
	salq	$4, %rax
	movq	8(%rbx,%rax), %rcx
	movq	16(%rbx,%rax), %r8
	movq	%r12, %rdx
	movl	$1, %esi
	movq	stderr(%rip), %rdi
	movl	$0, %eax
	call	__fprintf_chk@PLT
	movl	(%rbx), %eax
	subl	$1, %eax
	cmpl	%ebp, %eax
	jle	.L30
	movq	stderr(%rip), %rcx
	movl	$2, %edx
	movl	$1, %esi
	movq	%r13, %rdi
	call	fwrite@PLT
	jmp	.L30
.L29:
	movq	stderr(%rip), %rcx
	movl	$5, %edx
	movl	$1, %esi
	leaq	.LC10(%rip), %rdi
	call	fwrite@PLT
	jmp	.L20
	.cfi_endproc
.LFE73:
	.size	print_results, .-print_results
	.section	.rodata.str1.1
.LC15:
	.string	"%lu\t%e\t%e\t%e\t%e\t%e\n"
	.text
	.globl	bw_quartile
	.type	bw_quartile, @function
bw_quartile:
.LFB74:
	.cfi_startproc
	endbr64
	subq	$56, %rsp
	.cfi_def_cfa_offset 64
	testq	%rdi, %rdi
	js	.L38
	pxor	%xmm2, %xmm2
	cvtsi2sdq	%rdi, %xmm2
	movsd	%xmm2, 8(%rsp)
.L39:
	movsd	.LC0(%rip), %xmm0
	call	percent_point
	mulsd	.LC11(%rip), %xmm0
	movsd	8(%rsp), %xmm5
	divsd	%xmm0, %xmm5
	movsd	%xmm5, 16(%rsp)
	movsd	.LC12(%rip), %xmm0
	call	percent_point
	mulsd	.LC11(%rip), %xmm0
	movsd	8(%rsp), %xmm6
	divsd	%xmm0, %xmm6
	movsd	%xmm6, 24(%rsp)
	movsd	.LC3(%rip), %xmm0
	call	percent_point
	mulsd	.LC11(%rip), %xmm0
	movsd	8(%rsp), %xmm7
	divsd	%xmm0, %xmm7
	movsd	%xmm7, 32(%rsp)
	movsd	.LC13(%rip), %xmm0
	call	percent_point
	mulsd	.LC11(%rip), %xmm0
	movsd	8(%rsp), %xmm1
	divsd	%xmm0, %xmm1
	movsd	%xmm1, 40(%rsp)
	pxor	%xmm0, %xmm0
	call	percent_point
	mulsd	.LC11(%rip), %xmm0
	movsd	8(%rsp), %xmm8
	divsd	%xmm0, %xmm8
	movsd	%xmm8, 8(%rsp)
	call	get_n@PLT
	movq	%rax, %rcx
	movsd	16(%rsp), %xmm4
	movsd	24(%rsp), %xmm3
	movsd	32(%rsp), %xmm2
	movsd	40(%rsp), %xmm1
	movsd	8(%rsp), %xmm0
	leaq	.LC15(%rip), %rdx
	movl	$1, %esi
	movq	stderr(%rip), %rdi
	movl	$5, %eax
	call	__fprintf_chk@PLT
	addq	$56, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	ret
.L38:
	.cfi_restore_state
	movq	%rdi, %rax
	shrq	%rax
	andl	$1, %edi
	orq	%rdi, %rax
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	addsd	%xmm0, %xmm0
	movsd	%xmm0, 8(%rsp)
	jmp	.L39
	.cfi_endproc
.LFE74:
	.size	bw_quartile, .-bw_quartile
	.globl	nano_quartile
	.type	nano_quartile, @function
nano_quartile:
.LFB75:
	.cfi_startproc
	endbr64
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	subq	$48, %rsp
	.cfi_def_cfa_offset 64
	movq	%rdi, %rbx
	movsd	.LC0(%rip), %xmm0
	call	percent_point
	testq	%rbx, %rbx
	js	.L42
	pxor	%xmm2, %xmm2
	cvtsi2sdq	%rbx, %xmm2
	movsd	%xmm2, 8(%rsp)
.L43:
	mulsd	.LC16(%rip), %xmm0
	divsd	8(%rsp), %xmm0
	movsd	%xmm0, 16(%rsp)
	movsd	.LC12(%rip), %xmm0
	call	percent_point
	mulsd	.LC16(%rip), %xmm0
	movapd	%xmm0, %xmm6
	divsd	8(%rsp), %xmm6
	movsd	%xmm6, 24(%rsp)
	movsd	.LC3(%rip), %xmm0
	call	percent_point
	mulsd	.LC16(%rip), %xmm0
	movapd	%xmm0, %xmm7
	divsd	8(%rsp), %xmm7
	movsd	%xmm7, 32(%rsp)
	movsd	.LC13(%rip), %xmm0
	call	percent_point
	mulsd	.LC16(%rip), %xmm0
	movapd	%xmm0, %xmm1
	divsd	8(%rsp), %xmm1
	movsd	%xmm1, 40(%rsp)
	pxor	%xmm0, %xmm0
	call	percent_point
	mulsd	.LC16(%rip), %xmm0
	divsd	8(%rsp), %xmm0
	movq	%xmm0, %rbx
	call	get_n@PLT
	movq	%rax, %rcx
	movsd	16(%rsp), %xmm4
	movsd	24(%rsp), %xmm3
	movsd	32(%rsp), %xmm2
	movsd	40(%rsp), %xmm1
	movq	%rbx, %xmm0
	leaq	.LC15(%rip), %rdx
	movl	$1, %esi
	movq	stderr(%rip), %rdi
	movl	$5, %eax
	call	__fprintf_chk@PLT
	addq	$48, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 16
	popq	%rbx
	.cfi_def_cfa_offset 8
	ret
.L42:
	.cfi_restore_state
	movq	%rbx, %rax
	shrq	%rax
	andl	$1, %ebx
	orq	%rbx, %rax
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rax, %xmm1
	addsd	%xmm1, %xmm1
	movsd	%xmm1, 8(%rsp)
	jmp	.L43
	.cfi_endproc
.LFE75:
	.size	nano_quartile, .-nano_quartile
	.section	.rodata.str1.1
.LC17:
	.string	"\t%lu\t%lu\t%lu\n"
	.text
	.globl	print_mem
	.type	print_mem, @function
print_mem:
.LFB76:
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
	movq	%rdi, %r12
	movq	%rdx, %rbx
	call	getpagesize@PLT
	cmpq	(%r12), %r12
	je	.L45
	movslq	%eax, %r13
	movq	%r12, %rbp
	leaq	.LC17(%rip), %r14
.L47:
	movq	%rbp, %rcx
	subq	%r12, %rcx
	movq	%rcx, %rax
	movl	$0, %edx
	divq	%rbx
	movq	%rdx, %r9
	movq	%rcx, %rax
	movl	$0, %edx
	divq	%r13
	movq	%rax, %rcx
	movq	%rdx, %rax
	movl	$0, %edx
	divq	%rbx
	movq	%rax, %r8
	shrq	$3, %r9
	movq	%r14, %rdx
	movl	$1, %esi
	movq	stderr(%rip), %rdi
	movl	$0, %eax
	call	__fprintf_chk@PLT
	movq	0(%rbp), %rbp
	cmpq	%r12, 0(%rbp)
	jne	.L47
.L45:
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
.LFE76:
	.size	print_mem, .-print_mem
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC18:
	.string	"check_mem: pointer out of range!\n"
	.align 8
.LC19:
	.string	"check_mem: pointer chain doesn't loop\n"
	.text
	.globl	check_mem
	.type	check_mem, @function
check_mem:
.LFB77:
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
	subq	$8, %rsp
	.cfi_def_cfa_offset 64
	movq	%rsi, %r13
	shrq	$3, %r13
	addq	$1, %r13
	cmpq	(%rdi), %rdi
	je	.L50
	movq	%rdi, %rbp
	movq	%rsi, %r14
	movq	%rdi, %rbx
	movl	$0, %r12d
	leaq	.LC18(%rip), %r15
	jmp	.L54
.L52:
	movq	stderr(%rip), %rcx
	movl	$33, %edx
	movl	$1, %esi
	movq	%r15, %rdi
	call	fwrite@PLT
.L53:
	movq	(%rbx), %rbx
	addq	$1, %r12
	movq	(%rbx), %rax
	cmpq	%r12, %r13
	jbe	.L56
	cmpq	%rbp, %rax
	je	.L56
.L54:
	cmpq	%rbx, %rbp
	ja	.L52
	leaq	0(%rbp,%r14), %rax
	cmpq	%rax, %rbx
	jb	.L53
	jmp	.L52
.L56:
	cmpq	%rbp, %rax
	je	.L50
	movq	stderr(%rip), %rcx
	movl	$38, %edx
	movl	$1, %esi
	leaq	.LC19(%rip), %rdi
	call	fwrite@PLT
.L50:
	addq	$8, %rsp
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
.LFE77:
	.size	check_mem, .-check_mem
	.section	.rodata.cst8,"aM",@progbits,8
	.align 8
.LC0:
	.long	0
	.long	1072693248
	.align 8
.LC1:
	.long	0
	.long	1127219200
	.section	.rodata.cst16,"aM",@progbits,16
	.align 16
.LC2:
	.long	-1
	.long	2147483647
	.long	0
	.long	0
	.section	.rodata.cst8
	.align 8
.LC3:
	.long	0
	.long	1071644672
	.align 8
.LC11:
	.long	0
	.long	1093567616
	.align 8
.LC12:
	.long	0
	.long	1072168960
	.align 8
.LC13:
	.long	0
	.long	1070596096
	.align 8
.LC16:
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
