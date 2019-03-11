.global OutputCalculationResult

.data
// Max size the result can be - max number of digits in a number
// plus one for null terminator
.equ RESULTBUFF, 12
// Stores the return address
returnAddr:			.word 0
// Stores integer result as a string
resultStr:			.skip RESULTBUFF
// Store pointer to the string that describes the result
resultDescriptPtr: 	.word 0
// Store pointer to the string that describes an overflow error
overflowMsgPtr:		.word 0
// Endling character byte
.balign 4	
endl:	.byte 10

/*
(void) OutputCalculationResult(r0 result, r1 resultDescriptPtr, 
r2 overflowMsgPtr, cpsr status)
----------------------------------------------------------------
Output the result of a calculation, given a descriptor of the result, and a message if the calculation resulted in an overflow. The subroutine assumes
that the cpsr was updated when the result was calculated
----------------------------------------------------------------
MODS:
	r4
	r5
----------------------------------------------------------------
*/

.text
.balign 4
OutputCalculationResult:
	ldr r4, =returnAddr
	str lr, [r4]
	// Save the arguments before calling other subroutines
	mov r4, r1
	mov r5, r2
	// Check for an overflow error
    bvs _overflow
    // Convert r0 to a string
    ldr r1, =resultStr
    bl intasc32
    // Output message
    mov r1, r4
    bl putstring
    // Output the calculation result
    ldr r1, =resultStr
    bl putstring
    // Put an endline
    ldr r1, =endl
    bl putch
    bal _end
    _overflow:
        // Output the appropriate overflow error message
        mov r1, r5
        bl putstring
    _end:
		// Grab and go back to the stored return address
		ldr lr, =returnAddr
		ldr lr, [lr]
		bx lr
		.end
