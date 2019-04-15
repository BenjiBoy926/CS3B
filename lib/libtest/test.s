.global _start

.data
str1:	.asciz "taut"
str2:	.asciz "Cat in the Hat"
str3:	.asciz "cradle"
substring:	.asciz "at"

.text
.balign 4
_start:
	ldr r1, =str3
	mov r2, #'c'
	mov r3, #0
	bl String_lastIndexOfFrom

	ldr r1, =str3
	mov r2, #'c'
	mov r3, #1
	bl String_lastIndexOfFrom

	ldr r1, =str2
	ldr r2, =substring
	bl String_lastIndexOfString

	mov r0, #0
	mov r7, #1
	svc 0
