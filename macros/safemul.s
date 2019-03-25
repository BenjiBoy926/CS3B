.global safemul

product			.req r0
oppositeSigns	.req r3

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
	// Determine if the two numbers have opposite signs
	bl oppositesigns
	mov oppositeSigns, r0 
	// Get the absolute value of the first number
	bl abs
	mov r1, r0
	// Get the absolute value of the second number
	mov r1, r2
	bl abs
	mov r2, r0
	// Start the product off at 0
	mov product, #0
	_while__r1gtz:
		// Exit loop if r1 <= 0
		cmp r1, #0
		ble _endwhile__r1gtz
		// Accumulate the other number into the product
		adds product, product, r2
		// Check for overflow
		bvs _end
		// Decrement the number
		sub r1, r1, #1
		// Branch back to loop start
		bal _while__r1gtz
	_endwhile__r1gtz:
	// If the two numbers have opposite signs, negate the product
	cmp oppositeSigns, #0
	bgt _if__oppositesigns
	bal _end 
	_if__oppositesigns:
		mov r1, product
		bl negate
	_end:
	// Pop values of registers off of stack
	pop {r1, r2, pc}