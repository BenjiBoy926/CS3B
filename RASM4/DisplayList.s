.global DisplayList

.text
endl:	.byte 10

/*
void DisplayList(r0 list)
*/

.text
.balign 4
DisplayList:
	push {r4-r8, r10-r12, lr}

	// Store the pointer to the list
	mov r4, r0

	// Output endline
	ldr r1, =endl
	bl putch

	// Print the list
	mov r0, r4
	bl List_print

	// Output endline
	ldr r1, =endl
	bl putch

	pop {r4-r8, r10-r12, pc}