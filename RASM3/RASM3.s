.global _start

.extern malloc
.extern free

_start:
	mov r0, #1
	bl malloc

	mov r0, #0
	mov r7, #1
	swi 0
	.end

