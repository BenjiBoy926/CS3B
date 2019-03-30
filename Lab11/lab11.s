.global _start

.data
bVal1:	.byte -8
bVal2:	.byte 6
sVal1:	.hword -126
sVal2:	.hword 125

.text
.balign 4
_start:
	// Grab bVal1
	ldr r4, =bVal1
	ldrb r4, [r4]
	// Convert bVal1 to halfword
	mov r1, r4
	bl cbh
	// Store converted value in r5
	mov r5, r0
	// Grab bVal2
	ldr r4,=bVal2
	ldrb r4, [r4]
	// Convert bVa2 to halfword
	mov r1, r4
	bl cbh
	// Store converted value in r5
	mov r6, r0
	// Grab sVal1
	ldr r4, =sVal1
	ldrh r4, [r4]
	// Convert sVal1 to a word
	mov r1, r4
	bl chw
	// Store converted sVal1 in r7
	mov r7, r0
	// Grab sVal1
	ldr r4, =sVal2
	ldrh r4, [r4]
	// Convert sVal1 to a word
	mov r1, r4
	bl chw
	// Store converted sVal1 in r7
	mov r8, r0
	// Grab bVal1
	ldr r4, =bVal1
	ldrb r4, [r4]
	// Convert bVal1 to halfword
	mov r1, r4
	bl cbh
	// Store converted value in r5
	mov r9, r0
	// Grab bVal1
	ldr r4, =bVal1
	ldrb r4, [r4]
	// Convert bVal1 to halfword
	mov r1, r4
	bl cbh
	// Store converted value in r5
	mov r10, r0
	// Terminate the program
	mov r0, #0
	mov r7, #1
	swi 0
	.end