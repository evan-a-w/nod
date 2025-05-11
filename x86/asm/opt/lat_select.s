	.file	"lat_select.c"
	.text
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"localhost"
	.text
	.globl	open_socket
	.type	open_socket, @function
open_socket:
.LFB74:
	.cfi_startproc
	endbr64
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	movl	$0, %edx
	movl	$-31233, %esi
	leaq	.LC0(%rip), %rdi
	call	tcp_connect@PLT
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE74:
	.size	open_socket, .-open_socket
	.globl	open_file
	.type	open_file, @function
open_file:
.LFB75:
	.cfi_startproc
	endbr64
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	movl	$0, %esi
	movl	$0, %eax
	call	open@PLT
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE75:
	.size	open_file, .-open_file
	.globl	doit
	.type	doit, @function
doit:
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
	subq	$144, %rsp
	.cfi_def_cfa_offset 176
	movq	%fs:40, %rax
	movq	%rax, 136(%rsp)
	xorl	%eax, %eax
	movq	$0, tv.0(%rip)
	movq	$0, 8+tv.0(%rip)
	testq	%rdi, %rdi
	je	.L5
	movq	%rsi, %rbx
	leaq	-1(%rdi), %rbp
	movq	%rsp, %r12
.L7:
	movdqu	56(%rbx), %xmm0
	movaps	%xmm0, (%rsp)
	movdqu	72(%rbx), %xmm1
	movaps	%xmm1, 16(%rsp)
	movdqu	88(%rbx), %xmm2
	movaps	%xmm2, 32(%rsp)
	movdqu	104(%rbx), %xmm3
	movaps	%xmm3, 48(%rsp)
	movdqu	120(%rbx), %xmm4
	movaps	%xmm4, 64(%rsp)
	movdqu	136(%rbx), %xmm5
	movaps	%xmm5, 80(%rsp)
	movdqu	152(%rbx), %xmm6
	movaps	%xmm6, 96(%rsp)
	movdqu	168(%rbx), %xmm7
	movaps	%xmm7, 112(%rsp)
	movl	44(%rbx), %edi
	leaq	tv.0(%rip), %r8
	movl	$0, %ecx
	movq	%r12, %rdx
	movl	$0, %esi
	call	select@PLT
	subq	$1, %rbp
	cmpq	$-1, %rbp
	jne	.L7
.L5:
	movq	136(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L11
	addq	$144, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 32
	popq	%rbx
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	ret
.L11:
	.cfi_restore_state
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE76:
	.size	doit, .-doit
	.section	.rodata.str1.1
.LC1:
	.string	"Could not open device"
	.text
	.globl	initialize
	.type	initialize, @function
initialize:
.LFB77:
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
	subq	$8, %rsp
	.cfi_def_cfa_offset 64
	movl	44(%rsi), %r14d
	testq	%rdi, %rdi
	jne	.L12
	movq	%rsi, %rbp
	movq	%rsi, %rdi
	call	*24(%rsi)
	movl	%eax, %r13d
	testl	%eax, %eax
	jle	.L25
	movl	$0, 48(%rbp)
	leaq	56(%rbp), %rax
	leaq	184(%rbp), %rdx
.L15:
	movq	$0, (%rax)
	addq	$8, %rax
	cmpq	%rdx, %rax
	jne	.L15
	testl	%r14d, %r14d
	jle	.L20
	movl	$0, %r12d
	movl	$1, %r15d
	jmp	.L18
.L25:
	leaq	.LC1(%rip), %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L17:
	movslq	%ebx, %rdi
	call	__fdelt_chk@PLT
	movq	%r15, %rdx
	movl	%ebx, %ecx
	salq	%cl, %rdx
	orq	%rdx, 56(%rbp,%rax,8)
	addl	$1, %r12d
	cmpl	%r12d, %r14d
	je	.L26
.L18:
	movl	%r13d, %edi
	call	dup@PLT
	movl	%eax, %ebx
	cmpl	$-1, %eax
	je	.L16
	cmpl	%eax, 48(%rbp)
	jge	.L17
	movl	%eax, 48(%rbp)
	jmp	.L17
.L20:
	movl	$0, %r12d
.L16:
	addl	$1, 48(%rbp)
	movl	%r13d, %edi
	call	close@PLT
	cmpl	%r12d, %r14d
	jne	.L27
.L12:
	addq	$8, %rsp
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
.L27:
	.cfi_restore_state
	movl	$1, %edi
	call	exit@PLT
.L26:
	addl	$1, 48(%rbp)
	movl	%r13d, %edi
	call	close@PLT
	jmp	.L12
	.cfi_endproc
.LFE77:
	.size	initialize, .-initialize
	.globl	cleanup
	.type	cleanup, @function
cleanup:
.LFB78:
	.cfi_startproc
	endbr64
	testq	%rdi, %rdi
	jne	.L37
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
	movq	%rdi, %rbx
	movq	%rsi, %rbp
	cmpl	$0, 48(%rsi)
	js	.L30
	movl	$1, %r13d
	jmp	.L32
.L31:
	addq	$1, %rbx
	cmpl	%ebx, 48(%rbp)
	jl	.L30
.L32:
	movq	%rbx, %rdi
	call	__fdelt_chk@PLT
	movq	%rax, %rdx
	movq	%r13, %rax
	movl	%ebx, %ecx
	salq	%cl, %rax
	andq	56(%rbp,%rdx,8), %rax
	je	.L31
	movl	%ebx, %edi
	call	close@PLT
	jmp	.L31
.L30:
	leaq	56(%rbp), %rax
	addq	$184, %rbp
.L33:
	movq	$0, (%rax)
	addq	$8, %rax
	cmpq	%rbp, %rax
	jne	.L33
	addq	$8, %rsp
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
.L37:
	.cfi_restore 3
	.cfi_restore 6
	.cfi_restore 12
	.cfi_restore 13
	ret
	.cfi_endproc
.LFE78:
	.size	cleanup, .-cleanup
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC2:
	.string	"lat_select: Could not create temp file %s"
	.align 8
.LC3:
	.string	"lat_select: Could not open tcp server socket"
	.align 8
.LC4:
	.string	"lat_select::server(): fork() failed"
	.text
	.globl	server
	.type	server, @function
server:
.LFB73:
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
	subq	$168, %rsp
	.cfi_def_cfa_offset 208
	movq	%rdi, %rbp
	movq	%fs:40, %rax
	movq	%rax, 152(%rsp)
	xorl	%eax, %eax
	call	getpid@PLT
	movl	%eax, %r12d
	movl	$0, 32(%rbp)
	leaq	open_file(%rip), %rax
	cmpq	%rax, 24(%rbp)
	je	.L51
	movl	$8, %esi
	movl	$-31233, %edi
	call	tcp_server@PLT
	movl	%eax, 36(%rbp)
	testl	%eax, %eax
	jle	.L52
	call	fork@PLT
	movl	%eax, 32(%rbp)
	cmpl	$-1, %eax
	je	.L45
	leaq	40(%rbp), %r13
	testl	%eax, %eax
	je	.L46
.L40:
	movq	152(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L53
	addq	$168, %rsp
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
.L51:
	.cfi_restore_state
	movabsq	$7308327841512579436, %rax
	movabsq	$6365935209750754403, %rdx
	movq	%rax, 0(%rbp)
	movq	%rdx, 8(%rbp)
	movb	$0, 16(%rbp)
	movq	%rbp, %rdi
	call	mkstemp@PLT
	movl	%eax, %edi
	movl	%eax, 40(%rbp)
	testl	%eax, %eax
	jle	.L54
	call	close@PLT
	jmp	.L40
.L54:
	movq	%rsp, %rbx
	movq	%rbp, %r8
	leaq	.LC2(%rip), %rcx
	movl	$148, %edx
	movl	$1, %esi
	movq	%rbx, %rdi
	movl	$0, %eax
	call	__sprintf_chk@PLT
	movq	%rbx, %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L52:
	leaq	.LC3(%rip), %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L47:
	movl	36(%rbp), %edi
	movl	$0, %esi
	call	tcp_accept@PLT
	movl	%eax, %ebx
	movl	$1, %edx
	movq	%r13, %rsi
	movl	%eax, %edi
	call	read@PLT
	movl	%ebx, %edi
	call	close@PLT
.L46:
	call	getppid@PLT
	cmpl	%r12d, %eax
	je	.L47
	movl	$0, %edi
	call	exit@PLT
.L45:
	leaq	.LC4(%rip), %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L53:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE73:
	.size	server, .-server
	.section	.rodata.str1.8
	.align 8
.LC5:
	.string	"[-n <#descriptors>] [-P <parallelism>] [-W <warmup>] [-N <repetitions>] file|tcp\n"
	.section	.rodata.str1.1
.LC6:
	.string	"P:W:N:n:"
.LC7:
	.string	"tcp"
.LC8:
	.string	"Select on %d tcp fd's"
.LC9:
	.string	"file"
.LC10:
	.string	"Select on %d fd's"
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
	subq	$488, %rsp
	.cfi_def_cfa_offset 544
	movl	%edi, %ebx
	movq	%rsi, %rbp
	movq	%fs:40, %rax
	movq	%rax, 472(%rsp)
	xorl	%eax, %eax
	call	morefds@PLT
	movl	$200, 60(%rsp)
	movl	$-1, %r14d
	movl	$0, %r13d
	movl	$1, 12(%rsp)
	leaq	.LC6(%rip), %r12
	leaq	.LC5(%rip), %r15
	jmp	.L56
.L58:
	cmpl	$110, %eax
	jne	.L61
	movq	myoptarg(%rip), %rdi
	call	bytes@PLT
	movl	%eax, 60(%rsp)
	jmp	.L56
.L57:
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	movl	%eax, %r13d
.L56:
	movq	%r12, %rdx
	movq	%rbp, %rsi
	movl	%ebx, %edi
	call	mygetopt@PLT
	cmpl	$-1, %eax
	je	.L71
	cmpl	$87, %eax
	je	.L57
	jg	.L58
	cmpl	$78, %eax
	je	.L59
	cmpl	$80, %eax
	jne	.L61
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	movl	%eax, 12(%rsp)
	testl	%eax, %eax
	jg	.L56
	movq	%r15, %rdx
	movq	%rbp, %rsi
	movl	%ebx, %edi
	call	lmbench_usage@PLT
	jmp	.L56
.L59:
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	movl	%eax, %r14d
	jmp	.L56
.L61:
	movq	%r15, %rdx
	movq	%rbp, %rsi
	movl	%ebx, %edi
	call	lmbench_usage@PLT
	jmp	.L56
.L71:
	movl	myoptind(%rip), %eax
	addl	$1, %eax
	cmpl	%ebx, %eax
	jne	.L72
.L65:
	movslq	myoptind(%rip), %rax
	movq	0(%rbp,%rax,8), %r12
	movq	%r12, %rsi
	leaq	.LC7(%rip), %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	je	.L73
	movq	%r12, %rsi
	leaq	.LC9(%rip), %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L68
	leaq	open_file(%rip), %rax
	movq	%rax, 40(%rsp)
	leaq	16(%rsp), %rbx
	movq	%rbx, %rdi
	call	server
	pushq	%rbx
	.cfi_def_cfa_offset 552
	pushq	%r14
	.cfi_def_cfa_offset 560
	movl	%r13d, %r9d
	movl	28(%rsp), %r8d
	movl	$0, %ecx
	leaq	cleanup(%rip), %rdx
	leaq	doit(%rip), %rsi
	leaq	initialize(%rip), %rdi
	call	benchmp@PLT
	movq	%rbx, %rdi
	call	unlink@PLT
	leaq	224(%rsp), %rbx
	movl	76(%rsp), %r8d
	leaq	.LC10(%rip), %rcx
	movl	$256, %edx
	movl	$1, %esi
	movq	%rbx, %rdi
	movl	$0, %eax
	call	__sprintf_chk@PLT
	call	get_n@PLT
	movq	%rax, %rsi
	movq	%rbx, %rdi
	call	micro@PLT
	addq	$16, %rsp
	.cfi_def_cfa_offset 544
.L67:
	movl	$0, %edi
	call	exit@PLT
.L72:
	leaq	.LC5(%rip), %rdx
	movq	%rbp, %rsi
	movl	%ebx, %edi
	call	lmbench_usage@PLT
	jmp	.L65
.L73:
	leaq	open_socket(%rip), %rax
	movq	%rax, 40(%rsp)
	leaq	16(%rsp), %rbx
	movq	%rbx, %rdi
	call	server
	pushq	%rbx
	.cfi_def_cfa_offset 552
	pushq	%r14
	.cfi_def_cfa_offset 560
	movl	%r13d, %r9d
	movl	28(%rsp), %r8d
	movl	$0, %ecx
	leaq	cleanup(%rip), %rdx
	leaq	doit(%rip), %rsi
	leaq	initialize(%rip), %rdi
	call	benchmp@PLT
	leaq	224(%rsp), %rbx
	movl	76(%rsp), %r8d
	leaq	.LC8(%rip), %rcx
	movl	$256, %edx
	movl	$1, %esi
	movq	%rbx, %rdi
	movl	$0, %eax
	call	__sprintf_chk@PLT
	movl	$9, %esi
	movl	64(%rsp), %edi
	call	kill@PLT
	movl	$0, %edx
	movl	$0, %esi
	movl	64(%rsp), %edi
	call	waitpid@PLT
	call	get_n@PLT
	movq	%rax, %rsi
	movq	%rbx, %rdi
	call	micro@PLT
	addq	$16, %rsp
	.cfi_def_cfa_offset 544
	jmp	.L67
.L68:
	leaq	.LC5(%rip), %rdx
	movq	%rbp, %rsi
	movl	%ebx, %edi
	call	lmbench_usage@PLT
	jmp	.L67
	.cfi_endproc
.LFE72:
	.size	main, .-main
	.local	tv.0
	.comm	tv.0,16,16
	.globl	id
	.section	.rodata.str1.1
.LC11:
	.string	"$Id$\n"
	.section	.data.rel.local,"aw"
	.align 8
	.type	id, @object
	.size	id, 8
id:
	.quad	.LC11
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
