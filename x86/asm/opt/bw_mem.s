	.file	"bw_mem.c"
	.text
	.globl	wr
	.type	wr, @function
wr:
.LFB77:
	.cfi_startproc
	endbr64
	movq	48(%rsi), %rdx
	leaq	-1(%rdi), %rcx
	testq	%rdi, %rdi
	je	.L1
.L5:
	movq	24(%rsi), %rax
	cmpq	%rax, %rdx
	jb	.L3
.L4:
	movl	$1, (%rax)
	movl	$1, 16(%rax)
	movl	$1, 32(%rax)
	movl	$1, 48(%rax)
	movl	$1, 64(%rax)
	movl	$1, 80(%rax)
	movl	$1, 96(%rax)
	movl	$1, 112(%rax)
	movl	$1, 128(%rax)
	movl	$1, 144(%rax)
	movl	$1, 160(%rax)
	movl	$1, 176(%rax)
	movl	$1, 192(%rax)
	movl	$1, 208(%rax)
	movl	$1, 224(%rax)
	movl	$1, 240(%rax)
	movl	$1, 256(%rax)
	movl	$1, 272(%rax)
	movl	$1, 288(%rax)
	movl	$1, 304(%rax)
	movl	$1, 320(%rax)
	movl	$1, 336(%rax)
	movl	$1, 352(%rax)
	movl	$1, 368(%rax)
	movl	$1, 384(%rax)
	movl	$1, 400(%rax)
	movl	$1, 416(%rax)
	movl	$1, 432(%rax)
	movl	$1, 448(%rax)
	movl	$1, 464(%rax)
	movl	$1, 480(%rax)
	movl	$1, 496(%rax)
	addq	$512, %rax
	cmpq	%rax, %rdx
	jnb	.L4
.L3:
	subq	$1, %rcx
	cmpq	$-1, %rcx
	jne	.L5
.L1:
	ret
	.cfi_endproc
.LFE77:
	.size	wr, .-wr
	.globl	fcp
	.type	fcp, @function
fcp:
.LFB82:
	.cfi_startproc
	endbr64
	movq	%rsi, %r9
	movq	48(%rsi), %rsi
	leaq	-1(%rdi), %r8
	testq	%rdi, %rdi
	je	.L8
.L12:
	movq	24(%r9), %rax
	movq	32(%r9), %rdx
	cmpq	%rax, %rsi
	jb	.L10
.L11:
	movl	(%rax), %ecx
	movl	%ecx, (%rdx)
	movl	4(%rax), %ecx
	movl	%ecx, 4(%rdx)
	movl	8(%rax), %ecx
	movl	%ecx, 8(%rdx)
	movl	12(%rax), %ecx
	movl	%ecx, 12(%rdx)
	movl	16(%rax), %ecx
	movl	%ecx, 16(%rdx)
	movl	20(%rax), %ecx
	movl	%ecx, 20(%rdx)
	movl	24(%rax), %ecx
	movl	%ecx, 24(%rdx)
	movl	28(%rax), %ecx
	movl	%ecx, 28(%rdx)
	movl	32(%rax), %ecx
	movl	%ecx, 32(%rdx)
	movl	36(%rax), %ecx
	movl	%ecx, 36(%rdx)
	movl	40(%rax), %ecx
	movl	%ecx, 40(%rdx)
	movl	44(%rax), %ecx
	movl	%ecx, 44(%rdx)
	movl	48(%rax), %ecx
	movl	%ecx, 48(%rdx)
	movl	52(%rax), %ecx
	movl	%ecx, 52(%rdx)
	movl	56(%rax), %ecx
	movl	%ecx, 56(%rdx)
	movl	60(%rax), %ecx
	movl	%ecx, 60(%rdx)
	movl	64(%rax), %ecx
	movl	%ecx, 64(%rdx)
	movl	68(%rax), %ecx
	movl	%ecx, 68(%rdx)
	movl	72(%rax), %ecx
	movl	%ecx, 72(%rdx)
	movl	76(%rax), %ecx
	movl	%ecx, 76(%rdx)
	movl	80(%rax), %ecx
	movl	%ecx, 80(%rdx)
	movl	84(%rax), %ecx
	movl	%ecx, 84(%rdx)
	movl	88(%rax), %ecx
	movl	%ecx, 88(%rdx)
	movl	92(%rax), %ecx
	movl	%ecx, 92(%rdx)
	movl	96(%rax), %ecx
	movl	%ecx, 96(%rdx)
	movl	100(%rax), %ecx
	movl	%ecx, 100(%rdx)
	movl	104(%rax), %ecx
	movl	%ecx, 104(%rdx)
	movl	108(%rax), %ecx
	movl	%ecx, 108(%rdx)
	movl	112(%rax), %ecx
	movl	%ecx, 112(%rdx)
	movl	116(%rax), %ecx
	movl	%ecx, 116(%rdx)
	movl	120(%rax), %ecx
	movl	%ecx, 120(%rdx)
	movl	124(%rax), %ecx
	movl	%ecx, 124(%rdx)
	movl	128(%rax), %ecx
	movl	%ecx, 128(%rdx)
	movl	132(%rax), %ecx
	movl	%ecx, 132(%rdx)
	movl	136(%rax), %ecx
	movl	%ecx, 136(%rdx)
	movl	140(%rax), %ecx
	movl	%ecx, 140(%rdx)
	movl	144(%rax), %ecx
	movl	%ecx, 144(%rdx)
	movl	148(%rax), %ecx
	movl	%ecx, 148(%rdx)
	movl	152(%rax), %ecx
	movl	%ecx, 152(%rdx)
	movl	156(%rax), %ecx
	movl	%ecx, 156(%rdx)
	movl	160(%rax), %ecx
	movl	%ecx, 160(%rdx)
	movl	164(%rax), %ecx
	movl	%ecx, 164(%rdx)
	movl	168(%rax), %ecx
	movl	%ecx, 168(%rdx)
	movl	172(%rax), %ecx
	movl	%ecx, 172(%rdx)
	movl	176(%rax), %ecx
	movl	%ecx, 176(%rdx)
	movl	180(%rax), %ecx
	movl	%ecx, 180(%rdx)
	movl	184(%rax), %ecx
	movl	%ecx, 184(%rdx)
	movl	188(%rax), %ecx
	movl	%ecx, 188(%rdx)
	movl	192(%rax), %ecx
	movl	%ecx, 192(%rdx)
	movl	196(%rax), %ecx
	movl	%ecx, 196(%rdx)
	movl	200(%rax), %ecx
	movl	%ecx, 200(%rdx)
	movl	204(%rax), %ecx
	movl	%ecx, 204(%rdx)
	movl	208(%rax), %ecx
	movl	%ecx, 208(%rdx)
	movl	212(%rax), %ecx
	movl	%ecx, 212(%rdx)
	movl	216(%rax), %ecx
	movl	%ecx, 216(%rdx)
	movl	220(%rax), %ecx
	movl	%ecx, 220(%rdx)
	movl	224(%rax), %ecx
	movl	%ecx, 224(%rdx)
	movl	228(%rax), %ecx
	movl	%ecx, 228(%rdx)
	movl	232(%rax), %ecx
	movl	%ecx, 232(%rdx)
	movl	236(%rax), %ecx
	movl	%ecx, 236(%rdx)
	movl	240(%rax), %ecx
	movl	%ecx, 240(%rdx)
	movl	244(%rax), %ecx
	movl	%ecx, 244(%rdx)
	movl	248(%rax), %ecx
	movl	%ecx, 248(%rdx)
	movl	252(%rax), %ecx
	movl	%ecx, 252(%rdx)
	movl	256(%rax), %ecx
	movl	%ecx, 256(%rdx)
	movl	260(%rax), %ecx
	movl	%ecx, 260(%rdx)
	movl	264(%rax), %ecx
	movl	%ecx, 264(%rdx)
	movl	268(%rax), %ecx
	movl	%ecx, 268(%rdx)
	movl	272(%rax), %ecx
	movl	%ecx, 272(%rdx)
	movl	276(%rax), %ecx
	movl	%ecx, 276(%rdx)
	movl	280(%rax), %ecx
	movl	%ecx, 280(%rdx)
	movl	284(%rax), %ecx
	movl	%ecx, 284(%rdx)
	movl	288(%rax), %ecx
	movl	%ecx, 288(%rdx)
	movl	292(%rax), %ecx
	movl	%ecx, 292(%rdx)
	movl	296(%rax), %ecx
	movl	%ecx, 296(%rdx)
	movl	300(%rax), %ecx
	movl	%ecx, 300(%rdx)
	movl	304(%rax), %ecx
	movl	%ecx, 304(%rdx)
	movl	308(%rax), %ecx
	movl	%ecx, 308(%rdx)
	movl	312(%rax), %ecx
	movl	%ecx, 312(%rdx)
	movl	316(%rax), %ecx
	movl	%ecx, 316(%rdx)
	movl	320(%rax), %ecx
	movl	%ecx, 320(%rdx)
	movl	324(%rax), %ecx
	movl	%ecx, 324(%rdx)
	movl	328(%rax), %ecx
	movl	%ecx, 328(%rdx)
	movl	332(%rax), %ecx
	movl	%ecx, 332(%rdx)
	movl	336(%rax), %ecx
	movl	%ecx, 336(%rdx)
	movl	340(%rax), %ecx
	movl	%ecx, 340(%rdx)
	movl	344(%rax), %ecx
	movl	%ecx, 344(%rdx)
	movl	348(%rax), %ecx
	movl	%ecx, 348(%rdx)
	movl	352(%rax), %ecx
	movl	%ecx, 352(%rdx)
	movl	356(%rax), %ecx
	movl	%ecx, 356(%rdx)
	movl	360(%rax), %ecx
	movl	%ecx, 360(%rdx)
	movl	364(%rax), %ecx
	movl	%ecx, 364(%rdx)
	movl	368(%rax), %ecx
	movl	%ecx, 368(%rdx)
	movl	372(%rax), %ecx
	movl	%ecx, 372(%rdx)
	movl	376(%rax), %ecx
	movl	%ecx, 376(%rdx)
	movl	380(%rax), %ecx
	movl	%ecx, 380(%rdx)
	movl	384(%rax), %ecx
	movl	%ecx, 384(%rdx)
	movl	388(%rax), %ecx
	movl	%ecx, 388(%rdx)
	movl	392(%rax), %ecx
	movl	%ecx, 392(%rdx)
	movl	396(%rax), %ecx
	movl	%ecx, 396(%rdx)
	movl	400(%rax), %ecx
	movl	%ecx, 400(%rdx)
	movl	404(%rax), %ecx
	movl	%ecx, 404(%rdx)
	movl	408(%rax), %ecx
	movl	%ecx, 408(%rdx)
	movl	412(%rax), %ecx
	movl	%ecx, 412(%rdx)
	movl	416(%rax), %ecx
	movl	%ecx, 416(%rdx)
	movl	420(%rax), %ecx
	movl	%ecx, 420(%rdx)
	movl	424(%rax), %ecx
	movl	%ecx, 424(%rdx)
	movl	428(%rax), %ecx
	movl	%ecx, 428(%rdx)
	movl	432(%rax), %ecx
	movl	%ecx, 432(%rdx)
	movl	436(%rax), %ecx
	movl	%ecx, 436(%rdx)
	movl	440(%rax), %ecx
	movl	%ecx, 440(%rdx)
	movl	444(%rax), %ecx
	movl	%ecx, 444(%rdx)
	movl	448(%rax), %ecx
	movl	%ecx, 448(%rdx)
	movl	452(%rax), %ecx
	movl	%ecx, 452(%rdx)
	movl	456(%rax), %ecx
	movl	%ecx, 456(%rdx)
	movl	460(%rax), %ecx
	movl	%ecx, 460(%rdx)
	movl	464(%rax), %ecx
	movl	%ecx, 464(%rdx)
	movl	468(%rax), %ecx
	movl	%ecx, 468(%rdx)
	movl	472(%rax), %ecx
	movl	%ecx, 472(%rdx)
	movl	476(%rax), %ecx
	movl	%ecx, 476(%rdx)
	movl	480(%rax), %ecx
	movl	%ecx, 480(%rdx)
	movl	484(%rax), %ecx
	movl	%ecx, 484(%rdx)
	movl	488(%rax), %ecx
	movl	%ecx, 488(%rdx)
	movl	492(%rax), %ecx
	movl	%ecx, 492(%rdx)
	movl	496(%rax), %ecx
	movl	%ecx, 496(%rdx)
	movl	500(%rax), %ecx
	movl	%ecx, 500(%rdx)
	movl	504(%rax), %ecx
	movl	%ecx, 504(%rdx)
	movl	508(%rax), %ecx
	movl	%ecx, 508(%rdx)
	addq	$512, %rax
	addq	$512, %rdx
	cmpq	%rax, %rsi
	jnb	.L11
.L10:
	subq	$1, %r8
	cmpq	$-1, %r8
	jne	.L12
.L8:
	ret
	.cfi_endproc
.LFE82:
	.size	fcp, .-fcp
	.globl	loop_bzero
	.type	loop_bzero, @function
loop_bzero:
.LFB83:
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
	movq	24(%rsi), %r12
	movq	56(%rsi), %rbp
	leaq	-1(%rdi), %rbx
	testq	%rdi, %rdi
	je	.L15
.L17:
	movq	%rbp, %rdx
	movl	$0, %esi
	movq	%r12, %rdi
	call	memset@PLT
	subq	$1, %rbx
	cmpq	$-1, %rbx
	jne	.L17
.L15:
	popq	%rbx
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE83:
	.size	loop_bzero, .-loop_bzero
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"malloc"
	.text
	.globl	init_loop
	.type	init_loop, @function
init_loop:
.LFB74:
	.cfi_startproc
	endbr64
	testq	%rdi, %rdi
	je	.L28
	ret
.L28:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushq	%rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	subq	$8, %rsp
	.cfi_def_cfa_offset 32
	movq	%rsi, %rbx
	movq	8(%rsi), %rdi
	call	valloc@PLT
	movq	%rax, %rdi
	movq	%rax, 24(%rbx)
	movq	$0, 40(%rbx)
	movq	8(%rbx), %rbp
	leaq	-512(%rax,%rbp), %rax
	movq	%rax, 48(%rbx)
	movq	%rbp, 56(%rbx)
	testq	%rdi, %rdi
	je	.L29
	movq	%rbp, %rdx
	movl	$0, %esi
	call	memset@PLT
	cmpl	$1, 16(%rbx)
	je	.L30
.L20:
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
.L29:
	.cfi_restore_state
	leaq	.LC0(%rip), %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L30:
	leaq	2048(%rbp), %rdi
	call	valloc@PLT
	movq	%rax, 32(%rbx)
	movq	%rax, 40(%rbx)
	testq	%rax, %rax
	je	.L31
	cmpl	$0, 20(%rbx)
	je	.L20
	addq	$1920, %rax
	movq	%rax, 32(%rbx)
	jmp	.L20
.L31:
	leaq	.LC0(%rip), %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
	.cfi_endproc
.LFE74:
	.size	init_loop, .-init_loop
	.globl	cleanup
	.type	cleanup, @function
cleanup:
.LFB75:
	.cfi_startproc
	endbr64
	testq	%rdi, %rdi
	je	.L38
	ret
.L38:
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movq	%rsi, %rbx
	movq	24(%rsi), %rdi
	call	free@PLT
	movq	40(%rbx), %rdi
	testq	%rdi, %rdi
	je	.L32
	call	free@PLT
.L32:
	popq	%rbx
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE75:
	.size	cleanup, .-cleanup
	.globl	rd
	.type	rd, @function
rd:
.LFB76:
	.cfi_startproc
	endbr64
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	movq	48(%rsi), %rcx
	testq	%rdi, %rdi
	je	.L44
	leaq	-1(%rdi), %r8
	movq	24(%rsi), %rsi
	movl	$0, %edi
.L43:
	cmpq	%rsi, %rcx
	jb	.L41
	movq	%rsi, %rdx
.L42:
	movl	16(%rdx), %eax
	addl	(%rdx), %eax
	addl	32(%rdx), %eax
	addl	48(%rdx), %eax
	addl	64(%rdx), %eax
	addl	80(%rdx), %eax
	addl	96(%rdx), %eax
	addl	112(%rdx), %eax
	addl	128(%rdx), %eax
	addl	144(%rdx), %eax
	addl	160(%rdx), %eax
	addl	176(%rdx), %eax
	addl	192(%rdx), %eax
	addl	208(%rdx), %eax
	addl	224(%rdx), %eax
	addl	240(%rdx), %eax
	addl	256(%rdx), %eax
	addl	272(%rdx), %eax
	addl	288(%rdx), %eax
	addl	304(%rdx), %eax
	addl	320(%rdx), %eax
	addl	336(%rdx), %eax
	addl	352(%rdx), %eax
	addl	368(%rdx), %eax
	addl	384(%rdx), %eax
	addl	400(%rdx), %eax
	addl	416(%rdx), %eax
	addl	432(%rdx), %eax
	addl	448(%rdx), %eax
	addl	464(%rdx), %eax
	addl	480(%rdx), %eax
	addl	496(%rdx), %eax
	addl	%eax, %edi
	addq	$512, %rdx
	cmpq	%rdx, %rcx
	jnb	.L42
.L41:
	subq	$1, %r8
	cmpq	$-1, %r8
	jne	.L43
.L40:
	call	use_int@PLT
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	ret
.L44:
	.cfi_restore_state
	movl	$0, %edi
	jmp	.L40
	.cfi_endproc
.LFE76:
	.size	rd, .-rd
	.globl	rdwr
	.type	rdwr, @function
rdwr:
.LFB78:
	.cfi_startproc
	endbr64
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	movq	48(%rsi), %rdx
	testq	%rdi, %rdi
	je	.L53
	leaq	-1(%rdi), %rcx
	movl	$0, %edi
.L52:
	movq	24(%rsi), %rax
	cmpq	%rax, %rdx
	jb	.L50
.L51:
	addl	(%rax), %edi
	movl	$1, (%rax)
	addl	16(%rax), %edi
	movl	$1, 16(%rax)
	addl	32(%rax), %edi
	movl	$1, 32(%rax)
	addl	48(%rax), %edi
	movl	$1, 48(%rax)
	addl	64(%rax), %edi
	movl	$1, 64(%rax)
	addl	80(%rax), %edi
	movl	$1, 80(%rax)
	addl	96(%rax), %edi
	movl	$1, 96(%rax)
	addl	112(%rax), %edi
	movl	$1, 112(%rax)
	addl	128(%rax), %edi
	movl	$1, 128(%rax)
	addl	144(%rax), %edi
	movl	$1, 144(%rax)
	addl	160(%rax), %edi
	movl	$1, 160(%rax)
	addl	176(%rax), %edi
	movl	$1, 176(%rax)
	addl	192(%rax), %edi
	movl	$1, 192(%rax)
	addl	208(%rax), %edi
	movl	$1, 208(%rax)
	addl	224(%rax), %edi
	movl	$1, 224(%rax)
	addl	240(%rax), %edi
	movl	$1, 240(%rax)
	addl	256(%rax), %edi
	movl	$1, 256(%rax)
	addl	272(%rax), %edi
	movl	$1, 272(%rax)
	addl	288(%rax), %edi
	movl	$1, 288(%rax)
	addl	304(%rax), %edi
	movl	$1, 304(%rax)
	addl	320(%rax), %edi
	movl	$1, 320(%rax)
	addl	336(%rax), %edi
	movl	$1, 336(%rax)
	addl	352(%rax), %edi
	movl	$1, 352(%rax)
	addl	368(%rax), %edi
	movl	$1, 368(%rax)
	addl	384(%rax), %edi
	movl	$1, 384(%rax)
	addl	400(%rax), %edi
	movl	$1, 400(%rax)
	addl	416(%rax), %edi
	movl	$1, 416(%rax)
	addl	432(%rax), %edi
	movl	$1, 432(%rax)
	addl	448(%rax), %edi
	movl	$1, 448(%rax)
	addl	464(%rax), %edi
	movl	$1, 464(%rax)
	addl	480(%rax), %edi
	movl	$1, 480(%rax)
	addl	496(%rax), %edi
	movl	$1, 496(%rax)
	addq	$512, %rax
	cmpq	%rax, %rdx
	jnb	.L51
.L50:
	subq	$1, %rcx
	cmpq	$-1, %rcx
	jne	.L52
.L49:
	call	use_int@PLT
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	ret
.L53:
	.cfi_restore_state
	movl	$0, %edi
	jmp	.L49
	.cfi_endproc
.LFE78:
	.size	rdwr, .-rdwr
	.globl	frd
	.type	frd, @function
frd:
.LFB81:
	.cfi_startproc
	endbr64
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	movq	48(%rsi), %rcx
	testq	%rdi, %rdi
	je	.L62
	leaq	-1(%rdi), %r8
	movq	24(%rsi), %rsi
	movl	$0, %edi
.L61:
	cmpq	%rsi, %rcx
	jb	.L59
	movq	%rsi, %rdx
.L60:
	movl	4(%rdx), %eax
	addl	(%rdx), %eax
	addl	8(%rdx), %eax
	addl	12(%rdx), %eax
	addl	16(%rdx), %eax
	addl	20(%rdx), %eax
	addl	24(%rdx), %eax
	addl	28(%rdx), %eax
	addl	32(%rdx), %eax
	addl	36(%rdx), %eax
	addl	40(%rdx), %eax
	addl	44(%rdx), %eax
	addl	48(%rdx), %eax
	addl	52(%rdx), %eax
	addl	56(%rdx), %eax
	addl	60(%rdx), %eax
	addl	64(%rdx), %eax
	addl	68(%rdx), %eax
	addl	72(%rdx), %eax
	addl	76(%rdx), %eax
	addl	80(%rdx), %eax
	addl	84(%rdx), %eax
	addl	88(%rdx), %eax
	addl	92(%rdx), %eax
	addl	96(%rdx), %eax
	addl	100(%rdx), %eax
	addl	104(%rdx), %eax
	addl	108(%rdx), %eax
	addl	112(%rdx), %eax
	addl	116(%rdx), %eax
	addl	120(%rdx), %eax
	addl	124(%rdx), %eax
	addl	128(%rdx), %eax
	addl	132(%rdx), %eax
	addl	136(%rdx), %eax
	addl	140(%rdx), %eax
	addl	144(%rdx), %eax
	addl	148(%rdx), %eax
	addl	152(%rdx), %eax
	addl	156(%rdx), %eax
	addl	160(%rdx), %eax
	addl	164(%rdx), %eax
	addl	168(%rdx), %eax
	addl	172(%rdx), %eax
	addl	176(%rdx), %eax
	addl	180(%rdx), %eax
	addl	184(%rdx), %eax
	addl	188(%rdx), %eax
	addl	192(%rdx), %eax
	addl	196(%rdx), %eax
	addl	200(%rdx), %eax
	addl	204(%rdx), %eax
	addl	208(%rdx), %eax
	addl	212(%rdx), %eax
	addl	216(%rdx), %eax
	addl	220(%rdx), %eax
	addl	224(%rdx), %eax
	addl	228(%rdx), %eax
	addl	232(%rdx), %eax
	addl	236(%rdx), %eax
	addl	240(%rdx), %eax
	addl	244(%rdx), %eax
	addl	248(%rdx), %eax
	addl	252(%rdx), %eax
	addl	256(%rdx), %eax
	addl	260(%rdx), %eax
	addl	264(%rdx), %eax
	addl	268(%rdx), %eax
	addl	272(%rdx), %eax
	addl	276(%rdx), %eax
	addl	280(%rdx), %eax
	addl	284(%rdx), %eax
	addl	288(%rdx), %eax
	addl	292(%rdx), %eax
	addl	296(%rdx), %eax
	addl	300(%rdx), %eax
	addl	304(%rdx), %eax
	addl	308(%rdx), %eax
	addl	312(%rdx), %eax
	addl	316(%rdx), %eax
	addl	320(%rdx), %eax
	addl	324(%rdx), %eax
	addl	328(%rdx), %eax
	addl	332(%rdx), %eax
	addl	336(%rdx), %eax
	addl	340(%rdx), %eax
	addl	344(%rdx), %eax
	addl	348(%rdx), %eax
	addl	352(%rdx), %eax
	addl	356(%rdx), %eax
	addl	360(%rdx), %eax
	addl	364(%rdx), %eax
	addl	368(%rdx), %eax
	addl	372(%rdx), %eax
	addl	376(%rdx), %eax
	addl	380(%rdx), %eax
	addl	384(%rdx), %eax
	addl	388(%rdx), %eax
	addl	392(%rdx), %eax
	addl	396(%rdx), %eax
	addl	400(%rdx), %eax
	addl	404(%rdx), %eax
	addl	408(%rdx), %eax
	addl	412(%rdx), %eax
	addl	416(%rdx), %eax
	addl	420(%rdx), %eax
	addl	424(%rdx), %eax
	addl	428(%rdx), %eax
	addl	432(%rdx), %eax
	addl	436(%rdx), %eax
	addl	440(%rdx), %eax
	addl	444(%rdx), %eax
	addl	448(%rdx), %eax
	addl	452(%rdx), %eax
	addl	456(%rdx), %eax
	addl	460(%rdx), %eax
	addl	464(%rdx), %eax
	addl	468(%rdx), %eax
	addl	472(%rdx), %eax
	addl	476(%rdx), %eax
	addl	480(%rdx), %eax
	addl	484(%rdx), %eax
	addl	488(%rdx), %eax
	addl	492(%rdx), %eax
	addl	496(%rdx), %eax
	addl	500(%rdx), %eax
	addl	504(%rdx), %eax
	addl	508(%rdx), %eax
	addl	%eax, %edi
	addq	$512, %rdx
	cmpq	%rdx, %rcx
	jnb	.L60
.L59:
	subq	$1, %r8
	cmpq	$-1, %r8
	jne	.L61
.L58:
	call	use_int@PLT
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	ret
.L62:
	.cfi_restore_state
	movl	$0, %edi
	jmp	.L58
	.cfi_endproc
.LFE81:
	.size	frd, .-frd
	.globl	mcp
	.type	mcp, @function
mcp:
.LFB79:
	.cfi_startproc
	endbr64
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	movq	%rsi, %r9
	movq	48(%rsi), %rsi
	leaq	-1(%rdi), %r8
	testq	%rdi, %rdi
	je	.L71
.L70:
	movq	24(%r9), %rdi
	movq	32(%r9), %rdx
	cmpq	%rdi, %rsi
	jb	.L68
	movq	%rdi, %rax
.L69:
	movl	(%rax), %ecx
	movl	%ecx, (%rdx)
	movl	16(%rax), %ecx
	movl	%ecx, 16(%rdx)
	movl	32(%rax), %ecx
	movl	%ecx, 32(%rdx)
	movl	48(%rax), %ecx
	movl	%ecx, 48(%rdx)
	movl	64(%rax), %ecx
	movl	%ecx, 64(%rdx)
	movl	80(%rax), %ecx
	movl	%ecx, 80(%rdx)
	movl	96(%rax), %ecx
	movl	%ecx, 96(%rdx)
	movl	112(%rax), %ecx
	movl	%ecx, 112(%rdx)
	movl	128(%rax), %ecx
	movl	%ecx, 128(%rdx)
	movl	144(%rax), %ecx
	movl	%ecx, 144(%rdx)
	movl	160(%rax), %ecx
	movl	%ecx, 160(%rdx)
	movl	176(%rax), %ecx
	movl	%ecx, 176(%rdx)
	movl	192(%rax), %ecx
	movl	%ecx, 192(%rdx)
	movl	208(%rax), %ecx
	movl	%ecx, 208(%rdx)
	movl	224(%rax), %ecx
	movl	%ecx, 224(%rdx)
	movl	240(%rax), %ecx
	movl	%ecx, 240(%rdx)
	movl	256(%rax), %ecx
	movl	%ecx, 256(%rdx)
	movl	272(%rax), %ecx
	movl	%ecx, 272(%rdx)
	movl	288(%rax), %ecx
	movl	%ecx, 288(%rdx)
	movl	304(%rax), %ecx
	movl	%ecx, 304(%rdx)
	movl	320(%rax), %ecx
	movl	%ecx, 320(%rdx)
	movl	336(%rax), %ecx
	movl	%ecx, 336(%rdx)
	movl	352(%rax), %ecx
	movl	%ecx, 352(%rdx)
	movl	368(%rax), %ecx
	movl	%ecx, 368(%rdx)
	movl	384(%rax), %ecx
	movl	%ecx, 384(%rdx)
	movl	400(%rax), %ecx
	movl	%ecx, 400(%rdx)
	movl	416(%rax), %ecx
	movl	%ecx, 416(%rdx)
	movl	432(%rax), %ecx
	movl	%ecx, 432(%rdx)
	movl	448(%rax), %ecx
	movl	%ecx, 448(%rdx)
	movl	464(%rax), %ecx
	movl	%ecx, 464(%rdx)
	movl	480(%rax), %ecx
	movl	%ecx, 480(%rdx)
	movl	496(%rax), %ecx
	movl	%ecx, 496(%rdx)
	addq	$512, %rax
	addq	$512, %rdx
	cmpq	%rax, %rsi
	jnb	.L69
	movq	%rsi, %rax
	subq	%rdi, %rax
	andq	$-512, %rax
	leaq	512(%rdi,%rax), %rdi
.L68:
	subq	$1, %r8
	cmpq	$-1, %r8
	jne	.L70
.L67:
	call	use_pointer@PLT
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	ret
.L71:
	.cfi_restore_state
	movl	$0, %edi
	jmp	.L67
	.cfi_endproc
.LFE79:
	.size	mcp, .-mcp
	.globl	fwr
	.type	fwr, @function
fwr:
.LFB80:
	.cfi_startproc
	endbr64
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	movq	48(%rsi), %rdx
	leaq	-1(%rdi), %rcx
	testq	%rdi, %rdi
	je	.L80
.L79:
	movq	24(%rsi), %rdi
	cmpq	%rdi, %rdx
	jb	.L77
	movq	%rdi, %rax
.L78:
	movl	$1, 508(%rax)
	movl	$1, 504(%rax)
	movl	$1, 500(%rax)
	movl	$1, 496(%rax)
	movl	$1, 492(%rax)
	movl	$1, 488(%rax)
	movl	$1, 484(%rax)
	movl	$1, 480(%rax)
	movl	$1, 476(%rax)
	movl	$1, 472(%rax)
	movl	$1, 468(%rax)
	movl	$1, 464(%rax)
	movl	$1, 460(%rax)
	movl	$1, 456(%rax)
	movl	$1, 452(%rax)
	movl	$1, 448(%rax)
	movl	$1, 444(%rax)
	movl	$1, 440(%rax)
	movl	$1, 436(%rax)
	movl	$1, 432(%rax)
	movl	$1, 428(%rax)
	movl	$1, 424(%rax)
	movl	$1, 420(%rax)
	movl	$1, 416(%rax)
	movl	$1, 412(%rax)
	movl	$1, 408(%rax)
	movl	$1, 404(%rax)
	movl	$1, 400(%rax)
	movl	$1, 396(%rax)
	movl	$1, 392(%rax)
	movl	$1, 388(%rax)
	movl	$1, 384(%rax)
	movl	$1, 380(%rax)
	movl	$1, 376(%rax)
	movl	$1, 372(%rax)
	movl	$1, 368(%rax)
	movl	$1, 364(%rax)
	movl	$1, 360(%rax)
	movl	$1, 356(%rax)
	movl	$1, 352(%rax)
	movl	$1, 348(%rax)
	movl	$1, 344(%rax)
	movl	$1, 340(%rax)
	movl	$1, 336(%rax)
	movl	$1, 332(%rax)
	movl	$1, 328(%rax)
	movl	$1, 324(%rax)
	movl	$1, 320(%rax)
	movl	$1, 316(%rax)
	movl	$1, 312(%rax)
	movl	$1, 308(%rax)
	movl	$1, 304(%rax)
	movl	$1, 300(%rax)
	movl	$1, 296(%rax)
	movl	$1, 292(%rax)
	movl	$1, 288(%rax)
	movl	$1, 284(%rax)
	movl	$1, 280(%rax)
	movl	$1, 276(%rax)
	movl	$1, 272(%rax)
	movl	$1, 268(%rax)
	movl	$1, 264(%rax)
	movl	$1, 260(%rax)
	movl	$1, 256(%rax)
	movl	$1, 252(%rax)
	movl	$1, 248(%rax)
	movl	$1, 244(%rax)
	movl	$1, 240(%rax)
	movl	$1, 236(%rax)
	movl	$1, 232(%rax)
	movl	$1, 228(%rax)
	movl	$1, 224(%rax)
	movl	$1, 220(%rax)
	movl	$1, 216(%rax)
	movl	$1, 212(%rax)
	movl	$1, 208(%rax)
	movl	$1, 204(%rax)
	movl	$1, 200(%rax)
	movl	$1, 196(%rax)
	movl	$1, 192(%rax)
	movl	$1, 188(%rax)
	movl	$1, 184(%rax)
	movl	$1, 180(%rax)
	movl	$1, 176(%rax)
	movl	$1, 172(%rax)
	movl	$1, 168(%rax)
	movl	$1, 164(%rax)
	movl	$1, 160(%rax)
	movl	$1, 156(%rax)
	movl	$1, 152(%rax)
	movl	$1, 148(%rax)
	movl	$1, 144(%rax)
	movl	$1, 140(%rax)
	movl	$1, 136(%rax)
	movl	$1, 132(%rax)
	movl	$1, 128(%rax)
	movl	$1, 124(%rax)
	movl	$1, 120(%rax)
	movl	$1, 116(%rax)
	movl	$1, 112(%rax)
	movl	$1, 108(%rax)
	movl	$1, 104(%rax)
	movl	$1, 100(%rax)
	movl	$1, 96(%rax)
	movl	$1, 92(%rax)
	movl	$1, 88(%rax)
	movl	$1, 84(%rax)
	movl	$1, 80(%rax)
	movl	$1, 76(%rax)
	movl	$1, 72(%rax)
	movl	$1, 68(%rax)
	movl	$1, 64(%rax)
	movl	$1, 60(%rax)
	movl	$1, 56(%rax)
	movl	$1, 52(%rax)
	movl	$1, 48(%rax)
	movl	$1, 44(%rax)
	movl	$1, 40(%rax)
	movl	$1, 36(%rax)
	movl	$1, 32(%rax)
	movl	$1, 28(%rax)
	movl	$1, 24(%rax)
	movl	$1, 20(%rax)
	movl	$1, 16(%rax)
	movl	$1, 12(%rax)
	movl	$1, 8(%rax)
	movl	$1, 4(%rax)
	movl	$1, (%rax)
	addq	$512, %rax
	cmpq	%rax, %rdx
	jnb	.L78
	movq	%rdx, %rax
	subq	%rdi, %rax
	andq	$-512, %rax
	leaq	512(%rdi,%rax), %rdi
.L77:
	subq	$1, %rcx
	cmpq	$-1, %rcx
	jne	.L79
.L76:
	call	use_pointer@PLT
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	ret
.L80:
	.cfi_restore_state
	movl	$0, %edi
	jmp	.L76
	.cfi_endproc
.LFE80:
	.size	fwr, .-fwr
	.globl	loop_bcopy
	.type	loop_bcopy, @function
loop_bcopy:
.LFB84:
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
	movq	24(%rsi), %r13
	movq	32(%rsi), %r12
	movq	56(%rsi), %rbp
	leaq	-1(%rdi), %rbx
	testq	%rdi, %rdi
	je	.L84
.L86:
	movq	%rbp, %rdx
	movq	%r13, %rsi
	movq	%r12, %rdi
	call	memmove@PLT
	subq	$1, %rbx
	cmpq	$-1, %rbx
	jne	.L86
.L84:
	addq	$8, %rsp
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
	.cfi_endproc
.LFE84:
	.size	loop_bcopy, .-loop_bcopy
	.globl	init_overhead
	.type	init_overhead, @function
init_overhead:
.LFB73:
	.cfi_startproc
	endbr64
	ret
	.cfi_endproc
.LFE73:
	.size	init_overhead, .-init_overhead
	.section	.rodata.str1.1
.LC4:
	.string	"%.6f "
.LC5:
	.string	"%.2f "
.LC6:
	.string	"%.6f\n"
.LC7:
	.string	"%.2f\n"
	.text
	.globl	adjusted_bandwidth
	.type	adjusted_bandwidth, @function
adjusted_bandwidth:
.LFB85:
	.cfi_startproc
	endbr64
	subq	$24, %rsp
	.cfi_def_cfa_offset 32
	movq	%rsi, %rax
	testq	%rdi, %rdi
	js	.L91
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rdi, %xmm1
.L92:
	testq	%rdx, %rdx
	js	.L93
	pxor	%xmm2, %xmm2
	cvtsi2sdq	%rdx, %xmm2
.L94:
	divsd	%xmm2, %xmm1
	subsd	%xmm0, %xmm1
	divsd	.LC1(%rip), %xmm1
	movsd	%xmm1, 8(%rsp)
	pxor	%xmm0, %xmm0
	comisd	%xmm1, %xmm0
	jnb	.L90
	cmpq	$0, ftiming(%rip)
	je	.L109
.L96:
	testq	%rax, %rax
	js	.L97
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
.L98:
	divsd	.LC1(%rip), %xmm0
	movapd	%xmm0, %xmm3
	movsd	%xmm0, (%rsp)
	movsd	.LC3(%rip), %xmm0
	comisd	%xmm3, %xmm0
	ja	.L110
	movsd	(%rsp), %xmm0
	leaq	.LC5(%rip), %rdx
	movl	$1, %esi
	movq	ftiming(%rip), %rdi
	movl	$1, %eax
	call	__fprintf_chk@PLT
.L101:
	movsd	(%rsp), %xmm0
	divsd	8(%rsp), %xmm0
	movsd	.LC3(%rip), %xmm1
	comisd	%xmm0, %xmm1
	ja	.L111
	leaq	.LC7(%rip), %rdx
	movl	$1, %esi
	movq	ftiming(%rip), %rdi
	movl	$1, %eax
	call	__fprintf_chk@PLT
.L90:
	addq	$24, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	ret
.L91:
	.cfi_restore_state
	movq	%rdi, %rcx
	shrq	%rcx
	andl	$1, %edi
	orq	%rdi, %rcx
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rcx, %xmm1
	addsd	%xmm1, %xmm1
	jmp	.L92
.L93:
	movq	%rdx, %rcx
	shrq	%rcx
	andl	$1, %edx
	orq	%rdx, %rcx
	pxor	%xmm2, %xmm2
	cvtsi2sdq	%rcx, %xmm2
	addsd	%xmm2, %xmm2
	jmp	.L94
.L109:
	movq	stderr(%rip), %rdx
	movq	%rdx, ftiming(%rip)
	jmp	.L96
.L97:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
	jmp	.L98
.L110:
	movapd	%xmm3, %xmm0
	leaq	.LC4(%rip), %rdx
	movl	$1, %esi
	movq	ftiming(%rip), %rdi
	movl	$1, %eax
	call	__fprintf_chk@PLT
	jmp	.L101
.L111:
	leaq	.LC6(%rip), %rdx
	movl	$1, %esi
	movq	ftiming(%rip), %rdi
	movl	$1, %eax
	call	__fprintf_chk@PLT
	jmp	.L90
	.cfi_endproc
.LFE85:
	.size	adjusted_bandwidth, .-adjusted_bandwidth
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC8:
	.string	"[-P <parallelism>] [-W <warmup>] [-N <repetitions>] <size> what [conflict]\nwhat: rd wr rdwr cp fwr frd fcp bzero bcopy\n<size> must be larger than 512"
	.section	.rodata.str1.1
.LC9:
	.string	"P:W:N:"
.LC10:
	.string	"cp"
.LC11:
	.string	"fcp"
.LC12:
	.string	"bcopy"
.LC13:
	.string	"rd"
.LC14:
	.string	"wr"
.LC15:
	.string	"rdwr"
.LC16:
	.string	"frd"
.LC17:
	.string	"fwr"
.LC18:
	.string	"bzero"
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
	subq	$104, %rsp
	.cfi_def_cfa_offset 160
	movl	%edi, %ebp
	movq	%rsi, %rbx
	movq	%fs:40, %rax
	movq	%rax, 88(%rsp)
	xorl	%eax, %eax
	movq	$0x000000000, 16(%rsp)
	movl	$-1, %r14d
	movl	$0, 12(%rsp)
	movl	$1, %r13d
	leaq	.LC9(%rip), %r12
	leaq	.LC8(%rip), %r15
	jmp	.L113
.L114:
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	movl	%eax, %r13d
	testl	%eax, %eax
	jg	.L113
	movq	%r15, %rdx
	movq	%rbx, %rsi
	movl	%ebp, %edi
	call	lmbench_usage@PLT
	jmp	.L113
.L115:
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	movl	%eax, 12(%rsp)
.L113:
	movq	%r12, %rdx
	movq	%rbx, %rsi
	movl	%ebp, %edi
	call	mygetopt@PLT
	cmpl	$-1, %eax
	je	.L138
	cmpl	$80, %eax
	je	.L114
	cmpl	$87, %eax
	je	.L115
	cmpl	$78, %eax
	je	.L139
	movq	%r15, %rdx
	movq	%rbx, %rsi
	movl	%ebp, %edi
	call	lmbench_usage@PLT
	jmp	.L113
.L139:
	movl	$10, %edx
	movl	$0, %esi
	movq	myoptarg(%rip), %rdi
	call	strtol@PLT
	movl	%eax, %r14d
	jmp	.L113
.L138:
	movl	$0, 32(%rsp)
	movl	$0, 36(%rsp)
	movl	myoptind(%rip), %eax
	leal	3(%rax), %edx
	cmpl	%ebp, %edx
	je	.L140
	addl	$2, %eax
	cmpl	%ebp, %eax
	je	.L121
	leaq	.LC8(%rip), %rdx
	movq	%rbx, %rsi
	movl	%ebp, %edi
	call	lmbench_usage@PLT
	jmp	.L121
.L140:
	movl	$1, 36(%rsp)
.L121:
	movslq	myoptind(%rip), %rax
	movq	(%rbx,%rax,8), %rdi
	call	bytes@PLT
	movq	%rax, %r12
	movq	%rax, 24(%rsp)
	cmpq	$511, %rax
	jbe	.L141
.L122:
	movslq	myoptind(%rip), %rax
	movq	8(%rbx,%rax,8), %r15
	leaq	.LC10(%rip), %rsi
	movq	%r15, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	je	.L123
	leaq	.LC11(%rip), %rsi
	movq	%r15, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	je	.L123
	leaq	.LC12(%rip), %rsi
	movq	%r15, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L124
.L123:
	movl	$1, 32(%rsp)
.L124:
	leaq	.LC13(%rip), %rsi
	movq	%r15, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	je	.L142
	leaq	.LC14(%rip), %rsi
	movq	%r15, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	je	.L143
	leaq	.LC15(%rip), %rsi
	movq	%r15, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	je	.L144
	leaq	.LC10(%rip), %rsi
	movq	%r15, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	je	.L145
	leaq	.LC16(%rip), %rsi
	movq	%r15, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	je	.L146
	leaq	.LC17(%rip), %rsi
	movq	%r15, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	je	.L147
	leaq	.LC11(%rip), %rsi
	movq	%r15, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	je	.L148
	leaq	.LC18(%rip), %rsi
	movq	%r15, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	je	.L149
	leaq	.LC12(%rip), %rsi
	movq	%r15, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L134
	leaq	16(%rsp), %rax
	pushq	%rax
	.cfi_def_cfa_offset 168
	pushq	%r14
	.cfi_def_cfa_offset 176
	movl	28(%rsp), %r9d
	movl	%r13d, %r8d
	movl	$0, %ecx
	leaq	cleanup(%rip), %rdx
	leaq	loop_bcopy(%rip), %rsi
	leaq	init_loop(%rip), %rdi
	call	benchmp@PLT
	addq	$16, %rsp
	.cfi_def_cfa_offset 160
	jmp	.L126
.L141:
	leaq	.LC8(%rip), %rdx
	movq	%rbx, %rsi
	movl	%ebp, %edi
	call	lmbench_usage@PLT
	jmp	.L122
.L142:
	leaq	16(%rsp), %rax
	pushq	%rax
	.cfi_def_cfa_offset 168
	pushq	%r14
	.cfi_def_cfa_offset 176
	movl	28(%rsp), %r9d
	movl	%r13d, %r8d
	movl	$0, %ecx
	leaq	cleanup(%rip), %rdx
	leaq	rd(%rip), %rsi
	leaq	init_loop(%rip), %rdi
	call	benchmp@PLT
	addq	$16, %rsp
	.cfi_def_cfa_offset 160
.L126:
	movq	16(%rsp), %rbx
	call	get_n@PLT
	movslq	%r13d, %r13
	imulq	%rax, %r13
	call	usecs_spent@PLT
	movq	%rax, %rdi
	movq	%rbx, %xmm0
	movq	%r13, %rdx
	movq	%r12, %rsi
	call	adjusted_bandwidth
	movq	88(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L150
	movl	$0, %eax
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
.L143:
	.cfi_restore_state
	leaq	16(%rsp), %rax
	pushq	%rax
	.cfi_def_cfa_offset 168
	pushq	%r14
	.cfi_def_cfa_offset 176
	movl	28(%rsp), %r9d
	movl	%r13d, %r8d
	movl	$0, %ecx
	leaq	cleanup(%rip), %rdx
	leaq	wr(%rip), %rsi
	leaq	init_loop(%rip), %rdi
	call	benchmp@PLT
	addq	$16, %rsp
	.cfi_def_cfa_offset 160
	jmp	.L126
.L144:
	leaq	16(%rsp), %rax
	pushq	%rax
	.cfi_def_cfa_offset 168
	pushq	%r14
	.cfi_def_cfa_offset 176
	movl	28(%rsp), %r9d
	movl	%r13d, %r8d
	movl	$0, %ecx
	leaq	cleanup(%rip), %rdx
	leaq	rdwr(%rip), %rsi
	leaq	init_loop(%rip), %rdi
	call	benchmp@PLT
	addq	$16, %rsp
	.cfi_def_cfa_offset 160
	jmp	.L126
.L145:
	leaq	16(%rsp), %rax
	pushq	%rax
	.cfi_def_cfa_offset 168
	pushq	%r14
	.cfi_def_cfa_offset 176
	movl	28(%rsp), %r9d
	movl	%r13d, %r8d
	movl	$0, %ecx
	leaq	cleanup(%rip), %rdx
	leaq	mcp(%rip), %rsi
	leaq	init_loop(%rip), %rdi
	call	benchmp@PLT
	addq	$16, %rsp
	.cfi_def_cfa_offset 160
	jmp	.L126
.L146:
	leaq	16(%rsp), %rax
	pushq	%rax
	.cfi_def_cfa_offset 168
	pushq	%r14
	.cfi_def_cfa_offset 176
	movl	28(%rsp), %r9d
	movl	%r13d, %r8d
	movl	$0, %ecx
	leaq	cleanup(%rip), %rdx
	leaq	frd(%rip), %rsi
	leaq	init_loop(%rip), %rdi
	call	benchmp@PLT
	addq	$16, %rsp
	.cfi_def_cfa_offset 160
	jmp	.L126
.L147:
	leaq	16(%rsp), %rax
	pushq	%rax
	.cfi_def_cfa_offset 168
	pushq	%r14
	.cfi_def_cfa_offset 176
	movl	28(%rsp), %r9d
	movl	%r13d, %r8d
	movl	$0, %ecx
	leaq	cleanup(%rip), %rdx
	leaq	fwr(%rip), %rsi
	leaq	init_loop(%rip), %rdi
	call	benchmp@PLT
	addq	$16, %rsp
	.cfi_def_cfa_offset 160
	jmp	.L126
.L148:
	leaq	16(%rsp), %rax
	pushq	%rax
	.cfi_def_cfa_offset 168
	pushq	%r14
	.cfi_def_cfa_offset 176
	movl	28(%rsp), %r9d
	movl	%r13d, %r8d
	movl	$0, %ecx
	leaq	cleanup(%rip), %rdx
	leaq	fcp(%rip), %rsi
	leaq	init_loop(%rip), %rdi
	call	benchmp@PLT
	addq	$16, %rsp
	.cfi_def_cfa_offset 160
	jmp	.L126
.L149:
	leaq	16(%rsp), %rax
	pushq	%rax
	.cfi_def_cfa_offset 168
	pushq	%r14
	.cfi_def_cfa_offset 176
	movl	28(%rsp), %r9d
	movl	%r13d, %r8d
	movl	$0, %ecx
	leaq	cleanup(%rip), %rdx
	leaq	loop_bzero(%rip), %rsi
	leaq	init_loop(%rip), %rdi
	call	benchmp@PLT
	addq	$16, %rsp
	.cfi_def_cfa_offset 160
	jmp	.L126
.L134:
	leaq	.LC8(%rip), %rdx
	movq	%rbx, %rsi
	movl	%ebp, %edi
	call	lmbench_usage@PLT
	jmp	.L126
.L150:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE72:
	.size	main, .-main
	.globl	id
	.section	.rodata.str1.1
.LC19:
	.string	"$Id$"
	.section	.data.rel.local,"aw"
	.align 8
	.type	id, @object
	.size	id, 8
id:
	.quad	.LC19
	.section	.rodata.cst8,"aM",@progbits,8
	.align 8
.LC1:
	.long	0
	.long	1093567616
	.align 8
.LC3:
	.long	0
	.long	1072693248
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
