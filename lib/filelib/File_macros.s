@ Subroutine open_file: This method opens a file that is given
@
@ Entering register contents:
@	R1: File name string
@	R2: File flags
@	LR: Contains return address
@
@ Returned register contents:
@ 	R0: Returns with file handle
@
@ All required AAPC registers are preserved

	.global	 open_file
	
open_file:
	push	{R1-R2, R4-R8, R10-R11, LR}
	//push {sp}

	mov		R0,R1		@ Move file name into r0
	mov		R1,R2		@ Move file code into r2
	mov		R2,#0666	@ Allow access to all groups
	mov		R7,#5		@ Code # to open file
	svc		0

	//pop {sp}
	pop		{R1-R2, R4-R8, R10-R11, LR}
	bx		LR
	

@ Subroutine close_file: This method closes a file that is given
@
@ Entering register contents:
@	R0: File handle
@	LR: Contains return address
@
@ Returned register contents:
@ 	N/A
@
@ All required AAPC registers are preserved

	.global 	close_file
	
close_file:
	push	{R4-R8, R10-R11, LR}
	//push {sp}

	mov		R7, #6
	svc		0
	
	//pop {sp}
	pop		{R4-R8, R10-R11, LR}
	bx		LR


@ Subroutine write_to_file: This method will write a string out to a specific file
@
@ Entering register contents:
@	R0: Contains the File handle
@	R1: Contains the string to be output
@	LR: Contains return address
@
@ Returned register contents:
@ 	N/A
@
@ All required AAPC registers are preserved

	.global 	write_to_file
	
write_to_file:
	push	{R0-R8, R10- R11, LR}
	//push {sp}

	push	{R0}		@ Save the file handle
	bl		String_length
	mov		R2, R0

	mov		R7, #4
	pop		{R0}		@ Load back in the file handle
	svc		0
	
	//pop {sp}
	pop		{R0-R8, R10- R11, LR}
	bx		LR


@ Subroutine read_char: This method reads a character from a given file
@
@ Entering register contents:
@	R0: File handle
@	LR: Contains return address
@
@ Returned register contents:
@ 	R1: Returns with the character that was read
@   R2: Returns Boolean depending if the end of file has been reached
@
@ All required AAPC registers are preserved

	.data
char:	 .space 1

	.text
	.global 	read_char

read_char:
	push	{R0, R4-R8, R10-R11, LR}
	//push {sp}

	ldr		R1, =char	@ Points to where chracter will be stored
	mov		R2, #1		@ # of bytes being read
	mov		R7, #3		@ Read File code #
	svc		0

	cmp		R0, #0		@ Compared bytes read, to 0
	beq		end_of_file @ If it equals 0 then we reached end of file

	mov		R2, #0		@ Else, we have not reached the end

	ldrb	R1,[R1]		@ Loads a character from address
	b		return

end_of_file:
	mov		R1, #0		@ Return character is null
	mov		R2, #1		@ Returns true for end of file
	b		return

return:
	//pop {sp}
	pop		{R0, R4-R8, R10-R11, LR}
	bx		LR


@ Subroutine read_line: This method reads in a line from a file
@
@ Entering register contents:
@	R1: File handle
@	LR: Contains return address
@
@ Returned register contents:
@ 	R1: String (file line that is read)
@	R2: Returns Boolean if the end of file has been reached
@
@ All required AAPC registers are preserved

	.data
strBuf: .space 256

	.text
	.global 	read_line
	
read_line:
	push	{R0, R3-R8, R10-R11, LR}
	//push {sp}

	ldr		R3, =strBuf		@ Point r3 to strBuf
	mov		R5, #0			@ Store null into r5

loop:
	push	{R3}			@ Store strBuf

	bl		read_char

	cmp		R2, #1
	beq		end_of_file1	@ Checks to see if end of file has been reached

	pop		{R3}			@ Load back in strBuf

	cmp		R1, #'\r'
	beq		carriage_found	@ If char == \r line is done

	cmp		R1, #'\n'
	beq		end_line_found	@ If char == \n line is done

	cmp		R4, #255
	beq		end_line_found	@ If bufCount == 255 line is done

	strb	R1, [R3], #1	@ Store the char into buffer and offset ptr
	add		R4, #1

	b		loop

carriage_found:
	bl		read_char	@ Caridge is always followed by a \n
	b		end_line_found

end_line_found:
	strb	R5,[R3]			@ Store a null terminator to the end of the string
	b		make_string

make_string:
	ldr		R3, =strBuf
	mov		R1, R3
	bl		String_copy		@ Creates copy of the string
	mov		R1, R0			@ Return copy of string into r1
	b		return1

end_of_file1:
	pop		{R3}
	b		return1

return1:
	//push {sp}
	push	{R0, R3-R8, R10-R11, LR}
	bx		LR
	

@ Subroutine load_list_from_file: This method loads a list from a given file
@
@ Entering register contents:
@	R1: List
@	LR: File name
@
@ Returned register contents:
@ 	N/A
@
@ All required AAPC registers are preserved
	
	.global 	load_list_from_file
	
load_list_from_file:
	push	{R0-R2, R4-R8, R10- R11, LR}
	//push {sp}

loop1:
	push	{R1}		@ Save the list
	//bl		File_readLine

	cmp		R2,#1
	popeq	{R1}		@ If its the end of the file, we load list
	beq		loop_exit	@ If its the end of the file, we exit loop
	
	push	{R0}		@ Save the file handle
	bl		String_copy	@ Will return string copy into r0
	mov		R2,R0		@ Store the string copy into r2
	pop		{R0}		@ Load back the file handle

	pop		{R1}		@ Load back the list
	mov		R0, R1		@ Move list into r0
	mov		R1, R2		@ Move the string into r1
	bl		List_addstr	@ Must contain r0 = list, r1 = string
	mov		R2, R1		@ Put string back into r2
	mov		R1, R0		@ Put list back into r1

	b		loop1

loop_exit:
	//pop {sp}
	pop		{R0-R2, R4-R8, R10- R11, LR}
	bx		LR
	

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
@ All required AAPC registers are preserved

	// NOTE - already defined in String.a
	//.global 	String_copy

String_copy:
	push 	{R4-R8, R10-R11}
	//push {sp}
	push	{R1, R2, LR}

	bl		String_length	@ Calls string length and returns the length into r0
	bl		String_malloc	@ Creates a new dynamic string to store copy
	push	{r0}			@ Saves the new string

loop2:
	ldrb	r2, [r1], #1	@ Loads 1 character from r1 to new string r2
	
	cmp		r2, #0			@ Compares r2 with 0	
	beq		return2			@ If the character in r2 equals 0, then returns
	
	strb	r2, [r0], #1 	@ Stores the charcter from r2 into our new string r0
	b		loop2			@ Branches back to top of loop

return2:
	pop		{r0}			@ Loads the new copied string to be returned
	pop		{R1, R2, LR}
	//pop {sp}
	pop 	{R4-R8, R10-R11}
	bx		LR
	
	
@ Subroutine String_length: This method returns the number os characters in a string
@
@ Entering register contents:
@	R1: Contains the string
@	LR: Contains return address
@
@ Returned register contents:
@ 	R0: Returns with the length
@
@ All required AAPC registers are preserved

	// NOTE - already defined in String.a
	//.global 	String_length

String_length:
	push 	{R4-R8, R10-R11}
	//push {sp}
	push	{R1, R2, LR}	@ Saves all registers

	mov		r0, #0		@ Initialize counter

loop3:
	ldrb	r2, [r1], #1

	cmp		r2, #0
	beq		return3		@ If char equals null then return

	add		r0, #1
	b		loop3

return3:
	pop		{R1, R2, LR}
	//pop {sp}
	pop 	{R4-R8, R10-R11} @ Restores all registers

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
@ All required AAPC registers are preserved

	.extern		malloc
	// NOTE - already defined in String.a
	//.global 	String_malloc

String_malloc:
	push 	{R4-R8, R10-R11}
	//push {sp}
	push	{R1-R3, R12, LR}

	add		R0, #1	@ Reserve space for null
	bl		malloc

	pop		{R1-R3, R12, LR}
	//pop {sp}
	pop 	{R4-R8, R10-R11}
	bx	LR
