	.file	"max5_function_calls.c"
	.option nopic
	.attribute arch, "rv32i2p1"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.align	2
	.type	max, @function
max:
	mv	a5,a0
	mv	a0,a1
	bge	a1,a5,.L2
	mv	a0,a5
.L2:
	ret
	.size	max, .-max
	.section	.text.startup,"ax",@progbits
	.align	2
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-48
	sw	ra,44(sp)
 #APP
# 16 "max5_function_calls.c" 1
	li sp, 1024
# 0 "" 2
 #NO_APP
	li	a5,14
	sw	a5,12(sp)
	li	a5,27
	sw	a5,16(sp)
	li	a5,9
	sw	a5,20(sp)
	li	a5,31
	sw	a5,24(sp)
	li	a5,18
	sw	a5,28(sp)
	lw	a0,12(sp)
	lw	a1,16(sp)
	call	max
	lw	a1,20(sp)
	call	max
	lw	a1,24(sp)
	call	max
	lw	a1,28(sp)
	call	max
	sw	a0,256(zero)
.L5:
	j	.L5
	.size	main, .-main
	.ident	"GCC: (13.2.0-11ubuntu1+12) 13.2.0"
