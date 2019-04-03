.global String_indexOfFrom

/*
r0 String_indexOfFrom(r1 str, r2 ch, r3 startIndex)
---------------------------------------------------
Search the string for the given character starting 
at the given index
---------------------------------------------------
*/

String_indexOfFrom:
	// Preserve r2 and link register
	push {lr, r2}
	// Get a pointer to the part of the string
	// starting at the index
	mov r2, r3
	bl String_indexPtr
	// Restore r2, preserve r3
	pop {r2}
	push {r3}
	// Find the index of the character
	// starting at the part of the string
	// in the index specified
	mov r1, r0
	bl String_indexOf
	// Restore r3
	pop {r3}
	// If r0 = -1, branch to end and return it
	cmp r0, #0xffffffff
	beq _end
	// Add the starting index to the index in the other string
	add r0, r0, r3
	_end:
		// Pop the preserved lr into the program counter
		pop {pc}
