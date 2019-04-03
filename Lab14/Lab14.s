.global _start

_start:
	mov r1, #0
	bl factorial

	mov r1, #1
	bl factorial

	mov r1, #2
	bl factorial

	mov r1, #6
	bl factorial

	mvn r1, #3
	bl factorial

	mov r0, #0
	mov r7, #1
	swi 0
	.end