	.file	"lmdd.c"
	.text
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"norepeat on %u\n"
	.text
	.globl	been_there
	.type	been_there, @function
been_there:
.LFB73:
	.cfi_startproc
	endbr64
	movl	norepeats(%rip), %edx
	testl	%edx, %edx
	js	.L5
	movq	norepeat(%rip), %rcx
	movl	$0, %eax
.L4:
	cmpq	%rdi, (%rcx,%rax,8)
	je	.L11
	addq	$1, %rax
	cmpl	%eax, %edx
	jge	.L4
	movl	$0, %eax
	ret
.L11:
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	movl	%edi, %ecx
	leaq	.LC0(%rip), %rdx
	movl	$1, %esi
	movq	stderr(%rip), %rdi
	movl	$0, %eax
	call	__fprintf_chk@PLT
	movl	$1, %eax
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
.L5:
	movl	$0, %eax
	ret
	.cfi_endproc
.LFE73:
	.size	been_there, .-been_there
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC1:
	.string	"Bad arg: %s, possible arguments are: "
	.section	.rodata.str1.1
.LC2:
	.string	"%s "
	.text
	.globl	chkarg
	.type	chkarg, @function
chkarg:
.LFB74:
	.cfi_startproc
	endbr64
	movq	cmds(%rip), %rsi
	testq	%rsi, %rsi
	je	.L13
	movzbl	(%rdi), %r9d
	leaq	8+cmds(%rip), %r8
	jmp	.L14
.L22:
	cmpb	$61, %dl
	je	.L25
.L15:
	addq	$8, %r8
	movq	-8(%r8), %rsi
	testq	%rsi, %rsi
	je	.L13
.L14:
	movl	%r9d, %edx
	movl	$0, %eax
	testb	%r9b, %r9b
	je	.L15
.L18:
	movzbl	(%rsi,%rax), %ecx
	cmpb	%dl, %cl
	jne	.L22
	testb	%cl, %cl
	je	.L22
	addq	$1, %rax
	movzbl	(%rdi,%rax), %edx
	testb	%dl, %dl
	jne	.L18
	jmp	.L15
.L13:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushq	%rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	subq	$8, %rsp
	.cfi_def_cfa_offset 32
	movq	%rdi, %rcx
	leaq	.LC1(%rip), %rdx
	movl	$1, %esi
	movq	stderr(%rip), %rdi
	movl	$0, %eax
	call	__fprintf_chk@PLT
	movq	cmds(%rip), %rcx
	testq	%rcx, %rcx
	je	.L19
	leaq	8+cmds(%rip), %rbx
	leaq	.LC2(%rip), %rbp
.L20:
	movq	%rbp, %rdx
	movl	$1, %esi
	movq	stderr(%rip), %rdi
	movl	$0, %eax
	call	__fprintf_chk@PLT
	addq	$8, %rbx
	movq	-8(%rbx), %rcx
	testq	%rcx, %rcx
	jne	.L20
.L19:
	movq	stderr(%rip), %rsi
	movl	$10, %edi
	call	fputc@PLT
	movl	$1, %edi
	call	exit@PLT
.L25:
	.cfi_def_cfa_offset 8
	.cfi_restore 3
	.cfi_restore 6
	ret
	.cfi_endproc
.LFE74:
	.size	chkarg, .-chkarg
	.section	.rodata.str1.1
.LC3:
	.string	"label="
	.text
	.globl	getarg
	.type	getarg, @function
getarg:
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
	subq	$24, %rsp
	.cfi_def_cfa_offset 80
	movq	%rdi, %r14
	movl	%esi, %r13d
	movq	%rdx, %rbx
	call	strlen@PLT
	movslq	%r13d, %r13
	cmpq	$1, %r13
	jbe	.L32
	movq	%rax, %r15
	addq	$8, %rbx
	movl	$1, %ebp
.L31:
	movq	%rbx, 8(%rsp)
	movq	(%rbx), %r12
	movq	%r15, %rdx
	movq	%r14, %rsi
	movq	%r12, %rdi
	call	strncmp@PLT
	testl	%eax, %eax
	je	.L35
	addq	$1, %rbp
	addq	$8, %rbx
	cmpq	%r13, %rbp
	jne	.L31
	movq	$-1, %rbx
	jmp	.L28
.L35:
	leaq	(%r12,%r15), %rdi
	call	bytes@PLT
	movq	%rax, %rbx
	movq	8(%rsp), %rax
	movq	(%rax), %rbp
	movl	$6, %edx
	leaq	.LC3(%rip), %rsi
	movq	%rbp, %rdi
	call	strncmp@PLT
	addq	%r15, %rbp
	testl	%eax, %eax
	cmove	%rbp, %rbx
.L28:
	movq	%rbx, %rax
	addq	$24, %rsp
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
	movq	$-1, %rbx
	jmp	.L28
	.cfi_endproc
.LFE76:
	.size	getarg, .-getarg
	.section	.rodata.str1.1
.LC4:
	.string	"%s: "
	.text
	.globl	warning
	.type	warning, @function
warning:
.LFB78:
	.cfi_startproc
	endbr64
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movq	%rdi, %rbx
	movq	Label(%rip), %rcx
	cmpq	$-1, %rcx
	je	.L37
	leaq	.LC4(%rip), %rdx
	movl	$1, %esi
	movq	stderr(%rip), %rdi
	movl	$0, %eax
	call	__fprintf_chk@PLT
.L37:
	movq	%rbx, %rdi
	call	perror@PLT
	movl	$-1, %eax
	popq	%rbx
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE78:
	.size	warning, .-warning
	.section	.rodata.str1.1
.LC5:
	.string	"No output file"
	.text
	.globl	flush
	.type	flush, @function
flush:
.LFB79:
	.cfi_startproc
	endbr64
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	subq	$160, %rsp
	.cfi_def_cfa_offset 176
	movq	%fs:40, %rax
	movq	%rax, 152(%rsp)
	xorl	%eax, %eax
	movq	output(%rip), %rdi
	testq	%rdi, %rdi
	je	.L40
	movl	$2, %esi
	call	open@PLT
	movl	%eax, %ebx
	cmpl	$-1, %eax
	je	.L40
	movq	%rsp, %rsi
	movl	%eax, %edi
	call	fstat@PLT
	cmpl	$-1, %eax
	je	.L43
	movq	48(%rsp), %rsi
	testq	%rsi, %rsi
	jne	.L44
.L43:
	movq	output(%rip), %rdi
	call	warning
	jmp	.L39
.L40:
	leaq	.LC5(%rip), %rdi
	call	warning
.L39:
	movq	152(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L48
	addq	$160, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 16
	popq	%rbx
	.cfi_def_cfa_offset 8
	ret
.L44:
	.cfi_restore_state
	movl	$0, %r9d
	movl	%ebx, %r8d
	movl	$1, %ecx
	movl	$3, %edx
	movl	$0, %edi
	call	mmap@PLT
	movq	%rax, %rbx
	movl	$2, %edx
	movq	48(%rsp), %rsi
	movq	%rax, %rdi
	call	msync@PLT
	movq	48(%rsp), %rsi
	movq	%rbx, %rdi
	call	munmap@PLT
	jmp	.L39
.L48:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE79:
	.size	flush, .-flush
	.section	.rodata.str1.1
.LC6:
	.string	""
.LC7:
	.string	"READ operation latencies"
.LC8:
	.string	"%d- ms: %d\n"
.LC9:
	.string	"%d to %d ms: %d\n"
.LC10:
	.string	"%d+ ms: %d\n"
.LC11:
	.string	"WRITE operation latencies"
	.text
	.globl	done
	.type	done, @function
done:
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
	cmpl	$0, Sync(%rip)
	jg	.L75
.L50:
	cmpl	$0, Fsync(%rip)
	jg	.L76
.L51:
	cmpl	$0, Flush(%rip)
	jg	.L77
.L52:
	movl	$0, %esi
	movl	$0, %edi
	call	stop@PLT
	cmpl	$-1, ru(%rip)
	jne	.L78
.L53:
	movl	hash(%rip), %eax
	orl	poff(%rip), %eax
	je	.L54
	movq	stderr(%rip), %rsi
	movl	$10, %edi
	call	fputc@PLT
.L54:
	movq	Label(%rip), %rdi
	cmpq	$-1, %rdi
	je	.L55
	movq	stderr(%rip), %rsi
	call	fputs@PLT
.L55:
	movq	int_count(%rip), %rax
	leaq	0(,%rax,4), %rdi
	movq	%rdi, int_count(%rip)
	cmpl	$5, Print(%rip)
	ja	.L56
	movl	Print(%rip), %eax
	leaq	.L58(%rip), %rdx
	movslq	(%rdx,%rax,4), %rax
	addq	%rdx, %rax
	notrack jmp	*%rax
	.section	.rodata
	.align 4
	.align 4
.L58:
	.long	.L63-.L58
	.long	.L62-.L58
	.long	.L61-.L58
	.long	.L60-.L58
	.long	.L59-.L58
	.long	.L57-.L58
	.text
.L75:
	call	sync@PLT
	jmp	.L50
.L76:
	movl	out(%rip), %edi
	call	fsync@PLT
	jmp	.L51
.L77:
	call	flush
	jmp	.L52
.L78:
	call	rusage@PLT
	jmp	.L53
.L62:
	movslq	Bsize(%rip), %rsi
	movq	%rdi, %rax
	movl	$0, %edx
	divq	%rsi
	movq	%rax, %rdi
	call	latency@PLT
.L63:
	cmpl	$-1, Rtmax(%rip)
	jne	.L79
.L64:
	cmpl	$-1, Wtmax(%rip)
	jne	.L80
.L68:
	movl	$0, %edi
	call	exit@PLT
.L61:
	movslq	Bsize(%rip), %rcx
	movq	%rdi, %rax
	movl	$0, %edx
	divq	%rcx
	movq	%rax, %rsi
	leaq	.LC6(%rip), %rdi
	call	micro@PLT
	jmp	.L63
.L60:
	call	kb@PLT
	jmp	.L63
.L59:
	call	mb@PLT
	jmp	.L63
.L57:
	movl	$0, %edx
	movl	$1, %esi
	call	bandwidth@PLT
	jmp	.L63
.L56:
	movl	$1, %edx
	movl	$1, %esi
	call	bandwidth@PLT
	jmp	.L63
.L79:
	leaq	.LC7(%rip), %rdi
	call	puts@PLT
	movl	Rtmin(%rip), %esi
	movl	Rtmax(%rip), %eax
	subl	%esi, %eax
	movl	$10, %ecx
	cltd
	idivl	%ecx
	movl	%eax, %r12d
	movl	rthist(%rip), %ecx
	testl	%ecx, %ecx
	jne	.L81
.L65:
	movl	Rtmin(%rip), %ebp
	leaq	4+rthist(%rip), %rbx
	leaq	40(%rbx), %r13
	leaq	.LC9(%rip), %r14
	jmp	.L67
.L81:
	movl	%esi, %edx
	leaq	.LC8(%rip), %rsi
	movl	$1, %edi
	movl	$0, %eax
	call	__printf_chk@PLT
	jmp	.L65
.L66:
	addl	%r12d, %ebp
	addq	$4, %rbx
	cmpq	%r13, %rbx
	je	.L82
.L67:
	movl	(%rbx), %r8d
	testl	%r8d, %r8d
	je	.L66
	leal	-1(%rbp,%r12), %ecx
	movl	%ebp, %edx
	movq	%r14, %rsi
	movl	$1, %edi
	movl	$0, %eax
	call	__printf_chk@PLT
	jmp	.L66
.L82:
	movl	44+rthist(%rip), %ecx
	testl	%ecx, %ecx
	je	.L64
	movl	Rtmax(%rip), %edx
	leaq	.LC10(%rip), %rsi
	movl	$1, %edi
	movl	$0, %eax
	call	__printf_chk@PLT
	jmp	.L64
.L80:
	leaq	.LC11(%rip), %rdi
	call	puts@PLT
	movl	Wtmin(%rip), %esi
	movl	Wtmax(%rip), %eax
	subl	%esi, %eax
	movl	$10, %ecx
	cltd
	idivl	%ecx
	movl	%eax, %r12d
	movl	wthist(%rip), %ecx
	testl	%ecx, %ecx
	jne	.L83
.L69:
	movl	Wtmin(%rip), %ebp
	leaq	4+wthist(%rip), %rbx
	leaq	40(%rbx), %r13
	leaq	.LC9(%rip), %r14
	jmp	.L71
.L83:
	movl	%esi, %edx
	leaq	.LC8(%rip), %rsi
	movl	$1, %edi
	movl	$0, %eax
	call	__printf_chk@PLT
	jmp	.L69
.L70:
	addl	%r12d, %ebp
	addq	$4, %rbx
	cmpq	%r13, %rbx
	je	.L84
.L71:
	movl	(%rbx), %r8d
	testl	%r8d, %r8d
	je	.L70
	leal	-1(%rbp,%r12), %ecx
	movl	%ebp, %edx
	movq	%r14, %rsi
	movl	$1, %edi
	movl	$0, %eax
	call	__printf_chk@PLT
	jmp	.L70
.L84:
	movl	44+wthist(%rip), %ecx
	testl	%ecx, %ecx
	je	.L68
	movl	Wtmax(%rip), %edx
	leaq	.LC10(%rip), %rsi
	movl	$1, %edi
	movl	$0, %eax
	call	__printf_chk@PLT
	jmp	.L68
	.cfi_endproc
.LFE75:
	.size	done, .-done
	.globl	error
	.type	error, @function
error:
.LFB80:
	.cfi_startproc
	endbr64
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movq	%rdi, %rbx
	movq	Label(%rip), %rcx
	cmpq	$-1, %rcx
	je	.L86
	leaq	.LC4(%rip), %rdx
	movl	$1, %esi
	movq	stderr(%rip), %rdi
	movl	$0, %eax
	call	__fprintf_chk@PLT
.L86:
	movq	%rbx, %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
	.cfi_endproc
.LFE80:
	.size	error, .-error
	.section	.rodata.str1.1
.LC12:
	.string	"append="
.LC13:
	.string	"notrunc="
.LC14:
	.string	"nocreate="
.LC15:
	.string	"osync="
.LC16:
	.string	"of=internal"
.LC17:
	.string	"of=stdout"
.LC18:
	.string	"of=1"
.LC19:
	.string	"of=-"
.LC20:
	.string	"of=stderr"
.LC21:
	.string	"of=2"
.LC22:
	.string	"if=internal"
.LC23:
	.string	"if=stdin"
.LC24:
	.string	"if=0"
.LC25:
	.string	"if=-"
	.text
	.globl	getfile
	.type	getfile, @function
getfile:
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
	subq	$56, %rsp
	.cfi_def_cfa_offset 112
	movq	%rdi, %r14
	movl	%esi, %ebp
	movq	%rdx, %r12
	leaq	.LC12(%rip), %rdi
	call	getarg
	movq	%rax, 16(%rsp)
	movq	%r12, %rdx
	movl	%ebp, %esi
	leaq	.LC13(%rip), %rdi
	call	getarg
	movq	%rax, 24(%rsp)
	movq	%r12, %rdx
	movl	%ebp, %esi
	leaq	.LC14(%rip), %rdi
	call	getarg
	movq	%rax, 32(%rsp)
	movq	%r12, %rdx
	movl	%ebp, %esi
	leaq	.LC15(%rip), %rdi
	call	getarg
	movq	%rax, 40(%rsp)
	movq	%r14, %rdi
	call	strlen@PLT
	cmpl	$1, %ebp
	jle	.L95
	leaq	8(%r12), %rbx
	leal	-2(%rbp), %edx
	leaq	16(%r12,%rdx,8), %r15
	movslq	%eax, %r13
.L94:
	movq	%rbx, 8(%rsp)
	movq	(%rbx), %r12
	movq	%r13, %rdx
	movq	%r14, %rsi
	movq	%r12, %rdi
	call	strncmp@PLT
	movl	%eax, %ebp
	testl	%eax, %eax
	je	.L106
	addq	$8, %rbx
	cmpq	%r15, %rbx
	jne	.L94
	movl	$-2, %eax
.L88:
	addq	$56, %rsp
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
.L106:
	.cfi_restore_state
	cmpb	$111, (%r12)
	je	.L107
	movq	%r12, %rsi
	leaq	.LC22(%rip), %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	je	.L103
	movq	%r12, %rsi
	leaq	.LC23(%rip), %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	je	.L88
	movq	%r12, %rsi
	leaq	.LC24(%rip), %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	je	.L88
	movq	%r12, %rsi
	leaq	.LC25(%rip), %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	je	.L88
	leaq	(%r12,%r13), %rdi
	movl	$0, %esi
	movl	$0, %eax
	call	open@PLT
	cmpl	$-1, %eax
	jne	.L88
	movq	8(%rsp), %rax
	movq	%r13, %rdi
	addq	(%rax), %rdi
	call	error
.L107:
	movq	%r12, %rsi
	leaq	.LC16(%rip), %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	je	.L96
	movq	%r12, %rsi
	leaq	.LC17(%rip), %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	je	.L97
	movq	%r12, %rsi
	leaq	.LC18(%rip), %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	je	.L98
	movq	%r12, %rsi
	leaq	.LC19(%rip), %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	je	.L99
	movq	%r12, %rsi
	leaq	.LC20(%rip), %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	je	.L100
	movq	%r12, %rsi
	leaq	.LC21(%rip), %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	je	.L101
	movq	24(%rsp), %rax
	movq	16(%rsp), %rcx
	andq	%rcx, %rax
	cmpq	$-1, %rax
	sete	%dl
	movzbl	%dl, %edx
	sall	$9, %edx
	cmpq	$-1, %rcx
	setne	%al
	movzbl	%al, %eax
	sall	$10, %eax
	cmpq	$-1, 32(%rsp)
	sete	%cl
	movzbl	%cl, %ecx
	sall	$6, %ecx
	orl	%ecx, %eax
	cmpq	$-1, 40(%rsp)
	movl	$1052672, %ecx
	cmovne	%ecx, %ebp
	movl	%ebp, %esi
	orl	%eax, %esi
	orl	%edx, %esi
	orl	$1, %esi
	leaq	(%r12,%r13), %rdi
	movl	$420, %edx
	movl	$0, %eax
	call	open@PLT
	cmpl	$-1, %eax
	je	.L108
	movq	8(%rsp), %rcx
	addq	(%rcx), %r13
	movq	%r13, output(%rip)
	jmp	.L88
.L108:
	movq	8(%rsp), %rax
	movq	%r13, %rdi
	addq	(%rax), %rdi
	call	error
.L95:
	movl	$-2, %eax
	jmp	.L88
.L96:
	movl	$-2, %eax
	jmp	.L88
.L97:
	movl	$1, %eax
	jmp	.L88
.L98:
	movl	$1, %eax
	jmp	.L88
.L99:
	movl	$1, %eax
	jmp	.L88
.L100:
	movl	$2, %eax
	jmp	.L88
.L101:
	movl	$2, %eax
	jmp	.L88
.L103:
	movl	$-2, %eax
	jmp	.L88
	.cfi_endproc
.LFE77:
	.size	getfile, .-getfile
	.section	.rodata.str1.1
.LC26:
	.string	"mismatch="
.LC27:
	.string	"ipat="
.LC28:
	.string	"opat="
.LC29:
	.string	"bs="
.LC30:
	.string	"usleep="
.LC31:
	.string	"fork="
.LC32:
	.string	"fsync="
.LC33:
	.string	"sync="
.LC34:
	.string	"rand="
.LC35:
	.string	"start="
.LC36:
	.string	"end="
.LC37:
	.string	"time="
.LC38:
	.string	"srand="
.LC39:
	.string	"poff="
.LC40:
	.string	"print="
.LC41:
	.string	"bufs="
.LC42:
	.string	"realtime="
.LC43:
	.string	"rtmax="
.LC44:
	.string	"rtmin="
.LC45:
	.string	"wtmax="
.LC46:
	.string	"wtmin="
	.section	.rodata.str1.8
	.align 8
.LC47:
	.string	"Need a max to go with that min.\n"
	.align 8
.LC48:
	.string	"min has to be less than max, R=%d,%d W=%d,%d\n"
	.section	.rodata.str1.1
.LC49:
	.string	"timeopen="
.LC50:
	.string	"padin="
.LC51:
	.string	"Too many bufs"
.LC52:
	.string	"rusage="
.LC53:
	.string	"touch="
.LC54:
	.string	"hash="
.LC55:
	.string	"count="
.LC56:
	.string	"move="
.LC57:
	.string	"flush="
.LC58:
	.string	"skip="
.LC59:
	.string	"norepeat="
	.section	.rodata.str1.8
	.align 8
.LC60:
	.string	"Block size 0x%x must be word aligned\n"
	.align 8
.LC61:
	.string	"Block size must be at least 4.\n"
	.section	.rodata.str1.1
.LC62:
	.string	"VALLOC"
.LC63:
	.string	"if="
.LC64:
	.string	"of="
	.section	.rodata.str1.8
	.align 8
.LC65:
	.string	"I think you wanted wtmax, not rtmax\n"
	.align 8
.LC66:
	.string	"I think you wanted rtmax, not wtmax\n"
	.align 8
.LC69:
	.string	"READ: %.02f milliseconds offset %s\n"
	.section	.rodata.str1.1
.LC70:
	.string	"read"
.LC71:
	.string	"off=%u want=%x got=%x\n"
.LC72:
	.string	"write"
.LC73:
	.string	"write: wanted=%d got=%d\n"
	.section	.rodata.str1.8
	.align 8
.LC74:
	.string	"WRITE: %.02f milliseconds offset %s\n"
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
	subq	$264, %rsp
	.cfi_def_cfa_offset 320
	movl	%edi, %ebx
	movq	%rsi, %rbp
	movq	%fs:40, %rax
	movq	%rax, 248(%rsp)
	xorl	%eax, %eax
	cmpl	$1, %edi
	jle	.L110
	leaq	8(%rsi), %r12
	leal	-2(%rdi), %eax
	leaq	16(%rsi,%rax,8), %r13
.L111:
	movq	(%r12), %rdi
	movl	$0, %eax
	call	chkarg
	addq	$8, %r12
	cmpq	%r13, %r12
	jne	.L111
.L110:
	leaq	done(%rip), %r12
	movq	%r12, %rsi
	movl	$2, %edi
	call	signal@PLT
	movq	%r12, %rsi
	movl	$14, %edi
	call	signal@PLT
	movq	%rbp, %rdx
	movl	%ebx, %esi
	leaq	.LC26(%rip), %rdi
	movl	$0, %eax
	call	getarg
	movq	%rax, 16(%rsp)
	movq	%rbp, %rdx
	movl	%ebx, %esi
	leaq	.LC27(%rip), %rdi
	movl	$0, %eax
	call	getarg
	movq	%rax, 8(%rsp)
	movq	%rbp, %rdx
	movl	%ebx, %esi
	leaq	.LC28(%rip), %rdi
	movl	$0, %eax
	call	getarg
	movq	%rax, %r12
	movq	%rbp, %rdx
	movl	%ebx, %esi
	leaq	.LC29(%rip), %rdi
	movl	$0, %eax
	call	getarg
	testl	%eax, %eax
	movl	$8192, %edx
	cmovs	%edx, %eax
	movl	%eax, Bsize(%rip)
	movq	%rbp, %rdx
	movl	%ebx, %esi
	leaq	.LC30(%rip), %rdi
	movl	$0, %eax
	call	getarg
	movq	%rax, (%rsp)
	movq	%rbp, %rdx
	movl	%ebx, %esi
	leaq	.LC31(%rip), %rdi
	movl	$0, %eax
	call	getarg
	movq	%rax, 24(%rsp)
	movq	%rbp, %rdx
	movl	%ebx, %esi
	leaq	.LC32(%rip), %rdi
	movl	$0, %eax
	call	getarg
	movl	%eax, Fsync(%rip)
	movq	%rbp, %rdx
	movl	%ebx, %esi
	leaq	.LC33(%rip), %rdi
	movl	$0, %eax
	call	getarg
	movl	%eax, Sync(%rip)
	movq	%rbp, %rdx
	movl	%ebx, %esi
	leaq	.LC34(%rip), %rdi
	movl	$0, %eax
	call	getarg
	movq	%rax, Rand(%rip)
	movq	%rbp, %rdx
	movl	%ebx, %esi
	leaq	.LC35(%rip), %rdi
	movl	$0, %eax
	call	getarg
	movq	%rax, Start(%rip)
	movq	%rbp, %rdx
	movl	%ebx, %esi
	leaq	.LC36(%rip), %rdi
	movl	$0, %eax
	call	getarg
	movq	%rax, End(%rip)
	movq	%rbp, %rdx
	movl	%ebx, %esi
	leaq	.LC37(%rip), %rdi
	movl	$0, %eax
	call	getarg
	movq	%rax, %r15
	movq	End(%rip), %rax
	cmpq	$-1, %rax
	je	.L114
	movq	Rand(%rip), %rdx
	cmpq	%rdx, %rax
	ja	.L237
.L114:
	movq	%rbp, %rdx
	movl	%ebx, %esi
	leaq	.LC38(%rip), %rdi
	movl	$0, %eax
	call	getarg
	cmpq	$-1, %rax
	jne	.L238
.L115:
	movq	%rbp, %rdx
	movl	%ebx, %esi
	leaq	.LC39(%rip), %rdi
	movl	$0, %eax
	call	getarg
	cmpq	$-1, %rax
	setne	%al
	movzbl	%al, %eax
	movl	%eax, poff(%rip)
	movq	%rbp, %rdx
	movl	%ebx, %esi
	leaq	.LC40(%rip), %rdi
	movl	$0, %eax
	call	getarg
	movl	%eax, Print(%rip)
	movq	%rbp, %rdx
	movl	%ebx, %esi
	leaq	.LC41(%rip), %rdi
	movl	$0, %eax
	call	getarg
	movq	%rax, %r13
	movq	%rbp, %rdx
	movl	%ebx, %esi
	leaq	.LC42(%rip), %rdi
	movl	$0, %eax
	call	getarg
	movl	%eax, Realtime(%rip)
	movq	%rbp, %rdx
	movl	%ebx, %esi
	leaq	.LC43(%rip), %rdi
	movl	$0, %eax
	call	getarg
	cmpl	$-1, %eax
	je	.L221
	cmpl	$9, %eax
	jg	.L221
	movl	$10, Rtmax(%rip)
	jmp	.L118
.L237:
	movq	%rdx, End(%rip)
	jmp	.L114
.L238:
	movq	%rbp, %rdx
	movl	%ebx, %esi
	leaq	.LC38(%rip), %rdi
	movl	$0, %eax
	call	getarg
	movq	%rax, %rdi
	call	srand48@PLT
	jmp	.L115
.L221:
	movl	%eax, Rtmax(%rip)
.L118:
	movq	%rbp, %rdx
	movl	%ebx, %esi
	leaq	.LC44(%rip), %rdi
	movl	$0, %eax
	call	getarg
	movl	%eax, Rtmin(%rip)
	cmpl	$-1, Rtmax(%rip)
	je	.L119
	cmpl	$-1, %eax
	je	.L239
.L119:
	movq	%rbp, %rdx
	movl	%ebx, %esi
	leaq	.LC45(%rip), %rdi
	movl	$0, %eax
	call	getarg
	cmpl	$-1, %eax
	je	.L222
	cmpl	$9, %eax
	jg	.L222
	movl	$10, Wtmax(%rip)
	jmp	.L122
.L239:
	movl	$0, Rtmin(%rip)
	jmp	.L119
.L222:
	movl	%eax, Wtmax(%rip)
.L122:
	movq	%rbp, %rdx
	movl	%ebx, %esi
	leaq	.LC46(%rip), %rdi
	movl	$0, %eax
	call	getarg
	movl	%eax, Wtmin(%rip)
	movl	Wtmax(%rip), %r9d
	cmpl	$-1, %eax
	jne	.L123
	cmpl	$-1, %r9d
	jne	.L240
.L123:
	movl	Rtmin(%rip), %r8d
	testl	%r8d, %r8d
	jne	.L241
.L126:
	movl	Wtmin(%rip), %eax
	testl	%r9d, %r9d
	jne	.L125
	testl	%eax, %eax
	jne	.L127
.L125:
	movl	Rtmax(%rip), %ecx
	cmpl	%eax, %r9d
	jl	.L223
	cmpl	%r8d, %ecx
	jge	.L128
.L223:
	subq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 328
	pushq	%rax
	.cfi_def_cfa_offset 336
	leaq	.LC48(%rip), %rdx
	movl	$1, %esi
	movq	stderr(%rip), %rdi
	movl	$0, %eax
	call	__fprintf_chk@PLT
	movl	$1, %edi
	call	exit@PLT
.L240:
	.cfi_restore_state
	movl	$0, Wtmin(%rip)
	movl	Rtmin(%rip), %r8d
	movl	%r8d, %eax
	testl	%r8d, %r8d
	je	.L125
	cmpl	$0, Rtmax(%rip)
	je	.L127
	movl	Wtmin(%rip), %eax
	jmp	.L125
.L241:
	cmpl	$0, Rtmax(%rip)
	jne	.L126
.L127:
	movq	stderr(%rip), %rcx
	movl	$32, %edx
	movl	$1, %esi
	leaq	.LC47(%rip), %rdi
	call	fwrite@PLT
	movl	$1, %edi
	call	exit@PLT
.L128:
	movq	%rbp, %rdx
	movl	%ebx, %esi
	leaq	.LC49(%rip), %rdi
	movl	$0, %eax
	call	getarg
	movq	%rax, %r14
	movq	%rbp, %rdx
	movl	%ebx, %esi
	leaq	.LC50(%rip), %rdi
	movl	$0, %eax
	call	getarg
	movl	%eax, %ecx
	cmpl	$-1, %eax
	movl	$0, %eax
	cmovne	%ecx, %eax
	movl	%eax, 60(%rsp)
	movl	%r13d, 44(%rsp)
	cmpl	$-1, %r13d
	je	.L217
	cmpl	$10, %r13d
	jg	.L242
.L131:
	movq	%rbp, %rdx
	movl	%ebx, %esi
	leaq	.LC52(%rip), %rdi
	movl	$0, %eax
	call	getarg
	movl	%eax, ru(%rip)
	movq	%rbp, %rdx
	movl	%ebx, %esi
	leaq	.LC53(%rip), %rdi
	movl	$0, %eax
	call	getarg
	movq	%rax, 64(%rsp)
	movq	%rbp, %rdx
	movl	%ebx, %esi
	leaq	.LC54(%rip), %rdi
	movl	$0, %eax
	call	getarg
	cmpq	$-1, %rax
	setne	%al
	movzbl	%al, %eax
	movl	%eax, hash(%rip)
	movq	%rbp, %rdx
	movl	%ebx, %esi
	leaq	.LC3(%rip), %rdi
	movl	$0, %eax
	call	getarg
	movq	%rax, Label(%rip)
	movq	%rbp, %rdx
	movl	%ebx, %esi
	leaq	.LC55(%rip), %rdi
	movl	$0, %eax
	call	getarg
	movq	%rax, 32(%rsp)
	movq	%rbp, %rdx
	movl	%ebx, %esi
	leaq	.LC56(%rip), %rdi
	movl	$0, %eax
	call	getarg
	movq	%rax, 72(%rsp)
	cmpq	$-1, %rax
	je	.L132
	movslq	Bsize(%rip), %rcx
	movl	$0, %edx
	divq	%rcx
	movq	%rax, 32(%rsp)
.L132:
	movq	Rand(%rip), %rax
	cmpq	$-1, %rax
	je	.L133
	movl	Bsize(%rip), %edx
	negl	%edx
	movslq	%edx, %rdx
	subq	$1, %rax
	andq	%rax, %rdx
	movq	%rdx, 72(%rsp)
.L133:
	movq	%rbp, %rdx
	movl	%ebx, %esi
	leaq	.LC57(%rip), %rdi
	movl	$0, %eax
	call	getarg
	movl	%eax, Flush(%rip)
	movq	$0, int_count(%rip)
	movq	%rbp, %rdx
	movl	%ebx, %esi
	leaq	.LC58(%rip), %rdi
	movl	$0, %eax
	call	getarg
	movq	%rax, 48(%rsp)
	movq	%rbp, %rdx
	movl	%ebx, %esi
	leaq	.LC59(%rip), %rdi
	movl	$0, %eax
	call	getarg
	cmpq	$-1, %rax
	je	.L134
	movq	32(%rsp), %rdi
	cmpq	$-1, %rdi
	je	.L135
	movl	$8, %esi
	call	calloc@PLT
	movq	%rax, norepeat(%rip)
.L134:
	movq	8(%rsp), %rax
	movl	%eax, 56(%rsp)
	movl	%r12d, 92(%rsp)
	andl	%eax, %r12d
	cmpl	$-1, %r12d
	je	.L136
	movl	Bsize(%rip), %ecx
	testb	$3, %cl
	jne	.L243
.L136:
	movl	Bsize(%rip), %eax
	shrl	$2, %eax
	je	.L137
	cmpl	$0, 44(%rsp)
	jle	.L139
	leaq	160(%rsp), %r12
	movl	44(%rsp), %eax
	leal	-1(%rax), %eax
	leaq	168(%rsp,%rax,8), %r13
.L141:
	movl	Bsize(%rip), %edi
	call	valloc@PLT
	movq	%rax, %rdi
	movq	%rax, (%r12)
	testq	%rax, %rax
	je	.L244
	movslq	Bsize(%rip), %rdx
	movl	$0, %esi
	call	memset@PLT
	addq	$8, %r12
	cmpq	%r13, %r12
	jne	.L141
.L139:
	cmpl	$-1, %r15d
	jne	.L245
.L142:
	cmpl	$-1, %r14d
	jne	.L246
	movq	%rbp, %rdx
	movl	%ebx, %esi
	leaq	.LC63(%rip), %rdi
	call	getfile
	movl	%eax, 8(%rsp)
	movq	%rbp, %rdx
	movl	%ebx, %esi
	leaq	.LC64(%rip), %rdi
	call	getfile
	movl	%eax, out(%rip)
	movl	$0, %edi
	call	start@PLT
	jmp	.L214
.L242:
	leaq	.LC51(%rip), %rdi
	call	puts@PLT
	movl	$1, %edi
	call	exit@PLT
.L217:
	movl	$1, 44(%rsp)
	jmp	.L131
.L135:
	movl	$8, %esi
	movl	$10240, %edi
	call	calloc@PLT
	movq	%rax, norepeat(%rip)
	jmp	.L134
.L243:
	leaq	.LC60(%rip), %rdx
	movl	$1, %esi
	movq	stderr(%rip), %rdi
	movl	$0, %eax
	call	__fprintf_chk@PLT
	movl	$1, %edi
	call	exit@PLT
.L137:
	movq	stderr(%rip), %rcx
	movl	$31, %edx
	movl	$1, %esi
	leaq	.LC61(%rip), %rdi
	call	fwrite@PLT
	movl	$1, %edi
	call	exit@PLT
.L244:
	leaq	.LC62(%rip), %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L245:
	movl	%r15d, %edi
	call	alarm@PLT
	jmp	.L142
.L246:
	movl	$0, %edi
	call	start@PLT
	movq	%rbp, %rdx
	movl	%ebx, %esi
	leaq	.LC63(%rip), %rdi
	call	getfile
	movl	%eax, 8(%rsp)
	movq	%rbp, %rdx
	movl	%ebx, %esi
	leaq	.LC64(%rip), %rdi
	call	getfile
	movl	%eax, out(%rip)
.L214:
	cmpl	$-1, Rtmax(%rip)
	je	.L144
	cmpl	$0, 8(%rsp)
	js	.L247
.L144:
	cmpl	$-1, Wtmax(%rip)
	je	.L145
	cmpl	$0, out(%rip)
	js	.L248
.L145:
	movq	48(%rsp), %rcx
	cmpq	$-1, %rcx
	je	.L218
	movslq	Bsize(%rip), %rax
	imulq	%rax, %rcx
	movq	%rcx, %r14
	movl	8(%rsp), %eax
	testl	%eax, %eax
	jns	.L249
.L147:
	movl	out(%rip), %edi
	testl	%edi, %edi
	jns	.L250
.L148:
	cmpl	$0, poff(%rip)
	jne	.L251
.L146:
	movq	16(%rsp), %rax
	movl	%eax, 124(%rsp)
	movl	(%rsp), %ecx
	movl	%ecx, 88(%rsp)
	movl	24(%rsp), %ecx
	movl	%ecx, 48(%rsp)
	cmpq	$-1, 64(%rsp)
	setne	103(%rsp)
	movq	32(%rsp), %rcx
	movq	%rcx, 24(%rsp)
	movl	%eax, 96(%rsp)
	movl	$0, 84(%rsp)
	movl	$0, 16(%rsp)
	movl	8(%rsp), %eax
	notl	%eax
	shrl	$31, %eax
	movl	%eax, 80(%rsp)
	jmp	.L149
.L247:
	movq	stderr(%rip), %rcx
	movl	$36, %edx
	movl	$1, %esi
	leaq	.LC65(%rip), %rdi
	call	fwrite@PLT
	movl	$1, %edi
	call	exit@PLT
.L248:
	movq	stderr(%rip), %rcx
	movl	$36, %edx
	movl	$1, %esi
	leaq	.LC66(%rip), %rdi
	call	fwrite@PLT
	movl	$1, %edi
	call	exit@PLT
.L249:
	movl	$0, %edx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	seekto@PLT
	jmp	.L147
.L250:
	movl	$0, %edx
	movq	%r14, %rsi
	call	seekto@PLT
	jmp	.L148
.L251:
	movq	%r14, %rdi
	call	p64sz@PLT
	movq	%rax, %rcx
	leaq	.LC2(%rip), %rdx
	movl	$1, %esi
	movq	stderr(%rip), %rdi
	movl	$0, %eax
	call	__fprintf_chk@PLT
	jmp	.L146
.L218:
	movl	$0, %r14d
	jmp	.L146
.L273:
	movl	$0, %eax
	call	done
.L274:
	movl	$0, %edx
	cmpq	$0, start.0(%rip)
	jne	.L152
	movq	Rand(%rip), %rdx
	subq	%rax, %rdx
.L152:
	movq	%rdx, start.0(%rip)
	movabsq	$-9223372036854775808, %rbx
	jmp	.L159
.L153:
	movq	%rdx, %rcx
	shrq	%rcx
	andl	$1, %edx
	orq	%rdx, %rcx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rcx, %xmm0
	addsd	%xmm0, %xmm0
	jmp	.L154
.L155:
	subsd	.LC67(%rip), %xmm0
	cvttsd2siq	%xmm0, %rdx
	xorq	%rbx, %rdx
.L156:
	leal	-1(%rax), %ecx
	movslq	%ecx, %rcx
	addq	%rcx, %rdx
	negl	%eax
	movslq	%eax, %r14
	andq	%rdx, %r14
	addq	start.0(%rip), %r14
	movq	Start(%rip), %rax
	leaq	(%r14,%rax), %rdx
	cmpq	$-1, %rax
	cmovne	%rdx, %r14
	cmpq	$0, norepeat(%rip)
	je	.L158
	movq	%r14, %rdi
	call	been_there
	testl	%eax, %eax
	je	.L252
.L159:
	call	drand48@PLT
	movapd	%xmm0, %xmm1
	movl	Bsize(%rip), %eax
	movq	End(%rip), %rdx
	testq	%rdx, %rdx
	js	.L153
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
.L154:
	mulsd	%xmm1, %xmm0
	comisd	.LC67(%rip), %xmm0
	jnb	.L155
	cvttsd2siq	%xmm0, %rdx
	jmp	.L156
.L252:
	movq	norepeat(%rip), %rdx
	testq	%rdx, %rdx
	je	.L158
	movl	norepeats(%rip), %eax
	leal	1(%rax), %ecx
	movl	%ecx, norepeats(%rip)
	cltq
	movq	%r14, (%rdx,%rax,8)
	cmpq	$-1, 32(%rsp)
	jne	.L158
	cmpl	$10240, norepeats(%rip)
	je	.L253
.L158:
	movl	8(%rsp), %eax
	testl	%eax, %eax
	jns	.L254
.L160:
	movl	out(%rip), %edi
	testl	%edi, %edi
	js	.L161
	movl	$0, %edx
	movq	%r14, %rsi
	call	seekto@PLT
	jmp	.L161
.L253:
	movl	$0, norepeats(%rip)
	jmp	.L158
.L254:
	movl	$0, %edx
	movq	%r14, %rsi
	movl	%eax, %edi
	call	seekto@PLT
	jmp	.L160
.L275:
	movabsq	$-9223372036854775808, %rbx
	movq	72(%rsp), %rbp
	jmp	.L168
.L162:
	movq	%rdx, %rcx
	shrq	%rcx
	andl	$1, %edx
	orq	%rdx, %rcx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rcx, %xmm0
	addsd	%xmm0, %xmm0
	jmp	.L163
.L164:
	subsd	.LC67(%rip), %xmm0
	cvttsd2siq	%xmm0, %rcx
	xorq	%rbx, %rcx
.L165:
	movq	Start(%rip), %rdx
	cmpq	$-1, %rdx
	je	.L166
	addq	%rdx, %rcx
.L166:
	leal	-1(%rax), %edx
	movslq	%edx, %rdx
	addq	%rcx, %rdx
	negl	%eax
	cltq
	andq	%rdx, %rax
	movq	%rax, %r14
	cmpq	$0, norepeat(%rip)
	je	.L167
	movq	%rax, %rdi
	call	been_there
	testl	%eax, %eax
	je	.L255
.L168:
	call	drand48@PLT
	movapd	%xmm0, %xmm1
	movl	Bsize(%rip), %eax
	movslq	%eax, %rcx
	movq	%rbp, %rdx
	subq	%rcx, %rdx
	js	.L162
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
.L163:
	mulsd	%xmm1, %xmm0
	comisd	.LC67(%rip), %xmm0
	jnb	.L164
	cvttsd2siq	%xmm0, %rcx
	jmp	.L165
.L255:
	movq	norepeat(%rip), %rdx
	testq	%rdx, %rdx
	je	.L167
	movl	norepeats(%rip), %eax
	leal	1(%rax), %ecx
	movl	%ecx, norepeats(%rip)
	cltq
	movq	%r14, (%rdx,%rax,8)
.L167:
	cmpq	$-1, 32(%rsp)
	jne	.L169
	cmpl	$10240, norepeats(%rip)
	je	.L256
.L169:
	movl	8(%rsp), %eax
	testl	%eax, %eax
	jns	.L257
.L170:
	movl	out(%rip), %edi
	testl	%edi, %edi
	js	.L161
	movl	$0, %edx
	movq	%r14, %rsi
	call	seekto@PLT
	jmp	.L161
.L256:
	movl	$0, norepeats(%rip)
	jmp	.L169
.L257:
	movl	$0, %edx
	movq	%r14, %rsi
	movl	%eax, %edi
	call	seekto@PLT
	jmp	.L170
.L276:
	movq	%r14, %rdi
	call	p64sz@PLT
	movq	%rax, %rcx
	leaq	.LC2(%rip), %rdx
	movl	$1, %esi
	movq	stderr(%rip), %rdi
	movl	$0, %eax
	call	__fprintf_chk@PLT
	jmp	.L171
.L277:
	movl	$0, 16(%rsp)
	jmp	.L172
.L278:
	addq	$1, 24(%rsp)
	movl	$0, %edi
	call	start@PLT
	movl	$0, 60(%rsp)
	jmp	.L149
.L181:
	subl	%ecx, %eax
	movl	$10, %esi
	cltd
	idivl	%esi
	leal	(%rax,%rcx), %edx
	movl	$1, %ecx
.L183:
	cmpl	%edx, %ebp
	jl	.L258
	addl	$1, %ecx
	addl	%eax, %edx
	cmpl	$11, %ecx
	jne	.L183
	jmp	.L177
.L258:
	leaq	rthist(%rip), %rax
	movslq	%ecx, %rcx
	addl	$1, (%rax,%rcx,4)
	jmp	.L177
.L173:
	movl	Bsize(%rip), %r13d
.L177:
	cmpl	$-1, %r13d
	je	.L259
	testl	%r13d, %r13d
	jle	.L185
	cmpl	$-1, 56(%rsp)
	jne	.L260
.L187:
	cmpb	$0, 80(%rsp)
	je	.L190
	cmpb	$0, 103(%rsp)
	jne	.L261
.L190:
	cmpl	$0, out(%rip)
	js	.L192
	cmpl	$-1, 48(%rsp)
	je	.L193
	cmpl	$0, 84(%rsp)
	jne	.L262
.L194:
	call	fork@PLT
	movl	%eax, 84(%rsp)
	testl	%eax, %eax
	jne	.L263
.L193:
	cmpl	$-1, 92(%rsp)
	jne	.L264
.L195:
	movl	Wtmax(%rip), %eax
	andl	Wtmin(%rip), %eax
	cmpl	$-1, %eax
	je	.L198
	leaq	128(%rsp), %rdi
	call	start@PLT
.L198:
	movslq	%r13d, %rdx
	movq	%r15, %rsi
	movl	out(%rip), %edi
	call	write@PLT
	movl	%eax, %ebx
	cmpl	$-1, %eax
	je	.L265
	cmpl	%eax, %r13d
	jne	.L266
	movl	Wtmax(%rip), %eax
	andl	Wtmin(%rip), %eax
	cmpl	$-1, %eax
	je	.L202
	leaq	144(%rsp), %rsi
	leaq	128(%rsp), %rdi
	call	stop@PLT
	movq	%rax, %rbp
	movl	$1000, %ecx
	cltd
	idivl	%ecx
	movl	%eax, %ebx
	movl	Wtmax(%rip), %eax
	cmpl	%ebx, %eax
	jl	.L203
	movl	Wtmin(%rip), %ecx
	cmpl	%ebx, %ecx
	jle	.L204
.L203:
	movl	$1, %edx
	movl	$0, %esi
	movl	out(%rip), %edi
	call	seekto@PLT
	movq	%rax, %rdi
	call	p64sz@PLT
	movq	%rax, %rcx
	pxor	%xmm0, %xmm0
	cvtsi2ssl	%ebp, %xmm0
	divss	.LC68(%rip), %xmm0
	cvtss2sd	%xmm0, %xmm0
	leaq	.LC74(%rip), %rdx
	movl	$1, %esi
	movq	stderr(%rip), %rdi
	movl	$1, %eax
	call	__fprintf_chk@PLT
	movl	Wtmax(%rip), %eax
	cmpl	%ebx, %eax
	jle	.L212
	movl	Wtmin(%rip), %ecx
	cmpl	%ebx, %ecx
	jle	.L206
	addl	$1, wthist(%rip)
	jmp	.L202
.L259:
	leaq	.LC70(%rip), %rdi
	call	perror@PLT
.L185:
	movl	$0, %eax
	call	done
.L260:
	movslq	%r13d, %rax
	shrq	$2, %rax
	testl	%eax, %eax
	je	.L187
	movq	%r15, %rbx
	movl	%r14d, %ecx
	leal	-1(%rax), %eax
	leaq	4(%r15,%rax,4), %r12
	movl	%r14d, %ebp
	movq	%r14, 104(%rsp)
	movl	96(%rsp), %r14d
	movl	%r13d, 120(%rsp)
	movl	%ecx, %r13d
	movq	%r15, 112(%rsp)
	movl	124(%rsp), %r15d
	jmp	.L189
.L188:
	addq	$4, %rbx
	addl	$4, %ebp
	cmpq	%rbx, %r12
	je	.L267
.L189:
	movl	(%rbx), %r9d
	cmpl	%ebp, %r9d
	je	.L188
	movl	%ebp, %r8d
	movl	%r13d, %ecx
	leaq	.LC71(%rip), %rdx
	movl	$1, %esi
	movq	stderr(%rip), %rdi
	movl	$0, %eax
	call	__fprintf_chk@PLT
	cmpl	$-1, %r15d
	je	.L188
	subl	$1, %r14d
	jne	.L188
	movl	$0, %eax
	call	done
.L267:
	movl	%r14d, 96(%rsp)
	movq	104(%rsp), %r14
	movl	120(%rsp), %r13d
	movq	112(%rsp), %r15
	jmp	.L187
.L261:
	movl	$0, %eax
.L191:
	movb	$0, (%r15,%rax)
	addq	$4096, %rax
	cmpl	%eax, %r13d
	jg	.L191
	jmp	.L190
.L262:
	movl	$0, %edx
	movl	$0, %esi
	movl	84(%rsp), %edi
	call	waitpid@PLT
	jmp	.L194
.L263:
	movslq	%r13d, %rax
	addq	%rax, %r14
	movl	%r13d, %eax
	sarl	$2, %eax
	cltq
	addq	%rax, int_count(%rip)
	jmp	.L149
.L264:
	movslq	%r13d, %rcx
	shrq	$2, %rcx
	movl	$0, %eax
	jmp	.L196
.L197:
	leal	(%r14,%rax,4), %edx
	movl	%edx, (%r15,%rax,4)
	addq	$1, %rax
.L196:
	cmpq	%rax, %rcx
	jne	.L197
	jmp	.L195
.L265:
	movl	%r13d, %r15d
	leaq	.LC72(%rip), %rdi
	call	perror@PLT
.L200:
	movl	%ebx, %r8d
	movl	%r15d, %ecx
	leaq	.LC73(%rip), %rdx
	movl	$1, %esi
	movq	stderr(%rip), %rdi
	movl	$0, %eax
	call	__fprintf_chk@PLT
	movl	$0, %eax
	call	done
.L266:
	movl	%r13d, %r15d
	jmp	.L200
.L206:
	subl	%ecx, %eax
	movl	$10, %esi
	cltd
	idivl	%esi
	leal	(%rax,%rcx), %edx
	movl	$1, %ecx
.L208:
	cmpl	%ebx, %edx
	jg	.L268
	addl	$1, %ecx
	addl	%eax, %edx
	cmpl	$11, %ecx
	jne	.L208
	jmp	.L202
.L268:
	leaq	wthist(%rip), %rax
	movslq	%ecx, %rcx
	addl	$1, (%rax,%rcx,4)
	jmp	.L202
.L269:
	movl	$0, %eax
.L209:
	movb	$0, (%r15,%rax)
	addq	$4096, %rax
	cmpl	%eax, %r13d
	jg	.L209
	jmp	.L192
.L270:
	movl	(%rsp), %edi
	call	usleep@PLT
	jmp	.L210
.L271:
	movq	stderr(%rip), %rsi
	movl	$35, %edi
	call	fputc@PLT
	jmp	.L211
.L272:
	movl	$0, %edi
	call	exit@PLT
.L204:
	cmpl	%ebx, %eax
	jne	.L206
.L212:
	addl	$1, 44+wthist(%rip)
.L202:
	cmpq	$-1, 64(%rsp)
	jne	.L269
.L192:
	movslq	%r13d, %rax
	addq	%rax, %r14
	movl	%r13d, %eax
	sarl	$2, %eax
	cltq
	addq	%rax, int_count(%rip)
	cmpl	$-1, 88(%rsp)
	jne	.L270
.L210:
	cmpl	$0, hash(%rip)
	jne	.L271
.L211:
	cmpl	$-1, 48(%rsp)
	jne	.L272
.L149:
	cmpq	$-1, 32(%rsp)
	je	.L150
	movq	24(%rsp), %rcx
	leaq	-1(%rcx), %rax
	testq	%rcx, %rcx
	je	.L273
	movq	%rax, 24(%rsp)
.L150:
	movq	End(%rip), %rax
	cmpq	$-1, %rax
	jne	.L274
	cmpq	$-1, Rand(%rip)
	jne	.L275
.L161:
	cmpl	$0, poff(%rip)
	jne	.L276
.L171:
	movl	16(%rsp), %ecx
	movslq	%ecx, %rax
	movq	160(%rsp,%rax,8), %r15
	addl	$1, %ecx
	movl	%ecx, 16(%rsp)
	cmpl	%ecx, 44(%rsp)
	je	.L277
.L172:
	cmpl	$0, 8(%rsp)
	js	.L173
	movl	Rtmax(%rip), %eax
	andl	Rtmin(%rip), %eax
	cmpl	$-1, %eax
	je	.L174
	leaq	128(%rsp), %rdi
	call	start@PLT
.L174:
	movslq	Bsize(%rip), %rdx
	movq	%r15, %rsi
	movl	8(%rsp), %edi
	call	read@PLT
	movl	%eax, %r13d
	cmpl	$0, 60(%rsp)
	jne	.L278
	movl	Rtmax(%rip), %eax
	andl	Rtmin(%rip), %eax
	cmpl	$-1, %eax
	je	.L177
	leaq	144(%rsp), %rsi
	leaq	128(%rsp), %rdi
	call	stop@PLT
	movq	%rax, %rbx
	movl	$1000, %ecx
	cltd
	idivl	%ecx
	movl	%eax, %ebp
	movl	Rtmax(%rip), %eax
	cmpl	%ebp, %eax
	jl	.L178
	movl	Rtmin(%rip), %ecx
	cmpl	%ebp, %ecx
	jle	.L179
.L178:
	movl	$1, %edx
	movl	$0, %esi
	movl	8(%rsp), %edi
	call	seekto@PLT
	movq	%rax, %rdi
	call	p64sz@PLT
	movq	%rax, %rcx
	pxor	%xmm0, %xmm0
	cvtsi2ssl	%ebx, %xmm0
	divss	.LC68(%rip), %xmm0
	cvtss2sd	%xmm0, %xmm0
	leaq	.LC69(%rip), %rdx
	movl	$1, %esi
	movq	stderr(%rip), %rdi
	movl	$1, %eax
	call	__fprintf_chk@PLT
	movl	Rtmax(%rip), %eax
	cmpl	%ebp, %eax
	jle	.L213
	movl	Rtmin(%rip), %ecx
	cmpl	%ebp, %ecx
	jle	.L181
	addl	$1, rthist(%rip)
	jmp	.L177
.L179:
	cmpl	%ebp, %eax
	jne	.L181
.L213:
	addl	$1, 44+rthist(%rip)
	jmp	.L177
	.cfi_endproc
.LFE72:
	.size	main, .-main
	.local	start.0
	.comm	start.0,8,8
	.globl	output
	.bss
	.align 8
	.type	output, @object
	.size	output, 8
output:
	.zero	8
	.globl	cmds
	.section	.rodata.str1.1
.LC75:
	.string	"bs"
.LC76:
	.string	"bufs"
.LC77:
	.string	"count"
.LC78:
	.string	"flush"
.LC79:
	.string	"fork"
.LC80:
	.string	"fsync"
.LC81:
	.string	"if"
.LC82:
	.string	"ipat"
.LC83:
	.string	"label"
.LC84:
	.string	"mismatch"
.LC85:
	.string	"move"
.LC86:
	.string	"of"
.LC87:
	.string	"opat"
.LC88:
	.string	"print"
.LC89:
	.string	"rand"
.LC90:
	.string	"poff"
.LC91:
	.string	"rusage"
.LC92:
	.string	"skip"
.LC93:
	.string	"sync"
.LC94:
	.string	"touch"
.LC95:
	.string	"usleep"
.LC96:
	.string	"hash"
.LC97:
	.string	"append"
.LC98:
	.string	"rtmax"
.LC99:
	.string	"wtmax"
.LC100:
	.string	"rtmin"
.LC101:
	.string	"wtmin"
.LC102:
	.string	"realtime"
.LC103:
	.string	"notrunc"
.LC104:
	.string	"end"
.LC105:
	.string	"start"
.LC106:
	.string	"time"
.LC107:
	.string	"srand"
.LC108:
	.string	"padin"
.LC109:
	.string	"norepeat"
.LC110:
	.string	"timeopen"
.LC111:
	.string	"nocreate"
.LC112:
	.string	"osync"
	.section	.data.rel.local,"aw"
	.align 32
	.type	cmds, @object
	.size	cmds, 312
cmds:
	.quad	.LC75
	.quad	.LC76
	.quad	.LC77
	.quad	.LC78
	.quad	.LC79
	.quad	.LC80
	.quad	.LC81
	.quad	.LC82
	.quad	.LC83
	.quad	.LC84
	.quad	.LC85
	.quad	.LC86
	.quad	.LC87
	.quad	.LC88
	.quad	.LC89
	.quad	.LC90
	.quad	.LC91
	.quad	.LC92
	.quad	.LC93
	.quad	.LC94
	.quad	.LC95
	.quad	.LC96
	.quad	.LC97
	.quad	.LC98
	.quad	.LC99
	.quad	.LC100
	.quad	.LC101
	.quad	.LC102
	.quad	.LC103
	.quad	.LC104
	.quad	.LC105
	.quad	.LC106
	.quad	.LC107
	.quad	.LC108
	.quad	.LC109
	.quad	.LC110
	.quad	.LC111
	.quad	.LC112
	.quad	0
	.globl	norepeats
	.data
	.align 4
	.type	norepeats, @object
	.size	norepeats, 4
norepeats:
	.long	-1
	.globl	norepeat
	.bss
	.align 8
	.type	norepeat, @object
	.size	norepeat, 8
norepeat:
	.zero	8
	.globl	Label
	.align 8
	.type	Label, @object
	.size	Label, 8
Label:
	.zero	8
	.globl	wthist
	.align 32
	.type	wthist, @object
	.size	wthist, 48
wthist:
	.zero	48
	.globl	rthist
	.align 32
	.type	rthist, @object
	.size	rthist, 48
rthist:
	.zero	48
	.globl	Wtmin
	.align 4
	.type	Wtmin, @object
	.size	Wtmin, 4
Wtmin:
	.zero	4
	.globl	Wtmax
	.align 4
	.type	Wtmax, @object
	.size	Wtmax, 4
Wtmax:
	.zero	4
	.globl	Rtmin
	.align 4
	.type	Rtmin, @object
	.size	Rtmin, 4
Rtmin:
	.zero	4
	.globl	Rtmax
	.align 4
	.type	Rtmax, @object
	.size	Rtmax, 4
Rtmax:
	.zero	4
	.globl	Notrunc
	.align 4
	.type	Notrunc, @object
	.size	Notrunc, 4
Notrunc:
	.zero	4
	.globl	Realtime
	.align 4
	.type	Realtime, @object
	.size	Realtime, 4
Realtime:
	.zero	4
	.globl	hash
	.align 4
	.type	hash, @object
	.size	hash, 4
hash:
	.zero	4
	.globl	int_count
	.align 8
	.type	int_count, @object
	.size	int_count, 8
int_count:
	.zero	8
	.globl	Rand
	.align 8
	.type	Rand, @object
	.size	Rand, 8
Rand:
	.zero	8
	.globl	End
	.align 8
	.type	End, @object
	.size	End, 8
End:
	.zero	8
	.globl	Start
	.align 8
	.type	Start, @object
	.size	Start, 8
Start:
	.zero	8
	.globl	ru
	.align 4
	.type	ru, @object
	.size	ru, 4
ru:
	.zero	4
	.globl	Bsize
	.align 4
	.type	Bsize, @object
	.size	Bsize, 4
Bsize:
	.zero	4
	.globl	Flush
	.align 4
	.type	Flush, @object
	.size	Flush, 4
Flush:
	.zero	4
	.globl	Sync
	.align 4
	.type	Sync, @object
	.size	Sync, 4
Sync:
	.zero	4
	.globl	Fsync
	.align 4
	.type	Fsync, @object
	.size	Fsync, 4
Fsync:
	.zero	4
	.globl	Print
	.align 4
	.type	Print, @object
	.size	Print, 4
Print:
	.zero	4
	.globl	out
	.align 4
	.type	out, @object
	.size	out, 4
out:
	.zero	4
	.globl	poff
	.align 4
	.type	poff, @object
	.size	poff, 4
poff:
	.zero	4
	.globl	awrite
	.align 4
	.type	awrite, @object
	.size	awrite, 4
awrite:
	.zero	4
	.globl	id
	.section	.rodata.str1.8
	.align 8
.LC113:
	.string	"$Id: lmdd.c,v 1.23 1997/12/01 23:47:59 lm Exp $\n"
	.section	.data.rel.local
	.align 8
	.type	id, @object
	.size	id, 8
id:
	.quad	.LC113
	.section	.rodata.cst8,"aM",@progbits,8
	.align 8
.LC67:
	.long	0
	.long	1138753536
	.section	.rodata.cst4,"aM",@progbits,4
	.align 4
.LC68:
	.long	1148846080
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
