@ Subroutine String_length2: This method returns the number os characters in a string
@
@ Entering register contents:
@	R1: Contains the string
@	LR: Contains return address
@
@ Returned register contents:
@ 	R0: Returns with the length
@
@ All required AAPC registers are preserved, as well as R1 and R2

	.global 	String_length2

String_length2:
	push 	{R4-R8, R10-R11}
	push	{SP}
	push	{R1, R2, LR}	@ Saves all registers

	mov	r0, #0		@ Initialize counter

loop:
	ldrb	r2, [r1], #1

	cmp	r2, #0
	beq	return		@ If char equals null then return

	add	r0, #1
	b	loop

return:
	pop	{R1, R2, LR}
	pop	{SP}
	pop 	{R4-R8, R10-R11} @ Restores all registers

	bx	LR


@ Subroutine String_equals: This method checks if given string is equal to other string
@
@ Entering register contents:
@	R1: Contains the 1st string
@	R2: Contains the 2nd string
@	LR: Contains return address
@
@ Returned register contents:
@ 	R0: Returns with the boolean 
@
@ All required AAPC registers are preserved, as well as R1 through R3

	.global 	String_equals

String_equals:
	push 	{R4-R8, R10-R11}
	
	push	{SP}
	push	{R1-R3, LR}

	mov	r0, #1			@ Initialize boolean to true

loop1:
	ldrb	r3, [r1],#1
	ldrb	r4, [r2],#1

	cmp	r3, r4
	movne	r0, #0			@ If char1 is not equal to char2, then return false
	bne	return1

	cmp	r3, #0
	beq	return1			@ If char1 equals null then return

	b	loop1

return1:
	pop	{R1-R3, LR}
	pop	{SP}
	pop 	{R4-R8, R10-R11}
	bx	LR


@ Subroutine String_equalsIgnoreCase: This method will check to see whether two strings are equal to one another
@				      while being case incensitive
@
@ Entering register contents:
@	R1: Contains the 1st string
@	R2: Contains the 2nd string
@	LR: Contains return address
@
@ Returned register contents:
@ 	R0: Contains the boolean value whether the two strings are equal
@
@ All required AAPC registers are preserved, as well as R1 and R2

	.global 	String_equalsIgnoreCase

String_equalsIgnoreCase:
	push 	{R4-R8, R10-R11}
	
	push	{SP}
	push	{R1, R2, LR}

	bl	String_copy		@ Calls string copy and returns result into r0
	mov	r1, r0			@ Moves the value of r0 into r1
	bl	String_toLowerCase	@ The copy of the string is lowercased
	push	{r1}			@ Saves the copy of string1

	mov	r1, r2			@ Moves the 2nd string into r1
	bl	String_copy		@ Calls string copy and returns value into r0
	mov	r1, r0			@ Moves the value of r0 into r1
	bl	String_toLowerCase	@ The copy of the string is lowercased
	mov	r2, r1			@ Moves the copied string into r2

	pop	{r1}			@ Brings back copy of string1
	bl	String_equals		@ Calls string equals, if equal r0 will return 1, else 0

	pop	{R1, R2, LR}
	pop	{SP}
	pop 	{R4-R8, R10-R11}
	bx	LR


@ Subroutine String_copy: This method will create a new string that is a copy of the string passed into
@			  the function
@
@ Entering register contents:
@	R1: Contains the string to be copied
@	LR: Contains return address
@
@ Returned register contents:
@ 	R0: Returns with the new copied string
@
@ All required AAPC registers are preserved, as well as R1 and R2

	.global 	String_copy

String_copy:
	push 	{R4-R8, R10-R11}
	
	push	{SP}
	push	{R1, R2, LR}

	bl	String_length2	@ Calls string length and returns the length into r0
	bl	String_malloc	@ Creates a new dynamic string to store copy
	push	{r0}		@ Saves the new string

loop2:
	ldrb	r2, [r1], #1	@ Loads 1 character from r1 to new string r2
	
	cmp	r2, #0		@ Compares r2 with 0	
	beq	return2		@ If the character in r2 equals 0, then returns
	
	strb	r2, [r0], #1	@ Stores the charcter from r2 into our new string r0
	b	loop2		@ Branches back to top of loop

return2:
	pop	{r0}		@ Loads the new copied string to be returned
	pop	{R1, R2, LR}
	pop	{SP}
	pop 	{R4-R8, R10-R11}
	bx	LR


@ Subroutine String_substring_1: This method will return a string thats a substring between two given indeces
@
@ Entering register contents:
@	R1: Contains the string to be converted to a substring
@	R2: Contains the starting index
@	R3: Contains the ending index
@	LR: Contains return address
@
@ Returned register contents:
@ 	R0: Returns with the newly obtained substring
@
@ All required AAPC registers are preserved, as well as R1 through R3

	.global 	String_substring_1

String_substring_1:
	push 	{R4-R8, R10-R11}
	
	push	{SP}
	push	{R1-R3, LR}

	bl	String_length2		@ Gets the length of r0
	mov	r4, r0

	cmp	r2, r3
	bhi	bad_index3		@ Compares if starting index > end index

	cmp	r2, r4
	bhs	bad_index3		@ If startIndex >= length then bad index

	cmp	r3, r4
	bhs	bad_index3		@ If endIndex >= length then bad index

	sub	r0, r3, r2		@ R0 equals startIndex - endIndex
	add	r0, #1			@ R0 consists of indeces, we need string length
	bl	String_malloc		@ R0 equals address for substring

	add	r1 , r2			@ Offset the string by the starting index

	push	{R0}			@ Saves substring

loop3:
	ldrb	r4, [r1], #1
	strb	r4, [r0], #1

	cmp	r2, r3			@ Compares index equals startIndex
	beq	return3			@ If index equals endIndex then return

	add	r2, #1
	b	loop3			@ Branch to top of loop

bad_index3:
	bl	String_set_ovfl
	mov	r0, #0			@ Substring assigned to NULL

return3:
	pop	{R0}			@ Loads substring back into r0
	pop	{R1-R3, LR}
	pop	{SP}
	pop 	{R4-R8, R10-R11}
	bx	LR


@ Subroutine String_substring_2: This method returns a string that is a substring starting from given index
@				 to the end of the string
@
@ Entering register contents:
@	R1: Contains the string to be converted to a substring
@	R2: Contains the starting index
@	LR: Contains return address
@
@ Returned register contents:
@ 	R0: Returns with the newly obtained substring
@
@ All required AAPC registers are preserved, as well as R3

	.global 	String_substring_2

String_substring_2:
	push 	{R4-R8, R10-R11}
	
	push	{SP}
	push	{R3, LR}

	bl	String_length2		@ Gets the length of r0
	sub	r3 , r0, #1		@ assigns end index to length - 1

	bl	String_substring_1	@ gets the substring assigned to r0

	pop	{R3, LR}
	pop	{SP}
	pop 	{R4-R8, R10-R11}
	bx	LR


@ Subroutine String_charAt: This method returns a character at a given index
@
@ Entering register contents:
@	R1: Contains the string
@	R2: Contains the index
@	LR: Contains return address
@
@ Returned register contents:
@ 	R0: Returns with the character from the string
@
@ All required AAPC registers are preserved, as well as R1 through R3

	.global 	String_charAt

String_charAt:
	push 	{R4-R8, R10-R11}
	push	{SP}
	push	{R1-R3, LR}

	bl	String_length2		@ Get the length of r0
	mov	r3, r0

	cmp	r2, r3
	bhs	bad_index4		@ If index >= length then branch to bad index

	ldrb	r0, [r1, r2]
	b	return4

bad_index4:
	bl	String_set_ovfl
	mov	r0, #0

return4:
	pop	{R1-R3, LR}
	pop	{SP}
	pop 	{R4-R8, R10-R11}
	bx	LR


@ Subroutine String_startsWith_1: This method checks if a string starts with a given substring starting at a
@				  given index
@
@ Entering register contents:
@	R1: Contains the string
@	R2: Contains the substring
@	R3: Contains the starting index
@	LR: Contains return address
@
@ Returned register contents:
@ 	R0: Returns with the boolean
@
@ All required AAPC registers are preserved, as well as R1 through R3

	.global 	String_startsWith_1

String_startsWith_1:
	push 	{R4-R8, R10-R11}
	
	push	{SP}
	push	{R1-R3, LR}

	bl	String_length2
	mov	r4, r0

	cmp	r3, r4
	bhs	bad_index5		@ If startIndex >= length, then branch to bad index

	add	r1, r3			@ Start the string at the starting index
	mov	r5, #0
	
loop5:
	ldrb	r0, [r1]

	cmp	r0, #0
	beq	return5			@ If R0 equals null return

	bl	String_startsWith_2	@ Checks if r0 starts with substring or not
	
	cmp	r0, #1
	beq	return5			@ If found, return

	add	r1, #1
	b	loop5

bad_index5:
	bl	String_set_ovfl
	mov	r0, #0

return5:
	pop	{R1-R3, LR}
	pop	{SP}
	pop 	{R4-R8, R10-R11}
	bx	LR


@ Subroutine String_startsWith_2: This method checks if a string starts with a given substring
@
@ Entering register contents:
@	R1: Contains the string
@	R2: Contains the substring
@	LR: Contains return address
@
@ Returned register contents:
@ 	R0: Returns with the boolean
@
@ All required AAPC registers are preserved, as well as R1 through R3

	.global 	String_startsWith_2

String_startsWith_2:
	push 	{R4-R8, R10-R11}
	
	push	{SP}
	push	{R1-R3, LR}

	mov	r0, #0			@ Initialize r0

loop6:
	ldrb	r3, [r1], #1
	ldrb	r4, [r2], #1

	cmp	r4, #0
	moveq	r0, #1			@ If char2 equals null, then return
	beq	return6

	cmp	r3, #0
	beq	return6			@ If char1 equals null, then return

	cmp	r3, r4
	bne	return6			@ If char1 does not equal char2, then return

	b	loop6

return6:
	pop	{R1-R3, LR}
	pop	{SP}
	pop 	{R4-R8, R10-R11}
	bx	LR


@ Subroutine String_endsWith: This method checks whether a string contains a substring that is equal to another
@			      string, at the end
@
@ Entering register contents:
@	R1: Contains the string
@	R2: Contains the substring
@	LR: Contains return address
@
@ Returned register contents:
@ 	R0: Returns with the boolean
@
@ All required AAPC registers are preserved, as well as R1 through R3

	.global 	String_endsWith

String_endsWith:
	push 	{R4-R8, R10-R11}
	
	push	{SP}
	push	{R1-R3, LR}

	bl	String_length2			@ Gets the string length into r0
	mov	r3, r0
	push	{r1}				@ Saves the string

	mov	r1, r2
	bl	String_length2
	mov	r4, r0
	pop	{r1}				@ Loads the string

	cmp	r4, r3
	movhi	r0, #0				@ If substrLength > stringLength, then return false
	bhi	return7
	
	sub	r3, r4				@ R3 equals stringLength - substrLength
	bl	String_startsWith_1		@ Calls String_startsWith_1, to get result into r0

return7:
	pop	{R1-R3, LR}
	pop	{SP}
	pop 	{R4-R8, R10-R11}
	bx	LR


@ HELPER FUNCTIONS BELOW @

@ Subroutine String_set_ovfl: This method sets the overflow flag
@
@ Entering register contents:
@	None
@
@ Returned register contents:
@ 	None
@
@ All required AAPC registers are preserved, as well as r0

	.global 	String_set_ovfl

String_set_ovfl:
	push 	{R4-R8, R10-R11}
	
	push	{SP}
	push	{R0}

	mov	R0, #0x80000000		@ MSB = 1
	subs	R0, #1			@ MSB = 0 -> C = 1, V = 1
	mov	R0, #0x10
	asrs	R0, #1			@ R0 = 0x1 -> C = 0, V unchanged

	pop	{R0}
	pop	{SP}
	pop 	{R4-R8, R10-R11}
	bx	LR


@ Subroutine String_malloc: This method allocates enough space for a string given the size needed and returns
@			    the address
@
@ Entering register contents:
@	R0: Contains the string length
@
@ Returned register contents:
@ 	R0: Returns the address
@
@ All required AAPC registers are preserved, as well as R1 through R3 and r12

	.extern		malloc
	.global 	String_malloc

String_malloc:
	push 	{R4-R8, R10-R11}
	push	{SP}
	push	{R1-R3, R12, LR}

	add	R0, #1			@ Reserve space for null
	bl	malloc

	pop	{R1-R3, R12, LR}
	pop	{SP}
	pop 	{R4-R8, R10-R11}
	bx	LR


@ Subroutine String_toLowerCase: This method allocates enough space for a string given the size needed and returns
@			    the address
@
@ Entering register contents:
@	R1: Contains the string
@
@ Returned register contents:
@ 	R1: Returns the new lowercased string
@
@ All required AAPC registers are preserved, as well as R0 and R1

	.global 	String_toLowerCase

String_toLowerCase:
	push 	{R4-R8, R10-R11}
	
	push	{SP}
	push	{R0, R1, LR}

loop8:
	ldrb	r0, [r1]
	
	cmp	r0, #0x0	@ Check if the character is a null
	beq	return8

	cmp	r0, #'A'	
	blt	storing_char

	cmp	r0, #'Z'
	bgt	storing_char

	add	r0, #0x20	@ Capital and lowercased letters are offset by 0x20

storing_char:
	strb	r0, [r1]
	add	r1, #1
	b	loop8

return8:
	pop	{R0, R1, LR}
	pop	{SP}
	pop 	{R4-R8, R10-R11}
	bx	LR
.end
