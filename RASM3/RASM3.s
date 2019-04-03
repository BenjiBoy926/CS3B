.global _start

.data
str1:	.asciz "Hello"
str2:	.asciz ""
str3:	.asciz "wat dee frick"

.text
.balign 4
_start:
	ldr r1, =str1
	bl String_length

	ldr r1, =str2
	bl String_length

	ldr r1, =str3
	bl String_length

	mov r0, #0
	mov r7, #1
	swi 0
	.end