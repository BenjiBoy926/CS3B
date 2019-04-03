.global _start
.global _end

.data
.balign
bvar: 	.byte 0xff
hvar:	.hword 0xae62
ivar: 	.word 0xce004a32
str: 	.asciz "Hi, there!\n"

.text
.balign 4
_start:
    	ldr r1, =bvar
	ldr r1, [r1]
	
	ldr r1, =bvar
	ldrh r1, [r1]

	ldr r1, =bvar
	ldr r1, [r1] 
    	
	mov r0, #0
	mov r7, #1
	svc 0
    	.end

