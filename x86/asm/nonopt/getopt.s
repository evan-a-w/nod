	.file	"getopt.c"
	.text
	.section	.rodata
.LC0:
	.string	"%@%"
	.section	.data.rel.local,"aw"
	.align 8
	.type	id, @object
	.size	id, 8
id:
	.quad	.LC0
	.globl	myoptopt
	.bss
	.align 4
	.type	myoptopt, @object
	.size	myoptopt, 4
myoptopt:
	.zero	4
	.globl	myoptind
	.align 4
	.type	myoptind, @object
	.size	myoptind, 4
myoptind:
	.zero	4
	.globl	myoptarg
	.align 8
	.type	myoptarg, @object
	.size	myoptarg, 8
myoptarg:
	.zero	8
	.local	n
	.comm	n,4,4
	.section	.rodata
.LC1:
	.string	"getopt.c"
.LC2:
	.string	"av[optind][n]"
	.text
	.globl	mygetopt
	.type	mygetopt, @function
mygetopt:
.LFB8:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$48, %rsp
	movl	%edi, -20(%rbp)
	movq	%rsi, -32(%rbp)
	movq	%rdx, -40(%rbp)
	movl	myoptind(%rip), %eax
	testl	%eax, %eax
	jne	.L2
	movl	$1, myoptind(%rip)
	movl	$1, n(%rip)
.L2:
	movl	myoptind(%rip), %eax
	cmpl	%eax, -20(%rbp)
	jle	.L3
	movl	myoptind(%rip), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-32(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movzbl	(%rax), %eax
	cmpb	$45, %al
	jne	.L3
	movl	myoptind(%rip), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-32(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	addq	$1, %rax
	movzbl	(%rax), %eax
	testb	%al, %al
	jne	.L4
.L3:
	movl	$-1, %eax
	jmp	.L5
.L4:
	movl	myoptind(%rip), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-32(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rdx
	movl	n(%rip), %eax
	cltq
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	testb	%al, %al
	jne	.L6
	leaq	__PRETTY_FUNCTION__.0(%rip), %rax
	movq	%rax, %rcx
	movl	$48, %edx
	leaq	.LC1(%rip), %rax
	movq	%rax, %rsi
	leaq	.LC2(%rip), %rax
	movq	%rax, %rdi
	call	__assert_fail@PLT
.L6:
	movq	-40(%rbp), %rax
	movq	%rax, -8(%rbp)
	jmp	.L7
.L10:
	movq	-8(%rbp), %rax
	movzbl	(%rax), %edx
	movl	myoptind(%rip), %eax
	cltq
	leaq	0(,%rax,8), %rcx
	movq	-32(%rbp), %rax
	addq	%rcx, %rax
	movq	(%rax), %rcx
	movl	n(%rip), %eax
	cltq
	addq	%rcx, %rax
	movzbl	(%rax), %eax
	cmpb	%al, %dl
	je	.L22
	addq	$1, -8(%rbp)
.L7:
	movq	-8(%rbp), %rax
	movzbl	(%rax), %eax
	testb	%al, %al
	jne	.L10
	jmp	.L9
.L22:
	nop
.L9:
	movq	-8(%rbp), %rax
	movzbl	(%rax), %eax
	testb	%al, %al
	jne	.L11
	movl	myoptind(%rip), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-32(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rdx
	movl	n(%rip), %eax
	cltq
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	movsbl	%al, %eax
	movl	%eax, myoptopt(%rip)
	movl	$63, %eax
	jmp	.L5
.L11:
	movq	-8(%rbp), %rax
	addq	$1, %rax
	movzbl	(%rax), %eax
	cmpb	$58, %al
	je	.L12
	movq	-8(%rbp), %rax
	addq	$1, %rax
	movzbl	(%rax), %eax
	cmpb	$124, %al
	je	.L12
	movq	-8(%rbp), %rax
	addq	$1, %rax
	movzbl	(%rax), %eax
	cmpb	$59, %al
	je	.L12
	movl	myoptind(%rip), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-32(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rdx
	movl	n(%rip), %eax
	cltq
	addq	$1, %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	testb	%al, %al
	jne	.L13
	movl	myoptind(%rip), %eax
	addl	$1, %eax
	movl	%eax, myoptind(%rip)
	movl	$1, n(%rip)
	jmp	.L14
.L13:
	movl	n(%rip), %eax
	addl	$1, %eax
	movl	%eax, n(%rip)
.L14:
	movq	-8(%rbp), %rax
	movzbl	(%rax), %eax
	movsbl	%al, %eax
	jmp	.L5
.L12:
	movl	myoptind(%rip), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-32(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rdx
	movl	n(%rip), %eax
	cltq
	addq	$1, %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	testb	%al, %al
	je	.L15
	movl	myoptind(%rip), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-32(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rdx
	movl	n(%rip), %eax
	cltq
	addq	$1, %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	testb	%al, %al
	je	.L16
	movl	myoptind(%rip), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-32(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rdx
	movl	n(%rip), %eax
	cltq
	addq	$1, %rax
	addq	%rdx, %rax
	movq	%rax, myoptarg(%rip)
	jmp	.L17
.L16:
	movq	$0, myoptarg(%rip)
.L17:
	movl	myoptind(%rip), %eax
	addl	$1, %eax
	movl	%eax, myoptind(%rip)
	movl	$1, n(%rip)
	movq	-8(%rbp), %rax
	movzbl	(%rax), %eax
	movsbl	%al, %eax
	jmp	.L5
.L15:
	movq	-8(%rbp), %rax
	addq	$1, %rax
	movzbl	(%rax), %eax
	cmpb	$124, %al
	jne	.L18
	movq	$0, myoptarg(%rip)
	movl	myoptind(%rip), %eax
	addl	$1, %eax
	movl	%eax, myoptind(%rip)
	movl	$1, n(%rip)
	movq	-8(%rbp), %rax
	movzbl	(%rax), %eax
	movsbl	%al, %eax
	jmp	.L5
.L18:
	movq	-8(%rbp), %rax
	addq	$1, %rax
	movzbl	(%rax), %eax
	cmpb	$59, %al
	jne	.L19
	movq	$0, myoptarg(%rip)
	movl	myoptind(%rip), %eax
	addl	$1, %eax
	movl	%eax, myoptind(%rip)
	movq	-8(%rbp), %rax
	movzbl	(%rax), %eax
	movsbl	%al, %eax
	movl	%eax, myoptopt(%rip)
	movl	$63, %eax
	jmp	.L5
.L19:
	movl	myoptind(%rip), %eax
	addl	$1, %eax
	cmpl	%eax, -20(%rbp)
	je	.L20
	movl	myoptind(%rip), %eax
	cltq
	addq	$1, %rax
	leaq	0(,%rax,8), %rdx
	movq	-32(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movzbl	(%rax), %eax
	cmpb	$45, %al
	jne	.L21
.L20:
	movl	myoptind(%rip), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-32(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rdx
	movl	n(%rip), %eax
	cltq
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	movsbl	%al, %eax
	movl	%eax, myoptopt(%rip)
	movl	$63, %eax
	jmp	.L5
.L21:
	movl	myoptind(%rip), %eax
	cltq
	addq	$1, %rax
	leaq	0(,%rax,8), %rdx
	movq	-32(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	%rax, myoptarg(%rip)
	movl	myoptind(%rip), %eax
	addl	$2, %eax
	movl	%eax, myoptind(%rip)
	movl	$1, n(%rip)
	movq	-8(%rbp), %rax
	movzbl	(%rax), %eax
	movsbl	%al, %eax
.L5:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE8:
	.size	mygetopt, .-mygetopt
	.section	.rodata
	.align 8
	.type	__PRETTY_FUNCTION__.0, @object
	.size	__PRETTY_FUNCTION__.0, 9
__PRETTY_FUNCTION__.0:
	.string	"mygetopt"
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
