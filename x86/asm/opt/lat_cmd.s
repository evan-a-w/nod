	.file	"lat_cmd.c"
	.text
	.globl	bench
	.type	bench, @function
bench:
.LFB74:
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
	movq	%rdi, %r12
	movq	%rsi, %rbx
	movl	$0, %esi
	movl	$17, %edi
	call	signal@PLT
	leaq	-1(%r12), %rbp
	testq	%r12, %r12
	jne	.L4
.L1:
	popq	%rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	ret
.L3:
	.cfi_restore_state
	movl	8(%rbx), %edi
	movl	$0, %edx
	movl	$0, %esi
	call	waitpid@PLT
	movl	$0, 8(%rbx)
	subq	$1, %rbp
	cmpq	$-1, %rbp
	je	.L1
.L4:
	call	fork@PLT
	movl	%eax, 8(%rbx)
	cmpl	$48, %eax
	jne	.L3
	movq	(%rbx), %rax
	movq	%rax, %rsi
	movq	(%rax), %rdi
	call	execvp@PLT
	jmp	.L3
	.cfi_endproc
.LFE74:
	.size	bench, .-bench
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC0:
	.string	"[-P <parallelism>] [-W <warmup>] [-N <repetitions>] cmdline...\n"
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC1:
	.string	"P:W:N:"
.LC2:
	.string	"malloc"
.LC3:
	.string	"lat_cmd"
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
	subq	$56, %rsp
	.cfi_def_cfa_offset 112
	movl	%edi, %ebx
	movq	%rsi, %rbp
	movq	%fs:40, %rax
	movq	%rax, 40(%rsp)
	xorl	%eax, %eax
	movl	$-1, %r14d
	movl	$0, %r13d
	movl	$1, 12(%rsp)
	leaq	.LC1(%rip), %r12
	leaq	.LC0(%rip), %r15
	jmp	.L8
.L9:
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	movl	%eax, 12(%rsp)
	testl	%eax, %eax
	jg	.L8
	movq	%r15, %rdx
	movq	%rbp, %rsi
	movl	%ebx, %edi
	call	lmbench_usage@PLT
	jmp	.L8
.L10:
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	movl	%eax, %r13d
.L8:
	movq	%r12, %rdx
	movq	%rbp, %rsi
	movl	%ebx, %edi
	call	mygetopt@PLT
	cmpl	$-1, %eax
	je	.L24
	cmpl	$80, %eax
	je	.L9
	cmpl	$87, %eax
	je	.L10
	cmpl	$78, %eax
	je	.L25
	movq	%r15, %rdx
	movq	%rbp, %rsi
	movl	%ebx, %edi
	call	lmbench_usage@PLT
	jmp	.L8
.L25:
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	movl	%eax, %r14d
	jmp	.L8
.L24:
	cmpl	%ebx, myoptind(%rip)
	jge	.L26
.L15:
	movl	%ebx, %edi
	subl	myoptind(%rip), %edi
	addl	$1, %edi
	movslq	%edi, %rdi
	salq	$3, %rdi
	call	malloc@PLT
	movq	%rax, 16(%rsp)
	testq	%rax, %rax
	je	.L27
	movl	$0, 24(%rsp)
	movl	myoptind(%rip), %eax
	cmpl	%eax, %ebx
	jle	.L20
	movl	$0, %ecx
	movl	$0, %edx
.L18:
	addl	%edx, %eax
	cltq
	movq	0(%rbp,%rax,8), %rsi
	movq	16(%rsp), %rax
	movq	%rsi, (%rax,%rcx)
	addl	$1, %edx
	movl	myoptind(%rip), %eax
	addq	$8, %rcx
	movl	%ebx, %esi
	subl	%eax, %esi
	cmpl	%edx, %esi
	jg	.L18
.L17:
	movslq	%edx, %rdx
	movq	16(%rsp), %rax
	movq	$0, (%rax,%rdx,8)
	leaq	16(%rsp), %rax
	pushq	%rax
	.cfi_def_cfa_offset 120
	pushq	%r14
	.cfi_def_cfa_offset 128
	movl	%r13d, %r9d
	movl	28(%rsp), %r8d
	movl	$0, %ecx
	movl	$0, %edx
	leaq	bench(%rip), %rsi
	movl	$0, %edi
	call	benchmp@PLT
	call	get_n@PLT
	movq	%rax, %rsi
	leaq	.LC3(%rip), %rdi
	call	micro@PLT
	addq	$16, %rsp
	.cfi_def_cfa_offset 112
	movq	40(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L28
	movl	$0, %eax
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
.L26:
	.cfi_restore_state
	leaq	.LC0(%rip), %rdx
	movq	%rbp, %rsi
	movl	%ebx, %edi
	call	lmbench_usage@PLT
	jmp	.L15
.L27:
	leaq	.LC2(%rip), %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L20:
	movl	$0, %edx
	jmp	.L17
.L28:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE72:
	.size	main, .-main
	.globl	cleanup
	.type	cleanup, @function
cleanup:
.LFB73:
	.cfi_startproc
	endbr64
	testq	%rdi, %rdi
	jne	.L32
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movq	%rsi, %rbx
	movl	8(%rsi), %edi
	testl	%edi, %edi
	jne	.L35
.L29:
	popq	%rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	ret
.L35:
	.cfi_restore_state
	movl	$9, %esi
	call	kill@PLT
	movl	8(%rbx), %edi
	movl	$0, %edx
	movl	$0, %esi
	call	waitpid@PLT
	movl	$0, 8(%rbx)
	jmp	.L29
.L32:
	.cfi_def_cfa_offset 8
	.cfi_restore 3
	ret
	.cfi_endproc
.LFE73:
	.size	cleanup, .-cleanup
	.globl	id
	.section	.rodata.str1.1
.LC4:
	.string	"$Id$\n"
	.section	.data.rel.local,"aw"
	.align 8
	.type	id, @object
	.size	id, 8
id:
	.quad	.LC4
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
