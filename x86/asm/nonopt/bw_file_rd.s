	.file	"bw_file_rd.c"
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
	.globl	buf
	.bss
	.align 8
	.type	buf, @object
	.size	buf, 8
buf:
	.zero	8
	.globl	xfersize
	.align 8
	.type	xfersize, @object
	.size	xfersize, 8
xfersize:
	.zero	8
	.globl	count
	.align 8
	.type	count, @object
	.size	count, 8
count:
	.zero	8
	.text
	.globl	doit
	.type	doit, @function
doit:
.LFB8:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movl	%edi, -20(%rbp)
	movq	count(%rip), %rax
	movq	%rax, -16(%rbp)
	movq	xfersize(%rip), %rax
	movq	%rax, -8(%rbp)
	jmp	.L2
.L6:
	movq	-16(%rbp), %rax
	cmpq	-8(%rbp), %rax
	jnb	.L3
	movq	-16(%rbp), %rax
	movq	%rax, -8(%rbp)
.L3:
	movq	-8(%rbp), %rdx
	movq	-16(%rbp), %rax
	cmpq	%rax, %rdx
	cmova	%rax, %rdx
	movq	buf(%rip), %rcx
	movl	-20(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	read@PLT
	testq	%rax, %rax
	jle	.L7
	movq	xfersize(%rip), %rdx
	movq	-16(%rbp), %rax
	cmpq	%rax, %rdx
	cmovbe	%rdx, %rax
	movq	%rax, %rdx
	movq	buf(%rip), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	bread@PLT
	movq	-8(%rbp), %rax
	subq	%rax, -16(%rbp)
.L2:
	cmpq	$0, -16(%rbp)
	jne	.L6
	jmp	.L8
.L7:
	nop
.L8:
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE8:
	.size	doit, .-doit
	.section	.rodata
.LC1:
	.string	"%d"
.LC2:
	.string	"%s%d"
.LC3:
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
	subq	$184, %rsp
	.cfi_offset 3, -24
	movq	%rdi, -184(%rbp)
	movq	%rsi, -192(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -24(%rbp)
	xorl	%eax, %eax
	movq	-192(%rbp), %rax
	movq	%rax, -176(%rbp)
	cmpq	$0, -184(%rbp)
	jne	.L14
	movq	-176(%rbp), %rax
	movl	$-1, 256(%rax)
	movq	-176(%rbp), %rax
	movl	260(%rax), %eax
	testl	%eax, %eax
	je	.L9
	call	getpid@PLT
	movl	%eax, %edx
	leaq	-160(%rbp), %rax
	leaq	.LC1(%rip), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	sprintf@PLT
	movq	-176(%rbp), %rax
	movq	%rax, %rdi
	call	strlen@PLT
	movq	%rax, %rbx
	leaq	-160(%rbp), %rax
	movq	%rax, %rdi
	call	strlen@PLT
	addq	%rbx, %rax
	addq	$1, %rax
	movq	%rax, %rdi
	call	malloc@PLT
	movq	%rax, -168(%rbp)
	call	getpid@PLT
	movl	%eax, %ecx
	movq	-176(%rbp), %rdx
	movq	-168(%rbp), %rax
	leaq	.LC2(%rip), %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	sprintf@PLT
	movq	-176(%rbp), %rax
	movq	-168(%rbp), %rcx
	movl	$384, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	cp@PLT
	testl	%eax, %eax
	jns	.L12
	leaq	.LC3(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movq	-168(%rbp), %rax
	movq	%rax, %rdi
	call	unlink@PLT
	movl	$1, %edi
	call	exit@PLT
.L12:
	movq	-176(%rbp), %rax
	movq	-168(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcpy@PLT
	jmp	.L9
.L14:
	nop
.L9:
	movq	-24(%rbp), %rax
	subq	%fs:40, %rax
	je	.L13
	call	__stack_chk_fail@PLT
.L13:
	movq	-8(%rbp), %rbx
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE9:
	.size	initialize, .-initialize
	.section	.rodata
	.align 8
.LC4:
	.string	"ofd = open(state->filename, O_RDONLY)"
	.text
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
	jne	.L19
	movq	-32(%rbp), %rax
	movq	%rax, %rsi
	movl	$0, %edi
	call	initialize
	movq	-8(%rbp), %rax
	movl	$0, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	open@PLT
	movl	%eax, -12(%rbp)
	cmpl	$-1, -12(%rbp)
	jne	.L18
	leaq	.LC4(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L18:
	movq	-8(%rbp), %rax
	movl	-12(%rbp), %edx
	movl	%edx, 256(%rax)
	jmp	.L15
.L19:
	nop
.L15:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE10:
	.size	init_open, .-init_open
	.globl	time_with_open
	.type	time_with_open, @function
time_with_open:
.LFB11:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$48, %rsp
	movq	%rdi, -40(%rbp)
	movq	%rsi, -48(%rbp)
	movq	-48(%rbp), %rax
	movq	%rax, -16(%rbp)
	movq	-16(%rbp), %rax
	movq	%rax, -8(%rbp)
	jmp	.L21
.L22:
	movq	-8(%rbp), %rax
	movl	$0, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	open@PLT
	movl	%eax, -20(%rbp)
	movl	-20(%rbp), %eax
	movl	%eax, %edi
	call	doit
	movl	-20(%rbp), %eax
	movl	%eax, %edi
	call	close@PLT
.L21:
	movq	-40(%rbp), %rax
	leaq	-1(%rax), %rdx
	movq	%rdx, -40(%rbp)
	testq	%rax, %rax
	jne	.L22
	nop
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE11:
	.size	time_with_open, .-time_with_open
	.globl	time_io_only
	.type	time_io_only, @function
time_io_only:
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
	movq	-8(%rbp), %rax
	movl	256(%rax), %eax
	movl	%eax, -12(%rbp)
	jmp	.L24
.L25:
	movl	-12(%rbp), %eax
	movl	$0, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	lseek@PLT
	movl	-12(%rbp), %eax
	movl	%eax, %edi
	call	doit
.L24:
	movq	-24(%rbp), %rax
	leaq	-1(%rax), %rdx
	movq	%rdx, -24(%rbp)
	testq	%rax, %rax
	jne	.L25
	nop
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE12:
	.size	time_io_only, .-time_io_only
	.globl	cleanup
	.type	cleanup, @function
cleanup:
.LFB13:
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
	movq	-8(%rbp), %rax
	movl	256(%rax), %eax
	testl	%eax, %eax
	js	.L29
	movq	-8(%rbp), %rax
	movl	256(%rax), %eax
	movl	%eax, %edi
	call	close@PLT
.L29:
	movq	-8(%rbp), %rax
	movl	260(%rax), %eax
	testl	%eax, %eax
	je	.L26
	movq	-8(%rbp), %rax
	movq	%rax, %rdi
	call	unlink@PLT
	jmp	.L26
.L30:
	nop
.L26:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE13:
	.size	cleanup, .-cleanup
	.section	.rodata
	.align 8
.LC5:
	.string	"[-C] [-P <parallelism>] [-W <warmup>] [-N <repetitions>] <size> open2close|io_only <filename>\nmin size=%d\n"
.LC6:
	.string	"P:W:N:C"
.LC7:
	.string	"open2close"
.LC8:
	.string	"io_only"
	.text
	.globl	main
	.type	main, @function
main:
.LFB14:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$1344, %rsp
	movl	%edi, -1332(%rbp)
	movq	%rsi, -1344(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movl	$1, -1328(%rbp)
	movl	$0, -1324(%rbp)
	movl	$-1, -1320(%rbp)
	leaq	-1040(%rbp), %rax
	movl	$64, %edx
	leaq	.LC5(%rip), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	sprintf@PLT
	movl	$0, -1052(%rbp)
	jmp	.L32
.L39:
	cmpl	$87, -1316(%rbp)
	je	.L33
	cmpl	$87, -1316(%rbp)
	jg	.L34
	cmpl	$80, -1316(%rbp)
	je	.L35
	cmpl	$80, -1316(%rbp)
	jg	.L34
	cmpl	$67, -1316(%rbp)
	je	.L36
	cmpl	$78, -1316(%rbp)
	je	.L37
	jmp	.L34
.L35:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -1328(%rbp)
	cmpl	$0, -1328(%rbp)
	jg	.L32
	leaq	-1040(%rbp), %rdx
	movq	-1344(%rbp), %rcx
	movl	-1332(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	lmbench_usage@PLT
	jmp	.L32
.L33:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -1324(%rbp)
	jmp	.L32
.L37:
	movq	myoptarg(%rip), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -1320(%rbp)
	jmp	.L32
.L36:
	movl	$1, -1052(%rbp)
	jmp	.L32
.L34:
	leaq	-1040(%rbp), %rdx
	movq	-1344(%rbp), %rcx
	movl	-1332(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	lmbench_usage@PLT
	nop
.L32:
	movq	-1344(%rbp), %rcx
	movl	-1332(%rbp), %eax
	leaq	.LC6(%rip), %rdx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	mygetopt@PLT
	movl	%eax, -1316(%rbp)
	cmpl	$-1, -1316(%rbp)
	jne	.L39
	movl	myoptind(%rip), %eax
	addl	$3, %eax
	cmpl	%eax, -1332(%rbp)
	je	.L40
	leaq	-1040(%rbp), %rdx
	movq	-1344(%rbp), %rcx
	movl	-1332(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	lmbench_usage@PLT
.L40:
	movl	myoptind(%rip), %eax
	cltq
	addq	$2, %rax
	leaq	0(,%rax,8), %rdx
	movq	-1344(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rdx
	leaq	-1312(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcpy@PLT
	movl	myoptind(%rip), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-1344(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	bytes@PLT
	movq	%rax, count(%rip)
	movq	count(%rip), %rax
	cmpq	$511, %rax
	ja	.L41
	movl	$1, %edi
	call	exit@PLT
.L41:
	movq	count(%rip), %rax
	cmpq	$65535, %rax
	ja	.L42
	movq	count(%rip), %rax
	movq	%rax, xfersize(%rip)
	jmp	.L43
.L42:
	movq	$65536, xfersize(%rip)
.L43:
	movl	$65536, %edi
	call	valloc@PLT
	movq	%rax, buf(%rip)
	movq	buf(%rip), %rax
	movl	$65536, %edx
	movl	$0, %esi
	movq	%rax, %rdi
	call	memset@PLT
	movl	myoptind(%rip), %eax
	cltq
	addq	$1, %rax
	leaq	0(,%rax,8), %rdx
	movq	-1344(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	%rax, %rsi
	leaq	.LC7(%rip), %rax
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L44
	movl	-1324(%rbp), %ecx
	movl	-1328(%rbp), %edx
	leaq	-1312(%rbp), %rax
	pushq	%rax
	movl	-1320(%rbp), %eax
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
	jmp	.L45
.L44:
	movl	myoptind(%rip), %eax
	cltq
	addq	$1, %rax
	leaq	0(,%rax,8), %rdx
	movq	-1344(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	%rax, %rsi
	leaq	.LC8(%rip), %rax
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L46
	movl	-1324(%rbp), %ecx
	movl	-1328(%rbp), %edx
	leaq	-1312(%rbp), %rax
	pushq	%rax
	movl	-1320(%rbp), %eax
	pushq	%rax
	movl	%ecx, %r9d
	movl	%edx, %r8d
	movl	$0, %ecx
	leaq	cleanup(%rip), %rax
	movq	%rax, %rdx
	leaq	time_io_only(%rip), %rax
	movq	%rax, %rsi
	leaq	init_open(%rip), %rax
	movq	%rax, %rdi
	call	benchmp@PLT
	addq	$16, %rsp
	jmp	.L45
.L46:
	leaq	-1040(%rbp), %rdx
	movq	-1344(%rbp), %rcx
	movl	-1332(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	lmbench_usage@PLT
.L45:
	call	get_n@PLT
	movl	-1328(%rbp), %edx
	movslq	%edx, %rdx
	imulq	%rdx, %rax
	movq	%rax, %rcx
	movq	count(%rip), %rax
	movl	$0, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	bandwidth@PLT
	movl	$0, %eax
	movq	-8(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L48
	call	__stack_chk_fail@PLT
.L48:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE14:
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
