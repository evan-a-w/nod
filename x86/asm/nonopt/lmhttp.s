	.file	"lmhttp.c"
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
	.globl	bufs
	.align 16
	.type	bufs, @object
	.size	bufs, 24
bufs:
	.zero	24
	.globl	Dflg
	.align 4
	.type	Dflg, @object
	.size	Dflg, 4
Dflg:
	.zero	4
	.globl	dflg
	.align 4
	.type	dflg, @object
	.size	dflg, 4
dflg:
	.zero	4
	.globl	nflg
	.align 4
	.type	nflg, @object
	.size	nflg, 4
nflg:
	.zero	4
	.globl	lflg
	.align 4
	.type	lflg, @object
	.size	lflg, 4
lflg:
	.zero	4
	.globl	fflg
	.align 4
	.type	fflg, @object
	.size	fflg, 4
fflg:
	.zero	4
	.globl	zflg
	.align 4
	.type	zflg, @object
	.size	zflg, 4
zflg:
	.zero	4
	.globl	data
	.align 4
	.type	data, @object
	.size	data, 4
data:
	.zero	4
	.globl	logfile
	.align 4
	.type	logfile, @object
	.size	logfile, 4
logfile:
	.zero	4
	.section	.rodata
.LC1:
	.string	"Barf.\n"
.LC2:
	.string	"DOCROOT"
.LC3:
	.string	"/usr/tmp/lmhttp.log"
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
	subq	$32, %rsp
	movl	%edi, -20(%rbp)
	movq	%rsi, -32(%rbp)
	movl	$1, -8(%rbp)
	jmp	.L2
.L14:
	movl	-8(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-32(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movzbl	(%rax), %eax
	cmpb	$45, %al
	jne	.L23
	movl	-8(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-32(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	addq	$1, %rax
	movzbl	(%rax), %eax
	movsbl	%al, %eax
	cmpl	$68, %eax
	je	.L5
	cmpl	$68, %eax
	jl	.L6
	cmpl	$122, %eax
	jg	.L6
	cmpl	$100, %eax
	jl	.L6
	subl	$100, %eax
	cmpl	$22, %eax
	ja	.L6
	movl	%eax, %eax
	leaq	0(,%rax,4), %rdx
	leaq	.L8(%rip), %rax
	movl	(%rdx,%rax), %eax
	cltq
	leaq	.L8(%rip), %rdx
	addq	%rdx, %rax
	notrack jmp	*%rax
	.section	.rodata
	.align 4
	.align 4
.L8:
	.long	.L12-.L8
	.long	.L6-.L8
	.long	.L11-.L8
	.long	.L6-.L8
	.long	.L6-.L8
	.long	.L6-.L8
	.long	.L6-.L8
	.long	.L6-.L8
	.long	.L10-.L8
	.long	.L6-.L8
	.long	.L9-.L8
	.long	.L6-.L8
	.long	.L6-.L8
	.long	.L6-.L8
	.long	.L6-.L8
	.long	.L6-.L8
	.long	.L6-.L8
	.long	.L6-.L8
	.long	.L6-.L8
	.long	.L6-.L8
	.long	.L6-.L8
	.long	.L6-.L8
	.long	.L7-.L8
	.text
.L5:
	movl	$1, Dflg(%rip)
	jmp	.L13
.L12:
	movl	$1, dflg(%rip)
	jmp	.L13
.L11:
	movl	-8(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-32(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	addq	$2, %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, fflg(%rip)
	jmp	.L13
.L10:
	movl	$1, lflg(%rip)
	jmp	.L13
.L9:
	movl	$1, nflg(%rip)
	jmp	.L13
.L7:
	movl	$1, zflg(%rip)
	jmp	.L13
.L6:
	movq	stderr(%rip), %rax
	movq	%rax, %rcx
	movl	$6, %edx
	movl	$1, %esi
	leaq	.LC1(%rip), %rax
	movq	%rax, %rdi
	call	fwrite@PLT
	movl	$1, %edi
	call	exit@PLT
.L13:
	addl	$1, -8(%rbp)
.L2:
	movl	-8(%rbp), %eax
	cmpl	-20(%rbp), %eax
	jl	.L14
	jmp	.L4
.L23:
	nop
.L4:
	leaq	.LC2(%rip), %rax
	movq	%rax, %rdi
	call	getenv@PLT
	testq	%rax, %rax
	je	.L15
	leaq	.LC2(%rip), %rax
	movq	%rax, %rdi
	call	getenv@PLT
	movq	%rax, %rdi
	call	chdir@PLT
	cmpl	$-1, %eax
	jne	.L15
	leaq	.LC2(%rip), %rax
	movq	%rax, %rdi
	call	getenv@PLT
	movq	%rax, %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L15:
	movl	-20(%rbp), %eax
	cltq
	salq	$3, %rax
	leaq	-8(%rax), %rdx
	movq	-32(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	testl	%eax, %eax
	je	.L16
	movl	-20(%rbp), %eax
	cltq
	salq	$3, %rax
	leaq	-8(%rax), %rdx
	movq	-32(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	negl	%eax
	movl	%eax, -4(%rbp)
	jmp	.L17
.L16:
	movl	$-80, -4(%rbp)
.L17:
	movl	$1, %esi
	movl	$13, %edi
	call	signal@PLT
	movl	-4(%rbp), %eax
	movl	$8, %esi
	movl	%eax, %edi
	call	tcp_server@PLT
	movl	%eax, data(%rip)
	movl	$65536, %edi
	call	valloc@PLT
	movq	%rax, bufs(%rip)
	movl	$65536, %edi
	call	valloc@PLT
	movq	%rax, 8+bufs(%rip)
	movl	$65536, %edi
	call	valloc@PLT
	movq	%rax, 16+bufs(%rip)
	movl	$438, %edx
	movl	$1089, %esi
	leaq	.LC3(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	open@PLT
	movl	%eax, logfile(%rip)
	leaq	die(%rip), %rax
	movq	%rax, %rsi
	movl	$2, %edi
	call	signal@PLT
	leaq	die(%rip), %rax
	movq	%rax, %rsi
	movl	$1, %edi
	call	signal@PLT
	leaq	die(%rip), %rax
	movq	%rax, %rsi
	movl	$15, %edi
	call	signal@PLT
	movl	$1, -8(%rbp)
	jmp	.L18
.L21:
	call	fork@PLT
	testl	%eax, %eax
	jle	.L24
	addl	$1, -8(%rbp)
.L18:
	movl	fflg(%rip), %eax
	cmpl	%eax, -8(%rbp)
	jl	.L21
	jmp	.L20
.L24:
	nop
.L20:
	movl	-8(%rbp), %eax
	movl	$0, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	handle_scheduler@PLT
	movl	$0, %eax
	call	worker
	movl	$0, %eax
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE8:
	.size	main, .-main
	.globl	worker
	.type	worker, @function
worker:
.LFB9:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movl	$0, -8(%rbp)
.L27:
	movl	-8(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	leaq	bufs(%rip), %rax
	movq	(%rdx,%rax), %rax
	movq	%rax, buf(%rip)
	addl	$1, -8(%rbp)
	cmpl	$3, -8(%rbp)
	jne	.L26
	movl	$0, -8(%rbp)
.L26:
	movl	data(%rip), %eax
	movl	$8, %esi
	movl	%eax, %edi
	call	tcp_accept@PLT
	movl	%eax, -4(%rbp)
	movl	-4(%rbp), %eax
	movl	%eax, %edi
	call	source
	movl	-4(%rbp), %eax
	movl	%eax, %edi
	call	close@PLT
	jmp	.L27
	.cfi_endproc
.LFE9:
	.size	worker, .-worker
	.section	.rodata
.LC4:
	.string	"%a, %d %b %y %H:%M:%S %Z"
	.text
	.globl	http_time
	.type	http_time, @function
http_time:
.LFB10:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%rbx
	subq	$40, %rsp
	.cfi_offset 3, -24
	movq	%fs:40, %rax
	movq	%rax, -24(%rbp)
	xorl	%eax, %eax
	leaq	-40(%rbp), %rax
	movq	%rax, %rdi
	call	time@PLT
	movq	-40(%rbp), %rdx
	movq	save_tt.2(%rip), %rax
	cmpq	%rax, %rdx
	jne	.L29
	leaq	buf.1(%rip), %rax
	jmp	.L32
.L29:
	movq	-40(%rbp), %rax
	movq	%rax, save_tt.2(%rip)
	leaq	-40(%rbp), %rax
	movq	%rax, %rdi
	call	gmtime@PLT
	movq	%rax, -32(%rbp)
	movzbl	buf.1(%rip), %eax
	testb	%al, %al
	je	.L31
	movq	-40(%rbp), %rax
	movq	save_tt.2(%rip), %rdx
	subq	%rdx, %rax
	cmpq	$3599, %rax
	jg	.L31
	movq	-32(%rbp), %rax
	movl	(%rax), %eax
	movslq	%eax, %rdx
	imulq	$1717986919, %rdx, %rdx
	shrq	$32, %rdx
	sarl	$2, %edx
	sarl	$31, %eax
	movl	%eax, %ecx
	movl	%edx, %eax
	subl	%ecx, %eax
	addl	$48, %eax
	movb	%al, 22+buf.1(%rip)
	movq	-32(%rbp), %rax
	movl	(%rax), %edx
	movslq	%edx, %rax
	imulq	$1717986919, %rax, %rax
	shrq	$32, %rax
	sarl	$2, %eax
	movl	%edx, %esi
	sarl	$31, %esi
	subl	%esi, %eax
	movl	%eax, %ecx
	movl	%ecx, %eax
	sall	$2, %eax
	addl	%ecx, %eax
	addl	%eax, %eax
	movl	%edx, %ecx
	subl	%eax, %ecx
	movl	%ecx, %eax
	addl	$48, %eax
	movb	%al, 21+buf.1(%rip)
	movq	-32(%rbp), %rax
	movl	(%rax), %eax
	movl	%eax, save_tm.0(%rip)
	movl	4+save_tm.0(%rip), %edx
	movq	-32(%rbp), %rax
	movl	4(%rax), %eax
	cmpl	%eax, %edx
	jne	.L31
	leaq	buf.1(%rip), %rax
	jmp	.L32
.L31:
	movq	-32(%rbp), %rax
	movq	(%rax), %rcx
	movq	8(%rax), %rbx
	movq	%rcx, save_tm.0(%rip)
	movq	%rbx, 8+save_tm.0(%rip)
	movq	16(%rax), %rcx
	movq	24(%rax), %rbx
	movq	%rcx, 16+save_tm.0(%rip)
	movq	%rbx, 24+save_tm.0(%rip)
	movq	32(%rax), %rcx
	movq	40(%rax), %rbx
	movq	%rcx, 32+save_tm.0(%rip)
	movq	%rbx, 40+save_tm.0(%rip)
	movq	48(%rax), %rax
	movq	%rax, 48+save_tm.0(%rip)
	movq	-32(%rbp), %rax
	movq	%rax, %rcx
	leaq	.LC4(%rip), %rax
	movq	%rax, %rdx
	movl	$100, %esi
	leaq	buf.1(%rip), %rax
	movq	%rax, %rdi
	call	strftime@PLT
	leaq	buf.1(%rip), %rax
.L32:
	movq	-24(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L33
	call	__stack_chk_fail@PLT
.L33:
	movq	-8(%rbp), %rbx
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE10:
	.size	http_time, .-http_time
	.section	.rodata
.LC5:
	.string	"Tue, 28 Jan 97 01:20:30 GMT"
	.text
	.globl	date
	.type	date, @function
date:
.LFB11:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -8(%rbp)
	leaq	.LC5(%rip), %rax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE11:
	.size	date, .-date
	.section	.rodata
.LC6:
	.string	".gif"
.LC7:
	.string	"image/gif"
.LC8:
	.string	".jpeg"
.LC9:
	.string	"image/jpeg"
.LC10:
	.string	".html"
.LC11:
	.string	"text/html"
.LC12:
	.string	"text/plain"
	.text
	.globl	type
	.type	type, @function
type:
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
	movq	-24(%rbp), %rax
	movq	%rax, %rdi
	call	strlen@PLT
	movl	%eax, -4(%rbp)
	movl	-4(%rbp), %eax
	cltq
	leaq	-4(%rax), %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	leaq	.LC6(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L37
	leaq	.LC7(%rip), %rax
	jmp	.L38
.L37:
	movl	-4(%rbp), %eax
	cltq
	leaq	-5(%rax), %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	leaq	.LC8(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L39
	leaq	.LC9(%rip), %rax
	jmp	.L38
.L39:
	movl	-4(%rbp), %eax
	cltq
	leaq	-5(%rax), %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	leaq	.LC10(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L40
	leaq	.LC11(%rip), %rax
	jmp	.L38
.L40:
	movl	Dflg(%rip), %eax
	testl	%eax, %eax
	je	.L41
	movq	-24(%rbp), %rax
	movq	%rax, %rdi
	call	isdir
	testl	%eax, %eax
	je	.L41
	leaq	.LC11(%rip), %rax
	jmp	.L38
.L41:
	leaq	.LC12(%rip), %rax
.L38:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE12:
	.size	type, .-type
	.section	.rodata
.LC13:
	.string	"control nbytes"
.LC14:
	.string	"%.*s\n"
.LC15:
	.string	"EXIT"
.LC16:
	.string	"GET /"
.LC17:
	.string	"OPEN %s\n"
.LC18:
	.string	"Couldn't stat %s\n"
	.align 8
.LC19:
	.string	"HTTP/1.0 200 OK\r\n%s\r\nServer: lmhttp/0.1\r\nContent-Type: %s\r\nLast-Modified: %s\r\n\r\n"
.LC20:
	.string	"%s mmap failed\n"
	.text
	.globl	source
	.type	source, @function
source:
.LFB13:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r12
	pushq	%rbx
	subq	$1344, %rsp
	.cfi_offset 12, -24
	.cfi_offset 3, -32
	movl	%edi, -1348(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -24(%rbp)
	xorl	%eax, %eax
	movq	buf(%rip), %rcx
	movl	-1348(%rbp), %eax
	movl	$65536, %edx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	read@PLT
	movl	%eax, -1332(%rbp)
	cmpl	$0, -1332(%rbp)
	jg	.L43
	leaq	.LC13(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$-1, %eax
	jmp	.L67
.L43:
	movq	buf(%rip), %rdx
	movl	-1332(%rbp), %eax
	cltq
	addq	%rdx, %rax
	movb	$0, (%rax)
	movl	dflg(%rip), %eax
	testl	%eax, %eax
	je	.L45
	movq	buf(%rip), %rdx
	movl	-1332(%rbp), %eax
	movl	%eax, %esi
	leaq	.LC14(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf@PLT
.L45:
	movl	zflg(%rip), %eax
	testl	%eax, %eax
	je	.L46
	movl	$0, %eax
	jmp	.L67
.L46:
	movq	buf(%rip), %rax
	movl	$4, %edx
	leaq	.LC15(%rip), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	strncmp@PLT
	testl	%eax, %eax
	jne	.L47
	movl	$0, %edi
	call	exit@PLT
.L47:
	movq	buf(%rip), %rax
	movl	$5, %edx
	leaq	.LC16(%rip), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	strncmp@PLT
	testl	%eax, %eax
	je	.L48
	movq	buf(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$1, %eax
	jmp	.L67
.L48:
	movq	buf(%rip), %rax
	movq	%rax, -1320(%rbp)
	jmp	.L49
.L51:
	addq	$1, -1320(%rbp)
.L49:
	movq	-1320(%rbp), %rax
	movzbl	(%rax), %eax
	testb	%al, %al
	je	.L50
	movq	-1320(%rbp), %rax
	movzbl	(%rax), %eax
	cmpb	$13, %al
	je	.L50
	movq	-1320(%rbp), %rax
	movzbl	(%rax), %eax
	cmpb	$10, %al
	jne	.L51
.L50:
	movq	-1320(%rbp), %rax
	movb	$0, (%rax)
	movq	buf(%rip), %rax
	addq	$5, %rax
	movq	%rax, -1320(%rbp)
	jmp	.L52
.L54:
	addq	$1, -1320(%rbp)
.L52:
	movq	-1320(%rbp), %rax
	movzbl	(%rax), %eax
	testb	%al, %al
	je	.L53
	movq	-1320(%rbp), %rax
	movzbl	(%rax), %eax
	cmpb	$32, %al
	jne	.L54
.L53:
	movq	-1320(%rbp), %rax
	movb	$0, (%rax)
	movl	lflg(%rip), %eax
	testl	%eax, %eax
	je	.L55
	movq	buf(%rip), %rax
	leaq	5(%rax), %rcx
	leaq	-1168(%rbp), %rax
	movl	$100, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	strncpy@PLT
.L55:
	movl	dflg(%rip), %eax
	testl	%eax, %eax
	je	.L56
	movq	buf(%rip), %rax
	addq	$5, %rax
	movq	%rax, %rsi
	leaq	.LC17(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf@PLT
.L56:
	movq	buf(%rip), %rax
	addq	$5, %rax
	movl	$0, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	open@PLT
	movl	%eax, -1328(%rbp)
	cmpl	$-1, -1328(%rbp)
	jne	.L57
	nop
	jmp	.L58
.L69:
	nop
	jmp	.L58
.L70:
	nop
.L58:
	movq	buf(%rip), %rax
	addq	$5, %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	-1328(%rbp), %eax
	movl	%eax, %edi
	call	close@PLT
	movl	$1, %eax
	jmp	.L67
.L57:
	leaq	-1312(%rbp), %rdx
	movl	-1328(%rbp), %eax
	movq	%rdx, %rsi
	movl	%eax, %edi
	call	fstat@PLT
	cmpl	$-1, %eax
	jne	.L59
	movl	dflg(%rip), %eax
	testl	%eax, %eax
	je	.L69
	movq	buf(%rip), %rax
	addq	$5, %rax
	movq	%rax, %rsi
	leaq	.LC18(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf@PLT
	jmp	.L69
.L59:
	movq	-1264(%rbp), %rax
	movl	%eax, -1324(%rbp)
	leaq	-1312(%rbp), %rax
	addq	$88, %rax
	movq	%rax, %rdi
	call	date
	movq	%rax, %r12
	movq	buf(%rip), %rax
	addq	$5, %rax
	movq	%rax, %rdi
	call	type
	movq	%rax, %rbx
	call	http_time
	movq	%rax, %rdx
	leaq	-1056(%rbp), %rax
	movq	%r12, %r8
	movq	%rbx, %rcx
	leaq	.LC19(%rip), %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	sprintf@PLT
	movl	%eax, -1332(%rbp)
	movl	-1332(%rbp), %eax
	movslq	%eax, %rdx
	leaq	-1056(%rbp), %rcx
	movl	-1348(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	write@PLT
	movl	-1332(%rbp), %edx
	movslq	%edx, %rdx
	cmpq	%rdx, %rax
	jne	.L70
	movl	Dflg(%rip), %eax
	testl	%eax, %eax
	je	.L62
	movq	buf(%rip), %rax
	addq	$5, %rax
	movq	%rax, %rdi
	call	isdir
	testl	%eax, %eax
	je	.L62
	movq	buf(%rip), %rax
	leaq	5(%rax), %rdx
	movl	-1348(%rbp), %eax
	movl	%eax, %esi
	movq	%rdx, %rdi
	call	dodir
	jmp	.L63
.L62:
	movl	nflg(%rip), %eax
	testl	%eax, %eax
	je	.L64
	movq	buf(%rip), %rcx
	movl	-1324(%rbp), %edx
	movl	-1348(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	fake
	jmp	.L63
.L64:
	cmpl	$4096, -1324(%rbp)
	jle	.L65
	movl	-1324(%rbp), %edx
	movl	-1348(%rbp), %ecx
	movl	-1328(%rbp), %eax
	movl	%ecx, %esi
	movl	%eax, %edi
	call	mmap_rdwr
	cmpl	$-1, %eax
	jne	.L63
	movq	buf(%rip), %rax
	addq	$5, %rax
	movq	%rax, %rsi
	leaq	.LC20(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf@PLT
	jmp	.L63
.L65:
	movq	buf(%rip), %rdx
	movl	-1348(%rbp), %ecx
	movl	-1328(%rbp), %eax
	movl	%ecx, %esi
	movl	%eax, %edi
	call	rdwr
.L63:
	movl	lflg(%rip), %eax
	testl	%eax, %eax
	je	.L66
	movl	-1324(%rbp), %edx
	leaq	-1168(%rbp), %rcx
	movl	-1348(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	logit
.L66:
	movl	-1328(%rbp), %eax
	movl	%eax, %edi
	call	close@PLT
	movl	$0, %eax
.L67:
	movq	-24(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L68
	call	__stack_chk_fail@PLT
.L68:
	addq	$1344, %rsp
	popq	%rbx
	popq	%r12
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE13:
	.size	source, .-source
	.globl	isdir
	.type	isdir, @function
isdir:
.LFB14:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$176, %rsp
	movq	%rdi, -168(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	leaq	-160(%rbp), %rdx
	movq	-168(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	stat@PLT
	cmpl	$-1, %eax
	jne	.L72
	movl	$0, %eax
	jmp	.L74
.L72:
	movl	-136(%rbp), %eax
	andl	$61440, %eax
	cmpl	$16384, %eax
	sete	%al
	movzbl	%al, %eax
.L74:
	movq	-8(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L75
	call	__stack_chk_fail@PLT
.L75:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE14:
	.size	isdir, .-isdir
	.section	.rodata
.LC21:
	.string	"dodir(%s)\n"
.LC22:
	.string	"cd %s && ls -1a"
.LC23:
	.string	"r"
.LC24:
	.string	"Couldn't popen %s\n"
	.align 8
.LC25:
	.string	"<HTML><HEAD>\n<TITLE>Index of /%s</TITLE></HEAD><BODY><H1>Index of /%s</H1>\n"
.LC26:
	.string	"/%s/%s"
.LC27:
	.string	"\t%s\n"
.LC28:
	.string	"<A HREF=\""
.LC29:
	.string	"\">"
.LC30:
	.string	"</A><BR>\n"
	.text
	.globl	dodir
	.type	dodir, @function
dodir:
.LFB15:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$2096, %rsp
	movq	%rdi, -2088(%rbp)
	movl	%esi, -2092(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movl	dflg(%rip), %eax
	testl	%eax, %eax
	je	.L77
	movq	-2088(%rbp), %rax
	movq	%rax, %rsi
	leaq	.LC21(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf@PLT
.L77:
	movq	-2088(%rbp), %rdx
	leaq	-2064(%rbp), %rax
	leaq	.LC22(%rip), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	sprintf@PLT
	leaq	-2064(%rbp), %rax
	leaq	.LC23(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	popen@PLT
	movq	%rax, -2072(%rbp)
	cmpq	$0, -2072(%rbp)
	jne	.L78
	movl	dflg(%rip), %eax
	testl	%eax, %eax
	je	.L78
	leaq	-2064(%rbp), %rax
	movq	%rax, %rsi
	leaq	.LC24(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf@PLT
.L78:
	movq	-2088(%rbp), %rcx
	movq	-2088(%rbp), %rdx
	leaq	-2064(%rbp), %rax
	leaq	.LC25(%rip), %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	sprintf@PLT
	leaq	-2064(%rbp), %rax
	movq	%rax, %rdi
	call	strlen@PLT
	movq	%rax, %rdx
	leaq	-2064(%rbp), %rcx
	movl	-2092(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	write@PLT
	jmp	.L79
.L81:
	leaq	-2064(%rbp), %rax
	movq	%rax, %rdi
	call	strlen@PLT
	subq	$1, %rax
	movb	$0, -2064(%rbp,%rax)
	leaq	-2064(%rbp), %rcx
	movq	-2088(%rbp), %rdx
	leaq	-1040(%rbp), %rax
	leaq	.LC26(%rip), %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	sprintf@PLT
	movl	dflg(%rip), %eax
	testl	%eax, %eax
	je	.L80
	leaq	-1040(%rbp), %rax
	movq	%rax, %rsi
	leaq	.LC27(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf@PLT
.L80:
	movl	-2092(%rbp), %eax
	movl	$9, %edx
	leaq	.LC28(%rip), %rcx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	write@PLT
	leaq	-1040(%rbp), %rax
	movq	%rax, %rdi
	call	strlen@PLT
	movq	%rax, %rdx
	leaq	-1040(%rbp), %rcx
	movl	-2092(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	write@PLT
	movl	-2092(%rbp), %eax
	movl	$2, %edx
	leaq	.LC29(%rip), %rcx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	write@PLT
	leaq	-2064(%rbp), %rax
	movq	%rax, %rdi
	call	strlen@PLT
	movq	%rax, %rdx
	leaq	-2064(%rbp), %rcx
	movl	-2092(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	write@PLT
	movl	-2092(%rbp), %eax
	movl	$9, %edx
	leaq	.LC30(%rip), %rcx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	write@PLT
.L79:
	movq	-2072(%rbp), %rdx
	leaq	-2064(%rbp), %rax
	movl	$1024, %esi
	movq	%rax, %rdi
	call	fgets@PLT
	testq	%rax, %rax
	jne	.L81
	movq	-2072(%rbp), %rax
	movq	%rax, %rdi
	call	pclose@PLT
	nop
	movq	-8(%rbp), %rax
	subq	%fs:40, %rax
	je	.L82
	call	__stack_chk_fail@PLT
.L82:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE15:
	.size	dodir, .-dodir
	.section	.rodata
.LC31:
	.string	"write on socket"
	.text
	.globl	fake
	.type	fake, @function
fake:
.LFB16:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movl	%edi, -20(%rbp)
	movq	%rsi, -32(%rbp)
	movl	%edx, -24(%rbp)
	jmp	.L84
.L87:
	movl	-24(%rbp), %eax
	movl	$65536, %edx
	cmpl	%edx, %eax
	cmovg	%edx, %eax
	movslq	%eax, %rdx
	movq	-32(%rbp), %rcx
	movl	-20(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	write@PLT
	movl	%eax, -4(%rbp)
	cmpl	$-1, -4(%rbp)
	jne	.L85
	leaq	.LC31(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	jmp	.L83
.L85:
	movl	-4(%rbp), %eax
	subl	%eax, -24(%rbp)
.L84:
	cmpl	$0, -24(%rbp)
	jg	.L87
.L83:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE16:
	.size	fake, .-fake
	.globl	rdwr
	.type	rdwr, @function
rdwr:
.LFB17:
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
	movq	%rdx, -32(%rbp)
	jmp	.L89
.L93:
	movl	$0, -12(%rbp)
	jmp	.L90
.L92:
	movl	-8(%rbp), %eax
	subl	-12(%rbp), %eax
	movslq	%eax, %rdx
	movq	-32(%rbp), %rcx
	movl	-24(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	write@PLT
	movl	%eax, -4(%rbp)
	cmpl	$0, -12(%rbp)
	jns	.L91
	movl	$1, %edi
	call	exit@PLT
.L91:
	movl	-4(%rbp), %eax
	addl	%eax, -12(%rbp)
.L90:
	movl	-12(%rbp), %eax
	cmpl	-8(%rbp), %eax
	jl	.L92
.L89:
	movq	-32(%rbp), %rcx
	movl	-20(%rbp), %eax
	movl	$65536, %edx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	read@PLT
	movl	%eax, -8(%rbp)
	cmpl	$0, -8(%rbp)
	jg	.L93
	nop
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE17:
	.size	rdwr, .-rdwr
	.section	.rodata
.LC32:
	.string	"mmap"
.LC33:
	.string	"write"
.LC34:
	.string	"unmap"
	.text
	.globl	mmap_rdwr
	.type	mmap_rdwr, @function
mmap_rdwr:
.LFB18:
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
	movl	%edx, -28(%rbp)
	movl	$0, -16(%rbp)
	movl	-28(%rbp), %eax
	cltq
	movl	-20(%rbp), %edx
	movl	$0, %r9d
	movl	%edx, %r8d
	movl	$1, %ecx
	movl	$1, %edx
	movq	%rax, %rsi
	movl	$0, %edi
	call	mmap@PLT
	movq	%rax, -8(%rbp)
	cmpq	$-1, -8(%rbp)
	jne	.L95
	leaq	.LC32(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$-1, %eax
	jmp	.L96
.L95:
	movl	-28(%rbp), %eax
	subl	-16(%rbp), %eax
	movslq	%eax, %rdx
	movl	-16(%rbp), %eax
	movslq	%eax, %rcx
	movq	-8(%rbp), %rax
	addq	%rax, %rcx
	movl	-24(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	write@PLT
	movl	%eax, -12(%rbp)
	cmpl	$-1, -12(%rbp)
	jne	.L97
	leaq	.LC33(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	jmp	.L98
.L97:
	movl	-12(%rbp), %eax
	addl	%eax, -16(%rbp)
	movl	-16(%rbp), %eax
	cmpl	-28(%rbp), %eax
	jl	.L95
.L98:
	movl	-28(%rbp), %eax
	movslq	%eax, %rdx
	movq	-8(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	munmap@PLT
	cmpl	$-1, %eax
	jne	.L99
	leaq	.LC34(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
.L99:
	movl	$0, %eax
.L96:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE18:
	.size	mmap_rdwr, .-mmap_rdwr
	.local	logbuf
	.comm	logbuf,65536,32
	.local	nbytes
	.comm	nbytes,4,4
	.section	.rodata
.LC35:
	.string	"getpeername"
.LC36:
	.string	"%u %u %s %u\n"
	.text
	.globl	logit
	.type	logit, @function
logit:
.LFB19:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$1104, %rsp
	movl	%edi, -1092(%rbp)
	movq	%rsi, -1104(%rbp)
	movl	%edx, -1096(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movl	$16, -1076(%rbp)
	leaq	-1076(%rbp), %rdx
	leaq	-1072(%rbp), %rcx
	movl	-1092(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	getpeername@PLT
	cmpl	$-1, %eax
	jne	.L101
	leaq	.LC35(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	jmp	.L100
.L101:
	movl	$0, %edi
	call	time@PLT
	movl	%eax, %edi
	leaq	-1072(%rbp), %rax
	addq	$4, %rax
	movl	(%rax), %edx
	movl	-1096(%rbp), %esi
	movq	-1104(%rbp), %rcx
	leaq	-1056(%rbp), %rax
	movl	%esi, %r9d
	movq	%rcx, %r8
	movl	%edi, %ecx
	leaq	.LC36(%rip), %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	sprintf@PLT
	movl	%eax, -1076(%rbp)
	movl	nbytes(%rip), %eax
	movl	%eax, %edx
	movl	-1076(%rbp), %eax
	addl	%edx, %eax
	cmpl	$65535, %eax
	jbe	.L103
	movl	nbytes(%rip), %eax
	movslq	%eax, %rdx
	movl	logfile(%rip), %eax
	leaq	logbuf(%rip), %rcx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	write@PLT
	movl	$0, nbytes(%rip)
.L103:
	movl	-1076(%rbp), %eax
	movl	%eax, %esi
	movl	nbytes(%rip), %eax
	cltq
	leaq	logbuf(%rip), %rdx
	addq	%rax, %rdx
	leaq	-1056(%rbp), %rax
	movq	%rdx, %rcx
	movq	%rsi, %rdx
	movq	%rax, %rsi
	movq	%rcx, %rdi
	call	memcpy@PLT
	movl	nbytes(%rip), %eax
	movl	%eax, %edx
	movl	-1076(%rbp), %eax
	addl	%edx, %eax
	movl	%eax, nbytes(%rip)
.L100:
	movq	-8(%rbp), %rax
	subq	%fs:40, %rax
	je	.L104
	call	__stack_chk_fail@PLT
.L104:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE19:
	.size	logit, .-logit
	.globl	die
	.type	die, @function
die:
.LFB20:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	nbytes(%rip), %eax
	testl	%eax, %eax
	je	.L106
	movl	nbytes(%rip), %eax
	movslq	%eax, %rdx
	movl	logfile(%rip), %eax
	leaq	logbuf(%rip), %rcx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	write@PLT
	movl	$0, nbytes(%rip)
.L106:
	movl	$1, %edi
	call	exit@PLT
	.cfi_endproc
.LFE20:
	.size	die, .-die
	.local	save_tt.2
	.comm	save_tt.2,8,8
	.local	buf.1
	.comm	buf.1,100,32
	.local	save_tm.0
	.comm	save_tm.0,56,32
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
