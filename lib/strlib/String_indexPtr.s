.global String_indexPtr

/*
r0 String_indexPtr(r1 str, r2 index)
------------------------------------
Get a pointer to the point in the string
indexed by r2. If index points outside
the string, r0 = 0 (nullptr)

Negative value in r2 simply returns r1
------------------------------------
*/

String_indexPtr:
	mov r0, r1
	_while__index_gt_zero:
		// Load the current byte of r0 in r3
		ldrb r3, [r0]
		// If r3 currently stores the null terminator, 
		// the index is out of range of the string
		cmp r3, #0
		beq _if__index_out_of_range
		// Compare index with zero
		cmp r2, #0
		// If index is negative, it is out of range
		blt _if__index_out_of_range
		// If index is equal to zero, we've finished the routine
		beq _end
		// Decrement the index
		sub r2, r2, #1
		// Increment the string pointer
		add r0, r0, #1
		bal _while__index_gt_zero
	_if__index_out_of_range:
		// Move 0 into r0 if index is out of range
		mov r0, #0
	_end:
		bx lr
