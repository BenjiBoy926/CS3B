.global _start

.data
// Ints input by user as strings
strInt1:	.skip 13
strInt2:	.skip 13
// String used to display the operation "# % # = "
operationStr:	.skip 40
// Result of the calculation with user input
resultStr:	.skip 13

// Used to output an equation
mod:	.asciz " % "
eq:		.asciz " = "

// String that introduces all registers
register_output_prompt:	.asciz "Contents of registers after mod routine:\n"

// Strings that introduce registers
register_prefixes:
.asciz "R4 = "
.asciz "R5 = "
.asciz "R6 = "
.asciz "R7 = "
.asciz "R8 = "
.asciz "R10 = "
.asciz "R11 = "
end_register_prefixes:

// Output if dividing by zero
div_by_zero_prompt:	.asciz "Cannot divide by zero\n"

endl:	.byte 10

sentinel 	.req r4
lcv 		.req r5
oper1 		.req r6
oper2 		.req r7
mod 		.req r8

.text
.balign 4
_start:
	mov lcv, #1
	mov sentinel, #3

	exm3__while__lcv_le_sentinel:
		// Compare loop control with sentinel value
		cmp lcv, sentinel
		bgt exm3__endwhile

		// Get operand one and two
		bl GetIntInput
		mov oper1, r0
		bl GetIntInput
		mov oper2, r0

		// Get the remainder oper1 % oper2
		mov r1, oper1
		mov r2, oper2
		bl remainder
		mov mod, r0

		// Check and store whether vs is set/clear
		bvs exm3__if__vs_set
		bal exm3__elif__vs_clear

		exm3__if__vs_set:
			mov r9, #1
			bal exm3__endif__vs_set
		exm3__elif__vs_clear:
			mov r9, #0
		exm3__endif__vs_set:

		// Output the mod equation
		mov r0, oper1
		mov r1, oper2
		bl out_mod_eq

		// Check if vs was set or clear
		cmp r9, #0
		beq exm3__if__div_clear
		bal exm3__elif__div_by_zero

		// Put correct output for result or div by zero error
		exm3__if__div_clear:
			mov r0, mod
			ldr r1, =resultStr
			bl intasc32
			ldr r1, =resultStr
			bl putstring
			ldr r1, =endl
			bl putch
			bal exm3__endif__div_clear
		exm3__elif__div_by_zero:
			ldr r1, =div_by_zero_prompt
			bl putstring
		exm3__endif__div_clear:

		ldr r1, =endl
		bl putch

		// Update loop control
		add lcv, lcv, #1
		bal exm3__while__lcv_le_sentinel
	exm3__endwhile:

	mov r0, #0
	mov r7, #1
	svc 0

/*
void out_mod_eq(r0 oper1, r1 oper2)
*/
out_mod_eq:
	push {r4-r8, r10-r12, lr}
	
	// preserve arguments
	mov r4, r0
	mov r5, r1
	mov r6, r2

	mov r0, r4
	ldr r1, =strInt1
	bl intasc32
	mov r0, r5
	ldr r1, =strInt2
	bl intasc32

	ldr r1, =strInt1
	bl putstring
	ldr r1, =mod
	bl putstring
	ldr r1, =strInt2
	bl putstring
	ldr r1, =eq
	bl putstring

	pop {r4-r8, r10-r12, pc}
