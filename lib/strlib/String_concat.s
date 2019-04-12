.global String_concat

// Help the linker resolve the reference to malloc
.extern malloc

/*
r0 String_concat(r1 str1, r2 str2)
----------------------------------
Return a pointer to a dynamically allocated string 
with the characters in r1 followed by the characters in r2
----------------------------------
REGISTER TABLE:
	r4 = str1
	r5 = str2
	r6 = str1Len
	r7 = str2Len
	r8 = newString
----------------------------------
*/

String_concat:
	// Preserve arguments and the link register
	push {r4-r7, lr}
	mov r4, r1
	mov r5, r2
	// Get the length of string r1 and put it into r4
	mov r1, r4
	bl strlen
	mov r6, r0
	// Get the length of string in r2
	mov r1, r5
	bl strlen
	mov r7, r0
	// Allocate memory the size of both strings,
	// plus one for the null terminator
	add r0, r6, r7
	add r0, r0, #1
	bl malloc
	mov r8, r0
	// Copy first string (r4) into destination (r8)
	mov r1, r4
	mov r2, r8
	mov r3, r6
	bl memcpy
	// Copy second string (r5) into part of destination 
	// just beyond the first string (r8 + r6)
	mov r1, r5
	add r2, r8, r6
	add r3, r7, #1
	bl memcpy
	// Restore registers, putting preserved link register contents
	// into the program counter
	pop {r4-r7, pc}
