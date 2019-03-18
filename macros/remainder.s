.global remainder

.data
remainder 	.req r0
divisor		.req r1
dividend	.req r2
// Stores the return address
retAddr:	.word 0

/*
r0 remainder(r1 divisor, r2 dividend)
-------------------------------------
Return the signed remainder after the integer division r1 / r2
Overflow is set if r2 = 0
-------------------------------------
*/

.text
.balign 4
remainder:
	// Store the current contents of the link register
	ldr r0, =retAddr
	str lr, [r0]
	// Get the division r1 / r2
	bl idiv
	// Branch straight to the end if overflow is set
	bvs _end
	// Multiply the result of the division by the dividend
	mul remainder, dividend, remainder
	// Subtract the divisor from the remainder
	sub remainder, divisor, remainder  
	_end:
		// Restore the return address and branch back to it
		ldr lr, =retAddr
		ldr lr, [lr]
		bx lr