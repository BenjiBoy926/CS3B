.global _start

.data
str1:	.asciz "Hello, world!"
str2:	.asciz "How are you, world?!"
str3:	.asciz "I'm good, how are you, Codey?!"

.text
.balign 4
_start:
	// Construct a list
	bl List
	mov r4, r0

	// Get the length of str1
	ldr r1, =str1
	bl strlen
	mov r5, r0

	// Add str1 to the list
	mov r0, r4
	ldr r1, =str1
	add r2, r5, #1
	bl List_add

	// Get the length of str1
	ldr r1, =str2
	bl strlen
	mov r5, r0

	// Add str2 to the list
	mov r0, r4
	ldr r1, =str2
	add r2, r5, #1
	bl List_add

	// Get the length of str1
	ldr r1, =str3
	bl strlen
	mov r5, r0

	// Add str3 to the list
	mov r0, r4
	ldr r1, =str3
	add r2, r5, #1
	bl List_add

	mov r0, #0
	mov r7, #1
	svc 0
