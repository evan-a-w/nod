	.file	"lat_fs.c"
	.text
	.globl	cleanup_names
	.type	cleanup_names, @function
cleanup_names:
.LFB77:
	.cfi_startproc
	endbr64
	testq	%rdi, %rdi
	je	.L12
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushq	%rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	subq	$8, %rsp
	.cfi_def_cfa_offset 32
	movq	%rsi, %rbx
	cmpq	$0, 16(%rsi)
	jle	.L3
	movl	$0, %ebp
	jmp	.L5
.L4:
	addq	$1, %rbp
	cmpq	%rbp, 16(%rbx)
	jle	.L3
.L5:
	movq	24(%rbx), %rax
	movq	(%rax,%rbp,8), %rdi
	testq	%rdi, %rdi
	je	.L4
	call	free@PLT
	jmp	.L4
.L3:
	movq	24(%rbx), %rdi
	call	free@PLT
	movq	$0, 16(%rbx)
	movq	32(%rbx), %rbp
	subq	$1, %rbp
	jns	.L8
.L6:
	movq	40(%rbx), %rdi
	call	free@PLT
	movq	$0, 32(%rbx)
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
.L7:
	.cfi_restore_state
	subq	$1, %rbp
	cmpq	$-1, %rbp
	je	.L6
.L8:
	movq	40(%rbx), %rax
	movq	(%rax,%rbp,8), %rdi
	testq	%rdi, %rdi
	je	.L7
	call	rmdir@PLT
	movq	40(%rbx), %rax
	movq	(%rax,%rbp,8), %rdi
	call	free@PLT
	jmp	.L7
.L12:
	.cfi_def_cfa_offset 8
	.cfi_restore 3
	.cfi_restore 6
	ret
	.cfi_endproc
.LFE77:
	.size	cleanup_names, .-cleanup_names
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC0:
	.string	"benchmark_rm: null filename at %lu of %lu\n"
	.text
	.globl	benchmark_rm
	.type	benchmark_rm, @function
benchmark_rm:
.LFB81:
	.cfi_startproc
	endbr64
	testq	%rdi, %rdi
	je	.L22
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
	leaq	-1(%rdi), %rbx
	leaq	.LC0(%rip), %r12
	jmp	.L19
.L26:
	movq	16(%rbp), %r8
	movq	%rbx, %rcx
	movq	%r12, %rdx
	movl	$1, %esi
	movq	stderr(%rip), %rdi
	movl	$0, %eax
	call	__fprintf_chk@PLT
.L18:
	subq	$1, %rbx
	cmpq	$-1, %rbx
	je	.L25
.L19:
	movq	24(%rbp), %rax
	movq	(%rax,%rbx,8), %rdi
	testq	%rdi, %rdi
	je	.L26
	call	unlink@PLT
	jmp	.L18
.L25:
	popq	%rbx
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	ret
.L22:
	.cfi_restore 3
	.cfi_restore 6
	.cfi_restore 12
	ret
	.cfi_endproc
.LFE81:
	.size	benchmark_rm, .-benchmark_rm
	.globl	cleanup_mk
	.type	cleanup_mk, @function
cleanup_mk:
.LFB79:
	.cfi_startproc
	endbr64
	testq	%rdi, %rdi
	jne	.L33
	ret
.L33:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushq	%rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	subq	$8, %rsp
	.cfi_def_cfa_offset 32
	movq	%rdi, %rbx
	movq	%rsi, %rbp
	call	benchmark_rm
	movq	%rbp, %rsi
	movq	%rbx, %rdi
	call	cleanup_names
	addq	$8, %rsp
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE79:
	.size	cleanup_mk, .-cleanup_mk
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC1:
	.string	"%luk"
.LC3:
	.string	"\t%lu\t%.0f"
.LC4:
	.string	"\t-1\t-1"
.LC5:
	.string	"\t%.0f"
.LC6:
	.string	"\t-1"
	.text
	.globl	measure
	.type	measure, @function
measure:
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
	subq	$16, %rsp
	.cfi_def_cfa_offset 64
	movl	%esi, %ebx
	movl	%edx, %ebp
	movl	%ecx, %r12d
	movq	%r8, %r13
	movq	%rdi, %rcx
	shrq	$10, %rcx
	leaq	.LC1(%rip), %rdx
	movl	$1, %esi
	movq	stderr(%rip), %rdi
	movl	$0, %eax
	call	__fprintf_chk@PLT
	pushq	%r13
	.cfi_def_cfa_offset 72
	pushq	%r12
	.cfi_def_cfa_offset 80
	movl	%ebp, %r9d
	movl	%ebx, %r8d
	movl	$0, %ecx
	leaq	cleanup_mk(%rip), %rdx
	leaq	benchmark_mk(%rip), %rsi
	leaq	setup_names(%rip), %rdi
	call	benchmp@PLT
	call	usecs_spent@PLT
	addq	$16, %rsp
	.cfi_def_cfa_offset 64
	testq	%rax, %rax
	je	.L35
	call	get_n@PLT
	movq	%rax, %r14
	call	usecs_spent@PLT
	testq	%r14, %r14
	js	.L36
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%r14, %xmm0
.L37:
	mulsd	.LC2(%rip), %xmm0
	testq	%rax, %rax
	js	.L38
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rax, %xmm1
.L39:
	divsd	%xmm1, %xmm0
	movsd	%xmm0, 8(%rsp)
	call	get_n@PLT
	movq	%rax, %rcx
	movsd	8(%rsp), %xmm0
	leaq	.LC3(%rip), %rdx
	movl	$1, %esi
	movq	stderr(%rip), %rdi
	movl	$1, %eax
	call	__fprintf_chk@PLT
.L40:
	pushq	%r13
	.cfi_def_cfa_offset 72
	pushq	%r12
	.cfi_def_cfa_offset 80
	movl	%ebp, %r9d
	movl	%ebx, %r8d
	movl	$0, %ecx
	leaq	cleanup_names(%rip), %rdx
	leaq	benchmark_rm(%rip), %rsi
	leaq	setup_rm(%rip), %rdi
	call	benchmp@PLT
	call	usecs_spent@PLT
	addq	$16, %rsp
	.cfi_def_cfa_offset 64
	testq	%rax, %rax
	je	.L41
	call	get_n@PLT
	movq	%rax, %rbx
	call	usecs_spent@PLT
	testq	%rbx, %rbx
	js	.L42
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rbx, %xmm0
.L43:
	mulsd	.LC2(%rip), %xmm0
	testq	%rax, %rax
	js	.L44
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rax, %xmm1
.L45:
	divsd	%xmm1, %xmm0
	leaq	.LC5(%rip), %rdx
	movl	$1, %esi
	movq	stderr(%rip), %rdi
	movl	$1, %eax
	call	__fprintf_chk@PLT
.L46:
	movq	stderr(%rip), %rsi
	movl	$10, %edi
	call	fputc@PLT
	addq	$16, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 48
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
.L36:
	.cfi_restore_state
	movq	%r14, %rdx
	shrq	%rdx
	andl	$1, %r14d
	orq	%r14, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
	jmp	.L37
.L38:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rdx, %xmm1
	addsd	%xmm1, %xmm1
	jmp	.L39
.L35:
	movq	stderr(%rip), %rcx
	movl	$6, %edx
	movl	$1, %esi
	leaq	.LC4(%rip), %rdi
	call	fwrite@PLT
	jmp	.L40
.L42:
	movq	%rbx, %rdx
	shrq	%rdx
	andl	$1, %ebx
	orq	%rbx, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
	jmp	.L43
.L44:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rdx, %xmm1
	addsd	%xmm1, %xmm1
	jmp	.L45
.L41:
	movq	stderr(%rip), %rcx
	movl	$3, %edx
	movl	$1, %esi
	leaq	.LC6(%rip), %rdi
	call	fwrite@PLT
	jmp	.L46
	.cfi_endproc
.LFE73:
	.size	measure, .-measure
	.section	.rodata.str1.8
	.align 8
.LC7:
	.string	"[-s <file size>] [-n <max files per dir>] [-P <parallelism>] [-W <warmup>] [-N <repetitions>] [<dir>]\n"
	.section	.rodata.str1.1
.LC8:
	.string	"s:n:P:W:N:"
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
	subq	$88, %rsp
	.cfi_def_cfa_offset 144
	movl	%edi, %ebx
	movq	%rsi, %rbp
	movq	%fs:40, %rax
	movq	%rax, 72(%rsp)
	xorl	%eax, %eax
	movq	$0, 64(%rsp)
	movq	$100, 24(%rsp)
	movq	$0, 16(%rsp)
	movl	$-1, %r15d
	movl	$0, %r14d
	movl	$1, 12(%rsp)
	leaq	.LC8(%rip), %r13
	leaq	.L52(%rip), %r12
	jmp	.L49
.L51:
	movq	myoptarg(%rip), %rdi
	call	bytes@PLT
	movq	%rax, 64(%rsp)
.L49:
	movq	%r13, %rdx
	movq	%rbp, %rsi
	movl	%ebx, %edi
	call	mygetopt@PLT
	cmpl	$-1, %eax
	je	.L68
	subl	$78, %eax
	cmpl	$37, %eax
	ja	.L50
	movl	%eax, %eax
	movslq	(%r12,%rax,4), %rax
	addq	%r12, %rax
	notrack jmp	*%rax
	.section	.rodata
	.align 4
	.align 4
.L52:
	.long	.L56-.L52
	.long	.L50-.L52
	.long	.L55-.L52
	.long	.L50-.L52
	.long	.L50-.L52
	.long	.L50-.L52
	.long	.L50-.L52
	.long	.L50-.L52
	.long	.L50-.L52
	.long	.L54-.L52
	.long	.L50-.L52
	.long	.L50-.L52
	.long	.L50-.L52
	.long	.L50-.L52
	.long	.L50-.L52
	.long	.L50-.L52
	.long	.L50-.L52
	.long	.L50-.L52
	.long	.L50-.L52
	.long	.L50-.L52
	.long	.L50-.L52
	.long	.L50-.L52
	.long	.L50-.L52
	.long	.L50-.L52
	.long	.L50-.L52
	.long	.L50-.L52
	.long	.L50-.L52
	.long	.L50-.L52
	.long	.L50-.L52
	.long	.L50-.L52
	.long	.L50-.L52
	.long	.L50-.L52
	.long	.L53-.L52
	.long	.L50-.L52
	.long	.L50-.L52
	.long	.L50-.L52
	.long	.L50-.L52
	.long	.L51-.L52
	.text
.L53:
	movq	myoptarg(%rip), %rdi
	call	bytes@PLT
	movq	%rax, 24(%rsp)
	jmp	.L49
.L55:
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	movl	%eax, 12(%rsp)
	testl	%eax, %eax
	jg	.L49
	leaq	.LC7(%rip), %rdx
	movq	%rbp, %rsi
	movl	%ebx, %edi
	call	lmbench_usage@PLT
	jmp	.L49
.L54:
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	movl	%eax, %r14d
	jmp	.L49
.L56:
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	movl	%eax, %r15d
	jmp	.L49
.L50:
	leaq	.LC7(%rip), %rdx
	movq	%rbp, %rsi
	movl	%ebx, %edi
	call	lmbench_usage@PLT
	jmp	.L49
.L68:
	leal	-1(%rbx), %r12d
	cmpl	myoptind(%rip), %r12d
	jg	.L69
.L59:
	cmpl	myoptind(%rip), %r12d
	je	.L70
.L60:
	movq	64(%rsp), %rdi
	leaq	sizes.0(%rip), %rbx
	leaq	16(%rbx), %r12
	leaq	16(%rsp), %rbp
	testq	%rdi, %rdi
	jne	.L71
.L63:
	movslq	(%rbx), %rdi
	movq	%rdi, 64(%rsp)
	movq	%rbp, %r8
	movl	%r15d, %ecx
	movl	%r14d, %edx
	movl	12(%rsp), %esi
	call	measure
	addq	$4, %rbx
	cmpq	%r12, %rbx
	jne	.L63
.L62:
	movq	72(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L72
	movl	$0, %eax
	addq	$88, %rsp
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
.L69:
	.cfi_restore_state
	leaq	.LC7(%rip), %rdx
	movq	%rbp, %rsi
	movl	%ebx, %edi
	call	lmbench_usage@PLT
	jmp	.L59
.L70:
	movq	8(%rbp), %rax
	movq	%rax, 16(%rsp)
	jmp	.L60
.L71:
	movq	%rbp, %r8
	movl	%r15d, %ecx
	movl	%r14d, %edx
	movl	12(%rsp), %esi
	call	measure
	jmp	.L62
.L72:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE72:
	.size	main, .-main
	.globl	mkfile
	.type	mkfile, @function
mkfile:
.LFB74:
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
	leaq	-131072(%rsp), %r11
	.cfi_def_cfa 11, 131112
.LPSRL0:
	subq	$4096, %rsp
	orq	$0, (%rsp)
	cmpq	%r11, %rsp
	jne	.LPSRL0
	.cfi_def_cfa_register 7
	subq	$24, %rsp
	.cfi_def_cfa_offset 131136
	movq	%rsi, %rbp
	movq	%fs:40, %rax
	movq	%rax, 131080(%rsp)
	xorl	%eax, %eax
	movl	$438, %esi
	call	creat@PLT
	movl	%eax, %r12d
	testq	%rbp, %rbp
	je	.L74
	movq	%rsp, %r13
.L75:
	movl	$131072, %ebx
	cmpq	%rbx, %rbp
	cmovbe	%rbp, %rbx
	movq	%rbx, %rdx
	movq	%r13, %rsi
	movl	%r12d, %edi
	call	write@PLT
	subq	%rbx, %rbp
	jne	.L75
.L74:
	movl	%r12d, %edi
	call	close@PLT
	movq	131080(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L79
	addq	$131096, %rsp
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
.L79:
	.cfi_restore_state
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE74:
	.size	mkfile, .-mkfile
	.section	.rodata.str1.8
	.align 8
.LC9:
	.string	"benchmark_mk: null filename at %lu of %lu\n"
	.text
	.globl	benchmark_mk
	.type	benchmark_mk, @function
benchmark_mk:
.LFB80:
	.cfi_startproc
	endbr64
	testq	%rdi, %rdi
	je	.L87
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
	leaq	-1(%rdi), %rbx
	leaq	.LC9(%rip), %r12
	jmp	.L84
.L91:
	movq	16(%rbp), %r8
	movq	%rbx, %rcx
	movq	%r12, %rdx
	movl	$1, %esi
	movq	stderr(%rip), %rdi
	movl	$0, %eax
	call	__fprintf_chk@PLT
.L83:
	subq	$1, %rbx
	cmpq	$-1, %rbx
	je	.L90
.L84:
	movq	24(%rbp), %rax
	movq	(%rax,%rbx,8), %rdi
	testq	%rdi, %rdi
	je	.L91
	movq	48(%rbp), %rsi
	call	mkfile
	jmp	.L83
.L90:
	popq	%rbx
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	ret
.L87:
	.cfi_restore 3
	.cfi_restore 6
	.cfi_restore 12
	ret
	.cfi_endproc
.LFE80:
	.size	benchmark_mk, .-benchmark_mk
	.section	.rodata.str1.1
.LC10:
	.string	"%s/%ld"
	.text
	.globl	setup_names_recurse
	.type	setup_names_recurse, @function
setup_names_recurse:
.LFB75:
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
	subq	$4096, %rsp
	.cfi_def_cfa_offset 4152
	orq	$0, (%rsp)
	subq	$4096, %rsp
	.cfi_def_cfa_offset 8248
	orq	$0, (%rsp)
	subq	$72, %rsp
	.cfi_def_cfa_offset 8320
	movq	%rdi, %rbp
	movq	%rsi, %r13
	movl	%edx, %esi
	movl	%edx, 20(%rsp)
	movq	%rcx, %rbx
	movq	%fs:40, %rax
	movq	%rax, 8248(%rsp)
	xorl	%eax, %eax
	movq	0(%r13), %rdx
	movq	40(%rcx), %rax
	movq	(%rax,%rdx,8), %rax
	movq	%rax, (%rsp)
	testl	%esi, %esi
	jle	.L112
	movq	8(%rcx), %rsi
	movl	20(%rsp), %eax
	movslq	%eax, %rdx
	cmpl	$1, %eax
	jle	.L104
	movq	%rsi, %rcx
	movl	$1, %eax
.L97:
	imulq	%rsi, %rcx
	addq	$1, %rax
	cmpq	%rdx, %rax
	jne	.L97
.L96:
	movq	16(%rbx), %rax
	subq	0(%rbp), %rax
	movl	$0, %edx
	divq	%rcx
	addq	$1, %rax
	movq	%rax, 24(%rsp)
	testq	%rax, %rax
	jle	.L92
	movl	$0, %r15d
	testq	%rsi, %rsi
	jle	.L92
	movq	%rbp, 8(%rsp)
.L98:
	movq	8(%rsp), %rax
	movq	16(%rbx), %rcx
	cmpq	%rcx, (%rax)
	jnb	.L92
	leaq	32(%rsp), %r12
	movq	%r15, %r9
	movq	(%rsp), %r8
	leaq	.LC10(%rip), %rcx
	movl	$8212, %edx
	movl	$1, %esi
	movq	%r12, %rdi
	movl	$0, %eax
	call	__sprintf_chk@PLT
	movq	40(%rbx), %r14
	movq	0(%r13), %rax
	leaq	1(%rax), %rbp
	movq	%rbp, 0(%r13)
	movq	%r12, %rdi
	call	strdup@PLT
	movq	%rax, (%r14,%rbp,8)
	movl	$511, %esi
	movq	%r12, %rdi
	call	mkdir@PLT
	movl	20(%rsp), %eax
	leal	-1(%rax), %edx
	movq	%rbx, %rcx
	movq	%r13, %rsi
	movq	8(%rsp), %rdi
	call	setup_names_recurse
	addq	$1, %r15
	movq	8(%rbx), %rax
	movq	24(%rsp), %rdi
	cmpq	%rax, %rdi
	cmovle	%rdi, %rax
	cmpq	%r15, %rax
	jg	.L98
.L92:
	movq	8248(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L113
	addq	$8264, %rsp
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
.L112:
	.cfi_restore_state
	movl	$0, %r12d
	cmpq	$0, 8(%rcx)
	jle	.L92
.L94:
	movq	16(%rbx), %rax
	cmpq	%rax, 0(%rbp)
	jnb	.L92
	leaq	32(%rsp), %r14
	movq	%r12, %r9
	movq	(%rsp), %r8
	leaq	.LC10(%rip), %rcx
	movl	$8212, %edx
	movl	$1, %esi
	movq	%r14, %rdi
	movl	$0, %eax
	call	__sprintf_chk@PLT
	movq	24(%rbx), %r15
	movq	0(%rbp), %r13
	leaq	1(%r13), %rax
	movq	%rax, 0(%rbp)
	movq	%r14, %rdi
	call	strdup@PLT
	movq	%rax, (%r15,%r13,8)
	addq	$1, %r12
	cmpq	%r12, 8(%rbx)
	jg	.L94
	jmp	.L92
.L104:
	movq	%rsi, %rcx
	jmp	.L96
.L113:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE75:
	.size	setup_names_recurse, .-setup_names_recurse
	.section	.rodata.str1.1
.LC11:
	.string	"malloc"
.LC12:
	.string	"lat_fs_%d_XXXXXX"
.LC13:
	.string	"tempnam failed"
.LC14:
	.string	"mkdir failed"
	.section	.rodata.str1.8
	.align 8
.LC15:
	.string	"setup_names: ERROR: foff=%lu, iterations=%lu, doff=%lu, ndirs=%lu, depth=%ld\n"
	.text
	.globl	setup_names
	.type	setup_names, @function
setup_names:
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
	subq	$304, %rsp
	.cfi_def_cfa_offset 352
	movq	%fs:40, %rax
	movq	%rax, 296(%rsp)
	xorl	%eax, %eax
	testq	%rdi, %rdi
	je	.L114
	movq	%rdi, %rbp
	movq	%rsi, %rbx
	movq	%rdi, 16(%rsi)
	movq	8(%rsi), %rcx
	movq	%rdi, %rax
	movl	$0, %edx
	divq	%rcx
	cmpq	$1, %rdx
	sbbq	$-1, %rax
	movq	%rax, 32(%rsi)
	cmpq	$1, %rax
	jle	.L129
	movq	%rax, %rsi
	movl	$0, %r12d
.L119:
	cqto
	idivq	%rcx
	cmpq	$1, %rdx
	sbbq	$-1, %rax
	addq	%rax, %rsi
	addq	$1, %r12
	cmpq	$1, %rax
	jg	.L119
	movq	%rsi, 32(%rbx)
.L118:
	leaq	0(,%rbp,8), %rdi
	call	malloc@PLT
	movq	%rax, %r13
	movq	%rax, 24(%rbx)
	movq	32(%rbx), %r14
	leaq	0(,%r14,8), %rdi
	call	malloc@PLT
	movq	%rax, 40(%rbx)
	testq	%r13, %r13
	je	.L120
	testq	%rax, %rax
	jne	.L130
	testq	%r14, %r14
	jne	.L120
.L130:
	movl	$0, %eax
.L121:
	movq	24(%rbx), %rdx
	movq	$0, (%rdx,%rax,8)
	addq	$1, %rax
	cmpq	%rax, %rbp
	jne	.L121
	cmpq	$0, 32(%rbx)
	jle	.L122
	movl	$0, %eax
.L123:
	movq	40(%rbx), %rdx
	movq	$0, (%rdx,%rax,8)
	addq	$1, %rax
	cmpq	%rax, 32(%rbx)
	jg	.L123
.L122:
	call	getpid@PLT
	movl	%eax, %r8d
	leaq	16(%rsp), %r13
	leaq	.LC12(%rip), %rcx
	movl	$276, %edx
	movl	$1, %esi
	movq	%r13, %rdi
	movl	$0, %eax
	call	__sprintf_chk@PLT
	movq	%r13, %rsi
	movq	(%rbx), %rdi
	call	tempnam@PLT
	movq	%rax, %r13
	testq	%rax, %rax
	je	.L135
	movl	$448, %esi
	movq	%rax, %rdi
	call	mkdir@PLT
	testl	%eax, %eax
	jne	.L136
	movq	40(%rbx), %rax
	movq	%r13, (%rax)
	movq	$0, (%rsp)
	movq	$0, 8(%rsp)
	leaq	8(%rsp), %rsi
	movq	%rsp, %rdi
	movq	%rbx, %rcx
	movl	%r12d, %edx
	call	setup_names_recurse
	movq	(%rsp), %rcx
	cmpq	%rbp, %rcx
	jne	.L126
	movq	32(%rbx), %rax
	subq	$1, %rax
	cmpq	8(%rsp), %rax
	je	.L114
.L126:
	pushq	%r12
	.cfi_def_cfa_offset 360
	pushq	32(%rbx)
	.cfi_def_cfa_offset 368
	movq	24(%rsp), %r9
	movq	%rbp, %r8
	leaq	.LC15(%rip), %rdx
	movl	$1, %esi
	movq	stderr(%rip), %rdi
	movl	$0, %eax
	call	__fprintf_chk@PLT
	addq	$16, %rsp
	.cfi_def_cfa_offset 352
.L114:
	movq	296(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L137
	addq	$304, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 48
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
.L129:
	.cfi_restore_state
	movl	$0, %r12d
	jmp	.L118
.L120:
	leaq	.LC11(%rip), %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L135:
	leaq	.LC13(%rip), %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L136:
	leaq	.LC14(%rip), %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L137:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE76:
	.size	setup_names, .-setup_names
	.globl	setup_rm
	.type	setup_rm, @function
setup_rm:
.LFB78:
	.cfi_startproc
	endbr64
	testq	%rdi, %rdi
	jne	.L144
	ret
.L144:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushq	%rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	subq	$8, %rsp
	.cfi_def_cfa_offset 32
	movq	%rdi, %rbx
	movq	%rsi, %rbp
	call	setup_names
	movq	%rbp, %rsi
	movq	%rbx, %rdi
	call	benchmark_mk
	addq	$8, %rsp
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE78:
	.size	setup_rm, .-setup_rm
	.section	.rodata
	.align 16
	.type	sizes.0, @object
	.size	sizes.0, 16
sizes.0:
	.long	0
	.long	1024
	.long	4096
	.long	10240
	.globl	id
	.section	.rodata.str1.1
.LC16:
	.string	"$Id$\n"
	.section	.data.rel.local,"aw"
	.align 8
	.type	id, @object
	.size	id, 8
id:
	.quad	.LC16
	.section	.rodata.cst8,"aM",@progbits,8
	.align 8
.LC2:
	.long	0
	.long	1093567616
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
