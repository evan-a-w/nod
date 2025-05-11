	.file	"lib_timing.c"
	.text
	.globl	benchmp_sigterm
	.type	benchmp_sigterm, @function
benchmp_sigterm:
.LFB75:
	.cfi_startproc
	endbr64
	movl	$1, benchmp_sigterm_received(%rip)
	ret
	.cfi_endproc
.LFE75:
	.size	benchmp_sigterm, .-benchmp_sigterm
	.globl	sigchld_wait_handler
	.type	sigchld_wait_handler, @function
sigchld_wait_handler:
.LFB74:
	.cfi_startproc
	endbr64
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	movl	$0, %edi
	call	wait@PLT
	leaq	sigchld_wait_handler(%rip), %rsi
	movl	$17, %edi
	call	signal@PLT
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE74:
	.size	sigchld_wait_handler, .-sigchld_wait_handler
	.globl	benchmp_sigchld
	.type	benchmp_sigchld, @function
benchmp_sigchld:
.LFB76:
	.cfi_startproc
	endbr64
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	movl	$0, %esi
	movl	$17, %edi
	call	signal@PLT
	movl	$1, benchmp_sigchld_received(%rip)
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE76:
	.size	benchmp_sigchld, .-benchmp_sigchld
	.globl	benchmp_child_sigchld
	.type	benchmp_child_sigchld, @function
benchmp_child_sigchld:
.LFB81:
	.cfi_startproc
	endbr64
	pushq	%rax
	.cfi_def_cfa_offset 16
	popq	%rax
	.cfi_def_cfa_offset 8
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	cmpq	$0, 24+_benchmp_child_state(%rip)
	je	.L7
	movl	$0, %esi
	movl	$17, %edi
	call	signal@PLT
	leaq	_benchmp_child_state(%rip), %rsi
	movl	$0, %edi
	call	*24+_benchmp_child_state(%rip)
.L7:
	movl	$1, %edi
	call	exit@PLT
	.cfi_endproc
.LFE81:
	.size	benchmp_child_sigchld, .-benchmp_child_sigchld
	.globl	benchmp_child_sigterm
	.type	benchmp_child_sigterm, @function
benchmp_child_sigterm:
.LFB82:
	.cfi_startproc
	endbr64
	pushq	%rax
	.cfi_def_cfa_offset 16
	popq	%rax
	.cfi_def_cfa_offset 8
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	movl	$1, %esi
	movl	$15, %edi
	call	signal@PLT
	cmpq	$0, 24+_benchmp_child_state(%rip)
	je	.L10
	movl	$0, %esi
	movl	$17, %edi
	call	signal@PLT
	movq	%rax, %rsi
	testq	%rax, %rax
	je	.L11
	leaq	benchmp_child_sigchld(%rip), %rax
	cmpq	%rax, %rsi
	je	.L11
	movl	$17, %edi
	call	signal@PLT
.L11:
	leaq	_benchmp_child_state(%rip), %rsi
	movl	$0, %edi
	call	*24+_benchmp_child_state(%rip)
.L10:
	movl	$0, %edi
	call	exit@PLT
	.cfi_endproc
.LFE82:
	.size	benchmp_child_sigterm, .-benchmp_child_sigterm
	.globl	benchmp_sigalrm
	.type	benchmp_sigalrm, @function
benchmp_sigalrm:
.LFB77:
	.cfi_startproc
	endbr64
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	movl	$1, %esi
	movl	$14, %edi
	call	signal@PLT
	movl	$15, %esi
	movl	benchmp_sigalrm_pid(%rip), %edi
	call	kill@PLT
	movl	$1, benchmp_sigalrm_timeout(%rip)
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE77:
	.size	benchmp_sigalrm, .-benchmp_sigalrm
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"Usage: %s %s"
	.text
	.globl	lmbench_usage
	.type	lmbench_usage, @function
lmbench_usage:
.LFB73:
	.cfi_startproc
	endbr64
	pushq	%rax
	.cfi_def_cfa_offset 16
	popq	%rax
	.cfi_def_cfa_offset 8
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	movq	%rdx, %r8
	movq	(%rsi), %rcx
	leaq	.LC0(%rip), %rdx
	movl	$1, %esi
	movq	stderr(%rip), %rdi
	movl	$0, %eax
	call	__fprintf_chk@PLT
	movl	$-1, %edi
	call	exit@PLT
	.cfi_endproc
.LFE73:
	.size	lmbench_usage, .-lmbench_usage
	.globl	benchmp_childid
	.type	benchmp_childid, @function
benchmp_childid:
.LFB80:
	.cfi_startproc
	endbr64
	movl	32+_benchmp_child_state(%rip), %eax
	ret
	.cfi_endproc
.LFE80:
	.size	benchmp_childid, .-benchmp_childid
	.globl	benchmp_getstate
	.type	benchmp_getstate, @function
benchmp_getstate:
.LFB83:
	.cfi_startproc
	endbr64
	leaq	_benchmp_child_state(%rip), %rax
	ret
	.cfi_endproc
.LFE83:
	.size	benchmp_getstate, .-benchmp_getstate
	.globl	timing
	.type	timing, @function
timing:
.LFB86:
	.cfi_startproc
	endbr64
	movq	%rdi, ftiming(%rip)
	ret
	.cfi_endproc
.LFE86:
	.size	timing, .-timing
	.globl	start
	.type	start, @function
start:
.LFB87:
	.cfi_startproc
	endbr64
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movq	%rdi, %rbx
	testq	%rdi, %rdi
	leaq	start_tv(%rip), %rax
	cmove	%rax, %rbx
	leaq	ru_start(%rip), %rsi
	movl	$0, %edi
	call	getrusage@PLT
	movl	$0, %esi
	movq	%rbx, %rdi
	call	gettimeofday@PLT
	popq	%rbx
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE87:
	.size	start, .-start
	.globl	now
	.type	now, @function
now:
.LFB89:
	.cfi_startproc
	endbr64
	subq	$40, %rsp
	.cfi_def_cfa_offset 48
	movq	%fs:40, %rax
	movq	%rax, 24(%rsp)
	xorl	%eax, %eax
	movq	%rsp, %rdi
	movl	$0, %esi
	call	gettimeofday@PLT
	imulq	$1000000, (%rsp), %rax
	addq	8(%rsp), %rax
	movq	24(%rsp), %rdx
	subq	%fs:40, %rdx
	jne	.L26
	addq	$40, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	ret
.L26:
	.cfi_restore_state
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE89:
	.size	now, .-now
	.globl	Now
	.type	Now, @function
Now:
.LFB90:
	.cfi_startproc
	endbr64
	subq	$40, %rsp
	.cfi_def_cfa_offset 48
	movq	%fs:40, %rax
	movq	%rax, 24(%rsp)
	xorl	%eax, %eax
	movq	%rsp, %rdi
	movl	$0, %esi
	call	gettimeofday@PLT
	pxor	%xmm0, %xmm0
	cvtsi2sdq	(%rsp), %xmm0
	mulsd	.LC1(%rip), %xmm0
	pxor	%xmm1, %xmm1
	cvtsi2sdq	8(%rsp), %xmm1
	addsd	%xmm1, %xmm0
	movq	24(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L30
	addq	$40, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	ret
.L30:
	.cfi_restore_state
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE90:
	.size	Now, .-Now
	.globl	save_n
	.type	save_n, @function
save_n:
.LFB93:
	.cfi_startproc
	endbr64
	movq	%rdi, iterations(%rip)
	ret
	.cfi_endproc
.LFE93:
	.size	save_n, .-save_n
	.globl	get_n
	.type	get_n, @function
get_n:
.LFB94:
	.cfi_startproc
	endbr64
	movq	iterations(%rip), %rax
	ret
	.cfi_endproc
.LFE94:
	.size	get_n, .-get_n
	.globl	settime
	.type	settime, @function
settime:
.LFB95:
	.cfi_startproc
	endbr64
	movq	$0, start_tv(%rip)
	movq	$0, 8+start_tv(%rip)
	movabsq	$4835703278458516699, %rdx
	movq	%rdi, %rax
	mulq	%rdx
	shrq	$18, %rdx
	movq	%rdx, stop_tv(%rip)
	imulq	$1000000, %rdx, %rdx
	subq	%rdx, %rdi
	movq	%rdi, 8+stop_tv(%rip)
	ret
	.cfi_endproc
.LFE95:
	.size	settime, .-settime
	.section	.rodata.str1.1
.LC2:
	.string	"lib_timing.c"
.LC3:
	.string	"tdiff->tv_usec >= 0"
	.text
	.globl	tvsub
	.type	tvsub, @function
tvsub:
.LFB107:
	.cfi_startproc
	endbr64
	movq	(%rsi), %rcx
	subq	(%rdx), %rcx
	movq	%rcx, (%rdi)
	movq	8(%rsi), %rax
	subq	8(%rdx), %rax
	movq	%rax, 8(%rdi)
	testq	%rcx, %rcx
	jle	.L35
	testq	%rax, %rax
	js	.L42
.L35:
	testq	%rax, %rax
	jns	.L36
.L37:
	movq	$0, (%rdi)
	movq	$0, 8(%rdi)
.L34:
	ret
.L42:
	subq	$1, %rcx
	movq	%rcx, (%rdi)
	addq	$1000000, %rax
	movq	%rax, 8(%rdi)
	js	.L43
.L36:
	movq	(%rdx), %rax
	cmpq	%rax, (%rsi)
	jge	.L34
	jmp	.L37
.L43:
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	leaq	__PRETTY_FUNCTION__.12(%rip), %rcx
	movl	$1099, %edx
	leaq	.LC2(%rip), %rsi
	leaq	.LC3(%rip), %rdi
	call	__assert_fail@PLT
	.cfi_endproc
.LFE107:
	.size	tvsub, .-tvsub
	.globl	delta
	.type	delta, @function
delta:
.LFB91:
	.cfi_startproc
	endbr64
	subq	$56, %rsp
	.cfi_def_cfa_offset 64
	movq	%fs:40, %rax
	movq	%rax, 40(%rsp)
	xorl	%eax, %eax
	movq	%rsp, %rdi
	movl	$0, %esi
	call	gettimeofday@PLT
	cmpq	$0, 8+last.13(%rip)
	jne	.L49
	movdqa	(%rsp), %xmm0
	movaps	%xmm0, last.13(%rip)
	movl	$0, %eax
.L44:
	movq	40(%rsp), %rdx
	subq	%fs:40, %rdx
	jne	.L50
	addq	$56, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	ret
.L49:
	.cfi_restore_state
	movq	%rsp, %rsi
	leaq	16(%rsp), %rdi
	leaq	last.13(%rip), %rdx
	call	tvsub
	movdqa	(%rsp), %xmm1
	movaps	%xmm1, last.13(%rip)
	imulq	$1000000, 16(%rsp), %rax
	addq	24(%rsp), %rax
	jmp	.L44
.L50:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE91:
	.size	delta, .-delta
	.globl	Delta
	.type	Delta, @function
Delta:
.LFB92:
	.cfi_startproc
	endbr64
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	subq	$48, %rsp
	.cfi_def_cfa_offset 64
	movq	%fs:40, %rax
	movq	%rax, 40(%rsp)
	xorl	%eax, %eax
	movq	%rsp, %rbx
	movl	$0, %esi
	movq	%rbx, %rdi
	call	gettimeofday@PLT
	leaq	16(%rsp), %rdi
	leaq	start_tv(%rip), %rdx
	movq	%rbx, %rsi
	call	tvsub
	pxor	%xmm0, %xmm0
	cvtsi2sdq	24(%rsp), %xmm0
	divsd	.LC1(%rip), %xmm0
	pxor	%xmm1, %xmm1
	cvtsi2sdq	16(%rsp), %xmm1
	addsd	%xmm1, %xmm0
	movq	40(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L54
	addq	$48, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 16
	popq	%rbx
	.cfi_def_cfa_offset 8
	ret
.L54:
	.cfi_restore_state
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE92:
	.size	Delta, .-Delta
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC4:
	.string	"%.4f MB in %.4f secs, %.4f MB/sec\n"
	.section	.rodata.str1.1
.LC6:
	.string	"%.6f "
.LC7:
	.string	"%.2f "
.LC8:
	.string	"%.6f\n"
.LC9:
	.string	"%.2f\n"
	.text
	.globl	bandwidth
	.type	bandwidth, @function
bandwidth:
.LFB96:
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
	subq	$48, %rsp
	.cfi_def_cfa_offset 80
	movq	%rdi, %rbx
	movq	%rsi, %rbp
	movl	%edx, %r12d
	movq	%fs:40, %rax
	movq	%rax, 40(%rsp)
	xorl	%eax, %eax
	leaq	16(%rsp), %rdi
	leaq	start_tv(%rip), %rdx
	leaq	stop_tv(%rip), %rsi
	call	tvsub
	pxor	%xmm1, %xmm1
	cvtsi2sdq	16(%rsp), %xmm1
	movsd	.LC1(%rip), %xmm2
	mulsd	%xmm2, %xmm1
	pxor	%xmm0, %xmm0
	cvtsi2sdq	24(%rsp), %xmm0
	addsd	%xmm1, %xmm0
	divsd	%xmm2, %xmm0
	testq	%rbp, %rbp
	js	.L56
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rbp, %xmm1
.L57:
	divsd	%xmm1, %xmm0
	movsd	%xmm0, 8(%rsp)
	testq	%rbx, %rbx
	js	.L58
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rbx, %xmm0
.L59:
	divsd	.LC1(%rip), %xmm0
	movsd	%xmm0, (%rsp)
	cmpq	$0, ftiming(%rip)
	je	.L74
.L60:
	testl	%r12d, %r12d
	jne	.L75
	movsd	.LC5(%rip), %xmm0
	movsd	(%rsp), %xmm3
	comisd	%xmm3, %xmm0
	ja	.L76
	movsd	(%rsp), %xmm0
	leaq	.LC7(%rip), %rdx
	movl	$1, %esi
	movq	ftiming(%rip), %rdi
	movl	$1, %eax
	call	__fprintf_chk@PLT
.L65:
	movsd	(%rsp), %xmm0
	divsd	8(%rsp), %xmm0
	movsd	.LC5(%rip), %xmm1
	comisd	%xmm0, %xmm1
	ja	.L77
	leaq	.LC9(%rip), %rdx
	movl	$1, %esi
	movq	ftiming(%rip), %rdi
	movl	$1, %eax
	call	__fprintf_chk@PLT
.L55:
	movq	40(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L78
	addq	$48, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 32
	popq	%rbx
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	ret
.L56:
	.cfi_restore_state
	movq	%rbp, %rax
	shrq	%rax
	andl	$1, %ebp
	orq	%rbp, %rax
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rax, %xmm1
	addsd	%xmm1, %xmm1
	jmp	.L57
.L58:
	movq	%rbx, %rax
	shrq	%rax
	andl	$1, %ebx
	orq	%rbx, %rax
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	addsd	%xmm0, %xmm0
	jmp	.L59
.L74:
	movq	stderr(%rip), %rax
	movq	%rax, ftiming(%rip)
	jmp	.L60
.L75:
	movsd	(%rsp), %xmm0
	movapd	%xmm0, %xmm2
	movsd	8(%rsp), %xmm5
	divsd	%xmm5, %xmm2
	movapd	%xmm5, %xmm1
	leaq	.LC4(%rip), %rdx
	movl	$1, %esi
	movq	ftiming(%rip), %rdi
	movl	$3, %eax
	call	__fprintf_chk@PLT
	jmp	.L55
.L76:
	movapd	%xmm3, %xmm0
	leaq	.LC6(%rip), %rdx
	movl	$1, %esi
	movq	ftiming(%rip), %rdi
	movl	$1, %eax
	call	__fprintf_chk@PLT
	jmp	.L65
.L77:
	leaq	.LC8(%rip), %rdx
	movl	$1, %esi
	movq	ftiming(%rip), %rdi
	movl	$1, %eax
	call	__fprintf_chk@PLT
	jmp	.L55
.L78:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE96:
	.size	bandwidth, .-bandwidth
	.section	.rodata.str1.1
.LC12:
	.string	"%.0f KB/sec\n"
	.text
	.globl	kb
	.type	kb, @function
kb:
.LFB97:
	.cfi_startproc
	endbr64
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	subq	$32, %rsp
	.cfi_def_cfa_offset 48
	movq	%rdi, %rbx
	movq	%fs:40, %rax
	movq	%rax, 24(%rsp)
	xorl	%eax, %eax
	movq	%rsp, %rdi
	leaq	start_tv(%rip), %rdx
	leaq	stop_tv(%rip), %rsi
	call	tvsub
	pxor	%xmm1, %xmm1
	cvtsi2sdq	8(%rsp), %xmm1
	divsd	.LC1(%rip), %xmm1
	pxor	%xmm0, %xmm0
	cvtsi2sdq	(%rsp), %xmm0
	addsd	%xmm0, %xmm1
	ucomisd	.LC10(%rip), %xmm1
	jp	.L80
	je	.L79
.L80:
	testq	%rbx, %rbx
	js	.L83
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rbx, %xmm0
.L84:
	divsd	%xmm1, %xmm0
	cmpq	$0, ftiming(%rip)
	je	.L89
.L86:
	divsd	.LC11(%rip), %xmm0
	leaq	.LC12(%rip), %rdx
	movl	$1, %esi
	movq	ftiming(%rip), %rdi
	movl	$1, %eax
	call	__fprintf_chk@PLT
.L79:
	movq	24(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L90
	addq	$32, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 16
	popq	%rbx
	.cfi_def_cfa_offset 8
	ret
.L89:
	.cfi_restore_state
	movq	stderr(%rip), %rax
	movq	%rax, ftiming(%rip)
	jmp	.L86
.L83:
	movq	%rbx, %rax
	shrq	%rax
	andl	$1, %ebx
	orq	%rbx, %rax
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	addsd	%xmm0, %xmm0
	jmp	.L84
.L90:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE97:
	.size	kb, .-kb
	.section	.rodata.str1.1
.LC13:
	.string	"%.2f MB/sec\n"
	.text
	.globl	mb
	.type	mb, @function
mb:
.LFB98:
	.cfi_startproc
	endbr64
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	subq	$32, %rsp
	.cfi_def_cfa_offset 48
	movq	%rdi, %rbx
	movq	%fs:40, %rax
	movq	%rax, 24(%rsp)
	xorl	%eax, %eax
	movq	%rsp, %rdi
	leaq	start_tv(%rip), %rdx
	leaq	stop_tv(%rip), %rsi
	call	tvsub
	pxor	%xmm1, %xmm1
	cvtsi2sdq	8(%rsp), %xmm1
	divsd	.LC1(%rip), %xmm1
	pxor	%xmm0, %xmm0
	cvtsi2sdq	(%rsp), %xmm0
	addsd	%xmm0, %xmm1
	ucomisd	.LC10(%rip), %xmm1
	jp	.L92
	je	.L91
.L92:
	testq	%rbx, %rbx
	js	.L95
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rbx, %xmm0
.L96:
	divsd	%xmm1, %xmm0
	cmpq	$0, ftiming(%rip)
	je	.L101
.L98:
	divsd	.LC1(%rip), %xmm0
	leaq	.LC13(%rip), %rdx
	movl	$1, %esi
	movq	ftiming(%rip), %rdi
	movl	$1, %eax
	call	__fprintf_chk@PLT
.L91:
	movq	24(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L102
	addq	$32, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 16
	popq	%rbx
	.cfi_def_cfa_offset 8
	ret
.L101:
	.cfi_restore_state
	movq	stderr(%rip), %rax
	movq	%rax, ftiming(%rip)
	jmp	.L98
.L95:
	movq	%rbx, %rax
	shrq	%rax
	andl	$1, %ebx
	orq	%rbx, %rax
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	addsd	%xmm0, %xmm0
	jmp	.L96
.L102:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE98:
	.size	mb, .-mb
	.section	.rodata.str1.1
.LC14:
	.string	"/xfer"
.LC15:
	.string	"s"
.LC16:
	.string	"%d %dKB xfers in %.2f secs, "
.LC18:
	.string	"%.1fKB in "
.LC19:
	.string	"%.0f millisec%s, "
.LC20:
	.string	"%.4f millisec%s, "
.LC21:
	.string	"%.2f KB/sec\n"
	.text
	.globl	latency
	.type	latency, @function
latency:
.LFB99:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushq	%rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	subq	$56, %rsp
	.cfi_def_cfa_offset 80
	movq	%rdi, %rbx
	movq	%rsi, %rbp
	movq	%fs:40, %rax
	movq	%rax, 40(%rsp)
	xorl	%eax, %eax
	cmpq	$0, ftiming(%rip)
	je	.L134
.L104:
	leaq	16(%rsp), %rdi
	leaq	start_tv(%rip), %rdx
	leaq	stop_tv(%rip), %rsi
	call	tvsub
	pxor	%xmm0, %xmm0
	cvtsi2sdq	24(%rsp), %xmm0
	divsd	.LC1(%rip), %xmm0
	pxor	%xmm1, %xmm1
	cvtsi2sdq	16(%rsp), %xmm1
	addsd	%xmm1, %xmm0
	movsd	%xmm0, (%rsp)
	ucomisd	.LC10(%rip), %xmm0
	jp	.L128
	je	.L103
.L128:
	cmpq	$1, %rbx
	jbe	.L107
	testq	%rbp, %rbp
	js	.L108
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rbp, %xmm1
.L109:
	divsd	.LC11(%rip), %xmm1
	movsd	(%rsp), %xmm0
	cvttsd2sil	%xmm1, %r8d
	movl	%ebx, %ecx
	leaq	.LC16(%rip), %rdx
	movl	$1, %esi
	movq	ftiming(%rip), %rdi
	movl	$1, %eax
	call	__fprintf_chk@PLT
	movsd	.LC11(%rip), %xmm3
	mulsd	(%rsp), %xmm3
	movsd	%xmm3, 8(%rsp)
	testq	%rbx, %rbx
	js	.L110
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rbx, %xmm1
.L111:
	movsd	8(%rsp), %xmm0
	divsd	%xmm1, %xmm0
	leaq	.LC14(%rip), %rcx
	comisd	.LC17(%rip), %xmm0
	jbe	.L113
	leaq	.LC14(%rip), %rcx
.L112:
	leaq	.LC19(%rip), %rdx
	movl	$1, %esi
	movq	ftiming(%rip), %rdi
	movl	$1, %eax
	call	__fprintf_chk@PLT
.L119:
	imulq	%rbp, %rbx
	testq	%rbx, %rbx
	js	.L120
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rbx, %xmm0
.L121:
	movsd	(%rsp), %xmm1
	mulsd	.LC1(%rip), %xmm1
	movapd	%xmm0, %xmm2
	divsd	%xmm1, %xmm2
	comisd	.LC5(%rip), %xmm2
	jbe	.L132
	movapd	%xmm2, %xmm0
	leaq	.LC13(%rip), %rdx
	movl	$1, %esi
	movq	ftiming(%rip), %rdi
	movl	$1, %eax
	call	__fprintf_chk@PLT
.L103:
	movq	40(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L135
	addq	$56, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
.L134:
	.cfi_restore_state
	movq	stderr(%rip), %rax
	movq	%rax, ftiming(%rip)
	jmp	.L104
.L108:
	movq	%rbp, %rax
	shrq	%rax
	movq	%rbp, %rdx
	andl	$1, %edx
	orq	%rdx, %rax
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rax, %xmm1
	addsd	%xmm1, %xmm1
	jmp	.L109
.L110:
	movq	%rbx, %rax
	shrq	%rax
	movq	%rbx, %rdx
	andl	$1, %edx
	orq	%rdx, %rax
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rax, %xmm1
	addsd	%xmm1, %xmm1
	jmp	.L111
.L107:
	testq	%rbp, %rbp
	js	.L114
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rbp, %xmm0
.L115:
	divsd	.LC11(%rip), %xmm0
	leaq	.LC18(%rip), %rdx
	movl	$1, %esi
	movq	ftiming(%rip), %rdi
	movl	$1, %eax
	call	__fprintf_chk@PLT
	movsd	.LC11(%rip), %xmm5
	mulsd	(%rsp), %xmm5
	movsd	%xmm5, 8(%rsp)
	testq	%rbx, %rbx
	js	.L116
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rbx, %xmm1
.L117:
	movsd	8(%rsp), %xmm0
	divsd	%xmm1, %xmm0
	leaq	.LC15(%rip), %rcx
	comisd	.LC17(%rip), %xmm0
	ja	.L112
	leaq	.LC15(%rip), %rcx
.L113:
	leaq	.LC20(%rip), %rdx
	movl	$1, %esi
	movq	ftiming(%rip), %rdi
	movl	$1, %eax
	call	__fprintf_chk@PLT
	jmp	.L119
.L114:
	movq	%rbp, %rax
	shrq	%rax
	movq	%rbp, %rdx
	andl	$1, %edx
	orq	%rdx, %rax
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	addsd	%xmm0, %xmm0
	jmp	.L115
.L116:
	movq	%rbx, %rax
	shrq	%rax
	movq	%rbx, %rdx
	andl	$1, %edx
	orq	%rdx, %rax
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rax, %xmm1
	addsd	%xmm1, %xmm1
	jmp	.L117
.L120:
	movq	%rbx, %rax
	shrq	%rax
	andl	$1, %ebx
	orq	%rbx, %rax
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	addsd	%xmm0, %xmm0
	jmp	.L121
.L132:
	divsd	8(%rsp), %xmm0
	leaq	.LC21(%rip), %rdx
	movl	$1, %esi
	movq	ftiming(%rip), %rdi
	movl	$1, %eax
	call	__fprintf_chk@PLT
	jmp	.L103
.L135:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE99:
	.size	latency, .-latency
	.section	.rodata.str1.8
	.align 8
.LC22:
	.string	"%d context switches in %.2f secs, %.0f microsec/switch\n"
	.text
	.globl	context
	.type	context, @function
context:
.LFB100:
	.cfi_startproc
	endbr64
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	subq	$32, %rsp
	.cfi_def_cfa_offset 48
	movq	%rdi, %rbx
	movq	%fs:40, %rax
	movq	%rax, 24(%rsp)
	xorl	%eax, %eax
	movq	%rsp, %rdi
	leaq	start_tv(%rip), %rdx
	leaq	stop_tv(%rip), %rsi
	call	tvsub
	pxor	%xmm0, %xmm0
	cvtsi2sdq	8(%rsp), %xmm0
	divsd	.LC1(%rip), %xmm0
	pxor	%xmm1, %xmm1
	cvtsi2sdq	(%rsp), %xmm1
	addsd	%xmm1, %xmm0
	ucomisd	.LC10(%rip), %xmm0
	jp	.L143
	je	.L136
.L143:
	cmpq	$0, ftiming(%rip)
	je	.L145
.L139:
	movapd	%xmm0, %xmm1
	mulsd	.LC1(%rip), %xmm1
	testq	%rbx, %rbx
	js	.L140
	pxor	%xmm2, %xmm2
	cvtsi2sdq	%rbx, %xmm2
.L141:
	divsd	%xmm2, %xmm1
	movl	%ebx, %ecx
	leaq	.LC22(%rip), %rdx
	movl	$1, %esi
	movq	ftiming(%rip), %rdi
	movl	$2, %eax
	call	__fprintf_chk@PLT
.L136:
	movq	24(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L146
	addq	$32, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 16
	popq	%rbx
	.cfi_def_cfa_offset 8
	ret
.L145:
	.cfi_restore_state
	movq	stderr(%rip), %rax
	movq	%rax, ftiming(%rip)
	jmp	.L139
.L140:
	movq	%rbx, %rax
	shrq	%rax
	movq	%rbx, %rdx
	andl	$1, %edx
	orq	%rdx, %rax
	pxor	%xmm2, %xmm2
	cvtsi2sdq	%rax, %xmm2
	addsd	%xmm2, %xmm2
	jmp	.L141
.L146:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE100:
	.size	context, .-context
	.section	.rodata.str1.1
.LC23:
	.string	"%s: %.2f nanoseconds\n"
	.text
	.globl	nano
	.type	nano, @function
nano:
.LFB101:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushq	%rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	subq	$40, %rsp
	.cfi_def_cfa_offset 64
	movq	%rdi, %rbp
	movq	%rsi, %rbx
	movq	%fs:40, %rax
	movq	%rax, 24(%rsp)
	xorl	%eax, %eax
	movq	%rsp, %rdi
	leaq	start_tv(%rip), %rdx
	leaq	stop_tv(%rip), %rsi
	call	tvsub
	imulq	$1000000, (%rsp), %rax
	addq	8(%rsp), %rax
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	mulsd	.LC11(%rip), %xmm0
	ucomisd	.LC10(%rip), %xmm0
	jp	.L154
	je	.L147
.L154:
	cmpq	$0, ftiming(%rip)
	je	.L156
.L150:
	testq	%rbx, %rbx
	js	.L151
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rbx, %xmm1
.L152:
	divsd	%xmm1, %xmm0
	movq	%rbp, %rcx
	leaq	.LC23(%rip), %rdx
	movl	$1, %esi
	movq	ftiming(%rip), %rdi
	movl	$1, %eax
	call	__fprintf_chk@PLT
.L147:
	movq	24(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L157
	addq	$40, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
.L156:
	.cfi_restore_state
	movq	stderr(%rip), %rax
	movq	%rax, ftiming(%rip)
	jmp	.L150
.L151:
	movq	%rbx, %rax
	shrq	%rax
	andl	$1, %ebx
	orq	%rbx, %rax
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rax, %xmm1
	addsd	%xmm1, %xmm1
	jmp	.L152
.L157:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE101:
	.size	nano, .-nano
	.section	.rodata.str1.1
.LC24:
	.string	"%s: %.4f microseconds\n"
	.text
	.globl	micro
	.type	micro, @function
micro:
.LFB102:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushq	%rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	subq	$40, %rsp
	.cfi_def_cfa_offset 64
	movq	%rdi, %rbp
	movq	%rsi, %rbx
	movq	%fs:40, %rax
	movq	%rax, 24(%rsp)
	xorl	%eax, %eax
	movq	%rsp, %rdi
	leaq	start_tv(%rip), %rdx
	leaq	stop_tv(%rip), %rsi
	call	tvsub
	imulq	$1000000, (%rsp), %rax
	addq	8(%rsp), %rax
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	testq	%rbx, %rbx
	js	.L159
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rbx, %xmm1
.L160:
	divsd	%xmm1, %xmm0
	ucomisd	.LC10(%rip), %xmm0
	jp	.L165
	je	.L158
.L165:
	cmpq	$0, ftiming(%rip)
	je	.L167
.L163:
	movq	%rbp, %rcx
	leaq	.LC24(%rip), %rdx
	movl	$1, %esi
	movq	ftiming(%rip), %rdi
	movl	$1, %eax
	call	__fprintf_chk@PLT
.L158:
	movq	24(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L168
	addq	$40, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
.L159:
	.cfi_restore_state
	movq	%rbx, %rax
	shrq	%rax
	andl	$1, %ebx
	orq	%rbx, %rax
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rax, %xmm1
	addsd	%xmm1, %xmm1
	jmp	.L160
.L167:
	movq	stderr(%rip), %rax
	movq	%rax, ftiming(%rip)
	jmp	.L163
.L168:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE102:
	.size	micro, .-micro
	.section	.rodata.str1.1
.LC26:
	.string	"%.6f %.0f\n"
.LC27:
	.string	"%.6f %.3f\n"
	.text
	.globl	micromb
	.type	micromb, @function
micromb:
.LFB103:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushq	%rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	subq	$40, %rsp
	.cfi_def_cfa_offset 64
	movq	%rdi, %rbp
	movq	%rsi, %rbx
	movq	%fs:40, %rax
	movq	%rax, 24(%rsp)
	xorl	%eax, %eax
	movq	%rsp, %rdi
	leaq	start_tv(%rip), %rdx
	leaq	stop_tv(%rip), %rsi
	call	tvsub
	imulq	$1000000, (%rsp), %rax
	addq	8(%rsp), %rax
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rax, %xmm1
	testq	%rbx, %rbx
	js	.L170
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rbx, %xmm0
.L171:
	divsd	%xmm0, %xmm1
	ucomisd	.LC10(%rip), %xmm1
	jp	.L181
	je	.L169
.L181:
	cmpq	$0, ftiming(%rip)
	je	.L185
.L174:
	testq	%rbp, %rbp
	js	.L175
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rbp, %xmm0
.L176:
	divsd	.LC1(%rip), %xmm0
	comisd	.LC25(%rip), %xmm1
	jb	.L183
	leaq	.LC26(%rip), %rdx
	movl	$1, %esi
	movq	ftiming(%rip), %rdi
	movl	$2, %eax
	call	__fprintf_chk@PLT
.L169:
	movq	24(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L186
	addq	$40, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
.L170:
	.cfi_restore_state
	movq	%rbx, %rax
	shrq	%rax
	andl	$1, %ebx
	orq	%rbx, %rax
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	addsd	%xmm0, %xmm0
	jmp	.L171
.L185:
	movq	stderr(%rip), %rax
	movq	%rax, ftiming(%rip)
	jmp	.L174
.L175:
	movq	%rbp, %rax
	shrq	%rax
	andl	$1, %ebp
	orq	%rbp, %rax
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	addsd	%xmm0, %xmm0
	jmp	.L176
.L183:
	leaq	.LC27(%rip), %rdx
	movl	$1, %esi
	movq	ftiming(%rip), %rdi
	movl	$2, %eax
	call	__fprintf_chk@PLT
	jmp	.L169
.L186:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE103:
	.size	micromb, .-micromb
	.section	.rodata.str1.1
.LC28:
	.string	"%s: %d milliseconds\n"
	.text
	.globl	milli
	.type	milli, @function
milli:
.LFB104:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushq	%rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	subq	$40, %rsp
	.cfi_def_cfa_offset 64
	movq	%rdi, %rbx
	movq	%rsi, %rbp
	movq	%fs:40, %rax
	movq	%rax, 24(%rsp)
	xorl	%eax, %eax
	movq	%rsp, %rdi
	leaq	start_tv(%rip), %rdx
	leaq	stop_tv(%rip), %rsi
	call	tvsub
	imulq	$1000, (%rsp), %r8
	movq	8(%rsp), %rcx
	movabsq	$2361183241434822607, %rdx
	movq	%rcx, %rax
	imulq	%rdx
	sarq	$7, %rdx
	sarq	$63, %rcx
	subq	%rcx, %rdx
	leaq	(%r8,%rdx), %rax
	movl	$0, %edx
	divq	%rbp
	testq	%rax, %rax
	js	.L189
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
.L190:
	ucomisd	.LC10(%rip), %xmm0
	jp	.L194
	je	.L187
.L194:
	cmpq	$0, ftiming(%rip)
	je	.L196
.L192:
	movl	%eax, %r8d
	movq	%rbx, %rcx
	leaq	.LC28(%rip), %rdx
	movl	$1, %esi
	movq	ftiming(%rip), %rdi
	movl	$0, %eax
	call	__fprintf_chk@PLT
.L187:
	movq	24(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L197
	addq	$40, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
.L189:
	.cfi_restore_state
	movq	%rax, %rdx
	shrq	%rdx
	movq	%rax, %rcx
	andl	$1, %ecx
	orq	%rcx, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
	jmp	.L190
.L196:
	movq	stderr(%rip), %rdx
	movq	%rdx, ftiming(%rip)
	jmp	.L192
.L197:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE104:
	.size	milli, .-milli
	.section	.rodata.str1.8
	.align 8
.LC29:
	.string	"%d in %.2f secs, %.0f microseconds each\n"
	.text
	.globl	ptime
	.type	ptime, @function
ptime:
.LFB105:
	.cfi_startproc
	endbr64
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	subq	$32, %rsp
	.cfi_def_cfa_offset 48
	movq	%rdi, %rbx
	movq	%fs:40, %rax
	movq	%rax, 24(%rsp)
	xorl	%eax, %eax
	movq	%rsp, %rdi
	leaq	start_tv(%rip), %rdx
	leaq	stop_tv(%rip), %rsi
	call	tvsub
	pxor	%xmm0, %xmm0
	cvtsi2sdq	8(%rsp), %xmm0
	divsd	.LC1(%rip), %xmm0
	pxor	%xmm1, %xmm1
	cvtsi2sdq	(%rsp), %xmm1
	addsd	%xmm1, %xmm0
	ucomisd	.LC10(%rip), %xmm0
	jp	.L205
	je	.L198
.L205:
	cmpq	$0, ftiming(%rip)
	je	.L207
.L201:
	movapd	%xmm0, %xmm1
	mulsd	.LC1(%rip), %xmm1
	testq	%rbx, %rbx
	js	.L202
	pxor	%xmm2, %xmm2
	cvtsi2sdq	%rbx, %xmm2
.L203:
	divsd	%xmm2, %xmm1
	movl	%ebx, %ecx
	leaq	.LC29(%rip), %rdx
	movl	$1, %esi
	movq	ftiming(%rip), %rdi
	movl	$2, %eax
	call	__fprintf_chk@PLT
.L198:
	movq	24(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L208
	addq	$32, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 16
	popq	%rbx
	.cfi_def_cfa_offset 8
	ret
.L207:
	.cfi_restore_state
	movq	stderr(%rip), %rax
	movq	%rax, ftiming(%rip)
	jmp	.L201
.L202:
	movq	%rbx, %rax
	shrq	%rax
	movq	%rbx, %rdx
	andl	$1, %edx
	orq	%rdx, %rax
	pxor	%xmm2, %xmm2
	cvtsi2sdq	%rax, %xmm2
	addsd	%xmm2, %xmm2
	jmp	.L203
.L208:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE105:
	.size	ptime, .-ptime
	.globl	tvdelta
	.type	tvdelta, @function
tvdelta:
.LFB106:
	.cfi_startproc
	endbr64
	subq	$40, %rsp
	.cfi_def_cfa_offset 48
	movq	%rdi, %rdx
	movq	%fs:40, %rax
	movq	%rax, 24(%rsp)
	xorl	%eax, %eax
	movq	%rsp, %rdi
	call	tvsub
	imulq	$1000000, (%rsp), %rax
	addq	8(%rsp), %rax
	movq	24(%rsp), %rdx
	subq	%fs:40, %rdx
	jne	.L212
	addq	$40, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	ret
.L212:
	.cfi_restore_state
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE106:
	.size	tvdelta, .-tvdelta
	.globl	stop
	.type	stop, @function
stop:
.LFB88:
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
	movq	%rdi, %rbp
	movq	%rsi, %rbx
	testq	%rsi, %rsi
	leaq	stop_tv(%rip), %rax
	cmove	%rax, %rbx
	movl	$0, %esi
	movq	%rbx, %rdi
	call	gettimeofday@PLT
	leaq	ru_stop(%rip), %rsi
	movl	$0, %edi
	call	getrusage@PLT
	testq	%rbp, %rbp
	leaq	start_tv(%rip), %rax
	cmove	%rax, %rbp
	movq	%rbx, %rsi
	movq	%rbp, %rdi
	call	tvdelta
	addq	$8, %rsp
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE88:
	.size	stop, .-stop
	.globl	usecs_spent
	.type	usecs_spent, @function
usecs_spent:
.LFB108:
	.cfi_startproc
	endbr64
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	leaq	stop_tv(%rip), %rsi
	leaq	start_tv(%rip), %rdi
	call	tvdelta
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE108:
	.size	usecs_spent, .-usecs_spent
	.globl	timespent
	.type	timespent, @function
timespent:
.LFB109:
	.cfi_startproc
	endbr64
	subq	$40, %rsp
	.cfi_def_cfa_offset 48
	movq	%fs:40, %rax
	movq	%rax, 24(%rsp)
	xorl	%eax, %eax
	movq	%rsp, %rdi
	leaq	start_tv(%rip), %rdx
	leaq	stop_tv(%rip), %rsi
	call	tvsub
	pxor	%xmm0, %xmm0
	cvtsi2sdq	8(%rsp), %xmm0
	divsd	.LC1(%rip), %xmm0
	pxor	%xmm1, %xmm1
	cvtsi2sdq	(%rsp), %xmm1
	addsd	%xmm1, %xmm0
	movq	24(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L222
	addq	$40, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	ret
.L222:
	.cfi_restore_state
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE109:
	.size	timespent, .-timespent
	.section	.rodata.str1.8
	.align 8
.LC30:
	.string	"real=%.2f sys=%.2f user=%.2f idle=%.2f stall=%.0f%% "
	.align 8
.LC31:
	.string	"rd=%d wr=%d min=%d maj=%d ctx=%d\n"
	.text
	.globl	rusage
	.type	rusage, @function
rusage:
.LFB72:
	.cfi_startproc
	endbr64
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	subq	$32, %rsp
	.cfi_def_cfa_offset 48
	pxor	%xmm0, %xmm0
	cvtsi2sdq	24+ru_stop(%rip), %xmm0
	movsd	.LC1(%rip), %xmm2
	divsd	%xmm2, %xmm0
	pxor	%xmm1, %xmm1
	cvtsi2sdq	16+ru_stop(%rip), %xmm1
	addsd	%xmm0, %xmm1
	pxor	%xmm0, %xmm0
	cvtsi2sdq	24+ru_start(%rip), %xmm0
	divsd	%xmm2, %xmm0
	pxor	%xmm3, %xmm3
	cvtsi2sdq	16+ru_start(%rip), %xmm3
	addsd	%xmm3, %xmm0
	subsd	%xmm0, %xmm1
	movsd	%xmm1, 8(%rsp)
	pxor	%xmm0, %xmm0
	cvtsi2sdq	8+ru_stop(%rip), %xmm0
	divsd	%xmm2, %xmm0
	pxor	%xmm1, %xmm1
	cvtsi2sdq	ru_stop(%rip), %xmm1
	addsd	%xmm0, %xmm1
	pxor	%xmm0, %xmm0
	cvtsi2sdq	8+ru_start(%rip), %xmm0
	divsd	%xmm2, %xmm0
	pxor	%xmm2, %xmm2
	cvtsi2sdq	ru_start(%rip), %xmm2
	addsd	%xmm2, %xmm0
	movapd	%xmm1, %xmm5
	subsd	%xmm0, %xmm5
	movsd	%xmm5, 16(%rsp)
	call	timespent
	movsd	8(%rsp), %xmm1
	addsd	16(%rsp), %xmm1
	subsd	%xmm1, %xmm0
	movsd	%xmm0, 24(%rsp)
	call	timespent
	movapd	%xmm0, %xmm1
	movsd	24(%rsp), %xmm0
	divsd	%xmm1, %xmm0
	mulsd	.LC17(%rip), %xmm0
	movq	%xmm0, %rbx
	cmpq	$0, ftiming(%rip)
	je	.L226
.L224:
	call	timespent
	movq	%rbx, %xmm4
	movsd	24(%rsp), %xmm3
	movsd	16(%rsp), %xmm2
	movsd	8(%rsp), %xmm1
	leaq	.LC30(%rip), %rdx
	movl	$1, %esi
	movq	ftiming(%rip), %rdi
	movl	$5, %eax
	call	__fprintf_chk@PLT
	movq	88+ru_stop(%rip), %rcx
	subl	88+ru_start(%rip), %ecx
	movq	128+ru_stop(%rip), %rax
	subl	128+ru_start(%rip), %eax
	subl	136+ru_start(%rip), %eax
	addl	136+ru_stop(%rip), %eax
	pushq	%rax
	.cfi_def_cfa_offset 56
	movq	72+ru_stop(%rip), %rax
	subl	72+ru_start(%rip), %eax
	pushq	%rax
	.cfi_def_cfa_offset 64
	movq	64+ru_stop(%rip), %r9
	subl	64+ru_start(%rip), %r9d
	movq	96+ru_stop(%rip), %r8
	subl	96+ru_start(%rip), %r8d
	leaq	.LC31(%rip), %rdx
	movl	$1, %esi
	movq	ftiming(%rip), %rdi
	movl	$0, %eax
	call	__fprintf_chk@PLT
	addq	$48, %rsp
	.cfi_def_cfa_offset 16
	popq	%rbx
	.cfi_def_cfa_offset 8
	ret
.L226:
	.cfi_def_cfa_offset 48
	movq	stderr(%rip), %rax
	movq	%rax, ftiming(%rip)
	jmp	.L224
	.cfi_endproc
.LFE72:
	.size	rusage, .-rusage
	.section	.rodata.str1.1
.LC32:
	.string	"0x%x%08x"
.LC33:
	.string	"0x%x"
	.text
	.globl	p64
	.type	p64, @function
p64:
.LFB110:
	.cfi_startproc
	endbr64
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movl	n(%rip), %edx
	leal	1(%rdx), %eax
	movslq	%edx, %rcx
	leaq	(%rcx,%rcx,4), %rsi
	leaq	p64buf(%rip), %rcx
	leaq	(%rcx,%rsi,4), %rbx
	cmpl	$9, %edx
	movl	$0, %edx
	cmove	%edx, %eax
	movl	%eax, n(%rip)
	movq	%rdi, %r8
	sarq	$32, %r8
	testl	%r8d, %r8d
	je	.L230
	movl	%edi, %r9d
	leaq	.LC32(%rip), %rcx
	movq	$-1, %rdx
	movl	$1, %esi
	movq	%rbx, %rdi
	movl	$0, %eax
	call	__sprintf_chk@PLT
.L227:
	movq	%rbx, %rax
	popq	%rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	ret
.L230:
	.cfi_restore_state
	movl	%edi, %r8d
	leaq	.LC33(%rip), %rcx
	movq	$-1, %rdx
	movl	$1, %esi
	movq	%rbx, %rdi
	movl	$0, %eax
	call	__sprintf_chk@PLT
	jmp	.L227
	.cfi_endproc
.LFE110:
	.size	p64, .-p64
	.section	.rodata.str1.1
.LC34:
	.string	"0"
.LC37:
	.string	" KMGTPE"
.LC38:
	.string	"%.4f%c"
.LC39:
	.string	"%.2f%c"
	.text
	.globl	p64sz
	.type	p64sz, @function
p64sz:
.LFB111:
	.cfi_startproc
	endbr64
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	testq	%rdi, %rdi
	js	.L234
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdi, %xmm0
.L235:
	movl	n(%rip), %edx
	leal	1(%rdx), %eax
	cmpl	$9, %edx
	movl	$0, %ecx
	cmove	%ecx, %eax
	movl	%eax, n(%rip)
	movl	$0, %eax
	movsd	.LC36(%rip), %xmm2
	movsd	.LC35(%rip), %xmm1
	comisd	%xmm1, %xmm0
	jbe	.L252
.L240:
	addl	$1, %eax
	mulsd	%xmm2, %xmm0
	comisd	%xmm1, %xmm0
	ja	.L240
.L238:
	ucomisd	.LC10(%rip), %xmm0
	jp	.L248
	leaq	.LC34(%rip), %rbx
	je	.L233
.L248:
	movslq	%edx, %rdx
	leaq	(%rdx,%rdx,4), %rcx
	leaq	p64buf(%rip), %rdx
	leaq	(%rdx,%rcx,4), %rbx
	movsd	.LC17(%rip), %xmm1
	comisd	%xmm0, %xmm1
	jbe	.L253
	cltq
	leaq	.LC37(%rip), %rdx
	movsbl	(%rdx,%rax), %r8d
	leaq	.LC38(%rip), %rcx
	movq	$-1, %rdx
	movl	$1, %esi
	movq	%rbx, %rdi
	movl	$1, %eax
	call	__sprintf_chk@PLT
.L233:
	movq	%rbx, %rax
	popq	%rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	ret
.L234:
	.cfi_restore_state
	movq	%rdi, %rax
	shrq	%rax
	andl	$1, %edi
	orq	%rdi, %rax
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	addsd	%xmm0, %xmm0
	jmp	.L235
.L252:
	movl	$0, %eax
	jmp	.L238
.L253:
	cltq
	leaq	.LC37(%rip), %rdx
	movsbl	(%rdx,%rax), %r8d
	leaq	.LC39(%rip), %rcx
	movq	$-1, %rdx
	movl	$1, %esi
	movq	%rbx, %rdi
	movl	$1, %eax
	call	__sprintf_chk@PLT
	jmp	.L233
	.cfi_endproc
.LFE111:
	.size	p64sz, .-p64sz
	.globl	last
	.type	last, @function
last:
.LFB112:
	.cfi_startproc
	endbr64
.L256:
	addq	$1, %rdi
	cmpb	$0, -1(%rdi)
	jne	.L256
	movzbl	-2(%rdi), %eax
	ret
	.cfi_endproc
.LFE112:
	.size	last, .-last
	.section	.rodata.str1.1
.LC40:
	.string	"%llu"
	.text
	.globl	bytes
	.type	bytes, @function
bytes:
.LFB113:
	.cfi_startproc
	endbr64
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	subq	$16, %rsp
	.cfi_def_cfa_offset 32
	movq	%rdi, %rbx
	movq	%fs:40, %rax
	movq	%rax, 8(%rsp)
	xorl	%eax, %eax
	movq	%rsp, %rdx
	leaq	.LC40(%rip), %rsi
	call	__isoc99_sscanf@PLT
	movl	%eax, %edx
	movl	$0, %eax
	testl	%edx, %edx
	jle	.L258
	movq	%rbx, %rdi
	call	last
	subl	$71, %eax
	cmpb	$38, %al
	ja	.L260
	movzbl	%al, %eax
	leaq	.L262(%rip), %rdx
	movslq	(%rdx,%rax,4), %rax
	addq	%rdx, %rax
	notrack jmp	*%rax
	.section	.rodata
	.align 4
	.align 4
.L262:
	.long	.L267-.L262
	.long	.L260-.L262
	.long	.L260-.L262
	.long	.L260-.L262
	.long	.L266-.L262
	.long	.L260-.L262
	.long	.L265-.L262
	.long	.L260-.L262
	.long	.L260-.L262
	.long	.L260-.L262
	.long	.L260-.L262
	.long	.L260-.L262
	.long	.L260-.L262
	.long	.L260-.L262
	.long	.L260-.L262
	.long	.L260-.L262
	.long	.L260-.L262
	.long	.L260-.L262
	.long	.L260-.L262
	.long	.L260-.L262
	.long	.L260-.L262
	.long	.L260-.L262
	.long	.L260-.L262
	.long	.L260-.L262
	.long	.L260-.L262
	.long	.L260-.L262
	.long	.L260-.L262
	.long	.L260-.L262
	.long	.L260-.L262
	.long	.L260-.L262
	.long	.L260-.L262
	.long	.L260-.L262
	.long	.L264-.L262
	.long	.L260-.L262
	.long	.L260-.L262
	.long	.L260-.L262
	.long	.L263-.L262
	.long	.L260-.L262
	.long	.L261-.L262
	.text
.L263:
	salq	$10, (%rsp)
.L260:
	movq	(%rsp), %rax
.L258:
	movq	8(%rsp), %rdx
	subq	%fs:40, %rdx
	jne	.L271
	addq	$16, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 16
	popq	%rbx
	.cfi_def_cfa_offset 8
	ret
.L266:
	.cfi_restore_state
	imulq	$1000, (%rsp), %rax
	movq	%rax, (%rsp)
	jmp	.L260
.L261:
	salq	$20, (%rsp)
	jmp	.L260
.L265:
	imulq	$1000000, (%rsp), %rax
	movq	%rax, (%rsp)
	jmp	.L260
.L264:
	salq	$30, (%rsp)
	jmp	.L260
.L267:
	imulq	$1000000000, (%rsp), %rax
	movq	%rax, (%rsp)
	jmp	.L260
.L271:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE113:
	.size	bytes, .-bytes
	.globl	use_int
	.type	use_int, @function
use_int:
.LFB114:
	.cfi_startproc
	endbr64
	movq	use_result_dummy(%rip), %rax
	movslq	%edi, %rdi
	addq	%rax, %rdi
	movq	%rdi, use_result_dummy(%rip)
	ret
	.cfi_endproc
.LFE114:
	.size	use_int, .-use_int
	.globl	use_pointer
	.type	use_pointer, @function
use_pointer:
.LFB115:
	.cfi_startproc
	endbr64
	movq	use_result_dummy(%rip), %rax
	addq	%rax, %rdi
	movq	%rdi, use_result_dummy(%rip)
	ret
	.cfi_endproc
.LFE115:
	.size	use_pointer, .-use_pointer
	.globl	sizeof_result
	.type	sizeof_result, @function
sizeof_result:
.LFB116:
	.cfi_startproc
	endbr64
	movl	%edi, %eax
	sall	$4, %eax
	leal	8(%rax), %eax
	cmpl	$11, %edi
	movl	$184, %edx
	cmovle	%edx, %eax
	ret
	.cfi_endproc
.LFE116:
	.size	sizeof_result, .-sizeof_result
	.globl	insertinit
	.type	insertinit, @function
insertinit:
.LFB117:
	.cfi_startproc
	endbr64
	movl	$0, (%rdi)
	ret
	.cfi_endproc
.LFE117:
	.size	insertinit, .-insertinit
	.globl	insertsort
	.type	insertsort, @function
insertsort:
.LFB118:
	.cfi_startproc
	endbr64
	movq	%rsi, %r8
	movq	%rdx, %r9
	testq	%rdi, %rdi
	je	.L278
	movl	(%rdx), %esi
	testl	%esi, %esi
	jle	.L293
	testq	%rdi, %rdi
	js	.L281
	pxor	%xmm2, %xmm2
	cvtsi2sdq	%rdi, %xmm2
.L282:
	testq	%r8, %r8
	js	.L283
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%r8, %xmm0
.L284:
	divsd	%xmm0, %xmm2
	leaq	8(%r9), %rcx
	movl	$0, %edx
	jmp	.L292
.L281:
	movq	%rdi, %rax
	shrq	%rax
	movq	%rdi, %rdx
	andl	$1, %edx
	orq	%rdx, %rax
	pxor	%xmm2, %xmm2
	cvtsi2sdq	%rax, %xmm2
	addsd	%xmm2, %xmm2
	jmp	.L282
.L283:
	movq	%r8, %rax
	shrq	%rax
	movq	%r8, %rdx
	andl	$1, %edx
	orq	%rdx, %rax
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	addsd	%xmm0, %xmm0
	jmp	.L284
.L286:
	movq	%rax, %r11
	shrq	%r11
	andl	$1, %eax
	orq	%rax, %r11
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%r11, %xmm0
	addsd	%xmm0, %xmm0
	jmp	.L287
.L288:
	movq	%rax, %r10
	shrq	%r10
	andl	$1, %eax
	orq	%rax, %r10
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%r10, %xmm1
	addsd	%xmm1, %xmm1
.L289:
	divsd	%xmm1, %xmm0
	comisd	%xmm0, %xmm2
	ja	.L298
	addl	$1, %edx
	addq	$16, %rcx
	cmpl	%esi, %edx
	je	.L299
.L292:
	movq	%rcx, %r10
	movq	(%rcx), %rax
	testq	%rax, %rax
	js	.L286
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
.L287:
	movq	8(%r10), %rax
	testq	%rax, %rax
	js	.L288
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rax, %xmm1
	jmp	.L289
.L298:
	cmpl	%edx, %esi
	jle	.L280
	movslq	%esi, %rcx
	salq	$4, %rcx
	leaq	(%r9,%rcx), %rax
	leaq	-16(%r9,%rcx), %rcx
	leal	-1(%rsi), %r10d
	subl	%edx, %r10d
	salq	$4, %r10
	subq	%r10, %rcx
.L291:
	movdqu	-8(%rax), %xmm3
	movups	%xmm3, 8(%rax)
	subq	$16, %rax
	cmpq	%rcx, %rax
	jne	.L291
	jmp	.L280
.L299:
	movl	%esi, %edx
.L280:
	movslq	%edx, %rdx
	salq	$4, %rdx
	addq	%r9, %rdx
	movq	%rdi, 8(%rdx)
	movq	%r8, 16(%rdx)
	addl	$1, %esi
	movl	%esi, (%r9)
.L278:
	ret
.L293:
	movl	$0, %edx
	jmp	.L280
	.cfi_endproc
.LFE118:
	.size	insertsort, .-insertsort
	.globl	get_results
	.type	get_results, @function
get_results:
.LFB119:
	.cfi_startproc
	endbr64
	movq	results(%rip), %rax
	ret
	.cfi_endproc
.LFE119:
	.size	get_results, .-get_results
	.globl	save_minimum
	.type	save_minimum, @function
save_minimum:
.LFB121:
	.cfi_startproc
	endbr64
	movq	results(%rip), %rdx
	movl	(%rdx), %eax
	testl	%eax, %eax
	jne	.L302
	movq	$1, iterations(%rip)
	movl	$0, %edi
	call	settime
	ret
.L302:
	cltq
	salq	$4, %rax
	addq	%rax, %rdx
	movq	(%rdx), %rax
	movq	%rax, iterations(%rip)
	movq	-8(%rdx), %rdi
	call	settime
	ret
	.cfi_endproc
.LFE121:
	.size	save_minimum, .-save_minimum
	.globl	save_median
	.type	save_median, @function
save_median:
.LFB122:
	.cfi_startproc
	endbr64
	movq	results(%rip), %rdx
	movl	(%rdx), %ecx
	testl	%ecx, %ecx
	je	.L307
	movl	%ecx, %eax
	shrl	$31, %eax
	addl	%ecx, %eax
	sarl	%eax
	testb	$1, %cl
	je	.L306
	cltq
	salq	$4, %rax
	addq	%rax, %rdx
	movq	16(%rdx), %rax
	movq	8(%rdx), %rdi
	jmp	.L305
.L306:
	cltq
	salq	$4, %rax
	addq	%rax, %rdx
	movq	(%rdx), %rax
	addq	16(%rdx), %rax
	shrq	%rax
	movq	-8(%rdx), %rdi
	addq	8(%rdx), %rdi
	shrq	%rdi
	jmp	.L305
.L307:
	movl	$1, %eax
	movl	$0, %edi
.L305:
	movq	%rax, iterations(%rip)
	call	settime
	ret
	.cfi_endproc
.LFE122:
	.size	save_median, .-save_median
	.globl	set_results
	.type	set_results, @function
set_results:
.LFB120:
	.cfi_startproc
	endbr64
	movq	%rdi, results(%rip)
	movl	$0, %eax
	call	save_median
	ret
	.cfi_endproc
.LFE120:
	.size	set_results, .-set_results
	.type	time_N, @function
time_N:
.LFB131:
	.cfi_startproc
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
	subq	$216, %rsp
	.cfi_def_cfa_offset 272
	movq	%rdi, %rbp
	movq	%fs:40, %rax
	movq	%rax, 200(%rsp)
	xorl	%eax, %eax
	movq	results(%rip), %r14
	movl	$0, 16(%rsp)
	movl	$10, %r12d
	leaq	8(%rsp), %r13
	jmp	.L312
.L311:
	movq	(%rbx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rdx
	movq	(%rdx), %rbx
	subq	$1, %rax
	cmpq	$-1, %rax
	jne	.L311
.L310:
	movl	$0, %esi
	movl	$0, %edi
	call	stop
	movq	%rax, %r15
	movq	%rbx, %rdi
	call	use_pointer
	leaq	16(%rsp), %rdx
	movq	%rbp, %rsi
	movq	%r15, %rdi
	call	insertsort
	subl	$1, %r12d
	je	.L318
.L312:
	movq	%r13, 8(%rsp)
	movl	$0, %edi
	call	start
	leaq	-1(%rbp), %rax
	testq	%rbp, %rbp
	jle	.L314
	movq	%r13, %rbx
	jmp	.L311
.L314:
	movq	%r13, %rbx
	jmp	.L310
.L318:
	leaq	16(%rsp), %rax
	movq	%rax, results(%rip)
	movl	$0, %eax
	call	save_median
	movl	$0, %eax
	call	save_minimum
	call	usecs_spent
	movq	%rax, %rbx
	movq	%r14, results(%rip)
	movl	$0, %eax
	call	save_median
	movq	200(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L319
	movq	%rbx, %rax
	addq	$216, %rsp
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
.L319:
	.cfi_restore_state
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE131:
	.size	time_N, .-time_N
	.globl	benchmp_parent
	.type	benchmp_parent, @function
benchmp_parent:
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
	subq	$424, %rsp
	.cfi_def_cfa_offset 480
	movl	%edi, %r15d
	movl	%esi, 40(%rsp)
	movl	%edx, 44(%rsp)
	movl	%ecx, 64(%rsp)
	movq	%r8, %rbp
	movl	%r9d, 28(%rsp)
	movq	%fs:40, %rax
	movq	%rax, 408(%rsp)
	xorl	%eax, %eax
	movl	benchmp_sigchld_received(%rip), %eax
	orl	benchmp_sigterm_received(%rip), %eax
	movl	%eax, 68(%rsp)
	je	.L380
	movl	$0, %esi
	movl	$17, %edi
	call	signal@PLT
	movq	$0, 16(%rsp)
	movq	$0, 48(%rsp)
	movq	$0, 32(%rsp)
	cmpl	$0, 28(%rsp)
	jle	.L381
.L350:
	movl	$0, %ebx
	movl	28(%rsp), %r12d
.L347:
	movl	0(%rbp,%rbx,4), %edi
	movl	$15, %esi
	call	kill@PLT
	movl	0(%rbp,%rbx,4), %edi
	movl	$0, %edx
	movl	$0, %esi
	call	waitpid@PLT
	addq	$1, %rbx
	cmpl	%ebx, %r12d
	jg	.L347
	movq	48(%rsp), %rdi
	call	free@PLT
	movl	%r15d, %edi
	call	close@PLT
	movl	40(%rsp), %edi
	call	close@PLT
	movl	44(%rsp), %edi
	call	close@PLT
	movl	64(%rsp), %edi
	call	close@PLT
	cmpq	$0, 32(%rsp)
	je	.L348
.L346:
	movq	32(%rsp), %rdi
	call	free@PLT
.L348:
	movq	16(%rsp), %rax
	testq	%rax, %rax
	je	.L320
	movq	%rax, %rdi
	call	free@PLT
.L320:
	movq	408(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L382
	addq	$424, %rsp
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
.L380:
	.cfi_restore_state
	movl	%r9d, %r14d
	movl	%eax, %ebx
	movl	496(%rsp), %edi
	call	sizeof_result
	movl	%eax, 76(%rsp)
	movslq	%eax, %rdi
	call	malloc@PLT
	movq	%rax, %r13
	movq	%rax, 32(%rsp)
	movl	%r14d, %edi
	imull	496(%rsp), %edi
	call	sizeof_result
	movslq	%eax, %rdi
	call	malloc@PLT
	movq	%rax, %r12
	movq	%rax, 48(%rsp)
	movslq	%r14d, %r14
	movq	%r14, 8(%rsp)
	movq	%r14, %rdi
	call	malloc@PLT
	movq	%rax, %rcx
	movq	%rax, 16(%rsp)
	testq	%r13, %r13
	sete	%al
	testq	%r12, %r12
	sete	%dl
	orb	%dl, %al
	jne	.L320
	testq	%rcx, %rcx
	je	.L320
	testq	%r14, %r14
	je	.L323
	movl	$1, %r14d
	movl	%r15d, %ecx
	salq	%cl, %r14
	movl	%ebx, (%rsp)
	movl	$0, %r13d
	leaq	272(%rsp), %rbx
	movq	%rbp, 56(%rsp)
	jmp	.L324
.L328:
	addl	%ebp, (%rsp)
	movl	(%rsp), %eax
	movslq	%eax, %r13
	cmpq	%r13, 8(%rsp)
	jbe	.L329
.L324:
	leaq	144(%rsp), %rax
.L325:
	movq	$0, (%rax)
	addq	$8, %rax
	cmpq	%rax, %rbx
	jne	.L325
	leaq	272(%rsp), %rax
	leaq	400(%rsp), %rdx
.L326:
	movq	$0, (%rax)
	addq	$8, %rax
	cmpq	%rax, %rdx
	jne	.L326
	movslq	%r15d, %r12
	movq	%r12, %rdi
	call	__fdelt_chk@PLT
	orq	%r14, 144(%rsp,%rax,8)
	movq	%r12, %rdi
	call	__fdelt_chk@PLT
	orq	%r14, 272(%rsp,%rax,8)
	movq	$1, 112(%rsp)
	movq	$0, 120(%rsp)
	leaq	144(%rsp), %rsi
	leal	1(%r15), %edi
	leaq	112(%rsp), %r8
	movq	%rbx, %rcx
	movl	$0, %edx
	call	select@PLT
	movl	benchmp_sigchld_received(%rip), %ebp
	orl	benchmp_sigterm_received(%rip), %ebp
	jne	.L374
	movq	%r12, %rdi
	call	__fdelt_chk@PLT
	movq	%r14, %rcx
	andq	272(%rsp,%rax,8), %rcx
	jne	.L375
	movq	%r12, %rdi
	call	__fdelt_chk@PLT
	movq	%r14, %rcx
	andq	144(%rsp,%rax,8), %rcx
	je	.L328
	movq	8(%rsp), %rdx
	subq	%r13, %rdx
	movq	16(%rsp), %rsi
	movl	%r15d, %edi
	call	read@PLT
	movl	%eax, %ebp
	testl	%eax, %eax
	jns	.L328
	movq	56(%rsp), %rbp
	jmp	.L327
.L358:
	movl	68(%rsp), %edx
.L334:
	addl	%edx, %r15d
	movslq	%r15d, %rbp
	cmpq	%rbp, 8(%rsp)
	jbe	.L335
.L331:
	movq	(%rsp), %rax
.L332:
	movq	$0, (%rax)
	addq	$8, %rax
	cmpq	%rbx, %rax
	jne	.L332
	movq	%rbx, %rax
.L333:
	movq	$0, (%rax)
	addq	$8, %rax
	cmpq	%rax, %r12
	jne	.L333
	movq	%r13, %rdi
	call	__fdelt_chk@PLT
	orq	%r14, 144(%rsp,%rax,8)
	movq	%r13, %rdi
	call	__fdelt_chk@PLT
	orq	%r14, 272(%rsp,%rax,8)
	movq	$1, 112(%rsp)
	movq	$0, 120(%rsp)
	movl	56(%rsp), %eax
	addl	$1, %eax
	movl	%eax, 72(%rsp)
	leaq	112(%rsp), %r8
	movq	%rbx, %rcx
	movl	$0, %edx
	movq	(%rsp), %rsi
	movl	%eax, %edi
	call	select@PLT
	movl	benchmp_sigchld_received(%rip), %eax
	orl	benchmp_sigterm_received(%rip), %eax
	movl	%eax, 68(%rsp)
	jne	.L377
	movq	%r13, %rdi
	call	__fdelt_chk@PLT
	movq	%r14, %rcx
	andq	272(%rsp,%rax,8), %rcx
	jne	.L378
	movq	%r13, %rdi
	call	__fdelt_chk@PLT
	movq	%r14, %rcx
	andq	144(%rsp,%rax,8), %rcx
	je	.L358
	movq	8(%rsp), %rdx
	subq	%rbp, %rdx
	movq	16(%rsp), %rsi
	movl	56(%rsp), %edi
	call	read@PLT
	movl	%eax, %edx
	testl	%eax, %eax
	jns	.L334
	movl	56(%rsp), %r15d
	movq	80(%rsp), %rbp
	jmp	.L327
.L335:
	movl	56(%rsp), %r15d
	movq	80(%rsp), %rbp
	movq	48(%rsp), %rax
	movl	$0, (%rax)
	cmpl	$0, 28(%rsp)
	jle	.L337
	movl	68(%rsp), %eax
	movl	%eax, 80(%rsp)
	leaq	112(%rsp), %rax
	movq	%rax, 88(%rsp)
	movl	%r15d, 56(%rsp)
	movq	%rbp, 96(%rsp)
.L336:
	movq	(%rsp), %rax
.L338:
	movq	$0, (%rax)
	addq	$8, %rax
	cmpq	%rbx, %rax
	jne	.L338
	movq	%rbx, %rax
.L339:
	movq	$0, (%rax)
	addq	$8, %rax
	cmpq	%r12, %rax
	jne	.L339
	movl	$1, %edx
	movq	32(%rsp), %rbp
	movq	%rbp, %rsi
	movl	44(%rsp), %edi
	call	write@PLT
	movl	76(%rsp), %eax
	testl	%eax, %eax
	jle	.L340
	movl	%eax, %r15d
	movq	%rbx, 104(%rsp)
	movq	%rbp, %rbx
	jmp	.L343
.L342:
	subl	%ebp, %r15d
	movslq	%ebp, %rbp
	addq	%rbp, %rbx
	testl	%r15d, %r15d
	jle	.L383
.L343:
	movq	%r13, %rdi
	call	__fdelt_chk@PLT
	orq	%r14, 144(%rsp,%rax,8)
	movq	%r13, %rdi
	call	__fdelt_chk@PLT
	orq	%r14, 272(%rsp,%rax,8)
	movq	$1, 112(%rsp)
	movq	$0, 120(%rsp)
	leaq	272(%rsp), %rcx
	leaq	144(%rsp), %rsi
	movq	88(%rsp), %r8
	movl	$0, %edx
	movl	72(%rsp), %edi
	call	select@PLT
	movl	benchmp_sigchld_received(%rip), %ebp
	orl	benchmp_sigterm_received(%rip), %ebp
	jne	.L341
	movq	%r13, %rdi
	call	__fdelt_chk@PLT
	movq	%r14, %rcx
	andq	272(%rsp,%rax,8), %rcx
	jne	.L341
	movq	%r13, %rdi
	call	__fdelt_chk@PLT
	movq	%r14, %rcx
	andq	144(%rsp,%rax,8), %rcx
	je	.L342
	movslq	%r15d, %rdx
	movq	%rbx, %rsi
	movl	56(%rsp), %edi
	call	read@PLT
	movl	%eax, %ebp
	testl	%eax, %eax
	jns	.L342
.L341:
	movl	56(%rsp), %r15d
	movq	96(%rsp), %rbp
	movl	$0, %esi
	movl	$17, %edi
	call	signal@PLT
	jmp	.L350
.L383:
	movq	104(%rsp), %rbx
.L340:
	movq	32(%rsp), %rax
	cmpl	$0, (%rax)
	jle	.L344
	leaq	8(%rax), %rbp
	movl	68(%rsp), %r15d
.L345:
	movq	8(%rbp), %rsi
	movq	48(%rsp), %rdx
	movq	0(%rbp), %rdi
	call	insertsort
	addl	$1, %r15d
	addq	$16, %rbp
	movq	32(%rsp), %rax
	cmpl	%r15d, (%rax)
	jg	.L345
.L344:
	addl	$1, 80(%rsp)
	movl	80(%rsp), %eax
	cmpl	%eax, 28(%rsp)
	jne	.L336
	movl	56(%rsp), %r15d
	jmp	.L337
.L374:
	movq	56(%rsp), %rbp
.L327:
	movl	$0, %esi
	movl	$17, %edi
	call	signal@PLT
	cmpl	$0, 28(%rsp)
	jg	.L350
	movq	48(%rsp), %rdi
	call	free@PLT
	movl	%r15d, %edi
	call	close@PLT
	movl	40(%rsp), %edi
	call	close@PLT
	movl	44(%rsp), %edi
	call	close@PLT
	movl	64(%rsp), %edi
	call	close@PLT
	jmp	.L346
.L375:
	movq	56(%rsp), %rbp
	jmp	.L327
.L377:
	movl	56(%rsp), %r15d
	movq	80(%rsp), %rbp
	jmp	.L327
.L378:
	movl	56(%rsp), %r15d
	movq	80(%rsp), %rbp
	jmp	.L327
.L381:
	movl	%r15d, %edi
	call	close@PLT
	movl	40(%rsp), %edi
	call	close@PLT
	movl	44(%rsp), %edi
	call	close@PLT
	movl	64(%rsp), %edi
	call	close@PLT
	movq	$0, 16(%rsp)
	jmp	.L348
.L329:
	movq	56(%rsp), %rbp
	cmpl	$0, 488(%rsp)
	jg	.L354
	movq	8(%rsp), %rdx
	movq	16(%rsp), %rsi
	movl	40(%rsp), %edi
	call	write@PLT
.L353:
	movl	$1, %eax
	movl	%r15d, %ecx
	salq	%cl, %rax
	movq	%rax, %r14
	movl	$0, %ecx
	leaq	144(%rsp), %rax
	movq	%rax, (%rsp)
	leaq	272(%rsp), %rbx
	leaq	400(%rsp), %r12
	movslq	%r15d, %r13
	movl	%r15d, 56(%rsp)
	movl	68(%rsp), %r15d
	movq	%rbp, 80(%rsp)
	movq	%rcx, %rbp
	jmp	.L331
.L384:
	movq	8(%rsp), %rdx
	movq	16(%rsp), %rsi
	movl	40(%rsp), %edi
	call	write@PLT
.L330:
	movq	48(%rsp), %rax
	movl	$0, (%rax)
.L337:
	movl	$0, %esi
	movl	$17, %edi
	call	signal@PLT
	movq	8(%rsp), %rdx
	movq	32(%rsp), %rsi
	movl	64(%rsp), %ebx
	movl	%ebx, %edi
	call	write@PLT
	movq	48(%rsp), %rax
	movq	%rax, results(%rip)
	movl	$0, %eax
	call	save_median
	movl	%r15d, %edi
	call	close@PLT
	movl	40(%rsp), %edi
	call	close@PLT
	movl	44(%rsp), %edi
	call	close@PLT
	movl	%ebx, %edi
	call	close@PLT
	jmp	.L346
.L323:
	cmpl	$0, 488(%rsp)
	jle	.L384
.L354:
	movslq	488(%rsp), %rax
	imulq	$1125899907, %rax, %rax
	sarq	$50, %rax
	movl	488(%rsp), %edx
	sarl	$31, %edx
	subl	%edx, %eax
	movslq	%eax, %rdx
	movq	%rdx, 128(%rsp)
	imull	$1000000, %eax, %eax
	movl	488(%rsp), %edx
	subl	%eax, %edx
	movslq	%edx, %rax
	movq	%rax, 136(%rsp)
	leaq	128(%rsp), %r8
	movl	$0, %ecx
	movl	$0, %edx
	movl	$0, %esi
	movl	$0, %edi
	call	select@PLT
	movq	8(%rsp), %rbx
	movq	%rbx, %rdx
	movq	16(%rsp), %rsi
	movl	40(%rsp), %edi
	call	write@PLT
	testq	%rbx, %rbx
	jne	.L353
	jmp	.L330
.L382:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE79:
	.size	benchmp_parent, .-benchmp_parent
	.section	.rodata.str1.1
.LC41:
	.string	"TIMING_O"
	.text
	.globl	t_overhead
	.type	t_overhead, @function
t_overhead:
.LFB126:
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
	subq	$248, %rsp
	.cfi_def_cfa_offset 304
	movq	%fs:40, %rax
	movq	%rax, 232(%rsp)
	xorl	%eax, %eax
	call	init_timing
	movq	overhead.3(%rip), %rax
	cmpl	$0, initialized.4(%rip)
	je	.L422
.L385:
	movq	232(%rsp), %rdx
	subq	%fs:40, %rdx
	jne	.L423
	addq	$248, %rsp
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
.L422:
	.cfi_restore_state
	movl	$1, initialized.4(%rip)
	leaq	.LC41(%rip), %rdi
	call	getenv@PLT
	testq	%rax, %rax
	je	.L388
	leaq	.LC41(%rip), %rdi
	call	getenv@PLT
	movq	%rax, %rdi
	movl	$0, %esi
	call	strtod@PLT
	comisd	.LC42(%rip), %xmm0
	jnb	.L389
	cvttsd2siq	%xmm0, %rax
	movq	%rax, overhead.3(%rip)
.L391:
	movq	overhead.3(%rip), %rax
	jmp	.L385
.L389:
	subsd	.LC42(%rip), %xmm0
	cvttsd2siq	%xmm0, %rax
	movq	%rax, overhead.3(%rip)
	btcq	$63, overhead.3(%rip)
	jmp	.L391
.L388:
	call	init_timing
	cmpl	$50000, long_enough(%rip)
	jg	.L391
	movq	results(%rip), %r15
	movq	iterations(%rip), %r14
	call	usecs_spent
	movq	%rax, 24(%rsp)
	movl	$0, 48(%rsp)
	movl	$11, %r13d
	jmp	.L410
.L396:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
	jmp	.L397
.L403:
	movq	%r12, %rax
	shrq	%rax
	andl	$1, %r12d
	orq	%r12, %rax
	pxor	%xmm2, %xmm2
	cvtsi2sdq	%rax, %xmm2
	addsd	%xmm2, %xmm2
	jmp	.L404
.L405:
	subsd	.LC42(%rip), %xmm1
	cvttsd2siq	%xmm1, %rax
	movq	%rax, __iterations.2(%rip)
	btcq	$63, __iterations.2(%rip)
	jmp	.L399
.L420:
	cmpq	$134217728, %r12
	ja	.L413
	salq	$3, %r12
	movq	%r12, __iterations.2(%rip)
.L399:
	movsd	16(%rsp), %xmm4
	comisd	%xmm0, %xmm4
	jbe	.L392
.L407:
	movl	$0, %edi
	call	start
	movq	__iterations.2(%rip), %r12
	testq	%r12, %r12
	je	.L394
	movq	%r12, %rbx
	leaq	32(%rsp), %rbp
.L395:
	movl	$0, %esi
	movq	%rbp, %rdi
	call	gettimeofday@PLT
	subq	$1, %rbx
	jne	.L395
.L394:
	movl	$0, %esi
	movl	$0, %edi
	call	stop
	testq	%rax, %rax
	js	.L396
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
.L397:
	movsd	.LC44(%rip), %xmm1
	movsd	8(%rsp), %xmm3
	mulsd	%xmm3, %xmm1
	comisd	%xmm0, %xmm1
	ja	.L398
	mulsd	.LC45(%rip), %xmm3
	comisd	%xmm3, %xmm0
	jbe	.L399
.L398:
	comisd	.LC46(%rip), %xmm0
	jbe	.L420
	testq	%r12, %r12
	js	.L403
	pxor	%xmm2, %xmm2
	cvtsi2sdq	%r12, %xmm2
.L404:
	divsd	%xmm0, %xmm2
	movsd	8(%rsp), %xmm1
	mulsd	.LC47(%rip), %xmm1
	mulsd	%xmm2, %xmm1
	addsd	.LC5(%rip), %xmm1
	comisd	.LC42(%rip), %xmm1
	jnb	.L405
	cvttsd2siq	%xmm1, %rax
	movq	%rax, __iterations.2(%rip)
	jmp	.L399
.L413:
	pxor	%xmm0, %xmm0
.L392:
	movq	__iterations.2(%rip), %rbx
	movq	%rbx, iterations(%rip)
	comisd	.LC42(%rip), %xmm0
	jnb	.L408
	cvttsd2siq	%xmm0, %rdi
.L409:
	call	settime
	call	usecs_spent
	movq	%rax, %rdi
	leaq	48(%rsp), %rdx
	movq	%rbx, %rsi
	call	insertsort
	subl	$1, %r13d
	je	.L424
.L410:
	call	init_timing
	movl	long_enough(%rip), %eax
	testl	%eax, %eax
	movl	$0, %edx
	cmovs	%edx, %eax
	pxor	%xmm6, %xmm6
	cvtsi2sdl	%eax, %xmm6
	movsd	%xmm6, 8(%rsp)
	movsd	.LC43(%rip), %xmm5
	mulsd	%xmm6, %xmm5
	movsd	%xmm5, 16(%rsp)
	pxor	%xmm7, %xmm7
	comisd	%xmm7, %xmm5
	ja	.L407
	pxor	%xmm0, %xmm0
	jmp	.L392
.L408:
	subsd	.LC42(%rip), %xmm0
	cvttsd2siq	%xmm0, %rdi
	btcq	$63, %rdi
	jmp	.L409
.L424:
	leaq	48(%rsp), %rax
	movq	%rax, results(%rip)
	movl	$0, %eax
	call	save_median
	movl	$0, %eax
	call	save_minimum
	call	usecs_spent
	movl	$0, %edx
	divq	iterations(%rip)
	movq	%rax, overhead.3(%rip)
	movq	%r15, results(%rip)
	movl	$0, %eax
	call	save_median
	movq	%r14, iterations(%rip)
	movq	24(%rsp), %rdi
	call	settime
	jmp	.L391
.L423:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE126:
	.size	t_overhead, .-t_overhead
	.section	.rodata.str1.1
.LC48:
	.string	"ENOUGH"
	.text
	.type	init_timing, @function
init_timing:
.LFB128:
	.cfi_startproc
	cmpl	$0, done.9(%rip)
	je	.L470
	ret
.L470:
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
	movl	$1, done.9(%rip)
	leaq	.LC48(%rip), %rdi
	call	getenv@PLT
	leaq	possibilities(%rip), %r13
	testq	%rax, %rax
	je	.L457
	leaq	.LC48(%rip), %rdi
	call	getenv@PLT
	movq	%rax, %rdi
	movl	$10, %edx
	movl	$0, %esi
	call	strtol@PLT
	movl	%eax, %r14d
	jmp	.L428
.L472:
	movq	N.7(%rip), %rdi
	call	time_N
	movq	%rax, usecs.8(%rip)
	jmp	.L429
.L430:
	movq	%rax, %rdx
	shrq	%rdx
	movq	%rax, %rcx
	andl	$1, %ecx
	orq	%rcx, %rdx
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rdx, %xmm1
	addsd	%xmm1, %xmm1
	jmp	.L431
.L432:
	cmpq	$999, %rax
	ja	.L437
	movq	N.7(%rip), %rax
	leaq	(%rax,%rax,4), %rdi
	addq	%rdi, %rdi
.L438:
	movq	%rdi, N.7(%rip)
	call	time_N
	movq	%rax, usecs.8(%rip)
	subl	$1, %ebx
	je	.L435
.L443:
	movq	usecs.8(%rip), %rax
	testq	%rax, %rax
	js	.L430
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rax, %xmm1
.L431:
	comisd	(%rsp), %xmm1
	jbe	.L432
	movsd	8(%rsp), %xmm0
	mulsd	.LC50(%rip), %xmm0
	comisd	%xmm1, %xmm0
	jbe	.L432
	movq	N.7(%rip), %r12
	testq	%r12, %r12
	je	.L435
	movq	%r12, %rdi
	call	time_N
	movq	%rax, %rbp
	leaq	test_points(%rip), %rbx
	leaq	24(%rbx), %r15
	jmp	.L456
.L437:
	movq	N.7(%rip), %rax
	testq	%rax, %rax
	js	.L439
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
.L440:
	divsd	%xmm1, %xmm0
	mulsd	8(%rsp), %xmm0
	addsd	.LC5(%rip), %xmm0
	comisd	.LC42(%rip), %xmm0
	jnb	.L441
	cvttsd2siq	%xmm0, %rdi
	jmp	.L438
.L439:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
	jmp	.L440
.L441:
	subsd	.LC42(%rip), %xmm0
	cvttsd2siq	%xmm0, %rdi
	btcq	$63, %rdi
	jmp	.L438
.L444:
	movq	%r12, %rax
	shrq	%rax
	movq	%r12, %rdx
	andl	$1, %edx
	orq	%rdx, %rax
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	addsd	%xmm0, %xmm0
	jmp	.L445
.L446:
	movq	%rbp, %rdx
	shrq	%rdx
	movq	%rbp, %rcx
	andl	$1, %ecx
	orq	%rcx, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
	jmp	.L447
.L448:
	subsd	.LC42(%rip), %xmm0
	cvttsd2siq	%xmm0, %rdx
	movabsq	$-9223372036854775808, %rsi
	xorq	%rsi, %rdx
.L449:
	movq	%rdx, %rsi
	subq	%rax, %rsi
	movq	%rax, %rcx
	subq	%rdx, %rcx
	cmpq	%rdx, %rax
	movq	%rsi, %rax
	cmovnb	%rcx, %rax
	testq	%rax, %rax
	js	.L452
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
.L453:
	testq	%rdx, %rdx
	js	.L454
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rdx, %xmm1
.L455:
	divsd	%xmm1, %xmm0
	comisd	.LC51(%rip), %xmm0
	ja	.L435
	addq	$8, %rbx
	cmpq	%r15, %rbx
	je	.L428
.L456:
	movsd	(%rbx), %xmm6
	movsd	%xmm6, (%rsp)
	testq	%r12, %r12
	js	.L444
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%r12, %xmm0
.L445:
	mulsd	(%rsp), %xmm0
	cvttsd2sil	%xmm0, %edi
	movslq	%edi, %rdi
	call	time_N
	testq	%rbp, %rbp
	js	.L446
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rbp, %xmm0
.L447:
	mulsd	(%rsp), %xmm0
	comisd	.LC42(%rip), %xmm0
	jnb	.L448
	cvttsd2siq	%xmm0, %rdx
	jmp	.L449
.L452:
	movq	%rax, %rcx
	shrq	%rcx
	andl	$1, %eax
	orq	%rax, %rcx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rcx, %xmm0
	addsd	%xmm0, %xmm0
	jmp	.L453
.L454:
	movq	%rdx, %rax
	shrq	%rax
	andl	$1, %edx
	orq	%rdx, %rax
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rax, %xmm1
	addsd	%xmm1, %xmm1
	jmp	.L455
.L435:
	addq	$4, %r13
	leaq	16+possibilities(%rip), %rax
	cmpq	%rax, %r13
	je	.L471
.L457:
	movl	0(%r13), %r14d
	cmpq	$0, usecs.8(%rip)
	je	.L472
.L429:
	pxor	%xmm4, %xmm4
	cvtsi2sdl	%r14d, %xmm4
	movsd	%xmm4, 8(%rsp)
	movsd	.LC49(%rip), %xmm5
	mulsd	%xmm4, %xmm5
	movsd	%xmm5, (%rsp)
	movl	$10, %ebx
	jmp	.L443
.L471:
	movl	$1000000, %r14d
.L428:
	movl	%r14d, long_enough(%rip)
	call	t_overhead
	call	l_overhead
	addq	$24, %rsp
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
	.cfi_endproc
.LFE128:
	.size	init_timing, .-init_timing
	.section	.rodata.str1.1
.LC52:
	.string	"LOOP_O"
	.text
	.globl	l_overhead
	.type	l_overhead, @function
l_overhead:
.LFB125:
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
	subq	$408, %rsp
	.cfi_def_cfa_offset 464
	movq	%fs:40, %rax
	movq	%rax, 392(%rsp)
	xorl	%eax, %eax
	call	init_timing
	movsd	overhead.10(%rip), %xmm0
	cmpl	$0, initialized.11(%rip)
	je	.L546
.L473:
	movq	392(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L547
	addq	$408, %rsp
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
.L546:
	.cfi_restore_state
	movl	$1, initialized.11(%rip)
	leaq	.LC52(%rip), %rdi
	call	getenv@PLT
	testq	%rax, %rax
	je	.L476
	leaq	.LC52(%rip), %rdi
	call	getenv@PLT
	movq	%rax, %rdi
	movl	$0, %esi
	call	strtod@PLT
	movsd	%xmm0, overhead.10(%rip)
.L477:
	movsd	overhead.10(%rip), %xmm0
	jmp	.L473
.L476:
	movq	results(%rip), %r14
	movq	iterations(%rip), %r13
	call	usecs_spent
	movq	%rax, %r15
	movl	$0, 16(%rsp)
	movl	$0, 208(%rsp)
	movl	$11, %r12d
	jmp	.L516
.L482:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
	jmp	.L483
.L489:
	movq	%rbp, %rax
	shrq	%rax
	andl	$1, %ebp
	orq	%rbp, %rax
	pxor	%xmm2, %xmm2
	cvtsi2sdq	%rax, %xmm2
	addsd	%xmm2, %xmm2
	jmp	.L490
.L491:
	subsd	.LC42(%rip), %xmm1
	cvttsd2siq	%xmm1, %rax
	movq	%rax, __iterations.6(%rip)
	btcq	$63, __iterations.6(%rip)
	jmp	.L485
.L542:
	cmpq	$134217728, %rbp
	ja	.L529
	salq	$3, %rbp
	movq	%rbp, __iterations.6(%rip)
.L485:
	movsd	8(%rsp), %xmm5
	comisd	%xmm0, %xmm5
	jbe	.L478
.L493:
	movl	$0, %edi
	call	start
	movq	__iterations.6(%rip), %rbp
	testq	%rbp, %rbp
	je	.L480
	movq	%rbp, %rax
.L481:
	movq	(%rbx), %rbx
	subq	$1, %rax
	jne	.L481
.L480:
	movl	$0, %esi
	movl	$0, %edi
	call	stop
	testq	%rax, %rax
	js	.L482
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
.L483:
	movsd	.LC44(%rip), %xmm1
	movsd	(%rsp), %xmm3
	mulsd	%xmm3, %xmm1
	comisd	%xmm0, %xmm1
	ja	.L484
	mulsd	.LC45(%rip), %xmm3
	comisd	%xmm3, %xmm0
	jbe	.L485
.L484:
	comisd	.LC46(%rip), %xmm0
	jbe	.L542
	testq	%rbp, %rbp
	js	.L489
	pxor	%xmm2, %xmm2
	cvtsi2sdq	%rbp, %xmm2
.L490:
	divsd	%xmm0, %xmm2
	movsd	(%rsp), %xmm1
	mulsd	.LC47(%rip), %xmm1
	mulsd	%xmm2, %xmm1
	addsd	.LC5(%rip), %xmm1
	comisd	.LC42(%rip), %xmm1
	jnb	.L491
	cvttsd2siq	%xmm1, %rax
	movq	%rax, __iterations.6(%rip)
	jmp	.L485
.L529:
	pxor	%xmm0, %xmm0
.L478:
	movq	__iterations.6(%rip), %rax
	movq	%rax, iterations(%rip)
	comisd	.LC42(%rip), %xmm0
	jnb	.L494
	cvttsd2siq	%xmm0, %rdi
.L495:
	call	settime
	movq	%rbx, %rdi
	call	use_pointer
	call	usecs_spent
	movq	%rax, %rbx
	call	t_overhead
	cmpq	%rax, %rbx
	ja	.L548
.L496:
	movq	p(%rip), %rbx
	call	init_timing
	movl	long_enough(%rip), %eax
	testl	%eax, %eax
	movl	$0, %edx
	cmovs	%edx, %eax
	pxor	%xmm7, %xmm7
	cvtsi2sdl	%eax, %xmm7
	movsd	%xmm7, (%rsp)
	mulsd	.LC43(%rip), %xmm7
	movsd	%xmm7, 8(%rsp)
	comisd	.LC10(%rip), %xmm7
	ja	.L512
	pxor	%xmm0, %xmm0
	jmp	.L497
.L494:
	subsd	.LC42(%rip), %xmm0
	cvttsd2siq	%xmm0, %rdi
	btcq	$63, %rdi
	jmp	.L495
.L548:
	movq	iterations(%rip), %rbp
	call	usecs_spent
	movq	%rax, %rbx
	call	t_overhead
	leaq	16(%rsp), %rdx
	movq	%rbx, %rdi
	subq	%rax, %rdi
	movq	%rbp, %rsi
	call	insertsort
	jmp	.L496
.L501:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
	jmp	.L502
.L508:
	movq	%rbp, %rax
	shrq	%rax
	andl	$1, %ebp
	orq	%rbp, %rax
	pxor	%xmm2, %xmm2
	cvtsi2sdq	%rax, %xmm2
	addsd	%xmm2, %xmm2
	jmp	.L509
.L510:
	subsd	.LC42(%rip), %xmm1
	cvttsd2siq	%xmm1, %rax
	movq	%rax, __iterations.5(%rip)
	btcq	$63, __iterations.5(%rip)
	jmp	.L504
.L544:
	cmpq	$134217728, %rbp
	ja	.L531
	salq	$3, %rbp
	movq	%rbp, __iterations.5(%rip)
.L504:
	movsd	8(%rsp), %xmm6
	comisd	%xmm0, %xmm6
	jbe	.L497
.L512:
	movl	$0, %edi
	call	start
	movq	__iterations.5(%rip), %rbp
	testq	%rbp, %rbp
	je	.L499
	movq	%rbp, %rax
.L500:
	movq	(%rbx), %rdx
	movq	(%rdx), %rbx
	subq	$1, %rax
	jne	.L500
.L499:
	movl	$0, %esi
	movl	$0, %edi
	call	stop
	testq	%rax, %rax
	js	.L501
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
.L502:
	movsd	.LC44(%rip), %xmm1
	movsd	(%rsp), %xmm4
	mulsd	%xmm4, %xmm1
	comisd	%xmm0, %xmm1
	ja	.L503
	mulsd	.LC45(%rip), %xmm4
	comisd	%xmm4, %xmm0
	jbe	.L504
.L503:
	comisd	.LC46(%rip), %xmm0
	jbe	.L544
	testq	%rbp, %rbp
	js	.L508
	pxor	%xmm2, %xmm2
	cvtsi2sdq	%rbp, %xmm2
.L509:
	divsd	%xmm0, %xmm2
	movsd	(%rsp), %xmm1
	mulsd	.LC47(%rip), %xmm1
	mulsd	%xmm2, %xmm1
	addsd	.LC5(%rip), %xmm1
	comisd	.LC42(%rip), %xmm1
	jnb	.L510
	cvttsd2siq	%xmm1, %rax
	movq	%rax, __iterations.5(%rip)
	jmp	.L504
.L531:
	pxor	%xmm0, %xmm0
.L497:
	movq	__iterations.5(%rip), %rax
	movq	%rax, iterations(%rip)
	comisd	.LC42(%rip), %xmm0
	jnb	.L513
	cvttsd2siq	%xmm0, %rdi
.L514:
	call	settime
	movq	%rbx, %rdi
	call	use_pointer
	call	usecs_spent
	movq	%rax, %rbx
	call	t_overhead
	cmpq	%rax, %rbx
	ja	.L549
.L515:
	subl	$1, %r12d
	je	.L550
.L516:
	movq	p(%rip), %rbx
	call	init_timing
	movl	long_enough(%rip), %eax
	testl	%eax, %eax
	movl	$0, %edx
	cmovs	%edx, %eax
	pxor	%xmm7, %xmm7
	cvtsi2sdl	%eax, %xmm7
	movapd	%xmm7, %xmm5
	movsd	%xmm7, (%rsp)
	movsd	.LC43(%rip), %xmm7
	mulsd	%xmm5, %xmm7
	movsd	%xmm7, 8(%rsp)
	pxor	%xmm6, %xmm6
	comisd	%xmm6, %xmm7
	ja	.L493
	pxor	%xmm0, %xmm0
	jmp	.L478
.L513:
	subsd	.LC42(%rip), %xmm0
	cvttsd2siq	%xmm0, %rdi
	btcq	$63, %rdi
	jmp	.L514
.L549:
	movq	iterations(%rip), %rbp
	call	usecs_spent
	movq	%rax, %rbx
	call	t_overhead
	leaq	208(%rsp), %rdx
	movq	%rbx, %rdi
	subq	%rax, %rdi
	movq	%rbp, %rsi
	call	insertsort
	jmp	.L515
.L550:
	leaq	16(%rsp), %rax
	movq	%rax, results(%rip)
	movl	$0, %eax
	call	save_median
	movl	$0, %eax
	call	save_minimum
	call	usecs_spent
	testq	%rax, %rax
	js	.L517
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
.L518:
	addsd	%xmm0, %xmm0
	movq	iterations(%rip), %rax
	testq	%rax, %rax
	js	.L519
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rax, %xmm1
.L520:
	divsd	%xmm1, %xmm0
	movq	%xmm0, %rbx
	leaq	208(%rsp), %rax
	movq	%rax, results(%rip)
	movl	$0, %eax
	call	save_median
	movl	$0, %eax
	call	save_minimum
	call	usecs_spent
	testq	%rax, %rax
	js	.L521
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
.L522:
	movq	iterations(%rip), %rax
	testq	%rax, %rax
	js	.L523
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rax, %xmm1
.L524:
	divsd	%xmm1, %xmm0
	movq	%rbx, %xmm1
	subsd	%xmm0, %xmm1
	pxor	%xmm0, %xmm0
	comisd	%xmm1, %xmm0
	ja	.L525
	movsd	%xmm1, overhead.10(%rip)
.L526:
	movq	%r14, results(%rip)
	movl	$0, %eax
	call	save_median
	movq	%r13, iterations(%rip)
	movq	%r15, %rdi
	call	settime
	jmp	.L477
.L517:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
	jmp	.L518
.L519:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rdx, %xmm1
	addsd	%xmm1, %xmm1
	jmp	.L520
.L521:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
	jmp	.L522
.L523:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rdx, %xmm1
	addsd	%xmm1, %xmm1
	jmp	.L524
.L525:
	movq	$0x000000000, overhead.10(%rip)
	jmp	.L526
.L547:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE125:
	.size	l_overhead, .-l_overhead
	.globl	benchmp_interval
	.type	benchmp_interval, @function
benchmp_interval:
.LFB85:
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
	subq	$200, %rsp
	.cfi_def_cfa_offset 240
	movq	%rdi, %rbx
	movq	%fs:40, %rax
	movq	%rax, 184(%rsp)
	xorl	%eax, %eax
	cmpl	$1, (%rdi)
	je	.L603
	movq	80(%rdi), %rbp
.L553:
	cmpl	$0, 88(%rbx)
	je	.L554
	pxor	%xmm3, %xmm3
	cvtsi2sdl	52(%rbx), %xmm3
	movsd	%xmm3, 8(%rsp)
.L555:
	call	getppid@PLT
	cmpl	$1, %eax
	je	.L604
.L572:
	movq	$0, 32(%rsp)
	movq	$0, 40(%rsp)
	leaq	48(%rsp), %rax
	leaq	176(%rsp), %rdx
.L574:
	movq	$0, (%rax)
	addq	$8, %rax
	cmpq	%rdx, %rax
	jne	.L574
	movl	(%rbx), %eax
	cmpl	$1, %eax
	je	.L575
	cmpl	$2, %eax
	je	.L576
	testl	%eax, %eax
	je	.L605
.L577:
	movq	8(%rbx), %rax
	testq	%rax, %rax
	je	.L594
	movq	72(%rbx), %rsi
	movq	%rbp, %rdi
	call	*%rax
.L594:
	movl	$0, %edi
	call	start
	movq	184(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L606
	movq	%rbp, %rax
	addq	$200, %rsp
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
.L603:
	.cfi_restore_state
	movq	56(%rdi), %rbp
	jmp	.L553
.L554:
	movl	$0, %esi
	movl	$0, %edi
	call	stop
	testq	%rax, %rax
	js	.L556
	pxor	%xmm5, %xmm5
	cvtsi2sdq	%rax, %xmm5
	movq	%xmm5, %r13
.L557:
	cmpq	$0, 24(%rbx)
	je	.L558
	cmpq	$0, benchmp_sigchld_handler(%rip)
	je	.L607
.L559:
	movq	72(%rbx), %rsi
	movq	%rbp, %rdi
	call	*24(%rbx)
.L558:
	movq	56(%rbx), %rax
	movq	%rax, iterations(%rip)
	call	t_overhead
	movq	%rax, %r12
	movq	iterations(%rip), %rax
	testq	%rax, %rax
	js	.L560
	pxor	%xmm6, %xmm6
	cvtsi2sdq	%rax, %xmm6
	movsd	%xmm6, 8(%rsp)
.L561:
	call	l_overhead
	testq	%r12, %r12
	js	.L562
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%r12, %xmm1
.L563:
	mulsd	8(%rsp), %xmm0
	addsd	%xmm1, %xmm0
	movq	%r13, %xmm2
	subsd	%xmm0, %xmm2
	movsd	%xmm2, 8(%rsp)
	movl	$0, %edi
	comisd	.LC10(%rip), %xmm2
	jb	.L564
	comisd	.LC42(%rip), %xmm2
	jnb	.L566
	cvttsd2siq	%xmm2, %rax
.L567:
	testq	%rax, %rax
	js	.L568
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
.L569:
	comisd	.LC42(%rip), %xmm0
	jnb	.L570
	cvttsd2siq	%xmm0, %rdi
.L564:
	call	settime
	jmp	.L555
.L556:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
	movq	%xmm0, %r13
	jmp	.L557
.L607:
	movl	$0, %esi
	movl	$17, %edi
	call	signal@PLT
	jmp	.L559
.L560:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
	movsd	%xmm0, 8(%rsp)
	jmp	.L561
.L562:
	movq	%r12, %rax
	shrq	%rax
	andl	$1, %r12d
	orq	%r12, %rax
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rax, %xmm1
	addsd	%xmm1, %xmm1
	jmp	.L563
.L566:
	movsd	8(%rsp), %xmm0
	subsd	.LC42(%rip), %xmm0
	cvttsd2siq	%xmm0, %rax
	btcq	$63, %rax
	jmp	.L567
.L568:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
	jmp	.L569
.L570:
	subsd	.LC42(%rip), %xmm0
	cvttsd2siq	%xmm0, %rdi
	btcq	$63, %rdi
	jmp	.L564
.L604:
	cmpq	$0, 24(%rbx)
	je	.L572
	cmpq	$0, benchmp_sigchld_handler(%rip)
	je	.L608
.L573:
	movq	72(%rbx), %rsi
	movl	$0, %edi
	call	*24(%rbx)
	movl	$0, %edi
	call	exit@PLT
.L608:
	movl	$0, %esi
	movl	$17, %edi
	call	signal@PLT
	jmp	.L573
.L605:
	movq	80(%rbx), %rbp
	movslq	40(%rbx), %rdi
	call	__fdelt_chk@PLT
	movl	40(%rbx), %ecx
	movl	$1, %r12d
	movq	%r12, %rdx
	salq	%cl, %rdx
	orq	%rdx, 48(%rsp,%rax,8)
	leaq	48(%rsp), %rsi
	leal	1(%rcx), %edi
	leaq	32(%rsp), %r8
	movl	$0, %ecx
	movl	$0, %edx
	call	select@PLT
	movslq	40(%rbx), %rdi
	call	__fdelt_chk@PLT
	movl	40(%rbx), %ecx
	salq	%cl, %r12
	andq	48(%rsp,%rax,8), %r12
	jne	.L609
.L578:
	cmpl	$0, 88(%rbx)
	je	.L577
	movl	$0, 88(%rbx)
	leaq	31(%rsp), %rsi
	movl	36(%rbx), %edi
	movl	$1, %edx
	call	write@PLT
	jmp	.L577
.L609:
	movl	$1, (%rbx)
	leaq	31(%rsp), %rsi
	movl	$1, %edx
	movl	%ecx, %edi
	call	read@PLT
	movq	56(%rbx), %rbp
	jmp	.L578
.L575:
	movq	56(%rbx), %rbp
	cmpl	$1, 64(%rbx)
	jg	.L579
	pxor	%xmm0, %xmm0
	cvtsi2sdl	52(%rbx), %xmm0
	mulsd	.LC43(%rip), %xmm0
	movsd	8(%rsp), %xmm7
	comisd	%xmm0, %xmm7
	jbe	.L580
.L579:
	movq	results(%rip), %r13
	movq	iterations(%rip), %r12
	call	usecs_spent
	movq	%rax, %rdi
	movq	%r13, %rdx
	movq	%r12, %rsi
	call	insertsort
	movq	96(%rbx), %rax
	addq	$1, %rax
	movq	%rax, 96(%rbx)
	movslq	68(%rbx), %rdx
	cmpq	%rdx, %rax
	jl	.L580
	movl	$2, (%rbx)
.L580:
	cmpl	$1, 64(%rbx)
	je	.L610
.L582:
	movq	%rbp, 56(%rbx)
	cmpl	$2, (%rbx)
	jne	.L577
	leaq	31(%rsp), %rsi
	movl	36(%rbx), %edi
	movl	$1, %edx
	call	write@PLT
	movq	80(%rbx), %rbp
	jmp	.L577
.L610:
	pxor	%xmm0, %xmm0
	cvtsi2sdl	52(%rbx), %xmm0
	movapd	%xmm0, %xmm1
	mulsd	.LC44(%rip), %xmm1
	movsd	8(%rsp), %xmm7
	comisd	%xmm7, %xmm1
	ja	.L583
	movapd	%xmm0, %xmm1
	mulsd	.LC45(%rip), %xmm1
	comisd	%xmm1, %xmm7
	jbe	.L582
.L583:
	movsd	8(%rsp), %xmm5
	comisd	.LC46(%rip), %xmm5
	jbe	.L601
	testq	%rbp, %rbp
	js	.L587
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rbp, %xmm1
.L588:
	divsd	8(%rsp), %xmm1
	mulsd	.LC47(%rip), %xmm0
	mulsd	%xmm1, %xmm0
	addsd	.LC5(%rip), %xmm0
	comisd	.LC42(%rip), %xmm0
	jnb	.L589
	cvttsd2siq	%xmm0, %rbp
	jmp	.L582
.L587:
	movq	%rbp, %rax
	shrq	%rax
	andl	$1, %ebp
	orq	%rbp, %rax
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rax, %xmm1
	addsd	%xmm1, %xmm1
	jmp	.L588
.L589:
	subsd	.LC42(%rip), %xmm0
	cvttsd2siq	%xmm0, %rbp
	btcq	$63, %rbp
	jmp	.L582
.L601:
	salq	$3, %rbp
	cmpq	$134217728, %rbp
	ja	.L591
	pxor	%xmm0, %xmm0
	comisd	8(%rsp), %xmm0
	jbe	.L582
	cmpq	$1048576, %rbp
	jbe	.L582
.L591:
	movl	$2, (%rbx)
	jmp	.L582
.L576:
	movq	80(%rbx), %rbp
	movslq	44(%rbx), %rdi
	call	__fdelt_chk@PLT
	movl	44(%rbx), %ecx
	movl	$1, %r12d
	movq	%r12, %rdx
	salq	%cl, %rdx
	orq	%rdx, 48(%rsp,%rax,8)
	leaq	48(%rsp), %rsi
	leal	1(%rcx), %edi
	leaq	32(%rsp), %r8
	movl	$0, %ecx
	movl	$0, %edx
	call	select@PLT
	movslq	44(%rbx), %rdi
	call	__fdelt_chk@PLT
	movl	44(%rbx), %ecx
	salq	%cl, %r12
	andq	48(%rsp,%rax,8), %r12
	je	.L577
	leaq	31(%rsp), %rsi
	movl	$1, %edx
	movl	%ecx, %edi
	call	read@PLT
	movslq	104(%rbx), %rdx
	movl	36(%rbx), %edi
	movq	results(%rip), %rsi
	call	write@PLT
	cmpq	$0, 24(%rbx)
	je	.L592
	cmpq	$0, benchmp_sigchld_handler(%rip)
	je	.L611
.L593:
	movq	72(%rbx), %rsi
	movl	$0, %edi
	call	*24(%rbx)
.L592:
	leaq	31(%rsp), %rsi
	movl	48(%rbx), %edi
	movl	$1, %edx
	call	read@PLT
	movl	$0, %edi
	call	exit@PLT
.L611:
	movl	$0, %esi
	movl	$17, %edi
	call	signal@PLT
	jmp	.L593
.L606:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE85:
	.size	benchmp_interval, .-benchmp_interval
	.globl	benchmp_child
	.type	benchmp_child, @function
benchmp_child:
.LFB84:
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
	movq	%rdi, %r12
	movq	%rsi, %rbx
	movq	%rdx, %rsi
	movl	64(%rsp), %edx
	movl	72(%rsp), %edi
	movq	80(%rsp), %rbp
	cmpl	$1, %edx
	movl	$1, %eax
	cmovg	iterations(%rip), %rax
	movl	$0, _benchmp_child_state(%rip)
	movq	%r12, 8+_benchmp_child_state(%rip)
	movq	%rbx, 16+_benchmp_child_state(%rip)
	movq	%rsi, 24+_benchmp_child_state(%rip)
	movl	%ecx, 32+_benchmp_child_state(%rip)
	movl	%r8d, 36+_benchmp_child_state(%rip)
	movl	%r9d, 40+_benchmp_child_state(%rip)
	movl	32(%rsp), %ecx
	movl	%ecx, 44+_benchmp_child_state(%rip)
	movl	40(%rsp), %ecx
	movl	%ecx, 48+_benchmp_child_state(%rip)
	movl	48(%rsp), %ecx
	movl	%ecx, 52+_benchmp_child_state(%rip)
	movq	56(%rsp), %rcx
	movq	%rcx, 56+_benchmp_child_state(%rip)
	movq	%rax, 80+_benchmp_child_state(%rip)
	movl	%edx, 64+_benchmp_child_state(%rip)
	movl	%edi, 68+_benchmp_child_state(%rip)
	movq	%rbp, 72+_benchmp_child_state(%rip)
	movl	$1, 88+_benchmp_child_state(%rip)
	movq	$0, 96+_benchmp_child_state(%rip)
	call	sizeof_result
	movl	%eax, 104+_benchmp_child_state(%rip)
	movslq	%eax, %rdi
	call	malloc@PLT
	movq	%rax, 112+_benchmp_child_state(%rip)
	testq	%rax, %rax
	je	.L623
	movl	$0, (%rax)
	movq	%rax, results(%rip)
	movl	$0, %eax
	call	save_median
	movq	benchmp_sigchld_handler(%rip), %rsi
	testq	%rsi, %rsi
	je	.L615
	movl	$17, %edi
	call	signal@PLT
.L616:
	testq	%r12, %r12
	je	.L617
	movq	%rbp, %rsi
	movl	$0, %edi
	call	*%r12
.L617:
	movq	benchmp_sigterm_handler(%rip), %rsi
	testq	%rsi, %rsi
	je	.L618
	movl	$15, %edi
	call	signal@PLT
.L619:
	cmpl	$0, benchmp_sigterm_received(%rip)
	jne	.L625
	movq	112+_benchmp_child_state(%rip), %rax
	movl	$0, (%rax)
	leaq	_benchmp_child_state(%rip), %r12
.L621:
	movq	%r12, %rdi
	call	benchmp_interval
	movq	%rax, %rdi
	movq	%rbp, %rsi
	call	*%rbx
	jmp	.L621
.L615:
	leaq	benchmp_child_sigchld(%rip), %rsi
	movl	$17, %edi
	call	signal@PLT
	jmp	.L616
.L618:
	leaq	benchmp_child_sigterm(%rip), %rsi
	movl	$15, %edi
	call	signal@PLT
	jmp	.L619
.L625:
	movl	$15, %edi
	call	benchmp_child_sigterm
.L623:
	popq	%rbx
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE84:
	.size	benchmp_child, .-benchmp_child
	.globl	benchmp
	.type	benchmp, @function
benchmp:
.LFB78:
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
	movq	%rdi, 8(%rsp)
	movq	%rsi, 16(%rsp)
	movq	%rdx, 24(%rsp)
	movl	%ecx, %ebx
	movl	%r8d, %ebp
	movl	%r9d, 36(%rsp)
	movq	168(%rsp), %r14
	movq	%fs:40, %rax
	movq	%rax, 88(%rsp)
	xorl	%eax, %eax
	call	init_timing
	movl	long_enough(%rip), %eax
	cmpl	%eax, %ebx
	cmovl	%eax, %ebx
	cmpl	$0, 160(%rsp)
	js	.L659
.L627:
	movl	$0, %edi
	call	settime
	movq	$1, iterations(%rip)
	cmpl	$1, %ebp
	jle	.L652
	pushq	%r14
	.cfi_def_cfa_offset 168
	movl	168(%rsp), %eax
	pushq	%rax
	.cfi_def_cfa_offset 176
	movl	52(%rsp), %r9d
	movl	$1, %r8d
	movl	%ebx, %ecx
	movq	40(%rsp), %rdx
	movq	32(%rsp), %rsi
	movq	24(%rsp), %rdi
	call	benchmp
	call	usecs_spent
	addq	$16, %rsp
	.cfi_def_cfa_offset 160
	testq	%rax, %rax
	je	.L626
	movq	iterations(%rip), %r13
	cmpl	$999999, %ebx
	jle	.L660
.L632:
	movl	$0, %edi
	call	settime
	movq	$1, iterations(%rip)
.L630:
	leaq	56(%rsp), %rdi
	call	pipe@PLT
	testl	%eax, %eax
	js	.L626
	leaq	64(%rsp), %rdi
	call	pipe@PLT
	testl	%eax, %eax
	js	.L626
	leaq	72(%rsp), %rdi
	call	pipe@PLT
	testl	%eax, %eax
	js	.L626
	leaq	80(%rsp), %rdi
	call	pipe@PLT
	testl	%eax, %eax
	js	.L626
	movl	$0, benchmp_sigchld_received(%rip)
	movl	$0, benchmp_sigterm_received(%rip)
	leaq	benchmp_sigterm(%rip), %rsi
	movl	$15, %edi
	call	signal@PLT
	movq	%rax, benchmp_sigterm_handler(%rip)
	leaq	benchmp_sigchld(%rip), %rsi
	movl	$17, %edi
	call	signal@PLT
	movq	%rax, benchmp_sigchld_handler(%rip)
	movslq	%ebp, %rax
	leaq	0(,%rax,4), %r12
	movq	%r12, %rdi
	call	malloc@PLT
	movq	%rax, %r15
	testq	%rax, %rax
	je	.L626
	movq	%r12, %rdx
	movl	$0, %esi
	movq	%rax, %rdi
	call	memset@PLT
	movslq	%ebp, %rax
	movq	%rax, 40(%rsp)
	movl	$0, %r12d
	testq	%rax, %rax
	jle	.L640
.L639:
	call	fork@PLT
	movl	%eax, (%r15,%r12,4)
	cmpl	$-1, %eax
	je	.L641
	testl	%eax, %eax
	jne	.L642
	movl	56(%rsp), %edi
	call	close@PLT
	movl	68(%rsp), %edi
	call	close@PLT
	movl	76(%rsp), %edi
	call	close@PLT
	movl	84(%rsp), %edi
	call	close@PLT
	movl	$0, %edx
	movl	$0, %esi
	movl	%r12d, %edi
	call	handle_scheduler@PLT
	subq	$8, %rsp
	.cfi_def_cfa_offset 168
	pushq	%r14
	.cfi_def_cfa_offset 176
	movl	176(%rsp), %eax
	pushq	%rax
	.cfi_def_cfa_offset 184
	pushq	%rbp
	.cfi_def_cfa_offset 192
	pushq	%r13
	.cfi_def_cfa_offset 200
	pushq	%rbx
	.cfi_def_cfa_offset 208
	movl	128(%rsp), %eax
	pushq	%rax
	.cfi_def_cfa_offset 216
	movl	128(%rsp), %eax
	pushq	%rax
	.cfi_def_cfa_offset 224
	movl	128(%rsp), %r9d
	movl	124(%rsp), %r8d
	movl	%r12d, %ecx
	movq	88(%rsp), %rdx
	movq	80(%rsp), %rsi
	movq	72(%rsp), %rdi
	call	benchmp_child
	addq	$64, %rsp
	.cfi_def_cfa_offset 160
	movl	$0, %edi
	call	exit@PLT
.L659:
	cmpl	$1, %ebp
	jg	.L654
	cmpl	$999999, %ebx
	jg	.L654
	movl	$0, %edi
	call	settime
	movq	$1, iterations(%rip)
	movl	$11, 160(%rsp)
	movl	$1, %r13d
	jmp	.L630
.L654:
	movl	$1, 160(%rsp)
	jmp	.L627
.L660:
	testq	%r13, %r13
	js	.L633
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%r13, %xmm0
.L634:
	mulsd	.LC1(%rip), %xmm0
	movq	%xmm0, %r12
	call	usecs_spent
	testq	%rax, %rax
	js	.L635
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rax, %xmm1
.L636:
	movq	%r12, %xmm0
	divsd	%xmm1, %xmm0
	comisd	.LC42(%rip), %xmm0
	jnb	.L637
	cvttsd2siq	%xmm0, %r13
.L638:
	addq	$1, %r13
	jmp	.L632
.L633:
	movq	%r13, %rax
	shrq	%rax
	andl	$1, %r13d
	orq	%r13, %rax
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	addsd	%xmm0, %xmm0
	jmp	.L634
.L635:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rdx, %xmm1
	addsd	%xmm1, %xmm1
	jmp	.L636
.L637:
	subsd	.LC42(%rip), %xmm0
	cvttsd2siq	%xmm0, %r13
	btcq	$63, %r13
	jmp	.L638
.L652:
	movl	$1, %r13d
	jmp	.L630
.L642:
	addq	$1, %r12
	cmpq	%r12, 40(%rsp)
	je	.L640
	cmpl	$0, benchmp_sigterm_received(%rip)
	je	.L639
.L641:
	movl	$0, %esi
	movl	$17, %edi
	call	signal@PLT
	subq	$1, %r12
	js	.L644
.L645:
	movl	(%r15,%r12,4), %ebp
	movl	$15, %esi
	movl	%ebp, %edi
	call	kill@PLT
	movl	$0, %edx
	movl	$0, %esi
	movl	%ebp, %edi
	call	waitpid@PLT
	subq	$1, %r12
	cmpq	$-1, %r12
	jne	.L645
.L644:
	movslq	%ebx, %rax
	imulq	$1125899907, %rax, %rax
	sarq	$49, %rax
	sarl	$31, %ebx
	subl	%ebx, %eax
	addl	$2, %eax
	movl	$5, %edx
	cmpl	%edx, %eax
	cmovl	%edx, %eax
	movl	%eax, benchmp_sigalrm_timeout(%rip)
	movl	$0, %esi
	movl	$17, %edi
	call	signal@PLT
	leaq	-1(%r12), %rbx
	testq	%r12, %r12
	jle	.L648
	leaq	benchmp_sigalrm(%rip), %r12
.L649:
	movl	(%r15,%rbx,4), %ebp
	movl	%ebp, benchmp_sigalrm_pid(%rip)
	movq	%r12, %rsi
	movl	$14, %edi
	call	signal@PLT
	movq	%rax, benchmp_sigalrm_handler(%rip)
	movl	benchmp_sigalrm_timeout(%rip), %edi
	call	alarm@PLT
	movl	$0, %edx
	movl	$0, %esi
	movl	%ebp, %edi
	call	waitpid@PLT
	movl	$0, %edi
	call	alarm@PLT
	movq	benchmp_sigalrm_handler(%rip), %rsi
	movl	$14, %edi
	call	signal@PLT
	subq	$1, %rbx
	cmpq	$-1, %rbx
	jne	.L649
.L648:
	movq	%r15, %rdi
	call	free@PLT
.L626:
	movq	88(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L661
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
.L640:
	.cfi_restore_state
	movl	60(%rsp), %edi
	call	close@PLT
	movl	64(%rsp), %edi
	call	close@PLT
	movl	72(%rsp), %edi
	call	close@PLT
	movl	80(%rsp), %edi
	call	close@PLT
	pushq	%rbx
	.cfi_def_cfa_offset 168
	movl	168(%rsp), %eax
	pushq	%rax
	.cfi_def_cfa_offset 176
	movl	52(%rsp), %eax
	pushq	%rax
	.cfi_def_cfa_offset 184
	pushq	%r13
	.cfi_def_cfa_offset 192
	movl	%ebp, %r9d
	movq	%r15, %r8
	movl	116(%rsp), %ecx
	movl	108(%rsp), %edx
	movl	100(%rsp), %esi
	movl	88(%rsp), %edi
	call	benchmp_parent
	addq	$32, %rsp
	.cfi_def_cfa_offset 160
	jmp	.L644
.L661:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE78:
	.size	benchmp, .-benchmp
	.globl	get_enough
	.type	get_enough, @function
get_enough:
.LFB127:
	.cfi_startproc
	endbr64
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movl	%edi, %ebx
	call	init_timing
	movl	long_enough(%rip), %eax
	cmpl	%eax, %ebx
	cmovge	%ebx, %eax
	popq	%rbx
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE127:
	.size	get_enough, .-get_enough
	.globl	morefds
	.type	morefds, @function
morefds:
.LFB135:
	.cfi_startproc
	endbr64
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	subq	$32, %rsp
	.cfi_def_cfa_offset 48
	movq	%fs:40, %rax
	movq	%rax, 24(%rsp)
	xorl	%eax, %eax
	movq	%rsp, %rbx
	movq	%rbx, %rsi
	movl	$7, %edi
	call	getrlimit@PLT
	movq	8(%rsp), %rax
	movq	%rax, (%rsp)
	movq	%rbx, %rsi
	movl	$7, %edi
	call	setrlimit@PLT
	movq	24(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L667
	addq	$32, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 16
	popq	%rbx
	.cfi_def_cfa_offset 8
	ret
.L667:
	.cfi_restore_state
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE135:
	.size	morefds, .-morefds
	.globl	bread
	.type	bread, @function
bread:
.LFB136:
	.cfi_startproc
	endbr64
	movq	%rdi, %rdx
	movq	%rsi, %rdi
	leaq	(%rdx,%rsi), %rsi
	leaq	1024(%rdx), %r8
	cmpq	%r8, %rsi
	jb	.L675
	movq	%r8, %rdx
	movl	$0, %ecx
.L670:
	movq	-1016(%rdx), %rax
	addq	-1024(%rdx), %rax
	addq	-1008(%rdx), %rax
	addq	-1000(%rdx), %rax
	addq	-992(%rdx), %rax
	addq	-984(%rdx), %rax
	addq	-976(%rdx), %rax
	addq	-968(%rdx), %rax
	addq	-960(%rdx), %rax
	addq	-952(%rdx), %rax
	addq	-944(%rdx), %rax
	addq	-936(%rdx), %rax
	addq	-928(%rdx), %rax
	addq	-920(%rdx), %rax
	addq	-912(%rdx), %rax
	addq	-904(%rdx), %rax
	addq	-896(%rdx), %rax
	addq	-888(%rdx), %rax
	addq	-880(%rdx), %rax
	addq	-872(%rdx), %rax
	addq	-864(%rdx), %rax
	addq	-856(%rdx), %rax
	addq	-848(%rdx), %rax
	addq	-840(%rdx), %rax
	addq	-832(%rdx), %rax
	addq	-824(%rdx), %rax
	addq	-816(%rdx), %rax
	addq	-808(%rdx), %rax
	addq	-800(%rdx), %rax
	addq	-792(%rdx), %rax
	addq	-784(%rdx), %rax
	addq	-776(%rdx), %rax
	addq	-768(%rdx), %rax
	addq	-760(%rdx), %rax
	addq	-752(%rdx), %rax
	addq	-744(%rdx), %rax
	addq	-736(%rdx), %rax
	addq	-728(%rdx), %rax
	addq	-720(%rdx), %rax
	addq	-712(%rdx), %rax
	addq	-704(%rdx), %rax
	addq	-696(%rdx), %rax
	addq	-688(%rdx), %rax
	addq	-680(%rdx), %rax
	addq	-672(%rdx), %rax
	addq	-664(%rdx), %rax
	addq	-656(%rdx), %rax
	addq	-648(%rdx), %rax
	addq	-640(%rdx), %rax
	addq	-632(%rdx), %rax
	addq	-624(%rdx), %rax
	addq	-616(%rdx), %rax
	addq	-608(%rdx), %rax
	addq	-600(%rdx), %rax
	addq	-592(%rdx), %rax
	addq	-584(%rdx), %rax
	addq	-576(%rdx), %rax
	addq	-568(%rdx), %rax
	addq	-560(%rdx), %rax
	addq	-552(%rdx), %rax
	addq	-544(%rdx), %rax
	addq	-536(%rdx), %rax
	addq	-528(%rdx), %rax
	addq	-520(%rdx), %rax
	addq	-512(%rdx), %rax
	addq	-504(%rdx), %rax
	addq	-496(%rdx), %rax
	addq	-488(%rdx), %rax
	addq	-480(%rdx), %rax
	addq	-472(%rdx), %rax
	addq	-464(%rdx), %rax
	addq	-456(%rdx), %rax
	addq	-448(%rdx), %rax
	addq	-440(%rdx), %rax
	addq	-432(%rdx), %rax
	addq	-424(%rdx), %rax
	addq	-416(%rdx), %rax
	addq	-408(%rdx), %rax
	addq	-400(%rdx), %rax
	addq	-392(%rdx), %rax
	addq	-384(%rdx), %rax
	addq	-376(%rdx), %rax
	addq	-368(%rdx), %rax
	addq	-360(%rdx), %rax
	addq	-352(%rdx), %rax
	addq	-344(%rdx), %rax
	addq	-336(%rdx), %rax
	addq	-328(%rdx), %rax
	addq	-320(%rdx), %rax
	addq	-312(%rdx), %rax
	addq	-304(%rdx), %rax
	addq	-296(%rdx), %rax
	addq	-288(%rdx), %rax
	addq	-280(%rdx), %rax
	addq	-272(%rdx), %rax
	addq	-264(%rdx), %rax
	addq	-256(%rdx), %rax
	addq	-248(%rdx), %rax
	addq	-240(%rdx), %rax
	addq	-232(%rdx), %rax
	addq	-224(%rdx), %rax
	addq	-216(%rdx), %rax
	addq	-208(%rdx), %rax
	addq	-200(%rdx), %rax
	addq	-192(%rdx), %rax
	addq	-184(%rdx), %rax
	addq	-176(%rdx), %rax
	addq	-168(%rdx), %rax
	addq	-160(%rdx), %rax
	addq	-152(%rdx), %rax
	addq	-144(%rdx), %rax
	addq	-136(%rdx), %rax
	addq	-128(%rdx), %rax
	addq	-120(%rdx), %rax
	addq	-112(%rdx), %rax
	addq	-104(%rdx), %rax
	addq	-96(%rdx), %rax
	addq	-88(%rdx), %rax
	addq	-80(%rdx), %rax
	addq	-72(%rdx), %rax
	addq	-64(%rdx), %rax
	addq	-56(%rdx), %rax
	addq	-48(%rdx), %rax
	addq	-40(%rdx), %rax
	addq	-32(%rdx), %rax
	addq	-24(%rdx), %rax
	addq	-16(%rdx), %rax
	addq	-8(%rdx), %rax
	addq	%rax, %rcx
	addq	$1024, %rdx
	cmpq	%rdx, %rsi
	jnb	.L670
	subq	$1024, %rdi
	andq	$-1024, %rdi
	leaq	(%r8,%rdi), %rdx
.L669:
	leaq	128(%rdx), %r8
	cmpq	%r8, %rsi
	jb	.L671
	movq	%r8, %rdi
.L672:
	movq	-120(%rdi), %rax
	addq	-128(%rdi), %rax
	addq	-112(%rdi), %rax
	addq	-104(%rdi), %rax
	addq	-96(%rdi), %rax
	addq	-88(%rdi), %rax
	addq	-80(%rdi), %rax
	addq	-72(%rdi), %rax
	addq	-64(%rdi), %rax
	addq	-56(%rdi), %rax
	addq	-48(%rdi), %rax
	addq	-40(%rdi), %rax
	addq	-32(%rdi), %rax
	addq	-24(%rdi), %rax
	addq	-16(%rdi), %rax
	addq	-8(%rdi), %rax
	addq	%rax, %rcx
	subq	$-128, %rdi
	cmpq	%rdi, %rsi
	jnb	.L672
	leaq	-128(%rsi), %rax
	subq	%rdx, %rax
	andq	$-128, %rax
	leaq	(%r8,%rax), %rdx
.L671:
	addq	$8, %rdx
	cmpq	%rdx, %rsi
	jb	.L668
.L674:
	addq	-8(%rdx), %rcx
	addq	$8, %rdx
	cmpq	%rdx, %rsi
	jnb	.L674
.L668:
	movq	%rcx, %rax
	ret
.L675:
	movl	$0, %ecx
	jmp	.L669
	.cfi_endproc
.LFE136:
	.size	bread, .-bread
	.globl	touch
	.type	touch, @function
touch:
.LFB137:
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
	movq	%rdi, %rbp
	movq	%rsi, %rbx
	cmpq	$0, psize.1(%rip)
	jne	.L680
	call	getpagesize@PLT
	cltq
	movq	%rax, psize.1(%rip)
.L680:
	movq	psize.1(%rip), %rax
	cmpq	%rax, %rbx
	jb	.L679
.L682:
	movb	$1, 0(%rbp)
	addq	%rax, %rbp
	subq	%rax, %rbx
	cmpq	%rax, %rbx
	jnb	.L682
.L679:
	addq	$8, %rsp
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE137:
	.size	touch, .-touch
	.globl	permutation
	.type	permutation, @function
permutation:
.LFB138:
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
	subq	$8, %rsp
	.cfi_def_cfa_offset 48
	movq	%rdi, %r12
	movq	%rsi, %rbx
	leaq	0(,%rdi,8), %r13
	movq	%r13, %rdi
	call	malloc@PLT
	movq	%rax, %rbp
	testq	%rax, %rax
	je	.L685
	testq	%r12, %r12
	je	.L687
	leaq	0(%r13,%rax), %rcx
	movl	$0, %edx
.L688:
	movq	%rdx, (%rax)
	addq	%rbx, %rdx
	addq	$8, %rax
	cmpq	%rax, %rcx
	jne	.L688
	cmpq	$0, r.0(%rip)
	je	.L698
.L692:
	movl	$0, %ebx
.L690:
	movq	r.0(%rip), %rax
	leaq	(%rax,%rax), %r13
	call	rand@PLT
	cltq
	xorq	%r13, %rax
	movq	%rax, r.0(%rip)
	movl	$0, %edx
	divq	%r12
	leaq	0(%rbp,%rdx,8), %rax
	movq	(%rax), %rdx
	movq	0(%rbp,%rbx,8), %rcx
	movq	%rcx, (%rax)
	movq	%rdx, 0(%rbp,%rbx,8)
	addq	$1, %rbx
	cmpq	%rbx, %r12
	ja	.L690
.L685:
	movq	%rbp, %rax
	addq	$8, %rsp
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
.L687:
	.cfi_restore_state
	cmpq	$0, r.0(%rip)
	jne	.L685
	call	getpid@PLT
	movl	%eax, %ebx
	call	getppid@PLT
	movl	%eax, %r12d
	call	rand@PLT
	sall	$6, %ebx
	xorl	%eax, %r12d
	xorl	%r12d, %ebx
	call	rand@PLT
	sall	$10, %eax
	xorl	%ebx, %eax
	cltq
	movq	%rax, r.0(%rip)
	jmp	.L685
.L698:
	call	getpid@PLT
	movl	%eax, %ebx
	call	getppid@PLT
	movl	%eax, %r13d
	call	rand@PLT
	sall	$6, %ebx
	xorl	%r13d, %eax
	xorl	%eax, %ebx
	call	rand@PLT
	sall	$10, %eax
	xorl	%ebx, %eax
	cltq
	movq	%rax, r.0(%rip)
	jmp	.L692
	.cfi_endproc
.LFE138:
	.size	permutation, .-permutation
	.globl	cp
	.type	cp, @function
cp:
.LFB139:
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
	subq	$4096, %rsp
	.cfi_def_cfa_offset 4136
	orq	$0, (%rsp)
	subq	$4096, %rsp
	.cfi_def_cfa_offset 8232
	orq	$0, (%rsp)
	subq	$24, %rsp
	.cfi_def_cfa_offset 8256
	movq	%rsi, %rbp
	movl	%edx, %ebx
	movq	%fs:40, %rax
	movq	%rax, 8200(%rsp)
	xorl	%eax, %eax
	movl	$0, %esi
	call	open@PLT
	testl	%eax, %eax
	js	.L704
	movl	%eax, %r12d
	movl	%ebx, %edx
	movl	$578, %esi
	movq	%rbp, %rdi
	movl	$0, %eax
	call	open@PLT
	movl	%eax, %r13d
	testl	%eax, %eax
	js	.L705
	movq	%rsp, %rbp
.L701:
	movl	$8192, %edx
	movq	%rbp, %rsi
	movl	%r12d, %edi
	call	read@PLT
	movq	%rax, %rbx
	testq	%rax, %rax
	jle	.L708
	movq	%rbx, %rdx
	movq	%rbp, %rsi
	movl	%r13d, %edi
	call	write@PLT
	cmpq	%rbx, %rax
	jge	.L701
	movl	$-1, %eax
	jmp	.L699
.L708:
	movl	%r13d, %edi
	call	fsync@PLT
	movl	%r12d, %edi
	call	close@PLT
	movl	%r13d, %edi
	call	close@PLT
	movl	$0, %eax
.L699:
	movq	8200(%rsp), %rdx
	subq	%fs:40, %rdx
	jne	.L709
	addq	$8216, %rsp
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
.L704:
	.cfi_restore_state
	movl	$-1, %eax
	jmp	.L699
.L705:
	movl	$-1, %eax
	jmp	.L699
.L709:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE139:
	.size	cp, .-cp
	.globl	seekto
	.type	seekto, @function
seekto:
.LFB140:
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
	movl	%edi, 8(%rsp)
	movq	%rsi, (%rsp)
	movl	%edx, 12(%rsp)
	testq	%rsi, %rsi
	js	.L711
	cmpl	$1, %edx
	je	.L712
	cmpl	$2, %edx
	je	.L723
	movl	$1073741824, %r14d
	testl	%edx, %edx
	je	.L722
.L714:
	movslq	%r14d, %r12
	movq	(%rsp), %rbp
	movl	$0, %r13d
	movl	%r14d, %r15d
	shrl	$31, %r15d
	jmp	.L715
.L727:
	movl	$-1073741824, %r14d
.L722:
	movl	$0, %edx
	movl	$0, %esi
	movl	8(%rsp), %edi
	call	lseek@PLT
	jmp	.L714
.L723:
	movl	$1073741824, %r14d
.L713:
	movl	$2, %edx
	movl	$0, %esi
	movl	8(%rsp), %edi
	call	lseek@PLT
	movq	%rax, %rbx
	cmpq	$-1, %rax
	jne	.L714
	jmp	.L710
.L712:
	movl	$1073741824, %r14d
	cmpq	$0, (%rsp)
	jne	.L714
	movl	$1, %edx
	movl	$0, %esi
	movl	8(%rsp), %edi
	call	lseek@PLT
	movq	%rax, %rbx
	jmp	.L710
.L733:
	call	__errno_location@PLT
	cmpl	$0, (%rax)
	je	.L717
	jmp	.L710
.L729:
	cmpq	%rax, %r12
	jge	.L730
	testl	%r14d, %r14d
	jle	.L730
.L718:
	movl	$1, %edx
	movq	%r12, %rsi
	movl	8(%rsp), %edi
	call	lseek@PLT
	movq	%rax, %rbx
	cmpq	$-1, %rax
	je	.L733
.L717:
	addq	%r12, %r13
	movslq	%r14d, %rax
	subq	%rax, %rbp
.L715:
	movq	%rbp, %rax
	testb	%r15b, %r15b
	je	.L729
	cmpq	%rbp, %r12
	jle	.L729
	jmp	.L718
.L730:
	movq	(%rsp), %rbx
	movl	%ebx, %esi
	subl	%r13d, %esi
	movslq	%esi, %rsi
	movl	$1, %edx
	movl	8(%rsp), %edi
	call	lseek@PLT
	cmpl	$-1, %eax
	je	.L731
	cmpl	$0, 12(%rsp)
	je	.L710
.L731:
	movslq	%eax, %rbx
.L710:
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
.L711:
	.cfi_restore_state
	movl	12(%rsp), %eax
	testl	%eax, %eax
	je	.L727
	movl	$-1073741824, %r14d
	cmpl	$2, %eax
	jne	.L714
	movl	$-1073741824, %r14d
	jmp	.L713
	.cfi_endproc
.LFE140:
	.size	seekto, .-seekto
	.local	r.0
	.comm	r.0,8,8
	.local	psize.1
	.comm	psize.1,8,8
	.data
	.align 8
	.type	__iterations.2, @object
	.size	__iterations.2, 8
__iterations.2:
	.quad	1
	.local	overhead.3
	.comm	overhead.3,8,8
	.local	initialized.4
	.comm	initialized.4,4,4
	.align 8
	.type	__iterations.5, @object
	.size	__iterations.5, 8
__iterations.5:
	.quad	1
	.align 8
	.type	__iterations.6, @object
	.size	__iterations.6, 8
__iterations.6:
	.quad	1
	.align 8
	.type	N.7, @object
	.size	N.7, 8
N.7:
	.quad	10000
	.local	usecs.8
	.comm	usecs.8,8,8
	.local	done.9
	.comm	done.9,4,4
	.local	overhead.10
	.comm	overhead.10,8,8
	.local	initialized.11
	.comm	initialized.11,4,4
	.section	.rodata
	.type	__PRETTY_FUNCTION__.12, @object
	.size	__PRETTY_FUNCTION__.12, 6
__PRETTY_FUNCTION__.12:
	.string	"tvsub"
	.local	last.13
	.comm	last.13,16,16
	.align 16
	.type	possibilities, @object
	.size	possibilities, 16
possibilities:
	.long	5000
	.long	10000
	.long	50000
	.long	100000
	.align 16
	.type	test_points, @object
	.size	test_points, 24
test_points:
	.long	-1546188227
	.long	1072708976
	.long	-2061584302
	.long	1072714219
	.long	687194767
	.long	1072729948
	.local	long_enough
	.comm	long_enough,4,4
	.section	.data.rel.local,"aw"
	.align 8
	.type	p, @object
	.size	p, 8
p:
	.quad	p
	.align 8
	.type	results, @object
	.size	results, 8
results:
	.quad	_results
	.local	_results
	.comm	_results,184,32
	.local	n
	.comm	n,4,4
	.local	p64buf
	.comm	p64buf,200,32
	.local	_benchmp_child_state
	.comm	_benchmp_child_state,120,32
	.globl	benchmp_sigalrm_handler
	.bss
	.align 8
	.type	benchmp_sigalrm_handler, @object
	.size	benchmp_sigalrm_handler, 8
benchmp_sigalrm_handler:
	.zero	8
	.globl	benchmp_sigchld_handler
	.align 8
	.type	benchmp_sigchld_handler, @object
	.size	benchmp_sigchld_handler, 8
benchmp_sigchld_handler:
	.zero	8
	.globl	benchmp_sigterm_handler
	.align 8
	.type	benchmp_sigterm_handler, @object
	.size	benchmp_sigterm_handler, 8
benchmp_sigterm_handler:
	.zero	8
	.local	benchmp_sigalrm_timeout
	.comm	benchmp_sigalrm_timeout,4,4
	.local	benchmp_sigalrm_pid
	.comm	benchmp_sigalrm_pid,4,4
	.local	benchmp_sigchld_received
	.comm	benchmp_sigchld_received,4,4
	.local	benchmp_sigterm_received
	.comm	benchmp_sigterm_received,4,4
	.local	ru_stop
	.comm	ru_stop,144,32
	.local	ru_start
	.comm	ru_start,144,32
	.local	iterations
	.comm	iterations,8,8
	.local	use_result_dummy
	.comm	use_result_dummy,8,8
	.globl	ftiming
	.align 8
	.type	ftiming, @object
	.size	ftiming, 8
ftiming:
	.zero	8
	.local	stop_tv
	.comm	stop_tv,16,16
	.local	start_tv
	.comm	start_tv,16,16
	.section	.rodata.cst8,"aM",@progbits,8
	.align 8
.LC1:
	.long	0
	.long	1093567616
	.align 8
.LC5:
	.long	0
	.long	1072693248
	.align 8
.LC10:
	.long	0
	.long	0
	.align 8
.LC11:
	.long	0
	.long	1083129856
	.align 8
.LC17:
	.long	0
	.long	1079574528
	.align 8
.LC25:
	.long	0
	.long	1076101120
	.align 8
.LC35:
	.long	0
	.long	1082130432
	.align 8
.LC36:
	.long	0
	.long	1062207488
	.align 8
.LC42:
	.long	0
	.long	1138753536
	.align 8
.LC43:
	.long	1717986918
	.long	1072588390
	.align 8
.LC44:
	.long	2061584302
	.long	1072672276
	.align 8
.LC45:
	.long	858993459
	.long	1072902963
	.align 8
.LC46:
	.long	0
	.long	1080213504
	.align 8
.LC47:
	.long	-1717986918
	.long	1072798105
	.align 8
.LC49:
	.long	-171798692
	.long	1072651304
	.align 8
.LC50:
	.long	-2061584302
	.long	1072714219
	.align 8
.LC51:
	.long	1202590843
	.long	1063549665
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
