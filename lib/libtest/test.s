.global _start

.data
str1:	.asciz "Hello, world!"
str2:	.asciz "How are you, world?!"
str3:	.asciz "I'm good, how are you, Codey?!"
str4:	.asciz "Now let's see here..."
str5:	.asciz "Ah! Now let's just hope it works...!"
find:	.asciz "WOrld"
replace:	.asciz "Will it change?"
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

	mov r0, #0
	mov r7, #1
	svc 0
