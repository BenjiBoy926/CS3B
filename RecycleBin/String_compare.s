.global String_compare

/*
r0 String_stringCompare(r1 str, r2 otherStr)
--------------------------------------------
Compare the two strings. r0 = 1 if they are equal 
and 0 if they are unequal

NOTE: this routine returns true even if one string
is null terminated while the other has trailing
characters.  Thus it may be more accurate to say that the
function returns true if one string is found directly
at the beginning of the other
--------------------------------------------
*/

String_compare:
	// Preserve r4, r5 and the link register
	push {r4, r5, lr}
	_while__bytes_equal__AND__neither_null_encountered:
		// Store bytes pointed to by r1 and r2 in r4 and r5, respectively
		ldrb r4, [r1], #1
		ldrb r5, [r2], #1
		// Branch to label if the current byte of either
		// string is the null terminator
		cmp r4, #0
		beq _if__either_null_encountered
		cmp r5, #0
		beq _if__either_null_encountered
		// Compare the two bytes together
		cmp r4, r5
		bne _if__bytes_unequal
		// Branch back to the start of the loop
		bal _while__bytes_equal__AND__neither_null_encountered
	// Branch here if we reached the end of either string
	// before finding unequal characters
	_if__either_null_encountered:
		mov r0, #1
		bal cmp__end
	// Branch here if unequal bytes are found in the strings
	_if__bytes_unequal:
		mov r0, #0
	cmp__end:
		// Restore r4/r5 and put lr value in the pc
		pop {r4, r5, pc}
