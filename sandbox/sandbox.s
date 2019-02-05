.global _start
.global _end

.data
.balign 4
var: .word 4

.text
.balign 4
_start:
    	ldr r1, =var
    	
	mov r7, #1
	svc 0
    	.end

