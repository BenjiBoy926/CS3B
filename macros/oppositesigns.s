.global oppositesigns

flag	.req r0
num1	.req r1
num2	.req r2

/*
r0 oppositesigns(r1 num1, r2 num2)
----------------------------------
r0 = 0 if the numbers have opposite signs
r0 = 1 if the numbers have the same signs
0 counts as a positive number
----------------------------------
*/

oppositesigns:
	// Check to see if num1 is positive or negative
	cmp num1, #0
	bge _elif__num1pos
	// If r1 is negative, branch here
	_if__divisorneg:
		cmp num2, #0
		// If r2 is positive, they have opposite signs
		bge _if__oppositesign
		bal _elif__samesign
	// If r1 is positive, branch here
	_elif__num1pos:
		cmp dividend, #0
		// If r2 is positive, they have the same sign
		bge _elif__samesign
	// Branch here if divisor/dividend have opposite sign
	_if__oppositesign:
		mov flag, #1
		bal _endif__oppositesign
	// Branch here if divisor/dividend have same sign
	_elif__samesign:
		mov flag, #0
	_endif__oppositesign:
		bx lr
	