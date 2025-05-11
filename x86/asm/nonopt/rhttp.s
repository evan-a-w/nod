	.file	"rhttp.c"
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
	.section	.rodata
	.align 8
.LC1:
	.string	"Usage: %s hostname [port] remote-clients -p file ...\n"
.LC2:
	.string	"80"
.LC3:
	.string	"-p"
.LC4:
	.string	"rsh"
.LC5:
	.string	"http"
.LC6:
	.string	"%s "
.LC7:
	.string	"/tmp/rhttp%d"
	.align 8
.LC8:
	.string	"cat /tmp/rhttp*; rm /tmp/rhttp*"
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
	subq	$4096, %rsp
	orq	$0, (%rsp)
	subq	$4096, %rsp
	orq	$0, (%rsp)
	addq	$-128, %rsp
	movl	%edi, -8308(%rbp)
	movq	%rsi, -8320(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movq	-8320(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -8272(%rbp)
	movq	$0, -8264(%rbp)
	movq	$0, -8256(%rbp)
	cmpl	$4, -8308(%rbp)
	jg	.L2
	nop
.L3:
	movq	stderr(%rip), %rax
	movq	-8272(%rbp), %rdx
	leaq	.LC1(%rip), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf@PLT
	movl	$1, %edi
	call	exit@PLT
.L2:
	movq	-8320(%rbp), %rax
	movq	8(%rax), %rax
	movq	%rax, -8248(%rbp)
	addq	$8, -8320(%rbp)
	subl	$1, -8308(%rbp)
	movq	-8320(%rbp), %rax
	addq	$8, %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	testl	%eax, %eax
	je	.L4
	movq	-8320(%rbp), %rax
	movq	8(%rax), %rax
	movq	%rax, -8280(%rbp)
	addq	$8, -8320(%rbp)
	subl	$1, -8308(%rbp)
	jmp	.L5
.L4:
	leaq	.LC2(%rip), %rax
	movq	%rax, -8280(%rbp)
.L5:
	movl	$1, -8288(%rbp)
	jmp	.L6
.L9:
	movl	-8288(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-8320(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	%rax, %rsi
	leaq	.LC3(%rip), %rax
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L7
	addl	$1, -8288(%rbp)
	jmp	.L8
.L7:
	addl	$1, -8288(%rbp)
.L6:
	movl	-8288(%rbp), %eax
	cmpl	-8308(%rbp), %eax
	jl	.L9
.L8:
	leaq	.LC4(%rip), %rax
	movq	%rax, -8240(%rbp)
	leaq	.LC5(%rip), %rax
	movq	%rax, -8224(%rbp)
	movq	-8248(%rbp), %rax
	movq	%rax, -8216(%rbp)
	movl	$4, -8284(%rbp)
	jmp	.L10
.L11:
	movl	-8288(%rbp), %eax
	leal	1(%rax), %edx
	movl	%edx, -8288(%rbp)
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-8320(%rbp), %rax
	leaq	(%rdx,%rax), %rcx
	movl	-8284(%rbp), %eax
	leal	1(%rax), %edx
	movl	%edx, -8284(%rbp)
	movq	(%rcx), %rdx
	cltq
	movq	%rdx, -8240(%rbp,%rax,8)
.L10:
	movl	-8288(%rbp), %eax
	cmpl	-8308(%rbp), %eax
	jl	.L11
	movl	-8284(%rbp), %eax
	leal	1(%rax), %edx
	movl	%edx, -8284(%rbp)
	cltq
	movq	-8280(%rbp), %rdx
	movq	%rdx, -8240(%rbp,%rax,8)
	movl	-8284(%rbp), %eax
	cltq
	movq	$0, -8240(%rbp,%rax,8)
	movl	$1, -8288(%rbp)
	jmp	.L12
.L18:
	movl	-8288(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-8320(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	%rax, %rsi
	leaq	.LC3(%rip), %rax
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	je	.L24
	movl	-8288(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-8320(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	%rax, -8232(%rbp)
	movl	$0, -8284(%rbp)
	jmp	.L15
.L16:
	movl	-8284(%rbp), %eax
	cltq
	movq	-8240(%rbp,%rax,8), %rax
	movq	%rax, %rsi
	leaq	.LC6(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf@PLT
	addl	$1, -8284(%rbp)
.L15:
	movl	-8284(%rbp), %eax
	cltq
	movq	-8240(%rbp,%rax,8), %rax
	testq	%rax, %rax
	jne	.L16
	movl	$10, %edi
	call	putchar@PLT
	call	fork@PLT
	testl	%eax, %eax
	jne	.L17
	movl	-8288(%rbp), %edx
	leaq	-48(%rbp), %rax
	leaq	.LC7(%rip), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	sprintf@PLT
	leaq	-48(%rbp), %rax
	movl	$438, %esi
	movq	%rax, %rdi
	call	creat@PLT
	movl	$2, %edi
	call	close@PLT
	movl	$1, %edi
	call	dup@PLT
	movq	-8240(%rbp), %rax
	leaq	-8240(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	execvp@PLT
	movq	-8240(%rbp), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L17:
	addl	$1, -8288(%rbp)
.L12:
	movl	-8288(%rbp), %eax
	cmpl	-8308(%rbp), %eax
	jl	.L18
	jmp	.L14
.L24:
	nop
.L14:
	movl	$1, -8288(%rbp)
	jmp	.L19
.L22:
	movl	-8288(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-8320(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	%rax, %rsi
	leaq	.LC3(%rip), %rax
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	je	.L25
	movl	$0, %edi
	call	wait@PLT
	addl	$1, -8288(%rbp)
.L19:
	movl	-8288(%rbp), %eax
	cmpl	-8308(%rbp), %eax
	jl	.L22
	jmp	.L21
.L25:
	nop
.L21:
	leaq	.LC8(%rip), %rax
	movq	%rax, %rdi
	call	system@PLT
	movl	$1, %edi
	call	exit@PLT
	.cfi_endproc
.LFE8:
	.size	main, .-main
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
