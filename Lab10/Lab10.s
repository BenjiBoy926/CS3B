.global _start

_start:
	mov r0, #0x80000000
	mov r1, #0x80000001
	mov r2, #0x7fffffff
	mov r3, #0x7ffffffe
	mov r4, #0x0001e39e
	// Terminate the program
	mov r0, #1
	mov r7, #0
	swi 0