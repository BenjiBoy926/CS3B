.global _start

.data
str:	.asciz "Hello, world!"

.text
.balign 4
_start:
	ldr r1, =str
	bl String_length

	mov r1, r0
	ldr r0, =str
	bl Node

	mov r0, #0
	mov r7, #1
	svc 0
