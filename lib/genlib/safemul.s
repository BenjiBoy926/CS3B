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
	// Push r1 onto the stack so it can be used as an argument
	push {r1}
	// Get the absolute value of the second number
	mov r1, r2
	bl abs
	mov r2, r0
	// Pop r1 now that the subroutine is finished using it
	pop {r1}
	// Start the product off at 0
	mov product, #0
	safemul__while__r1gtz:
		// Exit loop if r1 <= 0
		cmp r1, #0
		ble safemul__endwhile__r1gtz
		// Accumulate the other number into the product
		adds product, product, r2
		// Check for overflow
		bvs safemul__end
		// Decrement the number
		sub r1, r1, #1
		// Branch back to loop start
		bal safemul__while__r1gtz
	safemul__endwhile__r1gtz:
	// If the two numbers have opposite signs, negate the product
	cmp oppositeSigns, #0
	bgt safemul__if__oppositesigns
	bal safemul__end 
	safemul__if__oppositesigns:
		mov r1, product
		bl negate
	safemul__end:
	// Pop values of registers off of stack
	pop {r1, r2, pc}
