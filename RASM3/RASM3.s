.global _start

.data
str1:	.asciz "Hello"
str2: 	.asciz "I are I"
endl:	.byte 10

.text
.balign 4
_start:
	// Put the string
	ldr r1, =str1
	bl putstring
	ldr r1, =endl
	bl putch
	// Replace 'l' with 'k' in "Hello"
	ldr r1, =str1
	mov r2, #'l'
	mov r3, #'k'
	bl String_replace
	// Display the string
	ldr r1, =str1
	bl putstring
	ldr r1, =endl
	bl putch
	ldr r1, =endl
	bl putch

	// Put the string
	ldr r1, =str2
	bl putstring
	ldr r1, =endl
	bl putch
	// Replace 'I' with 'y' in "I are I"
	ldr r1, =str2
	mov r2, #'I'
	mov r3, #'y'
	bl String_replace
	// Display the string
	ldr r1, =str2
	bl putstring
	ldr r1, =endl
	bl putch
	ldr r1, =endl
	bl putch

	// Put the string
	ldr r1, =str1
	bl putstring
	ldr r1, =endl
	bl putch
	// Replace 'l' with 'k' in "Hello"
	ldr r1, =str1
	mov r2, #'z'
	mov r3, #'6'
	bl String_replace
	// Display the string
	ldr r1, =str1
	bl putstring
	ldr r1, =endl
	bl putch
	ldr r1, =endl
	bl putch

	mov r0, #0
	mov r7, #1
	swi 0
	.end

