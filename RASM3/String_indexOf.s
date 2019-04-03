.global String_indexOf

/*
r0 String_indexOf(r1 str, r2 ch)
--------------------------------
Find the byte in r2 in the sequence of bytes
pointed to by r1
--------------------------------
*/

String_indexOf:
	mov r0, #0
	mov r3, r1
	_while__bytenotequal:
		// Load the byte pointed to by r1
		// Increment r1's address after
		ldrb r3, [r1], #1
		// If the current byte is zero,
		// we reached the end of the string, 
		// and the byte could not be found
		cmp r3, #0
		beq _if__bytenotfound
		// Branch to the end if current byte matches
		cmp r3, r2
		beq _end
		// Increment each time an unequal byte is compared
		add r0, r0, #1
		bal _while__bytenotequal
	_if__bytenotfound:
		// If byte was not found, return value is -1
		mvn r0, #0
	_end:
		bx lr