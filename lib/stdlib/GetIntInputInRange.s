.global GetIntInputInRange

.data 
// Feedback displayed if user enters invalid option
inputInvalidPrompt:	.asciz "*** ERROR: please input a number between 1 and 7 ***\n"

/*
r0 GetIntInputInRange(r0 min, r1 max)
-------------------------------------
Return an integer in r0 gotten from user input
that is in the range of [min, max]. Additionally
checks overflow and if the string is a valid int
-------------------------------------
*/

.text
.balign 4
GetIntInputInRange:
	push {r4-r8, r10-r12, lr}

	// Preserve arguments
	mov r4, r0
	mov r5, r1

	rasm4__while__input_out_of_range:
		bl GetIntInput
		mov r6, r0
		
		// Check to see if the integer input is a valid option
		mov r1, r6
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
	mov r0, r6

	pop {r4-r8, r10-r12, pc}
	