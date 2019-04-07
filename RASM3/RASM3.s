.global _start

.data
str1a:	.asciz "HEllo"
str1b:	.asciz "HEllo"
str2a: 	.asciz "12345"
str2b:	.asciz "12345"
str3a:	.asciz "Hello nUMBer 123"
str3b:	.asciz "Hello nUMBer 123"
endl:	.byte 10

.text
.balign 4
_start:
	ldr r1, =str1a
	bl TestString1
	ldr r1, =str1b
	bl TestString2
	
	ldr r1, =str2a
	bl TestString1
	ldr r1, =str2b
	bl TestString2

	ldr r1, =str3a
	bl TestString1
	ldr r1, =str3b
	bl TestString2

	mov r0, #0
	mov r7, #1
	swi 0
	.end

