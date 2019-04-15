.global String_indexOfString

/*
r0 String_indexOfString(r1 str, r2 otherStr)
--------------------------------------------
Find the index of the other string in this string
--------------------------------------------
*/

String_indexOfString:
	// Preserve registers from calling routine
	push {r4-r5, lr}
	// Get the length of the first string
	push {r1, r2}
	bl strlen
	mov r4, r0
	pop {r1, r2}
	// Get the length of the other string
	push {r1, r2}
	mov r1, r2
	bl strlen
	pop {r1, r2}
	// If the first string is smaller than the second,
	// return string not found
	mov r5, r0
	cmp r4, r5
	blt ios__if__string_not_found
	// Use r3 as the current index
	mov r3, #0
	ios__while__byte_not_null:
		// Load the next byte of the bigger string into r4
		ldrb r4, [r1]
		// If this byte is the null terminator, the string was not found
		cmp r4, #0
		beq ios__if__string_not_found
		// Compare string at r1 with string at r2
		push {r1, r2}
		bl String_compare
		pop {r1, r2}
		// If strings are equal, we found the string
		cmp r0, #1
		beq ios__if__string_found
		// Increment the index and the current string being checked
		add r3, r3, #1
		add r1, r1, #1
		bal ios__while__byte_not_null
	// If string is found, return r3, the index
	ios__if__string_found:
		mov r0, r3
		bal ios__end
	// If string not found, return -1
	ios__if__string_not_found:
		mvn r0, #0
	ios__end:
		pop {r4-r5, pc}
