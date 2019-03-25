.global idiv

.data
// REGISTER TABLE
quotient 	 	.req r0
divisor 		.req r1
dividend		.req r2
absDivisor		.req r3
absDividend		.req r4
oppositeSign 	.req r5

/*
r0 idiv(r1 divisor, r2 dividend)
--------------------------------
Return the result of the integer division r1 / r2
oVerflow flag is set if dividend is zero
--------------------------------
*/

.text
.balign 4
idiv:
	// Preserve register contents on the stack
	push {r1-r12, lr}

	/*
	PRECHECK divide by zero
	-----------------------
	If dividend is zero, set the overflow flag and branch to end
	-----------------------
	*/

	cmp dividend, #0 
	beq _if__divbyzero
	bal _endif__divbyzero
	_if__divbyzero:
		// Set the overflow flag
		bl setv
		// Branch to the end
		bal _end
	_endif__divbyzero:

	/*
	SETUP oppositeSign flag
	-----------------------
	oppositeSign = 1 if divisor and dividend have opposite signs
	oppositeSign = 0 if divisor and dividend have the same signs
	-----------------------
	*/
	// Preserve r0-r2 for use as arguments in the next subroutine
	push {r0-r2}
	// Check to see if divisor and dividend have opposite signs
	mov r1, divisor
	mov r2, dividend
	bl oppositesigns
	// Store result of subroutine
	mov oppositeSign, r0
	// Restore r0-r2 with data previously pushed onto stack
	pop {r0-r2}

	/*
	FUNCTION BODY
	-------------
	Start r3 = abs(r1). Repeatedly subtract abs(r2) until
	r3 <= 0.  Increment quotient for each subtraction
	-------------
	*/

	// Initialize r0, the loop counter
	mov quotient, #0

	// Store the absolute value of the divisor
	mov absDivisor, divisor
	cmp absDivisor, #0
	// Branch to correct if header
	ble _if__absdivisorneg
	bal _endif__absdivisorneg
	// If value is negative, subtract and move the logical negative
	_if__absdivisorneg:
		sub absDivisor, #1
		mvn absDivisor, absDivisor
	_endif__absdivisorneg:

	// Store the absolute value of the dividend
	mov absDividend, dividend
	cmp absDividend, #0
	// Branch to correct if header
	ble _if__absdividendneg
	bal _endif__absdividendneg
	// If value is negative, subtract and move the logical negative
	_if__absdividendneg:
		sub absDividend, #1
		mvn absDividend, absDividend
	_endif__absdividendneg:

	// Loop while the divisor is greater than or equal to zero
	_while__absdivisor_gez:
		// Subtract the dividend from the divisor, and compare them
		subs absDivisor, absDivisor, absDividend
		// Branch to end if divisor < 0
		blt _endwhile__absdivisor_gez
		// Increment quotient
		add quotient, quotient, #1
		// Branch back to start of loop
		bal _while__absdivisor_gez
	_endwhile__absdivisor_gez:
	
	/*
	FINAL CLEANUP
	-------------
	If the divisor/dividend have opposite signs, invert the quotient
	-------------
	*/

	// If opposite sign flag is set, branch to if
	// Otherwise, branch past if
	cmp oppositeSign, #1
	beq _if__oppositesign_b
	bal _endif__oppositesign_b
	// If signs are opposite, negate the quotient
	_if__oppositesign_b:
		sub quotient, #1
		mvn quotient, quotient
	_endif__oppositesign_b:

	_end:
		pop {r1-r12, pc}
