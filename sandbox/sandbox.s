.global _start
.global _end

.data
.balign
var: .word 4
str: .ascii "Hi, there!\n"

.text
.balign 4
_start:
    	ldr r1, =str
	mov r2, #11
	bl _stdout 
    	
	mov r7, #1
	svc 0
    	.end

