.global _start

.text
.balign 4
_start:
	bl List

	mov r0, #0
	mov r7, #1
	svc 0
