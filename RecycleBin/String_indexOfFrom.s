.global String_indexOfFrom

/*
r0 String_indexOfFrom(r1 str, r2 ch, r3 startIndex)
---------------------------------------------------
Search the string for the given character starting 
at the given index
---------------------------------------------------
*/

String_indexOfFrom:
	// Preserve r2, r3 and link register
	push {r2-r3, lr}
	// Get a pointer to the part of the string
	// starting at the index
	mov r2, r3
	bl String_indexPtr
	// Restore r2 and r3
	pop {r2-r3}	
	// If indexPtr returned null pointer,
	// the index is out of range of the string
	cmp r0, #0
	beq iof__if__index_out_of_range
	// Preserve r3 so it is not modified in the next subroutine
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
	beq iof__end
	// Add the starting index to the index in the other string
	add r0, r0, r3
	bal iof__end
	// If index given is out of range, 
	// return = -1
	iof__if__index_out_of_range:
		mvn r0, #0
	iof__end:
		// Pop the preserved lr into the program counter
		pop {pc}
