.global String_indexOfString

/*
r0 String_indexOfString(r1 str, r2 otherStr)
--------------------------------------------
Find the index of the other string in this string
--------------------------------------------
*/

String_indexOfString:
	push {r1-r2, r4-r5, lr}
	// Get the length of the first string
	bl String_length
	mov r4, r0
	// Get the length of the other string
	mov r1, r2
	bl String_length
	// If the first string is smaller than the second,
	mov r5, r0
	cmp r4, r5
	//blt // end
	// Initialize r3. 
	// R3 points to the part of the bigger string we are currently
	// comparing to the smaller string
	mov r3, r1

