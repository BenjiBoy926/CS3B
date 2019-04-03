.global abs

absNum	.req r0
num		.req r1

/*
r0 abs(r1 num)
--------------
Return the absolute value of the number stored in r1
--------------
*/

abs:
	// Push the link register onto the stack
	push {lr}
	// Store the number and compare it to zero
	mov absNum, num
	cmp absNum, #0
	// Branch if number is negative
	ble _if__numneg
	bal _endif__numneg
	// If value is negative, negate r1 and store it in r0
	_if__numneg:
		bl negate
	_endif__numneg:
		// Pop lr's value off into pc
		pop {pc}
