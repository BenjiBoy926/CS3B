.global _start

.data
// Strings to test
str1: .asciz "Hello!"
str2: .asciz "I'm Codey!"
str3: .asciz ""
// Prompts precedng output
strprompt:		.asciz "String:        "
strlenprompt:	.asciz "String length: "
// Endline ascii code
endl:	.byte 10
// Memory stores the string length as a string
lenstr:	.skip 13

.text
.balign 4
_start:
	// Output the first string to test
	ldr r1, =strprompt
	bl putstring
	ldr r1, =str1
	bl putstring
	ldr r1, =endl
	bl putch
	// Get the length of the string
	bl String_length
	// Output the length of the string
	ldr r1, =strlenprompt
	bl putstring
	ldr r1, =lenstr
	bl intasc32
	bl putstring
	ldr r1, =endl
	bl putch
	ldr r1, =endl
	bl putch

	// Output the second string to test
	ldr r1, =strprompt
	bl putstring
	ldr r1, =str2
	bl putstring
	ldr r1, =endl
	bl putch
	// Get the length of the string
	bl String_length
	// Output the length of the string
	ldr r1, =strlenprompt
	bl putstring
	ldr r1, =lenstr
	bl intasc32
	bl putstring
	ldr r1, =endl
	bl putch
	ldr r1, =endl
	bl putch

	// Output the third string to test
	ldr r1, =strprompt
	bl putstring
	ldr r1, =str3
	bl putstring
	ldr r1, =endl
	bl putch
	// Get the length of the string
	bl String_length
	// Output the length of the string
	ldr r1, =strlenprompt
	bl putstring
	ldr r1, =lenstr
	bl intasc32
	bl putstring
	ldr r1, =endl
	bl putch
	ldr r1, =endl
	bl putch

	mov r0, #0
	mov r7, #1
	swi 0
	.end
