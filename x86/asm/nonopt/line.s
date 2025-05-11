	.file	"line.c"
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
	.string	"[-v] [-W <warmup>] [-N <repetitions>][-M len[K|M]]\n"
.LC2:
	.string	"avM:W:N:"
.LC3:
	.string	"cache line size: %d bytes\n"
.LC4:
	.string	"%d\n"
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
	subq	$304, %rsp
	movl	%edi, -292(%rbp)
	movq	%rsi, -304(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movl	$0, -276(%rbp)
	movl	$0, -272(%rbp)
	movl	$0, %edi
	call	get_enough@PLT
	cmpl	$999999, %eax
	jle	.L2
	movl	$1, %eax
	jmp	.L3
.L2:
	movl	$11, %eax
.L3:
	movl	%eax, -268(%rbp)
	movq	$67108864, -256(%rbp)
	leaq	.LC1(%rip), %rax
	movq	%rax, -248(%rbp)
	movq	$8, -72(%rbp)
	call	getpagesize@PLT
	cltq
	movq	%rax, -64(%rbp)
	jmp	.L4
.L10:
	cmpl	$118, -264(%rbp)
	je	.L5
	cmpl	$118, -264(%rbp)
	jg	.L6
	cmpl	$87, -264(%rbp)
	je	.L7
	cmpl	$87, -264(%rbp)
	jg	.L6
	cmpl	$77, -264(%rbp)
	je	.L8
	cmpl	$78, -264(%rbp)
	je	.L9
	jmp	.L6
.L5:
	movl	$1, -276(%rbp)
	jmp	.L4
.L8:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	bytes@PLT
	movq	%rax, -256(%rbp)
	jmp	.L4
.L7:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -272(%rbp)
	jmp	.L4
.L9:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -268(%rbp)
	jmp	.L4
.L6:
	movq	-248(%rbp), %rdx
	movq	-304(%rbp), %rcx
	movl	-292(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	lmbench_usage@PLT
	nop
.L4:
	movq	-304(%rbp), %rcx
	movl	-292(%rbp), %eax
	leaq	.LC2(%rip), %rdx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	mygetopt@PLT
	movl	%eax, -264(%rbp)
	cmpl	$-1, -264(%rbp)
	jne	.L10
	leaq	-240(%rbp), %rcx
	movl	-268(%rbp), %edx
	movl	-272(%rbp), %esi
	movq	-256(%rbp), %rax
	movq	%rax, %rdi
	call	line_find@PLT
	movl	%eax, -260(%rbp)
	cmpl	$0, -260(%rbp)
	jle	.L11
	cmpl	$0, -276(%rbp)
	je	.L12
	movl	-260(%rbp), %eax
	movl	%eax, %esi
	leaq	.LC3(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf@PLT
	jmp	.L11
.L12:
	movl	-260(%rbp), %eax
	movl	%eax, %esi
	leaq	.LC4(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf@PLT
.L11:
	movl	$0, %eax
	movq	-8(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L14
	call	__stack_chk_fail@PLT
.L14:
	leave
	.cfi_def_cfa 7, 8
	ret
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
