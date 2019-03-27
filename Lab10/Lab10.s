.global _start

.data
name:		.asciz "Codey Huntting"
date:		.asciz "3/27/2019"
program:	.asciz "Lab10"

.text
.balign 4
_start:
	// Output a header for the program
	ldr r0, =name
	ldr r1, =date
	ldr r2, =program
	bl OutputHeader
	// Move the constants into the registers
	mov r0, #0x80000000
	mov r1, #0x80000001
	mov r2, #0x7fffffff
	mov r3, #0x7ffffffe
	mov r4, #61903
	lsl r4, #1
	// Terminate the program
	mov r0, #0
	mov r7, #1
	svc 0
	.end

