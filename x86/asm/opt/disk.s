	.file	"disk.c"
	.text
	.globl	flushdisk
	.type	flushdisk, @function
flushdisk:
.LFB72:
	.cfi_startproc
	endbr64
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movl	$0, %edx
	movl	$4705, %esi
	movl	$0, %eax
	call	ioctl@PLT
	movl	%eax, %ebx
	movl	$100000, %edi
	call	usleep@PLT
	movl	%ebx, %eax
	popq	%rbx
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE72:
	.size	flushdisk, .-flushdisk
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"usage: disksize device"
	.text
	.globl	disksize
	.type	disksize, @function
disksize:
.LFB76:
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
	subq	$536, %rsp
	.cfi_def_cfa_offset 576
	movq	%fs:40, %rax
	movq	%rax, 520(%rsp)
	xorl	%eax, %eax
	movl	$0, %esi
	call	open@PLT
	movl	%eax, %ebx
	movl	$0, %ebp
	movq	%rsp, %r13
	cmpl	$-1, %eax
	je	.L17
.L4:
	movq	%rbp, %r12
	addq	$536870912, %rbp
	movl	$0, %edx
	movq	%rbp, %rsi
	movl	%ebx, %edi
	call	seekto@PLT
	cmpq	%rax, %rbp
	jne	.L6
	movl	$512, %edx
	movq	%r13, %rsi
	movl	%ebx, %edi
	call	read@PLT
	cmpq	$512, %rax
	je	.L4
.L6:
	movq	%rsp, %r13
.L8:
	movq	%r12, %rbp
	addq	$67108864, %r12
	movl	$0, %edx
	movq	%r12, %rsi
	movl	%ebx, %edi
	call	seekto@PLT
	cmpq	%rax, %r12
	jne	.L7
	movl	$512, %edx
	movq	%r13, %rsi
	movl	%ebx, %edi
	call	read@PLT
	cmpq	$512, %rax
	je	.L8
.L7:
	movq	%rsp, %r13
.L9:
	movq	%rbp, %r12
	addq	$1048576, %rbp
	movl	$0, %edx
	movq	%rbp, %rsi
	movl	%ebx, %edi
	call	seekto@PLT
	cmpq	%rax, %rbp
	jne	.L3
	movl	$512, %edx
	movq	%r13, %rsi
	movl	%ebx, %edi
	call	read@PLT
	cmpq	$512, %rax
	je	.L9
.L3:
	movq	520(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L18
	movq	%r12, %rax
	addq	$536, %rsp
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
.L17:
	.cfi_restore_state
	leaq	.LC0(%rip), %rdi
	call	perror@PLT
	movl	$0, %r12d
	jmp	.L3
.L18:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE76:
	.size	disksize, .-disksize
	.section	.rodata.str1.1
.LC1:
	.string	"valloc"
.LC3:
	.string	"%.01f %.2f\n"
	.text
	.globl	zone
	.type	zone, @function
zone:
.LFB74:
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
	subq	$40, %rsp
	.cfi_def_cfa_offset 96
	movq	%rdi, %rbp
	movl	%esi, 28(%rsp)
	movl	%edx, %ebx
	call	__open_2@PLT
	cmpl	$-1, %eax
	je	.L39
	movl	%eax, %r13d
	movslq	%ebx, %r12
	movq	%r12, %rdi
	call	valloc@PLT
	movq	%rax, %r14
	testq	%rax, %rax
	je	.L40
	movq	%r12, %rdx
	movl	$0, %esi
	movq	%rax, %rdi
	call	memset@PLT
	movl	%r13d, %edi
	call	flushdisk
	movq	%rbp, %rdi
	call	disksize
	movabsq	$7870610804782742023, %rcx
	mulq	%rcx
	shrq	$6, %rdx
	movl	$512, %eax
	cmpl	%eax, %edx
	cmovge	%edx, %eax
	movl	%eax, %r12d
	addl	$511, %r12d
	andl	$-512, %r12d
	cmpl	%r12d, %ebx
	movl	$262144, %eax
	cmovg	%eax, %ebx
	cmpl	$0, 28(%rsp)
	jne	.L23
	movl	$512, %edx
	movq	%r14, %rsi
	movl	%r13d, %edi
	call	read@PLT
	cmpq	$512, %rax
	jne	.L24
.L25:
	movslq	%ebx, %rbp
	cmpl	%r12d, %ebx
	cmovge	%ebx, %r12d
	movslq	%r12d, %r12
	leaq	1024(%rbp,%r12), %rax
	movq	%rax, 16(%rsp)
	movq	$1536, 8(%rsp)
	movl	$512, %r12d
	movq	%rbp, %r15
	jmp	.L33
.L39:
	movq	%rbp, %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L40:
	leaq	.LC1(%rip), %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L23:
	movl	$512, %edx
	movq	%r14, %rsi
	movl	%r13d, %edi
	call	write@PLT
	cmpq	$512, %rax
	je	.L25
.L24:
	movq	%rbp, %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L26:
	movl	$1024, %edx
	movq	%r14, %rsi
	movl	%r13d, %edi
	call	write@PLT
	cmpq	$1024, %rax
	jne	.L27
	movl	$0, %edi
	call	start@PLT
	movq	%rbp, %rdx
	movq	%r14, %rsi
	movl	%r13d, %edi
	call	write@PLT
	jmp	.L34
.L27:
	movl	$0, %edi
	call	exit@PLT
.L31:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L32:
	divsd	.LC2(%rip), %xmm0
	leaq	.LC3(%rip), %rdx
	movl	$1, %esi
	movq	stderr(%rip), %rdi
	movl	$2, %eax
	call	__fprintf_chk@PLT
	addq	16(%rsp), %r12
	movl	$0, %edx
	movq	%r12, %rsi
	movl	%r13d, %edi
	call	seekto@PLT
	movq	16(%rsp), %rsi
	addq	%rsi, 8(%rsp)
	cmpq	%rax, %r12
	jne	.L35
.L33:
	cmpl	$0, 28(%rsp)
	jne	.L26
	movl	$1024, %edx
	movq	%r14, %rsi
	movl	%r13d, %edi
	call	read@PLT
	cmpq	$1024, %rax
	jne	.L27
	movl	$0, %edi
	call	start@PLT
	movq	%rbp, %rdx
	movq	%r14, %rsi
	movl	%r13d, %edi
	call	read@PLT
.L34:
	cmpq	%rax, %r15
	jne	.L35
	movl	$0, %esi
	movl	$0, %edi
	call	stop@PLT
	pxor	%xmm1, %xmm1
	cvtsi2sdl	%ebx, %xmm1
	pxor	%xmm0, %xmm0
	cvtsi2sdl	%eax, %xmm0
	divsd	%xmm0, %xmm1
	movq	8(%rsp), %rax
	addq	%rbp, %rax
	js	.L31
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L32
.L35:
	movl	$0, %eax
	addq	$40, %rsp
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
.LFE74:
	.size	zone, .-zone
	.section	.rodata.str1.1
.LC4:
	.string	"io"
.LC6:
	.string	"%.01f %.02f\n"
	.text
	.globl	seek
	.type	seek, @function
seek:
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
	subq	$40, %rsp
	.cfi_def_cfa_offset 96
	movq	%rdi, %rbp
	movl	%esi, %r15d
	call	__open_2@PLT
	movl	%eax, %ebx
	cmpl	$-1, %eax
	je	.L60
	movl	%eax, %edi
	call	flushdisk
	movq	%rbp, %rdi
	call	disksize
	movq	%rax, %rbp
	movl	$512, %edi
	call	valloc@PLT
	movq	%rax, %r14
	testq	%rax, %rax
	je	.L61
	movq	$0, (%rax)
	movq	$0, 504(%rax)
	leaq	8(%rax), %rdi
	andq	$-8, %rdi
	movq	%rax, %rcx
	subq	%rdi, %rcx
	addl	$512, %ecx
	shrl	$3, %ecx
	movl	%ecx, %ecx
	movl	$0, %eax
	rep stosq
	movabsq	$2361183241434822607, %rdx
	movq	%rbp, %rax
	imulq	%rdx
	sarq	$8, %rdx
	movq	%rbp, %rax
	sarq	$63, %rax
	subq	%rax, %rdx
	movl	$512, %eax
	cmpl	%eax, %edx
	cmovge	%edx, %eax
	movl	%eax, %r12d
	addl	$511, %r12d
	andl	$-512, %r12d
	movl	$0, %edx
	movl	$0, %esi
	movl	%ebx, %edi
	call	seekto@PLT
	testl	%r15d, %r15d
	jne	.L45
	movl	$512, %edx
	movq	%r14, %rsi
	movl	%ebx, %edi
	call	read@PLT
.L46:
	cmpl	$-1, %eax
	je	.L47
	leal	(%r12,%r12), %eax
	movl	%eax, 20(%rsp)
	cltq
	cmpq	%rax, %rbp
	jl	.L62
	movslq	%r12d, %rcx
	movq	%rcx, 8(%rsp)
	movq	%rcx, %rax
	negq	%rax
	subq	%rcx, %rax
	movq	%rax, 24(%rsp)
	movq	%rbp, %r13
	subq	%rcx, %r13
	subq	%rcx, %r13
	movl	$0, %r12d
	jmp	.L57
.L60:
	movq	%rbp, %rdi
	call	perror@PLT
	jmp	.L41
.L61:
	leaq	.LC1(%rip), %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L45:
	movl	$512, %edx
	movq	%r14, %rsi
	movl	%ebx, %edi
	call	write@PLT
	jmp	.L46
.L62:
	movl	$0, %ebx
	jmp	.L41
.L47:
	leaq	.LC4(%rip), %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L49:
	movl	$512, %edx
	movq	%r14, %rsi
	movl	%ebx, %edi
	call	write@PLT
	jmp	.L50
.L64:
	leaq	.LC4(%rip), %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L65:
	pxor	%xmm1, %xmm1
	cvtsi2sdl	%eax, %xmm1
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%r13, %xmm0
	divsd	.LC2(%rip), %xmm0
	divsd	.LC5(%rip), %xmm1
	leaq	.LC6(%rip), %rdx
	movl	$1, %esi
	movq	stderr(%rip), %rdi
	movl	$2, %eax
	call	__fprintf_chk@PLT
	jmp	.L52
.L53:
	movl	$512, %edx
	movq	%r14, %rsi
	movl	%ebx, %edi
	call	write@PLT
	jmp	.L54
.L66:
	leaq	.LC4(%rip), %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L56:
	addq	24(%rsp), %r13
	movslq	20(%rsp), %rax
	addq	%r12, %rax
	cmpq	%rbp, %rax
	jg	.L63
.L57:
	subq	8(%rsp), %rbp
	movl	$0, %edi
	call	start@PLT
	movl	$0, %edx
	movq	%rbp, %rsi
	movl	%ebx, %edi
	call	seekto@PLT
	testl	%r15d, %r15d
	jne	.L49
	movl	$512, %edx
	movq	%r14, %rsi
	movl	%ebx, %edi
	call	read@PLT
.L50:
	cmpl	$-1, %eax
	je	.L64
	movl	$0, %esi
	movl	$0, %edi
	call	stop@PLT
	leal	-1001(%rax), %edx
	cmpl	$998998, %edx
	jbe	.L65
.L52:
	addq	8(%rsp), %r12
	movl	$0, %edi
	call	start@PLT
	movl	$0, %edx
	movq	%r12, %rsi
	movl	%ebx, %edi
	call	seekto@PLT
	testl	%r15d, %r15d
	jne	.L53
	movl	$512, %edx
	movq	%r14, %rsi
	movl	%ebx, %edi
	call	read@PLT
.L54:
	cmpl	$-1, %eax
	je	.L66
	movl	$0, %esi
	movl	$0, %edi
	call	stop@PLT
	leal	-1001(%rax), %edx
	cmpl	$998998, %edx
	ja	.L56
	pxor	%xmm1, %xmm1
	cvtsi2sdl	%eax, %xmm1
	movq	8(%rsp), %rax
	addq	%r13, %rax
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	divsd	.LC2(%rip), %xmm0
	divsd	.LC5(%rip), %xmm1
	leaq	.LC6(%rip), %rdx
	movl	$1, %esi
	movq	stderr(%rip), %rdi
	movl	$2, %eax
	call	__fprintf_chk@PLT
	jmp	.L56
.L63:
	movl	$0, %ebx
.L41:
	movl	%ebx, %eax
	addq	$40, %rsp
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
.LFE75:
	.size	seek, .-seek
	.section	.rodata.str1.1
.LC7:
	.string	"\"Seek times for %s\n"
.LC8:
	.string	"\"Zone bandwidth for %s\n"
	.text
	.globl	main
	.type	main, @function
main:
.LFB73:
	.cfi_startproc
	endbr64
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movq	%rsi, %rbx
	movq	8(%rsi), %rcx
	leaq	.LC7(%rip), %rdx
	movl	$1, %esi
	movq	stderr(%rip), %rdi
	movl	$0, %eax
	call	__fprintf_chk@PLT
	movq	8(%rbx), %rdi
	movl	$0, %esi
	call	seek
	movq	stderr(%rip), %rsi
	movl	$10, %edi
	call	fputc@PLT
	movq	8(%rbx), %rcx
	leaq	.LC8(%rip), %rdx
	movl	$1, %esi
	movq	stderr(%rip), %rdi
	movl	$0, %eax
	call	__fprintf_chk@PLT
	movq	8(%rbx), %rdi
	movl	$1048576, %edx
	movl	$0, %esi
	call	zone
	movl	$0, %eax
	popq	%rbx
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE73:
	.size	main, .-main
	.section	.rodata.cst8,"aM",@progbits,8
	.align 8
.LC2:
	.long	0
	.long	1093567616
	.align 8
.LC5:
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
