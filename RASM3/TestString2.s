.global TestString2

/*
void TestString2(r1 str)
------------------------
*/

TestString2:
	push {r4, lr}
	mov r4, r1
	// Put the string
	mov r1, r4
	bl putstring
	ldr r1, =endl
	bl putch
	// Change cases in both strings
	mov r1, r4
	bl String_toLowerCase
	mov r1, r4
	bl String_toUpperCase
	// Display the string
	mov r1, r4
	bl putstring
	ldr r1, =endl
	bl putch
	ldr r1, =endl
	bl putch
	pop {r4, pc}