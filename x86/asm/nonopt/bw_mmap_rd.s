	.file	"bw_mmap_rd.c"
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
	.string	"[-C] [-P <parallelism>] [-W <warmup>] [-N <repetitions>] <size> open2close|mmap_only <filename>"
.LC2:
	.string	"P:W:N:C"
.LC3:
	.string	"x"
.LC4:
	.string	"<size> out of range!\n"
.LC5:
	.string	"open2close"
.LC6:
	.string	"mmap_only"
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
	subq	$480, %rsp
	movl	%edi, -468(%rbp)
	movq	%rsi, -480(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movl	$1, -464(%rbp)
	movl	$0, -460(%rbp)
	movl	$-1, -456(%rbp)
	leaq	.LC1(%rip), %rax
	movq	%rax, -448(%rbp)
	movl	$0, -20(%rbp)
	jmp	.L2
.L9:
	cmpl	$87, -452(%rbp)
	je	.L3
	cmpl	$87, -452(%rbp)
	jg	.L4
	cmpl	$80, -452(%rbp)
	je	.L5
	cmpl	$80, -452(%rbp)
	jg	.L4
	cmpl	$67, -452(%rbp)
	je	.L6
	cmpl	$78, -452(%rbp)
	je	.L7
	jmp	.L4
.L5:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -464(%rbp)
	cmpl	$0, -464(%rbp)
	jg	.L2
	movq	-448(%rbp), %rdx
	movq	-480(%rbp), %rcx
	movl	-468(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	lmbench_usage@PLT
	jmp	.L2
.L3:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -460(%rbp)
	jmp	.L2
.L7:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -456(%rbp)
	jmp	.L2
.L6:
	movl	$1, -20(%rbp)
	jmp	.L2
.L4:
	movq	-448(%rbp), %rdx
	movq	-480(%rbp), %rcx
	movl	-468(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	lmbench_usage@PLT
	nop
.L2:
	movq	-480(%rbp), %rcx
	movl	-468(%rbp), %eax
	leaq	.LC2(%rip), %rdx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	mygetopt@PLT
	movl	%eax, -452(%rbp)
	cmpl	$-1, -452(%rbp)
	jne	.L9
	movl	myoptind(%rip), %eax
	addl	$3, %eax
	cmpl	%eax, -468(%rbp)
	je	.L10
	movq	-448(%rbp), %rdx
	movq	-480(%rbp), %rcx
	movl	-468(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	lmbench_usage@PLT
.L10:
	movl	myoptind(%rip), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-480(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	bytes@PLT
	movq	%rax, -288(%rbp)
	movq	-288(%rbp), %rax
	movq	%rax, -440(%rbp)
	movl	myoptind(%rip), %eax
	cltq
	addq	$2, %rax
	leaq	0(,%rax,8), %rdx
	movq	-480(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	leaq	-288(%rbp), %rdx
	addq	$8, %rdx
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	strcpy@PLT
	leaq	-432(%rbp), %rax
	leaq	-288(%rbp), %rdx
	addq	$8, %rdx
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	stat@PLT
	cmpl	$-1, %eax
	jne	.L11
	leaq	.LC3(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L11:
	movl	-408(%rbp), %eax
	andl	$61440, %eax
	cmpl	$32768, %eax
	jne	.L12
	movq	-384(%rbp), %rax
	cmpq	%rax, -440(%rbp)
	ja	.L13
.L12:
	cmpq	$511, -440(%rbp)
	ja	.L14
.L13:
	movq	stderr(%rip), %rax
	movq	%rax, %rcx
	movl	$21, %edx
	movl	$1, %esi
	leaq	.LC4(%rip), %rax
	movq	%rax, %rdi
	call	fwrite@PLT
	movl	$1, %edi
	call	exit@PLT
.L14:
	movl	myoptind(%rip), %eax
	cltq
	addq	$1, %rax
	leaq	0(,%rax,8), %rdx
	movq	-480(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	%rax, %rsi
	leaq	.LC5(%rip), %rax
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L15
	movl	-460(%rbp), %ecx
	movl	-464(%rbp), %edx
	leaq	-288(%rbp), %rax
	pushq	%rax
	movl	-456(%rbp), %eax
	pushq	%rax
	movl	%ecx, %r9d
	movl	%edx, %r8d
	movl	$0, %ecx
	leaq	cleanup(%rip), %rax
	movq	%rax, %rdx
	leaq	time_with_open(%rip), %rax
	movq	%rax, %rsi
	leaq	initialize(%rip), %rax
	movq	%rax, %rdi
	call	benchmp@PLT
	addq	$16, %rsp
	jmp	.L16
.L15:
	movl	myoptind(%rip), %eax
	cltq
	addq	$1, %rax
	leaq	0(,%rax,8), %rdx
	movq	-480(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	%rax, %rsi
	leaq	.LC6(%rip), %rax
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L17
	movl	-460(%rbp), %ecx
	movl	-464(%rbp), %edx
	leaq	-288(%rbp), %rax
	pushq	%rax
	movl	-456(%rbp), %eax
	pushq	%rax
	movl	%ecx, %r9d
	movl	%edx, %r8d
	movl	$0, %ecx
	leaq	cleanup(%rip), %rax
	movq	%rax, %rdx
	leaq	time_no_open(%rip), %rax
	movq	%rax, %rsi
	leaq	init_open(%rip), %rax
	movq	%rax, %rdi
	call	benchmp@PLT
	addq	$16, %rsp
	jmp	.L16
.L17:
	movq	-448(%rbp), %rdx
	movq	-480(%rbp), %rcx
	movl	-468(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	lmbench_usage@PLT
.L16:
	call	get_n@PLT
	movl	-464(%rbp), %edx
	movslq	%edx, %rdx
	imulq	%rdx, %rax
	movq	%rax, %rcx
	movq	-440(%rbp), %rax
	movl	$0, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	bandwidth@PLT
	movl	$0, %eax
	movq	-8(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L19
	call	__stack_chk_fail@PLT
.L19:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE8:
	.size	main, .-main
	.section	.rodata
.LC7:
	.string	"%d"
.LC8:
	.string	"%s%d"
.LC9:
	.string	"creating private tempfile"
	.text
	.globl	initialize
	.type	initialize, @function
initialize:
.LFB9:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%rbx
	subq	$4096, %rsp
	orq	$0, (%rsp)
	subq	$4096, %rsp
	orq	$0, (%rsp)
	subq	$56, %rsp
	.cfi_offset 3, -24
	movq	%rdi, -8248(%rbp)
	movq	%rsi, -8256(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -24(%rbp)
	xorl	%eax, %eax
	movq	-8256(%rbp), %rax
	movq	%rax, -8240(%rbp)
	cmpq	$0, -8248(%rbp)
	jne	.L25
	movq	-8240(%rbp), %rax
	movl	$-1, 264(%rax)
	movq	-8240(%rbp), %rax
	movq	$0, 272(%rax)
	movq	-8240(%rbp), %rax
	movl	268(%rax), %eax
	testl	%eax, %eax
	je	.L20
	call	getpid@PLT
	movl	%eax, %edx
	leaq	-8224(%rbp), %rax
	leaq	.LC7(%rip), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	sprintf@PLT
	movq	-8240(%rbp), %rax
	addq	$8, %rax
	movq	%rax, %rdi
	call	strlen@PLT
	movq	%rax, %rbx
	leaq	-8224(%rbp), %rax
	movq	%rax, %rdi
	call	strlen@PLT
	addq	%rbx, %rax
	addq	$1, %rax
	movq	%rax, %rdi
	call	malloc@PLT
	movq	%rax, -8232(%rbp)
	call	getpid@PLT
	movl	%eax, %ecx
	movq	-8240(%rbp), %rax
	leaq	8(%rax), %rdx
	movq	-8232(%rbp), %rax
	leaq	.LC8(%rip), %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	sprintf@PLT
	movq	-8240(%rbp), %rax
	leaq	8(%rax), %rcx
	movq	-8232(%rbp), %rax
	movl	$384, %edx
	movq	%rax, %rsi
	movq	%rcx, %rdi
	call	cp@PLT
	testl	%eax, %eax
	jns	.L23
	leaq	.LC9(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movq	-8232(%rbp), %rax
	movq	%rax, %rdi
	call	unlink@PLT
	movl	$1, %edi
	call	exit@PLT
.L23:
	movq	-8240(%rbp), %rax
	leaq	8(%rax), %rdx
	movq	-8232(%rbp), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	strcpy@PLT
	jmp	.L20
.L25:
	nop
.L20:
	movq	-24(%rbp), %rax
	subq	%fs:40, %rax
	je	.L24
	call	__stack_chk_fail@PLT
.L24:
	movq	-8(%rbp), %rbx
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE9:
	.size	initialize, .-initialize
	.globl	init_open
	.type	init_open, @function
init_open:
.LFB10:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%rdi, -24(%rbp)
	movq	%rsi, -32(%rbp)
	movq	-32(%rbp), %rax
	movq	%rax, -8(%rbp)
	cmpq	$0, -24(%rbp)
	jne	.L30
	movq	-32(%rbp), %rax
	movq	%rax, %rsi
	movl	$0, %edi
	call	initialize
	movq	-8(%rbp), %rax
	addq	$8, %rax
	movl	$0, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	open@PLT
	movq	-8(%rbp), %rdx
	movl	%eax, 264(%rdx)
	movq	-8(%rbp), %rax
	movl	264(%rax), %eax
	cmpl	$-1, %eax
	jne	.L29
	leaq	.LC3(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L29:
	movq	-8(%rbp), %rax
	movl	264(%rax), %edx
	movq	-8(%rbp), %rax
	movq	(%rax), %rax
	movl	$0, %r9d
	movl	%edx, %r8d
	movl	$1, %ecx
	movl	$1, %edx
	movq	%rax, %rsi
	movl	$0, %edi
	call	mmap@PLT
	movq	-8(%rbp), %rdx
	movq	%rax, 272(%rdx)
	movq	-8(%rbp), %rax
	movq	272(%rax), %rax
	cmpq	$-1, %rax
	jne	.L26
	leaq	.LC3(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L30:
	nop
.L26:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE10:
	.size	init_open, .-init_open
	.globl	cleanup
	.type	cleanup, @function
cleanup:
.LFB11:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%rdi, -24(%rbp)
	movq	%rsi, -32(%rbp)
	movq	-32(%rbp), %rax
	movq	%rax, -8(%rbp)
	cmpq	$0, -24(%rbp)
	jne	.L36
	movq	-8(%rbp), %rax
	movq	272(%rax), %rax
	testq	%rax, %rax
	je	.L34
	movq	-8(%rbp), %rax
	movq	(%rax), %rdx
	movq	-8(%rbp), %rax
	movq	272(%rax), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	munmap@PLT
.L34:
	movq	-8(%rbp), %rax
	movl	264(%rax), %eax
	testl	%eax, %eax
	js	.L35
	movq	-8(%rbp), %rax
	movl	264(%rax), %eax
	movl	%eax, %edi
	call	close@PLT
.L35:
	movq	-8(%rbp), %rax
	movl	268(%rax), %eax
	testl	%eax, %eax
	je	.L31
	movq	-8(%rbp), %rax
	addq	$8, %rax
	movq	%rax, %rdi
	call	unlink@PLT
	jmp	.L31
.L36:
	nop
.L31:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE11:
	.size	cleanup, .-cleanup
	.globl	time_no_open
	.type	time_no_open, @function
time_no_open:
.LFB12:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%rdi, -24(%rbp)
	movq	%rsi, -32(%rbp)
	movq	-32(%rbp), %rax
	movq	%rax, -8(%rbp)
	jmp	.L38
.L39:
	movq	-8(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %rdx
	movq	-8(%rbp), %rax
	movq	272(%rax), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	bread@PLT
.L38:
	movq	-24(%rbp), %rax
	leaq	-1(%rax), %rdx
	movq	%rdx, -24(%rbp)
	testq	%rax, %rax
	jne	.L39
	nop
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE12:
	.size	time_no_open, .-time_no_open
	.globl	time_with_open
	.type	time_with_open, @function
time_with_open:
.LFB13:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$64, %rsp
	movq	%rdi, -56(%rbp)
	movq	%rsi, -64(%rbp)
	movq	-64(%rbp), %rax
	movq	%rax, -32(%rbp)
	movq	-32(%rbp), %rax
	addq	$8, %rax
	movq	%rax, -24(%rbp)
	movq	-32(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -16(%rbp)
	jmp	.L41
.L44:
	movq	-24(%rbp), %rax
	movl	$0, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	open@PLT
	movl	%eax, -36(%rbp)
	cmpl	$-1, -36(%rbp)
	jne	.L42
	leaq	.LC3(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L42:
	movl	-36(%rbp), %edx
	movq	-16(%rbp), %rax
	movl	$0, %r9d
	movl	%edx, %r8d
	movl	$1, %ecx
	movl	$1, %edx
	movq	%rax, %rsi
	movl	$0, %edi
	call	mmap@PLT
	movq	%rax, -8(%rbp)
	cmpq	$-1, -8(%rbp)
	jne	.L43
	leaq	.LC3(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L43:
	movq	-16(%rbp), %rdx
	movq	-8(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	bread@PLT
	movl	-36(%rbp), %eax
	movl	%eax, %edi
	call	close@PLT
	movq	-16(%rbp), %rdx
	movq	-8(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	munmap@PLT
.L41:
	movq	-56(%rbp), %rax
	leaq	-1(%rax), %rdx
	movq	%rdx, -56(%rbp)
	testq	%rax, %rax
	jne	.L44
	nop
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE13:
	.size	time_with_open, .-time_with_open
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
