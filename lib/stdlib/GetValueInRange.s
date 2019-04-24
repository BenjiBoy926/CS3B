.global GetIntInputInRange

.data 
// Feedback displayed if user enters invalid option
inputInvalidPrompt:	.asciz "*** ERROR: input out of valid range ***"

/*
r0 GetValueInRange(r0 min, r1 max, r2 valueGenerator)
-----------------------------------------------------
Return a value in r0 gotten from user input
that is in the range of [min, max]. Additionally
checks overflow and if the string is a valid int

The routine obtains a value by branching to the subroutine
at the address specified in r2.  The routine sould have
this signature:
	r0 generator()

Returns the value generated in r0
----------------------------------------------------
*/

.text
.balign 4
GetValueInRange:
	push {r4-r8, r10-r12, lr}

	// Preserve arguments
	mov r4, r0
	mov r5, r1
	mov r6, r2

	rasm4__while__input_out_of_range:
		// Generate a value and store it in r7
		bxl r6
		mov r7, r0
		
		// Check to see if the integer input is a valid option
		mov r7, r6
		mov r2, r4
		mov r3, r5
		bl inrange
		
		// If input out of range, loop again
		cmp r0, #0
		beq rasm4__if__input_out_of_range

		// If input in range, branch out of input loop
		bal rasm4__endwhile__input_out_of_range

		// If input is out of range, give user feedback
		rasm4__if__input_out_of_range:
			ldr r1, =inputInvalidPrompt
			bl putstring
			bal rasm4__while__input_out_of_range
	rasm4__endwhile__input_out_of_range:

	// Move the int input back into return register
	mov r0, r7

	pop {r4-r8, r10-r12, pc}
	