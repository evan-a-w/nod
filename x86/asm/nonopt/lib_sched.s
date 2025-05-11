	.file	"lib_sched.c"
	.text
	.section	.rodata
.LC0:
	.string	"LMBENCH_SCHED"
.LC1:
	.string	"DEFAULT"
.LC2:
	.string	"SINGLE"
.LC3:
	.string	"BALANCED"
.LC4:
	.string	"BALANCED_SPREAD"
.LC5:
	.string	"UNIQUE"
.LC6:
	.string	"UNIQUE_SPREAD"
.LC7:
	.string	"CUSTOM "
.LC8:
	.string	"CUSTOM_SPREAD "
	.text
	.globl	handle_scheduler
	.type	handle_scheduler, @function
handle_scheduler:
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
	movl	%esi, -24(%rbp)
	movl	%edx, -28(%rbp)
	movl	$0, -12(%rbp)
	leaq	.LC0(%rip), %rax
	movq	%rax, %rdi
	call	getenv@PLT
	movq	%rax, -8(%rbp)
	cmpq	$0, -8(%rbp)
	je	.L2
	movq	-8(%rbp), %rax
	leaq	.LC1(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcasecmp@PLT
	testl	%eax, %eax
	jne	.L3
.L2:
	movl	$0, %eax
	jmp	.L4
.L3:
	movq	-8(%rbp), %rax
	leaq	.LC2(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcasecmp@PLT
	testl	%eax, %eax
	jne	.L5
	movl	$0, -12(%rbp)
	jmp	.L6
.L5:
	movq	-8(%rbp), %rax
	leaq	.LC3(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcasecmp@PLT
	testl	%eax, %eax
	jne	.L7
	movl	-20(%rbp), %eax
	movl	%eax, -12(%rbp)
	jmp	.L6
.L7:
	movq	-8(%rbp), %rax
	leaq	.LC4(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcasecmp@PLT
	testl	%eax, %eax
	jne	.L8
	movl	-20(%rbp), %eax
	movl	%eax, %edi
	call	reverse_bits
	movl	%eax, -12(%rbp)
	jmp	.L6
.L8:
	movq	-8(%rbp), %rax
	leaq	.LC5(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcasecmp@PLT
	testl	%eax, %eax
	jne	.L9
	movl	-28(%rbp), %eax
	addl	$1, %eax
	imull	-20(%rbp), %eax
	movl	%eax, %edx
	movl	-24(%rbp), %eax
	addl	%edx, %eax
	movl	%eax, -12(%rbp)
	jmp	.L6
.L9:
	movq	-8(%rbp), %rax
	leaq	.LC6(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcasecmp@PLT
	testl	%eax, %eax
	jne	.L10
	movl	-28(%rbp), %eax
	addl	$1, %eax
	imull	-20(%rbp), %eax
	movl	%eax, %edx
	movl	-24(%rbp), %eax
	addl	%edx, %eax
	movl	%eax, %edi
	call	reverse_bits
	movl	%eax, -12(%rbp)
	jmp	.L6
.L10:
	movq	-8(%rbp), %rax
	movl	$7, %edx
	leaq	.LC7(%rip), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	strncasecmp@PLT
	testl	%eax, %eax
	jne	.L11
	movq	-8(%rbp), %rax
	leaq	6(%rax), %rdx
	movl	-20(%rbp), %eax
	movl	%eax, %esi
	movq	%rdx, %rdi
	call	custom
	movl	%eax, -12(%rbp)
	jmp	.L6
.L11:
	movq	-8(%rbp), %rax
	movl	$14, %edx
	leaq	.LC8(%rip), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	strncasecmp@PLT
	testl	%eax, %eax
	jne	.L12
	movl	-28(%rbp), %eax
	addl	$1, %eax
	imull	-20(%rbp), %eax
	movl	%eax, %edx
	movl	-24(%rbp), %eax
	addl	%eax, %edx
	movq	-8(%rbp), %rax
	addq	$13, %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	custom
	movl	%eax, -12(%rbp)
	jmp	.L6
.L12:
	movl	$0, %eax
	jmp	.L4
.L6:
	movl	$0, %eax
	call	sched_ncpus
	movl	%eax, %ecx
	movl	-12(%rbp), %eax
	cltd
	idivl	%ecx
	movl	%edx, %ecx
	movl	%ecx, %eax
	movl	%eax, %edi
	call	sched_pin
.L4:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE8:
	.size	handle_scheduler, .-handle_scheduler
	.globl	reverse_bits
	.type	reverse_bits, @function
reverse_bits:
.LFB9:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movl	%edi, -20(%rbp)
	movl	$0, %eax
	call	sched_ncpus
	subl	$1, %eax
	movl	%eax, -4(%rbp)
	movl	$0, -8(%rbp)
	movl	-4(%rbp), %eax
	sarl	%eax
	movl	%eax, -16(%rbp)
	movl	$1, -12(%rbp)
	jmp	.L14
.L15:
	sarl	-16(%rbp)
	addl	$1, -12(%rbp)
.L14:
	cmpl	$0, -16(%rbp)
	jg	.L15
	movl	$0, -16(%rbp)
	jmp	.L16
.L18:
	movl	-16(%rbp), %eax
	movl	-20(%rbp), %edx
	movl	%eax, %ecx
	sarl	%cl, %edx
	movl	%edx, %eax
	andl	$1, %eax
	testl	%eax, %eax
	je	.L17
	movl	-12(%rbp), %eax
	subl	-16(%rbp), %eax
	subl	$1, %eax
	movl	$1, %edx
	movl	%eax, %ecx
	sall	%cl, %edx
	movl	%edx, %eax
	orl	%eax, -8(%rbp)
.L17:
	addl	$1, -16(%rbp)
.L16:
	movl	-16(%rbp), %eax
	cmpl	-12(%rbp), %eax
	jl	.L18
	movl	-8(%rbp), %eax
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE9:
	.size	reverse_bits, .-reverse_bits
	.section	.rodata
.LC9:
	.string	"%d"
	.text
	.globl	custom
	.type	custom, @function
custom:
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
	movl	%esi, -28(%rbp)
	movq	values.5(%rip), %rax
	testq	%rax, %rax
	jne	.L21
	movl	$0, nvalues.4(%rip)
	movl	$4, %edi
	call	malloc@PLT
	movq	%rax, values.5(%rip)
	jmp	.L22
.L25:
	addq	$1, -24(%rbp)
.L23:
	movq	-24(%rbp), %rax
	movzbl	(%rax), %eax
	testb	%al, %al
	je	.L24
	call	__ctype_b_loc@PLT
	movq	(%rax), %rdx
	movq	-24(%rbp), %rax
	movzbl	(%rax), %eax
	movsbq	%al, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	movzwl	(%rax), %eax
	movzwl	%ax, %eax
	andl	$2048, %eax
	testl	%eax, %eax
	je	.L25
.L24:
	movq	-24(%rbp), %rax
	movq	%rax, -8(%rbp)
	jmp	.L26
.L28:
	addq	$1, -24(%rbp)
.L26:
	movq	-24(%rbp), %rax
	movzbl	(%rax), %eax
	testb	%al, %al
	je	.L27
	call	__ctype_b_loc@PLT
	movq	(%rax), %rdx
	movq	-24(%rbp), %rax
	movzbl	(%rax), %eax
	movsbq	%al, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	movzwl	(%rax), %eax
	movzwl	%ax, %eax
	andl	$2048, %eax
	testl	%eax, %eax
	jne	.L28
.L27:
	movq	-24(%rbp), %rax
	cmpq	-8(%rbp), %rax
	je	.L33
	movq	-24(%rbp), %rax
	leaq	1(%rax), %rdx
	movq	%rdx, -24(%rbp)
	movb	$0, (%rax)
	movq	values.5(%rip), %rcx
	movl	nvalues.4(%rip), %eax
	leal	1(%rax), %edx
	movl	%edx, nvalues.4(%rip)
	cltq
	salq	$2, %rax
	leaq	(%rcx,%rax), %rdx
	movq	-8(%rbp), %rax
	leaq	.LC9(%rip), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf@PLT
	movl	nvalues.4(%rip), %eax
	addl	$1, %eax
	cltq
	leaq	0(,%rax,4), %rdx
	movq	values.5(%rip), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	realloc@PLT
	movq	%rax, values.5(%rip)
.L22:
	movq	-24(%rbp), %rax
	movzbl	(%rax), %eax
	testb	%al, %al
	jne	.L23
	jmp	.L21
.L33:
	nop
.L21:
	movl	nvalues.4(%rip), %eax
	testl	%eax, %eax
	jne	.L31
	movl	$0, %eax
	jmp	.L32
.L31:
	movq	values.5(%rip), %rsi
	movl	nvalues.4(%rip), %ecx
	movl	-28(%rbp), %eax
	cltd
	idivl	%ecx
	movl	%edx, %eax
	cltq
	salq	$2, %rax
	addq	%rsi, %rax
	movl	(%rax), %eax
.L32:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE10:
	.size	custom, .-custom
	.globl	sched_ncpus
	.type	sched_ncpus, @function
sched_ncpus:
.LFB11:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	$84, %edi
	call	sysconf@PLT
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE11:
	.size	sched_ncpus, .-sched_ncpus
	.section	.rodata
.LC10:
	.string	"sched_getaffinity:"
.LC11:
	.string	"sched_setaffinity:"
	.text
	.globl	sched_pin
	.type	sched_pin, @function
sched_pin:
.LFB12:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$48, %rsp
	movl	%edi, -36(%rbp)
	movl	$-1, -20(%rbp)
	movq	cpumask.3(%rip), %rax
	testq	%rax, %rax
	jne	.L37
	movl	$0, %eax
	call	sched_ncpus
	addl	%eax, %eax
	cltq
	shrq	$6, %rax
	addl	$1, %eax
	movl	%eax, sz.2(%rip)
	movl	sz.2(%rip), %eax
	cltq
	salq	$3, %rax
	movq	%rax, %rdi
	call	malloc@PLT
	movq	%rax, mask.1(%rip)
	movl	sz.2(%rip), %eax
	cltq
	salq	$3, %rax
	movq	%rax, %rdi
	call	malloc@PLT
	movq	%rax, cpumask.3(%rip)
	movq	cpumask.3(%rip), %rax
	movl	sz.2(%rip), %edx
	movslq	%edx, %rdx
	leaq	0(,%rdx,8), %rcx
	movq	%rax, %rdx
	movq	%rcx, %rsi
	movl	$0, %edi
	movl	$0, %eax
	call	sched_getaffinity@PLT
	movl	%eax, -20(%rbp)
	cmpl	$0, -20(%rbp)
	jns	.L38
	leaq	.LC10(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
.L38:
	cmpl	$0, -20(%rbp)
	jns	.L39
	movl	-20(%rbp), %eax
	jmp	.L40
.L39:
	movl	$0, -28(%rbp)
	jmp	.L41
.L43:
	movl	-28(%rbp), %eax
	cltq
	shrq	$6, %rax
	movl	%eax, -16(%rbp)
	movl	-28(%rbp), %eax
	andl	$63, %eax
	movl	%eax, -12(%rbp)
	movq	cpumask.3(%rip), %rdx
	movl	-16(%rbp), %eax
	cltq
	salq	$3, %rax
	addq	%rdx, %rax
	movq	(%rax), %rdx
	movl	-12(%rbp), %eax
	movl	$1, %esi
	movl	%eax, %ecx
	sall	%cl, %esi
	movl	%esi, %eax
	cltq
	andq	%rdx, %rax
	testq	%rax, %rax
	je	.L42
	movl	ncpus.0(%rip), %eax
	addl	$1, %eax
	movl	%eax, ncpus.0(%rip)
.L42:
	addl	$1, -28(%rbp)
.L41:
	movl	-28(%rbp), %eax
	cltq
	movl	sz.2(%rip), %edx
	sall	$3, %edx
	movslq	%edx, %rdx
	salq	$3, %rdx
	cmpq	%rdx, %rax
	jb	.L43
.L37:
	movl	ncpus.0(%rip), %ecx
	movl	-36(%rbp), %eax
	cltd
	idivl	%ecx
	movl	%edx, -36(%rbp)
	movl	sz.2(%rip), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	mask.1(%rip), %rax
	movl	$0, %esi
	movq	%rax, %rdi
	call	memset@PLT
	movl	$0, -28(%rbp)
	movl	$0, -24(%rbp)
	jmp	.L44
.L48:
	movl	-28(%rbp), %eax
	cltq
	shrq	$6, %rax
	movl	%eax, -8(%rbp)
	movl	-28(%rbp), %eax
	andl	$63, %eax
	movl	%eax, -4(%rbp)
	movq	cpumask.3(%rip), %rdx
	movl	-8(%rbp), %eax
	cltq
	salq	$3, %rax
	addq	%rdx, %rax
	movq	(%rax), %rdx
	movl	-4(%rbp), %eax
	movl	$1, %esi
	movl	%eax, %ecx
	sall	%cl, %esi
	movl	%esi, %eax
	cltq
	andq	%rdx, %rax
	testq	%rax, %rax
	je	.L45
	movl	-24(%rbp), %eax
	cmpl	-36(%rbp), %eax
	jl	.L46
	movq	mask.1(%rip), %rdx
	movl	-8(%rbp), %eax
	cltq
	salq	$3, %rax
	addq	%rdx, %rax
	movq	(%rax), %rsi
	movl	-4(%rbp), %eax
	movl	$1, %edx
	movl	%eax, %ecx
	sall	%cl, %edx
	movl	%edx, %eax
	movslq	%eax, %rdx
	movq	mask.1(%rip), %rcx
	movl	-8(%rbp), %eax
	cltq
	salq	$3, %rax
	addq	%rcx, %rax
	orq	%rsi, %rdx
	movq	%rdx, (%rax)
	jmp	.L47
.L46:
	addl	$1, -24(%rbp)
.L45:
	addl	$1, -28(%rbp)
.L44:
	movl	-28(%rbp), %eax
	cltq
	movl	sz.2(%rip), %edx
	sall	$3, %edx
	movslq	%edx, %rdx
	salq	$3, %rdx
	cmpq	%rdx, %rax
	jb	.L48
.L47:
	movq	mask.1(%rip), %rax
	movl	sz.2(%rip), %edx
	movslq	%edx, %rdx
	leaq	0(,%rdx,8), %rcx
	movq	%rax, %rdx
	movq	%rcx, %rsi
	movl	$0, %edi
	movl	$0, %eax
	call	sched_setaffinity@PLT
	movl	%eax, -20(%rbp)
	cmpl	$0, -20(%rbp)
	jns	.L49
	leaq	.LC11(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
.L49:
	movl	-20(%rbp), %eax
.L40:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE12:
	.size	sched_pin, .-sched_pin
	.local	values.5
	.comm	values.5,8,8
	.data
	.align 4
	.type	nvalues.4, @object
	.size	nvalues.4, 4
nvalues.4:
	.long	-1
	.local	cpumask.3
	.comm	cpumask.3,8,8
	.local	sz.2
	.comm	sz.2,4,4
	.local	mask.1
	.comm	mask.1,8,8
	.local	ncpus.0
	.comm	ncpus.0,4,4
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
