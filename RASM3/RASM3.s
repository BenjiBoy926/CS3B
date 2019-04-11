.global _start

.data
str1:	.asciz "HEllo"
str2: 	.asciz "12345"
str3:	.asciz "Hello nUMBer 123"
endl:	.byte 10

.text
.balign 4
_start:
	ldr r1, =str1
	bl putstring
	ldr r1, =endl
	bl putch

	ldr r1, =str2
	bl putstring
	ldr r1, =endl
	bl putch

	ldr r1, =str1
	ldr r2, =str2
	bl String_concat
	mov r1, r0
	bl putstring
	ldr r1, =endl
	bl putch

	mov r0, #0
	mov r7, #1
	swi 0
	.end

