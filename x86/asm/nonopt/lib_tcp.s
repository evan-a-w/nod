	.file	"lib_tcp.c"
	.text
	.section	.rodata
.LC0:
	.string	"socket"
.LC1:
	.string	"bind"
.LC2:
	.string	"listen"
.LC3:
	.string	"pmap_set"
	.text
	.globl	tcp_server
	.type	tcp_server, @function
tcp_server:
.LFB8:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$64, %rsp
	movl	%edi, -52(%rbp)
	movl	%esi, -56(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movl	$6, %edx
	movl	$1, %esi
	movl	$2, %edi
	call	socket@PLT
	movl	%eax, -36(%rbp)
	cmpl	$0, -36(%rbp)
	jns	.L2
	leaq	.LC0(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L2:
	movl	-56(%rbp), %edx
	movl	-36(%rbp), %eax
	movl	%edx, %esi
	movl	%eax, %edi
	call	sock_optimize
	leaq	-32(%rbp), %rax
	movq	$0, (%rax)
	movq	$0, 8(%rax)
	movw	$2, -32(%rbp)
	cmpl	$0, -52(%rbp)
	jns	.L3
	movl	-52(%rbp), %eax
	negl	%eax
	movzwl	%ax, %eax
	movl	%eax, %edi
	call	htons@PLT
	movw	%ax, -30(%rbp)
.L3:
	leaq	-32(%rbp), %rcx
	movl	-36(%rbp), %eax
	movl	$16, %edx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	bind@PLT
	testl	%eax, %eax
	jns	.L4
	leaq	.LC1(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$2, %edi
	call	exit@PLT
.L4:
	movl	-36(%rbp), %eax
	movl	$100, %esi
	movl	%eax, %edi
	call	listen@PLT
	testl	%eax, %eax
	jns	.L5
	leaq	.LC2(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$4, %edi
	call	exit@PLT
.L5:
	cmpl	$0, -52(%rbp)
	jle	.L6
	movl	-52(%rbp), %eax
	cltq
	movl	$1, %esi
	movq	%rax, %rdi
	call	pmap_unset@PLT
	movl	-36(%rbp), %eax
	movl	%eax, %edi
	call	sockport
	movzwl	%ax, %edx
	movl	-52(%rbp), %eax
	cltq
	movl	%edx, %ecx
	movl	$6, %edx
	movl	$1, %esi
	movq	%rax, %rdi
	call	pmap_set@PLT
	testl	%eax, %eax
	jne	.L6
	leaq	.LC3(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$5, %edi
	call	exit@PLT
.L6:
	movl	-36(%rbp), %eax
	movq	-8(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L8
	call	__stack_chk_fail@PLT
.L8:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE8:
	.size	tcp_server, .-tcp_server
	.globl	tcp_done
	.type	tcp_done, @function
tcp_done:
.LFB9:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movl	%edi, -4(%rbp)
	cmpl	$0, -4(%rbp)
	jle	.L10
	movl	-4(%rbp), %eax
	cltq
	movl	$1, %esi
	movq	%rax, %rdi
	call	pmap_unset@PLT
.L10:
	movl	$0, %eax
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE9:
	.size	tcp_done, .-tcp_done
	.section	.rodata
.LC4:
	.string	"accept"
	.text
	.globl	tcp_accept
	.type	tcp_accept, @function
tcp_accept:
.LFB10:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$64, %rsp
	movl	%edi, -52(%rbp)
	movl	%esi, -56(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movl	$16, -40(%rbp)
	movl	-40(%rbp), %eax
	movl	%eax, %edx
	leaq	-32(%rbp), %rax
	movl	$0, %esi
	movq	%rax, %rdi
	call	memset@PLT
.L13:
	leaq	-40(%rbp), %rdx
	leaq	-32(%rbp), %rcx
	movl	-52(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	accept@PLT
	movl	%eax, -36(%rbp)
	cmpl	$0, -36(%rbp)
	jns	.L14
	call	__errno_location@PLT
	movl	(%rax), %eax
	cmpl	$4, %eax
	jne	.L15
	jmp	.L13
.L15:
	leaq	.LC4(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$6, %edi
	call	exit@PLT
.L14:
	movl	-56(%rbp), %edx
	movl	-36(%rbp), %eax
	movl	%edx, %esi
	movl	%eax, %edi
	call	sock_optimize
	movl	-36(%rbp), %eax
	movq	-8(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L17
	call	__stack_chk_fail@PLT
.L17:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE10:
	.size	tcp_accept, .-tcp_accept
	.section	.rodata
.LC5:
	.string	"lib TCP: No port found"
.LC6:
	.string	"connect"
	.text
	.globl	tcp_connect
	.type	tcp_connect, @function
tcp_connect:
.LFB11:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$64, %rsp
	movq	%rdi, -56(%rbp)
	movl	%esi, -60(%rbp)
	movl	%edx, -64(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movl	$6, %edx
	movl	$1, %esi
	movl	$2, %edi
	call	socket@PLT
	movl	%eax, -36(%rbp)
	cmpl	$0, -36(%rbp)
	jns	.L19
	leaq	.LC0(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L19:
	movl	-64(%rbp), %eax
	andl	$4, %eax
	testl	%eax, %eax
	je	.L20
	movzwl	port.6(%rip), %eax
	testw	%ax, %ax
	jne	.L22
	call	getpid@PLT
	sall	$4, %eax
	movw	%ax, port.6(%rip)
	movzwl	port.6(%rip), %eax
	cmpw	$1023, %ax
	ja	.L22
	movzwl	port.6(%rip), %eax
	addw	$1024, %ax
	movw	%ax, port.6(%rip)
.L22:
	movzwl	port.6(%rip), %eax
	addl	$1, %eax
	movw	%ax, port.6(%rip)
	leaq	-32(%rbp), %rax
	movq	$0, (%rax)
	movq	$0, 8(%rax)
	movw	$2, -32(%rbp)
	movzwl	port.6(%rip), %eax
	movzwl	%ax, %eax
	movl	%eax, %edi
	call	htons@PLT
	movw	%ax, -30(%rbp)
	leaq	-32(%rbp), %rcx
	movl	-36(%rbp), %eax
	movl	$16, %edx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	bind@PLT
	cmpl	$-1, %eax
	je	.L22
.L20:
	movl	-64(%rbp), %edx
	movl	-36(%rbp), %eax
	movl	%edx, %esi
	movl	%eax, %edi
	call	sock_optimize
	movq	h.5(%rip), %rax
	testq	%rax, %rax
	je	.L23
	movq	save_host.4(%rip), %rax
	cmpq	%rax, -56(%rbp)
	jne	.L23
	movl	-60(%rbp), %eax
	movslq	%eax, %rdx
	movq	save_prog.3(%rip), %rax
	cmpq	%rax, %rdx
	je	.L24
.L23:
	movq	-56(%rbp), %rax
	movq	%rax, save_host.4(%rip)
	movl	-60(%rbp), %eax
	cltq
	movq	%rax, save_prog.3(%rip)
	movq	-56(%rbp), %rax
	movq	%rax, %rdi
	call	gethostbyname@PLT
	movq	%rax, h.5(%rip)
	movq	h.5(%rip), %rax
	testq	%rax, %rax
	jne	.L25
	movq	-56(%rbp), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$2, %edi
	call	exit@PLT
.L25:
	movq	$0, s.2(%rip)
	movq	$0, 8+s.2(%rip)
	movw	$2, s.2(%rip)
	movq	h.5(%rip), %rax
	movl	20(%rax), %eax
	movslq	%eax, %rdx
	movq	h.5(%rip), %rax
	movq	24(%rax), %rax
	movq	(%rax), %rax
	movq	%rax, %rsi
	leaq	4+s.2(%rip), %rax
	movq	%rax, %rdi
	call	memmove@PLT
	cmpl	$0, -60(%rbp)
	jle	.L26
	movl	-60(%rbp), %eax
	cltq
	movl	$6, %ecx
	movl	$1, %edx
	movq	%rax, %rsi
	leaq	s.2(%rip), %rax
	movq	%rax, %rdi
	call	pmap_getport@PLT
	movw	%ax, save_port.1(%rip)
	movzwl	save_port.1(%rip), %eax
	testw	%ax, %ax
	jne	.L27
	leaq	.LC5(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$3, %edi
	call	exit@PLT
.L27:
	movzwl	save_port.1(%rip), %eax
	movzwl	%ax, %eax
	movl	%eax, %edi
	call	htons@PLT
	movw	%ax, 2+s.2(%rip)
	jmp	.L24
.L26:
	movl	-60(%rbp), %eax
	negl	%eax
	movzwl	%ax, %eax
	movl	%eax, %edi
	call	htons@PLT
	movw	%ax, 2+s.2(%rip)
.L24:
	movl	-36(%rbp), %eax
	movl	$16, %edx
	leaq	s.2(%rip), %rcx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	connect@PLT
	testl	%eax, %eax
	jns	.L28
	call	__errno_location@PLT
	movl	(%rax), %eax
	cmpl	$104, %eax
	je	.L29
	call	__errno_location@PLT
	movl	(%rax), %eax
	cmpl	$111, %eax
	je	.L29
	call	__errno_location@PLT
	movl	(%rax), %eax
	cmpl	$11, %eax
	jne	.L30
.L29:
	movl	-36(%rbp), %eax
	movl	%eax, %edi
	call	close@PLT
	movl	tries.0(%rip), %eax
	addl	$1, %eax
	movl	%eax, tries.0(%rip)
	movl	tries.0(%rip), %eax
	cmpl	$10, %eax
	jle	.L31
	movl	$-1, %eax
	jmp	.L32
.L31:
	movl	-64(%rbp), %edx
	movl	-60(%rbp), %ecx
	movq	-56(%rbp), %rax
	movl	%ecx, %esi
	movq	%rax, %rdi
	call	tcp_connect
	jmp	.L32
.L30:
	leaq	.LC6(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$4, %edi
	call	exit@PLT
.L28:
	movl	$0, tries.0(%rip)
	movl	-36(%rbp), %eax
.L32:
	movq	-8(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L33
	call	__stack_chk_fail@PLT
.L33:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE11:
	.size	tcp_connect, .-tcp_connect
	.section	.rodata
.LC7:
	.string	"SO_REUSEADDR"
	.text
	.globl	sock_optimize
	.type	sock_optimize, @function
sock_optimize:
.LFB12:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movl	%edi, -20(%rbp)
	movl	%esi, -24(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movl	-24(%rbp), %eax
	andl	$1, %eax
	testl	%eax, %eax
	je	.L35
	movl	$1048576, -12(%rbp)
	jmp	.L36
.L37:
	movl	-12(%rbp), %eax
	sarl	%eax
	movl	%eax, -12(%rbp)
.L36:
	leaq	-12(%rbp), %rdx
	movl	-20(%rbp), %eax
	movl	$4, %r8d
	movq	%rdx, %rcx
	movl	$8, %edx
	movl	$1, %esi
	movl	%eax, %edi
	call	setsockopt@PLT
	testl	%eax, %eax
	jne	.L37
.L35:
	movl	-24(%rbp), %eax
	andl	$2, %eax
	testl	%eax, %eax
	je	.L38
	movl	$1048576, -12(%rbp)
	jmp	.L39
.L40:
	movl	-12(%rbp), %eax
	sarl	%eax
	movl	%eax, -12(%rbp)
.L39:
	leaq	-12(%rbp), %rdx
	movl	-20(%rbp), %eax
	movl	$4, %r8d
	movq	%rdx, %rcx
	movl	$7, %edx
	movl	$1, %esi
	movl	%eax, %edi
	call	setsockopt@PLT
	testl	%eax, %eax
	jne	.L40
.L38:
	movl	-24(%rbp), %eax
	andl	$8, %eax
	testl	%eax, %eax
	je	.L44
	movl	$1, -12(%rbp)
	leaq	-12(%rbp), %rdx
	movl	-20(%rbp), %eax
	movl	$4, %r8d
	movq	%rdx, %rcx
	movl	$2, %edx
	movl	$1, %esi
	movl	%eax, %edi
	call	setsockopt@PLT
	cmpl	$-1, %eax
	jne	.L44
	leaq	.LC7(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
.L44:
	nop
	movq	-8(%rbp), %rax
	subq	%fs:40, %rax
	je	.L43
	call	__stack_chk_fail@PLT
.L43:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE12:
	.size	sock_optimize, .-sock_optimize
	.section	.rodata
.LC8:
	.string	"getsockname"
	.text
	.globl	sockport
	.type	sockport, @function
sockport:
.LFB13:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$64, %rsp
	movl	%edi, -52(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movl	$16, -36(%rbp)
	leaq	-36(%rbp), %rdx
	leaq	-32(%rbp), %rcx
	movl	-52(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	getsockname@PLT
	testl	%eax, %eax
	jns	.L46
	leaq	.LC8(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$-1, %eax
	jmp	.L48
.L46:
	movzwl	-30(%rbp), %eax
	movzwl	%ax, %eax
	movl	%eax, %edi
	call	ntohs@PLT
	movzwl	%ax, %eax
.L48:
	movq	-8(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L49
	call	__stack_chk_fail@PLT
.L49:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE13:
	.size	sockport, .-sockport
	.local	port.6
	.comm	port.6,2,2
	.local	h.5
	.comm	h.5,8,8
	.local	save_host.4
	.comm	save_host.4,8,8
	.local	save_prog.3
	.comm	save_prog.3,8,8
	.local	s.2
	.comm	s.2,16,16
	.local	save_port.1
	.comm	save_port.1,2,2
	.local	tries.0
	.comm	tries.0,4,4
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
