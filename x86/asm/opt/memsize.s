	.file	"memsize.c"
	.text
	.type	touchRange, @function
touchRange:
.LFB74:
	.cfi_startproc
	leaq	-1(%rsi), %rax
	testq	%rdx, %rdx
	movl	$0, %ecx
	cmovg	%rcx, %rax
	addq	%rax, %rdi
	movq	%rdx, %rax
	negq	%rax
	cmovs	%rdx, %rax
	leaq	-1(%rax), %rcx
	cmpq	%rcx, %rsi
	jbe	.L8
.L3:
	cmpl	$0, alarm_triggered(%rip)
	jne	.L1
	movb	$0, (%rdi)
	addq	%rdx, %rdi
	subq	%rax, %rsi
	cmpq	%rcx, %rsi
	ja	.L3
.L1:
	ret
.L8:
	ret
	.cfi_endproc
.LFE74:
	.size	touchRange, .-touchRange
	.globl	gotalarm
	.type	gotalarm, @function
gotalarm:
.LFB76:
	.cfi_startproc
	endbr64
	movl	$1, alarm_triggered(%rip)
	ret
	.cfi_endproc
.LFE76:
	.size	gotalarm, .-gotalarm
	.globl	test_malloc
	.type	test_malloc, @function
test_malloc:
.LFB75:
	.cfi_startproc
	endbr64
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	subq	$32, %rsp
	.cfi_def_cfa_offset 48
	movq	%rdi, %rbx
	movq	%fs:40, %rax
	movq	%rax, 24(%rsp)
	xorl	%eax, %eax
	leaq	16(%rsp), %rdi
	call	pipe@PLT
	testl	%eax, %eax
	js	.L19
	call	fork@PLT
	testl	%eax, %eax
	jne	.L13
	movl	16(%rsp), %edi
	call	close@PLT
	movq	%rbx, %rdi
	call	malloc@PLT
	movq	%rax, %rbx
	testq	%rax, %rax
	setne	%al
	movzbl	%al, %eax
	movl	%eax, 8(%rsp)
	leaq	8(%rsp), %rsi
	movl	$4, %edx
	movl	20(%rsp), %edi
	call	write@PLT
	movl	20(%rsp), %edi
	call	close@PLT
	testq	%rbx, %rbx
	je	.L14
	movq	%rbx, %rdi
	call	free@PLT
.L14:
	movl	$0, %edi
	call	exit@PLT
.L19:
	movq	%rbx, %rdi
	call	malloc@PLT
	movq	%rax, %rdi
	testq	%rax, %rax
	je	.L17
	call	free@PLT
	movl	$1, %eax
.L10:
	movq	24(%rsp), %rdx
	subq	%fs:40, %rdx
	jne	.L20
	addq	$32, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 16
	popq	%rbx
	.cfi_def_cfa_offset 8
	ret
.L13:
	.cfi_restore_state
	movl	20(%rsp), %edi
	call	close@PLT
	leaq	8(%rsp), %rsi
	movl	$4, %edx
	movl	16(%rsp), %edi
	call	read@PLT
	cmpq	$4, %rax
	je	.L15
	movl	$0, 8(%rsp)
.L15:
	movl	16(%rsp), %edi
	call	close@PLT
	leaq	12(%rsp), %rdi
	call	wait@PLT
	movl	8(%rsp), %eax
	jmp	.L10
.L17:
	movl	$0, %eax
	jmp	.L10
.L20:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE75:
	.size	test_malloc, .-test_malloc
	.globl	set_alarm
	.type	set_alarm, @function
set_alarm:
.LFB77:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushq	%rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	subq	$200, %rsp
	.cfi_def_cfa_offset 224
	movq	%rdi, %rbx
	movq	%fs:40, %rax
	movq	%rax, 184(%rsp)
	xorl	%eax, %eax
	movl	$0, alarm_triggered(%rip)
	leaq	gotalarm(%rip), %rax
	movq	%rax, 32(%rsp)
	leaq	32(%rsp), %rbp
	leaq	40(%rsp), %rdi
	call	sigemptyset@PLT
	movl	$0, 168(%rsp)
	movl	$0, %edx
	movq	%rbp, %rsi
	movl	$14, %edi
	call	sigaction@PLT
	movq	$0, (%rsp)
	movq	$0, 8(%rsp)
	movabsq	$4835703278458516699, %rdx
	movq	%rbx, %rax
	mulq	%rdx
	shrq	$18, %rdx
	movq	%rdx, 16(%rsp)
	imulq	$1000000, %rdx, %rdx
	subq	%rdx, %rbx
	movq	%rbx, 24(%rsp)
	movq	%rsp, %rsi
	movl	$0, %edx
	movl	$0, %edi
	call	setitimer@PLT
	movq	184(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L24
	addq	$200, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
.L24:
	.cfi_restore_state
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE77:
	.size	set_alarm, .-set_alarm
	.globl	clear_alarm
	.type	clear_alarm, @function
clear_alarm:
.LFB78:
	.cfi_startproc
	endbr64
	subq	$56, %rsp
	.cfi_def_cfa_offset 64
	movq	%fs:40, %rax
	movq	%rax, 40(%rsp)
	xorl	%eax, %eax
	movq	$0, (%rsp)
	movq	$0, 8(%rsp)
	movq	$0, 16(%rsp)
	movq	$0, 24(%rsp)
	movq	%rsp, %rsi
	movl	$0, %edx
	movl	$0, %edi
	call	setitimer@PLT
	movq	40(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L28
	addq	$56, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	ret
.L28:
	.cfi_restore_state
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE78:
	.size	clear_alarm, .-clear_alarm
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"Bad size\n"
.LC1:
	.string	"%dMB OK\r"
.LC2:
	.string	"%d\n"
	.text
	.globl	timeit
	.type	timeit, @function
timeit:
.LFB73:
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
	movq	%rdi, (%rsp)
	cmpq	$1032191, %rsi
	jbe	.L45
	movq	%rsi, %r15
	call	getpagesize@PLT
	movl	%eax, %ebx
	cltq
	movq	%rax, 8(%rsp)
	movq	%rax, %rdx
	movl	$1048576, %esi
	movq	(%rsp), %rdi
	call	touchRange
	cmpq	$2097151, %r15
	jbe	.L40
	movslq	%ebx, %rax
	movq	%rax, 24(%rsp)
	movl	$1048576, %ebx
	movl	$2097152, %ebp
	jmp	.L38
.L45:
	movq	stderr(%rip), %rcx
	movl	$9, %edx
	movl	$1, %esi
	leaq	.LC0(%rip), %rdi
	call	fwrite@PLT
	jmp	.L29
.L41:
	movl	$8388608, %ebx
	jmp	.L33
.L36:
	movq	%rbp, %rcx
	shrq	$20, %rcx
	leaq	.LC1(%rip), %rdx
	movl	$1, %esi
	movq	stderr(%rip), %rdi
	movl	$0, %eax
	call	__fprintf_chk@PLT
	addq	%rbx, %rbp
	cmpq	%rbp, %r15
	jb	.L46
.L38:
	movq	%rbp, %rax
	movl	$0, %edx
	divq	24(%rsp)
	movq	%rax, %r13
	leaq	(%rax,%rax,4), %r14
	addq	%r14, %r14
	movq	%r14, %rdi
	call	set_alarm
	movq	%rbp, %rax
	subq	%rbx, %rax
	movq	%rax, 16(%rsp)
	movq	(%rsp), %rcx
	addq	%rax, %rcx
	movq	%rcx, %rdi
	movq	8(%rsp), %rdx
	movq	%rbx, %rsi
	call	touchRange
	movl	$0, %eax
	call	clear_alarm
	movq	%r14, %rdi
	call	set_alarm
	movl	$0, %edi
	call	start@PLT
	movq	8(%rsp), %rdx
	movq	%rbp, %rsi
	movq	(%rsp), %rdi
	call	touchRange
	movl	$0, %esi
	movl	$0, %edi
	call	stop@PLT
	movq	%rax, %rbx
	movl	$0, %eax
	call	clear_alarm
	movslq	%ebx, %rax
	movl	$0, %edx
	divq	%r13
	cmpq	$10, %rax
	ja	.L32
	cmpl	$0, alarm_triggered(%rip)
	jne	.L32
	cmpq	$8388608, %r12
	ja	.L41
	cmpq	$8388607, %rbp
	jbe	.L41
	movl	$8388608, %ebx
.L34:
	movq	%rbx, %r12
	addq	%rbx, %rbx
	cmpq	%r12, %rbx
	jb	.L33
	cmpq	%rbp, %rbx
	jbe	.L34
.L33:
	shrq	$3, %rbx
	cmpq	%rbp, %r15
	jbe	.L36
	leaq	(%rbx,%rbp), %r13
	cmpq	%r15, %r13
	jbe	.L37
	movq	%r15, %rbx
	subq	%rbp, %rbx
	jmp	.L36
.L40:
	movq	%r15, 16(%rsp)
	jmp	.L32
.L46:
	movq	%r15, 16(%rsp)
.L32:
	movq	stderr(%rip), %rsi
	movl	$10, %edi
	call	fputc@PLT
	movq	16(%rsp), %rdx
	shrq	$20, %rdx
	leaq	.LC2(%rip), %rsi
	movl	$1, %edi
	movl	$0, %eax
	call	__printf_chk@PLT
.L29:
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
.L37:
	.cfi_restore_state
	movq	%rbp, %rcx
	shrq	$20, %rcx
	leaq	.LC1(%rip), %rdx
	movl	$1, %esi
	movq	stderr(%rip), %rdi
	movl	$0, %eax
	call	__fprintf_chk@PLT
	movq	%r13, %rbp
	jmp	.L38
	.cfi_endproc
.LFE73:
	.size	timeit, .-timeit
	.globl	main
	.type	main, @function
main:
.LFB72:
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
	movl	$1073741824, %ebp
	cmpl	$2, %edi
	je	.L58
.L48:
	movq	%rbp, %r13
	jmp	.L49
.L58:
	movq	8(%rsi), %rdi
	call	bytes@PLT
	salq	$20, %rax
	movq	%rax, %rbp
	cmpq	$1048575, %rax
	ja	.L48
	movl	$1073741824, %ebp
	jmp	.L48
.L50:
	movq	%rbp, %r13
	shrq	%rbp
.L49:
	movq	%rbp, %rdi
	call	test_malloc
	testl	%eax, %eax
	je	.L50
	movq	%rbp, %r12
	shrq	$21, %r12
	jne	.L53
.L51:
	movq	%rbp, %rdi
	call	malloc@PLT
	movq	%rax, %rbx
	testq	%rax, %rax
	je	.L54
	movq	%rbp, %rsi
	movq	%rax, %rdi
	call	timeit
	movq	%rbx, %rdi
	call	free@PLT
.L54:
	movl	$0, %edi
	call	exit@PLT
.L52:
	shrq	%r12
	je	.L51
.L53:
	movq	%r12, %rbx
	salq	$20, %rbx
	addq	%rbp, %rbx
	cmpq	%rbx, %r13
	jb	.L52
	movq	%rbx, %rdi
	call	test_malloc
	testl	%eax, %eax
	je	.L51
	movq	%rbx, %rbp
	jmp	.L52
	.cfi_endproc
.LFE72:
	.size	main, .-main
	.globl	alarm_triggered
	.bss
	.align 4
	.type	alarm_triggered, @object
	.size	alarm_triggered, 4
alarm_triggered:
	.zero	4
	.globl	id
	.section	.rodata.str1.1
.LC3:
	.string	"$Id$\n"
	.section	.data.rel.local,"aw"
	.align 8
	.type	id, @object
	.size	id, 8
id:
	.quad	.LC3
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
