	.file	"lib_tcp.c"
	.text
	.globl	tcp_done
	.type	tcp_done, @function
tcp_done:
.LFB73:
	.cfi_startproc
	endbr64
	testl	%edi, %edi
	jg	.L7
	movl	$0, %eax
	ret
.L7:
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	movslq	%edi, %rdi
	movl	$1, %esi
	call	pmap_unset@PLT
	movl	$0, %eax
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE73:
	.size	tcp_done, .-tcp_done
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"SO_REUSEADDR"
	.text
	.globl	sock_optimize
	.type	sock_optimize, @function
sock_optimize:
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
	movl	%edi, %ebx
	movl	%esi, %ebp
	movq	%fs:40, %rax
	movq	%rax, 8(%rsp)
	xorl	%eax, %eax
	testb	$1, %sil
	jne	.L18
.L10:
	testb	$2, %bpl
	jne	.L19
.L13:
	testb	$8, %bpl
	jne	.L21
.L8:
	movq	8(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L22
	addq	$16, %rsp
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
	movl	4(%rsp), %eax
	sarl	%eax
.L9:
	movl	%eax, 4(%rsp)
	movl	$4, %r8d
	movq	%r12, %rcx
	movl	$8, %edx
	movl	$1, %esi
	movl	%ebx, %edi
	call	setsockopt@PLT
	testl	%eax, %eax
	jne	.L11
	jmp	.L10
.L18:
	movl	$1048576, %eax
	leaq	4(%rsp), %r12
	jmp	.L9
.L14:
	movl	4(%rsp), %eax
	sarl	%eax
.L12:
	movl	%eax, 4(%rsp)
	movl	$4, %r8d
	movq	%r12, %rcx
	movl	$7, %edx
	movl	$1, %esi
	movl	%ebx, %edi
	call	setsockopt@PLT
	testl	%eax, %eax
	jne	.L14
	jmp	.L13
.L19:
	movl	$1048576, %eax
	leaq	4(%rsp), %r12
	jmp	.L12
.L21:
	movl	$1, 4(%rsp)
	leaq	4(%rsp), %rcx
	movl	$4, %r8d
	movl	$2, %edx
	movl	$1, %esi
	movl	%ebx, %edi
	call	setsockopt@PLT
	cmpl	$-1, %eax
	jne	.L8
	leaq	.LC0(%rip), %rdi
	call	perror@PLT
	jmp	.L8
.L22:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE76:
	.size	sock_optimize, .-sock_optimize
	.section	.rodata.str1.1
.LC1:
	.string	"accept"
	.text
	.globl	tcp_accept
	.type	tcp_accept, @function
tcp_accept:
.LFB74:
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
	subq	$56, %rsp
	.cfi_def_cfa_offset 96
	movl	%edi, %ebp
	movl	%esi, %r13d
	movq	%fs:40, %rax
	movq	%rax, 40(%rsp)
	xorl	%eax, %eax
	movl	$16, 12(%rsp)
	movq	$0, 16(%rsp)
	movq	$0, 24(%rsp)
	leaq	12(%rsp), %r12
.L24:
	leaq	16(%rsp), %rsi
	movq	%r12, %rdx
	movl	%ebp, %edi
	call	accept@PLT
	movl	%eax, %ebx
	testl	%eax, %eax
	jns	.L25
	call	__errno_location@PLT
	cmpl	$4, (%rax)
	je	.L24
	leaq	.LC1(%rip), %rdi
	call	perror@PLT
	movl	$6, %edi
	call	exit@PLT
.L25:
	movl	%r13d, %esi
	movl	%eax, %edi
	call	sock_optimize
	movq	40(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L29
	movl	%ebx, %eax
	addq	$56, %rsp
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
.L29:
	.cfi_restore_state
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE74:
	.size	tcp_accept, .-tcp_accept
	.section	.rodata.str1.1
.LC2:
	.string	"socket"
.LC3:
	.string	"lib TCP: No port found"
.LC4:
	.string	"connect"
	.text
	.globl	tcp_connect
	.type	tcp_connect, @function
tcp_connect:
.LFB75:
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
	movq	%rdi, %r12
	movl	%esi, %r13d
	movl	%edx, %r14d
	movq	%fs:40, %rax
	movq	%rax, 24(%rsp)
	xorl	%eax, %eax
	movl	$6, %edx
	movl	$1, %esi
	movl	$2, %edi
	call	socket@PLT
	testl	%eax, %eax
	js	.L50
	movl	%eax, %ebx
	testb	$4, %r14b
	je	.L32
	cmpw	$0, port.6(%rip)
	je	.L51
.L33:
	movq	%rsp, %rbp
.L35:
	movzwl	port.6(%rip), %eax
	addl	$1, %eax
	movw	%ax, port.6(%rip)
	movq	$0, 0(%rbp)
	movq	$0, 8(%rbp)
	movw	$2, (%rsp)
	rolw	$8, %ax
	movw	%ax, 2(%rsp)
	movl	$16, %edx
	movq	%rbp, %rsi
	movl	%ebx, %edi
	call	bind@PLT
	cmpl	$-1, %eax
	je	.L35
.L32:
	movl	%r14d, %esi
	movl	%ebx, %edi
	call	sock_optimize
	cmpq	$0, h.5(%rip)
	je	.L36
	cmpq	%r12, save_host.4(%rip)
	je	.L52
.L36:
	movq	%r12, save_host.4(%rip)
	movslq	%r13d, %rbp
	movq	%rbp, save_prog.3(%rip)
	movq	%r12, %rdi
	call	gethostbyname@PLT
	movq	%rax, h.5(%rip)
	testq	%rax, %rax
	je	.L53
	movq	$0, s.2(%rip)
	movq	$0, 8+s.2(%rip)
	movw	$2, s.2(%rip)
	movslq	20(%rax), %rdx
	movq	24(%rax), %rax
	movl	$12, %ecx
	movq	(%rax), %rsi
	leaq	4+s.2(%rip), %rdi
	call	__memmove_chk@PLT
	testl	%r13d, %r13d
	jg	.L54
	movl	%r13d, %eax
	negl	%eax
	rolw	$8, %ax
	movw	%ax, 2+s.2(%rip)
.L37:
	movl	$16, %edx
	leaq	s.2(%rip), %rsi
	movl	%ebx, %edi
	call	connect@PLT
	testl	%eax, %eax
	js	.L55
	movl	$0, tries.0(%rip)
.L30:
	movq	24(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L56
	movl	%ebx, %eax
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
.L50:
	.cfi_restore_state
	leaq	.LC2(%rip), %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L51:
	call	getpid@PLT
	sall	$4, %eax
	leal	1024(%rax), %edx
	cmpw	$1023, %ax
	cmovbe	%edx, %eax
	movw	%ax, port.6(%rip)
	jmp	.L33
.L52:
	movslq	%r13d, %rax
	cmpq	save_prog.3(%rip), %rax
	jne	.L36
	jmp	.L37
.L53:
	movq	%r12, %rdi
	call	perror@PLT
	movl	$2, %edi
	call	exit@PLT
.L54:
	movl	$6, %ecx
	movl	$1, %edx
	movq	%rbp, %rsi
	leaq	s.2(%rip), %rdi
	call	pmap_getport@PLT
	testw	%ax, %ax
	je	.L57
	rolw	$8, %ax
	movw	%ax, 2+s.2(%rip)
	jmp	.L37
.L57:
	leaq	.LC3(%rip), %rdi
	call	perror@PLT
	movl	$3, %edi
	call	exit@PLT
.L55:
	call	__errno_location@PLT
	movl	(%rax), %eax
	cmpl	$104, %eax
	sete	%dl
	cmpl	$111, %eax
	sete	%cl
	orb	%cl, %dl
	jne	.L47
	cmpl	$11, %eax
	jne	.L42
.L47:
	movl	%ebx, %edi
	call	close@PLT
	movl	tries.0(%rip), %eax
	addl	$1, %eax
	movl	%eax, tries.0(%rip)
	cmpl	$10, %eax
	jg	.L46
	movl	%r14d, %edx
	movl	%r13d, %esi
	movq	%r12, %rdi
	call	tcp_connect
	movl	%eax, %ebx
	jmp	.L30
.L42:
	leaq	.LC4(%rip), %rdi
	call	perror@PLT
	movl	$4, %edi
	call	exit@PLT
.L46:
	movl	$-1, %ebx
	jmp	.L30
.L56:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE75:
	.size	tcp_connect, .-tcp_connect
	.section	.rodata.str1.1
.LC5:
	.string	"getsockname"
	.text
	.globl	sockport
	.type	sockport, @function
sockport:
.LFB77:
	.cfi_startproc
	endbr64
	subq	$56, %rsp
	.cfi_def_cfa_offset 64
	movq	%fs:40, %rax
	movq	%rax, 40(%rsp)
	xorl	%eax, %eax
	movl	$16, 12(%rsp)
	leaq	12(%rsp), %rdx
	leaq	16(%rsp), %rsi
	call	getsockname@PLT
	testl	%eax, %eax
	js	.L63
	movzwl	18(%rsp), %eax
	rolw	$8, %ax
	movzwl	%ax, %eax
.L58:
	movq	40(%rsp), %rdx
	subq	%fs:40, %rdx
	jne	.L64
	addq	$56, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	ret
.L63:
	.cfi_restore_state
	leaq	.LC5(%rip), %rdi
	call	perror@PLT
	movl	$-1, %eax
	jmp	.L58
.L64:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE77:
	.size	sockport, .-sockport
	.section	.rodata.str1.1
.LC6:
	.string	"bind"
.LC7:
	.string	"listen"
.LC8:
	.string	"pmap_set"
	.text
	.globl	tcp_server
	.type	tcp_server, @function
tcp_server:
.LFB72:
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
	subq	$32, %rsp
	.cfi_def_cfa_offset 64
	movl	%edi, %ebp
	movl	%esi, %r12d
	movq	%fs:40, %rax
	movq	%rax, 24(%rsp)
	xorl	%eax, %eax
	movl	$6, %edx
	movl	$1, %esi
	movl	$2, %edi
	call	socket@PLT
	testl	%eax, %eax
	js	.L73
	movl	%eax, %ebx
	movl	%r12d, %esi
	movl	%eax, %edi
	call	sock_optimize
	movq	$0, (%rsp)
	movq	$0, 8(%rsp)
	movw	$2, (%rsp)
	testl	%ebp, %ebp
	js	.L74
.L67:
	movq	%rsp, %rsi
	movl	$16, %edx
	movl	%ebx, %edi
	call	bind@PLT
	testl	%eax, %eax
	js	.L75
	movl	$100, %esi
	movl	%ebx, %edi
	call	listen@PLT
	testl	%eax, %eax
	js	.L76
	testl	%ebp, %ebp
	jg	.L77
.L65:
	movq	24(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L78
	movl	%ebx, %eax
	addq	$32, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 32
	popq	%rbx
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	ret
.L73:
	.cfi_restore_state
	leaq	.LC2(%rip), %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L74:
	movl	%ebp, %eax
	negl	%eax
	rolw	$8, %ax
	movw	%ax, 2(%rsp)
	jmp	.L67
.L75:
	leaq	.LC6(%rip), %rdi
	call	perror@PLT
	movl	$2, %edi
	call	exit@PLT
.L76:
	leaq	.LC7(%rip), %rdi
	call	perror@PLT
	movl	$4, %edi
	call	exit@PLT
.L77:
	movslq	%ebp, %rbp
	movl	$1, %esi
	movq	%rbp, %rdi
	call	pmap_unset@PLT
	movl	%ebx, %edi
	call	sockport
	movzwl	%ax, %ecx
	movl	$6, %edx
	movl	$1, %esi
	movq	%rbp, %rdi
	call	pmap_set@PLT
	testl	%eax, %eax
	jne	.L65
	leaq	.LC8(%rip), %rdi
	call	perror@PLT
	movl	$5, %edi
	call	exit@PLT
.L78:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE72:
	.size	tcp_server, .-tcp_server
	.local	tries.0
	.comm	tries.0,4,4
	.local	s.2
	.comm	s.2,16,16
	.local	save_prog.3
	.comm	save_prog.3,8,8
	.local	save_host.4
	.comm	save_host.4,8,8
	.local	h.5
	.comm	h.5,8,8
	.local	port.6
	.comm	port.6,2,2
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
