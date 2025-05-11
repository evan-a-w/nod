	.file	"memsize.c"
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
	.globl	alarm_triggered
	.bss
	.align 4
	.type	alarm_triggered, @object
	.size	alarm_triggered, 4
alarm_triggered:
	.zero	4
	.text
	.globl	main
	.type	main, @function
main:
.LFB8:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$64, %rsp
	movl	%edi, -52(%rbp)
	movq	%rsi, -64(%rbp)
	movq	$0, -48(%rbp)
	movq	$0, -40(%rbp)
	cmpl	$2, -52(%rbp)
	jne	.L2
	movq	-64(%rbp), %rax
	addq	$8, %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	bytes@PLT
	salq	$20, %rax
	movq	%rax, -48(%rbp)
	movq	-48(%rbp), %rax
	movq	%rax, -40(%rbp)
.L2:
	cmpq	$1048575, -40(%rbp)
	ja	.L3
	movq	$1073741824, -48(%rbp)
	movq	-48(%rbp), %rax
	movq	%rax, -40(%rbp)
.L3:
	movq	$0, -24(%rbp)
	jmp	.L4
.L5:
	movq	-48(%rbp), %rax
	movq	%rax, -40(%rbp)
	shrq	-48(%rbp)
.L4:
	movq	-48(%rbp), %rax
	movq	%rax, %rdi
	call	test_malloc
	testl	%eax, %eax
	je	.L5
	movq	-48(%rbp), %rax
	shrq	$21, %rax
	movq	%rax, -32(%rbp)
	jmp	.L6
.L10:
	movq	-32(%rbp), %rax
	salq	$20, %rax
	movq	%rax, %rdx
	movq	-48(%rbp), %rax
	addq	%rdx, %rax
	movq	%rax, -16(%rbp)
	movq	-16(%rbp), %rax
	movq	%rax, -8(%rbp)
	movq	-40(%rbp), %rax
	cmpq	-16(%rbp), %rax
	jb	.L12
	movq	-8(%rbp), %rax
	cmpq	-16(%rbp), %rax
	jb	.L9
	movq	-16(%rbp), %rax
	movq	%rax, %rdi
	call	test_malloc
	testl	%eax, %eax
	je	.L9
	movq	-16(%rbp), %rax
	movq	%rax, -48(%rbp)
	jmp	.L8
.L12:
	nop
.L8:
	shrq	-32(%rbp)
.L6:
	cmpq	$0, -32(%rbp)
	jne	.L10
.L9:
	movq	-48(%rbp), %rax
	movq	%rax, %rdi
	call	malloc@PLT
	movq	%rax, -24(%rbp)
	cmpq	$0, -24(%rbp)
	je	.L11
	movq	-48(%rbp), %rdx
	movq	-24(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	timeit
	movq	-24(%rbp), %rax
	movq	%rax, %rdi
	call	free@PLT
.L11:
	movl	$0, %edi
	call	exit@PLT
	.cfi_endproc
.LFE8:
	.size	main, .-main
	.section	.rodata
.LC1:
	.string	"Bad size\n"
.LC2:
	.string	"%dMB OK\r"
.LC3:
	.string	"%d\n"
	.text
	.globl	timeit
	.type	timeit, @function
timeit:
.LFB9:
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
	movl	$0, -52(%rbp)
	movq	$1048576, -32(%rbp)
	call	getpagesize@PLT
	cltq
	movq	%rax, -16(%rbp)
	cmpq	$1032191, -80(%rbp)
	ja	.L14
	movq	stderr(%rip), %rax
	movq	%rax, %rcx
	movl	$9, %edx
	movl	$1, %esi
	leaq	.LC1(%rip), %rax
	movq	%rax, %rdi
	call	fwrite@PLT
	jmp	.L13
.L14:
	movq	$1048576, -40(%rbp)
	movq	$1048576, -32(%rbp)
	movq	-16(%rbp), %rdx
	movq	-40(%rbp), %rcx
	movq	-72(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	touchRange
	movq	-32(%rbp), %rax
	addq	%rax, -40(%rbp)
	jmp	.L16
.L25:
	movq	-40(%rbp), %rax
	movl	$0, %edx
	divq	-16(%rbp)
	movq	%rax, -8(%rbp)
	movq	-8(%rbp), %rdx
	movq	%rdx, %rax
	salq	$2, %rax
	addq	%rdx, %rax
	addq	%rax, %rax
	movq	%rax, %rdi
	call	set_alarm
	movq	-16(%rbp), %rdx
	movq	-40(%rbp), %rax
	subq	-32(%rbp), %rax
	movq	%rax, %rcx
	movq	-72(%rbp), %rax
	addq	%rax, %rcx
	movq	-32(%rbp), %rax
	movq	%rax, %rsi
	movq	%rcx, %rdi
	call	touchRange
	movl	$0, %eax
	call	clear_alarm
	movq	-8(%rbp), %rdx
	movq	%rdx, %rax
	salq	$2, %rax
	addq	%rdx, %rax
	addq	%rax, %rax
	movq	%rax, %rdi
	call	set_alarm
	movl	$0, %edi
	call	start@PLT
	movq	-16(%rbp), %rdx
	movq	-40(%rbp), %rcx
	movq	-72(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	touchRange
	movl	$0, %esi
	movl	$0, %edi
	call	stop@PLT
	movl	%eax, -52(%rbp)
	movl	$0, %eax
	call	clear_alarm
	movl	-52(%rbp), %eax
	cltq
	movl	$0, %edx
	divq	-8(%rbp)
	cmpq	$10, %rax
	ja	.L17
	movl	alarm_triggered(%rip), %eax
	testl	%eax, %eax
	je	.L18
.L17:
	movq	-40(%rbp), %rax
	subq	-32(%rbp), %rax
	movq	%rax, -80(%rbp)
	jmp	.L19
.L18:
	movq	$8388608, -24(%rbp)
	jmp	.L20
.L23:
	movq	-24(%rbp), %rax
	cmpq	-48(%rbp), %rax
	jb	.L26
	movq	-24(%rbp), %rax
	movq	%rax, -48(%rbp)
	salq	-24(%rbp)
.L20:
	movq	-24(%rbp), %rax
	cmpq	-40(%rbp), %rax
	jbe	.L23
	jmp	.L22
.L26:
	nop
.L22:
	movq	-24(%rbp), %rax
	shrq	$3, %rax
	movq	%rax, -32(%rbp)
	movq	-40(%rbp), %rax
	cmpq	-80(%rbp), %rax
	jnb	.L24
	movq	-40(%rbp), %rdx
	movq	-32(%rbp), %rax
	addq	%rdx, %rax
	cmpq	%rax, -80(%rbp)
	jnb	.L24
	movq	-80(%rbp), %rax
	subq	-40(%rbp), %rax
	movq	%rax, -32(%rbp)
.L24:
	movq	-40(%rbp), %rax
	shrq	$20, %rax
	movl	%eax, %edx
	movq	stderr(%rip), %rax
	leaq	.LC2(%rip), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf@PLT
	movq	-32(%rbp), %rax
	addq	%rax, -40(%rbp)
.L16:
	movq	-40(%rbp), %rax
	cmpq	-80(%rbp), %rax
	jbe	.L25
.L19:
	movq	stderr(%rip), %rax
	movq	%rax, %rsi
	movl	$10, %edi
	call	fputc@PLT
	movq	-80(%rbp), %rax
	shrq	$20, %rax
	movl	%eax, %esi
	leaq	.LC3(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf@PLT
.L13:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE9:
	.size	timeit, .-timeit
	.type	touchRange, @function
touchRange:
.LFB10:
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
	movq	%rdi, -24(%rbp)
	movq	%rsi, -32(%rbp)
	movq	%rdx, -40(%rbp)
	cmpq	$0, -40(%rbp)
	jg	.L28
	movq	-32(%rbp), %rax
	leaq	-1(%rax), %rdx
	jmp	.L29
.L28:
	movl	$0, %edx
.L29:
	movq	-24(%rbp), %rax
	leaq	(%rdx,%rax), %rbx
	movq	-40(%rbp), %rax
	movq	%rax, %rdx
	negq	%rdx
	cmovns	%rdx, %rax
	movq	%rax, %r12
	jmp	.L30
.L32:
	movb	$0, (%rbx)
	movq	-40(%rbp), %rax
	addq	%rax, %rbx
	subq	%r12, -32(%rbp)
.L30:
	leaq	-1(%r12), %rax
	cmpq	%rax, -32(%rbp)
	jbe	.L33
	movl	alarm_triggered(%rip), %eax
	testl	%eax, %eax
	je	.L32
.L33:
	nop
	popq	%rbx
	popq	%r12
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE10:
	.size	touchRange, .-touchRange
	.globl	test_malloc
	.type	test_malloc, @function
test_malloc:
.LFB11:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$64, %rsp
	movq	%rdi, -56(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	leaq	-16(%rbp), %rax
	movq	%rax, %rdi
	call	pipe@PLT
	testl	%eax, %eax
	jns	.L35
	movq	-56(%rbp), %rax
	movq	%rax, %rdi
	call	malloc@PLT
	movq	%rax, -24(%rbp)
	cmpq	$0, -24(%rbp)
	jne	.L36
	movl	$0, %eax
	jmp	.L41
.L36:
	movq	-24(%rbp), %rax
	movq	%rax, %rdi
	call	free@PLT
	movl	$1, %eax
	jmp	.L41
.L35:
	call	fork@PLT
	testl	%eax, %eax
	jne	.L38
	movl	-16(%rbp), %eax
	movl	%eax, %edi
	call	close@PLT
	movq	-56(%rbp), %rax
	movq	%rax, %rdi
	call	malloc@PLT
	movq	%rax, -32(%rbp)
	cmpq	$0, -32(%rbp)
	setne	%al
	movzbl	%al, %eax
	movl	%eax, -40(%rbp)
	movl	-12(%rbp), %eax
	leaq	-40(%rbp), %rcx
	movl	$4, %edx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	write@PLT
	movl	-12(%rbp), %eax
	movl	%eax, %edi
	call	close@PLT
	cmpq	$0, -32(%rbp)
	je	.L39
	movq	-32(%rbp), %rax
	movq	%rax, %rdi
	call	free@PLT
.L39:
	movl	$0, %edi
	call	exit@PLT
.L38:
	movl	-12(%rbp), %eax
	movl	%eax, %edi
	call	close@PLT
	movl	-16(%rbp), %eax
	leaq	-40(%rbp), %rcx
	movl	$4, %edx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	read@PLT
	cmpq	$4, %rax
	je	.L40
	movl	$0, -40(%rbp)
.L40:
	movl	-16(%rbp), %eax
	movl	%eax, %edi
	call	close@PLT
	leaq	-36(%rbp), %rax
	movq	%rax, %rdi
	call	wait@PLT
	movl	-40(%rbp), %eax
.L41:
	movq	-8(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L42
	call	__stack_chk_fail@PLT
.L42:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE11:
	.size	test_malloc, .-test_malloc
	.globl	gotalarm
	.type	gotalarm, @function
gotalarm:
.LFB12:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%edi, -4(%rbp)
	movl	$1, alarm_triggered(%rip)
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE12:
	.size	gotalarm, .-gotalarm
	.globl	set_alarm
	.type	set_alarm, @function
set_alarm:
.LFB13:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$208, %rsp
	movq	%rdi, -200(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movl	$0, alarm_triggered(%rip)
	leaq	gotalarm(%rip), %rax
	movq	%rax, -160(%rbp)
	leaq	-160(%rbp), %rax
	addq	$8, %rax
	movq	%rax, %rdi
	call	sigemptyset@PLT
	movl	$0, -24(%rbp)
	leaq	-160(%rbp), %rax
	movl	$0, %edx
	movq	%rax, %rsi
	movl	$14, %edi
	call	sigaction@PLT
	movq	$0, -192(%rbp)
	movq	$0, -184(%rbp)
	movq	-200(%rbp), %rax
	movabsq	$4835703278458516699, %rdx
	mulq	%rdx
	movq	%rdx, %rax
	shrq	$18, %rax
	movq	%rax, -176(%rbp)
	movq	-200(%rbp), %rcx
	movabsq	$4835703278458516699, %rdx
	movq	%rcx, %rax
	mulq	%rdx
	movq	%rdx, %rax
	shrq	$18, %rax
	imulq	$1000000, %rax, %rdx
	movq	%rcx, %rax
	subq	%rdx, %rax
	movq	%rax, -168(%rbp)
	leaq	-192(%rbp), %rax
	movl	$0, %edx
	movq	%rax, %rsi
	movl	$0, %edi
	call	setitimer@PLT
	nop
	movq	-8(%rbp), %rax
	subq	%fs:40, %rax
	je	.L45
	call	__stack_chk_fail@PLT
.L45:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE13:
	.size	set_alarm, .-set_alarm
	.globl	clear_alarm
	.type	clear_alarm, @function
clear_alarm:
.LFB14:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$48, %rsp
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movq	$0, -48(%rbp)
	movq	$0, -40(%rbp)
	movq	$0, -32(%rbp)
	movq	$0, -24(%rbp)
	leaq	-48(%rbp), %rax
	movl	$0, %edx
	movq	%rax, %rsi
	movl	$0, %edi
	call	setitimer@PLT
	nop
	movq	-8(%rbp), %rax
	subq	%fs:40, %rax
	je	.L47
	call	__stack_chk_fail@PLT
.L47:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE14:
	.size	clear_alarm, .-clear_alarm
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
