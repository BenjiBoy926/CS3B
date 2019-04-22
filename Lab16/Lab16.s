.global _start

.data
filename:	.asciz "output.txt"
string:		.asciz "cat in the hat\n"

.text
.balign 4
_start:
	// Linux syscall to open the file with the name
	ldr r0, =filename
	mov r1, #0101
	mov r2, #0777
	mov r7, #5
	svc 0
	mov r4, r0

	// Get the length of the string
	ldr r1, =string
	bl strlen
	mov r5, r0

	// Write to the file
	mov r0, r4
	ldr r1, =string
	mov r2, r5
	mov r7, #4
	svc 0

	mov r0, #0
	mov r7, #1
	svc 0
