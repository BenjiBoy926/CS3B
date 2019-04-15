.global _start

.data
str1:	.asciz "taut"
str2:	.asciz "Cat in the Hat"

.text
.balign 4
_start:
	ldr r1, =str1
	mov r2, #'t'
	bl String_indexOf

	ldr r1, =str1
	mov r2, #'t'
	bl String_lastIndexOf

	ldr r1, =str1
	mov r2, #'t'
	bl String_lastIndexOf
	
	ldr r1, =str1
	mov r2, #'t'
	bl String_lastIndexOf

	mov r0, #0
	mov r7, #1
	svc 0
