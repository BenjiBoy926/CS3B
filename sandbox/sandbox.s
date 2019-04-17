.global _start

.data
filename:	.asciz "input.txt"
str:		.skip 512 

.text
.balign 4
_start:
    ldr r0, =filename
	mov r1, #0
	mov r2, #0
	
	mov r7, #5
	svc 0

	ldr r1, =str
	mov r2, #13
	
	mov r7, #3
	svc 0
    	
	mov r0, #0
	mov r7, #1
	svc 0
    .end

