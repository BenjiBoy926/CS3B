/*
r0 =index String_indexOfIgnoreCase(r1 str, r2 otherStr)
-------------------------------------------------------
Find the index of the second string in the first string, 
ignoring case
-------------------------------------------------------
*/
.global String_indexOfIgnoreCase

/*
r0 =boolean String_containsIgnoreCase(r1 str, r2 otherStr)
----------------------------------------------------------
r0 = 1 if str contains otherStr and r0 = 0 if it doesn't
Ignore uppercase-lowercase difference
----------------------------------------------------------
*/
.global String_containsIgnoreCase

// Let the dynamic linker resolve references to free 
.extern free

.data
return0Str:	.asciz "Returning 0\n"
return1Str:	.asciz "Returning 1\n"

.text
.balign 4

// r0 =index String_indexOfIgnoreCase(r1 str, r2 otherStr)
String_indexOfIgnoreCase:
	push {r4-r8, r10-r12, lr}

	// Preserve arguments
	mov r4, r1
	mov r5, r2

	// Copy the first string
	bl String_copy
	mov r4, r0

	// Copy the second string
	mov r1, r5
	bl String_copy
	mov r5, r0

	// Force both copied strings to lowercase
	mov r1, r4
	bl String_toLowerCase
	mov r1, r5
	bl String_toLowerCase

	// Get the index of the second string in the first string
	mov r1, r4
	mov r2, r5
	bl String_indexOfString
	mov r6, r0

	// Free the memory of the string copies
	mov r0, r4
	bl free
	mov r0, r5
	bl free

	// Return r0, the index of the string
	mov r0, r6

	pop {r4-r8, r10-r12, pc}

// r0 =boolean String_containsIgnoreCase(r1 str, r2 otherStr)
String_containsIgnoreCase:
	push {r4-r8, r10-r12, lr}

	// Get the index of the first string in the other string
	bl String_indexOfIgnoreCase

	// Branch according to index of other string in this string
	cmp r0, #0
	bge strcontainsignore__if__index_not_negative
	bal strcontainsignore__if__index_negative

	// If index not negative, return 1
	strcontainsignore__if__index_not_negative:
		mov r0, #1
		ldr r1, =return1Str
		bl putstring
		bal strcontainsignore__end
	// If index is negative, return 0
	strcontainsignore__if__index_negative:
		mov r0, #0
		ldr r1, =return0Str
		bl putstring
	strcontainsignore__end:
		pop {r4-r8, r10-r12, pc}
