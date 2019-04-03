.global _start

_start:
	mov r1, #3
	bl factorial

	mov r0, #0
	mov r7, #1
	swi 0