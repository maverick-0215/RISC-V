	.file	"sort5_numbers.c"
	.option nopic
	.attribute arch, "rv32i2p1"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.section	.text.startup,"ax",@progbits
	.align	2
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-32
 #APP
# 4 "sort5_numbers.c" 1
	li sp, 1024
# 0 "" 2
 #NO_APP
	li	a5,23
	sw	a5,12(sp)
	li	a5,7
	sw	a5,16(sp)
	li	a5,31
	sw	a5,20(sp)
	li	a5,4
	sw	a5,24(sp)
	li	a5,18
	sw	a5,28(sp)
	lw	a4,12(sp)
	lw	a5,16(sp)
	ble	a4,a5,.L2
	lw	a5,12(sp)
	lw	a4,16(sp)
	sw	a4,12(sp)
	sw	a5,16(sp)
.L2:
	lw	a4,16(sp)
	lw	a5,20(sp)
	ble	a4,a5,.L10
	lw	a5,16(sp)
	lw	a4,20(sp)
	sw	a4,16(sp)
	sw	a5,20(sp)
.L10:
	lw	a4,20(sp)
	lw	a5,24(sp)
	ble	a4,a5,.L9
	lw	a5,20(sp)
	lw	a4,24(sp)
	sw	a4,20(sp)
	sw	a5,24(sp)
.L9:
	lw	a4,24(sp)
	lw	a5,28(sp)
	bgt	a4,a5,.L5
.L8:
	lw	a4,12(sp)
	lw	a5,16(sp)
	ble	a4,a5,.L7
	lw	a5,12(sp)
	lw	a4,16(sp)
	sw	a4,12(sp)
	sw	a5,16(sp)
.L7:
	lw	a4,16(sp)
	lw	a5,20(sp)
	ble	a4,a5,.L16
	lw	a5,16(sp)
	lw	a4,20(sp)
	sw	a4,16(sp)
	sw	a5,20(sp)
.L16:
	lw	a4,20(sp)
	lw	a5,24(sp)
	bgt	a4,a5,.L12
.L15:
	lw	a4,12(sp)
	lw	a5,16(sp)
	ble	a4,a5,.L14
	lw	a5,12(sp)
	lw	a4,16(sp)
	sw	a4,12(sp)
	sw	a5,16(sp)
.L14:
	lw	a4,16(sp)
	lw	a5,20(sp)
	ble	a4,a5,.L20
	lw	a5,16(sp)
	lw	a4,20(sp)
	sw	a4,16(sp)
	sw	a5,20(sp)
.L20:
	lw	a4,12(sp)
	lw	a5,16(sp)
	ble	a4,a5,.L19
	lw	a5,12(sp)
	lw	a4,16(sp)
	sw	a4,12(sp)
	sw	a5,16(sp)
.L19:
	lw	a5,12(sp)
	sw	a5,256(zero)
	lw	a5,16(sp)
	sw	a5,260(zero)
	lw	a5,20(sp)
	sw	a5,264(zero)
	lw	a5,24(sp)
	sw	a5,268(zero)
	lw	a5,28(sp)
	sw	a5,272(zero)
.L21:
	j	.L21
.L12:
	lw	a5,20(sp)
	lw	a4,24(sp)
	sw	a4,20(sp)
	sw	a5,24(sp)
	j	.L15
.L5:
	lw	a5,24(sp)
	lw	a4,28(sp)
	sw	a4,24(sp)
	sw	a5,28(sp)
	j	.L8
	.size	main, .-main
	.ident	"GCC: (13.2.0-11ubuntu1+12) 13.2.0"
