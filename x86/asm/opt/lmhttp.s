	.file	"lmhttp.c"
	.text
	.globl	die
	.type	die, @function
die:
.LFB84:
	.cfi_startproc
	endbr64
	pushq	%rax
	.cfi_def_cfa_offset 16
	popq	%rax
	.cfi_def_cfa_offset 8
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	movl	nbytes(%rip), %edx
	testl	%edx, %edx
	jne	.L4
.L2:
	movl	$1, %edi
	call	exit@PLT
.L4:
	movslq	%edx, %rdx
	leaq	logbuf(%rip), %rsi
	movl	logfile(%rip), %edi
	call	write@PLT
	movl	$0, nbytes(%rip)
	jmp	.L2
	.cfi_endproc
.LFE84:
	.size	die, .-die
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"%a, %d %b %y %H:%M:%S %Z"
	.text
	.globl	http_time
	.type	http_time, @function
http_time:
.LFB74:
	.cfi_startproc
	endbr64
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	subq	$16, %rsp
	.cfi_def_cfa_offset 32
	movq	%fs:40, %rax
	movq	%rax, 8(%rsp)
	xorl	%eax, %eax
	movq	%rsp, %rdi
	call	time@PLT
	movq	(%rsp), %rbx
	cmpq	save_tt.2(%rip), %rbx
	je	.L6
	movq	%rbx, save_tt.2(%rip)
	movq	%rsp, %rdi
	call	gmtime@PLT
	movq	%rax, %rcx
	cmpb	$0, buf.1(%rip)
	je	.L7
	movq	(%rsp), %rax
	subq	%rbx, %rax
	cmpq	$3599, %rax
	jg	.L7
	movl	(%rcx), %edx
	movslq	%edx, %rax
	imulq	$1717986919, %rax, %rax
	sarq	$34, %rax
	sarl	$31, %edx
	subl	%edx, %eax
	addl	$48, %eax
	movb	%al, 22+buf.1(%rip)
	movl	(%rcx), %edx
	movslq	%edx, %rax
	imulq	$1717986919, %rax, %rax
	sarq	$34, %rax
	movl	%edx, %esi
	sarl	$31, %esi
	subl	%esi, %eax
	leal	(%rax,%rax,4), %eax
	addl	%eax, %eax
	subl	%eax, %edx
	addl	$48, %edx
	movb	%dl, 21+buf.1(%rip)
	movl	(%rcx), %eax
	movl	%eax, save_tm.0(%rip)
	movl	4(%rcx), %eax
	cmpl	%eax, 4+save_tm.0(%rip)
	je	.L6
.L7:
	movdqu	(%rcx), %xmm0
	movaps	%xmm0, save_tm.0(%rip)
	movdqu	16(%rcx), %xmm1
	movaps	%xmm1, 16+save_tm.0(%rip)
	movdqu	32(%rcx), %xmm2
	movaps	%xmm2, 32+save_tm.0(%rip)
	movq	48(%rcx), %rax
	movq	%rax, 48+save_tm.0(%rip)
	leaq	.LC0(%rip), %rdx
	movl	$100, %esi
	leaq	buf.1(%rip), %rdi
	call	strftime@PLT
.L6:
	movq	8(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L10
	leaq	buf.1(%rip), %rax
	addq	$16, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 16
	popq	%rbx
	.cfi_def_cfa_offset 8
	ret
.L10:
	.cfi_restore_state
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE74:
	.size	http_time, .-http_time
	.section	.rodata.str1.1
.LC1:
	.string	"Tue, 28 Jan 97 01:20:30 GMT"
	.text
	.globl	date
	.type	date, @function
date:
.LFB75:
	.cfi_startproc
	endbr64
	leaq	.LC1(%rip), %rax
	ret
	.cfi_endproc
.LFE75:
	.size	date, .-date
	.globl	isdir
	.type	isdir, @function
isdir:
.LFB78:
	.cfi_startproc
	endbr64
	subq	$168, %rsp
	.cfi_def_cfa_offset 176
	movq	%fs:40, %rax
	movq	%rax, 152(%rsp)
	xorl	%eax, %eax
	movq	%rsp, %rsi
	call	stat@PLT
	movl	%eax, %edx
	movl	$0, %eax
	cmpl	$-1, %edx
	je	.L12
	movl	24(%rsp), %eax
	andl	$61440, %eax
	cmpl	$16384, %eax
	sete	%al
	movzbl	%al, %eax
.L12:
	movq	152(%rsp), %rdx
	subq	%fs:40, %rdx
	jne	.L17
	addq	$168, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	ret
.L17:
	.cfi_restore_state
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE78:
	.size	isdir, .-isdir
	.section	.rodata.str1.1
.LC2:
	.string	"image/gif"
.LC3:
	.string	"image/jpeg"
.LC4:
	.string	"text/html"
.LC5:
	.string	"text/plain"
.LC6:
	.string	".gif"
.LC7:
	.string	".jpeg"
.LC8:
	.string	".html"
	.text
	.globl	type
	.type	type, @function
type:
.LFB76:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushq	%rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	subq	$8, %rsp
	.cfi_def_cfa_offset 32
	movq	%rdi, %rbx
	call	strlen@PLT
	movslq	%eax, %rbp
	leaq	-4(%rbx,%rbp), %rdi
	leaq	.LC6(%rip), %rsi
	call	strcmp@PLT
	movl	%eax, %edx
	leaq	.LC2(%rip), %rax
	testl	%edx, %edx
	je	.L18
	leaq	-5(%rbx,%rbp), %rbp
	leaq	.LC7(%rip), %rsi
	movq	%rbp, %rdi
	call	strcmp@PLT
	movl	%eax, %edx
	leaq	.LC3(%rip), %rax
	testl	%edx, %edx
	je	.L18
	leaq	.LC8(%rip), %rsi
	movq	%rbp, %rdi
	call	strcmp@PLT
	movl	%eax, %edx
	leaq	.LC4(%rip), %rax
	testl	%edx, %edx
	je	.L18
	leaq	.LC5(%rip), %rax
	cmpl	$0, Dflg(%rip)
	jne	.L26
.L18:
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
	movq	%rbx, %rdi
	call	isdir
	testl	%eax, %eax
	leaq	.LC5(%rip), %rax
	leaq	.LC4(%rip), %rdx
	cmovne	%rdx, %rax
	jmp	.L18
	.cfi_endproc
.LFE76:
	.size	type, .-type
	.section	.rodata.str1.1
.LC9:
	.string	"dodir(%s)\n"
.LC10:
	.string	"cd %s && ls -1a"
.LC11:
	.string	"r"
.LC12:
	.string	"Couldn't popen %s\n"
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC13:
	.string	"<HTML><HEAD>\n<TITLE>Index of /%s</TITLE></HEAD><BODY><H1>Index of /%s</H1>\n"
	.section	.rodata.str1.1
.LC14:
	.string	"/%s/%s"
.LC15:
	.string	"\t%s\n"
.LC16:
	.string	"<A HREF=\""
.LC17:
	.string	"\">"
.LC18:
	.string	"</A><BR>\n"
	.text
	.globl	dodir
	.type	dodir, @function
dodir:
.LFB79:
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
	subq	$2072, %rsp
	.cfi_def_cfa_offset 2128
	movq	%rdi, %r12
	movl	%esi, %ebx
	movq	%fs:40, %rax
	movq	%rax, 2056(%rsp)
	xorl	%eax, %eax
	cmpl	$0, dflg(%rip)
	jne	.L35
.L28:
	movq	%rsp, %rbp
	movq	%r12, %r8
	leaq	.LC10(%rip), %rcx
	movl	$1024, %edx
	movl	$1, %esi
	movq	%rbp, %rdi
	movl	$0, %eax
	call	__sprintf_chk@PLT
	leaq	.LC11(%rip), %rsi
	movq	%rbp, %rdi
	call	popen@PLT
	movq	%rax, %r13
	testq	%rax, %rax
	je	.L36
.L29:
	movq	%rsp, %rbp
	movq	%r12, %r9
	movq	%r12, %r8
	leaq	.LC13(%rip), %rcx
	movl	$1024, %edx
	movl	$1, %esi
	movq	%rbp, %rdi
	movl	$0, %eax
	call	__sprintf_chk@PLT
	movq	%rbp, %rdi
	call	strlen@PLT
	movq	%rax, %rdx
	movq	%rbp, %rsi
	movl	%ebx, %edi
	call	write@PLT
	leaq	.LC14(%rip), %r15
	leaq	.LC16(%rip), %r14
	jmp	.L30
.L35:
	movq	%rdi, %rdx
	leaq	.LC9(%rip), %rsi
	movl	$1, %edi
	call	__printf_chk@PLT
	jmp	.L28
.L36:
	cmpl	$0, dflg(%rip)
	je	.L29
	movq	%rsp, %rdx
	leaq	.LC12(%rip), %rsi
	movl	$1, %edi
	movl	$0, %eax
	call	__printf_chk@PLT
	jmp	.L29
.L31:
	movl	$9, %edx
	movq	%r14, %rsi
	movl	%ebx, %edi
	call	write@PLT
	leaq	1024(%rsp), %rbp
	movq	%rbp, %rdi
	call	strlen@PLT
	movq	%rax, %rdx
	movq	%rbp, %rsi
	movl	%ebx, %edi
	call	write@PLT
	movl	$2, %edx
	leaq	.LC17(%rip), %rsi
	movl	%ebx, %edi
	call	write@PLT
	movq	%rsp, %rbp
	movq	%rbp, %rdi
	call	strlen@PLT
	movq	%rax, %rdx
	movq	%rbp, %rsi
	movl	%ebx, %edi
	call	write@PLT
	movl	$9, %edx
	leaq	.LC18(%rip), %rsi
	movl	%ebx, %edi
	call	write@PLT
.L30:
	movq	%rsp, %rdi
	movq	%r13, %rdx
	movl	$1024, %esi
	call	fgets@PLT
	testq	%rax, %rax
	je	.L37
	movq	%rsp, %rbp
	movq	%rbp, %rdi
	call	strlen@PLT
	movb	$0, -1(%rsp,%rax)
	leaq	1024(%rsp), %rdi
	movq	%rbp, %r9
	movq	%r12, %r8
	movq	%r15, %rcx
	movl	$1024, %edx
	movl	$1, %esi
	movl	$0, %eax
	call	__sprintf_chk@PLT
	cmpl	$0, dflg(%rip)
	je	.L31
	leaq	1024(%rsp), %rdx
	leaq	.LC15(%rip), %rsi
	movl	$1, %edi
	movl	$0, %eax
	call	__printf_chk@PLT
	jmp	.L31
.L37:
	movq	%r13, %rdi
	call	pclose@PLT
	movq	2056(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L38
	addq	$2072, %rsp
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
.L38:
	.cfi_restore_state
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE79:
	.size	dodir, .-dodir
	.section	.rodata.str1.1
.LC19:
	.string	"write on socket"
	.text
	.globl	fake
	.type	fake, @function
fake:
.LFB80:
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
	movl	%edi, %r12d
	movq	%rsi, %rbp
	movl	%edx, %ebx
	testl	%edx, %edx
	jle	.L39
.L42:
	movl	$65536, %edx
	cmpl	%edx, %ebx
	cmovle	%ebx, %edx
	movslq	%edx, %rdx
	movq	%rbp, %rsi
	movl	%r12d, %edi
	call	write@PLT
	cmpl	$-1, %eax
	je	.L45
	subl	%eax, %ebx
	testl	%ebx, %ebx
	jg	.L42
	jmp	.L39
.L45:
	leaq	.LC19(%rip), %rdi
	call	perror@PLT
.L39:
	popq	%rbx
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE80:
	.size	fake, .-fake
	.globl	rdwr
	.type	rdwr, @function
rdwr:
.LFB81:
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
	movl	%edi, %r14d
	movl	%esi, %r13d
	movq	%rdx, %r12
.L47:
	movl	$65536, %edx
	movq	%r12, %rsi
	movl	%r14d, %edi
	call	read@PLT
	movl	%eax, %ebp
	testl	%eax, %eax
	jle	.L52
	movslq	%eax, %rdx
	movq	%r12, %rsi
	movl	%r13d, %edi
	call	write@PLT
	movl	$0, %ebx
.L48:
	addl	%eax, %ebx
	cmpl	%ebx, %ebp
	jle	.L47
	movl	%ebp, %edx
	subl	%ebx, %edx
	movslq	%edx, %rdx
	movq	%r12, %rsi
	movl	%r13d, %edi
	call	write@PLT
	testl	%ebx, %ebx
	jns	.L48
	movl	$1, %edi
	call	exit@PLT
.L52:
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
	.cfi_endproc
.LFE81:
	.size	rdwr, .-rdwr
	.section	.rodata.str1.1
.LC20:
	.string	"mmap"
.LC21:
	.string	"write"
.LC22:
	.string	"unmap"
	.text
	.globl	mmap_rdwr
	.type	mmap_rdwr, @function
mmap_rdwr:
.LFB82:
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
	movl	%edi, %r8d
	movl	%esi, %r13d
	movl	%edx, %ebp
	movslq	%edx, %r14
	movl	$0, %r9d
	movl	$1, %ecx
	movl	$1, %edx
	movq	%r14, %rsi
	movl	$0, %edi
	call	mmap@PLT
	cmpq	$-1, %rax
	je	.L63
	movq	%rax, %r12
	movl	$0, %ebx
.L55:
	movl	%ebp, %edx
	subl	%ebx, %edx
	movslq	%edx, %rdx
	movslq	%ebx, %rsi
	addq	%r12, %rsi
	movl	%r13d, %edi
	call	write@PLT
	cmpl	$-1, %eax
	je	.L64
	addl	%eax, %ebx
	cmpl	%ebx, %ebp
	jg	.L55
	jmp	.L58
.L63:
	leaq	.LC20(%rip), %rdi
	call	perror@PLT
	movl	$-1, %eax
	jmp	.L54
.L64:
	leaq	.LC21(%rip), %rdi
	call	perror@PLT
.L58:
	movq	%r14, %rsi
	movq	%r12, %rdi
	call	munmap@PLT
	movl	%eax, %edx
	movl	$0, %eax
	cmpl	$-1, %edx
	je	.L65
.L54:
	popq	%rbx
	.cfi_remember_state
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
.L65:
	.cfi_restore_state
	leaq	.LC22(%rip), %rdi
	call	perror@PLT
	movl	$0, %eax
	jmp	.L54
	.cfi_endproc
.LFE82:
	.size	mmap_rdwr, .-mmap_rdwr
	.section	.rodata.str1.1
.LC23:
	.string	"getpeername"
.LC24:
	.string	"%u %u %s %u\n"
	.text
	.globl	logit
	.type	logit, @function
logit:
.LFB83:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushq	%rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	subq	$1096, %rsp
	.cfi_def_cfa_offset 1120
	movq	%rsi, %rbx
	movl	%edx, %ebp
	movq	%fs:40, %rax
	movq	%rax, 1080(%rsp)
	xorl	%eax, %eax
	movl	$16, 12(%rsp)
	leaq	12(%rsp), %rdx
	leaq	16(%rsp), %rsi
	call	getpeername@PLT
	cmpl	$-1, %eax
	je	.L72
	movl	$0, %edi
	call	time@PLT
	leaq	32(%rsp), %rdi
	pushq	%rbp
	.cfi_def_cfa_offset 1128
	pushq	%rbx
	.cfi_def_cfa_offset 1136
	movl	%eax, %r9d
	movl	36(%rsp), %r8d
	leaq	.LC24(%rip), %rcx
	movl	$1040, %edx
	movl	$1, %esi
	movl	$0, %eax
	call	__sprintf_chk@PLT
	movl	%eax, 28(%rsp)
	movl	nbytes(%rip), %edx
	addl	%edx, %eax
	addq	$16, %rsp
	.cfi_def_cfa_offset 1120
	cmpl	$65535, %eax
	ja	.L73
.L69:
	movl	12(%rsp), %ebp
	movl	nbytes(%rip), %ebx
	movslq	%ebx, %rdi
	leaq	logbuf(%rip), %rax
	addq	%rax, %rdi
	movl	%ebp, %edx
	leaq	32(%rsp), %rsi
	call	memcpy@PLT
	addl	%ebp, %ebx
	movl	%ebx, nbytes(%rip)
.L66:
	movq	1080(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L74
	addq	$1096, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
.L72:
	.cfi_restore_state
	leaq	.LC23(%rip), %rdi
	call	perror@PLT
	jmp	.L66
.L73:
	movslq	%edx, %rdx
	leaq	logbuf(%rip), %rsi
	movl	logfile(%rip), %edi
	call	write@PLT
	movl	$0, nbytes(%rip)
	jmp	.L69
.L74:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE83:
	.size	logit, .-logit
	.section	.rodata.str1.1
.LC25:
	.string	"control nbytes"
.LC26:
	.string	"%.*s\n"
.LC27:
	.string	"EXIT"
.LC28:
	.string	"GET /"
.LC29:
	.string	"OPEN %s\n"
.LC30:
	.string	"Couldn't stat %s\n"
	.section	.rodata.str1.8
	.align 8
.LC31:
	.string	"HTTP/1.0 200 OK\r\n%s\r\nServer: lmhttp/0.1\r\nContent-Type: %s\r\nLast-Modified: %s\r\n\r\n"
	.section	.rodata.str1.1
.LC32:
	.string	"%s mmap failed\n"
	.text
	.globl	source
	.type	source, @function
source:
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
	subq	$1304, %rsp
	.cfi_def_cfa_offset 1360
	movl	%edi, %ebp
	movq	%fs:40, %rax
	movq	%rax, 1288(%rsp)
	xorl	%eax, %eax
	movl	$65536, %edx
	movq	buf(%rip), %rsi
	call	read@PLT
	testl	%eax, %eax
	jle	.L101
	movl	%eax, %edx
	cltq
	movq	buf(%rip), %rcx
	movb	$0, (%rcx,%rax)
	cmpl	$0, dflg(%rip)
	jne	.L102
.L78:
	cmpl	$0, zflg(%rip)
	jne	.L97
	movq	buf(%rip), %rbx
	movl	$4, %edx
	leaq	.LC27(%rip), %rsi
	movq	%rbx, %rdi
	call	strncmp@PLT
	testl	%eax, %eax
	je	.L103
	movl	$5, %edx
	leaq	.LC28(%rip), %rsi
	movq	%rbx, %rdi
	call	strncmp@PLT
	movl	%eax, %r12d
	testl	%eax, %eax
	jne	.L80
	movzbl	(%rbx), %eax
	cmpb	$13, %al
	ja	.L81
	movl	$9217, %edx
	btq	%rax, %rdx
	jc	.L82
.L81:
	movl	$9217, %edx
.L99:
	addq	$1, %rbx
	movzbl	(%rbx), %eax
	cmpb	$13, %al
	ja	.L99
	btq	%rax, %rdx
	jnc	.L99
.L82:
	movb	$0, (%rbx)
	movq	buf(%rip), %rdx
	leaq	5(%rdx), %rax
	testb	$-33, 5(%rdx)
	je	.L84
.L85:
	addq	$1, %rax
	testb	$-33, (%rax)
	jne	.L85
.L84:
	movb	$0, (%rax)
	cmpl	$0, lflg(%rip)
	jne	.L104
.L86:
	cmpl	$0, dflg(%rip)
	jne	.L105
.L87:
	movq	buf(%rip), %rax
	leaq	5(%rax), %rdi
	movl	$0, %esi
	movl	$0, %eax
	call	open@PLT
	movl	%eax, %ebx
	cmpl	$-1, %eax
	je	.L89
	movq	%rsp, %rsi
	movl	%eax, %edi
	call	fstat@PLT
	cmpl	$-1, %eax
	je	.L106
	movq	48(%rsp), %r15
	movq	buf(%rip), %rax
	leaq	5(%rax), %rdi
	call	type
	movq	%rax, %r13
	call	http_time
	movq	%rax, %r8
	leaq	256(%rsp), %r14
	subq	$8, %rsp
	.cfi_def_cfa_offset 1368
	leaq	.LC1(%rip), %rax
	pushq	%rax
	.cfi_def_cfa_offset 1376
	movq	%r13, %r9
	leaq	.LC31(%rip), %rcx
	movl	$1024, %edx
	movl	$1, %esi
	movq	%r14, %rdi
	movl	$0, %eax
	call	__sprintf_chk@PLT
	movslq	%eax, %r13
	movq	%r13, %rdx
	movq	%r14, %rsi
	movl	%ebp, %edi
	call	write@PLT
	addq	$16, %rsp
	.cfi_def_cfa_offset 1360
	cmpq	%r13, %rax
	jne	.L89
	movl	%r15d, %r13d
	cmpl	$0, Dflg(%rip)
	jne	.L107
.L91:
	cmpl	$0, nflg(%rip)
	jne	.L108
	cmpl	$4096, %r15d
	jle	.L94
	movl	%r13d, %edx
	movl	%ebp, %esi
	movl	%ebx, %edi
	call	mmap_rdwr
	cmpl	$-1, %eax
	jne	.L92
	movq	buf(%rip), %rax
	leaq	5(%rax), %rdx
	leaq	.LC32(%rip), %rsi
	movl	$1, %edi
	movl	$0, %eax
	call	__printf_chk@PLT
	jmp	.L92
.L101:
	leaq	.LC25(%rip), %rdi
	call	perror@PLT
	movl	$-1, %r12d
	jmp	.L75
.L102:
	movq	buf(%rip), %rcx
	leaq	.LC26(%rip), %rsi
	movl	$1, %edi
	movl	$0, %eax
	call	__printf_chk@PLT
	jmp	.L78
.L103:
	movl	$0, %edi
	call	exit@PLT
.L80:
	movq	%rbx, %rdi
	call	perror@PLT
	movl	$1, %r12d
	jmp	.L75
.L104:
	movq	buf(%rip), %rax
	leaq	5(%rax), %rsi
	leaq	144(%rsp), %rdi
	movl	$100, %edx
	call	strncpy@PLT
	jmp	.L86
.L105:
	movq	buf(%rip), %rax
	leaq	5(%rax), %rdx
	leaq	.LC29(%rip), %rsi
	movl	$1, %edi
	movl	$0, %eax
	call	__printf_chk@PLT
	jmp	.L87
.L106:
	cmpl	$0, dflg(%rip)
	jne	.L109
.L89:
	movq	buf(%rip), %rax
	leaq	5(%rax), %rdi
	call	perror@PLT
	movl	%ebx, %edi
	call	close@PLT
	movl	$1, %r12d
	jmp	.L75
.L109:
	movq	buf(%rip), %rax
	leaq	5(%rax), %rdx
	leaq	.LC30(%rip), %rsi
	movl	$1, %edi
	movl	$0, %eax
	call	__printf_chk@PLT
	jmp	.L89
.L107:
	movq	buf(%rip), %rax
	leaq	5(%rax), %rdi
	call	isdir
	testl	%eax, %eax
	je	.L91
	movq	buf(%rip), %rax
	leaq	5(%rax), %rdi
	movl	%ebp, %esi
	call	dodir
	jmp	.L92
.L108:
	movl	%r13d, %edx
	movq	buf(%rip), %rsi
	movl	%ebp, %edi
	call	fake
	jmp	.L92
.L94:
	movq	buf(%rip), %rdx
	movl	%ebp, %esi
	movl	%ebx, %edi
	call	rdwr
.L92:
	cmpl	$0, lflg(%rip)
	jne	.L110
.L95:
	movl	%ebx, %edi
	call	close@PLT
	jmp	.L75
.L110:
	leaq	144(%rsp), %rsi
	movl	%r13d, %edx
	movl	%ebp, %edi
	call	logit
	jmp	.L95
.L97:
	movl	$0, %r12d
.L75:
	movq	1288(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L111
	movl	%r12d, %eax
	addq	$1304, %rsp
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
.L111:
	.cfi_restore_state
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE77:
	.size	source, .-source
	.globl	worker
	.type	worker, @function
worker:
.LFB73:
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
	movq	bufs(%rip), %rax
	movl	$1, %ebx
	leaq	bufs(%rip), %r12
.L113:
	movq	%rax, buf(%rip)
	movl	$8, %esi
	movl	data(%rip), %edi
	call	tcp_accept@PLT
	movl	%eax, %ebp
	movl	%eax, %edi
	call	source
	movl	%ebp, %edi
	call	close@PLT
	movslq	%ebx, %rax
	movq	(%r12,%rax,8), %rax
	addl	$1, %ebx
	cmpl	$3, %ebx
	movl	$0, %edx
	cmove	%edx, %ebx
	jmp	.L113
	.cfi_endproc
.LFE73:
	.size	worker, .-worker
	.section	.rodata.str1.1
.LC33:
	.string	"Barf.\n"
.LC34:
	.string	"DOCROOT"
.LC35:
	.string	"/usr/tmp/lmhttp.log"
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
	movl	%edi, %r12d
	movq	%rsi, %r13
	cmpl	$1, %edi
	jle	.L118
	leaq	8(%rsi), %rbx
	leal	-2(%rdi), %eax
	leaq	16(%rsi,%rax,8), %r14
	leaq	.L122(%rip), %rbp
	jmp	.L128
.L119:
	movl	$1, Dflg(%rip)
.L127:
	addq	$8, %rbx
	cmpq	%r14, %rbx
	je	.L118
.L128:
	movq	(%rbx), %rdi
	cmpb	$45, (%rdi)
	jne	.L118
	movzbl	1(%rdi), %eax
	cmpb	$68, %al
	je	.L119
	leal	-100(%rax), %edx
	cmpb	$22, %dl
	ja	.L120
	ja	.L120
	movzbl	%dl, %eax
	movslq	0(%rbp,%rax,4), %rax
	addq	%rbp, %rax
	notrack jmp	*%rax
	.section	.rodata
	.align 4
	.align 4
.L122:
	.long	.L126-.L122
	.long	.L120-.L122
	.long	.L125-.L122
	.long	.L120-.L122
	.long	.L120-.L122
	.long	.L120-.L122
	.long	.L120-.L122
	.long	.L120-.L122
	.long	.L124-.L122
	.long	.L120-.L122
	.long	.L123-.L122
	.long	.L120-.L122
	.long	.L120-.L122
	.long	.L120-.L122
	.long	.L120-.L122
	.long	.L120-.L122
	.long	.L120-.L122
	.long	.L120-.L122
	.long	.L120-.L122
	.long	.L120-.L122
	.long	.L120-.L122
	.long	.L120-.L122
	.long	.L121-.L122
	.text
.L126:
	movl	$1, dflg(%rip)
	jmp	.L127
.L125:
	addq	$2, %rdi
	movl	$10, %edx
	movl	$0, %esi
	call	strtol@PLT
	movl	%eax, fflg(%rip)
	jmp	.L127
.L124:
	movl	$1, lflg(%rip)
	jmp	.L127
.L123:
	movl	$1, nflg(%rip)
	jmp	.L127
.L121:
	movl	$1, zflg(%rip)
	jmp	.L127
.L120:
	movq	stderr(%rip), %rcx
	movl	$6, %edx
	movl	$1, %esi
	leaq	.LC33(%rip), %rdi
	call	fwrite@PLT
	movl	$1, %edi
	call	exit@PLT
.L118:
	leaq	.LC34(%rip), %rdi
	call	getenv@PLT
	testq	%rax, %rax
	je	.L129
	leaq	.LC34(%rip), %rdi
	call	getenv@PLT
	movq	%rax, %rdi
	call	chdir@PLT
	cmpl	$-1, %eax
	je	.L138
.L129:
	movslq	%r12d, %r12
	leaq	-8(%r13,%r12,8), %rbp
	movl	$10, %edx
	movl	$0, %esi
	movq	0(%rbp), %rdi
	call	strtol@PLT
	movl	$-80, %ebx
	testl	%eax, %eax
	jne	.L139
.L130:
	movl	$1, %esi
	movl	$13, %edi
	call	signal@PLT
	movl	$8, %esi
	movl	%ebx, %edi
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
	leaq	.LC35(%rip), %rdi
	movl	$0, %eax
	call	open@PLT
	movl	%eax, logfile(%rip)
	leaq	die(%rip), %rbx
	movq	%rbx, %rsi
	movl	$2, %edi
	call	signal@PLT
	movq	%rbx, %rsi
	movl	$1, %edi
	call	signal@PLT
	movq	%rbx, %rsi
	movl	$15, %edi
	call	signal@PLT
	cmpl	$1, fflg(%rip)
	jle	.L134
	movl	$1, %ebx
.L132:
	call	fork@PLT
	testl	%eax, %eax
	jle	.L131
	addl	$1, %ebx
	cmpl	%ebx, fflg(%rip)
	jg	.L132
.L131:
	movl	$0, %edx
	movl	$0, %esi
	movl	%ebx, %edi
	call	handle_scheduler@PLT
	movl	$0, %eax
	call	worker
.L138:
	leaq	.LC34(%rip), %rdi
	call	getenv@PLT
	movq	%rax, %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L139:
	movl	$10, %edx
	movl	$0, %esi
	movq	0(%rbp), %rdi
	call	strtol@PLT
	movl	%eax, %ebx
	negl	%ebx
	jmp	.L130
.L134:
	movl	$1, %ebx
	jmp	.L131
	.cfi_endproc
.LFE72:
	.size	main, .-main
	.local	save_tm.0
	.comm	save_tm.0,56,32
	.local	buf.1
	.comm	buf.1,100,32
	.local	save_tt.2
	.comm	save_tt.2,8,8
	.local	nbytes
	.comm	nbytes,4,4
	.local	logbuf
	.comm	logbuf,65536,32
	.globl	logfile
	.bss
	.align 4
	.type	logfile, @object
	.size	logfile, 4
logfile:
	.zero	4
	.globl	data
	.align 4
	.type	data, @object
	.size	data, 4
data:
	.zero	4
	.globl	zflg
	.align 4
	.type	zflg, @object
	.size	zflg, 4
zflg:
	.zero	4
	.globl	fflg
	.align 4
	.type	fflg, @object
	.size	fflg, 4
fflg:
	.zero	4
	.globl	lflg
	.align 4
	.type	lflg, @object
	.size	lflg, 4
lflg:
	.zero	4
	.globl	nflg
	.align 4
	.type	nflg, @object
	.size	nflg, 4
nflg:
	.zero	4
	.globl	dflg
	.align 4
	.type	dflg, @object
	.size	dflg, 4
dflg:
	.zero	4
	.globl	Dflg
	.align 4
	.type	Dflg, @object
	.size	Dflg, 4
Dflg:
	.zero	4
	.globl	bufs
	.align 16
	.type	bufs, @object
	.size	bufs, 24
bufs:
	.zero	24
	.globl	buf
	.align 8
	.type	buf, @object
	.size	buf, 8
buf:
	.zero	8
	.globl	id
	.section	.rodata.str1.1
.LC36:
	.string	"$Id$\n"
	.section	.data.rel.local,"aw"
	.align 8
	.type	id, @object
	.size	id, 8
id:
	.quad	.LC36
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
