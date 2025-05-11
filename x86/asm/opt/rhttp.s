	.file	"rhttp.c"
	.text
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"80"
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC1:
	.string	"Usage: %s hostname [port] remote-clients -p file ...\n"
	.section	.rodata.str1.1
.LC2:
	.string	"-p"
.LC3:
	.string	"rsh"
.LC4:
	.string	"http"
.LC5:
	.string	"%s "
.LC6:
	.string	"/tmp/rhttp%d"
	.section	.rodata.str1.8
	.align 8
.LC7:
	.string	"cat /tmp/rhttp*; rm /tmp/rhttp*"
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
	subq	$4096, %rsp
	.cfi_def_cfa_offset 4152
	orq	$0, (%rsp)
	subq	$4096, %rsp
	.cfi_def_cfa_offset 8248
	orq	$0, (%rsp)
	subq	$88, %rsp
	.cfi_def_cfa_offset 8336
	movq	%fs:40, %rax
	movq	%rax, 8264(%rsp)
	xorl	%eax, %eax
	movq	(%rsi), %rcx
	cmpl	$4, %edi
	jg	.L2
.L3:
	leaq	.LC1(%rip), %rdx
	movl	$1, %esi
	movq	stderr(%rip), %rdi
	call	__fprintf_chk@PLT
	movl	$1, %edi
	call	exit@PLT
.L2:
	movl	%edi, %r12d
	movq	%rsi, %rbp
	movq	8(%rsi), %rax
	movq	%rax, 8(%rsp)
	movq	16(%rsi), %rdi
	movl	$10, %edx
	movl	$0, %esi
	call	strtol@PLT
	testl	%eax, %eax
	jne	.L4
	addq	$8, %rbp
	subl	$1, %r12d
	leaq	.LC0(%rip), %rax
	movq	%rax, (%rsp)
.L5:
	movl	%r12d, 20(%rsp)
	leal	-2(%r12), %eax
	movq	%rax, 24(%rsp)
	movl	%r12d, %r13d
	movl	$1, %ebx
	leaq	.LC2(%rip), %r15
.L9:
	movq	0(%rbp,%rbx,8), %rsi
	movq	%r15, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	je	.L28
	addq	$1, %rbx
	cmpq	%r13, %rbx
	jne	.L9
	leaq	.LC3(%rip), %rax
	movq	%rax, 32(%rsp)
	leaq	.LC4(%rip), %rax
	movq	%rax, 48(%rsp)
	movq	8(%rsp), %rax
	movq	%rax, 56(%rsp)
	movl	$4, %eax
	jmp	.L8
.L4:
	movq	16(%rbp), %rax
	movq	%rax, (%rsp)
	addq	$16, %rbp
	subl	$2, %r12d
	jmp	.L5
.L28:
	leal	1(%rbx), %eax
	leaq	.LC3(%rip), %rcx
	movq	%rcx, 32(%rsp)
	leaq	.LC4(%rip), %rcx
	movq	%rcx, 48(%rsp)
	movq	8(%rsp), %rcx
	movq	%rcx, 56(%rsp)
	cmpl	%eax, %r12d
	jle	.L29
	cltq
	movslq	%ebx, %rdx
	imulq	$-8, %rdx, %rdx
	leaq	32(%rsp,%rdx), %rcx
.L11:
	movq	0(%rbp,%rax,8), %rdx
	movq	%rdx, 24(%rcx,%rax,8)
	addq	$1, %rax
	cmpl	%eax, %r12d
	jg	.L11
	movl	20(%rsp), %eax
	addl	$3, %eax
	subl	%ebx, %eax
.L8:
	movslq	%eax, %rdx
	movq	(%rsp), %rcx
	movq	%rcx, 32(%rsp,%rdx,8)
	addl	$1, %eax
	cltq
	movq	$0, 32(%rsp,%rax,8)
	movl	$1, %r14d
	leaq	.LC2(%rip), %r15
	leaq	.LC5(%rip), %r12
	jmp	.L17
.L29:
	movl	$4, %eax
	jmp	.L8
.L18:
	leaq	8(%rbp), %rbx
	movq	24(%rsp), %rax
	leaq	16(%rbp,%rax,8), %r12
	leaq	.LC2(%rip), %rbp
.L13:
	movq	(%rbx), %rsi
	movq	%rbp, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	je	.L19
	movl	$0, %edi
	call	wait@PLT
	addq	$8, %rbx
	cmpq	%rbx, %r12
	jne	.L13
.L19:
	leaq	.LC7(%rip), %rdi
	call	system@PLT
	movl	$1, %edi
	call	exit@PLT
.L14:
	movl	$10, %edi
	call	putchar@PLT
	call	fork@PLT
	testl	%eax, %eax
	je	.L30
	addq	$1, %r14
	cmpq	%r13, %r14
	je	.L18
.L17:
	movl	%r14d, (%rsp)
	movq	0(%rbp,%r14,8), %rbx
	movq	%rbx, %rsi
	movq	%r15, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	je	.L18
	movq	%rbx, 40(%rsp)
	movq	32(%rsp), %rdx
	testq	%rdx, %rdx
	je	.L14
	leaq	40(%rsp), %rbx
.L15:
	movq	%r12, %rsi
	movl	$1, %edi
	movl	$0, %eax
	call	__printf_chk@PLT
	addq	$8, %rbx
	movq	-8(%rbx), %rdx
	testq	%rdx, %rdx
	jne	.L15
	jmp	.L14
.L30:
	leaq	8224(%rsp), %rbx
	movl	(%rsp), %r8d
	leaq	.LC6(%rip), %rcx
	movl	$30, %edx
	movl	$1, %esi
	movq	%rbx, %rdi
	call	__sprintf_chk@PLT
	movl	$438, %esi
	movq	%rbx, %rdi
	call	creat@PLT
	movl	$2, %edi
	call	close@PLT
	movl	$1, %edi
	call	dup@PLT
	leaq	32(%rsp), %rsi
	movq	32(%rsp), %rdi
	call	execvp@PLT
	movq	32(%rsp), %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
	.cfi_endproc
.LFE72:
	.size	main, .-main
	.globl	id
	.section	.rodata.str1.1
.LC8:
	.string	"$Id$\n"
	.section	.data.rel.local,"aw"
	.align 8
	.type	id, @object
	.size	id, 8
id:
	.quad	.LC8
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
