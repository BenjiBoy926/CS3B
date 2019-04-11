.global memcpy

/*
void memcpy(r1 source, r2 destination, r3 bytes)
------------------------------------------------
Copy the source byte-for-byte into the destination
------------------------------------------------
*/

memcpy:
	_mem__while__bytes_not_zero:
		// If number of bytes to copy is currently zero, branch to end
		cmp r3, #0
		ble _mem__end
		// Load the byte at r1 into r0,
		// then store r0 into the byte at r2
		ldrb r0, [r1], #1
		strb r0, [r2], #1
		// Decrement r3
		sub r3, r3, #1
		bal _mem__while__bytes_not_zero
	_mem__end:
		bx lr