.global _start

.data
str1:	.asciz "Hello"
str2:	.asciz "Hellotherehowareyou"
str3:	.asciz "we Hello there"
str4:	.asciz "Hello"
str5:	.asciz "wat dee frick"

.text
.balign 4
_start:
	ldr r1, =str2
	ldr r2, =str1
	bl String_indexOfString

	ldr r1, =str1
	ldr r2, =str2
	bl String_indexOfString

	ldr r1, =str3
	ldr r2, =str1
	bl String_indexOfString

	ldr r1, =str1
	ldr r2, =str1
	bl String_indexOfString

	ldr r1, =str5
	ldr r2, =str1
	bl String_indexOfString

	mov r0, #0
	mov r7, #1
	swi 0
	.end

