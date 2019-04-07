.global TestString1

.data
endl:	.byte 10

/*
void TestString(r1 str)
-----------------------
*/

.text
.balign 4
TestString1:
	push {r4, lr}
	mov r4, r1
	// Put the string
	mov r1, r4
	bl putstring
	ldr r1, =endl
	bl putch
	// Change cases in both strings
	mov r1, r4
	bl String_toUpperCase
	// Output string
	mov r1, r4
	bl putstring
	ldr r1, =endl
	bl putch
	// Change case in string
	mov r1, r4
	bl String_toLowerCase
	// Output string
	mov r1, r4
	bl putstring
	ldr r1, =endl
	bl putch
	ldr r1, =endl
	bl putch
	pop {r4, pc}