.global safemul

product	.req r0

/*
r0 safemul(r1, r2)
------------------
Multiply two integers. More performance intensive than local
ARM "mul" directive, but checks for overflow
------------------
*/

safemul:
	// Put values of registers on stack
	push {r1, r2, lr}
	// Start the product off at 0
	mov product, #0
	_while__r1gtz:
		// Exit loop if r1 <= 0
		cmp r1, #0
		ble _endwhile__r1gtz
		// Accumulate the other number into the product
		adds product, product, r2
		// Check for overflow
		bvs _endwhile__r1gtz
		// Decrement the number
		sub r1, r1, #1
	_endwhile__r1gtz:
	// Pop values of registers off of stack
	pop {r1, r2, pc}