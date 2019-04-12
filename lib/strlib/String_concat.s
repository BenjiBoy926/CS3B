.global String_concat

// Help the linker resolve the reference to malloc
.extern malloc

/*
r0 String_concat(r1 str1, r2 str2)
----------------------------------
Return a pointer to a dynamically allocated string 
with the characters in r1 followed by the characters in r2
----------------------------------
*/

String_concat:
	// Preserve arguments and the link register
	push {r1, r2, r4, r5, lr}
	// Get the length of string r1 and put it into r4
	bl strlen
	pop {r1, r2}
	mov r4, r0
	// Get the length of string in r2
	mov r1, r2
	push {r1, r2}
	bl strlen
	pop {r1, r2}
	mov r5, r0
	// Allocate memory the size of both strings,
	// plus one for the null terminator
	add r0, r4, r5
	add r0, r0, #1
	push {r1, r2}
	bl malloc
	pop {r1, r2}
	// Copy data from r1 into r0
	mov r2, r0
	mov r3, r4
	push {r0-r2}
	bl memcpy
	pop {r0-r2}
	// Prepare arguments for memcpy: r1 = source
	mov r1, r2
	// Prepare arguments for memcpy: r2 = destination
	// Set destination to basePointer + sizeOfFirstString
	add r2, r0, r4
	// Prepare arguments for memcpy: r3 = bytes
	// Copy the number of characters in string two plus one for null terminator
	add r3, r5, #1
	// Copy string pointed to by r2 into
	// part of the string after r1
	push {r0}
	bl memcpy
	// Restore registers, putting preserved link register contents
	// into the program counter
	pop {r0, r4, r5, pc}
