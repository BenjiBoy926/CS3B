.global setv

/*
void setv()
-----------
Set the overflow flag
-----------
*/

setv:
	// Push registers locally used onto the stack
	push {r0, r1, r2, lr}
	// Simultaneously set CARRY and OVERFLOW
	mov r1, #0x80000000
	mov r2, #0x1
	subs r0, r1, r2
	// Clear CARRY without changing OVERFLOW
	mov r1, #0x10
	asrs r1, #1
	// Pop registers locally used off of the stack
	pop {r0, r1, r2, pc}
