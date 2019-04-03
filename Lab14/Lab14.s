.global _start

.data
factorialeq:	.asciz "! = "
strbuff:		.skip 13
safemsg:		.asciz "Program terminated without stack overflow\n"
endl:			.byte 10

.text
.balign 4
_start:
	mov r4, #0
	_while__r4_not_maxed:
		// Branch to end if r4 is the max
		cmp r4, #0x7fffffff
		beq _end
		// Convert the number we're computing the factorial for
		// and output it
		mov r0, r4
		ldr r1, =strbuff 
		bl intasc32
		bl putstring
		// Output factorial equals string
		ldr r1, =factorialeq
		bl putstring
		// Compute factorial of r4
		mov r1, r4
		bl factorial
		// Output result of factorial computation
		ldr r1, =strbuff
		bl intasc32
		bl putstring
		// Put an endling
		ldr r1, =endl
		bl putch
		// Branch back to start of the loop
		bal _while__r4_not_maxed
	_end:
	ldr r1, =safemsg
	bl putstring
	mov r0, #0
	mov r7, #1
	swi 0
	.end

