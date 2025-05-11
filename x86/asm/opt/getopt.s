	.file	"getopt.c"
	.text
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"getopt.c"
.LC1:
	.string	"av[optind][n]"
	.text
	.globl	mygetopt
	.type	mygetopt, @function
mygetopt:
.LFB72:
	.cfi_startproc
	endbr64
	movl	%edi, %r10d
	movq	%rsi, %r11
	movq	%rdx, %rax
	cmpl	$0, myoptind(%rip)
	jne	.L2
	movl	$1, myoptind(%rip)
	movl	$1, n(%rip)
.L2:
	movl	myoptind(%rip), %esi
	cmpl	%r10d, %esi
	jge	.L17
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushq	%rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	subq	$8, %rsp
	.cfi_def_cfa_offset 32
	movslq	%esi, %rdx
	leaq	0(,%rdx,8), %rbp
	movq	(%r11,%rdx,8), %rdi
	cmpb	$45, (%rdi)
	jne	.L18
	cmpb	$0, 1(%rdi)
	je	.L19
	movl	n(%rip), %r9d
	movslq	%r9d, %r8
	movzbl	(%rdi,%r8), %ecx
	testb	%cl, %cl
	je	.L4
	movzbl	(%rax), %edx
	cmpb	%dl, %cl
	je	.L5
	testb	%dl, %dl
	je	.L5
.L6:
	addq	$1, %rax
	movzbl	(%rax), %edx
	cmpb	%dl, %cl
	je	.L5
	testb	%dl, %dl
	jne	.L6
.L5:
	testb	%dl, %dl
	je	.L25
	movzbl	1(%rax), %edx
	leal	-58(%rdx), %ebx
	cmpb	$1, %bl
	jbe	.L9
	cmpb	$124, %dl
	jne	.L26
.L9:
	leaq	1(%rdi,%r8), %rdi
	cmpb	$0, (%rdi)
	jne	.L27
	cmpb	$124, %dl
	je	.L28
	cmpb	$59, %dl
	je	.L29
	leal	1(%rsi), %edx
	cmpl	%r10d, %edx
	je	.L15
	movq	8(%r11,%rbp), %rdx
	cmpb	$45, (%rdx)
	je	.L15
	movq	%rdx, myoptarg(%rip)
	addl	$2, %esi
	movl	%esi, myoptind(%rip)
	movl	$1, n(%rip)
	movsbl	(%rax), %eax
	jmp	.L1
.L4:
	leaq	__PRETTY_FUNCTION__.0(%rip), %rcx
	movl	$48, %edx
	leaq	.LC0(%rip), %rsi
	leaq	.LC1(%rip), %rdi
	call	__assert_fail@PLT
.L25:
	movsbl	%cl, %ecx
	movl	%ecx, myoptopt(%rip)
	movl	$63, %eax
.L1:
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
.L26:
	.cfi_restore_state
	addl	$1, %r9d
	cmpb	$0, 1(%rdi,%r8)
	jne	.L11
	addl	$1, %esi
	movl	%esi, myoptind(%rip)
	movl	$1, %r9d
.L11:
	movl	%r9d, n(%rip)
	movsbl	(%rax), %eax
	jmp	.L1
.L27:
	movq	%rdi, myoptarg(%rip)
	addl	$1, %esi
	movl	%esi, myoptind(%rip)
	movl	$1, n(%rip)
	movsbl	(%rax), %eax
	jmp	.L1
.L28:
	movq	$0, myoptarg(%rip)
	addl	$1, %esi
	movl	%esi, myoptind(%rip)
	movl	$1, n(%rip)
	movsbl	(%rax), %eax
	jmp	.L1
.L29:
	movq	$0, myoptarg(%rip)
	addl	$1, %esi
	movl	%esi, myoptind(%rip)
	movsbl	(%rax), %eax
	movl	%eax, myoptopt(%rip)
	movl	$63, %eax
	jmp	.L1
.L15:
	movsbl	%cl, %ecx
	movl	%ecx, myoptopt(%rip)
	movl	$63, %eax
	jmp	.L1
.L17:
	.cfi_def_cfa_offset 8
	.cfi_restore 3
	.cfi_restore 6
	movl	$-1, %eax
	ret
.L18:
	.cfi_def_cfa_offset 32
	.cfi_offset 3, -24
	.cfi_offset 6, -16
	movl	$-1, %eax
	jmp	.L1
.L19:
	movl	$-1, %eax
	jmp	.L1
	.cfi_endproc
.LFE72:
	.size	mygetopt, .-mygetopt
	.section	.rodata
	.align 8
	.type	__PRETTY_FUNCTION__.0, @object
	.size	__PRETTY_FUNCTION__.0, 9
__PRETTY_FUNCTION__.0:
	.string	"mygetopt"
	.local	n
	.comm	n,4,4
	.globl	myoptarg
	.bss
	.align 8
	.type	myoptarg, @object
	.size	myoptarg, 8
myoptarg:
	.zero	8
	.globl	myoptind
	.align 4
	.type	myoptind, @object
	.size	myoptind, 4
myoptind:
	.zero	4
	.globl	myoptopt
	.align 4
	.type	myoptopt, @object
	.size	myoptopt, 4
myoptopt:
	.zero	4
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
