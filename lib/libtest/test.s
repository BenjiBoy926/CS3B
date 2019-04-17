.global _start

.data
str1:	.asciz "Hello, world!"
str2:	.asciz "How are you, world?!"
str3:	.asciz "I'm good, how are you, Codey?!"
find:	.asciz "heLLo"
cCR:	.byte 10

.text
.balign 4
_start:
	// Construct a list
	bl List
	mov r4, r0

	mov r0, r4
	ldr r1, =str1
	bl List_addstr

	mov r0, r4
	ldr r1, =str2
	bl List_addstr

	mov r0, r4
	ldr r1, =str3
	bl List_addstr

	mov r0, r4
	ldr r1, =find
	ldr r2, =String_containsIgnoreCase
	ldr r3, =putstring_and_endline
	bl List_foreachcmp

	mov r0, #0
	mov r7, #1
	svc 0

// (r1 = string)
putstring_and_endline:
	push {lr}
	bl putstring
	ldr r1, =cCR
	bl putch
	pop {pc}
