.global _start

.data
factorialeq:	.asciz "! = "
strbuff:		.skip 13
safemsg:		.asciz "Program terminated without stack overflow\n"
endl:			.byte 10

.text
.balign 4
_start:
	mov r4, #1
	mov r5, #10
	_while__r4_not_maxed:
		// Branch to end if r4 is the max
		cmp r4, #0x7fffffff
		beq _end
		// Convert the number we're computing the factorial for
		mov r0, r4
		ldr r1, =strbuff 
		bl intasc32
		// Output the number
		ldr r1, =strbuff
		bl putstring
		// Output factorial equation string
		ldr r1, =factorialeq
		bl putstring
		// Compute factorial of r4
		mov r1, r4
		bl factorial
		// Convert factorial result
		ldr r1, =strbuff
		bl intasc32
		// Output factorial result
		ldr r1, =strbuff
		bl putstring
		// Put an endline
		ldr r1, =endl
		bl putch
		// Branch back to start of the loop
		mul r4, r5, r4
		bal _while__r4_not_maxed
	_end:
	ldr r1, =safemsg
	bl putstring
	mov r0, #0
	mov r7, #1
	swi 0
	.end

