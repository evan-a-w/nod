	.file	"disk.c"
	.text
	.globl	flushdisk
	.type	flushdisk, @function
flushdisk:
.LFB8:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movl	%edi, -20(%rbp)
	movl	-20(%rbp), %eax
	movl	$0, %edx
	movl	$4705, %esi
	movl	%eax, %edi
	movl	$0, %eax
	call	ioctl@PLT
	movl	%eax, -4(%rbp)
	movl	$100000, %edi
	call	usleep@PLT
	movl	-4(%rbp), %eax
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE8:
	.size	flushdisk, .-flushdisk
	.section	.rodata
.LC0:
	.string	"\"Seek times for %s\n"
.LC1:
	.string	"\"Zone bandwidth for %s\n"
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
	subq	$16, %rsp
	movl	%edi, -4(%rbp)
	movq	%rsi, -16(%rbp)
	movq	-16(%rbp), %rax
	addq	$8, %rax
	movq	(%rax), %rdx
	movq	stderr(%rip), %rax
	leaq	.LC0(%rip), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf@PLT
	movq	-16(%rbp), %rax
	addq	$8, %rax
	movq	(%rax), %rax
	movl	$0, %esi
	movq	%rax, %rdi
	call	seek
	movq	stderr(%rip), %rax
	movq	%rax, %rsi
	movl	$10, %edi
	call	fputc@PLT
	movq	-16(%rbp), %rax
	addq	$8, %rax
	movq	(%rax), %rdx
	movq	stderr(%rip), %rax
	leaq	.LC1(%rip), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf@PLT
	movq	-16(%rbp), %rax
	addq	$8, %rax
	movq	(%rax), %rax
	movl	$1048576, %edx
	movl	$0, %esi
	movq	%rax, %rdi
	call	zone
	movl	$0, %eax
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE9:
	.size	main, .-main
	.section	.rodata
.LC2:
	.string	"valloc"
.LC4:
	.string	"%.01f %.2f\n"
	.text
	.globl	zone
	.type	zone, @function
zone:
.LFB10:
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
	movl	%edx, -48(%rbp)
	movl	-44(%rbp), %edx
	movq	-40(%rbp), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	open@PLT
	movl	%eax, -24(%rbp)
	cmpl	$-1, -24(%rbp)
	jne	.L6
	movq	-40(%rbp), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L6:
	movl	-48(%rbp), %eax
	cltq
	movq	%rax, %rdi
	call	valloc@PLT
	movq	%rax, -8(%rbp)
	cmpq	$0, -8(%rbp)
	jne	.L7
	leaq	.LC2(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L7:
	movl	-48(%rbp), %eax
	cltq
	movq	-8(%rbp), %rdx
	movq	%rdx, %rcx
	movq	%rax, %rdx
	movl	$0, %esi
	movq	%rcx, %rdi
	call	memset@PLT
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	flushdisk
	movq	-40(%rbp), %rax
	movq	%rax, %rdi
	call	disksize
	movq	%rax, -16(%rbp)
	movq	-16(%rbp), %rax
	movabsq	$7870610804782742023, %rdx
	mulq	%rdx
	movq	%rdx, %rax
	shrq	$6, %rax
	movq	%rax, -16(%rbp)
	movq	-16(%rbp), %rax
	movl	%eax, -28(%rbp)
	cmpl	$511, -28(%rbp)
	jg	.L8
	movl	$512, -28(%rbp)
.L8:
	addl	$511, -28(%rbp)
	sarl	$9, -28(%rbp)
	sall	$9, -28(%rbp)
	movl	-48(%rbp), %eax
	cmpl	-28(%rbp), %eax
	jle	.L9
	movl	$262144, -48(%rbp)
.L9:
	movl	-48(%rbp), %eax
	cmpl	-28(%rbp), %eax
	jle	.L10
	movl	-48(%rbp), %eax
	movl	%eax, -28(%rbp)
.L10:
	movq	-16(%rbp), %rax
	imulq	$150, %rax, %rax
	movq	%rax, -16(%rbp)
	cmpl	$0, -44(%rbp)
	jne	.L11
	movq	-8(%rbp), %rcx
	movl	-24(%rbp), %eax
	movl	$512, %edx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	read@PLT
	cmpq	$512, %rax
	setne	%al
	jmp	.L12
.L11:
	movq	-8(%rbp), %rcx
	movl	-24(%rbp), %eax
	movl	$512, %edx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	write@PLT
	cmpq	$512, %rax
	setne	%al
.L12:
	testb	%al, %al
	je	.L13
	movq	-40(%rbp), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L13:
	movq	$512, -16(%rbp)
.L24:
	cmpl	$0, -44(%rbp)
	jne	.L14
	movq	-8(%rbp), %rcx
	movl	-24(%rbp), %eax
	movl	$1024, %edx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	read@PLT
	cmpq	$1024, %rax
	setne	%al
	jmp	.L15
.L14:
	movq	-8(%rbp), %rcx
	movl	-24(%rbp), %eax
	movl	$1024, %edx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	write@PLT
	cmpq	$1024, %rax
	setne	%al
.L15:
	testb	%al, %al
	je	.L16
	movl	$0, %edi
	call	exit@PLT
.L16:
	addq	$1024, -16(%rbp)
	movl	$0, %edi
	call	start@PLT
	cmpl	$0, -44(%rbp)
	jne	.L17
	movl	-48(%rbp), %eax
	movslq	%eax, %rdx
	movq	-8(%rbp), %rcx
	movl	-24(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	read@PLT
	jmp	.L18
.L17:
	movl	-48(%rbp), %eax
	movslq	%eax, %rdx
	movq	-8(%rbp), %rcx
	movl	-24(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	write@PLT
.L18:
	movl	-48(%rbp), %edx
	movslq	%edx, %rdx
	cmpq	%rdx, %rax
	jne	.L26
	movl	$0, %esi
	movl	$0, %edi
	call	stop@PLT
	movl	%eax, -20(%rbp)
	movl	-48(%rbp), %eax
	cltq
	addq	%rax, -16(%rbp)
	pxor	%xmm0, %xmm0
	cvtsi2sdl	-48(%rbp), %xmm0
	pxor	%xmm1, %xmm1
	cvtsi2sdl	-20(%rbp), %xmm1
	movapd	%xmm0, %xmm2
	divsd	%xmm1, %xmm2
	movq	-16(%rbp), %rax
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
	movsd	.LC3(%rip), %xmm1
	divsd	%xmm1, %xmm0
	movq	%xmm0, %rdx
	movq	stderr(%rip), %rax
	movapd	%xmm2, %xmm1
	movq	%rdx, %xmm0
	leaq	.LC4(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	movl	$2, %eax
	call	fprintf@PLT
	movl	-28(%rbp), %eax
	cltq
	addq	%rax, -16(%rbp)
	movq	-16(%rbp), %rcx
	movl	-24(%rbp), %eax
	movl	$0, %edx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	seekto@PLT
	movq	-16(%rbp), %rdx
	cmpq	%rdx, %rax
	jne	.L27
	jmp	.L24
.L26:
	nop
	jmp	.L20
.L27:
	nop
.L20:
	movl	$0, %eax
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE10:
	.size	zone, .-zone
	.section	.rodata
.LC5:
	.string	"io"
.LC7:
	.string	"%.01f %.02f\n"
	.text
	.globl	seek
	.type	seek, @function
seek:
.LFB11:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$80, %rsp
	movq	%rdi, -72(%rbp)
	movl	%esi, -76(%rbp)
	movl	$0, -56(%rbp)
	movl	$0, -52(%rbp)
	movl	-76(%rbp), %edx
	movq	-72(%rbp), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	open@PLT
	movl	%eax, -44(%rbp)
	cmpl	$-1, -44(%rbp)
	jne	.L29
	movq	-72(%rbp), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$-1, %eax
	jmp	.L30
.L29:
	movl	-44(%rbp), %eax
	movl	%eax, %edi
	call	flushdisk
	movq	-72(%rbp), %rax
	movq	%rax, %rdi
	call	disksize
	movq	%rax, -16(%rbp)
	movl	$512, %edi
	call	valloc@PLT
	movq	%rax, -8(%rbp)
	cmpq	$0, -8(%rbp)
	jne	.L31
	leaq	.LC2(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L31:
	movq	-8(%rbp), %rax
	movl	$512, %ecx
	movl	$0, %esi
	movq	%rsi, (%rax)
	movl	%ecx, %edx
	addq	%rax, %rdx
	addq	$8, %rdx
	movq	%rsi, -16(%rdx)
	leaq	8(%rax), %rdx
	andq	$-8, %rdx
	subq	%rdx, %rax
	addl	%eax, %ecx
	andl	$-8, %ecx
	movl	%ecx, %eax
	shrl	$3, %eax
	movl	%eax, %ecx
	movq	%rdx, %rdi
	movq	%rsi, %rax
	rep stosq
	movq	-16(%rbp), %rcx
	movabsq	$2361183241434822607, %rdx
	movq	%rcx, %rax
	imulq	%rdx
	movq	%rdx, %rax
	sarq	$8, %rax
	sarq	$63, %rcx
	movq	%rcx, %rdx
	subq	%rdx, %rax
	movl	%eax, -48(%rbp)
	cmpl	$511, -48(%rbp)
	jg	.L32
	movl	$512, -48(%rbp)
.L32:
	addl	$511, -48(%rbp)
	sarl	$9, -48(%rbp)
	sall	$9, -48(%rbp)
	movq	-16(%rbp), %rax
	movq	%rax, -24(%rbp)
	movq	$0, -32(%rbp)
	movq	-32(%rbp), %rcx
	movl	-44(%rbp), %eax
	movl	$0, %edx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	seekto@PLT
	cmpl	$0, -76(%rbp)
	jne	.L33
	movq	-8(%rbp), %rcx
	movl	-44(%rbp), %eax
	movl	$512, %edx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	read@PLT
	jmp	.L34
.L33:
	movq	-8(%rbp), %rcx
	movl	-44(%rbp), %eax
	movl	$512, %edx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	write@PLT
.L34:
	movl	%eax, -40(%rbp)
	cmpl	$-1, -40(%rbp)
	jne	.L36
	leaq	.LC5(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L44:
	movl	-48(%rbp), %eax
	cltq
	subq	%rax, -24(%rbp)
	movl	$0, %edi
	call	start@PLT
	movq	-24(%rbp), %rcx
	movl	-44(%rbp), %eax
	movl	$0, %edx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	seekto@PLT
	cmpl	$0, -76(%rbp)
	jne	.L37
	movq	-8(%rbp), %rcx
	movl	-44(%rbp), %eax
	movl	$512, %edx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	read@PLT
	jmp	.L38
.L37:
	movq	-8(%rbp), %rcx
	movl	-44(%rbp), %eax
	movl	$512, %edx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	write@PLT
.L38:
	movl	%eax, -40(%rbp)
	cmpl	$-1, -40(%rbp)
	jne	.L39
	leaq	.LC5(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L39:
	movl	$0, %esi
	movl	$0, %edi
	call	stop@PLT
	movl	%eax, -36(%rbp)
	cmpl	$1000, -36(%rbp)
	jle	.L40
	cmpl	$999999, -36(%rbp)
	jg	.L40
	addl	$1, -52(%rbp)
	movl	-36(%rbp), %eax
	movslq	%eax, %rdx
	imulq	$274877907, %rdx, %rdx
	shrq	$32, %rdx
	sarl	$6, %edx
	sarl	$31, %eax
	movl	%eax, %ecx
	movl	%edx, %eax
	subl	%ecx, %eax
	addl	%eax, -56(%rbp)
	pxor	%xmm0, %xmm0
	cvtsi2sdl	-36(%rbp), %xmm0
	movsd	.LC6(%rip), %xmm1
	movapd	%xmm0, %xmm2
	divsd	%xmm1, %xmm2
	movq	-24(%rbp), %rax
	subq	-32(%rbp), %rax
	movl	-48(%rbp), %edx
	movslq	%edx, %rdx
	subq	%rdx, %rax
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	movsd	.LC3(%rip), %xmm1
	divsd	%xmm1, %xmm0
	movq	%xmm0, %rdx
	movq	stderr(%rip), %rax
	movapd	%xmm2, %xmm1
	movq	%rdx, %xmm0
	leaq	.LC7(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	movl	$2, %eax
	call	fprintf@PLT
.L40:
	movl	-48(%rbp), %eax
	cltq
	addq	%rax, -32(%rbp)
	movl	$0, %edi
	call	start@PLT
	movq	-32(%rbp), %rcx
	movl	-44(%rbp), %eax
	movl	$0, %edx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	seekto@PLT
	cmpl	$0, -76(%rbp)
	jne	.L41
	movq	-8(%rbp), %rcx
	movl	-44(%rbp), %eax
	movl	$512, %edx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	read@PLT
	jmp	.L42
.L41:
	movq	-8(%rbp), %rcx
	movl	-44(%rbp), %eax
	movl	$512, %edx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	write@PLT
.L42:
	movl	%eax, -40(%rbp)
	cmpl	$-1, -40(%rbp)
	jne	.L43
	leaq	.LC5(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L43:
	movl	$0, %esi
	movl	$0, %edi
	call	stop@PLT
	movl	%eax, -36(%rbp)
	cmpl	$1000, -36(%rbp)
	jle	.L36
	cmpl	$999999, -36(%rbp)
	jg	.L36
	addl	$1, -52(%rbp)
	movl	-36(%rbp), %eax
	movslq	%eax, %rdx
	imulq	$274877907, %rdx, %rdx
	shrq	$32, %rdx
	sarl	$6, %edx
	sarl	$31, %eax
	movl	%eax, %ecx
	movl	%edx, %eax
	subl	%ecx, %eax
	addl	%eax, -56(%rbp)
	pxor	%xmm0, %xmm0
	cvtsi2sdl	-36(%rbp), %xmm0
	movsd	.LC6(%rip), %xmm1
	movapd	%xmm0, %xmm2
	divsd	%xmm1, %xmm2
	movl	-48(%rbp), %eax
	movslq	%eax, %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	subq	-32(%rbp), %rax
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	movsd	.LC3(%rip), %xmm1
	divsd	%xmm1, %xmm0
	movq	%xmm0, %rdx
	movq	stderr(%rip), %rax
	movapd	%xmm2, %xmm1
	movq	%rdx, %xmm0
	leaq	.LC7(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	movl	$2, %eax
	call	fprintf@PLT
.L36:
	movl	-48(%rbp), %eax
	addl	%eax, %eax
	movslq	%eax, %rdx
	movq	-32(%rbp), %rax
	addq	%rdx, %rax
	cmpq	%rax, -24(%rbp)
	jge	.L44
	movl	$0, %eax
.L30:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE11:
	.size	seek, .-seek
	.section	.rodata
.LC8:
	.string	"usage: disksize device"
	.text
	.globl	disksize
	.type	disksize, @function
disksize:
.LFB12:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$560, %rsp
	movq	%rdi, -552(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movq	-552(%rbp), %rax
	movl	$0, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	open@PLT
	movl	%eax, -540(%rbp)
	movq	$0, -536(%rbp)
	cmpl	$-1, -540(%rbp)
	jne	.L46
	leaq	.LC8(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$0, %eax
	jmp	.L59
.L46:
	addq	$536870912, -536(%rbp)
	movq	-536(%rbp), %rcx
	movl	-540(%rbp), %eax
	movl	$0, %edx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	seekto@PLT
	movq	-536(%rbp), %rdx
	cmpq	%rdx, %rax
	je	.L48
	subq	$536870912, -536(%rbp)
	jmp	.L54
.L48:
	leaq	-528(%rbp), %rcx
	movl	-540(%rbp), %eax
	movl	$512, %edx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	read@PLT
	cmpq	$512, %rax
	je	.L46
	subq	$536870912, -536(%rbp)
.L54:
	addq	$67108864, -536(%rbp)
	movq	-536(%rbp), %rcx
	movl	-540(%rbp), %eax
	movl	$0, %edx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	seekto@PLT
	movq	-536(%rbp), %rdx
	cmpq	%rdx, %rax
	je	.L51
	subq	$67108864, -536(%rbp)
	jmp	.L58
.L51:
	leaq	-528(%rbp), %rcx
	movl	-540(%rbp), %eax
	movl	$512, %edx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	read@PLT
	cmpq	$512, %rax
	je	.L54
	subq	$67108864, -536(%rbp)
.L58:
	addq	$1048576, -536(%rbp)
	movq	-536(%rbp), %rcx
	movl	-540(%rbp), %eax
	movl	$0, %edx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	seekto@PLT
	movq	-536(%rbp), %rdx
	cmpq	%rdx, %rax
	je	.L55
	subq	$1048576, -536(%rbp)
	jmp	.L56
.L55:
	leaq	-528(%rbp), %rcx
	movl	-540(%rbp), %eax
	movl	$512, %edx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	read@PLT
	cmpq	$512, %rax
	je	.L58
	subq	$1048576, -536(%rbp)
.L56:
	movq	-536(%rbp), %rax
.L59:
	movq	-8(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L60
	call	__stack_chk_fail@PLT
.L60:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE12:
	.size	disksize, .-disksize
	.section	.rodata
	.align 8
.LC3:
	.long	0
	.long	1093567616
	.align 8
.LC6:
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
