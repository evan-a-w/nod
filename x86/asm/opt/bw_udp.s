	.file	"bw_udp.c"
	.text
	.globl	init
	.type	init, @function
init:
.LFB73:
	.cfi_startproc
	endbr64
	testq	%rdi, %rdi
	je	.L7
	ret
.L7:
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movq	%rsi, %rbx
	movq	24(%rsi), %rdi
	movl	$0, %edx
	movq	$-31238, %rsi
	call	udp_connect@PLT
	movl	%eax, (%rbx)
	movl	$0, 4(%rbx)
	movq	16(%rbx), %rdi
	call	malloc@PLT
	movq	%rax, 40(%rbx)
	popq	%rbx
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE73:
	.size	init, .-init
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"bw_udp client: send failed"
.LC1:
	.string	"bw_udp client: recv failed"
	.text
	.globl	loop_transfer
	.type	loop_transfer, @function
loop_transfer:
.LFB74:
	.cfi_startproc
	endbr64
	pushq	%r14
	.cfi_def_cfa_offset 16
	.cfi_offset 14, -16
	pushq	%r13
	.cfi_def_cfa_offset 24
	.cfi_offset 13, -24
	pushq	%r12
	.cfi_def_cfa_offset 32
	.cfi_offset 12, -32
	pushq	%rbp
	.cfi_def_cfa_offset 40
	.cfi_offset 6, -40
	pushq	%rbx
	.cfi_def_cfa_offset 48
	.cfi_offset 3, -48
	subq	$32, %rsp
	.cfi_def_cfa_offset 80
	movq	%fs:40, %rax
	movq	%rax, 24(%rsp)
	xorl	%eax, %eax
	movl	(%rsi), %r12d
	movq	8(%rsi), %rbx
	movq	%rbx, (%rsp)
	movq	16(%rsi), %rax
	movq	%rax, 8(%rsp)
	testq	%rdi, %rdi
	je	.L8
	movq	%rsi, %rbp
	leaq	-1(%rdi), %r13
	movq	%rsp, %r14
	jmp	.L14
.L10:
	leaq	.LC0(%rip), %rdi
	call	perror@PLT
	movl	$5, %edi
	call	exit@PLT
.L20:
	leaq	.LC1(%rip), %rdi
	call	perror@PLT
	movl	$5, %edi
	call	exit@PLT
.L12:
	subq	$1, %r13
	cmpq	$-1, %r13
	je	.L8
.L14:
	movl	$0, %ecx
	movl	$16, %edx
	movq	%r14, %rsi
	movl	%r12d, %edi
	call	send@PLT
	cmpq	$16, %rax
	jne	.L10
	testq	%rbx, %rbx
	jle	.L12
.L11:
	movq	16(%rbp), %rdx
	movq	40(%rbp), %rsi
	movl	$0, %ecx
	movl	%r12d, %edi
	call	recv@PLT
	movq	%rax, %rdx
	movq	16(%rbp), %rax
	cmpq	%rdx, %rax
	jne	.L20
	subq	%rax, %rbx
	testq	%rbx, %rbx
	jg	.L11
	jmp	.L12
.L8:
	movq	24(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L21
	addq	$32, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 48
	popq	%rbx
	.cfi_def_cfa_offset 40
	popq	%rbp
	.cfi_def_cfa_offset 32
	popq	%r12
	.cfi_def_cfa_offset 24
	popq	%r13
	.cfi_def_cfa_offset 16
	popq	%r14
	.cfi_def_cfa_offset 8
	ret
.L21:
	.cfi_restore_state
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE74:
	.size	loop_transfer, .-loop_transfer
	.globl	cleanup
	.type	cleanup, @function
cleanup:
.LFB75:
	.cfi_startproc
	endbr64
	testq	%rdi, %rdi
	je	.L28
	ret
.L28:
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movq	%rsi, %rbx
	movl	(%rsi), %edi
	call	close@PLT
	movq	40(%rbx), %rdi
	call	free@PLT
	popq	%rbx
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE75:
	.size	cleanup, .-cleanup
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC2:
	.string	"bw_udp server: recvfrom: got wrong size\n"
	.section	.rodata.str1.1
.LC3:
	.string	"bw_udp sendto"
	.text
	.globl	server_main
	.type	server_main, @function
server_main:
.LFB76:
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
	subq	$72, %rsp
	.cfi_def_cfa_offset 128
	movq	%fs:40, %rax
	movq	%rax, 56(%rsp)
	xorl	%eax, %eax
	movl	$10485760, %edi
	call	valloc@PLT
	movq	%rax, %rbp
	movq	exit@GOTPCREL(%rip), %rsi
	movl	$14, %edi
	call	signal@PLT
	movl	$3600, %edi
	call	alarm@PLT
	movl	$0, %esi
	movq	$-31238, %rdi
	call	udp_server@PLT
	movl	%eax, %r13d
	leaq	28(%rsp), %rax
	movq	%rax, 8(%rsp)
.L34:
	movl	$16, 28(%rsp)
	movq	8(%rsp), %r9
	leaq	32(%rsp), %r8
	movl	$0, %ecx
	movl	$16, %edx
	movq	%rbp, %rsi
	movl	%r13d, %edi
	call	recvfrom@PLT
	testq	%rax, %rax
	js	.L38
	movq	0(%rbp), %rbx
	bswap	%ebx
	movl	%ebx, %ebx
	movq	8(%rbp), %r12
	bswap	%r12d
	movl	%r12d, %r15d
	testq	%rbx, %rbx
	jle	.L34
	leaq	32(%rsp), %r14
.L33:
	movl	%r12d, %edx
	movl	$16, %r9d
	movq	%r14, %r8
	movl	$0, %ecx
	movq	%rbp, %rsi
	movl	%r13d, %edi
	call	sendto@PLT
	testq	%rax, %rax
	js	.L39
	subq	%r15, %rbx
	testq	%rbx, %rbx
	jg	.L33
	jmp	.L34
.L38:
	movq	stderr(%rip), %rcx
	movl	$40, %edx
	movl	$1, %esi
	leaq	.LC2(%rip), %rdi
	call	fwrite@PLT
	movl	$9, %edi
	call	exit@PLT
.L39:
	leaq	.LC3(%rip), %rdi
	call	perror@PLT
	movl	$9, %edi
	call	exit@PLT
	.cfi_endproc
.LFE76:
	.size	server_main, .-server_main
	.section	.rodata.str1.8
	.align 8
.LC4:
	.string	"-s\n OR [-m <message size>] [-W <warmup>] [-N <repetitions>] server [size]\n OR -S serverhost\n"
	.section	.rodata.str1.1
.LC5:
	.string	"sS:m:W:N:"
.LC6:
	.string	"valloc"
	.section	.rodata.str1.8
	.align 8
.LC7:
	.string	"socket UDP bandwidth using %s: "
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
	subq	$104, %rsp
	.cfi_def_cfa_offset 160
	movl	%edi, %ebx
	movq	%rsi, %rbp
	movq	%fs:40, %rax
	movq	%rax, 88(%rsp)
	xorl	%eax, %eax
	movq	$0, 48(%rsp)
	movq	$10485760, 40(%rsp)
	movl	$-1, %r14d
	movl	$0, 12(%rsp)
	leaq	.LC5(%rip), %r13
	leaq	.LC4(%rip), %r15
	leaq	.L44(%rip), %r12
.L41:
	movq	%r13, %rdx
	movq	%rbp, %rsi
	movl	%ebx, %edi
	call	mygetopt@PLT
	cmpl	$-1, %eax
	je	.L63
	subl	$78, %eax
	cmpl	$37, %eax
	ja	.L42
	movl	%eax, %eax
	movslq	(%r12,%rax,4), %rax
	addq	%r12, %rax
	notrack jmp	*%rax
	.section	.rodata
	.align 4
	.align 4
.L44:
	.long	.L48-.L44
	.long	.L42-.L44
	.long	.L42-.L44
	.long	.L42-.L44
	.long	.L42-.L44
	.long	.L47-.L44
	.long	.L42-.L44
	.long	.L42-.L44
	.long	.L42-.L44
	.long	.L46-.L44
	.long	.L42-.L44
	.long	.L42-.L44
	.long	.L42-.L44
	.long	.L42-.L44
	.long	.L42-.L44
	.long	.L42-.L44
	.long	.L42-.L44
	.long	.L42-.L44
	.long	.L42-.L44
	.long	.L42-.L44
	.long	.L42-.L44
	.long	.L42-.L44
	.long	.L42-.L44
	.long	.L42-.L44
	.long	.L42-.L44
	.long	.L42-.L44
	.long	.L42-.L44
	.long	.L42-.L44
	.long	.L42-.L44
	.long	.L42-.L44
	.long	.L42-.L44
	.long	.L45-.L44
	.long	.L42-.L44
	.long	.L42-.L44
	.long	.L42-.L44
	.long	.L42-.L44
	.long	.L42-.L44
	.long	.L43-.L44
	.text
.L43:
	call	fork@PLT
	testl	%eax, %eax
	je	.L64
	movl	$0, %edi
	call	exit@PLT
.L64:
	call	server_main
.L47:
	movl	$0, %edx
	movq	$-31238, %rsi
	movq	myoptarg(%rip), %rdi
	call	udp_connect@PLT
	movl	%eax, %ebp
	movl	$-1, %ebx
	leaq	28(%rsp), %r12
.L50:
	movl	%ebx, %eax
	bswap	%eax
	movl	%eax, 28(%rsp)
	movl	$0, %ecx
	movl	$4, %edx
	movq	%r12, %rsi
	movl	%ebp, %edi
	call	send@PLT
	subl	$1, %ebx
	cmpl	$-5, %ebx
	jne	.L50
	movl	%ebp, %edi
	call	close@PLT
	movl	$0, %edi
	call	exit@PLT
.L45:
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	cltq
	movq	%rax, 48(%rsp)
	jmp	.L41
.L46:
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	movl	%eax, 12(%rsp)
	jmp	.L41
.L48:
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	movl	%eax, %r14d
	jmp	.L41
.L42:
	movq	%r15, %rdx
	movq	%rbp, %rsi
	movl	%ebx, %edi
	call	lmbench_usage@PLT
	jmp	.L41
.L63:
	movl	myoptind(%rip), %eax
	leal	-2(%rbx), %edx
	cmpl	%eax, %edx
	jg	.L60
	cmpl	%ebx, %eax
	jl	.L53
.L60:
	leaq	.LC4(%rip), %rdx
	movq	%rbp, %rsi
	movl	%ebx, %edi
	call	lmbench_usage@PLT
.L53:
	movl	myoptind(%rip), %eax
	leal	1(%rax), %edx
	movl	%edx, myoptind(%rip)
	cltq
	leaq	0(,%rax,8), %rcx
	movq	0(%rbp,%rax,8), %rax
	movq	%rax, 56(%rsp)
	cmpl	%ebx, %edx
	jl	.L65
.L55:
	movq	48(%rsp), %rdi
	testq	%rdi, %rdi
	jne	.L56
	movq	40(%rsp), %rdi
	movq	%rdi, 48(%rsp)
.L57:
	call	valloc@PLT
	movq	%rax, %rdi
	movq	%rax, 72(%rsp)
	testq	%rax, %rax
	je	.L66
	movq	48(%rsp), %rsi
	call	touch@PLT
	leaq	32(%rsp), %rax
	pushq	%rax
	.cfi_def_cfa_offset 168
	pushq	%r14
	.cfi_def_cfa_offset 176
	movl	28(%rsp), %r9d
	movl	$1, %r8d
	movl	$7500000, %ecx
	leaq	cleanup(%rip), %rdx
	leaq	loop_transfer(%rip), %rsi
	leaq	init(%rip), %rdi
	call	benchmp@PLT
	movq	72(%rsp), %rcx
	leaq	.LC7(%rip), %rdx
	movl	$1, %esi
	movq	stderr(%rip), %rdi
	movl	$0, %eax
	call	__fprintf_chk@PLT
	movq	56(%rsp), %rbx
	call	get_n@PLT
	imulq	%rax, %rbx
	movq	%rbx, %rdi
	call	mb@PLT
	addq	$16, %rsp
	.cfi_def_cfa_offset 160
	movq	88(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L67
	movl	$0, %eax
	addq	$104, %rsp
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
.L65:
	.cfi_restore_state
	movq	8(%rbp,%rcx), %rdi
	call	bytes@PLT
	movq	%rax, 40(%rsp)
	jmp	.L55
.L56:
	movq	40(%rsp), %rcx
	movq	%rcx, %rax
	cqto
	idivq	%rdi
	testq	%rdx, %rdx
	je	.L57
	movq	%rcx, %rax
	subq	%rdx, %rax
	addq	%rcx, %rax
	movq	%rax, 40(%rsp)
	jmp	.L57
.L66:
	leaq	.LC6(%rip), %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L67:
	call	__stack_chk_fail@PLT
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
