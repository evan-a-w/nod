	.file	"lmdd.c"
	.text
	.globl	id
	.section	.rodata
	.align 8
.LC0:
	.string	"$Id: lmdd.c,v 1.23 1997/12/01 23:47:59 lm Exp $\n"
	.section	.data.rel.local,"aw"
	.align 8
	.type	id, @object
	.size	id, 8
id:
	.quad	.LC0
	.globl	awrite
	.bss
	.align 4
	.type	awrite, @object
	.size	awrite, 4
awrite:
	.zero	4
	.globl	poff
	.align 4
	.type	poff, @object
	.size	poff, 4
poff:
	.zero	4
	.globl	out
	.align 4
	.type	out, @object
	.size	out, 4
out:
	.zero	4
	.globl	Print
	.align 4
	.type	Print, @object
	.size	Print, 4
Print:
	.zero	4
	.globl	Fsync
	.align 4
	.type	Fsync, @object
	.size	Fsync, 4
Fsync:
	.zero	4
	.globl	Sync
	.align 4
	.type	Sync, @object
	.size	Sync, 4
Sync:
	.zero	4
	.globl	Flush
	.align 4
	.type	Flush, @object
	.size	Flush, 4
Flush:
	.zero	4
	.globl	Bsize
	.align 4
	.type	Bsize, @object
	.size	Bsize, 4
Bsize:
	.zero	4
	.globl	ru
	.align 4
	.type	ru, @object
	.size	ru, 4
ru:
	.zero	4
	.globl	Start
	.align 8
	.type	Start, @object
	.size	Start, 8
Start:
	.zero	8
	.globl	End
	.align 8
	.type	End, @object
	.size	End, 8
End:
	.zero	8
	.globl	Rand
	.align 8
	.type	Rand, @object
	.size	Rand, 8
Rand:
	.zero	8
	.globl	int_count
	.align 8
	.type	int_count, @object
	.size	int_count, 8
int_count:
	.zero	8
	.globl	hash
	.align 4
	.type	hash, @object
	.size	hash, 4
hash:
	.zero	4
	.globl	Realtime
	.align 4
	.type	Realtime, @object
	.size	Realtime, 4
Realtime:
	.zero	4
	.globl	Notrunc
	.align 4
	.type	Notrunc, @object
	.size	Notrunc, 4
Notrunc:
	.zero	4
	.globl	Rtmax
	.align 4
	.type	Rtmax, @object
	.size	Rtmax, 4
Rtmax:
	.zero	4
	.globl	Rtmin
	.align 4
	.type	Rtmin, @object
	.size	Rtmin, 4
Rtmin:
	.zero	4
	.globl	Wtmax
	.align 4
	.type	Wtmax, @object
	.size	Wtmax, 4
Wtmax:
	.zero	4
	.globl	Wtmin
	.align 4
	.type	Wtmin, @object
	.size	Wtmin, 4
Wtmin:
	.zero	4
	.globl	rthist
	.align 32
	.type	rthist, @object
	.size	rthist, 48
rthist:
	.zero	48
	.globl	wthist
	.align 32
	.type	wthist, @object
	.size	wthist, 48
wthist:
	.zero	48
	.globl	Label
	.align 8
	.type	Label, @object
	.size	Label, 8
Label:
	.zero	8
	.globl	norepeat
	.align 8
	.type	norepeat, @object
	.size	norepeat, 8
norepeat:
	.zero	8
	.globl	norepeats
	.data
	.align 4
	.type	norepeats, @object
	.size	norepeats, 4
norepeats:
	.long	-1
	.globl	cmds
	.section	.rodata
.LC1:
	.string	"bs"
.LC2:
	.string	"bufs"
.LC3:
	.string	"count"
.LC4:
	.string	"flush"
.LC5:
	.string	"fork"
.LC6:
	.string	"fsync"
.LC7:
	.string	"if"
.LC8:
	.string	"ipat"
.LC9:
	.string	"label"
.LC10:
	.string	"mismatch"
.LC11:
	.string	"move"
.LC12:
	.string	"of"
.LC13:
	.string	"opat"
.LC14:
	.string	"print"
.LC15:
	.string	"rand"
.LC16:
	.string	"poff"
.LC17:
	.string	"rusage"
.LC18:
	.string	"skip"
.LC19:
	.string	"sync"
.LC20:
	.string	"touch"
.LC21:
	.string	"usleep"
.LC22:
	.string	"hash"
.LC23:
	.string	"append"
.LC24:
	.string	"rtmax"
.LC25:
	.string	"wtmax"
.LC26:
	.string	"rtmin"
.LC27:
	.string	"wtmin"
.LC28:
	.string	"realtime"
.LC29:
	.string	"notrunc"
.LC30:
	.string	"end"
.LC31:
	.string	"start"
.LC32:
	.string	"time"
.LC33:
	.string	"srand"
.LC34:
	.string	"padin"
.LC35:
	.string	"norepeat"
.LC36:
	.string	"timeopen"
.LC37:
	.string	"nocreate"
.LC38:
	.string	"osync"
	.section	.data.rel.local
	.align 32
	.type	cmds, @object
	.size	cmds, 312
cmds:
	.quad	.LC1
	.quad	.LC2
	.quad	.LC3
	.quad	.LC4
	.quad	.LC5
	.quad	.LC6
	.quad	.LC7
	.quad	.LC8
	.quad	.LC9
	.quad	.LC10
	.quad	.LC11
	.quad	.LC12
	.quad	.LC13
	.quad	.LC14
	.quad	.LC15
	.quad	.LC16
	.quad	.LC17
	.quad	.LC18
	.quad	.LC19
	.quad	.LC20
	.quad	.LC21
	.quad	.LC22
	.quad	.LC23
	.quad	.LC24
	.quad	.LC25
	.quad	.LC26
	.quad	.LC27
	.quad	.LC28
	.quad	.LC29
	.quad	.LC30
	.quad	.LC31
	.quad	.LC32
	.quad	.LC33
	.quad	.LC34
	.quad	.LC35
	.quad	.LC36
	.quad	.LC37
	.quad	.LC38
	.quad	0
	.section	.rodata
.LC39:
	.string	"mismatch="
.LC40:
	.string	"ipat="
.LC41:
	.string	"opat="
.LC42:
	.string	"bs="
.LC43:
	.string	"usleep="
.LC44:
	.string	"fork="
.LC45:
	.string	"fsync="
.LC46:
	.string	"sync="
.LC47:
	.string	"rand="
.LC48:
	.string	"start="
.LC49:
	.string	"end="
.LC50:
	.string	"time="
.LC51:
	.string	"srand="
.LC52:
	.string	"poff="
.LC53:
	.string	"print="
.LC54:
	.string	"bufs="
.LC55:
	.string	"realtime="
.LC56:
	.string	"rtmax="
.LC57:
	.string	"rtmin="
.LC58:
	.string	"wtmax="
.LC59:
	.string	"wtmin="
	.align 8
.LC60:
	.string	"Need a max to go with that min.\n"
	.align 8
.LC61:
	.string	"min has to be less than max, R=%d,%d W=%d,%d\n"
.LC62:
	.string	"timeopen="
.LC63:
	.string	"padin="
.LC64:
	.string	"Too many bufs"
.LC65:
	.string	"rusage="
.LC66:
	.string	"touch="
.LC67:
	.string	"hash="
.LC68:
	.string	"label="
.LC69:
	.string	"count="
.LC70:
	.string	"move="
.LC71:
	.string	"flush="
.LC72:
	.string	"skip="
.LC73:
	.string	"norepeat="
	.align 8
.LC74:
	.string	"Block size 0x%x must be word aligned\n"
	.align 8
.LC75:
	.string	"Block size must be at least 4.\n"
.LC76:
	.string	"VALLOC"
.LC77:
	.string	"if="
.LC78:
	.string	"of="
	.align 8
.LC79:
	.string	"I think you wanted wtmax, not rtmax\n"
	.align 8
.LC80:
	.string	"I think you wanted rtmax, not wtmax\n"
.LC81:
	.string	"%s "
	.align 8
.LC84:
	.string	"READ: %.02f milliseconds offset %s\n"
.LC85:
	.string	"read"
.LC86:
	.string	"off=%u want=%x got=%x\n"
.LC87:
	.string	"write"
.LC88:
	.string	"write: wanted=%d got=%d\n"
	.align 8
.LC89:
	.string	"WRITE: %.02f milliseconds offset %s\n"
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
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$296, %rsp
	.cfi_offset 13, -24
	.cfi_offset 12, -32
	.cfi_offset 3, -40
	movl	%edi, -308(%rbp)
	movq	%rsi, -320(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -40(%rbp)
	xorl	%eax, %eax
	movl	$0, -300(%rbp)
	movq	$0, -184(%rbp)
	movl	$0, -280(%rbp)
	movl	$1, -288(%rbp)
	jmp	.L2
.L3:
	movl	-288(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-320(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	chkarg
	addl	$1, -288(%rbp)
.L2:
	movl	-288(%rbp), %eax
	cmpl	-308(%rbp), %eax
	jl	.L3
	leaq	done(%rip), %rax
	movq	%rax, %rsi
	movl	$2, %edi
	call	signal@PLT
	leaq	done(%rip), %rax
	movq	%rax, %rsi
	movl	$14, %edi
	call	signal@PLT
	movq	-320(%rbp), %rdx
	movl	-308(%rbp), %eax
	movl	%eax, %esi
	leaq	.LC39(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	getarg
	movl	%eax, -260(%rbp)
	movl	-260(%rbp), %eax
	movl	%eax, -296(%rbp)
	movq	-320(%rbp), %rdx
	movl	-308(%rbp), %eax
	movl	%eax, %esi
	leaq	.LC40(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	getarg
	movl	%eax, -256(%rbp)
	movq	-320(%rbp), %rdx
	movl	-308(%rbp), %eax
	movl	%eax, %esi
	leaq	.LC41(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	getarg
	movl	%eax, -252(%rbp)
	movq	-320(%rbp), %rdx
	movl	-308(%rbp), %eax
	movl	%eax, %esi
	leaq	.LC42(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	getarg
	movl	%eax, Bsize(%rip)
	movl	Bsize(%rip), %eax
	testl	%eax, %eax
	jns	.L4
	movl	$8192, Bsize(%rip)
.L4:
	movq	-320(%rbp), %rdx
	movl	-308(%rbp), %eax
	movl	%eax, %esi
	leaq	.LC43(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	getarg
	movl	%eax, -248(%rbp)
	movq	-320(%rbp), %rdx
	movl	-308(%rbp), %eax
	movl	%eax, %esi
	leaq	.LC44(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	getarg
	movl	%eax, -244(%rbp)
	movq	-320(%rbp), %rdx
	movl	-308(%rbp), %eax
	movl	%eax, %esi
	leaq	.LC45(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	getarg
	movl	%eax, Fsync(%rip)
	movq	-320(%rbp), %rdx
	movl	-308(%rbp), %eax
	movl	%eax, %esi
	leaq	.LC46(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	getarg
	movl	%eax, Sync(%rip)
	movq	-320(%rbp), %rdx
	movl	-308(%rbp), %eax
	movl	%eax, %esi
	leaq	.LC47(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	getarg
	movq	%rax, Rand(%rip)
	movq	-320(%rbp), %rdx
	movl	-308(%rbp), %eax
	movl	%eax, %esi
	leaq	.LC48(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	getarg
	movq	%rax, Start(%rip)
	movq	-320(%rbp), %rdx
	movl	-308(%rbp), %eax
	movl	%eax, %esi
	leaq	.LC49(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	getarg
	movq	%rax, End(%rip)
	movq	-320(%rbp), %rdx
	movl	-308(%rbp), %eax
	movl	%eax, %esi
	leaq	.LC50(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	getarg
	movl	%eax, -240(%rbp)
	movq	End(%rip), %rax
	cmpq	$-1, %rax
	je	.L5
	movq	Rand(%rip), %rax
	cmpq	$-1, %rax
	je	.L5
	movq	End(%rip), %rdx
	movq	Rand(%rip), %rax
	cmpq	%rax, %rdx
	jbe	.L5
	movq	Rand(%rip), %rax
	movq	%rax, End(%rip)
.L5:
	movq	-320(%rbp), %rdx
	movl	-308(%rbp), %eax
	movl	%eax, %esi
	leaq	.LC51(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	getarg
	cmpq	$-1, %rax
	je	.L6
	movq	-320(%rbp), %rdx
	movl	-308(%rbp), %eax
	movl	%eax, %esi
	leaq	.LC51(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	getarg
	movq	%rax, %rdi
	call	srand48@PLT
.L6:
	movq	-320(%rbp), %rdx
	movl	-308(%rbp), %eax
	movl	%eax, %esi
	leaq	.LC52(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	getarg
	cmpq	$-1, %rax
	setne	%al
	movzbl	%al, %eax
	movl	%eax, poff(%rip)
	movq	-320(%rbp), %rdx
	movl	-308(%rbp), %eax
	movl	%eax, %esi
	leaq	.LC53(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	getarg
	movl	%eax, Print(%rip)
	movq	-320(%rbp), %rdx
	movl	-308(%rbp), %eax
	movl	%eax, %esi
	leaq	.LC54(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	getarg
	movl	%eax, -304(%rbp)
	movq	-320(%rbp), %rdx
	movl	-308(%rbp), %eax
	movl	%eax, %esi
	leaq	.LC55(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	getarg
	movl	%eax, Realtime(%rip)
	movq	-320(%rbp), %rdx
	movl	-308(%rbp), %eax
	movl	%eax, %esi
	leaq	.LC56(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	getarg
	movl	%eax, Rtmax(%rip)
	movl	Rtmax(%rip), %eax
	cmpl	$-1, %eax
	je	.L7
	movl	Rtmax(%rip), %eax
	cmpl	$9, %eax
	jg	.L7
	movl	$10, Rtmax(%rip)
.L7:
	movq	-320(%rbp), %rdx
	movl	-308(%rbp), %eax
	movl	%eax, %esi
	leaq	.LC57(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	getarg
	movl	%eax, Rtmin(%rip)
	movl	Rtmax(%rip), %eax
	cmpl	$-1, %eax
	je	.L8
	movl	Rtmin(%rip), %eax
	cmpl	$-1, %eax
	jne	.L8
	movl	$0, Rtmin(%rip)
.L8:
	movq	-320(%rbp), %rdx
	movl	-308(%rbp), %eax
	movl	%eax, %esi
	leaq	.LC58(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	getarg
	movl	%eax, Wtmax(%rip)
	movl	Wtmax(%rip), %eax
	cmpl	$-1, %eax
	je	.L9
	movl	Wtmax(%rip), %eax
	cmpl	$9, %eax
	jg	.L9
	movl	$10, Wtmax(%rip)
.L9:
	movq	-320(%rbp), %rdx
	movl	-308(%rbp), %eax
	movl	%eax, %esi
	leaq	.LC59(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	getarg
	movl	%eax, Wtmin(%rip)
	movl	Wtmax(%rip), %eax
	cmpl	$-1, %eax
	je	.L10
	movl	Wtmin(%rip), %eax
	cmpl	$-1, %eax
	jne	.L10
	movl	$0, Wtmin(%rip)
.L10:
	movl	Rtmin(%rip), %eax
	testl	%eax, %eax
	je	.L11
	movl	Rtmax(%rip), %eax
	testl	%eax, %eax
	je	.L12
.L11:
	movl	Wtmin(%rip), %eax
	testl	%eax, %eax
	je	.L13
	movl	Wtmax(%rip), %eax
	testl	%eax, %eax
	jne	.L13
.L12:
	movq	stderr(%rip), %rax
	movq	%rax, %rcx
	movl	$32, %edx
	movl	$1, %esi
	leaq	.LC60(%rip), %rax
	movq	%rax, %rdi
	call	fwrite@PLT
	movl	$1, %edi
	call	exit@PLT
.L13:
	movl	Rtmin(%rip), %edx
	movl	Rtmax(%rip), %eax
	cmpl	%eax, %edx
	jg	.L14
	movl	Wtmin(%rip), %edx
	movl	Wtmax(%rip), %eax
	cmpl	%eax, %edx
	jle	.L15
.L14:
	movl	Wtmin(%rip), %edi
	movl	Wtmax(%rip), %esi
	movl	Rtmin(%rip), %ecx
	movl	Rtmax(%rip), %edx
	movq	stderr(%rip), %rax
	movl	%edi, %r9d
	movl	%esi, %r8d
	leaq	.LC61(%rip), %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf@PLT
	movl	$1, %edi
	call	exit@PLT
.L15:
	movq	-320(%rbp), %rdx
	movl	-308(%rbp), %eax
	movl	%eax, %esi
	leaq	.LC62(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	getarg
	movl	%eax, -236(%rbp)
	movq	-320(%rbp), %rdx
	movl	-308(%rbp), %eax
	movl	%eax, %esi
	leaq	.LC63(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	getarg
	movl	%eax, -284(%rbp)
	cmpl	$-1, -284(%rbp)
	jne	.L16
	movl	$0, -284(%rbp)
.L16:
	cmpl	$-1, -304(%rbp)
	jne	.L17
	movl	$1, -304(%rbp)
.L17:
	cmpl	$10, -304(%rbp)
	jle	.L18
	leaq	.LC64(%rip), %rax
	movq	%rax, %rdi
	call	puts@PLT
	movl	$1, %edi
	call	exit@PLT
.L18:
	movq	-320(%rbp), %rdx
	movl	-308(%rbp), %eax
	movl	%eax, %esi
	leaq	.LC65(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	getarg
	movl	%eax, ru(%rip)
	movq	-320(%rbp), %rdx
	movl	-308(%rbp), %eax
	movl	%eax, %esi
	leaq	.LC66(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	getarg
	cmpq	$-1, %rax
	setne	%al
	movzbl	%al, %eax
	movl	%eax, -232(%rbp)
	movq	-320(%rbp), %rdx
	movl	-308(%rbp), %eax
	movl	%eax, %esi
	leaq	.LC67(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	getarg
	cmpq	$-1, %rax
	setne	%al
	movzbl	%al, %eax
	movl	%eax, hash(%rip)
	movq	-320(%rbp), %rdx
	movl	-308(%rbp), %eax
	movl	%eax, %esi
	leaq	.LC68(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	getarg
	movq	%rax, Label(%rip)
	movq	-320(%rbp), %rdx
	movl	-308(%rbp), %eax
	movl	%eax, %esi
	leaq	.LC69(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	getarg
	movq	%rax, -192(%rbp)
	movq	-320(%rbp), %rdx
	movl	-308(%rbp), %eax
	movl	%eax, %esi
	leaq	.LC70(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	getarg
	movq	%rax, -200(%rbp)
	cmpq	$-1, -200(%rbp)
	je	.L19
	movl	Bsize(%rip), %eax
	movslq	%eax, %rbx
	movq	-200(%rbp), %rax
	movl	$0, %edx
	divq	%rbx
	movq	%rax, -192(%rbp)
.L19:
	movq	Rand(%rip), %rax
	cmpq	$-1, %rax
	je	.L20
	movq	Rand(%rip), %rax
	movl	Bsize(%rip), %edx
	movslq	%edx, %rdx
	subq	%rdx, %rax
	movq	%rax, -200(%rbp)
	movl	Bsize(%rip), %eax
	subl	$1, %eax
	movslq	%eax, %rdx
	movq	-200(%rbp), %rax
	addq	%rax, %rdx
	movl	Bsize(%rip), %eax
	negl	%eax
	cltq
	andq	%rdx, %rax
	movq	%rax, -200(%rbp)
.L20:
	movq	-320(%rbp), %rdx
	movl	-308(%rbp), %eax
	movl	%eax, %esi
	leaq	.LC71(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	getarg
	movl	%eax, Flush(%rip)
	cmpq	$-1, -192(%rbp)
	jne	.L21
	movl	$0, -292(%rbp)
	jmp	.L22
.L21:
	movl	$1, -292(%rbp)
.L22:
	movq	$0, int_count(%rip)
	movq	-320(%rbp), %rdx
	movl	-308(%rbp), %eax
	movl	%eax, %esi
	leaq	.LC72(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	getarg
	movq	%rax, -176(%rbp)
	movq	-320(%rbp), %rdx
	movl	-308(%rbp), %eax
	movl	%eax, %esi
	leaq	.LC73(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	getarg
	cmpq	$-1, %rax
	je	.L23
	cmpl	$0, -292(%rbp)
	je	.L24
	movq	-192(%rbp), %rax
	movl	$8, %esi
	movq	%rax, %rdi
	call	calloc@PLT
	movq	%rax, norepeat(%rip)
	jmp	.L23
.L24:
	movl	$8, %esi
	movl	$10240, %edi
	call	calloc@PLT
	movq	%rax, norepeat(%rip)
.L23:
	cmpl	$-1, -256(%rbp)
	jne	.L25
	cmpl	$-1, -252(%rbp)
	je	.L26
.L25:
	movl	Bsize(%rip), %eax
	andl	$3, %eax
	testl	%eax, %eax
	je	.L26
	movl	Bsize(%rip), %edx
	movq	stderr(%rip), %rax
	leaq	.LC74(%rip), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf@PLT
	movl	$1, %edi
	call	exit@PLT
.L26:
	movl	Bsize(%rip), %eax
	sarl	$2, %eax
	testl	%eax, %eax
	jne	.L27
	movq	stderr(%rip), %rax
	movq	%rax, %rcx
	movl	$31, %edx
	movl	$1, %esi
	leaq	.LC75(%rip), %rax
	movq	%rax, %rdi
	call	fwrite@PLT
	movl	$1, %edi
	call	exit@PLT
.L27:
	movl	$0, -288(%rbp)
	jmp	.L28
.L30:
	movl	Bsize(%rip), %eax
	movl	%eax, %eax
	movq	%rax, %rdi
	call	valloc@PLT
	movq	%rax, %rdx
	movl	-288(%rbp), %eax
	cltq
	movq	%rdx, -128(%rbp,%rax,8)
	movl	-288(%rbp), %eax
	cltq
	movq	-128(%rbp,%rax,8), %rax
	testq	%rax, %rax
	jne	.L29
	leaq	.LC76(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
.L29:
	movl	Bsize(%rip), %eax
	movslq	%eax, %rdx
	movl	-288(%rbp), %eax
	cltq
	movq	-128(%rbp,%rax,8), %rax
	movl	$0, %esi
	movq	%rax, %rdi
	call	memset@PLT
	addl	$1, -288(%rbp)
.L28:
	movl	-288(%rbp), %eax
	cmpl	-304(%rbp), %eax
	jl	.L30
	cmpl	$-1, -240(%rbp)
	je	.L31
	movl	-240(%rbp), %eax
	movl	%eax, %edi
	call	alarm@PLT
.L31:
	cmpl	$-1, -236(%rbp)
	je	.L32
	movl	$0, %edi
	call	start@PLT
.L32:
	movq	-320(%rbp), %rdx
	movl	-308(%rbp), %eax
	movl	%eax, %esi
	leaq	.LC77(%rip), %rax
	movq	%rax, %rdi
	call	getfile
	movl	%eax, -228(%rbp)
	movq	-320(%rbp), %rdx
	movl	-308(%rbp), %eax
	movl	%eax, %esi
	leaq	.LC78(%rip), %rax
	movq	%rax, %rdi
	call	getfile
	movl	%eax, out(%rip)
	cmpl	$-1, -236(%rbp)
	jne	.L33
	movl	$0, %edi
	call	start@PLT
.L33:
	movl	Rtmax(%rip), %eax
	cmpl	$-1, %eax
	je	.L34
	cmpl	$0, -228(%rbp)
	jns	.L34
	movq	stderr(%rip), %rax
	movq	%rax, %rcx
	movl	$36, %edx
	movl	$1, %esi
	leaq	.LC79(%rip), %rax
	movq	%rax, %rdi
	call	fwrite@PLT
	movl	$1, %edi
	call	exit@PLT
.L34:
	movl	Wtmax(%rip), %eax
	cmpl	$-1, %eax
	je	.L35
	movl	out(%rip), %eax
	testl	%eax, %eax
	jns	.L35
	movq	stderr(%rip), %rax
	movq	%rax, %rcx
	movl	$36, %edx
	movl	$1, %esi
	leaq	.LC80(%rip), %rax
	movq	%rax, %rdi
	call	fwrite@PLT
	movl	$1, %edi
	call	exit@PLT
.L35:
	cmpq	$-1, -176(%rbp)
	je	.L114
	movq	-176(%rbp), %rax
	movq	%rax, -184(%rbp)
	movl	Bsize(%rip), %eax
	cltq
	movq	-184(%rbp), %rdx
	imulq	%rdx, %rax
	movq	%rax, -184(%rbp)
	cmpl	$0, -228(%rbp)
	js	.L37
	movq	-184(%rbp), %rcx
	movl	-228(%rbp), %eax
	movl	$0, %edx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	seekto@PLT
.L37:
	movl	out(%rip), %eax
	testl	%eax, %eax
	js	.L38
	movq	-184(%rbp), %rcx
	movl	out(%rip), %eax
	movl	$0, %edx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	seekto@PLT
.L38:
	movl	poff(%rip), %eax
	testl	%eax, %eax
	je	.L114
	movq	-184(%rbp), %rax
	movq	%rax, %rdi
	call	p64sz@PLT
	movq	%rax, %rdx
	movq	stderr(%rip), %rax
	leaq	.LC81(%rip), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf@PLT
.L114:
	cmpl	$0, -292(%rbp)
	je	.L39
	movq	-192(%rbp), %rax
	leaq	-1(%rax), %rdx
	movq	%rdx, -192(%rbp)
	testq	%rax, %rax
	jne	.L39
	movl	$0, %eax
	call	done
.L39:
	movq	End(%rip), %rax
	cmpq	$-1, %rax
	je	.L40
	movq	start.0(%rip), %rax
	testq	%rax, %rax
	jne	.L41
	movq	Rand(%rip), %rax
	movq	End(%rip), %rdx
	subq	%rdx, %rax
	jmp	.L42
.L41:
	movl	$0, %eax
.L42:
	movq	%rax, start.0(%rip)
.L49:
	call	drand48@PLT
	movapd	%xmm0, %xmm1
	movq	End(%rip), %rax
	testq	%rax, %rax
	js	.L43
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L44
.L43:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L44:
	mulsd	%xmm1, %xmm0
	comisd	.LC82(%rip), %xmm0
	jnb	.L45
	cvttsd2siq	%xmm0, %rax
	movq	%rax, -184(%rbp)
	jmp	.L46
.L45:
	movsd	.LC82(%rip), %xmm1
	subsd	%xmm1, %xmm0
	cvttsd2siq	%xmm0, %rax
	movq	%rax, -184(%rbp)
	movabsq	$-9223372036854775808, %rax
	xorq	%rax, -184(%rbp)
.L46:
	movq	-184(%rbp), %rax
	movq	%rax, -184(%rbp)
	movl	Bsize(%rip), %eax
	subl	$1, %eax
	movslq	%eax, %rdx
	movq	-184(%rbp), %rax
	addq	%rax, %rdx
	movl	Bsize(%rip), %eax
	negl	%eax
	cltq
	andq	%rdx, %rax
	movq	%rax, -184(%rbp)
	movq	start.0(%rip), %rax
	addq	%rax, -184(%rbp)
	movq	Start(%rip), %rax
	cmpq	$-1, %rax
	je	.L47
	movq	Start(%rip), %rax
	addq	%rax, -184(%rbp)
.L47:
	movq	norepeat(%rip), %rax
	testq	%rax, %rax
	je	.L48
	movq	-184(%rbp), %rax
	movq	%rax, %rdi
	call	been_there
	testl	%eax, %eax
	jne	.L49
.L48:
	movq	norepeat(%rip), %rax
	testq	%rax, %rax
	je	.L50
	movq	norepeat(%rip), %rcx
	movl	norepeats(%rip), %eax
	leal	1(%rax), %edx
	movl	%edx, norepeats(%rip)
	cltq
	salq	$3, %rax
	leaq	(%rcx,%rax), %rdx
	movq	-184(%rbp), %rax
	movq	%rax, (%rdx)
	cmpl	$0, -292(%rbp)
	jne	.L50
	movl	norepeats(%rip), %eax
	cmpl	$10240, %eax
	jne	.L50
	movl	$0, norepeats(%rip)
.L50:
	cmpl	$0, -228(%rbp)
	js	.L51
	movq	-184(%rbp), %rcx
	movl	-228(%rbp), %eax
	movl	$0, %edx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	seekto@PLT
.L51:
	movl	out(%rip), %eax
	testl	%eax, %eax
	js	.L52
	movq	-184(%rbp), %rcx
	movl	out(%rip), %eax
	movl	$0, %edx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	seekto@PLT
	jmp	.L52
.L40:
	movq	Rand(%rip), %rax
	cmpq	$-1, %rax
	je	.L52
.L59:
	call	drand48@PLT
	movapd	%xmm0, %xmm1
	movl	Bsize(%rip), %eax
	movslq	%eax, %rdx
	movq	-200(%rbp), %rax
	subq	%rdx, %rax
	testq	%rax, %rax
	js	.L53
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L54
.L53:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L54:
	mulsd	%xmm1, %xmm0
	comisd	.LC82(%rip), %xmm0
	jnb	.L55
	cvttsd2siq	%xmm0, %rax
	movq	%rax, -184(%rbp)
	jmp	.L56
.L55:
	movsd	.LC82(%rip), %xmm1
	subsd	%xmm1, %xmm0
	cvttsd2siq	%xmm0, %rax
	movq	%rax, -184(%rbp)
	movabsq	$-9223372036854775808, %rax
	xorq	%rax, -184(%rbp)
.L56:
	movq	-184(%rbp), %rax
	movq	%rax, -184(%rbp)
	movq	Start(%rip), %rax
	cmpq	$-1, %rax
	je	.L57
	movq	Start(%rip), %rax
	addq	%rax, -184(%rbp)
.L57:
	movl	Bsize(%rip), %eax
	subl	$1, %eax
	movslq	%eax, %rdx
	movq	-184(%rbp), %rax
	addq	%rax, %rdx
	movl	Bsize(%rip), %eax
	negl	%eax
	cltq
	andq	%rdx, %rax
	movq	%rax, -184(%rbp)
	movq	norepeat(%rip), %rax
	testq	%rax, %rax
	je	.L58
	movq	-184(%rbp), %rax
	movq	%rax, %rdi
	call	been_there
	testl	%eax, %eax
	jne	.L59
.L58:
	movq	norepeat(%rip), %rax
	testq	%rax, %rax
	je	.L60
	movq	norepeat(%rip), %rcx
	movl	norepeats(%rip), %eax
	leal	1(%rax), %edx
	movl	%edx, norepeats(%rip)
	cltq
	salq	$3, %rax
	leaq	(%rcx,%rax), %rdx
	movq	-184(%rbp), %rax
	movq	%rax, (%rdx)
.L60:
	cmpl	$0, -292(%rbp)
	jne	.L61
	movl	norepeats(%rip), %eax
	cmpl	$10240, %eax
	jne	.L61
	movl	$0, norepeats(%rip)
.L61:
	cmpl	$0, -228(%rbp)
	js	.L62
	movq	-184(%rbp), %rcx
	movl	-228(%rbp), %eax
	movl	$0, %edx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	seekto@PLT
.L62:
	movl	out(%rip), %eax
	testl	%eax, %eax
	js	.L52
	movq	-184(%rbp), %rcx
	movl	out(%rip), %eax
	movl	$0, %edx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	seekto@PLT
.L52:
	movl	poff(%rip), %eax
	testl	%eax, %eax
	je	.L63
	movq	-184(%rbp), %rax
	movq	%rax, %rdi
	call	p64sz@PLT
	movq	%rax, %rdx
	movq	stderr(%rip), %rax
	leaq	.LC81(%rip), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf@PLT
.L63:
	movl	-300(%rbp), %eax
	cltq
	movq	-128(%rbp,%rax,8), %rax
	movq	%rax, -168(%rbp)
	addl	$1, -300(%rbp)
	movl	-300(%rbp), %eax
	cmpl	-304(%rbp), %eax
	jne	.L64
	movl	$0, -300(%rbp)
.L64:
	cmpl	$0, -228(%rbp)
	js	.L65
	movl	Rtmax(%rip), %eax
	cmpl	$-1, %eax
	jne	.L66
	movl	Rtmin(%rip), %eax
	cmpl	$-1, %eax
	je	.L67
.L66:
	leaq	-160(%rbp), %rax
	movq	%rax, %rdi
	call	start@PLT
.L67:
	movl	Bsize(%rip), %eax
	movslq	%eax, %rdx
	movq	-168(%rbp), %rcx
	movl	-228(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	read@PLT
	movl	%eax, %ebx
	cmpl	$0, -284(%rbp)
	je	.L68
	movl	$0, -284(%rbp)
	addq	$1, -192(%rbp)
	movl	$0, %edi
	call	start@PLT
	jmp	.L69
.L68:
	movl	Rtmax(%rip), %eax
	cmpl	$-1, %eax
	jne	.L70
	movl	Rtmin(%rip), %eax
	cmpl	$-1, %eax
	je	.L79
.L70:
	leaq	-144(%rbp), %rdx
	leaq	-160(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	stop@PLT
	movl	%eax, -224(%rbp)
	movl	-224(%rbp), %eax
	movslq	%eax, %rdx
	imulq	$274877907, %rdx, %rdx
	shrq	$32, %rdx
	sarl	$6, %edx
	sarl	$31, %eax
	movl	%eax, %ecx
	movl	%edx, %eax
	subl	%ecx, %eax
	movl	%eax, -220(%rbp)
	movl	Rtmax(%rip), %eax
	cmpl	%eax, -220(%rbp)
	jg	.L72
	movl	Rtmin(%rip), %eax
	cmpl	%eax, -220(%rbp)
	jge	.L73
.L72:
	movl	-228(%rbp), %eax
	movl	$1, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	seekto@PLT
	movq	%rax, %rdi
	call	p64sz@PLT
	movq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2ssl	-224(%rbp), %xmm0
	movss	.LC83(%rip), %xmm1
	divss	%xmm1, %xmm0
	pxor	%xmm2, %xmm2
	cvtss2sd	%xmm0, %xmm2
	movq	%xmm2, %rcx
	movq	stderr(%rip), %rax
	movq	%rcx, %xmm0
	leaq	.LC84(%rip), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	movl	$1, %eax
	call	fprintf@PLT
.L73:
	movl	Rtmax(%rip), %eax
	cmpl	%eax, -220(%rbp)
	jl	.L74
	movl	44+rthist(%rip), %eax
	addl	$1, %eax
	movl	%eax, 44+rthist(%rip)
	jmp	.L79
.L74:
	movl	Rtmin(%rip), %eax
	cmpl	%eax, -220(%rbp)
	jge	.L75
	movl	rthist(%rip), %eax
	addl	$1, %eax
	movl	%eax, rthist(%rip)
	jmp	.L79
.L75:
	movl	Rtmax(%rip), %eax
	movl	Rtmin(%rip), %edx
	subl	%edx, %eax
	movslq	%eax, %rdx
	imulq	$1717986919, %rdx, %rdx
	shrq	$32, %rdx
	sarl	$2, %edx
	sarl	$31, %eax
	movl	%eax, %ecx
	movl	%edx, %eax
	subl	%ecx, %eax
	movl	%eax, -216(%rbp)
	movl	$1, -276(%rbp)
	jmp	.L76
.L78:
	movl	-276(%rbp), %eax
	imull	-216(%rbp), %eax
	movl	%eax, %edx
	movl	Rtmin(%rip), %eax
	addl	%edx, %eax
	cmpl	%eax, -220(%rbp)
	jge	.L77
	movl	-276(%rbp), %eax
	cltq
	leaq	0(,%rax,4), %rdx
	leaq	rthist(%rip), %rax
	movl	(%rdx,%rax), %eax
	leal	1(%rax), %ecx
	movl	-276(%rbp), %eax
	cltq
	leaq	0(,%rax,4), %rdx
	leaq	rthist(%rip), %rax
	movl	%ecx, (%rdx,%rax)
	jmp	.L79
.L77:
	addl	$1, -276(%rbp)
.L76:
	cmpl	$10, -276(%rbp)
	jle	.L78
	jmp	.L79
.L65:
	movl	Bsize(%rip), %ebx
.L79:
	cmpl	$-1, %ebx
	jne	.L80
	leaq	.LC85(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
.L80:
	testl	%ebx, %ebx
	jg	.L81
	movl	$0, %eax
	call	done
.L81:
	cmpl	$-1, -256(%rbp)
	je	.L82
	movl	$0, %r12d
	movslq	%ebx, %rax
	shrq	$2, %rax
	movl	%eax, %r13d
	jmp	.L83
.L85:
	movslq	%r12d, %rax
	leaq	0(,%rax,4), %rdx
	movq	-168(%rbp), %rax
	addq	%rdx, %rax
	movl	(%rax), %eax
	movq	-184(%rbp), %rdx
	movl	%edx, %ecx
	movslq	%r12d, %rdx
	sall	$2, %edx
	addl	%ecx, %edx
	cmpl	%edx, %eax
	je	.L84
	movslq	%r12d, %rax
	leaq	0(,%rax,4), %rdx
	movq	-168(%rbp), %rax
	addq	%rdx, %rax
	movl	(%rax), %ecx
	movq	-184(%rbp), %rax
	movl	%eax, %edx
	movslq	%r12d, %rax
	sall	$2, %eax
	addl	%eax, %edx
	movq	-184(%rbp), %rax
	movl	%eax, %esi
	movq	stderr(%rip), %rax
	movl	%ecx, %r8d
	movl	%edx, %ecx
	movl	%esi, %edx
	leaq	.LC86(%rip), %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf@PLT
	cmpl	$-1, -260(%rbp)
	je	.L84
	subl	$1, -296(%rbp)
	cmpl	$0, -296(%rbp)
	jne	.L84
	movl	$0, %eax
	call	done
.L84:
	addl	$1, %r12d
.L83:
	movl	%r13d, %eax
	leal	-1(%rax), %r13d
	testl	%eax, %eax
	jne	.L85
.L82:
	cmpl	$0, -228(%rbp)
	js	.L86
	cmpl	$0, -232(%rbp)
	je	.L86
	movl	$0, -272(%rbp)
	jmp	.L87
.L88:
	movl	-272(%rbp), %eax
	movslq	%eax, %rdx
	movq	-168(%rbp), %rax
	addq	%rdx, %rax
	movb	$0, (%rax)
	addl	$4096, -272(%rbp)
.L87:
	cmpl	%ebx, -272(%rbp)
	jl	.L88
.L86:
	movl	out(%rip), %eax
	testl	%eax, %eax
	js	.L89
	cmpl	$-1, -244(%rbp)
	je	.L90
	cmpl	$0, -280(%rbp)
	je	.L91
	movl	-280(%rbp), %eax
	movl	$0, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	waitpid@PLT
.L91:
	call	fork@PLT
	movl	%eax, -280(%rbp)
	cmpl	$0, -280(%rbp)
	je	.L90
	movslq	%ebx, %rax
	addq	%rax, -184(%rbp)
	movl	%ebx, %eax
	sarl	$2, %eax
	movslq	%eax, %rdx
	movq	int_count(%rip), %rax
	addq	%rdx, %rax
	movq	%rax, int_count(%rip)
	jmp	.L69
.L90:
	cmpl	$-1, -252(%rbp)
	je	.L92
	movl	$0, %r12d
	movslq	%ebx, %rax
	shrq	$2, %rax
	movl	%eax, %r13d
	jmp	.L93
.L94:
	movq	-184(%rbp), %rax
	movl	%eax, %esi
	movslq	%r12d, %rax
	leal	0(,%rax,4), %edx
	movslq	%r12d, %rax
	leaq	0(,%rax,4), %rcx
	movq	-168(%rbp), %rax
	addq	%rcx, %rax
	addl	%esi, %edx
	movl	%edx, (%rax)
	addl	$1, %r12d
.L93:
	movl	%r13d, %eax
	leal	-1(%rax), %r13d
	testl	%eax, %eax
	jne	.L94
.L92:
	movl	Wtmax(%rip), %eax
	cmpl	$-1, %eax
	jne	.L95
	movl	Wtmin(%rip), %eax
	cmpl	$-1, %eax
	je	.L96
.L95:
	leaq	-160(%rbp), %rax
	movq	%rax, %rdi
	call	start@PLT
.L96:
	movslq	%ebx, %rdx
	movl	out(%rip), %eax
	movq	-168(%rbp), %rcx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	write@PLT
	movl	%eax, -212(%rbp)
	cmpl	$-1, -212(%rbp)
	jne	.L97
	leaq	.LC87(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
.L97:
	cmpl	%ebx, -212(%rbp)
	je	.L98
	movq	stderr(%rip), %rax
	movl	-212(%rbp), %edx
	movl	%edx, %ecx
	movl	%ebx, %edx
	leaq	.LC88(%rip), %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf@PLT
	movl	$0, %eax
	call	done
.L98:
	movl	Wtmax(%rip), %eax
	cmpl	$-1, %eax
	jne	.L99
	movl	Wtmin(%rip), %eax
	cmpl	$-1, %eax
	je	.L100
.L99:
	leaq	-144(%rbp), %rdx
	leaq	-160(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	stop@PLT
	movl	%eax, -208(%rbp)
	movl	-208(%rbp), %eax
	movslq	%eax, %rdx
	imulq	$274877907, %rdx, %rdx
	shrq	$32, %rdx
	sarl	$6, %edx
	sarl	$31, %eax
	movl	%eax, %ecx
	movl	%edx, %eax
	subl	%ecx, %eax
	movl	%eax, -220(%rbp)
	movl	Wtmax(%rip), %eax
	cmpl	%eax, -220(%rbp)
	jg	.L101
	movl	Wtmin(%rip), %eax
	cmpl	%eax, -220(%rbp)
	jge	.L102
.L101:
	movl	out(%rip), %eax
	movl	$1, %edx
	movl	$0, %esi
	movl	%eax, %edi
	call	seekto@PLT
	movq	%rax, %rdi
	call	p64sz@PLT
	movq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2ssl	-208(%rbp), %xmm0
	movss	.LC83(%rip), %xmm1
	divss	%xmm1, %xmm0
	pxor	%xmm3, %xmm3
	cvtss2sd	%xmm0, %xmm3
	movq	%xmm3, %rcx
	movq	stderr(%rip), %rax
	movq	%rcx, %xmm0
	leaq	.LC89(%rip), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	movl	$1, %eax
	call	fprintf@PLT
.L102:
	movl	Wtmax(%rip), %eax
	cmpl	%eax, -220(%rbp)
	jl	.L103
	movl	44+wthist(%rip), %eax
	addl	$1, %eax
	movl	%eax, 44+wthist(%rip)
	jmp	.L100
.L103:
	movl	Wtmin(%rip), %eax
	cmpl	%eax, -220(%rbp)
	jge	.L104
	movl	wthist(%rip), %eax
	addl	$1, %eax
	movl	%eax, wthist(%rip)
	jmp	.L100
.L104:
	movl	Wtmax(%rip), %eax
	movl	Wtmin(%rip), %edx
	subl	%edx, %eax
	movslq	%eax, %rdx
	imulq	$1717986919, %rdx, %rdx
	shrq	$32, %rdx
	sarl	$2, %edx
	sarl	$31, %eax
	movl	%eax, %ecx
	movl	%edx, %eax
	subl	%ecx, %eax
	movl	%eax, -204(%rbp)
	movl	$1, -268(%rbp)
	jmp	.L105
.L107:
	movl	-268(%rbp), %eax
	imull	-204(%rbp), %eax
	movl	%eax, %edx
	movl	Wtmin(%rip), %eax
	addl	%edx, %eax
	cmpl	%eax, -220(%rbp)
	jge	.L106
	movl	-268(%rbp), %eax
	cltq
	leaq	0(,%rax,4), %rdx
	leaq	wthist(%rip), %rax
	movl	(%rdx,%rax), %eax
	leal	1(%rax), %ecx
	movl	-268(%rbp), %eax
	cltq
	leaq	0(,%rax,4), %rdx
	leaq	wthist(%rip), %rax
	movl	%ecx, (%rdx,%rax)
	jmp	.L100
.L106:
	addl	$1, -268(%rbp)
.L105:
	cmpl	$10, -268(%rbp)
	jle	.L107
.L100:
	cmpl	$-1, -212(%rbp)
	jne	.L108
	leaq	.LC87(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
.L108:
	cmpl	%ebx, -212(%rbp)
	je	.L109
	movl	$0, %eax
	call	done
.L109:
	cmpl	$0, -232(%rbp)
	je	.L89
	movl	$0, -264(%rbp)
	jmp	.L110
.L111:
	movl	-264(%rbp), %eax
	movslq	%eax, %rdx
	movq	-168(%rbp), %rax
	addq	%rdx, %rax
	movb	$0, (%rax)
	addl	$4096, -264(%rbp)
.L110:
	cmpl	%ebx, -264(%rbp)
	jl	.L111
.L89:
	movslq	%ebx, %rax
	addq	%rax, -184(%rbp)
	movl	%ebx, %eax
	sarl	$2, %eax
	movslq	%eax, %rdx
	movq	int_count(%rip), %rax
	addq	%rdx, %rax
	movq	%rax, int_count(%rip)
	cmpl	$-1, -248(%rbp)
	je	.L112
	movl	-248(%rbp), %eax
	movl	%eax, %edi
	call	usleep@PLT
.L112:
	movl	hash(%rip), %eax
	testl	%eax, %eax
	je	.L113
	movq	stderr(%rip), %rax
	movq	%rax, %rsi
	movl	$35, %edi
	call	fputc@PLT
.L113:
	cmpl	$-1, -244(%rbp)
	je	.L114
	movl	$0, %edi
	call	exit@PLT
.L69:
	jmp	.L114
	.cfi_endproc
.LFE8:
	.size	main, .-main
	.section	.rodata
.LC90:
	.string	"norepeat on %u\n"
	.text
	.globl	been_there
	.type	been_there, @function
been_there:
.LFB9:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%rbx
	subq	$24, %rsp
	.cfi_offset 3, -24
	movq	%rdi, -24(%rbp)
	movl	$0, %ebx
	jmp	.L117
.L120:
	movq	norepeat(%rip), %rdx
	movslq	%ebx, %rax
	salq	$3, %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	cmpq	%rax, -24(%rbp)
	jne	.L118
	movq	-24(%rbp), %rax
	movl	%eax, %edx
	movq	stderr(%rip), %rax
	leaq	.LC90(%rip), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf@PLT
	movl	$1, %eax
	jmp	.L119
.L118:
	addl	$1, %ebx
.L117:
	movl	norepeats(%rip), %eax
	cmpl	%eax, %ebx
	jle	.L120
	movl	$0, %eax
.L119:
	movq	-8(%rbp), %rbx
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE9:
	.size	been_there, .-been_there
	.section	.rodata
	.align 8
.LC91:
	.string	"Bad arg: %s, possible arguments are: "
	.text
	.globl	chkarg
	.type	chkarg, @function
chkarg:
.LFB10:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$48, %rsp
	movq	%rdi, -40(%rbp)
	movl	$0, -20(%rbp)
	jmp	.L122
.L128:
	movq	-40(%rbp), %rax
	movq	%rax, -16(%rbp)
	movl	-20(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	leaq	cmds(%rip), %rax
	movq	(%rdx,%rax), %rax
	movq	%rax, -8(%rbp)
	jmp	.L123
.L125:
	addq	$1, -16(%rbp)
	addq	$1, -8(%rbp)
.L123:
	movq	-16(%rbp), %rax
	movzbl	(%rax), %eax
	testb	%al, %al
	je	.L124
	movq	-8(%rbp), %rax
	movzbl	(%rax), %eax
	testb	%al, %al
	je	.L124
	movq	-16(%rbp), %rax
	movzbl	(%rax), %edx
	movq	-8(%rbp), %rax
	movzbl	(%rax), %eax
	cmpb	%al, %dl
	je	.L125
.L124:
	movq	-16(%rbp), %rax
	movzbl	(%rax), %eax
	cmpb	$61, %al
	je	.L132
	addl	$1, -20(%rbp)
.L122:
	movl	-20(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	leaq	cmds(%rip), %rax
	movq	(%rdx,%rax), %rax
	testq	%rax, %rax
	jne	.L128
	movq	stderr(%rip), %rax
	movq	-40(%rbp), %rdx
	leaq	.LC91(%rip), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf@PLT
	movl	$0, -20(%rbp)
	jmp	.L129
.L130:
	movl	-20(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	leaq	cmds(%rip), %rax
	movq	(%rdx,%rax), %rdx
	movq	stderr(%rip), %rax
	leaq	.LC81(%rip), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf@PLT
	addl	$1, -20(%rbp)
.L129:
	movl	-20(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	leaq	cmds(%rip), %rax
	movq	(%rdx,%rax), %rax
	testq	%rax, %rax
	jne	.L130
	movq	stderr(%rip), %rax
	movq	%rax, %rsi
	movl	$10, %edi
	call	fputc@PLT
	movl	$1, %edi
	call	exit@PLT
.L132:
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE10:
	.size	chkarg, .-chkarg
	.section	.rodata
.LC92:
	.string	""
.LC93:
	.string	"READ operation latencies"
.LC94:
	.string	"%d- ms: %d\n"
.LC95:
	.string	"%d to %d ms: %d\n"
.LC96:
	.string	"%d+ ms: %d\n"
.LC97:
	.string	"WRITE operation latencies"
	.text
	.globl	done
	.type	done, @function
done:
.LFB11:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movl	Sync(%rip), %eax
	testl	%eax, %eax
	jle	.L134
	call	sync@PLT
.L134:
	movl	Fsync(%rip), %eax
	testl	%eax, %eax
	jle	.L135
	movl	out(%rip), %eax
	movl	%eax, %edi
	call	fsync@PLT
.L135:
	movl	Flush(%rip), %eax
	testl	%eax, %eax
	jle	.L136
	call	flush
.L136:
	movl	$0, %esi
	movl	$0, %edi
	call	stop@PLT
	movl	ru(%rip), %eax
	cmpl	$-1, %eax
	je	.L137
	call	rusage@PLT
.L137:
	movl	hash(%rip), %eax
	testl	%eax, %eax
	jne	.L138
	movl	poff(%rip), %eax
	testl	%eax, %eax
	je	.L139
.L138:
	movq	stderr(%rip), %rax
	movq	%rax, %rsi
	movl	$10, %edi
	call	fputc@PLT
.L139:
	movq	Label(%rip), %rax
	cmpq	$-1, %rax
	je	.L140
	movq	Label(%rip), %rax
	movq	stderr(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	fputs@PLT
.L140:
	movq	int_count(%rip), %rax
	salq	$2, %rax
	movq	%rax, int_count(%rip)
	movl	Print(%rip), %eax
	cmpl	$5, %eax
	ja	.L141
	movl	%eax, %eax
	leaq	0(,%rax,4), %rdx
	leaq	.L143(%rip), %rax
	movl	(%rdx,%rax), %eax
	cltq
	leaq	.L143(%rip), %rdx
	addq	%rdx, %rax
	notrack jmp	*%rax
	.section	.rodata
	.align 4
	.align 4
.L143:
	.long	.L162-.L143
	.long	.L147-.L143
	.long	.L146-.L143
	.long	.L145-.L143
	.long	.L144-.L143
	.long	.L142-.L143
	.text
.L147:
	movl	Bsize(%rip), %eax
	movslq	%eax, %rcx
	movq	int_count(%rip), %rax
	movl	Bsize(%rip), %edx
	movslq	%edx, %rsi
	movl	$0, %edx
	divq	%rsi
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	latency@PLT
	jmp	.L149
.L146:
	movq	int_count(%rip), %rax
	movl	Bsize(%rip), %edx
	movslq	%edx, %rcx
	movl	$0, %edx
	divq	%rcx
	movq	%rax, %rsi
	leaq	.LC92(%rip), %rax
	movq	%rax, %rdi
	call	micro@PLT
	jmp	.L149
.L145:
	movq	int_count(%rip), %rax
	movq	%rax, %rdi
	call	kb@PLT
	jmp	.L149
.L144:
	movq	int_count(%rip), %rax
	movq	%rax, %rdi
	call	mb@PLT
	jmp	.L149
.L142:
	movq	int_count(%rip), %rax
	movl	$0, %edx
	movl	$1, %esi
	movq	%rax, %rdi
	call	bandwidth@PLT
	jmp	.L149
.L141:
	movq	int_count(%rip), %rax
	movl	$1, %edx
	movl	$1, %esi
	movq	%rax, %rdi
	call	bandwidth@PLT
	jmp	.L149
.L162:
	nop
.L149:
	movl	Rtmax(%rip), %eax
	cmpl	$-1, %eax
	je	.L150
	leaq	.LC93(%rip), %rax
	movq	%rax, %rdi
	call	puts@PLT
	movl	Rtmax(%rip), %eax
	movl	Rtmin(%rip), %edx
	subl	%edx, %eax
	movslq	%eax, %rdx
	imulq	$1717986919, %rdx, %rdx
	shrq	$32, %rdx
	sarl	$2, %edx
	sarl	$31, %eax
	movl	%eax, %ecx
	movl	%edx, %eax
	subl	%ecx, %eax
	movl	%eax, -4(%rbp)
	movl	rthist(%rip), %eax
	testl	%eax, %eax
	je	.L151
	movl	rthist(%rip), %edx
	movl	Rtmin(%rip), %eax
	movl	%eax, %esi
	leaq	.LC94(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf@PLT
.L151:
	movl	$1, -12(%rbp)
	movl	Rtmin(%rip), %eax
	movl	%eax, -8(%rbp)
	jmp	.L152
.L155:
	movl	-12(%rbp), %eax
	cltq
	leaq	0(,%rax,4), %rdx
	leaq	rthist(%rip), %rax
	movl	(%rdx,%rax), %eax
	testl	%eax, %eax
	je	.L163
	movl	-12(%rbp), %eax
	cltq
	leaq	0(,%rax,4), %rdx
	leaq	rthist(%rip), %rax
	movl	(%rdx,%rax), %edx
	movl	-8(%rbp), %ecx
	movl	-4(%rbp), %eax
	addl	%ecx, %eax
	leal	-1(%rax), %esi
	movl	-8(%rbp), %eax
	movl	%edx, %ecx
	movl	%esi, %edx
	movl	%eax, %esi
	leaq	.LC95(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf@PLT
	jmp	.L154
.L163:
	nop
.L154:
	addl	$1, -12(%rbp)
	movl	-4(%rbp), %eax
	addl	%eax, -8(%rbp)
.L152:
	cmpl	$10, -12(%rbp)
	jle	.L155
	movl	44+rthist(%rip), %eax
	testl	%eax, %eax
	je	.L150
	movl	44+rthist(%rip), %edx
	movl	Rtmax(%rip), %eax
	movl	%eax, %esi
	leaq	.LC96(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf@PLT
.L150:
	movl	Wtmax(%rip), %eax
	cmpl	$-1, %eax
	je	.L156
	leaq	.LC97(%rip), %rax
	movq	%rax, %rdi
	call	puts@PLT
	movl	Wtmax(%rip), %eax
	movl	Wtmin(%rip), %edx
	subl	%edx, %eax
	movslq	%eax, %rdx
	imulq	$1717986919, %rdx, %rdx
	shrq	$32, %rdx
	sarl	$2, %edx
	sarl	$31, %eax
	movl	%eax, %ecx
	movl	%edx, %eax
	subl	%ecx, %eax
	movl	%eax, -4(%rbp)
	movl	wthist(%rip), %eax
	testl	%eax, %eax
	je	.L157
	movl	wthist(%rip), %edx
	movl	Wtmin(%rip), %eax
	movl	%eax, %esi
	leaq	.LC94(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf@PLT
.L157:
	movl	$1, -12(%rbp)
	movl	Wtmin(%rip), %eax
	movl	%eax, -8(%rbp)
	jmp	.L158
.L161:
	movl	-12(%rbp), %eax
	cltq
	leaq	0(,%rax,4), %rdx
	leaq	wthist(%rip), %rax
	movl	(%rdx,%rax), %eax
	testl	%eax, %eax
	je	.L164
	movl	-12(%rbp), %eax
	cltq
	leaq	0(,%rax,4), %rdx
	leaq	wthist(%rip), %rax
	movl	(%rdx,%rax), %edx
	movl	-8(%rbp), %ecx
	movl	-4(%rbp), %eax
	addl	%ecx, %eax
	leal	-1(%rax), %esi
	movl	-8(%rbp), %eax
	movl	%edx, %ecx
	movl	%esi, %edx
	movl	%eax, %esi
	leaq	.LC95(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf@PLT
	jmp	.L160
.L164:
	nop
.L160:
	addl	$1, -12(%rbp)
	movl	-4(%rbp), %eax
	addl	%eax, -8(%rbp)
.L158:
	cmpl	$10, -12(%rbp)
	jle	.L161
	movl	44+wthist(%rip), %eax
	testl	%eax, %eax
	je	.L156
	movl	44+wthist(%rip), %edx
	movl	Wtmax(%rip), %eax
	movl	%eax, %esi
	leaq	.LC96(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf@PLT
.L156:
	movl	$0, %edi
	call	exit@PLT
	.cfi_endproc
.LFE11:
	.size	done, .-done
	.globl	getarg
	.type	getarg, @function
getarg:
.LFB12:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$40, %rsp
	.cfi_offset 13, -24
	.cfi_offset 12, -32
	.cfi_offset 3, -40
	movq	%rdi, -40(%rbp)
	movl	%esi, -44(%rbp)
	movq	%rdx, -56(%rbp)
	movq	-40(%rbp), %rax
	movq	%rax, %rdi
	call	strlen@PLT
	movq	%rax, %r12
	movl	$1, %ebx
	jmp	.L166
.L170:
	leaq	0(,%rbx,8), %rdx
	movq	-56(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	-40(%rbp), %rcx
	movq	%r12, %rdx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	strncmp@PLT
	testl	%eax, %eax
	jne	.L167
	leaq	0(,%rbx,8), %rdx
	movq	-56(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	addq	%r12, %rax
	movq	%rax, %rdi
	call	bytes@PLT
	movq	%rax, %r13
	leaq	0(,%rbx,8), %rdx
	movq	-56(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movl	$6, %edx
	leaq	.LC68(%rip), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	strncmp@PLT
	testl	%eax, %eax
	jne	.L168
	leaq	0(,%rbx,8), %rdx
	movq	-56(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	addq	%r12, %rax
	jmp	.L169
.L168:
	movq	%r13, %rax
	jmp	.L169
.L167:
	addq	$1, %rbx
.L166:
	movl	-44(%rbp), %eax
	cltq
	cmpq	%rax, %rbx
	jb	.L170
	movq	$-1, %rax
.L169:
	addq	$40, %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE12:
	.size	getarg, .-getarg
	.globl	output
	.bss
	.align 8
	.type	output, @object
	.size	output, 8
output:
	.zero	8
	.section	.rodata
.LC98:
	.string	"append="
.LC99:
	.string	"notrunc="
.LC100:
	.string	"nocreate="
.LC101:
	.string	"osync="
.LC102:
	.string	"of=internal"
.LC103:
	.string	"of=stdout"
.LC104:
	.string	"of=1"
.LC105:
	.string	"of=-"
.LC106:
	.string	"of=stderr"
.LC107:
	.string	"of=2"
.LC108:
	.string	"if=internal"
.LC109:
	.string	"if=stdin"
.LC110:
	.string	"if=0"
.LC111:
	.string	"if=-"
	.text
	.globl	getfile
	.type	getfile, @function
getfile:
.LFB13:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$72, %rsp
	.cfi_offset 13, -24
	.cfi_offset 12, -32
	.cfi_offset 3, -40
	movq	%rdi, -72(%rbp)
	movl	%esi, -76(%rbp)
	movq	%rdx, -88(%rbp)
	movq	-88(%rbp), %rdx
	movl	-76(%rbp), %eax
	movl	%eax, %esi
	leaq	.LC98(%rip), %rax
	movq	%rax, %rdi
	call	getarg
	cmpq	$-1, %rax
	setne	%al
	movzbl	%al, %eax
	movl	%eax, -52(%rbp)
	movq	-88(%rbp), %rdx
	movl	-76(%rbp), %eax
	movl	%eax, %esi
	leaq	.LC99(%rip), %rax
	movq	%rax, %rdi
	call	getarg
	cmpq	$-1, %rax
	setne	%al
	movzbl	%al, %eax
	movl	%eax, -48(%rbp)
	movq	-88(%rbp), %rdx
	movl	-76(%rbp), %eax
	movl	%eax, %esi
	leaq	.LC100(%rip), %rax
	movq	%rax, %rdi
	call	getarg
	cmpq	$-1, %rax
	setne	%al
	movzbl	%al, %eax
	movl	%eax, -44(%rbp)
	movq	-88(%rbp), %rdx
	movl	-76(%rbp), %eax
	movl	%eax, %esi
	leaq	.LC101(%rip), %rax
	movq	%rax, %rdi
	call	getarg
	cmpq	$-1, %rax
	setne	%al
	movzbl	%al, %eax
	movl	%eax, -40(%rbp)
	movq	-72(%rbp), %rax
	movq	%rax, %rdi
	call	strlen@PLT
	movl	%eax, %r13d
	movl	$1, %ebx
	jmp	.L172
.L197:
	movslq	%r13d, %rdx
	movslq	%ebx, %rax
	leaq	0(,%rax,8), %rcx
	movq	-88(%rbp), %rax
	addq	%rcx, %rax
	movq	(%rax), %rax
	movq	-72(%rbp), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	strncmp@PLT
	testl	%eax, %eax
	jne	.L173
	movslq	%ebx, %rax
	leaq	0(,%rax,8), %rdx
	movq	-88(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movzbl	(%rax), %eax
	cmpb	$111, %al
	jne	.L174
	movslq	%ebx, %rax
	leaq	0(,%rax,8), %rdx
	movq	-88(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	%rax, %rsi
	leaq	.LC102(%rip), %rax
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L175
	movl	$-2, %eax
	jmp	.L176
.L175:
	movslq	%ebx, %rax
	leaq	0(,%rax,8), %rdx
	movq	-88(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	%rax, %rsi
	leaq	.LC103(%rip), %rax
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L177
	movl	$1, %eax
	jmp	.L176
.L177:
	movslq	%ebx, %rax
	leaq	0(,%rax,8), %rdx
	movq	-88(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	%rax, %rsi
	leaq	.LC104(%rip), %rax
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L178
	movl	$1, %eax
	jmp	.L176
.L178:
	movslq	%ebx, %rax
	leaq	0(,%rax,8), %rdx
	movq	-88(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	%rax, %rsi
	leaq	.LC105(%rip), %rax
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L179
	movl	$1, %eax
	jmp	.L176
.L179:
	movslq	%ebx, %rax
	leaq	0(,%rax,8), %rdx
	movq	-88(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	%rax, %rsi
	leaq	.LC106(%rip), %rax
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L180
	movl	$2, %eax
	jmp	.L176
.L180:
	movslq	%ebx, %rax
	leaq	0(,%rax,8), %rdx
	movq	-88(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	%rax, %rsi
	leaq	.LC107(%rip), %rax
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L181
	movl	$2, %eax
	jmp	.L176
.L181:
	movl	$1, -36(%rbp)
	cmpl	$0, -48(%rbp)
	jne	.L182
	cmpl	$0, -52(%rbp)
	je	.L183
.L182:
	movl	$0, %eax
	jmp	.L184
.L183:
	movl	$512, %eax
.L184:
	orl	%eax, -36(%rbp)
	cmpl	$0, -44(%rbp)
	je	.L185
	movl	$0, %eax
	jmp	.L186
.L185:
	movl	$64, %eax
.L186:
	orl	%eax, -36(%rbp)
	cmpl	$0, -52(%rbp)
	je	.L187
	movl	$1024, %eax
	jmp	.L188
.L187:
	movl	$0, %eax
.L188:
	orl	%eax, -36(%rbp)
	cmpl	$0, -40(%rbp)
	je	.L189
	movl	$1052672, %eax
	jmp	.L190
.L189:
	movl	$0, %eax
.L190:
	orl	%eax, -36(%rbp)
	movslq	%ebx, %rax
	leaq	0(,%rax,8), %rdx
	movq	-88(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rdx
	movslq	%r13d, %rax
	leaq	(%rdx,%rax), %rcx
	movl	-36(%rbp), %eax
	movl	$420, %edx
	movl	%eax, %esi
	movq	%rcx, %rdi
	movl	$0, %eax
	call	open@PLT
	movl	%eax, %r12d
	cmpl	$-1, %r12d
	jne	.L191
	movslq	%ebx, %rax
	leaq	0(,%rax,8), %rdx
	movq	-88(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rdx
	movslq	%r13d, %rax
	addq	%rdx, %rax
	movq	%rax, %rdi
	call	error
.L191:
	movslq	%ebx, %rax
	leaq	0(,%rax,8), %rdx
	movq	-88(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rdx
	movslq	%r13d, %rax
	addq	%rdx, %rax
	movq	%rax, output(%rip)
	movl	%r12d, %eax
	jmp	.L176
.L174:
	movslq	%ebx, %rax
	leaq	0(,%rax,8), %rdx
	movq	-88(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	%rax, %rsi
	leaq	.LC108(%rip), %rax
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L192
	movl	$-2, %eax
	jmp	.L176
.L192:
	movslq	%ebx, %rax
	leaq	0(,%rax,8), %rdx
	movq	-88(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	%rax, %rsi
	leaq	.LC109(%rip), %rax
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L193
	movl	$0, %eax
	jmp	.L176
.L193:
	movslq	%ebx, %rax
	leaq	0(,%rax,8), %rdx
	movq	-88(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	%rax, %rsi
	leaq	.LC110(%rip), %rax
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L194
	movl	$0, %eax
	jmp	.L176
.L194:
	movslq	%ebx, %rax
	leaq	0(,%rax,8), %rdx
	movq	-88(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	%rax, %rsi
	leaq	.LC111(%rip), %rax
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L195
	movl	$0, %eax
	jmp	.L176
.L195:
	movslq	%ebx, %rax
	leaq	0(,%rax,8), %rdx
	movq	-88(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rdx
	movslq	%r13d, %rax
	addq	%rdx, %rax
	movl	$0, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	open@PLT
	movl	%eax, %r12d
	cmpl	$-1, %r12d
	jne	.L196
	movslq	%ebx, %rax
	leaq	0(,%rax,8), %rdx
	movq	-88(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rdx
	movslq	%r13d, %rax
	addq	%rdx, %rax
	movq	%rax, %rdi
	call	error
.L196:
	movl	%r12d, %eax
	jmp	.L176
.L173:
	addl	$1, %ebx
.L172:
	cmpl	-76(%rbp), %ebx
	jl	.L197
	movl	$-2, %eax
.L176:
	addq	$72, %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE13:
	.size	getfile, .-getfile
	.section	.rodata
.LC112:
	.string	"%s: "
	.text
	.globl	warning
	.type	warning, @function
warning:
.LFB14:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movq	Label(%rip), %rax
	cmpq	$-1, %rax
	je	.L199
	movq	Label(%rip), %rdx
	movq	stderr(%rip), %rax
	leaq	.LC112(%rip), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf@PLT
.L199:
	movq	-8(%rbp), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$-1, %eax
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE14:
	.size	warning, .-warning
	.section	.rodata
.LC113:
	.string	"No output file"
	.text
	.globl	flush
	.type	flush, @function
flush:
.LFB15:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$176, %rsp
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movq	output(%rip), %rax
	testq	%rax, %rax
	je	.L202
	movq	output(%rip), %rax
	movl	$2, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	open@PLT
	movl	%eax, -172(%rbp)
	cmpl	$-1, -172(%rbp)
	jne	.L203
.L202:
	leaq	.LC113(%rip), %rax
	movq	%rax, %rdi
	call	warning
	jmp	.L201
.L203:
	leaq	-160(%rbp), %rdx
	movl	-172(%rbp), %eax
	movq	%rdx, %rsi
	movl	%eax, %edi
	call	fstat@PLT
	cmpl	$-1, %eax
	je	.L205
	movq	-112(%rbp), %rax
	testq	%rax, %rax
	jne	.L206
.L205:
	movq	output(%rip), %rax
	movq	%rax, %rdi
	call	warning
	jmp	.L201
.L206:
	movq	-112(%rbp), %rax
	movq	%rax, %rsi
	movl	-172(%rbp), %eax
	movl	$0, %r9d
	movl	%eax, %r8d
	movl	$1, %ecx
	movl	$3, %edx
	movl	$0, %edi
	call	mmap@PLT
	movq	%rax, -168(%rbp)
	movq	-112(%rbp), %rax
	movq	%rax, %rcx
	movq	-168(%rbp), %rax
	movl	$2, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	msync@PLT
	movq	-112(%rbp), %rax
	movq	%rax, %rdx
	movq	-168(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	munmap@PLT
.L201:
	movq	-8(%rbp), %rax
	subq	%fs:40, %rax
	je	.L208
	call	__stack_chk_fail@PLT
.L208:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE15:
	.size	flush, .-flush
	.globl	error
	.type	error, @function
error:
.LFB16:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movq	Label(%rip), %rax
	cmpq	$-1, %rax
	je	.L210
	movq	Label(%rip), %rdx
	movq	stderr(%rip), %rax
	leaq	.LC112(%rip), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf@PLT
.L210:
	movq	-8(%rbp), %rax
	movq	%rax, %rdi
	call	perror@PLT
	movl	$1, %edi
	call	exit@PLT
	.cfi_endproc
.LFE16:
	.size	error, .-error
	.local	start.0
	.comm	start.0,8,8
	.section	.rodata
	.align 8
.LC82:
	.long	0
	.long	1138753536
	.align 4
.LC83:
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
