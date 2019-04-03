.global _start

.data
str1:	.asciz "Hello"
str2:	.asciz "Hellotherehowareyou"
str3:	.asciz "we Hello there"
str4:	.asciz "Hello"

.text
.balign 4
_start:
	ldr r1, =str1
	ldr r2, =str4
	bl String_compare

	ldr r1, =str1
	ldr r2, =str2
	bl String_compare

	ldr r1, =str1
	ldr r3, =str3
	bl String_compare

	mov r0, #0
	mov r7, #1
	swi 0
	.end

