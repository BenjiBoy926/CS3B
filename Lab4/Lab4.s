.global _start

.balign 4
.data
var1: .word 0
var2: .word 0

.balign 4
.text
_start:
	# Store "3" in the data block at "var1"
	ldr r1, =var1
	mov r3, #3
	str r3, [r1]
	# Store "4" in the data block at "var2"
	ldr r2, =var2 
	mov r3, #4
	str r3, [r2]
	# Store the updated contents of the data block at "var1" into register 1 
	ldr r1, =var1 
	ldr r1, [r1]
	# Store the update contents of the data block at "var2" into register 2
	ldr r2, =var2 
	ldr r2, [r2]
	# Add the update contents of the data blocks "var1" and "var2"
	add r0, r1, r2
	# Signal Linux to terminate the program
	mov r1, #0
	mov r7, #1
	svc 0
	
