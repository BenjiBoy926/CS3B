.global TestString2

.data
endl:	.byte 10

/*
void TestString2(r1 str)
------------------------
*/

.text
.balign 4
TestString2:
	push {r4, lr}
	mov r4, r1
	// Put the string
	mov r1, r4
	bl putstring
	ldr r1, =endl
	bl putch
	// Change cases in string
	mov r1, r4
	bl String_toLowerCase
	// Output string
	mov r1, r4
	bl putstring
	ldr r1, =endl
	bl putch
	// Change case in string the other way
	mov r1, r4
	bl String_toUpperCase
	// Output string
	mov r1, r4
	bl putstring
	ldr r1, =endl
	bl putch
	ldr r1, =endl
	bl putch
	pop {r4, pc}