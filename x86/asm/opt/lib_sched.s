	.file	"lib_sched.c"
	.text
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"%d"
	.text
	.globl	custom
	.type	custom, @function
custom:
.LFB74:
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
	movl	%esi, 12(%rsp)
	cmpq	$0, values.5(%rip)
	je	.L15
.L2:
	movl	nvalues.4(%rip), %ecx
	testl	%ecx, %ecx
	je	.L1
	movl	12(%rsp), %eax
	cltd
	idivl	%ecx
	movslq	%edx, %rdx
	movq	values.5(%rip), %rax
	movl	(%rax,%rdx,4), %ecx
.L1:
	movl	%ecx, %eax
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
.L15:
	.cfi_restore_state
	movq	%rdi, %rbx
	movl	$0, nvalues.4(%rip)
	movl	$4, %edi
	call	malloc@PLT
	movq	%rax, values.5(%rip)
	movzbl	(%rbx), %ebp
	movl	$0, %ecx
	testb	%bpl, %bpl
	je	.L1
	call	__ctype_b_loc@PLT
	movq	%rax, %r14
	jmp	.L11
.L16:
	movzbl	(%rbx), %eax
	testb	%al, %al
	je	.L2
	movq	%rbx, %rbp
.L6:
	movsbq	%al, %rax
	testb	$8, 1(%rdx,%rax,2)
	je	.L9
	addq	$1, %rbp
	movzbl	0(%rbp), %eax
	testb	%al, %al
	jne	.L6
.L9:
	cmpq	%rbp, %rbx
	je	.L2
	leaq	1(%rbp), %r12
	movb	$0, 0(%rbp)
	movq	values.5(%rip), %r15
	movl	nvalues.4(%rip), %r13d
	leal	1(%r13), %eax
	movl	%eax, nvalues.4(%rip)
	movslq	%r13d, %r13
	salq	$2, %r13
	leaq	(%r15,%r13), %rdx
	leaq	.LC0(%rip), %rsi
	movq	%rbx, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf@PLT
	leaq	8(%r13), %rsi
	movq	%r15, %rdi
	call	realloc@PLT
	movq	%rax, values.5(%rip)
	movzbl	1(%rbp), %ebp
	testb	%bpl, %bpl
	je	.L2
.L5:
	movq	%r12, %rbx
.L11:
	movq	(%r14), %rdx
	movsbq	%bpl, %rbp
	testb	$8, 1(%rdx,%rbp,2)
	jne	.L16
	leaq	1(%rbx), %r12
	movzbl	1(%rbx), %ebp
	testb	%bpl, %bpl
	jne	.L5
	jmp	.L2
	.cfi_endproc
.LFE74:
	.size	custom, .-custom
	.globl	sched_ncpus
	.type	sched_ncpus, @function
sched_ncpus:
.LFB75:
	.cfi_startproc
	endbr64
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	movl	$84, %edi
	call	sysconf@PLT
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE75:
	.size	sched_ncpus, .-sched_ncpus
	.globl	reverse_bits
	.type	reverse_bits, @function
reverse_bits:
.LFB73:
	.cfi_startproc
	endbr64
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movl	%edi, %ebx
	movl	$0, %eax
	call	sched_ncpus
	subl	$1, %eax
	sarl	%eax
	testl	%eax, %eax
	jle	.L25
	movl	$1, %edx
.L21:
	sarl	%eax
	addl	$1, %edx
	testl	%eax, %eax
	jg	.L21
	testl	%edx, %edx
	jle	.L30
.L20:
	movl	$0, %esi
	movl	$0, %eax
	leal	-1(%rdx), %r8d
	movl	$1, %edi
	jmp	.L24
.L25:
	movl	$1, %edx
	jmp	.L20
.L23:
	addl	$1, %eax
	cmpl	%eax, %edx
	jle	.L19
.L24:
	btl	%eax, %ebx
	jnc	.L23
	movl	%r8d, %ecx
	subl	%eax, %ecx
	movl	%edi, %r9d
	sall	%cl, %r9d
	orl	%r9d, %esi
	jmp	.L23
.L30:
	movl	$0, %esi
.L19:
	movl	%esi, %eax
	popq	%rbx
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE73:
	.size	reverse_bits, .-reverse_bits
	.section	.rodata.str1.1
.LC1:
	.string	"sched_getaffinity:"
.LC2:
	.string	"sched_setaffinity:"
	.text
	.globl	sched_pin
	.type	sched_pin, @function
sched_pin:
.LFB76:
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
	movl	%edi, %ebx
	cmpq	$0, cpumask.3(%rip)
	je	.L45
.L32:
	movl	%ebx, %eax
	cltd
	idivl	ncpus.0(%rip)
	movl	%edx, %ebx
	movslq	sz.2(%rip), %r13
	leaq	0(,%r13,8), %r12
	movq	mask.1(%rip), %rbp
	movq	%r12, %rdx
	movl	$0, %esi
	movq	%rbp, %rdi
	call	memset@PLT
	movq	%r13, %rdi
	salq	$6, %rdi
	je	.L37
	movq	cpumask.3(%rip), %r9
	movl	$0, %ecx
	movl	$0, %esi
	movl	$1, %r8d
	jmp	.L40
.L45:
	movl	$0, %eax
	call	sched_ncpus
	leal	(%rax,%rax), %ebp
	movslq	%ebp, %rbp
	shrq	$6, %rbp
	addl	$1, %ebp
	movl	%ebp, sz.2(%rip)
	movslq	%ebp, %rbp
	salq	$3, %rbp
	movq	%rbp, %rdi
	call	malloc@PLT
	movq	%rax, mask.1(%rip)
	movq	%rbp, %rdi
	call	malloc@PLT
	movq	%rax, %rdx
	movq	%rax, cpumask.3(%rip)
	movq	%rbp, %rsi
	movl	$0, %edi
	movl	$0, %eax
	call	sched_getaffinity@PLT
	movl	%eax, %ebp
	testl	%eax, %eax
	js	.L46
	movl	sz.2(%rip), %eax
	sall	$3, %eax
	cltq
	salq	$3, %rax
	je	.L32
	movq	cpumask.3(%rip), %r9
	movl	ncpus.0(%rip), %edi
	movl	$0, %ecx
	movl	$0, %r10d
	movl	$1, %r8d
	movl	$1, %r11d
	jmp	.L36
.L46:
	leaq	.LC1(%rip), %rdi
	call	perror@PLT
	jmp	.L31
.L35:
	addq	$1, %rcx
	cmpq	%rax, %rcx
	je	.L47
.L36:
	movq	%rcx, %rsi
	shrq	$6, %rsi
	movslq	%esi, %rsi
	movl	%r8d, %edx
	sall	%cl, %edx
	movslq	%edx, %rdx
	andq	(%r9,%rsi,8), %rdx
	je	.L35
	addl	$1, %edi
	movl	%r11d, %r10d
	jmp	.L35
.L47:
	testb	%r10b, %r10b
	je	.L32
	movl	%edi, ncpus.0(%rip)
	jmp	.L32
.L49:
	orq	%rdx, 0(%rbp,%r10)
.L37:
	movq	%rbp, %rdx
	movq	%r12, %rsi
	movl	$0, %edi
	movl	$0, %eax
	call	sched_setaffinity@PLT
	movl	%eax, %ebp
	testl	%eax, %eax
	js	.L48
.L31:
	movl	%ebp, %eax
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
.L38:
	.cfi_restore_state
	addq	$1, %rcx
	cmpq	%rdi, %rcx
	je	.L37
.L40:
	movq	%rcx, %rax
	shrq	$6, %rax
	cltq
	leaq	0(,%rax,8), %r10
	movl	%r8d, %edx
	sall	%cl, %edx
	movslq	%edx, %rdx
	movq	%rdx, %r11
	andq	(%r9,%rax,8), %r11
	je	.L38
	cmpl	%esi, %ebx
	jle	.L49
	addl	$1, %esi
	jmp	.L38
.L48:
	leaq	.LC2(%rip), %rdi
	call	perror@PLT
	jmp	.L31
	.cfi_endproc
.LFE76:
	.size	sched_pin, .-sched_pin
	.section	.rodata.str1.1
.LC3:
	.string	"LMBENCH_SCHED"
.LC4:
	.string	"DEFAULT"
.LC5:
	.string	"SINGLE"
.LC6:
	.string	"BALANCED"
.LC7:
	.string	"BALANCED_SPREAD"
.LC8:
	.string	"UNIQUE"
.LC9:
	.string	"UNIQUE_SPREAD"
.LC10:
	.string	"CUSTOM "
.LC11:
	.string	"CUSTOM_SPREAD "
	.text
	.globl	handle_scheduler
	.type	handle_scheduler, @function
handle_scheduler:
.LFB72:
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
	movl	%edi, %ebp
	movl	%esi, %r13d
	movl	%edx, %r12d
	leaq	.LC3(%rip), %rdi
	call	getenv@PLT
	testq	%rax, %rax
	je	.L57
	movq	%rax, %rbx
	leaq	.LC4(%rip), %rsi
	movq	%rax, %rdi
	call	strcasecmp@PLT
	testl	%eax, %eax
	je	.L50
	leaq	.LC5(%rip), %rsi
	movq	%rbx, %rdi
	call	strcasecmp@PLT
	testl	%eax, %eax
	je	.L58
	leaq	.LC6(%rip), %rsi
	movq	%rbx, %rdi
	call	strcasecmp@PLT
	testl	%eax, %eax
	je	.L52
	leaq	.LC7(%rip), %rsi
	movq	%rbx, %rdi
	call	strcasecmp@PLT
	testl	%eax, %eax
	je	.L61
	leaq	.LC8(%rip), %rsi
	movq	%rbx, %rdi
	call	strcasecmp@PLT
	testl	%eax, %eax
	jne	.L54
	addl	$1, %r12d
	imull	%ebp, %r12d
	leal	(%r12,%r13), %ebp
	jmp	.L52
.L61:
	movl	%ebp, %edi
	call	reverse_bits
	movl	%eax, %ebp
	jmp	.L52
.L54:
	leaq	.LC9(%rip), %rsi
	movq	%rbx, %rdi
	call	strcasecmp@PLT
	testl	%eax, %eax
	je	.L62
	movl	$7, %edx
	leaq	.LC10(%rip), %rsi
	movq	%rbx, %rdi
	call	strncasecmp@PLT
	testl	%eax, %eax
	je	.L63
	movl	$14, %edx
	leaq	.LC11(%rip), %rsi
	movq	%rbx, %rdi
	call	strncasecmp@PLT
	movl	%eax, %edx
	movl	$0, %eax
	testl	%edx, %edx
	jne	.L50
	addl	$1, %r12d
	imull	%ebp, %r12d
	leal	(%r12,%r13), %esi
	leaq	13(%rbx), %rdi
	call	custom
	movl	%eax, %ebp
	jmp	.L52
.L62:
	leal	1(%r12), %edi
	imull	%ebp, %edi
	leal	(%rdi,%r13), %edi
	call	reverse_bits
	movl	%eax, %ebp
	jmp	.L52
.L63:
	leaq	6(%rbx), %rdi
	movl	%ebp, %esi
	call	custom
	movl	%eax, %ebp
	jmp	.L52
.L58:
	movl	%eax, %ebp
.L52:
	movl	$0, %eax
	call	sched_ncpus
	movl	%eax, %ecx
	movl	%ebp, %eax
	cltd
	idivl	%ecx
	movl	%edx, %edi
	call	sched_pin
.L50:
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
.L57:
	.cfi_restore_state
	movl	$0, %eax
	jmp	.L50
	.cfi_endproc
.LFE72:
	.size	handle_scheduler, .-handle_scheduler
	.local	ncpus.0
	.comm	ncpus.0,4,4
	.local	mask.1
	.comm	mask.1,8,8
	.local	sz.2
	.comm	sz.2,4,4
	.local	cpumask.3
	.comm	cpumask.3,8,8
	.data
	.align 4
	.type	nvalues.4, @object
	.size	nvalues.4, 4
nvalues.4:
	.long	-1
	.local	values.5
	.comm	values.5,8,8
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
