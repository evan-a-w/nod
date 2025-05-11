	.file	"clock.c"
	.text
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"ENOUGH=%lu\n"
.LC1:
	.string	"TIMING_OVERHEAD=%f\n"
.LC2:
	.string	"LOOP_OVERHEAD=%f\n"
.LC3:
	.string	"# version [%s]\n"
	.text
	.globl	main
	.type	main, @function
main:
.LFB72:
	.cfi_startproc
	endbr64
	pushq	%r14
	.cfi_def_cfa_offset 16
	.cfi_offset 14, -16
	pushq	%rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	subq	$8, %rsp
	.cfi_def_cfa_offset 32
	movl	$15, %edi
	movl	$0, %eax
	call	compute_enough@PLT
	movslq	%eax, %rbx
	movq	%rbx, %rdx
	leaq	.LC0(%rip), %rsi
	movl	$1, %edi
	movl	$0, %eax
	call	__printf_chk@PLT
	movq	stdout(%rip), %rdi
	call	fflush@PLT
	movq	%rbx, %rdi
	movl	$0, %eax
	call	timing_overhead@PLT
	pxor	%xmm1, %xmm1
	cvtsi2sdl	%eax, %xmm1
	movq	%xmm1, %r14
	movapd	%xmm1, %xmm0
	leaq	.LC1(%rip), %rsi
	movl	$1, %edi
	movl	$1, %eax
	call	__printf_chk@PLT
	movq	stdout(%rip), %rdi
	call	fflush@PLT
	movq	%r14, %xmm0
	movq	%rbx, %rdi
	movl	$1, %eax
	call	loop_overhead@PLT
	pxor	%xmm0, %xmm0
	cvtsi2sdl	%eax, %xmm0
	leaq	.LC2(%rip), %rsi
	movl	$1, %edi
	movl	$1, %eax
	call	__printf_chk@PLT
	movq	revision(%rip), %rdx
	leaq	.LC3(%rip), %rsi
	movl	$1, %edi
	movl	$0, %eax
	call	__printf_chk@PLT
	movl	$0, %edi
	call	exit@PLT
	.cfi_endproc
.LFE72:
	.size	main, .-main
	.globl	revision
	.section	.rodata.str1.1
.LC4:
	.string	"$Revision$"
	.section	.data.rel.local,"aw"
	.align 8
	.type	revision, @object
	.size	revision, 8
revision:
	.quad	.LC4
	.globl	id
	.section	.rodata.str1.1
.LC5:
	.string	"$Id$"
	.section	.data.rel.local
	.align 8
	.type	id, @object
	.size	id, 8
id:
	.quad	.LC5
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
