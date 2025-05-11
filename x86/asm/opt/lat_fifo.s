	.file	"lat_fifo.c"
	.text
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"(r) read/write on pipe"
	.text
	.globl	doit
	.type	doit, @function
doit:
.LFB75:
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
	subq	$24, %rsp
	.cfi_def_cfa_offset 64
	movq	%rdi, %rbx
	movq	%fs:40, %rax
	movq	%rax, 8(%rsp)
	xorl	%eax, %eax
	movl	516(%rsi), %r13d
	movl	520(%rsi), %r12d
	leaq	7(%rsp), %rbp
.L2:
	testq	%rbx, %rbx
	je	.L8
	movl	$1, %edx
	movq	%rbp, %rsi
	movl	%r13d, %edi
	call	write@PLT
	cmpq	$1, %rax
	jne	.L3
	movl	$1, %edx
	movq	%rbp, %rsi
	movl	%r12d, %edi
	call	read@PLT
	subq	$1, %rbx
	cmpq	$1, %rax
	je	.L2
.L3:
	leaq	.LC0(%rip), %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L8:
	movq	8(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L9
	addq	$24, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 40
	popq	%rbx
	.cfi_def_cfa_offset 32
	popq	%rbp
	.cfi_def_cfa_offset 24
	popq	%r12
	.cfi_def_cfa_offset 16
	popq	%r13
	.cfi_def_cfa_offset 8
	ret
.L9:
	.cfi_restore_state
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE75:
	.size	doit, .-doit
	.globl	cleanup
	.type	cleanup, @function
cleanup:
.LFB74:
	.cfi_startproc
	endbr64
	testq	%rdi, %rdi
	je	.L16
	ret
.L16:
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movq	%rsi, %rbx
	movq	%rsi, %rdi
	call	unlink@PLT
	leaq	256(%rbx), %rdi
	call	unlink@PLT
	movl	516(%rbx), %edi
	call	close@PLT
	movl	520(%rbx), %edi
	call	close@PLT
	movl	512(%rbx), %edi
	testl	%edi, %edi
	jg	.L17
.L10:
	popq	%rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	ret
.L17:
	.cfi_restore_state
	movl	$15, %esi
	call	kill@PLT
	movl	512(%rbx), %edi
	movl	$0, %edx
	movl	$0, %esi
	call	waitpid@PLT
	movl	$0, 512(%rbx)
	jmp	.L10
	.cfi_endproc
.LFE74:
	.size	cleanup, .-cleanup
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC1:
	.string	"[-P <parallelism>] [-W <warmup>] [-N <repetitions>]\n"
	.section	.rodata.str1.1
.LC2:
	.string	"P:W:N:"
.LC3:
	.string	"Fifo latency"
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
	subq	$568, %rsp
	.cfi_def_cfa_offset 624
	movl	%edi, %ebx
	movq	%rsi, %rbp
	movq	%fs:40, %rax
	movq	%rax, 552(%rsp)
	xorl	%eax, %eax
	movl	$-1, %r14d
	movl	$0, %r13d
	movl	$1, 12(%rsp)
	leaq	.LC2(%rip), %r12
	leaq	.LC1(%rip), %r15
	jmp	.L19
.L20:
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	movl	%eax, 12(%rsp)
	testl	%eax, %eax
	jg	.L19
	movq	%r15, %rdx
	movq	%rbp, %rsi
	movl	%ebx, %edi
	call	lmbench_usage@PLT
	jmp	.L19
.L21:
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	movl	%eax, %r13d
.L19:
	movq	%r12, %rdx
	movq	%rbp, %rsi
	movl	%ebx, %edi
	call	mygetopt@PLT
	cmpl	$-1, %eax
	je	.L30
	cmpl	$80, %eax
	je	.L20
	cmpl	$87, %eax
	je	.L21
	cmpl	$78, %eax
	je	.L31
	movq	%r15, %rdx
	movq	%rbp, %rsi
	movl	%ebx, %edi
	call	lmbench_usage@PLT
	jmp	.L19
.L31:
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	movl	%eax, %r14d
	jmp	.L19
.L30:
	cmpl	%ebx, myoptind(%rip)
	jl	.L32
.L26:
	movl	$0, 528(%rsp)
	leaq	16(%rsp), %rax
	pushq	%rax
	.cfi_def_cfa_offset 632
	pushq	%r14
	.cfi_def_cfa_offset 640
	movl	%r13d, %r9d
	movl	28(%rsp), %r8d
	movl	$1000000, %ecx
	leaq	cleanup(%rip), %rdx
	leaq	doit(%rip), %rsi
	leaq	initialize(%rip), %rdi
	call	benchmp@PLT
	call	get_n@PLT
	movq	%rax, %rsi
	leaq	.LC3(%rip), %rdi
	call	micro@PLT
	addq	$16, %rsp
	.cfi_def_cfa_offset 624
	movq	552(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L33
	movl	$0, %eax
	addq	$568, %rsp
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
.L32:
	.cfi_restore_state
	leaq	.LC1(%rip), %rdx
	movq	%rbp, %rsi
	movl	%ebx, %edi
	call	lmbench_usage@PLT
	jmp	.L26
.L33:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE72:
	.size	main, .-main
	.section	.rodata.str1.1
.LC4:
	.string	"(w) read/write on pipe"
	.text
	.globl	writer
	.type	writer, @function
writer:
.LFB76:
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
	subq	$16, %rsp
	.cfi_def_cfa_offset 48
	movl	%edi, %r12d
	movl	%esi, %ebx
	movq	%fs:40, %rax
	movq	%rax, 8(%rsp)
	xorl	%eax, %eax
	leaq	.LC4(%rip), %rbp
	jmp	.L35
.L36:
	movq	%rbp, %rdi
	call	perror@PLT
.L35:
	leaq	7(%rsp), %rsi
	movl	$1, %edx
	movl	%ebx, %edi
	call	read@PLT
	cmpq	$1, %rax
	jne	.L36
	leaq	7(%rsp), %rsi
	movl	$1, %edx
	movl	%r12d, %edi
	call	write@PLT
	cmpq	$1, %rax
	jne	.L36
	jmp	.L35
	.cfi_endproc
.LFE76:
	.size	writer, .-writer
	.section	.rodata.str1.1
.LC5:
	.string	"/tmp/lmbench_f1.%d"
.LC6:
	.string	"/tmp/lmbench_f2.%d"
.LC7:
	.string	"mknod"
.LC8:
	.string	"fork"
.LC9:
	.string	"(i) read/write on pipe"
	.text
	.globl	initialize
	.type	initialize, @function
initialize:
.LFB73:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushq	%rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	subq	$24, %rsp
	.cfi_def_cfa_offset 48
	movq	%fs:40, %rax
	movq	%rax, 8(%rsp)
	xorl	%eax, %eax
	testq	%rdi, %rdi
	je	.L50
.L40:
	movq	8(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L51
	addq	$24, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
.L50:
	.cfi_restore_state
	movq	%rsi, %rbx
	movl	$0, 512(%rsi)
	call	getpid@PLT
	movl	%eax, %r8d
	leaq	.LC5(%rip), %rcx
	movl	$256, %edx
	movl	$1, %esi
	movq	%rbx, %rdi
	movl	$0, %eax
	call	__sprintf_chk@PLT
	call	getpid@PLT
	movl	%eax, %r8d
	leaq	256(%rbx), %rbp
	leaq	.LC6(%rip), %rcx
	movl	$256, %edx
	movl	$1, %esi
	movq	%rbp, %rdi
	movl	$0, %eax
	call	__sprintf_chk@PLT
	movq	%rbx, %rdi
	call	unlink@PLT
	movq	%rbp, %rdi
	call	unlink@PLT
	movl	$0, %edx
	movl	$4532, %esi
	movq	%rbx, %rdi
	call	mknod@PLT
	testl	%eax, %eax
	jne	.L42
	movl	$0, %edx
	movl	$4532, %esi
	movq	%rbp, %rdi
	call	mknod@PLT
	testl	%eax, %eax
	jne	.L42
	movl	$0, %eax
	call	benchmp_childid@PLT
	movl	%eax, %edi
	movl	$1, %edx
	movl	$0, %esi
	call	handle_scheduler@PLT
	call	fork@PLT
	movl	%eax, 512(%rbx)
	cmpl	$-1, %eax
	je	.L44
	testl	%eax, %eax
	je	.L52
	movl	$1, %esi
	movq	%rbx, %rdi
	movl	$0, %eax
	call	open@PLT
	movl	%eax, 516(%rbx)
	movl	$0, %esi
	movq	%rbp, %rdi
	movl	$0, %eax
	call	open@PLT
	movl	%eax, 520(%rbx)
	leaq	7(%rsp), %rsi
	movl	516(%rbx), %edi
	movl	$1, %edx
	call	write@PLT
	cmpq	$1, %rax
	jne	.L46
	leaq	7(%rsp), %rsi
	movl	520(%rbx), %edi
	movl	$1, %edx
	call	read@PLT
	cmpq	$1, %rax
	je	.L40
.L46:
	leaq	.LC9(%rip), %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L42:
	leaq	.LC7(%rip), %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L52:
	call	benchmp_childid@PLT
	movl	%eax, %edi
	movl	$1, %edx
	movl	$1, %esi
	call	handle_scheduler@PLT
	movl	$0, %esi
	movq	%rbx, %rdi
	movl	$0, %eax
	call	open@PLT
	movl	%eax, 520(%rbx)
	movl	$1, %esi
	movq	%rbp, %rdi
	movl	$0, %eax
	call	open@PLT
	movl	%eax, %edi
	movl	%eax, 516(%rbx)
	movl	520(%rbx), %esi
	call	writer
.L44:
	leaq	.LC8(%rip), %rdi
	call	perror@PLT
	jmp	.L40
.L51:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE73:
	.size	initialize, .-initialize
	.globl	id
	.section	.rodata.str1.1
.LC10:
	.string	"$Id$\n"
	.section	.data.rel.local,"aw"
	.align 8
	.type	id, @object
	.size	id, 8
id:
	.quad	.LC10
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
